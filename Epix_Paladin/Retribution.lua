local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3438 - (91 + 67)) == (9762 - 6482)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2485 - (423 + 100)) >= (18 + 2489))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((1045 - (326 + 445)) == (15631 - 12049))) then
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
		if (v100.CleanseToxins:IsAvailable() or ((4272 - 2354) == (2508 - 1433))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 11822 - (530 + 181);
	local v108 = 11992 - (614 + 267);
	local v109;
	local v110 = 32 - (19 + 13);
	local v111 = 0 - 0;
	local v112;
	v10:RegisterForEvent(function()
		v107 = 25892 - 14781;
		v108 = 31739 - 20628;
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v129 = v15:GCDRemains();
		local v130 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (3 + 7), v100.WakeofAshes:CooldownRemains());
		if (((695 - 299) <= (7888 - 4084)) and (v129 > v130)) then
			return v129;
		end
		return v130;
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 1812 - (1293 + 519);
	local function v116()
		if ((v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(40 - 20) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) or ((10884 - 6715) == (4182 - 1995))) then
			local v156 = 0 - 0;
			while true do
				if (((3311 - 1905) == (745 + 661)) and (v156 == (0 + 0))) then
					if (((3557 - 2026) < (987 + 3284)) and (v115 == (0 + 0))) then
						v115 = GetTime();
					end
					if (((397 + 238) == (1731 - (709 + 387))) and v99.Wait(2358 - (673 + 1185), v115)) then
						local v209 = 0 - 0;
						while true do
							if (((10831 - 7458) <= (5850 - 2294)) and (v209 == (0 + 0))) then
								if (v25(v104.CleanseToxinsFocus) or ((2460 + 831) < (4428 - 1148))) then
									return "cleanse_toxins dispel";
								end
								v115 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v117()
		if (((8745 - 4359) >= (1713 - 840)) and v96 and (v15:HealthPercentage() <= v97)) then
			if (((2801 - (446 + 1434)) <= (2385 - (1040 + 243))) and v100.FlashofLight:IsReady()) then
				if (((14045 - 9339) >= (2810 - (559 + 1288))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		if (v16:Exists() or ((2891 - (609 + 1322)) <= (1330 - (13 + 441)))) then
			if ((v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) or ((7720 - 5654) == (2441 - 1509))) then
				if (((24030 - 19205) < (181 + 4662)) and v25(v104.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(108 - 78) or ((1378 + 2499) >= (1989 + 2548))) then
			return;
		end
		if (v14 or ((12804 - 8489) < (945 + 781))) then
			local v157 = 0 - 0;
			while true do
				if ((v157 == (1 + 0)) or ((2047 + 1632) < (450 + 175))) then
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((3884 + 741) < (619 + 13))) then
						if (v25(v104.BlessingofSacrificeFocus) or ((516 - (153 + 280)) > (5139 - 3359))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((491 + 55) <= (426 + 651)) and v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
						if (v25(v104.BlessingofProtectionFocus) or ((522 + 474) > (3904 + 397))) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if (((2950 + 1120) > (1045 - 358)) and (v157 == (0 + 0))) then
					if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((1323 - (89 + 578)) >= (2379 + 951))) then
						if (v25(v104.WordofGloryFocus) or ((5180 - 2688) <= (1384 - (572 + 477)))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((583 + 3739) >= (1538 + 1024)) and v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) then
						if (v25(v104.LayonHandsFocus) or ((435 + 3202) >= (3856 - (84 + 2)))) then
							return "lay_on_hands defensive focus";
						end
					end
					v157 = 1 - 0;
				end
			end
		end
	end
	local function v119()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (842 - (497 + 345))) or ((61 + 2318) > (774 + 3804))) then
				v30 = v99.HandleTopTrinket(v102, v33, 1373 - (605 + 728), nil);
				if (v30 or ((345 + 138) > (1651 - 908))) then
					return v30;
				end
				v131 = 1 + 0;
			end
			if (((9072 - 6618) > (522 + 56)) and (v131 == (2 - 1))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 31 + 9, nil);
				if (((1419 - (457 + 32)) < (1892 + 2566)) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v120()
		local v132 = 1402 - (832 + 570);
		while true do
			if (((624 + 38) <= (254 + 718)) and (v132 == (6 - 4))) then
				if (((2106 + 2264) == (5166 - (588 + 208))) and v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (10 - 6))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((6562 - (884 + 916)) <= (1802 - 941))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37) or ((819 + 593) == (4917 - (232 + 421)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((5057 - (1569 + 320)) < (529 + 1624))) then
						return "blade_of_justice precombat 5";
					end
				end
				v132 = 1 + 2;
			end
			if ((v132 == (9 - 6)) or ((5581 - (316 + 289)) < (3486 - 2154))) then
				if (((214 + 4414) == (6081 - (666 + 787))) and v100.Judgment:IsCastable() and v45) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((479 - (360 + 65)) == (370 + 25))) then
						return "judgment precombat 6";
					end
				end
				if (((336 - (79 + 175)) == (128 - 46)) and v100.HammerofWrath:IsReady() and v44) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((454 + 127) < (864 - 582))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v132 = 7 - 3;
			end
			if ((v132 == (900 - (503 + 396))) or ((4790 - (92 + 89)) < (4839 - 2344))) then
				if (((591 + 561) == (682 + 470)) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (15 - 11))) then
					if (((260 + 1636) <= (7802 - 4380)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (4 + 0))) or ((473 + 517) > (4933 - 3313))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((110 + 767) > (7159 - 2464))) then
						return "final verdict precombat 3";
					end
				end
				v132 = 1246 - (485 + 759);
			end
			if (((6226 - 3535) >= (3040 - (442 + 747))) and (v132 == (1139 - (832 + 303)))) then
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((3931 - (88 + 858)) >= (1481 + 3375))) then
					if (((3539 + 737) >= (50 + 1145)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((4021 - (766 + 23)) <= (23153 - 18463)) and (v132 == (0 - 0))) then
				if ((v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) or ((2360 - 1464) >= (10677 - 7531))) then
					if (((4134 - (1036 + 37)) >= (2098 + 860)) and v25(v100.ArcaneTorrent, not v17:IsInRange(15 - 7))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((2507 + 680) >= (2124 - (641 + 839))) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) then
					if (((1557 - (910 + 3)) <= (1794 - 1090)) and v25(v100.ShieldofVengeance, not v17:IsInRange(1692 - (1466 + 218)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v121()
		local v133 = 1148 - (556 + 592);
		local v134;
		while true do
			if (((341 + 617) > (1755 - (329 + 479))) and (v133 == (855 - (174 + 680)))) then
				if (((15435 - 10943) >= (5500 - 2846)) and v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) then
					if (((2458 + 984) >= (2242 - (396 + 343))) and v25(v100.LightsJudgment, not v17:IsInRange(4 + 36))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (1487 - (29 + 1448)))))) or ((4559 - (135 + 1254)) <= (5515 - 4051))) then
					if (v25(v100.Fireblood, not v17:IsInRange(46 - 36)) or ((3197 + 1600) == (5915 - (389 + 1138)))) then
						return "fireblood cooldowns 6";
					end
				end
				v133 = 576 - (102 + 472);
			end
			if (((520 + 31) <= (378 + 303)) and ((2 + 0) == v133)) then
				if (((4822 - (320 + 1225)) > (723 - 316)) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(5 + 3)) then
					local v198 = 1464 - (157 + 1307);
					while true do
						if (((6554 - (821 + 1038)) >= (3530 - 2115)) and (v198 == (0 + 0))) then
							v30 = v119();
							if (v30 or ((5704 - 2492) <= (352 + 592))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (37 - 22)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) or ((4122 - (834 + 192)) <= (115 + 1683))) then
					if (((908 + 2629) == (76 + 3461)) and v25(v100.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v133 = 4 - 1;
			end
			if (((4141 - (300 + 4)) >= (420 + 1150)) and (v133 == (0 - 0))) then
				v134 = v99.HandleDPSPotion(v33 and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (372 - (112 + 250))))));
				if (v134 or ((1176 + 1774) == (9549 - 5737))) then
					return v134;
				end
				v133 = 1 + 0;
			end
			if (((2443 + 2280) >= (1734 + 584)) and ((2 + 2) == v133)) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (((v110 >= (4 + 1)) and (v10.CombatTime() < (1419 - (1001 + 413)))) or ((v110 >= (6 - 3)) and (v10.CombatTime() > (887 - (244 + 638)))))) or ((2720 - (627 + 66)) > (8497 - 5645))) then
					if (v25(v100.Crusade, not v17:IsInRange(612 - (512 + 90))) or ((3042 - (1665 + 241)) > (5034 - (373 + 344)))) then
						return "crusade cooldowns 14";
					end
				end
				if (((2142 + 2606) == (1257 + 3491)) and v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (10 - 6)) and (v10.CombatTime() < (13 - 5))) or ((v110 >= (1102 - (35 + 1064))) and ((v10.CombatTime() >= (6 + 2)) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (4 - 2)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (1 + 9)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (1246 - (298 + 938))))))) then
					local v199 = 1259 - (233 + 1026);
					while true do
						if (((5402 - (636 + 1030)) <= (2424 + 2316)) and (v199 == (0 + 0))) then
							if ((v98 == "player") or ((1008 + 2382) <= (207 + 2853))) then
								if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(231 - (55 + 166))) or ((194 + 805) > (271 + 2422))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if (((1767 - 1304) < (898 - (36 + 261))) and (v98 == "cursor")) then
								if (v25(v104.FinalReckoningCursor, not v17:IsInRange(34 - 14)) or ((3551 - (34 + 1334)) < (265 + 422))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((3535 + 1014) == (5832 - (1035 + 248))) and (v133 == (24 - (20 + 1)))) then
				if (((2435 + 2237) == (4991 - (134 + 185))) and v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (1148 - (549 + 584)))) or (v15:BuffStack(v100.CrusadeBuff) == (695 - (314 + 371))) or not v100.Crusade:IsAvailable() or (v100.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v100.AvengingWrath:CooldownRemains() > (983 - (478 + 490)))) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (1177 - (786 + 386)))) or ((v110 >= (9 - 6)) and (v10.CombatTime() > (1384 - (1055 + 324)))) or ((v110 >= (1342 - (1093 + 247))) and v100.DivineAuxiliary:IsAvailable())) and (((v17:TimeToDie() > (8 + 0)) and not v100.ExecutionersWill:IsAvailable()) or (v17:TimeToDie() > (2 + 10)))) then
					if (v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence)) or ((14562 - 10894) < (1340 - 945))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (10 - 6)) and (v10.CombatTime() < (12 - 7))) or ((v110 >= (2 + 1)) and ((v10.CombatTime() > (19 - 14)) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (6 - 4)) and v100.DivineAuxiliary:IsAvailable() and (v100.ExecutionSentence:CooldownUp() or v100.FinalReckoning:CooldownUp()))) and ((v106 == (1 + 0)) or (v17:TimeToDie() > (25 - 15)))) or ((4854 - (364 + 324)) == (1247 - 792))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(23 - 13)) or ((1475 + 2974) == (11142 - 8479))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v133 = 5 - 1;
			end
		end
	end
	local function v122()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (1269 - (1249 + 19))) or ((3861 + 416) < (11634 - 8645))) then
				if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1089 - (686 + 400)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (8 + 2))))) or ((1099 - (73 + 156)) >= (20 + 4129))) then
					if (((3023 - (721 + 90)) < (36 + 3147)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((15084 - 10438) > (3462 - (224 + 246))) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (4 - 1))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (18 - 8))))) then
					if (((261 + 1173) < (74 + 3032)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v135 = 2 + 0;
			end
			if (((1562 - 776) < (10059 - 7036)) and (v135 == (515 - (203 + 310)))) then
				if ((v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1996 - (1238 + 755)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) or ((3976 - (709 + 825)) < (136 - 62))) then
					if (((6605 - 2070) == (5399 - (196 + 668))) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((6232 - 3223) <= (2938 - (171 + 662)))) then
				v112 = ((v106 >= (96 - (4 + 89))) or ((v106 >= (6 - 4)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (9 + 15)));
				if (((8037 - 6207) < (1439 + 2230)) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1489 - (35 + 1451)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1463 - (28 + 1425)))))) then
					if (v25(v100.DivineStorm, not v17:IsInRange(2003 - (941 + 1052))) or ((1372 + 58) >= (5126 - (822 + 692)))) then
						return "divine_storm finishers 2";
					end
				end
				v135 = 1 - 0;
			end
		end
	end
	local function v123()
		local v136 = 0 + 0;
		while true do
			if (((2980 - (45 + 252)) >= (2434 + 26)) and (v136 == (0 + 0))) then
				if ((v110 >= (12 - 7)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(464 - (114 + 319), 5 - 1) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (4 - 0))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(20 + 11, 2 - 0)) or ((3779 - 1975) >= (5238 - (556 + 1407)))) then
					local v200 = 1206 - (741 + 465);
					while true do
						if (((465 - (170 + 295)) == v200) or ((747 + 670) > (3334 + 295))) then
							v30 = v122();
							if (((11805 - 7010) > (334 + 68)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((3087 + 1726) > (2019 + 1546)) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (1232 - (957 + 273))) and ((v100.AvengingWrath:CooldownRemains() > (2 + 4)) or (v100.Crusade:CooldownRemains() > (3 + 3))) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (15 - 11)) or (v108 < (21 - 13)))) then
					if (((11948 - 8036) == (19370 - 15458)) and v25(v100.WakeofAshes, not v17:IsInRange(1790 - (389 + 1391)))) then
						return "wake_of_ashes generators 2";
					end
				end
				if (((1770 + 1051) <= (503 + 4321)) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (6 - 3)) and v15:HasTier(982 - (783 + 168), 6 - 4)) then
					if (((1710 + 28) <= (2506 - (309 + 2))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				v136 = 2 - 1;
			end
			if (((1253 - (1090 + 122)) <= (979 + 2039)) and (v136 == (6 - 4))) then
				if (((1468 + 677) <= (5222 - (628 + 490))) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (1 + 3)) and (v106 >= (4 - 2))) then
					if (((12288 - 9599) < (5619 - (431 + 343))) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 8";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (5 - 2)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (5 - 3)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (4 + 0)))) or ((297 + 2025) > (4317 - (556 + 1139)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((4549 - (6 + 9)) == (382 + 1700))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (2 + 0)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(199 - (28 + 141), 2 + 2)) and ((v110 <= (3 - 0)) or (v17:HealthPercentage() > (15 + 5)) or not v100.VanguardsMomentum:IsAvailable())) or ((2888 - (486 + 831)) > (4858 - 2991))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((9343 - 6689) >= (567 + 2429))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v136 = 9 - 6;
			end
			if (((5241 - (668 + 595)) > (1894 + 210)) and (v136 == (2 + 3))) then
				if (((8167 - 5172) > (1831 - (23 + 267))) and v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1945.75 - (1129 + 815))) and ((v110 <= (389 - (371 + 16))) or ((v110 <= (1753 - (1326 + 424))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (3 - 1)))) or ((v110 == (14 - 10)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (120 - (88 + 30)))) and (v100.Judgment:CooldownRemains() > (v111 * (773 - (720 + 51))))))) then
					if (((7227 - 3978) > (2729 - (421 + 1355))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				if (v30 or ((5399 - 2126) > (2247 + 2326))) then
					return v30;
				end
				v136 = 1089 - (286 + 797);
			end
			if ((v136 == (14 - 10)) or ((5218 - 2067) < (1723 - (397 + 42)))) then
				if ((v17:HealthPercentage() <= (7 + 13)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff) or ((2650 - (24 + 776)) == (2355 - 826))) then
					local v201 = 785 - (222 + 563);
					while true do
						if (((1808 - 987) < (1529 + 594)) and (v201 == (190 - (23 + 167)))) then
							v30 = v122();
							if (((2700 - (690 + 1108)) < (839 + 1486)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((708 + 150) <= (3810 - (40 + 808))) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (1 + 1))) then
					if (v25(v100.Consecration, not v17:IsInRange(38 - 28)) or ((3772 + 174) < (682 + 606))) then
						return "consecration generators 22";
					end
				end
				if ((v100.DivineHammer:IsCastable() and v40 and (v106 >= (2 + 0))) or ((3813 - (47 + 524)) == (368 + 199))) then
					if (v25(v100.DivineHammer, not v17:IsInRange(27 - 17)) or ((1265 - 418) >= (2880 - 1617))) then
						return "divine_hammer generators 24";
					end
				end
				v136 = 1731 - (1165 + 561);
			end
			if ((v136 == (1 + 5)) or ((6977 - 4724) == (707 + 1144))) then
				if ((v100.TemplarSlash:IsReady() and v47) or ((2566 - (341 + 138)) > (641 + 1731))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((9173 - 4728) < (4475 - (89 + 237)))) then
						return "templar_slash generators 28";
					end
				end
				if ((v100.TemplarStrike:IsReady() and v48) or ((5848 - 4030) == (178 - 93))) then
					if (((1511 - (581 + 300)) < (3347 - (855 + 365))) and v25(v100.TemplarStrike, not v17:IsSpellInRange(v100.TemplarStrike))) then
						return "templar_strike generators 30";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and ((v110 <= (6 - 3)) or not v100.BoundlessJudgment:IsAvailable())) or ((633 + 1305) == (3749 - (1030 + 205)))) then
					if (((3995 + 260) >= (52 + 3)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 32";
					end
				end
				v136 = 293 - (156 + 130);
			end
			if (((6813 - 3814) > (1947 - 791)) and (v136 == (5 - 2))) then
				if (((620 + 1730) > (674 + 481)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (73 - (10 + 59)))) then
					if (((1140 + 2889) <= (23899 - 19046)) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (1166 - (671 + 492))) or not v100.BoundlessJudgment:IsAvailable())) or ((411 + 105) > (4649 - (369 + 846)))) then
					if (((1072 + 2974) >= (2589 + 444)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 16";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1948 - (1036 + 909))) or not v100.HolyBlade:IsAvailable())) or ((2162 + 557) <= (2428 - 981))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((4337 - (11 + 192)) < (1985 + 1941))) then
						return "blade_of_justice generators 18";
					end
				end
				v136 = 179 - (135 + 40);
			end
			if ((v136 == (19 - 11)) or ((99 + 65) >= (6135 - 3350))) then
				if ((v100.Consecration:IsCastable() and v38) or ((787 - 262) == (2285 - (50 + 126)))) then
					if (((91 - 58) == (8 + 25)) and v25(v100.Consecration, not v17:IsInRange(1423 - (1233 + 180)))) then
						return "consecration generators 30";
					end
				end
				if (((4023 - (522 + 447)) <= (5436 - (107 + 1314))) and v100.DivineHammer:IsCastable() and v40) then
					if (((869 + 1002) < (10305 - 6923)) and v25(v100.DivineHammer, not v17:IsInRange(5 + 5))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((2567 - 1274) <= (8570 - 6404)) and (v136 == (1917 - (716 + 1194)))) then
				if ((v100.HammerofWrath:IsReady() and v44 and ((v110 <= (1 + 2)) or (v17:HealthPercentage() > (3 + 17)) or not v100.VanguardsMomentum:IsAvailable())) or ((3082 - (74 + 429)) < (236 - 113))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((420 + 426) >= (5420 - 3052))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((2839 + 1173) <= (10352 - 6994))) then
					if (((3693 - 2199) <= (3438 - (279 + 154))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (783 - (454 + 324))) and (v86 < v108)) or ((2448 + 663) == (2151 - (12 + 5)))) then
					if (((1270 + 1085) == (6000 - 3645)) and v25(v100.ArcaneTorrent, not v17:IsInRange(4 + 6))) then
						return "arcane_torrent generators 28";
					end
				end
				v136 = 1101 - (277 + 816);
			end
			if ((v136 == (4 - 3)) or ((1771 - (1058 + 125)) <= (81 + 351))) then
				if (((5772 - (815 + 160)) >= (16712 - 12817)) and v100.DivineToll:IsCastable() and v42 and (v110 <= (4 - 2)) and ((v100.AvengingWrath:CooldownRemains() > (4 + 11)) or (v100.Crusade:CooldownRemains() > (43 - 28)) or (v108 < (1906 - (41 + 1857))))) then
					if (((5470 - (1222 + 671)) == (9245 - 5668)) and v25(v100.DivineToll, not v17:IsInRange(43 - 13))) then
						return "divine_toll generators 6";
					end
				end
				if (((4976 - (229 + 953)) > (5467 - (1111 + 663))) and v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(1610 - (874 + 705), 1 + 1)) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((870 + 405) == (8522 - 4422))) then
						return "judgment generators 7";
					end
				end
				if (((v110 >= (1 + 2)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (689 - (642 + 37)))) or ((363 + 1228) >= (573 + 3007))) then
					local v202 = 0 - 0;
					while true do
						if (((1437 - (233 + 221)) <= (4180 - 2372)) and (v202 == (0 + 0))) then
							v30 = v122();
							if (v30 or ((3691 - (718 + 823)) <= (754 + 443))) then
								return v30;
							end
							break;
						end
					end
				end
				v136 = 807 - (266 + 539);
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if (((4994 - (636 + 589)) >= (2784 - 1611)) and (v137 == (3 - 1))) then
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v137 = 3 + 0;
			end
			if (((540 + 945) == (2500 - (657 + 358))) and (v137 == (10 - 6))) then
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v137 = 11 - 6;
			end
			if ((v137 == (1192 - (1151 + 36))) or ((3202 + 113) <= (732 + 2050))) then
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v137 == (2 - 1)) or ((2708 - (1552 + 280)) >= (3798 - (64 + 770)))) then
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v137 = 2 + 0;
			end
			if ((v137 == (0 - 0)) or ((397 + 1835) > (3740 - (157 + 1086)))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v38 = EpicSettings.Settings['useConsecration'];
				v137 = 1 - 0;
			end
			if ((v137 == (13 - 10)) or ((3236 - 1126) <= (452 - 120))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v50 = EpicSettings.Settings['useVerdict'];
				v137 = 823 - (599 + 220);
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if (((5617 - (1813 + 118)) > (2319 + 853)) and (v138 == (1217 - (841 + 376)))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v138 = 1 - 0;
			end
			if ((v138 == (2 + 4)) or ((12211 - 7737) < (1679 - (464 + 395)))) then
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((10981 - 6702) >= (1385 + 1497)) and (v138 == (838 - (467 + 370)))) then
				v62 = EpicSettings.Settings['useDivineShield'];
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayOnHandsFocus'];
				v138 = 3 - 1;
			end
			if ((v138 == (3 + 0)) or ((6955 - 4926) >= (550 + 2971))) then
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v70 = EpicSettings.Settings['divineShieldHP'] or (520 - (150 + 370));
				v138 = 1286 - (74 + 1208);
			end
			if (((12 - 7) == v138) or ((9660 - 7623) >= (3304 + 1338))) then
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (390 - (14 + 376));
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v138 = 6 + 0;
			end
			if (((1641 + 79) < (13062 - 8604)) and (v138 == (2 + 0))) then
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v138 = 81 - (23 + 55);
			end
			if ((v138 == (9 - 5)) or ((291 + 145) > (2713 + 308))) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v72 = EpicSettings.Settings['layOnHandsFocusHP'] or (0 + 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (901 - (652 + 249));
				v138 = 13 - 8;
			end
		end
	end
	local function v126()
		v86 = EpicSettings.Settings['fightRemainsCheck'] or (1868 - (708 + 1160));
		v83 = EpicSettings.Settings['InterruptWithStun'];
		v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v85 = EpicSettings.Settings['InterruptThreshold'];
		v80 = EpicSettings.Settings['DispelDebuffs'];
		v79 = EpicSettings.Settings['DispelBuffs'];
		v87 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v88 = EpicSettings.Settings['trinketsWithCD'];
		v90 = EpicSettings.Settings['racialsWithCD'];
		v92 = EpicSettings.Settings['useHealthstone'];
		v91 = EpicSettings.Settings['useHealingPotion'];
		v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v93 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v81 = EpicSettings.Settings['handleAfflicted'];
		v82 = EpicSettings.Settings['HandleIncorporeal'];
		v96 = EpicSettings.Settings['HealOOC'];
		v97 = EpicSettings.Settings['HealOOCHP'] or (27 - (10 + 17));
	end
	local function v127()
		local v153 = 0 + 0;
		while true do
			if (((2445 - (1400 + 332)) <= (1624 - 777)) and (v153 == (1908 - (242 + 1666)))) then
				v125();
				v124();
				v126();
				v153 = 1 + 0;
			end
			if (((790 + 1364) <= (3436 + 595)) and (v153 == (944 - (850 + 90)))) then
				if (((8082 - 3467) == (6005 - (360 + 1030))) and (v99.TargetIsValid() or v15:AffectingCombat())) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					if ((v108 == (9833 + 1278)) or ((10697 - 6907) == (687 - 187))) then
						v108 = v10.FightRemains(v105, false);
					end
					v111 = v15:GCD();
					v110 = v15:HolyPower();
				end
				if (((1750 - (909 + 752)) < (1444 - (109 + 1114))) and not v15:AffectingCombat()) then
					if (((3760 - 1706) >= (554 + 867)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
						if (((934 - (6 + 236)) < (1927 + 1131)) and v25(v100.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				v30 = v118();
				v153 = 5 + 0;
			end
			if ((v153 == (4 - 2)) or ((5683 - 2429) == (2788 - (1076 + 57)))) then
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((214 + 1082) == (5599 - (579 + 110)))) then
					return v30;
				end
				v105 = v15:GetEnemiesInMeleeRange(1 + 7);
				v153 = 3 + 0;
			end
			if (((1788 + 1580) == (3775 - (174 + 233))) and (v153 == (16 - 10))) then
				if (((4638 - 1995) < (1697 + 2118)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (((3087 - (663 + 511)) > (440 + 53)) and v15:AffectingCombat()) then
						if (((1033 + 3722) > (10568 - 7140)) and v100.Intercession:IsCastable()) then
							if (((837 + 544) <= (5577 - 3208)) and v25(v100.Intercession, not v17:IsInRange(72 - 42), true)) then
								return "intercession target";
							end
						end
					elseif (v100.Redemption:IsCastable() or ((2311 + 2532) == (7948 - 3864))) then
						if (((3328 + 1341) > (34 + 329)) and v25(v100.Redemption, not v17:IsInRange(752 - (478 + 244)), true)) then
							return "redemption target";
						end
					end
				end
				if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((2394 - (440 + 77)) >= (1427 + 1711))) then
					if (((17355 - 12613) >= (5182 - (655 + 901))) and v25(v104.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((842 + 3698) == (702 + 214))) then
					if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (3 + 0)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((4657 - 3501) > (5790 - (695 + 750)))) then
						if (((7638 - 5401) < (6556 - 2307)) and v25(v104.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				v153 = 28 - 21;
			end
			if ((v153 == (352 - (285 + 66))) or ((6254 - 3571) < (1333 - (682 + 628)))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v153 = 1 + 1;
			end
			if (((996 - (176 + 123)) <= (346 + 480)) and (v153 == (7 + 2))) then
				if (((1374 - (239 + 30)) <= (320 + 856)) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
					local v203 = 0 + 0;
					while true do
						if (((5980 - 2601) <= (11892 - 8080)) and (v203 == (318 - (306 + 9)))) then
							v30 = v123();
							if (v30 or ((2749 - 1961) >= (282 + 1334))) then
								return v30;
							end
							v203 = 3 + 1;
						end
						if (((893 + 961) <= (9662 - 6283)) and (v203 == (1376 - (1140 + 235)))) then
							if (((2895 + 1654) == (4172 + 377)) and v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) then
								if (v25(v100.DivineProtection) or ((776 + 2246) >= (3076 - (33 + 19)))) then
									return "divine_protection defensive";
								end
							end
							if (((1741 + 3079) > (6587 - 4389)) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
								if (v25(v104.Healthstone) or ((468 + 593) >= (9591 - 4700))) then
									return "healthstone defensive";
								end
							end
							v203 = 2 + 0;
						end
						if (((2053 - (586 + 103)) <= (408 + 4065)) and ((12 - 8) == v203)) then
							if (v25(v100.Pool) or ((5083 - (1309 + 179)) <= (5 - 2))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v203 == (0 + 0)) or ((12546 - 7874) == (2910 + 942))) then
							if (((3311 - 1752) == (3106 - 1547)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (v25(v100.LayonHands) or ((2361 - (295 + 314)) <= (1935 - 1147))) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((5869 - (1300 + 662)) == (555 - 378))) then
								if (((5225 - (1178 + 577)) > (289 + 266)) and v25(v100.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v203 = 2 - 1;
						end
						if ((v203 == (1407 - (851 + 554))) or ((860 + 112) == (1788 - 1143))) then
							if (((6910 - 3728) >= (2417 - (115 + 187))) and v91 and (v15:HealthPercentage() <= v93)) then
								if (((2982 + 911) < (4193 + 236)) and (v95 == "Refreshing Healing Potion")) then
									if (v101.RefreshingHealingPotion:IsReady() or ((11297 - 8430) < (3066 - (160 + 1001)))) then
										if (v25(v104.RefreshingHealingPotion) or ((1572 + 224) >= (2796 + 1255))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if (((3313 - 1694) <= (4114 - (237 + 121))) and (v95 == "Dreamwalker's Healing Potion")) then
									if (((1501 - (525 + 372)) == (1144 - 540)) and v101.DreamwalkersHealingPotion:IsReady()) then
										if (v25(v104.RefreshingHealingPotion) or ((14732 - 10248) == (1042 - (96 + 46)))) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
							end
							if ((v86 < v108) or ((5236 - (643 + 134)) <= (402 + 711))) then
								v30 = v121();
								if (((8708 - 5076) > (12615 - 9217)) and v30) then
									return v30;
								end
								if (((3915 + 167) <= (9649 - 4732)) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36 and (v100.MarkofFyralathDebuff:AuraActiveCount() > (0 - 0)) and v15:BuffDown(v100.AvengingWrathBuff) and v15:BuffDown(v100.CrusadeBuff)) then
									if (((5551 - (316 + 403)) >= (922 + 464)) and v25(v104.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							v203 = 8 - 5;
						end
					end
				end
				break;
			end
			if (((50 + 87) == (344 - 207)) and (v153 == (6 + 2))) then
				if (v82 or ((506 + 1064) >= (15010 - 10678))) then
					v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 143 - 113, true);
					if (v30 or ((8442 - 4378) <= (105 + 1714))) then
						return v30;
					end
					v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 59 - 29, true);
					if (v30 or ((244 + 4742) < (4630 - 3056))) then
						return v30;
					end
				end
				if (((4443 - (12 + 5)) > (667 - 495)) and v80 and v34) then
					local v204 = 0 - 0;
					while true do
						if (((1245 - 659) > (1128 - 673)) and (v204 == (0 + 0))) then
							if (((2799 - (1656 + 317)) == (737 + 89)) and v14) then
								local v210 = 0 + 0;
								while true do
									if ((v210 == (0 - 0)) or ((19779 - 15760) > (4795 - (5 + 349)))) then
										v30 = v116();
										if (((9580 - 7563) < (5532 - (266 + 1005))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (((3108 + 1608) > (272 - 192)) and v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) then
								if (v100.CleanseToxins:IsReady() or ((4616 - 1109) == (4968 - (561 + 1135)))) then
									if (v25(v104.CleanseToxinsMouseover) or ((1140 - 264) >= (10107 - 7032))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((5418 - (507 + 559)) > (6408 - 3854)) and not v15:AffectingCombat() and v31 and v99.TargetIsValid()) then
					v30 = v120();
					if (v30 or ((13626 - 9220) < (4431 - (212 + 176)))) then
						return v30;
					end
				end
				v153 = 914 - (250 + 655);
			end
			if ((v153 == (8 - 5)) or ((3300 - 1411) >= (5292 - 1909))) then
				if (((3848 - (1869 + 87)) <= (9482 - 6748)) and v32) then
					v106 = #v105;
				else
					v105 = {};
					v106 = 1902 - (484 + 1417);
				end
				if (((4121 - 2198) < (3716 - 1498)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if (((2946 - (48 + 725)) > (618 - 239)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
						if (v25(v100.CrusaderAura) or ((6951 - 4360) == (1982 + 1427))) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v153 = 10 - 6;
			end
			if (((1264 + 3250) > (969 + 2355)) and (v153 == (858 - (152 + 701)))) then
				if (v30 or ((1519 - (430 + 881)) >= (1849 + 2979))) then
					return v30;
				end
				v30 = v117();
				if (v30 or ((2478 - (557 + 338)) > (1055 + 2512))) then
					return v30;
				end
				v153 = 16 - 10;
			end
			if ((v153 == (24 - 17)) or ((3488 - 2175) == (1711 - 917))) then
				if (((3975 - (499 + 302)) > (3768 - (39 + 827))) and (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()))) then
					local v205 = 0 - 0;
					local v206;
					while true do
						if (((9201 - 5081) <= (16920 - 12660)) and (v205 == (1 - 0))) then
							if (v30 or ((76 + 807) > (13984 - 9206))) then
								return v30;
							end
							break;
						end
						if ((v205 == (0 + 0)) or ((5728 - 2108) >= (4995 - (103 + 1)))) then
							v206 = v80 and v100.CleanseToxins:IsReady() and v34;
							v30 = v99.FocusUnit(v206, nil, 574 - (475 + 79), nil, 54 - 29, v100.FlashofLight);
							v205 = 3 - 2;
						end
					end
				end
				if (((551 + 3707) > (825 + 112)) and v34) then
					local v207 = 1503 - (1395 + 108);
					while true do
						if ((v207 == (2 - 1)) or ((6073 - (7 + 1197)) < (396 + 510))) then
							if ((v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((428 + 797) > (4547 - (27 + 292)))) then
								if (((9752 - 6424) > (2853 - 615)) and v25(v104.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((16099 - 12260) > (2770 - 1365)) and (v207 == (0 - 0))) then
							v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 179 - (43 + 96), 101 - 76, v100.FlashofLight, 3 - 1);
							if (v30 or ((1073 + 220) <= (144 + 363))) then
								return v30;
							end
							v207 = 1 - 0;
						end
					end
				end
				if (v81 or ((1110 + 1786) < (1508 - 703))) then
					local v208 = 0 + 0;
					while true do
						if (((170 + 2146) == (4067 - (1414 + 337))) and (v208 == (1940 - (1642 + 298)))) then
							if (v77 or ((6699 - 4129) == (4409 - 2876))) then
								local v211 = 0 - 0;
								while true do
									if ((v211 == (0 + 0)) or ((688 + 195) == (2432 - (357 + 615)))) then
										v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 29 + 11);
										if (v30 or ((11333 - 6714) <= (856 + 143))) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v78 and (v110 > (4 - 2))) or ((2728 + 682) > (280 + 3836))) then
								v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 26 + 14, true);
								if (v30 or ((2204 - (384 + 917)) >= (3756 - (128 + 569)))) then
									return v30;
								end
							end
							break;
						end
					end
				end
				v153 = 1551 - (1407 + 136);
			end
		end
	end
	local function v128()
		v100.MarkofFyralathDebuff:RegisterAuraTracking();
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v103();
	end
	v21.SetAPL(1957 - (687 + 1200), v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

