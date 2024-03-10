local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((4525 - (466 + 145)) == (1649 + 526))) then
			return v6(...);
		end
		if ((v5 == (1151 - (255 + 896))) or ((14657 - 9875) < (2308 - 1109))) then
			v6 = v0[v4];
			if (not v6 or ((5763 - (503 + 396)) < (2083 - (92 + 89)))) then
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
	local v115;
	local v116;
	local v117;
	local v118;
	local v119 = 5699 + 5412;
	local v120 = 6577 + 4534;
	local v121;
	v10:RegisterForEvent(function()
		local v141 = 0 - 0;
		while true do
			if (((662 + 4177) >= (8436 - 4736)) and (v141 == (0 + 0))) then
				v119 = 5307 + 5804;
				v120 = 33840 - 22729;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v122 = v18.Shaman.Restoration;
	local v123 = v25.Shaman.Restoration;
	local v124 = v20.Shaman.Restoration;
	local v125 = {};
	local v126 = v22.Commons.Everyone;
	local v127 = v22.Commons.Shaman;
	local function v128()
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((135 + 940) > (2924 - 1006))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v142)
		return v142:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (1249 - (485 + 759)));
	end
	local function v130()
		local v143 = 0 - 0;
		while true do
			if (((1585 - (442 + 747)) <= (4939 - (832 + 303))) and (v143 == (947 - (88 + 858)))) then
				if ((v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((1271 + 2898) == (1810 + 377))) then
					if (((58 + 1348) == (2195 - (766 + 23))) and v24(v123.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((7558 - 6027) < (5840 - 1569)) and v38 and (v13:HealthPercentage() <= v39)) then
					local v255 = 0 - 0;
					while true do
						if (((2155 - 1520) == (1708 - (1036 + 37))) and (v255 == (0 + 0))) then
							if (((6568 - 3195) <= (2798 + 758)) and (v40 == "Refreshing Healing Potion")) then
								if (v124.RefreshingHealingPotion:IsReady() or ((4771 - (641 + 839)) < (4193 - (910 + 3)))) then
									if (((11181 - 6795) >= (2557 - (1466 + 218))) and v24(v123.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((424 + 497) <= (2250 - (556 + 592))) and (v40 == "Dreamwalker's Healing Potion")) then
								if (((1674 + 3032) >= (1771 - (329 + 479))) and v124.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v123.RefreshingHealingPotion) or ((1814 - (174 + 680)) <= (3010 - 2134))) then
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
			if ((v143 == (0 - 0)) or ((1476 + 590) == (1671 - (396 + 343)))) then
				if (((427 + 4398) < (6320 - (29 + 1448))) and v93 and v122.AstralShift:IsReady()) then
					if ((v13:HealthPercentage() <= v59) or ((5266 - (135 + 1254)) >= (17091 - 12554))) then
						if (v24(v122.AstralShift, not v15:IsInRange(186 - 146)) or ((2876 + 1439) < (3253 - (389 + 1138)))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v96 and v122.EarthElemental:IsReady()) or ((4253 - (102 + 472)) < (590 + 35))) then
					if ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 14 + 11, v122.ChainHeal) or ((4313 + 312) < (2177 - (320 + 1225)))) then
						if (v24(v122.EarthElemental, not v15:IsInRange(71 - 31)) or ((51 + 32) > (3244 - (157 + 1307)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v143 = 1860 - (821 + 1038);
			end
		end
	end
	local function v131()
		if (((1362 - 816) <= (118 + 959)) and v114) then
			local v158 = 0 - 0;
			while true do
				if ((v158 == (0 + 0)) or ((2468 - 1472) > (5327 - (834 + 192)))) then
					v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 2 + 28, true);
					if (((1045 + 3025) > (15 + 672)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (v113 or ((1015 - 359) >= (3634 - (300 + 4)))) then
			v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 9 + 21);
			if (v29 or ((6523 - 4031) <= (697 - (112 + 250)))) then
				return v29;
			end
			if (((1723 + 2599) >= (6418 - 3856)) and v115) then
				v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 18 + 12);
				if (v29 or ((1881 + 1756) >= (2820 + 950))) then
					return v29;
				end
			end
			if (v116 or ((1180 + 1199) > (3401 + 1177))) then
				local v250 = 1414 - (1001 + 413);
				while true do
					if ((v250 == (0 - 0)) or ((1365 - (244 + 638)) > (1436 - (627 + 66)))) then
						v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 89 - 59);
						if (((3056 - (512 + 90)) > (2484 - (1665 + 241))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if (((1647 - (373 + 344)) < (2011 + 2447)) and v41) then
			v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 11 + 29);
			if (((1746 - 1084) <= (1644 - 672)) and v29) then
				return v29;
			end
			v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 1139 - (35 + 1064));
			if (((3180 + 1190) == (9349 - 4979)) and v29) then
				return v29;
			end
		end
		if (v42 or ((20 + 4742) <= (2097 - (298 + 938)))) then
			local v159 = 1259 - (233 + 1026);
			while true do
				if ((v159 == (1668 - (636 + 1030))) or ((722 + 690) == (4165 + 99))) then
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 12 + 28);
					if (v29 or ((215 + 2953) < (2374 - (55 + 166)))) then
						return v29;
					end
					v159 = 1 + 2;
				end
				if ((v159 == (1 + 0)) or ((19003 - 14027) < (1629 - (36 + 261)))) then
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 69 - 29);
					if (((5996 - (34 + 1334)) == (1780 + 2848)) and v29) then
						return v29;
					end
					v159 = 2 + 0;
				end
				if ((v159 == (1286 - (1035 + 248))) or ((75 - (20 + 1)) == (206 + 189))) then
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 359 - (134 + 185));
					if (((1215 - (549 + 584)) == (767 - (314 + 371))) and v29) then
						return v29;
					end
					break;
				end
				if ((v159 == (0 - 0)) or ((1549 - (478 + 490)) < (150 + 132))) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 1212 - (786 + 386));
					if (v29 or ((14928 - 10319) < (3874 - (1055 + 324)))) then
						return v29;
					end
					v159 = 1341 - (1093 + 247);
				end
			end
		end
		if (((1024 + 128) == (122 + 1030)) and v43) then
			local v160 = 0 - 0;
			while true do
				if (((6434 - 4538) <= (9737 - 6315)) and (v160 == (4 - 2))) then
					v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 15 + 25);
					if (v29 or ((3813 - 2823) > (5583 - 3963))) then
						return v29;
					end
					v160 = 3 + 0;
				end
				if ((v160 == (0 - 0)) or ((1565 - (364 + 324)) > (12870 - 8175))) then
					v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 95 - 55);
					if (((892 + 1799) >= (7745 - 5894)) and v29) then
						return v29;
					end
					v160 = 1 - 0;
				end
				if (((8 - 5) == v160) or ((4253 - (1249 + 19)) >= (4384 + 472))) then
					v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 155 - 115);
					if (((5362 - (686 + 400)) >= (938 + 257)) and v29) then
						return v29;
					end
					break;
				end
				if (((3461 - (73 + 156)) <= (23 + 4667)) and (v160 == (812 - (721 + 90)))) then
					v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 1 + 39);
					if (v29 or ((2909 - 2013) >= (3616 - (224 + 246)))) then
						return v29;
					end
					v160 = 2 - 0;
				end
			end
		end
		if (((5635 - 2574) >= (537 + 2421)) and v44) then
			local v161 = 0 + 0;
			while true do
				if (((2341 + 846) >= (1279 - 635)) and (v161 == (3 - 2))) then
					v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 553 - (203 + 310));
					if (((2637 - (1238 + 755)) <= (50 + 654)) and v29) then
						return v29;
					end
					v161 = 1536 - (709 + 825);
				end
				if (((1765 - 807) > (1379 - 432)) and (v161 == (864 - (196 + 668)))) then
					v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 157 - 117);
					if (((9304 - 4812) >= (3487 - (171 + 662))) and v29) then
						return v29;
					end
					v161 = 94 - (4 + 89);
				end
				if (((12063 - 8621) >= (548 + 955)) and (v161 == (13 - 10))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 16 + 24);
					if (v29 or ((4656 - (35 + 1451)) <= (2917 - (28 + 1425)))) then
						return v29;
					end
					break;
				end
				if ((v161 == (1995 - (941 + 1052))) or ((4600 + 197) == (5902 - (822 + 692)))) then
					v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 57 - 17);
					if (((260 + 291) <= (978 - (45 + 252))) and v29) then
						return v29;
					end
					v161 = 3 + 0;
				end
			end
		end
	end
	local function v132()
		local v144 = 0 + 0;
		while true do
			if (((7974 - 4697) > (840 - (114 + 319))) and (v144 == (1 - 0))) then
				if (((6016 - 1321) >= (903 + 512)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if ((v17:HealthPercentage() <= v83) or ((4784 - 1572) <= (1977 - 1033))) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((5059 - (556 + 1407)) <= (3004 - (741 + 465)))) then
							return "riptide healingcd";
						end
					end
				end
				if (((4002 - (170 + 295)) == (1864 + 1673)) and v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) then
					if (((3525 + 312) >= (3865 - 2295)) and (v87 == "Player")) then
						if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(34 + 6)) or ((1892 + 1058) == (2159 + 1653))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((5953 - (957 + 273)) >= (620 + 1698)) and (v87 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((812 + 1215) > (10867 - 8015))) then
							if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(105 - 65)) or ((3469 - 2333) > (21376 - 17059))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((6528 - (389 + 1391)) == (2979 + 1769)) and (v87 == "Confirmation")) then
						if (((389 + 3347) <= (10791 - 6051)) and v24(v122.SpiritLinkTotem, not v15:IsInRange(991 - (783 + 168)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 6 - 4;
			end
			if ((v144 == (0 + 0)) or ((3701 - (309 + 2)) <= (9396 - 6336))) then
				if ((v111 and ((v31 and v110) or not v110)) or ((2211 - (1090 + 122)) > (874 + 1819))) then
					local v256 = 0 - 0;
					while true do
						if (((317 + 146) < (1719 - (628 + 490))) and (v256 == (1 + 0))) then
							v29 = v126.HandleBottomTrinket(v125, v31, 99 - 59, nil);
							if (v29 or ((9976 - 7793) < (1461 - (431 + 343)))) then
								return v29;
							end
							break;
						end
						if (((9186 - 4637) == (13159 - 8610)) and (v256 == (0 + 0))) then
							v29 = v126.HandleTopTrinket(v125, v31, 6 + 34, nil);
							if (((6367 - (556 + 1139)) == (4687 - (6 + 9))) and v29) then
								return v29;
							end
							v256 = 1 + 0;
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1880 + 1788) < (564 - (28 + 141)))) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((1614 + 2552) == (561 - 106))) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((3152 + 1297) == (3980 - (486 + 831)))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 2 - 1;
			end
			if ((v144 == (10 - 7)) or ((809 + 3468) < (9450 - 6461))) then
				if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) or ((2133 - (668 + 595)) >= (3734 + 415))) then
					if (((446 + 1766) < (8680 - 5497)) and v24(v122.AncestralGuidance, not v15:IsInRange(330 - (23 + 267)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((6590 - (1129 + 815)) > (3379 - (371 + 16))) and v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) then
					if (((3184 - (1326 + 424)) < (5882 - 2776)) and v24(v122.Ascendance, not v15:IsInRange(146 - 106))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 122 - (88 + 30);
			end
			if (((1557 - (720 + 51)) < (6724 - 3701)) and (v144 == (1778 - (421 + 1355)))) then
				if ((v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) or ((4027 - 1585) < (37 + 37))) then
					if (((5618 - (286 + 797)) == (16578 - 12043)) and v24(v122.HealingTideTotem, not v15:IsInRange(66 - 26))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) or ((3448 - (397 + 42)) <= (658 + 1447))) then
					if (((2630 - (24 + 776)) < (5651 - 1982)) and (v56 == "Player")) then
						if (v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(825 - (222 + 563))) or ((3150 - 1720) >= (2601 + 1011))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((2873 - (23 + 167)) >= (4258 - (690 + 1108))) and (v56 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((651 + 1153) >= (2702 + 573))) then
							if (v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(888 - (40 + 808))) or ((234 + 1183) > (13877 - 10248))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((4583 + 212) > (213 + 189)) and (v56 == "Confirmation")) then
						if (((2640 + 2173) > (4136 - (47 + 524))) and v24(v122.AncestralProtectionTotem, not v15:IsInRange(26 + 14))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 8 - 5;
			end
			if (((5848 - 1936) == (8921 - 5009)) and (v144 == (1730 - (1165 + 561)))) then
				if (((84 + 2737) <= (14940 - 10116)) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
					if (((664 + 1074) <= (2674 - (341 + 138))) and v24(v122.ManaTideTotem, not v15:IsInRange(11 + 29))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((84 - 43) <= (3344 - (89 + 237))) and v35 and ((v109 and v31) or not v109)) then
					local v257 = 0 - 0;
					while true do
						if (((4515 - 2370) <= (4985 - (581 + 300))) and (v257 == (1221 - (855 + 365)))) then
							if (((6386 - 3697) < (1582 + 3263)) and v122.Berserking:IsReady()) then
								if (v24(v122.Berserking, not v15:IsInRange(1275 - (1030 + 205))) or ((2180 + 142) > (2440 + 182))) then
									return "Berserking cooldowns";
								end
							end
							if (v122.BloodFury:IsReady() or ((4820 - (156 + 130)) == (4730 - 2648))) then
								if (v24(v122.BloodFury, not v15:IsInRange(67 - 27)) or ((3217 - 1646) > (492 + 1375))) then
									return "BloodFury cooldowns";
								end
							end
							v257 = 2 + 0;
						end
						if ((v257 == (69 - (10 + 59))) or ((751 + 1903) >= (14754 - 11758))) then
							if (((5141 - (671 + 492)) > (1675 + 429)) and v122.AncestralCall:IsReady()) then
								if (((4210 - (369 + 846)) > (408 + 1133)) and v24(v122.AncestralCall, not v15:IsInRange(35 + 5))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((5194 - (1036 + 909)) > (758 + 195)) and v122.BagofTricks:IsReady()) then
								if (v24(v122.BagofTricks, not v15:IsInRange(67 - 27)) or ((3476 - (11 + 192)) > (2311 + 2262))) then
									return "BagofTricks cooldowns";
								end
							end
							v257 = 176 - (135 + 40);
						end
						if ((v257 == (4 - 2)) or ((1900 + 1251) < (2828 - 1544))) then
							if (v122.Fireblood:IsReady() or ((2773 - 923) == (1705 - (50 + 126)))) then
								if (((2286 - 1465) < (470 + 1653)) and v24(v122.Fireblood, not v15:IsInRange(1453 - (1233 + 180)))) then
									return "Fireblood cooldowns";
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
	local function v133()
		if (((1871 - (522 + 447)) < (3746 - (107 + 1314))) and v94 and v126.AreUnitsBelowHealthPercentage(45 + 50, 8 - 5, v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
			if (((365 + 493) <= (5881 - 2919)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (59 - 44))) or ((5856 - (716 + 1194)) < (22 + 1266))) then
			if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((348 + 2894) == (1070 - (74 + 429)))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1633 - 786) >= (626 + 637))) then
			if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((5157 - 2904) == (1310 + 541))) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((6434 - 4347) > (5864 - 3492))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((4878 - (279 + 154)) < (4927 - (454 + 324)))) then
			if ((v17:HealthPercentage() <= v83) or ((1431 + 387) == (102 - (12 + 5)))) then
				if (((340 + 290) < (5419 - 3292)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v105 and v122.UnleashLife:IsReady()) or ((717 + 1221) == (3607 - (277 + 816)))) then
			if (((18181 - 13926) >= (1238 - (1058 + 125))) and (v13:HealthPercentage() <= v90)) then
				if (((563 + 2436) > (2131 - (815 + 160))) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((10083 - 7733) > (2741 - 1586)) and (v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) then
			if (((962 + 3067) <= (14186 - 9333)) and v24(v123.HealingRainCursor, not v15:IsInRange(1938 - (41 + 1857)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) or ((2409 - (1222 + 671)) > (8875 - 5441))) then
			if (((5815 - 1769) >= (4215 - (229 + 953))) and (v74 == "Player")) then
				if (v24(v123.HealingRainPlayer, not v15:IsInRange(1814 - (1111 + 663)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4298 - (874 + 705)) <= (203 + 1244))) then
					return "healing_rain healingaoe";
				end
			elseif ((v74 == "Friendly under Cursor") or ((2821 + 1313) < (8160 - 4234))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((5 + 159) >= (3464 - (642 + 37)))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(10 + 30), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((84 + 441) == (5294 - 3185))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((487 - (233 + 221)) == (76 - 43)) and (v74 == "Enemy under Cursor")) then
				if (((2689 + 365) <= (5556 - (718 + 823))) and v16:Exists() and v13:CanAttack(v16)) then
					if (((1178 + 693) < (4187 - (266 + 539))) and v24(v123.HealingRainCursor, not v15:IsInRange(113 - 73), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((2518 - (636 + 589)) <= (5141 - 2975)) and (v74 == "Confirmation")) then
				if (v24(v122.HealingRain, not v15:IsInRange(82 - 42), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2044 + 535) < (45 + 78))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) or ((1861 - (657 + 358)) >= (6269 - 3901))) then
			if ((v71 == "Player") or ((9140 - 5128) <= (4545 - (1151 + 36)))) then
				if (((1443 + 51) <= (791 + 2214)) and v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(119 - 79))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v71 == "Friendly under Cursor") or ((4943 - (1552 + 280)) == (2968 - (64 + 770)))) then
				if (((1599 + 756) == (5346 - 2991)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(8 + 32)) or ((1831 - (157 + 1086)) <= (864 - 432))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((21009 - 16212) >= (5974 - 2079)) and (v71 == "Confirmation")) then
				if (((4882 - 1305) == (4396 - (599 + 220))) and v24(v122.EarthenWallTotem, not v15:IsInRange(79 - 39))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((5725 - (1813 + 118)) > (2700 + 993)) and v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) then
			if ((v66 == "Player") or ((2492 - (841 + 376)) == (5745 - 1645))) then
				if (v24(v123.DownpourPlayer, not v15:IsInRange(10 + 30), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4342 - 2751) >= (4439 - (464 + 395)))) then
					return "downpour healingaoe";
				end
			elseif (((2522 - 1539) <= (869 + 939)) and (v66 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((2987 - (467 + 370)) <= (2473 - 1276))) then
					if (((2767 + 1002) >= (4021 - 2848)) and v24(v123.DownpourCursor, not v15:IsInRange(7 + 33), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif (((3454 - 1969) == (2005 - (150 + 370))) and (v66 == "Confirmation")) then
				if (v24(v122.Downpour, not v15:IsInRange(1322 - (74 + 1208)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((8153 - 4838) <= (13193 - 10411))) then
					return "downpour healingaoe";
				end
			end
		end
		if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (8 + 2))) or ((1266 - (14 + 376)) >= (5140 - 2176))) then
			if (v24(v122.CloudburstTotem) or ((1445 + 787) > (2194 + 303))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) or ((2013 + 97) <= (972 - 640))) then
			if (((2773 + 913) > (3250 - (23 + 55))) and v24(v122.Wellspring, not v15:IsInRange(94 - 54), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) or ((2986 + 1488) < (737 + 83))) then
			if (((6633 - 2354) >= (907 + 1975)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) or ((2930 - (652 + 249)) >= (9422 - 5901))) then
			if (v24(v122.SpiritwalkersGrace, nil) or ((3905 - (708 + 1160)) >= (12600 - 7958))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if (((3135 - 1415) < (4485 - (10 + 17))) and v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) then
			if (v24(v122.HealingStreamTotem, nil) or ((98 + 338) > (4753 - (1400 + 332)))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v134()
		if (((1367 - 654) <= (2755 - (242 + 1666))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((922 + 1232) <= (1478 + 2553)) and (v17:HealthPercentage() <= v83)) then
				if (((3934 + 681) == (5555 - (850 + 90))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((6638 - 2848) == (1890 - (360 + 1030)))) then
			if (((79 + 10) < (623 - 402)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (((2825 - 771) >= (3082 - (909 + 752))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1915 - (109 + 1114)) < (5598 - 2540)) and v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) then
			if (v24(v122.EarthShield) or ((1267 + 1987) == (1897 - (6 + 236)))) then
				return "earth_shield player healingst";
			end
		end
		if ((v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) or ((817 + 479) == (3953 + 957))) then
			if (((7942 - 4574) == (5882 - 2514)) and v126.IsSoloMode()) then
				if (((3776 - (1076 + 57)) < (628 + 3187)) and v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) then
					if (((2602 - (579 + 110)) > (39 + 454)) and v24(v122.LightningShield)) then
						return "lightning_shield healingst";
					end
				end
			elseif (((4205 + 550) > (1820 + 1608)) and v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) then
				if (((1788 - (174 + 233)) <= (6617 - 4248)) and v24(v122.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v99 and v122.HealingSurge:IsReady()) or ((8499 - 3656) == (1817 + 2267))) then
			if (((5843 - (663 + 511)) > (324 + 39)) and (v17:HealthPercentage() <= v77)) then
				if (v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((408 + 1469) >= (9674 - 6536))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((2872 + 1870) >= (8536 - 4910)) and v101 and v122.HealingWave:IsReady()) then
			if ((v17:HealthPercentage() <= v80) or ((10990 - 6450) == (438 + 478))) then
				if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2249 - 1093) > (3097 + 1248))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v135()
		if (((205 + 2032) < (4971 - (478 + 244))) and v122.Stormkeeper:IsReady()) then
			if (v24(v122.Stormkeeper, not v15:IsInRange(557 - (440 + 77))) or ((1220 + 1463) < (83 - 60))) then
				return "stormkeeper damage";
			end
		end
		if (((2253 - (655 + 901)) <= (154 + 672)) and (math.max(#v13:GetEnemiesInRange(16 + 4), v13:GetEnemiesInSplashRangeCount(6 + 2)) > (7 - 5))) then
			if (((2550 - (695 + 750)) <= (4015 - 2839)) and v122.ChainLightning:IsReady()) then
				if (((5214 - 1835) <= (15330 - 11518)) and v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "chain_lightning damage";
				end
			end
		end
		if (v122.FlameShock:IsReady() or ((1139 - (285 + 66)) >= (3766 - 2150))) then
			local v162 = 1310 - (682 + 628);
			while true do
				if (((299 + 1555) <= (3678 - (176 + 123))) and (v162 == (0 + 0))) then
					if (((3300 + 1249) == (4818 - (239 + 30))) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(11 + 29), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock)) or ((2905 + 117) >= (5352 - 2328))) then
						return "flame_shock damage";
					end
					break;
				end
			end
		end
		if (((15037 - 10217) > (2513 - (306 + 9))) and v122.LavaBurst:IsReady()) then
			if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3702 - 2641) >= (851 + 4040))) then
				return "lava_burst damage";
			end
		end
		if (((837 + 527) <= (2154 + 2319)) and v122.LightningBolt:IsReady()) then
			if (v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((10280 - 6685) <= (1378 - (1140 + 235)))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v136()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (6 + 0)) or ((1200 + 3472) == (3904 - (33 + 19)))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v145 = 3 + 4;
			end
			if (((4672 - 3113) == (687 + 872)) and (v145 == (3 - 1))) then
				v65 = EpicSettings.Settings['DownpourHP'];
				v66 = EpicSettings.Settings['DownpourUsage'];
				v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v70 = EpicSettings.Settings['EarthenWallTotemHP'];
				v145 = 3 + 0;
			end
			if ((v145 == (690 - (586 + 103))) or ((160 + 1592) <= (2425 - 1637))) then
				v61 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v46 = EpicSettings.Settings['DispelBuffs'];
				v64 = EpicSettings.Settings['DownpourGroup'];
				v145 = 1490 - (1309 + 179);
			end
			if ((v145 == (9 - 4)) or ((1701 + 2206) == (475 - 298))) then
				v77 = EpicSettings.Settings['HealingSurgeHP'];
				v78 = EpicSettings.Settings['HealingTideTotemGroup'];
				v79 = EpicSettings.Settings['HealingTideTotemHP'];
				v80 = EpicSettings.Settings['HealingWaveHP'];
				v145 = 5 + 1;
			end
			if (((7372 - 3902) > (1105 - 550)) and (v145 == (621 - (295 + 314)))) then
				v105 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v145 == (21 - 12)) or ((2934 - (1300 + 662)) == (2025 - 1380))) then
				v94 = EpicSettings.Settings['UseChainHeal'];
				v95 = EpicSettings.Settings['UseCloudburstTotem'];
				v97 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v145 = 1765 - (1178 + 577);
			end
			if (((1653 + 1529) >= (6252 - 4137)) and (v145 == (1412 - (851 + 554)))) then
				v83 = EpicSettings.Settings['RiptideHP'];
				v84 = EpicSettings.Settings['RiptideTankHP'];
				v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v145 = 8 + 0;
			end
			if (((10796 - 6903) < (9618 - 5189)) and (v145 == (313 - (115 + 187)))) then
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v103 = EpicSettings.Settings['UseRiptide'];
				v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v145 = 10 + 2;
			end
			if (((8 + 0) == v145) or ((11297 - 8430) < (3066 - (160 + 1001)))) then
				v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v90 = EpicSettings.Settings['UnleashLifeHP'];
				v145 = 8 + 1;
			end
			if ((v145 == (7 + 3)) or ((3676 - 1880) >= (4409 - (237 + 121)))) then
				v98 = EpicSettings.Settings['UseHealingStreamTotem'];
				v99 = EpicSettings.Settings['UseHealingSurge'];
				v100 = EpicSettings.Settings['UseHealingTideTotem'];
				v101 = EpicSettings.Settings['UseHealingWave'];
				v145 = 908 - (525 + 372);
			end
			if (((3068 - 1449) <= (12340 - 8584)) and (v145 == (146 - (96 + 46)))) then
				v73 = EpicSettings.Settings['HealingRainHP'];
				v74 = EpicSettings.Settings['HealingRainUsage'];
				v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v76 = EpicSettings.Settings['HealingStreamTotemHP'];
				v145 = 782 - (643 + 134);
			end
			if (((219 + 385) == (1448 - 844)) and ((11 - 8) == v145)) then
				v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v72 = EpicSettings.Settings['HealingRainGroup'];
				v145 = 4 + 0;
			end
			if (((0 - 0) == v145) or ((9165 - 4681) == (1619 - (316 + 403)))) then
				v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v60 = EpicSettings.Settings['ChainHealGroup'];
				v145 = 1 + 0;
			end
		end
	end
	local function v137()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (2 + 2)) or ((11229 - 6770) <= (789 + 324))) then
				v111 = EpicSettings.Settings['useTrinkets'];
				v112 = EpicSettings.Settings['fightRemainsCheck'];
				v51 = EpicSettings.Settings['useWeapon'];
				v113 = EpicSettings.Settings['handleAfflicted'];
				v114 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v146 = 2 + 3;
			end
			if (((12584 - 8952) > (16228 - 12830)) and (v146 == (3 - 1))) then
				v92 = EpicSettings.Settings['UseAscendance'];
				v93 = EpicSettings.Settings['UseAstralShift'];
				v96 = EpicSettings.Settings['UseEarthElemental'];
				v102 = EpicSettings.Settings['UseManaTideTotem'];
				v106 = EpicSettings.Settings['UseWellspring'];
				v107 = EpicSettings.Settings['WellspringGroup'];
				v146 = 1 + 2;
			end
			if (((8035 - 3953) <= (241 + 4676)) and (v146 == (8 - 5))) then
				v108 = EpicSettings.Settings['WellspringHP'];
				v117 = EpicSettings.Settings['useManaPotion'];
				v118 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v110 = EpicSettings.Settings['trinketsWithCD'];
				v146 = 21 - (12 + 5);
			end
			if (((18767 - 13935) >= (2956 - 1570)) and (v146 == (0 - 0))) then
				v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v53 = EpicSettings.Settings['AncestralGuidanceHP'];
				v57 = EpicSettings.Settings['AscendanceGroup'];
				v58 = EpicSettings.Settings['AscendanceHP'];
				v59 = EpicSettings.Settings['AstralShiftHP'];
				v62 = EpicSettings.Settings['CloudburstTotemGroup'];
				v146 = 2 - 1;
			end
			if (((28 + 109) == (2110 - (1656 + 317))) and (v146 == (5 + 0))) then
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((1 + 0) == v146) or ((4174 - 2604) >= (21320 - 16988))) then
				v63 = EpicSettings.Settings['CloudburstTotemHP'];
				v67 = EpicSettings.Settings['EarthElementalHP'];
				v68 = EpicSettings.Settings['EarthElementalTankHP'];
				v81 = EpicSettings.Settings['ManaTideTotemMana'];
				v82 = EpicSettings.Settings['PrimordialWaveHP'];
				v91 = EpicSettings.Settings['UseAncestralGuidance'];
				v146 = 356 - (5 + 349);
			end
		end
	end
	local v138 = 0 - 0;
	local function v139()
		v136();
		v137();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		local v152;
		if (v13:IsDeadOrGhost() or ((5335 - (266 + 1005)) <= (1199 + 620))) then
			return;
		end
		if (v126.TargetIsValid() or v13:AffectingCombat() or ((17012 - 12026) < (2071 - 497))) then
			local v163 = 1696 - (561 + 1135);
			while true do
				if (((5767 - 1341) > (565 - 393)) and (v163 == (1066 - (507 + 559)))) then
					v121 = v13:GetEnemiesInRange(100 - 60);
					v119 = v10.BossFightRemains(nil, true);
					v163 = 3 - 2;
				end
				if (((974 - (212 + 176)) > (1360 - (250 + 655))) and (v163 == (2 - 1))) then
					v120 = v119;
					if (((1443 - 617) == (1292 - 466)) and (v120 == (13067 - (1869 + 87)))) then
						v120 = v10.FightRemains(v121, false);
					end
					break;
				end
			end
		end
		if (not v13:AffectingCombat() or ((13939 - 9920) > (6342 - (484 + 1417)))) then
			if (((4323 - 2306) < (7140 - 2879)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v251 = 773 - (48 + 725);
				local v252;
				while true do
					if (((7703 - 2987) > (214 - 134)) and (v251 == (0 + 0))) then
						v252 = v126.DeadFriendlyUnitsCount();
						if ((v252 > (2 - 1)) or ((982 + 2525) == (954 + 2318))) then
							if (v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1729 - (152 + 701)) >= (4386 - (430 + 881)))) then
								return "ancestral_vision";
							end
						elseif (((1667 + 2685) > (3449 - (557 + 338))) and v24(v123.AncestralSpiritMouseover, not v15:IsInRange(12 + 28), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v152 = v131();
		if (v152 or ((12416 - 8010) < (14157 - 10114))) then
			return v152;
		end
		if (v13:AffectingCombat() or v30 or ((5018 - 3129) >= (7290 - 3907))) then
			local v164 = v45 and v122.PurifySpirit:IsReady() and v32;
			if (((2693 - (499 + 302)) <= (3600 - (39 + 827))) and v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 68 - 43) < (2 - 1))) then
				v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 59 - 44, 61 - 21, "TANK", true, 3 + 22, v122.ChainHeal);
				if (((5628 - 3705) < (355 + 1863)) and v29) then
					return v29;
				end
				if (((3438 - 1265) > (483 - (103 + 1))) and (v126.UnitGroupRole(v17) == "TANK")) then
					if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((3145 - (475 + 79)) == (7369 - 3960))) then
						return "earth_shield_tank main apl 1";
					end
				end
			end
			if (((14444 - 9930) > (430 + 2894)) and (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 23 + 2) >= (1504 - (1395 + 108))))) then
				local v253 = 0 - 0;
				while true do
					if ((v253 == (1204 - (7 + 1197))) or ((91 + 117) >= (1685 + 3143))) then
						v29 = v126.FocusUnit(v164, nil, 359 - (27 + 292), nil, 72 - 47, v122.ChainHeal);
						if (v29 or ((2018 - 435) > (14959 - 11392))) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if ((v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(78 - 38) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) or ((2500 - 1187) == (933 - (43 + 96)))) then
			if (((12946 - 9772) > (6560 - 3658)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if (((3419 + 701) <= (1203 + 3057)) and v13:AffectingCombat() and v126.TargetIsValid()) then
			if ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady() or ((1745 - 862) > (1832 + 2946))) then
				if (v24(v123.UseWeapon, nil) or ((6784 - 3164) >= (1540 + 3351))) then
					return "Using Weapon Macro";
				end
			end
			if (((313 + 3945) > (2688 - (1414 + 337))) and v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) then
				if (v24(v123.ManaPotion, nil) or ((6809 - (1642 + 298)) < (2361 - 1455))) then
					return "Mana Potion main";
				end
			end
			v29 = v126.Interrupt(v122.WindShear, 86 - 56, true);
			if (v29 or ((3635 - 2410) > (1392 + 2836))) then
				return v29;
			end
			v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 24 + 6, true, v16);
			if (((4300 - (357 + 615)) > (1571 + 667)) and v29) then
				return v29;
			end
			v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 73 - 43, nil, v16);
			if (((3290 + 549) > (3010 - 1605)) and v29) then
				return v29;
			end
			v152 = v130();
			if (v152 or ((1035 + 258) <= (35 + 472))) then
				return v152;
			end
			if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((1821 + 1075) < (2106 - (384 + 917)))) then
				if (((3013 - (128 + 569)) == (3859 - (1407 + 136))) and v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge))) then
					return "greater_purge utility";
				end
			end
			if ((v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((4457 - (687 + 1200)) == (3243 - (556 + 1154)))) then
				if (v24(v122.Purge, not v15:IsSpellInRange(v122.Purge)) or ((3106 - 2223) == (1555 - (9 + 86)))) then
					return "purge utility";
				end
			end
			if ((v120 > v112) or ((5040 - (275 + 146)) <= (163 + 836))) then
				local v254 = 64 - (29 + 35);
				while true do
					if ((v254 == (0 - 0)) or ((10185 - 6775) > (18170 - 14054))) then
						v152 = v132();
						if (v152 or ((589 + 314) >= (4071 - (53 + 959)))) then
							return v152;
						end
						break;
					end
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((4384 - (312 + 96)) < (4958 - 2101))) then
			local v165 = 285 - (147 + 138);
			while true do
				if (((5829 - (813 + 86)) > (2085 + 222)) and (v165 == (0 - 0))) then
					if ((v32 and v45) or ((4538 - (18 + 474)) < (436 + 855))) then
						local v258 = 0 - 0;
						while true do
							if ((v258 == (1086 - (860 + 226))) or ((4544 - (121 + 182)) == (437 + 3108))) then
								if ((v122.Bursting:MaxDebuffStack() > (1244 - (988 + 252))) or ((458 + 3590) > (1326 + 2906))) then
									v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
									if (v29 or ((3720 - (49 + 1921)) >= (4363 - (223 + 667)))) then
										return v29;
									end
								end
								if (((3218 - (51 + 1)) == (5448 - 2282)) and v17) then
									if (((3775 - 2012) < (4849 - (146 + 979))) and v122.PurifySpirit:IsReady() and v126.UnitHasDispellableDebuffByPlayer(v17)) then
										if (((17 + 40) <= (3328 - (311 + 294))) and (v138 == (0 - 0))) then
											v138 = GetTime();
										end
										if (v126.Wait(212 + 288, v138) or ((3513 - (496 + 947)) == (1801 - (1233 + 125)))) then
											local v261 = 0 + 0;
											while true do
												if ((v261 == (0 + 0)) or ((514 + 2191) == (3038 - (963 + 682)))) then
													if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((3840 + 761) < (1565 - (504 + 1000)))) then
														return "purify_spirit dispel focus";
													end
													v138 = 0 + 0;
													break;
												end
											end
										end
									end
								end
								v258 = 1 + 0;
							end
							if ((v258 == (1 + 0)) or ((2049 - 659) >= (4054 + 690))) then
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((1165 + 838) > (4016 - (156 + 26)))) then
									if (v122.PurifySpirit:IsCastable() or ((90 + 66) > (6121 - 2208))) then
										if (((359 - (149 + 15)) == (1155 - (890 + 70))) and v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
					if (((3222 - (39 + 78)) >= (2278 - (14 + 468))) and (v122.Bursting:AuraActiveCount() > (6 - 3))) then
						if (((12239 - 7860) >= (1100 + 1031)) and (v122.Bursting:MaxDebuffStack() > (4 + 1)) and v122.SpiritLinkTotem:IsReady()) then
							if (((817 + 3027) >= (923 + 1120)) and (v87 == "Player")) then
								if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(11 + 29)) or ((6186 - 2954) <= (2700 + 31))) then
									return "spirit_link_totem bursting";
								end
							elseif (((17236 - 12331) == (124 + 4781)) and (v87 == "Friendly under Cursor")) then
								if ((v16:Exists() and not v13:CanAttack(v16)) or ((4187 - (12 + 39)) >= (4104 + 307))) then
									if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(123 - 83)) or ((10534 - 7576) == (1191 + 2826))) then
										return "spirit_link_totem bursting";
									end
								end
							elseif (((647 + 581) >= (2061 - 1248)) and (v87 == "Confirmation")) then
								if (v24(v122.SpiritLinkTotem, not v15:IsInRange(27 + 13)) or ((16697 - 13242) > (5760 - (1596 + 114)))) then
									return "spirit_link_totem bursting";
								end
							end
						end
						if (((633 - 390) == (956 - (164 + 549))) and v94 and v122.ChainHeal:IsReady()) then
							if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal)) or ((1709 - (1059 + 379)) > (1951 - 379))) then
								return "Chain Heal Spam because of Bursting";
							end
						end
					end
					v165 = 1 + 0;
				end
				if (((462 + 2277) < (3685 - (145 + 247))) and (v165 == (2 + 0))) then
					if ((v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) or ((1822 + 2120) < (3361 - 2227))) then
						if (v24(v122.NaturesSwiftness, nil) or ((517 + 2176) == (4284 + 689))) then
							return "natures_swiftness main";
						end
					end
					if (((3483 - 1337) == (2866 - (254 + 466))) and v33) then
						if ((v15:Exists() and not v13:CanAttack(v15)) or ((2804 - (544 + 16)) == (10245 - 7021))) then
							local v259 = 628 - (294 + 334);
							while true do
								if ((v259 == (253 - (236 + 17))) or ((2115 + 2789) <= (1492 + 424))) then
									if (((338 - 248) <= (5042 - 3977)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
										if (((2473 + 2329) == (3955 + 847)) and (v15:HealthPercentage() <= v83)) then
											if (v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide)) or ((3074 - (413 + 381)) <= (22 + 489))) then
												return "riptide healing target";
											end
										end
									end
									if ((v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) or ((3564 - 1888) <= (1202 - 739))) then
										if (((5839 - (582 + 1388)) == (6591 - 2722)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
											return "unleash_life healing target";
										end
									end
									v259 = 1 + 0;
								end
								if (((1522 - (326 + 38)) <= (7729 - 5116)) and (v259 == (1 - 0))) then
									if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((2984 - (47 + 573)) <= (705 + 1294))) then
										if (v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((20904 - 15982) < (314 - 120))) then
											return "chain_heal healing target";
										end
									end
									if ((v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) or ((3755 - (1269 + 395)) < (523 - (76 + 416)))) then
										if (v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2873 - (319 + 124)) >= (11136 - 6264))) then
											return "healing_wave healing target";
										end
									end
									break;
								end
							end
						end
						v152 = v133();
						if (v152 or ((5777 - (564 + 443)) < (4802 - 3067))) then
							return v152;
						end
						v152 = v134();
						if (v152 or ((4897 - (337 + 121)) <= (6885 - 4535))) then
							return v152;
						end
					end
					v165 = 9 - 6;
				end
				if (((1914 - (1261 + 650)) == v165) or ((1895 + 2584) < (7116 - 2650))) then
					if (((4364 - (772 + 1045)) > (173 + 1052)) and v34) then
						if (((4815 - (102 + 42)) > (4518 - (1524 + 320))) and v126.TargetIsValid()) then
							local v260 = 1270 - (1049 + 221);
							while true do
								if ((v260 == (156 - (18 + 138))) or ((9046 - 5350) < (4429 - (67 + 1035)))) then
									v152 = v135();
									if (v152 or ((4890 - (136 + 212)) == (12620 - 9650))) then
										return v152;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if (((202 + 50) <= (1823 + 154)) and ((1605 - (240 + 1364)) == v165)) then
					if (((v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) or ((2518 - (1050 + 32)) == (13478 - 9703))) then
						if (v122.PrimordialWaveResto:IsCastable() or ((958 + 660) < (1985 - (331 + 724)))) then
							if (((382 + 4341) > (4797 - (269 + 375))) and v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (728 - (267 + 458))))) or ((1137 + 2517) >= (8949 - 4295))) then
						if (((1769 - (667 + 151)) <= (2993 - (1410 + 87))) and v24(v122.TotemicRecall, nil)) then
							return "totemic_recall main";
						end
					end
					v165 = 1899 - (1504 + 393);
				end
			end
		end
	end
	local function v140()
		local v153 = 0 - 0;
		while true do
			if (((0 - 0) == v153) or ((2532 - (461 + 335)) == (73 + 498))) then
				v128();
				v122.Bursting:RegisterAuraTracking();
				v153 = 1762 - (1730 + 31);
			end
			if (((1668 - (728 + 939)) == v153) or ((3173 - 2277) > (9673 - 4904))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(604 - 340, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

