local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((194 + 352) <= (2935 - (673 + 1185))) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1638 - 642) > (3077 + 1224))) then
			v6 = v0[v4];
			if (((3042 + 1028) > (927 - 240)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v15 = v12.Focus;
	local v16 = v12.Pet;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.CastPooling;
	local v22 = v19.CastAnnotated;
	local v23 = v19.CastSuggested;
	local v24 = v19.Press;
	local v25 = v19.Macro;
	local v26 = v19.Commons.Evoker;
	local v27 = v19.Commons.Everyone.num;
	local v28 = v19.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = v17.Evoker.Devastation;
	local v31 = v18.Evoker.Devastation;
	local v32 = v25.Evoker.Devastation;
	local v33 = {};
	local v34 = v19.Commons.Everyone;
	local v35 = false;
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
	local v65 = v13:GetEquipment();
	local v66 = (v65[25 - 12] and v18(v65[24 - 11])) or v18(1880 - (446 + 1434));
	local v67 = (v65[1297 - (1040 + 243)] and v18(v65[41 - 27])) or v18(1847 - (559 + 1288));
	local v68;
	local v69;
	local v70;
	local v71 = ((v30.EssenceAttunement:IsAvailable()) and (1933 - (609 + 1322))) or (455 - (13 + 441));
	local v72 = 7 - 5;
	local v73, v74, v75;
	local v76;
	local v77, v78;
	local v79 = 10 - 6;
	local v80 = 64 - 51;
	local v81 = v30.BlastFurnace:TalentRank();
	local v82;
	local v83;
	local v84 = false;
	local v85 = 414 + 10697;
	local v86 = 40352 - 29241;
	local v87;
	local v88;
	local v89 = 0 + 0;
	local v90 = 0 + 0;
	local v91 = 2 - 1;
	local v92 = 1 + 0;
	local v93;
	local function v94()
		local v108 = 0 - 0;
		local v109;
		local v110;
		while true do
			if ((v108 == (0 + 0)) or ((365 + 291) >= (2393 + 937))) then
				v109 = nil;
				if (UnitInRaid("player") or ((2093 + 399) <= (328 + 7))) then
					v109 = v12.Raid;
				elseif (((4755 - (153 + 280)) >= (7397 - 4835)) and UnitInParty("player")) then
					v109 = v12.Party;
				else
					return false;
				end
				v108 = 1 + 0;
			end
			if ((v108 == (1 + 0)) or ((1904 + 1733) >= (3422 + 348))) then
				v110 = nil;
				for v146, v147 in pairs(v109) do
					if ((v147:Exists() and (UnitGroupRolesAssigned(v146) == "HEALER")) or ((1724 + 655) > (6970 - 2392))) then
						v110 = v147;
					end
				end
				v108 = 2 + 0;
			end
			if ((v108 == (669 - (89 + 578))) or ((346 + 137) > (1544 - 801))) then
				return v110;
			end
		end
	end
	v10:RegisterForEvent(function()
		v65 = v13:GetEquipment();
		v66 = (v65[1062 - (572 + 477)] and v18(v65[2 + 11])) or v18(0 + 0);
		v67 = (v65[2 + 12] and v18(v65[100 - (84 + 2)])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v111 = 0 + 0;
		while true do
			if (((3296 - (497 + 345)) > (15 + 563)) and (v111 == (0 + 0))) then
				v71 = ((v30.EssenceAttunement:IsAvailable()) and (1335 - (605 + 728))) or (1 + 0);
				v81 = v30.BlastFurnace:TalentRank();
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v112 = 0 - 0;
		local v113;
		while true do
			if (((43 + 887) < (16482 - 12024)) and ((1 + 0) == v112)) then
				v86 = 30784 - 19673;
				for v148 in pairs(v26.FirestormTracker) do
					v26.FirestormTracker[v148] = nil;
				end
				break;
			end
			if (((500 + 162) <= (1461 - (457 + 32))) and (v112 == (0 + 0))) then
				v113 = false;
				v85 = 12513 - (832 + 570);
				v112 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v95()
		if (((1140 + 3230) == (15464 - 11094)) and (v30.Firestorm:TimeSinceLastCast() > (6 + 6))) then
			return false;
		end
		if (v26.FirestormTracker[v14:GUID()] or ((5558 - (588 + 208)) <= (2320 - 1459))) then
			if ((v26.FirestormTracker[v14:GUID()] > (GetTime() - (1802.5 - (884 + 916)))) or ((2955 - 1543) == (2473 + 1791))) then
				return true;
			end
		end
		return false;
	end
	local function v96()
		local v114 = 653 - (232 + 421);
		while true do
			if ((v114 == (1889 - (1569 + 320))) or ((778 + 2390) < (410 + 1743))) then
				if ((v63 == "Auto") or ((16768 - 11792) < (1937 - (316 + 289)))) then
					if (((12114 - 7486) == (214 + 4414)) and v30.SourceofMagic:IsCastable() and v15:IsInRange(1478 - (666 + 787)) and (v93 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (725 - (360 + 65)))) then
						if (v20(v32.SourceofMagicFocus) or ((51 + 3) == (649 - (79 + 175)))) then
							return "source_of_magic precombat";
						end
					end
				end
				if (((128 - 46) == (64 + 18)) and (v63 == "Selected")) then
					local v151 = 0 - 0;
					local v152;
					while true do
						if ((v151 == (0 - 0)) or ((1480 - (503 + 396)) < (463 - (92 + 89)))) then
							v152 = v34.NamedUnit(48 - 23, v64);
							if ((v152 and v30.SourceofMagic:IsCastable() and (v152:BuffRemains(v30.SourceofMagicBuff) < (154 + 146))) or ((2728 + 1881) < (9770 - 7275))) then
								if (((158 + 994) == (2626 - 1474)) and v20(v32.SourceofMagicName)) then
									return "source_of_magic precombat";
								end
							end
							break;
						end
					end
				end
				v114 = 1 + 0;
			end
			if (((906 + 990) <= (10422 - 7000)) and (v114 == (1 + 1))) then
				if ((v30.LivingFlame:IsCastable() and not v30.Firestorm:IsAvailable()) or ((1509 - 519) > (2864 - (485 + 759)))) then
					if (v24(v30.LivingFlame, not v14:IsInRange(57 - 32), v88) or ((2066 - (442 + 747)) > (5830 - (832 + 303)))) then
						return "living_flame precombat";
					end
				end
				if (((3637 - (88 + 858)) >= (565 + 1286)) and v30.AzureStrike:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((2471 + 514) >= (200 + 4656))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
			if (((5065 - (766 + 23)) >= (5899 - 4704)) and (v114 == (1 - 0))) then
				v83 = (2 - 1) * v82;
				if (((10969 - 7737) <= (5763 - (1036 + 37))) and v30.Firestorm:IsCastable()) then
					if (v24(v30.Firestorm, not v14:IsInRange(18 + 7), v88) or ((1744 - 848) >= (2475 + 671))) then
						return "firestorm precombat";
					end
				end
				v114 = 1482 - (641 + 839);
			end
		end
	end
	local function v97()
		if (((3974 - (910 + 3)) >= (7540 - 4582)) and v30.ObsidianScales:IsCastable() and v13:BuffDown(v30.ObsidianScales) and (v13:HealthPercentage() < v59) and v58) then
			if (((4871 - (1466 + 218)) >= (296 + 348)) and v24(v30.ObsidianScales)) then
				return "obsidian_scales defensives";
			end
		end
		if (((1792 - (556 + 592)) <= (251 + 453)) and v31.Healthstone:IsReady() and v50 and (v13:HealthPercentage() <= v51)) then
			if (((1766 - (329 + 479)) > (1801 - (174 + 680))) and v24(v32.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if (((15435 - 10943) >= (5500 - 2846)) and v30.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v57) and v56) then
			if (((2458 + 984) >= (2242 - (396 + 343))) and v20(v30.RenewingBlaze, nil, nil)) then
				return "RenewingBlaze main 6";
			end
		end
		if ((v44 and (v13:HealthPercentage() <= v46)) or ((281 + 2889) <= (2941 - (29 + 1448)))) then
			if ((v45 == "Refreshing Healing Potion") or ((6186 - (135 + 1254)) == (16530 - 12142))) then
				if (((2572 - 2021) <= (454 + 227)) and v31.RefreshingHealingPotion:IsReady()) then
					if (((4804 - (389 + 1138)) > (981 - (102 + 472))) and v24(v32.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v98()
		if (((4431 + 264) >= (785 + 630)) and ((v77 and ((v70 >= (3 + 0)) or v13:BuffDown(v30.SpoilsofNeltharusVers) or ((v78 + ((1549 - (320 + 1225)) * v27(v30.EternitySurge:CooldownRemains() <= ((v87 * (2 - 0)) + v27(v30.FireBreath:CooldownRemains() <= (v87 * (2 + 0))))))) <= (1482 - (157 + 1307))))) or (v86 <= (1879 - (821 + 1038))))) then
			ShouldReturn = v34.HandleTopTrinket(v33, v37, 99 - 59, nil);
			if (ShouldReturn or ((352 + 2860) <= (1676 - 732))) then
				return ShouldReturn;
			end
			ShouldReturn = v34.HandleBottomTrinket(v33, v37, 15 + 25, nil);
			if (ShouldReturn or ((7673 - 4577) <= (2824 - (834 + 192)))) then
				return ShouldReturn;
			end
		end
	end
	local function v99()
		local v115 = 0 + 0;
		while true do
			if (((908 + 2629) == (76 + 3461)) and (v115 == (0 - 0))) then
				if (((4141 - (300 + 4)) >= (420 + 1150)) and v30.EternitySurge:CooldownDown()) then
					return nil;
				end
				if ((v70 <= ((2 - 1) + v27(v30.EternitysSpan:IsAvailable()))) or ((v78 < ((363.75 - (112 + 250)) * v82)) and (v78 >= ((1 + 0) * v82))) or (v77 and ((v70 == (12 - 7)) or (not v30.EternitysSpan:IsAvailable() and (v70 >= (4 + 2))) or (v30.EternitysSpan:IsAvailable() and (v70 >= (5 + 3))))) or ((2207 + 743) == (1891 + 1921))) then
					v89 = 1 + 0;
				elseif (((6137 - (1001 + 413)) >= (5168 - 2850)) and ((v70 <= ((884 - (244 + 638)) + ((695 - (627 + 66)) * v27(v30.EternitysSpan:IsAvailable())))) or ((v78 < ((5.5 - 3) * v82)) and (v78 >= ((603.75 - (512 + 90)) * v82))))) then
					v89 = 1908 - (1665 + 241);
				elseif ((v70 <= ((720 - (373 + 344)) + ((2 + 1) * v27(v30.EternitysSpan:IsAvailable())))) or not v30.FontofMagic:IsAvailable() or ((v78 <= ((1.25 + 2) * v82)) and (v78 >= ((5.5 - 3) * v82))) or ((3430 - 1403) > (3951 - (35 + 1064)))) then
					v89 = 3 + 0;
				else
					v89 = 8 - 4;
				end
				v115 = 1 + 0;
			end
			if ((v115 == (1237 - (298 + 938))) or ((2395 - (233 + 1026)) > (5983 - (636 + 1030)))) then
				v91 = v89;
				if (((2428 + 2320) == (4638 + 110)) and v24(v30.EternitySurge, not v14:IsInRange(9 + 21), true)) then
					return "eternity_surge empower " .. v89;
				end
				break;
			end
		end
	end
	local function v100()
		if (((253 + 3483) <= (4961 - (55 + 166))) and v30.FireBreath:CooldownDown()) then
			return nil;
		end
		local v116 = v14:DebuffRemains(v30.FireBreath);
		if ((v77 and (v70 <= (1 + 1))) or ((v70 == (1 + 0)) and not v30.EverburningFlame:IsAvailable()) or ((v78 < ((3.75 - 2) * v82)) and (v78 >= ((298 - (36 + 261)) * v82))) or ((5928 - 2538) <= (4428 - (34 + 1334)))) then
			v90 = 1 + 0;
		elseif ((not v95() and v30.EverburningFlame:IsAvailable() and (v70 <= (3 + 0))) or ((v70 == (1285 - (1035 + 248))) and not v30.EverburningFlame:IsAvailable()) or ((v78 < ((23.5 - (20 + 1)) * v82)) and (v78 >= ((1.75 + 0) * v82))) or ((1318 - (134 + 185)) > (3826 - (549 + 584)))) then
			v90 = 687 - (314 + 371);
		elseif (((1589 - 1126) < (1569 - (478 + 490))) and (not v30.FontofMagic:IsAvailable() or (v95() and v30.EverburningFlame:IsAvailable() and (v70 <= (2 + 1))) or ((v78 <= ((1175.25 - (786 + 386)) * v82)) and (v78 >= ((6.5 - 4) * v82))))) then
			v90 = 1382 - (1055 + 324);
		else
			v90 = 1344 - (1093 + 247);
		end
		v92 = v90;
		if (v22(v30.FireBreath, false, "1", not v14:IsInRange(27 + 3), nil) or ((230 + 1953) < (2727 - 2040))) then
			return "fire_breath empower " .. v90 .. " main 12";
		end
	end
	local function v101()
		if (((15438 - 10889) == (12943 - 8394)) and v30.Dragonrage:IsCastable() and Cds and ((v14:TimeToDie() >= (80 - 48)) or (v86 < (11 + 19)))) then
			if (((17998 - 13326) == (16103 - 11431)) and v24(v30.Dragonrage)) then
				return "dragonrage aoe 2";
			end
		end
		if ((v30.TipTheScales:IsCastable() and v37 and v77 and ((v70 <= (3 + 0 + ((7 - 4) * v27(v30.EternitysSpan:IsAvailable())))) or v30.FireBreath:CooldownDown())) or ((4356 - (364 + 324)) < (1082 - 687))) then
			if (v24(v30.TipTheScales) or ((9996 - 5830) == (151 + 304))) then
				return "tip_the_scales aoe 4";
			end
		end
		if (((not v30.Dragonrage:IsAvailable() or (v76 > v79) or not v30.Animosity:IsAvailable()) and ((((v13:BuffRemains(v30.PowerSwellBuff) < v83) or (not v30.Volatility:IsAvailable() and (v70 == (12 - 9)))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v83)) or v77) and ((v14:TimeToDie() >= (12 - 4)) or (v86 < (91 - 61)))) or ((5717 - (1249 + 19)) == (2404 + 259))) then
			local v124 = 0 - 0;
			local v125;
			while true do
				if ((v124 == (1086 - (686 + 400))) or ((3356 + 921) < (3218 - (73 + 156)))) then
					v125 = v100();
					if (v125 or ((5 + 865) >= (4960 - (721 + 90)))) then
						return v125;
					end
					break;
				end
			end
		end
		if (((25 + 2187) < (10334 - 7151)) and (v77 or not v30.Dragonrage:IsAvailable() or ((v30.Dragonrage:CooldownRemains() > v79) and ((v13:BuffRemains(v30.PowerSwellBuff) < v83) or (not v30.Volatility:IsAvailable() and (v70 == (473 - (224 + 246))))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v83) and ((v14:TimeToDie() >= (12 - 4)) or (v86 < (55 - 25)))))) then
			local v126 = 0 + 0;
			local v127;
			while true do
				if (((111 + 4535) > (2198 + 794)) and (v126 == (0 - 0))) then
					v127 = v99();
					if (((4771 - 3337) < (3619 - (203 + 310))) and v127) then
						return v127;
					end
					break;
				end
			end
		end
		if (((2779 - (1238 + 755)) < (212 + 2811)) and v30.DeepBreath:IsCastable() and v37 and not v77 and (v13:EssenceDeficit() > (1537 - (709 + 825))) and v34.TargetIsMouseover()) then
			if (v24(v32.DeepBreathCursor, not v14:IsInRange(55 - 25)) or ((3556 - 1114) < (938 - (196 + 668)))) then
				return "deep_breath aoe 6";
			end
		end
		if (((17905 - 13370) == (9393 - 4858)) and v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v71) or not v30.ArcaneVigor:IsAvailable())) then
			if (v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar)) or ((3842 - (171 + 662)) <= (2198 - (4 + 89)))) then
				return "shattering_star aoe 8";
			end
		end
		if (((6414 - 4584) < (1336 + 2333)) and v30.Firestorm:IsCastable()) then
			if (v24(v30.Firestorm, not v14:IsInRange(109 - 84), v88) or ((561 + 869) >= (5098 - (35 + 1451)))) then
				return "firestorm aoe 10";
			end
		end
		if (((4136 - (28 + 1425)) >= (4453 - (941 + 1052))) and v30.Pyre:IsReady() and ((v70 >= (5 + 0)) or ((v70 >= (1518 - (822 + 692))) and ((v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or not v30.EternitysSpan:IsAvailable())) or ((v70 >= (5 - 1)) and v30.Volatility:IsAvailable()) or ((v70 >= (2 + 1)) and v30.Volatility:IsAvailable() and v30.ChargedBlast:IsAvailable() and v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or ((v70 >= (300 - (45 + 252))) and v30.Volatility:IsAvailable() and not v30.ChargedBlast:IsAvailable() and (v13:BuffUp(v30.IridescenceRedBuff) or v13:BuffDown(v30.EssenceBurstBuff))) or (v13:BuffStack(v30.ChargedBlastBuff) >= (15 + 0)))) then
			if (v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre)) or ((621 + 1183) >= (7970 - 4695))) then
				return "pyre aoe 14";
			end
		end
		if ((v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - (434 - (114 + 319))))) or ((2034 - 617) > (4649 - 1020))) then
			if (((3057 + 1738) > (598 - 196)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
				return "living_flame aoe 14";
			end
		end
		if (((10084 - 5271) > (5528 - (556 + 1407))) and v30.Disintegrate:IsReady()) then
			if (((5118 - (741 + 465)) == (4377 - (170 + 295))) and v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v88)) then
				return "disintegrate aoe 20";
			end
		end
		if (((1487 + 1334) <= (4431 + 393)) and v30.LivingFlame:IsCastable() and v30.Snapfire:IsAvailable() and v13:BuffUp(v30.BurnoutBuff)) then
			if (((4278 - 2540) <= (1820 + 375)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
				return "living_flame aoe 22";
			end
		end
		if (((27 + 14) <= (1710 + 1308)) and v30.AzureStrike:IsCastable()) then
			if (((3375 - (957 + 273)) <= (1098 + 3006)) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
				return "azure_strike aoe 24";
			end
		end
	end
	local function v102()
		local v117 = 0 + 0;
		while true do
			if (((10246 - 7557) < (12767 - 7922)) and ((5 - 3) == v117)) then
				if ((v30.Animosity:IsAvailable() and v77 and (v78 < (v87 + v83)) and ((v78 - v30.EternitySurge:CooldownRemains()) > (v83 * v27(v13:BuffDown(v30.TipTheScales))))) or ((11497 - 9175) > (4402 - (389 + 1391)))) then
					if (v24(v30.Pool) or ((2845 + 1689) == (217 + 1865))) then
						return "Wait for ES st 14";
					end
				end
				if ((v30.LivingFlame:IsCastable() and v77 and (v78 < ((v71 - v13:BuffStack(v30.EssenceBurstBuff)) * v87)) and v13:BuffUp(v30.BurnoutBuff)) or ((3576 - 2005) > (2818 - (783 + 168)))) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88) or ((8907 - 6253) >= (2947 + 49))) then
						return "living_flame st 16";
					end
				end
				if (((4289 - (309 + 2)) > (6460 - 4356)) and v30.AzureStrike:IsCastable() and v77 and (v78 < ((v71 - v13:BuffStack(v30.EssenceBurstBuff)) * v87))) then
					if (((4207 - (1090 + 122)) > (500 + 1041)) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return "azure_strike st 18";
					end
				end
				if (((10911 - 7662) > (653 + 300)) and v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and ((v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff)) or (v13:BuffDown(v30.LeapingFlamesBuff) and (v13:BuffStack(v30.EssenceBurstBuff) < v71))) and (v13:Essence() < (v13:EssenceMax() - (1119 - (628 + 490))))) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88) or ((587 + 2686) > (11322 - 6749))) then
						return "living_flame st 20";
					end
				end
				v117 = 13 - 10;
			end
			if ((v117 == (777 - (431 + 343))) or ((6363 - 3212) < (3714 - 2430))) then
				if ((v30.Pyre:IsReady() and v95() and v30.RagingInferno:IsAvailable() and (v13:BuffStack(v30.ChargedBlastBuff) == (16 + 4)) and (v70 >= (1 + 1))) or ((3545 - (556 + 1139)) == (1544 - (6 + 9)))) then
					if (((151 + 670) < (1088 + 1035)) and v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre))) then
						return "pyre st 22";
					end
				end
				if (((1071 - (28 + 141)) < (901 + 1424)) and v30.Disintegrate:IsReady()) then
					if (((1058 - 200) <= (2098 + 864)) and v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v88)) then
						return "disintegrate st 24";
					end
				end
				if ((v30.Firestorm:IsCastable() and not v77 and v14:DebuffDown(v30.ShatteringStar)) or ((5263 - (486 + 831)) < (3351 - 2063))) then
					if (v24(v30.Firestorm, not v14:IsInRange(88 - 63), v88) or ((613 + 2629) == (1792 - 1225))) then
						return "firestorm st 26";
					end
				end
				if ((v30.DeepBreath:IsCastable() and v37 and not v77 and (v70 >= (1265 - (668 + 595))) and v34.TargetIsMouseover()) or ((763 + 84) >= (255 + 1008))) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(81 - 51)) or ((2543 - (23 + 267)) == (3795 - (1129 + 815)))) then
						return "deep_breath st 28";
					end
				end
				v117 = 391 - (371 + 16);
			end
			if (((1750 - (1326 + 424)) == v117) or ((3952 - 1865) > (8667 - 6295))) then
				if ((v30.Firestorm:IsCastable() and (v13:BuffUp(v30.SnapfireBuff))) or ((4563 - (88 + 30)) < (4920 - (720 + 51)))) then
					if (v24(v30.Firestorm, not v14:IsInRange(55 - 30), v88) or ((3594 - (421 + 1355)) == (140 - 55))) then
						return "firestorm st 4";
					end
				end
				if (((310 + 320) < (3210 - (286 + 797))) and v30.Dragonrage:IsCastable() and v37 and (((v30.FireBreath:CooldownRemains() < v87) and (v30.EternitySurge:CooldownRemains() < ((7 - 5) * v87))) or (v86 < (49 - 19)))) then
					if (v24(v30.Dragonrage) or ((2377 - (397 + 42)) == (786 + 1728))) then
						return "dragonrage st 6";
					end
				end
				if (((5055 - (24 + 776)) >= (84 - 29)) and v30.TipTheScales:IsCastable() and v37 and ((v77 and v30.EternitySurge:CooldownUp() and v30.FireBreath:CooldownDown() and not v30.EverburningFlame:IsAvailable()) or (v30.EverburningFlame:IsAvailable() and v30.FireBreath:CooldownUp()))) then
					if (((3784 - (222 + 563)) > (2546 - 1390)) and v24(v30.TipTheScales)) then
						return "tip_the_scales st 8";
					end
				end
				if (((1692 + 658) > (1345 - (23 + 167))) and (not v30.Dragonrage:IsAvailable() or (v76 > v80) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v83) or v77) and ((v14:TimeToDie() >= (1806 - (690 + 1108))) or (v86 < (11 + 19)))) then
					local v153 = 0 + 0;
					local v154;
					while true do
						if (((4877 - (40 + 808)) <= (800 + 4053)) and (v153 == (0 - 0))) then
							v154 = v100();
							if (v154 or ((494 + 22) > (1817 + 1617))) then
								return v154;
							end
							break;
						end
					end
				end
				v117 = 1 + 0;
			end
			if (((4617 - (47 + 524)) >= (1969 + 1064)) and (v117 == (2 - 1))) then
				if ((v30.Disintegrate:IsReady() and (v78 > (27 - 8)) and (v30.FireBreath:CooldownRemains() > (63 - 35)) and v30.EyeofInfinity:IsAvailable() and v13:HasTier(1756 - (1165 + 561), 1 + 1)) or ((8420 - 5701) <= (553 + 894))) then
					if (v20(v30.Disintegrate, nil, nil, not v14:IsSpellInRange(v30.Disintegrate)) or ((4613 - (341 + 138)) < (1060 + 2866))) then
						return "disintegrate st 9";
					end
				end
				if ((v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v71) or not v30.ArcaneVigor:IsAvailable())) or ((337 - 173) >= (3111 - (89 + 237)))) then
					if (v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar)) or ((1688 - 1163) == (4439 - 2330))) then
						return "shattering_star st 10";
					end
				end
				if (((914 - (581 + 300)) == (1253 - (855 + 365))) and (not v30.Dragonrage:IsAvailable() or (v76 > v80) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v83) or v77) and ((v14:TimeToDie() >= (18 - 10)) or (v86 < (10 + 20)))) then
					local v155 = 1235 - (1030 + 205);
					local v156;
					while true do
						if (((2868 + 186) <= (3736 + 279)) and (v155 == (286 - (156 + 130)))) then
							v156 = v99();
							if (((4251 - 2380) < (5699 - 2317)) and v156) then
								return v156;
							end
							break;
						end
					end
				end
				if (((2648 - 1355) <= (571 + 1595)) and v30.Animosity:IsAvailable() and v77 and (v78 < (v87 + (v83 * v27(v13:BuffDown(v30.TipTheScales))))) and ((v78 - v30.FireBreath:CooldownRemains()) >= (v83 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (v24(v30.Pool) or ((1504 + 1075) < (192 - (10 + 59)))) then
						return "Wait for FB st 12";
					end
				end
				v117 = 1 + 1;
			end
			if (((19 - 15) == v117) or ((2009 - (671 + 492)) >= (1886 + 482))) then
				if ((v30.DeepBreath:IsCastable() and v37 and not v77 and v30.ImminentDestruction:IsAvailable() and v14:DebuffDown(v30.ShatteringStar) and v34.TargetIsMouseover()) or ((5227 - (369 + 846)) <= (889 + 2469))) then
					if (((1275 + 219) <= (4950 - (1036 + 909))) and v24(v32.DeepBreathCursor, not v14:IsInRange(24 + 6))) then
						return "deep_breath st 30";
					end
				end
				if (v30.LivingFlame:IsCastable() or ((5222 - 2111) == (2337 - (11 + 192)))) then
					if (((1191 + 1164) == (2530 - (135 + 40))) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame st 32";
					end
				end
				if (v30.AzureStrike:IsCastable() or ((1424 - 836) <= (261 + 171))) then
					if (((10567 - 5770) >= (5839 - 1944)) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return "azure_strike st 34";
					end
				end
				break;
			end
		end
	end
	local function v103()
		local v118 = 176 - (50 + 126);
		while true do
			if (((9960 - 6383) == (792 + 2785)) and (v118 == (1413 - (1233 + 180)))) then
				if (((4763 - (522 + 447)) > (5114 - (107 + 1314))) and (v40 == "Player Only")) then
					if ((v30.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v42)) or ((592 + 683) == (12493 - 8393))) then
						if (v20(v32.VerdantEmbracePlayer, nil) or ((676 + 915) >= (7109 - 3529))) then
							return "verdant_embrace main 40";
						end
					end
				end
				if (((3889 - 2906) <= (3718 - (716 + 1194))) and ((v40 == "Everyone") or (v40 == "Not Tank"))) then
					if ((v30.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v42)) or ((37 + 2113) <= (129 + 1068))) then
						if (((4272 - (74 + 429)) >= (2262 - 1089)) and v20(v32.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace main 40";
						end
					end
				end
				v118 = 1 + 0;
			end
			if (((3399 - 1914) == (1051 + 434)) and (v118 == (2 - 1))) then
				if ((v41 == "Player Only") or ((8196 - 4881) <= (3215 - (279 + 154)))) then
					if ((v30.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v43)) or ((1654 - (454 + 324)) >= (2332 + 632))) then
						if (v20(v32.EmeraldBlossomPlayer, nil) or ((2249 - (12 + 5)) > (1347 + 1150))) then
							return "emerald_blossom main 42";
						end
					end
				end
				if ((v41 == "Everyone") or ((5376 - 3266) <= (123 + 209))) then
					if (((4779 - (277 + 816)) > (13554 - 10382)) and v30.EmeraldBlossom:IsReady() and (v15:HealthPercentage() < v43)) then
						if (v20(v32.EmeraldBlossomFocus, nil) or ((5657 - (1058 + 125)) < (154 + 666))) then
							return "emerald_blossom main 42";
						end
					end
				end
				break;
			end
		end
	end
	local function v104()
		local v119 = 975 - (815 + 160);
		while true do
			if (((18359 - 14080) >= (6841 - 3959)) and (v119 == (1 + 0))) then
				if ((v30.OppressingRoar:IsReady() and v55 and v34.UnitHasEnrageBuff(v14)) or ((5931 - 3902) >= (5419 - (41 + 1857)))) then
					if (v24(v30.OppressingRoar) or ((3930 - (1222 + 671)) >= (11997 - 7355))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if (((2472 - 752) < (5640 - (229 + 953))) and ((1774 - (1111 + 663)) == v119)) then
				if (not v15 or not v15:Exists() or not v15:IsInRange(1609 - (874 + 705)) or not v34.DispellableFriendlyUnit() or ((62 + 374) > (2062 + 959))) then
					return;
				end
				if (((1481 - 768) <= (24 + 823)) and v30.Expunge:IsReady() and (v34.UnitHasPoisonDebuff(v15))) then
					if (((2833 - (642 + 37)) <= (920 + 3111)) and v24(v32.ExpungeFocus)) then
						return "Expunge dispel";
					end
				end
				v119 = 1 + 0;
			end
		end
	end
	local function v105()
		local v120 = 0 - 0;
		while true do
			if (((5069 - (233 + 221)) == (10671 - 6056)) and (v120 == (3 + 0))) then
				v49 = EpicSettings.Settings['DispelBuffs'];
				v50 = EpicSettings.Settings['UseHealthstone'];
				v51 = EpicSettings.Settings['HealthstoneHP'] or (1541 - (718 + 823));
				v120 = 3 + 1;
			end
			if ((v120 == (811 - (266 + 539))) or ((10730 - 6940) == (1725 - (636 + 589)))) then
				v58 = EpicSettings.Settings['UseObsidianScales'];
				v59 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
				v60 = EpicSettings.Settings['UseHover'];
				v120 = 14 - 7;
			end
			if (((71 + 18) < (81 + 140)) and (v120 == (1019 - (657 + 358)))) then
				v52 = EpicSettings.Settings['InterruptWithStun'];
				v53 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v54 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v120 = 11 - 6;
			end
			if (((3241 - (1151 + 36)) >= (1373 + 48)) and (v120 == (3 + 5))) then
				v64 = EpicSettings.Settings['SourceOfMagicName'] or "";
				break;
			end
			if (((2066 - 1374) < (4890 - (1552 + 280))) and ((834 - (64 + 770)) == v120)) then
				v40 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v41 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
				v42 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
				v120 = 2 - 1;
			end
			if (((1 + 1) == v120) or ((4497 - (157 + 1086)) == (3312 - 1657))) then
				v46 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UseBlessingOfTheBronze'];
				v48 = EpicSettings.Settings['DispelDebuffs'];
				v120 = 3 - 0;
			end
			if ((v120 == (9 - 2)) or ((2115 - (599 + 220)) == (9777 - 4867))) then
				v61 = EpicSettings.Settings['HoverTime'] or (1931 - (1813 + 118));
				v62 = EpicSettings.Settings['LandslideUsage'] or "";
				v63 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
				v120 = 6 + 2;
			end
			if (((4585 - (841 + 376)) == (4719 - 1351)) and (v120 == (2 + 3))) then
				v55 = EpicSettings.Settings['UseOppressingRoar'];
				v56 = EpicSettings.Settings['UseRenewingBlaze'];
				v57 = EpicSettings.Settings['RenewingBlazeHP'] or (0 - 0);
				v120 = 865 - (464 + 395);
			end
			if (((6782 - 4139) < (1833 + 1982)) and (v120 == (838 - (467 + 370)))) then
				v43 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 - 0);
				v44 = EpicSettings.Settings['UseHealingPotion'];
				v45 = EpicSettings.Settings['HealingPotionName'] or "";
				v120 = 2 + 0;
			end
		end
	end
	local function v106()
		local v121 = 0 - 0;
		while true do
			if (((299 + 1614) > (1146 - 653)) and (v121 == (528 - (150 + 370)))) then
				if (((6037 - (74 + 1208)) > (8431 - 5003)) and v13:AffectingCombat()) then
					local v157 = 0 - 0;
					local v158;
					while true do
						if (((983 + 398) <= (2759 - (14 + 376))) and (v157 == (0 - 0))) then
							v158 = v97();
							if (v158 or ((3134 + 1709) == (3588 + 496))) then
								return v158;
							end
							break;
						end
					end
				end
				if (((4453 + 216) > (1063 - 700)) and (v13:AffectingCombat() or v35)) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1413 + 464) >= (3216 - (23 + 55)))) then
						local v174 = 0 - 0;
						local v175;
						while true do
							if (((3165 + 1577) >= (3257 + 369)) and ((1 - 0) == v174)) then
								v175 = v34.InterruptWithStun(v30.TailSwipe, 3 + 5);
								if (v175 or ((5441 - (652 + 249)) == (2451 - 1535))) then
									return v175;
								end
								v174 = 1870 - (708 + 1160);
							end
							if ((v174 == (0 - 0)) or ((2107 - 951) > (4372 - (10 + 17)))) then
								v175 = v34.Interrupt(v30.Quell, 3 + 7, true);
								if (((3969 - (1400 + 332)) < (8149 - 3900)) and v175) then
									return v175;
								end
								v174 = 1909 - (242 + 1666);
							end
							if ((v174 == (1 + 1)) or ((984 + 1699) < (20 + 3))) then
								v175 = v34.Interrupt(v30.Quell, 950 - (850 + 90), true, Mouseover, v32.QuellMouseover);
								if (((1220 - 523) <= (2216 - (360 + 1030))) and v175) then
									return v175;
								end
								break;
							end
						end
					end
					v76 = v29(v30.Dragonrage:CooldownRemains(), v30.EternitySurge:CooldownRemains() - ((2 + 0) * v87), v30.FireBreath:CooldownRemains() - v87);
					if (((3118 - 2013) <= (1617 - 441)) and v30.Unravel:IsReady() and v14:EnemyAbsorb()) then
						if (((5040 - (909 + 752)) <= (5035 - (109 + 1114))) and v24(v30.Unravel, not v14:IsSpellInRange(v30.Unravel))) then
							return "unravel main 4";
						end
					end
					if (v49 or v48 or ((1442 - 654) >= (630 + 986))) then
						local v176 = 242 - (6 + 236);
						local v177;
						while true do
							if (((1169 + 685) <= (2720 + 659)) and ((0 - 0) == v176)) then
								v177 = v104();
								if (((7945 - 3396) == (5682 - (1076 + 57))) and v177) then
									return v177;
								end
								break;
							end
						end
					end
					if ((v38 and v13:AffectingCombat()) or ((497 + 2525) >= (3713 - (579 + 110)))) then
						local v178 = 0 + 0;
						local v179;
						while true do
							if (((4262 + 558) > (1167 + 1031)) and (v178 == (407 - (174 + 233)))) then
								v179 = v103();
								if (v179 or ((2963 - 1902) >= (8584 - 3693))) then
									return v179;
								end
								break;
							end
						end
					end
					if (((607 + 757) <= (5647 - (663 + 511))) and v60 and v13:AffectingCombat()) then
						if (((GetTime() - LastStationaryTime) > v61) or ((3208 + 387) <= (1 + 2))) then
							if (v30.Hover:IsReady() or ((14403 - 9731) == (2333 + 1519))) then
								if (((3670 - 2111) == (3773 - 2214)) and v24(v30.Hover)) then
									return "hover main 2";
								end
							end
						end
					end
					if ((v63 == "Auto") or ((837 + 915) <= (1533 - 745))) then
						if ((v30.SourceofMagic:IsCastable() and v15:IsInRange(18 + 7) and (v93 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (28 + 272))) or ((4629 - (478 + 244)) == (694 - (440 + 77)))) then
							if (((1578 + 1892) > (2031 - 1476)) and v20(v32.SourceofMagicFocus)) then
								return "source_of_magic precombat";
							end
						end
					end
					if ((v63 == "Selected") or ((2528 - (655 + 901)) == (120 + 525))) then
						local v180 = 0 + 0;
						local v181;
						while true do
							if (((2149 + 1033) >= (8520 - 6405)) and (v180 == (1445 - (695 + 750)))) then
								v181 = v34.NamedUnit(85 - 60, v64);
								if (((6007 - 2114) < (17812 - 13383)) and v181 and v30.SourceofMagic:IsCastable() and (v181:BuffRemains(v30.SourceofMagicBuff) < (651 - (285 + 66)))) then
									if (v20(v32.SourceofMagicName) or ((6682 - 3815) < (3215 - (682 + 628)))) then
										return "source_of_magic precombat";
									end
								end
								break;
							end
						end
					end
					local v159 = v34.HandleDPSPotion(v13:BuffUp(v30.IridescenceBlueBuff));
					if (v159 or ((290 + 1506) >= (4350 - (176 + 123)))) then
						return v159;
					end
					if (((678 + 941) <= (2725 + 1031)) and v37) then
						local v182 = 269 - (239 + 30);
						local v183;
						while true do
							if (((165 + 439) == (581 + 23)) and (v182 == (0 - 0))) then
								v183 = v98();
								if (v183 or ((13989 - 9505) == (1215 - (306 + 9)))) then
									return v183;
								end
								break;
							end
						end
					end
					if ((v70 >= (10 - 7)) or ((776 + 3683) <= (683 + 430))) then
						local v184 = v101();
						if (((1749 + 1883) > (9716 - 6318)) and v184) then
							return v184;
						end
						if (((5457 - (1140 + 235)) <= (3130 + 1787)) and v24(v30.Pool)) then
							return "Pool for Aoe()";
						end
					end
					local v160 = v102();
					if (((4432 + 400) >= (356 + 1030)) and v160) then
						return v160;
					end
				end
				if (((189 - (33 + 19)) == (50 + 87)) and v24(v30.Pool)) then
					return "Pool for ST()";
				end
				break;
			end
			if ((v121 == (8 - 5)) or ((692 + 878) >= (8495 - 4163))) then
				if (v13:IsChanneling(v30.FireBreath) or ((3811 + 253) <= (2508 - (586 + 103)))) then
					local v161 = 0 + 0;
					local v162;
					while true do
						if ((v161 == (0 - 0)) or ((6474 - (1309 + 179)) < (2841 - 1267))) then
							v162 = GetTime() - v13:CastStart();
							if (((1927 + 2499) > (461 - 289)) and (v162 >= v13:EmpowerCastTime(v92))) then
								local v186 = 0 + 0;
								while true do
									if (((1244 - 658) > (906 - 451)) and ((609 - (295 + 314)) == v186)) then
										v10.EpicSettingsS = v30.FireBreath.ReturnID;
										return "Stopping Fire Breath";
									end
								end
							end
							break;
						end
					end
				end
				if (((2028 - 1202) == (2788 - (1300 + 662))) and v13:IsChanneling(v30.EternitySurge)) then
					local v163 = 0 - 0;
					local v164;
					while true do
						if ((v163 == (1755 - (1178 + 577))) or ((2088 + 1931) > (13128 - 8687))) then
							v164 = GetTime() - v13:CastStart();
							if (((3422 - (851 + 554)) < (3768 + 493)) and (v164 >= v13:EmpowerCastTime(v91))) then
								v10.EpicSettingsS = v30.EternitySurge.ReturnID;
								return "Stopping EternitySurge";
							end
							break;
						end
					end
				end
				v88 = v13:BuffRemains(v30.HoverBuff) < (5 - 3);
				v121 = 8 - 4;
			end
			if (((5018 - (115 + 187)) > (62 + 18)) and (v121 == (0 + 0))) then
				v105();
				v35 = EpicSettings.Toggles['ooc'];
				v36 = EpicSettings.Toggles['aoe'];
				v121 = 3 - 2;
			end
			if ((v121 == (1163 - (160 + 1001))) or ((3069 + 438) == (2258 + 1014))) then
				if (v13:IsDeadOrGhost() or ((1792 - 916) >= (3433 - (237 + 121)))) then
					return;
				end
				if (((5249 - (525 + 372)) > (4841 - 2287)) and v48 and v30.Expunge:IsReady() and v34.DispellableFriendlyUnit()) then
					local v165 = v48;
					local v166 = v34.FocusUnit(v165, nil, nil, nil, 65 - 45, v30.LivingFlame);
					if (v166 or ((4548 - (96 + 46)) < (4820 - (643 + 134)))) then
						return v166;
					end
				elseif ((v94() and (v15:BuffRemains(v30.SourceofMagicBuff) < (109 + 191))) or ((4529 - 2640) >= (12560 - 9177))) then
					local v185 = 0 + 0;
					while true do
						if (((3712 - 1820) <= (5588 - 2854)) and ((719 - (316 + 403)) == v185)) then
							v93 = v94():GUID();
							if (((1279 + 644) < (6098 - 3880)) and (v63 == "Auto") and (v94():BuffRemains(v30.SourceofMagicBuff) < (109 + 191)) and v30.SourceofMagic:IsCastable()) then
								local v189 = 0 - 0;
								while true do
									if (((1540 + 633) > (123 + 256)) and (v189 == (0 - 0))) then
										ShouldReturn = v34.FocusSpecifiedUnit(v94(), 119 - 94);
										if (ShouldReturn or ((5382 - 2791) == (196 + 3213))) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
					end
				elseif (((8885 - 4371) > (163 + 3161)) and v38) then
					if (((v40 == "Everyone") and v30.VerdantEmbrace:IsReady()) or ((v41 == "Everyone") and v30.EmeraldBlossom:IsReady()) or ((611 - 403) >= (4845 - (12 + 5)))) then
						ShouldReturn = v34.FocusUnit(false, nil, nil, nil, 77 - 57, v30.LivingFlame);
						if (ShouldReturn or ((3376 - 1793) > (7581 - 4014))) then
							return ShouldReturn;
						end
					elseif (((v40 == "Not Tank") and v30.VerdantEmbrace:IsReady()) or ((3255 - 1942) == (162 + 632))) then
						local v192 = 1973 - (1656 + 317);
						local v193;
						local v194;
						while true do
							if (((2829 + 345) > (2326 + 576)) and (v192 == (2 - 1))) then
								if (((20276 - 16156) <= (4614 - (5 + 349))) and (v193:HealthPercentage() < v194:HealthPercentage())) then
									local v195 = 0 - 0;
									while true do
										if (((1271 - (266 + 1005)) == v195) or ((582 + 301) > (16302 - 11524))) then
											ShouldReturn = v34.FocusUnit(false, nil, nil, "HEALER", 26 - 6, v30.LivingFlame);
											if (ShouldReturn or ((5316 - (561 + 1135)) >= (6373 - 1482))) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								if (((13996 - 9738) > (2003 - (507 + 559))) and (v194:HealthPercentage() < v193:HealthPercentage())) then
									local v196 = 0 - 0;
									while true do
										if ((v196 == (0 - 0)) or ((5257 - (212 + 176)) < (1811 - (250 + 655)))) then
											ShouldReturn = v34.FocusUnit(false, nil, nil, "DAMAGER", 54 - 34, v30.LivingFlame);
											if (ShouldReturn or ((2140 - 915) > (6614 - 2386))) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								break;
							end
							if (((5284 - (1869 + 87)) > (7762 - 5524)) and (v192 == (1901 - (484 + 1417)))) then
								v193 = v34.GetFocusUnit(false, nil, "HEALER") or v13;
								v194 = v34.GetFocusUnit(false, nil, "DAMAGER") or v13;
								v192 = 2 - 1;
							end
						end
					end
				end
				if (((6433 - 2594) > (2178 - (48 + 725))) and not v13:IsMoving()) then
					LastStationaryTime = GetTime();
				end
				v121 = 4 - 1;
			end
			if ((v121 == (18 - 11)) or ((752 + 541) <= (1354 - 847))) then
				if ((v38 and v35 and not v13:AffectingCombat()) or ((811 + 2085) < (235 + 570))) then
					local v167 = 853 - (152 + 701);
					local v168;
					while true do
						if (((3627 - (430 + 881)) == (887 + 1429)) and (v167 == (895 - (557 + 338)))) then
							v168 = v103();
							if (v168 or ((760 + 1810) == (4319 - 2786))) then
								return v168;
							end
							break;
						end
					end
				end
				if ((v60 and (v35 or v13:AffectingCombat())) or ((3091 - 2208) == (3878 - 2418))) then
					if (((GetTime() - LastStationaryTime) > v61) or ((9954 - 5335) <= (1800 - (499 + 302)))) then
						if ((v30.Hover:IsReady() and v13:BuffDown(v30.Hover)) or ((4276 - (39 + 827)) > (11361 - 7245))) then
							if (v24(v30.Hover) or ((2016 - 1113) >= (12149 - 9090))) then
								return "hover main 2";
							end
						end
					end
				end
				if ((not v13:AffectingCombat() and v35 and not v13:IsCasting()) or ((6103 - 2127) < (245 + 2612))) then
					local v169 = 0 - 0;
					local v170;
					while true do
						if (((789 + 4141) > (3649 - 1342)) and (v169 == (104 - (103 + 1)))) then
							v170 = v96();
							if (v170 or ((4600 - (475 + 79)) < (2790 - 1499))) then
								return v170;
							end
							break;
						end
					end
				end
				v121 = 25 - 17;
			end
			if ((v121 == (1 + 4)) or ((3733 + 508) == (5048 - (1395 + 108)))) then
				if (v34.TargetIsValid() or v13:AffectingCombat() or ((11779 - 7731) > (5436 - (7 + 1197)))) then
					local v171 = 0 + 0;
					while true do
						if ((v171 == (1 + 0)) or ((2069 - (27 + 292)) >= (10176 - 6703))) then
							if (((4037 - 871) == (13277 - 10111)) and (v86 == (21911 - 10800))) then
								v86 = v10.FightRemains(v68, false);
							end
							break;
						end
						if (((3357 - 1594) < (3863 - (43 + 96))) and (v171 == (0 - 0))) then
							v85 = v10.BossFightRemains(nil, true);
							v86 = v85;
							v171 = 1 - 0;
						end
					end
				end
				v87 = v13:GCD() + 0.25 + 0;
				v82 = v13:SpellHaste();
				v121 = 2 + 4;
			end
			if (((112 - 55) <= (1044 + 1679)) and (v121 == (1 - 0))) then
				v37 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['heal'];
				v39 = EpicSettings.Toggles['dispel'];
				v121 = 1 + 1;
			end
			if ((v121 == (1 + 5)) or ((3821 - (1414 + 337)) == (2383 - (1642 + 298)))) then
				v83 = (2 - 1) * v82;
				if ((v34.TargetIsValid() and v35) or v13:AffectingCombat() or ((7781 - 5076) == (4133 - 2740))) then
					local v172 = 0 + 0;
					while true do
						if (((0 + 0) == v172) or ((5573 - (357 + 615)) < (43 + 18))) then
							v77 = v13:BuffUp(v30.Dragonrage);
							v78 = (v77 and v13:BuffRemains(v30.Dragonrage)) or (0 - 0);
							break;
						end
					end
				end
				if (not v13:AffectingCombat() or ((1191 + 199) >= (10166 - 5422))) then
					if ((v47 and v30.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v30.BlessingoftheBronzeBuff, true) or v34.GroupBuffMissing(v30.BlessingoftheBronzeBuff))) or ((1602 + 401) > (261 + 3573))) then
						if (v24(v30.BlessingoftheBronze) or ((99 + 57) > (5214 - (384 + 917)))) then
							return "blessing_of_the_bronze precombat";
						end
					end
				end
				v121 = 704 - (128 + 569);
			end
			if (((1738 - (1407 + 136)) == (2082 - (687 + 1200))) and (v121 == (1714 - (556 + 1154)))) then
				v68 = v13:GetEnemiesInRange(87 - 62);
				v69 = v14:GetEnemiesInSplashRange(103 - (9 + 86));
				if (((3526 - (275 + 146)) >= (293 + 1503)) and v36) then
					v70 = v14:GetEnemiesInSplashRangeCount(72 - (29 + 35));
				else
					v70 = 4 - 3;
				end
				v121 = 14 - 9;
			end
		end
	end
	local function v107()
		local v122 = 0 - 0;
		while true do
			if (((2853 + 1526) >= (3143 - (53 + 959))) and (v122 == (409 - (312 + 96)))) then
				EpicSettings.SetupVersion("Devastation Evoker X v 10.2.01 By BoomK");
				break;
			end
			if (((6671 - 2827) >= (2328 - (147 + 138))) and (v122 == (899 - (813 + 86)))) then
				v34.DispellableDebuffs = v34.DispellablePoisonDebuffs;
				v19.Print("Devastation Evoker by Epic BoomK.");
				v122 = 1 + 0;
			end
		end
	end
	v19.SetAPL(2717 - 1250, v106, v107);
end;
return v0["Epix_Evoker_Devastation.lua"]();

