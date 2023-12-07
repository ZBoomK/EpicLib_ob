local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((13551 - 10648) >= (2487 - 992)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Fury.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26;
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
	local v66;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90 = v19.Commons.Everyone;
	local v91 = v17.Warrior.Fury;
	local v92 = v18.Warrior.Fury;
	local v93 = v22.Warrior.Fury;
	local v94 = {};
	local v95 = 30763 - 19652;
	local v96 = 11436 - (45 + 280);
	v9:RegisterForEvent(function()
		local v113 = 0 + 0;
		while true do
			if (((3972 + 574) >= (831 + 1444)) and (v113 == (0 + 0))) then
				v95 = 1955 + 9156;
				v96 = 20574 - 9463;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v97, v98;
	local v99;
	local function v100()
		local v114 = UnitGetTotalAbsorbs(v14);
		if (((2730 - (340 + 1571)) >= (9 + 13)) and (v114 > (1772 - (1733 + 39)))) then
			return true;
		else
			return false;
		end
	end
	local function v101()
		if (((8688 - 5526) == (4196 - (125 + 909))) and v91.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) then
			if (v23(v91.BitterImmunity) or ((4317 - (1096 + 852)) > (1987 + 2442))) then
				return "bitter_immunity defensive";
			end
		end
		if (((5847 - 1752) >= (3088 + 95)) and v91.EnragedRegeneration:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) then
			if (v23(v91.EnragedRegeneration) or ((4223 - (409 + 103)) < (1244 - (46 + 190)))) then
				return "enraged_regeneration defensive";
			end
		end
		if ((v91.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) or ((1144 - (51 + 44)) <= (256 + 650))) then
			if (((5830 - (1114 + 203)) > (3452 - (228 + 498))) and v23(v91.IgnorePain, nil, nil, true)) then
				return "ignore_pain defensive";
			end
		end
		if ((v91.RallyingCry:IsCastable() and v65 and v13:BuffDown(v91.AspectsFavorBuff) and v13:BuffDown(v91.RallyingCry) and (((v13:HealthPercentage() <= v74) and v90.IsSoloMode()) or v90.AreUnitsBelowHealthPercentage(v74, v75))) or ((321 + 1160) >= (1469 + 1189))) then
			if (v23(v91.RallyingCry) or ((3883 - (174 + 489)) == (3553 - 2189))) then
				return "rallying_cry defensive";
			end
		end
		if ((v91.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:UnitName() ~= v13:UnitName())) or ((2959 - (830 + 1075)) > (3916 - (303 + 221)))) then
			if (v23(v93.InterveneFocus) or ((1945 - (231 + 1038)) >= (1369 + 273))) then
				return "intervene defensive";
			end
		end
		if (((5298 - (171 + 991)) > (9878 - 7481)) and v91.DefensiveStance:IsCastable() and v67 and (v13:HealthPercentage() <= v77) and v13:BuffDown(v91.DefensiveStance, true)) then
			if (v23(v91.DefensiveStance) or ((11637 - 7303) == (10593 - 6348))) then
				return "defensive_stance defensive";
			end
		end
		if ((v91.BerserkerStance:IsCastable() and v67 and (v13:HealthPercentage() > v80) and v13:BuffDown(v91.BerserkerStance, true)) or ((3423 + 853) <= (10624 - 7593))) then
			if (v23(v91.BerserkerStance) or ((13794 - 9012) <= (1932 - 733))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if ((v92.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) or ((15035 - 10171) < (3150 - (111 + 1137)))) then
			if (((4997 - (91 + 67)) >= (11012 - 7312)) and v23(v93.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v69 and (v13:HealthPercentage() <= v79)) or ((269 + 806) > (2441 - (423 + 100)))) then
			local v157 = 0 + 0;
			while true do
				if (((1095 - 699) <= (1983 + 1821)) and (v157 == (771 - (326 + 445)))) then
					if ((v85 == "Refreshing Healing Potion") or ((18193 - 14024) == (4872 - 2685))) then
						if (((3281 - 1875) == (2117 - (530 + 181))) and v92.RefreshingHealingPotion:IsReady()) then
							if (((2412 - (614 + 267)) < (4303 - (19 + 13))) and v23(v93.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1033 - 398) == (1479 - 844)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (((9635 - 6262) <= (924 + 2632)) and v92.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v93.RefreshingHealingPotion) or ((5787 - 2496) < (6802 - 3522))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v102()
		local v115 = 1812 - (1293 + 519);
		while true do
			if (((8948 - 4562) >= (2278 - 1405)) and (v115 == (1 - 0))) then
				v26 = v90.HandleBottomTrinket(v94, v29, 172 - 132, nil);
				if (((2169 - 1248) <= (584 + 518)) and v26) then
					return v26;
				end
				break;
			end
			if (((961 + 3745) >= (2236 - 1273)) and (v115 == (0 + 0))) then
				v26 = v90.HandleTopTrinket(v94, v29, 14 + 26, nil);
				if (v26 or ((600 + 360) <= (1972 - (709 + 387)))) then
					return v26;
				end
				v115 = 1859 - (673 + 1185);
			end
		end
	end
	local function v103()
		if ((v30 and ((v51 and v29) or not v51) and (v89 < v96) and v91.Avatar:IsCastable() and not v91.TitansTorment:IsAvailable()) or ((5991 - 3925) == (2992 - 2060))) then
			if (((7938 - 3113) < (3464 + 1379)) and v23(v91.Avatar, not v99)) then
				return "avatar precombat 6";
			end
		end
		if ((v43 and ((v54 and v29) or not v54) and (v89 < v96) and v91.Recklessness:IsCastable() and not v91.RecklessAbandon:IsAvailable()) or ((2897 + 980) >= (6125 - 1588))) then
			if (v23(v91.Recklessness, not v99) or ((1060 + 3255) < (3441 - 1715))) then
				return "recklessness precombat 8";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and v99) or ((7221 - 3542) < (2505 - (446 + 1434)))) then
			if (v23(v91.Bloodthirst, not v99) or ((5908 - (1040 + 243)) < (1886 - 1254))) then
				return "bloodthirst precombat 10";
			end
		end
		if ((v34 and v91.Charge:IsReady() and not v99) or ((1930 - (559 + 1288)) > (3711 - (609 + 1322)))) then
			if (((1000 - (13 + 441)) <= (4024 - 2947)) and v23(v91.Charge, not v14:IsSpellInRange(v91.Charge))) then
				return "charge precombat 12";
			end
		end
	end
	local function v104()
		local v116 = 0 - 0;
		local v117;
		while true do
			if ((v116 == (29 - 23)) or ((38 + 958) > (15620 - 11319))) then
				if (((1446 + 2624) > (302 + 385)) and v91.Rampage:IsReady() and v41) then
					if (v23(v91.Rampage, not v99) or ((1946 - 1290) >= (1823 + 1507))) then
						return "rampage single_target 47";
					end
				end
				if ((v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) or ((4582 - 2090) <= (222 + 113))) then
					if (((2404 + 1918) >= (1841 + 721)) and v23(v91.Slam, not v99)) then
						return "slam single_target 48";
					end
				end
				if ((v91.Bloodbath:IsCastable() and v32) or ((3054 + 583) >= (3689 + 81))) then
					if (v23(v91.Bloodbath, not v99) or ((2812 - (153 + 280)) > (13219 - 8641))) then
						return "bloodbath single_target 50";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40) or ((434 + 49) > (294 + 449))) then
					if (((1285 + 1169) > (525 + 53)) and v23(v91.RagingBlow, not v99)) then
						return "raging_blow single_target 52";
					end
				end
				v116 = 6 + 1;
			end
			if (((1416 - 486) < (2756 + 1702)) and (v116 == (672 - (89 + 578)))) then
				if (((473 + 189) <= (2020 - 1048)) and v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) then
					if (((5419 - (572 + 477)) == (590 + 3780)) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath single_target 40";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((2858 + 1904) <= (103 + 758))) then
					if (v23(v91.CrushingBlow, not v99) or ((1498 - (84 + 2)) == (7026 - 2762))) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((2283 + 885) < (2995 - (497 + 345)))) then
					if (v23(v91.Bloodthirst, not v99) or ((128 + 4848) < (226 + 1106))) then
						return "bloodthirst single_target 44";
					end
				end
				if (((5961 - (605 + 728)) == (3302 + 1326)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 - 0))) then
					if (v23(v91.RagingBlow, not v99) or ((3 + 51) == (1460 - 1065))) then
						return "raging_blow single_target 46";
					end
				end
				v116 = 6 + 0;
			end
			if (((226 - 144) == (62 + 20)) and (v116 == (490 - (457 + 32)))) then
				v117 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (9 + 11)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (1412 - (832 + 570))) + (v13:BuffStack(v91.BloodcrazeBuff) * (15 + 0));
				if ((v117 >= (25 + 70)) or (not v91.ColdSteelHotBlood:IsAvailable() and v13:HasTier(106 - 76, 2 + 2)) or ((1377 - (588 + 208)) < (759 - 477))) then
					local v174 = 1800 - (884 + 916);
					while true do
						if (((0 - 0) == v174) or ((2673 + 1936) < (3148 - (232 + 421)))) then
							if (((3041 - (1569 + 320)) == (283 + 869)) and v91.Bloodbath:IsCastable() and v32) then
								if (((361 + 1535) <= (11531 - 8109)) and v23(v91.Bloodbath, not v99)) then
									return "bloodbath single_target 10";
								end
							end
							if ((v91.Bloodthirst:IsCastable() and v33) or ((1595 - (316 + 289)) > (4240 - 2620))) then
								if (v23(v91.Bloodthirst, not v99) or ((41 + 836) > (6148 - (666 + 787)))) then
									return "bloodthirst single_target 12";
								end
							end
							break;
						end
					end
				end
				if (((3116 - (360 + 65)) >= (1730 + 121)) and v91.Bloodbath:IsCastable() and v32 and v13:HasTier(285 - (79 + 175), 2 - 0)) then
					if (v23(v91.Bloodbath, not v99) or ((2330 + 655) >= (14884 - 10028))) then
						return "bloodbath single_target 14";
					end
				end
				if (((8234 - 3958) >= (2094 - (503 + 396))) and v46 and ((v56 and v29) or not v56) and (v89 < v96) and v91.ThunderousRoar:IsCastable() and v13:BuffUp(v91.EnrageBuff)) then
					if (((3413 - (92 + 89)) <= (9098 - 4408)) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(5 + 3))) then
						return "thunderous_roar single_target 16";
					end
				end
				v116 = 2 + 0;
			end
			if ((v116 == (27 - 20)) or ((123 + 773) >= (7173 - 4027))) then
				if (((2671 + 390) >= (1413 + 1545)) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
					if (((9706 - 6519) >= (81 + 563)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow single_target 54";
					end
				end
				if (((981 - 337) <= (1948 - (485 + 759))) and v91.Bloodthirst:IsCastable() and v33) then
					if (((2216 - 1258) > (2136 - (442 + 747))) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst single_target 56";
					end
				end
				if (((5627 - (832 + 303)) >= (3600 - (88 + 858))) and v28 and v91.Whirlwind:IsCastable() and v47) then
					if (((1050 + 2392) >= (1244 + 259)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(1 + 7))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if ((v116 == (793 - (766 + 23))) or ((15649 - 12479) <= (2002 - 538))) then
				if ((v91.Rampage:IsReady() and v41 and (v14:HealthPercentage() < (92 - 57)) and v91.Massacre:IsAvailable()) or ((16280 - 11483) == (5461 - (1036 + 37)))) then
					if (((391 + 160) <= (1326 - 645)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 32";
					end
				end
				if (((2578 + 699) > (1887 - (641 + 839))) and v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff))) and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
					if (((5608 - (910 + 3)) >= (3607 - 2192)) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1685 - (1466 + 218))) and v91.WrathandFury:IsAvailable()) or ((1477 + 1735) <= (2092 - (556 + 592)))) then
					if (v23(v91.RagingBlow, not v99) or ((1101 + 1995) <= (2606 - (329 + 479)))) then
						return "raging_blow single_target 36";
					end
				end
				if (((4391 - (174 + 680)) == (12153 - 8616)) and v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (1 - 0)) and v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
					if (((2740 + 1097) >= (2309 - (396 + 343))) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow single_target 38";
					end
				end
				v116 = 1 + 4;
			end
			if (((1477 - (29 + 1448)) == v116) or ((4339 - (135 + 1254)) == (14360 - 10548))) then
				if (((22052 - 17329) >= (1545 + 773)) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1528 - (389 + 1138))) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
					if (v23(v91.Whirlwind, not v14:IsInMeleeRange(582 - (102 + 472))) or ((1913 + 114) > (1582 + 1270))) then
						return "whirlwind single_target 2";
					end
				end
				if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) or ((1060 + 76) > (5862 - (320 + 1225)))) then
					if (((8452 - 3704) == (2906 + 1842)) and v23(v91.Execute, not v99)) then
						return "execute single_target 4";
					end
				end
				if (((5200 - (157 + 1307)) <= (6599 - (821 + 1038))) and v38 and ((v52 and v29) or not v52) and v91.OdynsFury:IsCastable() and (v89 < v96) and v13:BuffUp(v91.EnrageBuff) and ((v91.DancingBlades:IsAvailable() and (v13:BuffRemains(v91.DancingBladesBuff) < (12 - 7))) or not v91.DancingBlades:IsAvailable())) then
					if (v23(v91.OdynsFury, not v14:IsInMeleeRange(1 + 7)) or ((6021 - 2631) <= (1139 + 1921))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (210 - 125)))) or ((2025 - (834 + 192)) > (172 + 2521))) then
					if (((119 + 344) < (13 + 588)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 8";
					end
				end
				v116 = 1 - 0;
			end
			if ((v116 == (306 - (300 + 4))) or ((584 + 1599) < (1798 - 1111))) then
				if (((4911 - (112 + 250)) == (1814 + 2735)) and v91.Onslaught:IsReady() and v39 and (v13:BuffUp(v91.EnrageBuff) or v91.Tenderize:IsAvailable())) then
					if (((11704 - 7032) == (2677 + 1995)) and v23(v91.Onslaught, not v99)) then
						return "onslaught single_target 18";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v35 and v91.WrathandFury:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((1897 + 1771) < (296 + 99))) then
					if (v23(v91.CrushingBlow, not v99) or ((2066 + 2100) == (339 + 116))) then
						return "crushing_blow single_target 20";
					end
				end
				if ((v91.Execute:IsReady() and v36 and ((v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.AshenJuggernautBuff)) or ((v13:BuffRemains(v91.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (1449 - (1001 + 413))) and v91.Massacre:IsAvailable()) or (v14:HealthPercentage() > (44 - 24)))))) or ((5331 - (244 + 638)) == (3356 - (627 + 66)))) then
					if (v23(v91.Execute, not v99) or ((12743 - 8466) < (3591 - (512 + 90)))) then
						return "execute single_target 22";
					end
				end
				if ((v91.Rampage:IsReady() and v41 and v91.RecklessAbandon:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (1991 - (1665 + 241))))) or ((1587 - (373 + 344)) >= (1872 + 2277))) then
					if (((586 + 1626) < (8395 - 5212)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 24";
					end
				end
				v116 = 4 - 1;
			end
			if (((5745 - (35 + 1064)) > (2177 + 815)) and (v116 == (6 - 3))) then
				if (((6 + 1428) < (4342 - (298 + 938))) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) then
					if (((2045 - (233 + 1026)) < (4689 - (636 + 1030))) and v23(v91.Execute, not v99)) then
						return "execute single_target 26";
					end
				end
				if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable()) or ((1249 + 1193) < (73 + 1))) then
					if (((1348 + 3187) == (307 + 4228)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 28";
					end
				end
				if ((v91.Execute:IsReady() and v36) or ((3230 - (55 + 166)) <= (408 + 1697))) then
					if (((185 + 1645) < (14011 - 10342)) and v23(v91.Execute, not v99)) then
						return "execute single_target 29";
					end
				end
				if ((v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) or ((1727 - (36 + 261)) >= (6316 - 2704))) then
					if (((4051 - (34 + 1334)) >= (946 + 1514)) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath single_target 30";
					end
				end
				v116 = 4 + 0;
			end
		end
	end
	local function v105()
		if ((v91.Recklessness:IsCastable() and ((v54 and v29) or not v54) and v43 and (v89 < v96) and ((v98 > (1284 - (1035 + 248))) or (v96 < (33 - (20 + 1))))) or ((940 + 864) >= (3594 - (134 + 185)))) then
			if (v23(v91.Recklessness, not v99) or ((2550 - (549 + 584)) > (4314 - (314 + 371)))) then
				return "recklessness multi_target 2";
			end
		end
		if (((16460 - 11665) > (1370 - (478 + 490))) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (1 + 0)) and v91.TitanicRage:IsAvailable() and (v13:BuffDown(v91.MeatCleaverBuff) or v13:BuffUp(v91.AvatarBuff) or v13:BuffUp(v91.RecklessnessBuff))) then
			if (((5985 - (786 + 386)) > (11546 - 7981)) and v23(v91.OdynsFury, not v14:IsInMeleeRange(1387 - (1055 + 324)))) then
				return "odyns_fury multi_target 4";
			end
		end
		if (((5252 - (1093 + 247)) == (3477 + 435)) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1 + 0)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
			if (((11199 - 8378) <= (16371 - 11547)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(22 - 14))) then
				return "whirlwind multi_target 6";
			end
		end
		if (((4367 - 2629) <= (781 + 1414)) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) then
			if (((157 - 116) <= (10402 - 7384)) and v23(v91.Execute, not v99)) then
				return "execute multi_target 8";
			end
		end
		if (((1618 + 527) <= (10495 - 6391)) and v91.ThunderousRoar:IsCastable() and ((v56 and v29) or not v56) and v46 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
			if (((3377 - (364 + 324)) < (13281 - 8436)) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(19 - 11))) then
				return "thunderous_roar multi_target 10";
			end
		end
		if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (1 + 0)) and v13:BuffUp(v91.EnrageBuff)) or ((9715 - 7393) > (4198 - 1576))) then
			if (v23(v91.OdynsFury, not v14:IsInMeleeRange(24 - 16)) or ((5802 - (1249 + 19)) == (1880 + 202))) then
				return "odyns_fury multi_target 12";
			end
		end
		local v118 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (77 - 57)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (1096 - (686 + 400))) + (v13:BuffStack(v91.BloodcrazeBuff) * (12 + 3));
		if (((v118 >= (324 - (73 + 156))) and v13:HasTier(1 + 29, 815 - (721 + 90))) or ((18 + 1553) > (6061 - 4194))) then
			local v158 = 470 - (224 + 246);
			while true do
				if ((v158 == (0 - 0)) or ((4886 - 2232) >= (544 + 2452))) then
					if (((95 + 3883) > (1546 + 558)) and v91.Bloodbath:IsCastable() and v32) then
						if (((5954 - 2959) > (5128 - 3587)) and v23(v91.Bloodbath, not v99)) then
							return "bloodbath multi_target 14";
						end
					end
					if (((3762 - (203 + 310)) > (2946 - (1238 + 755))) and v91.Bloodthirst:IsCastable() and v33) then
						if (v23(v91.Bloodthirst, not v99) or ((229 + 3044) > (6107 - (709 + 825)))) then
							return "bloodthirst multi_target 16";
						end
					end
					break;
				end
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v91.WrathandFury:IsAvailable() and v35 and v13:BuffUp(v91.EnrageBuff)) or ((5806 - 2655) < (1870 - 586))) then
			if (v23(v91.CrushingBlow, not v99) or ((2714 - (196 + 668)) == (6036 - 4507))) then
				return "crushing_blow multi_target 14";
			end
		end
		if (((1700 - 879) < (2956 - (171 + 662))) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) then
			if (((995 - (4 + 89)) < (8148 - 5823)) and v23(v91.Execute, not v99)) then
				return "execute multi_target 16";
			end
		end
		if (((313 + 545) <= (13009 - 10047)) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
			if (v23(v91.OdynsFury, not v14:IsInMeleeRange(4 + 4)) or ((5432 - (35 + 1451)) < (2741 - (28 + 1425)))) then
				return "odyns_fury multi_target 18";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (2103 - (941 + 1052))) and v91.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (77 + 3)) and not v91.OverwhelmingRage:IsAvailable()))) or ((4756 - (822 + 692)) == (809 - 242))) then
			if (v23(v91.Rampage, not v99) or ((399 + 448) >= (1560 - (45 + 252)))) then
				return "rampage multi_target 20";
			end
		end
		if ((v91.Execute:IsReady() and v36) or ((2230 + 23) == (638 + 1213))) then
			if (v23(v91.Execute, not v99) or ((5078 - 2991) > (2805 - (114 + 319)))) then
				return "execute multi_target 22";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) or ((6381 - 1936) < (5315 - 1166))) then
			if (v23(v91.Bloodbath, not v99) or ((1159 + 659) == (126 - 41))) then
				return "bloodbath multi_target 24";
			end
		end
		if (((1320 - 690) < (4090 - (556 + 1407))) and v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff)))) then
			if (v23(v91.Bloodthirst, not v99) or ((3144 - (741 + 465)) == (2979 - (170 + 295)))) then
				return "bloodthirst multi_target 26";
			end
		end
		if (((2242 + 2013) >= (51 + 4)) and v91.Onslaught:IsReady() and v39 and ((not v91.Annihilator:IsAvailable() and v13:BuffUp(v91.EnrageBuff)) or v91.Tenderize:IsAvailable())) then
			if (((7383 - 4384) > (959 + 197)) and v23(v91.Onslaught, not v99)) then
				return "onslaught multi_target 28";
			end
		end
		if (((1508 + 842) > (655 + 500)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1231 - (957 + 273))) and v91.WrathandFury:IsAvailable()) then
			if (((1078 + 2951) <= (1943 + 2910)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow multi_target 30";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (3 - 2)) and v91.WrathandFury:IsAvailable()) or ((1359 - 843) > (10488 - 7054))) then
			if (((20034 - 15988) >= (4813 - (389 + 1391))) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow multi_target 32";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) or ((1706 + 1013) <= (151 + 1296))) then
			if (v23(v91.Bloodbath, not v99) or ((9411 - 5277) < (4877 - (783 + 168)))) then
				return "bloodbath multi_target 34";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable()) or ((550 - 386) >= (2740 + 45))) then
			if (v23(v91.CrushingBlow, not v99) or ((836 - (309 + 2)) == (6476 - 4367))) then
				return "crushing_blow multi_target 36";
			end
		end
		if (((1245 - (1090 + 122)) == (11 + 22)) and v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable()) then
			if (((10256 - 7202) <= (2748 + 1267)) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst multi_target 38";
			end
		end
		if (((2989 - (628 + 490)) < (607 + 2775)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (2 - 1))) then
			if (((5908 - 4615) <= (2940 - (431 + 343))) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow multi_target 40";
			end
		end
		if ((v91.Rampage:IsReady() and v41) or ((5208 - 2629) < (355 - 232))) then
			if (v23(v91.Rampage, not v99) or ((669 + 177) >= (303 + 2065))) then
				return "rampage multi_target 42";
			end
		end
		if ((v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) or ((5707 - (556 + 1139)) <= (3373 - (6 + 9)))) then
			if (((274 + 1220) <= (1540 + 1465)) and v23(v91.Slam, not v99)) then
				return "slam multi_target 44";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32) or ((3280 - (28 + 141)) == (827 + 1307))) then
			if (((2906 - 551) == (1668 + 687)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath multi_target 46";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40) or ((1905 - (486 + 831)) <= (1124 - 692))) then
			if (((16888 - 12091) >= (737 + 3158)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow multi_target 48";
			end
		end
		if (((11310 - 7733) == (4840 - (668 + 595))) and v91.CrushingBlow:IsCastable() and v35) then
			if (((3414 + 380) > (745 + 2948)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow multi_target 50";
			end
		end
		if ((v91.Whirlwind:IsCastable() and v47) or ((3477 - 2202) == (4390 - (23 + 267)))) then
			if (v23(v91.Whirlwind, not v14:IsInMeleeRange(1952 - (1129 + 815))) or ((1978 - (371 + 16)) >= (5330 - (1326 + 424)))) then
				return "whirlwind multi_target 52";
			end
		end
	end
	local function v106()
		v26 = v101();
		if (((1861 - 878) <= (6606 - 4798)) and v26) then
			return v26;
		end
		if (v84 or ((2268 - (88 + 30)) <= (1968 - (720 + 51)))) then
			v26 = v90.HandleIncorporeal(v91.StormBolt, v93.StormBoltMouseover, 44 - 24, true);
			if (((5545 - (421 + 1355)) >= (1934 - 761)) and v26) then
				return v26;
			end
			v26 = v90.HandleIncorporeal(v91.IntimidatingShout, v93.IntimidatingShoutMouseover, 4 + 4, true);
			if (((2568 - (286 + 797)) == (5428 - 3943)) and v26) then
				return v26;
			end
		end
		if (v90.TargetIsValid() or ((5490 - 2175) <= (3221 - (397 + 42)))) then
			if ((v34 and v91.Charge:IsCastable()) or ((274 + 602) >= (3764 - (24 + 776)))) then
				if (v23(v91.Charge, not v14:IsSpellInRange(v91.Charge)) or ((3437 - 1205) > (3282 - (222 + 563)))) then
					return "charge main 2";
				end
			end
			local v159 = v90.HandleDPSPotion(v14:BuffUp(v91.RecklessnessBuff));
			if (v159 or ((4649 - 2539) <= (240 + 92))) then
				return v159;
			end
			if (((3876 - (23 + 167)) > (4970 - (690 + 1108))) and (v89 < v96)) then
				if ((v50 and ((v29 and v58) or not v58)) or ((1615 + 2859) < (677 + 143))) then
					v26 = v102();
					if (((5127 - (40 + 808)) >= (475 + 2407)) and v26) then
						return v26;
					end
				end
			end
			if (((v89 < v96) and v49 and ((v57 and v29) or not v57)) or ((7758 - 5729) >= (3366 + 155))) then
				if (v91.BloodFury:IsCastable() or ((1078 + 959) >= (2546 + 2096))) then
					if (((2291 - (47 + 524)) < (2894 + 1564)) and v23(v91.BloodFury, not v99)) then
						return "blood_fury main 12";
					end
				end
				if ((v91.Berserking:IsCastable() and v13:BuffUp(v91.RecklessnessBuff)) or ((1191 - 755) > (4516 - 1495))) then
					if (((1625 - 912) <= (2573 - (1165 + 561))) and v23(v91.Berserking, not v99)) then
						return "berserking main 14";
					end
				end
				if (((64 + 2090) <= (12484 - 8453)) and v91.LightsJudgment:IsCastable() and v13:BuffDown(v91.RecklessnessBuff)) then
					if (((1761 + 2854) == (5094 - (341 + 138))) and v23(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment))) then
						return "lights_judgment main 16";
					end
				end
				if (v91.Fireblood:IsCastable() or ((1024 + 2766) == (1031 - 531))) then
					if (((415 - (89 + 237)) < (710 - 489)) and v23(v91.Fireblood, not v99)) then
						return "fireblood main 18";
					end
				end
				if (((4324 - 2270) >= (2302 - (581 + 300))) and v91.AncestralCall:IsCastable()) then
					if (((1912 - (855 + 365)) < (7263 - 4205)) and v23(v91.AncestralCall, not v99)) then
						return "ancestral_call main 20";
					end
				end
				if ((v91.BagofTricks:IsCastable() and v13:BuffDown(v91.RecklessnessBuff) and v13:BuffUp(v91.EnrageBuff)) or ((1063 + 2191) == (2890 - (1030 + 205)))) then
					if (v23(v91.BagofTricks, not v14:IsSpellInRange(v91.BagofTricks)) or ((1217 + 79) == (4568 + 342))) then
						return "bag_of_tricks main 22";
					end
				end
			end
			if (((3654 - (156 + 130)) == (7652 - 4284)) and (v89 < v96)) then
				local v173 = 0 - 0;
				while true do
					if (((5413 - 2770) < (1006 + 2809)) and (v173 == (2 + 1))) then
						if (((1982 - (10 + 59)) > (140 + 353)) and v91.SpearofBastion:IsCastable() and (v83 == "cursor") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and (v13:BuffUp(v91.RecklessnessBuff) or v13:BuffUp(v91.AvatarBuff) or (v96 < (98 - 78)) or (v98 > (1164 - (671 + 492))) or not v91.TitansTorment:IsAvailable() or not v13:HasTier(25 + 6, 1217 - (369 + 846)))) then
							if (((1259 + 3496) > (2926 + 502)) and v23(v93.SpearOfBastionCursor, not v99)) then
								return "spear_of_bastion main 31";
							end
						end
						break;
					end
					if (((3326 - (1036 + 909)) <= (1884 + 485)) and ((2 - 0) == v173)) then
						if ((v91.Ravager:IsCastable() and (v82 == "cursor") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (206 - (11 + 192))) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (6 + 4)))) or ((5018 - (135 + 40)) == (9894 - 5810))) then
							if (((2815 + 1854) > (799 - 436)) and v23(v93.RavagerCursor, not v99)) then
								return "ravager main 28";
							end
						end
						if ((v91.SpearofBastion:IsCastable() and (v83 == "player") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and (v13:BuffUp(v91.RecklessnessBuff) or v13:BuffUp(v91.AvatarBuff) or (v96 < (29 - 9)) or (v98 > (177 - (50 + 126))) or not v91.TitansTorment:IsAvailable() or not v13:HasTier(86 - 55, 1 + 1))) or ((3290 - (1233 + 180)) >= (4107 - (522 + 447)))) then
							if (((6163 - (107 + 1314)) >= (1683 + 1943)) and v23(v93.SpearOfBastionPlayer, not v99)) then
								return "spear_of_bastion main 30";
							end
						end
						v173 = 8 - 5;
					end
					if ((v173 == (1 + 0)) or ((9015 - 4475) == (3624 - 2708))) then
						if ((v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v9.FightRemains() < (1922 - (716 + 1194))))) or ((20 + 1136) > (466 + 3879))) then
							if (((2740 - (74 + 429)) < (8196 - 3947)) and v23(v91.Recklessness, not v99)) then
								return "recklessness main 27";
							end
						end
						if ((v91.Ravager:IsCastable() and (v82 == "player") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (2 + 1)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (22 - 12)))) or ((1899 + 784) < (70 - 47))) then
							if (((1722 - 1025) <= (1259 - (279 + 154))) and v23(v93.RavagerPlayer, not v99)) then
								return "ravager main 28";
							end
						end
						v173 = 780 - (454 + 324);
					end
					if (((870 + 235) <= (1193 - (12 + 5))) and (v173 == (0 + 0))) then
						if (((8609 - 5230) <= (1409 + 2403)) and v91.Avatar:IsCastable() and v30 and ((v51 and v29) or not v51) and ((v91.TitansTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.AvatarBuff) and (v91.OdynsFury:CooldownRemains() > (1093 - (277 + 816)))) or (v91.BerserkersTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.AvatarBuff)) or (not v91.TitansTorment:IsAvailable() and not v91.BerserkersTorment:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v96 < (85 - 65)))))) then
							if (v23(v91.Avatar, not v99) or ((1971 - (1058 + 125)) >= (303 + 1313))) then
								return "avatar main 24";
							end
						end
						if (((2829 - (815 + 160)) <= (14497 - 11118)) and v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and ((v91.Annihilator:IsAvailable() and (v91.Avatar:CooldownRemains() < (2 - 1))) or (v91.Avatar:CooldownRemains() > (10 + 30)) or not v91.Avatar:IsAvailable() or (v96 < (35 - 23)))) then
							if (((6447 - (41 + 1857)) == (6442 - (1222 + 671))) and v23(v91.Recklessness, not v99)) then
								return "recklessness main 26";
							end
						end
						v173 = 2 - 1;
					end
				end
			end
			if ((v37 and v91.HeroicThrow:IsCastable() and not v14:IsInRange(43 - 13)) or ((4204 - (229 + 953)) >= (4798 - (1111 + 663)))) then
				if (((6399 - (874 + 705)) > (308 + 1890)) and v23(v91.HeroicThrow, not v14:IsInRange(21 + 9))) then
					return "heroic_throw main";
				end
			end
			if ((v91.WreckingThrow:IsCastable() and v48 and v14:AffectingCombat() and v100()) or ((2205 - 1144) >= (138 + 4753))) then
				if (((2043 - (642 + 37)) <= (1020 + 3453)) and v23(v91.WreckingThrow, not v14:IsInRange(5 + 25))) then
					return "wrecking_throw main";
				end
			end
			if ((v28 and (v98 > (4 - 2))) or ((4049 - (233 + 221)) <= (6 - 3))) then
				v26 = v105();
				if (v26 or ((4113 + 559) == (5393 - (718 + 823)))) then
					return v26;
				end
			end
			v26 = v104();
			if (((982 + 577) == (2364 - (266 + 539))) and v26) then
				return v26;
			end
			if (v19.CastAnnotated(v91.Pool, false, "WAIT") or ((4960 - 3208) <= (2013 - (636 + 589)))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v107()
		local v119 = 0 - 0;
		while true do
			if ((v119 == (0 - 0)) or ((3097 + 810) == (65 + 112))) then
				if (((4485 - (657 + 358)) > (1469 - 914)) and not v13:AffectingCombat()) then
					if ((v91.BerserkerStance:IsCastable() and v13:BuffDown(v91.BerserkerStance, true)) or ((2214 - 1242) == (1832 - (1151 + 36)))) then
						if (((3073 + 109) >= (557 + 1558)) and v23(v91.BerserkerStance)) then
							return "berserker_stance";
						end
					end
					if (((11626 - 7733) < (6261 - (1552 + 280))) and v91.BattleShout:IsCastable() and v31 and (v13:BuffDown(v91.BattleShoutBuff, true) or v90.GroupBuffMissing(v91.BattleShoutBuff))) then
						if (v23(v91.BattleShout) or ((3701 - (64 + 770)) < (1294 + 611))) then
							return "battle_shout precombat";
						end
					end
				end
				if ((v90.TargetIsValid() and v27) or ((4076 - 2280) >= (720 + 3331))) then
					if (((2862 - (157 + 1086)) <= (7517 - 3761)) and not v13:AffectingCombat()) then
						local v177 = 0 - 0;
						while true do
							if (((926 - 322) == (824 - 220)) and (v177 == (819 - (599 + 220)))) then
								v26 = v103();
								if (v26 or ((8929 - 4445) == (2831 - (1813 + 118)))) then
									return v26;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v108()
		v31 = EpicSettings.Settings['useBattleShout'];
		v32 = EpicSettings.Settings['useBloodbath'];
		v33 = EpicSettings.Settings['useBloodthirst'];
		v34 = EpicSettings.Settings['useCharge'];
		v35 = EpicSettings.Settings['useCrushingBlow'];
		v36 = EpicSettings.Settings['useExecute'];
		v37 = EpicSettings.Settings['useHeroicThrow'];
		v39 = EpicSettings.Settings['useOnslaught'];
		v40 = EpicSettings.Settings['useRagingBlow'];
		v41 = EpicSettings.Settings['useRampage'];
		v44 = EpicSettings.Settings['useSlam'];
		v47 = EpicSettings.Settings['useWhirlwind'];
		v48 = EpicSettings.Settings['useWreckingThrow'];
		v30 = EpicSettings.Settings['useAvatar'];
		v38 = EpicSettings.Settings['useOdynsFury'];
		v42 = EpicSettings.Settings['useRavager'];
		v43 = EpicSettings.Settings['useRecklessness'];
		v45 = EpicSettings.Settings['useSpearOfBastion'];
		v46 = EpicSettings.Settings['useThunderousRoar'];
		v51 = EpicSettings.Settings['avatarWithCD'];
		v52 = EpicSettings.Settings['odynFuryWithCD'];
		v53 = EpicSettings.Settings['ravagerWithCD'];
		v54 = EpicSettings.Settings['recklessnessWithCD'];
		v55 = EpicSettings.Settings['spearOfBastionWithCD'];
		v56 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v109()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (1220 - (841 + 376))) or ((6247 - 1788) <= (259 + 854))) then
				v70 = EpicSettings.Settings['useVictoryRush'];
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v72 = EpicSettings.Settings['enragedRegenerationHP'] or (859 - (464 + 395));
				v145 = 10 - 6;
			end
			if (((1745 + 1887) > (4235 - (467 + 370))) and (v145 == (0 - 0))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v145 = 1 + 0;
			end
			if (((13992 - 9910) <= (768 + 4149)) and (v145 == (13 - 7))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (520 - (150 + 370));
				v82 = EpicSettings.Settings['ravagerSetting'] or "player";
				v83 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((6114 - (74 + 1208)) >= (3408 - 2022)) and (v145 == (18 - 14))) then
				v73 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v74 = EpicSettings.Settings['rallyingCryHP'] or (390 - (14 + 376));
				v75 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v145 = 4 + 1;
			end
			if (((121 + 16) == (131 + 6)) and (v145 == (2 - 1))) then
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v63 = EpicSettings.Settings['useEnragedRegeneration'];
				v64 = EpicSettings.Settings['useIgnorePain'];
				v145 = 2 + 0;
			end
			if ((v145 == (80 - (23 + 55))) or ((3720 - 2150) >= (2891 + 1441))) then
				v65 = EpicSettings.Settings['useRallyingCry'];
				v66 = EpicSettings.Settings['useIntervene'];
				v67 = EpicSettings.Settings['useDefensiveStance'];
				v145 = 3 + 0;
			end
			if ((v145 == (7 - 2)) or ((1279 + 2785) <= (2720 - (652 + 249)))) then
				v76 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v77 = EpicSettings.Settings['defensiveStanceHP'] or (1868 - (708 + 1160));
				v80 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
				v145 = 10 - 4;
			end
		end
	end
	local function v110()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (27 - (10 + 17));
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v50 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v58 = EpicSettings.Settings['trinketsWithCD'];
		v57 = EpicSettings.Settings['racialsWithCD'];
		v68 = EpicSettings.Settings['useHealthstone'];
		v69 = EpicSettings.Settings['useHealingPotion'];
		v78 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v79 = EpicSettings.Settings['healingPotionHP'] or (1732 - (1400 + 332));
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v111()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (1910 - (242 + 1666))) or ((2134 + 2852) < (577 + 997))) then
				if (((3773 + 653) > (1112 - (850 + 90))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (((1025 - 439) > (1845 - (360 + 1030))) and v28) then
					local v175 = 0 + 0;
					while true do
						if (((2330 - 1504) == (1135 - 309)) and (v175 == (1661 - (909 + 752)))) then
							v97 = v13:GetEnemiesInMeleeRange(1231 - (109 + 1114));
							v98 = #v97;
							break;
						end
					end
				else
					v98 = 1 - 0;
				end
				v99 = v14:IsInMeleeRange(2 + 3);
				v156 = 245 - (6 + 236);
			end
			if ((v156 == (1 + 0)) or ((3235 + 784) > (10473 - 6032))) then
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v156 = 3 - 1;
			end
			if (((3150 - (1076 + 57)) < (701 + 3560)) and ((689 - (579 + 110)) == v156)) then
				v109();
				v108();
				v110();
				v156 = 1 + 0;
			end
			if (((4170 + 546) > (43 + 37)) and (v156 == (410 - (174 + 233)))) then
				if (v90.TargetIsValid() or v13:AffectingCombat() or ((9795 - 6288) == (5742 - 2470))) then
					local v176 = 0 + 0;
					while true do
						if (((1174 - (663 + 511)) == v176) or ((782 + 94) >= (668 + 2407))) then
							v95 = v9.BossFightRemains(nil, true);
							v96 = v95;
							v176 = 2 - 1;
						end
						if (((2636 + 1716) > (6012 - 3458)) and (v176 == (2 - 1))) then
							if ((v96 == (5302 + 5809)) or ((8575 - 4169) < (2882 + 1161))) then
								v96 = v9.FightRemains(v97, false);
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((173 + 1716) >= (4105 - (478 + 244)))) then
					if (((2409 - (440 + 77)) <= (1244 + 1490)) and v13:AffectingCombat()) then
						local v178 = 0 - 0;
						while true do
							if (((3479 - (655 + 901)) < (412 + 1806)) and ((0 + 0) == v178)) then
								v26 = v106();
								if (((1468 + 705) > (1526 - 1147)) and v26) then
									return v26;
								end
								break;
							end
						end
					else
						local v179 = 1445 - (695 + 750);
						while true do
							if (((0 - 0) == v179) or ((3998 - 1407) == (13709 - 10300))) then
								v26 = v107();
								if (((4865 - (285 + 66)) > (7748 - 4424)) and v26) then
									return v26;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v112()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1382 - (682 + 628), v111, v112);
end;
return v0["Epix_Warrior_Fury.lua"]();

