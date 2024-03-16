local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((2213 + 156) == (300 + 126))) then
			v6 = v0[v4];
			if (not v6 or ((3202 - (55 + 71)) > (4192 - 1009))) then
				return v1(v4, ...);
			end
			v5 = 1791 - (573 + 1217);
		end
		if (((3328 - 2126) > (81 + 977)) and (v5 == (1 - 0))) then
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
	local v32 = 939 - (714 + 225);
	local v33 = 2 - 1;
	local v34 = 1 - 0;
	local v35 = 1 + 0;
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
	local v98 = (v97[18 - 5] and v20(v97[819 - (118 + 688)])) or v20(48 - (25 + 23));
	local v99 = (v97[3 + 11] and v20(v97[1900 - (927 + 959)])) or v20(0 - 0);
	local v100;
	local v101;
	local v102;
	local v103 = 11843 - (16 + 716);
	local v104 = 21448 - 10337;
	local v105;
	local v106 = 97 - (11 + 86);
	local v107 = 0 - 0;
	local v108 = 285 - (175 + 110);
	local v109 = 0 - 0;
	v10:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if (((5507 - (503 + 1293)) > (9369 - 6014)) and (v126 == (0 + 0))) then
				v97 = v14:GetEquipment();
				v98 = (v97[1074 - (810 + 251)] and v20(v97[10 + 3])) or v20(0 + 0);
				v126 = 1 + 0;
			end
			if ((v126 == (534 - (43 + 490))) or ((1639 - (711 + 22)) >= (8622 - 6393))) then
				v99 = (v97[873 - (240 + 619)] and v20(v97[4 + 10])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v103 = 736 + 10375;
		v104 = 12855 - (1344 + 400);
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		local v127 = 405 - (255 + 150);
		while true do
			if (((1015 + 273) > (670 + 581)) and (v127 == (0 - 0))) then
				if (v93.LivingFlame:IsCastable() or ((14576 - 10063) < (5091 - (404 + 1335)))) then
					if (v26(v93.LivingFlame, not v15:IsInRange(431 - (183 + 223)), v105) or ((2512 - 447) >= (2118 + 1078))) then
						return "living_flame precombat";
					end
				end
				if (v93.AzureStrike:IsCastable() or ((1575 + 2801) <= (1818 - (10 + 327)))) then
					if (v26(v93.AzureStrike, not v15:IsSpellInRange(v93.AzureStrike)) or ((2363 + 1029) >= (5079 - (118 + 220)))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
		end
	end
	local function v111()
		if (((1109 + 2216) >= (2603 - (108 + 341))) and v93.ObsidianScales:IsCastable() and v54 and v14:BuffDown(v93.ObsidianScales) and (v14:HealthPercentage() < v55)) then
			if (v26(v93.ObsidianScales) or ((582 + 713) >= (13668 - 10435))) then
				return "obsidian_scales defensives";
			end
		end
		if (((5870 - (711 + 782)) > (3147 - 1505)) and v94.Healthstone:IsReady() and v47 and (v14:HealthPercentage() <= v48)) then
			if (((5192 - (270 + 199)) > (440 + 916)) and v26(v95.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if ((v41 and (v14:HealthPercentage() <= v43)) or ((5955 - (580 + 1239)) <= (10205 - 6772))) then
			if (((4059 + 186) <= (167 + 4464)) and (v42 == "Refreshing Healing Potion")) then
				if (((1863 + 2413) >= (10218 - 6304)) and v94.RefreshingHealingPotion:IsReady()) then
					if (((124 + 74) <= (5532 - (645 + 522))) and v26(v95.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
		if (((6572 - (1010 + 780)) > (4674 + 2)) and v93.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v87) and v86) then
			if (((23171 - 18307) > (6438 - 4241)) and v22(v93.RenewingBlaze, nil, nil)) then
				return "RenewingBlaze defensive";
			end
		end
	end
	local function v112()
		local v128 = 1836 - (1045 + 791);
		while true do
			if ((v128 == (2 - 1)) or ((5649 - 1949) == (3012 - (351 + 154)))) then
				if (((6048 - (1281 + 293)) >= (540 - (28 + 238))) and v93.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
					if (v26(v95.CauterizingFlameFocus) or ((4231 - 2337) <= (2965 - (1381 + 178)))) then
						return "cauterizing_flame dispel";
					end
				end
				if (((1475 + 97) >= (1235 + 296)) and v93.OppressingRoar:IsReady() and v85 and v28.UnitHasEnrageBuff(v15)) then
					if (v26(v93.OppressingRoar) or ((2000 + 2687) < (15658 - 11116))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if (((1705 + 1586) > (2137 - (381 + 89))) and (v128 == (0 + 0))) then
				if (not v16 or not v16:Exists() or not v28.UnitHasDispellableDebuffByPlayer(v16) or ((591 + 282) == (3483 - 1449))) then
					return;
				end
				if ((v93.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or ((3972 - (1074 + 82)) < (23 - 12))) then
					if (((5483 - (214 + 1570)) < (6161 - (990 + 465))) and v26(v95.ExpungeFocus)) then
						return "expunge dispel";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v113()
		if (((1152 + 1494) >= (852 + 24)) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v163 = v28.Interrupt(v93.Quell, 39 - 29, true);
			if (((2340 - (1668 + 58)) <= (3810 - (512 + 114))) and v163) then
				return v163;
			end
			v163 = v28.InterruptWithStun(v93.TailSwipe, 20 - 12);
			if (((6462 - 3336) == (10877 - 7751)) and v163) then
				return v163;
			end
			v163 = v28.Interrupt(v93.Quell, 5 + 5, true, v17, v95.QuellMouseover);
			if (v163 or ((410 + 1777) >= (4307 + 647))) then
				return v163;
			end
		end
	end
	local function v114()
		local v129 = 0 - 0;
		local v130;
		while true do
			if ((v129 == (1995 - (109 + 1885))) or ((5346 - (1269 + 200)) == (6852 - 3277))) then
				v130 = v28.HandleBottomTrinket(v96, v38, 855 - (98 + 717), nil);
				if (((1533 - (802 + 24)) > (1089 - 457)) and v130) then
					return v130;
				end
				break;
			end
			if ((v129 == (0 - 0)) or ((81 + 465) >= (2063 + 621))) then
				v130 = v28.HandleTopTrinket(v96, v38, 7 + 33, nil);
				if (((317 + 1148) <= (11965 - 7664)) and v130) then
					return v130;
				end
				v129 = 3 - 2;
			end
		end
	end
	local function v115()
		local v131 = 0 + 0;
		while true do
			if (((694 + 1010) > (1176 + 249)) and (v131 == (2 + 0))) then
				if (v93.AzureStrike:IsCastable() or ((321 + 366) == (5667 - (797 + 636)))) then
					if (v26(v93.AzureStrike, not v15:IsSpellInRange(v93.AzureStrike)) or ((16168 - 12838) < (3048 - (1427 + 192)))) then
						return "azure_strike damage";
					end
				end
				break;
			end
			if (((398 + 749) >= (777 - 442)) and (v131 == (0 + 0))) then
				if (((1557 + 1878) > (2423 - (192 + 134))) and v93.LivingFlame:IsCastable() and v14:BuffUp(v93.LeapingFlamesBuff)) then
					if (v26(v93.LivingFlame, not v15:IsSpellInRange(v93.LivingFlame), v105) or ((5046 - (316 + 960)) >= (2249 + 1792))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (v93.FireBreath:IsReady() or ((2926 + 865) <= (1490 + 121))) then
					local v182 = 0 - 0;
					while true do
						if ((v182 == (551 - (83 + 468))) or ((6384 - (1202 + 604)) <= (9373 - 7365))) then
							if (((1871 - 746) <= (5747 - 3671)) and (v102 <= (327 - (45 + 280)))) then
								v106 = 1 + 0;
							elseif ((v102 <= (4 + 0)) or ((272 + 471) >= (2435 + 1964))) then
								v106 = 1 + 1;
							elseif (((2138 - 983) < (3584 - (340 + 1571))) and (v102 <= (3 + 3))) then
								v106 = 1775 - (1733 + 39);
							else
								v106 = 10 - 6;
							end
							v33 = v106;
							v182 = 1035 - (125 + 909);
						end
						if ((v182 == (1949 - (1096 + 852))) or ((1043 + 1281) <= (825 - 247))) then
							if (((3654 + 113) == (4279 - (409 + 103))) and v26(v95.FireBreathMacro, not v15:IsInRange(266 - (46 + 190)), true, nil, true)) then
								return "fire_breath damage " .. v106;
							end
							break;
						end
					end
				end
				v131 = 96 - (51 + 44);
			end
			if (((1154 + 2935) == (5406 - (1114 + 203))) and (v131 == (727 - (228 + 498)))) then
				if (((966 + 3492) >= (925 + 749)) and v93.Disintegrate:IsReady() and v14:BuffUp(v93.EssenceBurstBuff)) then
					if (((1635 - (174 + 489)) <= (3694 - 2276)) and v26(v93.Disintegrate, not v15:IsSpellInRange(v93.Disintegrate), v105)) then
						return "disintegrate damage";
					end
				end
				if (v93.LivingFlame:IsCastable() or ((6843 - (830 + 1075)) < (5286 - (303 + 221)))) then
					if (v26(v93.LivingFlame, not v15:IsSpellInRange(v93.LivingFlame), v105) or ((3773 - (231 + 1038)) > (3554 + 710))) then
						return "living_flame damage";
					end
				end
				v131 = 1164 - (171 + 991);
			end
		end
	end
	local function v116()
		local v132 = 0 - 0;
		local v133;
		while true do
			if (((5780 - 3627) == (5372 - 3219)) and ((0 + 0) == v132)) then
				v133 = v114();
				if (v133 or ((1777 - 1270) >= (7474 - 4883))) then
					return v133;
				end
				v132 = 1 - 0;
			end
			if (((13851 - 9370) == (5729 - (111 + 1137))) and (v132 == (159 - (91 + 67)))) then
				if ((v93.Stasis:IsReady() and v56 and v28.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo)) or ((6928 - 4600) < (173 + 520))) then
					if (((4851 - (423 + 100)) == (31 + 4297)) and v26(v93.Stasis)) then
						return "stasis cooldown";
					end
				end
				if (((4396 - 2808) >= (695 + 637)) and v93.StasisReactivate:IsReady() and v56 and (v28.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo) or (v14:BuffUp(v93.StasisBuff) and (v14:BuffRemains(v93.StasisBuff) < (774 - (326 + 445)))))) then
					if (v26(v93.StasisReactivate) or ((18215 - 14041) > (9463 - 5215))) then
						return "stasis_reactivate cooldown";
					end
				end
				v132 = 4 - 2;
			end
			if ((v132 == (714 - (530 + 181))) or ((5467 - (614 + 267)) <= (114 - (19 + 13)))) then
				if (((6286 - 2423) == (9001 - 5138)) and v93.DreamFlight:IsCastable() and (v90 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) then
					if (v26(v93.DreamFlight) or ((805 - 523) <= (11 + 31))) then
						return "Dream_Flight cooldown";
					end
				end
				if (((8105 - 3496) >= (1588 - 822)) and v93.Rewind:IsCastable() and v65 and v28.AreUnitsBelowHealthPercentage(v66, v67, v93.Echo)) then
					if (v26(v93.Rewind) or ((2964 - (1293 + 519)) == (5076 - 2588))) then
						return "rewind cooldown";
					end
				end
				v132 = 9 - 5;
			end
			if (((6543 - 3121) > (14445 - 11095)) and ((4 - 2) == v132)) then
				if (((465 + 412) > (77 + 299)) and v93.TipTheScales:IsCastable()) then
					if ((v93.DreamBreath:IsReady() and v59 and v28.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) or ((7244 - 4126) <= (428 + 1423))) then
						local v187 = 0 + 0;
						while true do
							if ((v187 == (0 + 0)) or ((1261 - (709 + 387)) >= (5350 - (673 + 1185)))) then
								v34 = 2 - 1;
								if (((12680 - 8731) < (7989 - 3133)) and v26(v95.TipTheScalesDreamBreath)) then
									return "dream_breath cooldown";
								end
								break;
							end
						end
					elseif ((v93.Spiritbloom:IsReady() and v62 and v28.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) or ((3059 + 1217) < (2254 + 762))) then
						v35 = 3 - 0;
						if (((1152 + 3538) > (8224 - 4099)) and v26(v95.TipTheScalesSpiritbloom)) then
							return "spirit_bloom cooldown";
						end
					end
				end
				if ((v93.DreamFlight:IsCastable() and (v90 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) or ((98 - 48) >= (2776 - (446 + 1434)))) then
					if (v26(v95.DreamFlightCursor) or ((2997 - (1040 + 243)) >= (8828 - 5870))) then
						return "Dream_Flight cooldown";
					end
				end
				v132 = 1850 - (559 + 1288);
			end
			if ((v132 == (1935 - (609 + 1322))) or ((1945 - (13 + 441)) < (2406 - 1762))) then
				if (((1843 - 1139) < (4915 - 3928)) and v93.TimeDilation:IsCastable() and v68 and (v16:HealthPercentage() <= v69)) then
					if (((139 + 3579) > (6922 - 5016)) and v26(v95.TimeDilationFocus)) then
						return "time_dilation cooldown";
					end
				end
				if (v93.FireBreath:IsReady() or ((341 + 617) > (1593 + 2042))) then
					if (((10389 - 6888) <= (2459 + 2033)) and (v102 <= (3 - 1))) then
						v106 = 1 + 0;
					elseif ((v102 <= (3 + 1)) or ((2474 + 968) < (2140 + 408))) then
						v106 = 2 + 0;
					elseif (((3308 - (153 + 280)) >= (4227 - 2763)) and (v102 <= (6 + 0))) then
						v106 = 2 + 1;
					else
						v106 = 3 + 1;
					end
					v33 = v106;
					if (v26(v95.FireBreathMacro, not v15:IsInRange(28 + 2), true, nil, true) or ((3476 + 1321) >= (7450 - 2557))) then
						return "fire_breath cds " .. v106;
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (669 - (89 + 578))) or ((394 + 157) > (4299 - 2231))) then
				if (((3163 - (572 + 477)) > (128 + 816)) and v93.DreamBreath:IsReady() and v59 and v28.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) then
					if ((v109 <= (2 + 0)) or ((271 + 1991) >= (3182 - (84 + 2)))) then
						v107 = 1 - 0;
					else
						v107 = 2 + 0;
					end
					v34 = v107;
					if (v26(v95.DreamBreathMacro, nil, true) or ((3097 - (497 + 345)) >= (91 + 3446))) then
						return "dream_breath aoe_healing";
					end
				end
				if ((v93.Spiritbloom:IsReady() and v62 and v28.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) or ((649 + 3188) < (2639 - (605 + 728)))) then
					if (((2105 + 845) == (6558 - 3608)) and (v109 > (1 + 1))) then
						v108 = 10 - 7;
					else
						v108 = 1 + 0;
					end
					v35 = 7 - 4;
					if (v26(v95.SpiritbloomFocus, nil, true) or ((3567 + 1156) < (3787 - (457 + 32)))) then
						return "spirit_bloom aoe_healing";
					end
				end
				v134 = 2 + 1;
			end
			if (((2538 - (832 + 570)) >= (146 + 8)) and (v134 == (0 + 0))) then
				if ((v93.EmeraldBlossom:IsCastable() and v72 and v28.AreUnitsBelowHealthPercentage(v73, v74, v93.Echo)) or ((958 - 687) > (2288 + 2460))) then
					if (((5536 - (588 + 208)) >= (8495 - 5343)) and v26(v95.EmeraldBlossomFocus)) then
						return "emerald_blossom aoe_healing";
					end
				end
				if ((v70 == "Player Only") or ((4378 - (884 + 916)) >= (7097 - 3707))) then
					if (((24 + 17) <= (2314 - (232 + 421))) and v93.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v71)) then
						if (((2490 - (1569 + 320)) < (874 + 2686)) and v22(v95.VerdantEmbracePlayer, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 1 + 0;
			end
			if (((791 - 556) < (1292 - (316 + 289))) and (v134 == (7 - 4))) then
				if (((211 + 4338) > (2606 - (666 + 787))) and v93.LivingFlame:IsCastable() and v75 and v14:BuffUp(v93.LeapingFlamesBuff) and (v16:HealthPercentage() <= v76)) then
					if (v26(v95.LivingFlameFocus, not v16:IsSpellInRange(v93.LivingFlame), v105) or ((5099 - (360 + 65)) < (4367 + 305))) then
						return "living_flame_leaping_flames aoe_healing";
					end
				end
				break;
			end
			if (((3922 - (79 + 175)) < (7191 - 2630)) and (v134 == (1 + 0))) then
				if ((v70 == "Everyone") or ((1394 - 939) == (6942 - 3337))) then
					if ((v93.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v71)) or ((3562 - (503 + 396)) == (3493 - (92 + 89)))) then
						if (((8297 - 4020) <= (2295 + 2180)) and v22(v95.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				if ((v70 == "Not Tank") or ((515 + 355) == (4656 - 3467))) then
					if (((213 + 1340) <= (7143 - 4010)) and v93.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v71) and (v28.UnitGroupRole(v16) ~= "TANK")) then
						if (v22(v95.VerdantEmbraceFocus, nil) or ((1952 + 285) >= (1677 + 1834))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 5 - 3;
			end
		end
	end
	local function v118()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (0 - 0)) or ((2568 - (485 + 759)) > (6987 - 3967))) then
				if ((v93.Reversion:IsReady() and v77 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v93.Reversion) < (1190 - (442 + 747))) and (v16:HealthPercentage() <= v78)) or ((4127 - (832 + 303)) == (2827 - (88 + 858)))) then
					if (((947 + 2159) > (1263 + 263)) and v26(v95.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				if (((125 + 2898) < (4659 - (766 + 23))) and v93.Reversion:IsReady() and v77 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v93.Reversion, true, false) < (4 - 3)) and (v16:HealthPercentage() <= v79)) then
					if (((194 - 51) > (194 - 120)) and v26(v95.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v135 = 3 - 2;
			end
			if (((1091 - (1036 + 37)) < (1498 + 614)) and (v135 == (1 - 0))) then
				if (((863 + 234) <= (3108 - (641 + 839))) and v93.TemporalAnomaly:IsReady() and v80 and v28.AreUnitsBelowHealthPercentage(v81, v82, v93.Echo)) then
					if (((5543 - (910 + 3)) == (11803 - 7173)) and v26(v93.TemporalAnomaly, not v16:IsInRange(1714 - (1466 + 218)), v105)) then
						return "temporal_anomaly st_healing";
					end
				end
				if (((1627 + 1913) > (3831 - (556 + 592))) and v93.Echo:IsReady() and v83 and not v16:BuffUp(v93.Echo) and (v16:HealthPercentage() <= v84)) then
					if (((1705 + 3089) >= (4083 - (329 + 479))) and v26(v95.EchoFocus)) then
						return "echo st_healing";
					end
				end
				v135 = 856 - (174 + 680);
			end
			if (((5098 - 3614) == (3075 - 1591)) and (v135 == (2 + 0))) then
				if (((2171 - (396 + 343)) < (315 + 3240)) and v93.LivingFlame:IsReady() and v75 and (v16:HealthPercentage() <= v76)) then
					if (v26(v95.LivingFlameFocus, not v16:IsSpellInRange(v93.LivingFlame), v105) or ((2542 - (29 + 1448)) > (4967 - (135 + 1254)))) then
						return "living_flame st_healing";
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v136 = 0 - 0;
		local v137;
		while true do
			if ((v136 == (0 - 0)) or ((3196 + 1599) < (2934 - (389 + 1138)))) then
				v137 = v117();
				if (((2427 - (102 + 472)) < (4542 + 271)) and v137) then
					return v137;
				end
				v136 = 1 + 0;
			end
			if ((v136 == (1 + 0)) or ((4366 - (320 + 1225)) < (4327 - 1896))) then
				v137 = v118();
				if (v137 or ((1759 + 1115) < (3645 - (157 + 1307)))) then
					return v137;
				end
				break;
			end
		end
	end
	local function v120()
		if (v46 or v45 or ((4548 - (821 + 1038)) <= (855 - 512))) then
			local v164 = v112();
			if (v164 or ((205 + 1664) == (3568 - 1559))) then
				return v164;
			end
		end
		local v138 = v111();
		if (v138 or ((1320 + 2226) < (5754 - 3432))) then
			return v138;
		end
		local v138 = v116();
		if (v138 or ((3108 - (834 + 192)) == (304 + 4469))) then
			return v138;
		end
		local v138 = v113();
		if (((833 + 2411) > (23 + 1032)) and v138) then
			return v138;
		end
		local v138 = v119();
		if (v138 or ((5132 - 1819) <= (2082 - (300 + 4)))) then
			return v138;
		end
		if (v28.TargetIsValid() or ((380 + 1041) >= (5507 - 3403))) then
			local v165 = v115();
			if (((2174 - (112 + 250)) <= (1296 + 1953)) and v165) then
				return v165;
			end
		end
	end
	local function v121()
		local v139 = 0 - 0;
		while true do
			if (((930 + 693) <= (1013 + 944)) and (v139 == (0 + 0))) then
				if (((2188 + 2224) == (3278 + 1134)) and (v46 or v45)) then
					local v183 = 1414 - (1001 + 413);
					local v184;
					while true do
						if (((3902 - 2152) >= (1724 - (244 + 638))) and (v183 == (693 - (627 + 66)))) then
							v184 = v112();
							if (((13026 - 8654) > (2452 - (512 + 90))) and v184) then
								return v184;
							end
							break;
						end
					end
				end
				if (((2138 - (1665 + 241)) < (1538 - (373 + 344))) and v36) then
					local v185 = 0 + 0;
					local v186;
					while true do
						if (((138 + 380) < (2379 - 1477)) and (v185 == (1 - 0))) then
							if (((4093 - (35 + 1064)) > (625 + 233)) and v44 and v93.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v93.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v93.BlessingoftheBronzeBuff))) then
								if (v26(v93.BlessingoftheBronze) or ((8033 - 4278) <= (4 + 911))) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (((5182 - (298 + 938)) > (5002 - (233 + 1026))) and v28.TargetIsValid()) then
								local v192 = v110();
								if (v192 or ((3001 - (636 + 1030)) >= (1691 + 1615))) then
									return v192;
								end
							end
							break;
						end
						if (((4732 + 112) > (670 + 1583)) and (v185 == (0 + 0))) then
							v186 = v119();
							if (((673 - (55 + 166)) == (88 + 364)) and v186) then
								return v186;
							end
							v185 = 1 + 0;
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
		v43 = EpicSettings.Settings['HealingPotionHP'] or (297 - (36 + 261));
		v44 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 - 0);
		v45 = EpicSettings.Settings['DispelDebuffs'] or (1368 - (34 + 1334));
		v46 = EpicSettings.Settings['DispelBuffs'] or (0 + 0);
		v47 = EpicSettings.Settings['UseHealthstone'];
		v48 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v49 = EpicSettings.Settings['HandleCharredTreant'] or (1283 - (1035 + 248));
		v50 = EpicSettings.Settings['HandleCharredBrambles'] or (21 - (20 + 1));
		v51 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v52 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (319 - (134 + 185));
		v53 = EpicSettings.Settings['InterruptThreshold'] or (1133 - (549 + 584));
		v54 = EpicSettings.Settings['UseObsidianScales'];
		v55 = EpicSettings.Settings['ObsidianScalesHP'] or (685 - (314 + 371));
		v56 = EpicSettings.Settings['UseStasis'];
		v57 = EpicSettings.Settings['StasisHP'] or (0 - 0);
		v58 = EpicSettings.Settings['StasisGroup'] or (968 - (478 + 490));
		v59 = EpicSettings.Settings['UseDreamBreath'];
		v60 = EpicSettings.Settings['DreamBreathHP'] or (0 + 0);
		v61 = EpicSettings.Settings['DreamBreathGroup'] or (1172 - (786 + 386));
		v62 = EpicSettings.Settings['UseSpiritbloom'];
		v63 = EpicSettings.Settings['SpiritbloomHP'] or (0 - 0);
		v64 = EpicSettings.Settings['SpiritbloomGroup'] or (1379 - (1055 + 324));
		v65 = EpicSettings.Settings['UseRewind'];
		v66 = EpicSettings.Settings['RewindHP'] or (1340 - (1093 + 247));
		v67 = EpicSettings.Settings['RewindGroup'] or (0 + 0);
		v68 = EpicSettings.Settings['UseTimeDilation'];
		v69 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
		v70 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v71 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 - 0);
		v72 = EpicSettings.Settings['UseEmeraldBlossom'];
		v73 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 - 0);
		v74 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
		v75 = EpicSettings.Settings['UseLivingFlame'];
		v76 = EpicSettings.Settings['LivingFlameHP'] or (0 - 0);
		v77 = EpicSettings.Settings['UseReversion'];
		v78 = EpicSettings.Settings['ReversionHP'] or (0 + 0);
		v79 = EpicSettings.Settings['ReversionTankHP'] or (0 - 0);
		v80 = EpicSettings.Settings['UseTemporalAnomaly'];
		v81 = EpicSettings.Settings['TemporalAnomalyHP'] or (0 - 0);
		v82 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 + 0);
		v83 = EpicSettings.Settings['UseEcho'];
		v84 = EpicSettings.Settings['EchoHP'] or (0 - 0);
		v85 = EpicSettings.Settings['UseOppressingRoar'];
		v86 = EpicSettings.Settings['UseRenewingBlaze'];
		v87 = EpicSettings.Settings['RenewingBlazeHP'] or (688 - (364 + 324));
		v88 = EpicSettings.Settings['UseHover'];
		v89 = EpicSettings.Settings['HoverTime'] or (0 - 0);
	end
	local function v123()
		v90 = EpicSettings.Settings['DreamFlightUsage'] or "";
		v91 = EpicSettings.Settings['DreamFlightHP'] or (0 - 0);
		v92 = EpicSettings.Settings['DreamFlightGroup'] or (0 + 0);
	end
	local function v124()
		v122();
		v123();
		if (v14:IsDeadOrGhost() or ((19067 - 14510) < (3341 - 1254))) then
			return;
		end
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		v39 = EpicSettings.Toggles['dispel'];
		if (((11765 - 7891) == (5142 - (1249 + 19))) and v14:IsMounted()) then
			return;
		end
		if (not v14:IsMoving() or ((1750 + 188) > (19209 - 14274))) then
			v32 = GetTime();
		end
		if (v14:AffectingCombat() or v45 or v36 or ((5341 - (686 + 400)) < (2686 + 737))) then
			local v166 = 229 - (73 + 156);
			local v167;
			local v168;
			while true do
				if (((7 + 1447) <= (3302 - (721 + 90))) and ((0 + 0) == v166)) then
					v167 = v45 and v93.Expunge:IsReady();
					v168 = v28.FocusUnit(v167, nil, 129 - 89, nil, 490 - (224 + 246), v93.Echo);
					v166 = 1 - 0;
				end
				if ((v166 == (1 - 0)) or ((755 + 3402) <= (67 + 2736))) then
					if (((3565 + 1288) >= (5928 - 2946)) and v168) then
						return v168;
					end
					break;
				end
			end
		end
		if (((13756 - 9622) > (3870 - (203 + 310))) and v49) then
			local v169 = v28.HandleCharredTreant(v93.Echo, v95.EchoMouseover, 2033 - (1238 + 755));
			if (v169 or ((239 + 3178) < (4068 - (709 + 825)))) then
				return v169;
			end
			local v169 = v28.HandleCharredTreant(v93.LivingFlame, v95.LivingFlameMouseover, 73 - 33, true);
			if (v169 or ((3964 - 1242) <= (1028 - (196 + 668)))) then
				return v169;
			end
		end
		if (v50 or ((9507 - 7099) < (4368 - 2259))) then
			local v170 = v28.HandleCharredBrambles(v93.Echo, v95.EchoMouseover, 873 - (171 + 662));
			if (v170 or ((126 - (4 + 89)) == (5099 - 3644))) then
				return v170;
			end
			local v170 = v28.HandleCharredBrambles(v93.LivingFlame, v95.LivingFlameMouseover, 15 + 25, true);
			if (v170 or ((1945 - 1502) >= (1575 + 2440))) then
				return v170;
			end
		end
		if (((4868 - (35 + 1451)) > (1619 - (28 + 1425))) and v88 and (v36 or v14:AffectingCombat())) then
			if (((GetTime() - v32) > v89) or ((2273 - (941 + 1052)) == (2934 + 125))) then
				if (((3395 - (822 + 692)) > (1845 - 552)) and v93.Hover:IsReady() and v14:BuffDown(v93.Hover)) then
					if (((1111 + 1246) == (2654 - (45 + 252))) and v26(v93.Hover)) then
						return "hover main 2";
					end
				end
			end
		end
		v105 = v14:BuffRemains(v93.HoverBuff) < (2 + 0);
		v109 = v28.FriendlyUnitsBelowHealthPercentageCount(30 + 55, nil, nil, v93.Echo);
		v100 = v14:GetEnemiesInRange(60 - 35);
		v101 = v15:GetEnemiesInSplashRange(441 - (114 + 319));
		if (((175 - 52) == (157 - 34)) and v37) then
			v102 = #v101;
		else
			v102 = 1 + 0;
		end
		if (v28.TargetIsValid() or v14:AffectingCombat() or ((1572 - 516) >= (7106 - 3714))) then
			local v171 = 1963 - (556 + 1407);
			while true do
				if ((v171 == (1206 - (741 + 465))) or ((1546 - (170 + 295)) < (567 + 508))) then
					v103 = v10.BossFightRemains(nil, true);
					v104 = v103;
					v171 = 1 + 0;
				end
				if ((v171 == (2 - 1)) or ((870 + 179) >= (2843 + 1589))) then
					if ((v104 == (6292 + 4819)) or ((5998 - (957 + 273)) <= (227 + 619))) then
						v104 = v10.FightRemains(v100, false);
					end
					break;
				end
			end
		end
		if (v14:IsChanneling(v93.FireBreath) or ((1345 + 2013) <= (5410 - 3990))) then
			local v172 = 0 - 0;
			local v173;
			while true do
				if ((v172 == (0 - 0)) or ((18514 - 14775) <= (4785 - (389 + 1391)))) then
					v173 = GetTime() - v14:CastStart();
					if ((v173 >= v14:EmpowerCastTime(v33)) or ((1041 + 618) >= (223 + 1911))) then
						local v188 = 0 - 0;
						while true do
							if ((v188 == (951 - (783 + 168))) or ((10941 - 7681) < (2317 + 38))) then
								v10.EpicSettingsS = v93.FireBreath.ReturnID;
								return "Stopping Fire Breath";
							end
						end
					end
					break;
				end
			end
		end
		if (v14:IsChanneling(v93.DreamBreath) or ((980 - (309 + 2)) == (12968 - 8745))) then
			local v174 = 1212 - (1090 + 122);
			local v175;
			while true do
				if ((v174 == (0 + 0)) or ((5682 - 3990) < (403 + 185))) then
					v175 = GetTime() - v14:CastStart();
					if ((v175 >= v14:EmpowerCastTime(v34)) or ((5915 - (628 + 490)) < (655 + 2996))) then
						v10.EpicSettingsS = v93.DreamBreath.ReturnID;
						return "Stopping DreamBreath";
					end
					break;
				end
			end
		end
		if (v14:IsChanneling(v93.Spiritbloom) or ((10341 - 6164) > (22164 - 17314))) then
			local v176 = 774 - (431 + 343);
			local v177;
			while true do
				if ((v176 == (0 - 0)) or ((1157 - 757) > (878 + 233))) then
					v177 = GetTime() - v14:CastStart();
					if (((391 + 2660) > (2700 - (556 + 1139))) and (v177 >= v14:EmpowerCastTime(v35))) then
						local v191 = 15 - (6 + 9);
						while true do
							if (((677 + 3016) <= (2245 + 2137)) and ((169 - (28 + 141)) == v191)) then
								v10.EpicSettingsS = v93.Spiritbloom.ReturnID;
								return "Stopping Spiritbloom";
							end
						end
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((1272 + 2010) > (5060 - 960))) then
			local v178 = v28.DeadFriendlyUnitsCount();
			if (not v14:AffectingCombat() or ((2536 + 1044) < (4161 - (486 + 831)))) then
				if (((231 - 142) < (15807 - 11317)) and (v178 > (1 + 0))) then
					if (v26(v93.MassReturn, nil, true) or ((15755 - 10772) < (3071 - (668 + 595)))) then
						return "mass_return";
					end
				elseif (((3446 + 383) > (760 + 3009)) and v26(v93.Return, not v15:IsInRange(81 - 51), true)) then
					return "return";
				end
			end
		end
		if (((1775 - (23 + 267)) <= (4848 - (1129 + 815))) and not v14:IsChanneling()) then
			if (((4656 - (371 + 16)) == (6019 - (1326 + 424))) and v14:AffectingCombat()) then
				local v179 = 0 - 0;
				local v180;
				while true do
					if (((1414 - 1027) <= (2900 - (88 + 30))) and (v179 == (771 - (720 + 51)))) then
						v180 = v120();
						if (v180 or ((4224 - 2325) <= (2693 - (421 + 1355)))) then
							return v180;
						end
						break;
					end
				end
			else
				local v181 = v121();
				if (v181 or ((7113 - 2801) <= (431 + 445))) then
					return v181;
				end
			end
		end
	end
	local function v125()
		v21.Print("Preservation Evoker by Epic BoomK");
		EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
	end
	v21.SetAPL(2551 - (286 + 797), v124, v125);
end;
return v0["Epix_Evoker_Preservation.lua"]();

