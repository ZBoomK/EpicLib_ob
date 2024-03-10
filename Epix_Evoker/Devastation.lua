local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1274 - (215 + 1059);
	local v6;
	while true do
		if ((v5 == (1162 - (171 + 991))) or ((2868 - 2172) > (7126 - 4472))) then
			v6 = v0[v4];
			if (((928 - 556) <= (738 + 183)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if (((10670 - 6971) < (7585 - 2879)) and (v5 == (3 - 2))) then
			return v6(...);
		end
	end
end
v0["Epix_Evoker_Devastation.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Mouseover;
	local v16 = v12.Focus;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.CastPooling;
	local v23 = v20.CastAnnotated;
	local v24 = v20.CastSuggested;
	local v25 = v20.Press;
	local v26 = v20.Macro;
	local v27 = v20.Commons.Evoker;
	local v28 = v20.Commons.Everyone.num;
	local v29 = v20.Commons.Everyone.bool;
	local v30 = math.max;
	local v31 = v18.Evoker.Devastation;
	local v32 = v19.Evoker.Devastation;
	local v33 = v26.Evoker.Devastation;
	local v34 = {};
	local v35 = v20.Commons.Everyone;
	local v36 = false;
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
	local v66 = v13:GetEquipment();
	local v67 = (v66[1261 - (111 + 1137)] and v19(v66[171 - (91 + 67)])) or v19(0 - 0);
	local v68 = (v66[4 + 10] and v19(v66[537 - (423 + 100)])) or v19(0 + 0);
	local v69;
	local v70;
	local v71;
	local v72 = ((v31.EssenceAttunement:IsAvailable()) and (5 - 3)) or (1 + 0);
	local v73 = 773 - (326 + 445);
	local v74, v75, v76;
	local v77;
	local v78, v79;
	local v80 = 17 - 13;
	local v81 = 28 - 15;
	local v82 = v31.BlastFurnace:TalentRank();
	local v83;
	local v84;
	local v85 = false;
	local v86 = 25935 - 14824;
	local v87 = 11822 - (530 + 181);
	local v88;
	local v89;
	local v90 = 881 - (614 + 267);
	local v91 = 32 - (19 + 13);
	local v92 = 1 - 0;
	local v93 = 2 - 1;
	local v94;
	local function v95()
		local v109 = 0 - 0;
		local v110;
		local v111;
		while true do
			if (((688 + 1958) >= (1540 - 664)) and (v109 == (3 - 1))) then
				return v111;
			end
			if (((2426 - (1293 + 519)) <= (6495 - 3311)) and (v109 == (0 - 0))) then
				v110 = nil;
				if (((5977 - 2851) == (13479 - 10353)) and UnitInRaid("player")) then
					v110 = v12.Raid;
				elseif (UnitInParty("player") or ((5151 - 2964) >= (2624 + 2330))) then
					v110 = v12.Party;
				else
					return false;
				end
				v109 = 1 + 0;
			end
			if ((v109 == (2 - 1)) or ((896 + 2981) == (1188 + 2387))) then
				v111 = nil;
				for v147, v148 in pairs(v110) do
					if (((442 + 265) > (1728 - (709 + 387))) and v148:Exists() and (UnitGroupRolesAssigned(v147) == "HEALER")) then
						v111 = v148;
					end
				end
				v109 = 1860 - (673 + 1185);
			end
		end
	end
	v10:RegisterForEvent(function()
		v66 = v13:GetEquipment();
		v67 = (v66[37 - 24] and v19(v66[41 - 28])) or v19(0 - 0);
		v68 = (v66[11 + 3] and v19(v66[11 + 3])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v112 = 0 + 0;
		while true do
			if ((v112 == (0 - 0)) or ((1071 - 525) >= (4564 - (446 + 1434)))) then
				v72 = ((v31.EssenceAttunement:IsAvailable()) and (1285 - (1040 + 243))) or (2 - 1);
				v82 = v31.BlastFurnace:TalentRank();
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v113 = false;
		v86 = 12958 - (559 + 1288);
		v87 = 13042 - (609 + 1322);
		for v126 in pairs(v27.FirestormTracker) do
			v27.FirestormTracker[v126] = nil;
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		if (((1919 - (13 + 441)) <= (16072 - 11771)) and (v31.Firestorm:TimeSinceLastCast() > (31 - 19))) then
			return false;
		end
		if (((8486 - 6782) > (54 + 1371)) and v27.FirestormTracker[v14:GUID()]) then
			if ((v27.FirestormTracker[v14:GUID()] > (GetTime() - (7.5 - 5))) or ((245 + 442) == (1856 + 2378))) then
				return true;
			end
		end
		return false;
	end
	local function v97()
		local v114 = 0 - 0;
		while true do
			if ((v114 == (0 + 0)) or ((6124 - 2794) < (945 + 484))) then
				if (((638 + 509) >= (241 + 94)) and (v64 == "Auto")) then
					if (((2885 + 550) > (2052 + 45)) and v31.SourceofMagic:IsCastable() and v16:IsInRange(458 - (153 + 280)) and (v94 == v16:GUID()) and (v16:BuffRemains(v31.SourceofMagicBuff) < (866 - 566))) then
						if (v21(v33.SourceofMagicFocus) or ((3385 + 385) >= (1596 + 2445))) then
							return "source_of_magic precombat";
						end
					end
				end
				if ((v64 == "Selected") or ((1984 + 1807) <= (1462 + 149))) then
					local v150 = v35.NamedUnit(19 + 6, v65);
					if ((v150 and v31.SourceofMagic:IsCastable() and (v150:BuffRemains(v31.SourceofMagicBuff) < (456 - 156))) or ((2830 + 1748) <= (2675 - (89 + 578)))) then
						if (((804 + 321) <= (4315 - 2239)) and v21(v33.SourceofMagicName)) then
							return "source_of_magic precombat";
						end
					end
				end
				v114 = 1050 - (572 + 477);
			end
			if ((v114 == (1 + 1)) or ((446 + 297) >= (526 + 3873))) then
				if (((1241 - (84 + 2)) < (2757 - 1084)) and v31.LivingFlame:IsCastable() and not v31.Firestorm:IsAvailable()) then
					if (v25(v31.LivingFlame, not v14:IsInRange(19 + 6), v89) or ((3166 - (497 + 345)) <= (15 + 563))) then
						return "living_flame precombat";
					end
				end
				if (((637 + 3130) == (5100 - (605 + 728))) and v31.AzureStrike:IsCastable()) then
					if (((2918 + 1171) == (9090 - 5001)) and v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
			if (((205 + 4253) >= (6189 - 4515)) and (v114 == (1 + 0))) then
				v84 = (2 - 1) * v83;
				if (((734 + 238) <= (1907 - (457 + 32))) and v31.Firestorm:IsCastable()) then
					if (v25(v31.Firestorm, not v14:IsInRange(11 + 14), v89) or ((6340 - (832 + 570)) < (4487 + 275))) then
						return "firestorm precombat";
					end
				end
				v114 = 1 + 1;
			end
		end
	end
	local function v98()
		local v115 = 0 - 0;
		while true do
			if ((v115 == (0 + 0)) or ((3300 - (588 + 208)) > (11492 - 7228))) then
				if (((3953 - (884 + 916)) == (4507 - 2354)) and v31.ObsidianScales:IsCastable() and v13:BuffDown(v31.ObsidianScales) and (v13:HealthPercentage() < v60) and v59) then
					if (v25(v31.ObsidianScales) or ((294 + 213) >= (3244 - (232 + 421)))) then
						return "obsidian_scales defensives";
					end
				end
				if (((6370 - (1569 + 320)) == (1100 + 3381)) and v32.Healthstone:IsReady() and v51 and (v13:HealthPercentage() <= v52)) then
					if (v25(v33.Healthstone, nil, nil, true) or ((443 + 1885) < (2335 - 1642))) then
						return "healthstone defensive 3";
					end
				end
				v115 = 606 - (316 + 289);
			end
			if (((11329 - 7001) == (200 + 4128)) and (v115 == (1454 - (666 + 787)))) then
				if (((2013 - (360 + 65)) >= (1245 + 87)) and v31.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v58) and v57) then
					if (v21(v31.RenewingBlaze, nil, nil) or ((4428 - (79 + 175)) > (6697 - 2449))) then
						return "RenewingBlaze main 6";
					end
				end
				if ((v45 and (v13:HealthPercentage() <= v47)) or ((3579 + 1007) <= (251 - 169))) then
					if (((7439 - 3576) == (4762 - (503 + 396))) and (v46 == "Refreshing Healing Potion")) then
						if (v32.RefreshingHealingPotion:IsReady() or ((463 - (92 + 89)) <= (80 - 38))) then
							if (((2364 + 2245) >= (454 + 312)) and v25(v33.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v99()
		if ((v78 and ((v71 >= (11 - 8)) or v13:BuffDown(v31.SpoilsofNeltharusVers) or ((v79 + ((1 + 3) * v28(v31.EternitySurge:CooldownRemains() <= ((v88 * (4 - 2)) + v28(v31.FireBreath:CooldownRemains() <= (v88 * (2 + 0))))))) <= (9 + 9)))) or (v87 <= (60 - 40)) or ((144 + 1008) == (3794 - 1306))) then
			ShouldReturn = v35.HandleTopTrinket(v34, v38, 1284 - (485 + 759), nil);
			if (((7917 - 4495) > (4539 - (442 + 747))) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v35.HandleBottomTrinket(v34, v38, 1175 - (832 + 303), nil);
			if (((1823 - (88 + 858)) > (115 + 261)) and ShouldReturn) then
				return ShouldReturn;
			end
		end
	end
	local function v100()
		local v116 = 0 + 0;
		while true do
			if ((v116 == (1 + 0)) or ((3907 - (766 + 23)) <= (9137 - 7286))) then
				v92 = v90;
				if (v25(v31.EternitySurge, not v14:IsInRange(41 - 11), true) or ((434 - 269) >= (11851 - 8359))) then
					return "eternity_surge empower " .. v90;
				end
				break;
			end
			if (((5022 - (1036 + 37)) < (3443 + 1413)) and (v116 == (0 - 0))) then
				if (v31.EternitySurge:CooldownDown() or ((3364 + 912) < (4496 - (641 + 839)))) then
					return nil;
				end
				if (((5603 - (910 + 3)) > (10515 - 6390)) and ((v71 <= ((1685 - (1466 + 218)) + v28(v31.EternitysSpan:IsAvailable()))) or ((v79 < ((1.75 + 0) * v83)) and (v79 >= ((1149 - (556 + 592)) * v83))) or (v78 and ((v71 == (2 + 3)) or (not v31.EternitysSpan:IsAvailable() and (v71 >= (814 - (329 + 479)))) or (v31.EternitysSpan:IsAvailable() and (v71 >= (862 - (174 + 680)))))))) then
					v90 = 3 - 2;
				elseif ((v71 <= ((3 - 1) + ((2 + 0) * v28(v31.EternitysSpan:IsAvailable())))) or ((v79 < ((741.5 - (396 + 343)) * v83)) and (v79 >= ((1.75 + 0) * v83))) or ((1527 - (29 + 1448)) >= (2285 - (135 + 1254)))) then
					v90 = 7 - 5;
				elseif ((v71 <= ((13 - 10) + ((2 + 1) * v28(v31.EternitysSpan:IsAvailable())))) or not v31.FontofMagic:IsAvailable() or ((v79 <= ((1530.25 - (389 + 1138)) * v83)) and (v79 >= ((576.5 - (102 + 472)) * v83))) or ((1618 + 96) >= (1641 + 1317))) then
					v90 = 3 + 0;
				else
					v90 = 1549 - (320 + 1225);
				end
				v116 = 1 - 0;
			end
		end
	end
	local function v101()
		local v117 = 0 + 0;
		local v118;
		while true do
			if ((v117 == (1465 - (157 + 1307))) or ((3350 - (821 + 1038)) < (1606 - 962))) then
				if (((77 + 627) < (1753 - 766)) and ((v78 and (v71 <= (1 + 1))) or ((v71 == (2 - 1)) and not v31.EverburningFlame:IsAvailable()) or ((v79 < ((1027.75 - (834 + 192)) * v83)) and (v79 >= ((1 + 0) * v83))))) then
					v91 = 1 + 0;
				elseif (((80 + 3638) > (2952 - 1046)) and ((not v96() and v31.EverburningFlame:IsAvailable() and (v71 <= (307 - (300 + 4)))) or ((v71 == (1 + 1)) and not v31.EverburningFlame:IsAvailable()) or ((v79 < ((5.5 - 3) * v83)) and (v79 >= ((363.75 - (112 + 250)) * v83))))) then
					v91 = 1 + 1;
				elseif (not v31.FontofMagic:IsAvailable() or (v96() and v31.EverburningFlame:IsAvailable() and (v71 <= (7 - 4))) or ((v79 <= ((2.25 + 1) * v83)) and (v79 >= ((2.5 + 0) * v83))) or ((717 + 241) > (1803 + 1832))) then
					v91 = 3 + 0;
				else
					v91 = 1418 - (1001 + 413);
				end
				v93 = v91;
				v117 = 4 - 2;
			end
			if (((4383 - (244 + 638)) <= (5185 - (627 + 66))) and (v117 == (0 - 0))) then
				if (v31.FireBreath:CooldownDown() or ((4044 - (512 + 90)) < (4454 - (1665 + 241)))) then
					return nil;
				end
				v118 = v14:DebuffRemains(v31.FireBreath);
				v117 = 718 - (373 + 344);
			end
			if (((1297 + 1578) >= (388 + 1076)) and (v117 == (5 - 3))) then
				if (v23(v31.FireBreath, false, "1", not v14:IsInRange(50 - 20), nil) or ((5896 - (35 + 1064)) >= (3561 + 1332))) then
					return "fire_breath empower " .. v91 .. " main 12";
				end
				break;
			end
		end
	end
	local function v102()
		local v119 = 0 - 0;
		while true do
			if ((v119 == (1 + 1)) or ((1787 - (298 + 938)) > (3327 - (233 + 1026)))) then
				if (((3780 - (636 + 1030)) > (483 + 461)) and v31.Firestorm:IsCastable()) then
					if (v25(v31.Firestorm, not v14:IsInRange(25 + 0), v89) or ((672 + 1590) >= (210 + 2886))) then
						return "firestorm aoe 10";
					end
				end
				if ((v31.Pyre:IsReady() and ((v71 >= (226 - (55 + 166))) or ((v71 >= (1 + 3)) and ((v13:BuffDown(v31.EssenceBurstBuff) and v13:BuffDown(v31.IridescenceBlueBuff)) or not v31.EternitysSpan:IsAvailable())) or ((v71 >= (1 + 3)) and v31.Volatility:IsAvailable()) or ((v71 >= (11 - 8)) and v31.Volatility:IsAvailable() and v31.ChargedBlast:IsAvailable() and v13:BuffDown(v31.EssenceBurstBuff) and v13:BuffDown(v31.IridescenceBlueBuff)) or ((v71 >= (300 - (36 + 261))) and v31.Volatility:IsAvailable() and not v31.ChargedBlast:IsAvailable() and (v13:BuffUp(v31.IridescenceRedBuff) or v13:BuffDown(v31.EssenceBurstBuff))) or (v13:BuffStack(v31.ChargedBlastBuff) >= (25 - 10)))) or ((3623 - (34 + 1334)) >= (1360 + 2177))) then
					if (v25(v31.Pyre, not v14:IsSpellInRange(v31.Pyre)) or ((2982 + 855) < (2589 - (1035 + 248)))) then
						return "pyre aoe 14";
					end
				end
				if (((2971 - (20 + 1)) == (1537 + 1413)) and v31.LivingFlame:IsCastable() and v13:BuffUp(v31.BurnoutBuff) and v13:BuffUp(v31.LeapingFlamesBuff) and v13:BuffDown(v31.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - (320 - (134 + 185))))) then
					if (v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89) or ((5856 - (549 + 584)) < (3983 - (314 + 371)))) then
						return "living_flame aoe 14";
					end
				end
				v119 = 10 - 7;
			end
			if (((2104 - (478 + 490)) >= (82 + 72)) and ((1175 - (786 + 386)) == v119)) then
				if (v31.Disintegrate:IsReady() or ((877 - 606) > (6127 - (1055 + 324)))) then
					if (((6080 - (1093 + 247)) >= (2801 + 351)) and v25(v31.Disintegrate, not v14:IsSpellInRange(v31.Disintegrate), v89)) then
						return "disintegrate aoe 20";
					end
				end
				if ((v31.LivingFlame:IsCastable() and v31.Snapfire:IsAvailable() and v13:BuffUp(v31.BurnoutBuff)) or ((272 + 2306) >= (13458 - 10068))) then
					if (((139 - 98) <= (4726 - 3065)) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
						return "living_flame aoe 22";
					end
				end
				if (((1510 - 909) < (1267 + 2293)) and v31.AzureStrike:IsCastable()) then
					if (((905 - 670) < (2367 - 1680)) and v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike))) then
						return "azure_strike aoe 24";
					end
				end
				break;
			end
			if (((3431 + 1118) > (2948 - 1795)) and (v119 == (689 - (364 + 324)))) then
				if (v78 or not v31.Dragonrage:IsAvailable() or ((v31.Dragonrage:CooldownRemains() > v80) and ((v13:BuffRemains(v31.PowerSwellBuff) < v84) or (not v31.Volatility:IsAvailable() and (v71 == (7 - 4)))) and (v13:BuffRemains(v31.BlazingShardsBuff) < v84) and ((v14:TimeToDie() >= (19 - 11)) or (v87 < (10 + 20)))) or ((19557 - 14883) < (7481 - 2809))) then
					local v151 = 0 - 0;
					local v152;
					while true do
						if (((4936 - (1249 + 19)) < (4117 + 444)) and (v151 == (0 - 0))) then
							v152 = v100();
							if (v152 or ((1541 - (686 + 400)) == (2829 + 776))) then
								return v152;
							end
							break;
						end
					end
				end
				if ((v31.DeepBreath:IsCastable() and v38 and not v78 and (v13:EssenceDeficit() > (232 - (73 + 156))) and v35.TargetIsMouseover()) or ((13 + 2650) == (4123 - (721 + 90)))) then
					if (((49 + 4228) <= (14529 - 10054)) and v25(v33.DeepBreathCursor, not v14:IsInRange(500 - (224 + 246)))) then
						return "deep_breath aoe 6";
					end
				end
				if ((v31.ShatteringStar:IsCastable() and ((v13:BuffStack(v31.EssenceBurstBuff) < v72) or not v31.ArcaneVigor:IsAvailable())) or ((1409 - 539) == (2188 - 999))) then
					if (((282 + 1271) <= (75 + 3058)) and v25(v31.ShatteringStar, not v14:IsSpellInRange(v31.ShatteringStar))) then
						return "shattering_star aoe 8";
					end
				end
				v119 = 2 + 0;
			end
			if ((v119 == (0 - 0)) or ((7444 - 5207) >= (4024 - (203 + 310)))) then
				if ((v31.Dragonrage:IsCastable() and v38 and ((v14:TimeToDie() >= (2025 - (1238 + 755))) or (v87 < (3 + 27)))) or ((2858 - (709 + 825)) > (5565 - 2545))) then
					if (v25(v31.Dragonrage) or ((4357 - 1365) == (2745 - (196 + 668)))) then
						return "dragonrage aoe 2";
					end
				end
				if (((12263 - 9157) > (3160 - 1634)) and v31.TipTheScales:IsCastable() and v38 and v78 and ((v71 <= ((836 - (171 + 662)) + ((96 - (4 + 89)) * v28(v31.EternitysSpan:IsAvailable())))) or v31.FireBreath:CooldownDown())) then
					if (((10595 - 7572) < (1410 + 2460)) and v25(v31.TipTheScales)) then
						return "tip_the_scales aoe 4";
					end
				end
				if (((627 - 484) > (30 + 44)) and (not v31.Dragonrage:IsAvailable() or (v77 > v80) or not v31.Animosity:IsAvailable()) and ((((v13:BuffRemains(v31.PowerSwellBuff) < v84) or (not v31.Volatility:IsAvailable() and (v71 == (1489 - (35 + 1451))))) and (v13:BuffRemains(v31.BlazingShardsBuff) < v84)) or v78) and ((v14:TimeToDie() >= (1461 - (28 + 1425))) or (v87 < (2023 - (941 + 1052))))) then
					local v153 = 0 + 0;
					local v154;
					while true do
						if (((1532 - (822 + 692)) < (3014 - 902)) and (v153 == (0 + 0))) then
							v154 = v101();
							if (((1394 - (45 + 252)) <= (1611 + 17)) and v154) then
								return v154;
							end
							break;
						end
					end
				end
				v119 = 1 + 0;
			end
		end
	end
	local function v103()
		local v120 = 0 - 0;
		while true do
			if (((5063 - (114 + 319)) == (6647 - 2017)) and (v120 == (1 - 0))) then
				if (((2257 + 1283) > (3997 - 1314)) and v31.Disintegrate:IsReady() and (v79 > (39 - 20)) and (v31.FireBreath:CooldownRemains() > (1991 - (556 + 1407))) and v31.EyeofInfinity:IsAvailable() and v13:HasTier(1236 - (741 + 465), 467 - (170 + 295))) then
					if (((2526 + 2268) >= (3009 + 266)) and v21(v31.Disintegrate, nil, nil, not v14:IsSpellInRange(v31.Disintegrate))) then
						return "disintegrate st 9";
					end
				end
				if (((3653 - 2169) == (1231 + 253)) and v31.ShatteringStar:IsCastable() and ((v13:BuffStack(v31.EssenceBurstBuff) < v72) or not v31.ArcaneVigor:IsAvailable())) then
					if (((919 + 513) < (2014 + 1541)) and v25(v31.ShatteringStar, not v14:IsSpellInRange(v31.ShatteringStar))) then
						return "shattering_star st 10";
					end
				end
				if (((not v31.Dragonrage:IsAvailable() or (v77 > v81) or not v31.Animosity:IsAvailable()) and ((v13:BuffRemains(v31.BlazingShardsBuff) < v84) or v78) and ((v14:TimeToDie() >= (1238 - (957 + 273))) or (v87 < (9 + 21)))) or ((427 + 638) > (13633 - 10055))) then
					local v155 = 0 - 0;
					local v156;
					while true do
						if ((v155 == (0 - 0)) or ((23743 - 18948) < (3187 - (389 + 1391)))) then
							v156 = v100();
							if (((1163 + 690) < (501 + 4312)) and v156) then
								return v156;
							end
							break;
						end
					end
				end
				if ((v31.Animosity:IsAvailable() and v78 and (v79 < (v88 + (v84 * v28(v13:BuffDown(v31.TipTheScales))))) and ((v79 - v31.FireBreath:CooldownRemains()) >= (v84 * v28(v13:BuffDown(v31.TipTheScales))))) or ((6422 - 3601) < (3382 - (783 + 168)))) then
					if (v25(v31.Pool) or ((9645 - 6771) < (2146 + 35))) then
						return "Wait for FB st 12";
					end
				end
				v120 = 313 - (309 + 2);
			end
			if (((0 - 0) == v120) or ((3901 - (1090 + 122)) <= (112 + 231))) then
				if ((v31.Firestorm:IsCastable() and (v13:BuffUp(v31.SnapfireBuff))) or ((6276 - 4407) == (1375 + 634))) then
					if (v25(v31.Firestorm, not v14:IsInRange(1143 - (628 + 490)), v89) or ((636 + 2910) < (5748 - 3426))) then
						return "firestorm st 4";
					end
				end
				if ((v31.Dragonrage:IsCastable() and v38 and (((v31.FireBreath:CooldownRemains() < v88) and (v31.EternitySurge:CooldownRemains() < ((9 - 7) * v88))) or (v87 < (804 - (431 + 343))))) or ((4204 - 2122) == (13807 - 9034))) then
					if (((2563 + 681) > (135 + 920)) and v25(v31.Dragonrage)) then
						return "dragonrage st 6";
					end
				end
				if ((v31.TipTheScales:IsCastable() and v38 and ((v78 and v31.EternitySurge:CooldownUp() and v31.FireBreath:CooldownDown() and not v31.EverburningFlame:IsAvailable()) or (v31.EverburningFlame:IsAvailable() and v31.FireBreath:CooldownUp()))) or ((5008 - (556 + 1139)) <= (1793 - (6 + 9)))) then
					if (v25(v31.TipTheScales) or ((261 + 1160) >= (1078 + 1026))) then
						return "tip_the_scales st 8";
					end
				end
				if (((1981 - (28 + 141)) <= (1259 + 1990)) and (not v31.Dragonrage:IsAvailable() or (v77 > v81) or not v31.Animosity:IsAvailable()) and ((v13:BuffRemains(v31.BlazingShardsBuff) < v84) or v78) and ((v14:TimeToDie() >= (9 - 1)) or (v87 < (22 + 8)))) then
					local v157 = 1317 - (486 + 831);
					local v158;
					while true do
						if (((4223 - 2600) <= (6889 - 4932)) and (v157 == (0 + 0))) then
							v158 = v101();
							if (((13950 - 9538) == (5675 - (668 + 595))) and v158) then
								return v158;
							end
							break;
						end
					end
				end
				v120 = 1 + 0;
			end
			if (((353 + 1397) >= (2296 - 1454)) and (v120 == (292 - (23 + 267)))) then
				if (((6316 - (1129 + 815)) > (2237 - (371 + 16))) and v31.Animosity:IsAvailable() and v78 and (v79 < (v88 + v84)) and ((v79 - v31.EternitySurge:CooldownRemains()) > (v84 * v28(v13:BuffDown(v31.TipTheScales))))) then
					if (((1982 - (1326 + 424)) < (1554 - 733)) and v25(v31.Pool)) then
						return "Wait for ES st 14";
					end
				end
				if (((1892 - 1374) < (1020 - (88 + 30))) and v31.LivingFlame:IsCastable() and v78 and (v79 < ((v72 - v13:BuffStack(v31.EssenceBurstBuff)) * v88)) and v13:BuffUp(v31.BurnoutBuff)) then
					if (((3765 - (720 + 51)) > (1908 - 1050)) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
						return "living_flame st 16";
					end
				end
				if ((v31.AzureStrike:IsCastable() and v78 and (v79 < ((v72 - v13:BuffStack(v31.EssenceBurstBuff)) * v88))) or ((5531 - (421 + 1355)) <= (1509 - 594))) then
					if (((1939 + 2007) > (4826 - (286 + 797))) and v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike))) then
						return "azure_strike st 18";
					end
				end
				if ((v31.LivingFlame:IsCastable() and v13:BuffUp(v31.BurnoutBuff) and ((v13:BuffUp(v31.LeapingFlamesBuff) and v13:BuffDown(v31.EssenceBurstBuff)) or (v13:BuffDown(v31.LeapingFlamesBuff) and (v13:BuffStack(v31.EssenceBurstBuff) < v72))) and (v13:Essence() < (v13:EssenceMax() - (3 - 2)))) or ((2210 - 875) >= (3745 - (397 + 42)))) then
					if (((1513 + 3331) > (3053 - (24 + 776))) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
						return "living_flame st 20";
					end
				end
				v120 = 4 - 1;
			end
			if (((1237 - (222 + 563)) == (995 - 543)) and (v120 == (3 + 1))) then
				if ((v31.DeepBreath:IsCastable() and v38 and not v78 and v31.ImminentDestruction:IsAvailable() and v14:DebuffDown(v31.ShatteringStar) and v35.TargetIsMouseover()) or ((4747 - (23 + 167)) < (3885 - (690 + 1108)))) then
					if (((1398 + 2476) == (3196 + 678)) and v25(v33.DeepBreathCursor, not v14:IsInRange(878 - (40 + 808)))) then
						return "deep_breath st 30";
					end
				end
				if (v31.LivingFlame:IsCastable() or ((320 + 1618) > (18871 - 13936))) then
					if (v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89) or ((4067 + 188) < (1811 + 1612))) then
						return "living_flame st 32";
					end
				end
				if (((798 + 656) <= (3062 - (47 + 524))) and v31.AzureStrike:IsCastable()) then
					if (v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike)) or ((2698 + 1459) <= (7662 - 4859))) then
						return "azure_strike st 34";
					end
				end
				break;
			end
			if (((7256 - 2403) >= (6800 - 3818)) and (v120 == (1729 - (1165 + 561)))) then
				if (((123 + 4011) > (10397 - 7040)) and v31.Pyre:IsReady() and v96() and v31.RagingInferno:IsAvailable() and (v13:BuffStack(v31.ChargedBlastBuff) == (8 + 12)) and (v71 >= (481 - (341 + 138)))) then
					if (v25(v31.Pyre, not v14:IsSpellInRange(v31.Pyre)) or ((923 + 2494) < (5228 - 2694))) then
						return "pyre st 22";
					end
				end
				if (v31.Disintegrate:IsReady() or ((3048 - (89 + 237)) <= (527 - 363))) then
					if (v25(v31.Disintegrate, not v14:IsSpellInRange(v31.Disintegrate), v89) or ((5069 - 2661) < (2990 - (581 + 300)))) then
						return "disintegrate st 24";
					end
				end
				if ((v31.Firestorm:IsCastable() and not v78 and v14:DebuffDown(v31.ShatteringStar)) or ((1253 - (855 + 365)) == (3455 - 2000))) then
					if (v25(v31.Firestorm, not v14:IsInRange(9 + 16), v89) or ((1678 - (1030 + 205)) >= (3770 + 245))) then
						return "firestorm st 26";
					end
				end
				if (((3147 + 235) > (452 - (156 + 130))) and v31.DeepBreath:IsCastable() and v38 and not v78 and (v71 >= (4 - 2)) and v35.TargetIsMouseover()) then
					if (v25(v33.DeepBreathCursor, not v14:IsInRange(50 - 20)) or ((573 - 293) == (807 + 2252))) then
						return "deep_breath st 28";
					end
				end
				v120 = 3 + 1;
			end
		end
	end
	local function v104()
		local v121 = 69 - (10 + 59);
		while true do
			if (((532 + 1349) > (6367 - 5074)) and (v121 == (1164 - (671 + 492)))) then
				if (((1877 + 480) == (3572 - (369 + 846))) and (v42 == "Player Only")) then
					if (((33 + 90) == (105 + 18)) and v31.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v44)) then
						if (v21(v33.EmeraldBlossomPlayer, nil) or ((3001 - (1036 + 909)) >= (2697 + 695))) then
							return "emerald_blossom main 42";
						end
					end
				end
				if ((v42 == "Everyone") or ((1814 - 733) < (1278 - (11 + 192)))) then
					if ((v31.EmeraldBlossom:IsReady() and (v16:HealthPercentage() < v44)) or ((531 + 518) >= (4607 - (135 + 40)))) then
						if (v21(v33.EmeraldBlossomFocus, nil) or ((11552 - 6784) <= (510 + 336))) then
							return "emerald_blossom main 42";
						end
					end
				end
				break;
			end
			if ((v121 == (0 - 0)) or ((5033 - 1675) <= (1596 - (50 + 126)))) then
				if ((v41 == "Player Only") or ((10411 - 6672) <= (666 + 2339))) then
					if ((v31.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v43)) or ((3072 - (1233 + 180)) >= (3103 - (522 + 447)))) then
						if (v21(v33.VerdantEmbracePlayer, nil) or ((4681 - (107 + 1314)) < (1093 + 1262))) then
							return "verdant_embrace main 40";
						end
					end
				end
				if ((v41 == "Everyone") or (v41 == "Not Tank") or ((2038 - 1369) == (1794 + 2429))) then
					if ((v31.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v43)) or ((3359 - 1667) < (2326 - 1738))) then
						if (v21(v33.VerdantEmbraceFocus, nil) or ((6707 - (716 + 1194)) < (63 + 3588))) then
							return "verdant_embrace main 40";
						end
					end
				end
				v121 = 1 + 0;
			end
		end
	end
	local function v105()
		local v122 = 503 - (74 + 429);
		while true do
			if ((v122 == (0 - 0)) or ((2071 + 2106) > (11102 - 6252))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(22 + 8) or not v35.UnitHasDispellableDebuffByPlayer(v16) or ((1233 - 833) > (2746 - 1635))) then
					return;
				end
				if (((3484 - (279 + 154)) > (1783 - (454 + 324))) and v31.Expunge:IsReady() and (v35.UnitHasPoisonDebuff(v16))) then
					if (((2906 + 787) <= (4399 - (12 + 5))) and v25(v33.ExpungeFocus)) then
						return "Expunge dispel";
					end
				end
				v122 = 1 + 0;
			end
			if ((v122 == (2 - 1)) or ((1213 + 2069) > (5193 - (277 + 816)))) then
				if ((v31.OppressingRoar:IsReady() and v56 and v35.UnitHasEnrageBuff(v14)) or ((15297 - 11717) < (4027 - (1058 + 125)))) then
					if (((17 + 72) < (5465 - (815 + 160))) and v25(v31.OppressingRoar)) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
		end
	end
	local function v106()
		local v123 = 0 - 0;
		while true do
			if ((v123 == (11 - 6)) or ((1189 + 3794) < (5285 - 3477))) then
				v61 = EpicSettings.Settings['UseHover'];
				v62 = EpicSettings.Settings['HoverTime'] or (1898 - (41 + 1857));
				v63 = EpicSettings.Settings['LandslideUsage'] or "";
				v64 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
				v123 = 1899 - (1222 + 671);
			end
			if (((9896 - 6067) > (5417 - 1648)) and (v123 == (1182 - (229 + 953)))) then
				v41 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v42 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
				v43 = EpicSettings.Settings['VerdantEmbraceHP'] or (1774 - (1111 + 663));
				v44 = EpicSettings.Settings['EmeraldBlossomHP'] or (1579 - (874 + 705));
				v123 = 1 + 0;
			end
			if (((1014 + 471) <= (6035 - 3131)) and (v123 == (1 + 1))) then
				v49 = EpicSettings.Settings['DispelDebuffs'];
				v50 = EpicSettings.Settings['DispelBuffs'];
				v51 = EpicSettings.Settings['UseHealthstone'];
				v52 = EpicSettings.Settings['HealthstoneHP'] or (679 - (642 + 37));
				v123 = 1 + 2;
			end
			if (((683 + 3586) == (10718 - 6449)) and (v123 == (460 - (233 + 221)))) then
				v65 = EpicSettings.Settings['SourceOfMagicName'] or "";
				break;
			end
			if (((894 - 507) <= (2449 + 333)) and (v123 == (1545 - (718 + 823)))) then
				v57 = EpicSettings.Settings['UseRenewingBlaze'];
				v58 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v59 = EpicSettings.Settings['UseObsidianScales'];
				v60 = EpicSettings.Settings['ObsidianScalesHP'] or (805 - (266 + 539));
				v123 = 13 - 8;
			end
			if ((v123 == (1228 - (636 + 589))) or ((4507 - 2608) <= (1891 - 974))) then
				v53 = EpicSettings.Settings['InterruptWithStun'];
				v54 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v55 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v56 = EpicSettings.Settings['UseOppressingRoar'];
				v123 = 2 + 2;
			end
			if ((v123 == (1016 - (657 + 358))) or ((11416 - 7104) <= (1995 - 1119))) then
				v45 = EpicSettings.Settings['UseHealingPotion'];
				v46 = EpicSettings.Settings['HealingPotionName'] or "";
				v47 = EpicSettings.Settings['HealingPotionHP'] or (1187 - (1151 + 36));
				v48 = EpicSettings.Settings['UseBlessingOfTheBronze'];
				v123 = 2 + 0;
			end
		end
	end
	local function v107()
		local v124 = 0 + 0;
		while true do
			if (((6665 - 4433) <= (4428 - (1552 + 280))) and (v124 == (841 - (64 + 770)))) then
				if (((1423 + 672) < (8367 - 4681)) and v39 and v36 and not v13:AffectingCombat()) then
					local v159 = 0 + 0;
					local v160;
					while true do
						if ((v159 == (1243 - (157 + 1086))) or ((3192 - 1597) >= (19594 - 15120))) then
							v160 = v104();
							if (v160 or ((7084 - 2465) < (3932 - 1050))) then
								return v160;
							end
							break;
						end
					end
				end
				if ((v61 and (v36 or v13:AffectingCombat())) or ((1113 - (599 + 220)) >= (9620 - 4789))) then
					if (((3960 - (1813 + 118)) <= (2255 + 829)) and ((GetTime() - LastStationaryTime) > v62)) then
						if ((v31.Hover:IsReady() and v13:BuffDown(v31.Hover)) or ((3254 - (841 + 376)) == (3391 - 971))) then
							if (((1036 + 3422) > (10655 - 6751)) and v25(v31.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				if (((1295 - (464 + 395)) >= (315 - 192)) and not v13:AffectingCombat() and v36 and not v13:IsCasting()) then
					local v161 = v97();
					if (((241 + 259) < (2653 - (467 + 370))) and v161) then
						return v161;
					end
				end
				v124 = 16 - 8;
			end
			if (((2624 + 950) == (12251 - 8677)) and ((1 + 0) == v124)) then
				v38 = EpicSettings.Toggles['cds'];
				v39 = EpicSettings.Toggles['heal'];
				v40 = EpicSettings.Toggles['dispel'];
				v124 = 4 - 2;
			end
			if (((741 - (150 + 370)) < (1672 - (74 + 1208))) and (v124 == (19 - 11))) then
				if (v13:AffectingCombat() or ((10495 - 8282) <= (1012 + 409))) then
					local v162 = 390 - (14 + 376);
					local v163;
					while true do
						if (((5303 - 2245) < (3145 + 1715)) and (v162 == (0 + 0))) then
							v163 = v98();
							if (v163 or ((1237 + 59) >= (13027 - 8581))) then
								return v163;
							end
							break;
						end
					end
				end
				if (v13:AffectingCombat() or v36 or ((1048 + 345) > (4567 - (23 + 55)))) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((10484 - 6060) < (19 + 8))) then
						local v177 = 0 + 0;
						local v178;
						while true do
							if ((v177 == (1 - 0)) or ((629 + 1368) > (4716 - (652 + 249)))) then
								v178 = v35.InterruptWithStun(v31.TailSwipe, 21 - 13);
								if (((5333 - (708 + 1160)) > (5192 - 3279)) and v178) then
									return v178;
								end
								v177 = 3 - 1;
							end
							if (((760 - (10 + 17)) < (409 + 1410)) and ((1732 - (1400 + 332)) == v177)) then
								v178 = v35.Interrupt(v31.Quell, 19 - 9, true);
								if (v178 or ((6303 - (242 + 1666)) == (2035 + 2720))) then
									return v178;
								end
								v177 = 1 + 0;
							end
							if ((v177 == (2 + 0)) or ((4733 - (850 + 90)) < (4148 - 1779))) then
								v178 = v35.Interrupt(v31.Quell, 1400 - (360 + 1030), true, v15, v33.QuellMouseover);
								if (v178 or ((3615 + 469) == (747 - 482))) then
									return v178;
								end
								break;
							end
						end
					end
					v77 = v30(v31.Dragonrage:CooldownRemains(), v31.EternitySurge:CooldownRemains() - ((2 - 0) * v88), v31.FireBreath:CooldownRemains() - v88);
					if (((6019 - (909 + 752)) == (5581 - (109 + 1114))) and v31.Unravel:IsReady() and v14:EnemyAbsorb()) then
						if (v25(v31.Unravel, not v14:IsSpellInRange(v31.Unravel)) or ((5745 - 2607) < (387 + 606))) then
							return "unravel main 4";
						end
					end
					if (((3572 - (6 + 236)) > (1464 + 859)) and (v50 or v49)) then
						local v179 = 0 + 0;
						local v180;
						while true do
							if ((v179 == (0 - 0)) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
								v180 = v105();
								if (v180 or ((151 + 765) == (3360 - (579 + 110)))) then
									return v180;
								end
								break;
							end
						end
					end
					if (((22 + 250) == (241 + 31)) and v39 and v13:AffectingCombat()) then
						local v181 = 0 + 0;
						local v182;
						while true do
							if (((4656 - (174 + 233)) <= (13516 - 8677)) and (v181 == (0 - 0))) then
								v182 = v104();
								if (((1235 + 1542) < (4374 - (663 + 511))) and v182) then
									return v182;
								end
								break;
							end
						end
					end
					if (((85 + 10) < (425 + 1532)) and v61 and v13:AffectingCombat()) then
						if (((2546 - 1720) < (1040 + 677)) and ((GetTime() - LastStationaryTime) > v62)) then
							if (((3356 - 1930) >= (2675 - 1570)) and v31.Hover:IsReady()) then
								if (((1315 + 1439) <= (6576 - 3197)) and v25(v31.Hover)) then
									return "hover main 2";
								end
							end
						end
					end
					if ((v64 == "Auto") or ((2799 + 1128) == (130 + 1283))) then
						if ((v31.SourceofMagic:IsCastable() and v16:IsInRange(747 - (478 + 244)) and (v94 == v16:GUID()) and (v16:BuffRemains(v31.SourceofMagicBuff) < (817 - (440 + 77)))) or ((525 + 629) <= (2883 - 2095))) then
							if (v21(v33.SourceofMagicFocus) or ((3199 - (655 + 901)) > (627 + 2752))) then
								return "source_of_magic precombat";
							end
						end
					end
					if ((v64 == "Selected") or ((2146 + 657) > (3072 + 1477))) then
						local v183 = 0 - 0;
						local v184;
						while true do
							if ((v183 == (1445 - (695 + 750))) or ((751 - 531) >= (4663 - 1641))) then
								v184 = v35.NamedUnit(100 - 75, v65);
								if (((3173 - (285 + 66)) == (6577 - 3755)) and v184 and v31.SourceofMagic:IsCastable() and (v184:BuffRemains(v31.SourceofMagicBuff) < (1610 - (682 + 628)))) then
									if (v21(v33.SourceofMagicName) or ((172 + 889) == (2156 - (176 + 123)))) then
										return "source_of_magic precombat";
									end
								end
								break;
							end
						end
					end
					local v164 = v35.HandleDPSPotion(v13:BuffUp(v31.IridescenceBlueBuff));
					if (((1155 + 1605) > (990 + 374)) and v164) then
						return v164;
					end
					if (v38 or ((5171 - (239 + 30)) <= (978 + 2617))) then
						local v185 = 0 + 0;
						local v186;
						while true do
							if ((v185 == (0 - 0)) or ((12017 - 8165) == (608 - (306 + 9)))) then
								v186 = v99();
								if (v186 or ((5440 - 3881) == (798 + 3790))) then
									return v186;
								end
								break;
							end
						end
					end
					if ((v71 >= (2 + 1)) or ((2159 + 2325) == (2253 - 1465))) then
						local v187 = v102();
						if (((5943 - (1140 + 235)) >= (2487 + 1420)) and v187) then
							return v187;
						end
						if (((1143 + 103) < (891 + 2579)) and v25(v31.Pool)) then
							return "Pool for Aoe()";
						end
					end
					local v165 = v103();
					if (((4120 - (33 + 19)) >= (351 + 621)) and v165) then
						return v165;
					end
				end
				if (((1477 - 984) < (1715 + 2178)) and v25(v31.Pool)) then
					return "Pool for ST()";
				end
				break;
			end
			if ((v124 == (9 - 4)) or ((1382 + 91) >= (4021 - (586 + 103)))) then
				if (v35.TargetIsValid() or v13:AffectingCombat() or ((369 + 3682) <= (3561 - 2404))) then
					local v166 = 1488 - (1309 + 179);
					while true do
						if (((1089 - 485) < (1254 + 1627)) and (v166 == (2 - 1))) then
							if ((v87 == (8393 + 2718)) or ((1912 - 1012) == (6728 - 3351))) then
								v87 = v10.FightRemains(v69, false);
							end
							break;
						end
						if (((5068 - (295 + 314)) > (1451 - 860)) and (v166 == (1962 - (1300 + 662)))) then
							v86 = v10.BossFightRemains(nil, true);
							v87 = v86;
							v166 = 3 - 2;
						end
					end
				end
				v88 = v13:GCD() + (1755.25 - (1178 + 577));
				v83 = v13:SpellHaste();
				v124 = 4 + 2;
			end
			if (((10045 - 6647) >= (3800 - (851 + 554))) and (v124 == (0 + 0))) then
				v106();
				v36 = EpicSettings.Toggles['ooc'];
				v37 = EpicSettings.Toggles['aoe'];
				v124 = 2 - 1;
			end
			if ((v124 == (8 - 4)) or ((2485 - (115 + 187)) >= (2163 + 661))) then
				v69 = v13:GetEnemiesInRange(24 + 1);
				v70 = v14:GetEnemiesInSplashRange(31 - 23);
				if (((3097 - (160 + 1001)) == (1694 + 242)) and v37) then
					v71 = v14:GetEnemiesInSplashRangeCount(6 + 2);
				else
					v71 = 1 - 0;
				end
				v124 = 363 - (237 + 121);
			end
			if ((v124 == (903 - (525 + 372))) or ((9160 - 4328) < (14170 - 9857))) then
				v84 = (143 - (96 + 46)) * v83;
				if (((4865 - (643 + 134)) > (1399 + 2475)) and ((v35.TargetIsValid() and v36) or v13:AffectingCombat())) then
					local v167 = 0 - 0;
					while true do
						if (((16083 - 11751) == (4155 + 177)) and (v167 == (0 - 0))) then
							v78 = v13:BuffUp(v31.Dragonrage);
							v79 = (v78 and v13:BuffRemains(v31.Dragonrage)) or (0 - 0);
							break;
						end
					end
				end
				if (((4718 - (316 + 403)) >= (1928 + 972)) and not v13:AffectingCombat()) then
					if ((v48 and v31.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v31.BlessingoftheBronzeBuff, true) or v35.GroupBuffMissing(v31.BlessingoftheBronzeBuff))) or ((6942 - 4417) > (1469 + 2595))) then
						if (((11007 - 6636) == (3098 + 1273)) and v25(v31.BlessingoftheBronze)) then
							return "blessing_of_the_bronze precombat";
						end
					end
				end
				v124 = 3 + 4;
			end
			if (((10 - 7) == v124) or ((1270 - 1004) > (10357 - 5371))) then
				if (((114 + 1877) >= (1820 - 895)) and v13:IsChanneling(v31.FireBreath)) then
					local v168 = 0 + 0;
					local v169;
					while true do
						if (((1338 - 883) < (2070 - (12 + 5))) and (v168 == (0 - 0))) then
							v169 = GetTime() - v13:CastStart();
							if ((v169 >= v13:EmpowerCastTime(v93)) or ((1761 - 935) == (10311 - 5460))) then
								local v189 = 0 - 0;
								while true do
									if (((38 + 145) == (2156 - (1656 + 317))) and (v189 == (0 + 0))) then
										v10.EpicSettingsS = v31.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				if (((929 + 230) <= (4754 - 2966)) and v13:IsChanneling(v31.EternitySurge)) then
					local v170 = 0 - 0;
					local v171;
					while true do
						if (((354 - (5 + 349)) == v170) or ((16657 - 13150) > (5589 - (266 + 1005)))) then
							v171 = GetTime() - v13:CastStart();
							if ((v171 >= v13:EmpowerCastTime(v92)) or ((2027 + 1048) <= (10116 - 7151))) then
								local v190 = 0 - 0;
								while true do
									if (((3061 - (561 + 1135)) <= (2620 - 609)) and (v190 == (0 - 0))) then
										v10.EpicSettingsS = v31.EternitySurge.ReturnID;
										return "Stopping EternitySurge";
									end
								end
							end
							break;
						end
					end
				end
				v89 = v13:BuffRemains(v31.HoverBuff) < (1068 - (507 + 559));
				v124 = 9 - 5;
			end
			if ((v124 == (6 - 4)) or ((3164 - (212 + 176)) > (4480 - (250 + 655)))) then
				if (v13:IsDeadOrGhost() or ((6964 - 4410) == (8393 - 3589))) then
					return;
				end
				if (((4031 - 1454) == (4533 - (1869 + 87))) and v49 and v31.Expunge:IsReady() and v35.UnitHasDispellableDebuffByPlayer(v16)) then
					local v172 = 0 - 0;
					local v173;
					local v174;
					while true do
						if ((v172 == (1901 - (484 + 1417))) or ((12 - 6) >= (3165 - 1276))) then
							v173 = v49;
							v174 = v35.FocusUnit(v173, nil, nil, nil, 793 - (48 + 725), v31.LivingFlame);
							v172 = 1 - 0;
						end
						if (((1357 - 851) <= (1100 + 792)) and ((2 - 1) == v172)) then
							if (v174 or ((562 + 1446) > (647 + 1571))) then
								return v174;
							end
							break;
						end
					end
				else
					local v175 = v95();
					if (((1232 - (152 + 701)) <= (5458 - (430 + 881))) and v175 and (v16:BuffRemains(v31.SourceofMagicBuff) < (115 + 185))) then
						local v188 = 895 - (557 + 338);
						while true do
							if (((0 + 0) == v188) or ((12720 - 8206) <= (3533 - 2524))) then
								v94 = v175:GUID();
								if (((v64 == "Auto") and (v175:BuffRemains(v31.SourceofMagicBuff) < (797 - 497)) and v31.SourceofMagic:IsCastable()) or ((7534 - 4038) == (1993 - (499 + 302)))) then
									local v192 = 866 - (39 + 827);
									while true do
										if (((0 - 0) == v192) or ((464 - 256) == (11752 - 8793))) then
											ShouldReturn = v35.FocusSpecifiedUnit(v175, 37 - 12);
											if (((367 + 3910) >= (3842 - 2529)) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								break;
							end
						end
					elseif (((414 + 2173) < (5022 - 1848)) and v39) then
						if (((v41 == "Everyone") and v31.VerdantEmbrace:IsReady()) or ((v42 == "Everyone") and v31.EmeraldBlossom:IsReady()) or ((4224 - (103 + 1)) <= (2752 - (475 + 79)))) then
							local v191 = 0 - 0;
							while true do
								if ((v191 == (0 - 0)) or ((207 + 1389) == (756 + 102))) then
									ShouldReturn = v35.FocusUnit(false, nil, nil, nil, 1523 - (1395 + 108), v31.LivingFlame);
									if (((9370 - 6150) == (4424 - (7 + 1197))) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						elseif (((v41 == "Not Tank") and v31.VerdantEmbrace:IsReady()) or ((612 + 790) > (1264 + 2356))) then
							local v197 = 319 - (27 + 292);
							local v198;
							local v199;
							while true do
								if (((7542 - 4968) == (3281 - 707)) and ((0 - 0) == v197)) then
									v198 = v35.GetFocusUnit(false, nil, "HEALER") or v13;
									v199 = v35.GetFocusUnit(false, nil, "DAMAGER") or v13;
									v197 = 1 - 0;
								end
								if (((3423 - 1625) < (2896 - (43 + 96))) and ((4 - 3) == v197)) then
									if ((v198:HealthPercentage() < v199:HealthPercentage()) or ((851 - 474) > (2161 + 443))) then
										ShouldReturn = v35.FocusUnit(false, nil, nil, "HEALER", 6 + 14, v31.LivingFlame);
										if (((1122 - 554) < (350 + 561)) and ShouldReturn) then
											return ShouldReturn;
										end
									end
									if (((6156 - 2871) < (1332 + 2896)) and (v199:HealthPercentage() < v198:HealthPercentage())) then
										ShouldReturn = v35.FocusUnit(false, nil, nil, "DAMAGER", 2 + 18, v31.LivingFlame);
										if (((5667 - (1414 + 337)) > (5268 - (1642 + 298))) and ShouldReturn) then
											return ShouldReturn;
										end
									end
									break;
								end
							end
						end
					end
				end
				if (((6517 - 4017) < (11043 - 7204)) and not v13:IsMoving()) then
					LastStationaryTime = GetTime();
				end
				v124 = 8 - 5;
			end
		end
	end
	local function v108()
		local v125 = 0 + 0;
		while true do
			if (((395 + 112) == (1479 - (357 + 615))) and (v125 == (0 + 0))) then
				v35.DispellableDebuffs = v35.DispellablePoisonDebuffs;
				v20.Print("Devastation Evoker by Epic BoomK.");
				v125 = 2 - 1;
			end
			if (((206 + 34) <= (6782 - 3617)) and (v125 == (1 + 0))) then
				EpicSettings.SetupVersion("Devastation Evoker X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v20.SetAPL(100 + 1367, v107, v108);
end;
return v0["Epix_Evoker_Devastation.lua"]();

