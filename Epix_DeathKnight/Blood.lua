local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((5673 - (818 + 323)) < (1268 - (141 + 95)))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((823 - 503) <= (124 - 72))) then
			v6 = v0[v4];
			if (((307 + 1002) <= (9605 - 6099)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		local v95 = 0 + 0;
		while true do
			if (((4161 - 1206) == (1744 + 1211)) and (v95 == (165 - (92 + 71)))) then
				v43 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v44 = EpicSettings.Settings['AntiMagicShellGCD'];
				v45 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v46 = EpicSettings.Settings['DeathAndDecayGCD'];
				v47 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v48 = EpicSettings.Settings['SacrificialPactGCD'];
				v95 = 2 + 1;
			end
			if ((v95 == (0 - 0)) or ((3668 - (574 + 191)) == (1234 + 261))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (849 - (254 + 595));
				v95 = 127 - (55 + 71);
			end
			if (((5988 - 1442) >= (4065 - (573 + 1217))) and (v95 == (8 - 5))) then
				v49 = EpicSettings.Settings['MindFreezeOffGCD'];
				v50 = EpicSettings.Settings['RacialsOffGCD'];
				v51 = EpicSettings.Settings['BonestormGCD'];
				v52 = EpicSettings.Settings['ChainsOfIceGCD'];
				v53 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v54 = not EpicSettings.Settings['DeathStrikeGCD'];
				v95 = 1 + 3;
			end
			if (((1319 - 500) >= (961 - (714 + 225))) and ((11 - 7) == v95)) then
				v55 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v56 = EpicSettings.Settings['TombstoneGCD'];
				v57 = EpicSettings.Settings['VampiricBloodGCD'];
				v58 = EpicSettings.Settings['BloodTapOffGCD'];
				v59 = EpicSettings.Settings['RuneTapOffGCD'];
				v64 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v95 = 6 - 1;
			end
			if (((343 + 2819) == (4577 - 1415)) and (v95 == (807 - (118 + 688)))) then
				v37 = EpicSettings.Settings['InterruptWithStun'] or (48 - (25 + 23));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1886 - (927 + 959));
				v31 = EpicSettings.Settings['UseTrinkets'];
				v41 = EpicSettings.Settings['UseDeathStrikeHP'];
				v42 = EpicSettings.Settings['UseDarkSuccorHP'];
				v95 = 6 - 4;
			end
			if ((v95 == (737 - (16 + 716))) or ((4572 - 2203) > (4526 - (11 + 86)))) then
				v60 = EpicSettings.Settings['RuneTapThreshold'];
				v61 = EpicSettings.Settings['VampiricBloodThreshold'];
				v62 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (0 - 0);
				v63 = EpicSettings.Settings['DeathStrikeHealing'] or (285 - (175 + 110));
				v65 = EpicSettings.Settings['DnDCast'];
				break;
			end
		end
	end
	local v67;
	local v68 = v16.DeathKnight.Blood;
	local v69 = v18.DeathKnight.Blood;
	local v70 = v21.DeathKnight.Blood;
	local v71 = {v69.Fyralath:ID()};
	local v72 = 320 - 255;
	local v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (1800 - (503 + 1293))) or (13 - 8);
	local v74 = 0 + 0;
	local v75 = 1061 - (810 + 251);
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
		v73 = ((not v68.DeathsCaress:IsAvailable() or v68.Consumption:IsAvailable() or v68.Blooddrinker:IsAvailable()) and (737 - (711 + 22))) or (19 - 14);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v84(v96)
		local v97 = 859 - (240 + 619);
		local v98;
		while true do
			if (((989 + 3106) >= (5063 - 1880)) and ((1 + 0) == v97)) then
				return v98;
			end
			if ((v97 == (1744 - (1344 + 400))) or ((4116 - (255 + 150)) < (794 + 214))) then
				v98 = 0 + 0;
				for v138, v139 in pairs(v96) do
					if (not v139:DebuffUp(v68.BloodPlagueDebuff) or ((4481 - 3432) <= (2926 - 2020))) then
						v98 = v98 + (1740 - (404 + 1335));
					end
				end
				v97 = 407 - (183 + 223);
			end
		end
	end
	local function v85(v99)
		return (v99:DebuffRemains(v68.SoulReaperDebuff));
	end
	local function v86(v100)
		return ((v100:TimeToX(42 - 7) < (4 + 1)) or (v100:HealthPercentage() <= (13 + 22))) and (v100:TimeToDie() > (v100:DebuffRemains(v68.SoulReaperDebuff) + (342 - (10 + 327))));
	end
	local function v87()
		local v101 = 0 + 0;
		while true do
			if (((4851 - (118 + 220)) > (909 + 1817)) and (v101 == (449 - (108 + 341)))) then
				if (v68.DeathsCaress:IsReady() or ((666 + 815) >= (11237 - 8579))) then
					if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((4713 - (711 + 782)) == (2614 - 1250))) then
						return "deaths_caress precombat 4";
					end
				end
				if (v68.Marrowrend:IsReady() or ((1523 - (270 + 199)) > (1100 + 2292))) then
					if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1824 - (580 + 1239))) or ((2009 - 1333) >= (1571 + 71))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v88()
		if (((149 + 3987) > (1045 + 1352)) and (v14:HealthPercentage() <= v36) and v35 and v69.Healthstone:IsReady()) then
			if (v10.Press(v70.Healthstone, nil, nil, true) or ((11315 - 6981) == (2638 + 1607))) then
				return "healthstone defensive 3";
			end
		end
		if ((v32 and (v14:HealthPercentage() <= v34)) or ((5443 - (645 + 522)) <= (4821 - (1010 + 780)))) then
			local v107 = 0 + 0;
			while true do
				if ((v107 == (0 - 0)) or ((14013 - 9231) <= (3035 - (1045 + 791)))) then
					if ((v33 == "Refreshing Healing Potion") or ((12311 - 7447) < (2903 - 1001))) then
						if (((5344 - (351 + 154)) >= (5274 - (1281 + 293))) and v69.RefreshingHealingPotion:IsReady()) then
							if (v10.Press(v70.RefreshingHealingPotion) or ((1341 - (28 + 238)) > (4285 - 2367))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1955 - (1381 + 178)) <= (3568 + 236)) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v69.DreamwalkersHealingPotion:IsReady() or ((3362 + 807) == (933 + 1254))) then
							if (((4847 - 3441) == (729 + 677)) and v10.Press(v70.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((2001 - (381 + 89)) < (3788 + 483)) and v68.RuneTap:IsReady() and v76 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= (3 + 0)) and (v68.RuneTap:Charges() >= (1 - 0)) and v14:BuffDown(v68.RuneTapBuff)) then
			if (((1791 - (1074 + 82)) == (1391 - 756)) and v20(v68.RuneTap, v59)) then
				return "rune_tap defensives 2";
			end
		end
		if (((5157 - (214 + 1570)) <= (5011 - (990 + 465))) and v14:ActiveMitigationNeeded() and (v68.Marrowrend:TimeSinceLastCast() > (1.5 + 1)) and (v68.DeathStrike:TimeSinceLastCast() > (1.5 + 1))) then
			local v108 = 0 + 0;
			while true do
				if (((3 - 2) == v108) or ((5017 - (1668 + 58)) < (3906 - (512 + 114)))) then
					if (((11434 - 7048) >= (1804 - 931)) and v68.DeathStrike:IsReady()) then
						if (((3204 - 2283) <= (513 + 589)) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
							return "death_strike defensives 10";
						end
					end
					break;
				end
				if (((881 + 3825) >= (838 + 125)) and ((0 - 0) == v108)) then
					if ((v68.DeathStrike:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (2001 - (109 + 1885)))) or ((2429 - (1269 + 200)) <= (1678 - 802))) then
						if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((2881 - (98 + 717)) == (1758 - (802 + 24)))) then
							return "death_strike defensives 4";
						end
					end
					if (((8320 - 3495) < (6115 - 1272)) and v68.Marrowrend:IsReady()) then
						if (v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(1 + 4)) or ((2979 + 898) >= (746 + 3791))) then
							return "marrowrend defensives 6";
						end
					end
					v108 = 1 + 0;
				end
			end
		end
		if ((v68.VampiricBlood:IsCastable() and v76 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v68.IceboundFortitudeBuff)) or ((12004 - 7689) < (5755 - 4029))) then
			if (v20(v68.VampiricBlood, v57) or ((1316 + 2363) < (255 + 370))) then
				return "vampiric_blood defensives 14";
			end
		end
		if ((v68.IceboundFortitude:IsCastable() and v76 and (v14:HealthPercentage() <= v64) and v14:BuffDown(v68.VampiricBloodBuff)) or ((3815 + 810) < (460 + 172))) then
			if (v20(v68.IceboundFortitude, v55) or ((39 + 44) > (3213 - (797 + 636)))) then
				return "icebound_fortitude defensives 16";
			end
		end
		if (((2650 - 2104) <= (2696 - (1427 + 192))) and v68.DeathStrike:IsReady() and (v14:HealthPercentage() <= v63)) then
			if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((346 + 650) > (9985 - 5684))) then
				return "death_strike defensives 18";
			end
		end
	end
	local function v89()
	end
	local function v90()
		local v102 = 0 + 0;
		while true do
			if (((1845 + 2225) > (1013 - (192 + 134))) and (v102 == (1279 - (316 + 960)))) then
				if (v68.BagofTricks:IsCastable() or ((366 + 290) >= (2570 + 760))) then
					if (v20(v68.BagofTricks, nil, not v15:IsSpellInRange(v68.BagofTricks)) or ((2304 + 188) <= (1280 - 945))) then
						return "bag_of_tricks racials 14";
					end
				end
				if (((4873 - (83 + 468)) >= (4368 - (1202 + 604))) and v68.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (93 - 73))) then
					if (v20(v68.ArcaneTorrent, nil, not v15:IsInRange(13 - 5)) or ((10069 - 6432) >= (4095 - (45 + 280)))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if (((2 + 0) == v102) or ((2079 + 300) > (1672 + 2906))) then
				if (v68.AncestralCall:IsCastable() or ((268 + 215) > (131 + 612))) then
					if (((4543 - 2089) > (2489 - (340 + 1571))) and v20(v68.AncestralCall)) then
						return "ancestral_call racials 10";
					end
				end
				if (((367 + 563) < (6230 - (1733 + 39))) and v68.Fireblood:IsCastable()) then
					if (((1819 - 1157) <= (2006 - (125 + 909))) and v20(v68.Fireblood)) then
						return "fireblood racials 12";
					end
				end
				v102 = 1951 - (1096 + 852);
			end
			if (((1961 + 2409) == (6240 - 1870)) and (v102 == (1 + 0))) then
				if ((v68.ArcanePulse:IsCastable() and ((v78 >= (514 - (409 + 103))) or ((v14:Rune() < (237 - (46 + 190))) and (v14:RunicPowerDeficit() > (155 - (51 + 44)))))) or ((1344 + 3418) <= (2178 - (1114 + 203)))) then
					if (v20(v68.ArcanePulse, nil, not v15:IsInRange(734 - (228 + 498))) or ((306 + 1106) == (2356 + 1908))) then
						return "arcane_pulse racials 6";
					end
				end
				if ((v68.LightsJudgment:IsCastable() and (v14:BuffUp(v68.UnholyStrengthBuff))) or ((3831 - (174 + 489)) < (5608 - 3455))) then
					if (v20(v68.LightsJudgment, nil, not v15:IsSpellInRange(v68.LightsJudgment)) or ((6881 - (830 + 1075)) < (1856 - (303 + 221)))) then
						return "lights_judgment racials 8";
					end
				end
				v102 = 1271 - (231 + 1038);
			end
			if (((3857 + 771) == (5790 - (171 + 991))) and (v102 == (0 - 0))) then
				if ((v68.BloodFury:IsCastable() and v68.DancingRuneWeapon:CooldownUp() and (not v68.Blooddrinker:IsReady() or not v68.Blooddrinker:IsAvailable())) or ((144 - 90) == (985 - 590))) then
					if (((66 + 16) == (287 - 205)) and v20(v68.BloodFury)) then
						return "blood_fury racials 2";
					end
				end
				if (v68.Berserking:IsCastable() or ((1675 - 1094) < (453 - 171))) then
					if (v20(v68.Berserking) or ((14247 - 9638) < (3743 - (111 + 1137)))) then
						return "berserking racials 4";
					end
				end
				v102 = 159 - (91 + 67);
			end
		end
	end
	local function v91()
		local v103 = 0 - 0;
		while true do
			if (((288 + 864) == (1675 - (423 + 100))) and (v103 == (1 + 0))) then
				if (((5249 - 3353) <= (1784 + 1638)) and v68.SoulReaper:IsReady() and (v78 == (772 - (326 + 445))) and ((v15:TimeToX(152 - 117) < (10 - 5)) or (v15:HealthPercentage() <= (81 - 46))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + (716 - (530 + 181))))) then
					if (v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(886 - (614 + 267))) or ((1022 - (19 + 13)) > (2636 - 1016))) then
						return "soul_reaper drw_up 12";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 >= (4 - 2))) or ((2505 - 1628) > (1220 + 3475))) then
					if (((4732 - 2041) >= (3838 - 1987)) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(1817 - (1293 + 519)))) then
						return "soul_reaper drw_up 14";
					end
				end
				if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.SanguineGround:IsAvailable() or v68.UnholyGround:IsAvailable())) or ((6090 - 3105) >= (12678 - 7822))) then
					if (((8176 - 3900) >= (5152 - 3957)) and (v65 == "At Player")) then
						if (((7613 - 4381) <= (2485 + 2205)) and v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(7 + 23))) then
							return "death_and_decay drw_up 16";
						end
					elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(69 - 39)) or ((208 + 688) >= (1046 + 2100))) then
						return "death_and_decay drw_up 16";
					end
				end
				if (((1913 + 1148) >= (4054 - (709 + 387))) and v68.BloodBoil:IsCastable() and (v78 > (1860 - (673 + 1185))) and (v68.BloodBoil:ChargesFractional() >= (2.1 - 1))) then
					if (((10233 - 7046) >= (1059 - 415)) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(8 + 2))) then
						return "blood_boil drw_up 18";
					end
				end
				v103 = 2 + 0;
			end
			if (((869 - 225) <= (173 + 531)) and (v103 == (0 - 0))) then
				if (((1880 - 922) > (2827 - (446 + 1434))) and v68.BloodBoil:IsReady() and (v15:DebuffDown(v68.BloodPlagueDebuff))) then
					if (((5775 - (1040 + 243)) >= (7921 - 5267)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(1857 - (559 + 1288)))) then
						return "blood_boil drw_up 2";
					end
				end
				if (((5373 - (609 + 1322)) >= (1957 - (13 + 441))) and v68.Tombstone:IsReady() and (v14:BuffStack(v68.BoneShieldBuff) > (18 - 13)) and (v14:Rune() >= (5 - 3)) and (v14:RunicPowerDeficit() >= (149 - 119)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff)))) then
					if (v20(v68.Tombstone) or ((119 + 3051) <= (5316 - 3852))) then
						return "tombstone drw_up 4";
					end
				end
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()))) or ((1704 + 3093) == (1923 + 2465))) then
					if (((1635 - 1084) <= (373 + 308)) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(8 - 3))) then
						return "death_strike drw_up 6";
					end
				end
				if (((2167 + 1110) > (227 + 180)) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (3 + 1)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (17 + 3))) then
					if (((4594 + 101) >= (1848 - (153 + 280))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(14 - 9))) then
						return "marrowrend drw_up 10";
					end
				end
				v103 = 1 + 0;
			end
			if ((v103 == (2 + 1)) or ((1681 + 1531) <= (857 + 87))) then
				if ((v68.HeartStrike:IsReady() and ((v14:RuneTimeToX(2 + 0) < v14:GCD()) or (v14:RunicPowerDeficit() >= v75))) or ((4713 - 1617) <= (1112 + 686))) then
					if (((4204 - (89 + 578)) == (2527 + 1010)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
						return "heart_strike drw_up 26";
					end
				end
				break;
			end
			if (((7976 - 4139) >= (2619 - (572 + 477))) and (v103 == (1 + 1))) then
				v75 = 16 + 9 + (v79 * v22(v68.Heartbreaker:IsAvailable()) * (1 + 1));
				if ((v68.DeathStrike:IsReady() and ((v14:RunicPowerDeficit() <= v75) or (v14:RunicPower() >= v72))) or ((3036 - (84 + 2)) == (6281 - 2469))) then
					if (((3403 + 1320) >= (3160 - (497 + 345))) and v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike))) then
						return "death_strike drw_up 20";
					end
				end
				if (v68.Consumption:IsCastable() or ((52 + 1975) > (483 + 2369))) then
					if (v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption)) or ((2469 - (605 + 728)) > (3081 + 1236))) then
						return "consumption drw_up 22";
					end
				end
				if (((10556 - 5808) == (218 + 4530)) and v68.BloodBoil:IsReady() and (v68.BloodBoil:ChargesFractional() >= (3.1 - 2)) and (v14:BuffStack(v68.HemostasisBuff) < (5 + 0))) then
					if (((10350 - 6614) <= (3579 + 1161)) and v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(499 - (457 + 32)))) then
						return "blood_boil drw_up 24";
					end
				end
				v103 = 2 + 1;
			end
		end
	end
	local function v92()
		local v104 = 1402 - (832 + 570);
		while true do
			if ((v104 == (3 + 0)) or ((885 + 2505) <= (10828 - 7768))) then
				if ((v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v14:BuffStack(v68.HemostasisBuff) <= ((801 - (588 + 208)) - v78)) or (v78 > (5 - 3)))) or ((2799 - (884 + 916)) > (5637 - 2944))) then
					if (((269 + 194) < (1254 - (232 + 421))) and v20(v68.BloodBoil, nil, not v15:IsInMeleeRange(1899 - (1569 + 320)))) then
						return "blood_boil standard 18";
					end
				end
				if ((v68.HeartStrike:IsReady() and (v14:RuneTimeToX(1 + 3) < v14:GCD())) or ((415 + 1768) < (2314 - 1627))) then
					if (((5154 - (316 + 289)) == (11907 - 7358)) and v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike))) then
						return "heart_strike standard 20";
					end
				end
				if (((216 + 4456) == (6125 - (666 + 787))) and v68.BloodBoil:IsCastable() and (v68.BloodBoil:ChargesFractional() >= (426.1 - (360 + 65)))) then
					if (v20(v68.BloodBoil, nil, nil, not v15:IsInMeleeRange(10 + 0)) or ((3922 - (79 + 175)) < (622 - 227))) then
						return "blood_boil standard 22";
					end
				end
				v104 = 4 + 0;
			end
			if ((v104 == (0 - 0)) or ((8022 - 3856) == (1354 - (503 + 396)))) then
				if ((v29 and v68.Tombstone:IsCastable() and (v14:BuffStack(v68.BoneShieldBuff) > (186 - (92 + 89))) and (v14:Rune() >= (3 - 1)) and (v14:RunicPowerDeficit() >= (16 + 14)) and (not v68.ShatteringBone:IsAvailable() or (v68.ShatteringBone:IsAvailable() and v14:BuffUp(v68.DeathAndDecayBuff))) and (v68.DancingRuneWeapon:CooldownRemains() >= (15 + 10))) or ((17422 - 12973) == (365 + 2298))) then
					if (v20(v68.Tombstone) or ((9751 - 5474) < (2608 + 381))) then
						return "tombstone standard 2";
					end
				end
				v74 = 5 + 5 + (v78 * v22(v68.Heartbreaker:IsAvailable()) * (5 - 3));
				if ((v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (2 + 8)))) or ((1326 - 456) >= (5393 - (485 + 759)))) then
					if (((5118 - 2906) < (4372 - (442 + 747))) and v20(v68.DeathStrike, v54, nil, not v15:IsInMeleeRange(1140 - (832 + 303)))) then
						return "death_strike standard 4";
					end
				end
				v104 = 947 - (88 + 858);
			end
			if (((1417 + 3229) > (2477 + 515)) and (v104 == (1 + 1))) then
				if (((2223 - (766 + 23)) < (15333 - 12227)) and v68.SoulReaper:IsReady() and (v78 == (1 - 0)) and ((v15:TimeToX(92 - 57) < (16 - 11)) or (v15:HealthPercentage() <= (1108 - (1036 + 37)))) and (v15:TimeToDie() > (v15:DebuffRemains(v68.SoulReaperDebuff) + 4 + 1))) then
					if (((1530 - 744) < (2378 + 645)) and v20(v68.SoulReaper, nil, nil, not v15:IsInMeleeRange(1485 - (641 + 839)))) then
						return "soul_reaper standard 12";
					end
				end
				if ((v68.SoulReaper:IsReady() and (v78 >= (915 - (910 + 3)))) or ((6225 - 3783) < (1758 - (1466 + 218)))) then
					if (((2085 + 2450) == (5683 - (556 + 592))) and v82.CastTargetIf(v68.SoulReaper, v77, "min", v85, v86, not v15:IsInMeleeRange(2 + 3))) then
						return "soul_reaper standard 14";
					end
				end
				if ((v29 and v68.Bonestorm:IsReady() and (v14:RunicPower() >= (908 - (329 + 479)))) or ((3863 - (174 + 680)) <= (7233 - 5128))) then
					if (((3793 - 1963) < (2620 + 1049)) and v20(v68.Bonestorm)) then
						return "bonestorm standard 16";
					end
				end
				v104 = 742 - (396 + 343);
			end
			if ((v104 == (1 + 3)) or ((2907 - (29 + 1448)) >= (5001 - (135 + 1254)))) then
				if (((10107 - 7424) >= (11486 - 9026)) and v68.HeartStrike:IsReady() and (v14:Rune() > (1 + 0)) and ((v14:RuneTimeToX(1530 - (389 + 1138)) < v14:GCD()) or (v14:BuffStack(v68.BoneShieldBuff) > (581 - (102 + 472))))) then
					if (v20(v68.HeartStrike, nil, nil, not v15:IsSpellInRange(v68.HeartStrike)) or ((1703 + 101) >= (1817 + 1458))) then
						return "heart_strike standard 24";
					end
				end
				break;
			end
			if ((v104 == (1 + 0)) or ((2962 - (320 + 1225)) > (6459 - 2830))) then
				if (((2934 + 1861) > (1866 - (157 + 1307))) and v68.DeathsCaress:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (1863 - (821 + 1038))) or (v14:BuffStack(v68.BoneShieldBuff) < (v73 + (2 - 1)))) and (v14:RunicPowerDeficit() > (2 + 8)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff))) and not v68.Consumption:IsAvailable() and not v68.Blooddrinker:IsAvailable() and (v14:RuneTimeToX(4 - 1) > v14:GCD())) then
					if (((1791 + 3022) > (8836 - 5271)) and v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress))) then
						return "deaths_caress standard 6";
					end
				end
				if (((4938 - (834 + 192)) == (249 + 3663)) and v68.Marrowrend:IsReady() and ((v14:BuffRemains(v68.BoneShieldBuff) <= (2 + 2)) or (v14:BuffStack(v68.BoneShieldBuff) < v73)) and (v14:RunicPowerDeficit() > (1 + 19)) and not (v68.InsatiableBlade:IsAvailable() and (v68.DancingRuneWeapon:CooldownRemains() < v14:BuffRemains(v68.BoneShieldBuff)))) then
					if (((4369 - 1548) <= (5128 - (300 + 4))) and v20(v68.Marrowrend, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "marrowrend standard 8";
					end
				end
				if (((4549 - 2811) <= (2557 - (112 + 250))) and v68.Consumption:IsCastable()) then
					if (((17 + 24) <= (7560 - 4542)) and v20(v68.Consumption, nil, not v15:IsSpellInRange(v68.Consumption))) then
						return "consumption standard 10";
					end
				end
				v104 = 2 + 0;
			end
		end
	end
	local function v93()
		local v105 = 0 + 0;
		while true do
			if (((1605 + 540) <= (2035 + 2069)) and (v105 == (1 + 0))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v105 = 1416 - (1001 + 413);
			end
			if (((5996 - 3307) < (5727 - (244 + 638))) and (v105 == (696 - (627 + 66)))) then
				if (v82.TargetIsValid() or v14:AffectingCombat() or ((6918 - 4596) > (3224 - (512 + 90)))) then
					v79 = v24(v78, (v14:BuffUp(v68.DeathAndDecayBuff) and (1911 - (1665 + 241))) or (719 - (373 + 344)));
					v80 = v84(v77);
					v76 = v14:IsTankingAoE(4 + 4) or v14:IsTanking(v15);
				end
				if (v82.TargetIsValid() or ((1200 + 3334) == (5491 - 3409))) then
					if (not v14:AffectingCombat() or ((2658 - 1087) > (2966 - (35 + 1064)))) then
						local v141 = 0 + 0;
						local v142;
						while true do
							if ((v141 == (0 - 0)) or ((11 + 2643) >= (4232 - (298 + 938)))) then
								v142 = v87();
								if (((5237 - (233 + 1026)) > (3770 - (636 + 1030))) and v142) then
									return v142;
								end
								break;
							end
						end
					end
					local v140 = v88();
					if (((1532 + 1463) > (1506 + 35)) and v140) then
						return v140;
					end
					if (((966 + 2283) > (65 + 888)) and v14:IsChanneling(v68.Blooddrinker) and v14:BuffUp(v68.BoneShieldBuff) and (v80 == (221 - (55 + 166))) and not v14:ShouldStopCasting() and (v14:CastRemains() > (0.2 + 0))) then
						if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((330 + 2943) > (17464 - 12891))) then
							return "Pool During Blooddrinker";
						end
					end
					v72 = v62;
					if (v31 or ((3448 - (36 + 261)) < (2245 - 961))) then
						local v143 = v89();
						if (v143 or ((3218 - (34 + 1334)) == (588 + 941))) then
							return v143;
						end
					end
					if (((638 + 183) < (3406 - (1035 + 248))) and v29 and v68.RaiseDead:IsCastable()) then
						if (((923 - (20 + 1)) < (1212 + 1113)) and v20(v68.RaiseDead, nil)) then
							return "raise_dead main 4";
						end
					end
					if (((1177 - (134 + 185)) <= (4095 - (549 + 584))) and v68.VampiricBlood:IsCastable() and v14:BuffDown(v68.VampiricBloodBuff) and v14:BuffDown(v68.VampiricStrengthBuff)) then
						if (v20(v68.VampiricBlood, v57) or ((4631 - (314 + 371)) < (4421 - 3133))) then
							return "vampiric_blood main 5";
						end
					end
					if ((v68.DeathsCaress:IsReady() and (v14:BuffDown(v68.BoneShieldBuff))) or ((4210 - (478 + 490)) == (301 + 266))) then
						if (v20(v68.DeathsCaress, nil, nil, not v15:IsSpellInRange(v68.DeathsCaress)) or ((2019 - (786 + 386)) >= (4090 - 2827))) then
							return "deaths_caress main 6";
						end
					end
					if ((v68.DeathAndDecay:IsReady() and (v65 ~= "Don't Cast") and v14:BuffDown(v68.DeathAndDecayBuff) and (v68.UnholyGround:IsAvailable() or v68.SanguineGround:IsAvailable() or (v78 > (1382 - (1055 + 324))) or v14:BuffUp(v68.CrimsonScourgeBuff))) or ((3593 - (1093 + 247)) == (1645 + 206))) then
						if ((v65 == "At Player") or ((220 + 1867) > (9417 - 7045))) then
							if (v20(v70.DaDPlayer, v46, nil, not v15:IsInRange(101 - 71)) or ((12648 - 8203) < (10425 - 6276))) then
								return "death_and_decay drw_up 16";
							end
						elseif (v20(v70.DaDCursor, v46, nil, not v15:IsInRange(11 + 19)) or ((7003 - 5185) == (292 - 207))) then
							return "death_and_decay drw_up 16";
						end
					end
					if (((476 + 154) < (5439 - 3312)) and v68.DeathStrike:IsReady() and ((v14:BuffRemains(v68.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v68.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v72) or (v14:RunicPowerDeficit() <= v74) or (v15:TimeToDie() < (698 - (364 + 324))))) then
						if (v20(v68.DeathStrike, v54, nil, not v15:IsSpellInRange(v68.DeathStrike)) or ((5312 - 3374) == (6032 - 3518))) then
							return "death_strike main 10";
						end
					end
					if (((1411 + 2844) >= (230 - 175)) and v68.Blooddrinker:IsReady() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) then
						if (((4802 - 1803) > (3510 - 2354)) and v20(v68.Blooddrinker, nil, nil, not v15:IsSpellInRange(v68.Blooddrinker))) then
							return "blooddrinker main 12";
						end
					end
					if (((3618 - (1249 + 19)) > (1043 + 112)) and v29) then
						local v144 = v90();
						if (((15682 - 11653) <= (5939 - (686 + 400))) and v144) then
							return v144;
						end
					end
					if ((v29 and v68.SacrificialPact:IsReady() and v81.GhoulActive() and v14:BuffDown(v68.DancingRuneWeaponBuff) and ((v81.GhoulRemains() < (2 + 0)) or (v15:TimeToDie() < v14:GCD()))) or ((745 - (73 + 156)) > (17 + 3417))) then
						if (((4857 - (721 + 90)) >= (35 + 2998)) and v20(v68.SacrificialPact, v48)) then
							return "sacrificial_pact main 14";
						end
					end
					if ((v29 and v68.BloodTap:IsCastable() and (((v14:Rune() <= (6 - 4)) and (v14:RuneTimeToX(474 - (224 + 246)) > v14:GCD()) and (v68.BloodTap:ChargesFractional() >= (1.8 - 0))) or (v14:RuneTimeToX(5 - 2) > v14:GCD()))) or ((494 + 2225) <= (35 + 1412))) then
						if (v20(v68.BloodTap, v58) or ((3037 + 1097) < (7805 - 3879))) then
							return "blood_tap main 16";
						end
					end
					if ((v29 and v68.GorefiendsGrasp:IsCastable() and (v68.TighteningGrasp:IsAvailable())) or ((545 - 381) >= (3298 - (203 + 310)))) then
						if (v20(v68.GorefiendsGrasp, nil, not v15:IsSpellInRange(v68.GorefiendsGrasp)) or ((2518 - (1238 + 755)) == (148 + 1961))) then
							return "gorefiends_grasp main 18";
						end
					end
					if (((1567 - (709 + 825)) == (60 - 27)) and v29 and v68.EmpowerRuneWeapon:IsReady() and (v14:Rune() < (8 - 2)) and (v14:RunicPowerDeficit() > (869 - (196 + 668)))) then
						if (((12057 - 9003) <= (8316 - 4301)) and v20(v68.EmpowerRuneWeapon)) then
							return "empower_rune_weapon main 20";
						end
					end
					if (((2704 - (171 + 662)) < (3475 - (4 + 89))) and v29 and v68.AbominationLimb:IsCastable()) then
						if (((4531 - 3238) <= (789 + 1377)) and v20(v68.AbominationLimb, nil, not v15:IsInRange(87 - 67))) then
							return "abomination_limb main 22";
						end
					end
					if ((v29 and v68.DancingRuneWeapon:IsCastable() and (v14:BuffDown(v68.DancingRuneWeaponBuff))) or ((1012 + 1567) < (1609 - (35 + 1451)))) then
						if (v20(v68.DancingRuneWeapon, v53) or ((2299 - (28 + 1425)) >= (4361 - (941 + 1052)))) then
							return "dancing_rune_weapon main 24";
						end
					end
					if ((v14:BuffUp(v68.DancingRuneWeaponBuff)) or ((3847 + 165) <= (4872 - (822 + 692)))) then
						local v145 = v91();
						if (((2132 - 638) <= (1416 + 1589)) and v145) then
							return v145;
						end
						if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((3408 - (45 + 252)) == (2112 + 22))) then
							return "Wait/Pool for DRWUp";
						end
					end
					local v140 = v92();
					if (((811 + 1544) == (5731 - 3376)) and v140) then
						return v140;
					end
					if (v10.CastAnnotated(v68.Pool, false, "WAIT") or ((1021 - (114 + 319)) <= (619 - 187))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((6146 - 1349) >= (2484 + 1411)) and (v105 == (2 - 0))) then
				v77 = v14:GetEnemiesInMeleeRange(10 - 5);
				if (((5540 - (556 + 1407)) == (4783 - (741 + 465))) and v28) then
					v78 = #v77;
				else
					v78 = 466 - (170 + 295);
				end
				v105 = 2 + 1;
			end
			if (((3485 + 309) > (9092 - 5399)) and (v105 == (0 + 0))) then
				v66();
				v27 = EpicSettings.Toggles['ooc'];
				v105 = 1 + 0;
			end
		end
	end
	local function v94()
		v68.MarkofFyralathDebuff:RegisterAuraTracking();
		v10.Print("Blood DK by Epic. Work in progress Gojira");
	end
	v10.SetAPL(142 + 108, v93, v94);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

