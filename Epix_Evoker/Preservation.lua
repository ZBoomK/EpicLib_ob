local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2 - 1) == v5) or ((1095 - 460) == (3130 - (157 + 1234)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((3222 - (991 + 564)) >= (2152 + 1139))) then
			v6 = v0[v4];
			if (not v6 or ((2432 - (1381 + 178)) == (1908 + 126))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v32 = GetUnitEmpowerStageDuration;
	local v33 = 0 + 0;
	local v34 = 3 - 2;
	local v35 = 1 + 0;
	local v36 = 471 - (381 + 89);
	local v37 = false;
	local v38 = false;
	local v39 = false;
	local v40 = false;
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
	local v94 = v19.Evoker.Preservation;
	local v95 = v20.Evoker.Preservation;
	local v96 = v27.Evoker.Preservation;
	local v97 = {};
	local v98 = v14:GetEquipment();
	local v99 = (v98[12 + 1] and v20(v98[9 + 4])) or v20(0 - 0);
	local v100 = (v98[1170 - (1074 + 82)] and v20(v98[30 - 16])) or v20(1784 - (214 + 1570));
	local v101;
	local v102;
	local v103;
	local v104 = 12566 - (990 + 465);
	local v105 = 4581 + 6530;
	local v106;
	local v107 = 0 + 0;
	local v108 = 0 + 0;
	local v109 = 0 - 0;
	local v110 = 1726 - (1668 + 58);
	v10:RegisterForEvent(function()
		local v127 = 626 - (512 + 114);
		while true do
			if (((0 - 0) == v127) or ((5821 - 3005) < (38 - 27))) then
				v98 = v14:GetEquipment();
				v99 = (v98[7 + 6] and v20(v98[3 + 10])) or v20(0 + 0);
				v127 = 3 - 2;
			end
			if (((5693 - (109 + 1885)) < (6175 - (1269 + 200))) and ((1 - 0) == v127)) then
				v100 = (v98[829 - (98 + 717)] and v20(v98[840 - (802 + 24)])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if (((391 + 2255) >= (674 + 202)) and (v128 == (0 + 0))) then
				v104 = 2397 + 8714;
				v105 = 30910 - 19799;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v129 = 0 - 0;
		while true do
			if (((220 + 394) <= (1297 + 1887)) and (v129 == (0 + 0))) then
				if (((2274 + 852) == (1460 + 1666)) and v94.LivingFlame:IsCastable()) then
					if (v26(v94.LivingFlame, not v15:IsInRange(1458 - (797 + 636)), v106) or ((10618 - 8431) >= (6573 - (1427 + 192)))) then
						return "living_flame precombat";
					end
				end
				if (v94.AzureStrike:IsCastable() or ((1344 + 2533) == (8300 - 4725))) then
					if (((636 + 71) > (287 + 345)) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
		end
	end
	local function v112()
		if ((v94.ObsidianScales:IsCastable() and v55 and v14:BuffDown(v94.ObsidianScales) and (v14:HealthPercentage() < v56)) or ((872 - (192 + 134)) >= (3960 - (316 + 960)))) then
			if (((816 + 649) <= (3320 + 981)) and v26(v94.ObsidianScales)) then
				return "obsidian_scales defensives";
			end
		end
		if (((1576 + 128) > (5447 - 4022)) and v95.Healthstone:IsReady() and v48 and (v14:HealthPercentage() <= v49)) then
			if (v26(v96.Healthstone, nil, nil, true) or ((1238 - (83 + 468)) == (6040 - (1202 + 604)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v42 and (v14:HealthPercentage() <= v44)) or ((15545 - 12215) < (2377 - 948))) then
			if (((3175 - 2028) >= (660 - (45 + 280))) and (v43 == "Refreshing Healing Potion")) then
				if (((3316 + 119) > (1833 + 264)) and v95.RefreshingHealingPotion:IsReady()) then
					if (v26(v96.RefreshingHealingPotion, nil, nil, true) or ((1377 + 2393) >= (2237 + 1804))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
		if ((v94.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v88) and v87) or ((667 + 3124) <= (2983 - 1372))) then
			if (v22(v94.RenewingBlaze, nil, nil) or ((6489 - (340 + 1571)) <= (793 + 1215))) then
				return "RenewingBlaze defensive";
			end
		end
	end
	local function v113()
		if (((2897 - (1733 + 39)) <= (5704 - 3628)) and v94.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
			if (v26(v96.ExpungeFocus) or ((1777 - (125 + 909)) >= (6347 - (1096 + 852)))) then
				return "expunge dispel";
			end
		end
		if (((519 + 636) < (2388 - 715)) and v94.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
			if (v26(v96.CauterizingFlameFocus) or ((2255 + 69) <= (1090 - (409 + 103)))) then
				return "cauterizing_flame dispel";
			end
		end
		if (((4003 - (46 + 190)) == (3862 - (51 + 44))) and v94.OppressingRoar:IsReady() and v86 and v28.UnitHasEnrageBuff(v15)) then
			if (((1154 + 2935) == (5406 - (1114 + 203))) and v26(v94.OppressingRoar)) then
				return "Oppressing Roar dispel";
			end
		end
	end
	local function v114()
		if (((5184 - (228 + 498)) >= (363 + 1311)) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v142 = v28.Interrupt(v94.Quell, 6 + 4, true);
			if (((1635 - (174 + 489)) <= (3694 - 2276)) and v142) then
				return v142;
			end
			v142 = v28.InterruptWithStun(v94.TailSwipe, 1913 - (830 + 1075));
			if (v142 or ((5462 - (303 + 221)) < (6031 - (231 + 1038)))) then
				return v142;
			end
			v142 = v28.Interrupt(v94.Quell, 9 + 1, true, v17, v96.QuellMouseover);
			if (v142 or ((3666 - (171 + 991)) > (17572 - 13308))) then
				return v142;
			end
		end
	end
	local function v115()
		local v130 = 0 - 0;
		local v131;
		while true do
			if (((5372 - 3219) == (1724 + 429)) and (v130 == (3 - 2))) then
				v131 = v28.HandleBottomTrinket(v97, v39, 115 - 75, nil);
				if (v131 or ((816 - 309) >= (8009 - 5418))) then
					return v131;
				end
				break;
			end
			if (((5729 - (111 + 1137)) == (4639 - (91 + 67))) and (v130 == (0 - 0))) then
				v131 = v28.HandleTopTrinket(v97, v39, 10 + 30, nil);
				if (v131 or ((2851 - (423 + 100)) < (5 + 688))) then
					return v131;
				end
				v130 = 2 - 1;
			end
		end
	end
	local function v116()
		if (((2256 + 2072) == (5099 - (326 + 445))) and v94.LivingFlame:IsCastable() and v14:BuffUp(v94.LeapingFlamesBuff)) then
			if (((6929 - 5341) >= (2967 - 1635)) and v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106)) then
				return "living_flame_leaping_flames damage";
			end
		end
		if (v94.FireBreath:IsReady() or ((9742 - 5568) > (4959 - (530 + 181)))) then
			local v143 = 881 - (614 + 267);
			while true do
				if ((v143 == (33 - (19 + 13))) or ((7463 - 2877) <= (190 - 108))) then
					if (((11035 - 7172) == (1004 + 2859)) and v26(v96.FireBreathMacro, not v15:IsInRange(52 - 22), true, nil, true)) then
						return "fire_breath damage " .. v107;
					end
					break;
				end
				if ((v143 == (0 - 0)) or ((2094 - (1293 + 519)) <= (85 - 43))) then
					if (((12033 - 7424) >= (1464 - 698)) and (v103 <= (8 - 6))) then
						v107 = 2 - 1;
					elseif ((v103 <= (3 + 1)) or ((236 + 916) == (5780 - 3292))) then
						v107 = 1 + 1;
					elseif (((1137 + 2285) > (2094 + 1256)) and (v103 <= (1102 - (709 + 387)))) then
						v107 = 1861 - (673 + 1185);
					else
						v107 = 11 - 7;
					end
					v34 = v107;
					v143 = 3 - 2;
				end
			end
		end
		if (((1442 - 565) > (269 + 107)) and v94.Disintegrate:IsReady() and v14:BuffUp(v94.EssenceBurstBuff)) then
			if (v26(v94.Disintegrate, not v15:IsSpellInRange(v94.Disintegrate), v106) or ((2330 + 788) <= (2498 - 647))) then
				return "disintegrate damage";
			end
		end
		if (v94.LivingFlame:IsCastable() or ((41 + 124) >= (6962 - 3470))) then
			if (((7751 - 3802) < (6736 - (446 + 1434))) and v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106)) then
				return "living_flame damage";
			end
		end
		if (v94.AzureStrike:IsCastable() or ((5559 - (1040 + 243)) < (9001 - 5985))) then
			if (((6537 - (559 + 1288)) > (6056 - (609 + 1322))) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
				return "azure_strike damage";
			end
		end
	end
	local function v117()
		local v132 = v115();
		if (v132 or ((504 - (13 + 441)) >= (3347 - 2451))) then
			return v132;
		end
		if ((v94.Stasis:IsReady() and v57 and v28.AreUnitsBelowHealthPercentage(v58, v59)) or ((4489 - 2775) >= (14732 - 11774))) then
			if (v26(v94.Stasis) or ((56 + 1435) < (2338 - 1694))) then
				return "stasis cooldown";
			end
		end
		if (((251 + 453) < (433 + 554)) and v94.StasisReactivate:IsReady() and v57 and (v28.AreUnitsBelowHealthPercentage(v58, v59) or (v14:BuffUp(v94.StasisBuff) and (v14:BuffRemains(v94.StasisBuff) < (8 - 5))))) then
			if (((2035 + 1683) > (3504 - 1598)) and v26(v94.StasisReactivate)) then
				return "stasis_reactivate cooldown";
			end
		end
		if (v94.TipTheScales:IsCastable() or ((634 + 324) > (2022 + 1613))) then
			if (((2516 + 985) <= (3772 + 720)) and v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) then
				v35 = 1 + 0;
				if (v26(v96.TipTheScalesDreamBreath) or ((3875 - (153 + 280)) < (7357 - 4809))) then
					return "dream_breath cooldown";
				end
			elseif (((2582 + 293) >= (579 + 885)) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
				local v191 = 0 + 0;
				while true do
					if ((v191 == (0 + 0)) or ((3476 + 1321) >= (7450 - 2557))) then
						v36 = 2 + 1;
						if (v26(v96.TipTheScalesSpiritbloom) or ((1218 - (89 + 578)) > (1478 + 590))) then
							return "spirit_bloom cooldown";
						end
						break;
					end
				end
			end
		end
		if (((4394 - 2280) > (1993 - (572 + 477))) and v94.DreamFlight:IsCastable() and (v91 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v92, v93)) then
			if (v26(v96.DreamFlightCursor) or ((306 + 1956) >= (1858 + 1238))) then
				return "Dream_Flight cooldown";
			end
		end
		if ((v94.DreamFlight:IsCastable() and (v91 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v92, v93)) or ((270 + 1985) >= (3623 - (84 + 2)))) then
			if (v26(v94.DreamFlight) or ((6322 - 2485) < (941 + 365))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((3792 - (497 + 345)) == (76 + 2874)) and v94.Rewind:IsCastable() and v66 and v28.AreUnitsBelowHealthPercentage(v67, v68)) then
			if (v26(v94.Rewind) or ((799 + 3924) < (4631 - (605 + 728)))) then
				return "rewind cooldown";
			end
		end
		if (((811 + 325) >= (341 - 187)) and v94.TimeDilation:IsCastable() and v69 and (v16:HealthPercentage() <= v70)) then
			if (v26(v96.TimeDilationFocus) or ((13 + 258) > (17554 - 12806))) then
				return "time_dilation cooldown";
			end
		end
		if (((4274 + 466) >= (8732 - 5580)) and v94.FireBreath:IsReady()) then
			local v144 = 0 + 0;
			while true do
				if ((v144 == (489 - (457 + 32))) or ((1094 + 1484) >= (4792 - (832 + 570)))) then
					if (((39 + 2) <= (434 + 1227)) and (v103 <= (6 - 4))) then
						v107 = 1 + 0;
					elseif (((1397 - (588 + 208)) < (9595 - 6035)) and (v103 <= (1804 - (884 + 916)))) then
						v107 = 3 - 1;
					elseif (((137 + 98) < (1340 - (232 + 421))) and (v103 <= (1895 - (1569 + 320)))) then
						v107 = 1 + 2;
					else
						v107 = 1 + 3;
					end
					v34 = v107;
					v144 = 3 - 2;
				end
				if (((5154 - (316 + 289)) > (3017 - 1864)) and (v144 == (1 + 0))) then
					if (v26(v96.FireBreathMacro, not v15:IsInRange(1483 - (666 + 787)), true, nil, true) or ((5099 - (360 + 65)) < (4367 + 305))) then
						return "fire_breath cds " .. v107;
					end
					break;
				end
			end
		end
	end
	local function v118()
		if (((3922 - (79 + 175)) < (7191 - 2630)) and v94.EmeraldBlossom:IsCastable() and v73 and v28.AreUnitsBelowHealthPercentage(v74, v75)) then
			if (v26(v96.EmeraldBlossomFocus) or ((356 + 99) == (11050 - 7445))) then
				return "emerald_blossom aoe_healing";
			end
		end
		if ((v71 == "Player Only") or ((5128 - 2465) == (4211 - (503 + 396)))) then
			if (((4458 - (92 + 89)) <= (8680 - 4205)) and v94.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v72)) then
				if (v22(v96.VerdantEmbracePlayer, nil) or ((447 + 423) == (704 + 485))) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((6081 - 4528) <= (429 + 2704)) and (v71 == "Everyone")) then
			if ((v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72)) or ((5100 - 2863) >= (3064 + 447))) then
				if (v22(v96.VerdantEmbraceFocus, nil) or ((633 + 691) > (9197 - 6177))) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v71 == "Not Tank") or ((374 + 2618) == (2868 - 987))) then
			if (((4350 - (485 + 759)) > (3530 - 2004)) and v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72) and (v28.UnitGroupRole(v16) ~= "TANK")) then
				if (((4212 - (442 + 747)) < (5005 - (832 + 303))) and v22(v96.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((1089 - (88 + 858)) > (23 + 51)) and v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) then
			local v145 = 0 + 0;
			while true do
				if (((1 + 17) < (2901 - (766 + 23))) and ((4 - 3) == v145)) then
					if (((1500 - 403) <= (4289 - 2661)) and v26(v96.DreamBreathMacro, nil, true)) then
						return "dream_breath aoe_healing";
					end
					break;
				end
				if (((15714 - 11084) == (5703 - (1036 + 37))) and (v145 == (0 + 0))) then
					if (((6893 - 3353) > (2111 + 572)) and (v110 <= (1482 - (641 + 839)))) then
						v108 = 914 - (910 + 3);
					else
						v108 = 4 - 2;
					end
					v35 = v108;
					v145 = 1685 - (1466 + 218);
				end
			end
		end
		if (((2204 + 2590) >= (4423 - (556 + 592))) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
			local v146 = 0 + 0;
			while true do
				if (((2292 - (329 + 479)) == (2338 - (174 + 680))) and (v146 == (3 - 2))) then
					if (((2967 - 1535) < (2539 + 1016)) and v26(v96.SpiritbloomFocus, nil, true)) then
						return "spirit_bloom aoe_healing";
					end
					break;
				end
				if ((v146 == (739 - (396 + 343))) or ((95 + 970) > (5055 - (29 + 1448)))) then
					if ((v110 > (1391 - (135 + 1254))) or ((18063 - 13268) < (6569 - 5162))) then
						v109 = 2 + 1;
					else
						v109 = 1528 - (389 + 1138);
					end
					v36 = 577 - (102 + 472);
					v146 = 1 + 0;
				end
			end
		end
		if (((1028 + 825) < (4488 + 325)) and v94.LivingFlame:IsCastable() and v76 and v14:BuffUp(v94.LeapingFlamesBuff) and (v16:HealthPercentage() <= v77)) then
			if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or ((4366 - (320 + 1225)) < (4327 - 1896))) then
				return "living_flame_leaping_flames aoe_healing";
			end
		end
	end
	local function v119()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (1466 - (157 + 1307))) or ((4733 - (821 + 1038)) < (5441 - 3260))) then
				if ((v94.LivingFlame:IsReady() and v76 and (v16:HealthPercentage() <= v77)) or ((295 + 2394) <= (608 - 265))) then
					if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or ((696 + 1173) == (4979 - 2970))) then
						return "living_flame st_healing";
					end
				end
				break;
			end
			if ((v133 == (1027 - (834 + 192))) or ((226 + 3320) < (596 + 1726))) then
				if ((v94.TemporalAnomaly:IsReady() and v81 and v28.AreUnitsBelowHealthPercentage(v82, v83)) or ((45 + 2037) == (7394 - 2621))) then
					if (((3548 - (300 + 4)) > (282 + 773)) and v26(v94.TemporalAnomaly, not v16:IsInRange(78 - 48), v106)) then
						return "temporal_anomaly st_healing";
					end
				end
				if ((v94.Echo:IsReady() and v84 and not v16:BuffUp(v94.Echo) and (v16:HealthPercentage() <= v85)) or ((3675 - (112 + 250)) <= (709 + 1069))) then
					if (v26(v96.EchoFocus) or ((3559 - 2138) >= (1206 + 898))) then
						return "echo st_healing";
					end
				end
				v133 = 2 + 0;
			end
			if (((1356 + 456) <= (1611 + 1638)) and (v133 == (0 + 0))) then
				if (((3037 - (1001 + 413)) <= (4363 - 2406)) and v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion) < (883 - (244 + 638))) and (v16:HealthPercentage() <= v79)) then
					if (((5105 - (627 + 66)) == (13146 - 8734)) and v26(v96.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				if (((2352 - (512 + 90)) >= (2748 - (1665 + 241))) and v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion, true, false) < (718 - (373 + 344))) and (v16:HealthPercentage() <= v80)) then
					if (((1972 + 2400) > (490 + 1360)) and v26(v96.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v133 = 2 - 1;
			end
		end
	end
	local function v120()
		local v134 = 0 - 0;
		local v135;
		while true do
			if (((1331 - (35 + 1064)) < (598 + 223)) and (v134 == (2 - 1))) then
				v135 = v119();
				if (((3 + 515) < (2138 - (298 + 938))) and v135) then
					return v135;
				end
				break;
			end
			if (((4253 - (233 + 1026)) > (2524 - (636 + 1030))) and (v134 == (0 + 0))) then
				v135 = v118();
				if (v135 or ((3668 + 87) <= (272 + 643))) then
					return v135;
				end
				v134 = 1 + 0;
			end
		end
	end
	local function v121()
		local v136 = 221 - (55 + 166);
		local v137;
		while true do
			if (((765 + 3181) > (377 + 3366)) and (v136 == (11 - 8))) then
				if (v137 or ((1632 - (36 + 261)) >= (5781 - 2475))) then
					return v137;
				end
				v137 = v120();
				v136 = 1372 - (34 + 1334);
			end
			if (((1863 + 2981) > (1751 + 502)) and ((1283 - (1035 + 248)) == v136)) then
				if (((473 - (20 + 1)) == (236 + 216)) and (v47 or v46)) then
					local v174 = 319 - (134 + 185);
					local v175;
					while true do
						if ((v174 == (1133 - (549 + 584))) or ((5242 - (314 + 371)) < (7164 - 5077))) then
							v175 = v113();
							if (((4842 - (478 + 490)) == (2053 + 1821)) and v175) then
								return v175;
							end
							break;
						end
					end
				end
				v137 = v112();
				v136 = 1173 - (786 + 386);
			end
			if ((v136 == (12 - 8)) or ((3317 - (1055 + 324)) > (6275 - (1093 + 247)))) then
				if (v137 or ((3782 + 473) < (360 + 3063))) then
					return v137;
				end
				if (((5772 - 4318) <= (8453 - 5962)) and v28.TargetIsValid()) then
					local v176 = v116();
					if (v176 or ((11828 - 7671) <= (7043 - 4240))) then
						return v176;
					end
				end
				break;
			end
			if (((1727 + 3126) >= (11487 - 8505)) and ((6 - 4) == v136)) then
				if (((3118 + 1016) > (8584 - 5227)) and v137) then
					return v137;
				end
				v137 = v114();
				v136 = 691 - (364 + 324);
			end
			if ((v136 == (2 - 1)) or ((8199 - 4782) < (840 + 1694))) then
				if (v137 or ((11389 - 8667) <= (262 - 98))) then
					return v137;
				end
				v137 = v117();
				v136 = 5 - 3;
			end
		end
	end
	local function v122()
		if (v47 or v46 or ((3676 - (1249 + 19)) < (1904 + 205))) then
			local v147 = 0 - 0;
			local v148;
			while true do
				if (((1086 - (686 + 400)) == v147) or ((26 + 7) == (1684 - (73 + 156)))) then
					v148 = v113();
					if (v148 or ((3 + 440) >= (4826 - (721 + 90)))) then
						return v148;
					end
					break;
				end
			end
		end
		if (((39 + 3343) > (538 - 372)) and v37) then
			local v149 = 470 - (224 + 246);
			local v150;
			while true do
				if ((v149 == (0 - 0)) or ((515 - 235) == (555 + 2504))) then
					v150 = v120();
					if (((45 + 1836) > (950 + 343)) and v150) then
						return v150;
					end
					v149 = 1 - 0;
				end
				if (((7843 - 5486) == (2870 - (203 + 310))) and (v149 == (1994 - (1238 + 755)))) then
					if (((9 + 114) == (1657 - (709 + 825))) and v45 and v94.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v94.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v94.BlessingoftheBronzeBuff))) then
						if (v26(v94.BlessingoftheBronze) or ((1945 - 889) >= (4940 - 1548))) then
							return "blessing_of_the_bronze precombat";
						end
					end
					if (v28.TargetIsValid() or ((1945 - (196 + 668)) < (4244 - 3169))) then
						local v192 = 0 - 0;
						local v193;
						while true do
							if ((v192 == (833 - (171 + 662))) or ((1142 - (4 + 89)) >= (15533 - 11101))) then
								v193 = v111();
								if (v193 or ((1737 + 3031) <= (3715 - 2869))) then
									return v193;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1486 - (35 + 1451))) or ((4811 - (28 + 1425)) <= (3413 - (941 + 1052)))) then
				v41 = EpicSettings.Settings['UseRacials'];
				v42 = EpicSettings.Settings['UseHealingPotion'];
				v43 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v44 = EpicSettings.Settings['HealingPotionHP'] or (1514 - (822 + 692));
				v138 = 1 - 0;
			end
			if ((v138 == (4 + 4)) or ((4036 - (45 + 252)) <= (2974 + 31))) then
				v73 = EpicSettings.Settings['UseEmeraldBlossom'];
				v74 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
				v75 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['UseLivingFlame'];
				v138 = 442 - (114 + 319);
			end
			if ((v138 == (16 - 4)) or ((2125 - 466) >= (1361 + 773))) then
				v89 = EpicSettings.Settings['UseHover'];
				v90 = EpicSettings.Settings['HoverTime'] or (0 - 0);
				break;
			end
			if ((v138 == (5 - 2)) or ((5223 - (556 + 1407)) < (3561 - (741 + 465)))) then
				v53 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (465 - (170 + 295));
				v54 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v55 = EpicSettings.Settings['UseObsidianScales'];
				v56 = EpicSettings.Settings['ObsidianScalesHP'] or (0 + 0);
				v138 = 9 - 5;
			end
			if (((1 + 0) == v138) or ((430 + 239) == (2392 + 1831))) then
				v45 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (1230 - (957 + 273));
				v46 = EpicSettings.Settings['DispelDebuffs'] or (0 + 0);
				v47 = EpicSettings.Settings['DispelBuffs'] or (0 + 0);
				v48 = EpicSettings.Settings['UseHealthstone'];
				v138 = 7 - 5;
			end
			if ((v138 == (28 - 17)) or ((5167 - 3475) < (2911 - 2323))) then
				v85 = EpicSettings.Settings['EchoHP'] or (1780 - (389 + 1391));
				v86 = EpicSettings.Settings['UseOppressingRoar'];
				v87 = EpicSettings.Settings['UseRenewingBlaze'];
				v88 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v138 = 2 + 10;
			end
			if ((v138 == (22 - 12)) or ((5748 - (783 + 168)) < (12253 - 8602))) then
				v81 = EpicSettings.Settings['UseTemporalAnomaly'];
				v82 = EpicSettings.Settings['TemporalAnomalyHP'] or (0 + 0);
				v83 = EpicSettings.Settings['TemporalAnomalyGroup'] or (311 - (309 + 2));
				v84 = EpicSettings.Settings['UseEcho'];
				v138 = 33 - 22;
			end
			if ((v138 == (1218 - (1090 + 122))) or ((1355 + 2822) > (16288 - 11438))) then
				v65 = EpicSettings.Settings['SpiritbloomGroup'] or (0 + 0);
				v66 = EpicSettings.Settings['UseRewind'];
				v67 = EpicSettings.Settings['RewindHP'] or (1118 - (628 + 490));
				v68 = EpicSettings.Settings['RewindGroup'] or (0 + 0);
				v138 = 16 - 9;
			end
			if ((v138 == (22 - 17)) or ((1174 - (431 + 343)) > (2243 - 1132))) then
				v61 = EpicSettings.Settings['DreamBreathHP'] or (0 - 0);
				v62 = EpicSettings.Settings['DreamBreathGroup'] or (0 + 0);
				v63 = EpicSettings.Settings['UseSpiritbloom'];
				v64 = EpicSettings.Settings['SpiritbloomHP'] or (0 + 0);
				v138 = 1701 - (556 + 1139);
			end
			if (((3066 - (6 + 9)) > (185 + 820)) and (v138 == (5 + 4))) then
				v77 = EpicSettings.Settings['LivingFlameHP'] or (169 - (28 + 141));
				v78 = EpicSettings.Settings['UseReversion'];
				v79 = EpicSettings.Settings['ReversionHP'] or (0 + 0);
				v80 = EpicSettings.Settings['ReversionTankHP'] or (0 - 0);
				v138 = 8 + 2;
			end
			if (((5010 - (486 + 831)) <= (11402 - 7020)) and (v138 == (6 - 4))) then
				v49 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v50 = EpicSettings.Settings['HandleCharredTreant'] or (0 - 0);
				v51 = EpicSettings.Settings['HandleCharredBrambles'] or (1263 - (668 + 595));
				v52 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v138 = 1 + 2;
			end
			if ((v138 == (19 - 12)) or ((3572 - (23 + 267)) > (6044 - (1129 + 815)))) then
				v69 = EpicSettings.Settings['UseTimeDilation'];
				v70 = EpicSettings.Settings['TimeDilationHP'] or (387 - (371 + 16));
				v71 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v72 = EpicSettings.Settings['VerdantEmbraceHP'] or (1750 - (1326 + 424));
				v138 = 14 - 6;
			end
			if ((v138 == (14 - 10)) or ((3698 - (88 + 30)) < (3615 - (720 + 51)))) then
				v57 = EpicSettings.Settings['UseStasis'];
				v58 = EpicSettings.Settings['StasisHP'] or (0 - 0);
				v59 = EpicSettings.Settings['StasisGroup'] or (1776 - (421 + 1355));
				v60 = EpicSettings.Settings['UseDreamBreath'];
				v138 = 8 - 3;
			end
		end
	end
	local function v124()
		v91 = EpicSettings.Settings['DreamFlightUsage'] or "";
		v92 = EpicSettings.Settings['DreamFlightHP'] or (0 + 0);
		v93 = EpicSettings.Settings['DreamFlightGroup'] or (1083 - (286 + 797));
	end
	local function v125()
		local v139 = 0 - 0;
		while true do
			if (((146 - 57) < (4929 - (397 + 42))) and (v139 == (1 + 1))) then
				if (not v14:IsMoving() or ((5783 - (24 + 776)) < (2785 - 977))) then
					v33 = GetTime();
				end
				if (((4614 - (222 + 563)) > (8303 - 4534)) and (v14:AffectingCombat() or v46)) then
					local v177 = v46 and v94.Expunge:IsReady();
					local v178 = v28.FocusUnit(v177, v96, 22 + 8, 210 - (23 + 167));
					if (((3283 - (690 + 1108)) <= (1048 + 1856)) and v178) then
						return v178;
					end
				end
				if (((3522 + 747) == (5117 - (40 + 808))) and v50) then
					local v179 = 0 + 0;
					local v180;
					while true do
						if (((1479 - 1092) <= (2659 + 123)) and (v179 == (1 + 0))) then
							v180 = v28.HandleCharredTreant(v94.LivingFlame, v96.LivingFlameMouseover, 22 + 18, true);
							if (v180 or ((2470 - (47 + 524)) <= (596 + 321))) then
								return v180;
							end
							break;
						end
						if (((0 - 0) == v179) or ((6446 - 2134) <= (1997 - 1121))) then
							v180 = v28.HandleCharredTreant(v94.Echo, v96.EchoMouseover, 1766 - (1165 + 561));
							if (((67 + 2165) <= (8040 - 5444)) and v180) then
								return v180;
							end
							v179 = 1 + 0;
						end
					end
				end
				if (((2574 - (341 + 138)) < (996 + 2690)) and v51) then
					local v181 = 0 - 0;
					local v182;
					while true do
						if ((v181 == (327 - (89 + 237))) or ((5131 - 3536) >= (9418 - 4944))) then
							v182 = v28.HandleCharredBrambles(v94.LivingFlame, v96.LivingFlameMouseover, 921 - (581 + 300), true);
							if (v182 or ((5839 - (855 + 365)) < (6845 - 3963))) then
								return v182;
							end
							break;
						end
						if ((v181 == (0 + 0)) or ((1529 - (1030 + 205)) >= (4536 + 295))) then
							v182 = v28.HandleCharredBrambles(v94.Echo, v96.EchoMouseover, 38 + 2);
							if (((2315 - (156 + 130)) <= (7007 - 3923)) and v182) then
								return v182;
							end
							v181 = 1 - 0;
						end
					end
				end
				v139 = 5 - 2;
			end
			if ((v139 == (1 + 2)) or ((1188 + 849) == (2489 - (10 + 59)))) then
				if (((1261 + 3197) > (19226 - 15322)) and v89 and (v37 or v14:AffectingCombat())) then
					if (((1599 - (671 + 492)) >= (98 + 25)) and ((GetTime() - v33) > v90)) then
						if (((1715 - (369 + 846)) < (481 + 1335)) and v94.Hover:IsReady() and v14:BuffDown(v94.Hover)) then
							if (((3051 + 523) == (5519 - (1036 + 909))) and v26(v94.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				v106 = v14:BuffRemains(v94.HoverBuff) < (2 + 0);
				v110 = v28.FriendlyUnitsBelowHealthPercentageCount(142 - 57);
				v101 = v14:GetEnemiesInRange(228 - (11 + 192));
				v139 = 3 + 1;
			end
			if (((396 - (135 + 40)) < (944 - 554)) and (v139 == (4 + 1))) then
				if (v14:IsChanneling(v94.DreamBreath) or ((4874 - 2661) <= (2129 - 708))) then
					local v183 = 176 - (50 + 126);
					local v184;
					while true do
						if (((8515 - 5457) < (1076 + 3784)) and (v183 == (1413 - (1233 + 180)))) then
							v184 = GetTime() - v14:CastStart();
							if ((v184 >= v14:EmpowerCastTime(v35)) or ((2265 - (522 + 447)) >= (5867 - (107 + 1314)))) then
								v10.EpicSettingsS = v94.DreamBreath.ReturnID;
								return "Stopping DreamBreath";
							end
							break;
						end
					end
				end
				if (v14:IsChanneling(v94.Spiritbloom) or ((647 + 746) > (13678 - 9189))) then
					local v185 = GetTime() - v14:CastStart();
					if ((v185 >= v14:EmpowerCastTime(v36)) or ((1880 + 2544) < (53 - 26))) then
						v10.EpicSettingsS = v94.Spiritbloom.ReturnID;
						return "Stopping Spiritbloom";
					end
				end
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((7901 - 5904) > (5725 - (716 + 1194)))) then
					local v186 = 0 + 0;
					local v187;
					while true do
						if (((372 + 3093) > (2416 - (74 + 429))) and ((0 - 0) == v186)) then
							v187 = v28.DeadFriendlyUnitsCount();
							if (((364 + 369) < (4163 - 2344)) and not v14:AffectingCombat()) then
								if ((v187 > (1 + 0)) or ((13549 - 9154) == (11757 - 7002))) then
									if (v26(v94.MassReturn, nil, true) or ((4226 - (279 + 154)) < (3147 - (454 + 324)))) then
										return "mass_return";
									end
								elseif (v26(v94.Return, not v15:IsInRange(24 + 6), true) or ((4101 - (12 + 5)) == (143 + 122))) then
									return "return";
								end
							end
							break;
						end
					end
				end
				if (((11104 - 6746) == (1611 + 2747)) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((4231 - (277 + 816)) < (4243 - 3250))) then
						local v196 = 1183 - (1058 + 125);
						local v197;
						while true do
							if (((625 + 2705) > (3298 - (815 + 160))) and ((0 - 0) == v196)) then
								v197 = v121();
								if (v197 or ((8607 - 4981) == (952 + 3037))) then
									return v197;
								end
								break;
							end
						end
					else
						local v198 = 0 - 0;
						local v199;
						while true do
							if ((v198 == (1898 - (41 + 1857))) or ((2809 - (1222 + 671)) == (6903 - 4232))) then
								v199 = v122();
								if (((390 - 118) == (1454 - (229 + 953))) and v199) then
									return v199;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((6023 - (1111 + 663)) <= (6418 - (874 + 705))) and ((1 + 0) == v139)) then
				v38 = EpicSettings.Toggles['aoe'];
				v39 = EpicSettings.Toggles['cds'];
				v40 = EpicSettings.Toggles['dispel'];
				if (((1895 + 882) < (6651 - 3451)) and v14:IsMounted()) then
					return;
				end
				v139 = 1 + 1;
			end
			if (((774 - (642 + 37)) < (447 + 1510)) and (v139 == (1 + 3))) then
				v102 = v15:GetEnemiesInSplashRange(19 - 11);
				if (((1280 - (233 + 221)) < (3970 - 2253)) and v38) then
					v103 = #v102;
				else
					v103 = 1 + 0;
				end
				if (((2967 - (718 + 823)) >= (696 + 409)) and (v28.TargetIsValid() or v14:AffectingCombat())) then
					local v188 = 805 - (266 + 539);
					while true do
						if (((7797 - 5043) <= (4604 - (636 + 589))) and (v188 == (0 - 0))) then
							v104 = v10.BossFightRemains(nil, true);
							v105 = v104;
							v188 = 1 - 0;
						end
						if (((1 + 0) == v188) or ((1427 + 2500) == (2428 - (657 + 358)))) then
							if ((v105 == (29419 - 18308)) or ((2628 - 1474) <= (1975 - (1151 + 36)))) then
								v105 = v10.FightRemains(v101, false);
							end
							break;
						end
					end
				end
				if (v14:IsChanneling(v94.FireBreath) or ((1587 + 56) > (889 + 2490))) then
					local v189 = 0 - 0;
					local v190;
					while true do
						if ((v189 == (1832 - (1552 + 280))) or ((3637 - (64 + 770)) > (3089 + 1460))) then
							v190 = GetTime() - v14:CastStart();
							if ((v190 >= v14:EmpowerCastTime(v34)) or ((499 - 279) >= (537 + 2485))) then
								local v202 = 1243 - (157 + 1086);
								while true do
									if (((5647 - 2825) == (12359 - 9537)) and (v202 == (0 - 0))) then
										v10.EpicSettingsS = v94.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				v139 = 6 - 1;
			end
			if ((v139 == (819 - (599 + 220))) or ((2112 - 1051) == (3788 - (1813 + 118)))) then
				v123();
				v124();
				if (((2018 + 742) > (2581 - (841 + 376))) and v14:IsDeadOrGhost()) then
					return;
				end
				v37 = EpicSettings.Toggles['ooc'];
				v139 = 1 - 0;
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (2 - 1)) or ((5761 - (464 + 395)) <= (9226 - 5631))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
				v140 = 1 + 1;
			end
			if ((v140 == (839 - (467 + 370))) or ((7959 - 4107) == (216 + 77))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
				break;
			end
			if ((v140 == (0 - 0)) or ((244 + 1315) == (10673 - 6085))) then
				v21.Print("Preservation Evoker by Epic BoomK");
				EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
				v140 = 521 - (150 + 370);
			end
		end
	end
	v21.SetAPL(2750 - (74 + 1208), v125, v126);
end;
return v0["Epix_Evoker_Preservation.lua"]();

