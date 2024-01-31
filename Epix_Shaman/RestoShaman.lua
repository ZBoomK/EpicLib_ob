local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((46 + 641) == (4934 - (668 + 32)))) then
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
	local v115 = 41079 - 29968;
	local v116 = 10017 + 1094;
	local v117;
	v9:RegisterForEvent(function()
		v115 = 30784 - 19673;
		v116 = 8390 + 2721;
	end, "PLAYER_REGEN_ENABLED");
	local v118 = v17.Shaman.Restoration;
	local v119 = v24.Shaman.Restoration;
	local v120 = v19.Shaman.Restoration;
	local v121 = {};
	local v122 = v21.Commons.Everyone;
	local v123 = v21.Commons.Shaman;
	local function v124()
		if (v118.ImprovedPurifySpirit:IsAvailable() or ((3819 - (457 + 32)) < (607 + 822))) then
			v122.DispellableDebuffs = v20.MergeTable(v122.DispellableMagicDebuffs, v122.DispellableCurseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125(v137)
		return v137:DebuffRefreshable(v118.FlameShockDebuff) and (v116 > (1407 - (832 + 570)));
	end
	local function v126()
		if (((1081 + 66) >= (88 + 247)) and v91 and v118.AstralShift:IsReady()) then
			if (((12155 - 8720) > (1011 + 1086)) and (v12:HealthPercentage() <= v57)) then
				if (v23(v118.AstralShift, not v14:IsInRange(836 - (588 + 208))) or ((10161 - 6391) >= (5841 - (884 + 916)))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v94 and v118.EarthElemental:IsReady()) or ((7936 - 4145) <= (935 + 676))) then
			if ((v12:HealthPercentage() <= v65) or v122.IsTankBelowHealthPercentage(v66) or ((5231 - (232 + 421)) <= (3897 - (1569 + 320)))) then
				if (((277 + 848) <= (395 + 1681)) and v23(v118.EarthElemental, not v14:IsInRange(134 - 94))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v120.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((1348 - (316 + 289)) >= (11514 - 7115))) then
			if (((54 + 1101) < (3126 - (666 + 787))) and v23(v119.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v37 and (v12:HealthPercentage() <= v38)) or ((2749 - (360 + 65)) <= (541 + 37))) then
			local v199 = 254 - (79 + 175);
			while true do
				if (((5939 - 2172) == (2940 + 827)) and (v199 == (0 - 0))) then
					if (((7874 - 3785) == (4988 - (503 + 396))) and (v39 == "Refreshing Healing Potion")) then
						if (((4639 - (92 + 89)) >= (3247 - 1573)) and v120.RefreshingHealingPotion:IsReady()) then
							if (((499 + 473) <= (840 + 578)) and v23(v119.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((19337 - 14399) < (652 + 4110))) then
						if (v120.DreamwalkersHealingPotion:IsReady() or ((5708 - 3204) > (3721 + 543))) then
							if (((1029 + 1124) == (6557 - 4404)) and v23(v119.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1 - 0)) or ((1751 - (485 + 759)) >= (5995 - 3404))) then
				if (((5670 - (442 + 747)) == (5616 - (832 + 303))) and v40) then
					local v237 = 946 - (88 + 858);
					while true do
						if ((v237 == (1 + 0)) or ((1927 + 401) < (29 + 664))) then
							v28 = v122.HandleChromie(v118.HealingSurge, v119.HealingSurgeMouseover, 829 - (766 + 23));
							if (((21366 - 17038) == (5918 - 1590)) and v28) then
								return v28;
							end
							break;
						end
						if (((4183 - 2595) >= (4520 - 3188)) and (v237 == (1073 - (1036 + 37)))) then
							v28 = v122.HandleChromie(v118.Riptide, v119.RiptideMouseover, 29 + 11);
							if (v28 or ((8127 - 3953) > (3342 + 906))) then
								return v28;
							end
							v237 = 1481 - (641 + 839);
						end
					end
				end
				if (v41 or ((5499 - (910 + 3)) <= (208 - 126))) then
					local v238 = 1684 - (1466 + 218);
					while true do
						if (((1776 + 2087) == (5011 - (556 + 592))) and (v238 == (2 + 1))) then
							v28 = v122.HandleCharredTreant(v118.HealingWave, v119.HealingWaveMouseover, 848 - (329 + 479));
							if (v28 or ((1136 - (174 + 680)) <= (144 - 102))) then
								return v28;
							end
							break;
						end
						if (((9552 - 4943) >= (547 + 219)) and (v238 == (741 - (396 + 343)))) then
							v28 = v122.HandleCharredTreant(v118.HealingSurge, v119.HealingSurgeMouseover, 4 + 36);
							if (v28 or ((2629 - (29 + 1448)) == (3877 - (135 + 1254)))) then
								return v28;
							end
							v238 = 11 - 8;
						end
						if (((15977 - 12555) > (2233 + 1117)) and (v238 == (1528 - (389 + 1138)))) then
							v28 = v122.HandleCharredTreant(v118.ChainHeal, v119.ChainHealMouseover, 614 - (102 + 472));
							if (((828 + 49) > (209 + 167)) and v28) then
								return v28;
							end
							v238 = 2 + 0;
						end
						if ((v238 == (1545 - (320 + 1225))) or ((5550 - 2432) <= (1133 + 718))) then
							v28 = v122.HandleCharredTreant(v118.Riptide, v119.RiptideMouseover, 1504 - (157 + 1307));
							if (v28 or ((2024 - (821 + 1038)) >= (8712 - 5220))) then
								return v28;
							end
							v238 = 1 + 0;
						end
					end
				end
				v138 = 3 - 1;
			end
			if (((1470 + 2479) < (12035 - 7179)) and (v138 == (1026 - (834 + 192)))) then
				if (v112 or ((272 + 4004) < (775 + 2241))) then
					local v239 = 0 + 0;
					while true do
						if (((7265 - 2575) > (4429 - (300 + 4))) and (v239 == (0 + 0))) then
							v28 = v122.HandleIncorporeal(v118.Hex, v119.HexMouseOver, 78 - 48, true);
							if (v28 or ((412 - (112 + 250)) >= (358 + 538))) then
								return v28;
							end
							break;
						end
					end
				end
				if (v111 or ((4293 - 2579) >= (1695 + 1263))) then
					local v240 = 0 + 0;
					while true do
						if ((v240 == (1 + 0)) or ((740 + 751) < (479 + 165))) then
							if (((2118 - (1001 + 413)) < (2200 - 1213)) and v113) then
								local v252 = 882 - (244 + 638);
								while true do
									if (((4411 - (627 + 66)) > (5679 - 3773)) and (v252 == (602 - (512 + 90)))) then
										v28 = v122.HandleAfflicted(v118.TremorTotem, v118.TremorTotem, 1936 - (1665 + 241));
										if (v28 or ((1675 - (373 + 344)) > (1640 + 1995))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((927 + 2574) <= (11848 - 7356)) and v114) then
								v28 = v122.HandleAfflicted(v118.PoisonCleansingTotem, v118.PoisonCleansingTotem, 50 - 20);
								if (v28 or ((4541 - (35 + 1064)) < (1854 + 694))) then
									return v28;
								end
							end
							break;
						end
						if (((6151 - 3276) >= (6 + 1458)) and (v240 == (1236 - (298 + 938)))) then
							v28 = v122.HandleAfflicted(v118.PurifySpirit, v119.PurifySpiritMouseover, 1289 - (233 + 1026));
							if (v28 or ((6463 - (636 + 1030)) >= (2502 + 2391))) then
								return v28;
							end
							v240 = 1 + 0;
						end
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (1 + 1)) or ((772 - (55 + 166)) > (401 + 1667))) then
				if (((213 + 1901) > (3605 - 2661)) and v42) then
					v28 = v122.HandleCharredBrambles(v118.Riptide, v119.RiptideMouseover, 337 - (36 + 261));
					if (v28 or ((3955 - 1693) >= (4464 - (34 + 1334)))) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.ChainHeal, v119.ChainHealMouseover, 16 + 24);
					if (v28 or ((1753 + 502) >= (4820 - (1035 + 248)))) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.HealingSurge, v119.HealingSurgeMouseover, 61 - (20 + 1));
					if (v28 or ((2000 + 1837) < (1625 - (134 + 185)))) then
						return v28;
					end
					v28 = v122.HandleCharredBrambles(v118.HealingWave, v119.HealingWaveMouseover, 1173 - (549 + 584));
					if (((3635 - (314 + 371)) == (10127 - 7177)) and v28) then
						return v28;
					end
				end
				if (v43 or ((5691 - (478 + 490)) < (1748 + 1550))) then
					local v241 = 1172 - (786 + 386);
					while true do
						if (((3679 - 2543) >= (1533 - (1055 + 324))) and (v241 == (1342 - (1093 + 247)))) then
							v28 = v122.HandleFyrakkNPC(v118.HealingSurge, v119.HealingSurgeMouseover, 36 + 4);
							if (v28 or ((29 + 242) > (18850 - 14102))) then
								return v28;
							end
							v241 = 9 - 6;
						end
						if (((13487 - 8747) >= (7920 - 4768)) and ((1 + 0) == v241)) then
							v28 = v122.HandleFyrakkNPC(v118.ChainHeal, v119.ChainHealMouseover, 154 - 114);
							if (v28 or ((8885 - 6307) >= (2557 + 833))) then
								return v28;
							end
							v241 = 4 - 2;
						end
						if (((729 - (364 + 324)) <= (4553 - 2892)) and (v241 == (0 - 0))) then
							v28 = v122.HandleFyrakkNPC(v118.Riptide, v119.RiptideMouseover, 14 + 26);
							if (((2514 - 1913) < (5701 - 2141)) and v28) then
								return v28;
							end
							v241 = 2 - 1;
						end
						if (((1503 - (1249 + 19)) < (621 + 66)) and (v241 == (11 - 8))) then
							v28 = v122.HandleFyrakkNPC(v118.HealingWave, v119.HealingWaveMouseover, 1126 - (686 + 400));
							if (((3570 + 979) > (1382 - (73 + 156))) and v28) then
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
	local function v128()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (813 - (721 + 90))) or ((53 + 4621) < (15169 - 10497))) then
				if (((4138 - (224 + 246)) < (7388 - 2827)) and v98 and v122.AreUnitsBelowHealthPercentage(v77, v76) and v118.HealingTideTotem:IsReady()) then
					if (v23(v118.HealingTideTotem, not v14:IsInRange(73 - 33)) or ((83 + 372) == (86 + 3519))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v53, v52) and v118.AncestralProtectionTotem:IsReady()) or ((1956 + 707) == (6584 - 3272))) then
					if (((14232 - 9955) <= (4988 - (203 + 310))) and (v54 == "Player")) then
						if (v23(v119.AncestralProtectionTotemPlayer, not v14:IsInRange(2033 - (1238 + 755))) or ((61 + 809) == (2723 - (709 + 825)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((2861 - 1308) <= (4563 - 1430)) and (v54 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((3101 - (196 + 668)) >= (13862 - 10351))) then
							if (v23(v119.AncestralProtectionTotemCursor, not v14:IsInRange(82 - 42)) or ((2157 - (171 + 662)) > (3113 - (4 + 89)))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v54 == "Confirmation") or ((10486 - 7494) == (685 + 1196))) then
						if (((13642 - 10536) > (599 + 927)) and v23(v118.AncestralProtectionTotem, not v14:IsInRange(1526 - (35 + 1451)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v139 = 1456 - (28 + 1425);
			end
			if (((5016 - (941 + 1052)) < (3711 + 159)) and ((1518 - (822 + 692)) == v139)) then
				if (((203 - 60) > (35 + 39)) and v100 and (v12:ManaPercentage() <= v79) and v118.ManaTideTotem:IsReady()) then
					if (((315 - (45 + 252)) < (2090 + 22)) and v23(v118.ManaTideTotem, not v14:IsInRange(14 + 26))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((2669 - 1572) <= (2061 - (114 + 319))) and v34 and ((v107 and v30) or not v107)) then
					local v242 = 0 - 0;
					while true do
						if (((5932 - 1302) == (2952 + 1678)) and (v242 == (2 - 0))) then
							if (((7417 - 3877) > (4646 - (556 + 1407))) and v118.Fireblood:IsReady()) then
								if (((6000 - (741 + 465)) >= (3740 - (170 + 295))) and v23(v118.Fireblood, not v14:IsInRange(22 + 18))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((1364 + 120) == (3653 - 2169)) and (v242 == (0 + 0))) then
							if (((919 + 513) < (2014 + 1541)) and v118.AncestralCall:IsReady()) then
								if (v23(v118.AncestralCall, not v14:IsInRange(1270 - (957 + 273))) or ((285 + 780) > (1433 + 2145))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v118.BagofTricks:IsReady() or ((18271 - 13476) < (3707 - 2300))) then
								if (((5659 - 3806) < (23832 - 19019)) and v23(v118.BagofTricks, not v14:IsInRange(1820 - (389 + 1391)))) then
									return "BagofTricks cooldowns";
								end
							end
							v242 = 1 + 0;
						end
						if ((v242 == (1 + 0)) or ((6422 - 3601) < (3382 - (783 + 168)))) then
							if (v118.Berserking:IsReady() or ((9645 - 6771) < (2146 + 35))) then
								if (v23(v118.Berserking, not v14:IsInRange(351 - (309 + 2))) or ((8257 - 5568) <= (1555 - (1090 + 122)))) then
									return "Berserking cooldowns";
								end
							end
							if (v118.BloodFury:IsReady() or ((606 + 1263) == (6747 - 4738))) then
								if (v23(v118.BloodFury, not v14:IsInRange(28 + 12)) or ((4664 - (628 + 490)) < (417 + 1905))) then
									return "BloodFury cooldowns";
								end
							end
							v242 = 4 - 2;
						end
					end
				end
				break;
			end
			if ((v139 == (13 - 10)) or ((2856 - (431 + 343)) == (9639 - 4866))) then
				if (((9384 - 6140) > (834 + 221)) and v89 and v122.AreUnitsBelowHealthPercentage(v51, v50) and v118.AncestralGuidance:IsReady()) then
					if (v23(v118.AncestralGuidance, not v14:IsInRange(6 + 34)) or ((5008 - (556 + 1139)) <= (1793 - (6 + 9)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v90 and v122.AreUnitsBelowHealthPercentage(v56, v55) and v118.Ascendance:IsReady()) or ((261 + 1160) >= (1078 + 1026))) then
					if (((1981 - (28 + 141)) <= (1259 + 1990)) and v23(v118.Ascendance, not v14:IsInRange(49 - 9))) then
						return "ascendance cooldowns";
					end
				end
				v139 = 3 + 1;
			end
			if (((2940 - (486 + 831)) <= (5092 - 3135)) and (v139 == (3 - 2))) then
				if (((834 + 3578) == (13950 - 9538)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
					if (((3013 - (668 + 595)) >= (758 + 84)) and (v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) then
						if (((882 + 3490) > (5045 - 3195)) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((522 - (23 + 267)) < (2765 - (1129 + 815))) and v122.AreUnitsBelowHealthPercentage(v84, v83) and v118.SpiritLinkTotem:IsReady()) then
					if (((905 - (371 + 16)) < (2652 - (1326 + 424))) and (v85 == "Player")) then
						if (((5670 - 2676) > (3135 - 2277)) and v23(v119.SpiritLinkTotemPlayer, not v14:IsInRange(158 - (88 + 30)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v85 == "Friendly under Cursor") or ((4526 - (720 + 51)) <= (2035 - 1120))) then
						if (((5722 - (421 + 1355)) > (6174 - 2431)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v119.SpiritLinkTotemCursor, not v14:IsInRange(20 + 20)) or ((2418 - (286 + 797)) >= (12085 - 8779))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((8023 - 3179) > (2692 - (397 + 42))) and (v85 == "Confirmation")) then
						if (((142 + 310) == (1252 - (24 + 776))) and v23(v118.SpiritLinkTotem, not v14:IsInRange(61 - 21))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v139 = 787 - (222 + 563);
			end
			if (((0 - 0) == v139) or ((3281 + 1276) < (2277 - (23 + 167)))) then
				if (((5672 - (690 + 1108)) == (1398 + 2476)) and v109 and ((v30 and v108) or not v108)) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (848 - (40 + 808))) or ((320 + 1618) > (18871 - 13936))) then
							v28 = v122.HandleTopTrinket(v121, v30, 39 + 1, nil);
							if (v28 or ((2251 + 2004) < (1878 + 1545))) then
								return v28;
							end
							v243 = 572 - (47 + 524);
						end
						if (((944 + 510) <= (6809 - 4318)) and (v243 == (1 - 0))) then
							v28 = v122.HandleBottomTrinket(v121, v30, 91 - 51, nil);
							if (v28 or ((5883 - (1165 + 561)) <= (84 + 2719))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((15030 - 10177) >= (1138 + 1844)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
					if (((4613 - (341 + 138)) > (907 + 2450)) and (v16:HealthPercentage() <= v81)) then
						if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((7051 - 3634) < (2860 - (89 + 237)))) then
							return "riptide healingcd";
						end
					end
				end
				v139 = 3 - 2;
			end
		end
	end
	local function v129()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (881 - (581 + 300))) or ((3942 - (855 + 365)) <= (389 - 225))) then
				if ((v92 and v122.AreUnitsBelowHealthPercentage(32 + 63, 1238 - (1030 + 205)) and v118.ChainHeal:IsReady() and v12:BuffUp(v118.HighTide)) or ((2261 + 147) < (1962 + 147))) then
					if (v23(v119.ChainHealFocus, not v16:IsSpellInRange(v118.ChainHeal), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((319 - (156 + 130)) == (3306 - 1851))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v99 and (v16:HealthPercentage() <= v78) and v118.HealingWave:IsReady() and (v118.PrimordialWaveResto:TimeSinceLastCast() < (25 - 10))) or ((907 - 464) >= (1058 + 2957))) then
					if (((1973 + 1409) > (235 - (10 + 59))) and v23(v119.HealingWaveFocus, not v16:IsSpellInRange(v118.HealingWave), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((80 + 200) == (15064 - 12005))) then
					if (((3044 - (671 + 492)) > (1030 + 263)) and (v16:HealthPercentage() <= v81)) then
						if (((3572 - (369 + 846)) == (624 + 1733)) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v140 = 1 + 0;
			end
			if (((2068 - (1036 + 909)) == (98 + 25)) and (v140 == (2 - 0))) then
				if ((v122.AreUnitsBelowHealthPercentage(v71, v70) and v118.HealingRain:IsReady()) or ((1259 - (11 + 192)) >= (1715 + 1677))) then
					if ((v72 == "Player") or ((1256 - (135 + 40)) < (2604 - 1529))) then
						if (v23(v119.HealingRainPlayer, not v14:IsInRange(25 + 15), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2310 - 1261) >= (6643 - 2211))) then
							return "healing_rain healingaoe";
						end
					elseif ((v72 == "Friendly under Cursor") or ((4944 - (50 + 126)) <= (2355 - 1509))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((744 + 2614) <= (2833 - (1233 + 180)))) then
							if (v23(v119.HealingRainCursor, not v14:IsInRange(1009 - (522 + 447)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((5160 - (107 + 1314)) <= (1395 + 1610))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Enemy under Cursor") or ((5054 - 3395) >= (907 + 1227))) then
						if ((v15:Exists() and v12:CanAttack(v15)) or ((6473 - 3213) < (9317 - 6962))) then
							if (v23(v119.HealingRainCursor, not v14:IsInRange(1950 - (716 + 1194)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((12 + 657) == (453 + 3770))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v72 == "Confirmation") or ((2195 - (74 + 429)) < (1133 - 545))) then
						if (v23(v118.HealingRain, not v14:IsInRange(20 + 20), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((10980 - 6183) < (2584 + 1067))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v68, v67) and v118.EarthenWallTotem:IsReady()) or ((12877 - 8700) > (11992 - 7142))) then
					if ((v69 == "Player") or ((833 - (279 + 154)) > (1889 - (454 + 324)))) then
						if (((2401 + 650) > (1022 - (12 + 5))) and v23(v119.EarthenWallTotemPlayer, not v14:IsInRange(22 + 18))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((9409 - 5716) <= (1620 + 2762)) and (v69 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((4375 - (277 + 816)) > (17519 - 13419))) then
							if (v23(v119.EarthenWallTotemCursor, not v14:IsInRange(1223 - (1058 + 125))) or ((672 + 2908) < (3819 - (815 + 160)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((381 - 292) < (10658 - 6168)) and (v69 == "Confirmation")) then
						if (v23(v118.EarthenWallTotem, not v14:IsInRange(10 + 30)) or ((14566 - 9583) < (3706 - (41 + 1857)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((5722 - (1222 + 671)) > (9741 - 5972)) and v122.AreUnitsBelowHealthPercentage(v63, v62) and v118.Downpour:IsReady()) then
					if (((2134 - 649) <= (4086 - (229 + 953))) and (v64 == "Player")) then
						if (((6043 - (1111 + 663)) == (5848 - (874 + 705))) and v23(v119.DownpourPlayer, not v14:IsInRange(6 + 34), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif (((265 + 122) <= (5782 - 3000)) and (v64 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((54 + 1845) <= (1596 - (642 + 37)))) then
							if (v23(v119.DownpourCursor, not v14:IsInRange(10 + 30), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((690 + 3622) <= (2199 - 1323))) then
								return "downpour healingaoe";
							end
						end
					elseif (((2686 - (233 + 221)) <= (6002 - 3406)) and (v64 == "Confirmation")) then
						if (((1844 + 251) < (5227 - (718 + 823))) and v23(v118.Downpour, not v14:IsInRange(26 + 14), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				v140 = 808 - (266 + 539);
			end
			if ((v140 == (11 - 7)) or ((2820 - (636 + 589)) >= (10619 - 6145))) then
				if ((v102 and v12:IsMoving() and v122.AreUnitsBelowHealthPercentage(v87, v86) and v118.SpiritwalkersGrace:IsReady()) or ((9526 - 4907) < (2284 + 598))) then
					if (v23(v118.SpiritwalkersGrace, nil) or ((107 + 187) >= (5846 - (657 + 358)))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((5372 - 3343) <= (7025 - 3941)) and v96 and v122.AreUnitsBelowHealthPercentage(v74, v73) and v118.HealingStreamTotem:IsReady()) then
					if (v23(v118.HealingStreamTotem, nil) or ((3224 - (1151 + 36)) == (2337 + 83))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((1173 + 3285) > (11658 - 7754)) and (v140 == (1835 - (1552 + 280)))) then
				if (((1270 - (64 + 770)) >= (84 + 39)) and v93 and v122.AreUnitsBelowHealthPercentage(v61, v60) and v118.CloudburstTotem:IsReady()) then
					if (((1135 - 635) < (323 + 1493)) and v23(v118.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((4817 - (157 + 1086)) == (7153 - 3579)) and v104 and v122.AreUnitsBelowHealthPercentage(v106, v105) and v118.Wellspring:IsReady()) then
					if (((967 - 746) < (598 - 208)) and v23(v118.Wellspring, not v14:IsInRange(54 - 14), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if ((v92 and v122.AreUnitsBelowHealthPercentage(v59, v58) and v118.ChainHeal:IsReady()) or ((3032 - (599 + 220)) <= (2829 - 1408))) then
					if (((4989 - (1813 + 118)) < (3553 + 1307)) and v23(v119.ChainHealFocus, not v16:IsSpellInRange(v118.ChainHeal), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v140 = 1221 - (841 + 376);
			end
			if ((v140 == (1 - 0)) or ((302 + 994) >= (12135 - 7689))) then
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((2252 - (464 + 395)) > (11520 - 7031))) then
					if (((v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) or ((2125 + 2299) < (864 - (467 + 370)))) then
						if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((4126 - 2129) > (2801 + 1014))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((11878 - 8413) > (299 + 1614)) and v103 and v118.UnleashLife:IsReady()) then
					if (((1705 - 972) < (2339 - (150 + 370))) and (v16:HealthPercentage() <= v88)) then
						if (v23(v118.UnleashLife, not v16:IsSpellInRange(v118.UnleashLife)) or ((5677 - (74 + 1208)) == (11695 - 6940))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v72 == "Cursor") and v118.HealingRain:IsReady()) or ((17988 - 14195) < (1686 + 683))) then
					if (v23(v119.HealingRainCursor, not v14:IsInRange(430 - (14 + 376)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((7083 - 2999) == (172 + 93))) then
						return "healing_rain healingaoe";
					end
				end
				v140 = 2 + 0;
			end
		end
	end
	local function v130()
		local v141 = 0 + 0;
		while true do
			if (((12769 - 8411) == (3279 + 1079)) and (v141 == (80 - (23 + 55)))) then
				if ((v118.ElementalOrbit:IsAvailable() and v12:BuffUp(v118.EarthShieldBuff)) or ((7436 - 4298) < (663 + 330))) then
					if (((2991 + 339) > (3601 - 1278)) and v122.IsSoloMode()) then
						if ((v118.LightningShield:IsReady() and v12:BuffDown(v118.LightningShield)) or ((1141 + 2485) == (4890 - (652 + 249)))) then
							if (v23(v118.LightningShield) or ((2451 - 1535) == (4539 - (708 + 1160)))) then
								return "lightning_shield healingst";
							end
						end
					elseif (((738 - 466) == (495 - 223)) and v118.WaterShield:IsReady() and v12:BuffDown(v118.WaterShield)) then
						if (((4276 - (10 + 17)) <= (1087 + 3752)) and v23(v118.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				if (((4509 - (1400 + 332)) < (6137 - 2937)) and v97 and v118.HealingSurge:IsReady()) then
					if (((2003 - (242 + 1666)) < (838 + 1119)) and (v16:HealthPercentage() <= v75)) then
						if (((303 + 523) < (1464 + 253)) and v23(v119.HealingSurgeFocus, not v16:IsSpellInRange(v118.HealingSurge), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				v141 = 943 - (850 + 90);
			end
			if (((2496 - 1070) >= (2495 - (360 + 1030))) and (v141 == (1 + 0))) then
				if (((7773 - 5019) <= (4648 - 1269)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
					if ((v16:HealthPercentage() <= v81) or (v16:HealthPercentage() <= v81) or ((5588 - (909 + 752)) == (2636 - (109 + 1114)))) then
						if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((2112 - 958) <= (307 + 481))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v118.ElementalOrbit:IsAvailable() and v12:BuffDown(v118.EarthShieldBuff)) or ((1885 - (6 + 236)) > (2129 + 1250))) then
					if (v23(v118.EarthShield) or ((2257 + 546) > (10727 - 6178))) then
						return "earth_shield healingst";
					end
				end
				v141 = 3 - 1;
			end
			if (((1133 - (1076 + 57)) == v141) or ((37 + 183) >= (3711 - (579 + 110)))) then
				if (((223 + 2599) == (2496 + 326)) and v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) then
					if ((v16:HealthPercentage() <= v81) or ((564 + 497) == (2264 - (174 + 233)))) then
						if (((7709 - 4949) > (2393 - 1029)) and v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v101 and v12:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v16:BuffDown(v118.Riptide)) or ((2180 + 2722) <= (4769 - (663 + 511)))) then
					if (((v16:HealthPercentage() <= v82) and (v122.UnitGroupRole(v16) == "TANK")) or ((3437 + 415) == (64 + 229))) then
						if (v23(v119.RiptideFocus, not v16:IsSpellInRange(v118.Riptide)) or ((4806 - 3247) == (2779 + 1809))) then
							return "riptide healingaoe";
						end
					end
				end
				v141 = 2 - 1;
			end
			if ((v141 == (7 - 4)) or ((2140 + 2344) == (1533 - 745))) then
				if (((3256 + 1312) >= (358 + 3549)) and v99 and v118.HealingWave:IsReady()) then
					if (((1968 - (478 + 244)) < (3987 - (440 + 77))) and (v16:HealthPercentage() <= v78)) then
						if (((1850 + 2218) >= (3557 - 2585)) and v23(v119.HealingWaveFocus, not v16:IsSpellInRange(v118.HealingWave), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v142 = 1556 - (655 + 901);
		while true do
			if (((92 + 401) < (2981 + 912)) and ((2 + 0) == v142)) then
				if (v118.LightningBolt:IsReady() or ((5934 - 4461) >= (4777 - (695 + 750)))) then
					if (v23(v118.LightningBolt, not v14:IsSpellInRange(v118.LightningBolt), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((13832 - 9781) <= (1785 - 628))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if (((2428 - 1824) < (3232 - (285 + 66))) and (v142 == (0 - 0))) then
				if (v118.Stormkeeper:IsReady() or ((2210 - (682 + 628)) == (545 + 2832))) then
					if (((4758 - (176 + 123)) > (248 + 343)) and v23(v118.Stormkeeper, not v14:IsInRange(30 + 10))) then
						return "stormkeeper damage";
					end
				end
				if (((3667 - (239 + 30)) >= (652 + 1743)) and (#v12:GetEnemiesInRange(39 + 1) > (1 - 0))) then
					if (v118.ChainLightning:IsReady() or ((6810 - 4627) >= (3139 - (306 + 9)))) then
						if (((6755 - 4819) == (337 + 1599)) and v23(v118.ChainLightning, not v14:IsSpellInRange(v118.ChainLightning), v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v142 = 1 + 0;
			end
			if (((1 + 0) == v142) or ((13817 - 8985) < (5688 - (1140 + 235)))) then
				if (((2602 + 1486) > (3553 + 321)) and v118.FlameShock:IsReady()) then
					local v244 = 0 + 0;
					while true do
						if (((4384 - (33 + 19)) == (1565 + 2767)) and ((0 - 0) == v244)) then
							if (((1762 + 2237) >= (5687 - 2787)) and v122.CastCycle(v118.FlameShock, v12:GetEnemiesInRange(38 + 2), v125, not v14:IsSpellInRange(v118.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v23(v118.FlameShock, not v14:IsSpellInRange(v118.FlameShock)) or ((3214 - (586 + 103)) > (371 + 3693))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((13456 - 9085) == (5859 - (1309 + 179))) and v118.LavaBurst:IsReady()) then
					if (v23(v118.LavaBurst, not v14:IsSpellInRange(v118.LavaBurst), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((479 - 213) > (2171 + 2815))) then
						return "lava_burst damage";
					end
				end
				v142 = 5 - 3;
			end
		end
	end
	local function v132()
		v52 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v53 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v54 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v58 = EpicSettings.Settings['ChainHealGroup'];
		v59 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelDebuffs'];
		v45 = EpicSettings.Settings['DispelBuffs'];
		v62 = EpicSettings.Settings['DownpourGroup'];
		v63 = EpicSettings.Settings['DownpourHP'];
		v64 = EpicSettings.Settings['DownpourUsage'];
		v67 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v68 = EpicSettings.Settings['EarthenWallTotemHP'];
		v69 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v38 = EpicSettings.Settings['healingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v70 = EpicSettings.Settings['HealingRainGroup'];
		v71 = EpicSettings.Settings['HealingRainHP'];
		v72 = EpicSettings.Settings['HealingRainUsage'];
		v73 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v74 = EpicSettings.Settings['HealingStreamTotemHP'];
		v75 = EpicSettings.Settings['HealingSurgeHP'];
		v76 = EpicSettings.Settings['HealingTideTotemGroup'];
		v77 = EpicSettings.Settings['HealingTideTotemHP'];
		v78 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v49 = EpicSettings.Settings['InterruptThreshold'];
		v47 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['RiptideHP'];
		v82 = EpicSettings.Settings['RiptideTankHP'];
		v83 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v84 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v85 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v86 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v87 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v88 = EpicSettings.Settings['UnleashLifeHP'];
		v92 = EpicSettings.Settings['UseChainHeal'];
		v93 = EpicSettings.Settings['UseCloudburstTotem'];
		v95 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['UseHealingStreamTotem'];
		v97 = EpicSettings.Settings['UseHealingSurge'];
		v98 = EpicSettings.Settings['UseHealingTideTotem'];
		v99 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v46 = EpicSettings.Settings['UsePurgeTarget'];
		v101 = EpicSettings.Settings['UseRiptide'];
		v102 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v103 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v133()
		local v192 = 0 + 0;
		while true do
			if (((4230 - 2239) >= (1843 - 918)) and (v192 == (613 - (295 + 314)))) then
				v111 = EpicSettings.Settings['handleAfflicted'];
				v112 = EpicSettings.Settings['HandleIncorporeal'];
				v40 = EpicSettings.Settings['HandleChromie'];
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v43 = EpicSettings.Settings['HandleFyrakkNPC'];
				v192 = 12 - 7;
			end
			if (((2417 - (1300 + 662)) < (6446 - 4393)) and (v192 == (1758 - (1178 + 577)))) then
				v106 = EpicSettings.Settings['WellspringHP'];
				v107 = EpicSettings.Settings['racialsWithCD'];
				v34 = EpicSettings.Settings['useRacials'];
				v108 = EpicSettings.Settings['trinketsWithCD'];
				v109 = EpicSettings.Settings['useTrinkets'];
				v110 = EpicSettings.Settings['fightRemainsCheck'];
				v192 = 3 + 1;
			end
			if (((0 - 0) == v192) or ((2231 - (851 + 554)) == (4290 + 561))) then
				v50 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v51 = EpicSettings.Settings['AncestralGuidanceHP'];
				v55 = EpicSettings.Settings['AscendanceGroup'];
				v56 = EpicSettings.Settings['AscendanceHP'];
				v57 = EpicSettings.Settings['AstralShiftHP'];
				v60 = EpicSettings.Settings['CloudburstTotemGroup'];
				v192 = 2 - 1;
			end
			if (((397 - 214) == (485 - (115 + 187))) and (v192 == (2 + 0))) then
				v90 = EpicSettings.Settings['UseAscendance'];
				v91 = EpicSettings.Settings['UseAstralShift'];
				v94 = EpicSettings.Settings['UseEarthElemental'];
				v100 = EpicSettings.Settings['UseManaTideTotem'];
				v104 = EpicSettings.Settings['UseWellspring'];
				v105 = EpicSettings.Settings['WellspringGroup'];
				v192 = 3 + 0;
			end
			if (((4567 - 3408) <= (2949 - (160 + 1001))) and (v192 == (5 + 0))) then
				v113 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v114 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v192 == (1 + 0)) or ((7178 - 3671) > (4676 - (237 + 121)))) then
				v61 = EpicSettings.Settings['CloudburstTotemHP'];
				v65 = EpicSettings.Settings['EarthElementalHP'];
				v66 = EpicSettings.Settings['EarthElementalTankHP'];
				v79 = EpicSettings.Settings['ManaTideTotemMana'];
				v80 = EpicSettings.Settings['PrimordialWaveHP'];
				v89 = EpicSettings.Settings['UseAncestralGuidance'];
				v192 = 899 - (525 + 372);
			end
		end
	end
	local v134 = 0 - 0;
	local function v135()
		local v193 = 0 - 0;
		local v194;
		while true do
			if ((v193 == (145 - (96 + 46))) or ((3852 - (643 + 134)) <= (1071 + 1894))) then
				if (((3272 - 1907) <= (7466 - 5455)) and (v12:AffectingCombat() or v29)) then
					local v245 = 0 + 0;
					local v246;
					while true do
						if ((v245 == (1 - 0)) or ((5674 - 2898) > (4294 - (316 + 403)))) then
							if (not v16:BuffDown(v118.EarthShield) or (v122.UnitGroupRole(v16) ~= "TANK") or not v95 or (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 17 + 8) >= (2 - 1)) or ((924 + 1630) == (12098 - 7294))) then
								local v253 = 0 + 0;
								while true do
									if (((831 + 1746) == (8928 - 6351)) and (v253 == (0 - 0))) then
										v28 = v122.FocusUnit(v246, nil, nil, nil);
										if (v28 or ((12 - 6) >= (109 + 1780))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
						if (((995 - 489) <= (93 + 1799)) and (v245 == (0 - 0))) then
							v246 = v44 and v118.PurifySpirit:IsReady() and v31;
							if ((v118.EarthShield:IsReady() and v95 and (v122.FriendlyUnitsWithBuffCount(v118.EarthShield, true, false, 42 - (12 + 5)) < (3 - 2))) or ((4284 - 2276) > (4714 - 2496))) then
								local v254 = 0 - 0;
								while true do
									if (((77 + 302) <= (6120 - (1656 + 317))) and (v254 == (0 + 0))) then
										v28 = v122.FocusUnitRefreshableBuff(v118.EarthShield, 13 + 2, 106 - 66, "TANK", true, 123 - 98);
										if (v28 or ((4868 - (5 + 349)) <= (4792 - 3783))) then
											return v28;
										end
										v254 = 1272 - (266 + 1005);
									end
									if ((v254 == (1 + 0)) or ((11928 - 8432) == (1568 - 376))) then
										if ((v122.UnitGroupRole(v16) == "TANK") or ((1904 - (561 + 1135)) == (3855 - 896))) then
											if (((14058 - 9781) >= (2379 - (507 + 559))) and v23(v119.EarthShieldFocus, not v16:IsSpellInRange(v118.EarthShield))) then
												return "earth_shield_tank main apl";
											end
										end
										break;
									end
								end
							end
							v245 = 2 - 1;
						end
					end
				end
				if (((8000 - 5413) < (3562 - (212 + 176))) and v118.EarthShield:IsCastable() and v95 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(945 - (250 + 655)) and (v122.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v118.EarthShield))) then
					if (v23(v119.EarthShieldFocus, not v16:IsSpellInRange(v118.EarthShield)) or ((11234 - 7114) <= (3840 - 1642))) then
						return "earth_shield_tank main apl";
					end
				end
				if (not v12:AffectingCombat() or ((2496 - 900) == (2814 - (1869 + 87)))) then
					if (((11168 - 7948) == (5121 - (484 + 1417))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v250 = 0 - 0;
						local v251;
						while true do
							if ((v250 == (0 - 0)) or ((2175 - (48 + 725)) > (5913 - 2293))) then
								v251 = v122.DeadFriendlyUnitsCount();
								if (((6905 - 4331) == (1496 + 1078)) and (v251 > (2 - 1))) then
									if (((504 + 1294) < (804 + 1953)) and v23(v118.AncestralVision, nil, v12:BuffDown(v118.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (v23(v119.AncestralSpiritMouseover, not v14:IsInRange(893 - (152 + 701)), v12:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1688 - (430 + 881)) > (998 + 1606))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				if (((1463 - (557 + 338)) < (270 + 641)) and v12:AffectingCombat() and v122.TargetIsValid()) then
					local v247 = 0 - 0;
					while true do
						if (((11503 - 8218) < (11232 - 7004)) and ((6 - 3) == v247)) then
							if (((4717 - (499 + 302)) > (4194 - (39 + 827))) and v118.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v122.UnitHasMagicBuff(v14)) then
								if (((6901 - 4401) < (8573 - 4734)) and v23(v118.Purge, not v14:IsSpellInRange(v118.Purge))) then
									return "purge utility";
								end
							end
							if (((2013 - 1506) == (778 - 271)) and (v116 > v110)) then
								local v255 = 0 + 0;
								while true do
									if (((702 - 462) <= (507 + 2658)) and (v255 == (0 - 0))) then
										v194 = v128();
										if (((938 - (103 + 1)) >= (1359 - (475 + 79))) and v194) then
											return v194;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v247 == (2 - 1)) or ((12198 - 8386) < (300 + 2016))) then
							if (v28 or ((2334 + 318) <= (3036 - (1395 + 108)))) then
								return v28;
							end
							v28 = v122.InterruptWithStunCursor(v118.CapacitorTotem, v119.CapacitorTotemCursor, 87 - 57, nil, v15);
							if (v28 or ((4802 - (7 + 1197)) < (637 + 823))) then
								return v28;
							end
							v247 = 1 + 1;
						end
						if (((321 - (27 + 292)) == v247) or ((12060 - 7944) < (1519 - 327))) then
							v194 = v126();
							if (v194 or ((14162 - 10785) <= (1780 - 877))) then
								return v194;
							end
							if (((7572 - 3596) >= (578 - (43 + 96))) and v118.GreaterPurge:IsAvailable() and v46 and v118.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v122.UnitHasMagicBuff(v14)) then
								if (((15304 - 11552) == (8482 - 4730)) and v23(v118.GreaterPurge, not v14:IsSpellInRange(v118.GreaterPurge))) then
									return "greater_purge utility";
								end
							end
							v247 = 3 + 0;
						end
						if (((1143 + 2903) > (5326 - 2631)) and ((0 + 0) == v247)) then
							v28 = v122.Interrupt(v118.WindShear, 56 - 26, true);
							if (v28 or ((1117 + 2428) == (235 + 2962))) then
								return v28;
							end
							v28 = v122.InterruptCursor(v118.WindShear, v119.WindShearMouseover, 1781 - (1414 + 337), true, v15);
							v247 = 1941 - (1642 + 298);
						end
					end
				end
				v193 = 10 - 6;
			end
			if (((6887 - 4493) > (1106 - 733)) and (v193 == (2 + 2))) then
				if (((3233 + 922) <= (5204 - (357 + 615))) and (v29 or v12:AffectingCombat())) then
					local v248 = 0 + 0;
					while true do
						if ((v248 == (2 - 1)) or ((3069 + 512) == (7442 - 3969))) then
							if (((3995 + 1000) > (228 + 3120)) and v32) then
								local v256 = 0 + 0;
								while true do
									if ((v256 == (1302 - (384 + 917))) or ((1451 - (128 + 569)) > (5267 - (1407 + 136)))) then
										v194 = v130();
										if (((2104 - (687 + 1200)) >= (1767 - (556 + 1154))) and v194) then
											return v194;
										end
										break;
									end
									if (((0 - 0) == v256) or ((2165 - (9 + 86)) >= (4458 - (275 + 146)))) then
										v194 = v129();
										if (((440 + 2265) == (2769 - (29 + 35))) and v194) then
											return v194;
										end
										v256 = 4 - 3;
									end
								end
							end
							if (((182 - 121) == (269 - 208)) and v33) then
								if (v122.TargetIsValid() or ((456 + 243) >= (2308 - (53 + 959)))) then
									v194 = v131();
									if (v194 or ((2191 - (312 + 96)) >= (6275 - 2659))) then
										return v194;
									end
								end
							end
							break;
						end
						if ((v248 == (285 - (147 + 138))) or ((4812 - (813 + 86)) > (4091 + 436))) then
							if (((8107 - 3731) > (1309 - (18 + 474))) and v31 and v44) then
								local v257 = 0 + 0;
								while true do
									if (((15865 - 11004) > (1910 - (860 + 226))) and ((303 - (121 + 182)) == v257)) then
										if (v16 or ((171 + 1212) >= (3371 - (988 + 252)))) then
											if ((v118.PurifySpirit:IsReady() and v122.DispellableFriendlyUnit(3 + 22)) or ((588 + 1288) >= (4511 - (49 + 1921)))) then
												local v258 = 890 - (223 + 667);
												while true do
													if (((1834 - (51 + 1)) <= (6491 - 2719)) and (v258 == (0 - 0))) then
														if ((v134 == (1125 - (146 + 979))) or ((1327 + 3373) < (1418 - (311 + 294)))) then
															v134 = GetTime();
														end
														if (((8920 - 5721) < (1716 + 2334)) and v122.Wait(1943 - (496 + 947), v134)) then
															local v259 = 1358 - (1233 + 125);
															while true do
																if ((v259 == (0 + 0)) or ((4442 + 509) < (842 + 3588))) then
																	if (((1741 - (963 + 682)) == (81 + 15)) and v23(v119.PurifySpiritFocus, not v16:IsSpellInRange(v118.PurifySpirit))) then
																		return "purify_spirit dispel focus";
																	end
																	v134 = 1504 - (504 + 1000);
																	break;
																end
															end
														end
														break;
													end
												end
											end
										end
										if ((v15 and v15:Exists() and v15:IsAPlayer() and (v122.UnitHasMagicDebuff(v15) or (v122.UnitHasCurseDebuff(v15) and v118.ImprovedPurifySpirit:IsAvailable()))) or ((1845 + 894) > (3650 + 358))) then
											if (v118.PurifySpirit:IsReady() or ((3 + 20) == (1671 - 537))) then
												if (v23(v119.PurifySpiritMouseover, not v15:IsSpellInRange(v118.PurifySpirit)) or ((2301 + 392) >= (2391 + 1720))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							if (((v16:HealthPercentage() < v80) and v16:BuffDown(v118.Riptide)) or ((4498 - (156 + 26)) <= (1237 + 909))) then
								if (v118.PrimordialWaveResto:IsCastable() or ((5547 - 2001) <= (2973 - (149 + 15)))) then
									if (((5864 - (890 + 70)) > (2283 - (39 + 78))) and v23(v119.PrimordialWaveFocus, not v16:IsSpellInRange(v118.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							v248 = 483 - (14 + 468);
						end
					end
				end
				break;
			end
			if (((239 - 130) >= (251 - 161)) and (v193 == (2 + 0))) then
				if (((2990 + 1988) > (618 + 2287)) and v12:IsDeadOrGhost()) then
					return;
				end
				if (v122.TargetIsValid() or v12:AffectingCombat() or ((1367 + 1659) <= (598 + 1682))) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (0 + 0)) or ((5808 - 4155) <= (28 + 1080))) then
							v117 = v12:GetEnemiesInRange(91 - (12 + 39));
							v115 = v9.BossFightRemains(nil, true);
							v249 = 1 + 0;
						end
						if (((9004 - 6095) > (9291 - 6682)) and (v249 == (1 + 0))) then
							v116 = v115;
							if (((399 + 358) > (491 - 297)) and (v116 == (7401 + 3710))) then
								v116 = v9.FightRemains(v117, false);
							end
							break;
						end
					end
				end
				v194 = v127();
				if (v194 or ((149 - 118) >= (3108 - (1596 + 114)))) then
					return v194;
				end
				v193 = 7 - 4;
			end
			if (((3909 - (164 + 549)) <= (6310 - (1059 + 379))) and (v193 == (0 - 0))) then
				v132();
				v133();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v193 = 1 + 0;
			end
			if (((561 + 2765) == (3718 - (145 + 247))) and (v193 == (1 + 0))) then
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v33 = EpicSettings.Toggles['dps'];
				v194 = nil;
				v193 = 1 + 1;
			end
		end
	end
	local function v136()
		local v195 = 0 - 0;
		while true do
			if (((275 + 1158) <= (3341 + 537)) and (v195 == (0 - 0))) then
				v124();
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(984 - (254 + 466), v135, v136);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

