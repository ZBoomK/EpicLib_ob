local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 683 - (27 + 656);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((31 + 52) > (985 + 795))) then
			return v6(...);
		end
		if (((97 + 449) <= (1994 - 917)) and (v5 == (1911 - (340 + 1571)))) then
			v6 = v0[v4];
			if (not v6 or ((393 + 603) > (6073 - (1733 + 39)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v33 = 1034 - (125 + 909);
	local v34 = 1949 - (1096 + 852);
	local v35 = 1 + 0;
	local v36 = 1 - 0;
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
	local v99 = (v98[13 + 0] and v20(v98[525 - (409 + 103)])) or v20(236 - (46 + 190));
	local v100 = (v98[109 - (51 + 44)] and v20(v98[4 + 10])) or v20(1317 - (1114 + 203));
	local v101;
	local v102;
	local v103;
	local v104 = 11837 - (228 + 498);
	local v105 = 2408 + 8703;
	local v106;
	local v107 = 0 + 0;
	local v108 = 663 - (174 + 489);
	local v109 = 0 - 0;
	local v110 = 1905 - (830 + 1075);
	v10:RegisterForEvent(function()
		local v127 = 524 - (303 + 221);
		while true do
			if (((5339 - (231 + 1038)) > (573 + 114)) and (v127 == (1163 - (171 + 991)))) then
				v100 = (v98[57 - 43] and v20(v98[37 - 23])) or v20(0 - 0);
				break;
			end
			if ((v127 == (0 + 0)) or ((2299 - 1643) >= (9606 - 6276))) then
				v98 = v14:GetEquipment();
				v99 = (v98[20 - 7] and v20(v98[39 - 26])) or v20(1248 - (111 + 1137));
				v127 = 159 - (91 + 67);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (0 + 0)) or ((3015 - (423 + 100)) <= (3 + 332))) then
				v104 = 30764 - 19653;
				v105 = 5792 + 5319;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (((5093 - (326 + 445)) >= (11180 - 8618)) and v94.LivingFlame:IsCastable()) then
			if (v26(v94.LivingFlame, not v15:IsInRange(55 - 30), v106) or ((8489 - 4852) >= (4481 - (530 + 181)))) then
				return "living_flame precombat";
			end
		end
		if (v94.AzureStrike:IsCastable() or ((3260 - (614 + 267)) > (4610 - (19 + 13)))) then
			if (v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike)) or ((785 - 302) > (1730 - 987))) then
				return "azure_strike precombat";
			end
		end
	end
	local function v112()
		if (((7010 - 4556) > (151 + 427)) and v94.ObsidianScales:IsCastable() and v55 and v14:BuffDown(v94.ObsidianScales) and (v14:HealthPercentage() < v56)) then
			if (((1635 - 705) < (9245 - 4787)) and v26(v94.ObsidianScales)) then
				return "obsidian_scales defensives";
			end
		end
		if (((2474 - (1293 + 519)) <= (1982 - 1010)) and v95.Healthstone:IsReady() and v48 and (v14:HealthPercentage() <= v49)) then
			if (((11409 - 7039) == (8356 - 3986)) and v26(v96.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if ((v42 and (v14:HealthPercentage() <= v44)) or ((20534 - 15772) <= (2028 - 1167))) then
			if ((v43 == "Refreshing Healing Potion") or ((748 + 664) == (870 + 3394))) then
				if (v95.RefreshingHealingPotion:IsReady() or ((7360 - 4192) < (498 + 1655))) then
					if (v26(v96.RefreshingHealingPotion, nil, nil, true) or ((1654 + 3322) < (833 + 499))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
		if (((5724 - (709 + 387)) == (6486 - (673 + 1185))) and v94.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v88) and v87) then
			if (v22(v94.RenewingBlaze, nil, nil) or ((156 - 102) == (1268 - 873))) then
				return "RenewingBlaze defensive";
			end
		end
	end
	local function v113()
		local v129 = 0 - 0;
		while true do
			if (((59 + 23) == (62 + 20)) and (v129 == (1 - 0))) then
				if ((v94.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or ((143 + 438) < (561 - 279))) then
					if (v26(v96.CauterizingFlameFocus) or ((9047 - 4438) < (4375 - (446 + 1434)))) then
						return "cauterizing_flame dispel";
					end
				end
				if (((2435 - (1040 + 243)) == (3438 - 2286)) and v94.OppressingRoar:IsReady() and v86 and v28.UnitHasEnrageBuff(v15)) then
					if (((3743 - (559 + 1288)) <= (5353 - (609 + 1322))) and v26(v94.OppressingRoar)) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if ((v129 == (454 - (13 + 441))) or ((3699 - 2709) > (4243 - 2623))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(149 - 119) or not v28.DispellableFriendlyUnit() or ((33 + 844) > (17051 - 12356))) then
					return;
				end
				if (((956 + 1735) >= (812 + 1039)) and v94.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) then
					if (v26(v96.ExpungeFocus) or ((8858 - 5873) >= (2658 + 2198))) then
						return "expunge dispel";
					end
				end
				v129 = 1 - 0;
			end
		end
	end
	local function v114()
		if (((2827 + 1449) >= (665 + 530)) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v146 = 0 + 0;
			local v147;
			while true do
				if (((2714 + 518) <= (4589 + 101)) and (v146 == (434 - (153 + 280)))) then
					v147 = v28.InterruptWithStun(v94.TailSwipe, 23 - 15);
					if (v147 or ((805 + 91) >= (1243 + 1903))) then
						return v147;
					end
					v146 = 2 + 0;
				end
				if (((2778 + 283) >= (2144 + 814)) and (v146 == (0 - 0))) then
					v147 = v28.Interrupt(v94.Quell, 7 + 3, true);
					if (((3854 - (89 + 578)) >= (461 + 183)) and v147) then
						return v147;
					end
					v146 = 1 - 0;
				end
				if (((1693 - (572 + 477)) <= (95 + 609)) and (v146 == (2 + 0))) then
					v147 = v28.Interrupt(v94.Quell, 2 + 8, true, v17, v96.QuellMouseover);
					if (((1044 - (84 + 2)) > (1560 - 613)) and v147) then
						return v147;
					end
					break;
				end
			end
		end
	end
	local function v115()
		local v130 = 0 + 0;
		local v131;
		while true do
			if (((5334 - (497 + 345)) >= (68 + 2586)) and (v130 == (1 + 0))) then
				v131 = v28.HandleBottomTrinket(v97, v39, 1373 - (605 + 728), nil);
				if (((2456 + 986) >= (3341 - 1838)) and v131) then
					return v131;
				end
				break;
			end
			if (((0 + 0) == v130) or ((11720 - 8550) <= (1320 + 144))) then
				v131 = v28.HandleTopTrinket(v97, v39, 110 - 70, nil);
				if (v131 or ((3622 + 1175) == (4877 - (457 + 32)))) then
					return v131;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v116()
		local v132 = 1402 - (832 + 570);
		while true do
			if (((520 + 31) <= (178 + 503)) and (v132 == (3 - 2))) then
				if (((1579 + 1698) > (1203 - (588 + 208))) and v94.Disintegrate:IsReady() and v14:BuffUp(v94.EssenceBurstBuff)) then
					if (((12654 - 7959) >= (3215 - (884 + 916))) and v26(v94.Disintegrate, not v15:IsSpellInRange(v94.Disintegrate), v106)) then
						return "disintegrate damage";
					end
				end
				if (v94.LivingFlame:IsCastable() or ((6724 - 3512) <= (548 + 396))) then
					if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((3749 - (232 + 421)) <= (3687 - (1569 + 320)))) then
						return "living_flame damage";
					end
				end
				v132 = 1 + 1;
			end
			if (((672 + 2865) == (11918 - 8381)) and (v132 == (607 - (316 + 289)))) then
				if (((10043 - 6206) >= (73 + 1497)) and v94.AzureStrike:IsCastable()) then
					if (v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike)) or ((4403 - (666 + 787)) == (4237 - (360 + 65)))) then
						return "azure_strike damage";
					end
				end
				break;
			end
			if (((4414 + 309) >= (2572 - (79 + 175))) and (v132 == (0 - 0))) then
				if ((v94.LivingFlame:IsCastable() and v14:BuffUp(v94.LeapingFlamesBuff)) or ((1582 + 445) > (8741 - 5889))) then
					if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((2187 - 1051) > (5216 - (503 + 396)))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (((4929 - (92 + 89)) == (9210 - 4462)) and v94.FireBreath:IsReady()) then
					local v170 = 0 + 0;
					while true do
						if (((2212 + 1524) <= (18562 - 13822)) and (v170 == (0 + 0))) then
							if ((v103 <= (4 - 2)) or ((2958 + 432) <= (1462 + 1598))) then
								v107 = 2 - 1;
							elseif ((v103 <= (1 + 3)) or ((1522 - 523) > (3937 - (485 + 759)))) then
								v107 = 4 - 2;
							elseif (((1652 - (442 + 747)) < (1736 - (832 + 303))) and (v103 <= (952 - (88 + 858)))) then
								v107 = 1 + 2;
							else
								v107 = 4 + 0;
							end
							v34 = v107;
							v170 = 1 + 0;
						end
						if ((v170 == (790 - (766 + 23))) or ((10776 - 8593) < (939 - 252))) then
							if (((11984 - 7435) == (15439 - 10890)) and v26(v96.FireBreathMacro, not v15:IsInRange(1103 - (1036 + 37)), true, nil, true)) then
								return "fire_breath damage " .. v107;
							end
							break;
						end
					end
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v117()
		if (((9097 - 4425) == (3676 + 996)) and (not v16 or not v16:Exists() or not v16:IsInRange(1510 - (641 + 839)))) then
			return;
		end
		local v133 = v115();
		if (v133 or ((4581 - (910 + 3)) < (1006 - 611))) then
			return v133;
		end
		if ((v94.Stasis:IsReady() and v57 and v28.AreUnitsBelowHealthPercentage(v58, v59)) or ((5850 - (1466 + 218)) == (210 + 245))) then
			if (v26(v94.Stasis) or ((5597 - (556 + 592)) == (947 + 1716))) then
				return "stasis cooldown";
			end
		end
		if ((v94.StasisReactivate:IsReady() and v57 and (v28.AreUnitsBelowHealthPercentage(v58, v59) or (v14:BuffUp(v94.StasisBuff) and (v14:BuffRemains(v94.StasisBuff) < (811 - (329 + 479)))))) or ((5131 - (174 + 680)) < (10270 - 7281))) then
			if (v26(v94.StasisReactivate) or ((1803 - 933) >= (2963 + 1186))) then
				return "stasis_reactivate cooldown";
			end
		end
		if (((2951 - (396 + 343)) < (282 + 2901)) and v94.TipTheScales:IsCastable()) then
			if (((6123 - (29 + 1448)) > (4381 - (135 + 1254))) and v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) then
				v35 = 3 - 2;
				if (((6695 - 5261) < (2070 + 1036)) and v26(v96.TipTheScalesDreamBreath)) then
					return "dream_breath cooldown";
				end
			elseif (((2313 - (389 + 1138)) < (3597 - (102 + 472))) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
				local v195 = 0 + 0;
				while true do
					if (((0 + 0) == v195) or ((2277 + 165) < (1619 - (320 + 1225)))) then
						v36 = 5 - 2;
						if (((2775 + 1760) == (5999 - (157 + 1307))) and v26(v96.TipTheScalesSpiritbloom)) then
							return "spirit_bloom cooldown";
						end
						break;
					end
				end
			end
		end
		if ((v94.DreamFlight:IsCastable() and (v91 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v92, v93)) or ((4868 - (821 + 1038)) <= (5251 - 3146))) then
			if (((201 + 1629) < (6516 - 2847)) and v26(v96.DreamFlightCursor)) then
				return "Dream_Flight cooldown";
			end
		end
		if ((v94.DreamFlight:IsCastable() and (v91 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v92, v93)) or ((533 + 897) >= (8952 - 5340))) then
			if (((3709 - (834 + 192)) >= (157 + 2303)) and v26(v94.DreamFlight)) then
				return "Dream_Flight cooldown";
			end
		end
		if ((v94.Rewind:IsCastable() and v66 and v28.AreUnitsBelowHealthPercentage(v67, v68)) or ((464 + 1340) >= (71 + 3204))) then
			if (v26(v94.Rewind) or ((2194 - 777) > (3933 - (300 + 4)))) then
				return "rewind cooldown";
			end
		end
		if (((1281 + 3514) > (1052 - 650)) and v94.TimeDilation:IsCastable() and v69 and (v16:HealthPercentage() <= v70)) then
			if (((5175 - (112 + 250)) > (1422 + 2143)) and v26(v96.TimeDilationFocus)) then
				return "time_dilation cooldown";
			end
		end
		if (((9800 - 5888) == (2242 + 1670)) and v94.FireBreath:IsReady()) then
			local v148 = 0 + 0;
			while true do
				if (((2110 + 711) <= (2392 + 2432)) and (v148 == (1 + 0))) then
					if (((3152 - (1001 + 413)) <= (4894 - 2699)) and v26(v96.FireBreathMacro, not v15:IsInRange(912 - (244 + 638)), true, nil, true)) then
						return "fire_breath cds " .. v107;
					end
					break;
				end
				if (((734 - (627 + 66)) <= (8992 - 5974)) and (v148 == (602 - (512 + 90)))) then
					if (((4051 - (1665 + 241)) <= (4821 - (373 + 344))) and (v103 <= (1 + 1))) then
						v107 = 1 + 0;
					elseif (((7092 - 4403) < (8198 - 3353)) and (v103 <= (1103 - (35 + 1064)))) then
						v107 = 2 + 0;
					elseif ((v103 <= (12 - 6)) or ((10 + 2312) > (3858 - (298 + 938)))) then
						v107 = 1262 - (233 + 1026);
					else
						v107 = 1670 - (636 + 1030);
					end
					v34 = v107;
					v148 = 1 + 0;
				end
			end
		end
	end
	local function v118()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (1 + 1)) or ((307 + 4227) == (2303 - (55 + 166)))) then
				if ((v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) or ((305 + 1266) > (188 + 1679))) then
					local v171 = 0 - 0;
					while true do
						if ((v171 == (297 - (36 + 261))) or ((4641 - 1987) >= (4364 - (34 + 1334)))) then
							if (((1530 + 2448) > (1635 + 469)) and (v110 <= (1285 - (1035 + 248)))) then
								v108 = 22 - (20 + 1);
							else
								v108 = 2 + 0;
							end
							v35 = v108;
							v171 = 320 - (134 + 185);
						end
						if (((4128 - (549 + 584)) > (2226 - (314 + 371))) and (v171 == (3 - 2))) then
							if (((4217 - (478 + 490)) > (505 + 448)) and v26(v96.DreamBreathMacro, nil, true)) then
								return "dream_breath aoe_healing";
							end
							break;
						end
					end
				end
				if ((v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) or ((4445 - (786 + 386)) > (14811 - 10238))) then
					local v172 = 1379 - (1055 + 324);
					while true do
						if ((v172 == (1341 - (1093 + 247))) or ((2801 + 350) < (136 + 1148))) then
							if (v26(v96.SpiritbloomFocus, nil, true) or ((7344 - 5494) == (5188 - 3659))) then
								return "spirit_bloom aoe_healing";
							end
							break;
						end
						if (((2336 - 1515) < (5334 - 3211)) and (v172 == (0 + 0))) then
							if (((3474 - 2572) < (8013 - 5688)) and (v110 > (2 + 0))) then
								v109 = 7 - 4;
							else
								v109 = 689 - (364 + 324);
							end
							v36 = 7 - 4;
							v172 = 2 - 1;
						end
					end
				end
				v134 = 1 + 2;
			end
			if (((3590 - 2732) <= (4743 - 1781)) and (v134 == (0 - 0))) then
				if ((v94.EmeraldBlossom:IsCastable() and v73 and v28.AreUnitsBelowHealthPercentage(v74, v75)) or ((5214 - (1249 + 19)) < (1163 + 125))) then
					if (v26(v96.EmeraldBlossomFocus) or ((12619 - 9377) == (1653 - (686 + 400)))) then
						return "emerald_blossom aoe_healing";
					end
				end
				if ((v71 == "Player Only") or ((665 + 182) >= (1492 - (73 + 156)))) then
					if ((v94.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v72)) or ((11 + 2242) == (2662 - (721 + 90)))) then
						if (v22(v96.VerdantEmbracePlayer, nil) or ((24 + 2063) > (7701 - 5329))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 471 - (224 + 246);
			end
			if ((v134 == (1 - 0)) or ((8184 - 3739) < (753 + 3396))) then
				if ((v71 == "Everyone") or ((44 + 1774) == (63 + 22))) then
					if (((1252 - 622) < (7078 - 4951)) and v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72)) then
						if (v22(v96.VerdantEmbraceFocus, nil) or ((2451 - (203 + 310)) == (4507 - (1238 + 755)))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				if (((298 + 3957) >= (1589 - (709 + 825))) and (v71 == "Not Tank")) then
					if (((5525 - 2526) > (1683 - 527)) and v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72) and (v28.UnitGroupRole(v16) ~= "TANK")) then
						if (((3214 - (196 + 668)) > (4560 - 3405)) and v22(v96.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 3 - 1;
			end
			if (((4862 - (171 + 662)) <= (4946 - (4 + 89))) and (v134 == (10 - 7))) then
				if ((v94.LivingFlame:IsCastable() and v76 and v14:BuffUp(v94.LeapingFlamesBuff) and (v16:HealthPercentage() <= v77)) or ((188 + 328) > (15082 - 11648))) then
					if (((1587 + 2459) >= (4519 - (35 + 1451))) and v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106)) then
						return "living_flame_leaping_flames aoe_healing";
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v135 = 1453 - (28 + 1425);
		while true do
			if (((1995 - (941 + 1052)) == v135) or ((2608 + 111) <= (2961 - (822 + 692)))) then
				if ((v94.LivingFlame:IsReady() and v76 and (v16:HealthPercentage() <= v77)) or ((5901 - 1767) < (1850 + 2076))) then
					if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or ((461 - (45 + 252)) >= (2756 + 29))) then
						return "living_flame st_healing";
					end
				end
				break;
			end
			if ((v135 == (0 + 0)) or ((1277 - 752) == (2542 - (114 + 319)))) then
				if (((46 - 13) == (41 - 8)) and v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion) < (1 + 0)) and (v16:HealthPercentage() <= v79)) then
					if (((4549 - 1495) <= (8412 - 4397)) and v26(v96.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				if (((3834 - (556 + 1407)) < (4588 - (741 + 465))) and v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion, true, false) < (466 - (170 + 295))) and (v16:HealthPercentage() <= v80)) then
					if (((682 + 611) <= (1990 + 176)) and v26(v96.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v135 = 2 - 1;
			end
			if ((v135 == (1 + 0)) or ((1654 + 925) < (70 + 53))) then
				if ((v94.TemporalAnomaly:IsReady() and v81 and v28.AreUnitsBelowHealthPercentage(v82, v83)) or ((2076 - (957 + 273)) >= (634 + 1734))) then
					if (v26(v94.TemporalAnomaly, not v16:IsInRange(13 + 17), v106) or ((15287 - 11275) <= (8849 - 5491))) then
						return "temporal_anomaly st_healing";
					end
				end
				if (((4563 - 3069) <= (14879 - 11874)) and v94.Echo:IsReady() and v84 and not v16:BuffUp(v94.Echo) and (v16:HealthPercentage() <= v85)) then
					if (v26(v96.EchoFocus) or ((4891 - (389 + 1391)) == (1339 + 795))) then
						return "echo st_healing";
					end
				end
				v135 = 1 + 1;
			end
		end
	end
	local function v120()
		local v136 = 0 - 0;
		local v137;
		while true do
			if (((3306 - (783 + 168)) == (7903 - 5548)) and (v136 == (2 + 0))) then
				if (v137 or ((899 - (309 + 2)) <= (1326 - 894))) then
					return v137;
				end
				break;
			end
			if (((6009 - (1090 + 122)) >= (1263 + 2632)) and (v136 == (0 - 0))) then
				if (((2448 + 1129) == (4695 - (628 + 490))) and (not v16 or not v16:Exists() or not v16:IsInRange(6 + 24))) then
					return;
				end
				v137 = v118();
				v136 = 2 - 1;
			end
			if (((17338 - 13544) > (4467 - (431 + 343))) and (v136 == (1 - 0))) then
				if (v137 or ((3688 - 2413) == (3240 + 860))) then
					return v137;
				end
				v137 = v119();
				v136 = 1 + 1;
			end
		end
	end
	local function v121()
		local v138 = 1695 - (556 + 1139);
		local v139;
		while true do
			if ((v138 == (17 - (6 + 9))) or ((292 + 1299) >= (1834 + 1746))) then
				if (((1152 - (28 + 141)) <= (701 + 1107)) and v139) then
					return v139;
				end
				v139 = v114();
				v138 = 3 - 0;
			end
			if ((v138 == (0 + 0)) or ((3467 - (486 + 831)) <= (3114 - 1917))) then
				if (((13268 - 9499) >= (222 + 951)) and (v47 or v46)) then
					local v173 = 0 - 0;
					local v174;
					while true do
						if (((2748 - (668 + 595)) == (1337 + 148)) and ((0 + 0) == v173)) then
							v174 = v113();
							if (v174 or ((9040 - 5725) <= (3072 - (23 + 267)))) then
								return v174;
							end
							break;
						end
					end
				end
				v139 = v112();
				v138 = 1945 - (1129 + 815);
			end
			if (((391 - (371 + 16)) == v138) or ((2626 - (1326 + 424)) >= (5613 - 2649))) then
				if (v139 or ((8156 - 5924) > (2615 - (88 + 30)))) then
					return v139;
				end
				if (v28.TargetIsValid() or ((2881 - (720 + 51)) <= (738 - 406))) then
					local v175 = 1776 - (421 + 1355);
					local v176;
					while true do
						if (((6080 - 2394) > (1559 + 1613)) and (v175 == (1083 - (286 + 797)))) then
							v176 = v116();
							if (v176 or ((16355 - 11881) < (1358 - 538))) then
								return v176;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4718 - (397 + 42)) >= (901 + 1981)) and (v138 == (803 - (24 + 776)))) then
				if (v139 or ((3125 - 1096) >= (4306 - (222 + 563)))) then
					return v139;
				end
				v139 = v120();
				v138 = 8 - 4;
			end
			if ((v138 == (1 + 0)) or ((2227 - (23 + 167)) >= (6440 - (690 + 1108)))) then
				if (((621 + 1099) < (3678 + 780)) and v139) then
					return v139;
				end
				v139 = v117();
				v138 = 850 - (40 + 808);
			end
		end
	end
	local function v122()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (0 - 0)) or ((417 + 19) > (1599 + 1422))) then
				if (((391 + 322) <= (1418 - (47 + 524))) and (v47 or v46)) then
					local v177 = 0 + 0;
					local v178;
					while true do
						if (((5887 - 3733) <= (6027 - 1996)) and (v177 == (0 - 0))) then
							v178 = v113();
							if (((6341 - (1165 + 561)) == (138 + 4477)) and v178) then
								return v178;
							end
							break;
						end
					end
				end
				if (v37 or ((11738 - 7948) == (191 + 309))) then
					local v179 = 479 - (341 + 138);
					local v180;
					while true do
						if (((25 + 64) < (455 - 234)) and ((327 - (89 + 237)) == v179)) then
							if (((6607 - 4553) >= (2991 - 1570)) and v45 and v94.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v94.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v94.BlessingoftheBronzeBuff))) then
								if (((1573 - (581 + 300)) < (4278 - (855 + 365))) and v26(v94.BlessingoftheBronze)) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (v28.TargetIsValid() or ((7728 - 4474) == (541 + 1114))) then
								local v202 = v111();
								if (v202 or ((2531 - (1030 + 205)) == (4610 + 300))) then
									return v202;
								end
							end
							break;
						end
						if (((3134 + 234) == (3654 - (156 + 130))) and (v179 == (0 - 0))) then
							v180 = v120();
							if (((4454 - 1811) < (7813 - 3998)) and v180) then
								return v180;
							end
							v179 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v141 = 0 + 0;
		while true do
			if (((1982 - (10 + 59)) > (140 + 353)) and (v141 == (34 - 27))) then
				v83 = EpicSettings.Settings['TemporalAnomalyGroup'] or (1163 - (671 + 492));
				v84 = EpicSettings.Settings['UseEcho'];
				v85 = EpicSettings.Settings['EchoHP'] or (0 + 0);
				v86 = EpicSettings.Settings['UseOppressingRoar'];
				v87 = EpicSettings.Settings['UseRenewingBlaze'];
				v88 = EpicSettings.Settings['RenewingBlazeHP'] or (1215 - (369 + 846));
				v141 = 3 + 5;
			end
			if (((4058 + 697) > (5373 - (1036 + 909))) and (v141 == (2 + 0))) then
				v53 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v54 = EpicSettings.Settings['InterruptThreshold'] or (203 - (11 + 192));
				v55 = EpicSettings.Settings['UseObsidianScales'];
				v56 = EpicSettings.Settings['ObsidianScalesHP'] or (0 + 0);
				v57 = EpicSettings.Settings['UseStasis'];
				v58 = EpicSettings.Settings['StasisHP'] or (175 - (135 + 40));
				v141 = 6 - 3;
			end
			if (((833 + 548) <= (5218 - 2849)) and (v141 == (1 - 0))) then
				v47 = EpicSettings.Settings['DispelBuffs'] or (176 - (50 + 126));
				v48 = EpicSettings.Settings['UseHealthstone'];
				v49 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v50 = EpicSettings.Settings['HandleCharredTreant'] or (0 + 0);
				v51 = EpicSettings.Settings['HandleCharredBrambles'] or (1413 - (1233 + 180));
				v52 = EpicSettings.Settings['InterruptWithStun'] or (969 - (522 + 447));
				v141 = 1423 - (107 + 1314);
			end
			if ((v141 == (2 + 1)) or ((14756 - 9913) == (1735 + 2349))) then
				v59 = EpicSettings.Settings['StasisGroup'] or (0 - 0);
				v60 = EpicSettings.Settings['UseDreamBreath'];
				v61 = EpicSettings.Settings['DreamBreathHP'] or (0 - 0);
				v62 = EpicSettings.Settings['DreamBreathGroup'] or (1910 - (716 + 1194));
				v63 = EpicSettings.Settings['UseSpiritbloom'];
				v64 = EpicSettings.Settings['SpiritbloomHP'] or (0 + 0);
				v141 = 1 + 3;
			end
			if (((5172 - (74 + 429)) > (699 - 336)) and (v141 == (0 + 0))) then
				v41 = EpicSettings.Settings['UseRacials'];
				v42 = EpicSettings.Settings['UseHealingPotion'];
				v43 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v44 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v45 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 - 0);
				v46 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
				v141 = 434 - (279 + 154);
			end
			if (((784 - (454 + 324)) == v141) or ((1477 + 400) >= (3155 - (12 + 5)))) then
				v77 = EpicSettings.Settings['LivingFlameHP'] or (0 + 0);
				v78 = EpicSettings.Settings['UseReversion'];
				v79 = EpicSettings.Settings['ReversionHP'] or (0 - 0);
				v80 = EpicSettings.Settings['ReversionTankHP'] or (0 + 0);
				v81 = EpicSettings.Settings['UseTemporalAnomaly'];
				v82 = EpicSettings.Settings['TemporalAnomalyHP'] or (1093 - (277 + 816));
				v141 = 29 - 22;
			end
			if (((5925 - (1058 + 125)) >= (680 + 2946)) and (v141 == (983 - (815 + 160)))) then
				v89 = EpicSettings.Settings['UseHover'];
				v90 = EpicSettings.Settings['HoverTime'] or (0 - 0);
				break;
			end
			if ((v141 == (11 - 6)) or ((1084 + 3456) == (2677 - 1761))) then
				v71 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v72 = EpicSettings.Settings['VerdantEmbraceHP'] or (1898 - (41 + 1857));
				v73 = EpicSettings.Settings['UseEmeraldBlossom'];
				v74 = EpicSettings.Settings['EmeraldBlossomHP'] or (1893 - (1222 + 671));
				v75 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['UseLivingFlame'];
				v141 = 7 - 1;
			end
			if ((v141 == (1186 - (229 + 953))) or ((2930 - (1111 + 663)) > (5924 - (874 + 705)))) then
				v65 = EpicSettings.Settings['SpiritbloomGroup'] or (0 + 0);
				v66 = EpicSettings.Settings['UseRewind'];
				v67 = EpicSettings.Settings['RewindHP'] or (0 + 0);
				v68 = EpicSettings.Settings['RewindGroup'] or (0 - 0);
				v69 = EpicSettings.Settings['UseTimeDilation'];
				v70 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
				v141 = 684 - (642 + 37);
			end
		end
	end
	local function v124()
		local v142 = 0 + 0;
		while true do
			if (((358 + 1879) < (10667 - 6418)) and (v142 == (454 - (233 + 221)))) then
				v91 = EpicSettings.Settings['DreamFlightUsage'] or "";
				v92 = EpicSettings.Settings['DreamFlightHP'] or (0 - 0);
				v142 = 1 + 0;
			end
			if ((v142 == (1542 - (718 + 823))) or ((1689 + 994) < (828 - (266 + 539)))) then
				v93 = EpicSettings.Settings['DreamFlightGroup'] or (0 - 0);
				break;
			end
		end
	end
	local function v125()
		local v143 = 1225 - (636 + 589);
		while true do
			if (((1654 - 957) <= (1703 - 877)) and ((2 + 0) == v143)) then
				if (((402 + 703) <= (2191 - (657 + 358))) and not v14:IsMoving()) then
					v33 = GetTime();
				end
				if (((8946 - 5567) <= (8684 - 4872)) and (v14:AffectingCombat() or v46)) then
					local v181 = 1187 - (1151 + 36);
					local v182;
					local v183;
					while true do
						if ((v181 == (1 + 0)) or ((208 + 580) >= (4826 - 3210))) then
							if (((3686 - (1552 + 280)) <= (4213 - (64 + 770))) and v183) then
								return v183;
							end
							break;
						end
						if (((3089 + 1460) == (10326 - 5777)) and (v181 == (0 + 0))) then
							v182 = v46 and v94.Expunge:IsReady();
							v183 = v28.FocusUnit(v182, v96, 1273 - (157 + 1086), 40 - 20);
							v181 = 4 - 3;
						end
					end
				end
				if (v50 or ((4635 - 1613) >= (4127 - 1103))) then
					local v184 = 819 - (599 + 220);
					local v185;
					while true do
						if (((9598 - 4778) > (4129 - (1813 + 118))) and (v184 == (0 + 0))) then
							v185 = v28.HandleCharredTreant(v94.Echo, v96.EchoMouseover, 1257 - (841 + 376));
							if (v185 or ((1486 - 425) >= (1137 + 3754))) then
								return v185;
							end
							v184 = 2 - 1;
						end
						if (((2223 - (464 + 395)) <= (11479 - 7006)) and (v184 == (1 + 0))) then
							v185 = v28.HandleCharredTreant(v94.LivingFlame, v96.LivingFlameMouseover, 877 - (467 + 370), true);
							if (v185 or ((7428 - 3833) <= (3 + 0))) then
								return v185;
							end
							break;
						end
					end
				end
				if (v51 or ((16015 - 11343) == (601 + 3251))) then
					local v186 = v28.HandleCharredBrambles(v94.Echo, v96.EchoMouseover, 93 - 53);
					if (((2079 - (150 + 370)) == (2841 - (74 + 1208))) and v186) then
						return v186;
					end
					local v186 = v28.HandleCharredBrambles(v94.LivingFlame, v96.LivingFlameMouseover, 98 - 58, true);
					if (v186 or ((8308 - 6556) <= (561 + 227))) then
						return v186;
					end
				end
				v143 = 393 - (14 + 376);
			end
			if ((v143 == (8 - 3)) or ((2529 + 1378) == (156 + 21))) then
				if (((3310 + 160) > (1626 - 1071)) and v14:IsChanneling(v94.DreamBreath)) then
					local v187 = 0 + 0;
					local v188;
					while true do
						if ((v187 == (78 - (23 + 55))) or ((2303 - 1331) == (431 + 214))) then
							v188 = GetTime() - v14:CastStart();
							if (((2858 + 324) >= (3279 - 1164)) and (v188 >= v14:EmpowerCastTime(v35))) then
								v10.EpicSettingsS = v94.DreamBreath.ReturnID;
								return "Stopping DreamBreath";
							end
							break;
						end
					end
				end
				if (((1225 + 2668) < (5330 - (652 + 249))) and v14:IsChanneling(v94.Spiritbloom)) then
					local v189 = GetTime() - v14:CastStart();
					if ((v189 >= v14:EmpowerCastTime(v36)) or ((7672 - 4805) < (3773 - (708 + 1160)))) then
						v10.EpicSettingsS = v94.Spiritbloom.ReturnID;
						return "Stopping Spiritbloom";
					end
				end
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((4875 - 3079) >= (7385 - 3334))) then
					local v190 = 27 - (10 + 17);
					local v191;
					while true do
						if (((364 + 1255) <= (5488 - (1400 + 332))) and (v190 == (0 - 0))) then
							v191 = v28.DeadFriendlyUnitsCount();
							if (((2512 - (242 + 1666)) == (259 + 345)) and not v14:AffectingCombat()) then
								if ((v191 > (1 + 0)) or ((3822 + 662) == (1840 - (850 + 90)))) then
									if (v26(v94.MassReturn, nil, true) or ((7809 - 3350) <= (2503 - (360 + 1030)))) then
										return "mass_return";
									end
								elseif (((3215 + 417) > (9590 - 6192)) and v26(v94.Return, not v15:IsInRange(41 - 11), true)) then
									return "return";
								end
							end
							break;
						end
					end
				end
				if (((5743 - (909 + 752)) <= (6140 - (109 + 1114))) and not v14:IsChanneling()) then
					if (((8846 - 4014) >= (540 + 846)) and v14:AffectingCombat()) then
						local v198 = 242 - (6 + 236);
						local v199;
						while true do
							if (((87 + 50) == (111 + 26)) and (v198 == (0 - 0))) then
								v199 = v121();
								if (v199 or ((2742 - 1172) >= (5465 - (1076 + 57)))) then
									return v199;
								end
								break;
							end
						end
					else
						local v200 = 0 + 0;
						local v201;
						while true do
							if ((v200 == (689 - (579 + 110))) or ((321 + 3743) <= (1609 + 210))) then
								v201 = v122();
								if (v201 or ((2647 + 2339) < (1981 - (174 + 233)))) then
									return v201;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((12363 - 7937) > (301 - 129)) and (v143 == (0 + 0))) then
				v123();
				v124();
				if (((1760 - (663 + 511)) > (406 + 49)) and v14:IsDeadOrGhost()) then
					return;
				end
				v37 = EpicSettings.Toggles['ooc'];
				v143 = 1 + 0;
			end
			if (((2546 - 1720) == (501 + 325)) and (v143 == (9 - 5))) then
				v102 = v15:GetEnemiesInSplashRange(19 - 11);
				if (v38 or ((1918 + 2101) > (8643 - 4202))) then
					v103 = #v102;
				else
					v103 = 1 + 0;
				end
				if (((185 + 1832) < (4983 - (478 + 244))) and (v28.TargetIsValid() or v14:AffectingCombat())) then
					local v192 = 517 - (440 + 77);
					while true do
						if (((2145 + 2571) > (292 - 212)) and (v192 == (1557 - (655 + 901)))) then
							if ((v105 == (2061 + 9050)) or ((2685 + 822) == (2210 + 1062))) then
								v105 = v10.FightRemains(v101, false);
							end
							break;
						end
						if ((v192 == (0 - 0)) or ((2321 - (695 + 750)) >= (10500 - 7425))) then
							v104 = v10.BossFightRemains(nil, true);
							v105 = v104;
							v192 = 1 - 0;
						end
					end
				end
				if (((17502 - 13150) > (2905 - (285 + 66))) and v14:IsChanneling(v94.FireBreath)) then
					local v193 = 0 - 0;
					local v194;
					while true do
						if ((v193 == (1310 - (682 + 628))) or ((711 + 3695) < (4342 - (176 + 123)))) then
							v194 = GetTime() - v14:CastStart();
							if ((v194 >= v14:EmpowerCastTime(v34)) or ((791 + 1098) >= (2454 + 929))) then
								local v205 = 269 - (239 + 30);
								while true do
									if (((515 + 1377) <= (2628 + 106)) and (v205 == (0 - 0))) then
										v10.EpicSettingsS = v94.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				v143 = 15 - 10;
			end
			if (((2238 - (306 + 9)) < (7739 - 5521)) and ((1 + 2) == v143)) then
				if (((1334 + 839) > (183 + 196)) and v89 and (v37 or v14:AffectingCombat())) then
					if (((GetTime() - v33) > v90) or ((7409 - 4818) == (4784 - (1140 + 235)))) then
						if (((2873 + 1641) > (3049 + 275)) and v94.Hover:IsReady() and v14:BuffDown(v94.Hover)) then
							if (v26(v94.Hover) or ((54 + 154) >= (4880 - (33 + 19)))) then
								return "hover main 2";
							end
						end
					end
				end
				v106 = v14:BuffRemains(v94.HoverBuff) < (1 + 1);
				v110 = v28.FriendlyUnitsBelowHealthPercentageCount(254 - 169);
				v101 = v14:GetEnemiesInRange(12 + 13);
				v143 = 7 - 3;
			end
			if ((v143 == (1 + 0)) or ((2272 - (586 + 103)) > (325 + 3242))) then
				v38 = EpicSettings.Toggles['aoe'];
				v39 = EpicSettings.Toggles['cds'];
				v40 = EpicSettings.Toggles['dispel'];
				if (v14:IsMounted() or ((4042 - 2729) == (2282 - (1309 + 179)))) then
					return;
				end
				v143 = 2 - 0;
			end
		end
	end
	local function v126()
		v21.Print("Preservation Evoker by Epic BoomK");
		EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
		v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
	end
	v21.SetAPL(639 + 829, v125, v126);
end;
return v0["Epix_Evoker_Preservation.lua"]();

