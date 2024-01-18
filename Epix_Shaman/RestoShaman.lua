local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (748 - (655 + 93))) or ((783 - (36 + 51)) > (11444 - 8790))) then
			v6 = v0[v4];
			if (((876 - 504) <= (488 + 433)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((8594 - 4895) < (1088 + 3618)) and (v5 == (1 + 0))) then
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
	local v114;
	local v115 = 6944 + 4167;
	local v116 = 12207 - (709 + 387);
	local v117;
	v10:RegisterForEvent(function()
		local v136 = 1858 - (673 + 1185);
		while true do
			if (((7673 - 5027) >= (2812 - 1936)) and (v136 == (0 - 0))) then
				v115 = 7948 + 3163;
				v116 = 8303 + 2808;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v118 = v18.Shaman.Restoration;
	local v119 = v25.Shaman.Restoration;
	local v120 = v20.Shaman.Restoration;
	local v121 = {};
	local v122 = v22.Commons.Everyone;
	local v123 = v22.Commons.Shaman;
	local function v124()
		if (((828 - 214) <= (782 + 2402)) and v118.ImprovedPurifySpirit:IsAvailable()) then
			v122.DispellableDebuffs = v21.MergeTable(v122.DispellableMagicDebuffs, v122.DispellableCurseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125(v137)
		return v137:DebuffRefreshable(v118.FlameShockDebuff) and (v116 > (9 - 4));
	end
	local function v126()
		local v138 = 0 - 0;
		while true do
			if (((5006 - (446 + 1434)) == (4409 - (1040 + 243))) and ((2 - 1) == v138)) then
				if ((v120.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((4034 - (559 + 1288)) >= (6885 - (609 + 1322)))) then
					if (v24(v119.Healthstone) or ((4331 - (13 + 441)) == (13359 - 9784))) then
						return "healthstone defensive 3";
					end
				end
				if (((1851 - 1144) > (3147 - 2515)) and v38 and (v13:HealthPercentage() <= v39)) then
					local v236 = 0 + 0;
					while true do
						if ((v236 == (0 - 0)) or ((194 + 352) >= (1177 + 1507))) then
							if (((4347 - 2882) <= (2354 + 1947)) and (v40 == "Refreshing Healing Potion")) then
								if (((3133 - 1429) > (943 + 482)) and v120.RefreshingHealingPotion:IsReady()) then
									if (v24(v119.RefreshingHealingPotion) or ((383 + 304) == (3043 + 1191))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v40 == "Dreamwalker's Healing Potion") or ((2797 + 533) < (1399 + 30))) then
								if (((1580 - (153 + 280)) >= (967 - 632)) and v120.DreamwalkersHealingPotion:IsReady()) then
									if (((3084 + 351) > (828 + 1269)) and v24(v119.RefreshingHealingPotion)) then
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
			if ((v138 == (0 + 0)) or ((3422 + 348) >= (2929 + 1112))) then
				if ((v91 and v118.AstralShift:IsReady()) or ((5772 - 1981) <= (996 + 615))) then
					if ((v13:HealthPercentage() <= v57) or ((5245 - (89 + 578)) <= (1435 + 573))) then
						if (((2338 - 1213) <= (3125 - (572 + 477))) and v24(v118.AstralShift, not v15:IsInRange(6 + 34))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v94 and v118.EarthElemental:IsReady()) or ((446 + 297) >= (526 + 3873))) then
					if (((1241 - (84 + 2)) < (2757 - 1084)) and ((v13:HealthPercentage() <= v65) or v122.IsTankBelowHealthPercentage(v66))) then
						if (v24(v118.EarthElemental, not v15:IsInRange(29 + 11)) or ((3166 - (497 + 345)) <= (15 + 563))) then
							return "earth_elemental defensives";
						end
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v127()
		local v139 = 1333 - (605 + 728);
		while true do
			if (((2688 + 1079) == (8374 - 4607)) and (v139 == (1 + 0))) then
				if (((15117 - 11028) == (3687 + 402)) and v41) then
					v29 = v122.HandleCharredTreant(v118.Riptide, v119.RiptideMouseover, 110 - 70);
					if (((3367 + 1091) >= (2163 - (457 + 32))) and v29) then
						return v29;
					end
					v29 = v122.HandleCharredTreant(v118.ChainHeal, v119.ChainHealMouseover, 17 + 23);
					if (((2374 - (832 + 570)) <= (1336 + 82)) and v29) then
						return v29;
					end
					v29 = v122.HandleCharredTreant(v118.HealingSurge, v119.HealingSurgeMouseover, 11 + 29);
					if (v29 or ((17474 - 12536) < (2294 + 2468))) then
						return v29;
					end
					v29 = v122.HandleCharredTreant(v118.HealingWave, v119.HealingWaveMouseover, 836 - (588 + 208));
					if (v29 or ((6748 - 4244) > (6064 - (884 + 916)))) then
						return v29;
					end
				end
				if (((4507 - 2354) == (1249 + 904)) and v42) then
					v29 = v122.HandleCharredBrambles(v118.Riptide, v119.RiptideMouseover, 693 - (232 + 421));
					if (v29 or ((2396 - (1569 + 320)) >= (636 + 1955))) then
						return v29;
					end
					v29 = v122.HandleCharredBrambles(v118.ChainHeal, v119.ChainHealMouseover, 8 + 32);
					if (((15100 - 10619) == (5086 - (316 + 289))) and v29) then
						return v29;
					end
					v29 = v122.HandleCharredBrambles(v118.HealingSurge, v119.HealingSurgeMouseover, 104 - 64);
					if (v29 or ((108 + 2220) < (2146 - (666 + 787)))) then
						return v29;
					end
					v29 = v122.HandleCharredBrambles(v118.HealingWave, v119.HealingWaveMouseover, 465 - (360 + 65));
					if (((4045 + 283) == (4582 - (79 + 175))) and v29) then
						return v29;
					end
				end
				v139 = 2 - 0;
			end
			if (((1240 + 348) >= (4082 - 2750)) and ((3 - 1) == v139)) then
				if (v43 or ((5073 - (503 + 396)) > (4429 - (92 + 89)))) then
					v29 = v122.HandleFyrakkNPC(v118.Riptide, v119.RiptideMouseover, 77 - 37);
					if (v29 or ((2352 + 2234) <= (49 + 33))) then
						return v29;
					end
					v29 = v122.HandleFyrakkNPC(v118.ChainHeal, v119.ChainHealMouseover, 156 - 116);
					if (((529 + 3334) == (8807 - 4944)) and v29) then
						return v29;
					end
					v29 = v122.HandleFyrakkNPC(v118.HealingSurge, v119.HealingSurgeMouseover, 35 + 5);
					if (v29 or ((135 + 147) <= (127 - 85))) then
						return v29;
					end
					v29 = v122.HandleFyrakkNPC(v118.HealingWave, v119.HealingWaveMouseover, 5 + 35);
					if (((7028 - 2419) >= (2010 - (485 + 759))) and v29) then
						return v29;
					end
				end
				break;
			end
			if ((v139 == (0 - 0)) or ((2341 - (442 + 747)) == (3623 - (832 + 303)))) then
				if (((4368 - (88 + 858)) > (1022 + 2328)) and v112) then
					local v237 = 0 + 0;
					while true do
						if (((37 + 840) > (1165 - (766 + 23))) and (v237 == (0 - 0))) then
							v29 = v122.HandleIncorporeal(v118.Hex, v119.HexMouseOver, 41 - 11, true);
							if (v29 or ((8214 - 5096) <= (6282 - 4431))) then
								return v29;
							end
							break;
						end
					end
				end
				if (v111 or ((1238 - (1036 + 37)) >= (2476 + 1016))) then
					v29 = v122.HandleAfflicted(v118.PurifySpirit, v119.PurifySpiritMouseover, 58 - 28);
					if (((3107 + 842) < (6336 - (641 + 839))) and v29) then
						return v29;
					end
					if (v113 or ((5189 - (910 + 3)) < (7688 - 4672))) then
						local v246 = 1684 - (1466 + 218);
						while true do
							if (((2156 + 2534) > (5273 - (556 + 592))) and (v246 == (0 + 0))) then
								v29 = v122.HandleAfflicted(v118.TremorTotem, v118.TremorTotem, 838 - (329 + 479));
								if (v29 or ((904 - (174 + 680)) >= (3078 - 2182))) then
									return v29;
								end
								break;
							end
						end
					end
					if (v114 or ((3552 - 1838) >= (2112 + 846))) then
						local v247 = 739 - (396 + 343);
						while true do
							if ((v247 == (0 + 0)) or ((2968 - (29 + 1448)) < (2033 - (135 + 1254)))) then
								v29 = v122.HandleAfflicted(v118.PoisonCleansingTotem, v118.PoisonCleansingTotem, 113 - 83);
								if (((3287 - 2583) < (658 + 329)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v139 = 1528 - (389 + 1138);
			end
		end
	end
	local function v128()
		local v140 = 574 - (102 + 472);
		while true do
			if (((3509 + 209) > (1057 + 849)) and (v140 == (1 + 0))) then
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((2503 - (320 + 1225)) > (6470 - 2835))) then
					if (((2143 + 1358) <= (5956 - (157 + 1307))) and (v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((5301 - (821 + 1038)) < (6357 - 3809))) then
							return "riptide healingcd";
						end
					end
				end
				if (((315 + 2560) >= (2600 - 1136)) and v122.AreUnitsBelowHealthPercentage(v84, v83) and v118.SpiritLinkTotem:IsReady()) then
					if ((v85 == "Player") or ((1785 + 3012) >= (12127 - 7234))) then
						if (v24(v119.SpiritLinkTotemPlayer, not v15:IsInRange(1066 - (834 + 192))) or ((36 + 515) > (531 + 1537))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((46 + 2068) > (1461 - 517)) and (v85 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2566 - (300 + 4)) >= (827 + 2269))) then
							if (v24(v119.SpiritLinkTotemCursor, not v15:IsInRange(104 - 64)) or ((2617 - (112 + 250)) >= (1411 + 2126))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v85 == "Confirmation") or ((9612 - 5775) < (749 + 557))) then
						if (((1526 + 1424) == (2207 + 743)) and v24(v118.SpiritLinkTotem, not v15:IsInRange(20 + 20))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v140 = 2 + 0;
			end
			if ((v140 == (1416 - (1001 + 413))) or ((10531 - 5808) < (4180 - (244 + 638)))) then
				if (((1829 - (627 + 66)) >= (458 - 304)) and v98 and v122.AreUnitsBelowHealthPercentage(v77, v76) and v118.HealingTideTotem:IsReady()) then
					if (v24(v118.HealingTideTotem, not v15:IsInRange(642 - (512 + 90))) or ((2177 - (1665 + 241)) > (5465 - (373 + 344)))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((2138 + 2602) >= (834 + 2318)) and v122.AreUnitsBelowHealthPercentage(v53, v52) and v118.AncestralProtectionTotem:IsReady()) then
					if ((v54 == "Player") or ((6799 - 4221) >= (5736 - 2346))) then
						if (((1140 - (35 + 1064)) <= (1209 + 452)) and v24(v119.AncestralProtectionTotemPlayer, not v15:IsInRange(85 - 45))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((3 + 598) < (4796 - (298 + 938))) and (v54 == "Friendly under Cursor")) then
						if (((1494 - (233 + 1026)) < (2353 - (636 + 1030))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((2326 + 2223) > (1127 + 26)) and v24(v119.AncestralProtectionTotemCursor, not v15:IsInRange(12 + 28))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v54 == "Confirmation") or ((316 + 4358) < (4893 - (55 + 166)))) then
						if (((711 + 2957) < (459 + 4102)) and v24(v118.AncestralProtectionTotem, not v15:IsInRange(152 - 112))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v140 = 300 - (36 + 261);
			end
			if ((v140 == (4 - 1)) or ((1823 - (34 + 1334)) == (1386 + 2219))) then
				if ((v89 and v122.AreUnitsBelowHealthPercentage(v51, v50) and v118.AncestralGuidance:IsReady()) or ((2070 + 593) == (4595 - (1035 + 248)))) then
					if (((4298 - (20 + 1)) <= (2332 + 2143)) and v24(v118.AncestralGuidance, not v15:IsInRange(359 - (134 + 185)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v90 and v122.AreUnitsBelowHealthPercentage(v56, v55) and v118.Ascendance:IsReady()) or ((2003 - (549 + 584)) == (1874 - (314 + 371)))) then
					if (((5331 - 3778) <= (4101 - (478 + 490))) and v24(v118.Ascendance, not v15:IsInRange(22 + 18))) then
						return "ascendance cooldowns";
					end
				end
				v140 = 1176 - (786 + 386);
			end
			if ((v140 == (12 - 8)) or ((3616 - (1055 + 324)) >= (4851 - (1093 + 247)))) then
				if ((v100 and (v13:ManaPercentage() <= v79) and v118.ManaTideTotem:IsReady()) or ((1177 + 147) > (318 + 2702))) then
					if (v24(v118.ManaTideTotem, not v15:IsInRange(158 - 118)) or ((10153 - 7161) == (5352 - 3471))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((7805 - 4699) > (543 + 983)) and v35 and ((v107 and v31) or not v107)) then
					local v238 = 0 - 0;
					while true do
						if (((10419 - 7396) < (2919 + 951)) and (v238 == (4 - 2))) then
							if (((831 - (364 + 324)) > (202 - 128)) and v118.Fireblood:IsReady()) then
								if (((43 - 25) < (700 + 1412)) and v24(v118.Fireblood, not v15:IsInRange(167 - 127))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((1756 - 659) <= (4944 - 3316)) and (v238 == (1268 - (1249 + 19)))) then
							if (((4180 + 450) == (18022 - 13392)) and v118.AncestralCall:IsReady()) then
								if (((4626 - (686 + 400)) > (2106 + 577)) and v24(v118.AncestralCall, not v15:IsInRange(269 - (73 + 156)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((23 + 4771) >= (4086 - (721 + 90))) and v118.BagofTricks:IsReady()) then
								if (((17 + 1467) == (4818 - 3334)) and v24(v118.BagofTricks, not v15:IsInRange(510 - (224 + 246)))) then
									return "BagofTricks cooldowns";
								end
							end
							v238 = 1 - 0;
						end
						if (((2636 - 1204) < (645 + 2910)) and (v238 == (1 + 0))) then
							if (v118.Berserking:IsReady() or ((783 + 282) > (7113 - 3535))) then
								if (v24(v118.Berserking, not v15:IsInRange(133 - 93)) or ((5308 - (203 + 310)) < (3400 - (1238 + 755)))) then
									return "Berserking cooldowns";
								end
							end
							if (((130 + 1723) < (6347 - (709 + 825))) and v118.BloodFury:IsReady()) then
								if (v24(v118.BloodFury, not v15:IsInRange(73 - 33)) or ((4109 - 1288) < (3295 - (196 + 668)))) then
									return "BloodFury cooldowns";
								end
							end
							v238 = 7 - 5;
						end
					end
				end
				break;
			end
			if ((v140 == (0 - 0)) or ((3707 - (171 + 662)) < (2274 - (4 + 89)))) then
				if ((v109 and ((v31 and v108) or not v108)) or ((9424 - 6735) <= (125 + 218))) then
					local v239 = 0 - 0;
					while true do
						if ((v239 == (1 + 0)) or ((3355 - (35 + 1451)) == (3462 - (28 + 1425)))) then
							v29 = v122.HandleBottomTrinket(v121, v31, 2033 - (941 + 1052), nil);
							if (v29 or ((3401 + 145) < (3836 - (822 + 692)))) then
								return v29;
							end
							break;
						end
						if ((v239 == (0 - 0)) or ((981 + 1101) == (5070 - (45 + 252)))) then
							v29 = v122.HandleTopTrinket(v121, v31, 40 + 0, nil);
							if (((1117 + 2127) > (2567 - 1512)) and v29) then
								return v29;
							end
							v239 = 434 - (114 + 319);
						end
					end
				end
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((4755 - 1442) <= (2277 - 499))) then
					if ((v17:HealthPercentage() <= v81) or ((906 + 515) >= (3134 - 1030))) then
						if (((3796 - 1984) <= (5212 - (556 + 1407))) and v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v140 = 1207 - (741 + 465);
			end
		end
	end
	local function v129()
		local v141 = 465 - (170 + 295);
		while true do
			if (((856 + 767) <= (1798 + 159)) and (v141 == (0 - 0))) then
				if (((3658 + 754) == (2830 + 1582)) and v92 and v122.AreUnitsBelowHealthPercentage(54 + 41, 1233 - (957 + 273)) and v118.ChainHeal:IsReady() and v13:BuffUp(v118.HighTide)) then
					if (((469 + 1281) >= (338 + 504)) and v24(v119.ChainHealFocus, not v17:IsSpellInRange(v118.ChainHeal), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((16659 - 12287) > (4875 - 3025)) and v99 and (v17:HealthPercentage() <= v78) and v118.HealingWave:IsReady() and (v118.PrimordialWaveResto:TimeSinceLastCast() < (45 - 30))) then
					if (((1148 - 916) < (2601 - (389 + 1391))) and v24(v119.HealingWaveFocus, not v17:IsSpellInRange(v118.HealingWave), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((325 + 193) < (94 + 808)) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
					if (((6815 - 3821) > (1809 - (783 + 168))) and (v17:HealthPercentage() <= v81)) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((12602 - 8847) <= (901 + 14))) then
							return "riptide healingaoe";
						end
					end
				end
				v141 = 312 - (309 + 2);
			end
			if (((12117 - 8171) > (4955 - (1090 + 122))) and (v141 == (1 + 2))) then
				if ((v93 and v122.AreUnitsBelowHealthPercentage(v61, v60) and v118.CloudburstTotem:IsReady()) or ((4483 - 3148) >= (2263 + 1043))) then
					if (((5962 - (628 + 490)) > (404 + 1849)) and v24(v118.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((1118 - 666) == (2065 - 1613)) and v104 and v122.AreUnitsBelowHealthPercentage(v106, v105) and v118.Wellspring:IsReady()) then
					if (v24(v118.Wellspring, not v15:IsInRange(814 - (431 + 343)), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((9202 - 4645) < (6037 - 3950))) then
						return "wellspring healingaoe";
					end
				end
				if (((3061 + 813) == (496 + 3378)) and v92 and v122.AreUnitsBelowHealthPercentage(v59, v58) and v118.ChainHeal:IsReady()) then
					if (v24(v119.ChainHealFocus, not v17:IsSpellInRange(v118.ChainHeal), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((3633 - (556 + 1139)) > (4950 - (6 + 9)))) then
						return "chain_heal healingaoe";
					end
				end
				v141 = 1 + 3;
			end
			if ((v141 == (3 + 1)) or ((4424 - (28 + 141)) < (1326 + 2097))) then
				if (((1793 - 339) <= (1765 + 726)) and v102 and v13:IsMoving() and v122.AreUnitsBelowHealthPercentage(v87, v86) and v118.SpiritwalkersGrace:IsReady()) then
					if (v24(v118.SpiritwalkersGrace, nil) or ((5474 - (486 + 831)) <= (7293 - 4490))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((17085 - 12232) >= (564 + 2418)) and v96 and v122.AreUnitsBelowHealthPercentage(v74, v73) and v118.HealingStreamTotem:IsReady()) then
					if (((13071 - 8937) > (4620 - (668 + 595))) and v24(v118.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v141 == (1 + 0)) or ((689 + 2728) < (6910 - 4376))) then
				if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((3012 - (23 + 267)) <= (2108 - (1129 + 815)))) then
					if (((v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) or ((2795 - (371 + 16)) < (3859 - (1326 + 424)))) then
						if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((61 - 28) == (5316 - 3861))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v103 and v118.UnleashLife:IsReady()) or ((561 - (88 + 30)) >= (4786 - (720 + 51)))) then
					if (((7523 - 4141) > (1942 - (421 + 1355))) and (v17:HealthPercentage() <= v88)) then
						if (v24(v118.UnleashLife, not v17:IsSpellInRange(v118.UnleashLife)) or ((461 - 181) == (1503 + 1556))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((2964 - (286 + 797)) > (4726 - 3433)) and (v72 == "Cursor") and v118.HealingRain:IsReady()) then
					if (((3903 - 1546) == (2796 - (397 + 42))) and v24(v119.HealingRainCursor, not v15:IsInRange(13 + 27), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v141 = 802 - (24 + 776);
			end
			if (((189 - 66) == (908 - (222 + 563))) and (v141 == (3 - 1))) then
				if ((v122.AreUnitsBelowHealthPercentage(v71, v70) and v118.HealingRain:IsReady()) or ((761 + 295) >= (3582 - (23 + 167)))) then
					if ((v72 == "Player") or ((2879 - (690 + 1108)) < (388 + 687))) then
						if (v24(v119.HealingRainPlayer, not v15:IsInRange(33 + 7), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1897 - (40 + 808)) >= (730 + 3702))) then
							return "healing_rain healingaoe";
						end
					elseif ((v72 == "Friendly under Cursor") or ((18232 - 13464) <= (809 + 37))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1777 + 1581) <= (779 + 641))) then
							if (v24(v119.HealingRainCursor, not v15:IsInRange(611 - (47 + 524)), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2427 + 1312) <= (8214 - 5209))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Enemy under Cursor") or ((2480 - 821) >= (4866 - 2732))) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((4986 - (1165 + 561)) < (70 + 2285))) then
							if (v24(v119.HealingRainCursor, not v15:IsInRange(123 - 83), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((256 + 413) == (4702 - (341 + 138)))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Confirmation") or ((457 + 1235) < (1213 - 625))) then
						if (v24(v118.HealingRain, not v15:IsInRange(366 - (89 + 237)), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((15431 - 10634) < (7686 - 4035))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v68, v67) and v118.EarthenWallTotem:IsReady()) or ((5058 - (581 + 300)) > (6070 - (855 + 365)))) then
					if ((v69 == "Player") or ((950 - 550) > (363 + 748))) then
						if (((4286 - (1030 + 205)) > (944 + 61)) and v24(v119.EarthenWallTotemPlayer, not v15:IsInRange(38 + 2))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((3979 - (156 + 130)) <= (9956 - 5574)) and (v69 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((5530 - 2248) > (8397 - 4297))) then
							if (v24(v119.EarthenWallTotemCursor, not v15:IsInRange(11 + 29)) or ((2088 + 1492) < (2913 - (10 + 59)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((26 + 63) < (22112 - 17622)) and (v69 == "Confirmation")) then
						if (v24(v118.EarthenWallTotem, not v15:IsInRange(1203 - (671 + 492))) or ((3967 + 1016) < (3023 - (369 + 846)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((1014 + 2815) > (3217 + 552)) and v122.AreUnitsBelowHealthPercentage(v63, v62) and v118.Downpour:IsReady()) then
					if (((3430 - (1036 + 909)) <= (2309 + 595)) and (v64 == "Player")) then
						if (((7166 - 2897) == (4472 - (11 + 192))) and v24(v119.DownpourPlayer, not v15:IsInRange(21 + 19), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif (((562 - (135 + 40)) <= (6740 - 3958)) and (v64 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1145 + 754) <= (2020 - 1103))) then
							if (v24(v119.DownpourCursor, not v15:IsInRange(59 - 19), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4488 - (50 + 126)) <= (2439 - 1563))) then
								return "downpour healingaoe";
							end
						end
					elseif (((495 + 1737) <= (4009 - (1233 + 180))) and (v64 == "Confirmation")) then
						if (((3064 - (522 + 447)) < (5107 - (107 + 1314))) and v24(v118.Downpour, not v15:IsInRange(19 + 21), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				v141 = 8 - 5;
			end
		end
	end
	local function v130()
		if ((v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((678 + 917) >= (8884 - 4410))) then
			if ((v17:HealthPercentage() <= v81) or ((18275 - 13656) < (4792 - (716 + 1194)))) then
				if (v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide)) or ((6 + 288) >= (518 + 4313))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((2532 - (74 + 429)) <= (5948 - 2864)) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
			if (((v17:HealthPercentage() <= v82) and (v122.UnitGroupRole(v17) == "TANK")) or ((1010 + 1027) == (5539 - 3119))) then
				if (((3154 + 1304) > (12035 - 8131)) and v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((1077 - 641) >= (556 - (279 + 154))) and v101 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
			if (((1278 - (454 + 324)) < (1429 + 387)) and ((v17:HealthPercentage() <= v81) or (v17:HealthPercentage() <= v81))) then
				if (((3591 - (12 + 5)) == (1927 + 1647)) and v24(v119.RiptideFocus, not v17:IsSpellInRange(v118.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((562 - 341) < (145 + 245)) and v118.ElementalOrbit:IsAvailable() and v13:BuffDown(v118.EarthShieldBuff)) then
			if (v24(v118.EarthShield) or ((3306 - (277 + 816)) <= (6072 - 4651))) then
				return "earth_shield healingst";
			end
		end
		if (((4241 - (1058 + 125)) < (912 + 3948)) and v118.ElementalOrbit:IsAvailable() and v13:BuffUp(v118.EarthShieldBuff)) then
			if (v122.IsSoloMode() or ((2271 - (815 + 160)) >= (19076 - 14630))) then
				if ((v118.LightningShield:IsReady() and v13:BuffDown(v118.LightningShield)) or ((3306 - 1913) > (1071 + 3418))) then
					if (v24(v118.LightningShield) or ((12931 - 8507) < (1925 - (41 + 1857)))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v118.WaterShield:IsReady() and v13:BuffDown(v118.WaterShield)) or ((3890 - (1222 + 671)) > (9860 - 6045))) then
				if (((4980 - 1515) > (3095 - (229 + 953))) and v24(v118.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if (((2507 - (1111 + 663)) < (3398 - (874 + 705))) and v97 and v118.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v75) or ((616 + 3779) == (3245 + 1510))) then
				if (v24(v119.HealingSurgeFocus, not v17:IsSpellInRange(v118.HealingSurge), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((7884 - 4091) < (67 + 2302))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v99 and v118.HealingWave:IsReady()) or ((4763 - (642 + 37)) == (61 + 204))) then
			if (((698 + 3660) == (10941 - 6583)) and (v17:HealthPercentage() <= v78)) then
				if (v24(v119.HealingWaveFocus, not v17:IsSpellInRange(v118.HealingWave), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((3592 - (233 + 221)) < (2296 - 1303))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v131()
		local v142 = 0 + 0;
		while true do
			if (((4871 - (718 + 823)) > (1462 + 861)) and (v142 == (805 - (266 + 539)))) then
				if (v118.Stormkeeper:IsReady() or ((10265 - 6639) == (5214 - (636 + 589)))) then
					if (v24(v118.Stormkeeper, not v15:IsInRange(94 - 54)) or ((1888 - 972) == (2117 + 554))) then
						return "stormkeeper damage";
					end
				end
				if (((99 + 173) == (1287 - (657 + 358))) and (#v13:GetEnemiesInRange(105 - 65) > (2 - 1))) then
					if (((5436 - (1151 + 36)) <= (4673 + 166)) and v118.ChainLightning:IsReady()) then
						if (((731 + 2046) < (9556 - 6356)) and v24(v118.ChainLightning, not v15:IsSpellInRange(v118.ChainLightning), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v142 = 1833 - (1552 + 280);
			end
			if (((929 - (64 + 770)) < (1329 + 628)) and (v142 == (2 - 1))) then
				if (((147 + 679) < (2960 - (157 + 1086))) and v118.FlameShock:IsReady()) then
					local v240 = 0 - 0;
					while true do
						if (((6245 - 4819) >= (1694 - 589)) and (v240 == (0 - 0))) then
							if (((3573 - (599 + 220)) <= (6728 - 3349)) and v122.CastCycle(v118.FlameShock, v13:GetEnemiesInRange(1971 - (1813 + 118)), v125, not v15:IsSpellInRange(v118.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v24(v118.FlameShock, not v15:IsSpellInRange(v118.FlameShock)) or ((2871 + 1056) == (2630 - (841 + 376)))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v118.LavaBurst:IsReady() or ((1616 - 462) <= (184 + 604))) then
					if (v24(v118.LavaBurst, not v15:IsSpellInRange(v118.LavaBurst), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4484 - 2841) > (4238 - (464 + 395)))) then
						return "lava_burst damage";
					end
				end
				v142 = 5 - 3;
			end
			if ((v142 == (1 + 1)) or ((3640 - (467 + 370)) > (9400 - 4851))) then
				if (v118.LightningBolt:IsReady() or ((162 + 58) >= (10359 - 7337))) then
					if (((441 + 2381) == (6565 - 3743)) and v24(v118.LightningBolt, not v15:IsSpellInRange(v118.LightningBolt), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v143 = 520 - (150 + 370);
		while true do
			if ((v143 == (1289 - (74 + 1208))) or ((2609 - 1548) == (8806 - 6949))) then
				v98 = EpicSettings.Settings['UseHealingTideTotem'];
				v99 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v46 = EpicSettings.Settings['UsePurgeTarget'];
				v101 = EpicSettings.Settings['UseRiptide'];
				v102 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v143 = 6 + 2;
			end
			if (((3150 - (14 + 376)) > (2365 - 1001)) and (v143 == (4 + 2))) then
				v92 = EpicSettings.Settings['UseChainHeal'];
				v93 = EpicSettings.Settings['UseCloudburstTotem'];
				v95 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v96 = EpicSettings.Settings['UseHealingStreamTotem'];
				v97 = EpicSettings.Settings['UseHealingSurge'];
				v143 = 7 + 0;
			end
			if ((v143 == (4 + 0)) or ((14363 - 9461) <= (2705 + 890))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['RiptideHP'];
				v82 = EpicSettings.Settings['RiptideTankHP'];
				v143 = 83 - (23 + 55);
			end
			if ((v143 == (11 - 6)) or ((2571 + 1281) == (264 + 29))) then
				v83 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v84 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v85 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v86 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v88 = EpicSettings.Settings['UnleashLifeHP'];
				v143 = 9 - 3;
			end
			if ((v143 == (3 + 5)) or ((2460 - (652 + 249)) == (12278 - 7690))) then
				v103 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if ((v143 == (1871 - (708 + 1160))) or ((12171 - 7687) == (1436 - 648))) then
				v73 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v74 = EpicSettings.Settings['HealingStreamTotemHP'];
				v75 = EpicSettings.Settings['HealingSurgeHP'];
				v76 = EpicSettings.Settings['HealingTideTotemGroup'];
				v77 = EpicSettings.Settings['HealingTideTotemHP'];
				v78 = EpicSettings.Settings['HealingWaveHP'];
				v143 = 31 - (10 + 17);
			end
			if (((1026 + 3542) >= (5639 - (1400 + 332))) and (v143 == (3 - 1))) then
				v69 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v70 = EpicSettings.Settings['HealingRainGroup'];
				v71 = EpicSettings.Settings['HealingRainHP'];
				v72 = EpicSettings.Settings['HealingRainUsage'];
				v143 = 1911 - (242 + 1666);
			end
			if (((534 + 712) < (1272 + 2198)) and (v143 == (0 + 0))) then
				v52 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v53 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v58 = EpicSettings.Settings['ChainHealGroup'];
				v59 = EpicSettings.Settings['ChainHealHP'];
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v143 = 941 - (850 + 90);
			end
			if (((7124 - 3056) >= (2362 - (360 + 1030))) and (v143 == (1 + 0))) then
				v45 = EpicSettings.Settings['DispelBuffs'];
				v62 = EpicSettings.Settings['DownpourGroup'];
				v63 = EpicSettings.Settings['DownpourHP'];
				v64 = EpicSettings.Settings['DownpourUsage'];
				v67 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v68 = EpicSettings.Settings['EarthenWallTotemHP'];
				v143 = 5 - 3;
			end
		end
	end
	local function v133()
		v50 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v51 = EpicSettings.Settings['AncestralGuidanceHP'];
		v55 = EpicSettings.Settings['AscendanceGroup'];
		v56 = EpicSettings.Settings['AscendanceHP'];
		v57 = EpicSettings.Settings['AstralShiftHP'];
		v60 = EpicSettings.Settings['CloudburstTotemGroup'];
		v61 = EpicSettings.Settings['CloudburstTotemHP'];
		v65 = EpicSettings.Settings['EarthElementalHP'];
		v66 = EpicSettings.Settings['EarthElementalTankHP'];
		v79 = EpicSettings.Settings['ManaTideTotemMana'];
		v80 = EpicSettings.Settings['PrimordialWaveHP'];
		v89 = EpicSettings.Settings['UseAncestralGuidance'];
		v90 = EpicSettings.Settings['UseAscendance'];
		v91 = EpicSettings.Settings['UseAstralShift'];
		v94 = EpicSettings.Settings['UseEarthElemental'];
		v100 = EpicSettings.Settings['UseManaTideTotem'];
		v104 = EpicSettings.Settings['UseWellspring'];
		v105 = EpicSettings.Settings['WellspringGroup'];
		v106 = EpicSettings.Settings['WellspringHP'];
		v107 = EpicSettings.Settings['racialsWithCD'];
		v35 = EpicSettings.Settings['useRacials'];
		v108 = EpicSettings.Settings['trinketsWithCD'];
		v109 = EpicSettings.Settings['useTrinkets'];
		v110 = EpicSettings.Settings['fightRemainsCheck'];
		v111 = EpicSettings.Settings['handleAfflicted'];
		v112 = EpicSettings.Settings['HandleIncorporeal'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v43 = EpicSettings.Settings['HandleFyrakkNPC'];
		v113 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v114 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v134()
		local v175 = 0 - 0;
		local v176;
		while true do
			if (((2154 - (909 + 752)) < (5116 - (109 + 1114))) and (v175 == (0 - 0))) then
				v132();
				v133();
				v30 = EpicSettings.Toggles['ooc'];
				v175 = 1 + 0;
			end
			if ((v175 == (243 - (6 + 236))) or ((929 + 544) >= (2682 + 650))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v175 = 4 - 2;
			end
			if ((v175 == (6 - 2)) or ((5184 - (1076 + 57)) <= (191 + 966))) then
				if (((1293 - (579 + 110)) < (228 + 2653)) and (v13:AffectingCombat() or v30)) then
					local v241 = 0 + 0;
					local v242;
					while true do
						if ((v241 == (1 + 0)) or ((1307 - (174 + 233)) == (9432 - 6055))) then
							if (((7825 - 3366) > (263 + 328)) and (not v17:BuffDown(v118.EarthShield) or (v122.UnitGroupRole(v17) ~= "TANK") or not v95 or (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 1199 - (663 + 511)) >= (1 + 0)))) then
								local v250 = 0 + 0;
								while true do
									if (((10475 - 7077) >= (1451 + 944)) and (v250 == (0 - 0))) then
										v29 = v122.FocusUnit(v242, nil, nil, nil);
										if (v29 or ((5284 - 3101) >= (1348 + 1476))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((3768 - 1832) == (1380 + 556)) and (v241 == (0 + 0))) then
							v242 = v44 and v118.PurifySpirit:IsReady() and v32;
							if ((v118.EarthShield:IsReady() and v95 and (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 747 - (478 + 244)) < (518 - (440 + 77)))) or ((2197 + 2635) < (15785 - 11472))) then
								v29 = v122.FocusUnitRefreshableBuff(v118.EarthShield, 1571 - (655 + 901), 8 + 32, "TANK", true, 20 + 5);
								if (((2761 + 1327) > (15606 - 11732)) and v29) then
									return v29;
								end
								if (((5777 - (695 + 750)) == (14792 - 10460)) and (v122.UnitGroupRole(v17) == "TANK")) then
									if (((6170 - 2171) >= (11663 - 8763)) and v24(v119.EarthShieldFocus, not v17:IsSpellInRange(v118.EarthShield))) then
										return "earth_shield_tank main apl";
									end
								end
							end
							v241 = 352 - (285 + 66);
						end
					end
				end
				if ((v118.EarthShield:IsCastable() and v95 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(93 - 53) and (v122.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v118.EarthShield))) or ((3835 - (682 + 628)) > (656 + 3408))) then
					if (((4670 - (176 + 123)) == (1829 + 2542)) and v24(v119.EarthShieldFocus, not v17:IsSpellInRange(v118.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				if (not v13:AffectingCombat() or ((193 + 73) > (5255 - (239 + 30)))) then
					if (((542 + 1449) >= (890 + 35)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v248 = 0 - 0;
						local v249;
						while true do
							if (((1419 - 964) < (2368 - (306 + 9))) and (v248 == (0 - 0))) then
								v249 = v122.DeadFriendlyUnitsCount();
								if ((v249 > (1 + 0)) or ((507 + 319) == (2335 + 2516))) then
									if (((523 - 340) == (1558 - (1140 + 235))) and v24(v118.AncestralVision, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (((738 + 421) <= (1640 + 148)) and v24(v119.AncestralSpiritMouseover, not v15:IsInRange(11 + 29), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v175 = 57 - (33 + 19);
			end
			if ((v175 == (2 + 1)) or ((10511 - 7004) > (1903 + 2415))) then
				if (v122.TargetIsValid() or v13:AffectingCombat() or ((6030 - 2955) <= (2781 + 184))) then
					local v243 = 689 - (586 + 103);
					while true do
						if (((125 + 1240) <= (6191 - 4180)) and ((1488 - (1309 + 179)) == v243)) then
							v117 = v13:GetEnemiesInRange(72 - 32);
							v115 = v10.BossFightRemains(nil, true);
							v243 = 1 + 0;
						end
						if ((v243 == (2 - 1)) or ((2097 + 679) > (7595 - 4020))) then
							v116 = v115;
							if ((v116 == (22140 - 11029)) or ((3163 - (295 + 314)) == (11799 - 6995))) then
								v116 = v10.FightRemains(v117, false);
							end
							break;
						end
					end
				end
				v176 = v127();
				if (((4539 - (1300 + 662)) == (8092 - 5515)) and v176) then
					return v176;
				end
				v175 = 1759 - (1178 + 577);
			end
			if ((v175 == (3 + 2)) or ((17 - 11) >= (3294 - (851 + 554)))) then
				if (((448 + 58) <= (5246 - 3354)) and v13:AffectingCombat() and v122.TargetIsValid()) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (302 - (115 + 187))) or ((1538 + 470) > (2100 + 118))) then
							v29 = v122.Interrupt(v118.WindShear, 118 - 88, true);
							if (((1540 - (160 + 1001)) <= (3628 + 519)) and v29) then
								return v29;
							end
							v29 = v122.InterruptCursor(v118.WindShear, v119.WindShearMouseover, 21 + 9, true, v16);
							v244 = 1 - 0;
						end
						if ((v244 == (359 - (237 + 121))) or ((5411 - (525 + 372)) <= (1912 - 903))) then
							if (v29 or ((11486 - 7990) == (1334 - (96 + 46)))) then
								return v29;
							end
							v29 = v122.InterruptWithStunCursor(v118.CapacitorTotem, v119.CapacitorTotemCursor, 807 - (643 + 134), nil, v16);
							if (v29 or ((76 + 132) == (7094 - 4135))) then
								return v29;
							end
							v244 = 7 - 5;
						end
						if (((4102 + 175) >= (2576 - 1263)) and (v244 == (3 - 1))) then
							v176 = v126();
							if (((3306 - (316 + 403)) < (2110 + 1064)) and v176) then
								return v176;
							end
							if ((v118.GreaterPurge:IsAvailable() and v46 and v118.GreaterPurge:IsReady() and v32 and v45 and not v13:IsCasting() and not v13:IsChanneling() and v122.UnitHasMagicBuff(v15)) or ((11327 - 7207) <= (795 + 1403))) then
								if (v24(v118.GreaterPurge, not v15:IsSpellInRange(v118.GreaterPurge)) or ((4019 - 2423) == (609 + 249))) then
									return "greater_purge utility";
								end
							end
							v244 = 1 + 2;
						end
						if (((11157 - 7937) == (15378 - 12158)) and ((5 - 2) == v244)) then
							if ((v118.Purge:IsReady() and v46 and v32 and v45 and not v13:IsCasting() and not v13:IsChanneling() and v122.UnitHasMagicBuff(v15)) or ((81 + 1321) > (7126 - 3506))) then
								if (((126 + 2448) == (7572 - 4998)) and v24(v118.Purge, not v15:IsSpellInRange(v118.Purge))) then
									return "purge utility";
								end
							end
							if (((1815 - (12 + 5)) < (10708 - 7951)) and (v116 > v110)) then
								local v251 = 0 - 0;
								while true do
									if ((v251 == (0 - 0)) or ((934 - 557) > (529 + 2075))) then
										v176 = v128();
										if (((2541 - (1656 + 317)) < (812 + 99)) and v176) then
											return v176;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((2633 + 652) < (11242 - 7014)) and (v30 or v13:AffectingCombat())) then
					local v245 = 0 - 0;
					while true do
						if (((4270 - (5 + 349)) > (15807 - 12479)) and (v245 == (1271 - (266 + 1005)))) then
							if (((1648 + 852) < (13098 - 9259)) and v32 and v44) then
								local v252 = 0 - 0;
								while true do
									if (((2203 - (561 + 1135)) == (660 - 153)) and (v252 == (0 - 0))) then
										if (((1306 - (507 + 559)) <= (7942 - 4777)) and v17) then
											if (((2579 - 1745) >= (1193 - (212 + 176))) and v118.PurifySpirit:IsReady() and v122.DispellableFriendlyUnit(930 - (250 + 655))) then
												if (v24(v119.PurifySpiritFocus, not v17:IsSpellInRange(v118.PurifySpirit)) or ((10394 - 6582) < (4046 - 1730))) then
													return "purify_spirit dispel focus";
												end
											end
										end
										if ((v16 and v16:Exists() and v16:IsAPlayer() and (v122.UnitHasMagicDebuff(v16) or (v122.UnitHasCurseDebuff(v16) and v118.ImprovedPurifySpirit:IsAvailable()))) or ((4148 - 1496) <= (3489 - (1869 + 87)))) then
											if (v118.PurifySpirit:IsReady() or ((12479 - 8881) < (3361 - (484 + 1417)))) then
												if (v24(v119.PurifySpiritMouseover, not v16:IsSpellInRange(v118.PurifySpirit)) or ((8822 - 4706) < (1997 - 805))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							if (((v17:HealthPercentage() < v80) and v17:BuffDown(v118.Riptide)) or ((4150 - (48 + 725)) <= (1474 - 571))) then
								if (((10666 - 6690) >= (256 + 183)) and v118.PrimordialWaveResto:IsCastable()) then
									if (((10026 - 6274) == (1051 + 2701)) and v24(v119.PrimordialWaveFocus, not v17:IsSpellInRange(v118.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							v245 = 1 + 0;
						end
						if (((4899 - (152 + 701)) > (4006 - (430 + 881))) and (v245 == (1 + 0))) then
							if (v33 or ((4440 - (557 + 338)) == (945 + 2252))) then
								local v253 = 0 - 0;
								while true do
									if (((8383 - 5989) > (990 - 617)) and (v253 == (2 - 1))) then
										v176 = v130();
										if (((4956 - (499 + 302)) <= (5098 - (39 + 827))) and v176) then
											return v176;
										end
										break;
									end
									if (((0 - 0) == v253) or ((7997 - 4416) == (13794 - 10321))) then
										v176 = v129();
										if (((7668 - 2673) > (287 + 3061)) and v176) then
											return v176;
										end
										v253 = 2 - 1;
									end
								end
							end
							if (v34 or ((121 + 633) > (5892 - 2168))) then
								if (((321 - (103 + 1)) >= (611 - (475 + 79))) and v122.TargetIsValid()) then
									local v254 = 0 - 0;
									while true do
										if ((v254 == (0 - 0)) or ((268 + 1802) >= (3553 + 484))) then
											v176 = v131();
											if (((4208 - (1395 + 108)) == (7871 - 5166)) and v176) then
												return v176;
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
			if (((1265 - (7 + 1197)) == (27 + 34)) and (v175 == (1 + 1))) then
				v34 = EpicSettings.Toggles['dps'];
				v176 = nil;
				if (v13:IsDeadOrGhost() or ((1018 - (27 + 292)) >= (3797 - 2501))) then
					return;
				end
				v175 = 3 - 0;
			end
		end
	end
	local function v135()
		local v177 = 0 - 0;
		while true do
			if (((0 - 0) == v177) or ((3395 - 1612) >= (3755 - (43 + 96)))) then
				v124();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1076 - 812, v134, v135);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

