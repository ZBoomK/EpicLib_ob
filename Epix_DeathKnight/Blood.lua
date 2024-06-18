local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((3429 + 513) <= (5355 - (173 + 195))) and not v6) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_DeathKnight_Blood.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Pet;
	local v20 = v10.Press;
	local v21 = v10.Macro;
	local v22 = v10.Commons.Everyone.num;
	local v23 = v10.Commons.Everyone.bool;
	local v24 = math.min;
	local v25 = math.abs;
	local v26 = math.max;
	local v27 = false;
	local v28 = false;
	local v29 = false;
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
	local v62;
	local v63;
	local v64;
	local v65;
	local function v66()
		v30 = EpicSettings.Settings['UseRacials'];
		v32 = EpicSettings.Settings['UseHealingPotion'];
		v33 = EpicSettings.Settings['HealingPotionName'] or (1201 - (209 + 992));
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (1504 - (363 + 1141));
		v37 = EpicSettings.Settings['InterruptWithStun'] or (1580 - (1183 + 397));
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v31 = EpicSettings.Settings['UseTrinkets'];
		v41 = EpicSettings.Settings['UseDeathStrikeHP'];
		v42 = EpicSettings.Settings['UseDarkSuccorHP'];
		v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
		v44 = EpicSettings.Settings['AntiMagicShellGCD'];
		v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
		v46 = EpicSettings.Settings['DeathAndDecayGCD'];
		v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
		v48 = EpicSettings.Settings['SacrificialPactGCD'];
		v49 = EpicSettings.Settings['MindFreezeOffGCD'];
		v50 = EpicSettings.Settings['RacialsOffGCD'];
		v51 = EpicSettings.Settings['BonestormGCD'];
		v52 = EpicSettings.Settings['ChainsOfIceGCD'];
		v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
		v54 = not EpicSettings.Settings['DeathStrikeGCD'];
		v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
		v56 = EpicSettings.Settings['TombstoneGCD'];
		v57 = EpicSettings.Settings['VampiricBloodGCD'];
		v58 = EpicSettings.Settings['BloodTapOffGCD'];
		v59 = EpicSettings.Settings['RuneTapOffGCD'];
		v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
		v60 = EpicSettings.Settings['RuneTapThreshold'];
		v61 = EpicSettings.Settings['VampiricBloodThreshold'];
		v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (0 + 0);
		v63 = EpicSettings.Settings['DeathStrikeHealing'] or (1975 - (1913 + 62));
		v65 = EpicSettings.Settings['DnDCast'];
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 172 - 107;
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (1937 - (565 + 1368))) or (18 - 13);
	local v74 = 1661 - (1477 + 184);
	local v75 = 0 - 0;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81 = v10.GhoulTable;
	local v82 = v10.Commons.Everyone;
	local v83 = {{v68.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (308 - (244 + 60))) or (4 + 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v121)
		local v122 = 476 - (41 + 435);
		local v123;
		while true do
			if (((5585 - (938 + 63)) == (3526 + 1058)) and (v122 == (1126 - (936 + 189)))) then
				return v123;
			end
			if (((1310 + 2669) >= (3281 - (1565 + 48))) and (v122 == (0 + 0))) then
				v123 = 1138 - (782 + 356);
				for v135, v136 in pairs(v121) do
					if (((835 - (176 + 91)) > (1114 - 686)) and not v136:DebuffUp(v68.BloodPlagueDebuff)) then
						v123 = v123 + (1 - 0);
					end
				end
				v122 = 1093 - (975 + 117);
			end
		end
	end
	local function v85(v124)
		return (v124:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v125)
		return ((v125:TimeToX(1910 - (157 + 1718)) < (5 + 0)) or (v125:HealthPercentage() <= (124 - 89))) and (v125:TimeToDie() > (v125:DebuffRemains(v68.SoulReaperDebuff) + (17 - 12)));
	end
	local function v87()
		if (((2352 - (697 + 321)) <= (12566 - 7953)) and v68.DeathsCaress:IsReady()) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((3950 - 2085) >= (4677 - 2648))) then
				return "deaths_caress precombat 4";
			end
		end
		if (((1927 + 3023) >= (3027 - 1411)) and v68.Marrowrend:IsReady()) then
			if (((4624 - 2899) == (2952 - (322 + 905))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(616 - (602 + 9)))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v88()
		if (((2648 - (449 + 740)) <= (3354 - (826 + 46))) and (v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) then
			if (v10.Press(v70.Healthstone, nil, nil, true) or ((3643 - (245 + 702)) >= (14320 - 9788))) then
				return "healthstone defensive 3";
			end
		end
		if (((337 + 711) >= (1950 - (260 + 1638))) and v32 and (v14:HealthPercentage() <= v34)) then
			local v132 = 440 - (382 + 58);
			while true do
				if (((9489 - 6531) < (3742 + 761)) and (v132 == (0 - 0))) then
					if ((v33 == "Refreshing Healing Potion") or ((8129 - 5394) == (2514 - (902 + 303)))) then
						if (v69.RefreshingHealingPotion:IsReady() or ((9067 - 4937) <= (7116 - 4161))) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((169 + 1795) <= (3030 - (1121 + 569)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2713 - (22 + 192)) == (3182 - (483 + 200))) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v69.DreamwalkersHealingPotion:IsReady() or ((3718 - (1404 + 59)) < (60 - 38))) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((1459 - 373) >= (2170 - (468 + 297)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if ((v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (565 - (334 + 228))) and (v68.RuneTap:Charges() >= (3 - 2)) and v14:BuffDown(v68.RuneTapBuff)) or ((5490 - 3121) == (772 - 346))) then
			if (v20(v68.RuneTap, v59) or ((874 + 2202) > (3419 - (141 + 95)))) then
				return "rune_tap defensives 2";
			end
		end
		if (((1181 + 21) > (2722 - 1664)) and v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (4.5 - 2)) and (v68.DeathStrike:TimeSinceLastCast() > (1.5 + 1))) then
			if (((10167 - 6456) > (2359 + 996)) and v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (4 + 3))) then
				if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((1275 - 369) >= (1315 + 914))) then
					return "death_strike defensives 4";
				end
			end
			if (((1451 - (92 + 71)) > (618 + 633)) and v68.Marrowrend:IsReady()) then
				if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(8 - 3)) or ((5278 - (574 + 191)) < (2765 + 587))) then
					return "marrowrend defensives 6";
				end
			end
			if (v68.DeathStrike:IsReady() or ((5173 - 3108) >= (1633 + 1563))) then
				if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((5225 - (254 + 595)) <= (1607 - (55 + 71)))) then
					return "death_strike defensives 10";
				end
			end
		end
		if ((v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) or ((4468 - 1076) >= (6531 - (573 + 1217)))) then
			if (((9208 - 5883) >= (164 + 1990)) and v20(v68.VampiricBlood, v57)) then
				return "vampiric_blood defensives 14";
			end
		end
		if ((v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) or ((2086 - 791) >= (4172 - (714 + 225)))) then
			if (((12791 - 8414) > (2288 - 646)) and v20(v68.IceboundFortitude, v55)) then
				return "icebound_fortitude defensives 16";
			end
		end
		if (((512 + 4211) > (1962 - 606)) and v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= v63)) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((4942 - (118 + 688)) <= (3481 - (25 + 23)))) then
				return "death_strike defensives 18";
			end
		end
	end
	local function v89()
		local v126 = 0 + 0;
		local v127;
		while true do
			if (((6131 - (927 + 959)) <= (15610 - 10979)) and (v126 == (733 - (16 + 716)))) then
				v127 = v82.HandleBottomTrinket(v71, v29, 77 - 37, nil);
				if (((4373 - (11 + 86)) >= (9546 - 5632)) and v127) then
					return v127;
				end
				break;
			end
			if (((483 - (175 + 110)) <= (11020 - 6655)) and (v126 == (0 - 0))) then
				v127 = v82.HandleTopTrinket(v71, v29, 1836 - (503 + 1293), nil);
				if (((13355 - 8573) > (3382 + 1294)) and v127) then
					return v127;
				end
				v126 = 1062 - (810 + 251);
			end
		end
	end
	local function v90()
		if (((3376 + 1488) > (675 + 1522)) and v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) then
			if (v20(v68.BloodFury) or ((3336 + 364) == (3040 - (43 + 490)))) then
				return "blood_fury racials 2";
			end
		end
		if (((5207 - (711 + 22)) >= (1059 - 785)) and v68.Berserking:IsCastable()) then
			if (v20(v68.Berserking) or ((2753 - (240 + 619)) <= (340 + 1066))) then
				return "berserking racials 4";
			end
		end
		if (((2499 - 927) >= (102 + 1429)) and v68.ArcanePulse:IsCastable() and ((v78 >= (1746 - (1344 + 400))) or ((v14:Rune() < (406 - (255 + 150))) and (v14:RunicPowerDeficit() > (48 + 12))))) then
			if (v20(v68.ArcanePulse, nil, not v15:IsInRange(5 + 3)) or ((20025 - 15338) < (14670 - 10128))) then
				return "arcane_pulse racials 6";
			end
		end
		if (((5030 - (404 + 1335)) > (2073 - (183 + 223))) and v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) then
			if (v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment)) or ((1061 - 188) == (1348 + 686))) then
				return "lights_judgment racials 8";
			end
		end
		if (v68.AncestralCall:IsCastable() or ((1014 + 1802) < (348 - (10 + 327)))) then
			if (((2576 + 1123) < (5044 - (118 + 220))) and v20(v68.AncestralCall)) then
				return "ancestral_call racials 10";
			end
		end
		if (((882 + 1764) >= (1325 - (108 + 341))) and v68.Fireblood:IsCastable()) then
			if (((276 + 338) <= (13461 - 10277)) and v20(v68.Fireblood)) then
				return "fireblood racials 12";
			end
		end
		if (((4619 - (711 + 782)) == (5992 - 2866)) and v68.BagofTricks:IsCastable()) then
			if (v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks)) or ((2656 - (270 + 199)) >= (1607 + 3347))) then
				return "bag_of_tricks racials 14";
			end
		end
		if ((v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (1839 - (580 + 1239)))) or ((11525 - 7648) == (3419 + 156))) then
			if (((26 + 681) > (276 + 356)) and v20(v68.ArcaneTorrent, nil, not v15:IsInRange(20 - 12))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v91()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (1168 - (645 + 522))) or ((2336 - (1010 + 780)) >= (2683 + 1))) then
				if (((6979 - 5514) <= (12603 - 8302)) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (1840 - (1045 + 791))) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (50 - 30))) then
					if (((2601 - 897) > (1930 - (351 + 154))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1579 - (1281 + 293)))) then
						return "marrowrend drw_up 10";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 == (267 - (28 + 238))) and ((v15:TimeToX(77 - 42) < (1564 - (1381 + 178))) or (v15:HealthPercentage() <= (33 + 2))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + 5 + 0))) or ((294 + 393) == (14596 - 10362))) then
					if (v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(3 + 2)) or ((3800 - (381 + 89)) < (1268 + 161))) then
						return "soul_reaper drw_up 12";
					end
				end
				if (((776 + 371) >= (573 - 238)) and v68.SoulReaper:IsReady() and (v78 >= (1158 - (1074 + 82)))) then
					if (((7527 - 4092) > (3881 - (214 + 1570))) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(1460 - (990 + 465)))) then
						return "soul_reaper drw_up 14";
					end
				end
				v128 = 1 + 1;
			end
			if ((v128 == (1 + 1)) or ((3667 + 103) >= (15903 - 11862))) then
				if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) or ((5517 - (1668 + 58)) <= (2237 - (512 + 114)))) then
					if ((v65 == "At Player") or ((11935 - 7357) <= (4151 - 2143))) then
						if (((3914 - 2789) <= (966 + 1110)) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(6 + 24))) then
							return "death_and_decay drw_up 16";
						end
					elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(27 + 3)) or ((2506 - 1763) >= (6393 - (109 + 1885)))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((2624 - (1269 + 200)) < (3206 - 1533)) and v68.BloodBoil:IsCastable() and (v78 > (817 - (98 + 717))) and (v68.BloodBoil:ChargesFractional() >= (827.1 - (802 + 24)))) then
					if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(17 - 7)) or ((2934 - 610) <= (86 + 492))) then
						return "blood_boil drw_up 18";
					end
				end
				v75 = 20 + 5 + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (1 + 1));
				v128 = 1 + 2;
			end
			if (((10479 - 6712) == (12562 - 8795)) and (v128 == (0 + 0))) then
				if (((1665 + 2424) == (3373 + 716)) and v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) then
					if (((3242 + 1216) >= (782 + 892)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(1443 - (797 + 636)))) then
						return "blood_boil drw_up 2";
					end
				end
				if (((4719 - 3747) <= (3037 - (1427 + 192))) and v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (2 + 3)) and (v14:Rune() >= (4 - 2)) and (v14:RunicPowerDeficit() >= (27 + 3)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) then
					if (v20(v68.Tombstone) or ((2238 + 2700) < (5088 - (192 + 134)))) then
						return "tombstone drw_up 4";
					end
				end
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) or ((3780 - (316 + 960)) > (2373 + 1891))) then
					if (((1662 + 491) == (1991 + 162)) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(18 - 13))) then
						return "death_strike drw_up 6";
					end
				end
				v128 = 552 - (83 + 468);
			end
			if ((v128 == (1810 - (1202 + 604))) or ((2366 - 1859) >= (4312 - 1721))) then
				if (((12406 - 7925) == (4806 - (45 + 280))) and v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(2 + 0) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((2034 + 294) < (254 + 439))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if (((2395 + 1933) == (762 + 3566)) and (v128 == (5 - 2))) then
				if (((3499 - (340 + 1571)) >= (526 + 806)) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((5946 - (1733 + 39)) > (11673 - 7425))) then
						return "death_strike drw_up 20";
					end
				end
				if (v68.Consumption:IsCastable() or ((5620 - (125 + 909)) <= (2030 - (1096 + 852)))) then
					if (((1733 + 2130) == (5515 - 1652)) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0)) and (v14:BuffStack(v68.HemostasisBuff) < (517 - (409 + 103)))) or ((518 - (46 + 190)) <= (137 - (51 + 44)))) then
					if (((1300 + 3309) >= (2083 - (1114 + 203))) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(736 - (228 + 498)))) then
						return "blood_boil drw_up 24";
					end
				end
				v128 = 1 + 3;
			end
		end
	end
	local function v92()
		if ((v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (3 + 2)) and (v14:Rune() >= (665 - (174 + 489))) and (v14:RunicPowerDeficit() >= (78 - 48)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (1930 - (830 + 1075)))) or ((1676 - (303 + 221)) == (3757 - (231 + 1038)))) then
			if (((2852 + 570) > (4512 - (171 + 991))) and v20(v68.Tombstone)) then
				return "tombstone standard 2";
			end
		end
		v74 = (41 - 31) + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (5 - 3));
		if (((2188 - 1311) > (301 + 75)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (35 - 25)))) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(14 - 9)) or ((5025 - 1907) <= (5721 - 3870))) then
				return "death_strike standard 4";
			end
		end
		if ((v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (1252 - (111 + 1137))) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + (159 - (91 + 67))))) and (v14:RunicPowerDeficit() > (29 - 19)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(1 + 2) > v14:GCD())) or ((688 - (423 + 100)) >= (25 + 3467))) then
			if (((10933 - 6984) < (2532 + 2324)) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
				return "deaths_caress standard 6";
			end
		end
		if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (775 - (326 + 445))) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (87 - 67)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) or ((9525 - 5249) < (7039 - 4023))) then
			if (((5401 - (530 + 181)) > (5006 - (614 + 267))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(37 - (19 + 13)))) then
				return "marrowrend standard 8";
			end
		end
		if (v68.Consumption:IsCastable() or ((81 - 31) >= (2087 - 1191))) then
			if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((4896 - 3182) >= (769 + 2189))) then
				return "consumption standard 10";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 == (1 - 0)) and ((v15:TimeToX(72 - 37) < (1817 - (1293 + 519))) or (v15:HealthPercentage() <= (71 - 36))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (13 - 8)))) or ((2851 - 1360) < (2776 - 2132))) then
			if (((1658 - 954) < (523 + 464)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
				return "soul_reaper standard 12";
			end
		end
		if (((8638 - 4920) > (441 + 1465)) and v68.SoulReaper:IsReady() and (v78 >= (1 + 1))) then
			if (v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(4 + 1)) or ((2054 - (709 + 387)) > (5493 - (673 + 1185)))) then
				return "soul_reaper standard 14";
			end
		end
		if (((10153 - 6652) <= (14424 - 9932)) and v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (164 - 64))) then
			if (v20(v68.Bonestorm) or ((2462 + 980) < (1904 + 644))) then
				return "bonestorm standard 16";
			end
		end
		if (((3881 - 1006) >= (360 + 1104)) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.8 - 0)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((9 - 4) - v78)) or (v78 > (1882 - (446 + 1434))))) then
			if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1293 - (1040 + 243))) or ((14317 - 9520) >= (6740 - (559 + 1288)))) then
				return "blood_boil standard 18";
			end
		end
		if ((v68.HeartStrike:IsReady() and (v14:RuneTimeToX(1935 - (609 + 1322)) < v14:GCD())) or ((1005 - (13 + 441)) > (7727 - 5659))) then
			if (((5537 - 3423) > (4701 - 3757)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 20";
			end
		end
		if ((v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0))) or ((8215 - 5953) >= (1100 + 1996))) then
			if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(5 + 5)) or ((6691 - 4436) >= (1936 + 1601))) then
				return "blood_boil standard 22";
			end
		end
		if ((v68.HeartStrike:IsReady() and (v14:Rune() > (1 - 0)) and ((v14:RuneTimeToX(2 + 1) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (4 + 3)))) or ((2757 + 1080) < (1097 + 209))) then
			if (((2887 + 63) == (3383 - (153 + 280))) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v93()
		v66();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v77 = v14:GetEnemiesInMeleeRange(14 - 9);
		if (v28 or ((4241 + 482) < (1303 + 1995))) then
			v78 = #v77;
		else
			v78 = 1 + 0;
		end
		if (((1031 + 105) >= (112 + 42)) and (v82.TargetIsValid() or v14:AffectingCombat())) then
			local v133 = 0 - 0;
			while true do
				if ((v133 == (0 + 0)) or ((938 - (89 + 578)) > (3392 + 1356))) then
					v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (10 - 5)) or (1051 - (572 + 477)));
					v80 = v84(v77);
					v133 = 1 + 0;
				end
				if (((2845 + 1895) >= (377 + 2775)) and (v133 == (87 - (84 + 2)))) then
					v76 = v14:IsTankingAoE(13 - 5) or v14:IsTanking(v15);
					break;
				end
			end
		end
		if (v82.TargetIsValid() or ((1858 + 720) >= (4232 - (497 + 345)))) then
			if (((2 + 39) <= (281 + 1380)) and not v14:AffectingCombat()) then
				local v137 = 1333 - (605 + 728);
				local v138;
				while true do
					if (((429 + 172) < (7914 - 4354)) and ((0 + 0) == v137)) then
						v138 = v87();
						if (((868 - 633) < (620 + 67)) and v138) then
							return v138;
						end
						break;
					end
				end
			end
			local v134 = v88();
			if (((12603 - 8054) > (871 + 282)) and v134) then
				return v134;
			end
			if ((v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (489 - (457 + 32))) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 + 0))) or ((6076 - (832 + 570)) < (4402 + 270))) then
				if (((957 + 2711) < (16140 - 11579)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
					return "Pool During Blooddrinker";
				end
			end
			v72 = v62;
			if (v31 or ((220 + 235) == (4401 - (588 + 208)))) then
				local v139 = v89();
				if (v139 or ((7177 - 4514) == (5112 - (884 + 916)))) then
					return v139;
				end
			end
			if (((8953 - 4676) <= (2595 + 1880)) and v29 and v68.RaiseDead:IsCastable()) then
				if (v20(v68.RaiseDead, nil) or ((1523 - (232 + 421)) == (3078 - (1569 + 320)))) then
					return "raise_dead main 4";
				end
			end
			if (((382 + 1171) <= (596 + 2537)) and v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) then
				if (v20(v68.VampiricBlood, v57) or ((7538 - 5301) >= (4116 - (316 + 289)))) then
					return "vampiric_blood main 5";
				end
			end
			if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((3465 - 2141) > (140 + 2880))) then
				if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((4445 - (666 + 787)) == (2306 - (360 + 65)))) then
					return "deaths_caress main 6";
				end
			end
			if (((2903 + 203) > (1780 - (79 + 175))) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (4 - 1)) or v14:BuffUp(v68.CrimsonScourgeBuff))) then
				if (((2359 + 664) < (11862 - 7992)) and (v65 == "At Player")) then
					if (((275 - 132) > (973 - (503 + 396))) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(211 - (92 + 89)))) then
						return "death_and_decay drw_up 16";
					end
				elseif (((34 - 16) < (1084 + 1028)) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(18 + 12))) then
					return "death_and_decay drw_up 16";
				end
			end
			if (((4295 - 3198) <= (223 + 1405)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (22 - 12)))) then
				if (((4040 + 590) == (2212 + 2418)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
					return "death_strike main 10";
				end
			end
			if (((10781 - 7241) > (335 + 2348)) and v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
				if (((7310 - 2516) >= (4519 - (485 + 759))) and v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker))) then
					return "blooddrinker main 12";
				end
			end
			if (((3433 - 1949) == (2673 - (442 + 747))) and v29) then
				local v140 = 1135 - (832 + 303);
				local v141;
				while true do
					if (((2378 - (88 + 858)) < (1084 + 2471)) and (v140 == (0 + 0))) then
						v141 = v90();
						if (v141 or ((44 + 1021) > (4367 - (766 + 23)))) then
							return v141;
						end
						break;
					end
				end
			end
			if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (9 - 7)) or (v15:TimeToDie() < v14:GCD()))) or ((6557 - 1762) < (3706 - 2299))) then
				if (((6289 - 4436) < (5886 - (1036 + 37))) and v20(v68.SacrificialPact, v48)) then
					return "sacrificial_pact main 14";
				end
			end
			if ((v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (2 + 0)) and (v14:RuneTimeToX(7 - 3) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (1.8 + 0))) or (v14:RuneTimeToX(1483 - (641 + 839)) > v14:GCD()))) or ((3734 - (910 + 3)) < (6197 - 3766))) then
				if (v20(v68.BloodTap, v58) or ((4558 - (1466 + 218)) < (1003 + 1178))) then
					return "blood_tap main 16";
				end
			end
			if ((v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) or ((3837 - (556 + 592)) <= (122 + 221))) then
				if (v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp)) or ((2677 - (329 + 479)) == (2863 - (174 + 680)))) then
					return "gorefiends_grasp main 18";
				end
			end
			if ((v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (20 - 14)) and (v14:RunicPowerDeficit() > (10 - 5))) or ((2532 + 1014) < (3061 - (396 + 343)))) then
				if (v20(v68.EmpowerRuneWeapon) or ((185 + 1897) == (6250 - (29 + 1448)))) then
					return "empower_rune_weapon main 20";
				end
			end
			if (((4633 - (135 + 1254)) > (3974 - 2919)) and v29 and v68.AbominationLimb:IsCastable()) then
				if (v20(v68.AbominationLimb, nil, not v15:IsInRange(93 - 73)) or ((2208 + 1105) <= (3305 - (389 + 1138)))) then
					return "abomination_limb main 22";
				end
			end
			if ((v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((1995 - (102 + 472)) >= (1986 + 118))) then
				if (((1005 + 807) <= (3030 + 219)) and v20(v68.DancingRuneWeapon, v53)) then
					return "dancing_rune_weapon main 24";
				end
			end
			if (((3168 - (320 + 1225)) <= (3483 - 1526)) and (v14:BuffUp(v68.DancingRuneWeaponBuff))) then
				local v142 = v91();
				if (((2700 + 1712) == (5876 - (157 + 1307))) and v142) then
					return v142;
				end
				if (((3609 - (821 + 1038)) >= (2100 - 1258)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
					return "Wait/Pool for DRWUp";
				end
			end
			local v134 = v92();
			if (((479 + 3893) > (3286 - 1436)) and v134) then
				return v134;
			end
			if (((87 + 145) < (2034 - 1213)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v94()
		v68.MarkofFyralathDebuff:RegisterAuraTracking();
		v10.Print("Blood DK by Epic. Work in progress Gojira");
	end
	v10.SetAPL(1276 - (834 + 192), v93, v94);
end;
return v1["Epix_DeathKnight_Blood.lua"](...);

