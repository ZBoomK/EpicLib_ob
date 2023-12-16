local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1094 + 2068) <= (1939 + 1502)) and not v5) then
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
	local v111 = 12745 - (1607 + 27);
	local v112 = 3197 + 7914;
	local v113;
	v9:RegisterForEvent(function()
		v111 = 12837 - (1668 + 58);
		v112 = 11737 - (512 + 114);
	end, "PLAYER_REGEN_ENABLED");
	local v114 = v17.Shaman.Restoration;
	local v115 = v24.Shaman.Restoration;
	local v116 = v19.Shaman.Restoration;
	local v117 = {};
	local v118 = v21.Commons.Everyone;
	local v119 = v21.Commons.Shaman;
	local function v120()
		if (((12269 - 7563) > (9155 - 4726)) and v114.ImprovedPurifySpirit:IsAvailable()) then
			v118.DispellableDebuffs = v20.MergeTable(v118.DispellableMagicDebuffs, v118.DispellableCurseDebuffs);
		else
			v118.DispellableDebuffs = v118.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v120();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v121(v132)
		return v132:DebuffRefreshable(v114.FlameShockDebuff) and (v112 > (17 - 12));
	end
	local function v122()
		if (((1328 + 1526) < (767 + 3328)) and v87 and v114.AstralShift:IsReady()) then
			if ((v12:HealthPercentage() <= v53) or ((920 + 138) >= (4054 - 2852))) then
				if (((5705 - (109 + 1885)) > (4824 - (1269 + 200))) and v23(v114.AstralShift, not v14:IsInRange(76 - 36))) then
					return "astral_shift defensives";
				end
			end
		end
		if ((v90 and v114.EarthElemental:IsReady()) or ((1721 - (98 + 717)) >= (3055 - (802 + 24)))) then
			if (((2221 - 933) > (1579 - 328)) and ((v12:HealthPercentage() <= v61) or v118.IsTankBelowHealthPercentage(v62))) then
				if (v23(v114.EarthElemental, not v14:IsInRange(6 + 34)) or ((3468 + 1045) < (551 + 2801))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v116.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((446 + 1619) >= (8891 - 5695))) then
			if (v23(v115.Healthstone) or ((14592 - 10216) <= (530 + 951))) then
				return "healthstone defensive 3";
			end
		end
		if ((v37 and (v12:HealthPercentage() <= v38)) or ((1381 + 2011) >= (3911 + 830))) then
			if (((2418 + 907) >= (1006 + 1148)) and (v39 == "Refreshing Healing Potion")) then
				if (v116.RefreshingHealingPotion:IsReady() or ((2728 - (797 + 636)) >= (15697 - 12464))) then
					if (((5996 - (1427 + 192)) > (569 + 1073)) and v23(v115.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((10965 - 6242) > (1219 + 137)) and (v39 == "Dreamwalker's Healing Potion")) then
				if (v116.DreamwalkersHealingPotion:IsReady() or ((1875 + 2261) <= (3759 - (192 + 134)))) then
					if (((5521 - (316 + 960)) <= (2578 + 2053)) and v23(v115.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v123()
		local v133 = 0 + 0;
		while true do
			if (((3953 + 323) >= (14963 - 11049)) and (v133 == (551 - (83 + 468)))) then
				if (((2004 - (1202 + 604)) <= (20376 - 16011)) and v40) then
					local v226 = 0 - 0;
					while true do
						if (((13239 - 8457) > (5001 - (45 + 280))) and (v226 == (1 + 0))) then
							v28 = v118.HandleCharredTreant(v114.HealingSurge, v115.HealingSurgeMouseover, 35 + 5);
							if (((1777 + 3087) > (1216 + 981)) and v28) then
								return v28;
							end
							v226 = 1 + 1;
						end
						if ((v226 == (0 - 0)) or ((5611 - (340 + 1571)) == (989 + 1518))) then
							v28 = v118.HandleCharredTreant(v114.Riptide, v115.RiptideMouseover, 1812 - (1733 + 39));
							if (((12294 - 7820) >= (1308 - (125 + 909))) and v28) then
								return v28;
							end
							v226 = 1949 - (1096 + 852);
						end
						if ((v226 == (1 + 1)) or ((2704 - 810) <= (1364 + 42))) then
							v28 = v118.HandleCharredTreant(v114.HealingWave, v115.HealingWaveMouseover, 552 - (409 + 103));
							if (((1808 - (46 + 190)) >= (1626 - (51 + 44))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v41 or ((1322 + 3365) < (5859 - (1114 + 203)))) then
					local v227 = 726 - (228 + 498);
					while true do
						if (((714 + 2577) > (921 + 746)) and (v227 == (663 - (174 + 489)))) then
							v28 = v118.HandleCharredBrambles(v114.Riptide, v115.RiptideMouseover, 104 - 64);
							if (v28 or ((2778 - (830 + 1075)) == (2558 - (303 + 221)))) then
								return v28;
							end
							v227 = 1270 - (231 + 1038);
						end
						if ((v227 == (2 + 0)) or ((3978 - (171 + 991)) < (45 - 34))) then
							v28 = v118.HandleCharredBrambles(v114.HealingWave, v115.HealingWaveMouseover, 107 - 67);
							if (((9230 - 5531) < (3767 + 939)) and v28) then
								return v28;
							end
							break;
						end
						if (((9275 - 6629) >= (2526 - 1650)) and (v227 == (1 - 0))) then
							v28 = v118.HandleCharredBrambles(v114.HealingSurge, v115.HealingSurgeMouseover, 123 - 83);
							if (((1862 - (111 + 1137)) <= (3342 - (91 + 67))) and v28) then
								return v28;
							end
							v227 = 5 - 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v134 = 0 + 0;
		while true do
			if (((3649 - (423 + 100)) == (22 + 3104)) and (v134 == (5 - 3))) then
				if ((v94 and v118.AreUnitsBelowHealthPercentage(v73, v72) and v114.HealingTideTotem:IsReady()) or ((1140 + 1047) >= (5725 - (326 + 445)))) then
					if (v23(v114.HealingTideTotem, not v14:IsInRange(174 - 134)) or ((8637 - 4760) == (8344 - 4769))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if (((1418 - (530 + 181)) > (1513 - (614 + 267))) and v118.AreUnitsBelowHealthPercentage(v49, v48) and v114.AncestralProtectionTotem:IsReady()) then
					if ((v50 == "Player") or ((578 - (19 + 13)) >= (4368 - 1684))) then
						if (((3413 - 1948) <= (12286 - 7985)) and v23(v115.AncestralProtectionTotemPlayer, not v14:IsInRange(11 + 29))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((2996 - 1292) > (2955 - 1530)) and (v50 == "Friendly under Cursor")) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((2499 - (1293 + 519)) == (8638 - 4404))) then
							if (v23(v115.AncestralProtectionTotemCursor, not v14:IsInRange(104 - 64)) or ((6368 - 3038) < (6161 - 4732))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif (((2701 - 1554) >= (178 + 157)) and (v50 == "Confirmation")) then
						if (((701 + 2734) > (4872 - 2775)) and v23(v114.AncestralProtectionTotem, not v14:IsInRange(10 + 30))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v134 = 1 + 2;
			end
			if (((1 + 0) == v134) or ((4866 - (709 + 387)) >= (5899 - (673 + 1185)))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((10994 - 7203) <= (5173 - 3562))) then
					if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((7532 - 2954) <= (1437 + 571))) then
						if (((841 + 284) <= (2802 - 726)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if ((v118.AreUnitsBelowHealthPercentage(v80, v79) and v114.SpiritLinkTotem:IsReady()) or ((183 + 560) >= (8770 - 4371))) then
					if (((2266 - 1111) < (3553 - (446 + 1434))) and (v81 == "Player")) then
						if (v23(v115.SpiritLinkTotemPlayer, not v14:IsInRange(1323 - (1040 + 243))) or ((6936 - 4612) <= (2425 - (559 + 1288)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((5698 - (609 + 1322)) == (4221 - (13 + 441))) and (v81 == "Friendly under Cursor")) then
						if (((15279 - 11190) == (10710 - 6621)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((22202 - 17744) >= (63 + 1611)) and v23(v115.SpiritLinkTotemCursor, not v14:IsInRange(145 - 105))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((346 + 626) <= (622 + 796)) and (v81 == "Confirmation")) then
						if (v23(v114.SpiritLinkTotem, not v14:IsInRange(118 - 78)) or ((2703 + 2235) < (8757 - 3995))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v134 = 2 + 0;
			end
			if ((v134 == (3 + 1)) or ((1800 + 704) > (3581 + 683))) then
				if (((2107 + 46) == (2586 - (153 + 280))) and v96 and (v12:Mana() <= v75) and v114.ManaTideTotem:IsReady()) then
					if (v23(v114.ManaTideTotem, not v14:IsInRange(115 - 75)) or ((456 + 51) >= (1024 + 1567))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((2345 + 2136) == (4067 + 414)) and v34 and ((v103 and v30) or not v103)) then
					if (v114.AncestralCall:IsReady() or ((1687 + 641) < (1055 - 362))) then
						if (((2675 + 1653) == (4995 - (89 + 578))) and v23(v114.AncestralCall, not v14:IsInRange(29 + 11))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((3301 - 1713) >= (2381 - (572 + 477))) and v114.BagofTricks:IsReady()) then
						if (v23(v114.BagofTricks, not v14:IsInRange(6 + 34)) or ((2505 + 1669) > (508 + 3740))) then
							return "BagofTricks cooldowns";
						end
					end
					if (v114.Berserking:IsReady() or ((4672 - (84 + 2)) <= (134 - 52))) then
						if (((2783 + 1080) == (4705 - (497 + 345))) and v23(v114.Berserking, not v14:IsInRange(2 + 38))) then
							return "Berserking cooldowns";
						end
					end
					if (v114.BloodFury:IsReady() or ((48 + 234) <= (1375 - (605 + 728)))) then
						if (((3289 + 1320) >= (1702 - 936)) and v23(v114.BloodFury, not v14:IsInRange(2 + 38))) then
							return "BloodFury cooldowns";
						end
					end
					if (v114.Fireblood:IsReady() or ((4259 - 3107) == (2243 + 245))) then
						if (((9480 - 6058) > (2530 + 820)) and v23(v114.Fireblood, not v14:IsInRange(529 - (457 + 32)))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if (((373 + 504) > (1778 - (832 + 570))) and (v134 == (0 + 0))) then
				if ((v105 and ((v30 and v104) or not v104)) or ((814 + 2304) <= (6550 - 4699))) then
					local v228 = 0 + 0;
					while true do
						if ((v228 == (797 - (588 + 208))) or ((444 - 279) >= (5292 - (884 + 916)))) then
							v28 = v118.HandleBottomTrinket(v117, v30, 83 - 43, nil);
							if (((2290 + 1659) < (5509 - (232 + 421))) and v28) then
								return v28;
							end
							break;
						end
						if ((v228 == (1889 - (1569 + 320))) or ((1050 + 3226) < (573 + 2443))) then
							v28 = v118.HandleTopTrinket(v117, v30, 134 - 94, nil);
							if (((5295 - (316 + 289)) > (10798 - 6673)) and v28) then
								return v28;
							end
							v228 = 1 + 0;
						end
					end
				end
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((1503 - (666 + 787)) >= (1321 - (360 + 65)))) then
					if ((v16:HealthPercentage() <= v77) or ((1602 + 112) >= (3212 - (79 + 175)))) then
						if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((2350 - 859) < (503 + 141))) then
							return "riptide healingcd";
						end
					end
				end
				v134 = 2 - 1;
			end
			if (((1355 - 651) < (1886 - (503 + 396))) and (v134 == (184 - (92 + 89)))) then
				if (((7212 - 3494) > (978 + 928)) and v85 and v118.AreUnitsBelowHealthPercentage(v47, v46) and v114.AncestralGuidance:IsReady()) then
					if (v23(v114.AncestralGuidance, not v14:IsInRange(24 + 16)) or ((3751 - 2793) > (498 + 3137))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if (((7982 - 4481) <= (3920 + 572)) and v86 and v118.AreUnitsBelowHealthPercentage(v52, v51) and v114.Ascendance:IsReady()) then
					if (v23(v114.Ascendance, not v14:IsInRange(20 + 20)) or ((10482 - 7040) < (319 + 2229))) then
						return "ascendance cooldowns";
					end
				end
				v134 = 5 - 1;
			end
		end
	end
	local function v125()
		local v135 = 1244 - (485 + 759);
		while true do
			if (((6652 - 3777) >= (2653 - (442 + 747))) and (v135 == (1135 - (832 + 303)))) then
				if ((v88 and v118.AreUnitsBelowHealthPercentage(1041 - (88 + 858), 1 + 2) and v114.ChainHeal:IsReady() and v12:BuffUp(v114.HighTide)) or ((3970 + 827) >= (202 + 4691))) then
					if (v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((1340 - (766 + 23)) > (10209 - 8141))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if (((2891 - 777) > (2486 - 1542)) and v95 and (v16:HealthPercentage() <= v74) and v114.HealingWave:IsReady() and (v114.PrimordialWaveResto:TimeSinceLastCast() < (50 - 35))) then
					if (v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3335 - (1036 + 37)) >= (2195 + 901))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((4391 - 2136) >= (2783 + 754))) then
					if ((v16:HealthPercentage() <= v77) or ((5317 - (641 + 839)) < (2219 - (910 + 3)))) then
						if (((7520 - 4570) == (4634 - (1466 + 218))) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v135 = 1 + 0;
			end
			if ((v135 == (1151 - (556 + 592))) or ((1680 + 3043) < (4106 - (329 + 479)))) then
				if (((1990 - (174 + 680)) >= (528 - 374)) and v89 and v118.AreUnitsBelowHealthPercentage(v57, v56) and v114.CloudburstTotem:IsReady()) then
					if (v23(v114.CloudburstTotem) or ((561 - 290) > (3390 + 1358))) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((5479 - (396 + 343)) >= (279 + 2873)) and v100 and v118.AreUnitsBelowHealthPercentage(v102, v101) and v114.Wellspring:IsReady()) then
					if (v23(v114.Wellspring, not v14:IsInRange(1517 - (29 + 1448)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3967 - (135 + 1254)) >= (12770 - 9380))) then
						return "wellspring healingaoe";
					end
				end
				if (((191 - 150) <= (1107 + 554)) and v88 and v118.AreUnitsBelowHealthPercentage(v55, v54) and v114.ChainHeal:IsReady()) then
					if (((2128 - (389 + 1138)) < (4134 - (102 + 472))) and v23(v115.ChainHealFocus, not v16:IsSpellInRange(v114.ChainHeal), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v135 = 4 + 0;
			end
			if (((131 + 104) < (641 + 46)) and (v135 == (1547 - (320 + 1225)))) then
				if (((8097 - 3548) > (706 + 447)) and v118.AreUnitsBelowHealthPercentage(v67, v66) and v114.HealingRain:IsReady()) then
					if ((v68 == "Player") or ((6138 - (157 + 1307)) < (6531 - (821 + 1038)))) then
						if (((9151 - 5483) < (499 + 4062)) and v23(v115.HealingRainPlayer, not v14:IsInRange(71 - 31), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif ((v68 == "Friendly under Cursor") or ((170 + 285) == (8935 - 5330))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((3689 - (834 + 192)) == (211 + 3101))) then
							if (((1098 + 3179) <= (97 + 4378)) and v23(v115.HealingRainCursor, not v14:IsInRange(61 - 21), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v68 == "Enemy under Cursor") or ((1174 - (300 + 4)) == (318 + 871))) then
						if (((4065 - 2512) <= (3495 - (112 + 250))) and v15:Exists() and v12:CanAttack(v15)) then
							if (v23(v115.HealingRainCursor, not v14:IsInRange(16 + 24), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((5603 - 3366) >= (2012 + 1499))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v68 == "Confirmation") or ((685 + 639) > (2259 + 761))) then
						if (v23(v114.HealingRain, not v14:IsInRange(20 + 20), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((2223 + 769) == (3295 - (1001 + 413)))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if (((6926 - 3820) > (2408 - (244 + 638))) and v118.AreUnitsBelowHealthPercentage(v64, v63) and v114.EarthenWallTotem:IsReady()) then
					if (((3716 - (627 + 66)) < (11531 - 7661)) and (v65 == "Player")) then
						if (((745 - (512 + 90)) > (1980 - (1665 + 241))) and v23(v115.EarthenWallTotemPlayer, not v14:IsInRange(757 - (373 + 344)))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif (((9 + 9) < (559 + 1553)) and (v65 == "Friendly under Cursor")) then
						if (((2893 - 1796) <= (2754 - 1126)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((5729 - (35 + 1064)) == (3369 + 1261)) and v23(v115.EarthenWallTotemCursor, not v14:IsInRange(85 - 45))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((15 + 3525) > (3919 - (298 + 938))) and (v65 == "Confirmation")) then
						if (((6053 - (233 + 1026)) >= (4941 - (636 + 1030))) and v23(v114.EarthenWallTotem, not v14:IsInRange(21 + 19))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((1450 + 34) == (441 + 1043)) and v118.AreUnitsBelowHealthPercentage(v59, v58) and v114.Downpour:IsReady()) then
					if (((97 + 1335) < (3776 - (55 + 166))) and (v60 == "Player")) then
						if (v23(v115.DownpourPlayer, not v14:IsInRange(8 + 32), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((108 + 957) > (13664 - 10086))) then
							return "downpour healingaoe";
						end
					elseif ((v60 == "Friendly under Cursor") or ((5092 - (36 + 261)) < (2460 - 1053))) then
						if (((3221 - (34 + 1334)) < (1851 + 2962)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v115.DownpourCursor, not v14:IsInRange(32 + 8), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((4104 - (1035 + 248)) < (2452 - (20 + 1)))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v60 == "Confirmation") or ((1498 + 1376) < (2500 - (134 + 185)))) then
						if (v23(v114.Downpour, not v14:IsInRange(1173 - (549 + 584)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((3374 - (314 + 371)) <= (1177 - 834))) then
							return "downpour healingaoe";
						end
					end
				end
				v135 = 971 - (478 + 490);
			end
			if ((v135 == (1 + 0)) or ((3041 - (786 + 386)) == (6506 - 4497))) then
				if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((4925 - (1055 + 324)) < (3662 - (1093 + 247)))) then
					if (((v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) or ((1851 + 231) == (502 + 4271))) then
						if (((12879 - 9635) > (3580 - 2525)) and v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v99 and v114.UnleashLife:IsReady()) or ((9426 - 6113) <= (4467 - 2689))) then
					if ((v16:HealthPercentage() <= v84) or ((506 + 915) >= (8105 - 6001))) then
						if (((6245 - 4433) <= (2450 + 799)) and v23(v114.UnleashLife, not v16:IsSpellInRange(v114.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((4150 - 2527) <= (2645 - (364 + 324))) and (v68 == "Cursor") and v114.HealingRain:IsReady()) then
					if (((12094 - 7682) == (10586 - 6174)) and v23(v115.HealingRainCursor, not v14:IsInRange(14 + 26), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				v135 = 8 - 6;
			end
			if (((2802 - 1052) >= (2557 - 1715)) and (v135 == (1272 - (1249 + 19)))) then
				if (((3947 + 425) > (7201 - 5351)) and v98 and v12:IsMoving() and v118.AreUnitsBelowHealthPercentage(v83, v82) and v114.SpiritwalkersGrace:IsReady()) then
					if (((1318 - (686 + 400)) < (645 + 176)) and v23(v114.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if (((747 - (73 + 156)) < (5 + 897)) and v92 and v118.AreUnitsBelowHealthPercentage(v70, v69) and v114.HealingStreamTotem:IsReady()) then
					if (((3805 - (721 + 90)) > (10 + 848)) and v23(v114.HealingStreamTotem, nil)) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
		end
	end
	local function v126()
		if ((v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) or ((12192 - 8437) <= (1385 - (224 + 246)))) then
			if (((6392 - 2446) > (6891 - 3148)) and (v16:HealthPercentage() <= v77)) then
				if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((243 + 1092) >= (79 + 3227))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((3558 + 1286) > (4479 - 2226)) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
			if (((1504 - 1052) == (965 - (203 + 310))) and (v16:HealthPercentage() <= v78) and (v118.UnitGroupRole(v16) == "TANK")) then
				if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((6550 - (1238 + 755)) < (146 + 1941))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((5408 - (709 + 825)) == (7138 - 3264)) and v97 and v12:BuffDown(v114.UnleashLife) and v114.Riptide:IsReady() and v16:BuffDown(v114.Riptide)) then
			if ((v16:HealthPercentage() <= v77) or (v16:HealthPercentage() <= v77) or ((2822 - 884) > (5799 - (196 + 668)))) then
				if (v23(v115.RiptideFocus, not v16:IsSpellInRange(v114.Riptide)) or ((16799 - 12544) < (7090 - 3667))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((2287 - (171 + 662)) <= (2584 - (4 + 89))) and v114.ElementalOrbit:IsAvailable() and v12:BuffDown(v114.EarthShieldBuff)) then
			if (v23(v114.EarthShield) or ((14570 - 10413) <= (1021 + 1782))) then
				return "earth_shield healingst";
			end
		end
		if (((21315 - 16462) >= (1170 + 1812)) and v114.ElementalOrbit:IsAvailable() and v12:BuffUp(v114.EarthShieldBuff)) then
			if (((5620 - (35 + 1451)) > (4810 - (28 + 1425))) and v118.IsSoloMode()) then
				if ((v114.LightningShield:IsReady() and v12:BuffDown(v114.LightningShield)) or ((5410 - (941 + 1052)) < (2430 + 104))) then
					if (v23(v114.LightningShield) or ((4236 - (822 + 692)) <= (233 - 69))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v114.WaterShield:IsReady() and v12:BuffDown(v114.WaterShield)) or ((1135 + 1273) < (2406 - (45 + 252)))) then
				if (v23(v114.WaterShield) or ((33 + 0) == (501 + 954))) then
					return "water_shield healingst";
				end
			end
		end
		if ((v93 and v114.HealingSurge:IsReady()) or ((1078 - 635) >= (4448 - (114 + 319)))) then
			if (((4855 - 1473) > (212 - 46)) and (v16:HealthPercentage() <= v71)) then
				if (v23(v115.HealingSurgeFocus, not v16:IsSpellInRange(v114.HealingSurge), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((179 + 101) == (4556 - 1497))) then
					return "healing_surge healingst";
				end
			end
		end
		if (((3941 - 2060) > (3256 - (556 + 1407))) and v95 and v114.HealingWave:IsReady()) then
			if (((3563 - (741 + 465)) == (2822 - (170 + 295))) and (v16:HealthPercentage() <= v74)) then
				if (((65 + 58) == (113 + 10)) and v23(v115.HealingWaveFocus, not v16:IsSpellInRange(v114.HealingWave), v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v127()
		if (v114.Stormkeeper:IsReady() or ((2599 - 1543) >= (2812 + 580))) then
			if (v23(v114.Stormkeeper, not v14:IsInRange(26 + 14)) or ((613 + 468) < (2305 - (957 + 273)))) then
				return "stormkeeper damage";
			end
		end
		if ((#v12:GetEnemiesInRange(11 + 29) > (1 + 0)) or ((3997 - 2948) >= (11679 - 7247))) then
			if (v114.ChainLightning:IsReady() or ((14563 - 9795) <= (4189 - 3343))) then
				if (v23(v114.ChainLightning, not v14:IsSpellInRange(v114.ChainLightning), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((5138 - (389 + 1391)) <= (891 + 529))) then
					return "chain_lightning damage";
				end
			end
		end
		if (v114.FlameShock:IsReady() or ((390 + 3349) <= (6841 - 3836))) then
			if (v118.CastCycle(v114.FlameShock, v12:GetEnemiesInRange(991 - (783 + 168)), v121, not v14:IsSpellInRange(v114.FlameShock), nil, nil, nil, nil) or ((5567 - 3908) >= (2100 + 34))) then
				return "flame_shock_cycle damage";
			end
			if (v23(v114.FlameShock, not v14:IsSpellInRange(v114.FlameShock)) or ((3571 - (309 + 2)) < (7231 - 4876))) then
				return "flame_shock damage";
			end
		end
		if (v114.LavaBurst:IsReady() or ((1881 - (1090 + 122)) == (1370 + 2853))) then
			if (v23(v114.LavaBurst, not v14:IsSpellInRange(v114.LavaBurst), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((5682 - 3990) < (403 + 185))) then
				return "lava_burst damage";
			end
		end
		if (v114.LightningBolt:IsReady() or ((5915 - (628 + 490)) < (655 + 2996))) then
			if (v23(v114.LightningBolt, not v14:IsSpellInRange(v114.LightningBolt), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((10341 - 6164) > (22164 - 17314))) then
				return "lightning_bolt damage";
			end
		end
	end
	local function v128()
		v48 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v49 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v50 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v54 = EpicSettings.Settings['ChainHealGroup'];
		v55 = EpicSettings.Settings['ChainHealHP'];
		v42 = EpicSettings.Settings['DispelDebuffs'];
		v58 = EpicSettings.Settings['DownpourGroup'];
		v59 = EpicSettings.Settings['DownpourHP'];
		v60 = EpicSettings.Settings['DownpourUsage'];
		v63 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v64 = EpicSettings.Settings['EarthenWallTotemHP'];
		v65 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v41 = EpicSettings.Settings['HandleCharredBrambles'];
		v40 = EpicSettings.Settings['HandleCharredTreant'];
		v38 = EpicSettings.Settings['HealingPotionHP'];
		v39 = EpicSettings.Settings['HealingPotionName'];
		v66 = EpicSettings.Settings['HealingRainGroup'];
		v67 = EpicSettings.Settings['HealingRainHP'];
		v68 = EpicSettings.Settings['HealingRainUsage'];
		v69 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v70 = EpicSettings.Settings['HealingStreamTotemHP'];
		v71 = EpicSettings.Settings['HealingSurgeHP'];
		v72 = EpicSettings.Settings['HealingTideTotemGroup'];
		v73 = EpicSettings.Settings['HealingTideTotemHP'];
		v74 = EpicSettings.Settings['HealingWaveHP'];
		v36 = EpicSettings.Settings['healthstoneHP'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v77 = EpicSettings.Settings['RiptideHP'];
		v78 = EpicSettings.Settings['RiptideTankHP'];
		v79 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v80 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v81 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v82 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v83 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v84 = EpicSettings.Settings['UnleashLifeHP'];
		v88 = EpicSettings.Settings['UseChainHeal'];
		v89 = EpicSettings.Settings['UseCloudburstTotem'];
		v91 = EpicSettings.Settings['UseEarthShield'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v92 = EpicSettings.Settings['UseHealingStreamTotem'];
		v93 = EpicSettings.Settings['UseHealingSurge'];
		v94 = EpicSettings.Settings['UseHealingTideTotem'];
		v95 = EpicSettings.Settings['UseHealingWave'];
		v35 = EpicSettings.Settings['useHealthstone'];
		v97 = EpicSettings.Settings['UseRiptide'];
		v98 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v99 = EpicSettings.Settings['UseUnleashLife'];
		v109 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v110 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v129()
		local v187 = 774 - (431 + 343);
		while true do
			if ((v187 == (0 - 0)) or ((1157 - 757) > (878 + 233))) then
				v46 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v47 = EpicSettings.Settings['AncestralGuidanceHP'];
				v51 = EpicSettings.Settings['AscendanceGroup'];
				v52 = EpicSettings.Settings['AscendanceHP'];
				v187 = 1 + 0;
			end
			if (((4746 - (556 + 1139)) > (1020 - (6 + 9))) and (v187 == (1 + 4))) then
				v103 = EpicSettings.Settings['racialsWithCD'];
				v104 = EpicSettings.Settings['trinketsWithCD'];
				v105 = EpicSettings.Settings['useTrinkets'];
				v106 = EpicSettings.Settings['fightRemainsCheck'];
				v187 = 4 + 2;
			end
			if (((3862 - (28 + 141)) <= (1698 + 2684)) and (v187 == (4 - 0))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v100 = EpicSettings.Settings['UseWellspring'];
				v101 = EpicSettings.Settings['WellspringGroup'];
				v102 = EpicSettings.Settings['WellspringHP'];
				v187 = 4 + 1;
			end
			if ((v187 == (1320 - (486 + 831))) or ((8540 - 5258) > (14434 - 10334))) then
				v86 = EpicSettings.Settings['UseAscendance'];
				v87 = EpicSettings.Settings['UseAstralShift'];
				v90 = EpicSettings.Settings['UseEarthElemental'];
				v96 = EpicSettings.Settings['UseManaTideTotem'];
				v187 = 1 + 3;
			end
			if ((v187 == (3 - 2)) or ((4843 - (668 + 595)) < (2560 + 284))) then
				v53 = EpicSettings.Settings['AstralShiftHP'];
				v56 = EpicSettings.Settings['CloudburstTotemGroup'];
				v57 = EpicSettings.Settings['CloudburstTotemHP'];
				v61 = EpicSettings.Settings['EarthElementalHP'];
				v187 = 1 + 1;
			end
			if (((242 - 153) < (4780 - (23 + 267))) and (v187 == (1950 - (1129 + 815)))) then
				v107 = EpicSettings.Settings['handleAfflicted'];
				v108 = EpicSettings.Settings['HandleIncorporeal'];
				v109 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v110 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v187 == (389 - (371 + 16))) or ((6733 - (1326 + 424)) < (3424 - 1616))) then
				v62 = EpicSettings.Settings['EarthElementalTankHP'];
				v75 = EpicSettings.Settings['ManaTideTotemMana'];
				v76 = EpicSettings.Settings['PrimordialWaveHP'];
				v85 = EpicSettings.Settings['UseAncestralGuidance'];
				v187 = 10 - 7;
			end
		end
	end
	local function v130()
		local v188 = 118 - (88 + 30);
		local v189;
		while true do
			if (((4600 - (720 + 51)) > (8383 - 4614)) and (v188 == (1776 - (421 + 1355)))) then
				v128();
				v129();
				v29 = EpicSettings.Toggles['ooc'];
				v188 = 1 - 0;
			end
			if (((730 + 755) <= (3987 - (286 + 797))) and (v188 == (7 - 5))) then
				v33 = EpicSettings.Toggles['dps'];
				if (((7070 - 2801) == (4708 - (397 + 42))) and v12:IsDeadOrGhost()) then
					return;
				end
				if (((121 + 266) <= (3582 - (24 + 776))) and (v12:AffectingCombat() or v29)) then
					local v229 = v42 and v114.PurifySpirit:IsReady() and v31;
					if ((v114.EarthShield:IsReady() and v91 and (v118.FriendlyUnitsWithBuffCount(v114.EarthShield, true) < (1 - 0))) or ((2684 - (222 + 563)) <= (2019 - 1102))) then
						local v231 = 0 + 0;
						while true do
							if (((190 - (23 + 167)) == v231) or ((6110 - (690 + 1108)) <= (317 + 559))) then
								v28 = v118.FocusUnitRefreshableBuff(v114.EarthShield, 13 + 2, 888 - (40 + 808), "TANK");
								if (((368 + 1864) <= (9927 - 7331)) and v28) then
									return v28;
								end
								v231 = 1 + 0;
							end
							if (((1109 + 986) < (2022 + 1664)) and (v231 == (572 - (47 + 524)))) then
								if ((v118.UnitGroupRole(v16) == "TANK") or ((1036 + 559) >= (12229 - 7755))) then
									if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((6906 - 2287) < (6572 - 3690))) then
										return "earth_shield_tank main apl";
									end
								end
								break;
							end
						end
					end
					if (not v16:BuffDown(v114.EarthShield) or (v118.UnitGroupRole(v16) ~= "TANK") or not v91 or ((2020 - (1165 + 561)) >= (144 + 4687))) then
						local v232 = 0 - 0;
						while true do
							if (((775 + 1254) <= (3563 - (341 + 138))) and ((0 + 0) == v232)) then
								v28 = v118.FocusUnit(v229, nil, nil, nil);
								if (v28 or ((4203 - 2166) == (2746 - (89 + 237)))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v188 = 9 - 6;
			end
			if (((9385 - 4927) > (4785 - (581 + 300))) and (v188 == (1223 - (855 + 365)))) then
				if (((1035 - 599) >= (41 + 82)) and v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(1275 - (1030 + 205)) and (v118.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v114.EarthShield))) then
					if (((470 + 30) < (1690 + 126)) and v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v189 = nil;
				if (((3860 - (156 + 130)) == (8120 - 4546)) and not v12:AffectingCombat()) then
					if (((372 - 151) < (798 - 408)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v233 = v118.DeadFriendlyUnitsCount();
						if ((v233 > (1 + 0)) or ((1291 + 922) <= (1490 - (10 + 59)))) then
							if (((865 + 2193) < (23934 - 19074)) and v23(v114.AncestralVision, nil, v12:BuffDown(v114.SpiritwalkersGraceBuff))) then
								return "ancestral_vision";
							end
						elseif (v23(v115.AncestralSpiritMouseover, not v14:IsInRange(1203 - (671 + 492)), v12:BuffDown(v114.SpiritwalkersGraceBuff)) or ((1032 + 264) >= (5661 - (369 + 846)))) then
							return "ancestral_spirit";
						end
					end
				end
				v188 = 2 + 2;
			end
			if ((v188 == (4 + 0)) or ((3338 - (1036 + 909)) > (3570 + 919))) then
				if ((v12:AffectingCombat() and v118.TargetIsValid()) or ((7427 - 3003) < (230 - (11 + 192)))) then
					local v230 = 0 + 0;
					while true do
						if ((v230 == (175 - (135 + 40))) or ((4838 - 2841) > (2300 + 1515))) then
							v113 = v12:GetEnemiesInRange(88 - 48);
							v111 = v9.BossFightRemains(nil, true);
							v112 = v111;
							if (((5194 - 1729) > (2089 - (50 + 126))) and (v112 == (30938 - 19827))) then
								v112 = v9.FightRemains(v113, false);
							end
							v230 = 1 + 0;
						end
						if (((2146 - (1233 + 180)) < (2788 - (522 + 447))) and (v230 == (1422 - (107 + 1314)))) then
							v28 = v118.Interrupt(v114.WindShear, 14 + 16, true);
							if (v28 or ((13392 - 8997) == (2020 + 2735))) then
								return v28;
							end
							v28 = v118.InterruptCursor(v114.WindShear, v115.WindShearMouseover, 59 - 29, true, v15);
							if (v28 or ((15007 - 11214) < (4279 - (716 + 1194)))) then
								return v28;
							end
							v230 = 1 + 1;
						end
						if (((1 + 1) == v230) or ((4587 - (74 + 429)) == (511 - 246))) then
							v28 = v118.InterruptWithStunCursor(v114.CapacitorTotem, v115.CapacitorTotemCursor, 15 + 15, nil, v15);
							if (((9975 - 5617) == (3084 + 1274)) and v28) then
								return v28;
							end
							if (v108 or ((9674 - 6536) < (2455 - 1462))) then
								v28 = v118.HandleIncorporeal(v114.Hex, v115.HexMouseOver, 463 - (279 + 154), true);
								if (((4108 - (454 + 324)) > (1828 + 495)) and v28) then
									return v28;
								end
							end
							if (v107 or ((3643 - (12 + 5)) == (2151 + 1838))) then
								v28 = v118.HandleAfflicted(v114.PurifySpirit, v115.PurifySpiritMouseover, 76 - 46);
								if (v28 or ((339 + 577) == (3764 - (277 + 816)))) then
									return v28;
								end
								if (((1162 - 890) == (1455 - (1058 + 125))) and v109) then
									v28 = v118.HandleAfflicted(v114.TremorTotem, v114.TremorTotem, 6 + 24);
									if (((5224 - (815 + 160)) <= (20762 - 15923)) and v28) then
										return v28;
									end
								end
								if (((6591 - 3814) < (764 + 2436)) and v110) then
									v28 = v118.HandleAfflicted(v114.PoisonCleansingTotem, v114.PoisonCleansingTotem, 87 - 57);
									if (((1993 - (41 + 1857)) < (3850 - (1222 + 671))) and v28) then
										return v28;
									end
								end
							end
							v230 = 7 - 4;
						end
						if (((1186 - 360) < (2899 - (229 + 953))) and (v230 == (1777 - (1111 + 663)))) then
							v189 = v122();
							if (((3005 - (874 + 705)) >= (155 + 950)) and v189) then
								return v189;
							end
							if (((1879 + 875) <= (7023 - 3644)) and (v112 > v106)) then
								v189 = v124();
								if (v189 or ((111 + 3816) == (2092 - (642 + 37)))) then
									return v189;
								end
							end
							break;
						end
					end
				end
				if (v29 or v12:AffectingCombat() or ((264 + 890) <= (127 + 661))) then
					if (v31 or ((4124 - 2481) > (3833 - (233 + 221)))) then
						if ((v16 and v42) or ((6481 - 3678) > (4004 + 545))) then
							if ((v114.PurifySpirit:IsReady() and v118.DispellableFriendlyUnit(1566 - (718 + 823))) or ((139 + 81) >= (3827 - (266 + 539)))) then
								if (((7989 - 5167) == (4047 - (636 + 589))) and v23(v115.PurifySpiritFocus, not v16:IsSpellInRange(v114.PurifySpirit))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					if (((v16:HealthPercentage() < v76) and v16:BuffDown(v114.Riptide)) or ((2518 - 1457) == (3830 - 1973))) then
						if (((2188 + 572) > (496 + 868)) and v114.PrimordialWaveResto:IsCastable()) then
							if (v23(v115.PrimordialWaveFocus, not v16:IsSpellInRange(v114.PrimordialWaveResto)) or ((5917 - (657 + 358)) <= (9518 - 5923))) then
								return "primordial_wave main";
							end
						end
					end
					if ((v114.EarthShield:IsCastable() and v91 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(91 - 51) and (v118.UnitGroupRole(v16) == "TANK") and v16:BuffDown(v114.EarthShield)) or ((5039 - (1151 + 36)) == (283 + 10))) then
						if (v23(v115.EarthShieldFocus, not v16:IsSpellInRange(v114.EarthShield)) or ((410 + 1149) == (13701 - 9113))) then
							return "earth_shield_tank main fight";
						end
					end
					v189 = v123();
					if (v189 or ((6316 - (1552 + 280)) == (1622 - (64 + 770)))) then
						return v189;
					end
					if (((3102 + 1466) >= (8868 - 4961)) and v32) then
						local v234 = 0 + 0;
						while true do
							if (((2489 - (157 + 1086)) < (6945 - 3475)) and (v234 == (4 - 3))) then
								v189 = v126();
								if (((6239 - 2171) >= (1326 - 354)) and v189) then
									return v189;
								end
								break;
							end
							if (((1312 - (599 + 220)) < (7751 - 3858)) and ((1931 - (1813 + 118)) == v234)) then
								v189 = v125();
								if (v189 or ((1077 + 396) >= (4549 - (841 + 376)))) then
									return v189;
								end
								v234 = 1 - 0;
							end
						end
					end
					if (v33 or ((942 + 3109) <= (3157 - 2000))) then
						if (((1463 - (464 + 395)) < (7393 - 4512)) and v118.TargetIsValid()) then
							local v235 = 0 + 0;
							while true do
								if ((v235 == (837 - (467 + 370))) or ((1859 - 959) == (2479 + 898))) then
									v189 = v127();
									if (((15285 - 10826) > (93 + 498)) and v189) then
										return v189;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
			if (((7905 - 4507) >= (2915 - (150 + 370))) and (v188 == (1283 - (74 + 1208)))) then
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v188 = 4 - 2;
			end
		end
	end
	local function v131()
		v120();
		v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(1252 - 988, v130, v131);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

