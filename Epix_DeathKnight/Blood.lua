local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((532 + 1084) == (3229 - (1565 + 48))) and not v6) then
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
		local v95 = 0 + 0;
		while true do
			if (((2863 - (782 + 356)) == (1992 - (176 + 91))) and (v95 == (0 - 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v34 = EpicSettings.Settings['HealingPotionHP'] or (1092 - (975 + 117));
				v95 = 1876 - (157 + 1718);
			end
			if (((1185 + 274) <= (8810 - 6328)) and (v95 == (20 - 14))) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v95 = 1025 - (697 + 321);
			end
			if ((v95 == (21 - 13)) or ((5711 - 3015) >= (10447 - 5915))) then
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (0 + 0);
				v63 = EpicSettings.Settings['DeathStrikeHealing'] or (0 - 0);
				v65 = EpicSettings.Settings['DnDCast'];
				break;
			end
			if (((2809 - 1761) >= (1279 - (322 + 905))) and (v95 == (615 - (602 + 9)))) then
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v95 = 1194 - (449 + 740);
			end
			if (((3830 - (826 + 46)) < (5450 - (245 + 702))) and (v95 == (6 - 4))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v95 = 1901 - (260 + 1638);
			end
			if ((v95 == (447 - (382 + 58))) or ((8774 - 6039) == (1088 + 221))) then
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v95 = 16 - 8;
			end
			if ((v95 == (8 - 5)) or ((5335 - (902 + 303)) <= (6487 - 3532))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v95 = 9 - 5;
			end
			if ((v95 == (1 + 0)) or ((3654 - (1121 + 569)) <= (1554 - (22 + 192)))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (683 - (483 + 200));
				v37 = EpicSettings.Settings['InterruptWithStun'] or (1463 - (1404 + 59));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v95 = 2 - 0;
			end
			if (((3264 - (468 + 297)) == (3061 - (334 + 228))) and (v95 == (16 - 11))) then
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = not EpicSettings.Settings['DeathStrikeGCD'];
				v95 = 13 - 7;
			end
		end
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 19 + 46;
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (240 - (141 + 95))) or (5 + 0);
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (5 - 1)) or (3 + 2);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v96)
		local v97 = 163 - (92 + 71);
		local v98;
		while true do
			if (((0 + 0) == v97) or ((3791 - 1536) < (787 - (574 + 191)))) then
				v98 = 0 + 0;
				for v135, v136 in pairs(v96) do
					if (not v136:DebuffUp(v68.BloodPlagueDebuff) or ((2720 - 1634) >= (718 + 687))) then
						v98 = v98 + (850 - (254 + 595));
					end
				end
				v97 = 127 - (55 + 71);
			end
			if ((v97 == (1 - 0)) or ((4159 - (573 + 1217)) == (1179 - 753))) then
				return v98;
			end
		end
	end
	local function v85(v99)
		return (v99:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v100)
		return ((v100:TimeToX(3 + 32) < (8 - 3)) or (v100:HealthPercentage() <= (974 - (714 + 225)))) and (v100:TimeToDie() > (v100:DebuffRemains(v68.SoulReaperDebuff) + (14 - 9)));
	end
	local function v87()
		if (v68.DeathsCaress:IsReady() or ((4287 - 1211) > (345 + 2838))) then
			if (((1739 - 537) > (1864 - (118 + 688))) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
				return "deaths_caress precombat 4";
			end
		end
		if (((3759 - (25 + 23)) > (650 + 2705)) and v68.Marrowrend:IsReady()) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1891 - (927 + 959))) or ((3053 - 2147) >= (2961 - (16 + 716)))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v88()
		local v101 = 0 - 0;
		while true do
			if (((1385 - (11 + 86)) > (3051 - 1800)) and (v101 == (288 - (175 + 110)))) then
				if ((v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= v63)) or ((11393 - 6880) < (16532 - 13180))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((3861 - (503 + 1293)) >= (8925 - 5729))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((1 + 0) == v101) or ((5437 - (810 + 251)) <= (1028 + 453))) then
				if ((v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (1 + 2)) and (v68.RuneTap:Charges() >= (1 + 0)) and v14:BuffDown(v68.RuneTapBuff)) or ((3925 - (43 + 490)) >= (5474 - (711 + 22)))) then
					if (((12861 - 9536) >= (3013 - (240 + 619))) and v20(v68.RuneTap, v59)) then
						return "rune_tap defensives 2";
					end
				end
				if ((v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (1.5 + 1)) and (v68.DeathStrike:TimeSinceLastCast() > (2.5 - 0))) or ((86 + 1209) >= (4977 - (1344 + 400)))) then
					local v142 = 405 - (255 + 150);
					while true do
						if (((3448 + 929) > (880 + 762)) and (v142 == (4 - 3))) then
							if (((15254 - 10531) > (3095 - (404 + 1335))) and v68.DeathStrike:IsReady()) then
								if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((4542 - (183 + 223)) <= (4176 - 743))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
						if (((2813 + 1432) <= (1667 + 2964)) and ((337 - (10 + 327)) == v142)) then
							if (((2978 + 1298) >= (4252 - (118 + 220))) and v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (3 + 4))) then
								if (((647 - (108 + 341)) <= (1961 + 2404)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (((20217 - 15435) > (6169 - (711 + 782))) and v68.Marrowrend:IsReady()) then
								if (((9324 - 4460) > (2666 - (270 + 199))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
									return "marrowrend defensives 6";
								end
							end
							v142 = 1820 - (580 + 1239);
						end
					end
				end
				v101 = 5 - 3;
			end
			if (((2 + 0) == v101) or ((133 + 3567) == (1093 + 1414))) then
				if (((11680 - 7206) >= (171 + 103)) and v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) then
					if (v20(v68.VampiricBlood, v57) or ((3061 - (645 + 522)) <= (3196 - (1010 + 780)))) then
						return "vampiric_blood defensives 14";
					end
				end
				if (((1572 + 0) >= (7293 - 5762)) and v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) then
					if (v20(v68.IceboundFortitude, v55) or ((13735 - 9048) < (6378 - (1045 + 791)))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v101 = 7 - 4;
			end
			if (((5024 - 1733) > (2172 - (351 + 154))) and (v101 == (1574 - (1281 + 293)))) then
				if (((v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) or ((1139 - (28 + 238)) == (4544 - 2510))) then
					if (v10.Press(v70.Healthstone, nil, nil, true) or ((4375 - (1381 + 178)) < (11 + 0))) then
						return "healthstone defensive 3";
					end
				end
				if (((2983 + 716) < (2008 + 2698)) and v32 and (v14:HealthPercentage() <= v34)) then
					if (((9121 - 6475) >= (454 + 422)) and (v33 == "Refreshing Healing Potion")) then
						if (((1084 - (381 + 89)) <= (2824 + 360)) and v69.RefreshingHealingPotion:IsReady()) then
							if (((2115 + 1011) == (5354 - 2228)) and v10.Press(v70.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((3343 - (1074 + 82)) >= (10856 - 5902))) then
						if (v69.DreamwalkersHealingPotion:IsReady() or ((5661 - (214 + 1570)) == (5030 - (990 + 465)))) then
							if (((292 + 415) > (275 + 357)) and v10.Press(v70.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				v101 = 1 + 0;
			end
		end
	end
	local function v89()
		local v102 = 0 - 0;
		local v103;
		while true do
			if ((v102 == (1726 - (1668 + 58))) or ((1172 - (512 + 114)) >= (6997 - 4313))) then
				v103 = v82.HandleTopTrinket(v71, v29, 82 - 42, nil);
				if (((5097 - 3632) <= (2001 + 2300)) and v103) then
					return v103;
				end
				v102 = 1 + 0;
			end
			if (((1482 + 222) > (4806 - 3381)) and (v102 == (1995 - (109 + 1885)))) then
				v103 = v82.HandleBottomTrinket(v71, v29, 1509 - (1269 + 200), nil);
				if (v103 or ((1316 - 629) == (5049 - (98 + 717)))) then
					return v103;
				end
				break;
			end
		end
	end
	local function v90()
		if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((4156 - (802 + 24)) < (2463 - 1034))) then
			if (((1448 - 301) >= (50 + 285)) and v20(v68.BloodFury)) then
				return "blood_fury racials 2";
			end
		end
		if (((2640 + 795) > (345 + 1752)) and v68.Berserking:IsCastable()) then
			if (v20(v68.Berserking) or ((814 + 2956) >= (11241 - 7200))) then
				return "berserking racials 4";
			end
		end
		if ((v68.ArcanePulse:IsCastable() and ((v78 >= (6 - 4)) or ((v14:Rune() < (1 + 0)) and (v14:RunicPowerDeficit() > (25 + 35))))) or ((3128 + 663) <= (1172 + 439))) then
			if (v20(v68.ArcanePulse, nil, not v15:IsInRange(4 + 4)) or ((6011 - (797 + 636)) <= (9749 - 7741))) then
				return "arcane_pulse racials 6";
			end
		end
		if (((2744 - (1427 + 192)) <= (720 + 1356)) and v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) then
			if (v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment)) or ((1724 - 981) >= (3955 + 444))) then
				return "lights_judgment racials 8";
			end
		end
		if (((524 + 631) < (1999 - (192 + 134))) and v68.AncestralCall:IsCastable()) then
			if (v20(v68.AncestralCall) or ((3600 - (316 + 960)) <= (322 + 256))) then
				return "ancestral_call racials 10";
			end
		end
		if (((2908 + 859) == (3482 + 285)) and v68.Fireblood:IsCastable()) then
			if (((15632 - 11543) == (4640 - (83 + 468))) and v20(v68.Fireblood)) then
				return "fireblood racials 12";
			end
		end
		if (((6264 - (1202 + 604)) >= (7814 - 6140)) and v68.BagofTricks:IsCastable()) then
			if (((1617 - 645) <= (3926 - 2508)) and v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks))) then
				return "bag_of_tricks racials 14";
			end
		end
		if ((v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (345 - (45 + 280)))) or ((4767 + 171) < (4161 + 601))) then
			if (v20(v68.ArcaneTorrent, nil, not v15:IsInRange(3 + 5)) or ((1386 + 1118) > (750 + 3514))) then
				return "arcane_torrent racials 16";
			end
		end
	end
	local function v91()
		if (((3986 - 1833) == (4064 - (340 + 1571))) and v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) then
			if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(4 + 6)) or ((2279 - (1733 + 39)) >= (7119 - 4528))) then
				return "blood_boil drw_up 2";
			end
		end
		if (((5515 - (125 + 909)) == (6429 - (1096 + 852))) and v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (3 + 2)) and (v14:Rune() >= (2 - 0)) and (v14:RunicPowerDeficit() >= (30 + 0)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) then
			if (v20(v68.Tombstone) or ((2840 - (409 + 103)) < (929 - (46 + 190)))) then
				return "tombstone drw_up 4";
			end
		end
		if (((4423 - (51 + 44)) == (1221 + 3107)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) then
			if (((2905 - (1114 + 203)) >= (2058 - (228 + 498))) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(2 + 3))) then
				return "death_strike drw_up 6";
			end
		end
		if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (3 + 1)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (683 - (174 + 489)))) or ((10874 - 6700) > (6153 - (830 + 1075)))) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(529 - (303 + 221))) or ((5855 - (231 + 1038)) <= (69 + 13))) then
				return "marrowrend drw_up 10";
			end
		end
		if (((5025 - (171 + 991)) == (15920 - 12057)) and v68.SoulReaper:IsReady() and (v78 == (2 - 1)) and ((v15:TimeToX(87 - 52) < (5 + 0)) or (v15:HealthPercentage() <= (122 - 87))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (14 - 9)))) then
			if (v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(8 - 3)) or ((871 - 589) <= (1290 - (111 + 1137)))) then
				return "soul_reaper drw_up 12";
			end
		end
		if (((4767 - (91 + 67)) >= (2279 - 1513)) and v68.SoulReaper:IsReady() and (v78 >= (1 + 1))) then
			if (v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(528 - (423 + 100))) or ((9 + 1143) == (6888 - 4400))) then
				return "soul_reaper drw_up 14";
			end
		end
		if (((1784 + 1638) > (4121 - (326 + 445))) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) then
			if (((3827 - 2950) > (837 - 461)) and (v65 == "At Player")) then
				if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(70 - 40)) or ((3829 - (530 + 181)) <= (2732 - (614 + 267)))) then
					return "death_and_decay drw_up 16";
				end
			elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(62 - (19 + 13))) or ((268 - 103) >= (8137 - 4645))) then
				return "death_and_decay drw_up 16";
			end
		end
		if (((11280 - 7331) < (1262 + 3594)) and v68.BloodBoil:IsCastable() and (v78 > (3 - 1)) and (v68.BloodBoil:ChargesFractional() >= (1.1 - 0))) then
			if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1822 - (1293 + 519))) or ((8724 - 4448) < (7874 - 4858))) then
				return "blood_boil drw_up 18";
			end
		end
		v75 = (47 - 22) + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (8 - 6));
		if (((11048 - 6358) > (2185 + 1940)) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((11 + 39) >= (2081 - 1185))) then
				return "death_strike drw_up 20";
			end
		end
		if (v68.Consumption:IsCastable() or ((397 + 1317) >= (983 + 1975))) then
			if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((932 + 559) < (1740 - (709 + 387)))) then
				return "consumption drw_up 22";
			end
		end
		if (((2562 - (673 + 1185)) < (2862 - 1875)) and v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (3.1 - 2)) and (v14:BuffStack(v68.HemostasisBuff) < (8 - 3))) then
			if (((2660 + 1058) > (1425 + 481)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(13 - 3))) then
				return "blood_boil drw_up 24";
			end
		end
		if ((v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(1 + 1) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) or ((1910 - 952) > (7135 - 3500))) then
			if (((5381 - (446 + 1434)) <= (5775 - (1040 + 243))) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike drw_up 26";
			end
		end
	end
	local function v92()
		if ((v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (14 - 9)) and (v14:Rune() >= (1849 - (559 + 1288))) and (v14:RunicPowerDeficit() >= (1961 - (609 + 1322))) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (479 - (13 + 441)))) or ((12861 - 9419) < (6674 - 4126))) then
			if (((14318 - 11443) >= (55 + 1409)) and v20(v68.Tombstone)) then
				return "tombstone standard 2";
			end
		end
		v74 = (36 - 26) + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (1 + 1));
		if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (5 + 5)))) or ((14235 - 9438) >= (2678 + 2215))) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(8 - 3)) or ((365 + 186) > (1151 + 917))) then
				return "death_strike standard 4";
			end
		end
		if (((1519 + 595) > (793 + 151)) and v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (4 + 0)) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + (434 - (153 + 280))))) and (v14:RunicPowerDeficit() > (28 - 18)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(3 + 0) > v14:GCD())) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((894 + 1368) >= (1621 + 1475))) then
				return "deaths_caress standard 6";
			end
		end
		if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (4 + 0)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (15 + 5)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) or ((3433 - 1178) >= (2187 + 1350))) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(672 - (89 + 578))) or ((2742 + 1095) < (2714 - 1408))) then
				return "marrowrend standard 8";
			end
		end
		if (((3999 - (572 + 477)) == (398 + 2552)) and v68.Consumption:IsCastable()) then
			if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((2835 + 1888) < (394 + 2904))) then
				return "consumption standard 10";
			end
		end
		if (((1222 - (84 + 2)) >= (253 - 99)) and v68.SoulReaper:IsReady() and (v78 == (1 + 0)) and ((v15:TimeToX(877 - (497 + 345)) < (1 + 4)) or (v15:HealthPercentage() <= (6 + 29))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (1338 - (605 + 728))))) then
			if (v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(4 + 1)) or ((602 - 331) > (218 + 4530))) then
				return "soul_reaper standard 12";
			end
		end
		if (((17524 - 12784) >= (2842 + 310)) and v68.SoulReaper:IsReady() and (v78 >= (5 - 3))) then
			if (v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(4 + 1)) or ((3067 - (457 + 32)) >= (1439 + 1951))) then
				return "soul_reaper standard 14";
			end
		end
		if (((1443 - (832 + 570)) <= (1565 + 96)) and v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (27 + 73))) then
			if (((2126 - 1525) < (1715 + 1845)) and v20(v68.Bonestorm)) then
				return "bonestorm standard 16";
			end
		end
		if (((1031 - (588 + 208)) < (1851 - 1164)) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1801.8 - (884 + 916))) and ((v14:BuffStack(v68.HemostasisBuff) <= ((10 - 5) - v78)) or (v78 > (2 + 0)))) then
			if (((5202 - (232 + 421)) > (3042 - (1569 + 320))) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(3 + 7))) then
				return "blood_boil standard 18";
			end
		end
		if ((v68.HeartStrike:IsReady() and (v14:RuneTimeToX(1 + 3) < v14:GCD())) or ((15750 - 11076) < (5277 - (316 + 289)))) then
			if (((9601 - 5933) < (211 + 4350)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 20";
			end
		end
		if ((v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1454.1 - (666 + 787)))) or ((880 - (360 + 65)) == (3370 + 235))) then
			if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(264 - (79 + 175))) or ((4198 - 1535) == (2585 + 727))) then
				return "blood_boil standard 22";
			end
		end
		if (((13110 - 8833) <= (8618 - 4143)) and v68.HeartStrike:IsReady() and (v14:Rune() > (900 - (503 + 396))) and ((v14:RuneTimeToX(184 - (92 + 89)) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (13 - 6)))) then
			if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((447 + 423) == (704 + 485))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v93()
		v66();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v77 = v14:GetEnemiesInMeleeRange(19 - 14);
		if (((213 + 1340) <= (7143 - 4010)) and v28) then
			v78 = #v77;
		else
			v78 = 1 + 0;
		end
		if (v82.TargetIsValid() or v14:AffectingCombat() or ((1069 + 1168) >= (10693 - 7182))) then
			v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (1 + 4)) or (2 - 0));
			v80 = v84(v77);
			v76 = v14:IsTankingAoE(1252 - (485 + 759)) or v14:IsTanking(v15);
		end
		if (v82.TargetIsValid() or ((3063 - 1739) > (4209 - (442 + 747)))) then
			if (not v14:AffectingCombat() or ((4127 - (832 + 303)) == (2827 - (88 + 858)))) then
				local v137 = 0 + 0;
				local v138;
				while true do
					if (((2571 + 535) > (63 + 1463)) and (v137 == (789 - (766 + 23)))) then
						v138 = v87();
						if (((14923 - 11900) < (5292 - 1422)) and v138) then
							return v138;
						end
						break;
					end
				end
			end
			local v108 = v88();
			if (((376 - 233) > (251 - 177)) and v108) then
				return v108;
			end
			if (((1091 - (1036 + 37)) < (1498 + 614)) and v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (0 - 0)) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 + 0))) then
				if (((2577 - (641 + 839)) <= (2541 - (910 + 3))) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
					return "Pool During Blooddrinker";
				end
			end
			v72 = v62;
			local v108 = v89();
			if (((11803 - 7173) == (6314 - (1466 + 218))) and v108) then
				return v108;
			end
			if (((1627 + 1913) > (3831 - (556 + 592))) and v29 and v68.RaiseDead:IsCastable()) then
				if (((1705 + 3089) >= (4083 - (329 + 479))) and v20(v68.RaiseDead, nil)) then
					return "raise_dead main 4";
				end
			end
			if (((2338 - (174 + 680)) == (5098 - 3614)) and v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) then
				if (((2967 - 1535) < (2539 + 1016)) and v20(v68.VampiricBlood, v57)) then
					return "vampiric_blood main 5";
				end
			end
			if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((1804 - (396 + 343)) > (317 + 3261))) then
				if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((6272 - (29 + 1448)) < (2796 - (135 + 1254)))) then
					return "deaths_caress main 6";
				end
			end
			if (((6980 - 5127) < (22472 - 17659)) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (2 + 1)) or v14:BuffUp(v68.CrimsonScourgeBuff))) then
				if ((v65 == "At Player") or ((4348 - (389 + 1138)) < (3005 - (102 + 472)))) then
					if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(29 + 1)) or ((1594 + 1280) < (2034 + 147))) then
						return "death_and_decay drw_up 16";
					end
				elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(1575 - (320 + 1225))) or ((4786 - 2097) <= (210 + 133))) then
					return "death_and_decay drw_up 16";
				end
			end
			if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (1474 - (157 + 1307))))) or ((3728 - (821 + 1038)) == (5012 - 3003))) then
				if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((388 + 3158) < (4124 - 1802))) then
					return "death_strike main 10";
				end
			end
			if ((v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((775 + 1307) == (11830 - 7057))) then
				if (((4270 - (834 + 192)) > (68 + 987)) and v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker))) then
					return "blooddrinker main 12";
				end
			end
			if (v29 or ((851 + 2462) <= (39 + 1739))) then
				local v139 = 0 - 0;
				local v140;
				while true do
					if ((v139 == (304 - (300 + 4))) or ((380 + 1041) >= (5507 - 3403))) then
						v140 = v90();
						if (((2174 - (112 + 250)) <= (1296 + 1953)) and v140) then
							return v140;
						end
						break;
					end
				end
			end
			if (((4065 - 2442) <= (1122 + 835)) and v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (2 + 0)) or (v15:TimeToDie() < v14:GCD()))) then
				if (((3300 + 1112) == (2188 + 2224)) and v20(v68.SacrificialPact, v48)) then
					return "sacrificial_pact main 14";
				end
			end
			if (((1301 + 449) >= (2256 - (1001 + 413))) and v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (4 - 2)) and (v14:RuneTimeToX(886 - (244 + 638)) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (694.8 - (627 + 66)))) or (v14:RuneTimeToX(8 - 5) > v14:GCD()))) then
				if (((4974 - (512 + 90)) > (3756 - (1665 + 241))) and v20(v68.BloodTap, v58)) then
					return "blood_tap main 16";
				end
			end
			if (((949 - (373 + 344)) < (371 + 450)) and v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) then
				if (((138 + 380) < (2379 - 1477)) and v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp))) then
					return "gorefiends_grasp main 18";
				end
			end
			if (((5066 - 2072) > (1957 - (35 + 1064))) and v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (5 + 1)) and (v14:RunicPowerDeficit() > (10 - 5))) then
				if (v20(v68.EmpowerRuneWeapon) or ((15 + 3740) <= (2151 - (298 + 938)))) then
					return "empower_rune_weapon main 20";
				end
			end
			if (((5205 - (233 + 1026)) > (5409 - (636 + 1030))) and v29 and v68.AbominationLimb:IsCastable()) then
				if (v20(v68.AbominationLimb, nil, not v15:IsInRange(11 + 9)) or ((1304 + 31) >= (983 + 2323))) then
					return "abomination_limb main 22";
				end
			end
			if (((328 + 4516) > (2474 - (55 + 166))) and v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
				if (((88 + 364) == (46 + 406)) and v20(v68.DancingRuneWeapon, v53)) then
					return "dancing_rune_weapon main 24";
				end
			end
			if ((v14:BuffUp(v68.DancingRuneWeaponBuff)) or ((17403 - 12846) < (2384 - (36 + 261)))) then
				local v141 = v91();
				if (((6774 - 2900) == (5242 - (34 + 1334))) and v141) then
					return v141;
				end
				if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((746 + 1192) > (3835 + 1100))) then
					return "Wait/Pool for DRWUp";
				end
			end
			local v108 = v92();
			if (v108 or ((5538 - (1035 + 248)) < (3444 - (20 + 1)))) then
				return v108;
			end
			if (((758 + 696) <= (2810 - (134 + 185))) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v94()
		local v107 = 1133 - (549 + 584);
		while true do
			if ((v107 == (685 - (314 + 371))) or ((14270 - 10113) <= (3771 - (478 + 490)))) then
				v68.MarkofFyralathDebuff:RegisterAuraTracking();
				v10.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(133 + 117, v93, v94);
end;
return v1["Epix_DeathKnight_Blood.lua"](...);

