local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((915 - 347) > (1367 - (714 + 225))) and not v6) then
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
		v33 = EpicSettings.Settings['UseTrinkets'];
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (806 - (118 + 688));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (48 - (25 + 23));
		v43 = EpicSettings.Settings['SummonPet'];
		v44 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
		v45 = EpicSettings.Settings['VileTaint'];
		v46 = EpicSettings.Settings['PhantomSingularity'];
		v47 = EpicSettings.Settings['SummonDarkglare'];
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
	local v71 = 1886 - (927 + 959);
	local v72 = 37453 - 26342;
	local v73 = 11843 - (16 + 716);
	local v74;
	v10:RegisterForEvent(function()
		local v116 = 0 - 0;
		while true do
			if (((1431 - (11 + 86)) <= (11251 - 6638)) and (v116 == (285 - (175 + 110)))) then
				v51.SeedofCorruption:RegisterInFlight();
				v51.ShadowBolt:RegisterInFlight();
				v116 = 2 - 1;
			end
			if ((v116 == (4 - 3)) or ((3661 - (503 + 1293)) >= (5666 - 3637))) then
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
		local v117 = 0 + 0;
		while true do
			if (((6011 - (810 + 251)) >= (1122 + 494)) and (v117 == (0 + 0))) then
				v72 = 10017 + 1094;
				v73 = 11644 - (43 + 490);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v75(v118, v119)
		if (((2458 - (711 + 22)) == (6672 - 4947)) and (not v118 or not v119)) then
			return 859 - (240 + 619);
		end
		local v120;
		for v154, v155 in pairs(v118) do
			local v156 = 0 + 0;
			local v157;
			while true do
				if (((2320 - 861) <= (165 + 2317)) and ((1744 - (1344 + 400)) == v156)) then
					v157 = v155:DebuffRemains(v119) + ((504 - (255 + 150)) * v26(v155:DebuffDown(v119)));
					if ((v120 == nil) or (v157 < v120) or ((2124 + 572) >= (2427 + 2105))) then
						v120 = v157;
					end
					break;
				end
			end
		end
		return v120 or (0 - 0);
	end
	local function v76(v121)
		local v122 = 0 - 0;
		local v123;
		local v124;
		while true do
			if (((2787 - (404 + 1335)) >= (458 - (183 + 223))) and (v122 == (1 - 0))) then
				v123 = 0 + 0;
				v124 = 0 + 0;
				v122 = 339 - (10 + 327);
			end
			if (((2060 + 898) < (4841 - (118 + 220))) and (v122 == (1 + 1))) then
				for v163, v164 in pairs(v121) do
					v123 = v123 + (450 - (108 + 341));
					if (v164:DebuffUp(v51.SeedofCorruptionDebuff) or ((1229 + 1506) == (5534 - 4225))) then
						v124 = v124 + (1494 - (711 + 782));
					end
				end
				return v123 == v124;
			end
			if ((v122 == (0 - 0)) or ((4599 - (270 + 199)) <= (958 + 1997))) then
				if (not v121 or (#v121 == (1819 - (580 + 1239))) or ((5838 - 3874) <= (1282 + 58))) then
					return false;
				end
				if (((90 + 2409) == (1089 + 1410)) and (v51.SeedofCorruption:InFlight() or v13:PrevGCDP(2 - 1, v51.SeedofCorruption))) then
					return false;
				end
				v122 = 1 + 0;
			end
		end
	end
	local function v77()
		return v50.GuardiansTable.DarkglareDuration > (1167 - (645 + 522));
	end
	local function v78()
		return v50.GuardiansTable.DarkglareDuration;
	end
	local function v79(v125)
		return (v125:DebuffRemains(v51.AgonyDebuff));
	end
	local function v80(v126)
		return (v126:DebuffRemains(v51.CorruptionDebuff));
	end
	local function v81(v127)
		return (v127:DebuffRemains(v51.ShadowEmbraceDebuff));
	end
	local function v82(v128)
		return (v128:DebuffRemains(v51.SiphonLifeDebuff));
	end
	local function v83(v129)
		return (v129:DebuffRemains(v51.SoulRotDebuff));
	end
	local function v84(v130)
		return (v130:DebuffRemains(v51.AgonyDebuff) < (v130:DebuffRemains(v51.VileTaintDebuff) + v51.VileTaint:CastTime())) and (v130:DebuffRemains(v51.AgonyDebuff) < (1795 - (1010 + 780)));
	end
	local function v85(v131)
		return v131:DebuffRemains(v51.AgonyDebuff) < (5 + 0);
	end
	local function v86(v132)
		return ((v132:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v132:DebuffRemains(v51.AgonyDebuff) < (23 - 18));
	end
	local function v87(v133)
		return ((v133:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v133:DebuffRemains(v51.AgonyDebuff) < (14 - 9)) and (v73 > (1841 - (1045 + 791)));
	end
	local function v88(v134)
		return v134:DebuffRemains(v51.CorruptionDebuff) < (12 - 7);
	end
	local function v89(v135)
		return (v51.ShadowEmbrace:IsAvailable() and ((v135:DebuffStack(v51.ShadowEmbraceDebuff) < (4 - 1)) or (v135:DebuffRemains(v51.ShadowEmbraceDebuff) < (508 - (351 + 154))))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v90(v136)
		return (v136:DebuffRefreshable(v51.SiphonLifeDebuff));
	end
	local function v91(v137)
		return v137:DebuffRemains(v51.AgonyDebuff) < (1579 - (1281 + 293));
	end
	local function v92(v138)
		return (v138:DebuffRefreshable(v51.AgonyDebuff));
	end
	local function v93(v139)
		return v139:DebuffRemains(v51.CorruptionDebuff) < (271 - (28 + 238));
	end
	local function v94(v140)
		return (v140:DebuffRefreshable(v51.CorruptionDebuff));
	end
	local function v95(v141)
		return (v141:DebuffStack(v51.ShadowEmbraceDebuff) < (6 - 3)) or (v141:DebuffRemains(v51.ShadowEmbraceDebuff) < (1562 - (1381 + 178)));
	end
	local function v96(v142)
		return (v51.ShadowEmbrace:IsAvailable() and ((v142:DebuffStack(v51.ShadowEmbraceDebuff) < (3 + 0)) or (v142:DebuffRemains(v51.ShadowEmbraceDebuff) < (3 + 0)))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v97(v143)
		return v143:DebuffRemains(v51.SiphonLifeDebuff) < (3 + 2);
	end
	local function v98(v144)
		return (v144:DebuffRemains(v51.SiphonLifeDebuff) < (17 - 12)) and v144:DebuffUp(v51.AgonyDebuff);
	end
	local function v99()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (471 - (381 + 89))) or ((2000 + 255) < (15 + 7))) then
				if ((v51.UnstableAffliction:IsReady() and not v51.SoulSwap:IsAvailable()) or ((1859 - 773) >= (2561 - (1074 + 82)))) then
					if (v25(v51.UnstableAffliction, not v17:IsSpellInRange(v51.UnstableAffliction), true) or ((5191 - 2822) == (2210 - (214 + 1570)))) then
						return "unstable_affliction precombat 8";
					end
				end
				if (v51.ShadowBolt:IsReady() or ((4531 - (990 + 465)) > (1313 + 1870))) then
					if (((524 + 678) > (1029 + 29)) and v25(v51.ShadowBolt, not v17:IsSpellInRange(v51.ShadowBolt), true)) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
			if (((14604 - 10893) > (5081 - (1668 + 58))) and (v145 == (626 - (512 + 114)))) then
				if (v51.GrimoireofSacrifice:IsCastable() or ((2361 - 1455) >= (4607 - 2378))) then
					if (((4481 - 3193) > (582 + 669)) and v25(v51.GrimoireofSacrifice)) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (v51.Haunt:IsReady() or ((845 + 3668) < (2915 + 437))) then
					if (v25(v51.Haunt, not v17:IsSpellInRange(v51.Haunt), true) or ((6965 - 4900) >= (5190 - (109 + 1885)))) then
						return "haunt precombat 6";
					end
				end
				v145 = 1470 - (1269 + 200);
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
		v65 = not v64 or (v63 and ((v51.SummonDarkglare:CooldownRemains() > (38 - 18)) or not v51.SummonDarkglare:IsAvailable()));
	end
	local function v101()
		local v146 = v49.HandleTopTrinket(v53, v31, 855 - (98 + 717), nil);
		if (v146 or ((5202 - (802 + 24)) <= (2553 - 1072))) then
			return v146;
		end
		local v146 = v49.HandleBottomTrinket(v53, v31, 50 - 10, nil);
		if (v146 or ((501 + 2891) >= (3643 + 1098))) then
			return v146;
		end
	end
	local function v102()
		local v147 = v101();
		if (((547 + 2778) >= (465 + 1689)) and v147) then
			return v147;
		end
		if (v52.DesperateInvokersCodex:IsEquippedAndReady() or ((3602 - 2307) >= (10781 - 7548))) then
			if (((1566 + 2811) > (669 + 973)) and v25(v55.DesperateInvokersCodex, not v17:IsInRange(38 + 7))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (((3435 + 1288) > (634 + 722)) and v52.ConjuredChillglobe:IsEquippedAndReady()) then
			if (v25(v55.ConjuredChillglobe) or ((5569 - (797 + 636)) <= (16668 - 13235))) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v103()
		if (((5864 - (1427 + 192)) <= (1605 + 3026)) and v65) then
			local v158 = v49.HandleDPSPotion();
			if (((9927 - 5651) >= (3519 + 395)) and v158) then
				return v158;
			end
			if (((90 + 108) <= (4691 - (192 + 134))) and v51.Berserking:IsCastable()) then
				if (((6058 - (316 + 960)) > (2603 + 2073)) and v25(v51.Berserking)) then
					return "berserking ogcd 4";
				end
			end
			if (((3754 + 1110) > (2031 + 166)) and v51.BloodFury:IsCastable()) then
				if (v25(v51.BloodFury) or ((14145 - 10445) == (3058 - (83 + 468)))) then
					return "blood_fury ogcd 6";
				end
			end
			if (((6280 - (1202 + 604)) >= (1279 - 1005)) and v51.Fireblood:IsCastable()) then
				if (v25(v51.Fireblood) or ((3152 - 1258) <= (3892 - 2486))) then
					return "fireblood ogcd 8";
				end
			end
		end
	end
	local function v104()
		if (((1897 - (45 + 280)) >= (1478 + 53)) and v31) then
			local v159 = 0 + 0;
			local v160;
			while true do
				if (((0 + 0) == v159) or ((2594 + 2093) < (799 + 3743))) then
					v160 = v103();
					if (((6094 - 2803) > (3578 - (340 + 1571))) and v160) then
						return v160;
					end
					break;
				end
			end
		end
		local v148 = v102();
		if (v148 or ((345 + 528) == (3806 - (1733 + 39)))) then
			return v148;
		end
		if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (8 - 5))) or ((3850 - (125 + 909)) < (1959 - (1096 + 852)))) then
			if (((1660 + 2039) < (6719 - 2013)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
				return "haunt aoe 2";
			end
		end
		if (((2567 + 79) >= (1388 - (409 + 103))) and v51.VileTaint:IsReady() and (((v51.SouleatersGluttony:TalentRank() == (238 - (46 + 190))) and ((v66 < (96.5 - (51 + 44))) or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()))) or ((v51.SouleatersGluttony:TalentRank() == (1 + 0)) and (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and ((v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (v51.VileTaint:CooldownRemains() > (1342 - (1114 + 203))))))) then
			if (((1340 - (228 + 498)) <= (690 + 2494)) and v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(23 + 17))) then
				return "vile_taint aoe 4";
			end
		end
		if (((3789 - (174 + 489)) == (8143 - 5017)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:IsAvailable() and (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (1930 - (830 + 1075)))))) and v17:DebuffUp(v51.AgonyDebuff)) then
			if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((2711 - (303 + 221)) >= (6223 - (231 + 1038)))) then
				return "phantom_singularity aoe 6";
			end
		end
		if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (5 + 0))) or ((5039 - (171 + 991)) == (14733 - 11158))) then
			if (((1898 - 1191) > (1577 - 945)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
				return "unstable_affliction aoe 8";
			end
		end
		if ((v51.Agony:IsReady() and (v51.AgonyDebuff:AuraActiveCount() < (7 + 1)) and (((v74 * (6 - 4)) + v51.SoulRot:CastTime()) < v69)) or ((1574 - 1028) >= (4325 - 1641))) then
			if (((4528 - 3063) <= (5549 - (111 + 1137))) and v49.CastTargetIf(v51.Agony, v56, "min", v79, v86, not v17:IsSpellInRange(v51.Agony))) then
				return "agony aoe 9";
			end
		end
		if (((1862 - (91 + 67)) > (4241 - 2816)) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (2 + 4)) and v51.SummonDarkglare:CooldownUp() and (v10.CombatTime() < (543 - (423 + 100))) and (((v74 * (1 + 1)) + v51.SoulRot:CastTime()) < v69)) then
			if (v49.CastCycle(v51.SiphonLife, v56, v98, not v17:IsSpellInRange(v51.SiphonLife)) or ((1902 - 1215) == (2207 + 2027))) then
				return "siphon_life aoe 10";
			end
		end
		if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (772 - (326 + 445)))) and v17:DebuffUp(v51.AgonyDebuff)) or ((14532 - 11202) < (3183 - 1754))) then
			if (((2677 - 1530) >= (1046 - (530 + 181))) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
				return "soul_rot aoe 12";
			end
		end
		if (((4316 - (614 + 267)) > (2129 - (19 + 13))) and v51.SeedofCorruption:IsReady() and (v17:DebuffRemains(v51.CorruptionDebuff) < (7 - 2)) and not (v51.SeedofCorruption:InFlight() or v17:DebuffUp(v51.SeedofCorruptionDebuff))) then
			if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((8785 - 5015) >= (11543 - 7502))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if ((v51.Corruption:IsReady() and not v51.SeedofCorruption:IsAvailable()) or ((985 + 2806) <= (2833 - 1222))) then
			if (v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption)) or ((9493 - 4915) <= (3820 - (1293 + 519)))) then
				return "corruption aoe 15";
			end
		end
		if (((2295 - 1170) <= (5420 - 3344)) and v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62 and v47) then
			if (v24(v51.SummonDarkglare) or ((1420 - 677) >= (18968 - 14569))) then
				return "summon_darkglare aoe 18";
			end
		end
		if (((2720 - 1565) < (887 + 786)) and v51.DrainLife:IsReady() and (v13:BuffStack(v51.InevitableDemiseBuff) > (7 + 23)) and v13:BuffUp(v51.SoulRot) and (v13:BuffRemains(v51.SoulRot) <= v74) and (v58 > (6 - 3))) then
			if (v49.CastTargetIf(v51.DrainLife, v56, "min", v83, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((538 + 1786) <= (193 + 385))) then
				return "drain_life aoe 19";
			end
		end
		if (((2355 + 1412) == (4863 - (709 + 387))) and v51.MaleficRapture:IsReady() and v13:BuffUp(v51.UmbrafireKindlingBuff) and ((((v58 < (1864 - (673 + 1185))) or (v10.CombatTime() < (87 - 57))) and v77()) or not v51.DoomBlossom:IsAvailable())) then
			if (((13130 - 9041) == (6727 - 2638)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(72 + 28))) then
				return "malefic_rapture aoe 20";
			end
		end
		if (((3332 + 1126) >= (2259 - 585)) and v51.SeedofCorruption:IsReady() and v51.SowTheSeeds:IsAvailable()) then
			if (((239 + 733) <= (2827 - 1409)) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if ((v51.MaleficRapture:IsReady() and ((((v51.SummonDarkglare:CooldownRemains() > (29 - 14)) or (v71 > (1883 - (446 + 1434)))) and not v51.SowTheSeeds:IsAvailable()) or v13:BuffUp(v51.TormentedCrescendoBuff))) or ((6221 - (1040 + 243)) < (14212 - 9450))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1947 - (559 + 1288))) or ((4435 - (609 + 1322)) > (4718 - (13 + 441)))) then
				return "malefic_rapture aoe 24";
			end
		end
		if (((8045 - 5892) == (5639 - 3486)) and v51.DrainLife:IsReady() and (v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable()) and (v13:BuffStack(v51.InevitableDemiseBuff) > (49 - 39))) then
			if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((19 + 488) >= (9409 - 6818))) then
				return "drain_life aoe 26";
			end
		end
		if (((1592 + 2889) == (1964 + 2517)) and v51.DrainSoul:IsReady() and v13:BuffUp(v51.NightfallBuff) and v51.ShadowEmbrace:IsAvailable()) then
			if (v49.CastCycle(v51.DrainSoul, v56, v95, not v17:IsSpellInRange(v51.DrainSoul)) or ((6908 - 4580) < (380 + 313))) then
				return "drain_soul aoe 28";
			end
		end
		if (((7959 - 3631) == (2862 + 1466)) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
			if (((884 + 704) >= (958 + 374)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
				return "drain_soul aoe 30";
			end
		end
		if ((v51.SummonSoulkeeper:IsReady() and ((v51.SummonSoulkeeper:Count() == (9 + 1)) or ((v51.SummonSoulkeeper:Count() > (3 + 0)) and (v73 < (443 - (153 + 280)))))) or ((12052 - 7878) > (3814 + 434))) then
			if (v24(v51.SummonSoulkeeper) or ((1811 + 2775) <= (43 + 39))) then
				return "soul_strike aoe 32";
			end
		end
		if (((3506 + 357) == (2800 + 1063)) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (7 - 2)) and ((v58 < (5 + 3)) or not v51.DoomBlossom:IsAvailable())) then
			if (v49.CastCycle(v51.SiphonLife, v56, v97, not v17:IsSpellInRange(v51.SiphonLife)) or ((949 - (89 + 578)) <= (31 + 11))) then
				return "siphon_life aoe 34";
			end
		end
		if (((9581 - 4972) >= (1815 - (572 + 477))) and v51.DrainSoul:IsReady()) then
			if (v49.CastCycle(v51.DrainSoul, v56, v96, not v17:IsSpellInRange(v51.DrainSoul)) or ((156 + 996) == (1494 + 994))) then
				return "drain_soul aoe 36";
			end
		end
		if (((409 + 3013) > (3436 - (84 + 2))) and v51.ShadowBolt:IsReady()) then
			if (((1444 - 567) > (271 + 105)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v105()
		if (v31 or ((3960 - (497 + 345)) <= (48 + 1803))) then
			local v161 = v103();
			if (v161 or ((28 + 137) >= (4825 - (605 + 728)))) then
				return v161;
			end
		end
		local v149 = v102();
		if (((2818 + 1131) < (10795 - 5939)) and v149) then
			return v149;
		end
		if ((v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62 and v47) or ((196 + 4080) < (11150 - 8134))) then
			if (((4229 + 461) > (11428 - 7303)) and v24(v51.SummonDarkglare)) then
				return "summon_darkglare cleave 2";
			end
		end
		if ((v51.MaleficRapture:IsReady() and ((v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or (v71 > (493 - (457 + 32))))) or ((22 + 28) >= (2298 - (832 + 570)))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(95 + 5)) or ((447 + 1267) >= (10467 - 7509))) then
				return "malefic_rapture cleave 2";
			end
		end
		if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 + 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (808 - (588 + 208)))))) or ((4018 - 2527) < (2444 - (884 + 916)))) then
			if (((1473 - 769) < (573 + 414)) and v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(693 - (232 + 421)))) then
				return "vile_taint cleave 4";
			end
		end
		if (((5607 - (1569 + 320)) > (468 + 1438)) and v51.VileTaint:IsReady() and (v51.AgonyDebuff:AuraActiveCount() == (1 + 1)) and (v51.CorruptionDebuff:AuraActiveCount() == (6 - 4)) and (not v51.SiphonLife:IsAvailable() or (v51.SiphonLifeDebuff:AuraActiveCount() == (607 - (316 + 289)))) and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (31 - 19))))) then
			if (v24(v55.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v51.VileTaint)) or ((45 + 913) > (5088 - (666 + 787)))) then
				return "vile_taint cleave 10";
			end
		end
		if (((3926 - (360 + 65)) <= (4199 + 293)) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (255 - (79 + 175)))) and (v51.AgonyDebuff:AuraActiveCount() >= (2 - 0))) then
			if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((2686 + 756) < (7810 - 5262))) then
				return "soul_rot cleave 8";
			end
		end
		if (((5536 - 2661) >= (2363 - (503 + 396))) and v51.Agony:IsReady()) then
			if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v87, not v17:IsSpellInRange(v51.Agony)) or ((4978 - (92 + 89)) >= (9491 - 4598))) then
				return "agony cleave 10";
			end
		end
		if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (3 + 2)) and (v73 > (2 + 1))) or ((2157 - 1606) > (283 + 1785))) then
			if (((4819 - 2705) > (824 + 120)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
				return "unstable_affliction cleave 12";
			end
		end
		if ((v51.SeedofCorruption:IsReady() and not v51.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v51.CorruptionDebuff) < (3 + 2)) and v51.SowTheSeeds:IsAvailable() and v76(v56)) or ((6889 - 4627) >= (387 + 2709))) then
			if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((3438 - 1183) >= (4781 - (485 + 759)))) then
				return "seed_of_corruption cleave 14";
			end
		end
		if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (6 - 3))) or ((5026 - (442 + 747)) < (2441 - (832 + 303)))) then
			if (((3896 - (88 + 858)) == (900 + 2050)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
				return "haunt cleave 16";
			end
		end
		if ((v51.Corruption:IsReady() and not (v51.SeedofCorruption:InFlight() or (v17:DebuffRemains(v51.SeedofCorruptionDebuff) > (0 + 0))) and (v73 > (1 + 4))) or ((5512 - (766 + 23)) < (16281 - 12983))) then
			if (((1552 - 416) >= (405 - 251)) and v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption cleave 18";
			end
		end
		if ((v51.SiphonLife:IsReady() and (v73 > (16 - 11))) or ((1344 - (1036 + 37)) > (3367 + 1381))) then
			if (((9230 - 4490) >= (2480 + 672)) and v49.CastTargetIf(v51.SiphonLife, v56, "min", v82, v90, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life cleave 20";
			end
		end
		if ((v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (1483 - (641 + 839)))) and v59 and v60 and v62 and v47) or ((3491 - (910 + 3)) >= (8642 - 5252))) then
			if (((1725 - (1466 + 218)) <= (764 + 897)) and v24(v51.SummonDarkglare)) then
				return "summon_darkglare cleave 22";
			end
		end
		if (((1749 - (556 + 592)) < (1266 + 2294)) and v51.MaleficRapture:IsReady() and v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (809 - (329 + 479))) and (v71 > (857 - (174 + 680)))) then
			if (((807 - 572) < (1423 - 736)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(72 + 28))) then
				return "malefic_rapture cleave 24";
			end
		end
		if (((5288 - (396 + 343)) > (103 + 1050)) and v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (1480 - (29 + 1448))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1392 - (135 + 1254))))) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((17607 - 12933) < (21814 - 17142))) then
				return "drain_soul cleave 26";
			end
		end
		if (((2445 + 1223) < (6088 - (389 + 1138))) and v70:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
			if (v49.CastTargetIf(v70, v56, "min", v81, v89, not v17:IsSpellInRange(v70)) or ((1029 - (102 + 472)) == (3403 + 202))) then
				return "drain_soul/shadow_bolt cleave 28";
			end
		end
		if ((v51.MaleficRapture:IsReady() and not v51.DreadTouch:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff)) or ((1477 + 1186) == (3089 + 223))) then
			if (((5822 - (320 + 1225)) <= (7966 - 3491)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(62 + 38))) then
				return "malefic_rapture cleave 30";
			end
		end
		if ((v51.MaleficRapture:IsReady() and (v63 or v61)) or ((2334 - (157 + 1307)) == (3048 - (821 + 1038)))) then
			if (((3874 - 2321) <= (343 + 2790)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(177 - 77))) then
				return "malefic_rapture cleave 32";
			end
		end
		if ((v51.MaleficRapture:IsReady() and (v71 > (2 + 1))) or ((5544 - 3307) >= (4537 - (834 + 192)))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(7 + 93)) or ((340 + 984) > (65 + 2955))) then
				return "malefic_rapture cleave 34";
			end
		end
		if ((v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (74 - 26)) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (324 - (300 + 4))) and (v73 < (2 + 2))))) or ((7832 - 4840) == (2243 - (112 + 250)))) then
			if (((1239 + 1867) > (3822 - 2296)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 36";
			end
		end
		if (((1732 + 1291) < (2002 + 1868)) and v51.DrainLife:IsReady() and v13:BuffUp(v51.SoulRot) and (v13:BuffStack(v51.InevitableDemiseBuff) > (23 + 7))) then
			if (((71 + 72) > (55 + 19)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 38";
			end
		end
		if (((1432 - (1001 + 413)) < (4709 - 2597)) and v51.Agony:IsReady()) then
			if (((1979 - (244 + 638)) <= (2321 - (627 + 66))) and v49.CastCycle(v51.Agony, v56, v92, not v17:IsSpellInRange(v51.Agony))) then
				return "agony cleave 40";
			end
		end
		if (((13795 - 9165) == (5232 - (512 + 90))) and v51.Corruption:IsCastable()) then
			if (((5446 - (1665 + 241)) > (3400 - (373 + 344))) and v49.CastCycle(v51.Corruption, v56, v94, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption cleave 42";
			end
		end
		if (((2163 + 2631) >= (867 + 2408)) and v51.MaleficRapture:IsReady() and (v71 > (2 - 1))) then
			if (((2511 - 1027) == (2583 - (35 + 1064))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(73 + 27))) then
				return "malefic_rapture cleave 44";
			end
		end
		if (((3063 - 1631) < (15 + 3540)) and v51.DrainSoul:IsReady()) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((2301 - (298 + 938)) > (4837 - (233 + 1026)))) then
				return "drain_soul cleave 54";
			end
		end
		if (v70:IsReady() or ((6461 - (636 + 1030)) < (720 + 687))) then
			if (((1810 + 43) < (1430 + 3383)) and v24(v70, nil, nil, not v17:IsSpellInRange(v70))) then
				return "drain_soul/shadow_bolt cleave 46";
			end
		end
	end
	local function v106()
		v48();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v56 = v13:GetEnemiesInRange(3 + 37);
		v57 = v17:GetEnemiesInSplashRange(231 - (55 + 166));
		if (v30 or ((547 + 2274) < (245 + 2186))) then
			v58 = v28(#v57, #v56);
		else
			v58 = 3 - 2;
		end
		if (v49.TargetIsValid() or v13:AffectingCombat() or ((3171 - (36 + 261)) < (3814 - 1633))) then
			local v162 = 1368 - (34 + 1334);
			while true do
				if ((v162 == (0 + 0)) or ((2090 + 599) <= (1626 - (1035 + 248)))) then
					v72 = v10.BossFightRemains(nil, true);
					v73 = v72;
					v162 = 22 - (20 + 1);
				end
				if ((v162 == (1 + 0)) or ((2188 - (134 + 185)) == (3142 - (549 + 584)))) then
					if ((v73 == (11796 - (314 + 371))) or ((12173 - 8627) < (3290 - (478 + 490)))) then
						v73 = v10.FightRemains(v57, false);
					end
					break;
				end
			end
		end
		v71 = v13:SoulShardsP();
		v66 = v75(v57, v51.AgonyDebuff);
		v67 = v75(v57, v51.VileTaintDebuff);
		v68 = v75(v57, v51.PhantomSingularityDebuff);
		v69 = v28(v67 * v26(v51.VileTaint:IsAvailable()), v68 * v26(v51.PhantomSingularity:IsAvailable()));
		v74 = v13:GCD() + 0.25 + 0;
		if ((v51.SummonPet:IsCastable() and v43 and not v16:IsActive()) or ((3254 - (786 + 386)) == (15459 - 10686))) then
			if (((4623 - (1055 + 324)) > (2395 - (1093 + 247))) and v25(v51.SummonPet)) then
				return "summon_pet ooc";
			end
		end
		if (v49.TargetIsValid() or ((2945 + 368) <= (187 + 1591))) then
			if ((not v13:AffectingCombat() and v29) or ((5641 - 4220) >= (7140 - 5036))) then
				local v165 = v99();
				if (((5155 - 3343) <= (8164 - 4915)) and v165) then
					return v165;
				end
			end
			if (((578 + 1045) <= (7539 - 5582)) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v166 = v49.Interrupt(v51.SpellLock, 137 - 97, true);
				if (((3327 + 1085) == (11283 - 6871)) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.SpellLock, 728 - (364 + 324), true, v15, v55.SpellLockMouseover);
				if (((4797 - 3047) >= (2020 - 1178)) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.AxeToss, 14 + 26, true);
				if (((18293 - 13921) > (2962 - 1112)) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.AxeToss, 121 - 81, true, v15, v55.AxeTossMouseover);
				if (((1500 - (1249 + 19)) < (742 + 79)) and v166) then
					return v166;
				end
				v166 = v49.InterruptWithStun(v51.AxeToss, 155 - 115, true);
				if (((1604 - (686 + 400)) < (708 + 194)) and v166) then
					return v166;
				end
				v166 = v49.InterruptWithStun(v51.AxeToss, 269 - (73 + 156), true, v15, v55.AxeTossMouseover);
				if (((15 + 2979) > (1669 - (721 + 90))) and v166) then
					return v166;
				end
			end
			v100();
			if (((v58 > (1 + 0)) and (v58 < (9 - 6))) or ((4225 - (224 + 246)) <= (1482 - 567))) then
				local v167 = 0 - 0;
				local v168;
				while true do
					if (((716 + 3230) > (90 + 3653)) and ((0 + 0) == v167)) then
						v168 = v105();
						if (v168 or ((2654 - 1319) >= (11001 - 7695))) then
							return v168;
						end
						break;
					end
				end
			end
			if (((5357 - (203 + 310)) > (4246 - (1238 + 755))) and (v58 > (1 + 1))) then
				local v169 = 1534 - (709 + 825);
				local v170;
				while true do
					if (((832 - 380) == (657 - 205)) and (v169 == (864 - (196 + 668)))) then
						v170 = v104();
						if (v170 or ((17992 - 13435) < (4322 - 2235))) then
							return v170;
						end
						break;
					end
				end
			end
			if (((4707 - (171 + 662)) == (3967 - (4 + 89))) and v23()) then
				local v171 = 0 - 0;
				local v172;
				while true do
					if ((v171 == (0 + 0)) or ((8512 - 6574) > (1936 + 2999))) then
						v172 = v103();
						if (v172 or ((5741 - (35 + 1451)) < (4876 - (28 + 1425)))) then
							return v172;
						end
						break;
					end
				end
			end
			if (((3447 - (941 + 1052)) <= (2389 + 102)) and v33) then
				local v173 = v102();
				if (v173 or ((5671 - (822 + 692)) <= (4000 - 1197))) then
					return v173;
				end
			end
			if (((2286 + 2567) >= (3279 - (45 + 252))) and v51.MaleficRapture:IsReady() and v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) then
				if (((1423 + 2711) > (8169 - 4812)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(533 - (114 + 319)))) then
					return "malefic_rapture main 2";
				end
			end
			if ((v51.MaleficRapture:IsReady() and (v73 < (5 - 1))) or ((4378 - 961) < (1616 + 918))) then
				if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(148 - 48)) or ((5703 - 2981) <= (2127 - (556 + 1407)))) then
					return "malefic_rapture main 4";
				end
			end
			if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1207.5 - (741 + 465))) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (477 - (170 + 295)))))) or ((1269 + 1139) < (1938 + 171))) then
				if (v24(v55.VileTaintCursor, v45, nil, not v17:IsInRange(98 - 58)) or ((28 + 5) == (934 + 521))) then
					return "vile_taint main 6";
				end
			end
			if ((v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (15 + 10))))) and v17:DebuffUp(v51.AgonyDebuff)) or ((1673 - (957 + 273)) >= (1074 + 2941))) then
				if (((1354 + 2028) > (632 - 466)) and v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity))) then
					return "phantom_singularity main 8";
				end
			end
			if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (2 - 1))) and v17:DebuffUp(v51.AgonyDebuff)) or ((855 - 575) == (15147 - 12088))) then
				if (((3661 - (389 + 1391)) > (812 + 481)) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
					return "soul_rot main 10";
				end
			end
			if (((246 + 2111) == (5365 - 3008)) and v51.Agony:IsCastable() and (not v51.VileTaint:IsAvailable() or (v17:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime()))) and (v17:DebuffRemains(v51.AgonyDebuff) < (956 - (783 + 168))) and (v73 > (16 - 11))) then
				if (((121 + 2) == (434 - (309 + 2))) and v24(v51.Agony, nil, nil, not v17:IsSpellInRange(v51.Agony))) then
					return "agony main 12";
				end
			end
			if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (15 - 10)) and (v73 > (1215 - (1090 + 122)))) or ((343 + 713) >= (11391 - 7999))) then
				if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((740 + 341) < (2193 - (628 + 490)))) then
					return "unstable_affliction main 14";
				end
			end
			if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1 + 4))) or ((2596 - 1547) >= (20254 - 15822))) then
				if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((5542 - (431 + 343)) <= (1708 - 862))) then
					return "haunt main 16";
				end
			end
			if ((v51.Corruption:IsCastable() and v17:DebuffRefreshable(v51.CorruptionDebuff) and (v73 > (14 - 9))) or ((2653 + 705) <= (182 + 1238))) then
				if (v24(v51.Corruption, nil, nil, not v17:IsSpellInRange(v51.Corruption)) or ((5434 - (556 + 1139)) <= (3020 - (6 + 9)))) then
					return "corruption main 18";
				end
			end
			if ((v51.SiphonLife:IsCastable() and v17:DebuffRefreshable(v51.SiphonLifeDebuff) and (v73 > (1 + 4))) or ((850 + 809) >= (2303 - (28 + 141)))) then
				if (v24(v51.SiphonLife, nil, nil, not v17:IsSpellInRange(v51.SiphonLife)) or ((1263 + 1997) < (2906 - 551))) then
					return "siphon_life main 20";
				end
			end
			if ((v51.SummonDarkglare:IsReady() and v47 and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (3 + 0))) and v59 and v60 and v62) or ((1986 - (486 + 831)) == (10989 - 6766))) then
				if (v24(v51.SummonDarkglare) or ((5956 - 4264) < (112 + 476))) then
					return "summon_darkglare main 22";
				end
			end
			if ((v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (9 - 6)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1266 - (668 + 595))))) or ((4317 + 480) < (737 + 2914))) then
				if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((11391 - 7214) > (5140 - (23 + 267)))) then
					return "drain_soul main 24";
				end
			end
			if ((v51.ShadowBolt:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (1947 - (1129 + 815))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (390 - (371 + 16))))) or ((2150 - (1326 + 424)) > (2104 - 993))) then
				if (((11149 - 8098) > (1123 - (88 + 30))) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 26";
				end
			end
			if (((4464 - (720 + 51)) <= (9747 - 5365)) and v51.MaleficRapture:IsReady() and ((v71 > (1780 - (421 + 1355))) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 - 0)) and (v71 > (2 + 1))) or (v51.TormentedCrescendo:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v17:DebuffDown(v51.DreadTouchDebuff)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1085 - (286 + 797)))) or v63 or (v61 and (v71 > (3 - 2))) or (v51.TormentedCrescendo:IsAvailable() and v51.Nightfall:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v13:BuffUp(v51.NightfallBuff)))) then
				if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(165 - 65)) or ((3721 - (397 + 42)) > (1281 + 2819))) then
					return "malefic_rapture main 28";
				end
			end
			if ((v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (848 - (24 + 776))) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (30 - 10)) and (v73 < (789 - (222 + 563)))))) or ((7887 - 4307) < (2048 + 796))) then
				if (((279 - (23 + 167)) < (6288 - (690 + 1108))) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
					return "drain_life main 30";
				end
			end
			if ((v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((1798 + 3185) < (1492 + 316))) then
				if (((4677 - (40 + 808)) > (621 + 3148)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
					return "drain_soul main 32";
				end
			end
			if (((5678 - 4193) <= (2776 + 128)) and v51.ShadowBolt:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
				if (((2259 + 2010) == (2342 + 1927)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 34";
				end
			end
			if (((958 - (47 + 524)) <= (1806 + 976)) and v51.DrainSoul:IsReady()) then
				if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((5190 - 3291) <= (1370 - 453))) then
					return "drain_soul main 36";
				end
			end
			if (v51.ShadowBolt:IsReady() or ((9833 - 5521) <= (2602 - (1165 + 561)))) then
				if (((67 + 2165) <= (8040 - 5444)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 38";
				end
			end
		end
	end
	local function v107()
		local v153 = 0 + 0;
		while true do
			if (((2574 - (341 + 138)) < (996 + 2690)) and (v153 == (0 - 0))) then
				v10.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v51.AgonyDebuff:RegisterAuraTracking();
				v153 = 327 - (89 + 237);
			end
			if ((v153 == (3 - 2)) or ((3357 - 1762) >= (5355 - (581 + 300)))) then
				v51.SiphonLifeDebuff:RegisterAuraTracking();
				v51.CorruptionDebuff:RegisterAuraTracking();
				v153 = 1222 - (855 + 365);
			end
			if ((v153 == (4 - 2)) or ((1509 + 3110) < (4117 - (1030 + 205)))) then
				v51.UnstableAfflictionDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v10.SetAPL(249 + 16, v106, v107);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

