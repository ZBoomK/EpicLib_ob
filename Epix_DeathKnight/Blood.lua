local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2069 + 1437) <= (1472 - (92 + 71)))) then
			v6 = v0[v4];
			if (((1460 + 1495) == (4968 - 2013)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 766 - (574 + 191);
		end
		if ((v5 == (1 + 0)) or ((7272 - 4369) == (764 + 731))) then
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
		local v95 = 849 - (254 + 595);
		while true do
			if (((4672 - (55 + 71)) >= (2996 - 721)) and (v95 == (1793 - (573 + 1217)))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v95 = 10 - 6;
			end
			if (((63 + 756) >= (34 - 12)) and (v95 == (943 - (714 + 225)))) then
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v95 = 14 - 9;
			end
			if (((4407 - 1245) == (343 + 2819)) and (v95 == (11 - 3))) then
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (806 - (118 + 688));
				v63 = EpicSettings.Settings['DeathStrikeHealing'] or (48 - (25 + 23));
				v65 = EpicSettings.Settings['DnDCast'];
				break;
			end
			if ((v95 == (0 + 0)) or ((4255 - (927 + 959)) > (14929 - 10500))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (732 - (16 + 716));
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v95 = 98 - (11 + 86);
			end
			if (((9988 - 5893) >= (3468 - (175 + 110))) and (v95 == (17 - 10))) then
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v95 = 39 - 31;
			end
			if ((v95 == (1798 - (503 + 1293))) or ((10364 - 6653) < (729 + 279))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1061 - (810 + 251));
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v95 = 3 + 0;
			end
			if ((v95 == (1 + 0)) or ((946 + 103) <= (1439 - (43 + 490)))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (733 - (711 + 22));
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (859 - (240 + 619));
				v95 = 1 + 1;
			end
			if (((7178 - 2665) > (181 + 2545)) and (v95 == (1750 - (1344 + 400)))) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v95 = 412 - (255 + 150);
			end
			if ((v95 == (4 + 1)) or ((793 + 688) >= (11356 - 8698))) then
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = EpicSettings.Settings['DeathStrikeGCD'];
				v95 = 19 - 13;
			end
		end
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 471 - (183 + 223);
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (4 - 0)) or (4 + 1);
	local v74 = 0 + 0;
	local v75 = 337 - (10 + 327);
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (2 + 2)) or (21 - 16);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v96)
		local v97 = 1493 - (711 + 782);
		local v98;
		while true do
			if (((1 - 0) == v97) or ((3689 - (270 + 199)) == (443 + 921))) then
				return v98;
			end
			if ((v97 == (1819 - (580 + 1239))) or ((3133 - 2079) > (3244 + 148))) then
				v98 = 0 + 0;
				for v138, v139 in pairs(v96) do
					if (not v139:DebuffUp(v68.BloodPlagueDebuff) or ((295 + 381) >= (4286 - 2644))) then
						v98 = v98 + 1 + 0;
					end
				end
				v97 = 1168 - (645 + 522);
			end
		end
	end
	local function v85(v99)
		return (v99:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v100)
		return ((v100:TimeToX(1825 - (1010 + 780)) < (5 + 0)) or (v100:HealthPercentage() <= (166 - 131))) and (v100:TimeToDie() > (v100:DebuffRemains(v68.SoulReaperDebuff) + (14 - 9)));
	end
	local function v87()
		if (((5972 - (1045 + 791)) > (6067 - 3670)) and v68.DeathsCaress:IsReady()) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((6617 - 2283) == (4750 - (351 + 154)))) then
				return "deaths_caress precombat 4";
			end
		end
		if (v68.Marrowrend:IsReady() or ((5850 - (1281 + 293)) <= (3297 - (28 + 238)))) then
			if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(10 - 5)) or ((6341 - (1381 + 178)) <= (1125 + 74))) then
				return "marrowrend precombat 6";
			end
		end
	end
	local function v88()
		local v101 = 0 + 0;
		while true do
			if ((v101 == (1 + 0)) or ((16768 - 11904) < (986 + 916))) then
				if (((5309 - (381 + 89)) >= (3282 + 418)) and v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (3 + 0)) and (v68.RuneTap:Charges() >= (1 - 0)) and v14:BuffDown(v68.RuneTapBuff)) then
					if (v20(v68.RuneTap, v59) or ((2231 - (1074 + 82)) > (4203 - 2285))) then
						return "rune_tap defensives 2";
					end
				end
				if (((2180 - (214 + 1570)) <= (5259 - (990 + 465))) and v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (1.5 + 1)) and (v68.DeathStrike:TimeSinceLastCast() > (1.5 + 1))) then
					if ((v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (7 + 0))) or ((16407 - 12238) == (3913 - (1668 + 58)))) then
						if (((2032 - (512 + 114)) == (3665 - 2259)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
							return "death_strike defensives 4";
						end
					end
					if (((3164 - 1633) < (14861 - 10590)) and v68.Marrowrend:IsReady()) then
						if (((296 + 339) == (119 + 516)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(5 + 0))) then
							return "marrowrend defensives 6";
						end
					end
					if (((11376 - 8003) <= (5550 - (109 + 1885))) and v68.DeathStrike:IsReady()) then
						if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((4760 - (1269 + 200)) < (6286 - 3006))) then
							return "death_strike defensives 10";
						end
					end
				end
				v101 = 817 - (98 + 717);
			end
			if (((5212 - (802 + 24)) >= (1505 - 632)) and (v101 == (2 - 0))) then
				if (((137 + 784) <= (847 + 255)) and v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) then
					if (((773 + 3933) >= (208 + 755)) and v20(v68.VampiricBlood, v57)) then
						return "vampiric_blood defensives 14";
					end
				end
				if ((v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) or ((2670 - 1710) <= (2921 - 2045))) then
					if (v20(v68.IceboundFortitude, v55) or ((739 + 1327) == (380 + 552))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v101 = 3 + 0;
			end
			if (((3509 + 1316) < (2262 + 2581)) and ((1436 - (797 + 636)) == v101)) then
				if ((v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= v63)) or ((18824 - 14947) >= (6156 - (1427 + 192)))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((1496 + 2819) < (4007 - 2281))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if ((v101 == (0 + 0)) or ((1668 + 2011) < (951 - (192 + 134)))) then
				if (((v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) or ((5901 - (316 + 960)) < (352 + 280))) then
					if (v10.Press(v70.Healthstone, nil, nil, true) or ((65 + 18) > (1646 + 134))) then
						return "healthstone defensive 3";
					end
				end
				if (((2087 - 1541) <= (1628 - (83 + 468))) and v32 and (v14:HealthPercentage() <= v34)) then
					if ((v33 == "Refreshing Healing Potion") or ((2802 - (1202 + 604)) > (20077 - 15776))) then
						if (((6773 - 2703) > (1902 - 1215)) and v69.RefreshingHealingPotion:IsReady()) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((981 - (45 + 280)) >= (3215 + 115))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((2178 + 314) <= (123 + 212))) then
						if (((2392 + 1930) >= (451 + 2111)) and v69.DreamwalkersHealingPotion:IsReady()) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((6734 - 3097) >= (5681 - (340 + 1571)))) then
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
	end
	local function v90()
		local v102 = 1772 - (1733 + 39);
		while true do
			if ((v102 == (0 - 0)) or ((3413 - (125 + 909)) > (6526 - (1096 + 852)))) then
				if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((217 + 266) > (1060 - 317))) then
					if (((2381 + 73) > (1090 - (409 + 103))) and v20(v68.BloodFury)) then
						return "blood_fury racials 2";
					end
				end
				if (((1166 - (46 + 190)) < (4553 - (51 + 44))) and v68.Berserking:IsCastable()) then
					if (((187 + 475) <= (2289 - (1114 + 203))) and v20(v68.Berserking)) then
						return "berserking racials 4";
					end
				end
				v102 = 727 - (228 + 498);
			end
			if (((947 + 3423) == (2415 + 1955)) and (v102 == (665 - (174 + 489)))) then
				if (v68.AncestralCall:IsCastable() or ((12406 - 7644) <= (2766 - (830 + 1075)))) then
					if (v20(v68.AncestralCall) or ((1936 - (303 + 221)) == (5533 - (231 + 1038)))) then
						return "ancestral_call racials 10";
					end
				end
				if (v68.Fireblood:IsCastable() or ((2640 + 528) < (3315 - (171 + 991)))) then
					if (v20(v68.Fireblood) or ((20506 - 15530) < (3576 - 2244))) then
						return "fireblood racials 12";
					end
				end
				v102 = 7 - 4;
			end
			if (((3704 + 924) == (16222 - 11594)) and (v102 == (2 - 1))) then
				if ((v68.ArcanePulse:IsCastable() and ((v78 >= (2 - 0)) or ((v14:Rune() < (3 - 2)) and (v14:RunicPowerDeficit() > (1308 - (111 + 1137)))))) or ((212 - (91 + 67)) == (1175 - 780))) then
					if (((21 + 61) == (605 - (423 + 100))) and v20(v68.ArcanePulse, nil, not v15:IsInRange(1 + 7))) then
						return "arcane_pulse racials 6";
					end
				end
				if ((v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) or ((1608 - 1027) < (147 + 135))) then
					if (v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment)) or ((5380 - (326 + 445)) < (10888 - 8393))) then
						return "lights_judgment racials 8";
					end
				end
				v102 = 4 - 2;
			end
			if (((2688 - 1536) == (1863 - (530 + 181))) and (v102 == (884 - (614 + 267)))) then
				if (((1928 - (19 + 13)) <= (5569 - 2147)) and v68.BagofTricks:IsCastable()) then
					if (v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks)) or ((2307 - 1317) > (4627 - 3007))) then
						return "bag_of_tricks racials 14";
					end
				end
				if ((v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (6 + 14))) or ((1542 - 665) > (9736 - 5041))) then
					if (((4503 - (1293 + 519)) >= (3776 - 1925)) and v20(v68.ArcaneTorrent, nil, not v15:IsInRange(20 - 12))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
		end
	end
	local function v91()
		local v103 = 0 - 0;
		while true do
			if ((v103 == (12 - 9)) or ((7031 - 4046) >= (2572 + 2284))) then
				if (((873 + 3403) >= (2776 - 1581)) and v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(1 + 1) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) then
					if (((1074 + 2158) <= (2931 + 1759)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if ((v103 == (1097 - (709 + 387))) or ((2754 - (673 + 1185)) >= (9123 - 5977))) then
				if (((9829 - 6768) >= (4866 - 1908)) and v68.SoulReaper:IsReady() and (v78 == (1 + 0)) and ((v15:TimeToX(27 + 8) < (6 - 1)) or (v15:HealthPercentage() <= (9 + 26))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (9 - 4)))) then
					if (((6256 - 3069) >= (2524 - (446 + 1434))) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(1288 - (1040 + 243)))) then
						return "soul_reaper drw_up 12";
					end
				end
				if (((1922 - 1278) <= (2551 - (559 + 1288))) and v68.SoulReaper:IsReady() and (v78 >= (1933 - (609 + 1322)))) then
					if (((1412 - (13 + 441)) > (3538 - 2591)) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(13 - 8))) then
						return "soul_reaper drw_up 14";
					end
				end
				if (((22372 - 17880) >= (99 + 2555)) and v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) then
					if (((12500 - 9058) >= (534 + 969)) and (v65 == "At Player")) then
						if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(14 + 16)) or ((9407 - 6237) <= (802 + 662))) then
							return "death_and_decay drw_up 16";
						end
					elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(55 - 25)) or ((3172 + 1625) == (2441 + 1947))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((396 + 155) <= (572 + 109)) and v68.BloodBoil:IsCastable() and (v78 > (2 + 0)) and (v68.BloodBoil:ChargesFractional() >= (434.1 - (153 + 280)))) then
					if (((9462 - 6185) > (366 + 41)) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(4 + 6))) then
						return "blood_boil drw_up 18";
					end
				end
				v103 = 2 + 0;
			end
			if (((4261 + 434) >= (1026 + 389)) and (v103 == (0 - 0))) then
				if ((v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) or ((1986 + 1226) <= (1611 - (89 + 578)))) then
					if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(8 + 2)) or ((6435 - 3339) <= (2847 - (572 + 477)))) then
						return "blood_boil drw_up 2";
					end
				end
				if (((478 + 3059) == (2123 + 1414)) and v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (1 + 4)) and (v14:Rune() >= (88 - (84 + 2))) and (v14:RunicPowerDeficit() >= (49 - 19)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) then
					if (((2765 + 1072) >= (2412 - (497 + 345))) and v20(v68.Tombstone)) then
						return "tombstone drw_up 4";
					end
				end
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) or ((76 + 2874) == (645 + 3167))) then
					if (((6056 - (605 + 728)) >= (1654 + 664)) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(11 - 6))) then
						return "death_strike drw_up 6";
					end
				end
				if ((v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (1 + 3)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (73 - 53))) or ((1828 + 199) > (7901 - 5049))) then
					if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(4 + 1)) or ((1625 - (457 + 32)) > (1832 + 2485))) then
						return "marrowrend drw_up 10";
					end
				end
				v103 = 1403 - (832 + 570);
			end
			if (((4474 + 274) == (1239 + 3509)) and (v103 == (6 - 4))) then
				v75 = 13 + 12 + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (798 - (588 + 208)));
				if (((10069 - 6333) <= (6540 - (884 + 916))) and v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) then
					if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((7097 - 3707) <= (1775 + 1285))) then
						return "death_strike drw_up 20";
					end
				end
				if (v68.Consumption:IsCastable() or ((1652 - (232 + 421)) > (4582 - (1569 + 320)))) then
					if (((114 + 349) < (115 + 486)) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption drw_up 22";
					end
				end
				if ((v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (3.1 - 2)) and (v14:BuffStack(v68.HemostasisBuff) < (610 - (316 + 289)))) or ((5714 - 3531) < (32 + 655))) then
					if (((6002 - (666 + 787)) == (4974 - (360 + 65))) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(10 + 0))) then
						return "blood_boil drw_up 24";
					end
				end
				v103 = 257 - (79 + 175);
			end
		end
	end
	local function v92()
		if (((7366 - 2694) == (3646 + 1026)) and v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (15 - 10)) and (v14:Rune() >= (3 - 1)) and (v14:RunicPowerDeficit() >= (929 - (503 + 396))) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (206 - (92 + 89)))) then
			if (v20(v68.Tombstone) or ((7115 - 3447) < (203 + 192))) then
				return "tombstone standard 2";
			end
		end
		v74 = 6 + 4 + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (7 - 5));
		if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (2 + 8)))) or ((9498 - 5332) == (397 + 58))) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(3 + 2)) or ((13549 - 9100) == (333 + 2330))) then
				return "death_strike standard 4";
			end
		end
		if ((v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (5 - 1)) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + (1245 - (485 + 759))))) and (v14:RunicPowerDeficit() > (23 - 13)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(1192 - (442 + 747)) > v14:GCD())) or ((5412 - (832 + 303)) < (3935 - (88 + 858)))) then
			if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((266 + 604) >= (3434 + 715))) then
				return "deaths_caress standard 6";
			end
		end
		if (((92 + 2120) < (3972 - (766 + 23))) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (19 - 15)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (27 - 7)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) then
			if (((12240 - 7594) > (10154 - 7162)) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1078 - (1036 + 37)))) then
				return "marrowrend standard 8";
			end
		end
		if (((1017 + 417) < (6048 - 2942)) and v68.Consumption:IsCastable()) then
			if (((619 + 167) < (4503 - (641 + 839))) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
				return "consumption standard 10";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 == (914 - (910 + 3))) and ((v15:TimeToX(89 - 54) < (1689 - (1466 + 218))) or (v15:HealthPercentage() <= (17 + 18))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (1153 - (556 + 592))))) or ((869 + 1573) < (882 - (329 + 479)))) then
			if (((5389 - (174 + 680)) == (15583 - 11048)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(10 - 5))) then
				return "soul_reaper standard 12";
			end
		end
		if ((v68.SoulReaper:IsReady() and (v78 >= (2 + 0))) or ((3748 - (396 + 343)) <= (187 + 1918))) then
			if (((3307 - (29 + 1448)) < (5058 - (135 + 1254))) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(18 - 13))) then
				return "soul_reaper standard 14";
			end
		end
		if ((v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (466 - 366))) or ((954 + 476) >= (5139 - (389 + 1138)))) then
			if (((3257 - (102 + 472)) >= (2322 + 138)) and v20(v68.Bonestorm)) then
				return "bonestorm standard 16";
			end
		end
		if ((v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((5 + 0) - v78)) or (v78 > (1547 - (320 + 1225))))) or ((3211 - 1407) >= (2004 + 1271))) then
			if (v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1474 - (157 + 1307))) or ((3276 - (821 + 1038)) > (9054 - 5425))) then
				return "blood_boil standard 18";
			end
		end
		if (((525 + 4270) > (713 - 311)) and v68.HeartStrike:IsReady() and (v14:RuneTimeToX(2 + 2) < v14:GCD())) then
			if (((11929 - 7116) > (4591 - (834 + 192))) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 20";
			end
		end
		if (((249 + 3663) == (1005 + 2907)) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.1 + 0))) then
			if (((4369 - 1548) <= (5128 - (300 + 4))) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(3 + 7))) then
				return "blood_boil standard 22";
			end
		end
		if (((4549 - 2811) <= (2557 - (112 + 250))) and v68.HeartStrike:IsReady() and (v14:Rune() > (1 + 0)) and ((v14:RuneTimeToX(7 - 4) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (5 + 2)))) then
			if (((22 + 19) <= (2258 + 760)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v93()
		v66();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v77 = v14:GetEnemiesInMeleeRange(3 + 2);
		if (((1594 + 551) <= (5518 - (1001 + 413))) and v28) then
			v78 = #v77;
		else
			v78 = 2 - 1;
		end
		if (((3571 - (244 + 638)) < (5538 - (627 + 66))) and (v82.TargetIsValid() or v14:AffectingCombat())) then
			v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (14 - 9)) or (604 - (512 + 90)));
			v80 = v84(v77);
			v76 = v14:IsTankingAoE(1914 - (1665 + 241)) or v14:IsTanking(v15);
		end
		if (v82.TargetIsValid() or ((3039 - (373 + 344)) > (1183 + 1439))) then
			local v109 = 0 + 0;
			local v110;
			while true do
				if ((v109 == (0 - 0)) or ((7672 - 3138) == (3181 - (35 + 1064)))) then
					if (not v14:AffectingCombat() or ((1144 + 427) > (3994 - 2127))) then
						local v140 = 0 + 0;
						local v141;
						while true do
							if ((v140 == (1236 - (298 + 938))) or ((3913 - (233 + 1026)) >= (4662 - (636 + 1030)))) then
								v141 = v87();
								if (((2034 + 1944) > (2056 + 48)) and v141) then
									return v141;
								end
								break;
							end
						end
					end
					v110 = v88();
					if (((890 + 2105) > (105 + 1436)) and v110) then
						return v110;
					end
					v109 = 222 - (55 + 166);
				end
				if (((630 + 2619) > (96 + 857)) and (v109 == (11 - 8))) then
					if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (300 - (36 + 261))) or v14:BuffUp(v68.CrimsonScourgeBuff))) or ((5723 - 2450) > (5941 - (34 + 1334)))) then
						if ((v65 == "At Player") or ((1212 + 1939) < (998 + 286))) then
							if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(1313 - (1035 + 248))) or ((1871 - (20 + 1)) == (797 + 732))) then
								return "death_and_decay drw_up 16";
							end
						elseif (((1140 - (134 + 185)) < (3256 - (549 + 584))) and v20(v70.DaDCursor, v46, nil, not v15:IsInRange(715 - (314 + 371)))) then
							return "death_and_decay drw_up 16";
						end
					end
					if (((3096 - 2194) < (3293 - (478 + 490))) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (6 + 4)))) then
						if (((2030 - (786 + 386)) <= (9593 - 6631)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
							return "death_strike main 10";
						end
					end
					if ((v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((5325 - (1055 + 324)) < (2628 - (1093 + 247)))) then
						if (v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker)) or ((2881 + 361) == (60 + 507))) then
							return "blooddrinker main 12";
						end
					end
					v109 = 15 - 11;
				end
				if ((v109 == (23 - 16)) or ((2409 - 1562) >= (3173 - 1910))) then
					if (v110 or ((802 + 1451) == (7130 - 5279))) then
						return v110;
					end
					if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((7193 - 5106) > (1789 + 583))) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if ((v109 == (15 - 9)) or ((5133 - (364 + 324)) < (11373 - 7224))) then
					if ((v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((4362 - 2544) == (29 + 56))) then
						if (((2636 - 2006) < (3405 - 1278)) and v20(v68.DancingRuneWeapon, v53)) then
							return "dancing_rune_weapon main 24";
						end
					end
					if ((v14:BuffUp(v68.DancingRuneWeaponBuff)) or ((5885 - 3947) == (3782 - (1249 + 19)))) then
						local v142 = v91();
						if (((3841 + 414) >= (214 - 159)) and v142) then
							return v142;
						end
						if (((4085 - (686 + 400)) > (907 + 249)) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
							return "Wait/Pool for DRWUp";
						end
					end
					v110 = v92();
					v109 = 236 - (73 + 156);
				end
				if (((12 + 2338) > (1966 - (721 + 90))) and (v109 == (1 + 4))) then
					if (((13081 - 9052) <= (5323 - (224 + 246))) and v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) then
						if (v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp)) or ((835 - 319) > (6322 - 2888))) then
							return "gorefiends_grasp main 18";
						end
					end
					if (((734 + 3312) >= (73 + 2960)) and v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (5 + 1)) and (v14:RunicPowerDeficit() > (9 - 4))) then
						if (v20(v68.EmpowerRuneWeapon) or ((9048 - 6329) <= (1960 - (203 + 310)))) then
							return "empower_rune_weapon main 20";
						end
					end
					if ((v29 and v68.AbominationLimb:IsCastable()) or ((6127 - (1238 + 755)) < (275 + 3651))) then
						if (v20(v68.AbominationLimb, nil, not v15:IsInRange(1554 - (709 + 825))) or ((302 - 138) >= (4056 - 1271))) then
							return "abomination_limb main 22";
						end
					end
					v109 = 870 - (196 + 668);
				end
				if ((v109 == (3 - 2)) or ((1087 - 562) == (2942 - (171 + 662)))) then
					if (((126 - (4 + 89)) == (115 - 82)) and v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (0 + 0)) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 - 0))) then
						if (((1198 + 1856) <= (5501 - (35 + 1451))) and v10.CastAnnotated(v68.Pool, false, "WAIT")) then
							return "Pool During Blooddrinker";
						end
					end
					v72 = v62;
					if (((3324 - (28 + 1425)) < (5375 - (941 + 1052))) and v31) then
						local v143 = 0 + 0;
						local v144;
						while true do
							if (((2807 - (822 + 692)) <= (3091 - 925)) and ((0 + 0) == v143)) then
								v144 = v89();
								if (v144 or ((2876 - (45 + 252)) < (122 + 1))) then
									return v144;
								end
								break;
							end
						end
					end
					v109 = 1 + 1;
				end
				if ((v109 == (9 - 5)) or ((1279 - (114 + 319)) >= (3399 - 1031))) then
					if (v29 or ((5140 - 1128) <= (2141 + 1217))) then
						local v145 = v90();
						if (((2225 - 731) <= (6296 - 3291)) and v145) then
							return v145;
						end
					end
					if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (1965 - (556 + 1407))) or (v15:TimeToDie() < v14:GCD()))) or ((4317 - (741 + 465)) == (2599 - (170 + 295)))) then
						if (((1241 + 1114) == (2164 + 191)) and v20(v68.SacrificialPact, v48)) then
							return "sacrificial_pact main 14";
						end
					end
					if ((v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (4 - 2)) and (v14:RuneTimeToX(4 + 0) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (1.8 + 0))) or (v14:RuneTimeToX(2 + 1) > v14:GCD()))) or ((1818 - (957 + 273)) <= (116 + 316))) then
						if (((1921 + 2876) >= (14841 - 10946)) and v20(v68.BloodTap, v58)) then
							return "blood_tap main 16";
						end
					end
					v109 = 13 - 8;
				end
				if (((10925 - 7348) == (17712 - 14135)) and (v109 == (1782 - (389 + 1391)))) then
					if (((2381 + 1413) > (385 + 3308)) and v29 and v68.RaiseDead:IsCastable()) then
						if (v20(v68.RaiseDead, nil) or ((2902 - 1627) == (5051 - (783 + 168)))) then
							return "raise_dead main 4";
						end
					end
					if ((v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) or ((5339 - 3748) >= (3522 + 58))) then
						if (((1294 - (309 + 2)) <= (5552 - 3744)) and v20(v68.VampiricBlood, v57)) then
							return "vampiric_blood main 5";
						end
					end
					if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((3362 - (1090 + 122)) <= (389 + 808))) then
						if (((12657 - 8888) >= (803 + 370)) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
							return "deaths_caress main 6";
						end
					end
					v109 = 1121 - (628 + 490);
				end
			end
		end
	end
	local function v94()
		local v107 = 0 + 0;
		while true do
			if (((3676 - 2191) == (6786 - 5301)) and ((774 - (431 + 343)) == v107)) then
				v68.MarkofFyralathDebuff:RegisterAuraTracking();
				v10.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(504 - 254, v93, v94);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

