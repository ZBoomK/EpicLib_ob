local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3141 - 1853) > (1536 - (175 + 110))) and not v5) then
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
	local v31 = 0 - 0;
	local v32 = 4 - 3;
	local v33 = 1797 - (503 + 1293);
	local v34 = 2 - 1;
	local v35 = false;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v92 = v18.Evoker.Preservation;
	local v93 = v19.Evoker.Preservation;
	local v94 = v26.Evoker.Preservation;
	local v95 = {};
	local v96 = v13:GetEquipment();
	local v97 = (v96[10 + 3] and v19(v96[1074 - (810 + 251)])) or v19(0 + 0);
	local v98 = (v96[5 + 9] and v19(v96[13 + 1])) or v19(533 - (43 + 490));
	local v99;
	local v100;
	local v101;
	local v102 = 11844 - (711 + 22);
	local v103 = 42979 - 31868;
	local v104;
	local v105 = 859 - (240 + 619);
	local v106 = 0 + 0;
	local v107 = 0 - 0;
	local v108 = 0 + 0;
	v9:RegisterForEvent(function()
		v96 = v13:GetEquipment();
		v97 = (v96[1757 - (1344 + 400)] and v19(v96[418 - (255 + 150)])) or v19(0 + 0);
		v98 = (v96[8 + 6] and v19(v96[59 - 45])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v102 = 12850 - (404 + 1335);
		v103 = 11517 - (183 + 223);
	end, "PLAYER_REGEN_ENABLED");
	local function v109()
		if (v92.LivingFlame:IsCastable() or ((5491 - 978) < (2221 + 1131))) then
			if (v25(v92.LivingFlame, not v14:IsInRange(9 + 16), v104) or ((2402 - (10 + 327)) >= (2226 + 970))) then
				return "living_flame precombat";
			end
		end
		if (v92.AzureStrike:IsCastable() or ((4714 - (118 + 220)) <= (494 + 987))) then
			if (v25(v92.AzureStrike, not v14:IsSpellInRange(v92.AzureStrike)) or ((3841 - (108 + 341)) >= (2130 + 2611))) then
				return "azure_strike precombat";
			end
		end
	end
	local function v110()
		local v125 = 0 - 0;
		while true do
			if (((4818 - (711 + 782)) >= (4128 - 1974)) and (v125 == (470 - (270 + 199)))) then
				if ((v40 and (v13:HealthPercentage() <= v42)) or ((420 + 875) >= (5052 - (580 + 1239)))) then
					if (((13011 - 8634) > (1571 + 71)) and (v41 == "Refreshing Healing Potion")) then
						if (((170 + 4553) > (591 + 765)) and v93.RefreshingHealingPotion:IsReady()) then
							if (v25(v94.RefreshingHealingPotion, nil, nil, true) or ((10798 - 6662) <= (2133 + 1300))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				if (((5412 - (645 + 522)) <= (6421 - (1010 + 780))) and v92.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v86) and v85) then
					if (((4274 + 2) >= (18645 - 14731)) and v21(v92.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze defensive";
					end
				end
				break;
			end
			if (((580 - 382) <= (6201 - (1045 + 791))) and (v125 == (0 - 0))) then
				if (((7301 - 2519) > (5181 - (351 + 154))) and v92.ObsidianScales:IsCastable() and v53 and v13:BuffDown(v92.ObsidianScales) and (v13:HealthPercentage() < v54)) then
					if (((6438 - (1281 + 293)) > (2463 - (28 + 238))) and v25(v92.ObsidianScales)) then
						return "obsidian_scales defensives";
					end
				end
				if ((v93.Healthstone:IsReady() and v46 and (v13:HealthPercentage() <= v47)) or ((8267 - 4567) == (4066 - (1381 + 178)))) then
					if (((4197 + 277) >= (221 + 53)) and v25(v94.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v111()
		if (not v15 or not v15:Exists() or not (v27.UnitHasDispellableDebuffByPlayer(v15) or v27.DispellableFriendlyUnit(86 - 61)) or ((982 + 912) <= (1876 - (381 + 89)))) then
			return;
		end
		if (((1395 + 177) >= (1036 + 495)) and v92.Expunge:IsReady() and (v27.UnitHasMagicDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) then
			if (v25(v94.ExpungeFocus) or ((8028 - 3341) < (5698 - (1074 + 82)))) then
				return "expunge dispel";
			end
		end
		if (((7211 - 3920) > (3451 - (214 + 1570))) and v92.CauterizingFlame:IsReady() and (v27.UnitHasCurseDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) then
			if (v25(v94.CauterizingFlameFocus) or ((2328 - (990 + 465)) == (839 + 1195))) then
				return "cauterizing_flame dispel";
			end
		end
		if ((v92.OppressingRoar:IsReady() and v84 and v27.UnitHasEnrageBuff(v14)) or ((1226 + 1590) < (11 + 0))) then
			if (((14557 - 10858) < (6432 - (1668 + 58))) and v25(v92.OppressingRoar)) then
				return "Oppressing Roar dispel";
			end
		end
	end
	local function v112()
		if (((3272 - (512 + 114)) >= (2283 - 1407)) and not v13:IsCasting() and not v13:IsChanneling()) then
			local v137 = v27.Interrupt(v92.Quell, 20 - 10, true);
			if (((2136 - 1522) <= (1482 + 1702)) and v137) then
				return v137;
			end
			v137 = v27.InterruptWithStun(v92.TailSwipe, 2 + 6);
			if (((2718 + 408) == (10543 - 7417)) and v137) then
				return v137;
			end
			v137 = v27.Interrupt(v92.Quell, 2004 - (109 + 1885), true, v16, v94.QuellMouseover);
			if (v137 or ((3656 - (1269 + 200)) >= (9494 - 4540))) then
				return v137;
			end
		end
	end
	local function v113()
		local v126 = v27.HandleTopTrinket(v95, v37, 855 - (98 + 717), nil);
		if (v126 or ((4703 - (802 + 24)) == (6165 - 2590))) then
			return v126;
		end
		local v126 = v27.HandleBottomTrinket(v95, v37, 50 - 10, nil);
		if (((105 + 602) > (486 + 146)) and v126) then
			return v126;
		end
	end
	local function v114()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (1 + 0)) or ((1518 - 972) >= (8950 - 6266))) then
				if (((524 + 941) <= (1751 + 2550)) and v92.Disintegrate:IsReady() and v13:BuffUp(v92.EssenceBurstBuff)) then
					if (((1406 + 298) > (1037 + 388)) and v25(v92.Disintegrate, not v14:IsSpellInRange(v92.Disintegrate), v104)) then
						return "disintegrate damage";
					end
				end
				if (v92.LivingFlame:IsCastable() or ((321 + 366) == (5667 - (797 + 636)))) then
					if (v25(v92.LivingFlame, not v14:IsSpellInRange(v92.LivingFlame), v104) or ((16168 - 12838) < (3048 - (1427 + 192)))) then
						return "living_flame damage";
					end
				end
				v127 = 1 + 1;
			end
			if (((2662 - 1515) >= (302 + 33)) and (v127 == (0 + 0))) then
				if (((3761 - (192 + 134)) > (3373 - (316 + 960))) and v92.LivingFlame:IsCastable() and v13:BuffUp(v92.LeapingFlamesBuff)) then
					if (v25(v92.LivingFlame, not v14:IsSpellInRange(v92.LivingFlame), v104) or ((2098 + 1672) >= (3119 + 922))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (v92.FireBreath:IsReady() or ((3505 + 286) <= (6158 - 4547))) then
					if ((v101 <= (553 - (83 + 468))) or ((6384 - (1202 + 604)) <= (9373 - 7365))) then
						v105 = 1 - 0;
					elseif (((3114 - 1989) <= (2401 - (45 + 280))) and (v101 <= (4 + 0))) then
						v105 = 2 + 0;
					elseif ((v101 <= (3 + 3)) or ((412 + 331) >= (774 + 3625))) then
						v105 = 5 - 2;
					else
						v105 = 1915 - (340 + 1571);
					end
					v32 = v105;
					if (((456 + 699) < (3445 - (1733 + 39))) and v25(v94.FireBreathMacro, not v14:IsInRange(82 - 52), true, nil, true)) then
						return "fire_breath damage " .. v105;
					end
				end
				v127 = 1035 - (125 + 909);
			end
			if ((v127 == (1950 - (1096 + 852))) or ((1043 + 1281) <= (825 - 247))) then
				if (((3654 + 113) == (4279 - (409 + 103))) and v92.AzureStrike:IsCastable()) then
					if (((4325 - (46 + 190)) == (4184 - (51 + 44))) and v25(v92.AzureStrike, not v14:IsSpellInRange(v92.AzureStrike))) then
						return "azure_strike damage";
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v128 = v113();
		if (((1258 + 3200) >= (2991 - (1114 + 203))) and v128) then
			return v128;
		end
		if (((1698 - (228 + 498)) <= (308 + 1110)) and v92.Stasis:IsReady() and v55 and v27.AreUnitsBelowHealthPercentage(v56, v57, v92.Echo)) then
			if (v25(v92.Stasis) or ((2729 + 2209) < (5425 - (174 + 489)))) then
				return "stasis cooldown";
			end
		end
		if ((v92.StasisReactivate:IsReady() and v55 and (v27.AreUnitsBelowHealthPercentage(v56, v57, v92.Echo) or (v13:BuffUp(v92.StasisBuff) and (v13:BuffRemains(v92.StasisBuff) < (7 - 4))))) or ((4409 - (830 + 1075)) > (4788 - (303 + 221)))) then
			if (((3422 - (231 + 1038)) == (1795 + 358)) and v25(v92.StasisReactivate)) then
				return "stasis_reactivate cooldown";
			end
		end
		if (v92.TipTheScales:IsCastable() or ((1669 - (171 + 991)) >= (10677 - 8086))) then
			if (((12032 - 7551) == (11182 - 6701)) and v92.DreamBreath:IsReady() and v58 and v27.AreUnitsBelowHealthPercentage(v59, v60, v92.Echo)) then
				local v161 = 0 + 0;
				while true do
					if ((v161 == (0 - 0)) or ((6715 - 4387) < (1116 - 423))) then
						v33 = 3 - 2;
						if (((5576 - (111 + 1137)) == (4486 - (91 + 67))) and v25(v94.TipTheScalesDreamBreath)) then
							return "dream_breath cooldown";
						end
						break;
					end
				end
			elseif (((4726 - 3138) >= (333 + 999)) and v92.Spiritbloom:IsReady() and v61 and v27.AreUnitsBelowHealthPercentage(v62, v63, v92.Echo)) then
				local v182 = 523 - (423 + 100);
				while true do
					if ((v182 == (0 + 0)) or ((11557 - 7383) > (2215 + 2033))) then
						v34 = 774 - (326 + 445);
						if (v25(v94.TipTheScalesSpiritbloom) or ((20013 - 15427) <= (182 - 100))) then
							return "spirit_bloom cooldown";
						end
						break;
					end
				end
			end
		end
		if (((9016 - 5153) == (4574 - (530 + 181))) and v92.DreamFlight:IsCastable() and (v89 == "At Cursor") and v27.AreUnitsBelowHealthPercentage(v90, v91, v92.Echo)) then
			if (v25(v94.DreamFlightCursor) or ((1163 - (614 + 267)) <= (74 - (19 + 13)))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((7501 - 2892) >= (1784 - 1018)) and v92.DreamFlight:IsCastable() and (v89 == "Confirmation") and v27.AreUnitsBelowHealthPercentage(v90, v91, v92.Echo)) then
			if (v25(v92.DreamFlight) or ((3290 - 2138) == (647 + 1841))) then
				return "Dream_Flight cooldown";
			end
		end
		if (((6017 - 2595) > (6947 - 3597)) and v92.Rewind:IsCastable() and v64 and v27.AreUnitsBelowHealthPercentage(v65, v66, v92.Echo)) then
			if (((2689 - (1293 + 519)) > (766 - 390)) and v25(v92.Rewind)) then
				return "rewind cooldown";
			end
		end
		if ((v92.TimeDilation:IsCastable() and v67 and (v15:HealthPercentage() <= v68)) or ((8140 - 5022) <= (3539 - 1688))) then
			if (v25(v94.TimeDilationFocus) or ((711 - 546) >= (8226 - 4734))) then
				return "time_dilation cooldown";
			end
		end
		if (((2092 + 1857) < (991 + 3865)) and v92.FireBreath:IsReady()) then
			local v138 = 0 - 0;
			while true do
				if ((v138 == (1 + 0)) or ((1421 + 2855) < (1885 + 1131))) then
					if (((5786 - (709 + 387)) > (5983 - (673 + 1185))) and v25(v94.FireBreathMacro, not v14:IsInRange(87 - 57), true, nil, true)) then
						return "fire_breath cds " .. v105;
					end
					break;
				end
				if (((0 - 0) == v138) or ((82 - 32) >= (641 + 255))) then
					if ((v101 <= (2 + 0)) or ((2313 - 599) >= (727 + 2231))) then
						v105 = 1 - 0;
					elseif ((v101 <= (7 - 3)) or ((3371 - (446 + 1434)) < (1927 - (1040 + 243)))) then
						v105 = 5 - 3;
					elseif (((2551 - (559 + 1288)) < (2918 - (609 + 1322))) and (v101 <= (460 - (13 + 441)))) then
						v105 = 10 - 7;
					else
						v105 = 10 - 6;
					end
					v32 = v105;
					v138 = 4 - 3;
				end
			end
		end
	end
	local function v116()
		if (((139 + 3579) > (6922 - 5016)) and v92.EmeraldBlossom:IsCastable() and v71 and v27.AreUnitsBelowHealthPercentage(v72, v73, v92.Echo)) then
			if (v25(v94.EmeraldBlossomFocus) or ((341 + 617) > (1593 + 2042))) then
				return "emerald_blossom aoe_healing";
			end
		end
		if (((10389 - 6888) <= (2459 + 2033)) and (v69 == "Player Only")) then
			if ((v92.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v70)) or ((6330 - 2888) < (1685 + 863))) then
				if (((1600 + 1275) >= (1052 + 412)) and v21(v94.VerdantEmbracePlayer, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v69 == "Everyone") or ((4028 + 769) >= (4788 + 105))) then
			if ((v92.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v70)) or ((984 - (153 + 280)) > (5971 - 3903))) then
				if (((1898 + 216) > (373 + 571)) and v21(v94.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v69 == "Not Tank") or ((1184 + 1078) >= (2810 + 286))) then
			if ((v92.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v70) and (v27.UnitGroupRole(v15) ~= "TANK")) or ((1634 + 621) >= (5385 - 1848))) then
				if (v21(v94.VerdantEmbraceFocus, nil) or ((2372 + 1465) < (1973 - (89 + 578)))) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((2108 + 842) == (6132 - 3182)) and v92.DreamBreath:IsReady() and v58 and v27.AreUnitsBelowHealthPercentage(v59, v60, v92.Echo)) then
			local v139 = 1049 - (572 + 477);
			while true do
				if ((v139 == (1 + 0)) or ((2835 + 1888) < (394 + 2904))) then
					if (((1222 - (84 + 2)) >= (253 - 99)) and v25(v94.DreamBreathMacro, nil, true)) then
						return "dream_breath aoe_healing";
					end
					break;
				end
				if ((v139 == (0 + 0)) or ((1113 - (497 + 345)) > (122 + 4626))) then
					if (((802 + 3938) >= (4485 - (605 + 728))) and (v108 <= (2 + 0))) then
						v106 = 1 - 0;
					else
						v106 = 1 + 1;
					end
					v33 = v106;
					v139 = 3 - 2;
				end
			end
		end
		if ((v92.Spiritbloom:IsReady() and v61 and v27.AreUnitsBelowHealthPercentage(v62, v63, v92.Echo)) or ((2325 + 253) >= (9392 - 6002))) then
			if (((31 + 10) <= (2150 - (457 + 32))) and (v108 > (1 + 1))) then
				v107 = 1405 - (832 + 570);
			else
				v107 = 1 + 0;
			end
			v34 = 1 + 2;
			if (((2126 - 1525) < (1715 + 1845)) and v25(v94.SpiritbloomFocus, nil, true)) then
				return "spirit_bloom aoe_healing";
			end
		end
		if (((1031 - (588 + 208)) < (1851 - 1164)) and v92.LivingFlame:IsCastable() and v74 and v13:BuffUp(v92.LeapingFlamesBuff) and (v15:HealthPercentage() <= v75)) then
			if (((6349 - (884 + 916)) > (2413 - 1260)) and v25(v94.LivingFlameFocus, not v15:IsSpellInRange(v92.LivingFlame), v104)) then
				return "living_flame_leaping_flames aoe_healing";
			end
		end
	end
	local function v117()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (653 - (232 + 421))) or ((6563 - (1569 + 320)) < (1147 + 3525))) then
				if (((697 + 2971) < (15369 - 10808)) and v92.Reversion:IsReady() and v76 and (v27.UnitGroupRole(v15) ~= "TANK") and (v27.FriendlyUnitsWithBuffCount(v92.Reversion) < (606 - (316 + 289))) and (v15:HealthPercentage() <= v77)) then
					if (v25(v94.ReversionFocus) or ((1191 - 736) == (167 + 3438))) then
						return "reversion_tank st_healing";
					end
				end
				if ((v92.Reversion:IsReady() and v76 and (v27.UnitGroupRole(v15) == "TANK") and (v27.FriendlyUnitsWithBuffCount(v92.Reversion, true, false) < (1454 - (666 + 787))) and (v15:HealthPercentage() <= v78)) or ((3088 - (360 + 65)) == (3096 + 216))) then
					if (((4531 - (79 + 175)) <= (7056 - 2581)) and v25(v94.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v129 = 1 + 0;
			end
			if ((v129 == (2 - 1)) or ((1675 - 805) == (2088 - (503 + 396)))) then
				if (((1734 - (92 + 89)) <= (6077 - 2944)) and v92.TemporalAnomaly:IsReady() and v79 and v27.AreUnitsBelowHealthPercentage(v80, v81, v92.Echo)) then
					if (v25(v92.TemporalAnomaly, not v15:IsInRange(16 + 14), v104) or ((1324 + 913) >= (13749 - 10238))) then
						return "temporal_anomaly st_healing";
					end
				end
				if ((v92.Echo:IsReady() and v82 and not v15:BuffUp(v92.Echo) and (v15:HealthPercentage() <= v83)) or ((182 + 1142) > (6885 - 3865))) then
					if (v25(v94.EchoFocus) or ((2611 + 381) == (899 + 982))) then
						return "echo st_healing";
					end
				end
				v129 = 5 - 3;
			end
			if (((388 + 2718) > (2326 - 800)) and (v129 == (1246 - (485 + 759)))) then
				if (((6994 - 3971) < (5059 - (442 + 747))) and v92.LivingFlame:IsReady() and v74 and (v15:HealthPercentage() <= v75)) then
					if (((1278 - (832 + 303)) > (1020 - (88 + 858))) and v25(v94.LivingFlameFocus, not v15:IsSpellInRange(v92.LivingFlame), v104)) then
						return "living_flame st_healing";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v130 = v116();
		if (((6 + 12) < (1748 + 364)) and v130) then
			return v130;
		end
		v130 = v117();
		if (((46 + 1051) <= (2417 - (766 + 23))) and v130) then
			return v130;
		end
	end
	local function v119()
		local v131 = 0 - 0;
		local v132;
		while true do
			if (((6332 - 1702) == (12198 - 7568)) and (v131 == (3 - 2))) then
				if (((4613 - (1036 + 37)) > (1903 + 780)) and v132) then
					return v132;
				end
				v132 = v115();
				v131 = 3 - 1;
			end
			if (((3772 + 1022) >= (4755 - (641 + 839))) and ((913 - (910 + 3)) == v131)) then
				if (((3782 - 2298) == (3168 - (1466 + 218))) and (v45 or v44)) then
					local v162 = 0 + 0;
					local v163;
					while true do
						if (((2580 - (556 + 592)) < (1265 + 2290)) and (v162 == (808 - (329 + 479)))) then
							v163 = v111();
							if (v163 or ((1919 - (174 + 680)) > (12294 - 8716))) then
								return v163;
							end
							break;
						end
					end
				end
				v132 = v110();
				v131 = 1 - 0;
			end
			if ((v131 == (2 + 0)) or ((5534 - (396 + 343)) < (125 + 1282))) then
				if (((3330 - (29 + 1448)) < (6202 - (135 + 1254))) and v132) then
					return v132;
				end
				v132 = v112();
				v131 = 11 - 8;
			end
			if ((v131 == (18 - 14)) or ((1881 + 940) < (3958 - (389 + 1138)))) then
				if (v132 or ((3448 - (102 + 472)) < (2059 + 122))) then
					return v132;
				end
				if (v27.TargetIsValid() or ((1492 + 1197) <= (320 + 23))) then
					local v164 = 1545 - (320 + 1225);
					local v165;
					while true do
						if ((v164 == (0 - 0)) or ((1144 + 725) == (3473 - (157 + 1307)))) then
							v165 = v114();
							if (v165 or ((5405 - (821 + 1038)) < (5793 - 3471))) then
								return v165;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == (1 + 2)) or ((3697 - 1615) == (1776 + 2997))) then
				if (((8040 - 4796) > (2081 - (834 + 192))) and v132) then
					return v132;
				end
				v132 = v118();
				v131 = 1 + 3;
			end
		end
	end
	local function v120()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 + 0)) or ((5132 - 1819) <= (2082 - (300 + 4)))) then
				if (v45 or v44 or ((380 + 1041) >= (5507 - 3403))) then
					local v166 = v111();
					if (((2174 - (112 + 250)) <= (1296 + 1953)) and v166) then
						return v166;
					end
				end
				if (((4065 - 2442) <= (1122 + 835)) and v35) then
					local v167 = v118();
					if (((2282 + 2130) == (3300 + 1112)) and v167) then
						return v167;
					end
					if (((868 + 882) >= (626 + 216)) and v43 and v92.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v92.BlessingoftheBronzeBuff, true) or v27.GroupBuffMissing(v92.BlessingoftheBronzeBuff))) then
						if (((5786 - (1001 + 413)) > (4125 - 2275)) and v25(v92.BlessingoftheBronze)) then
							return "blessing_of_the_bronze precombat";
						end
					end
					if (((1114 - (244 + 638)) < (1514 - (627 + 66))) and v27.TargetIsValid()) then
						local v183 = v109();
						if (((1543 - 1025) < (1504 - (512 + 90))) and v183) then
							return v183;
						end
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v134 = 1906 - (1665 + 241);
		while true do
			if (((3711 - (373 + 344)) > (387 + 471)) and (v134 == (2 + 5))) then
				v74 = EpicSettings.Settings['UseLivingFlame'];
				v75 = EpicSettings.Settings['LivingFlameHP'] or (0 - 0);
				v76 = EpicSettings.Settings['UseReversion'];
				v77 = EpicSettings.Settings['ReversionHP'] or (0 - 0);
				v78 = EpicSettings.Settings['ReversionTankHP'] or (1099 - (35 + 1064));
				v134 = 6 + 2;
			end
			if ((v134 == (0 - 0)) or ((15 + 3740) <= (2151 - (298 + 938)))) then
				v39 = EpicSettings.Settings['UseRacials'];
				v40 = EpicSettings.Settings['UseHealingPotion'];
				v41 = EpicSettings.Settings['HealingPotionName'] or (1259 - (233 + 1026));
				v42 = EpicSettings.Settings['HealingPotionHP'] or (1666 - (636 + 1030));
				v43 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 + 0);
				v134 = 1 + 0;
			end
			if (((1173 + 2773) > (253 + 3490)) and ((225 - (55 + 166)) == v134)) then
				v59 = EpicSettings.Settings['DreamBreathHP'] or (0 + 0);
				v60 = EpicSettings.Settings['DreamBreathGroup'] or (0 + 0);
				v61 = EpicSettings.Settings['UseSpiritbloom'];
				v62 = EpicSettings.Settings['SpiritbloomHP'] or (0 - 0);
				v63 = EpicSettings.Settings['SpiritbloomGroup'] or (297 - (36 + 261));
				v134 = 8 - 3;
			end
			if ((v134 == (1371 - (34 + 1334))) or ((514 + 821) >= (2569 + 737))) then
				v54 = EpicSettings.Settings['ObsidianScalesHP'] or (1283 - (1035 + 248));
				v55 = EpicSettings.Settings['UseStasis'];
				v56 = EpicSettings.Settings['StasisHP'] or (21 - (20 + 1));
				v57 = EpicSettings.Settings['StasisGroup'] or (0 + 0);
				v58 = EpicSettings.Settings['UseDreamBreath'];
				v134 = 323 - (134 + 185);
			end
			if (((5977 - (549 + 584)) > (2938 - (314 + 371))) and (v134 == (27 - 19))) then
				v79 = EpicSettings.Settings['UseTemporalAnomaly'];
				v80 = EpicSettings.Settings['TemporalAnomalyHP'] or (968 - (478 + 490));
				v81 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 + 0);
				v82 = EpicSettings.Settings['UseEcho'];
				v83 = EpicSettings.Settings['EchoHP'] or (1172 - (786 + 386));
				v134 = 28 - 19;
			end
			if (((1831 - (1055 + 324)) == (1792 - (1093 + 247))) and ((6 + 0) == v134)) then
				v69 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v70 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
				v71 = EpicSettings.Settings['UseEmeraldBlossom'];
				v72 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 - 0);
				v73 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
				v134 = 19 - 12;
			end
			if ((v134 == (2 - 1)) or ((1622 + 2935) < (8040 - 5953))) then
				v44 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
				v45 = EpicSettings.Settings['DispelBuffs'] or (0 + 0);
				v46 = EpicSettings.Settings['UseHealthstone'];
				v47 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v48 = EpicSettings.Settings['HandleCharredTreant'] or (688 - (364 + 324));
				v134 = 5 - 3;
			end
			if (((9296 - 5422) == (1284 + 2590)) and (v134 == (20 - 15))) then
				v64 = EpicSettings.Settings['UseRewind'];
				v65 = EpicSettings.Settings['RewindHP'] or (0 - 0);
				v66 = EpicSettings.Settings['RewindGroup'] or (0 - 0);
				v67 = EpicSettings.Settings['UseTimeDilation'];
				v68 = EpicSettings.Settings['TimeDilationHP'] or (1268 - (1249 + 19));
				v134 = 6 + 0;
			end
			if ((v134 == (7 - 5)) or ((3024 - (686 + 400)) > (3873 + 1062))) then
				v49 = EpicSettings.Settings['HandleCharredBrambles'] or (229 - (73 + 156));
				v50 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v51 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (811 - (721 + 90));
				v52 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v53 = EpicSettings.Settings['UseObsidianScales'];
				v134 = 9 - 6;
			end
			if ((v134 == (479 - (224 + 246))) or ((6893 - 2638) < (6302 - 2879))) then
				v84 = EpicSettings.Settings['UseOppressingRoar'];
				v85 = EpicSettings.Settings['UseRenewingBlaze'];
				v86 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v87 = EpicSettings.Settings['UseHover'];
				v88 = EpicSettings.Settings['HoverTime'] or (0 + 0);
				break;
			end
		end
	end
	local function v122()
		v89 = EpicSettings.Settings['DreamFlightUsage'] or "";
		v90 = EpicSettings.Settings['DreamFlightHP'] or (0 + 0);
		v91 = EpicSettings.Settings['DreamFlightGroup'] or (0 - 0);
	end
	local function v123()
		local v135 = 0 - 0;
		while true do
			if (((1967 - (203 + 310)) <= (4484 - (1238 + 755))) and (v135 == (1 + 4))) then
				if (v13:IsChanneling(v92.DreamBreath) or ((5691 - (709 + 825)) <= (5164 - 2361))) then
					local v168 = 0 - 0;
					local v169;
					while true do
						if (((5717 - (196 + 668)) >= (11773 - 8791)) and (v168 == (0 - 0))) then
							v169 = GetTime() - v13:CastStart();
							if (((4967 - (171 + 662)) > (3450 - (4 + 89))) and (v169 >= v13:EmpowerCastTime(v33))) then
								local v187 = 0 - 0;
								while true do
									if ((v187 == (0 + 0)) or ((15008 - 11591) < (994 + 1540))) then
										v9.EpicSettingsS = v92.DreamBreath.ReturnID;
										return "Stopping DreamBreath";
									end
								end
							end
							break;
						end
					end
				end
				if (v13:IsChanneling(v92.Spiritbloom) or ((4208 - (35 + 1451)) <= (1617 - (28 + 1425)))) then
					local v170 = 1993 - (941 + 1052);
					local v171;
					while true do
						if ((v170 == (0 + 0)) or ((3922 - (822 + 692)) < (3010 - 901))) then
							v171 = GetTime() - v13:CastStart();
							if ((v171 >= v13:EmpowerCastTime(v34)) or ((16 + 17) == (1752 - (45 + 252)))) then
								local v188 = 0 + 0;
								while true do
									if ((v188 == (0 + 0)) or ((1078 - 635) >= (4448 - (114 + 319)))) then
										v9.EpicSettingsS = v92.Spiritbloom.ReturnID;
										return "Stopping Spiritbloom";
									end
								end
							end
							break;
						end
					end
				end
				if (((4855 - 1473) > (212 - 46)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					local v172 = 0 + 0;
					local v173;
					while true do
						if ((v172 == (0 - 0)) or ((586 - 306) == (5022 - (556 + 1407)))) then
							v173 = v27.DeadFriendlyUnitsCount();
							if (((3087 - (741 + 465)) > (1758 - (170 + 295))) and not v13:AffectingCombat()) then
								if (((1242 + 1115) == (2165 + 192)) and (v173 > (2 - 1))) then
									if (((102 + 21) == (79 + 44)) and v25(v92.MassReturn, nil, true)) then
										return "mass_return";
									end
								elseif (v25(v92.Return, not v14:IsInRange(17 + 13), true) or ((2286 - (957 + 273)) >= (908 + 2484))) then
									return "return";
								end
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((433 + 648) < (4096 - 3021))) then
					if (v13:AffectingCombat() or ((2764 - 1715) >= (13537 - 9105))) then
						local v184 = v119();
						if (v184 or ((23609 - 18841) <= (2626 - (389 + 1391)))) then
							return v184;
						end
					else
						local v185 = 0 + 0;
						local v186;
						while true do
							if ((v185 == (0 + 0)) or ((7644 - 4286) <= (2371 - (783 + 168)))) then
								v186 = v120();
								if (v186 or ((12548 - 8809) <= (2956 + 49))) then
									return v186;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((312 - (309 + 2)) == v135) or ((5094 - 3435) >= (3346 - (1090 + 122)))) then
				v36 = EpicSettings.Toggles['aoe'];
				v37 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['dispel'];
				if (v13:IsMounted() or ((1057 + 2203) < (7909 - 5554))) then
					return;
				end
				v135 = 2 + 0;
			end
			if ((v135 == (1118 - (628 + 490))) or ((120 + 549) == (10455 - 6232))) then
				v121();
				v122();
				if (v13:IsDeadOrGhost() or ((7732 - 6040) < (1362 - (431 + 343)))) then
					return;
				end
				v35 = EpicSettings.Toggles['ooc'];
				v135 = 1 - 0;
			end
			if (((8 - 5) == v135) or ((3790 + 1007) < (467 + 3184))) then
				if ((v87 and (v35 or v13:AffectingCombat())) or ((5872 - (556 + 1139)) > (4865 - (6 + 9)))) then
					if (((GetTime() - v31) > v88) or ((74 + 326) > (570 + 541))) then
						if (((3220 - (28 + 141)) > (390 + 615)) and v92.Hover:IsReady() and v13:BuffDown(v92.Hover)) then
							if (((4557 - 864) <= (3104 + 1278)) and v25(v92.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				v104 = v13:BuffRemains(v92.HoverBuff) < (1319 - (486 + 831));
				v108 = v27.FriendlyUnitsBelowHealthPercentageCount(221 - 136, nil, nil, v92.Echo);
				v99 = v13:GetEnemiesInRange(88 - 63);
				v135 = 1 + 3;
			end
			if (((6 - 4) == v135) or ((4545 - (668 + 595)) > (3690 + 410))) then
				if (not v13:IsMoving() or ((722 + 2858) < (7755 - 4911))) then
					v31 = GetTime();
				end
				if (((379 - (23 + 267)) < (6434 - (1129 + 815))) and (v13:AffectingCombat() or v44 or v35)) then
					local v174 = 387 - (371 + 16);
					local v175;
					local v176;
					while true do
						if ((v174 == (1751 - (1326 + 424))) or ((9437 - 4454) < (6606 - 4798))) then
							if (((3947 - (88 + 30)) > (4540 - (720 + 51))) and v176) then
								return v176;
							end
							break;
						end
						if (((3303 - 1818) <= (4680 - (421 + 1355))) and (v174 == (0 - 0))) then
							v175 = v44 and v92.Expunge:IsReady();
							v176 = v27.FocusUnit(v175, nil, 20 + 20, nil, 1103 - (286 + 797), v92.Echo);
							v174 = 3 - 2;
						end
					end
				end
				if (((7070 - 2801) == (4708 - (397 + 42))) and v48) then
					local v177 = 0 + 0;
					local v178;
					while true do
						if (((1187 - (24 + 776)) <= (4285 - 1503)) and ((785 - (222 + 563)) == v177)) then
							v178 = v27.HandleCharredTreant(v92.Echo, v94.EchoMouseover, 88 - 48);
							if (v178 or ((1368 + 531) <= (1107 - (23 + 167)))) then
								return v178;
							end
							v177 = 1799 - (690 + 1108);
						end
						if ((v177 == (1 + 0)) or ((3557 + 755) <= (1724 - (40 + 808)))) then
							v178 = v27.HandleCharredTreant(v92.LivingFlame, v94.LivingFlameMouseover, 7 + 33, true);
							if (((8535 - 6303) <= (2482 + 114)) and v178) then
								return v178;
							end
							break;
						end
					end
				end
				if (((1109 + 986) < (2022 + 1664)) and v49) then
					local v179 = v27.HandleCharredBrambles(v92.Echo, v94.EchoMouseover, 611 - (47 + 524));
					if (v179 or ((1036 + 559) >= (12229 - 7755))) then
						return v179;
					end
					local v179 = v27.HandleCharredBrambles(v92.LivingFlame, v94.LivingFlameMouseover, 59 - 19, true);
					if (v179 or ((10533 - 5914) < (4608 - (1165 + 561)))) then
						return v179;
					end
				end
				v135 = 1 + 2;
			end
			if (((12 - 8) == v135) or ((113 + 181) >= (5310 - (341 + 138)))) then
				v100 = v14:GetEnemiesInSplashRange(3 + 5);
				if (((4186 - 2157) <= (3410 - (89 + 237))) and v36) then
					v101 = #v100;
				else
					v101 = 3 - 2;
				end
				if (v27.TargetIsValid() or v13:AffectingCombat() or ((4288 - 2251) == (3301 - (581 + 300)))) then
					v102 = v9.BossFightRemains(nil, true);
					v103 = v102;
					if (((5678 - (855 + 365)) > (9272 - 5368)) and (v103 == (3628 + 7483))) then
						v103 = v9.FightRemains(v99, false);
					end
				end
				if (((1671 - (1030 + 205)) >= (116 + 7)) and v13:IsChanneling(v92.FireBreath)) then
					local v180 = 0 + 0;
					local v181;
					while true do
						if (((786 - (156 + 130)) < (4126 - 2310)) and ((0 - 0) == v180)) then
							v181 = GetTime() - v13:CastStart();
							if (((7319 - 3745) == (942 + 2632)) and (v181 >= v13:EmpowerCastTime(v32))) then
								local v189 = 0 + 0;
								while true do
									if (((290 - (10 + 59)) < (111 + 279)) and (v189 == (0 - 0))) then
										v9.EpicSettingsS = v92.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				v135 = 1168 - (671 + 492);
			end
		end
	end
	local function v124()
		v20.Print("Preservation Evoker by Epic BoomK");
		EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
		v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableMagicDebuffs);
		v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableDiseaseDebuffs);
		v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableCurseDebuffs);
	end
	v20.SetAPL(1169 + 299, v123, v124);
end;
return v0["Epix_Evoker_Preservation.lua"]();

