local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5879 - (257 + 916)) > (3340 + 1089)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((2203 + 651) < (3786 + 309)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (552 - (83 + 468))) or ((2864 - (1202 + 604)) >= (5611 - 4409))) then
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
	local v116 = 18492 - 7381;
	local v117 = 30763 - 19652;
	local v118;
	v10:RegisterForEvent(function()
		v116 = 11436 - (45 + 280);
		v117 = 10725 + 386;
	end, "PLAYER_REGEN_ENABLED");
	local v119 = v18.Shaman.Restoration;
	local v120 = v25.Shaman.Restoration;
	local v121 = v20.Shaman.Restoration;
	local v122 = {};
	local v123 = v22.Commons.Everyone;
	local v124 = v22.Commons.Shaman;
	local function v125()
		if (((3243 + 468) > (1226 + 2129)) and v119.ImprovedPurifySpirit:IsAvailable()) then
			v123.DispellableDebuffs = v21.MergeTable(v123.DispellableMagicDebuffs, v123.DispellableCurseDebuffs);
		else
			v123.DispellableDebuffs = v123.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v125();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v126(v138)
		return v138:DebuffRefreshable(v119.FlameShockDebuff) and (v117 > (3 + 2));
	end
	local function v127()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (0 - 0)) or ((2817 - (340 + 1571)) >= (880 + 1349))) then
				if (((3060 - (1733 + 39)) > (3437 - 2186)) and v92 and v119.AstralShift:IsReady()) then
					if ((v13:HealthPercentage() <= v58) or ((5547 - (125 + 909)) < (5300 - (1096 + 852)))) then
						if (v24(v119.AstralShift, not v15:IsInRange(18 + 22)) or ((2948 - 883) >= (3100 + 96))) then
							return "astral_shift defensives";
						end
					end
				end
				if ((v95 and v119.EarthElemental:IsReady()) or ((4888 - (409 + 103)) <= (1717 - (46 + 190)))) then
					if ((v13:HealthPercentage() <= v66) or v123.IsTankBelowHealthPercentage(v67) or ((3487 - (51 + 44)) >= (1338 + 3403))) then
						if (((4642 - (1114 + 203)) >= (2880 - (228 + 498))) and v24(v119.EarthElemental, not v15:IsInRange(9 + 31))) then
							return "earth_elemental defensives";
						end
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (664 - (174 + 489))) or ((3373 - 2078) >= (5138 - (830 + 1075)))) then
				if (((4901 - (303 + 221)) > (2911 - (231 + 1038))) and v121.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
					if (((3936 + 787) > (2518 - (171 + 991))) and v24(v120.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v38 and (v13:HealthPercentage() <= v39)) or ((17045 - 12909) <= (9218 - 5785))) then
					if (((10593 - 6348) <= (3707 + 924)) and (v40 == "Refreshing Healing Potion")) then
						if (((14988 - 10712) >= (11290 - 7376)) and v121.RefreshingHealingPotion:IsReady()) then
							if (((318 - 120) <= (13493 - 9128)) and v24(v120.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((6030 - (111 + 1137)) > (4834 - (91 + 67))) and (v40 == "Dreamwalker's Healing Potion")) then
						if (((14476 - 9612) > (549 + 1648)) and v121.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v120.RefreshingHealingPotion) or ((4223 - (423 + 100)) == (18 + 2489))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if (((2332 + 2142) >= (1045 - (326 + 445))) and (v140 == (8 - 6))) then
				if (v43 or ((4219 - 2325) <= (3281 - 1875))) then
					local v242 = 711 - (530 + 181);
					while true do
						if (((2453 - (614 + 267)) >= (1563 - (19 + 13))) and (v242 == (4 - 1))) then
							v29 = v123.HandleCharredBrambles(v119.HealingWave, v120.HealingWaveMouseover, 93 - 53);
							if (v29 or ((13388 - 8701) < (1180 + 3362))) then
								return v29;
							end
							break;
						end
						if (((5787 - 2496) > (3456 - 1789)) and ((1813 - (1293 + 519)) == v242)) then
							v29 = v123.HandleCharredBrambles(v119.ChainHeal, v120.ChainHealMouseover, 81 - 41);
							if (v29 or ((2278 - 1405) == (3889 - 1855))) then
								return v29;
							end
							v242 = 8 - 6;
						end
						if (((4 - 2) == v242) or ((1492 + 1324) < (3 + 8))) then
							v29 = v123.HandleCharredBrambles(v119.HealingSurge, v120.HealingSurgeMouseover, 92 - 52);
							if (((855 + 2844) < (1564 + 3142)) and v29) then
								return v29;
							end
							v242 = 2 + 1;
						end
						if (((3742 - (709 + 387)) >= (2734 - (673 + 1185))) and (v242 == (0 - 0))) then
							v29 = v123.HandleCharredBrambles(v119.Riptide, v120.RiptideMouseover, 128 - 88);
							if (((1009 - 395) <= (2278 + 906)) and v29) then
								return v29;
							end
							v242 = 1 + 0;
						end
					end
				end
				if (((4219 - 1093) == (768 + 2358)) and v44) then
					v29 = v123.HandleFyrakkNPC(v119.Riptide, v120.RiptideMouseover, 79 - 39);
					if (v29 or ((4293 - 2106) >= (6834 - (446 + 1434)))) then
						return v29;
					end
					v29 = v123.HandleFyrakkNPC(v119.ChainHeal, v120.ChainHealMouseover, 1323 - (1040 + 243));
					if (v29 or ((11571 - 7694) == (5422 - (559 + 1288)))) then
						return v29;
					end
					v29 = v123.HandleFyrakkNPC(v119.HealingSurge, v120.HealingSurgeMouseover, 1971 - (609 + 1322));
					if (((1161 - (13 + 441)) > (2361 - 1729)) and v29) then
						return v29;
					end
					v29 = v123.HandleFyrakkNPC(v119.HealingWave, v120.HealingWaveMouseover, 104 - 64);
					if (v29 or ((2719 - 2173) >= (100 + 2584))) then
						return v29;
					end
				end
				break;
			end
			if (((5320 - 3855) <= (1528 + 2773)) and (v140 == (0 + 0))) then
				if (((5056 - 3352) > (780 + 645)) and v113) then
					v29 = v123.HandleIncorporeal(v119.Hex, v120.HexMouseOver, 55 - 25, true);
					if (v29 or ((455 + 232) == (2355 + 1879))) then
						return v29;
					end
				end
				if (v112 or ((2393 + 937) < (1200 + 229))) then
					v29 = v123.HandleAfflicted(v119.PurifySpirit, v120.PurifySpiritMouseover, 30 + 0);
					if (((1580 - (153 + 280)) >= (967 - 632)) and v29) then
						return v29;
					end
					if (((3084 + 351) > (828 + 1269)) and v114) then
						v29 = v123.HandleAfflicted(v119.TremorTotem, v119.TremorTotem, 16 + 14);
						if (v29 or ((3422 + 348) >= (2929 + 1112))) then
							return v29;
						end
					end
					if (v115 or ((5772 - 1981) <= (996 + 615))) then
						v29 = v123.HandleAfflicted(v119.PoisonCleansingTotem, v119.PoisonCleansingTotem, 697 - (89 + 578));
						if (v29 or ((3271 + 1307) <= (4174 - 2166))) then
							return v29;
						end
					end
				end
				v140 = 1050 - (572 + 477);
			end
			if (((152 + 973) <= (1246 + 830)) and (v140 == (1 + 0))) then
				if (v41 or ((829 - (84 + 2)) >= (7249 - 2850))) then
					v29 = v123.HandleChromie(v119.Riptide, v120.RiptideMouseover, 29 + 11);
					if (((1997 - (497 + 345)) < (43 + 1630)) and v29) then
						return v29;
					end
					v29 = v123.HandleChromie(v119.HealingSurge, v120.HealingSurgeMouseover, 7 + 33);
					if (v29 or ((3657 - (605 + 728)) <= (413 + 165))) then
						return v29;
					end
				end
				if (((8374 - 4607) == (173 + 3594)) and v42) then
					local v243 = 0 - 0;
					while true do
						if (((3687 + 402) == (11328 - 7239)) and (v243 == (0 + 0))) then
							v29 = v123.HandleCharredTreant(v119.Riptide, v120.RiptideMouseover, 529 - (457 + 32));
							if (((1892 + 2566) >= (3076 - (832 + 570))) and v29) then
								return v29;
							end
							v243 = 1 + 0;
						end
						if (((254 + 718) <= (5017 - 3599)) and ((1 + 0) == v243)) then
							v29 = v123.HandleCharredTreant(v119.ChainHeal, v120.ChainHealMouseover, 836 - (588 + 208));
							if (v29 or ((13309 - 8371) < (6562 - (884 + 916)))) then
								return v29;
							end
							v243 = 3 - 1;
						end
						if ((v243 == (2 + 0)) or ((3157 - (232 + 421)) > (6153 - (1569 + 320)))) then
							v29 = v123.HandleCharredTreant(v119.HealingSurge, v120.HealingSurgeMouseover, 10 + 30);
							if (((410 + 1743) == (7254 - 5101)) and v29) then
								return v29;
							end
							v243 = 608 - (316 + 289);
						end
						if (((7 - 4) == v243) or ((24 + 483) >= (4044 - (666 + 787)))) then
							v29 = v123.HandleCharredTreant(v119.HealingWave, v120.HealingWaveMouseover, 465 - (360 + 65));
							if (((4188 + 293) == (4735 - (79 + 175))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v140 = 2 - 0;
			end
		end
	end
	local function v129()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (2 - 1)) or ((4483 - 2155) < (1592 - (503 + 396)))) then
				if (((4509 - (92 + 89)) == (8395 - 4067)) and v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) then
					if (((815 + 773) >= (789 + 543)) and (v17:HealthPercentage() <= v83) and (v123.UnitGroupRole(v17) == "TANK")) then
						if (v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide)) or ((16345 - 12171) > (581 + 3667))) then
							return "riptide healingcd";
						end
					end
				end
				if ((v123.AreUnitsBelowHealthPercentage(v85, v84) and v119.SpiritLinkTotem:IsReady()) or ((10456 - 5870) <= (72 + 10))) then
					if (((1846 + 2017) == (11765 - 7902)) and (v86 == "Player")) then
						if (v24(v120.SpiritLinkTotemPlayer, not v15:IsInRange(5 + 35)) or ((429 - 147) <= (1286 - (485 + 759)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((10664 - 6055) >= (1955 - (442 + 747))) and (v86 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((2287 - (832 + 303)) == (3434 - (88 + 858)))) then
							if (((1043 + 2379) > (2773 + 577)) and v24(v120.SpiritLinkTotemCursor, not v15:IsInRange(2 + 38))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((1666 - (766 + 23)) > (1856 - 1480)) and (v86 == "Confirmation")) then
						if (v24(v119.SpiritLinkTotem, not v15:IsInRange(54 - 14)) or ((8214 - 5096) <= (6282 - 4431))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v141 = 1075 - (1036 + 37);
			end
			if (((0 + 0) == v141) or ((321 - 156) >= (2747 + 745))) then
				if (((5429 - (641 + 839)) < (5769 - (910 + 3))) and v110 and ((v31 and v109) or not v109)) then
					v29 = v123.HandleTopTrinket(v122, v31, 101 - 61, nil);
					if (v29 or ((5960 - (1466 + 218)) < (1387 + 1629))) then
						return v29;
					end
					v29 = v123.HandleBottomTrinket(v122, v31, 1188 - (556 + 592), nil);
					if (((1668 + 3022) > (4933 - (329 + 479))) and v29) then
						return v29;
					end
				end
				if ((v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) or ((904 - (174 + 680)) >= (3078 - 2182))) then
					if ((v17:HealthPercentage() <= v82) or ((3552 - 1838) >= (2112 + 846))) then
						if (v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide)) or ((2230 - (396 + 343)) < (57 + 587))) then
							return "riptide healingcd";
						end
					end
				end
				v141 = 1478 - (29 + 1448);
			end
			if (((2093 - (135 + 1254)) < (3717 - 2730)) and (v141 == (9 - 7))) then
				if (((2478 + 1240) > (3433 - (389 + 1138))) and v99 and v123.AreUnitsBelowHealthPercentage(v78, v77) and v119.HealingTideTotem:IsReady()) then
					if (v24(v119.HealingTideTotem, not v15:IsInRange(614 - (102 + 472))) or ((905 + 53) > (2016 + 1619))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((3265 + 236) <= (6037 - (320 + 1225))) and v123.AreUnitsBelowHealthPercentage(v54, v53) and v119.AncestralProtectionTotem:IsReady()) then
					if ((v55 == "Player") or ((6126 - 2684) < (1560 + 988))) then
						if (((4339 - (157 + 1307)) >= (3323 - (821 + 1038))) and v24(v120.AncestralProtectionTotemPlayer, not v15:IsInRange(99 - 59))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v55 == "Friendly under Cursor") or ((525 + 4272) >= (8690 - 3797))) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((206 + 345) > (5125 - 3057))) then
							if (((3140 - (834 + 192)) > (61 + 883)) and v24(v120.AncestralProtectionTotemCursor, not v15:IsInRange(11 + 29))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v55 == "Confirmation") or ((49 + 2213) >= (4795 - 1699))) then
						if (v24(v119.AncestralProtectionTotem, not v15:IsInRange(344 - (300 + 4))) or ((603 + 1652) >= (9258 - 5721))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v141 = 365 - (112 + 250);
			end
			if ((v141 == (2 + 2)) or ((9612 - 5775) < (749 + 557))) then
				if (((1526 + 1424) == (2207 + 743)) and v101 and (v13:ManaPercentage() <= v80) and v119.ManaTideTotem:IsReady()) then
					if (v24(v119.ManaTideTotem, not v15:IsInRange(20 + 20)) or ((3509 + 1214) < (4712 - (1001 + 413)))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((2533 - 1397) >= (1036 - (244 + 638))) and v35 and ((v108 and v31) or not v108)) then
					if (v119.AncestralCall:IsReady() or ((964 - (627 + 66)) > (14147 - 9399))) then
						if (((5342 - (512 + 90)) >= (5058 - (1665 + 241))) and v24(v119.AncestralCall, not v15:IsInRange(757 - (373 + 344)))) then
							return "AncestralCall cooldowns";
						end
					end
					if (v119.BagofTricks:IsReady() or ((1163 + 1415) >= (897 + 2493))) then
						if (((108 - 67) <= (2810 - 1149)) and v24(v119.BagofTricks, not v15:IsInRange(1139 - (35 + 1064)))) then
							return "BagofTricks cooldowns";
						end
					end
					if (((438 + 163) < (7616 - 4056)) and v119.Berserking:IsReady()) then
						if (((1 + 234) < (1923 - (298 + 938))) and v24(v119.Berserking, not v15:IsInRange(1299 - (233 + 1026)))) then
							return "Berserking cooldowns";
						end
					end
					if (((6215 - (636 + 1030)) > (590 + 563)) and v119.BloodFury:IsReady()) then
						if (v24(v119.BloodFury, not v15:IsInRange(40 + 0)) or ((1389 + 3285) < (316 + 4356))) then
							return "BloodFury cooldowns";
						end
					end
					if (((3889 - (55 + 166)) < (884 + 3677)) and v119.Fireblood:IsReady()) then
						if (v24(v119.Fireblood, not v15:IsInRange(5 + 35)) or ((1737 - 1282) == (3902 - (36 + 261)))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if ((v141 == (4 - 1)) or ((4031 - (34 + 1334)) == (1274 + 2038))) then
				if (((3324 + 953) <= (5758 - (1035 + 248))) and v90 and v123.AreUnitsBelowHealthPercentage(v52, v51) and v119.AncestralGuidance:IsReady()) then
					if (v24(v119.AncestralGuidance, not v15:IsInRange(61 - (20 + 1))) or ((454 + 416) == (1508 - (134 + 185)))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((2686 - (549 + 584)) <= (3818 - (314 + 371))) and v91 and v123.AreUnitsBelowHealthPercentage(v57, v56) and v119.Ascendance:IsReady()) then
					if (v24(v119.Ascendance, not v15:IsInRange(137 - 97)) or ((3205 - (478 + 490)) >= (1860 + 1651))) then
						return "ascendance cooldowns";
					end
				end
				v141 = 1176 - (786 + 386);
			end
		end
	end
	local function v130()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (1380 - (1055 + 324))) or ((2664 - (1093 + 247)) > (2684 + 336))) then
				if ((v104 and v119.UnleashLife:IsReady()) or ((315 + 2677) == (7467 - 5586))) then
					if (((10540 - 7434) > (4342 - 2816)) and (v17:HealthPercentage() <= v89)) then
						if (((7596 - 4573) < (1377 + 2493)) and v24(v119.UnleashLife, not v17:IsSpellInRange(v119.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((550 - 407) > (255 - 181)) and (v73 == "Cursor") and v119.HealingRain:IsReady()) then
					if (((14 + 4) < (5401 - 3289)) and v24(v120.HealingRainCursor, not v15:IsInRange(728 - (364 + 324)), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if (((3007 - 1910) <= (3906 - 2278)) and v123.AreUnitsBelowHealthPercentage(v72, v71) and v119.HealingRain:IsReady()) then
					if (((1535 + 3095) == (19373 - 14743)) and (v73 == "Player")) then
						if (((5669 - 2129) > (8148 - 5465)) and v24(v120.HealingRainPlayer, not v15:IsInRange(1308 - (1249 + 19)), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((4328 + 466) >= (12747 - 9472)) and (v73 == "Friendly under Cursor")) then
						if (((2570 - (686 + 400)) == (1165 + 319)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((1661 - (73 + 156)) < (17 + 3538)) and v24(v120.HealingRainCursor, not v15:IsInRange(851 - (721 + 90)), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v73 == "Enemy under Cursor") or ((12 + 1053) > (11617 - 8039))) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((5265 - (224 + 246)) < (2279 - 872))) then
							if (((3411 - 1558) < (874 + 3939)) and v24(v120.HealingRainCursor, not v15:IsInRange(1 + 39), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v73 == "Confirmation") or ((2072 + 749) < (4832 - 2401))) then
						if (v24(v119.HealingRain, not v15:IsInRange(133 - 93), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((3387 - (203 + 310)) < (4174 - (1238 + 755)))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v123.AreUnitsBelowHealthPercentage(v69, v68) and v119.EarthenWallTotem:IsReady()) or ((188 + 2501) <= (1877 - (709 + 825)))) then
					if ((v70 == "Player") or ((3443 - 1574) == (2925 - 916))) then
						if (v24(v120.EarthenWallTotemPlayer, not v15:IsInRange(904 - (196 + 668))) or ((14000 - 10454) < (4809 - 2487))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v70 == "Friendly under Cursor") or ((2915 - (171 + 662)) == (4866 - (4 + 89)))) then
						if (((11370 - 8126) > (385 + 670)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v120.EarthenWallTotemCursor, not v15:IsInRange(175 - 135)) or ((1300 + 2013) <= (3264 - (35 + 1451)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((2874 - (28 + 1425)) >= (4097 - (941 + 1052)))) then
						if (((1738 + 74) <= (4763 - (822 + 692))) and v24(v119.EarthenWallTotem, not v15:IsInRange(57 - 17))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v142 = 1 + 1;
			end
			if (((1920 - (45 + 252)) <= (1937 + 20)) and (v142 == (1 + 1))) then
				if (((10737 - 6325) == (4845 - (114 + 319))) and v123.AreUnitsBelowHealthPercentage(v64, v63) and v119.Downpour:IsReady()) then
					if (((2512 - 762) >= (1078 - 236)) and (v65 == "Player")) then
						if (((2788 + 1584) > (2756 - 906)) and v24(v120.DownpourPlayer, not v15:IsInRange(83 - 43), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif (((2195 - (556 + 1407)) < (2027 - (741 + 465))) and (v65 == "Friendly under Cursor")) then
						if (((983 - (170 + 295)) < (476 + 426)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((2751 + 243) > (2112 - 1254)) and v24(v120.DownpourCursor, not v15:IsInRange(34 + 6), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v65 == "Confirmation") or ((2409 + 1346) <= (519 + 396))) then
						if (((5176 - (957 + 273)) > (1002 + 2741)) and v24(v119.Downpour, not v15:IsInRange(17 + 23), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v94 and v123.AreUnitsBelowHealthPercentage(v62, v61) and v119.CloudburstTotem:IsReady()) or ((5086 - 3751) >= (8711 - 5405))) then
					if (((14795 - 9951) > (11156 - 8903)) and v24(v119.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((2232 - (389 + 1391)) == (284 + 168)) and v105 and v123.AreUnitsBelowHealthPercentage(v107, v106) and v119.Wellspring:IsReady()) then
					if (v24(v119.Wellspring, not v15:IsInRange(5 + 35), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((10374 - 5817) < (3038 - (783 + 168)))) then
						return "wellspring healingaoe";
					end
				end
				if (((13001 - 9127) == (3811 + 63)) and v93 and v123.AreUnitsBelowHealthPercentage(v60, v59) and v119.ChainHeal:IsReady()) then
					if (v24(v120.ChainHealFocus, not v17:IsSpellInRange(v119.ChainHeal), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((2249 - (309 + 2)) > (15154 - 10219))) then
						return "chain_heal healingaoe";
					end
				end
				v142 = 1215 - (1090 + 122);
			end
			if ((v142 == (1 + 2)) or ((14290 - 10035) < (2343 + 1080))) then
				if (((2572 - (628 + 490)) <= (447 + 2044)) and v103 and v13:IsMoving() and v123.AreUnitsBelowHealthPercentage(v88, v87) and v119.SpiritwalkersGrace:IsReady()) then
					if (v24(v119.SpiritwalkersGrace, nil) or ((10291 - 6134) <= (12809 - 10006))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((5627 - (431 + 343)) >= (6021 - 3039)) and v97 and v123.AreUnitsBelowHealthPercentage(v75, v74) and v119.HealingStreamTotem:IsReady()) then
					if (((11959 - 7825) > (2653 + 704)) and v24(v119.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v142 == (0 + 0)) or ((5112 - (556 + 1139)) < (2549 - (6 + 9)))) then
				if ((v93 and v123.AreUnitsBelowHealthPercentage(18 + 77, 2 + 1) and v119.ChainHeal:IsReady() and v13:BuffUp(v119.HighTide)) or ((2891 - (28 + 141)) <= (64 + 100))) then
					if (v24(v120.ChainHealFocus, not v17:IsSpellInRange(v119.ChainHeal), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((2971 - 563) < (1494 + 615))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v100 and (v17:HealthPercentage() <= v79) and v119.HealingWave:IsReady() and (v119.PrimordialWaveResto:TimeSinceLastCast() < (1332 - (486 + 831)))) or ((85 - 52) == (5122 - 3667))) then
					if (v24(v120.HealingWaveFocus, not v17:IsSpellInRange(v119.HealingWave), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((84 + 359) >= (12695 - 8680))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if (((4645 - (668 + 595)) > (150 + 16)) and v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) then
					if ((v17:HealthPercentage() <= v82) or ((57 + 223) == (8342 - 5283))) then
						if (((2171 - (23 + 267)) > (3237 - (1129 + 815))) and v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if (((2744 - (371 + 16)) == (4107 - (1326 + 424))) and v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) then
					if (((232 - 109) == (449 - 326)) and (v17:HealthPercentage() <= v83) and (v123.UnitGroupRole(v17) == "TANK")) then
						if (v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide)) or ((1174 - (88 + 30)) >= (4163 - (720 + 51)))) then
							return "riptide healingaoe";
						end
					end
				end
				v142 = 2 - 1;
			end
		end
	end
	local function v131()
		local v143 = 1776 - (421 + 1355);
		while true do
			if ((v143 == (1 - 0)) or ((532 + 549) < (2158 - (286 + 797)))) then
				if ((v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) or ((3834 - 2785) >= (7340 - 2908))) then
					if ((v17:HealthPercentage() <= v82) or (v17:HealthPercentage() <= v82) or ((5207 - (397 + 42)) <= (265 + 581))) then
						if (v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide)) or ((4158 - (24 + 776)) <= (2187 - 767))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v119.ElementalOrbit:IsAvailable() and v13:BuffDown(v119.EarthShieldBuff)) or ((4524 - (222 + 563)) <= (6621 - 3616))) then
					if (v24(v119.EarthShield) or ((1195 + 464) >= (2324 - (23 + 167)))) then
						return "earth_shield healingst";
					end
				end
				v143 = 1800 - (690 + 1108);
			end
			if ((v143 == (0 + 0)) or ((2689 + 571) < (3203 - (40 + 808)))) then
				if ((v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) or ((111 + 558) == (16148 - 11925))) then
					if ((v17:HealthPercentage() <= v82) or ((1618 + 74) < (312 + 276))) then
						if (v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide)) or ((2631 + 2166) < (4222 - (47 + 524)))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v13:BuffDown(v119.UnleashLife) and v119.Riptide:IsReady() and v17:BuffDown(v119.Riptide)) or ((2711 + 1466) > (13257 - 8407))) then
					if (((v17:HealthPercentage() <= v83) and (v123.UnitGroupRole(v17) == "TANK")) or ((598 - 198) > (2533 - 1422))) then
						if (((4777 - (1165 + 561)) > (30 + 975)) and v24(v120.RiptideFocus, not v17:IsSpellInRange(v119.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v143 = 3 - 2;
			end
			if (((1410 + 2283) <= (4861 - (341 + 138))) and (v143 == (1 + 1))) then
				if ((v119.ElementalOrbit:IsAvailable() and v13:BuffUp(v119.EarthShieldBuff)) or ((6772 - 3490) > (4426 - (89 + 237)))) then
					if (v123.IsSoloMode() or ((11516 - 7936) < (5987 - 3143))) then
						if (((970 - (581 + 300)) < (5710 - (855 + 365))) and v119.LightningShield:IsReady() and v13:BuffDown(v119.LightningShield)) then
							if (v24(v119.LightningShield) or ((11835 - 6852) < (591 + 1217))) then
								return "lightning_shield healingst";
							end
						end
					elseif (((5064 - (1030 + 205)) > (3539 + 230)) and v119.WaterShield:IsReady() and v13:BuffDown(v119.WaterShield)) then
						if (((1382 + 103) <= (3190 - (156 + 130))) and v24(v119.WaterShield)) then
							return "water_shield healingst";
						end
					end
				end
				if (((9699 - 5430) == (7194 - 2925)) and v98 and v119.HealingSurge:IsReady()) then
					if (((791 - 404) <= (734 + 2048)) and (v17:HealthPercentage() <= v76)) then
						if (v24(v120.HealingSurgeFocus, not v17:IsSpellInRange(v119.HealingSurge), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((1108 + 791) <= (986 - (10 + 59)))) then
							return "healing_surge healingst";
						end
					end
				end
				v143 = 1 + 2;
			end
			if ((v143 == (14 - 11)) or ((5475 - (671 + 492)) <= (698 + 178))) then
				if (((3447 - (369 + 846)) <= (688 + 1908)) and v100 and v119.HealingWave:IsReady()) then
					if (((1788 + 307) < (5631 - (1036 + 909))) and (v17:HealthPercentage() <= v79)) then
						if (v24(v120.HealingWaveFocus, not v17:IsSpellInRange(v119.HealingWave), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((1269 + 326) >= (7511 - 3037))) then
							return "healing_wave healingst";
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		if (v119.Stormkeeper:IsReady() or ((4822 - (11 + 192)) < (1457 + 1425))) then
			if (v24(v119.Stormkeeper, not v15:IsInRange(215 - (135 + 40))) or ((712 - 418) >= (2912 + 1919))) then
				return "stormkeeper damage";
			end
		end
		if (((4469 - 2440) <= (4622 - 1538)) and (math.max(#v13:GetEnemiesInRange(196 - (50 + 126)), v13:GetEnemiesInSplashRangeCount(22 - 14)) > (1 + 1))) then
			if (v119.ChainLightning:IsReady() or ((3450 - (1233 + 180)) == (3389 - (522 + 447)))) then
				if (((5879 - (107 + 1314)) > (1812 + 2092)) and v24(v119.ChainLightning, not v15:IsSpellInRange(v119.ChainLightning), v13:BuffDown(v119.SpiritwalkersGraceBuff))) then
					return "chain_lightning damage";
				end
			end
		end
		if (((1328 - 892) >= (53 + 70)) and v119.FlameShock:IsReady()) then
			if (((992 - 492) < (7185 - 5369)) and v123.CastCycle(v119.FlameShock, v13:GetEnemiesInRange(1950 - (716 + 1194)), v126, not v15:IsSpellInRange(v119.FlameShock), nil, nil, nil, nil)) then
				return "flame_shock_cycle damage";
			end
			if (((62 + 3512) == (383 + 3191)) and v24(v119.FlameShock, not v15:IsSpellInRange(v119.FlameShock))) then
				return "flame_shock damage";
			end
		end
		if (((724 - (74 + 429)) < (752 - 362)) and v119.LavaBurst:IsReady()) then
			if (v24(v119.LavaBurst, not v15:IsSpellInRange(v119.LavaBurst), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((1097 + 1116) <= (3252 - 1831))) then
				return "lava_burst damage";
			end
		end
		if (((2164 + 894) < (14983 - 10123)) and v119.LightningBolt:IsReady()) then
			if (v24(v119.LightningBolt, not v15:IsSpellInRange(v119.LightningBolt), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((3204 - 1908) >= (4879 - (279 + 154)))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v133()
		v53 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v54 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v55 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v59 = EpicSettings.Settings['ChainHealGroup'];
		v60 = EpicSettings.Settings['ChainHealHP'];
		v45 = EpicSettings.Settings['DispelDebuffs'];
		v46 = EpicSettings.Settings['DispelBuffs'];
		v63 = EpicSettings.Settings['DownpourGroup'];
		v64 = EpicSettings.Settings['DownpourHP'];
		v65 = EpicSettings.Settings['DownpourUsage'];
		v68 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v69 = EpicSettings.Settings['EarthenWallTotemHP'];
		v70 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v39 = EpicSettings.Settings['healingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v71 = EpicSettings.Settings['HealingRainGroup'];
		v72 = EpicSettings.Settings['HealingRainHP'];
		v73 = EpicSettings.Settings['HealingRainUsage'];
		v74 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v75 = EpicSettings.Settings['HealingStreamTotemHP'];
		v76 = EpicSettings.Settings['HealingSurgeHP'];
		v77 = EpicSettings.Settings['HealingTideTotemGroup'];
		v78 = EpicSettings.Settings['HealingTideTotemHP'];
		v79 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v49 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v50 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['InterruptWithStun'];
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
		v38 = EpicSettings.Settings['useHealingPotion'];
		v97 = EpicSettings.Settings['UseHealingStreamTotem'];
		v98 = EpicSettings.Settings['UseHealingSurge'];
		v99 = EpicSettings.Settings['UseHealingTideTotem'];
		v100 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v47 = EpicSettings.Settings['UsePurgeTarget'];
		v102 = EpicSettings.Settings['UseRiptide'];
		v103 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v104 = EpicSettings.Settings['UseUnleashLife'];
	end
	local function v134()
		local v193 = 778 - (454 + 324);
		while true do
			if ((v193 == (3 + 0)) or ((1410 - (12 + 5)) > (2421 + 2068))) then
				v107 = EpicSettings.Settings['WellspringHP'];
				v108 = EpicSettings.Settings['racialsWithCD'];
				v35 = EpicSettings.Settings['useRacials'];
				v109 = EpicSettings.Settings['trinketsWithCD'];
				v110 = EpicSettings.Settings['useTrinkets'];
				v111 = EpicSettings.Settings['fightRemainsCheck'];
				v193 = 10 - 6;
			end
			if ((v193 == (1 + 0)) or ((5517 - (277 + 816)) < (115 - 88))) then
				v62 = EpicSettings.Settings['CloudburstTotemHP'];
				v66 = EpicSettings.Settings['EarthElementalHP'];
				v67 = EpicSettings.Settings['EarthElementalTankHP'];
				v80 = EpicSettings.Settings['ManaTideTotemMana'];
				v81 = EpicSettings.Settings['PrimordialWaveHP'];
				v90 = EpicSettings.Settings['UseAncestralGuidance'];
				v193 = 1185 - (1058 + 125);
			end
			if ((v193 == (1 + 1)) or ((2972 - (815 + 160)) > (16368 - 12553))) then
				v91 = EpicSettings.Settings['UseAscendance'];
				v92 = EpicSettings.Settings['UseAstralShift'];
				v95 = EpicSettings.Settings['UseEarthElemental'];
				v101 = EpicSettings.Settings['UseManaTideTotem'];
				v105 = EpicSettings.Settings['UseWellspring'];
				v106 = EpicSettings.Settings['WellspringGroup'];
				v193 = 7 - 4;
			end
			if (((827 + 2638) > (5591 - 3678)) and (v193 == (1903 - (41 + 1857)))) then
				v114 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v115 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((2626 - (1222 + 671)) < (4701 - 2882)) and (v193 == (0 - 0))) then
				v51 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v52 = EpicSettings.Settings['AncestralGuidanceHP'];
				v56 = EpicSettings.Settings['AscendanceGroup'];
				v57 = EpicSettings.Settings['AscendanceHP'];
				v58 = EpicSettings.Settings['AstralShiftHP'];
				v61 = EpicSettings.Settings['CloudburstTotemGroup'];
				v193 = 1183 - (229 + 953);
			end
			if ((v193 == (1778 - (1111 + 663))) or ((5974 - (874 + 705)) == (666 + 4089))) then
				v112 = EpicSettings.Settings['handleAfflicted'];
				v113 = EpicSettings.Settings['HandleIncorporeal'];
				v41 = EpicSettings.Settings['HandleChromie'];
				v43 = EpicSettings.Settings['HandleCharredBrambles'];
				v42 = EpicSettings.Settings['HandleCharredTreant'];
				v44 = EpicSettings.Settings['HandleFyrakkNPC'];
				v193 = 4 + 1;
			end
		end
	end
	local v135 = 0 - 0;
	local function v136()
		v133();
		v134();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		local v199;
		if (v13:IsDeadOrGhost() or ((107 + 3686) < (3048 - (642 + 37)))) then
			return;
		end
		if (v123.TargetIsValid() or v13:AffectingCombat() or ((932 + 3152) == (43 + 222))) then
			v118 = v13:GetEnemiesInRange(100 - 60);
			v116 = v10.BossFightRemains(nil, true);
			v117 = v116;
			if (((4812 - (233 + 221)) == (10077 - 5719)) and (v117 == (9780 + 1331))) then
				v117 = v10.FightRemains(v118, false);
			end
		end
		v199 = v128();
		if (v199 or ((4679 - (718 + 823)) < (625 + 368))) then
			return v199;
		end
		if (((4135 - (266 + 539)) > (6576 - 4253)) and (v13:AffectingCombat() or v30)) then
			local v204 = 1225 - (636 + 589);
			local v205;
			while true do
				if (((0 - 0) == v204) or ((7478 - 3852) == (3162 + 827))) then
					v205 = v45 and v119.PurifySpirit:IsReady() and v32;
					if ((v119.EarthShield:IsReady() and v96 and (v123.FriendlyUnitsWithBuffCount(v119.EarthShield, true, false, 10 + 15) < (1016 - (657 + 358)))) or ((2425 - 1509) == (6085 - 3414))) then
						local v244 = 1187 - (1151 + 36);
						while true do
							if (((263 + 9) == (72 + 200)) and (v244 == (2 - 1))) then
								if (((6081 - (1552 + 280)) <= (5673 - (64 + 770))) and (v123.UnitGroupRole(v17) == "TANK")) then
									if (((1886 + 891) < (7264 - 4064)) and v24(v120.EarthShieldFocus, not v17:IsSpellInRange(v119.EarthShield))) then
										return "earth_shield_tank main apl";
									end
								end
								break;
							end
							if (((17 + 78) < (3200 - (157 + 1086))) and (v244 == (0 - 0))) then
								v29 = v123.FocusUnitRefreshableBuff(v119.EarthShield, 65 - 50, 61 - 21, "TANK", true, 33 - 8);
								if (((1645 - (599 + 220)) < (3419 - 1702)) and v29) then
									return v29;
								end
								v244 = 1932 - (1813 + 118);
							end
						end
					end
					v204 = 1 + 0;
				end
				if (((2643 - (841 + 376)) >= (1547 - 442)) and ((1 + 0) == v204)) then
					if (((7516 - 4762) <= (4238 - (464 + 395))) and (not v17:BuffDown(v119.EarthShield) or (v123.UnitGroupRole(v17) ~= "TANK") or not v96 or (v123.FriendlyUnitsWithBuffCount(v119.EarthShield, true, false, 64 - 39) >= (1 + 0)))) then
						local v245 = 837 - (467 + 370);
						while true do
							if ((v245 == (0 - 0)) or ((2883 + 1044) == (4843 - 3430))) then
								v29 = v123.FocusUnit(v205, nil, nil, nil);
								if (v29 or ((181 + 973) <= (1832 - 1044))) then
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
		if ((v119.EarthShield:IsCastable() and v96 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(560 - (150 + 370)) and (v123.UnitGroupRole(v17) == "TANK") and (v17:BuffDown(v119.EarthShield))) or ((2925 - (74 + 1208)) > (8310 - 4931))) then
			if (v24(v120.EarthShieldFocus, not v17:IsSpellInRange(v119.EarthShield)) or ((13293 - 10490) > (3237 + 1312))) then
				return "earth_shield_tank main apl";
			end
		end
		if (not v13:AffectingCombat() or ((610 - (14 + 376)) >= (5241 - 2219))) then
			if (((1827 + 995) == (2479 + 343)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v238 = 0 + 0;
				local v239;
				while true do
					if ((v238 == (0 - 0)) or ((799 + 262) == (1935 - (23 + 55)))) then
						v239 = v123.DeadFriendlyUnitsCount();
						if (((6541 - 3781) > (911 + 453)) and (v239 > (1 + 0))) then
							if (v24(v119.AncestralVision, nil, v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((7600 - 2698) <= (1131 + 2464))) then
								return "ancestral_vision";
							end
						elseif (v24(v120.AncestralSpiritMouseover, not v15:IsInRange(941 - (652 + 249)), v13:BuffDown(v119.SpiritwalkersGraceBuff)) or ((10308 - 6456) == (2161 - (708 + 1160)))) then
							return "ancestral_spirit";
						end
						break;
					end
				end
			end
		end
		if ((v13:AffectingCombat() and v123.TargetIsValid()) or ((4231 - 2672) == (8364 - 3776))) then
			v29 = v123.Interrupt(v119.WindShear, 57 - (10 + 17), true);
			if (v29 or ((1008 + 3476) == (2520 - (1400 + 332)))) then
				return v29;
			end
			v29 = v123.InterruptCursor(v119.WindShear, v120.WindShearMouseover, 57 - 27, true, v16);
			if (((6476 - (242 + 1666)) >= (1672 + 2235)) and v29) then
				return v29;
			end
			v29 = v123.InterruptWithStunCursor(v119.CapacitorTotem, v120.CapacitorTotemCursor, 11 + 19, nil, v16);
			if (((1062 + 184) < (4410 - (850 + 90))) and v29) then
				return v29;
			end
			v199 = v127();
			if (((7124 - 3056) >= (2362 - (360 + 1030))) and v199) then
				return v199;
			end
			if (((437 + 56) < (10987 - 7094)) and v119.GreaterPurge:IsAvailable() and v47 and v119.GreaterPurge:IsReady() and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v123.UnitHasMagicBuff(v15)) then
				if (v24(v119.GreaterPurge, not v15:IsSpellInRange(v119.GreaterPurge)) or ((2025 - 552) >= (4993 - (909 + 752)))) then
					return "greater_purge utility";
				end
			end
			if ((v119.Purge:IsReady() and v47 and v32 and v46 and not v13:IsCasting() and not v13:IsChanneling() and v123.UnitHasMagicBuff(v15)) or ((5274 - (109 + 1114)) <= (2117 - 960))) then
				if (((236 + 368) < (3123 - (6 + 236))) and v24(v119.Purge, not v15:IsSpellInRange(v119.Purge))) then
					return "purge utility";
				end
			end
			if ((v117 > v111) or ((568 + 332) == (2719 + 658))) then
				v199 = v129();
				if (((10515 - 6056) > (1032 - 441)) and v199) then
					return v199;
				end
			end
		end
		if (((4531 - (1076 + 57)) >= (394 + 2001)) and (v30 or v13:AffectingCombat())) then
			if ((v32 and v45) or ((2872 - (579 + 110)) >= (223 + 2601))) then
				local v240 = 0 + 0;
				while true do
					if (((1028 + 908) == (2343 - (174 + 233))) and (v240 == (0 - 0))) then
						if (v17 or ((8480 - 3648) < (1918 + 2395))) then
							if (((5262 - (663 + 511)) > (3457 + 417)) and v119.PurifySpirit:IsReady() and v123.DispellableFriendlyUnit(6 + 19)) then
								if (((13355 - 9023) == (2624 + 1708)) and (v135 == (0 - 0))) then
									v135 = GetTime();
								end
								if (((9680 - 5681) >= (1384 + 1516)) and v123.Wait(973 - 473, v135)) then
									local v246 = 0 + 0;
									while true do
										if ((v246 == (0 + 0)) or ((3247 - (478 + 244)) > (4581 - (440 + 77)))) then
											if (((1988 + 2383) == (15998 - 11627)) and v24(v120.PurifySpiritFocus, not v17:IsSpellInRange(v119.PurifySpirit))) then
												return "purify_spirit dispel focus";
											end
											v135 = 1556 - (655 + 901);
											break;
										end
									end
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and (v123.UnitHasMagicDebuff(v16) or (v123.UnitHasCurseDebuff(v16) and v119.ImprovedPurifySpirit:IsAvailable()))) or ((50 + 216) > (3818 + 1168))) then
							if (((1345 + 646) >= (3726 - 2801)) and v119.PurifySpirit:IsReady()) then
								if (((1900 - (695 + 750)) < (7010 - 4957)) and v24(v120.PurifySpiritMouseover, not v16:IsSpellInRange(v119.PurifySpirit))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
			if (((v17:HealthPercentage() < v81) and v17:BuffDown(v119.Riptide)) or ((1274 - 448) == (19509 - 14658))) then
				if (((534 - (285 + 66)) == (426 - 243)) and v119.PrimordialWaveResto:IsCastable()) then
					if (((2469 - (682 + 628)) <= (289 + 1499)) and v24(v120.PrimordialWaveFocus, not v17:IsSpellInRange(v119.PrimordialWaveResto))) then
						return "primordial_wave main";
					end
				end
			end
			if (v33 or ((3806 - (176 + 123)) > (1807 + 2511))) then
				local v241 = 0 + 0;
				while true do
					if ((v241 == (269 - (239 + 30))) or ((836 + 2239) <= (2850 + 115))) then
						v199 = v130();
						if (((2415 - 1050) <= (6273 - 4262)) and v199) then
							return v199;
						end
						v241 = 316 - (306 + 9);
					end
					if ((v241 == (3 - 2)) or ((483 + 2293) > (2194 + 1381))) then
						v199 = v131();
						if (v199 or ((1230 + 1324) == (13737 - 8933))) then
							return v199;
						end
						break;
					end
				end
			end
			if (((3952 - (1140 + 235)) == (1640 + 937)) and v34) then
				if (v123.TargetIsValid() or ((6 + 0) >= (485 + 1404))) then
					v199 = v132();
					if (((558 - (33 + 19)) <= (684 + 1208)) and v199) then
						return v199;
					end
				end
			end
		end
	end
	local function v137()
		v125();
		v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(791 - 527, v136, v137);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

