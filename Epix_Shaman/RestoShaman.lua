local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((331 + 356) == (1483 - (588 + 208))) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (1800 - (884 + 916))) or ((1373 - 717) >= (1931 + 1399))) then
			v6 = v0[v4];
			if (not v6 or ((3145 - (232 + 421)) <= (2224 - (1569 + 320)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Shaman_RestoShaman.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Utils;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.Macro;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = math.min;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111;
	local v112;
	local v113 = 2111 + 9000;
	local v114 = 37441 - 26330;
	local v115;
	v10:RegisterForEvent(function()
		local v134 = 605 - (316 + 289);
		while true do
			if (((11313 - 6991) >= (119 + 2443)) and (v134 == (1453 - (666 + 787)))) then
				v113 = 11536 - (360 + 65);
				v114 = 10384 + 727;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v116 = v18.Shaman.Restoration;
	local v117 = v25.Shaman.Restoration;
	local v118 = v20.Shaman.Restoration;
	local v119 = {};
	local v120 = v22.Commons.Everyone;
	local v121 = v22.Commons.Shaman;
	local function v122()
		if (v116.ImprovedPurifySpirit:IsAvailable() or ((3891 - (79 + 175)) >= (5944 - 2174))) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellableCurseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123(v135)
		return v135:DebuffRefreshable(v116.FlameShockDebuff) and (v114 > (4 + 1));
	end
	local function v124()
		if ((v89 and v116.AstralShift:IsReady()) or ((7291 - 4912) > (8816 - 4238))) then
			if ((v13:HealthPercentage() <= v55) or ((1382 - (503 + 396)) > (924 - (92 + 89)))) then
				if (((4760 - 2306) > (297 + 281)) and v24(v116.AstralShift, not v15:IsInRange(24 + 16))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((3642 - 2712) < (610 + 3848)) and v92 and v116.EarthElemental:IsReady()) then
			if (((1509 - 847) <= (849 + 123)) and ((v13:HealthPercentage() <= v63) or v120.IsTankBelowHealthPercentage(v64))) then
				if (((2088 + 2282) == (13309 - 8939)) and v24(v116.EarthElemental, not v15:IsInRange(5 + 35))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v118.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((7261 - 2499) <= (2105 - (485 + 759)))) then
			if (v24(v117.Healthstone) or ((3267 - 1855) == (5453 - (442 + 747)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((4303 - (832 + 303)) < (3099 - (88 + 858)))) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (0 + 0)) or ((205 + 4771) < (2121 - (766 + 23)))) then
					if (((22847 - 18219) == (6329 - 1701)) and (v40 == "Refreshing Healing Potion")) then
						if (v118.RefreshingHealingPotion:IsReady() or ((141 - 87) == (1340 - 945))) then
							if (((1155 - (1036 + 37)) == (59 + 23)) and v24(v117.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v40 == "Dreamwalker's Healing Potion") or ((1131 - 550) < (222 + 60))) then
						if (v118.DreamwalkersHealingPotion:IsReady() or ((6089 - (641 + 839)) < (3408 - (910 + 3)))) then
							if (((2936 - 1784) == (2836 - (1466 + 218))) and v24(v117.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		local v136 = 0 + 0;
		while true do
			if (((3044 - (556 + 592)) <= (1217 + 2205)) and (v136 == (809 - (329 + 479)))) then
				if (v43 or ((1844 - (174 + 680)) > (5566 - 3946))) then
					local v234 = 0 - 0;
					while true do
						if ((v234 == (0 + 0)) or ((1616 - (396 + 343)) > (416 + 4279))) then
							v29 = v120.HandleFyrakkNPC(v116.Riptide, v117.RiptideMouseover, 1517 - (29 + 1448));
							if (((4080 - (135 + 1254)) >= (6972 - 5121)) and v29) then
								return v29;
							end
							v234 = 4 - 3;
						end
						if ((v234 == (2 + 0)) or ((4512 - (389 + 1138)) >= (5430 - (102 + 472)))) then
							v29 = v120.HandleFyrakkNPC(v116.HealingWave, v117.HealingWaveMouseover, 38 + 2);
							if (((2372 + 1904) >= (1115 + 80)) and v29) then
								return v29;
							end
							break;
						end
						if (((4777 - (320 + 1225)) <= (8349 - 3659)) and (v234 == (1 + 0))) then
							v29 = v120.HandleFyrakkNPC(v116.HealingSurge, v117.HealingSurgeMouseover, 1504 - (157 + 1307));
							if (v29 or ((2755 - (821 + 1038)) >= (7849 - 4703))) then
								return v29;
							end
							v234 = 1 + 1;
						end
					end
				end
				break;
			end
			if (((5436 - 2375) >= (1101 + 1857)) and (v136 == (0 - 0))) then
				if (((4213 - (834 + 192)) >= (41 + 603)) and v41) then
					v29 = v120.HandleCharredTreant(v116.Riptide, v117.RiptideMouseover, 11 + 29);
					if (((14 + 630) <= (1090 - 386)) and v29) then
						return v29;
					end
					v29 = v120.HandleCharredTreant(v116.HealingSurge, v117.HealingSurgeMouseover, 344 - (300 + 4));
					if (((256 + 702) > (2478 - 1531)) and v29) then
						return v29;
					end
					v29 = v120.HandleCharredTreant(v116.HealingWave, v117.HealingWaveMouseover, 402 - (112 + 250));
					if (((1791 + 2701) >= (6648 - 3994)) and v29) then
						return v29;
					end
				end
				if (((1972 + 1470) >= (778 + 725)) and v42) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (1 + 0)) or ((2355 + 815) <= (2878 - (1001 + 413)))) then
							v29 = v120.HandleCharredBrambles(v116.HealingSurge, v117.HealingSurgeMouseover, 89 - 49);
							if (v29 or ((5679 - (244 + 638)) == (5081 - (627 + 66)))) then
								return v29;
							end
							v235 = 5 - 3;
						end
						if (((1153 - (512 + 90)) <= (2587 - (1665 + 241))) and (v235 == (717 - (373 + 344)))) then
							v29 = v120.HandleCharredBrambles(v116.Riptide, v117.RiptideMouseover, 19 + 21);
							if (((868 + 2409) > (1073 - 666)) and v29) then
								return v29;
							end
							v235 = 1 - 0;
						end
						if (((5794 - (35 + 1064)) >= (1030 + 385)) and (v235 == (4 - 2))) then
							v29 = v120.HandleCharredBrambles(v116.HealingWave, v117.HealingWaveMouseover, 1 + 39);
							if (v29 or ((4448 - (298 + 938)) <= (2203 - (233 + 1026)))) then
								return v29;
							end
							break;
						end
					end
				end
				v136 = 1667 - (636 + 1030);
			end
		end
	end
	local function v126()
		if ((v107 and ((v31 and v106) or not v106)) or ((1583 + 1513) <= (1757 + 41))) then
			local v149 = 0 + 0;
			while true do
				if (((239 + 3298) == (3758 - (55 + 166))) and (v149 == (1 + 0))) then
					v29 = v120.HandleBottomTrinket(v119, v31, 5 + 35, nil);
					if (((14653 - 10816) >= (1867 - (36 + 261))) and v29) then
						return v29;
					end
					break;
				end
				if (((0 - 0) == v149) or ((4318 - (34 + 1334)) == (1466 + 2346))) then
					v29 = v120.HandleTopTrinket(v119, v31, 32 + 8, nil);
					if (((6006 - (1035 + 248)) >= (2339 - (20 + 1))) and v29) then
						return v29;
					end
					v149 = 1 + 0;
				end
			end
		end
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((2346 - (134 + 185)) > (3985 - (549 + 584)))) then
			if ((v17:HealthPercentage() <= v79) or ((1821 - (314 + 371)) > (14820 - 10503))) then
				if (((5716 - (478 + 490)) == (2516 + 2232)) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
					return "riptide healingcd";
				end
			end
		end
		if (((4908 - (786 + 386)) <= (15352 - 10612)) and v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) then
			if (((v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) or ((4769 - (1055 + 324)) <= (4400 - (1093 + 247)))) then
				if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((888 + 111) > (284 + 2409))) then
					return "riptide healingcd";
				end
			end
		end
		if (((1838 - 1375) < (2039 - 1438)) and v120.AreUnitsBelowHealthPercentage(v82, v81) and v116.SpiritLinkTotem:IsReady()) then
			if ((v83 == "Player") or ((6211 - 4028) < (1726 - 1039))) then
				if (((1619 + 2930) == (17524 - 12975)) and v24(v117.SpiritLinkTotemPlayer, not v15:IsInRange(137 - 97))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((3523 + 1149) == (11947 - 7275)) and (v83 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((4356 - (364 + 324)) < (1082 - 687))) then
					if (v24(v117.SpiritLinkTotemCursor, not v15:IsInRange(95 - 55)) or ((1381 + 2785) == (1903 - 1448))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v83 == "Confirmation") or ((7124 - 2675) == (8087 - 5424))) then
				if (v24(v116.SpiritLinkTotem, not v15:IsInRange(1308 - (1249 + 19))) or ((3861 + 416) < (11634 - 8645))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if ((v96 and v120.AreUnitsBelowHealthPercentage(v75, v74) and v116.HealingTideTotem:IsReady()) or ((1956 - (686 + 400)) >= (3256 + 893))) then
			if (((2441 - (73 + 156)) < (16 + 3167)) and v24(v116.HealingTideTotem, not v15:IsInRange(851 - (721 + 90)))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((53 + 4593) > (9714 - 6722)) and v120.AreUnitsBelowHealthPercentage(v51, v50) and v116.AncestralProtectionTotem:IsReady()) then
			if (((1904 - (224 + 246)) < (5031 - 1925)) and (v52 == "Player")) then
				if (((1447 - 661) < (549 + 2474)) and v24(v117.AncestralProtectionTotemPlayer, not v15:IsInRange(1 + 39))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v52 == "Friendly under Cursor") or ((1794 + 648) < (146 - 72))) then
				if (((15091 - 10556) == (5048 - (203 + 310))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v117.AncestralProtectionTotemCursor, not v15:IsInRange(2033 - (1238 + 755))) or ((211 + 2798) <= (3639 - (709 + 825)))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((3372 - 1542) < (5344 - 1675)) and (v52 == "Confirmation")) then
				if (v24(v116.AncestralProtectionTotem, not v15:IsInRange(904 - (196 + 668))) or ((5646 - 4216) >= (7481 - 3869))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((3516 - (171 + 662)) >= (2553 - (4 + 89))) and v87 and v120.AreUnitsBelowHealthPercentage(v49, v48) and v116.AncestralGuidance:IsReady()) then
			if (v24(v116.AncestralGuidance, not v15:IsInRange(140 - 100)) or ((657 + 1147) >= (14384 - 11109))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if ((v88 and v120.AreUnitsBelowHealthPercentage(v54, v53) and v116.Ascendance:IsReady()) or ((556 + 861) > (5115 - (35 + 1451)))) then
			if (((6248 - (28 + 1425)) > (2395 - (941 + 1052))) and v24(v116.Ascendance, not v15:IsInRange(39 + 1))) then
				return "ascendance cooldowns";
			end
		end
		if (((6327 - (822 + 692)) > (5089 - 1524)) and v98 and (v13:Mana() <= v77) and v116.ManaTideTotem:IsReady()) then
			if (((1843 + 2069) == (4209 - (45 + 252))) and v24(v116.ManaTideTotem, not v15:IsInRange(40 + 0))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((971 + 1850) <= (11740 - 6916)) and v35 and ((v105 and v31) or not v105)) then
			local v150 = 433 - (114 + 319);
			while true do
				if (((2495 - 757) <= (2812 - 617)) and (v150 == (0 + 0))) then
					if (((60 - 19) <= (6323 - 3305)) and v116.AncestralCall:IsReady()) then
						if (((4108 - (556 + 1407)) <= (5310 - (741 + 465))) and v24(v116.AncestralCall, not v15:IsInRange(505 - (170 + 295)))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((1417 + 1272) < (4451 + 394)) and v116.BagofTricks:IsReady()) then
						if (v24(v116.BagofTricks, not v15:IsInRange(98 - 58)) or ((1925 + 397) > (1682 + 940))) then
							return "BagofTricks cooldowns";
						end
					end
					v150 = 1 + 0;
				end
				if ((v150 == (1231 - (957 + 273))) or ((1213 + 3321) == (834 + 1248))) then
					if (v116.Berserking:IsReady() or ((5986 - 4415) > (4919 - 3052))) then
						if (v24(v116.Berserking, not v15:IsInRange(122 - 82)) or ((13141 - 10487) >= (4776 - (389 + 1391)))) then
							return "Berserking cooldowns";
						end
					end
					if (((2496 + 1482) > (219 + 1885)) and v116.BloodFury:IsReady()) then
						if (((6818 - 3823) > (2492 - (783 + 168))) and v24(v116.BloodFury, not v15:IsInRange(134 - 94))) then
							return "BloodFury cooldowns";
						end
					end
					v150 = 2 + 0;
				end
				if (((3560 - (309 + 2)) > (2926 - 1973)) and (v150 == (1214 - (1090 + 122)))) then
					if (v116.Fireblood:IsReady() or ((1062 + 2211) > (15358 - 10785))) then
						if (v24(v116.Fireblood, not v15:IsInRange(28 + 12)) or ((4269 - (628 + 490)) < (231 + 1053))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
			end
		end
	end
	local function v127()
		if ((v90 and v120.AreUnitsBelowHealthPercentage(235 - 140, 13 - 10) and v116.ChainHeal:IsReady() and v13:BuffUp(v116.HighTide)) or ((2624 - (431 + 343)) == (3087 - 1558))) then
			if (((2374 - 1553) < (1678 + 445)) and v24(v117.ChainHealFocus, not v17:IsSpellInRange(v116.ChainHeal), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((116 + 786) < (4020 - (556 + 1139))) and v97 and (v17:HealthPercentage() <= v76) and v116.HealingWave:IsReady() and (v116.PrimordialWaveResto:TimeSinceLastCast() < (30 - (6 + 9)))) then
			if (((158 + 700) <= (1518 + 1444)) and v24(v117.HealingWaveFocus, not v17:IsSpellInRange(v116.HealingWave), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((4115 - (28 + 141)) < (499 + 789))) then
			if ((v17:HealthPercentage() <= v79) or ((4001 - 759) == (402 + 165))) then
				if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((2164 - (486 + 831)) >= (3286 - 2023))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) or ((7931 - 5678) == (350 + 1501))) then
			if (((v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) or ((6599 - 4512) > (3635 - (668 + 595)))) then
				if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((4000 + 445) < (837 + 3312))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v101 and v116.UnleashLife:IsReady()) or ((4957 - 3139) == (375 - (23 + 267)))) then
			if (((2574 - (1129 + 815)) < (2514 - (371 + 16))) and (v17:HealthPercentage() <= v86)) then
				if (v24(v116.UnleashLife, not v17:IsSpellInRange(v116.UnleashLife)) or ((3688 - (1326 + 424)) == (4761 - 2247))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((15548 - 11293) >= (173 - (88 + 30))) and (v70 == "Cursor") and v116.HealingRain:IsReady()) then
			if (((3770 - (720 + 51)) > (2571 - 1415)) and v24(v117.HealingRainCursor, not v15:IsInRange(1816 - (421 + 1355)), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if (((3876 - 1526) > (568 + 587)) and v120.AreUnitsBelowHealthPercentage(v69, v68) and v116.HealingRain:IsReady()) then
			if (((5112 - (286 + 797)) <= (17740 - 12887)) and (v70 == "Player")) then
				if (v24(v117.HealingRainPlayer, not v15:IsInRange(66 - 26), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((955 - (397 + 42)) > (1073 + 2361))) then
					return "healing_rain healingaoe";
				end
			elseif (((4846 - (24 + 776)) >= (4672 - 1639)) and (v70 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((3504 - (222 + 563)) <= (3187 - 1740))) then
					if (v24(v117.HealingRainCursor, not v15:IsInRange(29 + 11), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((4324 - (23 + 167)) < (5724 - (690 + 1108)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v70 == "Enemy under Cursor") or ((60 + 104) >= (2298 + 487))) then
				if ((v16:Exists() and v13:CanAttack(v16)) or ((1373 - (40 + 808)) == (348 + 1761))) then
					if (((126 - 93) == (32 + 1)) and v24(v117.HealingRainCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((1675 + 1379) <= (4586 - (47 + 524))) and (v70 == "Confirmation")) then
				if (((1215 + 656) < (9244 - 5862)) and v24(v116.HealingRain, not v15:IsInRange(59 - 19), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((2948 - 1655) <= (3892 - (1165 + 561))) and v120.AreUnitsBelowHealthPercentage(v66, v65) and v116.EarthenWallTotem:IsReady()) then
			if ((v67 == "Player") or ((77 + 2502) < (380 - 257))) then
				if (v24(v117.EarthenWallTotemPlayer, not v15:IsInRange(16 + 24)) or ((1325 - (341 + 138)) >= (640 + 1728))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v67 == "Friendly under Cursor") or ((8279 - 4267) <= (3684 - (89 + 237)))) then
				if (((4805 - 3311) <= (6326 - 3321)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v117.EarthenWallTotemCursor, not v15:IsInRange(921 - (581 + 300))) or ((4331 - (855 + 365)) == (5068 - 2934))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((769 + 1586) == (3590 - (1030 + 205))) and (v67 == "Confirmation")) then
				if (v24(v116.EarthenWallTotem, not v15:IsInRange(38 + 2)) or ((547 + 41) <= (718 - (156 + 130)))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((10899 - 6102) >= (6564 - 2669)) and v120.AreUnitsBelowHealthPercentage(v61, v60) and v116.Downpour:IsReady()) then
			if (((7325 - 3748) == (943 + 2634)) and (v62 == "Player")) then
				if (((2213 + 1581) > (3762 - (10 + 59))) and v24(v117.DownpourPlayer, not v15:IsInRange(12 + 28), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v62 == "Friendly under Cursor") or ((6279 - 5004) == (5263 - (671 + 492)))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1267 + 324) >= (4795 - (369 + 846)))) then
					if (((261 + 722) <= (1543 + 265)) and v24(v117.DownpourCursor, not v15:IsInRange(1985 - (1036 + 909)), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v62 == "Confirmation") or ((1710 + 440) <= (2008 - 811))) then
				if (((3972 - (11 + 192)) >= (593 + 580)) and v24(v116.Downpour, not v15:IsInRange(215 - (135 + 40)), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((3597 - 2112) == (896 + 589)) and v91 and v120.AreUnitsBelowHealthPercentage(v59, v58) and v116.CloudburstTotem:IsReady()) then
			if (v24(v116.CloudburstTotem) or ((7302 - 3987) <= (4169 - 1387))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v102 and v120.AreUnitsBelowHealthPercentage(v104, v103) and v116.Wellspring:IsReady()) or ((1052 - (50 + 126)) >= (8253 - 5289))) then
			if (v24(v116.Wellspring, not v15:IsInRange(9 + 31), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((3645 - (1233 + 180)) > (3466 - (522 + 447)))) then
				return "wellspring healingaoe";
			end
		end
		if ((v90 and v120.AreUnitsBelowHealthPercentage(v57, v56) and v116.ChainHeal:IsReady()) or ((3531 - (107 + 1314)) <= (155 + 177))) then
			if (((11231 - 7545) > (1348 + 1824)) and v24(v117.ChainHealFocus, not v17:IsSpellInRange(v116.ChainHeal), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v100 and v13:IsMoving() and v120.AreUnitsBelowHealthPercentage(v85, v84) and v116.SpiritwalkersGrace:IsReady()) or ((8884 - 4410) < (3244 - 2424))) then
			if (((6189 - (716 + 1194)) >= (50 + 2832)) and v24(v116.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v94 and v120.AreUnitsBelowHealthPercentage(v72, v71) and v116.HealingStreamTotem:IsReady()) or ((218 + 1811) >= (4024 - (74 + 429)))) then
			if (v24(v116.HealingStreamTotem, nil) or ((3929 - 1892) >= (2301 + 2341))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v128()
		local v137 = 0 - 0;
		while true do
			if (((1217 + 503) < (13743 - 9285)) and (v137 == (4 - 2))) then
				if ((v116.ElementalOrbit:IsAvailable() and v13:BuffUp(v116.EarthShieldBuff)) or ((869 - (279 + 154)) > (3799 - (454 + 324)))) then
					if (((561 + 152) <= (864 - (12 + 5))) and v120.IsSoloMode()) then
						if (((1162 + 992) <= (10270 - 6239)) and v116.LightningShield:IsReady() and v13:BuffDown(v116.LightningShield)) then
							if (((1706 + 2909) == (5708 - (277 + 816))) and v24(v116.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v116.WaterShield:IsReady() and v13:BuffDown(v116.WaterShield)) or ((16195 - 12405) == (1683 - (1058 + 125)))) then
						if (((17 + 72) < (1196 - (815 + 160))) and v24(v116.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				if (((8812 - 6758) >= (3373 - 1952)) and v95 and v116.HealingSurge:IsReady()) then
					if (((166 + 526) < (8938 - 5880)) and (v17:HealthPercentage() <= v73)) then
						if (v24(v117.HealingSurgeFocus, not v17:IsSpellInRange(v116.HealingSurge), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((5152 - (41 + 1857)) == (3548 - (1222 + 671)))) then
							return "healing_surge healingst";
						end
					end
				end
				v137 = 7 - 4;
			end
			if ((v137 == (0 - 0)) or ((2478 - (229 + 953)) == (6684 - (1111 + 663)))) then
				if (((4947 - (874 + 705)) == (472 + 2896)) and v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) then
					if (((1804 + 839) < (7930 - 4115)) and (v17:HealthPercentage() <= v79)) then
						if (((54 + 1859) > (1172 - (642 + 37))) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((1085 + 3670) > (549 + 2879)) and v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) then
					if (((3467 - 2086) <= (2823 - (233 + 221))) and (v17:HealthPercentage() <= v80) and (v120.UnitGroupRole(v17) == "TANK")) then
						if (v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide)) or ((11198 - 6355) == (3595 + 489))) then
							return "riptide healingaoe";
						end
					end
				end
				v137 = 1542 - (718 + 823);
			end
			if (((2939 + 1730) > (1168 - (266 + 539))) and (v137 == (8 - 5))) then
				if ((v97 and v116.HealingWave:IsReady()) or ((3102 - (636 + 589)) >= (7448 - 4310))) then
					if (((9780 - 5038) >= (2874 + 752)) and (v17:HealthPercentage() <= v76)) then
						if (v24(v117.HealingWaveFocus, not v17:IsSpellInRange(v116.HealingWave), v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((1650 + 2890) == (1931 - (657 + 358)))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v137 == (2 - 1)) or ((2633 - 1477) > (5532 - (1151 + 36)))) then
				if (((2161 + 76) < (1118 + 3131)) and v99 and v13:BuffDown(v116.UnleashLife) and v116.Riptide:IsReady() and v17:BuffDown(v116.Riptide)) then
					if ((v17:HealthPercentage() <= v79) or (v17:HealthPercentage() <= v79) or ((8012 - 5329) < (1855 - (1552 + 280)))) then
						if (((1531 - (64 + 770)) <= (561 + 265)) and v24(v117.RiptideFocus, not v17:IsSpellInRange(v116.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((2508 - 1403) <= (209 + 967)) and v116.ElementalOrbit:IsAvailable() and v13:BuffDown(v116.EarthShieldBuff)) then
					if (((4622 - (157 + 1086)) <= (7629 - 3817)) and v24(v116.EarthShield)) then
						return "earth_shield healingst";
					end
				end
				v137 = 8 - 6;
			end
		end
	end
	local function v129()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (2 - 0)) or ((1607 - (599 + 220)) >= (3217 - 1601))) then
				if (((3785 - (1813 + 118)) <= (2470 + 909)) and v116.LightningBolt:IsReady()) then
					if (((5766 - (841 + 376)) == (6373 - 1824)) and v24(v116.LightningBolt, not v15:IsSpellInRange(v116.LightningBolt), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v138 == (1 + 0)) or ((8248 - 5226) >= (3883 - (464 + 395)))) then
				if (((12370 - 7550) > (1056 + 1142)) and v116.FlameShock:IsReady()) then
					local v236 = 837 - (467 + 370);
					while true do
						if ((v236 == (0 - 0)) or ((779 + 282) >= (16766 - 11875))) then
							if (((213 + 1151) <= (10406 - 5933)) and v120.CastCycle(v116.FlameShock, v13:GetEnemiesInRange(560 - (150 + 370)), v123, not v15:IsSpellInRange(v116.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v24(v116.FlameShock, not v15:IsSpellInRange(v116.FlameShock)) or ((4877 - (74 + 1208)) <= (7 - 4))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v116.LavaBurst:IsReady() or ((22157 - 17485) == (2741 + 1111))) then
					if (((1949 - (14 + 376)) == (2703 - 1144)) and v24(v116.LavaBurst, not v15:IsSpellInRange(v116.LavaBurst), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v138 = 2 + 0;
			end
			if ((v138 == (0 + 0)) or ((1671 + 81) <= (2308 - 1520))) then
				if (v116.Stormkeeper:IsReady() or ((2940 + 967) == (255 - (23 + 55)))) then
					if (((8223 - 4753) > (371 + 184)) and v24(v116.Stormkeeper, not v15:IsInRange(36 + 4))) then
						return "stormkeeper damage";
					end
				end
				if ((#v13:GetEnemiesInRange(62 - 22) > (1 + 0)) or ((1873 - (652 + 249)) == (1726 - 1081))) then
					if (((5050 - (708 + 1160)) >= (5741 - 3626)) and v116.ChainLightning:IsReady()) then
						if (((7097 - 3204) < (4456 - (10 + 17))) and v24(v116.ChainLightning, not v15:IsSpellInRange(v116.ChainLightning), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v130()
		local v139 = 1732 - (1400 + 332);
		while true do
			if (((16 - 7) == v139) or ((4775 - (242 + 1666)) < (816 + 1089))) then
				v97 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v99 = EpicSettings.Settings['UseRiptide'];
				v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v101 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v139 == (3 + 3)) or ((1531 + 265) >= (4991 - (850 + 90)))) then
				v79 = EpicSettings.Settings['RiptideHP'];
				v80 = EpicSettings.Settings['RiptideTankHP'];
				v81 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v82 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v83 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v139 = 12 - 5;
			end
			if (((3009 - (360 + 1030)) <= (3324 + 432)) and (v139 == (5 - 3))) then
				v66 = EpicSettings.Settings['EarthenWallTotemHP'];
				v67 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v43 = EpicSettings.Settings['HandleFyrakkNPC'];
				v139 = 3 - 0;
			end
			if (((2265 - (909 + 752)) == (1827 - (109 + 1114))) and (v139 == (14 - 6))) then
				v93 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v94 = EpicSettings.Settings['UseHealingStreamTotem'];
				v95 = EpicSettings.Settings['UseHealingSurge'];
				v96 = EpicSettings.Settings['UseHealingTideTotem'];
				v139 = 4 + 5;
			end
			if ((v139 == (247 - (6 + 236))) or ((2826 + 1658) == (725 + 175))) then
				v76 = EpicSettings.Settings['HealingWaveHP'];
				v37 = EpicSettings.Settings['healthstoneHP'];
				v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v47 = EpicSettings.Settings['InterruptThreshold'];
				v45 = EpicSettings.Settings['InterruptWithStun'];
				v139 = 13 - 7;
			end
			if ((v139 == (1 - 0)) or ((5592 - (1076 + 57)) <= (184 + 929))) then
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v60 = EpicSettings.Settings['DownpourGroup'];
				v61 = EpicSettings.Settings['DownpourHP'];
				v62 = EpicSettings.Settings['DownpourUsage'];
				v65 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v139 = 691 - (579 + 110);
			end
			if (((287 + 3345) > (3005 + 393)) and ((2 + 1) == v139)) then
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v68 = EpicSettings.Settings['HealingRainGroup'];
				v69 = EpicSettings.Settings['HealingRainHP'];
				v70 = EpicSettings.Settings['HealingRainUsage'];
				v139 = 411 - (174 + 233);
			end
			if (((11402 - 7320) <= (8629 - 3712)) and ((4 + 3) == v139)) then
				v84 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v85 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v86 = EpicSettings.Settings['UnleashLifeHP'];
				v90 = EpicSettings.Settings['UseChainHeal'];
				v91 = EpicSettings.Settings['UseCloudburstTotem'];
				v139 = 1182 - (663 + 511);
			end
			if (((4311 + 521) >= (301 + 1085)) and (v139 == (0 - 0))) then
				v50 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v52 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v56 = EpicSettings.Settings['ChainHealGroup'];
				v57 = EpicSettings.Settings['ChainHealHP'];
				v139 = 1 + 0;
			end
			if (((322 - 185) == (331 - 194)) and (v139 == (2 + 2))) then
				v71 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v72 = EpicSettings.Settings['HealingStreamTotemHP'];
				v73 = EpicSettings.Settings['HealingSurgeHP'];
				v74 = EpicSettings.Settings['HealingTideTotemGroup'];
				v75 = EpicSettings.Settings['HealingTideTotemHP'];
				v139 = 9 - 4;
			end
		end
	end
	local function v131()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (1 + 5)) or ((2292 - (478 + 244)) >= (4849 - (440 + 77)))) then
				v103 = EpicSettings.Settings['WellspringGroup'];
				v104 = EpicSettings.Settings['WellspringHP'];
				v105 = EpicSettings.Settings['racialsWithCD'];
				v140 = 4 + 3;
			end
			if ((v140 == (10 - 7)) or ((5620 - (655 + 901)) <= (338 + 1481))) then
				v77 = EpicSettings.Settings['ManaTideTotemMana'];
				v78 = EpicSettings.Settings['PrimordialWaveHP'];
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v140 = 4 + 0;
			end
			if ((v140 == (3 + 1)) or ((20086 - 15100) < (3019 - (695 + 750)))) then
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v140 = 16 - 11;
			end
			if (((6829 - 2403) > (691 - 519)) and (v140 == (360 - (285 + 66)))) then
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((1365 - 779) > (1765 - (682 + 628))) and (v140 == (1 + 4))) then
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v35 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['UseWellspring'];
				v140 = 305 - (176 + 123);
			end
			if (((346 + 480) == (600 + 226)) and (v140 == (277 - (239 + 30)))) then
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v140 = 3 + 6;
			end
			if ((v140 == (7 + 0)) or ((7112 - 3093) > (13855 - 9414))) then
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v140 = 323 - (306 + 9);
			end
			if (((7038 - 5021) < (742 + 3519)) and ((0 + 0) == v140)) then
				v48 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v49 = EpicSettings.Settings['AncestralGuidanceHP'];
				v53 = EpicSettings.Settings['AscendanceGroup'];
				v140 = 1 + 0;
			end
			if (((13485 - 8769) > (1455 - (1140 + 235))) and (v140 == (2 + 0))) then
				v59 = EpicSettings.Settings['CloudburstTotemHP'];
				v63 = EpicSettings.Settings['EarthElementalHP'];
				v64 = EpicSettings.Settings['EarthElementalTankHP'];
				v140 = 3 + 0;
			end
			if ((v140 == (1 + 0)) or ((3559 - (33 + 19)) == (1182 + 2090))) then
				v54 = EpicSettings.Settings['AscendanceHP'];
				v55 = EpicSettings.Settings['AstralShiftHP'];
				v58 = EpicSettings.Settings['CloudburstTotemGroup'];
				v140 = 5 - 3;
			end
		end
	end
	local function v132()
		local v141 = 0 + 0;
		local v142;
		while true do
			if ((v141 == (7 - 3)) or ((822 + 54) >= (3764 - (586 + 103)))) then
				if (((397 + 3955) > (7862 - 5308)) and (v120.TargetIsValid() or v13:AffectingCombat())) then
					local v237 = 1488 - (1309 + 179);
					while true do
						if ((v237 == (0 - 0)) or ((1918 + 2488) < (10857 - 6814))) then
							v115 = v13:GetEnemiesInRange(31 + 9);
							v113 = v10.BossFightRemains(nil, true);
							v237 = 1 - 0;
						end
						if ((v237 == (1 - 0)) or ((2498 - (295 + 314)) >= (8308 - 4925))) then
							v114 = v113;
							if (((3854 - (1300 + 662)) <= (8585 - 5851)) and (v114 == (12866 - (1178 + 577)))) then
								v114 = v10.FightRemains(v115, false);
							end
							break;
						end
					end
				end
				if (((999 + 924) < (6556 - 4338)) and v13:AffectingCombat() and v120.TargetIsValid()) then
					local v238 = 1405 - (851 + 554);
					while true do
						if (((1922 + 251) > (1050 - 671)) and ((3 - 1) == v238)) then
							v142 = v124();
							if (v142 or ((2893 - (115 + 187)) == (2611 + 798))) then
								return v142;
							end
							if (((4274 + 240) > (13098 - 9774)) and (v114 > v108)) then
								local v244 = 1161 - (160 + 1001);
								while true do
									if ((v244 == (0 + 0)) or ((144 + 64) >= (9883 - 5055))) then
										v142 = v126();
										if (v142 or ((1941 - (237 + 121)) > (4464 - (525 + 372)))) then
											return v142;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v238 == (1 - 0)) or ((4313 - 3000) == (936 - (96 + 46)))) then
							v29 = v120.InterruptWithStunCursor(v116.CapacitorTotem, v117.CapacitorTotemCursor, 807 - (643 + 134), nil, v16);
							if (((1146 + 2028) > (6958 - 4056)) and v29) then
								return v29;
							end
							if (((15296 - 11176) <= (4086 + 174)) and v110) then
								local v245 = 0 - 0;
								while true do
									if (((0 - 0) == v245) or ((1602 - (316 + 403)) > (3176 + 1602))) then
										v29 = v120.HandleIncorporeal(v116.Hex, v117.HexMouseOver, 82 - 52, true);
										if (v29 or ((1309 + 2311) >= (12317 - 7426))) then
											return v29;
										end
										break;
									end
								end
							end
							if (((3018 + 1240) > (302 + 635)) and v109) then
								local v246 = 0 - 0;
								while true do
									if ((v246 == (4 - 3)) or ((10114 - 5245) < (52 + 854))) then
										if (v111 or ((2411 - 1186) > (207 + 4021))) then
											local v250 = 0 - 0;
											while true do
												if (((3345 - (12 + 5)) > (8692 - 6454)) and (v250 == (0 - 0))) then
													v29 = v120.HandleAfflicted(v116.TremorTotem, v116.TremorTotem, 63 - 33);
													if (((9519 - 5680) > (286 + 1119)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if (v112 or ((3266 - (1656 + 317)) <= (452 + 55))) then
											local v251 = 0 + 0;
											while true do
												if ((v251 == (0 - 0)) or ((14252 - 11356) < (1159 - (5 + 349)))) then
													v29 = v120.HandleAfflicted(v116.PoisonCleansingTotem, v116.PoisonCleansingTotem, 142 - 112);
													if (((3587 - (266 + 1005)) == (1527 + 789)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v246 == (0 - 0)) or ((3383 - 813) == (3229 - (561 + 1135)))) then
										v29 = v120.HandleAfflicted(v116.PurifySpirit, v117.PurifySpiritMouseover, 39 - 9);
										if (v29 or ((2902 - 2019) == (2526 - (507 + 559)))) then
											return v29;
										end
										v246 = 2 - 1;
									end
								end
							end
							v238 = 6 - 4;
						end
						if ((v238 == (388 - (212 + 176))) or ((5524 - (250 + 655)) <= (2724 - 1725))) then
							v29 = v120.Interrupt(v116.WindShear, 52 - 22, true);
							if (v29 or ((5335 - 1925) > (6072 - (1869 + 87)))) then
								return v29;
							end
							v29 = v120.InterruptCursor(v116.WindShear, v117.WindShearMouseover, 104 - 74, true, v16);
							if (v29 or ((2804 - (484 + 1417)) >= (6556 - 3497))) then
								return v29;
							end
							v238 = 1 - 0;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((4749 - (48 + 725)) < (4666 - 1809))) then
					local v239 = 0 - 0;
					while true do
						if (((2866 + 2064) > (6164 - 3857)) and (v239 == (1 + 0))) then
							if ((v116.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(12 + 28) and (v120.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v116.EarthShield)) or ((4899 - (152 + 701)) < (2602 - (430 + 881)))) then
								if (v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield)) or ((1625 + 2616) == (4440 - (557 + 338)))) then
									return "earth_shield_tank main fight";
								end
							end
							v142 = v125();
							v239 = 1 + 1;
						end
						if ((v239 == (5 - 3)) or ((14175 - 10127) > (11243 - 7011))) then
							if (v142 or ((3771 - 2021) >= (4274 - (499 + 302)))) then
								return v142;
							end
							if (((4032 - (39 + 827)) == (8739 - 5573)) and v33) then
								local v247 = 0 - 0;
								while true do
									if (((7002 - 5239) < (5717 - 1993)) and (v247 == (0 + 0))) then
										v142 = v127();
										if (((166 - 109) <= (436 + 2287)) and v142) then
											return v142;
										end
										v247 = 1 - 0;
									end
									if ((v247 == (105 - (103 + 1))) or ((2624 - (475 + 79)) == (957 - 514))) then
										v142 = v128();
										if (v142 or ((8656 - 5951) == (181 + 1212))) then
											return v142;
										end
										break;
									end
								end
							end
							v239 = 3 + 0;
						end
						if ((v239 == (1506 - (1395 + 108))) or ((13388 - 8787) < (1265 - (7 + 1197)))) then
							if (v34 or ((607 + 783) >= (1656 + 3088))) then
								if (v120.TargetIsValid() or ((2322 - (27 + 292)) > (11234 - 7400))) then
									local v249 = 0 - 0;
									while true do
										if ((v249 == (0 - 0)) or ((307 - 151) > (7452 - 3539))) then
											v142 = v129();
											if (((334 - (43 + 96)) == (795 - 600)) and v142) then
												return v142;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((7020 - 3915) >= (1491 + 305)) and (v239 == (0 + 0))) then
							if (((8654 - 4275) >= (817 + 1314)) and v32) then
								if (((7203 - 3359) >= (644 + 1399)) and v17 and v44) then
									if ((v116.PurifySpirit:IsReady() and v120.DispellableFriendlyUnit(2 + 23)) or ((4983 - (1414 + 337)) <= (4671 - (1642 + 298)))) then
										if (((12786 - 7881) == (14110 - 9205)) and v24(v117.PurifySpiritFocus, not v17:IsSpellInRange(v116.PurifySpirit))) then
											return "purify_spirit dispel";
										end
									end
								end
							end
							if (((v17:HealthPercentage() < v78) and v17:BuffDown(v116.Riptide)) or ((12273 - 8137) >= (1452 + 2959))) then
								if (v116.PrimordialWaveResto:IsCastable() or ((2302 + 656) == (4989 - (357 + 615)))) then
									if (((862 + 366) >= (1994 - 1181)) and v24(v117.PrimordialWaveFocus, not v17:IsSpellInRange(v116.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							v239 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v141 == (0 - 0)) or ((2764 + 691) > (276 + 3774))) then
				v130();
				v131();
				v30 = EpicSettings.Toggles['ooc'];
				v141 = 1 + 0;
			end
			if (((1544 - (384 + 917)) == (940 - (128 + 569))) and ((1546 - (1407 + 136)) == v141)) then
				if ((v116.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(1927 - (687 + 1200)) and (v120.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v116.EarthShield))) or ((1981 - (556 + 1154)) > (5530 - 3958))) then
					if (((2834 - (9 + 86)) < (3714 - (275 + 146))) and v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v142 = nil;
				if (not v13:AffectingCombat() or ((642 + 3300) < (1198 - (29 + 35)))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((11935 - 9242) == (14853 - 9880))) then
						local v242 = 0 - 0;
						local v243;
						while true do
							if (((1398 + 748) == (3158 - (53 + 959))) and ((408 - (312 + 96)) == v242)) then
								v243 = v120.DeadFriendlyUnitsCount();
								if ((v243 > (1 - 0)) or ((2529 - (147 + 138)) == (4123 - (813 + 86)))) then
									if (v24(v116.AncestralVision, nil, v13:BuffDown(v116.SpiritwalkersGraceBuff)) or ((4432 + 472) <= (3549 - 1633))) then
										return "ancestral_vision";
									end
								elseif (((582 - (18 + 474)) <= (360 + 705)) and v24(v117.AncestralSpiritMouseover, not v15:IsInRange(130 - 90), v13:BuffDown(v116.SpiritwalkersGraceBuff))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v141 = 1090 - (860 + 226);
			end
			if (((5105 - (121 + 182)) == (592 + 4210)) and (v141 == (1242 - (988 + 252)))) then
				v34 = EpicSettings.Toggles['dps'];
				if (v13:IsDeadOrGhost() or ((258 + 2022) <= (161 + 350))) then
					return;
				end
				if (v13:AffectingCombat() or v30 or ((3646 - (49 + 1921)) <= (1353 - (223 + 667)))) then
					local v240 = 52 - (51 + 1);
					local v241;
					while true do
						if (((6658 - 2789) == (8284 - 4415)) and (v240 == (1125 - (146 + 979)))) then
							v241 = v44 and v116.PurifySpirit:IsReady() and v32;
							if (((327 + 831) <= (3218 - (311 + 294))) and v116.EarthShield:IsReady() and v93 and (v120.FriendlyUnitsWithBuffCount(v116.EarthShield, true, false, 69 - 44) < (1 + 0))) then
								local v248 = 1443 - (496 + 947);
								while true do
									if (((1358 - (1233 + 125)) == v248) or ((960 + 1404) <= (1794 + 205))) then
										v29 = v120.FocusUnitRefreshableBuff(v116.EarthShield, 3 + 12, 1685 - (963 + 682), "TANK", true, 21 + 4);
										if (v29 or ((6426 - (504 + 1000)) < (131 + 63))) then
											return v29;
										end
										v248 = 1 + 0;
									end
									if ((v248 == (1 + 0)) or ((3083 - 992) < (27 + 4))) then
										if ((v120.UnitGroupRole(v17) == "TANK") or ((1414 + 1016) >= (5054 - (156 + 26)))) then
											if (v24(v117.EarthShieldFocus, not v17:IsSpellInRange(v116.EarthShield)) or ((2748 + 2022) < (2714 - 979))) then
												return "earth_shield_tank main apl";
											end
										end
										break;
									end
								end
							end
							v240 = 165 - (149 + 15);
						end
						if ((v240 == (961 - (890 + 70))) or ((4556 - (39 + 78)) <= (2832 - (14 + 468)))) then
							if (not v17:BuffDown(v116.EarthShield) or (v120.UnitGroupRole(v17) ~= "TANK") or not v93 or (v120.FriendlyUnitsWithBuffCount(v116.EarthShield, true, false, 54 - 29) >= (2 - 1)) or ((2311 + 2168) < (2682 + 1784))) then
								v29 = v120.FocusUnit(v241, nil, nil, nil);
								if (((542 + 2005) > (554 + 671)) and v29) then
									return v29;
								end
							end
							break;
						end
					end
				end
				v141 = 1 + 2;
			end
			if (((8940 - 4269) > (2643 + 31)) and ((3 - 2) == v141)) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v141 = 1 + 1;
			end
		end
	end
	local function v133()
		local v143 = 51 - (12 + 39);
		while true do
			if ((v143 == (0 + 0)) or ((11440 - 7744) < (11849 - 8522))) then
				v122();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(79 + 185, v132, v133);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

