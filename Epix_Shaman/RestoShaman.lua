local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2144 - (561 + 677)) >= (7756 - 5527))) then
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
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.min;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v104;
	local v105 = 5169 + 5942;
	local v106 = 2080 + 9031;
	v9:RegisterForEvent(function()
		local v125 = 0 + 0;
		while true do
			if (((4344 - 3056) > (3245 - (109 + 1885))) and (v125 == (1469 - (1269 + 200)))) then
				v105 = 21296 - 10185;
				v106 = 11926 - (98 + 717);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v107 = v17.Shaman.Restoration;
	local v108 = v24.Shaman.Restoration;
	local v109 = v19.Shaman.Restoration;
	local v110 = {};
	local v111 = v21.Commons.Everyone;
	local v112 = v21.Commons.Shaman;
	local function v113()
		if (v107.ImprovedPurifySpirit:IsAvailable() or ((5339 - (802 + 24)) < (5779 - 2427))) then
			v111.DispellableDebuffs = v20.MergeTable(v111.DispellableMagicDebuffs, v111.DispellableCurseDebuffs);
		else
			v111.DispellableDebuffs = v111.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v114(v126)
		return v126:DebuffRefreshable(v107.FlameShockDebuff) and (v106 > (6 - 1));
	end
	local function v115()
		if ((v97 and v107.AstralShift:IsReady()) or ((305 + 1760) >= (2456 + 740))) then
			if ((v12:HealthPercentage() <= v98) or ((719 + 3657) <= (320 + 1161))) then
				if (v23(v107.AstralShift) or ((9436 - 6044) >= (15810 - 11069))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((1190 + 2135) >= (877 + 1277)) and v99 and v107.EarthElemental:IsReady()) then
			if ((v12:HealthPercentage() <= v100) or v111.IsTankBelowHealthPercentage(v101) or ((1069 + 226) >= (2351 + 882))) then
				if (((2044 + 2333) > (3075 - (797 + 636))) and v23(v107.EarthElemental)) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((22931 - 18208) > (2975 - (1427 + 192))) and v109.Healthstone:IsReady() and v34 and (v12:HealthPercentage() <= v35)) then
			if (v23(v108.Healthstone, nil, nil, true) or ((1434 + 2702) <= (7970 - 4537))) then
				return "healthstone defensive 3";
			end
		end
		if (((3816 + 429) <= (2099 + 2532)) and v36 and (v12:HealthPercentage() <= v37)) then
			if (((4602 - (192 + 134)) >= (5190 - (316 + 960))) and (v38 == "Refreshing Healing Potion")) then
				if (((111 + 87) <= (3369 + 996)) and v109.RefreshingHealingPotion:IsReady()) then
					if (((4421 + 361) > (17876 - 13200)) and v23(v108.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v116()
		if (((5415 - (83 + 468)) > (4003 - (1202 + 604))) and v39) then
			ShouldReturn = v111.HandleCharredTreant(v107.Riptide, v108.RiptideMouseover, 186 - 146);
			if (ShouldReturn or ((6157 - 2457) == (6941 - 4434))) then
				return ShouldReturn;
			end
			ShouldReturn = v111.HandleCharredTreant(v107.HealingSurge, v108.HealingSurgeMouseover, 365 - (45 + 280));
			if (((4319 + 155) >= (240 + 34)) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v111.HandleCharredTreant(v107.HealingWave, v108.HealingWaveMouseover, 15 + 25);
			if (ShouldReturn or ((1049 + 845) <= (248 + 1158))) then
				return ShouldReturn;
			end
		end
		if (((2910 - 1338) >= (3442 - (340 + 1571))) and v40) then
			ShouldReturn = v111.HandleCharredBrambles(v107.Riptide, v108.RiptideMouseover, 16 + 24);
			if (ShouldReturn or ((6459 - (1733 + 39)) < (12480 - 7938))) then
				return ShouldReturn;
			end
			ShouldReturn = v111.HandleCharredBrambles(v107.HealingSurge, v108.HealingSurgeMouseover, 1074 - (125 + 909));
			if (((5239 - (1096 + 852)) > (748 + 919)) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v111.HandleCharredBrambles(v107.HealingWave, v108.HealingWaveMouseover, 57 - 17);
			if (ShouldReturn or ((847 + 26) == (2546 - (409 + 103)))) then
				return ShouldReturn;
			end
		end
	end
	local function v117()
		ShouldReturn = v111.HandleTopTrinket(v110, v29, 276 - (46 + 190), nil);
		if (ShouldReturn or ((2911 - (51 + 44)) < (4 + 7))) then
			return ShouldReturn;
		end
		ShouldReturn = v111.HandleBottomTrinket(v110, v29, 1357 - (1114 + 203), nil);
		if (((4425 - (228 + 498)) < (1020 + 3686)) and ShouldReturn) then
			return ShouldReturn;
		end
		if (((1462 + 1184) >= (1539 - (174 + 489))) and v107.EarthShield:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(104 - 64) and (v111.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v107.EarthShield)) then
			if (((2519 - (830 + 1075)) <= (3708 - (303 + 221))) and v23(v108.EarthShieldFocus)) then
				return "earth_shield_tank healingst";
			end
		end
		if (((4395 - (231 + 1038)) == (2605 + 521)) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
			if ((v16:HealthPercentage() <= v48) or ((3349 - (171 + 991)) >= (20416 - 15462))) then
				if (v23(v108.RiptideFocus) or ((10410 - 6533) == (8921 - 5346))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((566 + 141) > (2215 - 1583)) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
			if (((v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == "TANK")) or ((1574 - 1028) >= (4325 - 1641))) then
				if (((4528 - 3063) <= (5549 - (111 + 1137))) and v23(v108.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1862 - (91 + 67)) > (4241 - 2816)) and v111.AreUnitsBelowHealthPercentage(v69, v70) and v107.SpiritLinkTotem:IsReady()) then
			if ((v68 == "Player") or ((172 + 515) == (4757 - (423 + 100)))) then
				if (v23(v108.SpiritLinkTotemPlayer) or ((24 + 3306) < (3956 - 2527))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((598 + 549) >= (1106 - (326 + 445))) and (v68 == "Friendly under Cursor")) then
				if (((14990 - 11555) > (4671 - 2574)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v108.SpiritLinkTotemCursor, not v14:IsInRange(93 - 53)) or ((4481 - (530 + 181)) >= (4922 - (614 + 267)))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v68 == "Confirmation") or ((3823 - (19 + 13)) <= (2621 - 1010))) then
				if (v23(v107.SpiritLinkTotem) or ((10668 - 6090) <= (5736 - 3728))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((293 + 832) <= (3650 - 1574)) and v71 and v111.AreUnitsBelowHealthPercentage(v72, v73) and v107.HealingTideTotem:IsReady()) then
			if (v23(v107.HealingTideTotem) or ((1540 - 797) >= (6211 - (1293 + 519)))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((2356 - 1201) < (4367 - 2694)) and v111.AreUnitsBelowHealthPercentage(v81, v82) and v107.AncestralProtectionTotem:IsReady()) then
			if ((v80 == "Player") or ((4443 - 2119) <= (2492 - 1914))) then
				if (((8874 - 5107) == (1996 + 1771)) and v23(v108.AncestralProtectionTotemPlayer)) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((835 + 3254) == (9500 - 5411)) and (v80 == "Friendly under Cursor")) then
				if (((1031 + 3427) >= (557 + 1117)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((608 + 364) <= (2514 - (709 + 387))) and v23(v108.AncestralProtectionTotemCursor, not v14:IsInRange(1898 - (673 + 1185)))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v80 == "Confirmation") or ((14320 - 9382) < (15291 - 10529))) then
				if (v23(v107.AncestralProtectionTotem) or ((4119 - 1615) > (3050 + 1214))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((1609 + 544) == (2906 - 753)) and v89 and v111.AreUnitsBelowHealthPercentage(v90, v91) and v107.AncestralGuidance:IsReady()) then
			if (v23(v107.AncestralGuidance) or ((125 + 382) >= (5165 - 2574))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((8796 - 4315) == (6361 - (446 + 1434))) and v92 and v111.AreUnitsBelowHealthPercentage(v93, v94) and v107.Ascendance:IsReady()) then
			if (v23(v107.Ascendance) or ((3611 - (1040 + 243)) < (2068 - 1375))) then
				return "ascendance cooldowns";
			end
		end
		if (((6175 - (559 + 1288)) == (6259 - (609 + 1322))) and v95 and (v12:Mana() <= v96) and v107.ManaTideTotem:IsReady()) then
			if (((2042 - (13 + 441)) >= (4977 - 3645)) and v23(v107.ManaTideTotem)) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (v33 or ((10933 - 6759) > (21156 - 16908))) then
			if (v107.AncestralCall:IsReady() or ((171 + 4415) <= (297 - 215))) then
				if (((1373 + 2490) == (1693 + 2170)) and v23(v107.AncestralCall)) then
					return "AncestralCall cooldowns";
				end
			end
			if (v107.BagofTricks:IsReady() or ((836 - 554) <= (23 + 19))) then
				if (((8476 - 3867) >= (507 + 259)) and v23(v107.BagofTricks)) then
					return "BagofTricks cooldowns";
				end
			end
			if (v107.Berserking:IsReady() or ((641 + 511) == (1788 + 700))) then
				if (((2874 + 548) > (3278 + 72)) and v23(v107.Berserking)) then
					return "Berserking cooldowns";
				end
			end
			if (((1310 - (153 + 280)) > (1085 - 709)) and v107.BloodFury:IsReady()) then
				if (v23(v107.BloodFury) or ((2800 + 318) <= (731 + 1120))) then
					return "BloodFury cooldowns";
				end
			end
			if (v107.Fireblood:IsReady() or ((87 + 78) >= (3169 + 323))) then
				if (((2862 + 1087) < (7393 - 2537)) and v23(v107.Fireblood)) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v118()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (670 - (89 + 578))) or ((3055 + 1221) < (6269 - 3253))) then
				if (((5739 - (572 + 477)) > (557 + 3568)) and v86 and v111.AreUnitsBelowHealthPercentage(v87, v88) and v107.Wellspring:IsReady()) then
					if (v23(v107.Wellspring, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((31 + 19) >= (107 + 789))) then
						return "wellspring healingaoe";
					end
				end
				if ((v59 and v111.AreUnitsBelowHealthPercentage(v60, v61) and v107.ChainHeal:IsReady()) or ((1800 - (84 + 2)) >= (4874 - 1916))) then
					if (v23(v108.ChainHealFocus, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((1075 + 416) < (1486 - (497 + 345)))) then
						return "chain_heal healingaoe";
					end
				end
				if (((19 + 685) < (167 + 820)) and v62 and v12:IsMoving() and v111.AreUnitsBelowHealthPercentage(v63, v64) and v107.SpiritwalkersGrace:IsReady()) then
					if (((5051 - (605 + 728)) > (1360 + 546)) and v23(v107.SpiritwalkersGrace)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				v127 = 8 - 4;
			end
			if ((v127 == (1 + 3)) or ((3541 - 2583) > (3277 + 358))) then
				if (((9699 - 6198) <= (3392 + 1100)) and v65 and v111.AreUnitsBelowHealthPercentage(v66, v67) and v107.HealingStreamTotem:IsReady()) then
					if (v23(v107.HealingStreamTotem) or ((3931 - (457 + 32)) < (1082 + 1466))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((4277 - (832 + 570)) >= (1380 + 84)) and (v127 == (1 + 1))) then
				if ((v111.AreUnitsBelowHealthPercentage(v75, v76) and v107.EarthenWallTotem:IsReady()) or ((16975 - 12178) >= (2357 + 2536))) then
					if ((v74 == "Player") or ((1347 - (588 + 208)) > (5573 - 3505))) then
						if (((3914 - (884 + 916)) > (1975 - 1031)) and v23(v108.EarthenWallTotemPlayer)) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v74 == "Friendly under Cursor") or ((1312 + 950) >= (3749 - (232 + 421)))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((4144 - (1569 + 320)) >= (868 + 2669))) then
							if (v23(v108.EarthenWallTotemCursor, not v14:IsInRange(8 + 32)) or ((12929 - 9092) < (1911 - (316 + 289)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((7722 - 4772) == (137 + 2813)) and (v74 == "Confirmation")) then
						if (v23(v107.EarthenWallTotem) or ((6176 - (666 + 787)) < (3723 - (360 + 65)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((1062 + 74) >= (408 - (79 + 175))) and v111.AreUnitsBelowHealthPercentage(v78, v79) and v107.Downpour:IsReady()) then
					if ((v77 == "Player") or ((427 - 156) > (3706 + 1042))) then
						if (((14529 - 9789) >= (6069 - 2917)) and v23(v108.DownpourPlayer, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v77 == "Friendly under Cursor") or ((3477 - (503 + 396)) >= (3571 - (92 + 89)))) then
						if (((79 - 38) <= (852 + 809)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((356 + 245) < (13941 - 10381)) and v23(v108.DownpourCursor, not v14:IsInRange(6 + 34), v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((535 - 300) < (600 + 87)) and (v77 == "Confirmation")) then
						if (((2173 + 2376) > (3511 - 2358)) and v23(v107.Downpour, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v83 and v111.AreUnitsBelowHealthPercentage(v84, v85) and v107.CloudburstTotem:IsReady()) or ((584 + 4090) < (7124 - 2452))) then
					if (((4912 - (485 + 759)) < (10553 - 5992)) and v23(v107.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				v127 = 1192 - (442 + 747);
			end
			if ((v127 == (1136 - (832 + 303))) or ((1401 - (88 + 858)) == (1099 + 2506))) then
				if ((v54 and v107.UnleashLife:IsReady()) or ((2204 + 459) == (137 + 3175))) then
					if (((5066 - (766 + 23)) <= (22091 - 17616)) and (v16:HealthPercentage() <= v55)) then
						if (v23(v107.UnleashLife) or ((1189 - 319) == (3132 - 1943))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((5270 - 3717) <= (4206 - (1036 + 37))) and (v56 == "Cursor") and v107.HealingRain:IsReady()) then
					if (v23(v108.HealingRainCursor, not v14:IsInRange(29 + 11), v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((4356 - 2119) >= (2762 + 749))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v111.AreUnitsBelowHealthPercentage(v57, v58) and v107.HealingRain:IsReady()) or ((2804 - (641 + 839)) > (3933 - (910 + 3)))) then
					if ((v56 == "Player") or ((7627 - 4635) == (3565 - (1466 + 218)))) then
						if (((1428 + 1678) > (2674 - (556 + 592))) and v23(v108.HealingRainPlayer, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((1075 + 1948) < (4678 - (329 + 479))) and (v56 == "Friendly under Cursor")) then
						if (((997 - (174 + 680)) > (253 - 179)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((37 - 19) < (1508 + 604)) and v23(v108.HealingRainCursor, not v14:IsInRange(779 - (396 + 343)), v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((98 + 999) <= (3105 - (29 + 1448))) and (v56 == "Enemy under Cursor")) then
						if (((6019 - (135 + 1254)) == (17442 - 12812)) and v15:Exists() and v12:CanAttack(v15)) then
							if (((16528 - 12988) > (1789 + 894)) and v23(v108.HealingRainCursor, not v14:IsInRange(1567 - (389 + 1138)), v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((5368 - (102 + 472)) >= (3091 + 184)) and (v56 == "Confirmation")) then
						if (((823 + 661) == (1384 + 100)) and v23(v107.HealingRain, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				v127 = 1547 - (320 + 1225);
			end
			if (((2548 - 1116) < (2176 + 1379)) and (v127 == (1464 - (157 + 1307)))) then
				if ((v107.EarthShield:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(1899 - (821 + 1038)) and (v111.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v107.EarthShield)) or ((2657 - 1592) > (392 + 3186))) then
					if (v23(v108.EarthShieldFocus) or ((8516 - 3721) < (524 + 883))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((4592 - 2739) < (5839 - (834 + 192))) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((v16:HealthPercentage() <= v48) or ((180 + 2641) < (624 + 1807))) then
						if (v23(v108.RiptideFocus) or ((62 + 2812) < (3378 - 1197))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) or ((2993 - (300 + 4)) <= (92 + 251))) then
					if (((v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == "TANK")) or ((4892 - 3023) == (2371 - (112 + 250)))) then
						if (v23(v108.RiptideFocus) or ((1414 + 2132) < (5816 - 3494))) then
							return "riptide healingaoe";
						end
					end
				end
				v127 = 1 + 0;
			end
		end
	end
	local function v119()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (1 + 0)) or ((1033 + 1049) == (3546 + 1227))) then
				if (((4658 - (1001 + 413)) > (2352 - 1297)) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
					if (((v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == "TANK")) or ((4195 - (244 + 638)) <= (2471 - (627 + 66)))) then
						if (v23(v108.RiptideFocus) or ((4233 - 2812) >= (2706 - (512 + 90)))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((3718 - (1665 + 241)) <= (3966 - (373 + 344))) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
					if (((733 + 890) <= (518 + 1439)) and ((v16:HealthPercentage() <= v48) or (v16:HealthPercentage() <= v48))) then
						if (((11637 - 7225) == (7465 - 3053)) and v23(v108.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v128 = 1101 - (35 + 1064);
			end
			if (((1274 + 476) >= (1801 - 959)) and (v128 == (0 + 0))) then
				if (((5608 - (298 + 938)) > (3109 - (233 + 1026))) and v107.EarthShield:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(1706 - (636 + 1030)) and (v111.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v107.EarthShield)) then
					if (((119 + 113) < (802 + 19)) and v23(v108.EarthShieldFocus)) then
						return "earth_shield_tank healingst";
					end
				end
				if (((154 + 364) < (61 + 841)) and v47 and v107.Riptide:IsReady() and v16:BuffDown(v107.Riptide)) then
					if (((3215 - (55 + 166)) > (167 + 691)) and (v16:HealthPercentage() <= v48)) then
						if (v23(v108.RiptideFocus) or ((378 + 3377) <= (3494 - 2579))) then
							return "riptide healingaoe";
						end
					end
				end
				v128 = 298 - (36 + 261);
			end
			if (((6900 - 2954) > (5111 - (34 + 1334))) and (v128 == (2 + 1))) then
				if ((v50 and v107.HealingWave:IsReady()) or ((1038 + 297) >= (4589 - (1035 + 248)))) then
					if (((4865 - (20 + 1)) > (1174 + 1079)) and (v16:HealthPercentage() <= v51)) then
						if (((771 - (134 + 185)) == (1585 - (549 + 584))) and v23(v108.HealingWaveFocus, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v128 == (687 - (314 + 371))) or ((15643 - 11086) < (3055 - (478 + 490)))) then
				if (((2053 + 1821) == (5046 - (786 + 386))) and v111.IsSoloMode()) then
					if ((v107.LightningShield:IsReady() and v12:BuffDown(v107.LightningShield)) or ((6277 - 4339) > (6314 - (1055 + 324)))) then
						if (v23(v107.LightningShield) or ((5595 - (1093 + 247)) < (3042 + 381))) then
							return "lightning_shield healingst";
						end
					end
				elseif (((153 + 1301) <= (9889 - 7398)) and v107.WaterShield:IsReady() and v12:BuffDown(v107.WaterShield)) then
					if (v23(v107.WaterShield) or ((14107 - 9950) <= (7975 - 5172))) then
						return "water_shield healingst";
					end
				end
				if (((12194 - 7341) >= (1061 + 1921)) and v52 and v107.HealingSurge:IsReady()) then
					if (((15925 - 11791) > (11570 - 8213)) and (v16:HealthPercentage() <= v53)) then
						if (v23(v108.HealingSurgeFocus, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((2577 + 840) < (6479 - 3945))) then
							return "healing_surge healingst";
						end
					end
				end
				v128 = 691 - (364 + 324);
			end
		end
	end
	local function v120()
		if (v107.FlameShock:IsReady() or ((7461 - 4739) <= (393 - 229))) then
			if (v111.CastCycle(v107.FlameShock, v12:GetEnemiesInRange(14 + 26), v114, not v14:IsSpellInRange(v107.FlameShock), nil, nil, nil, nil) or ((10075 - 7667) < (3377 - 1268))) then
				return "flame_shock_cycle damage";
			end
		end
		if (v107.LavaBurst:IsReady() or ((100 - 67) == (2723 - (1249 + 19)))) then
			if (v23(v107.LavaBurst, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((400 + 43) >= (15628 - 11613))) then
				return "lava_burst damage";
			end
		end
		if (((4468 - (686 + 400)) > (131 + 35)) and v107.Stormkeeper:IsReady()) then
			if (v23(v107.Stormkeeper) or ((509 - (73 + 156)) == (15 + 3044))) then
				return "stormkeeper damage";
			end
		end
		if (((2692 - (721 + 90)) > (15 + 1278)) and (#v12:GetEnemiesInRange(129 - 89) < (473 - (224 + 246)))) then
			if (((3818 - 1461) == (4339 - 1982)) and v107.LightningBolt:IsReady()) then
				if (((23 + 100) == (3 + 120)) and v23(v107.LightningBolt, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
					return "lightning_bolt damage";
				end
			end
		elseif (v107.ChainLightning:IsReady() or ((776 + 280) >= (6743 - 3351))) then
			if (v23(v107.ChainLightning, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((3597 - 2516) < (1588 - (203 + 310)))) then
				return "chain_lightning damage";
			end
		end
	end
	local function v121()
		local v129 = 1993 - (1238 + 755);
		while true do
			if ((v129 == (1 + 4)) or ((2583 - (709 + 825)) >= (8166 - 3734))) then
				v54 = EpicSettings.Settings['UseUnleashLife'];
				v55 = EpicSettings.Settings['UnleashLifeHP'];
				v56 = EpicSettings.Settings['HealingRainUsage'];
				v57 = EpicSettings.Settings['HealingRainHP'];
				v129 = 8 - 2;
			end
			if ((v129 == (865 - (196 + 668))) or ((18825 - 14057) <= (1752 - 906))) then
				v38 = EpicSettings.Settings['HealingPotionName'];
				v39 = EpicSettings.Settings['HandleCharredTreant'];
				v40 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['DispelDebuffs'];
				v129 = 835 - (171 + 662);
			end
			if (((102 - (4 + 89)) == v129) or ((11769 - 8411) <= (518 + 902))) then
				v70 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v71 = EpicSettings.Settings['UseHealingTideTotem'];
				v72 = EpicSettings.Settings['HealingTideTotemHP'];
				v73 = EpicSettings.Settings['HealingTideTotemGroup'];
				v129 = 43 - 33;
			end
			if ((v129 == (0 + 0)) or ((5225 - (35 + 1451)) <= (4458 - (28 + 1425)))) then
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionHP'];
				v129 = 1994 - (941 + 1052);
			end
			if ((v129 == (4 + 0)) or ((3173 - (822 + 692)) >= (3046 - 912))) then
				v50 = EpicSettings.Settings['UseHealingWave'];
				v51 = EpicSettings.Settings['HealingWaveHP'];
				v52 = EpicSettings.Settings['UseHealingSurge'];
				v53 = EpicSettings.Settings['HealingSurgeHP'];
				v129 = 3 + 2;
			end
			if (((300 - (45 + 252)) == v129) or ((3226 + 34) < (811 + 1544))) then
				v46 = EpicSettings.Settings['UseEarthShield'];
				v47 = EpicSettings.Settings['UseRiptide'];
				v48 = EpicSettings.Settings['RiptideHP'];
				v49 = EpicSettings.Settings['RiptideTankHP'];
				v129 = 9 - 5;
			end
			if ((v129 == (445 - (114 + 319))) or ((959 - 290) == (5410 - 1187))) then
				v82 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v83 = EpicSettings.Settings['UseCloudburstTotem'];
				break;
			end
			if ((v129 == (2 + 0)) or ((2520 - 828) < (1231 - 643))) then
				v42 = EpicSettings.Settings['DispelBuffs'];
				v43 = EpicSettings.Settings['InterruptWithStun'];
				v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v45 = EpicSettings.Settings['InterruptThreshold'];
				v129 = 1966 - (556 + 1407);
			end
			if ((v129 == (1216 - (741 + 465))) or ((5262 - (170 + 295)) < (1924 + 1727))) then
				v74 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v75 = EpicSettings.Settings['EarthenWallTotemHP'];
				v76 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v77 = EpicSettings.Settings['DownpourUsage'];
				v129 = 11 + 0;
			end
			if ((v129 == (17 - 10)) or ((3463 + 714) > (3111 + 1739))) then
				v62 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v63 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v64 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v65 = EpicSettings.Settings['UseHealingStreamTotem'];
				v129 = 5 + 3;
			end
			if ((v129 == (1238 - (957 + 273))) or ((107 + 293) > (445 + 666))) then
				v66 = EpicSettings.Settings['HealingStreamTotemHP'];
				v67 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v68 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v69 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v129 = 34 - 25;
			end
			if (((8039 - 4988) > (3069 - 2064)) and (v129 == (54 - 43))) then
				v78 = EpicSettings.Settings['DownpourHP'];
				v79 = EpicSettings.Settings['DownpourGroup'];
				v80 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v81 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v129 = 1792 - (389 + 1391);
			end
			if (((2317 + 1376) <= (457 + 3925)) and (v129 == (13 - 7))) then
				v58 = EpicSettings.Settings['HealingRainGroup'];
				v59 = EpicSettings.Settings['UseChainHeal'];
				v60 = EpicSettings.Settings['ChainHealHP'];
				v61 = EpicSettings.Settings['ChainHealGroup'];
				v129 = 958 - (783 + 168);
			end
		end
	end
	local function v122()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (3 + 0)) or ((3593 - (309 + 2)) > (12590 - 8490))) then
				v93 = EpicSettings.Settings['AscendanceHP'];
				v94 = EpicSettings.Settings['AscendanceGroup'];
				v95 = EpicSettings.Settings['UseManaTideTotem'];
				v130 = 1216 - (1090 + 122);
			end
			if ((v130 == (0 + 0)) or ((12023 - 8443) < (1947 + 897))) then
				v84 = EpicSettings.Settings['CloudburstTotemHP'];
				v85 = EpicSettings.Settings['CloudburstTotemGroup'];
				v86 = EpicSettings.Settings['UseWellspring'];
				v130 = 1119 - (628 + 490);
			end
			if (((16 + 73) < (11116 - 6626)) and (v130 == (4 - 3))) then
				v87 = EpicSettings.Settings['WellspringHP'];
				v88 = EpicSettings.Settings['WellspringGroup'];
				v89 = EpicSettings.Settings['UseAncestralGuidance'];
				v130 = 776 - (431 + 343);
			end
			if ((v130 == (10 - 5)) or ((14415 - 9432) < (1429 + 379))) then
				v99 = EpicSettings.Settings['UseEarthElemental'];
				v100 = EpicSettings.Settings['EarthElementalHP'];
				v101 = EpicSettings.Settings['EarthElementalTankHP'];
				v130 = 1 + 5;
			end
			if (((5524 - (556 + 1139)) > (3784 - (6 + 9))) and (v130 == (1 + 3))) then
				v96 = EpicSettings.Settings['ManaTideTotemMana'];
				v97 = EpicSettings.Settings['UseAstralShift'];
				v98 = EpicSettings.Settings['AstralShiftHP'];
				v130 = 3 + 2;
			end
			if (((1654 - (28 + 141)) <= (1125 + 1779)) and (v130 == (7 - 1))) then
				v33 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['PrimordialWaveSaveCooldowns'];
				v103 = EpicSettings.Settings['PrimordialWaveUsage'];
				v130 = 5 + 2;
			end
			if (((5586 - (486 + 831)) == (11108 - 6839)) and (v130 == (6 - 4))) then
				v90 = EpicSettings.Settings['AncestralGuidanceHP'];
				v91 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v92 = EpicSettings.Settings['UseAscendance'];
				v130 = 1 + 2;
			end
			if (((1223 - 836) <= (4045 - (668 + 595))) and ((7 + 0) == v130)) then
				v104 = EpicSettings.Settings['PrimordialWaveHP'];
				break;
			end
		end
	end
	local function v123()
		local v131 = 0 + 0;
		local v132;
		while true do
			if ((v131 == (0 - 0)) or ((2189 - (23 + 267)) <= (2861 - (1129 + 815)))) then
				v121();
				v122();
				v28 = EpicSettings.Toggles['ooc'];
				v131 = 388 - (371 + 16);
			end
			if ((v131 == (1753 - (1326 + 424))) or ((8166 - 3854) <= (3201 - 2325))) then
				v132 = nil;
				if (((2350 - (88 + 30)) <= (3367 - (720 + 51))) and not v12:AffectingCombat() and v28) then
					if (((4660 - 2565) < (5462 - (421 + 1355))) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v12:CanAttack(v14)) then
						local v219 = v111.DeadFriendlyUnitsCount();
						if (v12:AffectingCombat() or ((2631 - 1036) >= (2198 + 2276))) then
							if ((v219 > (1084 - (286 + 797))) or ((16885 - 12266) < (4773 - 1891))) then
								if (v23(v107.AncestralVision, nil, v12:BuffDown(v107.SpiritwalkersGraceBuff)) or ((733 - (397 + 42)) >= (1509 + 3322))) then
									return "ancestral_vision";
								end
							elseif (((2829 - (24 + 776)) <= (4750 - 1666)) and v23(v107.AncestralSpirit, not v14:IsInRange(825 - (222 + 563)), v12:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return "ancestral_spirit";
							end
						end
					end
				end
				if ((v12:AffectingCombat() and v111.TargetIsValid()) or ((4487 - 2450) == (1743 + 677))) then
					local v214 = 190 - (23 + 167);
					local v215;
					while true do
						if (((6256 - (690 + 1108)) > (1409 + 2495)) and (v214 == (0 + 0))) then
							v105 = v9.BossFightRemains(nil, true);
							v106 = v105;
							if (((1284 - (40 + 808)) >= (21 + 102)) and (v106 == (42488 - 31377))) then
								v106 = v9.FightRemains(Enemies10ySplash, false);
							end
							v215 = v111.Interrupt(v107.WindShear, 29 + 1, true);
							v214 = 1 + 0;
						end
						if (((275 + 225) < (2387 - (47 + 524))) and (v214 == (2 + 0))) then
							if (((9769 - 6195) == (5343 - 1769)) and v215) then
								return v215;
							end
							v132 = v115();
							if (((503 - 282) < (2116 - (1165 + 561))) and v132) then
								return v132;
							end
							v132 = v117();
							v214 = 1 + 2;
						end
						if (((9 - 6) == v214) or ((845 + 1368) <= (1900 - (341 + 138)))) then
							if (((826 + 2232) < (10029 - 5169)) and v132) then
								return v132;
							end
							if (not v102 or v29 or ((1622 - (89 + 237)) >= (14302 - 9856))) then
								if ((v103 == "Both") or (v103 == "Defensive") or ((2932 - 1539) > (5370 - (581 + 300)))) then
									if ((v16:HealthPercentage() < v104) or ((5644 - (855 + 365)) < (64 - 37))) then
										if (v107.PrimordialWave:IsReady() or ((653 + 1344) > (5050 - (1030 + 205)))) then
											if (((3253 + 212) > (1780 + 133)) and v23(v108.PrimordialWaveFocus)) then
												return "primordial_wave main";
											end
										end
									end
								end
								if (((1019 - (156 + 130)) < (4132 - 2313)) and ((v103 == "Both") or (v103 == "Offensive"))) then
									if ((v14:DebuffRefreshable(v107.FlameShock) and (v106 > (16 - 6))) or ((9001 - 4606) == (1253 + 3502))) then
										if (v107.PrimordialWave:IsReady() or ((2212 + 1581) < (2438 - (10 + 59)))) then
											if (v23(v107.PrimordialWave) or ((1156 + 2928) == (1305 - 1040))) then
												return "primordial_wave main";
											end
										end
									end
								end
							end
							break;
						end
						if (((5521 - (671 + 492)) == (3470 + 888)) and ((1216 - (369 + 846)) == v214)) then
							if (v215 or ((831 + 2307) < (848 + 145))) then
								return v215;
							end
							v215 = v111.InterruptCursor(v107.WindShear, v108.WindShearMouseover, 1975 - (1036 + 909), true, v15);
							if (((2648 + 682) > (3899 - 1576)) and v215) then
								return v215;
							end
							v215 = v111.InterruptWithStunCursor(v107.CapacitorTotem, v108.CapacitorTotemCursor, 233 - (11 + 192), nil, v15);
							v214 = 2 + 0;
						end
					end
				end
				v131 = 179 - (135 + 40);
			end
			if ((v131 == (2 - 1)) or ((2186 + 1440) == (8787 - 4798))) then
				v29 = EpicSettings.Toggles['cds'];
				v30 = EpicSettings.Toggles['dispel'];
				v31 = EpicSettings.Toggles['healing'];
				v131 = 2 - 0;
			end
			if ((v131 == (178 - (50 + 126))) or ((2550 - 1634) == (592 + 2079))) then
				v32 = EpicSettings.Toggles['dps'];
				if (((1685 - (1233 + 180)) == (1241 - (522 + 447))) and v12:IsDeadOrGhost()) then
					return;
				end
				if (((5670 - (107 + 1314)) <= (2246 + 2593)) and (v12:AffectingCombat() or v28)) then
					local v216 = 0 - 0;
					local v217;
					while true do
						if (((1180 + 1597) < (6354 - 3154)) and ((0 - 0) == v216)) then
							v217 = v41 and v107.PurifySpirit:IsReady() and v30;
							if (((2005 - (716 + 1194)) < (34 + 1923)) and v107.EarthShield:IsReady() and v46) then
								local v220 = 0 + 0;
								while true do
									if (((1329 - (74 + 429)) < (3311 - 1594)) and (v220 == (0 + 0))) then
										ShouldReturn = v111.FocusUnitRefreshableBuff(v107.EarthShield, 34 - 19, 29 + 11, "TANK");
										if (((4395 - 2969) >= (2732 - 1627)) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							v216 = 434 - (279 + 154);
						end
						if (((3532 - (454 + 324)) <= (2659 + 720)) and ((18 - (12 + 5)) == v216)) then
							if (not v16:BuffRefreshable(v107.EarthShield) or (v111.UnitGroupRole(v16) ~= "TANK") or not v46 or ((2118 + 1809) == (3599 - 2186))) then
								local v221 = 0 + 0;
								while true do
									if ((v221 == (1093 - (277 + 816))) or ((4931 - 3777) <= (1971 - (1058 + 125)))) then
										ShouldReturn = v111.FocusUnit(v217, nil, nil, nil);
										if (ShouldReturn or ((309 + 1334) > (4354 - (815 + 160)))) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v131 = 12 - 9;
			end
			if ((v131 == (9 - 5)) or ((669 + 2134) > (13297 - 8748))) then
				if (v28 or v12:AffectingCombat() or ((2118 - (41 + 1857)) >= (4915 - (1222 + 671)))) then
					local v218 = 0 - 0;
					while true do
						if (((4055 - 1233) == (4004 - (229 + 953))) and (v218 == (1776 - (1111 + 663)))) then
							if (v32 or ((2640 - (874 + 705)) == (260 + 1597))) then
								if (((1884 + 876) > (2834 - 1470)) and v111.TargetIsValid()) then
									local v223 = 0 + 0;
									while true do
										if ((v223 == (679 - (642 + 37))) or ((1118 + 3784) <= (576 + 3019))) then
											v132 = v120();
											if (v132 or ((9671 - 5819) == (747 - (233 + 221)))) then
												return v132;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((v218 == (2 - 1)) or ((1373 + 186) == (6129 - (718 + 823)))) then
							if (v132 or ((2822 + 1662) == (1593 - (266 + 539)))) then
								return v132;
							end
							if (((12932 - 8364) >= (5132 - (636 + 589))) and v31) then
								local v222 = 0 - 0;
								while true do
									if (((2569 - 1323) < (2750 + 720)) and (v222 == (0 + 0))) then
										v132 = v118();
										if (((5083 - (657 + 358)) >= (2573 - 1601)) and v132) then
											return v132;
										end
										v222 = 2 - 1;
									end
									if (((1680 - (1151 + 36)) < (3760 + 133)) and (v222 == (1 + 0))) then
										v132 = v119();
										if (v132 or ((4398 - 2925) >= (5164 - (1552 + 280)))) then
											return v132;
										end
										break;
									end
								end
							end
							v218 = 836 - (64 + 770);
						end
						if (((0 + 0) == v218) or ((9195 - 5144) <= (206 + 951))) then
							if (((1847 - (157 + 1086)) < (5766 - 2885)) and v30) then
								if ((v16 and v41) or ((3941 - 3041) == (5180 - 1803))) then
									if (((6085 - 1626) > (1410 - (599 + 220))) and v107.PurifySpirit:IsReady() and v111.DispellableFriendlyUnit()) then
										if (((6766 - 3368) >= (4326 - (1813 + 118))) and v23(v108.PurifySpirit)) then
											return "purify_spirit dispel";
										end
									end
								end
								if (v42 or ((1596 + 587) >= (4041 - (841 + 376)))) then
									if (((2712 - 776) == (450 + 1486)) and v107.Purge:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v111.UnitHasMagicBuff(v14)) then
										if (v23(v107.Purge, not v14:IsSpellInRange(v107.Purge)) or ((13188 - 8356) < (5172 - (464 + 395)))) then
											return "purge dispel";
										end
									end
								end
							end
							v132 = v116();
							v218 = 2 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v133 = 0 + 0;
		while true do
			if (((4925 - (467 + 370)) > (8005 - 4131)) and (v133 == (0 + 0))) then
				v113();
				v21.Print("Restoration Shaman rotation by Epic.");
				v133 = 3 - 2;
			end
			if (((676 + 3656) == (10078 - 5746)) and (v133 == (521 - (150 + 370)))) then
				EpicSettings.SetupVersion("Restoration Shaman X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v21.SetAPL(1546 - (74 + 1208), v123, v124);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

