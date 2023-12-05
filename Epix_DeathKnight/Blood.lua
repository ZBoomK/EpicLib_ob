local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1849 - 801) >= (9 + 43)) and not v5) then
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
			if (((4571 - (1565 + 48)) < (2782 + 1721)) and (v91 == (1140 - (782 + 356)))) then
				v42 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v43 = EpicSettings.Settings['AntiMagicShellGCD'];
				v44 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v45 = EpicSettings.Settings['DeathAndDecayGCD'];
				v46 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v47 = EpicSettings.Settings['SacrificialPactGCD'];
				v91 = 270 - (176 + 91);
			end
			if ((v91 == (0 - 0)) or ((4030 - 1295) == (2401 - (975 + 117)))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (1875 - (157 + 1718));
				v33 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v91 = 3 - 2;
			end
			if ((v91 == (1021 - (697 + 321))) or ((11250 - 7120) <= (6260 - 3305))) then
				v48 = EpicSettings.Settings['MindFreezeOffGCD'];
				v49 = EpicSettings.Settings['RacialsOffGCD'];
				v50 = EpicSettings.Settings['BonestormGCD'];
				v51 = EpicSettings.Settings['ChainsOfIceGCD'];
				v52 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v53 = EpicSettings.Settings['DeathStrikeGCD'];
				v91 = 8 - 4;
			end
			if (((2 + 2) == v91) or ((3679 - 1715) <= (3592 - 2252))) then
				v54 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v55 = EpicSettings.Settings['TombstoneGCD'];
				v56 = EpicSettings.Settings['VampiricBloodGCD'];
				v57 = EpicSettings.Settings['BloodTapOffGCD'];
				v58 = EpicSettings.Settings['RuneTapOffGCD'];
				v59 = EpicSettings.Settings['RuneTapThreshold'];
				v91 = 1232 - (322 + 905);
			end
			if (((3110 - (602 + 9)) == (3688 - (449 + 740))) and (v91 == (873 - (826 + 46)))) then
				v36 = EpicSettings.Settings['InterruptWithStun'] or (947 - (245 + 702));
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v30 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseDeathStrikeHP'];
				v41 = EpicSettings.Settings['UseDarkSuccorHP'];
				v91 = 1900 - (260 + 1638);
			end
			if ((v91 == (445 - (382 + 58))) or ((7234 - 4979) < (19 + 3))) then
				v60 = EpicSettings.Settings['VampiricBloodThreshold'];
				v61 = EpicSettings.Settings['DeathStrikeDumpAmount'];
				break;
			end
		end
	end
	local v63;
	local v64 = v15.DeathKnight.Blood;
	local v65 = v17.DeathKnight.Blood;
	local v66 = v20.DeathKnight.Blood;
	local v67 = {v65.Fyralath:ID()};
	local v68 = 192 - 127;
	local v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (1209 - (902 + 303))) or (10 - 5);
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
		v69 = ((not v64.DeathsCaress:IsAvailable() or v64.Consumption:IsAvailable() or v64.Blooddrinker:IsAvailable()) and (10 - 6)) or (6 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v80(v92)
		local v93 = 765 - (468 + 297);
		local v94;
		while true do
			if (((563 - (334 + 228)) == v93) or ((3662 - 2576) >= (3256 - 1851))) then
				return v94;
			end
			if ((v93 == (0 - 0)) or ((673 + 1696) == (662 - (141 + 95)))) then
				v94 = 0 + 0;
				for v131, v132 in pairs(v92) do
					if (not v132:DebuffUp(v64.BloodPlagueDebuff) or ((7917 - 4841) > (7651 - 4468))) then
						v94 = v94 + 1 + 0;
					end
				end
				v93 = 2 - 1;
			end
		end
	end
	local function v81(v95)
		return (v95:DebuffRemains(v64.SoulReaperDebuff));
	end
	local function v82(v96)
		return ((v96:TimeToX(25 + 10) < (3 + 2)) or (v96:HealthPercentage() <= (49 - 14))) and (v96:TimeToDie() > (v96:DebuffRemains(v64.SoulReaperDebuff) + 3 + 2));
	end
	local function v83()
		local v97 = 163 - (92 + 71);
		while true do
			if (((594 + 608) > (1778 - 720)) and (v97 == (765 - (574 + 191)))) then
				if (((3062 + 649) > (8405 - 5050)) and v64.DeathsCaress:IsReady()) then
					if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((463 + 443) >= (3078 - (254 + 595)))) then
						return "deaths_caress precombat 4";
					end
				end
				if (((1414 - (55 + 71)) > (1647 - 396)) and v64.Marrowrend:IsReady()) then
					if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(1795 - (573 + 1217))) or ((12498 - 7985) < (256 + 3096))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v84()
		local v98 = 0 - 0;
		while true do
			if (((941 - (714 + 225)) == v98) or ((6034 - 3969) >= (4454 - 1258))) then
				if ((v64.DeathStrike:IsReady() and (v13:HealthPercentage() <= (6 + 44 + (((v13:RunicPower() > v68) and (28 - 8)) or (806 - (118 + 688))))) and not v13:HealingAbsorbed()) or ((4424 - (25 + 23)) <= (287 + 1194))) then
					if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((5278 - (927 + 959)) >= (15981 - 11240))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((4057 - (16 + 716)) >= (4157 - 2003)) and (v98 == (97 - (11 + 86)))) then
				if ((v64.RuneTap:IsReady() and v72 and (v13:HealthPercentage() <= v59) and (v13:Rune() >= (6 - 3)) and (v64.RuneTap:Charges() >= (286 - (175 + 110))) and v13:BuffDown(v64.RuneTapBuff)) or ((3269 - 1974) >= (15945 - 12712))) then
					if (((6173 - (503 + 1293)) > (4585 - 2943)) and v19(v64.RuneTap, v58)) then
						return "rune_tap defensives 2";
					end
				end
				if (((3416 + 1307) > (2417 - (810 + 251))) and v13:ActiveMitigationNeeded() and (v64.Marrowrend:TimeSinceLastCast() > (2.5 + 0)) and (v64.DeathStrike:TimeSinceLastCast() > (1.5 + 1))) then
					local v133 = 0 + 0;
					while true do
						if ((v133 == (533 - (43 + 490))) or ((4869 - (711 + 22)) <= (13279 - 9846))) then
							if (((5104 - (240 + 619)) <= (1118 + 3513)) and v64.DeathStrike:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (10 - 3))) then
								if (((283 + 3993) >= (5658 - (1344 + 400))) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (((603 - (255 + 150)) <= (3439 + 926)) and v64.Marrowrend:IsReady()) then
								if (((2561 + 2221) > (19978 - 15302)) and v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(16 - 11))) then
									return "marrowrend defensives 6";
								end
							end
							v133 = 1740 - (404 + 1335);
						end
						if (((5270 - (183 + 223)) > (2673 - 476)) and (v133 == (1 + 0))) then
							if (v64.DeathStrike:IsReady() or ((1332 + 2368) == (2844 - (10 + 327)))) then
								if (((3116 + 1358) >= (612 - (118 + 220))) and v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
					end
				end
				v98 = 1 + 0;
			end
			if ((v98 == (450 - (108 + 341))) or ((851 + 1043) <= (5944 - 4538))) then
				if (((3065 - (711 + 782)) >= (2934 - 1403)) and v64.VampiricBlood:IsCastable() and v72 and (v13:HealthPercentage() <= v60) and v13:BuffDown(v64.IceboundFortitudeBuff)) then
					if (v19(v64.VampiricBlood, v56) or ((5156 - (270 + 199)) < (1473 + 3069))) then
						return "vampiric_blood defensives 14";
					end
				end
				if (((5110 - (580 + 1239)) > (4955 - 3288)) and v64.IceboundFortitude:IsCastable() and v72 and (v13:HealthPercentage() <= IceboundFortitudeThreshold) and v13:BuffDown(v64.VampiricBloodBuff)) then
					if (v19(v64.IceboundFortitude, v54) or ((835 + 38) == (74 + 1960))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v98 = 1 + 1;
			end
		end
	end
	local function v85()
	end
	local function v86()
		local v99 = 0 - 0;
		while true do
			if ((v99 == (0 + 0)) or ((3983 - (645 + 522)) < (1801 - (1010 + 780)))) then
				if (((3698 + 1) < (22418 - 17712)) and v64.BloodFury:IsCastable() and v64.DancingRuneWeapon:CooldownUp() and (not v64.Blooddrinker:IsReady() or not v64.Blooddrinker:IsAvailable())) then
					if (((7753 - 5107) >= (2712 - (1045 + 791))) and v19(v64.BloodFury, v49)) then
						return "blood_fury racials 2";
					end
				end
				if (((1553 - 939) <= (4861 - 1677)) and v64.Berserking:IsCastable()) then
					if (((3631 - (351 + 154)) == (4700 - (1281 + 293))) and v19(v64.Berserking, v49)) then
						return "berserking racials 4";
					end
				end
				v99 = 267 - (28 + 238);
			end
			if ((v99 == (2 - 1)) or ((3746 - (1381 + 178)) >= (4647 + 307))) then
				if ((v64.ArcanePulse:IsCastable() and ((v74 >= (2 + 0)) or ((v13:Rune() < (1 + 0)) and (v13:RunicPowerDeficit() > (206 - 146))))) or ((2009 + 1868) == (4045 - (381 + 89)))) then
					if (((627 + 80) > (428 + 204)) and v19(v64.ArcanePulse, v49, nil, not v14:IsInRange(13 - 5))) then
						return "arcane_pulse racials 6";
					end
				end
				if ((v64.LightsJudgment:IsCastable() and (v13:BuffUp(v64.UnholyStrengthBuff))) or ((1702 - (1074 + 82)) >= (5881 - 3197))) then
					if (((3249 - (214 + 1570)) <= (5756 - (990 + 465))) and v19(v64.LightsJudgment, v49, nil, not v14:IsSpellInRange(v64.LightsJudgment))) then
						return "lights_judgment racials 8";
					end
				end
				v99 = 1 + 1;
			end
			if (((742 + 962) > (1386 + 39)) and (v99 == (11 - 8))) then
				if (v64.BagofTricks:IsCastable() or ((2413 - (1668 + 58)) == (4860 - (512 + 114)))) then
					if (v19(v64.BagofTricks, v49, nil, not v14:IsSpellInRange(v64.BagofTricks)) or ((8681 - 5351) < (2953 - 1524))) then
						return "bag_of_tricks racials 14";
					end
				end
				if (((3991 - 2844) >= (156 + 179)) and v64.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (4 + 16))) then
					if (((2987 + 448) > (7072 - 4975)) and v19(v64.ArcaneTorrent, v49, nil, not v14:IsInRange(2002 - (109 + 1885)))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if ((v99 == (1471 - (1269 + 200))) or ((7225 - 3455) >= (4856 - (98 + 717)))) then
				if (v64.AncestralCall:IsCastable() or ((4617 - (802 + 24)) <= (2777 - 1166))) then
					if (v19(v64.AncestralCall, v49) or ((5781 - 1203) <= (297 + 1711))) then
						return "ancestral_call racials 10";
					end
				end
				if (((865 + 260) <= (341 + 1735)) and v64.Fireblood:IsCastable()) then
					if (v19(v64.Fireblood, v49) or ((161 + 582) >= (12237 - 7838))) then
						return "fireblood racials 12";
					end
				end
				v99 = 9 - 6;
			end
		end
	end
	local function v87()
		local v100 = 0 + 0;
		while true do
			if (((471 + 684) < (1380 + 293)) and (v100 == (1 + 0))) then
				if ((v64.SoulReaper:IsReady() and (v74 == (1 + 0)) and ((v14:TimeToX(1468 - (797 + 636)) < (24 - 19)) or (v14:HealthPercentage() <= (1654 - (1427 + 192)))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + 2 + 3))) or ((5395 - 3071) <= (520 + 58))) then
					if (((1708 + 2059) == (4093 - (192 + 134))) and v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(1281 - (316 + 960)))) then
						return "soul_reaper drw_up 12";
					end
				end
				if (((2276 + 1813) == (3156 + 933)) and v64.SoulReaper:IsReady() and (v74 >= (2 + 0))) then
					if (((17042 - 12584) >= (2225 - (83 + 468))) and v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(1811 - (1202 + 604)))) then
						return "soul_reaper drw_up 14";
					end
				end
				if (((4537 - 3565) <= (2359 - 941)) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.SanguineGround:IsAvailable() or v64.UnholyGround:IsAvailable())) then
					if (v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(83 - 53)) or ((5263 - (45 + 280)) < (4597 + 165))) then
						return "death_and_decay drw_up 16";
					end
				end
				if ((v64.BloodBoil:IsCastable() and (v74 > (2 + 0)) and (v64.BloodBoil:ChargesFractional() >= (1.1 + 0))) or ((1386 + 1118) > (750 + 3514))) then
					if (((3986 - 1833) == (4064 - (340 + 1571))) and v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(4 + 6))) then
						return "blood_boil drw_up 18";
					end
				end
				v100 = 1774 - (1733 + 39);
			end
			if ((v100 == (5 - 3)) or ((1541 - (125 + 909)) >= (4539 - (1096 + 852)))) then
				v71 = 12 + 13 + (v75 * v21(v64.Heartbreaker:IsAvailable()) * (2 - 0));
				if (((4347 + 134) == (4993 - (409 + 103))) and v64.DeathStrike:IsReady() and ((v13:RunicPowerDeficit() <= v71) or (v13:RunicPower() >= v68))) then
					if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((2564 - (46 + 190)) < (788 - (51 + 44)))) then
						return "death_strike drw_up 20";
					end
				end
				if (((1221 + 3107) == (5645 - (1114 + 203))) and v64.Consumption:IsCastable()) then
					if (((2314 - (228 + 498)) >= (289 + 1043)) and v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v64.BloodBoil:IsReady() and (v64.BloodBoil:ChargesFractional() >= (1.1 + 0)) and (v13:BuffStack(v64.HemostasisBuff) < (668 - (174 + 489)))) or ((10874 - 6700) > (6153 - (830 + 1075)))) then
					if (v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(534 - (303 + 221))) or ((5855 - (231 + 1038)) <= (69 + 13))) then
						return "blood_boil drw_up 24";
					end
				end
				v100 = 1165 - (171 + 991);
			end
			if (((15920 - 12057) == (10372 - 6509)) and (v100 == (7 - 4))) then
				if ((v64.HeartStrike:IsReady() and ((v13:RuneTimeToX(2 + 0) < v13:GCD()) or (v13:RunicPowerDeficit() >= v71))) or ((988 - 706) <= (120 - 78))) then
					if (((7428 - 2819) >= (2367 - 1601)) and v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if ((v100 == (1248 - (111 + 1137))) or ((1310 - (91 + 67)) == (7404 - 4916))) then
				if (((854 + 2568) > (3873 - (423 + 100))) and v64.BloodBoil:IsReady() and (v14:DebuffDown(v64.BloodPlagueDebuff))) then
					if (((7 + 870) > (1040 - 664)) and v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(6 + 4))) then
						return "blood_boil drw_up 2";
					end
				end
				if ((v64.Tombstone:IsReady() and (v13:BuffStack(v64.BoneShieldBuff) > (776 - (326 + 445))) and (v13:Rune() >= (8 - 6)) and (v13:RunicPowerDeficit() >= (66 - 36)) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff)))) or ((7277 - 4159) <= (2562 - (530 + 181)))) then
					if (v19(v64.Tombstone) or ((1046 - (614 + 267)) >= (3524 - (19 + 13)))) then
						return "tombstone drw_up 4";
					end
				end
				if (((6426 - 2477) < (11315 - 6459)) and v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()))) then
					if (v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(14 - 9)) or ((1111 + 3165) < (5303 - 2287))) then
						return "death_strike drw_up 6";
					end
				end
				if (((9726 - 5036) > (5937 - (1293 + 519))) and v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (7 - 3)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (52 - 32))) then
					if (v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(9 - 4)) or ((215 - 165) >= (2110 - 1214))) then
						return "marrowrend drw_up 10";
					end
				end
				v100 = 1 + 0;
			end
		end
	end
	local function v88()
		if ((v28 and v64.Tombstone:IsCastable() and (v13:BuffStack(v64.BoneShieldBuff) > (2 + 3)) and (v13:Rune() >= (4 - 2)) and (v13:RunicPowerDeficit() >= (7 + 23)) and (not v64.ShatteringBone:IsAvailable() or (v64.ShatteringBone:IsAvailable() and v13:BuffUp(v64.DeathAndDecayBuff))) and (v64.DancingRuneWeapon:CooldownRemains() >= (9 + 16))) or ((1072 + 642) >= (4054 - (709 + 387)))) then
			if (v19(v64.Tombstone) or ((3349 - (673 + 1185)) < (1867 - 1223))) then
				return "tombstone standard 2";
			end
		end
		v70 = (32 - 22) + (v74 * v21(v64.Heartbreaker:IsAvailable()) * (2 - 0));
		if (((504 + 200) < (738 + 249)) and v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (13 - 3)))) then
			if (((914 + 2804) > (3800 - 1894)) and v19(v64.DeathStrike, v53, nil, not v14:IsInMeleeRange(9 - 4))) then
				return "death_strike standard 4";
			end
		end
		if ((v64.DeathsCaress:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (1884 - (446 + 1434))) or (v13:BuffStack(v64.BoneShieldBuff) < (v69 + (1284 - (1040 + 243))))) and (v13:RunicPowerDeficit() > (29 - 19)) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff))) and not v64.Consumption:IsAvailable() and not v64.Blooddrinker:IsAvailable() and (v13:RuneTimeToX(1850 - (559 + 1288)) > v13:GCD())) or ((2889 - (609 + 1322)) > (4089 - (13 + 441)))) then
			if (((13082 - 9581) <= (11766 - 7274)) and v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress))) then
				return "deaths_caress standard 6";
			end
		end
		if ((v64.Marrowrend:IsReady() and ((v13:BuffRemains(v64.BoneShieldBuff) <= (19 - 15)) or (v13:BuffStack(v64.BoneShieldBuff) < v69)) and (v13:RunicPowerDeficit() > (1 + 19)) and not (v64.InsatiableBlade:IsAvailable() and (v64.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v64.BoneShieldBuff)))) or ((12500 - 9058) < (905 + 1643))) then
			if (((1260 + 1615) >= (4344 - 2880)) and v19(v64.Marrowrend, nil, nil, not v14:IsInMeleeRange(3 + 2))) then
				return "marrowrend standard 8";
			end
		end
		if (v64.Consumption:IsCastable() or ((8822 - 4025) >= (3235 + 1658))) then
			if (v19(v64.Consumption, nil, not v14:IsSpellInRange(v64.Consumption)) or ((307 + 244) > (1486 + 582))) then
				return "consumption standard 10";
			end
		end
		if (((1776 + 338) > (924 + 20)) and v64.SoulReaper:IsReady() and (v74 == (434 - (153 + 280))) and ((v14:TimeToX(101 - 66) < (5 + 0)) or (v14:HealthPercentage() <= (14 + 21))) and (v14:TimeToDie() > (v14:DebuffRemains(v64.SoulReaperDebuff) + 3 + 2))) then
			if (v19(v64.SoulReaper, nil, nil, not v14:IsInMeleeRange(5 + 0)) or ((1640 + 622) >= (4713 - 1617))) then
				return "soul_reaper standard 12";
			end
		end
		if ((v64.SoulReaper:IsReady() and (v74 >= (2 + 0))) or ((2922 - (89 + 578)) >= (2527 + 1010))) then
			if (v78.CastTargetIf(v64.SoulReaper, v73, "min", v81, v82, not v14:IsInMeleeRange(10 - 5)) or ((4886 - (572 + 477)) < (177 + 1129))) then
				return "soul_reaper standard 14";
			end
		end
		if (((1771 + 1179) == (353 + 2597)) and v28 and v64.Bonestorm:IsReady() and (v13:RunicPower() >= (136 - (84 + 2)))) then
			if (v19(v64.Bonestorm) or ((7783 - 3060) < (2376 + 922))) then
				return "bonestorm standard 16";
			end
		end
		if (((1978 - (497 + 345)) >= (4 + 150)) and v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v13:BuffStack(v64.HemostasisBuff) <= ((1338 - (605 + 728)) - v74)) or (v74 > (2 + 0)))) then
			if (v19(v64.BloodBoil, nil, not v14:IsInMeleeRange(22 - 12)) or ((13 + 258) > (17554 - 12806))) then
				return "blood_boil standard 18";
			end
		end
		if (((4274 + 466) >= (8732 - 5580)) and v64.HeartStrike:IsReady() and (v13:RuneTimeToX(4 + 0) < v13:GCD())) then
			if (v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike)) or ((3067 - (457 + 32)) >= (1439 + 1951))) then
				return "heart_strike standard 20";
			end
		end
		if (((1443 - (832 + 570)) <= (1565 + 96)) and v64.BloodBoil:IsCastable() and (v64.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
			if (((2126 - 1525) < (1715 + 1845)) and v19(v64.BloodBoil, nil, nil, not v14:IsInMeleeRange(806 - (588 + 208)))) then
				return "blood_boil standard 22";
			end
		end
		if (((633 - 398) < (2487 - (884 + 916))) and v64.HeartStrike:IsReady() and (v13:Rune() > (1 - 0)) and ((v13:RuneTimeToX(2 + 1) < v13:GCD()) or (v13:BuffStack(v64.BoneShieldBuff) > (660 - (232 + 421))))) then
			if (((6438 - (1569 + 320)) > (283 + 870)) and v19(v64.HeartStrike, nil, nil, not v14:IsSpellInRange(v64.HeartStrike))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v89()
		local v101 = 0 + 0;
		while true do
			if ((v101 == (3 - 2)) or ((5279 - (316 + 289)) < (12229 - 7557))) then
				v28 = EpicSettings.Toggles['cds'];
				v73 = v13:GetEnemiesInMeleeRange(1 + 4);
				v63 = v13:GetEnemiesInMeleeRange(1463 - (666 + 787));
				v101 = 427 - (360 + 65);
			end
			if (((3428 + 240) < (4815 - (79 + 175))) and (v101 == (0 - 0))) then
				v62();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v101 = 1 + 0;
			end
			if ((v101 == (5 - 3)) or ((876 - 421) == (4504 - (503 + 396)))) then
				if (v27 or ((2844 - (92 + 89)) == (6424 - 3112))) then
					v74 = ((#v73 > (0 + 0)) and #v73) or (1 + 0);
				else
					v74 = 3 - 2;
					v63 = 1 + 0;
				end
				v75 = v23(v74, (v13:BuffUp(v64.DeathAndDecayBuff) and (11 - 6)) or (2 + 0));
				v76 = v80(v73);
				v101 = 2 + 1;
			end
			if (((13026 - 8749) <= (559 + 3916)) and (v101 == (4 - 1))) then
				v72 = v13:IsTankingAoE(1252 - (485 + 759)) or v13:IsTanking(v14);
				if (v78.TargetIsValid() or ((2013 - 1143) == (2378 - (442 + 747)))) then
					if (((2688 - (832 + 303)) <= (4079 - (88 + 858))) and not v13:AffectingCombat()) then
						local v135 = 0 + 0;
						local v136;
						while true do
							if ((v135 == (0 + 0)) or ((93 + 2144) >= (4300 - (766 + 23)))) then
								v136 = v83();
								if (v136 or ((6536 - 5212) > (4130 - 1110))) then
									return v136;
								end
								break;
							end
						end
					end
					if (v72 or ((7882 - 4890) == (6384 - 4503))) then
						local v137 = 1073 - (1036 + 37);
						local v138;
						while true do
							if (((2203 + 903) > (2971 - 1445)) and (v137 == (0 + 0))) then
								v138 = v84();
								if (((4503 - (641 + 839)) < (4783 - (910 + 3))) and v138) then
									return v138;
								end
								break;
							end
						end
					end
					if (((364 - 221) > (1758 - (1466 + 218))) and v13:IsChanneling(v64.Blooddrinker) and v13:BuffUp(v64.BoneShieldBuff) and (v76 == (0 + 0)) and not v13:ShouldStopCasting() and (v13:CastRemains() > (1148.2 - (556 + 592)))) then
						if (((7 + 11) < (2920 - (329 + 479))) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
							return "Pool During Blooddrinker";
						end
					end
					v68 = v61;
					if (((1951 - (174 + 680)) <= (5593 - 3965)) and v30) then
						local v139 = v85();
						if (((9596 - 4966) == (3306 + 1324)) and v139) then
							return v139;
						end
					end
					if (((4279 - (396 + 343)) > (238 + 2445)) and v28 and v64.RaiseDead:IsCastable()) then
						if (((6271 - (29 + 1448)) >= (4664 - (135 + 1254))) and v19(v64.RaiseDead, nil)) then
							return "raise_dead main 4";
						end
					end
					if (((5590 - 4106) == (6928 - 5444)) and v64.VampiricBlood:IsCastable() and v13:BuffDown(v64.VampiricBloodBuff) and v13:BuffDown(v64.VampiricStrengthBuff)) then
						if (((955 + 477) < (5082 - (389 + 1138))) and v19(v64.VampiricBlood, v56)) then
							return "vampiric_blood main 5";
						end
					end
					if ((v64.DeathsCaress:IsReady() and (v13:BuffDown(v64.BoneShieldBuff))) or ((1639 - (102 + 472)) > (3377 + 201))) then
						if (v19(v64.DeathsCaress, nil, nil, not v14:IsSpellInRange(v64.DeathsCaress)) or ((2659 + 2136) < (1312 + 95))) then
							return "deaths_caress main 6";
						end
					end
					if (((3398 - (320 + 1225)) < (8567 - 3754)) and v64.DeathAndDecay:IsReady() and v13:BuffDown(v64.DeathAndDecayBuff) and (v64.UnholyGround:IsAvailable() or v64.SanguineGround:IsAvailable() or (v74 > (2 + 1)) or v13:BuffUp(v64.CrimsonScourgeBuff))) then
						if (v19(v66.DaDPlayer, v45, nil, not v14:IsInRange(1494 - (157 + 1307))) or ((4680 - (821 + 1038)) < (6065 - 3634))) then
							return "death_and_decay main 8";
						end
					end
					if ((v64.DeathStrike:IsReady() and ((v13:BuffRemains(v64.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v64.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v68) or (v13:RunicPowerDeficit() <= v70) or (v14:TimeToDie() < (2 + 8)))) or ((5104 - 2230) < (812 + 1369))) then
						if (v19(v64.DeathStrike, v53, nil, not v14:IsSpellInRange(v64.DeathStrike)) or ((6664 - 3975) <= (1369 - (834 + 192)))) then
							return "death_strike main 10";
						end
					end
					if ((v64.Blooddrinker:IsReady() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) or ((119 + 1750) == (516 + 1493))) then
						if (v19(v64.Blooddrinker, nil, nil, not v14:IsSpellInRange(v64.Blooddrinker)) or ((77 + 3469) < (3596 - 1274))) then
							return "blooddrinker main 12";
						end
					end
					if (v28 or ((2386 - (300 + 4)) == (1275 + 3498))) then
						local v140 = 0 - 0;
						local v141;
						while true do
							if (((3606 - (112 + 250)) > (421 + 634)) and (v140 == (0 - 0))) then
								v141 = v86();
								if (v141 or ((1898 + 1415) <= (920 + 858))) then
									return v141;
								end
								break;
							end
						end
					end
					if ((v28 and v64.SacrificialPact:IsReady() and v77.GhoulActive() and v13:BuffDown(v64.DancingRuneWeaponBuff) and ((v77.GhoulRemains() < (2 + 0)) or (v14:TimeToDie() < v13:GCD()))) or ((705 + 716) >= (1564 + 540))) then
						if (((3226 - (1001 + 413)) <= (7244 - 3995)) and v19(v64.SacrificialPact, v47)) then
							return "sacrificial_pact main 14";
						end
					end
					if (((2505 - (244 + 638)) <= (2650 - (627 + 66))) and v28 and v64.BloodTap:IsCastable() and (((v13:Rune() <= (5 - 3)) and (v13:RuneTimeToX(606 - (512 + 90)) > v13:GCD()) and (v64.BloodTap:ChargesFractional() >= (1907.8 - (1665 + 241)))) or (v13:RuneTimeToX(720 - (373 + 344)) > v13:GCD()))) then
						if (((1990 + 2422) == (1168 + 3244)) and v19(v64.BloodTap, v57)) then
							return "blood_tap main 16";
						end
					end
					if (((4616 - 2866) >= (1424 - 582)) and v28 and v64.GorefiendsGrasp:IsCastable() and (v64.TighteningGrasp:IsAvailable())) then
						if (((5471 - (35 + 1064)) > (1347 + 503)) and v19(v64.GorefiendsGrasp, nil, not v14:IsSpellInRange(v64.GorefiendsGrasp))) then
							return "gorefiends_grasp main 18";
						end
					end
					if (((496 - 264) < (4 + 817)) and v28 and v64.EmpowerRuneWeapon:IsCastable() and (v13:Rune() < (1242 - (298 + 938))) and (v13:RunicPowerDeficit() > (1264 - (233 + 1026)))) then
						if (((2184 - (636 + 1030)) < (462 + 440)) and v19(v64.EmpowerRuneWeapon, v46)) then
							return "empower_rune_weapon main 20";
						end
					end
					if (((2925 + 69) > (255 + 603)) and v28 and v64.AbominationLimb:IsCastable()) then
						if (v19(v64.AbominationLimb, nil, not v14:IsInRange(2 + 18)) or ((3976 - (55 + 166)) <= (178 + 737))) then
							return "abomination_limb main 22";
						end
					end
					if (((397 + 3549) > (14294 - 10551)) and v28 and v64.DancingRuneWeapon:IsCastable() and (v13:BuffDown(v64.DancingRuneWeaponBuff))) then
						if (v19(v64.DancingRuneWeapon, v52) or ((1632 - (36 + 261)) >= (5781 - 2475))) then
							return "dancing_rune_weapon main 24";
						end
					end
					if (((6212 - (34 + 1334)) > (867 + 1386)) and (v13:BuffUp(v64.DancingRuneWeaponBuff))) then
						local v142 = 0 + 0;
						local v143;
						while true do
							if (((1735 - (1035 + 248)) == (473 - (20 + 1))) and (v142 == (0 + 0))) then
								v143 = v87();
								if (v143 or ((4876 - (134 + 185)) < (3220 - (549 + 584)))) then
									return v143;
								end
								v142 = 686 - (314 + 371);
							end
							if (((13299 - 9425) == (4842 - (478 + 490))) and (v142 == (1 + 0))) then
								if (v9.CastAnnotated(v64.Pool, false, "WAIT") or ((3110 - (786 + 386)) > (15984 - 11049))) then
									return "Wait/Pool for DRWUp";
								end
								break;
							end
						end
					end
					local v134 = v88();
					if (v134 or ((5634 - (1055 + 324)) < (4763 - (1093 + 247)))) then
						return v134;
					end
					if (((1293 + 161) <= (262 + 2229)) and v9.CastAnnotated(v64.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
		end
	end
	local function v90()
		v64.MarkofFyralathDebuff:RegisterAuraTracking();
		v9.Print("Blood DK by Epic. Work in progress Gojira");
	end
	v9.SetAPL(992 - 742, v89, v90);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

