local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((819 + 380) == (4392 - 3193)) and not v6) then
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
			if ((v108 == (1620 - (1427 + 192))) or ((221 + 415) == (4415 - 2513))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (326 - (192 + 134));
				v108 = 1278 - (316 + 960);
			end
			if ((v108 == (2 + 1)) or ((3735 + 1104) <= (3032 + 248))) then
				v45 = EpicSettings.Settings['VileTaint'];
				v46 = EpicSettings.Settings['PhantomSingularity'];
				v47 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if ((v108 == (0 - 0)) or ((4225 - (83 + 468)) <= (3768 - (1202 + 604)))) then
				v33 = EpicSettings.Settings['UseTrinkets'];
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v108 = 1 - 0;
			end
			if ((v108 == (5 - 3)) or ((2219 - (45 + 280)) < (1358 + 48))) then
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v43 = EpicSettings.Settings['SummonPet'];
				v44 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v108 = 1 + 2;
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
	local v72 = 13022 - (340 + 1571);
	local v73 = 4383 + 6728;
	local v74;
	v10:RegisterForEvent(function()
		v51.SeedofCorruption:RegisterInFlight();
		v51.ShadowBolt:RegisterInFlight();
		v51.Haunt:RegisterInFlight();
		v70 = ((v51.DrainSoul:IsAvailable()) and v51.DrainSoul) or v51.ShadowBolt;
	end, "LEARNED_SPELL_IN_TAB");
	v51.SeedofCorruption:RegisterInFlight();
	v51.ShadowBolt:RegisterInFlight();
	v51.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v109 = 1772 - (1733 + 39);
		while true do
			if (((4319 - 2747) >= (2565 - (125 + 909))) and (v109 == (1948 - (1096 + 852)))) then
				v72 = 4985 + 6126;
				v73 = 15867 - 4756;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v75(v110, v111)
		local v112 = 0 + 0;
		local v113;
		while true do
			if ((v112 == (512 - (409 + 103))) or ((4923 - (46 + 190)) < (4637 - (51 + 44)))) then
				if (((929 + 2362) > (2984 - (1114 + 203))) and (not v110 or not v111)) then
					return 726 - (228 + 498);
				end
				v113 = nil;
				v112 = 1 + 0;
			end
			if ((v112 == (1 + 0)) or ((1536 - (174 + 489)) == (5299 - 3265))) then
				for v161, v162 in pairs(v110) do
					local v163 = 1905 - (830 + 1075);
					local v164;
					while true do
						if ((v163 == (524 - (303 + 221))) or ((4085 - (231 + 1038)) < (10 + 1))) then
							v164 = v162:DebuffRemains(v111) + ((1261 - (171 + 991)) * v26(v162:DebuffDown(v111)));
							if (((15244 - 11545) < (12636 - 7930)) and ((v113 == nil) or (v164 < v113))) then
								v113 = v164;
							end
							break;
						end
					end
				end
				return v113 or (0 - 0);
			end
		end
	end
	local function v76(v114)
		local v115 = 0 + 0;
		local v116;
		local v117;
		while true do
			if (((9275 - 6629) >= (2526 - 1650)) and (v115 == (0 - 0))) then
				if (((1897 - 1283) <= (4432 - (111 + 1137))) and (not v114 or (#v114 == (158 - (91 + 67))))) then
					return false;
				end
				if (((9303 - 6177) == (780 + 2346)) and (v51.SeedofCorruption:InFlight() or v13:PrevGCDP(524 - (423 + 100), v51.SeedofCorruption))) then
					return false;
				end
				v115 = 1 + 0;
			end
			if ((v115 == (2 - 1)) or ((1140 + 1047) >= (5725 - (326 + 445)))) then
				v116 = 0 - 0;
				v117 = 0 - 0;
				v115 = 4 - 2;
			end
			if ((v115 == (713 - (530 + 181))) or ((4758 - (614 + 267)) == (3607 - (19 + 13)))) then
				for v165, v166 in pairs(v114) do
					local v167 = 0 - 0;
					while true do
						if (((1647 - 940) > (1805 - 1173)) and (v167 == (0 + 0))) then
							v116 = v116 + (1 - 0);
							if (v166:DebuffUp(v51.SeedofCorruptionDebuff) or ((1132 - 586) >= (4496 - (1293 + 519)))) then
								v117 = v117 + (1 - 0);
							end
							break;
						end
					end
				end
				return v116 == v117;
			end
		end
	end
	local function v77()
		return v50.GuardiansTable.DarkglareDuration > (0 - 0);
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
		return (v123:DebuffRemains(v51.AgonyDebuff) < (v123:DebuffRemains(v51.VileTaintDebuff) + v51.VileTaint:CastTime())) and (v123:DebuffRemains(v51.AgonyDebuff) < (9 - 4));
	end
	local function v85(v124)
		return v124:DebuffRemains(v51.AgonyDebuff) < (21 - 16);
	end
	local function v86(v125)
		return ((v125:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v125:DebuffRemains(v51.AgonyDebuff) < (11 - 6));
	end
	local function v87(v126)
		return ((v126:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime())) or not v51.VileTaint:IsAvailable()) and (v126:DebuffRemains(v51.AgonyDebuff) < (3 + 2)) and (v73 > (2 + 3));
	end
	local function v88(v127)
		return v127:DebuffRemains(v51.CorruptionDebuff) < (11 - 6);
	end
	local function v89(v128)
		return (v51.ShadowEmbrace:IsAvailable() and ((v128:DebuffStack(v51.ShadowEmbraceDebuff) < (1 + 2)) or (v128:DebuffRemains(v51.ShadowEmbraceDebuff) < (1 + 2)))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v90(v129)
		return (v129:DebuffRefreshable(v51.SiphonLifeDebuff));
	end
	local function v91(v130)
		return v130:DebuffRemains(v51.AgonyDebuff) < (4 + 1);
	end
	local function v92(v131)
		return (v131:DebuffRefreshable(v51.AgonyDebuff));
	end
	local function v93(v132)
		return v132:DebuffRemains(v51.CorruptionDebuff) < (1101 - (709 + 387));
	end
	local function v94(v133)
		return (v133:DebuffRefreshable(v51.CorruptionDebuff));
	end
	local function v95(v134)
		return (v134:DebuffStack(v51.ShadowEmbraceDebuff) < (1861 - (673 + 1185))) or (v134:DebuffRemains(v51.ShadowEmbraceDebuff) < (8 - 5));
	end
	local function v96(v135)
		return (v51.ShadowEmbrace:IsAvailable() and ((v135:DebuffStack(v51.ShadowEmbraceDebuff) < (9 - 6)) or (v135:DebuffRemains(v51.ShadowEmbraceDebuff) < (4 - 1)))) or not v51.ShadowEmbrace:IsAvailable();
	end
	local function v97(v136)
		return v136:DebuffRemains(v51.SiphonLifeDebuff) < (4 + 1);
	end
	local function v98(v137)
		return (v137:DebuffRemains(v51.SiphonLifeDebuff) < (4 + 1)) and v137:DebuffUp(v51.AgonyDebuff);
	end
	local function v99()
		local v138 = 0 - 0;
		while true do
			if (((360 + 1105) <= (8575 - 4274)) and (v138 == (1 - 0))) then
				if (((3584 - (446 + 1434)) > (2708 - (1040 + 243))) and v51.UnstableAffliction:IsReady() and not v51.SoulSwap:IsAvailable()) then
					if (v25(v51.UnstableAffliction, not v17:IsSpellInRange(v51.UnstableAffliction), true) or ((2050 - 1363) == (6081 - (559 + 1288)))) then
						return "unstable_affliction precombat 8";
					end
				end
				if (v51.ShadowBolt:IsReady() or ((5261 - (609 + 1322)) < (1883 - (13 + 441)))) then
					if (((4286 - 3139) >= (877 - 542)) and v25(v51.ShadowBolt, not v17:IsSpellInRange(v51.ShadowBolt), true)) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
			if (((17107 - 13672) > (79 + 2018)) and ((0 - 0) == v138)) then
				if (v51.GrimoireofSacrifice:IsCastable() or ((1340 + 2430) >= (1771 + 2270))) then
					if (v25(v51.GrimoireofSacrifice) or ((11249 - 7458) <= (882 + 729))) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (v51.Haunt:IsReady() or ((8419 - 3841) <= (1328 + 680))) then
					if (((626 + 499) <= (1492 + 584)) and v25(v51.Haunt, not v17:IsSpellInRange(v51.Haunt), true)) then
						return "haunt precombat 6";
					end
				end
				v138 = 1 + 0;
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
		v65 = not v64 or (v63 and ((v51.SummonDarkglare:CooldownRemains() > (20 + 0)) or not v51.SummonDarkglare:IsAvailable()));
	end
	local function v101()
		local v139 = v49.HandleTopTrinket(v53, v31, 473 - (153 + 280), nil);
		if (v139 or ((2145 - 1402) >= (3950 + 449))) then
			return v139;
		end
		local v139 = v49.HandleBottomTrinket(v53, v31, 16 + 24, nil);
		if (((605 + 550) < (1519 + 154)) and v139) then
			return v139;
		end
	end
	local function v102()
		local v140 = 0 + 0;
		local v141;
		while true do
			if (((1 - 0) == v140) or ((1437 + 887) <= (1245 - (89 + 578)))) then
				if (((2692 + 1075) == (7831 - 4064)) and v52.DesperateInvokersCodex:IsEquippedAndReady()) then
					if (((5138 - (572 + 477)) == (552 + 3537)) and v25(v55.DesperateInvokersCodex, not v17:IsInRange(28 + 17))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (((533 + 3925) >= (1760 - (84 + 2))) and v52.ConjuredChillglobe:IsEquippedAndReady()) then
					if (((1601 - 629) <= (1022 + 396)) and v25(v55.ConjuredChillglobe)) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
			if ((v140 == (842 - (497 + 345))) or ((127 + 4811) < (805 + 3957))) then
				v141 = v101();
				if (v141 or ((3837 - (605 + 728)) > (3043 + 1221))) then
					return v141;
				end
				v140 = 1 - 0;
			end
		end
	end
	local function v103()
		if (((99 + 2054) == (7960 - 5807)) and v65) then
			local v149 = 0 + 0;
			local v150;
			while true do
				if ((v149 == (0 - 0)) or ((383 + 124) >= (3080 - (457 + 32)))) then
					v150 = v49.HandleDPSPotion();
					if (((1902 + 2579) == (5883 - (832 + 570))) and v150) then
						return v150;
					end
					v149 = 1 + 0;
				end
				if ((v149 == (1 + 0)) or ((8238 - 5910) < (334 + 359))) then
					if (((5124 - (588 + 208)) == (11664 - 7336)) and v51.Berserking:IsCastable()) then
						if (((3388 - (884 + 916)) >= (2788 - 1456)) and v25(v51.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v51.BloodFury:IsCastable() or ((2421 + 1753) > (4901 - (232 + 421)))) then
						if (v25(v51.BloodFury) or ((6475 - (1569 + 320)) <= (21 + 61))) then
							return "blood_fury ogcd 6";
						end
					end
					v149 = 1 + 1;
				end
				if (((13017 - 9154) == (4468 - (316 + 289))) and (v149 == (5 - 3))) then
					if (v51.Fireblood:IsCastable() or ((14 + 268) <= (1495 - (666 + 787)))) then
						if (((5034 - (360 + 65)) >= (716 + 50)) and v25(v51.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
			end
		end
	end
	local function v104()
		local v142 = 254 - (79 + 175);
		local v143;
		while true do
			if ((v142 == (7 - 2)) or ((899 + 253) == (7626 - 5138))) then
				if (((6589 - 3167) > (4249 - (503 + 396))) and v51.SummonSoulkeeper:IsReady() and ((v51.SummonSoulkeeper:Count() == (191 - (92 + 89))) or ((v51.SummonSoulkeeper:Count() > (5 - 2)) and (v73 < (6 + 4))))) then
					if (((520 + 357) > (1472 - 1096)) and v24(v51.SummonSoulkeeper)) then
						return "soul_strike aoe 32";
					end
				end
				if ((v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (1 + 4)) and ((v58 < (17 - 9)) or not v51.DoomBlossom:IsAvailable())) or ((2721 + 397) <= (885 + 966))) then
					if (v49.CastCycle(v51.SiphonLife, v56, v97, not v17:IsSpellInRange(v51.SiphonLife)) or ((502 - 337) >= (436 + 3056))) then
						return "siphon_life aoe 34";
					end
				end
				if (((6021 - 2072) < (6100 - (485 + 759))) and v51.DrainSoul:IsReady()) then
					if (v49.CastCycle(v51.DrainSoul, v56, v96, not v17:IsSpellInRange(v51.DrainSoul)) or ((9894 - 5618) < (4205 - (442 + 747)))) then
						return "drain_soul aoe 36";
					end
				end
				if (((5825 - (832 + 303)) > (5071 - (88 + 858))) and v51.ShadowBolt:IsReady()) then
					if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((16 + 34) >= (742 + 154))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if (((1 + 0) == v142) or ((2503 - (766 + 23)) >= (14602 - 11644))) then
				if ((v51.VileTaint:IsReady() and (((v51.SouleatersGluttony:TalentRank() == (2 - 0)) and ((v66 < (2.5 - 1)) or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()))) or ((v51.SouleatersGluttony:TalentRank() == (3 - 2)) and (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and ((v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (v51.VileTaint:CooldownRemains() > (1098 - (1036 + 37))))))) or ((1058 + 433) < (1253 - 609))) then
					if (((554 + 150) < (2467 - (641 + 839))) and v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(953 - (910 + 3)))) then
						return "vile_taint aoe 4";
					end
				end
				if (((9478 - 5760) > (3590 - (1466 + 218))) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:IsAvailable() and (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime())) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (12 + 13))))) and v17:DebuffUp(v51.AgonyDebuff)) then
					if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((2106 - (556 + 592)) > (1293 + 2342))) then
						return "phantom_singularity aoe 6";
					end
				end
				if (((4309 - (329 + 479)) <= (5346 - (174 + 680))) and v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (17 - 12))) then
					if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((7133 - 3691) < (1820 + 728))) then
						return "unstable_affliction aoe 8";
					end
				end
				if (((3614 - (396 + 343)) >= (130 + 1334)) and v51.Agony:IsReady() and (v51.AgonyDebuff:AuraActiveCount() < (1485 - (29 + 1448))) and (((v74 * (1391 - (135 + 1254))) + v51.SoulRot:CastTime()) < v69)) then
					if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v86, not v17:IsSpellInRange(v51.Agony)) or ((18071 - 13274) >= (22846 - 17953))) then
						return "agony aoe 9";
					end
				end
				v142 = 2 + 0;
			end
			if ((v142 == (1531 - (389 + 1138))) or ((1125 - (102 + 472)) > (1952 + 116))) then
				if (((1173 + 941) > (881 + 63)) and v51.MaleficRapture:IsReady() and ((((v51.SummonDarkglare:CooldownRemains() > (1560 - (320 + 1225))) or (v71 > (5 - 2))) and not v51.SowTheSeeds:IsAvailable()) or v13:BuffUp(v51.TormentedCrescendoBuff))) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(62 + 38)) or ((3726 - (157 + 1307)) >= (4955 - (821 + 1038)))) then
						return "malefic_rapture aoe 24";
					end
				end
				if ((v51.DrainLife:IsReady() and (v17:DebuffUp(v51.SoulRotDebuff) or not v51.SoulRot:IsAvailable()) and (v13:BuffStack(v51.InevitableDemiseBuff) > (24 - 14))) or ((247 + 2008) >= (6282 - 2745))) then
					if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((1428 + 2409) < (3236 - 1930))) then
						return "drain_life aoe 26";
					end
				end
				if (((3976 - (834 + 192)) == (188 + 2762)) and v51.DrainSoul:IsReady() and v13:BuffUp(v51.NightfallBuff) and v51.ShadowEmbrace:IsAvailable()) then
					if (v49.CastCycle(v51.DrainSoul, v56, v95, not v17:IsSpellInRange(v51.DrainSoul)) or ((1213 + 3510) < (71 + 3227))) then
						return "drain_soul aoe 28";
					end
				end
				if (((1759 - 623) >= (458 - (300 + 4))) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
					if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((73 + 198) > (12429 - 7681))) then
						return "drain_soul aoe 30";
					end
				end
				v142 = 367 - (112 + 250);
			end
			if (((1890 + 2850) >= (7896 - 4744)) and ((2 + 1) == v142)) then
				if ((v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) or ((1334 + 1244) >= (2536 + 854))) then
					if (((21 + 20) <= (1234 + 427)) and v24(v51.SummonDarkglare, v47)) then
						return "summon_darkglare aoe 18";
					end
				end
				if (((2015 - (1001 + 413)) < (7938 - 4378)) and v51.DrainLife:IsReady() and (v13:BuffStack(v51.InevitableDemiseBuff) > (912 - (244 + 638))) and v13:BuffUp(v51.SoulRot) and (v13:BuffRemains(v51.SoulRot) <= v74) and (v58 > (696 - (627 + 66)))) then
					if (((700 - 465) < (1289 - (512 + 90))) and v49.CastTargetIf(v51.DrainLife, v56, "min", v83, nil, not v17:IsSpellInRange(v51.DrainLife))) then
						return "drain_life aoe 19";
					end
				end
				if (((6455 - (1665 + 241)) > (1870 - (373 + 344))) and v51.MaleficRapture:IsReady() and v13:BuffUp(v51.UmbrafireKindlingBuff) and ((((v58 < (3 + 3)) or (v10.CombatTime() < (8 + 22))) and v77()) or not v51.DoomBlossom:IsAvailable())) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(263 - 163)) or ((7909 - 3235) < (5771 - (35 + 1064)))) then
						return "malefic_rapture aoe 20";
					end
				end
				if (((2669 + 999) < (9758 - 5197)) and v51.SeedofCorruption:IsReady() and v51.SowTheSeeds:IsAvailable()) then
					if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((2 + 453) == (4841 - (298 + 938)))) then
						return "seed_of_corruption aoe 22";
					end
				end
				v142 = 1263 - (233 + 1026);
			end
			if ((v142 == (1668 - (636 + 1030))) or ((1362 + 1301) == (3236 + 76))) then
				if (((1271 + 3006) <= (303 + 4172)) and v51.SiphonLife:IsReady() and (v51.SiphonLifeDebuff:AuraActiveCount() < (227 - (55 + 166))) and v51.SummonDarkglare:CooldownUp() and (v10.CombatTime() < (4 + 16)) and (((v74 * (1 + 1)) + v51.SoulRot:CastTime()) < v69)) then
					if (v49.CastCycle(v51.SiphonLife, v56, v98, not v17:IsSpellInRange(v51.SiphonLife)) or ((3322 - 2452) == (1486 - (36 + 261)))) then
						return "siphon_life aoe 10";
					end
				end
				if (((2715 - 1162) <= (4501 - (34 + 1334))) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v17:DebuffUp(v51.AgonyDebuff)) then
					if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((1739 + 498) >= (4794 - (1035 + 248)))) then
						return "soul_rot aoe 12";
					end
				end
				if ((v51.SeedofCorruption:IsReady() and (v17:DebuffRemains(v51.CorruptionDebuff) < (26 - (20 + 1))) and not (v51.SeedofCorruption:InFlight() or v17:DebuffUp(v51.SeedofCorruptionDebuff))) or ((690 + 634) > (3339 - (134 + 185)))) then
					if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((4125 - (549 + 584)) == (2566 - (314 + 371)))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if (((10662 - 7556) > (2494 - (478 + 490))) and v51.Corruption:IsReady() and not v51.SeedofCorruption:IsAvailable()) then
					if (((1602 + 1421) < (5042 - (786 + 386))) and v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption))) then
						return "corruption aoe 15";
					end
				end
				v142 = 9 - 6;
			end
			if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and (v142 == (0 + 0))) then
				if (((2 + 16) < (8385 - 6273)) and v31) then
					local v168 = 0 - 0;
					local v169;
					while true do
						if (((3121 - 2024) <= (4090 - 2462)) and (v168 == (0 + 0))) then
							v169 = v103();
							if (((17836 - 13206) == (15958 - 11328)) and v169) then
								return v169;
							end
							break;
						end
					end
				end
				v143 = v102();
				if (((2670 + 870) > (6861 - 4178)) and v143) then
					return v143;
				end
				if (((5482 - (364 + 324)) >= (8977 - 5702)) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (6 - 3))) then
					if (((492 + 992) == (6209 - 4725)) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
						return "haunt aoe 2";
					end
				end
				v142 = 1 - 0;
			end
		end
	end
	local function v105()
		local v144 = 0 - 0;
		local v145;
		while true do
			if (((2700 - (1249 + 19)) < (3209 + 346)) and (v144 == (15 - 11))) then
				if ((v51.Corruption:IsReady() and not (v51.SeedofCorruption:InFlight() or (v17:DebuffRemains(v51.SeedofCorruptionDebuff) > (1086 - (686 + 400)))) and (v73 > (4 + 1))) or ((1294 - (73 + 156)) > (17 + 3561))) then
					if (v49.CastTargetIf(v51.Corruption, v56, "min", v80, v88, not v17:IsSpellInRange(v51.Corruption)) or ((5606 - (721 + 90)) < (16 + 1391))) then
						return "corruption cleave 18";
					end
				end
				if (((6016 - 4163) < (5283 - (224 + 246))) and v51.SiphonLife:IsReady() and (v73 > (8 - 3))) then
					if (v49.CastTargetIf(v51.SiphonLife, v56, "min", v82, v90, not v17:IsSpellInRange(v51.SiphonLife)) or ((5193 - 2372) < (441 + 1990))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (1 + 2))) and v59 and v60 and v62) or ((2111 + 763) < (4335 - 2154))) then
					if (v24(v51.SummonDarkglare, v47) or ((8948 - 6259) <= (856 - (203 + 310)))) then
						return "summon_darkglare cleave 22";
					end
				end
				v144 = 1998 - (1238 + 755);
			end
			if ((v144 == (1 + 5)) or ((3403 - (709 + 825)) == (3701 - 1692))) then
				if ((v51.MaleficRapture:IsReady() and not v51.DreadTouch:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff)) or ((5164 - 1618) < (3186 - (196 + 668)))) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(394 - 294)) or ((4312 - 2230) == (5606 - (171 + 662)))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((3337 - (4 + 89)) > (3697 - 2642)) and v51.MaleficRapture:IsReady() and (v63 or v61)) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(37 + 63)) or ((14551 - 11238) <= (698 + 1080))) then
						return "malefic_rapture cleave 32";
					end
				end
				if ((v51.MaleficRapture:IsReady() and (v71 > (1489 - (35 + 1451)))) or ((2874 - (28 + 1425)) >= (4097 - (941 + 1052)))) then
					if (((1738 + 74) <= (4763 - (822 + 692))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(142 - 42))) then
						return "malefic_rapture cleave 34";
					end
				end
				v144 = 4 + 3;
			end
			if (((1920 - (45 + 252)) <= (1937 + 20)) and (v144 == (2 + 3))) then
				if (((10737 - 6325) == (4845 - (114 + 319))) and v51.MaleficRapture:IsReady() and v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 - 0)) and (v71 > (3 - 0))) then
					if (((1116 + 634) >= (1253 - 411)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(209 - 109))) then
						return "malefic_rapture cleave 24";
					end
				end
				if (((6335 - (556 + 1407)) > (3056 - (741 + 465))) and v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (468 - (170 + 295))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (2 + 1)))) then
					if (((214 + 18) < (2021 - 1200)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
						return "drain_soul cleave 26";
					end
				end
				if (((430 + 88) < (579 + 323)) and v70:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
					if (((1696 + 1298) > (2088 - (957 + 273))) and v49.CastTargetIf(v70, v56, "min", v81, v89, not v17:IsSpellInRange(v70))) then
						return "drain_soul/shadow_bolt cleave 28";
					end
				end
				v144 = 2 + 4;
			end
			if ((v144 == (3 + 4)) or ((14308 - 10553) <= (2411 - 1496))) then
				if (((12052 - 8106) > (18534 - 14791)) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (1828 - (389 + 1391))) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (13 + 7)) and (v73 < (1 + 3))))) then
					if (v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife)) or ((3039 - 1704) >= (4257 - (783 + 168)))) then
						return "drain_life cleave 36";
					end
				end
				if (((16257 - 11413) > (2217 + 36)) and v51.DrainLife:IsReady() and v13:BuffUp(v51.SoulRot) and (v13:BuffStack(v51.InevitableDemiseBuff) > (341 - (309 + 2)))) then
					if (((1387 - 935) == (1664 - (1090 + 122))) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
						return "drain_life cleave 38";
					end
				end
				if (v51.Agony:IsReady() or ((1478 + 3079) < (7009 - 4922))) then
					if (((2652 + 1222) == (4992 - (628 + 490))) and v49.CastCycle(v51.Agony, v56, v92, not v17:IsSpellInRange(v51.Agony))) then
						return "agony cleave 40";
					end
				end
				v144 = 2 + 6;
			end
			if ((v144 == (0 - 0)) or ((8856 - 6918) > (5709 - (431 + 343)))) then
				if (v31 or ((8593 - 4338) < (9902 - 6479))) then
					local v170 = v103();
					if (((1149 + 305) <= (319 + 2172)) and v170) then
						return v170;
					end
				end
				v145 = v102();
				if (v145 or ((5852 - (556 + 1139)) <= (2818 - (6 + 9)))) then
					return v145;
				end
				v144 = 1 + 0;
			end
			if (((2487 + 2366) >= (3151 - (28 + 141))) and (v144 == (4 + 4))) then
				if (((5102 - 968) > (2378 + 979)) and v51.Corruption:IsCastable()) then
					if (v49.CastCycle(v51.Corruption, v56, v94, not v17:IsSpellInRange(v51.Corruption)) or ((4734 - (486 + 831)) < (6594 - 4060))) then
						return "corruption cleave 42";
					end
				end
				if ((v51.MaleficRapture:IsReady() and (v71 > (3 - 2))) or ((515 + 2207) <= (518 - 354))) then
					if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(1363 - (668 + 595))) or ((2167 + 241) < (426 + 1683))) then
						return "malefic_rapture cleave 44";
					end
				end
				if (v51.DrainSoul:IsReady() or ((89 - 56) == (1745 - (23 + 267)))) then
					if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((2387 - (1129 + 815)) >= (4402 - (371 + 16)))) then
						return "drain_soul cleave 54";
					end
				end
				v144 = 1759 - (1326 + 424);
			end
			if (((6405 - 3023) > (606 - 440)) and (v144 == (119 - (88 + 30)))) then
				if ((v31 and v51.SummonDarkglare:IsCastable() and v59 and v60 and v62) or ((1051 - (720 + 51)) == (6804 - 3745))) then
					if (((3657 - (421 + 1355)) > (2132 - 839)) and v24(v51.SummonDarkglare, v47)) then
						return "summon_darkglare cleave 2";
					end
				end
				if (((1158 + 1199) == (3440 - (286 + 797))) and v51.MaleficRapture:IsReady() and ((v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (7 - 5)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) or (v71 > (6 - 2)))) then
					if (((562 - (397 + 42)) == (39 + 84)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(900 - (24 + 776)))) then
						return "malefic_rapture cleave 2";
					end
				end
				if ((v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 - 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (797 - (222 + 563)))))) or ((2326 - 1270) >= (2443 + 949))) then
					if (v24(v55.VileTaintCursor, nil, nil, not v17:IsInRange(230 - (23 + 167))) or ((2879 - (690 + 1108)) < (388 + 687))) then
						return "vile_taint cleave 4";
					end
				end
				v144 = 2 + 0;
			end
			if ((v144 == (857 - (40 + 808))) or ((173 + 876) >= (16947 - 12515))) then
				if (v70:IsReady() or ((4558 + 210) <= (448 + 398))) then
					if (v24(v70, nil, nil, not v17:IsSpellInRange(v70)) or ((1842 + 1516) <= (1991 - (47 + 524)))) then
						return "drain_soul/shadow_bolt cleave 46";
					end
				end
				break;
			end
			if ((v144 == (2 + 1)) or ((10220 - 6481) <= (4493 - 1488))) then
				if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (11 - 6)) and (v73 > (1729 - (1165 + 561)))) or ((50 + 1609) >= (6609 - 4475))) then
					if (v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction)) or ((1244 + 2016) < (2834 - (341 + 138)))) then
						return "unstable_affliction cleave 12";
					end
				end
				if ((v51.SeedofCorruption:IsReady() and not v51.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v51.CorruptionDebuff) < (2 + 3)) and v51.SowTheSeeds:IsAvailable() and v76(v56)) or ((1380 - 711) == (4549 - (89 + 237)))) then
					if (v24(v51.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v51.SeedofCorruption)) or ((5443 - 3751) < (1237 - 649))) then
						return "seed_of_corruption cleave 14";
					end
				end
				if ((v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (884 - (581 + 300)))) or ((6017 - (855 + 365)) < (8671 - 5020))) then
					if (v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt)) or ((1364 + 2813) > (6085 - (1030 + 205)))) then
						return "haunt cleave 16";
					end
				end
				v144 = 4 + 0;
			end
			if ((v144 == (2 + 0)) or ((686 - (156 + 130)) > (2524 - 1413))) then
				if (((5141 - 2090) > (2058 - 1053)) and v51.VileTaint:IsReady() and (v51.AgonyDebuff:AuraActiveCount() == (1 + 1)) and (v51.CorruptionDebuff:AuraActiveCount() == (2 + 0)) and (not v51.SiphonLife:IsAvailable() or (v51.SiphonLifeDebuff:AuraActiveCount() == (71 - (10 + 59)))) and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.VileTaint:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (4 + 8))))) then
					if (((18187 - 14494) <= (5545 - (671 + 492))) and v24(v55.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v51.VileTaint))) then
						return "vile_taint cleave 10";
					end
				end
				if ((v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v51.AgonyDebuff:AuraActiveCount() >= (1217 - (369 + 846)))) or ((869 + 2413) > (3499 + 601))) then
					if (v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot)) or ((5525 - (1036 + 909)) < (2262 + 582))) then
						return "soul_rot cleave 8";
					end
				end
				if (((148 - 59) < (4693 - (11 + 192))) and v51.Agony:IsReady()) then
					if (v49.CastTargetIf(v51.Agony, v56, "min", v79, v87, not v17:IsSpellInRange(v51.Agony)) or ((2519 + 2464) < (1983 - (135 + 40)))) then
						return "agony cleave 10";
					end
				end
				v144 = 6 - 3;
			end
		end
	end
	local function v106()
		v48();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v56 = v13:GetEnemiesInRange(25 + 15);
		v57 = v17:GetEnemiesInSplashRange(22 - 12);
		if (((5739 - 1910) > (3945 - (50 + 126))) and v30) then
			v58 = v28(#v57, #v56);
		else
			v58 = 2 - 1;
		end
		if (((329 + 1156) <= (4317 - (1233 + 180))) and (v49.TargetIsValid() or v13:AffectingCombat())) then
			local v151 = 969 - (522 + 447);
			while true do
				if (((5690 - (107 + 1314)) == (1981 + 2288)) and (v151 == (0 - 0))) then
					v72 = v10.BossFightRemains(nil, true);
					v73 = v72;
					v151 = 1 + 0;
				end
				if (((768 - 381) <= (11007 - 8225)) and (v151 == (1911 - (716 + 1194)))) then
					if ((v73 == (190 + 10921)) or ((204 + 1695) <= (1420 - (74 + 429)))) then
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
		v74 = v13:GCD() + (0.25 - 0);
		if ((v51.SummonPet:IsCastable() and v43 and not v16:IsActive()) or ((2138 + 2174) <= (2004 - 1128))) then
			if (((1580 + 652) <= (8002 - 5406)) and v25(v51.SummonPet)) then
				return "summon_pet ooc";
			end
		end
		if (((5180 - 3085) < (4119 - (279 + 154))) and v49.TargetIsValid()) then
			local v152 = 778 - (454 + 324);
			while true do
				if ((v152 == (0 + 0)) or ((1612 - (12 + 5)) >= (2413 + 2061))) then
					if ((not v13:AffectingCombat() and v29) or ((11769 - 7150) < (1065 + 1817))) then
						local v171 = 1093 - (277 + 816);
						local v172;
						while true do
							if ((v171 == (0 - 0)) or ((1477 - (1058 + 125)) >= (906 + 3925))) then
								v172 = v99();
								if (((3004 - (815 + 160)) <= (13232 - 10148)) and v172) then
									return v172;
								end
								break;
							end
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((4835 - 2798) == (578 + 1842))) then
						local v173 = 0 - 0;
						local v174;
						while true do
							if (((6356 - (41 + 1857)) > (5797 - (1222 + 671))) and (v173 == (5 - 3))) then
								v174 = v49.Interrupt(v51.AxeToss, 57 - 17, true, v15, v55.AxeTossMouseover);
								if (((1618 - (229 + 953)) >= (1897 - (1111 + 663))) and v174) then
									return v174;
								end
								v174 = v49.InterruptWithStun(v51.AxeToss, 1619 - (874 + 705), true);
								v173 = 1 + 2;
							end
							if (((342 + 158) < (3774 - 1958)) and (v173 == (0 + 0))) then
								v174 = v49.Interrupt(v51.SpellLock, 719 - (642 + 37), true);
								if (((815 + 2759) == (572 + 3002)) and v174) then
									return v174;
								end
								v174 = v49.Interrupt(v51.SpellLock, 100 - 60, true, v15, v55.SpellLockMouseover);
								v173 = 455 - (233 + 221);
							end
							if (((510 - 289) < (344 + 46)) and (v173 == (1542 - (718 + 823)))) then
								if (v174 or ((1393 + 820) <= (2226 - (266 + 539)))) then
									return v174;
								end
								v174 = v49.Interrupt(v51.AxeToss, 113 - 73, true);
								if (((4283 - (636 + 589)) < (11536 - 6676)) and v174) then
									return v174;
								end
								v173 = 3 - 1;
							end
							if ((v173 == (3 + 0)) or ((471 + 825) >= (5461 - (657 + 358)))) then
								if (v174 or ((3688 - 2295) > (10226 - 5737))) then
									return v174;
								end
								v174 = v49.InterruptWithStun(v51.AxeToss, 1227 - (1151 + 36), true, v15, v55.AxeTossMouseover);
								if (v174 or ((4273 + 151) < (8 + 19))) then
									return v174;
								end
								break;
							end
						end
					end
					v100();
					v152 = 2 - 1;
				end
				if ((v152 == (1838 - (1552 + 280))) or ((2831 - (64 + 770)) > (2591 + 1224))) then
					if (((7865 - 4400) > (340 + 1573)) and v51.DrainSoul:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (1246 - (157 + 1086))) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (5 - 2)))) then
						if (((3210 - 2477) < (2789 - 970)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
							return "drain_soul main 24";
						end
					end
					if ((v51.ShadowBolt:IsReady() and v51.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v51.ShadowEmbraceDebuff) < (3 - 0)) or (v17:DebuffRemains(v51.ShadowEmbraceDebuff) < (822 - (599 + 220))))) or ((8751 - 4356) == (6686 - (1813 + 118)))) then
						if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((2773 + 1020) < (3586 - (841 + 376)))) then
							return "shadow_bolt main 26";
						end
					end
					if ((v51.MaleficRapture:IsReady() and ((v71 > (5 - 1)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (1 + 0)) and (v71 > (8 - 5))) or (v51.TormentedCrescendo:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v17:DebuffDown(v51.DreadTouchDebuff)) or (v51.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v51.TormentedCrescendoBuff) == (861 - (464 + 395)))) or v63 or (v61 and (v71 > (2 - 1))) or (v51.TormentedCrescendo:IsAvailable() and v51.Nightfall:IsAvailable() and v13:BuffUp(v51.TormentedCrescendoBuff) and v13:BuffUp(v51.NightfallBuff)))) or ((1962 + 2122) == (1102 - (467 + 370)))) then
						if (((9005 - 4647) == (3200 + 1158)) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(342 - 242))) then
							return "malefic_rapture main 28";
						end
					end
					v152 = 2 + 5;
				end
				if ((v152 == (8 - 4)) or ((3658 - (150 + 370)) < (2275 - (74 + 1208)))) then
					if (((8190 - 4860) > (11016 - 8693)) and v51.Agony:IsCastable() and (not v51.VileTaint:IsAvailable() or (v17:DebuffRemains(v51.AgonyDebuff) < (v51.VileTaint:CooldownRemains() + v51.VileTaint:CastTime()))) and (v17:DebuffRemains(v51.AgonyDebuff) < (4 + 1)) and (v73 > (395 - (14 + 376)))) then
						if (v24(v51.Agony, nil, nil, not v17:IsSpellInRange(v51.Agony)) or ((6289 - 2663) == (2582 + 1407))) then
							return "agony main 12";
						end
					end
					if ((v51.UnstableAffliction:IsReady() and (v17:DebuffRemains(v51.UnstableAfflictionDebuff) < (5 + 0)) and (v73 > (3 + 0))) or ((2683 - 1767) == (2010 + 661))) then
						if (((350 - (23 + 55)) == (644 - 372)) and v24(v51.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v51.UnstableAffliction))) then
							return "unstable_affliction main 14";
						end
					end
					if (((2836 + 1413) <= (4346 + 493)) and v51.Haunt:IsReady() and (v17:DebuffRemains(v51.HauntDebuff) < (7 - 2))) then
						if (((874 + 1903) < (4101 - (652 + 249))) and v24(v51.Haunt, nil, nil, not v17:IsSpellInRange(v51.Haunt))) then
							return "haunt main 16";
						end
					end
					v152 = 13 - 8;
				end
				if (((1963 - (708 + 1160)) < (5312 - 3355)) and ((12 - 5) == v152)) then
					if (((853 - (10 + 17)) < (386 + 1331)) and v51.DrainLife:IsReady() and ((v13:BuffStack(v51.InevitableDemiseBuff) > (1780 - (1400 + 332))) or ((v13:BuffStack(v51.InevitableDemiseBuff) > (38 - 18)) and (v73 < (1912 - (242 + 1666)))))) then
						if (((611 + 815) >= (405 + 700)) and v24(v51.DrainLife, nil, nil, not v17:IsSpellInRange(v51.DrainLife))) then
							return "drain_life main 30";
						end
					end
					if (((2348 + 406) <= (4319 - (850 + 90))) and v51.DrainSoul:IsReady() and (v13:BuffUp(v51.NightfallBuff))) then
						if (v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul)) or ((6877 - 2950) == (2803 - (360 + 1030)))) then
							return "drain_soul main 32";
						end
					end
					if ((v51.ShadowBolt:IsReady() and (v13:BuffUp(v51.NightfallBuff))) or ((1022 + 132) <= (2223 - 1435))) then
						if (v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt)) or ((2259 - 616) > (5040 - (909 + 752)))) then
							return "shadow_bolt main 34";
						end
					end
					v152 = 1231 - (109 + 1114);
				end
				if ((v152 == (1 - 0)) or ((1092 + 1711) > (4791 - (6 + 236)))) then
					if (((v58 > (1 + 0)) and (v58 < (3 + 0))) or ((518 - 298) >= (5278 - 2256))) then
						local v175 = 1133 - (1076 + 57);
						local v176;
						while true do
							if (((465 + 2357) == (3511 - (579 + 110))) and ((0 + 0) == v175)) then
								v176 = v105();
								if (v176 or ((939 + 122) == (986 + 871))) then
									return v176;
								end
								break;
							end
						end
					end
					if (((3167 - (174 + 233)) > (3809 - 2445)) and (v58 > (3 - 1))) then
						local v177 = 0 + 0;
						local v178;
						while true do
							if (((1174 - (663 + 511)) == v177) or ((4374 + 528) <= (781 + 2814))) then
								v178 = v104();
								if (v178 or ((11875 - 8023) == (178 + 115))) then
									return v178;
								end
								break;
							end
						end
					end
					if (v23() or ((3670 - 2111) == (11106 - 6518))) then
						local v179 = 0 + 0;
						local v180;
						while true do
							if ((v179 == (0 - 0)) or ((3196 + 1288) == (73 + 715))) then
								v180 = v103();
								if (((5290 - (478 + 244)) >= (4424 - (440 + 77))) and v180) then
									return v180;
								end
								break;
							end
						end
					end
					v152 = 1 + 1;
				end
				if (((4560 - 3314) < (5026 - (655 + 901))) and (v152 == (1 + 4))) then
					if (((3115 + 953) >= (657 + 315)) and v51.Corruption:IsCastable() and v17:DebuffRefreshable(v51.CorruptionDebuff) and (v73 > (20 - 15))) then
						if (((1938 - (695 + 750)) < (13293 - 9400)) and v24(v51.Corruption, nil, nil, not v17:IsSpellInRange(v51.Corruption))) then
							return "corruption main 18";
						end
					end
					if ((v51.SiphonLife:IsCastable() and v17:DebuffRefreshable(v51.SiphonLifeDebuff) and (v73 > (7 - 2))) or ((5923 - 4450) >= (3683 - (285 + 66)))) then
						if (v24(v51.SiphonLife, nil, nil, not v17:IsSpellInRange(v51.SiphonLife)) or ((9443 - 5392) <= (2467 - (682 + 628)))) then
							return "siphon_life main 20";
						end
					end
					if (((98 + 506) < (3180 - (176 + 123))) and v51.SummonDarkglare:IsReady() and (not v51.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v51.ShadowEmbraceDebuff) == (2 + 1))) and v59 and v60 and v62) then
						if (v24(v51.SummonDarkglare, v47) or ((653 + 247) == (3646 - (239 + 30)))) then
							return "summon_darkglare main 22";
						end
					end
					v152 = 2 + 4;
				end
				if (((4286 + 173) > (1045 - 454)) and (v152 == (8 - 5))) then
					if (((3713 - (306 + 9)) >= (8357 - 5962)) and v51.VileTaint:IsReady() and (not v51.SoulRot:IsAvailable() or (v66 < (1.5 + 0)) or (v51.SoulRot:CooldownRemains() <= (v51.VileTaint:ExecuteTime() + v74)) or (not v51.SouleatersGluttony:IsAvailable() and (v51.SoulRot:CooldownRemains() >= (8 + 4))))) then
						if (v24(v55.VileTaintCursor, v45, nil, not v17:IsInRange(20 + 20)) or ((6242 - 4059) >= (4199 - (1140 + 235)))) then
							return "vile_taint main 6";
						end
					end
					if (((1233 + 703) == (1776 + 160)) and v51.PhantomSingularity:IsCastable() and ((v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (not v51.SouleatersGluttony:IsAvailable() and (not v51.SoulRot:IsAvailable() or (v51.SoulRot:CooldownRemains() <= v51.PhantomSingularity:ExecuteTime()) or (v51.SoulRot:CooldownRemains() >= (7 + 18))))) and v17:DebuffUp(v51.AgonyDebuff)) then
						if (v24(v51.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v51.PhantomSingularity)) or ((4884 - (33 + 19)) < (1558 + 2755))) then
							return "phantom_singularity main 8";
						end
					end
					if (((12252 - 8164) > (1707 + 2167)) and v51.SoulRot:IsReady() and v60 and (v59 or (v51.SouleatersGluttony:TalentRank() ~= (1 - 0))) and v17:DebuffUp(v51.AgonyDebuff)) then
						if (((4063 + 269) == (5021 - (586 + 103))) and v24(v51.SoulRot, nil, nil, not v17:IsSpellInRange(v51.SoulRot))) then
							return "soul_rot main 10";
						end
					end
					v152 = 1 + 3;
				end
				if (((12311 - 8312) >= (4388 - (1309 + 179))) and (v152 == (14 - 6))) then
					if (v51.DrainSoul:IsReady() or ((1100 + 1425) > (10914 - 6850))) then
						if (((3302 + 1069) == (9286 - 4915)) and v24(v51.DrainSoul, nil, nil, not v17:IsSpellInRange(v51.DrainSoul))) then
							return "drain_soul main 36";
						end
					end
					if (v51.ShadowBolt:IsReady() or ((529 - 263) > (5595 - (295 + 314)))) then
						if (((4890 - 2899) >= (2887 - (1300 + 662))) and v24(v51.ShadowBolt, nil, nil, not v17:IsSpellInRange(v51.ShadowBolt))) then
							return "shadow_bolt main 38";
						end
					end
					break;
				end
				if (((1428 - 973) < (3808 - (1178 + 577))) and (v152 == (2 + 0))) then
					if (v33 or ((2441 - 1615) == (6256 - (851 + 554)))) then
						local v181 = v102();
						if (((162 + 21) == (507 - 324)) and v181) then
							return v181;
						end
					end
					if (((2516 - 1357) <= (2090 - (115 + 187))) and v51.MaleficRapture:IsReady() and v51.DreadTouch:IsAvailable() and (v17:DebuffRemains(v51.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v51.AgonyDebuff) > v74) and v17:DebuffUp(v51.CorruptionDebuff) and (not v51.SiphonLife:IsAvailable() or v17:DebuffUp(v51.SiphonLifeDebuff)) and v17:DebuffUp(v51.UnstableAfflictionDebuff) and (not v51.PhantomSingularity:IsAvailable() or v51.PhantomSingularity:CooldownDown()) and (not v51.VileTaint:IsAvailable() or v51.VileTaint:CooldownDown()) and (not v51.SoulRot:IsAvailable() or v51.SoulRot:CooldownDown())) then
						if (v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(95 + 5)) or ((13819 - 10312) > (5479 - (160 + 1001)))) then
							return "malefic_rapture main 2";
						end
					end
					if ((v51.MaleficRapture:IsReady() and (v73 < (4 + 0))) or ((2122 + 953) <= (6069 - 3104))) then
						if (((1723 - (237 + 121)) <= (2908 - (525 + 372))) and v24(v51.MaleficRapture, nil, nil, not v17:IsInRange(189 - 89))) then
							return "malefic_rapture main 4";
						end
					end
					v152 = 9 - 6;
				end
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
	v10.SetAPL(407 - (96 + 46), v106, v107);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

