local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((4023 - 1957) == (734 + 198))) then
			return v6(...);
		end
		if (((6305 - (641 + 839)) < (5756 - (910 + 3))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((5561 - (1466 + 218)) >= (2086 + 2451))) then
				return v1(v4, ...);
			end
			v5 = 1149 - (556 + 592);
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
	local v119 = 3952 + 7159;
	local v120 = 11919 - (329 + 479);
	local v121;
	v10:RegisterForEvent(function()
		v119 = 11965 - (174 + 680);
		v120 = 38179 - 27068;
	end, "PLAYER_REGEN_ENABLED");
	local v122 = v18.Shaman.Restoration;
	local v123 = v25.Shaman.Restoration;
	local v124 = v20.Shaman.Restoration;
	local v125 = {};
	local v126 = v22.Commons.Everyone;
	local v127 = v22.Commons.Shaman;
	local function v128()
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((8943 - 4628) < (1233 + 493))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v141)
		return v141:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (744 - (396 + 343)));
	end
	local function v130()
		if ((v93 and v122.AstralShift:IsReady()) or ((326 + 3353) < (2102 - (29 + 1448)))) then
			if ((v13:HealthPercentage() <= v59) or ((6014 - (135 + 1254)) < (2380 - 1748))) then
				if (v24(v122.AstralShift, not v15:IsInRange(186 - 146)) or ((56 + 27) > (3307 - (389 + 1138)))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((1120 - (102 + 472)) <= (1017 + 60)) and v96 and v122.EarthElemental:IsReady()) then
			if ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68) or ((553 + 443) > (4011 + 290))) then
				if (((5615 - (320 + 1225)) > (1222 - 535)) and v24(v122.EarthElemental, not v15:IsInRange(25 + 15))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((2120 - (157 + 1307)) >= (5189 - (821 + 1038)))) then
			if (v24(v123.Healthstone) or ((6217 - 3725) <= (37 + 298))) then
				return "healthstone defensive 3";
			end
		end
		if (((7676 - 3354) >= (954 + 1608)) and v38 and (v13:HealthPercentage() <= v39)) then
			local v153 = 0 - 0;
			while true do
				if ((v153 == (1026 - (834 + 192))) or ((232 + 3405) >= (968 + 2802))) then
					if ((v40 == "Refreshing Healing Potion") or ((52 + 2327) > (7092 - 2514))) then
						if (v124.RefreshingHealingPotion:IsReady() or ((787 - (300 + 4)) > (199 + 544))) then
							if (((6423 - 3969) > (940 - (112 + 250))) and v24(v123.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((371 + 559) < (11168 - 6710)) and (v40 == "Dreamwalker's Healing Potion")) then
						if (((380 + 282) <= (503 + 469)) and v124.DreamwalkersHealingPotion:IsReady()) then
							if (((3269 + 1101) == (2167 + 2203)) and v24(v123.RefreshingHealingPotion)) then
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
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1416 - (1001 + 413))) or ((10619 - 5857) <= (1743 - (244 + 638)))) then
				if (v43 or ((2105 - (627 + 66)) == (12704 - 8440))) then
					v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 642 - (512 + 90));
					if (v29 or ((5074 - (1665 + 241)) < (2870 - (373 + 344)))) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 19 + 21);
					if (v29 or ((1317 + 3659) < (3513 - 2181))) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 67 - 27);
					if (((5727 - (35 + 1064)) == (3368 + 1260)) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 85 - 45);
					if (v29 or ((1 + 53) == (1631 - (298 + 938)))) then
						return v29;
					end
				end
				if (((1341 - (233 + 1026)) == (1748 - (636 + 1030))) and v44) then
					local v245 = 0 + 0;
					while true do
						if ((v245 == (1 + 0)) or ((173 + 408) < (20 + 262))) then
							v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 261 - (55 + 166));
							if (v29 or ((894 + 3715) < (251 + 2244))) then
								return v29;
							end
							v245 = 7 - 5;
						end
						if (((1449 - (36 + 261)) == (2014 - 862)) and (v245 == (1370 - (34 + 1334)))) then
							v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 16 + 24);
							if (((1474 + 422) <= (4705 - (1035 + 248))) and v29) then
								return v29;
							end
							v245 = 24 - (20 + 1);
						end
						if (((0 + 0) == v245) or ((1309 - (134 + 185)) > (2753 - (549 + 584)))) then
							v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 725 - (314 + 371));
							if (v29 or ((3010 - 2133) > (5663 - (478 + 490)))) then
								return v29;
							end
							v245 = 1 + 0;
						end
						if (((3863 - (786 + 386)) >= (5995 - 4144)) and (v245 == (1382 - (1055 + 324)))) then
							v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 1380 - (1093 + 247));
							if (v29 or ((2653 + 332) >= (511 + 4345))) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((16976 - 12700) >= (4055 - 2860)) and (v142 == (0 - 0))) then
				if (((8121 - 4889) <= (1669 + 3021)) and v114) then
					local v246 = 0 - 0;
					while true do
						if ((v246 == (0 - 0)) or ((676 + 220) >= (8045 - 4899))) then
							v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 718 - (364 + 324), true);
							if (((8391 - 5330) >= (7097 - 4139)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((1057 + 2130) >= (2694 - 2050)) and v113) then
					local v247 = 0 - 0;
					while true do
						if (((1955 - 1311) <= (1972 - (1249 + 19))) and (v247 == (1 + 0))) then
							if (((3728 - 2770) > (2033 - (686 + 400))) and v115) then
								v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 24 + 6);
								if (((4721 - (73 + 156)) >= (13 + 2641)) and v29) then
									return v29;
								end
							end
							if (((4253 - (721 + 90)) >= (17 + 1486)) and v116) then
								local v257 = 0 - 0;
								while true do
									if ((v257 == (470 - (224 + 246))) or ((5135 - 1965) <= (2694 - 1230))) then
										v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 6 + 24);
										if (v29 or ((115 + 4682) == (3223 + 1165))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if (((1095 - 544) <= (2266 - 1585)) and (v247 == (513 - (203 + 310)))) then
							v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 2023 - (1238 + 755));
							if (((229 + 3048) > (1941 - (709 + 825))) and v29) then
								return v29;
							end
							v247 = 1 - 0;
						end
					end
				end
				v142 = 1 - 0;
			end
			if (((5559 - (196 + 668)) >= (5586 - 4171)) and (v142 == (1 - 0))) then
				if (v41 or ((4045 - (171 + 662)) <= (1037 - (4 + 89)))) then
					local v248 = 0 - 0;
					while true do
						if ((v248 == (0 + 0)) or ((13598 - 10502) <= (706 + 1092))) then
							v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 1526 - (35 + 1451));
							if (((4990 - (28 + 1425)) == (5530 - (941 + 1052))) and v29) then
								return v29;
							end
							v248 = 1 + 0;
						end
						if (((5351 - (822 + 692)) >= (2241 - 671)) and (v248 == (1 + 0))) then
							v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 337 - (45 + 252));
							if (v29 or ((2919 + 31) == (1312 + 2500))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((11494 - 6771) >= (2751 - (114 + 319))) and v42) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (2 - 0)) or ((1293 + 734) > (4248 - 1396))) then
							v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 83 - 43);
							if (v29 or ((3099 - (556 + 1407)) > (5523 - (741 + 465)))) then
								return v29;
							end
							v249 = 468 - (170 + 295);
						end
						if (((2502 + 2246) == (4362 + 386)) and ((2 - 1) == v249)) then
							v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 34 + 6);
							if (((2396 + 1340) <= (2685 + 2055)) and v29) then
								return v29;
							end
							v249 = 1232 - (957 + 273);
						end
						if ((v249 == (0 + 0)) or ((1358 + 2032) <= (11659 - 8599))) then
							v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 105 - 65);
							if (v29 or ((3051 - 2052) > (13334 - 10641))) then
								return v29;
							end
							v249 = 1781 - (389 + 1391);
						end
						if (((291 + 172) < (63 + 538)) and (v249 == (6 - 3))) then
							v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 991 - (783 + 168));
							if (v29 or ((7326 - 5143) < (676 + 11))) then
								return v29;
							end
							break;
						end
					end
				end
				v142 = 313 - (309 + 2);
			end
		end
	end
	local function v132()
		if (((13969 - 9420) == (5761 - (1090 + 122))) and v111 and ((v31 and v110) or not v110)) then
			local v154 = 0 + 0;
			while true do
				if (((15690 - 11018) == (3198 + 1474)) and (v154 == (1118 - (628 + 490)))) then
					v29 = v126.HandleTopTrinket(v125, v31, 8 + 32, nil);
					if (v29 or ((9081 - 5413) < (1805 - 1410))) then
						return v29;
					end
					v154 = 775 - (431 + 343);
				end
				if ((v154 == (1 - 0)) or ((12051 - 7885) == (360 + 95))) then
					v29 = v126.HandleBottomTrinket(v125, v31, 6 + 34, nil);
					if (v29 or ((6144 - (556 + 1139)) == (2678 - (6 + 9)))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((784 + 3493) < (1532 + 1457))) then
			if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((1039 - (28 + 141)) >= (1608 + 2541))) then
				if (((2730 - 518) < (2255 + 928)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingcd tank";
				end
			end
		end
		if (((5963 - (486 + 831)) > (7785 - 4793)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((5048 - 3614) < (587 + 2519)) and (v17:HealthPercentage() <= v83)) then
				if (((2485 - 1699) < (4286 - (668 + 595))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v86, v85) and v122.SpiritLinkTotem:IsReady()) or ((2198 + 244) < (15 + 59))) then
			if (((12367 - 7832) == (4825 - (23 + 267))) and (v87 == "Player")) then
				if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(1984 - (1129 + 815))) or ((3396 - (371 + 16)) <= (3855 - (1326 + 424)))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((3465 - 1635) < (13407 - 9738)) and (v87 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((1548 - (88 + 30)) >= (4383 - (720 + 51)))) then
					if (((5968 - 3285) >= (4236 - (421 + 1355))) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(65 - 25))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v87 == "Confirmation") or ((887 + 917) >= (4358 - (286 + 797)))) then
				if (v24(v122.SpiritLinkTotem, not v15:IsInRange(146 - 106)) or ((2346 - 929) > (4068 - (397 + 42)))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((1498 + 3297) > (1202 - (24 + 776))) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78) and v122.HealingTideTotem:IsReady()) then
			if (((7414 - 2601) > (4350 - (222 + 563))) and v24(v122.HealingTideTotem, not v15:IsInRange(88 - 48))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((2817 + 1095) == (4102 - (23 + 167))) and v126.AreUnitsBelowHealthPercentage(v55, v54) and v122.AncestralProtectionTotem:IsReady()) then
			if (((4619 - (690 + 1108)) <= (1741 + 3083)) and (v56 == "Player")) then
				if (((1434 + 304) <= (3043 - (40 + 808))) and v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(7 + 33))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((156 - 115) <= (2885 + 133)) and (v56 == "Friendly under Cursor")) then
				if (((1135 + 1010) <= (2251 + 1853)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((3260 - (47 + 524)) < (3145 + 1700)) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(109 - 69))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v56 == "Confirmation") or ((3471 - 1149) > (5979 - 3357))) then
				if (v24(v122.AncestralProtectionTotem, not v15:IsInRange(1766 - (1165 + 561))) or ((135 + 4399) == (6448 - 4366))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52) and v122.AncestralGuidance:IsReady()) or ((600 + 971) > (2346 - (341 + 138)))) then
			if (v24(v122.AncestralGuidance, not v15:IsInRange(11 + 29)) or ((5476 - 2822) >= (3322 - (89 + 237)))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((12797 - 8819) > (4429 - 2325)) and v92 and v126.AreUnitsBelowHealthPercentage(v58, v57) and v122.Ascendance:IsReady()) then
			if (((3876 - (581 + 300)) > (2761 - (855 + 365))) and v24(v122.Ascendance, not v15:IsInRange(95 - 55))) then
				return "ascendance cooldowns";
			end
		end
		if (((1061 + 2188) > (2188 - (1030 + 205))) and v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) then
			if (v24(v122.ManaTideTotem, not v15:IsInRange(38 + 2)) or ((3045 + 228) > (4859 - (156 + 130)))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v35 and ((v109 and v31) or not v109)) or ((7159 - 4008) < (2163 - 879))) then
			local v155 = 0 - 0;
			while true do
				if ((v155 == (1 + 1)) or ((1079 + 771) == (1598 - (10 + 59)))) then
					if (((233 + 588) < (10455 - 8332)) and v122.Fireblood:IsReady()) then
						if (((2065 - (671 + 492)) < (1851 + 474)) and v24(v122.Fireblood, not v15:IsInRange(1255 - (369 + 846)))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
				if (((228 + 630) <= (2528 + 434)) and (v155 == (1946 - (1036 + 909)))) then
					if (v122.Berserking:IsReady() or ((3138 + 808) < (2162 - 874))) then
						if (v24(v122.Berserking, not v15:IsInRange(243 - (11 + 192))) or ((1639 + 1603) == (742 - (135 + 40)))) then
							return "Berserking cooldowns";
						end
					end
					if (v122.BloodFury:IsReady() or ((2052 - 1205) >= (762 + 501))) then
						if (v24(v122.BloodFury, not v15:IsInRange(88 - 48)) or ((3377 - 1124) == (2027 - (50 + 126)))) then
							return "BloodFury cooldowns";
						end
					end
					v155 = 5 - 3;
				end
				if ((v155 == (0 + 0)) or ((3500 - (1233 + 180)) > (3341 - (522 + 447)))) then
					if (v122.AncestralCall:IsReady() or ((5866 - (107 + 1314)) < (1926 + 2223))) then
						if (v24(v122.AncestralCall, not v15:IsInRange(121 - 81)) or ((773 + 1045) == (168 - 83))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((2492 - 1862) < (4037 - (716 + 1194))) and v122.BagofTricks:IsReady()) then
						if (v24(v122.BagofTricks, not v15:IsInRange(1 + 39)) or ((208 + 1730) == (3017 - (74 + 429)))) then
							return "BagofTricks cooldowns";
						end
					end
					v155 = 1 - 0;
				end
			end
		end
	end
	local function v133()
		if (((2109 + 2146) >= (125 - 70)) and v94 and v126.AreUnitsBelowHealthPercentage(68 + 27, 8 - 5) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
			if (((7414 - 4415) > (1589 - (279 + 154))) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if (((3128 - (454 + 324)) > (909 + 246)) and v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (32 - (12 + 5)))) then
			if (((2173 + 1856) <= (12365 - 7512)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((191 + 325) > (4527 - (277 + 816)))) then
			if (((17288 - 13242) >= (4216 - (1058 + 125))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((510 + 2209) <= (2422 - (815 + 160)))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((17737 - 13603) < (9319 - 5393))) then
			if ((v17:HealthPercentage() <= v83) or ((40 + 124) >= (8140 - 5355))) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((2423 - (41 + 1857)) == (4002 - (1222 + 671)))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((85 - 52) == (46 - 13)) and v105 and v122.UnleashLife:IsReady()) then
			if (((4236 - (229 + 953)) <= (5789 - (1111 + 663))) and (v13:HealthPercentage() <= v90)) then
				if (((3450 - (874 + 705)) < (474 + 2908)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((883 + 410) <= (4502 - 2336)) and (v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72)) then
			if (v24(v123.HealingRainCursor, not v15:IsInRange(2 + 38), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3258 - (642 + 37)) < (29 + 94))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v73, v72) and v122.HealingRain:IsReady()) or ((136 + 710) >= (5945 - 3577))) then
			if ((v74 == "Player") or ((4466 - (233 + 221)) <= (7764 - 4406))) then
				if (((1315 + 179) <= (4546 - (718 + 823))) and v24(v123.HealingRainPlayer, not v15:IsInRange(26 + 14), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			elseif ((v74 == "Friendly under Cursor") or ((3916 - (266 + 539)) == (6041 - 3907))) then
				if (((3580 - (636 + 589)) == (5590 - 3235)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(82 - 42), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((466 + 122) <= (157 + 275))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((5812 - (657 + 358)) >= (10313 - 6418)) and (v74 == "Enemy under Cursor")) then
				if (((8149 - 4572) == (4764 - (1151 + 36))) and v16:Exists() and v13:CanAttack(v16)) then
					if (((3664 + 130) > (971 + 2722)) and v24(v123.HealingRainCursor, not v15:IsInRange(119 - 79), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v74 == "Confirmation") or ((3107 - (1552 + 280)) == (4934 - (64 + 770)))) then
				if (v24(v122.HealingRain, not v15:IsInRange(28 + 12), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((3611 - 2020) >= (636 + 2944))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((2226 - (157 + 1086)) <= (3618 - 1810)) and v126.AreUnitsBelowHealthPercentage(v70, v69) and v122.EarthenWallTotem:IsReady()) then
			if ((v71 == "Player") or ((9416 - 7266) <= (1836 - 639))) then
				if (((5143 - 1374) >= (1992 - (599 + 220))) and v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(79 - 39))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif (((3416 - (1813 + 118)) == (1086 + 399)) and (v71 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((4532 - (841 + 376)) <= (3897 - 1115))) then
					if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(10 + 30)) or ((2391 - 1515) >= (3823 - (464 + 395)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v71 == "Confirmation") or ((5728 - 3496) > (1200 + 1297))) then
				if (v24(v122.EarthenWallTotem, not v15:IsInRange(877 - (467 + 370))) or ((4360 - 2250) <= (244 + 88))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((12635 - 8949) > (495 + 2677)) and v126.AreUnitsBelowHealthPercentage(v65, v64) and v122.Downpour:IsReady()) then
			if ((v66 == "Player") or ((10408 - 5934) < (1340 - (150 + 370)))) then
				if (((5561 - (74 + 1208)) >= (7088 - 4206)) and v24(v123.DownpourPlayer, not v15:IsInRange(189 - 149), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif ((v66 == "Friendly under Cursor") or ((1444 + 585) >= (3911 - (14 + 376)))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((3532 - 1495) >= (3004 + 1638))) then
					if (((1511 + 209) < (4252 + 206)) and v24(v123.DownpourCursor, not v15:IsInRange(117 - 77), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v66 == "Confirmation") or ((328 + 108) > (3099 - (23 + 55)))) then
				if (((1689 - 976) <= (566 + 281)) and v24(v122.Downpour, not v15:IsInRange(36 + 4), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if (((3339 - 1185) <= (1268 + 2763)) and v95 and v126.AreUnitsBelowHealthPercentage(v63, v62) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (911 - (652 + 249)))) then
			if (((12350 - 7735) == (6483 - (708 + 1160))) and v24(v122.CloudburstTotem)) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107) and v122.Wellspring:IsReady()) or ((10287 - 6497) == (911 - 411))) then
			if (((116 - (10 + 17)) < (50 + 171)) and v24(v122.Wellspring, not v15:IsInRange(1772 - (1400 + 332)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "wellspring healingaoe";
			end
		end
		if (((3939 - 1885) >= (3329 - (242 + 1666))) and v94 and v126.AreUnitsBelowHealthPercentage(v61, v60) and v122.ChainHeal:IsReady()) then
			if (((297 + 395) < (1121 + 1937)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88) and v122.SpiritwalkersGrace:IsReady()) or ((2774 + 480) == (2595 - (850 + 90)))) then
			if (v24(v122.SpiritwalkersGrace, nil) or ((2269 - 973) == (6300 - (360 + 1030)))) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if (((2981 + 387) == (9506 - 6138)) and v98 and v126.AreUnitsBelowHealthPercentage(v76, v75) and v122.HealingStreamTotem:IsReady()) then
			if (((3635 - 992) < (5476 - (909 + 752))) and v24(v122.HealingStreamTotem, nil)) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v134()
		local v143 = 1223 - (109 + 1114);
		while true do
			if (((3502 - 1589) > (192 + 301)) and (v143 == (242 - (6 + 236)))) then
				if (((2996 + 1759) > (2760 + 668)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((3256 - 1875) <= (4137 - 1768)) and (v17:HealthPercentage() <= v83)) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((5976 - (1076 + 57)) == (672 + 3412))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((5358 - (579 + 110)) > (29 + 334)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((1660 + 217) >= (1666 + 1472))) then
						if (((5149 - (174 + 233)) >= (10128 - 6502)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v143 = 1 - 0;
			end
			if ((v143 == (1 + 0)) or ((5714 - (663 + 511)) == (818 + 98))) then
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97) or ((251 + 905) > (13395 - 9050))) then
					v29 = v126.FocusSpecifiedUnit(v126.NamedUnit(25 + 15, v13:Name(), 58 - 33), 72 - 42);
					if (((1068 + 1169) < (8269 - 4020)) and v29) then
						return v29;
					end
					if (v24(v123.EarthShieldFocus) or ((1913 + 770) < (3 + 20))) then
						return "earth_shield player healingst";
					end
				end
				if (((1419 - (478 + 244)) <= (1343 - (440 + 77))) and v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) then
					if (((503 + 602) <= (4303 - 3127)) and v126.IsSoloMode()) then
						if (((4935 - (655 + 901)) <= (707 + 3105)) and v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) then
							if (v24(v122.LightningShield) or ((604 + 184) >= (1092 + 524))) then
								return "lightning_shield healingst";
							end
						end
					elseif (((7468 - 5614) <= (4824 - (695 + 750))) and v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) then
						if (((15533 - 10984) == (7019 - 2470)) and v24(v122.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				v143 = 7 - 5;
			end
			if ((v143 == (353 - (285 + 66))) or ((7044 - 4022) >= (4334 - (682 + 628)))) then
				if (((777 + 4043) > (2497 - (176 + 123))) and v99 and v122.HealingSurge:IsReady()) then
					if ((v17:HealthPercentage() <= v77) or ((444 + 617) >= (3548 + 1343))) then
						if (((1633 - (239 + 30)) <= (1216 + 3257)) and v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v101 and v122.HealingWave:IsReady()) or ((3456 + 139) <= (4 - 1))) then
					if ((v17:HealthPercentage() <= v80) or ((14575 - 9903) == (4167 - (306 + 9)))) then
						if (((5440 - 3881) == (272 + 1287)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (1 + 1)) or ((5009 - 3257) <= (2163 - (1140 + 235)))) then
				if (v122.LightningBolt:IsReady() or ((2487 + 1420) == (163 + 14))) then
					if (((891 + 2579) > (607 - (33 + 19))) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v144 == (0 + 0)) or ((2913 - 1941) == (285 + 360))) then
				if (((6239 - 3057) >= (1984 + 131)) and v122.Stormkeeper:IsReady()) then
					if (((4582 - (586 + 103)) < (404 + 4025)) and v24(v122.Stormkeeper, not v15:IsInRange(123 - 83))) then
						return "stormkeeper damage";
					end
				end
				if ((math.max(#v13:GetEnemiesInRange(1508 - (1309 + 179)), v13:GetEnemiesInSplashRangeCount(14 - 6)) > (1 + 1)) or ((7699 - 4832) < (1439 + 466))) then
					if (v122.ChainLightning:IsReady() or ((3815 - 2019) >= (8072 - 4021))) then
						if (((2228 - (295 + 314)) <= (9225 - 5469)) and v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v144 = 1963 - (1300 + 662);
			end
			if (((1896 - 1292) == (2359 - (1178 + 577))) and ((1 + 0) == v144)) then
				if (v122.FlameShock:IsReady() or ((13255 - 8771) == (2305 - (851 + 554)))) then
					local v250 = 0 + 0;
					while true do
						if ((v250 == (0 - 0)) or ((9683 - 5224) <= (1415 - (115 + 187)))) then
							if (((2782 + 850) > (3217 + 181)) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(157 - 117), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (((5243 - (160 + 1001)) <= (4302 + 615)) and v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (((3334 + 1498) >= (2836 - 1450)) and v122.LavaBurst:IsReady()) then
					if (((495 - (237 + 121)) == (1034 - (525 + 372))) and v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v144 = 3 - 1;
			end
		end
	end
	local function v136()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (147 - (96 + 46))) or ((2347 - (643 + 134)) >= (1564 + 2768))) then
				v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v90 = EpicSettings.Settings['UnleashLifeHP'];
				v145 = 14 - 8;
			end
			if ((v145 == (0 - 0)) or ((3898 + 166) <= (3569 - 1750))) then
				v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v60 = EpicSettings.Settings['ChainHealGroup'];
				v61 = EpicSettings.Settings['ChainHealHP'];
				v45 = EpicSettings.Settings['DispelDebuffs'];
				v145 = 1 - 0;
			end
			if ((v145 == (726 - (316 + 403))) or ((3315 + 1671) < (4327 - 2753))) then
				v100 = EpicSettings.Settings['UseHealingTideTotem'];
				v101 = EpicSettings.Settings['UseHealingWave'];
				v36 = EpicSettings.Settings['useHealthstone'];
				v47 = EpicSettings.Settings['UsePurgeTarget'];
				v103 = EpicSettings.Settings['UseRiptide'];
				v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v145 = 3 + 5;
			end
			if (((11146 - 6720) > (122 + 50)) and (v145 == (3 + 5))) then
				v105 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((2030 - 1444) > (2173 - 1718)) and (v145 == (12 - 6))) then
				v94 = EpicSettings.Settings['UseChainHeal'];
				v95 = EpicSettings.Settings['UseCloudburstTotem'];
				v97 = EpicSettings.Settings['UseEarthShield'];
				v38 = EpicSettings.Settings['useHealingPotion'];
				v98 = EpicSettings.Settings['UseHealingStreamTotem'];
				v99 = EpicSettings.Settings['UseHealingSurge'];
				v145 = 1 + 6;
			end
			if (((1625 - 799) == (41 + 785)) and (v145 == (11 - 7))) then
				v37 = EpicSettings.Settings['healthstoneHP'];
				v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v50 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['InterruptWithStun'];
				v83 = EpicSettings.Settings['RiptideHP'];
				v84 = EpicSettings.Settings['RiptideTankHP'];
				v145 = 22 - (12 + 5);
			end
			if ((v145 == (3 - 2)) or ((8574 - 4555) > (9440 - 4999))) then
				v46 = EpicSettings.Settings['DispelBuffs'];
				v64 = EpicSettings.Settings['DownpourGroup'];
				v65 = EpicSettings.Settings['DownpourHP'];
				v66 = EpicSettings.Settings['DownpourUsage'];
				v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v70 = EpicSettings.Settings['EarthenWallTotemHP'];
				v145 = 4 - 2;
			end
			if (((410 + 1607) < (6234 - (1656 + 317))) and (v145 == (2 + 0))) then
				v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v39 = EpicSettings.Settings['healingPotionHP'];
				v40 = EpicSettings.Settings['HealingPotionName'];
				v72 = EpicSettings.Settings['HealingRainGroup'];
				v73 = EpicSettings.Settings['HealingRainHP'];
				v74 = EpicSettings.Settings['HealingRainUsage'];
				v145 = 3 + 0;
			end
			if (((12539 - 7823) > (393 - 313)) and (v145 == (357 - (5 + 349)))) then
				v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v76 = EpicSettings.Settings['HealingStreamTotemHP'];
				v77 = EpicSettings.Settings['HealingSurgeHP'];
				v78 = EpicSettings.Settings['HealingTideTotemGroup'];
				v79 = EpicSettings.Settings['HealingTideTotemHP'];
				v80 = EpicSettings.Settings['HealingWaveHP'];
				v145 = 18 - 14;
			end
		end
	end
	local function v137()
		local v146 = 1271 - (266 + 1005);
		while true do
			if ((v146 == (2 + 1)) or ((11966 - 8459) == (4307 - 1035))) then
				v108 = EpicSettings.Settings['WellspringHP'];
				v117 = EpicSettings.Settings['useManaPotion'];
				v118 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v110 = EpicSettings.Settings['trinketsWithCD'];
				v146 = 1700 - (561 + 1135);
			end
			if ((v146 == (1 - 0)) or ((2879 - 2003) >= (4141 - (507 + 559)))) then
				v63 = EpicSettings.Settings['CloudburstTotemHP'];
				v67 = EpicSettings.Settings['EarthElementalHP'];
				v68 = EpicSettings.Settings['EarthElementalTankHP'];
				v81 = EpicSettings.Settings['ManaTideTotemMana'];
				v82 = EpicSettings.Settings['PrimordialWaveHP'];
				v91 = EpicSettings.Settings['UseAncestralGuidance'];
				v146 = 4 - 2;
			end
			if (((13459 - 9107) > (2942 - (212 + 176))) and (v146 == (907 - (250 + 655)))) then
				v92 = EpicSettings.Settings['UseAscendance'];
				v93 = EpicSettings.Settings['UseAstralShift'];
				v96 = EpicSettings.Settings['UseEarthElemental'];
				v102 = EpicSettings.Settings['UseManaTideTotem'];
				v106 = EpicSettings.Settings['UseWellspring'];
				v107 = EpicSettings.Settings['WellspringGroup'];
				v146 = 8 - 5;
			end
			if ((v146 == (8 - 3)) or ((6893 - 2487) < (5999 - (1869 + 87)))) then
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v146 == (0 - 0)) or ((3790 - (484 + 1417)) >= (7250 - 3867))) then
				v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v53 = EpicSettings.Settings['AncestralGuidanceHP'];
				v57 = EpicSettings.Settings['AscendanceGroup'];
				v58 = EpicSettings.Settings['AscendanceHP'];
				v59 = EpicSettings.Settings['AstralShiftHP'];
				v62 = EpicSettings.Settings['CloudburstTotemGroup'];
				v146 = 1 - 0;
			end
			if (((2665 - (48 + 725)) <= (4465 - 1731)) and (v146 == (10 - 6))) then
				v111 = EpicSettings.Settings['useTrinkets'];
				v112 = EpicSettings.Settings['fightRemainsCheck'];
				v51 = EpicSettings.Settings['useWeapon'];
				v113 = EpicSettings.Settings['handleAfflicted'];
				v114 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v146 = 3 + 2;
			end
		end
	end
	local v138 = 0 - 0;
	local function v139()
		local v147 = 0 + 0;
		local v148;
		while true do
			if (((561 + 1362) < (3071 - (152 + 701))) and ((1311 - (430 + 881)) == v147)) then
				v136();
				v137();
				v30 = EpicSettings.Toggles['ooc'];
				v147 = 1 + 0;
			end
			if (((3068 - (557 + 338)) > (113 + 266)) and ((14 - 9) == v147)) then
				if ((v13:AffectingCombat() and v126.TargetIsValid()) or ((9073 - 6482) == (9056 - 5647))) then
					local v251 = 0 - 0;
					while true do
						if (((5315 - (499 + 302)) > (4190 - (39 + 827))) and (v251 == (7 - 4))) then
							if ((v120 > v112) or ((464 - 256) >= (19176 - 14348))) then
								local v258 = 0 - 0;
								while true do
									if ((v258 == (0 + 0)) or ((4633 - 3050) > (571 + 2996))) then
										v148 = v132();
										if (v148 or ((2077 - 764) == (898 - (103 + 1)))) then
											return v148;
										end
										break;
									end
								end
							end
							break;
						end
						if (((3728 - (475 + 79)) > (6273 - 3371)) and ((3 - 2) == v251)) then
							v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 4 + 26, true, v16);
							if (((3626 + 494) <= (5763 - (1395 + 108))) and v29) then
								return v29;
							end
							v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 87 - 57, nil, v16);
							if (v29 or ((2087 - (7 + 1197)) > (2084 + 2694))) then
								return v29;
							end
							v251 = 1 + 1;
						end
						if ((v251 == (321 - (27 + 292))) or ((10607 - 6987) >= (6237 - 1346))) then
							v148 = v130();
							if (((17857 - 13599) > (1847 - 910)) and v148) then
								return v148;
							end
							if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((9272 - 4403) < (1045 - (43 + 96)))) then
								if (v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge)) or ((4996 - 3771) > (9558 - 5330))) then
									return "greater_purge utility";
								end
							end
							if (((2762 + 566) > (632 + 1606)) and v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) then
								if (((7587 - 3748) > (539 + 866)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
									return "purge utility";
								end
							end
							v251 = 5 - 2;
						end
						if (((0 + 0) == v251) or ((95 + 1198) <= (2258 - (1414 + 337)))) then
							if ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady() or ((4836 - (1642 + 298)) < (2098 - 1293))) then
								if (((6662 - 4346) == (6872 - 4556)) and v24(v123.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if ((v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) or ((846 + 1724) == (1193 + 340))) then
								if (v24(v123.ManaPotion, nil) or ((1855 - (357 + 615)) == (1025 + 435))) then
									return "Mana Potion main";
								end
							end
							v29 = v126.Interrupt(v122.WindShear, 73 - 43, true);
							if (v29 or ((3958 + 661) <= (2140 - 1141))) then
								return v29;
							end
							v251 = 1 + 0;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((232 + 3178) > (2588 + 1528))) then
					local v252 = 1301 - (384 + 917);
					while true do
						if ((v252 == (698 - (128 + 569))) or ((2446 - (1407 + 136)) >= (4946 - (687 + 1200)))) then
							if (((v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) or ((5686 - (556 + 1154)) < (10051 - 7194))) then
								if (((5025 - (9 + 86)) > (2728 - (275 + 146))) and v122.PrimordialWaveResto:IsCastable()) then
									if (v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto)) or ((658 + 3388) < (1355 - (29 + 35)))) then
										return "primordial_wave main";
									end
								end
							end
							if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (13 - 10)))) or ((12667 - 8426) == (15649 - 12104))) then
								if (v24(v122.TotemicRecall, nil) or ((2637 + 1411) > (5244 - (53 + 959)))) then
									return "totemic_recall main";
								end
							end
							v252 = 410 - (312 + 96);
						end
						if ((v252 == (3 - 1)) or ((2035 - (147 + 138)) >= (4372 - (813 + 86)))) then
							if (((2862 + 304) == (5865 - 2699)) and v33) then
								local v259 = 492 - (18 + 474);
								while true do
									if (((595 + 1168) < (12154 - 8430)) and (v259 == (1087 - (860 + 226)))) then
										if (((360 - (121 + 182)) <= (336 + 2387)) and v148) then
											return v148;
										end
										v148 = v134();
										v259 = 1242 - (988 + 252);
									end
									if ((v259 == (0 + 0)) or ((649 + 1421) == (2413 - (49 + 1921)))) then
										if ((v15:Exists() and not v13:CanAttack(v15)) or ((3595 - (223 + 667)) == (1445 - (51 + 1)))) then
											local v263 = 0 - 0;
											while true do
												if ((v263 == (1 - 0)) or ((5726 - (146 + 979)) < (18 + 43))) then
													if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((1995 - (311 + 294)) >= (13229 - 8485))) then
														if (v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((849 + 1154) > (5277 - (496 + 947)))) then
															return "chain_heal healing target";
														end
													end
													if ((v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) or ((1514 - (1233 + 125)) > (1588 + 2325))) then
														if (((175 + 20) == (38 + 157)) and v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
															return "healing_wave healing target";
														end
													end
													break;
												end
												if (((4750 - (963 + 682)) >= (1499 + 297)) and (v263 == (1504 - (504 + 1000)))) then
													if (((2949 + 1430) >= (1941 + 190)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
														if (((363 + 3481) >= (3012 - 969)) and (v15:HealthPercentage() <= v83)) then
															if (v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide)) or ((2762 + 470) <= (1589 + 1142))) then
																return "riptide healing target";
															end
														end
													end
													if (((5087 - (156 + 26)) == (2826 + 2079)) and v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) then
														if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((6470 - 2334) >= (4575 - (149 + 15)))) then
															return "unleash_life healing target";
														end
													end
													v263 = 961 - (890 + 70);
												end
											end
										end
										v148 = v133();
										v259 = 118 - (39 + 78);
									end
									if ((v259 == (484 - (14 + 468))) or ((6504 - 3546) == (11227 - 7210))) then
										if (((634 + 594) >= (489 + 324)) and v148) then
											return v148;
										end
										break;
									end
								end
							end
							if (v34 or ((734 + 2721) > (1830 + 2220))) then
								if (((64 + 179) == (464 - 221)) and v126.TargetIsValid()) then
									local v262 = 0 + 0;
									while true do
										if ((v262 == (0 - 0)) or ((7 + 264) > (1623 - (12 + 39)))) then
											v148 = v135();
											if (((2549 + 190) < (10192 - 6899)) and v148) then
												return v148;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((v252 == (0 - 0)) or ((1169 + 2773) < (597 + 537))) then
							if ((v32 and v45) or ((6828 - 4135) == (3313 + 1660))) then
								local v260 = 0 - 0;
								while true do
									if (((3856 - (1596 + 114)) == (5602 - 3456)) and (v260 == (714 - (164 + 549)))) then
										if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((3682 - (1059 + 379)) == (4002 - 778))) then
											if (v122.PurifySpirit:IsCastable() or ((2542 + 2362) <= (323 + 1593))) then
												if (((482 - (145 + 247)) <= (874 + 191)) and v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit))) then
													return "purify_spirit dispel mouseover";
												end
											end
										end
										break;
									end
									if (((2219 + 2583) == (14236 - 9434)) and (v260 == (0 + 0))) then
										if ((v122.Bursting:MaxDebuffStack() > (4 + 0)) or ((3702 - 1422) <= (1231 - (254 + 466)))) then
											local v264 = 560 - (544 + 16);
											while true do
												if ((v264 == (0 - 0)) or ((2304 - (294 + 334)) <= (716 - (236 + 17)))) then
													v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
													if (((1668 + 2201) == (3012 + 857)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if (((4361 - 3203) <= (12371 - 9758)) and v17) then
											if ((v122.PurifySpirit:IsReady() and v126.DispellableFriendlyUnit(13 + 12)) or ((1948 + 416) <= (2793 - (413 + 381)))) then
												if ((v138 == (0 + 0)) or ((10467 - 5545) < (503 - 309))) then
													v138 = GetTime();
												end
												if (v126.Wait(2470 - (582 + 1388), v138) or ((3562 - 1471) < (23 + 8))) then
													local v265 = 364 - (326 + 38);
													while true do
														if ((v265 == (0 - 0)) or ((3469 - 1039) >= (5492 - (47 + 573)))) then
															if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((1682 + 3088) < (7368 - 5633))) then
																return "purify_spirit dispel focus";
															end
															v138 = 0 - 0;
															break;
														end
													end
												end
											end
										end
										v260 = 1665 - (1269 + 395);
									end
								end
							end
							if ((v122.Bursting:AuraActiveCount() > (495 - (76 + 416))) or ((4882 - (319 + 124)) <= (5371 - 3021))) then
								local v261 = 1007 - (564 + 443);
								while true do
									if ((v261 == (0 - 0)) or ((4937 - (337 + 121)) < (13085 - 8619))) then
										if (((8484 - 5937) > (3136 - (1261 + 650))) and (v122.Bursting:MaxDebuffStack() > (3 + 2)) and v122.SpiritLinkTotem:IsReady()) then
											if (((7443 - 2772) > (4491 - (772 + 1045))) and (v87 == "Player")) then
												if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(6 + 34)) or ((3840 - (102 + 42)) < (5171 - (1524 + 320)))) then
													return "spirit_link_totem bursting";
												end
											elseif ((v87 == "Friendly under Cursor") or ((5812 - (1049 + 221)) == (3126 - (18 + 138)))) then
												if (((616 - 364) <= (3079 - (67 + 1035))) and v16:Exists() and not v13:CanAttack(v16)) then
													if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(388 - (136 + 212))) or ((6102 - 4666) == (3025 + 750))) then
														return "spirit_link_totem bursting";
													end
												end
											elseif ((v87 == "Confirmation") or ((1492 + 126) < (2534 - (240 + 1364)))) then
												if (((5805 - (1050 + 32)) > (14828 - 10675)) and v24(v122.SpiritLinkTotem, not v15:IsInRange(24 + 16))) then
													return "spirit_link_totem bursting";
												end
											end
										end
										if ((v94 and v122.ChainHeal:IsReady()) or ((4709 - (331 + 724)) >= (376 + 4278))) then
											if (((1595 - (269 + 375)) <= (2221 - (267 + 458))) and v24(v123.ChainHealFocus, nil)) then
												return "Chain Heal Spam because of Bursting";
											end
										end
										break;
									end
								end
							end
							v252 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v147 == (7 - 3)) or ((2554 - (667 + 151)) == (2068 - (1410 + 87)))) then
				if (v148 or ((2793 - (1504 + 393)) > (12890 - 8121))) then
					return v148;
				end
				if (v13:AffectingCombat() or v30 or ((2711 - 1666) <= (1816 - (461 + 335)))) then
					local v253 = v45 and v122.PurifySpirit:IsReady() and v32;
					if ((v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 4 + 21) < (1762 - (1730 + 31)))) or ((2827 - (728 + 939)) <= (1161 - 833))) then
						v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 30 - 15, 91 - 51, "TANK", true, 1093 - (138 + 930));
						if (((3480 + 328) > (2286 + 638)) and v29) then
							return v29;
						end
						if (((3335 + 556) < (20085 - 15166)) and (v126.UnitGroupRole(v17) == "TANK")) then
							if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((4000 - (459 + 1307)) <= (3372 - (474 + 1396)))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					if (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 43 - 18) >= (1 + 0)) or ((9 + 2503) < (1237 - 805))) then
						local v254 = 0 + 0;
						while true do
							if (((0 - 0) == v254) or ((8059 - 6211) == (1456 - (562 + 29)))) then
								v29 = v126.FocusUnit(v253, nil, 35 + 5, nil, 1444 - (374 + 1045));
								if (v29 or ((3706 + 976) <= (14100 - 9559))) then
									return v29;
								end
								break;
							end
						end
					end
				end
				if ((v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(678 - (448 + 190)) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) or ((977 + 2049) >= (1827 + 2219))) then
					if (((1309 + 699) > (2452 - 1814)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				v147 = 15 - 10;
			end
			if (((3269 - (1307 + 187)) <= (12820 - 9587)) and (v147 == (6 - 3))) then
				if (v126.TargetIsValid() or v13:AffectingCombat() or ((13929 - 9386) == (2680 - (232 + 451)))) then
					v121 = v13:GetEnemiesInRange(39 + 1);
					v119 = v10.BossFightRemains(nil, true);
					v120 = v119;
					if ((v120 == (9816 + 1295)) or ((3666 - (510 + 54)) < (1466 - 738))) then
						v120 = v10.FightRemains(v121, false);
					end
				end
				if (((381 - (13 + 23)) == (672 - 327)) and not v13:AffectingCombat()) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((4062 - 1235) < (686 - 308))) then
						local v255 = 1088 - (830 + 258);
						local v256;
						while true do
							if (((0 - 0) == v255) or ((2175 + 1301) < (2210 + 387))) then
								v256 = v126.DeadFriendlyUnitsCount();
								if (((4520 - (860 + 581)) < (17683 - 12889)) and (v256 > (1 + 0))) then
									if (((5095 - (237 + 4)) > (10491 - 6027)) and v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (v24(v123.AncestralSpiritMouseover, not v15:IsInRange(101 - 61), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((9312 - 4400) == (3076 + 682))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				v148 = v131();
				v147 = 3 + 1;
			end
			if (((475 - 349) <= (1495 + 1987)) and (v147 == (2 + 0))) then
				v34 = EpicSettings.Toggles['dps'];
				v148 = nil;
				if (v13:IsDeadOrGhost() or ((3800 - (85 + 1341)) == (7462 - 3088))) then
					return;
				end
				v147 = 8 - 5;
			end
			if (((1947 - (45 + 327)) == (2972 - 1397)) and (v147 == (503 - (444 + 58)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v147 = 1 + 1;
			end
		end
	end
	local function v140()
		v128();
		v122.Bursting:RegisterAuraTracking();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(46 + 218, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

