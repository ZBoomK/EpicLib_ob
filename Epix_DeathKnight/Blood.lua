local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1995 - (476 + 255)) < (3370 - (369 + 761))) and not v5) then
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
	local v62;
	local function v63()
		v29 = EpicSettings.Settings['UseRacials'];
		v31 = EpicSettings.Settings['UseHealingPotion'];
		v32 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
		v33 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v34 = EpicSettings.Settings['UseHealthstone'];
		v35 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v36 = EpicSettings.Settings['InterruptWithStun'] or (238 - (64 + 174));
		v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v38 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v30 = EpicSettings.Settings['UseTrinkets'];
		v40 = EpicSettings.Settings['UseDeathStrikeHP'];
		v41 = EpicSettings.Settings['UseDarkSuccorHP'];
		v42 = EpicSettings.Settings['UseAMSAMZOffensively'];
		v43 = EpicSettings.Settings['AntiMagicShellGCD'];
		v44 = EpicSettings.Settings['AntiMagicZoneGCD'];
		v45 = EpicSettings.Settings['DeathAndDecayGCD'];
		v46 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
		v47 = EpicSettings.Settings['SacrificialPactGCD'];
		v48 = EpicSettings.Settings['MindFreezeOffGCD'];
		v49 = EpicSettings.Settings['RacialsOffGCD'];
		v50 = EpicSettings.Settings['BonestormGCD'];
		v51 = EpicSettings.Settings['ChainsOfIceGCD'];
		v52 = EpicSettings.Settings['DancingRuneWeaponGCD'];
		v53 = EpicSettings.Settings['DeathStrikeGCD'];
		v54 = EpicSettings.Settings['IceboundFortitudeGCD'];
		v55 = EpicSettings.Settings['TombstoneGCD'];
		v56 = EpicSettings.Settings['VampiricBloodGCD'];
		v57 = EpicSettings.Settings['BloodTapOffGCD'];
		v58 = EpicSettings.Settings['RuneTapOffGCD'];
		v62 = EpicSettings.Settings['IceboundFortitudeThreshold'];
		v59 = EpicSettings.Settings['RuneTapThreshold'];
		v60 = EpicSettings.Settings['VampiricBloodThreshold'];
		v61 = EpicSettings.Settings['DeathStrikeDumpAmount'];
	end
	local v64;
	local v65 = v15.DeathKnight.Blood;
	local v66 = v17.DeathKnight.Blood;
	local v67 = v20.DeathKnight.Blood;
	local v68 = {v66.Fyralath:ID()};
	local v69 = 281 - (42 + 174);
	local v70 = ((not v65.DeathsCaress:IsAvailable() or v65.Consumption:IsAvailable() or v65.Blooddrinker:IsAvailable()) and (4 + 0)) or (5 + 0);
	local v71 = 0 + 0;
	local v72 = 1504 - (363 + 1141);
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78 = v9.GhoulTable;
	local v79 = v9.Commons.Everyone;
	local v80 = {{v65.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v70 = ((not v65.DeathsCaress:IsAvailable() or v65.Consumption:IsAvailable() or v65.Blooddrinker:IsAvailable()) and (1979 - (1913 + 62))) or (4 + 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v81(v119)
		local v120 = 0 - 0;
		local v121;
		while true do
			if (((5824 - (565 + 1368)) >= (5768 - 4234)) and (v120 == (1662 - (1477 + 184)))) then
				return v121;
			end
			if (((5370 - 1428) == (3673 + 269)) and (v120 == (856 - (564 + 292)))) then
				v121 = 0 - 0;
				for v132, v133 in pairs(v119) do
					if (not v133:DebuffUp(v65.BloodPlagueDebuff) or ((9892 - 6610) > (5031 - (244 + 60)))) then
						v121 = v121 + 1 + 0;
					end
				end
				v120 = 477 - (41 + 435);
			end
		end
	end
	local function v82(v122)
		return (v122:DebuffRemains(v65.SoulReaperDebuff));
	end
	local function v83(v123)
		return ((v123:TimeToX(1036 - (938 + 63)) < (4 + 1)) or (v123:HealthPercentage() <= (1160 - (936 + 189)))) and (v123:TimeToDie() > (v123:DebuffRemains(v65.SoulReaperDebuff) + 2 + 3));
	end
	local function v84()
		local v124 = 1613 - (1565 + 48);
		while true do
			if ((v124 == (0 + 0)) or ((5117 - (782 + 356)) < (3724 - (176 + 91)))) then
				if (((1114 - 686) < (2658 - 854)) and v65.DeathsCaress:IsReady()) then
					if (v19(v65.DeathsCaress, nil, nil, not v14:IsSpellInRange(v65.DeathsCaress)) or ((4417 - (975 + 117)) > (6488 - (157 + 1718)))) then
						return "deaths_caress precombat 4";
					end
				end
				if (v65.Marrowrend:IsReady() or ((4018 + 932) <= (16162 - 11609))) then
					if (((9111 - 6446) <= (4951 - (697 + 321))) and v19(v65.Marrowrend, nil, nil, not v14:IsInMeleeRange(13 - 8))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v85()
		if (((6933 - 3660) == (7545 - 4272)) and v65.RuneTap:IsReady() and v73 and (v13:HealthPercentage() <= v59) and (v13:Rune() >= (2 + 1)) and (v65.RuneTap:Charges() >= (1 - 0)) and v13:BuffDown(v65.RuneTapBuff)) then
			if (((10251 - 6427) > (1636 - (322 + 905))) and v19(v65.RuneTap, v58)) then
				return "rune_tap defensives 2";
			end
		end
		if (((2698 - (602 + 9)) == (3276 - (449 + 740))) and v13:ActiveMitigationNeeded() and (v65.Marrowrend:TimeSinceLastCast() > (874.5 - (826 + 46))) and (v65.DeathStrike:TimeSinceLastCast() > (949.5 - (245 + 702)))) then
			if ((v65.DeathStrike:IsReady() and (v13:BuffStack(v65.BoneShieldBuff) > (21 - 14))) or ((1095 + 2309) > (6401 - (260 + 1638)))) then
				if (v19(v65.DeathStrike, v53, nil, not v14:IsSpellInRange(v65.DeathStrike)) or ((3946 - (382 + 58)) <= (4198 - 2889))) then
					return "death_strike defensives 4";
				end
			end
			if (((2456 + 499) == (6106 - 3151)) and v65.Marrowrend:IsReady()) then
				if (v19(v65.Marrowrend, nil, nil, not v14:IsInMeleeRange(14 - 9)) or ((4108 - (902 + 303)) == (3282 - 1787))) then
					return "marrowrend defensives 6";
				end
			end
			if (((10948 - 6402) >= (196 + 2079)) and v65.DeathStrike:IsReady()) then
				if (((2509 - (1121 + 569)) >= (236 - (22 + 192))) and v19(v65.DeathStrike, v53, nil, not v14:IsSpellInRange(v65.DeathStrike))) then
					return "death_strike defensives 10";
				end
			end
		end
		if (((3845 - (483 + 200)) == (4625 - (1404 + 59))) and v65.VampiricBlood:IsCastable() and v73 and (v13:HealthPercentage() <= v60) and v13:BuffDown(v65.IceboundFortitudeBuff)) then
			if (v19(v65.VampiricBlood, v56) or ((6483 - 4114) > (5951 - 1522))) then
				return "vampiric_blood defensives 14";
			end
		end
		if (((4860 - (468 + 297)) >= (3745 - (334 + 228))) and v65.IceboundFortitude:IsCastable() and v73 and (v13:HealthPercentage() <= v62) and v13:BuffDown(v65.VampiricBloodBuff)) then
			if (v19(v65.IceboundFortitude, v54) or ((12517 - 8806) < (2336 - 1328))) then
				return "icebound_fortitude defensives 16";
			end
		end
		if ((v65.DeathStrike:IsReady() and (v13:HealthPercentage() <= ((90 - 40) + (((v13:RunicPower() > v69) and (6 + 14)) or (236 - (141 + 95))))) and not v13:HealingAbsorbed()) or ((1031 + 18) <= (2331 - 1425))) then
			if (((10848 - 6335) > (639 + 2087)) and v19(v65.DeathStrike, v53, nil, not v14:IsSpellInRange(v65.DeathStrike))) then
				return "death_strike defensives 18";
			end
		end
	end
	local function v86()
	end
	local function v87()
		if ((v65.BloodFury:IsCastable() and v65.DancingRuneWeapon:CooldownUp() and (not v65.Blooddrinker:IsReady() or not v65.Blooddrinker:IsAvailable())) or ((4057 - 2576) >= (1869 + 789))) then
			if (v19(v65.BloodFury) or ((1677 + 1543) == (1920 - 556))) then
				return "blood_fury racials 2";
			end
		end
		if (v65.Berserking:IsCastable() or ((622 + 432) > (3555 - (92 + 71)))) then
			if (v19(v65.Berserking) or ((334 + 342) >= (2760 - 1118))) then
				return "berserking racials 4";
			end
		end
		if (((4901 - (574 + 191)) > (1978 + 419)) and v65.ArcanePulse:IsCastable() and ((v75 >= (4 - 2)) or ((v13:Rune() < (1 + 0)) and (v13:RunicPowerDeficit() > (909 - (254 + 595)))))) then
			if (v19(v65.ArcanePulse, nil, not v14:IsInRange(134 - (55 + 71))) or ((5709 - 1375) == (6035 - (573 + 1217)))) then
				return "arcane_pulse racials 6";
			end
		end
		if ((v65.LightsJudgment:IsCastable() and (v13:BuffUp(v65.UnholyStrengthBuff))) or ((11841 - 7565) <= (231 + 2800))) then
			if (v19(v65.LightsJudgment, nil, not v14:IsSpellInRange(v65.LightsJudgment)) or ((7704 - 2922) <= (2138 - (714 + 225)))) then
				return "lights_judgment racials 8";
			end
		end
		if (v65.AncestralCall:IsCastable() or ((14214 - 9350) < (2651 - 749))) then
			if (((524 + 4315) >= (5357 - 1657)) and v19(v65.AncestralCall)) then
				return "ancestral_call racials 10";
			end
		end
		if (v65.Fireblood:IsCastable() or ((1881 - (118 + 688)) > (1966 - (25 + 23)))) then
			if (((77 + 319) <= (5690 - (927 + 959))) and v19(v65.Fireblood)) then
				return "fireblood racials 12";
			end
		end
		if (v65.BagofTricks:IsCastable() or ((14053 - 9884) == (2919 - (16 + 716)))) then
			if (((2713 - 1307) == (1503 - (11 + 86))) and v19(v65.BagofTricks, nil, not v14:IsSpellInRange(v65.BagofTricks))) then
				return "bag_of_tricks racials 14";
			end
		end
		if (((3734 - 2203) < (4556 - (175 + 110))) and v65.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (50 - 30))) then
			if (((3131 - 2496) == (2431 - (503 + 1293))) and v19(v65.ArcaneTorrent, nil, not v14:IsInRange(22 - 14))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v88()
		local v125 = 0 + 0;
		while true do
			if (((4434 - (810 + 251)) <= (2468 + 1088)) and (v125 == (1 + 0))) then
				if ((v65.SoulReaper:IsReady() and (v75 == (1 + 0)) and ((v14:TimeToX(568 - (43 + 490)) < (738 - (711 + 22))) or (v14:HealthPercentage() <= (135 - 100))) and (v14:TimeToDie() > (v14:DebuffRemains(v65.SoulReaperDebuff) + (864 - (240 + 619))))) or ((795 + 2496) < (5217 - 1937))) then
					if (((291 + 4095) >= (2617 - (1344 + 400))) and v19(v65.SoulReaper, nil, nil, not v14:IsInMeleeRange(410 - (255 + 150)))) then
						return "soul_reaper drw_up 12";
					end
				end
				if (((726 + 195) <= (590 + 512)) and v65.SoulReaper:IsReady() and (v75 >= (8 - 6))) then
					if (((15199 - 10493) >= (2702 - (404 + 1335))) and v79.CastTargetIf(v65.SoulReaper, v74, "min", v82, v83, not v14:IsInMeleeRange(411 - (183 + 223)))) then
						return "soul_reaper drw_up 14";
					end
				end
				if ((v65.DeathAndDecay:IsReady() and v13:BuffDown(v65.DeathAndDecayBuff) and (v65.SanguineGround:IsAvailable() or v65.UnholyGround:IsAvailable())) or ((1168 - 208) <= (581 + 295))) then
					if (v19(v67.DaDPlayer, v45, nil, not v14:IsInRange(11 + 19)) or ((2403 - (10 + 327)) == (650 + 282))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((5163 - (118 + 220)) < (1614 + 3229)) and v65.BloodBoil:IsCastable() and (v75 > (451 - (108 + 341))) and (v65.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
					if (v19(v65.BloodBoil, nil, not v14:IsInMeleeRange(42 - 32)) or ((5370 - (711 + 782)) >= (8697 - 4160))) then
						return "blood_boil drw_up 18";
					end
				end
				v125 = 471 - (270 + 199);
			end
			if (((1 + 1) == v125) or ((6134 - (580 + 1239)) < (5130 - 3404))) then
				v72 = 24 + 1 + (v76 * v21(v65.Heartbreaker:IsAvailable()) * (1 + 1));
				if ((v65.DeathStrike:IsReady() and ((v13:RunicPowerDeficit() <= v72) or (v13:RunicPower() >= v69))) or ((1603 + 2076) < (1631 - 1006))) then
					if (v19(v65.DeathStrike, v53, nil, not v14:IsSpellInRange(v65.DeathStrike)) or ((2874 + 1751) < (1799 - (645 + 522)))) then
						return "death_strike drw_up 20";
					end
				end
				if (v65.Consumption:IsCastable() or ((1873 - (1010 + 780)) > (1780 + 0))) then
					if (((2601 - 2055) <= (3156 - 2079)) and v19(v65.Consumption, nil, not v14:IsSpellInRange(v65.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v65.BloodBoil:IsReady() and (v65.BloodBoil:ChargesFractional() >= (1837.1 - (1045 + 791))) and (v13:BuffStack(v65.HemostasisBuff) < (12 - 7))) or ((1520 - 524) > (4806 - (351 + 154)))) then
					if (((5644 - (1281 + 293)) > (953 - (28 + 238))) and v19(v65.BloodBoil, nil, nil, not v14:IsInMeleeRange(22 - 12))) then
						return "blood_boil drw_up 24";
					end
				end
				v125 = 1562 - (1381 + 178);
			end
			if ((v125 == (0 + 0)) or ((529 + 127) >= (1421 + 1909))) then
				if ((v65.BloodBoil:IsReady() and (v14:DebuffDown(v65.BloodPlagueDebuff))) or ((8590 - 6098) <= (174 + 161))) then
					if (((4792 - (381 + 89)) >= (2272 + 290)) and v19(v65.BloodBoil, nil, nil, not v14:IsInMeleeRange(7 + 3))) then
						return "blood_boil drw_up 2";
					end
				end
				if ((v65.Tombstone:IsReady() and (v13:BuffStack(v65.BoneShieldBuff) > (8 - 3)) and (v13:Rune() >= (1158 - (1074 + 82))) and (v13:RunicPowerDeficit() >= (65 - 35)) and (not v65.ShatteringBone:IsAvailable() or (v65.ShatteringBone:IsAvailable() and v13:BuffUp(v65.DeathAndDecayBuff)))) or ((5421 - (214 + 1570)) >= (5225 - (990 + 465)))) then
					if (v19(v65.Tombstone) or ((981 + 1398) > (1992 + 2586))) then
						return "tombstone drw_up 4";
					end
				end
				if ((v65.DeathStrike:IsReady() and ((v13:BuffRemains(v65.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v65.IcyTalonsBuff) <= v13:GCD()))) or ((470 + 13) > (2923 - 2180))) then
					if (((4180 - (1668 + 58)) > (1204 - (512 + 114))) and v19(v65.DeathStrike, v53, nil, not v14:IsInMeleeRange(13 - 8))) then
						return "death_strike drw_up 6";
					end
				end
				if (((1922 - 992) < (15512 - 11054)) and v65.Marrowrend:IsReady() and ((v13:BuffRemains(v65.BoneShieldBuff) <= (2 + 2)) or (v13:BuffStack(v65.BoneShieldBuff) < v70)) and (v13:RunicPowerDeficit() > (4 + 16))) then
					if (((576 + 86) <= (3278 - 2306)) and v19(v65.Marrowrend, nil, nil, not v14:IsInMeleeRange(1999 - (109 + 1885)))) then
						return "marrowrend drw_up 10";
					end
				end
				v125 = 1470 - (1269 + 200);
			end
			if (((8376 - 4006) == (5185 - (98 + 717))) and (v125 == (829 - (802 + 24)))) then
				if ((v65.HeartStrike:IsReady() and ((v13:RuneTimeToX(2 - 0) < v13:GCD()) or (v13:RunicPowerDeficit() >= v72))) or ((6013 - 1251) <= (128 + 733))) then
					if (v19(v65.HeartStrike, nil, nil, not v14:IsSpellInRange(v65.HeartStrike)) or ((1085 + 327) == (701 + 3563))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
		end
	end
	local function v89()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (8 - 5)) or ((10564 - 7396) < (771 + 1382))) then
				if ((v65.BloodBoil:IsCastable() and (v65.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v13:BuffStack(v65.HemostasisBuff) <= ((5 + 0) - v75)) or (v75 > (2 + 0)))) or ((2324 + 2652) < (2765 - (797 + 636)))) then
					if (((22470 - 17842) == (6247 - (1427 + 192))) and v19(v65.BloodBoil, nil, not v14:IsInMeleeRange(4 + 6))) then
						return "blood_boil standard 18";
					end
				end
				if ((v65.HeartStrike:IsReady() and (v13:RuneTimeToX(8 - 4) < v13:GCD())) or ((49 + 5) == (180 + 215))) then
					if (((408 - (192 + 134)) == (1358 - (316 + 960))) and v19(v65.HeartStrike, nil, nil, not v14:IsSpellInRange(v65.HeartStrike))) then
						return "heart_strike standard 20";
					end
				end
				if ((v65.BloodBoil:IsCastable() and (v65.BloodBoil:ChargesFractional() >= (1.1 + 0))) or ((449 + 132) < (261 + 21))) then
					if (v19(v65.BloodBoil, nil, nil, not v14:IsInMeleeRange(38 - 28)) or ((5160 - (83 + 468)) < (4301 - (1202 + 604)))) then
						return "blood_boil standard 22";
					end
				end
				v126 = 18 - 14;
			end
			if (((1916 - 764) == (3189 - 2037)) and (v126 == (326 - (45 + 280)))) then
				if (((1831 + 65) <= (2990 + 432)) and v65.DeathsCaress:IsReady() and ((v13:BuffRemains(v65.BoneShieldBuff) <= (2 + 2)) or (v13:BuffStack(v65.BoneShieldBuff) < (v70 + 1 + 0))) and (v13:RunicPowerDeficit() > (2 + 8)) and not (v65.InsatiableBlade:IsAvailable() and (v65.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v65.BoneShieldBuff))) and not v65.Consumption:IsAvailable() and not v65.Blooddrinker:IsAvailable() and (v13:RuneTimeToX(5 - 2) > v13:GCD())) then
					if (v19(v65.DeathsCaress, nil, nil, not v14:IsSpellInRange(v65.DeathsCaress)) or ((2901 - (340 + 1571)) > (639 + 981))) then
						return "deaths_caress standard 6";
					end
				end
				if ((v65.Marrowrend:IsReady() and ((v13:BuffRemains(v65.BoneShieldBuff) <= (1776 - (1733 + 39))) or (v13:BuffStack(v65.BoneShieldBuff) < v70)) and (v13:RunicPowerDeficit() > (54 - 34)) and not (v65.InsatiableBlade:IsAvailable() and (v65.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v65.BoneShieldBuff)))) or ((1911 - (125 + 909)) > (6643 - (1096 + 852)))) then
					if (((1208 + 1483) >= (2643 - 792)) and v19(v65.Marrowrend, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
						return "marrowrend standard 8";
					end
				end
				if (v65.Consumption:IsCastable() or ((3497 - (409 + 103)) >= (5092 - (46 + 190)))) then
					if (((4371 - (51 + 44)) >= (338 + 857)) and v19(v65.Consumption, nil, not v14:IsSpellInRange(v65.Consumption))) then
						return "consumption standard 10";
					end
				end
				v126 = 1319 - (1114 + 203);
			end
			if (((3958 - (228 + 498)) <= (1017 + 3673)) and (v126 == (0 + 0))) then
				if ((v28 and v65.Tombstone:IsCastable() and (v13:BuffStack(v65.BoneShieldBuff) > (668 - (174 + 489))) and (v13:Rune() >= (5 - 3)) and (v13:RunicPowerDeficit() >= (1935 - (830 + 1075))) and (not v65.ShatteringBone:IsAvailable() or (v65.ShatteringBone:IsAvailable() and v13:BuffUp(v65.DeathAndDecayBuff))) and (v65.DancingRuneWeapon:CooldownRemains() >= (549 - (303 + 221)))) or ((2165 - (231 + 1038)) >= (2622 + 524))) then
					if (((4223 - (171 + 991)) >= (12190 - 9232)) and v19(v65.Tombstone)) then
						return "tombstone standard 2";
					end
				end
				v71 = (26 - 16) + (v75 * v21(v65.Heartbreaker:IsAvailable()) * (4 - 2));
				if (((2551 + 636) >= (2257 - 1613)) and v65.DeathStrike:IsReady() and ((v13:BuffRemains(v65.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v65.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v69) or (v13:RunicPowerDeficit() <= v71) or (v14:TimeToDie() < (28 - 18)))) then
					if (((1037 - 393) <= (2176 - 1472)) and v19(v65.DeathStrike, v53, nil, not v14:IsInMeleeRange(1253 - (111 + 1137)))) then
						return "death_strike standard 4";
					end
				end
				v126 = 159 - (91 + 67);
			end
			if (((2851 - 1893) > (237 + 710)) and (v126 == (525 - (423 + 100)))) then
				if (((32 + 4460) >= (7348 - 4694)) and v65.SoulReaper:IsReady() and (v75 == (1 + 0)) and ((v14:TimeToX(806 - (326 + 445)) < (21 - 16)) or (v14:HealthPercentage() <= (77 - 42))) and (v14:TimeToDie() > (v14:DebuffRemains(v65.SoulReaperDebuff) + (11 - 6)))) then
					if (((4153 - (530 + 181)) >= (2384 - (614 + 267))) and v19(v65.SoulReaper, nil, nil, not v14:IsInMeleeRange(37 - (19 + 13)))) then
						return "soul_reaper standard 12";
					end
				end
				if ((v65.SoulReaper:IsReady() and (v75 >= (2 - 0))) or ((7387 - 4217) <= (4182 - 2718))) then
					if (v79.CastTargetIf(v65.SoulReaper, v74, "min", v82, v83, not v14:IsInMeleeRange(2 + 3)) or ((8436 - 3639) == (9099 - 4711))) then
						return "soul_reaper standard 14";
					end
				end
				if (((2363 - (1293 + 519)) <= (1389 - 708)) and v28 and v65.Bonestorm:IsReady() and (v13:RunicPower() >= (261 - 161))) then
					if (((6266 - 2989) > (1754 - 1347)) and v19(v65.Bonestorm)) then
						return "bonestorm standard 16";
					end
				end
				v126 = 6 - 3;
			end
			if (((2487 + 2208) >= (289 + 1126)) and (v126 == (9 - 5))) then
				if ((v65.HeartStrike:IsReady() and (v13:Rune() > (1 + 0)) and ((v13:RuneTimeToX(1 + 2) < v13:GCD()) or (v13:BuffStack(v65.BoneShieldBuff) > (5 + 2)))) or ((4308 - (709 + 387)) <= (2802 - (673 + 1185)))) then
					if (v19(v65.HeartStrike, nil, nil, not v14:IsSpellInRange(v65.HeartStrike)) or ((8978 - 5882) <= (5773 - 3975))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
		end
	end
	local function v90()
		v63();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v74 = v13:GetEnemiesInMeleeRange(8 - 3);
		if (((2530 + 1007) == (2643 + 894)) and v27) then
			v75 = #v74;
		else
			v75 = 1 - 0;
		end
		if (((943 + 2894) >= (3130 - 1560)) and (v79.TargetIsValid() or v13:AffectingCombat())) then
			v76 = v23(v75, (v13:BuffUp(v65.DeathAndDecayBuff) and (9 - 4)) or (1882 - (446 + 1434)));
			v77 = v81(v74);
			v73 = v13:IsTankingAoE(1291 - (1040 + 243)) or v13:IsTanking(v14);
		end
		if (v79.TargetIsValid() or ((8804 - 5854) == (5659 - (559 + 1288)))) then
			if (((6654 - (609 + 1322)) >= (2772 - (13 + 441))) and not v13:AffectingCombat()) then
				local v134 = v84();
				if (v134 or ((7574 - 5547) > (7470 - 4618))) then
					return v134;
				end
			end
			if (v73 or ((5657 - 4521) > (161 + 4156))) then
				local v135 = v85();
				if (((17243 - 12495) == (1687 + 3061)) and v135) then
					return v135;
				end
			end
			if (((1638 + 2098) <= (14066 - 9326)) and v13:IsChanneling(v65.Blooddrinker) and v13:BuffUp(v65.BoneShieldBuff) and (v77 == (0 + 0)) and not v13:ShouldStopCasting() and (v13:CastRemains() > (0.2 - 0))) then
				if (v9.CastAnnotated(v65.Pool, false, "WAIT") or ((2242 + 1148) <= (1702 + 1358))) then
					return "Pool During Blooddrinker";
				end
			end
			v69 = v61;
			if (v30 or ((718 + 281) > (2262 + 431))) then
				local v136 = 0 + 0;
				local v137;
				while true do
					if (((896 - (153 + 280)) < (1735 - 1134)) and ((0 + 0) == v136)) then
						v137 = v86();
						if (v137 or ((862 + 1321) < (360 + 327))) then
							return v137;
						end
						break;
					end
				end
			end
			if (((4129 + 420) == (3297 + 1252)) and v28 and v65.RaiseDead:IsCastable()) then
				if (((7113 - 2441) == (2888 + 1784)) and v19(v65.RaiseDead, nil)) then
					return "raise_dead main 4";
				end
			end
			if ((v65.VampiricBlood:IsCastable() and v13:BuffDown(v65.VampiricBloodBuff) and v13:BuffDown(v65.VampiricStrengthBuff)) or ((4335 - (89 + 578)) < (283 + 112))) then
				if (v19(v65.VampiricBlood, v56) or ((8660 - 4494) == (1504 - (572 + 477)))) then
					return "vampiric_blood main 5";
				end
			end
			if ((v65.DeathsCaress:IsReady() and (v13:BuffDown(v65.BoneShieldBuff))) or ((601 + 3848) == (1599 + 1064))) then
				if (v19(v65.DeathsCaress, nil, nil, not v14:IsSpellInRange(v65.DeathsCaress)) or ((511 + 3766) < (3075 - (84 + 2)))) then
					return "deaths_caress main 6";
				end
			end
			if ((v65.DeathAndDecay:IsReady() and v13:BuffDown(v65.DeathAndDecayBuff) and (v65.UnholyGround:IsAvailable() or v65.SanguineGround:IsAvailable() or (v75 > (4 - 1)) or v13:BuffUp(v65.CrimsonScourgeBuff))) or ((627 + 243) >= (4991 - (497 + 345)))) then
				if (((57 + 2155) < (539 + 2644)) and v19(v67.DaDPlayer, v45, nil, not v14:IsInRange(1363 - (605 + 728)))) then
					return "death_and_decay main 8";
				end
			end
			if (((3315 + 1331) > (6651 - 3659)) and v65.DeathStrike:IsReady() and ((v13:BuffRemains(v65.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v65.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v69) or (v13:RunicPowerDeficit() <= v71) or (v14:TimeToDie() < (1 + 9)))) then
				if (((5301 - 3867) < (2801 + 305)) and v19(v65.DeathStrike, v53, nil, not v14:IsSpellInRange(v65.DeathStrike))) then
					return "death_strike main 10";
				end
			end
			if (((2177 - 1391) < (2283 + 740)) and v65.Blooddrinker:IsReady() and (v13:BuffDown(v65.DancingRuneWeaponBuff))) then
				if (v19(v65.Blooddrinker, nil, nil, not v14:IsSpellInRange(v65.Blooddrinker)) or ((2931 - (457 + 32)) < (32 + 42))) then
					return "blooddrinker main 12";
				end
			end
			if (((5937 - (832 + 570)) == (4273 + 262)) and v28) then
				local v138 = 0 + 0;
				local v139;
				while true do
					if ((v138 == (0 - 0)) or ((1450 + 1559) <= (2901 - (588 + 208)))) then
						v139 = v87();
						if (((4932 - 3102) < (5469 - (884 + 916))) and v139) then
							return v139;
						end
						break;
					end
				end
			end
			if ((v28 and v65.SacrificialPact:IsReady() and v78.GhoulActive() and v13:BuffDown(v65.DancingRuneWeaponBuff) and ((v78.GhoulRemains() < (3 - 1)) or (v14:TimeToDie() < v13:GCD()))) or ((830 + 600) >= (4265 - (232 + 421)))) then
				if (((4572 - (1569 + 320)) >= (604 + 1856)) and v19(v65.SacrificialPact, v47)) then
					return "sacrificial_pact main 14";
				end
			end
			if ((v28 and v65.BloodTap:IsCastable() and (((v13:Rune() <= (1 + 1)) and (v13:RuneTimeToX(13 - 9) > v13:GCD()) and (v65.BloodTap:ChargesFractional() >= (606.8 - (316 + 289)))) or (v13:RuneTimeToX(7 - 4) > v13:GCD()))) or ((84 + 1720) >= (4728 - (666 + 787)))) then
				if (v19(v65.BloodTap, v57) or ((1842 - (360 + 65)) > (3392 + 237))) then
					return "blood_tap main 16";
				end
			end
			if (((5049 - (79 + 175)) > (633 - 231)) and v28 and v65.GorefiendsGrasp:IsCastable() and (v65.TighteningGrasp:IsAvailable())) then
				if (((3756 + 1057) > (10927 - 7362)) and v19(v65.GorefiendsGrasp, nil, not v14:IsSpellInRange(v65.GorefiendsGrasp))) then
					return "gorefiends_grasp main 18";
				end
			end
			if (((7533 - 3621) == (4811 - (503 + 396))) and v28 and v65.EmpowerRuneWeapon:IsReady() and (v13:Rune() < (187 - (92 + 89))) and (v13:RunicPowerDeficit() > (9 - 4))) then
				if (((1447 + 1374) <= (2856 + 1968)) and v19(v65.EmpowerRuneWeapon)) then
					return "empower_rune_weapon main 20";
				end
			end
			if (((6806 - 5068) <= (301 + 1894)) and v28 and v65.AbominationLimb:IsCastable()) then
				if (((93 - 52) <= (2634 + 384)) and v19(v65.AbominationLimb, nil, not v14:IsInRange(10 + 10))) then
					return "abomination_limb main 22";
				end
			end
			if (((6532 - 4387) <= (513 + 3591)) and v28 and v65.DancingRuneWeapon:IsCastable() and (v13:BuffDown(v65.DancingRuneWeaponBuff))) then
				if (((4100 - 1411) < (6089 - (485 + 759))) and v19(v65.DancingRuneWeapon, v52)) then
					return "dancing_rune_weapon main 24";
				end
			end
			if ((v13:BuffUp(v65.DancingRuneWeaponBuff)) or ((5372 - 3050) > (3811 - (442 + 747)))) then
				local v140 = v88();
				if (v140 or ((5669 - (832 + 303)) == (3028 - (88 + 858)))) then
					return v140;
				end
				if (v9.CastAnnotated(v65.Pool, false, "WAIT") or ((479 + 1092) > (1546 + 321))) then
					return "Wait/Pool for DRWUp";
				end
			end
			local v131 = v89();
			if (v131 or ((110 + 2544) >= (3785 - (766 + 23)))) then
				return v131;
			end
			if (((19638 - 15660) > (2877 - 773)) and v9.CastAnnotated(v65.Pool, false, "WAIT")) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v91()
		local v130 = 0 - 0;
		while true do
			if (((10165 - 7170) > (2614 - (1036 + 37))) and (v130 == (0 + 0))) then
				v65.MarkofFyralathDebuff:RegisterAuraTracking();
				v9.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(486 - 236, v90, v91);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

