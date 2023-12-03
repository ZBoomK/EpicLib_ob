local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4143 - (1477 + 184)) < (1987 - 528))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DeathKnight_Blood.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Pet;
	local v19 = v9.Press;
	local v20 = v9.Macro;
	local v21 = v9.Commons.Everyone.num;
	local v22 = v9.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29;
	local v30;
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
	local function v62()
		local v91 = 0 + 0;
		while true do
			if ((v91 == (859 - (564 + 292))) or ((4651 - 1955) >= (13660 - 9128))) then
				v48 = EpicSettings.Settings['MindFreezeOffGCD'];
				v49 = EpicSettings.Settings['RacialsOffGCD'];
				v50 = EpicSettings.Settings['BonestormGCD'];
				v51 = EpicSettings.Settings['ChainsOfIceGCD'];
				v52 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v53 = EpicSettings.Settings['DeathStrikeGCD'];
				v91 = 308 - (244 + 60);
			end
			if (((806 + 242) >= (528 - (41 + 435))) and (v91 == (1003 - (938 + 63)))) then
				v42 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v43 = EpicSettings.Settings['AntiMagicShellGCD'];
				v44 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v45 = EpicSettings.Settings['DeathAndDecayGCD'];
				v46 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v47 = EpicSettings.Settings['SacrificialPactGCD'];
				v91 = 3 + 0;
			end
			if (((4083 - (936 + 189)) < (1482 + 3021)) and (v91 == (1618 - (1565 + 48)))) then
				v60 = EpicSettings.Settings['VampiricBloodThreshold'];
				v61 = EpicSettings.Settings['DeathStrikeDumpAmount'];
				break;
			end
			if ((v91 == (0 + 0)) or ((3873 - (782 + 356)) == (1576 - (176 + 91)))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v33 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (1092 - (975 + 117));
				v91 = 1876 - (157 + 1718);
			end
			if ((v91 == (4 + 0)) or ((14661 - 10531) <= (10102 - 7147))) then
				v54 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v55 = EpicSettings.Settings['TombstoneGCD'];
				v56 = EpicSettings.Settings['VampiricBloodGCD'];
				v57 = EpicSettings.Settings['BloodTapOffGCD'];
				v58 = EpicSettings.Settings['RuneTapOffGCD'];
				v59 = EpicSettings.Settings['RuneTapThreshold'];
				v91 = 1023 - (697 + 321);
			end
			if ((v91 == (2 - 1)) or ((4160 - 2196) <= (3089 - 1749))) then
				v36 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v30 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseDeathStrikeHP'];
				v41 = EpicSettings.Settings['UseDarkSuccorHP'];
				v91 = 1229 - (322 + 905);
			end
		end
	end
	local v63;
	local v64 = v15.DeathKnight.Blood;
	local v65 = v17.DeathKnight.Blood;
	local v66 = v20.DeathKnight.Blood;
	local v67 = {v65.Fyralath:ID()};
	local v68 = 1254 - (449 + 740);
	local v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (876 - (826 + 46))) or (952 - (245 + 702));
	local v70 = 0 - 0;
	local v71 = 0 + 0;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77 = v9.GhoulTable;
	local v78 = v9.Commons.Everyone;
	local v79 = {{v64.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (8 - 4)) or (14 - 9);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v80(v92)
		local v93 = 1205 - (902 + 303);
		for v99, v100 in pairs(v92) do
			if (((5486 - 2987) == (6018 - 3519)) and not v100:DebuffUp(v64.BloodPlagueDebuff)) then
				v93 = v93 + 1 + 0;
			end
		end
		return v93;
	end
	local function v81(v94)
		return (v94:DebuffRemains(v64.SoulReaperDebuff));
	end
	local function v82(v95)
		return ((v95:TimeToX(1725 - (1121 + 569)) < (219 - (22 + 192))) or (v95:HealthPercentage() <= (718 - (483 + 200)))) and (v95:TimeToDie() > (v95:DebuffRemains(v64.SoulReaperDebuff) + (1468 - (1404 + 59))));
	end
	local function v83()
		local v96 = 0 - 0;
		while true do
			if ((v96 == (0 - 0)) or ((3020 - (468 + 297)) < (584 - (334 + 228)))) then
				if (v64.DeathsCaress:IsReady() or ((3662 - 2576) >= (3256 - 1851))) then
					if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((4296 - 1927) == (121 + 305))) then
						return "deaths_caress precombat 4";
					end
				end
				if (v64.Marrowrend:IsReady() or ((3312 - (141 + 95)) > (3127 + 56))) then
					if (((3093 - 1891) > (2542 - 1484)) and v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(2 + 3))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v84()
		local v97 = 0 - 0;
		while true do
			if (((2609 + 1102) > (1748 + 1607)) and ((1 - 0) == v97)) then
				if ((v64.VampiricBlood:IsCastable() and v72 and (v13:HealthPercentage() <= v60) and v13:BuffDown(v64.IceboundFortitudeBuff)) or ((535 + 371) >= (2392 - (92 + 71)))) then
					if (((637 + 651) > (2102 - 851)) and v19(v64.VampiricBlood, v56)) then
						return "vampiric_blood defensives 14";
					end
				end
				if ((v64.IceboundFortitude:IsCastable() and v72 and (v13:HealthPercentage() <= IceboundFortitudeThreshold) and v13:BuffDown(v64.VampiricBloodBuff)) or ((5278 - (574 + 191)) < (2765 + 587))) then
					if (v19(v64.IceboundFortitude, v54) or ((5173 - 3108) >= (1633 + 1563))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v97 = 851 - (254 + 595);
			end
			if ((v97 == (128 - (55 + 71))) or ((5764 - 1388) <= (3271 - (573 + 1217)))) then
				if ((v64.DeathStrike:IsReady() and (v13:HealthPercentage() <= ((138 - 88) + (((v13:RunicPower() > v68) and (2 + 18)) or (0 - 0)))) and not v13:HealingAbsorbed()) or ((4331 - (714 + 225)) >= (13854 - 9113))) then
					if (((4635 - 1310) >= (234 + 1920)) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if ((v97 == (0 - 0)) or ((2101 - (118 + 688)) >= (3281 - (25 + 23)))) then
				if (((848 + 3529) > (3528 - (927 + 959))) and v64.RuneTap:IsReady() and v72 and (v13:HealthPercentage() <= v59) and (v13:Rune() >= (10 - 7)) and (v64.RuneTap:Charges() >= (733 - (16 + 716))) and v13:BuffDown(v64.RuneTapBuff)) then
					if (((9117 - 4394) > (1453 - (11 + 86))) and v19(v64.RuneTap, v58)) then
						return "rune_tap defensives 2";
					end
				end
				if ((v13:ActiveMitigationNeeded() and (v64.Marrowrend:TimeSinceLastCast() > (4.5 - 2)) and (v64.DeathStrike:TimeSinceLastCast() > (287.5 - (175 + 110)))) or ((10442 - 6306) <= (16932 - 13499))) then
					local v130 = 1796 - (503 + 1293);
					while true do
						if (((11855 - 7610) <= (3349 + 1282)) and (v130 == (1061 - (810 + 251)))) then
							if (((2968 + 1308) >= (1202 + 2712)) and v64.DeathStrike:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (7 + 0))) then
								if (((731 - (43 + 490)) <= (5098 - (711 + 22))) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (((18497 - 13715) > (5535 - (240 + 619))) and v64.Marrowrend:IsReady()) then
								if (((1174 + 3690) > (3494 - 1297)) and v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
									return "marrowrend defensives 6";
								end
							end
							v130 = 1745 - (1344 + 400);
						end
						if ((v130 == (406 - (255 + 150))) or ((2915 + 785) == (1343 + 1164))) then
							if (((19115 - 14641) >= (884 - 610)) and v64.DeathStrike:IsReady()) then
								if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((3633 - (404 + 1335)) <= (1812 - (183 + 223)))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
					end
				end
				v97 = 1 - 0;
			end
		end
	end
	local function v85()
	end
	local function v86()
		if (((1042 + 530) >= (551 + 980)) and v64.BloodFury:IsCastable() and v64.DancingRuneWeapon:CooldownUp() and (not v64.Blooddrinker:IsReady() or not v64.Blooddrinker:IsAvailable())) then
			if (v19(v64.BloodFury, v49) or ((5024 - (10 + 327)) < (3163 + 1379))) then
				return "blood_fury racials 2";
			end
		end
		if (((3629 - (118 + 220)) > (556 + 1111)) and v64.Berserking:IsCastable()) then
			if (v19(v64.Berserking, v49) or ((1322 - (108 + 341)) == (914 + 1120))) then
				return "berserking racials 4";
			end
		end
		if ((v64.ArcanePulse:IsCastable() and ((v74 >= (8 - 6)) or ((v13:Rune() < (1494 - (711 + 782))) and (v13:RunicPowerDeficit() > (115 - 55))))) or ((3285 - (270 + 199)) < (4 + 7))) then
			if (((5518 - (580 + 1239)) < (13989 - 9283)) and v19(v64.ArcanePulse, v49, nil, not v14:IsInRange(8 + 0))) then
				return "arcane_pulse racials 6";
			end
		end
		if (((96 + 2550) >= (382 + 494)) and v64.LightsJudgment:IsCastable() and (v13:BuffUp(v64.UnholyStrengthBuff))) then
			if (((1602 - 988) <= (1979 + 1205)) and v19(v64.LightsJudgment, v49, nil, not v14:IsSpellInRange(v64.LightsJudgment))) then
				return "lights_judgment racials 8";
			end
		end
		if (((4293 - (645 + 522)) == (4916 - (1010 + 780))) and v64.AncestralCall:IsCastable()) then
			if (v19(v64.AncestralCall, v49) or ((2186 + 1) >= (23600 - 18646))) then
				return "ancestral_call racials 10";
			end
		end
		if (v64.Fireblood:IsCastable() or ((11361 - 7484) == (5411 - (1045 + 791)))) then
			if (((1789 - 1082) > (964 - 332)) and v19(v64.Fireblood, v49)) then
				return "fireblood racials 12";
			end
		end
		if (v64.BagofTricks:IsCastable() or ((1051 - (351 + 154)) >= (4258 - (1281 + 293)))) then
			if (((1731 - (28 + 238)) <= (9610 - 5309)) and v19(v64.BagofTricks, v49, nil, not v14:IsSpellInRange(v64.BagofTricks))) then
				return "bag_of_tricks racials 14";
			end
		end
		if (((3263 - (1381 + 178)) > (1337 + 88)) and v64.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (17 + 3))) then
			if (v19(v64.ArcaneTorrent, v49, nil, not v14:IsInRange(4 + 4)) or ((2368 - 1681) == (2194 + 2040))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v87()
		if ((v64.BloodBoil:IsReady() and (v14:DebuffDown(v64.BloodPlagueDebuff))) or ((3800 - (381 + 89)) < (1268 + 161))) then
			if (((776 + 371) >= (573 - 238)) and v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(1166 - (1074 + 82)))) then
				return "blood_boil drw_up 2";
			end
		end
		if (((7527 - 4092) > (3881 - (214 + 1570))) and v64.Tombstone:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (1460 - (990 + 465))) and (v13:Rune() >= (1 + 1)) and (v13:RunicPowerDeficit() >= (14 + 16)) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff)))) then
			if (v19(v64.Tombstone) or ((3667 + 103) >= (15903 - 11862))) then
				return "tombstone drw_up 4";
			end
		end
		if ((v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()))) or ((5517 - (1668 + 58)) <= (2237 - (512 + 114)))) then
			if (v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(13 - 8)) or ((9464 - 4886) <= (6987 - 4979))) then
				return "death_strike drw_up 6";
			end
		end
		if (((524 + 601) <= (389 + 1687)) and v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (4 + 0)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (67 - 47))) then
			if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(1999 - (109 + 1885))) or ((2212 - (1269 + 200)) >= (8431 - 4032))) then
				return "marrowrend drw_up 10";
			end
		end
		if (((1970 - (98 + 717)) < (2499 - (802 + 24))) and v64.SoulReaper:IsReady() and (v74 == (1 - 0)) and ((v14:TimeToX(44 - 9) < (1 + 4)) or (v14:HealthPercentage() <= (27 + 8))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + 1 + 4))) then
			if (v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(2 + 3)) or ((6465 - 4141) <= (1927 - 1349))) then
				return "soul_reaper drw_up 12";
			end
		end
		if (((1348 + 2419) == (1534 + 2233)) and v64.SoulReaper:IsReady() and (v74 >= (2 + 0))) then
			if (((2974 + 1115) == (1910 + 2179)) and v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(1438 - (797 + 636)))) then
				return "soul_reaper drw_up 14";
			end
		end
		if (((21645 - 17187) >= (3293 - (1427 + 192))) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.SanguineGround:IsAvailable() or v64.UnholyGround:IsAvailable())) then
			if (((337 + 635) <= (3291 - 1873)) and v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(27 + 3))) then
				return "death_and_decay drw_up 16";
			end
		end
		if ((v64.BloodBoil:IsCastable() and (v74 > (1 + 1)) and (v64.BloodBoil:ChargesFractional() >= (327.1 - (192 + 134)))) or ((6214 - (316 + 960)) < (2651 + 2111))) then
			if (v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(8 + 2)) or ((2315 + 189) > (16301 - 12037))) then
				return "blood_boil drw_up 18";
			end
		end
		v71 = (576 - (83 + 468)) + (v75 * v21(v64.Heartbreaker:IsAvailable()) * (1808 - (1202 + 604)));
		if (((10050 - 7897) == (3582 - 1429)) and v64.DeathStrike:IsReady() and ((v13:RunicPowerDeficit() <= v71) or (v13:RunicPower() >= v68))) then
			if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((1403 - 896) >= (2916 - (45 + 280)))) then
				return "death_strike drw_up 20";
			end
		end
		if (((4326 + 155) == (3915 + 566)) and v64.Consumption:IsCastable()) then
			if (v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption)) or ((851 + 1477) < (384 + 309))) then
				return "consumption drw_up 22";
			end
		end
		if (((762 + 3566) == (8013 - 3685)) and v64.BloodBoil:IsReady() and (v64.BloodBoil:ChargesFractional() >= (1912.1 - (340 + 1571))) and (v13:BuffStack(v64.HemostasisBuff) < (2 + 3))) then
			if (((3360 - (1733 + 39)) >= (3660 - 2328)) and v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(1044 - (125 + 909)))) then
				return "blood_boil drw_up 24";
			end
		end
		if ((v64.HeartStrike:IsReady() and ((v13:RuneTimeToX(1950 - (1096 + 852)) < v13:GCD()) or (v13:RunicPowerDeficit() >= v71))) or ((1873 + 2301) > (6066 - 1818))) then
			if (v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike)) or ((4449 + 137) <= (594 - (409 + 103)))) then
				return "heart_strike drw_up 26";
			end
		end
	end
	local function v88()
		if (((4099 - (46 + 190)) == (3958 - (51 + 44))) and v28 and v64.Tombstone:IsCastable() and (v13:BuffStack(v64.BoneShieldBuff) > (2 + 3)) and (v13:Rune() >= (1319 - (1114 + 203))) and (v13:RunicPowerDeficit() >= (756 - (228 + 498))) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff))) and (v64.DancingRuneWeapon:CooldownRemains() >= (6 + 19))) then
			if (v19(v64.Tombstone) or ((156 + 126) <= (705 - (174 + 489)))) then
				return "tombstone standard 2";
			end
		end
		v70 = (26 - 16) + (v74 * v21(v64.Heartbreaker:IsAvailable()) * (1907 - (830 + 1075)));
		if (((5133 - (303 + 221)) >= (2035 - (231 + 1038))) and v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (9 + 1)))) then
			if (v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(1167 - (171 + 991))) or ((4747 - 3595) == (6680 - 4192))) then
				return "death_strike standard 4";
			end
		end
		if (((8539 - 5117) > (2682 + 668)) and v64.DeathsCaress:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (13 - 9)) or (v13:BuffStack(v64.BoneShieldBuff) < (v69 + (2 - 1)))) and (v13:RunicPowerDeficit() > (16 - 6)) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff))) and not v64.Consumption:IsAvailable() and not v64.Blooddrinker:IsAvailable() and (v13:RuneTimeToX(9 - 6) > v13:GCD())) then
			if (((2125 - (111 + 1137)) > (534 - (91 + 67))) and v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress))) then
				return "deaths_caress standard 6";
			end
		end
		if ((v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (11 - 7)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (5 + 15)) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff)))) or ((3641 - (423 + 100)) <= (13 + 1838))) then
			if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(13 - 8)) or ((87 + 78) >= (4263 - (326 + 445)))) then
				return "marrowrend standard 8";
			end
		end
		if (((17233 - 13284) < (10817 - 5961)) and v64.Consumption:IsCastable()) then
			if (v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption)) or ((9980 - 5704) < (3727 - (530 + 181)))) then
				return "consumption standard 10";
			end
		end
		if (((5571 - (614 + 267)) > (4157 - (19 + 13))) and v64.SoulReaper:IsReady() and (v74 == (1 - 0)) and ((v14:TimeToX(81 - 46) < (14 - 9)) or (v14:HealthPercentage() <= (10 + 25))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + (8 - 3)))) then
			if (v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(10 - 5)) or ((1862 - (1293 + 519)) >= (1827 - 931))) then
				return "soul_reaper standard 12";
			end
		end
		if ((v64.SoulReaper:IsReady() and (v74 >= (4 - 2))) or ((3277 - 1563) >= (12755 - 9797))) then
			if (v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(11 - 6)) or ((790 + 701) < (132 + 512))) then
				return "soul_reaper standard 14";
			end
		end
		if (((1635 - 931) < (229 + 758)) and v28 and v64.Bonestorm:IsReady() and (v13:RunicPower() >= (34 + 66))) then
			if (((2324 + 1394) > (3002 - (709 + 387))) and v19(v64.Bonestorm, nil, not v14:IsInMeleeRange(1866 - (673 + 1185)))) then
				return "bonestorm standard 16";
			end
		end
		if ((v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (2.8 - 1)) and ((v13:BuffStack(v64.HemostasisBuff) <= ((16 - 11) - v74)) or (v63 > (2 - 0)))) or ((686 + 272) > (2717 + 918))) then
			if (((4726 - 1225) <= (1104 + 3388)) and v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(19 - 9))) then
				return "blood_boil standard 18";
			end
		end
		if ((v64.HeartStrike:IsReady() and (v13:RuneTimeToX(7 - 3) < v13:GCD())) or ((5322 - (446 + 1434)) < (3831 - (1040 + 243)))) then
			if (((8580 - 5705) >= (3311 - (559 + 1288))) and v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike))) then
				return "heart_strike standard 20";
			end
		end
		if ((v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (1932.1 - (609 + 1322)))) or ((5251 - (13 + 441)) >= (18284 - 13391))) then
			if (v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(26 - 16)) or ((2744 - 2193) > (78 + 1990))) then
				return "blood_boil standard 22";
			end
		end
		if (((7677 - 5563) > (336 + 608)) and v64.HeartStrike:IsReady() and (v13:Rune() > (1 + 0)) and ((v13:RuneTimeToX(8 - 5) < v13:GCD()) or (v13:BuffStack(v64.BoneShieldBuff) > (4 + 3)))) then
			if (v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike)) or ((4159 - 1897) >= (2047 + 1049))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v89()
		local v98 = 0 + 0;
		while true do
			if ((v98 == (2 + 0)) or ((1894 + 361) >= (3461 + 76))) then
				v73 = v13:GetEnemiesInMeleeRange(438 - (153 + 280));
				if (v27 or ((11079 - 7242) < (1173 + 133))) then
					v74 = ((#v73 > (0 + 0)) and #v73) or (1 + 0);
				else
					v74 = 1 + 0;
					v63 = 1 + 0;
				end
				v98 = 4 - 1;
			end
			if (((1824 + 1126) == (3617 - (89 + 578))) and ((3 + 1) == v98)) then
				v72 = v13:IsTankingAoE(16 - 8) or v13:IsTanking(v14);
				if (v78.TargetIsValid() or ((5772 - (572 + 477)) < (445 + 2853))) then
					local v131 = 0 + 0;
					local v132;
					while true do
						if (((136 + 1000) >= (240 - (84 + 2))) and (v131 == (4 - 1))) then
							if ((v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (8 + 2)))) or ((1113 - (497 + 345)) > (122 + 4626))) then
								if (((802 + 3938) >= (4485 - (605 + 728))) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
									return "death_strike main 10";
								end
							end
							if ((v64.Blooddrinker:IsReady() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) or ((1840 + 738) >= (7536 - 4146))) then
								if (((2 + 39) <= (6141 - 4480)) and v19(v64.Blooddrinker, nil, nil, not v14:IsSpellInRange(v64.Blooddrinker))) then
									return "blooddrinker main 12";
								end
							end
							if (((542 + 59) < (9863 - 6303)) and v28) then
								local v133 = 0 + 0;
								local v134;
								while true do
									if (((724 - (457 + 32)) < (292 + 395)) and ((1402 - (832 + 570)) == v133)) then
										v134 = v86();
										if (((4286 + 263) > (301 + 852)) and v134) then
											return v134;
										end
										break;
									end
								end
							end
							v131 = 13 - 9;
						end
						if ((v131 == (2 + 2)) or ((5470 - (588 + 208)) < (12591 - 7919))) then
							if (((5468 - (884 + 916)) < (9548 - 4987)) and v28 and v64.SacrificialPact:IsReady() and v77.GhoulActive() and v13:BuffDown(v64.DancingRuneWeaponBuff) and ((v77.GhoulRemains() < (2 + 0)) or (v14:TimeToDie() < v13:GCD()))) then
								if (v19(v64.SacrificialPact, v47) or ((1108 - (232 + 421)) == (5494 - (1569 + 320)))) then
									return "sacrificial_pact main 14";
								end
							end
							if ((v28 and v64.BloodTap:IsCastable() and (((v13:Rune() <= (1 + 1)) and (v13:RuneTimeToX(1 + 3) > v13:GCD()) and (v64.BloodTap:ChargesFractional() >= (3.8 - 2))) or (v13:RuneTimeToX(608 - (316 + 289)) > v13:GCD()))) or ((6970 - 4307) == (153 + 3159))) then
								if (((5730 - (666 + 787)) <= (4900 - (360 + 65))) and v19(v64.BloodTap, v57)) then
									return "blood_tap main 16";
								end
							end
							if ((v28 and v64.GorefiendsGrasp:IsCastable() and (v64.TighteningGrasp:IsAvailable())) or ((814 + 56) == (1443 - (79 + 175)))) then
								if (((2448 - 895) <= (2445 + 688)) and v19(v64.GorefiendsGrasp, nil, not v14:IsSpellInRange(v64.GorefiendsGrasp))) then
									return "gorefiends_grasp main 18";
								end
							end
							v131 = 15 - 10;
						end
						if ((v131 == (9 - 4)) or ((3136 - (503 + 396)) >= (3692 - (92 + 89)))) then
							if ((v28 and v64.EmpowerRuneWeapon:IsCastable() and (v13:Rune() < (10 - 4)) and (v13:RunicPowerDeficit() > (3 + 2))) or ((784 + 540) > (11826 - 8806))) then
								if (v19(v64.EmpowerRuneWeapon, v46) or ((410 + 2582) == (4288 - 2407))) then
									return "empower_rune_weapon main 20";
								end
							end
							if (((2710 + 396) > (729 + 797)) and v28 and v64.AbominationLimb:IsCastable()) then
								if (((9206 - 6183) < (484 + 3386)) and v19(v64.AbominationLimb, nil, not v14:IsInRange(30 - 10))) then
									return "abomination_limb main 22";
								end
							end
							if (((1387 - (485 + 759)) > (170 - 96)) and v28 and v64.DancingRuneWeapon:IsCastable() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) then
								if (((1207 - (442 + 747)) < (3247 - (832 + 303))) and v19(v64.DancingRuneWeapon, v52)) then
									return "dancing_rune_weapon main 24";
								end
							end
							v131 = 952 - (88 + 858);
						end
						if (((335 + 762) <= (1348 + 280)) and (v131 == (1 + 1))) then
							if (((5419 - (766 + 23)) == (22857 - 18227)) and v64.VampiricBlood:IsCastable() and v13:BuffDown(v64.VampiricBloodBuff) and v13:BuffDown(v64.VampiricStrengthBuff)) then
								if (((4841 - 1301) > (7068 - 4385)) and v19(v64.VampiricBlood, v56)) then
									return "vampiric_blood main 5";
								end
							end
							if (((16270 - 11476) >= (4348 - (1036 + 37))) and v64.DeathsCaress:IsReady() and (v13:BuffDown(v64.BoneShieldBuff))) then
								if (((1053 + 431) == (2889 - 1405)) and v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress))) then
									return "deaths_caress main 6";
								end
							end
							if (((1127 + 305) < (5035 - (641 + 839))) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.UnholyGround:IsAvailable() or v64.SanguineGround:IsAvailable() or (v74 > (916 - (910 + 3))) or v13:BuffUp(v64.CrimsonScourgeBuff))) then
								if (v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(76 - 46)) or ((2749 - (1466 + 218)) > (1645 + 1933))) then
									return "death_and_decay main 8";
								end
							end
							v131 = 1151 - (556 + 592);
						end
						if ((v131 == (3 + 4)) or ((5603 - (329 + 479)) < (2261 - (174 + 680)))) then
							if (((6366 - 4513) < (9975 - 5162)) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v131 == (5 + 1)) or ((3560 - (396 + 343)) < (216 + 2215))) then
							if ((v13:BuffUp(v64.DancingRuneWeaponBuff)) or ((4351 - (29 + 1448)) < (3570 - (135 + 1254)))) then
								local v135 = 0 - 0;
								local v136;
								while true do
									if ((v135 == (4 - 3)) or ((1793 + 896) <= (1870 - (389 + 1138)))) then
										if (v9.CastAnnotated(v64.Pool, false, "WAIT") or ((2443 - (102 + 472)) == (1896 + 113))) then
											return "Wait/Pool for DRWUp";
										end
										break;
									end
									if (((0 + 0) == v135) or ((3307 + 239) < (3867 - (320 + 1225)))) then
										v136 = v87();
										if (v136 or ((3705 - 1623) == (2921 + 1852))) then
											return v136;
										end
										v135 = 1465 - (157 + 1307);
									end
								end
							end
							v132 = v88();
							if (((5103 - (821 + 1038)) > (2632 - 1577)) and v132) then
								return v132;
							end
							v131 = 1 + 6;
						end
						if ((v131 == (0 - 0)) or ((1233 + 2080) <= (4406 - 2628))) then
							if (not v13:AffectingCombat() or ((2447 - (834 + 192)) >= (134 + 1970))) then
								local v137 = v83();
								if (((466 + 1346) <= (70 + 3179)) and v137) then
									return v137;
								end
							end
							if (((2514 - 891) <= (2261 - (300 + 4))) and v72) then
								local v138 = 0 + 0;
								local v139;
								while true do
									if (((11549 - 7137) == (4774 - (112 + 250))) and (v138 == (0 + 0))) then
										v139 = v84();
										if (((4384 - 2634) >= (483 + 359)) and v139) then
											return v139;
										end
										break;
									end
								end
							end
							if (((2262 + 2110) > (1384 + 466)) and v13:IsChanneling(v64.Blooddrinker) and v13:BuffUp(v64.BoneShieldBuff) and (v76 == (0 + 0)) and not v13:ShouldStopCasting() and (v13:CastRemains() > (0.2 + 0))) then
								if (((1646 - (1001 + 413)) < (1830 - 1009)) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
									return "Pool During Blooddrinker";
								end
							end
							v131 = 883 - (244 + 638);
						end
						if (((1211 - (627 + 66)) < (2687 - 1785)) and (v131 == (603 - (512 + 90)))) then
							v68 = v61;
							if (((4900 - (1665 + 241)) > (1575 - (373 + 344))) and v30) then
								local v140 = v85();
								if (v140 or ((1694 + 2061) <= (243 + 672))) then
									return v140;
								end
							end
							if (((10408 - 6462) > (6333 - 2590)) and v28 and v64.RaiseDead:IsCastable()) then
								if (v19(v64.RaiseDead, nil) or ((2434 - (35 + 1064)) >= (2406 + 900))) then
									return "raise_dead main 4";
								end
							end
							v131 = 4 - 2;
						end
					end
				end
				break;
			end
			if (((20 + 4824) > (3489 - (298 + 938))) and (v98 == (1262 - (233 + 1026)))) then
				v75 = v23(v74, (v13:BuffUp(v64.DeathAndDecayBuff) and (1671 - (636 + 1030))) or (2 + 0));
				v76 = v80(v73);
				v98 = 4 + 0;
			end
			if (((135 + 317) == (31 + 421)) and (v98 == (222 - (55 + 166)))) then
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v98 = 1 + 1;
			end
			if (((0 + 0) == v98) or ((17403 - 12846) < (2384 - (36 + 261)))) then
				v62();
				v26 = EpicSettings.Toggles['ooc'];
				v98 = 1 - 0;
			end
		end
	end
	local function v90()
		v64.MarkofFyralathDebuff:RegisterAuraTracking();
		v9.Print("Blood DK by Epic. Work in progress Gojira");
	end
	v9.SetAPL(1618 - (34 + 1334), v89, v90);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

