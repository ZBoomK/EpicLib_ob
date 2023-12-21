local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5390 - (83 + 468)) >= (5506 - (1202 + 604))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((1788 - 713) > (5310 - 3392))) then
				return v1(v4, ...);
			end
			v5 = 326 - (45 + 280);
		end
		if (((383 + 13) <= (3324 + 480)) and (v5 == (1 + 0))) then
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
		if (v98.CleanseToxins:IsAvailable() or ((2307 + 1862) == (385 + 1802))) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 20574 - 9463;
	local v106 = 13022 - (340 + 1571);
	local v107;
	local v108 = 0 + 0;
	local v109 = 1772 - (1733 + 39);
	local v110;
	v10:RegisterForEvent(function()
		v105 = 30531 - 19420;
		v106 = 12145 - (125 + 909);
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v126 = 1948 - (1096 + 852);
		local v127;
		local v128;
		while true do
			if (((631 + 775) == (2007 - 601)) and (v126 == (0 + 0))) then
				v127 = v15:GCDRemains();
				v128 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (522 - (409 + 103)), v98.WakeofAshes:CooldownRemains());
				v126 = 237 - (46 + 190);
			end
			if (((1626 - (51 + 44)) < (1205 + 3066)) and (v126 == (1318 - (1114 + 203)))) then
				if (((1361 - (228 + 498)) == (138 + 497)) and (v127 > v128)) then
					return v127;
				end
				return v128;
			end
		end
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v113()
		if (((1864 + 1509) <= (4219 - (174 + 489))) and v98.CleanseToxins:IsReady() and v34 and v97.DispellableFriendlyUnit(65 - 40)) then
			if (v25(v102.CleanseToxinsFocus) or ((5196 - (830 + 1075)) < (3804 - (303 + 221)))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v114()
		if (((5655 - (231 + 1038)) >= (728 + 145)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (((2083 - (171 + 991)) <= (4541 - 3439)) and v98.FlashofLight:IsReady()) then
				if (((12636 - 7930) >= (2402 - 1439)) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		if (v16:Exists() or ((769 + 191) <= (3070 - 2194))) then
			if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((5959 - 3893) == (1501 - 569))) then
				if (((14915 - 10090) < (6091 - (111 + 1137))) and v25(v102.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(188 - (91 + 67)) or ((11538 - 7661) >= (1133 + 3404))) then
			return;
		end
		if (v14 or ((4838 - (423 + 100)) < (13 + 1713))) then
			local v172 = 0 - 0;
			while true do
				if ((v172 == (0 + 0)) or ((4450 - (326 + 445)) < (2727 - 2102))) then
					if ((v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) or ((10303 - 5678) < (1474 - 842))) then
						if (v25(v102.WordofGloryFocus) or ((794 - (530 + 181)) > (2661 - (614 + 267)))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((578 - (19 + 13)) <= (1752 - 675)) and v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) then
						if (v25(v102.LayonHandsFocus) or ((2320 - 1324) > (12286 - 7985))) then
							return "lay_on_hands defensive focus";
						end
					end
					v172 = 1 + 0;
				end
				if (((7157 - 3087) > (1424 - 737)) and (v172 == (1813 - (1293 + 519)))) then
					if ((v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((1338 - 682) >= (8694 - 5364))) then
						if (v25(v102.BlessingofSacrificeFocus) or ((4765 - 2273) <= (1444 - 1109))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((10181 - 5859) >= (1357 + 1205)) and v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
						if (v25(v102.BlessingofProtectionFocus) or ((743 + 2894) >= (8759 - 4989))) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (1 + 0)) or ((1487 + 892) > (5674 - (709 + 387)))) then
				v30 = v97.HandleBottomTrinket(v100, v33, 1898 - (673 + 1185), nil);
				if (v30 or ((1400 - 917) > (2385 - 1642))) then
					return v30;
				end
				break;
			end
			if (((4037 - 1583) > (414 + 164)) and (v129 == (0 + 0))) then
				v30 = v97.HandleTopTrinket(v100, v33, 54 - 14, nil);
				if (((229 + 701) < (8888 - 4430)) and v30) then
					return v30;
				end
				v129 = 1 - 0;
			end
		end
	end
	local function v117()
		local v130 = 1880 - (446 + 1434);
		while true do
			if (((1945 - (1040 + 243)) <= (2901 - 1929)) and (v130 == (1850 - (559 + 1288)))) then
				if (((6301 - (609 + 1322)) == (4824 - (13 + 441))) and v98.HammerofWrath:IsReady() and v42) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((17794 - 13032) <= (2255 - 1394))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if ((v98.CrusaderStrike:IsCastable() and v37) or ((7032 - 5620) == (159 + 4105))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((11505 - 8337) < (765 + 1388))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v130 == (0 + 0)) or ((14766 - 9790) < (729 + 603))) then
				if (((8511 - 3883) == (3060 + 1568)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) then
					if (v25(v98.ShieldofVengeance) or ((31 + 23) == (284 + 111))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if (((69 + 13) == (81 + 1)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (437 - (153 + 280)))) then
					if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((1677 - 1096) < (254 + 28))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v130 = 1 + 0;
			end
			if ((v130 == (2 + 0)) or ((4183 + 426) < (1808 + 687))) then
				if (((1753 - 601) == (713 + 439)) and v98.BladeofJustice:IsCastable() and v35) then
					if (((2563 - (89 + 578)) <= (2445 + 977)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				if ((v98.Judgment:IsCastable() and v43) or ((2058 - 1068) > (2669 - (572 + 477)))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((119 + 758) > (2818 + 1877))) then
						return "judgment precombat 6";
					end
				end
				v130 = 1 + 2;
			end
			if (((2777 - (84 + 2)) >= (3050 - 1199)) and (v130 == (1 + 0))) then
				if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (846 - (497 + 345)))) or ((77 + 2908) >= (821 + 4035))) then
					if (((5609 - (605 + 728)) >= (853 + 342)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				if (((7185 - 3953) <= (215 + 4475)) and v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (14 - 10))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((808 + 88) >= (8715 - 5569))) then
						return "templars verdict precombat 4";
					end
				end
				v130 = 2 + 0;
			end
		end
	end
	local function v118()
		local v131 = 489 - (457 + 32);
		local v132;
		while true do
			if (((1299 + 1762) >= (4360 - (832 + 570))) and (v131 == (0 + 0))) then
				v132 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (3 + 7))) or (v106 < (88 - 63)));
				if (((1536 + 1651) >= (1440 - (588 + 208))) and v132) then
					return v132;
				end
				v131 = 2 - 1;
			end
			if (((2444 - (884 + 916)) <= (1473 - 769)) and (v131 == (2 + 0))) then
				if (((1611 - (232 + 421)) > (2836 - (1569 + 320))) and v85 and ((v33 and v86) or not v86) and v17:IsInRange(2 + 6)) then
					local v191 = 0 + 0;
					while true do
						if (((15137 - 10645) >= (3259 - (316 + 289))) and (v191 == (0 - 0))) then
							v30 = v116();
							if (((159 + 3283) >= (2956 - (666 + 787))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (440 - (360 + 65))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) or ((2963 + 207) <= (1718 - (79 + 175)))) then
					if (v25(v98.ShieldofVengeance) or ((7563 - 2766) == (3425 + 963))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v131 = 8 - 5;
			end
			if (((1060 - 509) <= (1580 - (503 + 396))) and (v131 == (185 - (92 + 89)))) then
				if (((6357 - 3080) > (209 + 198)) and v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v108 >= (3 + 1)) and (v10.CombatTime() < (19 - 14))) or ((v108 >= (1 + 2)) and (v10.CombatTime() >= (11 - 6))))) then
					if (((4097 + 598) >= (676 + 739)) and v25(v98.Crusade, not v17:IsInRange(30 - 20))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (1 + 3)) and (v10.CombatTime() < (12 - 4))) or ((v108 >= (1247 - (485 + 759))) and (v10.CombatTime() >= (18 - 10))) or ((v108 >= (1191 - (442 + 747))) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (1145 - (832 + 303))) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (956 - (88 + 858)))))) and ((v107 > (0 + 0)) or (v108 == (5 + 0)) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable()))) or ((4001 - (766 + 23)) <= (4660 - 3716))) then
					local v192 = 0 - 0;
					while true do
						if ((v192 == (0 - 0)) or ((10507 - 7411) <= (2871 - (1036 + 37)))) then
							if (((2508 + 1029) == (6887 - 3350)) and (v96 == "player")) then
								if (((3019 + 818) >= (3050 - (641 + 839))) and v25(v102.FinalReckoningPlayer, not v17:IsInRange(923 - (910 + 3)))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v96 == "cursor") or ((7520 - 4570) == (5496 - (1466 + 218)))) then
								if (((2171 + 2552) >= (3466 - (556 + 592))) and v25(v102.FinalReckoningCursor, not v17:IsInRange(8 + 12))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == (809 - (329 + 479))) or ((2881 - (174 + 680)) > (9799 - 6947))) then
				if ((v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) or ((2354 - 1218) > (3083 + 1234))) then
					if (((5487 - (396 + 343)) == (421 + 4327)) and v25(v98.LightsJudgment, not v17:IsInRange(1517 - (29 + 1448)))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((5125 - (135 + 1254)) <= (17856 - 13116)) and v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (46 - 36))))) then
					if (v25(v98.Fireblood, not v17:IsInRange(7 + 3)) or ((4917 - (389 + 1138)) <= (3634 - (102 + 472)))) then
						return "fireblood cooldowns 6";
					end
				end
				v131 = 2 + 0;
			end
			if (((2 + 1) == v131) or ((932 + 67) > (4238 - (320 + 1225)))) then
				if (((824 - 361) < (368 + 233)) and v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (1479 - (157 + 1307)))) or (v15:BuffStack(v98.CrusadeBuff) == (1869 - (821 + 1038))) or (v98.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v98.AvengingWrath:CooldownRemains() > (2 + 13))) and (((v108 >= (6 - 2)) and (v10.CombatTime() < (2 + 3))) or ((v108 >= (7 - 4)) and (v10.CombatTime() > (1031 - (834 + 192)))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (3 + 5)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (1 + 11)))) then
					if (v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence)) or ((3381 - 1198) < (991 - (300 + 4)))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((1215 + 3334) == (11908 - 7359)) and v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (366 - (112 + 250))) and (v10.CombatTime() < (2 + 3))) or ((v108 >= (7 - 4)) and (v10.CombatTime() > (3 + 2))) or ((v108 >= (2 + 0)) and v98.DivineAuxiliary:IsAvailable() and (v98.ExecutionSentence:CooldownUp() or v98.FinalReckoning:CooldownUp())))) then
					if (((3495 + 1177) == (2317 + 2355)) and v25(v98.AvengingWrath, not v17:IsInRange(8 + 2))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v131 = 1418 - (1001 + 413);
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (884 - (244 + 638))) or ((4361 - (627 + 66)) < (1176 - 781))) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (605 - (512 + 90)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1916 - (1665 + 241)))))) or ((4883 - (373 + 344)) == (206 + 249))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((1178 + 3271) == (7024 - 4361))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v133 == (1 - 0)) or ((5376 - (35 + 1064)) < (2175 + 814))) then
				if ((v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (6 - 3))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1 + 9))))) or ((2106 - (298 + 938)) >= (5408 - (233 + 1026)))) then
					if (((3878 - (636 + 1030)) < (1628 + 1555)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((4539 + 107) > (889 + 2103)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1 + 2))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (231 - (55 + 166)))))) then
					if (((278 + 1156) < (313 + 2793)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v133 = 7 - 5;
			end
			if (((1083 - (36 + 261)) < (5286 - 2263)) and (v133 == (1368 - (34 + 1334)))) then
				v110 = ((v104 >= (2 + 1)) or ((v104 >= (2 + 0)) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (1307 - (1035 + 248))));
				if ((v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (24 - (20 + 1)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (6 + 4))))) or ((2761 - (134 + 185)) < (1207 - (549 + 584)))) then
					if (((5220 - (314 + 371)) == (15568 - 11033)) and v25(v98.DivineStorm, not v17:IsInRange(978 - (478 + 490)))) then
						return "divine_storm finishers 2";
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v120()
		if ((v108 >= (1177 - (786 + 386))) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(100 - 69, 1383 - (1055 + 324)) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (1344 - (1093 + 247)))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(28 + 3, 1 + 1)) or ((11946 - 8937) <= (7143 - 5038))) then
			v30 = v119();
			if (((5207 - 3377) < (9219 - 5550)) and v30) then
				return v30;
			end
		end
		if ((v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1 + 1)) and (v98.AvengingWrath:CooldownDown() or v98.Crusade:CooldownDown()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (15 - 11)) or (v106 < (27 - 19)))) or ((1079 + 351) >= (9237 - 5625))) then
			if (((3371 - (364 + 324)) >= (6743 - 4283)) and v25(v98.WakeofAshes, not v17:IsInRange(23 - 13))) then
				return "wake_of_ashes generators 2";
			end
		end
		if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (1 + 2)) and v15:HasTier(129 - 98, 2 - 0)) or ((5478 - 3674) >= (4543 - (1249 + 19)))) then
			if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((1280 + 137) > (14125 - 10496))) then
				return "blade_of_justice generators 4";
			end
		end
		if (((5881 - (686 + 400)) > (316 + 86)) and v98.DivineToll:IsCastable() and v40 and (v108 <= (231 - (73 + 156))) and ((v98.AvengingWrath:CooldownRemains() > (1 + 14)) or (v98.Crusade:CooldownRemains() > (826 - (721 + 90))) or (v106 < (1 + 7)))) then
			if (((15627 - 10814) > (4035 - (224 + 246))) and v25(v98.DivineToll, not v17:IsInRange(48 - 18))) then
				return "divine_toll generators 6";
			end
		end
		if (((7202 - 3290) == (710 + 3202)) and v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(1 + 30, 2 + 0)) then
			if (((5608 - 2787) <= (16053 - 11229)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment generators 7";
			end
		end
		if (((2251 - (203 + 310)) <= (4188 - (1238 + 755))) and (v108 >= (1 + 2)) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1544 - (709 + 825)))) then
			v30 = v119();
			if (((75 - 34) <= (4395 - 1377)) and v30) then
				return v30;
			end
		end
		if (((3009 - (196 + 668)) <= (16203 - 12099)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (7 - 3)) and (v104 >= (835 - (171 + 662)))) then
			if (((2782 - (4 + 89)) < (16981 - 12136)) and v25(v98.TemplarSlash, not v17:IsInRange(4 + 6))) then
				return "templar_slash generators 8";
			end
		end
		if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (13 - 10)) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (1 + 1)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (1490 - (35 + 1451))))) or ((3775 - (28 + 1425)) > (4615 - (941 + 1052)))) then
			if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((4348 + 186) == (3596 - (822 + 692)))) then
				return "blade_of_justice generators 10";
			end
		end
		if ((v98.HammerofWrath:IsReady() and v42 and ((v104 < (2 - 0)) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(15 + 15, 301 - (45 + 252))) and ((v108 <= (3 + 0)) or (v17:HealthPercentage() > (7 + 13)) or not v98.VanguardsMomentum:IsAvailable())) or ((3823 - 2252) > (2300 - (114 + 319)))) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((3810 - 1156) >= (3838 - 842))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if (((2536 + 1442) > (3134 - 1030)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (8 - 4))) then
			if (((4958 - (556 + 1407)) > (2747 - (741 + 465))) and v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash))) then
				return "templar_slash generators 14";
			end
		end
		if (((3714 - (170 + 295)) > (503 + 450)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (3 + 0)) or not v98.BoundlessJudgment:IsAvailable())) then
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((8058 - 4785) > (3791 + 782))) then
				return "judgment generators 16";
			end
		end
		if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (2 + 1)) or not v98.HolyBlade:IsAvailable())) or ((1785 + 1366) < (2514 - (957 + 273)))) then
			if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((495 + 1355) == (613 + 916))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((3128 - 2307) < (5594 - 3471)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (9 - 6)) or not v98.BoundlessJudgment:IsAvailable())) then
			if (((4466 - 3564) < (4105 - (389 + 1391))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment generators 20";
			end
		end
		if (((539 + 319) <= (309 + 2653)) and ((v17:HealthPercentage() <= (45 - 25)) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff))) then
			v30 = v119();
			if (v30 or ((4897 - (783 + 168)) < (4322 - 3034))) then
				return v30;
			end
		end
		if ((v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (2 + 0))) or ((3553 - (309 + 2)) == (1740 - 1173))) then
			if (v25(v98.Consecration, not v17:IsInRange(1222 - (1090 + 122))) or ((275 + 572) >= (4241 - 2978))) then
				return "consecration generators 22";
			end
		end
		if ((v98.DivineHammer:IsCastable() and v38 and (v104 >= (2 + 0))) or ((3371 - (628 + 490)) == (332 + 1519))) then
			if (v25(v98.DivineHammer, not v17:IsInRange(24 - 14)) or ((9537 - 7450) > (3146 - (431 + 343)))) then
				return "divine_hammer generators 24";
			end
		end
		if ((v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1.75 - 0)) and ((v108 <= (5 - 3)) or ((v108 <= (3 + 0)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1 + 1)))) or ((v108 == (1699 - (556 + 1139))) and (v98.BladeofJustice:CooldownRemains() > (v109 * (17 - (6 + 9)))) and (v98.Judgment:CooldownRemains() > (v109 * (1 + 1)))))) or ((2278 + 2167) < (4318 - (28 + 141)))) then
			if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((705 + 1113) == (104 - 19))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v119();
		if (((447 + 183) < (3444 - (486 + 831))) and v30) then
			return v30;
		end
		if ((v98.TemplarSlash:IsReady() and v45) or ((5043 - 3105) == (8850 - 6336))) then
			if (((805 + 3450) >= (173 - 118)) and v25(v98.TemplarSlash, not v17:IsInRange(1273 - (668 + 595)))) then
				return "templar_slash generators 28";
			end
		end
		if (((2699 + 300) > (234 + 922)) and v98.TemplarStrike:IsReady() and v46) then
			if (((6408 - 4058) > (1445 - (23 + 267))) and v25(v98.TemplarStrike, not v17:IsInRange(1954 - (1129 + 815)))) then
				return "templar_strike generators 30";
			end
		end
		if (((4416 - (371 + 16)) <= (6603 - (1326 + 424))) and v98.Judgment:IsReady() and v43 and ((v108 <= (5 - 2)) or not v98.BoundlessJudgment:IsAvailable())) then
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1885 - 1369) > (3552 - (88 + 30)))) then
				return "judgment generators 32";
			end
		end
		if (((4817 - (720 + 51)) >= (6746 - 3713)) and v98.HammerofWrath:IsReady() and v42 and ((v108 <= (1779 - (421 + 1355))) or (v17:HealthPercentage() > (32 - 12)) or not v98.VanguardsMomentum:IsAvailable())) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((1336 + 1383) <= (2530 - (286 + 797)))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if ((v98.CrusaderStrike:IsCastable() and v37) or ((15112 - 10978) < (6502 - 2576))) then
			if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((603 - (397 + 42)) >= (870 + 1915))) then
				return "crusader_strike generators 26";
			end
		end
		if ((v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (805 - (24 + 776))) and (v84 < v106)) or ((808 - 283) == (2894 - (222 + 563)))) then
			if (((72 - 39) == (24 + 9)) and v25(v98.ArcaneTorrent, not v17:IsInRange(200 - (23 + 167)))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((4852 - (690 + 1108)) <= (1449 + 2566)) and v98.Consecration:IsCastable() and v36) then
			if (((1544 + 327) < (4230 - (40 + 808))) and v25(v98.Consecration, not v17:IsInRange(2 + 8))) then
				return "consecration generators 30";
			end
		end
		if (((4944 - 3651) <= (2071 + 95)) and v98.DivineHammer:IsCastable() and v38) then
			if (v25(v98.DivineHammer, not v17:IsInRange(6 + 4)) or ((1415 + 1164) < (694 - (47 + 524)))) then
				return "divine_hammer generators 32";
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
		v67 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
		v68 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
		v69 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
		v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
		v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (1726 - (1165 + 561));
		v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 + 0);
		v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
		v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
		v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v123()
		local v168 = 479 - (341 + 138);
		while true do
			if ((v168 == (2 + 4)) or ((1745 - 899) >= (2694 - (89 + 237)))) then
				v95 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if ((v168 == (3 - 1)) or ((4893 - (581 + 300)) <= (4578 - (855 + 365)))) then
				v85 = EpicSettings.Settings['useTrinkets'];
				v87 = EpicSettings.Settings['useRacials'];
				v86 = EpicSettings.Settings['trinketsWithCD'];
				v168 = 6 - 3;
			end
			if (((488 + 1006) <= (4240 - (1030 + 205))) and (v168 == (4 + 0))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (286 - (156 + 130));
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v168 = 11 - 6;
			end
			if ((v168 == (1 - 0)) or ((6371 - 3260) == (563 + 1571))) then
				v83 = EpicSettings.Settings['InterruptThreshold'];
				v78 = EpicSettings.Settings['DispelDebuffs'];
				v77 = EpicSettings.Settings['DispelBuffs'];
				v168 = 2 + 0;
			end
			if (((2424 - (10 + 59)) == (667 + 1688)) and ((24 - 19) == v168)) then
				v79 = EpicSettings.Settings['handleAfflicted'];
				v80 = EpicSettings.Settings['HandleIncorporeal'];
				v94 = EpicSettings.Settings['HealOOC'];
				v168 = 1169 - (671 + 492);
			end
			if ((v168 == (3 + 0)) or ((1803 - (369 + 846)) <= (115 + 317))) then
				v88 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v168 = 4 + 0;
			end
			if (((6742 - (1036 + 909)) >= (3097 + 798)) and (v168 == (0 - 0))) then
				v84 = EpicSettings.Settings['fightRemainsCheck'] or (203 - (11 + 192));
				v81 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v168 = 1 + 0;
			end
		end
	end
	local function v124()
		local v169 = 175 - (135 + 40);
		while true do
			if (((8666 - 5089) == (2157 + 1420)) and (v169 == (0 - 0))) then
				v122();
				v121();
				v123();
				v31 = EpicSettings.Toggles['ooc'];
				v169 = 1 - 0;
			end
			if (((3970 - (50 + 126)) > (10283 - 6590)) and (v169 == (2 + 4))) then
				v30 = v115();
				if (v30 or ((2688 - (1233 + 180)) == (5069 - (522 + 447)))) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v97.TargetIsValid()) or ((3012 - (107 + 1314)) >= (1662 + 1918))) then
					local v193 = 0 - 0;
					while true do
						if (((418 + 565) <= (3590 - 1782)) and (v193 == (0 - 0))) then
							v30 = v117();
							if (v30 or ((4060 - (716 + 1194)) <= (21 + 1176))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((404 + 3365) >= (1676 - (74 + 429))) and v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
					local v194 = 0 - 0;
					while true do
						if (((736 + 749) == (3399 - 1914)) and (v194 == (2 + 0))) then
							if ((v89 and (v15:HealthPercentage() <= v91)) or ((10219 - 6904) <= (6878 - 4096))) then
								local v202 = 433 - (279 + 154);
								while true do
									if ((v202 == (778 - (454 + 324))) or ((690 + 186) >= (2981 - (12 + 5)))) then
										if ((v93 == "Refreshing Healing Potion") or ((1204 + 1028) > (6362 - 3865))) then
											if (v99.RefreshingHealingPotion:IsReady() or ((780 + 1330) <= (1425 - (277 + 816)))) then
												if (((15750 - 12064) > (4355 - (1058 + 125))) and v25(v102.RefreshingHealingPotion)) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v93 == "Dreamwalker's Healing Potion") or ((839 + 3635) < (1795 - (815 + 160)))) then
											if (((18359 - 14080) >= (6841 - 3959)) and v99.DreamwalkersHealingPotion:IsReady()) then
												if (v25(v102.RefreshingHealingPotion) or ((485 + 1544) >= (10292 - 6771))) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v84 < v106) or ((3935 - (41 + 1857)) >= (6535 - (1222 + 671)))) then
								v30 = v118();
								if (((4445 - 2725) < (6407 - 1949)) and v30) then
									return v30;
								end
							end
							v194 = 1185 - (229 + 953);
						end
						if ((v194 == (1778 - (1111 + 663))) or ((2015 - (874 + 705)) > (423 + 2598))) then
							if (((487 + 226) <= (1759 - 912)) and v25(v98.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((61 + 2093) <= (4710 - (642 + 37))) and (v194 == (1 + 0))) then
							if (((739 + 3876) == (11587 - 6972)) and v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) then
								if (v25(v98.DivineProtection) or ((4244 - (233 + 221)) == (1156 - 656))) then
									return "divine_protection defensive";
								end
							end
							if (((79 + 10) < (1762 - (718 + 823))) and v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
								if (((1293 + 761) >= (2226 - (266 + 539))) and v25(v102.Healthstone)) then
									return "healthstone defensive";
								end
							end
							v194 = 5 - 3;
						end
						if (((1917 - (636 + 589)) < (7258 - 4200)) and (v194 == (5 - 2))) then
							v30 = v120();
							if (v30 or ((2579 + 675) == (602 + 1053))) then
								return v30;
							end
							v194 = 1019 - (657 + 358);
						end
						if (((0 - 0) == v194) or ((2952 - 1656) == (6097 - (1151 + 36)))) then
							if (((3253 + 115) == (886 + 2482)) and v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) then
								if (((7893 - 5250) < (5647 - (1552 + 280))) and v25(v98.LayonHands)) then
									return "lay_on_hands_player defensive";
								end
							end
							if (((2747 - (64 + 770)) > (335 + 158)) and v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
								if (((10794 - 6039) > (609 + 2819)) and v25(v98.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v194 = 1244 - (157 + 1086);
						end
					end
				end
				break;
			end
			if (((2763 - 1382) <= (10375 - 8006)) and (v169 == (5 - 1))) then
				if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((6609 - 1766) == (4903 - (599 + 220)))) then
					if (((9297 - 4628) > (2294 - (1813 + 118))) and v25(v102.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((1373 + 504) >= (4355 - (841 + 376)))) then
					if (((6644 - 1902) >= (843 + 2783)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (8 - 5)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v102.IntercessionMouseover) or ((5399 - (464 + 395)) == (2350 - 1434))) then
							return "Intercession mouseover";
						end
					end
				end
				if (v97.TargetIsValid() or v15:AffectingCombat() or ((556 + 600) > (5182 - (467 + 370)))) then
					local v195 = 0 - 0;
					while true do
						if (((1643 + 594) < (14565 - 10316)) and (v195 == (0 + 0))) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							v195 = 2 - 1;
						end
						if ((v195 == (522 - (150 + 370))) or ((3965 - (74 + 1208)) < (56 - 33))) then
							v108 = v15:HolyPower();
							break;
						end
						if (((3305 - 2608) <= (588 + 238)) and ((391 - (14 + 376)) == v195)) then
							if (((1916 - 811) <= (761 + 415)) and (v106 == (9761 + 1350))) then
								v106 = v10.FightRemains(v103, false);
							end
							v109 = v15:GCD();
							v195 = 2 + 0;
						end
					end
				end
				if (((9900 - 6521) <= (2868 + 944)) and v79) then
					local v196 = 78 - (23 + 55);
					while true do
						if ((v196 == (0 - 0)) or ((526 + 262) >= (1452 + 164))) then
							if (((2873 - 1019) <= (1063 + 2316)) and v75) then
								local v203 = 901 - (652 + 249);
								while true do
									if (((12173 - 7624) == (6417 - (708 + 1160))) and (v203 == (0 - 0))) then
										v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 72 - 32);
										if (v30 or ((3049 - (10 + 17)) >= (680 + 2344))) then
											return v30;
										end
										break;
									end
								end
							end
							if (((6552 - (1400 + 332)) > (4215 - 2017)) and v76 and (v108 > (1910 - (242 + 1666)))) then
								v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 18 + 22, true);
								if (v30 or ((389 + 672) >= (4169 + 722))) then
									return v30;
								end
							end
							break;
						end
					end
				end
				v169 = 945 - (850 + 90);
			end
			if (((2388 - 1024) <= (5863 - (360 + 1030))) and (v169 == (5 + 0))) then
				if (v80 or ((10146 - 6551) <= (3 - 0))) then
					v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 1691 - (909 + 752), true);
					if (v30 or ((5895 - (109 + 1114)) == (7051 - 3199))) then
						return v30;
					end
					v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 12 + 18, true);
					if (((1801 - (6 + 236)) == (983 + 576)) and v30) then
						return v30;
					end
				end
				v30 = v114();
				if (v30 or ((1411 + 341) <= (1858 - 1070))) then
					return v30;
				end
				if (v14 or ((6824 - 2917) == (1310 - (1076 + 57)))) then
					if (((571 + 2899) > (1244 - (579 + 110))) and v78) then
						local v201 = 0 + 0;
						while true do
							if ((v201 == (0 + 0)) or ((516 + 456) == (1052 - (174 + 233)))) then
								v30 = v113();
								if (((8888 - 5706) >= (3712 - 1597)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v169 = 3 + 3;
			end
			if (((5067 - (663 + 511)) < (3952 + 477)) and (v169 == (1 + 0))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((8838 - 5971) < (1154 + 751))) then
					return v30;
				end
				v169 = 4 - 2;
			end
			if ((v169 == (7 - 4)) or ((858 + 938) >= (7884 - 3833))) then
				if (((1154 + 465) <= (344 + 3412)) and v34) then
					local v197 = 722 - (478 + 244);
					while true do
						if (((1121 - (440 + 77)) == (275 + 329)) and (v197 == (3 - 2))) then
							if ((v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((6040 - (655 + 901)) == (167 + 733))) then
								if (v25(v102.BlessingofFreedomFocus) or ((3414 + 1045) <= (752 + 361))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((14631 - 10999) > (4843 - (695 + 750))) and (v197 == (0 - 0))) then
							v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 61 - 21, 100 - 75);
							if (((4433 - (285 + 66)) <= (11461 - 6544)) and v30) then
								return v30;
							end
							v197 = 1311 - (682 + 628);
						end
					end
				end
				v107 = v111();
				if (((779 + 4053) >= (1685 - (176 + 123))) and not v15:AffectingCombat()) then
					if (((58 + 79) == (100 + 37)) and v98.RetributionAura:IsCastable() and (v112())) then
						if (v25(v98.RetributionAura) or ((1839 - (239 + 30)) >= (1178 + 3154))) then
							return "retribution_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((3907 + 157) <= (3219 - 1400))) then
					if (v15:AffectingCombat() or ((15555 - 10569) < (1889 - (306 + 9)))) then
						if (((15444 - 11018) > (30 + 142)) and v98.Intercession:IsCastable()) then
							if (((360 + 226) > (220 + 235)) and v25(v98.Intercession, not v17:IsInRange(85 - 55), true)) then
								return "intercession target";
							end
						end
					elseif (((2201 - (1140 + 235)) == (526 + 300)) and v98.Redemption:IsCastable()) then
						if (v25(v98.Redemption, not v17:IsInRange(28 + 2), true) or ((1032 + 2987) > (4493 - (33 + 19)))) then
							return "redemption target";
						end
					end
				end
				v169 = 2 + 2;
			end
			if (((6045 - 4028) < (1878 + 2383)) and (v169 == (3 - 1))) then
				v103 = v15:GetEnemiesInMeleeRange(8 + 0);
				if (((5405 - (586 + 103)) > (8 + 72)) and v32) then
					v104 = #v103;
				else
					local v198 = 0 - 0;
					while true do
						if (((1488 - (1309 + 179)) == v198) or ((6330 - 2823) == (1425 + 1847))) then
							v103 = {};
							v104 = 2 - 1;
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((662 + 214) >= (6533 - 3458))) then
					if (((8671 - 4319) > (3163 - (295 + 314))) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
						if (v25(v98.CrusaderAura) or ((10821 - 6415) < (6005 - (1300 + 662)))) then
							return "crusader_aura";
						end
					end
				end
				if (v15:AffectingCombat() or v78 or ((5931 - 4042) >= (5138 - (1178 + 577)))) then
					local v199 = 0 + 0;
					local v200;
					while true do
						if (((5592 - 3700) <= (4139 - (851 + 554))) and (v199 == (0 + 0))) then
							v200 = v78 and v98.CleanseToxins:IsReady() and v34;
							v30 = v97.FocusUnit(v200, v102, 55 - 35, nil, 54 - 29);
							v199 = 303 - (115 + 187);
						end
						if (((1473 + 450) < (2100 + 118)) and (v199 == (3 - 2))) then
							if (((3334 - (160 + 1001)) > (332 + 47)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v169 = 3 + 0;
			end
		end
	end
	local function v125()
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v101();
	end
	v21.SetAPL(143 - 73, v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

