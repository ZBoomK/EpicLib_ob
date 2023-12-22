local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 626 - (512 + 114);
	local v6;
	while true do
		if (((12269 - 7563) > (9155 - 4726)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((1328 + 1526) < (767 + 3328)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (3 - 2)) or ((3052 - (109 + 1885)) >= (2671 - (1269 + 200)))) then
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
	local v112 = 21296 - 10185;
	local v113 = 11926 - (98 + 717);
	local v114;
	v10:RegisterForEvent(function()
		v112 = 11937 - (802 + 24);
		v113 = 19160 - 8049;
	end, "PLAYER_REGEN_ENABLED");
	local v115 = v18.Shaman.Restoration;
	local v116 = v25.Shaman.Restoration;
	local v117 = v20.Shaman.Restoration;
	local v118 = {};
	local v119 = v22.Commons.Everyone;
	local v120 = v22.Commons.Shaman;
	local function v121()
		if (((4686 - 975) > (496 + 2859)) and v115.ImprovedPurifySpirit:IsAvailable()) then
			v119.DispellableDebuffs = v21.MergeTable(v119.DispellableMagicDebuffs, v119.DispellableCurseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122(v133)
		return v133:DebuffRefreshable(v115.FlameShockDebuff) and (v113 > (4 + 1));
	end
	local function v123()
		local v134 = 0 + 0;
		while true do
			if (((1 + 0) == v134) or ((2520 - 1614) >= (7433 - 5204))) then
				if (((461 + 827) > (510 + 741)) and v117.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
					if (v24(v116.Healthstone) or ((3723 + 790) < (2438 + 914))) then
						return "healthstone defensive 3";
					end
				end
				if ((v38 and (v13:HealthPercentage() <= v39)) or ((965 + 1100) >= (4629 - (797 + 636)))) then
					if ((v40 == "Refreshing Healing Potion") or ((21247 - 16871) <= (3100 - (1427 + 192)))) then
						if (v117.RefreshingHealingPotion:IsReady() or ((1176 + 2216) >= (11007 - 6266))) then
							if (((2989 + 336) >= (977 + 1177)) and v24(v116.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v40 == "Dreamwalker's Healing Potion") or ((1621 - (192 + 134)) >= (4509 - (316 + 960)))) then
						if (((2436 + 1941) > (1268 + 374)) and v117.DreamwalkersHealingPotion:IsReady()) then
							if (((4366 + 357) > (5183 - 3827)) and v24(v116.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v134 == (551 - (83 + 468))) or ((5942 - (1202 + 604)) <= (16025 - 12592))) then
				if (((7064 - 2819) <= (12821 - 8190)) and v88 and v115.AstralShift:IsReady()) then
					if (((4601 - (45 + 280)) >= (3778 + 136)) and (v13:HealthPercentage() <= v54)) then
						if (((173 + 25) <= (1594 + 2771)) and v24(v115.AstralShift, not v15:IsInRange(23 + 17))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((842 + 3940) > (8658 - 3982)) and v91 and v115.EarthElemental:IsReady()) then
					if (((6775 - (340 + 1571)) > (867 + 1330)) and ((v13:HealthPercentage() <= v62) or v119.IsTankBelowHealthPercentage(v63))) then
						if (v24(v115.EarthElemental, not v15:IsInRange(1812 - (1733 + 39))) or ((10167 - 6467) == (3541 - (125 + 909)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v134 = 1949 - (1096 + 852);
			end
		end
	end
	local function v124()
		if (((2007 + 2467) >= (391 - 117)) and v41) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (512 - (409 + 103))) or ((2130 - (46 + 190)) <= (1501 - (51 + 44)))) then
					v29 = v119.HandleCharredTreant(v115.Riptide, v116.RiptideMouseover, 12 + 28);
					if (((2889 - (1114 + 203)) >= (2257 - (228 + 498))) and v29) then
						return v29;
					end
					v174 = 1 + 0;
				end
				if ((v174 == (2 + 0)) or ((5350 - (174 + 489)) < (11833 - 7291))) then
					v29 = v119.HandleCharredTreant(v115.HealingWave, v116.HealingWaveMouseover, 1945 - (830 + 1075));
					if (((3815 - (303 + 221)) > (2936 - (231 + 1038))) and v29) then
						return v29;
					end
					break;
				end
				if ((v174 == (1 + 0)) or ((2035 - (171 + 991)) == (8382 - 6348))) then
					v29 = v119.HandleCharredTreant(v115.HealingSurge, v116.HealingSurgeMouseover, 107 - 67);
					if (v29 or ((7027 - 4211) < (9 + 2))) then
						return v29;
					end
					v174 = 6 - 4;
				end
			end
		end
		if (((10670 - 6971) < (7585 - 2879)) and v42) then
			v29 = v119.HandleCharredBrambles(v115.Riptide, v116.RiptideMouseover, 123 - 83);
			if (((3894 - (111 + 1137)) >= (1034 - (91 + 67))) and v29) then
				return v29;
			end
			v29 = v119.HandleCharredBrambles(v115.HealingSurge, v116.HealingSurgeMouseover, 119 - 79);
			if (((154 + 460) <= (3707 - (423 + 100))) and v29) then
				return v29;
			end
			v29 = v119.HandleCharredBrambles(v115.HealingWave, v116.HealingWaveMouseover, 1 + 39);
			if (((8654 - 5528) == (1630 + 1496)) and v29) then
				return v29;
			end
		end
	end
	local function v125()
		local v135 = 771 - (326 + 445);
		while true do
			if ((v135 == (8 - 6)) or ((4872 - 2685) >= (11563 - 6609))) then
				if ((v95 and v119.AreUnitsBelowHealthPercentage(v74, v73) and v115.HealingTideTotem:IsReady()) or ((4588 - (530 + 181)) == (4456 - (614 + 267)))) then
					if (((739 - (19 + 13)) > (1028 - 396)) and v24(v115.HealingTideTotem, not v15:IsInRange(93 - 53))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v50, v49) and v115.AncestralProtectionTotem:IsReady()) or ((1559 - 1013) >= (698 + 1986))) then
					if (((2576 - 1111) <= (8919 - 4618)) and (v51 == "Player")) then
						if (((3516 - (1293 + 519)) > (2907 - 1482)) and v24(v116.AncestralProtectionTotemPlayer, not v15:IsInRange(104 - 64))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v51 == "Friendly under Cursor") or ((1313 - 626) == (18257 - 14023))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((7844 - 4514) < (757 + 672))) then
							if (((235 + 912) >= (778 - 443)) and v24(v116.AncestralProtectionTotemCursor, not v15:IsInRange(10 + 30))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((1142 + 2293) > (1311 + 786)) and (v51 == "Confirmation")) then
						if (v24(v115.AncestralProtectionTotem, not v15:IsInRange(1136 - (709 + 387))) or ((5628 - (673 + 1185)) >= (11719 - 7678))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v135 = 9 - 6;
			end
			if (((1 - 0) == v135) or ((2712 + 1079) <= (1204 + 407))) then
				if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((6180 - 1602) <= (494 + 1514))) then
					if (((2243 - 1118) <= (4074 - 1998)) and (v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) then
						if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((2623 - (446 + 1434)) >= (5682 - (1040 + 243)))) then
							return "riptide healingcd";
						end
					end
				end
				if (((3447 - 2292) < (3520 - (559 + 1288))) and v119.AreUnitsBelowHealthPercentage(v81, v80) and v115.SpiritLinkTotem:IsReady()) then
					if ((v82 == "Player") or ((4255 - (609 + 1322)) <= (1032 - (13 + 441)))) then
						if (((14076 - 10309) == (9867 - 6100)) and v24(v116.SpiritLinkTotemPlayer, not v15:IsInRange(199 - 159))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((153 + 3936) == (14850 - 10761)) and (v82 == "Friendly under Cursor")) then
						if (((1584 + 2874) >= (734 + 940)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((2884 - 1912) <= (776 + 642)) and v24(v116.SpiritLinkTotemCursor, not v15:IsInRange(73 - 33))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v82 == "Confirmation") or ((3265 + 1673) < (2649 + 2113))) then
						if (v24(v115.SpiritLinkTotem, not v15:IsInRange(29 + 11)) or ((2103 + 401) > (4172 + 92))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v135 = 435 - (153 + 280);
			end
			if (((6216 - 4063) == (1933 + 220)) and (v135 == (2 + 2))) then
				if ((v97 and (v13:Mana() <= v76) and v115.ManaTideTotem:IsReady()) or ((266 + 241) >= (2352 + 239))) then
					if (((3247 + 1234) == (6822 - 2341)) and v24(v115.ManaTideTotem, not v15:IsInRange(25 + 15))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v104 and v31) or not v104)) or ((2995 - (89 + 578)) < (496 + 197))) then
					local v231 = 0 - 0;
					while true do
						if (((5377 - (572 + 477)) == (584 + 3744)) and ((1 + 0) == v231)) then
							if (((190 + 1398) >= (1418 - (84 + 2))) and v115.Berserking:IsReady()) then
								if (v24(v115.Berserking, not v15:IsInRange(65 - 25)) or ((3008 + 1166) > (5090 - (497 + 345)))) then
									return "Berserking cooldowns";
								end
							end
							if (v115.BloodFury:IsReady() or ((118 + 4468) <= (14 + 68))) then
								if (((5196 - (605 + 728)) == (2757 + 1106)) and v24(v115.BloodFury, not v15:IsInRange(88 - 48))) then
									return "BloodFury cooldowns";
								end
							end
							v231 = 1 + 1;
						end
						if ((v231 == (7 - 5)) or ((255 + 27) <= (116 - 74))) then
							if (((3481 + 1128) >= (1255 - (457 + 32))) and v115.Fireblood:IsReady()) then
								if (v24(v115.Fireblood, not v15:IsInRange(17 + 23)) or ((2554 - (832 + 570)) == (2344 + 144))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((893 + 2529) > (11855 - 8505)) and (v231 == (0 + 0))) then
							if (((1673 - (588 + 208)) > (1013 - 637)) and v115.AncestralCall:IsReady()) then
								if (v24(v115.AncestralCall, not v15:IsInRange(1840 - (884 + 916))) or ((6527 - 3409) <= (1074 + 777))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v115.BagofTricks:IsReady() or ((818 - (232 + 421)) >= (5381 - (1569 + 320)))) then
								if (((969 + 2980) < (923 + 3933)) and v24(v115.BagofTricks, not v15:IsInRange(134 - 94))) then
									return "BagofTricks cooldowns";
								end
							end
							v231 = 606 - (316 + 289);
						end
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((198 + 4078) < (4469 - (666 + 787)))) then
				if (((5115 - (360 + 65)) > (3856 + 269)) and v106 and ((v31 and v105) or not v105)) then
					local v232 = 254 - (79 + 175);
					while true do
						if ((v232 == (1 - 0)) or ((40 + 10) >= (2746 - 1850))) then
							v29 = v119.HandleBottomTrinket(v118, v31, 77 - 37, nil);
							if (v29 or ((2613 - (503 + 396)) >= (3139 - (92 + 89)))) then
								return v29;
							end
							break;
						end
						if ((v232 == (0 - 0)) or ((765 + 726) < (382 + 262))) then
							v29 = v119.HandleTopTrinket(v118, v31, 156 - 116, nil);
							if (((97 + 607) < (2250 - 1263)) and v29) then
								return v29;
							end
							v232 = 1 + 0;
						end
					end
				end
				if (((1776 + 1942) > (5804 - 3898)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
					if ((v17:HealthPercentage() <= v78) or ((120 + 838) > (5543 - 1908))) then
						if (((4745 - (485 + 759)) <= (10393 - 5901)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v135 = 1190 - (442 + 747);
			end
			if ((v135 == (1138 - (832 + 303))) or ((4388 - (88 + 858)) < (777 + 1771))) then
				if (((2380 + 495) >= (61 + 1403)) and v86 and v119.AreUnitsBelowHealthPercentage(v48, v47) and v115.AncestralGuidance:IsReady()) then
					if (v24(v115.AncestralGuidance, not v15:IsInRange(829 - (766 + 23))) or ((23681 - 18884) >= (6691 - 1798))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v87 and v119.AreUnitsBelowHealthPercentage(v53, v52) and v115.Ascendance:IsReady()) or ((1451 - 900) > (7018 - 4950))) then
					if (((3187 - (1036 + 37)) > (670 + 274)) and v24(v115.Ascendance, not v15:IsInRange(77 - 37))) then
						return "ascendance cooldowns";
					end
				end
				v135 = 4 + 0;
			end
		end
	end
	local function v126()
		if ((v89 and v119.AreUnitsBelowHealthPercentage(1575 - (641 + 839), 916 - (910 + 3)) and v115.ChainHeal:IsReady() and v13:BuffUp(v115.HighTide)) or ((5766 - 3504) >= (4780 - (1466 + 218)))) then
			if (v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((1037 + 1218) >= (4685 - (556 + 592)))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v96 and (v17:HealthPercentage() <= v75) and v115.HealingWave:IsReady() and (v115.PrimordialWaveResto:TimeSinceLastCast() < (6 + 9))) or ((4645 - (329 + 479)) < (2160 - (174 + 680)))) then
			if (((10136 - 7186) == (6114 - 3164)) and v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((3373 + 1350) < (4037 - (396 + 343)))) then
			if (((101 + 1035) >= (1631 - (29 + 1448))) and (v17:HealthPercentage() <= v78)) then
				if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((1660 - (135 + 1254)) > (17886 - 13138))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((22131 - 17391) >= (2101 + 1051)) and v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) then
			if (((v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) or ((4105 - (389 + 1138)) >= (3964 - (102 + 472)))) then
				if (((39 + 2) <= (922 + 739)) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((561 + 40) < (5105 - (320 + 1225))) and v100 and v115.UnleashLife:IsReady()) then
			if (((418 - 183) < (421 + 266)) and (v17:HealthPercentage() <= v85)) then
				if (((6013 - (157 + 1307)) > (3012 - (821 + 1038))) and v24(v115.UnleashLife, not v17:IsSpellInRange(v115.UnleashLife))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v69 == "Cursor") and v115.HealingRain:IsReady()) or ((11661 - 6987) < (511 + 4161))) then
			if (((6515 - 2847) < (1697 + 2864)) and v24(v116.HealingRainCursor, not v15:IsInRange(99 - 59), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v119.AreUnitsBelowHealthPercentage(v68, v67) and v115.HealingRain:IsReady()) or ((1481 - (834 + 192)) == (230 + 3375))) then
			if ((v69 == "Player") or ((684 + 1979) == (72 + 3240))) then
				if (((6625 - 2348) <= (4779 - (300 + 4))) and v24(v116.HealingRainPlayer, not v15:IsInRange(11 + 29), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif ((v69 == "Friendly under Cursor") or ((2277 - 1407) == (1551 - (112 + 250)))) then
				if (((620 + 933) <= (7848 - 4715)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v116.HealingRainCursor, not v15:IsInRange(23 + 17), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((1157 + 1080) >= (2626 + 885))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v69 == "Enemy under Cursor") or ((657 + 667) > (2244 + 776))) then
				if ((v16:Exists() and v13:CanAttack(v16)) or ((4406 - (1001 + 413)) == (4194 - 2313))) then
					if (((3988 - (244 + 638)) > (2219 - (627 + 66))) and v24(v116.HealingRainCursor, not v15:IsInRange(119 - 79), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((3625 - (512 + 90)) < (5776 - (1665 + 241))) and (v69 == "Confirmation")) then
				if (((860 - (373 + 344)) > (34 + 40)) and v24(v115.HealingRain, not v15:IsInRange(11 + 29), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((47 - 29) < (3573 - 1461)) and v119.AreUnitsBelowHealthPercentage(v65, v64) and v115.EarthenWallTotem:IsReady()) then
			if (((2196 - (35 + 1064)) <= (1185 + 443)) and (v66 == "Player")) then
				if (((9906 - 5276) == (19 + 4611)) and v24(v116.EarthenWallTotemPlayer, not v15:IsInRange(1276 - (298 + 938)))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((4799 - (233 + 1026)) > (4349 - (636 + 1030))) and (v66 == "Friendly under Cursor")) then
				if (((2452 + 2342) >= (3199 + 76)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((441 + 1043) == (101 + 1383)) and v24(v116.EarthenWallTotemCursor, not v15:IsInRange(261 - (55 + 166)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((278 + 1154) < (358 + 3197)) and (v66 == "Confirmation")) then
				if (v24(v115.EarthenWallTotem, not v15:IsInRange(152 - 112)) or ((1362 - (36 + 261)) > (6257 - 2679))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if ((v119.AreUnitsBelowHealthPercentage(v60, v59) and v115.Downpour:IsReady()) or ((6163 - (34 + 1334)) < (541 + 866))) then
			if (((1440 + 413) < (6096 - (1035 + 248))) and (v61 == "Player")) then
				if (v24(v116.DownpourPlayer, not v15:IsInRange(61 - (20 + 1)), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((1470 + 1351) < (2750 - (134 + 185)))) then
					return "downpour healingaoe";
				end
			elseif ((v61 == "Friendly under Cursor") or ((4007 - (549 + 584)) < (2866 - (314 + 371)))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((9231 - 6542) <= (1311 - (478 + 490)))) then
					if (v24(v116.DownpourCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3041 - (786 + 386)) == (6506 - 4497))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v61 == "Confirmation") or ((4925 - (1055 + 324)) < (3662 - (1093 + 247)))) then
				if (v24(v115.Downpour, not v15:IsInRange(36 + 4), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((219 + 1863) == (18949 - 14176))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((11009 - 7765) > (3002 - 1947)) and v90 and v119.AreUnitsBelowHealthPercentage(v58, v57) and v115.CloudburstTotem:IsReady()) then
			if (v24(v115.CloudburstTotem) or ((8325 - 5012) <= (633 + 1145))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v101 and v119.AreUnitsBelowHealthPercentage(v103, v102) and v115.Wellspring:IsReady()) or ((5474 - 4053) >= (7252 - 5148))) then
			if (((1367 + 445) <= (8308 - 5059)) and v24(v115.Wellspring, not v15:IsInRange(728 - (364 + 324)), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if (((4448 - 2825) <= (4696 - 2739)) and v89 and v119.AreUnitsBelowHealthPercentage(v56, v55) and v115.ChainHeal:IsReady()) then
			if (((1463 + 2949) == (18461 - 14049)) and v24(v116.ChainHealFocus, not v17:IsSpellInRange(v115.ChainHeal), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if (((2802 - 1052) >= (2557 - 1715)) and v99 and v13:IsMoving() and v119.AreUnitsBelowHealthPercentage(v84, v83) and v115.SpiritwalkersGrace:IsReady()) then
			if (((5640 - (1249 + 19)) > (1670 + 180)) and v24(v115.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if (((902 - 670) < (1907 - (686 + 400))) and v93 and v119.AreUnitsBelowHealthPercentage(v71, v70) and v115.HealingStreamTotem:IsReady()) then
			if (((407 + 111) < (1131 - (73 + 156))) and v24(v115.HealingStreamTotem, nil)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v127()
		local v136 = 0 + 0;
		while true do
			if (((3805 - (721 + 90)) > (10 + 848)) and (v136 == (6 - 4))) then
				if ((v115.ElementalOrbit:IsAvailable() and v13:BuffUp(v115.EarthShieldBuff)) or ((4225 - (224 + 246)) <= (1482 - 567))) then
					if (((7265 - 3319) > (679 + 3064)) and v119.IsSoloMode()) then
						if ((v115.LightningShield:IsReady() and v13:BuffDown(v115.LightningShield)) or ((32 + 1303) >= (2429 + 877))) then
							if (((9630 - 4786) > (7497 - 5244)) and v24(v115.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif (((965 - (203 + 310)) == (2445 - (1238 + 755))) and v115.WaterShield:IsReady() and v13:BuffDown(v115.WaterShield)) then
						if (v24(v115.WaterShield) or ((319 + 4238) < (3621 - (709 + 825)))) then
							return "water_shield healingst";
						end
					end
				end
				if (((7138 - 3264) == (5643 - 1769)) and v94 and v115.HealingSurge:IsReady()) then
					if ((v17:HealthPercentage() <= v72) or ((2802 - (196 + 668)) > (19484 - 14549))) then
						if (v24(v116.HealingSurgeFocus, not v17:IsSpellInRange(v115.HealingSurge), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((8813 - 4558) < (4256 - (171 + 662)))) then
							return "healing_surge healingst";
						end
					end
				end
				v136 = 96 - (4 + 89);
			end
			if (((5096 - 3642) <= (908 + 1583)) and (v136 == (0 - 0))) then
				if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((1631 + 2526) <= (4289 - (35 + 1451)))) then
					if (((6306 - (28 + 1425)) >= (4975 - (941 + 1052))) and (v17:HealthPercentage() <= v78)) then
						if (((3964 + 170) > (4871 - (822 + 692))) and v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((4878 - 1461) < (1194 + 1340))) then
					if (((v17:HealthPercentage() <= v79) and (v119.UnitGroupRole(v17) == "TANK")) or ((3019 - (45 + 252)) <= (163 + 1))) then
						if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((829 + 1579) < (5132 - 3023))) then
							return "riptide healingaoe";
						end
					end
				end
				v136 = 434 - (114 + 319);
			end
			if ((v136 == (1 - 0)) or ((41 - 8) == (928 + 527))) then
				if ((v98 and v13:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v17:BuffDown(v115.Riptide)) or ((659 - 216) >= (8412 - 4397))) then
					if (((5345 - (556 + 1407)) > (1372 - (741 + 465))) and ((v17:HealthPercentage() <= v78) or (v17:HealthPercentage() <= v78))) then
						if (v24(v116.RiptideFocus, not v17:IsSpellInRange(v115.Riptide)) or ((745 - (170 + 295)) == (1612 + 1447))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((1728 + 153) > (3183 - 1890)) and v115.ElementalOrbit:IsAvailable() and v13:BuffDown(v115.EarthShieldBuff)) then
					if (((1954 + 403) == (1512 + 845)) and v24(v115.EarthShield)) then
						return "earth_shield healingst";
					end
				end
				v136 = 2 + 0;
			end
			if (((1353 - (957 + 273)) == (33 + 90)) and (v136 == (2 + 1))) then
				if ((v96 and v115.HealingWave:IsReady()) or ((4023 - 2967) >= (8938 - 5546))) then
					if ((v17:HealthPercentage() <= v75) or ((3301 - 2220) < (5323 - 4248))) then
						if (v24(v116.HealingWaveFocus, not v17:IsSpellInRange(v115.HealingWave), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2829 - (389 + 1391)) >= (2781 + 1651))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (0 - 0)) or ((5719 - (783 + 168)) <= (2839 - 1993))) then
				if (v115.Stormkeeper:IsReady() or ((3304 + 54) <= (1731 - (309 + 2)))) then
					if (v24(v115.Stormkeeper, not v15:IsInRange(122 - 82)) or ((4951 - (1090 + 122)) <= (975 + 2030))) then
						return "stormkeeper damage";
					end
				end
				if ((#v13:GetEnemiesInRange(134 - 94) > (1 + 0)) or ((2777 - (628 + 490)) >= (383 + 1751))) then
					if (v115.ChainLightning:IsReady() or ((8071 - 4811) < (10762 - 8407))) then
						if (v24(v115.ChainLightning, not v15:IsSpellInRange(v115.ChainLightning), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((1443 - (431 + 343)) == (8528 - 4305))) then
							return "chain_lightning damage";
						end
					end
				end
				v137 = 2 - 1;
			end
			if ((v137 == (1 + 0)) or ((217 + 1475) < (2283 - (556 + 1139)))) then
				if (v115.FlameShock:IsReady() or ((4812 - (6 + 9)) < (669 + 2982))) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (169 - (28 + 141))) or ((1618 + 2559) > (5986 - 1136))) then
							if (v119.CastCycle(v115.FlameShock, v13:GetEnemiesInRange(29 + 11), v122, not v15:IsSpellInRange(v115.FlameShock), nil, nil, nil, nil) or ((1717 - (486 + 831)) > (2891 - 1780))) then
								return "flame_shock_cycle damage";
							end
							if (((10741 - 7690) > (190 + 815)) and v24(v115.FlameShock, not v15:IsSpellInRange(v115.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((11676 - 7983) <= (5645 - (668 + 595))) and v115.LavaBurst:IsReady()) then
					if (v24(v115.LavaBurst, not v15:IsSpellInRange(v115.LavaBurst), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((2954 + 328) > (827 + 3273))) then
						return "lava_burst damage";
					end
				end
				v137 = 5 - 3;
			end
			if ((v137 == (292 - (23 + 267))) or ((5524 - (1129 + 815)) < (3231 - (371 + 16)))) then
				if (((1839 - (1326 + 424)) < (8503 - 4013)) and v115.LightningBolt:IsReady()) then
					if (v24(v115.LightningBolt, not v15:IsSpellInRange(v115.LightningBolt), v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((18209 - 13226) < (1926 - (88 + 30)))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v129()
		local v138 = 771 - (720 + 51);
		while true do
			if (((8517 - 4688) > (5545 - (421 + 1355))) and (v138 == (10 - 3))) then
				v94 = EpicSettings.Settings['UseHealingSurge'];
				v95 = EpicSettings.Settings['UseHealingTideTotem'];
				v96 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v98 = EpicSettings.Settings['UseRiptide'];
				v99 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v138 = 4 + 4;
			end
			if (((2568 - (286 + 797)) <= (10615 - 7711)) and (v138 == (7 - 2))) then
				v79 = EpicSettings.Settings['RiptideTankHP'];
				v80 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v81 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v82 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v83 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v84 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v138 = 445 - (397 + 42);
			end
			if (((1334 + 2935) == (5069 - (24 + 776))) and (v138 == (12 - 4))) then
				v100 = EpicSettings.Settings['UseUnleashLife'];
				v110 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
				v111 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((1172 - (222 + 563)) <= (6129 - 3347)) and (v138 == (3 + 1))) then
				v75 = EpicSettings.Settings['HealingWaveHP'];
				v37 = EpicSettings.Settings['healthstoneHP'];
				v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v46 = EpicSettings.Settings['InterruptThreshold'];
				v44 = EpicSettings.Settings['InterruptWithStun'];
				v78 = EpicSettings.Settings['RiptideHP'];
				v138 = 195 - (23 + 167);
			end
			if ((v138 == (1800 - (690 + 1108))) or ((686 + 1213) <= (757 + 160))) then
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v39 = EpicSettings.Settings['HealingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v67 = EpicSettings.Settings['HealingRainGroup'];
				v68 = EpicSettings.Settings['HealingRainHP'];
				v138 = 851 - (40 + 808);
			end
			if ((v138 == (1 + 2)) or ((16488 - 12176) <= (838 + 38))) then
				v69 = EpicSettings.Settings['HealingRainUsage'];
				v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v71 = EpicSettings.Settings['HealingStreamTotemHP'];
				v72 = EpicSettings.Settings['HealingSurgeHP'];
				v73 = EpicSettings.Settings['HealingTideTotemGroup'];
				v74 = EpicSettings.Settings['HealingTideTotemHP'];
				v138 = 3 + 1;
			end
			if (((1224 + 1008) <= (3167 - (47 + 524))) and (v138 == (4 + 2))) then
				v85 = EpicSettings.Settings['UnleashLifeHP'];
				v89 = EpicSettings.Settings['UseChainHeal'];
				v90 = EpicSettings.Settings['UseCloudburstTotem'];
				v92 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['UseHealingPotion'];
				v93 = EpicSettings.Settings['UseHealingStreamTotem'];
				v138 = 19 - 12;
			end
			if (((3132 - 1037) < (8406 - 4720)) and ((1727 - (1165 + 561)) == v138)) then
				v59 = EpicSettings.Settings['DownpourGroup'];
				v60 = EpicSettings.Settings['DownpourHP'];
				v61 = EpicSettings.Settings['DownpourUsage'];
				v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v65 = EpicSettings.Settings['EarthenWallTotemHP'];
				v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v138 = 1 + 1;
			end
			if ((v138 == (0 - 0)) or ((609 + 986) >= (4953 - (341 + 138)))) then
				v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v55 = EpicSettings.Settings['ChainHealGroup'];
				v56 = EpicSettings.Settings['ChainHealHP'];
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v138 = 1 + 0;
			end
		end
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
		local v167 = 0 - 0;
		local v168;
		while true do
			if ((v167 == (326 - (89 + 237))) or ((14859 - 10240) < (6067 - 3185))) then
				v129();
				v130();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['cds'];
				v167 = 882 - (581 + 300);
			end
			if ((v167 == (1222 - (855 + 365))) or ((698 - 404) >= (1578 + 3253))) then
				if (((3264 - (1030 + 205)) <= (2896 + 188)) and (v13:AffectingCombat() or v30)) then
					local v234 = v43 and v115.PurifySpirit:IsReady() and v32;
					if ((v115.EarthShield:IsReady() and v92 and (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 24 + 1) < (287 - (156 + 130)))) or ((4628 - 2591) == (4078 - 1658))) then
						v29 = v119.FocusUnitRefreshableBuff(v115.EarthShield, 30 - 15, 11 + 29, "TANK", true, 15 + 10);
						if (((4527 - (10 + 59)) > (1105 + 2799)) and v29) then
							return v29;
						end
						if (((2147 - 1711) >= (1286 - (671 + 492))) and (v119.UnitGroupRole(v17) == "TANK")) then
							if (((399 + 101) < (3031 - (369 + 846))) and v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield))) then
								return "earth_shield_tank main apl";
							end
						end
					end
					if (((947 + 2627) == (3051 + 523)) and (not v17:BuffDown(v115.EarthShield) or (v119.UnitGroupRole(v17) ~= "TANK") or not v92 or (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 1970 - (1036 + 909)) >= (1 + 0)))) then
						v29 = v119.FocusUnit(v234, nil, nil, nil);
						if (((370 - 149) < (593 - (11 + 192))) and v29) then
							return v29;
						end
					end
				end
				if ((v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(21 + 19) and (v119.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v115.EarthShield))) or ((2388 - (135 + 40)) <= (3442 - 2021))) then
					if (((1844 + 1214) < (10706 - 5846)) and v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v168 = nil;
				if (not v13:AffectingCombat() or ((1942 - 646) >= (4622 - (50 + 126)))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((3878 - 2485) > (994 + 3495))) then
						local v235 = v119.DeadFriendlyUnitsCount();
						if ((v235 > (1414 - (1233 + 180))) or ((5393 - (522 + 447)) < (1448 - (107 + 1314)))) then
							if (v24(v115.AncestralVision, nil, v13:BuffDown(v115.SpiritwalkersGraceBuff)) or ((927 + 1070) > (11624 - 7809))) then
								return "ancestral_vision";
							end
						elseif (((1472 + 1993) > (3798 - 1885)) and v24(v116.AncestralSpiritMouseover, not v15:IsInRange(158 - 118), v13:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v167 = 1913 - (716 + 1194);
			end
			if (((13 + 720) < (195 + 1624)) and ((506 - (74 + 429)) == v167)) then
				if ((v13:AffectingCombat() and v119.TargetIsValid()) or ((8478 - 4083) == (2357 + 2398))) then
					v114 = v13:GetEnemiesInRange(91 - 51);
					v112 = v10.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (7861 + 3250)) or ((11693 - 7900) < (5857 - 3488))) then
						v113 = v10.FightRemains(v114, false);
					end
					v29 = v119.Interrupt(v115.WindShear, 463 - (279 + 154), true);
					if (v29 or ((4862 - (454 + 324)) == (209 + 56))) then
						return v29;
					end
					v29 = v119.InterruptCursor(v115.WindShear, v116.WindShearMouseover, 47 - (12 + 5), true, v16);
					if (((2350 + 2008) == (11104 - 6746)) and v29) then
						return v29;
					end
					v29 = v119.InterruptWithStunCursor(v115.CapacitorTotem, v116.CapacitorTotemCursor, 12 + 18, nil, v16);
					if (v29 or ((4231 - (277 + 816)) < (4243 - 3250))) then
						return v29;
					end
					if (((4513 - (1058 + 125)) > (436 + 1887)) and v109) then
						local v236 = 975 - (815 + 160);
						while true do
							if ((v236 == (0 - 0)) or ((8607 - 4981) == (952 + 3037))) then
								v29 = v119.HandleIncorporeal(v115.Hex, v116.HexMouseOver, 87 - 57, true);
								if (v29 or ((2814 - (41 + 1857)) == (4564 - (1222 + 671)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((702 - 430) == (390 - 118)) and v108) then
						v29 = v119.HandleAfflicted(v115.PurifySpirit, v116.PurifySpiritMouseover, 1212 - (229 + 953));
						if (((6023 - (1111 + 663)) <= (6418 - (874 + 705))) and v29) then
							return v29;
						end
						if (((389 + 2388) < (2184 + 1016)) and v110) then
							v29 = v119.HandleAfflicted(v115.TremorTotem, v115.TremorTotem, 62 - 32);
							if (((3 + 92) < (2636 - (642 + 37))) and v29) then
								return v29;
							end
						end
						if (((189 + 637) < (275 + 1442)) and v111) then
							v29 = v119.HandleAfflicted(v115.PoisonCleansingTotem, v115.PoisonCleansingTotem, 75 - 45);
							if (((1880 - (233 + 221)) >= (2555 - 1450)) and v29) then
								return v29;
							end
						end
					end
					v168 = v123();
					if (((2424 + 330) <= (4920 - (718 + 823))) and v168) then
						return v168;
					end
					if ((v113 > v107) or ((2472 + 1455) == (2218 - (266 + 539)))) then
						local v237 = 0 - 0;
						while true do
							if ((v237 == (1225 - (636 + 589))) or ((2738 - 1584) <= (1625 - 837))) then
								v168 = v125();
								if (v168 or ((1303 + 340) > (1228 + 2151))) then
									return v168;
								end
								break;
							end
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((3818 - (657 + 358)) > (12044 - 7495))) then
					if (v32 or ((501 - 281) >= (4209 - (1151 + 36)))) then
						if (((2726 + 96) == (742 + 2080)) and v17 and v43) then
							if ((v115.PurifySpirit:IsReady() and v119.DispellableFriendlyUnit(74 - 49)) or ((2893 - (1552 + 280)) == (2691 - (64 + 770)))) then
								if (((1874 + 886) > (3096 - 1732)) and v24(v116.PurifySpiritFocus, not v17:IsSpellInRange(v115.PurifySpirit))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					if (((v17:HealthPercentage() < v77) and v17:BuffDown(v115.Riptide)) or ((871 + 4031) <= (4838 - (157 + 1086)))) then
						if (v115.PrimordialWaveResto:IsCastable() or ((7709 - 3857) == (1283 - 990))) then
							if (v24(v116.PrimordialWaveFocus, not v17:IsSpellInRange(v115.PrimordialWaveResto)) or ((2390 - 831) == (6261 - 1673))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v115.EarthShield:IsCastable() and v92 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(859 - (599 + 220)) and (v119.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v115.EarthShield)) or ((8929 - 4445) == (2719 - (1813 + 118)))) then
						if (((3340 + 1228) >= (5124 - (841 + 376))) and v24(v116.EarthShieldFocus, not v17:IsSpellInRange(v115.EarthShield))) then
							return "earth_shield_tank main fight";
						end
					end
					v168 = v124();
					if (((1745 - 499) < (807 + 2663)) and v168) then
						return v168;
					end
					if (((11103 - 7035) >= (1831 - (464 + 395))) and v33) then
						local v238 = 0 - 0;
						while true do
							if (((237 + 256) < (4730 - (467 + 370))) and (v238 == (1 - 0))) then
								v168 = v127();
								if (v168 or ((1082 + 391) >= (11421 - 8089))) then
									return v168;
								end
								break;
							end
							if ((v238 == (0 + 0)) or ((9424 - 5373) <= (1677 - (150 + 370)))) then
								v168 = v126();
								if (((1886 - (74 + 1208)) < (7085 - 4204)) and v168) then
									return v168;
								end
								v238 = 4 - 3;
							end
						end
					end
					if (v34 or ((641 + 259) == (3767 - (14 + 376)))) then
						if (((7733 - 3274) > (383 + 208)) and v119.TargetIsValid()) then
							v168 = v128();
							if (((2985 + 413) >= (2285 + 110)) and v168) then
								return v168;
							end
						end
					end
				end
				break;
			end
			if ((v167 == (2 - 1)) or ((1643 + 540) >= (2902 - (23 + 55)))) then
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (((4587 - 2651) == (1292 + 644)) and v13:IsDeadOrGhost()) then
					return;
				end
				v167 = 2 + 0;
			end
		end
	end
	local function v132()
		local v169 = 0 - 0;
		while true do
			if ((v169 == (0 + 0)) or ((5733 - (652 + 249)) < (11542 - 7229))) then
				v121();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(2132 - (708 + 1160), v131, v132);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

