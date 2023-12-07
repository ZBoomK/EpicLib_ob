local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((17 + 5) <= (707 + 1548)) and not v5) then
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
		local v91 = 267 - (176 + 91);
		while true do
			if ((v91 == (7 - 4)) or ((1600 - 514) >= (2497 - (975 + 117)))) then
				v48 = EpicSettings.Settings['MindFreezeOffGCD'];
				v49 = EpicSettings.Settings['RacialsOffGCD'];
				v50 = EpicSettings.Settings['BonestormGCD'];
				v51 = EpicSettings.Settings['ChainsOfIceGCD'];
				v52 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v53 = EpicSettings.Settings['DeathStrikeGCD'];
				v91 = 1879 - (157 + 1718);
			end
			if ((v91 == (2 + 0)) or ((8409 - 6040) == (1456 - 1030))) then
				v42 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v43 = EpicSettings.Settings['AntiMagicShellGCD'];
				v44 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v45 = EpicSettings.Settings['DeathAndDecayGCD'];
				v46 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v47 = EpicSettings.Settings['SacrificialPactGCD'];
				v91 = 1021 - (697 + 321);
			end
			if ((v91 == (13 - 8)) or ((6516 - 3440) > (7337 - 4154))) then
				v60 = EpicSettings.Settings['VampiricBloodThreshold'];
				v61 = EpicSettings.Settings['DeathStrikeDumpAmount'];
				break;
			end
			if (((468 + 734) > (1981 - 923)) and (v91 == (0 - 0))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (1227 - (322 + 905));
				v33 = EpicSettings.Settings['HealingPotionHP'] or (611 - (602 + 9));
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (1189 - (449 + 740));
				v91 = 873 - (826 + 46);
			end
			if (((4658 - (245 + 702)) > (10601 - 7246)) and (v91 == (2 + 2))) then
				v54 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v55 = EpicSettings.Settings['TombstoneGCD'];
				v56 = EpicSettings.Settings['VampiricBloodGCD'];
				v57 = EpicSettings.Settings['BloodTapOffGCD'];
				v58 = EpicSettings.Settings['RuneTapOffGCD'];
				v59 = EpicSettings.Settings['RuneTapThreshold'];
				v91 = 1903 - (260 + 1638);
			end
			if ((v91 == (441 - (382 + 58))) or ((2906 - 2000) >= (1853 + 376))) then
				v36 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptThreshold'] or (1205 - (902 + 303));
				v30 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseDeathStrikeHP'];
				v41 = EpicSettings.Settings['UseDarkSuccorHP'];
				v91 = 3 - 1;
			end
		end
	end
	local v63;
	local v64 = v15.DeathKnight.Blood;
	local v65 = v17.DeathKnight.Blood;
	local v66 = v20.DeathKnight.Blood;
	local v67 = {v65.Fyralath:ID()};
	local v68 = 6 + 59;
	local v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (1694 - (1121 + 569))) or (219 - (22 + 192));
	local v70 = 683 - (483 + 200);
	local v71 = 1463 - (1404 + 59);
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
		v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (13 - 9)) or (11 - 6);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v80(v92)
		local v93 = 0 - 0;
		local v94;
		while true do
			if (((366 + 922) > (1487 - (141 + 95))) and (v93 == (1 + 0))) then
				return v94;
			end
			if ((v93 == (0 - 0)) or ((10848 - 6335) < (786 + 2566))) then
				v94 = 0 - 0;
				for v130, v131 in pairs(v92) do
					if (not v131:DebuffUp(v64.BloodPlagueDebuff) or ((1452 + 613) >= (1665 + 1531))) then
						v94 = v94 + (1 - 0);
					end
				end
				v93 = 1 + 0;
			end
		end
	end
	local function v81(v95)
		return (v95:DebuffRemains(v64.SoulReaperDebuff));
	end
	local function v82(v96)
		return ((v96:TimeToX(198 - (92 + 71)) < (3 + 2)) or (v96:HealthPercentage() <= (58 - 23))) and (v96:TimeToDie() > (v96:DebuffRemains(v64.SoulReaperDebuff) + (770 - (574 + 191))));
	end
	local function v83()
		if (v64.DeathsCaress:IsReady() or ((3610 + 766) <= (3710 - 2229))) then
			if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((1733 + 1659) >= (5590 - (254 + 595)))) then
				return "deaths_caress precombat 4";
			end
		end
		if (((3451 - (55 + 71)) >= (2837 - 683)) and v64.Marrowrend:IsReady()) then
			if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(1795 - (573 + 1217))) or ((3586 - 2291) >= (246 + 2987))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v84()
		if (((7052 - 2675) > (2581 - (714 + 225))) and v64.RuneTap:IsReady() and v72 and (v13:HealthPercentage() <= v59) and (v13:Rune() >= (8 - 5)) and (v64.RuneTap:Charges() >= (1 - 0)) and v13:BuffDown(v64.RuneTapBuff)) then
			if (((512 + 4211) > (1962 - 606)) and v19(v64.RuneTap, v58)) then
				return "rune_tap defensives 2";
			end
		end
		if ((v13:ActiveMitigationNeeded() and (v64.Marrowrend:TimeSinceLastCast() > (808.5 - (118 + 688))) and (v64.DeathStrike:TimeSinceLastCast() > (50.5 - (25 + 23)))) or ((802 + 3334) <= (5319 - (927 + 959)))) then
			if (((14309 - 10064) <= (5363 - (16 + 716))) and v64.DeathStrike:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (12 - 5))) then
				if (((4373 - (11 + 86)) >= (9546 - 5632)) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
					return "death_strike defensives 4";
				end
			end
			if (((483 - (175 + 110)) <= (11020 - 6655)) and v64.Marrowrend:IsReady()) then
				if (((23586 - 18804) > (6472 - (503 + 1293))) and v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(13 - 8))) then
					return "marrowrend defensives 6";
				end
			end
			if (((3518 + 1346) > (3258 - (810 + 251))) and v64.DeathStrike:IsReady()) then
				if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((2568 + 1132) == (770 + 1737))) then
					return "death_strike defensives 10";
				end
			end
		end
		if (((4034 + 440) >= (807 - (43 + 490))) and v64.VampiricBlood:IsCastable() and v72 and (v13:HealthPercentage() <= v60) and v13:BuffDown(v64.IceboundFortitudeBuff)) then
			if (v19(v64.VampiricBlood, v56) or ((2627 - (711 + 22)) <= (5438 - 4032))) then
				return "vampiric_blood defensives 14";
			end
		end
		if (((2431 - (240 + 619)) >= (370 + 1161)) and v64.IceboundFortitude:IsCastable() and v72 and (v13:HealthPercentage() <= IceboundFortitudeThreshold) and v13:BuffDown(v64.VampiricBloodBuff)) then
			if (v19(v64.IceboundFortitude, v54) or ((7454 - 2767) < (301 + 4241))) then
				return "icebound_fortitude defensives 16";
			end
		end
		if (((5035 - (1344 + 400)) > (2072 - (255 + 150))) and v64.DeathStrike:IsReady() and (v13:HealthPercentage() <= (40 + 10 + (((v13:RunicPower() > v68) and (11 + 9)) or (0 - 0)))) and not v13:HealingAbsorbed()) then
			if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((2819 - 1946) == (3773 - (404 + 1335)))) then
				return "death_strike defensives 18";
			end
		end
	end
	local function v85()
	end
	local function v86()
		local v97 = 406 - (183 + 223);
		while true do
			if ((v97 == (1 - 0)) or ((1866 + 950) < (4 + 7))) then
				if (((4036 - (10 + 327)) < (3278 + 1428)) and v64.ArcanePulse:IsCastable() and ((v74 >= (340 - (118 + 220))) or ((v13:Rune() < (1 + 0)) and (v13:RunicPowerDeficit() > (509 - (108 + 341)))))) then
					if (((1189 + 1457) >= (3703 - 2827)) and v19(v64.ArcanePulse, nil, not v14:IsInRange(1501 - (711 + 782)))) then
						return "arcane_pulse racials 6";
					end
				end
				if (((1176 - 562) <= (3653 - (270 + 199))) and v64.LightsJudgment:IsCastable() and (v13:BuffUp(v64.UnholyStrengthBuff))) then
					if (((1014 + 2112) == (4945 - (580 + 1239))) and v19(v64.LightsJudgment, nil, not v14:IsSpellInRange(v64.LightsJudgment))) then
						return "lights_judgment racials 8";
					end
				end
				v97 = 5 - 3;
			end
			if ((v97 == (3 + 0)) or ((79 + 2108) >= (2159 + 2795))) then
				if (v64.BagofTricks:IsCastable() or ((10122 - 6245) == (2221 + 1354))) then
					if (((1874 - (645 + 522)) > (2422 - (1010 + 780))) and v19(v64.BagofTricks, nil, not v14:IsSpellInRange(v64.BagofTricks))) then
						return "bag_of_tricks racials 14";
					end
				end
				if ((v64.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (20 + 0))) or ((2601 - 2055) >= (7865 - 5181))) then
					if (((3301 - (1045 + 791)) <= (10886 - 6585)) and v19(v64.ArcaneTorrent, nil, not v14:IsInRange(12 - 4))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if (((2209 - (351 + 154)) > (2999 - (1281 + 293))) and (v97 == (268 - (28 + 238)))) then
				if (v64.AncestralCall:IsCastable() or ((1535 - 848) == (5793 - (1381 + 178)))) then
					if (v19(v64.AncestralCall) or ((3124 + 206) < (1153 + 276))) then
						return "ancestral_call racials 10";
					end
				end
				if (((490 + 657) >= (1154 - 819)) and v64.Fireblood:IsCastable()) then
					if (((1780 + 1655) > (2567 - (381 + 89))) and v19(v64.Fireblood)) then
						return "fireblood racials 12";
					end
				end
				v97 = 3 + 0;
			end
			if ((v97 == (0 + 0)) or ((6457 - 2687) >= (5197 - (1074 + 82)))) then
				if ((v64.BloodFury:IsCastable() and v64.DancingRuneWeapon:CooldownUp() and (not v64.Blooddrinker:IsReady() or not v64.Blooddrinker:IsAvailable())) or ((8307 - 4516) <= (3395 - (214 + 1570)))) then
					if (v19(v64.BloodFury) or ((6033 - (990 + 465)) <= (828 + 1180))) then
						return "blood_fury racials 2";
					end
				end
				if (((490 + 635) <= (2019 + 57)) and v64.Berserking:IsCastable()) then
					if (v19(v64.Berserking) or ((2923 - 2180) >= (6125 - (1668 + 58)))) then
						return "berserking racials 4";
					end
				end
				v97 = 627 - (512 + 114);
			end
		end
	end
	local function v87()
		if (((3011 - 1856) < (3458 - 1785)) and v64.BloodBoil:IsReady() and (v14:DebuffDown(v64.BloodPlagueDebuff))) then
			if (v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(34 - 24)) or ((1082 + 1242) <= (109 + 469))) then
				return "blood_boil drw_up 2";
			end
		end
		if (((3275 + 492) == (12705 - 8938)) and v64.Tombstone:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (1999 - (109 + 1885))) and (v13:Rune() >= (1471 - (1269 + 200))) and (v13:RunicPowerDeficit() >= (57 - 27)) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff)))) then
			if (((4904 - (98 + 717)) == (4915 - (802 + 24))) and v19(v64.Tombstone)) then
				return "tombstone drw_up 4";
			end
		end
		if (((7687 - 3229) >= (2113 - 439)) and v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()))) then
			if (((144 + 828) <= (1090 + 328)) and v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(1 + 4))) then
				return "death_strike drw_up 6";
			end
		end
		if ((v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (1 + 3)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (55 - 35))) or ((16466 - 11528) < (1704 + 3058))) then
			if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(3 + 2)) or ((2066 + 438) > (3101 + 1163))) then
				return "marrowrend drw_up 10";
			end
		end
		if (((1006 + 1147) == (3586 - (797 + 636))) and v64.SoulReaper:IsReady() and (v74 == (4 - 3)) and ((v14:TimeToX(1654 - (1427 + 192)) < (2 + 3)) or (v14:HealthPercentage() <= (81 - 46))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + 5 + 0))) then
			if (v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(3 + 2)) or ((833 - (192 + 134)) >= (3867 - (316 + 960)))) then
				return "soul_reaper drw_up 12";
			end
		end
		if (((2494 + 1987) == (3459 + 1022)) and v64.SoulReaper:IsReady() and (v74 >= (2 + 0))) then
			if (v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(18 - 13)) or ((2879 - (83 + 468)) < (2499 - (1202 + 604)))) then
				return "soul_reaper drw_up 14";
			end
		end
		if (((20203 - 15875) == (7202 - 2874)) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.SanguineGround:IsAvailable() or v64.UnholyGround:IsAvailable())) then
			if (((4396 - 2808) >= (1657 - (45 + 280))) and v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(29 + 1))) then
				return "death_and_decay drw_up 16";
			end
		end
		if ((v64.BloodBoil:IsCastable() and (v74 > (2 + 0)) and (v64.BloodBoil:ChargesFractional() >= (1.1 + 0))) or ((2310 + 1864) > (748 + 3500))) then
			if (v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(18 - 8)) or ((6497 - (340 + 1571)) <= (33 + 49))) then
				return "blood_boil drw_up 18";
			end
		end
		v71 = (1797 - (1733 + 39)) + (v75 * v21(v64.Heartbreaker:IsAvailable()) * (5 - 3));
		if (((4897 - (125 + 909)) == (5811 - (1096 + 852))) and v64.DeathStrike:IsReady() and ((v13:RunicPowerDeficit() <= v71) or (v13:RunicPower() >= v68))) then
			if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((127 + 155) <= (59 - 17))) then
				return "death_strike drw_up 20";
			end
		end
		if (((4471 + 138) >= (1278 - (409 + 103))) and v64.Consumption:IsCastable()) then
			if (v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption)) or ((1388 - (46 + 190)) == (2583 - (51 + 44)))) then
				return "consumption drw_up 22";
			end
		end
		if (((966 + 2456) > (4667 - (1114 + 203))) and v64.BloodBoil:IsReady() and (v64.BloodBoil:ChargesFractional() >= (727.1 - (228 + 498))) and (v13:BuffStack(v64.HemostasisBuff) < (2 + 3))) then
			if (((485 + 392) > (1039 - (174 + 489))) and v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(26 - 16))) then
				return "blood_boil drw_up 24";
			end
		end
		if ((v64.HeartStrike:IsReady() and ((v13:RuneTimeToX(1907 - (830 + 1075)) < v13:GCD()) or (v13:RunicPowerDeficit() >= v71))) or ((3642 - (303 + 221)) <= (3120 - (231 + 1038)))) then
			if (v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike)) or ((138 + 27) >= (4654 - (171 + 991)))) then
				return "heart_strike drw_up 26";
			end
		end
	end
	local function v88()
		local v98 = 0 - 0;
		while true do
			if (((10603 - 6654) < (12117 - 7261)) and (v98 == (2 + 0))) then
				if ((v64.SoulReaper:IsReady() and (v74 == (3 - 2)) and ((v14:TimeToX(100 - 65) < (8 - 3)) or (v14:HealthPercentage() <= (108 - 73))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + (1253 - (111 + 1137))))) or ((4434 - (91 + 67)) < (8976 - 5960))) then
					if (((1171 + 3519) > (4648 - (423 + 100))) and v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(1 + 4))) then
						return "soul_reaper standard 12";
					end
				end
				if ((v64.SoulReaper:IsReady() and (v74 >= (5 - 3))) or ((27 + 23) >= (1667 - (326 + 445)))) then
					if (v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(21 - 16)) or ((3818 - 2104) >= (6904 - 3946))) then
						return "soul_reaper standard 14";
					end
				end
				if ((v28 and v64.Bonestorm:IsReady() and (v13:RunicPower() >= (761 - (530 + 181)))) or ((2372 - (614 + 267)) < (676 - (19 + 13)))) then
					if (((1145 - 441) < (2299 - 1312)) and v19(v64.Bonestorm)) then
						return "bonestorm standard 16";
					end
				end
				v98 = 8 - 5;
			end
			if (((966 + 2752) > (3351 - 1445)) and ((7 - 3) == v98)) then
				if ((v64.HeartStrike:IsReady() and (v13:Rune() > (1813 - (1293 + 519))) and ((v13:RuneTimeToX(5 - 2) < v13:GCD()) or (v13:BuffStack(v64.BoneShieldBuff) > (18 - 11)))) or ((1831 - 873) > (15674 - 12039))) then
					if (((8247 - 4746) <= (2380 + 2112)) and v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
			if ((v98 == (1 + 2)) or ((7997 - 4555) < (589 + 1959))) then
				if (((956 + 1919) >= (915 + 549)) and v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (1097.8 - (709 + 387))) and ((v13:BuffStack(v64.HemostasisBuff) <= ((1863 - (673 + 1185)) - v74)) or (v74 > (5 - 3)))) then
					if (v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(32 - 22)) or ((7891 - 3094) >= (3500 + 1393))) then
						return "blood_boil standard 18";
					end
				end
				if ((v64.HeartStrike:IsReady() and (v13:RuneTimeToX(3 + 1) < v13:GCD())) or ((743 - 192) > (508 + 1560))) then
					if (((4214 - 2100) > (1852 - 908)) and v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike))) then
						return "heart_strike standard 20";
					end
				end
				if ((v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (1881.1 - (446 + 1434)))) or ((3545 - (1040 + 243)) >= (9240 - 6144))) then
					if (v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(1857 - (559 + 1288))) or ((4186 - (609 + 1322)) >= (3991 - (13 + 441)))) then
						return "blood_boil standard 22";
					end
				end
				v98 = 14 - 10;
			end
			if ((v98 == (2 - 1)) or ((19109 - 15272) < (49 + 1257))) then
				if (((10713 - 7763) == (1048 + 1902)) and v64.DeathsCaress:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (2 + 2)) or (v13:BuffStack(v64.BoneShieldBuff) < (v69 + (2 - 1)))) and (v13:RunicPowerDeficit() > (6 + 4)) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff))) and not v64.Consumption:IsAvailable() and not v64.Blooddrinker:IsAvailable() and (v13:RuneTimeToX(4 - 1) > v13:GCD())) then
					if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((3123 + 1600) < (1835 + 1463))) then
						return "deaths_caress standard 6";
					end
				end
				if (((817 + 319) >= (130 + 24)) and v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (4 + 0)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (453 - (153 + 280))) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff)))) then
					if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(14 - 9)) or ((244 + 27) > (1875 + 2873))) then
						return "marrowrend standard 8";
					end
				end
				if (((2481 + 2259) >= (2861 + 291)) and v64.Consumption:IsCastable()) then
					if (v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption)) or ((1869 + 709) >= (5162 - 1772))) then
						return "consumption standard 10";
					end
				end
				v98 = 2 + 0;
			end
			if (((708 - (89 + 578)) <= (1187 + 474)) and ((0 - 0) == v98)) then
				if (((1650 - (572 + 477)) < (481 + 3079)) and v28 and v64.Tombstone:IsCastable() and (v13:BuffStack(v64.BoneShieldBuff) > (4 + 1)) and (v13:Rune() >= (1 + 1)) and (v13:RunicPowerDeficit() >= (116 - (84 + 2))) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff))) and (v64.DancingRuneWeapon:CooldownRemains() >= (41 - 16))) then
					if (((170 + 65) < (1529 - (497 + 345))) and v19(v64.Tombstone)) then
						return "tombstone standard 2";
					end
				end
				v70 = 1 + 9 + (v74 * v21(v64.Heartbreaker:IsAvailable()) * (1 + 1));
				if (((5882 - (605 + 728)) > (823 + 330)) and v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (22 - 12)))) then
					if (v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(1 + 4)) or ((17280 - 12606) < (4212 + 460))) then
						return "death_strike standard 4";
					end
				end
				v98 = 2 - 1;
			end
		end
	end
	local function v89()
		local v99 = 0 + 0;
		while true do
			if (((4157 - (457 + 32)) < (1936 + 2625)) and (v99 == (1403 - (832 + 570)))) then
				v73 = v13:GetEnemiesInMeleeRange(5 + 0);
				v63 = v13:GetEnemiesInMeleeRange(3 + 7);
				if (v27 or ((1610 - 1155) == (1737 + 1868))) then
					v74 = ((#v73 > (796 - (588 + 208))) and #v73) or (2 - 1);
				else
					local v132 = 1800 - (884 + 916);
					while true do
						if (((0 - 0) == v132) or ((1545 + 1118) == (3965 - (232 + 421)))) then
							v74 = 1890 - (1569 + 320);
							v63 = 1 + 0;
							break;
						end
					end
				end
				v75 = v23(v74, (v13:BuffUp(v64.DeathAndDecayBuff) and (1 + 4)) or (6 - 4));
				v99 = 607 - (316 + 289);
			end
			if (((11195 - 6918) <= (207 + 4268)) and (v99 == (1455 - (666 + 787)))) then
				v76 = v80(v73);
				v72 = v13:IsTankingAoE(433 - (360 + 65)) or v13:IsTanking(v14);
				if (v78.TargetIsValid() or ((814 + 56) == (1443 - (79 + 175)))) then
					if (((2448 - 895) <= (2445 + 688)) and not v13:AffectingCombat()) then
						local v134 = 0 - 0;
						local v135;
						while true do
							if ((v134 == (0 - 0)) or ((3136 - (503 + 396)) >= (3692 - (92 + 89)))) then
								v135 = v83();
								if (v135 or ((2568 - 1244) > (1549 + 1471))) then
									return v135;
								end
								break;
							end
						end
					end
					if (v72 or ((1771 + 1221) == (7366 - 5485))) then
						local v136 = 0 + 0;
						local v137;
						while true do
							if (((7081 - 3975) > (1332 + 194)) and (v136 == (0 + 0))) then
								v137 = v84();
								if (((9206 - 6183) < (484 + 3386)) and v137) then
									return v137;
								end
								break;
							end
						end
					end
					if (((217 - 74) > (1318 - (485 + 759))) and v13:IsChanneling(v64.Blooddrinker) and v13:BuffUp(v64.BoneShieldBuff) and (v76 == (0 - 0)) and not v13:ShouldStopCasting() and (v13:CastRemains() > (1189.2 - (442 + 747)))) then
						if (((1153 - (832 + 303)) < (3058 - (88 + 858))) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
							return "Pool During Blooddrinker";
						end
					end
					v68 = v61;
					if (((335 + 762) <= (1348 + 280)) and v30) then
						local v138 = v85();
						if (((191 + 4439) == (5419 - (766 + 23))) and v138) then
							return v138;
						end
					end
					if (((17476 - 13936) > (3668 - 985)) and v28 and v64.RaiseDead:IsCastable()) then
						if (((12630 - 7836) >= (11115 - 7840)) and v19(v64.RaiseDead, nil)) then
							return "raise_dead main 4";
						end
					end
					if (((2557 - (1036 + 37)) == (1053 + 431)) and v64.VampiricBlood:IsCastable() and v13:BuffDown(v64.VampiricBloodBuff) and v13:BuffDown(v64.VampiricStrengthBuff)) then
						if (((2788 - 1356) < (2797 + 758)) and v19(v64.VampiricBlood, v56)) then
							return "vampiric_blood main 5";
						end
					end
					if ((v64.DeathsCaress:IsReady() and (v13:BuffDown(v64.BoneShieldBuff))) or ((2545 - (641 + 839)) > (4491 - (910 + 3)))) then
						if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((12223 - 7428) < (3091 - (1466 + 218)))) then
							return "deaths_caress main 6";
						end
					end
					if (((852 + 1001) < (5961 - (556 + 592))) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.UnholyGround:IsAvailable() or v64.SanguineGround:IsAvailable() or (v74 > (2 + 1)) or v13:BuffUp(v64.CrimsonScourgeBuff))) then
						if (v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(838 - (329 + 479))) or ((3675 - (174 + 680)) < (8353 - 5922))) then
							return "death_and_decay main 8";
						end
					end
					if ((v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (20 - 10)))) or ((2052 + 822) < (2920 - (396 + 343)))) then
						if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((238 + 2451) <= (1820 - (29 + 1448)))) then
							return "death_strike main 10";
						end
					end
					if ((v64.Blooddrinker:IsReady() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) or ((3258 - (135 + 1254)) == (7568 - 5559))) then
						if (v19(v64.Blooddrinker, nil, nil, not v14:IsSpellInRange(v64.Blooddrinker)) or ((16556 - 13010) < (1548 + 774))) then
							return "blooddrinker main 12";
						end
					end
					if (v28 or ((3609 - (389 + 1138)) == (5347 - (102 + 472)))) then
						local v139 = 0 + 0;
						local v140;
						while true do
							if (((1799 + 1445) > (984 + 71)) and (v139 == (1545 - (320 + 1225)))) then
								v140 = v86();
								if (v140 or ((5897 - 2584) <= (1088 + 690))) then
									return v140;
								end
								break;
							end
						end
					end
					if ((v28 and v64.SacrificialPact:IsReady() and v77.GhoulActive() and v13:BuffDown(v64.DancingRuneWeaponBuff) and ((v77.GhoulRemains() < (1466 - (157 + 1307))) or (v14:TimeToDie() < v13:GCD()))) or ((3280 - (821 + 1038)) >= (5249 - 3145))) then
						if (((199 + 1613) <= (5770 - 2521)) and v19(v64.SacrificialPact, v47)) then
							return "sacrificial_pact main 14";
						end
					end
					if (((604 + 1019) <= (4850 - 2893)) and v28 and v64.BloodTap:IsCastable() and (((v13:Rune() <= (1028 - (834 + 192))) and (v13:RuneTimeToX(1 + 3) > v13:GCD()) and (v64.BloodTap:ChargesFractional() >= (1.8 + 0))) or (v13:RuneTimeToX(1 + 2) > v13:GCD()))) then
						if (((6834 - 2422) == (4716 - (300 + 4))) and v19(v64.BloodTap, v57)) then
							return "blood_tap main 16";
						end
					end
					if (((468 + 1282) >= (2203 - 1361)) and v28 and v64.GorefiendsGrasp:IsCastable() and (v64.TighteningGrasp:IsAvailable())) then
						if (((4734 - (112 + 250)) > (738 + 1112)) and v19(v64.GorefiendsGrasp, nil, not v14:IsSpellInRange(v64.GorefiendsGrasp))) then
							return "gorefiends_grasp main 18";
						end
					end
					if (((580 - 348) < (471 + 350)) and v28 and v64.EmpowerRuneWeapon:IsReady() and (v13:Rune() < (4 + 2)) and (v13:RunicPowerDeficit() > (4 + 1))) then
						if (((257 + 261) < (671 + 231)) and v19(v64.EmpowerRuneWeapon)) then
							return "empower_rune_weapon main 20";
						end
					end
					if (((4408 - (1001 + 413)) > (1913 - 1055)) and v28 and v64.AbominationLimb:IsCastable()) then
						if (v19(v64.AbominationLimb, nil, not v14:IsInRange(902 - (244 + 638))) or ((4448 - (627 + 66)) <= (2726 - 1811))) then
							return "abomination_limb main 22";
						end
					end
					if (((4548 - (512 + 90)) > (5649 - (1665 + 241))) and v28 and v64.DancingRuneWeapon:IsCastable() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) then
						if (v19(v64.DancingRuneWeapon, v52) or ((2052 - (373 + 344)) >= (1492 + 1814))) then
							return "dancing_rune_weapon main 24";
						end
					end
					if (((1282 + 3562) > (5942 - 3689)) and (v13:BuffUp(v64.DancingRuneWeaponBuff))) then
						local v141 = 0 - 0;
						local v142;
						while true do
							if (((1551 - (35 + 1064)) == (329 + 123)) and (v141 == (0 - 0))) then
								v142 = v87();
								if (v142 or ((19 + 4538) < (3323 - (298 + 938)))) then
									return v142;
								end
								v141 = 1260 - (233 + 1026);
							end
							if (((5540 - (636 + 1030)) == (1981 + 1893)) and (v141 == (1 + 0))) then
								if (v9.CastAnnotated(v64.Pool, false, "WAIT") or ((576 + 1362) > (334 + 4601))) then
									return "Wait/Pool for DRWUp";
								end
								break;
							end
						end
					end
					local v133 = v88();
					if (v133 or ((4476 - (55 + 166)) < (664 + 2759))) then
						return v133;
					end
					if (((147 + 1307) <= (9513 - 7022)) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v99 == (297 - (36 + 261))) or ((7269 - 3112) <= (4171 - (34 + 1334)))) then
				v62();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v99 = 1 + 0;
			end
		end
	end
	local function v90()
		local v100 = 0 + 0;
		while true do
			if (((6136 - (1035 + 248)) >= (3003 - (20 + 1))) and (v100 == (0 + 0))) then
				v64.MarkofFyralathDebuff:RegisterAuraTracking();
				v9.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(569 - (134 + 185), v89, v90);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

