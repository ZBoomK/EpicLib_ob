local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((221 - (128 + 10)) > (123 + 1657))) then
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
	local v118 = 12646 - (1051 + 484);
	local v119 = 1216 + 9895;
	local v120;
	v9:RegisterForEvent(function()
		local v140 = 0 - 0;
		while true do
			if (((204 + 342) <= (2669 - 1592)) and (v140 == (1026 - (834 + 192)))) then
				v118 = 707 + 10404;
				v119 = 2852 + 8259;
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
		if (v121.ImprovedPurifySpirit:IsAvailable() or ((22 + 974) > (6662 - 2361))) then
			v125.DispellableDebuffs = v20.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (309 - (300 + 4)));
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if (((10654 - 6584) > (1049 - (112 + 250))) and (v142 == (1 + 0))) then
				if ((v123.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((1643 - 987) >= (1908 + 1422))) then
					if (v23(v122.Healthstone) or ((1289 + 1203) <= (251 + 84))) then
						return "healthstone defensive 3";
					end
				end
				if (((2143 + 2179) >= (1904 + 658)) and v37 and (v12:HealthPercentage() <= v38)) then
					local v250 = 1414 - (1001 + 413);
					while true do
						if ((v250 == (0 - 0)) or ((4519 - (244 + 638)) >= (4463 - (627 + 66)))) then
							if ((v39 == "Refreshing Healing Potion") or ((7088 - 4709) > (5180 - (512 + 90)))) then
								if (v123.RefreshingHealingPotion:IsReady() or ((2389 - (1665 + 241)) > (1460 - (373 + 344)))) then
									if (((1107 + 1347) > (153 + 425)) and v23(v122.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((2453 - 1523) < (7543 - 3085)) and (v39 == "Dreamwalker's Healing Potion")) then
								if (((1761 - (35 + 1064)) <= (708 + 264)) and v123.DreamwalkersHealingPotion:IsReady()) then
									if (((9349 - 4979) == (18 + 4352)) and v23(v122.RefreshingHealingPotion)) then
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
			if ((v142 == (1236 - (298 + 938))) or ((6021 - (233 + 1026)) <= (2527 - (636 + 1030)))) then
				if ((v92 and v121.AstralShift:IsReady()) or ((722 + 690) == (4165 + 99))) then
					if ((v12:HealthPercentage() <= v58) or ((942 + 2226) < (146 + 2007))) then
						if (v23(v121.AstralShift, not v14:IsInRange(261 - (55 + 166))) or ((965 + 4011) < (134 + 1198))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((17674 - 13046) == (4925 - (36 + 261))) and v95 and v121.EarthElemental:IsReady()) then
					if ((v12:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67, 43 - 18, v121.ChainHeal) or ((1422 - (34 + 1334)) == (152 + 243))) then
						if (((64 + 18) == (1365 - (1035 + 248))) and v23(v121.EarthElemental, not v14:IsInRange(61 - (20 + 1)))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v130()
		local v143 = 319 - (134 + 185);
		while true do
			if ((v143 == (1134 - (549 + 584))) or ((1266 - (314 + 371)) < (967 - 685))) then
				if (v40 or ((5577 - (478 + 490)) < (1322 + 1173))) then
					local v251 = 1172 - (786 + 386);
					while true do
						if (((3731 - 2579) == (2531 - (1055 + 324))) and ((1341 - (1093 + 247)) == v251)) then
							v28 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 36 + 4);
							if (((200 + 1696) <= (13585 - 10163)) and v28) then
								return v28;
							end
							break;
						end
						if ((v251 == (0 - 0)) or ((2817 - 1827) > (4070 - 2450))) then
							v28 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 15 + 25);
							if (v28 or ((3378 - 2501) > (16182 - 11487))) then
								return v28;
							end
							v251 = 1 + 0;
						end
					end
				end
				if (((6881 - 4190) >= (2539 - (364 + 324))) and v41) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (6 - 3)) or ((990 + 1995) >= (20318 - 15462))) then
							v28 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 64 - 24);
							if (((12986 - 8710) >= (2463 - (1249 + 19))) and v28) then
								return v28;
							end
							break;
						end
						if (((2918 + 314) <= (18255 - 13565)) and ((1087 - (686 + 400)) == v252)) then
							v28 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 32 + 8);
							if (v28 or ((1125 - (73 + 156)) >= (15 + 3131))) then
								return v28;
							end
							v252 = 813 - (721 + 90);
						end
						if (((35 + 3026) >= (9604 - 6646)) and ((472 - (224 + 246)) == v252)) then
							v28 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 64 - 24);
							if (((5867 - 2680) >= (117 + 527)) and v28) then
								return v28;
							end
							v252 = 1 + 2;
						end
						if (((474 + 170) <= (1399 - 695)) and (v252 == (0 - 0))) then
							v28 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 553 - (203 + 310));
							if (((2951 - (1238 + 755)) > (67 + 880)) and v28) then
								return v28;
							end
							v252 = 1535 - (709 + 825);
						end
					end
				end
				v143 = 3 - 1;
			end
			if (((6542 - 2050) >= (3518 - (196 + 668))) and (v143 == (0 - 0))) then
				if (((7129 - 3687) >= (2336 - (171 + 662))) and v113) then
					local v253 = 93 - (4 + 89);
					while true do
						if ((v253 == (0 - 0)) or ((1155 + 2015) <= (6430 - 4966))) then
							v28 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 12 + 18, true);
							if (v28 or ((6283 - (35 + 1451)) == (5841 - (28 + 1425)))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((2544 - (941 + 1052)) <= (653 + 28)) and v112) then
					local v254 = 1514 - (822 + 692);
					while true do
						if (((4678 - 1401) > (192 + 215)) and (v254 == (297 - (45 + 252)))) then
							v28 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 30 + 0);
							if (((1616 + 3079) >= (3443 - 2028)) and v28) then
								return v28;
							end
							v254 = 434 - (114 + 319);
						end
						if ((v254 == (1 - 0)) or ((4115 - 903) <= (602 + 342))) then
							if (v114 or ((4612 - 1516) <= (3767 - 1969))) then
								local v266 = 1963 - (556 + 1407);
								while true do
									if (((4743 - (741 + 465)) == (4002 - (170 + 295))) and (v266 == (0 + 0))) then
										v28 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 28 + 2);
										if (((9446 - 5609) >= (1302 + 268)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (v115 or ((1892 + 1058) == (2159 + 1653))) then
								local v267 = 1230 - (957 + 273);
								while true do
									if (((1264 + 3459) >= (928 + 1390)) and (v267 == (0 - 0))) then
										v28 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 79 - 49);
										if (v28 or ((6191 - 4164) > (14122 - 11270))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v143 = 1781 - (389 + 1391);
			end
			if ((v143 == (2 + 0)) or ((119 + 1017) > (9827 - 5510))) then
				if (((5699 - (783 + 168)) == (15935 - 11187)) and v42) then
					local v255 = 0 + 0;
					while true do
						if (((4047 - (309 + 2)) <= (14556 - 9816)) and ((1212 - (1090 + 122)) == v255)) then
							v28 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 13 + 27);
							if (v28 or ((11385 - 7995) <= (2095 + 965))) then
								return v28;
							end
							v255 = 1119 - (628 + 490);
						end
						if ((v255 == (1 + 2)) or ((2473 - 1474) > (12306 - 9613))) then
							v28 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 814 - (431 + 343));
							if (((934 - 471) < (1738 - 1137)) and v28) then
								return v28;
							end
							break;
						end
						if ((v255 == (2 + 0)) or ((280 + 1903) < (2382 - (556 + 1139)))) then
							v28 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 55 - (6 + 9));
							if (((833 + 3716) == (2331 + 2218)) and v28) then
								return v28;
							end
							v255 = 172 - (28 + 141);
						end
						if (((1810 + 2862) == (5766 - 1094)) and (v255 == (1 + 0))) then
							v28 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 1357 - (486 + 831));
							if (v28 or ((9544 - 5876) < (1390 - 995))) then
								return v28;
							end
							v255 = 1 + 1;
						end
					end
				end
				if (v43 or ((13172 - 9006) == (1718 - (668 + 595)))) then
					local v256 = 0 + 0;
					while true do
						if ((v256 == (0 + 0)) or ((12132 - 7683) == (2953 - (23 + 267)))) then
							v28 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 1984 - (1129 + 815));
							if (v28 or ((4664 - (371 + 16)) < (4739 - (1326 + 424)))) then
								return v28;
							end
							v256 = 1 - 0;
						end
						if ((v256 == (10 - 7)) or ((988 - (88 + 30)) >= (4920 - (720 + 51)))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 88 - 48);
							if (((3988 - (421 + 1355)) < (5250 - 2067)) and v28) then
								return v28;
							end
							break;
						end
						if (((2283 + 2363) > (4075 - (286 + 797))) and (v256 == (3 - 2))) then
							v28 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 66 - 26);
							if (((1873 - (397 + 42)) < (971 + 2135)) and v28) then
								return v28;
							end
							v256 = 802 - (24 + 776);
						end
						if (((1210 - 424) < (3808 - (222 + 563))) and (v256 == (3 - 1))) then
							v28 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 29 + 11);
							if (v28 or ((2632 - (23 + 167)) < (1872 - (690 + 1108)))) then
								return v28;
							end
							v256 = 2 + 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v144 = 0 + 0;
		while true do
			if (((5383 - (40 + 808)) == (747 + 3788)) and (v144 == (3 - 2))) then
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2876 + 133) <= (1114 + 991))) then
					if (((1004 + 826) < (4240 - (47 + 524))) and (v16:HealthPercentage() <= v82)) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((929 + 501) >= (9873 - 6261))) then
							return "riptide healingcd";
						end
					end
				end
				if (((4011 - 1328) >= (5610 - 3150)) and v125.AreUnitsBelowHealthPercentage(v85, v84, v121.ChainHeal) and v121.SpiritLinkTotem:IsReady()) then
					if ((v86 == "Player") or ((3530 - (1165 + 561)) >= (98 + 3177))) then
						if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(123 - 83)) or ((541 + 876) > (4108 - (341 + 138)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((1295 + 3500) > (829 - 427)) and (v86 == "Friendly under Cursor")) then
						if (((5139 - (89 + 237)) > (11468 - 7903)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((8235 - 4323) == (4793 - (581 + 300))) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(1260 - (855 + 365)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((6700 - 3879) <= (1576 + 3248)) and (v86 == "Confirmation")) then
						if (((2973 - (1030 + 205)) <= (2061 + 134)) and v23(v121.SpiritLinkTotem, not v14:IsInRange(38 + 2))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 288 - (156 + 130);
			end
			if (((93 - 52) <= (5086 - 2068)) and (v144 == (3 - 1))) then
				if (((566 + 1579) <= (2394 + 1710)) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77, v121.ChainHeal) and v121.HealingTideTotem:IsReady()) then
					if (((2758 - (10 + 59)) < (1371 + 3474)) and v23(v121.HealingTideTotem, not v14:IsInRange(196 - 156))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v54, v53, v121.ChainHeal) and v121.AncestralProtectionTotem:IsReady()) or ((3485 - (671 + 492)) > (2088 + 534))) then
					if ((v55 == "Player") or ((5749 - (369 + 846)) == (552 + 1530))) then
						if (v23(v122.AncestralProtectionTotemPlayer, not v14:IsInRange(35 + 5)) or ((3516 - (1036 + 909)) > (1485 + 382))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v55 == "Friendly under Cursor") or ((4455 - 1801) >= (3199 - (11 + 192)))) then
						if (((2011 + 1967) > (2279 - (135 + 40))) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((7256 - 4261) > (929 + 612)) and v23(v122.AncestralProtectionTotemCursor, not v14:IsInRange(88 - 48))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((4870 - 1621) > (1129 - (50 + 126))) and (v55 == "Confirmation")) then
						if (v23(v121.AncestralProtectionTotem, not v14:IsInRange(111 - 71)) or ((725 + 2548) > (5986 - (1233 + 180)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 972 - (522 + 447);
			end
			if ((v144 == (1424 - (107 + 1314))) or ((1463 + 1688) < (3912 - 2628))) then
				if ((v90 and v125.AreUnitsBelowHealthPercentage(v52, v51, v121.ChainHeal) and v121.AncestralGuidance:IsReady()) or ((786 + 1064) == (3035 - 1506))) then
					if (((3248 - 2427) < (4033 - (716 + 1194))) and v23(v121.AncestralGuidance, not v14:IsInRange(1 + 39))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((97 + 805) < (2828 - (74 + 429))) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56, v121.ChainHeal) and v121.Ascendance:IsReady()) then
					if (((1654 - 796) <= (1469 + 1493)) and v23(v121.Ascendance, not v14:IsInRange(91 - 51))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 3 + 1;
			end
			if ((v144 == (12 - 8)) or ((9756 - 5810) < (1721 - (279 + 154)))) then
				if ((v101 and (v12:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) or ((4020 - (454 + 324)) == (447 + 120))) then
					if (v23(v121.ManaTideTotem, not v14:IsInRange(57 - (12 + 5))) or ((457 + 390) >= (3217 - 1954))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v34 and ((v108 and v30) or not v108)) or ((833 + 1420) == (2944 - (277 + 816)))) then
					local v257 = 0 - 0;
					while true do
						if ((v257 == (1185 - (1058 + 125))) or ((392 + 1695) > (3347 - (815 + 160)))) then
							if (v121.Fireblood:IsReady() or ((19071 - 14626) < (9848 - 5699))) then
								if (v23(v121.Fireblood, not v14:IsInRange(10 + 30)) or ((5314 - 3496) == (1983 - (41 + 1857)))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((2523 - (1222 + 671)) < (5497 - 3370)) and (v257 == (1 - 0))) then
							if (v121.Berserking:IsReady() or ((3120 - (229 + 953)) == (4288 - (1111 + 663)))) then
								if (((5834 - (874 + 705)) >= (8 + 47)) and v23(v121.Berserking, not v14:IsInRange(28 + 12))) then
									return "Berserking cooldowns";
								end
							end
							if (((6233 - 3234) > (33 + 1123)) and v121.BloodFury:IsReady()) then
								if (((3029 - (642 + 37)) > (264 + 891)) and v23(v121.BloodFury, not v14:IsInRange(7 + 33))) then
									return "BloodFury cooldowns";
								end
							end
							v257 = 4 - 2;
						end
						if (((4483 - (233 + 221)) <= (11222 - 6369)) and (v257 == (0 + 0))) then
							if (v121.AncestralCall:IsReady() or ((2057 - (718 + 823)) > (2161 + 1273))) then
								if (((4851 - (266 + 539)) >= (8586 - 5553)) and v23(v121.AncestralCall, not v14:IsInRange(1265 - (636 + 589)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v121.BagofTricks:IsReady() or ((6453 - 3734) <= (2984 - 1537))) then
								if (v23(v121.BagofTricks, not v14:IsInRange(32 + 8)) or ((1502 + 2632) < (4941 - (657 + 358)))) then
									return "BagofTricks cooldowns";
								end
							end
							v257 = 2 - 1;
						end
					end
				end
				break;
			end
			if ((v144 == (0 - 0)) or ((1351 - (1151 + 36)) >= (2690 + 95))) then
				if ((v110 and ((v30 and v109) or not v109)) or ((139 + 386) == (6298 - 4189))) then
					local v258 = 1832 - (1552 + 280);
					while true do
						if (((867 - (64 + 770)) == (23 + 10)) and (v258 == (2 - 1))) then
							v28 = v125.HandleBottomTrinket(v124, v30, 8 + 32, nil);
							if (((4297 - (157 + 1086)) <= (8036 - 4021)) and v28) then
								return v28;
							end
							break;
						end
						if (((8194 - 6323) < (5187 - 1805)) and (v258 == (0 - 0))) then
							v28 = v125.HandleTopTrinket(v124, v30, 859 - (599 + 220), nil);
							if (((2574 - 1281) <= (4097 - (1813 + 118))) and v28) then
								return v28;
							end
							v258 = 1 + 0;
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((3796 - (841 + 376)) < (171 - 48))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((197 + 649) >= (6463 - 4095))) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((4871 - (464 + 395)) <= (8617 - 5259))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 1 + 0;
			end
		end
	end
	local function v132()
		local v145 = 837 - (467 + 370);
		while true do
			if (((3087 - 1593) <= (2206 + 799)) and ((10 - 7) == v145)) then
				if ((v103 and v12:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87, v121.ChainHeal) and v121.SpiritwalkersGrace:IsReady()) or ((486 + 2625) == (4964 - 2830))) then
					if (((2875 - (150 + 370)) == (3637 - (74 + 1208))) and v23(v121.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74, v121.ChainHeal) and v121.HealingStreamTotem:IsReady()) or ((1446 - 858) <= (2048 - 1616))) then
					if (((3414 + 1383) >= (4285 - (14 + 376))) and v23(v121.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((6203 - 2626) == (2315 + 1262)) and (v145 == (2 + 0))) then
				if (((3619 + 175) > (10820 - 7127)) and v125.AreUnitsBelowHealthPercentage(v64, v63, v121.ChainHeal) and v121.Downpour:IsReady()) then
					if ((v65 == "Player") or ((960 + 315) == (4178 - (23 + 55)))) then
						if (v23(v122.DownpourPlayer, not v14:IsInRange(94 - 54), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1062 + 529) >= (3215 + 365))) then
							return "downpour healingaoe";
						end
					elseif (((1523 - 540) <= (569 + 1239)) and (v65 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((3051 - (652 + 249)) <= (3203 - 2006))) then
							if (((5637 - (708 + 1160)) >= (3183 - 2010)) and v23(v122.DownpourCursor, not v14:IsInRange(72 - 32), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((1512 - (10 + 17)) == (334 + 1151)) and (v65 == "Confirmation")) then
						if (v23(v121.Downpour, not v14:IsInRange(1772 - (1400 + 332)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((6358 - 3043) <= (4690 - (242 + 1666)))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v94 and v125.AreUnitsBelowHealthPercentage(v62, v61, v121.ChainHeal) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (5 + 5))) or ((322 + 554) >= (2527 + 437))) then
					if (v23(v121.CloudburstTotem) or ((3172 - (850 + 90)) > (4373 - 1876))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v105 and v125.AreUnitsBelowHealthPercentage(v107, v106, v121.ChainHeal) and v121.Wellspring:IsReady()) or ((3500 - (360 + 1030)) <= (294 + 38))) then
					if (((10403 - 6717) > (4363 - 1191)) and v23(v121.Wellspring, not v14:IsInRange(1701 - (909 + 752)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if ((v93 and v125.AreUnitsBelowHealthPercentage(v60, v59, v121.ChainHeal) and v121.ChainHeal:IsReady()) or ((5697 - (109 + 1114)) < (1501 - 681))) then
					if (((1666 + 2613) >= (3124 - (6 + 236))) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v145 = 2 + 1;
			end
			if ((v145 == (1 + 0)) or ((4784 - 2755) >= (6149 - 2628))) then
				if ((v104 and v121.UnleashLife:IsReady()) or ((3170 - (1076 + 57)) >= (764 + 3878))) then
					if (((2409 - (579 + 110)) < (352 + 4106)) and (v12:HealthPercentage() <= v89)) then
						if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((386 + 50) > (1604 + 1417))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((1120 - (174 + 233)) <= (2365 - 1518)) and (v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal)) then
					if (((3780 - 1626) <= (1793 + 2238)) and v23(v122.HealingRainCursor, not v14:IsInRange(1214 - (663 + 511)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if (((4118 + 497) == (1002 + 3613)) and v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal) and v121.HealingRain:IsReady()) then
					if ((v73 == "Player") or ((11684 - 7894) == (303 + 197))) then
						if (((209 - 120) < (534 - 313)) and v23(v122.HealingRainPlayer, not v14:IsInRange(20 + 20), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((3997 - 1943) >= (1013 + 408)) and (v73 == "Friendly under Cursor")) then
						if (((64 + 628) < (3780 - (478 + 244))) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v122.HealingRainCursor, not v14:IsInRange(557 - (440 + 77)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1480 + 1774) == (6057 - 4402))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v73 == "Enemy under Cursor") or ((2852 - (655 + 901)) == (911 + 3999))) then
						if (((2579 + 789) == (2275 + 1093)) and v15:Exists() and v12:CanAttack(v15)) then
							if (((10647 - 8004) < (5260 - (695 + 750))) and v23(v122.HealingRainCursor, not v14:IsInRange(136 - 96), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((2951 - 1038) > (1982 - 1489)) and (v73 == "Confirmation")) then
						if (((5106 - (285 + 66)) > (7990 - 4562)) and v23(v121.HealingRain, not v14:IsInRange(1350 - (682 + 628)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((223 + 1158) <= (2668 - (176 + 123))) and v125.AreUnitsBelowHealthPercentage(v69, v68, v121.ChainHeal) and v121.EarthenWallTotem:IsReady()) then
					if ((v70 == "Player") or ((2026 + 2817) == (2963 + 1121))) then
						if (((4938 - (239 + 30)) > (99 + 264)) and v23(v122.EarthenWallTotemPlayer, not v14:IsInRange(39 + 1))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v70 == "Friendly under Cursor") or ((3322 - 1445) >= (9790 - 6652))) then
						if (((5057 - (306 + 9)) >= (12653 - 9027)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v122.EarthenWallTotemCursor, not v14:IsInRange(7 + 33)) or ((2786 + 1754) == (441 + 475))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((3305 - 2149) > (5720 - (1140 + 235)))) then
						if (((1424 + 813) < (3897 + 352)) and v23(v121.EarthenWallTotem, not v14:IsInRange(11 + 29))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v145 = 54 - (33 + 19);
			end
			if ((v145 == (0 + 0)) or ((8041 - 5358) < (11 + 12))) then
				if (((1366 - 669) <= (775 + 51)) and v93 and v125.AreUnitsBelowHealthPercentage(784 - (586 + 103), 1 + 2, v121.ChainHeal) and v121.ChainHeal:IsReady() and v12:BuffUp(v121.HighTide)) then
					if (((3401 - 2296) <= (2664 - (1309 + 179))) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((6099 - 2720) <= (1660 + 2152)) and v100 and (v16:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (40 - 25))) then
					if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((596 + 192) >= (3433 - 1817))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((3693 - 1839) <= (3988 - (295 + 314))) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if (((11172 - 6623) == (6511 - (1300 + 662))) and (v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((9489 - 6467) >= (4779 - (1178 + 577)))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if (((2504 + 2316) > (6497 - 4299)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if ((v16:HealthPercentage() <= v82) or ((2466 - (851 + 554)) >= (4326 + 565))) then
						if (((3782 - 2418) <= (9714 - 5241)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 303 - (115 + 187);
			end
		end
	end
	local function v133()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (2 + 0)) or ((14166 - 10571) <= (1164 - (160 + 1001)))) then
				if ((v98 and v121.HealingSurge:IsReady()) or ((4088 + 584) == (2658 + 1194))) then
					if (((3190 - 1631) == (1917 - (237 + 121))) and (v16:HealthPercentage() <= v76)) then
						if (v23(v122.HealingSurgeFocus, not v16:IsSpellInRange(v121.HealingSurge), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2649 - (525 + 372)) <= (1493 - 705))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v100 and v121.HealingWave:IsReady()) or ((12836 - 8929) == (319 - (96 + 46)))) then
					if (((4247 - (643 + 134)) > (201 + 354)) and (v16:HealthPercentage() <= v79)) then
						if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2330 - 1358) == (2394 - 1749))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if (((3052 + 130) >= (4150 - 2035)) and ((1 - 0) == v146)) then
				if (((4612 - (316 + 403)) < (2944 + 1485)) and v121.ElementalOrbit:IsAvailable() and v12:BuffDown(v121.EarthShieldBuff) and not v14:IsAPlayer() and v121.EarthShield:IsCastable() and v96 and v12:CanAttack(v14)) then
					if (v23(v121.EarthShield) or ((7882 - 5015) < (689 + 1216))) then
						return "earth_shield player healingst";
					end
				end
				if ((v121.ElementalOrbit:IsAvailable() and v12:BuffUp(v121.EarthShieldBuff)) or ((4522 - 2726) >= (2871 + 1180))) then
					if (((522 + 1097) <= (13014 - 9258)) and v125.IsSoloMode()) then
						if (((2884 - 2280) == (1254 - 650)) and v121.LightningShield:IsReady() and v12:BuffDown(v121.LightningShield)) then
							if (v23(v121.LightningShield) or ((257 + 4227) == (1771 - 871))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v121.WaterShield:IsReady() and v12:BuffDown(v121.WaterShield)) or ((218 + 4241) <= (3274 - 2161))) then
						if (((3649 - (12 + 5)) > (13197 - 9799)) and v23(v121.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v146 = 3 - 1;
			end
			if (((8676 - 4594) <= (12193 - 7276)) and (v146 == (0 + 0))) then
				if (((6805 - (1656 + 317)) >= (1236 + 150)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if (((110 + 27) == (363 - 226)) and (v16:HealthPercentage() <= v82)) then
						if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((7726 - 6156) >= (4686 - (5 + 349)))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((19303 - 15239) <= (3090 - (266 + 1005)))) then
					if (((v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) or ((3286 + 1700) < (5370 - 3796))) then
						if (((5826 - 1400) > (1868 - (561 + 1135))) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v146 = 1 - 0;
			end
		end
	end
	local function v134()
		local v147 = 0 - 0;
		while true do
			if (((1652 - (507 + 559)) > (1141 - 686)) and (v147 == (0 - 0))) then
				if (((1214 - (212 + 176)) == (1731 - (250 + 655))) and v121.Stormkeeper:IsReady()) then
					if (v23(v121.Stormkeeper, not v14:IsInRange(109 - 69)) or ((7022 - 3003) > (6948 - 2507))) then
						return "stormkeeper damage";
					end
				end
				if (((3973 - (1869 + 87)) < (14778 - 10517)) and (math.max(#v12:GetEnemiesInRange(1921 - (484 + 1417)), v12:GetEnemiesInSplashRangeCount(16 - 8)) > (2 - 0))) then
					if (((5489 - (48 + 725)) > (130 - 50)) and v121.ChainLightning:IsReady()) then
						if (v23(v121.ChainLightning, not v14:IsSpellInRange(v121.ChainLightning), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((9408 - 5901) == (1902 + 1370))) then
							return "chain_lightning damage";
						end
					end
				end
				v147 = 2 - 1;
			end
			if ((v147 == (1 + 0)) or ((256 + 620) >= (3928 - (152 + 701)))) then
				if (((5663 - (430 + 881)) > (979 + 1575)) and v121.FlameShock:IsReady()) then
					local v259 = 895 - (557 + 338);
					while true do
						if ((v259 == (0 + 0)) or ((12416 - 8010) < (14157 - 10114))) then
							if (v125.CastCycle(v121.FlameShock, v12:GetEnemiesInRange(106 - 66), v128, not v14:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil) or ((4070 - 2181) >= (4184 - (499 + 302)))) then
								return "flame_shock_cycle damage";
							end
							if (((2758 - (39 + 827)) <= (7547 - 4813)) and v23(v121.FlameShock, not v14:IsSpellInRange(v121.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((4294 - 2371) < (8809 - 6591)) and v121.LavaBurst:IsReady()) then
					if (((3335 - 1162) > (33 + 346)) and v23(v121.LavaBurst, not v14:IsSpellInRange(v121.LavaBurst), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v147 = 5 - 3;
			end
			if ((v147 == (1 + 1)) or ((4099 - 1508) == (3513 - (103 + 1)))) then
				if (((5068 - (475 + 79)) > (7185 - 3861)) and v121.LightningBolt:IsReady()) then
					if (v23(v121.LightningBolt, not v14:IsSpellInRange(v121.LightningBolt), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((665 - 457) >= (624 + 4204))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v135()
		v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v59 = EpicSettings.Settings['ChainHealGroup'];
		v60 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v63 = EpicSettings.Settings['DownpourGroup'];
		v64 = EpicSettings.Settings['DownpourHP'];
		v65 = EpicSettings.Settings['DownpourUsage'];
		v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v69 = EpicSettings.Settings['EarthenWallTotemHP'];
		v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v38 = EpicSettings.Settings['healingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v71 = EpicSettings.Settings['HealingRainGroup'];
		v72 = EpicSettings.Settings['HealingRainHP'];
		v73 = EpicSettings.Settings['HealingRainUsage'];
		v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v75 = EpicSettings.Settings['HealingStreamTotemHP'];
		v76 = EpicSettings.Settings['HealingSurgeHP'];
		v77 = EpicSettings.Settings['HealingTideTotemGroup'];
		v78 = EpicSettings.Settings['HealingTideTotemHP'];
		v79 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v49 = EpicSettings.Settings['InterruptThreshold'];
		v47 = EpicSettings.Settings['InterruptWithStun'];
		v82 = EpicSettings.Settings['RiptideHP'];
		v83 = EpicSettings.Settings['RiptideTankHP'];
		v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v89 = EpicSettings.Settings['UnleashLifeHP'];
		v93 = EpicSettings.Settings['UseChainHeal'];
		v94 = EpicSettings.Settings['UseCloudburstTotem'];
		v96 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['useHealingPotion'];
		v97 = EpicSettings.Settings['UseHealingStreamTotem'];
		v98 = EpicSettings.Settings['UseHealingSurge'];
		v99 = EpicSettings.Settings['UseHealingTideTotem'];
		v100 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v46 = EpicSettings.Settings['UsePurgeTarget'];
		v102 = EpicSettings.Settings['UseRiptide'];
		v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v104 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v136()
		local v197 = 0 + 0;
		while true do
			if ((v197 == (1506 - (1395 + 108))) or ((4606 - 3023) > (4771 - (7 + 1197)))) then
				v91 = EpicSettings.Settings['UseAscendance'];
				v92 = EpicSettings.Settings['UseAstralShift'];
				v95 = EpicSettings.Settings['UseEarthElemental'];
				v101 = EpicSettings.Settings['UseManaTideTotem'];
				v197 = 2 + 2;
			end
			if ((v197 == (3 + 3)) or ((1632 - (27 + 292)) == (2326 - 1532))) then
				v110 = EpicSettings.Settings['useTrinkets'];
				v111 = EpicSettings.Settings['fightRemainsCheck'];
				v50 = EpicSettings.Settings['useWeapon'];
				v112 = EpicSettings.Settings['handleAfflicted'];
				v197 = 8 - 1;
			end
			if (((13310 - 10136) > (5722 - 2820)) and (v197 == (3 - 1))) then
				v67 = EpicSettings.Settings['EarthElementalTankHP'];
				v80 = EpicSettings.Settings['ManaTideTotemMana'];
				v81 = EpicSettings.Settings['PrimordialWaveHP'];
				v90 = EpicSettings.Settings['UseAncestralGuidance'];
				v197 = 142 - (43 + 96);
			end
			if (((16805 - 12685) <= (9631 - 5371)) and (v197 == (6 + 1))) then
				v113 = EpicSettings.Settings['HandleIncorporeal'];
				v40 = EpicSettings.Settings['HandleChromie'];
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v197 = 3 + 5;
			end
			if (((9 - 4) == v197) or ((339 + 544) > (8954 - 4176))) then
				v117 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['racialsWithCD'];
				v34 = EpicSettings.Settings['useRacials'];
				v109 = EpicSettings.Settings['trinketsWithCD'];
				v197 = 2 + 4;
			end
			if ((v197 == (1 + 7)) or ((5371 - (1414 + 337)) >= (6831 - (1642 + 298)))) then
				v43 = EpicSettings.Settings['HandleFyrakkNPC'];
				v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((11099 - 6841) > (2695 - 1758)) and ((0 - 0) == v197)) then
				v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v52 = EpicSettings.Settings['AncestralGuidanceHP'];
				v56 = EpicSettings.Settings['AscendanceGroup'];
				v57 = EpicSettings.Settings['AscendanceHP'];
				v197 = 1 + 0;
			end
			if ((v197 == (4 + 0)) or ((5841 - (357 + 615)) < (636 + 270))) then
				v105 = EpicSettings.Settings['UseWellspring'];
				v106 = EpicSettings.Settings['WellspringGroup'];
				v107 = EpicSettings.Settings['WellspringHP'];
				v116 = EpicSettings.Settings['useManaPotion'];
				v197 = 11 - 6;
			end
			if ((v197 == (1 + 0)) or ((2625 - 1400) > (3382 + 846))) then
				v58 = EpicSettings.Settings['AstralShiftHP'];
				v61 = EpicSettings.Settings['CloudburstTotemGroup'];
				v62 = EpicSettings.Settings['CloudburstTotemHP'];
				v66 = EpicSettings.Settings['EarthElementalHP'];
				v197 = 1 + 1;
			end
		end
	end
	local v137 = 0 + 0;
	local function v138()
		v135();
		v136();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['dispel'];
		v32 = EpicSettings.Toggles['healing'];
		v33 = EpicSettings.Toggles['dps'];
		local v203;
		if (((4629 - (384 + 917)) > (2935 - (128 + 569))) and v12:IsDeadOrGhost()) then
			return;
		end
		if (((5382 - (1407 + 136)) > (3292 - (687 + 1200))) and (v125.TargetIsValid() or v12:AffectingCombat())) then
			local v208 = 1710 - (556 + 1154);
			while true do
				if (((0 - 0) == v208) or ((1388 - (9 + 86)) <= (928 - (275 + 146)))) then
					v120 = v12:GetEnemiesInRange(7 + 33);
					v118 = v9.BossFightRemains(nil, true);
					v208 = 65 - (29 + 35);
				end
				if (((4 - 3) == v208) or ((8650 - 5754) < (3553 - 2748))) then
					v119 = v118;
					if (((1509 + 807) == (3328 - (53 + 959))) and (v119 == (11519 - (312 + 96)))) then
						v119 = v9.FightRemains(v120, false);
					end
					break;
				end
			end
		end
		if (not v12:AffectingCombat() or ((4460 - 1890) == (1818 - (147 + 138)))) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((1782 - (813 + 86)) == (1320 + 140))) then
				local v248 = 0 - 0;
				local v249;
				while true do
					if ((v248 == (492 - (18 + 474))) or ((1559 + 3060) <= (3260 - 2261))) then
						v249 = v125.DeadFriendlyUnitsCount();
						if ((v249 > (1087 - (860 + 226))) or ((3713 - (121 + 182)) > (507 + 3609))) then
							if (v23(v121.AncestralVision, nil, v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((2143 - (988 + 252)) >= (346 + 2713))) then
								return "ancestral_vision";
							end
						elseif (v23(v122.AncestralSpiritMouseover, not v14:IsInRange(13 + 27), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5946 - (49 + 1921)) < (3747 - (223 + 667)))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v203 = v130();
		if (((4982 - (51 + 1)) > (3970 - 1663)) and v203) then
			return v203;
		end
		if (v12:AffectingCombat() or v29 or ((8663 - 4617) < (2416 - (146 + 979)))) then
			local v209 = 0 + 0;
			local v210;
			while true do
				if ((v209 == (605 - (311 + 294))) or ((11826 - 7585) == (1502 + 2043))) then
					v210 = v44 and v121.PurifySpirit:IsReady() and v31;
					if ((v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 1468 - (496 + 947)) < (1359 - (1233 + 125)))) or ((1643 + 2405) > (3797 + 435))) then
						v28 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 3 + 12, 1685 - (963 + 682), "TANK", true, 21 + 4, v121.ChainHeal);
						if (v28 or ((3254 - (504 + 1000)) >= (2339 + 1134))) then
							return v28;
						end
						if (((2884 + 282) == (299 + 2867)) and (v125.UnitGroupRole(v16) == "TANK")) then
							if (((2599 - 836) < (3182 + 542)) and v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					v209 = 1 + 0;
				end
				if (((239 - (156 + 26)) <= (1569 + 1154)) and (v209 == (1 - 0))) then
					if (not v16:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v16) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 189 - (149 + 15)) >= (961 - (890 + 70))) or ((2187 - (39 + 78)) == (925 - (14 + 468)))) then
						local v260 = 0 - 0;
						while true do
							if ((v260 == (0 - 0)) or ((1396 + 1309) == (837 + 556))) then
								v28 = v125.FocusUnit(v210, nil, 9 + 31, nil, 12 + 13, v121.ChainHeal);
								if (v28 or ((1206 + 3395) < (116 - 55))) then
									return v28;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if ((v121.EarthShield:IsCastable() and v96 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(40 + 0) and (v125.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v121.EarthShield))) or ((4884 - 3494) >= (120 + 4624))) then
			if (v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield)) or ((2054 - (12 + 39)) > (3567 + 267))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if ((v12:AffectingCombat() and v125.TargetIsValid()) or ((482 - 326) > (13936 - 10023))) then
			local v211 = 0 + 0;
			while true do
				if (((103 + 92) == (494 - 299)) and (v211 == (0 + 0))) then
					if (((15005 - 11900) >= (3506 - (1596 + 114))) and ((v30 and v50 and v123.Dreambinder:IsEquippedAndReady()) or v123.Iridal:IsEquippedAndReady())) then
						if (((11432 - 7053) >= (2844 - (164 + 549))) and v23(v122.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((5282 - (1059 + 379)) >= (2536 - 493)) and v116 and v123.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v117)) then
						if (v23(v122.ManaPotion, nil) or ((1676 + 1556) <= (461 + 2270))) then
							return "Mana Potion main";
						end
					end
					v28 = v125.Interrupt(v121.WindShear, 422 - (145 + 247), true);
					if (((4025 + 880) == (2267 + 2638)) and v28) then
						return v28;
					end
					v211 = 2 - 1;
				end
				if ((v211 == (1 + 0)) or ((3563 + 573) >= (7162 - 2751))) then
					v28 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 750 - (254 + 466), true, v15);
					if (v28 or ((3518 - (544 + 16)) == (12765 - 8748))) then
						return v28;
					end
					v28 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 658 - (294 + 334), nil, v15);
					if (((1481 - (236 + 17)) >= (351 + 462)) and v28) then
						return v28;
					end
					v211 = 2 + 0;
				end
				if ((v211 == (10 - 7)) or ((16357 - 12902) > (2086 + 1964))) then
					if (((201 + 42) == (1037 - (413 + 381))) and (v119 > v111)) then
						local v261 = 0 + 0;
						while true do
							if (((0 - 0) == v261) or ((703 - 432) > (3542 - (582 + 1388)))) then
								v203 = v131();
								if (((4666 - 1927) < (2358 + 935)) and v203) then
									return v203;
								end
								break;
							end
						end
					end
					break;
				end
				if (((366 - (326 + 38)) == v211) or ((11661 - 7719) < (1618 - 484))) then
					v203 = v129();
					if (v203 or ((3313 - (47 + 573)) == (1753 + 3220))) then
						return v203;
					end
					if (((9114 - 6968) == (3482 - 1336)) and v121.GreaterPurge:IsAvailable() and v46 and v121.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) then
						if (v23(v121.GreaterPurge, not v14:IsSpellInRange(v121.GreaterPurge)) or ((3908 - (1269 + 395)) == (3716 - (76 + 416)))) then
							return "greater_purge utility";
						end
					end
					if ((v121.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((5347 - (319 + 124)) <= (4379 - 2463))) then
						if (((1097 - (564 + 443)) <= (2948 - 1883)) and v23(v121.Purge, not v14:IsSpellInRange(v121.Purge))) then
							return "purge utility";
						end
					end
					v211 = 461 - (337 + 121);
				end
			end
		end
		if (((14070 - 9268) == (15995 - 11193)) and (v29 or v12:AffectingCombat())) then
			local v212 = 1911 - (1261 + 650);
			while true do
				if ((v212 == (2 + 1)) or ((3633 - 1353) <= (2328 - (772 + 1045)))) then
					if (v33 or ((237 + 1439) <= (607 - (102 + 42)))) then
						if (((5713 - (1524 + 320)) == (5139 - (1049 + 221))) and v125.TargetIsValid()) then
							local v264 = 156 - (18 + 138);
							while true do
								if (((2834 - 1676) <= (3715 - (67 + 1035))) and (v264 == (348 - (136 + 212)))) then
									v203 = v134();
									if (v203 or ((10045 - 7681) <= (1602 + 397))) then
										return v203;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if ((v212 == (1 + 0)) or ((6526 - (240 + 1364)) < (1276 - (1050 + 32)))) then
					if (((v16:HealthPercentage() < v81) and v16:BuffDown(v121.Riptide)) or ((7466 - 5375) < (19 + 12))) then
						if (v121.PrimordialWaveResto:IsCastable() or ((3485 - (331 + 724)) >= (394 + 4478))) then
							if (v23(v122.PrimordialWaveFocus, not v16:IsSpellInRange(v121.PrimordialWaveResto)) or ((5414 - (269 + 375)) < (2460 - (267 + 458)))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v12:GCD() * (1 + 2)))) or ((8536 - 4097) <= (3168 - (667 + 151)))) then
						if (v23(v121.TotemicRecall, nil) or ((5976 - (1410 + 87)) < (6363 - (1504 + 393)))) then
							return "totemic_recall main";
						end
					end
					v212 = 5 - 3;
				end
				if (((6607 - 4060) > (2021 - (461 + 335))) and (v212 == (1 + 1))) then
					if (((6432 - (1730 + 31)) > (4341 - (728 + 939))) and v121.NaturesSwiftness:IsReady() and v121.Riptide:CooldownRemains() and v121.UnleashLife:CooldownRemains()) then
						if (v23(v121.NaturesSwiftness, nil) or ((13089 - 9393) < (6748 - 3421))) then
							return "natures_swiftness main";
						end
					end
					if (v32 or ((10406 - 5864) == (4038 - (138 + 930)))) then
						if (((231 + 21) <= (1546 + 431)) and v14:Exists() and not v12:CanAttack(v14)) then
							local v265 = 0 + 0;
							while true do
								if (((0 - 0) == v265) or ((3202 - (459 + 1307)) == (5645 - (474 + 1396)))) then
									if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v14:BuffDown(v121.Riptide)) or ((2825 - 1207) < (872 + 58))) then
										if (((16 + 4707) > (11895 - 7742)) and (v14:HealthPercentage() <= v82)) then
											if (v23(v121.Riptide, not v16:IsSpellInRange(v121.Riptide)) or ((463 + 3191) >= (15536 - 10882))) then
												return "riptide healing target";
											end
										end
									end
									if (((4147 - 3196) <= (2087 - (562 + 29))) and v104 and v121.UnleashLife:IsReady() and (v14:HealthPercentage() <= v89)) then
										if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((1480 + 256) == (1990 - (374 + 1045)))) then
											return "unleash_life healing target";
										end
									end
									v265 = 1 + 0;
								end
								if ((v265 == (2 - 1)) or ((1534 - (448 + 190)) > (1540 + 3229))) then
									if ((v93 and (v14:HealthPercentage() <= v60) and v121.ChainHeal:IsReady() and (v12:IsInParty() or v12:IsInRaid() or v125.TargetIsValidHealableNpc() or v12:BuffUp(v121.HighTide))) or ((472 + 573) <= (665 + 355))) then
										if (v23(v121.ChainHeal, not v14:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4459 - 3299) <= (1018 - 690))) then
											return "chain_heal healing target";
										end
									end
									if (((5302 - (1307 + 187)) > (11595 - 8671)) and v100 and (v14:HealthPercentage() <= v79) and v121.HealingWave:IsReady()) then
										if (((9110 - 5219) < (15082 - 10163)) and v23(v121.HealingWave, not v14:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
											return "healing_wave healing target";
										end
									end
									break;
								end
							end
						end
						v203 = v132();
						if (v203 or ((2917 - (232 + 451)) <= (1435 + 67))) then
							return v203;
						end
						v203 = v133();
						if (v203 or ((2220 + 292) < (996 - (510 + 54)))) then
							return v203;
						end
					end
					v212 = 5 - 2;
				end
				if ((v212 == (36 - (13 + 23))) or ((3602 - 1754) == (1242 - 377))) then
					if ((v31 and v44) or ((8506 - 3824) <= (5629 - (830 + 258)))) then
						local v262 = 0 - 0;
						while true do
							if ((v262 == (1 + 0)) or ((2575 + 451) >= (5487 - (860 + 581)))) then
								if (((7406 - 5398) > (507 + 131)) and v15 and v15:Exists() and v15:IsAPlayer() and v125.UnitHasDispellableDebuffByPlayer(v15)) then
									if (((2016 - (237 + 4)) <= (7597 - 4364)) and v121.PurifySpirit:IsCastable()) then
										if (v23(v122.PurifySpiritMouseover, not v15:IsSpellInRange(v121.PurifySpirit)) or ((11493 - 6950) == (3785 - 1788))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
							if ((v262 == (0 + 0)) or ((1782 + 1320) < (2748 - 2020))) then
								if (((149 + 196) == (188 + 157)) and (v121.Bursting:MaxDebuffStack() > (1430 - (85 + 1341)))) then
									v28 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
									if (v28 or ((4823 - 1996) < (1067 - 689))) then
										return v28;
									end
								end
								if (v16 or ((3848 - (45 + 327)) < (4899 - 2302))) then
									if (((3581 - (444 + 58)) < (2084 + 2710)) and v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(5 + 20)) then
										local v268 = 0 + 0;
										while true do
											if (((14066 - 9212) > (6196 - (64 + 1668))) and (v268 == (1973 - (1227 + 746)))) then
												if ((v137 == (0 - 0)) or ((9115 - 4203) == (4252 - (415 + 79)))) then
													v137 = GetTime();
												end
												if (((4 + 122) <= (3973 - (142 + 349))) and v125.Wait(215 + 285, v137)) then
													local v269 = 0 - 0;
													while true do
														if (((0 + 0) == v269) or ((1673 + 701) == (11911 - 7537))) then
															if (((3439 - (1710 + 154)) == (1893 - (200 + 118))) and v23(v122.PurifySpiritFocus, not v16:IsSpellInRange(v121.PurifySpirit))) then
																return "purify_spirit dispel focus";
															end
															v137 = 0 + 0;
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								v262 = 1 - 0;
							end
						end
					end
					if ((v121.Bursting:AuraActiveCount() > (4 - 1)) or ((1985 + 249) == (1440 + 15))) then
						local v263 = 0 + 0;
						while true do
							if ((v263 == (0 + 0)) or ((2311 - 1244) > (3029 - (363 + 887)))) then
								if (((3773 - 1612) >= (4445 - 3511)) and (v121.Bursting:MaxDebuffStack() > (1 + 4)) and v121.SpiritLinkTotem:IsReady()) then
									if (((3771 - 2159) == (1102 + 510)) and (v86 == "Player")) then
										if (((6016 - (674 + 990)) >= (813 + 2020)) and v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(17 + 23))) then
											return "spirit_link_totem bursting";
										end
									elseif ((v86 == "Friendly under Cursor") or ((5106 - 1884) < (4128 - (507 + 548)))) then
										if (((1581 - (289 + 548)) <= (4760 - (821 + 997))) and v15:Exists() and not v12:CanAttack(v15)) then
											if (v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(295 - (195 + 60))) or ((493 + 1340) <= (2823 - (251 + 1250)))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif ((v86 == "Confirmation") or ((10156 - 6689) <= (725 + 330))) then
										if (((4573 - (809 + 223)) == (5167 - 1626)) and v23(v121.SpiritLinkTotem, not v14:IsInRange(120 - 80))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v93 and v121.ChainHeal:IsReady()) or ((11761 - 8204) >= (2948 + 1055))) then
									if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal)) or ((345 + 312) >= (2285 - (14 + 603)))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
								break;
							end
						end
					end
					v212 = 130 - (118 + 11);
				end
			end
		end
	end
	local function v139()
		local v204 = 0 + 0;
		while true do
			if ((v204 == (1 + 0)) or ((2992 - 1965) > (4807 - (551 + 398)))) then
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
			if ((v204 == (0 + 0)) or ((1301 + 2353) < (366 + 84))) then
				v127();
				v121.Bursting:RegisterAuraTracking();
				v204 = 3 - 2;
			end
		end
	end
	v21.SetAPL(608 - 344, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

