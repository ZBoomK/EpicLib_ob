local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 962 - (531 + 431);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((5623 - (711 + 782)) <= (5664 - 2709))) then
			v6 = v0[v4];
			if (not v6 or ((2433 - (270 + 199)) <= (435 + 905))) then
				return v1(v4, ...);
			end
			v5 = 1820 - (580 + 1239);
		end
		if (((7428 - 4929) == (2390 + 109)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Warlock_Affliction.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Focus;
	local v15 = v12.MouseOver;
	local v16 = v12.Pet;
	local v17 = v12.Target;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Macro;
	local v23 = v20.AoEON;
	local v24 = v20.CDsON;
	local v25 = v20.Cast;
	local v26 = v20.Press;
	local v27 = v20.Commons.Everyone.num;
	local v28 = v20.Commons.Everyone.bool;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32;
	local v33;
	local v34;
	local v35;
	local v36;
	local v37;
	local v38;
	local v39;
	local v40;
	local v41;
	local v42;
	local v43;
	local v44;
	local v45;
	local v46;
	local v47;
	local function v48()
		v33 = EpicSettings.Settings['UseTrinkets'];
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (1167 - (645 + 522));
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1790 - (1010 + 780));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v43 = EpicSettings.Settings['SummonPet'];
		v44 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
		v45 = EpicSettings.Settings['VileTaint'];
		v46 = EpicSettings.Settings['PhantomSingularity'];
		v47 = EpicSettings.Settings['SummonDarkglare'];
	end
	local v49 = v20.Commons.Everyone;
	local v50 = v18.Warlock.Affliction;
	local v51 = v19.Warlock.Affliction;
	local v52 = {v51.ConjuredChillglobe:ID(),v51.DesperateInvokersCodex:ID(),v51.BelorrelostheSuncaller:ID()};
	local v53 = v13:GetEquipment();
	local v54 = (v53[19 - 6] and v19(v53[518 - (351 + 154)])) or v19(1574 - (1281 + 293));
	local v55 = (v53[280 - (28 + 238)] and v19(v53[31 - 17])) or v19(1559 - (1381 + 178));
	local v56 = v22.Warlock.Affliction;
	local v57, v58, v59;
	local v60, v61, v62, v63, v64, v65, v66;
	local v67;
	local v68;
	local v69 = 10422 + 689;
	local v70 = 8960 + 2151;
	v10:RegisterForEvent(function()
		v50.SeedofCorruption:RegisterInFlight();
		v50.ShadowBolt:RegisterInFlight();
		v50.Haunt:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v50.SeedofCorruption:RegisterInFlight();
	v50.ShadowBolt:RegisterInFlight();
	v50.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v103 = 0 + 0;
		while true do
			if ((v103 == (0 - 0)) or ((1169 + 1086) < (492 - (381 + 89)))) then
				v53 = v13:GetEquipment();
				v54 = (v53[12 + 1] and v19(v53[9 + 4])) or v19(0 - 0);
				v103 = 1157 - (1074 + 82);
			end
			if ((v103 == (1 - 0)) or ((2870 - (214 + 1570)) >= (2860 - (990 + 465)))) then
				v55 = (v53[6 + 8] and v19(v53[7 + 7])) or v19(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v104 = 0 - 0;
		while true do
			if ((v104 == (1726 - (1668 + 58))) or ((2995 - (512 + 114)) == (1110 - 684))) then
				v69 = 22970 - 11859;
				v70 = 38662 - 27551;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v71(v105)
		local v106 = 0 + 0;
		local v107;
		while true do
			if ((v106 == (1 + 0)) or ((2675 + 401) > (10736 - 7553))) then
				return v107 or (1994 - (109 + 1885));
			end
			if (((2671 - (1269 + 200)) > (2027 - 969)) and (v106 == (815 - (98 + 717)))) then
				v107 = nil;
				for v138, v139 in pairs(v105) do
					local v140 = 826 - (802 + 24);
					local v141;
					while true do
						if (((6399 - 2688) > (4237 - 882)) and (v140 == (0 + 0))) then
							v141 = v139:DebuffRemains(v50.AgonyDebuff) + ((77 + 22) * v27(v139:DebuffDown(v50.AgonyDebuff)));
							if ((v107 == nil) or (v141 < v107) or ((149 + 757) >= (481 + 1748))) then
								v107 = v141;
							end
							break;
						end
					end
				end
				v106 = 2 - 1;
			end
		end
	end
	local function v72(v108)
		local v109 = 0 - 0;
		local v110;
		local v111;
		while true do
			if (((461 + 827) > (510 + 741)) and (v109 == (2 + 0))) then
				return v110 == v111;
			end
			if ((v109 == (1 + 0)) or ((2108 + 2405) < (4785 - (797 + 636)))) then
				v111 = 0 - 0;
				for v142, v143 in pairs(v108) do
					local v144 = 1619 - (1427 + 192);
					while true do
						if (((0 + 0) == v144) or ((4794 - 2729) >= (2873 + 323))) then
							v110 = v110 + 1 + 0;
							if (v143:DebuffUp(v50.SeedofCorruptionDebuff) or ((4702 - (192 + 134)) <= (2757 - (316 + 960)))) then
								v111 = v111 + 1 + 0;
							end
							break;
						end
					end
				end
				v109 = 2 + 0;
			end
			if ((v109 == (0 + 0)) or ((12967 - 9575) >= (5292 - (83 + 468)))) then
				if (((5131 - (1202 + 604)) >= (10055 - 7901)) and (v50.SeedofCorruption:InFlight() or v13:PrevGCDP(1 - 0, v50.SeedofCorruption))) then
					return false;
				end
				v110 = 0 - 0;
				v109 = 326 - (45 + 280);
			end
		end
	end
	local function v73(v112)
		return (v112:DebuffRemains(v50.AgonyDebuff));
	end
	local function v74(v113)
		return (v113:DebuffRemains(v50.CorruptionDebuff));
	end
	local function v75(v114)
		return (v114:DebuffRemains(v50.SiphonLifeDebuff));
	end
	local function v76(v115)
		return (v115:DebuffRemains(v50.AgonyDebuff) < (v115:DebuffRemains(v50.VileTaintDebuff) + v50.VileTaint:CastTime())) and (v115:DebuffRemains(v50.AgonyDebuff) < (5 + 0));
	end
	local function v77(v116)
		return v116:DebuffRemains(v50.AgonyDebuff) < (5 + 0);
	end
	local function v78(v117)
		return v117:DebuffRemains(v50.CorruptionDebuff) < (2 + 3);
	end
	local function v79(v118)
		return (v118:DebuffRefreshable(v50.SiphonLifeDebuff));
	end
	local function v80(v119)
		return v119:DebuffRemains(v50.AgonyDebuff) < (3 + 2);
	end
	local function v81(v120)
		return (v120:DebuffRefreshable(v50.AgonyDebuff));
	end
	local function v82(v121)
		return v121:DebuffRemains(v50.CorruptionDebuff) < (1 + 4);
	end
	local function v83(v122)
		return (v122:DebuffRefreshable(v50.CorruptionDebuff));
	end
	local function v84(v123)
		return (v123:DebuffStack(v50.ShadowEmbraceDebuff) < (5 - 2)) or (v123:DebuffRemains(v50.ShadowEmbraceDebuff) < (1914 - (340 + 1571)));
	end
	local function v85(v124)
		return v124:DebuffRemains(v50.SiphonLifeDebuff) < (2 + 3);
	end
	local function v86()
		local v125 = 1772 - (1733 + 39);
		while true do
			if ((v125 == (0 - 0)) or ((2329 - (125 + 909)) >= (5181 - (1096 + 852)))) then
				if (((1964 + 2413) > (2344 - 702)) and v50.GrimoireofSacrifice:IsCastable()) then
					if (((4581 + 142) > (1868 - (409 + 103))) and v26(v50.GrimoireofSacrifice)) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (v50.Haunt:IsReady() or ((4372 - (46 + 190)) <= (3528 - (51 + 44)))) then
					if (((1198 + 3047) <= (5948 - (1114 + 203))) and v26(v50.Haunt, not v17:IsSpellInRange(v50.Haunt), true)) then
						return "haunt precombat 6";
					end
				end
				v125 = 727 - (228 + 498);
			end
			if (((927 + 3349) >= (2163 + 1751)) and (v125 == (664 - (174 + 489)))) then
				if (((515 - 317) <= (6270 - (830 + 1075))) and v50.UnstableAffliction:IsReady() and not v50.SoulSwap:IsAvailable()) then
					if (((5306 - (303 + 221)) > (5945 - (231 + 1038))) and v26(v50.UnstableAffliction, not v17:IsSpellInRange(v50.UnstableAffliction), true)) then
						return "unstable_affliction precombat 8";
					end
				end
				if (((4054 + 810) > (3359 - (171 + 991))) and v50.ShadowBolt:IsReady()) then
					if (v26(v50.ShadowBolt, not v17:IsSpellInRange(v50.ShadowBolt), true) or ((15248 - 11548) == (6731 - 4224))) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
		end
	end
	local function v87()
		v60 = v17:DebuffUp(v50.PhantomSingularityDebuff) or not v50.PhantomSingularity:IsAvailable();
		v61 = v17:DebuffUp(v50.VileTaintDebuff) or not v50.VileTaint:IsAvailable();
		v62 = v17:DebuffUp(v50.VileTaintDebuff) or v17:DebuffUp(v50.PhantomSingularityDebuff) or (not v50.VileTaint:IsAvailable() and not v50.PhantomSingularity:IsAvailable());
		v63 = v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable();
		v64 = v60 and v61 and v63;
		v65 = v50.PhantomSingularity:IsAvailable() or v50.VileTaint:IsAvailable() or v50.SoulRot:IsAvailable() or v50.SummonDarkglare:IsAvailable();
		v66 = not v65 or (v10.GuardiansTable.DarkglareDuration > (0 - 0)) or (v64 and (v50.SummonDarkglare:CooldownRemains() > (17 + 3))) or v13:PowerInfusionUp();
	end
	local function v88()
		ShouldReturn = v49.HandleTopTrinket(v52, v31, 140 - 100, nil);
		if (((12906 - 8432) >= (441 - 167)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v49.HandleBottomTrinket(v52, v31, 123 - 83, nil);
		if (ShouldReturn or ((3142 - (111 + 1137)) <= (1564 - (91 + 67)))) then
			return ShouldReturn;
		end
	end
	local function v89()
		local v126 = v88();
		if (((4678 - 3106) >= (382 + 1149)) and v126) then
			return v126;
		end
		if (v51.DesperateInvokersCodex:IsEquippedAndReady() or ((5210 - (423 + 100)) < (32 + 4510))) then
			if (((9112 - 5821) > (869 + 798)) and v26(v56.DesperateInvokersCodex, not v17:IsInRange(816 - (326 + 445)))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (v51.ConjuredChillglobe:IsEquippedAndReady() or ((3809 - 2936) == (4531 - 2497))) then
			if (v26(v56.ConjuredChillglobe) or ((6572 - 3756) < (722 - (530 + 181)))) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v90()
		if (((4580 - (614 + 267)) < (4738 - (19 + 13))) and v66) then
			local v134 = v49.HandleDPSPotion();
			if (((4305 - 1659) >= (2040 - 1164)) and v134) then
				return v134;
			end
			if (((1753 - 1139) <= (827 + 2357)) and v50.Berserking:IsCastable()) then
				if (((5497 - 2371) == (6482 - 3356)) and v26(v50.Berserking)) then
					return "berserking ogcd 4";
				end
			end
			if (v50.BloodFury:IsCastable() or ((3999 - (1293 + 519)) >= (10107 - 5153))) then
				if (v26(v50.BloodFury) or ((10122 - 6245) == (6836 - 3261))) then
					return "blood_fury ogcd 6";
				end
			end
			if (((3048 - 2341) > (1488 - 856)) and v50.Fireblood:IsCastable()) then
				if (v26(v50.Fireblood) or ((290 + 256) >= (548 + 2136))) then
					return "fireblood ogcd 8";
				end
			end
		end
	end
	local function v91()
		if (((3403 - 1938) <= (994 + 3307)) and v31) then
			local v135 = v90();
			if (((567 + 1137) > (891 + 534)) and v135) then
				return v135;
			end
		end
		local v127 = v89();
		if (v127 or ((1783 - (709 + 387)) == (6092 - (673 + 1185)))) then
			return v127;
		end
		v67 = v71(v58);
		if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (8 - 5))) or ((10693 - 7363) < (2350 - 921))) then
			if (((821 + 326) >= (251 + 84)) and v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt))) then
				return "haunt aoe 2";
			end
		end
		if (((4637 - 1202) > (516 + 1581)) and v50.VileTaint:IsReady() and (((v50.SouleatersGluttony:TalentRank() == (3 - 1)) and ((v67 < (1.5 - 0)) or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()))) or ((v50.SouleatersGluttony:TalentRank() == (1881 - (446 + 1434))) and (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime())) or (not v50.SouleatersGluttony:IsAvailable() and ((v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (v50.VileTaint:CooldownRemains() > (1308 - (1040 + 243))))))) then
			if (v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(119 - 79)) or ((5617 - (559 + 1288)) >= (5972 - (609 + 1322)))) then
				return "vile_taint aoe 4";
			end
		end
		if (v50.PhantomSingularity:IsCastable() or ((4245 - (13 + 441)) <= (6019 - 4408))) then
			if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((11991 - 7413) <= (10000 - 7992))) then
				return "phantom_singularity aoe 6";
			end
		end
		if (((42 + 1083) <= (7539 - 5463)) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (2 + 3))) then
			if (v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction)) or ((326 + 417) >= (13054 - 8655))) then
				return "unstable_affliction aoe 8";
			end
		end
		if (((633 + 522) < (3076 - 1403)) and v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (4 + 2)) and v50.SummonDarkglare:CooldownUp()) then
			if (v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife)) or ((1293 + 1031) <= (416 + 162))) then
				return "siphon_life aoe 10";
			end
		end
		if (((3163 + 604) == (3686 + 81)) and v50.SoulRot:IsReady() and v61 and v60) then
			if (((4522 - (153 + 280)) == (11807 - 7718)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
				return "soul_rot aoe 12";
			end
		end
		if (((4003 + 455) >= (661 + 1013)) and v50.SeedofCorruption:IsReady() and (v17:DebuffRemains(v50.CorruptionDebuff) < (3 + 2)) and not (v50.SeedofCorruption:InFlight() or v17:DebuffUp(v50.SeedofCorruptionDebuff))) then
			if (((883 + 89) <= (1028 + 390)) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if ((v50.Agony:IsReady() and (v50.AgonyDebuff:AuraActiveCount() < (11 - 3))) or ((3052 + 1886) < (5429 - (89 + 578)))) then
			if (v49.CastTargetIf(v50.Agony, v57, "min", v73, v76, not v17:IsSpellInRange(v50.Agony)) or ((1789 + 715) > (8864 - 4600))) then
				return "agony aoe 16";
			end
		end
		if (((3202 - (572 + 477)) == (291 + 1862)) and v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) then
			if (v25(v50.SummonDarkglare, v47) or ((305 + 202) >= (310 + 2281))) then
				return "summon_darkglare aoe 18";
			end
		end
		if (((4567 - (84 + 2)) == (7384 - 2903)) and v50.MaleficRapture:IsReady() and (v13:BuffUp(v50.UmbrafireKindlingBuff))) then
			if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(73 + 27)) or ((3170 - (497 + 345)) < (18 + 675))) then
				return "malefic_rapture aoe 20";
			end
		end
		if (((732 + 3596) == (5661 - (605 + 728))) and v50.SeedofCorruption:IsReady() and v50.SowTheSeeds:IsAvailable()) then
			if (((1134 + 454) >= (2960 - 1628)) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if ((v50.MaleficRapture:IsReady() and ((((v50.SummonDarkglare:CooldownRemains() > (1 + 14)) or (v68 > (10 - 7))) and not v50.SowTheSeeds:IsAvailable()) or v13:BuffUp(v50.TormentedCrescendoBuff))) or ((3763 + 411) > (11769 - 7521))) then
			if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(76 + 24)) or ((5075 - (457 + 32)) <= (35 + 47))) then
				return "malefic_rapture aoe 24";
			end
		end
		if (((5265 - (832 + 570)) == (3640 + 223)) and v50.DrainLife:IsReady() and (v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable()) and (v13:BuffStack(v50.InevitableDemiseBuff) > (3 + 7))) then
			if (v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife)) or ((997 - 715) <= (21 + 21))) then
				return "drain_life aoe 26";
			end
		end
		if (((5405 - (588 + 208)) >= (2064 - 1298)) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) then
			if (v49.CastCycle(v50.DrainSoul, v57, v84, not v17:IsSpellInRange(v50.DrainSoul)) or ((2952 - (884 + 916)) == (5208 - 2720))) then
				return "drain_soul aoe 28";
			end
		end
		if (((1985 + 1437) > (4003 - (232 + 421))) and v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
			if (((2766 - (1569 + 320)) > (93 + 283)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
				return "drain_soul aoe 30";
			end
		end
		if ((v50.SummonSoulkeeper:IsReady() and ((v50.SummonSoulkeeper:Count() == (2 + 8)) or ((v50.SummonSoulkeeper:Count() > (9 - 6)) and (v70 < (615 - (316 + 289)))))) or ((8161 - 5043) <= (86 + 1765))) then
			if (v25(v50.SummonSoulkeeper) or ((1618 - (666 + 787)) >= (3917 - (360 + 65)))) then
				return "soul_strike aoe 32";
			end
		end
		if (((3691 + 258) < (5110 - (79 + 175))) and v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (7 - 2))) then
			if (v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife)) or ((3337 + 939) < (9244 - 6228))) then
				return "siphon_life aoe 34";
			end
		end
		if (((9032 - 4342) > (5024 - (503 + 396))) and v50.DrainSoul:IsReady()) then
			if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((231 - (92 + 89)) >= (1737 - 841))) then
				return "drain_soul aoe 36";
			end
		end
		if (v50.ShadowBolt:IsReady() or ((880 + 834) >= (1751 + 1207))) then
			if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((5838 - 4347) < (89 + 555))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v92()
		local v128 = 0 - 0;
		local v129;
		while true do
			if (((615 + 89) < (472 + 515)) and (v128 == (15 - 10))) then
				if (((465 + 3253) > (2906 - 1000)) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) then
					if (v49.CastCycle(v50.DrainSoul, v57, v84, not v17:IsSpellInRange(v50.DrainSoul)) or ((2202 - (485 + 759)) > (8410 - 4775))) then
						return "drain_soul cleave 36";
					end
				end
				if (((4690 - (442 + 747)) <= (5627 - (832 + 303))) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff)) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((4388 - (88 + 858)) < (777 + 1771))) then
						return "drain_soul cleave 38";
					end
				end
				if (((2380 + 495) >= (61 + 1403)) and v50.ShadowBolt:IsReady() and v13:BuffUp(v50.NightfallBuff)) then
					if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((5586 - (766 + 23)) >= (24155 - 19262))) then
						return "shadow_bolt cleave 40";
					end
				end
				if ((v50.MaleficRapture:IsReady() and (v68 > (3 - 0))) or ((1451 - 900) > (7018 - 4950))) then
					if (((3187 - (1036 + 37)) > (670 + 274)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(194 - 94))) then
						return "malefic_rapture cleave 42";
					end
				end
				v128 = 5 + 1;
			end
			if ((v128 == (1482 - (641 + 839))) or ((3175 - (910 + 3)) >= (7892 - 4796))) then
				if ((v50.PhantomSingularity:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (1686 - (1466 + 218))) and (v50.CorruptionDebuff:AuraActiveCount() == (1 + 1)) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (1150 - (556 + 592)))) and (v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (9 + 16)))) or ((3063 - (329 + 479)) >= (4391 - (174 + 680)))) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((13184 - 9347) < (2706 - 1400))) then
						return "phantom_singularity cleave 12";
					end
				end
				if (((2107 + 843) == (3689 - (396 + 343))) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (1 + 4))) then
					if (v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction)) or ((6200 - (29 + 1448)) < (4687 - (135 + 1254)))) then
						return "unstable_affliction cleave 14";
					end
				end
				if (((4279 - 3143) >= (718 - 564)) and v50.SeedofCorruption:IsReady() and not v50.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v50.CorruptionDebuff) < (4 + 1)) and v50.SowTheSeeds:IsAvailable() and v72()) then
					if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or ((1798 - (389 + 1138)) > (5322 - (102 + 472)))) then
						return "seed_of_corruption cleave 16";
					end
				end
				if (((4474 + 266) >= (1748 + 1404)) and v50.Corruption:IsReady()) then
					if (v49.CastTargetIf(v50.Corruption, v57, "min", v74, v78, not v17:IsSpellInRange(v50.Corruption)) or ((2404 + 174) >= (4935 - (320 + 1225)))) then
						return "corruption cleave 18";
					end
				end
				v128 = 5 - 2;
			end
			if (((26 + 15) <= (3125 - (157 + 1307))) and (v128 == (1862 - (821 + 1038)))) then
				if (((1499 - 898) < (390 + 3170)) and v50.SiphonLife:IsReady()) then
					if (((417 - 182) < (256 + 431)) and v49.CastTargetIf(v50.SiphonLife, v57, "min", v75, v79, not v17:IsSpellInRange(v50.SiphonLife))) then
						return "siphon_life cleave 20";
					end
				end
				if (((11274 - 6725) > (2179 - (834 + 192))) and v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (1 + 2))) then
					if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((1200 + 3474) < (101 + 4571))) then
						return "haunt cleave 22";
					end
				end
				if (((5682 - 2014) < (4865 - (300 + 4))) and v50.PhantomSingularity:IsReady() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (7 + 18)))))) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((1191 - 736) == (3967 - (112 + 250)))) then
						return "phantom_singularity cleave 24";
					end
				end
				if (v50.SoulRot:IsReady() or ((1062 + 1601) == (8297 - 4985))) then
					if (((2451 + 1826) <= (2315 + 2160)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return "soul_rot cleave 26";
					end
				end
				v128 = 3 + 1;
			end
			if ((v128 == (0 + 0)) or ((647 + 223) == (2603 - (1001 + 413)))) then
				if (((3462 - 1909) <= (4015 - (244 + 638))) and v31) then
					local v145 = 693 - (627 + 66);
					local v146;
					while true do
						if ((v145 == (0 - 0)) or ((2839 - (512 + 90)) >= (5417 - (1665 + 241)))) then
							v146 = v90();
							if (v146 or ((2041 - (373 + 344)) > (1363 + 1657))) then
								return v146;
							end
							break;
						end
					end
				end
				v129 = v89();
				if (v129 or ((792 + 2200) == (4961 - 3080))) then
					return v129;
				end
				if (((5255 - 2149) > (2625 - (35 + 1064))) and v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) then
					if (((2200 + 823) < (8279 - 4409)) and v25(v50.SummonDarkglare, v47)) then
						return "summon_darkglare cleave 2";
					end
				end
				v128 = 1 + 0;
			end
			if (((1379 - (298 + 938)) > (1333 - (233 + 1026))) and (v128 == (1673 - (636 + 1030)))) then
				if (((10 + 8) < (2063 + 49)) and v50.MaleficRapture:IsReady() and (v68 > (1 + 0))) then
					if (((75 + 1022) <= (1849 - (55 + 166))) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(20 + 80))) then
						return "malefic_rapture cleave 52";
					end
				end
				if (((466 + 4164) == (17682 - 13052)) and v50.DrainSoul:IsReady()) then
					if (((3837 - (36 + 261)) > (4691 - 2008)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				if (((6162 - (34 + 1334)) >= (1259 + 2016)) and v50.ShadowBolt:IsReady()) then
					if (((1154 + 330) == (2767 - (1035 + 248))) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
						return "shadow_bolt cleave 56";
					end
				end
				break;
			end
			if (((1453 - (20 + 1)) < (1853 + 1702)) and (v128 == (325 - (134 + 185)))) then
				if ((v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (1181 - (549 + 584))) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (705 - (314 + 371))) and (v70 < (13 - 9))))) or ((2033 - (478 + 490)) > (1896 + 1682))) then
					if (v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife)) or ((5967 - (786 + 386)) < (4557 - 3150))) then
						return "drain_life cleave 44";
					end
				end
				if (((3232 - (1055 + 324)) < (6153 - (1093 + 247))) and v50.DrainLife:IsReady() and v17:DebuffUp(v50.SoulRotDebuff) and (v13:BuffStack(v50.InevitableDemiseBuff) > (9 + 1))) then
					if (v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife)) or ((297 + 2524) < (9651 - 7220))) then
						return "drain_life cleave 46";
					end
				end
				if (v50.Agony:IsReady() or ((9753 - 6879) < (6205 - 4024))) then
					if (v49.CastCycle(v50.Agony, v57, v81, not v17:IsSpellInRange(v50.Agony)) or ((6757 - 4068) <= (123 + 220))) then
						return "agony cleave 48";
					end
				end
				if (v50.Corruption:IsCastable() or ((7200 - 5331) == (6924 - 4915))) then
					if (v49.CastCycle(v50.Corruption, v57, v83, not v17:IsSpellInRange(v50.Corruption)) or ((2674 + 872) < (5938 - 3616))) then
						return "corruption cleave 50";
					end
				end
				v128 = 695 - (364 + 324);
			end
			if ((v128 == (10 - 6)) or ((4995 - 2913) == (1582 + 3191))) then
				if (((13573 - 10329) > (1689 - 634)) and v50.MaleficRapture:IsReady() and ((v68 > (11 - 7)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (1269 - (1249 + 19))) and (v68 > (3 + 0))))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(389 - 289)) or ((4399 - (686 + 400)) <= (1396 + 382))) then
						return "malefic_rapture cleave 28";
					end
				end
				if ((v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < v13:GCD())) or ((1650 - (73 + 156)) >= (10 + 2094))) then
					if (((2623 - (721 + 90)) <= (37 + 3212)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(324 - 224))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((2093 - (224 + 246)) <= (3170 - 1213)) and v50.MaleficRapture:IsReady() and not v50.DreadTouch:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff)) then
					if (((8123 - 3711) == (801 + 3611)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(3 + 97))) then
						return "malefic_rapture cleave 32";
					end
				end
				if (((1286 + 464) >= (1673 - 831)) and v50.MaleficRapture:IsReady() and (v64 or v62)) then
					if (((14549 - 10177) > (2363 - (203 + 310))) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(2093 - (1238 + 755)))) then
						return "malefic_rapture cleave 34";
					end
				end
				v128 = 1 + 4;
			end
			if (((1766 - (709 + 825)) < (1512 - 691)) and ((1 - 0) == v128)) then
				if (((1382 - (196 + 668)) < (3561 - 2659)) and v50.MaleficRapture:IsReady() and ((v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (3 - 1)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) or (v68 > (837 - (171 + 662))) or v13:BuffUp(v50.UmbrafireKindlingBuff))) then
					if (((3087 - (4 + 89)) > (3007 - 2149)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(37 + 63))) then
						return "malefic_rapture cleave 4";
					end
				end
				if (v50.Agony:IsReady() or ((16492 - 12737) <= (359 + 556))) then
					if (((5432 - (35 + 1451)) > (5196 - (28 + 1425))) and v49.CastTargetIf(v50.Agony, v57, "min", v73, v77, not v17:IsSpellInRange(v50.Agony))) then
						return "agony cleave 6";
					end
				end
				if ((v50.SoulRot:IsReady() and v61 and v60) or ((3328 - (941 + 1052)) >= (3170 + 136))) then
					if (((6358 - (822 + 692)) > (3215 - 962)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				if (((213 + 239) == (749 - (45 + 252))) and v50.VileTaint:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (2 + 0)) and (v50.CorruptionDebuff:AuraActiveCount() == (1 + 1)) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (4 - 2))) and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (445 - (114 + 319)))))) then
					if (v25(v56.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v50.VileTaint)) or ((6542 - 1985) < (2673 - 586))) then
						return "vile_taint cleave 10";
					end
				end
				v128 = 2 + 0;
			end
		end
	end
	local function v93()
		v48();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v57 = v13:GetEnemiesInRange(59 - 19);
		v58 = v17:GetEnemiesInSplashRange(20 - 10);
		if (((5837 - (556 + 1407)) == (5080 - (741 + 465))) and v30) then
			v59 = v17:GetEnemiesInSplashRangeCount(475 - (170 + 295));
		else
			v59 = 1 + 0;
		end
		if (v49.TargetIsValid() or v13:AffectingCombat() or ((1781 + 157) > (12150 - 7215))) then
			local v136 = 0 + 0;
			while true do
				if ((v136 == (1 + 0)) or ((2410 + 1845) < (4653 - (957 + 273)))) then
					if (((389 + 1065) <= (998 + 1493)) and (v70 == (42337 - 31226))) then
						v70 = v10.FightRemains(v58, false);
					end
					break;
				end
				if ((v136 == (0 - 0)) or ((12697 - 8540) <= (13879 - 11076))) then
					v69 = v10.BossFightRemains(nil, true);
					v70 = v69;
					v136 = 1781 - (389 + 1391);
				end
			end
		end
		v68 = v13:SoulShardsP();
		if (((3045 + 1808) >= (311 + 2671)) and v50.SummonPet:IsCastable() and v43 and not v16:IsActive()) then
			if (((9411 - 5277) > (4308 - (783 + 168))) and v26(v50.SummonPet)) then
				return "summon_pet ooc";
			end
		end
		if (v49.TargetIsValid() or ((11468 - 8051) < (2493 + 41))) then
			local v137 = 311 - (309 + 2);
			while true do
				if ((v137 == (9 - 6)) or ((3934 - (1090 + 122)) <= (54 + 110))) then
					if ((v50.Agony:IsCastable() and (v17:DebuffRemains(v50.AgonyDebuff) < (16 - 11))) or ((1648 + 760) < (3227 - (628 + 490)))) then
						if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or ((6 + 27) == (3602 - 2147))) then
							return "agony main 6";
						end
					end
					if ((v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (22 - 17))) or ((1217 - (431 + 343)) >= (8108 - 4093))) then
						if (((9783 - 6401) > (132 + 34)) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
							return "unstable_affliction main 8";
						end
					end
					if ((v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) or ((36 + 244) == (4754 - (556 + 1139)))) then
						if (((1896 - (6 + 9)) > (237 + 1056)) and v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption))) then
							return "corruption main 10";
						end
					end
					v137 = 3 + 1;
				end
				if (((2526 - (28 + 141)) == (913 + 1444)) and (v137 == (8 - 1))) then
					if (((88 + 35) == (1440 - (486 + 831))) and v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
						if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((2747 - 1691) >= (11941 - 8549))) then
							return "drain_soul main 30";
						end
					end
					if ((v50.ShadowBolt:IsReady() and (v13:BuffUp(v50.NightfallBuff))) or ((205 + 876) < (3398 - 2323))) then
						if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((2312 - (668 + 595)) >= (3989 + 443))) then
							return "shadow_bolt main 32";
						end
					end
					if ((v50.Agony:IsCastable() and (v17:DebuffRefreshable(v50.AgonyDebuff))) or ((962 + 3806) <= (2307 - 1461))) then
						if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or ((3648 - (23 + 267)) <= (3364 - (1129 + 815)))) then
							return "agony main 34";
						end
					end
					v137 = 395 - (371 + 16);
				end
				if ((v137 == (1754 - (1326 + 424))) or ((7081 - 3342) <= (10980 - 7975))) then
					if ((v50.SiphonLife:IsCastable() and (v17:DebuffRefreshable(v50.SiphonLifeDebuff))) or ((1777 - (88 + 30)) >= (2905 - (720 + 51)))) then
						if (v25(v50.SiphonLife, nil, nil, not v17:IsSpellInRange(v50.SiphonLife)) or ((7251 - 3991) < (4131 - (421 + 1355)))) then
							return "siphon_life main 12";
						end
					end
					if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (4 - 1))) or ((329 + 340) == (5306 - (286 + 797)))) then
						if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((6185 - 4493) < (973 - 385))) then
							return "haunt main 14";
						end
					end
					if ((v50.DrainSoul:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (442 - (397 + 42))) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (1 + 2)))) or ((5597 - (24 + 776)) < (5624 - 1973))) then
						if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((4962 - (222 + 563)) > (10686 - 5836))) then
							return "drain_soul main 16";
						end
					end
					v137 = 4 + 1;
				end
				if ((v137 == (198 - (23 + 167))) or ((2198 - (690 + 1108)) > (401 + 710))) then
					if (((2517 + 534) > (1853 - (40 + 808))) and v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) then
						if (((609 + 3084) <= (16756 - 12374)) and v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption))) then
							return "corruption main 36";
						end
					end
					if (v50.DrainSoul:IsReady() or ((3137 + 145) > (2169 + 1931))) then
						if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((1964 + 1616) < (3415 - (47 + 524)))) then
							return "drain_soul main 40";
						end
					end
					if (((58 + 31) < (12273 - 7783)) and v50.ShadowBolt:IsReady()) then
						if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((7450 - 2467) < (4123 - 2315))) then
							return "shadow_bolt main 42";
						end
					end
					break;
				end
				if (((5555 - (1165 + 561)) > (112 + 3657)) and (v137 == (6 - 4))) then
					if (((567 + 918) <= (3383 - (341 + 138))) and v33) then
						local v147 = v89();
						if (((1153 + 3116) == (8809 - 4540)) and v147) then
							return v147;
						end
					end
					if (((713 - (89 + 237)) <= (8949 - 6167)) and v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (3 - 1)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) then
						if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(981 - (581 + 300))) or ((3119 - (855 + 365)) <= (2178 - 1261))) then
							return "malefic_rapture main 2";
						end
					end
					if ((v50.SummonDarkglare:IsReady() and v60 and v61 and v63) or ((1408 + 2904) <= (2111 - (1030 + 205)))) then
						if (((2096 + 136) <= (2415 + 181)) and v25(v50.SummonDarkglare, v47)) then
							return "summon_darkglare main 4";
						end
					end
					v137 = 289 - (156 + 130);
				end
				if (((4760 - 2665) < (6212 - 2526)) and (v137 == (10 - 5))) then
					if ((v50.ShadowBolt:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (1 + 2)) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (2 + 1)))) or ((1664 - (10 + 59)) >= (1266 + 3208))) then
						if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((22747 - 18128) < (4045 - (671 + 492)))) then
							return "shadow_bolt main 18";
						end
					end
					if ((v50.PhantomSingularity:IsCastable() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (20 + 5)))))) or ((1509 - (369 + 846)) >= (1279 + 3552))) then
						if (((1732 + 297) <= (5029 - (1036 + 909))) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
							return "phantom_singularity main 20";
						end
					end
					if ((v50.VileTaint:IsReady() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (10 + 2))))) or ((3419 - 1382) == (2623 - (11 + 192)))) then
						if (((2253 + 2205) > (4079 - (135 + 40))) and v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(96 - 56))) then
							return "vile_taint main 22";
						end
					end
					v137 = 4 + 2;
				end
				if (((960 - 524) >= (184 - 61)) and (v137 == (177 - (50 + 126)))) then
					if (((1392 - 892) < (402 + 1414)) and (v59 > (1414 - (1233 + 180))) and (v59 < (972 - (522 + 447)))) then
						local v148 = 1421 - (107 + 1314);
						local v149;
						while true do
							if (((1659 + 1915) == (10890 - 7316)) and (v148 == (0 + 0))) then
								v149 = v92();
								if (((438 - 217) < (1543 - 1153)) and v149) then
									return v149;
								end
								break;
							end
						end
					end
					if ((v59 > (1912 - (716 + 1194))) or ((38 + 2175) <= (153 + 1268))) then
						local v150 = v91();
						if (((3561 - (74 + 429)) < (9375 - 4515)) and v150) then
							return v150;
						end
					end
					if (v24() or ((643 + 653) >= (10177 - 5731))) then
						local v151 = 0 + 0;
						local v152;
						while true do
							if ((v151 == (0 - 0)) or ((3444 - 2051) > (4922 - (279 + 154)))) then
								v152 = v90();
								if (v152 or ((5202 - (454 + 324)) < (22 + 5))) then
									return v152;
								end
								break;
							end
						end
					end
					v137 = 19 - (12 + 5);
				end
				if ((v137 == (0 + 0)) or ((5088 - 3091) > (1410 + 2405))) then
					if (((4558 - (277 + 816)) > (8174 - 6261)) and not v13:AffectingCombat() and v29) then
						local v153 = v86();
						if (((1916 - (1058 + 125)) < (342 + 1477)) and v153) then
							return v153;
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((5370 - (815 + 160)) == (20402 - 15647))) then
						local v154 = v49.Interrupt(v50.SpellLock, 94 - 54, true);
						if (v154 or ((905 + 2888) < (6924 - 4555))) then
							return v154;
						end
						v154 = v49.Interrupt(v50.SpellLock, 1938 - (41 + 1857), true, v15, v56.SpellLockMouseover);
						if (v154 or ((5977 - (1222 + 671)) == (684 - 419))) then
							return v154;
						end
						v154 = v49.Interrupt(v50.AxeToss, 57 - 17, true);
						if (((5540 - (229 + 953)) == (6132 - (1111 + 663))) and v154) then
							return v154;
						end
						v154 = v49.Interrupt(v50.AxeToss, 1619 - (874 + 705), true, v15, v56.AxeTossMouseover);
						if (v154 or ((440 + 2698) < (678 + 315))) then
							return v154;
						end
						v154 = v49.InterruptWithStun(v50.AxeToss, 83 - 43, true);
						if (((94 + 3236) > (3002 - (642 + 37))) and v154) then
							return v154;
						end
						v154 = v49.InterruptWithStun(v50.AxeToss, 10 + 30, true, v15, v56.AxeTossMouseover);
						if (v154 or ((581 + 3045) == (10015 - 6026))) then
							return v154;
						end
					end
					v87();
					v137 = 455 - (233 + 221);
				end
				if ((v137 == (13 - 7)) or ((807 + 109) == (4212 - (718 + 823)))) then
					if (((172 + 100) == (1077 - (266 + 539))) and v50.SoulRot:IsReady() and v61 and (v60 or (v50.SouleatersGluttony:TalentRank() ~= (2 - 1)))) then
						if (((5474 - (636 + 589)) <= (11486 - 6647)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
							return "soul_rot main 24";
						end
					end
					if (((5727 - 2950) < (2536 + 664)) and v50.MaleficRapture:IsReady() and ((v68 > (2 + 2)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (1016 - (657 + 358))) and (v68 > (7 - 4))) or (v50.TormentedCrescendo:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v17:DebuffDown(v50.DreadTouchDebuff)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (4 - 2))) or v64 or (v62 and (v68 > (1188 - (1151 + 36)))) or (v50.TormentedCrescendo:IsAvailable() and v50.Nightfall:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v13:BuffUp(v50.NightfallBuff)))) then
						if (((92 + 3) < (515 + 1442)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(298 - 198))) then
							return "malefic_rapture main 26";
						end
					end
					if (((2658 - (1552 + 280)) < (2551 - (64 + 770))) and v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (33 + 15)) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (45 - 25)) and (v70 < (1 + 3))))) then
						if (((2669 - (157 + 1086)) >= (2211 - 1106)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
							return "drain_life main 28";
						end
					end
					v137 = 30 - 23;
				end
			end
		end
	end
	local function v94()
		v20.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
		v50.AgonyDebuff:RegisterAuraTracking();
		v50.SiphonLifeDebuff:RegisterAuraTracking();
		v50.CorruptionDebuff:RegisterAuraTracking();
	end
	v20.SetAPL(406 - 141, v93, v94);
end;
return v0["Epix_Warlock_Affliction.lua"]();

