local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1723 - (1300 + 423);
	local v6;
	while true do
		if (((5862 - 3026) > (1718 - 1224)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2370 + 356) == (13049 - 9180))) then
			v6 = v0[v4];
			if (not v6 or ((6370 - (109 + 1885)) <= (2950 - (1269 + 200)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
		if (v100.CleanseToxins:IsAvailable() or ((4207 - (98 + 717)) >= (5567 - (802 + 24)))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 19160 - 8049;
	local v108 = 14032 - 2921;
	local v109;
	local v110 = 0 + 0;
	local v111 = 0 + 0;
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if (((718 + 2607) >= (5992 - 3838)) and (v129 == (0 - 0))) then
				v107 = 3975 + 7136;
				v108 = 4523 + 6588;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = 0 + 0;
		local v131;
		local v132;
		while true do
			if ((v130 == (1 + 0)) or ((605 + 690) >= (4666 - (797 + 636)))) then
				if (((21251 - 16874) > (3261 - (1427 + 192))) and (v131 > v132)) then
					return v131;
				end
				return v132;
			end
			if (((1637 + 3086) > (3148 - 1792)) and (v130 == (0 + 0))) then
				v131 = v15:GCDRemains();
				v132 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (5 + 5), v100.WakeofAshes:CooldownRemains());
				v130 = 327 - (192 + 134);
			end
		end
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 1276 - (316 + 960);
	local function v116()
		if ((v100.CleanseToxins:IsReady() and v99.UnitHasDispellableDebuffByPlayer(v14)) or ((2302 + 1834) <= (2650 + 783))) then
			local v142 = 0 + 0;
			while true do
				if (((16228 - 11983) <= (5182 - (83 + 468))) and (v142 == (1806 - (1202 + 604)))) then
					if (((19961 - 15685) >= (6513 - 2599)) and (v115 == (0 - 0))) then
						v115 = GetTime();
					end
					if (((523 - (45 + 280)) <= (4214 + 151)) and v99.Wait(437 + 63, v115)) then
						if (((1747 + 3035) > (2588 + 2088)) and v25(v104.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v115 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v117()
		if (((9006 - 4142) > (4108 - (340 + 1571))) and v96 and (v15:HealthPercentage() <= v97)) then
			if (v100.FlashofLight:IsReady() or ((1460 + 2240) == (4279 - (1733 + 39)))) then
				if (((12294 - 7820) >= (1308 - (125 + 909))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		if (v16:Exists() or ((3842 - (1096 + 852)) <= (631 + 775))) then
			if (((2244 - 672) >= (1485 + 46)) and v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) then
				if (v25(v104.WordofGloryMouseover) or ((5199 - (409 + 103)) < (4778 - (46 + 190)))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (((3386 - (51 + 44)) > (471 + 1196)) and (not v14 or not v14:Exists() or not v14:IsInRange(1347 - (1114 + 203)))) then
			return;
		end
		if (v14 or ((1599 - (228 + 498)) == (441 + 1593))) then
			if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((1556 + 1260) < (674 - (174 + 489)))) then
				if (((9636 - 5937) < (6611 - (830 + 1075))) and v25(v104.WordofGloryFocus)) then
					return "word_of_glory defensive focus";
				end
			end
			if (((3170 - (303 + 221)) >= (2145 - (231 + 1038))) and v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) then
				if (((512 + 102) <= (4346 - (171 + 991))) and v25(v104.LayonHandsFocus)) then
					return "lay_on_hands defensive focus";
				end
			end
			if (((12882 - 9756) == (8393 - 5267)) and v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) then
				if (v25(v104.BlessingofSacrificeFocus) or ((5457 - 3270) >= (3965 + 989))) then
					return "blessing_of_sacrifice defensive focus";
				end
			end
			if ((v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((13590 - 9713) == (10313 - 6738))) then
				if (((1138 - 431) > (1953 - 1321)) and v25(v104.BlessingofProtectionFocus)) then
					return "blessing_of_protection defensive focus";
				end
			end
		end
	end
	local function v119()
		v30 = v99.HandleTopTrinket(v102, v33, 1288 - (111 + 1137), nil);
		if (v30 or ((704 - (91 + 67)) >= (7988 - 5304))) then
			return v30;
		end
		v30 = v99.HandleBottomTrinket(v102, v33, 10 + 30, nil);
		if (((1988 - (423 + 100)) <= (31 + 4270)) and v30) then
			return v30;
		end
	end
	local function v120()
		local v133 = 0 - 0;
		while true do
			if (((889 + 815) > (2196 - (326 + 445))) and (v133 == (17 - 13))) then
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((1530 - 843) == (9882 - 5648))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((4041 - (530 + 181)) < (2310 - (614 + 267)))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((1179 - (19 + 13)) >= (544 - 209)) and (v133 == (6 - 3))) then
				if (((9812 - 6377) > (545 + 1552)) and v100.Judgment:IsCastable() and v45) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((6630 - 2860) >= (8380 - 4339))) then
						return "judgment precombat 6";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44) or ((5603 - (1293 + 519)) <= (3286 - 1675))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((11952 - 7374) <= (3839 - 1831))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v133 = 17 - 13;
			end
			if (((2650 - 1525) <= (1100 + 976)) and (v133 == (0 + 0))) then
				if ((v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) or ((1725 - 982) >= (1017 + 3382))) then
					if (((384 + 771) < (1046 + 627)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1104 - (709 + 387)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((4182 - (673 + 1185)) <= (1676 - 1098))) then
					if (((12096 - 8329) == (6197 - 2430)) and v25(v100.ShieldofVengeance, not v17:IsInRange(6 + 2))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v133 = 1 + 0;
			end
			if (((5520 - 1431) == (1005 + 3084)) and (v133 == (1 - 0))) then
				if (((8750 - 4292) >= (3554 - (446 + 1434))) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (1287 - (1040 + 243)))) then
					if (((2901 - 1929) <= (3265 - (559 + 1288))) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (1935 - (609 + 1322)))) or ((5392 - (13 + 441)) < (17794 - 13032))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((6558 - 4054) > (21236 - 16972))) then
						return "final verdict precombat 3";
					end
				end
				v133 = 1 + 1;
			end
			if (((7819 - 5666) == (765 + 1388)) and (v133 == (1 + 1))) then
				if ((v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (11 - 7))) or ((278 + 229) >= (4765 - 2174))) then
					if (((2963 + 1518) == (2493 + 1988)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37) or ((1673 + 655) < (582 + 111))) then
					if (((4235 + 93) == (4761 - (153 + 280))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v133 = 8 - 5;
			end
		end
	end
	local function v121()
		local v134 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (9 + 1))) or (v108 < (10 + 15)));
		if (((832 + 756) >= (1209 + 123)) and v134) then
			return v134;
		end
		if ((v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) or ((3025 + 1149) > (6468 - 2220))) then
			if (v25(v100.LightsJudgment, not v17:IsInRange(25 + 15)) or ((5253 - (89 + 578)) <= (59 + 23))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((8030 - 4167) == (4912 - (572 + 477))) and v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (2 + 8))))) then
			if (v25(v100.Fireblood, not v17:IsInRange(7 + 3)) or ((34 + 248) <= (128 - (84 + 2)))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((7595 - 2986) >= (552 + 214)) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(850 - (497 + 345))) then
			v30 = v119();
			if (v30 or ((30 + 1122) == (421 + 2067))) then
				return v30;
			end
		end
		if (((4755 - (605 + 728)) > (2391 + 959)) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (33 - 18)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
			if (((41 + 836) > (1390 - 1014)) and v25(v100.ShieldofVengeance)) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if ((v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (14 + 1))) or (v15:BuffStack(v100.CrusadeBuff) == (27 - 17)) or (v100.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v100.AvengingWrath:CooldownRemains() > (504 - (457 + 32)))) and (((v110 >= (2 + 2)) and (v10.CombatTime() < (1407 - (832 + 570)))) or ((v110 >= (3 + 0)) and (v10.CombatTime() > (2 + 3))) or ((v110 >= (6 - 4)) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (4 + 4)) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (808 - (588 + 208))))) or ((8403 - 5285) <= (3651 - (884 + 916)))) then
			if (v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence)) or ((345 - 180) >= (2025 + 1467))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((4602 - (232 + 421)) < (6745 - (1569 + 320))) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (1 + 3)) and (v10.CombatTime() < (1 + 4))) or ((v110 >= (9 - 6)) and (v10.CombatTime() > (610 - (316 + 289)))) or ((v110 >= (5 - 3)) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v100.ExecutionSentence:CooldownRemains() > (1468 - (666 + 787))) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (425 - (360 + 65))) or (v100.FinalReckoning:CooldownRemains() > (29 + 1)) or not v100.FinalReckoning:IsReady())))))) then
			if (v25(v100.AvengingWrath, not v17:IsInRange(264 - (79 + 175))) or ((6742 - 2466) < (2354 + 662))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if (((14376 - 9686) > (7944 - 3819)) and v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (904 - (503 + 396))) and (v10.CombatTime() < (186 - (92 + 89)))) or ((v110 >= (5 - 2)) and (v10.CombatTime() > (3 + 2))))) then
			if (v25(v100.Crusade, not v17:IsInRange(6 + 4)) or ((195 - 145) >= (123 + 773))) then
				return "crusade cooldowns 14";
			end
		end
		if ((v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (8 - 4)) and (v10.CombatTime() < (7 + 1))) or ((v110 >= (2 + 1)) and (v10.CombatTime() >= (24 - 16))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (15 - 5)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (1254 - (485 + 759)))))) and ((v109 > (0 - 0)) or (v110 == (1194 - (442 + 747))) or ((v110 >= (1137 - (832 + 303))) and v100.DivineAuxiliary:IsAvailable()))) or ((2660 - (88 + 858)) >= (902 + 2056))) then
			local v143 = 0 + 0;
			while true do
				if ((v143 == (0 + 0)) or ((2280 - (766 + 23)) < (3179 - 2535))) then
					if (((962 - 258) < (2600 - 1613)) and (v98 == "player")) then
						if (((12618 - 8900) > (2979 - (1036 + 37))) and v25(v104.FinalReckoningPlayer, not v17:IsInRange(8 + 2))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if ((v98 == "cursor") or ((1865 - 907) > (2860 + 775))) then
						if (((4981 - (641 + 839)) <= (5405 - (910 + 3))) and v25(v104.FinalReckoningCursor, not v17:IsInRange(50 - 30))) then
							return "final_reckoning cooldowns 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		v112 = ((v106 >= (1687 - (1466 + 218))) or ((v106 >= (1 + 1)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (1172 - (556 + 592))));
		if ((v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (2 + 1))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (818 - (329 + 479)))))) or ((4296 - (174 + 680)) < (8755 - 6207))) then
			if (((5958 - 3083) >= (1046 + 418)) and v25(v100.DivineStorm, not v17:IsInRange(749 - (396 + 343)))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1 + 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1487 - (29 + 1448)))))) or ((6186 - (135 + 1254)) >= (18432 - 13539))) then
			if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((2572 - 2021) > (1379 + 689))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((3641 - (389 + 1138)) > (1518 - (102 + 472))) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (3 + 0))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (6 + 4))))) then
			if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((2110 + 152) >= (4641 - (320 + 1225)))) then
				return "final verdict finishers 6";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (5 - 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (7 + 3))))) or ((3719 - (157 + 1307)) >= (5396 - (821 + 1038)))) then
			if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((9573 - 5736) < (143 + 1163))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v123()
		if (((5239 - 2289) == (1098 + 1852)) and ((v110 >= (12 - 7)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(1057 - (834 + 192), 1 + 3) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (2 + 2))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(1 + 30, 2 - 0)))) then
			v30 = v122();
			if (v30 or ((5027 - (300 + 4)) < (881 + 2417))) then
				return v30;
			end
		end
		if (((2973 - 1837) >= (516 - (112 + 250))) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (2 + 1)) and v15:HasTier(77 - 46, 2 + 0)) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((141 + 130) > (3551 + 1197))) then
				return "blade_of_justice generators 1";
			end
		end
		if (((2351 + 2389) >= (2342 + 810)) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (1416 - (1001 + 413))) and ((v100.AvengingWrath:CooldownRemains() > (0 - 0)) or (v100.Crusade:CooldownRemains() > (882 - (244 + 638))) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (697 - (627 + 66))) or (v108 < (23 - 15)) or not v100.ExecutionSentence:IsReady())) then
			if (v25(v100.WakeofAshes, not v17:IsInRange(612 - (512 + 90))) or ((4484 - (1665 + 241)) >= (4107 - (373 + 344)))) then
				return "wake_of_ashes generators 2";
			end
		end
		if (((19 + 22) <= (440 + 1221)) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (7 - 4)) and v15:HasTier(52 - 21, 1101 - (35 + 1064))) then
			if (((438 + 163) < (7616 - 4056)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 4";
			end
		end
		if (((1 + 234) < (1923 - (298 + 938))) and v100.DivineToll:IsCastable() and v42 and (v110 <= (1261 - (233 + 1026))) and ((v100.AvengingWrath:CooldownRemains() > (1681 - (636 + 1030))) or (v100.Crusade:CooldownRemains() > (8 + 7)) or (v108 < (8 + 0)))) then
			if (((1352 + 3197) > (78 + 1075)) and v25(v100.DivineToll, not v17:IsInRange(251 - (55 + 166)))) then
				return "divine_toll generators 6";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(7 + 24, 1 + 1)) or ((17850 - 13176) < (4969 - (36 + 261)))) then
			if (((6414 - 2746) < (5929 - (34 + 1334))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment generators 7";
			end
		end
		if (((v110 >= (2 + 1)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (8 + 2))) or ((1738 - (1035 + 248)) == (3626 - (20 + 1)))) then
			local v144 = 0 + 0;
			while true do
				if (((319 - (134 + 185)) == v144) or ((3796 - (549 + 584)) == (3997 - (314 + 371)))) then
					v30 = v122();
					if (((14682 - 10405) <= (5443 - (478 + 490))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (3 + 1)) and (v106 >= (1174 - (786 + 386)))) or ((2817 - 1947) == (2568 - (1055 + 324)))) then
			if (((2893 - (1093 + 247)) <= (2785 + 348)) and v25(v100.TemplarSlash, not v17:IsInRange(2 + 8))) then
				return "templar_slash generators 8";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (11 - 8)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (6 - 4)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (10 - 6)))) or ((5621 - 3384) >= (1249 + 2262))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((5100 - 3776) > (10409 - 7389))) then
				return "blade_of_justice generators 10";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (2 + 0)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(76 - 46, 692 - (364 + 324))) and ((v110 <= (7 - 4)) or (v17:HealthPercentage() > (47 - 27)) or not v100.VanguardsMomentum:IsAvailable())) or ((992 + 2000) == (7870 - 5989))) then
			if (((4974 - 1868) > (4634 - 3108)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if (((4291 - (1249 + 19)) < (3494 + 376)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (15 - 11))) then
			if (((1229 - (686 + 400)) > (59 + 15)) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
				return "templar_slash generators 14";
			end
		end
		if (((247 - (73 + 156)) < (10 + 2102)) and v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (814 - (721 + 90))) or not v100.BoundlessJudgment:IsAvailable())) then
			if (((13 + 1084) <= (5285 - 3657)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment generators 16";
			end
		end
		if (((5100 - (224 + 246)) == (7500 - 2870)) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (5 - 2)) or not v100.HolyBlade:IsAvailable())) then
			if (((643 + 2897) > (64 + 2619)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((3522 + 1272) >= (6511 - 3236)) and ((v17:HealthPercentage() <= (66 - 46)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
			v30 = v122();
			if (((1997 - (203 + 310)) == (3477 - (1238 + 755))) and v30) then
				return v30;
			end
		end
		if (((101 + 1331) < (5089 - (709 + 825))) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (3 - 1))) then
			if (v25(v100.Consecration, not v17:IsInRange(14 - 4)) or ((1929 - (196 + 668)) > (14126 - 10548))) then
				return "consecration generators 22";
			end
		end
		if ((v100.DivineHammer:IsCastable() and v40 and (v106 >= (3 - 1))) or ((5628 - (171 + 662)) < (1500 - (4 + 89)))) then
			if (((6494 - 4641) < (1753 + 3060)) and v25(v100.DivineHammer, not v17:IsInRange(43 - 33))) then
				return "divine_hammer generators 24";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v110 <= (1488 - (35 + 1451))) or ((v110 <= (1456 - (28 + 1425))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1995 - (941 + 1052))))) or ((v110 == (4 + 0)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1516 - (822 + 692)))) and (v100.Judgment:CooldownRemains() > (v111 * (2 - 0)))))) or ((1329 + 1492) < (2728 - (45 + 252)))) then
			if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((2844 + 30) < (751 + 1430))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v122();
		if (v30 or ((6544 - 3855) <= (776 - (114 + 319)))) then
			return v30;
		end
		if ((v100.TemplarSlash:IsReady() and v47) or ((2682 - 813) == (2573 - 564))) then
			if (v25(v100.TemplarSlash, not v17:IsInRange(7 + 3)) or ((5282 - 1736) < (4864 - 2542))) then
				return "templar_slash generators 28";
			end
		end
		if ((v100.TemplarStrike:IsReady() and v48) or ((4045 - (556 + 1407)) == (5979 - (741 + 465)))) then
			if (((3709 - (170 + 295)) > (556 + 499)) and v25(v100.TemplarStrike, not v17:IsInRange(10 + 0))) then
				return "templar_strike generators 30";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and ((v110 <= (7 - 4)) or not v100.BoundlessJudgment:IsAvailable())) or ((2747 + 566) <= (1141 + 637))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((805 + 616) >= (3334 - (957 + 273)))) then
				return "judgment generators 32";
			end
		end
		if (((485 + 1327) <= (1301 + 1948)) and v100.HammerofWrath:IsReady() and v44 and ((v110 <= (11 - 8)) or (v17:HealthPercentage() > (52 - 32)) or not v100.VanguardsMomentum:IsAvailable())) then
			if (((4957 - 3334) <= (9690 - 7733)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if (((6192 - (389 + 1391)) == (2769 + 1643)) and v100.CrusaderStrike:IsCastable() and v39) then
			if (((183 + 1567) >= (1916 - 1074)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if (((5323 - (783 + 168)) > (6208 - 4358)) and v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (5 + 0)) and (v86 < v108)) then
			if (((543 - (309 + 2)) < (2521 - 1700)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1222 - (1090 + 122)))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((168 + 350) < (3029 - 2127)) and v100.Consecration:IsCastable() and v38) then
			if (((2049 + 945) > (1976 - (628 + 490))) and v25(v100.Consecration, not v17:IsInRange(2 + 8))) then
				return "consecration generators 30";
			end
		end
		if ((v100.DivineHammer:IsCastable() and v40) or ((9297 - 5542) <= (4181 - 3266))) then
			if (((4720 - (431 + 343)) > (7559 - 3816)) and v25(v100.DivineHammer, not v17:IsInRange(28 - 18))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v124()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (0 + 0)) or ((3030 - (556 + 1139)) >= (3321 - (6 + 9)))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v135 = 1 + 0;
			end
			if (((2482 + 2362) > (2422 - (28 + 141))) and (v135 == (1 + 1))) then
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v135 = 3 - 0;
			end
			if (((321 + 131) == (1769 - (486 + 831))) and (v135 == (10 - 6))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v135 = 17 - 12;
			end
			if (((1 + 2) == v135) or ((14409 - 9852) < (3350 - (668 + 595)))) then
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v135 = 4 + 0;
			end
			if (((782 + 3092) == (10564 - 6690)) and (v135 == (291 - (23 + 267)))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v135 = 1946 - (1129 + 815);
			end
			if ((v135 == (393 - (371 + 16))) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v135 = 25 - 18;
			end
			if ((v135 == (125 - (88 + 30))) or ((5026 - (720 + 51)) < (7614 - 4191))) then
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if (((3230 - (421 + 1355)) <= (4109 - 1618)) and (v135 == (3 + 2))) then
				v50 = EpicSettings.Settings['useVerdict'];
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v135 = 1089 - (286 + 797);
			end
		end
	end
	local function v125()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (7 - 2)) or ((4596 - (397 + 42)) <= (876 + 1927))) then
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((5653 - (24 + 776)) >= (4593 - 1611)) and (v136 == (788 - (222 + 563)))) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v72 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (190 - (23 + 167));
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (1798 - (690 + 1108));
				v136 = 2 + 2;
			end
			if (((3410 + 724) > (4205 - (40 + 808))) and (v136 == (0 + 0))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v62 = EpicSettings.Settings['useDivineShield'];
				v136 = 3 - 2;
			end
			if ((v136 == (1 + 0)) or ((1808 + 1609) < (1390 + 1144))) then
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayonHandsFocus'];
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v136 = 573 - (47 + 524);
			end
			if ((v136 == (2 + 0)) or ((7440 - 4718) <= (244 - 80))) then
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v70 = EpicSettings.Settings['divineShieldHP'] or (1726 - (1165 + 561));
				v136 = 1 + 2;
			end
			if ((v136 == (12 - 8)) or ((919 + 1489) < (2588 - (341 + 138)))) then
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v136 = 331 - (89 + 237);
			end
		end
	end
	local function v126()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (8 - 4)) or ((914 - (581 + 300)) == (2675 - (855 + 365)))) then
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if ((v137 == (1 + 2)) or ((1678 - (1030 + 205)) >= (3770 + 245))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (286 - (156 + 130));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v81 = EpicSettings.Settings['handleAfflicted'];
				v137 = 8 - 4;
			end
			if (((5699 - 2317) > (339 - 173)) and (v137 == (0 + 0))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v137 = 70 - (10 + 59);
			end
			if ((v137 == (1 + 1)) or ((1378 - 1098) == (4222 - (671 + 492)))) then
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v137 = 3 + 0;
			end
			if (((3096 - (369 + 846)) > (343 + 950)) and (v137 == (1 + 0))) then
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v137 = 1947 - (1036 + 909);
			end
		end
	end
	local function v127()
		local v138 = 0 + 0;
		while true do
			if (((3956 - 1599) == (2560 - (11 + 192))) and ((3 + 1) == v138)) then
				if (((298 - (135 + 40)) == (297 - 174)) and (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()))) then
					local v199 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v199, nil, 13 + 7, nil, 54 - 29, v100.FlashofLight);
					if (v30 or ((1582 - 526) >= (3568 - (50 + 126)))) then
						return v30;
					end
				end
				if (v34 or ((3010 - 1929) < (238 + 837))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1453 - (1233 + 180), 994 - (522 + 447), v100.FlashofLight);
					if (v30 or ((2470 - (107 + 1314)) >= (2057 + 2375))) then
						return v30;
					end
					if ((v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((14528 - 9760) <= (360 + 486))) then
						if (v25(v104.BlessingofFreedomFocus) or ((6668 - 3310) <= (5618 - 4198))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (v99.TargetIsValid() or v15:AffectingCombat() or ((5649 - (716 + 1194)) <= (52 + 2953))) then
					local v200 = 0 + 0;
					while true do
						if ((v200 == (504 - (74 + 429))) or ((3199 - 1540) >= (1058 + 1076))) then
							if ((v108 == (25433 - 14322)) or ((2307 + 953) < (7260 - 4905))) then
								v108 = v10.FightRemains(v105, false);
							end
							v111 = v15:GCD();
							v200 = 4 - 2;
						end
						if (((435 - (279 + 154)) == v200) or ((1447 - (454 + 324)) == (3323 + 900))) then
							v110 = v15:HolyPower();
							break;
						end
						if ((v200 == (17 - (12 + 5))) or ((913 + 779) < (1498 - 910))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v200 = 1 + 0;
						end
					end
				end
				if (v81 or ((5890 - (277 + 816)) < (15600 - 11949))) then
					if (v77 or ((5360 - (1058 + 125)) > (910 + 3940))) then
						v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 1015 - (815 + 160));
						if (v30 or ((1716 - 1316) > (2637 - 1526))) then
							return v30;
						end
					end
					if (((728 + 2323) > (2937 - 1932)) and v78 and (v110 > (1900 - (41 + 1857)))) then
						local v204 = 1893 - (1222 + 671);
						while true do
							if (((9544 - 5851) <= (6298 - 1916)) and (v204 == (1182 - (229 + 953)))) then
								v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 1814 - (1111 + 663), true);
								if (v30 or ((4861 - (874 + 705)) > (574 + 3526))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v138 = 4 + 1;
			end
			if ((v138 == (0 - 0)) or ((101 + 3479) < (3523 - (642 + 37)))) then
				v125();
				v124();
				v126();
				v31 = EpicSettings.Toggles['ooc'];
				v138 = 1 + 0;
			end
			if (((15 + 74) < (11273 - 6783)) and (v138 == (456 - (233 + 221)))) then
				v105 = v15:GetEnemiesInMeleeRange(18 - 10);
				if (v32 or ((4386 + 597) < (3349 - (718 + 823)))) then
					v106 = #v105;
				else
					v105 = {};
					v106 = 1 + 0;
				end
				if (((4634 - (266 + 539)) > (10670 - 6901)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if (((2710 - (636 + 589)) <= (6892 - 3988)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
						if (((8804 - 4535) == (3384 + 885)) and v25(v100.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v138 = 2 + 1;
			end
			if (((1402 - (657 + 358)) <= (7365 - 4583)) and ((11 - 6) == v138)) then
				if (v82 or ((3086 - (1151 + 36)) <= (886 + 31))) then
					local v201 = 0 + 0;
					while true do
						if ((v201 == (0 - 0)) or ((6144 - (1552 + 280)) <= (1710 - (64 + 770)))) then
							v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 21 + 9, true);
							if (((5066 - 2834) <= (461 + 2135)) and v30) then
								return v30;
							end
							v201 = 1244 - (157 + 1086);
						end
						if (((4193 - 2098) < (16143 - 12457)) and (v201 == (1 - 0))) then
							v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 40 - 10, true);
							if (v30 or ((2414 - (599 + 220)) >= (8909 - 4435))) then
								return v30;
							end
							break;
						end
					end
				end
				v30 = v117();
				if (v30 or ((6550 - (1813 + 118)) < (2107 + 775))) then
					return v30;
				end
				if ((v80 and v34) or ((1511 - (841 + 376)) >= (6769 - 1938))) then
					if (((472 + 1557) <= (8417 - 5333)) and v14) then
						v30 = v116();
						if (v30 or ((2896 - (464 + 395)) == (6210 - 3790))) then
							return v30;
						end
					end
					if (((2141 + 2317) > (4741 - (467 + 370))) and v16 and v16:Exists() and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16))) then
						if (((900 - 464) >= (91 + 32)) and v100.CleanseToxins:IsReady()) then
							if (((1714 - 1214) < (284 + 1532)) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v138 = 13 - 7;
			end
			if (((4094 - (150 + 370)) == (4856 - (74 + 1208))) and ((14 - 8) == v138)) then
				v30 = v118();
				if (((1048 - 827) < (278 + 112)) and v30) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v99.TargetIsValid()) or ((2603 - (14 + 376)) <= (2464 - 1043))) then
					local v202 = 0 + 0;
					while true do
						if (((2687 + 371) < (4636 + 224)) and (v202 == (0 - 0))) then
							v30 = v120();
							if (v30 or ((975 + 321) >= (4524 - (23 + 55)))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((3301 - 1908) > (2996 + 1493))) then
					local v203 = 0 + 0;
					while true do
						if ((v203 == (5 - 1)) or ((1392 + 3032) < (928 - (652 + 249)))) then
							if (v25(v100.Pool) or ((5344 - 3347) > (5683 - (708 + 1160)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((9405 - 5940) > (3487 - 1574)) and (v203 == (29 - (10 + 17)))) then
							if (((165 + 568) < (3551 - (1400 + 332))) and v91 and (v15:HealthPercentage() <= v93)) then
								local v205 = 0 - 0;
								while true do
									if ((v205 == (1908 - (242 + 1666))) or ((1881 + 2514) == (1743 + 3012))) then
										if ((v95 == "Refreshing Healing Potion") or ((3233 + 560) < (3309 - (850 + 90)))) then
											if (v101.RefreshingHealingPotion:IsReady() or ((7152 - 3068) == (1655 - (360 + 1030)))) then
												if (((3857 + 501) == (12300 - 7942)) and v25(v104.RefreshingHealingPotion)) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v95 == "Dreamwalker's Healing Potion") or ((4317 - 1179) < (2654 - (909 + 752)))) then
											if (((4553 - (109 + 1114)) > (4252 - 1929)) and v101.DreamwalkersHealingPotion:IsReady()) then
												if (v25(v104.RefreshingHealingPotion) or ((1412 + 2214) == (4231 - (6 + 236)))) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v86 < v108) or ((578 + 338) == (2150 + 521))) then
								v30 = v121();
								if (((640 - 368) == (474 - 202)) and v30) then
									return v30;
								end
								if (((5382 - (1076 + 57)) <= (796 + 4043)) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) then
									if (((3466 - (579 + 110)) < (253 + 2947)) and v25(v104.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							v203 = 3 + 0;
						end
						if (((51 + 44) < (2364 - (174 + 233))) and (v203 == (8 - 5))) then
							v30 = v123();
							if (((1449 - 623) < (764 + 953)) and v30) then
								return v30;
							end
							v203 = 1178 - (663 + 511);
						end
						if (((1273 + 153) >= (240 + 865)) and (v203 == (0 - 0))) then
							if (((1668 + 1086) <= (7954 - 4575)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (v25(v100.LayonHands) or ((9506 - 5579) == (675 + 738))) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((2245 - 1091) <= (562 + 226))) then
								if (v25(v100.DivineShield) or ((151 + 1492) > (4101 - (478 + 244)))) then
									return "divine_shield defensive";
								end
							end
							v203 = 518 - (440 + 77);
						end
						if ((v203 == (1 + 0)) or ((10258 - 7455) > (6105 - (655 + 901)))) then
							if ((v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) or ((41 + 179) >= (2314 + 708))) then
								if (((1906 + 916) == (11368 - 8546)) and v25(v100.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if ((v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((2506 - (695 + 750)) == (6341 - 4484))) then
								if (((4259 - 1499) > (5485 - 4121)) and v25(v104.Healthstone)) then
									return "healthstone defensive";
								end
							end
							v203 = 353 - (285 + 66);
						end
					end
				end
				break;
			end
			if ((v138 == (2 - 1)) or ((6212 - (682 + 628)) <= (580 + 3015))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((4151 - (176 + 123)) == (123 + 170))) then
					return v30;
				end
				v138 = 2 + 0;
			end
			if (((272 - (239 + 30)) == v138) or ((424 + 1135) == (4410 + 178))) then
				if (not v15:AffectingCombat() or ((7936 - 3452) == (2458 - 1670))) then
					if (((4883 - (306 + 9)) >= (13633 - 9726)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
						if (((217 + 1029) < (2130 + 1340)) and v25(v100.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if (((1959 + 2109) >= (2779 - 1807)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (((1868 - (1140 + 235)) < (2478 + 1415)) and v15:AffectingCombat()) then
						if (v100.Intercession:IsCastable() or ((1351 + 122) >= (856 + 2476))) then
							if (v25(v100.Intercession, not v17:IsInRange(82 - (33 + 19)), true) or ((1463 + 2588) <= (3467 - 2310))) then
								return "intercession target";
							end
						end
					elseif (((267 + 337) < (5649 - 2768)) and v100.Redemption:IsCastable()) then
						if (v25(v100.Redemption, not v17:IsInRange(29 + 1), true) or ((1589 - (586 + 103)) == (308 + 3069))) then
							return "redemption target";
						end
					end
				end
				if (((13727 - 9268) > (2079 - (1309 + 179))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((6134 - 2736) >= (1043 + 1352)) and v25(v104.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((5862 - 3679) >= (2134 + 690))) then
					if (((4113 - 2177) == (3857 - 1921)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (612 - (295 + 314))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v104.IntercessionMouseover) or ((11868 - 7036) < (6275 - (1300 + 662)))) then
							return "Intercession mouseover";
						end
					end
				end
				v138 = 12 - 8;
			end
		end
	end
	local function v128()
		local v139 = 1755 - (1178 + 577);
		while true do
			if (((2124 + 1964) > (11452 - 7578)) and (v139 == (1405 - (851 + 554)))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v103();
				break;
			end
		end
	end
	v21.SetAPL(62 + 8, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

