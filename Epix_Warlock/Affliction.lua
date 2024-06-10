local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((3264 - (765 + 135)) > (7592 - 4086))) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Warlock_Affliction.lua"] = function(...)
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
	local v20 = v10.Bind;
	local v21 = v10.Macro;
	local v22 = v10.AoEON;
	local v23 = v10.CDsON;
	local v24 = v10.Cast;
	local v25 = v10.Press;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
	local v28 = math.max;
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
		local v108 = 0 + 0;
		while true do
			if (((3 + 0) == v108) or ((2950 - (20 + 27)) > (5241 - (50 + 237)))) then
				v45 = EpicSettings.Settings['VileTaint'];
				v46 = EpicSettings.Settings['PhantomSingularity'];
				v47 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if (((1760 + 1324) > (64 - 24)) and (v108 == (1 + 1))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (1493 - (711 + 782));
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
				v108 = 472 - (270 + 199);
			end
			if (((1107 + 2305) > (2638 - (580 + 1239))) and (v108 == (2 - 1))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v108 = 4 - 2;
			end
			if (((1965 + 1197) <= (4608 - (645 + 522))) and (v108 == (1790 - (1010 + 780)))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v108 = 4 - 3;
			end
		end
	end
	local v49 = v10.Commons.Everyone;
	local v50 = v10.Commons.Warlock;
	local v51 = v18.Warlock.Affliction;
	local v52 = v19.Warlock.Affliction;
	local v53 = {};
	local v54 = v13:GetEquipment();
	local v55 = v21.Warlock.Affliction;
	local v56, v57, v58;
	local v59, v60, v61, v62, v63, v64, v65;
	local v66, v67, v68, v69;
	local v70 = ((v51.DrainSoul:IsAvailable()) and v51.DrainSoul) or v51.ShadowBolt;
	local v71 = 0 - 0;
	local v72 = 12947 - (1045 + 791);
	local v73 = 28124 - 17013;
	local v74;
	v10:RegisterForEvent(function()
		local v109 = 0 - 0;
		while true do
			if (((5211 - (351 + 154)) > (6003 - (1281 + 293))) and (v109 == (267 - (28 + 238)))) then
				v51.Haunt:RegisterInFlight();
				v70 = ((v51.DrainSoul:IsAvailable()) and v51.DrainSoul) or v51.ShadowBolt;
				break;
			end
			if (((6377 - 3523) < (5654 - (1381 + 178))) and (v109 == (0 + 0))) then
				v51.SeedofCorruption:RegisterInFlight();
				v51.ShadowBolt:RegisterInFlight();
				v109 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v51.SeedofCorruption:RegisterInFlight();
	v51.ShadowBolt:RegisterInFlight();
	v51.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v110 = 0 + 0;
		while true do
			if ((v110 == (0 - 0)) or ((549 + 509) >= (1672 - (381 + 89)))) then
				v72 = 9854 + 1257;
				v73 = 7515 + 3596;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v75(v111, v112)
		if (((6356 - 2645) > (4511 - (1074 + 82))) and (not v111 or not v112)) then
			return 0 - 0;
		end
		local v113;
		for v148, v149 in pairs(v111) do
			local v150 = v149:DebuffRemains(v112) + ((1883 - (214 + 1570)) * v26(v149:DebuffDown(v112)));
			if ((v113 == nil) or (v150 < v113) or ((2361 - (990 + 465)) >= (919 + 1310))) then
				v113 = v150;
			end
		end
		return v113 or (0 + 0);
	end
	local function v76(v114)
		local v115 = 0 + 0;
		local v116;
		local v117;
		while true do
			if (((5068 - 3780) > (2977 - (1668 + 58))) and (v115 == (628 - (512 + 114)))) then
				for v164, v165 in pairs(v114) do
					local v166 = 0 - 0;
					while true do
						if (((0 - 0) == v166) or ((15703 - 11190) < (1560 + 1792))) then
							v116 = v116 + 1 + 0;
							if (v165:DebuffUp(v51.SeedofCorruptionDebuff) or ((1796 + 269) >= (10779 - 7583))) then
								v117 = v117 + (1995 - (109 + 1885));
							end
							break;
						end
					end
				end
				return v116 == v117;
			end
			if ((v115 == (1470 - (1269 + 200))) or ((8387 - 4011) <= (2296 - (98 + 717)))) then
				v116 = 826 - (802 + 24);
				v117 = 0 - 0;
				v115 = 2 - 0;
			end
			if ((v115 == (0 + 0)) or ((2607 + 785) >= (779 + 3962))) then
				if (((718 + 2607) >= (5992 - 3838)) and (not v114 or (#v114 == (0 - 0)))) then
					return false;
				end
				if (v51.SeedofCorruption:InFlight() or v13:PrevGCDP(1 + 0, v51.SeedofCorruption) or ((528 + 767) >= (2667 + 566))) then
					return false;
				end
				v115 = 1 + 0;
			end
		end
	end
	local function v77()
		return v50.GuardiansTable.DarkglareDuration > (0 + 0);
	end
	local function v78()
		return v50.GuardiansTable.DarkglareDuration;
	end
	local function v79(v118)
		return (v118:DebuffRemains(v51.AgonyDebuff));
	end
	local function v80(v119)
		return (v119:DebuffRemains(v51.CorruptionDebuff));
	end
	local function v81(v120)
		return (v120:DebuffRemains(v51.ShadowEmbraceDebuff));
	end
	local function v82(v121)
		return (v121:DebuffRemains(v51.SiphonLifeDebuff));
	end
	local function v83(v122)
		return (v122:DebuffRemains(v51.SoulRotDebuff));
	end
	local function v84(v123)
		return (v123:DebuffRemains(v51.AgonyDebuff) < (v123:DebuffRemains(v51.VileTaintDebuff) + v51.VileTaint:CastTime())) and (v123:DebuffRemains(v51.AgonyDebuff) < (1438 - (797 + 636)));
	end
	local function v85(v124)
		return v124:DebuffRemains(v51.AgonyDebuff) < (24 - 19);
	end
	local function v86(v125)
		return ((v125:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v125:DebuffRemains(v51.AgonyDebuff) < (1624 - (1427 + 192)));
	end
	local function v87(v126)
		return ((v126:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v126:DebuffRemains(v51.AgonyDebuff) < (2 + 3)) and (v73 > (11 - 6));
	end
	local function v88(v127)
		return v127:DebuffRemains(v51.CorruptionDebuff) < (5 + 0);
	end
	local function v89(v128)
		return (v51.ShadowEmbrace:IsAvailable() and ((v128:DebuffStack(v51.ShadowEmbraceDebuff) < (2 + 1)) or (v128:DebuffRemains(v51.ShadowEmbraceDebuff) < (329 - (192 + 134))))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v90(v129)
		return (v129:DebuffRefreshable(v51.SiphonLifeDebuff));
	end
	local function v91(v130)
		return v130:DebuffRemains(v51.AgonyDebuff) < (1281 - (316 + 960));
	end
	local function v92(v131)
		return (v131:DebuffRefreshable(v51.AgonyDebuff));
	end
	local function v93(v132)
		return v132:DebuffRemains(v51.CorruptionDebuff) < (3 + 2);
	end
	local function v94(v133)
		return (v133:DebuffRefreshable(v51.CorruptionDebuff));
	end
	local function v95(v134)
		return (v134:DebuffStack(v51.ShadowEmbraceDebuff) < (3 + 0)) or (v134:DebuffRemains(v51.ShadowEmbraceDebuff) < (3 + 0));
	end
	local function v96(v135)
		return (v51.ShadowEmbrace:IsAvailable() and ((v135:DebuffStack(v51.ShadowEmbraceDebuff) < (11 - 8)) or (v135:DebuffRemains(v51.ShadowEmbraceDebuff) < (554 - (83 + 468))))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v97(v136)
		return v136:DebuffRemains(v51.SiphonLifeDebuff) < (1811 - (1202 + 604));
	end
	local function v98(v137)
		return (v137:DebuffRemains(v51.SiphonLifeDebuff) < (23 - 18)) and v137:DebuffUp(v51.AgonyDebuff);
	end
	local function v99()
		if (((7284 - 2907) > (4546 - 2904)) and v51.GrimoireofSacrifice:IsCastable()) then
			if (((5048 - (45 + 280)) > (1309 + 47)) and v25(v51.GrimoireofSacrifice)) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (v51.Haunt:IsReady() or ((3614 + 522) <= (1254 + 2179))) then
			if (((2350 + 1895) <= (815 + 3816)) and v25(v51.Haunt, not v17:IsSpellInRange(v51.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if (((7918 - 3642) >= (5825 - (340 + 1571))) and v51.UnstableAffliction:IsReady() and not v51.SoulSwap:IsAvailable()) then
			if (((79 + 119) <= (6137 - (1733 + 39))) and v25(v51.UnstableAffliction, not v17:IsSpellInRange(v51.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (((13140 - 8358) > (5710 - (125 + 909))) and v51.ShadowBolt:IsReady()) then
			if (((6812 - (1096 + 852)) > (986 + 1211)) and v25(v51.ShadowBolt, not v17:IsSpellInRange(v51.ShadowBolt), true)) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v100()
		v59 = v17:DebuffUp(v51.PhantomSingularityDebuff) or not v51.PhantomSingularity:IsAvailable();
		v60 = v17:DebuffUp(v51.VileTaintDebuff) or not v51.VileTaint:IsAvailable();
		v61 = v17:DebuffUp(v51.VileTaintDebuff) or v17:DebuffUp(v51.PhantomSingularityDebuff) or (not v51.VileTaint:IsAvailable() and not v51.PhantomSingularity:IsAvailable());
		v62 = v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable();
		v63 = v59 and v60 and v62;
		v64 = v51.PhantomSingularity:IsAvailable() or v51.VileTaint:IsAvailable() or v51.SoulRot:IsAvailable() or v51.SummonDarkglare:IsAvailable();
		v65 = not v64 or (v63 and ((v51.SummonDarkglare:CooldownRemains() > (28 - 8)) or not v51.SummonDarkglare:IsAvailable()));
	end
	local function v101()
		local v138 = v49.HandleTopTrinket(v53, v31, 39 + 1, nil);
		if (v138 or ((4212 - (409 + 103)) == (2743 - (46 + 190)))) then
			return v138;
		end
		local v138 = v49.HandleBottomTrinket(v53, v31, 135 - (51 + 44), nil);
		if (((1262 + 3212) >= (1591 - (1114 + 203))) and v138) then
			return v138;
		end
	end
	local function v102()
		local v139 = 726 - (228 + 498);
		local v140;
		while true do
			if ((v139 == (0 + 0)) or ((1047 + 847) <= (2069 - (174 + 489)))) then
				v140 = v101();
				if (((4095 - 2523) >= (3436 - (830 + 1075))) and v140) then
					return v140;
				end
				v139 = 525 - (303 + 221);
			end
			if ((v139 == (1270 - (231 + 1038))) or ((3906 + 781) < (5704 - (171 + 991)))) then
				if (((13562 - 10271) > (4476 - 2809)) and v52.DesperateInvokersCodex:IsEquippedAndReady()) then
					if (v25(v55.DesperateInvokersCodex, not v17:IsInRange(112 - 67)) or ((699 + 174) == (7129 - 5095))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (v52.ConjuredChillglobe:IsEquippedAndReady() or ((8123 - 5307) < (17 - 6))) then
					if (((11434 - 7735) < (5954 - (111 + 1137))) and v25(v55.ConjuredChillglobe)) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
		end
	end
	local function v103()
		if (((2804 - (91 + 67)) >= (2607 - 1731)) and v65) then
			local v151 = 0 + 0;
			local v152;
			while true do
				if (((1137 - (423 + 100)) <= (23 + 3161)) and (v151 == (0 - 0))) then
					v152 = v49.HandleDPSPotion();
					if (((1630 + 1496) == (3897 - (326 + 445))) and v152) then
						return v152;
					end
					v151 = 4 - 3;
				end
				if ((v151 == (4 - 2)) or ((5104 - 2917) >= (5665 - (530 + 181)))) then
					if (v51.Fireblood:IsCastable() or ((4758 - (614 + 267)) == (3607 - (19 + 13)))) then
						if (((1150 - 443) > (1472 - 840)) and v25(v51.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if ((v151 == (2 - 1)) or ((142 + 404) >= (4720 - 2036))) then
					if (((3038 - 1573) <= (6113 - (1293 + 519))) and v51.Berserking:IsCastable()) then
						if (((3476 - 1772) > (3720 - 2295)) and v25(v51.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v51.BloodFury:IsCastable() or ((1313 - 626) == (18257 - 14023))) then
						if (v25(v51.BloodFury) or ((7844 - 4514) < (757 + 672))) then
							return "blood_fury ogcd 6";
						end
					end
					v151 = 1 + 1;
				end
			end
		end
	end
	local function v104()
		local v141 = 0 - 0;
		local v142;
		while true do
			if (((266 + 881) >= (112 + 223)) and (v141 == (2 + 0))) then
				if (((4531 - (709 + 387)) > (3955 - (673 + 1185))) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (17 - 11)) and v51.SummonDarkglare:CooldownUp() and (v10.CombatTime() < (64 - 44)) and (((v74 * (2 - 0)) + v51.SoulRot:CastTime()) < v69)) then
					if (v49.CastCycle(v51.SiphonLife, v56, v98, not v17:IsSpellInRange(v51.SiphonLife)) or ((2697 + 1073) >= (3020 + 1021))) then
						return "siphon_life aoe 10";
					end
				end
				if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 - 0))) and v17:DebuffUp(v51.AgonyDebuff)) or ((932 + 2859) <= (3211 - 1600))) then
					if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((8986 - 4408) <= (3888 - (446 + 1434)))) then
						return "soul_rot aoe 12";
					end
				end
				if (((2408 - (1040 + 243)) <= (6196 - 4120)) and v51.SeedofCorruption:IsReady() and (v17:DebuffRemains(v51.CorruptionDebuff) < (1852 - (559 + 1288))) and not (v51.SeedofCorruption:InFlight() or v17:DebuffUp(v51.SeedofCorruptionDebuff))) then
					if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((2674 - (609 + 1322)) >= (4853 - (13 + 441)))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if (((4315 - 3160) < (4382 - 2709)) and v51.Corruption:IsReady() and not v51.SeedofCorruption:IsAvailable()) then
					if (v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption)) or ((11574 - 9250) <= (22 + 556))) then
						return "corruption aoe 15";
					end
				end
				v141 = 10 - 7;
			end
			if (((1338 + 2429) == (1651 + 2116)) and (v141 == (11 - 7))) then
				if (((2238 + 1851) == (7520 - 3431)) and v51.MaleficRapture:IsReady() and ((((v51.SummonDarkglare:CooldownRemains() > (10 + 5)) or (v71 > (2 + 1))) and not v51.SowTheSeeds:IsAvailable()) or v13:BuffUp(v51.TormentedCrescendoBuff))) then
					if (((3204 + 1254) >= (1406 + 268)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(98 + 2))) then
						return "malefic_rapture aoe 24";
					end
				end
				if (((1405 - (153 + 280)) <= (4094 - 2676)) and v51.DrainLife:IsReady() and (v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable()) and (v13:BuffStack(v51.InevitableDemiseBuff) > (9 + 1))) then
					if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((1950 + 2988) < (2493 + 2269))) then
						return "drain_life aoe 26";
					end
				end
				if ((v51.DrainSoul:IsReady() and v13:BuffUp(v51.NightfallBuff) and v51.ShadowEmbrace:IsAvailable()) or ((2273 + 231) > (3090 + 1174))) then
					if (((3278 - 1125) == (1331 + 822)) and v49.CastCycle(v51.DrainSoul, v56, v95, not v17:IsSpellInRange(v51.DrainSoul))) then
						return "drain_soul aoe 28";
					end
				end
				if ((v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((1174 - (89 + 578)) >= (1851 + 740))) then
					if (((9315 - 4834) == (5530 - (572 + 477))) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
						return "drain_soul aoe 30";
					end
				end
				v141 = 1 + 4;
			end
			if ((v141 == (2 + 1)) or ((278 + 2050) < (779 - (84 + 2)))) then
				if (((7132 - 2804) == (3118 + 1210)) and v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
					if (((2430 - (497 + 345)) >= (35 + 1297)) and v24(v51.SummonDarkglare, v47)) then
						return "summon_darkglare aoe 18";
					end
				end
				if ((v51.DrainLife:IsReady() and (v13:BuffStack(v51.InevitableDemiseBuff) > (6 + 24)) and v13:BuffUp(v51.SoulRot) and (v13:BuffRemains(v51.SoulRot) <= v74) and (v58 > (1336 - (605 + 728)))) or ((2979 + 1195) > (9444 - 5196))) then
					if (v49.CastTargetIf(v51.DrainLife, v56, "min", v83, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((211 + 4375) <= (303 - 221))) then
						return "drain_life aoe 19";
					end
				end
				if (((3483 + 380) == (10702 - 6839)) and v51.MaleficRapture:IsReady() and v13:BuffUp(v51.UmbrafireKindlingBuff) and ((((v58 < (5 + 1)) or (v10.CombatTime() < (519 - (457 + 32)))) and v77()) or not v51.DoomBlossom:IsAvailable())) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(43 + 57)) or ((1684 - (832 + 570)) <= (40 + 2))) then
						return "malefic_rapture aoe 20";
					end
				end
				if (((1202 + 3407) >= (2710 - 1944)) and v51.SeedofCorruption:IsReady() and v51.SowTheSeeds:IsAvailable()) then
					if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((555 + 597) == (3284 - (588 + 208)))) then
						return "seed_of_corruption aoe 22";
					end
				end
				v141 = 10 - 6;
			end
			if (((5222 - (884 + 916)) > (7013 - 3663)) and (v141 == (1 + 0))) then
				if (((1530 - (232 + 421)) > (2265 - (1569 + 320))) and v51.VileTaint:IsReady() and (((v51.SouleatersGluttony:TalentRank() == (1 + 1)) and ((v66 < (1.5 + 0)) or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()))) or ((v51.SouleatersGluttony:TalentRank() == (3 - 2)) and (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and ((v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (v51.VileTaint:CooldownRemains() > (630 - (316 + 289))))))) then
					if (v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(104 - 64)) or ((144 + 2974) <= (3304 - (666 + 787)))) then
						return "vile_taint aoe 4";
					end
				end
				if ((v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:IsAvailable() and (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (450 - (360 + 65)))))) and v17:DebuffUp(v51.AgonyDebuff)) or ((155 + 10) >= (3746 - (79 + 175)))) then
					if (((6226 - 2277) < (3790 + 1066)) and v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity))) then
						return "phantom_singularity aoe 6";
					end
				end
				if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (15 - 10))) or ((8234 - 3958) < (3915 - (503 + 396)))) then
					if (((4871 - (92 + 89)) > (8001 - 3876)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
						return "unstable_affliction aoe 8";
					end
				end
				if ((v51.Agony:IsReady() and (v51.AgonyDebuff:AuraActiveCount() < (5 + 3)) and (((v74 * (2 + 0)) + v51.SoulRot:CastTime()) < v69)) or ((195 - 145) >= (123 + 773))) then
					if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v86, not v17:IsSpellInRange(v51.Agony)) or ((3907 - 2193) >= (2581 + 377))) then
						return "agony aoe 9";
					end
				end
				v141 = 1 + 1;
			end
			if ((v141 == (15 - 10)) or ((187 + 1304) < (981 - 337))) then
				if (((1948 - (485 + 759)) < (2283 - 1296)) and v51.SummonSoulkeeper:IsReady() and ((v51.SummonSoulkeeper:Count() == (1199 - (442 + 747))) or ((v51.SummonSoulkeeper:Count() > (1138 - (832 + 303))) and (v73 < (956 - (88 + 858)))))) then
					if (((1134 + 2584) > (1578 + 328)) and v24(v51.SummonSoulkeeper)) then
						return "soul_strike aoe 32";
					end
				end
				if ((v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (1 + 4)) and ((v58 < (797 - (766 + 23))) or not v51.DoomBlossom:IsAvailable())) or ((4729 - 3771) > (4970 - 1335))) then
					if (((9223 - 5722) <= (15245 - 10753)) and v49.CastCycle(v51.SiphonLife, v56, v97, not v17:IsSpellInRange(v51.SiphonLife))) then
						return "siphon_life aoe 34";
					end
				end
				if (v51.DrainSoul:IsReady() or ((4515 - (1036 + 37)) < (1807 + 741))) then
					if (((5598 - 2723) >= (1152 + 312)) and v49.CastCycle(v51.DrainSoul, v56, v96, not v17:IsSpellInRange(v51.DrainSoul))) then
						return "drain_soul aoe 36";
					end
				end
				if (v51.ShadowBolt:IsReady() or ((6277 - (641 + 839)) >= (5806 - (910 + 3)))) then
					if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((1404 - 853) > (3752 - (1466 + 218)))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if (((972 + 1142) > (2092 - (556 + 592))) and (v141 == (0 + 0))) then
				if (v31 or ((3070 - (329 + 479)) >= (3950 - (174 + 680)))) then
					local v175 = 0 - 0;
					local v176;
					while true do
						if ((v175 == (0 - 0)) or ((1611 + 644) >= (4276 - (396 + 343)))) then
							v176 = v103();
							if (v176 or ((340 + 3497) < (2783 - (29 + 1448)))) then
								return v176;
							end
							break;
						end
					end
				end
				v142 = v102();
				if (((4339 - (135 + 1254)) == (11113 - 8163)) and v142) then
					return v142;
				end
				if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (13 - 10))) or ((3148 + 1575) < (4825 - (389 + 1138)))) then
					if (((1710 - (102 + 472)) >= (146 + 8)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
						return "haunt aoe 2";
					end
				end
				v141 = 1 + 0;
			end
		end
	end
	local function v105()
		if (v31 or ((253 + 18) > (6293 - (320 + 1225)))) then
			local v153 = 0 - 0;
			local v154;
			while true do
				if (((2901 + 1839) >= (4616 - (157 + 1307))) and (v153 == (1859 - (821 + 1038)))) then
					v154 = v103();
					if (v154 or ((6432 - 3854) >= (371 + 3019))) then
						return v154;
					end
					break;
				end
			end
		end
		local v143 = v102();
		if (((72 - 31) <= (618 + 1043)) and v143) then
			return v143;
		end
		if (((1489 - 888) < (4586 - (834 + 192))) and v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
			if (((15 + 220) < (177 + 510)) and v24(v51.SummonDarkglare, v47)) then
				return "summon_darkglare cleave 2";
			end
		end
		if (((98 + 4451) > (1786 - 633)) and v51.MaleficRapture:IsReady() and ((v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (306 - (300 + 4))) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or (v71 > (2 + 2)))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(261 - 161)) or ((5036 - (112 + 250)) < (1863 + 2809))) then
				return "malefic_rapture cleave 2";
			end
		end
		if (((9188 - 5520) < (2613 + 1948)) and v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 + 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (9 + 3))))) then
			if (v24(v51.VileTaint, nil, nil, not v17:IsInRange(20 + 20)) or ((339 + 116) == (5019 - (1001 + 413)))) then
				return "vile_taint cleave 4";
			end
		end
		if ((v51.VileTaint:IsReady() and (v51.AgonyDebuff:AuraActiveCount() == (4 - 2)) and (v51.CorruptionDebuff:AuraActiveCount() == (884 - (244 + 638))) and (not v51.SiphonLife:IsAvailable() or (v51.SiphonLifeDebuff:AuraActiveCount() == (695 - (627 + 66)))) and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (35 - 23))))) or ((3265 - (512 + 90)) == (5218 - (1665 + 241)))) then
			if (((4994 - (373 + 344)) <= (2019 + 2456)) and v24(v55.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v51.VileTaint))) then
				return "vile_taint cleave 10";
			end
		end
		if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v51.AgonyDebuff:AuraActiveCount() >= (5 - 3))) or ((1472 - 602) == (2288 - (35 + 1064)))) then
			if (((1130 + 423) <= (6702 - 3569)) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
				return "soul_rot cleave 8";
			end
		end
		if (v51.Agony:IsReady() or ((9 + 2228) >= (4747 - (298 + 938)))) then
			if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v87, not v17:IsSpellInRange(v51.Agony)) or ((2583 - (233 + 1026)) > (4686 - (636 + 1030)))) then
				return "agony cleave 10";
			end
		end
		if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (3 + 2)) and (v73 > (3 + 0))) or ((889 + 2103) == (128 + 1753))) then
			if (((3327 - (55 + 166)) > (296 + 1230)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
				return "unstable_affliction cleave 12";
			end
		end
		if (((304 + 2719) < (14779 - 10909)) and v51.SeedofCorruption:IsReady() and not v51.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v51.CorruptionDebuff) < (302 - (36 + 261))) and v51.SowTheSeeds:IsAvailable() and v76(v56)) then
			if (((249 - 106) > (1442 - (34 + 1334))) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
				return "seed_of_corruption cleave 14";
			end
		end
		if (((7 + 11) < (1641 + 471)) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1286 - (1035 + 248)))) then
			if (((1118 - (20 + 1)) <= (849 + 779)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
				return "haunt cleave 16";
			end
		end
		if (((4949 - (134 + 185)) == (5763 - (549 + 584))) and v51.Corruption:IsReady() and not (v51.SeedofCorruption:InFlight() or (v17:DebuffRemains(v51.SeedofCorruptionDebuff) > (685 - (314 + 371)))) and (v73 > (17 - 12))) then
			if (((4508 - (478 + 490)) > (1422 + 1261)) and v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption cleave 18";
			end
		end
		if (((5966 - (786 + 386)) >= (10607 - 7332)) and v51.SiphonLife:IsReady() and (v73 > (1384 - (1055 + 324)))) then
			if (((2824 - (1093 + 247)) == (1319 + 165)) and v49.CastTargetIf(v51.SiphonLife, v56, "min", v82, v90, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life cleave 20";
			end
		end
		if (((151 + 1281) < (14113 - 10558)) and v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (9 - 6))) and v59 and v60 and v62) then
			if (v24(v51.SummonDarkglare, v47) or ((3030 - 1965) > (8991 - 5413))) then
				return "summon_darkglare cleave 22";
			end
		end
		if ((v51.MaleficRapture:IsReady() and v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 + 0)) and (v71 > (11 - 8))) or ((16527 - 11732) < (1061 + 346))) then
			if (((4738 - 2885) < (5501 - (364 + 324))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(274 - 174))) then
				return "malefic_rapture cleave 24";
			end
		end
		if ((v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (6 - 3)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1 + 2)))) or ((11803 - 8982) < (3892 - 1461))) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((8728 - 5854) < (3449 - (1249 + 19)))) then
				return "drain_soul cleave 26";
			end
		end
		if ((v70:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((2428 + 261) <= (1335 - 992))) then
			if (v49.CastTargetIf(v70, v56, "min", v81, v89, not v17:IsSpellInRange(v70)) or ((2955 - (686 + 400)) == (1577 + 432))) then
				return "drain_soul/shadow_bolt cleave 28";
			end
		end
		if ((v51.MaleficRapture:IsReady() and not v51.DreadTouch:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff)) or ((3775 - (73 + 156)) < (11 + 2311))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(911 - (721 + 90))) or ((24 + 2058) == (15497 - 10724))) then
				return "malefic_rapture cleave 30";
			end
		end
		if (((3714 - (224 + 246)) > (1709 - 654)) and v51.MaleficRapture:IsReady() and (v63 or v61)) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(184 - 84)) or ((601 + 2712) <= (43 + 1735))) then
				return "malefic_rapture cleave 32";
			end
		end
		if ((v51.MaleficRapture:IsReady() and (v71 > (3 + 0))) or ((2824 - 1403) >= (7001 - 4897))) then
			if (((2325 - (203 + 310)) <= (5242 - (1238 + 755))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(7 + 93))) then
				return "malefic_rapture cleave 34";
			end
		end
		if (((3157 - (709 + 825)) <= (3606 - 1649)) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (69 - 21)) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (884 - (196 + 668))) and (v73 < (15 - 11))))) then
			if (((9138 - 4726) == (5245 - (171 + 662))) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 36";
			end
		end
		if (((1843 - (4 + 89)) >= (2950 - 2108)) and v51.DrainLife:IsReady() and v13:BuffUp(v51.SoulRot) and (v13:BuffStack(v51.InevitableDemiseBuff) > (11 + 19))) then
			if (((19202 - 14830) > (726 + 1124)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 38";
			end
		end
		if (((1718 - (35 + 1451)) < (2274 - (28 + 1425))) and v51.Agony:IsReady()) then
			if (((2511 - (941 + 1052)) < (865 + 37)) and v49.CastCycle(v51.Agony, v56, v92, not v17:IsSpellInRange(v51.Agony))) then
				return "agony cleave 40";
			end
		end
		if (((4508 - (822 + 692)) > (1224 - 366)) and v51.Corruption:IsCastable()) then
			if (v49.CastCycle(v51.Corruption, v56, v94, not v17:IsSpellInRange(v51.Corruption)) or ((1769 + 1986) <= (1212 - (45 + 252)))) then
				return "corruption cleave 42";
			end
		end
		if (((3905 + 41) > (1289 + 2454)) and v51.MaleficRapture:IsReady() and (v71 > (2 - 1))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(533 - (114 + 319))) or ((1916 - 581) >= (4236 - 930))) then
				return "malefic_rapture cleave 44";
			end
		end
		if (((3088 + 1756) > (3356 - 1103)) and v51.DrainSoul:IsReady()) then
			if (((946 - 494) == (2415 - (556 + 1407))) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
				return "drain_soul cleave 54";
			end
		end
		if (v70:IsReady() or ((5763 - (741 + 465)) < (2552 - (170 + 295)))) then
			if (((2042 + 1832) == (3559 + 315)) and v24(v70, nil, nil, not v17:IsSpellInRange(v70))) then
				return "drain_soul/shadow_bolt cleave 46";
			end
		end
	end
	local function v106()
		v48();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v56 = v13:GetEnemiesInRange(98 - 58);
		v57 = v17:GetEnemiesInSplashRange(9 + 1);
		if (v30 or ((1243 + 695) > (2795 + 2140))) then
			v58 = v17:GetEnemiesInSplashRangeCount(1240 - (957 + 273));
		else
			v58 = 1 + 0;
		end
		if (v49.TargetIsValid() or v13:AffectingCombat() or ((1704 + 2551) < (13043 - 9620))) then
			local v155 = 0 - 0;
			while true do
				if (((4440 - 2986) <= (12334 - 9843)) and (v155 == (1781 - (389 + 1391)))) then
					if ((v73 == (6972 + 4139)) or ((433 + 3724) <= (6381 - 3578))) then
						v73 = v10.FightRemains(v57, false);
					end
					break;
				end
				if (((5804 - (783 + 168)) >= (10008 - 7026)) and (v155 == (0 + 0))) then
					v72 = v10.BossFightRemains(nil, true);
					v73 = v72;
					v155 = 312 - (309 + 2);
				end
			end
		end
		v71 = v13:SoulShardsP();
		v66 = v75(v57, v51.AgonyDebuff);
		v67 = v75(v57, v51.VileTaintDebuff);
		v68 = v75(v57, v51.PhantomSingularityDebuff);
		v69 = v28(v67 * v26(v51.VileTaint:IsAvailable()), v68 * v26(v51.PhantomSingularity:IsAvailable()));
		v74 = v13:GCD() + (0.25 - 0);
		if (((5346 - (1090 + 122)) > (1089 + 2268)) and v51.SummonPet:IsCastable() and v43 and not v16:IsActive()) then
			if (v25(v51.SummonPet) or ((11475 - 8058) < (1735 + 799))) then
				return "summon_pet ooc";
			end
		end
		if (v49.TargetIsValid() or ((3840 - (628 + 490)) <= (30 + 134))) then
			if ((not v13:AffectingCombat() and v29) or ((5961 - 3553) < (9638 - 7529))) then
				local v167 = v99();
				if (v167 or ((807 - (431 + 343)) == (2938 - 1483))) then
					return v167;
				end
			end
			if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1281 - 838) >= (3172 + 843))) then
				local v168 = 0 + 0;
				local v169;
				while true do
					if (((5077 - (556 + 1139)) > (181 - (6 + 9))) and (v168 == (0 + 0))) then
						v169 = v49.Interrupt(v51.SpellLock, 21 + 19, true);
						if (v169 or ((449 - (28 + 141)) == (1185 + 1874))) then
							return v169;
						end
						v169 = v49.Interrupt(v51.SpellLock, 49 - 9, true, v15, v55.SpellLockMouseover);
						if (((1333 + 548) > (2610 - (486 + 831))) and v169) then
							return v169;
						end
						v168 = 2 - 1;
					end
					if (((8297 - 5940) == (446 + 1911)) and (v168 == (6 - 4))) then
						v169 = v49.InterruptWithStun(v51.AxeToss, 1303 - (668 + 595), true);
						if (((111 + 12) == (25 + 98)) and v169) then
							return v169;
						end
						v169 = v49.InterruptWithStun(v51.AxeToss, 109 - 69, true, v15, v55.AxeTossMouseover);
						if (v169 or ((1346 - (23 + 267)) >= (5336 - (1129 + 815)))) then
							return v169;
						end
						break;
					end
					if ((v168 == (388 - (371 + 16))) or ((2831 - (1326 + 424)) < (2035 - 960))) then
						v169 = v49.Interrupt(v51.AxeToss, 146 - 106, true);
						if (v169 or ((1167 - (88 + 30)) >= (5203 - (720 + 51)))) then
							return v169;
						end
						v169 = v49.Interrupt(v51.AxeToss, 88 - 48, true, v15, v55.AxeTossMouseover);
						if (v169 or ((6544 - (421 + 1355)) <= (1395 - 549))) then
							return v169;
						end
						v168 = 1 + 1;
					end
				end
			end
			v100();
			if (((v58 > (1084 - (286 + 797))) and (v58 < (10 - 7))) or ((5561 - 2203) <= (1859 - (397 + 42)))) then
				local v170 = v105();
				if (v170 or ((1168 + 2571) <= (3805 - (24 + 776)))) then
					return v170;
				end
			end
			if ((v58 > (2 - 0)) or ((2444 - (222 + 563)) >= (4701 - 2567))) then
				local v171 = v104();
				if (v171 or ((2348 + 912) < (2545 - (23 + 167)))) then
					return v171;
				end
			end
			if (v23() or ((2467 - (690 + 1108)) == (1524 + 2699))) then
				local v172 = 0 + 0;
				local v173;
				while true do
					if (((848 - (40 + 808)) == v172) or ((279 + 1413) < (2248 - 1660))) then
						v173 = v103();
						if (v173 or ((4585 + 212) < (1932 + 1719))) then
							return v173;
						end
						break;
					end
				end
			end
			if (v33 or ((2291 + 1886) > (5421 - (47 + 524)))) then
				local v174 = v102();
				if (v174 or ((260 + 140) > (3036 - 1925))) then
					return v174;
				end
			end
			if (((4561 - 1510) > (2292 - 1287)) and v51.MaleficRapture:IsReady() and v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (1728 - (1165 + 561))) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) then
				if (((110 + 3583) <= (13571 - 9189)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(39 + 61))) then
					return "malefic_rapture main 2";
				end
			end
			if ((v51.MaleficRapture:IsReady() and (v73 < (483 - (341 + 138)))) or ((886 + 2396) > (8461 - 4361))) then
				if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(426 - (89 + 237))) or ((11516 - 7936) < (5987 - 3143))) then
					return "malefic_rapture main 4";
				end
			end
			if (((970 - (581 + 300)) < (5710 - (855 + 365))) and v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (2.5 - 1)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (4 + 8))))) then
				if (v24(v51.VileTaint, v45, nil, not v17:IsInRange(1275 - (1030 + 205))) or ((4679 + 304) < (1682 + 126))) then
					return "vile_taint main 6";
				end
			end
			if (((4115 - (156 + 130)) > (8563 - 4794)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (42 - 17))))) and v17:DebuffUp(v51.AgonyDebuff)) then
				if (((3041 - 1556) <= (766 + 2138)) and v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity))) then
					return "phantom_singularity main 8";
				end
			end
			if (((2490 + 1779) == (4338 - (10 + 59))) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v17:DebuffUp(v51.AgonyDebuff)) then
				if (((1905 - 1518) <= (3945 - (671 + 492))) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
					return "soul_rot main 10";
				end
			end
			if ((v51.Agony:IsCastable() and (not v51.VileTaint:IsAvailable() or (v17:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime()))) and (v17:DebuffRemains(v51.AgonyDebuff) < (4 + 1)) and (v73 > (1220 - (369 + 846)))) or ((503 + 1396) <= (783 + 134))) then
				if (v24(v51.Agony, nil, nil, not v17:IsSpellInRange(v51.Agony)) or ((6257 - (1036 + 909)) <= (697 + 179))) then
					return "agony main 12";
				end
			end
			if (((3746 - 1514) <= (2799 - (11 + 192))) and v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (3 + 2)) and (v73 > (178 - (135 + 40)))) then
				if (((5075 - 2980) < (2222 + 1464)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
					return "unstable_affliction main 14";
				end
			end
			if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (10 - 5))) or ((2391 - 796) >= (4650 - (50 + 126)))) then
				if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((12861 - 8242) < (638 + 2244))) then
					return "haunt main 16";
				end
			end
			if ((v51.Corruption:IsCastable() and v17:DebuffRefreshable(v51.CorruptionDebuff) and (v73 > (1418 - (1233 + 180)))) or ((1263 - (522 + 447)) >= (6252 - (107 + 1314)))) then
				if (((942 + 1087) <= (9396 - 6312)) and v24(v51.Corruption, nil, nil, not v17:IsSpellInRange(v51.Corruption))) then
					return "corruption main 18";
				end
			end
			if ((v51.SiphonLife:IsCastable() and v17:DebuffRefreshable(v51.SiphonLifeDebuff) and (v73 > (3 + 2))) or ((4044 - 2007) == (9574 - 7154))) then
				if (((6368 - (716 + 1194)) > (67 + 3837)) and v24(v51.SiphonLife, nil, nil, not v17:IsSpellInRange(v51.SiphonLife))) then
					return "siphon_life main 20";
				end
			end
			if (((47 + 389) >= (626 - (74 + 429))) and v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (5 - 2))) and v59 and v60 and v62) then
				if (((248 + 252) < (4156 - 2340)) and v24(v51.SummonDarkglare, v47)) then
					return "summon_darkglare main 22";
				end
			end
			if (((2529 + 1045) == (11018 - 7444)) and v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (7 - 4)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (436 - (279 + 154))))) then
				if (((999 - (454 + 324)) < (307 + 83)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
					return "drain_soul main 24";
				end
			end
			if ((v51.ShadowBolt:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (20 - (12 + 5))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (2 + 1)))) or ((5638 - 3425) <= (526 + 895))) then
				if (((4151 - (277 + 816)) < (20767 - 15907)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 26";
				end
			end
			if ((v51.MaleficRapture:IsReady() and ((v71 > (1187 - (1058 + 125))) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 + 0)) and (v71 > (978 - (815 + 160)))) or (v51.TormentedCrescendo:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v17:DebuffDown(v51.DreadTouchDebuff)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (8 - 6))) or v63 or (v61 and (v71 > (2 - 1))) or (v51.TormentedCrescendo:IsAvailable() and v51.Nightfall:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v13:BuffUp(v51.NightfallBuff)))) or ((310 + 986) >= (12996 - 8550))) then
				if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1998 - (41 + 1857))) or ((3286 - (1222 + 671)) > (11601 - 7112))) then
					return "malefic_rapture main 28";
				end
			end
			if ((v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (68 - 20)) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (1202 - (229 + 953))) and (v73 < (1778 - (1111 + 663)))))) or ((6003 - (874 + 705)) < (4 + 23))) then
				if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((1363 + 634) > (7930 - 4115))) then
					return "drain_life main 30";
				end
			end
			if (((98 + 3367) > (2592 - (642 + 37))) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
				if (((168 + 565) < (292 + 1527)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
					return "drain_soul main 32";
				end
			end
			if ((v51.ShadowBolt:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((11034 - 6639) == (5209 - (233 + 221)))) then
				if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((8770 - 4977) < (2086 + 283))) then
					return "shadow_bolt main 34";
				end
			end
			if (v51.DrainSoul:IsReady() or ((5625 - (718 + 823)) == (167 + 98))) then
				if (((5163 - (266 + 539)) == (12338 - 7980)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
					return "drain_soul main 36";
				end
			end
			if (v51.ShadowBolt:IsReady() or ((4363 - (636 + 589)) < (2356 - 1363))) then
				if (((6868 - 3538) > (1841 + 482)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 38";
				end
			end
		end
	end
	local function v107()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (1015 - (657 + 358))) or ((9600 - 5974) == (9087 - 5098))) then
				v10.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v51.AgonyDebuff:RegisterAuraTracking();
				v147 = 1188 - (1151 + 36);
			end
			if (((1 + 0) == v147) or ((241 + 675) == (7976 - 5305))) then
				v51.SiphonLifeDebuff:RegisterAuraTracking();
				v51.CorruptionDebuff:RegisterAuraTracking();
				v147 = 1834 - (1552 + 280);
			end
			if (((1106 - (64 + 770)) == (185 + 87)) and (v147 == (4 - 2))) then
				v51.UnstableAfflictionDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v10.SetAPL(48 + 217, v106, v107);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

