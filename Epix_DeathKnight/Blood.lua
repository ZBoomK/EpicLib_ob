local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (49 - (25 + 23))) or ((428 + 1780) > (5438 - (927 + 959)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((3129 - (16 + 716)) == (5447 - 2625))) then
			v6 = v0[v4];
			if (not v6 or ((4342 - (11 + 86)) == (11295 - 6664))) then
				return v1(v4, ...);
			end
			v5 = 286 - (175 + 110);
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
	local v64;
	local v65;
	local function v66()
		local v95 = 0 - 0;
		while true do
			if (((21090 - 16814) >= (5710 - (503 + 1293))) and (v95 == (0 - 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v34 = EpicSettings.Settings['HealingPotionHP'] or (1061 - (810 + 251));
				v95 = 1 + 0;
			end
			if (((61 + 137) <= (3935 + 430)) and (v95 == (539 - (43 + 490)))) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v95 = 740 - (711 + 22);
			end
			if (((18497 - 13715) > (5535 - (240 + 619))) and (v95 == (2 + 6))) then
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (0 - 0);
				v63 = EpicSettings.Settings['DeathStrikeHealing'] or (0 + 0);
				v65 = EpicSettings.Settings['DnDCast'];
				break;
			end
			if (((6608 - (1344 + 400)) > (2602 - (255 + 150))) and (v95 == (4 + 0))) then
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v95 = 3 + 2;
			end
			if ((v95 == (8 - 6)) or ((11950 - 8250) == (4246 - (404 + 1335)))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (406 - (183 + 223));
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v95 = 3 - 0;
			end
			if (((2965 + 1509) >= (99 + 175)) and (v95 == (344 - (10 + 327)))) then
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v95 = 6 + 2;
			end
			if ((v95 == (341 - (118 + 220))) or ((632 + 1262) <= (1855 - (108 + 341)))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v95 = 2 + 2;
			end
			if (((6645 - 5073) >= (3024 - (711 + 782))) and (v95 == (1 - 0))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (469 - (270 + 199));
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1819 - (580 + 1239));
				v95 = 5 - 3;
			end
			if ((v95 == (5 + 0)) or ((169 + 4518) < (1979 + 2563))) then
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = EpicSettings.Settings['DeathStrikeGCD'];
				v95 = 15 - 9;
			end
		end
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 1232 - (645 + 522);
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (1794 - (1010 + 780))) or (5 + 0);
	local v74 = 0 - 0;
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (1578 - (1281 + 293))) or (271 - (28 + 238));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v96)
		local v97 = 0 - 0;
		local v98;
		while true do
			if (((4850 - (1381 + 178)) > (1564 + 103)) and ((0 + 0) == v97)) then
				v98 = 0 + 0;
				for v138, v139 in pairs(v96) do
					if (not v139:DebuffUp(v68.BloodPlagueDebuff) or ((3009 - 2136) == (1054 + 980))) then
						v98 = v98 + (471 - (381 + 89));
					end
				end
				v97 = 1 + 0;
			end
			if ((v97 == (1 + 0)) or ((4823 - 2007) < (1167 - (1074 + 82)))) then
				return v98;
			end
		end
	end
	local function v85(v99)
		return (v99:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v100)
		return ((v100:TimeToX(76 - 41) < (1789 - (214 + 1570))) or (v100:HealthPercentage() <= (1490 - (990 + 465)))) and (v100:TimeToDie() > (v100:DebuffRemains(v68.SoulReaperDebuff) + 3 + 2));
	end
	local function v87()
		local v101 = 0 + 0;
		while true do
			if (((3598 + 101) < (18520 - 13814)) and ((1726 - (1668 + 58)) == v101)) then
				if (((3272 - (512 + 114)) >= (2283 - 1407)) and v68.DeathsCaress:IsReady()) then
					if (((1269 - 655) <= (11079 - 7895)) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
						return "deaths_caress precombat 4";
					end
				end
				if (((1455 + 1671) == (586 + 2540)) and v68.Marrowrend:IsReady()) then
					if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(5 + 0)) or ((7376 - 5189) >= (6948 - (109 + 1885)))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v88()
		local v102 = 1469 - (1269 + 200);
		while true do
			if ((v102 == (5 - 2)) or ((4692 - (98 + 717)) == (4401 - (802 + 24)))) then
				if (((1218 - 511) > (797 - 165)) and v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= v63)) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((81 + 465) >= (2063 + 621))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((241 + 1224) <= (928 + 3373)) and ((2 - 1) == v102)) then
				if (((5682 - 3978) > (510 + 915)) and v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (2 + 1)) and (v68.RuneTap:Charges() >= (1 + 0)) and v14:BuffDown(v68.RuneTapBuff)) then
					if (v20(v68.RuneTap, v59) or ((500 + 187) == (1977 + 2257))) then
						return "rune_tap defensives 2";
					end
				end
				if ((v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (1435.5 - (797 + 636))) and (v68.DeathStrike:TimeSinceLastCast() > (9.5 - 7))) or ((4949 - (1427 + 192)) < (496 + 933))) then
					local v140 = 0 - 0;
					while true do
						if (((1031 + 116) >= (152 + 183)) and (v140 == (327 - (192 + 134)))) then
							if (((4711 - (316 + 960)) > (1167 + 930)) and v68.DeathStrike:IsReady()) then
								if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((2910 + 860) >= (3736 + 305))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
						if ((v140 == (0 - 0)) or ((4342 - (83 + 468)) <= (3417 - (1202 + 604)))) then
							if ((v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (32 - 25))) or ((7618 - 3040) <= (5559 - 3551))) then
								if (((1450 - (45 + 280)) <= (2004 + 72)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (v68.Marrowrend:IsReady() or ((650 + 93) >= (1607 + 2792))) then
								if (((640 + 515) < (295 + 1378)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(9 - 4))) then
									return "marrowrend defensives 6";
								end
							end
							v140 = 1912 - (340 + 1571);
						end
					end
				end
				v102 = 1 + 1;
			end
			if (((1774 - (1733 + 39)) == v102) or ((6386 - 4062) <= (1612 - (125 + 909)))) then
				if (((5715 - (1096 + 852)) == (1690 + 2077)) and v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) then
					if (((5838 - 1749) == (3967 + 122)) and v20(v68.VampiricBlood, v57)) then
						return "vampiric_blood defensives 14";
					end
				end
				if (((4970 - (409 + 103)) >= (1910 - (46 + 190))) and v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) then
					if (((1067 - (51 + 44)) <= (400 + 1018)) and v20(v68.IceboundFortitude, v55)) then
						return "icebound_fortitude defensives 16";
					end
				end
				v102 = 1320 - (1114 + 203);
			end
			if ((v102 == (726 - (228 + 498))) or ((1070 + 3868) < (2631 + 2131))) then
				if (((v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) or ((3167 - (174 + 489)) > (11108 - 6844))) then
					if (((4058 - (830 + 1075)) == (2677 - (303 + 221))) and v10.Press(v70.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v32 and (v14:HealthPercentage() <= v34)) or ((1776 - (231 + 1038)) >= (2160 + 431))) then
					local v141 = 1162 - (171 + 991);
					while true do
						if (((18467 - 13986) == (12032 - 7551)) and ((0 - 0) == v141)) then
							if ((v33 == "Refreshing Healing Potion") or ((1864 + 464) < (2429 - 1736))) then
								if (((12485 - 8157) == (6976 - 2648)) and v69.RefreshingHealingPotion:IsReady()) then
									if (((4908 - 3320) >= (2580 - (111 + 1137))) and v10.Press(v70.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v33 == "Dreamwalker's Healing Potion") or ((4332 - (91 + 67)) > (12643 - 8395))) then
								if (v69.DreamwalkersHealingPotion:IsReady() or ((1145 + 3441) <= (605 - (423 + 100)))) then
									if (((28 + 3835) == (10695 - 6832)) and v10.Press(v70.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				v102 = 1 + 0;
			end
		end
	end
	local function v89()
	end
	local function v90()
		if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((1053 - (326 + 445)) <= (183 - 141))) then
			if (((10267 - 5658) >= (1787 - 1021)) and v20(v68.BloodFury)) then
				return "blood_fury racials 2";
			end
		end
		if (v68.Berserking:IsCastable() or ((1863 - (530 + 181)) == (3369 - (614 + 267)))) then
			if (((3454 - (19 + 13)) > (5452 - 2102)) and v20(v68.Berserking)) then
				return "berserking racials 4";
			end
		end
		if (((2043 - 1166) > (1074 - 698)) and v68.ArcanePulse:IsCastable() and ((v78 >= (1 + 1)) or ((v14:Rune() < (1 - 0)) and (v14:RunicPowerDeficit() > (124 - 64))))) then
			if (v20(v68.ArcanePulse, nil, not v15:IsInRange(1820 - (1293 + 519))) or ((6361 - 3243) <= (4832 - 2981))) then
				return "arcane_pulse racials 6";
			end
		end
		if ((v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) or ((315 - 150) >= (15057 - 11565))) then
			if (((9302 - 5353) < (2572 + 2284)) and v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment))) then
				return "lights_judgment racials 8";
			end
		end
		if (v68.AncestralCall:IsCastable() or ((873 + 3403) < (7007 - 3991))) then
			if (((1084 + 3606) > (1371 + 2754)) and v20(v68.AncestralCall)) then
				return "ancestral_call racials 10";
			end
		end
		if (v68.Fireblood:IsCastable() or ((32 + 18) >= (1992 - (709 + 387)))) then
			if (v20(v68.Fireblood) or ((3572 - (673 + 1185)) >= (8578 - 5620))) then
				return "fireblood racials 12";
			end
		end
		if (v68.BagofTricks:IsCastable() or ((4787 - 3296) < (1059 - 415))) then
			if (((504 + 200) < (738 + 249)) and v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks))) then
				return "bag_of_tricks racials 14";
			end
		end
		if (((5019 - 1301) > (469 + 1437)) and v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (39 - 19))) then
			if (v20(v68.ArcaneTorrent, nil, not v15:IsInRange(15 - 7)) or ((2838 - (446 + 1434)) > (4918 - (1040 + 243)))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v91()
		local v103 = 0 - 0;
		while true do
			if (((5348 - (559 + 1288)) <= (6423 - (609 + 1322))) and (v103 == (455 - (13 + 441)))) then
				if ((v68.SoulReaper:IsReady() and (v78 == (3 - 2)) and ((v15:TimeToX(91 - 56) < (24 - 19)) or (v15:HealthPercentage() <= (2 + 33))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (18 - 13)))) or ((1223 + 2219) < (1117 + 1431))) then
					if (((8531 - 5656) >= (802 + 662)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(8 - 3))) then
						return "soul_reaper drw_up 12";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 >= (2 + 0))) or ((2668 + 2129) >= (3516 + 1377))) then
					if (v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(5 + 0)) or ((540 + 11) > (2501 - (153 + 280)))) then
						return "soul_reaper drw_up 14";
					end
				end
				if (((6104 - 3990) > (848 + 96)) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) then
					if ((v65 == "At Player") or ((894 + 1368) >= (1621 + 1475))) then
						if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(28 + 2)) or ((1634 + 621) >= (5385 - 1848))) then
							return "death_and_decay drw_up 16";
						end
					elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(19 + 11)) or ((4504 - (89 + 578)) < (933 + 373))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((6132 - 3182) == (3999 - (572 + 477))) and v68.BloodBoil:IsCastable() and (v78 > (1 + 1)) and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
					if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(2 + 8)) or ((4809 - (84 + 2)) < (5435 - 2137))) then
						return "blood_boil drw_up 18";
					end
				end
				v103 = 2 + 0;
			end
			if (((1978 - (497 + 345)) >= (4 + 150)) and (v103 == (1 + 2))) then
				if ((v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(1335 - (605 + 728)) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) or ((194 + 77) > (10556 - 5808))) then
					if (((218 + 4522) >= (11653 - 8501)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if ((v103 == (2 + 0)) or ((7142 - 4564) >= (2560 + 830))) then
				v75 = (514 - (457 + 32)) + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (1 + 1));
				if (((1443 - (832 + 570)) <= (1565 + 96)) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
					if (((157 + 444) < (12598 - 9038)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
						return "death_strike drw_up 20";
					end
				end
				if (((114 + 121) < (1483 - (588 + 208))) and v68.Consumption:IsCastable()) then
					if (((12260 - 7711) > (2953 - (884 + 916))) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (1.1 - 0)) and (v14:BuffStack(v68.HemostasisBuff) < (3 + 2))) or ((5327 - (232 + 421)) < (6561 - (1569 + 320)))) then
					if (((900 + 2768) < (867 + 3694)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(33 - 23))) then
						return "blood_boil drw_up 24";
					end
				end
				v103 = 608 - (316 + 289);
			end
			if ((v103 == (0 - 0)) or ((22 + 433) == (5058 - (666 + 787)))) then
				if ((v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) or ((3088 - (360 + 65)) == (3096 + 216))) then
					if (((4531 - (79 + 175)) <= (7056 - 2581)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(8 + 2))) then
						return "blood_boil drw_up 2";
					end
				end
				if ((v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (15 - 10)) and (v14:Rune() >= (3 - 1)) and (v14:RunicPowerDeficit() >= (929 - (503 + 396))) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) or ((1051 - (92 + 89)) == (2306 - 1117))) then
					if (((797 + 756) <= (1855 + 1278)) and v20(v68.Tombstone)) then
						return "tombstone drw_up 4";
					end
				end
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) or ((8760 - 6523) >= (481 + 3030))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(11 - 6)) or ((1156 + 168) > (1443 + 1577))) then
						return "death_strike drw_up 6";
					end
				end
				if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (12 - 8)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (3 + 17))) or ((4562 - 1570) == (3125 - (485 + 759)))) then
					if (((7186 - 4080) > (2715 - (442 + 747))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1140 - (832 + 303)))) then
						return "marrowrend drw_up 10";
					end
				end
				v103 = 947 - (88 + 858);
			end
		end
	end
	local function v92()
		local v104 = 0 + 0;
		while true do
			if (((2502 + 521) < (160 + 3710)) and (v104 == (792 - (766 + 23)))) then
				if (((705 - 562) > (101 - 27)) and v68.HeartStrike:IsReady() and (v14:Rune() > (2 - 1)) and ((v14:RuneTimeToX(10 - 7) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (1080 - (1036 + 37))))) then
					if (((13 + 5) < (4112 - 2000)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
			if (((863 + 234) <= (3108 - (641 + 839))) and (v104 == (915 - (910 + 3)))) then
				if (((11803 - 7173) == (6314 - (1466 + 218))) and v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (46 + 54))) then
					if (((4688 - (556 + 592)) > (955 + 1728)) and v20(v68.Bonestorm)) then
						return "bonestorm standard 16";
					end
				end
				if (((5602 - (329 + 479)) >= (4129 - (174 + 680))) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (3.8 - 2)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((10 - 5) - v78)) or (v78 > (2 + 0)))) then
					if (((2223 - (396 + 343)) == (132 + 1352)) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1487 - (29 + 1448)))) then
						return "blood_boil standard 18";
					end
				end
				if (((2821 - (135 + 1254)) < (13392 - 9837)) and v68.HeartStrike:IsReady() and (v14:RuneTimeToX(18 - 14) < v14:GCD())) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((710 + 355) > (5105 - (389 + 1138)))) then
						return "heart_strike standard 20";
					end
				end
				if ((v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (575.1 - (102 + 472)))) or ((4525 + 270) < (781 + 626))) then
					if (((1728 + 125) < (6358 - (320 + 1225))) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(17 - 7))) then
						return "blood_boil standard 22";
					end
				end
				v104 = 2 + 1;
			end
			if ((v104 == (1464 - (157 + 1307))) or ((4680 - (821 + 1038)) < (6065 - 3634))) then
				if ((v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (1 + 4)) and (v14:Rune() >= (3 - 1)) and (v14:RunicPowerDeficit() >= (12 + 18)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (61 - 36))) or ((3900 - (834 + 192)) < (139 + 2042))) then
					if (v20(v68.Tombstone) or ((691 + 1998) <= (8 + 335))) then
						return "tombstone standard 2";
					end
				end
				v74 = (15 - 5) + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (306 - (300 + 4)));
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (3 + 7)))) or ((4892 - 3023) == (2371 - (112 + 250)))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(2 + 3)) or ((8883 - 5337) < (1331 + 991))) then
						return "death_strike standard 4";
					end
				end
				if ((v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (3 + 1)) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + 1 + 0))) and (v14:RunicPowerDeficit() > (5 + 5)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(3 + 0) > v14:GCD())) or ((3496 - (1001 + 413)) == (10643 - 5870))) then
					if (((4126 - (244 + 638)) > (1748 - (627 + 66))) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
						return "deaths_caress standard 6";
					end
				end
				v104 = 2 - 1;
			end
			if ((v104 == (603 - (512 + 90))) or ((5219 - (1665 + 241)) <= (2495 - (373 + 344)))) then
				if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (2 + 2)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (6 + 14)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) or ((3748 - 2327) >= (3560 - 1456))) then
					if (((2911 - (35 + 1064)) <= (2364 + 885)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(10 - 5))) then
						return "marrowrend standard 8";
					end
				end
				if (((7 + 1616) <= (3193 - (298 + 938))) and v68.Consumption:IsCastable()) then
					if (((5671 - (233 + 1026)) == (6078 - (636 + 1030))) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption standard 10";
					end
				end
				if (((895 + 855) >= (823 + 19)) and v68.SoulReaper:IsReady() and (v78 == (1 + 0)) and ((v15:TimeToX(3 + 32) < (226 - (55 + 166))) or (v15:HealthPercentage() <= (7 + 28))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + 1 + 4))) then
					if (((16696 - 12324) > (2147 - (36 + 261))) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(8 - 3))) then
						return "soul_reaper standard 12";
					end
				end
				if (((1600 - (34 + 1334)) < (316 + 505)) and v68.SoulReaper:IsReady() and (v78 >= (2 + 0))) then
					if (((1801 - (1035 + 248)) < (923 - (20 + 1))) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(3 + 2))) then
						return "soul_reaper standard 14";
					end
				end
				v104 = 321 - (134 + 185);
			end
		end
	end
	local function v93()
		local v105 = 1133 - (549 + 584);
		while true do
			if (((3679 - (314 + 371)) > (2945 - 2087)) and (v105 == (968 - (478 + 490)))) then
				v66();
				v27 = EpicSettings.Toggles['ooc'];
				v105 = 1 + 0;
			end
			if ((v105 == (1173 - (786 + 386))) or ((12162 - 8407) <= (2294 - (1055 + 324)))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v105 = 1342 - (1093 + 247);
			end
			if (((3507 + 439) > (394 + 3349)) and (v105 == (11 - 8))) then
				if (v82.TargetIsValid() or v14:AffectingCombat() or ((4530 - 3195) >= (9407 - 6101))) then
					v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (12 - 7)) or (1 + 1));
					v80 = v84(v77);
					v76 = v14:IsTankingAoE(30 - 22) or v14:IsTanking(v15);
				end
				if (((16696 - 11852) > (1699 + 554)) and v82.TargetIsValid()) then
					local v142 = 0 - 0;
					local v143;
					while true do
						if (((1140 - (364 + 324)) == (1238 - 786)) and (v142 == (4 - 2))) then
							if ((v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) or ((1511 + 3046) < (8732 - 6645))) then
								if (((6203 - 2329) == (11765 - 7891)) and v20(v68.VampiricBlood, v57)) then
									return "vampiric_blood main 5";
								end
							end
							if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((3206 - (1249 + 19)) > (4455 + 480))) then
								if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((16562 - 12307) < (4509 - (686 + 400)))) then
									return "deaths_caress main 6";
								end
							end
							if (((1141 + 313) <= (2720 - (73 + 156))) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (1 + 2)) or v14:BuffUp(v68.CrimsonScourgeBuff))) then
								if ((v65 == "At Player") or ((4968 - (721 + 90)) <= (32 + 2771))) then
									if (((15757 - 10904) >= (3452 - (224 + 246))) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(48 - 18))) then
										return "death_and_decay drw_up 16";
									end
								elseif (((7611 - 3477) > (609 + 2748)) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(1 + 29))) then
									return "death_and_decay drw_up 16";
								end
							end
							v142 = 3 + 0;
						end
						if ((v142 == (9 - 4)) or ((11371 - 7954) < (3047 - (203 + 310)))) then
							if ((v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (1999 - (1238 + 755))) and (v14:RunicPowerDeficit() > (1 + 4))) or ((4256 - (709 + 825)) <= (302 - 138))) then
								if (v20(v68.EmpowerRuneWeapon) or ((3507 - 1099) < (2973 - (196 + 668)))) then
									return "empower_rune_weapon main 20";
								end
							end
							if ((v29 and v68.AbominationLimb:IsCastable()) or ((130 - 97) == (3013 - 1558))) then
								if (v20(v68.AbominationLimb, nil, not v15:IsInRange(853 - (171 + 662))) or ((536 - (4 + 89)) >= (14072 - 10057))) then
									return "abomination_limb main 22";
								end
							end
							if (((1232 + 2150) > (728 - 562)) and v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
								if (v20(v68.DancingRuneWeapon, v53) or ((110 + 170) == (4545 - (35 + 1451)))) then
									return "dancing_rune_weapon main 24";
								end
							end
							v142 = 1459 - (28 + 1425);
						end
						if (((3874 - (941 + 1052)) > (1240 + 53)) and (v142 == (1514 - (822 + 692)))) then
							if (((3364 - 1007) == (1111 + 1246)) and not v14:AffectingCombat()) then
								local v144 = v87();
								if (((420 - (45 + 252)) == (122 + 1)) and v144) then
									return v144;
								end
							end
							if (v76 or ((364 + 692) >= (8254 - 4862))) then
								local v145 = 433 - (114 + 319);
								local v146;
								while true do
									if ((v145 == (0 - 0)) or ((1384 - 303) < (686 + 389))) then
										v146 = v88();
										if (v146 or ((1562 - 513) >= (9285 - 4853))) then
											return v146;
										end
										break;
									end
								end
							end
							if ((v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (1963 - (556 + 1407))) and not v14:ShouldStopCasting() and (v14:CastRemains() > (1206.2 - (741 + 465)))) or ((5233 - (170 + 295)) <= (446 + 400))) then
								if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((3085 + 273) <= (3496 - 2076))) then
									return "Pool During Blooddrinker";
								end
							end
							v142 = 1 + 0;
						end
						if ((v142 == (4 + 2)) or ((2118 + 1621) <= (4235 - (957 + 273)))) then
							if ((v14:BuffUp(v68.DancingRuneWeaponBuff)) or ((444 + 1215) >= (855 + 1279))) then
								local v147 = v91();
								if (v147 or ((12422 - 9162) < (6205 - 3850))) then
									return v147;
								end
								if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((2043 - 1374) == (20910 - 16687))) then
									return "Wait/Pool for DRWUp";
								end
							end
							v143 = v92();
							if (v143 or ((3472 - (389 + 1391)) < (369 + 219))) then
								return v143;
							end
							v142 = 1 + 6;
						end
						if (((2 - 1) == v142) or ((5748 - (783 + 168)) < (12253 - 8602))) then
							v72 = v62;
							if (v31 or ((4109 + 68) > (5161 - (309 + 2)))) then
								local v148 = v89();
								if (v148 or ((1228 - 828) > (2323 - (1090 + 122)))) then
									return v148;
								end
							end
							if (((990 + 2061) > (3375 - 2370)) and v29 and v68.RaiseDead:IsCastable()) then
								if (((2528 + 1165) <= (5500 - (628 + 490))) and v20(v68.RaiseDead, nil)) then
									return "raise_dead main 4";
								end
							end
							v142 = 1 + 1;
						end
						if (((7 - 4) == v142) or ((14998 - 11716) > (4874 - (431 + 343)))) then
							if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (20 - 10)))) or ((10356 - 6776) < (2247 + 597))) then
								if (((12 + 77) < (6185 - (556 + 1139))) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike main 10";
								end
							end
							if ((v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((4998 - (6 + 9)) < (332 + 1476))) then
								if (((1962 + 1867) > (3938 - (28 + 141))) and v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker))) then
									return "blooddrinker main 12";
								end
							end
							if (((576 + 909) <= (3583 - 679)) and v29) then
								local v149 = v90();
								if (((3024 + 1245) == (5586 - (486 + 831))) and v149) then
									return v149;
								end
							end
							v142 = 10 - 6;
						end
						if (((1362 - 975) <= (526 + 2256)) and (v142 == (12 - 8))) then
							if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (1265 - (668 + 595))) or (v15:TimeToDie() < v14:GCD()))) or ((1709 + 190) <= (185 + 732))) then
								if (v20(v68.SacrificialPact, v48) or ((11759 - 7447) <= (1166 - (23 + 267)))) then
									return "sacrificial_pact main 14";
								end
							end
							if (((4176 - (1129 + 815)) <= (2983 - (371 + 16))) and v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (1752 - (1326 + 424))) and (v14:RuneTimeToX(7 - 3) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (3.8 - 2))) or (v14:RuneTimeToX(121 - (88 + 30)) > v14:GCD()))) then
								if (((2866 - (720 + 51)) < (8199 - 4513)) and v20(v68.BloodTap, v58)) then
									return "blood_tap main 16";
								end
							end
							if ((v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) or ((3371 - (421 + 1355)) >= (7380 - 2906))) then
								if (v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp)) or ((2269 + 2350) < (3965 - (286 + 797)))) then
									return "gorefiends_grasp main 18";
								end
							end
							v142 = 18 - 13;
						end
						if ((v142 == (11 - 4)) or ((733 - (397 + 42)) >= (1509 + 3322))) then
							if (((2829 - (24 + 776)) <= (4750 - 1666)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v105 == (787 - (222 + 563))) or ((4487 - 2450) == (1743 + 677))) then
				v77 = v14:GetEnemiesInMeleeRange(195 - (23 + 167));
				if (((6256 - (690 + 1108)) > (1409 + 2495)) and v28) then
					v78 = #v77;
				else
					v78 = 1 + 0;
				end
				v105 = 851 - (40 + 808);
			end
		end
	end
	local function v94()
		local v106 = 0 + 0;
		while true do
			if (((1667 - 1231) >= (118 + 5)) and (v106 == (0 + 0))) then
				v68.MarkofFyralathDebuff:RegisterAuraTracking();
				v10.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(138 + 112, v93, v94);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

