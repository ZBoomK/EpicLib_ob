local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1555 - (991 + 564);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((4294 - (1381 + 178)) >= (4184 + 276))) then
			return v6(...);
		end
		if (((2341 + 562) >= (638 + 857)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((2356 + 2190) >= (2745 - (381 + 89))) and not v6) then
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
	local v95;
	local v96;
	local v97;
	local v98;
	local v99 = v21.Commons.Everyone;
	local v100 = v19.Paladin.Retribution;
	local v101 = v20.Paladin.Retribution;
	local v102 = {};
	local function v103()
		if (((554 + 265) >= (37 - 15)) and v100.CleanseToxins:IsAvailable()) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 12267 - (1074 + 82);
	local v108 = 24349 - 13238;
	local v109;
	local v110 = 1784 - (214 + 1570);
	local v111 = 1455 - (990 + 465);
	local v112;
	v10:RegisterForEvent(function()
		v107 = 4581 + 6530;
		v108 = 4835 + 6276;
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v129 = v15:GCDRemains();
		local v130 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (10 + 0), v100.WakeofAshes:CooldownRemains());
		if (((12443 - 9281) == (4888 - (1668 + 58))) and (v129 > v130)) then
			return v129;
		end
		return v130;
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 626 - (512 + 114);
	local function v116()
		if ((v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(65 - 40) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) or ((4897 - 2528) > (15411 - 10982))) then
			if (((1906 + 2189) >= (596 + 2587)) and (v115 == (0 + 0))) then
				v115 = GetTime();
			end
			if (v99.Wait(1686 - 1186, v115) or ((5705 - (109 + 1885)) < (2477 - (1269 + 200)))) then
				local v199 = 0 - 0;
				while true do
					if ((v199 == (815 - (98 + 717))) or ((1875 - (802 + 24)) <= (1562 - 656))) then
						if (((5699 - 1186) > (403 + 2323)) and v25(v104.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v115 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((244 + 1237) >= (574 + 2084))) then
			if (v100.FlashofLight:IsReady() or ((8957 - 5737) == (4548 - 3184))) then
				if (v25(v100.FlashofLight) or ((377 + 677) > (1381 + 2011))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		if (v16:Exists() or ((558 + 118) >= (1194 + 448))) then
			if (((1932 + 2204) > (3830 - (797 + 636))) and v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) then
				if (v25(v104.WordofGloryMouseover) or ((21043 - 16709) == (5864 - (1427 + 192)))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(11 + 19) or ((9927 - 5651) <= (2725 + 306))) then
			return;
		end
		if (v14 or ((2168 + 2614) <= (1525 - (192 + 134)))) then
			if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((6140 - (316 + 960)) < (1059 + 843))) then
				if (((3735 + 1104) >= (3420 + 280)) and v25(v104.WordofGloryFocus)) then
					return "word_of_glory defensive focus";
				end
			end
			if ((v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) or ((4109 - 3034) > (2469 - (83 + 468)))) then
				if (((2202 - (1202 + 604)) <= (17757 - 13953)) and v25(v104.LayonHandsFocus)) then
					return "lay_on_hands defensive focus";
				end
			end
			if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((6938 - 2769) == (6055 - 3868))) then
				if (((1731 - (45 + 280)) == (1358 + 48)) and v25(v104.BlessingofSacrificeFocus)) then
					return "blessing_of_sacrifice defensive focus";
				end
			end
			if (((1338 + 193) < (1560 + 2711)) and v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
				if (((352 + 283) == (112 + 523)) and v25(v104.BlessingofProtectionFocus)) then
					return "blessing_of_protection defensive focus";
				end
			end
		end
	end
	local function v119()
		v30 = v99.HandleTopTrinket(v102, v33, 74 - 34, nil);
		if (((5284 - (340 + 1571)) <= (1403 + 2153)) and v30) then
			return v30;
		end
		v30 = v99.HandleBottomTrinket(v102, v33, 1812 - (1733 + 39), nil);
		if (v30 or ((9043 - 5752) < (4314 - (125 + 909)))) then
			return v30;
		end
	end
	local function v120()
		local v131 = 1948 - (1096 + 852);
		while true do
			if (((1968 + 2418) >= (1245 - 372)) and (v131 == (2 + 0))) then
				if (((1433 - (409 + 103)) <= (1338 - (46 + 190))) and v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (99 - (51 + 44)))) then
					if (((1328 + 3378) >= (2280 - (1114 + 203))) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37) or ((1686 - (228 + 498)) <= (190 + 686))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1142 + 924) == (1595 - (174 + 489)))) then
						return "blade_of_justice precombat 5";
					end
				end
				v131 = 7 - 4;
			end
			if (((6730 - (830 + 1075)) < (5367 - (303 + 221))) and (v131 == (1269 - (231 + 1038)))) then
				if ((v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) or ((3231 + 646) >= (5699 - (171 + 991)))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(32 - 24)) or ((11586 - 7271) < (4307 - 2581))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((2945 + 734) < (2190 - 1565))) then
					if (v25(v100.ShieldofVengeance, not v17:IsInRange(22 - 14)) or ((7455 - 2830) < (1953 - 1321))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v131 = 1249 - (111 + 1137);
			end
			if ((v131 == (161 - (91 + 67))) or ((247 - 164) > (445 + 1335))) then
				if (((1069 - (423 + 100)) <= (8 + 1069)) and v100.Judgment:IsCastable() and v45) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2757 - 1761) > (2242 + 2059))) then
						return "judgment precombat 6";
					end
				end
				if (((4841 - (326 + 445)) > (2997 - 2310)) and v100.HammerofWrath:IsReady() and v44) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((1460 - 804) >= (7772 - 4442))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v131 = 715 - (530 + 181);
			end
			if ((v131 == (885 - (614 + 267))) or ((2524 - (19 + 13)) <= (544 - 209))) then
				if (((10071 - 5749) >= (7318 - 4756)) and v100.CrusaderStrike:IsCastable() and v39) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((945 + 2692) >= (6630 - 2860))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v131 == (1 - 0)) or ((4191 - (1293 + 519)) > (9340 - 4762))) then
				if ((v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (9 - 5))) or ((923 - 440) > (3203 - 2460))) then
					if (((5780 - 3326) > (307 + 271)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((190 + 740) < (10357 - 5899)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (1 + 3))) then
					if (((220 + 442) <= (608 + 364)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v131 = 1098 - (709 + 387);
			end
		end
	end
	local function v121()
		local v132 = 1858 - (673 + 1185);
		local v133;
		while true do
			if (((12673 - 8303) == (14032 - 9662)) and ((1 - 0) == v132)) then
				if ((v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) or ((3407 + 1355) <= (644 + 217))) then
					if (v25(v100.LightsJudgment, not v17:IsInRange(54 - 14)) or ((347 + 1065) == (8501 - 4237))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (19 - 9))))) or ((5048 - (446 + 1434)) < (3436 - (1040 + 243)))) then
					if (v25(v100.Fireblood, not v17:IsInRange(29 - 19)) or ((6823 - (559 + 1288)) < (3263 - (609 + 1322)))) then
						return "fireblood cooldowns 6";
					end
				end
				v132 = 456 - (13 + 441);
			end
			if (((17293 - 12665) == (12122 - 7494)) and (v132 == (19 - 15))) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (1 + 4)) and (v10.CombatTime() < (18 - 13))) or ((v110 >= (2 + 1)) and (v10.CombatTime() > (3 + 2))))) or ((160 - 106) == (217 + 178))) then
					if (((150 - 68) == (55 + 27)) and v25(v100.Crusade, not v17:IsInRange(6 + 4))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (7 + 1))) or ((v110 >= (3 + 0)) and (v10.CombatTime() >= (441 - (153 + 280)))) or ((v110 >= (5 - 3)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (9 + 1)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (4 + 6))))) and ((v109 > (0 + 0)) or (v110 == (5 + 0)) or ((v110 >= (2 + 0)) and v100.DivineAuxiliary:IsAvailable()))) or ((884 - 303) < (175 + 107))) then
					local v202 = 667 - (89 + 578);
					while true do
						if ((v202 == (0 + 0)) or ((9581 - 4972) < (3544 - (572 + 477)))) then
							if (((156 + 996) == (692 + 460)) and (v98 == "player")) then
								if (((227 + 1669) <= (3508 - (84 + 2))) and v25(v104.FinalReckoningPlayer, not v17:IsInRange(16 - 6))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v98 == "cursor") or ((714 + 276) > (2462 - (497 + 345)))) then
								if (v25(v104.FinalReckoningCursor, not v17:IsInRange(1 + 19)) or ((149 + 728) > (6028 - (605 + 728)))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1920 + 771) >= (4115 - 2264)) and (v132 == (1 + 1))) then
				if ((v87 and ((v33 and v88) or not v88) and v17:IsInRange(29 - 21)) or ((2691 + 294) >= (13453 - 8597))) then
					v30 = v119();
					if (((3229 + 1047) >= (1684 - (457 + 32))) and v30) then
						return v30;
					end
				end
				if (((1372 + 1860) <= (6092 - (832 + 570))) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (15 + 0)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
					if (v25(v100.ShieldofVengeance) or ((234 + 662) >= (11132 - 7986))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v132 = 2 + 1;
			end
			if (((3857 - (588 + 208)) >= (7972 - 5014)) and (v132 == (1800 - (884 + 916)))) then
				v133 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (20 - 10))) or (v108 < (15 + 10)));
				if (((3840 - (232 + 421)) >= (2533 - (1569 + 320))) and v133) then
					return v133;
				end
				v132 = 1 + 0;
			end
			if (((123 + 521) <= (2372 - 1668)) and ((608 - (316 + 289)) == v132)) then
				if (((2507 - 1549) > (44 + 903)) and v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (1468 - (666 + 787)))) or (v15:BuffStack(v100.CrusadeBuff) == (435 - (360 + 65))) or (v100.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v100.AvengingWrath:CooldownRemains() > (269 - (79 + 175)))) and (((v110 >= (5 - 1)) and (v10.CombatTime() < (4 + 1))) or ((v110 >= (8 - 5)) and (v10.CombatTime() > (9 - 4))) or ((v110 >= (901 - (503 + 396))) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (189 - (92 + 89))) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (22 - 10)))) then
					if (((2304 + 2188) >= (1571 + 1083)) and v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((13479 - 10037) >= (206 + 1297)) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (8 - 4)) and (v10.CombatTime() < (5 + 0))) or ((v110 >= (2 + 1)) and (v10.CombatTime() > (15 - 10))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v100.ExecutionSentence:CooldownRemains() > (1259 - (485 + 759))) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (0 - 0)) or (v100.FinalReckoning:CooldownRemains() > (1219 - (442 + 747))) or not v100.FinalReckoning:IsReady())))))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(1145 - (832 + 303))) or ((4116 - (88 + 858)) <= (447 + 1017))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v132 = 4 + 0;
			end
		end
	end
	local function v122()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (790 - (766 + 23))) or ((23681 - 18884) == (6000 - 1612))) then
				if (((1451 - 900) <= (2311 - 1630)) and v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1076 - (1036 + 37)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (8 + 2))))) then
					if (((6381 - 3104) > (321 + 86)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((6175 - (641 + 839)) >= (2328 - (910 + 3))) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (7 - 4))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1694 - (1466 + 218)))))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((1477 + 1735) <= (2092 - (556 + 592)))) then
						return "final verdict finishers 6";
					end
				end
				v134 = 1 + 1;
			end
			if ((v134 == (810 - (329 + 479))) or ((3950 - (174 + 680)) <= (6177 - 4379))) then
				if (((7331 - 3794) == (2526 + 1011)) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (742 - (396 + 343)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) then
					if (((5314 - (29 + 1448)) >= (2959 - (135 + 1254))) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v134 == (0 - 0)) or ((13773 - 10823) == (2541 + 1271))) then
				v112 = ((v106 >= (1530 - (389 + 1138))) or ((v106 >= (576 - (102 + 472))) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (23 + 1)));
				if (((2620 + 2103) >= (2162 + 156)) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1548 - (320 + 1225)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (17 - 7))))) then
					if (v25(v100.DivineStorm, not v17:IsInRange(7 + 3)) or ((3491 - (157 + 1307)) > (4711 - (821 + 1038)))) then
						return "divine_storm finishers 2";
					end
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v123()
		if ((v110 >= (1 + 4)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(54 - 23, 2 + 2) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (9 - 5))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(1057 - (834 + 192), 1 + 1)) or ((292 + 844) > (93 + 4224))) then
			local v178 = 0 - 0;
			while true do
				if (((5052 - (300 + 4)) == (1269 + 3479)) and (v178 == (0 - 0))) then
					v30 = v122();
					if (((4098 - (112 + 250)) <= (1890 + 2850)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (7 - 4)) and v15:HasTier(18 + 13, 2 + 0)) or ((2536 + 854) <= (1518 + 1542))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((743 + 256) > (4107 - (1001 + 413)))) then
				return "blade_of_justice generators 1";
			end
		end
		if (((1032 - 569) < (1483 - (244 + 638))) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (695 - (627 + 66))) and ((v100.AvengingWrath:CooldownRemains() > (0 - 0)) or (v100.Crusade:CooldownRemains() > (602 - (512 + 90))) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (1910 - (1665 + 241))) or (v108 < (725 - (373 + 344))) or not v100.ExecutionSentence:IsReady())) then
			if (v25(v100.WakeofAshes, not v17:IsInRange(5 + 5)) or ((578 + 1605) < (1812 - 1125))) then
				return "wake_of_ashes generators 2";
			end
		end
		if (((7697 - 3148) == (5648 - (35 + 1064))) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (3 + 0)) and v15:HasTier(66 - 35, 1 + 1)) then
			if (((5908 - (298 + 938)) == (5931 - (233 + 1026))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 4";
			end
		end
		if ((v100.DivineToll:IsCastable() and v42 and (v110 <= (1668 - (636 + 1030))) and ((v100.AvengingWrath:CooldownRemains() > (8 + 7)) or (v100.Crusade:CooldownRemains() > (15 + 0)) or (v108 < (3 + 5)))) or ((248 + 3420) < (616 - (55 + 166)))) then
			if (v25(v100.DivineToll, not v17:IsInRange(6 + 24)) or ((419 + 3747) == (1737 - 1282))) then
				return "divine_toll generators 6";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(328 - (36 + 261), 3 - 1)) or ((5817 - (34 + 1334)) == (1024 + 1639))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((3324 + 953) < (4272 - (1035 + 248)))) then
				return "judgment generators 7";
			end
		end
		if (((v110 >= (24 - (20 + 1))) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (6 + 4))) or ((1189 - (134 + 185)) >= (5282 - (549 + 584)))) then
			local v179 = 685 - (314 + 371);
			while true do
				if (((7593 - 5381) < (4151 - (478 + 490))) and (v179 == (0 + 0))) then
					v30 = v122();
					if (((5818 - (786 + 386)) > (9690 - 6698)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((2813 - (1055 + 324)) < (4446 - (1093 + 247))) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (4 + 0)) and (v106 >= (1 + 1))) then
			if (((3120 - 2334) < (10259 - 7236)) and v25(v100.TemplarSlash, not v17:IsInRange(28 - 18))) then
				return "templar_slash generators 8";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (7 - 4)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (1 + 1)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (15 - 11)))) or ((8416 - 5974) < (56 + 18))) then
			if (((11597 - 7062) == (5223 - (364 + 324))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 10";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (5 - 3)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(71 - 41, 2 + 2)) and ((v110 <= (12 - 9)) or (v17:HealthPercentage() > (32 - 12)) or not v100.VanguardsMomentum:IsAvailable())) or ((9138 - 6129) <= (3373 - (1249 + 19)))) then
			if (((1652 + 178) < (14281 - 10612)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (1090 - (686 + 400)))) or ((1122 + 308) >= (3841 - (73 + 156)))) then
			if (((13 + 2670) >= (3271 - (721 + 90))) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
				return "templar_slash generators 14";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (1 + 2)) or not v100.BoundlessJudgment:IsAvailable())) or ((5857 - 4053) >= (3745 - (224 + 246)))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2295 - 878) > (6681 - 3052))) then
				return "judgment generators 16";
			end
		end
		if (((870 + 3925) > (10 + 392)) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (3 + 0)) or not v100.HolyBlade:IsAvailable())) then
			if (((9568 - 4755) > (11863 - 8298)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((4425 - (203 + 310)) == (5905 - (1238 + 755))) and ((v17:HealthPercentage() <= (2 + 18)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
			v30 = v122();
			if (((4355 - (709 + 825)) <= (8889 - 4065)) and v30) then
				return v30;
			end
		end
		if (((2531 - 793) <= (3059 - (196 + 668))) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (7 - 5))) then
			if (((84 - 43) <= (3851 - (171 + 662))) and v25(v100.Consecration, not v17:IsInRange(103 - (4 + 89)))) then
				return "consecration generators 22";
			end
		end
		if (((7517 - 5372) <= (1495 + 2609)) and v100.DivineHammer:IsCastable() and v40 and (v106 >= (8 - 6))) then
			if (((1055 + 1634) < (6331 - (35 + 1451))) and v25(v100.DivineHammer, not v17:IsInRange(1463 - (28 + 1425)))) then
				return "divine_hammer generators 24";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1994.75 - (941 + 1052))) and ((v110 <= (2 + 0)) or ((v110 <= (1517 - (822 + 692))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (2 - 0)))) or ((v110 == (2 + 2)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (299 - (45 + 252)))) and (v100.Judgment:CooldownRemains() > (v111 * (2 + 0)))))) or ((800 + 1522) > (6380 - 3758))) then
			if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((4967 - (114 + 319)) == (2988 - 906))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v122();
		if (v30 or ((2012 - 441) > (1191 + 676))) then
			return v30;
		end
		if ((v100.TemplarSlash:IsReady() and v47) or ((3953 - 1299) >= (6277 - 3281))) then
			if (((5941 - (556 + 1407)) > (3310 - (741 + 465))) and v25(v100.TemplarSlash, not v17:IsInRange(475 - (170 + 295)))) then
				return "templar_slash generators 28";
			end
		end
		if (((1579 + 1416) > (1416 + 125)) and v100.TemplarStrike:IsReady() and v48) then
			if (((7998 - 4749) > (791 + 162)) and v25(v100.TemplarStrike, not v17:IsInRange(7 + 3))) then
				return "templar_strike generators 30";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and ((v110 <= (2 + 1)) or not v100.BoundlessJudgment:IsAvailable())) or ((4503 - (957 + 273)) > (1224 + 3349))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((1262 + 1889) < (4892 - 3608))) then
				return "judgment generators 32";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44 and ((v110 <= (7 - 4)) or (v17:HealthPercentage() > (61 - 41)) or not v100.VanguardsMomentum:IsAvailable())) or ((9160 - 7310) == (3309 - (389 + 1391)))) then
			if (((516 + 305) < (221 + 1902)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if (((2053 - 1151) < (3276 - (783 + 168))) and v100.CrusaderStrike:IsCastable() and v39) then
			if (((2879 - 2021) <= (2914 + 48)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (316 - (309 + 2))) and (v86 < v108)) or ((12117 - 8171) < (2500 - (1090 + 122)))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(4 + 6)) or ((10888 - 7646) == (389 + 178))) then
				return "arcane_torrent generators 28";
			end
		end
		if ((v100.Consecration:IsCastable() and v38) or ((1965 - (628 + 490)) >= (227 + 1036))) then
			if (v25(v100.Consecration, not v17:IsInRange(24 - 14)) or ((10296 - 8043) == (2625 - (431 + 343)))) then
				return "consecration generators 30";
			end
		end
		if ((v100.DivineHammer:IsCastable() and v40) or ((4214 - 2127) > (6861 - 4489))) then
			if (v25(v100.DivineHammer, not v17:IsInRange(8 + 2)) or ((569 + 3876) < (5844 - (556 + 1139)))) then
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
		v69 = EpicSettings.Settings['divineProtectionHP'] or (15 - (6 + 9));
		v70 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
		v71 = EpicSettings.Settings['layonHandsHP'] or (0 + 0);
		v72 = EpicSettings.Settings['layonHandsFocusHP'] or (169 - (28 + 141));
		v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (1317 - (486 + 831));
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v126()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (3 - 2)) or ((344 + 1474) == (268 - 183))) then
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v171 = 1265 - (668 + 595);
			end
			if (((567 + 63) < (429 + 1698)) and (v171 == (5 - 3))) then
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v171 = 293 - (23 + 267);
			end
			if ((v171 == (1947 - (1129 + 815))) or ((2325 - (371 + 16)) == (4264 - (1326 + 424)))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v81 = EpicSettings.Settings['handleAfflicted'];
				v171 = 122 - (88 + 30);
			end
			if (((5026 - (720 + 51)) >= (122 - 67)) and (v171 == (1780 - (421 + 1355)))) then
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((1474 + 1525) > (2239 - (286 + 797))) and (v171 == (0 - 0))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v171 = 440 - (397 + 42);
			end
		end
	end
	local function v127()
		v125();
		v124();
		v126();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (((734 + 1616) > (1955 - (24 + 776))) and v15:IsDeadOrGhost()) then
			return v30;
		end
		v105 = v15:GetEnemiesInMeleeRange(12 - 4);
		if (((4814 - (222 + 563)) <= (10692 - 5839)) and v32) then
			v106 = #v105;
		else
			local v180 = 0 + 0;
			while true do
				if ((v180 == (190 - (23 + 167))) or ((2314 - (690 + 1108)) > (1239 + 2195))) then
					v105 = {};
					v106 = 1 + 0;
					break;
				end
			end
		end
		if (((4894 - (40 + 808)) >= (500 + 2533)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) or ((10397 - 7678) <= (1384 + 63))) then
				if (v25(v100.CrusaderAura) or ((2187 + 1947) < (2153 + 1773))) then
					return "crusader_aura";
				end
			end
		end
		v109 = v113();
		if (not v15:AffectingCombat() or ((735 - (47 + 524)) >= (1808 + 977))) then
			if ((v100.RetributionAura:IsCastable() and (v114()) and v35) or ((1435 - 910) == (3153 - 1044))) then
				if (((74 - 41) == (1759 - (1165 + 561))) and v25(v100.RetributionAura)) then
					return "retribution_aura";
				end
			end
		end
		if (((91 + 2963) <= (12435 - 8420)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (((714 + 1157) < (3861 - (341 + 138))) and v15:AffectingCombat()) then
				if (((350 + 943) <= (4469 - 2303)) and v100.Intercession:IsCastable()) then
					if (v25(v100.Intercession, not v17:IsInRange(356 - (89 + 237)), true) or ((8296 - 5717) < (258 - 135))) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((1727 - (581 + 300)) >= (3588 - (855 + 365)))) then
				if (v25(v100.Redemption, not v17:IsInRange(71 - 41), true) or ((1310 + 2702) <= (4593 - (1030 + 205)))) then
					return "redemption target";
				end
			end
		end
		if (((1403 + 91) <= (2796 + 209)) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v104.RedemptionMouseover) or ((3397 - (156 + 130)) == (4848 - 2714))) then
				return "redemption mouseover";
			end
		end
		if (((3969 - 1614) == (4823 - 2468)) and v15:AffectingCombat()) then
			if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (1 + 2)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((343 + 245) <= (501 - (10 + 59)))) then
				if (((1357 + 3440) >= (19181 - 15286)) and v25(v104.IntercessionMouseover)) then
					return "Intercession mouseover";
				end
			end
		end
		if (((4740 - (671 + 492)) == (2848 + 729)) and (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()))) then
			local v181 = v80 and v100.CleanseToxins:IsReady() and v34;
			v30 = v99.FocusUnit(v181, nil, 1235 - (369 + 846), nil, 7 + 18, v100.FlashofLight);
			if (((3238 + 556) > (5638 - (1036 + 909))) and v30) then
				return v30;
			end
		end
		if (v34 or ((1014 + 261) == (6883 - 2783))) then
			v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 243 - (11 + 192), 13 + 12, v100.FlashofLight);
			if (v30 or ((1766 - (135 + 40)) >= (8673 - 5093))) then
				return v30;
			end
			if (((593 + 390) <= (3982 - 2174)) and v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
				if (v25(v104.BlessingofFreedomFocus) or ((3223 - 1073) <= (1373 - (50 + 126)))) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((10494 - 6725) >= (260 + 913)) and (v99.TargetIsValid() or v15:AffectingCombat())) then
			v107 = v10.BossFightRemains(nil, true);
			v108 = v107;
			if (((2898 - (1233 + 180)) == (2454 - (522 + 447))) and (v108 == (12532 - (107 + 1314)))) then
				v108 = v10.FightRemains(v105, false);
			end
			v111 = v15:GCD();
			v110 = v15:HolyPower();
		end
		if (v81 or ((1539 + 1776) <= (8476 - 5694))) then
			if (v77 or ((373 + 503) >= (5885 - 2921))) then
				local v200 = 0 - 0;
				while true do
					if ((v200 == (1910 - (716 + 1194))) or ((39 + 2193) > (268 + 2229))) then
						v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 543 - (74 + 429));
						if (v30 or ((4070 - 1960) <= (165 + 167))) then
							return v30;
						end
						break;
					end
				end
			end
			if (((8437 - 4751) > (2245 + 927)) and v78 and (v110 > (5 - 3))) then
				local v201 = 0 - 0;
				while true do
					if (((433 - (279 + 154)) == v201) or ((5252 - (454 + 324)) < (646 + 174))) then
						v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 57 - (12 + 5), true);
						if (((2308 + 1971) >= (7343 - 4461)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (v82 or ((750 + 1279) >= (4614 - (277 + 816)))) then
			v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 128 - 98, true);
			if (v30 or ((3220 - (1058 + 125)) >= (871 + 3771))) then
				return v30;
			end
			v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 1005 - (815 + 160), true);
			if (((7379 - 5659) < (10582 - 6124)) and v30) then
				return v30;
			end
		end
		v30 = v117();
		if (v30 or ((105 + 331) > (8830 - 5809))) then
			return v30;
		end
		if (((2611 - (41 + 1857)) <= (2740 - (1222 + 671))) and v80 and v34) then
			local v182 = 0 - 0;
			while true do
				if (((3096 - 942) <= (5213 - (229 + 953))) and ((1774 - (1111 + 663)) == v182)) then
					if (((6194 - (874 + 705)) == (646 + 3969)) and v14) then
						v30 = v116();
						if (v30 or ((2586 + 1204) == (1039 - 539))) then
							return v30;
						end
					end
					if (((3 + 86) < (900 - (642 + 37))) and v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) then
						if (((469 + 1585) >= (228 + 1193)) and v100.CleanseToxins:IsReady()) then
							if (((1737 - 1045) < (3512 - (233 + 221))) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v30 = v118();
		if (v30 or ((7524 - 4270) == (1457 + 198))) then
			return v30;
		end
		if ((not v15:AffectingCombat() and v31 and v99.TargetIsValid()) or ((2837 - (718 + 823)) == (3090 + 1820))) then
			local v183 = 805 - (266 + 539);
			while true do
				if (((9535 - 6167) == (4593 - (636 + 589))) and (v183 == (0 - 0))) then
					v30 = v120();
					if (((5450 - 2807) < (3024 + 791)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((695 + 1218) > (1508 - (657 + 358))) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
			local v184 = 0 - 0;
			while true do
				if (((10833 - 6078) > (4615 - (1151 + 36))) and (v184 == (0 + 0))) then
					if (((364 + 1017) <= (7074 - 4705)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
						if (v25(v100.LayonHands) or ((6675 - (1552 + 280)) == (4918 - (64 + 770)))) then
							return "lay_on_hands_player defensive";
						end
					end
					if (((3170 + 1499) > (823 - 460)) and v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
						if (v25(v100.DivineShield) or ((334 + 1543) >= (4381 - (157 + 1086)))) then
							return "divine_shield defensive";
						end
					end
					v184 = 1 - 0;
				end
				if (((20768 - 16026) >= (5561 - 1935)) and (v184 == (3 - 0))) then
					v30 = v123();
					if (v30 or ((5359 - (599 + 220)) == (1823 - 907))) then
						return v30;
					end
					v184 = 1935 - (1813 + 118);
				end
				if ((v184 == (1 + 0)) or ((2373 - (841 + 376)) > (6087 - 1742))) then
					if (((520 + 1717) < (11597 - 7348)) and v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) then
						if (v25(v100.DivineProtection) or ((3542 - (464 + 395)) < (58 - 35))) then
							return "divine_protection defensive";
						end
					end
					if (((335 + 362) <= (1663 - (467 + 370))) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
						if (((2283 - 1178) <= (864 + 312)) and v25(v104.Healthstone)) then
							return "healthstone defensive";
						end
					end
					v184 = 6 - 4;
				end
				if (((528 + 2851) <= (8868 - 5056)) and (v184 == (522 - (150 + 370)))) then
					if ((v91 and (v15:HealthPercentage() <= v93)) or ((2070 - (74 + 1208)) >= (3974 - 2358))) then
						local v203 = 0 - 0;
						while true do
							if (((1320 + 534) <= (3769 - (14 + 376))) and ((0 - 0) == v203)) then
								if (((2944 + 1605) == (3997 + 552)) and (v95 == "Refreshing Healing Potion")) then
									if (v101.RefreshingHealingPotion:IsReady() or ((2883 + 139) >= (8860 - 5836))) then
										if (((3627 + 1193) > (2276 - (23 + 55))) and v25(v104.RefreshingHealingPotion)) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if ((v95 == "Dreamwalker's Healing Potion") or ((2514 - 1453) >= (3264 + 1627))) then
									if (((1225 + 139) <= (6934 - 2461)) and v101.DreamwalkersHealingPotion:IsReady()) then
										if (v25(v104.RefreshingHealingPotion) or ((1131 + 2464) <= (904 - (652 + 249)))) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if ((v86 < v108) or ((12502 - 7830) == (5720 - (708 + 1160)))) then
						v30 = v121();
						if (((4231 - 2672) == (2841 - 1282)) and v30) then
							return v30;
						end
						if ((v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) or ((1779 - (10 + 17)) <= (177 + 611))) then
							if (v25(v104.UseWeapon) or ((5639 - (1400 + 332)) == (338 - 161))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					v184 = 1911 - (242 + 1666);
				end
				if (((1485 + 1985) > (204 + 351)) and (v184 == (4 + 0))) then
					if (v25(v100.Pool) or ((1912 - (850 + 90)) == (1129 - 484))) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v128()
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v103();
	end
	v21.SetAPL(1460 - (360 + 1030), v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

