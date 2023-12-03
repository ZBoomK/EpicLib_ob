local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5052 - (927 + 834)) > (8318 - 6651)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Priest_Holy.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Focus;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = v9.Utils;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Press;
	local v23 = v9.PressCursor;
	local v24 = v9.PressFocus;
	local v25 = v9.PressMouseover;
	local v26 = v9.PressPlayer;
	local v27 = v20.Bind;
	local v28 = v20.Macro;
	local v29 = v20.Commons.Everyone.num;
	local v30 = v20.Commons.Everyone.bool;
	local v31 = string.format;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = 432 - (317 + 115);
	local v37 = false;
	local v38 = false;
	local v39 = 0 - 0;
	local v40 = false;
	local v41 = false;
	local v42 = 0 + 0;
	local v43 = 0 + 0;
	local v44 = false;
	local v45 = 826 - (802 + 24);
	local v46 = 0 - 0;
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
	local v97 = 0 - 0;
	local v98 = v17.Priest.Holy;
	local v99 = v18.Priest.Holy;
	local v100 = v28.Priest.Holy;
	local v101 = {};
	local v102;
	local v103, v104, v105;
	local v106;
	local v107;
	local v108 = v20.Commons.Everyone;
	local function v109()
		if (v98.ImprovedPurify:IsAvailable() or ((129 + 744) == (1563 + 471))) then
			v108.DispellableDebuffs = v19.MergeTable(v108.DispellableMagicDebuffs, v108.DispellableDiseaseDebuffs);
		else
			v108.DispellableDebuffs = v108.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v109();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v110(v124)
		return v124:DebuffRefreshable(v98.ShadowWordPain) and (v124:TimeToDie() >= (2 + 10));
	end
	local function v111()
		if ((v98.Purify:IsReady() and v35 and v108.DispellableFriendlyUnit()) or ((608 + 2208) < (30 - 19))) then
			if (((12335 - 8636) < (1684 + 3022)) and v22(v100.PurifyFocus)) then
				return "purify dispel";
			end
		end
	end
	local function v112()
		local v125 = 0 + 0;
		while true do
			if (((2183 + 463) >= (637 + 239)) and ((0 + 0) == v125)) then
				if (((2047 - (797 + 636)) <= (15459 - 12275)) and v98.Fade:IsReady() and v93 and (v12:HealthPercentage() <= v94)) then
					if (((4745 - (1427 + 192)) == (1084 + 2042)) and v22(v98.Fade, nil, nil, true)) then
						return "fade defensive";
					end
				end
				if ((v98.DesperatePrayer:IsCastable() and v92 and (v12:HealthPercentage() <= v36)) or ((5077 - 2890) >= (4453 + 501))) then
					if (v22(v98.DesperatePrayer) or ((1757 + 2120) == (3901 - (192 + 134)))) then
						return "desperate_prayer defensive";
					end
				end
				v125 = 1277 - (316 + 960);
			end
			if (((394 + 313) > (488 + 144)) and (v125 == (1 + 0))) then
				if ((v99.Healthstone:IsReady() and v81 and (v12:HealthPercentage() <= v82)) or ((2087 - 1541) >= (3235 - (83 + 468)))) then
					if (((3271 - (1202 + 604)) <= (20077 - 15776)) and v22(v100.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (((2835 - 1131) > (3945 - 2520)) and v88 and (v12:HealthPercentage() <= v90)) then
					if ((v89 == "Refreshing Healing Potion") or ((1012 - (45 + 280)) == (4087 + 147))) then
						if (v99.RefreshingHealingPotion:IsReady() or ((2910 + 420) < (522 + 907))) then
							if (((635 + 512) >= (59 + 276)) and v22(v100.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v126 = 0 - 0;
		while true do
			if (((5346 - (340 + 1571)) > (828 + 1269)) and ((1773 - (1733 + 39)) == v126)) then
				v102 = v108.HandleBottomTrinket(v101, v34 and v12:BuffUp(v98.PowerInfusionBuff), 109 - 69, nil);
				if (v102 or ((4804 - (125 + 909)) >= (5989 - (1096 + 852)))) then
					return v102;
				end
				break;
			end
			if ((v126 == (0 + 0)) or ((5413 - 1622) <= (1563 + 48))) then
				v102 = v108.HandleTopTrinket(v101, v34 and v12:BuffUp(v98.PowerInfusionBuff), 552 - (409 + 103), nil);
				if (v102 or ((4814 - (46 + 190)) <= (2103 - (51 + 44)))) then
					return v102;
				end
				v126 = 1 + 0;
			end
		end
	end
	local function v114()
		if (((2442 - (1114 + 203)) <= (2802 - (228 + 498))) and ((GetTime() - v97) > v39)) then
			local v137 = 0 + 0;
			while true do
				if ((v137 == (0 + 0)) or ((1406 - (174 + 489)) >= (11460 - 7061))) then
					if (((3060 - (830 + 1075)) < (2197 - (303 + 221))) and v98.BodyandSoul:IsAvailable() and v98.PowerWordShield:IsReady() and v38 and v12:BuffDown(v98.AngelicFeatherBuff) and v12:BuffDown(v98.BodyandSoulBuff)) then
						if (v22(v100.PowerWordShieldPlayer) or ((3593 - (231 + 1038)) <= (482 + 96))) then
							return "power_word_shield_player move";
						end
					end
					if (((4929 - (171 + 991)) == (15524 - 11757)) and v98.AngelicFeather:IsReady() and v37 and v12:BuffDown(v98.AngelicFeatherBuff) and v12:BuffDown(v98.BodyandSoulBuff) and v12:BuffDown(v98.AngelicFeatherBuff)) then
						if (((10979 - 6890) == (10203 - 6114)) and v22(v100.AngelicFeatherPlayer)) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v115()
		if (((3568 + 890) >= (5867 - 4193)) and (v78 == "Anyone")) then
			if (((2803 - 1831) <= (2285 - 867)) and v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79)) then
				if (v22(v100.GuardianSpiritFocus, nil, nil, true) or ((15264 - 10326) < (6010 - (111 + 1137)))) then
					return "guardian_spirit heal_cooldown";
				end
			end
		elseif ((v78 == "Tank Only") or ((2662 - (91 + 67)) > (12690 - 8426))) then
			if (((538 + 1615) == (2676 - (423 + 100))) and v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79) and (Commons.UnitGroupRole(v14) == "TANK")) then
				if (v22(v100.GuardianSpiritFocus, nil, nil, true) or ((4 + 503) >= (7173 - 4582))) then
					return "guardian_spirit heal_cooldown";
				end
			end
		elseif (((2336 + 2145) == (5252 - (326 + 445))) and (v78 == "Tank and Self")) then
			if ((v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79) and ((Commons.UnitGroupRole(v14) == "TANK") or (Commons.UnitGroupRole(v14) == "HEALER"))) or ((10159 - 7831) < (1543 - 850))) then
				if (((10102 - 5774) == (5039 - (530 + 181))) and v22(v100.GuardianSpiritFocus, nil, nil, true)) then
					return "guardian_spirit heal_cooldown";
				end
			end
		end
		if (((2469 - (614 + 267)) >= (1364 - (19 + 13))) and v98.HolyWordSalvation:IsReady() and v69 and v108.AreUnitsBelowHealthPercentage(v70, v71)) then
			if (v22(v98.HolyWordSalvation, nil, true) or ((6793 - 2619) > (9899 - 5651))) then
				return "holy_word_salvation heal_cooldown";
			end
		end
		if ((v98.DivineHymn:IsReady() and v51 and v108.AreUnitsBelowHealthPercentage(v52, v53)) or ((13100 - 8514) <= (22 + 60))) then
			if (((6793 - 2930) == (8011 - 4148)) and v22(v98.DivineHymn, nil, true)) then
				return "divine_hymn heal_cooldown";
			end
		end
	end
	local function v116()
		local v127 = 1812 - (1293 + 519);
		while true do
			if ((v127 == (1 - 0)) or ((736 - 454) <= (80 - 38))) then
				if (((19874 - 15265) >= (1804 - 1038)) and v98.HolyWordSerenity:IsReady() and v67 and (v14:HealthPercentage() <= v68)) then
					if (v22(v100.HolyWordSerenityFocus) or ((611 + 541) == (508 + 1980))) then
						return "holy_word_serenity heal";
					end
				end
				if (((7950 - 4528) > (775 + 2575)) and v108.AreUnitsBelowHealthPercentage(v42, v43) and v41) then
					if (((292 + 585) > (235 + 141)) and v98.Apotheosis:IsReady() and v34 and v12:AffectingCombat() and ((v98.HolyWordSanctify:CooldownDown() and v98.HolyWordSerenity:CooldownDown()) or (v98.HolyWordSerenity:CooldownDown() and (v14:HealthPercentage() <= v68)) or (v98.HolyWordSanctify:CooldownDown() and v108.AreUnitsBelowHealthPercentage(v73, v74)))) then
						if (v22(v98.Apotheosis) or ((4214 - (709 + 387)) <= (3709 - (673 + 1185)))) then
							return "apotheosis heal";
						end
					end
				end
				if ((v98.CircleofHealing:IsReady() and v44 and v108.AreUnitsBelowHealthPercentage(v45, v46)) or ((478 - 313) >= (11213 - 7721))) then
					if (((6496 - 2547) < (3474 + 1382)) and v22(v100.CircleofHealingFocus)) then
						return "circle_of_healing heal";
					end
				end
				v127 = 2 + 0;
			end
			if ((v127 == (5 - 1)) or ((1051 + 3225) < (6013 - 2997))) then
				if (((9206 - 4516) > (6005 - (446 + 1434))) and v98.Renew:IsReady() and v95 and v14:BuffDown(v98.Renew) and (v14:HealthPercentage() <= v96)) then
					if (v22(v100.RenewFocus, nil, true) or ((1333 - (1040 + 243)) >= (2674 - 1778))) then
						return "renew heal";
					end
				end
				break;
			end
			if ((v127 == (1847 - (559 + 1288))) or ((3645 - (609 + 1322)) >= (3412 - (13 + 441)))) then
				if ((v98.PowerWordLife:IsReady() and v65 and (v14:HealthPercentage() < v66)) or ((5571 - 4080) < (1686 - 1042))) then
					if (((3506 - 2802) < (37 + 950)) and v22(v100.PowerWordLifeFocus)) then
						return "power_word_life heal";
					end
				end
				if (((13503 - 9785) > (677 + 1229)) and v98.PrayerofMending:IsReady() and v63 and v14:BuffRefreshable(v98.PrayerofMending) and (v14:HealthPercentage() <= v64)) then
					if (v22(v100.PrayerofMendingFocus) or ((420 + 538) > (10786 - 7151))) then
						return "prayer_of_mending heal";
					end
				end
				if (((1916 + 1585) <= (8261 - 3769)) and v98.HolyWordSanctify:IsReady() and v72 and v108.AreUnitsBelowHealthPercentage(v73, v74) and v15 and v15:IsAPlayer() and not v12:CanAttack(v15)) then
					if (v22(v100.HolyWordSanctifyCursor) or ((2276 + 1166) < (1418 + 1130))) then
						return "holy_word_sanctify heal";
					end
				end
				v127 = 1 + 0;
			end
			if (((2415 + 460) >= (1433 + 31)) and (v127 == (436 - (153 + 280)))) then
				if ((v98.FlashHeal:IsReady() and v56 and ((v98.Lightweaver:IsAvailable() and (v12:BuffDown(v98.LightweaverBuff) or (v12:BuffStack(v98.LightweaverBuff) < (5 - 3)))) or v12:BuffUp(v98.SurgeofLight) or (not v98.Lightweaver:IsAvailable() and (v12:ManaPercentage() > (36 + 4))))) or ((1895 + 2902) >= (2561 + 2332))) then
					if ((v14:HealthPercentage() <= v57) or (v14:HealthPercentage() <= v62) or ((501 + 50) > (1499 + 569))) then
						if (((3218 - 1104) > (584 + 360)) and v22(v100.FlashHealFocus, nil, v107)) then
							return "flash_heal heal";
						end
					end
				end
				if ((v98.Heal:IsReady() and v61 and (v14:HealthPercentage() <= v62)) or ((2929 - (89 + 578)) >= (2212 + 884))) then
					if (v22(v100.HealFocus, nil, true) or ((4687 - 2432) >= (4586 - (572 + 477)))) then
						return "heal heal";
					end
				end
				if ((v98.SymbolofHope:IsReady() and v40 and v34 and v98.DesperatePrayer:CooldownDown()) or ((518 + 3319) < (784 + 522))) then
					if (((353 + 2597) == (3036 - (84 + 2))) and v22(v98.SymbolofHope, nil, true)) then
						return "symbol_of_hope heal";
					end
				end
				v127 = 6 - 2;
			end
			if ((v127 == (2 + 0)) or ((5565 - (497 + 345)) < (85 + 3213))) then
				if (((193 + 943) >= (1487 - (605 + 728))) and v98.DivineStar:IsReady() and (v14:HealthPercentage() < v55) and v54) then
					if (v22(v100.DivineStarPlayer, not v14:IsInRange(22 + 8)) or ((602 - 331) > (218 + 4530))) then
						return "divine_star heal";
					end
				end
				if (((17524 - 12784) >= (2842 + 310)) and v98.Halo:IsReady() and v58 and v108.AreUnitsBelowHealthPercentage(v59, v60)) then
					if (v22(v100.HaloPlayer, nil, true) or ((7142 - 4564) >= (2560 + 830))) then
						return "halo heal";
					end
				end
				if (((530 - (457 + 32)) <= (705 + 956)) and v98.PrayerofHealing:IsReady() and v75 and v12:BuffUp(v98.PrayerCircleBuff) and v108.AreUnitsBelowHealthPercentage(v76, v77)) then
					if (((2003 - (832 + 570)) < (3354 + 206)) and v22(v100.PrayerofHealingFocus, nil, true)) then
						return "prayer_of_healing heal";
					end
				end
				v127 = 1 + 2;
			end
		end
	end
	local function v117()
		local v128 = 0 - 0;
		while true do
			if (((114 + 121) < (1483 - (588 + 208))) and (v128 == (5 - 3))) then
				if (((6349 - (884 + 916)) > (2413 - 1260)) and v98.ShadowWordDeath:IsCastable() and (v13:HealthPercentage() <= (12 + 8))) then
					if (v22(v98.ShadowWordDeath, not v13:IsSpellInRange(v98.ShadowWordDeath)) or ((5327 - (232 + 421)) < (6561 - (1569 + 320)))) then
						return "shadow_word_death damage";
					end
				end
				if (((900 + 2768) < (867 + 3694)) and v98.ShadowWordDeath:IsCastable() and v15 and (v15:HealthPercentage() <= (67 - 47))) then
					if (v22(v100.ShadowWordDeathMouseover, not v15:IsSpellInRange(v98.ShadowWordDeath)) or ((1060 - (316 + 289)) == (9436 - 5831))) then
						return "shadow_word_death_mouseover damage";
					end
				end
				if ((v98.DivineStar:IsReady() and not v13:IsFacingBlacklisted()) or ((123 + 2540) == (4765 - (666 + 787)))) then
					if (((4702 - (360 + 65)) <= (4183 + 292)) and v22(v100.DivineStarPlayer, not v13:IsInRange(284 - (79 + 175)))) then
						return "divine_star damage";
					end
				end
				v128 = 4 - 1;
			end
			if ((v128 == (4 + 1)) or ((2666 - 1796) == (2289 - 1100))) then
				if (((2452 - (503 + 396)) <= (3314 - (92 + 89))) and v98.Mindgames:IsReady()) then
					if (v22(v98.Mindgames, not v13:IsInRange(77 - 37), true) or ((1148 + 1089) >= (2078 + 1433))) then
						return "mindgames damage";
					end
				end
				if ((v98.HolyNova:IsReady() and (v104 > (15 - 11))) or ((182 + 1142) > (6885 - 3865))) then
					if (v22(v98.HolyNova) or ((2611 + 381) == (899 + 982))) then
						return "holy_nova_aoe damage";
					end
				end
				if (((9459 - 6353) > (191 + 1335)) and v12:IsMoving()) then
					local v174 = 0 - 0;
					while true do
						if (((4267 - (485 + 759)) < (8954 - 5084)) and (v174 == (1189 - (442 + 747)))) then
							v102 = v114();
							if (((1278 - (832 + 303)) > (1020 - (88 + 858))) and v102) then
								return v102;
							end
							break;
						end
					end
				end
				v128 = 2 + 4;
			end
			if (((15 + 3) < (87 + 2025)) and (v128 == (790 - (766 + 23)))) then
				if (((5415 - 4318) <= (2226 - 598)) and v98.Shadowfiend:IsReady() and v34 and (v12:ManaPercentage() <= (250 - 155))) then
					if (((15714 - 11084) == (5703 - (1036 + 37))) and v22(v98.Shadowfiend)) then
						return "shadowfiend damage";
					end
				end
				if (((2510 + 1030) > (5224 - 2541)) and v98.ArcaneTorrent:IsReady() and v84 and v34 and (v12:ManaPercentage() <= (75 + 20))) then
					if (((6274 - (641 + 839)) >= (4188 - (910 + 3))) and v22(v98.ArcaneTorrent)) then
						return "arcane_torrent damage";
					end
				end
				if (((3782 - 2298) == (3168 - (1466 + 218))) and v85 and v34 and v12:BuffUp(v98.PowerInfusionBuff)) then
					v102 = v113();
					if (((659 + 773) < (4703 - (556 + 592))) and v102) then
						return v102;
					end
				end
				v128 = 1 + 1;
			end
			if ((v128 == (812 - (329 + 479))) or ((1919 - (174 + 680)) > (12294 - 8716))) then
				if ((v108.AreUnitsBelowHealthPercentage(v42, v43) and v41) or ((9938 - 5143) < (1005 + 402))) then
					if (((2592 - (396 + 343)) < (426 + 4387)) and v98.Apotheosis:IsReady() and v34 and v12:AffectingCombat() and v98.HolyWordSanctify:CooldownDown() and v98.HolyWordSerenity:CooldownDown() and (v98.HolyWordChastise:CooldownRemains() > ((v12:GCD() + (1477.15 - (29 + 1448))) * (1392 - (135 + 1254)))) and (not v98.HolyNova:IsAvailable() or (v104 < (18 - 13)))) then
						if (v22(v98.Apotheosis) or ((13171 - 10350) < (1621 + 810))) then
							return "apotheosis damage";
						end
					end
				end
				if ((v98.HolyFire:IsReady() and (not v98.HolyNova:IsAvailable() or (v104 < (1532 - (389 + 1138))))) or ((3448 - (102 + 472)) < (2059 + 122))) then
					if (v22(v98.HolyFire, not v13:IsSpellInRange(v98.HolyFire), v106) or ((1492 + 1197) <= (320 + 23))) then
						return "holy_fire damage";
					end
				end
				if ((v98.EmpyrealBlaze:IsReady() and v98.HolyFire:CooldownDown() and (not v98.HolyNova:IsAvailable() or (v104 < (1550 - (320 + 1225))))) or ((3326 - 1457) == (1230 + 779))) then
					if (v22(v98.EmpyrealBlaze, not v13:IsSpellInRange(v98.HolyFire)) or ((5010 - (157 + 1307)) < (4181 - (821 + 1038)))) then
						return "empyreal_blaze damage";
					end
				end
				v128 = 12 - 7;
			end
			if ((v128 == (1 + 5)) or ((3697 - 1615) == (1776 + 2997))) then
				if (((8040 - 4796) > (2081 - (834 + 192))) and v98.ShadowWordPain:IsReady()) then
					if (v108.CastCycle(v98.ShadowWordPain, v105, v110, not v13:IsSpellInRange(v98.ShadowWordPain), nil, nil, v100.ShadowWordPainMouseover) or ((211 + 3102) <= (457 + 1321))) then
						return "shadow_word_pain_cycle damage";
					end
				end
				if ((v98.HolyNova:IsReady() and (v104 >= (1 + 1))) or ((2201 - 780) >= (2408 - (300 + 4)))) then
					if (((484 + 1328) <= (8504 - 5255)) and v22(v98.HolyNova)) then
						return "holy_nova damage";
					end
				end
				if (((1985 - (112 + 250)) <= (781 + 1176)) and v98.Smite:IsReady()) then
					if (((11052 - 6640) == (2528 + 1884)) and v22(v98.Smite, not v13:IsSpellInRange(v98.Smite), true)) then
						return "smite damage";
					end
				end
				v128 = 4 + 3;
			end
			if (((1309 + 441) >= (418 + 424)) and (v128 == (3 + 0))) then
				if (((5786 - (1001 + 413)) > (4125 - 2275)) and v98.Halo:IsReady() and v58) then
					if (((1114 - (244 + 638)) < (1514 - (627 + 66))) and v22(v100.HaloPlayer, not v13:IsInRange(89 - 59), true)) then
						return "halo damage";
					end
				end
				if (((1120 - (512 + 90)) < (2808 - (1665 + 241))) and v98.HolyNova:IsReady() and (v12:BuffStack(v98.RhapsodyBuff) == (737 - (373 + 344)))) then
					if (((1351 + 1643) > (228 + 630)) and v22(v98.HolyNova)) then
						return "holy_nova_rhapsody damage";
					end
				end
				if ((v98.HolyWordChastise:IsReady() and (not v98.HolyNova:IsAvailable() or (v104 < (13 - 8)))) or ((6354 - 2599) <= (2014 - (35 + 1064)))) then
					if (((2872 + 1074) > (8007 - 4264)) and v22(v98.HolyWordChastise, not v13:IsSpellInRange(v98.HolyWordChastise))) then
						return "holy_word_chastise damage";
					end
				end
				v128 = 1 + 3;
			end
			if ((v128 == (1243 - (298 + 938))) or ((2594 - (233 + 1026)) >= (4972 - (636 + 1030)))) then
				if (((2477 + 2367) > (2201 + 52)) and v98.ShadowWordPain:IsReady()) then
					if (((135 + 317) == (31 + 421)) and v22(v98.ShadowWordPain, not v13:IsSpellInRange(v98.ShadowWordPain))) then
						return "shadow_word_pain_movement damage";
					end
				end
				break;
			end
			if ((v128 == (221 - (55 + 166))) or ((884 + 3673) < (210 + 1877))) then
				v102 = v108.InterruptWithStun(v98.PsychicScream, 30 - 22);
				if (((4171 - (36 + 261)) == (6774 - 2900)) and v102) then
					return v102;
				end
				if ((v98.DispelMagic:IsReady() and v35 and v83 and not v12:IsCasting() and not v12:IsChanneling() and v108.UnitHasMagicBuff(v13)) or ((3306 - (34 + 1334)) > (1898 + 3037))) then
					if (v22(v98.DispelMagic, not v13:IsSpellInRange(v98.DispelMagic)) or ((3307 + 948) < (4706 - (1035 + 248)))) then
						return "dispel_magic damage";
					end
				end
				v128 = 22 - (20 + 1);
			end
		end
	end
	local function v118()
		local v129 = 0 + 0;
		while true do
			if (((1773 - (134 + 185)) <= (3624 - (549 + 584))) and (v129 == (685 - (314 + 371)))) then
				v102 = v112();
				if (v102 or ((14270 - 10113) <= (3771 - (478 + 490)))) then
					return v102;
				end
				v129 = 1 + 0;
			end
			if (((6025 - (786 + 386)) >= (9658 - 6676)) and (v129 == (1381 - (1055 + 324)))) then
				if (((5474 - (1093 + 247)) > (2984 + 373)) and v108.TargetIsValid()) then
					v102 = v117();
					if (v102 or ((360 + 3057) < (10060 - 7526))) then
						return v102;
					end
				elseif (v12:IsMoving() or ((9237 - 6515) <= (466 - 302))) then
					local v177 = 0 - 0;
					while true do
						if ((v177 == (0 + 0)) or ((9276 - 6868) < (7269 - 5160))) then
							v102 = v114();
							if (v102 or ((25 + 8) == (3721 - 2266))) then
								return v102;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v129 == (689 - (364 + 324))) or ((1214 - 771) >= (9634 - 5619))) then
				if (((1121 + 2261) > (694 - 528)) and v86) then
					local v175 = 0 - 0;
					while true do
						if ((v175 == (8 - 5)) or ((1548 - (1249 + 19)) == (2762 + 297))) then
							v102 = v108.HandleAfflicted(v98.FlashHeal, v100.FlashHealMouseover, 155 - 115, true);
							if (((2967 - (686 + 400)) > (1015 + 278)) and v102) then
								return v102;
							end
							break;
						end
						if (((2586 - (73 + 156)) == (12 + 2345)) and (v175 == (813 - (721 + 90)))) then
							v102 = v108.HandleAfflicted(v98.HolyWordSerenity, v100.HolyWordSerenityMouseover, 1 + 39);
							if (((399 - 276) == (593 - (224 + 246))) and v102) then
								return v102;
							end
							v175 = 4 - 1;
						end
						if ((v175 == (0 - 0)) or ((192 + 864) >= (81 + 3311))) then
							v102 = v108.HandleAfflicted(v98.Purify, v100.PurifyMouseover, 30 + 10);
							if (v102 or ((2148 - 1067) < (3577 - 2502))) then
								return v102;
							end
							v175 = 514 - (203 + 310);
						end
						if ((v175 == (1994 - (1238 + 755))) or ((74 + 975) >= (5966 - (709 + 825)))) then
							v102 = v108.HandleAfflicted(v98.PowerWordLife, v100.PowerWordLifeMouseover, 73 - 33);
							if (v102 or ((6945 - 2177) <= (1710 - (196 + 668)))) then
								return v102;
							end
							v175 = 7 - 5;
						end
					end
				end
				if (v14 or ((6955 - 3597) <= (2253 - (171 + 662)))) then
					if (v80 or ((3832 - (4 + 89)) <= (10532 - 7527))) then
						local v178 = 0 + 0;
						while true do
							if ((v178 == (0 - 0)) or ((651 + 1008) >= (3620 - (35 + 1451)))) then
								v102 = v111();
								if (v102 or ((4713 - (28 + 1425)) < (4348 - (941 + 1052)))) then
									return v102;
								end
								break;
							end
						end
					end
					if (v34 or ((642 + 27) == (5737 - (822 + 692)))) then
						local v179 = 0 - 0;
						while true do
							if ((v179 == (0 + 0)) or ((1989 - (45 + 252)) < (582 + 6))) then
								v102 = v115();
								if (v102 or ((1651 + 3146) < (8885 - 5234))) then
									return v102;
								end
								break;
							end
						end
					end
					v102 = v108.HandleChromie(v98.HolyWordSerenity, v100.HolyWordSerenityMouseover, 473 - (114 + 319));
					if (v102 or ((5997 - 1820) > (6214 - 1364))) then
						return v102;
					end
					v102 = v108.HandleChromie(v98.FlashHeal, v100.FlashHealMouseover, 26 + 14, true);
					if (v102 or ((595 - 195) > (2327 - 1216))) then
						return v102;
					end
					if (((5014 - (556 + 1407)) > (2211 - (741 + 465))) and v87) then
						local v180 = 465 - (170 + 295);
						while true do
							if (((1946 + 1747) <= (4025 + 357)) and (v180 == (2 - 1))) then
								v102 = v108.HandleIncorporeal(v98.ShackleUndead, v100.ShackleUndeadMouseover, 25 + 5, true);
								if (v102 or ((2105 + 1177) > (2322 + 1778))) then
									return v102;
								end
								break;
							end
							if ((v180 == (1230 - (957 + 273))) or ((958 + 2622) < (1139 + 1705))) then
								v102 = v108.HandleIncorporeal(v98.DominateMind, v100.DominateMindMouseover, 114 - 84, true);
								if (((234 - 145) < (13714 - 9224)) and v102) then
									return v102;
								end
								v180 = 4 - 3;
							end
						end
					end
					v102 = v116();
					if (v102 or ((6763 - (389 + 1391)) < (1135 + 673))) then
						return v102;
					end
				end
				v129 = 1 + 1;
			end
		end
	end
	local function v119()
		if (((8716 - 4887) > (4720 - (783 + 168))) and v86) then
			local v138 = 0 - 0;
			while true do
				if (((1461 + 24) <= (3215 - (309 + 2))) and (v138 == (0 - 0))) then
					v102 = v108.HandleAfflicted(v98.Purify, v100.PurifyMouseover, 1252 - (1090 + 122));
					if (((1385 + 2884) == (14337 - 10068)) and v102) then
						return v102;
					end
					v138 = 1 + 0;
				end
				if (((1505 - (628 + 490)) <= (499 + 2283)) and (v138 == (2 - 1))) then
					v102 = v108.HandleAfflicted(v98.PowerWordLife, v100.PowerWordLifeMouseover, 182 - 142);
					if (v102 or ((2673 - (431 + 343)) <= (1851 - 934))) then
						return v102;
					end
					v138 = 5 - 3;
				end
				if ((v138 == (2 + 0)) or ((552 + 3760) <= (2571 - (556 + 1139)))) then
					v102 = v108.HandleAfflicted(v98.HolyWordSerenity, v100.HolyWordSerenityMouseover, 55 - (6 + 9));
					if (((409 + 1823) <= (1330 + 1266)) and v102) then
						return v102;
					end
					v138 = 172 - (28 + 141);
				end
				if (((812 + 1283) < (4549 - 863)) and (v138 == (3 + 0))) then
					v102 = v108.HandleAfflicted(v98.FlashHeal, v100.FlashHealMouseover, 1357 - (486 + 831), true);
					if (v102 or ((4150 - 2555) >= (15750 - 11276))) then
						return v102;
					end
					break;
				end
			end
		end
		if (v14 or ((873 + 3746) < (9112 - 6230))) then
			local v139 = 1263 - (668 + 595);
			while true do
				if ((v139 == (0 + 0)) or ((60 + 234) >= (13174 - 8343))) then
					if (((2319 - (23 + 267)) <= (5028 - (1129 + 815))) and v80) then
						v102 = v111();
						if (v102 or ((2424 - (371 + 16)) == (4170 - (1326 + 424)))) then
							return v102;
						end
					end
					if (((8443 - 3985) > (14266 - 10362)) and v32) then
						local v181 = 118 - (88 + 30);
						while true do
							if (((1207 - (720 + 51)) >= (273 - 150)) and (v181 == (1776 - (421 + 1355)))) then
								v102 = v116();
								if (((824 - 324) < (893 + 923)) and v102) then
									return v102;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (((4657 - (286 + 797)) == (13065 - 9491)) and v12:IsMoving()) then
			local v140 = 0 - 0;
			while true do
				if (((660 - (397 + 42)) < (122 + 268)) and (v140 == (800 - (24 + 776)))) then
					v102 = v114();
					if (v102 or ((3409 - 1196) <= (2206 - (222 + 563)))) then
						return v102;
					end
					break;
				end
			end
		end
		if (((6737 - 3679) < (3500 + 1360)) and v13 and v13:Exists() and v13:IsAPlayer() and v13:IsDeadOrGhost() and not v12:CanAttack(v13)) then
			local v141 = 190 - (23 + 167);
			local v142;
			while true do
				if ((v141 == (1798 - (690 + 1108))) or ((468 + 828) >= (3668 + 778))) then
					v142 = v108.DeadFriendlyUnitsCount();
					if ((v142 > (849 - (40 + 808))) or ((230 + 1163) > (17165 - 12676))) then
						if (v22(v98.MassResurrection, nil, true) or ((4229 + 195) < (15 + 12))) then
							return "mass_resurrection";
						end
					elseif (v22(v98.Resurrection, nil, true) or ((1096 + 901) > (4386 - (47 + 524)))) then
						return "resurrection";
					end
					break;
				end
			end
		end
		if (((2249 + 1216) > (5229 - 3316)) and v98.PowerWordFortitude:IsCastable() and v91 and (v12:BuffDown(v98.PowerWordFortitudeBuff, true) or v108.GroupBuffMissing(v98.PowerWordFortitudeBuff))) then
			if (((1095 - 362) < (4148 - 2329)) and v22(v100.PowerWordFortitudePlayer)) then
				return "power_word_fortitude";
			end
		end
	end
	local function v120()
		local v130 = 1726 - (1165 + 561);
		while true do
			if ((v130 == (0 + 0)) or ((13612 - 9217) == (1815 + 2940))) then
				v36 = EpicSettings.Settings['DesperatePrayerHP'] or (479 - (341 + 138));
				v37 = EpicSettings.Settings['UseAngelicFeather'];
				v38 = EpicSettings.Settings['UseBodyAndSoul'];
				v130 = 1 + 0;
			end
			if ((v130 == (1 - 0)) or ((4119 - (89 + 237)) < (7620 - 5251))) then
				v39 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
				v40 = EpicSettings.Settings['UseSymbolOfHope'];
				v41 = EpicSettings.Settings['UseApotheosis'];
				v130 = 883 - (581 + 300);
			end
			if (((1224 - (855 + 365)) == v130) or ((9700 - 5616) == (87 + 178))) then
				v48 = EpicSettings.Settings['PIName1'] or "";
				v49 = EpicSettings.Settings['PIName2'] or "";
				v50 = EpicSettings.Settings['PIName3'] or "";
				v130 = 1240 - (1030 + 205);
			end
			if (((4092 + 266) == (4055 + 303)) and (v130 == (294 - (156 + 130)))) then
				v60 = EpicSettings.Settings['HaloGroup'] or (0 - 0);
				v61 = EpicSettings.Settings['UseHeal'];
				v62 = EpicSettings.Settings['HealHP'] or (0 - 0);
				break;
			end
			if ((v130 == (11 - 5)) or ((827 + 2311) < (580 + 413))) then
				v54 = EpicSettings.Settings['UseDivineStar'];
				v55 = EpicSettings.Settings['DivineStarHP'] or (69 - (10 + 59));
				v56 = EpicSettings.Settings['UseFlashHeal'];
				v130 = 2 + 5;
			end
			if (((16399 - 13069) > (3486 - (671 + 492))) and (v130 == (2 + 0))) then
				v42 = EpicSettings.Settings['ApotheosisHP'] or (1215 - (369 + 846));
				v43 = EpicSettings.Settings['ApotheosisGroup'] or (0 + 0);
				v44 = EpicSettings.Settings['UseCircleOfHealing'];
				v130 = 3 + 0;
			end
			if ((v130 == (1952 - (1036 + 909))) or ((2883 + 743) == (6696 - 2707))) then
				v57 = EpicSettings.Settings['FlashHealHP'] or (203 - (11 + 192));
				v58 = EpicSettings.Settings['UseHalo'];
				v59 = EpicSettings.Settings['HaloHP'] or (0 + 0);
				v130 = 183 - (135 + 40);
			end
			if ((v130 == (11 - 6)) or ((553 + 363) == (5884 - 3213))) then
				v51 = EpicSettings.Settings['UseDivineHymn'];
				v52 = EpicSettings.Settings['DivineHymnHP'] or (0 - 0);
				v53 = EpicSettings.Settings['DivineHymnGroup'] or (176 - (50 + 126));
				v130 = 16 - 10;
			end
			if (((61 + 211) == (1685 - (1233 + 180))) and (v130 == (972 - (522 + 447)))) then
				v45 = EpicSettings.Settings['CircleOfHealingHP'] or (1421 - (107 + 1314));
				v46 = EpicSettings.Settings['CircleOfHealingGroup'] or (0 + 0);
				v47 = EpicSettings.Settings['PowerInfusionUsage'] or "";
				v130 = 11 - 7;
			end
		end
	end
	local function v121()
		local v131 = 0 + 0;
		while true do
			if (((8437 - 4188) <= (19145 - 14306)) and (v131 == (1910 - (716 + 1194)))) then
				v63 = EpicSettings.Settings['UsePrayerOfMending'];
				v64 = EpicSettings.Settings['PrayerOfMendingHP'] or (0 + 0);
				v65 = EpicSettings.Settings['UsePowerWordLife'];
				v66 = EpicSettings.Settings['PowerWordLifeHP'] or (0 + 0);
				v67 = EpicSettings.Settings['UseHolyWordSerenity'];
				v131 = 504 - (74 + 429);
			end
			if (((5356 - 2579) < (1586 + 1614)) and (v131 == (13 - 7))) then
				v93 = EpicSettings.Settings['UseFade'] or (0 + 0);
				v94 = EpicSettings.Settings['FadeHP'] or (0 - 0);
				v95 = EpicSettings.Settings['UseRenew'];
				v96 = EpicSettings.Settings['RenewHP'] or (0 - 0);
				break;
			end
			if (((528 - (279 + 154)) < (2735 - (454 + 324))) and (v131 == (1 + 0))) then
				v68 = EpicSettings.Settings['HolyWordSerenityHP'] or (17 - (12 + 5));
				v69 = EpicSettings.Settings['UseHolyWordSalvation'];
				v70 = EpicSettings.Settings['HolyWordSalvationHP'] or (0 + 0);
				v71 = EpicSettings.Settings['HolyWordSalvationGroup'] or (0 - 0);
				v72 = EpicSettings.Settings['UseHolyWordSanctify'];
				v131 = 1 + 1;
			end
			if (((1919 - (277 + 816)) < (7336 - 5619)) and ((1185 - (1058 + 125)) == v131)) then
				v73 = EpicSettings.Settings['HolyWordSanctifyHP'] or (0 + 0);
				v74 = EpicSettings.Settings['HolyWordSanctifyGroup'] or (975 - (815 + 160));
				v75 = EpicSettings.Settings['UsePrayerOfHealing'];
				v76 = EpicSettings.Settings['PrayerOfHealingHP'] or (0 - 0);
				v77 = EpicSettings.Settings['PrayerOfHealingGroup'] or (0 - 0);
				v131 = 1 + 2;
			end
			if (((4168 - 2742) >= (3003 - (41 + 1857))) and (v131 == (1896 - (1222 + 671)))) then
				v78 = EpicSettings.Settings['GuardianSpiritUsage'] or "";
				v79 = EpicSettings.Settings['GuardianSpiritHP'] or (0 - 0);
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['UseHealthstone'];
				v82 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v131 = 1186 - (229 + 953);
			end
			if (((4528 - (1111 + 663)) <= (4958 - (874 + 705))) and (v131 == (1 + 4))) then
				v88 = EpicSettings.Settings['UseHealingPotion'];
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v90 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v91 = EpicSettings.Settings['UsePowerWordFortitude'];
				v92 = EpicSettings.Settings['UseDesperatePrayer'];
				v131 = 12 - 6;
			end
			if ((v131 == (1 + 3)) or ((4606 - (642 + 37)) == (323 + 1090))) then
				v83 = EpicSettings.Settings['DispelBuffs'];
				v84 = EpicSettings.Settings['UseRacials'];
				v85 = EpicSettings.Settings['UseTrinkets'];
				v86 = EpicSettings.Settings['HandleAfflicted'];
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				v131 = 1 + 4;
			end
		end
	end
	local function v122()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (454 - (233 + 221))) or ((2668 - 1514) <= (694 + 94))) then
				v120();
				v121();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v132 = 1542 - (718 + 823);
			end
			if ((v132 == (1 + 0)) or ((2448 - (266 + 539)) > (9566 - 6187))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v12:IsDeadOrGhost() or ((4028 - (636 + 589)) > (10797 - 6248))) then
					return;
				end
				if (v12:IsMounted() or ((453 - 233) >= (2395 + 627))) then
					return;
				end
				v132 = 1 + 1;
			end
			if (((3837 - (657 + 358)) == (7471 - 4649)) and (v132 == (6 - 3))) then
				if (v33 or ((2248 - (1151 + 36)) == (1794 + 63))) then
					v104 = #v103;
				else
					v104 = 1 + 0;
				end
				v106 = v12:BuffDown(v98.EmpyrealBlazeBuff);
				v107 = v12:BuffDown(v98.SurgeofLight);
				if (((8242 - 5482) > (3196 - (1552 + 280))) and not v12:IsChanneling()) then
					if (v12:AffectingCombat() or ((5736 - (64 + 770)) <= (2441 + 1154))) then
						local v182 = 0 - 0;
						while true do
							if (((0 + 0) == v182) or ((5095 - (157 + 1086)) == (586 - 293))) then
								v102 = v118();
								if (v102 or ((6827 - 5268) == (7037 - 2449))) then
									return v102;
								end
								break;
							end
						end
					elseif (v32 or ((6119 - 1635) == (1607 - (599 + 220)))) then
						local v184 = 0 - 0;
						while true do
							if (((6499 - (1813 + 118)) >= (2856 + 1051)) and (v184 == (1217 - (841 + 376)))) then
								v102 = v119();
								if (((1745 - 499) < (807 + 2663)) and v102) then
									return v102;
								end
								v184 = 2 - 1;
							end
							if (((4927 - (464 + 395)) >= (2494 - 1522)) and ((1 + 0) == v184)) then
								v102 = v117();
								if (((1330 - (467 + 370)) < (8044 - 4151)) and v102) then
									return v102;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v132 == (2 + 0)) or ((5049 - 3576) >= (520 + 2812))) then
				if (not v12:IsMoving() or ((9424 - 5373) <= (1677 - (150 + 370)))) then
					v97 = GetTime();
				end
				if (((1886 - (74 + 1208)) < (7085 - 4204)) and (v12:AffectingCombat() or v80)) then
					local v176 = v80 and v98.Purify:IsReady() and v35;
					if ((v108.IsTankBelowHealthPercentage(v79) and v98.GuardianSpirit:IsReady() and ((v78 == "Tank Only") or (v78 == "Tank and Self"))) or ((4268 - 3368) == (2403 + 974))) then
						local v183 = 390 - (14 + 376);
						while true do
							if (((7733 - 3274) > (383 + 208)) and (v183 == (0 + 0))) then
								v102 = v108.FocusUnit(v176, nil, nil, "TANK", 20 + 0);
								if (((9956 - 6558) >= (1802 + 593)) and v102) then
									return v102;
								end
								break;
							end
						end
					elseif (((v12:HealthPercentage() < v79) and v98.GuardianSpirit:IsReady() and (v78 == "Tank and Self")) or ((2261 - (23 + 55)) >= (6692 - 3868))) then
						local v185 = 0 + 0;
						while true do
							if (((1739 + 197) == (3001 - 1065)) and (v185 == (0 + 0))) then
								v102 = v108.FocusUnit(v176, nil, nil, "HEALER", 921 - (652 + 249));
								if (v102 or ((12931 - 8099) < (6181 - (708 + 1160)))) then
									return v102;
								end
								break;
							end
						end
					else
						local v186 = 0 - 0;
						while true do
							if (((7453 - 3365) > (3901 - (10 + 17))) and (v186 == (0 + 0))) then
								v102 = v108.FocusUnit(v176, nil, nil, nil, 1752 - (1400 + 332));
								if (((8308 - 3976) == (6240 - (242 + 1666))) and v102) then
									return v102;
								end
								break;
							end
						end
					end
				end
				v105 = v12:GetEnemiesInRange(18 + 22);
				v103 = v12:GetEnemiesInMeleeRange(5 + 7);
				v132 = 3 + 0;
			end
		end
	end
	local function v123()
		local v133 = 940 - (850 + 90);
		while true do
			if (((7003 - 3004) >= (4290 - (360 + 1030))) and (v133 == (1 + 0))) then
				EpicSettings.SetupVersion("Holy Priest X v 10.2.00 By BoomK");
				break;
			end
			if ((v133 == (0 - 0)) or ((3473 - 948) > (5725 - (909 + 752)))) then
				v109();
				v20.Print("Holy Priest by Epic BoomK");
				v133 = 1224 - (109 + 1114);
			end
		end
	end
	v20.SetAPL(469 - 212, v122, v123);
end;
return v0["Epix_Priest_Holy.lua"]();

