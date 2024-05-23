local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((6207 - (159 + 1342)) >= (3177 - 2214)) and not v5) then
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
	local v118 = 12259 - (556 + 592);
	local v119 = 3952 + 7159;
	local v120;
	v9:RegisterForEvent(function()
		local v140 = 808 - (329 + 479);
		while true do
			if ((v140 == (854 - (174 + 680))) or ((3298 - 2338) <= (1815 - 939))) then
				v118 = 7933 + 3178;
				v119 = 11850 - (396 + 343);
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
		if (v121.ImprovedPurifySpirit:IsAvailable() or ((183 + 1883) == (2409 - (29 + 1448)))) then
			v125.DispellableDebuffs = v20.MergeTable(v125.DispellableMagicDebuffs, v125.DispellableCurseDebuffs);
		else
			v125.DispellableDebuffs = v125.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v127();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v128(v141)
		return v141:DebuffRefreshable(v121.FlameShockDebuff) and (v119 > (1394 - (135 + 1254)));
	end
	local function v129()
		if (((18176 - 13351) < (22612 - 17769)) and v92 and v121.AstralShift:IsReady()) then
			if ((v12:HealthPercentage() <= v58) or ((2584 + 1293) >= (6064 - (389 + 1138)))) then
				if (v23(v121.AstralShift, not v14:IsInRange(614 - (102 + 472))) or ((4073 + 242) < (958 + 768))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v95 and v121.EarthElemental:IsReady()) or ((3431 + 248) < (2170 - (320 + 1225)))) then
			if ((v12:HealthPercentage() <= v66) or v125.IsTankBelowHealthPercentage(v67, 44 - 19, v121.ChainHeal) or ((2830 + 1795) < (2096 - (157 + 1307)))) then
				if (v23(v121.EarthElemental, not v14:IsInRange(1899 - (821 + 1038))) or ((207 - 124) > (195 + 1585))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((969 - 423) <= (401 + 676)) and v123.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) then
			if (v23(v122.Healthstone) or ((2468 - 1472) > (5327 - (834 + 192)))) then
				return "healthstone defensive 3";
			end
		end
		if (((259 + 3811) > (177 + 510)) and v37 and (v12:HealthPercentage() <= v38)) then
			local v155 = 0 + 0;
			while true do
				if ((v155 == (1 - 0)) or ((960 - (300 + 4)) >= (890 + 2440))) then
					if ((v39 == "Potion of Withering Dreams") or ((6523 - 4031) <= (697 - (112 + 250)))) then
						if (((1723 + 2599) >= (6418 - 3856)) and v123.PotionOfWitheringDreams:IsReady()) then
							if (v23(v122.RefreshingHealingPotion) or ((2084 + 1553) >= (1950 + 1820))) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
				if ((v155 == (0 + 0)) or ((1180 + 1199) > (3401 + 1177))) then
					if ((v39 == "Refreshing Healing Potion") or ((1897 - (1001 + 413)) > (1656 - 913))) then
						if (((3336 - (244 + 638)) > (1271 - (627 + 66))) and v123.RefreshingHealingPotion:IsReady()) then
							if (((2771 - 1841) < (5060 - (512 + 90))) and v23(v122.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2568 - (1665 + 241)) <= (1689 - (373 + 344))) and (v39 == "Dreamwalker's Healing Potion")) then
						if (((1971 + 2399) == (1157 + 3213)) and v123.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v122.RefreshingHealingPotion) or ((12560 - 7798) <= (1456 - 595))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					v155 = 1100 - (35 + 1064);
				end
			end
		end
	end
	local function v130()
		if (v113 or ((1028 + 384) == (9122 - 4858))) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (1236 - (298 + 938))) or ((4427 - (233 + 1026)) < (3819 - (636 + 1030)))) then
					v28 = v125.HandleIncorporeal(v121.Hex, v122.HexMouseOver, 16 + 14, true);
					if (v28 or ((4861 + 115) < (396 + 936))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((313 + 4315) == (4849 - (55 + 166))) and v112) then
			local v157 = 0 + 0;
			while true do
				if ((v157 == (1 + 0)) or ((206 - 152) == (692 - (36 + 261)))) then
					if (((142 - 60) == (1450 - (34 + 1334))) and v114) then
						local v253 = 0 + 0;
						while true do
							if ((v253 == (0 + 0)) or ((1864 - (1035 + 248)) < (303 - (20 + 1)))) then
								v28 = v125.HandleAfflicted(v121.TremorTotem, v121.TremorTotem, 16 + 14);
								if (v28 or ((4928 - (134 + 185)) < (3628 - (549 + 584)))) then
									return v28;
								end
								break;
							end
						end
					end
					if (((1837 - (314 + 371)) == (3954 - 2802)) and v115) then
						local v254 = 968 - (478 + 490);
						while true do
							if (((1005 + 891) <= (4594 - (786 + 386))) and (v254 == (0 - 0))) then
								v28 = v125.HandleAfflicted(v121.PoisonCleansingTotem, v121.PoisonCleansingTotem, 1409 - (1055 + 324));
								if (v28 or ((2330 - (1093 + 247)) > (1440 + 180))) then
									return v28;
								end
								break;
							end
						end
					end
					v157 = 1 + 1;
				end
				if ((v157 == (7 - 5)) or ((2976 - 2099) > (13359 - 8664))) then
					if (((6762 - 4071) >= (659 + 1192)) and v121.PurifySpirit:CooldownRemains()) then
						local v255 = 0 - 0;
						while true do
							if ((v255 == (0 - 0)) or ((2251 + 734) >= (12418 - 7562))) then
								v28 = v125.HandleAfflicted(v121.HealingSurge, v122.HealingSurgeMouseover, 718 - (364 + 324));
								if (((11721 - 7445) >= (2867 - 1672)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					break;
				end
				if (((1072 + 2160) <= (19624 - 14934)) and (v157 == (0 - 0))) then
					v28 = v125.HandleAfflicted(v121.PurifySpirit, v122.PurifySpiritMouseover, 91 - 61);
					if (v28 or ((2164 - (1249 + 19)) >= (2840 + 306))) then
						return v28;
					end
					v157 = 3 - 2;
				end
			end
		end
		if (((4147 - (686 + 400)) >= (2321 + 637)) and v40) then
			v28 = v125.HandleChromie(v121.Riptide, v122.RiptideMouseover, 269 - (73 + 156));
			if (((16 + 3171) >= (1455 - (721 + 90))) and v28) then
				return v28;
			end
			v28 = v125.HandleChromie(v121.HealingSurge, v122.HealingSurgeMouseover, 1 + 39);
			if (((2090 - 1446) <= (1174 - (224 + 246))) and v28) then
				return v28;
			end
		end
		if (((1551 - 593) > (1743 - 796)) and v41) then
			v28 = v125.HandleCharredTreant(v121.Riptide, v122.RiptideMouseover, 8 + 32);
			if (((107 + 4385) >= (1950 + 704)) and v28) then
				return v28;
			end
			v28 = v125.HandleCharredTreant(v121.ChainHeal, v122.ChainHealMouseover, 79 - 39);
			if (((11454 - 8012) >= (2016 - (203 + 310))) and v28) then
				return v28;
			end
			v28 = v125.HandleCharredTreant(v121.HealingSurge, v122.HealingSurgeMouseover, 2033 - (1238 + 755));
			if (v28 or ((222 + 2948) <= (2998 - (709 + 825)))) then
				return v28;
			end
			v28 = v125.HandleCharredTreant(v121.HealingWave, v122.HealingWaveMouseover, 73 - 33);
			if (v28 or ((6987 - 2190) == (5252 - (196 + 668)))) then
				return v28;
			end
		end
		if (((2175 - 1624) <= (1410 - 729)) and v42) then
			local v158 = 833 - (171 + 662);
			while true do
				if (((3370 - (4 + 89)) > (1426 - 1019)) and (v158 == (1 + 0))) then
					v28 = v125.HandleCharredBrambles(v121.ChainHeal, v122.ChainHealMouseover, 175 - 135);
					if (((1842 + 2853) >= (2901 - (35 + 1451))) and v28) then
						return v28;
					end
					v158 = 1455 - (28 + 1425);
				end
				if ((v158 == (1995 - (941 + 1052))) or ((3080 + 132) <= (2458 - (822 + 692)))) then
					v28 = v125.HandleCharredBrambles(v121.HealingSurge, v122.HealingSurgeMouseover, 57 - 17);
					if (v28 or ((1459 + 1637) <= (2095 - (45 + 252)))) then
						return v28;
					end
					v158 = 3 + 0;
				end
				if (((1218 + 2319) == (8607 - 5070)) and (v158 == (436 - (114 + 319)))) then
					v28 = v125.HandleCharredBrambles(v121.HealingWave, v122.HealingWaveMouseover, 57 - 17);
					if (((4916 - 1079) >= (1001 + 569)) and v28) then
						return v28;
					end
					break;
				end
				if ((v158 == (0 - 0)) or ((6181 - 3231) == (5775 - (556 + 1407)))) then
					v28 = v125.HandleCharredBrambles(v121.Riptide, v122.RiptideMouseover, 1246 - (741 + 465));
					if (((5188 - (170 + 295)) >= (1222 + 1096)) and v28) then
						return v28;
					end
					v158 = 1 + 0;
				end
			end
		end
		if (v43 or ((4990 - 2963) > (2365 + 487))) then
			local v159 = 0 + 0;
			while true do
				if ((v159 == (2 + 1)) or ((2366 - (957 + 273)) > (1155 + 3162))) then
					v28 = v125.HandleFyrakkNPC(v121.HealingWave, v122.HealingWaveMouseover, 17 + 23);
					if (((18091 - 13343) == (12512 - 7764)) and v28) then
						return v28;
					end
					break;
				end
				if (((11411 - 7675) <= (23470 - 18730)) and ((1781 - (389 + 1391)) == v159)) then
					v28 = v125.HandleFyrakkNPC(v121.ChainHeal, v122.ChainHealMouseover, 26 + 14);
					if (v28 or ((353 + 3037) <= (6966 - 3906))) then
						return v28;
					end
					v159 = 953 - (783 + 168);
				end
				if (((6 - 4) == v159) or ((983 + 16) > (3004 - (309 + 2)))) then
					v28 = v125.HandleFyrakkNPC(v121.HealingSurge, v122.HealingSurgeMouseover, 122 - 82);
					if (((1675 - (1090 + 122)) < (195 + 406)) and v28) then
						return v28;
					end
					v159 = 9 - 6;
				end
				if ((v159 == (0 + 0)) or ((3301 - (628 + 490)) < (124 + 563))) then
					v28 = v125.HandleFyrakkNPC(v121.Riptide, v122.RiptideMouseover, 99 - 59);
					if (((20788 - 16239) == (5323 - (431 + 343))) and v28) then
						return v28;
					end
					v159 = 1 - 0;
				end
			end
		end
	end
	local function v131()
		if (((13515 - 8843) == (3691 + 981)) and v110 and ((v30 and v109) or not v109)) then
			local v160 = 0 + 0;
			while true do
				if ((v160 == (1695 - (556 + 1139))) or ((3683 - (6 + 9)) < (73 + 322))) then
					v28 = v125.HandleTopTrinket(v124, v30, 21 + 19, nil);
					if (v28 or ((4335 - (28 + 141)) == (177 + 278))) then
						return v28;
					end
					v160 = 1 - 0;
				end
				if (((1 + 0) == v160) or ((5766 - (486 + 831)) == (6929 - 4266))) then
					v28 = v125.HandleBottomTrinket(v124, v30, 140 - 100, nil);
					if (v28 or ((809 + 3468) < (9450 - 6461))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2133 - (668 + 595)) >= (3734 + 415))) then
			if (((446 + 1766) < (8680 - 5497)) and (v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) then
				if (((4936 - (23 + 267)) > (4936 - (1129 + 815))) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
					return "riptide healingcd tank";
				end
			end
		end
		if (((1821 - (371 + 16)) < (4856 - (1326 + 424))) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
			if (((1488 - 702) < (11046 - 8023)) and (v16:HealthPercentage() <= v82)) then
				if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((2560 - (88 + 30)) < (845 - (720 + 51)))) then
					return "riptide healingcd";
				end
			end
		end
		if (((10088 - 5553) == (6311 - (421 + 1355))) and v125.AreUnitsBelowHealthPercentage(v85, v84, v121.ChainHeal) and v121.SpiritLinkTotem:IsReady()) then
			if ((v86 == "Player") or ((4963 - 1954) <= (1035 + 1070))) then
				if (((2913 - (286 + 797)) < (13412 - 9743)) and v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(66 - 26))) then
					return "spirit_link_totem cooldowns";
				end
			elseif ((v86 == "Friendly under Cursor") or ((1869 - (397 + 42)) >= (1129 + 2483))) then
				if (((3483 - (24 + 776)) >= (3789 - 1329)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(825 - (222 + 563))) or ((3974 - 2170) >= (2358 + 917))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v86 == "Confirmation") or ((1607 - (23 + 167)) > (5427 - (690 + 1108)))) then
				if (((1731 + 3064) > (332 + 70)) and v23(v121.SpiritLinkTotem, not v14:IsInRange(888 - (40 + 808)))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((793 + 4020) > (13632 - 10067)) and v99 and v125.AreUnitsBelowHealthPercentage(v78, v77, v121.ChainHeal) and v121.HealingTideTotem:IsReady()) then
			if (((3739 + 173) == (2070 + 1842)) and v23(v121.HealingTideTotem, not v14:IsInRange(22 + 18))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((3392 - (47 + 524)) <= (3131 + 1693)) and v125.AreUnitsBelowHealthPercentage(v54, v53, v121.ChainHeal) and v121.AncestralProtectionTotem:IsReady()) then
			if (((4750 - 3012) <= (3282 - 1087)) and (v55 == "Player")) then
				if (((93 - 52) <= (4744 - (1165 + 561))) and v23(v122.AncestralProtectionTotemPlayer, not v14:IsInRange(2 + 38))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((6643 - 4498) <= (1566 + 2538)) and (v55 == "Friendly under Cursor")) then
				if (((3168 - (341 + 138)) < (1308 + 3537)) and v15:Exists() and not v12:CanAttack(v15)) then
					if (v23(v122.AncestralProtectionTotemCursor, not v14:IsInRange(82 - 42)) or ((2648 - (89 + 237)) > (8434 - 5812))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v55 == "Confirmation") or ((9545 - 5011) == (2963 - (581 + 300)))) then
				if (v23(v121.AncestralProtectionTotem, not v14:IsInRange(1260 - (855 + 365))) or ((3731 - 2160) > (610 + 1257))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v90 and v125.AreUnitsBelowHealthPercentage(v52, v51, v121.ChainHeal) and v121.AncestralGuidance:IsReady()) or ((3889 - (1030 + 205)) >= (2813 + 183))) then
			if (((3701 + 277) > (2390 - (156 + 130))) and v23(v121.AncestralGuidance, not v14:IsInRange(90 - 50))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((5047 - 2052) > (3155 - 1614)) and v91 and v125.AreUnitsBelowHealthPercentage(v57, v56, v121.ChainHeal) and v121.Ascendance:IsReady()) then
			if (((857 + 2392) > (556 + 397)) and v23(v121.Ascendance, not v14:IsInRange(109 - (10 + 59)))) then
				return "ascendance cooldowns";
			end
		end
		if ((v101 and (v12:ManaPercentage() <= v80) and v121.ManaTideTotem:IsReady()) or ((926 + 2347) > (22520 - 17947))) then
			if (v23(v121.ManaTideTotem, not v14:IsInRange(1203 - (671 + 492))) or ((2509 + 642) < (2499 - (369 + 846)))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v34 and ((v108 and v30) or not v108)) or ((490 + 1360) == (1305 + 224))) then
			local v161 = 1945 - (1036 + 909);
			while true do
				if (((653 + 168) < (3564 - 1441)) and (v161 == (204 - (11 + 192)))) then
					if (((456 + 446) < (2500 - (135 + 40))) and v121.Berserking:IsReady()) then
						if (((2078 - 1220) <= (1786 + 1176)) and v23(v121.Berserking, not v14:IsInRange(88 - 48))) then
							return "Berserking cooldowns";
						end
					end
					if (v121.BloodFury:IsReady() or ((5915 - 1969) < (1464 - (50 + 126)))) then
						if (v23(v121.BloodFury, not v14:IsInRange(111 - 71)) or ((718 + 2524) == (1980 - (1233 + 180)))) then
							return "BloodFury cooldowns";
						end
					end
					v161 = 971 - (522 + 447);
				end
				if (((1421 - (107 + 1314)) == v161) or ((394 + 453) >= (3848 - 2585))) then
					if (v121.AncestralCall:IsReady() or ((957 + 1296) == (3675 - 1824))) then
						if (v23(v121.AncestralCall, not v14:IsInRange(158 - 118)) or ((3997 - (716 + 1194)) > (41 + 2331))) then
							return "AncestralCall cooldowns";
						end
					end
					if (v121.BagofTricks:IsReady() or ((477 + 3968) < (4652 - (74 + 429)))) then
						if (v23(v121.BagofTricks, not v14:IsInRange(77 - 37)) or ((902 + 916) == (194 - 109))) then
							return "BagofTricks cooldowns";
						end
					end
					v161 = 1 + 0;
				end
				if (((1942 - 1312) < (5258 - 3131)) and (v161 == (435 - (279 + 154)))) then
					if (v121.Fireblood:IsReady() or ((2716 - (454 + 324)) == (1978 + 536))) then
						if (((4272 - (12 + 5)) >= (30 + 25)) and v23(v121.Fireblood, not v14:IsInRange(101 - 61))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
			end
		end
	end
	local function v132()
		local v142 = 0 + 0;
		while true do
			if (((4092 - (277 + 816)) > (4939 - 3783)) and (v142 == (1185 - (1058 + 125)))) then
				if (((441 + 1909) > (2130 - (815 + 160))) and v125.AreUnitsBelowHealthPercentage(v64, v63, v121.ChainHeal) and v121.Downpour:IsReady()) then
					if (((17286 - 13257) <= (11520 - 6667)) and (v65 == "Player")) then
						if (v23(v122.DownpourPlayer, not v14:IsInRange(10 + 30), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1508 - 992) > (5332 - (41 + 1857)))) then
							return "downpour healingaoe";
						end
					elseif (((5939 - (1222 + 671)) >= (7838 - 4805)) and (v65 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((3907 - 1188) <= (2629 - (229 + 953)))) then
							if (v23(v122.DownpourCursor, not v14:IsInRange(1814 - (1111 + 663)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((5713 - (874 + 705)) < (550 + 3376))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v65 == "Confirmation") or ((112 + 52) >= (5789 - 3004))) then
						if (v23(v121.Downpour, not v14:IsInRange(2 + 38), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1204 - (642 + 37)) == (481 + 1628))) then
							return "downpour healingaoe";
						end
					end
				end
				if (((6 + 27) == (82 - 49)) and v94 and v125.AreUnitsBelowHealthPercentage(v62, v61, v121.ChainHeal) and v121.CloudburstTotem:IsReady() and (v121.CloudburstTotem:TimeSinceLastCast() > (464 - (233 + 221)))) then
					if (((7061 - 4007) <= (3534 + 481)) and v23(v121.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((3412 - (718 + 823)) < (2129 + 1253)) and v105 and v125.AreUnitsBelowHealthPercentage(v107, v106, v121.ChainHeal) and v121.Wellspring:IsReady()) then
					if (((2098 - (266 + 539)) <= (6132 - 3966)) and v23(v121.Wellspring, not v14:IsInRange(1265 - (636 + 589)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "wellspring healingaoe";
					end
				end
				if ((v93 and v125.AreUnitsBelowHealthPercentage(v60, v59, v121.ChainHeal) and v121.ChainHeal:IsReady()) or ((6121 - 3542) < (253 - 130))) then
					if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((671 + 175) >= (861 + 1507))) then
						return "chain_heal healingaoe";
					end
				end
				v142 = 1018 - (657 + 358);
			end
			if ((v142 == (0 - 0)) or ((9140 - 5128) <= (4545 - (1151 + 36)))) then
				if (((1443 + 51) <= (791 + 2214)) and v93 and v125.AreUnitsBelowHealthPercentage(283 - 188, 1835 - (1552 + 280), v121.ChainHeal) and v121.ChainHeal:IsReady() and v12:BuffUp(v121.HighTide)) then
					if (v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3945 - (64 + 770)) == (1449 + 685))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((5346 - 2991) == (419 + 1936)) and v100 and (v16:HealthPercentage() <= v79) and v121.HealingWave:IsReady() and (v121.PrimordialWaveResto:TimeSinceLastCast() < (1258 - (157 + 1086)))) then
					if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1176 - 588) <= (1891 - 1459))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((7358 - 2561) >= (5315 - 1420)) and v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) then
					if (((4396 - (599 + 220)) == (7123 - 3546)) and (v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) then
						if (((5725 - (1813 + 118)) > (2700 + 993)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2492 - (841 + 376)) == (5745 - 1645))) then
					if ((v16:HealthPercentage() <= v82) or ((370 + 1221) >= (9771 - 6191))) then
						if (((1842 - (464 + 395)) <= (4639 - 2831)) and v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v142 = 1 + 0;
			end
			if ((v142 == (838 - (467 + 370))) or ((4443 - 2293) <= (879 + 318))) then
				if (((12920 - 9151) >= (184 + 989)) and v104 and v121.UnleashLife:IsReady()) then
					if (((3454 - 1969) == (2005 - (150 + 370))) and (v12:HealthPercentage() <= v89)) then
						if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((4597 - (74 + 1208)) <= (6842 - 4060))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v73 == "Cursor") and v121.HealingRain:IsReady() and v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal)) or ((4154 - 3278) >= (2110 + 854))) then
					if (v23(v122.HealingRainCursor, not v14:IsInRange(430 - (14 + 376)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3871 - 1639) > (1616 + 881))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v72, v71, v121.ChainHeal) and v121.HealingRain:IsReady()) or ((1854 + 256) <= (317 + 15))) then
					if (((10800 - 7114) > (2387 + 785)) and (v73 == "Player")) then
						if (v23(v122.HealingRainPlayer, not v14:IsInRange(118 - (23 + 55)), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((10602 - 6128) < (548 + 272))) then
							return "healing_rain healingaoe";
						end
					elseif (((3843 + 436) >= (4468 - 1586)) and (v73 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((639 + 1390) >= (4422 - (652 + 249)))) then
							if (v23(v122.HealingRainCursor, not v14:IsInRange(107 - 67), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3905 - (708 + 1160)) >= (12600 - 7958))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((3135 - 1415) < (4485 - (10 + 17))) and (v73 == "Enemy under Cursor")) then
						if ((v15:Exists() and v12:CanAttack(v15)) or ((98 + 338) > (4753 - (1400 + 332)))) then
							if (((1367 - 654) <= (2755 - (242 + 1666))) and v23(v122.HealingRainCursor, not v14:IsInRange(18 + 22), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((790 + 1364) <= (3436 + 595)) and (v73 == "Confirmation")) then
						if (((5555 - (850 + 90)) == (8082 - 3467)) and v23(v121.HealingRain, not v14:IsInRange(1430 - (360 + 1030)), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v125.AreUnitsBelowHealthPercentage(v69, v68, v121.ChainHeal) and v121.EarthenWallTotem:IsReady()) or ((3355 + 435) == (1411 - 911))) then
					if (((121 - 32) < (1882 - (909 + 752))) and (v70 == "Player")) then
						if (((3277 - (109 + 1114)) >= (2601 - 1180)) and v23(v122.EarthenWallTotemPlayer, not v14:IsInRange(16 + 24))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((934 - (6 + 236)) < (1927 + 1131)) and (v70 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((2620 + 634) == (3903 - 2248))) then
							if (v23(v122.EarthenWallTotemCursor, not v14:IsInRange(69 - 29)) or ((2429 - (1076 + 57)) == (808 + 4102))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((4057 - (579 + 110)) == (266 + 3102)) and (v70 == "Confirmation")) then
						if (((2337 + 306) < (2025 + 1790)) and v23(v121.EarthenWallTotem, not v14:IsInRange(447 - (174 + 233)))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v142 = 5 - 3;
			end
			if (((3357 - 1444) > (220 + 273)) and (v142 == (1177 - (663 + 511)))) then
				if (((4243 + 512) > (745 + 2683)) and v103 and v12:IsMoving() and v125.AreUnitsBelowHealthPercentage(v88, v87, v121.ChainHeal) and v121.SpiritwalkersGrace:IsReady()) then
					if (((4257 - 2876) <= (1435 + 934)) and v23(v121.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v97 and v125.AreUnitsBelowHealthPercentage(v75, v74, v121.ChainHeal) and v121.HealingStreamTotem:IsReady()) or ((11401 - 6558) == (9886 - 5802))) then
					if (((2228 + 2441) > (706 - 343)) and v23(v121.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
		end
	end
	local function v133()
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((1338 + 539) >= (287 + 2851))) then
			if (((5464 - (478 + 244)) >= (4143 - (440 + 77))) and (v16:HealthPercentage() <= v82)) then
				if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((2065 + 2475) == (3352 - 2436))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v16:BuffDown(v121.Riptide)) or ((2712 - (655 + 901)) > (806 + 3539))) then
			if (((1713 + 524) < (2870 + 1379)) and (v16:HealthPercentage() <= v83) and (v125.UnitGroupRole(v16) == "TANK")) then
				if (v23(v122.RiptideFocus, not v16:IsSpellInRange(v121.Riptide)) or ((10808 - 8125) < (1468 - (695 + 750)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((2380 - 1683) <= (1274 - 448)) and v121.ElementalOrbit:IsAvailable() and v12:BuffDown(v121.EarthShieldBuff) and not v14:IsAPlayer() and v121.EarthShield:IsCastable() and v96 and v12:CanAttack(v14)) then
			if (((4444 - 3339) <= (1527 - (285 + 66))) and v23(v121.EarthShield)) then
				return "earth_shield player healingst";
			end
		end
		if (((7876 - 4497) <= (5122 - (682 + 628))) and v121.ElementalOrbit:IsAvailable() and v12:BuffUp(v121.EarthShieldBuff)) then
			if (v125.IsSoloMode() or ((128 + 660) >= (1915 - (176 + 123)))) then
				if (((776 + 1078) <= (2452 + 927)) and v121.LightningShield:IsReady() and v12:BuffDown(v121.LightningShield)) then
					if (((4818 - (239 + 30)) == (1237 + 3312)) and v23(v121.LightningShield)) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v121.WaterShield:IsReady() and v12:BuffDown(v121.WaterShield)) or ((2905 + 117) >= (5352 - 2328))) then
				if (((15037 - 10217) > (2513 - (306 + 9))) and v23(v121.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v98 and v121.HealingSurge:IsReady()) or ((3702 - 2641) >= (851 + 4040))) then
			if (((837 + 527) <= (2154 + 2319)) and (v16:HealthPercentage() <= v76)) then
				if (v23(v122.HealingSurgeFocus, not v16:IsSpellInRange(v121.HealingSurge), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((10280 - 6685) <= (1378 - (1140 + 235)))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v100 and v121.HealingWave:IsReady()) or ((2974 + 1698) == (3533 + 319))) then
			if (((401 + 1158) == (1611 - (33 + 19))) and (v16:HealthPercentage() <= v79)) then
				if (v23(v122.HealingWaveFocus, not v16:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((633 + 1119) <= (2361 - 1573))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v134()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (0 - 0)) or ((3664 + 243) == (866 - (586 + 103)))) then
				if (((316 + 3154) > (1708 - 1153)) and v121.Stormkeeper:IsReady()) then
					if (v23(v121.Stormkeeper, not v14:IsInRange(1528 - (1309 + 179))) or ((1754 - 782) == (281 + 364))) then
						return "stormkeeper damage";
					end
				end
				if (((8545 - 5363) >= (1598 + 517)) and (math.max(#v12:GetEnemiesInRange(42 - 22), v12:GetEnemiesInSplashRangeCount(15 - 7)) > (611 - (295 + 314)))) then
					if (((9561 - 5668) < (6391 - (1300 + 662))) and v121.ChainLightning:IsReady()) then
						if (v23(v121.ChainLightning, not v14:IsSpellInRange(v121.ChainLightning), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((9002 - 6135) < (3660 - (1178 + 577)))) then
							return "chain_lightning damage";
						end
					end
				end
				v143 = 1 + 0;
			end
			if ((v143 == (2 - 1)) or ((3201 - (851 + 554)) >= (3583 + 468))) then
				if (((4489 - 2870) <= (8157 - 4401)) and v121.FlameShock:IsReady()) then
					local v252 = 302 - (115 + 187);
					while true do
						if (((463 + 141) == (572 + 32)) and (v252 == (0 - 0))) then
							if (v125.CastCycle(v121.FlameShock, v12:GetEnemiesInRange(1201 - (160 + 1001)), v128, not v14:IsSpellInRange(v121.FlameShock), nil, nil, nil, nil) or ((3923 + 561) == (621 + 279))) then
								return "flame_shock_cycle damage";
							end
							if (v23(v121.FlameShock, not v14:IsSpellInRange(v121.FlameShock)) or ((9127 - 4668) <= (1471 - (237 + 121)))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((4529 - (525 + 372)) > (6441 - 3043)) and v121.LavaBurst:IsReady()) then
					if (((13411 - 9329) <= (5059 - (96 + 46))) and v23(v121.LavaBurst, not v14:IsSpellInRange(v121.LavaBurst), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v143 = 779 - (643 + 134);
			end
			if (((1745 + 3087) >= (3323 - 1937)) and (v143 == (7 - 5))) then
				if (((132 + 5) == (268 - 131)) and v121.LightningBolt:IsReady()) then
					if (v23(v121.LightningBolt, not v14:IsSpellInRange(v121.LightningBolt), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((3209 - 1639) >= (5051 - (316 + 403)))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (0 - 0)) or ((1469 + 2595) <= (4580 - 2761))) then
				v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v59 = EpicSettings.Settings['ChainHealGroup'];
				v60 = EpicSettings.Settings['ChainHealHP'];
				v144 = 1 + 0;
			end
			if ((v144 == (1 + 0)) or ((17276 - 12290) < (7517 - 5943))) then
				v44 = EpicSettings.Settings['DispelDebuffs'];
				v45 = EpicSettings.Settings['DispelBuffs'];
				v63 = EpicSettings.Settings['DownpourGroup'];
				v64 = EpicSettings.Settings['DownpourHP'];
				v65 = EpicSettings.Settings['DownpourUsage'];
				v144 = 3 - 1;
			end
			if (((254 + 4172) > (338 - 166)) and (v144 == (1 + 3))) then
				v76 = EpicSettings.Settings['HealingSurgeHP'];
				v77 = EpicSettings.Settings['HealingTideTotemGroup'];
				v78 = EpicSettings.Settings['HealingTideTotemHP'];
				v79 = EpicSettings.Settings['HealingWaveHP'];
				v36 = EpicSettings.Settings['healthstoneHP'];
				v144 = 14 - 9;
			end
			if (((603 - (12 + 5)) > (1767 - 1312)) and (v144 == (16 - 8))) then
				v97 = EpicSettings.Settings['UseHealingStreamTotem'];
				v98 = EpicSettings.Settings['UseHealingSurge'];
				v99 = EpicSettings.Settings['UseHealingTideTotem'];
				v100 = EpicSettings.Settings['UseHealingWave'];
				v35 = EpicSettings.Settings['useHealthstone'];
				v144 = 18 - 9;
			end
			if (((2048 - 1222) == (168 + 658)) and (v144 == (1979 - (1656 + 317)))) then
				v84 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v85 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v86 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v87 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v144 = 7 + 0;
			end
			if ((v144 == (2 + 0)) or ((10686 - 6667) > (21856 - 17415))) then
				v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v69 = EpicSettings.Settings['EarthenWallTotemHP'];
				v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v38 = EpicSettings.Settings['healingPotionHP'];
				v39 = EpicSettings.Settings['HealingPotionName'];
				v144 = 357 - (5 + 349);
			end
			if (((9580 - 7563) < (5532 - (266 + 1005))) and (v144 == (6 + 3))) then
				v46 = EpicSettings.Settings['UsePurgeTarget'];
				v102 = EpicSettings.Settings['UseRiptide'];
				v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v104 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((16091 - 11375) > (105 - 25)) and (v144 == (1701 - (561 + 1135)))) then
				v48 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v49 = EpicSettings.Settings['InterruptThreshold'];
				v47 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['RiptideHP'];
				v83 = EpicSettings.Settings['RiptideTankHP'];
				v144 = 7 - 1;
			end
			if ((v144 == (9 - 6)) or ((4573 - (507 + 559)) == (8210 - 4938))) then
				v71 = EpicSettings.Settings['HealingRainGroup'];
				v72 = EpicSettings.Settings['HealingRainHP'];
				v73 = EpicSettings.Settings['HealingRainUsage'];
				v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v75 = EpicSettings.Settings['HealingStreamTotemHP'];
				v144 = 12 - 8;
			end
			if ((v144 == (395 - (212 + 176))) or ((1781 - (250 + 655)) >= (8385 - 5310))) then
				v89 = EpicSettings.Settings['UnleashLifeHP'];
				v93 = EpicSettings.Settings['UseChainHeal'];
				v94 = EpicSettings.Settings['UseCloudburstTotem'];
				v96 = EpicSettings.Settings['UseEarthShield'];
				v37 = EpicSettings.Settings['useHealingPotion'];
				v144 = 13 - 5;
			end
		end
	end
	local function v136()
		local v145 = 0 - 0;
		while true do
			if (((6308 - (1869 + 87)) > (8858 - 6304)) and (v145 == (1901 - (484 + 1417)))) then
				v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v52 = EpicSettings.Settings['AncestralGuidanceHP'];
				v56 = EpicSettings.Settings['AscendanceGroup'];
				v57 = EpicSettings.Settings['AscendanceHP'];
				v58 = EpicSettings.Settings['AstralShiftHP'];
				v145 = 2 - 1;
			end
			if ((v145 == (9 - 3)) or ((5179 - (48 + 725)) < (6604 - 2561))) then
				v42 = EpicSettings.Settings['HandleCharredBrambles'];
				v41 = EpicSettings.Settings['HandleCharredTreant'];
				v43 = EpicSettings.Settings['HandleFyrakkNPC'];
				v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v145 == (2 - 1)) or ((1098 + 791) >= (9040 - 5657))) then
				v61 = EpicSettings.Settings['CloudburstTotemGroup'];
				v62 = EpicSettings.Settings['CloudburstTotemHP'];
				v66 = EpicSettings.Settings['EarthElementalHP'];
				v67 = EpicSettings.Settings['EarthElementalTankHP'];
				v80 = EpicSettings.Settings['ManaTideTotemMana'];
				v145 = 1 + 1;
			end
			if (((552 + 1340) <= (3587 - (152 + 701))) and ((1313 - (430 + 881)) == v145)) then
				v81 = EpicSettings.Settings['PrimordialWaveHP'];
				v90 = EpicSettings.Settings['UseAncestralGuidance'];
				v91 = EpicSettings.Settings['UseAscendance'];
				v92 = EpicSettings.Settings['UseAstralShift'];
				v95 = EpicSettings.Settings['UseEarthElemental'];
				v145 = 2 + 1;
			end
			if (((2818 - (557 + 338)) < (656 + 1562)) and (v145 == (8 - 5))) then
				v101 = EpicSettings.Settings['UseManaTideTotem'];
				v105 = EpicSettings.Settings['UseWellspring'];
				v106 = EpicSettings.Settings['WellspringGroup'];
				v107 = EpicSettings.Settings['WellspringHP'];
				v116 = EpicSettings.Settings['useManaPotion'];
				v145 = 13 - 9;
			end
			if (((5773 - 3600) > (816 - 437)) and (v145 == (806 - (499 + 302)))) then
				v111 = EpicSettings.Settings['fightRemainsCheck'];
				v50 = EpicSettings.Settings['useWeapon'];
				v112 = EpicSettings.Settings['handleAfflicted'];
				v113 = EpicSettings.Settings['HandleIncorporeal'];
				v40 = EpicSettings.Settings['HandleChromie'];
				v145 = 872 - (39 + 827);
			end
			if ((v145 == (10 - 6)) or ((5786 - 3195) == (13539 - 10130))) then
				v117 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['racialsWithCD'];
				v34 = EpicSettings.Settings['useRacials'];
				v109 = EpicSettings.Settings['trinketsWithCD'];
				v110 = EpicSettings.Settings['useTrinkets'];
				v145 = 7 - 2;
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
		local v151;
		if (((13211 - 8697) > (532 + 2792)) and v12:IsDeadOrGhost()) then
			return;
		end
		if (v125.TargetIsValid() or v12:AffectingCombat() or ((328 - 120) >= (4932 - (103 + 1)))) then
			v120 = v12:GetEnemiesInRange(594 - (475 + 79));
			v118 = v9.BossFightRemains(nil, true);
			v119 = v118;
			if ((v119 == (24019 - 12908)) or ((5065 - 3482) > (461 + 3106))) then
				v119 = v9.FightRemains(v120, false);
			end
		end
		if (not v12:AffectingCombat() or ((1156 + 157) == (2297 - (1395 + 108)))) then
			if (((9235 - 6061) > (4106 - (7 + 1197))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v249 = 0 + 0;
				local v250;
				while true do
					if (((1438 + 2682) <= (4579 - (27 + 292))) and (v249 == (0 - 0))) then
						v250 = v125.DeadFriendlyUnitsCount();
						if ((v250 > (1 - 0)) or ((3703 - 2820) > (9422 - 4644))) then
							if (v23(v121.AncestralVision, nil, v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((6894 - 3274) >= (5030 - (43 + 96)))) then
								return "ancestral_vision";
							end
						elseif (((17368 - 13110) > (2117 - 1180)) and v23(v122.AncestralSpiritMouseover, not v14:IsInRange(34 + 6), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v151 = v130();
		if (v151 or ((1375 + 3494) < (1790 - 884))) then
			return v151;
		end
		if (v12:AffectingCombat() or v29 or ((470 + 755) > (7923 - 3695))) then
			local v162 = 0 + 0;
			local v163;
			while true do
				if (((245 + 3083) > (3989 - (1414 + 337))) and (v162 == (1940 - (1642 + 298)))) then
					v163 = v44 and v121.PurifySpirit:IsReady() and v31;
					if (((10007 - 6168) > (4041 - 2636)) and v121.EarthShield:IsReady() and v96 and (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 73 - 48) < (1 + 0))) then
						local v256 = 0 + 0;
						while true do
							if ((v256 == (972 - (357 + 615))) or ((908 + 385) <= (1243 - 736))) then
								v28 = v125.FocusUnitRefreshableBuff(v121.EarthShield, 13 + 2, 85 - 45, "TANK", true, 20 + 5, v121.ChainHeal);
								if (v28 or ((197 + 2699) < (506 + 299))) then
									return v28;
								end
								v256 = 1302 - (384 + 917);
							end
							if (((3013 - (128 + 569)) == (3859 - (1407 + 136))) and (v256 == (1888 - (687 + 1200)))) then
								if ((v125.UnitGroupRole(v16) == "TANK") or ((4280 - (556 + 1154)) == (5393 - 3860))) then
									if (v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield)) or ((978 - (9 + 86)) == (1881 - (275 + 146)))) then
										return "earth_shield_tank main apl 1";
									end
								end
								break;
							end
						end
					end
					v162 = 1 + 0;
				end
				if (((65 - (29 + 35)) == v162) or ((20471 - 15852) <= (2983 - 1984))) then
					if (not v16:BuffDown(v121.EarthShield) or (v125.UnitGroupRole(v16) ~= "TANK") or not v96 or (v125.FriendlyUnitsWithBuffCount(v121.EarthShield, true, false, 110 - 85) >= (1 + 0)) or ((4422 - (53 + 959)) > (4524 - (312 + 96)))) then
						local v257 = 0 - 0;
						while true do
							if ((v257 == (285 - (147 + 138))) or ((1802 - (813 + 86)) >= (2765 + 294))) then
								v28 = v125.FocusUnit(v163, nil, 74 - 34, nil, 517 - (18 + 474), v121.ChainHeal);
								if (v28 or ((1342 + 2634) < (9324 - 6467))) then
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
		if (((6016 - (860 + 226)) > (2610 - (121 + 182))) and v121.EarthShield:IsCastable() and v96 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(5 + 35) and (v125.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v121.EarthShield))) then
			if (v23(v122.EarthShieldFocus, not v16:IsSpellInRange(v121.EarthShield)) or ((5286 - (988 + 252)) < (146 + 1145))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if ((v12:AffectingCombat() and v125.TargetIsValid()) or ((1329 + 2912) == (5515 - (49 + 1921)))) then
			if ((v30 and v50 and v123.Dreambinder:IsEquippedAndReady()) or v123.Iridal:IsEquippedAndReady() or ((4938 - (223 + 667)) > (4284 - (51 + 1)))) then
				if (v23(v122.UseWeapon, nil) or ((3012 - 1262) >= (7436 - 3963))) then
					return "Using Weapon Macro";
				end
			end
			if (((4291 - (146 + 979)) == (894 + 2272)) and v116 and v123.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v117)) then
				if (((2368 - (311 + 294)) < (10385 - 6661)) and v23(v122.ManaPotion, nil)) then
					return "Mana Potion main";
				end
			end
			v28 = v125.Interrupt(v121.WindShear, 13 + 17, true);
			if (((1500 - (496 + 947)) <= (4081 - (1233 + 125))) and v28) then
				return v28;
			end
			v28 = v125.InterruptCursor(v121.WindShear, v122.WindShearMouseover, 13 + 17, true, v15);
			if (v28 or ((1858 + 212) == (85 + 358))) then
				return v28;
			end
			v28 = v125.InterruptWithStunCursor(v121.CapacitorTotem, v122.CapacitorTotemCursor, 1675 - (963 + 682), nil, v15);
			if (v28 or ((2258 + 447) == (2897 - (504 + 1000)))) then
				return v28;
			end
			v151 = v129();
			if (v151 or ((3099 + 1502) < (56 + 5))) then
				return v151;
			end
			if ((v121.GreaterPurge:IsAvailable() and v46 and v121.GreaterPurge:IsReady() and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((132 + 1258) >= (6995 - 2251))) then
				if (v23(v121.GreaterPurge, not v14:IsSpellInRange(v121.GreaterPurge)) or ((1712 + 291) > (2230 + 1604))) then
					return "greater_purge utility";
				end
			end
			if ((v121.Purge:IsReady() and v46 and v31 and v45 and not v12:IsCasting() and not v12:IsChanneling() and v125.UnitHasMagicBuff(v14)) or ((338 - (156 + 26)) > (2255 + 1658))) then
				if (((304 - 109) == (359 - (149 + 15))) and v23(v121.Purge, not v14:IsSpellInRange(v121.Purge))) then
					return "purge utility";
				end
			end
			if (((4065 - (890 + 70)) >= (1913 - (39 + 78))) and (v119 > v111)) then
				local v251 = 482 - (14 + 468);
				while true do
					if (((9629 - 5250) >= (5956 - 3825)) and (v251 == (0 + 0))) then
						v151 = v131();
						if (((2309 + 1535) >= (435 + 1608)) and v151) then
							return v151;
						end
						break;
					end
				end
			end
		end
		if (v29 or v12:AffectingCombat() or ((1460 + 1772) <= (716 + 2015))) then
			local v164 = 0 - 0;
			while true do
				if (((4848 + 57) == (17236 - 12331)) and (v164 == (1 + 1))) then
					if ((v121.NaturesSwiftness:IsReady() and v121.Riptide:CooldownRemains() and v121.UnleashLife:CooldownRemains()) or ((4187 - (12 + 39)) >= (4104 + 307))) then
						if (v23(v121.NaturesSwiftness, nil) or ((9155 - 6197) == (14306 - 10289))) then
							return "natures_swiftness main";
						end
					end
					if (((365 + 863) >= (428 + 385)) and v32) then
						local v258 = 0 - 0;
						while true do
							if ((v258 == (0 + 0)) or ((16697 - 13242) > (5760 - (1596 + 114)))) then
								if (((633 - 390) == (956 - (164 + 549))) and v14:Exists() and not v12:CanAttack(v14)) then
									local v262 = 1438 - (1059 + 379);
									while true do
										if ((v262 == (1 - 0)) or ((141 + 130) > (265 + 1307))) then
											if (((3131 - (145 + 247)) < (2703 + 590)) and v93 and (v14:HealthPercentage() <= v60) and v121.ChainHeal:IsReady() and (v12:IsInParty() or v12:IsInRaid() or v125.TargetIsValidHealableNpc() or v12:BuffUp(v121.HighTide))) then
												if (v23(v121.ChainHeal, not v14:IsSpellInRange(v121.ChainHeal), v12:BuffDown(v121.SpiritwalkersGraceBuff)) or ((1822 + 2120) < (3361 - 2227))) then
													return "chain_heal healing target";
												end
											end
											if ((v100 and (v14:HealthPercentage() <= v79) and v121.HealingWave:IsReady()) or ((517 + 2176) == (4284 + 689))) then
												if (((3483 - 1337) == (2866 - (254 + 466))) and v23(v121.HealingWave, not v14:IsSpellInRange(v121.HealingWave), v12:BuffDown(v121.SpiritwalkersGraceBuff))) then
													return "healing_wave healing target";
												end
											end
											break;
										end
										if (((560 - (544 + 16)) == v262) or ((7131 - 4887) == (3852 - (294 + 334)))) then
											if ((v102 and v12:BuffDown(v121.UnleashLife) and v121.Riptide:IsReady() and v14:BuffDown(v121.Riptide)) or ((5157 - (236 + 17)) <= (826 + 1090))) then
												if (((71 + 19) <= (4010 - 2945)) and (v14:HealthPercentage() <= v82)) then
													if (((22735 - 17933) == (2473 + 2329)) and v23(v121.Riptide, not v16:IsSpellInRange(v121.Riptide))) then
														return "riptide healing target";
													end
												end
											end
											if ((v104 and v121.UnleashLife:IsReady() and (v14:HealthPercentage() <= v89)) or ((1878 + 402) <= (1305 - (413 + 381)))) then
												if (v23(v121.UnleashLife, not v16:IsSpellInRange(v121.UnleashLife)) or ((71 + 1605) <= (984 - 521))) then
													return "unleash_life healing target";
												end
											end
											v262 = 2 - 1;
										end
									end
								end
								v151 = v132();
								v258 = 1971 - (582 + 1388);
							end
							if (((6591 - 2722) == (2770 + 1099)) and (v258 == (365 - (326 + 38)))) then
								if (((3425 - 2267) <= (3729 - 1116)) and v151) then
									return v151;
								end
								v151 = v133();
								v258 = 622 - (47 + 573);
							end
							if ((v258 == (1 + 1)) or ((10040 - 7676) <= (3243 - 1244))) then
								if (v151 or ((6586 - (1269 + 395)) < (686 - (76 + 416)))) then
									return v151;
								end
								break;
							end
						end
					end
					v164 = 446 - (319 + 124);
				end
				if ((v164 == (2 - 1)) or ((3098 - (564 + 443)) < (85 - 54))) then
					if ((v16:Exists() and (v16:HealthPercentage() < v81) and v16:BuffDown(v121.Riptide)) or ((2888 - (337 + 121)) >= (14275 - 9403))) then
						if (v121.PrimordialWaveResto:IsCastable() or ((15889 - 11119) < (3646 - (1261 + 650)))) then
							if (v23(v122.PrimordialWaveFocus, not v16:IsSpellInRange(v121.PrimordialWaveResto)) or ((1879 + 2560) <= (3745 - 1395))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v121.TotemicRecall:IsAvailable() and v121.TotemicRecall:IsReady() and (v121.EarthenWallTotem:TimeSinceLastCast() < (v12:GCD() * (1820 - (772 + 1045))))) or ((632 + 3847) < (4610 - (102 + 42)))) then
						if (((4391 - (1524 + 320)) > (2495 - (1049 + 221))) and v23(v121.TotemicRecall, nil)) then
							return "totemic_recall main";
						end
					end
					v164 = 158 - (18 + 138);
				end
				if (((11433 - 6762) > (3776 - (67 + 1035))) and (v164 == (351 - (136 + 212)))) then
					if (v33 or ((15705 - 12009) < (2666 + 661))) then
						if (v125.TargetIsValid() or ((4188 + 354) == (4574 - (240 + 1364)))) then
							local v261 = 1082 - (1050 + 32);
							while true do
								if (((899 - 647) <= (1170 + 807)) and ((1055 - (331 + 724)) == v261)) then
									v151 = v134();
									if (v151 or ((116 + 1320) == (4419 - (269 + 375)))) then
										return v151;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if ((v164 == (725 - (267 + 458))) or ((504 + 1114) < (1788 - 858))) then
					if (((5541 - (667 + 151)) > (5650 - (1410 + 87))) and v31 and v44) then
						local v259 = 1897 - (1504 + 393);
						while true do
							if (((2 - 1) == v259) or ((9479 - 5825) >= (5450 - (461 + 335)))) then
								if (((122 + 829) <= (3257 - (1730 + 31))) and v16 and v16:Exists() and v16:IsAPlayer() and (v125.UnitHasDispellableDebuffByPlayer(v16) or v125.DispellableFriendlyUnit(1692 - (728 + 939)) or v125.UnitHasMagicDebuff(v16) or (v125.UnitHasCurseDebuff(v16) and v121.ImprovedPurifySpirit:IsAvailable()))) then
									if (v121.PurifySpirit:IsCastable() or ((6148 - 4412) == (1158 - 587))) then
										local v264 = 0 - 0;
										while true do
											if ((v264 == (1068 - (138 + 930))) or ((819 + 77) > (3729 + 1040))) then
												if ((v137 == (0 + 0)) or ((4266 - 3221) <= (2786 - (459 + 1307)))) then
													v137 = GetTime();
												end
												if (v125.Wait(2370 - (474 + 1396), v137) or ((2025 - 865) <= (308 + 20))) then
													if (((13 + 3795) > (8375 - 5451)) and v23(v122.PurifySpiritFocus, not v16:IsSpellInRange(v121.PurifySpirit))) then
														return "purify_spirit dispel focus";
													end
													v137 = 0 + 0;
												end
												break;
											end
										end
									end
								end
								if (((12989 - 9098) < (21452 - 16533)) and v15 and v15:Exists() and not v12:CanAttack(v15) and (v125.UnitHasDispellableDebuffByPlayer(v15) or v125.UnitHasMagicDebuff(v15) or (v125.UnitHasCurseDebuff(v15) and v121.ImprovedPurifySpirit:IsAvailable()))) then
									if (v121.PurifySpirit:IsCastable() or ((2825 - (562 + 29)) <= (1281 + 221))) then
										if (v23(v122.PurifySpiritMouseover, not v15:IsSpellInRange(v121.PurifySpirit)) or ((3931 - (374 + 1045)) < (342 + 90))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
							if ((v259 == (0 - 0)) or ((2486 - (448 + 190)) == (280 + 585))) then
								if ((v121.Bursting:MaxDebuffStack() > (2 + 2)) or ((3051 + 1631) <= (17459 - 12918))) then
									local v263 = 0 - 0;
									while true do
										if ((v263 == (1494 - (1307 + 187))) or ((11999 - 8973) >= (9473 - 5427))) then
											v28 = v125.FocusSpecifiedUnit(v121.Bursting:MaxDebuffStackUnit());
											if (((6156 - 4148) > (1321 - (232 + 451))) and v28) then
												return v28;
											end
											break;
										end
									end
								end
								if (((1695 + 80) <= (2856 + 377)) and v15 and v15:Exists() and v15:IsAPlayer()) then
									if (v125.UnitHasPoisonDebuff(v15) or ((5107 - (510 + 54)) == (4023 - 2026))) then
										if (v121.PoisonCleansingTotem:IsCastable() or ((3138 - (13 + 23)) < (1418 - 690))) then
											if (((495 - 150) == (626 - 281)) and v23(v121.PoisonCleansingTotem, nil)) then
												return "poison_cleansing_totem dispel mouseover";
											end
										end
									end
								end
								v259 = 1089 - (830 + 258);
							end
						end
					end
					if ((v121.Bursting:AuraActiveCount() > (10 - 7)) or ((1769 + 1058) < (322 + 56))) then
						local v260 = 1441 - (860 + 581);
						while true do
							if (((0 - 0) == v260) or ((2759 + 717) < (2838 - (237 + 4)))) then
								if (((7235 - 4156) < (12129 - 7335)) and (v121.Bursting:MaxDebuffStack() > (9 - 4)) and v121.SpiritLinkTotem:IsReady()) then
									if (((3973 + 881) > (2564 + 1900)) and (v86 == "Player")) then
										if (v23(v122.SpiritLinkTotemPlayer, not v14:IsInRange(151 - 111)) or ((2108 + 2804) == (2045 + 1713))) then
											return "spirit_link_totem bursting";
										end
									elseif (((1552 - (85 + 1341)) <= (5941 - 2459)) and (v86 == "Friendly under Cursor")) then
										if ((v15:Exists() and not v12:CanAttack(v15)) or ((6704 - 4330) == (4746 - (45 + 327)))) then
											if (((2972 - 1397) == (2077 - (444 + 58))) and v23(v122.SpiritLinkTotemCursor, not v14:IsInRange(18 + 22))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif ((v86 == "Confirmation") or ((385 + 1849) == (712 + 743))) then
										if (v23(v121.SpiritLinkTotem, not v14:IsInRange(115 - 75)) or ((2799 - (64 + 1668)) > (3752 - (1227 + 746)))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if (((6642 - 4481) >= (1732 - 798)) and v93 and v121.ChainHeal:IsReady()) then
									if (((2106 - (415 + 79)) == (42 + 1570)) and v23(v122.ChainHealFocus, not v16:IsSpellInRange(v121.ChainHeal))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
								break;
							end
						end
					end
					v164 = 492 - (142 + 349);
				end
			end
		end
	end
	local function v139()
		v127();
		v121.Bursting:RegisterAuraTracking();
		v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(114 + 150, v138, v139);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

