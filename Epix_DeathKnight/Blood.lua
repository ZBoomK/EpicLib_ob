local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3919 - (265 + 299)) >= (10216 - 7364)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((542 + 507) <= (1600 - (619 + 75)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((5319 - (118 + 688)) > (2774 - (25 + 23))) and (v5 == (1 + 0))) then
			return v6(...);
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
		local v95 = 1886 - (927 + 959);
		while true do
			if ((v95 == (10 - 7)) or ((2213 - (16 + 716)) >= (5130 - 2472))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v95 = 101 - (11 + 86);
			end
			if ((v95 == (9 - 5)) or ((3505 - (175 + 110)) == (3443 - 2079))) then
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v95 = 24 - 19;
			end
			if ((v95 == (1804 - (503 + 1293))) or ((2943 - 1889) > (2453 + 939))) then
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (1061 - (810 + 251));
				v63 = EpicSettings.Settings['DeathStrikeHealing'] or (0 + 0);
				v65 = EpicSettings.Settings['DnDCast'];
				break;
			end
			if ((v95 == (0 + 0)) or ((610 + 66) >= (2175 - (43 + 490)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (733 - (711 + 22));
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v95 = 860 - (240 + 619);
			end
			if (((999 + 3137) > (3812 - 1415)) and (v95 == (1 + 6))) then
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v95 = 1752 - (1344 + 400);
			end
			if ((v95 == (407 - (255 + 150))) or ((3414 + 920) == (2273 + 1972))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v95 = 9 - 6;
			end
			if ((v95 == (1740 - (404 + 1335))) or ((4682 - (183 + 223)) <= (3688 - 657))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (337 - (10 + 327));
				v95 = 2 + 0;
			end
			if ((v95 == (344 - (118 + 220))) or ((1594 + 3188) <= (1648 - (108 + 341)))) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v95 = 4 + 3;
			end
			if ((v95 == (21 - 16)) or ((6357 - (711 + 782)) < (3645 - 1743))) then
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = EpicSettings.Settings['DeathStrikeGCD'];
				v95 = 475 - (270 + 199);
			end
		end
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 1884 - (580 + 1239);
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (11 - 7)) or (5 + 0);
	local v74 = 0 + 0;
	local v75 = 0 + 0;
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (4 + 0)) or (23 - 18);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v96)
		local v97 = 0 - 0;
		for v105, v106 in pairs(v96) do
			if (((6675 - (1045 + 791)) >= (9365 - 5665)) and not v106:DebuffUp(v68.BloodPlagueDebuff)) then
				v97 = v97 + (1 - 0);
			end
		end
		return v97;
	end
	local function v85(v98)
		return (v98:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v99)
		return ((v99:TimeToX(540 - (351 + 154)) < (1579 - (1281 + 293))) or (v99:HealthPercentage() <= (301 - (28 + 238)))) and (v99:TimeToDie() > (v99:DebuffRemains(v68.SoulReaperDebuff) + (10 - 5)));
	end
	local function v87()
		if (v68.DeathsCaress:IsReady() or ((2634 - (1381 + 178)) > (1799 + 119))) then
			if (((320 + 76) <= (1623 + 2181)) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
				return "deaths_caress precombat 4";
			end
		end
		if (v68.Marrowrend:IsReady() or ((14372 - 10203) == (1134 + 1053))) then
			if (((1876 - (381 + 89)) == (1247 + 159)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(4 + 1))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v88()
		local v100 = 0 - 0;
		while true do
			if (((2687 - (1074 + 82)) < (9359 - 5088)) and (v100 == (1787 - (214 + 1570)))) then
				if (((2090 - (990 + 465)) == (262 + 373)) and v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= (v63 + (((v14:RunicPower() > v72) and (9 + 11)) or (0 + 0))))) then
					if (((13274 - 9901) <= (5282 - (1668 + 58))) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((627 - (512 + 114)) == v100) or ((8580 - 5289) < (6780 - 3500))) then
				if (((15261 - 10875) >= (407 + 466)) and v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (1 + 2)) and (v68.RuneTap:Charges() >= (1 + 0)) and v14:BuffDown(v68.RuneTapBuff)) then
					if (((3106 - 2185) <= (3096 - (109 + 1885))) and v20(v68.RuneTap, v59)) then
						return "rune_tap defensives 2";
					end
				end
				if (((6175 - (1269 + 200)) >= (1845 - 882)) and v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (817.5 - (98 + 717))) and (v68.DeathStrike:TimeSinceLastCast() > (828.5 - (802 + 24)))) then
					local v137 = 0 - 0;
					while true do
						if ((v137 == (1 - 0)) or ((142 + 818) <= (674 + 202))) then
							if (v68.DeathStrike:IsReady() or ((340 + 1726) == (202 + 730))) then
								if (((13422 - 8597) < (16150 - 11307)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
						if (((0 + 0) == v137) or ((1579 + 2298) >= (3743 + 794))) then
							if ((v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (6 + 1))) or ((2015 + 2300) < (3159 - (797 + 636)))) then
								if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((17862 - 14183) < (2244 - (1427 + 192)))) then
									return "death_strike defensives 4";
								end
							end
							if (v68.Marrowrend:IsReady() or ((1603 + 3022) < (1467 - 835))) then
								if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(5 + 0)) or ((38 + 45) > (2106 - (192 + 134)))) then
									return "marrowrend defensives 6";
								end
							end
							v137 = 1277 - (316 + 960);
						end
					end
				end
				v100 = 2 + 0;
			end
			if (((422 + 124) <= (996 + 81)) and (v100 == (0 - 0))) then
				if (((v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) or ((1547 - (83 + 468)) > (6107 - (1202 + 604)))) then
					if (((18999 - 14929) > (1143 - 456)) and v10.Press(v70.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v32 and (v14:HealthPercentage() <= v34)) or ((1816 - 1160) >= (3655 - (45 + 280)))) then
					local v138 = 0 + 0;
					while true do
						if (((0 + 0) == v138) or ((910 + 1582) <= (186 + 149))) then
							if (((761 + 3561) >= (4743 - 2181)) and (v33 == "Refreshing Healing Potion")) then
								if (v69.RefreshingHealingPotion:IsReady() or ((5548 - (340 + 1571)) >= (1487 + 2283))) then
									if (v10.Press(v70.RefreshingHealingPotion) or ((4151 - (1733 + 39)) > (12579 - 8001))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v33 == "Dreamwalker's Healing Potion") or ((1517 - (125 + 909)) > (2691 - (1096 + 852)))) then
								if (((1101 + 1353) > (825 - 247)) and v69.DreamwalkersHealingPotion:IsReady()) then
									if (((903 + 27) < (4970 - (409 + 103))) and v10.Press(v70.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				v100 = 237 - (46 + 190);
			end
			if (((757 - (51 + 44)) <= (275 + 697)) and (v100 == (1319 - (1114 + 203)))) then
				if (((5096 - (228 + 498)) == (947 + 3423)) and v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) then
					if (v20(v68.VampiricBlood, v57) or ((2631 + 2131) <= (1524 - (174 + 489)))) then
						return "vampiric_blood defensives 14";
					end
				end
				if ((v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) or ((3678 - 2266) == (6169 - (830 + 1075)))) then
					if (v20(v68.IceboundFortitude, v55) or ((3692 - (303 + 221)) < (3422 - (231 + 1038)))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v100 = 3 + 0;
			end
		end
	end
	local function v89()
	end
	local function v90()
		if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((6138 - (171 + 991)) < (5489 - 4157))) then
			if (((12426 - 7798) == (11548 - 6920)) and v20(v68.BloodFury)) then
				return "blood_fury racials 2";
			end
		end
		if (v68.Berserking:IsCastable() or ((44 + 10) == (1384 - 989))) then
			if (((236 - 154) == (131 - 49)) and v20(v68.Berserking)) then
				return "berserking racials 4";
			end
		end
		if ((v68.ArcanePulse:IsCastable() and ((v78 >= (6 - 4)) or ((v14:Rune() < (1249 - (111 + 1137))) and (v14:RunicPowerDeficit() > (218 - (91 + 67)))))) or ((1729 - 1148) < (71 + 211))) then
			if (v20(v68.ArcanePulse, nil, not v15:IsInRange(531 - (423 + 100))) or ((33 + 4576) < (6907 - 4412))) then
				return "arcane_pulse racials 6";
			end
		end
		if (((601 + 551) == (1923 - (326 + 445))) and v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) then
			if (((8274 - 6378) <= (7623 - 4201)) and v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment))) then
				return "lights_judgment racials 8";
			end
		end
		if (v68.AncestralCall:IsCastable() or ((2310 - 1320) > (2331 - (530 + 181)))) then
			if (v20(v68.AncestralCall) or ((1758 - (614 + 267)) > (4727 - (19 + 13)))) then
				return "ancestral_call racials 10";
			end
		end
		if (((4379 - 1688) >= (4313 - 2462)) and v68.Fireblood:IsCastable()) then
			if (v20(v68.Fireblood) or ((8526 - 5541) >= (1262 + 3594))) then
				return "fireblood racials 12";
			end
		end
		if (((7519 - 3243) >= (2478 - 1283)) and v68.BagofTricks:IsCastable()) then
			if (((5044 - (1293 + 519)) <= (9569 - 4879)) and v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks))) then
				return "bag_of_tricks racials 14";
			end
		end
		if ((v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (52 - 32))) or ((1713 - 817) >= (13565 - 10419))) then
			if (((7210 - 4149) >= (1567 + 1391)) and v20(v68.ArcaneTorrent, nil, not v15:IsInRange(2 + 6))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v91()
		local v101 = 0 - 0;
		while true do
			if (((737 + 2450) >= (214 + 430)) and (v101 == (2 + 0))) then
				v75 = (1121 - (709 + 387)) + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (1860 - (673 + 1185)));
				if (((1867 - 1223) <= (2260 - 1556)) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
					if (((1576 - 618) > (678 + 269)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
						return "death_strike drw_up 20";
					end
				end
				if (((3357 + 1135) >= (3583 - 929)) and v68.Consumption:IsCastable()) then
					if (((846 + 2596) >= (2996 - 1493)) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (1.1 - 0)) and (v14:BuffStack(v68.HemostasisBuff) < (1885 - (446 + 1434)))) or ((4453 - (1040 + 243)) <= (4369 - 2905))) then
					if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(1857 - (559 + 1288))) or ((6728 - (609 + 1322)) == (4842 - (13 + 441)))) then
						return "blood_boil drw_up 24";
					end
				end
				v101 = 10 - 7;
			end
			if (((1443 - 892) <= (3391 - 2710)) and (v101 == (0 + 0))) then
				if (((11901 - 8624) > (145 + 262)) and v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) then
					if (((2058 + 2637) >= (4199 - 2784)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(6 + 4))) then
						return "blood_boil drw_up 2";
					end
				end
				if ((v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (8 - 3)) and (v14:Rune() >= (2 + 0)) and (v14:RunicPowerDeficit() >= (17 + 13)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) or ((2308 + 904) <= (793 + 151))) then
					if (v20(v68.Tombstone) or ((3030 + 66) <= (2231 - (153 + 280)))) then
						return "tombstone drw_up 4";
					end
				end
				if (((10213 - 6676) == (3176 + 361)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) then
					if (((1516 + 2321) >= (822 + 748)) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(5 + 0))) then
						return "death_strike drw_up 6";
					end
				end
				if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (3 + 1)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (30 - 10))) or ((1824 + 1126) == (4479 - (89 + 578)))) then
					if (((3374 + 1349) >= (4818 - 2500)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1054 - (572 + 477)))) then
						return "marrowrend drw_up 10";
					end
				end
				v101 = 1 + 0;
			end
			if ((v101 == (1 + 0)) or ((242 + 1785) > (2938 - (84 + 2)))) then
				if ((v68.SoulReaper:IsReady() and (v78 == (1 - 0)) and ((v15:TimeToX(26 + 9) < (847 - (497 + 345))) or (v15:HealthPercentage() <= (1 + 34))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + 1 + 4))) or ((2469 - (605 + 728)) > (3081 + 1236))) then
					if (((10556 - 5808) == (218 + 4530)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(18 - 13))) then
						return "soul_reaper drw_up 12";
					end
				end
				if (((3368 + 368) <= (13132 - 8392)) and v68.SoulReaper:IsReady() and (v78 >= (2 + 0))) then
					if (v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(494 - (457 + 32))) or ((1439 + 1951) <= (4462 - (832 + 570)))) then
						return "soul_reaper drw_up 14";
					end
				end
				if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) or ((942 + 57) > (703 + 1990))) then
					if (((1638 - 1175) < (290 + 311)) and (v65 == "At Player")) then
						if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(826 - (588 + 208))) or ((5883 - 3700) < (2487 - (884 + 916)))) then
							return "death_and_decay drw_up 16";
						end
					elseif (((9523 - 4974) == (2638 + 1911)) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(683 - (232 + 421)))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((6561 - (1569 + 320)) == (1147 + 3525)) and v68.BloodBoil:IsCastable() and (v78 > (1 + 1)) and (v68.BloodBoil:ChargesFractional() >= (3.1 - 2))) then
					if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(615 - (316 + 289))) or ((9601 - 5933) < (19 + 376))) then
						return "blood_boil drw_up 18";
					end
				end
				v101 = 1455 - (666 + 787);
			end
			if ((v101 == (428 - (360 + 65))) or ((3894 + 272) == (709 - (79 + 175)))) then
				if ((v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(2 - 0) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) or ((3472 + 977) == (8162 - 5499))) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((8236 - 3959) < (3888 - (503 + 396)))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
		end
	end
	local function v92()
		if ((v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (186 - (92 + 89))) and (v14:Rune() >= (3 - 1)) and (v14:RunicPowerDeficit() >= (16 + 14)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (15 + 10))) or ((3407 - 2537) >= (568 + 3581))) then
			if (((5043 - 2831) < (2778 + 405)) and v20(v68.Tombstone)) then
				return "tombstone standard 2";
			end
		end
		v74 = 5 + 5 + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (5 - 3));
		if (((580 + 4066) > (4562 - 1570)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (1254 - (485 + 759))))) then
			if (((3317 - 1883) < (4295 - (442 + 747))) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(1140 - (832 + 303)))) then
				return "death_strike standard 4";
			end
		end
		if (((1732 - (88 + 858)) < (922 + 2101)) and v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (4 + 0)) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + 1 + 0))) and (v14:RunicPowerDeficit() > (799 - (766 + 23))) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(14 - 11) > v14:GCD())) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((3339 - 897) < (194 - 120))) then
				return "deaths_caress standard 6";
			end
		end
		if (((15391 - 10856) == (5608 - (1036 + 37))) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (3 + 1)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (38 - 18)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(4 + 1)) or ((4489 - (641 + 839)) <= (3018 - (910 + 3)))) then
				return "marrowrend standard 8";
			end
		end
		if (((4665 - 2835) < (5353 - (1466 + 218))) and v68.Consumption:IsCastable()) then
			if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((658 + 772) >= (4760 - (556 + 592)))) then
				return "consumption standard 10";
			end
		end
		if (((955 + 1728) >= (3268 - (329 + 479))) and v68.SoulReaper:IsReady() and (v78 == (855 - (174 + 680))) and ((v15:TimeToX(120 - 85) < (10 - 5)) or (v15:HealthPercentage() <= (25 + 10))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (744 - (396 + 343))))) then
			if (v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(1 + 4)) or ((3281 - (29 + 1448)) >= (4664 - (135 + 1254)))) then
				return "soul_reaper standard 12";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 >= (7 - 5))) or ((6616 - 5199) > (2419 + 1210))) then
			if (((6322 - (389 + 1138)) > (976 - (102 + 472))) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(5 + 0))) then
				return "soul_reaper standard 14";
			end
		end
		if (((2669 + 2144) > (3325 + 240)) and v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (1645 - (320 + 1225)))) then
			if (((6963 - 3051) == (2394 + 1518)) and v20(v68.Bonestorm)) then
				return "bonestorm standard 16";
			end
		end
		if (((4285 - (157 + 1307)) <= (6683 - (821 + 1038))) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (2.8 - 1)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((1 + 4) - v78)) or (v78 > (3 - 1)))) then
			if (((647 + 1091) <= (5440 - 3245)) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1036 - (834 + 192)))) then
				return "blood_boil standard 18";
			end
		end
		if (((3 + 38) <= (775 + 2243)) and v68.HeartStrike:IsReady() and (v14:RuneTimeToX(1 + 3) < v14:GCD())) then
			if (((3323 - 1178) <= (4408 - (300 + 4))) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 20";
			end
		end
		if (((719 + 1970) < (12683 - 7838)) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (363.1 - (112 + 250)))) then
			if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(4 + 6)) or ((5816 - 3494) > (1503 + 1119))) then
				return "blood_boil standard 22";
			end
		end
		if ((v68.HeartStrike:IsReady() and (v14:Rune() > (1 + 0)) and ((v14:RuneTimeToX(3 + 0) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (4 + 3)))) or ((3369 + 1165) == (3496 - (1001 + 413)))) then
			if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((3503 - 1932) > (2749 - (244 + 638)))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v93()
		v66();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v77 = v14:GetEnemiesInMeleeRange(698 - (627 + 66));
		if (v28 or ((7907 - 5253) >= (3598 - (512 + 90)))) then
			v78 = #v77;
		else
			v78 = 1907 - (1665 + 241);
		end
		if (((4695 - (373 + 344)) > (949 + 1155)) and (v82.TargetIsValid() or v14:AffectingCombat())) then
			v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (2 + 3)) or (5 - 3));
			v80 = v84(v77);
			v76 = v14:IsTankingAoE(13 - 5) or v14:IsTanking(v15);
		end
		if (((4094 - (35 + 1064)) > (1122 + 419)) and v82.TargetIsValid()) then
			local v108 = 0 - 0;
			local v109;
			while true do
				if (((13 + 3236) > (2189 - (298 + 938))) and (v108 == (1259 - (233 + 1026)))) then
					if (not v14:AffectingCombat() or ((4939 - (636 + 1030)) > (2339 + 2234))) then
						local v139 = 0 + 0;
						local v140;
						while true do
							if ((v139 == (0 + 0)) or ((213 + 2938) < (1505 - (55 + 166)))) then
								v140 = v87();
								if (v140 or ((359 + 1491) == (154 + 1375))) then
									return v140;
								end
								break;
							end
						end
					end
					if (((3135 - 2314) < (2420 - (36 + 261))) and v76) then
						local v141 = 0 - 0;
						local v142;
						while true do
							if (((2270 - (34 + 1334)) < (894 + 1431)) and (v141 == (0 + 0))) then
								v142 = v88();
								if (((2141 - (1035 + 248)) <= (2983 - (20 + 1))) and v142) then
									return v142;
								end
								break;
							end
						end
					end
					if ((v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (0 + 0)) and not v14:ShouldStopCasting() and (v14:CastRemains() > (319.2 - (134 + 185)))) or ((5079 - (549 + 584)) < (1973 - (314 + 371)))) then
						if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((11129 - 7887) == (1535 - (478 + 490)))) then
							return "Pool During Blooddrinker";
						end
					end
					v108 = 1 + 0;
				end
				if ((v108 == (1174 - (786 + 386))) or ((2743 - 1896) >= (2642 - (1055 + 324)))) then
					if ((v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) or ((3593 - (1093 + 247)) == (1645 + 206))) then
						if (v20(v68.VampiricBlood, v57) or ((220 + 1867) > (9417 - 7045))) then
							return "vampiric_blood main 5";
						end
					end
					if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((15085 - 10640) < (11805 - 7656))) then
						if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((4568 - 2750) == (31 + 54))) then
							return "deaths_caress main 6";
						end
					end
					if (((2427 - 1797) < (7331 - 5204)) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (3 + 0)) or v14:BuffUp(v68.CrimsonScourgeBuff))) then
						if ((v65 == "At Player") or ((4955 - 3017) == (3202 - (364 + 324)))) then
							if (((11664 - 7409) >= (131 - 76)) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(10 + 20))) then
								return "death_and_decay drw_up 16";
							end
						elseif (((12548 - 9549) > (1851 - 695)) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(91 - 61))) then
							return "death_and_decay drw_up 16";
						end
					end
					v108 = 1271 - (1249 + 19);
				end
				if (((2122 + 228) > (4495 - 3340)) and (v108 == (1093 - (686 + 400)))) then
					if (((3162 + 867) <= (5082 - (73 + 156))) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if (((1 + 5) == v108) or ((1327 - (721 + 90)) > (39 + 3395))) then
					if (((13136 - 9090) >= (3503 - (224 + 246))) and (v14:BuffUp(v68.DancingRuneWeaponBuff))) then
						local v143 = v91();
						if (v143 or ((4404 - 1685) <= (2663 - 1216))) then
							return v143;
						end
						if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((750 + 3384) < (94 + 3832))) then
							return "Wait/Pool for DRWUp";
						end
					end
					v109 = v92();
					if (v109 or ((121 + 43) >= (5537 - 2752))) then
						return v109;
					end
					v108 = 23 - 16;
				end
				if ((v108 == (514 - (203 + 310))) or ((2518 - (1238 + 755)) == (148 + 1961))) then
					v72 = v62;
					if (((1567 - (709 + 825)) == (60 - 27)) and v31) then
						local v144 = 0 - 0;
						local v145;
						while true do
							if (((3918 - (196 + 668)) <= (15852 - 11837)) and (v144 == (0 - 0))) then
								v145 = v89();
								if (((2704 - (171 + 662)) < (3475 - (4 + 89))) and v145) then
									return v145;
								end
								break;
							end
						end
					end
					if (((4531 - 3238) <= (789 + 1377)) and v29 and v68.RaiseDead:IsCastable()) then
						if (v20(v68.RaiseDead, nil) or ((11327 - 8748) < (49 + 74))) then
							return "raise_dead main 4";
						end
					end
					v108 = 1488 - (35 + 1451);
				end
				if ((v108 == (1457 - (28 + 1425))) or ((2839 - (941 + 1052)) >= (2271 + 97))) then
					if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (1516 - (822 + 692))) or (v15:TimeToDie() < v14:GCD()))) or ((5727 - 1715) <= (1582 + 1776))) then
						if (((1791 - (45 + 252)) <= (2974 + 31)) and v20(v68.SacrificialPact, v48)) then
							return "sacrificial_pact main 14";
						end
					end
					if ((v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (1 + 1)) and (v14:RuneTimeToX(9 - 5) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (434.8 - (114 + 319)))) or (v14:RuneTimeToX(3 - 0) > v14:GCD()))) or ((3986 - 875) == (1361 + 773))) then
						if (((3508 - 1153) == (4934 - 2579)) and v20(v68.BloodTap, v58)) then
							return "blood_tap main 16";
						end
					end
					if ((v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) or ((2551 - (556 + 1407)) <= (1638 - (741 + 465)))) then
						if (((5262 - (170 + 295)) >= (2053 + 1842)) and v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp))) then
							return "gorefiends_grasp main 18";
						end
					end
					v108 = 5 + 0;
				end
				if (((8806 - 5229) == (2966 + 611)) and (v108 == (4 + 1))) then
					if (((2149 + 1645) > (4923 - (957 + 273))) and v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (2 + 4)) and (v14:RunicPowerDeficit() > (3 + 2))) then
						if (v20(v68.EmpowerRuneWeapon) or ((4858 - 3583) == (10804 - 6704))) then
							return "empower_rune_weapon main 20";
						end
					end
					if ((v29 and v68.AbominationLimb:IsCastable()) or ((4859 - 3268) >= (17727 - 14147))) then
						if (((2763 - (389 + 1391)) <= (1135 + 673)) and v20(v68.AbominationLimb, nil, not v15:IsInRange(3 + 17))) then
							return "abomination_limb main 22";
						end
					end
					if ((v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((4894 - 2744) <= (2148 - (783 + 168)))) then
						if (((12649 - 8880) >= (1154 + 19)) and v20(v68.DancingRuneWeapon, v53)) then
							return "dancing_rune_weapon main 24";
						end
					end
					v108 = 317 - (309 + 2);
				end
				if (((4560 - 3075) == (2697 - (1090 + 122))) and (v108 == (1 + 2))) then
					if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (33 - 23)))) or ((2269 + 1046) <= (3900 - (628 + 490)))) then
						if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((158 + 718) >= (7338 - 4374))) then
							return "death_strike main 10";
						end
					end
					if ((v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((10200 - 7968) > (3271 - (431 + 343)))) then
						if (v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker)) or ((4261 - 2151) <= (960 - 628))) then
							return "blooddrinker main 12";
						end
					end
					if (((2912 + 774) > (406 + 2766)) and v29) then
						local v146 = 1695 - (556 + 1139);
						local v147;
						while true do
							if ((v146 == (15 - (6 + 9))) or ((820 + 3654) < (421 + 399))) then
								v147 = v90();
								if (((4448 - (28 + 141)) >= (1117 + 1765)) and v147) then
									return v147;
								end
								break;
							end
						end
					end
					v108 = 4 - 0;
				end
			end
		end
	end
	local function v94()
		v68.MarkofFyralathDebuff:RegisterAuraTracking();
		v10.Print("Blood DK by Epic. Work in progress Gojira");
	end
	v10.SetAPL(178 + 72, v93, v94);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

