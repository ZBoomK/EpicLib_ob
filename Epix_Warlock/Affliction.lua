local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1189 - (645 + 522)) <= (4045 - (1010 + 780))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((5173 - 4087) >= (4117 - 2712))) then
				return v1(v4, ...);
			end
			v5 = 1837 - (1045 + 791);
		end
		if ((v5 == (2 - 1)) or ((3616 - 1247) == (931 - (351 + 154)))) then
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
		local v95 = 1574 - (1281 + 293);
		while true do
			if ((v95 == (268 - (28 + 238))) or ((6872 - 3796) > (4742 - (1381 + 178)))) then
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v95 = 10 - 7;
			end
			if (((623 + 579) > (1528 - (381 + 89))) and (v95 == (0 + 0))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v95 = 1 + 0;
			end
			if (((6356 - 2645) > (4511 - (1074 + 82))) and (v95 == (6 - 3))) then
				v41 = EpicSettings.Settings['InterruptThreshold'] or (1784 - (214 + 1570));
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (1455 - (990 + 465));
				v95 = 2 + 2;
			end
			if ((v95 == (2 + 2)) or ((882 + 24) >= (8772 - 6543))) then
				v45 = EpicSettings.Settings['VileTaint'];
				v46 = EpicSettings.Settings['PhantomSingularity'];
				v47 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if (((3014 - (1668 + 58)) > (1877 - (512 + 114))) and (v95 == (2 - 1))) then
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v95 = 1 + 1;
			end
		end
	end
	local v49 = v20.Commons.Everyone;
	local v50 = v18.Warlock.Affliction;
	local v51 = v19.Warlock.Affliction;
	local v52 = {v51.ConjuredChillglobe:ID(),v51.DesperateInvokersCodex:ID(),v51.BelorrelostheSuncaller:ID()};
	local v53 = v13:GetEquipment();
	local v54 = (v53[2007 - (109 + 1885)] and v19(v53[1482 - (1269 + 200)])) or v19(0 - 0);
	local v55 = (v53[829 - (98 + 717)] and v19(v53[840 - (802 + 24)])) or v19(0 - 0);
	local v56 = v22.Warlock.Affliction;
	local v57, v58, v59;
	local v60, v61, v62, v63, v64, v65, v66;
	local v67;
	local v68;
	local v69 = 14032 - 2921;
	local v70 = 1641 + 9470;
	v10:RegisterForEvent(function()
		v50.SeedofCorruption:RegisterInFlight();
		v50.ShadowBolt:RegisterInFlight();
		v50.Haunt:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v50.SeedofCorruption:RegisterInFlight();
	v50.ShadowBolt:RegisterInFlight();
	v50.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v96 = 0 + 0;
		while true do
			if (((1 + 0) == v96) or ((974 + 3539) < (9324 - 5972))) then
				v55 = (v53[46 - 32] and v19(v53[6 + 8])) or v19(0 + 0);
				break;
			end
			if ((v96 == (0 + 0)) or ((1502 + 563) >= (1493 + 1703))) then
				v53 = v13:GetEquipment();
				v54 = (v53[1446 - (797 + 636)] and v19(v53[63 - 50])) or v19(1619 - (1427 + 192));
				v96 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v97 = 0 - 0;
		while true do
			if ((v97 == (0 + 0)) or ((1984 + 2392) <= (1807 - (192 + 134)))) then
				v69 = 12387 - (316 + 960);
				v70 = 6184 + 4927;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v71(v98)
		local v99 = 0 + 0;
		local v100;
		while true do
			if ((v99 == (1 + 0)) or ((12967 - 9575) >= (5292 - (83 + 468)))) then
				return v100 or (1806 - (1202 + 604));
			end
			if (((15521 - 12196) >= (3584 - 1430)) and (v99 == (0 - 0))) then
				v100 = nil;
				for v140, v141 in pairs(v98) do
					local v142 = v141:DebuffRemains(v50.AgonyDebuff) + ((424 - (45 + 280)) * v27(v141:DebuffDown(v50.AgonyDebuff)));
					if ((v100 == nil) or (v142 < v100) or ((1250 + 45) >= (2825 + 408))) then
						v100 = v142;
					end
				end
				v99 = 1 + 0;
			end
		end
	end
	local function v72(v101)
		if (((2423 + 1954) > (289 + 1353)) and (v50.SeedofCorruption:InFlight() or v13:PrevGCDP(1 - 0, v50.SeedofCorruption))) then
			return false;
		end
		local v102 = 1911 - (340 + 1571);
		local v103 = 0 + 0;
		for v124, v125 in pairs(v101) do
			v102 = v102 + (1773 - (1733 + 39));
			if (((12978 - 8255) > (2390 - (125 + 909))) and v125:DebuffUp(v50.SeedofCorruptionDebuff)) then
				v103 = v103 + (1949 - (1096 + 852));
			end
		end
		return v102 == v103;
	end
	local function v73(v104)
		return (v104:DebuffRemains(v50.AgonyDebuff));
	end
	local function v74(v105)
		return (v105:DebuffRemains(v50.CorruptionDebuff));
	end
	local function v75(v106)
		return (v106:DebuffRemains(v50.SiphonLifeDebuff));
	end
	local function v76(v107)
		return (v107:DebuffRemains(v50.AgonyDebuff) < (v107:DebuffRemains(v50.VileTaintDebuff) + v50.VileTaint:CastTime())) and (v107:DebuffRemains(v50.AgonyDebuff) < (3 + 2));
	end
	local function v77(v108)
		return v108:DebuffRemains(v50.AgonyDebuff) < (6 - 1);
	end
	local function v78(v109)
		return v109:DebuffRemains(v50.CorruptionDebuff) < (5 + 0);
	end
	local function v79(v110)
		return (v110:DebuffRefreshable(v50.SiphonLifeDebuff));
	end
	local function v80(v111)
		return v111:DebuffRemains(v50.AgonyDebuff) < (517 - (409 + 103));
	end
	local function v81(v112)
		return (v112:DebuffRefreshable(v50.AgonyDebuff));
	end
	local function v82(v113)
		return v113:DebuffRemains(v50.CorruptionDebuff) < (241 - (46 + 190));
	end
	local function v83(v114)
		return (v114:DebuffRefreshable(v50.CorruptionDebuff));
	end
	local function v84(v115)
		return (v115:DebuffStack(v50.ShadowEmbraceDebuff) < (98 - (51 + 44))) or (v115:DebuffRemains(v50.ShadowEmbraceDebuff) < (1 + 2));
	end
	local function v85(v116)
		return v116:DebuffRemains(v50.SiphonLifeDebuff) < (1322 - (1114 + 203));
	end
	local function v86()
		if (v50.GrimoireofSacrifice:IsCastable() or ((4862 - (228 + 498)) <= (744 + 2689))) then
			if (((2346 + 1899) <= (5294 - (174 + 489))) and v26(v50.GrimoireofSacrifice)) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (((11140 - 6864) >= (5819 - (830 + 1075))) and v50.Haunt:IsReady()) then
			if (((722 - (303 + 221)) <= (5634 - (231 + 1038))) and v26(v50.Haunt, not v17:IsSpellInRange(v50.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if (((3985 + 797) > (5838 - (171 + 991))) and v50.UnstableAffliction:IsReady() and not v50.SoulSwap:IsAvailable()) then
			if (((20045 - 15181) > (5899 - 3702)) and v26(v50.UnstableAffliction, not v17:IsSpellInRange(v50.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (v50.ShadowBolt:IsReady() or ((9233 - 5533) == (2007 + 500))) then
			if (((15682 - 11208) >= (790 - 516)) and v26(v50.ShadowBolt, not v17:IsSpellInRange(v50.ShadowBolt), true)) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v87()
		local v117 = 0 - 0;
		while true do
			if ((v117 == (3 - 2)) or ((3142 - (111 + 1137)) <= (1564 - (91 + 67)))) then
				v62 = v17:DebuffUp(v50.VileTaintDebuff) or v17:DebuffUp(v50.PhantomSingularityDebuff) or (not v50.VileTaint:IsAvailable() and not v50.PhantomSingularity:IsAvailable());
				v63 = v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable();
				v117 = 5 - 3;
			end
			if (((393 + 1179) >= (2054 - (423 + 100))) and (v117 == (1 + 1))) then
				v64 = v60 and v61 and v63;
				v65 = v50.PhantomSingularity:IsAvailable() or v50.VileTaint:IsAvailable() or v50.SoulRot:IsAvailable() or v50.SummonDarkglare:IsAvailable();
				v117 = 7 - 4;
			end
			if ((v117 == (2 + 1)) or ((5458 - (326 + 445)) < (19821 - 15279))) then
				v66 = not v65 or (v10.GuardiansTable.DarkglareDuration > (0 - 0)) or (v64 and (v50.SummonDarkglare:CooldownRemains() > (46 - 26))) or v13:PowerInfusionUp();
				break;
			end
			if (((4002 - (530 + 181)) > (2548 - (614 + 267))) and (v117 == (32 - (19 + 13)))) then
				v60 = v17:DebuffUp(v50.PhantomSingularityDebuff) or not v50.PhantomSingularity:IsAvailable();
				v61 = v17:DebuffUp(v50.VileTaintDebuff) or not v50.VileTaint:IsAvailable();
				v117 = 1 - 0;
			end
		end
	end
	local function v88()
		ShouldReturn = v49.HandleTopTrinket(v52, v31, 93 - 53, nil);
		if (ShouldReturn or ((2493 - 1620) == (529 + 1505))) then
			return ShouldReturn;
		end
		ShouldReturn = v49.HandleBottomTrinket(v52, v31, 70 - 30, nil);
		if (ShouldReturn or ((5839 - 3023) < (1823 - (1293 + 519)))) then
			return ShouldReturn;
		end
	end
	local function v89()
		local v118 = v88();
		if (((7546 - 3847) < (12287 - 7581)) and v118) then
			return v118;
		end
		if (((5059 - 2413) >= (3777 - 2901)) and v51.DesperateInvokersCodex:IsEquippedAndReady()) then
			if (((1446 - 832) <= (1687 + 1497)) and v26(v56.DesperateInvokersCodex, not v17:IsInRange(10 + 35))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (((7262 - 4136) == (723 + 2403)) and v51.ConjuredChillglobe:IsEquippedAndReady()) then
			if (v26(v56.ConjuredChillglobe) or ((727 + 1460) >= (3096 + 1858))) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v90()
		if (v66 or ((4973 - (709 + 387)) == (5433 - (673 + 1185)))) then
			local v127 = 0 - 0;
			local v128;
			while true do
				if (((2269 - 1562) > (1039 - 407)) and (v127 == (0 + 0))) then
					v128 = v49.HandleDPSPotion();
					if (v128 or ((408 + 138) >= (3623 - 939))) then
						return v128;
					end
					v127 = 1 + 0;
				end
				if (((2921 - 1456) <= (8442 - 4141)) and (v127 == (1881 - (446 + 1434)))) then
					if (((2987 - (1040 + 243)) > (4253 - 2828)) and v50.Berserking:IsCastable()) then
						if (v26(v50.Berserking) or ((2534 - (559 + 1288)) == (6165 - (609 + 1322)))) then
							return "berserking ogcd 4";
						end
					end
					if (v50.BloodFury:IsCastable() or ((3784 - (13 + 441)) < (5339 - 3910))) then
						if (((3004 - 1857) >= (1668 - 1333)) and v26(v50.BloodFury)) then
							return "blood_fury ogcd 6";
						end
					end
					v127 = 1 + 1;
				end
				if (((12475 - 9040) > (745 + 1352)) and (v127 == (1 + 1))) then
					if (v50.Fireblood:IsCastable() or ((11187 - 7417) >= (2212 + 1829))) then
						if (v26(v50.Fireblood) or ((6972 - 3181) <= (1066 + 545))) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
			end
		end
	end
	local function v91()
		local v119 = 0 + 0;
		local v120;
		while true do
			if ((v119 == (0 + 0)) or ((3844 + 734) <= (1965 + 43))) then
				if (((1558 - (153 + 280)) <= (5994 - 3918)) and v31) then
					local v143 = v90();
					if (v143 or ((668 + 75) >= (1737 + 2662))) then
						return v143;
					end
				end
				v120 = v89();
				if (((605 + 550) < (1519 + 154)) and v120) then
					return v120;
				end
				v67 = v71(v58);
				v119 = 1 + 0;
			end
			if ((v119 == (2 - 0)) or ((1437 + 887) <= (1245 - (89 + 578)))) then
				if (((2692 + 1075) == (7831 - 4064)) and v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (1055 - (572 + 477))) and v50.SummonDarkglare:CooldownUp()) then
					if (((552 + 3537) == (2454 + 1635)) and v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife))) then
						return "siphon_life aoe 10";
					end
				end
				if (((533 + 3925) >= (1760 - (84 + 2))) and v50.SoulRot:IsReady() and v61 and v60) then
					if (((1601 - 629) <= (1022 + 396)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return "soul_rot aoe 12";
					end
				end
				if ((v50.SeedofCorruption:IsReady() and (v17:DebuffRemains(v50.CorruptionDebuff) < (847 - (497 + 345))) and not (v50.SeedofCorruption:InFlight() or v17:DebuffUp(v50.SeedofCorruptionDebuff))) or ((127 + 4811) < (805 + 3957))) then
					if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or ((3837 - (605 + 728)) > (3043 + 1221))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if (((4786 - 2633) == (99 + 2054)) and v50.Agony:IsReady() and (v50.AgonyDebuff:AuraActiveCount() < (29 - 21))) then
					if (v49.CastTargetIf(v50.Agony, v57, "min", v73, v76, not v17:IsSpellInRange(v50.Agony)) or ((458 + 49) >= (7178 - 4587))) then
						return "agony aoe 16";
					end
				end
				v119 = 3 + 0;
			end
			if (((4970 - (457 + 32)) == (1902 + 2579)) and (v119 == (1406 - (832 + 570)))) then
				if ((v50.DrainLife:IsReady() and (v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable()) and (v13:BuffStack(v50.InevitableDemiseBuff) > (10 + 0))) or ((608 + 1720) < (2452 - 1759))) then
					if (((2085 + 2243) == (5124 - (588 + 208))) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return "drain_life aoe 26";
					end
				end
				if (((4279 - 2691) >= (3132 - (884 + 916))) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) then
					if (v49.CastCycle(v50.DrainSoul, v57, v84, not v17:IsSpellInRange(v50.DrainSoul)) or ((8738 - 4564) > (2464 + 1784))) then
						return "drain_soul aoe 28";
					end
				end
				if ((v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) or ((5239 - (232 + 421)) <= (1971 - (1569 + 320)))) then
					if (((948 + 2915) == (734 + 3129)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
						return "drain_soul aoe 30";
					end
				end
				if ((v50.SummonSoulkeeper:IsReady() and ((v50.SummonSoulkeeper:Count() == (33 - 23)) or ((v50.SummonSoulkeeper:Count() > (608 - (316 + 289))) and (v70 < (26 - 16))))) or ((14 + 268) <= (1495 - (666 + 787)))) then
					if (((5034 - (360 + 65)) >= (716 + 50)) and v25(v50.SummonSoulkeeper)) then
						return "soul_strike aoe 32";
					end
				end
				v119 = 259 - (79 + 175);
			end
			if ((v119 == (7 - 2)) or ((899 + 253) == (7626 - 5138))) then
				if (((6589 - 3167) > (4249 - (503 + 396))) and v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (186 - (92 + 89)))) then
					if (((1701 - 824) > (193 + 183)) and v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife))) then
						return "siphon_life aoe 34";
					end
				end
				if (v50.DrainSoul:IsReady() or ((1846 + 1272) <= (7248 - 5397))) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((23 + 142) >= (7961 - 4469))) then
						return "drain_soul aoe 36";
					end
				end
				if (((3446 + 503) < (2320 + 2536)) and v50.ShadowBolt:IsReady()) then
					if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((13023 - 8747) < (377 + 2639))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if (((7152 - 2462) > (5369 - (485 + 759))) and (v119 == (2 - 1))) then
				if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (1192 - (442 + 747)))) or ((1185 - (832 + 303)) >= (1842 - (88 + 858)))) then
					if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((523 + 1191) >= (2449 + 509))) then
						return "haunt aoe 2";
					end
				end
				if ((v50.VileTaint:IsReady() and (((v50.SouleatersGluttony:TalentRank() == (1 + 1)) and ((v67 < (790.5 - (766 + 23))) or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()))) or ((v50.SouleatersGluttony:TalentRank() == (4 - 3)) and (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime())) or (not v50.SouleatersGluttony:IsAvailable() and ((v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (v50.VileTaint:CooldownRemains() > (33 - 8)))))) or ((3928 - 2437) < (2185 - 1541))) then
					if (((1777 - (1036 + 37)) < (700 + 287)) and v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(77 - 37))) then
						return "vile_taint aoe 4";
					end
				end
				if (((2925 + 793) > (3386 - (641 + 839))) and v50.PhantomSingularity:IsCastable()) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((1871 - (910 + 3)) > (9266 - 5631))) then
						return "phantom_singularity aoe 6";
					end
				end
				if (((5185 - (1466 + 218)) <= (2065 + 2427)) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (1153 - (556 + 592)))) then
					if (v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction)) or ((1224 + 2218) < (3356 - (329 + 479)))) then
						return "unstable_affliction aoe 8";
					end
				end
				v119 = 856 - (174 + 680);
			end
			if (((9879 - 7004) >= (3034 - 1570)) and (v119 == (3 + 0))) then
				if ((v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) or ((5536 - (396 + 343)) >= (433 + 4460))) then
					if (v25(v50.SummonDarkglare, v47) or ((2028 - (29 + 1448)) > (3457 - (135 + 1254)))) then
						return "summon_darkglare aoe 18";
					end
				end
				if (((7963 - 5849) > (4407 - 3463)) and v50.MaleficRapture:IsReady() and (v13:BuffUp(v50.UmbrafireKindlingBuff))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(67 + 33)) or ((3789 - (389 + 1138)) >= (3670 - (102 + 472)))) then
						return "malefic_rapture aoe 20";
					end
				end
				if ((v50.SeedofCorruption:IsReady() and v50.SowTheSeeds:IsAvailable()) or ((2129 + 126) >= (1962 + 1575))) then
					if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or ((3578 + 259) < (2851 - (320 + 1225)))) then
						return "seed_of_corruption aoe 22";
					end
				end
				if (((5251 - 2301) == (1805 + 1145)) and v50.MaleficRapture:IsReady() and ((((v50.SummonDarkglare:CooldownRemains() > (1479 - (157 + 1307))) or (v68 > (1862 - (821 + 1038)))) and not v50.SowTheSeeds:IsAvailable()) or v13:BuffUp(v50.TormentedCrescendoBuff))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(249 - 149)) or ((517 + 4206) < (5857 - 2559))) then
						return "malefic_rapture aoe 24";
					end
				end
				v119 = 2 + 2;
			end
		end
	end
	local function v92()
		local v121 = 0 - 0;
		local v122;
		while true do
			if (((2162 - (834 + 192)) >= (10 + 144)) and (v121 == (1 + 0))) then
				if ((v50.MaleficRapture:IsReady() and ((v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (1 + 1)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) or (v68 > (5 - 1)) or v13:BuffUp(v50.UmbrafireKindlingBuff))) or ((575 - (300 + 4)) > (1269 + 3479))) then
					if (((12408 - 7668) >= (3514 - (112 + 250))) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(40 + 60))) then
						return "malefic_rapture cleave 4";
					end
				end
				if (v50.Agony:IsReady() or ((6458 - 3880) >= (1943 + 1447))) then
					if (((22 + 19) <= (1243 + 418)) and v49.CastTargetIf(v50.Agony, v57, "min", v73, v77, not v17:IsSpellInRange(v50.Agony))) then
						return "agony cleave 6";
					end
				end
				if (((298 + 303) < (2645 + 915)) and v50.SoulRot:IsReady() and v61 and v60) then
					if (((1649 - (1001 + 413)) < (1531 - 844)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				if (((5431 - (244 + 638)) > (1846 - (627 + 66))) and v50.VileTaint:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (5 - 3)) and (v50.CorruptionDebuff:AuraActiveCount() == (604 - (512 + 90))) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (1908 - (1665 + 241)))) and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (729 - (373 + 344)))))) then
					if (v25(v56.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v50.VileTaint)) or ((2109 + 2565) < (1237 + 3435))) then
						return "vile_taint cleave 10";
					end
				end
				v121 = 5 - 3;
			end
			if (((6206 - 2538) < (5660 - (35 + 1064))) and (v121 == (4 + 1))) then
				if ((v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) or ((973 - 518) == (15 + 3590))) then
					if (v49.CastCycle(v50.DrainSoul, v57, EvaluatecycleDrainSoul, not v17:IsSpellInRange(v50.DrainSoul)) or ((3899 - (298 + 938)) == (4571 - (233 + 1026)))) then
						return "drain_soul cleave 36";
					end
				end
				if (((5943 - (636 + 1030)) <= (2288 + 2187)) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff)) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((850 + 20) == (354 + 835))) then
						return "drain_soul cleave 38";
					end
				end
				if (((105 + 1448) <= (3354 - (55 + 166))) and v50.ShadowBolt:IsReady() and v13:BuffUp(v50.NightfallBuff)) then
					if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((434 + 1803) >= (354 + 3157))) then
						return "shadow_bolt cleave 40";
					end
				end
				if ((v50.MaleficRapture:IsReady() and (v68 > (11 - 8))) or ((1621 - (36 + 261)) > (5281 - 2261))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(1468 - (34 + 1334))) or ((1151 + 1841) == (1462 + 419))) then
						return "malefic_rapture cleave 42";
					end
				end
				v121 = 1289 - (1035 + 248);
			end
			if (((3127 - (20 + 1)) > (796 + 730)) and (v121 == (319 - (134 + 185)))) then
				if (((4156 - (549 + 584)) < (4555 - (314 + 371))) and v31) then
					local v144 = v90();
					if (((490 - 347) > (1042 - (478 + 490))) and v144) then
						return v144;
					end
				end
				v122 = v89();
				if (((10 + 8) < (3284 - (786 + 386))) and v122) then
					return v122;
				end
				if (((3553 - 2456) <= (3007 - (1055 + 324))) and v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) then
					if (((5970 - (1093 + 247)) == (4115 + 515)) and v25(v50.SummonDarkglare, v47)) then
						return "summon_darkglare cleave 2";
					end
				end
				v121 = 1 + 0;
			end
			if (((14054 - 10514) > (9105 - 6422)) and (v121 == (8 - 5))) then
				if (((12046 - 7252) >= (1165 + 2110)) and v50.SiphonLife:IsReady()) then
					if (((5716 - 4232) == (5114 - 3630)) and v49.CastTargetIf(v50.SiphonLife, v57, "min", v75, v79, not v17:IsSpellInRange(v50.SiphonLife))) then
						return "siphon_life cleave 20";
					end
				end
				if (((1080 + 352) < (9091 - 5536)) and v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (691 - (364 + 324)))) then
					if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((2919 - 1854) > (8585 - 5007))) then
						return "haunt cleave 22";
					end
				end
				if ((v50.PhantomSingularity:IsReady() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (9 + 16)))))) or ((20063 - 15268) < (2252 - 845))) then
					if (((5627 - 3774) < (6081 - (1249 + 19))) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
						return "phantom_singularity cleave 24";
					end
				end
				if (v50.SoulRot:IsReady() or ((2547 + 274) < (9462 - 7031))) then
					if (v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot)) or ((3960 - (686 + 400)) < (1712 + 469))) then
						return "soul_rot cleave 26";
					end
				end
				v121 = 233 - (73 + 156);
			end
			if ((v121 == (1 + 3)) or ((3500 - (721 + 90)) <= (4 + 339))) then
				if ((v50.MaleficRapture:IsReady() and ((v68 > (12 - 8)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (471 - (224 + 246))) and (v68 > (4 - 1))))) or ((3440 - 1571) == (365 + 1644))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(3 + 97)) or ((2605 + 941) < (4615 - 2293))) then
						return "malefic_rapture cleave 28";
					end
				end
				if ((v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < v13:GCD())) or ((6928 - 4846) == (5286 - (203 + 310)))) then
					if (((5237 - (1238 + 755)) > (74 + 981)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(1634 - (709 + 825)))) then
						return "malefic_rapture cleave 30";
					end
				end
				if ((v50.MaleficRapture:IsReady() and not v50.DreadTouch:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff)) or ((6104 - 2791) <= (2589 - 811))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(964 - (196 + 668))) or ((5610 - 4189) >= (4357 - 2253))) then
						return "malefic_rapture cleave 32";
					end
				end
				if (((2645 - (171 + 662)) <= (3342 - (4 + 89))) and v50.MaleficRapture:IsReady() and (v64 or v62)) then
					if (((5688 - 4065) <= (713 + 1244)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(439 - 339))) then
						return "malefic_rapture cleave 34";
					end
				end
				v121 = 2 + 3;
			end
			if (((5898 - (35 + 1451)) == (5865 - (28 + 1425))) and (v121 == (1999 - (941 + 1052)))) then
				if (((1679 + 71) >= (2356 - (822 + 692))) and v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (68 - 20)) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (10 + 10)) and (v70 < (301 - (45 + 252)))))) then
					if (((4326 + 46) > (637 + 1213)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return "drain_life cleave 44";
					end
				end
				if (((564 - 332) < (1254 - (114 + 319))) and v50.DrainLife:IsReady() and v17:DebuffUp(v50.SoulRotDebuff) and (v13:BuffStack(v50.InevitableDemiseBuff) > (14 - 4))) then
					if (((663 - 145) < (576 + 326)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return "drain_life cleave 46";
					end
				end
				if (((4460 - 1466) > (1797 - 939)) and v50.Agony:IsReady()) then
					if (v49.CastCycle(v50.Agony, v57, v81, not v17:IsSpellInRange(v50.Agony)) or ((5718 - (556 + 1407)) <= (2121 - (741 + 465)))) then
						return "agony cleave 48";
					end
				end
				if (((4411 - (170 + 295)) > (1973 + 1770)) and v50.Corruption:IsCastable()) then
					if (v49.CastCycle(v50.Corruption, v57, v83, not v17:IsSpellInRange(v50.Corruption)) or ((1227 + 108) >= (8139 - 4833))) then
						return "corruption cleave 50";
					end
				end
				v121 = 6 + 1;
			end
			if (((3107 + 1737) > (1276 + 977)) and (v121 == (1237 - (957 + 273)))) then
				if (((121 + 331) == (181 + 271)) and v50.MaleficRapture:IsReady() and (v68 > (3 - 2))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(263 - 163)) or ((13918 - 9361) < (10334 - 8247))) then
						return "malefic_rapture cleave 52";
					end
				end
				if (((5654 - (389 + 1391)) == (2431 + 1443)) and v50.DrainSoul:IsReady()) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((202 + 1736) > (11235 - 6300))) then
						return "drain_soul cleave 54";
					end
				end
				if (v50.ShadowBolt:IsReady() or ((5206 - (783 + 168)) < (11488 - 8065))) then
					if (((1431 + 23) <= (2802 - (309 + 2))) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
						return "shadow_bolt cleave 56";
					end
				end
				break;
			end
			if ((v121 == (5 - 3)) or ((5369 - (1090 + 122)) <= (909 + 1894))) then
				if (((16298 - 11445) >= (2041 + 941)) and v50.PhantomSingularity:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (1120 - (628 + 490))) and (v50.CorruptionDebuff:AuraActiveCount() == (1 + 1)) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (4 - 2))) and (v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (114 - 89)))) then
					if (((4908 - (431 + 343)) > (6779 - 3422)) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
						return "phantom_singularity cleave 12";
					end
				end
				if ((v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (14 - 9))) or ((2700 + 717) < (325 + 2209))) then
					if (v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction)) or ((4417 - (556 + 1139)) <= (179 - (6 + 9)))) then
						return "unstable_affliction cleave 14";
					end
				end
				if ((v50.SeedofCorruption:IsReady() and not v50.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v50.CorruptionDebuff) < (1 + 4)) and v50.SowTheSeeds:IsAvailable() and v72()) or ((1234 + 1174) < (2278 - (28 + 141)))) then
					if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or ((13 + 20) == (1795 - 340))) then
						return "seed_of_corruption cleave 16";
					end
				end
				if (v50.Corruption:IsReady() or ((314 + 129) >= (5332 - (486 + 831)))) then
					if (((8800 - 5418) > (584 - 418)) and v49.CastTargetIf(v50.Corruption, v57, "min", v74, v78, not v17:IsSpellInRange(v50.Corruption))) then
						return "corruption cleave 18";
					end
				end
				v121 = 1 + 2;
			end
		end
	end
	local function v93()
		local v123 = 0 - 0;
		while true do
			if ((v123 == (1265 - (668 + 595))) or ((252 + 28) == (617 + 2442))) then
				if (((5129 - 3248) > (1583 - (23 + 267))) and v30) then
					v59 = v17:GetEnemiesInSplashRangeCount(1954 - (1129 + 815));
				else
					v59 = 388 - (371 + 16);
				end
				if (((4107 - (1326 + 424)) == (4464 - 2107)) and (v49.TargetIsValid() or v13:AffectingCombat())) then
					local v145 = 0 - 0;
					while true do
						if (((241 - (88 + 30)) == (894 - (720 + 51))) and (v145 == (0 - 0))) then
							v69 = v10.BossFightRemains(nil, true);
							v70 = v69;
							v145 = 1777 - (421 + 1355);
						end
						if ((v145 == (1 - 0)) or ((519 + 537) >= (4475 - (286 + 797)))) then
							if ((v70 == (40617 - 29506)) or ((1790 - 709) < (1514 - (397 + 42)))) then
								v70 = v10.FightRemains(v58, false);
							end
							break;
						end
					end
				end
				v68 = v13:SoulShardsP();
				v123 = 1 + 2;
			end
			if ((v123 == (800 - (24 + 776))) or ((1615 - 566) >= (5217 - (222 + 563)))) then
				v48();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v123 = 1 - 0;
			end
			if (((1 + 0) == v123) or ((4958 - (23 + 167)) <= (2644 - (690 + 1108)))) then
				v31 = EpicSettings.Toggles['cds'];
				v57 = v13:GetEnemiesInRange(15 + 25);
				v58 = v17:GetEnemiesInSplashRange(9 + 1);
				v123 = 850 - (40 + 808);
			end
			if ((v123 == (1 + 2)) or ((12840 - 9482) <= (1358 + 62))) then
				if ((v50.SummonPet:IsCastable() and v43 and not v16:IsActive()) or ((1979 + 1760) <= (1648 + 1357))) then
					if (v26(v50.SummonPet) or ((2230 - (47 + 524)) >= (1385 + 749))) then
						return "summon_pet ooc";
					end
				end
				if (v49.TargetIsValid() or ((8911 - 5651) < (3521 - 1166))) then
					if ((not v13:AffectingCombat() and v29) or ((1525 - 856) == (5949 - (1165 + 561)))) then
						local v146 = 0 + 0;
						local v147;
						while true do
							if ((v146 == (0 - 0)) or ((646 + 1046) < (1067 - (341 + 138)))) then
								v147 = v86();
								if (v147 or ((1295 + 3502) < (7534 - 3883))) then
									return v147;
								end
								break;
							end
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((4503 - (89 + 237)) > (15602 - 10752))) then
						local v148 = v49.Interrupt(v50.SpellLock, 84 - 44, true);
						if (v148 or ((1281 - (581 + 300)) > (2331 - (855 + 365)))) then
							return v148;
						end
						v148 = v49.Interrupt(v50.SpellLock, 95 - 55, true, v15, v56.SpellLockMouseover);
						if (((997 + 2054) > (2240 - (1030 + 205))) and v148) then
							return v148;
						end
						v148 = v49.Interrupt(v50.AxeToss, 38 + 2, true);
						if (((3436 + 257) <= (4668 - (156 + 130))) and v148) then
							return v148;
						end
						v148 = v49.Interrupt(v50.AxeToss, 90 - 50, true, v15, v56.AxeTossMouseover);
						if (v148 or ((5530 - 2248) > (8397 - 4297))) then
							return v148;
						end
						v148 = v49.InterruptWithStun(v50.AxeToss, 11 + 29, true);
						if (v148 or ((2088 + 1492) < (2913 - (10 + 59)))) then
							return v148;
						end
						v148 = v49.InterruptWithStun(v50.AxeToss, 12 + 28, true, v15, v56.AxeTossMouseover);
						if (((438 - 349) < (5653 - (671 + 492))) and v148) then
							return v148;
						end
					end
					v87();
					if (((v59 > (1 + 0)) and (v59 < (1218 - (369 + 846)))) or ((1320 + 3663) < (1543 + 265))) then
						local v149 = v92();
						if (((5774 - (1036 + 909)) > (2997 + 772)) and v149) then
							return v149;
						end
					end
					if (((2493 - 1008) <= (3107 - (11 + 192))) and (v59 > (2 + 0))) then
						local v150 = v91();
						if (((4444 - (135 + 40)) == (10343 - 6074)) and v150) then
							return v150;
						end
					end
					if (((234 + 153) <= (6128 - 3346)) and v24()) then
						local v151 = v90();
						if (v151 or ((2846 - 947) <= (1093 - (50 + 126)))) then
							return v151;
						end
					end
					if (v33 or ((12006 - 7694) <= (194 + 682))) then
						local v152 = 1413 - (1233 + 180);
						local v153;
						while true do
							if (((3201 - (522 + 447)) <= (4017 - (107 + 1314))) and (v152 == (0 + 0))) then
								v153 = v89();
								if (((6383 - 4288) < (1566 + 2120)) and v153) then
									return v153;
								end
								break;
							end
						end
					end
					if ((v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (3 - 1)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) or ((6310 - 4715) >= (6384 - (716 + 1194)))) then
						if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(2 + 98)) or ((495 + 4124) < (3385 - (74 + 429)))) then
							return "malefic_rapture main 2";
						end
					end
					if ((v50.SummonDarkglare:IsReady() and v60 and v61 and v63) or ((566 - 272) >= (2395 + 2436))) then
						if (((4644 - 2615) <= (2182 + 902)) and v25(v50.SummonDarkglare, v47)) then
							return "summon_darkglare main 4";
						end
					end
					if ((v50.Agony:IsCastable() and (v17:DebuffRemains(v50.AgonyDebuff) < (15 - 10))) or ((5036 - 2999) == (2853 - (279 + 154)))) then
						if (((5236 - (454 + 324)) > (3072 + 832)) and v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony))) then
							return "agony main 6";
						end
					end
					if (((453 - (12 + 5)) >= (67 + 56)) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (12 - 7))) then
						if (((185 + 315) < (2909 - (277 + 816))) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
							return "unstable_affliction main 8";
						end
					end
					if (((15271 - 11697) == (4757 - (1058 + 125))) and v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) then
						if (((42 + 179) < (1365 - (815 + 160))) and v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption))) then
							return "corruption main 10";
						end
					end
					if ((v50.SiphonLife:IsCastable() and (v17:DebuffRefreshable(v50.SiphonLifeDebuff))) or ((9495 - 7282) <= (3373 - 1952))) then
						if (((730 + 2328) < (14206 - 9346)) and v25(v50.SiphonLife, nil, nil, not v17:IsSpellInRange(v50.SiphonLife))) then
							return "siphon_life main 12";
						end
					end
					if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (1901 - (41 + 1857)))) or ((3189 - (1222 + 671)) >= (11490 - 7044))) then
						if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((2001 - 608) > (5671 - (229 + 953)))) then
							return "haunt main 14";
						end
					end
					if ((v50.DrainSoul:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (1777 - (1111 + 663))) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (1582 - (874 + 705))))) or ((620 + 3804) < (19 + 8))) then
						if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((4150 - 2153) > (108 + 3707))) then
							return "drain_soul main 16";
						end
					end
					if (((4144 - (642 + 37)) > (437 + 1476)) and v50.ShadowBolt:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (1 + 2)) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (7 - 4)))) then
						if (((1187 - (233 + 221)) < (4206 - 2387)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
							return "shadow_bolt main 18";
						end
					end
					if ((v50.PhantomSingularity:IsCastable() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (23 + 2)))))) or ((5936 - (718 + 823)) == (2993 + 1762))) then
						if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((4598 - (266 + 539)) < (6706 - 4337))) then
							return "phantom_singularity main 20";
						end
					end
					if ((v50.VileTaint:IsReady() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (1237 - (636 + 589)))))) or ((9693 - 5609) == (546 - 281))) then
						if (((3454 + 904) == (1584 + 2774)) and v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(1055 - (657 + 358)))) then
							return "vile_taint main 22";
						end
					end
					if ((v50.SoulRot:IsReady() and v61 and (v60 or (v50.SouleatersGluttony:TalentRank() ~= (2 - 1)))) or ((7149 - 4011) < (2180 - (1151 + 36)))) then
						if (((3216 + 114) > (611 + 1712)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
							return "soul_rot main 24";
						end
					end
					if ((v50.MaleficRapture:IsReady() and ((v68 > (11 - 7)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (1833 - (1552 + 280))) and (v68 > (837 - (64 + 770)))) or (v50.TormentedCrescendo:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v17:DebuffDown(v50.DreadTouchDebuff)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (2 + 0))) or v64 or (v62 and (v68 > (2 - 1))) or (v50.TormentedCrescendo:IsAvailable() and v50.Nightfall:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v13:BuffUp(v50.NightfallBuff)))) or ((644 + 2982) == (5232 - (157 + 1086)))) then
						if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(200 - 100)) or ((4011 - 3095) == (4096 - 1425))) then
							return "malefic_rapture main 26";
						end
					end
					if (((370 - 98) == (1091 - (599 + 220))) and v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (95 - 47)) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (1951 - (1813 + 118))) and (v70 < (3 + 1))))) then
						if (((5466 - (841 + 376)) <= (6779 - 1940)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
							return "drain_life main 28";
						end
					end
					if (((646 + 2131) < (8734 - 5534)) and v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
						if (((954 - (464 + 395)) < (5022 - 3065)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
							return "drain_soul main 30";
						end
					end
					if (((397 + 429) < (2554 - (467 + 370))) and v50.ShadowBolt:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
						if (((2946 - 1520) >= (812 + 293)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
							return "shadow_bolt main 32";
						end
					end
					if (((9440 - 6686) <= (528 + 2851)) and v50.Agony:IsCastable() and (v17:DebuffRefreshable(v50.AgonyDebuff))) then
						if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or ((9136 - 5209) == (1933 - (150 + 370)))) then
							return "agony main 34";
						end
					end
					if ((v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) or ((2436 - (74 + 1208)) <= (1938 - 1150))) then
						if (v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption)) or ((7792 - 6149) > (2405 + 974))) then
							return "corruption main 36";
						end
					end
					if (v50.DrainSoul:IsReady() or ((3193 - (14 + 376)) > (7889 - 3340))) then
						if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((143 + 77) >= (2655 + 367))) then
							return "drain_soul main 40";
						end
					end
					if (((2692 + 130) == (8268 - 5446)) and v50.ShadowBolt:IsReady()) then
						if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((799 + 262) == (1935 - (23 + 55)))) then
							return "shadow_bolt main 42";
						end
					end
				end
				break;
			end
		end
	end
	local function v94()
		v20.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
	end
	v20.SetAPL(628 - 363, v93, v94);
end;
return v0["Epix_Warlock_Affliction.lua"]();

