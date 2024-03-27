local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((4623 - (29 + 1448)) < (5711 - (135 + 1254))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((16038 - 12603) == (1398 + 699))) then
				return v1(v4, ...);
			end
			v5 = 1528 - (389 + 1138);
		end
		if ((v5 == (575 - (102 + 472))) or ((3558 + 212) >= (2241 + 1800))) then
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
	local v118;
	local v119 = 10361 + 750;
	local v120 = 12656 - (320 + 1225);
	local v121;
	v10:RegisterForEvent(function()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (0 + 0)) or ((5255 - (157 + 1307)) <= (3470 - (821 + 1038)))) then
				v119 = 27721 - 16610;
				v120 = 1216 + 9895;
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
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((8131 - 3553) <= (748 + 1260))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v142)
		return v142:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (12 - 7));
	end
	local function v130()
		if (((2151 - (834 + 192)) <= (132 + 1944)) and v93 and v122.AstralShift:IsReady()) then
			if ((v13:HealthPercentage() <= v59) or ((191 + 552) >= (95 + 4304))) then
				if (((1789 - 634) < (1977 - (300 + 4))) and v24(v122.AstralShift, not v15:IsInRange(11 + 29))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v96 and v122.EarthElemental:IsReady()) or ((6083 - 3759) <= (940 - (112 + 250)))) then
			if (((1502 + 2265) == (9437 - 5670)) and ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 15 + 10, v122.ChainHeal))) then
				if (((2115 + 1974) == (3059 + 1030)) and v24(v122.EarthElemental, not v15:IsInRange(20 + 20))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((3312 + 1146) >= (3088 - (1001 + 413))) and v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (((2167 - 1195) <= (2300 - (244 + 638))) and v24(v123.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((5631 - (627 + 66)) < (14188 - 9426))) then
			local v156 = 602 - (512 + 90);
			while true do
				if ((v156 == (1906 - (1665 + 241))) or ((3221 - (373 + 344)) > (1924 + 2340))) then
					if (((570 + 1583) == (5678 - 3525)) and (v40 == "Refreshing Healing Potion")) then
						if (v124.RefreshingHealingPotion:IsReady() or ((857 - 350) >= (3690 - (35 + 1064)))) then
							if (((3261 + 1220) == (9587 - 5106)) and v24(v123.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v40 == "Dreamwalker's Healing Potion") or ((10 + 2318) < (1929 - (298 + 938)))) then
						if (((5587 - (233 + 1026)) == (5994 - (636 + 1030))) and v124.DreamwalkersHealingPotion:IsReady()) then
							if (((812 + 776) >= (1302 + 30)) and v24(v123.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v131()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (0 + 0)) or ((4395 - (55 + 166)) > (824 + 3424))) then
				if (v114 or ((462 + 4124) <= (312 - 230))) then
					local v247 = 297 - (36 + 261);
					while true do
						if (((6755 - 2892) == (5231 - (34 + 1334))) and (v247 == (0 + 0))) then
							v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 24 + 6, true);
							if (v29 or ((1565 - (1035 + 248)) <= (63 - (20 + 1)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((2402 + 2207) >= (1085 - (134 + 185))) and v113) then
					v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 1163 - (549 + 584));
					if (v29 or ((1837 - (314 + 371)) == (8541 - 6053))) then
						return v29;
					end
					if (((4390 - (478 + 490)) > (1775 + 1575)) and v115) then
						local v255 = 1172 - (786 + 386);
						while true do
							if (((2840 - 1963) > (1755 - (1055 + 324))) and (v255 == (1340 - (1093 + 247)))) then
								v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 27 + 3);
								if (v29 or ((328 + 2790) <= (7348 - 5497))) then
									return v29;
								end
								break;
							end
						end
					end
					if (v116 or ((559 - 394) >= (9936 - 6444))) then
						local v256 = 0 - 0;
						while true do
							if (((1405 + 2544) < (18707 - 13851)) and (v256 == (0 - 0))) then
								v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 23 + 7);
								if (v29 or ((10935 - 6659) < (3704 - (364 + 324)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((12856 - 8166) > (9898 - 5773)) and v122.PurifySpirit:CooldownRemains()) then
						local v257 = 0 + 0;
						while true do
							if ((v257 == (0 - 0)) or ((80 - 30) >= (2721 - 1825))) then
								v29 = v126.HandleAfflicted(v122.HealingSurge, v123.HealingSurgeMouseover, 1298 - (1249 + 19));
								if (v29 or ((1548 + 166) >= (11513 - 8555))) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v143 = 1087 - (686 + 400);
			end
			if ((v143 == (1 + 0)) or ((1720 - (73 + 156)) < (4 + 640))) then
				if (((1515 - (721 + 90)) < (12 + 975)) and v41) then
					local v248 = 0 - 0;
					while true do
						if (((4188 - (224 + 246)) > (3087 - 1181)) and (v248 == (1 - 0))) then
							v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 8 + 32);
							if (v29 or ((23 + 935) > (2670 + 965))) then
								return v29;
							end
							break;
						end
						if (((6960 - 3459) <= (14948 - 10456)) and (v248 == (513 - (203 + 310)))) then
							v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 2033 - (1238 + 755));
							if (v29 or ((241 + 3201) < (4082 - (709 + 825)))) then
								return v29;
							end
							v248 = 1 - 0;
						end
					end
				end
				if (((4187 - 1312) >= (2328 - (196 + 668))) and v42) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (1 - 0)) or ((5630 - (171 + 662)) >= (4986 - (4 + 89)))) then
							v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 140 - 100);
							if (v29 or ((201 + 350) > (9083 - 7015))) then
								return v29;
							end
							v249 = 1 + 1;
						end
						if (((3600 - (35 + 1451)) > (2397 - (28 + 1425))) and (v249 == (1996 - (941 + 1052)))) then
							v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 39 + 1);
							if (v29 or ((3776 - (822 + 692)) >= (4419 - 1323))) then
								return v29;
							end
							break;
						end
						if ((v249 == (1 + 1)) or ((2552 - (45 + 252)) >= (3500 + 37))) then
							v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 14 + 26);
							if (v29 or ((9337 - 5500) < (1739 - (114 + 319)))) then
								return v29;
							end
							v249 = 3 - 0;
						end
						if (((3780 - 830) == (1881 + 1069)) and (v249 == (0 - 0))) then
							v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 83 - 43);
							if (v29 or ((6686 - (556 + 1407)) < (4504 - (741 + 465)))) then
								return v29;
							end
							v249 = 466 - (170 + 295);
						end
					end
				end
				v143 = 2 + 0;
			end
			if (((1044 + 92) >= (379 - 225)) and (v143 == (2 + 0))) then
				if (v43 or ((174 + 97) > (2689 + 2059))) then
					v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 1270 - (957 + 273));
					if (((1268 + 3472) >= (1262 + 1890)) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 152 - 112);
					if (v29 or ((6793 - 4215) >= (10354 - 6964))) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 198 - 158);
					if (((1821 - (389 + 1391)) <= (1043 + 618)) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 5 + 35);
					if (((1368 - 767) < (4511 - (783 + 168))) and v29) then
						return v29;
					end
				end
				if (((788 - 553) < (676 + 11)) and v44) then
					local v250 = 311 - (309 + 2);
					while true do
						if (((13969 - 9420) > (2365 - (1090 + 122))) and (v250 == (1 + 0))) then
							v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 134 - 94);
							if (v29 or ((3199 + 1475) < (5790 - (628 + 490)))) then
								return v29;
							end
							v250 = 1 + 1;
						end
						if (((9081 - 5413) < (20843 - 16282)) and ((774 - (431 + 343)) == v250)) then
							v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 80 - 40);
							if (v29 or ((1316 - 861) == (2848 + 757))) then
								return v29;
							end
							v250 = 1 + 0;
						end
						if ((v250 == (1697 - (556 + 1139))) or ((2678 - (6 + 9)) == (607 + 2705))) then
							v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 21 + 19);
							if (((4446 - (28 + 141)) <= (1734 + 2741)) and v29) then
								return v29;
							end
							v250 = 3 - 0;
						end
						if ((v250 == (3 + 0)) or ((2187 - (486 + 831)) == (3093 - 1904))) then
							v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 140 - 100);
							if (((294 + 1259) <= (9906 - 6773)) and v29) then
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
	local function v132()
		local v144 = 1263 - (668 + 595);
		while true do
			if ((v144 == (2 + 0)) or ((452 + 1785) >= (9574 - 6063))) then
				if ((v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) or ((1614 - (23 + 267)) > (4964 - (1129 + 815)))) then
					if (v24(v122.HealingTideTotem, not v15:IsInRange(427 - (371 + 16))) or ((4742 - (1326 + 424)) == (3562 - 1681))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((11350 - 8244) > (1644 - (88 + 30))) and v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) then
					if (((3794 - (720 + 51)) < (8608 - 4738)) and (v56 == "Player")) then
						if (((1919 - (421 + 1355)) > (121 - 47)) and v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(20 + 20))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((1101 - (286 + 797)) < (7720 - 5608)) and (v56 == "Friendly under Cursor")) then
						if (((1816 - 719) <= (2067 - (397 + 42))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((1447 + 3183) == (5430 - (24 + 776))) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(61 - 21))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((4325 - (222 + 563)) > (5911 - 3228)) and (v56 == "Confirmation")) then
						if (((3452 + 1342) >= (3465 - (23 + 167))) and v24(v122.AncestralProtectionTotem, not v15:IsInRange(1838 - (690 + 1108)))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v144 = 2 + 1;
			end
			if (((1225 + 259) == (2332 - (40 + 808))) and (v144 == (1 + 3))) then
				if (((5475 - 4043) < (3398 + 157)) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
					if (v24(v122.ManaTideTotem, not v15:IsInRange(22 + 18)) or ((585 + 480) > (4149 - (47 + 524)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v109 and v31) or not v109)) or ((3112 + 1683) < (3846 - 2439))) then
					local v251 = 0 - 0;
					while true do
						if (((4225 - 2372) < (6539 - (1165 + 561))) and (v251 == (1 + 1))) then
							if (v122.Fireblood:IsReady() or ((8737 - 5916) < (928 + 1503))) then
								if (v24(v122.Fireblood, not v15:IsInRange(519 - (341 + 138))) or ((776 + 2098) < (4500 - 2319))) then
									return "Fireblood cooldowns";
								end
							end
							break;
						end
						if (((327 - (89 + 237)) == v251) or ((8650 - 5961) <= (722 - 379))) then
							if (v122.Berserking:IsReady() or ((2750 - (581 + 300)) == (3229 - (855 + 365)))) then
								if (v24(v122.Berserking, not v15:IsInRange(95 - 55)) or ((1158 + 2388) < (3557 - (1030 + 205)))) then
									return "Berserking cooldowns";
								end
							end
							if (v122.BloodFury:IsReady() or ((1955 + 127) == (4441 + 332))) then
								if (((3530 - (156 + 130)) > (2397 - 1342)) and v24(v122.BloodFury, not v15:IsInRange(67 - 27))) then
									return "BloodFury cooldowns";
								end
							end
							v251 = 3 - 1;
						end
						if ((v251 == (0 + 0)) or ((1932 + 1381) <= (1847 - (10 + 59)))) then
							if (v122.AncestralCall:IsReady() or ((402 + 1019) >= (10361 - 8257))) then
								if (((2975 - (671 + 492)) <= (2587 + 662)) and v24(v122.AncestralCall, not v15:IsInRange(1255 - (369 + 846)))) then
									return "AncestralCall cooldowns";
								end
							end
							if (((430 + 1193) <= (1671 + 286)) and v122.BagofTricks:IsReady()) then
								if (((6357 - (1036 + 909)) == (3508 + 904)) and v24(v122.BagofTricks, not v15:IsInRange(67 - 27))) then
									return "BagofTricks cooldowns";
								end
							end
							v251 = 204 - (11 + 192);
						end
					end
				end
				break;
			end
			if (((885 + 865) >= (1017 - (135 + 40))) and (v144 == (6 - 3))) then
				if (((2636 + 1736) > (4075 - 2225)) and v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) then
					if (((347 - 115) < (997 - (50 + 126))) and v24(v122.AncestralGuidance, not v15:IsInRange(111 - 71))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((115 + 403) < (2315 - (1233 + 180))) and v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) then
					if (((3963 - (522 + 447)) > (2279 - (107 + 1314))) and v24(v122.Ascendance, not v15:IsInRange(19 + 21))) then
						return "ascendance cooldowns";
					end
				end
				v144 = 11 - 7;
			end
			if ((v144 == (1 + 0)) or ((7456 - 3701) <= (3620 - 2705))) then
				if (((5856 - (716 + 1194)) > (64 + 3679)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if ((v17:HealthPercentage() <= v83) or ((143 + 1192) >= (3809 - (74 + 429)))) then
						if (((9343 - 4499) > (1117 + 1136)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((1034 - 582) == (320 + 132)) and v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) then
					if ((v87 == "Player") or ((14048 - 9491) < (5159 - 3072))) then
						if (((4307 - (279 + 154)) == (4652 - (454 + 324))) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(32 + 8))) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v87 == "Friendly under Cursor") or ((1955 - (12 + 5)) > (2661 + 2274))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((10841 - 6586) < (1265 + 2158))) then
							if (((2547 - (277 + 816)) <= (10644 - 8153)) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(1223 - (1058 + 125)))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif ((v87 == "Confirmation") or ((780 + 3377) <= (3778 - (815 + 160)))) then
						if (((20822 - 15969) >= (7078 - 4096)) and v24(v122.SpiritLinkTotem, not v15:IsInRange(10 + 30))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v144 = 5 - 3;
			end
			if (((6032 - (41 + 1857)) > (5250 - (1222 + 671))) and (v144 == (0 - 0))) then
				if ((v111 and ((v31 and v110) or not v110)) or ((4911 - 1494) < (3716 - (229 + 953)))) then
					local v252 = 1774 - (1111 + 663);
					while true do
						if ((v252 == (1579 - (874 + 705))) or ((382 + 2340) <= (112 + 52))) then
							v29 = v126.HandleTopTrinket(v125, v31, 83 - 43, nil);
							if (v29 or ((68 + 2340) < (2788 - (642 + 37)))) then
								return v29;
							end
							v252 = 1 + 0;
						end
						if ((v252 == (1 + 0)) or ((82 - 49) == (1909 - (233 + 221)))) then
							v29 = v126.HandleBottomTrinket(v125, v31, 92 - 52, nil);
							if (v29 or ((390 + 53) >= (5556 - (718 + 823)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((2129 + 1253) > (971 - (266 + 539))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((792 - 512) == (4284 - (636 + 589)))) then
						if (((4464 - 2583) > (2666 - 1373)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingcd tank";
						end
					end
				end
				v144 = 1 + 0;
			end
		end
	end
	local function v133()
		local v145 = 0 + 0;
		while true do
			if (((3372 - (657 + 358)) == (6240 - 3883)) and ((6 - 3) == v145)) then
				if (((1310 - (1151 + 36)) == (119 + 4)) and v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) then
					if (v24(v122.SpiritwalkersGrace, nil) or ((278 + 778) >= (10129 - 6737))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) or ((2913 - (1552 + 280)) < (1909 - (64 + 770)))) then
					if (v24(v122.HealingStreamTotem, nil) or ((713 + 336) >= (10060 - 5628))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v145 == (1 + 0)) or ((6011 - (157 + 1086)) <= (1693 - 847))) then
				if ((v105 and v122.UnleashLife:IsReady()) or ((14707 - 11349) <= (2178 - 758))) then
					if ((v13:HealthPercentage() <= v90) or ((5102 - 1363) <= (3824 - (599 + 220)))) then
						if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((3303 - 1644) >= (4065 - (1813 + 118)))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) or ((2383 + 877) < (3572 - (841 + 376)))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(56 - 16), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((156 + 513) == (11526 - 7303))) then
						return "healing_rain healingaoe";
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) or ((2551 - (464 + 395)) < (1508 - 920))) then
					if ((v74 == "Player") or ((2304 + 2493) < (4488 - (467 + 370)))) then
						if (v24(v123.HealingRainPlayer, not v15:IsInRange(82 - 42), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3067 + 1110) > (16625 - 11775))) then
							return "healing_rain healingaoe";
						end
					elseif ((v74 == "Friendly under Cursor") or ((63 + 337) > (2584 - 1473))) then
						if (((3571 - (150 + 370)) > (2287 - (74 + 1208))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((9083 - 5390) <= (20782 - 16400)) and v24(v123.HealingRainCursor, not v15:IsInRange(29 + 11), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v74 == "Enemy under Cursor") or ((3672 - (14 + 376)) > (7111 - 3011))) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((2317 + 1263) < (2499 + 345))) then
							if (((85 + 4) < (13156 - 8666)) and v24(v123.HealingRainCursor, not v15:IsInRange(31 + 9), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v74 == "Confirmation") or ((5061 - (23 + 55)) < (4284 - 2476))) then
						if (((2556 + 1273) > (3385 + 384)) and v24(v122.HealingRain, not v15:IsInRange(62 - 22), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((468 + 1017) <= (3805 - (652 + 249))) and v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) then
					if (((11424 - 7155) == (6137 - (708 + 1160))) and (v71 == "Player")) then
						if (((1050 - 663) <= (5071 - 2289)) and v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(67 - (10 + 17)))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v71 == "Friendly under Cursor") or ((427 + 1472) <= (2649 - (1400 + 332)))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((8270 - 3958) <= (2784 - (242 + 1666)))) then
							if (((956 + 1276) <= (952 + 1644)) and v24(v123.EarthenWallTotemCursor, not v15:IsInRange(35 + 5))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((3035 - (850 + 90)) < (6455 - 2769)) and (v71 == "Confirmation")) then
						if (v24(v122.EarthenWallTotem, not v15:IsInRange(1430 - (360 + 1030))) or ((1412 + 183) >= (12627 - 8153))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v145 = 2 - 0;
			end
			if ((v145 == (1663 - (909 + 752))) or ((5842 - (109 + 1114)) < (5275 - 2393))) then
				if ((v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) or ((115 + 179) >= (5073 - (6 + 236)))) then
					if (((1279 + 750) <= (2483 + 601)) and (v66 == "Player")) then
						if (v24(v123.DownpourPlayer, not v15:IsInRange(94 - 54), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3557 - 1520) == (3553 - (1076 + 57)))) then
							return "downpour healingaoe";
						end
					elseif (((734 + 3724) > (4593 - (579 + 110))) and (v66 == "Friendly under Cursor")) then
						if (((35 + 401) >= (109 + 14)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((266 + 234) < (2223 - (174 + 233))) and v24(v123.DownpourCursor, not v15:IsInRange(111 - 71), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif (((6272 - 2698) == (1590 + 1984)) and (v66 == "Confirmation")) then
						if (((1395 - (663 + 511)) < (348 + 42)) and v24(v122.Downpour, not v15:IsInRange(9 + 31), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (30 - 20))) or ((1341 + 872) <= (3345 - 1924))) then
					if (((7402 - 4344) < (2320 + 2540)) and v24(v122.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) or ((2522 - 1226) >= (3169 + 1277))) then
					if (v24(v122.Wellspring, not v15:IsInRange(4 + 36), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2115 - (478 + 244)) > (5006 - (440 + 77)))) then
						return "wellspring healingaoe";
					end
				end
				if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) or ((2012 + 2412) < (98 - 71))) then
					if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3553 - (655 + 901)) > (708 + 3107))) then
						return "chain_heal healingaoe";
					end
				end
				v145 = 3 + 0;
			end
			if (((2340 + 1125) > (7706 - 5793)) and (v145 == (1445 - (695 + 750)))) then
				if (((2502 - 1769) < (2806 - 987)) and v94 and v126.AreUnitsBelowHealthPercentage(382 - 287, 354 - (285 + 66), v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
					if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((10245 - 5850) == (6065 - (682 + 628)))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (3 + 12))) or ((4092 - (176 + 123)) < (991 + 1378))) then
					if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((2963 + 1121) == (534 - (239 + 30)))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((1185 + 3173) == (4189 + 169)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((5553 - 2415) < (3097 - 2104))) then
						if (((3645 - (306 + 9)) > (8106 - 5783)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((631 + 2995) == (2448 + 1541))) then
					if ((v17:HealthPercentage() <= v83) or ((441 + 475) == (7637 - 4966))) then
						if (((1647 - (1140 + 235)) == (174 + 98)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 1 + 0;
			end
		end
	end
	local function v134()
		local v146 = 0 + 0;
		while true do
			if (((4301 - (33 + 19)) <= (1748 + 3091)) and ((0 - 0) == v146)) then
				if (((1224 + 1553) < (6275 - 3075)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((90 + 5) < (2646 - (586 + 103))) and (v17:HealthPercentage() <= v83)) then
						if (((76 + 750) < (5285 - 3568)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((2914 - (1309 + 179)) >= (1994 - 889)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((1199 + 1555) <= (9074 - 5695)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((2967 + 960) == (3001 - 1588))) then
							return "riptide healingaoe";
						end
					end
				end
				v146 = 1 - 0;
			end
			if (((610 - (295 + 314)) == v146) or ((2833 - 1679) <= (2750 - (1300 + 662)))) then
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) or ((5159 - 3516) > (5134 - (1178 + 577)))) then
					if (v24(v122.EarthShield) or ((1456 + 1347) > (13447 - 8898))) then
						return "earth_shield player healingst";
					end
				end
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) or ((1625 - (851 + 554)) >= (2673 + 349))) then
					if (((7826 - 5004) == (6128 - 3306)) and v126.IsSoloMode()) then
						if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((1363 - (115 + 187)) == (1423 + 434))) then
							if (((2613 + 147) > (5374 - 4010)) and v24(v122.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) or ((6063 - (160 + 1001)) <= (3146 + 449))) then
						if (v24(v122.WaterShield) or ((2658 + 1194) == (599 - 306))) then
							return "water_shield healingst";
						end
					end
				end
				v146 = 360 - (237 + 121);
			end
			if (((899 - (525 + 372)) == v146) or ((2955 - 1396) == (15074 - 10486))) then
				if ((v99 and v122.HealingSurge:IsReady()) or ((4626 - (96 + 46)) == (1565 - (643 + 134)))) then
					if (((1650 + 2918) >= (9368 - 5461)) and (v17:HealthPercentage() <= v77)) then
						if (((4625 - 3379) < (3328 + 142)) and v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				if (((7983 - 3915) >= (1986 - 1014)) and v101 and v122.HealingWave:IsReady()) then
					if (((1212 - (316 + 403)) < (2588 + 1305)) and (v17:HealthPercentage() <= v80)) then
						if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4049 - 2576) >= (1205 + 2127))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		if (v122.Stormkeeper:IsReady() or ((10201 - 6150) <= (820 + 337))) then
			if (((195 + 409) < (9982 - 7101)) and v24(v122.Stormkeeper, not v15:IsInRange(191 - 151))) then
				return "stormkeeper damage";
			end
		end
		if ((math.max(#v13:GetEnemiesInRange(41 - 21), v13:GetEnemiesInSplashRangeCount(1 + 7)) > (3 - 1)) or ((44 + 856) == (9935 - 6558))) then
			if (((4476 - (12 + 5)) > (2295 - 1704)) and v122.ChainLightning:IsReady()) then
				if (((7249 - 3851) >= (5091 - 2696)) and v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "chain_lightning damage";
				end
			end
		end
		if (v122.FlameShock:IsReady() or ((5413 - 3230) >= (574 + 2250))) then
			local v157 = 1973 - (1656 + 317);
			while true do
				if (((1726 + 210) == (1552 + 384)) and (v157 == (0 - 0))) then
					if (v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(196 - 156), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil) or ((5186 - (5 + 349)) < (20486 - 16173))) then
						return "flame_shock_cycle damage";
					end
					if (((5359 - (266 + 1005)) > (2553 + 1321)) and v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock))) then
						return "flame_shock damage";
					end
					break;
				end
			end
		end
		if (((14781 - 10449) == (5702 - 1370)) and v122.LavaBurst:IsReady()) then
			if (((5695 - (561 + 1135)) >= (3779 - 879)) and v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "lava_burst damage";
			end
		end
		if (v122.LightningBolt:IsReady() or ((8299 - 5774) > (5130 - (507 + 559)))) then
			if (((10968 - 6597) == (13518 - 9147)) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v136()
		local v147 = 388 - (212 + 176);
		while true do
			if ((v147 == (909 - (250 + 655))) or ((725 - 459) > (8712 - 3726))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v83 = EpicSettings.Settings['RiptideHP'];
				v84 = EpicSettings.Settings['RiptideTankHP'];
				v147 = 7 - 2;
			end
			if (((3947 - (1869 + 87)) >= (3208 - 2283)) and (v147 == (1909 - (484 + 1417)))) then
				v105 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((975 - 520) < (3439 - 1386)) and (v147 == (776 - (48 + 725)))) then
				v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v76 = EpicSettings.Settings['HealingStreamTotemHP'];
				v77 = EpicSettings.Settings['HealingSurgeHP'];
				v78 = EpicSettings.Settings['HealingTideTotemGroup'];
				v79 = EpicSettings.Settings['HealingTideTotemHP'];
				v80 = EpicSettings.Settings['HealingWaveHP'];
				v147 = 5 - 1;
			end
			if ((v147 == (0 - 0)) or ((481 + 345) == (12963 - 8112))) then
				v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v60 = EpicSettings.Settings['ChainHealGroup'];
				v61 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v147 = 1 + 0;
			end
			if (((54 + 129) == (1036 - (152 + 701))) and (v147 == (1316 - (430 + 881)))) then
				v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v90 = EpicSettings.Settings['UnleashLifeHP'];
				v147 = 3 + 3;
			end
			if (((2054 - (557 + 338)) <= (529 + 1259)) and (v147 == (5 - 3))) then
				v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v72 = EpicSettings.Settings['HealingRainGroup'];
				v73 = EpicSettings.Settings['HealingRainHP'];
				v74 = EpicSettings.Settings['HealingRainUsage'];
				v147 = 10 - 7;
			end
			if (((2 - 1) == v147) or ((7558 - 4051) > (5119 - (499 + 302)))) then
				v46 = EpicSettings.Settings['DispelBuffs'];
				v64 = EpicSettings.Settings['DownpourGroup'];
				v65 = EpicSettings.Settings['DownpourHP'];
				v66 = EpicSettings.Settings['DownpourUsage'];
				v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v70 = EpicSettings.Settings['EarthenWallTotemHP'];
				v147 = 868 - (39 + 827);
			end
			if ((v147 == (19 - 12)) or ((6867 - 3792) <= (11776 - 8811))) then
				v100 = EpicSettings.Settings['UseHealingTideTotem'];
				v101 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v103 = EpicSettings.Settings['UseRiptide'];
				v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v147 = 11 - 3;
			end
			if (((117 + 1248) <= (5885 - 3874)) and (v147 == (1 + 5))) then
				v94 = EpicSettings.Settings['UseChainHeal'];
				v95 = EpicSettings.Settings['UseCloudburstTotem'];
				v97 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v98 = EpicSettings.Settings['UseHealingStreamTotem'];
				v99 = EpicSettings.Settings['UseHealingSurge'];
				v147 = 10 - 3;
			end
		end
	end
	local function v137()
		local v148 = 104 - (103 + 1);
		while true do
			if ((v148 == (559 - (475 + 79))) or ((6001 - 3225) > (11440 - 7865))) then
				v112 = EpicSettings.Settings['fightRemainsCheck'];
				v51 = EpicSettings.Settings['useWeapon'];
				v113 = EpicSettings.Settings['handleAfflicted'];
				v114 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v148 = 1 + 5;
			end
			if ((v148 == (6 + 0)) or ((4057 - (1395 + 108)) == (13979 - 9175))) then
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((3781 - (7 + 1197)) == (1124 + 1453)) and (v148 == (2 + 2))) then
				v118 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v110 = EpicSettings.Settings['trinketsWithCD'];
				v111 = EpicSettings.Settings['useTrinkets'];
				v148 = 324 - (27 + 292);
			end
			if ((v148 == (8 - 5)) or ((7 - 1) >= (7921 - 6032))) then
				v102 = EpicSettings.Settings['UseManaTideTotem'];
				v106 = EpicSettings.Settings['UseWellspring'];
				v107 = EpicSettings.Settings['WellspringGroup'];
				v108 = EpicSettings.Settings['WellspringHP'];
				v117 = EpicSettings.Settings['useManaPotion'];
				v148 = 7 - 3;
			end
			if (((963 - 457) <= (2031 - (43 + 96))) and (v148 == (8 - 6))) then
				v82 = EpicSettings.Settings['PrimordialWaveHP'];
				v91 = EpicSettings.Settings['UseAncestralGuidance'];
				v92 = EpicSettings.Settings['UseAscendance'];
				v93 = EpicSettings.Settings['UseAstralShift'];
				v96 = EpicSettings.Settings['UseEarthElemental'];
				v148 = 6 - 3;
			end
			if ((v148 == (0 + 0)) or ((567 + 1441) > (4383 - 2165))) then
				v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v53 = EpicSettings.Settings['AncestralGuidanceHP'];
				v57 = EpicSettings.Settings['AscendanceGroup'];
				v58 = EpicSettings.Settings['AscendanceHP'];
				v59 = EpicSettings.Settings['AstralShiftHP'];
				v148 = 1 + 0;
			end
			if (((709 - 330) <= (1306 + 2841)) and (v148 == (1 + 0))) then
				v62 = EpicSettings.Settings['CloudburstTotemGroup'];
				v63 = EpicSettings.Settings['CloudburstTotemHP'];
				v67 = EpicSettings.Settings['EarthElementalHP'];
				v68 = EpicSettings.Settings['EarthElementalTankHP'];
				v81 = EpicSettings.Settings['ManaTideTotemMana'];
				v148 = 1753 - (1414 + 337);
			end
		end
	end
	local v138 = 1940 - (1642 + 298);
	local function v139()
		local v149 = 0 - 0;
		local v150;
		while true do
			if ((v149 == (14 - 9)) or ((13395 - 8881) <= (333 + 676))) then
				if ((v13:AffectingCombat() and v126.TargetIsValid()) or ((2721 + 775) == (2164 - (357 + 615)))) then
					if ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady() or ((147 + 61) == (7260 - 4301))) then
						if (((3665 + 612) >= (2813 - 1500)) and v24(v123.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((2070 + 517) < (216 + 2958)) and v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) then
						if (v24(v123.ManaPotion, nil) or ((2590 + 1530) <= (3499 - (384 + 917)))) then
							return "Mana Potion main";
						end
					end
					v29 = v126.Interrupt(v122.WindShear, 727 - (128 + 569), true);
					if (v29 or ((3139 - (1407 + 136)) == (2745 - (687 + 1200)))) then
						return v29;
					end
					v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 1740 - (556 + 1154), true, v16);
					if (((11328 - 8108) == (3315 - (9 + 86))) and v29) then
						return v29;
					end
					v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 451 - (275 + 146), nil, v16);
					if (v29 or ((229 + 1173) > (3684 - (29 + 35)))) then
						return v29;
					end
					v150 = v130();
					if (((11407 - 8833) == (7687 - 5113)) and v150) then
						return v150;
					end
					if (((7937 - 6139) < (1796 + 961)) and v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) then
						if (v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge)) or ((1389 - (53 + 959)) > (3012 - (312 + 96)))) then
							return "greater_purge utility";
						end
					end
					if (((985 - 417) < (1196 - (147 + 138))) and v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) then
						if (((4184 - (813 + 86)) < (3821 + 407)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
							return "purge utility";
						end
					end
					if (((7254 - 3338) > (3820 - (18 + 474))) and (v120 > v112)) then
						local v258 = 0 + 0;
						while true do
							if (((8159 - 5659) < (4925 - (860 + 226))) and (v258 == (303 - (121 + 182)))) then
								v150 = v132();
								if (((63 + 444) == (1747 - (988 + 252))) and v150) then
									return v150;
								end
								break;
							end
						end
					end
				end
				if (((28 + 212) <= (992 + 2173)) and (v30 or v13:AffectingCombat())) then
					if (((2804 - (49 + 1921)) >= (1695 - (223 + 667))) and v32 and v45) then
						if ((v122.Bursting:MaxDebuffStack() > (56 - (51 + 1))) or ((6560 - 2748) < (4959 - 2643))) then
							local v263 = 1125 - (146 + 979);
							while true do
								if ((v263 == (0 + 0)) or ((3257 - (311 + 294)) <= (4274 - 2741))) then
									v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
									if (v29 or ((1525 + 2073) < (2903 - (496 + 947)))) then
										return v29;
									end
									break;
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer()) or ((5474 - (1233 + 125)) < (484 + 708))) then
							if (v126.UnitHasPoisonDebuff(v16) or ((3030 + 347) <= (172 + 731))) then
								if (((5621 - (963 + 682)) >= (367 + 72)) and v122.PoisonCleansingTotem:IsCastable()) then
									if (((5256 - (504 + 1000)) == (2527 + 1225)) and v24(v122.PoisonCleansingTotem, nil)) then
										return "poison_cleansing_totem dispel mouseover";
									end
								end
							end
						end
						if (((3685 + 361) > (255 + 2440)) and v17 and v17:Exists() and v17:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v17)) then
							if (v122.PurifySpirit:IsCastable() or ((5227 - 1682) == (2732 + 465))) then
								if (((1393 + 1001) > (555 - (156 + 26))) and (v138 == (0 + 0))) then
									v138 = GetTime();
								end
								if (((6500 - 2345) <= (4396 - (149 + 15))) and v126.Wait(1460 - (890 + 70), v138)) then
									local v268 = 117 - (39 + 78);
									while true do
										if ((v268 == (482 - (14 + 468))) or ((7874 - 4293) == (9707 - 6234))) then
											if (((2578 + 2417) > (2011 + 1337)) and v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit))) then
												return "purify_spirit dispel focus";
											end
											v138 = 0 + 0;
											break;
										end
									end
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((341 + 413) > (976 + 2748))) then
							if (((415 - 198) >= (57 + 0)) and v122.PurifySpirit:IsCastable()) then
								if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((7274 - 5204) >= (102 + 3935))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
					end
					if (((2756 - (12 + 39)) == (2517 + 188)) and (v122.Bursting:AuraActiveCount() > (9 - 6))) then
						local v259 = 0 - 0;
						while true do
							if (((19 + 42) == (33 + 28)) and (v259 == (0 - 0))) then
								if (((v122.Bursting:MaxDebuffStack() > (4 + 1)) and v122.SpiritLinkTotem:IsReady()) or ((3378 - 2679) >= (3006 - (1596 + 114)))) then
									if ((v87 == "Player") or ((4654 - 2871) >= (4329 - (164 + 549)))) then
										if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(1478 - (1059 + 379))) or ((4858 - 945) > (2347 + 2180))) then
											return "spirit_link_totem bursting";
										end
									elseif (((738 + 3638) > (1209 - (145 + 247))) and (v87 == "Friendly under Cursor")) then
										if (((3989 + 872) > (381 + 443)) and v16:Exists() and not v13:CanAttack(v16)) then
											if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(118 - 78)) or ((266 + 1117) >= (1836 + 295))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif ((v87 == "Confirmation") or ((3045 - 1169) >= (3261 - (254 + 466)))) then
										if (((2342 - (544 + 16)) <= (11987 - 8215)) and v24(v122.SpiritLinkTotem, not v15:IsInRange(668 - (294 + 334)))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v94 and v122.ChainHeal:IsReady()) or ((4953 - (236 + 17)) < (351 + 462))) then
									if (((2491 + 708) < (15252 - 11202)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
								break;
							end
						end
					end
					if ((v17:Exists() and (v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) or ((23440 - 18489) < (2281 + 2149))) then
						if (((80 + 16) == (890 - (413 + 381))) and v122.PrimordialWaveResto:IsCastable()) then
							if (v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto)) or ((116 + 2623) > (8524 - 4516))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (7 - 4)))) or ((1993 - (582 + 1388)) == (1931 - 797))) then
						if (v24(v122.TotemicRecall, nil) or ((1928 + 765) >= (4475 - (326 + 38)))) then
							return "totemic_recall main";
						end
					end
					if ((v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) or ((12767 - 8451) <= (3063 - 917))) then
						if (v24(v122.NaturesSwiftness, nil) or ((4166 - (47 + 573)) <= (991 + 1818))) then
							return "natures_swiftness main";
						end
					end
					if (((20827 - 15923) > (3515 - 1349)) and v33) then
						local v260 = 1664 - (1269 + 395);
						while true do
							if (((601 - (76 + 416)) >= (533 - (319 + 124))) and ((2 - 1) == v260)) then
								if (((5985 - (564 + 443)) > (8042 - 5137)) and v150) then
									return v150;
								end
								v150 = v134();
								v260 = 460 - (337 + 121);
							end
							if ((v260 == (5 - 3)) or ((10079 - 7053) <= (4191 - (1261 + 650)))) then
								if (v150 or ((700 + 953) <= (1765 - 657))) then
									return v150;
								end
								break;
							end
							if (((4726 - (772 + 1045)) > (369 + 2240)) and (v260 == (144 - (102 + 42)))) then
								if (((2601 - (1524 + 320)) > (1464 - (1049 + 221))) and v15:Exists() and not v13:CanAttack(v15)) then
									local v267 = 156 - (18 + 138);
									while true do
										if ((v267 == (0 - 0)) or ((1133 - (67 + 1035)) >= (1746 - (136 + 212)))) then
											if (((13581 - 10385) <= (3904 + 968)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
												if (((3067 + 259) == (4930 - (240 + 1364))) and (v15:HealthPercentage() <= v83)) then
													if (((2515 - (1050 + 32)) <= (13846 - 9968)) and v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide))) then
														return "riptide healing target";
													end
												end
											end
											if ((v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) or ((937 + 646) == (2790 - (331 + 724)))) then
												if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((241 + 2740) == (2994 - (269 + 375)))) then
													return "unleash_life healing target";
												end
											end
											v267 = 726 - (267 + 458);
										end
										if ((v267 == (1 + 0)) or ((8588 - 4122) <= (1311 - (667 + 151)))) then
											if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((4044 - (1410 + 87)) <= (3884 - (1504 + 393)))) then
												if (((8003 - 5042) > (7108 - 4368)) and v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
													return "chain_heal healing target";
												end
											end
											if (((4492 - (461 + 335)) >= (462 + 3150)) and v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) then
												if (v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((4731 - (1730 + 31)) == (3545 - (728 + 939)))) then
													return "healing_wave healing target";
												end
											end
											break;
										end
									end
								end
								v150 = v133();
								v260 = 3 - 2;
							end
						end
					end
					if (v34 or ((7490 - 3797) < (4529 - 2552))) then
						if (v126.TargetIsValid() or ((1998 - (138 + 930)) > (1920 + 181))) then
							local v264 = 0 + 0;
							while true do
								if (((3560 + 593) > (12600 - 9514)) and ((1766 - (459 + 1307)) == v264)) then
									v150 = v135();
									if (v150 or ((6524 - (474 + 1396)) <= (7072 - 3022))) then
										return v150;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if ((v149 == (1 + 0)) or ((9 + 2593) < (4285 - 2789))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v149 = 1 + 1;
			end
			if ((v149 == (9 - 6)) or ((4448 - 3428) > (2879 - (562 + 29)))) then
				if (((280 + 48) == (1747 - (374 + 1045))) and (v126.TargetIsValid() or v13:AffectingCombat())) then
					v121 = v13:GetEnemiesInRange(32 + 8);
					v119 = v10.BossFightRemains(nil, true);
					v120 = v119;
					if (((4691 - 3180) < (4446 - (448 + 190))) and (v120 == (3588 + 7523))) then
						v120 = v10.FightRemains(v121, false);
					end
				end
				if (not v13:AffectingCombat() or ((1134 + 1376) > (3206 + 1713))) then
					if (((18312 - 13549) == (14799 - 10036)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v261 = 1494 - (1307 + 187);
						local v262;
						while true do
							if (((16405 - 12268) > (4326 - 2478)) and (v261 == (0 - 0))) then
								v262 = v126.DeadFriendlyUnitsCount();
								if (((3119 - (232 + 451)) <= (2993 + 141)) and (v262 > (1 + 0))) then
									if (((4287 - (510 + 54)) == (7500 - 3777)) and v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (v24(v123.AncestralSpiritMouseover, not v15:IsInRange(76 - (13 + 23)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((7886 - 3840) >= (6201 - 1885))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v150 = v131();
				v149 = 7 - 3;
			end
			if ((v149 == (1092 - (830 + 258))) or ((7083 - 5075) < (1207 + 722))) then
				if (((2029 + 355) > (3216 - (860 + 581))) and v150) then
					return v150;
				end
				if (v13:AffectingCombat() or v30 or ((16757 - 12214) <= (3473 + 903))) then
					local v253 = 241 - (237 + 4);
					local v254;
					while true do
						if (((1710 - 982) == (1841 - 1113)) and (v253 == (1 - 0))) then
							if (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 21 + 4) >= (1 + 0)) or ((4062 - 2986) > (2005 + 2666))) then
								local v265 = 0 + 0;
								while true do
									if (((3277 - (85 + 1341)) >= (644 - 266)) and ((0 - 0) == v265)) then
										v29 = v126.FocusUnit(v254, nil, 412 - (45 + 327), nil, 47 - 22, v122.ChainHeal);
										if (v29 or ((2450 - (444 + 58)) >= (1511 + 1965))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((825 + 3969) >= (408 + 425)) and (v253 == (0 - 0))) then
							v254 = v45 and v122.PurifySpirit:IsReady() and v32;
							if (((5822 - (64 + 1668)) == (6063 - (1227 + 746))) and v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 76 - 51) < (1 - 0))) then
								local v266 = 494 - (415 + 79);
								while true do
									if ((v266 == (1 + 0)) or ((4249 - (142 + 349)) == (1071 + 1427))) then
										if ((v126.UnitGroupRole(v17) == "TANK") or ((3674 - 1001) < (783 + 792))) then
											if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((2622 + 1099) <= (3962 - 2507))) then
												return "earth_shield_tank main apl 1";
											end
										end
										break;
									end
									if (((2798 - (1710 + 154)) < (2588 - (200 + 118))) and (v266 == (0 + 0))) then
										v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 26 - 11, 59 - 19, "TANK", true, 23 + 2, v122.ChainHeal);
										if (v29 or ((1595 + 17) == (674 + 581))) then
											return v29;
										end
										v266 = 1 + 0;
									end
								end
							end
							v253 = 2 - 1;
						end
					end
				end
				if ((v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(1290 - (363 + 887)) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) or ((7598 - 3246) < (20019 - 15813))) then
					if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((442 + 2418) <= (423 - 242))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v149 = 4 + 1;
			end
			if (((4886 - (674 + 990)) >= (438 + 1089)) and (v149 == (0 + 0))) then
				v136();
				v137();
				v30 = EpicSettings.Toggles['ooc'];
				v149 = 1 - 0;
			end
			if (((2560 - (507 + 548)) <= (2958 - (289 + 548))) and (v149 == (1820 - (821 + 997)))) then
				v34 = EpicSettings.Toggles['dps'];
				v150 = nil;
				if (((999 - (195 + 60)) == (201 + 543)) and v13:IsDeadOrGhost()) then
					return;
				end
				v149 = 1504 - (251 + 1250);
			end
		end
	end
	local function v140()
		local v151 = 0 - 0;
		while true do
			if ((v151 == (0 + 0)) or ((3011 - (809 + 223)) >= (4138 - 1302))) then
				v128();
				v122.Bursting:RegisterAuraTracking();
				v151 = 2 - 1;
			end
			if (((6060 - 4227) <= (1965 + 703)) and (v151 == (1 + 0))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(881 - (14 + 603), v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

