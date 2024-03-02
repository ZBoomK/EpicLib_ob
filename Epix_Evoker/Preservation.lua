local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((6340 - (1607 + 27)) < (1065 + 2634))) then
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
	local v32 = 1726 - (1668 + 58);
	local v33 = 627 - (512 + 114);
	local v34 = 2 - 1;
	local v35 = 1 - 0;
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
	local v98 = (v97[45 - 32] and v19(v97[7 + 6])) or v19(0 + 0);
	local v99 = (v97[13 + 1] and v19(v97[47 - 33])) or v19(1994 - (109 + 1885));
	local v100;
	local v101;
	local v102;
	local v103 = 12580 - (1269 + 200);
	local v104 = 21296 - 10185;
	local v105;
	local v106 = 815 - (98 + 717);
	local v107 = 826 - (802 + 24);
	local v108 = 0 - 0;
	local v109 = 0 - 0;
	v9:RegisterForEvent(function()
		local v126 = 0 + 0;
		while true do
			if (((2033 + 613) >= (144 + 732)) and (v126 == (1 + 0))) then
				v99 = (v97[38 - 24] and v19(v97[46 - 32])) or v19(0 + 0);
				break;
			end
			if (((250 + 364) <= (2627 + 557)) and (v126 == (0 + 0))) then
				v97 = v13:GetEquipment();
				v98 = (v97[7 + 6] and v19(v97[1446 - (797 + 636)])) or v19(0 - 0);
				v126 = 1620 - (1427 + 192);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v103 = 3850 + 7261;
		v104 = 25797 - 14686;
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		local v127 = 0 + 0;
		while true do
			if (((1417 + 1709) == (3452 - (192 + 134))) and (v127 == (1276 - (316 + 960)))) then
				if (v93.LivingFlame:IsCastable() or ((1218 + 969) >= (3824 + 1130))) then
					if (v25(v93.LivingFlame, not v14:IsInRange(24 + 1), v105) or ((14821 - 10944) == (4126 - (83 + 468)))) then
						return "living_flame precombat";
					end
				end
				if (((2513 - (1202 + 604)) > (2950 - 2318)) and v93.AzureStrike:IsCastable()) then
					if (v25(v93.AzureStrike, not v14:IsSpellInRange(v93.AzureStrike)) or ((908 - 362) >= (7431 - 4747))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
		end
	end
	local function v111()
		if (((1790 - (45 + 280)) <= (4152 + 149)) and v93.ObsidianScales:IsCastable() and v54 and v13:BuffDown(v93.ObsidianScales) and (v13:HealthPercentage() < v55)) then
			if (((1489 + 215) > (521 + 904)) and v25(v93.ObsidianScales)) then
				return "obsidian_scales defensives";
			end
		end
		if ((v94.Healthstone:IsReady() and v47 and (v13:HealthPercentage() <= v48)) or ((381 + 306) == (745 + 3489))) then
			if (v25(v95.Healthstone, nil, nil, true) or ((6166 - 2836) < (3340 - (340 + 1571)))) then
				return "healthstone defensive 3";
			end
		end
		if (((453 + 694) >= (2107 - (1733 + 39))) and v41 and (v13:HealthPercentage() <= v43)) then
			if (((9438 - 6003) > (3131 - (125 + 909))) and (v42 == "Refreshing Healing Potion")) then
				if (v94.RefreshingHealingPotion:IsReady() or ((5718 - (1096 + 852)) >= (1813 + 2228))) then
					if (v25(v95.RefreshingHealingPotion, nil, nil, true) or ((5413 - 1622) <= (1563 + 48))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
		if ((v93.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v87) and v86) or ((5090 - (409 + 103)) <= (2244 - (46 + 190)))) then
			if (((1220 - (51 + 44)) <= (586 + 1490)) and v21(v93.RenewingBlaze, nil, nil)) then
				return "RenewingBlaze defensive";
			end
		end
	end
	local function v112()
		local v128 = 1317 - (1114 + 203);
		while true do
			if ((v128 == (726 - (228 + 498))) or ((161 + 582) >= (2431 + 1968))) then
				if (((1818 - (174 + 489)) < (4358 - 2685)) and v93.Expunge:IsReady() and (v27.UnitHasMagicDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) then
					if (v25(v95.ExpungeFocus) or ((4229 - (830 + 1075)) <= (1102 - (303 + 221)))) then
						return "expunge dispel";
					end
				end
				if (((5036 - (231 + 1038)) == (3140 + 627)) and v93.CauterizingFlame:IsReady() and (v27.UnitHasCurseDebuff(v15) or v27.UnitHasDiseaseDebuff(v15))) then
					if (((5251 - (171 + 991)) == (16851 - 12762)) and v25(v95.CauterizingFlameFocus)) then
						return "cauterizing_flame dispel";
					end
				end
				v128 = 2 - 1;
			end
			if (((11124 - 6666) >= (1340 + 334)) and (v128 == (3 - 2))) then
				if (((2803 - 1831) <= (2285 - 867)) and v93.OppressingRoar:IsReady() and v85 and v27.UnitHasEnrageBuff(v14)) then
					if (v25(v93.OppressingRoar) or ((15264 - 10326) < (6010 - (111 + 1137)))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
		end
	end
	local function v113()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2662 - (91 + 67)) > (12690 - 8426))) then
			local v148 = v27.Interrupt(v93.Quell, 3 + 7, true);
			if (((2676 - (423 + 100)) == (16 + 2137)) and v148) then
				return v148;
			end
			v148 = v27.InterruptWithStun(v93.TailSwipe, 21 - 13);
			if (v148 or ((265 + 242) >= (3362 - (326 + 445)))) then
				return v148;
			end
			v148 = v27.Interrupt(v93.Quell, 43 - 33, true, v16, v95.QuellMouseover);
			if (((9982 - 5501) == (10459 - 5978)) and v148) then
				return v148;
			end
		end
	end
	local function v114()
		local v129 = 711 - (530 + 181);
		local v130;
		while true do
			if ((v129 == (882 - (614 + 267))) or ((2360 - (19 + 13)) < (1127 - 434))) then
				v130 = v27.HandleBottomTrinket(v96, v38, 93 - 53, nil);
				if (((12363 - 8035) == (1125 + 3203)) and v130) then
					return v130;
				end
				break;
			end
			if (((2792 - 1204) >= (2761 - 1429)) and (v129 == (1812 - (1293 + 519)))) then
				v130 = v27.HandleTopTrinket(v96, v38, 81 - 41, nil);
				if (v130 or ((10897 - 6723) > (8123 - 3875))) then
					return v130;
				end
				v129 = 4 - 3;
			end
		end
	end
	local function v115()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (1 + 0)) or ((936 + 3650) <= (190 - 108))) then
				if (((893 + 2970) == (1284 + 2579)) and v93.Disintegrate:IsReady() and v13:BuffUp(v93.EssenceBurstBuff)) then
					if (v25(v93.Disintegrate, not v14:IsSpellInRange(v93.Disintegrate), v105) or ((177 + 105) <= (1138 - (709 + 387)))) then
						return "disintegrate damage";
					end
				end
				if (((6467 - (673 + 1185)) >= (2221 - 1455)) and v93.LivingFlame:IsCastable()) then
					if (v25(v93.LivingFlame, not v14:IsSpellInRange(v93.LivingFlame), v105) or ((3698 - 2546) == (4093 - 1605))) then
						return "living_flame damage";
					end
				end
				v131 = 2 + 0;
			end
			if (((2557 + 865) > (4523 - 1173)) and (v131 == (0 + 0))) then
				if (((1748 - 871) > (737 - 361)) and v93.LivingFlame:IsCastable() and v13:BuffUp(v93.LeapingFlamesBuff)) then
					if (v25(v93.LivingFlame, not v14:IsSpellInRange(v93.LivingFlame), v105) or ((4998 - (446 + 1434)) <= (3134 - (1040 + 243)))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (v93.FireBreath:IsReady() or ((492 - 327) >= (5339 - (559 + 1288)))) then
					local v187 = 1931 - (609 + 1322);
					while true do
						if (((4403 - (13 + 441)) < (18145 - 13289)) and (v187 == (2 - 1))) then
							if (v25(v95.FireBreathMacro, not v14:IsInRange(149 - 119), true, nil, true) or ((160 + 4116) < (10953 - 7937))) then
								return "fire_breath damage " .. v106;
							end
							break;
						end
						if (((1666 + 3024) > (1808 + 2317)) and (v187 == (0 - 0))) then
							if ((v102 <= (2 + 0)) or ((91 - 41) >= (593 + 303))) then
								v106 = 1 + 0;
							elseif ((v102 <= (3 + 1)) or ((1440 + 274) >= (2895 + 63))) then
								v106 = 435 - (153 + 280);
							elseif ((v102 <= (17 - 11)) or ((1339 + 152) < (255 + 389))) then
								v106 = 2 + 1;
							else
								v106 = 4 + 0;
							end
							v33 = v106;
							v187 = 1 + 0;
						end
					end
				end
				v131 = 1 - 0;
			end
			if (((436 + 268) < (1654 - (89 + 578))) and (v131 == (2 + 0))) then
				if (((7729 - 4011) > (2955 - (572 + 477))) and v93.AzureStrike:IsCastable()) then
					if (v25(v93.AzureStrike, not v14:IsSpellInRange(v93.AzureStrike)) or ((130 + 828) > (2182 + 1453))) then
						return "azure_strike damage";
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v132 = 0 + 0;
		local v133;
		while true do
			if (((3587 - (84 + 2)) <= (7402 - 2910)) and (v132 == (0 + 0))) then
				v133 = v114();
				if (v133 or ((4284 - (497 + 345)) < (66 + 2482))) then
					return v133;
				end
				v132 = 1 + 0;
			end
			if (((4208 - (605 + 728)) >= (1045 + 419)) and (v132 == (3 - 1))) then
				if (v93.TipTheScales:IsCastable() or ((220 + 4577) >= (18090 - 13197))) then
					if ((v93.DreamBreath:IsReady() and v59 and v27.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) or ((497 + 54) > (5729 - 3661))) then
						local v198 = 0 + 0;
						while true do
							if (((2603 - (457 + 32)) > (401 + 543)) and (v198 == (1402 - (832 + 570)))) then
								v34 = 1 + 0;
								if (v25(v95.TipTheScalesDreamBreath) or ((590 + 1672) >= (10956 - 7860))) then
									return "dream_breath cooldown";
								end
								break;
							end
						end
					elseif ((v93.Spiritbloom:IsReady() and v62 and v27.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) or ((1087 + 1168) >= (4333 - (588 + 208)))) then
						local v203 = 0 - 0;
						while true do
							if ((v203 == (1800 - (884 + 916))) or ((8032 - 4195) < (758 + 548))) then
								v35 = 656 - (232 + 421);
								if (((4839 - (1569 + 320)) == (724 + 2226)) and v25(v95.TipTheScalesSpiritbloom)) then
									return "spirit_bloom cooldown";
								end
								break;
							end
						end
					end
				end
				if ((v93.DreamFlight:IsCastable() and (v90 == "At Cursor") and v27.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) or ((898 + 3825) < (11113 - 7815))) then
					if (((1741 - (316 + 289)) >= (402 - 248)) and v25(v95.DreamFlightCursor)) then
						return "Dream_Flight cooldown";
					end
				end
				v132 = 1 + 2;
			end
			if ((v132 == (1454 - (666 + 787))) or ((696 - (360 + 65)) > (4438 + 310))) then
				if (((4994 - (79 + 175)) >= (4969 - 1817)) and v93.Stasis:IsReady() and v56 and v27.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo)) then
					if (v25(v93.Stasis) or ((2012 + 566) >= (10391 - 7001))) then
						return "stasis cooldown";
					end
				end
				if (((78 - 37) <= (2560 - (503 + 396))) and v93.StasisReactivate:IsReady() and v56 and (v27.AreUnitsBelowHealthPercentage(v57, v58, v93.Echo) or (v13:BuffUp(v93.StasisBuff) and (v13:BuffRemains(v93.StasisBuff) < (184 - (92 + 89)))))) then
					if (((1165 - 564) < (1826 + 1734)) and v25(v93.StasisReactivate)) then
						return "stasis_reactivate cooldown";
					end
				end
				v132 = 2 + 0;
			end
			if (((920 - 685) < (94 + 593)) and (v132 == (8 - 4))) then
				if (((3969 + 580) > (551 + 602)) and v93.TimeDilation:IsCastable() and v68 and (v15:HealthPercentage() <= v69)) then
					if (v25(v95.TimeDilationFocus) or ((14235 - 9561) < (584 + 4088))) then
						return "time_dilation cooldown";
					end
				end
				if (((5593 - 1925) < (5805 - (485 + 759))) and v93.FireBreath:IsReady()) then
					local v188 = 0 - 0;
					while true do
						if ((v188 == (1190 - (442 + 747))) or ((1590 - (832 + 303)) == (4551 - (88 + 858)))) then
							if (v25(v95.FireBreathMacro, not v14:IsInRange(10 + 20), true, nil, true) or ((2204 + 459) == (137 + 3175))) then
								return "fire_breath cds " .. v106;
							end
							break;
						end
						if (((5066 - (766 + 23)) <= (22091 - 17616)) and (v188 == (0 - 0))) then
							if ((v102 <= (4 - 2)) or ((2952 - 2082) == (2262 - (1036 + 37)))) then
								v106 = 1 + 0;
							elseif (((3023 - 1470) <= (2465 + 668)) and (v102 <= (1484 - (641 + 839)))) then
								v106 = 915 - (910 + 3);
							elseif ((v102 <= (15 - 9)) or ((3921 - (1466 + 218)) >= (1614 + 1897))) then
								v106 = 1151 - (556 + 592);
							else
								v106 = 2 + 2;
							end
							v33 = v106;
							v188 = 809 - (329 + 479);
						end
					end
				end
				break;
			end
			if ((v132 == (857 - (174 + 680))) or ((4549 - 3225) > (6259 - 3239))) then
				if ((v93.DreamFlight:IsCastable() and (v90 == "Confirmation") and v27.AreUnitsBelowHealthPercentage(v91, v92, v93.Echo)) or ((2137 + 855) == (2620 - (396 + 343)))) then
					if (((275 + 2831) > (3003 - (29 + 1448))) and v25(v93.DreamFlight)) then
						return "Dream_Flight cooldown";
					end
				end
				if (((4412 - (135 + 1254)) < (14579 - 10709)) and v93.Rewind:IsCastable() and v65 and v27.AreUnitsBelowHealthPercentage(v66, v67, v93.Echo)) then
					if (((667 - 524) > (50 + 24)) and v25(v93.Rewind)) then
						return "rewind cooldown";
					end
				end
				v132 = 1531 - (389 + 1138);
			end
		end
	end
	local function v117()
		local v134 = 574 - (102 + 472);
		while true do
			if (((17 + 1) < (1172 + 940)) and (v134 == (1 + 0))) then
				if (((2642 - (320 + 1225)) <= (2898 - 1270)) and (v70 == "Everyone")) then
					if (((2833 + 1797) == (6094 - (157 + 1307))) and v93.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v71)) then
						if (((5399 - (821 + 1038)) > (6693 - 4010)) and v21(v95.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				if (((525 + 4269) >= (5816 - 2541)) and (v70 == "Not Tank")) then
					if (((553 + 931) == (3678 - 2194)) and v93.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v71) and (v27.UnitGroupRole(v15) ~= "TANK")) then
						if (((2458 - (834 + 192)) < (227 + 3328)) and v21(v95.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 1 + 1;
			end
			if (((1 + 2) == v134) or ((1649 - 584) > (3882 - (300 + 4)))) then
				if ((v93.LivingFlame:IsCastable() and v75 and v13:BuffUp(v93.LeapingFlamesBuff) and (v15:HealthPercentage() <= v76)) or ((1281 + 3514) < (3682 - 2275))) then
					if (((2215 - (112 + 250)) < (1919 + 2894)) and v25(v95.LivingFlameFocus, not v15:IsSpellInRange(v93.LivingFlame), v105)) then
						return "living_flame_leaping_flames aoe_healing";
					end
				end
				break;
			end
			if ((v134 == (0 - 0)) or ((1617 + 1204) < (1258 + 1173))) then
				if ((v93.EmeraldBlossom:IsCastable() and v72 and v27.AreUnitsBelowHealthPercentage(v73, v74, v93.Echo)) or ((2150 + 724) < (1082 + 1099))) then
					if (v25(v95.EmeraldBlossomFocus) or ((1998 + 691) <= (1757 - (1001 + 413)))) then
						return "emerald_blossom aoe_healing";
					end
				end
				if ((v70 == "Player Only") or ((4167 - 2298) == (2891 - (244 + 638)))) then
					if ((v93.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v71)) or ((4239 - (627 + 66)) < (6918 - 4596))) then
						if (v21(v95.VerdantEmbracePlayer, nil) or ((2684 - (512 + 90)) == (6679 - (1665 + 241)))) then
							return "verdant_embrace aoe_healing";
						end
					end
				end
				v134 = 718 - (373 + 344);
			end
			if (((1464 + 1780) > (280 + 775)) and (v134 == (5 - 3))) then
				if ((v93.DreamBreath:IsReady() and v59 and v27.AreUnitsBelowHealthPercentage(v60, v61, v93.Echo)) or ((5605 - 2292) <= (2877 - (35 + 1064)))) then
					local v189 = 0 + 0;
					while true do
						if ((v189 == (2 - 1)) or ((6 + 1415) >= (3340 - (298 + 938)))) then
							if (((3071 - (233 + 1026)) <= (4915 - (636 + 1030))) and v25(v95.DreamBreathMacro, nil, true)) then
								return "dream_breath aoe_healing";
							end
							break;
						end
						if (((830 + 793) <= (1912 + 45)) and (v189 == (0 + 0))) then
							if (((299 + 4113) == (4633 - (55 + 166))) and (v109 <= (1 + 1))) then
								v107 = 1 + 0;
							else
								v107 = 7 - 5;
							end
							v34 = v107;
							v189 = 298 - (36 + 261);
						end
					end
				end
				if (((3060 - 1310) >= (2210 - (34 + 1334))) and v93.Spiritbloom:IsReady() and v62 and v27.AreUnitsBelowHealthPercentage(v63, v64, v93.Echo)) then
					local v190 = 0 + 0;
					while true do
						if (((3397 + 975) > (3133 - (1035 + 248))) and (v190 == (22 - (20 + 1)))) then
							if (((121 + 111) < (1140 - (134 + 185))) and v25(v95.SpiritbloomFocus, nil, true)) then
								return "spirit_bloom aoe_healing";
							end
							break;
						end
						if (((1651 - (549 + 584)) < (1587 - (314 + 371))) and ((0 - 0) == v190)) then
							if (((3962 - (478 + 490)) > (455 + 403)) and (v109 > (1174 - (786 + 386)))) then
								v108 = 9 - 6;
							else
								v108 = 1380 - (1055 + 324);
							end
							v35 = 1343 - (1093 + 247);
							v190 = 1 + 0;
						end
					end
				end
				v134 = 1 + 2;
			end
		end
	end
	local function v118()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (3 - 2)) or ((10684 - 6929) <= (2299 - 1384))) then
				if (((1404 + 2542) > (14419 - 10676)) and v93.TemporalAnomaly:IsReady() and v80 and v27.AreUnitsBelowHealthPercentage(v81, v82, v93.Echo)) then
					if (v25(v93.TemporalAnomaly, not v15:IsInRange(103 - 73), v105) or ((1007 + 328) >= (8454 - 5148))) then
						return "temporal_anomaly st_healing";
					end
				end
				if (((5532 - (364 + 324)) > (6175 - 3922)) and v93.Echo:IsReady() and v83 and not v15:BuffUp(v93.Echo) and (v15:HealthPercentage() <= v84)) then
					if (((1084 - 632) == (150 + 302)) and v25(v95.EchoFocus)) then
						return "echo st_healing";
					end
				end
				v135 = 8 - 6;
			end
			if ((v135 == (0 - 0)) or ((13840 - 9283) < (3355 - (1249 + 19)))) then
				if (((3497 + 377) == (15079 - 11205)) and v93.Reversion:IsReady() and v77 and (v27.UnitGroupRole(v15) ~= "TANK") and (v27.FriendlyUnitsWithBuffCount(v93.Reversion) < (1087 - (686 + 400))) and (v15:HealthPercentage() <= v78)) then
					if (v25(v95.ReversionFocus) or ((1521 + 417) > (5164 - (73 + 156)))) then
						return "reversion_tank st_healing";
					end
				end
				if ((v93.Reversion:IsReady() and v77 and (v27.UnitGroupRole(v15) == "TANK") and (v27.FriendlyUnitsWithBuffCount(v93.Reversion, true, false) < (1 + 0)) and (v15:HealthPercentage() <= v79)) or ((5066 - (721 + 90)) < (39 + 3384))) then
					if (((4720 - 3266) <= (2961 - (224 + 246))) and v25(v95.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v135 = 1 - 0;
			end
			if ((v135 == (3 - 1)) or ((755 + 3402) <= (67 + 2736))) then
				if (((3565 + 1288) >= (5928 - 2946)) and v93.LivingFlame:IsReady() and v75 and (v15:HealthPercentage() <= v76)) then
					if (((13756 - 9622) > (3870 - (203 + 310))) and v25(v95.LivingFlameFocus, not v15:IsSpellInRange(v93.LivingFlame), v105)) then
						return "living_flame st_healing";
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v136 = 1993 - (1238 + 755);
		local v137;
		while true do
			if (((1 + 0) == v136) or ((4951 - (709 + 825)) < (4669 - 2135))) then
				v137 = v118();
				if (v137 or ((3964 - 1242) <= (1028 - (196 + 668)))) then
					return v137;
				end
				break;
			end
			if ((v136 == (0 - 0)) or ((4987 - 2579) < (2942 - (171 + 662)))) then
				v137 = v117();
				if (v137 or ((126 - (4 + 89)) == (5099 - 3644))) then
					return v137;
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v120()
		local v138 = 0 - 0;
		local v139;
		while true do
			if ((v138 == (1 + 0)) or ((1929 - (35 + 1451)) >= (5468 - (28 + 1425)))) then
				if (((5375 - (941 + 1052)) > (160 + 6)) and v139) then
					return v139;
				end
				v139 = v116();
				v138 = 1516 - (822 + 692);
			end
			if ((v138 == (0 - 0)) or ((132 + 148) == (3356 - (45 + 252)))) then
				if (((1862 + 19) > (445 + 848)) and (v46 or v45)) then
					local v191 = v112();
					if (((5735 - 3378) == (2790 - (114 + 319))) and v191) then
						return v191;
					end
				end
				v139 = v111();
				v138 = 1 - 0;
			end
			if (((157 - 34) == (79 + 44)) and (v138 == (4 - 1))) then
				if (v139 or ((2212 - 1156) >= (5355 - (556 + 1407)))) then
					return v139;
				end
				v139 = v119();
				v138 = 1210 - (741 + 465);
			end
			if ((v138 == (467 - (170 + 295))) or ((570 + 511) < (988 + 87))) then
				if (v139 or ((2582 - 1533) >= (3674 + 758))) then
					return v139;
				end
				v139 = v113();
				v138 = 2 + 1;
			end
			if ((v138 == (3 + 1)) or ((5998 - (957 + 273)) <= (227 + 619))) then
				if (v139 or ((1345 + 2013) <= (5410 - 3990))) then
					return v139;
				end
				if (v27.TargetIsValid() or ((9852 - 6113) <= (9178 - 6173))) then
					local v192 = 0 - 0;
					local v193;
					while true do
						if ((v192 == (1780 - (389 + 1391))) or ((1041 + 618) >= (223 + 1911))) then
							v193 = v115();
							if (v193 or ((7421 - 4161) < (3306 - (783 + 168)))) then
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
	local function v121()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (0 + 0)) or ((980 - (309 + 2)) == (12968 - 8745))) then
				if (v46 or v45 or ((2904 - (1090 + 122)) < (191 + 397))) then
					local v194 = 0 - 0;
					local v195;
					while true do
						if ((v194 == (0 + 0)) or ((5915 - (628 + 490)) < (655 + 2996))) then
							v195 = v112();
							if (v195 or ((10341 - 6164) > (22164 - 17314))) then
								return v195;
							end
							break;
						end
					end
				end
				if (v36 or ((1174 - (431 + 343)) > (2243 - 1132))) then
					local v196 = 0 - 0;
					local v197;
					while true do
						if (((2411 + 640) > (129 + 876)) and (v196 == (1696 - (556 + 1139)))) then
							if (((3708 - (6 + 9)) <= (803 + 3579)) and v44 and v93.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v93.BlessingoftheBronzeBuff, true) or v27.GroupBuffMissing(v93.BlessingoftheBronzeBuff))) then
								if (v25(v93.BlessingoftheBronze) or ((1682 + 1600) > (4269 - (28 + 141)))) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (v27.TargetIsValid() or ((1387 + 2193) < (3509 - 665))) then
								local v204 = v110();
								if (((64 + 25) < (5807 - (486 + 831))) and v204) then
									return v204;
								end
							end
							break;
						end
						if ((v196 == (0 - 0)) or ((17543 - 12560) < (342 + 1466))) then
							v197 = v119();
							if (((12107 - 8278) > (5032 - (668 + 595))) and v197) then
								return v197;
							end
							v196 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v141 = 0 + 0;
		while true do
			if (((4049 - 2564) <= (3194 - (23 + 267))) and (v141 == (1944 - (1129 + 815)))) then
				v40 = EpicSettings.Settings['UseRacials'];
				v41 = EpicSettings.Settings['UseHealingPotion'];
				v42 = EpicSettings.Settings['HealingPotionName'] or (387 - (371 + 16));
				v43 = EpicSettings.Settings['HealingPotionHP'] or (1750 - (1326 + 424));
				v44 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 - 0);
				v141 = 3 - 2;
			end
			if (((4387 - (88 + 30)) == (5040 - (720 + 51))) and (v141 == (11 - 6))) then
				v65 = EpicSettings.Settings['UseRewind'];
				v66 = EpicSettings.Settings['RewindHP'] or (1776 - (421 + 1355));
				v67 = EpicSettings.Settings['RewindGroup'] or (0 - 0);
				v68 = EpicSettings.Settings['UseTimeDilation'];
				v69 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
				v141 = 1089 - (286 + 797);
			end
			if (((1414 - 1027) <= (4607 - 1825)) and (v141 == (443 - (397 + 42)))) then
				v60 = EpicSettings.Settings['DreamBreathHP'] or (0 + 0);
				v61 = EpicSettings.Settings['DreamBreathGroup'] or (800 - (24 + 776));
				v62 = EpicSettings.Settings['UseSpiritbloom'];
				v63 = EpicSettings.Settings['SpiritbloomHP'] or (0 - 0);
				v64 = EpicSettings.Settings['SpiritbloomGroup'] or (785 - (222 + 563));
				v141 = 11 - 6;
			end
			if ((v141 == (6 + 1)) or ((2089 - (23 + 167)) <= (2715 - (690 + 1108)))) then
				v75 = EpicSettings.Settings['UseLivingFlame'];
				v76 = EpicSettings.Settings['LivingFlameHP'] or (0 + 0);
				v77 = EpicSettings.Settings['UseReversion'];
				v78 = EpicSettings.Settings['ReversionHP'] or (0 + 0);
				v79 = EpicSettings.Settings['ReversionTankHP'] or (848 - (40 + 808));
				v141 = 2 + 6;
			end
			if ((v141 == (34 - 25)) or ((4122 + 190) <= (464 + 412))) then
				v85 = EpicSettings.Settings['UseOppressingRoar'];
				v86 = EpicSettings.Settings['UseRenewingBlaze'];
				v87 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v88 = EpicSettings.Settings['UseHover'];
				v89 = EpicSettings.Settings['HoverTime'] or (571 - (47 + 524));
				break;
			end
			if (((1449 + 783) <= (7096 - 4500)) and (v141 == (1 - 0))) then
				v45 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
				v46 = EpicSettings.Settings['DispelBuffs'] or (1726 - (1165 + 561));
				v47 = EpicSettings.Settings['UseHealthstone'];
				v48 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v49 = EpicSettings.Settings['HandleCharredTreant'] or (0 - 0);
				v141 = 1 + 1;
			end
			if (((2574 - (341 + 138)) < (996 + 2690)) and (v141 == (16 - 8))) then
				v80 = EpicSettings.Settings['UseTemporalAnomaly'];
				v81 = EpicSettings.Settings['TemporalAnomalyHP'] or (326 - (89 + 237));
				v82 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 - 0);
				v83 = EpicSettings.Settings['UseEcho'];
				v84 = EpicSettings.Settings['EchoHP'] or (0 - 0);
				v141 = 890 - (581 + 300);
			end
			if (((1223 - (855 + 365)) == v141) or ((3788 - 2193) >= (1461 + 3013))) then
				v55 = EpicSettings.Settings['ObsidianScalesHP'] or (1235 - (1030 + 205));
				v56 = EpicSettings.Settings['UseStasis'];
				v57 = EpicSettings.Settings['StasisHP'] or (0 + 0);
				v58 = EpicSettings.Settings['StasisGroup'] or (0 + 0);
				v59 = EpicSettings.Settings['UseDreamBreath'];
				v141 = 290 - (156 + 130);
			end
			if (((13 - 7) == v141) or ((7784 - 3165) < (5902 - 3020))) then
				v70 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v71 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
				v72 = EpicSettings.Settings['UseEmeraldBlossom'];
				v73 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
				v74 = EpicSettings.Settings['EmeraldBlossomGroup'] or (69 - (10 + 59));
				v141 = 2 + 5;
			end
			if (((9 - 7) == v141) or ((1457 - (671 + 492)) >= (3846 + 985))) then
				v50 = EpicSettings.Settings['HandleCharredBrambles'] or (1215 - (369 + 846));
				v51 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v52 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v53 = EpicSettings.Settings['InterruptThreshold'] or (1945 - (1036 + 909));
				v54 = EpicSettings.Settings['UseObsidianScales'];
				v141 = 3 + 0;
			end
		end
	end
	local function v123()
		local v142 = 0 - 0;
		while true do
			if (((2232 - (11 + 192)) <= (1559 + 1525)) and (v142 == (175 - (135 + 40)))) then
				v90 = EpicSettings.Settings['DreamFlightUsage'] or "";
				v91 = EpicSettings.Settings['DreamFlightHP'] or (0 - 0);
				v142 = 1 + 0;
			end
			if ((v142 == (2 - 1)) or ((3052 - 1015) == (2596 - (50 + 126)))) then
				v92 = EpicSettings.Settings['DreamFlightGroup'] or (0 - 0);
				break;
			end
		end
	end
	local function v124()
		v122();
		v123();
		if (((987 + 3471) > (5317 - (1233 + 180))) and v13:IsDeadOrGhost()) then
			return;
		end
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		v39 = EpicSettings.Toggles['dispel'];
		if (((1405 - (522 + 447)) >= (1544 - (107 + 1314))) and v13:IsMounted()) then
			return;
		end
		if (((233 + 267) < (5533 - 3717)) and not v13:IsMoving()) then
			v32 = GetTime();
		end
		if (((1518 + 2056) == (7096 - 3522)) and (v13:AffectingCombat() or v45 or v36)) then
			local v149 = 0 - 0;
			local v150;
			local v151;
			while true do
				if (((2131 - (716 + 1194)) < (7 + 383)) and (v149 == (1 + 0))) then
					if (v151 or ((2716 - (74 + 429)) <= (2741 - 1320))) then
						return v151;
					end
					break;
				end
				if (((1516 + 1542) < (11125 - 6265)) and ((0 + 0) == v149)) then
					v150 = v45 and v93.Expunge:IsReady();
					v151 = v27.FocusUnit(v150, nil, 123 - 83, nil, 49 - 29, v93.Echo);
					v149 = 434 - (279 + 154);
				end
			end
		end
		if (v49 or ((2074 - (454 + 324)) >= (3498 + 948))) then
			local v152 = 17 - (12 + 5);
			local v153;
			while true do
				if ((v152 == (1 + 0)) or ((3548 - 2155) > (1659 + 2830))) then
					v153 = v27.HandleCharredTreant(v93.LivingFlame, v95.LivingFlameMouseover, 1133 - (277 + 816), true);
					if (v153 or ((18904 - 14480) < (1210 - (1058 + 125)))) then
						return v153;
					end
					break;
				end
				if (((0 + 0) == v152) or ((2972 - (815 + 160)) > (16368 - 12553))) then
					v153 = v27.HandleCharredTreant(v93.Echo, v95.EchoMouseover, 94 - 54);
					if (((827 + 2638) > (5591 - 3678)) and v153) then
						return v153;
					end
					v152 = 1899 - (41 + 1857);
				end
			end
		end
		if (((2626 - (1222 + 671)) < (4701 - 2882)) and v50) then
			local v154 = 0 - 0;
			local v155;
			while true do
				if (((1183 - (229 + 953)) == v154) or ((6169 - (1111 + 663)) == (6334 - (874 + 705)))) then
					v155 = v27.HandleCharredBrambles(v93.LivingFlame, v95.LivingFlameMouseover, 6 + 34, true);
					if (v155 or ((2588 + 1205) < (4923 - 2554))) then
						return v155;
					end
					break;
				end
				if ((v154 == (0 + 0)) or ((4763 - (642 + 37)) == (61 + 204))) then
					v155 = v27.HandleCharredBrambles(v93.Echo, v95.EchoMouseover, 7 + 33);
					if (((10941 - 6583) == (4812 - (233 + 221))) and v155) then
						return v155;
					end
					v154 = 2 - 1;
				end
			end
		end
		if ((v88 and (v36 or v13:AffectingCombat())) or ((2762 + 376) < (2534 - (718 + 823)))) then
			if (((2096 + 1234) > (3128 - (266 + 539))) and ((GetTime() - v32) > v89)) then
				if ((v93.Hover:IsReady() and v13:BuffDown(v93.Hover)) or ((10265 - 6639) == (5214 - (636 + 589)))) then
					if (v25(v93.Hover) or ((2174 - 1258) == (5508 - 2837))) then
						return "hover main 2";
					end
				end
			end
		end
		v105 = v13:BuffRemains(v93.HoverBuff) < (2 + 0);
		v109 = v27.FriendlyUnitsBelowHealthPercentageCount(31 + 54);
		v100 = v13:GetEnemiesInRange(1040 - (657 + 358));
		v101 = v14:GetEnemiesInSplashRange(21 - 13);
		if (((619 - 347) == (1459 - (1151 + 36))) and v37) then
			v102 = #v101;
		else
			v102 = 1 + 0;
		end
		if (((1118 + 3131) <= (14451 - 9612)) and (v27.TargetIsValid() or v13:AffectingCombat())) then
			local v156 = 1832 - (1552 + 280);
			while true do
				if (((3611 - (64 + 770)) < (2173 + 1027)) and ((2 - 1) == v156)) then
					if (((17 + 78) < (3200 - (157 + 1086))) and (v104 == (22239 - 11128))) then
						v104 = v9.FightRemains(v100, false);
					end
					break;
				end
				if (((3617 - 2791) < (2633 - 916)) and (v156 == (0 - 0))) then
					v103 = v9.BossFightRemains(nil, true);
					v104 = v103;
					v156 = 820 - (599 + 220);
				end
			end
		end
		if (((2839 - 1413) >= (3036 - (1813 + 118))) and v13:IsChanneling(v93.FireBreath)) then
			local v157 = GetTime() - v13:CastStart();
			if (((2014 + 740) <= (4596 - (841 + 376))) and (v157 >= v13:EmpowerCastTime(v33))) then
				local v183 = 0 - 0;
				while true do
					if ((v183 == (0 + 0)) or ((10718 - 6791) == (2272 - (464 + 395)))) then
						v9.EpicSettingsS = v93.FireBreath.ReturnID;
						return "Stopping Fire Breath";
					end
				end
			end
		end
		if (v13:IsChanneling(v93.DreamBreath) or ((2961 - 1807) <= (379 + 409))) then
			local v158 = 837 - (467 + 370);
			local v159;
			while true do
				if (((0 - 0) == v158) or ((1207 + 436) > (11583 - 8204))) then
					v159 = GetTime() - v13:CastStart();
					if ((v159 >= v13:EmpowerCastTime(v34)) or ((438 + 2365) > (10583 - 6034))) then
						local v201 = 520 - (150 + 370);
						while true do
							if (((1282 - (74 + 1208)) == v201) or ((541 - 321) >= (14332 - 11310))) then
								v9.EpicSettingsS = v93.DreamBreath.ReturnID;
								return "Stopping DreamBreath";
							end
						end
					end
					break;
				end
			end
		end
		if (((2009 + 813) == (3212 - (14 + 376))) and v13:IsChanneling(v93.Spiritbloom)) then
			local v160 = 0 - 0;
			local v161;
			while true do
				if ((v160 == (0 + 0)) or ((933 + 128) == (1772 + 85))) then
					v161 = GetTime() - v13:CastStart();
					if (((8087 - 5327) > (1027 + 337)) and (v161 >= v13:EmpowerCastTime(v35))) then
						local v202 = 78 - (23 + 55);
						while true do
							if ((v202 == (0 - 0)) or ((3272 + 1630) <= (3229 + 366))) then
								v9.EpicSettingsS = v93.Spiritbloom.ReturnID;
								return "Stopping Spiritbloom";
							end
						end
					end
					break;
				end
			end
		end
		if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((5972 - 2120) == (93 + 200))) then
			local v162 = 901 - (652 + 249);
			local v163;
			while true do
				if ((v162 == (0 - 0)) or ((3427 - (708 + 1160)) == (12453 - 7865))) then
					v163 = v27.DeadFriendlyUnitsCount();
					if (not v13:AffectingCombat() or ((8174 - 3690) == (815 - (10 + 17)))) then
						if (((1026 + 3542) >= (5639 - (1400 + 332))) and (v163 > (1 - 0))) then
							if (((3154 - (242 + 1666)) < (1485 + 1985)) and v25(v93.MassReturn, nil, true)) then
								return "mass_return";
							end
						elseif (((1491 + 2577) >= (829 + 143)) and v25(v93.Return, not v14:IsInRange(970 - (850 + 90)), true)) then
							return "return";
						end
					end
					break;
				end
			end
		end
		if (((862 - 369) < (5283 - (360 + 1030))) and not v13:IsChanneling()) then
			if (v13:AffectingCombat() or ((1304 + 169) >= (9404 - 6072))) then
				local v184 = v120();
				if (v184 or ((5573 - 1522) <= (2818 - (909 + 752)))) then
					return v184;
				end
			else
				local v185 = 1223 - (109 + 1114);
				local v186;
				while true do
					if (((1105 - 501) < (1122 + 1759)) and (v185 == (242 - (6 + 236)))) then
						v186 = v121();
						if (v186 or ((568 + 332) == (2719 + 658))) then
							return v186;
						end
						break;
					end
				end
			end
		end
	end
	local function v125()
		local v147 = 0 - 0;
		while true do
			if (((7787 - 3328) > (1724 - (1076 + 57))) and (v147 == (1 + 1))) then
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableCurseDebuffs);
				break;
			end
			if (((4087 - (579 + 110)) >= (190 + 2205)) and (v147 == (0 + 0))) then
				v20.Print("Preservation Evoker by Epic BoomK");
				EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
				v147 = 1 + 0;
			end
			if ((v147 == (408 - (174 + 233))) or ((6097 - 3914) >= (4956 - 2132))) then
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableMagicDebuffs);
				v27.DispellableDebuffs = v11.MergeTable(v27.DispellableDebuffs, v27.DispellableDiseaseDebuffs);
				v147 = 1 + 1;
			end
		end
	end
	v20.SetAPL(2642 - (663 + 511), v124, v125);
end;
return v0["Epix_Evoker_Preservation.lua"]();

