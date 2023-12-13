local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1328 + 1041) == (6038 - 3669)) and not v5) then
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
	local v111;
	local v112;
	local v113;
	local v114 = 11498 - (370 + 17);
	local v115 = 12402 - (783 + 508);
	local v116;
	v9:RegisterForEvent(function()
		local v135 = 1772 - (1733 + 39);
		while true do
			if (((11252 - 7157) >= (4217 - (125 + 909))) and (v135 == (1948 - (1096 + 852)))) then
				v114 = 4985 + 6126;
				v115 = 15867 - 4756;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v117 = v17.Shaman.Restoration;
	local v118 = v24.Shaman.Restoration;
	local v119 = v19.Shaman.Restoration;
	local v120 = {};
	local v121 = v21.Commons.Everyone;
	local v122 = v21.Commons.Shaman;
	local function v123()
		if (v117.ImprovedPurifySpirit:IsAvailable() or ((3600 + 111) < (1520 - (409 + 103)))) then
			v121.DispellableDebuffs = v20.MergeTable(v121.DispellableMagicDebuffs, v121.DispellableCurseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124(v136)
		return v136:DebuffRefreshable(v117.FlameShockDebuff) and (v115 > (241 - (46 + 190)));
	end
	local function v125()
		local v137 = 95 - (51 + 44);
		while true do
			if ((v137 == (0 + 0)) or ((2366 - (1114 + 203)) <= (1632 - (228 + 498)))) then
				if (((978 + 3535) > (1507 + 1219)) and v89 and v117.AstralShift:IsReady()) then
					if ((v12:HealthPercentage() <= v54) or ((2144 - (174 + 489)) >= (6924 - 4266))) then
						if (v23(v117.AstralShift) or ((5125 - (830 + 1075)) == (1888 - (303 + 221)))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v92 and v117.EarthElemental:IsReady()) or ((2323 - (231 + 1038)) > (2827 + 565))) then
					if ((v12:HealthPercentage() <= v62) or v121.IsTankBelowHealthPercentage(v63) or ((1838 - (171 + 991)) >= (6766 - 5124))) then
						if (((11105 - 6969) > (5981 - 3584)) and v23(v117.EarthElemental)) then
							return "earth_elemental defensives";
						end
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (3 - 2)) or ((12502 - 8168) == (6842 - 2597))) then
				if ((v119.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((13218 - 8942) <= (4279 - (111 + 1137)))) then
					if (v23(v118.Healthstone) or ((4940 - (91 + 67)) <= (3568 - 2369))) then
						return "healthstone defensive 3";
					end
				end
				if ((v37 and (v12:HealthPercentage() <= v38)) or ((1214 + 3650) < (2425 - (423 + 100)))) then
					if (((34 + 4805) >= (10244 - 6544)) and (v39 == "Refreshing Healing Potion")) then
						if (v119.RefreshingHealingPotion:IsReady() or ((561 + 514) > (2689 - (326 + 445)))) then
							if (((1728 - 1332) <= (8474 - 4670)) and v23(v118.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((9730 - 5561) == (2898 - (530 + 181)))) then
						if (((2287 - (614 + 267)) == (1438 - (19 + 13))) and v119.DreamwalkersHealingPotion:IsReady()) then
							if (((2491 - 960) < (9952 - 5681)) and v23(v118.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v138 = 0 - 0;
		while true do
			if (((165 + 470) == (1116 - 481)) and (v138 == (0 - 0))) then
				if (((5185 - (1293 + 519)) <= (7255 - 3699)) and v40) then
					v28 = v121.HandleCharredTreant(v117.Riptide, v118.RiptideMouseover, 104 - 64);
					if (v28 or ((6293 - 3002) < (14143 - 10863))) then
						return v28;
					end
					v28 = v121.HandleCharredTreant(v117.HealingSurge, v118.HealingSurgeMouseover, 94 - 54);
					if (((2324 + 2062) >= (179 + 694)) and v28) then
						return v28;
					end
					v28 = v121.HandleCharredTreant(v117.HealingWave, v118.HealingWaveMouseover, 92 - 52);
					if (((213 + 708) <= (367 + 735)) and v28) then
						return v28;
					end
				end
				if (((2941 + 1765) >= (2059 - (709 + 387))) and v41) then
					local v239 = 1858 - (673 + 1185);
					while true do
						if ((v239 == (2 - 1)) or ((3082 - 2122) <= (1440 - 564))) then
							v28 = v121.HandleCharredBrambles(v117.HealingSurge, v118.HealingSurgeMouseover, 29 + 11);
							if (v28 or ((1544 + 522) == (1257 - 325))) then
								return v28;
							end
							v239 = 1 + 1;
						end
						if (((9620 - 4795) < (9506 - 4663)) and (v239 == (1882 - (446 + 1434)))) then
							v28 = v121.HandleCharredBrambles(v117.HealingWave, v118.HealingWaveMouseover, 1323 - (1040 + 243));
							if (v28 or ((11571 - 7694) >= (6384 - (559 + 1288)))) then
								return v28;
							end
							break;
						end
						if ((v239 == (1931 - (609 + 1322))) or ((4769 - (13 + 441)) < (6449 - 4723))) then
							v28 = v121.HandleCharredBrambles(v117.Riptide, v118.RiptideMouseover, 104 - 64);
							if (v28 or ((18323 - 14644) < (24 + 601))) then
								return v28;
							end
							v239 = 3 - 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		if ((v107 and ((v30 and v106) or not v106)) or ((1643 + 2982) < (277 + 355))) then
			v28 = v121.HandleTopTrinket(v120, v30, 118 - 78, nil);
			if (v28 or ((46 + 37) > (3273 - 1493))) then
				return v28;
			end
			v28 = v121.HandleBottomTrinket(v120, v30, 27 + 13, nil);
			if (((304 + 242) <= (774 + 303)) and v28) then
				return v28;
			end
		end
		if ((v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(34 + 6) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (1 + 0))) or ((1429 - (153 + 280)) > (12419 - 8118))) then
			if (((3655 + 415) > (272 + 415)) and v23(v118.EarthShieldFocus)) then
				return "earth_shield_tank healingst";
			end
		end
		if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((344 + 312) >= (3022 + 308))) then
			if ((v16:HealthPercentage() <= v79) or ((1806 + 686) <= (510 - 175))) then
				if (((2672 + 1650) >= (3229 - (89 + 578))) and v23(v118.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((2599 + 1038) >= (7837 - 4067))) then
			if (((v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) or ((3428 - (572 + 477)) > (618 + 3960))) then
				if (v23(v118.RiptideFocus) or ((290 + 193) > (89 + 654))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((2540 - (84 + 2)) > (952 - 374)) and v121.AreUnitsBelowHealthPercentage(v82, v81) and v117.SpiritLinkTotem:IsReady()) then
			if (((670 + 260) < (5300 - (497 + 345))) and (v83 == "Player")) then
				if (((17 + 645) <= (165 + 807)) and v23(v118.SpiritLinkTotemPlayer)) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((5703 - (605 + 728)) == (3118 + 1252)) and (v83 == "Friendly under Cursor")) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((10586 - 5824) <= (40 + 821))) then
					if (v23(v118.SpiritLinkTotemCursor, not v14:IsInRange(147 - 107)) or ((1273 + 139) == (11813 - 7549))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v83 == "Confirmation") or ((2393 + 775) < (2642 - (457 + 32)))) then
				if (v23(v117.SpiritLinkTotem) or ((2112 + 2864) < (2734 - (832 + 570)))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((4360 + 268) == (1207 + 3421)) and v96 and v121.AreUnitsBelowHealthPercentage(v74, v73) and v117.HealingTideTotem:IsReady()) then
			if (v23(v117.HealingTideTotem) or ((190 - 136) == (191 + 204))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((878 - (588 + 208)) == (220 - 138)) and v121.AreUnitsBelowHealthPercentage(v50, v49) and v117.AncestralProtectionTotem:IsReady()) then
			if ((v51 == "Player") or ((2381 - (884 + 916)) < (589 - 307))) then
				if (v23(v118.AncestralProtectionTotemPlayer) or ((2673 + 1936) < (3148 - (232 + 421)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((3041 - (1569 + 320)) == (283 + 869)) and (v51 == "Friendly under Cursor")) then
				if (((361 + 1535) <= (11531 - 8109)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v118.AncestralProtectionTotemCursor, not v14:IsInRange(645 - (316 + 289))) or ((2591 - 1601) > (75 + 1545))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v51 == "Confirmation") or ((2330 - (666 + 787)) > (5120 - (360 + 65)))) then
				if (((2515 + 176) >= (2105 - (79 + 175))) and v23(v117.AncestralProtectionTotem)) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v87 and v121.AreUnitsBelowHealthPercentage(v48, v47) and v117.AncestralGuidance:IsReady()) or ((4706 - 1721) >= (3790 + 1066))) then
			if (((13106 - 8830) >= (2301 - 1106)) and v23(v117.AncestralGuidance)) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((4131 - (503 + 396)) <= (4871 - (92 + 89))) and v88 and v121.AreUnitsBelowHealthPercentage(v53, v52) and v117.Ascendance:IsReady()) then
			if (v23(v117.Ascendance) or ((1737 - 841) >= (1614 + 1532))) then
				return "ascendance cooldowns";
			end
		end
		if (((1812 + 1249) >= (11583 - 8625)) and v98 and (v12:Mana() <= v76) and v117.ManaTideTotem:IsReady()) then
			if (((436 + 2751) >= (1467 - 823)) and v23(v117.ManaTideTotem)) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((562 + 82) <= (337 + 367)) and v34 and ((v105 and v30) or not v105)) then
			if (((2917 - 1959) > (119 + 828)) and v117.AncestralCall:IsReady()) then
				if (((6849 - 2357) >= (3898 - (485 + 759))) and v23(v117.AncestralCall)) then
					return "AncestralCall cooldowns";
				end
			end
			if (((7964 - 4522) >= (2692 - (442 + 747))) and v117.BagofTricks:IsReady()) then
				if (v23(v117.BagofTricks) or ((4305 - (832 + 303)) <= (2410 - (88 + 858)))) then
					return "BagofTricks cooldowns";
				end
			end
			if (v117.Berserking:IsReady() or ((1463 + 3334) == (3632 + 756))) then
				if (((23 + 528) <= (1470 - (766 + 23))) and v23(v117.Berserking)) then
					return "Berserking cooldowns";
				end
			end
			if (((16177 - 12900) > (556 - 149)) and v117.BloodFury:IsReady()) then
				if (((12369 - 7674) >= (4802 - 3387)) and v23(v117.BloodFury)) then
					return "BloodFury cooldowns";
				end
			end
			if (v117.Fireblood:IsReady() or ((4285 - (1036 + 37)) <= (670 + 274))) then
				if (v23(v117.Fireblood) or ((6029 - 2933) <= (1415 + 383))) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v128()
		if (((5017 - (641 + 839)) == (4450 - (910 + 3))) and v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(101 - 61) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (1685 - (1466 + 218)))) then
			if (((1764 + 2073) >= (2718 - (556 + 592))) and v23(v118.EarthShieldFocus)) then
				return "earth_shield_tank healingst";
			end
		end
		if ((v90 and v121.AreUnitsBelowHealthPercentage(33 + 57, 811 - (329 + 479)) and v117.ChainHeal:IsReady() and v12:BuffUp(v117.HighTide)) or ((3804 - (174 + 680)) == (13098 - 9286))) then
			if (((9788 - 5065) >= (1655 + 663)) and v23(v118.ChainHealFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v97 and (v16:HealthPercentage() <= v75) and v117.HealingWave:IsReady() and (v117.PrimordialWave:TimeSinceLastCast() < (754 - (396 + 343)))) or ((180 + 1847) > (4329 - (29 + 1448)))) then
			if (v23(v118.HealingWaveFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2525 - (135 + 1254)) > (16262 - 11945))) then
				return "healing_wave healingaoe";
			end
		end
		if (((22168 - 17420) == (3165 + 1583)) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
			if (((5263 - (389 + 1138)) <= (5314 - (102 + 472))) and (v16:HealthPercentage() <= v79)) then
				if (v23(v118.RiptideFocus) or ((3200 + 190) <= (1697 + 1363))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((932 + 67) > (4238 - (320 + 1225)))) then
			if (((824 - 361) < (368 + 233)) and (v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) then
				if (v23(v118.RiptideFocus) or ((3647 - (157 + 1307)) < (2546 - (821 + 1038)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((11349 - 6800) == (498 + 4051)) and v101 and v117.UnleashLife:IsReady()) then
			if (((8298 - 3626) == (1739 + 2933)) and (v16:HealthPercentage() <= v86)) then
				if (v23(v117.UnleashLife) or ((9091 - 5423) < (1421 - (834 + 192)))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v69 == "Cursor") and v117.HealingRain:IsReady()) or ((265 + 3901) == (117 + 338))) then
			if (v23(v118.HealingRainCursor, not v14:IsInRange(1 + 39), v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((6891 - 2442) == (2967 - (300 + 4)))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v121.AreUnitsBelowHealthPercentage(v68, v67) and v117.HealingRain:IsReady()) or ((1143 + 3134) < (7824 - 4835))) then
			if ((v69 == "Player") or ((1232 - (112 + 250)) >= (1654 + 2495))) then
				if (((5541 - 3329) < (1824 + 1359)) and v23(v118.HealingRainPlayer, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif (((2403 + 2243) > (2238 + 754)) and (v69 == "Friendly under Cursor")) then
				if (((712 + 722) < (2308 + 798)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((2200 - (1001 + 413)) < (6740 - 3717)) and v23(v118.HealingRainCursor, not v14:IsInRange(922 - (244 + 638)), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v69 == "Enemy under Cursor") or ((3135 - (627 + 66)) < (220 - 146))) then
				if (((5137 - (512 + 90)) == (6441 - (1665 + 241))) and v15:Exists() and v12:CanAttack(v15)) then
					if (v23(v118.HealingRainCursor, not v14:IsInRange(757 - (373 + 344)), v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1358 + 1651) <= (557 + 1548))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((4827 - 2997) < (6208 - 2539)) and (v69 == "Confirmation")) then
				if (v23(v117.HealingRain, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2529 - (35 + 1064)) >= (2629 + 983))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((5740 - 3057) >= (10 + 2450)) and v121.AreUnitsBelowHealthPercentage(v65, v64) and v117.EarthenWallTotem:IsReady()) then
			if ((v66 == "Player") or ((3040 - (298 + 938)) >= (4534 - (233 + 1026)))) then
				if (v23(v118.EarthenWallTotemPlayer) or ((3083 - (636 + 1030)) > (1856 + 1773))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((4684 + 111) > (120 + 282)) and (v66 == "Friendly under Cursor")) then
				if (((326 + 4487) > (3786 - (55 + 166))) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((759 + 3153) == (394 + 3518)) and v23(v118.EarthenWallTotemCursor, not v14:IsInRange(152 - 112))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((3118 - (36 + 261)) <= (8436 - 3612)) and (v66 == "Confirmation")) then
				if (((3106 - (34 + 1334)) <= (844 + 1351)) and v23(v117.EarthenWallTotem)) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((32 + 9) <= (4301 - (1035 + 248))) and v121.AreUnitsBelowHealthPercentage(v60, v59) and v117.Downpour:IsReady()) then
			if (((2166 - (20 + 1)) <= (2139 + 1965)) and (v61 == "Player")) then
				if (((3008 - (134 + 185)) < (5978 - (549 + 584))) and v23(v118.DownpourPlayer, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v61 == "Friendly under Cursor") or ((3007 - (314 + 371)) > (9001 - 6379))) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((5502 - (478 + 490)) == (1103 + 979))) then
					if (v23(v118.DownpourCursor, not v14:IsInRange(1212 - (786 + 386)), v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((5088 - 3517) > (3246 - (1055 + 324)))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v61 == "Confirmation") or ((3994 - (1093 + 247)) >= (2663 + 333))) then
				if (((419 + 3559) > (8353 - 6249)) and v23(v117.Downpour, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((10164 - 7169) > (4384 - 2843)) and v91 and v121.AreUnitsBelowHealthPercentage(v58, v57) and v117.CloudburstTotem:IsReady()) then
			if (((8164 - 4915) > (340 + 613)) and v23(v117.CloudburstTotem)) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v102 and v121.AreUnitsBelowHealthPercentage(v104, v103) and v117.Wellspring:IsReady()) or ((12608 - 9335) > (15761 - 11188))) then
			if (v23(v117.Wellspring, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2376 + 775) < (3283 - 1999))) then
				return "wellspring healingaoe";
			end
		end
		if ((v90 and v121.AreUnitsBelowHealthPercentage(v56, v55) and v117.ChainHeal:IsReady()) or ((2538 - (364 + 324)) == (4191 - 2662))) then
			if (((1969 - 1148) < (704 + 1419)) and v23(v118.ChainHealFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if (((3774 - 2872) < (3723 - 1398)) and v100 and v12:IsMoving() and v121.AreUnitsBelowHealthPercentage(v85, v84) and v117.SpiritwalkersGrace:IsReady()) then
			if (((2605 - 1747) <= (4230 - (1249 + 19))) and v23(v117.SpiritwalkersGrace)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v94 and v121.AreUnitsBelowHealthPercentage(v71, v70) and v117.HealingStreamTotem:IsReady()) or ((3562 + 384) < (5013 - 3725))) then
			if (v23(v117.HealingStreamTotem) or ((4328 - (686 + 400)) == (445 + 122))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v129()
		local v139 = 229 - (73 + 156);
		while true do
			if ((v139 == (1 + 1)) or ((1658 - (721 + 90)) >= (15 + 1248))) then
				if ((v117.ElementalOrbit:IsAvailable() and v12:BuffDown(v117.EarthShieldBuff)) or ((7315 - 5062) == (2321 - (224 + 246)))) then
					if (v23(v117.EarthShield) or ((3380 - 1293) > (4367 - 1995))) then
						return "earth_shield healingst";
					end
				end
				if ((v117.ElementalOrbit:IsAvailable() and v12:BuffUp(v117.EarthShieldBuff)) or ((807 + 3638) < (99 + 4050))) then
					if (v121.IsSoloMode() or ((1336 + 482) == (168 - 83))) then
						if (((2096 - 1466) < (2640 - (203 + 310))) and v117.LightningShield:IsReady() and v12:BuffDown(v117.LightningShield)) then
							if (v23(v117.LightningShield) or ((3931 - (1238 + 755)) == (176 + 2338))) then
								return "lightning_shield healingst";
							end
						end
					elseif (((5789 - (709 + 825)) >= (100 - 45)) and v117.WaterShield:IsReady() and v12:BuffDown(v117.WaterShield)) then
						if (((4368 - 1369) > (2020 - (196 + 668))) and v23(v117.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v139 = 11 - 8;
			end
			if (((4867 - 2517) > (1988 - (171 + 662))) and (v139 == (93 - (4 + 89)))) then
				if (((14121 - 10092) <= (1768 + 3085)) and v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(175 - 135) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (1 + 0))) then
					if (v23(v118.EarthShieldFocus) or ((2002 - (35 + 1451)) > (4887 - (28 + 1425)))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((6039 - (941 + 1052)) >= (2909 + 124)) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
					if ((v16:HealthPercentage() <= v79) or ((4233 - (822 + 692)) <= (2065 - 618))) then
						if (v23(v118.RiptideFocus) or ((1948 + 2186) < (4223 - (45 + 252)))) then
							return "riptide healingaoe";
						end
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (1 + 0)) or ((398 - 234) >= (3218 - (114 + 319)))) then
				if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((753 - 228) == (2701 - 592))) then
					if (((22 + 11) == (48 - 15)) and (v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) then
						if (((6398 - 3344) <= (5978 - (556 + 1407))) and v23(v118.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				if (((3077 - (741 + 465)) < (3847 - (170 + 295))) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
					if (((682 + 611) <= (1990 + 176)) and ((v16:HealthPercentage() <= v79) or (v16:HealthPercentage() <= v79))) then
						if (v23(v118.RiptideFocus) or ((6349 - 3770) < (102 + 21))) then
							return "riptide healingaoe";
						end
					end
				end
				v139 = 2 + 0;
			end
			if ((v139 == (2 + 1)) or ((2076 - (957 + 273)) >= (634 + 1734))) then
				if ((v95 and v117.HealingSurge:IsReady()) or ((1607 + 2405) <= (12795 - 9437))) then
					if (((3936 - 2442) <= (9178 - 6173)) and (v16:HealthPercentage() <= v72)) then
						if (v23(v118.HealingSurgeFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((15404 - 12293) == (3914 - (389 + 1391)))) then
							return "healing_surge healingst";
						end
					end
				end
				if (((1478 + 877) == (246 + 2109)) and v97 and v117.HealingWave:IsReady()) then
					if ((v16:HealthPercentage() <= v75) or ((1338 - 750) <= (1383 - (783 + 168)))) then
						if (((16099 - 11302) >= (3832 + 63)) and v23(v118.HealingWaveFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v140 = 311 - (309 + 2);
		while true do
			if (((10984 - 7407) == (4789 - (1090 + 122))) and (v140 == (1 + 0))) then
				if (((12742 - 8948) > (2528 + 1165)) and v117.Stormkeeper:IsReady()) then
					if (v23(v117.Stormkeeper) or ((2393 - (628 + 490)) == (736 + 3364))) then
						return "stormkeeper damage";
					end
				end
				if ((#v12:GetEnemiesInRange(99 - 59) < (13 - 10)) or ((2365 - (431 + 343)) >= (7230 - 3650))) then
					if (((2843 - 1860) <= (1429 + 379)) and v117.LightningBolt:IsReady()) then
						if (v23(v117.LightningBolt, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((275 + 1875) <= (2892 - (556 + 1139)))) then
							return "lightning_bolt damage";
						end
					end
				elseif (((3784 - (6 + 9)) >= (215 + 958)) and v117.ChainLightning:IsReady()) then
					if (((761 + 724) == (1654 - (28 + 141))) and v23(v117.ChainLightning, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
			if (((0 + 0) == v140) or ((4091 - 776) <= (1971 + 811))) then
				if (v117.FlameShock:IsReady() or ((2193 - (486 + 831)) >= (7712 - 4748))) then
					if (v121.CastCycle(v117.FlameShock, v12:GetEnemiesInRange(140 - 100), v124, not v14:IsSpellInRange(v117.FlameShock), nil, nil, nil, nil) or ((422 + 1810) > (7895 - 5398))) then
						return "flame_shock_cycle damage";
					end
					if (v23(v117.FlameShock, not v14:IsSpellInRange(v117.FlameShock)) or ((3373 - (668 + 595)) <= (299 + 33))) then
						return "flame_shock damage";
					end
				end
				if (((744 + 2942) > (8650 - 5478)) and v117.LavaBurst:IsReady()) then
					if (v23(v117.LavaBurst, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((4764 - (23 + 267)) < (2764 - (1129 + 815)))) then
						return "lava_burst damage";
					end
				end
				v140 = 388 - (371 + 16);
			end
		end
	end
	local function v131()
		local v141 = 1750 - (1326 + 424);
		while true do
			if (((8103 - 3824) >= (10531 - 7649)) and (v141 == (123 - (88 + 30)))) then
				v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v71 = EpicSettings.Settings['HealingStreamTotemHP'];
				v72 = EpicSettings.Settings['HealingSurgeHP'];
				v73 = EpicSettings.Settings['HealingTideTotemGroup'];
				v141 = 777 - (720 + 51);
			end
			if ((v141 == (17 - 9)) or ((3805 - (421 + 1355)) >= (5808 - 2287))) then
				v81 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v82 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v83 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v84 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v141 = 5 + 4;
			end
			if ((v141 == (1095 - (286 + 797))) or ((7446 - 5409) >= (7688 - 3046))) then
				v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v101 = EpicSettings.Settings['UseUnleashLife'];
				v111 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
				v112 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((2159 - (397 + 42)) < (1393 + 3065)) and (v141 == (807 - (24 + 776)))) then
				v46 = EpicSettings.Settings['InterruptThreshold'];
				v44 = EpicSettings.Settings['InterruptWithStun'];
				v79 = EpicSettings.Settings['RiptideHP'];
				v80 = EpicSettings.Settings['RiptideTankHP'];
				v141 = 12 - 4;
			end
			if ((v141 == (791 - (222 + 563))) or ((960 - 524) > (2176 + 845))) then
				v74 = EpicSettings.Settings['HealingTideTotemHP'];
				v75 = EpicSettings.Settings['HealingWaveHP'];
				v36 = EpicSettings.Settings['healthstoneHP'];
				v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v141 = 197 - (23 + 167);
			end
			if (((2511 - (690 + 1108)) <= (306 + 541)) and (v141 == (8 + 1))) then
				v85 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v86 = EpicSettings.Settings['UnleashLifeHP'];
				v90 = EpicSettings.Settings['UseChainHeal'];
				v91 = EpicSettings.Settings['UseCloudburstTotem'];
				v141 = 858 - (40 + 808);
			end
			if (((355 + 1799) <= (15414 - 11383)) and (v141 == (4 + 0))) then
				v39 = EpicSettings.Settings['HealingPotionName'];
				v67 = EpicSettings.Settings['HealingRainGroup'];
				v68 = EpicSettings.Settings['HealingRainHP'];
				v69 = EpicSettings.Settings['HealingRainUsage'];
				v141 = 3 + 2;
			end
			if (((2531 + 2084) == (5186 - (47 + 524))) and (v141 == (7 + 3))) then
				v93 = EpicSettings.Settings['UseEarthShield'];
				v37 = EpicSettings.Settings['UseHealingPotion'];
				v94 = EpicSettings.Settings['UseHealingStreamTotem'];
				v95 = EpicSettings.Settings['UseHealingSurge'];
				v141 = 30 - 19;
			end
			if ((v141 == (0 - 0)) or ((8643 - 4853) == (2226 - (1165 + 561)))) then
				v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v55 = EpicSettings.Settings['ChainHealGroup'];
				v141 = 1 + 0;
			end
			if (((275 - 186) < (85 + 136)) and (v141 == (480 - (341 + 138)))) then
				v56 = EpicSettings.Settings['ChainHealHP'];
				v43 = EpicSettings.Settings['DispelBuffs'];
				v42 = EpicSettings.Settings['DispelDebuffs'];
				v59 = EpicSettings.Settings['DownpourGroup'];
				v141 = 1 + 1;
			end
			if (((4238 - 2184) >= (1747 - (89 + 237))) and (v141 == (35 - 24))) then
				v96 = EpicSettings.Settings['UseHealingTideTotem'];
				v97 = EpicSettings.Settings['UseHealingWave'];
				v35 = EpicSettings.Settings['useHealthstone'];
				v99 = EpicSettings.Settings['UseRiptide'];
				v141 = 24 - 12;
			end
			if (((1573 - (581 + 300)) < (4278 - (855 + 365))) and ((4 - 2) == v141)) then
				v60 = EpicSettings.Settings['DownpourHP'];
				v61 = EpicSettings.Settings['DownpourUsage'];
				v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v65 = EpicSettings.Settings['EarthenWallTotemHP'];
				v141 = 1 + 2;
			end
			if ((v141 == (1238 - (1030 + 205))) or ((3055 + 199) == (1540 + 115))) then
				v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v41 = EpicSettings.Settings['HandleCharredBrambles'];
				v40 = EpicSettings.Settings['HandleCharredTreant'];
				v38 = EpicSettings.Settings['HealingPotionHP'];
				v141 = 290 - (156 + 130);
			end
		end
	end
	local function v132()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (11 - 4)) or ((2654 - 1358) == (1294 + 3616))) then
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v113 = EpicSettings.Settings['usePurgeTarget'];
				break;
			end
			if (((1964 + 1404) == (3437 - (10 + 59))) and (v142 == (1 + 0))) then
				v54 = EpicSettings.Settings['AstralShiftHP'];
				v57 = EpicSettings.Settings['CloudburstTotemGroup'];
				v58 = EpicSettings.Settings['CloudburstTotemHP'];
				v62 = EpicSettings.Settings['EarthElementalHP'];
				v142 = 9 - 7;
			end
			if (((3806 - (671 + 492)) < (3037 + 778)) and (v142 == (1219 - (369 + 846)))) then
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v34 = EpicSettings.Settings['UseRacials'];
				v102 = EpicSettings.Settings['UseWellspring'];
				v103 = EpicSettings.Settings['WellspringGroup'];
				v142 = 2 + 3;
			end
			if (((1633 + 280) > (2438 - (1036 + 909))) and ((0 + 0) == v142)) then
				v47 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v48 = EpicSettings.Settings['AncestralGuidanceHP'];
				v52 = EpicSettings.Settings['AscendanceGroup'];
				v53 = EpicSettings.Settings['AscendanceHP'];
				v142 = 1 - 0;
			end
			if (((4958 - (11 + 192)) > (1733 + 1695)) and (v142 == (181 - (135 + 40)))) then
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v142 = 16 - 9;
			end
			if (((833 + 548) <= (5218 - 2849)) and (v142 == (7 - 2))) then
				v104 = EpicSettings.Settings['WellspringHP'];
				v105 = EpicSettings.Settings['racialsWithCD'];
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v142 = 182 - (50 + 126);
			end
			if ((v142 == (8 - 5)) or ((1072 + 3771) == (5497 - (1233 + 180)))) then
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v142 = 973 - (522 + 447);
			end
			if (((6090 - (107 + 1314)) > (169 + 194)) and ((5 - 3) == v142)) then
				v63 = EpicSettings.Settings['EarthElementalTankHP'];
				v76 = EpicSettings.Settings['ManaTideTotemMana'];
				v77 = EpicSettings.Settings['PrimordialWaveHP'];
				v78 = EpicSettings.Settings['PrimordialWaveSaveCooldowns'];
				v142 = 2 + 1;
			end
		end
	end
	local function v133()
		v131();
		v132();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['dispel'];
		v32 = EpicSettings.Toggles['healing'];
		v33 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((3726 - 1849) >= (12415 - 9277))) then
			return;
		end
		if (((6652 - (716 + 1194)) >= (62 + 3564)) and (v12:AffectingCombat() or v29)) then
			local v153 = v42 and v117.PurifySpirit:IsReady() and v31;
			if ((v117.EarthShield:IsReady() and v93 and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (1 + 0))) or ((5043 - (74 + 429)) == (1766 - 850))) then
				v28 = v121.FocusUnitRefreshableBuff(v117.EarthShield, 8 + 7, 91 - 51, "TANK");
				if (v28 or ((818 + 338) > (13395 - 9050))) then
					return v28;
				end
			end
			if (((5530 - 3293) < (4682 - (279 + 154))) and (not v16:BuffRefreshable(v117.EarthShield) or (v121.UnitGroupRole(v16) ~= "TANK") or not v93)) then
				local v237 = 778 - (454 + 324);
				while true do
					if ((v237 == (0 + 0)) or ((2700 - (12 + 5)) < (13 + 10))) then
						v28 = v121.FocusUnit(v153, nil, nil, nil);
						if (((1775 - 1078) <= (306 + 520)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
		end
		local v148;
		if (((2198 - (277 + 816)) <= (5024 - 3848)) and not v12:AffectingCombat() and v29) then
			if (((4562 - (1058 + 125)) <= (715 + 3097)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v12:CanAttack(v14)) then
				local v238 = v121.DeadFriendlyUnitsCount();
				if (v12:AffectingCombat() or ((1763 - (815 + 160)) >= (6933 - 5317))) then
					if (((4400 - 2546) <= (807 + 2572)) and (v238 > (2 - 1))) then
						if (((6447 - (41 + 1857)) == (6442 - (1222 + 671))) and v23(v117.AncestralVision, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "ancestral_vision";
						end
					elseif (v23(v117.AncestralSpirit, not v14:IsInRange(103 - 63), v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((4343 - 1321) >= (4206 - (229 + 953)))) then
						return "ancestral_spirit";
					end
				end
			end
		end
		if (((6594 - (1111 + 663)) > (3777 - (874 + 705))) and v12:AffectingCombat() and v121.TargetIsValid()) then
			local v154 = 0 + 0;
			while true do
				if ((v154 == (3 + 1)) or ((2205 - 1144) >= (138 + 4753))) then
					v148 = v125();
					if (((2043 - (642 + 37)) <= (1020 + 3453)) and v148) then
						return v148;
					end
					if ((v115 > v108) or ((576 + 3019) <= (7 - 4))) then
						v148 = v127();
						if (v148 or ((5126 - (233 + 221)) == (8907 - 5055))) then
							return v148;
						end
					end
					v154 = 5 + 0;
				end
				if (((3100 - (718 + 823)) == (982 + 577)) and (v154 == (808 - (266 + 539)))) then
					if (v28 or ((4960 - 3208) <= (2013 - (636 + 589)))) then
						return v28;
					end
					if (v110 or ((9274 - 5367) == (365 - 188))) then
						local v240 = 0 + 0;
						while true do
							if (((1261 + 2209) > (1570 - (657 + 358))) and (v240 == (0 - 0))) then
								v28 = v121.HandleIncorporeal(v117.Hex, v118.HexMouseOver, 68 - 38, true);
								if (v28 or ((2159 - (1151 + 36)) == (623 + 22))) then
									return v28;
								end
								break;
							end
						end
					end
					if (((837 + 2345) >= (6316 - 4201)) and v109) then
						v28 = v121.HandleAfflicted(v117.PurifySpirit, v118.PurifySpirit, 1862 - (1552 + 280));
						if (((4727 - (64 + 770)) < (3008 + 1421)) and v28) then
							return v28;
						end
						if (v111 or ((6507 - 3640) < (339 + 1566))) then
							local v241 = 1243 - (157 + 1086);
							while true do
								if ((v241 == (0 - 0)) or ((7865 - 6069) >= (6213 - 2162))) then
									v28 = v121.HandleAfflicted(v117.TremorTotem, v117.TremorTotem, 40 - 10);
									if (((2438 - (599 + 220)) <= (7479 - 3723)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if (((2535 - (1813 + 118)) == (442 + 162)) and v112) then
							v28 = v121.HandleAfflicted(v117.PoisonCleansingTotem, v117.PoisonCleansingTotem, 1247 - (841 + 376));
							if (v28 or ((6283 - 1799) == (210 + 690))) then
								return v28;
							end
						end
					end
					v154 = 10 - 6;
				end
				if (((859 - (464 + 395)) == v154) or ((11443 - 6984) <= (535 + 578))) then
					v116 = v12:GetEnemiesInRange(877 - (467 + 370));
					v114 = v9.BossFightRemains(nil, true);
					v115 = v114;
					v154 = 1 - 0;
				end
				if (((2667 + 965) > (11648 - 8250)) and ((1 + 0) == v154)) then
					if (((9496 - 5414) <= (5437 - (150 + 370))) and (v115 == (12393 - (74 + 1208)))) then
						v115 = v9.FightRemains(v116, false);
					end
					v28 = v121.Interrupt(v117.WindShear, 73 - 43, true);
					if (((22916 - 18084) >= (987 + 399)) and v28) then
						return v28;
					end
					v154 = 392 - (14 + 376);
				end
				if (((237 - 100) == (89 + 48)) and (v154 == (2 + 0))) then
					v28 = v121.InterruptCursor(v117.WindShear, v118.WindShearMouseover, 29 + 1, true, v15);
					if (v28 or ((4600 - 3030) >= (3259 + 1073))) then
						return v28;
					end
					v28 = v121.InterruptWithStunCursor(v117.CapacitorTotem, v118.CapacitorTotemCursor, 108 - (23 + 55), nil, v15);
					v154 = 6 - 3;
				end
				if ((v154 == (4 + 1)) or ((3650 + 414) <= (2819 - 1000))) then
					if (not v78 or v30 or ((1569 + 3417) < (2475 - (652 + 249)))) then
						if (((11844 - 7418) > (2040 - (708 + 1160))) and (v16:HealthPercentage() < v77) and v16:BuffDown(v117.Riptide)) then
							if (((1590 - 1004) > (829 - 374)) and v117.PrimordialWave:IsReady()) then
								if (((853 - (10 + 17)) == (186 + 640)) and v23(v118.PrimordialWaveFocus)) then
									return "primordial_wave main";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (v29 or v12:AffectingCombat() or ((5751 - (1400 + 332)) > (8517 - 4076))) then
			if (((3925 - (242 + 1666)) < (1824 + 2437)) and v31) then
				if (((1729 + 2987) > (69 + 11)) and v16 and v42) then
					if ((v117.PurifySpirit:IsReady() and v121.DispellableFriendlyUnit()) or ((4447 - (850 + 90)) == (5730 - 2458))) then
						if (v23(v118.PurifySpirit) or ((2266 - (360 + 1030)) >= (2722 + 353))) then
							return "purify_spirit dispel";
						end
					end
				end
				if (((12283 - 7931) > (3513 - 959)) and v43 and v113) then
					if ((v117.Purge:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v121.UnitHasMagicBuff(v14)) or ((6067 - (909 + 752)) < (5266 - (109 + 1114)))) then
						if (v23(v117.Purge, not v14:IsSpellInRange(v117.Purge)) or ((3458 - 1569) >= (1317 + 2066))) then
							return "purge dispel";
						end
					end
				end
			end
			v148 = v126();
			if (((2134 - (6 + 236)) <= (1723 + 1011)) and v148) then
				return v148;
			end
			if (((1548 + 375) < (5230 - 3012)) and v32) then
				v148 = v128();
				if (((3795 - 1622) > (1512 - (1076 + 57))) and v148) then
					return v148;
				end
				v148 = v129();
				if (v148 or ((427 + 2164) == (4098 - (579 + 110)))) then
					return v148;
				end
			end
			if (((357 + 4157) > (2939 + 385)) and v33) then
				if (v121.TargetIsValid() or ((111 + 97) >= (5235 - (174 + 233)))) then
					v148 = v130();
					if (v148 or ((4421 - 2838) > (6260 - 2693))) then
						return v148;
					end
				end
			end
		end
	end
	local function v134()
		local v149 = 0 + 0;
		while true do
			if (((1174 - (663 + 511)) == v149) or ((1172 + 141) == (173 + 621))) then
				v123();
				v21.Print("Restoration Shaman rotation by Epic.");
				v149 = 2 - 1;
			end
			if (((1923 + 1251) > (6832 - 3930)) and (v149 == (2 - 1))) then
				EpicSettings.SetupVersion("Restoration Shaman X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v21.SetAPL(126 + 138, v133, v134);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

