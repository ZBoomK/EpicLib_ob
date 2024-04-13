local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((115 + 3980) >= (5489 - 2306)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warlock_Affliction.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Focus;
	local v14 = v11.MouseOver;
	local v15 = v11.Pet;
	local v16 = v11.Target;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Macro;
	local v22 = v19.AoEON;
	local v23 = v19.CDsON;
	local v24 = v19.Cast;
	local v25 = v19.Press;
	local v26 = v19.Commons.Everyone.num;
	local v27 = v19.Commons.Everyone.bool;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31;
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
	local function v47()
		local v94 = 0 - 0;
		while true do
			if ((v94 == (0 + 0)) or ((2852 + 859) < (166 + 842))) then
				v32 = EpicSettings.Settings['UseTrinkets'];
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v94 = 1 + 0;
			end
			if ((v94 == (11 - 7)) or ((3497 - 2448) <= (325 + 581))) then
				v44 = EpicSettings.Settings['VileTaint'];
				v45 = EpicSettings.Settings['PhantomSingularity'];
				v46 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if (((1838 + 2675) > (2249 + 477)) and (v94 == (2 + 0))) then
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptWithStun'] or (1433 - (797 + 636));
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v94 = 1622 - (1427 + 192);
			end
			if ((v94 == (1 + 0)) or ((3438 - 1957) >= (2390 + 268))) then
				v34 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v35 = EpicSettings.Settings['HealingPotionHP'] or (326 - (192 + 134));
				v36 = EpicSettings.Settings['UseHealthstone'];
				v94 = 1278 - (316 + 960);
			end
			if ((v94 == (2 + 1)) or ((2485 + 735) == (1261 + 103))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v42 = EpicSettings.Settings['SummonPet'];
				v43 = EpicSettings.Settings['DarkPactHP'] or (551 - (83 + 468));
				v94 = 1810 - (1202 + 604);
			end
		end
	end
	local v48 = v19.Commons.Everyone;
	local v49 = v17.Warlock.Affliction;
	local v50 = v18.Warlock.Affliction;
	local v51 = {v50.ConjuredChillglobe:ID(),v50.DesperateInvokersCodex:ID(),v50.BelorrelostheSuncaller:ID()};
	local v52 = v12:GetEquipment();
	local v53 = (v52[338 - (45 + 280)] and v18(v52[13 + 0])) or v18(0 + 0);
	local v54 = (v52[6 + 8] and v18(v52[8 + 6])) or v18(0 + 0);
	local v55 = v21.Warlock.Affliction;
	local v56, v57, v58;
	local v59, v60, v61, v62, v63, v64, v65;
	local v66;
	local v67;
	local v68 = 20574 - 9463;
	local v69 = 13022 - (340 + 1571);
	v9:RegisterForEvent(function()
		local v95 = 0 + 0;
		while true do
			if ((v95 == (1773 - (1733 + 39))) or ((2896 - 1842) > (4426 - (125 + 909)))) then
				v49.Haunt:RegisterInFlight();
				break;
			end
			if ((v95 == (1948 - (1096 + 852))) or ((304 + 372) >= (2344 - 702))) then
				v49.SeedofCorruption:RegisterInFlight();
				v49.ShadowBolt:RegisterInFlight();
				v95 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v49.SeedofCorruption:RegisterInFlight();
	v49.ShadowBolt:RegisterInFlight();
	v49.Haunt:RegisterInFlight();
	v9:RegisterForEvent(function()
		local v96 = 512 - (409 + 103);
		while true do
			if (((4372 - (46 + 190)) > (2492 - (51 + 44))) and (v96 == (0 + 0))) then
				v52 = v12:GetEquipment();
				v53 = (v52[1330 - (1114 + 203)] and v18(v52[739 - (228 + 498)])) or v18(0 + 0);
				v96 = 1 + 0;
			end
			if ((v96 == (664 - (174 + 489))) or ((11291 - 6957) == (6150 - (830 + 1075)))) then
				v54 = (v52[538 - (303 + 221)] and v18(v52[1283 - (231 + 1038)])) or v18(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v68 = 12273 - (171 + 991);
		v69 = 45790 - 34679;
	end, "PLAYER_REGEN_ENABLED");
	local function v70(v97)
		local v98;
		for v124, v125 in pairs(v97) do
			local v126 = 0 - 0;
			local v127;
			while true do
				if ((v126 == (0 - 0)) or ((3423 + 853) <= (10624 - 7593))) then
					v127 = v125:DebuffRemains(v49.AgonyDebuff) + ((285 - 186) * v26(v125:DebuffDown(v49.AgonyDebuff)));
					if ((v98 == nil) or (v127 < v98) or ((7707 - 2925) <= (3706 - 2507))) then
						v98 = v127;
					end
					break;
				end
			end
		end
		return v98 or (1248 - (111 + 1137));
	end
	local function v71(v99)
		if (v49.SeedofCorruption:InFlight() or v12:PrevGCDP(159 - (91 + 67), v49.SeedofCorruption) or ((14476 - 9612) < (475 + 1427))) then
			return false;
		end
		local v100 = 523 - (423 + 100);
		local v101 = 0 + 0;
		for v128, v129 in pairs(v99) do
			local v130 = 0 - 0;
			while true do
				if (((2523 + 2316) >= (4471 - (326 + 445))) and (v130 == (0 - 0))) then
					v100 = v100 + (2 - 1);
					if (v129:DebuffUp(v49.SeedofCorruptionDebuff) or ((2508 - 1433) > (2629 - (530 + 181)))) then
						v101 = v101 + (882 - (614 + 267));
					end
					break;
				end
			end
		end
		return v100 == v101;
	end
	local function v72(v102)
		return (v102:DebuffRemains(v49.AgonyDebuff));
	end
	local function v73(v103)
		return (v103:DebuffRemains(v49.CorruptionDebuff));
	end
	local function v74(v104)
		return (v104:DebuffRemains(v49.SiphonLifeDebuff));
	end
	local function v75(v105)
		return (v105:DebuffRemains(v49.AgonyDebuff) < (v105:DebuffRemains(v49.VileTaintDebuff) + v49.VileTaint:CastTime())) and (v105:DebuffRemains(v49.AgonyDebuff) < (37 - (19 + 13)));
	end
	local function v76(v106)
		return v106:DebuffRemains(v49.AgonyDebuff) < (7 - 2);
	end
	local function v77(v107)
		return v107:DebuffRemains(v49.CorruptionDebuff) < (11 - 6);
	end
	local function v78(v108)
		return (v108:DebuffRefreshable(v49.SiphonLifeDebuff));
	end
	local function v79(v109)
		return v109:DebuffRemains(v49.AgonyDebuff) < (14 - 9);
	end
	local function v80(v110)
		return (v110:DebuffRefreshable(v49.AgonyDebuff));
	end
	local function v81(v111)
		return v111:DebuffRemains(v49.CorruptionDebuff) < (2 + 3);
	end
	local function v82(v112)
		return (v112:DebuffRefreshable(v49.CorruptionDebuff));
	end
	local function v83(v113)
		return (v113:DebuffStack(v49.ShadowEmbraceDebuff) < (4 - 1)) or (v113:DebuffRemains(v49.ShadowEmbraceDebuff) < (6 - 3));
	end
	local function v84(v114)
		return v114:DebuffRemains(v49.SiphonLifeDebuff) < (1817 - (1293 + 519));
	end
	local function v85()
		if (((807 - 411) <= (9931 - 6127)) and v49.GrimoireofSacrifice:IsCastable()) then
			if (v25(v49.GrimoireofSacrifice) or ((7971 - 3802) == (9430 - 7243))) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (((3311 - 1905) == (745 + 661)) and v49.Haunt:IsReady()) then
			if (((313 + 1218) < (9923 - 5652)) and v25(v49.Haunt, not v16:IsSpellInRange(v49.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if (((147 + 488) == (211 + 424)) and v49.UnstableAffliction:IsReady() and not v49.SoulSwap:IsAvailable()) then
			if (((2108 + 1265) <= (4652 - (709 + 387))) and v25(v49.UnstableAffliction, not v16:IsSpellInRange(v49.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (v49.ShadowBolt:IsReady() or ((5149 - (673 + 1185)) < (9512 - 6232))) then
			if (((14084 - 9698) >= (1436 - 563)) and v25(v49.ShadowBolt, not v16:IsSpellInRange(v49.ShadowBolt), true)) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v86()
		local v115 = 0 + 0;
		while true do
			if (((689 + 232) <= (1487 - 385)) and (v115 == (1 + 2))) then
				v65 = not v64 or (v9.GuardiansTable.DarkglareDuration > (0 - 0)) or (v63 and (v49.SummonDarkglare:CooldownRemains() > (39 - 19))) or v12:PowerInfusionUp();
				break;
			end
			if (((6586 - (446 + 1434)) >= (2246 - (1040 + 243))) and ((2 - 1) == v115)) then
				v61 = v16:DebuffUp(v49.VileTaintDebuff) or v16:DebuffUp(v49.PhantomSingularityDebuff) or (not v49.VileTaint:IsAvailable() and not v49.PhantomSingularity:IsAvailable());
				v62 = v16:DebuffUp(v49.SoulRotDebuff) or not v49.SoulRot:IsAvailable();
				v115 = 1849 - (559 + 1288);
			end
			if ((v115 == (1931 - (609 + 1322))) or ((1414 - (13 + 441)) <= (3273 - 2397))) then
				v59 = v16:DebuffUp(v49.PhantomSingularityDebuff) or not v49.PhantomSingularity:IsAvailable();
				v60 = v16:DebuffUp(v49.VileTaintDebuff) or not v49.VileTaint:IsAvailable();
				v115 = 2 - 1;
			end
			if ((v115 == (9 - 7)) or ((77 + 1989) == (3384 - 2452))) then
				v63 = v59 and v60 and v62;
				v64 = v49.PhantomSingularity:IsAvailable() or v49.VileTaint:IsAvailable() or v49.SoulRot:IsAvailable() or v49.SummonDarkglare:IsAvailable();
				v115 = 2 + 1;
			end
		end
	end
	local function v87()
		local v116 = 0 + 0;
		while true do
			if (((14318 - 9493) < (2651 + 2192)) and (v116 == (1 - 0))) then
				ShouldReturn = v48.HandleBottomTrinket(v51, v30, 27 + 13, nil);
				if (ShouldReturn or ((2157 + 1720) >= (3260 + 1277))) then
					return ShouldReturn;
				end
				break;
			end
			if (((0 + 0) == v116) or ((4222 + 93) < (2159 - (153 + 280)))) then
				ShouldReturn = v48.HandleTopTrinket(v51, v30, 115 - 75, nil);
				if (ShouldReturn or ((3304 + 375) < (247 + 378))) then
					return ShouldReturn;
				end
				v116 = 1 + 0;
			end
		end
	end
	local function v88()
		local v117 = v87();
		if (v117 or ((4198 + 427) < (458 + 174))) then
			return v117;
		end
		if (v50.DesperateInvokersCodex:IsEquippedAndReady() or ((126 - 43) > (1101 + 679))) then
			if (((1213 - (89 + 578)) <= (770 + 307)) and v25(v55.DesperateInvokersCodex, not v16:IsInRange(93 - 48))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (v50.ConjuredChillglobe:IsEquippedAndReady() or ((2045 - (572 + 477)) > (581 + 3720))) then
			if (((2443 + 1627) > (83 + 604)) and v25(v55.ConjuredChillglobe)) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v89()
		if (v65 or ((742 - (84 + 2)) >= (5488 - 2158))) then
			local v131 = v48.HandleDPSPotion();
			if (v131 or ((1796 + 696) <= (1177 - (497 + 345)))) then
				return v131;
			end
			if (((111 + 4211) >= (434 + 2128)) and v49.Berserking:IsCastable()) then
				if (v25(v49.Berserking) or ((4970 - (605 + 728)) >= (2690 + 1080))) then
					return "berserking ogcd 4";
				end
			end
			if (v49.BloodFury:IsCastable() or ((5288 - 2909) > (210 + 4368))) then
				if (v25(v49.BloodFury) or ((1785 - 1302) > (670 + 73))) then
					return "blood_fury ogcd 6";
				end
			end
			if (((6799 - 4345) > (437 + 141)) and v49.Fireblood:IsCastable()) then
				if (((1419 - (457 + 32)) < (1892 + 2566)) and v25(v49.Fireblood)) then
					return "fireblood ogcd 8";
				end
			end
		end
	end
	local function v90()
		local v118 = 1402 - (832 + 570);
		local v119;
		while true do
			if (((624 + 38) <= (254 + 718)) and (v118 == (17 - 12))) then
				if (((2106 + 2264) == (5166 - (588 + 208))) and v49.SiphonLife:IsReady() and (v49.SiphonLifeDebuff:AuraActiveCount() < (13 - 8))) then
					if (v48.CastCycle(v49.SiphonLife, v56, v84, not v16:IsSpellInRange(v49.SiphonLife)) or ((6562 - (884 + 916)) <= (1802 - 941))) then
						return "siphon_life aoe 34";
					end
				end
				if (v49.DrainSoul:IsReady() or ((819 + 593) == (4917 - (232 + 421)))) then
					if (v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul)) or ((5057 - (1569 + 320)) < (529 + 1624))) then
						return "drain_soul aoe 36";
					end
				end
				if (v49.ShadowBolt:IsReady() or ((946 + 4030) < (4488 - 3156))) then
					if (((5233 - (316 + 289)) == (12114 - 7486)) and v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if ((v118 == (1 + 1)) or ((1507 - (666 + 787)) == (820 - (360 + 65)))) then
				if (((77 + 5) == (336 - (79 + 175))) and v49.SiphonLife:IsReady() and (v49.SiphonLifeDebuff:AuraActiveCount() < (9 - 3)) and v49.SummonDarkglare:CooldownUp()) then
					if (v48.CastCycle(v49.SiphonLife, v56, v84, not v16:IsSpellInRange(v49.SiphonLife)) or ((454 + 127) < (864 - 582))) then
						return "siphon_life aoe 10";
					end
				end
				if ((v49.SoulRot:IsReady() and v60 and v59) or ((8875 - 4266) < (3394 - (503 + 396)))) then
					if (((1333 - (92 + 89)) == (2234 - 1082)) and v24(v49.SoulRot, nil, nil, not v16:IsSpellInRange(v49.SoulRot))) then
						return "soul_rot aoe 12";
					end
				end
				if (((973 + 923) <= (2026 + 1396)) and v49.SeedofCorruption:IsReady() and (v16:DebuffRemains(v49.CorruptionDebuff) < (19 - 14)) and not (v49.SeedofCorruption:InFlight() or v16:DebuffUp(v49.SeedofCorruptionDebuff))) then
					if (v24(v49.SeedofCorruption, nil, nil, not v16:IsSpellInRange(v49.SeedofCorruption)) or ((136 + 854) > (3693 - 2073))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if ((v49.Agony:IsReady() and (v49.AgonyDebuff:AuraActiveCount() < (7 + 1))) or ((419 + 458) > (14299 - 9604))) then
					if (((336 + 2355) >= (2822 - 971)) and v48.CastTargetIf(v49.Agony, v56, "min", v72, v75, not v16:IsSpellInRange(v49.Agony))) then
						return "agony aoe 16";
					end
				end
				v118 = 1247 - (485 + 759);
			end
			if ((v118 == (6 - 3)) or ((4174 - (442 + 747)) >= (5991 - (832 + 303)))) then
				if (((5222 - (88 + 858)) >= (365 + 830)) and v30 and v49.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
					if (((2675 + 557) <= (194 + 4496)) and v24(v49.SummonDarkglare, v46)) then
						return "summon_darkglare aoe 18";
					end
				end
				if ((v49.MaleficRapture:IsReady() and (v12:BuffUp(v49.UmbrafireKindlingBuff))) or ((1685 - (766 + 23)) >= (15530 - 12384))) then
					if (((4186 - 1125) >= (7793 - 4835)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(339 - 239))) then
						return "malefic_rapture aoe 20";
					end
				end
				if (((4260 - (1036 + 37)) >= (457 + 187)) and v49.SeedofCorruption:IsReady() and v49.SowTheSeeds:IsAvailable()) then
					if (((1253 - 609) <= (554 + 150)) and v24(v49.SeedofCorruption, nil, nil, not v16:IsSpellInRange(v49.SeedofCorruption))) then
						return "seed_of_corruption aoe 22";
					end
				end
				if (((2438 - (641 + 839)) > (1860 - (910 + 3))) and v49.MaleficRapture:IsReady() and ((((v49.SummonDarkglare:CooldownRemains() > (38 - 23)) or (v67 > (1687 - (1466 + 218)))) and not v49.SowTheSeeds:IsAvailable()) or v12:BuffUp(v49.TormentedCrescendoBuff))) then
					if (((2065 + 2427) >= (3802 - (556 + 592))) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(36 + 64))) then
						return "malefic_rapture aoe 24";
					end
				end
				v118 = 812 - (329 + 479);
			end
			if (((4296 - (174 + 680)) >= (5164 - 3661)) and (v118 == (0 - 0))) then
				if (v30 or ((2264 + 906) <= (2203 - (396 + 343)))) then
					local v143 = 0 + 0;
					local v144;
					while true do
						if ((v143 == (1477 - (29 + 1448))) or ((6186 - (135 + 1254)) == (16530 - 12142))) then
							v144 = v89();
							if (((2572 - 2021) <= (454 + 227)) and v144) then
								return v144;
							end
							break;
						end
					end
				end
				v119 = v88();
				if (((4804 - (389 + 1138)) > (981 - (102 + 472))) and v119) then
					return v119;
				end
				v66 = v70(v57);
				v118 = 1 + 0;
			end
			if (((2604 + 2091) >= (1320 + 95)) and (v118 == (1546 - (320 + 1225)))) then
				if ((v49.Haunt:IsReady() and (v16:DebuffRemains(v49.HauntDebuff) < (5 - 2))) or ((1966 + 1246) <= (2408 - (157 + 1307)))) then
					if (v24(v49.Haunt, nil, nil, not v16:IsSpellInRange(v49.Haunt)) or ((4955 - (821 + 1038)) <= (4485 - 2687))) then
						return "haunt aoe 2";
					end
				end
				if (((387 + 3150) == (6282 - 2745)) and v49.VileTaint:IsReady() and (((v49.SouleatersGluttony:TalentRank() == (1 + 1)) and ((v66 < (2.5 - 1)) or (v49.SoulRot:CooldownRemains() <= v49.VileTaint:ExecuteTime()))) or ((v49.SouleatersGluttony:TalentRank() == (1027 - (834 + 192))) and (v49.SoulRot:CooldownRemains() <= v49.VileTaint:ExecuteTime())) or (not v49.SouleatersGluttony:IsAvailable() and ((v49.SoulRot:CooldownRemains() <= v49.VileTaint:ExecuteTime()) or (v49.VileTaint:CooldownRemains() > (2 + 23)))))) then
					if (((985 + 2852) >= (34 + 1536)) and v24(v55.VileTaintCursor, nil, nil, not v16:IsInRange(61 - 21))) then
						return "vile_taint aoe 4";
					end
				end
				if (v49.PhantomSingularity:IsCastable() or ((3254 - (300 + 4)) == (1019 + 2793))) then
					if (((12363 - 7640) >= (2680 - (112 + 250))) and v24(v49.PhantomSingularity, v45, nil, not v16:IsSpellInRange(v49.PhantomSingularity))) then
						return "phantom_singularity aoe 6";
					end
				end
				if ((v49.UnstableAffliction:IsReady() and (v16:DebuffRemains(v49.UnstableAfflictionDebuff) < (2 + 3))) or ((5077 - 3050) > (1634 + 1218))) then
					if (v24(v49.UnstableAffliction, nil, nil, not v16:IsSpellInRange(v49.UnstableAffliction)) or ((588 + 548) > (3229 + 1088))) then
						return "unstable_affliction aoe 8";
					end
				end
				v118 = 1 + 1;
			end
			if (((3528 + 1220) == (6162 - (1001 + 413))) and (v118 == (8 - 4))) then
				if (((4618 - (244 + 638)) <= (5433 - (627 + 66))) and v49.DrainLife:IsReady() and (v16:DebuffUp(v49.SoulRotDebuff) or not v49.SoulRot:IsAvailable()) and (v12:BuffStack(v49.InevitableDemiseBuff) > (29 - 19))) then
					if (v24(v49.DrainLife, nil, nil, not v16:IsSpellInRange(v49.DrainLife)) or ((3992 - (512 + 90)) <= (4966 - (1665 + 241)))) then
						return "drain_life aoe 26";
					end
				end
				if ((v49.DrainSoul:IsReady() and v12:BuffUp(v49.NightfallBuff) and v49.ShadowEmbrace:IsAvailable()) or ((1716 - (373 + 344)) > (1215 + 1478))) then
					if (((123 + 340) < (1585 - 984)) and v48.CastCycle(v49.DrainSoul, v56, v83, not v16:IsSpellInRange(v49.DrainSoul))) then
						return "drain_soul aoe 28";
					end
				end
				if ((v49.DrainSoul:IsReady() and (v12:BuffUp(v49.NightfallBuff))) or ((3693 - 1510) < (1786 - (35 + 1064)))) then
					if (((3310 + 1239) == (9732 - 5183)) and v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul))) then
						return "drain_soul aoe 30";
					end
				end
				if (((19 + 4653) == (5908 - (298 + 938))) and v49.SummonSoulkeeper:IsReady() and ((v49.SummonSoulkeeper:Count() == (1269 - (233 + 1026))) or ((v49.SummonSoulkeeper:Count() > (1669 - (636 + 1030))) and (v69 < (6 + 4))))) then
					if (v24(v49.SummonSoulkeeper) or ((3583 + 85) < (118 + 277))) then
						return "soul_strike aoe 32";
					end
				end
				v118 = 1 + 4;
			end
		end
	end
	local function v91()
		local v120 = 221 - (55 + 166);
		local v121;
		while true do
			if ((v120 == (0 + 0)) or ((419 + 3747) == (1737 - 1282))) then
				if (v30 or ((4746 - (36 + 261)) == (4656 - 1993))) then
					local v145 = 1368 - (34 + 1334);
					local v146;
					while true do
						if ((v145 == (0 + 0)) or ((3324 + 953) < (4272 - (1035 + 248)))) then
							v146 = v89();
							if (v146 or ((891 - (20 + 1)) >= (2162 + 1987))) then
								return v146;
							end
							break;
						end
					end
				end
				v121 = v88();
				if (((2531 - (134 + 185)) < (4316 - (549 + 584))) and v121) then
					return v121;
				end
				if (((5331 - (314 + 371)) > (10271 - 7279)) and v30 and v49.SummonDarkglare:IsCastable() and v59 and v60 and v62) then
					if (((2402 - (478 + 490)) < (1646 + 1460)) and v24(v49.SummonDarkglare, v46)) then
						return "summon_darkglare cleave 2";
					end
				end
				if (((1958 - (786 + 386)) < (9791 - 6768)) and v49.MaleficRapture:IsReady() and ((v49.DreadTouch:IsAvailable() and (v16:DebuffRemains(v49.DreadTouchDebuff) < (1381 - (1055 + 324))) and v16:DebuffUp(v49.AgonyDebuff) and v16:DebuffUp(v49.CorruptionDebuff) and (not v49.SiphonLife:IsAvailable() or v16:DebuffUp(v49.SiphonLifeDebuff)) and (not v49.PhantomSingularity:IsAvailable() or v49.PhantomSingularity:CooldownDown()) and (not v49.VileTaint:IsAvailable() or v49.VileTaint:CooldownDown()) and (not v49.SoulRot:IsAvailable() or v49.SoulRot:CooldownDown())) or (v67 > (1344 - (1093 + 247))) or v12:BuffUp(v49.UmbrafireKindlingBuff))) then
					if (v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(89 + 11)) or ((257 + 2185) < (293 - 219))) then
						return "malefic_rapture cleave 4";
					end
				end
				if (((15390 - 10855) == (12904 - 8369)) and v49.Agony:IsReady()) then
					if (v48.CastTargetIf(v49.Agony, v56, "min", v72, v76, not v16:IsSpellInRange(v49.Agony)) or ((7561 - 4552) <= (749 + 1356))) then
						return "agony cleave 6";
					end
				end
				v120 = 3 - 2;
			end
			if (((6307 - 4477) < (2767 + 902)) and (v120 == (4 - 2))) then
				if (v49.SiphonLife:IsReady() or ((2118 - (364 + 324)) >= (9901 - 6289))) then
					if (((6437 - 3754) >= (816 + 1644)) and v48.CastTargetIf(v49.SiphonLife, v56, "min", v74, v78, not v16:IsSpellInRange(v49.SiphonLife))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v49.Haunt:IsReady() and (v16:DebuffRemains(v49.HauntDebuff) < (12 - 9))) or ((2888 - 1084) >= (9946 - 6671))) then
					if (v24(v49.Haunt, nil, nil, not v16:IsSpellInRange(v49.Haunt)) or ((2685 - (1249 + 19)) > (3276 + 353))) then
						return "haunt cleave 22";
					end
				end
				if (((18664 - 13869) > (1488 - (686 + 400))) and v49.PhantomSingularity:IsReady() and ((v49.SoulRot:CooldownRemains() <= v49.PhantomSingularity:ExecuteTime()) or (not v49.SouleatersGluttony:IsAvailable() and (not v49.SoulRot:IsAvailable() or (v49.SoulRot:CooldownRemains() <= v49.PhantomSingularity:ExecuteTime()) or (v49.SoulRot:CooldownRemains() >= (20 + 5)))))) then
					if (((5042 - (73 + 156)) > (17 + 3548)) and v24(v49.PhantomSingularity, v45, nil, not v16:IsSpellInRange(v49.PhantomSingularity))) then
						return "phantom_singularity cleave 24";
					end
				end
				if (((4723 - (721 + 90)) == (44 + 3868)) and v49.SoulRot:IsReady()) then
					if (((9159 - 6338) <= (5294 - (224 + 246))) and v24(v49.SoulRot, nil, nil, not v16:IsSpellInRange(v49.SoulRot))) then
						return "soul_rot cleave 26";
					end
				end
				if (((2815 - 1077) <= (4041 - 1846)) and v49.MaleficRapture:IsReady() and ((v67 > (1 + 3)) or (v49.TormentedCrescendo:IsAvailable() and (v12:BuffStack(v49.TormentedCrescendoBuff) == (1 + 0)) and (v67 > (3 + 0))))) then
					if (((81 - 40) <= (10043 - 7025)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(613 - (203 + 310)))) then
						return "malefic_rapture cleave 28";
					end
				end
				if (((4138 - (1238 + 755)) <= (287 + 3817)) and v49.MaleficRapture:IsReady() and v49.DreadTouch:IsAvailable() and (v16:DebuffRemains(v49.DreadTouchDebuff) < v12:GCD())) then
					if (((4223 - (709 + 825)) < (8927 - 4082)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(145 - 45))) then
						return "malefic_rapture cleave 30";
					end
				end
				v120 = 867 - (196 + 668);
			end
			if (((11 - 8) == v120) or ((4809 - 2487) > (3455 - (171 + 662)))) then
				if ((v49.MaleficRapture:IsReady() and not v49.DreadTouch:IsAvailable() and v12:BuffUp(v49.TormentedCrescendoBuff)) or ((4627 - (4 + 89)) == (7297 - 5215))) then
					if (v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(37 + 63)) or ((6900 - 5329) > (733 + 1134))) then
						return "malefic_rapture cleave 32";
					end
				end
				if ((v49.MaleficRapture:IsReady() and (v63 or v61)) or ((4140 - (35 + 1451)) >= (4449 - (28 + 1425)))) then
					if (((5971 - (941 + 1052)) > (2018 + 86)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(1614 - (822 + 692)))) then
						return "malefic_rapture cleave 34";
					end
				end
				if (((4275 - 1280) > (726 + 815)) and v49.DrainSoul:IsReady() and v12:BuffUp(v49.NightfallBuff) and v49.ShadowEmbrace:IsAvailable()) then
					if (((3546 - (45 + 252)) > (943 + 10)) and v48.CastCycle(v49.DrainSoul, v56, v83, not v16:IsSpellInRange(v49.DrainSoul))) then
						return "drain_soul cleave 36";
					end
				end
				if ((v49.DrainSoul:IsReady() and v12:BuffUp(v49.NightfallBuff)) or ((1127 + 2146) > (11129 - 6556))) then
					if (v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul)) or ((3584 - (114 + 319)) < (1843 - 559))) then
						return "drain_soul cleave 38";
					end
				end
				if ((v49.ShadowBolt:IsReady() and v12:BuffUp(v49.NightfallBuff)) or ((2370 - 520) == (975 + 554))) then
					if (((1222 - 401) < (4447 - 2324)) and v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt))) then
						return "shadow_bolt cleave 40";
					end
				end
				if (((2865 - (556 + 1407)) < (3531 - (741 + 465))) and v49.MaleficRapture:IsReady() and (v67 > (468 - (170 + 295)))) then
					if (((453 + 405) <= (2721 + 241)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(246 - 146))) then
						return "malefic_rapture cleave 42";
					end
				end
				v120 = 4 + 0;
			end
			if (((4 + 1) == v120) or ((2235 + 1711) < (2518 - (957 + 273)))) then
				if (v49.ShadowBolt:IsReady() or ((868 + 2374) == (227 + 340))) then
					if (v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt)) or ((3227 - 2380) >= (3328 - 2065))) then
						return "shadow_bolt cleave 56";
					end
				end
				break;
			end
			if ((v120 == (2 - 1)) or ((11156 - 8903) == (3631 - (389 + 1391)))) then
				if ((v49.SoulRot:IsReady() and v60 and v59) or ((1310 + 777) > (247 + 2125))) then
					if (v24(v49.SoulRot, nil, nil, not v16:IsSpellInRange(v49.SoulRot)) or ((10119 - 5674) < (5100 - (783 + 168)))) then
						return "soul_rot cleave 8";
					end
				end
				if ((v49.VileTaint:IsReady() and (v49.AgonyDebuff:AuraActiveCount() == (6 - 4)) and (v49.CorruptionDebuff:AuraActiveCount() == (2 + 0)) and (not v49.SiphonLife:IsAvailable() or (v49.SiphonLifeDebuff:AuraActiveCount() == (313 - (309 + 2)))) and (not v49.SoulRot:IsAvailable() or (v49.SoulRot:CooldownRemains() <= v49.VileTaint:ExecuteTime()) or (not v49.SouleatersGluttony:IsAvailable() and (v49.SoulRot:CooldownRemains() >= (36 - 24))))) or ((3030 - (1090 + 122)) == (28 + 57))) then
					if (((2115 - 1485) < (1456 + 671)) and v24(v55.VileTaintCursor, nil, nil, not v16:IsSpellInRange(v49.VileTaint))) then
						return "vile_taint cleave 10";
					end
				end
				if ((v49.PhantomSingularity:IsReady() and (v49.AgonyDebuff:AuraActiveCount() == (1120 - (628 + 490))) and (v49.CorruptionDebuff:AuraActiveCount() == (1 + 1)) and (not v49.SiphonLife:IsAvailable() or (v49.SiphonLifeDebuff:AuraActiveCount() == (4 - 2))) and (v49.SoulRot:IsAvailable() or (v49.SoulRot:CooldownRemains() <= v49.PhantomSingularity:ExecuteTime()) or (v49.SoulRot:CooldownRemains() >= (114 - 89)))) or ((2712 - (431 + 343)) == (5076 - 2562))) then
					if (((12309 - 8054) >= (44 + 11)) and v24(v49.PhantomSingularity, v45, nil, not v16:IsSpellInRange(v49.PhantomSingularity))) then
						return "phantom_singularity cleave 12";
					end
				end
				if (((384 + 2615) > (2851 - (556 + 1139))) and v49.UnstableAffliction:IsReady() and (v16:DebuffRemains(v49.UnstableAfflictionDebuff) < (20 - (6 + 9)))) then
					if (((431 + 1919) > (592 + 563)) and v24(v49.UnstableAffliction, nil, nil, not v16:IsSpellInRange(v49.UnstableAffliction))) then
						return "unstable_affliction cleave 14";
					end
				end
				if (((4198 - (28 + 141)) <= (1880 + 2973)) and v49.SeedofCorruption:IsReady() and not v49.AbsoluteCorruption:IsAvailable() and (v16:DebuffRemains(v49.CorruptionDebuff) < (6 - 1)) and v49.SowTheSeeds:IsAvailable() and v71(v57)) then
					if (v24(v49.SeedofCorruption, nil, nil, not v16:IsSpellInRange(v49.SeedofCorruption)) or ((366 + 150) > (4751 - (486 + 831)))) then
						return "seed_of_corruption cleave 16";
					end
				end
				if (((10528 - 6482) >= (10677 - 7644)) and v49.Corruption:IsReady()) then
					if (v48.CastTargetIf(v49.Corruption, v56, "min", v73, v77, not v16:IsSpellInRange(v49.Corruption)) or ((514 + 2205) <= (4575 - 3128))) then
						return "corruption cleave 18";
					end
				end
				v120 = 1265 - (668 + 595);
			end
			if ((v120 == (4 + 0)) or ((834 + 3300) < (10706 - 6780))) then
				if ((v49.DrainLife:IsReady() and ((v12:BuffStack(v49.InevitableDemiseBuff) > (338 - (23 + 267))) or ((v12:BuffStack(v49.InevitableDemiseBuff) > (1964 - (1129 + 815))) and (v69 < (391 - (371 + 16)))))) or ((1914 - (1326 + 424)) >= (5274 - 2489))) then
					if (v24(v49.DrainLife, nil, nil, not v16:IsSpellInRange(v49.DrainLife)) or ((1918 - 1393) == (2227 - (88 + 30)))) then
						return "drain_life cleave 44";
					end
				end
				if (((804 - (720 + 51)) == (73 - 40)) and v49.DrainLife:IsReady() and v16:DebuffUp(v49.SoulRotDebuff) and (v12:BuffStack(v49.InevitableDemiseBuff) > (1786 - (421 + 1355)))) then
					if (((5037 - 1983) <= (1973 + 2042)) and v24(v49.DrainLife, nil, nil, not v16:IsSpellInRange(v49.DrainLife))) then
						return "drain_life cleave 46";
					end
				end
				if (((2954 - (286 + 797)) < (12363 - 8981)) and v49.Agony:IsReady()) then
					if (((2140 - 847) <= (2605 - (397 + 42))) and v48.CastCycle(v49.Agony, v56, v80, not v16:IsSpellInRange(v49.Agony))) then
						return "agony cleave 48";
					end
				end
				if (v49.Corruption:IsCastable() or ((806 + 1773) < (923 - (24 + 776)))) then
					if (v48.CastCycle(v49.Corruption, v56, v82, not v16:IsSpellInRange(v49.Corruption)) or ((1302 - 456) >= (3153 - (222 + 563)))) then
						return "corruption cleave 50";
					end
				end
				if ((v49.MaleficRapture:IsReady() and (v67 > (1 - 0))) or ((2889 + 1123) <= (3548 - (23 + 167)))) then
					if (((3292 - (690 + 1108)) <= (1085 + 1920)) and v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(83 + 17))) then
						return "malefic_rapture cleave 52";
					end
				end
				if (v49.DrainSoul:IsReady() or ((3959 - (40 + 808)) == (352 + 1782))) then
					if (((9005 - 6650) == (2251 + 104)) and v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				v120 = 3 + 2;
			end
		end
	end
	local function v92()
		local v122 = 0 + 0;
		while true do
			if ((v122 == (572 - (47 + 524))) or ((382 + 206) <= (1180 - 748))) then
				v30 = EpicSettings.Toggles['cds'];
				v56 = v12:GetEnemiesInRange(59 - 19);
				v57 = v16:GetEnemiesInSplashRange(22 - 12);
				v122 = 1728 - (1165 + 561);
			end
			if (((143 + 4654) >= (12063 - 8168)) and (v122 == (1 + 1))) then
				if (((4056 - (341 + 138)) == (966 + 2611)) and v29) then
					v58 = v16:GetEnemiesInSplashRangeCount(20 - 10);
				else
					v58 = 327 - (89 + 237);
				end
				if (((12205 - 8411) > (7774 - 4081)) and (v48.TargetIsValid() or v12:AffectingCombat())) then
					local v147 = 881 - (581 + 300);
					while true do
						if ((v147 == (1221 - (855 + 365))) or ((3028 - 1753) == (1339 + 2761))) then
							if ((v69 == (12346 - (1030 + 205))) or ((1494 + 97) >= (3331 + 249))) then
								v69 = v9.FightRemains(v57, false);
							end
							break;
						end
						if (((1269 - (156 + 130)) <= (4107 - 2299)) and (v147 == (0 - 0))) then
							v68 = v9.BossFightRemains(nil, true);
							v69 = v68;
							v147 = 1 - 0;
						end
					end
				end
				v67 = v12:SoulShardsP();
				v122 = 1 + 2;
			end
			if ((v122 == (2 + 1)) or ((2219 - (10 + 59)) <= (339 + 858))) then
				if (((18561 - 14792) >= (2336 - (671 + 492))) and v49.SummonPet:IsCastable() and v42 and not v15:IsActive()) then
					if (((1183 + 302) == (2700 - (369 + 846))) and v25(v49.SummonPet)) then
						return "summon_pet ooc";
					end
				end
				if (v48.TargetIsValid() or ((878 + 2437) <= (2375 + 407))) then
					if ((not v12:AffectingCombat() and v28) or ((2821 - (1036 + 909)) >= (2357 + 607))) then
						local v148 = v85();
						if (v148 or ((3746 - 1514) > (2700 - (11 + 192)))) then
							return v148;
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling()) or ((1067 + 1043) <= (507 - (135 + 40)))) then
						local v149 = 0 - 0;
						local v150;
						while true do
							if (((2222 + 1464) > (6987 - 3815)) and (v149 == (2 - 0))) then
								v150 = v48.InterruptWithStun(v49.AxeToss, 216 - (50 + 126), true);
								if (v150 or ((12458 - 7984) < (182 + 638))) then
									return v150;
								end
								v150 = v48.InterruptWithStun(v49.AxeToss, 1453 - (1233 + 180), true, v14, v55.AxeTossMouseover);
								if (((5248 - (522 + 447)) >= (4303 - (107 + 1314))) and v150) then
									return v150;
								end
								break;
							end
							if ((v149 == (1 + 0)) or ((6182 - 4153) >= (1496 + 2025))) then
								v150 = v48.Interrupt(v49.AxeToss, 79 - 39, true);
								if (v150 or ((8059 - 6022) >= (6552 - (716 + 1194)))) then
									return v150;
								end
								v150 = v48.Interrupt(v49.AxeToss, 1 + 39, true, v14, v55.AxeTossMouseover);
								if (((185 + 1535) < (4961 - (74 + 429))) and v150) then
									return v150;
								end
								v149 = 3 - 1;
							end
							if ((v149 == (0 + 0)) or ((997 - 561) > (2138 + 883))) then
								v150 = v48.Interrupt(v49.SpellLock, 123 - 83, true);
								if (((1762 - 1049) <= (1280 - (279 + 154))) and v150) then
									return v150;
								end
								v150 = v48.Interrupt(v49.SpellLock, 818 - (454 + 324), true, v14, v55.SpellLockMouseover);
								if (((1695 + 459) <= (4048 - (12 + 5))) and v150) then
									return v150;
								end
								v149 = 1 + 0;
							end
						end
					end
					v86();
					if (((11758 - 7143) == (1706 + 2909)) and (v58 > (1094 - (277 + 816))) and (v58 < (12 - 9))) then
						local v151 = 1183 - (1058 + 125);
						local v152;
						while true do
							if ((v151 == (0 + 0)) or ((4765 - (815 + 160)) == (2145 - 1645))) then
								v152 = v91();
								if (((211 - 122) < (53 + 168)) and v152) then
									return v152;
								end
								break;
							end
						end
					end
					if (((6004 - 3950) >= (3319 - (41 + 1857))) and (v58 > (1895 - (1222 + 671)))) then
						local v153 = v90();
						if (((1788 - 1096) < (4395 - 1337)) and v153) then
							return v153;
						end
					end
					if (v23() or ((4436 - (229 + 953)) == (3429 - (1111 + 663)))) then
						local v154 = 1579 - (874 + 705);
						local v155;
						while true do
							if ((v154 == (0 + 0)) or ((885 + 411) == (10206 - 5296))) then
								v155 = v89();
								if (((95 + 3273) == (4047 - (642 + 37))) and v155) then
									return v155;
								end
								break;
							end
						end
					end
					if (((603 + 2040) < (611 + 3204)) and v32) then
						local v156 = 0 - 0;
						local v157;
						while true do
							if (((2367 - (233 + 221)) > (1139 - 646)) and ((0 + 0) == v156)) then
								v157 = v88();
								if (((6296 - (718 + 823)) > (2158 + 1270)) and v157) then
									return v157;
								end
								break;
							end
						end
					end
					if (((2186 - (266 + 539)) <= (6706 - 4337)) and v49.MaleficRapture:IsReady() and v49.DreadTouch:IsAvailable() and (v16:DebuffRemains(v49.DreadTouchDebuff) < (1227 - (636 + 589))) and v16:DebuffUp(v49.AgonyDebuff) and v16:DebuffUp(v49.CorruptionDebuff) and (not v49.SiphonLife:IsAvailable() or v16:DebuffUp(v49.SiphonLifeDebuff)) and (not v49.PhantomSingularity:IsAvailable() or v49.PhantomSingularity:CooldownDown()) and (not v49.VileTaint:IsAvailable() or v49.VileTaint:CooldownDown()) and (not v49.SoulRot:IsAvailable() or v49.SoulRot:CooldownDown())) then
						if (v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(237 - 137)) or ((9988 - 5145) == (3237 + 847))) then
							return "malefic_rapture main 2";
						end
					end
					if (((1697 + 2972) > (1378 - (657 + 358))) and v49.SummonDarkglare:IsReady() and v59 and v60 and v62) then
						if (v24(v49.SummonDarkglare, v46) or ((4969 - 3092) >= (7149 - 4011))) then
							return "summon_darkglare main 4";
						end
					end
					if (((5929 - (1151 + 36)) >= (3502 + 124)) and v49.Agony:IsCastable() and (v16:DebuffRemains(v49.AgonyDebuff) < (2 + 3))) then
						if (v24(v49.Agony, nil, nil, not v16:IsSpellInRange(v49.Agony)) or ((13558 - 9018) == (2748 - (1552 + 280)))) then
							return "agony main 6";
						end
					end
					if ((v49.UnstableAffliction:IsReady() and (v16:DebuffRemains(v49.UnstableAfflictionDebuff) < (839 - (64 + 770)))) or ((785 + 371) > (9863 - 5518))) then
						if (((398 + 1839) < (5492 - (157 + 1086))) and v24(v49.UnstableAffliction, nil, nil, not v16:IsSpellInRange(v49.UnstableAffliction))) then
							return "unstable_affliction main 8";
						end
					end
					if ((v49.Corruption:IsCastable() and (v16:DebuffRefreshable(v49.CorruptionDebuff))) or ((5370 - 2687) < (100 - 77))) then
						if (((1069 - 372) <= (1126 - 300)) and v24(v49.Corruption, nil, nil, not v16:IsSpellInRange(v49.Corruption))) then
							return "corruption main 10";
						end
					end
					if (((1924 - (599 + 220)) <= (2341 - 1165)) and v49.SiphonLife:IsCastable() and (v16:DebuffRefreshable(v49.SiphonLifeDebuff))) then
						if (((5310 - (1813 + 118)) <= (2787 + 1025)) and v24(v49.SiphonLife, nil, nil, not v16:IsSpellInRange(v49.SiphonLife))) then
							return "siphon_life main 12";
						end
					end
					if ((v49.Haunt:IsReady() and (v16:DebuffRemains(v49.HauntDebuff) < (1220 - (841 + 376)))) or ((1103 - 315) >= (376 + 1240))) then
						if (((5060 - 3206) <= (4238 - (464 + 395))) and v24(v49.Haunt, nil, nil, not v16:IsSpellInRange(v49.Haunt))) then
							return "haunt main 14";
						end
					end
					if (((11674 - 7125) == (2185 + 2364)) and v49.DrainSoul:IsReady() and v49.ShadowEmbrace:IsAvailable() and ((v16:DebuffStack(v49.ShadowEmbraceDebuff) < (840 - (467 + 370))) or (v16:DebuffRemains(v49.ShadowEmbraceDebuff) < (5 - 2)))) then
						if (v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul)) or ((2219 + 803) >= (10366 - 7342))) then
							return "drain_soul main 16";
						end
					end
					if (((752 + 4068) > (5113 - 2915)) and v49.ShadowBolt:IsReady() and v49.ShadowEmbrace:IsAvailable() and ((v16:DebuffStack(v49.ShadowEmbraceDebuff) < (523 - (150 + 370))) or (v16:DebuffRemains(v49.ShadowEmbraceDebuff) < (1285 - (74 + 1208))))) then
						if (v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt)) or ((2609 - 1548) >= (23196 - 18305))) then
							return "shadow_bolt main 18";
						end
					end
					if (((971 + 393) <= (4863 - (14 + 376))) and v49.PhantomSingularity:IsCastable() and ((v49.SoulRot:CooldownRemains() <= v49.PhantomSingularity:ExecuteTime()) or (not v49.SouleatersGluttony:IsAvailable() and (not v49.SoulRot:IsAvailable() or (v49.SoulRot:CooldownRemains() <= v49.PhantomSingularity:ExecuteTime()) or (v49.SoulRot:CooldownRemains() >= (43 - 18)))))) then
						if (v24(v49.PhantomSingularity, v45, nil, not v16:IsSpellInRange(v49.PhantomSingularity)) or ((2327 + 1268) <= (3 + 0))) then
							return "phantom_singularity main 20";
						end
					end
					if ((v49.VileTaint:IsReady() and (not v49.SoulRot:IsAvailable() or (v49.SoulRot:CooldownRemains() <= v49.VileTaint:ExecuteTime()) or (not v49.SouleatersGluttony:IsAvailable() and (v49.SoulRot:CooldownRemains() >= (12 + 0))))) or ((13689 - 9017) == (2898 + 954))) then
						if (((1637 - (23 + 55)) == (3694 - 2135)) and v24(v55.VileTaintCursor, nil, nil, not v16:IsInRange(27 + 13))) then
							return "vile_taint main 22";
						end
					end
					if ((v49.SoulRot:IsReady() and v60 and (v59 or (v49.SouleatersGluttony:TalentRank() ~= (1 + 0)))) or ((2716 - 964) <= (248 + 540))) then
						if (v24(v49.SoulRot, nil, nil, not v16:IsSpellInRange(v49.SoulRot)) or ((4808 - (652 + 249)) == (473 - 296))) then
							return "soul_rot main 24";
						end
					end
					if (((5338 - (708 + 1160)) > (1506 - 951)) and v49.MaleficRapture:IsReady() and ((v67 > (6 - 2)) or (v49.TormentedCrescendo:IsAvailable() and (v12:BuffStack(v49.TormentedCrescendoBuff) == (28 - (10 + 17))) and (v67 > (1 + 2))) or (v49.TormentedCrescendo:IsAvailable() and v12:BuffUp(v49.TormentedCrescendoBuff) and v16:DebuffDown(v49.DreadTouchDebuff)) or (v49.TormentedCrescendo:IsAvailable() and (v12:BuffStack(v49.TormentedCrescendoBuff) == (1734 - (1400 + 332)))) or v63 or (v61 and (v67 > (1 - 0))) or (v49.TormentedCrescendo:IsAvailable() and v49.Nightfall:IsAvailable() and v12:BuffUp(v49.TormentedCrescendoBuff) and v12:BuffUp(v49.NightfallBuff)))) then
						if (v24(v49.MaleficRapture, nil, nil, not v16:IsInRange(2008 - (242 + 1666))) or ((416 + 556) == (237 + 408))) then
							return "malefic_rapture main 26";
						end
					end
					if (((2712 + 470) >= (3055 - (850 + 90))) and v49.DrainLife:IsReady() and ((v12:BuffStack(v49.InevitableDemiseBuff) > (83 - 35)) or ((v12:BuffStack(v49.InevitableDemiseBuff) > (1410 - (360 + 1030))) and (v69 < (4 + 0))))) then
						if (((10987 - 7094) < (6092 - 1663)) and v24(v49.DrainLife, nil, nil, not v16:IsSpellInRange(v49.DrainLife))) then
							return "drain_life main 28";
						end
					end
					if ((v49.DrainSoul:IsReady() and (v12:BuffUp(v49.NightfallBuff))) or ((4528 - (909 + 752)) < (3128 - (109 + 1114)))) then
						if (v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul)) or ((3287 - 1491) >= (1577 + 2474))) then
							return "drain_soul main 30";
						end
					end
					if (((1861 - (6 + 236)) <= (2367 + 1389)) and v49.ShadowBolt:IsReady() and (v12:BuffUp(v49.NightfallBuff))) then
						if (((487 + 117) == (1424 - 820)) and v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt))) then
							return "shadow_bolt main 32";
						end
					end
					if ((v49.Agony:IsCastable() and (v16:DebuffRefreshable(v49.AgonyDebuff))) or ((7831 - 3347) == (2033 - (1076 + 57)))) then
						if (v24(v49.Agony, nil, nil, not v16:IsSpellInRange(v49.Agony)) or ((734 + 3725) <= (1802 - (579 + 110)))) then
							return "agony main 34";
						end
					end
					if (((287 + 3345) > (3005 + 393)) and v49.Corruption:IsCastable() and (v16:DebuffRefreshable(v49.CorruptionDebuff))) then
						if (((2167 + 1915) <= (5324 - (174 + 233))) and v24(v49.Corruption, nil, nil, not v16:IsSpellInRange(v49.Corruption))) then
							return "corruption main 36";
						end
					end
					if (((13497 - 8665) >= (2432 - 1046)) and v49.DrainSoul:IsReady()) then
						if (((61 + 76) == (1311 - (663 + 511))) and v24(v49.DrainSoul, nil, nil, not v16:IsSpellInRange(v49.DrainSoul))) then
							return "drain_soul main 40";
						end
					end
					if (v49.ShadowBolt:IsReady() or ((1401 + 169) >= (941 + 3391))) then
						if (v24(v49.ShadowBolt, nil, nil, not v16:IsSpellInRange(v49.ShadowBolt)) or ((12529 - 8465) <= (1102 + 717))) then
							return "shadow_bolt main 42";
						end
					end
				end
				break;
			end
			if ((v122 == (0 - 0)) or ((12069 - 7083) < (752 + 822))) then
				v47();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v122 = 1 - 0;
			end
		end
	end
	local function v93()
		local v123 = 0 + 0;
		while true do
			if (((405 + 4021) > (894 - (478 + 244))) and (v123 == (517 - (440 + 77)))) then
				v19.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v49.AgonyDebuff:RegisterAuraTracking();
				v123 = 1 + 0;
			end
			if (((2144 - 1558) > (2011 - (655 + 901))) and (v123 == (1 + 0))) then
				v49.SiphonLifeDebuff:RegisterAuraTracking();
				v49.CorruptionDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v19.SetAPL(203 + 62, v92, v93);
end;
return v0["Epix_Warlock_Affliction.lua"]();

