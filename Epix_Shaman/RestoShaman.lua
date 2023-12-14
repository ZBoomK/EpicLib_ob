local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1364 + 42) < (2406 - (409 + 103))) and (v5 == (237 - (46 + 190)))) then
			return v6(...);
		end
		if (((1667 - (51 + 44)) >= (432 + 1099)) and (v5 == (1317 - (1114 + 203)))) then
			v6 = v0[v4];
			if (not v6 or ((5413 - (228 + 498)) < (985 + 3557))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v115 = 11774 - (174 + 489);
	local v116 = 28947 - 17836;
	local v117;
	v10:RegisterForEvent(function()
		local v136 = 1905 - (830 + 1075);
		while true do
			if (((3815 - (303 + 221)) > (2936 - (231 + 1038))) and (v136 == (0 + 0))) then
				v115 = 12273 - (171 + 991);
				v116 = 45790 - 34679;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v118 = v18.Shaman.Restoration;
	local v119 = v25.Shaman.Restoration;
	local v120 = v20.Shaman.Restoration;
	local v121 = {};
	local v122 = v22.Commons.Everyone;
	local v123 = v22.Commons.Shaman;
	local function v124()
		if (v118.ImprovedPurifySpirit:IsAvailable() or ((2343 - 1470) == (5075 - 3041))) then
			v122.DispellableDebuffs = v21.MergeTable(v122.DispellableMagicDebuffs, v122.DispellableCurseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125(v137)
		return v137:DebuffRefreshable(v118.FlameShockDebuff) and (v116 > (5 + 0));
	end
	local function v126()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (2 - 1)) or ((4538 - 1722) < (33 - 22))) then
				if (((4947 - (111 + 1137)) < (4864 - (91 + 67))) and v120.Healthstone:IsReady() and v36 and (v13:HealthPercentage() <= v37)) then
					if (((7875 - 5229) >= (219 + 657)) and v24(v119.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((1137 - (423 + 100)) <= (23 + 3161)) and v38 and (v13:HealthPercentage() <= v39)) then
					if (((8654 - 5528) == (1630 + 1496)) and (v40 == "Refreshing Healing Potion")) then
						if (v120.RefreshingHealingPotion:IsReady() or ((2958 - (326 + 445)) >= (21619 - 16665))) then
							if (v24(v119.RefreshingHealingPotion) or ((8637 - 4760) == (8344 - 4769))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1418 - (530 + 181)) > (1513 - (614 + 267))) and (v40 == "Dreamwalker's Healing Potion")) then
						if (v120.DreamwalkersHealingPotion:IsReady() or ((578 - (19 + 13)) >= (4368 - 1684))) then
							if (((3413 - 1948) <= (12286 - 7985)) and v24(v119.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((443 + 1261) > (2505 - 1080)) and (v138 == (0 - 0))) then
				if ((v90 and v118.AstralShift:IsReady()) or ((2499 - (1293 + 519)) == (8638 - 4404))) then
					if ((v13:HealthPercentage() <= v55) or ((8694 - 5364) < (2732 - 1303))) then
						if (((4945 - 3798) >= (788 - 453)) and v24(v118.AstralShift)) then
							return "astral_shift defensives";
						end
					end
				end
				if (((1820 + 1615) > (428 + 1669)) and v93 and v118.EarthElemental:IsReady()) then
					if ((v13:HealthPercentage() <= v63) or v122.IsTankBelowHealthPercentage(v64) or ((8759 - 4989) >= (934 + 3107))) then
						if (v24(v118.EarthElemental) or ((1260 + 2531) <= (1007 + 604))) then
							return "earth_elemental defensives";
						end
					end
				end
				v138 = 1097 - (709 + 387);
			end
		end
	end
	local function v127()
		local v139 = 1858 - (673 + 1185);
		while true do
			if ((v139 == (0 - 0)) or ((14700 - 10122) <= (3303 - 1295))) then
				if (((805 + 320) <= (1552 + 524)) and v41) then
					local v238 = 0 - 0;
					while true do
						if ((v238 == (1 + 1)) or ((1481 - 738) >= (8634 - 4235))) then
							v29 = v122.HandleCharredTreant(v118.HealingWave, v119.HealingWaveMouseover, 1920 - (446 + 1434));
							if (((2438 - (1040 + 243)) < (4993 - 3320)) and v29) then
								return v29;
							end
							break;
						end
						if ((v238 == (1847 - (559 + 1288))) or ((4255 - (609 + 1322)) <= (1032 - (13 + 441)))) then
							v29 = v122.HandleCharredTreant(v118.Riptide, v119.RiptideMouseover, 149 - 109);
							if (((9867 - 6100) == (18761 - 14994)) and v29) then
								return v29;
							end
							v238 = 1 + 0;
						end
						if (((14850 - 10761) == (1453 + 2636)) and (v238 == (1 + 0))) then
							v29 = v122.HandleCharredTreant(v118.HealingSurge, v119.HealingSurgeMouseover, 118 - 78);
							if (((2440 + 2018) >= (3078 - 1404)) and v29) then
								return v29;
							end
							v238 = 2 + 0;
						end
					end
				end
				if (((541 + 431) <= (1019 + 399)) and v42) then
					local v239 = 0 + 0;
					while true do
						if ((v239 == (1 + 0)) or ((5371 - (153 + 280)) < (13750 - 8988))) then
							v29 = v122.HandleCharredBrambles(v118.HealingSurge, v119.HealingSurgeMouseover, 36 + 4);
							if (v29 or ((989 + 1515) > (2232 + 2032))) then
								return v29;
							end
							v239 = 2 + 0;
						end
						if (((1561 + 592) == (3278 - 1125)) and (v239 == (2 + 0))) then
							v29 = v122.HandleCharredBrambles(v118.HealingWave, v119.HealingWaveMouseover, 707 - (89 + 578));
							if (v29 or ((363 + 144) >= (5386 - 2795))) then
								return v29;
							end
							break;
						end
						if (((5530 - (572 + 477)) == (605 + 3876)) and (v239 == (0 + 0))) then
							v29 = v122.HandleCharredBrambles(v118.Riptide, v119.RiptideMouseover, 5 + 35);
							if (v29 or ((2414 - (84 + 2)) < (1141 - 448))) then
								return v29;
							end
							v239 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v140 = 842 - (497 + 345);
		while true do
			if (((111 + 4217) == (732 + 3596)) and (v140 == (1335 - (605 + 728)))) then
				if (((1134 + 454) >= (2960 - 1628)) and v89 and v122.AreUnitsBelowHealthPercentage(v54, v53) and v118.Ascendance:IsReady()) then
					if (v24(v118.Ascendance) or ((192 + 3982) > (15705 - 11457))) then
						return "ascendance cooldowns";
					end
				end
				if ((v99 and (v13:Mana() <= v77) and v118.ManaTideTotem:IsReady()) or ((4135 + 451) <= (226 - 144))) then
					if (((2917 + 946) == (4352 - (457 + 32))) and v24(v118.ManaTideTotem)) then
						return "mana_tide_totem cooldowns";
					end
				end
				if ((v35 and ((v106 and v31) or not v106)) or ((120 + 162) <= (1444 - (832 + 570)))) then
					if (((4343 + 266) >= (200 + 566)) and v118.AncestralCall:IsReady()) then
						if (v24(v118.AncestralCall) or ((4076 - 2924) == (1199 + 1289))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((4218 - (588 + 208)) > (9029 - 5679)) and v118.BagofTricks:IsReady()) then
						if (((2677 - (884 + 916)) > (786 - 410)) and v24(v118.BagofTricks)) then
							return "BagofTricks cooldowns";
						end
					end
					if (v118.Berserking:IsReady() or ((1808 + 1310) <= (2504 - (232 + 421)))) then
						if (v24(v118.Berserking) or ((2054 - (1569 + 320)) >= (857 + 2635))) then
							return "Berserking cooldowns";
						end
					end
					if (((751 + 3198) < (16363 - 11507)) and v118.BloodFury:IsReady()) then
						if (v24(v118.BloodFury) or ((4881 - (316 + 289)) < (7894 - 4878))) then
							return "BloodFury cooldowns";
						end
					end
					if (((217 + 4473) > (5578 - (666 + 787))) and v118.Fireblood:IsReady()) then
						if (v24(v118.Fireblood) or ((475 - (360 + 65)) >= (838 + 58))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if ((v140 == (255 - (79 + 175))) or ((2702 - 988) >= (2309 + 649))) then
				if ((v122.AreUnitsBelowHealthPercentage(v83, v82) and v118.SpiritLinkTotem:IsReady()) or ((4570 - 3079) < (1239 - 595))) then
					if (((1603 - (503 + 396)) < (1168 - (92 + 89))) and (v84 == "Player")) then
						if (((7212 - 3494) > (978 + 928)) and v24(v119.SpiritLinkTotemPlayer)) then
							return "spirit_link_totem cooldowns";
						end
					elseif ((v84 == "Friendly under Cursor") or ((567 + 391) > (14235 - 10600))) then
						if (((479 + 3022) <= (10242 - 5750)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v119.SpiritLinkTotemCursor, not v15:IsInRange(35 + 5)) or ((1645 + 1797) < (7760 - 5212))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((359 + 2516) >= (2232 - 768)) and (v84 == "Confirmation")) then
						if (v24(v118.SpiritLinkTotem) or ((6041 - (485 + 759)) >= (11321 - 6428))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				if ((v97 and v122.AreUnitsBelowHealthPercentage(v75, v74) and v118.HealingTideTotem:IsReady()) or ((1740 - (442 + 747)) > (3203 - (832 + 303)))) then
					if (((3060 - (88 + 858)) > (288 + 656)) and v24(v118.HealingTideTotem)) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v51, v50) and v118.AncestralProtectionTotem:IsReady()) or ((1873 + 389) >= (128 + 2968))) then
					if ((v52 == "Player") or ((3044 - (766 + 23)) >= (17461 - 13924))) then
						if (v24(v119.AncestralProtectionTotemPlayer) or ((5247 - 1410) < (3440 - 2134))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif (((10012 - 7062) == (4023 - (1036 + 37))) and (v52 == "Friendly under Cursor")) then
						if ((v16:Exists() and not v13:CanAttack(v16)) or ((3349 + 1374) < (6422 - 3124))) then
							if (((894 + 242) >= (1634 - (641 + 839))) and v24(v119.AncestralProtectionTotemCursor, not v15:IsInRange(953 - (910 + 3)))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v52 == "Confirmation") or ((690 - 419) > (6432 - (1466 + 218)))) then
						if (((2179 + 2561) >= (4300 - (556 + 592))) and v24(v118.AncestralProtectionTotem)) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				if ((v88 and v122.AreUnitsBelowHealthPercentage(v49, v48) and v118.AncestralGuidance:IsReady()) or ((917 + 1661) >= (4198 - (329 + 479)))) then
					if (((895 - (174 + 680)) <= (5707 - 4046)) and v24(v118.AncestralGuidance)) then
						return "ancestral_guidance cooldowns";
					end
				end
				v140 = 3 - 1;
			end
			if (((430 + 171) < (4299 - (396 + 343))) and (v140 == (0 + 0))) then
				if (((1712 - (29 + 1448)) < (2076 - (135 + 1254))) and v108 and ((v31 and v107) or not v107)) then
					local v240 = 0 - 0;
					while true do
						if (((21239 - 16690) > (769 + 384)) and (v240 == (1527 - (389 + 1138)))) then
							v29 = v122.HandleTopTrinket(v121, v31, 614 - (102 + 472), nil);
							if (v29 or ((4411 + 263) < (2591 + 2081))) then
								return v29;
							end
							v240 = 1 + 0;
						end
						if (((5213 - (320 + 1225)) < (8119 - 3558)) and (v240 == (1 + 0))) then
							v29 = v122.HandleBottomTrinket(v121, v31, 1504 - (157 + 1307), nil);
							if (v29 or ((2314 - (821 + 1038)) == (8994 - 5389))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v118.EarthShield:IsReady() and v94 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(5 + 35) and (v122.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v118.EarthShield) and (v122.FriendlyUnitsWithBuffCount(v118.EarthShieldBuff, true) <= (1 - 0))) or ((991 + 1672) == (8208 - 4896))) then
					if (((5303 - (834 + 192)) <= (285 + 4190)) and v24(v119.EarthShieldFocus)) then
						return "earth_shield_tank healingst";
					end
				end
				if ((v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((224 + 646) == (26 + 1163))) then
					if (((2405 - 852) <= (3437 - (300 + 4))) and (v17:HealthPercentage() <= v80)) then
						if (v24(v119.RiptideFocus) or ((598 + 1639) >= (9190 - 5679))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((1686 - (112 + 250)) > (1204 + 1816))) then
					if (((v17:HealthPercentage() <= v81) and (v122.UnitGroupRole(v17) == "TANK")) or ((7495 - 4503) == (1078 + 803))) then
						if (((1607 + 1499) > (1142 + 384)) and v24(v119.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v129()
		local v141 = 0 + 0;
		while true do
			if (((4437 - (1001 + 413)) < (8630 - 4760)) and (v141 == (884 - (244 + 638)))) then
				if (((836 - (627 + 66)) > (220 - 146)) and (v70 == "Cursor") and v118.HealingRain:IsReady()) then
					if (((620 - (512 + 90)) < (4018 - (1665 + 241))) and v24(v119.HealingRainCursor, not v15:IsInRange(757 - (373 + 344)), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_rain healingaoe";
					end
				end
				if (((495 + 602) <= (431 + 1197)) and v122.AreUnitsBelowHealthPercentage(v69, v68) and v118.HealingRain:IsReady()) then
					if (((12212 - 7582) == (7835 - 3205)) and (v70 == "Player")) then
						if (((4639 - (35 + 1064)) > (1953 + 730)) and v24(v119.HealingRainPlayer, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					elseif (((10256 - 5462) >= (14 + 3261)) and (v70 == "Friendly under Cursor")) then
						if (((2720 - (298 + 938)) == (2743 - (233 + 1026))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (((3098 - (636 + 1030)) < (1818 + 1737)) and v24(v119.HealingRainCursor, not v15:IsInRange(40 + 0), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v70 == "Enemy under Cursor") or ((317 + 748) > (242 + 3336))) then
						if ((v16:Exists() and v13:CanAttack(v16)) or ((5016 - (55 + 166)) < (273 + 1134))) then
							if (((187 + 1666) < (18380 - 13567)) and v24(v119.HealingRainCursor, not v15:IsInRange(337 - (36 + 261)), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v70 == "Confirmation") or ((4933 - 2112) < (3799 - (34 + 1334)))) then
						if (v24(v118.HealingRain, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((1105 + 1769) < (1695 + 486))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v122.AreUnitsBelowHealthPercentage(v66, v65) and v118.EarthenWallTotem:IsReady()) or ((3972 - (1035 + 248)) <= (364 - (20 + 1)))) then
					if ((v67 == "Player") or ((974 + 895) == (2328 - (134 + 185)))) then
						if (v24(v119.EarthenWallTotemPlayer) or ((4679 - (549 + 584)) < (3007 - (314 + 371)))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v67 == "Friendly under Cursor") or ((7147 - 5065) == (5741 - (478 + 490)))) then
						if (((1719 + 1525) > (2227 - (786 + 386))) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v119.EarthenWallTotemCursor, not v15:IsInRange(129 - 89)) or ((4692 - (1055 + 324)) <= (3118 - (1093 + 247)))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif ((v67 == "Confirmation") or ((1263 + 158) >= (222 + 1882))) then
						if (((7193 - 5381) <= (11026 - 7777)) and v24(v118.EarthenWallTotem)) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				v141 = 8 - 5;
			end
			if (((4078 - 2455) <= (697 + 1260)) and ((3 - 2) == v141)) then
				if (((15207 - 10795) == (3327 + 1085)) and v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
					if (((4475 - 2725) >= (1530 - (364 + 324))) and (v17:HealthPercentage() <= v80)) then
						if (((11984 - 7612) > (4439 - 2589)) and v24(v119.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				if (((77 + 155) < (3435 - 2614)) and v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) then
					if (((829 - 311) < (2739 - 1837)) and (v17:HealthPercentage() <= v81) and (v122.UnitGroupRole(v17) == "TANK")) then
						if (((4262 - (1249 + 19)) > (775 + 83)) and v24(v119.RiptideFocus)) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v102 and v118.UnleashLife:IsReady()) or ((14616 - 10861) <= (2001 - (686 + 400)))) then
					if (((3097 + 849) > (3972 - (73 + 156))) and (v17:HealthPercentage() <= v87)) then
						if (v24(v118.UnleashLife) or ((7 + 1328) >= (4117 - (721 + 90)))) then
							return "unleash_life healingaoe";
						end
					end
				end
				v141 = 1 + 1;
			end
			if (((15727 - 10883) > (2723 - (224 + 246))) and (v141 == (0 - 0))) then
				if (((831 - 379) == (82 + 370)) and v118.EarthShield:IsReady() and v94 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(1 + 39) and (v122.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v118.EarthShield) and (v122.FriendlyUnitsWithBuffCount(v118.EarthShieldBuff, true) <= (1 + 0))) then
					if (v24(v119.EarthShieldFocus) or ((9059 - 4502) < (6944 - 4857))) then
						return "earth_shield_tank healingst";
					end
				end
				if (((4387 - (203 + 310)) == (5867 - (1238 + 755))) and v91 and v122.AreUnitsBelowHealthPercentage(7 + 83, 1537 - (709 + 825)) and v118.ChainHeal:IsReady() and v13:BuffUp(v118.HighTide)) then
					if (v24(v119.ChainHealFocus, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((3570 - 1632) > (7188 - 2253))) then
						return "chain_heal healingaoe";
					end
				end
				if ((v98 and (v17:HealthPercentage() <= v76) and v118.HealingWave:IsReady() and (v118.PrimordialWave:TimeSinceLastCast() < (879 - (196 + 668)))) or ((16799 - 12544) < (7090 - 3667))) then
					if (((2287 - (171 + 662)) <= (2584 - (4 + 89))) and v24(v119.HealingWaveFocus, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe";
					end
				end
				v141 = 3 - 2;
			end
			if ((v141 == (2 + 2)) or ((18258 - 14101) <= (1100 + 1703))) then
				if (((6339 - (35 + 1451)) >= (4435 - (28 + 1425))) and v91 and v122.AreUnitsBelowHealthPercentage(v57, v56) and v118.ChainHeal:IsReady()) then
					if (((6127 - (941 + 1052)) > (3219 + 138)) and v24(v119.ChainHealFocus, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				if ((v101 and v13:IsMoving() and v122.AreUnitsBelowHealthPercentage(v86, v85) and v118.SpiritwalkersGrace:IsReady()) or ((4931 - (822 + 692)) < (3617 - 1083))) then
					if (v24(v118.SpiritwalkersGrace) or ((1283 + 1439) <= (461 - (45 + 252)))) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v95 and v122.AreUnitsBelowHealthPercentage(v72, v71) and v118.HealingStreamTotem:IsReady()) or ((2383 + 25) < (726 + 1383))) then
					if (v24(v118.HealingStreamTotem) or ((80 - 47) == (1888 - (114 + 319)))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v141 == (3 - 0)) or ((567 - 124) >= (2560 + 1455))) then
				if (((5037 - 1655) > (347 - 181)) and v122.AreUnitsBelowHealthPercentage(v61, v60) and v118.Downpour:IsReady()) then
					if ((v62 == "Player") or ((2243 - (556 + 1407)) == (4265 - (741 + 465)))) then
						if (((2346 - (170 + 295)) > (682 + 611)) and v24(v119.DownpourPlayer, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					elseif (((2165 + 192) == (5803 - 3446)) and (v62 == "Friendly under Cursor")) then
						if (((102 + 21) == (79 + 44)) and v16:Exists() and not v13:CanAttack(v16)) then
							if (v24(v119.DownpourCursor, not v15:IsInRange(23 + 17), v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2286 - (957 + 273)) >= (908 + 2484))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v62 == "Confirmation") or ((433 + 648) < (4096 - 3021))) then
						if (v24(v118.Downpour, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2764 - 1715) >= (13537 - 9105))) then
							return "downpour healingaoe";
						end
					end
				end
				if ((v92 and v122.AreUnitsBelowHealthPercentage(v59, v58) and v118.CloudburstTotem:IsReady()) or ((23609 - 18841) <= (2626 - (389 + 1391)))) then
					if (v24(v118.CloudburstTotem) or ((2107 + 1251) <= (148 + 1272))) then
						return "clouburst_totem healingaoe";
					end
				end
				if ((v103 and v122.AreUnitsBelowHealthPercentage(v105, v104) and v118.Wellspring:IsReady()) or ((8512 - 4773) <= (3956 - (783 + 168)))) then
					if (v24(v118.Wellspring, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((5567 - 3908) >= (2100 + 34))) then
						return "wellspring healingaoe";
					end
				end
				v141 = 315 - (309 + 2);
			end
		end
	end
	local function v130()
		if ((v118.EarthShield:IsReady() and v94 and v17:Exists() and not v17:IsDeadOrGhost() and v17:IsInRange(122 - 82) and (v122.UnitGroupRole(v17) == "TANK") and v17:BuffDown(v118.EarthShield) and (v122.FriendlyUnitsWithBuffCount(v118.EarthShieldBuff, true) <= (1213 - (1090 + 122)))) or ((1057 + 2203) < (7909 - 5554))) then
			if (v24(v119.EarthShieldFocus) or ((458 + 211) == (5341 - (628 + 490)))) then
				return "earth_shield_tank healingst";
			end
		end
		if ((v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((304 + 1388) < (1455 - 867))) then
			if ((v17:HealthPercentage() <= v80) or ((21922 - 17125) < (4425 - (431 + 343)))) then
				if (v24(v119.RiptideFocus) or ((8435 - 4258) > (14030 - 9180))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((317 + 83) > (143 + 968))) then
			if (((4746 - (556 + 1139)) > (1020 - (6 + 9))) and (v17:HealthPercentage() <= v81) and (v122.UnitGroupRole(v17) == "TANK")) then
				if (((677 + 3016) <= (2245 + 2137)) and v24(v119.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v100 and v13:BuffDown(v118.UnleashLife) and v118.Riptide:IsReady() and v17:BuffDown(v118.Riptide)) or ((3451 - (28 + 141)) > (1589 + 2511))) then
			if ((v17:HealthPercentage() <= v80) or (v17:HealthPercentage() <= v80) or ((4418 - 838) < (2015 + 829))) then
				if (((1406 - (486 + 831)) < (11684 - 7194)) and v24(v119.RiptideFocus)) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v118.ElementalOrbit:IsAvailable() and v13:BuffDown(v118.EarthShieldBuff)) or ((17543 - 12560) < (342 + 1466))) then
			if (((12107 - 8278) > (5032 - (668 + 595))) and v24(v118.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((1337 + 148) <= (586 + 2318)) and v118.ElementalOrbit:IsAvailable() and v13:BuffUp(v118.EarthShieldBuff)) then
			if (((11641 - 7372) == (4559 - (23 + 267))) and v122.IsSoloMode()) then
				if (((2331 - (1129 + 815)) <= (3169 - (371 + 16))) and v118.LightningShield:IsReady() and v13:BuffDown(v118.LightningShield)) then
					if (v24(v118.LightningShield) or ((3649 - (1326 + 424)) <= (1736 - 819))) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v118.WaterShield:IsReady() and v13:BuffDown(v118.WaterShield)) or ((15757 - 11445) <= (994 - (88 + 30)))) then
				if (((3003 - (720 + 51)) <= (5774 - 3178)) and v24(v118.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if (((3871 - (421 + 1355)) < (6080 - 2394)) and v96 and v118.HealingSurge:IsReady()) then
			if ((v17:HealthPercentage() <= v73) or ((784 + 811) >= (5557 - (286 + 797)))) then
				if (v24(v119.HealingSurgeFocus, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((16885 - 12266) < (4773 - 1891))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v98 and v118.HealingWave:IsReady()) or ((733 - (397 + 42)) >= (1509 + 3322))) then
			if (((2829 - (24 + 776)) <= (4750 - 1666)) and (v17:HealthPercentage() <= v76)) then
				if (v24(v119.HealingWaveFocus, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((2822 - (222 + 563)) == (5332 - 2912))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v131()
		local v142 = 0 + 0;
		while true do
			if (((4648 - (23 + 167)) > (5702 - (690 + 1108))) and (v142 == (1 + 0))) then
				if (((360 + 76) >= (971 - (40 + 808))) and v118.Stormkeeper:IsReady()) then
					if (((83 + 417) < (6944 - 5128)) and v24(v118.Stormkeeper)) then
						return "stormkeeper damage";
					end
				end
				if (((3416 + 158) == (1891 + 1683)) and (#v13:GetEnemiesInRange(22 + 18) < (574 - (47 + 524)))) then
					if (((144 + 77) < (1066 - 676)) and v118.LightningBolt:IsReady()) then
						if (v24(v118.LightningBolt, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((3308 - 1095) <= (3240 - 1819))) then
							return "lightning_bolt damage";
						end
					end
				elseif (((4784 - (1165 + 561)) < (145 + 4715)) and v118.ChainLightning:IsReady()) then
					if (v24(v118.ChainLightning, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((4013 - 2717) >= (1697 + 2749))) then
						return "chain_lightning damage";
					end
				end
				break;
			end
			if ((v142 == (479 - (341 + 138))) or ((377 + 1016) > (9263 - 4774))) then
				if (v118.FlameShock:IsReady() or ((4750 - (89 + 237)) < (86 - 59))) then
					local v241 = 0 - 0;
					while true do
						if ((v241 == (881 - (581 + 300))) or ((3217 - (855 + 365)) > (9061 - 5246))) then
							if (((1132 + 2333) > (3148 - (1030 + 205))) and v122.CastCycle(v118.FlameShock, v13:GetEnemiesInRange(38 + 2), v125, not v15:IsSpellInRange(v118.FlameShock), nil, nil, nil, nil)) then
								return "flame_shock_cycle damage";
							end
							if (((682 + 51) < (2105 - (156 + 130))) and v24(v118.FlameShock, not v15:IsSpellInRange(v118.FlameShock))) then
								return "flame_shock damage";
							end
							break;
						end
					end
				end
				if (v118.LavaBurst:IsReady() or ((9986 - 5591) == (8014 - 3259))) then
					if (v24(v118.LavaBurst, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff)) or ((7768 - 3975) < (625 + 1744))) then
						return "lava_burst damage";
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v132()
		v50 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
		v51 = EpicSettings.Settings['AncestralProtectionTotemHP'];
		v52 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
		v56 = EpicSettings.Settings['ChainHealGroup'];
		v57 = EpicSettings.Settings['ChainHealHP'];
		v44 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['DispelDebuffs'];
		v60 = EpicSettings.Settings['DownpourGroup'];
		v61 = EpicSettings.Settings['DownpourHP'];
		v62 = EpicSettings.Settings['DownpourUsage'];
		v65 = EpicSettings.Settings['EarthenWallTotemGroup'];
		v66 = EpicSettings.Settings['EarthenWallTotemHP'];
		v67 = EpicSettings.Settings['EarthenWallTotemUsage'];
		v42 = EpicSettings.Settings['HandleCharredBrambles'];
		v41 = EpicSettings.Settings['HandleCharredTreant'];
		v39 = EpicSettings.Settings['HealingPotionHP'];
		v40 = EpicSettings.Settings['HealingPotionName'];
		v68 = EpicSettings.Settings['HealingRainGroup'];
		v69 = EpicSettings.Settings['HealingRainHP'];
		v70 = EpicSettings.Settings['HealingRainUsage'];
		v71 = EpicSettings.Settings['HealingStreamTotemGroup'];
		v72 = EpicSettings.Settings['HealingStreamTotemHP'];
		v73 = EpicSettings.Settings['HealingSurgeHP'];
		v74 = EpicSettings.Settings['HealingTideTotemGroup'];
		v75 = EpicSettings.Settings['HealingTideTotemHP'];
		v76 = EpicSettings.Settings['HealingWaveHP'];
		v37 = EpicSettings.Settings['healthstoneHP'];
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v47 = EpicSettings.Settings['InterruptThreshold'];
		v45 = EpicSettings.Settings['InterruptWithStun'];
		v80 = EpicSettings.Settings['RiptideHP'];
		v81 = EpicSettings.Settings['RiptideTankHP'];
		v82 = EpicSettings.Settings['SpiritLinkTotemGroup'];
		v83 = EpicSettings.Settings['SpiritLinkTotemHP'];
		v84 = EpicSettings.Settings['SpiritLinkTotemUsage'];
		v85 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
		v86 = EpicSettings.Settings['SpiritwalkersGraceHP'];
		v87 = EpicSettings.Settings['UnleashLifeHP'];
		v91 = EpicSettings.Settings['UseChainHeal'];
		v92 = EpicSettings.Settings['UseCloudburstTotem'];
		v94 = EpicSettings.Settings['UseEarthShield'];
		v38 = EpicSettings.Settings['UseHealingPotion'];
		v95 = EpicSettings.Settings['UseHealingStreamTotem'];
		v96 = EpicSettings.Settings['UseHealingSurge'];
		v97 = EpicSettings.Settings['UseHealingTideTotem'];
		v98 = EpicSettings.Settings['UseHealingWave'];
		v36 = EpicSettings.Settings['useHealthstone'];
		v100 = EpicSettings.Settings['UseRiptide'];
		v101 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v102 = EpicSettings.Settings['UseUnleashLife'];
		v112 = EpicSettings.Settings['UseTremorTotemWithAfflicted'];
		v113 = EpicSettings.Settings['UsePoisonCleansingTotemWithAfflicted'];
	end
	local function v133()
		local v195 = 69 - (10 + 59);
		while true do
			if ((v195 == (0 + 0)) or ((20112 - 16028) == (1428 - (671 + 492)))) then
				v48 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v49 = EpicSettings.Settings['AncestralGuidanceHP'];
				v53 = EpicSettings.Settings['AscendanceGroup'];
				v54 = EpicSettings.Settings['AscendanceHP'];
				v195 = 1 + 0;
			end
			if (((5573 - (369 + 846)) == (1154 + 3204)) and (v195 == (6 + 0))) then
				v109 = EpicSettings.Settings['fightRemainsCheck'];
				v110 = EpicSettings.Settings['handleAfflicted'];
				v111 = EpicSettings.Settings['HandleIncorporeal'];
				v112 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v195 = 1952 - (1036 + 909);
			end
			if ((v195 == (6 + 1)) or ((5268 - 2130) < (1196 - (11 + 192)))) then
				v113 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v114 = EpicSettings.Settings['usePurgeTarget'];
				break;
			end
			if (((1683 + 1647) > (2498 - (135 + 40))) and ((11 - 6) == v195)) then
				v105 = EpicSettings.Settings['WellspringHP'];
				v106 = EpicSettings.Settings['racialsWithCD'];
				v107 = EpicSettings.Settings['trinketsWithCD'];
				v108 = EpicSettings.Settings['useTrinkets'];
				v195 = 4 + 2;
			end
			if ((v195 == (4 - 2)) or ((5435 - 1809) == (4165 - (50 + 126)))) then
				v64 = EpicSettings.Settings['EarthElementalTankHP'];
				v77 = EpicSettings.Settings['ManaTideTotemMana'];
				v78 = EpicSettings.Settings['PrimordialWaveHP'];
				v79 = EpicSettings.Settings['PrimordialWaveSaveCooldowns'];
				v195 = 8 - 5;
			end
			if (((1 + 2) == v195) or ((2329 - (1233 + 180)) == (3640 - (522 + 447)))) then
				v88 = EpicSettings.Settings['UseAncestralGuidance'];
				v89 = EpicSettings.Settings['UseAscendance'];
				v90 = EpicSettings.Settings['UseAstralShift'];
				v93 = EpicSettings.Settings['UseEarthElemental'];
				v195 = 1425 - (107 + 1314);
			end
			if (((127 + 145) == (828 - 556)) and (v195 == (2 + 2))) then
				v99 = EpicSettings.Settings['UseManaTideTotem'];
				v35 = EpicSettings.Settings['UseRacials'];
				v103 = EpicSettings.Settings['UseWellspring'];
				v104 = EpicSettings.Settings['WellspringGroup'];
				v195 = 9 - 4;
			end
			if (((16811 - 12562) <= (6749 - (716 + 1194))) and (v195 == (1 + 0))) then
				v55 = EpicSettings.Settings['AstralShiftHP'];
				v58 = EpicSettings.Settings['CloudburstTotemGroup'];
				v59 = EpicSettings.Settings['CloudburstTotemHP'];
				v63 = EpicSettings.Settings['EarthElementalHP'];
				v195 = 1 + 1;
			end
		end
	end
	local function v134()
		local v196 = 503 - (74 + 429);
		local v197;
		while true do
			if (((5356 - 2579) < (1586 + 1614)) and (v196 == (0 - 0))) then
				v132();
				v133();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['cds'];
				v196 = 1 + 0;
			end
			if (((292 - 197) < (4838 - 2881)) and (v196 == (436 - (279 + 154)))) then
				if (((1604 - (454 + 324)) < (1351 + 366)) and (v30 or v13:AffectingCombat())) then
					if (((1443 - (12 + 5)) >= (596 + 509)) and v32) then
						if (((7017 - 4263) <= (1249 + 2130)) and v17 and v43) then
							if ((v118.PurifySpirit:IsReady() and v122.DispellableFriendlyUnit()) or ((5020 - (277 + 816)) == (6037 - 4624))) then
								if (v24(v119.PurifySpiritFocus) or ((2337 - (1058 + 125)) <= (148 + 640))) then
									return "purify_spirit dispel";
								end
							end
						end
						if ((v44 and v114) or ((2618 - (815 + 160)) > (14497 - 11118))) then
							if ((v118.Purge:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v122.UnitHasMagicBuff(v15)) or ((6653 - 3850) > (1086 + 3463))) then
								if (v24(v118.Purge, not v15:IsSpellInRange(v118.Purge)) or ((643 - 423) >= (4920 - (41 + 1857)))) then
									return "purge dispel";
								end
							end
						end
					end
					v197 = v127();
					if (((4715 - (1222 + 671)) == (7293 - 4471)) and v197) then
						return v197;
					end
					if (v33 or ((1524 - 463) == (3039 - (229 + 953)))) then
						local v244 = 1774 - (1111 + 663);
						while true do
							if (((4339 - (874 + 705)) > (191 + 1173)) and (v244 == (1 + 0))) then
								v197 = v130();
								if (v197 or ((10188 - 5286) <= (102 + 3493))) then
									return v197;
								end
								break;
							end
							if ((v244 == (679 - (642 + 37))) or ((879 + 2973) == (47 + 246))) then
								v197 = v129();
								if (v197 or ((3913 - 2354) == (5042 - (233 + 221)))) then
									return v197;
								end
								v244 = 2 - 1;
							end
						end
					end
					if (v34 or ((3947 + 537) == (2329 - (718 + 823)))) then
						if (((2875 + 1693) >= (4712 - (266 + 539))) and v122.TargetIsValid()) then
							v197 = v131();
							if (((3527 - 2281) < (4695 - (636 + 589))) and v197) then
								return v197;
							end
						end
					end
				end
				break;
			end
			if (((9656 - 5588) >= (2004 - 1032)) and (v196 == (2 + 0))) then
				if (((180 + 313) < (4908 - (657 + 358))) and (v13:AffectingCombat() or v30)) then
					local v242 = v43 and v118.PurifySpirit:IsReady() and v32;
					if ((v118.EarthShield:IsReady() and v94 and (v122.FriendlyUnitsWithBuffCount(v118.EarthShieldBuff, true) <= (2 - 1))) or ((3355 - 1882) >= (4519 - (1151 + 36)))) then
						local v245 = 0 + 0;
						while true do
							if ((v245 == (0 + 0)) or ((12097 - 8046) <= (2989 - (1552 + 280)))) then
								v29 = v122.FocusUnitRefreshableBuff(v118.EarthShield, 849 - (64 + 770), 28 + 12, "TANK");
								if (((1370 - 766) < (512 + 2369)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (not v17:BuffRefreshable(v118.EarthShield) or (v122.UnitGroupRole(v17) ~= "TANK") or not v94 or ((2143 - (157 + 1086)) == (6758 - 3381))) then
						v29 = v122.FocusUnit(v242, nil, nil, nil);
						if (((19529 - 15070) > (906 - 315)) and v29) then
							return v29;
						end
					end
				end
				v197 = nil;
				if (((4637 - 1239) >= (3214 - (599 + 220))) and not v13:AffectingCombat() and v30) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((4346 - 2163) >= (4755 - (1813 + 118)))) then
						local v246 = 0 + 0;
						local v247;
						while true do
							if (((3153 - (841 + 376)) == (2712 - 776)) and (v246 == (0 + 0))) then
								v247 = v122.DeadFriendlyUnitsCount();
								if ((v247 > (2 - 1)) or ((5691 - (464 + 395)) < (11068 - 6755))) then
									if (((1964 + 2124) > (4711 - (467 + 370))) and v24(v118.AncestralVision, nil, v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (((8951 - 4619) == (3180 + 1152)) and v24(v119.AncestralSpiritMouseover, not v15:IsInRange(137 - 97), v13:BuffDown(v118.SpiritwalkersGraceBuff))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				if (((624 + 3375) >= (6747 - 3847)) and v13:AffectingCombat() and v122.TargetIsValid()) then
					local v243 = 520 - (150 + 370);
					while true do
						if ((v243 == (1283 - (74 + 1208))) or ((6210 - 3685) > (19273 - 15209))) then
							v29 = v122.Interrupt(v118.WindShear, 22 + 8, true);
							if (((4761 - (14 + 376)) == (7581 - 3210)) and v29) then
								return v29;
							end
							v29 = v122.InterruptCursor(v118.WindShear, v119.WindShearMouseover, 20 + 10, true, v16);
							if (v29 or ((234 + 32) > (4756 + 230))) then
								return v29;
							end
							v243 = 5 - 3;
						end
						if (((1498 + 493) >= (1003 - (23 + 55))) and (v243 == (0 - 0))) then
							v117 = v13:GetEnemiesInRange(27 + 13);
							v115 = v10.BossFightRemains(nil, true);
							v116 = v115;
							if (((409 + 46) < (3182 - 1129)) and (v116 == (3496 + 7615))) then
								v116 = v10.FightRemains(v117, false);
							end
							v243 = 902 - (652 + 249);
						end
						if ((v243 == (5 - 3)) or ((2694 - (708 + 1160)) == (13167 - 8316))) then
							v29 = v122.InterruptWithStunCursor(v118.CapacitorTotem, v119.CapacitorTotemCursor, 54 - 24, nil, v16);
							if (((210 - (10 + 17)) == (42 + 141)) and v29) then
								return v29;
							end
							if (((2891 - (1400 + 332)) <= (3429 - 1641)) and v111) then
								v29 = v122.HandleIncorporeal(v118.Hex, v119.HexMouseOver, 1938 - (242 + 1666), true);
								if (v29 or ((1501 + 2006) > (1583 + 2735))) then
									return v29;
								end
							end
							if (v110 or ((2621 + 454) <= (3905 - (850 + 90)))) then
								v29 = v122.HandleAfflicted(v118.PurifySpirit, v119.PurifySpiritMouseover, 52 - 22);
								if (((2755 - (360 + 1030)) <= (1780 + 231)) and v29) then
									return v29;
								end
								if (v112 or ((7834 - 5058) > (4918 - 1343))) then
									local v249 = 1661 - (909 + 752);
									while true do
										if ((v249 == (1223 - (109 + 1114))) or ((4675 - 2121) == (1871 + 2933))) then
											v29 = v122.HandleAfflicted(v118.TremorTotem, v118.TremorTotem, 272 - (6 + 236));
											if (((1624 + 953) == (2075 + 502)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if (v113 or ((13 - 7) >= (3298 - 1409))) then
									local v250 = 1133 - (1076 + 57);
									while true do
										if (((84 + 422) <= (2581 - (579 + 110))) and ((0 + 0) == v250)) then
											v29 = v122.HandleAfflicted(v118.PoisonCleansingTotem, v118.PoisonCleansingTotem, 27 + 3);
											if (v29 or ((1066 + 942) > (2625 - (174 + 233)))) then
												return v29;
											end
											break;
										end
									end
								end
							end
							v243 = 8 - 5;
						end
						if (((664 - 285) <= (1845 + 2302)) and (v243 == (1177 - (663 + 511)))) then
							v197 = v126();
							if (v197 or ((4028 + 486) <= (220 + 789))) then
								return v197;
							end
							if ((v116 > v109) or ((10778 - 7282) == (722 + 470))) then
								local v248 = 0 - 0;
								while true do
									if ((v248 == (0 - 0)) or ((100 + 108) == (5758 - 2799))) then
										v197 = v128();
										if (((3049 + 1228) >= (121 + 1192)) and v197) then
											return v197;
										end
										break;
									end
								end
							end
							if (((3309 - (478 + 244)) < (3691 - (440 + 77))) and (not v79 or v31)) then
								if (((v17:HealthPercentage() < v78) and v17:BuffDown(v118.Riptide)) or ((1874 + 2246) <= (8044 - 5846))) then
									if (v118.PrimordialWave:IsReady() or ((3152 - (655 + 901)) == (160 + 698))) then
										if (((2466 + 754) == (2175 + 1045)) and v24(v119.PrimordialWaveFocus)) then
											return "primordial_wave main";
										end
									end
								end
							end
							break;
						end
					end
				end
				v196 = 11 - 8;
			end
			if ((v196 == (1446 - (695 + 750))) or ((4787 - 3385) > (5586 - 1966))) then
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (((10351 - 7777) == (2925 - (285 + 66))) and v13:IsDeadOrGhost()) then
					return;
				end
				v196 = 4 - 2;
			end
		end
	end
	local function v135()
		local v198 = 1310 - (682 + 628);
		while true do
			if (((290 + 1508) < (3056 - (176 + 123))) and (v198 == (0 + 0))) then
				v124();
				v22.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(192 + 72, v134, v135);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

