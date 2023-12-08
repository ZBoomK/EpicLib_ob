local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1052 - (433 + 619);
	local v6;
	while true do
		if ((v5 == (164 - (92 + 71))) or ((724 + 740) > (3698 - 1498))) then
			return v6(...);
		end
		if ((v5 == (765 - (574 + 191))) or ((1119 + 237) > (11832 - 7109))) then
			v6 = v0[v4];
			if (not v6 or ((2113 + 2023) <= (4282 - (254 + 595)))) then
				return v1(v4, ...);
			end
			v5 = 127 - (55 + 71);
		end
	end
end
v0["Epix_DeathKnight_Blood.lua"] = function(...)
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
	local function v64()
		local v93 = 0 - 0;
		while true do
			if (((6035 - (573 + 1217)) <= (12825 - 8194)) and (v93 == (1 + 4))) then
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'];
				break;
			end
			if (((6889 - 2613) >= (4853 - (714 + 225))) and (v93 == (5 - 3))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v93 = 3 - 0;
			end
			if (((22 + 176) <= (6319 - 1954)) and ((809 - (118 + 688)) == v93)) then
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = EpicSettings.Settings['DeathStrikeGCD'];
				v93 = 52 - (25 + 23);
			end
			if (((927 + 3855) > (6562 - (927 + 959))) and (v93 == (0 - 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (732 - (16 + 716));
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (97 - (11 + 86));
				v93 = 2 - 1;
			end
			if (((5149 - (175 + 110)) > (5546 - 3349)) and (v93 == (4 - 3))) then
				v37 = EpicSettings.Settings['InterruptWithStun'] or (1796 - (503 + 1293));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v93 = 1063 - (810 + 251);
			end
			if (((3 + 1) == v93) or ((1136 + 2564) == (2260 + 247))) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v63 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v93 = 538 - (43 + 490);
			end
		end
	end
	local v65;
	local v66 = v16.DeathKnight.Blood;
	local v67 = v18.DeathKnight.Blood;
	local v68 = v21.DeathKnight.Blood;
	local v69 = {v67.Fyralath:ID()};
	local v70 = 251 - 186;
	local v71 = ((not v66.DeathsCaress:IsAvailable() or v66.Consumption:IsAvailable() or v66.Blooddrinker:IsAvailable()) and (863 - (240 + 619))) or (2 + 3);
	local v72 = 0 - 0;
	local v73 = 0 + 0;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79 = v10.GhoulTable;
	local v80 = v10.Commons.Everyone;
	local v81 = {{v66.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v71 = ((not v66.DeathsCaress:IsAvailable() or v66.Consumption:IsAvailable() or v66.Blooddrinker:IsAvailable()) and (16 - 12)) or (16 - 11);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v82(v94)
		local v95 = 1739 - (404 + 1335);
		local v96;
		while true do
			if (((4880 - (183 + 223)) >= (332 - 58)) and ((0 + 0) == v95)) then
				v96 = 0 + 0;
				for v137, v138 in pairs(v94) do
					if (not v138:DebuffUp(v66.BloodPlagueDebuff) or ((2231 - (10 + 327)) <= (980 + 426))) then
						v96 = v96 + (339 - (118 + 220));
					end
				end
				v95 = 1 + 0;
			end
			if (((2021 - (108 + 341)) >= (688 + 843)) and (v95 == (4 - 3))) then
				return v96;
			end
		end
	end
	local function v83(v97)
		return (v97:DebuffRemains(v66.SoulReaperDebuff));
	end
	local function v84(v98)
		return ((v98:TimeToX(1528 - (711 + 782)) < (9 - 4)) or (v98:HealthPercentage() <= (504 - (270 + 199)))) and (v98:TimeToDie() > (v98:DebuffRemains(v66.SoulReaperDebuff) + 2 + 3));
	end
	local function v85()
		local v99 = 1819 - (580 + 1239);
		while true do
			if ((v99 == (0 - 0)) or ((4482 + 205) < (164 + 4378))) then
				if (((1434 + 1857) > (4352 - 2685)) and v66.DeathsCaress:IsReady()) then
					if (v20(v66.DeathsCaress, nil, nil, not v15:IsSpellInRange(v66.DeathsCaress)) or ((543 + 330) == (3201 - (645 + 522)))) then
						return "deaths_caress precombat 4";
					end
				end
				if (v66.Marrowrend:IsReady() or ((4606 - (1010 + 780)) < (11 + 0))) then
					if (((17621 - 13922) < (13790 - 9084)) and v20(v66.Marrowrend, nil, nil, not v15:IsInMeleeRange(1841 - (1045 + 791)))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v86()
		local v100 = 0 - 0;
		while true do
			if (((4039 - 1393) >= (1381 - (351 + 154))) and (v100 == (1575 - (1281 + 293)))) then
				if (((880 - (28 + 238)) <= (7114 - 3930)) and v66.VampiricBlood:IsCastable() and v74 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v66.IceboundFortitudeBuff)) then
					if (((4685 - (1381 + 178)) == (2932 + 194)) and v20(v66.VampiricBlood, v57)) then
						return "vampiric_blood defensives 14";
					end
				end
				if ((v66.IceboundFortitude:IsCastable() and v74 and (v14:HealthPercentage() <= v63) and v14:BuffDown(v66.VampiricBloodBuff)) or ((1764 + 423) >= (2114 + 2840))) then
					if (v20(v66.IceboundFortitude, v55) or ((13365 - 9488) == (1853 + 1722))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v100 = 472 - (381 + 89);
			end
			if (((627 + 80) > (428 + 204)) and (v100 == (0 - 0))) then
				if ((v66.RuneTap:IsReady() and v74 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (1159 - (1074 + 82))) and (v66.RuneTap:Charges() >= (1 - 0)) and v14:BuffDown(v66.RuneTapBuff)) or ((2330 - (214 + 1570)) >= (4139 - (990 + 465)))) then
					if (((604 + 861) <= (1872 + 2429)) and v20(v66.RuneTap, v59)) then
						return "rune_tap defensives 2";
					end
				end
				if (((1658 + 46) > (5607 - 4182)) and v14:ActiveMitigationNeeded() and (v66.Marrowrend:TimeSinceLastCast() > (1728.5 - (1668 + 58))) and (v66.DeathStrike:TimeSinceLastCast() > (628.5 - (512 + 114)))) then
					local v139 = 0 - 0;
					while true do
						if ((v139 == (1 - 0)) or ((2390 - 1703) == (1970 + 2264))) then
							if (v66.DeathStrike:IsReady() or ((624 + 2706) < (1243 + 186))) then
								if (((3868 - 2721) >= (2329 - (109 + 1885))) and v20(v66.DeathStrike, v54, nil, not v15:IsSpellInRange(v66.DeathStrike))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
						if (((4904 - (1269 + 200)) > (4019 - 1922)) and (v139 == (815 - (98 + 717)))) then
							if ((v66.DeathStrike:IsReady() and (v14:BuffStack(v66.BoneShieldBuff) > (833 - (802 + 24)))) or ((6501 - 2731) >= (5103 - 1062))) then
								if (v20(v66.DeathStrike, v54, nil, not v15:IsSpellInRange(v66.DeathStrike)) or ((560 + 3231) <= (1238 + 373))) then
									return "death_strike defensives 4";
								end
							end
							if (v66.Marrowrend:IsReady() or ((752 + 3826) <= (434 + 1574))) then
								if (((3129 - 2004) <= (6922 - 4846)) and v20(v66.Marrowrend, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
									return "marrowrend defensives 6";
								end
							end
							v139 = 1 + 0;
						end
					end
				end
				v100 = 1 + 0;
			end
			if ((v100 == (2 + 0)) or ((347 + 396) >= (5832 - (797 + 636)))) then
				if (((5607 - 4452) < (3292 - (1427 + 192))) and v66.DeathStrike:IsReady() and (v14:HealthPercentage() <= (18 + 32 + (((v14:RunicPower() > v70) and (46 - 26)) or (0 + 0)))) and not v14:HealingAbsorbed()) then
					if (v20(v66.DeathStrike, v54, nil, not v15:IsSpellInRange(v66.DeathStrike)) or ((1054 + 1270) <= (904 - (192 + 134)))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
		end
	end
	local function v87()
	end
	local function v88()
		local v101 = 1276 - (316 + 960);
		while true do
			if (((2097 + 1670) == (2908 + 859)) and (v101 == (1 + 0))) then
				if (((15632 - 11543) == (4640 - (83 + 468))) and v66.ArcanePulse:IsCastable() and ((v76 >= (1808 - (1202 + 604))) or ((v14:Rune() < (4 - 3)) and (v14:RunicPowerDeficit() > (99 - 39))))) then
					if (((12343 - 7885) >= (1999 - (45 + 280))) and v20(v66.ArcanePulse, nil, not v15:IsInRange(8 + 0))) then
						return "arcane_pulse racials 6";
					end
				end
				if (((850 + 122) <= (518 + 900)) and v66.LightsJudgment:IsCastable() and (v14:BuffUp(v66.UnholyStrengthBuff))) then
					if (v20(v66.LightsJudgment, nil, not v15:IsSpellInRange(v66.LightsJudgment)) or ((2733 + 2205) < (838 + 3924))) then
						return "lights_judgment racials 8";
					end
				end
				v101 = 3 - 1;
			end
			if ((v101 == (1911 - (340 + 1571))) or ((988 + 1516) > (6036 - (1733 + 39)))) then
				if (((5916 - 3763) == (3187 - (125 + 909))) and v66.BloodFury:IsCastable() and v66.DancingRuneWeapon:CooldownUp() and (not v66.Blooddrinker:IsReady() or not v66.Blooddrinker:IsAvailable())) then
					if (v20(v66.BloodFury) or ((2455 - (1096 + 852)) >= (1163 + 1428))) then
						return "blood_fury racials 2";
					end
				end
				if (((6399 - 1918) == (4347 + 134)) and v66.Berserking:IsCastable()) then
					if (v20(v66.Berserking) or ((2840 - (409 + 103)) < (929 - (46 + 190)))) then
						return "berserking racials 4";
					end
				end
				v101 = 96 - (51 + 44);
			end
			if (((1221 + 3107) == (5645 - (1114 + 203))) and (v101 == (729 - (228 + 498)))) then
				if (((345 + 1243) >= (736 + 596)) and v66.BagofTricks:IsCastable()) then
					if (v20(v66.BagofTricks, nil, not v15:IsSpellInRange(v66.BagofTricks)) or ((4837 - (174 + 489)) > (11067 - 6819))) then
						return "bag_of_tricks racials 14";
					end
				end
				if ((v66.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (1925 - (830 + 1075)))) or ((5110 - (303 + 221)) <= (1351 - (231 + 1038)))) then
					if (((3220 + 643) == (5025 - (171 + 991))) and v20(v66.ArcaneTorrent, nil, not v15:IsInRange(32 - 24))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if ((v101 == (5 - 3)) or ((703 - 421) <= (34 + 8))) then
				if (((16156 - 11547) >= (2209 - 1443)) and v66.AncestralCall:IsCastable()) then
					if (v20(v66.AncestralCall) or ((1856 - 704) == (7690 - 5202))) then
						return "ancestral_call racials 10";
					end
				end
				if (((4670 - (111 + 1137)) > (3508 - (91 + 67))) and v66.Fireblood:IsCastable()) then
					if (((2610 - 1733) > (94 + 282)) and v20(v66.Fireblood)) then
						return "fireblood racials 12";
					end
				end
				v101 = 526 - (423 + 100);
			end
		end
	end
	local function v89()
		local v102 = 0 + 0;
		while true do
			if ((v102 == (5 - 3)) or ((1626 + 1492) <= (2622 - (326 + 445)))) then
				if ((v66.DeathAndDecay:IsReady() and v14:BuffDown(v66.DeathAndDecayBuff) and (v66.SanguineGround:IsAvailable() or v66.UnholyGround:IsAvailable())) or ((720 - 555) >= (7779 - 4287))) then
					if (((9217 - 5268) < (5567 - (530 + 181))) and v20(v68.DaDPlayer, v46, nil, not v15:IsInRange(911 - (614 + 267)))) then
						return "death_and_decay drw_up 16";
					end
				end
				if ((v66.BloodBoil:IsCastable() and (v76 > (34 - (19 + 13))) and (v66.BloodBoil:ChargesFractional() >= (1.1 - 0))) or ((9963 - 5687) < (8615 - 5599))) then
					if (((1219 + 3471) > (7254 - 3129)) and v20(v66.BloodBoil, nil, not v15:IsInMeleeRange(20 - 10))) then
						return "blood_boil drw_up 18";
					end
				end
				v73 = (1837 - (1293 + 519)) + (v77 * v22(v66.Heartbreaker:IsAvailable()) * (3 - 1));
				v102 = 7 - 4;
			end
			if (((5 - 2) == v102) or ((215 - 165) >= (2110 - 1214))) then
				if ((v66.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v73) or (v14:RunicPower() >= v70))) or ((908 + 806) >= (604 + 2354))) then
					if (v20(v66.DeathStrike, v54, nil, not v15:IsSpellInRange(v66.DeathStrike)) or ((3464 - 1973) < (149 + 495))) then
						return "death_strike drw_up 20";
					end
				end
				if (((234 + 470) < (617 + 370)) and v66.Consumption:IsCastable()) then
					if (((4814 - (709 + 387)) > (3764 - (673 + 1185))) and v20(v66.Consumption, nil, not v15:IsSpellInRange(v66.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v66.BloodBoil:IsReady() and (v66.BloodBoil:ChargesFractional() >= (2.1 - 1)) and (v14:BuffStack(v66.HemostasisBuff) < (16 - 11))) or ((1576 - 618) > (2600 + 1035))) then
					if (((2616 + 885) <= (6064 - 1572)) and v20(v66.BloodBoil, nil, nil, not v15:IsInMeleeRange(3 + 7))) then
						return "blood_boil drw_up 24";
					end
				end
				v102 = 7 - 3;
			end
			if ((v102 == (1 - 0)) or ((5322 - (446 + 1434)) < (3831 - (1040 + 243)))) then
				if (((8580 - 5705) >= (3311 - (559 + 1288))) and v66.Marrowrend:IsReady() and ((v14:BuffRemains(v66.BoneShieldBuff) <= (1935 - (609 + 1322))) or (v14:BuffStack(v66.BoneShieldBuff) < v71)) and (v14:RunicPowerDeficit() > (474 - (13 + 441)))) then
					if (v20(v66.Marrowrend, nil, nil, not v15:IsInMeleeRange(18 - 13)) or ((12565 - 7768) >= (24369 - 19476))) then
						return "marrowrend drw_up 10";
					end
				end
				if ((v66.SoulReaper:IsReady() and (v76 == (1 + 0)) and ((v15:TimeToX(127 - 92) < (2 + 3)) or (v15:HealthPercentage() <= (16 + 19))) and (v15:TimeToDie() > (v15:DebuffRemains(v66.SoulReaperDebuff) + (14 - 9)))) or ((302 + 249) > (3803 - 1735))) then
					if (((1398 + 716) > (526 + 418)) and v20(v66.SoulReaper, nil, nil, not v15:IsInMeleeRange(4 + 1))) then
						return "soul_reaper drw_up 12";
					end
				end
				if ((v66.SoulReaper:IsReady() and (v76 >= (2 + 0))) or ((2214 + 48) >= (3529 - (153 + 280)))) then
					if (v80.CastTargetIf(v66.SoulReaper, v75, "min", v83, v84, not v15:IsInMeleeRange(14 - 9)) or ((2025 + 230) >= (1397 + 2140))) then
						return "soul_reaper drw_up 14";
					end
				end
				v102 = 2 + 0;
			end
			if ((v102 == (4 + 0)) or ((2781 + 1056) < (1988 - 682))) then
				if (((1824 + 1126) == (3617 - (89 + 578))) and v66.HeartStrike:IsReady() and ((v14:RuneTimeToX(2 + 0) < v14:GCD()) or (v14:RunicPowerDeficit() >= v73))) then
					if (v20(v66.HeartStrike, nil, nil, not v15:IsSpellInRange(v66.HeartStrike)) or ((9818 - 5095) < (4347 - (572 + 477)))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if (((154 + 982) >= (93 + 61)) and (v102 == (0 + 0))) then
				if ((v66.BloodBoil:IsReady() and (v15:DebuffDown(v66.BloodPlagueDebuff))) or ((357 - (84 + 2)) > (7824 - 3076))) then
					if (((3415 + 1325) >= (3994 - (497 + 345))) and v20(v66.BloodBoil, nil, nil, not v15:IsInMeleeRange(1 + 9))) then
						return "blood_boil drw_up 2";
					end
				end
				if ((v66.Tombstone:IsReady() and (v14:BuffStack(v66.BoneShieldBuff) > (1 + 4)) and (v14:Rune() >= (1335 - (605 + 728))) and (v14:RunicPowerDeficit() >= (22 + 8)) and (not v66.ShatteringBone:IsAvailable() or (v66.ShatteringBone:IsAvailable() and v14:BuffUp(v66.DeathAndDecayBuff)))) or ((5731 - 3153) >= (156 + 3234))) then
					if (((151 - 110) <= (1498 + 163)) and v20(v66.Tombstone)) then
						return "tombstone drw_up 4";
					end
				end
				if (((1664 - 1063) < (2688 + 872)) and v66.DeathStrike:IsReady() and ((v14:BuffRemains(v66.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v66.IcyTalonsBuff) <= v14:GCD()))) then
					if (((724 - (457 + 32)) < (292 + 395)) and v20(v66.DeathStrike, v54, nil, not v15:IsInMeleeRange(1407 - (832 + 570)))) then
						return "death_strike drw_up 6";
					end
				end
				v102 = 1 + 0;
			end
		end
	end
	local function v90()
		local v103 = 0 + 0;
		while true do
			if (((16097 - 11548) > (556 + 597)) and ((796 - (588 + 208)) == v103)) then
				if ((v29 and v66.Tombstone:IsCastable() and (v14:BuffStack(v66.BoneShieldBuff) > (13 - 8)) and (v14:Rune() >= (1802 - (884 + 916))) and (v14:RunicPowerDeficit() >= (62 - 32)) and (not v66.ShatteringBone:IsAvailable() or (v66.ShatteringBone:IsAvailable() and v14:BuffUp(v66.DeathAndDecayBuff))) and (v66.DancingRuneWeapon:CooldownRemains() >= (15 + 10))) or ((5327 - (232 + 421)) < (6561 - (1569 + 320)))) then
					if (((900 + 2768) < (867 + 3694)) and v20(v66.Tombstone)) then
						return "tombstone standard 2";
					end
				end
				v72 = (33 - 23) + (v76 * v22(v66.Heartbreaker:IsAvailable()) * (607 - (316 + 289)));
				if ((v66.DeathStrike:IsReady() and ((v14:BuffRemains(v66.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v66.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v70) or (v14:RunicPowerDeficit() <= v72) or (v15:TimeToDie() < (26 - 16)))) or ((22 + 433) == (5058 - (666 + 787)))) then
					if (v20(v66.DeathStrike, v54, nil, not v15:IsInMeleeRange(430 - (360 + 65))) or ((2489 + 174) == (3566 - (79 + 175)))) then
						return "death_strike standard 4";
					end
				end
				v103 = 1 - 0;
			end
			if (((3338 + 939) <= (13716 - 9241)) and (v103 == (1 - 0))) then
				if ((v66.DeathsCaress:IsReady() and ((v14:BuffRemains(v66.BoneShieldBuff) <= (903 - (503 + 396))) or (v14:BuffStack(v66.BoneShieldBuff) < (v71 + (182 - (92 + 89))))) and (v14:RunicPowerDeficit() > (19 - 9)) and not (v66.InsatiableBlade:IsAvailable() and (v66.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v66.BoneShieldBuff))) and not v66.Consumption:IsAvailable() and not v66.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(2 + 1) > v14:GCD())) or ((515 + 355) == (4656 - 3467))) then
					if (((213 + 1340) <= (7143 - 4010)) and v20(v66.DeathsCaress, nil, nil, not v15:IsSpellInRange(v66.DeathsCaress))) then
						return "deaths_caress standard 6";
					end
				end
				if ((v66.Marrowrend:IsReady() and ((v14:BuffRemains(v66.BoneShieldBuff) <= (4 + 0)) or (v14:BuffStack(v66.BoneShieldBuff) < v71)) and (v14:RunicPowerDeficit() > (10 + 10)) and not (v66.InsatiableBlade:IsAvailable() and (v66.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v66.BoneShieldBuff)))) or ((6813 - 4576) >= (439 + 3072))) then
					if (v20(v66.Marrowrend, nil, nil, not v15:IsInMeleeRange(7 - 2)) or ((2568 - (485 + 759)) > (6987 - 3967))) then
						return "marrowrend standard 8";
					end
				end
				if (v66.Consumption:IsCastable() or ((4181 - (442 + 747)) == (3016 - (832 + 303)))) then
					if (((4052 - (88 + 858)) > (466 + 1060)) and v20(v66.Consumption, nil, not v15:IsSpellInRange(v66.Consumption))) then
						return "consumption standard 10";
					end
				end
				v103 = 2 + 0;
			end
			if (((125 + 2898) < (4659 - (766 + 23))) and (v103 == (14 - 11))) then
				if (((194 - 51) > (194 - 120)) and v66.BloodBoil:IsCastable() and (v66.BloodBoil:ChargesFractional() >= (3.8 - 2)) and ((v14:BuffStack(v66.HemostasisBuff) <= ((1078 - (1036 + 37)) - v76)) or (v76 > (2 + 0)))) then
					if (((34 - 16) < (1662 + 450)) and v20(v66.BloodBoil, nil, not v15:IsInMeleeRange(1490 - (641 + 839)))) then
						return "blood_boil standard 18";
					end
				end
				if (((2010 - (910 + 3)) <= (4150 - 2522)) and v66.HeartStrike:IsReady() and (v14:RuneTimeToX(1688 - (1466 + 218)) < v14:GCD())) then
					if (((2128 + 2502) == (5778 - (556 + 592))) and v20(v66.HeartStrike, nil, nil, not v15:IsSpellInRange(v66.HeartStrike))) then
						return "heart_strike standard 20";
					end
				end
				if (((1259 + 2281) > (3491 - (329 + 479))) and v66.BloodBoil:IsCastable() and (v66.BloodBoil:ChargesFractional() >= (855.1 - (174 + 680)))) then
					if (((16472 - 11678) >= (6787 - 3512)) and v20(v66.BloodBoil, nil, nil, not v15:IsInMeleeRange(8 + 2))) then
						return "blood_boil standard 22";
					end
				end
				v103 = 743 - (396 + 343);
			end
			if (((132 + 1352) == (2961 - (29 + 1448))) and ((1391 - (135 + 1254)) == v103)) then
				if (((5394 - 3962) < (16598 - 13043)) and v66.SoulReaper:IsReady() and (v76 == (1 + 0)) and ((v15:TimeToX(1562 - (389 + 1138)) < (579 - (102 + 472))) or (v15:HealthPercentage() <= (34 + 1))) and (v15:TimeToDie() > (v15:DebuffRemains(v66.SoulReaperDebuff) + 3 + 2))) then
					if (v20(v66.SoulReaper, nil, nil, not v15:IsInMeleeRange(5 + 0)) or ((2610 - (320 + 1225)) > (6369 - 2791))) then
						return "soul_reaper standard 12";
					end
				end
				if ((v66.SoulReaper:IsReady() and (v76 >= (2 + 0))) or ((6259 - (157 + 1307)) < (3266 - (821 + 1038)))) then
					if (((4623 - 2770) < (527 + 4286)) and v80.CastTargetIf(v66.SoulReaper, v75, "min", v83, v84, not v15:IsInMeleeRange(8 - 3))) then
						return "soul_reaper standard 14";
					end
				end
				if ((v29 and v66.Bonestorm:IsReady() and (v14:RunicPower() >= (19 + 31))) or ((6991 - 4170) < (3457 - (834 + 192)))) then
					if (v20(v66.Bonestorm) or ((183 + 2691) < (560 + 1621))) then
						return "bonestorm standard 16";
					end
				end
				v103 = 1 + 2;
			end
			if ((v103 == (5 - 1)) or ((2993 - (300 + 4)) <= (92 + 251))) then
				if ((v66.HeartStrike:IsReady() and (v14:Rune() > (2 - 1)) and ((v14:RuneTimeToX(365 - (112 + 250)) < v14:GCD()) or (v14:BuffStack(v66.BoneShieldBuff) > (3 + 4)))) or ((4681 - 2812) == (1151 + 858))) then
					if (v20(v66.HeartStrike, nil, nil, not v15:IsSpellInRange(v66.HeartStrike)) or ((1834 + 1712) < (1737 + 585))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
		end
	end
	local function v91()
		local v104 = 0 + 0;
		while true do
			if ((v104 == (3 + 0)) or ((3496 - (1001 + 413)) == (10643 - 5870))) then
				v74 = v14:IsTankingAoE(890 - (244 + 638)) or v14:IsTanking(v15);
				if (((3937 - (627 + 66)) > (3143 - 2088)) and v80.TargetIsValid()) then
					local v140 = 602 - (512 + 90);
					local v141;
					while true do
						if ((v140 == (1906 - (1665 + 241))) or ((4030 - (373 + 344)) <= (802 + 976))) then
							if (not v14:AffectingCombat() or ((376 + 1045) >= (5549 - 3445))) then
								local v142 = 0 - 0;
								local v143;
								while true do
									if (((2911 - (35 + 1064)) <= (2364 + 885)) and (v142 == (0 - 0))) then
										v143 = v85();
										if (((7 + 1616) <= (3193 - (298 + 938))) and v143) then
											return v143;
										end
										break;
									end
								end
							end
							if (((5671 - (233 + 1026)) == (6078 - (636 + 1030))) and v74) then
								local v144 = 0 + 0;
								local v145;
								while true do
									if (((1710 + 40) >= (251 + 591)) and (v144 == (0 + 0))) then
										v145 = v86();
										if (((4593 - (55 + 166)) > (359 + 1491)) and v145) then
											return v145;
										end
										break;
									end
								end
							end
							if (((24 + 208) < (3135 - 2314)) and v14:IsChanneling(v66.Blooddrinker) and v14:BuffUp(v66.BoneShieldBuff) and (v78 == (297 - (36 + 261))) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 - 0))) then
								if (((1886 - (34 + 1334)) < (347 + 555)) and v10.CastAnnotated(v66.Pool, false, "WAIT")) then
									return "Pool During Blooddrinker";
								end
							end
							v70 = v62;
							v140 = 1 + 0;
						end
						if (((4277 - (1035 + 248)) > (879 - (20 + 1))) and (v140 == (2 + 0))) then
							if ((v66.DeathAndDecay:IsReady() and v14:BuffDown(v66.DeathAndDecayBuff) and (v66.UnholyGround:IsAvailable() or v66.SanguineGround:IsAvailable() or (v76 > (322 - (134 + 185))) or v14:BuffUp(v66.CrimsonScourgeBuff))) or ((4888 - (549 + 584)) <= (1600 - (314 + 371)))) then
								if (((13546 - 9600) > (4711 - (478 + 490))) and v20(v68.DaDPlayer, v46, nil, not v15:IsInRange(16 + 14))) then
									return "death_and_decay main 8";
								end
							end
							if ((v66.DeathStrike:IsReady() and ((v14:BuffRemains(v66.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v66.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v70) or (v14:RunicPowerDeficit() <= v72) or (v15:TimeToDie() < (1182 - (786 + 386))))) or ((4323 - 2988) >= (4685 - (1055 + 324)))) then
								if (((6184 - (1093 + 247)) > (2003 + 250)) and v20(v66.DeathStrike, v54, nil, not v15:IsSpellInRange(v66.DeathStrike))) then
									return "death_strike main 10";
								end
							end
							if (((48 + 404) == (1794 - 1342)) and v66.Blooddrinker:IsReady() and (v14:BuffDown(v66.DancingRuneWeaponBuff))) then
								if (v20(v66.Blooddrinker, nil, nil, not v15:IsSpellInRange(v66.Blooddrinker)) or ((15465 - 10908) < (5938 - 3851))) then
									return "blooddrinker main 12";
								end
							end
							if (((9734 - 5860) == (1379 + 2495)) and v29) then
								local v146 = v88();
								if (v146 or ((7465 - 5527) > (17009 - 12074))) then
									return v146;
								end
							end
							v140 = 3 + 0;
						end
						if ((v140 == (9 - 5)) or ((4943 - (364 + 324)) < (9383 - 5960))) then
							if (((3488 - 2034) <= (826 + 1665)) and v29 and v66.AbominationLimb:IsCastable()) then
								if (v20(v66.AbominationLimb, nil, not v15:IsInRange(83 - 63)) or ((6656 - 2499) <= (8512 - 5709))) then
									return "abomination_limb main 22";
								end
							end
							if (((6121 - (1249 + 19)) >= (2692 + 290)) and v29 and v66.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v66.DancingRuneWeaponBuff))) then
								if (((16091 - 11957) > (4443 - (686 + 400))) and v20(v66.DancingRuneWeapon, v53)) then
									return "dancing_rune_weapon main 24";
								end
							end
							if ((v14:BuffUp(v66.DancingRuneWeaponBuff)) or ((2681 + 736) < (2763 - (73 + 156)))) then
								local v147 = 0 + 0;
								local v148;
								while true do
									if ((v147 == (811 - (721 + 90))) or ((31 + 2691) <= (532 - 368))) then
										v148 = v89();
										if (v148 or ((2878 - (224 + 246)) < (3416 - 1307))) then
											return v148;
										end
										v147 = 1 - 0;
									end
									if (((1 + 0) == v147) or ((1 + 32) == (1069 + 386))) then
										if (v10.CastAnnotated(v66.Pool, false, "WAIT") or ((880 - 437) >= (13361 - 9346))) then
											return "Wait/Pool for DRWUp";
										end
										break;
									end
								end
							end
							v141 = v90();
							v140 = 518 - (203 + 310);
						end
						if (((5375 - (1238 + 755)) > (12 + 154)) and (v140 == (1539 - (709 + 825)))) then
							if (v141 or ((515 - 235) == (4455 - 1396))) then
								return v141;
							end
							if (((2745 - (196 + 668)) > (5104 - 3811)) and v10.CastAnnotated(v66.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((4882 - 2525) == (3190 - (171 + 662))) and (v140 == (94 - (4 + 89)))) then
							if (((430 - 307) == (45 + 78)) and v31) then
								local v149 = 0 - 0;
								local v150;
								while true do
									if ((v149 == (0 + 0)) or ((2542 - (35 + 1451)) >= (4845 - (28 + 1425)))) then
										v150 = v87();
										if (v150 or ((3074 - (941 + 1052)) < (1031 + 44))) then
											return v150;
										end
										break;
									end
								end
							end
							if ((v29 and v66.RaiseDead:IsCastable()) or ((2563 - (822 + 692)) >= (6326 - 1894))) then
								if (v20(v66.RaiseDead, nil) or ((2246 + 2522) <= (1143 - (45 + 252)))) then
									return "raise_dead main 4";
								end
							end
							if ((v66.VampiricBlood:IsCastable() and v14:BuffDown(v66.VampiricBloodBuff) and v14:BuffDown(v66.VampiricStrengthBuff)) or ((3323 + 35) <= (489 + 931))) then
								if (v20(v66.VampiricBlood, v57) or ((9099 - 5360) <= (3438 - (114 + 319)))) then
									return "vampiric_blood main 5";
								end
							end
							if ((v66.DeathsCaress:IsReady() and (v14:BuffDown(v66.BoneShieldBuff))) or ((2381 - 722) >= (2733 - 599))) then
								if (v20(v66.DeathsCaress, nil, nil, not v15:IsSpellInRange(v66.DeathsCaress)) or ((2079 + 1181) < (3508 - 1153))) then
									return "deaths_caress main 6";
								end
							end
							v140 = 3 - 1;
						end
						if ((v140 == (1966 - (556 + 1407))) or ((1875 - (741 + 465)) == (4688 - (170 + 295)))) then
							if ((v29 and v66.SacrificialPact:IsReady() and v79.GhoulActive() and v14:BuffDown(v66.DancingRuneWeaponBuff) and ((v79.GhoulRemains() < (2 + 0)) or (v15:TimeToDie() < v14:GCD()))) or ((1555 + 137) < (1447 - 859))) then
								if (v20(v66.SacrificialPact, v48) or ((3977 + 820) < (2342 + 1309))) then
									return "sacrificial_pact main 14";
								end
							end
							if ((v29 and v66.BloodTap:IsCastable() and (((v14:Rune() <= (2 + 0)) and (v14:RuneTimeToX(1234 - (957 + 273)) > v14:GCD()) and (v66.BloodTap:ChargesFractional() >= (1.8 + 0))) or (v14:RuneTimeToX(2 + 1) > v14:GCD()))) or ((15916 - 11739) > (12780 - 7930))) then
								if (v20(v66.BloodTap, v58) or ((1221 - 821) > (5501 - 4390))) then
									return "blood_tap main 16";
								end
							end
							if (((4831 - (389 + 1391)) > (631 + 374)) and v29 and v66.GorefiendsGrasp:IsCastable() and (v66.TighteningGrasp:IsAvailable())) then
								if (((385 + 3308) <= (9975 - 5593)) and v20(v66.GorefiendsGrasp, nil, not v15:IsSpellInRange(v66.GorefiendsGrasp))) then
									return "gorefiends_grasp main 18";
								end
							end
							if ((v29 and v66.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (957 - (783 + 168))) and (v14:RunicPowerDeficit() > (16 - 11))) or ((3229 + 53) > (4411 - (309 + 2)))) then
								if (v20(v66.EmpowerRuneWeapon) or ((10993 - 7413) < (4056 - (1090 + 122)))) then
									return "empower_rune_weapon main 20";
								end
							end
							v140 = 2 + 2;
						end
					end
				end
				break;
			end
			if (((298 - 209) < (3073 + 1417)) and ((1118 - (628 + 490)) == v104)) then
				v64();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v104 = 1 + 0;
			end
			if ((v104 == (2 - 1)) or ((22772 - 17789) < (2582 - (431 + 343)))) then
				v29 = EpicSettings.Toggles['cds'];
				v75 = v14:GetEnemiesInMeleeRange(10 - 5);
				v65 = v14:GetEnemiesInMeleeRange(28 - 18);
				v104 = 2 + 0;
			end
			if (((490 + 3339) > (5464 - (556 + 1139))) and (v104 == (17 - (6 + 9)))) then
				if (((272 + 1213) <= (1488 + 1416)) and v28) then
					v76 = ((#v75 > (169 - (28 + 141))) and #v75) or (1 + 0);
				else
					v76 = 1 - 0;
					v65 = 1 + 0;
				end
				v77 = v24(v76, (v14:BuffUp(v66.DeathAndDecayBuff) and (1322 - (486 + 831))) or (5 - 3));
				v78 = v82(v75);
				v104 = 10 - 7;
			end
		end
	end
	local function v92()
		local v105 = 0 + 0;
		while true do
			if (((13498 - 9229) == (5532 - (668 + 595))) and (v105 == (0 + 0))) then
				v66.MarkofFyralathDebuff:RegisterAuraTracking();
				v10.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(51 + 199, v91, v92);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

