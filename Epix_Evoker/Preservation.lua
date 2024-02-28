local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((2977 - (437 + 910)) > (4667 - (270 + 199)))) then
			v6 = v0[v4];
			if (((342 + 712) == (2873 - (580 + 1239))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((25 + 651) >= (716 + 926))) then
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
	local v32 = GetUnitEmpowerStageDuration;
	local v33 = 0 - 0;
	local v34 = 1 + 0;
	local v35 = 1168 - (645 + 522);
	local v36 = 1791 - (1010 + 780);
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
	local v99 = (v98[13 + 0] and v20(v98[61 - 48])) or v20(0 - 0);
	local v100 = (v98[1850 - (1045 + 791)] and v20(v98[34 - 20])) or v20(0 - 0);
	local v101;
	local v102;
	local v103;
	local v104 = 11616 - (351 + 154);
	local v105 = 12685 - (1281 + 293);
	local v106;
	local v107 = 266 - (28 + 238);
	local v108 = 0 - 0;
	local v109 = 1559 - (1381 + 178);
	local v110 = 0 + 0;
	v10:RegisterForEvent(function()
		v98 = v14:GetEquipment();
		v99 = (v98[11 + 2] and v20(v98[6 + 7])) or v20(0 - 0);
		v100 = (v98[8 + 6] and v20(v98[484 - (381 + 89)])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v127 = 0 + 0;
		while true do
			if (((7084 - 2948) > (3553 - (1074 + 82))) and (v127 == (0 - 0))) then
				v104 = 12895 - (214 + 1570);
				v105 = 12566 - (990 + 465);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (v94.LivingFlame:IsCastable() or ((1787 + 2547) == (1848 + 2397))) then
			if (v26(v94.LivingFlame, not v15:IsInRange(25 + 0), v106) or ((16828 - 12552) <= (4757 - (1668 + 58)))) then
				return "living_flame precombat";
			end
		end
		if (v94.AzureStrike:IsCastable() or ((5408 - (512 + 114)) <= (3125 - 1926))) then
			if (v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike)) or ((10055 - 5191) < (6618 - 4716))) then
				return "azure_strike precombat";
			end
		end
	end
	local function v112()
		local v128 = 0 + 0;
		while true do
			if (((906 + 3933) >= (3217 + 483)) and ((3 - 2) == v128)) then
				if ((v42 and (v14:HealthPercentage() <= v44)) or ((3069 - (109 + 1885)) > (3387 - (1269 + 200)))) then
					if (((758 - 362) <= (4619 - (98 + 717))) and (v43 == "Refreshing Healing Potion")) then
						if (v95.RefreshingHealingPotion:IsReady() or ((4995 - (802 + 24)) == (3770 - 1583))) then
							if (((1775 - 369) == (208 + 1198)) and v26(v96.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				if (((1177 + 354) < (702 + 3569)) and v94.RenewingBlaze:IsCastable() and (v14:HealthPercentage() < v88) and v87) then
					if (((137 + 498) == (1766 - 1131)) and v22(v94.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze defensive";
					end
				end
				break;
			end
			if (((11247 - 7874) <= (1272 + 2284)) and (v128 == (0 + 0))) then
				if ((v94.ObsidianScales:IsCastable() and v55 and v14:BuffDown(v94.ObsidianScales) and (v14:HealthPercentage() < v56)) or ((2715 + 576) < (2385 + 895))) then
					if (((2048 + 2338) >= (2306 - (797 + 636))) and v26(v94.ObsidianScales)) then
						return "obsidian_scales defensives";
					end
				end
				if (((4471 - 3550) <= (2721 - (1427 + 192))) and v95.Healthstone:IsReady() and v48 and (v14:HealthPercentage() <= v49)) then
					if (((1631 + 3075) >= (2235 - 1272)) and v26(v96.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v113()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (327 - (192 + 134))) or ((2236 - (316 + 960)) <= (488 + 388))) then
				if ((v94.OppressingRoar:IsReady() and v86 and v28.UnitHasEnrageBuff(v15)) or ((1595 + 471) == (862 + 70))) then
					if (((18445 - 13620) < (5394 - (83 + 468))) and v26(v94.OppressingRoar)) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if ((v129 == (1806 - (1202 + 604))) or ((18098 - 14221) >= (7550 - 3013))) then
				if ((v94.Expunge:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or ((11947 - 7632) < (2051 - (45 + 280)))) then
					if (v26(v96.ExpungeFocus) or ((3551 + 128) < (547 + 78))) then
						return "expunge dispel";
					end
				end
				if ((v94.CauterizingFlame:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or ((1689 + 2936) < (350 + 282))) then
					if (v26(v96.CauterizingFlameFocus) or ((15 + 68) > (3296 - 1516))) then
						return "cauterizing_flame dispel";
					end
				end
				v129 = 1912 - (340 + 1571);
			end
		end
	end
	local function v114()
		if (((216 + 330) <= (2849 - (1733 + 39))) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v147 = v28.Interrupt(v94.Quell, 27 - 17, true);
			if (v147 or ((2030 - (125 + 909)) > (6249 - (1096 + 852)))) then
				return v147;
			end
			v147 = v28.InterruptWithStun(v94.TailSwipe, 4 + 4);
			if (((5812 - 1742) > (667 + 20)) and v147) then
				return v147;
			end
			v147 = v28.Interrupt(v94.Quell, 522 - (409 + 103), true, v17, v96.QuellMouseover);
			if (v147 or ((892 - (46 + 190)) >= (3425 - (51 + 44)))) then
				return v147;
			end
		end
	end
	local function v115()
		local v130 = 0 + 0;
		local v131;
		while true do
			if ((v130 == (1318 - (1114 + 203))) or ((3218 - (228 + 498)) <= (73 + 262))) then
				v131 = v28.HandleBottomTrinket(v97, v39, 23 + 17, nil);
				if (((4985 - (174 + 489)) >= (6674 - 4112)) and v131) then
					return v131;
				end
				break;
			end
			if ((v130 == (1905 - (830 + 1075))) or ((4161 - (303 + 221)) >= (5039 - (231 + 1038)))) then
				v131 = v28.HandleTopTrinket(v97, v39, 34 + 6, nil);
				if (v131 or ((3541 - (171 + 991)) > (18866 - 14288))) then
					return v131;
				end
				v130 = 2 - 1;
			end
		end
	end
	local function v116()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (2 + 0)) or ((1692 - 1209) > (2143 - 1400))) then
				if (((3955 - 1501) > (1786 - 1208)) and v94.AzureStrike:IsCastable()) then
					if (((2178 - (111 + 1137)) < (4616 - (91 + 67))) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
						return "azure_strike damage";
					end
				end
				break;
			end
			if (((1970 - 1308) <= (243 + 729)) and (v132 == (523 - (423 + 100)))) then
				if (((31 + 4339) == (12099 - 7729)) and v94.LivingFlame:IsCastable() and v14:BuffUp(v94.LeapingFlamesBuff)) then
					if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((2483 + 2279) <= (1632 - (326 + 445)))) then
						return "living_flame_leaping_flames damage";
					end
				end
				if (v94.FireBreath:IsReady() or ((6161 - 4749) == (9499 - 5235))) then
					local v187 = 0 - 0;
					while true do
						if ((v187 == (711 - (530 + 181))) or ((4049 - (614 + 267)) < (2185 - (19 + 13)))) then
							if ((v103 <= (2 - 0)) or ((11595 - 6619) < (3804 - 2472))) then
								v107 = 1 + 0;
							elseif (((8138 - 3510) == (9597 - 4969)) and (v103 <= (1816 - (1293 + 519)))) then
								v107 = 3 - 1;
							elseif ((v103 <= (15 - 9)) or ((102 - 48) == (1703 - 1308))) then
								v107 = 6 - 3;
							else
								v107 = 3 + 1;
							end
							v34 = v107;
							v187 = 1 + 0;
						end
						if (((190 - 108) == (19 + 63)) and (v187 == (1 + 0))) then
							if (v26(v96.FireBreathMacro, not v15:IsInRange(19 + 11), true, nil, true) or ((1677 - (709 + 387)) < (2140 - (673 + 1185)))) then
								return "fire_breath damage " .. v107;
							end
							break;
						end
					end
				end
				v132 = 2 - 1;
			end
			if ((v132 == (3 - 2)) or ((7582 - 2973) < (1785 + 710))) then
				if (((861 + 291) == (1554 - 402)) and v94.Disintegrate:IsReady() and v14:BuffUp(v94.EssenceBurstBuff)) then
					if (((466 + 1430) <= (6822 - 3400)) and v26(v94.Disintegrate, not v15:IsSpellInRange(v94.Disintegrate), v106)) then
						return "disintegrate damage";
					end
				end
				if (v94.LivingFlame:IsCastable() or ((1943 - 953) > (3500 - (446 + 1434)))) then
					if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or ((2160 - (1040 + 243)) > (14012 - 9317))) then
						return "living_flame damage";
					end
				end
				v132 = 1849 - (559 + 1288);
			end
		end
	end
	local function v117()
		local v133 = 1931 - (609 + 1322);
		local v134;
		while true do
			if (((3145 - (13 + 441)) >= (6916 - 5065)) and ((0 - 0) == v133)) then
				v134 = v115();
				if (v134 or ((14866 - 11881) >= (181 + 4675))) then
					return v134;
				end
				v133 = 3 - 2;
			end
			if (((1519 + 2757) >= (524 + 671)) and (v133 == (2 - 1))) then
				if (((1769 + 1463) <= (8625 - 3935)) and v94.Stasis:IsReady() and v57 and v28.AreUnitsBelowHealthPercentage(v58, v59)) then
					if (v26(v94.Stasis) or ((593 + 303) >= (1750 + 1396))) then
						return "stasis cooldown";
					end
				end
				if (((2200 + 861) >= (2484 + 474)) and v94.StasisReactivate:IsReady() and v57 and (v28.AreUnitsBelowHealthPercentage(v58, v59) or (v14:BuffUp(v94.StasisBuff) and (v14:BuffRemains(v94.StasisBuff) < (3 + 0))))) then
					if (((3620 - (153 + 280)) >= (1859 - 1215)) and v26(v94.StasisReactivate)) then
						return "stasis_reactivate cooldown";
					end
				end
				v133 = 2 + 0;
			end
			if (((255 + 389) <= (369 + 335)) and (v133 == (3 + 0))) then
				if (((695 + 263) > (1441 - 494)) and v94.DreamFlight:IsCastable() and (v91 == "Confirmation") and v28.AreUnitsBelowHealthPercentage(v92, v93)) then
					if (((2777 + 1715) >= (3321 - (89 + 578))) and v26(v94.DreamFlight)) then
						return "Dream_Flight cooldown";
					end
				end
				if (((2459 + 983) >= (3124 - 1621)) and v94.Rewind:IsCastable() and v66 and v28.AreUnitsBelowHealthPercentage(v67, v68)) then
					if (v26(v94.Rewind) or ((4219 - (572 + 477)) <= (198 + 1266))) then
						return "rewind cooldown";
					end
				end
				v133 = 3 + 1;
			end
			if (((1 + 1) == v133) or ((4883 - (84 + 2)) == (7231 - 2843))) then
				if (((397 + 154) <= (1523 - (497 + 345))) and v94.TipTheScales:IsCastable()) then
					if (((84 + 3193) > (69 + 338)) and v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) then
						local v192 = 1333 - (605 + 728);
						while true do
							if (((3350 + 1345) >= (3145 - 1730)) and (v192 == (0 + 0))) then
								v35 = 3 - 2;
								if (v26(v96.TipTheScalesDreamBreath) or ((2896 + 316) <= (2615 - 1671))) then
									return "dream_breath cooldown";
								end
								break;
							end
						end
					elseif ((v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) or ((2338 + 758) <= (2287 - (457 + 32)))) then
						local v196 = 0 + 0;
						while true do
							if (((4939 - (832 + 570)) == (3333 + 204)) and (v196 == (0 + 0))) then
								v36 = 10 - 7;
								if (((1849 + 1988) >= (2366 - (588 + 208))) and v26(v96.TipTheScalesSpiritbloom)) then
									return "spirit_bloom cooldown";
								end
								break;
							end
						end
					end
				end
				if ((v94.DreamFlight:IsCastable() and (v91 == "At Cursor") and v28.AreUnitsBelowHealthPercentage(v92, v93)) or ((7950 - 5000) == (5612 - (884 + 916)))) then
					if (((9887 - 5164) >= (1345 + 973)) and v26(v96.DreamFlightCursor)) then
						return "Dream_Flight cooldown";
					end
				end
				v133 = 656 - (232 + 421);
			end
			if ((v133 == (1893 - (1569 + 320))) or ((498 + 1529) > (542 + 2310))) then
				if ((v94.TimeDilation:IsCastable() and v69 and (v16:HealthPercentage() <= v70)) or ((3828 - 2692) > (4922 - (316 + 289)))) then
					if (((12428 - 7680) == (220 + 4528)) and v26(v96.TimeDilationFocus)) then
						return "time_dilation cooldown";
					end
				end
				if (((5189 - (666 + 787)) <= (5165 - (360 + 65))) and v94.FireBreath:IsReady()) then
					if ((v103 <= (2 + 0)) or ((3644 - (79 + 175)) <= (4825 - 1765))) then
						v107 = 1 + 0;
					elseif ((v103 <= (12 - 8)) or ((1923 - 924) > (3592 - (503 + 396)))) then
						v107 = 183 - (92 + 89);
					elseif (((897 - 434) < (309 + 292)) and (v103 <= (4 + 2))) then
						v107 = 11 - 8;
					else
						v107 = 1 + 3;
					end
					v34 = v107;
					if (v26(v96.FireBreathMacro, not v15:IsInRange(68 - 38), true, nil, true) or ((1905 + 278) < (329 + 358))) then
						return "fire_breath cds " .. v107;
					end
				end
				break;
			end
		end
	end
	local function v118()
		if (((13854 - 9305) == (568 + 3981)) and v94.EmeraldBlossom:IsCastable() and v73 and v28.AreUnitsBelowHealthPercentage(v74, v75)) then
			if (((7124 - 2452) == (5916 - (485 + 759))) and v26(v96.EmeraldBlossomFocus)) then
				return "emerald_blossom aoe_healing";
			end
		end
		if ((v71 == "Player Only") or ((8487 - 4819) < (1584 - (442 + 747)))) then
			if ((v94.VerdantEmbrace:IsReady() and (v14:HealthPercentage() < v72)) or ((5301 - (832 + 303)) == (1401 - (88 + 858)))) then
				if (v22(v96.VerdantEmbracePlayer, nil) or ((1356 + 3093) == (2204 + 459))) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v71 == "Everyone") or ((177 + 4100) < (3778 - (766 + 23)))) then
			if ((v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72)) or ((4294 - 3424) >= (5673 - 1524))) then
				if (((5827 - 3615) < (10803 - 7620)) and v22(v96.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if (((5719 - (1036 + 37)) > (2122 + 870)) and (v71 == "Not Tank")) then
			if (((2792 - 1358) < (2444 + 662)) and v94.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v72) and (v28.UnitGroupRole(v16) ~= "TANK")) then
				if (((2266 - (641 + 839)) < (3936 - (910 + 3))) and v22(v96.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace aoe_healing";
				end
			end
		end
		if ((v94.DreamBreath:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) or ((6225 - 3783) < (1758 - (1466 + 218)))) then
			local v148 = 0 + 0;
			while true do
				if (((5683 - (556 + 592)) == (1613 + 2922)) and (v148 == (809 - (329 + 479)))) then
					if (v26(v96.DreamBreathMacro, nil, true) or ((3863 - (174 + 680)) <= (7233 - 5128))) then
						return "dream_breath aoe_healing";
					end
					break;
				end
				if (((3793 - 1963) < (2620 + 1049)) and (v148 == (739 - (396 + 343)))) then
					if ((v110 <= (1 + 1)) or ((2907 - (29 + 1448)) >= (5001 - (135 + 1254)))) then
						v108 = 3 - 2;
					else
						v108 = 9 - 7;
					end
					v35 = v108;
					v148 = 1 + 0;
				end
			end
		end
		if (((4210 - (389 + 1138)) >= (3034 - (102 + 472))) and v94.Spiritbloom:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) then
			local v149 = 0 + 0;
			while true do
				if ((v149 == (1 + 0)) or ((1683 + 121) >= (4820 - (320 + 1225)))) then
					if (v26(v96.SpiritbloomFocus, nil, true) or ((2521 - 1104) > (2221 + 1408))) then
						return "spirit_bloom aoe_healing";
					end
					break;
				end
				if (((6259 - (157 + 1307)) > (2261 - (821 + 1038))) and (v149 == (0 - 0))) then
					if (((527 + 4286) > (6332 - 2767)) and (v110 > (1 + 1))) then
						v109 = 7 - 4;
					else
						v109 = 1027 - (834 + 192);
					end
					v36 = 1 + 2;
					v149 = 1 + 0;
				end
			end
		end
		if (((84 + 3828) == (6059 - 2147)) and v94.LivingFlame:IsCastable() and v76 and v14:BuffUp(v94.LeapingFlamesBuff) and (v16:HealthPercentage() <= v77)) then
			if (((3125 - (300 + 4)) <= (1289 + 3535)) and v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106)) then
				return "living_flame_leaping_flames aoe_healing";
			end
		end
	end
	local function v119()
		local v135 = 0 - 0;
		while true do
			if (((2100 - (112 + 250)) <= (876 + 1319)) and (v135 == (2 - 1))) then
				if (((24 + 17) <= (1561 + 1457)) and v94.TemporalAnomaly:IsReady() and v81 and v28.AreUnitsBelowHealthPercentage(v82, v83)) then
					if (((1605 + 540) <= (2035 + 2069)) and v26(v94.TemporalAnomaly, not v16:IsInRange(23 + 7), v106)) then
						return "temporal_anomaly st_healing";
					end
				end
				if (((4103 - (1001 + 413)) < (10804 - 5959)) and v94.Echo:IsReady() and v84 and not v16:BuffUp(v94.Echo) and (v16:HealthPercentage() <= v85)) then
					if (v26(v96.EchoFocus) or ((3204 - (244 + 638)) > (3315 - (627 + 66)))) then
						return "echo st_healing";
					end
				end
				v135 = 5 - 3;
			end
			if (((602 - (512 + 90)) == v135) or ((6440 - (1665 + 241)) == (2799 - (373 + 344)))) then
				if ((v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) ~= "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion) < (1 + 0)) and (v16:HealthPercentage() <= v79)) or ((416 + 1155) > (4924 - 3057))) then
					if (v26(v96.ReversionFocus) or ((4491 - 1837) >= (4095 - (35 + 1064)))) then
						return "reversion_tank st_healing";
					end
				end
				if (((2895 + 1083) > (4501 - 2397)) and v94.Reversion:IsReady() and v78 and (v28.UnitGroupRole(v16) == "TANK") and (v28.FriendlyUnitsWithBuffCount(v94.Reversion, true, false) < (1 + 0)) and (v16:HealthPercentage() <= v80)) then
					if (((4231 - (298 + 938)) > (2800 - (233 + 1026))) and v26(v96.ReversionFocus)) then
						return "reversion_tank st_healing";
					end
				end
				v135 = 1667 - (636 + 1030);
			end
			if (((1662 + 1587) > (931 + 22)) and ((1 + 1) == v135)) then
				if ((v94.LivingFlame:IsReady() and v76 and (v16:HealthPercentage() <= v77)) or ((222 + 3051) > (4794 - (55 + 166)))) then
					if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or ((611 + 2540) < (130 + 1154))) then
						return "living_flame st_healing";
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v136 = v118();
		if (v136 or ((7065 - 5215) == (1826 - (36 + 261)))) then
			return v136;
		end
		v136 = v119();
		if (((1435 - 614) < (3491 - (34 + 1334))) and v136) then
			return v136;
		end
	end
	local function v121()
		if (((347 + 555) < (1807 + 518)) and (v47 or v46)) then
			local v150 = v113();
			if (((2141 - (1035 + 248)) <= (2983 - (20 + 1))) and v150) then
				return v150;
			end
		end
		local v137 = v112();
		if (v137 or ((2056 + 1890) < (1607 - (134 + 185)))) then
			return v137;
		end
		local v137 = v117();
		if (v137 or ((4375 - (549 + 584)) == (1252 - (314 + 371)))) then
			return v137;
		end
		local v137 = v114();
		if (v137 or ((2907 - 2060) >= (2231 - (478 + 490)))) then
			return v137;
		end
		local v137 = v120();
		if (v137 or ((1194 + 1059) == (3023 - (786 + 386)))) then
			return v137;
		end
		if (v28.TargetIsValid() or ((6759 - 4672) > (3751 - (1055 + 324)))) then
			local v151 = 1340 - (1093 + 247);
			local v152;
			while true do
				if ((v151 == (0 + 0)) or ((468 + 3977) < (16472 - 12323))) then
					v152 = v116();
					if (v152 or ((6169 - 4351) == (241 - 156))) then
						return v152;
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v138 = 0 - 0;
		while true do
			if (((225 + 405) < (8194 - 6067)) and (v138 == (0 - 0))) then
				if (v47 or v46 or ((1462 + 476) == (6428 - 3914))) then
					local v188 = 688 - (364 + 324);
					local v189;
					while true do
						if (((11664 - 7409) >= (131 - 76)) and (v188 == (0 + 0))) then
							v189 = v113();
							if (((12548 - 9549) > (1851 - 695)) and v189) then
								return v189;
							end
							break;
						end
					end
				end
				if (((7137 - 4787) > (2423 - (1249 + 19))) and v37) then
					local v190 = 0 + 0;
					local v191;
					while true do
						if (((15682 - 11653) <= (5939 - (686 + 400))) and (v190 == (1 + 0))) then
							if ((v45 and v94.BlessingoftheBronze:IsCastable() and (v14:BuffDown(v94.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v94.BlessingoftheBronzeBuff))) or ((745 - (73 + 156)) > (17 + 3417))) then
								if (((4857 - (721 + 90)) >= (35 + 2998)) and v26(v94.BlessingoftheBronze)) then
									return "blessing_of_the_bronze precombat";
								end
							end
							if (v28.TargetIsValid() or ((8828 - 6109) <= (1917 - (224 + 246)))) then
								local v197 = v111();
								if (v197 or ((6696 - 2562) < (7228 - 3302))) then
									return v197;
								end
							end
							break;
						end
						if ((v190 == (0 + 0)) or ((4 + 160) >= (2046 + 739))) then
							v191 = v120();
							if (v191 or ((1043 - 518) == (7018 - 4909))) then
								return v191;
							end
							v190 = 514 - (203 + 310);
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v139 = 1993 - (1238 + 755);
		while true do
			if (((3 + 30) == (1567 - (709 + 825))) and (v139 == (3 - 1))) then
				v49 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v50 = EpicSettings.Settings['HandleCharredTreant'] or (864 - (196 + 668));
				v51 = EpicSettings.Settings['HandleCharredBrambles'] or (0 - 0);
				v52 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v139 = 836 - (171 + 662);
			end
			if (((3147 - (4 + 89)) <= (14072 - 10057)) and (v139 == (5 + 7))) then
				v89 = EpicSettings.Settings['UseHover'];
				v90 = EpicSettings.Settings['HoverTime'] or (0 - 0);
				break;
			end
			if (((734 + 1137) < (4868 - (35 + 1451))) and ((1463 - (28 + 1425)) == v139)) then
				v81 = EpicSettings.Settings['UseTemporalAnomaly'];
				v82 = EpicSettings.Settings['TemporalAnomalyHP'] or (1993 - (941 + 1052));
				v83 = EpicSettings.Settings['TemporalAnomalyGroup'] or (0 + 0);
				v84 = EpicSettings.Settings['UseEcho'];
				v139 = 1525 - (822 + 692);
			end
			if (((1845 - 552) <= (1021 + 1145)) and (v139 == (300 - (45 + 252)))) then
				v53 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v54 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v55 = EpicSettings.Settings['UseObsidianScales'];
				v56 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
				v139 = 437 - (114 + 319);
			end
			if ((v139 == (5 - 1)) or ((3303 - 724) < (79 + 44))) then
				v57 = EpicSettings.Settings['UseStasis'];
				v58 = EpicSettings.Settings['StasisHP'] or (0 - 0);
				v59 = EpicSettings.Settings['StasisGroup'] or (0 - 0);
				v60 = EpicSettings.Settings['UseDreamBreath'];
				v139 = 1968 - (556 + 1407);
			end
			if ((v139 == (1212 - (741 + 465))) or ((1311 - (170 + 295)) >= (1248 + 1120))) then
				v65 = EpicSettings.Settings['SpiritbloomGroup'] or (0 + 0);
				v66 = EpicSettings.Settings['UseRewind'];
				v67 = EpicSettings.Settings['RewindHP'] or (0 - 0);
				v68 = EpicSettings.Settings['RewindGroup'] or (0 + 0);
				v139 = 5 + 2;
			end
			if (((1 + 0) == v139) or ((5242 - (957 + 273)) <= (899 + 2459))) then
				v45 = EpicSettings.Settings['UseBlessingOfTheBronze'] or (0 + 0);
				v46 = EpicSettings.Settings['DispelDebuffs'] or (0 - 0);
				v47 = EpicSettings.Settings['DispelBuffs'] or (0 - 0);
				v48 = EpicSettings.Settings['UseHealthstone'];
				v139 = 5 - 3;
			end
			if (((7397 - 5903) <= (4785 - (389 + 1391))) and ((6 + 2) == v139)) then
				v73 = EpicSettings.Settings['UseEmeraldBlossom'];
				v74 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
				v75 = EpicSettings.Settings['EmeraldBlossomGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['UseLivingFlame'];
				v139 = 960 - (783 + 168);
			end
			if ((v139 == (36 - 25)) or ((3061 + 50) == (2445 - (309 + 2)))) then
				v85 = EpicSettings.Settings['EchoHP'] or (0 - 0);
				v86 = EpicSettings.Settings['UseOppressingRoar'];
				v87 = EpicSettings.Settings['UseRenewingBlaze'];
				v88 = EpicSettings.Settings['RenewingBlazeHP'] or (1212 - (1090 + 122));
				v139 = 4 + 8;
			end
			if (((7909 - 5554) == (1612 + 743)) and (v139 == (1125 - (628 + 490)))) then
				v69 = EpicSettings.Settings['UseTimeDilation'];
				v70 = EpicSettings.Settings['TimeDilationHP'] or (0 + 0);
				v71 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v72 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 - 0);
				v139 = 36 - 28;
			end
			if ((v139 == (783 - (431 + 343))) or ((1187 - 599) <= (1249 - 817))) then
				v77 = EpicSettings.Settings['LivingFlameHP'] or (0 + 0);
				v78 = EpicSettings.Settings['UseReversion'];
				v79 = EpicSettings.Settings['ReversionHP'] or (0 + 0);
				v80 = EpicSettings.Settings['ReversionTankHP'] or (1695 - (556 + 1139));
				v139 = 25 - (6 + 9);
			end
			if (((879 + 3918) >= (1996 + 1899)) and (v139 == (174 - (28 + 141)))) then
				v61 = EpicSettings.Settings['DreamBreathHP'] or (0 + 0);
				v62 = EpicSettings.Settings['DreamBreathGroup'] or (0 - 0);
				v63 = EpicSettings.Settings['UseSpiritbloom'];
				v64 = EpicSettings.Settings['SpiritbloomHP'] or (0 + 0);
				v139 = 1323 - (486 + 831);
			end
			if (((9308 - 5731) == (12593 - 9016)) and ((0 + 0) == v139)) then
				v41 = EpicSettings.Settings['UseRacials'];
				v42 = EpicSettings.Settings['UseHealingPotion'];
				v43 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v44 = EpicSettings.Settings['HealingPotionHP'] or (1263 - (668 + 595));
				v139 = 1 + 0;
			end
		end
	end
	local function v124()
		local v140 = 0 + 0;
		while true do
			if (((10346 - 6552) > (3983 - (23 + 267))) and (v140 == (1945 - (1129 + 815)))) then
				v93 = EpicSettings.Settings['DreamFlightGroup'] or (387 - (371 + 16));
				break;
			end
			if ((v140 == (1750 - (1326 + 424))) or ((2414 - 1139) == (14982 - 10882))) then
				v91 = EpicSettings.Settings['DreamFlightUsage'] or "";
				v92 = EpicSettings.Settings['DreamFlightHP'] or (118 - (88 + 30));
				v140 = 772 - (720 + 51);
			end
		end
	end
	local function v125()
		v123();
		v124();
		if (v14:IsDeadOrGhost() or ((3539 - 1948) >= (5356 - (421 + 1355)))) then
			return;
		end
		v37 = EpicSettings.Toggles['ooc'];
		v38 = EpicSettings.Toggles['aoe'];
		v39 = EpicSettings.Toggles['cds'];
		v40 = EpicSettings.Toggles['dispel'];
		if (((1621 - 638) <= (889 + 919)) and v14:IsMounted()) then
			return;
		end
		if (not v14:IsMoving() or ((3233 - (286 + 797)) <= (4375 - 3178))) then
			v33 = GetTime();
		end
		if (((6242 - 2473) >= (1612 - (397 + 42))) and (v14:AffectingCombat() or v46 or v37)) then
			local v153 = v46 and v94.Expunge:IsReady();
			local v154 = v28.FocusUnit(v153, nil, 13 + 27, nil, 825 - (24 + 776));
			if (((2287 - 802) == (2270 - (222 + 563))) and v154) then
				return v154;
			end
		end
		if (v50 or ((7304 - 3989) <= (2003 + 779))) then
			local v155 = v28.HandleCharredTreant(v94.Echo, v96.EchoMouseover, 230 - (23 + 167));
			if (v155 or ((2674 - (690 + 1108)) >= (1070 + 1894))) then
				return v155;
			end
			local v155 = v28.HandleCharredTreant(v94.LivingFlame, v96.LivingFlameMouseover, 33 + 7, true);
			if (v155 or ((3080 - (40 + 808)) > (412 + 2085))) then
				return v155;
			end
		end
		if (v51 or ((8068 - 5958) <= (318 + 14))) then
			local v156 = v28.HandleCharredBrambles(v94.Echo, v96.EchoMouseover, 22 + 18);
			if (((2022 + 1664) > (3743 - (47 + 524))) and v156) then
				return v156;
			end
			local v156 = v28.HandleCharredBrambles(v94.LivingFlame, v96.LivingFlameMouseover, 26 + 14, true);
			if (v156 or ((12229 - 7755) < (1226 - 406))) then
				return v156;
			end
		end
		if (((9758 - 5479) >= (4608 - (1165 + 561))) and v89 and (v37 or v14:AffectingCombat())) then
			if (((GetTime() - v33) > v90) or ((61 + 1968) >= (10905 - 7384))) then
				if ((v94.Hover:IsReady() and v14:BuffDown(v94.Hover)) or ((778 + 1259) >= (5121 - (341 + 138)))) then
					if (((465 + 1255) < (9199 - 4741)) and v26(v94.Hover)) then
						return "hover main 2";
					end
				end
			end
		end
		v106 = v14:BuffRemains(v94.HoverBuff) < (328 - (89 + 237));
		v110 = v28.FriendlyUnitsBelowHealthPercentageCount(273 - 188);
		v101 = v14:GetEnemiesInRange(52 - 27);
		v102 = v15:GetEnemiesInSplashRange(889 - (581 + 300));
		if (v38 or ((1656 - (855 + 365)) > (7175 - 4154))) then
			v103 = #v102;
		else
			v103 = 1 + 0;
		end
		if (((1948 - (1030 + 205)) <= (796 + 51)) and (v28.TargetIsValid() or v14:AffectingCombat())) then
			local v157 = 0 + 0;
			while true do
				if (((2440 - (156 + 130)) <= (9159 - 5128)) and (v157 == (1 - 0))) then
					if (((9452 - 4837) == (1217 + 3398)) and (v105 == (6480 + 4631))) then
						v105 = v10.FightRemains(v101, false);
					end
					break;
				end
				if ((v157 == (69 - (10 + 59))) or ((1072 + 2718) == (2462 - 1962))) then
					v104 = v10.BossFightRemains(nil, true);
					v105 = v104;
					v157 = 1164 - (671 + 492);
				end
			end
		end
		if (((71 + 18) < (1436 - (369 + 846))) and v14:IsChanneling(v94.FireBreath)) then
			local v158 = 0 + 0;
			local v159;
			while true do
				if (((1753 + 301) >= (3366 - (1036 + 909))) and (v158 == (0 + 0))) then
					v159 = GetTime() - v14:CastStart();
					if (((1161 - 469) < (3261 - (11 + 192))) and (v159 >= v14:EmpowerCastTime(v34))) then
						v10.EpicSettingsS = v94.FireBreath.ReturnID;
						return "Stopping Fire Breath";
					end
					break;
				end
			end
		end
		if (v14:IsChanneling(v94.DreamBreath) or ((1645 + 1609) == (1830 - (135 + 40)))) then
			local v160 = GetTime() - v14:CastStart();
			if ((v160 >= v14:EmpowerCastTime(v35)) or ((3139 - 1843) == (2960 + 1950))) then
				v10.EpicSettingsS = v94.DreamBreath.ReturnID;
				return "Stopping DreamBreath";
			end
		end
		if (((7419 - 4051) == (5048 - 1680)) and v14:IsChanneling(v94.Spiritbloom)) then
			local v161 = 176 - (50 + 126);
			local v162;
			while true do
				if (((7359 - 4716) < (845 + 2970)) and (v161 == (1413 - (1233 + 180)))) then
					v162 = GetTime() - v14:CastStart();
					if (((2882 - (522 + 447)) > (1914 - (107 + 1314))) and (v162 >= v14:EmpowerCastTime(v36))) then
						local v195 = 0 + 0;
						while true do
							if (((14489 - 9734) > (1456 + 1972)) and (v195 == (0 - 0))) then
								v10.EpicSettingsS = v94.Spiritbloom.ReturnID;
								return "Stopping Spiritbloom";
							end
						end
					end
					break;
				end
			end
		end
		if (((5464 - 4083) <= (4279 - (716 + 1194))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
			local v163 = v28.DeadFriendlyUnitsCount();
			if (not v14:AffectingCombat() or ((83 + 4760) == (438 + 3646))) then
				if (((5172 - (74 + 429)) > (699 - 336)) and (v163 > (1 + 0))) then
					if (v26(v94.MassReturn, nil, true) or ((4296 - 2419) >= (2221 + 917))) then
						return "mass_return";
					end
				elseif (((14619 - 9877) >= (8965 - 5339)) and v26(v94.Return, not v15:IsInRange(463 - (279 + 154)), true)) then
					return "return";
				end
			end
		end
		if (not v14:IsChanneling() or ((5318 - (454 + 324)) == (721 + 195))) then
			if (v14:AffectingCombat() or ((1173 - (12 + 5)) > (2343 + 2002))) then
				local v185 = v121();
				if (((5699 - 3462) < (1571 + 2678)) and v185) then
					return v185;
				end
			else
				local v186 = v122();
				if (v186 or ((3776 - (277 + 816)) < (98 - 75))) then
					return v186;
				end
			end
		end
	end
	local function v126()
		local v145 = 1183 - (1058 + 125);
		while true do
			if (((131 + 566) <= (1801 - (815 + 160))) and (v145 == (8 - 6))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
				break;
			end
			if (((2623 - 1518) <= (281 + 895)) and (v145 == (2 - 1))) then
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
				v28.DispellableDebuffs = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
				v145 = 1900 - (41 + 1857);
			end
			if (((5272 - (1222 + 671)) <= (9852 - 6040)) and (v145 == (0 - 0))) then
				v21.Print("Preservation Evoker by Epic BoomK");
				EpicSettings.SetupVersion("Preservation Evoker X v 10.2.01 By Gojira");
				v145 = 1183 - (229 + 953);
			end
		end
	end
	v21.SetAPL(3242 - (1111 + 663), v125, v126);
end;
return v0["Epix_Evoker_Preservation.lua"]();

