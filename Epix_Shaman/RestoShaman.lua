local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((161 + 1303) <= (5423 - (82 + 964))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((3201 - (409 + 103)) < (4959 - (46 + 190))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 96 - (51 + 44);
		end
		if (((1167 + 2969) >= (3714 - (1114 + 203))) and (v5 == (727 - (228 + 498)))) then
			return v6(...);
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
	local v114 = 2408 + 8703;
	local v115 = 6139 + 4972;
	local v116;
	v10:RegisterForEvent(function()
		local v135 = 663 - (174 + 489);
		while true do
			if ((v135 == (0 - 0)) or ((6239 - (830 + 1075)) == (4769 - (303 + 221)))) then
				v114 = 12380 - (231 + 1038);
				v115 = 9259 + 1852;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v117 = v18.Shaman.Restoration;
	local v118 = v25.Shaman.Restoration;
	local v119 = v20.Shaman.Restoration;
	local v120 = {};
	local v121 = v22.Commons.Everyone;
	local v122 = v22.Commons.Shaman;
	local function v123()
		if (v117.ImprovedPurifySpirit:IsAvailable() or ((5438 - (171 + 991)) <= (12491 - 9460))) then
			v121.DispellableDebuffs = v21.MergeTable(v121.DispellableMagicDebuffs, v121.DispellableCurseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124(v136)
		return v136:DebuffRefreshable(v117.FlameShockDebuff) and (v115 > (13 - 8));
	end
	local function v125()
		if ((v89 and v117.AstralShift:IsReady()) or ((11933 - 7151) <= (960 + 239))) then
			if ((v13:HealthPercentage() <= v55) or ((17049 - 12185) < (5486 - 3584))) then
				if (((7799 - 2960) >= (11437 - 7737)) and v24(v117.AstralShift)) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v92 and v117.EarthElemental:IsReady()) or ((2323 - (111 + 1137)) > (2076 - (91 + 67)))) then
			if (((1178 - 782) <= (950 + 2854)) and ((v13:HealthPercentage() <= v63) or v121.IsTankBelowHealthPercentage(v64))) then
				if (v24(v117.EarthElemental) or ((4692 - (423 + 100)) == (16 + 2171))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((3892 - 2486) == (733 + 673)) and v119.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (((2302 - (326 + 445)) < (18638 - 14367)) and v24(v118.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((1414 - 779) == (1481 - 846)) and v38 and (v13:HealthPercentage() <= v39)) then
			if (((4084 - (530 + 181)) <= (4437 - (614 + 267))) and (v40 == "Refreshing Healing Potion")) then
				if (v119.RefreshingHealingPotion:IsReady() or ((3323 - (19 + 13)) < (5338 - 2058))) then
					if (((10220 - 5834) >= (2493 - 1620)) and v24(v118.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((240 + 681) <= (1937 - 835)) and (v40 == "Dreamwalker's Healing Potion")) then
				if (((9759 - 5053) >= (2775 - (1293 + 519))) and v119.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v118.RefreshingHealingPotion) or ((1958 - 998) <= (2287 - 1411))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v126()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (0 - 0)) or ((4866 - 2800) == (494 + 438))) then
				if (((985 + 3840) < (11252 - 6409)) and v41) then
					local v238 = 0 + 0;
					while true do
						if (((1 + 0) == v238) or ((2423 + 1454) >= (5633 - (709 + 387)))) then
							v29 = v121.HandleCharredTreant(v117.HealingSurge, v118.HealingSurgeMouseover, 1898 - (673 + 1185));
							if (v29 or ((12514 - 8199) < (5542 - 3816))) then
								return v29;
							end
							v238 = 2 - 0;
						end
						if ((v238 == (0 + 0)) or ((2749 + 930) < (843 - 218))) then
							v29 = v121.HandleCharredTreant(v117.Riptide, v118.RiptideMouseover, 10 + 30);
							if (v29 or ((9221 - 4596) < (1240 - 608))) then
								return v29;
							end
							v238 = 1881 - (446 + 1434);
						end
						if ((v238 == (1285 - (1040 + 243))) or ((247 - 164) > (3627 - (559 + 1288)))) then
							v29 = v121.HandleCharredTreant(v117.HealingWave, v118.HealingWaveMouseover, 1971 - (609 + 1322));
							if (((1000 - (13 + 441)) <= (4024 - 2947)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v42 or ((2608 - 1612) > (21420 - 17119))) then
					v29 = v121.HandleCharredBrambles(v117.Riptide, v118.RiptideMouseover, 2 + 38);
					if (((14781 - 10711) > (245 + 442)) and v29) then
						return v29;
					end
					v29 = v121.HandleCharredBrambles(v117.HealingSurge, v118.HealingSurgeMouseover, 18 + 22);
					if (v29 or ((1946 - 1290) >= (1823 + 1507))) then
						return v29;
					end
					v29 = v121.HandleCharredBrambles(v117.HealingWave, v118.HealingWaveMouseover, 73 - 33);
					if (v29 or ((1648 + 844) <= (187 + 148))) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v127()
		if (((3106 + 1216) >= (2152 + 410)) and v107 and ((v31 and v106) or not v106)) then
			local v202 = 0 + 0;
			while true do
				if (((433 - (153 + 280)) == v202) or ((10501 - 6864) >= (3385 + 385))) then
					v29 = v121.HandleTopTrinket(v120, v31, 16 + 24, nil);
					if (v29 or ((1245 + 1134) > (4155 + 423))) then
						return v29;
					end
					v202 = 1 + 0;
				end
				if ((v202 == (1 - 0)) or ((299 + 184) > (1410 - (89 + 578)))) then
					v29 = v121.HandleBottomTrinket(v120, v31, 29 + 11, nil);
					if (((5101 - 2647) > (1627 - (572 + 477))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((126 + 804) < (2676 + 1782)) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
			if (((80 + 582) <= (1058 - (84 + 2))) and (v17:HealthPercentage() <= v79)) then
				if (((7202 - 2832) == (3149 + 1221)) and v24(v118.RiptideFocus)) then
					return "riptide healingcd";
				end
			end
		end
		if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((5604 - (497 + 345)) <= (23 + 838))) then
			if (((v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) or ((239 + 1173) == (5597 - (605 + 728)))) then
				if (v24(v118.RiptideFocus) or ((2261 + 907) < (4786 - 2633))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v121.AreUnitsBelowHealthPercentage(v82, v81) and v117.SpiritLinkTotem:IsReady()) or ((229 + 4747) < (4924 - 3592))) then
			if (((4173 + 455) == (12822 - 8194)) and (v83 == "Player")) then
				if (v24(v118.SpiritLinkTotemPlayer) or ((41 + 13) == (884 - (457 + 32)))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((35 + 47) == (1484 - (832 + 570))) and (v83 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((548 + 33) < (74 + 208))) then
					if (v24(v118.SpiritLinkTotemCursor, not v15:IsInRange(141 - 101)) or ((2221 + 2388) < (3291 - (588 + 208)))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif (((3104 - 1952) == (2952 - (884 + 916))) and (v83 == "Confirmation")) then
				if (((3969 - 2073) <= (1985 + 1437)) and v24(v117.SpiritLinkTotem)) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if ((v96 and v121.AreUnitsBelowHealthPercentage(v75, v74) and v117.HealingTideTotem:IsReady()) or ((1643 - (232 + 421)) > (3509 - (1569 + 320)))) then
			if (v24(v117.HealingTideTotem) or ((216 + 661) > (892 + 3803))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((9068 - 6377) >= (2456 - (316 + 289))) and v121.AreUnitsBelowHealthPercentage(v51, v50) and v117.AncestralProtectionTotem:IsReady()) then
			if ((v52 == "Player") or ((7813 - 4828) >= (225 + 4631))) then
				if (((5729 - (666 + 787)) >= (1620 - (360 + 65))) and v24(v118.AncestralProtectionTotemPlayer)) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((3021 + 211) <= (4944 - (79 + 175))) and (v52 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1412 - 516) >= (2455 + 691))) then
					if (((9382 - 6321) >= (5696 - 2738)) and v24(v118.AncestralProtectionTotemCursor, not v15:IsInRange(939 - (503 + 396)))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((3368 - (92 + 89)) >= (1249 - 605)) and (v52 == "Confirmation")) then
				if (((331 + 313) <= (417 + 287)) and v24(v117.AncestralProtectionTotem)) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((3751 - 2793) > (130 + 817)) and v87 and v121.AreUnitsBelowHealthPercentage(v49, v48) and v117.AncestralGuidance:IsReady()) then
			if (((10242 - 5750) >= (2316 + 338)) and v24(v117.AncestralGuidance)) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((1645 + 1797) >= (4577 - 3074)) and v88 and v121.AreUnitsBelowHealthPercentage(v54, v53) and v117.Ascendance:IsReady()) then
			if (v24(v117.Ascendance) or ((396 + 2774) <= (2232 - 768))) then
				return "ascendance cooldowns";
			end
		end
		if ((v98 and (v13:Mana() <= v77) and v117.ManaTideTotem:IsReady()) or ((6041 - (485 + 759)) == (10153 - 5765))) then
			if (((1740 - (442 + 747)) <= (1816 - (832 + 303))) and v24(v117.ManaTideTotem)) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((4223 - (88 + 858)) > (125 + 282)) and v35 and ((v105 and v31) or not v105)) then
			local v203 = 0 + 0;
			while true do
				if (((194 + 4501) >= (2204 - (766 + 23))) and (v203 == (4 - 3))) then
					if (v117.Berserking:IsReady() or ((4392 - 1180) <= (2486 - 1542))) then
						if (v24(v117.Berserking) or ((10507 - 7411) <= (2871 - (1036 + 37)))) then
							return "Berserking cooldowns";
						end
					end
					if (((2508 + 1029) == (6887 - 3350)) and v117.BloodFury:IsReady()) then
						if (((3019 + 818) >= (3050 - (641 + 839))) and v24(v117.BloodFury)) then
							return "BloodFury cooldowns";
						end
					end
					v203 = 915 - (910 + 3);
				end
				if ((v203 == (0 - 0)) or ((4634 - (1466 + 218)) == (1752 + 2060))) then
					if (((5871 - (556 + 592)) >= (825 + 1493)) and v117.AncestralCall:IsReady()) then
						if (v24(v117.AncestralCall) or ((2835 - (329 + 479)) > (3706 - (174 + 680)))) then
							return "AncestralCall cooldowns";
						end
					end
					if (v117.BagofTricks:IsReady() or ((3903 - 2767) > (8947 - 4630))) then
						if (((3390 + 1358) == (5487 - (396 + 343))) and v24(v117.BagofTricks)) then
							return "BagofTricks cooldowns";
						end
					end
					v203 = 1 + 0;
				end
				if (((5213 - (29 + 1448)) <= (6129 - (135 + 1254))) and (v203 == (7 - 5))) then
					if (v117.Fireblood:IsReady() or ((15828 - 12438) <= (2040 + 1020))) then
						if (v24(v117.Fireblood) or ((2526 - (389 + 1138)) > (3267 - (102 + 472)))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
			end
		end
	end
	local function v128()
		if (((437 + 26) < (334 + 267)) and v90 and v121.AreUnitsBelowHealthPercentage(84 + 6, 1548 - (320 + 1225)) and v117.ChainHeal:IsReady() and v13:BuffUp(v117.HighTide)) then
			if (v24(v118.ChainHealFocus, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((3886 - 1703) < (421 + 266))) then
				return "chain_heal healingaoe";
			end
		end
		if (((6013 - (157 + 1307)) == (6408 - (821 + 1038))) and v97 and (v17:HealthPercentage() <= v76) and v117.HealingWave:IsReady() and (v117.PrimordialWave:TimeSinceLastCast() < (37 - 22))) then
			if (((511 + 4161) == (8298 - 3626)) and v24(v118.HealingWaveFocus, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe";
			end
		end
		if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((1365 + 2303) < (979 - 584))) then
			if ((v17:HealthPercentage() <= v79) or ((5192 - (834 + 192)) == (29 + 426))) then
				if (v24(v118.RiptideFocus) or ((1142 + 3307) == (58 + 2605))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((6625 - 2348) < (3293 - (300 + 4)))) then
			if (((v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) or ((233 + 637) >= (10860 - 6711))) then
				if (((2574 - (112 + 250)) < (1269 + 1914)) and v24(v118.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if (((11639 - 6993) > (1715 + 1277)) and v101 and v117.UnleashLife:IsReady()) then
			if (((742 + 692) < (2323 + 783)) and (v17:HealthPercentage() <= v86)) then
				if (((390 + 396) < (2246 + 777)) and v24(v117.UnleashLife)) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v70 == "Cursor") and v117.HealingRain:IsReady()) or ((3856 - (1001 + 413)) < (164 - 90))) then
			if (((5417 - (244 + 638)) == (5228 - (627 + 66))) and v24(v118.HealingRainCursor, not v15:IsInRange(119 - 79), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v121.AreUnitsBelowHealthPercentage(v69, v68) and v117.HealingRain:IsReady()) or ((3611 - (512 + 90)) <= (4011 - (1665 + 241)))) then
			if (((2547 - (373 + 344)) < (1655 + 2014)) and (v70 == "Player")) then
				if (v24(v118.HealingRainPlayer, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((379 + 1051) >= (9527 - 5915))) then
					return "healing_rain healingaoe";
				end
			elseif (((4539 - 1856) >= (3559 - (35 + 1064))) and (v70 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1313 + 491) >= (7006 - 3731))) then
					if (v24(v118.HealingRainCursor, not v15:IsInRange(1 + 39), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2653 - (298 + 938)) > (4888 - (233 + 1026)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((6461 - (636 + 1030)) > (206 + 196)) and (v70 == "Enemy under Cursor")) then
				if (((4702 + 111) > (1060 + 2505)) and v16:Exists() and v13:CanAttack(v16)) then
					if (((265 + 3647) == (4133 - (55 + 166))) and v24(v118.HealingRainCursor, not v15:IsInRange(8 + 32), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((284 + 2537) <= (18423 - 13599)) and (v70 == "Confirmation")) then
				if (((2035 - (36 + 261)) <= (3838 - 1643)) and v24(v117.HealingRain, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((1409 - (34 + 1334)) <= (1161 + 1857)) and v121.AreUnitsBelowHealthPercentage(v66, v65) and v117.EarthenWallTotem:IsReady()) then
			if (((1667 + 478) <= (5387 - (1035 + 248))) and (v67 == "Player")) then
				if (((2710 - (20 + 1)) < (2525 + 2320)) and v24(v118.EarthenWallTotemPlayer)) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v67 == "Friendly under Cursor") or ((2641 - (134 + 185)) > (3755 - (549 + 584)))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((5219 - (314 + 371)) == (7147 - 5065))) then
					if (v24(v118.EarthenWallTotemCursor, not v15:IsInRange(1008 - (478 + 490))) or ((833 + 738) > (3039 - (786 + 386)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v67 == "Confirmation") or ((8596 - 5942) >= (4375 - (1055 + 324)))) then
				if (((5318 - (1093 + 247)) > (1870 + 234)) and v24(v117.EarthenWallTotem)) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((315 + 2680) > (6118 - 4577)) and v121.AreUnitsBelowHealthPercentage(v61, v60) and v117.Downpour:IsReady()) then
			if (((11026 - 7777) > (2711 - 1758)) and (v62 == "Player")) then
				if (v24(v118.DownpourPlayer, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((8224 - 4951) > (1627 + 2946))) then
					return "downpour healingaoe";
				end
			elseif ((v62 == "Friendly under Cursor") or ((12138 - 8987) < (4425 - 3141))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1395 + 455) == (3909 - 2380))) then
					if (((1509 - (364 + 324)) < (5819 - 3696)) and v24(v118.DownpourCursor, not v15:IsInRange(95 - 55), v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif (((299 + 603) < (9728 - 7403)) and (v62 == "Confirmation")) then
				if (((1373 - 515) <= (8995 - 6033)) and v24(v117.Downpour, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if ((v91 and v121.AreUnitsBelowHealthPercentage(v59, v58) and v117.CloudburstTotem:IsReady()) or ((5214 - (1249 + 19)) < (1163 + 125))) then
			if (v24(v117.CloudburstTotem) or ((12619 - 9377) == (1653 - (686 + 400)))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v102 and v121.AreUnitsBelowHealthPercentage(v104, v103) and v117.Wellspring:IsReady()) or ((665 + 182) >= (1492 - (73 + 156)))) then
			if (v24(v117.Wellspring, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((11 + 2242) == (2662 - (721 + 90)))) then
				return "wellspring healingaoe";
			end
		end
		if ((v90 and v121.AreUnitsBelowHealthPercentage(v57, v56) and v117.ChainHeal:IsReady()) or ((24 + 2063) > (7701 - 5329))) then
			if (v24(v118.ChainHealFocus, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((4915 - (224 + 246)) < (6720 - 2571))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v100 and v13:IsMoving() and v121.AreUnitsBelowHealthPercentage(v85, v84) and v117.SpiritwalkersGrace:IsReady()) or ((3346 - 1528) == (16 + 69))) then
			if (((15 + 615) < (1563 + 564)) and v24(v117.SpiritwalkersGrace)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v94 and v121.AreUnitsBelowHealthPercentage(v72, v71) and v117.HealingStreamTotem:IsReady()) or ((3852 - 1914) == (8365 - 5851))) then
			if (((4768 - (203 + 310)) >= (2048 - (1238 + 755))) and v24(v117.HealingStreamTotem)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v129()
		if (((210 + 2789) > (2690 - (709 + 825))) and v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) then
			if (((4330 - 1980) > (1682 - 527)) and (v17:HealthPercentage() <= v79)) then
				if (((4893 - (196 + 668)) <= (19160 - 14307)) and v24(v118.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((1068 - 552) > (4267 - (171 + 662)))) then
			if (((4139 - (4 + 89)) >= (10630 - 7597)) and (v17:HealthPercentage() <= v80) and (v121.UnitGroupRole(v17) == "TANK")) then
				if (v24(v118.RiptideFocus) or ((991 + 1728) <= (6355 - 4908))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v13:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v17:BuffDown(v117.Riptide)) or ((1622 + 2512) < (5412 - (35 + 1451)))) then
			if ((v17:HealthPercentage() <= v79) or (v17:HealthPercentage() <= v79) or ((1617 - (28 + 1425)) >= (4778 - (941 + 1052)))) then
				if (v24(v118.RiptideFocus) or ((504 + 21) == (3623 - (822 + 692)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((46 - 13) == (16 + 17)) and v117.ElementalOrbit:IsAvailable() and v13:BuffDown(v117.EarthShieldBuff)) then
			if (((3351 - (45 + 252)) <= (3973 + 42)) and v24(v117.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((644 + 1227) < (8230 - 4848)) and v117.ElementalOrbit:IsAvailable() and v13:BuffUp(v117.EarthShieldBuff)) then
			if (((1726 - (114 + 319)) <= (3109 - 943)) and v121.IsSoloMode()) then
				if ((v117.LightningShield:IsReady() and v13:BuffDown(v117.LightningShield)) or ((3303 - 724) < (79 + 44))) then
					if (v24(v117.LightningShield) or ((1260 - 414) >= (4961 - 2593))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v117.WaterShield:IsReady() and v13:BuffDown(v117.WaterShield)) or ((5975 - (556 + 1407)) <= (4564 - (741 + 465)))) then
				if (((1959 - (170 + 295)) <= (1584 + 1421)) and v24(v117.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v95 and v117.HealingSurge:IsReady()) or ((2858 + 253) == (5253 - 3119))) then
			if (((1953 + 402) == (1511 + 844)) and (v17:HealthPercentage() <= v73)) then
				if (v24(v118.HealingSurgeFocus, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((333 + 255) <= (1662 - (957 + 273)))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((1283 + 3514) >= (1560 + 2335)) and v97 and v117.HealingWave:IsReady()) then
			if (((13629 - 10052) == (9426 - 5849)) and (v17:HealthPercentage() <= v76)) then
				if (((11588 - 7794) > (18286 - 14593)) and v24(v118.HealingWaveFocus, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v130()
		if (v117.FlameShock:IsReady() or ((3055 - (389 + 1391)) == (2573 + 1527))) then
			if (v121.CastCycle(v117.FlameShock, v13:GetEnemiesInRange(5 + 35), v124, not v15:IsSpellInRange(v117.FlameShock), nil, nil, nil, nil) or ((3621 - 2030) >= (4531 - (783 + 168)))) then
				return "flame_shock_cycle damage";
			end
			if (((3298 - 2315) <= (1779 + 29)) and v24(v117.FlameShock, not v15:IsSpellInRange(v117.FlameShock))) then
				return "flame_shock damage";
			end
		end
		if (v117.LavaBurst:IsReady() or ((2461 - (309 + 2)) <= (3675 - 2478))) then
			if (((4981 - (1090 + 122)) >= (381 + 792)) and v24(v117.LavaBurst, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "lava_burst damage";
			end
		end
		if (((4987 - 3502) == (1017 + 468)) and v117.Stormkeeper:IsReady()) then
			if (v24(v117.Stormkeeper) or ((4433 - (628 + 490)) <= (499 + 2283))) then
				return "stormkeeper damage";
			end
		end
		if ((#v13:GetEnemiesInRange(99 - 59) < (13 - 10)) or ((1650 - (431 + 343)) >= (5985 - 3021))) then
			if (v117.LightningBolt:IsReady() or ((6456 - 4224) > (1973 + 524))) then
				if (v24(v117.LightningBolt, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((270 + 1840) <= (2027 - (556 + 1139)))) then
					return "lightning_bolt damage";
				end
			end
		elseif (((3701 - (6 + 9)) > (581 + 2591)) and v117.ChainLightning:IsReady()) then
			if (v24(v117.ChainLightning, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2292 + 2182) < (989 - (28 + 141)))) then
				return "chain_lightning damage";
			end
		end
	end
	local function v131()
		v50 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v51 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v52 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v56 = EpicSettings.Settings['ChainHealGroup'];
		v57 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v60 = EpicSettings.Settings['DownpourGroup'];
		v61 = EpicSettings.Settings['DownpourHP'];
		v62 = EpicSettings.Settings['DownpourUsage'];
		v65 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v66 = EpicSettings.Settings['EarthenWallTotemHP'];
		v67 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v39 = EpicSettings.Settings['HealingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v68 = EpicSettings.Settings['HealingRainGroup'];
		v69 = EpicSettings.Settings['HealingRainHP'];
		v70 = EpicSettings.Settings['HealingRainUsage'];
		v71 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v72 = EpicSettings.Settings['HealingStreamTotemHP'];
		v73 = EpicSettings.Settings['HealingSurgeHP'];
		v74 = EpicSettings.Settings['HealingTideTotemGroup'];
		v75 = EpicSettings.Settings['HealingTideTotemHP'];
		v76 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v47 = EpicSettings.Settings['InterruptThreshold'];
		v45 = EpicSettings.Settings['InterruptWithStun'];
		v79 = EpicSettings.Settings['RiptideHP'];
		v80 = EpicSettings.Settings['RiptideTankHP'];
		v81 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v82 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v83 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v84 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v85 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v86 = EpicSettings.Settings['UnleashLifeHP'];
		v90 = EpicSettings.Settings['UseChainHeal'];
		v91 = EpicSettings.Settings['UseCloudburstTotem'];
		v93 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['UseHealingPotion'];
		v94 = EpicSettings.Settings['UseHealingStreamTotem'];
		v95 = EpicSettings.Settings['UseHealingSurge'];
		v96 = EpicSettings.Settings['UseHealingTideTotem'];
		v97 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v99 = EpicSettings.Settings['UseRiptide'];
		v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v101 = EpicSettings.Settings['UseUnleashLife'];
		v111 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v112 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v132()
		local v190 = 0 + 0;
		while true do
			if (((5281 - 1002) >= (2042 + 840)) and (v190 == (1324 - (486 + 831)))) then
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v190 = 20 - 12;
			end
			if (((21 - 15) == v190) or ((384 + 1645) >= (11133 - 7612))) then
				v103 = EpicSettings.Settings['WellspringGroup'];
				v104 = EpicSettings.Settings['WellspringHP'];
				v105 = EpicSettings.Settings['racialsWithCD'];
				v190 = 1270 - (668 + 595);
			end
			if ((v190 == (1 + 0)) or ((411 + 1626) >= (12659 - 8017))) then
				v54 = EpicSettings.Settings['AscendanceHP'];
				v55 = EpicSettings.Settings['AstralShiftHP'];
				v58 = EpicSettings.Settings['CloudburstTotemGroup'];
				v190 = 292 - (23 + 267);
			end
			if (((3664 - (1129 + 815)) < (4845 - (371 + 16))) and (v190 == (1753 - (1326 + 424)))) then
				v77 = EpicSettings.Settings['ManaTideTotemMana'];
				v78 = EpicSettings.Settings['PrimordialWaveHP'];
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v190 = 7 - 3;
			end
			if (((18 - 13) == v190) or ((554 - (88 + 30)) > (3792 - (720 + 51)))) then
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v35 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['UseWellspring'];
				v190 = 13 - 7;
			end
			if (((2489 - (421 + 1355)) <= (1396 - 549)) and (v190 == (1 + 1))) then
				v59 = EpicSettings.Settings['CloudburstTotemHP'];
				v63 = EpicSettings.Settings['EarthElementalHP'];
				v64 = EpicSettings.Settings['EarthElementalTankHP'];
				v190 = 1086 - (286 + 797);
			end
			if (((7874 - 5720) <= (6676 - 2645)) and (v190 == (448 - (397 + 42)))) then
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v113 = EpicSettings.Settings['usePurgeTarget'];
				break;
			end
			if (((1442 + 3173) == (5415 - (24 + 776))) and (v190 == (0 - 0))) then
				v48 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v49 = EpicSettings.Settings['AncestralGuidanceHP'];
				v53 = EpicSettings.Settings['AscendanceGroup'];
				v190 = 786 - (222 + 563);
			end
			if ((v190 == (8 - 4)) or ((2729 + 1061) == (690 - (23 + 167)))) then
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v190 = 1803 - (690 + 1108);
			end
			if (((33 + 56) < (183 + 38)) and (v190 == (856 - (40 + 808)))) then
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v190 = 2 + 7;
			end
		end
	end
	local function v133()
		v131();
		v132();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		if (((7854 - 5800) >= (1359 + 62)) and v13:IsDeadOrGhost()) then
			return;
		end
		if (((367 + 325) < (1677 + 1381)) and (v13:AffectingCombat() or v30)) then
			local v204 = 571 - (47 + 524);
			local v205;
			while true do
				if ((v204 == (1 + 0)) or ((8894 - 5640) == (2474 - 819))) then
					if (not v17:BuffRefreshable(v117.EarthShield) or (v121.UnitGroupRole(v17) ~= "TANK") or not v93 or ((2955 - 1659) == (6636 - (1165 + 561)))) then
						local v239 = 0 + 0;
						while true do
							if (((10431 - 7063) == (1286 + 2082)) and (v239 == (479 - (341 + 138)))) then
								v29 = v121.FocusUnit(v205, nil, nil, nil);
								if (((714 + 1929) < (7873 - 4058)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					break;
				end
				if (((2239 - (89 + 237)) > (1585 - 1092)) and (v204 == (0 - 0))) then
					v205 = v43 and v117.PurifySpirit:IsReady() and v32;
					if (((5636 - (581 + 300)) > (4648 - (855 + 365))) and v117.EarthShield:IsReady() and v93 and (v121.FriendlyUnitsWithBuffCount(v117.EarthShield, true) < (2 - 1))) then
						local v240 = 0 + 0;
						while true do
							if (((2616 - (1030 + 205)) <= (2225 + 144)) and (v240 == (0 + 0))) then
								v29 = v121.FocusUnitRefreshableBuff(v117.EarthShield, 301 - (156 + 130), 90 - 50, "TANK");
								if (v29 or ((8162 - 3319) == (8364 - 4280))) then
									return v29;
								end
								break;
							end
						end
					end
					v204 = 1 + 0;
				end
			end
		end
		if (((2723 + 1946) > (432 - (10 + 59))) and v117.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(12 + 28) and (v121.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v117.EarthShield))) then
			if (v24(v118.EarthShieldFocus) or ((9243 - 7366) >= (4301 - (671 + 492)))) then
				return "earth_shield_tank main apl";
			end
		end
		local v196;
		if (((3775 + 967) >= (4841 - (369 + 846))) and not v13:AffectingCombat() and v30) then
			if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1202 + 3338) == (782 + 134))) then
				local v237 = v121.DeadFriendlyUnitsCount();
				if ((v237 > (1946 - (1036 + 909))) or ((920 + 236) > (7294 - 2949))) then
					if (((2440 - (11 + 192)) < (2148 + 2101)) and v24(v117.AncestralVision, nil, v13:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "ancestral_vision";
					end
				elseif (v24(v118.AncestralSpiritMouseover, not v15:IsInRange(215 - (135 + 40)), v13:BuffDown(v117.SpiritwalkersGraceBuff)) or ((6500 - 3817) < (14 + 9))) then
					return "ancestral_spirit";
				end
			end
		end
		if (((1535 - 838) <= (1237 - 411)) and v13:AffectingCombat() and v121.TargetIsValid()) then
			local v206 = 176 - (50 + 126);
			while true do
				if (((3076 - 1971) <= (261 + 915)) and (v206 == (1416 - (1233 + 180)))) then
					v29 = v121.InterruptWithStunCursor(v117.CapacitorTotem, v118.CapacitorTotemCursor, 999 - (522 + 447), nil, v16);
					if (((4800 - (107 + 1314)) <= (1769 + 2043)) and v29) then
						return v29;
					end
					if (v110 or ((2400 - 1612) >= (687 + 929))) then
						local v241 = 0 - 0;
						while true do
							if (((7335 - 5481) <= (5289 - (716 + 1194))) and (v241 == (0 + 0))) then
								v29 = v121.HandleIncorporeal(v117.Hex, v118.HexMouseOver, 4 + 26, true);
								if (((5052 - (74 + 429)) == (8774 - 4225)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					v206 = 2 + 2;
				end
				if ((v206 == (8 - 4)) or ((2138 + 884) >= (9322 - 6298))) then
					if (((11917 - 7097) > (2631 - (279 + 154))) and v109) then
						local v242 = 778 - (454 + 324);
						while true do
							if ((v242 == (1 + 0)) or ((1078 - (12 + 5)) >= (2638 + 2253))) then
								if (((3475 - 2111) <= (1653 + 2820)) and v111) then
									v29 = v121.HandleAfflicted(v117.TremorTotem, v117.TremorTotem, 1123 - (277 + 816));
									if (v29 or ((15361 - 11766) <= (1186 - (1058 + 125)))) then
										return v29;
									end
								end
								if (v112 or ((876 + 3796) == (4827 - (815 + 160)))) then
									local v246 = 0 - 0;
									while true do
										if (((3700 - 2141) == (372 + 1187)) and (v246 == (0 - 0))) then
											v29 = v121.HandleAfflicted(v117.PoisonCleansingTotem, v117.PoisonCleansingTotem, 1928 - (41 + 1857));
											if (v29 or ((3645 - (1222 + 671)) <= (2036 - 1248))) then
												return v29;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v242 == (0 - 0)) or ((5089 - (229 + 953)) == (1951 - (1111 + 663)))) then
								v29 = v121.HandleAfflicted(v117.PurifySpirit, v118.PurifySpiritMouseover, 1609 - (874 + 705));
								if (((486 + 2984) > (379 + 176)) and v29) then
									return v29;
								end
								v242 = 1 - 0;
							end
						end
					end
					v196 = v125();
					if (v196 or ((28 + 944) == (1324 - (642 + 37)))) then
						return v196;
					end
					v206 = 2 + 3;
				end
				if (((510 + 2672) >= (5310 - 3195)) and ((459 - (233 + 221)) == v206)) then
					if (((9002 - 5109) < (3899 + 530)) and (v115 > v108)) then
						v196 = v127();
						if (v196 or ((4408 - (718 + 823)) < (1199 + 706))) then
							return v196;
						end
					end
					if (((v17:HealthPercentage() < v78) and v17:BuffDown(v117.Riptide)) or ((2601 - (266 + 539)) >= (11469 - 7418))) then
						if (((2844 - (636 + 589)) <= (8915 - 5159)) and v117.PrimordialWave:IsReady()) then
							if (((1245 - 641) == (479 + 125)) and v24(v118.PrimordialWaveFocus)) then
								return "primordial_wave main";
							end
						end
					end
					break;
				end
				if ((v206 == (0 + 0)) or ((5499 - (657 + 358)) == (2382 - 1482))) then
					v116 = v13:GetEnemiesInRange(91 - 51);
					v114 = v10.BossFightRemains(nil, true);
					v115 = v114;
					v206 = 1188 - (1151 + 36);
				end
				if ((v206 == (2 + 0)) or ((1173 + 3286) <= (3323 - 2210))) then
					if (((5464 - (1552 + 280)) > (4232 - (64 + 770))) and v29) then
						return v29;
					end
					v29 = v121.InterruptCursor(v117.WindShear, v118.WindShearMouseover, 21 + 9, true, v16);
					if (((9266 - 5184) <= (874 + 4043)) and v29) then
						return v29;
					end
					v206 = 1246 - (157 + 1086);
				end
				if (((9671 - 4839) >= (6070 - 4684)) and (v206 == (1 - 0))) then
					if (((186 - 49) == (956 - (599 + 220))) and (v115 == (22126 - 11015))) then
						v115 = v10.FightRemains(v116, false);
					end
					if ((v117.EarthShield:IsCastable() and v93 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(1971 - (1813 + 118)) and (v121.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v117.EarthShield)) or ((1148 + 422) >= (5549 - (841 + 376)))) then
						if (v24(v118.EarthShieldFocus) or ((5694 - 1630) <= (423 + 1396))) then
							return "earth_shield_tank main fight";
						end
					end
					v29 = v121.Interrupt(v117.WindShear, 81 - 51, true);
					v206 = 861 - (464 + 395);
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((12796 - 7810) < (756 + 818))) then
			local v207 = 837 - (467 + 370);
			while true do
				if (((9145 - 4719) > (127 + 45)) and (v207 == (0 - 0))) then
					if (((92 + 494) > (1058 - 603)) and v32) then
						local v243 = 520 - (150 + 370);
						while true do
							if (((2108 - (74 + 1208)) == (2031 - 1205)) and (v243 == (0 - 0))) then
								if ((v17 and v43) or ((2860 + 1159) > (4831 - (14 + 376)))) then
									if (((3498 - 1481) < (2758 + 1503)) and v117.PurifySpirit:IsReady() and v121.DispellableFriendlyUnit()) then
										if (((4143 + 573) > (77 + 3)) and v24(v118.PurifySpiritFocus)) then
											return "purify_spirit dispel";
										end
									end
								end
								if ((v44 and v113) or ((10275 - 6768) == (2462 + 810))) then
									local v247 = 78 - (23 + 55);
									while true do
										if ((v247 == (0 - 0)) or ((585 + 291) >= (2762 + 313))) then
											if (((6747 - 2395) > (804 + 1750)) and v117.GreaterPurge:IsAvailable() and v117.GreaterPurge:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v121.UnitHasMagicBuff(v15)) then
												if (v24(v117.GreaterPurge, not v15:IsSpellInRange(v117.Purge)) or ((5307 - (652 + 249)) < (10819 - 6776))) then
													return "purge dispel";
												end
											end
											if ((v117.Purge:IsAvailable() and v117.Purge:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v121.UnitHasMagicBuff(v15)) or ((3757 - (708 + 1160)) >= (9182 - 5799))) then
												if (((3448 - 1556) <= (2761 - (10 + 17))) and v24(v117.Purge, not v15:IsSpellInRange(v117.Purge))) then
													return "purge dispel";
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
					v196 = v126();
					v207 = 1 + 0;
				end
				if (((3655 - (1400 + 332)) < (4254 - 2036)) and (v207 == (1909 - (242 + 1666)))) then
					if (((930 + 1243) > (139 + 240)) and v196) then
						return v196;
					end
					if (v33 or ((2209 + 382) == (4349 - (850 + 90)))) then
						local v244 = 0 - 0;
						while true do
							if (((5904 - (360 + 1030)) > (2942 + 382)) and (v244 == (0 - 0))) then
								v196 = v128();
								if (v196 or ((285 - 77) >= (6489 - (909 + 752)))) then
									return v196;
								end
								v244 = 1224 - (109 + 1114);
							end
							if ((v244 == (1 - 0)) or ((617 + 966) > (3809 - (6 + 236)))) then
								v196 = v129();
								if (v196 or ((828 + 485) == (640 + 154))) then
									return v196;
								end
								break;
							end
						end
					end
					v207 = 4 - 2;
				end
				if (((5543 - 2369) > (4035 - (1076 + 57))) and (v207 == (1 + 1))) then
					if (((4809 - (579 + 110)) <= (337 + 3923)) and v34) then
						if (v121.TargetIsValid() or ((781 + 102) > (2536 + 2242))) then
							local v245 = 407 - (174 + 233);
							while true do
								if ((v245 == (0 - 0)) or ((6353 - 2733) >= (2175 + 2716))) then
									v196 = v130();
									if (((5432 - (663 + 511)) > (836 + 101)) and v196) then
										return v196;
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
	end
	local function v134()
		local v197 = 0 + 0;
		while true do
			if ((v197 == (0 - 0)) or ((2949 + 1920) < (2132 - 1226))) then
				v123();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(638 - 374, v133, v134);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

