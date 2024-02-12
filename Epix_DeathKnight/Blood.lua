local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((510 + 396) >= (6586 - 4357))) then
			v6 = v0[v4];
			if (((3640 - 2352) > (66 + 1185)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1053 - (433 + 619))) or ((4676 - (92 + 71)) < (1656 + 1696))) then
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
		v30 = EpicSettings.Settings['UseRacials'];
		v32 = EpicSettings.Settings['UseHealingPotion'];
		v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v34 = EpicSettings.Settings['HealingPotionHP'] or (765 - (574 + 191));
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v37 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptThreshold'] or (849 - (254 + 595));
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
		v54 = EpicSettings.Settings['DeathStrikeGCD'];
		v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
		v56 = EpicSettings.Settings['TombstoneGCD'];
		v57 = EpicSettings.Settings['VampiricBloodGCD'];
		v58 = EpicSettings.Settings['BloodTapOffGCD'];
		v59 = EpicSettings.Settings['RuneTapOffGCD'];
		v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
		v60 = EpicSettings.Settings['RuneTapThreshold'];
		v61 = EpicSettings.Settings['VampiricBloodThreshold'];
		v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (126 - (55 + 71));
		v63 = EpicSettings.Settings['DeathStrikeHealing'] or (0 - 0);
		v65 = EpicSettings.Settings['DnDCast'];
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 180 - 115;
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (1 + 3)) or (8 - 3);
	local v74 = 939 - (714 + 225);
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (52 - (25 + 23))) or (1 + 4);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v122)
		local v123 = 1886 - (927 + 959);
		for v131, v132 in pairs(v122) do
			if (not v132:DebuffUp(v68.BloodPlagueDebuff) or ((6960 - 4895) >= (3928 - (16 + 716)))) then
				v123 = v123 + (1 - 0);
			end
		end
		return v123;
	end
	local function v85(v124)
		return (v124:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v125)
		return ((v125:TimeToX(132 - (11 + 86)) < (12 - 7)) or (v125:HealthPercentage() <= (320 - (175 + 110)))) and (v125:TimeToDie() > (v125:DebuffRemains(v68.SoulReaperDebuff) + (12 - 7)));
	end
	local function v87()
		if (v68.DeathsCaress:IsReady() or ((21583 - 17207) <= (3277 - (503 + 1293)))) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((9473 - 6081) >= (3429 + 1312))) then
				return "deaths_caress precombat 4";
			end
		end
		if (((4386 - (810 + 251)) >= (1495 + 659)) and v68.Marrowrend:IsReady()) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(2 + 3)) or ((1168 + 127) >= (3766 - (43 + 490)))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v88()
		local v126 = 733 - (711 + 22);
		while true do
			if (((16930 - 12553) > (2501 - (240 + 619))) and ((1 + 2) == v126)) then
				if (((7512 - 2789) > (90 + 1266)) and v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= (v63 + (((v14:RunicPower() > v72) and (1764 - (1344 + 400))) or (405 - (255 + 150))))) and not v14:HealingAbsorbed()) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((3258 + 878) <= (1838 + 1595))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((18137 - 13892) <= (14957 - 10326)) and (v126 == (1741 - (404 + 1335)))) then
				if (((4682 - (183 + 223)) >= (4762 - 848)) and v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) then
					if (((132 + 66) <= (1571 + 2794)) and v20(v68.VampiricBlood, v57)) then
						return "vampiric_blood defensives 14";
					end
				end
				if (((5119 - (10 + 327)) > (3257 + 1419)) and v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) then
					if (((5202 - (118 + 220)) > (733 + 1464)) and v20(v68.IceboundFortitude, v55)) then
						return "icebound_fortitude defensives 16";
					end
				end
				v126 = 452 - (108 + 341);
			end
			if ((v126 == (1 + 0)) or ((15642 - 11942) == (4000 - (711 + 782)))) then
				if (((8576 - 4102) >= (743 - (270 + 199))) and v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (1 + 2)) and (v68.RuneTap:Charges() >= (1820 - (580 + 1239))) and v14:BuffDown(v68.RuneTapBuff)) then
					if (v20(v68.RuneTap, v59) or ((5630 - 3736) <= (1345 + 61))) then
						return "rune_tap defensives 2";
					end
				end
				if (((57 + 1515) >= (667 + 864)) and v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (4.5 - 2)) and (v68.DeathStrike:TimeSinceLastCast() > (2.5 + 0))) then
					local v137 = 1167 - (645 + 522);
					while true do
						if (((1791 - (1010 + 780)) == v137) or ((4685 + 2) < (21637 - 17095))) then
							if (((9644 - 6353) > (3503 - (1045 + 791))) and v68.DeathStrike:IsReady()) then
								if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((2209 - 1336) == (3105 - 1071))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
						if ((v137 == (505 - (351 + 154))) or ((4390 - (1281 + 293)) < (277 - (28 + 238)))) then
							if (((8264 - 4565) < (6265 - (1381 + 178))) and v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (7 + 0))) then
								if (((2134 + 512) >= (374 + 502)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (((2116 - 1502) <= (1650 + 1534)) and v68.Marrowrend:IsReady()) then
								if (((3596 - (381 + 89)) == (2773 + 353)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(4 + 1))) then
									return "marrowrend defensives 6";
								end
							end
							v137 = 1 - 0;
						end
					end
				end
				v126 = 1158 - (1074 + 82);
			end
			if ((v126 == (0 - 0)) or ((3971 - (214 + 1570)) >= (6409 - (990 + 465)))) then
				if (((v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) or ((1599 + 2278) == (1556 + 2019))) then
					if (((688 + 19) > (2487 - 1855)) and v10.Press(v70.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v32 and (v14:HealthPercentage() <= v34)) or ((2272 - (1668 + 58)) >= (3310 - (512 + 114)))) then
					if (((3819 - 2354) <= (8891 - 4590)) and (v33 == "Refreshing Healing Potion")) then
						if (((5929 - 4225) > (663 + 762)) and v69.RefreshingHealingPotion:IsReady()) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((129 + 558) == (3681 + 553))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((11231 - 7901) < (3423 - (109 + 1885)))) then
						if (((2616 - (1269 + 200)) >= (642 - 307)) and v69.DreamwalkersHealingPotion:IsReady()) then
							if (((4250 - (98 + 717)) > (2923 - (802 + 24))) and v10.Press(v70.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				v126 = 1 - 0;
			end
		end
	end
	local function v89()
	end
	local function v90()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (1 + 1)) or ((2897 + 873) >= (664 + 3377))) then
				if (v68.AncestralCall:IsCastable() or ((818 + 2973) <= (4481 - 2870))) then
					if (v20(v68.AncestralCall) or ((15266 - 10688) <= (719 + 1289))) then
						return "ancestral_call racials 10";
					end
				end
				if (((458 + 667) <= (1713 + 363)) and v68.Fireblood:IsCastable()) then
					if (v20(v68.Fireblood) or ((541 + 202) >= (2054 + 2345))) then
						return "fireblood racials 12";
					end
				end
				v127 = 1436 - (797 + 636);
			end
			if (((5607 - 4452) < (3292 - (1427 + 192))) and ((2 + 1) == v127)) then
				if (v68.BagofTricks:IsCastable() or ((5395 - 3071) <= (520 + 58))) then
					if (((1708 + 2059) == (4093 - (192 + 134))) and v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks))) then
						return "bag_of_tricks racials 14";
					end
				end
				if (((5365 - (316 + 960)) == (2276 + 1813)) and v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (16 + 4))) then
					if (((4121 + 337) >= (6399 - 4725)) and v20(v68.ArcaneTorrent, nil, not v15:IsInRange(559 - (83 + 468)))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if (((2778 - (1202 + 604)) <= (6619 - 5201)) and (v127 == (1 - 0))) then
				if ((v68.ArcanePulse:IsCastable() and ((v78 >= (5 - 3)) or ((v14:Rune() < (326 - (45 + 280))) and (v14:RunicPowerDeficit() > (58 + 2))))) or ((4315 + 623) < (1739 + 3023))) then
					if (v20(v68.ArcanePulse, nil, not v15:IsInRange(5 + 3)) or ((441 + 2063) > (7895 - 3631))) then
						return "arcane_pulse racials 6";
					end
				end
				if (((4064 - (340 + 1571)) == (850 + 1303)) and v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) then
					if (v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment)) or ((2279 - (1733 + 39)) >= (7119 - 4528))) then
						return "lights_judgment racials 8";
					end
				end
				v127 = 1036 - (125 + 909);
			end
			if (((6429 - (1096 + 852)) == (2011 + 2470)) and (v127 == (0 - 0))) then
				if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((2259 + 69) < (1205 - (409 + 103)))) then
					if (((4564 - (46 + 190)) == (4423 - (51 + 44))) and v20(v68.BloodFury)) then
						return "blood_fury racials 2";
					end
				end
				if (((448 + 1140) >= (2649 - (1114 + 203))) and v68.Berserking:IsCastable()) then
					if (v20(v68.Berserking) or ((4900 - (228 + 498)) > (921 + 3327))) then
						return "berserking racials 4";
					end
				end
				v127 = 1 + 0;
			end
		end
	end
	local function v91()
		if ((v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) or ((5249 - (174 + 489)) <= (213 - 131))) then
			if (((5768 - (830 + 1075)) == (4387 - (303 + 221))) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(1279 - (231 + 1038)))) then
				return "blood_boil drw_up 2";
			end
		end
		if ((v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (5 + 0)) and (v14:Rune() >= (1164 - (171 + 991))) and (v14:RunicPowerDeficit() >= (123 - 93)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) or ((757 - 475) <= (104 - 62))) then
			if (((3689 + 920) >= (2685 - 1919)) and v20(v68.Tombstone)) then
				return "tombstone drw_up 4";
			end
		end
		if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) or ((3322 - 2170) == (4010 - 1522))) then
			if (((10578 - 7156) > (4598 - (111 + 1137))) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(163 - (91 + 67)))) then
				return "death_strike drw_up 6";
			end
		end
		if (((2610 - 1733) > (94 + 282)) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (527 - (423 + 100))) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (1 + 19))) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(13 - 8)) or ((1626 + 1492) <= (2622 - (326 + 445)))) then
				return "marrowrend drw_up 10";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 == (4 - 3)) and ((v15:TimeToX(77 - 42) < (11 - 6)) or (v15:HealthPercentage() <= (746 - (530 + 181)))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (886 - (614 + 267))))) or ((197 - (19 + 13)) >= (5683 - 2191))) then
			if (((9202 - 5253) < (13871 - 9015)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
				return "soul_reaper drw_up 12";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 >= (3 - 1))) or ((8867 - 4591) < (4828 - (1293 + 519)))) then
			if (((9569 - 4879) > (10770 - 6645)) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(9 - 4))) then
				return "soul_reaper drw_up 14";
			end
		end
		if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) or ((215 - 165) >= (2110 - 1214))) then
			if ((v65 == "At Player") or ((908 + 806) >= (604 + 2354))) then
				if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(69 - 39)) or ((345 + 1146) < (214 + 430))) then
					return "death_and_decay drw_up 16";
				end
			elseif (((440 + 264) < (2083 - (709 + 387))) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(1888 - (673 + 1185)))) then
				return "death_and_decay drw_up 16";
			end
		end
		if (((10782 - 7064) > (6120 - 4214)) and v68.BloodBoil:IsCastable() and (v78 > (2 - 0)) and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
			if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(8 + 2)) or ((1293 - 335) > (893 + 2742))) then
				return "blood_boil drw_up 18";
			end
		end
		v75 = (49 - 24) + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (3 - 1));
		if (((5381 - (446 + 1434)) <= (5775 - (1040 + 243))) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((10273 - 6831) < (4395 - (559 + 1288)))) then
				return "death_strike drw_up 20";
			end
		end
		if (((4806 - (609 + 1322)) >= (1918 - (13 + 441))) and v68.Consumption:IsCastable()) then
			if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((17925 - 13128) >= (12816 - 7923))) then
				return "consumption drw_up 22";
			end
		end
		if ((v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (4.1 - 3)) and (v14:BuffStack(v68.HemostasisBuff) < (1 + 4))) or ((2001 - 1450) > (735 + 1333))) then
			if (((927 + 1187) > (2801 - 1857)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(6 + 4))) then
				return "blood_boil drw_up 24";
			end
		end
		if ((v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(3 - 1) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) or ((1496 + 766) >= (1722 + 1374))) then
			if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((1621 + 634) >= (2970 + 567))) then
				return "heart_strike drw_up 26";
			end
		end
	end
	local function v92()
		local v128 = 0 + 0;
		while true do
			if (((435 - (153 + 280)) == v128) or ((11079 - 7242) < (1173 + 133))) then
				if (((1165 + 1785) == (1544 + 1406)) and v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (91 + 9))) then
					if (v20(v68.Bonestorm) or ((3423 + 1300) < (5021 - 1723))) then
						return "bonestorm standard 16";
					end
				end
				if (((703 + 433) >= (821 - (89 + 578))) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((10 - 5) - v78)) or (v78 > (1051 - (572 + 477))))) then
					if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(2 + 8)) or ((163 + 108) > (567 + 4181))) then
						return "blood_boil standard 18";
					end
				end
				if (((4826 - (84 + 2)) >= (5194 - 2042)) and v68.HeartStrike:IsReady() and (v14:RuneTimeToX(3 + 1) < v14:GCD())) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((3420 - (497 + 345)) >= (87 + 3303))) then
						return "heart_strike standard 20";
					end
				end
				if (((7 + 34) <= (2994 - (605 + 728))) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
					if (((1335 - 734) < (164 + 3396)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(36 - 26))) then
						return "blood_boil standard 22";
					end
				end
				v128 = 3 + 0;
			end
			if (((650 - 415) < (519 + 168)) and (v128 == (490 - (457 + 32)))) then
				if (((1931 + 2618) > (2555 - (832 + 570))) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (4 + 0)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (6 + 14)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) then
					if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(17 - 12)) or ((2252 + 2422) < (5468 - (588 + 208)))) then
						return "marrowrend standard 8";
					end
				end
				if (((9886 - 6218) < (6361 - (884 + 916))) and v68.Consumption:IsCastable()) then
					if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((952 - 497) == (2091 + 1514))) then
						return "consumption standard 10";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 == (654 - (232 + 421))) and ((v15:TimeToX(1924 - (1569 + 320)) < (2 + 3)) or (v15:HealthPercentage() <= (7 + 28))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (16 - 11)))) or ((3268 - (316 + 289)) == (8669 - 5357))) then
					if (((198 + 4079) <= (5928 - (666 + 787))) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(430 - (360 + 65)))) then
						return "soul_reaper standard 12";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 >= (2 + 0))) or ((1124 - (79 + 175)) == (1874 - 685))) then
					if (((1212 + 341) <= (9603 - 6470)) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(9 - 4))) then
						return "soul_reaper standard 14";
					end
				end
				v128 = 901 - (503 + 396);
			end
			if ((v128 == (184 - (92 + 89))) or ((4339 - 2102) >= (1801 + 1710))) then
				if ((v68.HeartStrike:IsReady() and (v14:Rune() > (1 + 0)) and ((v14:RuneTimeToX(11 - 8) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (1 + 6)))) or ((3018 - 1694) > (2635 + 385))) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((1430 + 1562) == (5728 - 3847))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
			if (((388 + 2718) > (2326 - 800)) and (v128 == (1244 - (485 + 759)))) then
				if (((6994 - 3971) < (5059 - (442 + 747))) and v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (1140 - (832 + 303))) and (v14:Rune() >= (948 - (88 + 858))) and (v14:RunicPowerDeficit() >= (10 + 20)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (21 + 4))) then
					if (((6 + 137) > (863 - (766 + 23))) and v20(v68.Tombstone)) then
						return "tombstone standard 2";
					end
				end
				v74 = (49 - 39) + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (2 - 0));
				if (((47 - 29) < (7168 - 5056)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (1083 - (1036 + 37))))) then
					if (((778 + 319) <= (3169 - 1541)) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(4 + 1))) then
						return "death_strike standard 4";
					end
				end
				if (((6110 - (641 + 839)) == (5543 - (910 + 3))) and v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (9 - 5)) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + (1685 - (1466 + 218))))) and (v14:RunicPowerDeficit() > (5 + 5)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(1151 - (556 + 592)) > v14:GCD())) then
					if (((1259 + 2281) > (3491 - (329 + 479))) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
						return "deaths_caress standard 6";
					end
				end
				v128 = 855 - (174 + 680);
			end
		end
	end
	local function v93()
		local v129 = 0 - 0;
		while true do
			if (((9936 - 5142) >= (2339 + 936)) and ((740 - (396 + 343)) == v129)) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v129 = 1 + 1;
			end
			if (((2961 - (29 + 1448)) == (2873 - (135 + 1254))) and (v129 == (0 - 0))) then
				v66();
				v27 = EpicSettings.Toggles['ooc'];
				v129 = 4 - 3;
			end
			if (((955 + 477) < (5082 - (389 + 1138))) and ((577 - (102 + 472)) == v129)) then
				if (v82.TargetIsValid() or v14:AffectingCombat() or ((1006 + 59) > (1985 + 1593))) then
					local v138 = 0 + 0;
					while true do
						if ((v138 == (1545 - (320 + 1225))) or ((8536 - 3741) < (861 + 546))) then
							v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (1469 - (157 + 1307))) or (1861 - (821 + 1038)));
							v80 = v84(v77);
							v138 = 2 - 1;
						end
						if (((203 + 1650) < (8548 - 3735)) and (v138 == (1 + 0))) then
							v76 = v14:IsTankingAoE(19 - 11) or v14:IsTanking(v15);
							break;
						end
					end
				end
				if (v82.TargetIsValid() or ((3847 - (834 + 192)) < (155 + 2276))) then
					local v139 = 0 + 0;
					local v140;
					while true do
						if ((v139 == (1 + 4)) or ((4451 - 1577) < (2485 - (300 + 4)))) then
							if ((v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (2 + 4)) and (v14:RunicPowerDeficit() > (13 - 8))) or ((3051 - (112 + 250)) <= (137 + 206))) then
								if (v20(v68.EmpowerRuneWeapon) or ((4681 - 2812) == (1151 + 858))) then
									return "empower_rune_weapon main 20";
								end
							end
							if ((v29 and v68.AbominationLimb:IsCastable()) or ((1834 + 1712) < (1737 + 585))) then
								if (v20(v68.AbominationLimb, nil, not v15:IsInRange(10 + 10)) or ((1547 + 535) == (6187 - (1001 + 413)))) then
									return "abomination_limb main 22";
								end
							end
							if (((7233 - 3989) > (1937 - (244 + 638))) and v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
								if (v20(v68.DancingRuneWeapon, v53) or ((4006 - (627 + 66)) <= (5297 - 3519))) then
									return "dancing_rune_weapon main 24";
								end
							end
							v139 = 608 - (512 + 90);
						end
						if ((v139 == (1906 - (1665 + 241))) or ((2138 - (373 + 344)) >= (949 + 1155))) then
							if (((480 + 1332) <= (8569 - 5320)) and not v14:AffectingCombat()) then
								local v141 = 0 - 0;
								local v142;
								while true do
									if (((2722 - (35 + 1064)) <= (1424 + 533)) and (v141 == (0 - 0))) then
										v142 = v87();
										if (((18 + 4394) == (5648 - (298 + 938))) and v142) then
											return v142;
										end
										break;
									end
								end
							end
							if (((3009 - (233 + 1026)) >= (2508 - (636 + 1030))) and v76) then
								local v143 = v88();
								if (((2236 + 2136) > (1808 + 42)) and v143) then
									return v143;
								end
							end
							if (((69 + 163) < (56 + 765)) and v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (221 - (55 + 166))) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 + 0))) then
								if (((53 + 465) < (3444 - 2542)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
									return "Pool During Blooddrinker";
								end
							end
							v139 = 298 - (36 + 261);
						end
						if (((5235 - 2241) > (2226 - (34 + 1334))) and (v139 == (3 + 4))) then
							if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((2918 + 837) <= (2198 - (1035 + 248)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((3967 - (20 + 1)) > (1951 + 1792)) and (v139 == (322 - (134 + 185)))) then
							if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (1143 - (549 + 584))))) or ((2020 - (314 + 371)) >= (11349 - 8043))) then
								if (((5812 - (478 + 490)) > (1194 + 1059)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
									return "death_strike main 10";
								end
							end
							if (((1624 - (786 + 386)) == (1463 - 1011)) and v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
								if (v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker)) or ((5936 - (1055 + 324)) < (3427 - (1093 + 247)))) then
									return "blooddrinker main 12";
								end
							end
							if (((3443 + 431) == (408 + 3466)) and v29) then
								local v144 = 0 - 0;
								local v145;
								while true do
									if ((v144 == (0 - 0)) or ((5514 - 3576) > (12401 - 7466))) then
										v145 = v90();
										if (v145 or ((1514 + 2741) < (13186 - 9763))) then
											return v145;
										end
										break;
									end
								end
							end
							v139 = 13 - 9;
						end
						if (((1097 + 357) <= (6370 - 3879)) and (v139 == (694 - (364 + 324)))) then
							if ((v14:BuffUp(v68.DancingRuneWeaponBuff)) or ((11395 - 7238) <= (6725 - 3922))) then
								local v146 = 0 + 0;
								local v147;
								while true do
									if (((20306 - 15453) >= (4775 - 1793)) and (v146 == (0 - 0))) then
										v147 = v91();
										if (((5402 - (1249 + 19)) > (3031 + 326)) and v147) then
											return v147;
										end
										v146 = 3 - 2;
									end
									if ((v146 == (1087 - (686 + 400))) or ((2681 + 736) < (2763 - (73 + 156)))) then
										if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((13 + 2709) <= (975 - (721 + 90)))) then
											return "Wait/Pool for DRWUp";
										end
										break;
									end
								end
							end
							v140 = v92();
							if (v140 or ((28 + 2380) < (6847 - 4738))) then
								return v140;
							end
							v139 = 477 - (224 + 246);
						end
						if ((v139 == (5 - 1)) or ((60 - 27) == (264 + 1191))) then
							if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (1 + 1)) or (v15:TimeToDie() < v14:GCD()))) or ((326 + 117) >= (7982 - 3967))) then
								if (((11254 - 7872) > (679 - (203 + 310))) and v20(v68.SacrificialPact, v48)) then
									return "sacrificial_pact main 14";
								end
							end
							if ((v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (1995 - (1238 + 755))) and (v14:RuneTimeToX(1 + 3) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (1535.8 - (709 + 825)))) or (v14:RuneTimeToX(4 - 1) > v14:GCD()))) or ((407 - 127) == (3923 - (196 + 668)))) then
								if (((7426 - 5545) > (2678 - 1385)) and v20(v68.BloodTap, v58)) then
									return "blood_tap main 16";
								end
							end
							if (((3190 - (171 + 662)) == (2450 - (4 + 89))) and v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) then
								if (((430 - 307) == (45 + 78)) and v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp))) then
									return "gorefiends_grasp main 18";
								end
							end
							v139 = 21 - 16;
						end
						if ((v139 == (1 + 0)) or ((2542 - (35 + 1451)) >= (4845 - (28 + 1425)))) then
							v72 = v62;
							if (v31 or ((3074 - (941 + 1052)) < (1031 + 44))) then
								local v148 = 1514 - (822 + 692);
								local v149;
								while true do
									if ((v148 == (0 - 0)) or ((495 + 554) >= (4729 - (45 + 252)))) then
										v149 = v89();
										if (v149 or ((4718 + 50) <= (292 + 554))) then
											return v149;
										end
										break;
									end
								end
							end
							if ((v29 and v68.RaiseDead:IsCastable()) or ((8172 - 4814) <= (1853 - (114 + 319)))) then
								if (v20(v68.RaiseDead, nil) or ((5367 - 1628) <= (3850 - 845))) then
									return "raise_dead main 4";
								end
							end
							v139 = 2 + 0;
						end
						if ((v139 == (2 - 0)) or ((3475 - 1816) >= (4097 - (556 + 1407)))) then
							if ((v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) or ((4466 - (741 + 465)) < (2820 - (170 + 295)))) then
								if (v20(v68.VampiricBlood, v57) or ((353 + 316) == (3879 + 344))) then
									return "vampiric_blood main 5";
								end
							end
							if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((4165 - 2473) < (488 + 100))) then
								if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((3077 + 1720) < (2068 + 1583))) then
									return "deaths_caress main 6";
								end
							end
							if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (1233 - (957 + 273))) or v14:BuffUp(v68.CrimsonScourgeBuff))) or ((1118 + 3059) > (1942 + 2908))) then
								if ((v65 == "At Player") or ((1524 - 1124) > (2927 - 1816))) then
									if (((9319 - 6268) > (4976 - 3971)) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(1810 - (389 + 1391)))) then
										return "death_and_decay drw_up 16";
									end
								elseif (((2317 + 1376) <= (457 + 3925)) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(68 - 38))) then
									return "death_and_decay drw_up 16";
								end
							end
							v139 = 954 - (783 + 168);
						end
					end
				end
				break;
			end
			if ((v129 == (6 - 4)) or ((3229 + 53) > (4411 - (309 + 2)))) then
				v77 = v14:GetEnemiesInMeleeRange(15 - 10);
				if (v28 or ((4792 - (1090 + 122)) < (923 + 1921))) then
					v78 = #v77;
				else
					v78 = 3 - 2;
				end
				v129 = 3 + 0;
			end
		end
	end
	local function v94()
		local v130 = 1118 - (628 + 490);
		while true do
			if (((16 + 73) < (11116 - 6626)) and (v130 == (0 - 0))) then
				v68.MarkofFyralathDebuff:RegisterAuraTracking();
				v10.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(1024 - (431 + 343), v93, v94);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

