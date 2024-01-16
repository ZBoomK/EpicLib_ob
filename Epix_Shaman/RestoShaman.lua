local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((243 + 371) < (1667 + 1517)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((2266 + 860) == (4759 - 1633)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2854 - (89 + 578)) >= (3539 + 1415))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
	local v113;
	local v114;
	local v115 = 12160 - (572 + 477);
	local v116 = 1499 + 9612;
	local v117;
	v10:RegisterForEvent(function()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (0 + 0)) or ((3963 - (84 + 2)) == (5891 - 2316))) then
				v115 = 8005 + 3106;
				v116 = 11953 - (497 + 345);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v118 = v18.Shaman.Restoration;
	local v119 = v25.Shaman.Restoration;
	local v120 = v20.Shaman.Restoration;
	local v121 = {};
	local v122 = v22.Commons.Everyone;
	local v123 = v22.Commons.Shaman;
	local function v124()
		if (((19 + 688) > (107 + 525)) and v118.ImprovedPurifySpirit:IsAvailable()) then
			v122.DispellableDebuffs = v21.MergeTable(v122.DispellableMagicDebuffs, v122.DispellableCurseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125(v137)
		return v137:DebuffRefreshable(v118.FlameShockDebuff) and (v116 > (1338 - (605 + 728)));
	end
	local function v126()
		if ((v91 and v118.AstralShift:IsReady()) or ((390 + 156) >= (5966 - 3282))) then
			if (((68 + 1397) <= (15901 - 11600)) and (v13:HealthPercentage() <= v57)) then
				if (((1537 + 167) > (3947 - 2522)) and v24(v118.AstralShift, not v15:IsInRange(31 + 9))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v94 and v118.EarthElemental:IsReady()) or ((1176 - (457 + 32)) == (1797 + 2437))) then
			if ((v13:HealthPercentage() <= v65) or v122.IsTankBelowHealthPercentage(v66) or ((4732 - (832 + 570)) < (1347 + 82))) then
				if (((300 + 847) >= (1185 - 850)) and v24(v118.EarthElemental, not v15:IsInRange(20 + 20))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((4231 - (588 + 208)) > (5651 - 3554)) and v120.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (v24(v119.Healthstone) or ((5570 - (884 + 916)) >= (8459 - 4418))) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((2199 + 1592) <= (2264 - (232 + 421)))) then
			local v181 = 1889 - (1569 + 320);
			while true do
				if ((v181 == (0 + 0)) or ((870 + 3708) <= (6766 - 4758))) then
					if (((1730 - (316 + 289)) <= (5434 - 3358)) and (v40 == "Refreshing Healing Potion")) then
						if (v120.RefreshingHealingPotion:IsReady() or ((35 + 708) >= (5852 - (666 + 787)))) then
							if (((1580 - (360 + 65)) < (1564 + 109)) and v24(v119.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v40 == "Dreamwalker's Healing Potion") or ((2578 - (79 + 175)) <= (910 - 332))) then
						if (((2940 + 827) == (11546 - 7779)) and v120.DreamwalkersHealingPotion:IsReady()) then
							if (((7874 - 3785) == (4988 - (503 + 396))) and v24(v119.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v138 = 181 - (92 + 89);
		while true do
			if (((8648 - 4190) >= (859 + 815)) and (v138 == (1 + 0))) then
				if (((3806 - 2834) <= (194 + 1224)) and v41) then
					local v238 = 0 - 0;
					while true do
						if ((v238 == (3 + 0)) or ((2359 + 2579) < (14503 - 9741))) then
							v29 = v122.HandleCharredTreant(v118.HealingWave, v119.HealingWaveMouseover, 5 + 35);
							if (v29 or ((3818 - 1314) > (5508 - (485 + 759)))) then
								return v29;
							end
							break;
						end
						if (((4981 - 2828) == (3342 - (442 + 747))) and (v238 == (1135 - (832 + 303)))) then
							v29 = v122.HandleCharredTreant(v118.Riptide, v119.RiptideMouseover, 986 - (88 + 858));
							if (v29 or ((155 + 352) >= (2145 + 446))) then
								return v29;
							end
							v238 = 1 + 0;
						end
						if (((5270 - (766 + 23)) == (22121 - 17640)) and (v238 == (1 - 0))) then
							v29 = v122.HandleCharredTreant(v118.ChainHeal, v119.ChainHealMouseover, 105 - 65);
							if (v29 or ((7901 - 5573) < (1766 - (1036 + 37)))) then
								return v29;
							end
							v238 = 2 + 0;
						end
						if (((8427 - 4099) == (3405 + 923)) and (v238 == (1482 - (641 + 839)))) then
							v29 = v122.HandleCharredTreant(v118.HealingSurge, v119.HealingSurgeMouseover, 953 - (910 + 3));
							if (((4048 - 2460) >= (3016 - (1466 + 218))) and v29) then
								return v29;
							end
							v238 = 2 + 1;
						end
					end
				end
				if (v42 or ((5322 - (556 + 592)) > (1511 + 2737))) then
					local v239 = 808 - (329 + 479);
					while true do
						if ((v239 == (857 - (174 + 680))) or ((15758 - 11172) <= (169 - 87))) then
							v29 = v122.HandleCharredBrambles(v118.HealingWave, v119.HealingWaveMouseover, 29 + 11);
							if (((4602 - (396 + 343)) == (342 + 3521)) and v29) then
								return v29;
							end
							break;
						end
						if ((v239 == (1478 - (29 + 1448))) or ((1671 - (135 + 1254)) <= (157 - 115))) then
							v29 = v122.HandleCharredBrambles(v118.ChainHeal, v119.ChainHealMouseover, 186 - 146);
							if (((3072 + 1537) >= (2293 - (389 + 1138))) and v29) then
								return v29;
							end
							v239 = 576 - (102 + 472);
						end
						if (((0 + 0) == v239) or ((639 + 513) == (2320 + 168))) then
							v29 = v122.HandleCharredBrambles(v118.Riptide, v119.RiptideMouseover, 1585 - (320 + 1225));
							if (((6091 - 2669) > (2050 + 1300)) and v29) then
								return v29;
							end
							v239 = 1465 - (157 + 1307);
						end
						if (((2736 - (821 + 1038)) > (937 - 561)) and ((1 + 1) == v239)) then
							v29 = v122.HandleCharredBrambles(v118.HealingSurge, v119.HealingSurgeMouseover, 71 - 31);
							if (v29 or ((1161 + 1957) <= (4587 - 2736))) then
								return v29;
							end
							v239 = 1029 - (834 + 192);
						end
					end
				end
				v138 = 1 + 1;
			end
			if (((1 + 1) == v138) or ((4 + 161) >= (5409 - 1917))) then
				if (((4253 - (300 + 4)) < (1297 + 3559)) and v43) then
					local v240 = 0 - 0;
					while true do
						if ((v240 == (362 - (112 + 250))) or ((1705 + 2571) < (7555 - 4539))) then
							v29 = v122.HandleFyrakkNPC(v118.Riptide, v119.RiptideMouseover, 23 + 17);
							if (((2426 + 2264) > (3086 + 1039)) and v29) then
								return v29;
							end
							v240 = 1 + 0;
						end
						if ((v240 == (2 + 0)) or ((1464 - (1001 + 413)) >= (1997 - 1101))) then
							v29 = v122.HandleFyrakkNPC(v118.HealingSurge, v119.HealingSurgeMouseover, 922 - (244 + 638));
							if (v29 or ((2407 - (627 + 66)) >= (8813 - 5855))) then
								return v29;
							end
							v240 = 605 - (512 + 90);
						end
						if ((v240 == (1909 - (1665 + 241))) or ((2208 - (373 + 344)) < (291 + 353))) then
							v29 = v122.HandleFyrakkNPC(v118.HealingWave, v119.HealingWaveMouseover, 11 + 29);
							if (((1856 - 1152) < (1670 - 683)) and v29) then
								return v29;
							end
							break;
						end
						if (((4817 - (35 + 1064)) > (1387 + 519)) and (v240 == (2 - 1))) then
							v29 = v122.HandleFyrakkNPC(v118.ChainHeal, v119.ChainHealMouseover, 1 + 39);
							if (v29 or ((2194 - (298 + 938)) > (4894 - (233 + 1026)))) then
								return v29;
							end
							v240 = 1668 - (636 + 1030);
						end
					end
				end
				break;
			end
			if (((1790 + 1711) <= (4388 + 104)) and (v138 == (0 + 0))) then
				if (v112 or ((233 + 3209) < (2769 - (55 + 166)))) then
					v29 = v122.HandleIncorporeal(v118.Hex, v119.HexMouseOver, 6 + 24, true);
					if (((290 + 2585) >= (5591 - 4127)) and v29) then
						return v29;
					end
				end
				if (v111 or ((5094 - (36 + 261)) >= (8556 - 3663))) then
					local v241 = 1368 - (34 + 1334);
					while true do
						if ((v241 == (1 + 0)) or ((429 + 122) > (3351 - (1035 + 248)))) then
							if (((2135 - (20 + 1)) > (492 + 452)) and v113) then
								local v250 = 319 - (134 + 185);
								while true do
									if ((v250 == (1133 - (549 + 584))) or ((2947 - (314 + 371)) >= (10628 - 7532))) then
										v29 = v122.HandleAfflicted(v118.TremorTotem, v118.TremorTotem, 998 - (478 + 490));
										if (v29 or ((1195 + 1060) >= (4709 - (786 + 386)))) then
											return v29;
										end
										break;
									end
								end
							end
							if (v114 or ((12428 - 8591) < (2685 - (1055 + 324)))) then
								local v251 = 1340 - (1093 + 247);
								while true do
									if (((2622 + 328) == (311 + 2639)) and (v251 == (0 - 0))) then
										v29 = v122.HandleAfflicted(v118.PoisonCleansingTotem, v118.PoisonCleansingTotem, 101 - 71);
										if (v29 or ((13439 - 8716) < (8287 - 4989))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((405 + 731) >= (593 - 439)) and (v241 == (0 - 0))) then
							v29 = v122.HandleAfflicted(v118.PurifySpirit, v119.PurifySpiritMouseover, 23 + 7);
							if (v29 or ((692 - 421) > (5436 - (364 + 324)))) then
								return v29;
							end
							v241 = 2 - 1;
						end
					end
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v128()
		if (((1571 + 3169) >= (13188 - 10036)) and v109 and ((v31 and v108) or not v108)) then
			local v182 = 0 - 0;
			while true do
				if ((v182 == (0 - 0)) or ((3846 - (1249 + 19)) >= (3060 + 330))) then
					v29 = v122.HandleTopTrinket(v121, v31, 155 - 115, nil);
					if (((1127 - (686 + 400)) <= (1304 + 357)) and v29) then
						return v29;
					end
					v182 = 230 - (73 + 156);
				end
				if (((3 + 598) < (4371 - (721 + 90))) and (v182 == (1 + 0))) then
					v29 = v122.HandleBottomTrinket(v121, v31, 129 - 89, nil);
					if (((705 - (224 + 246)) < (1112 - 425)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((8375 - 3826) > (210 + 943)) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
			if ((v17:HealthPercentage() <= v81) or ((112 + 4562) < (3432 + 1240))) then
				if (((7292 - 3624) < (15178 - 10617)) and v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((968 - (203 + 310)) == (5598 - (1238 + 755)))) then
			if (((v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) or ((187 + 2476) == (4846 - (709 + 825)))) then
				if (((7881 - 3604) <= (6518 - 2043)) and v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v122.AreUnitsBelowHealthPercentage(v84, v83) and v118.SpiritLinkTotem:IsReady()) or ((1734 - (196 + 668)) == (4694 - 3505))) then
			if (((3216 - 1663) <= (3966 - (171 + 662))) and (v85 == "Player")) then
				if (v24(v119.SpiritLinkTotemPlayer, not v15:IsInRange(133 - (4 + 89))) or ((7840 - 5603) >= (1279 + 2232))) then
					return "spirit_link_totem cooldowns";
				end
			elseif ((v85 == "Friendly under Cursor") or ((5815 - 4491) > (1185 + 1835))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((4478 - (35 + 1451)) == (3334 - (28 + 1425)))) then
					if (((5099 - (941 + 1052)) > (1464 + 62)) and v24(v119.SpiritLinkTotemCursor, not v15:IsInRange(1554 - (822 + 692)))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif (((4314 - 1291) < (1823 + 2047)) and (v85 == "Confirmation")) then
				if (((440 - (45 + 252)) > (74 + 0)) and v24(v118.SpiritLinkTotem, not v15:IsInRange(14 + 26))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((43 - 25) < (2545 - (114 + 319))) and v98 and v122.AreUnitsBelowHealthPercentage(v77, v76) and v118.HealingTideTotem:IsReady()) then
			if (((1574 - 477) <= (2085 - 457)) and v24(v118.HealingTideTotem, not v15:IsInRange(26 + 14))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((6898 - 2268) == (9701 - 5071)) and v122.AreUnitsBelowHealthPercentage(v53, v52) and v118.AncestralProtectionTotem:IsReady()) then
			if (((5503 - (556 + 1407)) > (3889 - (741 + 465))) and (v54 == "Player")) then
				if (((5259 - (170 + 295)) >= (1726 + 1549)) and v24(v119.AncestralProtectionTotemPlayer, not v15:IsInRange(37 + 3))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((3653 - 2169) == (1231 + 253)) and (v54 == "Friendly under Cursor")) then
				if (((919 + 513) < (2014 + 1541)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v119.AncestralProtectionTotemCursor, not v15:IsInRange(1270 - (957 + 273))) or ((285 + 780) > (1433 + 2145))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v54 == "Confirmation") or ((18271 - 13476) < (3707 - 2300))) then
				if (((5659 - 3806) < (23832 - 19019)) and v24(v118.AncestralProtectionTotem, not v15:IsInRange(1820 - (389 + 1391)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v89 and v122.AreUnitsBelowHealthPercentage(v51, v50) and v118.AncestralGuidance:IsReady()) or ((1770 + 1051) < (254 + 2177))) then
			if (v24(v118.AncestralGuidance, not v15:IsInRange(91 - 51)) or ((3825 - (783 + 168)) < (7319 - 5138))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if ((v90 and v122.AreUnitsBelowHealthPercentage(v56, v55) and v118.Ascendance:IsReady()) or ((2645 + 44) <= (654 - (309 + 2)))) then
			if (v24(v118.Ascendance, not v15:IsInRange(122 - 82)) or ((3081 - (1090 + 122)) == (652 + 1357))) then
				return "ascendance cooldowns";
			end
		end
		if ((v100 and (v13:ManaPercentage() <= v79) and v118.ManaTideTotem:IsReady()) or ((11909 - 8363) < (1590 + 732))) then
			if (v24(v118.ManaTideTotem, not v15:IsInRange(1158 - (628 + 490))) or ((374 + 1708) == (11817 - 7044))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((14825 - 11581) > (1829 - (431 + 343))) and v35 and ((v107 and v31) or not v107)) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (5 - 3)) or ((2618 + 695) <= (228 + 1550))) then
					if (v118.Fireblood:IsReady() or ((3116 - (556 + 1139)) >= (2119 - (6 + 9)))) then
						if (((332 + 1480) <= (1665 + 1584)) and v24(v118.Fireblood, not v15:IsInRange(209 - (28 + 141)))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
				if (((629 + 994) <= (2415 - 458)) and ((1 + 0) == v183)) then
					if (((5729 - (486 + 831)) == (11480 - 7068)) and v118.Berserking:IsReady()) then
						if (((6161 - 4411) >= (160 + 682)) and v24(v118.Berserking, not v15:IsInRange(126 - 86))) then
							return "Berserking cooldowns";
						end
					end
					if (((5635 - (668 + 595)) > (1665 + 185)) and v118.BloodFury:IsReady()) then
						if (((47 + 185) < (2238 - 1417)) and v24(v118.BloodFury, not v15:IsInRange(330 - (23 + 267)))) then
							return "BloodFury cooldowns";
						end
					end
					v183 = 1946 - (1129 + 815);
				end
				if (((905 - (371 + 16)) < (2652 - (1326 + 424))) and ((0 - 0) == v183)) then
					if (((10940 - 7946) > (976 - (88 + 30))) and v118.AncestralCall:IsReady()) then
						if (v24(v118.AncestralCall, not v15:IsInRange(811 - (720 + 51))) or ((8353 - 4598) <= (2691 - (421 + 1355)))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((6509 - 2563) > (1839 + 1904)) and v118.BagofTricks:IsReady()) then
						if (v24(v118.BagofTricks, not v15:IsInRange(1123 - (286 + 797))) or ((4880 - 3545) >= (5475 - 2169))) then
							return "BagofTricks cooldowns";
						end
					end
					v183 = 440 - (397 + 42);
				end
			end
		end
	end
	local function v129()
		local v139 = 0 + 0;
		while true do
			if (((5644 - (24 + 776)) > (3470 - 1217)) and ((785 - (222 + 563)) == v139)) then
				if (((995 - 543) == (326 + 126)) and v92 and v122.AreUnitsBelowHealthPercentage(285 - (23 + 167), 1801 - (690 + 1108)) and v118.ChainHeal:IsReady() and v13:BuffUp(v118.HighTide)) then
					if (v24(v119.ChainHealFocus, not v17:IsSpellInRange(v118.ChainHeal), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1645 + 2912) < (1722 + 365))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((4722 - (40 + 808)) == (638 + 3236)) and v99 and (v17:HealthPercentage() <= v78) and v118.HealingWave:IsReady() and (v118.PrimordialWaveResto:TimeSinceLastCast() < (57 - 42))) then
					if (v24(v119.HealingWaveFocus, not v17:IsSpellInRange(v118.HealingWave), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1853 + 85) > (2611 + 2324))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((2334 + 1921) < (3994 - (47 + 524)))) then
					if (((944 + 510) <= (6809 - 4318)) and (v17:HealthPercentage() <= v81)) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((6215 - 2058) <= (6392 - 3589))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((6579 - (1165 + 561)) >= (89 + 2893)) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
					if (((12803 - 8669) > (1281 + 2076)) and (v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((3896 - (341 + 138)) < (685 + 1849))) then
							return "riptide healingaoe";
						end
					end
				end
				v139 = 1 - 0;
			end
			if ((v139 == (329 - (89 + 237))) or ((8756 - 6034) <= (344 - 180))) then
				if ((v102 and v13:IsMoving() and v122.AreUnitsBelowHealthPercentage(v87, v86) and v118.SpiritwalkersGrace:IsReady()) or ((3289 - (581 + 300)) < (3329 - (855 + 365)))) then
					if (v24(v118.SpiritwalkersGrace, nil) or ((78 - 45) == (476 + 979))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v96 and v122.AreUnitsBelowHealthPercentage(v74, v73) and v118.HealingStreamTotem:IsReady()) or ((1678 - (1030 + 205)) >= (3770 + 245))) then
					if (((3147 + 235) > (452 - (156 + 130))) and v24(v118.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v139 == (4 - 2)) or ((471 - 191) == (6264 - 3205))) then
				if (((496 + 1385) > (754 + 539)) and v122.AreUnitsBelowHealthPercentage(v63, v62) and v118.Downpour:IsReady()) then
					if (((2426 - (10 + 59)) == (667 + 1690)) and (v64 == "Player")) then
						if (((605 - 482) == (1286 - (671 + 492))) and v24(v119.DownpourPlayer, not v15:IsInRange(32 + 8), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v64 == "Friendly under Cursor") or ((2271 - (369 + 846)) >= (899 + 2493))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((923 + 158) < (3020 - (1036 + 909)))) then
							if (v24(v119.DownpourCursor, not v15:IsInRange(32 + 8), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1760 - 711) >= (4635 - (11 + 192)))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v64 == "Confirmation") or ((2410 + 2358) <= (1021 - (135 + 40)))) then
						if (v24(v118.Downpour, not v15:IsInRange(96 - 56), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2025 + 1333) <= (3128 - 1708))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v93 and v122.AreUnitsBelowHealthPercentage(v61, v60) and v118.CloudburstTotem:IsReady()) or ((5604 - 1865) <= (3181 - (50 + 126)))) then
					if (v24(v118.CloudburstTotem) or ((4619 - 2960) >= (473 + 1661))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v104 and v122.AreUnitsBelowHealthPercentage(v106, v105) and v118.Wellspring:IsReady()) or ((4673 - (1233 + 180)) < (3324 - (522 + 447)))) then
					if (v24(v118.Wellspring, not v15:IsInRange(1461 - (107 + 1314)), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((311 + 358) == (12867 - 8644))) then
						return "wellspring healingaoe";
					end
				end
				if ((v92 and v122.AreUnitsBelowHealthPercentage(v59, v58) and v118.ChainHeal:IsReady()) or ((719 + 973) < (1167 - 579))) then
					if (v24(v119.ChainHealFocus, not v17:IsSpellInRange(v118.ChainHeal), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((18979 - 14182) < (5561 - (716 + 1194)))) then
						return "chain_heal healingaoe";
					end
				end
				v139 = 1 + 2;
			end
			if ((v139 == (1 + 0)) or ((4680 - (74 + 429)) > (9356 - 4506))) then
				if ((v103 and v118.UnleashLife:IsReady()) or ((199 + 201) > (2542 - 1431))) then
					if (((2159 + 892) > (3098 - 2093)) and (v17:HealthPercentage() <= v88)) then
						if (((9131 - 5438) <= (4815 - (279 + 154))) and v24(v118.UnleashLife, not v17:IsSpellInRange(v118.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v72 == "Cursor") and v118.HealingRain:IsReady()) or ((4060 - (454 + 324)) > (3226 + 874))) then
					if (v24(v119.HealingRainCursor, not v15:IsInRange(57 - (12 + 5)), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1931 + 1649) < (7246 - 4402))) then
						return "healing_rain healingaoe";
					end
				end
				if (((33 + 56) < (5583 - (277 + 816))) and v122.AreUnitsBelowHealthPercentage(v71, v70) and v118.HealingRain:IsReady()) then
					if ((v72 == "Player") or ((21292 - 16309) < (2991 - (1058 + 125)))) then
						if (((718 + 3111) > (4744 - (815 + 160))) and v24(v119.HealingRainPlayer, not v15:IsInRange(171 - 131), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((3525 - 2040) <= (693 + 2211)) and (v72 == "Friendly under Cursor")) then
						if (((12478 - 8209) == (6167 - (41 + 1857))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((2280 - (1222 + 671)) <= (7190 - 4408)) and v24(v119.HealingRainCursor, not v15:IsInRange(57 - 17), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Enemy under Cursor") or ((3081 - (229 + 953)) <= (2691 - (1111 + 663)))) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((5891 - (874 + 705)) <= (123 + 753))) then
							if (((1523 + 709) <= (5395 - 2799)) and v24(v119.HealingRainCursor, not v15:IsInRange(2 + 38), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((2774 - (642 + 37)) < (841 + 2845)) and (v72 == "Confirmation")) then
						if (v24(v118.HealingRain, not v15:IsInRange(7 + 33), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4004 - 2409) >= (4928 - (233 + 221)))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v68, v67) and v118.EarthenWallTotem:IsReady()) or ((10680 - 6061) < (2537 + 345))) then
					if ((v69 == "Player") or ((1835 - (718 + 823)) >= (3040 + 1791))) then
						if (((2834 - (266 + 539)) <= (8731 - 5647)) and v24(v119.EarthenWallTotemPlayer, not v15:IsInRange(1265 - (636 + 589)))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v69 == "Friendly under Cursor") or ((4835 - 2798) == (4991 - 2571))) then
						if (((3533 + 925) > (1419 + 2485)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((1451 - (657 + 358)) >= (325 - 202)) and v24(v119.EarthenWallTotemCursor, not v15:IsInRange(91 - 51))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((1687 - (1151 + 36)) < (1754 + 62)) and (v69 == "Confirmation")) then
						if (((940 + 2634) == (10673 - 7099)) and v24(v118.EarthenWallTotem, not v15:IsInRange(1872 - (1552 + 280)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v139 = 836 - (64 + 770);
			end
		end
	end
	local function v130()
		local v140 = 0 + 0;
		while true do
			if (((501 - 280) < (70 + 320)) and (v140 == (1243 - (157 + 1086)))) then
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((4429 - 2216) <= (6223 - 4802))) then
					if (((4690 - 1632) < (6633 - 1773)) and (v17:HealthPercentage() <= v81)) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((2115 - (599 + 220)) >= (8853 - 4407))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((3324 - (1813 + 118)) > (3282 + 1207))) then
					if (((v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) or ((5641 - (841 + 376)) < (37 - 10))) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((464 + 1533) > (10413 - 6598))) then
							return "riptide healingaoe";
						end
					end
				end
				v140 = 860 - (464 + 395);
			end
			if (((8892 - 5427) > (919 + 994)) and (v140 == (840 - (467 + 370)))) then
				if (((1514 - 781) < (1336 + 483)) and v99 and v118.HealingWave:IsReady()) then
					if ((v17:HealthPercentage() <= v78) or ((15066 - 10671) == (742 + 4013))) then
						if (v24(v119.HealingWaveFocus, not v17:IsSpellInRange(v118.HealingWave), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((8824 - 5031) < (2889 - (150 + 370)))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v140 == (1284 - (74 + 1208))) or ((10044 - 5960) == (1256 - 991))) then
				if (((3101 + 1257) == (4748 - (14 + 376))) and v118.ElementalOrbit:IsAvailable() and v13:BuffUp(v118.EarthShieldBuff)) then
					if (v122.IsSoloMode() or ((5442 - 2304) < (643 + 350))) then
						if (((2926 + 404) > (2216 + 107)) and v118.LightningShield:IsReady() and v13:BuffDown(v118.LightningShield)) then
							if (v24(v118.LightningShield) or ((10624 - 6998) == (3001 + 988))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v118.WaterShield:IsReady() and v13:BuffDown(v118.WaterShield)) or ((994 - (23 + 55)) == (6329 - 3658))) then
						if (((182 + 90) == (245 + 27)) and v24(v118.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				if (((6587 - 2338) <= (1523 + 3316)) and v97 and v118.HealingSurge:IsReady()) then
					if (((3678 - (652 + 249)) < (8563 - 5363)) and (v17:HealthPercentage() <= v75)) then
						if (((1963 - (708 + 1160)) < (5312 - 3355)) and v24(v119.HealingSurgeFocus, not v17:IsSpellInRange(v118.HealingSurge), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				v140 = 5 - 2;
			end
			if (((853 - (10 + 17)) < (386 + 1331)) and (v140 == (1733 - (1400 + 332)))) then
				if (((2734 - 1308) >= (3013 - (242 + 1666))) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
					if (((1179 + 1575) <= (1239 + 2140)) and ((v17:HealthPercentage() <= v81) or (v17:HealthPercentage() <= v81))) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((3347 + 580) == (2353 - (850 + 90)))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v118.ElementalOrbit:IsAvailable() and v13:BuffDown(v118.EarthShieldBuff)) or ((2021 - 867) <= (2178 - (360 + 1030)))) then
					if (v24(v118.EarthShield) or ((1455 + 188) > (9536 - 6157))) then
						return "earth_shield healingst";
					end
				end
				v140 = 2 - 0;
			end
		end
	end
	local function v131()
		local v141 = 1661 - (909 + 752);
		while true do
			if ((v141 == (1225 - (109 + 1114))) or ((5131 - 2328) > (1771 + 2778))) then
				if (v118.LightningBolt:IsReady() or ((462 - (6 + 236)) >= (1904 + 1118))) then
					if (((2272 + 550) == (6654 - 3832)) and v24(v118.LightningBolt, not v15:IsSpellInRange(v118.LightningBolt), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v141 == (1 - 0)) or ((2194 - (1076 + 57)) == (306 + 1551))) then
				if (((3449 - (579 + 110)) > (108 + 1256)) and v118.FlameShock:IsReady()) then
					local v242 = 0 + 0;
					while true do
						if ((v242 == (0 + 0)) or ((5309 - (174 + 233)) <= (10041 - 6446))) then
							if (v122.CastCycle(v118.FlameShock, v13:GetEnemiesInRange(70 - 30), v125, not v15:IsSpellInRange(v118.FlameShock), nil, nil, nil, nil) or ((1713 + 2139) == (1467 - (663 + 511)))) then
								return "flame_shock_cycle damage";
							end
							if (v24(v118.FlameShock, not v15:IsSpellInRange(v118.FlameShock)) or ((1391 + 168) == (997 + 3591))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v118.LavaBurst:IsReady() or ((13823 - 9339) == (478 + 310))) then
					if (((10754 - 6186) >= (9457 - 5550)) and v24(v118.LavaBurst, not v15:IsSpellInRange(v118.LavaBurst), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v141 = 1 + 1;
			end
			if (((2425 - 1179) < (2473 + 997)) and (v141 == (0 + 0))) then
				if (((4790 - (478 + 244)) >= (1489 - (440 + 77))) and v118.Stormkeeper:IsReady()) then
					if (((225 + 268) < (14248 - 10355)) and v24(v118.Stormkeeper, not v15:IsInRange(1596 - (655 + 901)))) then
						return "stormkeeper damage";
					end
				end
				if ((#v13:GetEnemiesInRange(8 + 32) > (1 + 0)) or ((995 + 478) >= (13423 - 10091))) then
					if (v118.ChainLightning:IsReady() or ((5496 - (695 + 750)) <= (3950 - 2793))) then
						if (((931 - 327) < (11586 - 8705)) and v24(v118.ChainLightning, not v15:IsSpellInRange(v118.ChainLightning), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v141 = 352 - (285 + 66);
			end
		end
	end
	local function v132()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (1317 - (682 + 628))) or ((146 + 754) == (3676 - (176 + 123)))) then
				v81 = EpicSettings.Settings['RiptideHP'];
				v82 = EpicSettings.Settings['RiptideTankHP'];
				v83 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v84 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v142 = 4 + 4;
			end
			if (((3235 + 1224) > (860 - (239 + 30))) and (v142 == (1 + 0))) then
				v59 = EpicSettings.Settings['ChainHealHP'];
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v62 = EpicSettings.Settings['DownpourGroup'];
				v142 = 2 + 0;
			end
			if (((6014 - 2616) >= (7471 - 5076)) and (v142 == (326 - (306 + 9)))) then
				v36 = EpicSettings.Settings['useHealthstone'];
				v46 = EpicSettings.Settings['UsePurgeTarget'];
				v101 = EpicSettings.Settings['UseRiptide'];
				v102 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v142 = 41 - 29;
			end
			if ((v142 == (2 + 8)) or ((1340 + 843) >= (1360 + 1464))) then
				v96 = EpicSettings.Settings['UseHealingStreamTotem'];
				v97 = EpicSettings.Settings['UseHealingSurge'];
				v98 = EpicSettings.Settings['UseHealingTideTotem'];
				v99 = EpicSettings.Settings['UseHealingWave'];
				v142 = 31 - 20;
			end
			if (((3311 - (1140 + 235)) == (1233 + 703)) and (v142 == (0 + 0))) then
				v52 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v53 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v58 = EpicSettings.Settings['ChainHealGroup'];
				v142 = 1 + 0;
			end
			if ((v142 == (64 - (33 + 19))) or ((1745 + 3087) < (12927 - 8614))) then
				v103 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((1801 + 2287) > (7597 - 3723)) and (v142 == (8 + 0))) then
				v85 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v86 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v88 = EpicSettings.Settings['UnleashLifeHP'];
				v142 = 698 - (586 + 103);
			end
			if (((395 + 3937) == (13336 - 9004)) and (v142 == (1490 - (1309 + 179)))) then
				v63 = EpicSettings.Settings['DownpourHP'];
				v64 = EpicSettings.Settings['DownpourUsage'];
				v67 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v68 = EpicSettings.Settings['EarthenWallTotemHP'];
				v142 = 5 - 2;
			end
			if (((1741 + 2258) >= (7788 - 4888)) and (v142 == (3 + 0))) then
				v69 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v70 = EpicSettings.Settings['HealingRainGroup'];
				v142 = 7 - 3;
			end
			if ((v142 == (11 - 5)) or ((3134 - (295 + 314)) > (9981 - 5917))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v142 = 1969 - (1300 + 662);
			end
			if (((13725 - 9354) == (6126 - (1178 + 577))) and (v142 == (5 + 4))) then
				v92 = EpicSettings.Settings['UseChainHeal'];
				v93 = EpicSettings.Settings['UseCloudburstTotem'];
				v95 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v142 = 29 - 19;
			end
			if ((v142 == (1410 - (851 + 554))) or ((236 + 30) > (13827 - 8841))) then
				v75 = EpicSettings.Settings['HealingSurgeHP'];
				v76 = EpicSettings.Settings['HealingTideTotemGroup'];
				v77 = EpicSettings.Settings['HealingTideTotemHP'];
				v78 = EpicSettings.Settings['HealingWaveHP'];
				v142 = 12 - 6;
			end
			if (((2293 - (115 + 187)) >= (709 + 216)) and (v142 == (4 + 0))) then
				v71 = EpicSettings.Settings['HealingRainHP'];
				v72 = EpicSettings.Settings['HealingRainUsage'];
				v73 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v74 = EpicSettings.Settings['HealingStreamTotemHP'];
				v142 = 19 - 14;
			end
		end
	end
	local function v133()
		v50 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v51 = EpicSettings.Settings['AncestralGuidanceHP'];
		v55 = EpicSettings.Settings['AscendanceGroup'];
		v56 = EpicSettings.Settings['AscendanceHP'];
		v57 = EpicSettings.Settings['AstralShiftHP'];
		v60 = EpicSettings.Settings['CloudburstTotemGroup'];
		v61 = EpicSettings.Settings['CloudburstTotemHP'];
		v65 = EpicSettings.Settings['EarthElementalHP'];
		v66 = EpicSettings.Settings['EarthElementalTankHP'];
		v79 = EpicSettings.Settings['ManaTideTotemMana'];
		v80 = EpicSettings.Settings['PrimordialWaveHP'];
		v89 = EpicSettings.Settings['UseAncestralGuidance'];
		v90 = EpicSettings.Settings['UseAscendance'];
		v91 = EpicSettings.Settings['UseAstralShift'];
		v94 = EpicSettings.Settings['UseEarthElemental'];
		v100 = EpicSettings.Settings['UseManaTideTotem'];
		v104 = EpicSettings.Settings['UseWellspring'];
		v105 = EpicSettings.Settings['WellspringGroup'];
		v106 = EpicSettings.Settings['WellspringHP'];
		v107 = EpicSettings.Settings['racialsWithCD'];
		v35 = EpicSettings.Settings['useRacials'];
		v108 = EpicSettings.Settings['trinketsWithCD'];
		v109 = EpicSettings.Settings['useTrinkets'];
		v110 = EpicSettings.Settings['fightRemainsCheck'];
		v111 = EpicSettings.Settings['handleAfflicted'];
		v112 = EpicSettings.Settings['HandleIncorporeal'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v43 = EpicSettings.Settings['HandleFyrakkNPC'];
		v113 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v114 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v134()
		local v174 = 1161 - (160 + 1001);
		local v175;
		while true do
			if (((399 + 56) < (1417 + 636)) and (v174 == (5 - 2))) then
				if (v13:AffectingCombat() or v30 or ((1184 - (237 + 121)) == (5748 - (525 + 372)))) then
					local v243 = 0 - 0;
					local v244;
					while true do
						if (((601 - 418) == (325 - (96 + 46))) and (v243 == (777 - (643 + 134)))) then
							v244 = v44 and v118.PurifySpirit:IsReady() and v32;
							if (((419 + 740) <= (4287 - 2499)) and v118.EarthShield:IsReady() and v95 and (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 92 - 67) < (1 + 0))) then
								local v252 = 0 - 0;
								while true do
									if ((v252 == (1 - 0)) or ((4226 - (316 + 403)) > (2871 + 1447))) then
										if ((v122.UnitGroupRole(v17) == "TANK") or ((8454 - 5379) <= (1072 + 1893))) then
											if (((3437 - 2072) <= (1426 + 585)) and v24(v119.EarthShieldFocus, not v17:IsSpellInRange(v118.EarthShield))) then
												return "earth_shield_tank main apl";
											end
										end
										break;
									end
									if ((v252 == (0 + 0)) or ((9618 - 6842) > (17073 - 13498))) then
										v29 = v122.FocusUnitRefreshableBuff(v118.EarthShield, 31 - 16, 3 + 37, "TANK", true, 49 - 24);
										if (v29 or ((125 + 2429) == (14133 - 9329))) then
											return v29;
										end
										v252 = 18 - (12 + 5);
									end
								end
							end
							v243 = 3 - 2;
						end
						if (((5498 - 2921) == (5477 - 2900)) and (v243 == (2 - 1))) then
							if (not v17:BuffDown(v118.EarthShield) or (v122.UnitGroupRole(v17) ~= "TANK") or not v95 or (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 6 + 19) >= (1974 - (1656 + 317))) or ((6 + 0) >= (1514 + 375))) then
								local v253 = 0 - 0;
								while true do
									if (((2490 - 1984) <= (2246 - (5 + 349))) and (v253 == (0 - 0))) then
										v29 = v122.FocusUnit(v244, nil, nil, nil);
										if (v29 or ((3279 - (266 + 1005)) > (1462 + 756))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((1293 - 914) <= (5459 - 1312)) and v118.EarthShield:IsCastable() and v95 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(1736 - (561 + 1135)) and (v122.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v118.EarthShield))) then
					if (v24(v119.EarthShieldFocus, not v17:IsSpellInRange(v118.EarthShield)) or ((5882 - 1368) <= (3316 - 2307))) then
						return "earth_shield_tank main apl";
					end
				end
				v175 = nil;
				v174 = 1070 - (507 + 559);
			end
			if ((v174 == (4 - 2)) or ((10811 - 7315) == (1580 - (212 + 176)))) then
				v34 = EpicSettings.Toggles['dps'];
				if (v13:IsDeadOrGhost() or ((1113 - (250 + 655)) == (8068 - 5109))) then
					return;
				end
				if (((7472 - 3195) >= (2053 - 740)) and (v122.TargetIsValid() or v13:AffectingCombat())) then
					local v245 = 1956 - (1869 + 87);
					while true do
						if (((8972 - 6385) < (5075 - (484 + 1417))) and (v245 == (0 - 0))) then
							v117 = v13:GetEnemiesInRange(67 - 27);
							v115 = v10.BossFightRemains(nil, true);
							v245 = 774 - (48 + 725);
						end
						if ((v245 == (1 - 0)) or ((11053 - 6933) <= (1278 + 920))) then
							v116 = v115;
							if ((v116 == (29693 - 18582)) or ((447 + 1149) == (251 + 607))) then
								v116 = v10.FightRemains(v117, false);
							end
							break;
						end
					end
				end
				v174 = 856 - (152 + 701);
			end
			if (((4531 - (430 + 881)) == (1234 + 1986)) and (v174 == (896 - (557 + 338)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v174 = 1 + 1;
			end
			if (((10 - 6) == v174) or ((4909 - 3507) > (9617 - 5997))) then
				if (((5547 - 2973) == (3375 - (499 + 302))) and not v13:AffectingCombat()) then
					if (((2664 - (39 + 827)) < (7610 - 4853)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v248 = 0 - 0;
						local v249;
						while true do
							if ((v248 == (0 - 0)) or ((578 - 201) > (223 + 2381))) then
								v249 = v122.DeadFriendlyUnitsCount();
								if (((1662 - 1094) < (146 + 765)) and (v249 > (1 - 0))) then
									if (((3389 - (103 + 1)) < (4782 - (475 + 79))) and v24(v118.AncestralVision, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (((8465 - 4549) > (10649 - 7321)) and v24(v119.AncestralSpiritMouseover, not v15:IsInRange(6 + 34), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				if (((2201 + 299) < (5342 - (1395 + 108))) and v13:AffectingCombat() and v122.TargetIsValid()) then
					local v246 = 0 - 0;
					while true do
						if (((1711 - (7 + 1197)) == (222 + 285)) and (v246 == (0 + 0))) then
							v29 = v122.Interrupt(v118.WindShear, 349 - (27 + 292), true);
							if (((703 - 463) <= (4036 - 871)) and v29) then
								return v29;
							end
							v29 = v122.InterruptCursor(v118.WindShear, v119.WindShearMouseover, 125 - 95, true, v16);
							if (((1644 - 810) >= (1533 - 728)) and v29) then
								return v29;
							end
							v246 = 140 - (43 + 96);
						end
						if ((v246 == (4 - 3)) or ((8617 - 4805) < (1922 + 394))) then
							v29 = v122.InterruptWithStunCursor(v118.CapacitorTotem, v119.CapacitorTotemCursor, 9 + 21, nil, v16);
							if (v29 or ((5241 - 2589) <= (588 + 945))) then
								return v29;
							end
							v175 = v126();
							if (v175 or ((6742 - 3144) < (460 + 1000))) then
								return v175;
							end
							v246 = 1 + 1;
						end
						if ((v246 == (1753 - (1414 + 337))) or ((6056 - (1642 + 298)) < (3107 - 1915))) then
							if ((v118.GreaterPurge:IsAvailable() and v46 and v118.GreaterPurge:IsReady() and v32 and v45 and not v13:IsCasting() and not v13:IsChanneling() and v122.UnitHasMagicBuff(v15)) or ((9715 - 6338) <= (2679 - 1776))) then
								if (((1309 + 2667) >= (342 + 97)) and v24(v118.GreaterPurge, not v15:IsSpellInRange(v118.GreaterPurge))) then
									return "greater_purge utility";
								end
							end
							if (((4724 - (357 + 615)) == (2634 + 1118)) and v118.Purge:IsReady() and v46 and v32 and v45 and not v13:IsCasting() and not v13:IsChanneling() and v122.UnitHasMagicBuff(v15)) then
								if (((9927 - 5881) > (2310 + 385)) and v24(v118.Purge, not v15:IsSpellInRange(v118.Purge))) then
									return "purge utility";
								end
							end
							if ((v116 > v110) or ((7597 - 4052) == (2557 + 640))) then
								local v254 = 0 + 0;
								while true do
									if (((1505 + 889) > (1674 - (384 + 917))) and (v254 == (697 - (128 + 569)))) then
										v175 = v128();
										if (((5698 - (1407 + 136)) <= (6119 - (687 + 1200))) and v175) then
											return v175;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((5291 - (556 + 1154)) == (12218 - 8745))) then
					local v247 = 95 - (9 + 86);
					while true do
						if (((5416 - (275 + 146)) > (545 + 2803)) and ((66 - (29 + 35)) == v247)) then
							if (v33 or ((3341 - 2587) > (11122 - 7398))) then
								local v255 = 0 - 0;
								while true do
									if (((142 + 75) >= (1069 - (53 + 959))) and (v255 == (408 - (312 + 96)))) then
										v175 = v129();
										if (v175 or ((3592 - 1522) >= (4322 - (147 + 138)))) then
											return v175;
										end
										v255 = 900 - (813 + 86);
									end
									if (((2445 + 260) == (5011 - 2306)) and (v255 == (493 - (18 + 474)))) then
										v175 = v130();
										if (((21 + 40) == (199 - 138)) and v175) then
											return v175;
										end
										break;
									end
								end
							end
							if (v34 or ((1785 - (860 + 226)) >= (1599 - (121 + 182)))) then
								if (v122.TargetIsValid() or ((220 + 1563) >= (4856 - (988 + 252)))) then
									local v257 = 0 + 0;
									while true do
										if ((v257 == (0 + 0)) or ((5883 - (49 + 1921)) > (5417 - (223 + 667)))) then
											v175 = v131();
											if (((4428 - (51 + 1)) > (1405 - 588)) and v175) then
												return v175;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((10408 - 5547) > (1949 - (146 + 979))) and (v247 == (0 + 0))) then
							if ((v32 and v44) or ((1988 - (311 + 294)) >= (5942 - 3811))) then
								local v256 = 0 + 0;
								while true do
									if ((v256 == (1443 - (496 + 947))) or ((3234 - (1233 + 125)) >= (1032 + 1509))) then
										if (((1599 + 183) <= (717 + 3055)) and v17) then
											if ((v118.PurifySpirit:IsReady() and v122.DispellableFriendlyUnit(1670 - (963 + 682))) or ((3923 + 777) < (2317 - (504 + 1000)))) then
												if (((2155 + 1044) < (3689 + 361)) and v24(v119.PurifySpiritFocus, not v17:IsSpellInRange(v118.PurifySpirit))) then
													return "purify_spirit dispel focus";
												end
											end
										end
										if ((v16 and v16:Exists() and v16:IsAPlayer() and (v122.UnitHasMagicDebuff(v16) or (v122.UnitHasCurseDebuff(v16) and v118.ImprovedPurifySpirit:IsAvailable()))) or ((468 + 4483) < (6532 - 2102))) then
											if (((83 + 13) == (56 + 40)) and v118.PurifySpirit:IsReady()) then
												if (v24(v119.PurifySpiritMouseover, not v16:IsSpellInRange(v118.PurifySpirit)) or ((2921 - (156 + 26)) > (2309 + 1699))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							if (((v17:HealthPercentage() < v80) and v17:BuffDown(v118.Riptide)) or ((35 - 12) == (1298 - (149 + 15)))) then
								if (v118.PrimordialWaveResto:IsCastable() or ((3653 - (890 + 70)) >= (4228 - (39 + 78)))) then
									if (v24(v119.PrimordialWaveFocus, not v17:IsSpellInRange(v118.PrimordialWaveResto)) or ((4798 - (14 + 468)) <= (4719 - 2573))) then
										return "primordial_wave main";
									end
								end
							end
							v247 = 2 - 1;
						end
						if ((v247 == (1 + 0)) or ((2130 + 1416) <= (597 + 2212))) then
							v175 = v127();
							if (((2215 + 2689) > (568 + 1598)) and v175) then
								return v175;
							end
							v247 = 3 - 1;
						end
					end
				end
				break;
			end
			if (((108 + 1) >= (316 - 226)) and (v174 == (0 + 0))) then
				v132();
				v133();
				v30 = EpicSettings.Toggles['ooc'];
				v174 = 52 - (12 + 39);
			end
		end
	end
	local function v135()
		local v176 = 0 + 0;
		while true do
			if (((15408 - 10430) > (10346 - 7441)) and (v176 == (0 + 0))) then
				v124();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(139 + 125, v134, v135);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

