local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((601 - 403) <= (16155 - 11790)) and not v5) then
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
	local v114;
	local v115;
	local v116;
	local v117;
	local v118 = 29728 - 18617;
	local v119 = 11651 - (133 + 407);
	local v120;
	v9:RegisterForEvent(function()
		local v140 = 0 - 0;
		while true do
			if (((6963 - 2181) > (1220 + 3456)) and (v140 == (0 - 0))) then
				v118 = 5353 + 5758;
				v119 = 11907 - (588 + 208);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v17.Shaman.Restoration;
	local v122 = v24.Shaman.Restoration;
	local v123 = v19.Shaman.Restoration;
	local v124 = {};
	local v125 = v21.Commons.Everyone;
	local v126 = v21.Commons.Shaman;
	local function v127()
		if (((13109 - 8245) > (3997 - (884 + 916))) and v121.ImprovedPurifySpirit:IsAvailable()) then
			v125.DispellableDebuffs = v20.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (10 - 5));
	end
	local function v129()
		if ((v92 and v121.AstralShift:IsReady()) or ((2146 + 1554) == (3160 - (232 + 421)))) then
			if (((6363 - (1569 + 320)) >= (68 + 206)) and (v12:HealthPercentage() <= v58)) then
				if (v23(v121.AstralShift, not v14:IsInRange(8 + 32)) or ((6382 - 4488) <= (2011 - (316 + 289)))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((4114 - 2542) >= (71 + 1460)) and v95 and v121.EarthElemental:IsReady()) then
			if ((v12:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67) or ((6140 - (666 + 787)) < (4967 - (360 + 65)))) then
				if (((3076 + 215) > (1921 - (79 + 175))) and v23(v121.EarthElemental, not v14:IsInRange(63 - 23))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v123.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((682 + 191) == (6234 - 4200))) then
			if (v23(v122.Healthstone) or ((5422 - 2606) < (910 - (503 + 396)))) then
				return "healthstone defensive 3";
			end
		end
		if (((3880 - (92 + 89)) < (9128 - 4422)) and v37 and (v12:HealthPercentage() <= v38)) then
			local v153 = 0 + 0;
			while true do
				if (((1567 + 1079) >= (3430 - 2554)) and (v153 == (0 + 0))) then
					if (((1399 - 785) <= (2779 + 405)) and (v39 == "Refreshing Healing Potion")) then
						if (((1494 + 1632) == (9520 - 6394)) and v123.RefreshingHealingPotion:IsReady()) then
							if (v23(v122.RefreshingHealingPotion) or ((273 + 1914) >= (7554 - 2600))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((5121 - (485 + 759)) == (8272 - 4697))) then
						if (((1896 - (442 + 747)) > (1767 - (832 + 303))) and v123.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v122.RefreshingHealingPotion) or ((1492 - (88 + 858)) >= (819 + 1865))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v130()
		local v142 = 0 + 0;
		while true do
			if (((61 + 1404) <= (5090 - (766 + 23))) and (v142 == (4 - 3))) then
				if (((2330 - 626) > (3754 - 2329)) and v40) then
					v28 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 135 - 95);
					if (v28 or ((1760 - (1036 + 37)) == (3002 + 1232))) then
						return v28;
					end
					v28 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 77 - 37);
					if (v28 or ((2620 + 710) < (2909 - (641 + 839)))) then
						return v28;
					end
				end
				if (((2060 - (910 + 3)) >= (854 - 519)) and v41) then
					local v244 = 1684 - (1466 + 218);
					while true do
						if (((1579 + 1856) > (3245 - (556 + 592))) and (v244 == (2 + 1))) then
							v28 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 848 - (329 + 479));
							if (v28 or ((4624 - (174 + 680)) >= (13885 - 9844))) then
								return v28;
							end
							break;
						end
						if ((v244 == (1 - 0)) or ((2707 + 1084) <= (2350 - (396 + 343)))) then
							v28 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 4 + 36);
							if (v28 or ((6055 - (29 + 1448)) <= (3397 - (135 + 1254)))) then
								return v28;
							end
							v244 = 7 - 5;
						end
						if (((5252 - 4127) <= (1384 + 692)) and (v244 == (1529 - (389 + 1138)))) then
							v28 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 614 - (102 + 472));
							if (v28 or ((702 + 41) >= (2440 + 1959))) then
								return v28;
							end
							v244 = 3 + 0;
						end
						if (((2700 - (320 + 1225)) < (2978 - 1305)) and (v244 == (0 + 0))) then
							v28 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 1504 - (157 + 1307));
							if (v28 or ((4183 - (821 + 1038)) <= (1442 - 864))) then
								return v28;
							end
							v244 = 1 + 0;
						end
					end
				end
				v142 = 3 - 1;
			end
			if (((1402 + 2365) == (9336 - 5569)) and ((1028 - (834 + 192)) == v142)) then
				if (((260 + 3829) == (1050 + 3039)) and v42) then
					local v245 = 0 + 0;
					while true do
						if (((6906 - 2448) >= (1978 - (300 + 4))) and (v245 == (1 + 2))) then
							v28 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 104 - 64);
							if (((1334 - (112 + 250)) <= (566 + 852)) and v28) then
								return v28;
							end
							break;
						end
						if (((2 - 1) == v245) or ((2829 + 2109) < (2463 + 2299))) then
							v28 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 30 + 10);
							if (v28 or ((1242 + 1262) > (3168 + 1096))) then
								return v28;
							end
							v245 = 1416 - (1001 + 413);
						end
						if (((4800 - 2647) == (3035 - (244 + 638))) and (v245 == (693 - (627 + 66)))) then
							v28 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 119 - 79);
							if (v28 or ((1109 - (512 + 90)) >= (4497 - (1665 + 241)))) then
								return v28;
							end
							v245 = 718 - (373 + 344);
						end
						if (((2022 + 2459) == (1186 + 3295)) and (v245 == (5 - 3))) then
							v28 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 67 - 27);
							if (v28 or ((3427 - (35 + 1064)) < (505 + 188))) then
								return v28;
							end
							v245 = 6 - 3;
						end
					end
				end
				if (((18 + 4310) == (5564 - (298 + 938))) and v43) then
					v28 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 1299 - (233 + 1026));
					if (((3254 - (636 + 1030)) >= (682 + 650)) and v28) then
						return v28;
					end
					v28 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 40 + 0);
					if (v28 or ((1240 + 2934) > (288 + 3960))) then
						return v28;
					end
					v28 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 261 - (55 + 166));
					if (v28 or ((889 + 3697) <= (9 + 73))) then
						return v28;
					end
					v28 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 152 - 112);
					if (((4160 - (36 + 261)) == (6755 - 2892)) and v28) then
						return v28;
					end
				end
				break;
			end
			if ((v142 == (1368 - (34 + 1334))) or ((109 + 173) <= (33 + 9))) then
				if (((5892 - (1035 + 248)) >= (787 - (20 + 1))) and v113) then
					v28 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 16 + 14, true);
					if (v28 or ((1471 - (134 + 185)) == (3621 - (549 + 584)))) then
						return v28;
					end
				end
				if (((4107 - (314 + 371)) > (11500 - 8150)) and v112) then
					v28 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 998 - (478 + 490));
					if (((465 + 412) > (1548 - (786 + 386))) and v28) then
						return v28;
					end
					if (v114 or ((10099 - 6981) <= (3230 - (1055 + 324)))) then
						v28 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 1370 - (1093 + 247));
						if (v28 or ((147 + 18) >= (368 + 3124))) then
							return v28;
						end
					end
					if (((15678 - 11729) < (16479 - 11623)) and v115) then
						local v250 = 0 - 0;
						while true do
							if ((v250 == (0 - 0)) or ((1522 + 2754) < (11618 - 8602))) then
								v28 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 103 - 73);
								if (((3537 + 1153) > (10549 - 6424)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v142 = 689 - (364 + 324);
			end
		end
	end
	local function v131()
		local v143 = 0 - 0;
		while true do
			if (((0 - 0) == v143) or ((17 + 33) >= (3748 - 2852))) then
				if ((v110 and ((v30 and v109) or not v109)) or ((2744 - 1030) >= (8983 - 6025))) then
					v28 = v125.HandleTopTrinket(v124, v30, 1308 - (1249 + 19), nil);
					if (v28 or ((1346 + 145) < (2506 - 1862))) then
						return v28;
					end
					v28 = v125.HandleBottomTrinket(v124, v30, 1126 - (686 + 400), nil);
					if (((553 + 151) < (1216 - (73 + 156))) and v28) then
						return v28;
					end
				end
				if (((18 + 3700) > (2717 - (721 + 90))) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((11 + 947) > (11802 - 8167))) then
						if (((3971 - (224 + 246)) <= (7276 - 2784)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingcd tank";
						end
					end
				end
				v143 = 1 - 0;
			end
			if ((v143 == (1 + 0)) or ((82 + 3360) < (1872 + 676))) then
				if (((5715 - 2840) >= (4871 - 3407)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if ((v16:HealthPercentage() <= v82) or ((5310 - (203 + 310)) >= (6886 - (1238 + 755)))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((39 + 512) > (3602 - (709 + 825)))) then
							return "riptide healingcd";
						end
					end
				end
				if (((3895 - 1781) > (1374 - 430)) and v125.AreUnitsBelowHealthPercentage(v85, v84) and v121.SpiritLinkTotem:IsReady()) then
					if ((v86 == "Player") or ((3126 - (196 + 668)) >= (12223 - 9127))) then
						if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(82 - 42)) or ((3088 - (171 + 662)) >= (3630 - (4 + 89)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v86 == "Friendly under Cursor") or ((13448 - 9611) < (476 + 830))) then
						if (((12957 - 10007) == (1157 + 1793)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(1526 - (35 + 1451))) or ((6176 - (28 + 1425)) < (5291 - (941 + 1052)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((1090 + 46) >= (1668 - (822 + 692))) and (v86 == "Confirmation")) then
						if (v23(v121.SpiritLinkTotem, not v14:IsInRange(57 - 17)) or ((128 + 143) > (5045 - (45 + 252)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v143 = 2 + 0;
			end
			if (((1632 + 3108) >= (7670 - 4518)) and (v143 == (436 - (114 + 319)))) then
				if ((v90 and v125.AreUnitsBelowHealthPercentage(v52, v51) and v121.AncestralGuidance:IsReady()) or ((3701 - 1123) >= (4343 - 953))) then
					if (((27 + 14) <= (2474 - 813)) and v23(v121.AncestralGuidance, not v14:IsInRange(83 - 43))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((2564 - (556 + 1407)) < (4766 - (741 + 465))) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56) and v121.Ascendance:IsReady()) then
					if (((700 - (170 + 295)) < (362 + 325)) and v23(v121.Ascendance, not v14:IsInRange(37 + 3))) then
						return "ascendance cooldowns";
					end
				end
				v143 = 9 - 5;
			end
			if (((3771 + 778) > (740 + 413)) and ((2 + 0) == v143)) then
				if ((v99 and v125.AreUnitsBelowHealthPercentage(v78, v77) and v121.HealingTideTotem:IsReady()) or ((5904 - (957 + 273)) < (1250 + 3422))) then
					if (((1469 + 2199) < (17379 - 12818)) and v23(v121.HealingTideTotem, not v14:IsInRange(105 - 65))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v54, v53) and v121.AncestralProtectionTotem:IsReady()) or ((1389 - 934) == (17850 - 14245))) then
					if ((v55 == "Player") or ((4443 - (389 + 1391)) == (2078 + 1234))) then
						if (((446 + 3831) <= (10187 - 5712)) and v23(v122.AncestralProtectionTotemPlayer, not v14:IsInRange(991 - (783 + 168)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v55 == "Friendly under Cursor") or ((2919 - 2049) == (1170 + 19))) then
						if (((1864 - (309 + 2)) <= (9621 - 6488)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v122.AncestralProtectionTotemCursor, not v14:IsInRange(1252 - (1090 + 122))) or ((726 + 1511) >= (11791 - 8280))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v55 == "Confirmation") or ((907 + 417) > (4138 - (628 + 490)))) then
						if (v23(v121.AncestralProtectionTotem, not v14:IsInRange(8 + 32)) or ((7407 - 4415) == (8596 - 6715))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v143 = 777 - (431 + 343);
			end
			if (((6272 - 3166) > (4414 - 2888)) and (v143 == (4 + 0))) then
				if (((387 + 2636) < (5565 - (556 + 1139))) and v101 and (v12:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) then
					if (((158 - (6 + 9)) > (14 + 60)) and v23(v121.ManaTideTotem, not v14:IsInRange(21 + 19))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((187 - (28 + 141)) < (819 + 1293)) and v34 and ((v108 and v30) or not v108)) then
					if (((1353 - 256) <= (1154 + 474)) and v121.AncestralCall:IsReady()) then
						if (((5947 - (486 + 831)) == (12048 - 7418)) and v23(v121.AncestralCall, not v14:IsInRange(140 - 100))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((669 + 2871) > (8483 - 5800)) and v121.BagofTricks:IsReady()) then
						if (((6057 - (668 + 595)) >= (2947 + 328)) and v23(v121.BagofTricks, not v14:IsInRange(9 + 31))) then
							return "BagofTricks cooldowns";
						end
					end
					if (((4046 - 2562) == (1774 - (23 + 267))) and v121.Berserking:IsReady()) then
						if (((3376 - (1129 + 815)) < (3942 - (371 + 16))) and v23(v121.Berserking, not v14:IsInRange(1790 - (1326 + 424)))) then
							return "Berserking cooldowns";
						end
					end
					if (v121.BloodFury:IsReady() or ((2016 - 951) > (13074 - 9496))) then
						if (v23(v121.BloodFury, not v14:IsInRange(158 - (88 + 30))) or ((5566 - (720 + 51)) < (3129 - 1722))) then
							return "BloodFury cooldowns";
						end
					end
					if (((3629 - (421 + 1355)) < (7940 - 3127)) and v121.Fireblood:IsReady()) then
						if (v23(v121.Fireblood, not v14:IsInRange(20 + 20)) or ((3904 - (286 + 797)) < (8886 - 6455))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (440 - (397 + 42))) or ((898 + 1976) < (2981 - (24 + 776)))) then
				if ((v104 and v121.UnleashLife:IsReady()) or ((4142 - 1453) <= (1128 - (222 + 563)))) then
					if ((v12:HealthPercentage() <= v89) or ((4117 - 2248) == (1447 + 562))) then
						if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((3736 - (23 + 167)) < (4120 - (690 + 1108)))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71)) or ((752 + 1330) == (3937 + 836))) then
					if (((4092 - (40 + 808)) > (174 + 881)) and v23(v122.HealingRainCursor, not v14:IsInRange(152 - 112), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v72, v71) and v121.HealingRain:IsReady()) or ((3167 + 146) <= (941 + 837))) then
					if ((v73 == "Player") or ((780 + 641) >= (2675 - (47 + 524)))) then
						if (((1176 + 636) <= (8881 - 5632)) and v23(v122.HealingRainPlayer, not v14:IsInRange(59 - 19), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((3701 - 2078) <= (3683 - (1165 + 561))) and (v73 == "Friendly under Cursor")) then
						if (((132 + 4280) == (13664 - 9252)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((668 + 1082) >= (1321 - (341 + 138))) and v23(v122.HealingRainCursor, not v14:IsInRange(11 + 29), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((9022 - 4650) > (2176 - (89 + 237))) and (v73 == "Enemy under Cursor")) then
						if (((746 - 514) < (1728 - 907)) and v15:Exists() and v12:CanAttack(v15)) then
							if (((1399 - (581 + 300)) < (2122 - (855 + 365))) and v23(v122.HealingRainCursor, not v14:IsInRange(95 - 55), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((978 + 2016) > (2093 - (1030 + 205))) and (v73 == "Confirmation")) then
						if (v23(v121.HealingRain, not v14:IsInRange(38 + 2), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3494 + 261) <= (1201 - (156 + 130)))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((8966 - 5020) > (6308 - 2565)) and v125.AreUnitsBelowHealthPercentage(v69, v68) and v121.EarthenWallTotem:IsReady()) then
					if ((v70 == "Player") or ((2734 - 1399) >= (872 + 2434))) then
						if (((2825 + 2019) > (2322 - (10 + 59))) and v23(v122.EarthenWallTotemPlayer, not v14:IsInRange(12 + 28))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((2225 - 1773) == (1615 - (671 + 492))) and (v70 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((3628 + 929) < (3302 - (369 + 846)))) then
							if (((1026 + 2848) == (3307 + 567)) and v23(v122.EarthenWallTotemCursor, not v14:IsInRange(1985 - (1036 + 909)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((1541 + 397) > (8285 - 3350))) then
						if (v23(v121.EarthenWallTotem, not v14:IsInRange(243 - (11 + 192))) or ((2151 + 2104) < (3598 - (135 + 40)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v144 = 4 - 2;
			end
			if (((877 + 577) <= (5487 - 2996)) and (v144 == (2 - 0))) then
				if ((v125.AreUnitsBelowHealthPercentage(v64, v63) and v121.Downpour:IsReady()) or ((4333 - (50 + 126)) <= (7804 - 5001))) then
					if (((1075 + 3778) >= (4395 - (1233 + 180))) and (v65 == "Player")) then
						if (((5103 - (522 + 447)) > (4778 - (107 + 1314))) and v23(v122.DownpourPlayer, not v14:IsInRange(19 + 21), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v65 == "Friendly under Cursor") or ((10411 - 6994) < (1077 + 1457))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((5404 - 2682) <= (648 - 484))) then
							if (v23(v122.DownpourCursor, not v14:IsInRange(1950 - (716 + 1194)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((42 + 2366) < (226 + 1883))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v65 == "Confirmation") or ((536 - (74 + 429)) == (2806 - 1351))) then
						if (v23(v121.Downpour, not v14:IsInRange(20 + 20), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1013 - 570) >= (2841 + 1174))) then
							return "downpour healingaoe";
						end
					end
				end
				if (((10426 - 7044) > (410 - 244)) and v94 and v125.AreUnitsBelowHealthPercentage(v62, v61) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (443 - (279 + 154)))) then
					if (v23(v121.CloudburstTotem) or ((1058 - (454 + 324)) == (2407 + 652))) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((1898 - (12 + 5)) > (698 + 595)) and v105 and v125.AreUnitsBelowHealthPercentage(v107, v106) and v121.Wellspring:IsReady()) then
					if (((6005 - 3648) == (871 + 1486)) and v23(v121.Wellspring, not v14:IsInRange(1133 - (277 + 816)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if (((525 - 402) == (1306 - (1058 + 125))) and v93 and v125.AreUnitsBelowHealthPercentage(v60, v59) and v121.ChainHeal:IsReady()) then
					if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((198 + 858) >= (4367 - (815 + 160)))) then
						return "chain_heal healingaoe";
					end
				end
				v144 = 12 - 9;
			end
			if ((v144 == (7 - 4)) or ((258 + 823) < (3142 - 2067))) then
				if ((v103 and v12:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87) and v121.SpiritwalkersGrace:IsReady()) or ((2947 - (41 + 1857)) >= (6325 - (1222 + 671)))) then
					if (v23(v121.SpiritwalkersGrace, nil) or ((12323 - 7555) <= (1215 - 369))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74) and v121.HealingStreamTotem:IsReady()) or ((4540 - (229 + 953)) <= (3194 - (1111 + 663)))) then
					if (v23(v121.HealingStreamTotem, nil) or ((5318 - (874 + 705)) <= (421 + 2584))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v144 == (0 + 0)) or ((3447 - 1788) >= (61 + 2073))) then
				if ((v93 and v125.AreUnitsBelowHealthPercentage(774 - (642 + 37), 1 + 2) and v121.ChainHeal:IsReady() and v12:BuffUp(v121.HighTide)) or ((522 + 2738) < (5912 - 3557))) then
					if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1123 - (233 + 221)) == (9765 - 5542))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v100 and (v16:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (14 + 1))) or ((3233 - (718 + 823)) < (371 + 217))) then
					if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5602 - (266 + 539)) < (10336 - 6685))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((5402 - (636 + 589)) > (11512 - 6662))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((825 - 425) > (881 + 230))) then
						if (((1109 + 1942) > (2020 - (657 + 358))) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if (((9778 - 6085) <= (9983 - 5601)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if ((v16:HealthPercentage() <= v82) or ((4469 - (1151 + 36)) > (3960 + 140))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((942 + 2638) < (8493 - 5649))) then
							return "riptide healingaoe";
						end
					end
				end
				v144 = 1833 - (1552 + 280);
			end
		end
	end
	local function v133()
		local v145 = 834 - (64 + 770);
		while true do
			if (((61 + 28) < (10192 - 5702)) and (v145 == (1 + 1))) then
				if ((v98 and v121.HealingSurge:IsReady()) or ((6226 - (157 + 1086)) < (3618 - 1810))) then
					if (((16769 - 12940) > (5780 - 2011)) and (v16:HealthPercentage() <= v76)) then
						if (((2026 - 541) <= (3723 - (599 + 220))) and v23(v122.HealingSurgeFocus, not v16:IsSpellInRange(v121.HealingSurge), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				if (((8500 - 4231) == (6200 - (1813 + 118))) and v100 and v121.HealingWave:IsReady()) then
					if (((283 + 104) <= (3999 - (841 + 376))) and (v16:HealthPercentage() <= v79)) then
						if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2660 - 761) <= (214 + 703))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v145 == (2 - 1)) or ((5171 - (464 + 395)) <= (2248 - 1372))) then
				if (((1072 + 1160) <= (3433 - (467 + 370))) and v121.ElementalOrbit:IsAvailable() and v12:BuffDown(v121.EarthShieldBuff) and not v14:IsAPlayer() and v121.EarthShield:IsCastable() and v96) then
					local v246 = 0 - 0;
					while true do
						if (((1538 + 557) < (12635 - 8949)) and (v246 == (0 + 0))) then
							v28 = v125.FocusSpecifiedUnit(v125.NamedUnit(93 - 53, v12:Name(), 545 - (150 + 370)), 1312 - (74 + 1208));
							if (v28 or ((3923 - 2328) >= (21218 - 16744))) then
								return v28;
							end
							v246 = 1 + 0;
						end
						if (((391 - (14 + 376)) == v246) or ((8011 - 3392) < (1865 + 1017))) then
							if (v23(v122.EarthShieldFocus) or ((259 + 35) >= (4608 + 223))) then
								return "earth_shield player healingst";
							end
							break;
						end
					end
				end
				if (((5945 - 3916) <= (2321 + 763)) and v121.ElementalOrbit:IsAvailable() and v12:BuffUp(v121.EarthShieldBuff)) then
					if (v125.IsSoloMode() or ((2115 - (23 + 55)) == (5735 - 3315))) then
						if (((2975 + 1483) > (3506 + 398)) and v121.LightningShield:IsReady() and v12:BuffDown(v121.LightningShield)) then
							if (((675 - 239) >= (39 + 84)) and v23(v121.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif (((1401 - (652 + 249)) < (4859 - 3043)) and v121.WaterShield:IsReady() and v12:BuffDown(v121.WaterShield)) then
						if (((5442 - (708 + 1160)) == (9701 - 6127)) and v23(v121.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v145 = 3 - 1;
			end
			if (((248 - (10 + 17)) < (88 + 302)) and (v145 == (1732 - (1400 + 332)))) then
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((4244 - 2031) <= (3329 - (242 + 1666)))) then
					if (((1309 + 1749) < (1782 + 3078)) and (v16:HealthPercentage() <= v82)) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((1105 + 191) >= (5386 - (850 + 90)))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2439 - 1046) > (5879 - (360 + 1030)))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((3916 + 508) < (76 - 49))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((2747 - 750) > (5476 - (909 + 752)))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 1224 - (109 + 1114);
			end
		end
	end
	local function v134()
		if (((6343 - 2878) > (745 + 1168)) and v121.Stormkeeper:IsReady()) then
			if (((975 - (6 + 236)) < (1147 + 672)) and v23(v121.Stormkeeper, not v14:IsInRange(33 + 7))) then
				return "stormkeeper damage";
			end
		end
		if ((math.max(#v12:GetEnemiesInRange(47 - 27), v12:GetEnemiesInSplashRangeCount(13 - 5)) > (1135 - (1076 + 57))) or ((723 + 3672) == (5444 - (579 + 110)))) then
			if (v121.ChainLightning:IsReady() or ((300 + 3493) < (2095 + 274))) then
				if (v23(v121.ChainLightning, not v14:IsSpellInRange(v121.ChainLightning), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2168 + 1916) == (672 - (174 + 233)))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((12173 - 7815) == (7648 - 3290)) and v121.FlameShock:IsReady()) then
			local v154 = 0 + 0;
			while true do
				if ((v154 == (1174 - (663 + 511))) or ((2800 + 338) < (216 + 777))) then
					if (((10266 - 6936) > (1407 + 916)) and v125.CastCycle(v121.FlameShock, v12:GetEnemiesInRange(94 - 54), v128, not v14:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (v23(v121.FlameShock, not v14:IsSpellInRange(v121.FlameShock)) or ((8777 - 5151) == (1904 + 2085))) then
						return "flame_shock damage";
					end
					break;
				end
			end
		end
		if (v121.LavaBurst:IsReady() or ((1782 - 866) == (1904 + 767))) then
			if (((25 + 247) == (994 - (478 + 244))) and v23(v121.LavaBurst, not v14:IsSpellInRange(v121.LavaBurst), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "lava_burst damage";
			end
		end
		if (((4766 - (440 + 77)) <= (2201 + 2638)) and v121.LightningBolt:IsReady()) then
			if (((10163 - 7386) < (4756 - (655 + 901))) and v23(v121.LightningBolt, not v14:IsSpellInRange(v121.LightningBolt), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v135()
		local v146 = 0 + 0;
		while true do
			if (((73 + 22) < (1322 + 635)) and (v146 == (44 - 33))) then
				v35 = EpicSettings.Settings['useHealthstone'];
				v46 = EpicSettings.Settings['UsePurgeTarget'];
				v102 = EpicSettings.Settings['UseRiptide'];
				v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v146 = 1457 - (695 + 750);
			end
			if (((2820 - 1994) < (2649 - 932)) and ((32 - 24) == v146)) then
				v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v89 = EpicSettings.Settings['UnleashLifeHP'];
				v146 = 360 - (285 + 66);
			end
			if (((3323 - 1897) >= (2415 - (682 + 628))) and (v146 == (1 + 2))) then
				v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v38 = EpicSettings.Settings['healingPotionHP'];
				v39 = EpicSettings.Settings['HealingPotionName'];
				v71 = EpicSettings.Settings['HealingRainGroup'];
				v146 = 303 - (176 + 123);
			end
			if (((1152 + 1602) <= (2452 + 927)) and ((275 - (239 + 30)) == v146)) then
				v36 = EpicSettings.Settings['healthstoneHP'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v146 = 2 + 5;
			end
			if ((v146 == (12 + 0)) or ((6950 - 3023) == (4407 - 2994))) then
				v104 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v146 == (315 - (306 + 9))) or ((4026 - 2872) <= (138 + 650))) then
				v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v59 = EpicSettings.Settings['ChainHealGroup'];
				v146 = 1 + 0;
			end
			if ((v146 == (2 + 2)) or ((4698 - 3055) > (4754 - (1140 + 235)))) then
				v72 = EpicSettings.Settings['HealingRainHP'];
				v73 = EpicSettings.Settings['HealingRainUsage'];
				v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v75 = EpicSettings.Settings['HealingStreamTotemHP'];
				v146 = 4 + 1;
			end
			if ((v146 == (1 + 0)) or ((720 + 2083) > (4601 - (33 + 19)))) then
				v60 = EpicSettings.Settings['ChainHealHP'];
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v63 = EpicSettings.Settings['DownpourGroup'];
				v146 = 1 + 1;
			end
			if ((v146 == (5 - 3)) or ((97 + 123) >= (5926 - 2904))) then
				v64 = EpicSettings.Settings['DownpourHP'];
				v65 = EpicSettings.Settings['DownpourUsage'];
				v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v69 = EpicSettings.Settings['EarthenWallTotemHP'];
				v146 = 3 + 0;
			end
			if (((3511 - (586 + 103)) == (257 + 2565)) and (v146 == (15 - 10))) then
				v76 = EpicSettings.Settings['HealingSurgeHP'];
				v77 = EpicSettings.Settings['HealingTideTotemGroup'];
				v78 = EpicSettings.Settings['HealingTideTotemHP'];
				v79 = EpicSettings.Settings['HealingWaveHP'];
				v146 = 1494 - (1309 + 179);
			end
			if ((v146 == (18 - 8)) or ((462 + 599) == (4987 - 3130))) then
				v97 = EpicSettings.Settings['UseHealingStreamTotem'];
				v98 = EpicSettings.Settings['UseHealingSurge'];
				v99 = EpicSettings.Settings['UseHealingTideTotem'];
				v100 = EpicSettings.Settings['UseHealingWave'];
				v146 = 9 + 2;
			end
			if (((5864 - 3104) > (2717 - 1353)) and ((618 - (295 + 314)) == v146)) then
				v93 = EpicSettings.Settings['UseChainHeal'];
				v94 = EpicSettings.Settings['UseCloudburstTotem'];
				v96 = EpicSettings.Settings['UseEarthShield'];
				v37 = EpicSettings.Settings['useHealingPotion'];
				v146 = 24 - 14;
			end
			if (((1969 - (1300 + 662)) == v146) or ((15392 - 10490) <= (5350 - (1178 + 577)))) then
				v82 = EpicSettings.Settings['RiptideHP'];
				v83 = EpicSettings.Settings['RiptideTankHP'];
				v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v146 = 5 + 3;
			end
		end
	end
	local function v136()
		local v147 = 0 - 0;
		while true do
			if ((v147 == (1410 - (851 + 554))) or ((3407 + 445) == (812 - 519))) then
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v43 = EpicSettings.Settings['HandleFyrakkNPC'];
				v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v147 == (3 - 1)) or ((1861 - (115 + 187)) == (3514 + 1074))) then
				v91 = EpicSettings.Settings['UseAscendance'];
				v92 = EpicSettings.Settings['UseAstralShift'];
				v95 = EpicSettings.Settings['UseEarthElemental'];
				v101 = EpicSettings.Settings['UseManaTideTotem'];
				v105 = EpicSettings.Settings['UseWellspring'];
				v106 = EpicSettings.Settings['WellspringGroup'];
				v147 = 3 + 0;
			end
			if ((v147 == (15 - 11)) or ((5645 - (160 + 1001)) == (690 + 98))) then
				v110 = EpicSettings.Settings['useTrinkets'];
				v111 = EpicSettings.Settings['fightRemainsCheck'];
				v50 = EpicSettings.Settings['useWeapon'];
				v112 = EpicSettings.Settings['handleAfflicted'];
				v113 = EpicSettings.Settings['HandleIncorporeal'];
				v40 = EpicSettings.Settings['HandleChromie'];
				v147 = 4 + 1;
			end
			if (((9351 - 4783) >= (4265 - (237 + 121))) and ((898 - (525 + 372)) == v147)) then
				v62 = EpicSettings.Settings['CloudburstTotemHP'];
				v66 = EpicSettings.Settings['EarthElementalHP'];
				v67 = EpicSettings.Settings['EarthElementalTankHP'];
				v80 = EpicSettings.Settings['ManaTideTotemMana'];
				v81 = EpicSettings.Settings['PrimordialWaveHP'];
				v90 = EpicSettings.Settings['UseAncestralGuidance'];
				v147 = 3 - 1;
			end
			if (((4093 - 2847) < (3612 - (96 + 46))) and (v147 == (780 - (643 + 134)))) then
				v107 = EpicSettings.Settings['WellspringHP'];
				v116 = EpicSettings.Settings['useManaPotion'];
				v117 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['racialsWithCD'];
				v34 = EpicSettings.Settings['useRacials'];
				v109 = EpicSettings.Settings['trinketsWithCD'];
				v147 = 2 + 2;
			end
			if (((9754 - 5686) >= (3608 - 2636)) and ((0 + 0) == v147)) then
				v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v52 = EpicSettings.Settings['AncestralGuidanceHP'];
				v56 = EpicSettings.Settings['AscendanceGroup'];
				v57 = EpicSettings.Settings['AscendanceHP'];
				v58 = EpicSettings.Settings['AstralShiftHP'];
				v61 = EpicSettings.Settings['CloudburstTotemGroup'];
				v147 = 1 - 0;
			end
		end
	end
	local v137 = 0 - 0;
	local function v138()
		local v148 = 719 - (316 + 403);
		local v149;
		while true do
			if (((328 + 165) < (10703 - 6810)) and (v148 == (2 + 1))) then
				if (v125.TargetIsValid() or v12:AffectingCombat() or ((3709 - 2236) >= (2362 + 970))) then
					v120 = v12:GetEnemiesInRange(13 + 27);
					v118 = v9.BossFightRemains(nil, true);
					v119 = v118;
					if ((v119 == (38499 - 27388)) or ((19346 - 15295) <= (2403 - 1246))) then
						v119 = v9.FightRemains(v120, false);
					end
				end
				if (((35 + 569) < (5671 - 2790)) and not v12:AffectingCombat()) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((44 + 856) == (9935 - 6558))) then
						local v251 = v125.DeadFriendlyUnitsCount();
						if (((4476 - (12 + 5)) > (2295 - 1704)) and (v251 > (1 - 0))) then
							if (((7223 - 3825) >= (5939 - 3544)) and v23(v121.AncestralVision, nil, v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (v23(v122.AncestralSpiritMouseover, not v14:IsInRange(9 + 31), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4156 - (1656 + 317)) >= (2517 + 307))) then
							return "ancestral_spirit";
						end
					end
				end
				v149 = v130();
				v148 = 4 + 0;
			end
			if (((5147 - 3211) == (9528 - 7592)) and (v148 == (356 - (5 + 349)))) then
				v33 = EpicSettings.Toggles['dps'];
				v149 = nil;
				if (v12:IsDeadOrGhost() or ((22951 - 18119) < (5584 - (266 + 1005)))) then
					return;
				end
				v148 = 2 + 1;
			end
			if (((13948 - 9860) > (5099 - 1225)) and (v148 == (1696 - (561 + 1135)))) then
				v135();
				v136();
				v29 = EpicSettings.Toggles['ooc'];
				v148 = 1 - 0;
			end
			if (((14239 - 9907) == (5398 - (507 + 559))) and (v148 == (9 - 5))) then
				if (((12367 - 8368) >= (3288 - (212 + 176))) and v149) then
					return v149;
				end
				if (v12:AffectingCombat() or v29 or ((3430 - (250 + 655)) > (11082 - 7018))) then
					local v247 = v44 and v121.PurifySpirit:IsReady() and v31;
					if (((7637 - 3266) == (6838 - 2467)) and v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 1981 - (1869 + 87)) < (3 - 2))) then
						v28 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 1916 - (484 + 1417), 85 - 45, "TANK", true, 41 - 16);
						if (v28 or ((1039 - (48 + 725)) > (8145 - 3159))) then
							return v28;
						end
						if (((5341 - 3350) >= (538 + 387)) and (v125.UnitGroupRole(v16) == "TANK")) then
							if (((1215 - 760) < (575 + 1478)) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					if (not v16:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v16) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 8 + 17) >= (854 - (152 + 701))) or ((2137 - (430 + 881)) == (1858 + 2993))) then
						local v252 = 895 - (557 + 338);
						while true do
							if (((55 + 128) == (515 - 332)) and ((0 - 0) == v252)) then
								v28 = v125.FocusUnit(v247, nil, 106 - 66, nil, 53 - 28);
								if (((1960 - (499 + 302)) <= (2654 - (39 + 827))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					v28 = v125.FocusSpecifiedUnit(v125.FriendlyUnitWithHealAbsorb(110 - 70, nil, 55 - 30), 119 - 89);
					if (v28 or ((5384 - 1877) > (370 + 3948))) then
						return v28;
					end
				end
				if ((v121.EarthShield:IsCastable() and v96 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(117 - 77) and (v125.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v121.EarthShield))) or ((492 + 2583) <= (4691 - 1726))) then
					if (((1469 - (103 + 1)) <= (2565 - (475 + 79))) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v148 = 10 - 5;
			end
			if ((v148 == (16 - 11)) or ((359 + 2417) > (3147 + 428))) then
				if ((v12:AffectingCombat() and v125.TargetIsValid()) or ((4057 - (1395 + 108)) == (13979 - 9175))) then
					local v248 = 1204 - (7 + 1197);
					while true do
						if (((1124 + 1453) == (900 + 1677)) and (v248 == (320 - (27 + 292)))) then
							v28 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 87 - 57, true, v15);
							if (v28 or ((7 - 1) >= (7921 - 6032))) then
								return v28;
							end
							v28 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 59 - 29, nil, v15);
							if (((963 - 457) <= (2031 - (43 + 96))) and v28) then
								return v28;
							end
							v248 = 8 - 6;
						end
						if ((v248 == (3 - 1)) or ((1667 + 341) > (627 + 1591))) then
							v149 = v129();
							if (((748 - 369) <= (1590 + 2557)) and v149) then
								return v149;
							end
							if ((v121.GreaterPurge:IsAvailable() and v46 and v121.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((8459 - 3945) <= (318 + 691))) then
								if (v23(v121.GreaterPurge, not v14:IsSpellInRange(v121.GreaterPurge)) or ((257 + 3239) == (2943 - (1414 + 337)))) then
									return "greater_purge utility";
								end
							end
							if ((v121.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((2148 - (1642 + 298)) == (7713 - 4754))) then
								if (((12304 - 8027) >= (3896 - 2583)) and v23(v121.Purge, not v14:IsSpellInRange(v121.Purge))) then
									return "purge utility";
								end
							end
							v248 = 1 + 2;
						end
						if (((2013 + 574) < (4146 - (357 + 615))) and (v248 == (0 + 0))) then
							if ((v30 and v50 and v123.Dreambinder:IsEquippedAndReady()) or v123.Iridal:IsEquippedAndReady() or ((10109 - 5989) <= (1884 + 314))) then
								if (v23(v122.UseWeapon, nil) or ((3420 - 1824) == (687 + 171))) then
									return "Using Weapon Macro";
								end
							end
							if (((219 + 3001) == (2024 + 1196)) and v116 and v123.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v117)) then
								if (v23(v122.ManaPotion, nil) or ((2703 - (384 + 917)) > (4317 - (128 + 569)))) then
									return "Mana Potion main";
								end
							end
							v28 = v125.Interrupt(v121.WindShear, 1573 - (1407 + 136), true);
							if (((4461 - (687 + 1200)) == (4284 - (556 + 1154))) and v28) then
								return v28;
							end
							v248 = 3 - 2;
						end
						if (((1893 - (9 + 86)) < (3178 - (275 + 146))) and (v248 == (1 + 2))) then
							if ((v119 > v111) or ((441 - (29 + 35)) > (11540 - 8936))) then
								v149 = v131();
								if (((1696 - 1128) < (4021 - 3110)) and v149) then
									return v149;
								end
							end
							break;
						end
					end
				end
				if (((2140 + 1145) < (5240 - (53 + 959))) and (v29 or v12:AffectingCombat())) then
					local v249 = 408 - (312 + 96);
					while true do
						if (((6796 - 2880) > (3613 - (147 + 138))) and (v249 == (901 - (813 + 86)))) then
							if (((2260 + 240) < (7112 - 3273)) and v32) then
								if (((999 - (18 + 474)) == (172 + 335)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v14:BuffDown(v121.Riptide) and not v12:CanAttack(v14)) then
									if (((783 - 543) <= (4251 - (860 + 226))) and (v14:HealthPercentage() <= v82)) then
										if (((1137 - (121 + 182)) >= (100 + 705)) and v23(v121.Riptide, not v16:IsSpellInRange(v121.Riptide))) then
											return "riptide healing target";
										end
									end
								end
								if ((v104 and v121.UnleashLife:IsReady() and (v14:HealthPercentage() <= v89) and not v12:CanAttack(v14)) or ((5052 - (988 + 252)) < (262 + 2054))) then
									if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((831 + 1821) <= (3503 - (49 + 1921)))) then
										return "unleash_life healing target";
									end
								end
								if ((v93 and (v14:HealthPercentage() <= v60) and v121.ChainHeal:IsReady() and (v12:IsInParty() or v12:IsInRaid() or v125.TargetIsValidHealableNpc() or v12:BuffUp(v121.HighTide)) and not v12:CanAttack(v14)) or ((4488 - (223 + 667)) < (1512 - (51 + 1)))) then
									if (v23(v121.ChainHeal, not v14:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((7084 - 2968) < (2552 - 1360))) then
										return "chain_heal healing target";
									end
								end
								if ((v100 and (v14:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and not v12:CanAttack(v14)) or ((4502 - (146 + 979)) <= (255 + 648))) then
									if (((4581 - (311 + 294)) >= (1224 - 785)) and v23(v121.HealingWave, not v14:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
										return "healing_wave healing target";
									end
								end
								v149 = v132();
								if (((1590 + 2162) == (5195 - (496 + 947))) and v149) then
									return v149;
								end
								v149 = v133();
								if (((5404 - (1233 + 125)) > (1094 + 1601)) and v149) then
									return v149;
								end
							end
							if (v33 or ((3181 + 364) == (608 + 2589))) then
								if (((4039 - (963 + 682)) > (312 + 61)) and v125.TargetIsValid()) then
									local v255 = 1504 - (504 + 1000);
									while true do
										if (((2799 + 1356) <= (3854 + 378)) and ((0 + 0) == v255)) then
											v149 = v134();
											if (v149 or ((5280 - 1699) == (2968 + 505))) then
												return v149;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((2905 + 2090) > (3530 - (156 + 26))) and (v249 == (0 + 0))) then
							if ((v31 and v44) or ((1179 - 425) > (3888 - (149 + 15)))) then
								local v253 = 960 - (890 + 70);
								while true do
									if (((334 - (39 + 78)) >= (539 - (14 + 468))) and (v253 == (2 - 1))) then
										if ((v15 and v15:Exists() and v15:IsAPlayer() and v125.UnitHasDispellableDebuffByPlayer(v15)) or ((5785 - 3715) >= (2083 + 1954))) then
											if (((1625 + 1080) == (575 + 2130)) and v121.PurifySpirit:IsCastable()) then
												if (((28 + 33) == (16 + 45)) and v23(v122.PurifySpiritMouseover, not v15:IsSpellInRange(v121.PurifySpirit))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
									if ((v253 == (0 - 0)) or ((691 + 8) >= (4554 - 3258))) then
										if ((v121.Bursting:MaxDebuffStack() > (1 + 3)) or ((1834 - (12 + 39)) >= (3365 + 251))) then
											local v256 = 0 - 0;
											while true do
												if ((v256 == (0 - 0)) or ((1161 + 2752) > (2383 + 2144))) then
													v28 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
													if (((11096 - 6720) > (545 + 272)) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if (((23492 - 18631) > (2534 - (1596 + 114))) and v16) then
											if ((v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(65 - 40)) or ((2096 - (164 + 549)) >= (3569 - (1059 + 379)))) then
												local v257 = 0 - 0;
												while true do
													if ((v257 == (0 + 0)) or ((317 + 1559) >= (2933 - (145 + 247)))) then
														if (((1463 + 319) <= (1743 + 2029)) and (v137 == (0 - 0))) then
															v137 = GetTime();
														end
														if (v125.Wait(96 + 404, v137) or ((4049 + 651) < (1319 - 506))) then
															if (((3919 - (254 + 466)) < (4610 - (544 + 16))) and v23(v122.PurifySpiritFocus, not v16:IsSpellInRange(v121.PurifySpirit))) then
																return "purify_spirit dispel focus";
															end
															v137 = 0 - 0;
														end
														break;
													end
												end
											end
										end
										v253 = 629 - (294 + 334);
									end
								end
							end
							if ((v121.Bursting:AuraActiveCount() > (256 - (236 + 17))) or ((2135 + 2816) < (3449 + 981))) then
								local v254 = 0 - 0;
								while true do
									if (((454 - 358) == (50 + 46)) and ((0 + 0) == v254)) then
										if (((v121.Bursting:MaxDebuffStack() > (799 - (413 + 381))) and v121.SpiritLinkTotem:IsReady()) or ((116 + 2623) > (8524 - 4516))) then
											if ((v86 == "Player") or ((59 - 36) == (3104 - (582 + 1388)))) then
												if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(68 - 28)) or ((1928 + 765) >= (4475 - (326 + 38)))) then
													return "spirit_link_totem bursting";
												end
											elseif ((v86 == "Friendly under Cursor") or ((12767 - 8451) <= (3063 - 917))) then
												if ((v15:Exists() and not v12:CanAttack(v15)) or ((4166 - (47 + 573)) <= (991 + 1818))) then
													if (((20827 - 15923) > (3515 - 1349)) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(1704 - (1269 + 395)))) then
														return "spirit_link_totem bursting";
													end
												end
											elseif (((601 - (76 + 416)) >= (533 - (319 + 124))) and (v86 == "Confirmation")) then
												if (((11379 - 6401) > (3912 - (564 + 443))) and v23(v121.SpiritLinkTotem, not v14:IsInRange(110 - 70))) then
													return "spirit_link_totem bursting";
												end
											end
										end
										if ((v93 and v121.ChainHeal:IsReady()) or ((3484 - (337 + 121)) <= (6680 - 4400))) then
											if (v23(v122.ChainHealFocus, nil) or ((5505 - 3852) <= (3019 - (1261 + 650)))) then
												return "Chain Heal Spam because of Bursting";
											end
										end
										break;
									end
								end
							end
							v249 = 1 + 0;
						end
						if (((4635 - 1726) > (4426 - (772 + 1045))) and (v249 == (1 + 0))) then
							if (((901 - (102 + 42)) > (2038 - (1524 + 320))) and (v16:HealthPercentage() < v81) and v16:BuffDown(v121.Riptide)) then
								if (v121.PrimordialWaveResto:IsCastable() or ((1301 - (1049 + 221)) >= (1554 - (18 + 138)))) then
									if (((7822 - 4626) <= (5974 - (67 + 1035))) and v23(v122.PrimordialWaveFocus, not v16:IsSpellInRange(v121.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							if (((3674 - (136 + 212)) == (14133 - 10807)) and v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v12:GCD() * (3 + 0)))) then
								if (((1322 + 111) <= (5482 - (240 + 1364))) and v23(v121.TotemicRecall, nil)) then
									return "totemic_recall main";
								end
							end
							v249 = 1084 - (1050 + 32);
						end
					end
				end
				break;
			end
			if ((v148 == (3 - 2)) or ((937 + 646) == (2790 - (331 + 724)))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v148 = 1 + 1;
			end
		end
	end
	local function v139()
		v127();
		v121.Bursting:RegisterAuraTracking();
		v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(908 - (269 + 375), v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

