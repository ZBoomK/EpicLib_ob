local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((4719 - 1984) == (2700 - (157 + 1234)))) then
			v6 = v0[v4];
			if (not v6 or ((6978 - 2848) <= (4510 - (991 + 564)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1560 - (1381 + 178))) or ((1843 + 121) <= (1081 + 259))) then
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
	local v112 = 4740 + 6371;
	local v113 = 38304 - 27193;
	local v114;
	v10:RegisterForEvent(function()
		local v133 = 0 + 0;
		while true do
			if (((2969 - (381 + 89)) == (2217 + 282)) and (v133 == (0 + 0))) then
				v112 = 19032 - 7921;
				v113 = 12267 - (1074 + 82);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v115 = v18.Shaman.Restoration;
	local v116 = v25.Shaman.Restoration;
	local v117 = v20.Shaman.Restoration;
	local v118 = {};
	local v119 = v22.Commons.Everyone;
	local v120 = v22.Commons.Shaman;
	local function v121()
		if (v115.ImprovedPurifySpirit:IsAvailable() or ((4941 - 2686) < (1806 - (214 + 1570)))) then
			v119.DispellableDebuffs = v21.MergeTable(v119.DispellableMagicDebuffs, v119.DispellableCurseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122(v134)
		return v134:DebuffRefreshable(v115.FlameShockDebuff) and (v113 > (1460 - (990 + 465)));
	end
	local function v123()
		local v135 = 0 + 0;
		while true do
			if (((1 + 0) == v135) or ((1057 + 29) >= (5529 - 4124))) then
				if ((v117.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((4095 - (1668 + 58)) == (1052 - (512 + 114)))) then
					if (v24(v116.Healthstone) or ((8019 - 4943) > (6579 - 3396))) then
						return "healthstone defensive 3";
					end
				end
				if (((4182 - 2980) > (493 + 565)) and v38 and (v13:HealthPercentage() <= v39)) then
					local v230 = 0 + 0;
					while true do
						if (((3227 + 484) > (11316 - 7961)) and (v230 == (1994 - (109 + 1885)))) then
							if ((v40 == "Refreshing Healing Potion") or ((2375 - (1269 + 200)) >= (4271 - 2042))) then
								if (((2103 - (98 + 717)) > (2077 - (802 + 24))) and v117.RefreshingHealingPotion:IsReady()) then
									if (v24(v116.RefreshingHealingPotion) or ((7782 - 3269) < (4233 - 881))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v40 == "Dreamwalker's Healing Potion") or ((305 + 1760) >= (2456 + 740))) then
								if (v117.DreamwalkersHealingPotion:IsReady() or ((719 + 3657) <= (320 + 1161))) then
									if (v24(v116.RefreshingHealingPotion) or ((9436 - 6044) >= (15810 - 11069))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1190 + 2135) >= (877 + 1277)) and (v135 == (0 + 0))) then
				if ((v88 and v115.AstralShift:IsReady()) or ((942 + 353) >= (1510 + 1723))) then
					if (((5810 - (797 + 636)) > (7972 - 6330)) and (v13:HealthPercentage() <= v54)) then
						if (((6342 - (1427 + 192)) > (470 + 886)) and v24(v115.AstralShift, not v15:IsInRange(92 - 52))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v91 and v115.EarthElemental:IsReady()) or ((3718 + 418) <= (1556 + 1877))) then
					if (((4571 - (192 + 134)) <= (5907 - (316 + 960))) and ((v13:HealthPercentage() <= v62) or v119.IsTankBelowHealthPercentage(v63))) then
						if (((2380 + 1896) >= (3021 + 893)) and v24(v115.EarthElemental, not v15:IsInRange(37 + 3))) then
							return "earth_elemental defensives";
						end
					end
				end
				v135 = 3 - 2;
			end
		end
	end
	local function v124()
		if (((749 - (83 + 468)) <= (6171 - (1202 + 604))) and v41) then
			local v223 = 0 - 0;
			while true do
				if (((7958 - 3176) > (12946 - 8270)) and (v223 == (326 - (45 + 280)))) then
					v29 = v119.HandleCharredTreant(v115.HealingSurge, v116.HealingSurgeMouseover, 39 + 1);
					if (((4250 + 614) > (803 + 1394)) and v29) then
						return v29;
					end
					v223 = 2 + 0;
				end
				if (((1 + 1) == v223) or ((6851 - 3151) == (4418 - (340 + 1571)))) then
					v29 = v119.HandleCharredTreant(v115.HealingWave, v116.HealingWaveMouseover, 16 + 24);
					if (((6246 - (1733 + 39)) >= (752 - 478)) and v29) then
						return v29;
					end
					break;
				end
				if ((v223 == (1034 - (125 + 909))) or ((3842 - (1096 + 852)) <= (631 + 775))) then
					v29 = v119.HandleCharredTreant(v115.Riptide, v116.RiptideMouseover, 57 - 17);
					if (((1525 + 47) >= (2043 - (409 + 103))) and v29) then
						return v29;
					end
					v223 = 237 - (46 + 190);
				end
			end
		end
		if (v42 or ((4782 - (51 + 44)) < (1282 + 3260))) then
			v29 = v119.HandleCharredBrambles(v115.Riptide, v116.RiptideMouseover, 1357 - (1114 + 203));
			if (((4017 - (228 + 498)) > (362 + 1305)) and v29) then
				return v29;
			end
			v29 = v119.HandleCharredBrambles(v115.HealingSurge, v116.HealingSurgeMouseover, 23 + 17);
			if (v29 or ((1536 - (174 + 489)) == (5299 - 3265))) then
				return v29;
			end
			v29 = v119.HandleCharredBrambles(v115.HealingWave, v116.HealingWaveMouseover, 1945 - (830 + 1075));
			if (v29 or ((3340 - (303 + 221)) < (1280 - (231 + 1038)))) then
				return v29;
			end
		end
	end
	local function v125()
		if (((3083 + 616) < (5868 - (171 + 991))) and v106 and ((v31 and v105) or not v105)) then
			local v224 = 0 - 0;
			while true do
				if (((7104 - 4458) >= (2185 - 1309)) and (v224 == (0 + 0))) then
					v29 = v119.HandleTopTrinket(v118, v31, 140 - 100, nil);
					if (((1771 - 1157) <= (5131 - 1947)) and v29) then
						return v29;
					end
					v224 = 3 - 2;
				end
				if (((4374 - (111 + 1137)) == (3284 - (91 + 67))) and (v224 == (2 - 1))) then
					v29 = v119.HandleBottomTrinket(v118, v31, 10 + 30, nil);
					if (v29 or ((2710 - (423 + 100)) >= (35 + 4919))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((10734 - 6857) == (1864 + 1711))) then
			if (((1478 - (326 + 445)) > (2757 - 2125)) and (v17:HealthPercentage() <= v78)) then
				if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((1215 - 669) >= (6264 - 3580))) then
					return "riptide healingcd";
				end
			end
		end
		if (((2176 - (530 + 181)) <= (5182 - (614 + 267))) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if (((1736 - (19 + 13)) > (2318 - 893)) and (v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) then
				if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((1600 - 913) == (12094 - 7860))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v119.AreUnitsBelowHealthPercentage(v81, v80) and v115.SpiritLinkTotem:IsReady()) or ((865 + 2465) < (2512 - 1083))) then
			if (((2378 - 1231) >= (2147 - (1293 + 519))) and (v82 == "Player")) then
				if (((7008 - 3573) > (5474 - 3377)) and v24(v116.SpiritLinkTotemPlayer, not v15:IsInRange(76 - 36))) then
					return "spirit_link_totem cooldowns";
				end
			elseif ((v82 == "Friendly under Cursor") or ((16256 - 12486) >= (9519 - 5478))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((2008 + 1783) <= (329 + 1282))) then
					if (v24(v116.SpiritLinkTotemCursor, not v15:IsInRange(92 - 52)) or ((1058 + 3520) <= (668 + 1340))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif (((704 + 421) <= (3172 - (709 + 387))) and (v82 == "Confirmation")) then
				if (v24(v115.SpiritLinkTotem, not v15:IsInRange(1898 - (673 + 1185))) or ((2154 - 1411) >= (14125 - 9726))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((1900 - 745) < (1197 + 476)) and v95 and v119.AreUnitsBelowHealthPercentage(v74, v73) and v115.HealingTideTotem:IsReady()) then
			if (v24(v115.HealingTideTotem, not v15:IsInRange(30 + 10)) or ((3137 - 813) <= (142 + 436))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((7510 - 3743) == (7394 - 3627)) and v119.AreUnitsBelowHealthPercentage(v50, v49) and v115.AncestralProtectionTotem:IsReady()) then
			if (((5969 - (446 + 1434)) == (5372 - (1040 + 243))) and (v51 == "Player")) then
				if (((13305 - 8847) >= (3521 - (559 + 1288))) and v24(v116.AncestralProtectionTotemPlayer, not v15:IsInRange(1971 - (609 + 1322)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((1426 - (13 + 441)) <= (5298 - 3880)) and (v51 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((12934 - 7996) < (23716 - 18954))) then
					if (v24(v116.AncestralProtectionTotemCursor, not v15:IsInRange(2 + 38)) or ((9093 - 6589) > (1515 + 2749))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((944 + 1209) == (6389 - 4236)) and (v51 == "Confirmation")) then
				if (v24(v115.AncestralProtectionTotem, not v15:IsInRange(22 + 18)) or ((932 - 425) >= (1713 + 878))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((2493 + 1988) == (3220 + 1261)) and v86 and v119.AreUnitsBelowHealthPercentage(v48, v47) and v115.AncestralGuidance:IsReady()) then
			if (v24(v115.AncestralGuidance, not v15:IsInRange(34 + 6)) or ((2278 + 50) < (1126 - (153 + 280)))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((12497 - 8169) == (3886 + 442)) and v87 and v119.AreUnitsBelowHealthPercentage(v53, v52) and v115.Ascendance:IsReady()) then
			if (((628 + 960) >= (698 + 634)) and v24(v115.Ascendance, not v15:IsInRange(37 + 3))) then
				return "ascendance cooldowns";
			end
		end
		if ((v97 and (v13:Mana() <= v76) and v115.ManaTideTotem:IsReady()) or ((3025 + 1149) > (6468 - 2220))) then
			if (v24(v115.ManaTideTotem, not v15:IsInRange(25 + 15)) or ((5253 - (89 + 578)) <= (59 + 23))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if (((8030 - 4167) == (4912 - (572 + 477))) and v35 and ((v104 and v31) or not v104)) then
			if (v115.AncestralCall:IsReady() or ((39 + 243) <= (26 + 16))) then
				if (((551 + 4058) >= (852 - (84 + 2))) and v24(v115.AncestralCall, not v15:IsInRange(65 - 25))) then
					return "AncestralCall cooldowns";
				end
			end
			if (v115.BagofTricks:IsReady() or ((830 + 322) == (3330 - (497 + 345)))) then
				if (((88 + 3334) > (567 + 2783)) and v24(v115.BagofTricks, not v15:IsInRange(1373 - (605 + 728)))) then
					return "BagofTricks cooldowns";
				end
			end
			if (((626 + 251) > (835 - 459)) and v115.Berserking:IsReady()) then
				if (v24(v115.Berserking, not v15:IsInRange(2 + 38)) or ((11527 - 8409) <= (1669 + 182))) then
					return "Berserking cooldowns";
				end
			end
			if (v115.BloodFury:IsReady() or ((456 - 291) >= (2637 + 855))) then
				if (((4438 - (457 + 32)) < (2061 + 2795)) and v24(v115.BloodFury, not v15:IsInRange(1442 - (832 + 570)))) then
					return "BloodFury cooldowns";
				end
			end
			if (v115.Fireblood:IsReady() or ((4029 + 247) < (787 + 2229))) then
				if (((16597 - 11907) > (1988 + 2137)) and v24(v115.Fireblood, not v15:IsInRange(836 - (588 + 208)))) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v126()
		if ((v89 and v119.AreUnitsBelowHealthPercentage(256 - 161, 1803 - (884 + 916)) and v115.ChainHeal:IsReady() and v13:BuffUp(v115.HighTide)) or ((104 - 54) >= (520 + 376))) then
			if (v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2367 - (232 + 421)) >= (4847 - (1569 + 320)))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v96 and (v17:HealthPercentage() <= v75) and v115.HealingWave:IsReady() and (v115.PrimordialWaveResto:TimeSinceLastCast() < (4 + 11))) or ((284 + 1207) < (2169 - 1525))) then
			if (((1309 - (316 + 289)) < (2583 - 1596)) and v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if (((172 + 3546) > (3359 - (666 + 787))) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if ((v17:HealthPercentage() <= v78) or ((1383 - (360 + 65)) > (3398 + 237))) then
				if (((3755 - (79 + 175)) <= (7082 - 2590)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((2686 + 756) < (7810 - 5262))) then
			if (((5536 - 2661) >= (2363 - (503 + 396))) and (v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) then
				if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((4978 - (92 + 89)) >= (9491 - 4598))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v100 and v115.UnleashLife:IsReady()) or ((283 + 268) > (1224 + 844))) then
			if (((8278 - 6164) > (130 + 814)) and (v17:HealthPercentage() <= v85)) then
				if (v24(v115.UnleashLife, not v17:IsSpellInRange(v115.UnleashLife)) or ((5157 - 2895) >= (2702 + 394))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v69 == "Cursor") and v115.HealingRain:IsReady()) or ((1078 + 1177) >= (10772 - 7235))) then
			if (v24(v116.HealingRainCursor, not v15:IsInRange(5 + 35), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((5850 - 2013) < (2550 - (485 + 759)))) then
				return "healing_rain healingaoe";
			end
		end
		if (((6825 - 3875) == (4139 - (442 + 747))) and v119.AreUnitsBelowHealthPercentage(v68, v67) and v115.HealingRain:IsReady()) then
			if ((v69 == "Player") or ((5858 - (832 + 303)) < (4244 - (88 + 858)))) then
				if (((347 + 789) >= (128 + 26)) and v24(v116.HealingRainPlayer, not v15:IsInRange(2 + 38), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif ((v69 == "Friendly under Cursor") or ((1060 - (766 + 23)) > (23439 - 18691))) then
				if (((6482 - 1742) >= (8304 - 5152)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v116.HealingRainCursor, not v15:IsInRange(135 - 95), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3651 - (1036 + 37)) >= (2404 + 986))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((79 - 38) <= (1307 + 354)) and (v69 == "Enemy under Cursor")) then
				if (((2081 - (641 + 839)) < (4473 - (910 + 3))) and v16:Exists() and v13:CanAttack(v16)) then
					if (((599 - 364) < (2371 - (1466 + 218))) and v24(v116.HealingRainCursor, not v15:IsInRange(19 + 21), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((5697 - (556 + 592)) > (411 + 742)) and (v69 == "Confirmation")) then
				if (v24(v115.HealingRain, not v15:IsInRange(848 - (329 + 479)), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((5528 - (174 + 680)) < (16053 - 11381))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((7602 - 3934) < (3257 + 1304)) and v119.AreUnitsBelowHealthPercentage(v65, v64) and v115.EarthenWallTotem:IsReady()) then
			if ((v66 == "Player") or ((1194 - (396 + 343)) == (319 + 3286))) then
				if (v24(v116.EarthenWallTotemPlayer, not v15:IsInRange(1517 - (29 + 1448))) or ((4052 - (135 + 1254)) == (12476 - 9164))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((19969 - 15692) <= (2983 + 1492)) and (v66 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((2397 - (389 + 1138)) == (1763 - (102 + 472)))) then
					if (((1466 + 87) <= (1738 + 1395)) and v24(v116.EarthenWallTotemCursor, not v15:IsInRange(38 + 2))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v66 == "Confirmation") or ((3782 - (320 + 1225)) >= (6249 - 2738))) then
				if (v24(v115.EarthenWallTotem, not v15:IsInRange(25 + 15)) or ((2788 - (157 + 1307)) > (4879 - (821 + 1038)))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v119.AreUnitsBelowHealthPercentage(v60, v59) and v115.Downpour:IsReady()) or ((7464 - 4472) == (206 + 1675))) then
			if (((5516 - 2410) > (568 + 958)) and (v61 == "Player")) then
				if (((7492 - 4469) < (4896 - (834 + 192))) and v24(v116.DownpourPlayer, not v15:IsInRange(3 + 37), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif (((37 + 106) > (2 + 72)) and (v61 == "Friendly under Cursor")) then
				if (((27 - 9) < (2416 - (300 + 4))) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((293 + 804) <= (4261 - 2633)) and v24(v116.DownpourCursor, not v15:IsInRange(402 - (112 + 250)), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif (((1846 + 2784) == (11599 - 6969)) and (v61 == "Confirmation")) then
				if (((2028 + 1512) > (1388 + 1295)) and v24(v115.Downpour, not v15:IsInRange(30 + 10), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((2378 + 2416) >= (2433 + 842)) and v90 and v119.AreUnitsBelowHealthPercentage(v58, v57) and v115.CloudburstTotem:IsReady()) then
			if (((2898 - (1001 + 413)) == (3308 - 1824)) and v24(v115.CloudburstTotem)) then
				return "clouburst_totem healingaoe";
			end
		end
		if (((2314 - (244 + 638)) < (4248 - (627 + 66))) and v101 and v119.AreUnitsBelowHealthPercentage(v103, v102) and v115.Wellspring:IsReady()) then
			if (v24(v115.Wellspring, not v15:IsInRange(119 - 79), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((1667 - (512 + 90)) > (5484 - (1665 + 241)))) then
				return "wellspring healingaoe";
			end
		end
		if ((v89 and v119.AreUnitsBelowHealthPercentage(v56, v55) and v115.ChainHeal:IsReady()) or ((5512 - (373 + 344)) < (635 + 772))) then
			if (((491 + 1362) < (12695 - 7882)) and v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v99 and v13:IsMoving() and v119.AreUnitsBelowHealthPercentage(v84, v83) and v115.SpiritwalkersGrace:IsReady()) or ((4773 - 1952) < (3530 - (35 + 1064)))) then
			if (v24(v115.SpiritwalkersGrace, nil) or ((2092 + 782) < (4666 - 2485))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v93 and v119.AreUnitsBelowHealthPercentage(v71, v70) and v115.HealingStreamTotem:IsReady()) or ((11 + 2678) <= (1579 - (298 + 938)))) then
			if (v24(v115.HealingStreamTotem, nil) or ((3128 - (233 + 1026)) == (3675 - (636 + 1030)))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v127()
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((1813 + 1733) < (2269 + 53))) then
			if ((v17:HealthPercentage() <= v78) or ((619 + 1463) == (323 + 4450))) then
				if (((3465 - (55 + 166)) > (205 + 850)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((334 + 2979) <= (6790 - 5012))) then
			if (((v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) or ((1718 - (36 + 261)) >= (3679 - 1575))) then
				if (((3180 - (34 + 1334)) <= (1250 + 1999)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1262 + 361) <= (3240 - (1035 + 248))) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if (((4433 - (20 + 1)) == (2299 + 2113)) and ((v17:HealthPercentage() <= v78) or (v17:HealthPercentage() <= v78))) then
				if (((2069 - (134 + 185)) >= (1975 - (549 + 584))) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((5057 - (314 + 371)) > (6350 - 4500)) and v115.ElementalOrbit:IsAvailable() and v13:BuffDown(v115.EarthShieldBuff)) then
			if (((1200 - (478 + 490)) < (435 + 386)) and v24(v115.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((1690 - (786 + 386)) < (2921 - 2019)) and v115.ElementalOrbit:IsAvailable() and v13:BuffUp(v115.EarthShieldBuff)) then
			if (((4373 - (1055 + 324)) > (2198 - (1093 + 247))) and v119.IsSoloMode()) then
				if ((v115.LightningShield:IsReady() and v13:BuffDown(v115.LightningShield)) or ((3337 + 418) <= (97 + 818))) then
					if (((15666 - 11720) > (12702 - 8959)) and v24(v115.LightningShield)) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v115.WaterShield:IsReady() and v13:BuffDown(v115.WaterShield)) or ((3798 - 2463) >= (8307 - 5001))) then
				if (((1724 + 3120) > (8679 - 6426)) and v24(v115.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if (((1557 - 1105) == (341 + 111)) and v94 and v115.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v72) or ((11653 - 7096) < (2775 - (364 + 324)))) then
				if (((10619 - 6745) == (9296 - 5422)) and v24(v116.HealingSurgeFocus, not v17:IsSpellInRange(v115.HealingSurge), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v96 and v115.HealingWave:IsReady()) or ((643 + 1295) > (20649 - 15714))) then
			if ((v17:HealthPercentage() <= v75) or ((6814 - 2559) < (10395 - 6972))) then
				if (((2722 - (1249 + 19)) <= (2249 + 242)) and v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v128()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (1088 - (686 + 400))) or ((3262 + 895) <= (3032 - (73 + 156)))) then
				if (((23 + 4830) >= (3793 - (721 + 90))) and v115.LightningBolt:IsReady()) then
					if (((47 + 4087) > (10899 - 7542)) and v24(v115.LightningBolt, not v15:IsSpellInRange(v115.LightningBolt), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if (((471 - (224 + 246)) == v136) or ((5535 - 2118) < (4665 - 2131))) then
				if (v115.FlameShock:IsReady() or ((494 + 2228) <= (4 + 160))) then
					local v231 = 0 + 0;
					while true do
						if (((0 - 0) == v231) or ((8013 - 5605) < (2622 - (203 + 310)))) then
							if (v119.CastCycle(v115.FlameShock, v13:GetEnemiesInRange(2033 - (1238 + 755)), v122, not v15:IsSpellInRange(v115.FlameShock), nil, nil, nil, nil) or ((3 + 30) == (2989 - (709 + 825)))) then
								return "flame_shock_cycle damage";
							end
							if (v24(v115.FlameShock, not v15:IsSpellInRange(v115.FlameShock)) or ((815 - 372) >= (5848 - 1833))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((4246 - (196 + 668)) > (655 - 489)) and v115.LavaBurst:IsReady()) then
					if (v24(v115.LavaBurst, not v15:IsSpellInRange(v115.LavaBurst), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((579 - 299) == (3892 - (171 + 662)))) then
						return "lava_burst damage";
					end
				end
				v136 = 95 - (4 + 89);
			end
			if (((6592 - 4711) > (471 + 822)) and ((0 - 0) == v136)) then
				if (((925 + 1432) == (3843 - (35 + 1451))) and v115.Stormkeeper:IsReady()) then
					if (((1576 - (28 + 1425)) == (2116 - (941 + 1052))) and v24(v115.Stormkeeper, not v15:IsInRange(39 + 1))) then
						return "stormkeeper damage";
					end
				end
				if ((#v13:GetEnemiesInRange(1554 - (822 + 692)) > (1 - 0)) or ((498 + 558) >= (3689 - (45 + 252)))) then
					if (v115.ChainLightning:IsReady() or ((1070 + 11) < (370 + 705))) then
						if (v24(v115.ChainLightning, not v15:IsSpellInRange(v115.ChainLightning), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2552 - 1503) >= (4865 - (114 + 319)))) then
							return "chain_lightning damage";
						end
					end
				end
				v136 = 1 - 0;
			end
		end
	end
	local function v129()
		v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v55 = EpicSettings.Settings['ChainHealGroup'];
		v56 = EpicSettings.Settings['ChainHealHP'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v59 = EpicSettings.Settings['DownpourGroup'];
		v60 = EpicSettings.Settings['DownpourHP'];
		v61 = EpicSettings.Settings['DownpourUsage'];
		v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v65 = EpicSettings.Settings['EarthenWallTotemHP'];
		v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v39 = EpicSettings.Settings['HealingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v67 = EpicSettings.Settings['HealingRainGroup'];
		v68 = EpicSettings.Settings['HealingRainHP'];
		v69 = EpicSettings.Settings['HealingRainUsage'];
		v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v71 = EpicSettings.Settings['HealingStreamTotemHP'];
		v72 = EpicSettings.Settings['HealingSurgeHP'];
		v73 = EpicSettings.Settings['HealingTideTotemGroup'];
		v74 = EpicSettings.Settings['HealingTideTotemHP'];
		v75 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v46 = EpicSettings.Settings['InterruptThreshold'];
		v44 = EpicSettings.Settings['InterruptWithStun'];
		v78 = EpicSettings.Settings['RiptideHP'];
		v79 = EpicSettings.Settings['RiptideTankHP'];
		v80 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v81 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v82 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v83 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v84 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v85 = EpicSettings.Settings['UnleashLifeHP'];
		v89 = EpicSettings.Settings['UseChainHeal'];
		v90 = EpicSettings.Settings['UseCloudburstTotem'];
		v92 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['UseHealingPotion'];
		v93 = EpicSettings.Settings['UseHealingStreamTotem'];
		v94 = EpicSettings.Settings['UseHealingSurge'];
		v95 = EpicSettings.Settings['UseHealingTideTotem'];
		v96 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v98 = EpicSettings.Settings['UseRiptide'];
		v99 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v100 = EpicSettings.Settings['UseUnleashLife'];
		v110 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v111 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v130()
		v47 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v48 = EpicSettings.Settings['AncestralGuidanceHP'];
		v52 = EpicSettings.Settings['AscendanceGroup'];
		v53 = EpicSettings.Settings['AscendanceHP'];
		v54 = EpicSettings.Settings['AstralShiftHP'];
		v57 = EpicSettings.Settings['CloudburstTotemGroup'];
		v58 = EpicSettings.Settings['CloudburstTotemHP'];
		v62 = EpicSettings.Settings['EarthElementalHP'];
		v63 = EpicSettings.Settings['EarthElementalTankHP'];
		v76 = EpicSettings.Settings['ManaTideTotemMana'];
		v77 = EpicSettings.Settings['PrimordialWaveHP'];
		v86 = EpicSettings.Settings['UseAncestralGuidance'];
		v87 = EpicSettings.Settings['UseAscendance'];
		v88 = EpicSettings.Settings['UseAstralShift'];
		v91 = EpicSettings.Settings['UseEarthElemental'];
		v97 = EpicSettings.Settings['UseManaTideTotem'];
		v35 = EpicSettings.Settings['UseRacials'];
		v101 = EpicSettings.Settings['UseWellspring'];
		v102 = EpicSettings.Settings['WellspringGroup'];
		v103 = EpicSettings.Settings['WellspringHP'];
		v104 = EpicSettings.Settings['racialsWithCD'];
		v105 = EpicSettings.Settings['trinketsWithCD'];
		v106 = EpicSettings.Settings['useTrinkets'];
		v107 = EpicSettings.Settings['fightRemainsCheck'];
		v108 = EpicSettings.Settings['handleAfflicted'];
		v109 = EpicSettings.Settings['HandleIncorporeal'];
		v110 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v111 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v131()
		local v216 = 0 - 0;
		local v217;
		while true do
			if ((v216 == (1 + 0)) or ((7103 - 2335) <= (1772 - 926))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v216 = 1965 - (556 + 1407);
			end
			if ((v216 == (1206 - (741 + 465))) or ((3823 - (170 + 295)) <= (749 + 671))) then
				v129();
				v130();
				v30 = EpicSettings.Toggles['ooc'];
				v216 = 1 + 0;
			end
			if ((v216 == (7 - 4)) or ((3100 + 639) <= (1928 + 1077))) then
				if ((v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(23 + 17) and (v119.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v115.EarthShield))) or ((2889 - (957 + 273)) >= (571 + 1563))) then
					if (v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield)) or ((1306 + 1954) < (8973 - 6618))) then
						return "earth_shield_tank main apl";
					end
				end
				v217 = nil;
				if (not v13:AffectingCombat() or ((1762 - 1093) == (12899 - 8676))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((8378 - 6686) < (2368 - (389 + 1391)))) then
						local v236 = v119.DeadFriendlyUnitsCount();
						if ((v236 > (1 + 0)) or ((500 + 4297) < (8311 - 4660))) then
							if (v24(v115.AncestralVision, nil, v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((5128 - (783 + 168)) > (16277 - 11427))) then
								return "ancestral_vision";
							end
						elseif (v24(v116.AncestralSpiritMouseover, not v15:IsInRange(40 + 0), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((711 - (309 + 2)) > (3411 - 2300))) then
							return "ancestral_spirit";
						end
					end
				end
				v216 = 1216 - (1090 + 122);
			end
			if (((990 + 2061) > (3375 - 2370)) and (v216 == (2 + 0))) then
				v34 = EpicSettings.Toggles['dps'];
				if (((4811 - (628 + 490)) <= (786 + 3596)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v13:AffectingCombat() or v30 or ((8125 - 4843) > (18737 - 14637))) then
					local v232 = 774 - (431 + 343);
					local v233;
					while true do
						if ((v232 == (1 - 0)) or ((10356 - 6776) < (2247 + 597))) then
							if (((12 + 77) < (6185 - (556 + 1139))) and (not v17:BuffDown(v115.EarthShield) or (v119.UnitGroupRole(v17) ~= "TANK") or not v92 or (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 40 - (6 + 9)) >= (1 + 0)))) then
								local v237 = 0 + 0;
								while true do
									if ((v237 == (169 - (28 + 141))) or ((1931 + 3052) < (2231 - 423))) then
										v29 = v119.FocusUnit(v233, nil, nil, nil);
										if (((2712 + 1117) > (5086 - (486 + 831))) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((3864 - 2379) <= (10223 - 7319)) and (v232 == (0 + 0))) then
							v233 = v43 and v115.PurifySpirit:IsReady() and v32;
							if (((13498 - 9229) == (5532 - (668 + 595))) and v115.EarthShield:IsReady() and v92 and (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 23 + 2) < (1 + 0))) then
								local v238 = 0 - 0;
								while true do
									if (((677 - (23 + 267)) <= (4726 - (1129 + 815))) and (v238 == (387 - (371 + 16)))) then
										v29 = v119.FocusUnitRefreshableBuff(v115.EarthShield, 1765 - (1326 + 424), 75 - 35, "TANK", true, 91 - 66);
										if (v29 or ((2017 - (88 + 30)) <= (1688 - (720 + 51)))) then
											return v29;
										end
										v238 = 2 - 1;
									end
									if ((v238 == (1777 - (421 + 1355))) or ((7113 - 2801) <= (431 + 445))) then
										if (((3315 - (286 + 797)) <= (9489 - 6893)) and (v119.UnitGroupRole(v17) == "TANK")) then
											if (((3469 - 1374) < (4125 - (397 + 42))) and v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield))) then
												return "earth_shield_tank main apl";
											end
										end
										break;
									end
								end
							end
							v232 = 1 + 0;
						end
					end
				end
				v216 = 803 - (24 + 776);
			end
			if ((v216 == (5 - 1)) or ((2380 - (222 + 563)) >= (9857 - 5383))) then
				if (v119.TargetIsValid() or v13:AffectingCombat() or ((3326 + 1293) < (3072 - (23 + 167)))) then
					v114 = v13:GetEnemiesInRange(1838 - (690 + 1108));
					v112 = v10.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (4009 + 7102)) or ((243 + 51) >= (5679 - (40 + 808)))) then
						v113 = v10.FightRemains(v114, false);
					end
				end
				if (((335 + 1694) <= (11792 - 8708)) and v13:AffectingCombat() and v119.TargetIsValid()) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (2 + 0)) or ((1118 + 919) == (2991 - (47 + 524)))) then
							v217 = v123();
							if (((2894 + 1564) > (10671 - 6767)) and v217) then
								return v217;
							end
							if (((651 - 215) >= (280 - 157)) and (v113 > v107)) then
								v217 = v125();
								if (((2226 - (1165 + 561)) < (54 + 1762)) and v217) then
									return v217;
								end
							end
							break;
						end
						if (((11069 - 7495) == (1364 + 2210)) and ((480 - (341 + 138)) == v234)) then
							v29 = v119.InterruptWithStunCursor(v115.CapacitorTotem, v116.CapacitorTotemCursor, 9 + 21, nil, v16);
							if (((455 - 234) < (716 - (89 + 237))) and v29) then
								return v29;
							end
							if (v109 or ((7119 - 4906) <= (2991 - 1570))) then
								local v239 = 881 - (581 + 300);
								while true do
									if (((4278 - (855 + 365)) < (11543 - 6683)) and (v239 == (0 + 0))) then
										v29 = v119.HandleIncorporeal(v115.Hex, v116.HexMouseOver, 1265 - (1030 + 205), true);
										if (v29 or ((1217 + 79) >= (4136 + 310))) then
											return v29;
										end
										break;
									end
								end
							end
							if (v108 or ((1679 - (156 + 130)) > (10199 - 5710))) then
								v29 = v119.HandleAfflicted(v115.PurifySpirit, v116.PurifySpiritMouseover, 50 - 20);
								if (v29 or ((9060 - 4636) < (8 + 19))) then
									return v29;
								end
								if (v110 or ((1165 + 832) > (3884 - (10 + 59)))) then
									v29 = v119.HandleAfflicted(v115.TremorTotem, v115.TremorTotem, 9 + 21);
									if (((17064 - 13599) > (3076 - (671 + 492))) and v29) then
										return v29;
									end
								end
								if (((584 + 149) < (3034 - (369 + 846))) and v111) then
									v29 = v119.HandleAfflicted(v115.PoisonCleansingTotem, v115.PoisonCleansingTotem, 8 + 22);
									if (v29 or ((3751 + 644) == (6700 - (1036 + 909)))) then
										return v29;
									end
								end
							end
							v234 = 2 + 0;
						end
						if ((v234 == (0 - 0)) or ((3996 - (11 + 192)) < (1198 + 1171))) then
							v29 = v119.Interrupt(v115.WindShear, 205 - (135 + 40), true);
							if (v29 or ((9894 - 5810) == (160 + 105))) then
								return v29;
							end
							v29 = v119.InterruptCursor(v115.WindShear, v116.WindShearMouseover, 66 - 36, true, v16);
							if (((6532 - 2174) == (4534 - (50 + 126))) and v29) then
								return v29;
							end
							v234 = 2 - 1;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((695 + 2443) < (2406 - (1233 + 180)))) then
					local v235 = 969 - (522 + 447);
					while true do
						if (((4751 - (107 + 1314)) > (1078 + 1245)) and (v235 == (8 - 5))) then
							if (v34 or ((1541 + 2085) == (7921 - 3932))) then
								if (v119.TargetIsValid() or ((3624 - 2708) == (4581 - (716 + 1194)))) then
									v217 = v128();
									if (((5 + 267) == (30 + 242)) and v217) then
										return v217;
									end
								end
							end
							break;
						end
						if (((4752 - (74 + 429)) <= (9334 - 4495)) and (v235 == (0 + 0))) then
							if (((6356 - 3579) < (2264 + 936)) and v32) then
								if (((292 - 197) < (4838 - 2881)) and v17 and v43) then
									if (((1259 - (279 + 154)) < (2495 - (454 + 324))) and v115.PurifySpirit:IsReady() and v119.DispellableFriendlyUnit(20 + 5)) then
										if (((1443 - (12 + 5)) >= (596 + 509)) and v24(v116.PurifySpiritFocus, not v17:IsSpellInRange(v115.PurifySpirit))) then
											return "purify_spirit dispel";
										end
									end
								end
							end
							if (((7017 - 4263) <= (1249 + 2130)) and (v17:HealthPercentage() < v77) and v17:BuffDown(v115.Riptide)) then
								if (v115.PrimordialWaveResto:IsCastable() or ((5020 - (277 + 816)) == (6037 - 4624))) then
									if (v24(v116.PrimordialWaveFocus, not v17:IsSpellInRange(v115.PrimordialWaveResto)) or ((2337 - (1058 + 125)) <= (148 + 640))) then
										return "primordial_wave main";
									end
								end
							end
							v235 = 976 - (815 + 160);
						end
						if ((v235 == (8 - 6)) or ((3900 - 2257) > (807 + 2572))) then
							if (v217 or ((8193 - 5390) > (6447 - (41 + 1857)))) then
								return v217;
							end
							if (v33 or ((2113 - (1222 + 671)) >= (7810 - 4788))) then
								v217 = v126();
								if (((4055 - 1233) == (4004 - (229 + 953))) and v217) then
									return v217;
								end
								v217 = v127();
								if (v217 or ((2835 - (1111 + 663)) == (3436 - (874 + 705)))) then
									return v217;
								end
							end
							v235 = 1 + 2;
						end
						if (((1884 + 876) > (2834 - 1470)) and (v235 == (1 + 0))) then
							if ((v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(719 - (642 + 37)) and (v119.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v115.EarthShield)) or ((1118 + 3784) <= (576 + 3019))) then
								if (v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield)) or ((9671 - 5819) == (747 - (233 + 221)))) then
									return "earth_shield_tank main fight";
								end
							end
							v217 = v124();
							v235 = 4 - 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v218 = 0 + 0;
		while true do
			if ((v218 == (1541 - (718 + 823))) or ((982 + 577) == (5393 - (266 + 539)))) then
				v121();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(747 - 483, v131, v132);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

