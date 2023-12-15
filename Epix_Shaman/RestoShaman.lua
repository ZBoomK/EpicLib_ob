local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((225 + 410) == (2493 - (673 + 1185))) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if (((10831 - 7458) <= (5850 - 2294)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2460 + 831) < (4428 - 1148))) then
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
	local v113;
	local v114 = 22154 - 11043;
	local v115 = 21810 - 10699;
	local v116;
	v10:RegisterForEvent(function()
		v114 = 12991 - (446 + 1434);
		v115 = 12394 - (1040 + 243);
	end, "PLAYER_REGEN_ENABLED");
	local v117 = v18.Shaman.Restoration;
	local v118 = v25.Shaman.Restoration;
	local v119 = v20.Shaman.Restoration;
	local v120 = {};
	local v121 = v22.Commons.Everyone;
	local v122 = v22.Commons.Shaman;
	local function v123()
		if (((13090 - 8704) >= (2720 - (559 + 1288))) and v117.ImprovedPurifySpirit:IsAvailable()) then
			v121.DispellableDebuffs = v21.MergeTable(v121.DispellableMagicDebuffs, v121.DispellableCurseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124(v135)
		return v135:DebuffRefreshable(v117.FlameShockDebuff) and (v115 > (1936 - (609 + 1322)));
	end
	local function v125()
		local v136 = 454 - (13 + 441);
		while true do
			if (((3441 - 2520) <= (2886 - 1784)) and (v136 == (4 - 3))) then
				if (((176 + 4530) >= (3497 - 2534)) and v119.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
					if (v24(v118.Healthstone) or ((341 + 619) <= (384 + 492))) then
						return "healthstone defensive 3";
					end
				end
				if ((v38 and (v13:HealthPercentage() <= v39)) or ((6130 - 4064) == (510 + 422))) then
					if (((8873 - 4048) < (3202 + 1641)) and (v40 == "Refreshing Healing Potion")) then
						if (v119.RefreshingHealingPotion:IsReady() or ((2157 + 1720) >= (3260 + 1277))) then
							if (v24(v118.RefreshingHealingPotion) or ((3624 + 691) < (1689 + 37))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v40 == "Dreamwalker's Healing Potion") or ((4112 - (153 + 280)) < (1804 - 1179))) then
						if (v119.DreamwalkersHealingPotion:IsReady() or ((4153 + 472) < (250 + 382))) then
							if (v24(v118.RefreshingHealingPotion) or ((44 + 39) > (1616 + 164))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((396 + 150) <= (1639 - 562)) and (v136 == (0 + 0))) then
				if ((v89 and v117.AstralShift:IsReady()) or ((1663 - (89 + 578)) > (3073 + 1228))) then
					if (((8461 - 4391) > (1736 - (572 + 477))) and (v13:HealthPercentage() <= v55)) then
						if (v24(v117.AstralShift, not v15:IsInRange(6 + 34)) or ((394 + 262) >= (398 + 2932))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v92 and v117.EarthElemental:IsReady()) or ((2578 - (84 + 2)) <= (552 - 217))) then
					if (((3114 + 1208) >= (3404 - (497 + 345))) and ((v13:HealthPercentage() <= v63) or v121.IsTankBelowHealthPercentage(v64))) then
						if (v24(v117.EarthElemental, not v15:IsInRange(2 + 38)) or ((615 + 3022) >= (5103 - (605 + 728)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v126()
		if (v41 or ((5288 - 2909) > (210 + 4368))) then
			local v148 = 0 - 0;
			while true do
				if ((v148 == (1 + 0)) or ((1337 - 854) > (562 + 181))) then
					v29 = v121.HandleCharredTreant(v117.HealingSurge, v118.HealingSurgeMouseover, 529 - (457 + 32));
					if (((1042 + 1412) > (1980 - (832 + 570))) and v29) then
						return v29;
					end
					v148 = 2 + 0;
				end
				if (((243 + 687) < (15775 - 11317)) and (v148 == (1 + 1))) then
					v29 = v121.HandleCharredTreant(v117.HealingWave, v118.HealingWaveMouseover, 836 - (588 + 208));
					if (((1784 - 1122) <= (2772 - (884 + 916))) and v29) then
						return v29;
					end
					break;
				end
				if (((9148 - 4778) == (2534 + 1836)) and (v148 == (653 - (232 + 421)))) then
					v29 = v121.HandleCharredTreant(v117.Riptide, v118.RiptideMouseover, 1929 - (1569 + 320));
					if (v29 or ((1169 + 3593) <= (164 + 697))) then
						return v29;
					end
					v148 = 3 - 2;
				end
			end
		end
		if (v42 or ((2017 - (316 + 289)) == (11161 - 6897))) then
			local v149 = 0 + 0;
			while true do
				if ((v149 == (1454 - (666 + 787))) or ((3593 - (360 + 65)) < (2013 + 140))) then
					v29 = v121.HandleCharredBrambles(v117.HealingSurge, v118.HealingSurgeMouseover, 294 - (79 + 175));
					if (v29 or ((7846 - 2870) < (1040 + 292))) then
						return v29;
					end
					v149 = 5 - 3;
				end
				if (((8912 - 4284) == (5527 - (503 + 396))) and (v149 == (181 - (92 + 89)))) then
					v29 = v121.HandleCharredBrambles(v117.Riptide, v118.RiptideMouseover, 77 - 37);
					if (v29 or ((28 + 26) == (234 + 161))) then
						return v29;
					end
					v149 = 3 - 2;
				end
				if (((12 + 70) == (186 - 104)) and (v149 == (2 + 0))) then
					v29 = v121.HandleCharredBrambles(v117.HealingWave, v118.HealingWaveMouseover, 20 + 20);
					if (v29 or ((1769 - 1188) < (36 + 246))) then
						return v29;
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v137 = 0 - 0;
		while true do
			if (((1244 - (485 + 759)) == v137) or ((10664 - 6055) < (3684 - (442 + 747)))) then
				if (((2287 - (832 + 303)) == (2098 - (88 + 858))) and v107 and ((v31 and v106) or not v106)) then
					local v237 = 0 + 0;
					while true do
						if (((1570 + 326) <= (141 + 3281)) and (v237 == (790 - (766 + 23)))) then
							v29 = v121.HandleBottomTrinket(v120, v31, 197 - 157, nil);
							if (v29 or ((1353 - 363) > (4268 - 2648))) then
								return v29;
							end
							break;
						end
						if (((0 - 0) == v237) or ((1950 - (1036 + 37)) > (3329 + 1366))) then
							v29 = v121.HandleTopTrinket(v120, v31, 77 - 37, nil);
							if (((2117 + 574) >= (3331 - (641 + 839))) and v29) then
								return v29;
							end
							v237 = 914 - (910 + 3);
						end
					end
				end
				if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((7609 - 4624) >= (6540 - (1466 + 218)))) then
					if (((1966 + 2310) >= (2343 - (556 + 592))) and (v17:HealthPercentage() <= v79)) then
						if (((1150 + 2082) <= (5498 - (329 + 479))) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v137 = 855 - (174 + 680);
			end
			if (((3 - 2) == v137) or ((1856 - 960) >= (2247 + 899))) then
				if (((3800 - (396 + 343)) >= (262 + 2696)) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
					if (((4664 - (29 + 1448)) >= (2033 - (135 + 1254))) and (v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) then
						if (((2425 - 1781) <= (3287 - 2583)) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((639 + 319) > (2474 - (389 + 1138))) and v121.AreUnitsBelowHealthPercentage(v82, v81) and v117.SpiritLinkTotem:IsReady()) then
					if (((5066 - (102 + 472)) >= (2505 + 149)) and (v83 == "Player")) then
						if (((1909 + 1533) >= (1402 + 101)) and v24(v118.SpiritLinkTotemPlayer, not v15:IsInRange(1585 - (320 + 1225)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v83 == "Friendly under Cursor") or ((5643 - 2473) <= (896 + 568))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((6261 - (157 + 1307)) == (6247 - (821 + 1038)))) then
							if (((1374 - 823) <= (75 + 606)) and v24(v118.SpiritLinkTotemCursor, not v15:IsInRange(71 - 31))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((1220 + 2057) > (1008 - 601)) and (v83 == "Confirmation")) then
						if (((5721 - (834 + 192)) >= (90 + 1325)) and v24(v117.SpiritLinkTotem, not v15:IsInRange(11 + 29))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v137 = 1 + 1;
			end
			if ((v137 == (5 - 1)) or ((3516 - (300 + 4)) <= (253 + 691))) then
				if ((v98 and (v13:Mana() <= v77) and v117.ManaTideTotem:IsReady()) or ((8104 - 5008) <= (2160 - (112 + 250)))) then
					if (((1411 + 2126) == (8860 - 5323)) and v24(v117.ManaTideTotem, not v15:IsInRange(23 + 17))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((1985 + 1852) >= (1175 + 395)) and v35 and ((v105 and v31) or not v105)) then
					local v238 = 0 + 0;
					while true do
						if ((v238 == (0 + 0)) or ((4364 - (1001 + 413)) == (8500 - 4688))) then
							if (((5605 - (244 + 638)) >= (3011 - (627 + 66))) and v117.AncestralCall:IsReady()) then
								if (v24(v117.AncestralCall, not v15:IsInRange(119 - 79)) or ((2629 - (512 + 90)) > (4758 - (1665 + 241)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v117.BagofTricks:IsReady() or ((1853 - (373 + 344)) > (1948 + 2369))) then
								if (((1257 + 3491) == (12523 - 7775)) and v24(v117.BagofTricks, not v15:IsInRange(67 - 27))) then
									return "BagofTricks cooldowns";
								end
							end
							v238 = 1100 - (35 + 1064);
						end
						if (((2719 + 1017) <= (10141 - 5401)) and (v238 == (1 + 1))) then
							if (v117.Fireblood:IsReady() or ((4626 - (298 + 938)) <= (4319 - (233 + 1026)))) then
								if (v24(v117.Fireblood, not v15:IsInRange(1706 - (636 + 1030))) or ((511 + 488) > (2631 + 62))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((138 + 325) < (41 + 560)) and (v238 == (222 - (55 + 166)))) then
							if (v117.Berserking:IsReady() or ((424 + 1759) < (70 + 617))) then
								if (((17372 - 12823) == (4846 - (36 + 261))) and v24(v117.Berserking, not v15:IsInRange(69 - 29))) then
									return "Berserking cooldowns";
								end
							end
							if (((6040 - (34 + 1334)) == (1797 + 2875)) and v117.BloodFury:IsReady()) then
								if (v24(v117.BloodFury, not v15:IsInRange(32 + 8)) or ((4951 - (1035 + 248)) < (416 - (20 + 1)))) then
									return "BloodFury cooldowns";
								end
							end
							v238 = 2 + 0;
						end
					end
				end
				break;
			end
			if ((v137 == (322 - (134 + 185))) or ((5299 - (549 + 584)) == (1140 - (314 + 371)))) then
				if ((v87 and v121.AreUnitsBelowHealthPercentage(v49, v48) and v117.AncestralGuidance:IsReady()) or ((15273 - 10824) == (3631 - (478 + 490)))) then
					if (v24(v117.AncestralGuidance, not v15:IsInRange(22 + 18)) or ((5449 - (786 + 386)) < (9681 - 6692))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v88 and v121.AreUnitsBelowHealthPercentage(v54, v53) and v117.Ascendance:IsReady()) or ((2249 - (1055 + 324)) >= (5489 - (1093 + 247)))) then
					if (((1966 + 246) < (335 + 2848)) and v24(v117.Ascendance, not v15:IsInRange(158 - 118))) then
						return "ascendance cooldowns";
					end
				end
				v137 = 13 - 9;
			end
			if (((13220 - 8574) > (7518 - 4526)) and (v137 == (1 + 1))) then
				if (((5524 - 4090) < (10705 - 7599)) and v96 and v121.AreUnitsBelowHealthPercentage(v75, v74) and v117.HealingTideTotem:IsReady()) then
					if (((593 + 193) < (7730 - 4707)) and v24(v117.HealingTideTotem, not v15:IsInRange(728 - (364 + 324)))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v121.AreUnitsBelowHealthPercentage(v51, v50) and v117.AncestralProtectionTotem:IsReady()) or ((6694 - 4252) < (177 - 103))) then
					if (((1504 + 3031) == (18975 - 14440)) and (v52 == "Player")) then
						if (v24(v118.AncestralProtectionTotemPlayer, not v15:IsInRange(64 - 24)) or ((9138 - 6129) <= (3373 - (1249 + 19)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((1652 + 178) < (14281 - 10612)) and (v52 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2516 - (686 + 400)) >= (2834 + 778))) then
							if (((2912 - (73 + 156)) >= (12 + 2448)) and v24(v118.AncestralProtectionTotemCursor, not v15:IsInRange(851 - (721 + 90)))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v52 == "Confirmation") or ((21 + 1783) >= (10633 - 7358))) then
						if (v24(v117.AncestralProtectionTotem, not v15:IsInRange(510 - (224 + 246))) or ((2295 - 878) > (6681 - 3052))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v137 = 1 + 2;
			end
		end
	end
	local function v128()
		local v138 = 0 + 0;
		while true do
			if (((3522 + 1273) > (798 - 396)) and (v138 == (9 - 6))) then
				if (((5326 - (203 + 310)) > (5558 - (1238 + 755))) and v91 and v121.AreUnitsBelowHealthPercentage(v59, v58) and v117.CloudburstTotem:IsReady()) then
					if (((274 + 3638) == (5446 - (709 + 825))) and v24(v117.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((5198 - 2377) <= (7026 - 2202)) and v102 and v121.AreUnitsBelowHealthPercentage(v104, v103) and v117.Wellspring:IsReady()) then
					if (((2602 - (196 + 668)) <= (8666 - 6471)) and v24(v117.Wellspring, not v15:IsInRange(82 - 42), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if (((874 - (171 + 662)) <= (3111 - (4 + 89))) and v90 and v121.AreUnitsBelowHealthPercentage(v57, v56) and v117.ChainHeal:IsReady()) then
					if (((7517 - 5372) <= (1495 + 2609)) and v24(v118.ChainHealFocus, not v17:IsSpellInRange(v117.ChainHeal), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v138 = 17 - 13;
			end
			if (((1055 + 1634) < (6331 - (35 + 1451))) and (v138 == (1455 - (28 + 1425)))) then
				if ((v121.AreUnitsBelowHealthPercentage(v69, v68) and v117.HealingRain:IsReady()) or ((4315 - (941 + 1052)) > (2515 + 107))) then
					if ((v70 == "Player") or ((6048 - (822 + 692)) == (2971 - 889))) then
						if (v24(v118.HealingRainPlayer, not v15:IsInRange(19 + 21), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1868 - (45 + 252)) > (1848 + 19))) then
							return "healing_rain healingaoe";
						end
					elseif ((v70 == "Friendly under Cursor") or ((914 + 1740) >= (7291 - 4295))) then
						if (((4411 - (114 + 319)) > (3020 - 916)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((3837 - 842) > (983 + 558)) and v24(v118.HealingRainCursor, not v15:IsInRange(59 - 19), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((6807 - 3558) > (2916 - (556 + 1407))) and (v70 == "Enemy under Cursor")) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((4479 - (741 + 465)) > (5038 - (170 + 295)))) then
							if (v24(v118.HealingRainCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2895 + 256) < (3161 - 1877))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((1534 + 316) == (981 + 548))) then
						if (((465 + 356) < (3353 - (957 + 273))) and v24(v117.HealingRain, not v15:IsInRange(11 + 29), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((362 + 540) < (8859 - 6534)) and v121.AreUnitsBelowHealthPercentage(v66, v65) and v117.EarthenWallTotem:IsReady()) then
					if (((2260 - 1402) <= (9047 - 6085)) and (v67 == "Player")) then
						if (v24(v118.EarthenWallTotemPlayer, not v15:IsInRange(198 - 158)) or ((5726 - (389 + 1391)) < (809 + 479))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v67 == "Friendly under Cursor") or ((338 + 2904) == (1290 - 723))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1798 - (783 + 168)) >= (4238 - 2975))) then
							if (v24(v118.EarthenWallTotemCursor, not v15:IsInRange(40 + 0)) or ((2564 - (309 + 2)) == (5684 - 3833))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v67 == "Confirmation") or ((3299 - (1090 + 122)) > (770 + 1602))) then
						if (v24(v117.EarthenWallTotem, not v15:IsInRange(134 - 94)) or ((3043 + 1402) < (5267 - (628 + 490)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if ((v121.AreUnitsBelowHealthPercentage(v61, v60) and v117.Downpour:IsReady()) or ((326 + 1492) == (210 - 125))) then
					if (((2879 - 2249) < (2901 - (431 + 343))) and (v62 == "Player")) then
						if (v24(v118.DownpourPlayer, not v15:IsInRange(80 - 40), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((5606 - 3668) == (1987 + 527))) then
							return "downpour healingaoe";
						end
					elseif (((545 + 3710) >= (1750 - (556 + 1139))) and (v62 == "Friendly under Cursor")) then
						if (((3014 - (6 + 9)) > (212 + 944)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((1204 + 1146) > (1324 - (28 + 141))) and v24(v118.DownpourCursor, not v15:IsInRange(16 + 24), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((4972 - 943) <= (3438 + 1415)) and (v62 == "Confirmation")) then
						if (v24(v117.Downpour, not v15:IsInRange(1357 - (486 + 831)), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1342 - 826) > (12089 - 8655))) then
							return "downpour healingaoe";
						end
					end
				end
				v138 = 1 + 2;
			end
			if (((12793 - 8747) >= (4296 - (668 + 595))) and (v138 == (4 + 0))) then
				if ((v100 and v13:IsMoving() and v121.AreUnitsBelowHealthPercentage(v85, v84) and v117.SpiritwalkersGrace:IsReady()) or ((549 + 2170) <= (3946 - 2499))) then
					if (v24(v117.SpiritwalkersGrace, nil) or ((4424 - (23 + 267)) < (5870 - (1129 + 815)))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v94 and v121.AreUnitsBelowHealthPercentage(v72, v71) and v117.HealingStreamTotem:IsReady()) or ((551 - (371 + 16)) >= (4535 - (1326 + 424)))) then
					if (v24(v117.HealingStreamTotem, nil) or ((994 - 469) == (7706 - 5597))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((151 - (88 + 30)) == (804 - (720 + 51))) and (v138 == (2 - 1))) then
				if (((4830 - (421 + 1355)) <= (6623 - 2608)) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
					if (((920 + 951) < (4465 - (286 + 797))) and (v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) then
						if (((4726 - 3433) <= (3587 - 1421)) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v101 and v117.UnleashLife:IsReady()) or ((3018 - (397 + 42)) < (39 + 84))) then
					if ((v17:HealthPercentage() <= v86) or ((1646 - (24 + 776)) >= (3647 - 1279))) then
						if (v24(v117.UnleashLife, not v17:IsSpellInRange(v117.UnleashLife)) or ((4797 - (222 + 563)) <= (7398 - 4040))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((1076 + 418) <= (3195 - (23 + 167))) and (v70 == "Cursor") and v117.HealingRain:IsReady()) then
					if (v24(v118.HealingRainCursor, not v15:IsInRange(1838 - (690 + 1108)), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1123 + 1988) == (1761 + 373))) then
						return "healing_rain healingaoe";
					end
				end
				v138 = 850 - (40 + 808);
			end
			if (((388 + 1967) == (9005 - 6650)) and ((0 + 0) == v138)) then
				if ((v90 and v121.AreUnitsBelowHealthPercentage(48 + 42, 2 + 1) and v117.ChainHeal:IsReady() and v13:BuffUp(v117.HighTide)) or ((1159 - (47 + 524)) <= (281 + 151))) then
					if (((13112 - 8315) >= (5824 - 1929)) and v24(v118.ChainHealFocus, not v17:IsSpellInRange(v117.ChainHeal), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((8157 - 4580) == (5303 - (1165 + 561))) and v97 and (v17:HealthPercentage() <= v76) and v117.HealingWave:IsReady() and (v117.PrimordialWave:TimeSinceLastCast() < (1 + 14))) then
					if (((11750 - 7956) > (1410 + 2283)) and v24(v118.HealingWaveFocus, not v17:IsSpellInRange(v117.HealingWave), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((1754 - (341 + 138)) == (1107 + 2993))) then
					if ((v17:HealthPercentage() <= v79) or ((3283 - 1692) >= (3906 - (89 + 237)))) then
						if (((3162 - 2179) <= (3806 - 1998)) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v138 = 882 - (581 + 300);
			end
		end
	end
	local function v129()
		local v139 = 1220 - (855 + 365);
		while true do
			if ((v139 == (4 - 2)) or ((703 + 1447) <= (2432 - (1030 + 205)))) then
				if (((3539 + 230) >= (1092 + 81)) and v117.ElementalOrbit:IsAvailable() and v13:BuffUp(v117.EarthShieldBuff)) then
					if (((1771 - (156 + 130)) == (3374 - 1889)) and v121.IsSoloMode()) then
						if ((v117.LightningShield:IsReady() and v13:BuffDown(v117.LightningShield)) or ((5587 - 2272) <= (5697 - 2915))) then
							if (v24(v117.LightningShield) or ((231 + 645) >= (1729 + 1235))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v117.WaterShield:IsReady() and v13:BuffDown(v117.WaterShield)) or ((2301 - (10 + 59)) > (707 + 1790))) then
						if (v24(v117.WaterShield) or ((10391 - 8281) <= (1495 - (671 + 492)))) then
							return "water_shield healingst";
						end
					end
				end
				if (((2935 + 751) > (4387 - (369 + 846))) and v95 and v117.HealingSurge:IsReady()) then
					if ((v17:HealthPercentage() <= v73) or ((1185 + 3289) < (700 + 120))) then
						if (((6224 - (1036 + 909)) >= (2292 + 590)) and v24(v118.HealingSurgeFocus, not v17:IsSpellInRange(v117.HealingSurge), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				v139 = 4 - 1;
			end
			if ((v139 == (206 - (11 + 192))) or ((1026 + 1003) >= (3696 - (135 + 40)))) then
				if ((v97 and v117.HealingWave:IsReady()) or ((4935 - 2898) >= (2799 + 1843))) then
					if (((3789 - 2069) < (6682 - 2224)) and (v17:HealthPercentage() <= v76)) then
						if (v24(v118.HealingWaveFocus, not v17:IsSpellInRange(v117.HealingWave), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((612 - (50 + 126)) > (8412 - 5391))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((158 + 555) <= (2260 - (1233 + 180))) and (v139 == (970 - (522 + 447)))) then
				if (((3575 - (107 + 1314)) <= (1871 + 2160)) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
					if (((14062 - 9447) == (1961 + 2654)) and ((v17:HealthPercentage() <= v79) or (v17:HealthPercentage() <= v79))) then
						if (v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide)) or ((7526 - 3736) == (1978 - 1478))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((1999 - (716 + 1194)) < (4 + 217)) and v117.ElementalOrbit:IsAvailable() and v13:BuffDown(v117.EarthShieldBuff)) then
					if (((221 + 1833) >= (1924 - (74 + 429))) and v24(v117.EarthShield)) then
						return "earth_shield healingst";
					end
				end
				v139 = 3 - 1;
			end
			if (((343 + 349) < (6999 - 3941)) and (v139 == (0 + 0))) then
				if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((10031 - 6777) == (4092 - 2437))) then
					if ((v17:HealthPercentage() <= v79) or ((1729 - (279 + 154)) == (5688 - (454 + 324)))) then
						if (((2650 + 718) == (3385 - (12 + 5))) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((1425 + 1218) < (9720 - 5905)) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
					if (((707 + 1206) > (1586 - (277 + 816))) and (v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) then
						if (((20318 - 15563) > (4611 - (1058 + 125))) and v24(v118.RiptideFocus, not v17:IsSpellInRange(v117.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v139 = 1 + 0;
			end
		end
	end
	local function v130()
		if (((2356 - (815 + 160)) <= (10164 - 7795)) and v117.FlameShock:IsReady()) then
			local v150 = 0 - 0;
			while true do
				if ((v150 == (0 + 0)) or ((14156 - 9313) == (5982 - (41 + 1857)))) then
					if (((6562 - (1222 + 671)) > (937 - 574)) and v121.CastCycle(v117.FlameShock, v13:GetEnemiesInRange(57 - 17), v124, not v15:IsSpellInRange(v117.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (v24(v117.FlameShock, not v15:IsSpellInRange(v117.FlameShock)) or ((3059 - (229 + 953)) >= (4912 - (1111 + 663)))) then
						return "flame_shock damage";
					end
					break;
				end
			end
		end
		if (((6321 - (874 + 705)) >= (508 + 3118)) and v117.LavaBurst:IsReady()) then
			if (v24(v117.LavaBurst, not v15:IsSpellInRange(v117.LavaBurst), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((3098 + 1442) == (1903 - 987))) then
				return "lava_burst damage";
			end
		end
		if (v117.Stormkeeper:IsReady() or ((33 + 1123) > (5024 - (642 + 37)))) then
			if (((511 + 1726) < (680 + 3569)) and v24(v117.Stormkeeper, not v15:IsInRange(100 - 60))) then
				return "stormkeeper damage";
			end
		end
		if ((#v13:GetEnemiesInRange(494 - (233 + 221)) < (6 - 3)) or ((2362 + 321) < (1564 - (718 + 823)))) then
			if (((439 + 258) <= (1631 - (266 + 539))) and v117.LightningBolt:IsReady()) then
				if (((3128 - 2023) <= (2401 - (636 + 589))) and v24(v117.LightningBolt, not v15:IsSpellInRange(v117.LightningBolt), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "lightning_bolt damage";
				end
			end
		elseif (((8020 - 4641) <= (7862 - 4050)) and v117.ChainLightning:IsReady()) then
			if (v24(v117.ChainLightning, not v15:IsSpellInRange(v117.ChainLightning), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((625 + 163) >= (588 + 1028))) then
				return "chain_lightning damage";
			end
		end
	end
	local function v131()
		local v140 = 1015 - (657 + 358);
		while true do
			if (((4908 - 3054) <= (7698 - 4319)) and (v140 == (1190 - (1151 + 36)))) then
				v69 = EpicSettings.Settings['HealingRainHP'];
				v70 = EpicSettings.Settings['HealingRainUsage'];
				v71 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v72 = EpicSettings.Settings['HealingStreamTotemHP'];
				v73 = EpicSettings.Settings['HealingSurgeHP'];
				v74 = EpicSettings.Settings['HealingTideTotemGroup'];
				v140 = 4 + 0;
			end
			if (((1196 + 3353) == (13585 - 9036)) and (v140 == (1832 - (1552 + 280)))) then
				v50 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v52 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v56 = EpicSettings.Settings['ChainHealGroup'];
				v57 = EpicSettings.Settings['ChainHealHP'];
				v44 = EpicSettings.Settings['DispelBuffs'];
				v140 = 835 - (64 + 770);
			end
			if ((v140 == (5 + 1)) or ((6859 - 3837) >= (537 + 2487))) then
				v85 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v86 = EpicSettings.Settings['UnleashLifeHP'];
				v90 = EpicSettings.Settings['UseChainHeal'];
				v91 = EpicSettings.Settings['UseCloudburstTotem'];
				v93 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['UseHealingPotion'];
				v140 = 1250 - (157 + 1086);
			end
			if (((9647 - 4827) > (9626 - 7428)) and (v140 == (7 - 2))) then
				v79 = EpicSettings.Settings['RiptideHP'];
				v80 = EpicSettings.Settings['RiptideTankHP'];
				v81 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v82 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v83 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v84 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v140 = 7 - 1;
			end
			if (((821 - (599 + 220)) == v140) or ((2112 - 1051) >= (6822 - (1813 + 118)))) then
				v67 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v39 = EpicSettings.Settings['HealingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v68 = EpicSettings.Settings['HealingRainGroup'];
				v140 = 3 + 0;
			end
			if (((2581 - (841 + 376)) <= (6266 - 1793)) and (v140 == (1 + 0))) then
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v60 = EpicSettings.Settings['DownpourGroup'];
				v61 = EpicSettings.Settings['DownpourHP'];
				v62 = EpicSettings.Settings['DownpourUsage'];
				v65 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v66 = EpicSettings.Settings['EarthenWallTotemHP'];
				v140 = 5 - 3;
			end
			if ((v140 == (866 - (464 + 395))) or ((9226 - 5631) <= (2 + 1))) then
				v94 = EpicSettings.Settings['UseHealingStreamTotem'];
				v95 = EpicSettings.Settings['UseHealingSurge'];
				v96 = EpicSettings.Settings['UseHealingTideTotem'];
				v97 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v99 = EpicSettings.Settings['UseRiptide'];
				v140 = 845 - (467 + 370);
			end
			if (((8 - 4) == v140) or ((3430 + 1242) == (13204 - 9352))) then
				v75 = EpicSettings.Settings['HealingTideTotemHP'];
				v76 = EpicSettings.Settings['HealingWaveHP'];
				v37 = EpicSettings.Settings['healthstoneHP'];
				v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v47 = EpicSettings.Settings['InterruptThreshold'];
				v45 = EpicSettings.Settings['InterruptWithStun'];
				v140 = 1 + 4;
			end
			if (((3626 - 2067) == (2079 - (150 + 370))) and (v140 == (1290 - (74 + 1208)))) then
				v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v101 = EpicSettings.Settings['UseUnleashLife'];
				v111 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
				v112 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
				break;
			end
		end
	end
	local function v132()
		local v141 = 0 - 0;
		while true do
			if (((28 - 22) == v141) or ((1247 + 505) <= (1178 - (14 + 376)))) then
				v103 = EpicSettings.Settings['WellspringGroup'];
				v104 = EpicSettings.Settings['WellspringHP'];
				v105 = EpicSettings.Settings['racialsWithCD'];
				v141 = 11 - 4;
			end
			if ((v141 == (3 + 1)) or ((3433 + 474) == (169 + 8))) then
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v141 = 14 - 9;
			end
			if (((2611 + 859) > (633 - (23 + 55))) and (v141 == (6 - 3))) then
				v77 = EpicSettings.Settings['ManaTideTotemMana'];
				v78 = EpicSettings.Settings['PrimordialWaveHP'];
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v141 = 3 + 1;
			end
			if (((5 + 0) == v141) or ((1506 - 534) == (203 + 442))) then
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v35 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['UseWellspring'];
				v141 = 907 - (652 + 249);
			end
			if (((8515 - 5333) >= (3983 - (708 + 1160))) and (v141 == (18 - 11))) then
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v141 = 14 - 6;
			end
			if (((3920 - (10 + 17)) < (995 + 3434)) and (v141 == (1734 - (1400 + 332)))) then
				v59 = EpicSettings.Settings['CloudburstTotemHP'];
				v63 = EpicSettings.Settings['EarthElementalHP'];
				v64 = EpicSettings.Settings['EarthElementalTankHP'];
				v141 = 5 - 2;
			end
			if ((v141 == (1909 - (242 + 1666))) or ((1227 + 1640) < (699 + 1206))) then
				v54 = EpicSettings.Settings['AscendanceHP'];
				v55 = EpicSettings.Settings['AstralShiftHP'];
				v58 = EpicSettings.Settings['CloudburstTotemGroup'];
				v141 = 2 + 0;
			end
			if ((v141 == (949 - (850 + 90))) or ((3144 - 1348) >= (5441 - (360 + 1030)))) then
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v113 = EpicSettings.Settings['usePurgeTarget'];
				break;
			end
			if (((1433 + 186) <= (10600 - 6844)) and (v141 == (0 - 0))) then
				v48 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v49 = EpicSettings.Settings['AncestralGuidanceHP'];
				v53 = EpicSettings.Settings['AscendanceGroup'];
				v141 = 1662 - (909 + 752);
			end
			if (((1827 - (109 + 1114)) == (1105 - 501)) and (v141 == (4 + 4))) then
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v141 = 251 - (6 + 236);
			end
		end
	end
	local function v133()
		local v142 = 0 + 0;
		local v143;
		while true do
			if ((v142 == (2 + 0)) or ((10574 - 6090) == (1572 - 672))) then
				if (v13:AffectingCombat() or v30 or ((5592 - (1076 + 57)) <= (184 + 929))) then
					local v239 = 689 - (579 + 110);
					local v240;
					while true do
						if (((287 + 3345) > (3005 + 393)) and (v239 == (0 + 0))) then
							v240 = v43 and v117.PurifySpirit:IsReady() and v32;
							if (((4489 - (174 + 233)) <= (13734 - 8817)) and v117.EarthShield:IsReady() and v93 and (v121.FriendlyUnitsWithBuffCount(v117.EarthShield, true) < (1 - 0))) then
								local v247 = 0 + 0;
								while true do
									if (((6006 - (663 + 511)) >= (1237 + 149)) and (v247 == (0 + 0))) then
										v29 = v121.FocusUnitRefreshableBuff(v117.EarthShield, 46 - 31, 25 + 15, "TANK");
										if (((322 - 185) == (331 - 194)) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							v239 = 1 + 0;
						end
						if ((v239 == (1 - 0)) or ((1119 + 451) >= (396 + 3936))) then
							if (not v17:BuffRefreshable(v117.EarthShield) or (v121.UnitGroupRole(v17) ~= "TANK") or not v93 or ((4786 - (478 + 244)) <= (2336 - (440 + 77)))) then
								v29 = v121.FocusUnit(v240, nil, nil, nil);
								if (v29 or ((2268 + 2718) < (5760 - 4186))) then
									return v29;
								end
							end
							break;
						end
					end
				end
				if (((5982 - (655 + 901)) > (32 + 140)) and v117.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(31 + 9) and (v121.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v117.EarthShield))) then
					if (((396 + 190) > (1833 - 1378)) and v24(v118.EarthShieldFocus, not v17:IsSpellInRange(v117.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v143 = nil;
				if (((2271 - (695 + 750)) == (2820 - 1994)) and not v13:AffectingCombat()) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((6201 - 2182) > (17860 - 13419))) then
						local v242 = 351 - (285 + 66);
						local v243;
						while true do
							if (((4701 - 2684) < (5571 - (682 + 628))) and ((0 + 0) == v242)) then
								v243 = v121.DeadFriendlyUnitsCount();
								if (((5015 - (176 + 123)) > (34 + 46)) and (v243 > (1 + 0))) then
									if (v24(v117.AncestralVision, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((3776 - (239 + 30)) == (890 + 2382))) then
										return "ancestral_vision";
									end
								elseif (v24(v118.AncestralSpiritMouseover, not v15:IsInRange(39 + 1), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1549 - 673) >= (9593 - 6518))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v142 = 318 - (306 + 9);
			end
			if (((15186 - 10834) > (445 + 2109)) and (v142 == (0 + 0))) then
				v131();
				v132();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['cds'];
				v142 = 1 + 0;
			end
			if ((v142 == (2 - 1)) or ((5781 - (1140 + 235)) < (2573 + 1470))) then
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (v13:IsDeadOrGhost() or ((1733 + 156) >= (869 + 2514))) then
					return;
				end
				v142 = 54 - (33 + 19);
			end
			if (((684 + 1208) <= (8194 - 5460)) and (v142 == (2 + 1))) then
				if (((3770 - 1847) < (2080 + 138)) and v13:AffectingCombat() and v121.TargetIsValid()) then
					v116 = v13:GetEnemiesInRange(729 - (586 + 103));
					v114 = v10.BossFightRemains(nil, true);
					v115 = v114;
					if (((198 + 1975) > (1166 - 787)) and (v115 == (12599 - (1309 + 179)))) then
						v115 = v10.FightRemains(v116, false);
					end
					v29 = v121.Interrupt(v117.WindShear, 54 - 24, true);
					if (v29 or ((1128 + 1463) == (9154 - 5745))) then
						return v29;
					end
					v29 = v121.InterruptCursor(v117.WindShear, v118.WindShearMouseover, 23 + 7, true, v16);
					if (((9590 - 5076) > (6623 - 3299)) and v29) then
						return v29;
					end
					v29 = v121.InterruptWithStunCursor(v117.CapacitorTotem, v118.CapacitorTotemCursor, 639 - (295 + 314), nil, v16);
					if (v29 or ((510 - 302) >= (6790 - (1300 + 662)))) then
						return v29;
					end
					if (v110 or ((4970 - 3387) > (5322 - (1178 + 577)))) then
						local v244 = 0 + 0;
						while true do
							if ((v244 == (0 - 0)) or ((2718 - (851 + 554)) == (703 + 91))) then
								v29 = v121.HandleIncorporeal(v117.Hex, v118.HexMouseOver, 83 - 53, true);
								if (((6893 - 3719) > (3204 - (115 + 187))) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (((3156 + 964) <= (4033 + 227)) and v109) then
						local v245 = 0 - 0;
						while true do
							if ((v245 == (1161 - (160 + 1001))) or ((773 + 110) > (3297 + 1481))) then
								v29 = v121.HandleAfflicted(v117.PurifySpirit, v118.PurifySpiritMouseover, 61 - 31);
								if (v29 or ((3978 - (237 + 121)) >= (5788 - (525 + 372)))) then
									return v29;
								end
								v245 = 1 - 0;
							end
							if (((13990 - 9732) > (1079 - (96 + 46))) and (v245 == (778 - (643 + 134)))) then
								if (v111 or ((1758 + 3111) < (2172 - 1266))) then
									local v248 = 0 - 0;
									while true do
										if ((v248 == (0 + 0)) or ((2404 - 1179) > (8642 - 4414))) then
											v29 = v121.HandleAfflicted(v117.TremorTotem, v117.TremorTotem, 749 - (316 + 403));
											if (((2213 + 1115) > (6153 - 3915)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if (((1388 + 2451) > (3538 - 2133)) and v112) then
									v29 = v121.HandleAfflicted(v117.PoisonCleansingTotem, v117.PoisonCleansingTotem, 22 + 8);
									if (v29 or ((417 + 876) <= (1756 - 1249))) then
										return v29;
									end
								end
								break;
							end
						end
					end
					v143 = v125();
					if (v143 or ((13830 - 10934) < (1672 - 867))) then
						return v143;
					end
					if (((133 + 2183) == (4559 - 2243)) and (v115 > v108)) then
						local v246 = 0 + 0;
						while true do
							if ((v246 == (0 - 0)) or ((2587 - (12 + 5)) == (5954 - 4421))) then
								v143 = v127();
								if (v143 or ((1883 - 1000) == (3103 - 1643))) then
									return v143;
								end
								break;
							end
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((11454 - 6835) <= (203 + 796))) then
					local v241 = 1973 - (1656 + 317);
					while true do
						if ((v241 == (1 + 0)) or ((2733 + 677) > (10944 - 6828))) then
							if ((v117.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(196 - 156) and (v121.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v117.EarthShield)) or ((1257 - (5 + 349)) >= (14529 - 11470))) then
								if (v24(v118.EarthShieldFocus, not v17:IsSpellInRange(v117.EarthShield)) or ((5247 - (266 + 1005)) < (1883 + 974))) then
									return "earth_shield_tank main fight";
								end
							end
							v143 = v126();
							v241 = 6 - 4;
						end
						if (((6490 - 1560) > (4003 - (561 + 1135))) and (v241 == (2 - 0))) then
							if (v143 or ((13299 - 9253) < (2357 - (507 + 559)))) then
								return v143;
							end
							if (v33 or ((10641 - 6400) == (10963 - 7418))) then
								v143 = v128();
								if (v143 or ((4436 - (212 + 176)) > (5137 - (250 + 655)))) then
									return v143;
								end
								v143 = v129();
								if (v143 or ((4772 - 3022) >= (6068 - 2595))) then
									return v143;
								end
							end
							v241 = 4 - 1;
						end
						if (((5122 - (1869 + 87)) == (10980 - 7814)) and ((1901 - (484 + 1417)) == v241)) then
							if (((3778 - 2015) < (6240 - 2516)) and v32) then
								if (((830 - (48 + 725)) <= (4447 - 1724)) and v17 and v43) then
									if ((v117.PurifySpirit:IsReady() and v121.DispellableFriendlyUnit(66 - 41)) or ((1204 + 866) == (1183 - 740))) then
										if (v24(v118.PurifySpiritFocus, not v17:IsSpellInRange(v117.PurifySpirit)) or ((758 + 1947) == (406 + 987))) then
											return "purify_spirit dispel";
										end
									end
								end
							end
							if (((v17:HealthPercentage() < v78) and v17:BuffDown(v117.Riptide)) or ((5454 - (152 + 701)) < (1372 - (430 + 881)))) then
								if (v117.PrimordialWave:IsCastable() or ((533 + 857) >= (5639 - (557 + 338)))) then
									if (v24(v118.PrimordialWaveFocus, not v17:IsSpellInRange(v117.PrimordialWave)) or ((593 + 1410) > (10803 - 6969))) then
										return "primordial_wave main";
									end
								end
							end
							v241 = 3 - 2;
						end
						if ((v241 == (7 - 4)) or ((335 - 179) > (4714 - (499 + 302)))) then
							if (((1061 - (39 + 827)) == (538 - 343)) and v34) then
								if (((6934 - 3829) >= (7133 - 5337)) and v121.TargetIsValid()) then
									local v249 = 0 - 0;
									while true do
										if (((375 + 4004) >= (6237 - 4106)) and (v249 == (0 + 0))) then
											v143 = v130();
											if (((6082 - 2238) >= (2147 - (103 + 1))) and v143) then
												return v143;
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
				break;
			end
		end
	end
	local function v134()
		v123();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(818 - (475 + 79), v133, v134);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

