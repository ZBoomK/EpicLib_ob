local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((12934 - 7980) == (1804 + 1099))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_RestoShaman.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = v9.Utils;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Press;
	local v23 = v20.Macro;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = math.min;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v104 = 12278 - (645 + 522);
	local v105 = 12901 - (1010 + 780);
	v9:RegisterForEvent(function()
		local v124 = 0 + 0;
		while true do
			if (((14691 - 11607) > (117 - 77)) and (v124 == (1836 - (1045 + 791)))) then
				v104 = 28124 - 17013;
				v105 = 16965 - 5854;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v106 = v16.Shaman.Restoration;
	local v107 = v23.Shaman.Restoration;
	local v108 = v18.Shaman.Restoration;
	local v109 = {};
	local v110 = v20.Commons.Everyone;
	local v111 = v20.Commons.Shaman;
	local function v112()
		if (((3917 - (351 + 154)) > (2393 - (1281 + 293))) and v106.ImprovedPurifySpirit:IsAvailable()) then
			v110.DispellableDebuffs = v19.MergeTable(v110.DispellableMagicDebuffs, v110.DispellableCurseDebuffs);
		else
			v110.DispellableDebuffs = v110.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v113(v125)
		return v125:DebuffRefreshable(v106.FlameShockDebuff) and (v105 > (271 - (28 + 238)));
	end
	local function v114()
		local v126 = 0 - 0;
		while true do
			if (((4721 - (1381 + 178)) <= (3228 + 213)) and (v126 == (1 + 0))) then
				if (((2008 + 2698) > (15268 - 10839)) and v108.Healthstone:IsReady() and v33 and (v12:HealthPercentage() <= v34)) then
					if (((1479 + 1375) < (4565 - (381 + 89))) and v22(v107.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v35 and (v12:HealthPercentage() <= v36)) or ((939 + 119) >= (813 + 389))) then
					if (((6356 - 2645) > (4511 - (1074 + 82))) and (v37 == "Refreshing Healing Potion")) then
						if (v108.RefreshingHealingPotion:IsReady() or ((1985 - 1079) >= (4013 - (214 + 1570)))) then
							if (((2743 - (990 + 465)) > (516 + 735)) and v22(v107.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v126 == (0 + 0)) or ((4389 + 124) < (13191 - 9839))) then
				if ((v96 and v106.AstralShift:IsReady()) or ((3791 - (1668 + 58)) >= (3822 - (512 + 114)))) then
					if ((v12:HealthPercentage() <= v97) or ((11408 - 7032) <= (3061 - 1580))) then
						if (v22(v106.AstralShift) or ((11802 - 8410) >= (2206 + 2535))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((623 + 2702) >= (1873 + 281)) and v98 and v106.EarthElemental:IsReady()) then
					if ((v12:HealthPercentage() <= v99) or v110.IsTankBelowHealthPercentage(v100) or ((4367 - 3072) >= (5227 - (109 + 1885)))) then
						if (((5846 - (1269 + 200)) > (3146 - 1504)) and v22(v106.EarthElemental)) then
							return "earth_elemental defensives";
						end
					end
				end
				v126 = 816 - (98 + 717);
			end
		end
	end
	local function v115()
		local v127 = 826 - (802 + 24);
		while true do
			if (((8144 - 3421) > (1712 - 356)) and (v127 == (1 + 2))) then
				if (ShouldReturn or ((3178 + 958) <= (564 + 2869))) then
					return ShouldReturn;
				end
				if (((916 + 3329) <= (12883 - 8252)) and v39) then
					local v213 = 0 - 0;
					while true do
						if (((1530 + 2746) >= (1594 + 2320)) and (v213 == (0 + 0))) then
							ShouldReturn = v110.HandleIncorporeal(v106.Hex, v107.HexMouseOver, 22 + 8);
							if (((93 + 105) <= (5798 - (797 + 636))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
			if (((23218 - 18436) > (6295 - (1427 + 192))) and (v127 == (1 + 1))) then
				if (((11292 - 6428) > (1975 + 222)) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v110.HandleChromie(v106.HealingWave, v107.HealingWaveMouseover, 19 + 21);
				v127 = 329 - (192 + 134);
			end
			if ((v127 == (1277 - (316 + 960))) or ((2060 + 1640) == (1935 + 572))) then
				if (((4136 + 338) >= (1047 - 773)) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v110.HandleChromie(v106.HealingSurge, v107.HealingSurgeMouseover, 591 - (83 + 468));
				v127 = 1808 - (1202 + 604);
			end
			if ((v127 == (0 - 0)) or ((3152 - 1258) <= (3892 - 2486))) then
				if (((1897 - (45 + 280)) >= (1478 + 53)) and v38) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (1 + 1)) or ((2594 + 2093) < (799 + 3743))) then
							ShouldReturn = v110.HandleAfflicted(v106.Riptide, v107.RiptideMouseover, 74 - 34);
							if (((5202 - (340 + 1571)) > (658 + 1009)) and ShouldReturn) then
								return ShouldReturn;
							end
							v214 = 1775 - (1733 + 39);
						end
						if (((2 - 1) == v214) or ((1907 - (125 + 909)) == (3982 - (1096 + 852)))) then
							ShouldReturn = v110.HandleAfflicted(v106.PurifySpirit, v107.PurifySpiritMouseover, 18 + 22);
							if (ShouldReturn or ((4020 - 1204) < (11 + 0))) then
								return ShouldReturn;
							end
							v214 = 514 - (409 + 103);
						end
						if (((3935 - (46 + 190)) < (4801 - (51 + 44))) and (v214 == (2 + 2))) then
							ShouldReturn = v110.HandleAfflicted(v106.HealingWave, v107.HealingWaveMouseover, 1357 - (1114 + 203));
							if (((3372 - (228 + 498)) >= (190 + 686)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if (((340 + 274) <= (3847 - (174 + 489))) and (v214 == (0 - 0))) then
							ShouldReturn = v110.HandleAfflicted(v106.PoisonCleansingTotem, nil, 1945 - (830 + 1075));
							if (((3650 - (303 + 221)) == (4395 - (231 + 1038))) and ShouldReturn) then
								return ShouldReturn;
							end
							v214 = 1 + 0;
						end
						if ((v214 == (1165 - (171 + 991))) or ((9013 - 6826) >= (13302 - 8348))) then
							ShouldReturn = v110.HandleAfflicted(v106.HealingSurge, v107.HealingSurgeMouseover, 99 - 59);
							if (ShouldReturn or ((3103 + 774) == (12531 - 8956))) then
								return ShouldReturn;
							end
							v214 = 11 - 7;
						end
					end
				end
				ShouldReturn = v110.HandleChromie(v106.Riptide, v107.RiptideMouseover, 64 - 24);
				v127 = 3 - 2;
			end
		end
	end
	local function v116()
		ShouldReturn = v110.HandleTopTrinket(v109, v28, 1288 - (111 + 1137), nil);
		if (((865 - (91 + 67)) > (1880 - 1248)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v110.HandleBottomTrinket(v109, v28, 10 + 30, nil);
		if (ShouldReturn or ((1069 - (423 + 100)) >= (19 + 2665))) then
			return ShouldReturn;
		end
		if (((4056 - 2591) <= (2242 + 2059)) and v106.EarthShield:IsReady() and v45 and v15:Exists() and not v15:IsDeadOrGhost() and v15:IsInRange(811 - (326 + 445)) and (v110.UnitGroupRole(v15) == "TANK") and v15:BuffDown(v106.EarthShield)) then
			if (((7436 - 5732) > (3174 - 1749)) and v22(v107.EarthShieldFocus)) then
				return "earth_shield_tank healingst";
			end
		end
		if ((v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) or ((1603 - 916) == (4945 - (530 + 181)))) then
			if ((v15:HealthPercentage() <= v47) or ((4211 - (614 + 267)) < (1461 - (19 + 13)))) then
				if (((1866 - 719) >= (780 - 445)) and v22(v107.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if (((9812 - 6377) > (545 + 1552)) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
			if (((v15:HealthPercentage() <= v48) and (v110.UnitGroupRole(v15) == "TANK")) or ((6630 - 2860) >= (8380 - 4339))) then
				if (v22(v107.RiptideFocus) or ((5603 - (1293 + 519)) <= (3286 - 1675))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v110.AreUnitsBelowHealthPercentage(v68, v69) and v106.SpiritLinkTotem:IsReady()) or ((11952 - 7374) <= (3839 - 1831))) then
			if (((4851 - 3726) <= (4890 - 2814)) and (v67 == "Player")) then
				if (v22(v107.SpiritLinkTotemPlayer) or ((394 + 349) >= (898 + 3501))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((2683 - 1528) < (387 + 1286)) and (v67 == "Friendly under Cursor")) then
				if ((Mouseover:Exists() and not v12:CanAttack(Mouseover)) or ((773 + 1551) <= (362 + 216))) then
					if (((4863 - (709 + 387)) == (5625 - (673 + 1185))) and v22(v107.SpiritLinkTotemCursor, not v14:IsInRange(116 - 76))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif (((13130 - 9041) == (6727 - 2638)) and (v67 == "Confirmation")) then
				if (((3189 + 1269) >= (1251 + 423)) and v22(v106.SpiritLinkTotem)) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((1311 - 339) <= (349 + 1069)) and v70 and v110.AreUnitsBelowHealthPercentage(v71, v72) and v106.HealingTideTotem:IsReady()) then
			if (v22(v106.HealingTideTotem) or ((9845 - 4907) < (9347 - 4585))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if ((v110.AreUnitsBelowHealthPercentage(v80, v81) and v106.AncestralProtectionTotem:IsReady()) or ((4384 - (446 + 1434)) > (5547 - (1040 + 243)))) then
			if (((6425 - 4272) == (4000 - (559 + 1288))) and (v79 == "Player")) then
				if (v22(v107.AncestralProtectionTotemPlayer) or ((2438 - (609 + 1322)) >= (3045 - (13 + 441)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((16744 - 12263) == (11737 - 7256)) and (v79 == "Friendly under Cursor")) then
				if ((Mouseover:Exists() and not v12:CanAttack(Mouseover)) or ((11594 - 9266) < (26 + 667))) then
					if (((15718 - 11390) == (1538 + 2790)) and v22(v107.AncestralProtectionTotemCursor, not v14:IsInRange(18 + 22))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((4712 - 3124) >= (729 + 603)) and (v79 == "Confirmation")) then
				if (v22(v106.AncestralProtectionTotem) or ((7676 - 3502) > (2809 + 1439))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v88 and v110.AreUnitsBelowHealthPercentage(v89, v90) and v106.AncestralGuidance:IsReady()) or ((2551 + 2035) <= (59 + 23))) then
			if (((3244 + 619) == (3780 + 83)) and v22(v106.AncestralGuidance)) then
				return "ancestral_guidance cooldowns";
			end
		end
		if ((v91 and v110.AreUnitsBelowHealthPercentage(v92, v93) and v106.Ascendance:IsReady()) or ((715 - (153 + 280)) <= (120 - 78))) then
			if (((4138 + 471) >= (303 + 463)) and v22(v106.Ascendance)) then
				return "ascendance cooldowns";
			end
		end
		if ((v94 and (v12:Mana() <= v95) and v106.ManaTideTotem:IsReady()) or ((603 + 549) == (2258 + 230))) then
			if (((2480 + 942) > (5101 - 1751)) and v22(v106.ManaTideTotem)) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((543 + 334) > (1043 - (89 + 578))) and v32) then
			if (v106.AncestralCall:IsReady() or ((2228 + 890) <= (3847 - 1996))) then
				if (v22(v106.AncestralCall) or ((1214 - (572 + 477)) >= (471 + 3021))) then
					return "AncestralCall cooldowns";
				end
			end
			if (((2370 + 1579) < (580 + 4276)) and v106.BagofTricks:IsReady()) then
				if (v22(v106.BagofTricks) or ((4362 - (84 + 2)) < (4970 - 1954))) then
					return "BagofTricks cooldowns";
				end
			end
			if (((3379 + 1311) > (4967 - (497 + 345))) and v106.Berserking:IsReady()) then
				if (v22(v106.Berserking) or ((2 + 48) >= (152 + 744))) then
					return "Berserking cooldowns";
				end
			end
			if (v106.BloodFury:IsReady() or ((3047 - (605 + 728)) >= (2111 + 847))) then
				if (v22(v106.BloodFury) or ((3314 - 1823) < (30 + 614))) then
					return "BloodFury cooldowns";
				end
			end
			if (((2602 - 1898) < (890 + 97)) and v106.Fireblood:IsReady()) then
				if (((10300 - 6582) > (1440 + 466)) and v22(v106.Fireblood)) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v117()
		local v128 = 489 - (457 + 32);
		while true do
			if (((0 + 0) == v128) or ((2360 - (832 + 570)) > (3425 + 210))) then
				if (((913 + 2588) <= (15896 - 11404)) and v106.EarthShield:IsReady() and v45 and v15:Exists() and not v15:IsDeadOrGhost() and v15:IsInRange(20 + 20) and (v110.UnitGroupRole(v15) == "TANK") and v15:BuffDown(v106.EarthShield)) then
					if (v22(v107.EarthShieldFocus) or ((4238 - (588 + 208)) < (6867 - 4319))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((4675 - (884 + 916)) >= (3064 - 1600)) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
					if ((v15:HealthPercentage() <= v47) or ((2782 + 2015) >= (5546 - (232 + 421)))) then
						if (v22(v107.RiptideFocus) or ((2440 - (1569 + 320)) > (508 + 1560))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((402 + 1712) > (3180 - 2236)) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
					if (((v15:HealthPercentage() <= v48) and (v110.UnitGroupRole(v15) == "TANK")) or ((2867 - (316 + 289)) >= (8104 - 5008))) then
						if (v22(v107.RiptideFocus) or ((105 + 2150) >= (4990 - (666 + 787)))) then
							return "riptide healingaoe";
						end
					end
				end
				v128 = 426 - (360 + 65);
			end
			if ((v128 == (1 + 0)) or ((4091 - (79 + 175)) < (2059 - 753))) then
				if (((2303 + 647) == (9042 - 6092)) and v53 and v106.UnleashLife:IsReady()) then
					if ((v15:HealthPercentage() <= v54) or ((9095 - 4372) < (4197 - (503 + 396)))) then
						if (((1317 - (92 + 89)) >= (298 - 144)) and v22(v106.UnleashLife)) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v55 == "Cursor") and v106.HealingRain:IsReady()) or ((139 + 132) > (2811 + 1937))) then
					if (((18562 - 13822) >= (432 + 2720)) and v22(v107.HealingRainCursor, not v14:IsInRange(91 - 51), v12:BuffDown(v106.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v110.AreUnitsBelowHealthPercentage(v56, v57) and v106.HealingRain:IsReady()) or ((2250 + 328) >= (1620 + 1770))) then
					if (((124 - 83) <= (208 + 1453)) and (v55 == "Player")) then
						if (((916 - 315) < (4804 - (485 + 759))) and v22(v107.HealingRainPlayer, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((543 - 308) < (1876 - (442 + 747))) and (v55 == "Friendly under Cursor")) then
						if (((5684 - (832 + 303)) > (2099 - (88 + 858))) and Mouseover:Exists() and not v12:CanAttack(Mouseover)) then
							if (v22(v107.HealingRainCursor, not v14:IsInRange(13 + 27), v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((3869 + 805) < (193 + 4479))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((4457 - (766 + 23)) < (22516 - 17955)) and (v55 == "Enemy under Cursor")) then
						if ((Mouseover:Exists() and v12:CanAttack(Mouseover)) or ((621 - 166) == (9498 - 5893))) then
							if (v22(v107.HealingRainCursor, not v14:IsInRange(135 - 95), v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((3736 - (1036 + 37)) == (2349 + 963))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((8328 - 4051) <= (3521 + 954)) and (v55 == "Confirmation")) then
						if (v22(v106.HealingRain, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((2350 - (641 + 839)) == (2102 - (910 + 3)))) then
							return "healing_rain healingaoe";
						end
					end
				end
				v128 = 4 - 2;
			end
			if (((3237 - (1466 + 218)) <= (1440 + 1693)) and (v128 == (1151 - (556 + 592)))) then
				if ((v85 and v110.AreUnitsBelowHealthPercentage(v86, v87) and v106.Wellspring:IsReady()) or ((796 + 1441) >= (4319 - (329 + 479)))) then
					if (v22(v106.Wellspring, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((2178 - (174 + 680)) > (10377 - 7357))) then
						return "wellspring healingaoe";
					end
				end
				if ((v58 and v110.AreUnitsBelowHealthPercentage(v59, v60) and v106.ChainHeal:IsReady()) or ((6201 - 3209) == (1343 + 538))) then
					if (((3845 - (396 + 343)) > (136 + 1390)) and v22(v107.ChainHealFocus, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				if (((4500 - (29 + 1448)) < (5259 - (135 + 1254))) and v61 and v12:IsMoving() and v110.AreUnitsBelowHealthPercentage(v62, v63) and v106.SpiritwalkersGrace:IsReady()) then
					if (((538 - 395) > (345 - 271)) and v22(v106.SpiritwalkersGrace)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				v128 = 3 + 1;
			end
			if (((1545 - (389 + 1138)) < (2686 - (102 + 472))) and ((2 + 0) == v128)) then
				if (((609 + 488) <= (1518 + 110)) and v110.AreUnitsBelowHealthPercentage(v74, v75) and v106.EarthenWallTotem:IsReady()) then
					if (((6175 - (320 + 1225)) == (8242 - 3612)) and (v73 == "Player")) then
						if (((2166 + 1374) > (4147 - (157 + 1307))) and v22(v107.EarthenWallTotemPlayer)) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((6653 - (821 + 1038)) >= (8171 - 4896)) and (v73 == "Friendly under Cursor")) then
						if (((163 + 1321) == (2635 - 1151)) and Mouseover:Exists() and not v12:CanAttack(Mouseover)) then
							if (((533 + 899) < (8811 - 5256)) and v22(v107.EarthenWallTotemCursor, not v14:IsInRange(1066 - (834 + 192)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v73 == "Confirmation") or ((68 + 997) > (919 + 2659))) then
						if (v22(v106.EarthenWallTotem) or ((103 + 4692) < (2178 - 771))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((2157 - (300 + 4)) < (1286 + 3527)) and v110.AreUnitsBelowHealthPercentage(v77, v78) and v106.Downpour:IsReady()) then
					if ((v76 == "Player") or ((7384 - 4563) < (2793 - (112 + 250)))) then
						if (v22(v107.DownpourPlayer, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((1146 + 1728) < (5463 - 3282))) then
							return "downpour healingaoe";
						end
					elseif ((v76 == "Friendly under Cursor") or ((1541 + 1148) <= (178 + 165))) then
						if ((Mouseover:Exists() and not v12:CanAttack(Mouseover)) or ((1398 + 471) == (997 + 1012))) then
							if (v22(v107.DownpourCursor, not v14:IsInRange(30 + 10), v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((4960 - (1001 + 413)) < (5177 - 2855))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v76 == "Confirmation") or ((2964 - (244 + 638)) == (5466 - (627 + 66)))) then
						if (((9665 - 6421) > (1657 - (512 + 90))) and v22(v106.Downpour, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v82 and v110.AreUnitsBelowHealthPercentage(v83, v84) and v106.CloudburstTotem:IsReady()) or ((5219 - (1665 + 241)) <= (2495 - (373 + 344)))) then
					if (v22(v106.CloudburstTotem) or ((641 + 780) >= (557 + 1547))) then
						return "clouburst_totem healingaoe";
					end
				end
				v128 = 7 - 4;
			end
			if (((3065 - 1253) <= (4348 - (35 + 1064))) and (v128 == (3 + 1))) then
				if (((3472 - 1849) <= (8 + 1949)) and v64 and v110.AreUnitsBelowHealthPercentage(v65, v66) and v106.HealingStreamTotem:IsReady()) then
					if (((5648 - (298 + 938)) == (5671 - (233 + 1026))) and v22(v106.HealingStreamTotem)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v129 = 1666 - (636 + 1030);
		while true do
			if (((895 + 855) >= (823 + 19)) and (v129 == (1 + 0))) then
				if (((296 + 4076) > (2071 - (55 + 166))) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
					if (((45 + 187) < (83 + 738)) and (v15:HealthPercentage() <= v48) and (v110.UnitGroupRole(v15) == "TANK")) then
						if (((1978 - 1460) < (1199 - (36 + 261))) and v22(v107.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				if (((5235 - 2241) > (2226 - (34 + 1334))) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
					if ((v15:HealthPercentage() <= v47) or (v15:HealthPercentage() <= v47) or ((1444 + 2311) <= (711 + 204))) then
						if (((5229 - (1035 + 248)) > (3764 - (20 + 1))) and v22(v107.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v129 = 2 + 0;
			end
			if ((v129 == (321 - (134 + 185))) or ((2468 - (549 + 584)) >= (3991 - (314 + 371)))) then
				if (((16629 - 11785) > (3221 - (478 + 490))) and v110.IsSoloMode()) then
					if (((240 + 212) == (1624 - (786 + 386))) and v106.LightningShield:IsReady() and v12:BuffDown(v106.LightningShield)) then
						if (v22(v106.LightningShield) or ((14760 - 10203) < (3466 - (1055 + 324)))) then
							return "lightning_shield healingst";
						end
					end
				elseif (((5214 - (1093 + 247)) == (3443 + 431)) and v106.WaterShield:IsReady() and v12:BuffDown(v106.WaterShield)) then
					if (v22(v106.WaterShield) or ((204 + 1734) > (19592 - 14657))) then
						return "water_shield healingst";
					end
				end
				if ((v51 and v106.HealingSurge:IsReady()) or ((14440 - 10185) < (9739 - 6316))) then
					if (((3653 - 2199) <= (887 + 1604)) and (v15:HealthPercentage() <= v52)) then
						if (v22(v107.HealingSurgeFocus, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((16014 - 11857) <= (9661 - 6858))) then
							return "healing_surge healingst";
						end
					end
				end
				v129 = 3 + 0;
			end
			if (((12410 - 7557) >= (3670 - (364 + 324))) and (v129 == (7 - 4))) then
				if (((9920 - 5786) > (1113 + 2244)) and v49 and v106.HealingWave:IsReady()) then
					if ((v15:HealthPercentage() <= v50) or ((14297 - 10880) < (4057 - 1523))) then
						if (v22(v107.HealingWaveFocus, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((8266 - 5544) <= (1432 - (1249 + 19)))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v129 == (0 + 0)) or ((9373 - 6965) < (3195 - (686 + 400)))) then
				if ((v106.EarthShield:IsReady() and v45 and v15:Exists() and not v15:IsDeadOrGhost() and v15:IsInRange(32 + 8) and (v110.UnitGroupRole(v15) == "TANK") and v15:BuffDown(v106.EarthShield)) or ((262 - (73 + 156)) == (7 + 1448))) then
					if (v22(v107.EarthShieldFocus) or ((1254 - (721 + 90)) >= (46 + 3969))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((10980 - 7598) > (636 - (224 + 246))) and v46 and v106.Riptide:IsReady() and v15:BuffDown(v106.Riptide)) then
					if ((v15:HealthPercentage() <= v47) or ((453 - 173) == (5631 - 2572))) then
						if (((342 + 1539) > (31 + 1262)) and v22(v107.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v119()
		if (((4685 - 2328) == (7843 - 5486)) and v106.FlameShock:IsReady()) then
			if (((636 - (203 + 310)) == (2116 - (1238 + 755))) and v110.CastCycle(v106.FlameShock, v12:GetEnemiesInRange(3 + 37), v113, not v14:IsSpellInRange(v106.FlameShock), nil, nil, nil, nil)) then
				return "flame_shock_cycle damage";
			end
		end
		if (v106.LavaBurst:IsReady() or ((2590 - (709 + 825)) >= (6250 - 2858))) then
			if (v22(v106.LavaBurst, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((1574 - 493) < (1939 - (196 + 668)))) then
				return "lava_burst damage";
			end
		end
		if (v106.Stormkeeper:IsReady() or ((4141 - 3092) >= (9180 - 4748))) then
			if (v22(v106.Stormkeeper) or ((5601 - (171 + 662)) <= (939 - (4 + 89)))) then
				return "stormkeeper damage";
			end
		end
		if ((#v12:GetEnemiesInRange(140 - 100) < (2 + 1)) or ((14749 - 11391) <= (557 + 863))) then
			if (v106.LightningBolt:IsReady() or ((5225 - (35 + 1451)) <= (4458 - (28 + 1425)))) then
				if (v22(v106.LightningBolt, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((3652 - (941 + 1052)) >= (2047 + 87))) then
					return "lightning_bolt damage";
				end
			end
		elseif (v106.ChainLightning:IsReady() or ((4774 - (822 + 692)) < (3361 - 1006))) then
			if (v22(v106.ChainLightning, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((316 + 353) == (4520 - (45 + 252)))) then
				return "chain_lightning damage";
			end
		end
	end
	local function v120()
		v33 = EpicSettings.Settings['UseHealthstone'];
		v34 = EpicSettings.Settings['HealthstoneHP'];
		v35 = EpicSettings.Settings['UseHealingPotion'];
		v36 = EpicSettings.Settings['HealingPotionHP'];
		v37 = EpicSettings.Settings['HealingPotionName'];
		v38 = EpicSettings.Settings['HandleAfflicted'];
		v39 = EpicSettings.Settings['HandleIncorporeal'];
		v40 = EpicSettings.Settings['DispelDebuffs'];
		v41 = EpicSettings.Settings['DispelBuffs'];
		v42 = EpicSettings.Settings['InterruptWithStun'];
		v43 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v44 = EpicSettings.Settings['InterruptThreshold'];
		v45 = EpicSettings.Settings['UseEarthShield'];
		v46 = EpicSettings.Settings['UseRiptide'];
		v47 = EpicSettings.Settings['RiptideHP'];
		v48 = EpicSettings.Settings['RiptideTankHP'];
		v49 = EpicSettings.Settings['UseHealingWave'];
		v50 = EpicSettings.Settings['HealingWaveHP'];
		v51 = EpicSettings.Settings['UseHealingSurge'];
		v52 = EpicSettings.Settings['HealingSurgeHP'];
		v53 = EpicSettings.Settings['UseUnleashLife'];
		v54 = EpicSettings.Settings['UnleashLifeHP'];
		v55 = EpicSettings.Settings['HealingRainUsage'];
		v56 = EpicSettings.Settings['HealingRainHP'];
		v57 = EpicSettings.Settings['HealingRainGroup'];
		v58 = EpicSettings.Settings['UseChainHeal'];
		v59 = EpicSettings.Settings['ChainHealHP'];
		v60 = EpicSettings.Settings['ChainHealGroup'];
		v61 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v62 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v63 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v64 = EpicSettings.Settings['UseHealingStreamTotem'];
		v65 = EpicSettings.Settings['HealingStreamTotemHP'];
		v66 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v67 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v68 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v69 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v70 = EpicSettings.Settings['UseHealingTideTotem'];
		v71 = EpicSettings.Settings['HealingTideTotemHP'];
		v72 = EpicSettings.Settings['HealingTideTotemGroup'];
		v73 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v74 = EpicSettings.Settings['EarthenWallTotemHP'];
		v75 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v76 = EpicSettings.Settings['DownpourUsage'];
		v77 = EpicSettings.Settings['DownpourHP'];
		v78 = EpicSettings.Settings['DownpourGroup'];
		v79 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v80 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v81 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v82 = EpicSettings.Settings['UseCloudburstTotem'];
	end
	local function v121()
		v83 = EpicSettings.Settings['CloudburstTotemHP'];
		v84 = EpicSettings.Settings['CloudburstTotemGroup'];
		v85 = EpicSettings.Settings['UseWellspring'];
		v86 = EpicSettings.Settings['WellspringHP'];
		v87 = EpicSettings.Settings['WellspringGroup'];
		v88 = EpicSettings.Settings['UseAncestralGuidance'];
		v89 = EpicSettings.Settings['AncestralGuidanceHP'];
		v90 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v91 = EpicSettings.Settings['UseAscendance'];
		v92 = EpicSettings.Settings['AscendanceHP'];
		v93 = EpicSettings.Settings['AscendanceGroup'];
		v94 = EpicSettings.Settings['UseManaTideTotem'];
		v95 = EpicSettings.Settings['ManaTideTotemMana'];
		v96 = EpicSettings.Settings['UseAstralShift'];
		v97 = EpicSettings.Settings['AstralShiftHP'];
		v98 = EpicSettings.Settings['UseEarthElemental'];
		v99 = EpicSettings.Settings['EarthElementalHP'];
		v100 = EpicSettings.Settings['EarthElementalTankHP'];
		v32 = EpicSettings.Settings['UseRacials'];
		v101 = EpicSettings.Settings['PrimordialWaveSaveCooldowns'];
		v102 = EpicSettings.Settings['PrimordialWaveUsage'];
		v103 = EpicSettings.Settings['PrimordialWaveHP'];
	end
	local function v122()
		local v202 = 0 + 0;
		local v203;
		while true do
			if ((v202 == (0 + 0)) or ((4117 - 2425) < (1021 - (114 + 319)))) then
				v120();
				v121();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['cds'];
				v202 = 1 - 0;
			end
			if ((v202 == (3 - 0)) or ((3059 + 1738) < (5439 - 1788))) then
				if (v27 or v12:AffectingCombat() or ((8751 - 4574) > (6813 - (556 + 1407)))) then
					local v215 = 1206 - (741 + 465);
					while true do
						if ((v215 == (466 - (170 + 295))) or ((211 + 189) > (1021 + 90))) then
							if (((7511 - 4460) > (834 + 171)) and v203) then
								return v203;
							end
							if (((2369 + 1324) <= (2482 + 1900)) and v30) then
								local v221 = 1230 - (957 + 273);
								while true do
									if (((0 + 0) == v221) or ((1314 + 1968) > (15622 - 11522))) then
										v203 = v117();
										if (v203 or ((9434 - 5854) < (8686 - 5842))) then
											return v203;
										end
										v221 = 4 - 3;
									end
									if (((1869 - (389 + 1391)) < (2818 + 1672)) and (v221 == (1 + 0))) then
										v203 = v118();
										if (v203 or ((11344 - 6361) < (2759 - (783 + 168)))) then
											return v203;
										end
										break;
									end
								end
							end
							v215 = 6 - 4;
						end
						if (((3767 + 62) > (4080 - (309 + 2))) and (v215 == (0 - 0))) then
							if (((2697 - (1090 + 122)) <= (942 + 1962)) and v29) then
								local v222 = 0 - 0;
								while true do
									if (((2922 + 1347) == (5387 - (628 + 490))) and (v222 == (0 + 0))) then
										if (((957 - 570) <= (12713 - 9931)) and v15 and v40) then
											if ((v106.PurifySpirit:IsReady() and v110.DispellableFriendlyUnit()) or ((2673 - (431 + 343)) <= (1851 - 934))) then
												if (v22(v107.PurifySpirit) or ((12474 - 8162) <= (693 + 183))) then
													return "purify_spirit dispel";
												end
											end
										end
										if (((286 + 1946) <= (4291 - (556 + 1139))) and v41) then
											if (((2110 - (6 + 9)) < (675 + 3011)) and v106.Purge:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v110.UnitHasMagicBuff(v14)) then
												if (v22(v106.Purge, not v14:IsSpellInRange(v106.Purge)) or ((818 + 777) >= (4643 - (28 + 141)))) then
													return "purge dispel";
												end
											end
										end
										break;
									end
								end
							end
							v203 = v115();
							v215 = 1 + 0;
						end
						if ((v215 == (2 - 0)) or ((3272 + 1347) < (4199 - (486 + 831)))) then
							if (v31 or ((765 - 471) >= (17008 - 12177))) then
								if (((384 + 1645) <= (9751 - 6667)) and v110.TargetIsValid()) then
									v203 = v119();
									if (v203 or ((3300 - (668 + 595)) == (2178 + 242))) then
										return v203;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((899 + 3559) > (10646 - 6742)) and (v202 == (292 - (23 + 267)))) then
				if (((2380 - (1129 + 815)) >= (510 - (371 + 16))) and (v12:AffectingCombat() or v27)) then
					local v216 = v40 and v106.PurifySpirit:IsReady() and v29;
					if (((2250 - (1326 + 424)) < (3438 - 1622)) and v106.EarthShield:IsReady() and v45) then
						ShouldReturn = v110.FocusUnitRefreshableBuff(v106.EarthShield, 54 - 39, 158 - (88 + 30), "TANK");
						if (((4345 - (720 + 51)) == (7950 - 4376)) and ShouldReturn) then
							return ShouldReturn;
						end
					end
					if (((1997 - (421 + 1355)) < (643 - 253)) and (not v15:BuffRefreshable(v106.EarthShield) or (v110.UnitGroupRole(v15) ~= "TANK") or not v45)) then
						local v218 = 0 + 0;
						while true do
							if ((v218 == (1083 - (286 + 797))) or ((8089 - 5876) <= (2353 - 932))) then
								ShouldReturn = v110.FocusUnit(v216, nil, nil, nil);
								if (((3497 - (397 + 42)) < (1518 + 3342)) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				v203 = nil;
				if ((not v12:AffectingCombat() and v27) or ((2096 - (24 + 776)) >= (6849 - 2403))) then
					if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v12:CanAttack(v14)) or ((2178 - (222 + 563)) > (9890 - 5401))) then
						local v219 = 0 + 0;
						local v220;
						while true do
							if ((v219 == (190 - (23 + 167))) or ((6222 - (690 + 1108)) < (10 + 17))) then
								v220 = v110.DeadFriendlyUnitsCount();
								if (v12:AffectingCombat() or ((1648 + 349) > (4663 - (40 + 808)))) then
									if (((571 + 2894) > (7315 - 5402)) and (v220 > (1 + 0))) then
										if (((388 + 345) < (998 + 821)) and v22(v106.AncestralVision, nil, v12:BuffDown(v106.SpiritwalkersGraceBuff))) then
											return "ancestral_vision";
										end
									elseif (v22(v106.AncestralSpirit, not v14:IsInRange(611 - (47 + 524)), v12:BuffDown(v106.SpiritwalkersGraceBuff)) or ((2853 + 1542) == (12997 - 8242))) then
										return "ancestral_spirit";
									end
								end
								break;
							end
						end
					end
				end
				if ((v12:AffectingCombat() and v110.TargetIsValid()) or ((5671 - 1878) < (5402 - 3033))) then
					v104 = v9.BossFightRemains(nil, true);
					v105 = v104;
					if ((v105 == (12837 - (1165 + 561))) or ((122 + 3962) == (820 - 555))) then
						v105 = v9.FightRemains(Enemies10ySplash, false);
					end
					local v217 = v110.Interrupt(v106.WindShear, 12 + 18, true);
					if (((4837 - (341 + 138)) == (1177 + 3181)) and v217) then
						return v217;
					end
					v217 = v110.InterruptCursor(v106.WindShear, v107.WindShearMouseover, 61 - 31, true, Mouseover);
					if (v217 or ((3464 - (89 + 237)) < (3194 - 2201))) then
						return v217;
					end
					v217 = v110.InterruptWithStunCursor(v106.CapacitorTotem, v107.CapacitorTotemCursor, 63 - 33, nil, Mouseover);
					if (((4211 - (581 + 300)) > (3543 - (855 + 365))) and v217) then
						return v217;
					end
					v203 = v114();
					if (v203 or ((8612 - 4986) == (1303 + 2686))) then
						return v203;
					end
					v203 = v116();
					if (v203 or ((2151 - (1030 + 205)) == (2508 + 163))) then
						return v203;
					end
					if (((254 + 18) == (558 - (156 + 130))) and (not v101 or v28)) then
						if (((9654 - 5405) <= (8155 - 3316)) and ((v102 == "Both") or (v102 == "Defensive"))) then
							if (((5686 - 2909) < (844 + 2356)) and (v15:HealthPercentage() < v103)) then
								if (((56 + 39) < (2026 - (10 + 59))) and v106.PrimordialWave:IsReady()) then
									if (((234 + 592) < (8455 - 6738)) and v22(v107.PrimordialWaveFocus)) then
										return "primordial_wave main";
									end
								end
							end
						end
						if (((2589 - (671 + 492)) >= (880 + 225)) and ((v102 == "Both") or (v102 == "Offensive"))) then
							if (((3969 - (369 + 846)) <= (895 + 2484)) and v14:DebuffRefreshable(v106.FlameShock) and (v105 > (9 + 1))) then
								if (v106.PrimordialWave:IsReady() or ((5872 - (1036 + 909)) == (1124 + 289))) then
									if (v22(v106.PrimordialWave) or ((1936 - 782) <= (991 - (11 + 192)))) then
										return "primordial_wave main";
									end
								end
							end
						end
					end
				end
				v202 = 2 + 1;
			end
			if ((v202 == (176 - (135 + 40))) or ((3980 - 2337) > (2037 + 1342))) then
				v29 = EpicSettings.Toggles['dispel'];
				v30 = EpicSettings.Toggles['healing'];
				v31 = EpicSettings.Toggles['dps'];
				if (v12:IsDeadOrGhost() or ((6174 - 3371) > (6818 - 2269))) then
					return;
				end
				v202 = 178 - (50 + 126);
			end
		end
	end
	local function v123()
		local v204 = 0 - 0;
		while true do
			if ((v204 == (0 + 0)) or ((1633 - (1233 + 180)) >= (3991 - (522 + 447)))) then
				v112();
				v20.Print("Restoration Shaman rotation by Epic.");
				v204 = 1422 - (107 + 1314);
			end
			if (((1310 + 1512) == (8598 - 5776)) and (v204 == (1 + 0))) then
				EpicSettings.SetupVersion("Restoration Shaman X v 10.2.00 By BoomK");
				break;
			end
		end
	end
	v20.SetAPL(523 - 259, v122, v123);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

