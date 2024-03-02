local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 370 - (360 + 10);
	local v6;
	while true do
		if (((901 + 505) < (208 + 1686)) and (v5 == (1047 - (82 + 964)))) then
			return v6(...);
		end
		if (((1525 + 47) >= (2043 - (409 + 103))) and (v5 == (236 - (46 + 190)))) then
			v6 = v0[v4];
			if (not v6 or ((4782 - (51 + 44)) < (1282 + 3260))) then
				return v1(v4, ...);
			end
			v5 = 1318 - (1114 + 203);
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
		if (((4017 - (228 + 498)) > (362 + 1305)) and v100.CleanseToxins:IsAvailable()) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 6139 + 4972;
	local v108 = 11774 - (174 + 489);
	local v109;
	local v110 = 0 - 0;
	local v111 = 1905 - (830 + 1075);
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 524 - (303 + 221);
		while true do
			if ((v129 == (1269 - (231 + 1038))) or ((728 + 145) == (3196 - (171 + 991)))) then
				v107 = 45790 - 34679;
				v108 = 29835 - 18724;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = 0 - 0;
		local v131;
		local v132;
		while true do
			if ((v130 == (1 + 0)) or ((9871 - 7055) < (31 - 20))) then
				if (((5962 - 2263) < (14547 - 9841)) and (v131 > v132)) then
					return v131;
				end
				return v132;
			end
			if (((3894 - (111 + 1137)) >= (1034 - (91 + 67))) and (v130 == (0 - 0))) then
				v131 = v15:GCDRemains();
				v132 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (3 + 7), v100.WakeofAshes:CooldownRemains());
				v130 = 524 - (423 + 100);
			end
		end
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 0 + 0;
	local function v116()
		if (((1699 - 1085) <= (1660 + 1524)) and v100.CleanseToxins:IsReady() and v99.DispellableFriendlyUnit(796 - (326 + 445))) then
			local v148 = 0 - 0;
			while true do
				if (((6963 - 3837) == (7296 - 4170)) and (v148 == (711 - (530 + 181)))) then
					if ((v115 == (881 - (614 + 267))) or ((2219 - (19 + 13)) >= (8063 - 3109))) then
						v115 = GetTime();
					end
					if (v99.Wait(1165 - 665, v115) or ((11075 - 7198) == (929 + 2646))) then
						if (((1243 - 536) > (1310 - 678)) and v25(v104.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v115 = 1812 - (1293 + 519);
					end
					break;
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((1113 - 567) >= (7007 - 4323))) then
			if (((2801 - 1336) <= (18546 - 14245)) and v100.FlashofLight:IsReady()) then
				if (((4014 - 2310) > (755 + 670)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 - 0)) or ((159 + 528) == (1407 + 2827))) then
				if (v16:Exists() or ((2081 + 1249) < (2525 - (709 + 387)))) then
					if (((3005 - (673 + 1185)) >= (971 - 636)) and v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) then
						if (((11030 - 7595) > (3449 - 1352)) and v25(v104.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(22 + 8) or ((2817 + 953) >= (5455 - 1414))) then
					return;
				end
				v133 = 1 + 0;
			end
			if ((v133 == (1 - 0)) or ((7441 - 3650) <= (3491 - (446 + 1434)))) then
				if (v14 or ((5861 - (1040 + 243)) <= (5993 - 3985))) then
					local v210 = 1847 - (559 + 1288);
					while true do
						if (((3056 - (609 + 1322)) <= (2530 - (13 + 441))) and (v210 == (3 - 2))) then
							if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((1946 - 1203) >= (21908 - 17509))) then
								if (((44 + 1111) < (6075 - 4402)) and v25(v104.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((826 + 1498) <= (254 + 324))) then
								if (((11178 - 7411) == (2062 + 1705)) and v25(v104.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if (((7520 - 3431) == (2704 + 1385)) and (v210 == (0 + 0))) then
							if (((3204 + 1254) >= (1406 + 268)) and v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) then
								if (((951 + 21) <= (1851 - (153 + 280))) and v25(v104.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) or ((14258 - 9320) < (4276 + 486))) then
								if (v25(v104.LayonHandsFocus) or ((989 + 1515) > (2232 + 2032))) then
									return "lay_on_hands defensive focus";
								end
							end
							v210 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if (((3278 - 1125) == (1331 + 822)) and (v134 == (668 - (89 + 578)))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 29 + 11, nil);
				if (v30 or ((1053 - 546) >= (3640 - (572 + 477)))) then
					return v30;
				end
				break;
			end
			if (((605 + 3876) == (2690 + 1791)) and (v134 == (0 + 0))) then
				v30 = v99.HandleTopTrinket(v102, v33, 126 - (84 + 2), nil);
				if (v30 or ((3836 - 1508) < (500 + 193))) then
					return v30;
				end
				v134 = 843 - (497 + 345);
			end
		end
	end
	local function v120()
		local v135 = 0 + 0;
		while true do
			if (((732 + 3596) == (5661 - (605 + 728))) and ((0 + 0) == v135)) then
				if (((3530 - 1942) >= (62 + 1270)) and v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(29 - 21)) or ((3763 + 411) > (11769 - 7521))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((3463 + 1123) <= (571 - (457 + 32)))) then
					if (((1639 + 2224) == (5265 - (832 + 570))) and v25(v100.ShieldofVengeance, not v17:IsInRange(8 + 0))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v135 = 1 + 0;
			end
			if (((6 - 4) == v135) or ((136 + 146) <= (838 - (588 + 208)))) then
				if (((12422 - 7813) >= (2566 - (884 + 916))) and v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (8 - 4))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((668 + 484) == (3141 - (232 + 421)))) then
						return "templars verdict precombat 4";
					end
				end
				if (((5311 - (1569 + 320)) > (822 + 2528)) and v100.BladeofJustice:IsCastable() and v37) then
					if (((167 + 710) > (1266 - 890)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v135 = 608 - (316 + 289);
			end
			if ((v135 == (7 - 4)) or ((144 + 2974) <= (3304 - (666 + 787)))) then
				if ((v100.Judgment:IsCastable() and v45) or ((590 - (360 + 65)) >= (3264 + 228))) then
					if (((4203 - (79 + 175)) < (7656 - 2800)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44) or ((3337 + 939) < (9244 - 6228))) then
					if (((9032 - 4342) > (5024 - (503 + 396))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v135 = 185 - (92 + 89);
			end
			if (((1 - 0) == v135) or ((26 + 24) >= (531 + 365))) then
				if ((v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (15 - 11))) or ((235 + 1479) >= (6744 - 3786))) then
					if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((1301 + 190) < (308 + 336))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((2144 - 1440) < (124 + 863)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (5 - 1))) then
					if (((4962 - (485 + 759)) > (4410 - 2504)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v135 = 1191 - (442 + 747);
			end
			if ((v135 == (1139 - (832 + 303))) or ((1904 - (88 + 858)) > (1108 + 2527))) then
				if (((2898 + 603) <= (186 + 4306)) and v100.CrusaderStrike:IsCastable() and v39) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((4231 - (766 + 23)) < (12578 - 10030))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		local v137;
		while true do
			if (((7574 - 4699) >= (4968 - 3504)) and ((1074 - (1036 + 37)) == v136)) then
				if ((v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) or ((3401 + 1396) >= (9528 - 4635))) then
					if (v25(v100.LightsJudgment, not v17:IsInRange(32 + 8)) or ((2031 - (641 + 839)) > (2981 - (910 + 3)))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((5389 - 3275) > (2628 - (1466 + 218))) and v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (5 + 5))))) then
					if (v25(v100.Fireblood, not v17:IsInRange(1158 - (556 + 592))) or ((805 + 1457) >= (3904 - (329 + 479)))) then
						return "fireblood cooldowns 6";
					end
				end
				v136 = 856 - (174 + 680);
			end
			if ((v136 == (6 - 4)) or ((4673 - 2418) >= (2526 + 1011))) then
				if ((v87 and ((v33 and v88) or not v88) and v17:IsInRange(747 - (396 + 343))) or ((340 + 3497) < (2783 - (29 + 1448)))) then
					v30 = v119();
					if (((4339 - (135 + 1254)) == (11113 - 8163)) and v30) then
						return v30;
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (70 - 55)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) or ((3148 + 1575) < (4825 - (389 + 1138)))) then
					if (((1710 - (102 + 472)) >= (146 + 8)) and v25(v100.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v136 = 2 + 1;
			end
			if ((v136 == (4 + 0)) or ((1816 - (320 + 1225)) > (8452 - 3704))) then
				if (((2901 + 1839) >= (4616 - (157 + 1307))) and v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (1864 - (821 + 1038))) and (v10.CombatTime() < (12 - 7))) or ((v110 >= (1 + 2)) and (v10.CombatTime() > (8 - 3))))) then
					if (v25(v100.Crusade, not v17:IsInRange(4 + 6)) or ((6389 - 3811) >= (4416 - (834 + 192)))) then
						return "crusade cooldowns 14";
					end
				end
				if (((3 + 38) <= (427 + 1234)) and v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (1 + 3)) and (v10.CombatTime() < (12 - 4))) or ((v110 >= (307 - (300 + 4))) and (v10.CombatTime() >= (3 + 5))) or ((v110 >= (5 - 3)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (372 - (112 + 250))) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (4 + 6))))) and ((v109 > (0 - 0)) or (v110 == (3 + 2)) or ((v110 >= (2 + 0)) and v100.DivineAuxiliary:IsAvailable()))) then
					local v211 = 0 + 0;
					while true do
						if (((298 + 303) < (2645 + 915)) and (v211 == (1414 - (1001 + 413)))) then
							if (((524 - 289) < (1569 - (244 + 638))) and (v98 == "player")) then
								if (((5242 - (627 + 66)) > (3435 - 2282)) and v25(v104.FinalReckoningPlayer, not v17:IsInRange(612 - (512 + 90)))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v98 == "cursor") or ((6580 - (1665 + 241)) < (5389 - (373 + 344)))) then
								if (((1655 + 2013) < (1207 + 3354)) and v25(v104.FinalReckoningCursor, not v17:IsInRange(52 - 32))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v136 == (0 - 0)) or ((1554 - (35 + 1064)) == (2623 + 982))) then
				v137 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15.BuffStack(v100.Crusade) == (21 - 11))) or (v108 < (1 + 24)));
				if (v137 or ((3899 - (298 + 938)) == (4571 - (233 + 1026)))) then
					return v137;
				end
				v136 = 1667 - (636 + 1030);
			end
			if (((2187 + 2090) <= (4372 + 103)) and ((1 + 2) == v136)) then
				if ((v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (2 + 13))) or (v15:BuffStack(v100.CrusadeBuff) == (231 - (55 + 166))) or (v100.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v100.AvengingWrath:CooldownRemains() > (2 + 13))) and (((v110 >= (15 - 11)) and (v10.CombatTime() < (302 - (36 + 261)))) or ((v110 >= (4 - 1)) and (v10.CombatTime() > (1373 - (34 + 1334)))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (7 + 1)) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (1295 - (1035 + 248))))) or ((891 - (20 + 1)) == (620 + 569))) then
					if (((1872 - (134 + 185)) <= (4266 - (549 + 584))) and v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (689 - (314 + 371))) and (v10.CombatTime() < (17 - 12))) or ((v110 >= (971 - (478 + 490))) and (v10.CombatTime() > (3 + 2))) or ((v110 >= (1174 - (786 + 386))) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v100.ExecutionSentence:CooldownRemains() > (1394 - (1055 + 324))) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (1340 - (1093 + 247))) or (v100.FinalReckoning:CooldownRemains() > (27 + 3)) or not v100.FinalReckoning:IsReady())))))) or ((236 + 2001) >= (13939 - 10428))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(33 - 23)) or ((3767 - 2443) > (7588 - 4568))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v136 = 2 + 2;
			end
		end
	end
	local function v122()
		v112 = ((v106 >= (11 - 8)) or ((v106 >= (6 - 4)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (19 + 5)));
		if ((v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (7 - 4))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (698 - (364 + 324)))))) or ((8201 - 5209) == (4513 - 2632))) then
			if (((1030 + 2076) > (6385 - 4859)) and v25(v100.DivineStorm, not v17:IsInRange(16 - 6))) then
				return "divine_storm finishers 2";
			end
		end
		if (((9181 - 6158) < (5138 - (1249 + 19))) and v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (3 + 0))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (38 - 28))))) then
			if (((1229 - (686 + 400)) > (59 + 15)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((247 - (73 + 156)) < (10 + 2102)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (814 - (721 + 90)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) then
			if (((3561 - 2464) <= (2098 - (224 + 246))) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if (((7500 - 2870) == (8524 - 3894)) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1 + 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) then
			if (((2601 + 939) > (5334 - 2651)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v123()
		if (((15953 - 11159) >= (3788 - (203 + 310))) and ((v110 >= (1998 - (1238 + 755))) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(3 + 28, 1538 - (709 + 825)) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (7 - 3))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(44 - 13, 866 - (196 + 668))))) then
			local v149 = 0 - 0;
			while true do
				if (((3073 - 1589) == (2317 - (171 + 662))) and ((93 - (4 + 89)) == v149)) then
					v30 = v122();
					if (((5018 - 3586) < (1295 + 2260)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (13 - 10)) and v15:HasTier(13 + 18, 1488 - (35 + 1451))) or ((2518 - (28 + 1425)) > (5571 - (941 + 1052)))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((4598 + 197) < (2921 - (822 + 692)))) then
				return "blade_of_justice generators 1";
			end
		end
		if (((2644 - 791) < (2268 + 2545)) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (299 - (45 + 252))) and ((v100.AvengingWrath:CooldownRemains() > (0 + 0)) or (v100.Crusade:CooldownRemains() > (0 + 0)) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (9 - 5)) or (v108 < (441 - (114 + 319))) or not v100.ExecutionSentence:IsReady())) then
			if (v25(v100.WakeofAshes, not v17:IsInRange(14 - 4)) or ((3614 - 793) < (1550 + 881))) then
				return "wake_of_ashes generators 2";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (4 - 1)) and v15:HasTier(64 - 33, 1965 - (556 + 1407))) or ((4080 - (741 + 465)) < (2646 - (170 + 295)))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1417 + 1272) <= (316 + 27))) then
				return "blade_of_justice generators 4";
			end
		end
		if ((v100.DivineToll:IsCastable() and v42 and (v110 <= (4 - 2)) and ((v100.AvengingWrath:CooldownRemains() > (13 + 2)) or (v100.Crusade:CooldownRemains() > (10 + 5)) or (v108 < (5 + 3)))) or ((3099 - (957 + 273)) == (538 + 1471))) then
			if (v25(v100.DivineToll, not v17:IsInRange(13 + 17)) or ((13511 - 9965) < (6118 - 3796))) then
				return "divine_toll generators 6";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(94 - 63, 9 - 7)) or ((3862 - (389 + 1391)) == (2995 + 1778))) then
			if (((338 + 2906) > (2401 - 1346)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment generators 7";
			end
		end
		if (((v110 >= (954 - (783 + 168))) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (33 - 23))) or ((3259 + 54) <= (2089 - (309 + 2)))) then
			local v150 = 0 - 0;
			while true do
				if ((v150 == (1212 - (1090 + 122))) or ((461 + 960) >= (7066 - 4962))) then
					v30 = v122();
					if (((1241 + 571) <= (4367 - (628 + 490))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((292 + 1331) <= (4844 - 2887)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (18 - 14)) and (v106 >= (776 - (431 + 343)))) then
			if (((8910 - 4498) == (12763 - 8351)) and v25(v100.TemplarSlash, not v17:IsInRange(8 + 2))) then
				return "templar_slash generators 8";
			end
		end
		if (((224 + 1526) >= (2537 - (556 + 1139))) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (18 - (6 + 9))) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (1 + 1)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (3 + 1)))) then
			if (((4541 - (28 + 141)) > (717 + 1133)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 10";
			end
		end
		if (((285 - 53) < (582 + 239)) and v100.HammerofWrath:IsReady() and v44 and ((v106 < (1319 - (486 + 831))) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(78 - 48, 13 - 9)) and ((v110 <= (1 + 2)) or (v17:HealthPercentage() > (63 - 43)) or not v100.VanguardsMomentum:IsAvailable())) then
			if (((1781 - (668 + 595)) < (812 + 90)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if (((604 + 2390) > (2339 - 1481)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (294 - (23 + 267)))) then
			if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((5699 - (1129 + 815)) <= (1302 - (371 + 16)))) then
				return "templar_slash generators 14";
			end
		end
		if (((5696 - (1326 + 424)) > (7088 - 3345)) and v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (10 - 7)) or not v100.BoundlessJudgment:IsAvailable())) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((1453 - (88 + 30)) >= (4077 - (720 + 51)))) then
				return "judgment generators 16";
			end
		end
		if (((10775 - 5931) > (4029 - (421 + 1355))) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (4 - 1)) or not v100.HolyBlade:IsAvailable())) then
			if (((223 + 229) == (1535 - (286 + 797))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if ((v17:HealthPercentage() <= (73 - 53)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff) or ((7548 - 2991) < (2526 - (397 + 42)))) then
			v30 = v122();
			if (((1210 + 2664) == (4674 - (24 + 776))) and v30) then
				return v30;
			end
		end
		if ((v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (2 - 0))) or ((2723 - (222 + 563)) > (10873 - 5938))) then
			if (v25(v100.Consecration, not v17:IsInRange(8 + 2)) or ((4445 - (23 + 167)) < (5221 - (690 + 1108)))) then
				return "consecration generators 22";
			end
		end
		if (((525 + 929) <= (2055 + 436)) and v100.DivineHammer:IsCastable() and v40 and (v106 >= (850 - (40 + 808)))) then
			if (v25(v100.DivineHammer, not v17:IsInRange(2 + 8)) or ((15896 - 11739) <= (2680 + 123))) then
				return "divine_hammer generators 24";
			end
		end
		if (((2568 + 2285) >= (1636 + 1346)) and v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (572.75 - (47 + 524))) and ((v110 <= (2 + 0)) or ((v110 <= (8 - 5)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (2 - 0)))) or ((v110 == (8 - 4)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1728 - (1165 + 561)))) and (v100.Judgment:CooldownRemains() > (v111 * (1 + 1)))))) then
			if (((12803 - 8669) > (1281 + 2076)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v122();
		if (v30 or ((3896 - (341 + 138)) < (685 + 1849))) then
			return v30;
		end
		if ((v100.TemplarSlash:IsReady() and v47) or ((5617 - 2895) <= (490 - (89 + 237)))) then
			if (v25(v100.TemplarSlash, not v17:IsInRange(32 - 22)) or ((5069 - 2661) < (2990 - (581 + 300)))) then
				return "templar_slash generators 28";
			end
		end
		if ((v100.TemplarStrike:IsReady() and v48) or ((1253 - (855 + 365)) == (3455 - 2000))) then
			if (v25(v100.TemplarStrike, not v17:IsInRange(4 + 6)) or ((1678 - (1030 + 205)) >= (3770 + 245))) then
				return "templar_strike generators 30";
			end
		end
		if (((3147 + 235) > (452 - (156 + 130))) and v100.Judgment:IsReady() and v45 and ((v110 <= (6 - 3)) or not v100.BoundlessJudgment:IsAvailable())) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((471 - 191) == (6264 - 3205))) then
				return "judgment generators 32";
			end
		end
		if (((496 + 1385) > (754 + 539)) and v100.HammerofWrath:IsReady() and v44 and ((v110 <= (72 - (10 + 59))) or (v17:HealthPercentage() > (6 + 14)) or not v100.VanguardsMomentum:IsAvailable())) then
			if (((11607 - 9250) == (3520 - (671 + 492))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if (((98 + 25) == (1338 - (369 + 846))) and v100.CrusaderStrike:IsCastable() and v39) then
			if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((280 + 776) >= (2895 + 497))) then
				return "crusader_strike generators 26";
			end
		end
		if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (1950 - (1036 + 909))) and (v86 < v108)) or ((860 + 221) < (1804 - 729))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(213 - (11 + 192))) or ((531 + 518) >= (4607 - (135 + 40)))) then
				return "arcane_torrent generators 28";
			end
		end
		if ((v100.Consecration:IsCastable() and v38) or ((11552 - 6784) <= (510 + 336))) then
			if (v25(v100.Consecration, not v17:IsInRange(22 - 12)) or ((5033 - 1675) <= (1596 - (50 + 126)))) then
				return "consecration generators 30";
			end
		end
		if ((v100.DivineHammer:IsCastable() and v40) or ((10411 - 6672) <= (666 + 2339))) then
			if (v25(v100.DivineHammer, not v17:IsInRange(1423 - (1233 + 180))) or ((2628 - (522 + 447)) >= (3555 - (107 + 1314)))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v124()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (2 - 1)) or ((1385 + 1875) < (4676 - 2321))) then
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v138 = 7 - 5;
			end
			if ((v138 == (1915 - (716 + 1194))) or ((12 + 657) == (453 + 3770))) then
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v138 == (506 - (74 + 429))) or ((3263 - 1571) < (292 + 296))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v50 = EpicSettings.Settings['useVerdict'];
				v138 = 8 - 4;
			end
			if ((v138 == (0 + 0)) or ((14788 - 9991) < (9027 - 5376))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v38 = EpicSettings.Settings['useConsecration'];
				v138 = 434 - (279 + 154);
			end
			if ((v138 == (780 - (454 + 324))) or ((3287 + 890) > (4867 - (12 + 5)))) then
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v138 = 2 + 1;
			end
			if ((v138 == (10 - 6)) or ((148 + 252) > (2204 - (277 + 816)))) then
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v138 = 21 - 16;
			end
		end
	end
	local function v125()
		local v139 = 1183 - (1058 + 125);
		while true do
			if (((573 + 2478) > (1980 - (815 + 160))) and (v139 == (17 - 13))) then
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v139 = 14 - 9;
			end
			if (((5591 - (41 + 1857)) <= (6275 - (1222 + 671))) and (v139 == (5 - 3))) then
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v70 = EpicSettings.Settings['divineShieldHP'] or (1182 - (229 + 953));
				v139 = 1777 - (1111 + 663);
			end
			if ((v139 == (1579 - (874 + 705))) or ((460 + 2822) > (2798 + 1302))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v62 = EpicSettings.Settings['useDivineShield'];
				v139 = 1 - 0;
			end
			if ((v139 == (1 + 4)) or ((4259 - (642 + 37)) < (649 + 2195))) then
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((15 + 74) < (11273 - 6783)) and (v139 == (455 - (233 + 221)))) then
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayonHandsFocus'];
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v139 = 4 - 2;
			end
			if ((v139 == (3 + 0)) or ((6524 - (718 + 823)) < (1138 + 670))) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (805 - (266 + 539));
				v72 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (1225 - (636 + 589));
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v139 = 8 - 4;
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if (((1392 + 2437) > (4784 - (657 + 358))) and (v140 == (4 - 2))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v140 = 6 - 3;
			end
			if (((2672 - (1151 + 36)) <= (2805 + 99)) and ((2 + 3) == v140)) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v140 = 17 - 11;
			end
			if (((6101 - (1552 + 280)) == (5103 - (64 + 770))) and (v140 == (5 + 1))) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((69 + 318) <= (4025 - (157 + 1086))) and (v140 == (1 - 0))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v140 = 8 - 6;
			end
			if (((3 - 0) == v140) or ((2591 - 692) <= (1736 - (599 + 220)))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v140 = 7 - 3;
			end
			if ((v140 == (1931 - (1813 + 118))) or ((3152 + 1160) <= (2093 - (841 + 376)))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v140 = 1 + 0;
			end
			if (((6092 - 3860) <= (3455 - (464 + 395))) and (v140 == (10 - 6))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (837 - (467 + 370));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v140 = 9 - 4;
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
		if (((1538 + 557) < (12635 - 8949)) and v15:IsDeadOrGhost()) then
			return v30;
		end
		v105 = v15:GetEnemiesInMeleeRange(2 + 6);
		if (v32 or ((3710 - 2115) >= (4994 - (150 + 370)))) then
			v106 = #v105;
		else
			local v151 = 1282 - (74 + 1208);
			while true do
				if ((v151 == (0 - 0)) or ((21905 - 17286) < (2051 + 831))) then
					v105 = {};
					v106 = 391 - (14 + 376);
					break;
				end
			end
		end
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((509 - 215) >= (3126 + 1705))) then
			if (((1783 + 246) <= (2942 + 142)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
				if (v25(v100.CrusaderAura) or ((5968 - 3931) == (1821 + 599))) then
					return "crusader_aura";
				end
			end
		end
		v109 = v113();
		if (((4536 - (23 + 55)) > (9251 - 5347)) and not v15:AffectingCombat()) then
			if (((291 + 145) >= (111 + 12)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
				if (((775 - 275) < (572 + 1244)) and v25(v100.RetributionAura)) then
					return "retribution_aura";
				end
			end
		end
		if (((4475 - (652 + 249)) == (9564 - 5990)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (((2089 - (708 + 1160)) < (1058 - 668)) and v15:AffectingCombat()) then
				if (v100.Intercession:IsCastable() or ((4034 - 1821) <= (1448 - (10 + 17)))) then
					if (((687 + 2371) < (6592 - (1400 + 332))) and v25(v100.Intercession, not v17:IsInRange(57 - 27), true)) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((3204 - (242 + 1666)) >= (1903 + 2543))) then
				if (v25(v100.Redemption, not v17:IsInRange(11 + 19), true) or ((1188 + 205) > (5429 - (850 + 90)))) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((7748 - 3324) < (1417 - (360 + 1030)))) then
			if (v25(v104.RedemptionMouseover) or ((1768 + 229) > (10767 - 6952))) then
				return "redemption mouseover";
			end
		end
		if (((4766 - 1301) > (3574 - (909 + 752))) and v15:AffectingCombat()) then
			if (((1956 - (109 + 1114)) < (3329 - 1510)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (2 + 1)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v104.IntercessionMouseover) or ((4637 - (6 + 236)) == (2996 + 1759))) then
					return "Intercession mouseover";
				end
			end
		end
		if (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()) or ((3054 + 739) < (5586 - 3217))) then
			local v152 = 0 - 0;
			local v153;
			while true do
				if ((v152 == (1134 - (1076 + 57))) or ((672 + 3412) == (954 - (579 + 110)))) then
					if (((345 + 4013) == (3854 + 504)) and v30) then
						return v30;
					end
					break;
				end
				if ((v152 == (0 + 0)) or ((3545 - (174 + 233)) < (2773 - 1780))) then
					v153 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v153, nil, 35 - 15, nil, 12 + 13, v100.FlashofLight);
					v152 = 1175 - (663 + 511);
				end
			end
		end
		if (((2971 + 359) > (505 + 1818)) and v34) then
			local v154 = 0 - 0;
			while true do
				if ((v154 == (0 + 0)) or ((8536 - 4910) == (9656 - 5667))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 20 + 20, 48 - 23, v100.FlashofLight);
					if (v30 or ((653 + 263) == (245 + 2426))) then
						return v30;
					end
					v154 = 723 - (478 + 244);
				end
				if (((789 - (440 + 77)) == (124 + 148)) and (v154 == (3 - 2))) then
					if (((5805 - (655 + 901)) <= (898 + 3941)) and v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (((2126 + 651) < (2161 + 1039)) and v25(v104.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (((382 - 287) < (3402 - (695 + 750))) and (v99.TargetIsValid() or v15:AffectingCombat())) then
			local v155 = 0 - 0;
			while true do
				if (((1274 - 448) < (6905 - 5188)) and (v155 == (352 - (285 + 66)))) then
					if (((3323 - 1897) >= (2415 - (682 + 628))) and (v108 == (1791 + 9320))) then
						v108 = v10.FightRemains(v105, false);
					end
					v111 = v15:GCD();
					v155 = 301 - (176 + 123);
				end
				if (((1152 + 1602) <= (2452 + 927)) and ((271 - (239 + 30)) == v155)) then
					v110 = v15:HolyPower();
					break;
				end
				if ((v155 == (0 + 0)) or ((3775 + 152) == (2500 - 1087))) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					v155 = 2 - 1;
				end
			end
		end
		if (v81 or ((1469 - (306 + 9)) <= (2749 - 1961))) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (0 + 0)) or ((791 + 852) > (9662 - 6283))) then
					if (v77 or ((4178 - (1140 + 235)) > (2895 + 1654))) then
						local v212 = 0 + 0;
						while true do
							if ((v212 == (0 + 0)) or ((272 - (33 + 19)) >= (1092 + 1930))) then
								v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 119 - 79);
								if (((1244 + 1578) == (5533 - 2711)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v78 and (v110 > (2 + 0))) or ((1750 - (586 + 103)) == (170 + 1687))) then
						v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 123 - 83, true);
						if (((4248 - (1309 + 179)) > (2461 - 1097)) and v30) then
							return v30;
						end
					end
					break;
				end
			end
		end
		if (v82 or ((2134 + 2768) <= (9654 - 6059))) then
			local v157 = 0 + 0;
			while true do
				if ((v157 == (0 - 0)) or ((7675 - 3823) == (902 - (295 + 314)))) then
					v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 73 - 43, true);
					if (v30 or ((3521 - (1300 + 662)) == (14406 - 9818))) then
						return v30;
					end
					v157 = 1756 - (1178 + 577);
				end
				if ((v157 == (1 + 0)) or ((13255 - 8771) == (2193 - (851 + 554)))) then
					v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 27 + 3, true);
					if (((12668 - 8100) >= (8484 - 4577)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		v30 = v117();
		if (((1548 - (115 + 187)) < (2658 + 812)) and v30) then
			return v30;
		end
		if (((3852 + 216) >= (3830 - 2858)) and v80 and v34) then
			local v158 = 1161 - (160 + 1001);
			while true do
				if (((432 + 61) < (2687 + 1206)) and (v158 == (0 - 0))) then
					if (v14 or ((1831 - (237 + 121)) >= (4229 - (525 + 372)))) then
						local v213 = 0 - 0;
						while true do
							if ((v213 == (0 - 0)) or ((4193 - (96 + 46)) <= (1934 - (643 + 134)))) then
								v30 = v116();
								if (((219 + 385) < (6907 - 4026)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v16 and v16:Exists() and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16))) or ((3341 - 2441) == (3239 + 138))) then
						if (((8750 - 4291) > (1207 - 616)) and v100.CleanseToxins:IsReady()) then
							if (((4117 - (316 + 403)) >= (1592 + 803)) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v30 = v118();
		if (v30 or ((6001 - 3818) >= (1021 + 1803))) then
			return v30;
		end
		if (((4875 - 2939) == (1372 + 564)) and not v15:AffectingCombat() and v31 and v99.TargetIsValid()) then
			v30 = v120();
			if (v30 or ((1558 + 3274) < (14944 - 10631))) then
				return v30;
			end
		end
		if (((19523 - 15435) > (8047 - 4173)) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
			local v159 = 0 + 0;
			while true do
				if (((8527 - 4195) == (212 + 4120)) and (v159 == (8 - 5))) then
					v30 = v123();
					if (((4016 - (12 + 5)) >= (11263 - 8363)) and v30) then
						return v30;
					end
					v159 = 8 - 4;
				end
				if ((v159 == (8 - 4)) or ((6261 - 3736) > (825 + 3239))) then
					if (((6344 - (1656 + 317)) == (3895 + 476)) and v25(v100.Pool)) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if (((2 + 0) == v159) or ((707 - 441) > (24538 - 19552))) then
					if (((2345 - (5 + 349)) >= (4393 - 3468)) and v91 and (v15:HealthPercentage() <= v93)) then
						local v214 = 1271 - (266 + 1005);
						while true do
							if (((300 + 155) < (7004 - 4951)) and (v214 == (0 - 0))) then
								if ((v95 == "Refreshing Healing Potion") or ((2522 - (561 + 1135)) == (6321 - 1470))) then
									if (((601 - 418) == (1249 - (507 + 559))) and v101.RefreshingHealingPotion:IsReady()) then
										if (((2908 - 1749) <= (5529 - 3741)) and v25(v104.RefreshingHealingPotion)) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if ((v95 == "Dreamwalker's Healing Potion") or ((3895 - (212 + 176)) > (5223 - (250 + 655)))) then
									if (v101.DreamwalkersHealingPotion:IsReady() or ((8385 - 5310) <= (5180 - 2215))) then
										if (((2135 - 770) <= (3967 - (1869 + 87))) and v25(v104.RefreshingHealingPotion)) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if ((v86 < v108) or ((9628 - 6852) > (5476 - (484 + 1417)))) then
						local v215 = 0 - 0;
						while true do
							if (((0 - 0) == v215) or ((3327 - (48 + 725)) == (7847 - 3043))) then
								v30 = v121();
								if (((6913 - 4336) == (1498 + 1079)) and v30) then
									return v30;
								end
								v215 = 2 - 1;
							end
							if ((v215 == (1 + 0)) or ((2 + 4) >= (2742 - (152 + 701)))) then
								if (((1817 - (430 + 881)) <= (725 + 1167)) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) then
									if (v25(v104.UseWeapon) or ((2903 - (557 + 338)) > (656 + 1562))) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
						end
					end
					v159 = 8 - 5;
				end
				if (((1326 - 947) <= (11017 - 6870)) and (v159 == (2 - 1))) then
					if ((v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) or ((5315 - (499 + 302)) <= (1875 - (39 + 827)))) then
						if (v25(v100.DivineProtection) or ((9650 - 6154) == (2661 - 1469))) then
							return "divine_protection defensive";
						end
					end
					if ((v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((826 - 618) == (4542 - 1583))) then
						if (((367 + 3910) >= (3842 - 2529)) and v25(v104.Healthstone)) then
							return "healthstone defensive";
						end
					end
					v159 = 1 + 1;
				end
				if (((4092 - 1505) < (3278 - (103 + 1))) and (v159 == (554 - (475 + 79)))) then
					if ((v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((8906 - 4786) <= (7033 - 4835))) then
						if (v25(v100.LayonHands) or ((207 + 1389) == (756 + 102))) then
							return "lay_on_hands_player defensive";
						end
					end
					if (((4723 - (1395 + 108)) == (9370 - 6150)) and v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
						if (v25(v100.DivineShield) or ((2606 - (7 + 1197)) > (1579 + 2041))) then
							return "divine_shield defensive";
						end
					end
					v159 = 1 + 0;
				end
			end
		end
	end
	local function v128()
		local v145 = 319 - (27 + 292);
		while true do
			if (((7542 - 4968) == (3281 - 707)) and (v145 == (0 - 0))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v103();
				break;
			end
		end
	end
	v21.SetAPL(138 - 68, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

