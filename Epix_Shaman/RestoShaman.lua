local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1703 + 951) < (4336 - 2302))) then
			return v6(...);
		end
		if (((1346 - (360 + 65)) < (1030 + 72)) and (v5 == (254 - (79 + 175)))) then
			v6 = v0[v4];
			if (((7420 - 2714) >= (752 + 211)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v118 = 21397 - 10286;
	local v119 = 12010 - (503 + 396);
	local v120;
	v10:RegisterForEvent(function()
		v118 = 11292 - (92 + 89);
		v119 = 21554 - 10443;
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v18.Shaman.Restoration;
	local v122 = v25.Shaman.Restoration;
	local v123 = v20.Shaman.Restoration;
	local v124 = {};
	local v125 = v22.Commons.Everyone;
	local v126 = v22.Commons.Shaman;
	local function v127()
		if (v121.ImprovedPurifySpirit:IsAvailable() or ((493 + 467) <= (519 + 357))) then
			v125.DispellableDebuffs = v21.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v140)
		return v140:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (19 - 14));
	end
	local function v129()
		if ((v92 and v121.AstralShift:IsReady()) or ((283 + 1783) == (2124 - 1192))) then
			if (((4210 + 615) < (2314 + 2529)) and (v13:HealthPercentage() <= v58)) then
				if (v24(v121.AstralShift, not v15:IsInRange(121 - 81)) or ((484 + 3393) >= (6918 - 2381))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v95 and v121.EarthElemental:IsReady()) or ((5559 - (485 + 759)) < (3993 - 2267))) then
			if ((v13:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67) or ((4868 - (442 + 747)) < (1760 - (832 + 303)))) then
				if (v24(v121.EarthElemental, not v15:IsInRange(986 - (88 + 858))) or ((1410 + 3215) < (524 + 108))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v123.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((4 + 79) > (2569 - (766 + 23)))) then
			if (((2695 - 2149) <= (1472 - 395)) and v24(v122.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((2623 - 1627) > (14597 - 10296))) then
			if (((5143 - (1036 + 37)) > (488 + 199)) and (v40 == "Refreshing Healing Potion")) then
				if (v123.RefreshingHealingPotion:IsReady() or ((1277 - 621) >= (2620 + 710))) then
					if (v24(v122.RefreshingHealingPotion) or ((3972 - (641 + 839)) <= (1248 - (910 + 3)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((11017 - 6695) >= (4246 - (1466 + 218))) and (v40 == "Dreamwalker's Healing Potion")) then
				if (v123.DreamwalkersHealingPotion:IsReady() or ((1672 + 1965) >= (4918 - (556 + 592)))) then
					if (v24(v122.RefreshingHealingPotion) or ((846 + 1533) > (5386 - (329 + 479)))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v130()
		local v141 = 854 - (174 + 680);
		while true do
			if (((6 - 4) == v141) or ((1000 - 517) > (531 + 212))) then
				if (((3193 - (396 + 343)) > (52 + 526)) and v43) then
					local v240 = 1477 - (29 + 1448);
					while true do
						if (((2319 - (135 + 1254)) < (16794 - 12336)) and (v240 == (4 - 3))) then
							v29 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 27 + 13);
							if (((2189 - (389 + 1138)) <= (1546 - (102 + 472))) and v29) then
								return v29;
							end
							v240 = 2 + 0;
						end
						if (((2424 + 1946) == (4075 + 295)) and (v240 == (1547 - (320 + 1225)))) then
							v29 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 71 - 31);
							if (v29 or ((2914 + 1848) <= (2325 - (157 + 1307)))) then
								return v29;
							end
							v240 = 1862 - (821 + 1038);
						end
						if ((v240 == (7 - 4)) or ((155 + 1257) == (7573 - 3309))) then
							v29 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 15 + 25);
							if (v29 or ((7852 - 4684) < (3179 - (834 + 192)))) then
								return v29;
							end
							break;
						end
						if ((v240 == (0 + 0)) or ((1278 + 3698) < (29 + 1303))) then
							v29 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 61 - 21);
							if (((4932 - (300 + 4)) == (1236 + 3392)) and v29) then
								return v29;
							end
							v240 = 2 - 1;
						end
					end
				end
				if (v44 or ((416 - (112 + 250)) == (158 + 237))) then
					v29 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 100 - 60);
					if (((47 + 35) == (43 + 39)) and v29) then
						return v29;
					end
					v29 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 30 + 10);
					if (v29 or ((289 + 292) < (210 + 72))) then
						return v29;
					end
					v29 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 1454 - (1001 + 413));
					if (v29 or ((10277 - 5668) < (3377 - (244 + 638)))) then
						return v29;
					end
					v29 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 733 - (627 + 66));
					if (((3432 - 2280) == (1754 - (512 + 90))) and v29) then
						return v29;
					end
				end
				break;
			end
			if (((3802 - (1665 + 241)) <= (4139 - (373 + 344))) and (v141 == (1 + 0))) then
				if (v41 or ((262 + 728) > (4273 - 2653))) then
					local v241 = 0 - 0;
					while true do
						if ((v241 == (1100 - (35 + 1064))) or ((639 + 238) > (10045 - 5350))) then
							v29 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 1 + 39);
							if (((3927 - (298 + 938)) >= (3110 - (233 + 1026))) and v29) then
								return v29;
							end
							break;
						end
						if ((v241 == (1666 - (636 + 1030))) or ((1527 + 1458) >= (4744 + 112))) then
							v29 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 12 + 28);
							if (((289 + 3987) >= (1416 - (55 + 166))) and v29) then
								return v29;
							end
							v241 = 1 + 0;
						end
					end
				end
				if (((326 + 2906) <= (17911 - 13221)) and v42) then
					local v242 = 297 - (36 + 261);
					while true do
						if ((v242 == (3 - 1)) or ((2264 - (34 + 1334)) >= (1210 + 1936))) then
							v29 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 32 + 8);
							if (((4344 - (1035 + 248)) >= (2979 - (20 + 1))) and v29) then
								return v29;
							end
							v242 = 2 + 1;
						end
						if (((3506 - (134 + 185)) >= (1777 - (549 + 584))) and ((688 - (314 + 371)) == v242)) then
							v29 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 137 - 97);
							if (((1612 - (478 + 490)) <= (373 + 331)) and v29) then
								return v29;
							end
							break;
						end
						if (((2130 - (786 + 386)) > (3067 - 2120)) and (v242 == (1379 - (1055 + 324)))) then
							v29 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 1380 - (1093 + 247));
							if (((3992 + 500) >= (280 + 2374)) and v29) then
								return v29;
							end
							v242 = 3 - 2;
						end
						if (((11681 - 8239) >= (4276 - 2773)) and (v242 == (2 - 1))) then
							v29 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 15 + 25);
							if (v29 or ((12212 - 9042) <= (5046 - 3582))) then
								return v29;
							end
							v242 = 2 + 0;
						end
					end
				end
				v141 = 4 - 2;
			end
			if ((v141 == (688 - (364 + 324))) or ((13150 - 8353) == (10529 - 6141))) then
				if (((183 + 368) <= (2849 - 2168)) and v113) then
					local v243 = 0 - 0;
					while true do
						if (((9952 - 6675) > (1675 - (1249 + 19))) and (v243 == (0 + 0))) then
							v29 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 116 - 86, true);
							if (((5781 - (686 + 400)) >= (1111 + 304)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v112 or ((3441 - (73 + 156)) <= (5 + 939))) then
					local v244 = 811 - (721 + 90);
					while true do
						if ((v244 == (0 + 0)) or ((10052 - 6956) <= (2268 - (224 + 246)))) then
							v29 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 48 - 18);
							if (((6512 - 2975) == (642 + 2895)) and v29) then
								return v29;
							end
							v244 = 1 + 0;
						end
						if (((2819 + 1018) >= (3121 - 1551)) and (v244 == (3 - 2))) then
							if (v114 or ((3463 - (203 + 310)) == (5805 - (1238 + 755)))) then
								local v252 = 0 + 0;
								while true do
									if (((6257 - (709 + 825)) >= (4271 - 1953)) and (v252 == (0 - 0))) then
										v29 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 894 - (196 + 668));
										if (v29 or ((8003 - 5976) > (5907 - 3055))) then
											return v29;
										end
										break;
									end
								end
							end
							if (v115 or ((1969 - (171 + 662)) > (4410 - (4 + 89)))) then
								local v253 = 0 - 0;
								while true do
									if (((1729 + 3019) == (20854 - 16106)) and (v253 == (0 + 0))) then
										v29 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 1516 - (35 + 1451));
										if (((5189 - (28 + 1425)) <= (6733 - (941 + 1052))) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v141 = 1 + 0;
			end
		end
	end
	local function v131()
		if ((v110 and ((v31 and v109) or not v109)) or ((4904 - (822 + 692)) <= (4368 - 1308))) then
			v29 = v125.HandleTopTrinket(v124, v31, 19 + 21, nil);
			if (v29 or ((1296 - (45 + 252)) > (2665 + 28))) then
				return v29;
			end
			v29 = v125.HandleBottomTrinket(v124, v31, 14 + 26, nil);
			if (((1126 - 663) < (1034 - (114 + 319))) and v29) then
				return v29;
			end
		end
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((3133 - 950) < (879 - 192))) then
			if (((2900 + 1649) == (6776 - 2227)) and (v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) then
				if (((9788 - 5116) == (6635 - (556 + 1407))) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingcd tank";
				end
			end
		end
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((4874 - (741 + 465)) < (860 - (170 + 295)))) then
			if ((v17:HealthPercentage() <= v82) or ((2196 + 1970) == (418 + 37))) then
				if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((10953 - 6504) == (2208 + 455))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v85, v84) and v121.SpiritLinkTotem:IsReady()) or ((2743 + 1534) < (1693 + 1296))) then
			if ((v86 == "Player") or ((2100 - (957 + 273)) >= (1110 + 3039))) then
				if (((886 + 1326) < (12128 - 8945)) and v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(105 - 65))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((14191 - 9545) > (14815 - 11823)) and (v86 == "Friendly under Cursor")) then
				if (((3214 - (389 + 1391)) < (1949 + 1157)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((82 + 704) < (6882 - 3859)) and v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(991 - (783 + 168)))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v86 == "Confirmation") or ((8195 - 5753) < (73 + 1))) then
				if (((4846 - (309 + 2)) == (13926 - 9391)) and v24(v121.SpiritLinkTotem, not v15:IsInRange(1252 - (1090 + 122)))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if ((v99 and v125.AreUnitsBelowHealthPercentage(v78, v77) and v121.HealingTideTotem:IsReady()) or ((976 + 2033) <= (7069 - 4964))) then
			if (((1253 + 577) < (4787 - (628 + 490))) and v24(v121.HealingTideTotem, not v15:IsInRange(8 + 32))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v54, v53) and v121.AncestralProtectionTotem:IsReady()) or ((3540 - 2110) >= (16506 - 12894))) then
			if (((3457 - (431 + 343)) >= (4968 - 2508)) and (v55 == "Player")) then
				if (v24(v122.AncestralProtectionTotemPlayer, not v15:IsInRange(115 - 75)) or ((1426 + 378) >= (419 + 2856))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v55 == "Friendly under Cursor") or ((3112 - (556 + 1139)) > (3644 - (6 + 9)))) then
				if (((878 + 3917) > (206 + 196)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((4982 - (28 + 141)) > (1381 + 2184)) and v24(v122.AncestralProtectionTotemCursor, not v15:IsInRange(49 - 9))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((2771 + 1141) == (5229 - (486 + 831))) and (v55 == "Confirmation")) then
				if (((7340 - 4519) <= (16983 - 12159)) and v24(v121.AncestralProtectionTotem, not v15:IsInRange(8 + 32))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if (((5495 - 3757) <= (3458 - (668 + 595))) and v90 and v125.AreUnitsBelowHealthPercentage(v52, v51) and v121.AncestralGuidance:IsReady()) then
			if (((37 + 4) <= (609 + 2409)) and v24(v121.AncestralGuidance, not v15:IsInRange(109 - 69))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((2435 - (23 + 267)) <= (6048 - (1129 + 815))) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56) and v121.Ascendance:IsReady()) then
			if (((3076 - (371 + 16)) < (6595 - (1326 + 424))) and v24(v121.Ascendance, not v15:IsInRange(75 - 35))) then
				return "ascendance cooldowns";
			end
		end
		if ((v101 and (v13:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) or ((8485 - 6163) > (2740 - (88 + 30)))) then
			if (v24(v121.ManaTideTotem, not v15:IsInRange(811 - (720 + 51))) or ((10085 - 5551) == (3858 - (421 + 1355)))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v35 and ((v108 and v31) or not v108)) or ((2591 - 1020) > (918 + 949))) then
			local v185 = 1083 - (286 + 797);
			while true do
				if ((v185 == (0 - 0)) or ((4395 - 1741) >= (3435 - (397 + 42)))) then
					if (((1243 + 2735) > (2904 - (24 + 776))) and v121.AncestralCall:IsReady()) then
						if (((4614 - 1619) > (2326 - (222 + 563))) and v24(v121.AncestralCall, not v15:IsInRange(88 - 48))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((2340 + 909) > (1143 - (23 + 167))) and v121.BagofTricks:IsReady()) then
						if (v24(v121.BagofTricks, not v15:IsInRange(1838 - (690 + 1108))) or ((1181 + 2092) > (3773 + 800))) then
							return "BagofTricks cooldowns";
						end
					end
					v185 = 849 - (40 + 808);
				end
				if ((v185 == (1 + 0)) or ((12049 - 8898) < (1228 + 56))) then
					if (v121.Berserking:IsReady() or ((979 + 871) == (839 + 690))) then
						if (((1392 - (47 + 524)) < (1378 + 745)) and v24(v121.Berserking, not v15:IsInRange(109 - 69))) then
							return "Berserking cooldowns";
						end
					end
					if (((1348 - 446) < (5302 - 2977)) and v121.BloodFury:IsReady()) then
						if (((2584 - (1165 + 561)) <= (88 + 2874)) and v24(v121.BloodFury, not v15:IsInRange(123 - 83))) then
							return "BloodFury cooldowns";
						end
					end
					v185 = 1 + 1;
				end
				if ((v185 == (481 - (341 + 138))) or ((1066 + 2880) < (2657 - 1369))) then
					if (v121.Fireblood:IsReady() or ((3568 - (89 + 237)) == (1823 - 1256))) then
						if (v24(v121.Fireblood, not v15:IsInRange(84 - 44)) or ((1728 - (581 + 300)) >= (2483 - (855 + 365)))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
			end
		end
	end
	local function v132()
		if ((v93 and v125.AreUnitsBelowHealthPercentage(225 - 130, 1 + 2) and v121.ChainHeal:IsReady() and v13:BuffUp(v121.HighTide)) or ((3488 - (1030 + 205)) == (1738 + 113))) then
			if (v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1942 + 145) > (2658 - (156 + 130)))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v100 and (v17:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (34 - 19))) or ((7491 - 3046) < (8497 - 4348))) then
			if (v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((480 + 1338) == (50 + 35))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if (((699 - (10 + 59)) < (602 + 1525)) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) or ((9544 - 7606) == (3677 - (671 + 492)))) then
				if (((3388 + 867) >= (1270 - (369 + 846))) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if (((794 + 2205) > (987 + 169)) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((4295 - (1036 + 909)) > (919 + 236)) and (v17:HealthPercentage() <= v82)) then
				if (((6763 - 2734) <= (5056 - (11 + 192))) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v104 and v121.UnleashLife:IsReady()) or ((261 + 255) > (3609 - (135 + 40)))) then
			if (((9802 - 5756) >= (1829 + 1204)) and (v17:HealthPercentage() <= v89)) then
				if (v24(v121.UnleashLife, not v17:IsSpellInRange(v121.UnleashLife)) or ((5989 - 3270) <= (2168 - 721))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71)) or ((4310 - (50 + 126)) < (10932 - 7006))) then
			if (v24(v122.HealingRainCursor, not v15:IsInRange(9 + 31), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1577 - (1233 + 180)) >= (3754 - (522 + 447)))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v72, v71) and v121.HealingRain:IsReady()) or ((1946 - (107 + 1314)) == (979 + 1130))) then
			if (((100 - 67) == (15 + 18)) and (v73 == "Player")) then
				if (((6064 - 3010) <= (15885 - 11870)) and v24(v122.HealingRainPlayer, not v15:IsInRange(1950 - (716 + 1194)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif (((32 + 1839) < (363 + 3019)) and (v73 == "Friendly under Cursor")) then
				if (((1796 - (74 + 429)) <= (4178 - 2012)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v122.HealingRainCursor, not v15:IsInRange(20 + 20), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5903 - 3324) < (88 + 35))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v73 == "Enemy under Cursor") or ((2607 - 1761) >= (5854 - 3486))) then
				if ((v16:Exists() and v13:CanAttack(v16)) or ((4445 - (279 + 154)) <= (4136 - (454 + 324)))) then
					if (((1176 + 318) <= (3022 - (12 + 5))) and v24(v122.HealingRainCursor, not v15:IsInRange(22 + 18), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v73 == "Confirmation") or ((7926 - 4815) == (789 + 1345))) then
				if (((3448 - (277 + 816)) == (10063 - 7708)) and v24(v121.HealingRain, not v15:IsInRange(1223 - (1058 + 125)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if ((v125.AreUnitsBelowHealthPercentage(v69, v68) and v121.EarthenWallTotem:IsReady()) or ((111 + 477) <= (1407 - (815 + 160)))) then
			if (((20582 - 15785) >= (9246 - 5351)) and (v70 == "Player")) then
				if (((854 + 2723) == (10456 - 6879)) and v24(v122.EarthenWallTotemPlayer, not v15:IsInRange(1938 - (41 + 1857)))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((5687 - (1222 + 671)) > (9544 - 5851)) and (v70 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1832 - 557) == (5282 - (229 + 953)))) then
					if (v24(v122.EarthenWallTotemCursor, not v15:IsInRange(1814 - (1111 + 663))) or ((3170 - (874 + 705)) >= (502 + 3078))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif (((671 + 312) <= (3758 - 1950)) and (v70 == "Confirmation")) then
				if (v24(v121.EarthenWallTotem, not v15:IsInRange(2 + 38)) or ((2829 - (642 + 37)) <= (273 + 924))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((603 + 3166) >= (2944 - 1771)) and v125.AreUnitsBelowHealthPercentage(v64, v63) and v121.Downpour:IsReady()) then
			if (((1939 - (233 + 221)) == (3433 - 1948)) and (v65 == "Player")) then
				if (v24(v122.DownpourPlayer, not v15:IsInRange(36 + 4), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4856 - (718 + 823)) <= (1751 + 1031))) then
					return "downpour healingaoe";
				end
			elseif ((v65 == "Friendly under Cursor") or ((1681 - (266 + 539)) >= (8391 - 5427))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((3457 - (636 + 589)) > (5927 - 3430))) then
					if (v24(v122.DownpourCursor, not v15:IsInRange(82 - 42), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1673 + 437) <= (121 + 211))) then
						return "downpour healingaoe";
					end
				end
			elseif (((4701 - (657 + 358)) > (8398 - 5226)) and (v65 == "Confirmation")) then
				if (v24(v121.Downpour, not v15:IsInRange(91 - 51), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5661 - (1151 + 36)) < (792 + 28))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((1125 + 3154) >= (8606 - 5724)) and v94 and v125.AreUnitsBelowHealthPercentage(v62, v61) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (1842 - (1552 + 280)))) then
			if (v24(v121.CloudburstTotem) or ((2863 - (64 + 770)) >= (2391 + 1130))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v105 and v125.AreUnitsBelowHealthPercentage(v107, v106) and v121.Wellspring:IsReady()) or ((4623 - 2586) >= (825 + 3817))) then
			if (((2963 - (157 + 1086)) < (8923 - 4465)) and v24(v121.Wellspring, not v15:IsInRange(175 - 135), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if ((v93 and v125.AreUnitsBelowHealthPercentage(v60, v59) and v121.ChainHeal:IsReady()) or ((668 - 232) > (4123 - 1102))) then
			if (((1532 - (599 + 220)) <= (1686 - 839)) and v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if (((4085 - (1813 + 118)) <= (2947 + 1084)) and v103 and v13:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87) and v121.SpiritwalkersGrace:IsReady()) then
			if (((5832 - (841 + 376)) == (6466 - 1851)) and v24(v121.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74) and v121.HealingStreamTotem:IsReady()) or ((881 + 2909) == (1364 - 864))) then
			if (((948 - (464 + 395)) < (567 - 346)) and v24(v121.HealingStreamTotem, nil)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v133()
		if (((987 + 1067) >= (2258 - (467 + 370))) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((1429 - 737) < (2245 + 813)) and (v17:HealthPercentage() <= v82)) then
				if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((11154 - 7900) == (259 + 1396))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((3015 - 1719) == (5430 - (150 + 370)))) then
			if (((4650 - (74 + 1208)) == (8283 - 4915)) and (v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) then
				if (((12534 - 9891) < (2715 + 1100)) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((2303 - (14 + 376)) > (854 - 361)) and v121.ElementalOrbit:IsAvailable() and v13:BuffDown(v121.EarthShieldBuff) and not v15:IsAPlayer()) then
			if (((3077 + 1678) > (3012 + 416)) and v24(v121.EarthShield)) then
				return "earth_shield player healingst";
			end
		end
		if (((1318 + 63) <= (6941 - 4572)) and v121.ElementalOrbit:IsAvailable() and v13:BuffUp(v121.EarthShieldBuff)) then
			if (v125.IsSoloMode() or ((3644 + 1199) == (4162 - (23 + 55)))) then
				if (((11064 - 6395) > (243 + 120)) and v121.LightningShield:IsReady() and v13:BuffDown(v121.LightningShield)) then
					if (v24(v121.LightningShield) or ((1686 + 191) >= (4864 - 1726))) then
						return "lightning_shield healingst";
					end
				end
			elseif (((1492 + 3250) >= (4527 - (652 + 249))) and v121.WaterShield:IsReady() and v13:BuffDown(v121.WaterShield)) then
				if (v24(v121.WaterShield) or ((12149 - 7609) == (2784 - (708 + 1160)))) then
					return "water_shield healingst";
				end
			end
		end
		if ((v98 and v121.HealingSurge:IsReady()) or ((3137 - 1981) > (7921 - 3576))) then
			if (((2264 - (10 + 17)) < (955 + 3294)) and (v17:HealthPercentage() <= v76)) then
				if (v24(v122.HealingSurgeFocus, not v17:IsSpellInRange(v121.HealingSurge), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4415 - (1400 + 332)) < (43 - 20))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((2605 - (242 + 1666)) <= (354 + 472)) and v100 and v121.HealingWave:IsReady()) then
			if (((405 + 700) <= (1003 + 173)) and (v17:HealthPercentage() <= v79)) then
				if (((4319 - (850 + 90)) <= (6676 - 2864)) and v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v134()
		local v142 = 1390 - (360 + 1030);
		while true do
			if ((v142 == (1 + 0)) or ((2223 - 1435) >= (2222 - 606))) then
				if (((3515 - (909 + 752)) <= (4602 - (109 + 1114))) and v121.FlameShock:IsReady()) then
					local v245 = 0 - 0;
					while true do
						if (((1771 + 2778) == (4791 - (6 + 236))) and ((0 + 0) == v245)) then
							if (v125.CastCycle(v121.FlameShock, v13:GetEnemiesInRange(33 + 7), v128, not v15:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil) or ((7126 - 4104) >= (5281 - 2257))) then
								return "flame_shock_cycle damage";
							end
							if (((5953 - (1076 + 57)) > (362 + 1836)) and v24(v121.FlameShock, not v15:IsSpellInRange(v121.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v121.LavaBurst:IsReady() or ((1750 - (579 + 110)) >= (387 + 4504))) then
					if (((1206 + 158) <= (2374 + 2099)) and v24(v121.LavaBurst, not v15:IsSpellInRange(v121.LavaBurst), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v142 = 409 - (174 + 233);
			end
			if ((v142 == (5 - 3)) or ((6309 - 2714) <= (2 + 1))) then
				if (v121.LightningBolt:IsReady() or ((5846 - (663 + 511)) == (3437 + 415))) then
					if (((339 + 1220) == (4806 - 3247)) and v24(v121.LightningBolt, not v15:IsSpellInRange(v121.LightningBolt), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v142 == (0 + 0)) or ((4124 - 2372) <= (1907 - 1119))) then
				if (v121.Stormkeeper:IsReady() or ((1865 + 2042) == (344 - 167))) then
					if (((2473 + 997) > (51 + 504)) and v24(v121.Stormkeeper, not v15:IsInRange(762 - (478 + 244)))) then
						return "stormkeeper damage";
					end
				end
				if ((math.max(#v13:GetEnemiesInRange(537 - (440 + 77)), v13:GetEnemiesInSplashRangeCount(4 + 4)) > (7 - 5)) or ((2528 - (655 + 901)) == (120 + 525))) then
					if (((2437 + 745) >= (1429 + 686)) and v121.ChainLightning:IsReady()) then
						if (((15683 - 11790) < (5874 - (695 + 750))) and v24(v121.ChainLightning, not v15:IsSpellInRange(v121.ChainLightning), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v142 = 3 - 2;
			end
		end
	end
	local function v135()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (28 - 21)) or ((3218 - (285 + 66)) < (4440 - 2535))) then
				v89 = EpicSettings.Settings['UnleashLifeHP'];
				v93 = EpicSettings.Settings['UseChainHeal'];
				v94 = EpicSettings.Settings['UseCloudburstTotem'];
				v96 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v143 = 1318 - (682 + 628);
			end
			if ((v143 == (2 + 6)) or ((2095 - (176 + 123)) >= (1695 + 2356))) then
				v97 = EpicSettings.Settings['UseHealingStreamTotem'];
				v98 = EpicSettings.Settings['UseHealingSurge'];
				v99 = EpicSettings.Settings['UseHealingTideTotem'];
				v100 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v143 = 7 + 2;
			end
			if (((1888 - (239 + 30)) <= (1022 + 2734)) and (v143 == (4 + 0))) then
				v76 = EpicSettings.Settings['HealingSurgeHP'];
				v77 = EpicSettings.Settings['HealingTideTotemGroup'];
				v78 = EpicSettings.Settings['HealingTideTotemHP'];
				v79 = EpicSettings.Settings['HealingWaveHP'];
				v37 = EpicSettings.Settings['healthstoneHP'];
				v143 = 8 - 3;
			end
			if (((1884 - 1280) == (919 - (306 + 9))) and (v143 == (17 - 12))) then
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['RiptideHP'];
				v83 = EpicSettings.Settings['RiptideTankHP'];
				v143 = 2 + 4;
			end
			if ((v143 == (0 + 0)) or ((2159 + 2325) == (2573 - 1673))) then
				v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v59 = EpicSettings.Settings['ChainHealGroup'];
				v60 = EpicSettings.Settings['ChainHealHP'];
				v143 = 1376 - (1140 + 235);
			end
			if ((v143 == (1 + 0)) or ((4089 + 370) <= (286 + 827))) then
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v46 = EpicSettings.Settings['DispelBuffs'];
				v63 = EpicSettings.Settings['DownpourGroup'];
				v64 = EpicSettings.Settings['DownpourHP'];
				v65 = EpicSettings.Settings['DownpourUsage'];
				v143 = 54 - (33 + 19);
			end
			if (((1312 + 2320) > (10184 - 6786)) and (v143 == (3 + 3))) then
				v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v143 = 13 - 6;
			end
			if (((3828 + 254) <= (5606 - (586 + 103))) and (v143 == (1 + 8))) then
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v102 = EpicSettings.Settings['UseRiptide'];
				v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v104 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((14875 - 10043) >= (2874 - (1309 + 179))) and (v143 == (5 - 2))) then
				v71 = EpicSettings.Settings['HealingRainGroup'];
				v72 = EpicSettings.Settings['HealingRainHP'];
				v73 = EpicSettings.Settings['HealingRainUsage'];
				v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v75 = EpicSettings.Settings['HealingStreamTotemHP'];
				v143 = 2 + 2;
			end
			if (((367 - 230) == (104 + 33)) and (v143 == (3 - 1))) then
				v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v69 = EpicSettings.Settings['EarthenWallTotemHP'];
				v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v143 = 5 - 2;
			end
		end
	end
	local function v136()
		v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v52 = EpicSettings.Settings['AncestralGuidanceHP'];
		v56 = EpicSettings.Settings['AscendanceGroup'];
		v57 = EpicSettings.Settings['AscendanceHP'];
		v58 = EpicSettings.Settings['AstralShiftHP'];
		v61 = EpicSettings.Settings['CloudburstTotemGroup'];
		v62 = EpicSettings.Settings['CloudburstTotemHP'];
		v66 = EpicSettings.Settings['EarthElementalHP'];
		v67 = EpicSettings.Settings['EarthElementalTankHP'];
		v80 = EpicSettings.Settings['ManaTideTotemMana'];
		v81 = EpicSettings.Settings['PrimordialWaveHP'];
		v90 = EpicSettings.Settings['UseAncestralGuidance'];
		v91 = EpicSettings.Settings['UseAscendance'];
		v92 = EpicSettings.Settings['UseAstralShift'];
		v95 = EpicSettings.Settings['UseEarthElemental'];
		v101 = EpicSettings.Settings['UseManaTideTotem'];
		v105 = EpicSettings.Settings['UseWellspring'];
		v106 = EpicSettings.Settings['WellspringGroup'];
		v107 = EpicSettings.Settings['WellspringHP'];
		v116 = EpicSettings.Settings['useManaPotion'];
		v117 = EpicSettings.Settings['manaPotionSlider'];
		v108 = EpicSettings.Settings['racialsWithCD'];
		v35 = EpicSettings.Settings['useRacials'];
		v109 = EpicSettings.Settings['trinketsWithCD'];
		v110 = EpicSettings.Settings['useTrinkets'];
		v111 = EpicSettings.Settings['fightRemainsCheck'];
		v112 = EpicSettings.Settings['handleAfflicted'];
		v113 = EpicSettings.Settings['HandleIncorporeal'];
		v41 = EpicSettings.Settings['HandleChromie'];
		v43 = EpicSettings.Settings['HandleCharredBrambles'];
		v42 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleFyrakkNPC'];
		v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local v137 = 609 - (295 + 314);
	local function v138()
		local v178 = 0 - 0;
		local v179;
		while true do
			if ((v178 == (1965 - (1300 + 662))) or ((4930 - 3360) >= (6087 - (1178 + 577)))) then
				if (v125.TargetIsValid() or v13:AffectingCombat() or ((2111 + 1953) <= (5377 - 3558))) then
					v120 = v13:GetEnemiesInRange(1445 - (851 + 554));
					v118 = v10.BossFightRemains(nil, true);
					v119 = v118;
					if ((v119 == (9826 + 1285)) or ((13827 - 8841) < (3418 - 1844))) then
						v119 = v10.FightRemains(v120, false);
					end
				end
				if (((4728 - (115 + 187)) > (132 + 40)) and not v13:AffectingCombat()) then
					if (((555 + 31) > (1793 - 1338)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v250 = 1161 - (160 + 1001);
						local v251;
						while true do
							if (((723 + 103) == (570 + 256)) and ((0 - 0) == v250)) then
								v251 = v125.DeadFriendlyUnitsCount();
								if ((v251 > (359 - (237 + 121))) or ((4916 - (525 + 372)) > (8419 - 3978))) then
									if (((6626 - 4609) < (4403 - (96 + 46))) and v24(v121.AncestralVision, nil, v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (((5493 - (643 + 134)) > (29 + 51)) and v24(v122.AncestralSpiritMouseover, not v15:IsInRange(95 - 55), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v179 = v130();
				v178 = 14 - 10;
			end
			if ((v178 == (1 + 0)) or ((6882 - 3375) == (6688 - 3416))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v178 = 721 - (316 + 403);
			end
			if (((3 + 1) == v178) or ((2408 - 1532) >= (1112 + 1963))) then
				if (((10959 - 6607) > (1810 + 744)) and v179) then
					return v179;
				end
				if (v13:AffectingCombat() or v30 or ((1420 + 2986) < (14008 - 9965))) then
					local v246 = 0 - 0;
					local v247;
					while true do
						if ((v246 == (1 - 0)) or ((109 + 1780) >= (6659 - 3276))) then
							if (((93 + 1799) <= (8043 - 5309)) and (not v17:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v17) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 42 - (12 + 5)) >= (3 - 2)))) then
								local v254 = 0 - 0;
								while true do
									if (((4087 - 2164) < (5500 - 3282)) and (v254 == (0 + 0))) then
										v29 = v125.FocusUnit(v247, nil, nil, nil);
										if (((4146 - (1656 + 317)) > (338 + 41)) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((0 + 0) == v246) or ((6889 - 4298) == (16777 - 13368))) then
							v247 = v45 and v121.PurifySpirit:IsReady() and v32;
							if (((4868 - (5 + 349)) > (15788 - 12464)) and v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 1296 - (266 + 1005)) < (1 + 0))) then
								local v255 = 0 - 0;
								while true do
									if ((v255 == (0 - 0)) or ((1904 - (561 + 1135)) >= (6291 - 1463))) then
										v29 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 49 - 34, 1106 - (507 + 559), "TANK", true, 62 - 37);
										if (v29 or ((4895 - 3312) > (3955 - (212 + 176)))) then
											return v29;
										end
										v255 = 906 - (250 + 655);
									end
									if ((v255 == (2 - 1)) or ((2294 - 981) == (1241 - 447))) then
										if (((5130 - (1869 + 87)) > (10065 - 7163)) and (v125.UnitGroupRole(v17) == "TANK")) then
											if (((6021 - (484 + 1417)) <= (9130 - 4870)) and v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield))) then
												return "earth_shield_tank main apl 1";
											end
										end
										break;
									end
								end
							end
							v246 = 1 - 0;
						end
					end
				end
				if ((v121.EarthShield:IsCastable() and v96 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(813 - (48 + 725)) and (v125.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v121.EarthShield))) or ((1442 - 559) > (12818 - 8040))) then
					if (v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield)) or ((2104 + 1516) >= (13070 - 8179))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v178 = 2 + 3;
			end
			if (((1241 + 3017) > (1790 - (152 + 701))) and (v178 == (1313 - (430 + 881)))) then
				v34 = EpicSettings.Toggles['dps'];
				v179 = nil;
				if (v13:IsDeadOrGhost() or ((1865 + 3004) < (1801 - (557 + 338)))) then
					return;
				end
				v178 = 1 + 2;
			end
			if ((v178 == (14 - 9)) or ((4289 - 3064) > (11232 - 7004))) then
				if (((7172 - 3844) > (3039 - (499 + 302))) and v13:AffectingCombat() and v125.TargetIsValid()) then
					local v248 = 866 - (39 + 827);
					while true do
						if (((10597 - 6758) > (3137 - 1732)) and ((7 - 5) == v248)) then
							if (v29 or ((1984 - 691) <= (44 + 463))) then
								return v29;
							end
							v179 = v129();
							if (v179 or ((8476 - 5580) < (129 + 676))) then
								return v179;
							end
							v248 = 4 - 1;
						end
						if (((2420 - (103 + 1)) == (2870 - (475 + 79))) and ((0 - 0) == v248)) then
							if ((v116 and v123.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v117)) or ((8224 - 5654) == (199 + 1334))) then
								if (v24(v122.ManaPotion, nil) or ((778 + 105) == (2963 - (1395 + 108)))) then
									return "Mana Potion main";
								end
							end
							v29 = v125.Interrupt(v121.WindShear, 87 - 57, true);
							if (v29 or ((5823 - (7 + 1197)) <= (436 + 563))) then
								return v29;
							end
							v248 = 1 + 0;
						end
						if ((v248 == (320 - (27 + 292))) or ((9992 - 6582) > (5248 - 1132))) then
							v29 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 125 - 95, true, v16);
							if (v29 or ((1780 - 877) >= (5825 - 2766))) then
								return v29;
							end
							v29 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 169 - (43 + 96), nil, v16);
							v248 = 8 - 6;
						end
						if ((v248 == (6 - 3)) or ((3300 + 676) < (807 + 2050))) then
							if (((9744 - 4814) > (885 + 1422)) and v121.GreaterPurge:IsAvailable() and v47 and v121.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
								if (v24(v121.GreaterPurge, not v15:IsSpellInRange(v121.GreaterPurge)) or ((7582 - 3536) < (407 + 884))) then
									return "greater_purge utility";
								end
							end
							if ((v121.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) or ((311 + 3930) == (5296 - (1414 + 337)))) then
								if (v24(v121.Purge, not v15:IsSpellInRange(v121.Purge)) or ((5988 - (1642 + 298)) > (11031 - 6799))) then
									return "purge utility";
								end
							end
							if ((v119 > v111) or ((5034 - 3284) >= (10306 - 6833))) then
								local v256 = 0 + 0;
								while true do
									if (((2464 + 702) == (4138 - (357 + 615))) and (v256 == (0 + 0))) then
										v179 = v131();
										if (((4325 - 2562) < (3191 + 533)) and v179) then
											return v179;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((121 - 64) <= (2178 + 545)) and (v30 or v13:AffectingCombat())) then
					local v249 = 0 + 0;
					while true do
						if ((v249 == (0 + 0)) or ((3371 - (384 + 917)) == (1140 - (128 + 569)))) then
							if ((v32 and v45) or ((4248 - (1407 + 136)) == (3280 - (687 + 1200)))) then
								local v257 = 1710 - (556 + 1154);
								while true do
									if ((v257 == (3 - 2)) or ((4696 - (9 + 86)) < (482 - (275 + 146)))) then
										if ((v16 and v16:Exists() and v16:IsAPlayer() and (v125.UnitHasMagicDebuff(v16) or (v125.UnitHasCurseDebuff(v16) and v121.ImprovedPurifySpirit:IsAvailable()))) or ((227 + 1163) >= (4808 - (29 + 35)))) then
											if (v121.PurifySpirit:IsReady() or ((8877 - 6874) > (11451 - 7617))) then
												if (v24(v122.PurifySpiritMouseover, not v16:IsSpellInRange(v121.PurifySpirit)) or ((688 - 532) > (2549 + 1364))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
									if (((1207 - (53 + 959)) == (603 - (312 + 96))) and (v257 == (0 - 0))) then
										if (((3390 - (147 + 138)) >= (2695 - (813 + 86))) and (v121.Bursting:MaxDebuffStack() > (4 + 0))) then
											local v260 = 0 - 0;
											while true do
												if (((4871 - (18 + 474)) >= (719 + 1412)) and ((0 - 0) == v260)) then
													v29 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
													if (((4930 - (860 + 226)) >= (2346 - (121 + 182))) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if (v17 or ((398 + 2834) <= (3971 - (988 + 252)))) then
											if (((555 + 4350) == (1537 + 3368)) and v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(1995 - (49 + 1921))) then
												local v261 = 890 - (223 + 667);
												while true do
													if ((v261 == (52 - (51 + 1))) or ((7118 - 2982) >= (9445 - 5034))) then
														if ((v137 == (1125 - (146 + 979))) or ((835 + 2123) == (4622 - (311 + 294)))) then
															v137 = GetTime();
														end
														if (((3424 - 2196) >= (345 + 468)) and v125.Wait(1943 - (496 + 947), v137)) then
															local v262 = 1358 - (1233 + 125);
															while true do
																if ((v262 == (0 + 0)) or ((3100 + 355) > (770 + 3280))) then
																	if (((1888 - (963 + 682)) == (203 + 40)) and v24(v122.PurifySpiritFocus, not v17:IsSpellInRange(v121.PurifySpirit))) then
																		return "purify_spirit dispel focus";
																	end
																	v137 = 1504 - (504 + 1000);
																	break;
																end
															end
														end
														break;
													end
												end
											end
										end
										v257 = 1 + 0;
									end
								end
							end
							if ((v121.Bursting:AuraActiveCount() > (3 + 0)) or ((26 + 245) > (2317 - 745))) then
								if (((2341 + 398) < (1916 + 1377)) and (v121.Bursting:MaxDebuffStack() > (187 - (156 + 26))) and v121.SpiritLinkTotem:IsReady()) then
									if ((v86 == "Player") or ((2271 + 1671) < (1774 - 640))) then
										if (v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(204 - (149 + 15))) or ((3653 - (890 + 70)) == (5090 - (39 + 78)))) then
											return "spirit_link_totem bursting";
										end
									elseif (((2628 - (14 + 468)) == (4719 - 2573)) and (v86 == "Friendly under Cursor")) then
										if ((v16:Exists() and not v13:CanAttack(v16)) or ((6271 - 4027) == (1664 + 1560))) then
											if (v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(25 + 15)) or ((1042 + 3862) <= (866 + 1050))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif (((24 + 66) <= (2038 - 973)) and (v86 == "Confirmation")) then
										if (((4747 + 55) == (16874 - 12072)) and v24(v121.SpiritLinkTotem, not v15:IsInRange(2 + 38))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v93 and v121.ChainHeal:IsReady()) or ((2331 - (12 + 39)) <= (476 + 35))) then
									if (v24(v122.ChainHealFocus, nil) or ((5187 - 3511) <= (1648 - 1185))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
							end
							v249 = 1 + 0;
						end
						if (((2037 + 1832) == (9810 - 5941)) and (v249 == (2 + 0))) then
							if (((5596 - 4438) <= (4323 - (1596 + 114))) and v33) then
								local v258 = 0 - 0;
								while true do
									if ((v258 == (713 - (164 + 549))) or ((3802 - (1059 + 379)) <= (2481 - 482))) then
										v179 = v132();
										if (v179 or ((2551 + 2371) < (33 + 161))) then
											return v179;
										end
										v258 = 393 - (145 + 247);
									end
									if ((v258 == (1 + 0)) or ((967 + 1124) < (91 - 60))) then
										v179 = v133();
										if (v179 or ((467 + 1963) >= (4197 + 675))) then
											return v179;
										end
										break;
									end
								end
							end
							if (v34 or ((7745 - 2975) < (2455 - (254 + 466)))) then
								if (v125.TargetIsValid() or ((4999 - (544 + 16)) <= (7468 - 5118))) then
									local v259 = 628 - (294 + 334);
									while true do
										if ((v259 == (253 - (236 + 17))) or ((1931 + 2548) < (3477 + 989))) then
											v179 = v134();
											if (((9592 - 7045) > (5799 - 4574)) and v179) then
												return v179;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((2405 + 2266) > (2203 + 471)) and (v249 == (795 - (413 + 381)))) then
							if (((v17:HealthPercentage() < v81) and v17:BuffDown(v121.Riptide)) or ((156 + 3540) < (7075 - 3748))) then
								if (v121.PrimordialWaveResto:IsCastable() or ((11798 - 7256) == (4940 - (582 + 1388)))) then
									if (((428 - 176) <= (1416 + 561)) and v24(v122.PrimordialWaveFocus, not v17:IsSpellInRange(v121.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (367 - (326 + 38))))) or ((4247 - 2811) == (5389 - 1614))) then
								if (v24(v121.TotemicRecall, nil) or ((2238 - (47 + 573)) < (328 + 602))) then
									return "totemic_recall main";
								end
							end
							v249 = 8 - 6;
						end
					end
				end
				break;
			end
			if (((7665 - 2942) > (5817 - (1269 + 395))) and ((492 - (76 + 416)) == v178)) then
				v135();
				v136();
				v30 = EpicSettings.Toggles['ooc'];
				v178 = 444 - (319 + 124);
			end
		end
	end
	local function v139()
		local v180 = 0 - 0;
		while true do
			if ((v180 == (1008 - (564 + 443))) or ((10115 - 6461) >= (5112 - (337 + 121)))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
			if (((2786 - 1835) <= (4983 - 3487)) and (v180 == (1911 - (1261 + 650)))) then
				v127();
				v121.Bursting:RegisterAuraTracking();
				v180 = 1 + 0;
			end
		end
	end
	v22.SetAPL(420 - 156, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

