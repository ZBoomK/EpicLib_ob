local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((7550 - 3986) <= (4811 - 2724))) then
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
	local v63;
	local v64;
	local function v65()
		local v94 = 0 + 0;
		while true do
			if (((5541 - 2583) < (12071 - 7568)) and (v94 == (1229 - (322 + 905)))) then
				v42 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v43 = EpicSettings.Settings['AntiMagicShellGCD'];
				v44 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v45 = EpicSettings.Settings['DeathAndDecayGCD'];
				v46 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v47 = EpicSettings.Settings['SacrificialPactGCD'];
				v94 = 614 - (602 + 9);
			end
			if ((v94 == (1189 - (449 + 740))) or ((3607 - (826 + 46)) == (2256 - (245 + 702)))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v33 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (1898 - (260 + 1638));
				v94 = 441 - (382 + 58);
			end
			if ((v94 == (9 - 6)) or ((3432 + 698) <= (6106 - 3151))) then
				v48 = EpicSettings.Settings['MindFreezeOffGCD'];
				v49 = EpicSettings.Settings['RacialsOffGCD'];
				v50 = EpicSettings.Settings['BonestormGCD'];
				v51 = EpicSettings.Settings['ChainsOfIceGCD'];
				v52 = EpicSettings.Settings['DancingRuneWeaponGCD'];
				v53 = EpicSettings.Settings['DeathStrikeGCD'];
				v94 = 11 - 7;
			end
			if (((1209 - (902 + 303)) == v94) or ((4312 - 2348) <= (3227 - 1887))) then
				v54 = EpicSettings.Settings['IceboundFortitudeGCD'];
				v55 = EpicSettings.Settings['TombstoneGCD'];
				v56 = EpicSettings.Settings['VampiricBloodGCD'];
				v57 = EpicSettings.Settings['BloodTapOffGCD'];
				v58 = EpicSettings.Settings['RuneTapOffGCD'];
				v63 = EpicSettings.Settings['IceboundFortitudeThreshold'];
				v94 = 1 + 4;
			end
			if (((4189 - (1121 + 569)) == (2713 - (22 + 192))) and (v94 == (684 - (483 + 200)))) then
				v36 = EpicSettings.Settings['InterruptWithStun'] or (1463 - (1404 + 59));
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v30 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseDeathStrikeHP'];
				v41 = EpicSettings.Settings['UseDarkSuccorHP'];
				v94 = 767 - (468 + 297);
			end
			if ((v94 == (567 - (334 + 228))) or ((7606 - 5351) < (50 - 28))) then
				v59 = EpicSettings.Settings['RuneTapThreshold'];
				v60 = EpicSettings.Settings['VampiricBloodThreshold'];
				v61 = EpicSettings.Settings['DeathStrikeDumpAmount'] or (0 - 0);
				v62 = EpicSettings.Settings['DeathStrikeHealing'] or (0 + 0);
				v64 = EpicSettings.Settings['DnDCast'];
				break;
			end
		end
	end
	local v66;
	local v67 = v15.DeathKnight.Blood;
	local v68 = v17.DeathKnight.Blood;
	local v69 = v20.DeathKnight.Blood;
	local v70 = {v68.Fyralath:ID()};
	local v71 = 64 + 1;
	local v72 = ((not v67.DeathsCaress:IsAvailable() or v67.Consumption:IsAvailable() or v67.Blooddrinker:IsAvailable()) and (9 - 5)) or (12 - 7);
	local v73 = 0 + 0;
	local v74 = 0 - 0;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80 = v9.GhoulTable;
	local v81 = v9.Commons.Everyone;
	local v82 = {{v67.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v72 = ((not v67.DeathsCaress:IsAvailable() or v67.Consumption:IsAvailable() or v67.Blooddrinker:IsAvailable()) and (167 - (92 + 71))) or (3 + 2);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v83(v95)
		local v96 = 0 - 0;
		local v97;
		while true do
			if (((766 - (574 + 191)) == v96) or ((896 + 190) >= (3519 - 2114))) then
				return v97;
			end
			if ((v96 == (0 + 0)) or ((3218 - (254 + 595)) == (552 - (55 + 71)))) then
				v97 = 0 - 0;
				for v137, v138 in pairs(v95) do
					if (not v138:DebuffUp(v67.BloodPlagueDebuff) or ((4866 - (573 + 1217)) > (8815 - 5632))) then
						v97 = v97 + 1 + 0;
					end
				end
				v96 = 1 - 0;
			end
		end
	end
	local function v84(v98)
		return (v98:DebuffRemains(v67.SoulReaperDebuff));
	end
	local function v85(v99)
		return ((v99:TimeToX(974 - (714 + 225)) < (14 - 9)) or (v99:HealthPercentage() <= (48 - 13))) and (v99:TimeToDie() > (v99:DebuffRemains(v67.SoulReaperDebuff) + 1 + 4));
	end
	local function v86()
		local v100 = 0 - 0;
		while true do
			if (((2008 - (118 + 688)) > (1106 - (25 + 23))) and (v100 == (0 + 0))) then
				if (((5597 - (927 + 959)) > (11309 - 7954)) and v67.DeathsCaress:IsReady()) then
					if (v19(v67.DeathsCaress, nil, nil, not v14:IsSpellInRange(v67.DeathsCaress)) or ((1638 - (16 + 716)) >= (4302 - 2073))) then
						return "deaths_caress precombat 4";
					end
				end
				if (((1385 - (11 + 86)) > (3051 - 1800)) and v67.Marrowrend:IsReady()) then
					if (v19(v67.Marrowrend, nil, nil, not v14:IsInMeleeRange(290 - (175 + 110))) or ((11393 - 6880) < (16532 - 13180))) then
						return "marrowrend precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v87()
		local v101 = 1796 - (503 + 1293);
		while true do
			if (((5 - 3) == v101) or ((1494 + 571) >= (4257 - (810 + 251)))) then
				if ((v67.DeathStrike:IsReady() and (v13:HealthPercentage() <= (v62 + (((v13:RunicPower() > v71) and (14 + 6)) or (0 + 0)))) and not v13:HealingAbsorbed()) or ((3945 + 431) <= (2014 - (43 + 490)))) then
					if (v19(v67.DeathStrike, v53, nil, not v14:IsSpellInRange(v67.DeathStrike)) or ((4125 - (711 + 22)) >= (18339 - 13598))) then
						return "death_strike defensives 18";
					end
				end
				break;
			end
			if (((4184 - (240 + 619)) >= (520 + 1634)) and (v101 == (0 - 0))) then
				if ((v67.RuneTap:IsReady() and v75 and (v13:HealthPercentage() <= v59) and (v13:Rune() >= (1 + 2)) and (v67.RuneTap:Charges() >= (1745 - (1344 + 400))) and v13:BuffDown(v67.RuneTapBuff)) or ((1700 - (255 + 150)) >= (2547 + 686))) then
					if (((2344 + 2033) > (7015 - 5373)) and v19(v67.RuneTap, v58)) then
						return "rune_tap defensives 2";
					end
				end
				if (((15254 - 10531) > (3095 - (404 + 1335))) and v13:ActiveMitigationNeeded() and (v67.Marrowrend:TimeSinceLastCast() > (408.5 - (183 + 223))) and (v67.DeathStrike:TimeSinceLastCast() > (2.5 - 0))) then
					local v139 = 0 + 0;
					while true do
						if ((v139 == (0 + 0)) or ((4473 - (10 + 327)) <= (2391 + 1042))) then
							if (((4583 - (118 + 220)) <= (1544 + 3087)) and v67.DeathStrike:IsReady() and (v13:BuffStack(v67.BoneShieldBuff) > (456 - (108 + 341)))) then
								if (((1921 + 2355) >= (16547 - 12633)) and v19(v67.DeathStrike, v53, nil, not v14:IsSpellInRange(v67.DeathStrike))) then
									return "death_strike defensives 4";
								end
							end
							if (((1691 - (711 + 782)) <= (8367 - 4002)) and v67.Marrowrend:IsReady()) then
								if (((5251 - (270 + 199)) > (1516 + 3160)) and v19(v67.Marrowrend, nil, nil, not v14:IsInMeleeRange(1824 - (580 + 1239)))) then
									return "marrowrend defensives 6";
								end
							end
							v139 = 2 - 1;
						end
						if (((4651 + 213) > (79 + 2118)) and (v139 == (1 + 0))) then
							if (v67.DeathStrike:IsReady() or ((9660 - 5960) == (1558 + 949))) then
								if (((5641 - (645 + 522)) >= (2064 - (1010 + 780))) and v19(v67.DeathStrike, v53, nil, not v14:IsSpellInRange(v67.DeathStrike))) then
									return "death_strike defensives 10";
								end
							end
							break;
						end
					end
				end
				v101 = 1 + 0;
			end
			if ((v101 == (4 - 3)) or ((5550 - 3656) <= (3242 - (1045 + 791)))) then
				if (((3978 - 2406) >= (2337 - 806)) and v67.VampiricBlood:IsCastable() and v75 and (v13:HealthPercentage() <= v60) and v13:BuffDown(v67.IceboundFortitudeBuff)) then
					if (v19(v67.VampiricBlood, v56) or ((5192 - (351 + 154)) < (6116 - (1281 + 293)))) then
						return "vampiric_blood defensives 14";
					end
				end
				if (((3557 - (28 + 238)) > (3724 - 2057)) and v67.IceboundFortitude:IsCastable() and v75 and (v13:HealthPercentage() <= v63) and v13:BuffDown(v67.VampiricBloodBuff)) then
					if (v19(v67.IceboundFortitude, v54) or ((2432 - (1381 + 178)) == (1908 + 126))) then
						return "icebound_fortitude defensives 16";
					end
				end
				v101 = 2 + 0;
			end
		end
	end
	local function v88()
	end
	local function v89()
		local v102 = 0 + 0;
		while true do
			if ((v102 == (0 - 0)) or ((1459 + 1357) < (481 - (381 + 89)))) then
				if (((3281 + 418) < (3183 + 1523)) and v67.BloodFury:IsCastable() and v67.DancingRuneWeapon:CooldownUp() and (not v67.Blooddrinker:IsReady() or not v67.Blooddrinker:IsAvailable())) then
					if (((4532 - 1886) >= (2032 - (1074 + 82))) and v19(v67.BloodFury)) then
						return "blood_fury racials 2";
					end
				end
				if (((1345 - 731) <= (4968 - (214 + 1570))) and v67.Berserking:IsCastable()) then
					if (((4581 - (990 + 465)) == (1289 + 1837)) and v19(v67.Berserking)) then
						return "berserking racials 4";
					end
				end
				v102 = 1 + 0;
			end
			if ((v102 == (1 + 0)) or ((8606 - 6419) >= (6680 - (1668 + 58)))) then
				if ((v67.ArcanePulse:IsCastable() and ((v77 >= (628 - (512 + 114))) or ((v13:Rune() < (2 - 1)) and (v13:RunicPowerDeficit() > (124 - 64))))) or ((13490 - 9613) == (1664 + 1911))) then
					if (((133 + 574) > (550 + 82)) and v19(v67.ArcanePulse, nil, not v14:IsInRange(26 - 18))) then
						return "arcane_pulse racials 6";
					end
				end
				if ((v67.LightsJudgment:IsCastable() and (v13:BuffUp(v67.UnholyStrengthBuff))) or ((2540 - (109 + 1885)) >= (4153 - (1269 + 200)))) then
					if (((2807 - 1342) <= (5116 - (98 + 717))) and v19(v67.LightsJudgment, nil, not v14:IsSpellInRange(v67.LightsJudgment))) then
						return "lights_judgment racials 8";
					end
				end
				v102 = 828 - (802 + 24);
			end
			if (((2938 - 1234) > (1799 - 374)) and (v102 == (1 + 2))) then
				if (v67.BagofTricks:IsCastable() or ((528 + 159) == (696 + 3538))) then
					if (v19(v67.BagofTricks, nil, not v14:IsSpellInRange(v67.BagofTricks)) or ((719 + 2611) < (3975 - 2546))) then
						return "bag_of_tricks racials 14";
					end
				end
				if (((3824 - 2677) >= (120 + 215)) and v67.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (9 + 11))) then
					if (((2834 + 601) > (1525 + 572)) and v19(v67.ArcaneTorrent, nil, not v14:IsInRange(4 + 4))) then
						return "arcane_torrent racials 16";
					end
				end
				break;
			end
			if ((v102 == (1435 - (797 + 636))) or ((18304 - 14534) >= (5660 - (1427 + 192)))) then
				if (v67.AncestralCall:IsCastable() or ((1314 + 2477) <= (3740 - 2129))) then
					if (v19(v67.AncestralCall) or ((4116 + 462) <= (910 + 1098))) then
						return "ancestral_call racials 10";
					end
				end
				if (((1451 - (192 + 134)) <= (3352 - (316 + 960))) and v67.Fireblood:IsCastable()) then
					if (v19(v67.Fireblood) or ((414 + 329) >= (3395 + 1004))) then
						return "fireblood racials 12";
					end
				end
				v102 = 3 + 0;
			end
		end
	end
	local function v90()
		if (((4415 - 3260) < (2224 - (83 + 468))) and v67.BloodBoil:IsReady() and (v14:DebuffDown(v67.BloodPlagueDebuff))) then
			if (v19(v67.BloodBoil, nil, nil, not v14:IsInMeleeRange(1816 - (1202 + 604))) or ((10848 - 8524) <= (961 - 383))) then
				return "blood_boil drw_up 2";
			end
		end
		if (((10429 - 6662) == (4092 - (45 + 280))) and v67.Tombstone:IsReady() and (v13:BuffStack(v67.BoneShieldBuff) > (5 + 0)) and (v13:Rune() >= (2 + 0)) and (v13:RunicPowerDeficit() >= (11 + 19)) and (not v67.ShatteringBone:IsAvailable() or (v67.ShatteringBone:IsAvailable() and v13:BuffUp(v67.DeathAndDecayBuff)))) then
			if (((2263 + 1826) == (720 + 3369)) and v19(v67.Tombstone)) then
				return "tombstone drw_up 4";
			end
		end
		if (((8254 - 3796) >= (3585 - (340 + 1571))) and v67.DeathStrike:IsReady() and ((v13:BuffRemains(v67.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v67.IcyTalonsBuff) <= v13:GCD()))) then
			if (((384 + 588) <= (3190 - (1733 + 39))) and v19(v67.DeathStrike, v53, nil, not v14:IsInMeleeRange(13 - 8))) then
				return "death_strike drw_up 6";
			end
		end
		if ((v67.Marrowrend:IsReady() and ((v13:BuffRemains(v67.BoneShieldBuff) <= (1038 - (125 + 909))) or (v13:BuffStack(v67.BoneShieldBuff) < v72)) and (v13:RunicPowerDeficit() > (1968 - (1096 + 852)))) or ((2216 + 2722) < (6800 - 2038))) then
			if (v19(v67.Marrowrend, nil, nil, not v14:IsInMeleeRange(5 + 0)) or ((3016 - (409 + 103)) > (4500 - (46 + 190)))) then
				return "marrowrend drw_up 10";
			end
		end
		if (((2248 - (51 + 44)) == (608 + 1545)) and v67.SoulReaper:IsReady() and (v77 == (1318 - (1114 + 203))) and ((v14:TimeToX(761 - (228 + 498)) < (2 + 3)) or (v14:HealthPercentage() <= (20 + 15))) and (v14:TimeToDie() > (v14:DebuffRemains(v67.SoulReaperDebuff) + (668 - (174 + 489))))) then
			if (v19(v67.SoulReaper, nil, nil, not v14:IsInMeleeRange(12 - 7)) or ((2412 - (830 + 1075)) >= (3115 - (303 + 221)))) then
				return "soul_reaper drw_up 12";
			end
		end
		if (((5750 - (231 + 1038)) == (3735 + 746)) and v67.SoulReaper:IsReady() and (v77 >= (1164 - (171 + 991)))) then
			if (v81.CastTargetIf(v67.SoulReaper, v76, "min", v84, v85, not v14:IsInMeleeRange(20 - 15)) or ((6250 - 3922) < (1729 - 1036))) then
				return "soul_reaper drw_up 14";
			end
		end
		if (((3464 + 864) == (15171 - 10843)) and v67.DeathAndDecay:IsReady() and (v64 ~= "Don't Cast") and v13:BuffDown(v67.DeathAndDecayBuff) and (v67.SanguineGround:IsAvailable() or v67.UnholyGround:IsAvailable())) then
			if (((4580 - 2992) >= (2146 - 814)) and (v64 == "At Player")) then
				if (v19(v69.DaDPlayer, v45, nil, not v14:IsInRange(92 - 62)) or ((5422 - (111 + 1137)) > (4406 - (91 + 67)))) then
					return "death_and_decay drw_up 16";
				end
			elseif (v19(v69.DaDCursor, v45, nil, not v14:IsInRange(89 - 59)) or ((1145 + 3441) <= (605 - (423 + 100)))) then
				return "death_and_decay drw_up 16";
			end
		end
		if (((28 + 3835) == (10695 - 6832)) and v67.BloodBoil:IsCastable() and (v77 > (2 + 0)) and (v67.BloodBoil:ChargesFractional() >= (772.1 - (326 + 445)))) then
			if (v19(v67.BloodBoil, nil, not v14:IsInMeleeRange(43 - 33)) or ((627 - 345) <= (97 - 55))) then
				return "blood_boil drw_up 18";
			end
		end
		v74 = (736 - (530 + 181)) + (v78 * v21(v67.Heartbreaker:IsAvailable()) * (883 - (614 + 267)));
		if (((4641 - (19 + 13)) >= (1246 - 480)) and v67.DeathStrike:IsReady() and ((v13:RunicPowerDeficit() <= v74) or (v13:RunicPower() >= v71))) then
			if (v19(v67.DeathStrike, v53, nil, not v14:IsSpellInRange(v67.DeathStrike)) or ((2684 - 1532) == (7107 - 4619))) then
				return "death_strike drw_up 20";
			end
		end
		if (((889 + 2533) > (5891 - 2541)) and v67.Consumption:IsCastable()) then
			if (((1818 - 941) > (2188 - (1293 + 519))) and v19(v67.Consumption, nil, not v14:IsSpellInRange(v67.Consumption))) then
				return "consumption drw_up 22";
			end
		end
		if ((v67.BloodBoil:IsReady() and (v67.BloodBoil:ChargesFractional() >= (1.1 - 0)) and (v13:BuffStack(v67.HemostasisBuff) < (13 - 8))) or ((5962 - 2844) <= (7981 - 6130))) then
			if (v19(v67.BloodBoil, nil, nil, not v14:IsInMeleeRange(23 - 13)) or ((88 + 77) >= (713 + 2779))) then
				return "blood_boil drw_up 24";
			end
		end
		if (((9175 - 5226) < (1123 + 3733)) and v67.HeartStrike:IsReady() and ((v13:RuneTimeToX(1 + 1) < v13:GCD()) or (v13:RunicPowerDeficit() >= v74))) then
			if (v19(v67.HeartStrike, nil, nil, not v14:IsSpellInRange(v67.HeartStrike)) or ((2673 + 1603) < (4112 - (709 + 387)))) then
				return "heart_strike drw_up 26";
			end
		end
	end
	local function v91()
		if (((6548 - (673 + 1185)) > (11963 - 7838)) and v28 and v67.Tombstone:IsCastable() and (v13:BuffStack(v67.BoneShieldBuff) > (16 - 11)) and (v13:Rune() >= (2 - 0)) and (v13:RunicPowerDeficit() >= (22 + 8)) and (not v67.ShatteringBone:IsAvailable() or (v67.ShatteringBone:IsAvailable() and v13:BuffUp(v67.DeathAndDecayBuff))) and (v67.DancingRuneWeapon:CooldownRemains() >= (19 + 6))) then
			if (v19(v67.Tombstone) or ((67 - 17) >= (221 + 675))) then
				return "tombstone standard 2";
			end
		end
		v73 = (19 - 9) + (v77 * v21(v67.Heartbreaker:IsAvailable()) * (3 - 1));
		if ((v67.DeathStrike:IsReady() and ((v13:BuffRemains(v67.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v67.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v71) or (v13:RunicPowerDeficit() <= v73) or (v14:TimeToDie() < (1890 - (446 + 1434))))) or ((2997 - (1040 + 243)) >= (8828 - 5870))) then
			if (v19(v67.DeathStrike, v53, nil, not v14:IsInMeleeRange(1852 - (559 + 1288))) or ((3422 - (609 + 1322)) < (1098 - (13 + 441)))) then
				return "death_strike standard 4";
			end
		end
		if (((2630 - 1926) < (2585 - 1598)) and v67.DeathsCaress:IsReady() and ((v13:BuffRemains(v67.BoneShieldBuff) <= (19 - 15)) or (v13:BuffStack(v67.BoneShieldBuff) < (v72 + 1 + 0))) and (v13:RunicPowerDeficit() > (36 - 26)) and not (v67.InsatiableBlade:IsAvailable() and (v67.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v67.BoneShieldBuff))) and not v67.Consumption:IsAvailable() and not v67.Blooddrinker:IsAvailable() and (v13:RuneTimeToX(2 + 1) > v13:GCD())) then
			if (((1630 + 2088) > (5656 - 3750)) and v19(v67.DeathsCaress, nil, nil, not v14:IsSpellInRange(v67.DeathsCaress))) then
				return "deaths_caress standard 6";
			end
		end
		if ((v67.Marrowrend:IsReady() and ((v13:BuffRemains(v67.BoneShieldBuff) <= (3 + 1)) or (v13:BuffStack(v67.BoneShieldBuff) < v72)) and (v13:RunicPowerDeficit() > (36 - 16)) and not (v67.InsatiableBlade:IsAvailable() and (v67.DancingRuneWeapon:CooldownRemains() < v13:BuffRemains(v67.BoneShieldBuff)))) or ((634 + 324) > (2022 + 1613))) then
			if (((2516 + 985) <= (3772 + 720)) and v19(v67.Marrowrend, nil, nil, not v14:IsInMeleeRange(5 + 0))) then
				return "marrowrend standard 8";
			end
		end
		if (v67.Consumption:IsCastable() or ((3875 - (153 + 280)) < (7357 - 4809))) then
			if (((2582 + 293) >= (579 + 885)) and v19(v67.Consumption, nil, not v14:IsSpellInRange(v67.Consumption))) then
				return "consumption standard 10";
			end
		end
		if ((v67.SoulReaper:IsReady() and (v77 == (1 + 0)) and ((v14:TimeToX(32 + 3) < (4 + 1)) or (v14:HealthPercentage() <= (53 - 18))) and (v14:TimeToDie() > (v14:DebuffRemains(v67.SoulReaperDebuff) + 4 + 1))) or ((5464 - (89 + 578)) >= (3496 + 1397))) then
			if (v19(v67.SoulReaper, nil, nil, not v14:IsInMeleeRange(10 - 5)) or ((1600 - (572 + 477)) > (279 + 1789))) then
				return "soul_reaper standard 12";
			end
		end
		if (((1269 + 845) > (113 + 831)) and v67.SoulReaper:IsReady() and (v77 >= (88 - (84 + 2)))) then
			if (v81.CastTargetIf(v67.SoulReaper, v76, "min", v84, v85, not v14:IsInMeleeRange(8 - 3)) or ((1630 + 632) >= (3938 - (497 + 345)))) then
				return "soul_reaper standard 14";
			end
		end
		if ((v28 and v67.Bonestorm:IsReady() and (v13:RunicPower() >= (3 + 97))) or ((382 + 1873) >= (4870 - (605 + 728)))) then
			if (v19(v67.Bonestorm) or ((2738 + 1099) < (2903 - 1597))) then
				return "bonestorm standard 16";
			end
		end
		if (((136 + 2814) == (10906 - 7956)) and v67.BloodBoil:IsCastable() and (v67.BloodBoil:ChargesFractional() >= (1.8 + 0)) and ((v13:BuffStack(v67.HemostasisBuff) <= ((13 - 8) - v77)) or (v77 > (2 + 0)))) then
			if (v19(v67.BloodBoil, nil, not v14:IsInMeleeRange(499 - (457 + 32))) or ((2004 + 2719) < (4700 - (832 + 570)))) then
				return "blood_boil standard 18";
			end
		end
		if (((1071 + 65) >= (41 + 113)) and v67.HeartStrike:IsReady() and (v13:RuneTimeToX(13 - 9) < v13:GCD())) then
			if (v19(v67.HeartStrike, nil, nil, not v14:IsSpellInRange(v67.HeartStrike)) or ((131 + 140) > (5544 - (588 + 208)))) then
				return "heart_strike standard 20";
			end
		end
		if (((12775 - 8035) >= (4952 - (884 + 916))) and v67.BloodBoil:IsCastable() and (v67.BloodBoil:ChargesFractional() >= (1.1 - 0))) then
			if (v19(v67.BloodBoil, nil, nil, not v14:IsInMeleeRange(6 + 4)) or ((3231 - (232 + 421)) >= (5279 - (1569 + 320)))) then
				return "blood_boil standard 22";
			end
		end
		if (((11 + 30) <= (316 + 1345)) and v67.HeartStrike:IsReady() and (v13:Rune() > (3 - 2)) and ((v13:RuneTimeToX(608 - (316 + 289)) < v13:GCD()) or (v13:BuffStack(v67.BoneShieldBuff) > (18 - 11)))) then
			if (((28 + 573) < (5013 - (666 + 787))) and v19(v67.HeartStrike, nil, nil, not v14:IsSpellInRange(v67.HeartStrike))) then
				return "heart_strike standard 24";
			end
		end
	end
	local function v92()
		v65();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v76 = v13:GetEnemiesInMeleeRange(430 - (360 + 65));
		if (((220 + 15) < (941 - (79 + 175))) and v27) then
			v77 = #v76;
		else
			v77 = 1 - 0;
		end
		if (((3550 + 999) > (3533 - 2380)) and (v81.TargetIsValid() or v13:AffectingCombat())) then
			local v107 = 0 - 0;
			while true do
				if ((v107 == (899 - (503 + 396))) or ((4855 - (92 + 89)) < (9062 - 4390))) then
					v78 = v23(v77, (v13:BuffUp(v67.DeathAndDecayBuff) and (3 + 2)) or (2 + 0));
					v79 = v83(v76);
					v107 = 3 - 2;
				end
				if (((502 + 3166) < (10399 - 5838)) and (v107 == (1 + 0))) then
					v75 = v13:IsTankingAoE(4 + 4) or v13:IsTanking(v14);
					break;
				end
			end
		end
		if (v81.TargetIsValid() or ((1385 - 930) == (450 + 3155))) then
			local v108 = 0 - 0;
			local v109;
			while true do
				if ((v108 == (1247 - (485 + 759))) or ((6161 - 3498) == (4501 - (442 + 747)))) then
					if (((5412 - (832 + 303)) <= (5421 - (88 + 858))) and v67.DeathStrike:IsReady() and ((v13:BuffRemains(v67.CoagulopathyBuff) <= v13:GCD()) or (v13:BuffRemains(v67.IcyTalonsBuff) <= v13:GCD()) or (v13:RunicPower() >= v71) or (v13:RunicPowerDeficit() <= v73) or (v14:TimeToDie() < (4 + 6)))) then
						if (v19(v67.DeathStrike, v53, nil, not v14:IsSpellInRange(v67.DeathStrike)) or ((721 + 149) == (49 + 1140))) then
							return "death_strike main 10";
						end
					end
					if (((2342 - (766 + 23)) <= (15466 - 12333)) and v67.Blooddrinker:IsReady() and (v13:BuffDown(v67.DancingRuneWeaponBuff))) then
						if (v19(v67.Blooddrinker, nil, nil, not v14:IsSpellInRange(v67.Blooddrinker)) or ((3059 - 822) >= (9250 - 5739))) then
							return "blooddrinker main 12";
						end
					end
					if (v28 or ((4493 - 3169) > (4093 - (1036 + 37)))) then
						local v140 = 0 + 0;
						local v141;
						while true do
							if ((v140 == (0 - 0)) or ((2354 + 638) == (3361 - (641 + 839)))) then
								v141 = v89();
								if (((4019 - (910 + 3)) > (3890 - 2364)) and v141) then
									return v141;
								end
								break;
							end
						end
					end
					v108 = 1688 - (1466 + 218);
				end
				if (((1390 + 1633) < (5018 - (556 + 592))) and (v108 == (0 + 0))) then
					if (((951 - (329 + 479)) > (928 - (174 + 680))) and not v13:AffectingCombat()) then
						local v142 = 0 - 0;
						local v143;
						while true do
							if (((37 - 19) < (1508 + 604)) and (v142 == (739 - (396 + 343)))) then
								v143 = v86();
								if (((98 + 999) <= (3105 - (29 + 1448))) and v143) then
									return v143;
								end
								break;
							end
						end
					end
					if (((6019 - (135 + 1254)) == (17442 - 12812)) and v75) then
						local v144 = v87();
						if (((16528 - 12988) > (1789 + 894)) and v144) then
							return v144;
						end
					end
					if (((6321 - (389 + 1138)) >= (3849 - (102 + 472))) and v13:IsChanneling(v67.Blooddrinker) and v13:BuffUp(v67.BoneShieldBuff) and (v79 == (0 + 0)) and not v13:ShouldStopCasting() and (v13:CastRemains() > (0.2 + 0))) then
						if (((1384 + 100) == (3029 - (320 + 1225))) and v9.CastAnnotated(v67.Pool, false, "WAIT")) then
							return "Pool During Blooddrinker";
						end
					end
					v108 = 1 - 0;
				end
				if (((877 + 555) < (5019 - (157 + 1307))) and (v108 == (1860 - (821 + 1038)))) then
					v71 = v61;
					if (v30 or ((2657 - 1592) > (392 + 3186))) then
						local v145 = v88();
						if (v145 or ((8516 - 3721) < (524 + 883))) then
							return v145;
						end
					end
					if (((4592 - 2739) < (5839 - (834 + 192))) and v28 and v67.RaiseDead:IsCastable()) then
						if (v19(v67.RaiseDead, nil) or ((180 + 2641) < (624 + 1807))) then
							return "raise_dead main 4";
						end
					end
					v108 = 1 + 1;
				end
				if ((v108 == (7 - 2)) or ((3178 - (300 + 4)) < (583 + 1598))) then
					if ((v28 and v67.EmpowerRuneWeapon:IsReady() and (v13:Rune() < (15 - 9)) and (v13:RunicPowerDeficit() > (367 - (112 + 250)))) or ((1072 + 1617) <= (858 - 515))) then
						if (v19(v67.EmpowerRuneWeapon) or ((1071 + 798) == (1039 + 970))) then
							return "empower_rune_weapon main 20";
						end
					end
					if ((v28 and v67.AbominationLimb:IsCastable()) or ((2653 + 893) < (1152 + 1170))) then
						if (v19(v67.AbominationLimb, nil, not v14:IsInRange(15 + 5)) or ((3496 - (1001 + 413)) == (10643 - 5870))) then
							return "abomination_limb main 22";
						end
					end
					if (((4126 - (244 + 638)) > (1748 - (627 + 66))) and v28 and v67.DancingRuneWeapon:IsCastable() and (v13:BuffDown(v67.DancingRuneWeaponBuff))) then
						if (v19(v67.DancingRuneWeapon, v52) or ((9871 - 6558) <= (2380 - (512 + 90)))) then
							return "dancing_rune_weapon main 24";
						end
					end
					v108 = 1912 - (1665 + 241);
				end
				if ((v108 == (721 - (373 + 344))) or ((641 + 780) >= (557 + 1547))) then
					if (((4779 - 2967) <= (5497 - 2248)) and v28 and v67.SacrificialPact:IsReady() and v80.GhoulActive() and v13:BuffDown(v67.DancingRuneWeaponBuff) and ((v80.GhoulRemains() < (1101 - (35 + 1064))) or (v14:TimeToDie() < v13:GCD()))) then
						if (((1181 + 442) <= (4186 - 2229)) and v19(v67.SacrificialPact, v47)) then
							return "sacrificial_pact main 14";
						end
					end
					if (((18 + 4394) == (5648 - (298 + 938))) and v28 and v67.BloodTap:IsCastable() and (((v13:Rune() <= (1261 - (233 + 1026))) and (v13:RuneTimeToX(1670 - (636 + 1030)) > v13:GCD()) and (v67.BloodTap:ChargesFractional() >= (1.8 + 0))) or (v13:RuneTimeToX(3 + 0) > v13:GCD()))) then
						if (((520 + 1230) >= (57 + 785)) and v19(v67.BloodTap, v57)) then
							return "blood_tap main 16";
						end
					end
					if (((4593 - (55 + 166)) > (359 + 1491)) and v28 and v67.GorefiendsGrasp:IsCastable() and (v67.TighteningGrasp:IsAvailable())) then
						if (((24 + 208) < (3135 - 2314)) and v19(v67.GorefiendsGrasp, nil, not v14:IsSpellInRange(v67.GorefiendsGrasp))) then
							return "gorefiends_grasp main 18";
						end
					end
					v108 = 302 - (36 + 261);
				end
				if (((905 - 387) < (2270 - (34 + 1334))) and (v108 == (3 + 3))) then
					if (((2327 + 667) > (2141 - (1035 + 248))) and (v13:BuffUp(v67.DancingRuneWeaponBuff))) then
						local v146 = v90();
						if (v146 or ((3776 - (20 + 1)) <= (477 + 438))) then
							return v146;
						end
						if (((4265 - (134 + 185)) > (4876 - (549 + 584))) and v9.CastAnnotated(v67.Pool, false, "WAIT")) then
							return "Wait/Pool for DRWUp";
						end
					end
					v109 = v91();
					if (v109 or ((2020 - (314 + 371)) >= (11349 - 8043))) then
						return v109;
					end
					v108 = 975 - (478 + 490);
				end
				if (((2567 + 2277) > (3425 - (786 + 386))) and (v108 == (6 - 4))) then
					if (((1831 - (1055 + 324)) == (1792 - (1093 + 247))) and v67.VampiricBlood:IsCastable() and v13:BuffDown(v67.VampiricBloodBuff) and v13:BuffDown(v67.VampiricStrengthBuff)) then
						if (v19(v67.VampiricBlood, v56) or ((4050 + 507) < (220 + 1867))) then
							return "vampiric_blood main 5";
						end
					end
					if (((15380 - 11506) == (13147 - 9273)) and v67.DeathsCaress:IsReady() and (v13:BuffDown(v67.BoneShieldBuff))) then
						if (v19(v67.DeathsCaress, nil, nil, not v14:IsSpellInRange(v67.DeathsCaress)) or ((5514 - 3576) > (12401 - 7466))) then
							return "deaths_caress main 6";
						end
					end
					if ((v67.DeathAndDecay:IsReady() and (v64 ~= "Don't Cast") and v13:BuffDown(v67.DeathAndDecayBuff) and (v67.UnholyGround:IsAvailable() or v67.SanguineGround:IsAvailable() or (v77 > (2 + 1)) or v13:BuffUp(v67.CrimsonScourgeBuff))) or ((16392 - 12137) < (11798 - 8375))) then
						if (((1097 + 357) <= (6370 - 3879)) and (v64 == "At Player")) then
							if (v19(v69.DaDPlayer, v45, nil, not v14:IsInRange(718 - (364 + 324))) or ((11395 - 7238) <= (6725 - 3922))) then
								return "death_and_decay drw_up 16";
							end
						elseif (((1609 + 3244) >= (12477 - 9495)) and v19(v69.DaDCursor, v45, nil, not v14:IsInRange(48 - 18))) then
							return "death_and_decay drw_up 16";
						end
					end
					v108 = 8 - 5;
				end
				if (((5402 - (1249 + 19)) > (3031 + 326)) and ((27 - 20) == v108)) then
					if (v9.CastAnnotated(v67.Pool, false, "WAIT") or ((4503 - (686 + 400)) < (1989 + 545))) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v93()
		local v106 = 229 - (73 + 156);
		while true do
			if (((0 + 0) == v106) or ((3533 - (721 + 90)) <= (2 + 162))) then
				v67.MarkofFyralathDebuff:RegisterAuraTracking();
				v9.Print("Blood DK by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(811 - 561, v92, v93);
end;
return v0["Epix_DeathKnight_Blood.lua"]();

