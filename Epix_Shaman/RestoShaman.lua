local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1899 - (262 + 1637);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((6017 - (157 + 1307)) < (2227 - (821 + 1038)))) then
			v6 = v0[v4];
			if (((2412 - 1445) == (106 + 861)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((552 + 930) <= (10308 - 6149)) and (v5 == (1027 - (834 + 192)))) then
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
	local v115;
	local v116;
	local v117;
	local v118 = 707 + 10404;
	local v119 = 2852 + 8259;
	local v120;
	v10:RegisterForEvent(function()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (0 - 0)) or ((788 - (300 + 4)) == (940 + 2576))) then
				v118 = 29085 - 17974;
				v119 = 11473 - (112 + 250);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v121 = v18.Shaman.Restoration;
	local v122 = v25.Shaman.Restoration;
	local v123 = v20.Shaman.Restoration;
	local v124 = {};
	local v125 = v22.Commons.Everyone;
	local v126 = v22.Commons.Shaman;
	local function v127()
		if (((1984 + 2992) > (3652 - 2194)) and v121.ImprovedPurifySpirit:IsAvailable()) then
			v125.DispellableDebuffs = v21.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (3 + 2));
	end
	local function v129()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (0 + 0)) or ((2295 + 2333) == (2134 + 738))) then
				if ((v92 and v121.AstralShift:IsReady()) or ((6000 - (1001 + 413)) < (182 - 100))) then
					if (((4745 - (244 + 638)) == (4556 - (627 + 66))) and (v13:HealthPercentage() <= v58)) then
						if (v24(v121.AstralShift, not v15:IsInRange(119 - 79)) or ((884 - (512 + 90)) <= (1948 - (1665 + 241)))) then
							return "astral_shift defensives";
						end
					end
				end
				if (((5326 - (373 + 344)) >= (346 + 420)) and v95 and v121.EarthElemental:IsReady()) then
					if ((v13:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67) or ((305 + 847) == (6562 - 4074))) then
						if (((5790 - 2368) > (4449 - (35 + 1064))) and v24(v121.EarthElemental, not v15:IsInRange(30 + 10))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 2 - 1;
			end
			if (((4 + 873) > (1612 - (298 + 938))) and (v142 == (1260 - (233 + 1026)))) then
				if ((v123.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((4784 - (636 + 1030)) <= (947 + 904))) then
					if (v24(v122.Healthstone) or ((162 + 3) >= (1038 + 2454))) then
						return "healthstone defensive 3";
					end
				end
				if (((267 + 3682) < (5077 - (55 + 166))) and v38 and (v13:HealthPercentage() <= v39)) then
					local v251 = 0 + 0;
					while true do
						if ((v251 == (0 + 0)) or ((16330 - 12054) < (3313 - (36 + 261)))) then
							if (((8202 - 3512) > (5493 - (34 + 1334))) and (v40 == "Refreshing Healing Potion")) then
								if (v123.RefreshingHealingPotion:IsReady() or ((20 + 30) >= (697 + 199))) then
									if (v24(v122.RefreshingHealingPotion) or ((2997 - (1035 + 248)) >= (2979 - (20 + 1)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v40 == "Dreamwalker's Healing Potion") or ((777 + 714) < (963 - (134 + 185)))) then
								if (((1837 - (549 + 584)) < (1672 - (314 + 371))) and v123.DreamwalkersHealingPotion:IsReady()) then
									if (((12763 - 9045) > (2874 - (478 + 490))) and v24(v122.RefreshingHealingPotion)) then
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
		end
	end
	local function v130()
		if (v113 or ((508 + 450) > (4807 - (786 + 386)))) then
			local v155 = 0 - 0;
			while true do
				if (((4880 - (1055 + 324)) <= (5832 - (1093 + 247))) and (v155 == (0 + 0))) then
					v29 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 4 + 26, true);
					if (v29 or ((13665 - 10223) < (8647 - 6099))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((8180 - 5305) >= (3678 - 2214)) and v112) then
			v29 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 11 + 19);
			if (v29 or ((18480 - 13683) >= (16864 - 11971))) then
				return v29;
			end
			if (v114 or ((416 + 135) > (5288 - 3220))) then
				local v249 = 688 - (364 + 324);
				while true do
					if (((5795 - 3681) > (2265 - 1321)) and (v249 == (0 + 0))) then
						v29 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 125 - 95);
						if (v29 or ((3621 - 1359) >= (9402 - 6306))) then
							return v29;
						end
						break;
					end
				end
			end
			if (v115 or ((3523 - (1249 + 19)) >= (3193 + 344))) then
				local v250 = 0 - 0;
				while true do
					if ((v250 == (1086 - (686 + 400))) or ((3011 + 826) < (1535 - (73 + 156)))) then
						v29 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 1 + 29);
						if (((3761 - (721 + 90)) == (34 + 2916)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if (v41 or ((15334 - 10611) < (3768 - (224 + 246)))) then
			local v156 = 0 - 0;
			while true do
				if (((2091 - 955) >= (28 + 126)) and (v156 == (1 + 0))) then
					v29 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 30 + 10);
					if (v29 or ((538 - 267) > (15800 - 11052))) then
						return v29;
					end
					break;
				end
				if (((5253 - (203 + 310)) >= (5145 - (1238 + 755))) and (v156 == (0 + 0))) then
					v29 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 1574 - (709 + 825));
					if (v29 or ((4750 - 2172) >= (4938 - 1548))) then
						return v29;
					end
					v156 = 865 - (196 + 668);
				end
			end
		end
		if (((161 - 120) <= (3440 - 1779)) and v42) then
			local v157 = 833 - (171 + 662);
			while true do
				if (((694 - (4 + 89)) < (12477 - 8917)) and ((1 + 1) == v157)) then
					v29 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 175 - 135);
					if (((93 + 142) < (2173 - (35 + 1451))) and v29) then
						return v29;
					end
					v157 = 1456 - (28 + 1425);
				end
				if (((6542 - (941 + 1052)) > (1106 + 47)) and (v157 == (1517 - (822 + 692)))) then
					v29 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 57 - 17);
					if (v29 or ((2202 + 2472) < (4969 - (45 + 252)))) then
						return v29;
					end
					break;
				end
				if (((3630 + 38) < (1570 + 2991)) and (v157 == (0 - 0))) then
					v29 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 473 - (114 + 319));
					if (v29 or ((652 - 197) == (4619 - 1014))) then
						return v29;
					end
					v157 = 1 + 0;
				end
				if ((v157 == (1 - 0)) or ((5579 - 2916) == (5275 - (556 + 1407)))) then
					v29 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 1246 - (741 + 465));
					if (((4742 - (170 + 295)) <= (2358 + 2117)) and v29) then
						return v29;
					end
					v157 = 2 + 0;
				end
			end
		end
		if (v43 or ((2141 - 1271) == (986 + 203))) then
			local v158 = 0 + 0;
			while true do
				if (((880 + 673) <= (4363 - (957 + 273))) and ((1 + 1) == v158)) then
					v29 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 17 + 23);
					if (v29 or ((8523 - 6286) >= (9252 - 5741))) then
						return v29;
					end
					v158 = 9 - 6;
				end
				if (((14 - 11) == v158) or ((3104 - (389 + 1391)) > (1895 + 1125))) then
					v29 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 5 + 35);
					if (v29 or ((6811 - 3819) == (2832 - (783 + 168)))) then
						return v29;
					end
					break;
				end
				if (((10424 - 7318) > (1502 + 24)) and (v158 == (312 - (309 + 2)))) then
					v29 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 122 - 82);
					if (((4235 - (1090 + 122)) < (1255 + 2615)) and v29) then
						return v29;
					end
					v158 = 6 - 4;
				end
				if (((98 + 45) > (1192 - (628 + 490))) and (v158 == (0 + 0))) then
					v29 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 99 - 59);
					if (((82 - 64) < (2886 - (431 + 343))) and v29) then
						return v29;
					end
					v158 = 1 - 0;
				end
			end
		end
		if (((3173 - 2076) <= (1287 + 341)) and v44) then
			local v159 = 0 + 0;
			while true do
				if (((6325 - (556 + 1139)) == (4645 - (6 + 9))) and ((1 + 0) == v159)) then
					v29 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 21 + 19);
					if (((3709 - (28 + 141)) > (1040 + 1643)) and v29) then
						return v29;
					end
					v159 = 2 - 0;
				end
				if (((3396 + 1398) >= (4592 - (486 + 831))) and (v159 == (5 - 3))) then
					v29 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 140 - 100);
					if (((281 + 1203) == (4692 - 3208)) and v29) then
						return v29;
					end
					v159 = 1266 - (668 + 595);
				end
				if (((1289 + 143) < (717 + 2838)) and (v159 == (0 - 0))) then
					v29 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 330 - (23 + 267));
					if (v29 or ((3009 - (1129 + 815)) > (3965 - (371 + 16)))) then
						return v29;
					end
					v159 = 1751 - (1326 + 424);
				end
				if ((v159 == (5 - 2)) or ((17522 - 12727) < (1525 - (88 + 30)))) then
					v29 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 811 - (720 + 51));
					if (((4121 - 2268) < (6589 - (421 + 1355))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
	end
	local function v131()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (2 + 1)) or ((3904 - (286 + 797)) < (8886 - 6455))) then
				if ((v90 and v125.AreUnitsBelowHealthPercentage(v52, v51) and v121.AncestralGuidance:IsReady()) or ((4760 - 1886) < (2620 - (397 + 42)))) then
					if (v24(v121.AncestralGuidance, not v15:IsInRange(13 + 27)) or ((3489 - (24 + 776)) <= (528 - 185))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v91 and v125.AreUnitsBelowHealthPercentage(v57, v56) and v121.Ascendance:IsReady()) or ((2654 - (222 + 563)) == (4426 - 2417))) then
					if (v24(v121.Ascendance, not v15:IsInRange(29 + 11)) or ((3736 - (23 + 167)) < (4120 - (690 + 1108)))) then
						return "ascendance cooldowns";
					end
				end
				v143 = 2 + 2;
			end
			if ((v143 == (2 + 0)) or ((2930 - (40 + 808)) == (786 + 3987))) then
				if (((12404 - 9160) > (1009 + 46)) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77) and v121.HealingTideTotem:IsReady()) then
					if (v24(v121.HealingTideTotem, not v15:IsInRange(22 + 18)) or ((1817 + 1496) <= (2349 - (47 + 524)))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v54, v53) and v121.AncestralProtectionTotem:IsReady()) or ((923 + 498) >= (5751 - 3647))) then
					if (((2708 - 896) <= (7409 - 4160)) and (v55 == "Player")) then
						if (((3349 - (1165 + 561)) <= (59 + 1898)) and v24(v122.AncestralProtectionTotemPlayer, not v15:IsInRange(123 - 83))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((1684 + 2728) == (4891 - (341 + 138))) and (v55 == "Friendly under Cursor")) then
						if (((473 + 1277) >= (1737 - 895)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((4698 - (89 + 237)) > (5951 - 4101)) and v24(v122.AncestralProtectionTotemCursor, not v15:IsInRange(84 - 44))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((1113 - (581 + 300)) < (2041 - (855 + 365))) and (v55 == "Confirmation")) then
						if (((1230 - 712) < (295 + 607)) and v24(v121.AncestralProtectionTotem, not v15:IsInRange(1275 - (1030 + 205)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v143 = 3 + 0;
			end
			if (((2786 + 208) > (1144 - (156 + 130))) and ((2 - 1) == v143)) then
				if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((6328 - 2573) <= (1874 - 959))) then
					if (((1040 + 2906) > (2183 + 1560)) and (v17:HealthPercentage() <= v82)) then
						if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((1404 - (10 + 59)) >= (936 + 2370))) then
							return "riptide healingcd";
						end
					end
				end
				if (((23855 - 19011) > (3416 - (671 + 492))) and v125.AreUnitsBelowHealthPercentage(v85, v84) and v121.SpiritLinkTotem:IsReady()) then
					if (((360 + 92) == (1667 - (369 + 846))) and (v86 == "Player")) then
						if (v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(11 + 29)) or ((3889 + 668) < (4032 - (1036 + 909)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((3081 + 793) == (6503 - 2629)) and (v86 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2141 - (11 + 192)) > (2494 + 2441))) then
							if (v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(215 - (135 + 40))) or ((10309 - 6054) < (2064 + 1359))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((3203 - 1749) <= (3733 - 1242)) and (v86 == "Confirmation")) then
						if (v24(v121.SpiritLinkTotem, not v15:IsInRange(216 - (50 + 126))) or ((11575 - 7418) <= (621 + 2182))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v143 = 1415 - (1233 + 180);
			end
			if (((5822 - (522 + 447)) >= (4403 - (107 + 1314))) and (v143 == (0 + 0))) then
				if (((12596 - 8462) > (1426 + 1931)) and v110 and ((v31 and v109) or not v109)) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (3 - 2)) or ((5327 - (716 + 1194)) < (44 + 2490))) then
							v29 = v125.HandleBottomTrinket(v124, v31, 5 + 35, nil);
							if (v29 or ((3225 - (74 + 429)) <= (315 - 151))) then
								return v29;
							end
							break;
						end
						if (((0 + 0) == v252) or ((5512 - 3104) < (1493 + 616))) then
							v29 = v125.HandleTopTrinket(v124, v31, 123 - 83, nil);
							if (v29 or ((81 - 48) == (1888 - (279 + 154)))) then
								return v29;
							end
							v252 = 779 - (454 + 324);
						end
					end
				end
				if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((349 + 94) >= (4032 - (12 + 5)))) then
					if (((1824 + 1558) > (422 - 256)) and (v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) then
						if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((104 + 176) == (4152 - (277 + 816)))) then
							return "riptide healingcd tank";
						end
					end
				end
				v143 = 4 - 3;
			end
			if (((3064 - (1058 + 125)) > (243 + 1050)) and (v143 == (979 - (815 + 160)))) then
				if (((10112 - 7755) == (5594 - 3237)) and v101 and (v13:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) then
					if (((30 + 93) == (359 - 236)) and v24(v121.ManaTideTotem, not v15:IsInRange(1938 - (41 + 1857)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v108 and v31) or not v108)) or ((2949 - (1222 + 671)) >= (8766 - 5374))) then
					local v253 = 0 - 0;
					while true do
						if ((v253 == (1184 - (229 + 953))) or ((2855 - (1111 + 663)) < (2654 - (874 + 705)))) then
							if (v121.Fireblood:IsReady() or ((147 + 902) >= (3024 + 1408))) then
								if (v24(v121.Fireblood, not v15:IsInRange(83 - 43)) or ((135 + 4633) <= (1525 - (642 + 37)))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if ((v253 == (1 + 0)) or ((538 + 2820) <= (3565 - 2145))) then
							if (v121.Berserking:IsReady() or ((4193 - (233 + 221)) <= (6948 - 3943))) then
								if (v24(v121.Berserking, not v15:IsInRange(36 + 4)) or ((3200 - (718 + 823)) >= (1343 + 791))) then
									return "Berserking cooldowns";
								end
							end
							if (v121.BloodFury:IsReady() or ((4065 - (266 + 539)) < (6667 - 4312))) then
								if (v24(v121.BloodFury, not v15:IsInRange(1265 - (636 + 589))) or ((1587 - 918) == (8709 - 4486))) then
									return "BloodFury cooldowns";
								end
							end
							v253 = 2 + 0;
						end
						if ((v253 == (0 + 0)) or ((2707 - (657 + 358)) < (1556 - 968))) then
							if (v121.AncestralCall:IsReady() or ((10928 - 6131) < (4838 - (1151 + 36)))) then
								if (v24(v121.AncestralCall, not v15:IsInRange(39 + 1)) or ((1099 + 3078) > (14484 - 9634))) then
									return "AncestralCall cooldowns";
								end
							end
							if (v121.BagofTricks:IsReady() or ((2232 - (1552 + 280)) > (1945 - (64 + 770)))) then
								if (((2072 + 979) > (2281 - 1276)) and v24(v121.BagofTricks, not v15:IsInRange(8 + 32))) then
									return "BagofTricks cooldowns";
								end
							end
							v253 = 1244 - (157 + 1086);
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
			if (((16174 - 12481) <= (6721 - 2339)) and (v144 == (3 - 0))) then
				if ((v103 and v13:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87) and v121.SpiritwalkersGrace:IsReady()) or ((4101 - (599 + 220)) > (8164 - 4064))) then
					if (v24(v121.SpiritwalkersGrace, nil) or ((5511 - (1813 + 118)) < (2079 + 765))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((1306 - (841 + 376)) < (6291 - 1801)) and v97 and v125.AreUnitsBelowHealthPercentage(v75, v74) and v121.HealingStreamTotem:IsReady()) then
					if (v24(v121.HealingStreamTotem, nil) or ((1158 + 3825) < (4934 - 3126))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if (((4688 - (464 + 395)) > (9672 - 5903)) and (v144 == (1 + 1))) then
				if (((2322 - (467 + 370)) <= (6001 - 3097)) and v125.AreUnitsBelowHealthPercentage(v64, v63) and v121.Downpour:IsReady()) then
					if (((3134 + 1135) == (14634 - 10365)) and (v65 == "Player")) then
						if (((61 + 326) <= (6472 - 3690)) and v24(v122.DownpourPlayer, not v15:IsInRange(560 - (150 + 370)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v65 == "Friendly under Cursor") or ((3181 - (74 + 1208)) <= (2254 - 1337))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((20450 - 16138) <= (624 + 252))) then
							if (((2622 - (14 + 376)) <= (4502 - 1906)) and v24(v122.DownpourCursor, not v15:IsInRange(26 + 14), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((1841 + 254) < (3516 + 170)) and (v65 == "Confirmation")) then
						if (v24(v121.Downpour, not v15:IsInRange(117 - 77), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1200 + 395) >= (4552 - (23 + 55)))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v94 and v125.AreUnitsBelowHealthPercentage(v62, v61) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (23 - 13))) or ((3083 + 1536) < (2589 + 293))) then
					if (v24(v121.CloudburstTotem) or ((455 - 161) >= (1520 + 3311))) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((2930 - (652 + 249)) <= (8253 - 5169)) and v105 and v125.AreUnitsBelowHealthPercentage(v107, v106) and v121.Wellspring:IsReady()) then
					if (v24(v121.Wellspring, not v15:IsInRange(1908 - (708 + 1160)), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5529 - 3492) == (4412 - 1992))) then
						return "wellspring healingaoe";
					end
				end
				if (((4485 - (10 + 17)) > (877 + 3027)) and v93 and v125.AreUnitsBelowHealthPercentage(v60, v59) and v121.ChainHeal:IsReady()) then
					if (((2168 - (1400 + 332)) >= (235 - 112)) and v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v144 = 1911 - (242 + 1666);
			end
			if (((214 + 286) < (666 + 1150)) and (v144 == (0 + 0))) then
				if (((4514 - (850 + 90)) == (6259 - 2685)) and v93 and v125.AreUnitsBelowHealthPercentage(1485 - (360 + 1030), 3 + 0) and v121.ChainHeal:IsReady() and v13:BuffUp(v121.HighTide)) then
					if (((623 - 402) < (536 - 146)) and v24(v122.ChainHealFocus, not v17:IsSpellInRange(v121.ChainHeal), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v100 and (v17:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (1676 - (909 + 752)))) or ((3436 - (109 + 1114)) <= (2601 - 1180))) then
					if (((1191 + 1867) < (5102 - (6 + 236))) and v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((817 + 479) >= (3579 + 867))) then
					if (((v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) or ((3285 - 1892) > (7840 - 3351))) then
						if (v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide)) or ((5557 - (1076 + 57)) < (5 + 22))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((2686 - (579 + 110)) > (302 + 3513))) then
					if (((3064 + 401) > (1016 + 897)) and (v17:HealthPercentage() <= v82)) then
						if (((1140 - (174 + 233)) < (5080 - 3261)) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v144 = 1 - 0;
			end
			if ((v144 == (1 + 0)) or ((5569 - (663 + 511)) == (4243 + 512))) then
				if ((v104 and v121.UnleashLife:IsReady()) or ((824 + 2969) < (7303 - 4934))) then
					if ((v17:HealthPercentage() <= v89) or ((2474 + 1610) == (623 - 358))) then
						if (((10549 - 6191) == (2080 + 2278)) and v24(v121.UnleashLife, not v17:IsSpellInRange(v121.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71)) or ((6107 - 2969) < (708 + 285))) then
					if (((305 + 3025) > (3045 - (478 + 244))) and v24(v122.HealingRainCursor, not v15:IsInRange(557 - (440 + 77)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v72, v71) and v121.HealingRain:IsReady()) or ((1649 + 1977) == (14599 - 10610))) then
					if ((v73 == "Player") or ((2472 - (655 + 901)) == (496 + 2175))) then
						if (((209 + 63) == (184 + 88)) and v24(v122.HealingRainPlayer, not v15:IsInRange(161 - 121), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((5694 - (695 + 750)) <= (16523 - 11684)) and (v73 == "Friendly under Cursor")) then
						if (((4285 - 1508) < (12869 - 9669)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((446 - (285 + 66)) < (4561 - 2604)) and v24(v122.HealingRainCursor, not v15:IsInRange(1350 - (682 + 628)), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((134 + 692) < (2016 - (176 + 123))) and (v73 == "Enemy under Cursor")) then
						if (((597 + 829) >= (802 + 303)) and v16:Exists() and v13:CanAttack(v16)) then
							if (((3023 - (239 + 30)) <= (919 + 2460)) and v24(v122.HealingRainCursor, not v15:IsInRange(39 + 1), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v73 == "Confirmation") or ((6950 - 3023) == (4407 - 2994))) then
						if (v24(v121.HealingRain, not v15:IsInRange(355 - (306 + 9)), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((4026 - 2872) <= (138 + 650))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v69, v68) and v121.EarthenWallTotem:IsReady()) or ((1009 + 634) > (1627 + 1752))) then
					if ((v70 == "Player") or ((8015 - 5212) > (5924 - (1140 + 235)))) then
						if (v24(v122.EarthenWallTotemPlayer, not v15:IsInRange(26 + 14)) or ((202 + 18) >= (776 + 2246))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((2874 - (33 + 19)) == (1019 + 1803)) and (v70 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((3180 - 2119) == (819 + 1038))) then
							if (((5412 - 2652) > (1279 + 85)) and v24(v122.EarthenWallTotemCursor, not v15:IsInRange(729 - (586 + 103)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((447 + 4455) <= (11067 - 7472))) then
						if (v24(v121.EarthenWallTotem, not v15:IsInRange(1528 - (1309 + 179))) or ((6953 - 3101) == (128 + 165))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v144 = 5 - 3;
			end
		end
	end
	local function v133()
		if ((v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) or ((1178 + 381) == (9747 - 5159))) then
			if ((v17:HealthPercentage() <= v82) or ((8934 - 4450) == (1397 - (295 + 314)))) then
				if (((11219 - 6651) >= (5869 - (1300 + 662))) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((3912 - 2666) < (5225 - (1178 + 577))) and v102 and v13:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v17:BuffDown(v121.Riptide)) then
			if (((2113 + 1955) >= (2873 - 1901)) and (v17:HealthPercentage() <= v83) and (v125.UnitGroupRole(v17) == "TANK")) then
				if (((1898 - (851 + 554)) < (3443 + 450)) and v24(v122.RiptideFocus, not v17:IsSpellInRange(v121.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v121.ElementalOrbit:IsAvailable() and v13:BuffDown(v121.EarthShieldBuff) and not v15:IsAPlayer() and v121.EarthShield:IsCastable()) or ((4085 - 2612) >= (7236 - 3904))) then
			local v160 = 302 - (115 + 187);
			while true do
				if ((v160 == (1 + 0)) or ((3836 + 215) <= (4559 - 3402))) then
					if (((1765 - (160 + 1001)) < (2521 + 360)) and v24(v122.EarthShieldFocus)) then
						return "earth_shield player healingst";
					end
					break;
				end
				if ((v160 == (0 + 0)) or ((1842 - 942) == (3735 - (237 + 121)))) then
					v29 = v125.FocusSpecifiedUnit(v125.NamedUnit(937 - (525 + 372), v13:Name(), 47 - 22), 98 - 68);
					if (((4601 - (96 + 46)) > (1368 - (643 + 134))) and v29) then
						return v29;
					end
					v160 = 1 + 0;
				end
			end
		end
		if (((8147 - 4749) >= (8891 - 6496)) and v121.ElementalOrbit:IsAvailable() and v13:BuffUp(v121.EarthShieldBuff)) then
			if (v125.IsSoloMode() or ((2094 + 89) >= (5541 - 2717))) then
				if (((3957 - 2021) == (2655 - (316 + 403))) and v121.LightningShield:IsReady() and v13:BuffDown(v121.LightningShield)) then
					if (v24(v121.LightningShield) or ((3212 + 1620) < (11857 - 7544))) then
						return "lightning_shield healingst";
					end
				end
			elseif (((1478 + 2610) > (9755 - 5881)) and v121.WaterShield:IsReady() and v13:BuffDown(v121.WaterShield)) then
				if (((3070 + 1262) == (1397 + 2935)) and v24(v121.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if (((13856 - 9857) >= (13849 - 10949)) and v98 and v121.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v76) or ((5245 - 2720) > (233 + 3831))) then
				if (((8604 - 4233) == (214 + 4157)) and v24(v122.HealingSurgeFocus, not v17:IsSpellInRange(v121.HealingSurge), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v100 and v121.HealingWave:IsReady()) or ((782 - 516) > (5003 - (12 + 5)))) then
			if (((7733 - 5742) >= (1973 - 1048)) and (v17:HealthPercentage() <= v79)) then
				if (((967 - 512) < (5091 - 3038)) and v24(v122.HealingWaveFocus, not v17:IsSpellInRange(v121.HealingWave), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v134()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (1975 - (1656 + 317))) or ((737 + 89) == (3888 + 963))) then
				if (((486 - 303) == (900 - 717)) and v121.LightningBolt:IsReady()) then
					if (((1513 - (5 + 349)) <= (8492 - 6704)) and v24(v121.LightningBolt, not v15:IsSpellInRange(v121.LightningBolt), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v145 == (1271 - (266 + 1005))) or ((2311 + 1196) > (14733 - 10415))) then
				if (v121.Stormkeeper:IsReady() or ((4048 - 973) <= (4661 - (561 + 1135)))) then
					if (((1778 - 413) <= (6610 - 4599)) and v24(v121.Stormkeeper, not v15:IsInRange(1106 - (507 + 559)))) then
						return "stormkeeper damage";
					end
				end
				if ((math.max(#v13:GetEnemiesInRange(50 - 30), v13:GetEnemiesInSplashRangeCount(24 - 16)) > (390 - (212 + 176))) or ((3681 - (250 + 655)) > (9748 - 6173))) then
					if (v121.ChainLightning:IsReady() or ((4462 - 1908) == (7515 - 2711))) then
						if (((4533 - (1869 + 87)) == (8938 - 6361)) and v24(v121.ChainLightning, not v15:IsSpellInRange(v121.ChainLightning), v13:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v145 = 1902 - (484 + 1417);
			end
			if ((v145 == (2 - 1)) or ((9 - 3) >= (2662 - (48 + 725)))) then
				if (((826 - 320) <= (5075 - 3183)) and v121.FlameShock:IsReady()) then
					local v254 = 0 + 0;
					while true do
						if ((v254 == (0 - 0)) or ((562 + 1446) > (647 + 1571))) then
							if (((1232 - (152 + 701)) <= (5458 - (430 + 881))) and v125.CastCycle(v121.FlameShock, v13:GetEnemiesInRange(16 + 24), v128, not v15:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v24(v121.FlameShock, not v15:IsSpellInRange(v121.FlameShock)) or ((5409 - (557 + 338)) <= (299 + 710))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v121.LavaBurst:IsReady() or ((9851 - 6355) == (4173 - 2981))) then
					if (v24(v121.LavaBurst, not v15:IsSpellInRange(v121.LavaBurst), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((552 - 344) == (6376 - 3417))) then
						return "lava_burst damage";
					end
				end
				v145 = 803 - (499 + 302);
			end
		end
	end
	local function v135()
		local v146 = 866 - (39 + 827);
		while true do
			if (((11806 - 7529) >= (2931 - 1618)) and (v146 == (31 - 23))) then
				v104 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((3971 - 1384) < (272 + 2902)) and (v146 == (5 - 3))) then
				v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v71 = EpicSettings.Settings['HealingRainGroup'];
				v72 = EpicSettings.Settings['HealingRainHP'];
				v73 = EpicSettings.Settings['HealingRainUsage'];
				v146 = 1 + 2;
			end
			if ((v146 == (9 - 3)) or ((4224 - (103 + 1)) <= (2752 - (475 + 79)))) then
				v93 = EpicSettings.Settings['UseChainHeal'];
				v94 = EpicSettings.Settings['UseCloudburstTotem'];
				v96 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v97 = EpicSettings.Settings['UseHealingStreamTotem'];
				v98 = EpicSettings.Settings['UseHealingSurge'];
				v146 = 14 - 7;
			end
			if ((v146 == (12 - 8)) or ((207 + 1389) == (756 + 102))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['RiptideHP'];
				v83 = EpicSettings.Settings['RiptideTankHP'];
				v146 = 1508 - (1395 + 108);
			end
			if (((9370 - 6150) == (4424 - (7 + 1197))) and (v146 == (4 + 3))) then
				v99 = EpicSettings.Settings['UseHealingTideTotem'];
				v100 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v102 = EpicSettings.Settings['UseRiptide'];
				v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v146 = 3 + 5;
			end
			if ((v146 == (319 - (27 + 292))) or ((4108 - 2706) > (4616 - 996))) then
				v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v59 = EpicSettings.Settings['ChainHealGroup'];
				v60 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v146 = 4 - 3;
			end
			if (((5075 - 2501) == (4901 - 2327)) and (v146 == (140 - (43 + 96)))) then
				v46 = EpicSettings.Settings['DispelBuffs'];
				v63 = EpicSettings.Settings['DownpourGroup'];
				v64 = EpicSettings.Settings['DownpourHP'];
				v65 = EpicSettings.Settings['DownpourUsage'];
				v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v69 = EpicSettings.Settings['EarthenWallTotemHP'];
				v146 = 8 - 6;
			end
			if (((4064 - 2266) < (2288 + 469)) and (v146 == (2 + 3))) then
				v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v89 = EpicSettings.Settings['UnleashLifeHP'];
				v146 = 11 - 5;
			end
			if ((v146 == (2 + 1)) or ((705 - 328) > (820 + 1784))) then
				v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v75 = EpicSettings.Settings['HealingStreamTotemHP'];
				v76 = EpicSettings.Settings['HealingSurgeHP'];
				v77 = EpicSettings.Settings['HealingTideTotemGroup'];
				v78 = EpicSettings.Settings['HealingTideTotemHP'];
				v79 = EpicSettings.Settings['HealingWaveHP'];
				v146 = 1 + 3;
			end
		end
	end
	local function v136()
		local v147 = 1751 - (1414 + 337);
		while true do
			if (((2508 - (1642 + 298)) < (2374 - 1463)) and (v147 == (0 - 0))) then
				v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v52 = EpicSettings.Settings['AncestralGuidanceHP'];
				v56 = EpicSettings.Settings['AscendanceGroup'];
				v57 = EpicSettings.Settings['AscendanceHP'];
				v58 = EpicSettings.Settings['AstralShiftHP'];
				v147 = 2 - 1;
			end
			if (((1082 + 2203) < (3290 + 938)) and (v147 == (977 - (357 + 615)))) then
				v111 = EpicSettings.Settings['fightRemainsCheck'];
				v112 = EpicSettings.Settings['handleAfflicted'];
				v113 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v147 = 5 + 1;
			end
			if (((9608 - 5692) > (2852 + 476)) and (v147 == (6 - 3))) then
				v101 = EpicSettings.Settings['UseManaTideTotem'];
				v105 = EpicSettings.Settings['UseWellspring'];
				v106 = EpicSettings.Settings['WellspringGroup'];
				v107 = EpicSettings.Settings['WellspringHP'];
				v116 = EpicSettings.Settings['useManaPotion'];
				v147 = 4 + 0;
			end
			if (((170 + 2330) < (2414 + 1425)) and ((1302 - (384 + 917)) == v147)) then
				v61 = EpicSettings.Settings['CloudburstTotemGroup'];
				v62 = EpicSettings.Settings['CloudburstTotemHP'];
				v66 = EpicSettings.Settings['EarthElementalHP'];
				v67 = EpicSettings.Settings['EarthElementalTankHP'];
				v80 = EpicSettings.Settings['ManaTideTotemMana'];
				v147 = 699 - (128 + 569);
			end
			if (((2050 - (1407 + 136)) == (2394 - (687 + 1200))) and (v147 == (1714 - (556 + 1154)))) then
				v117 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v109 = EpicSettings.Settings['trinketsWithCD'];
				v110 = EpicSettings.Settings['useTrinkets'];
				v147 = 17 - 12;
			end
			if (((335 - (9 + 86)) <= (3586 - (275 + 146))) and (v147 == (1 + 5))) then
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((898 - (29 + 35)) >= (3567 - 2762)) and (v147 == (5 - 3))) then
				v81 = EpicSettings.Settings['PrimordialWaveHP'];
				v90 = EpicSettings.Settings['UseAncestralGuidance'];
				v91 = EpicSettings.Settings['UseAscendance'];
				v92 = EpicSettings.Settings['UseAstralShift'];
				v95 = EpicSettings.Settings['UseEarthElemental'];
				v147 = 13 - 10;
			end
		end
	end
	local v137 = 0 + 0;
	local function v138()
		local v148 = 1012 - (53 + 959);
		local v149;
		while true do
			if ((v148 == (413 - (312 + 96))) or ((6615 - 2803) < (2601 - (147 + 138)))) then
				if ((v13:AffectingCombat() and v125.TargetIsValid()) or ((3551 - (813 + 86)) <= (1386 + 147))) then
					local v255 = 0 - 0;
					while true do
						if ((v255 == (492 - (18 + 474))) or ((1214 + 2384) < (4765 - 3305))) then
							if ((v116 and v123.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v117)) or ((5202 - (860 + 226)) < (1495 - (121 + 182)))) then
								if (v24(v122.ManaPotion, nil) or ((416 + 2961) <= (2143 - (988 + 252)))) then
									return "Mana Potion main";
								end
							end
							v29 = v125.Interrupt(v121.WindShear, 4 + 26, true);
							if (((1246 + 2730) >= (2409 - (49 + 1921))) and v29) then
								return v29;
							end
							v29 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 920 - (223 + 667), true, v16);
							v255 = 53 - (51 + 1);
						end
						if (((6457 - 2705) == (8033 - 4281)) and (v255 == (1127 - (146 + 979)))) then
							if (((1142 + 2904) > (3300 - (311 + 294))) and v149) then
								return v149;
							end
							if ((v121.GreaterPurge:IsAvailable() and v47 and v121.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) or ((9885 - 6340) == (1355 + 1842))) then
								if (((3837 - (496 + 947)) > (1731 - (1233 + 125))) and v24(v121.GreaterPurge, not v15:IsSpellInRange(v121.GreaterPurge))) then
									return "greater_purge utility";
								end
							end
							if (((1687 + 2468) <= (3797 + 435)) and v121.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
								if (v24(v121.Purge, not v15:IsSpellInRange(v121.Purge)) or ((681 + 2900) == (5118 - (963 + 682)))) then
									return "purge utility";
								end
							end
							if (((4169 + 826) > (4852 - (504 + 1000))) and (v119 > v111)) then
								local v262 = 0 + 0;
								while true do
									if (((0 + 0) == v262) or ((72 + 682) > (5490 - 1766))) then
										v149 = v131();
										if (((186 + 31) >= (34 + 23)) and v149) then
											return v149;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v255 == (183 - (156 + 26))) or ((1193 + 877) >= (6316 - 2279))) then
							if (((2869 - (149 + 15)) == (3665 - (890 + 70))) and v29) then
								return v29;
							end
							v29 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 147 - (39 + 78), nil, v16);
							if (((543 - (14 + 468)) == (134 - 73)) and v29) then
								return v29;
							end
							v149 = v129();
							v255 = 5 - 3;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((361 + 338) >= (779 + 517))) then
					local v256 = 0 + 0;
					while true do
						if ((v256 == (1 + 0)) or ((468 + 1315) >= (6921 - 3305))) then
							if (((v17:HealthPercentage() < v81) and v17:BuffDown(v121.Riptide)) or ((3868 + 45) > (15907 - 11380))) then
								if (((111 + 4265) > (868 - (12 + 39))) and v121.PrimordialWaveResto:IsCastable()) then
									if (((4523 + 338) > (2550 - 1726)) and v24(v122.PrimordialWaveFocus, not v17:IsSpellInRange(v121.PrimordialWaveResto))) then
										return "primordial_wave main";
									end
								end
							end
							if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (10 - 7)))) or ((410 + 973) >= (1122 + 1009))) then
								if (v24(v121.TotemicRecall, nil) or ((4756 - 2880) >= (1693 + 848))) then
									return "totemic_recall main";
								end
							end
							v256 = 9 - 7;
						end
						if (((3492 - (1596 + 114)) <= (9847 - 6075)) and (v256 == (713 - (164 + 549)))) then
							if ((v32 and v45) or ((6138 - (1059 + 379)) < (1008 - 195))) then
								local v263 = 0 + 0;
								while true do
									if (((540 + 2659) < (4442 - (145 + 247))) and (v263 == (0 + 0))) then
										if ((v121.Bursting:MaxDebuffStack() > (2 + 2)) or ((14678 - 9727) < (850 + 3580))) then
											local v267 = 0 + 0;
											while true do
												if (((155 - 59) == (816 - (254 + 466))) and (v267 == (560 - (544 + 16)))) then
													v29 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
													if (v29 or ((8704 - 5965) > (4636 - (294 + 334)))) then
														return v29;
													end
													break;
												end
											end
										end
										if (v17 or ((276 - (236 + 17)) == (489 + 645))) then
											if ((v121.PurifySpirit:IsReady() and v125.DispellableFriendlyUnit(20 + 5)) or ((10141 - 7448) >= (19463 - 15352))) then
												local v268 = 0 + 0;
												while true do
													if ((v268 == (0 + 0)) or ((5110 - (413 + 381)) <= (91 + 2055))) then
														if ((v137 == (0 - 0)) or ((9211 - 5665) <= (4779 - (582 + 1388)))) then
															v137 = GetTime();
														end
														if (((8355 - 3451) > (1551 + 615)) and v125.Wait(864 - (326 + 38), v137)) then
															local v269 = 0 - 0;
															while true do
																if (((154 - 45) >= (710 - (47 + 573))) and (v269 == (0 + 0))) then
																	if (((21141 - 16163) > (4714 - 1809)) and v24(v122.PurifySpiritFocus, not v17:IsSpellInRange(v121.PurifySpirit))) then
																		return "purify_spirit dispel focus";
																	end
																	v137 = 1664 - (1269 + 395);
																	break;
																end
															end
														end
														break;
													end
												end
											end
										end
										v263 = 493 - (76 + 416);
									end
									if ((v263 == (444 - (319 + 124))) or ((6916 - 3890) <= (3287 - (564 + 443)))) then
										if ((v16 and v16:Exists() and v16:IsAPlayer() and v125.UnitHasDispellableDebuffByPlayer(v16)) or ((4575 - 2922) <= (1566 - (337 + 121)))) then
											if (((8523 - 5614) > (8690 - 6081)) and v121.PurifySpirit:IsCastable()) then
												if (((2668 - (1261 + 650)) > (83 + 111)) and v24(v122.PurifySpiritMouseover, not v16:IsSpellInRange(v121.PurifySpirit))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							if ((v121.Bursting:AuraActiveCount() > (3 - 0)) or ((1848 - (772 + 1045)) >= (198 + 1200))) then
								local v264 = 144 - (102 + 42);
								while true do
									if (((5040 - (1524 + 320)) <= (6142 - (1049 + 221))) and (v264 == (156 - (18 + 138)))) then
										if (((8141 - 4815) == (4428 - (67 + 1035))) and (v121.Bursting:MaxDebuffStack() > (353 - (136 + 212))) and v121.SpiritLinkTotem:IsReady()) then
											if (((6089 - 4656) <= (3107 + 771)) and (v86 == "Player")) then
												if (v24(v122.SpiritLinkTotemPlayer, not v15:IsInRange(37 + 3)) or ((3187 - (240 + 1364)) == (2817 - (1050 + 32)))) then
													return "spirit_link_totem bursting";
												end
											elseif ((v86 == "Friendly under Cursor") or ((10643 - 7662) == (1391 + 959))) then
												if ((v16:Exists() and not v13:CanAttack(v16)) or ((5521 - (331 + 724)) <= (40 + 453))) then
													if (v24(v122.SpiritLinkTotemCursor, not v15:IsInRange(684 - (269 + 375))) or ((3272 - (267 + 458)) <= (618 + 1369))) then
														return "spirit_link_totem bursting";
													end
												end
											elseif (((5693 - 2732) > (3558 - (667 + 151))) and (v86 == "Confirmation")) then
												if (((5193 - (1410 + 87)) >= (5509 - (1504 + 393))) and v24(v121.SpiritLinkTotem, not v15:IsInRange(108 - 68))) then
													return "spirit_link_totem bursting";
												end
											end
										end
										if ((v93 and v121.ChainHeal:IsReady()) or ((7705 - 4735) == (2674 - (461 + 335)))) then
											if (v24(v122.ChainHealFocus, nil) or ((472 + 3221) < (3738 - (1730 + 31)))) then
												return "Chain Heal Spam because of Bursting";
											end
										end
										break;
									end
								end
							end
							v256 = 1668 - (728 + 939);
						end
						if ((v256 == (6 - 4)) or ((1886 - 956) > (4813 - 2712))) then
							if (((5221 - (138 + 930)) > (2821 + 265)) and v33) then
								local v265 = 0 + 0;
								while true do
									if ((v265 == (0 + 0)) or ((19003 - 14349) <= (5816 - (459 + 1307)))) then
										v149 = v132();
										if (v149 or ((4472 - (474 + 1396)) < (2612 - 1116))) then
											return v149;
										end
										v265 = 1 + 0;
									end
									if ((v265 == (1 + 0)) or ((2921 - 1901) > (290 + 1998))) then
										v149 = v133();
										if (((1094 - 766) == (1430 - 1102)) and v149) then
											return v149;
										end
										break;
									end
								end
							end
							if (((2102 - (562 + 29)) < (3247 + 561)) and v34) then
								if (v125.TargetIsValid() or ((3929 - (374 + 1045)) > (3894 + 1025))) then
									local v266 = 0 - 0;
									while true do
										if (((5401 - (448 + 190)) == (1538 + 3225)) and (v266 == (0 + 0))) then
											v149 = v134();
											if (((2696 + 1441) > (7105 - 5257)) and v149) then
												return v149;
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
			if (((7568 - 5132) <= (4628 - (1307 + 187))) and (v148 == (0 - 0))) then
				v135();
				v136();
				v30 = EpicSettings.Toggles['ooc'];
				v148 = 2 - 1;
			end
			if (((11415 - 7692) == (4406 - (232 + 451))) and (v148 == (1 + 0))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v148 = 2 + 0;
			end
			if ((v148 == (566 - (510 + 54))) or ((8151 - 4105) >= (4352 - (13 + 23)))) then
				v34 = EpicSettings.Toggles['dps'];
				v149 = nil;
				if (v13:IsDeadOrGhost() or ((3913 - 1905) < (2771 - 842))) then
					return;
				end
				v148 = 4 - 1;
			end
			if (((3472 - (830 + 258)) > (6261 - 4486)) and (v148 == (3 + 1))) then
				if (v149 or ((3866 + 677) <= (5817 - (860 + 581)))) then
					return v149;
				end
				if (((2685 - 1957) == (578 + 150)) and (v13:AffectingCombat() or v30)) then
					local v257 = v45 and v121.PurifySpirit:IsReady() and v32;
					if ((v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 266 - (237 + 4)) < (2 - 1))) or ((2721 - 1645) > (8856 - 4185))) then
						v29 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 13 + 2, 23 + 17, "TANK", true, 94 - 69);
						if (((795 + 1056) >= (206 + 172)) and v29) then
							return v29;
						end
						if ((v125.UnitGroupRole(v17) == "TANK") or ((3374 - (85 + 1341)) >= (5931 - 2455))) then
							if (((13539 - 8745) >= (1205 - (45 + 327))) and v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					if (((7718 - 3628) == (4592 - (444 + 58))) and (not v17:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v17) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 11 + 14) >= (1 + 0)))) then
						local v259 = 0 + 0;
						while true do
							if ((v259 == (0 - 0)) or ((5490 - (64 + 1668)) == (4471 - (1227 + 746)))) then
								v29 = v125.FocusUnit(v257, nil, 122 - 82, nil, 46 - 21);
								if (v29 or ((3167 - (415 + 79)) < (41 + 1534))) then
									return v29;
								end
								break;
							end
						end
					end
					v29 = v125.FocusSpecifiedUnit(v125.FriendlyUnitWithHealAbsorb(531 - (142 + 349), nil, 11 + 14), 41 - 11);
					if (v29 or ((1850 + 1871) <= (1026 + 429))) then
						return v29;
					end
				end
				if (((2543 - 1609) < (4134 - (1710 + 154))) and v121.EarthShield:IsCastable() and v96 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(358 - (200 + 118)) and (v125.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v121.EarthShield))) then
					if (v24(v122.EarthShieldFocus, not v17:IsSpellInRange(v121.EarthShield)) or ((639 + 973) == (2194 - 939))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v148 = 7 - 2;
			end
			if (((3 + 0) == v148) or ((4305 + 47) < (2258 + 1948))) then
				if (v125.TargetIsValid() or v13:AffectingCombat() or ((457 + 2403) <= (392 - 211))) then
					local v258 = 1250 - (363 + 887);
					while true do
						if (((5625 - 2403) >= (7268 - 5741)) and (v258 == (1 + 0))) then
							v119 = v118;
							if (((3521 - 2016) <= (1450 + 671)) and (v119 == (12775 - (674 + 990)))) then
								v119 = v10.FightRemains(v120, false);
							end
							break;
						end
						if (((214 + 530) == (305 + 439)) and (v258 == (0 - 0))) then
							v120 = v13:GetEnemiesInRange(1095 - (507 + 548));
							v118 = v10.BossFightRemains(nil, true);
							v258 = 838 - (289 + 548);
						end
					end
				end
				if (not v13:AffectingCombat() or ((3797 - (821 + 997)) >= (3091 - (195 + 60)))) then
					if (((493 + 1340) <= (4169 - (251 + 1250))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v260 = 0 - 0;
						local v261;
						while true do
							if (((2533 + 1153) == (4718 - (809 + 223))) and (v260 == (0 - 0))) then
								v261 = v125.DeadFriendlyUnitsCount();
								if (((10411 - 6944) > (1577 - 1100)) and (v261 > (1 + 0))) then
									if (v24(v121.AncestralVision, nil, v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1722 + 1566) >= (4158 - (14 + 603)))) then
										return "ancestral_vision";
									end
								elseif (v24(v122.AncestralSpiritMouseover, not v15:IsInRange(169 - (118 + 11)), v13:BuffDown(v121.SpiritwalkersGraceBuff)) or ((576 + 2981) == (3782 + 758))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v149 = v130();
				v148 = 11 - 7;
			end
		end
	end
	local function v139()
		local v150 = 949 - (551 + 398);
		while true do
			if ((v150 == (0 + 0)) or ((93 + 168) > (1030 + 237))) then
				v127();
				v121.Bursting:RegisterAuraTracking();
				v150 = 3 - 2;
			end
			if (((2930 - 1658) < (1251 + 2607)) and (v150 == (3 - 2))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(73 + 191, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

