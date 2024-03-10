local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1574 - (1281 + 293);
	local v6;
	while true do
		if (((4740 - (28 + 238)) >= (612 - 338)) and (v5 == (1559 - (1381 + 178)))) then
			v6 = v0[v4];
			if (not v6 or ((1777 + 117) <= (1134 + 272))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((5419 - 3847) >= (794 + 737)) and (v5 == (471 - (381 + 89)))) then
			return v6(...);
		end
	end
end
v0["Epix_Evoker_Preservation.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.Focus;
	local v17 = v13.MouseOver;
	local v18 = v13.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.CastPooling;
	local v24 = v21.CastAnnotated;
	local v25 = v21.CastSuggested;
	local v26 = v21.Press;
	local v27 = v21.Macro;
	local v28 = v21.Commons.Everyone;
	local v29 = v21.Commons.Everyone.num;
	local v30 = v21.Commons.Everyone.bool;
	local v31 = string.format;
	local v32 = 0 + 0;
	local v33 = 1 + 0;
	local v34 = 1 - 0;
	local v35 = 1157 - (1074 + 82);
	local v36 = false;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v93 = v19.Evoker.Preservation;
	local v94 = v20.Evoker.Preservation;
	local v95 = v27.Evoker.Preservation;
	local v96 = {};
	local v97 = v14:GetEquipment();
	local v98 = (v97[28 - 15] and v20(v97[1797 - (214 + 1570)])) or v20(1455 - (990 + 465));
	local v99 = (v97[6 + 8] and v20(v97[7 + 7])) or v20(0 + 0);
	local v100;
	local v101;
	local v102;
	local v103 = 43727 - 32616;
	local v104 = 12837 - (1668 + 58);
	local v105;
	local v106 = 626 - (512 + 114);
	local v107 = 0 - 0;
	local v108 = 0 - 0;
	local v109 = 0 - 0;
	v10:RegisterForEvent(function()
		v97 = v14:GetEquipment();
		v98 = (v97[7 + 6] and v20(v97[3 + 10])) or v20(0 + 0);
		v99 = (v97[47 - 33] and v20(v97[2008 - (109 + 1885)])) or v20(1469 - (1269 + 200));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if ((v126 == (815 - (98 + 717))) or ((5513 - (802 + 24)) < (7832 - 3290))) then
				v103 = 14032 - 2921;
				v104 = 1641 + 9470;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		local v127 = 0 + 0;
		while true do
			if (((541 + 2750) > (360 + 1307)) and (v127 == (0 - 0))) then
				if (v93.LivingFlame:IsCastable() or ((2911 - 2038) == (728 + 1306))) then
					if (v26(v93.LivingFlame, not v15:IsInRange(11 + 14), v105) or ((2323 + 493) < (8 + 3))) then
						return "living_flame precombat";
					end
				end
				if (((1728 + 1971) < (6139 - (797 + 636))) and v93.AzureStrike:IsCastable()) then
					if (((12847 - 10201) >= (2495 - (1427 + 192))) and v26(v93.AzureStrike, not v15:IsSpellInRange(v93.AzureStrike))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
		end
	end
	local function v111()
		local v128 = 0 + 0;
		while true do
			if (((1425 - 811) <= (2862 + 322)) and (v128 == (1 + 0))) then
				if (((3452 - (192 + 134)) == (4402 - (316 + 960))) and v41 and (v14:HealthPercentage() <= v43)) then
					if ((v42 == "Refreshing Healing Potion") or ((1218 + 969) >= (3824 + 1130))) then
						if (v94.RefreshingHealingPotion:IsReady() or ((3584 + 293) == (13667 - 10092))) then
							if (((1258 - (83 + 468)) > (2438 - (1202 + 604))) and v26(v95.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				if ((v93.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v87) and v86) or ((2548 - 2002) >= (4466 - 1782))) then
					if (((4056 - 2591) <= (4626 - (45 + 280))) and v22(v93.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze defensive";
					end
				end
				break;
			end
			if (((1645 + 59) > (1245 + 180)) and (v128 == (0 + 0))) then
				if ((v93.ObsidianScales:IsCastable() and v54 and v14:BuffDown(v93.ObsidianScales) and (v14:HealthPercentage() < v55)) or ((381 + 306) == (745 + 3489))) then
					if (v26(v93.ObsidianScales) or ((6166 - 2836) < (3340 - (340 + 1571)))) then
						return "obsidian_scales defensives";
					end
				end
				if (((453 + 694) >= (2107 - (1733 + 39))) and v94.Healthstone:IsReady() and v47 and (v14:HealthPercentage() <= v48)) then
					if (((9438 - 6003) > (3131 - (125 + 909))) and v26(v95.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1949 - (1096 + 852);
			end
		end
	end
	local function v112()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (1 - 0)) or ((3657 + 113) >= (4553 - (409 + 103)))) then
				if ((v93.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or ((4027 - (46 + 190)) <= (1706 - (51 + 44)))) then
					if (v26(v95.CauterizingFlameFocus) or ((1292 + 3286) <= (3325 - (1114 + 203)))) then
						return "cauterizing_flame dispel";
					end
				end
				if (((1851 - (228 + 498)) <= (450 + 1626)) and v93.OppressingRoar:IsReady() and v85 and v28.UnitHasEnrageBuff(v15)) then
					if (v26(v93.OppressingRoar) or ((411 + 332) >= (5062 - (174 + 489)))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if (((3008 - 1853) < (3578 - (830 + 1075))) and ((524 - (303 + 221)) == v129)) then
				if (not v16 or not v16:Exists() or not v28.UnitHasDispellableDebuffByPlayer(v16) or ((3593 - (231 + 1038)) <= (482 + 96))) then
					return;
				end
				if (((4929 - (171 + 991)) == (15524 - 11757)) and v93.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
					if (((10979 - 6890) == (10203 - 6114)) and v26(v95.ExpungeFocus)) then
						return "expunge dispel";
					end
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v113()
		if (((15626 - 11168) >= (4828 - 3154)) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v143 = 0 - 0;
			local v144;
			while true do
				if (((3004 - 2032) <= (2666 - (111 + 1137))) and (v143 == (159 - (91 + 67)))) then
					v144 = v28.InterruptWithStun(v93.TailSwipe, 23 - 15);
					if (v144 or ((1233 + 3705) < (5285 - (423 + 100)))) then
						return v144;
					end
					v143 = 1 + 1;
				end
				if ((v143 == (5 - 3)) or ((1306 + 1198) > (5035 - (326 + 445)))) then
					v144 = v28.Interrupt(v93.Quell, 43 - 33, true, v17, v95.QuellMouseover);
					if (((4795 - 2642) == (5024 - 2871)) and v144) then
						return v144;
					end
					break;
				end
				if ((v143 == (711 - (530 + 181))) or ((1388 - (614 + 267)) >= (2623 - (19 + 13)))) then
					v144 = v28.Interrupt(v93.Quell, 16 - 6, true);
					if (((10442 - 5961) == (12800 - 8319)) and v144) then
						return v144;
					end
					v143 = 1 + 0;
				end
			end
		end
	end
	local function v114()
		local v130 = v28.HandleTopTrinket(v96, v38, 70 - 30, nil);
		if (v130 or ((4827 - 2499) < (2505 - (1293 + 519)))) then
			return v130;
		end
		local v130 = v28.HandleBottomTrinket(v96, v38, 81 - 41, nil);
		if (((11299 - 6971) == (8276 - 3948)) and v130) then
			return v130;
		end
	end
	local function v115()
		local v131 = 0 - 0;
		while true do
			if (((3740 - 2152) >= (706 + 626)) and (v131 == (1 + 0))) then
				if ((v93.Disintegrate:IsReady() and v14:BuffUp(v93.EssenceBurstBuff)) or ((9698 - 5524) > (982 + 3266))) then
					if (v26(v93.Disintegrate, not v15:IsSpellInRange(v93.Disintegrate), v105) or ((1524 + 3062) <= (52 + 30))) then
						return "disintegrate damage";
					end
				end
				if (((4959 - (709 + 387)) == (5721 - (673 + 1185))) and v93.LivingFlame:IsCastable()) then
					if (v26(v93.LivingFlame, not v15:IsSpellInRange(v93.LivingFlame), v105) or ((817 - 535) <= (134 - 92))) then
						return "living_flame damage";
					end
				end
				v131 = 2 - 0;
			end
			if (((3297 + 1312) >= (573 + 193)) and (v131 == (0 - 0))) then
				if ((v93.LivingFlame:IsCastable() and v14:BuffUp(v93.LeapingFlamesBuff)) or ((283 + 869) == (4960 - 2472))) then
					if (((6717 - 3295) > (5230 - (446 + 1434))) and v26(v93.LivingFlame, not v15:IsSpellInRange(v93.LivingFlame), v105)) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (((2160 - (1040 + 243)) > (1122 - 746)) and v93.FireBreath:IsReady()) then
					if ((v102 <= (1849 - (559 + 1288))) or ((5049 - (609 + 1322)) <= (2305 - (13 + 441)))) then
						v106 = 3 - 2;
					elseif ((v102 <= (10 - 6)) or ((821 - 656) >= (131 + 3361))) then
						v106 = 7 - 5;
					elseif (((1403 + 2546) < (2128 + 2728)) and (v102 <= (17 - 11))) then
						v106 = 2 + 1;
					else
						v106 = 7 - 3;
					end
					v33 = v106;
					if (v26(v95.FireBreathMacro, not v15:IsInRange(20 + 10), true, nil, true) or ((2379 + 1897) < (2168 + 848))) then
						return "fire_breath damage " .. v106;
					end
				end
				v131 = 1 + 0;
			end
			if (((4589 + 101) > (4558 - (153 + 280))) and (v131 == (5 - 3))) then
				if (v93.AzureStrike:IsCastable() or ((45 + 5) >= (354 + 542))) then
					if (v26(v93.AzureStrike, not v15:IsSpellInRange(v93.AzureStrike)) or ((897 + 817) >= (2685 + 273))) then
						return "azure_strike damage";
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v132 = v114();
		if (v132 or ((1081 + 410) < (980 - 336))) then
			return v132;
		end
		if (((436 + 268) < (1654 - (89 + 578))) and v93.Stasis:IsReady() and v56 and v28.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo)) then
			if (((2657 + 1061) > (3961 - 2055)) and v26(v93.Stasis)) then
				return "stasis cooldown";
			end
		end
		if ((v93.StasisReactivate:IsReady() and v56 and (v28.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo) or (v14:BuffUp(v93.StasisBuff) and (v14:BuffRemains(v93.StasisBuff) < (1052 - (572 + 477)))))) or ((130 + 828) > (2182 + 1453))) then
			if (((418 + 3083) <= (4578 - (84 + 2))) and v26(v93.StasisReactivate)) then
				return "stasis_reactivate cooldown";
			end
		end
		if (v93.TipTheScales:IsCastable() or ((5671 - 2229) < (1836 + 712))) then
			if (((3717 - (497 + 345)) >= (38 + 1426)) and v93.DreamBreath:IsReady() and v59 and v28.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) then
				v34 = 1 + 0;
				if (v26(v95.TipTheScalesDreamBreath) or ((6130 - (605 + 728)) >= (3492 + 1401))) then
					return "dream_breath cooldown";
				end
			elseif ((v93.Spiritbloom:IsReady() and v62 and v28.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) or ((1224 - 673) > (95 + 1973))) then
				local v193 = 0 - 0;
				while true do
					if (((1906 + 208) > (2615 - 1671)) and ((0 + 0) == v193)) then
						v35 = 492 - (457 + 32);
						if (v26(v95.TipTheScalesSpiritbloom) or ((960 + 1302) >= (4498 - (832 + 570)))) then
							return "spirit_bloom cooldown";
						end
						break;
					end
				end
			end
		end
		if ((v93.DreamFlight:IsCastable() and (v90 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) or ((2125 + 130) >= (923 + 2614))) then
			if (v26(v95.DreamFlightCursor) or ((13578 - 9741) < (630 + 676))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((3746 - (588 + 208)) == (7950 - 5000)) and v93.DreamFlight:IsCastable() and (v90 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) then
			if (v26(v93.DreamFlight) or ((6523 - (884 + 916)) < (6904 - 3606))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((659 + 477) >= (807 - (232 + 421))) and v93.Rewind:IsCastable() and v65 and v28.AreUnitsBelowHealthPercentage(v66, v67, v93.Echo)) then
			if (v26(v93.Rewind) or ((2160 - (1569 + 320)) > (1165 + 3583))) then
				return "rewind cooldown";
			end
		end
		if (((901 + 3839) >= (10621 - 7469)) and v93.TimeDilation:IsCastable() and v68 and (v16:HealthPercentage() <= v69)) then
			if (v26(v95.TimeDilationFocus) or ((3183 - (316 + 289)) >= (8874 - 5484))) then
				return "time_dilation cooldown";
			end
		end
		if (((2 + 39) <= (3114 - (666 + 787))) and v93.FireBreath:IsReady()) then
			local v145 = 425 - (360 + 65);
			while true do
				if (((562 + 39) < (3814 - (79 + 175))) and (v145 == (0 - 0))) then
					if (((184 + 51) < (2105 - 1418)) and (v102 <= (3 - 1))) then
						v106 = 900 - (503 + 396);
					elseif (((4730 - (92 + 89)) > (2236 - 1083)) and (v102 <= (3 + 1))) then
						v106 = 2 + 0;
					elseif ((v102 <= (23 - 17)) or ((640 + 4034) < (10652 - 5980))) then
						v106 = 3 + 0;
					else
						v106 = 2 + 2;
					end
					v33 = v106;
					v145 = 2 - 1;
				end
				if (((458 + 3210) < (6955 - 2394)) and (v145 == (1245 - (485 + 759)))) then
					if (v26(v95.FireBreathMacro, not v15:IsInRange(69 - 39), true, nil, true) or ((1644 - (442 + 747)) == (4740 - (832 + 303)))) then
						return "fire_breath cds " .. v106;
					end
					break;
				end
			end
		end
	end
	local function v117()
		if ((v93.EmeraldBlossom:IsCastable() and v72 and v28.AreUnitsBelowHealthPercentage(v73, v74, v93.Echo)) or ((3609 - (88 + 858)) == (1010 + 2302))) then
			if (((3540 + 737) <= (185 + 4290)) and v26(v95.EmeraldBlossomFocus)) then
				return "emerald_blossom aoe_healing";
			end
		end
		if ((v70 == "Player Only") or ((1659 - (766 + 23)) == (5869 - 4680))) then
			if (((2123 - 570) <= (8254 - 5121)) and v93.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v71)) then
				if (v22(v95.VerdantEmbracePlayer, nil) or ((7592 - 5355) >= (4584 - (1036 + 37)))) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v70 == "Everyone") or ((939 + 385) > (5881 - 2861))) then
			if ((v93.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v71)) or ((2354 + 638) == (3361 - (641 + 839)))) then
				if (((4019 - (910 + 3)) > (3890 - 2364)) and v22(v95.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((4707 - (1466 + 218)) < (1779 + 2091)) and (v70 == "Not Tank")) then
			if (((1291 - (556 + 592)) > (27 + 47)) and v93.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v71) and (v28.UnitGroupRole(v16) ~= "TANK")) then
				if (((826 - (329 + 479)) < (2966 - (174 + 680))) and v22(v95.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((3769 - 2672) <= (3374 - 1746)) and v93.DreamBreath:IsReady() and v59 and v28.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) then
			if (((3306 + 1324) == (5369 - (396 + 343))) and (v109 <= (1 + 1))) then
				v107 = 1478 - (29 + 1448);
			else
				v107 = 1391 - (135 + 1254);
			end
			v34 = v107;
			if (((13335 - 9795) > (12527 - 9844)) and v26(v95.DreamBreathMacro, nil, true)) then
				return "dream_breath aoe_healing";
			end
		end
		if (((3195 + 1599) >= (4802 - (389 + 1138))) and v93.Spiritbloom:IsReady() and v62 and v28.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) then
			local v146 = 574 - (102 + 472);
			while true do
				if (((1401 + 83) == (823 + 661)) and (v146 == (0 + 0))) then
					if (((2977 - (320 + 1225)) < (6328 - 2773)) and (v109 > (2 + 0))) then
						v108 = 1467 - (157 + 1307);
					else
						v108 = 1860 - (821 + 1038);
					end
					v35 = 7 - 4;
					v146 = 1 + 0;
				end
				if ((v146 == (1 - 0)) or ((397 + 668) > (8868 - 5290))) then
					if (v26(v95.SpiritbloomFocus, nil, true) or ((5821 - (834 + 192)) < (90 + 1317))) then
						return "spirit_bloom aoe_healing";
					end
					break;
				end
			end
		end
		if (((476 + 1377) < (104 + 4709)) and v93.LivingFlame:IsCastable() and v75 and v14:BuffUp(v93.LeapingFlamesBuff) and (v16:HealthPercentage() <= v76)) then
			if (v26(v95.LivingFlameFocus, not v16:IsSpellInRange(v93.LivingFlame), v105) or ((4369 - 1548) < (2735 - (300 + 4)))) then
				return "living_flame_leaping_flames aoe_healing";
			end
		end
	end
	local function v118()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 - 0)) or ((3236 - (112 + 250)) < (870 + 1311))) then
				if ((v93.Reversion:IsReady() and v77 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v93.Reversion) < (2 - 1)) and (v16:HealthPercentage() <= v78)) or ((1541 + 1148) <= (178 + 165))) then
					if (v26(v95.ReversionFocus) or ((1398 + 471) == (997 + 1012))) then
						return "reversion_tank st_healing";
					end
				end
				if ((v93.Reversion:IsReady() and v77 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v93.Reversion, true, false) < (1 + 0)) and (v16:HealthPercentage() <= v79)) or ((4960 - (1001 + 413)) < (5177 - 2855))) then
					if (v26(v95.ReversionFocus) or ((2964 - (244 + 638)) == (5466 - (627 + 66)))) then
						return "reversion_tank st_healing";
					end
				end
				v133 = 2 - 1;
			end
			if (((3846 - (512 + 90)) > (2961 - (1665 + 241))) and (v133 == (719 - (373 + 344)))) then
				if ((v93.LivingFlame:IsReady() and v75 and (v16:HealthPercentage() <= v76)) or ((1495 + 1818) <= (471 + 1307))) then
					if (v26(v95.LivingFlameFocus, not v16:IsSpellInRange(v93.LivingFlame), v105) or ((3748 - 2327) >= (3560 - 1456))) then
						return "living_flame st_healing";
					end
				end
				break;
			end
			if (((2911 - (35 + 1064)) <= (2364 + 885)) and (v133 == (2 - 1))) then
				if (((7 + 1616) <= (3193 - (298 + 938))) and v93.TemporalAnomaly:IsReady() and v80 and v28.AreUnitsBelowHealthPercentage(v81, v82, v93.Echo)) then
					if (((5671 - (233 + 1026)) == (6078 - (636 + 1030))) and v26(v93.TemporalAnomaly, not v16:IsInRange(16 + 14), v105)) then
						return "temporal_anomaly st_healing";
					end
				end
				if (((1710 + 40) >= (251 + 591)) and v93.Echo:IsReady() and v83 and not v16:BuffUp(v93.Echo) and (v16:HealthPercentage() <= v84)) then
					if (((296 + 4076) > (2071 - (55 + 166))) and v26(v95.EchoFocus)) then
						return "echo st_healing";
					end
				end
				v133 = 1 + 1;
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		local v135;
		while true do
			if (((885 - 653) < (1118 - (36 + 261))) and (v134 == (1 - 0))) then
				v135 = v118();
				if (((1886 - (34 + 1334)) < (347 + 555)) and v135) then
					return v135;
				end
				break;
			end
			if (((2327 + 667) > (2141 - (1035 + 248))) and (v134 == (21 - (20 + 1)))) then
				v135 = v117();
				if (v135 or ((1957 + 1798) <= (1234 - (134 + 185)))) then
					return v135;
				end
				v134 = 1134 - (549 + 584);
			end
		end
	end
	local function v120()
		local v136 = 685 - (314 + 371);
		local v137;
		while true do
			if (((13546 - 9600) > (4711 - (478 + 490))) and (v136 == (2 + 0))) then
				if (v137 or ((2507 - (786 + 386)) >= (10707 - 7401))) then
					return v137;
				end
				v137 = v113();
				v136 = 1382 - (1055 + 324);
			end
			if (((6184 - (1093 + 247)) > (2003 + 250)) and (v136 == (1 + 0))) then
				if (((1794 - 1342) == (1533 - 1081)) and v137) then
					return v137;
				end
				v137 = v116();
				v136 = 5 - 3;
			end
			if ((v136 == (9 - 5)) or ((1622 + 2935) < (8040 - 5953))) then
				if (((13352 - 9478) == (2922 + 952)) and v137) then
					return v137;
				end
				if (v28.TargetIsValid() or ((4955 - 3017) > (5623 - (364 + 324)))) then
					local v175 = v115();
					if (v175 or ((11664 - 7409) < (8213 - 4790))) then
						return v175;
					end
				end
				break;
			end
			if (((482 + 972) <= (10423 - 7932)) and (v136 == (4 - 1))) then
				if (v137 or ((12625 - 8468) <= (4071 - (1249 + 19)))) then
					return v137;
				end
				v137 = v119();
				v136 = 4 + 0;
			end
			if (((18890 - 14037) >= (4068 - (686 + 400))) and (v136 == (0 + 0))) then
				if (((4363 - (73 + 156)) > (16 + 3341)) and (v46 or v45)) then
					local v176 = 811 - (721 + 90);
					local v177;
					while true do
						if ((v176 == (0 + 0)) or ((11094 - 7677) < (3004 - (224 + 246)))) then
							v177 = v112();
							if (v177 or ((4409 - 1687) <= (301 - 137))) then
								return v177;
							end
							break;
						end
					end
				end
				v137 = v111();
				v136 = 1 + 0;
			end
		end
	end
	local function v121()
		if (v46 or v45 or ((58 + 2350) < (1550 + 559))) then
			local v147 = 0 - 0;
			local v148;
			while true do
				if (((0 - 0) == v147) or ((546 - (203 + 310)) == (3448 - (1238 + 755)))) then
					v148 = v112();
					if (v148 or ((31 + 412) >= (5549 - (709 + 825)))) then
						return v148;
					end
					break;
				end
			end
		end
		if (((6231 - 2849) > (241 - 75)) and v36) then
			local v149 = v119();
			if (v149 or ((1144 - (196 + 668)) == (12077 - 9018))) then
				return v149;
			end
			if (((3896 - 2015) > (2126 - (171 + 662))) and v44 and v93.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v93.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v93.BlessingoftheBronzeBuff))) then
				if (((2450 - (4 + 89)) == (8261 - 5904)) and v26(v93.BlessingoftheBronze)) then
					return "blessing_of_the_bronze precombat";
				end
			end
			if (((45 + 78) == (540 - 417)) and v28.TargetIsValid()) then
				local v173 = 0 + 0;
				local v174;
				while true do
					if ((v173 == (1486 - (35 + 1451))) or ((2509 - (28 + 1425)) >= (5385 - (941 + 1052)))) then
						v174 = v110();
						if (v174 or ((1037 + 44) < (2589 - (822 + 692)))) then
							return v174;
						end
						break;
					end
				end
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1 + 1)) or ((1346 - (45 + 252)) >= (4386 + 46))) then
				v48 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v49 = EpicSettings.Settings['HandleCharredTreant'] or (0 - 0);
				v50 = EpicSettings.Settings['HandleCharredBrambles'] or (433 - (114 + 319));
				v51 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v138 = 3 - 0;
			end
			if ((v138 == (8 + 4)) or ((7103 - 2335) <= (1772 - 926))) then
				v88 = EpicSettings.Settings['UseHover'];
				v89 = EpicSettings.Settings['HoverTime'] or (1963 - (556 + 1407));
				break;
			end
			if (((1216 - (741 + 465)) == v138) or ((3823 - (170 + 295)) <= (749 + 671))) then
				v80 = EpicSettings.Settings['UseTemporalAnomaly'];
				v81 = EpicSettings.Settings['TemporalAnomalyHP'] or (0 + 0);
				v82 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 - 0);
				v83 = EpicSettings.Settings['UseEcho'];
				v138 = 10 + 1;
			end
			if ((v138 == (2 + 1)) or ((2118 + 1621) <= (4235 - (957 + 273)))) then
				v52 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v53 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v54 = EpicSettings.Settings['UseObsidianScales'];
				v55 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
				v138 = 10 - 6;
			end
			if ((v138 == (11 - 7)) or ((8214 - 6555) >= (3914 - (389 + 1391)))) then
				v56 = EpicSettings.Settings['UseStasis'];
				v57 = EpicSettings.Settings['StasisHP'] or (0 + 0);
				v58 = EpicSettings.Settings['StasisGroup'] or (0 + 0);
				v59 = EpicSettings.Settings['UseDreamBreath'];
				v138 = 11 - 6;
			end
			if ((v138 == (957 - (783 + 168))) or ((10941 - 7681) < (2317 + 38))) then
				v64 = EpicSettings.Settings['SpiritbloomGroup'] or (311 - (309 + 2));
				v65 = EpicSettings.Settings['UseRewind'];
				v66 = EpicSettings.Settings['RewindHP'] or (0 - 0);
				v67 = EpicSettings.Settings['RewindGroup'] or (1212 - (1090 + 122));
				v138 = 3 + 4;
			end
			if (((3 - 2) == v138) or ((458 + 211) == (5341 - (628 + 490)))) then
				v44 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 + 0);
				v45 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
				v46 = EpicSettings.Settings['DispelBuffs'] or (0 - 0);
				v47 = EpicSettings.Settings['UseHealthstone'];
				v138 = 776 - (431 + 343);
			end
			if (((16 - 8) == v138) or ((4894 - 3202) < (465 + 123))) then
				v72 = EpicSettings.Settings['UseEmeraldBlossom'];
				v73 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
				v74 = EpicSettings.Settings['EmeraldBlossomGroup'] or (1695 - (556 + 1139));
				v75 = EpicSettings.Settings['UseLivingFlame'];
				v138 = 24 - (6 + 9);
			end
			if ((v138 == (3 + 8)) or ((2458 + 2339) < (3820 - (28 + 141)))) then
				v84 = EpicSettings.Settings['EchoHP'] or (0 + 0);
				v85 = EpicSettings.Settings['UseOppressingRoar'];
				v86 = EpicSettings.Settings['UseRenewingBlaze'];
				v87 = EpicSettings.Settings['RenewingBlazeHP'] or (0 - 0);
				v138 = 9 + 3;
			end
			if ((v138 == (1324 - (486 + 831))) or ((10869 - 6692) > (17075 - 12225))) then
				v68 = EpicSettings.Settings['UseTimeDilation'];
				v69 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
				v70 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v71 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 - 0);
				v138 = 1271 - (668 + 595);
			end
			if ((v138 == (9 + 0)) or ((81 + 319) > (3029 - 1918))) then
				v76 = EpicSettings.Settings['LivingFlameHP'] or (290 - (23 + 267));
				v77 = EpicSettings.Settings['UseReversion'];
				v78 = EpicSettings.Settings['ReversionHP'] or (1944 - (1129 + 815));
				v79 = EpicSettings.Settings['ReversionTankHP'] or (387 - (371 + 16));
				v138 = 1760 - (1326 + 424);
			end
			if (((5778 - 2727) > (3672 - 2667)) and (v138 == (123 - (88 + 30)))) then
				v60 = EpicSettings.Settings['DreamBreathHP'] or (771 - (720 + 51));
				v61 = EpicSettings.Settings['DreamBreathGroup'] or (0 - 0);
				v62 = EpicSettings.Settings['UseSpiritbloom'];
				v63 = EpicSettings.Settings['SpiritbloomHP'] or (1776 - (421 + 1355));
				v138 = 9 - 3;
			end
			if (((1815 + 1878) <= (5465 - (286 + 797))) and ((0 - 0) == v138)) then
				v40 = EpicSettings.Settings['UseRacials'];
				v41 = EpicSettings.Settings['UseHealingPotion'];
				v42 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v43 = EpicSettings.Settings['HealingPotionHP'] or (439 - (397 + 42));
				v138 = 1 + 0;
			end
		end
	end
	local function v123()
		local v139 = 800 - (24 + 776);
		while true do
			if ((v139 == (1 - 0)) or ((4067 - (222 + 563)) > (9033 - 4933))) then
				v92 = EpicSettings.Settings['DreamFlightGroup'] or (0 + 0);
				break;
			end
			if ((v139 == (190 - (23 + 167))) or ((5378 - (690 + 1108)) < (1027 + 1817))) then
				v90 = EpicSettings.Settings['DreamFlightUsage'] or "";
				v91 = EpicSettings.Settings['DreamFlightHP'] or (0 + 0);
				v139 = 849 - (40 + 808);
			end
		end
	end
	local function v124()
		local v140 = 0 + 0;
		while true do
			if (((340 - 251) < (4292 + 198)) and (v140 == (0 + 0))) then
				v122();
				v123();
				if (v14:IsDeadOrGhost() or ((2733 + 2250) < (2379 - (47 + 524)))) then
					return;
				end
				v140 = 1 + 0;
			end
			if (((10466 - 6637) > (5635 - 1866)) and (v140 == (8 - 4))) then
				if (((3211 - (1165 + 561)) <= (87 + 2817)) and v88 and (v36 or v14:AffectingCombat())) then
					if (((13221 - 8952) == (1629 + 2640)) and ((GetTime() - v32) > v89)) then
						if (((866 - (341 + 138)) <= (751 + 2031)) and v93.Hover:IsReady() and v14:BuffDown(v93.Hover)) then
							if (v26(v93.Hover) or ((3918 - 2019) <= (1243 - (89 + 237)))) then
								return "hover main 2";
							end
						end
					end
				end
				v105 = v14:BuffRemains(v93.HoverBuff) < (6 - 4);
				v109 = v28.FriendlyUnitsBelowHealthPercentageCount(178 - 93);
				v140 = 886 - (581 + 300);
			end
			if ((v140 == (1221 - (855 + 365))) or ((10241 - 5929) <= (287 + 589))) then
				v36 = EpicSettings.Toggles['ooc'];
				v37 = EpicSettings.Toggles['aoe'];
				v38 = EpicSettings.Toggles['cds'];
				v140 = 1237 - (1030 + 205);
			end
			if (((2096 + 136) <= (2415 + 181)) and (v140 == (288 - (156 + 130)))) then
				v39 = EpicSettings.Toggles['dispel'];
				if (((4760 - 2665) < (6212 - 2526)) and v14:IsMounted()) then
					return;
				end
				if (not v14:IsMoving() or ((3266 - 1671) >= (1179 + 3295))) then
					v32 = GetTime();
				end
				v140 = 2 + 1;
			end
			if ((v140 == (76 - (10 + 59))) or ((1307 + 3312) < (14193 - 11311))) then
				if (v14:IsChanneling(v93.Spiritbloom) or ((1457 - (671 + 492)) >= (3846 + 985))) then
					local v178 = 1215 - (369 + 846);
					local v179;
					while true do
						if (((538 + 1491) <= (2632 + 452)) and ((1945 - (1036 + 909)) == v178)) then
							v179 = GetTime() - v14:CastStart();
							if ((v179 >= v14:EmpowerCastTime(v35)) or ((1620 + 417) == (4063 - 1643))) then
								local v199 = 203 - (11 + 192);
								while true do
									if (((2253 + 2205) > (4079 - (135 + 40))) and (v199 == (0 - 0))) then
										v10.EpicSettingsS = v93.Spiritbloom.ReturnID;
										return "Stopping Spiritbloom";
									end
								end
							end
							break;
						end
					end
				end
				if (((263 + 173) >= (270 - 147)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					local v180 = 0 - 0;
					local v181;
					while true do
						if (((676 - (50 + 126)) < (5056 - 3240)) and (v180 == (0 + 0))) then
							v181 = v28.DeadFriendlyUnitsCount();
							if (((4987 - (1233 + 180)) == (4543 - (522 + 447))) and not v14:AffectingCombat()) then
								if (((1642 - (107 + 1314)) < (181 + 209)) and (v181 > (2 - 1))) then
									if (v26(v93.MassReturn, nil, true) or ((940 + 1273) <= (2821 - 1400))) then
										return "mass_return";
									end
								elseif (((12099 - 9041) < (6770 - (716 + 1194))) and v26(v93.Return, not v15:IsInRange(1 + 29), true)) then
									return "return";
								end
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or ((139 + 1157) >= (4949 - (74 + 429)))) then
					if (v14:AffectingCombat() or ((2686 - 1293) > (2225 + 2264))) then
						local v194 = 0 - 0;
						local v195;
						while true do
							if ((v194 == (0 + 0)) or ((13638 - 9214) < (66 - 39))) then
								v195 = v120();
								if (v195 or ((2430 - (279 + 154)) > (4593 - (454 + 324)))) then
									return v195;
								end
								break;
							end
						end
					else
						local v196 = v121();
						if (((2727 + 738) > (1930 - (12 + 5))) and v196) then
							return v196;
						end
					end
				end
				break;
			end
			if (((396 + 337) < (4634 - 2815)) and (v140 == (2 + 1))) then
				if (v14:AffectingCombat() or v45 or v36 or ((5488 - (277 + 816)) == (20318 - 15563))) then
					local v182 = 1183 - (1058 + 125);
					local v183;
					local v184;
					while true do
						if ((v182 == (0 + 0)) or ((4768 - (815 + 160)) < (10164 - 7795))) then
							v183 = v45 and v93.Expunge:IsReady();
							v184 = v28.FocusUnit(v183, nil, 94 - 54, nil, 5 + 15, v93.Echo);
							v182 = 2 - 1;
						end
						if ((v182 == (1899 - (41 + 1857))) or ((5977 - (1222 + 671)) == (684 - 419))) then
							if (((6263 - 1905) == (5540 - (229 + 953))) and v184) then
								return v184;
							end
							break;
						end
					end
				end
				if (v49 or ((4912 - (1111 + 663)) < (2572 - (874 + 705)))) then
					local v185 = 0 + 0;
					local v186;
					while true do
						if (((2272 + 1058) > (4828 - 2505)) and (v185 == (0 + 0))) then
							v186 = v28.HandleCharredTreant(v93.Echo, v95.EchoMouseover, 719 - (642 + 37));
							if (v186 or ((827 + 2799) == (639 + 3350))) then
								return v186;
							end
							v185 = 2 - 1;
						end
						if ((v185 == (455 - (233 + 221))) or ((2117 - 1201) == (2351 + 320))) then
							v186 = v28.HandleCharredTreant(v93.LivingFlame, v95.LivingFlameMouseover, 1581 - (718 + 823), true);
							if (((172 + 100) == (1077 - (266 + 539))) and v186) then
								return v186;
							end
							break;
						end
					end
				end
				if (((12029 - 7780) <= (6064 - (636 + 589))) and v50) then
					local v187 = 0 - 0;
					local v188;
					while true do
						if (((5727 - 2950) < (2536 + 664)) and (v187 == (1 + 0))) then
							v188 = v28.HandleCharredBrambles(v93.LivingFlame, v95.LivingFlameMouseover, 1055 - (657 + 358), true);
							if (((251 - 156) < (4458 - 2501)) and v188) then
								return v188;
							end
							break;
						end
						if (((2013 - (1151 + 36)) < (1659 + 58)) and (v187 == (0 + 0))) then
							v188 = v28.HandleCharredBrambles(v93.Echo, v95.EchoMouseover, 119 - 79);
							if (((3258 - (1552 + 280)) >= (1939 - (64 + 770))) and v188) then
								return v188;
							end
							v187 = 1 + 0;
						end
					end
				end
				v140 = 8 - 4;
			end
			if (((489 + 2265) <= (4622 - (157 + 1086))) and (v140 == (11 - 5))) then
				if (v28.TargetIsValid() or v14:AffectingCombat() or ((17199 - 13272) == (2166 - 753))) then
					local v189 = 0 - 0;
					while true do
						if ((v189 == (819 - (599 + 220))) or ((2297 - 1143) <= (2719 - (1813 + 118)))) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v189 = 1 + 0;
						end
						if ((v189 == (1218 - (841 + 376))) or ((2301 - 658) > (785 + 2594))) then
							if ((v104 == (30327 - 19216)) or ((3662 - (464 + 395)) > (11674 - 7125))) then
								v104 = v10.FightRemains(v100, false);
							end
							break;
						end
					end
				end
				if (v14:IsChanneling(v93.FireBreath) or ((106 + 114) >= (3859 - (467 + 370)))) then
					local v190 = 0 - 0;
					local v191;
					while true do
						if (((2072 + 750) == (9673 - 6851)) and (v190 == (0 + 0))) then
							v191 = GetTime() - v14:CastStart();
							if ((v191 >= v14:EmpowerCastTime(v33)) or ((2468 - 1407) == (2377 - (150 + 370)))) then
								v10.EpicSettingsS = v93.FireBreath.ReturnID;
								return "Stopping Fire Breath";
							end
							break;
						end
					end
				end
				if (((4042 - (74 + 1208)) > (3354 - 1990)) and v14:IsChanneling(v93.DreamBreath)) then
					local v192 = GetTime() - v14:CastStart();
					if ((v192 >= v14:EmpowerCastTime(v34)) or ((23248 - 18346) <= (2559 + 1036))) then
						v10.EpicSettingsS = v93.DreamBreath.ReturnID;
						return "Stopping DreamBreath";
					end
				end
				v140 = 397 - (14 + 376);
			end
			if ((v140 == (8 - 3)) or ((2493 + 1359) == (258 + 35))) then
				v100 = v14:GetEnemiesInRange(24 + 1);
				v101 = v15:GetEnemiesInSplashRange(23 - 15);
				if (v37 or ((1173 + 386) == (4666 - (23 + 55)))) then
					v102 = #v101;
				else
					v102 = 2 - 1;
				end
				v140 = 5 + 1;
			end
		end
	end
	local function v125()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (0 - 0)) or ((1411 + 3073) == (1689 - (652 + 249)))) then
				v21.Print("Preservation Evoker by Epic BoomK");
				EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
				v141 = 2 - 1;
			end
			if (((6436 - (708 + 1160)) >= (10605 - 6698)) and (v141 == (1 - 0))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
				v141 = 29 - (10 + 17);
			end
			if (((280 + 966) < (5202 - (1400 + 332))) and (v141 == (3 - 1))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
				break;
			end
		end
	end
	v21.SetAPL(3376 - (242 + 1666), v124, v125);
end;
return v0["Epix_Evoker_Preservation.lua"]();

