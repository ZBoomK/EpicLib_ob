local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1964 - (991 + 564)) >= (2501 + 1323))) then
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
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111 = 12670 - (1381 + 178);
	local v112 = 10422 + 689;
	local v113;
	v9:RegisterForEvent(function()
		local v132 = 0 + 0;
		while true do
			if (((891 + 1196) == (7194 - 5107)) and (v132 == (0 + 0))) then
				v111 = 11581 - (381 + 89);
				v112 = 9854 + 1257;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v114 = v17.Shaman.Restoration;
	local v115 = v24.Shaman.Restoration;
	local v116 = v19.Shaman.Restoration;
	local v117 = {};
	local v118 = v21.Commons.Everyone;
	local v119 = v21.Commons.Shaman;
	local function v120()
		if (v114.ImprovedPurifySpirit:IsAvailable() or ((2303 + 1101) > (7713 - 3210))) then
			v118.DispellableDebuffs = v20.MergeTable(v118.DispellableMagicDebuffs, v118.DispellableCurseDebuffs);
		else
			v118.DispellableDebuffs = v118.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v120();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v121(v133)
		return v133:DebuffRefreshable(v114.FlameShockDebuff) and (v112 > (1161 - (1074 + 82)));
	end
	local function v122()
		if ((v87 and v114.AstralShift:IsReady()) or ((7683 - 4177) <= (3093 - (214 + 1570)))) then
			if (((4410 - (990 + 465)) == (1219 + 1736)) and (v12:HealthPercentage() <= v53)) then
				if (v23(v114.AstralShift, not v14:IsInRange(18 + 22)) or ((2824 + 79) == (5883 - 4388))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((6272 - (1668 + 58)) >= (2901 - (512 + 114))) and v90 and v114.EarthElemental:IsReady()) then
			if (((2135 - 1316) >= (45 - 23)) and ((v12:HealthPercentage() <= v61) or v118.IsTankBelowHealthPercentage(v62))) then
				if (((11002 - 7840) == (1471 + 1691)) and v23(v114.EarthElemental, not v14:IsInRange(8 + 32))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v116.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((2060 + 309) > (14938 - 10509))) then
			if (((6089 - (109 + 1885)) >= (4652 - (1269 + 200))) and v23(v115.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v37 and (v12:HealthPercentage() <= v38)) or ((7112 - 3401) < (1823 - (98 + 717)))) then
			local v225 = 826 - (802 + 24);
			while true do
				if ((v225 == (0 - 0)) or ((1324 - 275) <= (134 + 772))) then
					if (((3468 + 1045) > (448 + 2278)) and (v39 == "Refreshing Healing Potion")) then
						if (v116.RefreshingHealingPotion:IsReady() or ((320 + 1161) >= (7394 - 4736))) then
							if (v23(v115.RefreshingHealingPotion) or ((10737 - 7517) == (488 + 876))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((430 + 624) > (2798 + 594))) then
						if (v116.DreamwalkersHealingPotion:IsReady() or ((492 + 184) >= (767 + 875))) then
							if (((5569 - (797 + 636)) > (11638 - 9241)) and v23(v115.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		if (v40 or ((5953 - (1427 + 192)) == (1471 + 2774))) then
			v28 = v118.HandleCharredTreant(v114.Riptide, v115.RiptideMouseover, 92 - 52);
			if (v28 or ((3844 + 432) <= (1374 + 1657))) then
				return v28;
			end
			v28 = v118.HandleCharredTreant(v114.HealingSurge, v115.HealingSurgeMouseover, 366 - (192 + 134));
			if (v28 or ((6058 - (316 + 960)) <= (668 + 531))) then
				return v28;
			end
			v28 = v118.HandleCharredTreant(v114.HealingWave, v115.HealingWaveMouseover, 31 + 9);
			if (v28 or ((4496 + 368) < (7271 - 5369))) then
				return v28;
			end
		end
		if (((5390 - (83 + 468)) >= (5506 - (1202 + 604))) and v41) then
			v28 = v118.HandleCharredBrambles(v114.Riptide, v115.RiptideMouseover, 186 - 146);
			if (v28 or ((1788 - 713) > (5310 - 3392))) then
				return v28;
			end
			v28 = v118.HandleCharredBrambles(v114.HealingSurge, v115.HealingSurgeMouseover, 365 - (45 + 280));
			if (((383 + 13) <= (3324 + 480)) and v28) then
				return v28;
			end
			v28 = v118.HandleCharredBrambles(v114.HealingWave, v115.HealingWaveMouseover, 15 + 25);
			if (v28 or ((2307 + 1862) == (385 + 1802))) then
				return v28;
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		while true do
			if (((3317 - (340 + 1571)) == (555 + 851)) and (v134 == (1775 - (1733 + 39)))) then
				if (((4206 - 2675) < (5305 - (125 + 909))) and v85 and v118.AreUnitsBelowHealthPercentage(v47, v46) and v114.AncestralGuidance:IsReady()) then
					if (((2583 - (1096 + 852)) == (285 + 350)) and v23(v114.AncestralGuidance, not v14:IsInRange(57 - 17))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((3272 + 101) <= (4068 - (409 + 103))) and v86 and v118.AreUnitsBelowHealthPercentage(v52, v51) and v114.Ascendance:IsReady()) then
					if (v23(v114.Ascendance, not v14:IsInRange(276 - (46 + 190))) or ((3386 - (51 + 44)) < (926 + 2354))) then
						return "ascendance cooldowns";
					end
				end
				v134 = 1321 - (1114 + 203);
			end
			if (((5112 - (228 + 498)) >= (190 + 683)) and (v134 == (3 + 1))) then
				if (((1584 - (174 + 489)) <= (2870 - 1768)) and v96 and (v12:Mana() <= v75) and v114.ManaTideTotem:IsReady()) then
					if (((6611 - (830 + 1075)) >= (1487 - (303 + 221))) and v23(v114.ManaTideTotem, not v14:IsInRange(1309 - (231 + 1038)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v34 and ((v103 and v30) or not v103)) or ((800 + 160) <= (2038 - (171 + 991)))) then
					if (v114.AncestralCall:IsReady() or ((8514 - 6448) == (2502 - 1570))) then
						if (((12040 - 7215) < (3877 + 966)) and v23(v114.AncestralCall, not v14:IsInRange(140 - 100))) then
							return "AncestralCall cooldowns";
						end
					end
					if (v114.BagofTricks:IsReady() or ((11184 - 7307) >= (7312 - 2775))) then
						if (v23(v114.BagofTricks, not v14:IsInRange(123 - 83)) or ((5563 - (111 + 1137)) < (1884 - (91 + 67)))) then
							return "BagofTricks cooldowns";
						end
					end
					if (v114.Berserking:IsReady() or ((10949 - 7270) < (156 + 469))) then
						if (v23(v114.Berserking, not v14:IsInRange(563 - (423 + 100))) or ((33 + 4592) < (1749 - 1117))) then
							return "Berserking cooldowns";
						end
					end
					if (v114.BloodFury:IsReady() or ((44 + 39) > (2551 - (326 + 445)))) then
						if (((2382 - 1836) <= (2399 - 1322)) and v23(v114.BloodFury, not v14:IsInRange(93 - 53))) then
							return "BloodFury cooldowns";
						end
					end
					if (v114.Fireblood:IsReady() or ((1707 - (530 + 181)) > (5182 - (614 + 267)))) then
						if (((4102 - (19 + 13)) > (1118 - 431)) and v23(v114.Fireblood, not v14:IsInRange(93 - 53))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if ((v134 == (2 - 1)) or ((171 + 485) >= (5856 - 2526))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((5167 - 2675) <= (2147 - (1293 + 519)))) then
					if (((8817 - 4495) >= (6689 - 4127)) and (v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((6954 - 3317) >= (16256 - 12486))) then
							return "riptide healingcd";
						end
					end
				end
				if ((v118.AreUnitsBelowHealthPercentage(v80, v79) and v114.SpiritLinkTotem:IsReady()) or ((5604 - 3225) > (2425 + 2153))) then
					if ((v81 == "Player") or ((99 + 384) > (1725 - 982))) then
						if (((568 + 1886) > (193 + 385)) and v23(v115.SpiritLinkTotemPlayer, not v14:IsInRange(25 + 15))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((2026 - (709 + 387)) < (6316 - (673 + 1185))) and (v81 == "Friendly under Cursor")) then
						if (((1919 - 1257) <= (3120 - 2148)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((7190 - 2820) == (3126 + 1244)) and v23(v115.SpiritLinkTotemCursor, not v14:IsInRange(30 + 10))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v81 == "Confirmation") or ((6428 - 1666) <= (212 + 649))) then
						if (v23(v114.SpiritLinkTotem, not v14:IsInRange(79 - 39)) or ((2771 - 1359) == (6144 - (446 + 1434)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v134 = 1285 - (1040 + 243);
			end
			if ((v134 == (0 - 0)) or ((5015 - (559 + 1288)) < (4084 - (609 + 1322)))) then
				if ((v105 and ((v30 and v104) or not v104)) or ((5430 - (13 + 441)) < (4977 - 3645))) then
					local v233 = 0 - 0;
					while true do
						if (((23049 - 18421) == (173 + 4455)) and (v233 == (0 - 0))) then
							v28 = v118.HandleTopTrinket(v117, v30, 15 + 25, nil);
							if (v28 or ((24 + 30) == (1172 - 777))) then
								return v28;
							end
							v233 = 1 + 0;
						end
						if (((150 - 68) == (55 + 27)) and ((1 + 0) == v233)) then
							v28 = v118.HandleBottomTrinket(v117, v30, 29 + 11, nil);
							if (v28 or ((488 + 93) < (276 + 6))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((5042 - (153 + 280)) < (7204 - 4709))) then
					if (((1035 + 117) == (455 + 697)) and (v16:HealthPercentage() <= v77)) then
						if (((993 + 903) <= (3106 + 316)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v134 = 1 + 0;
			end
			if ((v134 == (2 - 0)) or ((612 + 378) > (2287 - (89 + 578)))) then
				if ((v94 and v118.AreUnitsBelowHealthPercentage(v73, v72) and v114.HealingTideTotem:IsReady()) or ((627 + 250) > (9760 - 5065))) then
					if (((3740 - (572 + 477)) >= (250 + 1601)) and v23(v114.HealingTideTotem, not v14:IsInRange(25 + 15))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v118.AreUnitsBelowHealthPercentage(v49, v48) and v114.AncestralProtectionTotem:IsReady()) or ((357 + 2628) >= (4942 - (84 + 2)))) then
					if (((7046 - 2770) >= (861 + 334)) and (v50 == "Player")) then
						if (((4074 - (497 + 345)) <= (120 + 4570)) and v23(v115.AncestralProtectionTotemPlayer, not v14:IsInRange(7 + 33))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v50 == "Friendly under Cursor") or ((2229 - (605 + 728)) >= (2245 + 901))) then
						if (((6805 - 3744) >= (136 + 2822)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((11783 - 8596) >= (581 + 63)) and v23(v115.AncestralProtectionTotemCursor, not v14:IsInRange(110 - 70))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((487 + 157) <= (1193 - (457 + 32))) and (v50 == "Confirmation")) then
						if (((407 + 551) > (2349 - (832 + 570))) and v23(v114.AncestralProtectionTotem, not v14:IsInRange(38 + 2))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v134 = 1 + 2;
			end
		end
	end
	local function v125()
		if (((15896 - 11404) >= (1279 + 1375)) and v88 and v118.AreUnitsBelowHealthPercentage(891 - (588 + 208), 8 - 5) and v114.ChainHeal:IsReady() and v12:BuffUp(v114.HighTide)) then
			if (((5242 - (884 + 916)) >= (3146 - 1643)) and v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v95 and (v16:HealthPercentage() <= v74) and v114.HealingWave:IsReady() and (v114.PrimordialWave:TimeSinceLastCast() < (9 + 6))) or ((3823 - (232 + 421)) <= (3353 - (1569 + 320)))) then
			if (v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((1177 + 3620) == (834 + 3554))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if (((1856 - 1305) <= (1286 - (316 + 289))) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
			if (((8578 - 5301) > (19 + 388)) and (v16:HealthPercentage() <= v77)) then
				if (((6148 - (666 + 787)) >= (1840 - (360 + 65))) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((3002 + 210) <= (1198 - (79 + 175)))) then
			if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((4881 - 1785) <= (1404 + 394))) then
				if (((10841 - 7304) == (6811 - 3274)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((4736 - (503 + 396)) >= (1751 - (92 + 89))) and v99 and v114.UnleashLife:IsReady()) then
			if ((v16:HealthPercentage() <= v84) or ((5722 - 2772) == (1955 + 1857))) then
				if (((2796 + 1927) >= (9077 - 6759)) and v23(v114.UnleashLife, not v16:IsSpellInRange(v114.UnleashLife))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v68 == "Cursor") and v114.HealingRain:IsReady()) or ((278 + 1749) > (6502 - 3650))) then
			if (v23(v115.HealingRainCursor, not v14:IsInRange(35 + 5), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((543 + 593) > (13148 - 8831))) then
				return "healing_rain healingaoe";
			end
		end
		if (((593 + 4155) == (7240 - 2492)) and v118.AreUnitsBelowHealthPercentage(v67, v66) and v114.HealingRain:IsReady()) then
			if (((4980 - (485 + 759)) <= (10967 - 6227)) and (v68 == "Player")) then
				if (v23(v115.HealingRainPlayer, not v14:IsInRange(1229 - (442 + 747)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((4525 - (832 + 303)) <= (4006 - (88 + 858)))) then
					return "healing_rain healingaoe";
				end
			elseif ((v68 == "Friendly under Cursor") or ((305 + 694) > (2229 + 464))) then
				if (((20 + 443) < (1390 - (766 + 23))) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v115.HealingRainCursor, not v14:IsInRange(197 - 157), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2984 - 801) < (1809 - 1122))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((15439 - 10890) == (5622 - (1036 + 37))) and (v68 == "Enemy under Cursor")) then
				if (((3313 + 1359) == (9097 - 4425)) and v15:Exists() and v12:CanAttack(v15)) then
					if (v23(v115.HealingRainCursor, not v14:IsInRange(32 + 8), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((5148 - (641 + 839)) < (1308 - (910 + 3)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v68 == "Confirmation") or ((10620 - 6454) == (2139 - (1466 + 218)))) then
				if (v23(v114.HealingRain, not v14:IsInRange(19 + 21), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((5597 - (556 + 592)) == (947 + 1716))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v118.AreUnitsBelowHealthPercentage(v64, v63) and v114.EarthenWallTotem:IsReady()) or ((5085 - (329 + 479)) < (3843 - (174 + 680)))) then
			if ((v65 == "Player") or ((2989 - 2119) >= (8599 - 4450))) then
				if (((1580 + 632) < (3922 - (396 + 343))) and v23(v115.EarthenWallTotemPlayer, not v14:IsInRange(4 + 36))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((6123 - (29 + 1448)) > (4381 - (135 + 1254))) and (v65 == "Friendly under Cursor")) then
				if (((5401 - 3967) < (14502 - 11396)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((524 + 262) < (4550 - (389 + 1138))) and v23(v115.EarthenWallTotemCursor, not v14:IsInRange(614 - (102 + 472)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v65 == "Confirmation") or ((2305 + 137) < (42 + 32))) then
				if (((4229 + 306) == (6080 - (320 + 1225))) and v23(v114.EarthenWallTotem, not v14:IsInRange(71 - 31))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v118.AreUnitsBelowHealthPercentage(v59, v58) and v114.Downpour:IsReady()) or ((1842 + 1167) <= (3569 - (157 + 1307)))) then
			if (((3689 - (821 + 1038)) < (9153 - 5484)) and (v60 == "Player")) then
				if (v23(v115.DownpourPlayer, not v14:IsInRange(5 + 35), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2540 - 1110) >= (1344 + 2268))) then
					return "downpour healingaoe";
				end
			elseif (((6649 - 3966) >= (3486 - (834 + 192))) and (v60 == "Friendly under Cursor")) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((115 + 1689) >= (841 + 2434))) then
					if (v23(v115.DownpourCursor, not v14:IsInRange(1 + 39), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2194 - 777) > (3933 - (300 + 4)))) then
						return "downpour healingaoe";
					end
				end
			elseif (((1281 + 3514) > (1052 - 650)) and (v60 == "Confirmation")) then
				if (((5175 - (112 + 250)) > (1422 + 2143)) and v23(v114.Downpour, not v14:IsInRange(100 - 60), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((2242 + 1670) == (2024 + 1888)) and v89 and v118.AreUnitsBelowHealthPercentage(v57, v56) and v114.CloudburstTotem:IsReady()) then
			if (((2110 + 711) <= (2392 + 2432)) and v23(v114.CloudburstTotem)) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((1292 + 446) <= (3609 - (1001 + 413))) and v100 and v118.AreUnitsBelowHealthPercentage(v102, v101) and v114.Wellspring:IsReady()) then
			if (((91 - 50) <= (3900 - (244 + 638))) and v23(v114.Wellspring, not v14:IsInRange(733 - (627 + 66)), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if (((6391 - 4246) <= (4706 - (512 + 90))) and v88 and v118.AreUnitsBelowHealthPercentage(v55, v54) and v114.ChainHeal:IsReady()) then
			if (((4595 - (1665 + 241)) < (5562 - (373 + 344))) and v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v98 and v12:IsMoving() and v118.AreUnitsBelowHealthPercentage(v83, v82) and v114.SpiritwalkersGrace:IsReady()) or ((1048 + 1274) > (694 + 1928))) then
			if (v23(v114.SpiritwalkersGrace, nil) or ((11959 - 7425) == (3522 - 1440))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v92 and v118.AreUnitsBelowHealthPercentage(v70, v69) and v114.HealingStreamTotem:IsReady()) or ((2670 - (35 + 1064)) > (1359 + 508))) then
			if (v23(v114.HealingStreamTotem, nil) or ((5677 - 3023) >= (12 + 2984))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v126()
		if (((5214 - (298 + 938)) > (3363 - (233 + 1026))) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
			if (((4661 - (636 + 1030)) > (788 + 753)) and (v16:HealthPercentage() <= v77)) then
				if (((3174 + 75) > (284 + 669)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((222 + 3051) > (4794 - (55 + 166)))) then
			if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((611 + 2540) < (130 + 1154))) then
				if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((7065 - 5215) == (1826 - (36 + 261)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1435 - 614) < (3491 - (34 + 1334))) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
			if (((347 + 555) < (1807 + 518)) and ((v16:HealthPercentage() <= v77) or (v16:HealthPercentage() <= v77))) then
				if (((2141 - (1035 + 248)) <= (2983 - (20 + 1))) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v114.ElementalOrbit:IsAvailable() and v12:BuffDown(v114.EarthShieldBuff)) or ((2056 + 1890) < (1607 - (134 + 185)))) then
			if (v23(v114.EarthShield) or ((4375 - (549 + 584)) == (1252 - (314 + 371)))) then
				return "earth_shield healingst";
			end
		end
		if ((v114.ElementalOrbit:IsAvailable() and v12:BuffUp(v114.EarthShieldBuff)) or ((2907 - 2060) >= (2231 - (478 + 490)))) then
			if (v118.IsSoloMode() or ((1194 + 1059) == (3023 - (786 + 386)))) then
				if ((v114.LightningShield:IsReady() and v12:BuffDown(v114.LightningShield)) or ((6759 - 4672) > (3751 - (1055 + 324)))) then
					if (v23(v114.LightningShield) or ((5785 - (1093 + 247)) < (3687 + 462))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v114.WaterShield:IsReady() and v12:BuffDown(v114.WaterShield)) or ((192 + 1626) == (337 - 252))) then
				if (((2138 - 1508) < (6052 - 3925)) and v23(v114.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v93 and v114.HealingSurge:IsReady()) or ((4869 - 2931) == (895 + 1619))) then
			if (((16392 - 12137) >= (189 - 134)) and (v16:HealthPercentage() <= v71)) then
				if (((2262 + 737) > (2956 - 1800)) and v23(v115.HealingSurgeFocus, not v16:IsSpellInRange(v114.HealingSurge), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((3038 - (364 + 324)) > (3166 - 2011)) and v95 and v114.HealingWave:IsReady()) then
			if (((9667 - 5638) <= (1609 + 3244)) and (v16:HealthPercentage() <= v74)) then
				if (v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2158 - 1642) > (5499 - 2065))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v127()
		local v135 = 0 - 0;
		while true do
			if (((5314 - (1249 + 19)) >= (2738 + 295)) and (v135 == (3 - 2))) then
				if (v114.Stormkeeper:IsReady() or ((3805 - (686 + 400)) <= (1136 + 311))) then
					if (v23(v114.Stormkeeper, not v14:IsInRange(269 - (73 + 156))) or ((20 + 4114) < (4737 - (721 + 90)))) then
						return "stormkeeper damage";
					end
				end
				if ((#v12:GetEnemiesInRange(1 + 39) < (9 - 6)) or ((634 - (224 + 246)) >= (4511 - 1726))) then
					if (v114.LightningBolt:IsReady() or ((966 - 441) == (383 + 1726))) then
						if (((1 + 32) == (25 + 8)) and v23(v114.LightningBolt, not v14:IsSpellInRange(v114.LightningBolt), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
							return "lightning_bolt damage";
						end
					end
				elseif (((6071 - 3017) <= (13361 - 9346)) and v114.ChainLightning:IsReady()) then
					if (((2384 - (203 + 310)) < (5375 - (1238 + 755))) and v23(v114.ChainLightning, not v14:IsSpellInRange(v114.ChainLightning), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
			if (((91 + 1202) <= (3700 - (709 + 825))) and (v135 == (0 - 0))) then
				if (v114.FlameShock:IsReady() or ((3756 - 1177) < (987 - (196 + 668)))) then
					local v234 = 0 - 0;
					while true do
						if ((v234 == (0 - 0)) or ((1679 - (171 + 662)) >= (2461 - (4 + 89)))) then
							if (v118.CastCycle(v114.FlameShock, v12:GetEnemiesInRange(140 - 100), v121, not v14:IsSpellInRange(v114.FlameShock), nil, nil, nil, nil) or ((1461 + 2551) <= (14749 - 11391))) then
								return "flame_shock_cycle damage";
							end
							if (((586 + 908) <= (4491 - (35 + 1451))) and v23(v114.FlameShock, not v14:IsSpellInRange(v114.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v114.LavaBurst:IsReady() or ((4564 - (28 + 1425)) == (4127 - (941 + 1052)))) then
					if (((2259 + 96) == (3869 - (822 + 692))) and v23(v114.LavaBurst, not v14:IsSpellInRange(v114.LavaBurst), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v135 = 1 - 0;
			end
		end
	end
	local function v128()
		v48 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v49 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v50 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v54 = EpicSettings.Settings['ChainHealGroup'];
		v55 = EpicSettings.Settings['ChainHealHP'];
		v42 = EpicSettings.Settings['DispelDebuffs'];
		v58 = EpicSettings.Settings['DownpourGroup'];
		v59 = EpicSettings.Settings['DownpourHP'];
		v60 = EpicSettings.Settings['DownpourUsage'];
		v63 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v64 = EpicSettings.Settings['EarthenWallTotemHP'];
		v65 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v41 = EpicSettings.Settings['HandleCharredBrambles'];
		v40 = EpicSettings.Settings['HandleCharredTreant'];
		v38 = EpicSettings.Settings['HealingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v66 = EpicSettings.Settings['HealingRainGroup'];
		v67 = EpicSettings.Settings['HealingRainHP'];
		v68 = EpicSettings.Settings['HealingRainUsage'];
		v69 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v70 = EpicSettings.Settings['HealingStreamTotemHP'];
		v71 = EpicSettings.Settings['HealingSurgeHP'];
		v72 = EpicSettings.Settings['HealingTideTotemGroup'];
		v73 = EpicSettings.Settings['HealingTideTotemHP'];
		v74 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v77 = EpicSettings.Settings['RiptideHP'];
		v78 = EpicSettings.Settings['RiptideTankHP'];
		v79 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v80 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v81 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v82 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v83 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v84 = EpicSettings.Settings['UnleashLifeHP'];
		v88 = EpicSettings.Settings['UseChainHeal'];
		v89 = EpicSettings.Settings['UseCloudburstTotem'];
		v91 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v92 = EpicSettings.Settings['UseHealingStreamTotem'];
		v93 = EpicSettings.Settings['UseHealingSurge'];
		v94 = EpicSettings.Settings['UseHealingTideTotem'];
		v95 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v97 = EpicSettings.Settings['UseRiptide'];
		v98 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v99 = EpicSettings.Settings['UseUnleashLife'];
		v109 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v110 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v129()
		v46 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v47 = EpicSettings.Settings['AncestralGuidanceHP'];
		v51 = EpicSettings.Settings['AscendanceGroup'];
		v52 = EpicSettings.Settings['AscendanceHP'];
		v53 = EpicSettings.Settings['AstralShiftHP'];
		v56 = EpicSettings.Settings['CloudburstTotemGroup'];
		v57 = EpicSettings.Settings['CloudburstTotemHP'];
		v61 = EpicSettings.Settings['EarthElementalHP'];
		v62 = EpicSettings.Settings['EarthElementalTankHP'];
		v75 = EpicSettings.Settings['ManaTideTotemMana'];
		v76 = EpicSettings.Settings['PrimordialWaveHP'];
		v85 = EpicSettings.Settings['UseAncestralGuidance'];
		v86 = EpicSettings.Settings['UseAscendance'];
		v87 = EpicSettings.Settings['UseAstralShift'];
		v90 = EpicSettings.Settings['UseEarthElemental'];
		v96 = EpicSettings.Settings['UseManaTideTotem'];
		v34 = EpicSettings.Settings['UseRacials'];
		v100 = EpicSettings.Settings['UseWellspring'];
		v101 = EpicSettings.Settings['WellspringGroup'];
		v102 = EpicSettings.Settings['WellspringHP'];
		v103 = EpicSettings.Settings['racialsWithCD'];
		v104 = EpicSettings.Settings['trinketsWithCD'];
		v105 = EpicSettings.Settings['useTrinkets'];
		v106 = EpicSettings.Settings['fightRemainsCheck'];
		v107 = EpicSettings.Settings['handleAfflicted'];
		v108 = EpicSettings.Settings['HandleIncorporeal'];
		v109 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v110 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v130()
		v128();
		v129();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['dispel'];
		v32 = EpicSettings.Toggles['healing'];
		v33 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((277 + 311) <= (729 - (45 + 252)))) then
			return;
		end
		if (((4747 + 50) >= (1341 + 2554)) and (v12:AffectingCombat() or v29)) then
			local v226 = v42 and v114.PurifySpirit:IsReady() and v31;
			if (((8705 - 5128) == (4010 - (114 + 319))) and v114.EarthShield:IsReady() and v91 and (v118.FriendlyUnitsWithBuffCount(v114.EarthShield, true) < (1 - 0))) then
				v28 = v118.FocusUnitRefreshableBuff(v114.EarthShield, 19 - 4, 26 + 14, "TANK");
				if (((5651 - 1857) > (7737 - 4044)) and v28) then
					return v28;
				end
			end
			if (not v16:BuffRefreshable(v114.EarthShield) or (v118.UnitGroupRole(v16) ~= "TANK") or not v91 or ((3238 - (556 + 1407)) == (5306 - (741 + 465)))) then
				v28 = v118.FocusUnit(v226, nil, nil, nil);
				if (v28 or ((2056 - (170 + 295)) >= (1887 + 1693))) then
					return v28;
				end
			end
		end
		if (((903 + 80) <= (4451 - 2643)) and v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(34 + 6) and (v118.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v114.EarthShield))) then
			if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((1379 + 771) <= (678 + 519))) then
				return "earth_shield_tank main apl";
			end
		end
		local v220;
		if (((4999 - (957 + 273)) >= (314 + 859)) and not v12:AffectingCombat()) then
			if (((595 + 890) == (5658 - 4173)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v228 = 0 - 0;
				local v229;
				while true do
					if ((v228 == (0 - 0)) or ((16414 - 13099) <= (4562 - (389 + 1391)))) then
						v229 = v118.DeadFriendlyUnitsCount();
						if ((v229 > (1 + 0)) or ((92 + 784) >= (6747 - 3783))) then
							if (v23(v114.AncestralVision, nil, v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3183 - (783 + 168)) > (8380 - 5883))) then
								return "ancestral_vision";
							end
						elseif (v23(v115.AncestralSpiritMouseover, not v14:IsInRange(40 + 0), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2421 - (309 + 2)) <= (1019 - 687))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		if (((4898 - (1090 + 122)) > (1029 + 2143)) and v12:AffectingCombat() and v118.TargetIsValid()) then
			v113 = v12:GetEnemiesInRange(134 - 94);
			v111 = v9.BossFightRemains(nil, true);
			v112 = v111;
			if ((v112 == (7605 + 3506)) or ((5592 - (628 + 490)) < (148 + 672))) then
				v112 = v9.FightRemains(v113, false);
			end
			v28 = v118.Interrupt(v114.WindShear, 74 - 44, true);
			if (((19554 - 15275) >= (3656 - (431 + 343))) and v28) then
				return v28;
			end
			v28 = v118.InterruptCursor(v114.WindShear, v115.WindShearMouseover, 60 - 30, true, v15);
			if (v28 or ((5869 - 3840) >= (2782 + 739))) then
				return v28;
			end
			v28 = v118.InterruptWithStunCursor(v114.CapacitorTotem, v115.CapacitorTotemCursor, 4 + 26, nil, v15);
			if (v28 or ((3732 - (556 + 1139)) >= (4657 - (6 + 9)))) then
				return v28;
			end
			if (((315 + 1405) < (2284 + 2174)) and v108) then
				local v230 = 169 - (28 + 141);
				while true do
					if (((0 + 0) == v230) or ((537 - 101) > (2140 + 881))) then
						v28 = v118.HandleIncorporeal(v114.Hex, v115.HexMouseOver, 1347 - (486 + 831), true);
						if (((1855 - 1142) <= (2981 - 2134)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
			if (((408 + 1746) <= (12745 - 8714)) and v107) then
				local v231 = 1263 - (668 + 595);
				while true do
					if (((4153 + 462) == (931 + 3684)) and (v231 == (2 - 1))) then
						if (v109 or ((4080 - (23 + 267)) == (2444 - (1129 + 815)))) then
							v28 = v118.HandleAfflicted(v114.TremorTotem, v114.TremorTotem, 417 - (371 + 16));
							if (((1839 - (1326 + 424)) < (418 - 197)) and v28) then
								return v28;
							end
						end
						if (((7505 - 5451) >= (1539 - (88 + 30))) and v110) then
							local v236 = 771 - (720 + 51);
							while true do
								if (((1539 - 847) < (4834 - (421 + 1355))) and (v236 == (0 - 0))) then
									v28 = v118.HandleAfflicted(v114.PoisonCleansingTotem, v114.PoisonCleansingTotem, 15 + 15);
									if (v28 or ((4337 - (286 + 797)) == (6050 - 4395))) then
										return v28;
									end
									break;
								end
							end
						end
						break;
					end
					if ((v231 == (0 - 0)) or ((1735 - (397 + 42)) == (1534 + 3376))) then
						v28 = v118.HandleAfflicted(v114.PurifySpirit, v115.PurifySpiritMouseover, 830 - (24 + 776));
						if (((5188 - 1820) == (4153 - (222 + 563))) and v28) then
							return v28;
						end
						v231 = 1 - 0;
					end
				end
			end
			v220 = v122();
			if (((1903 + 740) < (4005 - (23 + 167))) and v220) then
				return v220;
			end
			if (((3711 - (690 + 1108)) > (178 + 315)) and (v112 > v106)) then
				local v232 = 0 + 0;
				while true do
					if (((5603 - (40 + 808)) > (565 + 2863)) and (v232 == (0 - 0))) then
						v220 = v124();
						if (((1320 + 61) <= (1254 + 1115)) and v220) then
							return v220;
						end
						break;
					end
				end
			end
		end
		if (v29 or v12:AffectingCombat() or ((2656 + 2187) == (4655 - (47 + 524)))) then
			local v227 = 0 + 0;
			while true do
				if (((12762 - 8093) > (542 - 179)) and (v227 == (4 - 2))) then
					if (v220 or ((3603 - (1165 + 561)) >= (94 + 3044))) then
						return v220;
					end
					if (((14686 - 9944) >= (1384 + 2242)) and v32) then
						local v235 = 479 - (341 + 138);
						while true do
							if ((v235 == (0 + 0)) or ((9369 - 4829) == (1242 - (89 + 237)))) then
								v220 = v125();
								if (v220 or ((3718 - 2562) > (9147 - 4802))) then
									return v220;
								end
								v235 = 882 - (581 + 300);
							end
							if (((3457 - (855 + 365)) < (10092 - 5843)) and (v235 == (1 + 0))) then
								v220 = v126();
								if (v220 or ((3918 - (1030 + 205)) < (22 + 1))) then
									return v220;
								end
								break;
							end
						end
					end
					v227 = 3 + 0;
				end
				if (((983 - (156 + 130)) <= (1876 - 1050)) and (v227 == (0 - 0))) then
					if (((2263 - 1158) <= (310 + 866)) and v31) then
						if (((1971 + 1408) <= (3881 - (10 + 59))) and v16 and v42) then
							if ((v114.PurifySpirit:IsReady() and v118.DispellableFriendlyUnit(8 + 17)) or ((3880 - 3092) >= (2779 - (671 + 492)))) then
								if (((1476 + 378) <= (4594 - (369 + 846))) and v23(v115.PurifySpiritFocus, not v16:IsSpellInRange(v114.PurifySpirit))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					if (((1205 + 3344) == (3883 + 666)) and (v16:HealthPercentage() < v76) and v16:BuffDown(v114.Riptide)) then
						if (v114.PrimordialWave:IsCastable() or ((4967 - (1036 + 909)) >= (2405 + 619))) then
							if (((8092 - 3272) > (2401 - (11 + 192))) and v23(v115.PrimordialWaveFocus, not v16:IsSpellInRange(v114.PrimordialWave))) then
								return "primordial_wave main";
							end
						end
					end
					v227 = 1 + 0;
				end
				if ((v227 == (178 - (135 + 40))) or ((2570 - 1509) >= (2949 + 1942))) then
					if (((3004 - 1640) <= (6705 - 2232)) and v33) then
						if (v118.TargetIsValid() or ((3771 - (50 + 126)) <= (8 - 5))) then
							local v237 = 0 + 0;
							while true do
								if ((v237 == (1413 - (1233 + 180))) or ((5641 - (522 + 447)) == (5273 - (107 + 1314)))) then
									v220 = v127();
									if (((724 + 835) == (4750 - 3191)) and v220) then
										return v220;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if ((v227 == (1 + 0)) or ((3478 - 1726) <= (3117 - 2329))) then
					if ((v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(1950 - (716 + 1194)) and (v118.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v114.EarthShield)) or ((67 + 3840) == (19 + 158))) then
						if (((3973 - (74 + 429)) > (1070 - 515)) and v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield))) then
							return "earth_shield_tank main fight";
						end
					end
					v220 = v123();
					v227 = 1 + 1;
				end
			end
		end
	end
	local function v131()
		local v221 = 0 - 0;
		while true do
			if ((v221 == (0 + 0)) or ((2996 - 2024) == (1594 - 949))) then
				v120();
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(697 - (279 + 154), v130, v131);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

