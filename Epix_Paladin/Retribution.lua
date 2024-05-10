local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 326 - (192 + 134);
	local v6;
	while true do
		if ((v5 == (1276 - (316 + 960))) or ((2288 + 1822) > (3378 + 998))) then
			v6 = v0[v4];
			if (not v6 or ((1507 + 123) > (16048 - 11850))) then
				return v1(v4, ...);
			end
			v5 = 552 - (83 + 468);
		end
		if (((2860 - (1202 + 604)) == (4920 - 3866)) and (v5 == (1 - 0))) then
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
		if (v100.CleanseToxins:IsAvailable() or ((1871 - 1195) >= (1967 - (45 + 280)))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 10725 + 386;
	local v108 = 9708 + 1403;
	local v109;
	local v110 = 0 + 0;
	local v111 = 0 + 0;
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if (((7658 - 3522) > (4308 - (340 + 1571))) and (v129 == (0 + 0))) then
				v107 = 12883 - (1733 + 39);
				v108 = 30531 - 19420;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = v15:GCDRemains();
		local v131 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (1044 - (125 + 909)), v100.WakeofAshes:CooldownRemains());
		if ((v130 > v131) or ((6282 - (1096 + 852)) == (1905 + 2340))) then
			return v130;
		end
		return v131;
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 0 - 0;
	local function v116()
		if ((v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(20 + 0) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) or ((4788 - (409 + 103)) <= (3267 - (46 + 190)))) then
			local v160 = 95 - (51 + 44);
			while true do
				if ((v160 == (0 + 0)) or ((6099 - (1114 + 203)) <= (1925 - (228 + 498)))) then
					if ((v115 == (0 + 0)) or ((2688 + 2176) < (2565 - (174 + 489)))) then
						v115 = GetTime();
					end
					if (((12606 - 7767) >= (5605 - (830 + 1075))) and v99.Wait(1024 - (303 + 221), v115)) then
						local v211 = 1269 - (231 + 1038);
						while true do
							if ((v211 == (0 + 0)) or ((2237 - (171 + 991)) > (7904 - 5986))) then
								if (((1063 - 667) <= (9492 - 5688)) and v25(v104.CleanseToxinsFocus)) then
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
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((14613 - 10444) == (6308 - 4121))) then
			if (((2266 - 860) == (4346 - 2940)) and v100.FlashofLight:IsReady()) then
				if (((2779 - (111 + 1137)) < (4429 - (91 + 67))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v132 = 0 - 0;
		while true do
			if (((159 + 476) == (1158 - (423 + 100))) and (v132 == (1 + 0))) then
				if (((9338 - 5965) <= (1854 + 1702)) and v14) then
					if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((4062 - (326 + 445)) < (14313 - 11033))) then
						if (((9770 - 5384) >= (2037 - 1164)) and v25(v104.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((1632 - (530 + 181)) <= (1983 - (614 + 267))) and v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) then
						if (((4738 - (19 + 13)) >= (1566 - 603)) and v25(v104.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((2237 - 1277) <= (2502 - 1626))) then
						if (v25(v104.BlessingofSacrificeFocus) or ((537 + 1529) == (1638 - 706))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((10006 - 5181) < (6655 - (1293 + 519))) and v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
						if (v25(v104.BlessingofProtectionFocus) or ((7909 - 4032) >= (11845 - 7308))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((18606 - 14291) < (4065 - 2339))) then
				if (v16:Exists() or ((1949 + 1730) < (128 + 497))) then
					if ((v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) or ((10745 - 6120) < (147 + 485))) then
						if (v25(v104.WordofGloryMouseover) or ((28 + 55) > (1113 + 667))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((1642 - (709 + 387)) <= (2935 - (673 + 1185))) and (not v14 or not v14:Exists() or not v14:IsInRange(87 - 57))) then
					return;
				end
				v132 = 3 - 2;
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (1 + 0)) or ((745 + 251) > (5806 - 1505))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 10 + 30, nil);
				if (((8115 - 4045) > (1348 - 661)) and v30) then
					return v30;
				end
				break;
			end
			if (((1880 - (446 + 1434)) == v133) or ((1939 - (1040 + 243)) >= (9938 - 6608))) then
				v30 = v99.HandleTopTrinket(v102, v33, 1887 - (559 + 1288), nil);
				if (v30 or ((4423 - (609 + 1322)) <= (789 - (13 + 441)))) then
					return v30;
				end
				v133 = 3 - 2;
			end
		end
	end
	local function v120()
		if (((11320 - 6998) >= (12759 - 10197)) and v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(1 + 7)) or ((13208 - 9571) >= (1340 + 2430))) then
				return "arcane_torrent precombat 0";
			end
		end
		if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((1043 + 1336) > (13585 - 9007))) then
			if (v25(v100.ShieldofVengeance, not v17:IsInRange(5 + 3)) or ((887 - 404) > (492 + 251))) then
				return "shield_of_vengeance precombat 1";
			end
		end
		if (((1365 + 1089) > (416 + 162)) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (4 + 0))) then
			if (((910 + 20) < (4891 - (153 + 280))) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
				return "juscticars vengeance precombat 2";
			end
		end
		if (((1911 - 1249) <= (873 + 99)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (2 + 2))) then
			if (((2287 + 2083) == (3966 + 404)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
				return "final verdict precombat 3";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (3 + 1))) or ((7250 - 2488) <= (533 + 328))) then
			if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((2079 - (89 + 578)) == (3047 + 1217))) then
				return "templars verdict precombat 4";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37) or ((6585 - 3417) < (3202 - (572 + 477)))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((672 + 4304) < (800 + 532))) then
				return "blade_of_justice precombat 5";
			end
		end
		if (((553 + 4075) == (4714 - (84 + 2))) and v100.Judgment:IsCastable() and v45) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((88 - 34) == (285 + 110))) then
				return "judgment precombat 6";
			end
		end
		if (((924 - (497 + 345)) == (3 + 79)) and v100.HammerofWrath:IsReady() and v44) then
			if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((99 + 482) < (1615 - (605 + 728)))) then
				return "hammer_of_wrath precombat 7";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39) or ((3289 + 1320) < (5547 - 3052))) then
			if (((53 + 1099) == (4259 - 3107)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike precombat 180";
			end
		end
	end
	local function v121()
		local v134 = v99.HandleDPSPotion(v33 and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (10 + 0)))));
		if (((5252 - 3356) <= (2584 + 838)) and v134) then
			return v134;
		end
		if ((v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) or ((1479 - (457 + 32)) > (688 + 932))) then
			if (v25(v100.LightsJudgment, not v17:IsInRange(1442 - (832 + 570))) or ((827 + 50) > (1225 + 3470))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((9522 - 6831) >= (892 + 959)) and v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (806 - (588 + 208)))))) then
			if (v25(v100.Fireblood, not v17:IsInRange(26 - 16)) or ((4785 - (884 + 916)) >= (10166 - 5310))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((2480 + 1796) >= (1848 - (232 + 421))) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(1897 - (1569 + 320))) then
			local v161 = 0 + 0;
			while true do
				if (((615 + 2617) <= (15804 - 11114)) and (v161 == (605 - (316 + 289)))) then
					v30 = v119();
					if (v30 or ((2345 - 1449) >= (146 + 3000))) then
						return v30;
					end
					break;
				end
			end
		end
		if (((4514 - (666 + 787)) >= (3383 - (360 + 65))) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (15 + 0)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
			if (((3441 - (79 + 175)) >= (1014 - 370)) and v25(v100.ShieldofVengeance)) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((503 + 141) <= (2157 - 1453)) and v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (28 - 13))) or (v15:BuffStack(v100.CrusadeBuff) == (909 - (503 + 396))) or not v100.Crusade:IsAvailable() or (v100.AvengingWrath:CooldownRemains() < (181.75 - (92 + 89))) or (v100.AvengingWrath:CooldownRemains() > (28 - 13))) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (3 + 2))) or ((v110 >= (11 - 8)) and (v10.CombatTime() > (1 + 4))) or ((v110 >= (4 - 2)) and v100.DivineAuxiliary:IsAvailable())) and (((v17:TimeToDie() > (7 + 1)) and not v100.ExecutionersWill:IsAvailable()) or (v17:TimeToDie() > (6 + 6)))) then
			if (((2917 - 1959) > (119 + 828)) and v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((6849 - 2357) >= (3898 - (485 + 759))) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (8 - 4)) and (v10.CombatTime() < (1194 - (442 + 747)))) or ((v110 >= (1138 - (832 + 303))) and ((v10.CombatTime() > (951 - (88 + 858))) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable() and (v100.ExecutionSentence:CooldownUp() or v100.FinalReckoning:CooldownUp()))) and ((v106 == (1 + 0)) or (v17:TimeToDie() > (1 + 9)))) then
			if (((4231 - (766 + 23)) >= (7419 - 5916)) and v25(v100.AvengingWrath, not v17:IsInRange(13 - 3))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (((v110 >= (13 - 8)) and (v10.CombatTime() < (16 - 11))) or ((v110 >= (1076 - (1036 + 37))) and (v10.CombatTime() > (4 + 1))))) or ((6173 - 3003) <= (1152 + 312))) then
			if (v25(v100.Crusade, not v17:IsInRange(1490 - (641 + 839))) or ((5710 - (910 + 3)) == (11186 - 6798))) then
				return "crusade cooldowns 14";
			end
		end
		if (((2235 - (1466 + 218)) <= (313 + 368)) and v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (1152 - (556 + 592))) and (v10.CombatTime() < (3 + 5))) or ((v110 >= (811 - (329 + 479))) and ((v10.CombatTime() >= (862 - (174 + 680))) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (6 - 4)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (20 - 10)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (8 + 2)))))) then
			local v162 = 739 - (396 + 343);
			while true do
				if (((290 + 2987) > (1884 - (29 + 1448))) and (v162 == (1389 - (135 + 1254)))) then
					if (((17687 - 12992) >= (6606 - 5191)) and (v98 == "player")) then
						if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(7 + 3)) or ((4739 - (389 + 1138)) <= (1518 - (102 + 472)))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if ((v98 == "cursor") or ((2922 + 174) <= (998 + 800))) then
						if (((3298 + 239) == (5082 - (320 + 1225))) and v25(v104.FinalReckoningCursor, not v17:IsInRange(35 - 15))) then
							return "final_reckoning cooldowns 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v135 = 0 + 0;
		while true do
			if (((5301 - (157 + 1307)) >= (3429 - (821 + 1038))) and (v135 == (2 - 1))) then
				if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1 + 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (17 - 7))))) or ((1098 + 1852) == (9448 - 5636))) then
					if (((5749 - (834 + 192)) >= (148 + 2170)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1 + 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) or ((3139 - 1112) > (3156 - (300 + 4)))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((304 + 832) > (11300 - 6983))) then
						return "final verdict finishers 6";
					end
				end
				v135 = 364 - (112 + 250);
			end
			if (((1893 + 2855) == (11894 - 7146)) and ((0 + 0) == v135)) then
				v112 = ((v106 >= (2 + 1)) or ((v106 >= (2 + 0)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (12 + 12)));
				if (((2776 + 960) <= (6154 - (1001 + 413))) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (6 - 3))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (892 - (244 + 638)))))) then
					if (v25(v100.DivineStorm, not v17:IsInRange(703 - (627 + 66))) or ((10100 - 6710) <= (3662 - (512 + 90)))) then
						return "divine_storm finishers 2";
					end
				end
				v135 = 1907 - (1665 + 241);
			end
			if ((v135 == (719 - (373 + 344))) or ((451 + 548) > (713 + 1980))) then
				if (((1221 - 758) < (1016 - 415)) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1102 - (35 + 1064)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (8 + 2))))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((4670 - 2487) < (3 + 684))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v136 = 1236 - (298 + 938);
		while true do
			if (((5808 - (233 + 1026)) == (6215 - (636 + 1030))) and (v136 == (3 + 1))) then
				if (((4564 + 108) == (1388 + 3284)) and ((v17:HealthPercentage() <= (2 + 18)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
					local v209 = 221 - (55 + 166);
					while true do
						if ((v209 == (0 + 0)) or ((369 + 3299) < (1508 - 1113))) then
							v30 = v122();
							if (v30 or ((4463 - (36 + 261)) == (795 - 340))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (1370 - (34 + 1334)))) or ((1711 + 2738) == (2070 + 593))) then
					if (v25(v100.Consecration, not v17:IsInRange(1293 - (1035 + 248))) or ((4298 - (20 + 1)) < (1558 + 1431))) then
						return "consecration generators 22";
					end
				end
				if ((v100.DivineHammer:IsCastable() and v40 and (v106 >= (321 - (134 + 185)))) or ((2003 - (549 + 584)) >= (4834 - (314 + 371)))) then
					if (((7593 - 5381) < (4151 - (478 + 490))) and v25(v100.DivineHammer, not v17:IsInRange(6 + 4))) then
						return "divine_hammer generators 24";
					end
				end
				v136 = 1177 - (786 + 386);
			end
			if (((15048 - 10402) > (4371 - (1055 + 324))) and (v136 == (1346 - (1093 + 247)))) then
				if (((1275 + 159) < (327 + 2779)) and v100.TemplarSlash:IsReady() and v47) then
					if (((3120 - 2334) < (10259 - 7236)) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 28";
					end
				end
				if ((v100.TemplarStrike:IsReady() and v48) or ((6948 - 4506) < (185 - 111))) then
					if (((1614 + 2921) == (17470 - 12935)) and v25(v100.TemplarStrike, not v17:IsSpellInRange(v100.TemplarStrike))) then
						return "templar_strike generators 30";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and ((v110 <= (10 - 7)) or not v100.BoundlessJudgment:IsAvailable())) or ((2269 + 740) <= (5383 - 3278))) then
					if (((2518 - (364 + 324)) < (10057 - 6388)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 32";
					end
				end
				v136 = 16 - 9;
			end
			if ((v136 == (3 + 5)) or ((5983 - 4553) >= (5784 - 2172))) then
				if (((8148 - 5465) >= (3728 - (1249 + 19))) and v100.Consecration:IsCastable() and v38) then
					if (v25(v100.Consecration, not v17:IsInRange(10 + 0)) or ((7021 - 5217) >= (4361 - (686 + 400)))) then
						return "consecration generators 30";
					end
				end
				if ((v100.DivineHammer:IsCastable() and v40) or ((1112 + 305) > (3858 - (73 + 156)))) then
					if (((23 + 4772) > (1213 - (721 + 90))) and v25(v100.DivineHammer, not v17:IsInRange(1 + 9))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((15627 - 10814) > (4035 - (224 + 246))) and (v136 == (0 - 0))) then
				if (((7202 - 3290) == (710 + 3202)) and ((v110 >= (1 + 4)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(23 + 8, 7 - 3) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (12 - 8))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(544 - (203 + 310), 1995 - (1238 + 755))))) then
					local v210 = 0 + 0;
					while true do
						if (((4355 - (709 + 825)) <= (8889 - 4065)) and (v210 == (0 - 0))) then
							v30 = v122();
							if (((2602 - (196 + 668)) <= (8666 - 6471)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((84 - 43) <= (3851 - (171 + 662))) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (95 - (4 + 89))) and ((v100.AvengingWrath:CooldownRemains() > (20 - 14)) or (v100.Crusade:CooldownRemains() > (3 + 3))) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (17 - 13)) or (v108 < (4 + 4)))) then
					if (((3631 - (35 + 1451)) <= (5557 - (28 + 1425))) and v25(v100.WakeofAshes, not v17:IsInRange(2003 - (941 + 1052)))) then
						return "wake_of_ashes generators 2";
					end
				end
				if (((2579 + 110) < (6359 - (822 + 692))) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (3 - 0)) and v15:HasTier(15 + 16, 299 - (45 + 252))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((2298 + 24) > (903 + 1719))) then
						return "blade_of_justice generators 4";
					end
				end
				v136 = 2 - 1;
			end
			if ((v136 == (438 - (114 + 319))) or ((6509 - 1975) == (2667 - 585))) then
				if ((v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v110 <= (2 - 0)) or ((v110 <= (5 - 2)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1965 - (556 + 1407))))) or ((v110 == (1210 - (741 + 465))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (467 - (170 + 295)))) and (v100.Judgment:CooldownRemains() > (v111 * (2 + 0)))))) or ((1444 + 127) > (4596 - 2729))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((2201 + 453) >= (1922 + 1074))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				if (((2253 + 1725) > (3334 - (957 + 273))) and v30) then
					return v30;
				end
				v136 = 2 + 4;
			end
			if (((1199 + 1796) > (5871 - 4330)) and (v136 == (18 - 11))) then
				if (((9923 - 6674) > (4718 - 3765)) and v100.HammerofWrath:IsReady() and v44 and ((v110 <= (1783 - (389 + 1391))) or (v17:HealthPercentage() > (13 + 7)) or not v100.VanguardsMomentum:IsAvailable())) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((341 + 2932) > (10410 - 5837))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((4102 - (783 + 168)) < (4309 - 3025))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((1820 + 30) == (1840 - (309 + 2)))) then
						return "crusader_strike generators 26";
					end
				end
				if (((2521 - 1700) < (3335 - (1090 + 122))) and v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (2 + 3)) and (v86 < v108)) then
					if (((3029 - 2127) < (1592 + 733)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1128 - (628 + 490)))) then
						return "arcane_torrent generators 28";
					end
				end
				v136 = 2 + 6;
			end
			if (((2124 - 1266) <= (13536 - 10574)) and (v136 == (776 - (431 + 343)))) then
				if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (7 - 3)) and (v106 >= (5 - 3))) or ((3118 + 828) < (165 + 1123))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((4937 - (556 + 1139)) == (582 - (6 + 9)))) then
						return "templar_slash generators 8";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1 + 2)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (2 + 0)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (173 - (28 + 141))))) or ((329 + 518) >= (1558 - 295))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1596 + 657) == (3168 - (486 + 831)))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (5 - 3)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(105 - 75, 1 + 3)) and ((v110 <= (9 - 6)) or (v17:HealthPercentage() > (1283 - (668 + 595))) or not v100.VanguardsMomentum:IsAvailable())) or ((1878 + 209) > (479 + 1893))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((12121 - 7676) < (4439 - (23 + 267)))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v136 = 1947 - (1129 + 815);
			end
			if ((v136 == (388 - (371 + 16))) or ((3568 - (1326 + 424)) == (160 - 75))) then
				if (((2302 - 1672) < (2245 - (88 + 30))) and v100.DivineToll:IsCastable() and v42 and (v110 <= (773 - (720 + 51))) and ((v100.AvengingWrath:CooldownRemains() > (33 - 18)) or (v100.Crusade:CooldownRemains() > (1791 - (421 + 1355))) or (v108 < (13 - 5)))) then
					if (v25(v100.DivineToll, not v17:IsInRange(15 + 15)) or ((3021 - (286 + 797)) == (9190 - 6676))) then
						return "divine_toll generators 6";
					end
				end
				if (((7047 - 2792) >= (494 - (397 + 42))) and v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(10 + 21, 802 - (24 + 776))) then
					if (((4619 - 1620) > (1941 - (222 + 563))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 7";
					end
				end
				if (((5177 - 2827) > (832 + 323)) and (v110 >= (193 - (23 + 167))) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1808 - (690 + 1108)))) then
					v30 = v122();
					if (((1454 + 2575) <= (4003 + 850)) and v30) then
						return v30;
					end
				end
				v136 = 850 - (40 + 808);
			end
			if ((v136 == (1 + 2)) or ((1973 - 1457) > (3283 + 151))) then
				if (((2141 + 1905) >= (1664 + 1369)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (575 - (47 + 524)))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((1765 + 954) <= (3955 - 2508))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (4 - 1)) or not v100.BoundlessJudgment:IsAvailable())) or ((9427 - 5293) < (5652 - (1165 + 561)))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((5 + 159) >= (8625 - 5840))) then
						return "judgment generators 16";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (2 + 1)) or not v100.HolyBlade:IsAvailable())) or ((1004 - (341 + 138)) == (570 + 1539))) then
					if (((67 - 34) == (359 - (89 + 237))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				v136 = 12 - 8;
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if (((3935 - (581 + 300)) <= (5235 - (855 + 365))) and (v137 == (0 - 0))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v38 = EpicSettings.Settings['useConsecration'];
				v137 = 1 + 0;
			end
			if (((3106 - (1030 + 205)) < (3176 + 206)) and (v137 == (2 + 0))) then
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v137 = 289 - (156 + 130);
			end
			if (((2937 - 1644) <= (3650 - 1484)) and (v137 == (10 - 5))) then
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v137 == (2 + 2)) or ((1504 + 1075) < (192 - (10 + 59)))) then
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v137 = 2 + 3;
			end
			if (((4 - 3) == v137) or ((2009 - (671 + 492)) >= (1886 + 482))) then
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v137 = 1217 - (369 + 846);
			end
			if ((v137 == (1 + 2)) or ((3424 + 588) <= (5303 - (1036 + 909)))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v50 = EpicSettings.Settings['useVerdict'];
				v137 = 4 + 0;
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if (((1697 - (11 + 192)) <= (1519 + 1486)) and (v138 == (175 - (135 + 40)))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v138 = 2 - 1;
			end
			if (((4 + 1) == v138) or ((6853 - 3742) == (3198 - 1064))) then
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (176 - (50 + 126));
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v138 = 1419 - (1233 + 180);
			end
			if (((3324 - (522 + 447)) == (3776 - (107 + 1314))) and ((2 + 1) == v138)) then
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v70 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v138 = 7 - 3;
			end
			if ((v138 == (3 - 2)) or ((2498 - (716 + 1194)) <= (8 + 424))) then
				v62 = EpicSettings.Settings['useDivineShield'];
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayOnHandsFocus'];
				v138 = 1 + 1;
			end
			if (((5300 - (74 + 429)) >= (7513 - 3618)) and (v138 == (3 + 3))) then
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((8187 - 4610) == (2531 + 1046)) and ((5 - 3) == v138)) then
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v138 = 7 - 4;
			end
			if (((4227 - (279 + 154)) > (4471 - (454 + 324))) and ((4 + 0) == v138)) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (17 - (12 + 5));
				v72 = EpicSettings.Settings['layOnHandsFocusHP'] or (0 + 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 - 0);
				v138 = 2 + 3;
			end
		end
	end
	local function v126()
		v86 = EpicSettings.Settings['fightRemainsCheck'] or (1093 - (277 + 816));
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
		v93 = EpicSettings.Settings['healingPotionHP'] or (1183 - (1058 + 125));
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v81 = EpicSettings.Settings['handleAfflicted'];
		v82 = EpicSettings.Settings['HandleIncorporeal'];
		v96 = EpicSettings.Settings['HealOOC'];
		v97 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v127()
		v125();
		v124();
		v126();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((2250 - (815 + 160)) == (17591 - 13491))) then
			return v30;
		end
		v105 = v15:GetEnemiesInMeleeRange(18 - 10);
		if (v32 or ((380 + 1211) >= (10464 - 6884))) then
			v106 = #v105;
		else
			local v163 = 1898 - (41 + 1857);
			while true do
				if (((2876 - (1222 + 671)) <= (4672 - 2864)) and (v163 == (0 - 0))) then
					v105 = {};
					v106 = 1183 - (229 + 953);
					break;
				end
			end
		end
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((3924 - (1111 + 663)) <= (2776 - (874 + 705)))) then
			if (((528 + 3241) >= (801 + 372)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
				if (((3086 - 1601) == (42 + 1443)) and v25(v100.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		v109 = v113();
		if (not v15:AffectingCombat() or ((3994 - (642 + 37)) <= (635 + 2147))) then
			if ((v100.RetributionAura:IsCastable() and (v114()) and v35) or ((141 + 735) >= (7441 - 4477))) then
				if (v25(v100.RetributionAura) or ((2686 - (233 + 221)) > (5773 - 3276))) then
					return "retribution_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((1858 + 252) <= (1873 - (718 + 823)))) then
			if (((2320 + 1366) > (3977 - (266 + 539))) and v15:AffectingCombat()) then
				if (v100.Intercession:IsCastable() or ((12666 - 8192) < (2045 - (636 + 589)))) then
					if (((10156 - 5877) >= (5943 - 3061)) and v25(v100.Intercession, not v17:IsInRange(24 + 6), true)) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((738 + 1291) >= (4536 - (657 + 358)))) then
				if (v25(v100.Redemption, not v17:IsInRange(79 - 49), true) or ((4640 - 2603) >= (5829 - (1151 + 36)))) then
					return "redemption target";
				end
			end
		end
		if (((1661 + 59) < (1173 + 3285)) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v104.RedemptionMouseover) or ((1302 - 866) > (4853 - (1552 + 280)))) then
				return "redemption mouseover";
			end
		end
		if (((1547 - (64 + 770)) <= (576 + 271)) and v15:AffectingCombat()) then
			if (((4889 - 2735) <= (716 + 3315)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (1246 - (157 + 1086))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (((9237 - 4622) == (20212 - 15597)) and v25(v104.IntercessionMouseover)) then
					return "Intercession mouseover";
				end
			end
		end
		if (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()) or ((5813 - 2023) == (682 - 182))) then
			local v164 = 819 - (599 + 220);
			local v165;
			while true do
				if (((176 - 87) < (2152 - (1813 + 118))) and ((1 + 0) == v164)) then
					if (((3271 - (841 + 376)) >= (1990 - 569)) and v30) then
						return v30;
					end
					break;
				end
				if (((161 + 531) < (8346 - 5288)) and (v164 == (859 - (464 + 395)))) then
					v165 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v165, nil, 51 - 31, nil, 13 + 12, v100.FlashofLight);
					v164 = 838 - (467 + 370);
				end
			end
		end
		if (v34 or ((6724 - 3470) == (1215 + 440))) then
			local v166 = 0 - 0;
			while true do
				if (((0 + 0) == v166) or ((3015 - 1719) == (5430 - (150 + 370)))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1322 - (74 + 1208), 61 - 36, v100.FlashofLight, 9 - 7);
					if (((2397 + 971) == (3758 - (14 + 376))) and v30) then
						return v30;
					end
					v166 = 1 - 0;
				end
				if (((1711 + 932) < (3352 + 463)) and ((1 + 0) == v166)) then
					if (((5605 - 3692) > (371 + 122)) and v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (((4833 - (23 + 55)) > (8124 - 4696)) and v25(v104.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (((922 + 459) <= (2128 + 241)) and (v99.TargetIsValid() or v15:AffectingCombat())) then
			local v167 = 0 - 0;
			while true do
				if (((1 + 0) == v167) or ((5744 - (652 + 249)) == (10929 - 6845))) then
					if (((6537 - (708 + 1160)) > (985 - 622)) and (v108 == (20257 - 9146))) then
						v108 = v10.FightRemains(v105, false);
					end
					v111 = v15:GCD();
					v167 = 29 - (10 + 17);
				end
				if ((v167 == (0 + 0)) or ((3609 - (1400 + 332)) >= (6018 - 2880))) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					v167 = 1909 - (242 + 1666);
				end
				if (((2030 + 2712) >= (1329 + 2297)) and (v167 == (2 + 0))) then
					v110 = v15:HolyPower();
					break;
				end
			end
		end
		if (v81 or ((5480 - (850 + 90)) == (1603 - 687))) then
			if (v77 or ((2546 - (360 + 1030)) > (3846 + 499))) then
				local v207 = 0 - 0;
				while true do
					if (((3077 - 840) < (5910 - (909 + 752))) and (v207 == (1223 - (109 + 1114)))) then
						v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 73 - 33);
						if (v30 or ((1045 + 1638) < (265 - (6 + 236)))) then
							return v30;
						end
						break;
					end
				end
			end
			if (((440 + 257) <= (665 + 161)) and v78 and (v110 > (4 - 2))) then
				local v208 = 0 - 0;
				while true do
					if (((2238 - (1076 + 57)) <= (194 + 982)) and (v208 == (689 - (579 + 110)))) then
						v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 4 + 36, true);
						if (((2988 + 391) <= (2024 + 1788)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (v82 or ((1195 - (174 + 233)) >= (4513 - 2897))) then
			local v168 = 0 - 0;
			while true do
				if (((825 + 1029) <= (4553 - (663 + 511))) and (v168 == (0 + 0))) then
					v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 7 + 23, true);
					if (((14024 - 9475) == (2755 + 1794)) and v30) then
						return v30;
					end
					v168 = 2 - 1;
				end
				if ((v168 == (2 - 1)) or ((1443 + 1579) >= (5885 - 2861))) then
					v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 22 + 8, true);
					if (((441 + 4379) > (2920 - (478 + 244))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		v30 = v117();
		if (v30 or ((1578 - (440 + 77)) >= (2224 + 2667))) then
			return v30;
		end
		if (((4992 - 3628) <= (6029 - (655 + 901))) and v80 and v34) then
			local v169 = 0 + 0;
			while true do
				if ((v169 == (0 + 0)) or ((2428 + 1167) <= (11 - 8))) then
					if (v14 or ((6117 - (695 + 750)) == (13153 - 9301))) then
						v30 = v116();
						if (((2405 - 846) == (6269 - 4710)) and v30) then
							return v30;
						end
					end
					if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) or ((2103 - (285 + 66)) <= (1836 - 1048))) then
						if (v100.CleanseToxins:IsReady() or ((5217 - (682 + 628)) == (29 + 148))) then
							if (((3769 - (176 + 123)) > (233 + 322)) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v30 = v118();
		if (v30 or ((706 + 266) == (914 - (239 + 30)))) then
			return v30;
		end
		if (((866 + 2316) >= (2033 + 82)) and not v15:AffectingCombat() and v31 and v99.TargetIsValid()) then
			local v170 = 0 - 0;
			while true do
				if (((12145 - 8252) < (4744 - (306 + 9))) and (v170 == (0 - 0))) then
					v30 = v120();
					if (v30 or ((499 + 2368) < (1169 + 736))) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((865 + 931) >= (11584 - 7533))) then
			if (((2994 - (1140 + 235)) <= (2391 + 1365)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
				if (((554 + 50) == (156 + 448)) and v25(v100.LayonHands)) then
					return "lay_on_hands_player defensive";
				end
			end
			if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((4536 - (33 + 19)) == (325 + 575))) then
				if (v25(v100.DivineShield) or ((13364 - 8905) <= (491 + 622))) then
					return "divine_shield defensive";
				end
			end
			if (((7122 - 3490) > (3187 + 211)) and v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) then
				if (((4771 - (586 + 103)) <= (448 + 4469)) and v25(v100.DivineProtection)) then
					return "divine_protection defensive";
				end
			end
			if (((14875 - 10043) >= (2874 - (1309 + 179))) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
				if (((246 - 109) == (60 + 77)) and v25(v104.Healthstone)) then
					return "healthstone defensive";
				end
			end
			if ((v91 and (v15:HealthPercentage() <= v93)) or ((4216 - 2646) >= (3273 + 1059))) then
				if ((v95 == "Refreshing Healing Potion") or ((8634 - 4570) <= (3624 - 1805))) then
					if (v101.RefreshingHealingPotion:IsReady() or ((5595 - (295 + 314)) < (3865 - 2291))) then
						if (((6388 - (1300 + 662)) > (539 - 367)) and v25(v104.RefreshingHealingPotion)) then
							return "refreshing healing potion defensive";
						end
					end
				end
				if (((2341 - (1178 + 577)) > (237 + 218)) and (v95 == "Dreamwalker's Healing Potion")) then
					if (((2441 - 1615) == (2231 - (851 + 554))) and v101.DreamwalkersHealingPotion:IsReady()) then
						if (v25(v104.RefreshingHealingPotion) or ((3554 + 465) > (12316 - 7875))) then
							return "dreamwalkers healing potion defensive";
						end
					end
				end
			end
			if (((4380 - 2363) < (4563 - (115 + 187))) and (v86 < v108)) then
				v30 = v121();
				if (((3612 + 1104) > (76 + 4)) and v30) then
					return v30;
				end
				if ((v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36 and (v100.MarkofFyralathDebuff:AuraActiveCount() > (0 - 0)) and v15:BuffDown(v100.AvengingWrathBuff) and v15:BuffDown(v100.CrusadeBuff)) or ((4668 - (160 + 1001)) == (2863 + 409))) then
					if (v25(v104.UseWeapon) or ((605 + 271) >= (6294 - 3219))) then
						return "Fyralath The Dreamrender used";
					end
				end
			end
			v30 = v123();
			if (((4710 - (237 + 121)) > (3451 - (525 + 372))) and v30) then
				return v30;
			end
			if (v25(v100.Pool) or ((8352 - 3946) < (13283 - 9240))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v128()
		local v157 = 142 - (96 + 46);
		while true do
			if ((v157 == (778 - (643 + 134))) or ((682 + 1207) >= (8111 - 4728))) then
				v103();
				break;
			end
			if (((7024 - 5132) <= (2622 + 112)) and (v157 == (0 - 0))) then
				v100.MarkofFyralathDebuff:RegisterAuraTracking();
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v157 = 1 - 0;
			end
		end
	end
	v21.SetAPL(789 - (316 + 403), v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

