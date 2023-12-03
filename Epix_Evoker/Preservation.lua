local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1773 + 1631) > (6341 - 1838))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((3669 - (92 + 71)) <= (647 + 662))) then
			v6 = v0[v4];
			if (((4968 - 2013) == (3720 - (574 + 191))) and not v6) then
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
	local v33 = 0 - 0;
	local v34 = 1 + 0;
	local v35 = 850 - (254 + 595);
	local v36 = 127 - (55 + 71);
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
	local v99 = (v98[16 - 3] and v20(v98[1803 - (573 + 1217)])) or v20(0 - 0);
	local v100 = (v98[2 + 12] and v20(v98[21 - 7])) or v20(939 - (714 + 225));
	local v101;
	local v102;
	local v103;
	local v104 = 32470 - 21359;
	local v105 = 15490 - 4379;
	local v106;
	local v107 = 0 + 0;
	local v108 = 0 - 0;
	local v109 = 806 - (118 + 688);
	local v110 = 48 - (25 + 23);
	v10:RegisterForEvent(function()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (1887 - (927 + 959))) or ((9785 - 6882) == (2227 - (16 + 716)))) then
				v100 = (v98[26 - 12] and v20(v98[111 - (11 + 86)])) or v20(0 - 0);
				break;
			end
			if (((4831 - (175 + 110)) >= (5743 - 3468)) and (v127 == (0 - 0))) then
				v98 = v14:GetEquipment();
				v99 = (v98[1809 - (503 + 1293)] and v20(v98[36 - 23])) or v20(0 + 0);
				v127 = 1062 - (810 + 251);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v104 = 7711 + 3400;
		v105 = 3410 + 7701;
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (((739 + 80) >= (555 - (43 + 490))) and v94.LivingFlame:IsCastable()) then
			if (((3895 - (711 + 22)) == (12231 - 9069)) and v26(v94.LivingFlame, not v15:IsInRange(884 - (240 + 619)), v106)) then
				return "living_flame precombat";
			end
		end
		if (v94.AzureStrike:IsCastable() or ((572 + 1797) > (7044 - 2615))) then
			if (((272 + 3823) >= (4927 - (1344 + 400))) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
				return "azure_strike precombat";
			end
		end
	end
	local function v112()
		local v128 = 405 - (255 + 150);
		while true do
			if ((v128 == (1 + 0)) or ((1987 + 1724) < (4306 - 3298))) then
				if ((v42 and (v14:HealthPercentage() <= v44)) or ((3387 - 2338) <= (2645 - (404 + 1335)))) then
					if (((4919 - (183 + 223)) > (3316 - 590)) and (v43 == "Refreshing Healing Potion")) then
						if (v95.RefreshingHealingPotion:IsReady() or ((982 + 499) >= (957 + 1701))) then
							if (v26(v96.RefreshingHealingPotion, nil, nil, true) or ((3557 - (10 + 327)) == (950 + 414))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				if ((v94.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v88) and v87) or ((1392 - (118 + 220)) > (1131 + 2261))) then
					if (v22(v94.RenewingBlaze, nil, nil) or ((1125 - (108 + 341)) >= (738 + 904))) then
						return "RenewingBlaze defensive";
					end
				end
				break;
			end
			if (((17486 - 13350) > (3890 - (711 + 782))) and (v128 == (0 - 0))) then
				if ((v94.ObsidianScales:IsCastable() and v55 and v14:BuffDown(v94.ObsidianScales) and (v14:HealthPercentage() < v56)) or ((4803 - (270 + 199)) == (1377 + 2868))) then
					if (v26(v94.ObsidianScales) or ((6095 - (580 + 1239)) <= (9010 - 5979))) then
						return "obsidian_scales defensives";
					end
				end
				if ((v95.Healthstone:IsReady() and v48 and (v14:HealthPercentage() <= v49)) or ((4573 + 209) <= (44 + 1155))) then
					if (v26(v96.Healthstone, nil, nil, true) or ((2119 + 2745) < (4965 - 3063))) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v113()
		local v129 = 1167 - (645 + 522);
		while true do
			if (((6629 - (1010 + 780)) >= (3699 + 1)) and (v129 == (0 - 0))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(87 - 57) or not v28.DispellableFriendlyUnit() or ((2911 - (1045 + 791)) > (4854 - 2936))) then
					return;
				end
				if (((604 - 208) <= (4309 - (351 + 154))) and v94.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
					if (v26(v96.ExpungeFocus) or ((5743 - (1281 + 293)) == (2453 - (28 + 238)))) then
						return "expunge dispel";
					end
				end
				v129 = 2 - 1;
			end
			if (((2965 - (1381 + 178)) == (1319 + 87)) and (v129 == (1 + 0))) then
				if (((654 + 877) < (14723 - 10452)) and v94.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
					if (((329 + 306) == (1105 - (381 + 89))) and v26(v96.CauterizingFlameFocus)) then
						return "cauterizing_flame dispel";
					end
				end
				if (((2992 + 381) <= (2405 + 1151)) and v94.OppressingRoar:IsReady() and v86 and v28.UnitHasEnrageBuff(v15)) then
					if (v26(v94.OppressingRoar) or ((5637 - 2346) < (4436 - (1074 + 82)))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
		end
	end
	local function v114()
		if (((9611 - 5225) >= (2657 - (214 + 1570))) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v161 = v28.Interrupt(v94.Quell, 1465 - (990 + 465), true);
			if (((380 + 541) <= (480 + 622)) and v161) then
				return v161;
			end
			v161 = v28.InterruptWithStun(v94.TailSwipe, 8 + 0);
			if (((18520 - 13814) >= (2689 - (1668 + 58))) and v161) then
				return v161;
			end
			v161 = v28.Interrupt(v94.Quell, 636 - (512 + 114), true, v17, v96.QuellMouseover);
			if (v161 or ((2502 - 1542) <= (1810 - 934))) then
				return v161;
			end
		end
	end
	local function v115()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (0 + 0)) or ((387 + 1679) == (811 + 121))) then
				ShouldReturn = v28.HandleTopTrinket(v97, v39, 134 - 94, nil);
				if (((6819 - (109 + 1885)) < (6312 - (1269 + 200))) and ShouldReturn) then
					return ShouldReturn;
				end
				v130 = 1 - 0;
			end
			if ((v130 == (816 - (98 + 717))) or ((4703 - (802 + 24)) >= (7823 - 3286))) then
				ShouldReturn = v28.HandleBottomTrinket(v97, v39, 50 - 10, nil);
				if (ShouldReturn or ((638 + 3677) < (1327 + 399))) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v116()
		if ((v94.LivingFlame:IsCastable() and v14:BuffUp(v94.LeapingFlamesBuff)) or ((605 + 3074) < (135 + 490))) then
			if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((12866 - 8241) < (2107 - 1475))) then
				return "living_flame_leaping_flames damage";
			end
		end
		if (v94.FireBreath:IsReady() or ((30 + 53) > (725 + 1055))) then
			if (((451 + 95) <= (784 + 293)) and (v103 <= (1 + 1))) then
				v107 = 1434 - (797 + 636);
			elseif ((v103 <= (19 - 15)) or ((2615 - (1427 + 192)) > (1491 + 2810))) then
				v107 = 4 - 2;
			elseif (((3659 + 411) > (312 + 375)) and (v103 <= (332 - (192 + 134)))) then
				v107 = 1279 - (316 + 960);
			else
				v107 = 3 + 1;
			end
			v34 = v107;
			if (v26(v96.FireBreathMacro, not v15:IsInRange(24 + 6), true, nil, true) or ((607 + 49) >= (12730 - 9400))) then
				return "fire_breath damage " .. v107;
			end
		end
		if ((v94.Disintegrate:IsReady() and v14:BuffUp(v94.EssenceBurstBuff)) or ((3043 - (83 + 468)) <= (2141 - (1202 + 604)))) then
			if (((20175 - 15853) >= (4263 - 1701)) and v26(v94.Disintegrate, not v15:IsSpellInRange(v94.Disintegrate), v106)) then
				return "disintegrate damage";
			end
		end
		if (v94.LivingFlame:IsCastable() or ((10069 - 6432) >= (4095 - (45 + 280)))) then
			if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((2297 + 82) > (4000 + 578))) then
				return "living_flame damage";
			end
		end
		if (v94.AzureStrike:IsCastable() or ((177 + 306) > (412 + 331))) then
			if (((432 + 2022) > (1069 - 491)) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
				return "azure_strike damage";
			end
		end
	end
	local function v117()
		if (((2841 - (340 + 1571)) < (1759 + 2699)) and (not v16 or not v16:Exists() or not v16:IsInRange(1802 - (1733 + 39)))) then
			return;
		end
		local v131 = v115();
		if (((1819 - 1157) <= (2006 - (125 + 909))) and v131) then
			return v131;
		end
		if (((6318 - (1096 + 852)) == (1961 + 2409)) and v94.Stasis:IsReady() and v57 and v28.AreUnitsBelowHealthPercentage(v58, v59)) then
			if (v26(v94.Stasis) or ((6800 - 2038) <= (836 + 25))) then
				return "stasis cooldown";
			end
		end
		if ((v94.StasisReactivate:IsReady() and v57 and (v28.AreUnitsBelowHealthPercentage(v58, v59) or (v14:BuffUp(v94.StasisBuff) and (v14:BuffRemains(v94.StasisBuff) < (515 - (409 + 103)))))) or ((1648 - (46 + 190)) == (4359 - (51 + 44)))) then
			if (v26(v94.StasisReactivate) or ((894 + 2274) < (3470 - (1114 + 203)))) then
				return "stasis_reactivate cooldown";
			end
		end
		if (v94.TipTheScales:IsCastable() or ((5702 - (228 + 498)) < (289 + 1043))) then
			if (((2557 + 2071) == (5291 - (174 + 489))) and v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) then
				v35 = 2 - 1;
				if (v26(v96.TipTheScalesDreamBreath) or ((1959 - (830 + 1075)) == (919 - (303 + 221)))) then
					return "dream_breath cooldown";
				end
			elseif (((1351 - (231 + 1038)) == (69 + 13)) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
				local v184 = 1162 - (171 + 991);
				while true do
					if ((v184 == (0 - 0)) or ((1560 - 979) < (703 - 421))) then
						v36 = 3 + 0;
						if (v26(v96.TipTheScalesSpiritbloom) or ((16156 - 11547) < (7197 - 4702))) then
							return "spirit_bloom cooldown";
						end
						break;
					end
				end
			end
		end
		if (((1856 - 704) == (3561 - 2409)) and v94.DreamFlight:IsCastable() and (v91 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v92, v93)) then
			if (((3144 - (111 + 1137)) <= (3580 - (91 + 67))) and v26(v96.DreamFlightCursor)) then
				return "Dream_Flight cooldown";
			end
		end
		if ((v94.DreamFlight:IsCastable() and (v91 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v92, v93)) or ((2946 - 1956) > (405 + 1215))) then
			if (v26(v94.DreamFlight) or ((1400 - (423 + 100)) > (33 + 4662))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((7450 - 4759) >= (965 + 886)) and v94.Rewind:IsCastable() and v66 and v28.AreUnitsBelowHealthPercentage(v67, v68)) then
			if (v26(v94.Rewind) or ((3756 - (326 + 445)) >= (21191 - 16335))) then
				return "rewind cooldown";
			end
		end
		if (((9525 - 5249) >= (2789 - 1594)) and v94.TimeDilation:IsCastable() and v69 and (v16:HealthPercentage() <= v70)) then
			if (((3943 - (530 + 181)) <= (5571 - (614 + 267))) and v26(v96.TimeDilationFocus)) then
				return "time_dilation cooldown";
			end
		end
		if (v94.FireBreath:IsReady() or ((928 - (19 + 13)) >= (5119 - 1973))) then
			local v162 = 0 - 0;
			while true do
				if (((8744 - 5683) >= (769 + 2189)) and (v162 == (0 - 0))) then
					if (((6608 - 3421) >= (2456 - (1293 + 519))) and (v103 <= (3 - 1))) then
						v107 = 2 - 1;
					elseif (((1231 - 587) <= (3035 - 2331)) and (v103 <= (9 - 5))) then
						v107 = 2 + 0;
					elseif (((196 + 762) > (2200 - 1253)) and (v103 <= (2 + 4))) then
						v107 = 1 + 2;
					else
						v107 = 3 + 1;
					end
					v34 = v107;
					v162 = 1097 - (709 + 387);
				end
				if (((6350 - (673 + 1185)) >= (7696 - 5042)) and (v162 == (3 - 2))) then
					if (((5662 - 2220) >= (1076 + 427)) and v26(v96.FireBreathMacro, not v15:IsInRange(23 + 7), true, nil, true)) then
						return "fire_breath cds " .. v107;
					end
					break;
				end
			end
		end
	end
	local function v118()
		if ((v94.EmeraldBlossom:IsCastable() and v73 and v28.AreUnitsBelowHealthPercentage(v74, v75)) or ((4280 - 1110) <= (360 + 1104))) then
			if (v26(v96.EmeraldBlossomFocus) or ((9564 - 4767) == (8613 - 4225))) then
				return "emerald_blossom aoe_healing";
			end
		end
		if (((2431 - (446 + 1434)) <= (1964 - (1040 + 243))) and (v71 == "Player Only")) then
			if (((9780 - 6503) > (2254 - (559 + 1288))) and v94.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v72)) then
				if (((6626 - (609 + 1322)) >= (1869 - (13 + 441))) and v22(v96.VerdantEmbracePlayer, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v71 == "Everyone") or ((12002 - 8790) <= (2472 - 1528))) then
			if ((v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72)) or ((15419 - 12323) <= (67 + 1731))) then
				if (((12845 - 9308) == (1257 + 2280)) and v22(v96.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((1682 + 2155) >= (4659 - 3089)) and (v71 == "Not Tank")) then
			if ((v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72) and (v28.UnitGroupRole(v16) ~= "TANK")) or ((1615 + 1335) == (7010 - 3198))) then
				if (((3123 + 1600) >= (1290 + 1028)) and v22(v96.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) or ((1457 + 570) > (2395 + 457))) then
			if ((v110 <= (2 + 0)) or ((1569 - (153 + 280)) > (12465 - 8148))) then
				v108 = 1 + 0;
			else
				v108 = 1 + 1;
			end
			v35 = v108;
			if (((2485 + 2263) == (4309 + 439)) and v26(v96.DreamBreathMacro, nil, true)) then
				return "dream_breath aoe_healing";
			end
		end
		if (((2708 + 1028) <= (7217 - 2477)) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
			local v163 = 0 + 0;
			while true do
				if (((668 - (89 + 578)) == v163) or ((2422 + 968) <= (6361 - 3301))) then
					if (v26(v96.SpiritbloomFocus, nil, true) or ((2048 - (572 + 477)) > (364 + 2329))) then
						return "spirit_bloom aoe_healing";
					end
					break;
				end
				if (((278 + 185) < (72 + 529)) and (v163 == (86 - (84 + 2)))) then
					if ((v110 > (2 - 0)) or ((1573 + 610) < (1529 - (497 + 345)))) then
						v109 = 1 + 2;
					else
						v109 = 1 + 0;
					end
					v36 = 1336 - (605 + 728);
					v163 = 1 + 0;
				end
			end
		end
		if (((10113 - 5564) == (209 + 4340)) and v94.LivingFlame:IsCastable() and v76 and v14:BuffUp(v94.LeapingFlamesBuff) and (v16:HealthPercentage() <= v77)) then
			if (((17273 - 12601) == (4212 + 460)) and v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106)) then
				return "living_flame_leaping_flames aoe_healing";
			end
		end
	end
	local function v119()
		if ((v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion) < (2 - 1)) and (v16:HealthPercentage() <= v79)) or ((2770 + 898) < (884 - (457 + 32)))) then
			if (v26(v96.ReversionFocus) or ((1768 + 2398) == (1857 - (832 + 570)))) then
				return "reversion_tank st_healing";
			end
		end
		if ((v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion, true, false) < (1 + 0)) and (v16:HealthPercentage() <= v80)) or ((1161 + 3288) == (9423 - 6760))) then
			if (v26(v96.ReversionFocus) or ((2061 + 2216) < (3785 - (588 + 208)))) then
				return "reversion_tank st_healing";
			end
		end
		if ((v94.TemporalAnomaly:IsReady() and v81 and v28.AreUnitsBelowHealthPercentage(v82, v83)) or ((2344 - 1474) >= (5949 - (884 + 916)))) then
			if (((4630 - 2418) < (1846 + 1337)) and v26(v94.TemporalAnomaly, not v16:IsInRange(683 - (232 + 421)), v106)) then
				return "temporal_anomaly st_healing";
			end
		end
		if (((6535 - (1569 + 320)) > (735 + 2257)) and v94.Echo:IsReady() and v84 and not v16:BuffUp(v94.Echo) and (v16:HealthPercentage() <= v85)) then
			if (((273 + 1161) < (10466 - 7360)) and v26(v96.EchoFocus)) then
				return "echo st_healing";
			end
		end
		if (((1391 - (316 + 289)) < (7913 - 4890)) and v94.LivingFlame:IsReady() and v76 and (v16:HealthPercentage() <= v77)) then
			if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or ((113 + 2329) < (1527 - (666 + 787)))) then
				return "living_flame st_healing";
			end
		end
	end
	local function v120()
		local v132 = 425 - (360 + 65);
		local v133;
		while true do
			if (((4239 + 296) == (4789 - (79 + 175))) and (v132 == (0 - 0))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(24 + 6) or ((9223 - 6214) <= (4053 - 1948))) then
					return;
				end
				v133 = v118();
				v132 = 900 - (503 + 396);
			end
			if (((2011 - (92 + 89)) < (7117 - 3448)) and (v132 == (1 + 0))) then
				if (v133 or ((847 + 583) >= (14144 - 10532))) then
					return v133;
				end
				v133 = v119();
				v132 = 1 + 1;
			end
			if (((6117 - 3434) >= (2147 + 313)) and (v132 == (1 + 1))) then
				if (v133 or ((5494 - 3690) >= (409 + 2866))) then
					return v133;
				end
				break;
			end
		end
	end
	local function v121()
		if (v47 or v46 or ((2160 - 743) > (4873 - (485 + 759)))) then
			local v164 = v113();
			if (((11095 - 6300) > (1591 - (442 + 747))) and v164) then
				return v164;
			end
		end
		local v134 = v112();
		if (((5948 - (832 + 303)) > (4511 - (88 + 858))) and v134) then
			return v134;
		end
		v134 = v117();
		if (((1193 + 2719) == (3238 + 674)) and v134) then
			return v134;
		end
		v134 = v114();
		if (((117 + 2704) <= (5613 - (766 + 23))) and v134) then
			return v134;
		end
		v134 = v120();
		if (((8580 - 6842) <= (3001 - 806)) and v134) then
			return v134;
		end
		if (((107 - 66) <= (10243 - 7225)) and v28.TargetIsValid()) then
			v134 = v116();
			if (((3218 - (1036 + 37)) <= (2910 + 1194)) and v134) then
				return v134;
			end
		end
	end
	local function v122()
		local v135 = 0 - 0;
		while true do
			if (((2116 + 573) < (6325 - (641 + 839))) and (v135 == (913 - (910 + 3)))) then
				if (v47 or v46 or ((5919 - 3597) > (4306 - (1466 + 218)))) then
					local v180 = 0 + 0;
					local v181;
					while true do
						if ((v180 == (1148 - (556 + 592))) or ((1613 + 2921) == (2890 - (329 + 479)))) then
							v181 = v113();
							if (v181 or ((2425 - (174 + 680)) > (6415 - 4548))) then
								return v181;
							end
							break;
						end
					end
				end
				if (v37 or ((5500 - 2846) >= (2140 + 856))) then
					local v182 = 739 - (396 + 343);
					local v183;
					while true do
						if (((352 + 3626) > (3581 - (29 + 1448))) and (v182 == (1390 - (135 + 1254)))) then
							if (((11282 - 8287) > (7195 - 5654)) and UseBlessingoftheBronze and v94.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v94.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v94.BlessingoftheBronzeBuff))) then
								if (((2166 + 1083) > (2480 - (389 + 1138))) and v26(v94.BlessingoftheBronze)) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (v28.TargetIsValid() or ((3847 - (102 + 472)) > (4316 + 257))) then
								local v189 = 0 + 0;
								local v190;
								while true do
									if ((v189 == (0 + 0)) or ((4696 - (320 + 1225)) < (2285 - 1001))) then
										v190 = v111();
										if (v190 or ((1132 + 718) == (2993 - (157 + 1307)))) then
											return v190;
										end
										break;
									end
								end
							end
							break;
						end
						if (((2680 - (821 + 1038)) < (5296 - 3173)) and (v182 == (0 + 0))) then
							v183 = v120();
							if (((1601 - 699) < (866 + 1459)) and v183) then
								return v183;
							end
							v182 = 2 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		v41 = EpicSettings.Settings['UseRacials'];
		v42 = EpicSettings.Settings['UseHealingPotion'];
		v43 = EpicSettings.Settings['HealingPotionName'] or (1026 - (834 + 192));
		v44 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v45 = EpicSettings.Settings['UseBlessingOfTheBronze'];
		v46 = EpicSettings.Settings['DispelDebuffs'] or (0 + 0);
		v47 = EpicSettings.Settings['DispelBuffs'] or (0 + 0);
		v48 = EpicSettings.Settings['UseHealthstone'];
		v49 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v50 = EpicSettings.Settings['HandleAfflicted'] or (304 - (300 + 4));
		v51 = EpicSettings.Settings['HandleIncorporeal'] or (0 + 0);
		v52 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v53 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (362 - (112 + 250));
		v54 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v55 = EpicSettings.Settings['UseObsidianScales'];
		v56 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
		v57 = EpicSettings.Settings['UseStasis'];
		v58 = EpicSettings.Settings['StasisHP'] or (0 + 0);
		v59 = EpicSettings.Settings['StasisGroup'] or (0 + 0);
		v60 = EpicSettings.Settings['UseDreamBreath'];
		v61 = EpicSettings.Settings['DreamBreathHP'] or (0 + 0);
		v62 = EpicSettings.Settings['DreamBreathGroup'] or (0 + 0);
		v63 = EpicSettings.Settings['UseSpiritbloom'];
		v64 = EpicSettings.Settings['SpiritbloomHP'] or (0 + 0);
		v65 = EpicSettings.Settings['SpiritbloomGroup'] or (1414 - (1001 + 413));
		v66 = EpicSettings.Settings['UseRewind'];
		v67 = EpicSettings.Settings['RewindHP'] or (0 - 0);
		v68 = EpicSettings.Settings['RewindGroup'] or (882 - (244 + 638));
		v69 = EpicSettings.Settings['UseTimeDilation'];
		v70 = EpicSettings.Settings['TimeDilationHP'] or (693 - (627 + 66));
		v71 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v72 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 - 0);
		v73 = EpicSettings.Settings['UseEmeraldBlossom'];
		v74 = EpicSettings.Settings['EmeraldBlossomHP'] or (602 - (512 + 90));
		v75 = EpicSettings.Settings['EmeraldBlossomGroup'] or (1906 - (1665 + 241));
		v76 = EpicSettings.Settings['UseLivingFlame'];
		v77 = EpicSettings.Settings['LivingFlameHP'] or (717 - (373 + 344));
		v78 = EpicSettings.Settings['UseReversion'];
		v79 = EpicSettings.Settings['ReversionHP'] or (0 + 0);
		v80 = EpicSettings.Settings['ReversionTankHP'] or (0 + 0);
		v81 = EpicSettings.Settings['UseTemporalAnomaly'];
		v82 = EpicSettings.Settings['TemporalAnomalyHP'] or (0 - 0);
		v83 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 - 0);
		v84 = EpicSettings.Settings['UseEcho'];
		v85 = EpicSettings.Settings['EchoHP'] or (1099 - (35 + 1064));
		v86 = EpicSettings.Settings['UseOppressingRoar'];
		v87 = EpicSettings.Settings['UseRenewingBlaze'];
		v88 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
		v89 = EpicSettings.Settings['UseHover'];
		v90 = EpicSettings.Settings['HoverTime'] or (0 - 0);
	end
	local function v124()
		local v154 = 0 + 0;
		while true do
			if (((2094 - (298 + 938)) <= (4221 - (233 + 1026))) and (v154 == (1667 - (636 + 1030)))) then
				v93 = EpicSettings.Settings['DreamFlightGroup'] or (0 + 0);
				break;
			end
			if ((v154 == (0 + 0)) or ((1173 + 2773) < (88 + 1200))) then
				v91 = EpicSettings.Settings['DreamFlightUsage'] or "";
				v92 = EpicSettings.Settings['DreamFlightHP'] or (221 - (55 + 166));
				v154 = 1 + 0;
			end
		end
	end
	local function v125()
		v123();
		v124();
		if (v14:IsDeadOrGhost() or ((327 + 2915) == (2165 - 1598))) then
			return;
		end
		v37 = EpicSettings.Toggles['ooc'];
		v38 = EpicSettings.Toggles['aoe'];
		v39 = EpicSettings.Toggles['cds'];
		v40 = EpicSettings.Toggles['dispel'];
		if (v14:IsMounted() or ((1144 - (36 + 261)) >= (2208 - 945))) then
			return;
		end
		if (not v14:IsMoving() or ((3621 - (34 + 1334)) == (712 + 1139))) then
			v33 = GetTime();
		end
		if (v14:AffectingCombat() or v46 or ((1622 + 465) > (3655 - (1035 + 248)))) then
			local v165 = v46 and v94.Expunge:IsReady();
			local v166 = v28.FocusUnit(v165, v96, 51 - (20 + 1), 11 + 9);
			if (v166 or ((4764 - (134 + 185)) < (5282 - (549 + 584)))) then
				return v166;
			end
		end
		if (v50 or ((2503 - (314 + 371)) == (291 - 206))) then
			local v167 = 968 - (478 + 490);
			while true do
				if (((334 + 296) < (3299 - (786 + 386))) and (v167 == (0 - 0))) then
					ShouldReturn = v28.HandleAfflicted(v94.Expunge, v96.ExpungeMouseover, 1419 - (1055 + 324));
					if (ShouldReturn or ((3278 - (1093 + 247)) == (2235 + 279))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if (((448 + 3807) >= (218 - 163)) and v51) then
			local v168 = 0 - 0;
			while true do
				if (((8533 - 5534) > (2904 - 1748)) and (v168 == (0 + 0))) then
					ShouldReturn = v28.HandleIncorporeal(v94.Sleepwalk, v96.SleepwalkMouseover, 115 - 85, true);
					if (((8099 - 5749) > (871 + 284)) and ShouldReturn) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if (((10303 - 6274) <= (5541 - (364 + 324))) and v89 and (v37 or v14:AffectingCombat())) then
			if (((GetTime() - v33) > v90) or ((1414 - 898) > (8240 - 4806))) then
				if (((1341 + 2705) >= (12690 - 9657)) and v94.Hover:IsReady() and v14:BuffDown(v94.Hover)) then
					if (v26(v94.Hover) or ((4354 - 1635) <= (4394 - 2947))) then
						return "hover main 2";
					end
				end
			end
		end
		v106 = v14:BuffRemains(v94.HoverBuff) < (1270 - (1249 + 19));
		v110 = v28.FriendlyUnitsBelowHealthPercentageCount(77 + 8);
		v101 = v14:GetEnemiesInRange(97 - 72);
		v102 = v15:GetEnemiesInSplashRange(1094 - (686 + 400));
		if (v38 or ((3244 + 890) < (4155 - (73 + 156)))) then
			v103 = #v102;
		else
			v103 = 1 + 0;
		end
		if (v28.TargetIsValid() or v14:AffectingCombat() or ((975 - (721 + 90)) >= (32 + 2753))) then
			local v169 = 0 - 0;
			while true do
				if ((v169 == (471 - (224 + 246))) or ((850 - 325) == (3882 - 1773))) then
					if (((6 + 27) == (1 + 32)) and (v105 == (8161 + 2950))) then
						v105 = v10.FightRemains(v101, false);
					end
					break;
				end
				if (((6071 - 3017) <= (13361 - 9346)) and (v169 == (513 - (203 + 310)))) then
					v104 = v10.BossFightRemains(nil, true);
					v105 = v104;
					v169 = 1994 - (1238 + 755);
				end
			end
		end
		if (((131 + 1740) < (4916 - (709 + 825))) and v14:IsChanneling(v94.FireBreath)) then
			local v170 = 0 - 0;
			local v171;
			while true do
				if (((1882 - 589) <= (3030 - (196 + 668))) and (v170 == (0 - 0))) then
					v171 = GetTime() - v14:CastStart();
					if ((v171 >= v14:EmpowerCastTime(v34)) or ((5341 - 2762) < (956 - (171 + 662)))) then
						v10.EpicSettingsS = v94.FireBreath.ReturnID;
						return "Stopping Fire Breath";
					end
					break;
				end
			end
		end
		if (v14:IsChanneling(v94.DreamBreath) or ((939 - (4 + 89)) >= (8299 - 5931))) then
			local v172 = GetTime() - v14:CastStart();
			if ((v172 >= v14:EmpowerCastTime(v35)) or ((1461 + 2551) <= (14749 - 11391))) then
				v10.EpicSettingsS = v94.DreamBreath.ReturnID;
				return "Stopping DreamBreath";
			end
		end
		if (((586 + 908) <= (4491 - (35 + 1451))) and v14:IsChanneling(v94.Spiritbloom)) then
			local v173 = 1453 - (28 + 1425);
			local v174;
			while true do
				if ((v173 == (1993 - (941 + 1052))) or ((2984 + 127) == (3648 - (822 + 692)))) then
					v174 = GetTime() - v14:CastStart();
					if (((3361 - 1006) == (1110 + 1245)) and (v174 >= v14:EmpowerCastTime(v36))) then
						v10.EpicSettingsS = v94.Spiritbloom.ReturnID;
						return "Stopping Spiritbloom";
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((885 - (45 + 252)) <= (428 + 4))) then
			local v175 = v28.DeadFriendlyUnitsCount();
			if (((1651 + 3146) >= (9479 - 5584)) and not v14:AffectingCombat()) then
				if (((4010 - (114 + 319)) == (5135 - 1558)) and (v175 > (1 - 0))) then
					if (((2419 + 1375) > (5501 - 1808)) and v26(v94.MassReturn, nil, true)) then
						return "mass_return";
					end
				elseif (v26(v94.Return, not v15:IsInRange(62 - 32), true) or ((3238 - (556 + 1407)) == (5306 - (741 + 465)))) then
					return "return";
				end
			end
		end
		if (not v14:IsChanneling() or ((2056 - (170 + 295)) >= (1887 + 1693))) then
			if (((903 + 80) <= (4451 - 2643)) and v14:AffectingCombat()) then
				local v178 = v121();
				if (v178 or ((1783 + 367) <= (768 + 429))) then
					return v178;
				end
			else
				local v179 = v122();
				if (((2135 + 1634) >= (2403 - (957 + 273))) and v179) then
					return v179;
				end
			end
		end
	end
	local function v126()
		v21.Print("Preservation Evoker by Epic BoomK");
		EpicSettings.SetupVersion("Preservation Evoker X v 10.2.00 By BoomK");
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
	end
	v21.SetAPL(393 + 1075, v125, v126);
end;
return v0["Epix_Evoker_Preservation.lua"]();

