local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3264 + 1249) < (4413 - (810 + 251)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Evoker_Preservation.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.CastPooling;
	local v23 = v20.CastAnnotated;
	local v24 = v20.CastSuggested;
	local v25 = v20.Press;
	local v26 = v20.Macro;
	local v27 = v20.Commons.Everyone;
	local v28 = v20.Commons.Everyone.num;
	local v29 = v20.Commons.Everyone.bool;
	local v30 = string.format;
	local v31 = GetUnitEmpowerStageDuration;
	local v32 = 0 + 0;
	local v33 = 1 + 0;
	local v34 = 1 + 0;
	local v35 = 534 - (43 + 490);
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
	local v93 = v18.Evoker.Preservation;
	local v94 = v19.Evoker.Preservation;
	local v95 = v26.Evoker.Preservation;
	local v96 = {};
	local v97 = v13:GetEquipment();
	local v98 = (v97[746 - (711 + 22)] and v19(v97[50 - 37])) or v19(859 - (240 + 619));
	local v99 = (v97[4 + 10] and v19(v97[21 - 7])) or v19(0 + 0);
	local v100;
	local v101;
	local v102;
	local v103 = 12855 - (1344 + 400);
	local v104 = 11516 - (255 + 150);
	local v105;
	local v106 = 0 + 0;
	local v107 = 0 + 0;
	local v108 = 0 - 0;
	local v109 = 0 - 0;
	v9:RegisterForEvent(function()
		v97 = v13:GetEquipment();
		v98 = (v97[1752 - (404 + 1335)] and v19(v97[419 - (183 + 223)])) or v19(0 - 0);
		v99 = (v97[10 + 4] and v19(v97[6 + 8])) or v19(337 - (10 + 327));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (338 - (118 + 220))) or ((689 + 1376) >= (3645 - (108 + 341)))) then
				v103 = 4991 + 6120;
				v104 = 46975 - 35864;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		local v127 = 1493 - (711 + 782);
		while true do
			if ((v127 == (0 - 0)) or ((4845 - (270 + 199)) <= (481 + 1000))) then
				if (v93.LivingFlame:IsCastable() or ((5211 - (580 + 1239)) >= (14093 - 9352))) then
					if (((3180 + 145) >= (78 + 2076)) and v25(v93.LivingFlame, not v14:IsInRange(11 + 14), v105)) then
						return "living_flame precombat";
					end
				end
				if (v93.AzureStrike:IsCastable() or ((3381 - 2086) >= (2009 + 1224))) then
					if (((5544 - (645 + 522)) > (3432 - (1010 + 780))) and v25(v93.AzureStrike, not v14:IsSpellInRange(v93.AzureStrike))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
		end
	end
	local function v111()
		if (((4721 + 2) > (6459 - 5103)) and v93.ObsidianScales:IsCastable() and v54 and v13:BuffDown(v93.ObsidianScales) and (v13:HealthPercentage() < v55)) then
			if (v25(v93.ObsidianScales) or ((12120 - 7984) <= (5269 - (1045 + 791)))) then
				return "obsidian_scales defensives";
			end
		end
		if (((10745 - 6500) <= (7070 - 2439)) and v94.Healthstone:IsReady() and v47 and (v13:HealthPercentage() <= v48)) then
			if (((4781 - (351 + 154)) >= (5488 - (1281 + 293))) and v25(v95.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if (((464 - (28 + 238)) <= (9753 - 5388)) and v41 and (v13:HealthPercentage() <= v43)) then
			if (((6341 - (1381 + 178)) > (4386 + 290)) and (v42 == "Refreshing Healing Potion")) then
				if (((3923 + 941) > (938 + 1259)) and v94.RefreshingHealingPotion:IsReady()) then
					if (v25(v95.RefreshingHealingPotion, nil, nil, true) or ((12755 - 9055) == (1299 + 1208))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
		if (((4944 - (381 + 89)) >= (243 + 31)) and v93.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v87) and v86) then
			if (v21(v93.RenewingBlaze, nil, nil) or ((1281 + 613) <= (2408 - 1002))) then
				return "RenewingBlaze defensive";
			end
		end
	end
	local function v112()
		local v128 = 1156 - (1074 + 82);
		while true do
			if (((3444 - 1872) >= (3315 - (214 + 1570))) and (v128 == (1456 - (990 + 465)))) then
				if ((v93.CauterizingFlame:IsReady() and (v27.UnitHasCurseDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) or ((1933 + 2754) < (1977 + 2565))) then
					if (((3201 + 90) > (6560 - 4893)) and v25(v95.CauterizingFlameFocus)) then
						return "cauterizing_flame dispel";
					end
				end
				if ((v93.OppressingRoar:IsReady() and v85 and v27.UnitHasEnrageBuff(v14)) or ((2599 - (1668 + 58)) == (2660 - (512 + 114)))) then
					if (v25(v93.OppressingRoar) or ((7341 - 4525) < (22 - 11))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if (((12871 - 9172) < (2190 + 2516)) and (v128 == (0 + 0))) then
				if (((2301 + 345) >= (2954 - 2078)) and (not v15 or not v15:Exists() or not v15:IsInRange(2024 - (109 + 1885)) or not v27.DispellableFriendlyUnit())) then
					return;
				end
				if (((2083 - (1269 + 200)) <= (6102 - 2918)) and v93.Expunge:IsReady() and (v27.UnitHasMagicDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) then
					if (((3941 - (98 + 717)) == (3952 - (802 + 24))) and v25(v95.ExpungeFocus)) then
						return "expunge dispel";
					end
				end
				v128 = 1 - 0;
			end
		end
	end
	local function v113()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2761 - 574) >= (732 + 4222))) then
			local v157 = v27.Interrupt(v93.Quell, 8 + 2, true);
			if (v157 or ((637 + 3240) == (772 + 2803))) then
				return v157;
			end
			v157 = v27.InterruptWithStun(v93.TailSwipe, 22 - 14);
			if (((2357 - 1650) > (227 + 405)) and v157) then
				return v157;
			end
			v157 = v27.Interrupt(v93.Quell, 5 + 5, true, v16, v95.QuellMouseover);
			if (v157 or ((451 + 95) >= (1952 + 732))) then
				return v157;
			end
		end
	end
	local function v114()
		local v129 = 0 + 0;
		while true do
			if (((2898 - (797 + 636)) <= (20882 - 16581)) and (v129 == (1620 - (1427 + 192)))) then
				ShouldReturn = v27.HandleBottomTrinket(v96, v38, 14 + 26, nil);
				if (((3955 - 2251) > (1281 + 144)) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
			if ((v129 == (0 + 0)) or ((1013 - (192 + 134)) == (5510 - (316 + 960)))) then
				ShouldReturn = v27.HandleTopTrinket(v96, v38, 23 + 17, nil);
				if (ShouldReturn or ((2570 + 760) < (1321 + 108))) then
					return ShouldReturn;
				end
				v129 = 3 - 2;
			end
		end
	end
	local function v115()
		local v130 = 551 - (83 + 468);
		while true do
			if (((2953 - (1202 + 604)) >= (1563 - 1228)) and (v130 == (0 - 0))) then
				if (((9510 - 6075) > (2422 - (45 + 280))) and v93.LivingFlame:IsCastable() and v13:BuffUp(v93.LeapingFlamesBuff)) then
					if (v25(v93.LivingFlame, not v14:IsSpellInRange(v93.LivingFlame), v105) or ((3639 + 131) >= (3531 + 510))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (v93.FireBreath:IsReady() or ((1385 + 2406) <= (892 + 719))) then
					if ((v102 <= (1 + 1)) or ((8476 - 3898) <= (3919 - (340 + 1571)))) then
						v106 = 1 + 0;
					elseif (((2897 - (1733 + 39)) <= (5704 - 3628)) and (v102 <= (1038 - (125 + 909)))) then
						v106 = 1950 - (1096 + 852);
					elseif ((v102 <= (3 + 3)) or ((1060 - 317) >= (4267 + 132))) then
						v106 = 515 - (409 + 103);
					else
						v106 = 240 - (46 + 190);
					end
					v33 = v106;
					if (((1250 - (51 + 44)) < (472 + 1201)) and v25(v95.FireBreathMacro, not v14:IsInRange(1347 - (1114 + 203)), true, nil, true)) then
						return "fire_breath damage " .. v106;
					end
				end
				v130 = 727 - (228 + 498);
			end
			if ((v130 == (1 + 0)) or ((1284 + 1040) <= (1241 - (174 + 489)))) then
				if (((9814 - 6047) == (5672 - (830 + 1075))) and v93.Disintegrate:IsReady() and v13:BuffUp(v93.EssenceBurstBuff)) then
					if (((4613 - (303 + 221)) == (5358 - (231 + 1038))) and v25(v93.Disintegrate, not v14:IsSpellInRange(v93.Disintegrate), v105)) then
						return "disintegrate damage";
					end
				end
				if (((3715 + 743) >= (2836 - (171 + 991))) and v93.LivingFlame:IsCastable()) then
					if (((4005 - 3033) <= (3807 - 2389)) and v25(v93.LivingFlame, not v14:IsSpellInRange(v93.LivingFlame), v105)) then
						return "living_flame damage";
					end
				end
				v130 = 4 - 2;
			end
			if ((v130 == (2 + 0)) or ((17309 - 12371) < (13737 - 8975))) then
				if (v93.AzureStrike:IsCastable() or ((4035 - 1531) > (13180 - 8916))) then
					if (((3401 - (111 + 1137)) == (2311 - (91 + 67))) and v25(v93.AzureStrike, not v14:IsSpellInRange(v93.AzureStrike))) then
						return "azure_strike damage";
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v131 = 0 - 0;
		local v132;
		while true do
			if ((v131 == (1 + 0)) or ((1030 - (423 + 100)) >= (19 + 2572))) then
				if (((12407 - 7926) == (2336 + 2145)) and v93.Stasis:IsReady() and v56 and v27.AreUnitsBelowHealthPercentage(v57, v58)) then
					if (v25(v93.Stasis) or ((3099 - (326 + 445)) < (3024 - 2331))) then
						return "stasis cooldown";
					end
				end
				if (((9641 - 5313) == (10102 - 5774)) and v93.StasisReactivate:IsReady() and v56 and (v27.AreUnitsBelowHealthPercentage(v57, v58) or (v13:BuffUp(v93.StasisBuff) and (v13:BuffRemains(v93.StasisBuff) < (714 - (530 + 181)))))) then
					if (((2469 - (614 + 267)) >= (1364 - (19 + 13))) and v25(v93.StasisReactivate)) then
						return "stasis_reactivate cooldown";
					end
				end
				if (v93.TipTheScales:IsCastable() or ((6793 - 2619) > (9899 - 5651))) then
					if ((v93.DreamBreath:IsReady() and v59 and v27.AreUnitsBelowHealthPercentage(v60, v61)) or ((13100 - 8514) <= (22 + 60))) then
						local v185 = 0 - 0;
						while true do
							if (((8011 - 4148) == (5675 - (1293 + 519))) and (v185 == (0 - 0))) then
								v34 = 2 - 1;
								if (v25(v95.TipTheScalesDreamBreath) or ((539 - 257) <= (180 - 138))) then
									return "dream_breath cooldown";
								end
								break;
							end
						end
					elseif (((10857 - 6248) >= (406 + 360)) and v93.Spiritbloom:IsReady() and v62 and v27.AreUnitsBelowHealthPercentage(v63, v64)) then
						v35 = 1 + 2;
						if (v25(v95.TipTheScalesSpiritbloom) or ((2676 - 1524) == (575 + 1913))) then
							return "spirit_bloom cooldown";
						end
					end
				end
				v131 = 1 + 1;
			end
			if (((2139 + 1283) > (4446 - (709 + 387))) and (v131 == (1861 - (673 + 1185)))) then
				if (((2543 - 1666) > (1207 - 831)) and v93.TimeDilation:IsCastable() and v68 and (v15:HealthPercentage() <= v69)) then
					if (v25(v95.TimeDilationFocus) or ((5129 - 2011) <= (1324 + 527))) then
						return "time_dilation cooldown";
					end
				end
				if (v93.FireBreath:IsReady() or ((124 + 41) >= (4714 - 1222))) then
					local v166 = 0 + 0;
					while true do
						if (((7873 - 3924) < (9531 - 4675)) and ((1881 - (446 + 1434)) == v166)) then
							if (v25(v95.FireBreathMacro, not v14:IsInRange(1313 - (1040 + 243)), true, nil, true) or ((12762 - 8486) < (4863 - (559 + 1288)))) then
								return "fire_breath cds " .. v106;
							end
							break;
						end
						if (((6621 - (609 + 1322)) > (4579 - (13 + 441))) and (v166 == (0 - 0))) then
							if ((v102 <= (5 - 3)) or ((249 - 199) >= (34 + 862))) then
								v106 = 3 - 2;
							elseif ((v102 <= (2 + 2)) or ((752 + 962) >= (8777 - 5819))) then
								v106 = 2 + 0;
							elseif ((v102 <= (10 - 4)) or ((986 + 505) < (359 + 285))) then
								v106 = 3 + 0;
							else
								v106 = 4 + 0;
							end
							v33 = v106;
							v166 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((1137 - (153 + 280)) < (2849 - 1862)) and ((0 + 0) == v131)) then
				if (((1469 + 2249) > (998 + 908)) and (not v15 or not v15:Exists() or not v15:IsInRange(28 + 2))) then
					return;
				end
				v132 = v114();
				if (v132 or ((695 + 263) > (5535 - 1900))) then
					return v132;
				end
				v131 = 1 + 0;
			end
			if (((4168 - (89 + 578)) <= (3209 + 1283)) and (v131 == (3 - 1))) then
				if ((v93.DreamFlight:IsCastable() and (v90 == "At Cursor") and v27.AreUnitsBelowHealthPercentage(v91, v92)) or ((4491 - (572 + 477)) < (344 + 2204))) then
					if (((1726 + 1149) >= (175 + 1289)) and v25(v95.DreamFlightCursor)) then
						return "Dream_Flight cooldown";
					end
				end
				if ((v93.DreamFlight:IsCastable() and (v90 == "Confirmation") and v27.AreUnitsBelowHealthPercentage(v91, v92)) or ((4883 - (84 + 2)) >= (8063 - 3170))) then
					if (v25(v93.DreamFlight) or ((397 + 154) > (2910 - (497 + 345)))) then
						return "Dream_Flight cooldown";
					end
				end
				if (((55 + 2059) > (160 + 784)) and v93.Rewind:IsCastable() and v65 and v27.AreUnitsBelowHealthPercentage(v66, v67)) then
					if (v25(v93.Rewind) or ((3595 - (605 + 728)) >= (2209 + 887))) then
						return "rewind cooldown";
					end
				end
				v131 = 6 - 3;
			end
		end
	end
	local function v117()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (7 - 5)) or ((2033 + 222) >= (9799 - 6262))) then
				if ((v93.DreamBreath:IsReady() and v59 and v27.AreUnitsBelowHealthPercentage(v60, v61)) or ((2898 + 939) < (1795 - (457 + 32)))) then
					local v167 = 0 + 0;
					while true do
						if (((4352 - (832 + 570)) == (2780 + 170)) and (v167 == (1 + 0))) then
							if (v25(v95.DreamBreathMacro, nil, true) or ((16713 - 11990) < (1589 + 1709))) then
								return "dream_breath aoe_healing";
							end
							break;
						end
						if (((1932 - (588 + 208)) >= (414 - 260)) and (v167 == (1800 - (884 + 916)))) then
							if ((v109 <= (3 - 1)) or ((158 + 113) > (5401 - (232 + 421)))) then
								v107 = 1890 - (1569 + 320);
							else
								v107 = 1 + 1;
							end
							v34 = v107;
							v167 = 1 + 0;
						end
					end
				end
				if (((15972 - 11232) >= (3757 - (316 + 289))) and v93.Spiritbloom:IsReady() and v62 and v27.AreUnitsBelowHealthPercentage(v63, v64)) then
					local v168 = 0 - 0;
					while true do
						if ((v168 == (0 + 0)) or ((4031 - (666 + 787)) >= (3815 - (360 + 65)))) then
							if (((39 + 2) <= (1915 - (79 + 175))) and (v109 > (2 - 0))) then
								v108 = 3 + 0;
							else
								v108 = 2 - 1;
							end
							v35 = 5 - 2;
							v168 = 900 - (503 + 396);
						end
						if (((782 - (92 + 89)) < (6906 - 3346)) and (v168 == (1 + 0))) then
							if (((140 + 95) < (2690 - 2003)) and v25(v95.SpiritbloomFocus, nil, true)) then
								return "spirit_bloom aoe_healing";
							end
							break;
						end
					end
				end
				v133 = 1 + 2;
			end
			if (((10371 - 5822) > (1006 + 147)) and (v133 == (1 + 0))) then
				if ((v70 == "Everyone") or ((14235 - 9561) < (584 + 4088))) then
					if (((5593 - 1925) < (5805 - (485 + 759))) and v93.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v71)) then
						if (v21(v95.VerdantEmbraceFocus, nil) or ((1052 - 597) == (4794 - (442 + 747)))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				if ((v70 == "Not Tank") or ((3798 - (832 + 303)) == (4258 - (88 + 858)))) then
					if (((1304 + 2973) <= (3704 + 771)) and v93.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v71) and (v27.UnitGroupRole(v15) ~= "TANK")) then
						if (v21(v95.VerdantEmbraceFocus, nil) or ((36 + 834) == (1978 - (766 + 23)))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v133 = 9 - 7;
			end
			if (((2123 - 570) <= (8254 - 5121)) and (v133 == (0 - 0))) then
				if ((v93.EmeraldBlossom:IsCastable() and v72 and v27.AreUnitsBelowHealthPercentage(v73, v74)) or ((3310 - (1036 + 37)) >= (2490 + 1021))) then
					if (v25(v95.EmeraldBlossomFocus) or ((2577 - 1253) > (2376 + 644))) then
						return "emerald_blossom aoe_healing";
					end
				end
				if ((v70 == "Player Only") or ((4472 - (641 + 839)) == (2794 - (910 + 3)))) then
					if (((7918 - 4812) > (3210 - (1466 + 218))) and v93.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v71)) then
						if (((1390 + 1633) < (5018 - (556 + 592))) and v21(v95.VerdantEmbracePlayer, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v133 = 1 + 0;
			end
			if (((951 - (329 + 479)) > (928 - (174 + 680))) and (v133 == (10 - 7))) then
				if (((37 - 19) < (1508 + 604)) and v93.LivingFlame:IsCastable() and v75 and v13:BuffUp(v93.LeapingFlamesBuff) and (v15:HealthPercentage() <= v76)) then
					if (((1836 - (396 + 343)) <= (145 + 1483)) and v25(v95.LivingFlameFocus, not v15:IsSpellInRange(v93.LivingFlame), v105)) then
						return "living_flame_leaping_flames aoe_healing";
					end
				end
				break;
			end
		end
	end
	local function v118()
		if (((6107 - (29 + 1448)) == (6019 - (135 + 1254))) and v93.Reversion:IsReady() and v77 and (v27.UnitGroupRole(v15) ~= "TANK") and (v27.FriendlyUnitsWithBuffCount(v93.Reversion) < (3 - 2)) and (v15:HealthPercentage() <= v78)) then
			if (((16528 - 12988) > (1789 + 894)) and v25(v95.ReversionFocus)) then
				return "reversion_tank st_healing";
			end
		end
		if (((6321 - (389 + 1138)) >= (3849 - (102 + 472))) and v93.Reversion:IsReady() and v77 and (v27.UnitGroupRole(v15) == "TANK") and (v27.FriendlyUnitsWithBuffCount(v93.Reversion, true, false) < (1 + 0)) and (v15:HealthPercentage() <= v79)) then
			if (((823 + 661) == (1384 + 100)) and v25(v95.ReversionFocus)) then
				return "reversion_tank st_healing";
			end
		end
		if (((2977 - (320 + 1225)) < (6328 - 2773)) and v93.TemporalAnomaly:IsReady() and v80 and v27.AreUnitsBelowHealthPercentage(v81, v82)) then
			if (v25(v93.TemporalAnomaly, not v15:IsInRange(19 + 11), v105) or ((2529 - (157 + 1307)) > (5437 - (821 + 1038)))) then
				return "temporal_anomaly st_healing";
			end
		end
		if ((v93.Echo:IsReady() and v83 and not v15:BuffUp(v93.Echo) and (v15:HealthPercentage() <= v84)) or ((11963 - 7168) < (154 + 1253))) then
			if (((3290 - 1437) < (1791 + 3022)) and v25(v95.EchoFocus)) then
				return "echo st_healing";
			end
		end
		if ((v93.LivingFlame:IsReady() and v75 and (v15:HealthPercentage() <= v76)) or ((6991 - 4170) < (3457 - (834 + 192)))) then
			if (v25(v95.LivingFlameFocus, not v15:IsSpellInRange(v93.LivingFlame), v105) or ((183 + 2691) < (560 + 1621))) then
				return "living_flame st_healing";
			end
		end
	end
	local function v119()
		if (not v15 or not v15:Exists() or not v15:IsInRange(1 + 29) or ((4165 - 1476) <= (647 - (300 + 4)))) then
			return;
		end
		local v134 = v117();
		if (v134 or ((500 + 1369) == (5258 - 3249))) then
			return v134;
		end
		v134 = v118();
		if (v134 or ((3908 - (112 + 250)) < (926 + 1396))) then
			return v134;
		end
	end
	local function v120()
		if (v46 or v45 or ((5215 - 3133) == (2735 + 2038))) then
			local v158 = 0 + 0;
			local v159;
			while true do
				if (((2427 + 817) > (524 + 531)) and (v158 == (0 + 0))) then
					v159 = v112();
					if (v159 or ((4727 - (1001 + 413)) <= (3964 - 2186))) then
						return v159;
					end
					break;
				end
			end
		end
		local v135 = v111();
		if (v135 or ((2303 - (244 + 638)) >= (2797 - (627 + 66)))) then
			return v135;
		end
		v135 = v116();
		if (((5398 - 3586) <= (3851 - (512 + 90))) and v135) then
			return v135;
		end
		v135 = v113();
		if (((3529 - (1665 + 241)) <= (2674 - (373 + 344))) and v135) then
			return v135;
		end
		v135 = v119();
		if (((1990 + 2422) == (1168 + 3244)) and v135) then
			return v135;
		end
		if (((4616 - 2866) >= (1424 - 582)) and v27.TargetIsValid()) then
			v135 = v115();
			if (((5471 - (35 + 1064)) > (1347 + 503)) and v135) then
				return v135;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		while true do
			if (((1 + 231) < (2057 - (298 + 938))) and (v136 == (1259 - (233 + 1026)))) then
				if (((2184 - (636 + 1030)) < (462 + 440)) and (v46 or v45)) then
					local v169 = 0 + 0;
					local v170;
					while true do
						if (((890 + 2104) > (58 + 800)) and (v169 == (221 - (55 + 166)))) then
							v170 = v112();
							if (v170 or ((728 + 3027) <= (93 + 822))) then
								return v170;
							end
							break;
						end
					end
				end
				if (((15069 - 11123) > (4040 - (36 + 261))) and v36) then
					local v171 = 0 - 0;
					local v172;
					while true do
						if ((v171 == (1368 - (34 + 1334))) or ((514 + 821) >= (2569 + 737))) then
							v172 = v119();
							if (((6127 - (1035 + 248)) > (2274 - (20 + 1))) and v172) then
								return v172;
							end
							v171 = 1 + 0;
						end
						if (((771 - (134 + 185)) == (1585 - (549 + 584))) and (v171 == (686 - (314 + 371)))) then
							if ((UseBlessingoftheBronze and v93.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v93.BlessingoftheBronzeBuff, true) or v27.GroupBuffMissing(v93.BlessingoftheBronzeBuff))) or ((15643 - 11086) < (3055 - (478 + 490)))) then
								if (((2053 + 1821) == (5046 - (786 + 386))) and v25(v93.BlessingoftheBronze)) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (v27.TargetIsValid() or ((6277 - 4339) > (6314 - (1055 + 324)))) then
								local v192 = 1340 - (1093 + 247);
								local v193;
								while true do
									if ((v192 == (0 + 0)) or ((448 + 3807) < (13589 - 10166))) then
										v193 = v110();
										if (((4934 - 3480) <= (7088 - 4597)) and v193) then
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
				break;
			end
		end
	end
	local function v122()
		v40 = EpicSettings.Settings['UseRacials'];
		v41 = EpicSettings.Settings['UseHealingPotion'];
		v42 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v43 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v44 = EpicSettings.Settings['UseBlessingOfTheBronze'];
		v45 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
		v46 = EpicSettings.Settings['DispelBuffs'] or (0 - 0);
		v47 = EpicSettings.Settings['UseHealthstone'];
		v48 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v49 = EpicSettings.Settings['HandleCharredTreant'] or (0 - 0);
		v50 = EpicSettings.Settings['HandleCharredBrambles'] or (688 - (364 + 324));
		v51 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v52 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v53 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v54 = EpicSettings.Settings['UseObsidianScales'];
		v55 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
		v56 = EpicSettings.Settings['UseStasis'];
		v57 = EpicSettings.Settings['StasisHP'] or (0 - 0);
		v58 = EpicSettings.Settings['StasisGroup'] or (0 - 0);
		v59 = EpicSettings.Settings['UseDreamBreath'];
		v60 = EpicSettings.Settings['DreamBreathHP'] or (1268 - (1249 + 19));
		v61 = EpicSettings.Settings['DreamBreathGroup'] or (0 + 0);
		v62 = EpicSettings.Settings['UseSpiritbloom'];
		v63 = EpicSettings.Settings['SpiritbloomHP'] or (0 - 0);
		v64 = EpicSettings.Settings['SpiritbloomGroup'] or (1086 - (686 + 400));
		v65 = EpicSettings.Settings['UseRewind'];
		v66 = EpicSettings.Settings['RewindHP'] or (0 + 0);
		v67 = EpicSettings.Settings['RewindGroup'] or (229 - (73 + 156));
		v68 = EpicSettings.Settings['UseTimeDilation'];
		v69 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
		v70 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v71 = EpicSettings.Settings['VerdantEmbraceHP'] or (811 - (721 + 90));
		v72 = EpicSettings.Settings['UseEmeraldBlossom'];
		v73 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
		v74 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
		v75 = EpicSettings.Settings['UseLivingFlame'];
		v76 = EpicSettings.Settings['LivingFlameHP'] or (470 - (224 + 246));
		v77 = EpicSettings.Settings['UseReversion'];
		v78 = EpicSettings.Settings['ReversionHP'] or (0 - 0);
		v79 = EpicSettings.Settings['ReversionTankHP'] or (0 - 0);
		v80 = EpicSettings.Settings['UseTemporalAnomaly'];
		v81 = EpicSettings.Settings['TemporalAnomalyHP'] or (0 + 0);
		v82 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 + 0);
		v83 = EpicSettings.Settings['UseEcho'];
		v84 = EpicSettings.Settings['EchoHP'] or (0 + 0);
		v85 = EpicSettings.Settings['UseOppressingRoar'];
		v86 = EpicSettings.Settings['UseRenewingBlaze'];
		v87 = EpicSettings.Settings['RenewingBlazeHP'] or (0 - 0);
		v88 = EpicSettings.Settings['UseHover'];
		v89 = EpicSettings.Settings['HoverTime'] or (0 - 0);
	end
	local function v123()
		v90 = EpicSettings.Settings['DreamFlightUsage'] or "";
		v91 = EpicSettings.Settings['DreamFlightHP'] or (513 - (203 + 310));
		v92 = EpicSettings.Settings['DreamFlightGroup'] or (1993 - (1238 + 755));
	end
	local function v124()
		local v155 = 0 + 0;
		while true do
			if (((1539 - (709 + 825)) == v155) or ((7660 - 3503) <= (4082 - 1279))) then
				v100 = v13:GetEnemiesInRange(889 - (196 + 668));
				v101 = v14:GetEnemiesInSplashRange(31 - 23);
				if (((10052 - 5199) >= (3815 - (171 + 662))) and v37) then
					v102 = #v101;
				else
					v102 = 94 - (4 + 89);
				end
				v155 = 20 - 14;
			end
			if (((1506 + 2628) > (14744 - 11387)) and ((3 + 3) == v155)) then
				if (v27.TargetIsValid() or v13:AffectingCombat() or ((4903 - (35 + 1451)) < (3987 - (28 + 1425)))) then
					local v173 = 1993 - (941 + 1052);
					while true do
						if (((0 + 0) == v173) or ((4236 - (822 + 692)) <= (233 - 69))) then
							v103 = v9.BossFightRemains(nil, true);
							v104 = v103;
							v173 = 1 + 0;
						end
						if ((v173 == (298 - (45 + 252))) or ((2383 + 25) < (726 + 1383))) then
							if ((v104 == (27041 - 15930)) or ((466 - (114 + 319)) == (2088 - 633))) then
								v104 = v9.FightRemains(v100, false);
							end
							break;
						end
					end
				end
				if (v13:IsChanneling(v93.FireBreath) or ((567 - 124) >= (2560 + 1455))) then
					local v174 = 0 - 0;
					local v175;
					while true do
						if (((7085 - 3703) > (2129 - (556 + 1407))) and (v174 == (1206 - (741 + 465)))) then
							v175 = GetTime() - v13:CastStart();
							if ((v175 >= v13:EmpowerCastTime(v33)) or ((745 - (170 + 295)) == (1612 + 1447))) then
								local v194 = 0 + 0;
								while true do
									if (((4631 - 2750) > (1072 + 221)) and (v194 == (0 + 0))) then
										v9.EpicSettingsS = v93.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				if (((1335 + 1022) == (3587 - (957 + 273))) and v13:IsChanneling(v93.DreamBreath)) then
					local v176 = GetTime() - v13:CastStart();
					if (((33 + 90) == (50 + 73)) and (v176 >= v13:EmpowerCastTime(v34))) then
						v9.EpicSettingsS = v93.DreamBreath.ReturnID;
						return "Stopping DreamBreath";
					end
				end
				v155 = 26 - 19;
			end
			if ((v155 == (0 - 0)) or ((3225 - 2169) >= (16796 - 13404))) then
				v122();
				v123();
				if (v13:IsDeadOrGhost() or ((2861 - (389 + 1391)) < (675 + 400))) then
					return;
				end
				v155 = 1 + 0;
			end
			if ((v155 == (6 - 3)) or ((2000 - (783 + 168)) >= (14874 - 10442))) then
				if (v13:AffectingCombat() or v45 or ((4690 + 78) <= (1157 - (309 + 2)))) then
					local v177 = 0 - 0;
					local v178;
					local v179;
					while true do
						if ((v177 == (1213 - (1090 + 122))) or ((1089 + 2269) <= (4769 - 3349))) then
							if (v179 or ((2559 + 1180) <= (4123 - (628 + 490)))) then
								return v179;
							end
							break;
						end
						if ((v177 == (0 + 0)) or ((4107 - 2448) >= (9752 - 7618))) then
							v178 = v45 and v93.Expunge:IsReady();
							v179 = v27.FocusUnit(v178, v95, 804 - (431 + 343), 40 - 20);
							v177 = 2 - 1;
						end
					end
				end
				if (v49 or ((2576 + 684) < (302 + 2053))) then
					local v180 = 1695 - (556 + 1139);
					while true do
						if (((15 - (6 + 9)) == v180) or ((123 + 546) == (2164 + 2059))) then
							ShouldReturn = v27.HandleCharredTreant(v93.Echo, v95.EchoMouseover, 209 - (28 + 141));
							if (ShouldReturn or ((656 + 1036) < (725 - 137))) then
								return ShouldReturn;
							end
							v180 = 1 + 0;
						end
						if ((v180 == (1318 - (486 + 831))) or ((12482 - 7685) < (12853 - 9202))) then
							ShouldReturn = v27.HandleCharredTreant(v93.LivingFlame, v95.LivingFlameMouseover, 8 + 32, true);
							if (ShouldReturn or ((13207 - 9030) > (6113 - (668 + 595)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (v50 or ((360 + 40) > (225 + 886))) then
					local v181 = 0 - 0;
					while true do
						if (((3341 - (23 + 267)) > (2949 - (1129 + 815))) and ((387 - (371 + 16)) == v181)) then
							ShouldReturn = v27.HandleCharredBrambles(v93.Echo, v95.EchoMouseover, 1790 - (1326 + 424));
							if (((6993 - 3300) <= (16012 - 11630)) and ShouldReturn) then
								return ShouldReturn;
							end
							v181 = 119 - (88 + 30);
						end
						if ((v181 == (772 - (720 + 51))) or ((7300 - 4018) > (5876 - (421 + 1355)))) then
							ShouldReturn = v27.HandleCharredBrambles(v93.LivingFlame, v95.LivingFlameMouseover, 65 - 25, true);
							if (ShouldReturn or ((1759 + 1821) < (3927 - (286 + 797)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v155 = 14 - 10;
			end
			if (((146 - 57) < (4929 - (397 + 42))) and (v155 == (1 + 1))) then
				v39 = EpicSettings.Toggles['dispel'];
				if (v13:IsMounted() or ((5783 - (24 + 776)) < (2785 - 977))) then
					return;
				end
				if (((4614 - (222 + 563)) > (8303 - 4534)) and not v13:IsMoving()) then
					v32 = GetTime();
				end
				v155 = 3 + 0;
			end
			if (((1675 - (23 + 167)) <= (4702 - (690 + 1108))) and ((3 + 4) == v155)) then
				if (((3522 + 747) == (5117 - (40 + 808))) and v13:IsChanneling(v93.Spiritbloom)) then
					local v182 = GetTime() - v13:CastStart();
					if (((64 + 323) <= (10638 - 7856)) and (v182 >= v13:EmpowerCastTime(v35))) then
						v9.EpicSettingsS = v93.Spiritbloom.ReturnID;
						return "Stopping Spiritbloom";
					end
				end
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((1816 + 83) <= (486 + 431))) then
					local v183 = 0 + 0;
					local v184;
					while true do
						if ((v183 == (571 - (47 + 524))) or ((2799 + 1513) <= (2394 - 1518))) then
							v184 = v27.DeadFriendlyUnitsCount();
							if (((3336 - 1104) <= (5920 - 3324)) and not v13:AffectingCombat()) then
								if (((3821 - (1165 + 561)) < (110 + 3576)) and (v184 > (3 - 2))) then
									if (v25(v93.MassReturn, nil, true) or ((609 + 986) >= (4953 - (341 + 138)))) then
										return "mass_return";
									end
								elseif (v25(v93.Return, not v14:IsInRange(9 + 21), true) or ((9531 - 4912) < (3208 - (89 + 237)))) then
									return "return";
								end
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((945 - 651) >= (10170 - 5339))) then
					if (((2910 - (581 + 300)) <= (4304 - (855 + 365))) and v13:AffectingCombat()) then
						local v190 = v120();
						if (v190 or ((4838 - 2801) == (791 + 1629))) then
							return v190;
						end
					else
						local v191 = v121();
						if (((5693 - (1030 + 205)) > (3666 + 238)) and v191) then
							return v191;
						end
					end
				end
				break;
			end
			if (((406 + 30) >= (409 - (156 + 130))) and (v155 == (2 - 1))) then
				v36 = EpicSettings.Toggles['ooc'];
				v37 = EpicSettings.Toggles['aoe'];
				v38 = EpicSettings.Toggles['cds'];
				v155 = 2 - 0;
			end
			if (((1024 - 524) < (479 + 1337)) and ((3 + 1) == v155)) then
				if (((3643 - (10 + 59)) == (1011 + 2563)) and v88 and (v36 or v13:AffectingCombat())) then
					if (((1088 - 867) < (1553 - (671 + 492))) and ((GetTime() - v32) > v89)) then
						if ((v93.Hover:IsReady() and v13:BuffDown(v93.Hover)) or ((1762 + 451) <= (2636 - (369 + 846)))) then
							if (((810 + 2248) < (4148 + 712)) and v25(v93.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				v105 = v13:BuffRemains(v93.HoverBuff) < (1947 - (1036 + 909));
				v109 = v27.FriendlyUnitsBelowHealthPercentageCount(68 + 17);
				v155 = 8 - 3;
			end
		end
	end
	local function v125()
		local v156 = 203 - (11 + 192);
		while true do
			if ((v156 == (2 + 0)) or ((1471 - (135 + 40)) >= (10771 - 6325))) then
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableCurseDebuffs);
				break;
			end
			if ((v156 == (0 + 0)) or ((3068 - 1675) > (6728 - 2239))) then
				v20.Print("Preservation Evoker by Epic BoomK");
				EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By BoomK");
				v156 = 177 - (50 + 126);
			end
			if ((v156 == (2 - 1)) or ((980 + 3444) < (1440 - (1233 + 180)))) then
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableMagicDebuffs);
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableDiseaseDebuffs);
				v156 = 971 - (522 + 447);
			end
		end
	end
	v20.SetAPL(2889 - (107 + 1314), v124, v125);
end;
return v0["Epix_Evoker_Preservation.lua"]();

