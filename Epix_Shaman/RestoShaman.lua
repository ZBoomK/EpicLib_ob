local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (711 - (530 + 181))) or ((1787 - (614 + 267)) >= (2261 - (19 + 13)))) then
			v6 = v0[v4];
			if (((2096 - 808) > (2915 - 1664)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((7936 - 3423) < (6950 - 3598))) then
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
	local v119 = 12923 - (1293 + 519);
	local v120 = 22669 - 11558;
	local v121;
	v10:RegisterForEvent(function()
		v119 = 29010 - 17899;
		v120 = 21247 - 10136;
	end, "PLAYER_REGEN_ENABLED");
	local v122 = v18.Shaman.Restoration;
	local v123 = v25.Shaman.Restoration;
	local v124 = v20.Shaman.Restoration;
	local v125 = {};
	local v126 = v22.Commons.Everyone;
	local v127 = v22.Commons.Shaman;
	local function v128()
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((8904 - 6839) >= (7528 - 4332))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v141)
		return v141:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (3 + 2));
	end
	local function v130()
		local v142 = 0 + 0;
		while true do
			if (((2 - 1) == v142) or ((1012 + 3364) <= (492 + 989))) then
				if ((v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) or ((2120 + 1272) >= (5837 - (709 + 387)))) then
					if (((5183 - (673 + 1185)) >= (6246 - 4092)) and v24(v123.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v38 and (v13:HealthPercentage() <= v39)) or ((4158 - 2863) >= (5319 - 2086))) then
					if (((3131 + 1246) > (1227 + 415)) and (v40 == "Refreshing Healing Potion")) then
						if (((6375 - 1652) > (334 + 1022)) and v124.RefreshingHealingPotion:IsReady()) then
							if (v24(v123.RefreshingHealingPotion) or ((8246 - 4110) <= (6738 - 3305))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((6125 - (446 + 1434)) <= (5914 - (1040 + 243))) and (v40 == "Dreamwalker's Healing Potion")) then
						if (((12762 - 8486) >= (5761 - (559 + 1288))) and v124.DreamwalkersHealingPotion:IsReady()) then
							if (((2129 - (609 + 1322)) <= (4819 - (13 + 441))) and v24(v123.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((17869 - 13087) > (12248 - 7572)) and (v142 == (0 - 0))) then
				if (((182 + 4682) > (7978 - 5781)) and v93 and v122.AstralShift:IsReady()) then
					if ((v13:HealthPercentage() <= v59) or ((1315 + 2385) == (1099 + 1408))) then
						if (((13276 - 8802) >= (150 + 124)) and v24(v122.AstralShift, not v15:IsInRange(73 - 33))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v96 and v122.EarthElemental:IsReady()) or ((1253 + 641) <= (782 + 624))) then
					if (((1130 + 442) >= (1286 + 245)) and ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68))) then
						if (v24(v122.EarthElemental, not v15:IsInRange(40 + 0)) or ((5120 - (153 + 280)) < (13115 - 8573))) then
							return "earth_elemental defensives";
						end
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v131()
		local v143 = 0 + 0;
		while true do
			if (((1723 + 1568) > (1513 + 154)) and (v143 == (0 + 0))) then
				if (v114 or ((1329 - 456) == (1258 + 776))) then
					local v244 = 667 - (89 + 578);
					while true do
						if ((v244 == (0 + 0)) or ((5853 - 3037) < (1060 - (572 + 477)))) then
							v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 5 + 25, true);
							if (((2220 + 1479) < (562 + 4144)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((2732 - (84 + 2)) >= (1443 - 567)) and v113) then
					v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 22 + 8);
					if (((1456 - (497 + 345)) <= (82 + 3102)) and v29) then
						return v29;
					end
					if (((529 + 2597) == (4459 - (605 + 728))) and v115) then
						local v248 = 0 + 0;
						while true do
							if ((v248 == (0 - 0)) or ((101 + 2086) >= (18316 - 13362))) then
								v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 28 + 2);
								if (v29 or ((10741 - 6864) == (2700 + 875))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((1196 - (457 + 32)) > (269 + 363)) and v116) then
						local v249 = 1402 - (832 + 570);
						while true do
							if ((v249 == (0 + 0)) or ((143 + 403) >= (9497 - 6813))) then
								v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 15 + 15);
								if (((2261 - (588 + 208)) <= (11592 - 7291)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v143 = 1801 - (884 + 916);
			end
			if (((3567 - 1863) > (827 + 598)) and (v143 == (655 - (232 + 421)))) then
				if (v43 or ((2576 - (1569 + 320)) == (1039 + 3195))) then
					local v245 = 0 + 0;
					while true do
						if ((v245 == (3 - 2)) or ((3935 - (316 + 289)) < (3740 - 2311))) then
							v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 2 + 38);
							if (((2600 - (666 + 787)) >= (760 - (360 + 65))) and v29) then
								return v29;
							end
							v245 = 2 + 0;
						end
						if (((3689 - (79 + 175)) > (3306 - 1209)) and (v245 == (3 + 0))) then
							v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 122 - 82);
							if (v29 or ((7260 - 3490) >= (4940 - (503 + 396)))) then
								return v29;
							end
							break;
						end
						if ((v245 == (183 - (92 + 89))) or ((7354 - 3563) <= (827 + 784))) then
							v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 24 + 16);
							if (v29 or ((17928 - 13350) <= (275 + 1733))) then
								return v29;
							end
							v245 = 6 - 3;
						end
						if (((982 + 143) <= (992 + 1084)) and (v245 == (0 - 0))) then
							v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 5 + 35);
							if (v29 or ((1132 - 389) >= (5643 - (485 + 759)))) then
								return v29;
							end
							v245 = 2 - 1;
						end
					end
				end
				if (((2344 - (442 + 747)) < (2808 - (832 + 303))) and v44) then
					v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 986 - (88 + 858));
					if (v29 or ((709 + 1615) <= (479 + 99))) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 2 + 38);
					if (((4556 - (766 + 23)) == (18596 - 14829)) and v29) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 54 - 14);
					if (((10773 - 6684) == (13878 - 9789)) and v29) then
						return v29;
					end
					v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 1113 - (1036 + 37));
					if (((3161 + 1297) >= (3259 - 1585)) and v29) then
						return v29;
					end
				end
				break;
			end
			if (((765 + 207) <= (2898 - (641 + 839))) and (v143 == (914 - (910 + 3)))) then
				if (v41 or ((12588 - 7650) < (6446 - (1466 + 218)))) then
					v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 19 + 21);
					if (v29 or ((3652 - (556 + 592)) > (1517 + 2747))) then
						return v29;
					end
					v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 848 - (329 + 479));
					if (((3007 - (174 + 680)) == (7397 - 5244)) and v29) then
						return v29;
					end
				end
				if (v42 or ((1050 - 543) >= (1850 + 741))) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 779 - (396 + 343));
					if (((397 + 4084) == (5958 - (29 + 1448))) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 1429 - (135 + 1254));
					if (v29 or ((8770 - 6442) < (3235 - 2542))) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 27 + 13);
					if (((5855 - (389 + 1138)) == (4902 - (102 + 472))) and v29) then
						return v29;
					end
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 38 + 2);
					if (((881 + 707) >= (1242 + 90)) and v29) then
						return v29;
					end
				end
				v143 = 1547 - (320 + 1225);
			end
		end
	end
	local function v132()
		if ((v111 and ((v31 and v110) or not v110)) or ((7430 - 3256) > (2600 + 1648))) then
			v29 = v126.HandleTopTrinket(v125, v31, 1504 - (157 + 1307), nil);
			if (v29 or ((6445 - (821 + 1038)) <= (204 - 122))) then
				return v29;
			end
			v29 = v126.HandleBottomTrinket(v125, v31, 5 + 35, nil);
			if (((6861 - 2998) == (1438 + 2425)) and v29) then
				return v29;
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((698 - 416) <= (1068 - (834 + 192)))) then
			if (((294 + 4315) >= (197 + 569)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((25 + 1127) == (3854 - 1366))) then
					return "riptide healingcd tank";
				end
			end
		end
		if (((3726 - (300 + 4)) > (895 + 2455)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((2295 - 1418) > (738 - (112 + 250))) and (v17:HealthPercentage() <= v83)) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((1243 + 1875) <= (4637 - 2786))) then
					return "riptide healingcd";
				end
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v86, v85) and v122.SpiritLinkTotem:IsReady()) or ((95 + 70) >= (1806 + 1686))) then
			if (((2954 + 995) < (2408 + 2448)) and (v87 == "Player")) then
				if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(30 + 10)) or ((5690 - (1001 + 413)) < (6725 - 3709))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((5572 - (244 + 638)) > (4818 - (627 + 66))) and (v87 == "Friendly under Cursor")) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((148 - 98) >= (1498 - (512 + 90)))) then
					if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(1946 - (1665 + 241))) or ((2431 - (373 + 344)) >= (1335 + 1623))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v87 == "Confirmation") or ((395 + 1096) < (1698 - 1054))) then
				if (((1191 - 487) < (2086 - (35 + 1064))) and v24(v122.SpiritLinkTotem, not v15:IsInRange(30 + 10))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((7954 - 4236) > (8 + 1898)) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78) and v122.HealingTideTotem:IsReady()) then
			if (v24(v122.HealingTideTotem, not v15:IsInRange(1276 - (298 + 938))) or ((2217 - (233 + 1026)) > (5301 - (636 + 1030)))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((1790 + 1711) <= (4388 + 104)) and v126.AreUnitsBelowHealthPercentage(v55, v54) and v122.AncestralProtectionTotem:IsReady()) then
			if ((v56 == "Player") or ((1023 + 2419) < (173 + 2375))) then
				if (((3096 - (55 + 166)) >= (284 + 1180)) and v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(5 + 35))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif ((v56 == "Friendly under Cursor") or ((18320 - 13523) >= (5190 - (36 + 261)))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((963 - 412) > (3436 - (34 + 1334)))) then
					if (((813 + 1301) > (734 + 210)) and v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(1323 - (1035 + 248)))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif ((v56 == "Confirmation") or ((2283 - (20 + 1)) >= (1613 + 1483))) then
				if (v24(v122.AncestralProtectionTotem, not v15:IsInRange(359 - (134 + 185))) or ((3388 - (549 + 584)) >= (4222 - (314 + 371)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52) and v122.AncestralGuidance:IsReady()) or ((13172 - 9335) < (2274 - (478 + 490)))) then
			if (((1563 + 1387) == (4122 - (786 + 386))) and v24(v122.AncestralGuidance, not v15:IsInRange(129 - 89))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if ((v92 and v126.AreUnitsBelowHealthPercentage(v58, v57) and v122.Ascendance:IsReady()) or ((6102 - (1055 + 324)) < (4638 - (1093 + 247)))) then
			if (((1010 + 126) >= (17 + 137)) and v24(v122.Ascendance, not v15:IsInRange(158 - 118))) then
				return "ascendance cooldowns";
			end
		end
		if ((v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) or ((919 - 648) > (13510 - 8762))) then
			if (((11911 - 7171) >= (1122 + 2030)) and v24(v122.ManaTideTotem, not v15:IsInRange(154 - 114))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v35 and ((v109 and v31) or not v109)) or ((8885 - 6307) >= (2557 + 833))) then
			if (((104 - 63) <= (2349 - (364 + 324))) and v122.AncestralCall:IsReady()) then
				if (((1647 - 1046) < (8542 - 4982)) and v24(v122.AncestralCall, not v15:IsInRange(14 + 26))) then
					return "AncestralCall cooldowns";
				end
			end
			if (((983 - 748) < (1099 - 412)) and v122.BagofTricks:IsReady()) then
				if (((13815 - 9266) > (2421 - (1249 + 19))) and v24(v122.BagofTricks, not v15:IsInRange(37 + 3))) then
					return "BagofTricks cooldowns";
				end
			end
			if (v122.Berserking:IsReady() or ((18193 - 13519) < (5758 - (686 + 400)))) then
				if (((2878 + 790) < (4790 - (73 + 156))) and v24(v122.Berserking, not v15:IsInRange(1 + 39))) then
					return "Berserking cooldowns";
				end
			end
			if (v122.BloodFury:IsReady() or ((1266 - (721 + 90)) == (41 + 3564))) then
				if (v24(v122.BloodFury, not v15:IsInRange(129 - 89)) or ((3133 - (224 + 246)) == (5365 - 2053))) then
					return "BloodFury cooldowns";
				end
			end
			if (((7874 - 3597) <= (812 + 3663)) and v122.Fireblood:IsReady()) then
				if (v24(v122.Fireblood, not v15:IsInRange(1 + 39)) or ((639 + 231) == (2363 - 1174))) then
					return "Fireblood cooldowns";
				end
			end
		end
	end
	local function v133()
		local v144 = 0 - 0;
		while true do
			if (((2066 - (203 + 310)) <= (5126 - (1238 + 755))) and (v144 == (1 + 0))) then
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((3771 - (709 + 825)) >= (6469 - 2958))) then
					if ((v17:HealthPercentage() <= v83) or ((1928 - 604) > (3884 - (196 + 668)))) then
						if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((11813 - 8821) == (3896 - 2015))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((3939 - (171 + 662)) > (1619 - (4 + 89))) and v105 and v122.UnleashLife:IsReady()) then
					if (((10595 - 7572) < (1410 + 2460)) and (v13:HealthPercentage() <= v90)) then
						if (((627 - 484) > (30 + 44)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((1504 - (35 + 1451)) < (3565 - (28 + 1425))) and (v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72)) then
					if (((3090 - (941 + 1052)) <= (1562 + 66)) and v24(v123.HealingRainCursor, not v15:IsInRange(1554 - (822 + 692)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v144 = 2 - 0;
			end
			if (((2181 + 2449) == (4927 - (45 + 252))) and (v144 == (0 + 0))) then
				if (((1219 + 2321) > (6529 - 3846)) and v94 and v126.AreUnitsBelowHealthPercentage(528 - (114 + 319), 3 - 0) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) then
					if (((6142 - 1348) >= (2088 + 1187)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((2210 - 726) == (3109 - 1625)) and v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (1978 - (556 + 1407)))) then
					if (((2638 - (741 + 465)) < (4020 - (170 + 295))) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((562 + 503) > (3287 + 291))) then
					if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((11805 - 7010) < (1167 + 240))) then
						if (((1189 + 664) < (2726 + 2087)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe tank";
						end
					end
				end
				v144 = 1231 - (957 + 273);
			end
			if ((v144 == (1 + 2)) or ((1130 + 1691) < (9263 - 6832))) then
				if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (26 - 16))) or ((8778 - 5904) < (10799 - 8618))) then
					if (v24(v122.CloudburstTotem) or ((4469 - (389 + 1391)) <= (216 + 127))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107) and v122.Wellspring:IsReady()) or ((195 + 1674) == (4573 - 2564))) then
					if (v24(v122.Wellspring, not v15:IsInRange(991 - (783 + 168)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((11900 - 8354) < (2284 + 38))) then
						return "wellspring healingaoe";
					end
				end
				if ((v94 and v126.AreUnitsBelowHealthPercentage(v61, v60) and v122.ChainHeal:IsReady()) or ((2393 - (309 + 2)) == (14657 - 9884))) then
					if (((4456 - (1090 + 122)) > (343 + 712)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v144 = 13 - 9;
			end
			if ((v144 == (2 + 0)) or ((4431 - (628 + 490)) <= (319 + 1459))) then
				if ((v126.AreUnitsBelowHealthPercentage(v73, v72) and v122.HealingRain:IsReady()) or ((3518 - 2097) >= (9615 - 7511))) then
					if (((2586 - (431 + 343)) <= (6561 - 3312)) and (v74 == "Player")) then
						if (((4695 - 3072) <= (1547 + 410)) and v24(v123.HealingRainPlayer, not v15:IsInRange(6 + 34), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((6107 - (556 + 1139)) == (4427 - (6 + 9))) and (v74 == "Friendly under Cursor")) then
						if (((321 + 1429) >= (432 + 410)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((4541 - (28 + 141)) > (717 + 1133)) and v24(v123.HealingRainCursor, not v15:IsInRange(49 - 9), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((165 + 67) < (2138 - (486 + 831))) and (v74 == "Enemy under Cursor")) then
						if (((1347 - 829) < (3175 - 2273)) and v16:Exists() and v13:CanAttack(v16)) then
							if (((566 + 2428) > (2712 - 1854)) and v24(v123.HealingRainCursor, not v15:IsInRange(1303 - (668 + 595)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v74 == "Confirmation") or ((3379 + 376) <= (185 + 730))) then
						if (((10761 - 6815) > (4033 - (23 + 267))) and v24(v122.HealingRain, not v15:IsInRange(1984 - (1129 + 815)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v70, v69) and v122.EarthenWallTotem:IsReady()) or ((1722 - (371 + 16)) >= (5056 - (1326 + 424)))) then
					if (((9174 - 4330) > (8232 - 5979)) and (v71 == "Player")) then
						if (((570 - (88 + 30)) == (1223 - (720 + 51))) and v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(88 - 48))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v71 == "Friendly under Cursor") or ((6333 - (421 + 1355)) < (3442 - 1355))) then
						if (((1903 + 1971) == (4957 - (286 + 797))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(146 - 106)) or ((3209 - 1271) > (5374 - (397 + 42)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v71 == "Confirmation") or ((1329 + 2926) < (4223 - (24 + 776)))) then
						if (((2239 - 785) <= (3276 - (222 + 563))) and v24(v122.EarthenWallTotem, not v15:IsInRange(88 - 48))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if ((v126.AreUnitsBelowHealthPercentage(v65, v64) and v122.Downpour:IsReady()) or ((2993 + 1164) <= (2993 - (23 + 167)))) then
					if (((6651 - (690 + 1108)) >= (1076 + 1906)) and (v66 == "Player")) then
						if (((3410 + 724) > (4205 - (40 + 808))) and v24(v123.DownpourPlayer, not v15:IsInRange(7 + 33), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif ((v66 == "Friendly under Cursor") or ((13066 - 9649) < (2422 + 112))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((1440 + 1282) <= (90 + 74))) then
							if (v24(v123.DownpourCursor, not v15:IsInRange(611 - (47 + 524)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1563 + 845) < (5764 - 3655))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v66 == "Confirmation") or ((49 - 16) == (3318 - 1863))) then
						if (v24(v122.Downpour, not v15:IsInRange(1766 - (1165 + 561)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((14 + 429) >= (12435 - 8420))) then
							return "downpour healingaoe";
						end
					end
				end
				v144 = 2 + 1;
			end
			if (((3861 - (341 + 138)) > (45 + 121)) and (v144 == (7 - 3))) then
				if ((v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88) and v122.SpiritwalkersGrace:IsReady()) or ((606 - (89 + 237)) == (9840 - 6781))) then
					if (((3959 - 2078) > (2174 - (581 + 300))) and v24(v122.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((3577 - (855 + 365)) == (5598 - 3241)) and v98 and v126.AreUnitsBelowHealthPercentage(v76, v75) and v122.HealingStreamTotem:IsReady()) then
					if (((41 + 82) == (1358 - (1030 + 205))) and v24(v122.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
		end
	end
	local function v134()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (1 + 0)) or ((1342 - (156 + 130)) >= (7707 - 4315))) then
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) or ((1821 - 740) < (2201 - 1126))) then
					if (v24(v122.EarthShield) or ((277 + 772) >= (2585 + 1847))) then
						return "earth_shield player healingst";
					end
				end
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) or ((4837 - (10 + 59)) <= (240 + 606))) then
					if (v126.IsSoloMode() or ((16537 - 13179) <= (2583 - (671 + 492)))) then
						if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((2977 + 762) <= (4220 - (369 + 846)))) then
							if (v24(v122.LightningShield) or ((440 + 1219) >= (1822 + 312))) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) or ((5205 - (1036 + 909)) < (1873 + 482))) then
						if (v24(v122.WaterShield) or ((1122 - 453) == (4426 - (11 + 192)))) then
							return "water_shield healingst";
						end
					end
				end
				v145 = 2 + 0;
			end
			if ((v145 == (177 - (135 + 40))) or ((4099 - 2407) < (355 + 233))) then
				if ((v99 and v122.HealingSurge:IsReady()) or ((10567 - 5770) < (5472 - 1821))) then
					if ((v17:HealthPercentage() <= v77) or ((4353 - (50 + 126)) > (13505 - 8655))) then
						if (v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((89 + 311) > (2524 - (1233 + 180)))) then
							return "healing_surge healingst";
						end
					end
				end
				if (((4020 - (522 + 447)) > (2426 - (107 + 1314))) and v101 and v122.HealingWave:IsReady()) then
					if (((1714 + 1979) <= (13352 - 8970)) and (v17:HealthPercentage() <= v80)) then
						if (v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1394 + 1888) > (8141 - 4041))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v145 == (0 - 0)) or ((5490 - (716 + 1194)) < (49 + 2795))) then
				if (((10 + 79) < (4993 - (74 + 429))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if ((v17:HealthPercentage() <= v83) or ((9612 - 4629) < (897 + 911))) then
						if (((8764 - 4935) > (2667 + 1102)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((4577 - 3092) <= (7180 - 4276)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if (((4702 - (279 + 154)) == (5047 - (454 + 324))) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (((305 + 82) <= (2799 - (12 + 5))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v145 = 1 + 0;
			end
		end
	end
	local function v135()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1 + 0)) or ((2992 - (277 + 816)) <= (3918 - 3001))) then
				if (v122.FlameShock:IsReady() or ((5495 - (1058 + 125)) <= (165 + 711))) then
					local v246 = 975 - (815 + 160);
					while true do
						if (((9576 - 7344) <= (6162 - 3566)) and (v246 == (0 + 0))) then
							if (((6123 - 4028) < (5584 - (41 + 1857))) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(1933 - (1222 + 671)), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock)) or ((4122 - 2527) >= (6430 - 1956))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v122.LavaBurst:IsReady() or ((5801 - (229 + 953)) < (4656 - (1111 + 663)))) then
					if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1873 - (874 + 705)) >= (677 + 4154))) then
						return "lava_burst damage";
					end
				end
				v146 = 2 + 0;
			end
			if (((4217 - 2188) <= (87 + 2997)) and (v146 == (679 - (642 + 37)))) then
				if (v122.Stormkeeper:IsReady() or ((465 + 1572) == (388 + 2032))) then
					if (((11192 - 6734) > (4358 - (233 + 221))) and v24(v122.Stormkeeper, not v15:IsInRange(92 - 52))) then
						return "stormkeeper damage";
					end
				end
				if (((384 + 52) >= (1664 - (718 + 823))) and (math.max(#v13:GetEnemiesInRange(13 + 7), v13:GetEnemiesInSplashRangeCount(813 - (266 + 539))) > (5 - 3))) then
					if (((1725 - (636 + 589)) < (4310 - 2494)) and v122.ChainLightning:IsReady()) then
						if (((7371 - 3797) == (2833 + 741)) and v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v146 = 1 + 0;
			end
			if (((1236 - (657 + 358)) < (1032 - 642)) and (v146 == (4 - 2))) then
				if (v122.LightningBolt:IsReady() or ((3400 - (1151 + 36)) <= (1373 + 48))) then
					if (((804 + 2254) < (14513 - 9653)) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v136()
		v54 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v55 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v56 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v60 = EpicSettings.Settings['ChainHealGroup'];
		v61 = EpicSettings.Settings['ChainHealHP'];
		v45 = EpicSettings.Settings['DispelDebuffs'];
		v46 = EpicSettings.Settings['DispelBuffs'];
		v64 = EpicSettings.Settings['DownpourGroup'];
		v65 = EpicSettings.Settings['DownpourHP'];
		v66 = EpicSettings.Settings['DownpourUsage'];
		v69 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v70 = EpicSettings.Settings['EarthenWallTotemHP'];
		v71 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v39 = EpicSettings.Settings['healingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v72 = EpicSettings.Settings['HealingRainGroup'];
		v73 = EpicSettings.Settings['HealingRainHP'];
		v74 = EpicSettings.Settings['HealingRainUsage'];
		v75 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v76 = EpicSettings.Settings['HealingStreamTotemHP'];
		v77 = EpicSettings.Settings['HealingSurgeHP'];
		v78 = EpicSettings.Settings['HealingTideTotemGroup'];
		v79 = EpicSettings.Settings['HealingTideTotemHP'];
		v80 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v50 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['InterruptWithStun'];
		v83 = EpicSettings.Settings['RiptideHP'];
		v84 = EpicSettings.Settings['RiptideTankHP'];
		v85 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v86 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v87 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v88 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v89 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v90 = EpicSettings.Settings['UnleashLifeHP'];
		v94 = EpicSettings.Settings['UseChainHeal'];
		v95 = EpicSettings.Settings['UseCloudburstTotem'];
		v97 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['useHealingPotion'];
		v98 = EpicSettings.Settings['UseHealingStreamTotem'];
		v99 = EpicSettings.Settings['UseHealingSurge'];
		v100 = EpicSettings.Settings['UseHealingTideTotem'];
		v101 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v47 = EpicSettings.Settings['UsePurgeTarget'];
		v103 = EpicSettings.Settings['UseRiptide'];
		v104 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v105 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v137()
		local v196 = 1832 - (1552 + 280);
		while true do
			if ((v196 == (835 - (64 + 770))) or ((880 + 416) >= (10092 - 5646))) then
				v62 = EpicSettings.Settings['CloudburstTotemGroup'];
				v63 = EpicSettings.Settings['CloudburstTotemHP'];
				v67 = EpicSettings.Settings['EarthElementalHP'];
				v68 = EpicSettings.Settings['EarthElementalTankHP'];
				v81 = EpicSettings.Settings['ManaTideTotemMana'];
				v196 = 1 + 1;
			end
			if ((v196 == (1248 - (157 + 1086))) or ((2788 - 1395) > (19660 - 15171))) then
				v112 = EpicSettings.Settings['fightRemainsCheck'];
				v51 = EpicSettings.Settings['useWeapon'];
				v113 = EpicSettings.Settings['handleAfflicted'];
				v114 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v196 = 8 - 2;
			end
			if ((v196 == (0 - 0)) or ((5243 - (599 + 220)) < (53 - 26))) then
				v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v53 = EpicSettings.Settings['AncestralGuidanceHP'];
				v57 = EpicSettings.Settings['AscendanceGroup'];
				v58 = EpicSettings.Settings['AscendanceHP'];
				v59 = EpicSettings.Settings['AstralShiftHP'];
				v196 = 1932 - (1813 + 118);
			end
			if ((v196 == (3 + 1)) or ((3214 - (841 + 376)) > (5345 - 1530))) then
				v118 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v110 = EpicSettings.Settings['trinketsWithCD'];
				v111 = EpicSettings.Settings['useTrinkets'];
				v196 = 2 + 3;
			end
			if (((9457 - 5992) > (2772 - (464 + 395))) and (v196 == (5 - 3))) then
				v82 = EpicSettings.Settings['PrimordialWaveHP'];
				v91 = EpicSettings.Settings['UseAncestralGuidance'];
				v92 = EpicSettings.Settings['UseAscendance'];
				v93 = EpicSettings.Settings['UseAstralShift'];
				v96 = EpicSettings.Settings['UseEarthElemental'];
				v196 = 2 + 1;
			end
			if (((1570 - (467 + 370)) < (3758 - 1939)) and (v196 == (3 + 0))) then
				v102 = EpicSettings.Settings['UseManaTideTotem'];
				v106 = EpicSettings.Settings['UseWellspring'];
				v107 = EpicSettings.Settings['WellspringGroup'];
				v108 = EpicSettings.Settings['WellspringHP'];
				v117 = EpicSettings.Settings['useManaPotion'];
				v196 = 13 - 9;
			end
			if ((v196 == (1 + 5)) or ((10225 - 5830) == (5275 - (150 + 370)))) then
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
		end
	end
	local v138 = 1282 - (74 + 1208);
	local function v139()
		local v197 = 0 - 0;
		local v198;
		while true do
			if ((v197 == (9 - 7)) or ((2699 + 1094) < (2759 - (14 + 376)))) then
				if (v13:IsDeadOrGhost() or ((7083 - 2999) == (172 + 93))) then
					return;
				end
				if (((3829 + 529) == (4157 + 201)) and (v126.TargetIsValid() or v13:AffectingCombat())) then
					v121 = v13:GetEnemiesInRange(117 - 77);
					v119 = v10.BossFightRemains(nil, true);
					v120 = v119;
					if ((v120 == (8359 + 2752)) or ((3216 - (23 + 55)) < (2353 - 1360))) then
						v120 = v10.FightRemains(v121, false);
					end
				end
				if (((2223 + 1107) > (2087 + 236)) and not v13:AffectingCombat()) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((5621 - 1995) == (1255 + 2734))) then
						local v250 = v126.DeadFriendlyUnitsCount();
						if ((v250 > (902 - (652 + 249))) or ((2451 - 1535) == (4539 - (708 + 1160)))) then
							if (((738 - 466) == (495 - 223)) and v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (((4276 - (10 + 17)) <= (1087 + 3752)) and v24(v123.AncestralSpiritMouseover, not v15:IsInRange(1772 - (1400 + 332)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "ancestral_spirit";
						end
					end
				end
				v198 = v131();
				v197 = 5 - 2;
			end
			if (((4685 - (242 + 1666)) < (1370 + 1830)) and (v197 == (0 + 0))) then
				v136();
				v137();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['cds'];
				v197 = 1 + 0;
			end
			if (((1035 - (850 + 90)) < (3427 - 1470)) and (v197 == (1391 - (360 + 1030)))) then
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				v198 = nil;
				v197 = 2 + 0;
			end
			if (((2330 - 1504) < (2362 - 645)) and ((1664 - (909 + 752)) == v197)) then
				if (((2649 - (109 + 1114)) >= (2023 - 918)) and v198) then
					return v198;
				end
				if (((1073 + 1681) <= (3621 - (6 + 236))) and (v13:AffectingCombat() or v30)) then
					local v247 = v45 and v122.PurifySpirit:IsReady() and v32;
					if ((v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 16 + 9) < (1 + 0))) or ((9260 - 5333) == (2467 - 1054))) then
						v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 1148 - (1076 + 57), 7 + 33, "TANK", true, 714 - (579 + 110));
						if (v29 or ((92 + 1062) <= (697 + 91))) then
							return v29;
						end
						if ((v126.UnitGroupRole(v17) == "TANK") or ((872 + 771) > (3786 - (174 + 233)))) then
							if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((7829 - 5026) > (7983 - 3434))) then
								return "earth_shield_tank main apl 1";
							end
						end
					end
					if (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 12 + 13) >= (1175 - (663 + 511))) or ((197 + 23) >= (657 + 2365))) then
						v29 = v126.FocusUnit(v247, nil, 123 - 83, nil, 16 + 9);
						if (((6643 - 3821) == (6831 - 4009)) and v29) then
							return v29;
						end
					end
				end
				if ((v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(20 + 20) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) or ((2064 - 1003) == (1324 + 533))) then
					if (((253 + 2507) > (2086 - (478 + 244))) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
						return "earth_shield_tank main apl 2";
					end
				end
				if ((v13:AffectingCombat() and v126.TargetIsValid()) or ((5419 - (440 + 77)) <= (1635 + 1960))) then
					if ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady() or ((14098 - 10246) == (1849 - (655 + 901)))) then
						if (v24(v123.UseWeapon, nil) or ((290 + 1269) == (3513 + 1075))) then
							return "Using Weapon Macro";
						end
					end
					if ((v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) or ((3028 + 1456) == (3174 - 2386))) then
						if (((6013 - (695 + 750)) >= (13341 - 9434)) and v24(v123.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					v29 = v126.Interrupt(v122.WindShear, 46 - 16, true);
					if (((5011 - 3765) < (3821 - (285 + 66))) and v29) then
						return v29;
					end
					v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 69 - 39, true, v16);
					if (((5378 - (682 + 628)) >= (157 + 815)) and v29) then
						return v29;
					end
					v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 329 - (176 + 123), nil, v16);
					if (((207 + 286) < (2824 + 1069)) and v29) then
						return v29;
					end
					v198 = v130();
					if (v198 or ((1742 - (239 + 30)) >= (906 + 2426))) then
						return v198;
					end
					if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((3894 + 157) <= (2047 - 890))) then
						if (((1884 - 1280) < (3196 - (306 + 9))) and v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge))) then
							return "greater_purge utility";
						end
					end
					if ((v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((3140 - 2240) == (588 + 2789))) then
						if (((2736 + 1723) > (285 + 306)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
							return "purge utility";
						end
					end
					if (((9716 - 6318) >= (3770 - (1140 + 235))) and (v120 > v112)) then
						v198 = v132();
						if (v198 or ((1390 + 793) >= (2590 + 234))) then
							return v198;
						end
					end
				end
				v197 = 2 + 2;
			end
			if (((1988 - (33 + 19)) == (700 + 1236)) and (v197 == (11 - 7))) then
				if (v30 or v13:AffectingCombat() or ((2129 + 2703) < (8457 - 4144))) then
					if (((3834 + 254) > (4563 - (586 + 103))) and v32 and v45) then
						local v251 = 0 + 0;
						while true do
							if (((13336 - 9004) == (5820 - (1309 + 179))) and (v251 == (0 - 0))) then
								if (((1741 + 2258) >= (7788 - 4888)) and (v122.Bursting:MaxDebuffStack() > (4 + 0))) then
									local v254 = 0 - 0;
									while true do
										if ((v254 == (0 - 0)) or ((3134 - (295 + 314)) > (9981 - 5917))) then
											v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
											if (((6333 - (1300 + 662)) == (13725 - 9354)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if (v17 or ((2021 - (1178 + 577)) > (2590 + 2396))) then
									if (((5885 - 3894) >= (2330 - (851 + 554))) and v122.PurifySpirit:IsReady() and v126.DispellableFriendlyUnit(23 + 2)) then
										local v255 = 0 - 0;
										while true do
											if (((988 - 533) < (2355 - (115 + 187))) and (v255 == (0 + 0))) then
												if ((v138 == (0 + 0)) or ((3254 - 2428) == (6012 - (160 + 1001)))) then
													v138 = GetTime();
												end
												if (((161 + 22) == (127 + 56)) and v126.Wait(1023 - 523, v138)) then
													if (((1517 - (237 + 121)) <= (2685 - (525 + 372))) and v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit))) then
														return "purify_spirit dispel focus";
													end
													v138 = 0 - 0;
												end
												break;
											end
										end
									end
								end
								v251 = 3 - 2;
							end
							if ((v251 == (143 - (96 + 46))) or ((4284 - (643 + 134)) > (1559 + 2759))) then
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((7373 - 4298) <= (11008 - 8043))) then
									if (((1310 + 55) <= (3946 - 1935)) and v122.PurifySpirit:IsCastable()) then
										if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((5674 - 2898) > (4294 - (316 + 403)))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
					if ((v122.Bursting:AuraActiveCount() > (2 + 1)) or ((7021 - 4467) == (1737 + 3067))) then
						if (((6489 - 3912) == (1827 + 750)) and (v122.Bursting:MaxDebuffStack() > (2 + 3)) and v122.SpiritLinkTotem:IsReady()) then
							if ((v87 == "Player") or ((20 - 14) >= (9021 - 7132))) then
								if (((1051 - 545) <= (109 + 1783)) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(78 - 38))) then
									return "spirit_link_totem bursting";
								end
							elseif ((v87 == "Friendly under Cursor") or ((99 + 1909) > (6525 - 4307))) then
								if (((396 - (12 + 5)) <= (16107 - 11960)) and v16:Exists() and not v13:CanAttack(v16)) then
									if (v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(85 - 45)) or ((9595 - 5081) <= (2501 - 1492))) then
										return "spirit_link_totem bursting";
									end
								end
							elseif ((v87 == "Confirmation") or ((710 + 2786) == (3165 - (1656 + 317)))) then
								if (v24(v122.SpiritLinkTotem, not v15:IsInRange(36 + 4)) or ((167 + 41) == (7867 - 4908))) then
									return "spirit_link_totem bursting";
								end
							end
						end
						if (((21049 - 16772) >= (1667 - (5 + 349))) and v94 and v122.ChainHeal:IsReady()) then
							if (((12287 - 9700) < (4445 - (266 + 1005))) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal))) then
								return "Chain Heal Spam because of Bursting";
							end
						end
					end
					if (((v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) or ((2715 + 1405) <= (7499 - 5301))) then
						if (v122.PrimordialWaveResto:IsCastable() or ((2101 - 505) == (2554 - (561 + 1135)))) then
							if (((4196 - 976) == (10584 - 7364)) and v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (1069 - (507 + 559))))) or ((3517 - 2115) > (11195 - 7575))) then
						if (((2962 - (212 + 176)) == (3479 - (250 + 655))) and v24(v122.TotemicRecall, nil)) then
							return "totemic_recall main";
						end
					end
					if (((4902 - 3104) < (4816 - 2059)) and v33) then
						local v252 = 0 - 0;
						while true do
							if (((1957 - (1869 + 87)) == v252) or ((1307 - 930) > (4505 - (484 + 1417)))) then
								if (((1217 - 649) < (1526 - 615)) and v198) then
									return v198;
								end
								v198 = v134();
								v252 = 775 - (48 + 725);
							end
							if (((5366 - 2081) < (11343 - 7115)) and (v252 == (0 + 0))) then
								if (((10465 - 6549) > (932 + 2396)) and v15:Exists() and not v13:CanAttack(v15)) then
									if (((729 + 1771) < (4692 - (152 + 701))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
										if (((1818 - (430 + 881)) == (195 + 312)) and (v15:HealthPercentage() <= v83)) then
											if (((1135 - (557 + 338)) <= (936 + 2229)) and v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide))) then
												return "riptide healing target";
											end
										end
									end
									if (((2349 - 1515) >= (2818 - 2013)) and v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) then
										if (v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife)) or ((10127 - 6315) < (4990 - 2674))) then
											return "unleash_life healing target";
										end
									end
									if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((3453 - (499 + 302)) <= (2399 - (39 + 827)))) then
										if (v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((9932 - 6334) < (3260 - 1800))) then
											return "chain_heal healing target";
										end
									end
									if ((v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) or ((16348 - 12232) < (1829 - 637))) then
										if (v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((290 + 3087) <= (2642 - 1739))) then
											return "healing_wave healing target";
										end
									end
								end
								v198 = v133();
								v252 = 1 + 0;
							end
							if (((6291 - 2315) >= (543 - (103 + 1))) and (v252 == (556 - (475 + 79)))) then
								if (((8110 - 4358) == (12006 - 8254)) and v198) then
									return v198;
								end
								break;
							end
						end
					end
					if (((523 + 3523) > (2372 + 323)) and v34) then
						if (v126.TargetIsValid() or ((5048 - (1395 + 108)) == (9302 - 6105))) then
							local v253 = 1204 - (7 + 1197);
							while true do
								if (((1044 + 1350) > (131 + 242)) and (v253 == (319 - (27 + 292)))) then
									v198 = v135();
									if (((12175 - 8020) <= (5396 - 1164)) and v198) then
										return v198;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v140()
		local v199 = 0 - 0;
		while true do
			if ((v199 == (1 - 0)) or ((6820 - 3239) == (3612 - (43 + 96)))) then
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
			if (((20375 - 15380) > (7569 - 4221)) and (v199 == (0 + 0))) then
				v128();
				v122.Bursting:RegisterAuraTracking();
				v199 = 1 + 0;
			end
		end
	end
	v22.SetAPL(521 - 257, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

