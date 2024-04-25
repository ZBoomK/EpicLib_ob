local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1773 - (1755 + 18);
	local v6;
	while true do
		if ((v5 == (1848 - (559 + 1288))) or ((4118 - (609 + 1322)) == (3457 - (13 + 441)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((494 - 305) >= (17805 - 14230))) then
			v6 = v0[v4];
			if (((24 + 613) == (2313 - 1676)) and not v6) then
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
		if (v100.CleanseToxins:IsAvailable() or ((1613 + 2066) < (1854 - 1229))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 6081 + 5030;
	local v108 = 20435 - 9324;
	local v109;
	local v110 = 0 + 0;
	local v111 = 0 + 0;
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (0 + 0)) or ((4526 + 99) < (1065 - (153 + 280)))) then
				v107 = 32083 - 20972;
				v108 = 9976 + 1135;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = v15:GCDRemains();
		local v131 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (4 + 6), v100.WakeofAshes:CooldownRemains());
		if ((v130 > v131) or ((44 + 39) > (1616 + 164))) then
			return v130;
		end
		return v131;
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 0 + 0;
	local function v116()
		if (((831 - 285) <= (666 + 411)) and v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(692 - (89 + 578)) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (0 - 0)) or ((2045 - (572 + 477)) > (581 + 3720))) then
					if (((2443 + 1627) > (83 + 604)) and (v115 == (86 - (84 + 2)))) then
						v115 = GetTime();
					end
					if (v99.Wait(824 - 324, v115) or ((473 + 183) >= (4172 - (497 + 345)))) then
						local v212 = 0 + 0;
						while true do
							if ((v212 == (0 + 0)) or ((3825 - (605 + 728)) <= (240 + 95))) then
								if (((9608 - 5286) >= (118 + 2444)) and v25(v104.CleanseToxinsFocus)) then
									return "cleanse_toxins dispel";
								end
								v115 = 0 - 0;
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
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((3279 + 358) >= (10445 - 6675))) then
			if (v100.FlashofLight:IsReady() or ((1797 + 582) > (5067 - (457 + 32)))) then
				if (v25(v100.FlashofLight) or ((205 + 278) > (2145 - (832 + 570)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v132 = 0 + 0;
		while true do
			if (((640 + 1814) > (2045 - 1467)) and (v132 == (0 + 0))) then
				if (((1726 - (588 + 208)) < (12015 - 7557)) and v16:Exists()) then
					if (((2462 - (884 + 916)) <= (2034 - 1062)) and v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) then
						if (((2534 + 1836) == (5023 - (232 + 421))) and v25(v104.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(1919 - (1569 + 320)) or ((1169 + 3593) <= (164 + 697))) then
					return;
				end
				v132 = 3 - 2;
			end
			if (((606 - (316 + 289)) == v132) or ((3696 - 2284) == (197 + 4067))) then
				if (v14 or ((4621 - (666 + 787)) < (2578 - (360 + 65)))) then
					if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((4651 + 325) < (1586 - (79 + 175)))) then
						if (((7297 - 2669) == (3612 + 1016)) and v25(v104.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) or ((165 - 111) == (760 - 365))) then
						if (((981 - (503 + 396)) == (263 - (92 + 89))) and v25(v104.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((1126 - 545) < (145 + 137))) then
						if (v25(v104.BlessingofSacrificeFocus) or ((2728 + 1881) < (9770 - 7275))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((158 + 994) == (2626 - 1474)) and v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
						if (((1655 + 241) <= (1635 + 1787)) and v25(v104.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 + 0)) or ((1509 - 519) > (2864 - (485 + 759)))) then
				v30 = v99.HandleTopTrinket(v102, v33, 92 - 52, nil);
				if (v30 or ((2066 - (442 + 747)) > (5830 - (832 + 303)))) then
					return v30;
				end
				v133 = 947 - (88 + 858);
			end
			if (((821 + 1870) >= (1532 + 319)) and (v133 == (1 + 0))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 829 - (766 + 23), nil);
				if (v30 or ((14736 - 11751) >= (6640 - 1784))) then
					return v30;
				end
				break;
			end
		end
	end
	local function v120()
		local v134 = 0 - 0;
		while true do
			if (((14512 - 10236) >= (2268 - (1036 + 37))) and (v134 == (2 + 0))) then
				if (((6293 - 3061) <= (3690 + 1000)) and v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (1484 - (641 + 839)))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((1809 - (910 + 3)) >= (8020 - 4874))) then
						return "templars verdict precombat 4";
					end
				end
				if (((4745 - (1466 + 218)) >= (1360 + 1598)) and v100.BladeofJustice:IsCastable() and v37) then
					if (((4335 - (556 + 592)) >= (230 + 414)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v134 = 811 - (329 + 479);
			end
			if (((1498 - (174 + 680)) <= (2418 - 1714)) and (v134 == (5 - 2))) then
				if (((684 + 274) > (1686 - (396 + 343))) and v100.Judgment:IsCastable() and v45) then
					if (((398 + 4094) >= (4131 - (29 + 1448))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if (((4831 - (135 + 1254)) >= (5662 - 4159)) and v100.HammerofWrath:IsReady() and v44) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((14801 - 11631) <= (976 + 488))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v134 = 1531 - (389 + 1138);
			end
			if ((v134 == (578 - (102 + 472))) or ((4527 + 270) == (2434 + 1954))) then
				if (((514 + 37) <= (2226 - (320 + 1225))) and v100.CrusaderStrike:IsCastable() and v39) then
					if (((5833 - 2556) > (250 + 157)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((6159 - (157 + 1307)) >= (3274 - (821 + 1038))) and (v134 == (2 - 1))) then
				if ((v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (1 + 3))) or ((5704 - 2492) <= (352 + 592))) then
					if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((7673 - 4577) <= (2824 - (834 + 192)))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((225 + 3312) == (908 + 2629)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (1 + 3))) then
					if (((5943 - 2106) >= (1874 - (300 + 4))) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v134 = 1 + 1;
			end
			if ((v134 == (0 - 0)) or ((3312 - (112 + 250)) == (1520 + 2292))) then
				if (((11831 - 7108) >= (1328 + 990)) and v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(5 + 3)) or ((1516 + 511) > (1415 + 1437))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((844 + 292) > (5731 - (1001 + 413)))) then
					if (((10587 - 5839) == (5630 - (244 + 638))) and v25(v100.ShieldofVengeance, not v17:IsInRange(701 - (627 + 66)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v121()
		local v135 = 602 - (512 + 90);
		local v136;
		while true do
			if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and (v135 == (2 + 1))) then
				if ((v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (4 + 11))) or (v15:BuffStack(v100.CrusadeBuff) == (26 - 16)) or (v100.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v100.AvengingWrath:CooldownRemains() > (1114 - (35 + 1064)))) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (10 - 5))) or ((v110 >= (1 + 2)) and (v10.CombatTime() > (1241 - (298 + 938)))) or ((v110 >= (1261 - (233 + 1026))) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (1674 - (636 + 1030))) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (7 + 5)))) or ((3312 + 78) <= (910 + 2150))) then
					if (v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence)) or ((68 + 931) > (2914 - (55 + 166)))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((90 + 373) < (61 + 540)) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (15 - 11)) and (v10.CombatTime() < (302 - (36 + 261)))) or ((v110 >= (4 - 1)) and (v10.CombatTime() > (1373 - (34 + 1334)))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v100.ExecutionSentence:CooldownRemains() > (1298 - (1035 + 248))) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (21 - (20 + 1))) or (v100.FinalReckoning:CooldownRemains() > (16 + 14)) or not v100.FinalReckoning:IsReady())))))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(329 - (134 + 185))) or ((3316 - (549 + 584)) < (1372 - (314 + 371)))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v135 = 13 - 9;
			end
			if (((5517 - (478 + 490)) == (2410 + 2139)) and (v135 == (1173 - (786 + 386)))) then
				if (((15132 - 10460) == (6051 - (1055 + 324))) and v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) then
					if (v25(v100.LightsJudgment, not v17:IsInRange(1380 - (1093 + 247))) or ((3260 + 408) < (42 + 353))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (39 - 29))))) or ((14138 - 9972) == (1294 - 839))) then
					if (v25(v100.Fireblood, not v17:IsInRange(25 - 15)) or ((1583 + 2866) == (10258 - 7595))) then
						return "fireblood cooldowns 6";
					end
				end
				v135 = 6 - 4;
			end
			if ((v135 == (0 + 0)) or ((10937 - 6660) < (3677 - (364 + 324)))) then
				v136 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (27 - 17))) or (v108 < (59 - 34)));
				if (v136 or ((289 + 581) >= (17360 - 13211))) then
					return v136;
				end
				v135 = 1 - 0;
			end
			if (((6717 - 4505) < (4451 - (1249 + 19))) and (v135 == (2 + 0))) then
				if (((18084 - 13438) > (4078 - (686 + 400))) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(7 + 1)) then
					v30 = v119();
					if (((1663 - (73 + 156)) < (15 + 3091)) and v30) then
						return v30;
					end
				end
				if (((1597 - (721 + 90)) < (34 + 2989)) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (48 - 33)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
					if (v25(v100.ShieldofVengeance) or ((2912 - (224 + 246)) < (119 - 45))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v135 = 5 - 2;
			end
			if (((823 + 3712) == (108 + 4427)) and (v135 == (3 + 1))) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (9 - 4)) and (v10.CombatTime() < (16 - 11))) or ((v110 >= (516 - (203 + 310))) and (v10.CombatTime() > (1998 - (1238 + 755)))))) or ((211 + 2798) <= (3639 - (709 + 825)))) then
					if (((3372 - 1542) < (5344 - 1675)) and v25(v100.Crusade, not v17:IsInRange(874 - (196 + 668)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (15 - 11)) and (v10.CombatTime() < (16 - 8))) or ((v110 >= (836 - (171 + 662))) and (v10.CombatTime() >= (101 - (4 + 89)))) or ((v110 >= (6 - 4)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (4 + 6)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (43 - 33))))) and ((v109 > (0 + 0)) or (v110 == (1491 - (35 + 1451))) or ((v110 >= (1455 - (28 + 1425))) and v100.DivineAuxiliary:IsAvailable()))) or ((3423 - (941 + 1052)) >= (3464 + 148))) then
					local v199 = 1514 - (822 + 692);
					while true do
						if (((3829 - 1146) >= (1159 + 1301)) and ((297 - (45 + 252)) == v199)) then
							if ((v98 == "player") or ((1785 + 19) >= (1128 + 2147))) then
								if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(24 - 14)) or ((1850 - (114 + 319)) > (5209 - 1580))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if (((6144 - 1349) > (257 + 145)) and (v98 == "cursor")) then
								if (((7170 - 2357) > (7469 - 3904)) and v25(v104.FinalReckoningCursor, not v17:IsInRange(1983 - (556 + 1407)))) then
									return "final_reckoning cooldowns 18";
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
	local function v122()
		v112 = ((v106 >= (1209 - (741 + 465))) or ((v106 >= (467 - (170 + 295))) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (13 + 11)));
		if (((3594 + 318) == (9631 - 5719)) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (3 + 0))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (7 + 3))))) then
			if (((1598 + 1223) <= (6054 - (957 + 273))) and v25(v100.DivineStorm, not v17:IsInRange(3 + 7))) then
				return "divine_storm finishers 2";
			end
		end
		if (((696 + 1042) <= (8363 - 6168)) and v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (7 - 4))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (30 - 20))))) then
			if (((203 - 162) <= (4798 - (389 + 1391))) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((1346 + 799) <= (428 + 3676)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (6 - 3))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (961 - (783 + 168)))))) then
			if (((9024 - 6335) < (4766 + 79)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (314 - (309 + 2)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (30 - 20))))) or ((3534 - (1090 + 122)) > (851 + 1771))) then
			if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((15227 - 10693) == (1425 + 657))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v123()
		local v137 = 1118 - (628 + 490);
		while true do
			if ((v137 == (1 + 4)) or ((3889 - 2318) > (8532 - 6665))) then
				if ((v100.DivineHammer:IsCastable() and v40 and (v106 >= (776 - (431 + 343)))) or ((5359 - 2705) >= (8667 - 5671))) then
					if (((3143 + 835) > (270 + 1834)) and v25(v100.DivineHammer, not v17:IsInRange(1705 - (556 + 1139)))) then
						return "divine_hammer generators 24";
					end
				end
				if (((3010 - (6 + 9)) > (283 + 1258)) and v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v110 <= (171 - (28 + 141))) or ((v110 <= (2 + 1)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (2 - 0)))) or ((v110 == (3 + 1)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1319 - (486 + 831)))) and (v100.Judgment:CooldownRemains() > (v111 * (5 - 3)))))) then
					if (((11438 - 8189) > (181 + 772)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				v137 = 18 - 12;
			end
			if ((v137 == (1264 - (668 + 595))) or ((2946 + 327) > (923 + 3650))) then
				if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (8 - 5)) and v15:HasTier(321 - (23 + 267), 1946 - (1129 + 815))) or ((3538 - (371 + 16)) < (3034 - (1326 + 424)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((3503 - 1653) == (5587 - 4058))) then
						return "blade_of_justice generators 4";
					end
				end
				if (((939 - (88 + 30)) < (2894 - (720 + 51))) and v100.DivineToll:IsCastable() and v42 and (v110 <= (4 - 2)) and ((v100.AvengingWrath:CooldownRemains() > (1791 - (421 + 1355))) or (v100.Crusade:CooldownRemains() > (24 - 9)) or (v108 < (4 + 4)))) then
					if (((1985 - (286 + 797)) < (8499 - 6174)) and v25(v100.DivineToll, not v17:IsInRange(49 - 19))) then
						return "divine_toll generators 6";
					end
				end
				if (((1297 - (397 + 42)) <= (926 + 2036)) and v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(831 - (24 + 776), 2 - 0)) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((4731 - (222 + 563)) < (2837 - 1549))) then
						return "judgment generators 7";
					end
				end
				v137 = 2 + 0;
			end
			if ((v137 == (197 - (23 + 167))) or ((5040 - (690 + 1108)) == (205 + 362))) then
				if ((v100.Judgment:IsReady() and v45 and ((v110 <= (3 + 0)) or not v100.BoundlessJudgment:IsAvailable())) or ((1695 - (40 + 808)) >= (208 + 1055))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((8615 - 6362) == (1770 + 81))) then
						return "judgment generators 32";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44 and ((v110 <= (2 + 1)) or (v17:HealthPercentage() > (11 + 9)) or not v100.VanguardsMomentum:IsAvailable())) or ((2658 - (47 + 524)) > (1540 + 832))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((12150 - 7705) < (6203 - 2054))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((4145 - 2327) == (1811 - (1165 + 561)))) then
					if (((19 + 611) < (6587 - 4460)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v137 = 4 + 4;
			end
			if ((v137 == (479 - (341 + 138))) or ((524 + 1414) == (5187 - 2673))) then
				if (((4581 - (89 + 237)) >= (176 - 121)) and ((v110 >= (10 - 5)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(912 - (581 + 300), 1224 - (855 + 365)) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (9 - 5))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(11 + 20, 1237 - (1030 + 205))))) then
					local v200 = 0 + 0;
					while true do
						if (((2790 + 209) > (1442 - (156 + 130))) and (v200 == (0 - 0))) then
							v30 = v122();
							if (((3960 - 1610) > (2365 - 1210)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((1062 + 2967) <= (2830 + 2023)) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (72 - (10 + 59))) and v15:HasTier(9 + 22, 9 - 7)) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1679 - (671 + 492)) > (2734 + 700))) then
						return "blade_of_justice generators 1";
					end
				end
				if (((5261 - (369 + 846)) >= (803 + 2230)) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (2 + 0)) and ((v100.AvengingWrath:CooldownRemains() > (1945 - (1036 + 909))) or (v100.Crusade:CooldownRemains() > (0 + 0)) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (6 - 2)) or (v108 < (211 - (11 + 192))) or not v100.ExecutionSentence:IsReady())) then
					if (v25(v100.WakeofAshes, not v17:IsInRange(6 + 4)) or ((2894 - (135 + 40)) <= (3505 - 2058))) then
						return "wake_of_ashes generators 2";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (8 - 4)) or ((6196 - 2062) < (4102 - (50 + 126)))) then
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (8 - 5)) or not v100.HolyBlade:IsAvailable())) or ((37 + 127) >= (4198 - (1233 + 180)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1494 - (522 + 447)) == (3530 - (107 + 1314)))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((16 + 17) == (100 - 67)) and ((v17:HealthPercentage() <= (9 + 11)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
					local v201 = 0 - 0;
					while true do
						if (((12083 - 9029) <= (5925 - (716 + 1194))) and (v201 == (0 + 0))) then
							v30 = v122();
							if (((201 + 1670) < (3885 - (74 + 429))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((2493 - 1200) <= (1074 + 1092)) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (4 - 2))) then
					if (v25(v100.Consecration, not v17:IsInRange(8 + 2)) or ((7950 - 5371) < (304 - 181))) then
						return "consecration generators 22";
					end
				end
				v137 = 438 - (279 + 154);
			end
			if (((781 - (454 + 324)) == v137) or ((666 + 180) >= (2385 - (12 + 5)))) then
				if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (2 + 0)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(76 - 46, 2 + 2)) and ((v110 <= (1096 - (277 + 816))) or (v17:HealthPercentage() > (85 - 65)) or not v100.VanguardsMomentum:IsAvailable())) or ((5195 - (1058 + 125)) <= (630 + 2728))) then
					if (((2469 - (815 + 160)) <= (12893 - 9888)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (9 - 5))) or ((743 + 2368) == (6237 - 4103))) then
					if (((4253 - (41 + 1857)) == (4248 - (1222 + 671))) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (7 - 4)) or not v100.BoundlessJudgment:IsAvailable())) or ((844 - 256) <= (1614 - (229 + 953)))) then
					if (((6571 - (1111 + 663)) >= (5474 - (874 + 705))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 16";
					end
				end
				v137 = 1 + 3;
			end
			if (((2441 + 1136) == (7434 - 3857)) and (v137 == (1 + 5))) then
				if (((4473 - (642 + 37)) > (843 + 2850)) and v30) then
					return v30;
				end
				if ((v100.TemplarSlash:IsReady() and v47) or ((204 + 1071) == (10294 - 6194))) then
					if (v25(v100.TemplarSlash, not v17:IsInRange(464 - (233 + 221))) or ((3678 - 2087) >= (3152 + 428))) then
						return "templar_slash generators 28";
					end
				end
				if (((2524 - (718 + 823)) <= (1138 + 670)) and v100.TemplarStrike:IsReady() and v48) then
					if (v25(v100.TemplarStrike, not v17:IsInRange(815 - (266 + 539))) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
						return "templar_strike generators 30";
					end
				end
				v137 = 16 - 9;
			end
			if (((7773 - 4004) >= (930 + 243)) and (v137 == (1 + 1))) then
				if (((2500 - (657 + 358)) == (3931 - 2446)) and (v110 >= (6 - 3)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1197 - (1151 + 36)))) then
					local v202 = 0 + 0;
					while true do
						if ((v202 == (0 + 0)) or ((9899 - 6584) <= (4614 - (1552 + 280)))) then
							v30 = v122();
							if (v30 or ((1710 - (64 + 770)) >= (2013 + 951))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (8 - 4)) and (v106 >= (1 + 1))) or ((3475 - (157 + 1086)) > (4997 - 2500))) then
					if (v25(v100.TemplarSlash, not v17:IsInRange(43 - 33)) or ((3236 - 1126) <= (452 - 120))) then
						return "templar_slash generators 8";
					end
				end
				if (((4505 - (599 + 220)) > (6316 - 3144)) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1934 - (1813 + 118))) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (2 + 0)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (1221 - (841 + 376))))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((6268 - 1794) < (191 + 629))) then
						return "blade_of_justice generators 10";
					end
				end
				v137 = 8 - 5;
			end
			if (((5138 - (464 + 395)) >= (7396 - 4514)) and (v137 == (4 + 4))) then
				if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (842 - (467 + 370))) and (v86 < v108)) or ((4192 - 2163) >= (2585 + 936))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(34 - 24)) or ((318 + 1719) >= (10799 - 6157))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((2240 - (150 + 370)) < (5740 - (74 + 1208))) and v100.Consecration:IsCastable() and v38) then
					if (v25(v100.Consecration, not v17:IsInRange(24 - 14)) or ((2067 - 1631) > (2150 + 871))) then
						return "consecration generators 30";
					end
				end
				if (((1103 - (14 + 376)) <= (1468 - 621)) and v100.DivineHammer:IsCastable() and v40) then
					if (((1394 + 760) <= (3542 + 489)) and v25(v100.DivineHammer, not v17:IsInRange(10 + 0))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v138 = 0 - 0;
		while true do
			if (((3472 + 1143) == (4693 - (23 + 55))) and (v138 == (9 - 5))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v138 = 4 + 1;
			end
			if (((7 + 0) == v138) or ((5876 - 2086) == (158 + 342))) then
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if (((990 - (652 + 249)) < (591 - 370)) and (v138 == (1868 - (708 + 1160)))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v138 = 2 - 1;
			end
			if (((3744 - 1690) >= (1448 - (10 + 17))) and (v138 == (1 + 2))) then
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v138 = 1736 - (1400 + 332);
			end
			if (((1326 - 634) < (4966 - (242 + 1666))) and (v138 == (3 + 3))) then
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v138 = 3 + 4;
			end
			if ((v138 == (1 + 0)) or ((4194 - (850 + 90)) == (2898 - 1243))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v138 = 1392 - (360 + 1030);
			end
			if ((v138 == (2 + 0)) or ((3657 - 2361) == (6755 - 1845))) then
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v138 = 1664 - (909 + 752);
			end
			if (((4591 - (109 + 1114)) == (6166 - 2798)) and ((2 + 3) == v138)) then
				v50 = EpicSettings.Settings['useVerdict'];
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v138 = 248 - (6 + 236);
			end
		end
	end
	local function v125()
		v59 = EpicSettings.Settings['useRebuke'];
		v60 = EpicSettings.Settings['useHammerofJustice'];
		v61 = EpicSettings.Settings['useDivineProtection'];
		v62 = EpicSettings.Settings['useDivineShield'];
		v63 = EpicSettings.Settings['useLayonHands'];
		v64 = EpicSettings.Settings['useLayOnHandsFocus'];
		v65 = EpicSettings.Settings['useWordofGloryFocus'];
		v66 = EpicSettings.Settings['useWordofGloryMouseover'];
		v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v69 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
		v70 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
		v71 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
		v72 = EpicSettings.Settings['layOnHandsFocusHP'] or (0 - 0);
		v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (1133 - (1076 + 57));
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 + 0);
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (689 - (579 + 110));
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v126()
		local v151 = 0 + 0;
		while true do
			if (((1403 + 1240) < (4222 - (174 + 233))) and (v151 == (5 - 3))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v151 = 4 - 1;
			end
			if (((851 + 1062) > (1667 - (663 + 511))) and (v151 == (0 + 0))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v151 = 2 - 1;
			end
			if (((2880 + 1875) > (8070 - 4642)) and (v151 == (2 - 1))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v151 = 1 + 1;
			end
			if (((2687 - 1306) <= (1689 + 680)) and ((1 + 5) == v151)) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (722 - (478 + 244));
				break;
			end
			if ((v151 == (520 - (440 + 77))) or ((2202 + 2641) == (14947 - 10863))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v151 = 1560 - (655 + 901);
			end
			if (((866 + 3803) > (278 + 85)) and ((4 + 1) == v151)) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v151 = 24 - 18;
			end
			if ((v151 == (1449 - (695 + 750))) or ((6409 - 4532) >= (4842 - 1704))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (351 - (285 + 66));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v151 = 11 - 6;
			end
		end
	end
	local function v127()
		local v152 = 1310 - (682 + 628);
		while true do
			if (((765 + 3977) >= (3925 - (176 + 123))) and (v152 == (1 + 1))) then
				v105 = v15:GetEnemiesInMeleeRange(6 + 2);
				if (v32 or ((4809 - (239 + 30)) == (250 + 666))) then
					v106 = #v105;
				else
					local v203 = 0 + 0;
					while true do
						if ((v203 == (0 - 0)) or ((3606 - 2450) > (4660 - (306 + 9)))) then
							v105 = {};
							v106 = 3 - 2;
							break;
						end
					end
				end
				if (((390 + 1847) < (2607 + 1642)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) or ((1292 + 1391) < (65 - 42))) then
						if (((2072 - (1140 + 235)) <= (526 + 300)) and v25(v100.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v152 = 3 + 0;
			end
			if (((284 + 821) <= (1228 - (33 + 19))) and (v152 == (2 + 1))) then
				if (((10127 - 6748) <= (1680 + 2132)) and not v15:AffectingCombat()) then
					if ((v100.RetributionAura:IsCastable() and (v114()) and v35) or ((1545 - 757) >= (1516 + 100))) then
						if (((2543 - (586 + 103)) <= (308 + 3071)) and v25(v100.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if (((14004 - 9455) == (6037 - (1309 + 179))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (v15:AffectingCombat() or ((5454 - 2432) >= (1317 + 1707))) then
						if (((12944 - 8124) > (1661 + 537)) and v100.Intercession:IsCastable()) then
							if (v25(v100.Intercession, not v17:IsInRange(63 - 33), true) or ((2114 - 1053) >= (5500 - (295 + 314)))) then
								return "intercession target";
							end
						end
					elseif (((3349 - 1985) <= (6435 - (1300 + 662))) and v100.Redemption:IsCastable()) then
						if (v25(v100.Redemption, not v17:IsInRange(94 - 64), true) or ((5350 - (1178 + 577)) <= (2 + 1))) then
							return "redemption target";
						end
					end
				end
				if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((13811 - 9139) == (5257 - (851 + 554)))) then
					if (((1379 + 180) == (4323 - 2764)) and v25(v104.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((3804 - 2052) <= (1090 - (115 + 187)))) then
					if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (3 + 0)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((3699 + 208) == (697 - 520))) then
						if (((4631 - (160 + 1001)) > (486 + 69)) and v25(v104.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				v152 = 3 + 1;
			end
			if ((v152 == (0 - 0)) or ((1330 - (237 + 121)) == (1542 - (525 + 372)))) then
				v125();
				v124();
				v126();
				v31 = EpicSettings.Toggles['ooc'];
				v152 = 1 - 0;
			end
			if (((10454 - 7272) >= (2257 - (96 + 46))) and ((778 - (643 + 134)) == v152)) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (((1406 + 2487) < (10619 - 6190)) and v15:IsDeadOrGhost()) then
					return v30;
				end
				v152 = 7 - 5;
			end
			if ((v152 == (4 + 0)) or ((5626 - 2759) < (3894 - 1989))) then
				if (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()) or ((2515 - (316 + 403)) >= (2693 + 1358))) then
					local v204 = 0 - 0;
					local v205;
					while true do
						if (((586 + 1033) <= (9458 - 5702)) and (v204 == (0 + 0))) then
							v205 = v80 and v100.CleanseToxins:IsReady() and v34;
							v30 = v99.FocusUnit(v205, nil, 7 + 13, nil, 86 - 61, v100.FlashofLight);
							v204 = 4 - 3;
						end
						if (((1254 - 650) == (35 + 569)) and (v204 == (1 - 0))) then
							if (v30 or ((220 + 4264) == (2647 - 1747))) then
								return v30;
							end
							break;
						end
					end
				end
				if (v34 or ((4476 - (12 + 5)) <= (4322 - 3209))) then
					local v206 = 0 - 0;
					while true do
						if (((7720 - 4088) > (8426 - 5028)) and ((1 + 0) == v206)) then
							if (((6055 - (1656 + 317)) <= (4382 + 535)) and v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (((3873 + 959) >= (3685 - 2299)) and v25(v104.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((674 - 537) == (491 - (5 + 349))) and (v206 == (0 - 0))) then
							v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1311 - (266 + 1005), 17 + 8, v100.FlashofLight);
							if (v30 or ((5356 - 3786) >= (5702 - 1370))) then
								return v30;
							end
							v206 = 1697 - (561 + 1135);
						end
					end
				end
				if (v99.TargetIsValid() or v15:AffectingCombat() or ((5295 - 1231) <= (5979 - 4160))) then
					local v207 = 1066 - (507 + 559);
					while true do
						if ((v207 == (2 - 1)) or ((15420 - 10434) < (1962 - (212 + 176)))) then
							if (((5331 - (250 + 655)) > (468 - 296)) and (v108 == (19414 - 8303))) then
								v108 = v10.FightRemains(v105, false);
							end
							v111 = v15:GCD();
							v207 = 2 - 0;
						end
						if (((2542 - (1869 + 87)) > (1578 - 1123)) and (v207 == (1901 - (484 + 1417)))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v207 = 2 - 1;
						end
						if (((1383 - 557) == (1599 - (48 + 725))) and (v207 == (2 - 0))) then
							v110 = v15:HolyPower();
							break;
						end
					end
				end
				if (v81 or ((10782 - 6763) > (2581 + 1860))) then
					local v208 = 0 - 0;
					while true do
						if (((565 + 1452) < (1242 + 3019)) and ((853 - (152 + 701)) == v208)) then
							if (((6027 - (430 + 881)) > (31 + 49)) and v77) then
								local v214 = 895 - (557 + 338);
								while true do
									if ((v214 == (0 + 0)) or ((9882 - 6375) == (11457 - 8185))) then
										v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 106 - 66);
										if (v30 or ((1887 - 1011) >= (3876 - (499 + 302)))) then
											return v30;
										end
										break;
									end
								end
							end
							if (((5218 - (39 + 827)) > (7050 - 4496)) and v78 and (v110 > (4 - 2))) then
								local v215 = 0 - 0;
								while true do
									if ((v215 == (0 - 0)) or ((378 + 4028) < (11833 - 7790))) then
										v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 7 + 33, true);
										if (v30 or ((2988 - 1099) >= (3487 - (103 + 1)))) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v152 = 559 - (475 + 79);
			end
			if (((4089 - 2197) <= (8748 - 6014)) and (v152 == (1 + 5))) then
				v30 = v118();
				if (((1693 + 230) < (3721 - (1395 + 108))) and v30) then
					return v30;
				end
				if (((6323 - 4150) > (1583 - (7 + 1197))) and not v15:AffectingCombat() and v31 and v99.TargetIsValid()) then
					local v209 = 0 + 0;
					while true do
						if ((v209 == (0 + 0)) or ((2910 - (27 + 292)) == (9989 - 6580))) then
							v30 = v120();
							if (((5755 - 1241) > (13940 - 10616)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((409 - 201) >= (9194 - 4366))) then
					local v210 = 139 - (43 + 96);
					while true do
						if (((4 - 3) == v210) or ((3578 - 1995) > (2960 + 607))) then
							if ((v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) or ((371 + 942) == (1568 - 774))) then
								if (((1217 + 1957) > (5438 - 2536)) and v25(v100.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if (((1298 + 2822) <= (313 + 3947)) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
								if (v25(v104.Healthstone) or ((2634 - (1414 + 337)) > (6718 - (1642 + 298)))) then
									return "healthstone defensive";
								end
							end
							v210 = 4 - 2;
						end
						if ((v210 == (11 - 7)) or ((10742 - 7122) >= (1610 + 3281))) then
							if (((3313 + 945) > (1909 - (357 + 615))) and v25(v100.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v210 == (3 + 0)) or ((11946 - 7077) < (777 + 129))) then
							v30 = v123();
							if (v30 or ((2625 - 1400) > (3382 + 846))) then
								return v30;
							end
							v210 = 1 + 3;
						end
						if (((2092 + 1236) > (3539 - (384 + 917))) and ((699 - (128 + 569)) == v210)) then
							if (((5382 - (1407 + 136)) > (3292 - (687 + 1200))) and v91 and (v15:HealthPercentage() <= v93)) then
								local v216 = 1710 - (556 + 1154);
								while true do
									if ((v216 == (0 - 0)) or ((1388 - (9 + 86)) <= (928 - (275 + 146)))) then
										if ((v95 == "Refreshing Healing Potion") or ((471 + 2425) < (869 - (29 + 35)))) then
											if (((10264 - 7948) == (6917 - 4601)) and v101.RefreshingHealingPotion:IsReady()) then
												if (v25(v104.RefreshingHealingPotion) or ((11345 - 8775) == (999 + 534))) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v95 == "Dreamwalker's Healing Potion") or ((1895 - (53 + 959)) == (1868 - (312 + 96)))) then
											if (v101.DreamwalkersHealingPotion:IsReady() or ((8016 - 3397) <= (1284 - (147 + 138)))) then
												if (v25(v104.RefreshingHealingPotion) or ((4309 - (813 + 86)) > (3720 + 396))) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v86 < v108) or ((1672 - 769) >= (3551 - (18 + 474)))) then
								local v217 = 0 + 0;
								while true do
									if ((v217 == (3 - 2)) or ((5062 - (860 + 226)) < (3160 - (121 + 182)))) then
										if (((607 + 4323) > (3547 - (988 + 252))) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) then
											if (v25(v104.UseWeapon) or ((458 + 3588) < (405 + 886))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
									if ((v217 == (1970 - (49 + 1921))) or ((5131 - (223 + 667)) == (3597 - (51 + 1)))) then
										v30 = v121();
										if (v30 or ((6967 - 2919) > (9061 - 4829))) then
											return v30;
										end
										v217 = 1126 - (146 + 979);
									end
								end
							end
							v210 = 1 + 2;
						end
						if ((v210 == (605 - (311 + 294))) or ((4880 - 3130) >= (1472 + 2001))) then
							if (((4609 - (496 + 947)) == (4524 - (1233 + 125))) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (((716 + 1047) < (3342 + 382)) and v25(v100.LayonHands)) then
									return "lay_on_hands_player defensive";
								end
							end
							if (((11 + 46) <= (4368 - (963 + 682))) and v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (v25(v100.DivineShield) or ((1728 + 342) == (1947 - (504 + 1000)))) then
									return "divine_shield defensive";
								end
							end
							v210 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v152 == (5 + 0)) or ((256 + 2449) == (2053 - 660))) then
				if (v82 or ((3931 + 670) < (36 + 25))) then
					local v211 = 182 - (156 + 26);
					while true do
						if ((v211 == (0 + 0)) or ((2174 - 784) >= (4908 - (149 + 15)))) then
							v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 990 - (890 + 70), true);
							if (v30 or ((2120 - (39 + 78)) > (4316 - (14 + 468)))) then
								return v30;
							end
							v211 = 2 - 1;
						end
						if ((v211 == (2 - 1)) or ((81 + 75) > (2350 + 1563))) then
							v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 7 + 23, true);
							if (((89 + 106) == (52 + 143)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v30 = v117();
				if (((5943 - 2838) >= (1776 + 20)) and v30) then
					return v30;
				end
				if (((15387 - 11008) >= (54 + 2077)) and v80 and v34) then
					if (((3895 - (12 + 39)) >= (1901 + 142)) and v14) then
						local v213 = 0 - 0;
						while true do
							if ((v213 == (0 - 0)) or ((959 + 2273) <= (1438 + 1293))) then
								v30 = v116();
								if (((12437 - 7532) == (3268 + 1637)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) or ((19988 - 15852) >= (6121 - (1596 + 114)))) then
						if (v100.CleanseToxins:IsReady() or ((7722 - 4764) == (4730 - (164 + 549)))) then
							if (((2666 - (1059 + 379)) >= (1008 - 195)) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v152 = 4 + 2;
			end
		end
	end
	local function v128()
		local v153 = 0 + 0;
		while true do
			if ((v153 == (392 - (145 + 247))) or ((2835 + 620) > (1872 + 2178))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v103();
				break;
			end
		end
	end
	v21.SetAPL(207 - 137, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

