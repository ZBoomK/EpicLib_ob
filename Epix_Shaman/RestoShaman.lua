local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4885 - (1300 + 423)) <= (7113 - 3672)) and not v5) then
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
	local v114 = 38662 - 27551;
	local v115 = 5169 + 5942;
	local v116;
	v9:RegisterForEvent(function()
		v114 = 2080 + 9031;
		v115 = 9660 + 1451;
	end, "PLAYER_REGEN_ENABLED");
	local v117 = v17.Shaman.Restoration;
	local v118 = v24.Shaman.Restoration;
	local v119 = v19.Shaman.Restoration;
	local v120 = {};
	local v121 = v21.Commons.Everyone;
	local v122 = v21.Commons.Shaman;
	local function v123()
		if (((15873 - 11167) > (6423 - (109 + 1885))) and v117.ImprovedPurifySpirit:IsAvailable()) then
			v121.DispellableDebuffs = v20.MergeTable(v121.DispellableMagicDebuffs, v121.DispellableCurseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124(v135)
		return v135:DebuffRefreshable(v117.FlameShockDebuff) and (v115 > (1474 - (1269 + 200)));
	end
	local function v125()
		if (((5469 - 2615) < (4910 - (98 + 717))) and v89 and v117.AstralShift:IsReady()) then
			if ((v12:HealthPercentage() <= v54) or ((1884 - (802 + 24)) >= (2072 - 870))) then
				if (((4686 - 975) > (496 + 2859)) and v23(v117.AstralShift)) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v92 and v117.EarthElemental:IsReady()) or ((697 + 209) >= (367 + 1862))) then
			if (((278 + 1010) > (3480 - 2229)) and ((v12:HealthPercentage() <= v62) or v121.IsTankBelowHealthPercentage(v63))) then
				if (v23(v117.EarthElemental) or ((15049 - 10536) < (1199 + 2153))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v119.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((841 + 1224) >= (2637 + 559))) then
			if (v23(v118.Healthstone) or ((3182 + 1194) <= (692 + 789))) then
				return "healthstone defensive 3";
			end
		end
		if ((v37 and (v12:HealthPercentage() <= v38)) or ((4825 - (797 + 636)) >= (23019 - 18278))) then
			local v201 = 1619 - (1427 + 192);
			while true do
				if (((1153 + 2172) >= (5000 - 2846)) and (v201 == (0 + 0))) then
					if ((v39 == "Refreshing Healing Potion") or ((587 + 708) >= (3559 - (192 + 134)))) then
						if (((5653 - (316 + 960)) > (914 + 728)) and v119.RefreshingHealingPotion:IsReady()) then
							if (((3645 + 1078) > (1254 + 102)) and v23(v118.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((15811 - 11675) <= (3984 - (83 + 468)))) then
						if (((6051 - (1202 + 604)) <= (21618 - 16987)) and v119.DreamwalkersHealingPotion:IsReady()) then
							if (((7116 - 2840) >= (10836 - 6922)) and v23(v118.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v136 = 325 - (45 + 280);
		while true do
			if (((192 + 6) <= (3814 + 551)) and (v136 == (0 + 0))) then
				if (((2647 + 2135) > (823 + 3853)) and v40) then
					v28 = v121.HandleCharredTreant(v117.Riptide, v118.RiptideMouseover, 74 - 34);
					if (((6775 - (340 + 1571)) > (867 + 1330)) and v28) then
						return v28;
					end
					v28 = v121.HandleCharredTreant(v117.HealingSurge, v118.HealingSurgeMouseover, 1812 - (1733 + 39));
					if (v28 or ((10167 - 6467) == (3541 - (125 + 909)))) then
						return v28;
					end
					v28 = v121.HandleCharredTreant(v117.HealingWave, v118.HealingWaveMouseover, 1988 - (1096 + 852));
					if (((2007 + 2467) >= (391 - 117)) and v28) then
						return v28;
					end
				end
				if (v41 or ((1838 + 56) <= (1918 - (409 + 103)))) then
					local v239 = 236 - (46 + 190);
					while true do
						if (((1667 - (51 + 44)) >= (432 + 1099)) and (v239 == (1318 - (1114 + 203)))) then
							v28 = v121.HandleCharredBrambles(v117.HealingSurge, v118.HealingSurgeMouseover, 766 - (228 + 498));
							if (v28 or ((1016 + 3671) < (2510 + 2032))) then
								return v28;
							end
							v239 = 665 - (174 + 489);
						end
						if (((8573 - 5282) > (3572 - (830 + 1075))) and ((526 - (303 + 221)) == v239)) then
							v28 = v121.HandleCharredBrambles(v117.HealingWave, v118.HealingWaveMouseover, 1309 - (231 + 1038));
							if (v28 or ((728 + 145) == (3196 - (171 + 991)))) then
								return v28;
							end
							break;
						end
						if ((v239 == (0 - 0)) or ((7561 - 4745) < (27 - 16))) then
							v28 = v121.HandleCharredBrambles(v117.Riptide, v118.RiptideMouseover, 33 + 7);
							if (((12966 - 9267) < (13575 - 8869)) and v28) then
								return v28;
							end
							v239 = 1 - 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		if (((8179 - 5533) >= (2124 - (111 + 1137))) and v107 and ((v30 and v106) or not v106)) then
			v28 = v121.HandleTopTrinket(v120, v30, 198 - (91 + 67), nil);
			if (((1827 - 1213) <= (795 + 2389)) and v28) then
				return v28;
			end
			v28 = v121.HandleBottomTrinket(v120, v30, 563 - (423 + 100), nil);
			if (((22 + 3104) == (8654 - 5528)) and v28) then
				return v28;
			end
		end
		if ((v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(21 + 19) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (772 - (326 + 445)))) or ((9543 - 7356) >= (11036 - 6082))) then
			if (v23(v118.EarthShieldFocus) or ((9049 - 5172) == (4286 - (530 + 181)))) then
				return "earth_shield_tank healingcd";
			end
		end
		if (((1588 - (614 + 267)) > (664 - (19 + 13))) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
			if ((v16:HealthPercentage() <= v79) or ((887 - 341) >= (6254 - 3570))) then
				if (((4184 - 2719) <= (1118 + 3183)) and v23(v118.RiptideFocus)) then
					return "riptide healingcd";
				end
			end
		end
		if (((2996 - 1292) > (2955 - 1530)) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
			if (((v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) or ((2499 - (1293 + 519)) == (8638 - 4404))) then
				if (v23(v118.RiptideFocus) or ((8694 - 5364) < (2732 - 1303))) then
					return "riptide healingcd";
				end
			end
		end
		if (((4945 - 3798) >= (788 - 453)) and v121.AreUnitsBelowHealthPercentage(v82, v81) and v117.SpiritLinkTotem:IsReady()) then
			if (((1820 + 1615) > (428 + 1669)) and (v83 == "Player")) then
				if (v23(v118.SpiritLinkTotemPlayer) or ((8759 - 4989) >= (934 + 3107))) then
					return "spirit_link_totem cooldowns";
				end
			elseif ((v83 == "Friendly under Cursor") or ((1260 + 2531) <= (1007 + 604))) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((5674 - (709 + 387)) <= (3866 - (673 + 1185)))) then
					if (((3262 - 2137) <= (6666 - 4590)) and v23(v118.SpiritLinkTotemCursor, not v14:IsInRange(65 - 25))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v83 == "Confirmation") or ((532 + 211) >= (3287 + 1112))) then
				if (((1558 - 403) < (411 + 1262)) and v23(v117.SpiritLinkTotem)) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if ((v96 and v121.AreUnitsBelowHealthPercentage(v74, v73) and v117.HealingTideTotem:IsReady()) or ((4633 - 2309) <= (1134 - 556))) then
			if (((5647 - (446 + 1434)) == (5050 - (1040 + 243))) and v23(v117.HealingTideTotem)) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((12204 - 8115) == (5936 - (559 + 1288))) and v121.AreUnitsBelowHealthPercentage(v50, v49) and v117.AncestralProtectionTotem:IsReady()) then
			if (((6389 - (609 + 1322)) >= (2128 - (13 + 441))) and (v51 == "Player")) then
				if (((3631 - 2659) <= (3714 - 2296)) and v23(v118.AncestralProtectionTotemPlayer)) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v51 == "Friendly under Cursor") or ((24593 - 19655) < (178 + 4584))) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((9093 - 6589) > (1515 + 2749))) then
					if (((944 + 1209) == (6389 - 4236)) and v23(v118.AncestralProtectionTotemCursor, not v14:IsInRange(22 + 18))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v51 == "Confirmation") or ((932 - 425) >= (1713 + 878))) then
				if (((2493 + 1988) == (3220 + 1261)) and v23(v117.AncestralProtectionTotem)) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v87 and v121.AreUnitsBelowHealthPercentage(v48, v47) and v117.AncestralGuidance:IsReady()) or ((1955 + 373) < (679 + 14))) then
			if (((4761 - (153 + 280)) == (12497 - 8169)) and v23(v117.AncestralGuidance)) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((1426 + 162) >= (526 + 806)) and v88 and v121.AreUnitsBelowHealthPercentage(v53, v52) and v117.Ascendance:IsReady()) then
			if (v23(v117.Ascendance) or ((2185 + 1989) > (3855 + 393))) then
				return "ascendance cooldowns";
			end
		end
		if ((v98 and (v12:Mana() <= v76) and v117.ManaTideTotem:IsReady()) or ((3324 + 1262) <= (124 - 42))) then
			if (((2388 + 1475) == (4530 - (89 + 578))) and v23(v117.ManaTideTotem)) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v34 and ((v105 and v30) or not v105)) or ((202 + 80) <= (86 - 44))) then
			if (((5658 - (572 + 477)) >= (104 + 662)) and v117.AncestralCall:IsReady()) then
				if (v23(v117.AncestralCall) or ((692 + 460) == (297 + 2191))) then
					return "AncestralCall cooldowns";
				end
			end
			if (((3508 - (84 + 2)) > (5521 - 2171)) and v117.BagofTricks:IsReady()) then
				if (((632 + 245) > (1218 - (497 + 345))) and v23(v117.BagofTricks)) then
					return "BagofTricks cooldowns";
				end
			end
			if (v117.Berserking:IsReady() or ((80 + 3038) <= (313 + 1538))) then
				if (v23(v117.Berserking) or ((1498 - (605 + 728)) >= (2492 + 1000))) then
					return "Berserking cooldowns";
				end
			end
			if (((8779 - 4830) < (223 + 4633)) and v117.BloodFury:IsReady()) then
				if (v23(v117.BloodFury) or ((15809 - 11533) < (2719 + 297))) then
					return "BloodFury cooldowns";
				end
			end
			if (((12994 - 8304) > (3115 + 1010)) and v117.Fireblood:IsReady()) then
				if (v23(v117.Fireblood) or ((539 - (457 + 32)) >= (381 + 515))) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v128()
		if ((v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(1442 - (832 + 570)) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (1 + 0))) or ((447 + 1267) >= (10467 - 7509))) then
			if (v23(v118.EarthShieldFocus) or ((719 + 772) < (1440 - (588 + 208)))) then
				return "earth_shield_tank healingaoe";
			end
		end
		if (((1897 - 1193) < (2787 - (884 + 916))) and v90 and v121.AreUnitsBelowHealthPercentage(188 - 98, 2 + 1) and v117.ChainHeal:IsReady() and v12:BuffUp(v117.HighTide)) then
			if (((4371 - (232 + 421)) > (3795 - (1569 + 320))) and v23(v118.ChainHealFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v97 and (v16:HealthPercentage() <= v75) and v117.HealingWave:IsReady() and (v117.PrimordialWave:TimeSinceLastCast() < (4 + 11))) or ((183 + 775) > (12249 - 8614))) then
			if (((4106 - (316 + 289)) <= (11758 - 7266)) and v23(v118.HealingWaveFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe";
			end
		end
		if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((159 + 3283) < (4001 - (666 + 787)))) then
			if (((3300 - (360 + 65)) >= (1369 + 95)) and (v16:HealthPercentage() <= v79)) then
				if (v23(v118.RiptideFocus) or ((5051 - (79 + 175)) >= (7714 - 2821))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((430 + 121) > (6338 - 4270))) then
			if (((4070 - 1956) > (1843 - (503 + 396))) and (v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) then
				if (v23(v118.RiptideFocus) or ((2443 - (92 + 89)) >= (6005 - 2909))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v101 and v117.UnleashLife:IsReady()) or ((1157 + 1098) >= (2094 + 1443))) then
			if ((v16:HealthPercentage() <= v86) or ((15025 - 11188) < (179 + 1127))) then
				if (((6726 - 3776) == (2574 + 376)) and v23(v117.UnleashLife)) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v69 == "Cursor") and v117.HealingRain:IsReady()) or ((2256 + 2467) < (10044 - 6746))) then
			if (((142 + 994) >= (234 - 80)) and v23(v118.HealingRainCursor, not v14:IsInRange(1284 - (485 + 759)), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v121.AreUnitsBelowHealthPercentage(v68, v67) and v117.HealingRain:IsReady()) or ((626 - 355) > (5937 - (442 + 747)))) then
			if (((5875 - (832 + 303)) >= (4098 - (88 + 858))) and (v69 == "Player")) then
				if (v23(v118.HealingRainPlayer, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((786 + 1792) >= (2806 + 584))) then
					return "healing_rain healingaoe";
				end
			elseif (((2 + 39) <= (2450 - (766 + 23))) and (v69 == "Friendly under Cursor")) then
				if (((2966 - 2365) < (4868 - 1308)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((619 - 384) < (2331 - 1644)) and v23(v118.HealingRainCursor, not v14:IsInRange(1113 - (1036 + 37)), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((3226 + 1323) > (2244 - 1091)) and (v69 == "Enemy under Cursor")) then
				if ((v15:Exists() and v12:CanAttack(v15)) or ((3677 + 997) < (6152 - (641 + 839)))) then
					if (((4581 - (910 + 3)) < (11627 - 7066)) and v23(v118.HealingRainCursor, not v14:IsInRange(1724 - (1466 + 218)), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v69 == "Confirmation") or ((210 + 245) == (4753 - (556 + 592)))) then
				if (v23(v117.HealingRain, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((947 + 1716) == (4120 - (329 + 479)))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((5131 - (174 + 680)) <= (15376 - 10901)) and v121.AreUnitsBelowHealthPercentage(v65, v64) and v117.EarthenWallTotem:IsReady()) then
			if ((v66 == "Player") or ((1803 - 933) == (849 + 340))) then
				if (((2292 - (396 + 343)) <= (278 + 2855)) and v23(v118.EarthenWallTotemPlayer)) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v66 == "Friendly under Cursor") or ((3714 - (29 + 1448)) >= (4900 - (135 + 1254)))) then
				if ((v15:Exists() and not v12:CanAttack(v15)) or ((4987 - 3663) > (14100 - 11080))) then
					if (v23(v118.EarthenWallTotemCursor, not v14:IsInRange(27 + 13)) or ((4519 - (389 + 1138)) == (2455 - (102 + 472)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((2932 + 174) > (847 + 679)) and (v66 == "Confirmation")) then
				if (((2819 + 204) < (5415 - (320 + 1225))) and v23(v117.EarthenWallTotem)) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((254 - 111) > (46 + 28)) and v121.AreUnitsBelowHealthPercentage(v60, v59) and v117.Downpour:IsReady()) then
			if (((1482 - (157 + 1307)) < (3971 - (821 + 1038))) and (v61 == "Player")) then
				if (((2736 - 1639) <= (179 + 1449)) and v23(v118.DownpourPlayer, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif (((8224 - 3594) == (1723 + 2907)) and (v61 == "Friendly under Cursor")) then
				if (((8774 - 5234) > (3709 - (834 + 192))) and v15:Exists() and not v12:CanAttack(v15)) then
					if (((305 + 4489) >= (841 + 2434)) and v23(v118.DownpourCursor, not v14:IsInRange(1 + 39), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif (((2298 - 814) == (1788 - (300 + 4))) and (v61 == "Confirmation")) then
				if (((383 + 1049) < (9306 - 5751)) and v23(v117.Downpour, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if ((v91 and v121.AreUnitsBelowHealthPercentage(v58, v57) and v117.CloudburstTotem:IsReady()) or ((1427 - (112 + 250)) > (1427 + 2151))) then
			if (v23(v117.CloudburstTotem) or ((12012 - 7217) < (807 + 600))) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((959 + 894) < (3600 + 1213)) and v102 and v121.AreUnitsBelowHealthPercentage(v104, v103) and v117.Wellspring:IsReady()) then
			if (v23(v117.Wellspring, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((1399 + 1422) < (1806 + 625))) then
				return "wellspring healingaoe";
			end
		end
		if ((v90 and v121.AreUnitsBelowHealthPercentage(v56, v55) and v117.ChainHeal:IsReady()) or ((4288 - (1001 + 413)) < (4863 - 2682))) then
			if (v23(v118.ChainHealFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((3571 - (244 + 638)) <= (1036 - (627 + 66)))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v100 and v12:IsMoving() and v121.AreUnitsBelowHealthPercentage(v85, v84) and v117.SpiritwalkersGrace:IsReady()) or ((5568 - 3699) == (2611 - (512 + 90)))) then
			if (v23(v117.SpiritwalkersGrace) or ((5452 - (1665 + 241)) < (3039 - (373 + 344)))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v94 and v121.AreUnitsBelowHealthPercentage(v71, v70) and v117.HealingStreamTotem:IsReady()) or ((940 + 1142) == (1263 + 3510))) then
			if (((8556 - 5312) > (1784 - 729)) and v23(v117.HealingStreamTotem)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v129()
		local v137 = 1099 - (35 + 1064);
		while true do
			if ((v137 == (1 + 0)) or ((7087 - 3774) <= (8 + 1770))) then
				if ((v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) or ((2657 - (298 + 938)) >= (3363 - (233 + 1026)))) then
					if (((3478 - (636 + 1030)) <= (1662 + 1587)) and (v16:HealthPercentage() <= v80) and (v121.UnitGroupRole(v16) == "TANK")) then
						if (((1586 + 37) <= (582 + 1375)) and v23(v118.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				if (((299 + 4113) == (4633 - (55 + 166))) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
					if (((340 + 1410) >= (85 + 757)) and ((v16:HealthPercentage() <= v79) or (v16:HealthPercentage() <= v79))) then
						if (((16696 - 12324) > (2147 - (36 + 261))) and v23(v118.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v137 = 3 - 1;
			end
			if (((1600 - (34 + 1334)) < (316 + 505)) and (v137 == (2 + 0))) then
				if (((1801 - (1035 + 248)) < (923 - (20 + 1))) and v117.ElementalOrbit:IsAvailable() and v12:BuffDown(v117.EarthShieldBuff)) then
					if (((1560 + 1434) > (1177 - (134 + 185))) and v23(v117.EarthShield)) then
						return "earth_shield healingst";
					end
				end
				if ((v117.ElementalOrbit:IsAvailable() and v12:BuffUp(v117.EarthShieldBuff)) or ((4888 - (549 + 584)) <= (1600 - (314 + 371)))) then
					if (((13546 - 9600) > (4711 - (478 + 490))) and v121.IsSoloMode()) then
						if ((v117.LightningShield:IsReady() and v12:BuffDown(v117.LightningShield)) or ((708 + 627) >= (4478 - (786 + 386)))) then
							if (((15689 - 10845) > (3632 - (1055 + 324))) and v23(v117.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif (((1792 - (1093 + 247)) == (402 + 50)) and v117.WaterShield:IsReady() and v12:BuffDown(v117.WaterShield)) then
						if (v23(v117.WaterShield) or ((480 + 4077) < (8285 - 6198))) then
							return "water_shield healingst";
						end
					end
				end
				v137 = 9 - 6;
			end
			if (((11023 - 7149) == (9734 - 5860)) and (v137 == (0 + 0))) then
				if ((v117.EarthShield:IsReady() and v93 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(154 - 114) and (v121.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v117.EarthShield) and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (3 - 2))) or ((1462 + 476) > (12620 - 7685))) then
					if (v23(v118.EarthShieldFocus) or ((4943 - (364 + 324)) < (9383 - 5960))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((3488 - 2034) <= (826 + 1665)) and v99 and v12:BuffDown(v117.UnleashLife) and v117.Riptide:IsReady() and v16:BuffDown(v117.Riptide)) then
					if ((v16:HealthPercentage() <= v79) or ((17394 - 13237) <= (4488 - 1685))) then
						if (((14738 - 9885) >= (4250 - (1249 + 19))) and v23(v118.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v137 = 1 + 0;
			end
			if (((16091 - 11957) > (4443 - (686 + 400))) and (v137 == (3 + 0))) then
				if ((v95 and v117.HealingSurge:IsReady()) or ((3646 - (73 + 156)) < (12 + 2522))) then
					if ((v16:HealthPercentage() <= v72) or ((3533 - (721 + 90)) <= (2 + 162))) then
						if (v23(v118.HealingSurgeFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((7818 - 5410) < (2579 - (224 + 246)))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v97 and v117.HealingWave:IsReady()) or ((53 - 20) == (2679 - 1224))) then
					if ((v16:HealthPercentage() <= v75) or ((81 + 362) >= (96 + 3919))) then
						if (((2484 + 898) > (329 - 163)) and v23(v118.HealingWaveFocus, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (513 - (203 + 310))) or ((2273 - (1238 + 755)) == (214 + 2845))) then
				if (((3415 - (709 + 825)) > (2381 - 1088)) and v117.FlameShock:IsReady()) then
					local v240 = 0 - 0;
					while true do
						if (((3221 - (196 + 668)) == (9306 - 6949)) and ((0 - 0) == v240)) then
							if (((956 - (171 + 662)) == (216 - (4 + 89))) and v121.CastCycle(v117.FlameShock, v12:GetEnemiesInRange(140 - 100), v124, not v14:IsSpellInRange(v117.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v23(v117.FlameShock, not v14:IsSpellInRange(v117.FlameShock)) or ((385 + 671) >= (14898 - 11506))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v117.LavaBurst:IsReady() or ((424 + 657) < (2561 - (35 + 1451)))) then
					if (v23(v117.LavaBurst, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2502 - (28 + 1425)) >= (6425 - (941 + 1052)))) then
						return "lava_burst damage";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (1515 - (822 + 692))) or ((6806 - 2038) <= (399 + 447))) then
				if (v117.Stormkeeper:IsReady() or ((3655 - (45 + 252)) <= (1405 + 15))) then
					if (v23(v117.Stormkeeper) or ((1287 + 2452) <= (7313 - 4308))) then
						return "stormkeeper damage";
					end
				end
				if ((#v12:GetEnemiesInRange(473 - (114 + 319)) < (3 - 0)) or ((2125 - 466) >= (1361 + 773))) then
					if (v117.LightningBolt:IsReady() or ((4856 - 1596) < (4934 - 2579))) then
						if (v23(v117.LightningBolt, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((2632 - (556 + 1407)) == (5429 - (741 + 465)))) then
							return "lightning_bolt damage";
						end
					end
				elseif (v117.ChainLightning:IsReady() or ((2157 - (170 + 295)) < (310 + 278))) then
					if (v23(v117.ChainLightning, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff)) or ((4407 + 390) < (8988 - 5337))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
		end
	end
	local function v131()
		v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v55 = EpicSettings.Settings['ChainHealGroup'];
		v56 = EpicSettings.Settings['ChainHealHP'];
		v43 = EpicSettings.Settings['DispelBuffs'];
		v42 = EpicSettings.Settings['DispelDebuffs'];
		v59 = EpicSettings.Settings['DownpourGroup'];
		v60 = EpicSettings.Settings['DownpourHP'];
		v61 = EpicSettings.Settings['DownpourUsage'];
		v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v65 = EpicSettings.Settings['EarthenWallTotemHP'];
		v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v41 = EpicSettings.Settings['HandleCharredBrambles'];
		v40 = EpicSettings.Settings['HandleCharredTreant'];
		v38 = EpicSettings.Settings['HealingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v67 = EpicSettings.Settings['HealingRainGroup'];
		v68 = EpicSettings.Settings['HealingRainHP'];
		v69 = EpicSettings.Settings['HealingRainUsage'];
		v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v71 = EpicSettings.Settings['HealingStreamTotemHP'];
		v72 = EpicSettings.Settings['HealingSurgeHP'];
		v73 = EpicSettings.Settings['HealingTideTotemGroup'];
		v74 = EpicSettings.Settings['HealingTideTotemHP'];
		v75 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v46 = EpicSettings.Settings['InterruptThreshold'];
		v44 = EpicSettings.Settings['InterruptWithStun'];
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
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v94 = EpicSettings.Settings['UseHealingStreamTotem'];
		v95 = EpicSettings.Settings['UseHealingSurge'];
		v96 = EpicSettings.Settings['UseHealingTideTotem'];
		v97 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v99 = EpicSettings.Settings['UseRiptide'];
		v100 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v101 = EpicSettings.Settings['UseUnleashLife'];
		v111 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v112 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v132()
		local v191 = 0 + 0;
		while true do
			if ((v191 == (6 + 2)) or ((2366 + 1811) > (6080 - (957 + 273)))) then
				v108 = EpicSettings.Settings['fightRemainsCheck'];
				v109 = EpicSettings.Settings['handleAfflicted'];
				v110 = EpicSettings.Settings['HandleIncorporeal'];
				v191 = 3 + 6;
			end
			if ((v191 == (1 + 1)) or ((1524 - 1124) > (2927 - 1816))) then
				v58 = EpicSettings.Settings['CloudburstTotemHP'];
				v62 = EpicSettings.Settings['EarthElementalHP'];
				v63 = EpicSettings.Settings['EarthElementalTankHP'];
				v191 = 9 - 6;
			end
			if (((15107 - 12056) > (2785 - (389 + 1391))) and (v191 == (0 + 0))) then
				v47 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v48 = EpicSettings.Settings['AncestralGuidanceHP'];
				v52 = EpicSettings.Settings['AscendanceGroup'];
				v191 = 1 + 0;
			end
			if (((8407 - 4714) <= (5333 - (783 + 168))) and (v191 == (19 - 13))) then
				v102 = EpicSettings.Settings['UseWellspring'];
				v103 = EpicSettings.Settings['WellspringGroup'];
				v104 = EpicSettings.Settings['WellspringHP'];
				v191 = 7 + 0;
			end
			if (((314 - (309 + 2)) == v191) or ((10078 - 6796) > (5312 - (1090 + 122)))) then
				v76 = EpicSettings.Settings['ManaTideTotemMana'];
				v77 = EpicSettings.Settings['PrimordialWaveHP'];
				v78 = EpicSettings.Settings['PrimordialWaveSaveCooldowns'];
				v191 = 2 + 2;
			end
			if ((v191 == (13 - 9)) or ((2451 + 1129) < (3962 - (628 + 490)))) then
				v87 = EpicSettings.Settings['UseAncestralGuidance'];
				v88 = EpicSettings.Settings['UseAscendance'];
				v89 = EpicSettings.Settings['UseAstralShift'];
				v191 = 1 + 4;
			end
			if (((219 - 130) < (20519 - 16029)) and (v191 == (775 - (431 + 343)))) then
				v53 = EpicSettings.Settings['AscendanceHP'];
				v54 = EpicSettings.Settings['AstralShiftHP'];
				v57 = EpicSettings.Settings['CloudburstTotemGroup'];
				v191 = 3 - 1;
			end
			if ((v191 == (19 - 12)) or ((3937 + 1046) < (232 + 1576))) then
				v105 = EpicSettings.Settings['racialsWithCD'];
				v106 = EpicSettings.Settings['trinketsWithCD'];
				v107 = EpicSettings.Settings['useTrinkets'];
				v191 = 1703 - (556 + 1139);
			end
			if (((3844 - (6 + 9)) > (691 + 3078)) and (v191 == (3 + 2))) then
				v92 = EpicSettings.Settings['UseEarthElemental'];
				v98 = EpicSettings.Settings['UseManaTideTotem'];
				v34 = EpicSettings.Settings['UseRacials'];
				v191 = 175 - (28 + 141);
			end
			if (((576 + 909) <= (3583 - 679)) and (v191 == (7 + 2))) then
				v111 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v112 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v113 = EpicSettings.Settings['usePurgeTarget'];
				break;
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
		if (((5586 - (486 + 831)) == (11108 - 6839)) and v12:IsDeadOrGhost()) then
			return;
		end
		if (((1362 - 975) <= (526 + 2256)) and (v12:AffectingCombat() or v29)) then
			local v202 = v42 and v117.PurifySpirit:IsReady() and v31;
			if ((v117.EarthShield:IsReady() and v93 and (v121.FriendlyUnitsWithBuffCount(v117.EarthShieldBuff, true) <= (3 - 2))) or ((3162 - (668 + 595)) <= (826 + 91))) then
				local v235 = 0 + 0;
				while true do
					if ((v235 == (0 - 0)) or ((4602 - (23 + 267)) <= (2820 - (1129 + 815)))) then
						v28 = v121.FocusUnitRefreshableBuff(v117.EarthShield, 402 - (371 + 16), 1790 - (1326 + 424), "TANK");
						if (((4226 - 1994) <= (9486 - 6890)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
			if (((2213 - (88 + 30)) < (4457 - (720 + 51))) and (not v16:BuffRefreshable(v117.EarthShield) or (v121.UnitGroupRole(v16) ~= "TANK") or not v93)) then
				local v236 = 0 - 0;
				while true do
					if ((v236 == (1776 - (421 + 1355))) or ((2631 - 1036) >= (2198 + 2276))) then
						v28 = v121.FocusUnit(v202, nil, nil, nil);
						if (v28 or ((5702 - (286 + 797)) < (10535 - 7653))) then
							return v28;
						end
						break;
					end
				end
			end
		end
		local v197;
		if ((not v12:AffectingCombat() and v29) or ((486 - 192) >= (5270 - (397 + 42)))) then
			if (((634 + 1395) <= (3884 - (24 + 776))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v237 = 0 - 0;
				local v238;
				while true do
					if ((v237 == (785 - (222 + 563))) or ((4487 - 2450) == (1743 + 677))) then
						v238 = v121.DeadFriendlyUnitsCount();
						if (((4648 - (23 + 167)) > (5702 - (690 + 1108))) and (v238 > (1 + 0))) then
							if (((360 + 76) >= (971 - (40 + 808))) and v23(v117.AncestralVision, nil, v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (((83 + 417) < (6944 - 5128)) and v23(v118.AncestralSpiritMouseover, not v14:IsInRange(39 + 1), v12:BuffDown(v117.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		if (((1891 + 1683) == (1960 + 1614)) and v12:AffectingCombat() and v121.TargetIsValid()) then
			local v203 = 571 - (47 + 524);
			while true do
				if (((144 + 77) < (1066 - 676)) and (v203 == (5 - 1))) then
					v197 = v125();
					if (v197 or ((5046 - 2833) <= (3147 - (1165 + 561)))) then
						return v197;
					end
					if (((91 + 2967) < (15052 - 10192)) and (v115 > v108)) then
						local v241 = 0 + 0;
						while true do
							if (((479 - (341 + 138)) == v241) or ((350 + 946) >= (9175 - 4729))) then
								v197 = v127();
								if (v197 or ((1719 - (89 + 237)) > (14440 - 9951))) then
									return v197;
								end
								break;
							end
						end
					end
					v203 = 10 - 5;
				end
				if ((v203 == (883 - (581 + 300))) or ((5644 - (855 + 365)) < (64 - 37))) then
					v28 = v121.InterruptCursor(v117.WindShear, v118.WindShearMouseover, 10 + 20, true, v15);
					if (v28 or ((3232 - (1030 + 205)) > (3582 + 233))) then
						return v28;
					end
					v28 = v121.InterruptWithStunCursor(v117.CapacitorTotem, v118.CapacitorTotemCursor, 28 + 2, nil, v15);
					v203 = 289 - (156 + 130);
				end
				if (((7873 - 4408) > (3223 - 1310)) and (v203 == (0 - 0))) then
					v116 = v12:GetEnemiesInRange(11 + 29);
					v114 = v9.BossFightRemains(nil, true);
					v115 = v114;
					v203 = 1 + 0;
				end
				if (((802 - (10 + 59)) < (515 + 1304)) and (v203 == (24 - 19))) then
					if (not v78 or v30 or ((5558 - (671 + 492)) == (3786 + 969))) then
						if (((v16:HealthPercentage() < v77) and v16:BuffDown(v117.Riptide)) or ((5008 - (369 + 846)) < (628 + 1741))) then
							if (v117.PrimordialWave:IsReady() or ((3486 + 598) == (2210 - (1036 + 909)))) then
								if (((3465 + 893) == (7316 - 2958)) and v23(v118.PrimordialWaveFocus)) then
									return "primordial_wave main";
								end
							end
						end
					end
					break;
				end
				if ((v203 == (206 - (11 + 192))) or ((1586 + 1552) < (1168 - (135 + 40)))) then
					if (((8068 - 4738) > (1401 + 922)) and v28) then
						return v28;
					end
					if (v110 or ((7987 - 4361) == (5979 - 1990))) then
						local v242 = 176 - (50 + 126);
						while true do
							if ((v242 == (0 - 0)) or ((203 + 713) == (4084 - (1233 + 180)))) then
								v28 = v121.HandleIncorporeal(v117.Hex, v118.HexMouseOver, 999 - (522 + 447), true);
								if (((1693 - (107 + 1314)) == (127 + 145)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if (((12946 - 8697) <= (2056 + 2783)) and v109) then
						v28 = v121.HandleAfflicted(v117.PurifySpirit, v118.PurifySpiritMouseover, 59 - 29);
						if (((10987 - 8210) < (5110 - (716 + 1194))) and v28) then
							return v28;
						end
						if (((2 + 93) < (210 + 1747)) and v111) then
							local v245 = 503 - (74 + 429);
							while true do
								if (((1593 - 767) < (851 + 866)) and (v245 == (0 - 0))) then
									v28 = v121.HandleAfflicted(v117.TremorTotem, v117.TremorTotem, 22 + 8);
									if (((4395 - 2969) >= (2732 - 1627)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if (((3187 - (279 + 154)) <= (4157 - (454 + 324))) and v112) then
							v28 = v121.HandleAfflicted(v117.PoisonCleansingTotem, v117.PoisonCleansingTotem, 24 + 6);
							if (v28 or ((3944 - (12 + 5)) == (762 + 651))) then
								return v28;
							end
						end
					end
					v203 = 10 - 6;
				end
				if ((v203 == (1 + 0)) or ((2247 - (277 + 816)) <= (3367 - 2579))) then
					if ((v115 == (12294 - (1058 + 125))) or ((309 + 1334) > (4354 - (815 + 160)))) then
						v115 = v9.FightRemains(v116, false);
					end
					v28 = v121.Interrupt(v117.WindShear, 128 - 98, true);
					if (v28 or ((6653 - 3850) > (1086 + 3463))) then
						return v28;
					end
					v203 = 5 - 3;
				end
			end
		end
		if (v29 or v12:AffectingCombat() or ((2118 - (41 + 1857)) >= (4915 - (1222 + 671)))) then
			local v204 = 0 - 0;
			while true do
				if (((4055 - 1233) == (4004 - (229 + 953))) and (v204 == (1775 - (1111 + 663)))) then
					if (v197 or ((2640 - (874 + 705)) == (260 + 1597))) then
						return v197;
					end
					if (((1884 + 876) > (2834 - 1470)) and v32) then
						local v243 = 0 + 0;
						while true do
							if ((v243 == (680 - (642 + 37))) or ((1118 + 3784) <= (576 + 3019))) then
								v197 = v129();
								if (v197 or ((9671 - 5819) == (747 - (233 + 221)))) then
									return v197;
								end
								break;
							end
							if (((0 - 0) == v243) or ((1373 + 186) == (6129 - (718 + 823)))) then
								v197 = v128();
								if (v197 or ((2822 + 1662) == (1593 - (266 + 539)))) then
									return v197;
								end
								v243 = 2 - 1;
							end
						end
					end
					v204 = 1227 - (636 + 589);
				end
				if (((10843 - 6275) >= (8058 - 4151)) and ((0 + 0) == v204)) then
					if (((453 + 793) < (4485 - (657 + 358))) and v31) then
						local v244 = 0 - 0;
						while true do
							if (((9268 - 5200) >= (2159 - (1151 + 36))) and (v244 == (0 + 0))) then
								if (((130 + 363) < (11626 - 7733)) and v16 and v42) then
									if ((v117.PurifySpirit:IsReady() and v121.DispellableFriendlyUnit()) or ((3305 - (1552 + 280)) >= (4166 - (64 + 770)))) then
										if (v23(v118.PurifySpiritFocus) or ((2751 + 1300) <= (2626 - 1469))) then
											return "purify_spirit dispel";
										end
									end
								end
								if (((108 + 496) < (4124 - (157 + 1086))) and v43 and v113) then
									if ((v117.Purge:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v121.UnitHasMagicBuff(v14)) or ((1801 - 901) == (14790 - 11413))) then
										if (((6839 - 2380) > (806 - 215)) and v23(v117.Purge, not v14:IsSpellInRange(v117.Purge))) then
											return "purge dispel";
										end
									end
								end
								break;
							end
						end
					end
					v197 = v126();
					v204 = 820 - (599 + 220);
				end
				if (((6766 - 3368) >= (4326 - (1813 + 118))) and (v204 == (2 + 0))) then
					if (v33 or ((3400 - (841 + 376)) >= (3956 - 1132))) then
						if (((450 + 1486) == (5284 - 3348)) and v121.TargetIsValid()) then
							local v246 = 859 - (464 + 395);
							while true do
								if ((v246 == (0 - 0)) or ((2321 + 2511) < (5150 - (467 + 370)))) then
									v197 = v130();
									if (((8447 - 4359) > (2844 + 1030)) and v197) then
										return v197;
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
		v123();
		v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(904 - 640, v133, v134);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

