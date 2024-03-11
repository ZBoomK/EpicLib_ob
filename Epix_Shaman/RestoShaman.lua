local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1231 - (353 + 878);
	local v6;
	while true do
		if (((612 + 207) >= (29 - 7)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((6304 - 3142) == (6206 - 3044)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1881 - (446 + 1434);
		end
		if ((v5 == (1284 - (1040 + 243))) or ((7070 - 4701) > (6276 - (559 + 1288)))) then
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
	local v119 = 13042 - (609 + 1322);
	local v120 = 11565 - (13 + 441);
	local v121;
	v10:RegisterForEvent(function()
		local v141 = 0 - 0;
		while true do
			if (((10726 - 6631) >= (15852 - 12669)) and (v141 == (0 + 0))) then
				v119 = 40352 - 29241;
				v120 = 3947 + 7164;
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
		if (v122.ImprovedPurifySpirit:IsAvailable() or ((1627 + 2084) < (2991 - 1983))) then
			v126.DispellableDebuffs = v21.MergeTable(v126.DispellableMagicDebuffs, v126.DispellableCurseDebuffs);
		else
			v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129(v142)
		return v142:DebuffRefreshable(v122.FlameShockDebuff) and (v120 > (3 + 2));
	end
	local function v130()
		if ((v93 and v122.AstralShift:IsReady()) or ((1928 - 879) <= (599 + 307))) then
			if (((2511 + 2002) > (1959 + 767)) and (v13:HealthPercentage() <= v59)) then
				if (v24(v122.AstralShift, not v15:IsInRange(34 + 6)) or ((1449 + 32) >= (3091 - (153 + 280)))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v96 and v122.EarthElemental:IsReady()) or ((9298 - 6078) == (1225 + 139))) then
			if ((v13:HealthPercentage() <= v67) or v126.IsTankBelowHealthPercentage(v68, 10 + 15, v122.ChainHeal) or ((552 + 502) > (3079 + 313))) then
				if (v24(v122.EarthElemental, not v15:IsInRange(29 + 11)) or ((1028 - 352) >= (1015 + 627))) then
					return "earth_elemental defensives";
				end
			end
		end
		if (((4803 - (89 + 578)) > (1713 + 684)) and v124.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
			if (v24(v123.Healthstone) or ((9010 - 4676) == (5294 - (572 + 477)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v38 and (v13:HealthPercentage() <= v39)) or ((577 + 3699) <= (1819 + 1212))) then
			local v239 = 0 + 0;
			while true do
				if ((v239 == (86 - (84 + 2))) or ((7880 - 3098) <= (864 + 335))) then
					if ((v40 == "Refreshing Healing Potion") or ((5706 - (497 + 345)) < (49 + 1853))) then
						if (((819 + 4020) >= (5033 - (605 + 728))) and v124.RefreshingHealingPotion:IsReady()) then
							if (v24(v123.RefreshingHealingPotion) or ((767 + 308) > (4264 - 2346))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((19 + 377) <= (14064 - 10260)) and (v40 == "Dreamwalker's Healing Potion")) then
						if (v124.DreamwalkersHealingPotion:IsReady() or ((3759 + 410) == (6059 - 3872))) then
							if (((1062 + 344) == (1895 - (457 + 32))) and v24(v123.RefreshingHealingPotion)) then
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
		if (((650 + 881) < (5673 - (832 + 570))) and v114) then
			local v240 = 0 + 0;
			while true do
				if (((166 + 469) == (2247 - 1612)) and (v240 == (0 + 0))) then
					v29 = v126.HandleIncorporeal(v122.Hex, v123.HexMouseOver, 826 - (588 + 208), true);
					if (((9090 - 5717) <= (5356 - (884 + 916))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (v113 or ((6889 - 3598) < (1902 + 1378))) then
			v29 = v126.HandleAfflicted(v122.PurifySpirit, v123.PurifySpiritMouseover, 683 - (232 + 421));
			if (((6275 - (1569 + 320)) >= (215 + 658)) and v29) then
				return v29;
			end
			if (((175 + 746) <= (3713 - 2611)) and v115) then
				v29 = v126.HandleAfflicted(v122.TremorTotem, v122.TremorTotem, 635 - (316 + 289));
				if (((12318 - 7612) >= (45 + 918)) and v29) then
					return v29;
				end
			end
			if (v116 or ((2413 - (666 + 787)) <= (1301 - (360 + 65)))) then
				v29 = v126.HandleAfflicted(v122.PoisonCleansingTotem, v122.PoisonCleansingTotem, 29 + 1);
				if (v29 or ((2320 - (79 + 175)) == (1469 - 537))) then
					return v29;
				end
			end
			if (((3766 + 1059) < (14844 - 10001)) and v122.PurifySpirit:CooldownRemains()) then
				v29 = v126.HandleAfflicted(v122.HealingSurge, v123.HealingSurgeMouseover, 57 - 27);
				if (v29 or ((4776 - (503 + 396)) >= (4718 - (92 + 89)))) then
					return v29;
				end
			end
		end
		if (v41 or ((8370 - 4055) < (886 + 840))) then
			v29 = v126.HandleChromie(v122.Riptide, v123.RiptideMouseover, 24 + 16);
			if (v29 or ((14407 - 10728) < (86 + 539))) then
				return v29;
			end
			v29 = v126.HandleChromie(v122.HealingSurge, v123.HealingSurgeMouseover, 91 - 51);
			if (v29 or ((4036 + 589) < (302 + 330))) then
				return v29;
			end
		end
		if (v42 or ((252 - 169) > (223 + 1557))) then
			local v241 = 0 - 0;
			while true do
				if (((1790 - (485 + 759)) <= (2491 - 1414)) and (v241 == (1192 - (442 + 747)))) then
					v29 = v126.HandleCharredTreant(v122.HealingWave, v123.HealingWaveMouseover, 1175 - (832 + 303));
					if (v29 or ((1942 - (88 + 858)) > (1311 + 2990))) then
						return v29;
					end
					break;
				end
				if (((3369 + 701) > (29 + 658)) and (v241 == (790 - (766 + 23)))) then
					v29 = v126.HandleCharredTreant(v122.ChainHeal, v123.ChainHealMouseover, 197 - 157);
					if (v29 or ((896 - 240) >= (8773 - 5443))) then
						return v29;
					end
					v241 = 6 - 4;
				end
				if ((v241 == (1075 - (1036 + 37))) or ((1767 + 725) <= (652 - 317))) then
					v29 = v126.HandleCharredTreant(v122.HealingSurge, v123.HealingSurgeMouseover, 32 + 8);
					if (((5802 - (641 + 839)) >= (3475 - (910 + 3))) and v29) then
						return v29;
					end
					v241 = 7 - 4;
				end
				if ((v241 == (1684 - (1466 + 218))) or ((1672 + 1965) >= (4918 - (556 + 592)))) then
					v29 = v126.HandleCharredTreant(v122.Riptide, v123.RiptideMouseover, 15 + 25);
					if (v29 or ((3187 - (329 + 479)) > (5432 - (174 + 680)))) then
						return v29;
					end
					v241 = 3 - 2;
				end
			end
		end
		if (v43 or ((1000 - 517) > (531 + 212))) then
			local v242 = 739 - (396 + 343);
			while true do
				if (((218 + 2236) > (2055 - (29 + 1448))) and (v242 == (1392 - (135 + 1254)))) then
					v29 = v126.HandleCharredBrambles(v122.HealingWave, v123.HealingWaveMouseover, 150 - 110);
					if (((4342 - 3412) < (2971 + 1487)) and v29) then
						return v29;
					end
					break;
				end
				if (((2189 - (389 + 1138)) <= (1546 - (102 + 472))) and ((1 + 0) == v242)) then
					v29 = v126.HandleCharredBrambles(v122.ChainHeal, v123.ChainHealMouseover, 23 + 17);
					if (((4075 + 295) == (5915 - (320 + 1225))) and v29) then
						return v29;
					end
					v242 = 2 - 0;
				end
				if ((v242 == (0 + 0)) or ((6226 - (157 + 1307)) <= (2720 - (821 + 1038)))) then
					v29 = v126.HandleCharredBrambles(v122.Riptide, v123.RiptideMouseover, 99 - 59);
					if (v29 or ((155 + 1257) == (7573 - 3309))) then
						return v29;
					end
					v242 = 1 + 0;
				end
				if ((v242 == (4 - 2)) or ((4194 - (834 + 192)) < (137 + 2016))) then
					v29 = v126.HandleCharredBrambles(v122.HealingSurge, v123.HealingSurgeMouseover, 11 + 29);
					if (v29 or ((107 + 4869) < (2062 - 730))) then
						return v29;
					end
					v242 = 307 - (300 + 4);
				end
			end
		end
		if (((1236 + 3392) == (12114 - 7486)) and v44) then
			v29 = v126.HandleFyrakkNPC(v122.Riptide, v123.RiptideMouseover, 402 - (112 + 250));
			if (v29 or ((22 + 32) == (989 - 594))) then
				return v29;
			end
			v29 = v126.HandleFyrakkNPC(v122.ChainHeal, v123.ChainHealMouseover, 23 + 17);
			if (((43 + 39) == (62 + 20)) and v29) then
				return v29;
			end
			v29 = v126.HandleFyrakkNPC(v122.HealingSurge, v123.HealingSurgeMouseover, 20 + 20);
			if (v29 or ((432 + 149) < (1696 - (1001 + 413)))) then
				return v29;
			end
			v29 = v126.HandleFyrakkNPC(v122.HealingWave, v123.HealingWaveMouseover, 89 - 49);
			if (v29 or ((5491 - (244 + 638)) < (3188 - (627 + 66)))) then
				return v29;
			end
		end
	end
	local function v132()
		if (((3432 - 2280) == (1754 - (512 + 90))) and v111 and ((v31 and v110) or not v110)) then
			v29 = v126.HandleTopTrinket(v125, v31, 1946 - (1665 + 241), nil);
			if (((2613 - (373 + 344)) <= (1544 + 1878)) and v29) then
				return v29;
			end
			v29 = v126.HandleBottomTrinket(v125, v31, 11 + 29, nil);
			if (v29 or ((2611 - 1621) > (2741 - 1121))) then
				return v29;
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((1976 - (35 + 1064)) > (3417 + 1278))) then
			if (((5757 - 3066) >= (8 + 1843)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((4221 - (298 + 938)) >= (6115 - (233 + 1026)))) then
					return "riptide healingcd tank";
				end
			end
		end
		if (((5942 - (636 + 1030)) >= (611 + 584)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((3157 + 75) <= (1394 + 3296)) and (v17:HealthPercentage() <= v83)) then
				if (v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide)) or ((61 + 835) >= (3367 - (55 + 166)))) then
					return "riptide healingcd";
				end
			end
		end
		if (((594 + 2467) >= (298 + 2660)) and v126.AreUnitsBelowHealthPercentage(v86, v85, v122.ChainHeal) and v122.SpiritLinkTotem:IsReady()) then
			if (((12171 - 8984) >= (941 - (36 + 261))) and (v87 == "Player")) then
				if (((1126 - 482) <= (2072 - (34 + 1334))) and v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(16 + 24))) then
					return "spirit_link_totem cooldowns";
				end
			elseif (((745 + 213) > (2230 - (1035 + 248))) and (v87 == "Friendly under Cursor")) then
				if (((4513 - (20 + 1)) >= (1383 + 1271)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((3761 - (134 + 185)) >= (2636 - (549 + 584))) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(725 - (314 + 371)))) then
						return "spirit_link_totem cooldowns";
					end
				end
			elseif ((v87 == "Confirmation") or ((10882 - 7712) <= (2432 - (478 + 490)))) then
				if (v24(v122.SpiritLinkTotem, not v15:IsInRange(22 + 18)) or ((5969 - (786 + 386)) == (14212 - 9824))) then
					return "spirit_link_totem cooldowns";
				end
			end
		end
		if (((1930 - (1055 + 324)) <= (2021 - (1093 + 247))) and v100 and v126.AreUnitsBelowHealthPercentage(v79, v78, v122.ChainHeal) and v122.HealingTideTotem:IsReady()) then
			if (((2913 + 364) > (43 + 364)) and v24(v122.HealingTideTotem, not v15:IsInRange(158 - 118))) then
				return "healing_tide_totem cooldowns";
			end
		end
		if (((15933 - 11238) >= (4026 - 2611)) and v126.AreUnitsBelowHealthPercentage(v55, v54, v122.ChainHeal) and v122.AncestralProtectionTotem:IsReady()) then
			if ((v56 == "Player") or ((8071 - 4859) <= (336 + 608))) then
				if (v24(v123.AncestralProtectionTotemPlayer, not v15:IsInRange(154 - 114)) or ((10671 - 7575) <= (1356 + 442))) then
					return "AncestralProtectionTotem cooldowns";
				end
			elseif (((9045 - 5508) == (4225 - (364 + 324))) and (v56 == "Friendly under Cursor")) then
				if (((10518 - 6681) >= (3767 - 2197)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (v24(v123.AncestralProtectionTotemCursor, not v15:IsInRange(14 + 26)) or ((12343 - 9393) == (6104 - 2292))) then
						return "AncestralProtectionTotem cooldowns";
					end
				end
			elseif (((14344 - 9621) >= (3586 - (1249 + 19))) and (v56 == "Confirmation")) then
				if (v24(v122.AncestralProtectionTotem, not v15:IsInRange(37 + 3)) or ((7889 - 5862) > (3938 - (686 + 400)))) then
					return "AncestralProtectionTotem cooldowns";
				end
			end
		end
		if ((v91 and v126.AreUnitsBelowHealthPercentage(v53, v52, v122.ChainHeal) and v122.AncestralGuidance:IsReady()) or ((892 + 244) > (4546 - (73 + 156)))) then
			if (((23 + 4725) == (5559 - (721 + 90))) and v24(v122.AncestralGuidance, not v15:IsInRange(1 + 39))) then
				return "ancestral_guidance cooldowns";
			end
		end
		if (((12130 - 8394) <= (5210 - (224 + 246))) and v92 and v126.AreUnitsBelowHealthPercentage(v58, v57, v122.ChainHeal) and v122.Ascendance:IsReady()) then
			if (v24(v122.Ascendance, not v15:IsInRange(64 - 24)) or ((6241 - 2851) <= (556 + 2504))) then
				return "ascendance cooldowns";
			end
		end
		if ((v102 and (v13:ManaPercentage() <= v81) and v122.ManaTideTotem:IsReady()) or ((24 + 975) > (1978 + 715))) then
			if (((920 - 457) < (1999 - 1398)) and v24(v122.ManaTideTotem, not v15:IsInRange(553 - (203 + 310)))) then
				return "mana_tide_totem cooldowns";
			end
		end
		if ((v35 and ((v109 and v31) or not v109)) or ((4176 - (1238 + 755)) < (48 + 639))) then
			local v243 = 1534 - (709 + 825);
			while true do
				if (((8382 - 3833) == (6625 - 2076)) and ((864 - (196 + 668)) == v243)) then
					if (((18446 - 13774) == (9677 - 5005)) and v122.AncestralCall:IsReady()) then
						if (v24(v122.AncestralCall, not v15:IsInRange(873 - (171 + 662))) or ((3761 - (4 + 89)) < (1384 - 989))) then
							return "AncestralCall cooldowns";
						end
					end
					if (v122.BagofTricks:IsReady() or ((1517 + 2649) == (1998 - 1543))) then
						if (v24(v122.BagofTricks, not v15:IsInRange(16 + 24)) or ((5935 - (35 + 1451)) == (4116 - (28 + 1425)))) then
							return "BagofTricks cooldowns";
						end
					end
					v243 = 1994 - (941 + 1052);
				end
				if (((2 + 0) == v243) or ((5791 - (822 + 692)) < (4266 - 1277))) then
					if (v122.Fireblood:IsReady() or ((410 + 460) >= (4446 - (45 + 252)))) then
						if (((2189 + 23) < (1096 + 2087)) and v24(v122.Fireblood, not v15:IsInRange(97 - 57))) then
							return "Fireblood cooldowns";
						end
					end
					break;
				end
				if (((5079 - (114 + 319)) > (4295 - 1303)) and (v243 == (1 - 0))) then
					if (((915 + 519) < (4627 - 1521)) and v122.Berserking:IsReady()) then
						if (((1646 - 860) < (4986 - (556 + 1407))) and v24(v122.Berserking, not v15:IsInRange(1246 - (741 + 465)))) then
							return "Berserking cooldowns";
						end
					end
					if (v122.BloodFury:IsReady() or ((2907 - (170 + 295)) < (39 + 35))) then
						if (((4166 + 369) == (11165 - 6630)) and v24(v122.BloodFury, not v15:IsInRange(34 + 6))) then
							return "BloodFury cooldowns";
						end
					end
					v243 = 2 + 0;
				end
			end
		end
	end
	local function v133()
		if ((v94 and v126.AreUnitsBelowHealthPercentage(54 + 41, 1233 - (957 + 273), v122.ChainHeal) and v122.ChainHeal:IsReady() and v13:BuffUp(v122.HighTide)) or ((805 + 2204) <= (843 + 1262))) then
			if (((6973 - 5143) < (9668 - 5999)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe high tide";
			end
		end
		if ((v101 and (v17:HealthPercentage() <= v80) and v122.HealingWave:IsReady() and (v122.PrimordialWaveResto:TimeSinceLastCast() < (45 - 30))) or ((7080 - 5650) >= (5392 - (389 + 1391)))) then
			if (((1684 + 999) >= (257 + 2203)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "healing_wave healingaoe after primordial";
			end
		end
		if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((4106 - 2302) >= (4226 - (783 + 168)))) then
			if (((v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) or ((4755 - 3338) > (3570 + 59))) then
				if (((5106 - (309 + 2)) > (1234 - 832)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe tank";
				end
			end
		end
		if (((6025 - (1090 + 122)) > (1156 + 2409)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
			if (((13138 - 9226) == (2678 + 1234)) and (v17:HealthPercentage() <= v83)) then
				if (((3939 - (628 + 490)) <= (866 + 3958)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((4303 - 2565) <= (10031 - 7836)) and v105 and v122.UnleashLife:IsReady()) then
			if (((815 - (431 + 343)) <= (6095 - 3077)) and (v13:HealthPercentage() <= v90)) then
				if (((6205 - 4060) <= (3243 + 861)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
					return "unleash_life healingaoe";
				end
			end
		end
		if (((344 + 2345) < (6540 - (556 + 1139))) and (v74 == "Cursor") and v122.HealingRain:IsReady() and v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal)) then
			if (v24(v123.HealingRainCursor, not v15:IsInRange(55 - (6 + 9)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((426 + 1896) > (1344 + 1278))) then
				return "healing_rain healingaoe";
			end
		end
		if ((v126.AreUnitsBelowHealthPercentage(v73, v72, v122.ChainHeal) and v122.HealingRain:IsReady()) or ((4703 - (28 + 141)) == (807 + 1275))) then
			if ((v74 == "Player") or ((1938 - 367) > (1323 + 544))) then
				if (v24(v123.HealingRainPlayer, not v15:IsInRange(1357 - (486 + 831)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((6906 - 4252) >= (10547 - 7551))) then
					return "healing_rain healingaoe";
				end
			elseif (((752 + 3226) > (6652 - 4548)) and (v74 == "Friendly under Cursor")) then
				if (((4258 - (668 + 595)) > (1387 + 154)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((656 + 2593) > (2598 - 1645)) and v24(v123.HealingRainCursor, not v15:IsInRange(330 - (23 + 267)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
			elseif ((v74 == "Enemy under Cursor") or ((5217 - (1129 + 815)) > (4960 - (371 + 16)))) then
				if ((v16:Exists() and v13:CanAttack(v16)) or ((4901 - (1326 + 424)) < (2431 - 1147))) then
					if (v24(v123.HealingRainCursor, not v15:IsInRange(146 - 106), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((1968 - (88 + 30)) == (2300 - (720 + 51)))) then
						return "healing_rain healingaoe";
					end
				end
			elseif (((1826 - 1005) < (3899 - (421 + 1355))) and (v74 == "Confirmation")) then
				if (((1487 - 585) < (1143 + 1182)) and v24(v122.HealingRain, not v15:IsInRange(1123 - (286 + 797)), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "healing_rain healingaoe";
				end
			end
		end
		if (((3136 - 2278) <= (4905 - 1943)) and v126.AreUnitsBelowHealthPercentage(v70, v69, v122.ChainHeal) and v122.EarthenWallTotem:IsReady()) then
			if ((v71 == "Player") or ((4385 - (397 + 42)) < (403 + 885))) then
				if (v24(v123.EarthenWallTotemPlayer, not v15:IsInRange(840 - (24 + 776))) or ((4993 - 1751) == (1352 - (222 + 563)))) then
					return "earthen_wall_totem healingaoe";
				end
			elseif ((v71 == "Friendly under Cursor") or ((1865 - 1018) >= (910 + 353))) then
				if ((v16:Exists() and not v13:CanAttack(v16)) or ((2443 - (23 + 167)) == (3649 - (690 + 1108)))) then
					if (v24(v123.EarthenWallTotemCursor, not v15:IsInRange(15 + 25)) or ((1722 + 365) > (3220 - (40 + 808)))) then
						return "earthen_wall_totem healingaoe";
					end
				end
			elseif ((v71 == "Confirmation") or ((732 + 3713) < (15865 - 11716))) then
				if (v24(v122.EarthenWallTotem, not v15:IsInRange(39 + 1)) or ((962 + 856) == (47 + 38))) then
					return "earthen_wall_totem healingaoe";
				end
			end
		end
		if (((1201 - (47 + 524)) < (1381 + 746)) and v126.AreUnitsBelowHealthPercentage(v65, v64, v122.ChainHeal) and v122.Downpour:IsReady()) then
			if ((v66 == "Player") or ((5297 - 3359) == (3758 - 1244))) then
				if (((9704 - 5449) >= (1781 - (1165 + 561))) and v24(v123.DownpourPlayer, not v15:IsInRange(2 + 38), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			elseif (((9288 - 6289) > (442 + 714)) and (v66 == "Friendly under Cursor")) then
				if (((2829 - (341 + 138)) > (312 + 843)) and v16:Exists() and not v13:CanAttack(v16)) then
					if (((8314 - 4285) <= (5179 - (89 + 237))) and v24(v123.DownpourCursor, not v15:IsInRange(128 - 88), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "downpour healingaoe";
					end
				end
			elseif ((v66 == "Confirmation") or ((1086 - 570) > (4315 - (581 + 300)))) then
				if (((5266 - (855 + 365)) >= (7203 - 4170)) and v24(v122.Downpour, not v15:IsInRange(14 + 26), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
					return "downpour healingaoe";
				end
			end
		end
		if ((v95 and v126.AreUnitsBelowHealthPercentage(v63, v62, v122.ChainHeal) and v122.CloudburstTotem:IsReady() and (v122.CloudburstTotem:TimeSinceLastCast() > (1245 - (1030 + 205)))) or ((2553 + 166) <= (1347 + 100))) then
			if (v24(v122.CloudburstTotem) or ((4420 - (156 + 130)) < (8920 - 4994))) then
				return "clouburst_totem healingaoe";
			end
		end
		if ((v106 and v126.AreUnitsBelowHealthPercentage(v108, v107, v122.ChainHeal) and v122.Wellspring:IsReady()) or ((275 - 111) >= (5704 - 2919))) then
			if (v24(v122.Wellspring, not v15:IsInRange(11 + 29), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((307 + 218) == (2178 - (10 + 59)))) then
				return "wellspring healingaoe";
			end
		end
		if (((10 + 23) == (162 - 129)) and v94 and v126.AreUnitsBelowHealthPercentage(v61, v60, v122.ChainHeal) and v122.ChainHeal:IsReady()) then
			if (((4217 - (671 + 492)) <= (3197 + 818)) and v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
				return "chain_heal healingaoe";
			end
		end
		if (((3086 - (369 + 846)) < (896 + 2486)) and v104 and v13:IsMoving() and v126.AreUnitsBelowHealthPercentage(v89, v88, v122.ChainHeal) and v122.SpiritwalkersGrace:IsReady()) then
			if (((1104 + 189) <= (4111 - (1036 + 909))) and v24(v122.SpiritwalkersGrace, nil)) then
				return "spiritwalkers_grace healingaoe";
			end
		end
		if ((v98 and v126.AreUnitsBelowHealthPercentage(v76, v75, v122.ChainHeal) and v122.HealingStreamTotem:IsReady()) or ((2051 + 528) < (206 - 83))) then
			if (v24(v122.HealingStreamTotem, nil) or ((1049 - (11 + 192)) >= (1197 + 1171))) then
				return "healing_stream_totem healingaoe";
			end
		end
	end
	local function v134()
		local v143 = 175 - (135 + 40);
		while true do
			if ((v143 == (0 - 0)) or ((2419 + 1593) <= (7397 - 4039))) then
				if (((2239 - 745) <= (3181 - (50 + 126))) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) then
					if ((v17:HealthPercentage() <= v83) or ((8662 - 5551) == (473 + 1661))) then
						if (((3768 - (1233 + 180)) == (3324 - (522 + 447))) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v17:BuffDown(v122.Riptide)) or ((2009 - (107 + 1314)) <= (201 + 231))) then
					if (((14616 - 9819) >= (1655 + 2240)) and (v17:HealthPercentage() <= v84) and (v126.UnitGroupRole(v17) == "TANK")) then
						if (((7102 - 3525) == (14152 - 10575)) and v24(v123.RiptideFocus, not v17:IsSpellInRange(v122.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v143 = 1911 - (716 + 1194);
			end
			if (((65 + 3729) > (396 + 3297)) and (v143 == (505 - (74 + 429)))) then
				if ((v99 and v122.HealingSurge:IsReady()) or ((2459 - 1184) == (2033 + 2067))) then
					if ((v17:HealthPercentage() <= v77) or ((3641 - 2050) >= (2533 + 1047))) then
						if (((3030 - 2047) <= (4470 - 2662)) and v24(v123.HealingSurgeFocus, not v17:IsSpellInRange(v122.HealingSurge), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_surge healingst";
						end
					end
				end
				if ((v101 and v122.HealingWave:IsReady()) or ((2583 - (279 + 154)) <= (1975 - (454 + 324)))) then
					if (((2966 + 803) >= (1190 - (12 + 5))) and (v17:HealthPercentage() <= v80)) then
						if (((801 + 684) == (3783 - 2298)) and v24(v123.HealingWaveFocus, not v17:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
			if ((v143 == (1 + 0)) or ((4408 - (277 + 816)) <= (11887 - 9105))) then
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffDown(v122.EarthShieldBuff) and not v15:IsAPlayer() and v122.EarthShield:IsCastable() and v97 and v13:CanAttack(v15)) or ((2059 - (1058 + 125)) >= (556 + 2408))) then
					if (v24(v122.EarthShield) or ((3207 - (815 + 160)) > (10713 - 8216))) then
						return "earth_shield player healingst";
					end
				end
				if ((v122.ElementalOrbit:IsAvailable() and v13:BuffUp(v122.EarthShieldBuff)) or ((5008 - 2898) <= (80 + 252))) then
					if (((10774 - 7088) > (5070 - (41 + 1857))) and v126.IsSoloMode()) then
						if ((v122.LightningShield:IsReady() and v13:BuffDown(v122.LightningShield)) or ((6367 - (1222 + 671)) < (2119 - 1299))) then
							if (((6150 - 1871) >= (4064 - (229 + 953))) and v24(v122.LightningShield)) then
								return "lightning_shield healingst";
							end
						end
					elseif ((v122.WaterShield:IsReady() and v13:BuffDown(v122.WaterShield)) or ((3803 - (1111 + 663)) >= (5100 - (874 + 705)))) then
						if (v24(v122.WaterShield) or ((286 + 1751) >= (3168 + 1474))) then
							return "water_shield healingst";
						end
					end
				end
				v143 = 3 - 1;
			end
		end
	end
	local function v135()
		local v144 = 0 + 0;
		while true do
			if (((2399 - (642 + 37)) < (1017 + 3441)) and (v144 == (1 + 0))) then
				if (v122.FlameShock:IsReady() or ((1094 - 658) > (3475 - (233 + 221)))) then
					if (((1648 - 935) <= (746 + 101)) and v126.CastCycle(v122.FlameShock, v13:GetEnemiesInRange(1581 - (718 + 823)), v129, not v15:IsSpellInRange(v122.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (((1356 + 798) <= (4836 - (266 + 539))) and v24(v122.FlameShock, not v15:IsSpellInRange(v122.FlameShock))) then
						return "flame_shock damage";
					end
				end
				if (((13065 - 8450) == (5840 - (636 + 589))) and v122.LavaBurst:IsReady()) then
					if (v24(v122.LavaBurst, not v15:IsSpellInRange(v122.LavaBurst), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((8996 - 5206) == (1031 - 531))) then
						return "lava_burst damage";
					end
				end
				v144 = 2 + 0;
			end
			if (((33 + 56) < (1236 - (657 + 358))) and (v144 == (4 - 2))) then
				if (((4679 - 2625) >= (2608 - (1151 + 36))) and v122.LightningBolt:IsReady()) then
					if (((669 + 23) < (804 + 2254)) and v24(v122.LightningBolt, not v15:IsSpellInRange(v122.LightningBolt), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
			if ((v144 == (0 - 0)) or ((5086 - (1552 + 280)) == (2489 - (64 + 770)))) then
				if (v122.Stormkeeper:IsReady() or ((880 + 416) == (11146 - 6236))) then
					if (((598 + 2770) == (4611 - (157 + 1086))) and v24(v122.Stormkeeper, not v15:IsInRange(80 - 40))) then
						return "stormkeeper damage";
					end
				end
				if (((11575 - 8932) < (5851 - 2036)) and (math.max(#v13:GetEnemiesInRange(27 - 7), v13:GetEnemiesInSplashRangeCount(827 - (599 + 220))) > (3 - 1))) then
					if (((3844 - (1813 + 118)) > (361 + 132)) and v122.ChainLightning:IsReady()) then
						if (((5972 - (841 + 376)) > (4803 - 1375)) and v24(v122.ChainLightning, not v15:IsSpellInRange(v122.ChainLightning), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
							return "chain_lightning damage";
						end
					end
				end
				v144 = 1 + 0;
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
		v52 = EpicSettings.Settings['AncestralGuidanceGroup'];
		v53 = EpicSettings.Settings['AncestralGuidanceHP'];
		v57 = EpicSettings.Settings['AscendanceGroup'];
		v58 = EpicSettings.Settings['AscendanceHP'];
		v59 = EpicSettings.Settings['AstralShiftHP'];
		v62 = EpicSettings.Settings['CloudburstTotemGroup'];
		v63 = EpicSettings.Settings['CloudburstTotemHP'];
		v67 = EpicSettings.Settings['EarthElementalHP'];
		v68 = EpicSettings.Settings['EarthElementalTankHP'];
		v81 = EpicSettings.Settings['ManaTideTotemMana'];
		v82 = EpicSettings.Settings['PrimordialWaveHP'];
		v91 = EpicSettings.Settings['UseAncestralGuidance'];
		v92 = EpicSettings.Settings['UseAscendance'];
		v93 = EpicSettings.Settings['UseAstralShift'];
		v96 = EpicSettings.Settings['UseEarthElemental'];
		v102 = EpicSettings.Settings['UseManaTideTotem'];
		v106 = EpicSettings.Settings['UseWellspring'];
		v107 = EpicSettings.Settings['WellspringGroup'];
		v108 = EpicSettings.Settings['WellspringHP'];
		v117 = EpicSettings.Settings['useManaPotion'];
		v118 = EpicSettings.Settings['manaPotionSlider'];
		v109 = EpicSettings.Settings['racialsWithCD'];
		v35 = EpicSettings.Settings['useRacials'];
		v110 = EpicSettings.Settings['trinketsWithCD'];
		v111 = EpicSettings.Settings['useTrinkets'];
		v112 = EpicSettings.Settings['fightRemainsCheck'];
		v51 = EpicSettings.Settings['useWeapon'];
		v113 = EpicSettings.Settings['handleAfflicted'];
		v114 = EpicSettings.Settings['HandleIncorporeal'];
		v41 = EpicSettings.Settings['HandleChromie'];
		v43 = EpicSettings.Settings['HandleCharredBrambles'];
		v42 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleFyrakkNPC'];
		v115 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v116 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local v138 = 0 - 0;
	local function v139()
		v136();
		v137();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		local v234;
		if (((2240 - (464 + 395)) <= (6079 - 3710)) and v13:IsDeadOrGhost()) then
			return;
		end
		if (v126.TargetIsValid() or v13:AffectingCombat() or ((2326 + 2517) == (4921 - (467 + 370)))) then
			v121 = v13:GetEnemiesInRange(82 - 42);
			v119 = v10.BossFightRemains(nil, true);
			v120 = v119;
			if (((3428 + 1241) > (1244 - 881)) and (v120 == (1734 + 9377))) then
				v120 = v10.FightRemains(v121, false);
			end
		end
		if (not v13:AffectingCombat() or ((4366 - 2489) >= (3658 - (150 + 370)))) then
			if (((6024 - (74 + 1208)) >= (8918 - 5292)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v247 = 0 - 0;
				local v248;
				while true do
					if ((v247 == (0 + 0)) or ((4930 - (14 + 376)) == (1588 - 672))) then
						v248 = v126.DeadFriendlyUnitsCount();
						if ((v248 > (1 + 0)) or ((1016 + 140) > (4144 + 201))) then
							if (((6554 - 4317) < (3197 + 1052)) and v24(v122.AncestralVision, nil, v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (v24(v123.AncestralSpiritMouseover, not v15:IsInRange(118 - (23 + 55)), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((6358 - 3675) < (16 + 7))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		v234 = v131();
		if (((626 + 71) <= (1280 - 454)) and v234) then
			return v234;
		end
		if (((348 + 757) <= (2077 - (652 + 249))) and (v13:AffectingCombat() or v30)) then
			local v244 = 0 - 0;
			local v245;
			while true do
				if (((5247 - (708 + 1160)) <= (10347 - 6535)) and (v244 == (1 - 0))) then
					if (not v17:BuffDown(v122.EarthShield) or (v126.UnitGroupRole(v17) ~= "TANK") or not v97 or (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 52 - (10 + 17)) >= (1 + 0)) or ((2520 - (1400 + 332)) >= (3099 - 1483))) then
						v29 = v126.FocusUnit(v245, nil, 1948 - (242 + 1666), nil, 11 + 14, v122.ChainHeal);
						if (((680 + 1174) <= (2880 + 499)) and v29) then
							return v29;
						end
					end
					break;
				end
				if (((5489 - (850 + 90)) == (7966 - 3417)) and (v244 == (1390 - (360 + 1030)))) then
					v245 = v45 and v122.PurifySpirit:IsReady() and v32;
					if ((v122.EarthShield:IsReady() and v97 and (v126.FriendlyUnitsWithBuffCount(v122.EarthShield, true, false, 23 + 2) < (2 - 1))) or ((4157 - 1135) >= (4685 - (909 + 752)))) then
						local v250 = 1223 - (109 + 1114);
						while true do
							if (((8824 - 4004) > (856 + 1342)) and (v250 == (243 - (6 + 236)))) then
								if ((v126.UnitGroupRole(v17) == "TANK") or ((669 + 392) >= (3937 + 954))) then
									if (((3216 - 1852) <= (7812 - 3339)) and v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield))) then
										return "earth_shield_tank main apl 1";
									end
								end
								break;
							end
							if ((v250 == (1133 - (1076 + 57))) or ((592 + 3003) <= (692 - (579 + 110)))) then
								v29 = v126.FocusUnitRefreshableBuff(v122.EarthShield, 2 + 13, 36 + 4, "TANK", true, 14 + 11, v122.ChainHeal);
								if (v29 or ((5079 - (174 + 233)) == (10759 - 6907))) then
									return v29;
								end
								v250 = 1 - 0;
							end
						end
					end
					v244 = 1 + 0;
				end
			end
		end
		if (((2733 - (663 + 511)) == (1391 + 168)) and v122.EarthShield:IsCastable() and v97 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(9 + 31) and (v126.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v122.EarthShield))) then
			if (v24(v123.EarthShieldFocus, not v17:IsSpellInRange(v122.EarthShield)) or ((5401 - 3649) <= (478 + 310))) then
				return "earth_shield_tank main apl 2";
			end
		end
		if ((v13:AffectingCombat() and v126.TargetIsValid()) or ((9198 - 5291) == (427 - 250))) then
			if (((1656 + 1814) > (1080 - 525)) and ((v31 and v51 and v124.Dreambinder:IsEquippedAndReady()) or v124.Iridal:IsEquippedAndReady())) then
				if (v24(v123.UseWeapon, nil) or ((693 + 279) == (59 + 586))) then
					return "Using Weapon Macro";
				end
			end
			if (((3904 - (478 + 244)) >= (2632 - (440 + 77))) and v117 and v124.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v118)) then
				if (((1771 + 2122) < (16210 - 11781)) and v24(v123.ManaPotion, nil)) then
					return "Mana Potion main";
				end
			end
			v29 = v126.Interrupt(v122.WindShear, 1586 - (655 + 901), true);
			if (v29 or ((532 + 2335) < (1459 + 446))) then
				return v29;
			end
			v29 = v126.InterruptCursor(v122.WindShear, v123.WindShearMouseover, 21 + 9, true, v16);
			if (v29 or ((7235 - 5439) >= (5496 - (695 + 750)))) then
				return v29;
			end
			v29 = v126.InterruptWithStunCursor(v122.CapacitorTotem, v123.CapacitorTotemCursor, 102 - 72, nil, v16);
			if (((2497 - 878) <= (15105 - 11349)) and v29) then
				return v29;
			end
			v234 = v130();
			if (((955 - (285 + 66)) == (1407 - 803)) and v234) then
				return v234;
			end
			if ((v122.GreaterPurge:IsAvailable() and v47 and v122.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) or ((5794 - (682 + 628)) == (146 + 754))) then
				if (v24(v122.GreaterPurge, not v15:IsSpellInRange(v122.GreaterPurge)) or ((4758 - (176 + 123)) <= (466 + 647))) then
					return "greater_purge utility";
				end
			end
			if (((2635 + 997) > (3667 - (239 + 30))) and v122.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v126.UnitHasMagicBuff(v15)) then
				if (((1110 + 2972) <= (4726 + 191)) and v24(v122.Purge, not v15:IsSpellInRange(v122.Purge))) then
					return "purge utility";
				end
			end
			if (((8551 - 3719) >= (4323 - 2937)) and (v120 > v112)) then
				local v249 = 315 - (306 + 9);
				while true do
					if (((477 - 340) == (24 + 113)) and (v249 == (0 + 0))) then
						v234 = v132();
						if (v234 or ((756 + 814) >= (12387 - 8055))) then
							return v234;
						end
						break;
					end
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((5439 - (1140 + 235)) <= (1158 + 661))) then
			local v246 = 0 + 0;
			while true do
				if ((v246 == (1 + 1)) or ((5038 - (33 + 19)) < (569 + 1005))) then
					if (((13265 - 8839) > (76 + 96)) and v122.NaturesSwiftness:IsReady() and v122.Riptide:CooldownRemains() and v122.UnleashLife:CooldownRemains()) then
						if (((1148 - 562) > (427 + 28)) and v24(v122.NaturesSwiftness, nil)) then
							return "natures_swiftness main";
						end
					end
					if (((1515 - (586 + 103)) == (76 + 750)) and v33) then
						if ((v15:Exists() and not v13:CanAttack(v15)) or ((12372 - 8353) > (5929 - (1309 + 179)))) then
							if (((3640 - 1623) < (1855 + 2406)) and v103 and v13:BuffDown(v122.UnleashLife) and v122.Riptide:IsReady() and v15:BuffDown(v122.Riptide)) then
								if (((12665 - 7949) > (61 + 19)) and (v15:HealthPercentage() <= v83)) then
									if (v24(v122.Riptide, not v17:IsSpellInRange(v122.Riptide)) or ((7450 - 3943) == (6519 - 3247))) then
										return "riptide healing target";
									end
								end
							end
							if ((v105 and v122.UnleashLife:IsReady() and (v15:HealthPercentage() <= v90)) or ((1485 - (295 + 314)) >= (7552 - 4477))) then
								if (((6314 - (1300 + 662)) > (8019 - 5465)) and v24(v122.UnleashLife, not v17:IsSpellInRange(v122.UnleashLife))) then
									return "unleash_life healing target";
								end
							end
							if ((v94 and (v15:HealthPercentage() <= v61) and v122.ChainHeal:IsReady() and (v13:IsInParty() or v13:IsInRaid() or v126.TargetIsValidHealableNpc() or v13:BuffUp(v122.HighTide))) or ((6161 - (1178 + 577)) < (2100 + 1943))) then
								if (v24(v122.ChainHeal, not v15:IsSpellInRange(v122.ChainHeal), v13:BuffDown(v122.SpiritwalkersGraceBuff)) or ((5584 - 3695) >= (4788 - (851 + 554)))) then
									return "chain_heal healing target";
								end
							end
							if (((1674 + 218) <= (7582 - 4848)) and v101 and (v15:HealthPercentage() <= v80) and v122.HealingWave:IsReady()) then
								if (((4176 - 2253) < (2520 - (115 + 187))) and v24(v122.HealingWave, not v15:IsSpellInRange(v122.HealingWave), v13:BuffDown(v122.SpiritwalkersGraceBuff))) then
									return "healing_wave healing target";
								end
							end
						end
						v234 = v133();
						if (((1665 + 508) > (359 + 20)) and v234) then
							return v234;
						end
						v234 = v134();
						if (v234 or ((10210 - 7619) == (4570 - (160 + 1001)))) then
							return v234;
						end
					end
					v246 = 3 + 0;
				end
				if (((3115 + 1399) > (6804 - 3480)) and (v246 == (358 - (237 + 121)))) then
					if ((v32 and v45) or ((1105 - (525 + 372)) >= (9153 - 4325))) then
						local v251 = 0 - 0;
						while true do
							if (((142 - (96 + 46)) == v251) or ((2360 - (643 + 134)) > (1288 + 2279))) then
								if ((v122.Bursting:MaxDebuffStack() > (9 - 5)) or ((4874 - 3561) == (762 + 32))) then
									local v254 = 0 - 0;
									while true do
										if (((6487 - 3313) > (3621 - (316 + 403))) and (v254 == (0 + 0))) then
											v29 = v126.FocusSpecifiedUnit(v122.Bursting:MaxDebuffStackUnit());
											if (((11327 - 7207) <= (1540 + 2720)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer()) or ((2223 - 1340) > (3386 + 1392))) then
									if (v126.UnitHasPoisonDebuff(v16) or ((1167 + 2453) >= (16947 - 12056))) then
										if (((20335 - 16077) > (1946 - 1009)) and v122.PoisonCleansingTotem:IsCastable()) then
											if (v24(v122.PoisonCleansingTotem, nil) or ((279 + 4590) < (1783 - 877))) then
												return "poison_cleansing_totem dispel mouseover";
											end
										end
									end
								end
								v251 = 1 + 0;
							end
							if ((v251 == (2 - 1)) or ((1242 - (12 + 5)) > (16421 - 12193))) then
								if (((7100 - 3772) > (4757 - 2519)) and v17 and v17:Exists() and v17:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v17)) then
									if (((9519 - 5680) > (286 + 1119)) and v122.PurifySpirit:IsCastable()) then
										local v255 = 1973 - (1656 + 317);
										while true do
											if ((v255 == (0 + 0)) or ((1037 + 256) <= (1347 - 840))) then
												if ((v138 == (0 - 0)) or ((3250 - (5 + 349)) < (3823 - 3018))) then
													v138 = GetTime();
												end
												if (((3587 - (266 + 1005)) == (1527 + 789)) and v126.Wait(1706 - 1206, v138)) then
													local v256 = 0 - 0;
													while true do
														if ((v256 == (1696 - (561 + 1135))) or ((3349 - 779) == (5039 - 3506))) then
															if (v24(v123.PurifySpiritFocus, not v17:IsSpellInRange(v122.PurifySpirit)) or ((1949 - (507 + 559)) == (3663 - 2203))) then
																return "purify_spirit dispel focus";
															end
															v138 = 0 - 0;
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v126.UnitHasDispellableDebuffByPlayer(v16)) or ((5007 - (212 + 176)) <= (1904 - (250 + 655)))) then
									if (v122.PurifySpirit:IsCastable() or ((9298 - 5888) > (7191 - 3075))) then
										if (v24(v123.PurifySpiritMouseover, not v16:IsSpellInRange(v122.PurifySpirit)) or ((1412 - 509) >= (5015 - (1869 + 87)))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
					if ((v122.Bursting:AuraActiveCount() > (10 - 7)) or ((5877 - (484 + 1417)) < (6123 - 3266))) then
						local v252 = 0 - 0;
						while true do
							if (((5703 - (48 + 725)) > (3768 - 1461)) and ((0 - 0) == v252)) then
								if (((v122.Bursting:MaxDebuffStack() > (3 + 2)) and v122.SpiritLinkTotem:IsReady()) or ((10812 - 6766) < (362 + 929))) then
									if ((v87 == "Player") or ((1236 + 3005) == (4398 - (152 + 701)))) then
										if (v24(v123.SpiritLinkTotemPlayer, not v15:IsInRange(1351 - (430 + 881))) or ((1551 + 2497) > (5127 - (557 + 338)))) then
											return "spirit_link_totem bursting";
										end
									elseif ((v87 == "Friendly under Cursor") or ((518 + 1232) >= (9786 - 6313))) then
										if (((11086 - 7920) == (8411 - 5245)) and v16:Exists() and not v13:CanAttack(v16)) then
											if (((3799 - 2036) < (4525 - (499 + 302))) and v24(v123.SpiritLinkTotemCursor, not v15:IsInRange(906 - (39 + 827)))) then
												return "spirit_link_totem bursting";
											end
										end
									elseif (((157 - 100) <= (6081 - 3358)) and (v87 == "Confirmation")) then
										if (v24(v122.SpiritLinkTotem, not v15:IsInRange(158 - 118)) or ((3178 - 1108) == (38 + 405))) then
											return "spirit_link_totem bursting";
										end
									end
								end
								if ((v94 and v122.ChainHeal:IsReady()) or ((7917 - 5212) == (223 + 1170))) then
									if (v24(v123.ChainHealFocus, not v17:IsSpellInRange(v122.ChainHeal)) or ((7280 - 2679) < (165 - (103 + 1)))) then
										return "Chain Heal Spam because of Bursting";
									end
								end
								break;
							end
						end
					end
					v246 = 555 - (475 + 79);
				end
				if ((v246 == (2 - 1)) or ((4448 - 3058) >= (614 + 4130))) then
					if (((v17:HealthPercentage() < v82) and v17:BuffDown(v122.Riptide)) or ((1763 + 240) > (5337 - (1395 + 108)))) then
						if (v122.PrimordialWaveResto:IsCastable() or ((453 - 297) > (5117 - (7 + 1197)))) then
							if (((86 + 109) == (69 + 126)) and v24(v123.PrimordialWaveFocus, not v17:IsSpellInRange(v122.PrimordialWaveResto))) then
								return "primordial_wave main";
							end
						end
					end
					if (((3424 - (27 + 292)) >= (5262 - 3466)) and v122.TotemicRecall:IsAvailable() and v122.TotemicRecall:IsReady() and (v122.EarthenWallTotem:TimeSinceLastCast() < (v13:GCD() * (3 - 0)))) then
						if (((18364 - 13985) >= (4202 - 2071)) and v24(v122.TotemicRecall, nil)) then
							return "totemic_recall main";
						end
					end
					v246 = 3 - 1;
				end
				if (((3983 - (43 + 96)) >= (8333 - 6290)) and (v246 == (6 - 3))) then
					if (v34 or ((2682 + 550) <= (772 + 1959))) then
						if (((9694 - 4789) == (1880 + 3025)) and v126.TargetIsValid()) then
							local v253 = 0 - 0;
							while true do
								if (((0 + 0) == v253) or ((304 + 3832) >= (6162 - (1414 + 337)))) then
									v234 = v135();
									if (v234 or ((4898 - (1642 + 298)) == (10471 - 6454))) then
										return v234;
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
	end
	local function v140()
		v128();
		v122.Bursting:RegisterAuraTracking();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(759 - 495, v139, v140);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

