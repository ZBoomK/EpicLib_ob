local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2016 + 483) <= (1456 + 1956)) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if (((1169 + 1086) < (4998 - (381 + 89))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((951 + 454) >= (5894 - 2453))) then
				return v1(v4, ...);
			end
			v5 = 1157 - (1074 + 82);
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
	local v67 = (v66[28 - 15] and v19(v66[1797 - (214 + 1570)])) or v19(1455 - (990 + 465));
	local v68 = (v66[6 + 8] and v19(v66[7 + 7])) or v19(0 + 0);
	local v69;
	local v70;
	local v71;
	local v72 = ((v31.EssenceAttunement:IsAvailable()) and (7 - 5)) or (1727 - (1668 + 58));
	local v73 = 628 - (512 + 114);
	local v74, v75, v76;
	local v77;
	local v78, v79;
	local v80 = 10 - 6;
	local v81 = 26 - 13;
	local v82 = v31.BlastFurnace:TalentRank();
	local v83;
	local v84;
	local v85 = false;
	local v86 = 38662 - 27551;
	local v87 = 5169 + 5942;
	local v88;
	local v89;
	local v90 = 0 + 0;
	local v91 = 0 + 0;
	local v92 = 3 - 2;
	local v93 = 1995 - (109 + 1885);
	local v94;
	local function v95()
		local v109;
		if (((3838 - (1269 + 200)) == (4540 - 2171)) and UnitInRaid("player")) then
			v109 = v12.Raid;
		elseif (((4910 - (98 + 717)) >= (4009 - (802 + 24))) and UnitInParty("player")) then
			v109 = v12.Party;
		else
			return false;
		end
		local v110 = nil;
		for v131, v132 in pairs(v109) do
			if ((v132:Exists() and (UnitGroupRolesAssigned(v131) == "HEALER")) or ((6399 - 2688) < (1272 - 264))) then
				v110 = v132;
			end
		end
		return v110;
	end
	v10:RegisterForEvent(function()
		v66 = v13:GetEquipment();
		v67 = (v66[2 + 11] and v19(v66[10 + 3])) or v19(0 + 0);
		v68 = (v66[4 + 10] and v19(v66[38 - 24])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v72 = ((v31.EssenceAttunement:IsAvailable()) and (1 + 1)) or (1 + 0);
		v82 = v31.BlastFurnace:TalentRank();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v111 = false;
		v86 = 9166 + 1945;
		v87 = 8080 + 3031;
		for v133 in pairs(v27.FirestormTracker) do
			v27.FirestormTracker[v133] = nil;
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		local v112 = 0 + 0;
		while true do
			if ((v112 == (1434 - (797 + 636))) or ((5093 - 4044) <= (2525 - (1427 + 192)))) then
				return false;
			end
			if (((1564 + 2949) > (6329 - 3603)) and (v112 == (0 + 0))) then
				if ((v31.Firestorm:TimeSinceLastCast() > (6 + 6)) or ((1807 - (192 + 134)) >= (3934 - (316 + 960)))) then
					return false;
				end
				if (v27.FirestormTracker[v14:GUID()] or ((1792 + 1428) == (1053 + 311))) then
					if ((v27.FirestormTracker[v14:GUID()] > (GetTime() - (2.5 + 0))) or ((4029 - 2975) > (3943 - (83 + 468)))) then
						return true;
					end
				end
				v112 = 1807 - (1202 + 604);
			end
		end
	end
	local function v97()
		local v113 = 0 - 0;
		while true do
			if ((v113 == (1 - 0)) or ((1871 - 1195) >= (1967 - (45 + 280)))) then
				v84 = (1 + 0) * v83;
				if (((3614 + 522) > (876 + 1521)) and v31.Firestorm:IsCastable()) then
					if (v25(v31.Firestorm, not v14:IsInRange(14 + 11), v89) or ((763 + 3571) == (7860 - 3615))) then
						return "firestorm precombat";
					end
				end
				v113 = 1913 - (340 + 1571);
			end
			if ((v113 == (1 + 1)) or ((6048 - (1733 + 39)) <= (8328 - 5297))) then
				if ((v31.LivingFlame:IsCastable() and not v31.Firestorm:IsAvailable()) or ((5816 - (125 + 909)) <= (3147 - (1096 + 852)))) then
					if (v25(v31.LivingFlame, not v14:IsInRange(12 + 13), v89) or ((6946 - 2082) < (1845 + 57))) then
						return "living_flame precombat";
					end
				end
				if (((5351 - (409 + 103)) >= (3936 - (46 + 190))) and v31.AzureStrike:IsCastable()) then
					if (v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike)) or ((1170 - (51 + 44)) > (541 + 1377))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
			if (((1713 - (1114 + 203)) <= (4530 - (228 + 498))) and (v113 == (0 + 0))) then
				if ((v64 == "Auto") or ((2304 + 1865) == (2850 - (174 + 489)))) then
					if (((3662 - 2256) == (3311 - (830 + 1075))) and v31.SourceofMagic:IsCastable() and v16:IsInRange(549 - (303 + 221)) and (v94 == v16:GUID()) and (v16:BuffRemains(v31.SourceofMagicBuff) < (1569 - (231 + 1038)))) then
						if (((1276 + 255) < (5433 - (171 + 991))) and v21(v33.SourceofMagicFocus)) then
							return "source_of_magic precombat";
						end
					end
				end
				if (((2616 - 1981) == (1705 - 1070)) and (v64 == "Selected")) then
					local v146 = v35.NamedUnit(62 - 37, v65);
					if (((2700 + 673) <= (12465 - 8909)) and v146 and v31.SourceofMagic:IsCastable() and (v146:BuffRemains(v31.SourceofMagicBuff) < (865 - 565))) then
						if (v21(v33.SourceofMagicName) or ((5304 - 2013) < (10139 - 6859))) then
							return "source_of_magic precombat";
						end
					end
				end
				v113 = 1249 - (111 + 1137);
			end
		end
	end
	local function v98()
		if (((4544 - (91 + 67)) >= (2598 - 1725)) and v31.ObsidianScales:IsCastable() and v13:BuffDown(v31.ObsidianScales) and (v13:HealthPercentage() < v60) and v59) then
			if (((230 + 691) <= (1625 - (423 + 100))) and v25(v31.ObsidianScales)) then
				return "obsidian_scales defensives";
			end
		end
		if (((34 + 4672) >= (2665 - 1702)) and v32.Healthstone:IsReady() and v51 and (v13:HealthPercentage() <= v52)) then
			if (v25(v33.Healthstone, nil, nil, true) or ((501 + 459) <= (1647 - (326 + 445)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v31.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v58) and v57) or ((9015 - 6949) == (2075 - 1143))) then
			if (((11262 - 6437) < (5554 - (530 + 181))) and v21(v31.RenewingBlaze, nil, nil)) then
				return "RenewingBlaze main 6";
			end
		end
		if ((v45 and (v13:HealthPercentage() <= v47)) or ((4758 - (614 + 267)) >= (4569 - (19 + 13)))) then
			if ((v46 == "Refreshing Healing Potion") or ((7022 - 2707) < (4021 - 2295))) then
				if (v32.RefreshingHealingPotion:IsReady() or ((10509 - 6830) < (163 + 462))) then
					if (v25(v33.RefreshingHealingPotion, nil, nil, true) or ((8133 - 3508) < (1310 - 678))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v99()
		if ((v78 and ((v71 >= (1815 - (1293 + 519))) or v13:BuffDown(v31.SpoilsofNeltharusVers) or ((v79 + ((7 - 3) * v28(v31.EternitySurge:CooldownRemains() <= ((v88 * (4 - 2)) + v28(v31.FireBreath:CooldownRemains() <= (v88 * (3 - 1))))))) <= (77 - 59)))) or (v87 <= (47 - 27)) or ((44 + 39) > (364 + 1416))) then
			ShouldReturn = v35.HandleTopTrinket(v34, v38, 92 - 52, nil);
			if (((127 + 419) <= (358 + 719)) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v35.HandleBottomTrinket(v34, v38, 25 + 15, nil);
			if (ShouldReturn or ((2092 - (709 + 387)) > (6159 - (673 + 1185)))) then
				return ShouldReturn;
			end
		end
	end
	local function v100()
		if (((11803 - 7733) > (2205 - 1518)) and v31.EternitySurge:CooldownDown()) then
			return nil;
		end
		if ((v71 <= ((1 - 0) + v28(v31.EternitysSpan:IsAvailable()))) or ((v79 < ((1.75 + 0) * v83)) and (v79 >= ((1 + 0) * v83))) or (v78 and ((v71 == (6 - 1)) or (not v31.EternitysSpan:IsAvailable() and (v71 >= (2 + 4))) or (v31.EternitysSpan:IsAvailable() and (v71 >= (15 - 7))))) or ((1287 - 631) >= (5210 - (446 + 1434)))) then
			v90 = 1284 - (1040 + 243);
		elseif ((v71 <= ((5 - 3) + ((1849 - (559 + 1288)) * v28(v31.EternitysSpan:IsAvailable())))) or ((v79 < ((1933.5 - (609 + 1322)) * v83)) and (v79 >= ((455.75 - (13 + 441)) * v83))) or ((9311 - 6819) <= (877 - 542))) then
			v90 = 9 - 7;
		elseif (((161 + 4161) >= (9304 - 6742)) and ((v71 <= (2 + 1 + ((2 + 1) * v28(v31.EternitysSpan:IsAvailable())))) or not v31.FontofMagic:IsAvailable() or ((v79 <= ((8.25 - 5) * v83)) and (v79 >= ((2.5 + 0) * v83))))) then
			v90 = 4 - 1;
		else
			v90 = 3 + 1;
		end
		v92 = v90;
		if (v25(v31.EternitySurge, not v14:IsInRange(17 + 13), true) or ((2614 + 1023) >= (3166 + 604))) then
			return "eternity_surge empower " .. v90;
		end
	end
	local function v101()
		if (v31.FireBreath:CooldownDown() or ((2328 + 51) > (5011 - (153 + 280)))) then
			return nil;
		end
		local v114 = v14:DebuffRemains(v31.FireBreath);
		if ((v78 and (v71 <= (5 - 3))) or ((v71 == (1 + 0)) and not v31.EverburningFlame:IsAvailable()) or ((v79 < ((1.75 + 0) * v83)) and (v79 >= ((1 + 0) * v83))) or ((439 + 44) > (539 + 204))) then
			v91 = 1 - 0;
		elseif (((1517 + 937) > (1245 - (89 + 578))) and ((not v96() and v31.EverburningFlame:IsAvailable() and (v71 <= (3 + 0))) or ((v71 == (3 - 1)) and not v31.EverburningFlame:IsAvailable()) or ((v79 < ((1051.5 - (572 + 477)) * v83)) and (v79 >= ((1.75 + 0) * v83))))) then
			v91 = 2 + 0;
		elseif (((112 + 818) < (4544 - (84 + 2))) and (not v31.FontofMagic:IsAvailable() or (v96() and v31.EverburningFlame:IsAvailable() and (v71 <= (4 - 1))) or ((v79 <= ((3.25 + 0) * v83)) and (v79 >= ((844.5 - (497 + 345)) * v83))))) then
			v91 = 1 + 2;
		else
			v91 = 1 + 3;
		end
		v93 = v91;
		if (((1995 - (605 + 728)) <= (694 + 278)) and v23(v31.FireBreath, false, "1", not v14:IsInRange(66 - 36), nil)) then
			return "fire_breath empower " .. v91 .. " main 12";
		end
	end
	local function v102()
		local v115 = 0 + 0;
		while true do
			if (((16156 - 11786) == (3940 + 430)) and ((0 - 0) == v115)) then
				if ((v31.Dragonrage:IsCastable() and v38 and ((v14:TimeToDie() >= (25 + 7)) or (v87 < (519 - (457 + 32))))) or ((2021 + 2741) <= (2263 - (832 + 570)))) then
					if (v25(v31.Dragonrage) or ((1331 + 81) == (1112 + 3152))) then
						return "dragonrage aoe 2";
					end
				end
				if ((v31.TipTheScales:IsCastable() and v38 and v78 and ((v71 <= ((10 - 7) + ((2 + 1) * v28(v31.EternitysSpan:IsAvailable())))) or v31.FireBreath:CooldownDown())) or ((3964 - (588 + 208)) < (5802 - 3649))) then
					if (v25(v31.TipTheScales) or ((6776 - (884 + 916)) < (2788 - 1456))) then
						return "tip_the_scales aoe 4";
					end
				end
				if (((2684 + 1944) == (5281 - (232 + 421))) and (not v31.Dragonrage:IsAvailable() or (v77 > v80) or not v31.Animosity:IsAvailable()) and ((((v13:BuffRemains(v31.PowerSwellBuff) < v84) or (not v31.Volatility:IsAvailable() and (v71 == (1892 - (1569 + 320))))) and (v13:BuffRemains(v31.BlazingShardsBuff) < v84)) or v78) and ((v14:TimeToDie() >= (2 + 6)) or (v87 < (6 + 24)))) then
					local v147 = v101();
					if (v147 or ((181 - 127) == (1000 - (316 + 289)))) then
						return v147;
					end
				end
				if (((214 - 132) == (4 + 78)) and (v78 or not v31.Dragonrage:IsAvailable() or ((v31.Dragonrage:CooldownRemains() > v80) and ((v13:BuffRemains(v31.PowerSwellBuff) < v84) or (not v31.Volatility:IsAvailable() and (v71 == (1456 - (666 + 787))))) and (v13:BuffRemains(v31.BlazingShardsBuff) < v84) and ((v14:TimeToDie() >= (433 - (360 + 65))) or (v87 < (29 + 1)))))) then
					local v148 = 254 - (79 + 175);
					local v149;
					while true do
						if ((v148 == (0 - 0)) or ((454 + 127) < (864 - 582))) then
							v149 = v100();
							if (v149 or ((8875 - 4266) < (3394 - (503 + 396)))) then
								return v149;
							end
							break;
						end
					end
				end
				v115 = 182 - (92 + 89);
			end
			if (((2234 - 1082) == (591 + 561)) and (v115 == (1 + 0))) then
				if (((7424 - 5528) <= (468 + 2954)) and v31.DeepBreath:IsCastable() and v38 and not v78 and (v13:EssenceDeficit() > (6 - 3)) and v35.TargetIsMouseover()) then
					if (v25(v33.DeepBreathCursor, not v14:IsInRange(27 + 3)) or ((473 + 517) > (4933 - 3313))) then
						return "deep_breath aoe 6";
					end
				end
				if ((v31.ShatteringStar:IsCastable() and ((v13:BuffStack(v31.EssenceBurstBuff) < v72) or not v31.ArcaneVigor:IsAvailable())) or ((110 + 767) > (7159 - 2464))) then
					if (((3935 - (485 + 759)) >= (4282 - 2431)) and v25(v31.ShatteringStar, not v14:IsSpellInRange(v31.ShatteringStar))) then
						return "shattering_star aoe 8";
					end
				end
				if (v31.Firestorm:IsCastable() or ((4174 - (442 + 747)) >= (5991 - (832 + 303)))) then
					if (((5222 - (88 + 858)) >= (365 + 830)) and v25(v31.Firestorm, not v14:IsInRange(21 + 4), v89)) then
						return "firestorm aoe 10";
					end
				end
				if (((134 + 3098) <= (5479 - (766 + 23))) and v31.Pyre:IsReady() and ((v71 >= (24 - 19)) or ((v71 >= (5 - 1)) and ((v13:BuffDown(v31.EssenceBurstBuff) and v13:BuffDown(v31.IridescenceBlueBuff)) or not v31.EternitysSpan:IsAvailable())) or ((v71 >= (10 - 6)) and v31.Volatility:IsAvailable()) or ((v71 >= (10 - 7)) and v31.Volatility:IsAvailable() and v31.ChargedBlast:IsAvailable() and v13:BuffDown(v31.EssenceBurstBuff) and v13:BuffDown(v31.IridescenceBlueBuff)) or ((v71 >= (1076 - (1036 + 37))) and v31.Volatility:IsAvailable() and not v31.ChargedBlast:IsAvailable() and (v13:BuffUp(v31.IridescenceRedBuff) or v13:BuffDown(v31.EssenceBurstBuff))) or (v13:BuffStack(v31.ChargedBlastBuff) >= (11 + 4)))) then
					if (v25(v31.Pyre, not v14:IsSpellInRange(v31.Pyre)) or ((1744 - 848) >= (2475 + 671))) then
						return "pyre aoe 14";
					end
				end
				v115 = 1482 - (641 + 839);
			end
			if (((3974 - (910 + 3)) >= (7540 - 4582)) and ((1686 - (1466 + 218)) == v115)) then
				if (((1465 + 1722) >= (1792 - (556 + 592))) and v31.LivingFlame:IsCastable() and v13:BuffUp(v31.BurnoutBuff) and v13:BuffUp(v31.LeapingFlamesBuff) and v13:BuffDown(v31.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - (1 + 0)))) then
					if (((1452 - (329 + 479)) <= (1558 - (174 + 680))) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
						return "living_flame aoe 14";
					end
				end
				if (((3291 - 2333) > (1962 - 1015)) and v31.Disintegrate:IsReady()) then
					if (((3208 + 1284) >= (3393 - (396 + 343))) and v25(v31.Disintegrate, not v14:IsSpellInRange(v31.Disintegrate), v89)) then
						return "disintegrate aoe 20";
					end
				end
				if (((305 + 3137) >= (2980 - (29 + 1448))) and v31.LivingFlame:IsCastable() and v31.Snapfire:IsAvailable() and v13:BuffUp(v31.BurnoutBuff)) then
					if (v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89) or ((4559 - (135 + 1254)) <= (5515 - 4051))) then
						return "living_flame aoe 22";
					end
				end
				if (v31.AzureStrike:IsCastable() or ((22397 - 17600) == (2925 + 1463))) then
					if (((2078 - (389 + 1138)) <= (1255 - (102 + 472))) and v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike))) then
						return "azure_strike aoe 24";
					end
				end
				break;
			end
		end
	end
	local function v103()
		if (((3093 + 184) > (226 + 181)) and v31.Firestorm:IsCastable() and (v13:BuffUp(v31.SnapfireBuff))) then
			if (((4378 + 317) >= (2960 - (320 + 1225))) and v25(v31.Firestorm, not v14:IsInRange(44 - 19), v89)) then
				return "firestorm st 4";
			end
		end
		if ((v31.Dragonrage:IsCastable() and v38 and (((v31.FireBreath:CooldownRemains() < v88) and (v31.EternitySurge:CooldownRemains() < ((2 + 0) * v88))) or (v87 < (1494 - (157 + 1307))))) or ((5071 - (821 + 1038)) <= (2355 - 1411))) then
			if (v25(v31.Dragonrage) or ((339 + 2757) <= (3193 - 1395))) then
				return "dragonrage st 6";
			end
		end
		if (((1316 + 2221) == (8766 - 5229)) and v31.TipTheScales:IsCastable() and v38 and ((v78 and v31.EternitySurge:CooldownUp() and v31.FireBreath:CooldownDown() and not v31.EverburningFlame:IsAvailable()) or (v31.EverburningFlame:IsAvailable() and v31.FireBreath:CooldownUp()))) then
			if (((4863 - (834 + 192)) >= (100 + 1470)) and v25(v31.TipTheScales)) then
				return "tip_the_scales st 8";
			end
		end
		if (((not v31.Dragonrage:IsAvailable() or (v77 > v81) or not v31.Animosity:IsAvailable()) and ((v13:BuffRemains(v31.BlazingShardsBuff) < v84) or v78) and ((v14:TimeToDie() >= (3 + 5)) or (v87 < (1 + 29)))) or ((4570 - 1620) == (4116 - (300 + 4)))) then
			local v137 = v101();
			if (((1262 + 3461) >= (6067 - 3749)) and v137) then
				return v137;
			end
		end
		if ((v31.Disintegrate:IsReady() and (v79 > (381 - (112 + 250))) and (v31.FireBreath:CooldownRemains() > (12 + 16)) and v31.EyeofInfinity:IsAvailable() and v13:HasTier(75 - 45, 2 + 0)) or ((1049 + 978) > (2133 + 719))) then
			if (v21(v31.Disintegrate, nil, nil, not v14:IsSpellInRange(v31.Disintegrate)) or ((564 + 572) > (3207 + 1110))) then
				return "disintegrate st 9";
			end
		end
		if (((6162 - (1001 + 413)) == (10587 - 5839)) and v31.ShatteringStar:IsCastable() and ((v13:BuffStack(v31.EssenceBurstBuff) < v72) or not v31.ArcaneVigor:IsAvailable())) then
			if (((4618 - (244 + 638)) <= (5433 - (627 + 66))) and v25(v31.ShatteringStar, not v14:IsSpellInRange(v31.ShatteringStar))) then
				return "shattering_star st 10";
			end
		end
		if (((not v31.Dragonrage:IsAvailable() or (v77 > v81) or not v31.Animosity:IsAvailable()) and ((v13:BuffRemains(v31.BlazingShardsBuff) < v84) or v78) and ((v14:TimeToDie() >= (23 - 15)) or (v87 < (632 - (512 + 90))))) or ((5296 - (1665 + 241)) <= (3777 - (373 + 344)))) then
			local v138 = 0 + 0;
			local v139;
			while true do
				if ((v138 == (0 + 0)) or ((2634 - 1635) > (4556 - 1863))) then
					v139 = v100();
					if (((1562 - (35 + 1064)) < (438 + 163)) and v139) then
						return v139;
					end
					break;
				end
			end
		end
		if ((v31.Animosity:IsAvailable() and v78 and (v79 < (v88 + (v84 * v28(v13:BuffDown(v31.TipTheScales))))) and ((v79 - v31.FireBreath:CooldownRemains()) >= (v84 * v28(v13:BuffDown(v31.TipTheScales))))) or ((4670 - 2487) < (3 + 684))) then
			if (((5785 - (298 + 938)) == (5808 - (233 + 1026))) and v25(v31.Pool)) then
				return "Wait for FB st 12";
			end
		end
		if (((6338 - (636 + 1030)) == (2389 + 2283)) and v31.Animosity:IsAvailable() and v78 and (v79 < (v88 + v84)) and ((v79 - v31.EternitySurge:CooldownRemains()) > (v84 * v28(v13:BuffDown(v31.TipTheScales))))) then
			if (v25(v31.Pool) or ((3583 + 85) < (118 + 277))) then
				return "Wait for ES st 14";
			end
		end
		if ((v31.LivingFlame:IsCastable() and v78 and (v79 < ((v72 - v13:BuffStack(v31.EssenceBurstBuff)) * v88)) and v13:BuffUp(v31.BurnoutBuff)) or ((282 + 3884) == (676 - (55 + 166)))) then
			if (v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89) or ((863 + 3586) == (268 + 2395))) then
				return "living_flame st 16";
			end
		end
		if ((v31.AzureStrike:IsCastable() and v78 and (v79 < ((v72 - v13:BuffStack(v31.EssenceBurstBuff)) * v88))) or ((16334 - 12057) < (3286 - (36 + 261)))) then
			if (v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike)) or ((1521 - 651) >= (5517 - (34 + 1334)))) then
				return "azure_strike st 18";
			end
		end
		if (((851 + 1361) < (2474 + 709)) and v31.LivingFlame:IsCastable() and v13:BuffUp(v31.BurnoutBuff) and ((v13:BuffUp(v31.LeapingFlamesBuff) and v13:BuffDown(v31.EssenceBurstBuff)) or (v13:BuffDown(v31.LeapingFlamesBuff) and (v13:BuffStack(v31.EssenceBurstBuff) < v72))) and (v13:Essence() < (v13:EssenceMax() - (1284 - (1035 + 248))))) then
			if (((4667 - (20 + 1)) > (1559 + 1433)) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
				return "living_flame st 20";
			end
		end
		if (((1753 - (134 + 185)) < (4239 - (549 + 584))) and v31.Pyre:IsReady() and v96() and v31.RagingInferno:IsAvailable() and (v13:BuffStack(v31.ChargedBlastBuff) == (705 - (314 + 371))) and (v71 >= (6 - 4))) then
			if (((1754 - (478 + 490)) < (1602 + 1421)) and v25(v31.Pyre, not v14:IsSpellInRange(v31.Pyre))) then
				return "pyre st 22";
			end
		end
		if (v31.Disintegrate:IsReady() or ((3614 - (786 + 386)) < (239 - 165))) then
			if (((5914 - (1055 + 324)) == (5875 - (1093 + 247))) and v25(v31.Disintegrate, not v14:IsSpellInRange(v31.Disintegrate), v89)) then
				return "disintegrate st 24";
			end
		end
		if ((v31.Firestorm:IsCastable() and not v78 and v14:DebuffDown(v31.ShatteringStar)) or ((2674 + 335) <= (222 + 1883))) then
			if (((7265 - 5435) < (12451 - 8782)) and v25(v31.Firestorm, not v14:IsInRange(71 - 46), v89)) then
				return "firestorm st 26";
			end
		end
		if ((v31.DeepBreath:IsCastable() and v38 and not v78 and (v71 >= (4 - 2)) and v35.TargetIsMouseover()) or ((509 + 921) >= (13914 - 10302))) then
			if (((9247 - 6564) >= (1855 + 605)) and v25(v33.DeepBreathCursor, not v14:IsInRange(76 - 46))) then
				return "deep_breath st 28";
			end
		end
		if ((v31.DeepBreath:IsCastable() and v38 and not v78 and v31.ImminentDestruction:IsAvailable() and v14:DebuffDown(v31.ShatteringStar) and v35.TargetIsMouseover()) or ((2492 - (364 + 324)) >= (8977 - 5702))) then
			if (v25(v33.DeepBreathCursor, not v14:IsInRange(71 - 41)) or ((470 + 947) > (15184 - 11555))) then
				return "deep_breath st 30";
			end
		end
		if (((7679 - 2884) > (1220 - 818)) and v31.LivingFlame:IsCastable()) then
			if (((6081 - (1249 + 19)) > (3218 + 347)) and v25(v31.LivingFlame, not v14:IsSpellInRange(v31.LivingFlame), v89)) then
				return "living_flame st 32";
			end
		end
		if (((15227 - 11315) == (4998 - (686 + 400))) and v31.AzureStrike:IsCastable()) then
			if (((2214 + 607) <= (5053 - (73 + 156))) and v25(v31.AzureStrike, not v14:IsSpellInRange(v31.AzureStrike))) then
				return "azure_strike st 34";
			end
		end
	end
	local function v104()
		local v116 = 0 + 0;
		while true do
			if (((2549 - (721 + 90)) <= (25 + 2170)) and (v116 == (3 - 2))) then
				if (((511 - (224 + 246)) <= (4888 - 1870)) and (v42 == "Player Only")) then
					if (((3949 - 1804) <= (745 + 3359)) and v31.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v44)) then
						if (((64 + 2625) < (3559 + 1286)) and v21(v33.EmeraldBlossomPlayer, nil)) then
							return "emerald_blossom main 42";
						end
					end
				end
				if ((v42 == "Everyone") or ((4615 - 2293) > (8725 - 6103))) then
					if ((v31.EmeraldBlossom:IsReady() and (v16:HealthPercentage() < v44)) or ((5047 - (203 + 310)) == (4075 - (1238 + 755)))) then
						if (v21(v33.EmeraldBlossomFocus, nil) or ((110 + 1461) > (3401 - (709 + 825)))) then
							return "emerald_blossom main 42";
						end
					end
				end
				break;
			end
			if ((v116 == (0 - 0)) or ((3865 - 1211) >= (3860 - (196 + 668)))) then
				if (((15706 - 11728) > (4357 - 2253)) and (v41 == "Player Only")) then
					if (((3828 - (171 + 662)) > (1634 - (4 + 89))) and v31.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v43)) then
						if (((11387 - 8138) > (348 + 605)) and v21(v33.VerdantEmbracePlayer, nil)) then
							return "verdant_embrace main 40";
						end
					end
				end
				if ((v41 == "Everyone") or (v41 == "Not Tank") or ((14375 - 11102) > (1794 + 2779))) then
					if ((v31.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v43)) or ((4637 - (35 + 1451)) < (2737 - (28 + 1425)))) then
						if (v21(v33.VerdantEmbraceFocus, nil) or ((3843 - (941 + 1052)) == (1467 + 62))) then
							return "verdant_embrace main 40";
						end
					end
				end
				v116 = 1515 - (822 + 692);
			end
		end
	end
	local function v105()
		if (((1171 - 350) < (1000 + 1123)) and (not v16 or not v16:Exists() or not v16:IsInRange(327 - (45 + 252)) or not (v35.UnitHasDispellableDebuffByPlayer(v16) or v35.DispellableFriendlyUnit(25 + 0)))) then
			return;
		end
		if (((311 + 591) < (5658 - 3333)) and v31.Expunge:IsReady() and (v35.UnitHasPoisonDebuff(v16))) then
			if (((1291 - (114 + 319)) <= (4252 - 1290)) and v25(v33.ExpungeFocus)) then
				return "Expunge dispel";
			end
		end
		if ((v31.OppressingRoar:IsReady() and v56 and v35.UnitHasEnrageBuff(v14)) or ((5056 - 1110) < (822 + 466))) then
			if (v25(v31.OppressingRoar) or ((4829 - 1587) == (1187 - 620))) then
				return "Oppressing Roar dispel";
			end
		end
	end
	local function v106()
		v41 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v42 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
		v43 = EpicSettings.Settings['VerdantEmbraceHP'] or (1963 - (556 + 1407));
		v44 = EpicSettings.Settings['EmeraldBlossomHP'] or (1206 - (741 + 465));
		v45 = EpicSettings.Settings['UseHealingPotion'];
		v46 = EpicSettings.Settings['HealingPotionName'] or "";
		v47 = EpicSettings.Settings['HealingPotionHP'] or (465 - (170 + 295));
		v48 = EpicSettings.Settings['UseBlessingOfTheBronze'];
		v49 = EpicSettings.Settings['DispelDebuffs'];
		v50 = EpicSettings.Settings['DispelBuffs'];
		v51 = EpicSettings.Settings['UseHealthstone'];
		v52 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v53 = EpicSettings.Settings['InterruptWithStun'];
		v54 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v55 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v56 = EpicSettings.Settings['UseOppressingRoar'];
		v57 = EpicSettings.Settings['UseRenewingBlaze'];
		v58 = EpicSettings.Settings['RenewingBlazeHP'] or (0 - 0);
		v59 = EpicSettings.Settings['UseObsidianScales'];
		v60 = EpicSettings.Settings['ObsidianScalesHP'] or (0 + 0);
		v61 = EpicSettings.Settings['UseHover'];
		v62 = EpicSettings.Settings['HoverTime'] or (0 + 0);
		v63 = EpicSettings.Settings['LandslideUsage'] or "";
		v64 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
		v65 = EpicSettings.Settings['SourceOfMagicName'] or "";
	end
	local function v107()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (1234 - (957 + 273))) or ((227 + 620) >= (506 + 757))) then
				v69 = v13:GetEnemiesInRange(95 - 70);
				v70 = v14:GetEnemiesInSplashRange(21 - 13);
				if (v37 or ((6881 - 4628) == (9165 - 7314))) then
					v71 = v14:GetEnemiesInSplashRangeCount(1788 - (389 + 1391));
				else
					v71 = 1 + 0;
				end
				v128 = 1 + 4;
			end
			if ((v128 == (13 - 7)) or ((3038 - (783 + 168)) > (7960 - 5588))) then
				v84 = (1 + 0) * v83;
				if ((v35.TargetIsValid() and v36) or v13:AffectingCombat() or ((4756 - (309 + 2)) < (12740 - 8591))) then
					v78 = v13:BuffUp(v31.Dragonrage);
					v79 = (v78 and v13:BuffRemains(v31.Dragonrage)) or (1212 - (1090 + 122));
				end
				if (not v13:AffectingCombat() or ((590 + 1228) == (285 - 200))) then
					if (((432 + 198) < (3245 - (628 + 490))) and v48 and v31.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v31.BlessingoftheBronzeBuff, true) or v35.GroupBuffMissing(v31.BlessingoftheBronzeBuff))) then
						if (v25(v31.BlessingoftheBronze) or ((348 + 1590) == (6224 - 3710))) then
							return "blessing_of_the_bronze precombat";
						end
					end
				end
				v128 = 31 - 24;
			end
			if (((5029 - (431 + 343)) >= (111 - 56)) and (v128 == (23 - 15))) then
				if (((2370 + 629) > (148 + 1008)) and v13:AffectingCombat()) then
					local v150 = v98();
					if (((4045 - (556 + 1139)) > (1170 - (6 + 9))) and v150) then
						return v150;
					end
				end
				if (((738 + 3291) <= (2487 + 2366)) and (v13:AffectingCombat() or v36)) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((685 - (28 + 141)) > (1331 + 2103))) then
						local v162 = 0 - 0;
						local v163;
						while true do
							if (((2866 + 1180) >= (4350 - (486 + 831))) and (v162 == (0 - 0))) then
								v163 = v35.Interrupt(v31.Quell, 35 - 25, true);
								if (v163 or ((514 + 2205) <= (4575 - 3128))) then
									return v163;
								end
								v162 = 1264 - (668 + 595);
							end
							if (((2 + 0) == v162) or ((834 + 3300) < (10706 - 6780))) then
								v163 = v35.Interrupt(v31.Quell, 300 - (23 + 267), true, v15, v33.QuellMouseover);
								if (v163 or ((2108 - (1129 + 815)) >= (3172 - (371 + 16)))) then
									return v163;
								end
								break;
							end
							if (((1751 - (1326 + 424)) == v162) or ((994 - 469) == (7706 - 5597))) then
								v163 = v35.InterruptWithStun(v31.TailSwipe, 126 - (88 + 30));
								if (((804 - (720 + 51)) == (73 - 40)) and v163) then
									return v163;
								end
								v162 = 1778 - (421 + 1355);
							end
						end
					end
					v77 = v30(v31.Dragonrage:CooldownRemains(), v31.EternitySurge:CooldownRemains() - ((2 - 0) * v88), v31.FireBreath:CooldownRemains() - v88);
					if (((1501 + 1553) <= (5098 - (286 + 797))) and v31.Unravel:IsReady() and v14:EnemyAbsorb()) then
						if (((6839 - 4968) < (5601 - 2219)) and v25(v31.Unravel, not v14:IsSpellInRange(v31.Unravel))) then
							return "unravel main 4";
						end
					end
					if (((1732 - (397 + 42)) <= (677 + 1489)) and (v50 or v49)) then
						local v164 = 800 - (24 + 776);
						local v165;
						while true do
							if ((v164 == (0 - 0)) or ((3364 - (222 + 563)) < (270 - 147))) then
								v165 = v105();
								if (v165 or ((610 + 236) >= (2558 - (23 + 167)))) then
									return v165;
								end
								break;
							end
						end
					end
					if ((v39 and v13:AffectingCombat()) or ((5810 - (690 + 1108)) <= (1212 + 2146))) then
						local v166 = 0 + 0;
						local v167;
						while true do
							if (((2342 - (40 + 808)) <= (495 + 2510)) and (v166 == (0 - 0))) then
								v167 = v104();
								if (v167 or ((2974 + 137) == (1129 + 1005))) then
									return v167;
								end
								break;
							end
						end
					end
					if (((1292 + 1063) == (2926 - (47 + 524))) and v61 and v13:AffectingCombat()) then
						if (((GetTime() - LastStationaryTime) > v62) or ((382 + 206) <= (1180 - 748))) then
							if (((7172 - 2375) >= (8883 - 4988)) and v31.Hover:IsReady()) then
								if (((5303 - (1165 + 561)) == (107 + 3470)) and v25(v31.Hover)) then
									return "hover main 2";
								end
							end
						end
					end
					if (((11750 - 7956) > (1410 + 2283)) and (v64 == "Auto")) then
						if ((v31.SourceofMagic:IsCastable() and v16:IsInRange(504 - (341 + 138)) and (v94 == v16:GUID()) and (v16:BuffRemains(v31.SourceofMagicBuff) < (81 + 219))) or ((2631 - 1356) == (4426 - (89 + 237)))) then
							if (v21(v33.SourceofMagicFocus) or ((5118 - 3527) >= (7537 - 3957))) then
								return "source_of_magic precombat";
							end
						end
					end
					if (((1864 - (581 + 300)) <= (3028 - (855 + 365))) and (v64 == "Selected")) then
						local v168 = 0 - 0;
						local v169;
						while true do
							if ((v168 == (0 + 0)) or ((3385 - (1030 + 205)) <= (1124 + 73))) then
								v169 = v35.NamedUnit(24 + 1, v65);
								if (((4055 - (156 + 130)) >= (2665 - 1492)) and v169 and v31.SourceofMagic:IsCastable() and (v169:BuffRemains(v31.SourceofMagicBuff) < (505 - 205))) then
									if (((3041 - 1556) == (392 + 1093)) and v21(v33.SourceofMagicName)) then
										return "source_of_magic precombat";
									end
								end
								break;
							end
						end
					end
					local v151 = v35.HandleDPSPotion(v13:BuffUp(v31.IridescenceBlueBuff));
					if (v151 or ((1934 + 1381) <= (2851 - (10 + 59)))) then
						return v151;
					end
					if (v38 or ((248 + 628) >= (14597 - 11633))) then
						local v170 = 1163 - (671 + 492);
						local v171;
						while true do
							if (((0 + 0) == v170) or ((3447 - (369 + 846)) > (662 + 1835))) then
								v171 = v99();
								if (v171 or ((1801 + 309) <= (2277 - (1036 + 909)))) then
									return v171;
								end
								break;
							end
						end
					end
					if (((2931 + 755) > (5324 - 2152)) and (v71 >= (206 - (11 + 192)))) then
						local v172 = v102();
						if (v172 or ((2261 + 2213) < (995 - (135 + 40)))) then
							return v172;
						end
						if (((10367 - 6088) >= (1738 + 1144)) and v25(v31.Pool)) then
							return "Pool for Aoe()";
						end
					end
					local v152 = v103();
					if (v152 or ((4469 - 2440) >= (5277 - 1756))) then
						return v152;
					end
				end
				if (v25(v31.Pool) or ((2213 - (50 + 126)) >= (12925 - 8283))) then
					return "Pool for ST()";
				end
				break;
			end
			if (((381 + 1339) < (5871 - (1233 + 180))) and (v128 == (969 - (522 + 447)))) then
				v106();
				v36 = EpicSettings.Toggles['ooc'];
				v37 = EpicSettings.Toggles['aoe'];
				v128 = 1422 - (107 + 1314);
			end
			if ((v128 == (3 + 2)) or ((1328 - 892) > (1284 + 1737))) then
				if (((1415 - 702) <= (3351 - 2504)) and (v35.TargetIsValid() or v13:AffectingCombat())) then
					v86 = v10.BossFightRemains(nil, true);
					v87 = v86;
					if (((4064 - (716 + 1194)) <= (69 + 3962)) and (v87 == (1191 + 9920))) then
						v87 = v10.FightRemains(v69, false);
					end
				end
				v88 = v13:GCD() + (503.25 - (74 + 429));
				v83 = v13:SpellHaste();
				v128 = 11 - 5;
			end
			if (((2288 + 2327) == (10564 - 5949)) and (v128 == (5 + 2))) then
				if ((v39 and v36 and not v13:AffectingCombat()) or ((11684 - 7894) == (1236 - 736))) then
					local v153 = v104();
					if (((522 - (279 + 154)) < (999 - (454 + 324))) and v153) then
						return v153;
					end
				end
				if (((1617 + 437) >= (1438 - (12 + 5))) and v61 and (v36 or v13:AffectingCombat())) then
					if (((374 + 318) < (7791 - 4733)) and ((GetTime() - LastStationaryTime) > v62)) then
						if ((v31.Hover:IsReady() and v13:BuffDown(v31.Hover)) or ((1203 + 2051) == (2748 - (277 + 816)))) then
							if (v25(v31.Hover) or ((5537 - 4241) == (6093 - (1058 + 125)))) then
								return "hover main 2";
							end
						end
					end
				end
				if (((632 + 2736) == (4343 - (815 + 160))) and not v13:AffectingCombat() and v36 and not v13:IsCasting()) then
					local v154 = v97();
					if (((11340 - 8697) < (9056 - 5241)) and v154) then
						return v154;
					end
				end
				v128 = 2 + 6;
			end
			if (((5591 - 3678) > (2391 - (41 + 1857))) and (v128 == (1895 - (1222 + 671)))) then
				if (((12289 - 7534) > (4927 - 1499)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (((2563 - (229 + 953)) <= (4143 - (1111 + 663))) and v49 and v31.Expunge:IsReady() and (v35.UnitHasDispellableDebuffByPlayer(v16) or v35.DispellableFriendlyUnit(1604 - (874 + 705)))) then
					local v155 = v49;
					local v156 = v35.FocusUnit(v155, nil, nil, nil, 3 + 17, v31.LivingFlame);
					if (v156 or ((3305 + 1538) == (8488 - 4404))) then
						return v156;
					end
				else
					local v157 = 0 + 0;
					local v158;
					while true do
						if (((5348 - (642 + 37)) > (83 + 280)) and (v157 == (0 + 0))) then
							v158 = v95();
							if ((v158 and (v16:BuffRemains(v31.SourceofMagicBuff) < (753 - 453))) or ((2331 - (233 + 221)) >= (7256 - 4118))) then
								local v175 = 0 + 0;
								while true do
									if (((6283 - (718 + 823)) >= (2282 + 1344)) and (v175 == (805 - (266 + 539)))) then
										v94 = v158:GUID();
										if (((v64 == "Auto") and (v158:BuffRemains(v31.SourceofMagicBuff) < (849 - 549)) and v31.SourceofMagic:IsCastable()) or ((5765 - (636 + 589)) == (2174 - 1258))) then
											local v180 = 0 - 0;
											while true do
												if ((v180 == (0 + 0)) or ((420 + 736) > (5360 - (657 + 358)))) then
													ShouldReturn = v35.FocusSpecifiedUnit(v158, 66 - 41);
													if (((5096 - 2859) < (5436 - (1151 + 36))) and ShouldReturn) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										break;
									end
								end
							elseif (v39 or ((2591 + 92) < (7 + 16))) then
								if (((2081 - 1384) <= (2658 - (1552 + 280))) and (((v41 == "Everyone") and v31.VerdantEmbrace:IsReady()) or ((v42 == "Everyone") and v31.EmeraldBlossom:IsReady()))) then
									local v179 = 834 - (64 + 770);
									while true do
										if (((751 + 354) <= (2669 - 1493)) and (v179 == (0 + 0))) then
											ShouldReturn = v35.FocusUnit(false, nil, nil, nil, 1263 - (157 + 1086), v31.LivingFlame);
											if (((6762 - 3383) <= (16695 - 12883)) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								elseif (((v41 == "Not Tank") and v31.VerdantEmbrace:IsReady()) or ((1208 - 420) >= (2204 - 588))) then
									local v181 = 819 - (599 + 220);
									local v182;
									local v183;
									while true do
										if (((3691 - 1837) <= (5310 - (1813 + 118))) and (v181 == (1 + 0))) then
											if (((5766 - (841 + 376)) == (6373 - 1824)) and (v182:HealthPercentage() < v183:HealthPercentage())) then
												ShouldReturn = v35.FocusUnit(false, nil, nil, "HEALER", 5 + 15, v31.LivingFlame);
												if (ShouldReturn or ((8248 - 5226) >= (3883 - (464 + 395)))) then
													return ShouldReturn;
												end
											end
											if (((12370 - 7550) > (1056 + 1142)) and (v183:HealthPercentage() < v182:HealthPercentage())) then
												ShouldReturn = v35.FocusUnit(false, nil, nil, "DAMAGER", 857 - (467 + 370), v31.LivingFlame);
												if (ShouldReturn or ((2192 - 1131) >= (3591 + 1300))) then
													return ShouldReturn;
												end
											end
											break;
										end
										if (((4675 - 3311) <= (698 + 3775)) and (v181 == (0 - 0))) then
											v182 = v35.GetFocusUnit(false, nil, "HEALER") or v13;
											v183 = v35.GetFocusUnit(false, nil, "DAMAGER") or v13;
											v181 = 521 - (150 + 370);
										end
									end
								end
							end
							break;
						end
					end
				end
				if (not v13:IsMoving() or ((4877 - (74 + 1208)) <= (7 - 4))) then
					LastStationaryTime = GetTime();
				end
				v128 = 14 - 11;
			end
			if ((v128 == (1 + 0)) or ((5062 - (14 + 376)) == (6680 - 2828))) then
				v38 = EpicSettings.Toggles['cds'];
				v39 = EpicSettings.Toggles['heal'];
				v40 = EpicSettings.Toggles['dispel'];
				v128 = 2 + 0;
			end
			if (((1370 + 189) == (1487 + 72)) and (v128 == (8 - 5))) then
				if (v13:IsChanneling(v31.FireBreath) or ((1319 + 433) <= (866 - (23 + 55)))) then
					local v159 = GetTime() - v13:CastStart();
					if ((v159 >= v13:EmpowerCastTime(v93)) or ((9258 - 5351) == (119 + 58))) then
						v10.EpicSettingsS = v31.FireBreath.ReturnID;
						return "Stopping Fire Breath";
					end
				end
				if (((3117 + 353) > (860 - 305)) and v13:IsChanneling(v31.EternitySurge)) then
					local v160 = 0 + 0;
					local v161;
					while true do
						if ((v160 == (901 - (652 + 249))) or ((2601 - 1629) == (2513 - (708 + 1160)))) then
							v161 = GetTime() - v13:CastStart();
							if (((8637 - 5455) >= (3856 - 1741)) and (v161 >= v13:EmpowerCastTime(v92))) then
								local v176 = 27 - (10 + 17);
								while true do
									if (((875 + 3018) < (6161 - (1400 + 332))) and (v176 == (0 - 0))) then
										v10.EpicSettingsS = v31.EternitySurge.ReturnID;
										return "Stopping EternitySurge";
									end
								end
							end
							break;
						end
					end
				end
				v89 = v13:BuffRemains(v31.HoverBuff) < (1910 - (242 + 1666));
				v128 = 2 + 2;
			end
		end
	end
	local function v108()
		v35.DispellableDebuffs = v35.DispellablePoisonDebuffs;
		v20.Print("Devastation Evoker by Epic BoomK.");
		EpicSettings.SetupVersion("Devastation Evoker X v 10.2.01 By BoomK");
	end
	v20.SetAPL(538 + 929, v107, v108);
end;
return v0["Epix_Evoker_Devastation.lua"]();

