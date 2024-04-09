local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1620 - (1427 + 192))) or ((657 + 1237) <= (3264 - 1858))) then
			return v6(...);
		end
		if (((1414 + 158) >= (694 + 837)) and (v5 == (326 - (192 + 134)))) then
			v6 = v0[v4];
			if (not v6 or ((5963 - (316 + 960)) < (2528 + 2014))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		v38 = EpicSettings.Settings['HealthstoneHP'] or (551 - (83 + 468));
		v39 = EpicSettings.Settings['InterruptWithStun'] or (1806 - (1202 + 604));
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
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
	local v54 = (v53[5 + 8] and v19(v53[8 + 5])) or v19(0 + 0);
	local v55 = (v53[25 - 11] and v19(v53[1925 - (340 + 1571)])) or v19(0 + 0);
	local v56 = v22.Warlock.Affliction;
	local v57, v58, v59;
	local v60, v61, v62, v63, v64, v65, v66;
	local v67;
	local v68;
	local v69 = 12883 - (1733 + 39);
	local v70 = 30531 - 19420;
	v10:RegisterForEvent(function()
		local v103 = 1034 - (125 + 909);
		while true do
			if (((5239 - (1096 + 852)) > (748 + 919)) and (v103 == (1 - 0))) then
				v50.Haunt:RegisterInFlight();
				break;
			end
			if ((v103 == (0 + 0)) or ((1385 - (409 + 103)) == (2270 - (46 + 190)))) then
				v50.SeedofCorruption:RegisterInFlight();
				v50.ShadowBolt:RegisterInFlight();
				v103 = 96 - (51 + 44);
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v50.SeedofCorruption:RegisterInFlight();
	v50.ShadowBolt:RegisterInFlight();
	v50.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		v53 = v13:GetEquipment();
		v54 = (v53[4 + 9] and v19(v53[1330 - (1114 + 203)])) or v19(726 - (228 + 498));
		v55 = (v53[4 + 10] and v19(v53[8 + 6])) or v19(663 - (174 + 489));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v104 = 0 - 0;
		while true do
			if ((v104 == (1905 - (830 + 1075))) or ((3340 - (303 + 221)) < (1280 - (231 + 1038)))) then
				v69 = 9259 + 1852;
				v70 = 12273 - (171 + 991);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v71(v105)
		local v106 = 0 - 0;
		local v107;
		while true do
			if (((9932 - 6233) < (11743 - 7037)) and (v106 == (1 + 0))) then
				return v107 or (0 - 0);
			end
			if (((7633 - 4987) >= (1411 - 535)) and (v106 == (0 - 0))) then
				v107 = nil;
				for v142, v143 in pairs(v105) do
					local v144 = 1248 - (111 + 1137);
					local v145;
					while true do
						if (((772 - (91 + 67)) <= (9476 - 6292)) and ((0 + 0) == v144)) then
							v145 = v143:DebuffRemains(v50.AgonyDebuff) + ((622 - (423 + 100)) * v27(v143:DebuffDown(v50.AgonyDebuff)));
							if (((22 + 3104) == (8654 - 5528)) and ((v107 == nil) or (v145 < v107))) then
								v107 = v145;
							end
							break;
						end
					end
				end
				v106 = 1 + 0;
			end
		end
	end
	local function v72(v108)
		if (v50.SeedofCorruption:InFlight() or v13:PrevGCDP(772 - (326 + 445), v50.SeedofCorruption) or ((9543 - 7356) >= (11036 - 6082))) then
			return false;
		end
		local v109 = 0 - 0;
		local v110 = 711 - (530 + 181);
		for v132, v133 in pairs(v108) do
			v109 = v109 + (882 - (614 + 267));
			if (v133:DebuffUp(v50.SeedofCorruptionDebuff) or ((3909 - (19 + 13)) == (5818 - 2243))) then
				v110 = v110 + (2 - 1);
			end
		end
		return v109 == v110;
	end
	local function v73(v111)
		return (v111:DebuffRemains(v50.AgonyDebuff));
	end
	local function v74(v112)
		return (v112:DebuffRemains(v50.CorruptionDebuff));
	end
	local function v75(v113)
		return (v113:DebuffRemains(v50.SiphonLifeDebuff));
	end
	local function v76(v114)
		return (v114:DebuffRemains(v50.AgonyDebuff) < (v114:DebuffRemains(v50.VileTaintDebuff) + v50.VileTaint:CastTime())) and (v114:DebuffRemains(v50.AgonyDebuff) < (14 - 9));
	end
	local function v77(v115)
		return v115:DebuffRemains(v50.AgonyDebuff) < (2 + 3);
	end
	local function v78(v116)
		return v116:DebuffRemains(v50.CorruptionDebuff) < (8 - 3);
	end
	local function v79(v117)
		return (v117:DebuffRefreshable(v50.SiphonLifeDebuff));
	end
	local function v80(v118)
		return v118:DebuffRemains(v50.AgonyDebuff) < (10 - 5);
	end
	local function v81(v119)
		return (v119:DebuffRefreshable(v50.AgonyDebuff));
	end
	local function v82(v120)
		return v120:DebuffRemains(v50.CorruptionDebuff) < (1817 - (1293 + 519));
	end
	local function v83(v121)
		return (v121:DebuffRefreshable(v50.CorruptionDebuff));
	end
	local function v84(v122)
		return (v122:DebuffStack(v50.ShadowEmbraceDebuff) < (5 - 2)) or (v122:DebuffRemains(v50.ShadowEmbraceDebuff) < (7 - 4));
	end
	local function v85(v123)
		return v123:DebuffRemains(v50.SiphonLifeDebuff) < (9 - 4);
	end
	local function v86()
		if (((3048 - 2341) > (1488 - 856)) and v50.GrimoireofSacrifice:IsCastable()) then
			if (v26(v50.GrimoireofSacrifice) or ((290 + 256) >= (548 + 2136))) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (((3403 - 1938) <= (994 + 3307)) and v50.Haunt:IsReady()) then
			if (((567 + 1137) > (891 + 534)) and v26(v50.Haunt, not v17:IsSpellInRange(v50.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if ((v50.UnstableAffliction:IsReady() and not v50.SoulSwap:IsAvailable()) or ((1783 - (709 + 387)) == (6092 - (673 + 1185)))) then
			if (v26(v50.UnstableAffliction, not v17:IsSpellInRange(v50.UnstableAffliction), true) or ((9657 - 6327) < (4588 - 3159))) then
				return "unstable_affliction precombat 8";
			end
		end
		if (((1886 - 739) >= (240 + 95)) and v50.ShadowBolt:IsReady()) then
			if (((2567 + 868) > (2831 - 734)) and v26(v50.ShadowBolt, not v17:IsSpellInRange(v50.ShadowBolt), true)) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v87()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (3 - 1)) or ((7400 - 3630) >= (5921 - (446 + 1434)))) then
				v64 = v60 and v61 and v63;
				v65 = v50.PhantomSingularity:IsAvailable() or v50.VileTaint:IsAvailable() or v50.SoulRot:IsAvailable() or v50.SummonDarkglare:IsAvailable();
				v124 = 1286 - (1040 + 243);
			end
			if ((v124 == (0 - 0)) or ((5638 - (559 + 1288)) <= (3542 - (609 + 1322)))) then
				v60 = v17:DebuffUp(v50.PhantomSingularityDebuff) or not v50.PhantomSingularity:IsAvailable();
				v61 = v17:DebuffUp(v50.VileTaintDebuff) or not v50.VileTaint:IsAvailable();
				v124 = 455 - (13 + 441);
			end
			if (((10 - 7) == v124) or ((11991 - 7413) <= (10000 - 7992))) then
				v66 = not v65 or (v10.GuardiansTable.DarkglareDuration > (0 + 0)) or (v64 and (v50.SummonDarkglare:CooldownRemains() > (72 - 52))) or v13:PowerInfusionUp();
				break;
			end
			if (((400 + 725) <= (910 + 1166)) and (v124 == (2 - 1))) then
				v62 = v17:DebuffUp(v50.VileTaintDebuff) or v17:DebuffUp(v50.PhantomSingularityDebuff) or (not v50.VileTaint:IsAvailable() and not v50.PhantomSingularity:IsAvailable());
				v63 = v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable();
				v124 = 2 + 0;
			end
		end
	end
	local function v88()
		ShouldReturn = v49.HandleTopTrinket(v52, v31, 73 - 33, nil);
		if (ShouldReturn or ((492 + 251) >= (2447 + 1952))) then
			return ShouldReturn;
		end
		ShouldReturn = v49.HandleBottomTrinket(v52, v31, 29 + 11, nil);
		if (((970 + 185) < (1637 + 36)) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v89()
		local v125 = 433 - (153 + 280);
		local v126;
		while true do
			if (((0 - 0) == v125) or ((2087 + 237) <= (229 + 349))) then
				v126 = v88();
				if (((1972 + 1795) == (3419 + 348)) and v126) then
					return v126;
				end
				v125 = 1 + 0;
			end
			if (((6225 - 2136) == (2528 + 1561)) and (v125 == (668 - (89 + 578)))) then
				if (((3185 + 1273) >= (3480 - 1806)) and v51.DesperateInvokersCodex:IsEquippedAndReady()) then
					if (((2021 - (572 + 477)) <= (192 + 1226)) and v26(v56.DesperateInvokersCodex, not v17:IsInRange(28 + 17))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (v51.ConjuredChillglobe:IsEquippedAndReady() or ((590 + 4348) < (4848 - (84 + 2)))) then
					if (v26(v56.ConjuredChillglobe) or ((4126 - 1622) > (3072 + 1192))) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
		end
	end
	local function v90()
		if (((2995 - (497 + 345)) == (56 + 2097)) and v66) then
			local v135 = 0 + 0;
			local v136;
			while true do
				if (((1335 - (605 + 728)) == v135) or ((362 + 145) >= (5760 - 3169))) then
					if (((206 + 4275) == (16567 - 12086)) and v50.Fireblood:IsCastable()) then
						if (v26(v50.Fireblood) or ((2099 + 229) < (1919 - 1226))) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if (((3268 + 1060) == (4817 - (457 + 32))) and ((1 + 0) == v135)) then
					if (((2990 - (832 + 570)) >= (1255 + 77)) and v50.Berserking:IsCastable()) then
						if (v26(v50.Berserking) or ((1089 + 3085) > (15032 - 10784))) then
							return "berserking ogcd 4";
						end
					end
					if (v50.BloodFury:IsCastable() or ((2210 + 2376) <= (878 - (588 + 208)))) then
						if (((10411 - 6548) == (5663 - (884 + 916))) and v26(v50.BloodFury)) then
							return "blood_fury ogcd 6";
						end
					end
					v135 = 3 - 1;
				end
				if ((v135 == (0 + 0)) or ((935 - (232 + 421)) <= (1931 - (1569 + 320)))) then
					v136 = v49.HandleDPSPotion();
					if (((1131 + 3478) >= (146 + 620)) and v136) then
						return v136;
					end
					v135 = 3 - 2;
				end
			end
		end
	end
	local function v91()
		if (v31 or ((1757 - (316 + 289)) == (6512 - 4024))) then
			local v137 = 0 + 0;
			local v138;
			while true do
				if (((4875 - (666 + 787)) > (3775 - (360 + 65))) and (v137 == (0 + 0))) then
					v138 = v90();
					if (((1131 - (79 + 175)) > (592 - 216)) and v138) then
						return v138;
					end
					break;
				end
			end
		end
		local v127 = v89();
		if (v127 or ((2434 + 684) <= (5673 - 3822))) then
			return v127;
		end
		v67 = v71(v58);
		if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (5 - 2))) or ((1064 - (503 + 396)) >= (3673 - (92 + 89)))) then
			if (((7660 - 3711) < (2491 + 2365)) and v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt))) then
				return "haunt aoe 2";
			end
		end
		if ((v50.VileTaint:IsReady() and (((v50.SouleatersGluttony:TalentRank() == (2 + 0)) and ((v67 < (3.5 - 2)) or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()))) or ((v50.SouleatersGluttony:TalentRank() == (1 + 0)) and (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime())) or (not v50.SouleatersGluttony:IsAvailable() and ((v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (v50.VileTaint:CooldownRemains() > (57 - 32)))))) or ((3731 + 545) < (1441 + 1575))) then
			if (((14284 - 9594) > (515 + 3610)) and v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(61 - 21))) then
				return "vile_taint aoe 4";
			end
		end
		if (v50.PhantomSingularity:IsCastable() or ((1294 - (485 + 759)) >= (2073 - 1177))) then
			if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((2903 - (442 + 747)) >= (4093 - (832 + 303)))) then
				return "phantom_singularity aoe 6";
			end
		end
		if ((v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (951 - (88 + 858)))) or ((455 + 1036) < (533 + 111))) then
			if (((29 + 675) < (1776 - (766 + 23))) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
				return "unstable_affliction aoe 8";
			end
		end
		if (((18354 - 14636) > (2605 - 699)) and v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (15 - 9)) and v50.SummonDarkglare:CooldownUp()) then
			if (v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife)) or ((3251 - 2293) > (4708 - (1036 + 37)))) then
				return "siphon_life aoe 10";
			end
		end
		if (((2483 + 1018) <= (8747 - 4255)) and v50.SoulRot:IsReady() and v61 and v60) then
			if (v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot)) or ((2708 + 734) < (4028 - (641 + 839)))) then
				return "soul_rot aoe 12";
			end
		end
		if (((3788 - (910 + 3)) >= (3731 - 2267)) and v50.SeedofCorruption:IsReady() and (v17:DebuffRemains(v50.CorruptionDebuff) < (1689 - (1466 + 218))) and not (v50.SeedofCorruption:InFlight() or v17:DebuffUp(v50.SeedofCorruptionDebuff))) then
			if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or ((2205 + 2592) >= (6041 - (556 + 592)))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if ((v50.Agony:IsReady() and (v50.AgonyDebuff:AuraActiveCount() < (3 + 5))) or ((1359 - (329 + 479)) > (2922 - (174 + 680)))) then
			if (((7263 - 5149) > (1956 - 1012)) and v49.CastTargetIf(v50.Agony, v57, "min", v73, v76, not v17:IsSpellInRange(v50.Agony))) then
				return "agony aoe 16";
			end
		end
		if ((v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) or ((1615 + 647) >= (3835 - (396 + 343)))) then
			if (v25(v50.SummonDarkglare, v47) or ((200 + 2055) >= (5014 - (29 + 1448)))) then
				return "summon_darkglare aoe 18";
			end
		end
		if ((v50.MaleficRapture:IsReady() and (v13:BuffUp(v50.UmbrafireKindlingBuff))) or ((5226 - (135 + 1254)) < (4919 - 3613))) then
			if (((13773 - 10823) == (1966 + 984)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(1627 - (389 + 1138)))) then
				return "malefic_rapture aoe 20";
			end
		end
		if ((v50.SeedofCorruption:IsReady() and v50.SowTheSeeds:IsAvailable()) or ((5297 - (102 + 472)) < (3113 + 185))) then
			if (((630 + 506) >= (144 + 10)) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if ((v50.MaleficRapture:IsReady() and ((((v50.SummonDarkglare:CooldownRemains() > (1560 - (320 + 1225))) or (v68 > (5 - 2))) and not v50.SowTheSeeds:IsAvailable()) or v13:BuffUp(v50.TormentedCrescendoBuff))) or ((166 + 105) > (6212 - (157 + 1307)))) then
			if (((6599 - (821 + 1038)) >= (7863 - 4711)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(11 + 89))) then
				return "malefic_rapture aoe 24";
			end
		end
		if ((v50.DrainLife:IsReady() and (v17:DebuffUp(v50.SoulRotDebuff) or not v50.SoulRot:IsAvailable()) and (v13:BuffStack(v50.InevitableDemiseBuff) > (17 - 7))) or ((960 + 1618) >= (8402 - 5012))) then
			if (((1067 - (834 + 192)) <= (106 + 1555)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
				return "drain_life aoe 26";
			end
		end
		if (((155 + 446) < (77 + 3483)) and v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) then
			if (((364 - 129) < (991 - (300 + 4))) and v49.CastCycle(v50.DrainSoul, v57, v84, not v17:IsSpellInRange(v50.DrainSoul))) then
				return "drain_soul aoe 28";
			end
		end
		if (((1215 + 3334) > (3018 - 1865)) and v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
			if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((5036 - (112 + 250)) < (1863 + 2809))) then
				return "drain_soul aoe 30";
			end
		end
		if (((9188 - 5520) < (2613 + 1948)) and v50.SummonSoulkeeper:IsReady() and ((v50.SummonSoulkeeper:Count() == (6 + 4)) or ((v50.SummonSoulkeeper:Count() > (3 + 0)) and (v70 < (5 + 5))))) then
			if (v25(v50.SummonSoulkeeper) or ((339 + 116) == (5019 - (1001 + 413)))) then
				return "soul_strike aoe 32";
			end
		end
		if ((v50.SiphonLife:IsReady() and (v50.SiphonLifeDebuff:AuraActiveCount() < (11 - 6))) or ((3545 - (244 + 638)) == (4005 - (627 + 66)))) then
			if (((12743 - 8466) <= (5077 - (512 + 90))) and v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife))) then
				return "siphon_life aoe 34";
			end
		end
		if (v50.DrainSoul:IsReady() or ((2776 - (1665 + 241)) == (1906 - (373 + 344)))) then
			if (((701 + 852) <= (829 + 2304)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
				return "drain_soul aoe 36";
			end
		end
		if (v50.ShadowBolt:IsReady() or ((5900 - 3663) >= (5941 - 2430))) then
			if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((2423 - (35 + 1064)) > (2198 + 822))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v92()
		local v128 = 0 - 0;
		local v129;
		while true do
			if ((v128 == (1 + 4)) or ((4228 - (298 + 938)) == (3140 - (233 + 1026)))) then
				if (((4772 - (636 + 1030)) > (781 + 745)) and v50.DrainLife:IsReady() and v17:DebuffUp(v50.SoulRotDebuff) and (v13:BuffStack(v50.InevitableDemiseBuff) > (10 + 0))) then
					if (((899 + 2124) < (262 + 3608)) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return "drain_life cleave 46";
					end
				end
				if (((364 - (55 + 166)) > (15 + 59)) and v50.Agony:IsReady()) then
					if (((2 + 16) < (8065 - 5953)) and v49.CastCycle(v50.Agony, v57, v81, not v17:IsSpellInRange(v50.Agony))) then
						return "agony cleave 48";
					end
				end
				if (((1394 - (36 + 261)) <= (2846 - 1218)) and v50.Corruption:IsCastable()) then
					if (((5998 - (34 + 1334)) == (1780 + 2850)) and v49.CastCycle(v50.Corruption, v57, v83, not v17:IsSpellInRange(v50.Corruption))) then
						return "corruption cleave 50";
					end
				end
				if (((2751 + 789) > (3966 - (1035 + 248))) and v50.MaleficRapture:IsReady() and (v68 > (22 - (20 + 1)))) then
					if (((2498 + 2296) >= (3594 - (134 + 185))) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(1233 - (549 + 584)))) then
						return "malefic_rapture cleave 52";
					end
				end
				if (((2169 - (314 + 371)) == (5094 - 3610)) and v50.DrainSoul:IsReady()) then
					if (((2400 - (478 + 490)) < (1884 + 1671)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				v128 = 1178 - (786 + 386);
			end
			if ((v128 == (6 - 4)) or ((2444 - (1055 + 324)) > (4918 - (1093 + 247)))) then
				if ((v50.SeedofCorruption:IsReady() and not v50.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v50.CorruptionDebuff) < (5 + 0)) and v50.SowTheSeeds:IsAvailable() and v72()) or ((505 + 4290) < (5586 - 4179))) then
					if (((6288 - 4435) < (13695 - 8882)) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
						return "seed_of_corruption cleave 16";
					end
				end
				if (v50.Corruption:IsReady() or ((7088 - 4267) < (865 + 1566))) then
					if (v49.CastTargetIf(v50.Corruption, v57, "min", v74, v78, not v17:IsSpellInRange(v50.Corruption)) or ((11071 - 8197) < (7517 - 5336))) then
						return "corruption cleave 18";
					end
				end
				if (v50.SiphonLife:IsReady() or ((2028 + 661) <= (876 - 533))) then
					if (v49.CastTargetIf(v50.SiphonLife, v57, "min", v75, v79, not v17:IsSpellInRange(v50.SiphonLife)) or ((2557 - (364 + 324)) == (5507 - 3498))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (6 - 3))) or ((1176 + 2370) < (9715 - 7393))) then
					if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((3333 - 1251) == (14495 - 9722))) then
						return "haunt cleave 22";
					end
				end
				if (((4512 - (1249 + 19)) > (953 + 102)) and v50.PhantomSingularity:IsReady() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (97 - 72)))))) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((4399 - (686 + 400)) <= (1396 + 382))) then
						return "phantom_singularity cleave 24";
					end
				end
				v128 = 232 - (73 + 156);
			end
			if ((v128 == (1 + 5)) or ((2232 - (721 + 90)) >= (24 + 2080))) then
				if (((5883 - 4071) <= (3719 - (224 + 246))) and v50.ShadowBolt:IsReady()) then
					if (((2628 - 1005) <= (3602 - 1645)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
						return "shadow_bolt cleave 56";
					end
				end
				break;
			end
			if (((801 + 3611) == (105 + 4307)) and (v128 == (1 + 0))) then
				if (((3479 - 1729) >= (2801 - 1959)) and v50.Agony:IsReady()) then
					if (((4885 - (203 + 310)) > (3843 - (1238 + 755))) and v49.CastTargetIf(v50.Agony, v57, "min", v73, v77, not v17:IsSpellInRange(v50.Agony))) then
						return "agony cleave 6";
					end
				end
				if (((17 + 215) < (2355 - (709 + 825))) and v50.SoulRot:IsReady() and v61 and v60) then
					if (((954 - 436) < (1313 - 411)) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				if (((3858 - (196 + 668)) > (3387 - 2529)) and v50.VileTaint:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (3 - 1)) and (v50.CorruptionDebuff:AuraActiveCount() == (835 - (171 + 662))) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (95 - (4 + 89)))) and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (41 - 29))))) then
					if (v25(v56.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v50.VileTaint)) or ((1368 + 2387) <= (4018 - 3103))) then
						return "vile_taint cleave 10";
					end
				end
				if (((1548 + 2398) > (5229 - (35 + 1451))) and v50.PhantomSingularity:IsReady() and (v50.AgonyDebuff:AuraActiveCount() == (1455 - (28 + 1425))) and (v50.CorruptionDebuff:AuraActiveCount() == (1995 - (941 + 1052))) and (not v50.SiphonLife:IsAvailable() or (v50.SiphonLifeDebuff:AuraActiveCount() == (2 + 0))) and (v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (1539 - (822 + 692))))) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or ((1905 - 570) >= (1558 + 1748))) then
						return "phantom_singularity cleave 12";
					end
				end
				if (((5141 - (45 + 252)) > (2230 + 23)) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (2 + 3))) then
					if (((1099 - 647) == (885 - (114 + 319))) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
						return "unstable_affliction cleave 14";
					end
				end
				v128 = 2 - 0;
			end
			if ((v128 == (0 - 0)) or ((2906 + 1651) < (3108 - 1021))) then
				if (((8116 - 4242) == (5837 - (556 + 1407))) and v31) then
					local v146 = 1206 - (741 + 465);
					local v147;
					while true do
						if ((v146 == (465 - (170 + 295))) or ((1022 + 916) > (4533 + 402))) then
							v147 = v90();
							if (v147 or ((10475 - 6220) < (2838 + 585))) then
								return v147;
							end
							break;
						end
					end
				end
				v129 = v89();
				if (((933 + 521) <= (1411 + 1080)) and v129) then
					return v129;
				end
				if ((v31 and v50.SummonDarkglare:IsCastable() and v60 and v61 and v63) or ((5387 - (957 + 273)) <= (750 + 2053))) then
					if (((1943 + 2910) >= (11362 - 8380)) and v25(v50.SummonDarkglare, v47)) then
						return "summon_darkglare cleave 2";
					end
				end
				if (((10893 - 6759) > (10253 - 6896)) and v50.MaleficRapture:IsReady() and ((v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (9 - 7)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) or (v68 > (1784 - (389 + 1391))) or v13:BuffUp(v50.UmbrafireKindlingBuff))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(63 + 37)) or ((356 + 3061) < (5768 - 3234))) then
						return "malefic_rapture cleave 4";
					end
				end
				v128 = 952 - (783 + 168);
			end
			if (((9 - 6) == v128) or ((2678 + 44) <= (475 - (309 + 2)))) then
				if (v50.SoulRot:IsReady() or ((7394 - 4986) < (3321 - (1090 + 122)))) then
					if (v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot)) or ((11 + 22) == (4886 - 3431))) then
						return "soul_rot cleave 26";
					end
				end
				if ((v50.MaleficRapture:IsReady() and ((v68 > (3 + 1)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (1119 - (628 + 490))) and (v68 > (1 + 2))))) or ((1096 - 653) >= (18348 - 14333))) then
					if (((4156 - (431 + 343)) > (335 - 169)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(289 - 189))) then
						return "malefic_rapture cleave 28";
					end
				end
				if ((v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < v13:GCD())) or ((222 + 58) == (392 + 2667))) then
					if (((3576 - (556 + 1139)) > (1308 - (6 + 9))) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(19 + 81))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((1208 + 1149) == (2526 - (28 + 141))) and v50.MaleficRapture:IsReady() and not v50.DreadTouch:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff)) then
					if (((48 + 75) == (151 - 28)) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(71 + 29))) then
						return "malefic_rapture cleave 32";
					end
				end
				if ((v50.MaleficRapture:IsReady() and (v64 or v62)) or ((2373 - (486 + 831)) >= (8826 - 5434))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(352 - 252)) or ((205 + 876) < (3398 - 2323))) then
						return "malefic_rapture cleave 34";
					end
				end
				v128 = 1267 - (668 + 595);
			end
			if ((v128 == (4 + 0)) or ((212 + 837) >= (12086 - 7654))) then
				if ((v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50.ShadowEmbrace:IsAvailable()) or ((5058 - (23 + 267)) <= (2790 - (1129 + 815)))) then
					if (v49.CastCycle(v50.DrainSoul, v57, EvaluatecycleDrainSoul, not v17:IsSpellInRange(v50.DrainSoul)) or ((3745 - (371 + 16)) <= (3170 - (1326 + 424)))) then
						return "drain_soul cleave 36";
					end
				end
				if ((v50.DrainSoul:IsReady() and v13:BuffUp(v50.NightfallBuff)) or ((7081 - 3342) <= (10980 - 7975))) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or ((1777 - (88 + 30)) >= (2905 - (720 + 51)))) then
						return "drain_soul cleave 38";
					end
				end
				if ((v50.ShadowBolt:IsReady() and v13:BuffUp(v50.NightfallBuff)) or ((7251 - 3991) < (4131 - (421 + 1355)))) then
					if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or ((1103 - 434) == (2075 + 2148))) then
						return "shadow_bolt cleave 40";
					end
				end
				if ((v50.MaleficRapture:IsReady() and (v68 > (1086 - (286 + 797)))) or ((6185 - 4493) < (973 - 385))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(539 - (397 + 42))) or ((1499 + 3298) < (4451 - (24 + 776)))) then
						return "malefic_rapture cleave 42";
					end
				end
				if ((v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (73 - 25)) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (805 - (222 + 563))) and (v70 < (8 - 4))))) or ((3008 + 1169) > (5040 - (23 + 167)))) then
					if (v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife)) or ((2198 - (690 + 1108)) > (401 + 710))) then
						return "drain_life cleave 44";
					end
				end
				v128 = 5 + 0;
			end
		end
	end
	local function v93()
		local v130 = 848 - (40 + 808);
		while true do
			if (((503 + 2548) > (3843 - 2838)) and (v130 == (2 + 0))) then
				v68 = v13:SoulShardsP();
				if (((1954 + 1739) <= (2403 + 1979)) and v50.SummonPet:IsCastable() and v43 and not v16:IsActive()) then
					if (v26(v50.SummonPet) or ((3853 - (47 + 524)) > (2661 + 1439))) then
						return "summon_pet ooc";
					end
				end
				if (v49.TargetIsValid() or ((9786 - 6206) < (4252 - 1408))) then
					local v148 = 0 - 0;
					while true do
						if (((1815 - (1165 + 561)) < (134 + 4356)) and (v148 == (15 - 10))) then
							if ((v50.ShadowBolt:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (2 + 1)) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (482 - (341 + 138))))) or ((1346 + 3637) < (3730 - 1922))) then
								if (((4155 - (89 + 237)) > (12124 - 8355)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
									return "shadow_bolt main 18";
								end
							end
							if (((3126 - 1641) <= (3785 - (581 + 300))) and v50.PhantomSingularity:IsCastable() and ((v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.PhantomSingularity:ExecuteTime()) or (v50.SoulRot:CooldownRemains() >= (1245 - (855 + 365))))))) then
								if (((10139 - 5870) == (1394 + 2875)) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
									return "phantom_singularity main 20";
								end
							end
							if (((1622 - (1030 + 205)) <= (2612 + 170)) and v50.VileTaint:IsReady() and (not v50.SoulRot:IsAvailable() or (v50.SoulRot:CooldownRemains() <= v50.VileTaint:ExecuteTime()) or (not v50.SouleatersGluttony:IsAvailable() and (v50.SoulRot:CooldownRemains() >= (12 + 0))))) then
								if (v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(326 - (156 + 130))) or ((4314 - 2415) <= (1544 - 627))) then
									return "vile_taint main 22";
								end
							end
							v148 = 11 - 5;
						end
						if ((v148 == (2 + 4)) or ((2515 + 1797) <= (945 - (10 + 59)))) then
							if (((632 + 1600) <= (12784 - 10188)) and v50.SoulRot:IsReady() and v61 and (v60 or (v50.SouleatersGluttony:TalentRank() ~= (1164 - (671 + 492))))) then
								if (((1668 + 427) < (4901 - (369 + 846))) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
									return "soul_rot main 24";
								end
							end
							if ((v50.MaleficRapture:IsReady() and ((v68 > (2 + 2)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (1 + 0)) and (v68 > (1948 - (1036 + 909)))) or (v50.TormentedCrescendo:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v17:DebuffDown(v50.DreadTouchDebuff)) or (v50.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == (2 + 0))) or v64 or (v62 and (v68 > (1 - 0))) or (v50.TormentedCrescendo:IsAvailable() and v50.Nightfall:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v13:BuffUp(v50.NightfallBuff)))) or ((1798 - (11 + 192)) >= (2261 + 2213))) then
								if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(275 - (135 + 40))) or ((11191 - 6572) < (1738 + 1144))) then
									return "malefic_rapture main 26";
								end
							end
							if ((v50.DrainLife:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > (105 - 57)) or ((v13:BuffStack(v50.InevitableDemiseBuff) > (29 - 9)) and (v70 < (180 - (50 + 126)))))) or ((818 - 524) >= (1070 + 3761))) then
								if (((3442 - (1233 + 180)) <= (4053 - (522 + 447))) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
									return "drain_life main 28";
								end
							end
							v148 = 1428 - (107 + 1314);
						end
						if ((v148 == (2 + 1)) or ((6206 - 4169) == (1028 + 1392))) then
							if (((8852 - 4394) > (15446 - 11542)) and v50.Agony:IsCastable() and (v17:DebuffRemains(v50.AgonyDebuff) < (1915 - (716 + 1194)))) then
								if (((8 + 428) >= (14 + 109)) and v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony))) then
									return "agony main 6";
								end
							end
							if (((1003 - (74 + 429)) < (3503 - 1687)) and v50.UnstableAffliction:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < (3 + 2))) then
								if (((8180 - 4606) == (2529 + 1045)) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
									return "unstable_affliction main 8";
								end
							end
							if (((681 - 460) < (964 - 574)) and v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) then
								if (v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption)) or ((2646 - (279 + 154)) <= (2199 - (454 + 324)))) then
									return "corruption main 10";
								end
							end
							v148 = 4 + 0;
						end
						if (((3075 - (12 + 5)) < (2621 + 2239)) and (v148 == (10 - 6))) then
							if ((v50.SiphonLife:IsCastable() and (v17:DebuffRefreshable(v50.SiphonLifeDebuff))) or ((479 + 817) >= (5539 - (277 + 816)))) then
								if (v25(v50.SiphonLife, nil, nil, not v17:IsSpellInRange(v50.SiphonLife)) or ((5952 - 4559) > (5672 - (1058 + 125)))) then
									return "siphon_life main 12";
								end
							end
							if ((v50.Haunt:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < (1 + 2))) or ((5399 - (815 + 160)) < (115 - 88))) then
								if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or ((4740 - 2743) > (911 + 2904))) then
									return "haunt main 14";
								end
							end
							if (((10128 - 6663) > (3811 - (41 + 1857))) and v50.DrainSoul:IsReady() and v50.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < (1896 - (1222 + 671))) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < (7 - 4)))) then
								if (((1052 - 319) < (3001 - (229 + 953))) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
									return "drain_soul main 16";
								end
							end
							v148 = 1779 - (1111 + 663);
						end
						if ((v148 == (1580 - (874 + 705))) or ((616 + 3779) == (3245 + 1510))) then
							if (((v59 > (1 - 0)) and (v59 < (1 + 2))) or ((4472 - (642 + 37)) < (541 + 1828))) then
								local v150 = 0 + 0;
								local v151;
								while true do
									if ((v150 == (0 - 0)) or ((4538 - (233 + 221)) == (612 - 347))) then
										v151 = v92();
										if (((3836 + 522) == (5899 - (718 + 823))) and v151) then
											return v151;
										end
										break;
									end
								end
							end
							if ((v59 > (2 + 0)) or ((3943 - (266 + 539)) < (2811 - 1818))) then
								local v152 = 1225 - (636 + 589);
								local v153;
								while true do
									if (((7904 - 4574) > (4790 - 2467)) and ((0 + 0) == v152)) then
										v153 = v91();
										if (v153 or ((1318 + 2308) == (5004 - (657 + 358)))) then
											return v153;
										end
										break;
									end
								end
							end
							if (v24() or ((2425 - 1509) == (6085 - 3414))) then
								local v154 = 1187 - (1151 + 36);
								local v155;
								while true do
									if (((263 + 9) == (72 + 200)) and (v154 == (0 - 0))) then
										v155 = v90();
										if (((6081 - (1552 + 280)) <= (5673 - (64 + 770))) and v155) then
											return v155;
										end
										break;
									end
								end
							end
							v148 = 2 + 0;
						end
						if (((6303 - 3526) < (569 + 2631)) and (v148 == (1243 - (157 + 1086)))) then
							if (((190 - 95) < (8571 - 6614)) and not v13:AffectingCombat() and v29) then
								local v156 = 0 - 0;
								local v157;
								while true do
									if (((1126 - 300) < (2536 - (599 + 220))) and (v156 == (0 - 0))) then
										v157 = v86();
										if (((3357 - (1813 + 118)) >= (808 + 297)) and v157) then
											return v157;
										end
										break;
									end
								end
							end
							if (((3971 - (841 + 376)) <= (4734 - 1355)) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v158 = 0 + 0;
								local v159;
								while true do
									if ((v158 == (2 - 1)) or ((4786 - (464 + 395)) == (3626 - 2213))) then
										v159 = v49.Interrupt(v50.AxeToss, 20 + 20, true);
										if (v159 or ((1991 - (467 + 370)) <= (1628 - 840))) then
											return v159;
										end
										v159 = v49.Interrupt(v50.AxeToss, 30 + 10, true, v15, v56.AxeTossMouseover);
										if (v159 or ((5632 - 3989) > (528 + 2851))) then
											return v159;
										end
										v158 = 4 - 2;
									end
									if ((v158 == (522 - (150 + 370))) or ((4085 - (74 + 1208)) > (11188 - 6639))) then
										v159 = v49.InterruptWithStun(v50.AxeToss, 189 - 149, true);
										if (v159 or ((157 + 63) >= (3412 - (14 + 376)))) then
											return v159;
										end
										v159 = v49.InterruptWithStun(v50.AxeToss, 69 - 29, true, v15, v56.AxeTossMouseover);
										if (((1827 + 995) == (2479 + 343)) and v159) then
											return v159;
										end
										break;
									end
									if ((v158 == (0 + 0)) or ((3108 - 2047) == (1398 + 459))) then
										v159 = v49.Interrupt(v50.SpellLock, 118 - (23 + 55), true);
										if (((6541 - 3781) > (911 + 453)) and v159) then
											return v159;
										end
										v159 = v49.Interrupt(v50.SpellLock, 36 + 4, true, v15, v56.SpellLockMouseover);
										if (v159 or ((7600 - 2698) <= (1131 + 2464))) then
											return v159;
										end
										v158 = 902 - (652 + 249);
									end
								end
							end
							v87();
							v148 = 2 - 1;
						end
						if ((v148 == (1876 - (708 + 1160))) or ((10455 - 6603) == (534 - 241))) then
							if ((v50.Corruption:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) or ((1586 - (10 + 17)) == (1031 + 3557))) then
								if (v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption)) or ((6216 - (1400 + 332)) == (1511 - 723))) then
									return "corruption main 36";
								end
							end
							if (((6476 - (242 + 1666)) >= (1672 + 2235)) and v50.DrainSoul:IsReady()) then
								if (((457 + 789) < (2958 + 512)) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
									return "drain_soul main 40";
								end
							end
							if (((5008 - (850 + 90)) >= (1701 - 729)) and v50.ShadowBolt:IsReady()) then
								if (((1883 - (360 + 1030)) < (3446 + 447)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
									return "shadow_bolt main 42";
								end
							end
							break;
						end
						if ((v148 == (19 - 12)) or ((2025 - 552) >= (4993 - (909 + 752)))) then
							if ((v50.DrainSoul:IsReady() and (v13:BuffUp(v50.NightfallBuff))) or ((5274 - (109 + 1114)) <= (2117 - 960))) then
								if (((236 + 368) < (3123 - (6 + 236))) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
									return "drain_soul main 30";
								end
							end
							if ((v50.ShadowBolt:IsReady() and (v13:BuffUp(v50.NightfallBuff))) or ((568 + 332) == (2719 + 658))) then
								if (((10515 - 6056) > (1032 - 441)) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
									return "shadow_bolt main 32";
								end
							end
							if (((4531 - (1076 + 57)) >= (394 + 2001)) and v50.Agony:IsCastable() and (v17:DebuffRefreshable(v50.AgonyDebuff))) then
								if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or ((2872 - (579 + 110)) >= (223 + 2601))) then
									return "agony main 34";
								end
							end
							v148 = 8 + 0;
						end
						if (((1028 + 908) == (2343 - (174 + 233))) and (v148 == (5 - 3))) then
							if (v33 or ((8480 - 3648) < (1918 + 2395))) then
								local v160 = 1174 - (663 + 511);
								local v161;
								while true do
									if (((3647 + 441) > (842 + 3032)) and (v160 == (0 - 0))) then
										v161 = v89();
										if (((2624 + 1708) == (10198 - 5866)) and v161) then
											return v161;
										end
										break;
									end
								end
							end
							if (((9680 - 5681) >= (1384 + 1516)) and v50.MaleficRapture:IsReady() and v50.DreadTouch:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < (3 - 1)) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50.SiphonLife:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50.PhantomSingularity:IsAvailable() or v50.PhantomSingularity:CooldownDown()) and (not v50.VileTaint:IsAvailable() or v50.VileTaint:CooldownDown()) and (not v50.SoulRot:IsAvailable() or v50.SoulRot:CooldownDown())) then
								if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(72 + 28)) or ((231 + 2294) > (4786 - (478 + 244)))) then
									return "malefic_rapture main 2";
								end
							end
							if (((4888 - (440 + 77)) == (1988 + 2383)) and v50.SummonDarkglare:IsReady() and v60 and v61 and v63) then
								if (v25(v50.SummonDarkglare, v47) or ((973 - 707) > (6542 - (655 + 901)))) then
									return "summon_darkglare main 4";
								end
							end
							v148 = 1 + 2;
						end
					end
				end
				break;
			end
			if (((1525 + 466) >= (625 + 300)) and ((3 - 2) == v130)) then
				v57 = v13:GetEnemiesInRange(1485 - (695 + 750));
				v58 = v17:GetEnemiesInSplashRange(34 - 24);
				if (((701 - 246) < (8256 - 6203)) and v30) then
					v59 = v17:GetEnemiesInSplashRangeCount(361 - (285 + 66));
				else
					v59 = 2 - 1;
				end
				if (v49.TargetIsValid() or v13:AffectingCombat() or ((2136 - (682 + 628)) == (782 + 4069))) then
					local v149 = 299 - (176 + 123);
					while true do
						if (((77 + 106) == (133 + 50)) and (v149 == (269 - (239 + 30)))) then
							v69 = v10.BossFightRemains(nil, true);
							v70 = v69;
							v149 = 1 + 0;
						end
						if (((1114 + 45) <= (3164 - 1376)) and (v149 == (2 - 1))) then
							if ((v70 == (11426 - (306 + 9))) or ((12237 - 8730) > (751 + 3567))) then
								v70 = v10.FightRemains(v58, false);
							end
							break;
						end
					end
				end
				v130 = 2 + 0;
			end
			if ((v130 == (0 + 0)) or ((8793 - 5718) <= (4340 - (1140 + 235)))) then
				v48();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v130 = 1 + 0;
			end
		end
	end
	local function v94()
		local v131 = 0 + 0;
		while true do
			if (((351 + 1014) <= (2063 - (33 + 19))) and (v131 == (0 + 0))) then
				v20.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v50.AgonyDebuff:RegisterAuraTracking();
				v131 = 2 - 1;
			end
			if ((v131 == (1 + 0)) or ((5443 - 2667) > (3353 + 222))) then
				v50.SiphonLifeDebuff:RegisterAuraTracking();
				v50.CorruptionDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v20.SetAPL(954 - (586 + 103), v93, v94);
end;
return v0["Epix_Warlock_Affliction.lua"]();

