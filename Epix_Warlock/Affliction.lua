local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((1050 - (19 + 23)) < (8168 - 4457)) and not v6) then
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
		local v108 = 0 - 0;
		while true do
			if ((v108 == (1429 - (1233 + 195))) or ((3497 - 2448) <= (325 + 581))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v108 = 1 + 1;
			end
			if (((5946 - (797 + 636)) > (13235 - 10509)) and (v108 == (1622 - (1427 + 192)))) then
				v45 = EpicSettings.Settings['VileTaint'];
				v46 = EpicSettings.Settings['PhantomSingularity'];
				v47 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if ((v108 == (0 + 0)) or ((3438 - 1957) >= (2390 + 268))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v108 = 327 - (192 + 134);
			end
			if ((v108 == (1278 - (316 + 960))) or ((1792 + 1428) == (1053 + 311))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (551 - (83 + 468));
				v108 = 1809 - (1202 + 604);
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
	local v72 = 18492 - 7381;
	local v73 = 30763 - 19652;
	local v74;
	v10:RegisterForEvent(function()
		local v109 = 325 - (45 + 280);
		while true do
			if ((v109 == (0 + 0)) or ((921 + 133) > (1239 + 2153))) then
				v51.SeedofCorruption:RegisterInFlight();
				v51.ShadowBolt:RegisterInFlight();
				v109 = 1 + 0;
			end
			if ((v109 == (1 + 0)) or ((1251 - 575) >= (3553 - (340 + 1571)))) then
				v51.Haunt:RegisterInFlight();
				v70 = ((v51.DrainSoul:IsAvailable()) and v51.DrainSoul) or v51.ShadowBolt;
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v51.SeedofCorruption:RegisterInFlight();
	v51.ShadowBolt:RegisterInFlight();
	v51.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		v72 = 4383 + 6728;
		v73 = 12883 - (1733 + 39);
	end, "PLAYER_REGEN_ENABLED");
	local function v75(v110, v111)
		local v112 = 0 - 0;
		local v113;
		while true do
			if (((5170 - (125 + 909)) > (4345 - (1096 + 852))) and (v112 == (0 + 0))) then
				if (not v110 or not v111 or ((6189 - 1855) == (4118 + 127))) then
					return 512 - (409 + 103);
				end
				v113 = nil;
				v112 = 237 - (46 + 190);
			end
			if ((v112 == (96 - (51 + 44))) or ((1207 + 3069) <= (4348 - (1114 + 203)))) then
				for v161, v162 in pairs(v110) do
					local v163 = v162:DebuffRemains(v111) + ((825 - (228 + 498)) * v26(v162:DebuffDown(v111)));
					if ((v113 == nil) or (v163 < v113) or ((1037 + 3745) <= (663 + 536))) then
						v113 = v163;
					end
				end
				return v113 or (663 - (174 + 489));
			end
		end
	end
	local function v76(v114)
		if (not v114 or (#v114 == (0 - 0)) or ((6769 - (830 + 1075)) < (2426 - (303 + 221)))) then
			return false;
		end
		if (((6108 - (231 + 1038)) >= (3084 + 616)) and (v51.SeedofCorruption:InFlight() or v13:PrevGCDP(1163 - (171 + 991), v51.SeedofCorruption))) then
			return false;
		end
		local v115 = 0 - 0;
		local v116 = 0 - 0;
		for v145, v146 in pairs(v114) do
			v115 = v115 + (2 - 1);
			if (v146:DebuffUp(v51.SeedofCorruptionDebuff) or ((861 + 214) > (6723 - 4805))) then
				v116 = v116 + (2 - 1);
			end
		end
		return v115 == v116;
	end
	local function v77()
		return v50.GuardiansTable.DarkglareDuration > (0 - 0);
	end
	local function v78()
		return v50.GuardiansTable.DarkglareDuration;
	end
	local function v79(v117)
		return (v117:DebuffRemains(v51.AgonyDebuff));
	end
	local function v80(v118)
		return (v118:DebuffRemains(v51.CorruptionDebuff));
	end
	local function v81(v119)
		return (v119:DebuffRemains(v51.ShadowEmbraceDebuff));
	end
	local function v82(v120)
		return (v120:DebuffRemains(v51.SiphonLifeDebuff));
	end
	local function v83(v121)
		return (v121:DebuffRemains(v51.SoulRotDebuff));
	end
	local function v84(v122)
		return (v122:DebuffRemains(v51.AgonyDebuff) < (v122:DebuffRemains(v51.VileTaintDebuff) + v51.VileTaint:CastTime())) and (v122:DebuffRemains(v51.AgonyDebuff) < (15 - 10));
	end
	local function v85(v123)
		return v123:DebuffRemains(v51.AgonyDebuff) < (1253 - (111 + 1137));
	end
	local function v86(v124)
		return ((v124:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v124:DebuffRemains(v51.AgonyDebuff) < (163 - (91 + 67)));
	end
	local function v87(v125)
		return ((v125:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v125:DebuffRemains(v51.AgonyDebuff) < (14 - 9)) and (v73 > (2 + 3));
	end
	local function v88(v126)
		return v126:DebuffRemains(v51.CorruptionDebuff) < (528 - (423 + 100));
	end
	local function v89(v127)
		return (v51.ShadowEmbrace:IsAvailable() and ((v127:DebuffStack(v51.ShadowEmbraceDebuff) < (1 + 2)) or (v127:DebuffRemains(v51.ShadowEmbraceDebuff) < (7 - 4)))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v90(v128)
		return (v128:DebuffRefreshable(v51.SiphonLifeDebuff));
	end
	local function v91(v129)
		return v129:DebuffRemains(v51.AgonyDebuff) < (3 + 2);
	end
	local function v92(v130)
		return (v130:DebuffRefreshable(v51.AgonyDebuff));
	end
	local function v93(v131)
		return v131:DebuffRemains(v51.CorruptionDebuff) < (776 - (326 + 445));
	end
	local function v94(v132)
		return (v132:DebuffRefreshable(v51.CorruptionDebuff));
	end
	local function v95(v133)
		return (v133:DebuffStack(v51.ShadowEmbraceDebuff) < (13 - 10)) or (v133:DebuffRemains(v51.ShadowEmbraceDebuff) < (6 - 3));
	end
	local function v96(v134)
		return (v51.ShadowEmbrace:IsAvailable() and ((v134:DebuffStack(v51.ShadowEmbraceDebuff) < (6 - 3)) or (v134:DebuffRemains(v51.ShadowEmbraceDebuff) < (714 - (530 + 181))))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v97(v135)
		return v135:DebuffRemains(v51.SiphonLifeDebuff) < (886 - (614 + 267));
	end
	local function v98(v136)
		return (v136:DebuffRemains(v51.SiphonLifeDebuff) < (37 - (19 + 13))) and v136:DebuffUp(v51.AgonyDebuff);
	end
	local function v99()
		local v137 = 0 - 0;
		while true do
			if (((922 - 526) <= (10866 - 7062)) and ((0 + 0) == v137)) then
				if (v51.GrimoireofSacrifice:IsCastable() or ((7331 - 3162) == (4534 - 2347))) then
					if (((3218 - (1293 + 519)) == (2868 - 1462)) and v25(v51.GrimoireofSacrifice)) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (((3997 - 2466) < (8167 - 3896)) and v51.Haunt:IsReady()) then
					if (((2738 - 2103) == (1495 - 860)) and v25(v51.Haunt, not v17:IsSpellInRange(v51.Haunt), true)) then
						return "haunt precombat 6";
					end
				end
				v137 = 1 + 0;
			end
			if (((689 + 2684) <= (8261 - 4705)) and (v137 == (1 + 0))) then
				if ((v51.UnstableAffliction:IsReady() and not v51.SoulSwap:IsAvailable()) or ((1094 + 2197) < (2050 + 1230))) then
					if (((5482 - (709 + 387)) >= (2731 - (673 + 1185))) and v25(v51.UnstableAffliction, not v17:IsSpellInRange(v51.UnstableAffliction), true)) then
						return "unstable_affliction precombat 8";
					end
				end
				if (((2670 - 1749) <= (3538 - 2436)) and v51.ShadowBolt:IsReady()) then
					if (((7742 - 3036) >= (689 + 274)) and v25(v51.ShadowBolt, not v17:IsSpellInRange(v51.ShadowBolt), true)) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
		end
	end
	local function v100()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (3 - 0)) or ((236 + 724) <= (1746 - 870))) then
				v65 = not v64 or (v63 and ((v51.SummonDarkglare:CooldownRemains() > (39 - 19)) or not v51.SummonDarkglare:IsAvailable()));
				break;
			end
			if (((1881 - (446 + 1434)) == v138) or ((3349 - (1040 + 243)) == (2781 - 1849))) then
				v61 = v17:DebuffUp(v51.VileTaintDebuff) or v17:DebuffUp(v51.PhantomSingularityDebuff) or (not v51.VileTaint:IsAvailable() and not v51.PhantomSingularity:IsAvailable());
				v62 = v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable();
				v138 = 1849 - (559 + 1288);
			end
			if (((6756 - (609 + 1322)) < (5297 - (13 + 441))) and ((7 - 5) == v138)) then
				v63 = v59 and v60 and v62;
				v64 = v51.PhantomSingularity:IsAvailable() or v51.VileTaint:IsAvailable() or v51.SoulRot:IsAvailable() or v51.SummonDarkglare:IsAvailable();
				v138 = 7 - 4;
			end
			if ((v138 == (0 - 0)) or ((145 + 3732) >= (16477 - 11940))) then
				v59 = v17:DebuffUp(v51.PhantomSingularityDebuff) or not v51.PhantomSingularity:IsAvailable();
				v60 = v17:DebuffUp(v51.VileTaintDebuff) or not v51.VileTaint:IsAvailable();
				v138 = 1 + 0;
			end
		end
	end
	local function v101()
		local v139 = v49.HandleTopTrinket(v53, v31, 18 + 22, nil);
		if (v139 or ((12804 - 8489) < (945 + 781))) then
			return v139;
		end
		local v139 = v49.HandleBottomTrinket(v53, v31, 73 - 33, nil);
		if (v139 or ((2433 + 1246) < (348 + 277))) then
			return v139;
		end
	end
	local function v102()
		local v140 = v101();
		if (v140 or ((3324 + 1301) < (531 + 101))) then
			return v140;
		end
		if (v52.DesperateInvokersCodex:IsEquippedAndReady() or ((82 + 1) > (2213 - (153 + 280)))) then
			if (((1576 - 1030) <= (967 + 110)) and v25(v55.DesperateInvokersCodex, not v17:IsInRange(18 + 27))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (v52.ConjuredChillglobe:IsEquippedAndReady() or ((522 + 474) > (3904 + 397))) then
			if (((2950 + 1120) > (1045 - 358)) and v25(v55.ConjuredChillglobe)) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v103()
		if (v65 or ((406 + 250) >= (3997 - (89 + 578)))) then
			local v147 = v49.HandleDPSPotion();
			if (v147 or ((1781 + 711) <= (696 - 361))) then
				return v147;
			end
			if (((5371 - (572 + 477)) >= (346 + 2216)) and v51.Berserking:IsCastable()) then
				if (v25(v51.Berserking) or ((2183 + 1454) >= (451 + 3319))) then
					return "berserking ogcd 4";
				end
			end
			if (v51.BloodFury:IsCastable() or ((2465 - (84 + 2)) > (7544 - 2966))) then
				if (v25(v51.BloodFury) or ((348 + 135) > (1585 - (497 + 345)))) then
					return "blood_fury ogcd 6";
				end
			end
			if (((63 + 2391) > (98 + 480)) and v51.Fireblood:IsCastable()) then
				if (((2263 - (605 + 728)) < (3181 + 1277)) and v25(v51.Fireblood)) then
					return "fireblood ogcd 8";
				end
			end
		end
	end
	local function v104()
		if (((1471 - 809) <= (45 + 927)) and v31) then
			local v148 = 0 - 0;
			local v149;
			while true do
				if (((3940 + 430) == (12107 - 7737)) and ((0 + 0) == v148)) then
					v149 = v103();
					if (v149 or ((5251 - (457 + 32)) <= (366 + 495))) then
						return v149;
					end
					break;
				end
			end
		end
		local v141 = v102();
		if (v141 or ((2814 - (832 + 570)) == (4018 + 246))) then
			return v141;
		end
		if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1 + 2))) or ((11210 - 8042) < (1038 + 1115))) then
			if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((5772 - (588 + 208)) < (3589 - 2257))) then
				return "haunt aoe 2";
			end
		end
		if (((6428 - (884 + 916)) == (9688 - 5060)) and v51.VileTaint:IsReady() and (((v51.SouleatersGluttony:TalentRank() == (2 + 0)) and ((v66 < (654.5 - (232 + 421))) or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()))) or ((v51.SouleatersGluttony:TalentRank() == (1890 - (1569 + 320))) and (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and ((v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (v51.VileTaint:CooldownRemains() > (7 + 18)))))) then
			if (v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(8 + 32)) or ((181 - 127) == (1000 - (316 + 289)))) then
				return "vile_taint aoe 4";
			end
		end
		if (((214 - 132) == (4 + 78)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:IsAvailable() and (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (1478 - (666 + 787)))))) and v17:DebuffUp(v51.AgonyDebuff)) then
			if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((1006 - (360 + 65)) < (264 + 18))) then
				return "phantom_singularity aoe 6";
			end
		end
		if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (259 - (79 + 175)))) or ((7266 - 2657) < (1947 + 548))) then
			if (((3530 - 2378) == (2218 - 1066)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
				return "unstable_affliction aoe 8";
			end
		end
		if (((2795 - (503 + 396)) <= (3603 - (92 + 89))) and v51.Agony:IsReady() and (v51.AgonyDebuff:AuraActiveCount() < (15 - 7)) and (((v74 * (2 + 0)) + v51.SoulRot:CastTime()) < v69)) then
			if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v86, not v17:IsSpellInRange(v51.Agony)) or ((586 + 404) > (6344 - 4724))) then
				return "agony aoe 9";
			end
		end
		if ((v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (1 + 5)) and v51.SummonDarkglare:CooldownUp() and (v10.CombatTime() < (45 - 25)) and (((v74 * (2 + 0)) + v51.SoulRot:CastTime()) < v69)) or ((419 + 458) > (14299 - 9604))) then
			if (((336 + 2355) >= (2822 - 971)) and v49.CastCycle(v51.SiphonLife, v56, v98, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life aoe 10";
			end
		end
		if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1245 - (485 + 759)))) and v17:DebuffUp(v51.AgonyDebuff)) or ((6906 - 3921) >= (6045 - (442 + 747)))) then
			if (((5411 - (832 + 303)) >= (2141 - (88 + 858))) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
				return "soul_rot aoe 12";
			end
		end
		if (((986 + 2246) <= (3882 + 808)) and v51.SeedofCorruption:IsReady() and (v17:DebuffRemains(v51.CorruptionDebuff) < (1 + 4)) and not (v51.SeedofCorruption:InFlight() or v17:DebuffUp(v51.SeedofCorruptionDebuff))) then
			if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((1685 - (766 + 23)) >= (15530 - 12384))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if (((4186 - 1125) >= (7793 - 4835)) and v51.Corruption:IsReady() and not v51.SeedofCorruption:IsAvailable()) then
			if (((10816 - 7629) >= (1717 - (1036 + 37))) and v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption aoe 15";
			end
		end
		if (((457 + 187) <= (1370 - 666)) and v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
			if (((754 + 204) > (2427 - (641 + 839))) and v24(v51.SummonDarkglare, v47)) then
				return "summon_darkglare aoe 18";
			end
		end
		if (((5405 - (910 + 3)) >= (6765 - 4111)) and v51.DrainLife:IsReady() and (v13:BuffStack(v51.InevitableDemiseBuff) > (1714 - (1466 + 218))) and v13:BuffUp(v51.SoulRot) and (v13:BuffRemains(v51.SoulRot) <= v74) and (v58 > (2 + 1))) then
			if (((4590 - (556 + 592)) >= (535 + 968)) and v49.CastTargetIf(v51.DrainLife, v56, "min", v83, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life aoe 19";
			end
		end
		if ((v51.MaleficRapture:IsReady() and v13:BuffUp(v51.UmbrafireKindlingBuff) and ((((v58 < (814 - (329 + 479))) or (v10.CombatTime() < (884 - (174 + 680)))) and v77()) or not v51.DoomBlossom:IsAvailable())) or ((10892 - 7722) <= (3034 - 1570))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(72 + 28)) or ((5536 - (396 + 343)) == (389 + 3999))) then
				return "malefic_rapture aoe 20";
			end
		end
		if (((2028 - (29 + 1448)) <= (2070 - (135 + 1254))) and v51.SeedofCorruption:IsReady() and v51.SowTheSeeds:IsAvailable()) then
			if (((12344 - 9067) > (1900 - 1493)) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if (((3129 + 1566) >= (2942 - (389 + 1138))) and v51.MaleficRapture:IsReady() and ((((v51.SummonDarkglare:CooldownRemains() > (589 - (102 + 472))) or (v71 > (3 + 0))) and not v51.SowTheSeeds:IsAvailable()) or v13:BuffUp(v51.TormentedCrescendoBuff))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(56 + 44)) or ((2995 + 217) <= (2489 - (320 + 1225)))) then
				return "malefic_rapture aoe 24";
			end
		end
		if ((v51.DrainLife:IsReady() and (v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable()) and (v13:BuffStack(v51.InevitableDemiseBuff) > (17 - 7))) or ((1895 + 1201) <= (3262 - (157 + 1307)))) then
			if (((5396 - (821 + 1038)) == (8824 - 5287)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life aoe 26";
			end
		end
		if (((420 + 3417) >= (2788 - 1218)) and v51.DrainSoul:IsReady() and v13:BuffUp(v51.NightfallBuff) and v51.ShadowEmbrace:IsAvailable()) then
			if (v49.CastCycle(v51.DrainSoul, v56, v95, not v17:IsSpellInRange(v51.DrainSoul)) or ((1098 + 1852) == (9448 - 5636))) then
				return "drain_soul aoe 28";
			end
		end
		if (((5749 - (834 + 192)) >= (148 + 2170)) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((521 + 1506) > (62 + 2790))) then
				return "drain_soul aoe 30";
			end
		end
		if ((v51.SummonSoulkeeper:IsReady() and ((v51.SummonSoulkeeper:Count() == (15 - 5)) or ((v51.SummonSoulkeeper:Count() > (307 - (300 + 4))) and (v73 < (3 + 7))))) or ((2973 - 1837) > (4679 - (112 + 250)))) then
			if (((1893 + 2855) == (11894 - 7146)) and v24(v51.SummonSoulkeeper)) then
				return "soul_strike aoe 32";
			end
		end
		if (((2141 + 1595) <= (2452 + 2288)) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (4 + 1)) and ((v58 < (4 + 4)) or not v51.DoomBlossom:IsAvailable())) then
			if (v49.CastCycle(v51.SiphonLife, v56, v97, not v17:IsSpellInRange(v51.SiphonLife)) or ((2519 + 871) <= (4474 - (1001 + 413)))) then
				return "siphon_life aoe 34";
			end
		end
		if (v51.DrainSoul:IsReady() or ((2227 - 1228) > (3575 - (244 + 638)))) then
			if (((1156 - (627 + 66)) < (1790 - 1189)) and v49.CastCycle(v51.DrainSoul, v56, v96, not v17:IsSpellInRange(v51.DrainSoul))) then
				return "drain_soul aoe 36";
			end
		end
		if (v51.ShadowBolt:IsReady() or ((2785 - (512 + 90)) < (2593 - (1665 + 241)))) then
			if (((5266 - (373 + 344)) == (2052 + 2497)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v105()
		local v142 = 0 + 0;
		local v143;
		while true do
			if (((12323 - 7651) == (7905 - 3233)) and (v142 == (1104 - (35 + 1064)))) then
				if ((v51.MaleficRapture:IsReady() and v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 + 0)) and (v71 > (6 - 3))) or ((15 + 3653) < (1631 - (298 + 938)))) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1359 - (233 + 1026))) or ((5832 - (636 + 1030)) == (233 + 222))) then
						return "malefic_rapture cleave 24";
					end
				end
				if ((v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (3 + 0)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1 + 2)))) or ((301 + 4148) == (2884 - (55 + 166)))) then
					if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((829 + 3448) < (301 + 2688))) then
						return "drain_soul cleave 26";
					end
				end
				if ((v70:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((3322 - 2452) >= (4446 - (36 + 261)))) then
					if (((3868 - 1656) < (4551 - (34 + 1334))) and v49.CastTargetIf(v70, v56, "min", v81, v89, not v17:IsSpellInRange(v70))) then
						return "drain_soul/shadow_bolt cleave 28";
					end
				end
				v142 = 3 + 3;
			end
			if (((3610 + 1036) > (4275 - (1035 + 248))) and (v142 == (29 - (20 + 1)))) then
				if (((748 + 686) < (3425 - (134 + 185))) and v51.Corruption:IsCastable()) then
					if (((1919 - (549 + 584)) < (3708 - (314 + 371))) and v49.CastCycle(v51.Corruption, v56, v94, not v17:IsSpellInRange(v51.Corruption))) then
						return "corruption cleave 42";
					end
				end
				if ((v51.MaleficRapture:IsReady() and (v71 > (3 - 2))) or ((3410 - (478 + 490)) < (40 + 34))) then
					if (((5707 - (786 + 386)) == (14688 - 10153)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1479 - (1055 + 324)))) then
						return "malefic_rapture cleave 44";
					end
				end
				if (v51.DrainSoul:IsReady() or ((4349 - (1093 + 247)) <= (1871 + 234))) then
					if (((193 + 1637) < (14566 - 10897)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				v142 = 30 - 21;
			end
			if ((v142 == (8 - 5)) or ((3593 - 2163) >= (1285 + 2327))) then
				if (((10335 - 7652) >= (8479 - 6019)) and v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (4 + 1)) and (v73 > (7 - 4))) then
					if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((2492 - (364 + 324)) >= (8977 - 5702))) then
						return "unstable_affliction cleave 12";
					end
				end
				if ((v51.SeedofCorruption:IsReady() and not v51.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v51.CorruptionDebuff) < (11 - 6)) and v51.SowTheSeeds:IsAvailable() and v76(v56)) or ((470 + 947) > (15184 - 11555))) then
					if (((7679 - 2884) > (1220 - 818)) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
						return "seed_of_corruption cleave 14";
					end
				end
				if (((6081 - (1249 + 19)) > (3218 + 347)) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (11 - 8))) then
					if (((4998 - (686 + 400)) == (3070 + 842)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
						return "haunt cleave 16";
					end
				end
				v142 = 233 - (73 + 156);
			end
			if (((14 + 2807) <= (5635 - (721 + 90))) and (v142 == (1 + 6))) then
				if (((5643 - 3905) <= (2665 - (224 + 246))) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (77 - 29)) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (36 - 16)) and (v73 < (1 + 3))))) then
					if (((1 + 40) <= (2217 + 801)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
						return "drain_life cleave 36";
					end
				end
				if (((4264 - 2119) <= (13657 - 9553)) and v51.DrainLife:IsReady() and v13:BuffUp(v51.SoulRot) and (v13:BuffStack(v51.InevitableDemiseBuff) > (543 - (203 + 310)))) then
					if (((4682 - (1238 + 755)) < (339 + 4506)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
						return "drain_life cleave 38";
					end
				end
				if (v51.Agony:IsReady() or ((3856 - (709 + 825)) > (4831 - 2209))) then
					if (v49.CastCycle(v51.Agony, v56, v92, not v17:IsSpellInRange(v51.Agony)) or ((6604 - 2070) == (2946 - (196 + 668)))) then
						return "agony cleave 40";
					end
				end
				v142 = 31 - 23;
			end
			if ((v142 == (12 - 6)) or ((2404 - (171 + 662)) > (1960 - (4 + 89)))) then
				if ((v51.MaleficRapture:IsReady() and not v51.DreadTouch:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff)) or ((9302 - 6648) >= (1091 + 1905))) then
					if (((17472 - 13494) > (826 + 1278)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1586 - (35 + 1451)))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((4448 - (28 + 1425)) > (3534 - (941 + 1052))) and v51.MaleficRapture:IsReady() and (v63 or v61)) then
					if (((3116 + 133) > (2467 - (822 + 692))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(142 - 42))) then
						return "malefic_rapture cleave 32";
					end
				end
				if ((v51.MaleficRapture:IsReady() and (v71 > (2 + 1))) or ((3570 - (45 + 252)) > (4525 + 48))) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(35 + 65)) or ((7668 - 4517) < (1717 - (114 + 319)))) then
						return "malefic_rapture cleave 34";
					end
				end
				v142 = 9 - 2;
			end
			if ((v142 == (10 - 1)) or ((1180 + 670) == (2277 - 748))) then
				if (((1720 - 899) < (4086 - (556 + 1407))) and v70:IsReady()) then
					if (((2108 - (741 + 465)) < (2790 - (170 + 295))) and v24(v70, nil, nil, not v17:IsSpellInRange(v70))) then
						return "drain_soul/shadow_bolt cleave 46";
					end
				end
				break;
			end
			if (((453 + 405) <= (2721 + 241)) and (v142 == (9 - 5))) then
				if ((v51.Corruption:IsReady() and not (v51.SeedofCorruption:InFlight() or (v17:DebuffRemains(v51.SeedofCorruptionDebuff) > (0 + 0))) and (v73 > (4 + 1))) or ((2235 + 1711) < (2518 - (957 + 273)))) then
					if (v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption)) or ((868 + 2374) == (227 + 340))) then
						return "corruption cleave 18";
					end
				end
				if ((v51.SiphonLife:IsReady() and (v73 > (19 - 14))) or ((2231 - 1384) >= (3857 - 2594))) then
					if (v49.CastTargetIf(v51.SiphonLife, v56, "min", v82, v90, not v17:IsSpellInRange(v51.SiphonLife)) or ((11156 - 8903) == (3631 - (389 + 1391)))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (2 + 1))) and v59 and v60 and v62) or ((218 + 1869) > (5399 - 3027))) then
					if (v24(v51.SummonDarkglare, v47) or ((5396 - (783 + 168)) < (13924 - 9775))) then
						return "summon_darkglare cleave 22";
					end
				end
				v142 = 5 + 0;
			end
			if ((v142 == (313 - (309 + 2))) or ((5582 - 3764) == (1297 - (1090 + 122)))) then
				if (((205 + 425) < (7143 - 5016)) and v51.VileTaint:IsReady() and (v51.AgonyDebuff:AuraActiveCount() == (2 + 0)) and (v51.CorruptionDebuff:AuraActiveCount() == (1120 - (628 + 490))) and (not v51.SiphonLife:IsAvailable() or (v51.SiphonLifeDebuff:AuraActiveCount() == (1 + 1))) and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (29 - 17))))) then
					if (v24(v55.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v51.VileTaint)) or ((8856 - 6918) == (3288 - (431 + 343)))) then
						return "vile_taint cleave 10";
					end
				end
				if (((8593 - 4338) >= (159 - 104)) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v51.AgonyDebuff:AuraActiveCount() >= (1 + 1))) then
					if (((4694 - (556 + 1139)) > (1171 - (6 + 9))) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				if (((431 + 1919) > (592 + 563)) and v51.Agony:IsReady()) then
					if (((4198 - (28 + 141)) <= (1880 + 2973)) and v49.CastTargetIf(v51.Agony, v56, "min", v79, v87, not v17:IsSpellInRange(v51.Agony))) then
						return "agony cleave 10";
					end
				end
				v142 = 3 - 0;
			end
			if ((v142 == (0 + 0)) or ((1833 - (486 + 831)) > (8936 - 5502))) then
				if (((14244 - 10198) >= (574 + 2459)) and v31) then
					local v164 = 0 - 0;
					local v165;
					while true do
						if ((v164 == (1263 - (668 + 595))) or ((2447 + 272) <= (292 + 1155))) then
							v165 = v103();
							if (v165 or ((11273 - 7139) < (4216 - (23 + 267)))) then
								return v165;
							end
							break;
						end
					end
				end
				v143 = v102();
				if (v143 or ((2108 - (1129 + 815)) >= (3172 - (371 + 16)))) then
					return v143;
				end
				v142 = 1751 - (1326 + 424);
			end
			if ((v142 == (1 - 0)) or ((1918 - 1393) == (2227 - (88 + 30)))) then
				if (((804 - (720 + 51)) == (73 - 40)) and v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
					if (((4830 - (421 + 1355)) <= (6623 - 2608)) and v24(v51.SummonDarkglare, v47)) then
						return "summon_darkglare cleave 2";
					end
				end
				if (((920 + 951) < (4465 - (286 + 797))) and v51.MaleficRapture:IsReady() and ((v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (7 - 5)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or (v71 > (6 - 2)))) then
					if (((1732 - (397 + 42)) <= (677 + 1489)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(900 - (24 + 776)))) then
						return "malefic_rapture cleave 2";
					end
				end
				if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 - 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (797 - (222 + 563)))))) or ((5681 - 3102) < (89 + 34))) then
					if (v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(230 - (23 + 167))) or ((2644 - (690 + 1108)) >= (855 + 1513))) then
						return "vile_taint cleave 4";
					end
				end
				v142 = 2 + 0;
			end
		end
	end
	local function v106()
		local v144 = 848 - (40 + 808);
		while true do
			if ((v144 == (1 + 4)) or ((15341 - 11329) <= (3210 + 148))) then
				if (((791 + 703) <= (1648 + 1357)) and v49.TargetIsValid()) then
					local v166 = 571 - (47 + 524);
					while true do
						if ((v166 == (0 + 0)) or ((8504 - 5393) == (3190 - 1056))) then
							if (((5370 - 3015) == (4081 - (1165 + 561))) and not v13:AffectingCombat() and v29) then
								local v167 = 0 + 0;
								local v168;
								while true do
									if (((0 - 0) == v167) or ((225 + 363) <= (911 - (341 + 138)))) then
										v168 = v99();
										if (((1295 + 3502) >= (8038 - 4143)) and v168) then
											return v168;
										end
										break;
									end
								end
							end
							if (((3903 - (89 + 237)) == (11507 - 7930)) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v169 = 0 - 0;
								local v170;
								while true do
									if (((4675 - (581 + 300)) > (4913 - (855 + 365))) and (v169 == (0 - 0))) then
										v170 = v49.Interrupt(v51.SpellLock, 14 + 26, true);
										if (v170 or ((2510 - (1030 + 205)) == (3850 + 250))) then
											return v170;
										end
										v170 = v49.Interrupt(v51.SpellLock, 38 + 2, true, v15, v55.SpellLockMouseover);
										v169 = 287 - (156 + 130);
									end
									if (((4 - 2) == v169) or ((2681 - 1090) >= (7332 - 3752))) then
										v170 = v49.Interrupt(v51.AxeToss, 11 + 29, true, v15, v55.AxeTossMouseover);
										if (((574 + 409) <= (1877 - (10 + 59))) and v170) then
											return v170;
										end
										v170 = v49.InterruptWithStun(v51.AxeToss, 12 + 28, true);
										v169 = 14 - 11;
									end
									if ((v169 == (1164 - (671 + 492))) or ((1712 + 438) <= (2412 - (369 + 846)))) then
										if (((998 + 2771) >= (1002 + 171)) and v170) then
											return v170;
										end
										v170 = v49.Interrupt(v51.AxeToss, 1985 - (1036 + 909), true);
										if (((1181 + 304) == (2493 - 1008)) and v170) then
											return v170;
										end
										v169 = 205 - (11 + 192);
									end
									if (((2 + 1) == v169) or ((3490 - (135 + 40)) <= (6740 - 3958))) then
										if (v170 or ((529 + 347) >= (6529 - 3565))) then
											return v170;
										end
										v170 = v49.InterruptWithStun(v51.AxeToss, 59 - 19, true, v15, v55.AxeTossMouseover);
										if (v170 or ((2408 - (50 + 126)) > (6952 - 4455))) then
											return v170;
										end
										break;
									end
								end
							end
							v100();
							if (((v58 > (1 + 0)) and (v58 < (1416 - (1233 + 180)))) or ((3079 - (522 + 447)) <= (1753 - (107 + 1314)))) then
								local v171 = 0 + 0;
								local v172;
								while true do
									if (((11231 - 7545) > (1348 + 1824)) and ((0 - 0) == v171)) then
										v172 = v105();
										if (v172 or ((17701 - 13227) < (2730 - (716 + 1194)))) then
											return v172;
										end
										break;
									end
								end
							end
							v166 = 1 + 0;
						end
						if (((459 + 3820) >= (3385 - (74 + 429))) and (v166 == (9 - 4))) then
							if ((v51.MaleficRapture:IsReady() and ((v71 > (2 + 2)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (2 - 1)) and (v71 > (3 + 0))) or (v51.TormentedCrescendo:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v17:DebuffDown(v51.DreadTouchDebuff)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (5 - 3))) or v63 or (v61 and (v71 > (2 - 1))) or (v51.TormentedCrescendo:IsAvailable() and v51.Nightfall:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v13:BuffUp(v51.NightfallBuff)))) or ((2462 - (279 + 154)) >= (4299 - (454 + 324)))) then
								if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(79 + 21)) or ((2054 - (12 + 5)) >= (2503 + 2139))) then
									return "malefic_rapture main 28";
								end
							end
							if (((4382 - 2662) < (1648 + 2810)) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (1141 - (277 + 816))) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (85 - 65)) and (v73 < (1187 - (1058 + 125)))))) then
								if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((82 + 354) > (3996 - (815 + 160)))) then
									return "drain_life main 30";
								end
							end
							if (((3059 - 2346) <= (2010 - 1163)) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
								if (((514 + 1640) <= (11783 - 7752)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
									return "drain_soul main 32";
								end
							end
							if (((6513 - (41 + 1857)) == (6508 - (1222 + 671))) and v51.ShadowBolt:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
								if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((9795 - 6005) == (718 - 218))) then
									return "shadow_bolt main 34";
								end
							end
							v166 = 1188 - (229 + 953);
						end
						if (((1863 - (1111 + 663)) < (1800 - (874 + 705))) and ((1 + 3) == v166)) then
							if (((1402 + 652) >= (2953 - 1532)) and v51.SiphonLife:IsCastable() and v17:DebuffRefreshable(v51.SiphonLifeDebuff) and (v73 > (1 + 4))) then
								if (((1371 - (642 + 37)) < (698 + 2360)) and v24(v51.SiphonLife, nil, nil, not v17:IsSpellInRange(v51.SiphonLife))) then
									return "siphon_life main 20";
								end
							end
							if ((v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (1 + 2))) and v59 and v60 and v62) or ((8169 - 4915) == (2109 - (233 + 221)))) then
								if (v24(v51.SummonDarkglare, v47) or ((2996 - 1700) == (4322 + 588))) then
									return "summon_darkglare main 22";
								end
							end
							if (((4909 - (718 + 823)) == (2120 + 1248)) and v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (808 - (266 + 539))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (8 - 5)))) then
								if (((3868 - (636 + 589)) < (9055 - 5240)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
									return "drain_soul main 24";
								end
							end
							if (((3945 - 2032) > (391 + 102)) and v51.ShadowBolt:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (2 + 1)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1018 - (657 + 358))))) then
								if (((12590 - 7835) > (7809 - 4381)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
									return "shadow_bolt main 26";
								end
							end
							v166 = 1192 - (1151 + 36);
						end
						if (((1334 + 47) <= (623 + 1746)) and ((8 - 5) == v166)) then
							if ((v51.Agony:IsCastable() and (not v51.VileTaint:IsAvailable() or (v17:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime()))) and (v17:DebuffRemains(v51.AgonyDebuff) < (1837 - (1552 + 280))) and (v73 > (839 - (64 + 770)))) or ((3289 + 1554) == (9270 - 5186))) then
								if (((829 + 3840) > (1606 - (157 + 1086))) and v24(v51.Agony, nil, nil, not v17:IsSpellInRange(v51.Agony))) then
									return "agony main 12";
								end
							end
							if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (10 - 5)) and (v73 > (13 - 10))) or ((2879 - 1002) >= (4282 - 1144))) then
								if (((5561 - (599 + 220)) >= (7220 - 3594)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
									return "unstable_affliction main 14";
								end
							end
							if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1936 - (1813 + 118)))) or ((3319 + 1221) == (2133 - (841 + 376)))) then
								if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((1619 - 463) > (1010 + 3335))) then
									return "haunt main 16";
								end
							end
							if (((6105 - 3868) < (5108 - (464 + 395))) and v51.Corruption:IsCastable() and v17:DebuffRefreshable(v51.CorruptionDebuff) and (v73 > (12 - 7))) then
								if (v24(v51.Corruption, nil, nil, not v17:IsSpellInRange(v51.Corruption)) or ((1289 + 1394) < (860 - (467 + 370)))) then
									return "corruption main 18";
								end
							end
							v166 = 8 - 4;
						end
						if (((512 + 185) <= (2831 - 2005)) and ((1 + 1) == v166)) then
							if (((2570 - 1465) <= (1696 - (150 + 370))) and v51.MaleficRapture:IsReady() and (v73 < (1286 - (74 + 1208)))) then
								if (((8310 - 4931) <= (18078 - 14266)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(72 + 28))) then
									return "malefic_rapture main 4";
								end
							end
							if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (391.5 - (14 + 376))) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (20 - 8))))) or ((510 + 278) >= (1420 + 196))) then
								if (((1769 + 85) <= (9900 - 6521)) and v24(v55.VileTaintCursor, v45, nil, not v17:IsInRange(31 + 9))) then
									return "vile_taint main 6";
								end
							end
							if (((4627 - (23 + 55)) == (10780 - 6231)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (17 + 8))))) and v17:DebuffUp(v51.AgonyDebuff)) then
								if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((2714 + 308) >= (4688 - 1664))) then
									return "phantom_singularity main 8";
								end
							end
							if (((1517 + 3303) > (3099 - (652 + 249))) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (2 - 1))) and v17:DebuffUp(v51.AgonyDebuff)) then
								if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((2929 - (708 + 1160)) >= (13276 - 8385))) then
									return "soul_rot main 10";
								end
							end
							v166 = 5 - 2;
						end
						if (((1391 - (10 + 17)) <= (1005 + 3468)) and ((1733 - (1400 + 332)) == v166)) then
							if ((v58 > (3 - 1)) or ((5503 - (242 + 1666)) <= (2 + 1))) then
								local v173 = 0 + 0;
								local v174;
								while true do
									if ((v173 == (0 + 0)) or ((5612 - (850 + 90)) == (6746 - 2894))) then
										v174 = v104();
										if (((2949 - (360 + 1030)) == (1380 + 179)) and v174) then
											return v174;
										end
										break;
									end
								end
							end
							if (v23() or ((4944 - 3192) <= (1083 - 295))) then
								local v175 = 1661 - (909 + 752);
								local v176;
								while true do
									if ((v175 == (1223 - (109 + 1114))) or ((7152 - 3245) == (69 + 108))) then
										v176 = v103();
										if (((3712 - (6 + 236)) > (350 + 205)) and v176) then
											return v176;
										end
										break;
									end
								end
							end
							if (v33 or ((783 + 189) == (1521 - 876))) then
								local v177 = 0 - 0;
								local v178;
								while true do
									if (((4315 - (1076 + 57)) >= (348 + 1767)) and (v177 == (689 - (579 + 110)))) then
										v178 = v102();
										if (((308 + 3585) < (3916 + 513)) and v178) then
											return v178;
										end
										break;
									end
								end
							end
							if ((v51.MaleficRapture:IsReady() and v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or ((3274 - (174 + 233)) < (5321 - 3416))) then
								if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(175 - 75)) or ((799 + 997) >= (5225 - (663 + 511)))) then
									return "malefic_rapture main 2";
								end
							end
							v166 = 2 + 0;
						end
						if (((352 + 1267) <= (11579 - 7823)) and (v166 == (4 + 2))) then
							if (((1421 - 817) == (1461 - 857)) and v51.DrainSoul:IsReady()) then
								if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((2140 + 2344) == (1751 - 851))) then
									return "drain_soul main 36";
								end
							end
							if (v51.ShadowBolt:IsReady() or ((3178 + 1281) <= (102 + 1011))) then
								if (((4354 - (478 + 244)) > (3915 - (440 + 77))) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
									return "shadow_bolt main 38";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1856 + 2226) <= (17996 - 13079)) and ((1556 - (655 + 901)) == v144)) then
				v48();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v144 = 1 + 0;
			end
			if (((3700 + 1132) >= (936 + 450)) and (v144 == (15 - 11))) then
				v69 = v28(v67 * v26(v51.VileTaint:IsAvailable()), v68 * v26(v51.PhantomSingularity:IsAvailable()));
				v74 = v13:GCD() + (1445.25 - (695 + 750));
				if (((467 - 330) == (211 - 74)) and v51.SummonPet:IsCastable() and v43 and not v16:IsActive()) then
					if (v25(v51.SummonPet) or ((6314 - 4744) >= (4683 - (285 + 66)))) then
						return "summon_pet ooc";
					end
				end
				v144 = 11 - 6;
			end
			if ((v144 == (1313 - (682 + 628))) or ((656 + 3408) <= (2118 - (176 + 123)))) then
				v66 = v75(v57, v51.AgonyDebuff);
				v67 = v75(v57, v51.VileTaintDebuff);
				v68 = v75(v57, v51.PhantomSingularityDebuff);
				v144 = 2 + 2;
			end
			if ((v144 == (2 + 0)) or ((5255 - (239 + 30)) < (428 + 1146))) then
				if (((4255 + 171) > (303 - 131)) and v30) then
					v58 = v17:GetEnemiesInSplashRangeCount(31 - 21);
				else
					v58 = 316 - (306 + 9);
				end
				if (((2044 - 1458) > (80 + 375)) and (v49.TargetIsValid() or v13:AffectingCombat())) then
					v72 = v10.BossFightRemains(nil, true);
					v73 = v72;
					if (((507 + 319) == (398 + 428)) and (v73 == (31773 - 20662))) then
						v73 = v10.FightRemains(v57, false);
					end
				end
				v71 = v13:SoulShardsP();
				v144 = 1378 - (1140 + 235);
			end
			if ((v144 == (1 + 0)) or ((3686 + 333) > (1140 + 3301))) then
				v31 = EpicSettings.Toggles['cds'];
				v56 = v13:GetEnemiesInRange(92 - (33 + 19));
				v57 = v17:GetEnemiesInSplashRange(4 + 6);
				v144 = 5 - 3;
			end
		end
	end
	local function v107()
		v10.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
		v51.AgonyDebuff:RegisterAuraTracking();
		v51.SiphonLifeDebuff:RegisterAuraTracking();
		v51.CorruptionDebuff:RegisterAuraTracking();
		v51.UnstableAfflictionDebuff:RegisterAuraTracking();
	end
	v10.SetAPL(117 + 148, v106, v107);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

