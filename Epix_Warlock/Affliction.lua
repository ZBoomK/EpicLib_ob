local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((1573 - 1005) > (33 + 395)) and not v6) then
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
		v36 = EpicSettings.Settings['HealingPotionHP'] or (939 - (714 + 225));
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['SummonPet'];
		v44 = EpicSettings.Settings['DarkPactHP'] or (806 - (118 + 688));
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
	local v71 = 48 - (25 + 23);
	local v72 = 2153 + 8958;
	local v73 = 12997 - (927 + 959);
	local v74;
	v10:RegisterForEvent(function()
		local v116 = 0 - 0;
		while true do
			if (((2066 - (16 + 716)) <= (8904 - 4291)) and (v116 == (97 - (11 + 86)))) then
				v51.SeedofCorruption:RegisterInFlight();
				v51.ShadowBolt:RegisterInFlight();
				v116 = 2 - 1;
			end
			if ((v116 == (286 - (175 + 110))) or ((4708 - 2843) >= (10007 - 7978))) then
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
		v72 = 12907 - (503 + 1293);
		v73 = 31030 - 19919;
	end, "PLAYER_REGEN_ENABLED");
	local function v75(v117, v118)
		if (((3580 + 1370) >= (2677 - (810 + 251))) and (not v117 or not v118)) then
			return 0 + 0;
		end
		local v119;
		for v153, v154 in pairs(v117) do
			local v155 = 0 + 0;
			local v156;
			while true do
				if (((1556 + 169) == (2258 - (43 + 490))) and (v155 == (733 - (711 + 22)))) then
					v156 = v154:DebuffRemains(v118) + ((382 - 283) * v26(v154:DebuffDown(v118)));
					if (((2318 - (240 + 619)) <= (599 + 1883)) and ((v119 == nil) or (v156 < v119))) then
						v119 = v156;
					end
					break;
				end
			end
		end
		return v119 or (0 - 0);
	end
	local function v76(v120)
		local v121 = 0 + 0;
		local v122;
		local v123;
		while true do
			if ((v121 == (1746 - (1344 + 400))) or ((3101 - (255 + 150)) >= (3570 + 962))) then
				for v162, v163 in pairs(v120) do
					local v164 = 0 + 0;
					while true do
						if (((4477 - 3429) >= (167 - 115)) and (v164 == (1739 - (404 + 1335)))) then
							v122 = v122 + (407 - (183 + 223));
							if (((3598 - 640) < (2984 + 1519)) and v163:DebuffUp(v51.SeedofCorruptionDebuff)) then
								v123 = v123 + 1 + 0;
							end
							break;
						end
					end
				end
				return v122 == v123;
			end
			if ((v121 == (338 - (10 + 327))) or ((1905 + 830) == (1647 - (118 + 220)))) then
				v122 = 0 + 0;
				v123 = 449 - (108 + 341);
				v121 = 1 + 1;
			end
			if (((0 - 0) == v121) or ((5623 - (711 + 782)) <= (5664 - 2709))) then
				if (not v120 or (#v120 == (469 - (270 + 199))) or ((637 + 1327) <= (3159 - (580 + 1239)))) then
					return false;
				end
				if (((7428 - 4929) == (2390 + 109)) and (v51.SeedofCorruption:InFlight() or v13:PrevGCDP(1 + 0, v51.SeedofCorruption))) then
					return false;
				end
				v121 = 1 + 0;
			end
		end
	end
	local function v77()
		return v50.GuardiansTable.DarkglareDuration > (0 - 0);
	end
	local function v78()
		return v50.GuardiansTable.DarkglareDuration;
	end
	local function v79(v124)
		return (v124:DebuffRemains(v51.AgonyDebuff));
	end
	local function v80(v125)
		return (v125:DebuffRemains(v51.CorruptionDebuff));
	end
	local function v81(v126)
		return (v126:DebuffRemains(v51.ShadowEmbraceDebuff));
	end
	local function v82(v127)
		return (v127:DebuffRemains(v51.SiphonLifeDebuff));
	end
	local function v83(v128)
		return (v128:DebuffRemains(v51.SoulRotDebuff));
	end
	local function v84(v129)
		return (v129:DebuffRemains(v51.AgonyDebuff) < (v129:DebuffRemains(v51.VileTaintDebuff) + v51.VileTaint:CastTime())) and (v129:DebuffRemains(v51.AgonyDebuff) < (4 + 1));
	end
	local function v85(v130)
		return v130:DebuffRemains(v51.AgonyDebuff) < (1172 - (645 + 522));
	end
	local function v86(v131)
		return ((v131:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v131:DebuffRemains(v51.AgonyDebuff) < (1795 - (1010 + 780)));
	end
	local function v87(v132)
		return ((v132:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v132:DebuffRemains(v51.AgonyDebuff) < (5 + 0)) and (v73 > (23 - 18));
	end
	local function v88(v133)
		return v133:DebuffRemains(v51.CorruptionDebuff) < (14 - 9);
	end
	local function v89(v134)
		return (v51.ShadowEmbrace:IsAvailable() and ((v134:DebuffStack(v51.ShadowEmbraceDebuff) < (1839 - (1045 + 791))) or (v134:DebuffRemains(v51.ShadowEmbraceDebuff) < (7 - 4)))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v90(v135)
		return (v135:DebuffRefreshable(v51.SiphonLifeDebuff));
	end
	local function v91(v136)
		return v136:DebuffRemains(v51.AgonyDebuff) < (7 - 2);
	end
	local function v92(v137)
		return (v137:DebuffRefreshable(v51.AgonyDebuff));
	end
	local function v93(v138)
		return v138:DebuffRemains(v51.CorruptionDebuff) < (510 - (351 + 154));
	end
	local function v94(v139)
		return (v139:DebuffRefreshable(v51.CorruptionDebuff));
	end
	local function v95(v140)
		return (v140:DebuffStack(v51.ShadowEmbraceDebuff) < (1577 - (1281 + 293))) or (v140:DebuffRemains(v51.ShadowEmbraceDebuff) < (269 - (28 + 238)));
	end
	local function v96(v141)
		return (v51.ShadowEmbrace:IsAvailable() and ((v141:DebuffStack(v51.ShadowEmbraceDebuff) < (6 - 3)) or (v141:DebuffRemains(v51.ShadowEmbraceDebuff) < (1562 - (1381 + 178))))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v97(v142)
		return v142:DebuffRemains(v51.SiphonLifeDebuff) < (5 + 0);
	end
	local function v98(v143)
		return (v143:DebuffRemains(v51.SiphonLifeDebuff) < (5 + 0)) and v143:DebuffUp(v51.AgonyDebuff);
	end
	local function v99()
		if (v51.GrimoireofSacrifice:IsCastable() or ((962 + 1293) < (75 - 53))) then
			if (v25(v51.GrimoireofSacrifice) or ((563 + 523) >= (1875 - (381 + 89)))) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (v51.Haunt:IsReady() or ((2101 + 268) == (289 + 137))) then
			if (v25(v51.Haunt, not v17:IsSpellInRange(v51.Haunt), true) or ((5268 - 2192) > (4339 - (1074 + 82)))) then
				return "haunt precombat 6";
			end
		end
		if (((2633 - 1431) > (2842 - (214 + 1570))) and v51.UnstableAffliction:IsReady() and not v51.SoulSwap:IsAvailable()) then
			if (((5166 - (990 + 465)) > (1384 + 1971)) and v25(v51.UnstableAffliction, not v17:IsSpellInRange(v51.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (v51.ShadowBolt:IsReady() or ((395 + 511) >= (2168 + 61))) then
			if (((5068 - 3780) > (2977 - (1668 + 58))) and v25(v51.ShadowBolt, not v17:IsSpellInRange(v51.ShadowBolt), true)) then
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
		v65 = not v64 or (v63 and ((v51.SummonDarkglare:CooldownRemains() > (646 - (512 + 114))) or not v51.SummonDarkglare:IsAvailable()));
	end
	local function v101()
		local v144 = 0 - 0;
		local v145;
		while true do
			if ((v144 == (1 - 0)) or ((15703 - 11190) < (1560 + 1792))) then
				v145 = v49.HandleBottomTrinket(v53, v31, 8 + 32, nil);
				if (v145 or ((1796 + 269) >= (10779 - 7583))) then
					return v145;
				end
				break;
			end
			if ((v144 == (1994 - (109 + 1885))) or ((5845 - (1269 + 200)) <= (2838 - 1357))) then
				v145 = v49.HandleTopTrinket(v53, v31, 855 - (98 + 717), nil);
				if (v145 or ((4218 - (802 + 24)) >= (8175 - 3434))) then
					return v145;
				end
				v144 = 1 - 0;
			end
		end
	end
	local function v102()
		local v146 = v101();
		if (((492 + 2833) >= (1655 + 499)) and v146) then
			return v146;
		end
		if (v52.DesperateInvokersCodex:IsEquippedAndReady() or ((213 + 1082) >= (698 + 2535))) then
			if (((12176 - 7799) > (5475 - 3833)) and v25(v55.DesperateInvokersCodex, not v17:IsInRange(17 + 28))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (((1923 + 2800) > (1119 + 237)) and v52.ConjuredChillglobe:IsEquippedAndReady()) then
			if (v25(v55.ConjuredChillglobe) or ((3008 + 1128) <= (1603 + 1830))) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v103()
		if (((5678 - (797 + 636)) <= (22485 - 17854)) and v65) then
			local v157 = 1619 - (1427 + 192);
			local v158;
			while true do
				if (((1482 + 2794) >= (9086 - 5172)) and ((2 + 0) == v157)) then
					if (((90 + 108) <= (4691 - (192 + 134))) and v51.Fireblood:IsCastable()) then
						if (((6058 - (316 + 960)) > (2603 + 2073)) and v25(v51.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if (((3754 + 1110) > (2031 + 166)) and (v157 == (3 - 2))) then
					if (v51.Berserking:IsCastable() or ((4251 - (83 + 468)) == (4313 - (1202 + 604)))) then
						if (((20885 - 16411) >= (455 - 181)) and v25(v51.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v51.BloodFury:IsCastable() or ((5243 - 3349) <= (1731 - (45 + 280)))) then
						if (((1518 + 54) >= (1338 + 193)) and v25(v51.BloodFury)) then
							return "blood_fury ogcd 6";
						end
					end
					v157 = 1 + 1;
				end
				if ((v157 == (0 + 0)) or ((825 + 3862) < (8410 - 3868))) then
					v158 = v49.HandleDPSPotion();
					if (((5202 - (340 + 1571)) > (658 + 1009)) and v158) then
						return v158;
					end
					v157 = 1773 - (1733 + 39);
				end
			end
		end
	end
	local function v104()
		if (v31 or ((2398 - 1525) == (3068 - (125 + 909)))) then
			local v159 = 1948 - (1096 + 852);
			local v160;
			while true do
				if (((0 + 0) == v159) or ((4020 - 1204) < (11 + 0))) then
					v160 = v103();
					if (((4211 - (409 + 103)) < (4942 - (46 + 190))) and v160) then
						return v160;
					end
					break;
				end
			end
		end
		local v147 = v102();
		if (((2741 - (51 + 44)) >= (248 + 628)) and v147) then
			return v147;
		end
		if (((1931 - (1114 + 203)) <= (3910 - (228 + 498))) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1 + 2))) then
			if (((1727 + 1399) == (3789 - (174 + 489))) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
				return "haunt aoe 2";
			end
		end
		if ((v51.VileTaint:IsReady() and (((v51.SouleatersGluttony:TalentRank() == (5 - 3)) and ((v66 < (1906.5 - (830 + 1075))) or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()))) or ((v51.SouleatersGluttony:TalentRank() == (525 - (303 + 221))) and (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and ((v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (v51.VileTaint:CooldownRemains() > (1294 - (231 + 1038))))))) or ((1823 + 364) >= (6116 - (171 + 991)))) then
			if (v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(164 - 124)) or ((10410 - 6533) == (8921 - 5346))) then
				return "vile_taint aoe 4";
			end
		end
		if (((566 + 141) > (2215 - 1583)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:IsAvailable() and (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (72 - 47))))) and v17:DebuffUp(v51.AgonyDebuff)) then
			if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((879 - 333) >= (8296 - 5612))) then
				return "phantom_singularity aoe 6";
			end
		end
		if (((2713 - (111 + 1137)) <= (4459 - (91 + 67))) and v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (14 - 9))) then
			if (((426 + 1278) > (1948 - (423 + 100))) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
				return "unstable_affliction aoe 8";
			end
		end
		if ((v51.Agony:IsReady() and (v51.AgonyDebuff:AuraActiveCount() < (1 + 7)) and (((v74 * (5 - 3)) + v51.SoulRot:CastTime()) < v69)) or ((359 + 328) == (5005 - (326 + 445)))) then
			if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v86, not v17:IsSpellInRange(v51.Agony)) or ((14532 - 11202) < (3183 - 1754))) then
				return "agony aoe 9";
			end
		end
		if (((2677 - 1530) >= (1046 - (530 + 181))) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (887 - (614 + 267))) and v51.SummonDarkglare:CooldownUp() and (v10.CombatTime() < (52 - (19 + 13))) and (((v74 * (2 - 0)) + v51.SoulRot:CastTime()) < v69)) then
			if (((8004 - 4569) > (5990 - 3893)) and v49.CastCycle(v51.SiphonLife, v56, v98, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life aoe 10";
			end
		end
		if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v17:DebuffUp(v51.AgonyDebuff)) or ((6630 - 2860) >= (8380 - 4339))) then
			if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((5603 - (1293 + 519)) <= (3286 - 1675))) then
				return "soul_rot aoe 12";
			end
		end
		if ((v51.SeedofCorruption:IsReady() and (v17:DebuffRemains(v51.CorruptionDebuff) < (13 - 8)) and not (v51.SeedofCorruption:InFlight() or v17:DebuffUp(v51.SeedofCorruptionDebuff))) or ((8754 - 4176) <= (8658 - 6650))) then
			if (((2650 - 1525) <= (1100 + 976)) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if ((v51.Corruption:IsReady() and not v51.SeedofCorruption:IsAvailable()) or ((152 + 591) >= (10220 - 5821))) then
			if (((267 + 888) < (556 + 1117)) and v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption aoe 15";
			end
		end
		if ((v31 and v51.SummonDarkglare:IsCastable() and ((v59 and v60 and v62) or not v51.SoulRot:IsAvailable()) and v47) or ((1453 + 871) <= (1674 - (709 + 387)))) then
			if (((5625 - (673 + 1185)) == (10924 - 7157)) and v24(v51.SummonDarkglare)) then
				return "summon_darkglare aoe 18";
			end
		end
		if (((13130 - 9041) == (6727 - 2638)) and v51.DrainLife:IsReady() and (v13:BuffStack(v51.InevitableDemiseBuff) > (22 + 8)) and v13:BuffUp(v51.SoulRot) and (v13:BuffRemains(v51.SoulRot) <= v74) and (v58 > (3 + 0))) then
			if (((6018 - 1560) >= (412 + 1262)) and v49.CastTargetIf(v51.DrainLife, v56, "min", v83, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life aoe 19";
			end
		end
		if (((1937 - 965) <= (2783 - 1365)) and v51.MaleficRapture:IsReady() and v13:BuffUp(v51.UmbrafireKindlingBuff) and ((((v58 < (1886 - (446 + 1434))) or (v10.CombatTime() < (1313 - (1040 + 243)))) and v77()) or not v51.DoomBlossom:IsAvailable())) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(298 - 198)) or ((6785 - (559 + 1288)) < (6693 - (609 + 1322)))) then
				return "malefic_rapture aoe 20";
			end
		end
		if ((v51.SeedofCorruption:IsReady() and v51.SowTheSeeds:IsAvailable()) or ((2958 - (13 + 441)) > (15933 - 11669))) then
			if (((5639 - 3486) == (10722 - 8569)) and v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if ((v51.MaleficRapture:IsReady() and ((((v51.SummonDarkglare:CooldownRemains() > (1 + 14)) or (v71 > (10 - 7))) and not v51.SowTheSeeds:IsAvailable()) or v13:BuffUp(v51.TormentedCrescendoBuff))) or ((181 + 326) >= (1136 + 1455))) then
			if (((13297 - 8816) == (2453 + 2028)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(183 - 83))) then
				return "malefic_rapture aoe 24";
			end
		end
		if ((v51.DrainLife:IsReady() and (v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable()) and (v13:BuffStack(v51.InevitableDemiseBuff) > (7 + 3))) or ((1295 + 1033) < (498 + 195))) then
			if (((3635 + 693) == (4235 + 93)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life aoe 26";
			end
		end
		if (((2021 - (153 + 280)) >= (3845 - 2513)) and v51.DrainSoul:IsReady() and v13:BuffUp(v51.NightfallBuff) and v51.ShadowEmbrace:IsAvailable()) then
			if (v49.CastCycle(v51.DrainSoul, v56, v95, not v17:IsSpellInRange(v51.DrainSoul)) or ((3748 + 426) > (1678 + 2570))) then
				return "drain_soul aoe 28";
			end
		end
		if ((v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((2400 + 2186) <= (75 + 7))) then
			if (((2800 + 1063) == (5882 - 2019)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
				return "drain_soul aoe 30";
			end
		end
		if ((v51.SummonSoulkeeper:IsReady() and ((v51.SummonSoulkeeper:Count() == (7 + 3)) or ((v51.SummonSoulkeeper:Count() > (670 - (89 + 578))) and (v73 < (8 + 2))))) or ((585 - 303) <= (1091 - (572 + 477)))) then
			if (((622 + 3987) >= (460 + 306)) and v24(v51.SummonSoulkeeper)) then
				return "soul_strike aoe 32";
			end
		end
		if ((v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (1 + 4)) and ((v58 < (94 - (84 + 2))) or not v51.DoomBlossom:IsAvailable())) or ((1897 - 745) == (1793 + 695))) then
			if (((4264 - (497 + 345)) > (86 + 3264)) and v49.CastCycle(v51.SiphonLife, v56, v97, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life aoe 34";
			end
		end
		if (((149 + 728) > (1709 - (605 + 728))) and v51.DrainSoul:IsReady()) then
			if (v49.CastCycle(v51.DrainSoul, v56, v96, not v17:IsSpellInRange(v51.DrainSoul)) or ((2225 + 893) <= (4115 - 2264))) then
				return "drain_soul aoe 36";
			end
		end
		if (v51.ShadowBolt:IsReady() or ((8 + 157) >= (12910 - 9418))) then
			if (((3561 + 388) < (13453 - 8597)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v105()
		if (v31 or ((3229 + 1047) < (3505 - (457 + 32)))) then
			local v161 = v103();
			if (((1990 + 2700) > (5527 - (832 + 570))) and v161) then
				return v161;
			end
		end
		local v148 = v102();
		if (v148 or ((48 + 2) >= (234 + 662))) then
			return v148;
		end
		if ((v31 and v51.SummonDarkglare:IsCastable() and ((v59 and v60 and v62) or not v51.SoulRot:IsAvailable()) and v47) or ((6065 - 4351) >= (1425 + 1533))) then
			if (v24(v51.SummonDarkglare) or ((2287 - (588 + 208)) < (1735 - 1091))) then
				return "summon_darkglare cleave 2";
			end
		end
		if (((2504 - (884 + 916)) < (2065 - 1078)) and v51.MaleficRapture:IsReady() and ((v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or (v71 > (657 - (232 + 421))))) then
			if (((5607 - (1569 + 320)) > (468 + 1438)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(19 + 81))) then
				return "malefic_rapture cleave 2";
			end
		end
		if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (3.5 - 2)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (617 - (316 + 289)))))) or ((2507 - 1549) > (168 + 3467))) then
			if (((4954 - (666 + 787)) <= (4917 - (360 + 65))) and v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(38 + 2))) then
				return "vile_taint cleave 4";
			end
		end
		if ((v51.VileTaint:IsReady() and (v51.AgonyDebuff:AuraActiveCount() == (256 - (79 + 175))) and (v51.CorruptionDebuff:AuraActiveCount() == (2 - 0)) and (not v51.SiphonLife:IsAvailable() or (v51.SiphonLifeDebuff:AuraActiveCount() == (2 + 0))) and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (36 - 24))))) or ((6628 - 3186) < (3447 - (503 + 396)))) then
			if (((3056 - (92 + 89)) >= (2839 - 1375)) and v24(v55.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v51.VileTaint))) then
				return "vile_taint cleave 10";
			end
		end
		if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v51.AgonyDebuff:AuraActiveCount() >= (2 + 0))) or ((18785 - 13988) >= (670 + 4223))) then
			if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((1256 - 705) > (1805 + 263))) then
				return "soul_rot cleave 8";
			end
		end
		if (((1010 + 1104) > (2875 - 1931)) and v51.Agony:IsReady()) then
			if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v87, not v17:IsSpellInRange(v51.Agony)) or ((283 + 1979) >= (4721 - 1625))) then
				return "agony cleave 10";
			end
		end
		if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (1249 - (485 + 759))) and (v73 > (6 - 3))) or ((3444 - (442 + 747)) >= (4672 - (832 + 303)))) then
			if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((4783 - (88 + 858)) < (399 + 907))) then
				return "unstable_affliction cleave 12";
			end
		end
		if (((2442 + 508) == (122 + 2828)) and v51.SeedofCorruption:IsReady() and not v51.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v51.CorruptionDebuff) < (794 - (766 + 23))) and v51.SowTheSeeds:IsAvailable() and v76(v56)) then
			if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((23316 - 18593) < (4510 - 1212))) then
				return "seed_of_corruption cleave 14";
			end
		end
		if (((2992 - 1856) >= (522 - 368)) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (1076 - (1036 + 37)))) then
			if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((193 + 78) > (9245 - 4497))) then
				return "haunt cleave 16";
			end
		end
		if (((3729 + 1011) >= (4632 - (641 + 839))) and v51.Corruption:IsReady() and not (v51.SeedofCorruption:InFlight() or (v17:DebuffRemains(v51.SeedofCorruptionDebuff) > (913 - (910 + 3)))) and (v73 > (12 - 7))) then
			if (v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption)) or ((4262 - (1466 + 218)) >= (1559 + 1831))) then
				return "corruption cleave 18";
			end
		end
		if (((1189 - (556 + 592)) <= (591 + 1070)) and v51.SiphonLife:IsReady() and (v73 > (813 - (329 + 479)))) then
			if (((1455 - (174 + 680)) < (12232 - 8672)) and v49.CastTargetIf(v51.SiphonLife, v56, "min", v82, v90, not v17:IsSpellInRange(v51.SiphonLife))) then
				return "siphon_life cleave 20";
			end
		end
		if (((486 - 251) < (491 + 196)) and v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (742 - (396 + 343)))) and ((v59 and v60 and v62) or not v51.SoulRot:IsAvailable()) and v47) then
			if (((403 + 4146) > (2630 - (29 + 1448))) and v24(v51.SummonDarkglare)) then
				return "summon_darkglare cleave 22";
			end
		end
		if ((v51.MaleficRapture:IsReady() and v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1390 - (135 + 1254))) and (v71 > (11 - 8))) or ((21823 - 17149) < (3114 + 1558))) then
			if (((5195 - (389 + 1138)) < (5135 - (102 + 472))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(95 + 5))) then
				return "malefic_rapture cleave 24";
			end
		end
		if ((v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (2 + 1)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (3 + 0)))) or ((2000 - (320 + 1225)) == (6417 - 2812))) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((1630 + 1033) == (4776 - (157 + 1307)))) then
				return "drain_soul cleave 26";
			end
		end
		if (((6136 - (821 + 1038)) <= (11165 - 6690)) and v70:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
			if (v49.CastTargetIf(v70, v56, "min", v81, v89, not v17:IsSpellInRange(v70)) or ((96 + 774) == (2111 - 922))) then
				return "drain_soul/shadow_bolt cleave 28";
			end
		end
		if (((578 + 975) <= (7765 - 4632)) and v51.MaleficRapture:IsReady() and not v51.DreadTouch:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff)) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1126 - (834 + 192))) or ((143 + 2094) >= (902 + 2609))) then
				return "malefic_rapture cleave 30";
			end
		end
		if ((v51.MaleficRapture:IsReady() and (v63 or v61)) or ((29 + 1295) > (4678 - 1658))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(404 - (300 + 4))) or ((800 + 2192) == (4923 - 3042))) then
				return "malefic_rapture cleave 32";
			end
		end
		if (((3468 - (112 + 250)) > (609 + 917)) and v51.MaleficRapture:IsReady() and (v71 > (7 - 4))) then
			if (((1732 + 1291) < (2002 + 1868)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(75 + 25))) then
				return "malefic_rapture cleave 34";
			end
		end
		if (((71 + 72) > (55 + 19)) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (1462 - (1001 + 413))) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (44 - 24)) and (v73 < (886 - (244 + 638)))))) then
			if (((711 - (627 + 66)) < (6292 - 4180)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 36";
			end
		end
		if (((1699 - (512 + 90)) <= (3534 - (1665 + 241))) and v51.DrainLife:IsReady() and v13:BuffUp(v51.SoulRot) and (v13:BuffStack(v51.InevitableDemiseBuff) > (747 - (373 + 344)))) then
			if (((2089 + 2541) == (1226 + 3404)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
				return "drain_life cleave 38";
			end
		end
		if (((9337 - 5797) > (4539 - 1856)) and v51.Agony:IsReady()) then
			if (((5893 - (35 + 1064)) >= (2383 + 892)) and v49.CastCycle(v51.Agony, v56, v92, not v17:IsSpellInRange(v51.Agony))) then
				return "agony cleave 40";
			end
		end
		if (((3174 - 1690) == (6 + 1478)) and v51.Corruption:IsCastable()) then
			if (((2668 - (298 + 938)) < (4814 - (233 + 1026))) and v49.CastCycle(v51.Corruption, v56, v94, not v17:IsSpellInRange(v51.Corruption))) then
				return "corruption cleave 42";
			end
		end
		if ((v51.MaleficRapture:IsReady() and (v71 > (1667 - (636 + 1030)))) or ((545 + 520) > (3495 + 83))) then
			if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(30 + 70)) or ((324 + 4471) < (1628 - (55 + 166)))) then
				return "malefic_rapture cleave 44";
			end
		end
		if (((360 + 1493) < (484 + 4329)) and v51.DrainSoul:IsReady()) then
			if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((10773 - 7952) < (2728 - (36 + 261)))) then
				return "drain_soul cleave 54";
			end
		end
		if (v70:IsReady() or ((5026 - 2152) < (3549 - (34 + 1334)))) then
			if (v24(v70, nil, nil, not v17:IsSpellInRange(v70)) or ((1034 + 1655) <= (267 + 76))) then
				return "drain_soul/shadow_bolt cleave 46";
			end
		end
	end
	local function v106()
		v48();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v56 = v13:GetEnemiesInRange(1323 - (1035 + 248));
		v57 = v17:GetEnemiesInSplashRange(31 - (20 + 1));
		if (v30 or ((974 + 895) == (2328 - (134 + 185)))) then
			v58 = v28(#v57, #v56);
		else
			v58 = 1134 - (549 + 584);
		end
		if (v49.TargetIsValid() or v13:AffectingCombat() or ((4231 - (314 + 371)) < (7971 - 5649))) then
			v72 = v10.BossFightRemains(nil, true);
			v73 = v72;
			if ((v73 == (12079 - (478 + 490))) or ((1103 + 979) == (5945 - (786 + 386)))) then
				v73 = v10.FightRemains(v57, false);
			end
		end
		v71 = v13:SoulShardsP();
		v66 = v75(v57, v51.AgonyDebuff);
		v67 = v75(v57, v51.VileTaintDebuff);
		v68 = v75(v57, v51.PhantomSingularityDebuff);
		v69 = v28(v67 * v26(v51.VileTaint:IsAvailable()), v68 * v26(v51.PhantomSingularity:IsAvailable()));
		v74 = v13:GCD() + (0.25 - 0);
		if (((4623 - (1055 + 324)) > (2395 - (1093 + 247))) and v51.SummonPet:IsCastable() and v43 and not v16:IsActive()) then
			if (v25(v51.SummonPet) or ((2945 + 368) <= (187 + 1591))) then
				return "summon_pet ooc";
			end
		end
		if (v49.TargetIsValid() or ((5641 - 4220) >= (7140 - 5036))) then
			if (((5155 - 3343) <= (8164 - 4915)) and not v13:AffectingCombat() and v29) then
				local v165 = v99();
				if (((578 + 1045) <= (7539 - 5582)) and v165) then
					return v165;
				end
			end
			if (((15207 - 10795) == (3327 + 1085)) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v166 = v49.Interrupt(v51.SpellLock, 102 - 62, true);
				if (((2438 - (364 + 324)) >= (2307 - 1465)) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.SpellLock, 95 - 55, true, v15, v55.SpellLockMouseover);
				if (((1450 + 2922) > (7741 - 5891)) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.AxeToss, 64 - 24, true);
				if (((704 - 472) < (2089 - (1249 + 19))) and v166) then
					return v166;
				end
				v166 = v49.Interrupt(v51.AxeToss, 37 + 3, true, v15, v55.AxeTossMouseover);
				if (((2016 - 1498) < (1988 - (686 + 400))) and v166) then
					return v166;
				end
				v166 = v49.InterruptWithStun(v51.AxeToss, 32 + 8, true);
				if (((3223 - (73 + 156)) > (5 + 853)) and v166) then
					return v166;
				end
				v166 = v49.InterruptWithStun(v51.AxeToss, 851 - (721 + 90), true, v15, v55.AxeTossMouseover);
				if (v166 or ((43 + 3712) <= (2970 - 2055))) then
					return v166;
				end
			end
			v100();
			if (((4416 - (224 + 246)) > (6063 - 2320)) and (v58 > (1 - 0)) and (v58 < (1 + 2))) then
				local v167 = 0 + 0;
				local v168;
				while true do
					if ((v167 == (0 + 0)) or ((2654 - 1319) >= (11001 - 7695))) then
						v168 = v105();
						if (((5357 - (203 + 310)) > (4246 - (1238 + 755))) and v168) then
							return v168;
						end
						break;
					end
				end
			end
			if (((32 + 420) == (1986 - (709 + 825))) and (v58 > (3 - 1))) then
				local v169 = v104();
				if (v169 or ((6638 - 2081) < (2951 - (196 + 668)))) then
					return v169;
				end
			end
			if (((15295 - 11421) == (8024 - 4150)) and v23()) then
				local v170 = v103();
				if (v170 or ((2771 - (171 + 662)) > (5028 - (4 + 89)))) then
					return v170;
				end
			end
			if (v33 or ((14913 - 10658) < (1247 + 2176))) then
				local v171 = v102();
				if (((6386 - 4932) <= (977 + 1514)) and v171) then
					return v171;
				end
			end
			if ((v51.MaleficRapture:IsReady() and v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (1488 - (35 + 1451))) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or ((5610 - (28 + 1425)) <= (4796 - (941 + 1052)))) then
				if (((4654 + 199) >= (4496 - (822 + 692))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(142 - 42))) then
					return "malefic_rapture main 2";
				end
			end
			if (((1948 + 2186) > (3654 - (45 + 252))) and v51.MaleficRapture:IsReady() and (v73 < (4 + 0))) then
				if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(35 + 65)) or ((8315 - 4898) < (2967 - (114 + 319)))) then
					return "malefic_rapture main 4";
				end
			end
			if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 - 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (14 - 2))))) or ((1736 + 986) <= (243 - 79))) then
				if (v24(v55.VileTaintCursor, v45, nil, not v17:IsInRange(83 - 43)) or ((4371 - (556 + 1407)) < (3315 - (741 + 465)))) then
					return "vile_taint main 6";
				end
			end
			if ((v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (490 - (170 + 295)))))) and v17:DebuffUp(v51.AgonyDebuff)) or ((18 + 15) == (1337 + 118))) then
				if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((1090 - 647) >= (3329 + 686))) then
					return "phantom_singularity main 8";
				end
			end
			if (((2169 + 1213) > (95 + 71)) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1231 - (957 + 273)))) and v17:DebuffUp(v51.AgonyDebuff)) then
				if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((75 + 205) == (1225 + 1834))) then
					return "soul_rot main 10";
				end
			end
			if (((7167 - 5286) > (3407 - 2114)) and v51.Agony:IsCastable() and (not v51.VileTaint:IsAvailable() or (v17:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime()))) and (v17:DebuffRemains(v51.AgonyDebuff) < (15 - 10)) and (v73 > (24 - 19))) then
				if (((4137 - (389 + 1391)) == (1479 + 878)) and v24(v51.Agony, nil, nil, not v17:IsSpellInRange(v51.Agony))) then
					return "agony main 12";
				end
			end
			if (((13 + 110) == (279 - 156)) and v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (956 - (783 + 168))) and (v73 > (9 - 6))) then
				if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((1039 + 17) >= (3703 - (309 + 2)))) then
					return "unstable_affliction main 14";
				end
			end
			if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (15 - 10))) or ((2293 - (1090 + 122)) < (349 + 726))) then
				if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((3522 - 2473) >= (3034 + 1398))) then
					return "haunt main 16";
				end
			end
			if ((v51.Corruption:IsCastable() and v17:DebuffRefreshable(v51.CorruptionDebuff) and (v73 > (1123 - (628 + 490)))) or ((855 + 3913) <= (2094 - 1248))) then
				if (v24(v51.Corruption, nil, nil, not v17:IsSpellInRange(v51.Corruption)) or ((15346 - 11988) <= (2194 - (431 + 343)))) then
					return "corruption main 18";
				end
			end
			if ((v51.SiphonLife:IsCastable() and v17:DebuffRefreshable(v51.SiphonLifeDebuff) and (v73 > (10 - 5))) or ((10816 - 7077) <= (2374 + 631))) then
				if (v24(v51.SiphonLife, nil, nil, not v17:IsSpellInRange(v51.SiphonLife)) or ((213 + 1446) >= (3829 - (556 + 1139)))) then
					return "siphon_life main 20";
				end
			end
			if ((v51.SummonDarkglare:IsReady() and v47 and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (18 - (6 + 9)))) and ((v59 and v60 and v62) or not v51.SoulRot:IsAvailable())) or ((597 + 2663) < (1207 + 1148))) then
				if (v24(v51.SummonDarkglare) or ((838 - (28 + 141)) == (1636 + 2587))) then
					return "summon_darkglare main 22";
				end
			end
			if ((v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (3 - 0)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (3 + 0)))) or ((3009 - (486 + 831)) < (1530 - 942))) then
				if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((16888 - 12091) < (690 + 2961))) then
					return "drain_soul main 24";
				end
			end
			if ((v51.ShadowBolt:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (9 - 6)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (1266 - (668 + 595))))) or ((3759 + 418) > (978 + 3872))) then
				if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((1090 - 690) > (1401 - (23 + 267)))) then
					return "shadow_bolt main 26";
				end
			end
			if (((4995 - (1129 + 815)) > (1392 - (371 + 16))) and v51.MaleficRapture:IsReady() and ((v71 > (1754 - (1326 + 424))) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 - 0)) and (v71 > (10 - 7))) or (v51.TormentedCrescendo:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v17:DebuffDown(v51.DreadTouchDebuff)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (120 - (88 + 30)))) or v63 or (v61 and (v71 > (772 - (720 + 51)))) or (v51.TormentedCrescendo:IsAvailable() and v51.Nightfall:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v13:BuffUp(v51.NightfallBuff)))) then
				if (((8214 - 4521) <= (6158 - (421 + 1355))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(164 - 64))) then
					return "malefic_rapture main 28";
				end
			end
			if ((v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (24 + 24)) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (1103 - (286 + 797))) and (v73 < (14 - 10))))) or ((5435 - 2153) > (4539 - (397 + 42)))) then
				if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((1119 + 2461) < (3644 - (24 + 776)))) then
					return "drain_life main 30";
				end
			end
			if (((136 - 47) < (5275 - (222 + 563))) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
				if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((10979 - 5996) < (1302 + 506))) then
					return "drain_soul main 32";
				end
			end
			if (((4019 - (23 + 167)) > (5567 - (690 + 1108))) and v51.ShadowBolt:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
				if (((536 + 949) <= (2396 + 508)) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
					return "shadow_bolt main 34";
				end
			end
			if (((5117 - (40 + 808)) == (703 + 3566)) and v51.DrainSoul:IsReady()) then
				if (((1479 - 1092) <= (2659 + 123)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
					return "drain_soul main 36";
				end
			end
			if (v51.ShadowBolt:IsReady() or ((1005 + 894) <= (503 + 414))) then
				if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((4883 - (47 + 524)) <= (569 + 307))) then
					return "shadow_bolt main 38";
				end
			end
		end
	end
	local function v107()
		local v152 = 0 - 0;
		while true do
			if (((3336 - 1104) <= (5920 - 3324)) and (v152 == (1728 - (1165 + 561)))) then
				v51.UnstableAfflictionDebuff:RegisterAuraTracking();
				break;
			end
			if (((63 + 2032) < (11416 - 7730)) and (v152 == (0 + 0))) then
				v10.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v51.AgonyDebuff:RegisterAuraTracking();
				v152 = 480 - (341 + 138);
			end
			if ((v152 == (1 + 0)) or ((3291 - 1696) >= (4800 - (89 + 237)))) then
				v51.SiphonLifeDebuff:RegisterAuraTracking();
				v51.CorruptionDebuff:RegisterAuraTracking();
				v152 = 6 - 4;
			end
		end
	end
	v10.SetAPL(557 - 292, v106, v107);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

