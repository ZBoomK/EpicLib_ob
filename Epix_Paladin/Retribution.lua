local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (683 - (27 + 656))) or ((1425 + 205) > (1533 + 2665))) then
			v6 = v0[v4];
			if (((584 + 470) == (186 + 868)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1912 - (340 + 1571))) or ((267 + 409) >= (3414 - (1733 + 39)))) then
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
		if (((11365 - 7229) > (3431 - (125 + 909))) and v100.CleanseToxins:IsAvailable()) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 13059 - (1096 + 852);
	local v108 = 4985 + 6126;
	local v109;
	local v110 = 0 - 0;
	local v111 = 0 + 0;
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 512 - (409 + 103);
		while true do
			if ((v129 == (236 - (46 + 190))) or ((4429 - (51 + 44)) == (1198 + 3047))) then
				v107 = 12428 - (1114 + 203);
				v108 = 11837 - (228 + 498);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = 0 + 0;
		local v131;
		local v132;
		while true do
			if (((1 + 0) == v130) or ((4939 - (174 + 489)) <= (7896 - 4865))) then
				if ((v131 > v132) or ((6687 - (830 + 1075)) <= (1723 - (303 + 221)))) then
					return v131;
				end
				return v132;
			end
			if ((v130 == (1269 - (231 + 1038))) or ((4054 + 810) < (3064 - (171 + 991)))) then
				v131 = v15:GCDRemains();
				v132 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (41 - 31), v100.WakeofAshes:CooldownRemains());
				v130 = 2 - 1;
			end
		end
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 0 - 0;
	local function v116()
		if (((3873 + 966) >= (12969 - 9269)) and v100.CleanseToxins:IsReady() and v99.UnitHasDispellableDebuffByPlayer(v14)) then
			if ((v115 == (0 - 0)) or ((1732 - 657) > (5928 - 4010))) then
				v115 = GetTime();
			end
			if (((1644 - (111 + 1137)) <= (3962 - (91 + 67))) and v99.Wait(1488 - 988, v115)) then
				if (v25(v104.CleanseToxinsFocus) or ((1041 + 3128) == (2710 - (423 + 100)))) then
					return "cleanse_toxins dispel";
				end
				v115 = 0 + 0;
			end
		end
	end
	local function v117()
		if (((3892 - 2486) == (733 + 673)) and v96 and (v15:HealthPercentage() <= v97)) then
			if (((2302 - (326 + 445)) < (18638 - 14367)) and v100.FlashofLight:IsReady()) then
				if (((1414 - 779) == (1481 - 846)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v133 = 711 - (530 + 181);
		while true do
			if (((4254 - (614 + 267)) <= (3588 - (19 + 13))) and (v133 == (1 - 0))) then
				if (v14 or ((7668 - 4377) < (9369 - 6089))) then
					if (((1140 + 3246) >= (1534 - 661)) and v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) then
						if (((1909 - 988) <= (2914 - (1293 + 519))) and v25(v104.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((9601 - 4895) >= (2513 - 1550)) and v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) then
						if (v25(v104.LayonHandsFocus) or ((1835 - 875) <= (3777 - 2901))) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((4866 - 2800) == (494 + 438))) then
						if (((985 + 3840) < (11252 - 6409)) and v25(v104.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((896 + 2981) >= (1508 + 3029))) then
						if (v25(v104.BlessingofProtectionFocus) or ((2697 + 1618) < (2822 - (709 + 387)))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if ((v133 == (1858 - (673 + 1185))) or ((10669 - 6990) < (2006 - 1381))) then
				if (v16:Exists() or ((7609 - 2984) < (453 + 179))) then
					if ((v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) or ((63 + 20) > (2403 - 623))) then
						if (((135 + 411) <= (2146 - 1069)) and v25(v104.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(58 - 28) or ((2876 - (446 + 1434)) > (5584 - (1040 + 243)))) then
					return;
				end
				v133 = 2 - 1;
			end
		end
	end
	local function v119()
		local v134 = 1847 - (559 + 1288);
		while true do
			if (((6001 - (609 + 1322)) > (1141 - (13 + 441))) and (v134 == (3 - 2))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 104 - 64, nil);
				if (v30 or ((3267 - 2611) >= (124 + 3206))) then
					return v30;
				end
				break;
			end
			if ((v134 == (0 - 0)) or ((886 + 1606) <= (147 + 188))) then
				v30 = v99.HandleTopTrinket(v102, v33, 118 - 78, nil);
				if (((2366 + 1956) >= (4711 - 2149)) and v30) then
					return v30;
				end
				v134 = 1 + 0;
			end
		end
	end
	local function v120()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (2 + 0)) or ((3054 + 583) >= (3689 + 81))) then
				if ((v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (437 - (153 + 280)))) or ((6869 - 4490) > (4111 + 467))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((191 + 292) > (389 + 354))) then
						return "templars verdict precombat 4";
					end
				end
				if (((2227 + 227) > (419 + 159)) and v100.BladeofJustice:IsCastable() and v37) then
					if (((1416 - 486) < (2756 + 1702)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v135 = 670 - (89 + 578);
			end
			if (((473 + 189) <= (2020 - 1048)) and ((1052 - (572 + 477)) == v135)) then
				if (((590 + 3780) == (2623 + 1747)) and v100.Judgment:IsCastable() and v45) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((569 + 4193) <= (947 - (84 + 2)))) then
						return "judgment precombat 6";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44) or ((2326 - 914) == (3072 + 1192))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((4010 - (497 + 345)) < (56 + 2097))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v135 = 1 + 3;
			end
			if ((v135 == (1334 - (605 + 728))) or ((3551 + 1425) < (2960 - 1628))) then
				if (((213 + 4415) == (17110 - 12482)) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (4 + 0))) then
					if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((149 - 95) == (299 + 96))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((571 - (457 + 32)) == (35 + 47)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (1406 - (832 + 570)))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((548 + 33) < (74 + 208))) then
						return "final verdict precombat 3";
					end
				end
				v135 = 6 - 4;
			end
			if ((v135 == (2 + 2)) or ((5405 - (588 + 208)) < (6724 - 4229))) then
				if (((2952 - (884 + 916)) == (2411 - 1259)) and v100.CrusaderStrike:IsCastable() and v39) then
					if (((1100 + 796) <= (4075 - (232 + 421))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v135 == (1889 - (1569 + 320))) or ((243 + 747) > (308 + 1312))) then
				if ((v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) or ((2955 - 2078) > (5300 - (316 + 289)))) then
					if (((7044 - 4353) >= (86 + 1765)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1461 - (666 + 787)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((3410 - (360 + 65)) >= (4539 + 317))) then
					if (((4530 - (79 + 175)) >= (1884 - 689)) and v25(v100.ShieldofVengeance, not v17:IsInRange(7 + 1))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v135 = 2 - 1;
			end
		end
	end
	local function v121()
		local v136 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (19 - 9))) or (v108 < (924 - (503 + 396))));
		if (((3413 - (92 + 89)) <= (9098 - 4408)) and v136) then
			return v136;
		end
		if ((v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) or ((460 + 436) >= (1862 + 1284))) then
			if (((11987 - 8926) >= (405 + 2553)) and v25(v100.LightsJudgment, not v17:IsInRange(91 - 51))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((2781 + 406) >= (308 + 336)) and v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (30 - 20))))) then
			if (((81 + 563) <= (1073 - 369)) and v25(v100.Fireblood, not v17:IsInRange(1254 - (485 + 759)))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((2216 - 1258) > (2136 - (442 + 747))) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(1143 - (832 + 303))) then
			v30 = v119();
			if (((5438 - (88 + 858)) >= (809 + 1845)) and v30) then
				return v30;
			end
		end
		if (((2849 + 593) >= (62 + 1441)) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (804 - (766 + 23))) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
			if (v25(v100.ShieldofVengeance) or ((15649 - 12479) <= (2002 - 538))) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if ((v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (39 - 24))) or (v15:BuffStack(v100.CrusadeBuff) == (33 - 23)) or (v100.AvengingWrath:CooldownRemains() < (1073.75 - (1036 + 37))) or (v100.AvengingWrath:CooldownRemains() > (11 + 4))) and (((v110 >= (7 - 3)) and (v10.CombatTime() < (4 + 1))) or ((v110 >= (1483 - (641 + 839))) and (v10.CombatTime() > (918 - (910 + 3)))) or ((v110 >= (4 - 2)) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (1692 - (1466 + 218))) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (6 + 6)))) or ((5945 - (556 + 592)) == (1561 + 2827))) then
			if (((1359 - (329 + 479)) <= (1535 - (174 + 680))) and v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((11260 - 7983) > (843 - 436)) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (744 - (396 + 343)))) or ((v110 >= (1 + 2)) and (v10.CombatTime() > (1482 - (29 + 1448)))) or ((v110 >= (1391 - (135 + 1254))) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v100.ExecutionSentence:CooldownRemains() > (70 - 55)) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (0 + 0)) or (v100.FinalReckoning:CooldownRemains() > (1557 - (389 + 1138))) or not v100.FinalReckoning:IsReady())))))) then
			if (((5269 - (102 + 472)) >= (1336 + 79)) and v25(v100.AvengingWrath, not v17:IsInRange(6 + 4))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (5 + 0)) and (v10.CombatTime() < (1550 - (320 + 1225)))) or ((v110 >= (5 - 2)) and (v10.CombatTime() > (4 + 1))))) or ((4676 - (157 + 1307)) <= (2803 - (821 + 1038)))) then
			if (v25(v100.Crusade, not v17:IsInRange(24 - 14)) or ((339 + 2757) <= (3193 - 1395))) then
				return "crusade cooldowns 14";
			end
		end
		if (((1316 + 2221) == (8766 - 5229)) and v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (1030 - (834 + 192))) and (v10.CombatTime() < (1 + 7))) or ((v110 >= (1 + 2)) and (v10.CombatTime() >= (1 + 7))) or ((v110 >= (2 - 0)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (314 - (300 + 4))) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (3 + 7))))) and ((v109 > (0 - 0)) or (v110 == (367 - (112 + 250))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable()))) then
			if (((9612 - 5775) >= (900 + 670)) and (v98 == "player")) then
				if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(6 + 4)) or ((2207 + 743) == (1891 + 1921))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if (((3509 + 1214) >= (3732 - (1001 + 413))) and (v98 == "cursor")) then
				if (v25(v104.FinalReckoningCursor, not v17:IsInRange(44 - 24)) or ((2909 - (244 + 638)) > (3545 - (627 + 66)))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v122()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (604 - (512 + 90))) or ((3042 - (1665 + 241)) > (5034 - (373 + 344)))) then
				if (((2142 + 2606) == (1257 + 3491)) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (7 - 4))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (16 - 6))))) then
					if (((4835 - (35 + 1064)) <= (3449 + 1291)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if (((2 - 1) == v137) or ((14 + 3376) <= (4296 - (298 + 938)))) then
				if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1262 - (233 + 1026)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1676 - (636 + 1030)))))) or ((511 + 488) > (2631 + 62))) then
					if (((138 + 325) < (41 + 560)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (224 - (55 + 166)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (2 + 8))))) or ((220 + 1963) < (2623 - 1936))) then
					if (((4846 - (36 + 261)) == (7955 - 3406)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v137 = 1370 - (34 + 1334);
			end
			if (((1797 + 2875) == (3631 + 1041)) and (v137 == (1283 - (1035 + 248)))) then
				v112 = ((v106 >= (24 - (20 + 1))) or ((v106 >= (2 + 0)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (343 - (134 + 185))));
				if ((v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1136 - (549 + 584)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (695 - (314 + 371)))))) or ((12591 - 8923) < (1363 - (478 + 490)))) then
					if (v25(v100.DivineStorm, not v17:IsInRange(6 + 4)) or ((5338 - (786 + 386)) == (1473 - 1018))) then
						return "divine_storm finishers 2";
					end
				end
				v137 = 1380 - (1055 + 324);
			end
		end
	end
	local function v123()
		local v138 = 1340 - (1093 + 247);
		while true do
			if ((v138 == (2 + 0)) or ((468 + 3981) == (10572 - 7909))) then
				if (((v110 >= (9 - 6)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (28 - 18))) or ((10747 - 6470) < (1064 + 1925))) then
					v30 = v122();
					if (v30 or ((3351 - 2481) >= (14300 - 10151))) then
						return v30;
					end
				end
				if (((1668 + 544) < (8139 - 4956)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (692 - (364 + 324))) and (v106 >= (5 - 3))) then
					if (((11148 - 6502) > (992 + 2000)) and v25(v100.TemplarSlash, not v17:IsInRange(41 - 31))) then
						return "templar_slash generators 8";
					end
				end
				if (((2296 - 862) < (9433 - 6327)) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1271 - (1249 + 19))) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (2 + 0)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (15 - 11)))) then
					if (((1872 - (686 + 400)) < (2372 + 651)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v138 = 232 - (73 + 156);
			end
			if ((v138 == (0 + 0)) or ((3253 - (721 + 90)) < (1 + 73))) then
				if (((14724 - 10189) == (5005 - (224 + 246))) and ((v110 >= (8 - 3)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(56 - 25, 1 + 3) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (1 + 3))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(23 + 8, 3 - 1)))) then
					local v205 = 0 - 0;
					while true do
						if (((513 - (203 + 310)) == v205) or ((5002 - (1238 + 755)) <= (148 + 1957))) then
							v30 = v122();
							if (((3364 - (709 + 825)) < (6760 - 3091)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (3 - 0)) and v15:HasTier(895 - (196 + 668), 7 - 5)) or ((2962 - 1532) >= (4445 - (171 + 662)))) then
					if (((2776 - (4 + 89)) >= (8622 - 6162)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v100.WakeofAshes:IsCastable() and v49 and (v110 <= (1 + 1)) and ((v100.AvengingWrath:CooldownRemains() > (0 - 0)) or (v100.Crusade:CooldownRemains() > (0 + 0)) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (1490 - (35 + 1451))) or (v108 < (1461 - (28 + 1425))) or not v100.ExecutionSentence:IsReady())) or ((3797 - (941 + 1052)) >= (3141 + 134))) then
					if (v25(v100.WakeofAshes, not v17:IsInRange(1524 - (822 + 692))) or ((2022 - 605) > (1710 + 1919))) then
						return "wake_of_ashes generators 2";
					end
				end
				v138 = 298 - (45 + 252);
			end
			if (((4745 + 50) > (139 + 263)) and (v138 == (14 - 8))) then
				if (((5246 - (114 + 319)) > (5118 - 1553)) and v30) then
					return v30;
				end
				if (((5012 - 1100) == (2494 + 1418)) and v100.TemplarSlash:IsReady() and v47) then
					if (((4202 - 1381) <= (10107 - 5283)) and v25(v100.TemplarSlash, not v17:IsInRange(1973 - (556 + 1407)))) then
						return "templar_slash generators 28";
					end
				end
				if (((2944 - (741 + 465)) <= (2660 - (170 + 295))) and v100.TemplarStrike:IsReady() and v48) then
					if (((22 + 19) <= (2773 + 245)) and v25(v100.TemplarStrike, not v17:IsInRange(24 - 14))) then
						return "templar_strike generators 30";
					end
				end
				v138 = 6 + 1;
			end
			if (((1376 + 769) <= (2324 + 1780)) and (v138 == (1237 - (957 + 273)))) then
				if (((720 + 1969) < (1940 + 2905)) and v100.Judgment:IsReady() and v45 and ((v110 <= (11 - 8)) or not v100.BoundlessJudgment:IsAvailable())) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((6118 - 3796) > (8008 - 5386))) then
						return "judgment generators 32";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44 and ((v110 <= (14 - 11)) or (v17:HealthPercentage() > (1800 - (389 + 1391))) or not v100.VanguardsMomentum:IsAvailable())) or ((2845 + 1689) == (217 + 1865))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((3576 - 2005) > (2818 - (783 + 168)))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((8907 - 6253) >= (2947 + 49))) then
					if (((4289 - (309 + 2)) > (6460 - 4356)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v138 = 1220 - (1090 + 122);
			end
			if (((972 + 2023) > (5175 - 3634)) and (v138 == (6 + 2))) then
				if (((4367 - (628 + 490)) > (171 + 782)) and v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (12 - 7)) and (v86 < v108)) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(45 - 35)) or ((4047 - (431 + 343)) > (9235 - 4662))) then
						return "arcane_torrent generators 28";
					end
				end
				if ((v100.Consecration:IsCastable() and v38) or ((9115 - 5964) < (1015 + 269))) then
					if (v25(v100.Consecration, not v17:IsInRange(2 + 8)) or ((3545 - (556 + 1139)) == (1544 - (6 + 9)))) then
						return "consecration generators 30";
					end
				end
				if (((151 + 670) < (1088 + 1035)) and v100.DivineHammer:IsCastable() and v40) then
					if (((1071 - (28 + 141)) < (901 + 1424)) and v25(v100.DivineHammer, not v17:IsInRange(12 - 2))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((608 + 250) <= (4279 - (486 + 831))) and (v138 == (12 - 7))) then
				if ((v100.DivineHammer:IsCastable() and v40 and (v106 >= (6 - 4))) or ((746 + 3200) < (4072 - 2784))) then
					if (v25(v100.DivineHammer, not v17:IsInRange(1273 - (668 + 595))) or ((2918 + 324) == (115 + 452))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (2.75 - 1)) and ((v110 <= (292 - (23 + 267))) or ((v110 <= (1947 - (1129 + 815))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (389 - (371 + 16))))) or ((v110 == (1754 - (1326 + 424))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (3 - 1))) and (v100.Judgment:CooldownRemains() > (v111 * (7 - 5)))))) or ((965 - (88 + 30)) >= (2034 - (720 + 51)))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((5011 - 2758) == (3627 - (421 + 1355)))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				v138 = 9 - 3;
			end
			if ((v138 == (1 + 0)) or ((3170 - (286 + 797)) > (8671 - 6299))) then
				if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (4 - 1)) and v15:HasTier(470 - (397 + 42), 1 + 1)) or ((5245 - (24 + 776)) < (6391 - 2242))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((2603 - (222 + 563)) == (187 - 102))) then
						return "blade_of_justice generators 4";
					end
				end
				if (((454 + 176) < (2317 - (23 + 167))) and v100.DivineToll:IsCastable() and v42 and (v110 <= (1800 - (690 + 1108))) and ((v100.AvengingWrath:CooldownRemains() > (6 + 9)) or (v100.Crusade:CooldownRemains() > (13 + 2)) or (v108 < (856 - (40 + 808))))) then
					if (v25(v100.DivineToll, not v17:IsInRange(5 + 25)) or ((7410 - 5472) == (2403 + 111))) then
						return "divine_toll generators 6";
					end
				end
				if (((2251 + 2004) >= (31 + 24)) and v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(602 - (47 + 524), 2 + 0)) then
					if (((8197 - 5198) > (1728 - 572)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 7";
					end
				end
				v138 = 4 - 2;
			end
			if (((4076 - (1165 + 561)) > (35 + 1120)) and (v138 == (12 - 8))) then
				if (((1538 + 2491) <= (5332 - (341 + 138))) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1 + 2)) or not v100.HolyBlade:IsAvailable())) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1064 - 548) > (3760 - (89 + 237)))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((13015 - 8969) >= (6385 - 3352)) and ((v17:HealthPercentage() <= (901 - (581 + 300))) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
					v30 = v122();
					if (v30 or ((3939 - (855 + 365)) <= (3436 - 1989))) then
						return v30;
					end
				end
				if ((v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (1 + 1))) or ((5369 - (1030 + 205)) < (3686 + 240))) then
					if (v25(v100.Consecration, not v17:IsInRange(10 + 0)) or ((450 - (156 + 130)) >= (6328 - 3543))) then
						return "consecration generators 22";
					end
				end
				v138 = 8 - 3;
			end
			if ((v138 == (5 - 2)) or ((139 + 386) == (1230 + 879))) then
				if (((102 - (10 + 59)) == (10 + 23)) and v100.HammerofWrath:IsReady() and v44 and ((v106 < (9 - 7)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(1193 - (671 + 492), 4 + 0)) and ((v110 <= (1218 - (369 + 846))) or (v17:HealthPercentage() > (6 + 14)) or not v100.VanguardsMomentum:IsAvailable())) then
					if (((2607 + 447) <= (5960 - (1036 + 909))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((1488 + 383) < (5677 - 2295)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (207 - (11 + 192)))) then
					if (((654 + 639) <= (2341 - (135 + 40))) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (6 - 3)) or not v100.BoundlessJudgment:IsAvailable())) or ((1555 + 1024) < (270 - 147))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((1267 - 421) >= (2544 - (50 + 126)))) then
						return "judgment generators 16";
					end
				end
				v138 = 11 - 7;
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((1420 - (1233 + 180)) == v139) or ((4981 - (522 + 447)) <= (4779 - (107 + 1314)))) then
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if (((694 + 800) <= (9156 - 6151)) and (v139 == (3 + 2))) then
				v50 = EpicSettings.Settings['useVerdict'];
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v139 = 11 - 5;
			end
			if ((v139 == (0 - 0)) or ((5021 - (716 + 1194)) == (37 + 2097))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v139 = 1 + 0;
			end
			if (((2858 - (74 + 429)) == (4543 - 2188)) and (v139 == (2 + 2))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v139 = 11 - 6;
			end
			if ((v139 == (2 + 0)) or ((1812 - 1224) <= (1067 - 635))) then
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v139 = 436 - (279 + 154);
			end
			if (((5575 - (454 + 324)) >= (3065 + 830)) and (v139 == (20 - (12 + 5)))) then
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v139 = 3 + 1;
			end
			if (((9114 - 5537) == (1322 + 2255)) and (v139 == (1099 - (277 + 816)))) then
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v139 = 29 - 22;
			end
			if (((4977 - (1058 + 125)) > (693 + 3000)) and (v139 == (976 - (815 + 160)))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v139 = 8 - 6;
			end
		end
	end
	local function v125()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1 + 1)) or ((3727 - 2452) == (5998 - (41 + 1857)))) then
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (1893 - (1222 + 671));
				v70 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v140 = 3 - 0;
			end
			if ((v140 == (1187 - (229 + 953))) or ((3365 - (1111 + 663)) >= (5159 - (874 + 705)))) then
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((138 + 845) <= (1234 + 574)) and (v140 == (7 - 3))) then
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (679 - (642 + 37));
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v140 = 2 + 3;
			end
			if ((v140 == (0 + 0)) or ((5398 - 3248) <= (1651 - (233 + 221)))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v62 = EpicSettings.Settings['useDivineShield'];
				v140 = 2 - 1;
			end
			if (((3318 + 451) >= (2714 - (718 + 823))) and (v140 == (1 + 0))) then
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayonHandsFocus'];
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v140 = 807 - (266 + 539);
			end
			if (((4204 - 2719) == (2710 - (636 + 589))) and ((6 - 3) == v140)) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v72 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (1015 - (657 + 358));
				v140 = 10 - 6;
			end
		end
	end
	local function v126()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (1191 - (1151 + 36))) or ((3202 + 113) <= (732 + 2050))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (1832 - (1552 + 280));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v141 = 839 - (64 + 770);
			end
			if (((3 + 0) == v141) or ((1988 - 1112) >= (527 + 2437))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v141 = 1247 - (157 + 1086);
			end
			if ((v141 == (1 - 0)) or ((9775 - 7543) > (3830 - 1333))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v141 = 2 - 0;
			end
			if ((v141 == (824 - (599 + 220))) or ((4201 - 2091) <= (2263 - (1813 + 118)))) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v141 = 5 + 1;
			end
			if (((4903 - (841 + 376)) > (4444 - 1272)) and (v141 == (0 + 0))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v141 = 860 - (464 + 395);
			end
			if (((5 - 3) == v141) or ((2149 + 2325) < (1657 - (467 + 370)))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v141 = 5 - 2;
			end
			if (((3142 + 1137) >= (9879 - 6997)) and (v141 == (1 + 5))) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
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
		if (v15:IsDeadOrGhost() or ((2549 - (150 + 370)) >= (4803 - (74 + 1208)))) then
			return v30;
		end
		v105 = v15:GetEnemiesInMeleeRange(19 - 11);
		if (v32 or ((9660 - 7623) >= (3304 + 1338))) then
			v106 = #v105;
		else
			v105 = {};
			v106 = 391 - (14 + 376);
		end
		if (((2983 - 1263) < (2885 + 1573)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) or ((384 + 52) > (2882 + 139))) then
				if (((2089 - 1376) <= (638 + 209)) and v25(v100.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		v109 = v113();
		if (((2232 - (23 + 55)) <= (9553 - 5522)) and not v15:AffectingCombat()) then
			if (((3080 + 1535) == (4145 + 470)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
				if (v25(v100.RetributionAura) or ((5876 - 2086) == (158 + 342))) then
					return "retribution_aura";
				end
			end
		end
		if (((990 - (652 + 249)) < (591 - 370)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (((3922 - (708 + 1160)) >= (3857 - 2436)) and v15:AffectingCombat()) then
				if (((1261 - 569) < (3085 - (10 + 17))) and v100.Intercession:IsCastable()) then
					if (v25(v100.Intercession, not v17:IsInRange(7 + 23), true) or ((4986 - (1400 + 332)) == (3174 - 1519))) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((3204 - (242 + 1666)) == (2102 + 2808))) then
				if (((1235 + 2133) == (2871 + 497)) and v25(v100.Redemption, not v17:IsInRange(970 - (850 + 90)), true)) then
					return "redemption target";
				end
			end
		end
		if (((4628 - 1985) < (5205 - (360 + 1030))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (((1693 + 220) > (1390 - 897)) and v25(v104.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((6541 - 1786) > (5089 - (909 + 752))) and v15:AffectingCombat()) then
			if (((2604 - (109 + 1114)) <= (4336 - 1967)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (2 + 1)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v104.IntercessionMouseover) or ((5085 - (6 + 236)) == (2574 + 1510))) then
					return "Intercession mouseover";
				end
			end
		end
		if (((3759 + 910) > (855 - 492)) and (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()))) then
			local v149 = 0 - 0;
			local v150;
			while true do
				if ((v149 == (1134 - (1076 + 57))) or ((309 + 1568) >= (3827 - (579 + 110)))) then
					if (((375 + 4367) >= (3206 + 420)) and v30) then
						return v30;
					end
					break;
				end
				if ((v149 == (0 + 0)) or ((4947 - (174 + 233)) == (2558 - 1642))) then
					v150 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v150, nil, 35 - 15, nil, 12 + 13, v100.FlashofLight);
					v149 = 1175 - (663 + 511);
				end
			end
		end
		if (v34 or ((1032 + 124) > (944 + 3401))) then
			local v151 = 0 - 0;
			while true do
				if (((1355 + 882) < (10003 - 5754)) and (v151 == (0 - 0))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 20 + 20, 48 - 23, v100.FlashofLight);
					if (v30 or ((1913 + 770) < (3 + 20))) then
						return v30;
					end
					v151 = 723 - (478 + 244);
				end
				if (((1214 - (440 + 77)) <= (376 + 450)) and (v151 == (3 - 2))) then
					if (((2661 - (655 + 901)) <= (219 + 957)) and v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (((2587 + 792) <= (2574 + 1238)) and v25(v104.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (v99.TargetIsValid() or v15:AffectingCombat() or ((3174 - 2386) >= (3061 - (695 + 750)))) then
			v107 = v10.BossFightRemains(nil, true);
			v108 = v107;
			if (((6330 - 4476) <= (5214 - 1835)) and (v108 == (44685 - 33574))) then
				v108 = v10.FightRemains(v105, false);
			end
			v111 = v15:GCD();
			v110 = v15:HolyPower();
		end
		if (((4900 - (285 + 66)) == (10603 - 6054)) and v81) then
			if (v77 or ((4332 - (682 + 628)) >= (488 + 2536))) then
				v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 339 - (176 + 123));
				if (((2017 + 2803) > (1595 + 603)) and v30) then
					return v30;
				end
			end
			if ((v78 and (v110 > (271 - (239 + 30)))) or ((289 + 772) >= (4701 + 190))) then
				v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 70 - 30, true);
				if (((4255 - 2891) <= (4788 - (306 + 9))) and v30) then
					return v30;
				end
			end
		end
		if (v82 or ((12545 - 8950) <= (1 + 2))) then
			local v152 = 0 + 0;
			while true do
				if ((v152 == (1 + 0)) or ((13359 - 8687) == (5227 - (1140 + 235)))) then
					v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 20 + 10, true);
					if (((1430 + 129) == (401 + 1158)) and v30) then
						return v30;
					end
					break;
				end
				if ((v152 == (52 - (33 + 19))) or ((633 + 1119) <= (2361 - 1573))) then
					v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 14 + 16, true);
					if (v30 or ((7661 - 3754) == (166 + 11))) then
						return v30;
					end
					v152 = 690 - (586 + 103);
				end
			end
		end
		v30 = v117();
		if (((316 + 3154) > (1708 - 1153)) and v30) then
			return v30;
		end
		if ((v80 and v34) or ((2460 - (1309 + 179)) == (1164 - 519))) then
			if (((1385 + 1797) >= (5679 - 3564)) and v14) then
				v30 = v116();
				if (((2941 + 952) < (9409 - 4980)) and v30) then
					return v30;
				end
			end
			if ((v16 and v16:Exists() and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16))) or ((5712 - 2845) < (2514 - (295 + 314)))) then
				if (v100.CleanseToxins:IsReady() or ((4411 - 2615) >= (6013 - (1300 + 662)))) then
					if (((5083 - 3464) <= (5511 - (1178 + 577))) and v25(v104.CleanseToxinsMouseover)) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v30 = v118();
		if (((314 + 290) == (1785 - 1181)) and v30) then
			return v30;
		end
		if ((not v15:AffectingCombat() and v31 and v99.TargetIsValid()) or ((5889 - (851 + 554)) == (796 + 104))) then
			local v153 = 0 - 0;
			while true do
				if (((0 - 0) == v153) or ((4761 - (115 + 187)) <= (853 + 260))) then
					v30 = v120();
					if (((3439 + 193) > (13390 - 9992)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((5243 - (160 + 1001)) <= (4302 + 615)) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
			if (((3334 + 1498) >= (2836 - 1450)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
				if (((495 - (237 + 121)) == (1034 - (525 + 372))) and v25(v100.LayonHands)) then
					return "lay_on_hands_player defensive";
				end
			end
			if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((2976 - 1406) >= (14233 - 9901))) then
				if (v25(v100.DivineShield) or ((4206 - (96 + 46)) <= (2596 - (643 + 134)))) then
					return "divine_shield defensive";
				end
			end
			if ((v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) or ((1800 + 3186) < (3774 - 2200))) then
				if (((16432 - 12006) > (165 + 7)) and v25(v100.DivineProtection)) then
					return "divine_protection defensive";
				end
			end
			if (((1149 - 563) > (930 - 475)) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
				if (((1545 - (316 + 403)) == (550 + 276)) and v25(v104.Healthstone)) then
					return "healthstone defensive";
				end
			end
			if ((v91 and (v15:HealthPercentage() <= v93)) or ((11049 - 7030) > (1605 + 2836))) then
				local v204 = 0 - 0;
				while true do
					if (((1430 + 587) < (1374 + 2887)) and (v204 == (0 - 0))) then
						if (((22522 - 17806) > (166 - 86)) and (v95 == "Refreshing Healing Potion")) then
							if (v101.RefreshingHealingPotion:IsReady() or ((201 + 3306) == (6441 - 3169))) then
								if (v25(v104.RefreshingHealingPotion) or ((43 + 833) >= (9046 - 5971))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((4369 - (12 + 5)) > (9919 - 7365)) and (v95 == "Dreamwalker's Healing Potion")) then
							if (v101.DreamwalkersHealingPotion:IsReady() or ((9400 - 4994) < (8594 - 4551))) then
								if (v25(v104.RefreshingHealingPotion) or ((4684 - 2795) >= (687 + 2696))) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
						break;
					end
				end
			end
			if (((3865 - (1656 + 317)) <= (2437 + 297)) and (v86 < v108)) then
				v30 = v121();
				if (((1541 + 382) < (5897 - 3679)) and v30) then
					return v30;
				end
				if (((10694 - 8521) > (733 - (5 + 349))) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) then
					if (v25(v104.UseWeapon) or ((12306 - 9715) == (4680 - (266 + 1005)))) then
						return "Fyralath The Dreamrender used";
					end
				end
			end
			v30 = v123();
			if (((2975 + 1539) > (11341 - 8017)) and v30) then
				return v30;
			end
			if (v25(v100.Pool) or ((273 - 65) >= (6524 - (561 + 1135)))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v128()
		local v146 = 0 - 0;
		while true do
			if (((0 - 0) == v146) or ((2649 - (507 + 559)) > (8950 - 5383))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v103();
				break;
			end
		end
	end
	v21.SetAPL(216 - 146, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

