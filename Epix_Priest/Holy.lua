local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((6848 - 3137) > (9369 - 6014)) and not v5) then
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
	local v36 = 0 + 0;
	local v37 = false;
	local v38 = false;
	local v39 = 1061 - (810 + 251);
	local v40 = false;
	local v41 = false;
	local v42 = 0 + 0;
	local v43 = 0 + 0;
	local v44 = false;
	local v45 = 0 + 0;
	local v46 = 533 - (43 + 490);
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
	local v97 = 733 - (711 + 22);
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
		if (v98.ImprovedPurify:IsAvailable() or ((3504 - 2598) >= (3088 - (240 + 619)))) then
			v108.DispellableDebuffs = v19.MergeTable(v108.DispellableMagicDebuffs, v108.DispellableDiseaseDebuffs);
		else
			v108.DispellableDebuffs = v108.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v109();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v110(v124)
		return v124:DebuffRefreshable(v98.ShadowWordPain) and (v124:TimeToDie() >= (3 + 9));
	end
	local function v111()
		if (((2048 - 760) > (83 + 1168)) and v98.Purify:IsReady() and v35 and v108.DispellableFriendlyUnit()) then
			if (v22(v100.PurifyFocus) or ((6257 - (1344 + 400)) < (3757 - (255 + 150)))) then
				return "purify dispel";
			end
		end
	end
	local function v112()
		if ((v98.Fade:IsReady() and v93 and (v12:HealthPercentage() <= v94)) or ((1627 + 438) >= (1712 + 1484))) then
			if (v22(v98.Fade, nil, nil, true) or ((18696 - 14320) <= (4783 - 3302))) then
				return "fade defensive";
			end
		end
		if ((v98.DesperatePrayer:IsCastable() and v92 and (v12:HealthPercentage() <= v36)) or ((5131 - (404 + 1335)) >= (5147 - (183 + 223)))) then
			if (((4046 - 721) >= (1428 + 726)) and v22(v98.DesperatePrayer)) then
				return "desperate_prayer defensive";
			end
		end
		if ((v99.Healthstone:IsReady() and v81 and (v12:HealthPercentage() <= v82)) or ((467 + 828) >= (3570 - (10 + 327)))) then
			if (((3049 + 1328) > (1980 - (118 + 220))) and v22(v100.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if (((1574 + 3149) > (1805 - (108 + 341))) and v88 and (v12:HealthPercentage() <= v90)) then
			if ((v89 == "Refreshing Healing Potion") or ((1858 + 2278) <= (14514 - 11081))) then
				if (((5738 - (711 + 782)) <= (8877 - 4246)) and v99.RefreshingHealingPotion:IsReady()) then
					if (((4745 - (270 + 199)) >= (1269 + 2645)) and v22(v100.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v113()
		local v125 = 1819 - (580 + 1239);
		while true do
			if (((588 - 390) <= (4174 + 191)) and (v125 == (0 + 0))) then
				v102 = v108.HandleTopTrinket(v101, v34 and v12:BuffUp(v98.PowerInfusionBuff), 18 + 22, nil);
				if (((12485 - 7703) > (2905 + 1771)) and v102) then
					return v102;
				end
				v125 = 1168 - (645 + 522);
			end
			if (((6654 - (1010 + 780)) > (2196 + 1)) and (v125 == (4 - 3))) then
				v102 = v108.HandleBottomTrinket(v101, v34 and v12:BuffUp(v98.PowerInfusionBuff), 117 - 77, nil);
				if (v102 or ((5536 - (1045 + 791)) == (6345 - 3838))) then
					return v102;
				end
				break;
			end
		end
	end
	local function v114()
		if (((6830 - 2356) >= (779 - (351 + 154))) and ((GetTime() - v97) > v39)) then
			local v152 = 1574 - (1281 + 293);
			while true do
				if ((v152 == (266 - (28 + 238))) or ((4231 - 2337) <= (2965 - (1381 + 178)))) then
					if (((1475 + 97) >= (1235 + 296)) and v98.BodyandSoul:IsAvailable() and v98.PowerWordShield:IsReady() and v38 and v12:BuffDown(v98.AngelicFeatherBuff) and v12:BuffDown(v98.BodyandSoulBuff)) then
						if (v22(v100.PowerWordShieldPlayer) or ((2000 + 2687) < (15658 - 11116))) then
							return "power_word_shield_player move";
						end
					end
					if (((1705 + 1586) > (2137 - (381 + 89))) and v98.AngelicFeather:IsReady() and v37 and v12:BuffDown(v98.AngelicFeatherBuff) and v12:BuffDown(v98.BodyandSoulBuff) and v12:BuffDown(v98.AngelicFeatherBuff)) then
						if (v22(v100.AngelicFeatherPlayer) or ((775 + 98) == (1376 + 658))) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v115()
		if ((v78 == "Anyone") or ((4823 - 2007) < (1167 - (1074 + 82)))) then
			if (((8105 - 4406) < (6490 - (214 + 1570))) and v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79)) then
				if (((4101 - (990 + 465)) >= (362 + 514)) and v22(v100.GuardianSpiritFocus, nil, nil, true)) then
					return "guardian_spirit heal_cooldown";
				end
			end
		elseif (((268 + 346) <= (3097 + 87)) and (v78 == "Tank Only")) then
			if (((12302 - 9176) == (4852 - (1668 + 58))) and v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79) and (Commons.UnitGroupRole(v14) == "TANK")) then
				if (v22(v100.GuardianSpiritFocus, nil, nil, true) or ((2813 - (512 + 114)) >= (12915 - 7961))) then
					return "guardian_spirit heal_cooldown";
				end
			end
		elseif ((v78 == "Tank and Self") or ((8015 - 4138) == (12439 - 8864))) then
			if (((329 + 378) > (119 + 513)) and v98.GuardianSpirit:IsReady() and (v14:HealthPercentage() <= v79) and ((Commons.UnitGroupRole(v14) == "TANK") or (Commons.UnitGroupRole(v14) == "HEALER"))) then
				if (v22(v100.GuardianSpiritFocus, nil, nil, true) or ((475 + 71) >= (9052 - 6368))) then
					return "guardian_spirit heal_cooldown";
				end
			end
		end
		if (((3459 - (109 + 1885)) <= (5770 - (1269 + 200))) and v98.HolyWordSalvation:IsReady() and v69 and v108.AreUnitsBelowHealthPercentage(v70, v71)) then
			if (((3265 - 1561) > (2240 - (98 + 717))) and v22(v98.HolyWordSalvation, nil, true)) then
				return "holy_word_salvation heal_cooldown";
			end
		end
		if ((v98.DivineHymn:IsReady() and v51 and v108.AreUnitsBelowHealthPercentage(v52, v53)) or ((1513 - (802 + 24)) == (7301 - 3067))) then
			if (v22(v98.DivineHymn, nil, true) or ((4205 - 875) < (212 + 1217))) then
				return "divine_hymn heal_cooldown";
			end
		end
	end
	local function v116()
		if (((882 + 265) >= (56 + 279)) and v98.PowerWordLife:IsReady() and v65 and (v14:HealthPercentage() < v66)) then
			if (((741 + 2694) > (5833 - 3736)) and v22(v100.PowerWordLifeFocus)) then
				return "power_word_life heal";
			end
		end
		if ((v98.PrayerofMending:IsReady() and v63 and v14:BuffRefreshable(v98.PrayerofMending) and (v14:HealthPercentage() <= v64)) or ((12572 - 8802) >= (1446 + 2595))) then
			if (v22(v100.PrayerofMendingFocus) or ((1544 + 2247) <= (1329 + 282))) then
				return "prayer_of_mending heal";
			end
		end
		if ((v98.HolyWordSanctify:IsReady() and v72 and v108.AreUnitsBelowHealthPercentage(v73, v74) and v15 and v15:IsAPlayer() and not v12:CanAttack(v15)) or ((3329 + 1249) <= (938 + 1070))) then
			if (((2558 - (797 + 636)) <= (10079 - 8003)) and v22(v100.HolyWordSanctifyCursor)) then
				return "holy_word_sanctify heal";
			end
		end
		if ((v98.HolyWordSerenity:IsReady() and v67 and (v14:HealthPercentage() <= v68)) or ((2362 - (1427 + 192)) >= (1525 + 2874))) then
			if (((2681 - 1526) < (1504 + 169)) and v22(v100.HolyWordSerenityFocus)) then
				return "holy_word_serenity heal";
			end
		end
		if ((v108.AreUnitsBelowHealthPercentage(v42, v43) and v41) or ((1054 + 1270) <= (904 - (192 + 134)))) then
			if (((5043 - (316 + 960)) == (2097 + 1670)) and v98.Apotheosis:IsReady() and v34 and v12:AffectingCombat() and ((v98.HolyWordSanctify:CooldownDown() and v98.HolyWordSerenity:CooldownDown()) or (v98.HolyWordSerenity:CooldownDown() and (v14:HealthPercentage() <= v68)) or (v98.HolyWordSanctify:CooldownDown() and v108.AreUnitsBelowHealthPercentage(v73, v74)))) then
				if (((3156 + 933) == (3780 + 309)) and v22(v98.Apotheosis)) then
					return "apotheosis heal";
				end
			end
		end
		if (((17042 - 12584) >= (2225 - (83 + 468))) and v98.CircleofHealing:IsReady() and v44 and v108.AreUnitsBelowHealthPercentage(v45, v46)) then
			if (((2778 - (1202 + 604)) <= (6619 - 5201)) and v22(v100.CircleofHealingFocus)) then
				return "circle_of_healing heal";
			end
		end
		if ((v98.DivineStar:IsReady() and (v14:HealthPercentage() < v55) and v54) or ((8218 - 3280) < (13184 - 8422))) then
			if (v22(v100.DivineStarPlayer, not v14:IsInRange(355 - (45 + 280))) or ((2417 + 87) > (3726 + 538))) then
				return "divine_star heal";
			end
		end
		if (((787 + 1366) == (1192 + 961)) and v98.Halo:IsReady() and v58 and v108.AreUnitsBelowHealthPercentage(v59, v60)) then
			if (v22(v100.HaloPlayer, nil, true) or ((90 + 417) >= (4797 - 2206))) then
				return "halo heal";
			end
		end
		if (((6392 - (340 + 1571)) == (1768 + 2713)) and v98.PrayerofHealing:IsReady() and v75 and v12:BuffUp(v98.PrayerCircleBuff) and v108.AreUnitsBelowHealthPercentage(v76, v77)) then
			if (v22(v100.PrayerofHealingFocus, nil, true) or ((4100 - (1733 + 39)) < (1904 - 1211))) then
				return "prayer_of_healing heal";
			end
		end
		if (((5362 - (125 + 909)) == (6276 - (1096 + 852))) and v98.FlashHeal:IsReady() and v56 and ((v98.Lightweaver:IsAvailable() and (v12:BuffDown(v98.LightweaverBuff) or (v12:BuffStack(v98.LightweaverBuff) < (1 + 1)))) or v12:BuffUp(v98.SurgeofLight) or (not v98.Lightweaver:IsAvailable() and (v12:ManaPercentage() > (57 - 17))))) then
			if (((1541 + 47) >= (1844 - (409 + 103))) and ((v14:HealthPercentage() <= v57) or (v14:HealthPercentage() <= v62))) then
				if (v22(v100.FlashHealFocus, nil, v107) or ((4410 - (46 + 190)) > (4343 - (51 + 44)))) then
					return "flash_heal heal";
				end
			end
		end
		if ((v98.Heal:IsReady() and v61 and (v14:HealthPercentage() <= v62)) or ((1294 + 3292) <= (1399 - (1114 + 203)))) then
			if (((4589 - (228 + 498)) == (837 + 3026)) and v22(v100.HealFocus, nil, true)) then
				return "heal heal";
			end
		end
		if ((v98.SymbolofHope:IsReady() and v40 and v34 and v98.DesperatePrayer:CooldownDown()) or ((156 + 126) <= (705 - (174 + 489)))) then
			if (((12007 - 7398) >= (2671 - (830 + 1075))) and v22(v98.SymbolofHope, nil, true)) then
				return "symbol_of_hope heal";
			end
		end
		if ((v98.Renew:IsReady() and v95 and v14:BuffDown(v98.Renew) and (v14:HealthPercentage() <= v96)) or ((1676 - (303 + 221)) == (3757 - (231 + 1038)))) then
			if (((2852 + 570) > (4512 - (171 + 991))) and v22(v100.RenewFocus, nil, true)) then
				return "renew heal";
			end
		end
	end
	local function v117()
		local v126 = 0 - 0;
		while true do
			if (((2354 - 1477) > (938 - 562)) and (v126 == (1 + 0))) then
				if ((v98.ArcaneTorrent:IsReady() and v84 and v34 and (v12:ManaPercentage() <= (333 - 238))) or ((8994 - 5876) <= (2983 - 1132))) then
					if (v22(v98.ArcaneTorrent) or ((510 - 345) >= (4740 - (111 + 1137)))) then
						return "arcane_torrent damage";
					end
				end
				if (((4107 - (91 + 67)) < (14452 - 9596)) and v85 and v34 and v12:BuffUp(v98.PowerInfusionBuff)) then
					local v167 = 0 + 0;
					while true do
						if ((v167 == (523 - (423 + 100))) or ((31 + 4245) < (8350 - 5334))) then
							v102 = v113();
							if (((2445 + 2245) > (4896 - (326 + 445))) and v102) then
								return v102;
							end
							break;
						end
					end
				end
				if ((v98.ShadowWordDeath:IsCastable() and (v13:HealthPercentage() <= (87 - 67))) or ((111 - 61) >= (2090 - 1194))) then
					if (v22(v98.ShadowWordDeath, not v13:IsSpellInRange(v98.ShadowWordDeath)) or ((2425 - (530 + 181)) >= (3839 - (614 + 267)))) then
						return "shadow_word_death damage";
					end
				end
				if ((v98.ShadowWordDeath:IsCastable() and v15 and (v15:HealthPercentage() <= (52 - (19 + 13)))) or ((2426 - 935) < (1500 - 856))) then
					if (((2010 - 1306) < (257 + 730)) and v22(v100.ShadowWordDeathMouseover, not v15:IsSpellInRange(v98.ShadowWordDeath))) then
						return "shadow_word_death_mouseover damage";
					end
				end
				v126 = 3 - 1;
			end
			if (((7710 - 3992) > (3718 - (1293 + 519))) and (v126 == (0 - 0))) then
				v102 = v108.InterruptWithStun(v98.PsychicScream, 20 - 12);
				if (v102 or ((1831 - 873) > (15674 - 12039))) then
					return v102;
				end
				if (((8247 - 4746) <= (2380 + 2112)) and v98.DispelMagic:IsReady() and v35 and v83 and not v12:IsCasting() and not v12:IsChanneling() and v108.UnitHasMagicBuff(v13)) then
					if (v22(v98.DispelMagic, not v13:IsSpellInRange(v98.DispelMagic)) or ((703 + 2739) < (5920 - 3372))) then
						return "dispel_magic damage";
					end
				end
				if (((665 + 2210) >= (487 + 977)) and v98.Shadowfiend:IsReady() and v34 and (v12:ManaPercentage() <= (60 + 35))) then
					if (v22(v98.Shadowfiend) or ((5893 - (709 + 387)) >= (6751 - (673 + 1185)))) then
						return "shadowfiend damage";
					end
				end
				v126 = 2 - 1;
			end
			if ((v126 == (12 - 8)) or ((906 - 355) > (1480 + 588))) then
				if (((1580 + 534) > (1274 - 330)) and v98.HolyNova:IsReady() and (v104 > (1 + 3))) then
					if (v22(v98.HolyNova) or ((4509 - 2247) >= (6076 - 2980))) then
						return "holy_nova_aoe damage";
					end
				end
				if (v12:IsMoving() or ((4135 - (446 + 1434)) >= (4820 - (1040 + 243)))) then
					local v168 = 0 - 0;
					while true do
						if ((v168 == (1847 - (559 + 1288))) or ((5768 - (609 + 1322)) < (1760 - (13 + 441)))) then
							v102 = v114();
							if (((11023 - 8073) == (7727 - 4777)) and v102) then
								return v102;
							end
							break;
						end
					end
				end
				if (v98.ShadowWordPain:IsReady() or ((23522 - 18799) < (123 + 3175))) then
					if (((4125 - 2989) >= (55 + 99)) and v108.CastCycle(v98.ShadowWordPain, v105, v110, not v13:IsSpellInRange(v98.ShadowWordPain), nil, nil, v100.ShadowWordPainMouseover)) then
						return "shadow_word_pain_cycle damage";
					end
				end
				if ((v98.HolyNova:IsReady() and (v104 >= (1 + 1))) or ((804 - 533) > (2599 + 2149))) then
					if (((8717 - 3977) >= (2084 + 1068)) and v22(v98.HolyNova)) then
						return "holy_nova damage";
					end
				end
				v126 = 3 + 2;
			end
			if ((v126 == (4 + 1)) or ((2165 + 413) >= (3317 + 73))) then
				if (((474 - (153 + 280)) <= (4796 - 3135)) and v98.Smite:IsReady()) then
					if (((540 + 61) < (1406 + 2154)) and v22(v98.Smite, not v13:IsSpellInRange(v98.Smite), true)) then
						return "smite damage";
					end
				end
				if (((123 + 112) < (624 + 63)) and v98.ShadowWordPain:IsReady()) then
					if (((3297 + 1252) > (1755 - 602)) and v22(v98.ShadowWordPain, not v13:IsSpellInRange(v98.ShadowWordPain))) then
						return "shadow_word_pain_movement damage";
					end
				end
				break;
			end
			if ((v126 == (2 + 1)) or ((5341 - (89 + 578)) < (3338 + 1334))) then
				if (((7625 - 3957) < (5610 - (572 + 477))) and v108.AreUnitsBelowHealthPercentage(v42, v43) and v41) then
					if ((v98.Apotheosis:IsReady() and v34 and v12:AffectingCombat() and v98.HolyWordSanctify:CooldownDown() and v98.HolyWordSerenity:CooldownDown() and (v98.HolyWordChastise:CooldownRemains() > ((v12:GCD() + 0.15 + 0) * (2 + 1))) and (not v98.HolyNova:IsAvailable() or (v104 < (1 + 4)))) or ((541 - (84 + 2)) == (5941 - 2336))) then
						if (v22(v98.Apotheosis) or ((1919 + 744) == (4154 - (497 + 345)))) then
							return "apotheosis damage";
						end
					end
				end
				if (((110 + 4167) <= (757 + 3718)) and v98.HolyFire:IsReady() and (not v98.HolyNova:IsAvailable() or (v104 < (1338 - (605 + 728))))) then
					if (v22(v98.HolyFire, not v13:IsSpellInRange(v98.HolyFire), v106) or ((621 + 249) == (2643 - 1454))) then
						return "holy_fire damage";
					end
				end
				if (((72 + 1481) <= (11583 - 8450)) and v98.EmpyrealBlaze:IsReady() and v98.HolyFire:CooldownDown() and (not v98.HolyNova:IsAvailable() or (v104 < (5 + 0)))) then
					if (v22(v98.EmpyrealBlaze, not v13:IsSpellInRange(v98.HolyFire)) or ((6197 - 3960) >= (2651 + 860))) then
						return "empyreal_blaze damage";
					end
				end
				if (v98.Mindgames:IsReady() or ((1813 - (457 + 32)) > (1282 + 1738))) then
					if (v22(v98.Mindgames, not v13:IsInRange(1442 - (832 + 570)), true) or ((2819 + 173) == (491 + 1390))) then
						return "mindgames damage";
					end
				end
				v126 = 13 - 9;
			end
			if (((1497 + 1609) > (2322 - (588 + 208))) and (v126 == (5 - 3))) then
				if (((4823 - (884 + 916)) < (8102 - 4232)) and v98.DivineStar:IsReady() and not v13:IsFacingBlacklisted()) then
					if (((83 + 60) > (727 - (232 + 421))) and v22(v100.DivineStarPlayer, not v13:IsInRange(1919 - (1569 + 320)))) then
						return "divine_star damage";
					end
				end
				if (((5 + 13) < (402 + 1710)) and v98.Halo:IsReady() and v58) then
					if (((3696 - 2599) <= (2233 - (316 + 289))) and v22(v100.HaloPlayer, not v13:IsInRange(78 - 48), true)) then
						return "halo damage";
					end
				end
				if (((214 + 4416) == (6083 - (666 + 787))) and v98.HolyNova:IsReady() and (v12:BuffStack(v98.RhapsodyBuff) == (445 - (360 + 65)))) then
					if (((3309 + 231) > (2937 - (79 + 175))) and v22(v98.HolyNova)) then
						return "holy_nova_rhapsody damage";
					end
				end
				if (((7558 - 2764) >= (2556 + 719)) and v98.HolyWordChastise:IsReady() and (not v98.HolyNova:IsAvailable() or (v104 < (15 - 10)))) then
					if (((2857 - 1373) == (2383 - (503 + 396))) and v22(v98.HolyWordChastise, not v13:IsSpellInRange(v98.HolyWordChastise))) then
						return "holy_word_chastise damage";
					end
				end
				v126 = 184 - (92 + 89);
			end
		end
	end
	local function v118()
		local v127 = 0 - 0;
		while true do
			if (((735 + 697) < (2105 + 1450)) and ((3 - 2) == v127)) then
				if (v14 or ((146 + 919) > (8157 - 4579))) then
					local v169 = 0 + 0;
					while true do
						if ((v169 == (1 + 0)) or ((14603 - 9808) < (176 + 1231))) then
							v102 = v116();
							if (((2825 - 972) < (6057 - (485 + 759))) and v102) then
								return v102;
							end
							break;
						end
						if ((v169 == (0 - 0)) or ((4010 - (442 + 747)) < (3566 - (832 + 303)))) then
							if (v80 or ((3820 - (88 + 858)) < (665 + 1516))) then
								local v180 = 0 + 0;
								while true do
									if (((0 + 0) == v180) or ((3478 - (766 + 23)) <= (1693 - 1350))) then
										v102 = v111();
										if (v102 or ((2555 - 686) == (5292 - 3283))) then
											return v102;
										end
										break;
									end
								end
							end
							if (v34 or ((12035 - 8489) < (3395 - (1036 + 37)))) then
								local v181 = 0 + 0;
								while true do
									if ((v181 == (0 - 0)) or ((1638 + 444) == (6253 - (641 + 839)))) then
										v102 = v115();
										if (((4157 - (910 + 3)) > (2689 - 1634)) and v102) then
											return v102;
										end
										break;
									end
								end
							end
							v169 = 1685 - (1466 + 218);
						end
					end
				end
				if (v108.TargetIsValid() or ((1523 + 1790) <= (2926 - (556 + 592)))) then
					local v170 = 0 + 0;
					while true do
						if ((v170 == (808 - (329 + 479))) or ((2275 - (174 + 680)) >= (7229 - 5125))) then
							v102 = v117();
							if (((3755 - 1943) <= (2320 + 929)) and v102) then
								return v102;
							end
							break;
						end
					end
				elseif (((2362 - (396 + 343)) <= (174 + 1783)) and v12:IsMoving()) then
					local v177 = 1477 - (29 + 1448);
					while true do
						if (((5801 - (135 + 1254)) == (16620 - 12208)) and (v177 == (0 - 0))) then
							v102 = v114();
							if (((1167 + 583) >= (2369 - (389 + 1138))) and v102) then
								return v102;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4946 - (102 + 472)) > (1746 + 104)) and ((0 + 0) == v127)) then
				v102 = v112();
				if (((217 + 15) < (2366 - (320 + 1225))) and v102) then
					return v102;
				end
				v127 = 1 - 0;
			end
		end
	end
	local function v119()
		local v128 = 0 + 0;
		while true do
			if (((1982 - (157 + 1307)) < (2761 - (821 + 1038))) and (v128 == (2 - 1))) then
				if (((328 + 2666) > (1523 - 665)) and v13 and v13:Exists() and v13:IsAPlayer() and v13:IsDeadOrGhost() and not v12:CanAttack(v13)) then
					local v171 = 0 + 0;
					local v172;
					while true do
						if ((v171 == (0 - 0)) or ((4781 - (834 + 192)) <= (59 + 856))) then
							v172 = v108.DeadFriendlyUnitsCount();
							if (((1013 + 2933) > (81 + 3662)) and (v172 > (1 - 0))) then
								if (v22(v98.MassResurrection, nil, true) or ((1639 - (300 + 4)) >= (883 + 2423))) then
									return "mass_resurrection";
								end
							elseif (((12680 - 7836) > (2615 - (112 + 250))) and v22(v98.Resurrection, nil, true)) then
								return "resurrection";
							end
							break;
						end
					end
				end
				if (((181 + 271) == (1132 - 680)) and v98.PowerWordFortitude:IsCastable() and v91 and (v12:BuffDown(v98.PowerWordFortitudeBuff, true) or v108.GroupBuffMissing(v98.PowerWordFortitudeBuff))) then
					if (v22(v100.PowerWordFortitudePlayer) or ((2611 + 1946) < (1080 + 1007))) then
						return "power_word_fortitude";
					end
				end
				break;
			end
			if (((2898 + 976) == (1921 + 1953)) and (v128 == (0 + 0))) then
				if (v14 or ((3352 - (1001 + 413)) > (11004 - 6069))) then
					local v173 = 882 - (244 + 638);
					while true do
						if ((v173 == (693 - (627 + 66))) or ((12678 - 8423) < (4025 - (512 + 90)))) then
							if (((3360 - (1665 + 241)) <= (3208 - (373 + 344))) and v80) then
								local v182 = 0 + 0;
								while true do
									if ((v182 == (0 + 0)) or ((10964 - 6807) <= (4742 - 1939))) then
										v102 = v111();
										if (((5952 - (35 + 1064)) >= (2170 + 812)) and v102) then
											return v102;
										end
										break;
									end
								end
							end
							if (((8844 - 4710) > (14 + 3343)) and v32) then
								v102 = v116();
								if (v102 or ((4653 - (298 + 938)) < (3793 - (233 + 1026)))) then
									return v102;
								end
							end
							break;
						end
					end
				end
				if (v12:IsMoving() or ((4388 - (636 + 1030)) <= (84 + 80))) then
					v102 = v114();
					if (v102 or ((2353 + 55) < (627 + 1482))) then
						return v102;
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v120()
		local v129 = 221 - (55 + 166);
		while true do
			if (((1 + 0) == v129) or ((4 + 29) == (5556 - 4101))) then
				v40 = EpicSettings.Settings['UseSymbolOfHope'];
				v41 = EpicSettings.Settings['UseApotheosis'];
				v42 = EpicSettings.Settings['ApotheosisHP'] or (297 - (36 + 261));
				v43 = EpicSettings.Settings['ApotheosisGroup'] or (0 - 0);
				v129 = 1370 - (34 + 1334);
			end
			if ((v129 == (2 + 3)) or ((345 + 98) >= (5298 - (1035 + 248)))) then
				v56 = EpicSettings.Settings['UseFlashHeal'];
				v57 = EpicSettings.Settings['FlashHealHP'] or (21 - (20 + 1));
				v58 = EpicSettings.Settings['UseHalo'];
				v59 = EpicSettings.Settings['HaloHP'] or (0 + 0);
				v129 = 325 - (134 + 185);
			end
			if (((4515 - (549 + 584)) > (851 - (314 + 371))) and (v129 == (0 - 0))) then
				v36 = EpicSettings.Settings['DesperatePrayerHP'] or (968 - (478 + 490));
				v37 = EpicSettings.Settings['UseAngelicFeather'];
				v38 = EpicSettings.Settings['UseBodyAndSoul'];
				v39 = EpicSettings.Settings['MovementDelay'] or (0 + 0);
				v129 = 1173 - (786 + 386);
			end
			if ((v129 == (9 - 6)) or ((1659 - (1055 + 324)) == (4399 - (1093 + 247)))) then
				v48 = EpicSettings.Settings['PIName1'] or "";
				v49 = EpicSettings.Settings['PIName2'] or "";
				v50 = EpicSettings.Settings['PIName3'] or "";
				v51 = EpicSettings.Settings['UseDivineHymn'];
				v129 = 4 + 0;
			end
			if (((198 + 1683) > (5133 - 3840)) and (v129 == (13 - 9))) then
				v52 = EpicSettings.Settings['DivineHymnHP'] or (0 - 0);
				v53 = EpicSettings.Settings['DivineHymnGroup'] or (0 - 0);
				v54 = EpicSettings.Settings['UseDivineStar'];
				v55 = EpicSettings.Settings['DivineStarHP'] or (0 + 0);
				v129 = 19 - 14;
			end
			if (((8124 - 5767) == (1778 + 579)) and (v129 == (15 - 9))) then
				v60 = EpicSettings.Settings['HaloGroup'] or (688 - (364 + 324));
				v61 = EpicSettings.Settings['UseHeal'];
				v62 = EpicSettings.Settings['HealHP'] or (0 - 0);
				break;
			end
			if (((294 - 171) == (41 + 82)) and (v129 == (8 - 6))) then
				v44 = EpicSettings.Settings['UseCircleOfHealing'];
				v45 = EpicSettings.Settings['CircleOfHealingHP'] or (0 - 0);
				v46 = EpicSettings.Settings['CircleOfHealingGroup'] or (0 - 0);
				v47 = EpicSettings.Settings['PowerInfusionUsage'] or "";
				v129 = 1271 - (1249 + 19);
			end
		end
	end
	local function v121()
		v63 = EpicSettings.Settings['UsePrayerOfMending'];
		v64 = EpicSettings.Settings['PrayerOfMendingHP'] or (0 + 0);
		v65 = EpicSettings.Settings['UsePowerWordLife'];
		v66 = EpicSettings.Settings['PowerWordLifeHP'] or (0 - 0);
		v67 = EpicSettings.Settings['UseHolyWordSerenity'];
		v68 = EpicSettings.Settings['HolyWordSerenityHP'] or (1086 - (686 + 400));
		v69 = EpicSettings.Settings['UseHolyWordSalvation'];
		v70 = EpicSettings.Settings['HolyWordSalvationHP'] or (0 + 0);
		v71 = EpicSettings.Settings['HolyWordSalvationGroup'] or (229 - (73 + 156));
		v72 = EpicSettings.Settings['UseHolyWordSanctify'];
		v73 = EpicSettings.Settings['HolyWordSanctifyHP'] or (0 + 0);
		v74 = EpicSettings.Settings['HolyWordSanctifyGroup'] or (811 - (721 + 90));
		v75 = EpicSettings.Settings['UsePrayerOfHealing'];
		v76 = EpicSettings.Settings['PrayerOfHealingHP'] or (0 + 0);
		v77 = EpicSettings.Settings['PrayerOfHealingGroup'] or (0 - 0);
		v78 = EpicSettings.Settings['GuardianSpiritUsage'] or "";
		v79 = EpicSettings.Settings['GuardianSpiritHP'] or (470 - (224 + 246));
		v80 = EpicSettings.Settings['DispelDebuffs'];
		v81 = EpicSettings.Settings['UseHealthstone'];
		v82 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v83 = EpicSettings.Settings['DispelBuffs'];
		v84 = EpicSettings.Settings['UseRacials'];
		v85 = EpicSettings.Settings['UseTrinkets'];
		v86 = EpicSettings.Settings['HandleCharredTreant'];
		v87 = EpicSettings.Settings['HandleCharredBrambles'];
		v88 = EpicSettings.Settings['UseHealingPotion'];
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v90 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v91 = EpicSettings.Settings['UsePowerWordFortitude'];
		v92 = EpicSettings.Settings['UseDesperatePrayer'];
		v93 = EpicSettings.Settings['UseFade'] or (0 + 0);
		v94 = EpicSettings.Settings['FadeHP'] or (0 + 0);
		v95 = EpicSettings.Settings['UseRenew'];
		v96 = EpicSettings.Settings['RenewHP'] or (0 + 0);
	end
	local function v122()
		local v147 = 0 - 0;
		while true do
			if ((v147 == (0 - 0)) or ((1569 - (203 + 310)) >= (5385 - (1238 + 755)))) then
				v120();
				v121();
				v32 = EpicSettings.Toggles['ooc'];
				v147 = 1 + 0;
			end
			if ((v147 == (1539 - (709 + 825))) or ((1991 - 910) < (1565 - 490))) then
				if (v86 or ((1913 - (196 + 668)) >= (17498 - 13066))) then
					local v174 = 0 - 0;
					while true do
						if ((v174 == (833 - (171 + 662))) or ((4861 - (4 + 89)) <= (2964 - 2118))) then
							v102 = v108.HandleCharredTreant(v98.PowerWordLife, v100.PowerWordLifeMouseover, 15 + 25);
							if (v102 or ((14749 - 11391) <= (557 + 863))) then
								return v102;
							end
							v174 = 1487 - (35 + 1451);
						end
						if ((v174 == (1454 - (28 + 1425))) or ((5732 - (941 + 1052)) <= (2882 + 123))) then
							v102 = v108.HandleCharredTreant(v98.HolyWordSerenity, v100.HolyWordSerenityMouseover, 1554 - (822 + 692));
							if (v102 or ((2367 - 708) >= (1006 + 1128))) then
								return v102;
							end
							v174 = 299 - (45 + 252);
						end
						if ((v174 == (2 + 0)) or ((1122 + 2138) < (5731 - 3376))) then
							v102 = v108.HandleCharredTreant(v98.FlashHeal, v100.FlashHealMouseover, 473 - (114 + 319), true);
							if (v102 or ((959 - 290) == (5410 - 1187))) then
								return v102;
							end
							break;
						end
					end
				end
				if (v87 or ((1079 + 613) < (875 - 287))) then
					local v175 = 0 - 0;
					while true do
						if (((1964 - (556 + 1407)) == v175) or ((6003 - (741 + 465)) < (4116 - (170 + 295)))) then
							v102 = v108.HandleCharredBrambles(v98.HolyWordSerenity, v100.HolyWordSerenityMouseover, 22 + 18);
							if (v102 or ((3837 + 340) > (11940 - 7090))) then
								return v102;
							end
							v175 = 2 + 0;
						end
						if ((v175 == (0 + 0)) or ((227 + 173) > (2341 - (957 + 273)))) then
							v102 = v108.HandleCharredBrambles(v98.PowerWordLife, v100.PowerWordLifeMouseover, 11 + 29);
							if (((1222 + 1829) > (3829 - 2824)) and v102) then
								return v102;
							end
							v175 = 2 - 1;
						end
						if (((11280 - 7587) <= (21698 - 17316)) and (v175 == (1782 - (389 + 1391)))) then
							v102 = v108.HandleCharredBrambles(v98.FlashHeal, v100.FlashHealMouseover, 26 + 14, true);
							if (v102 or ((342 + 2940) > (9334 - 5234))) then
								return v102;
							end
							break;
						end
					end
				end
				if (not v12:IsChanneling() or ((4531 - (783 + 168)) < (9544 - 6700))) then
					if (((88 + 1) < (4801 - (309 + 2))) and v12:AffectingCombat()) then
						v102 = v118();
						if (v102 or ((15302 - 10319) < (3020 - (1090 + 122)))) then
							return v102;
						end
					elseif (((1242 + 2587) > (12657 - 8888)) and v32) then
						v102 = v119();
						if (((1017 + 468) <= (4022 - (628 + 490))) and v102) then
							return v102;
						end
						v102 = v117();
						if (((766 + 3503) == (10569 - 6300)) and v102) then
							return v102;
						end
					end
				end
				break;
			end
			if (((1768 - 1381) <= (3556 - (431 + 343))) and (v147 == (5 - 2))) then
				if (v12:AffectingCombat() or v80 or ((5493 - 3594) <= (725 + 192))) then
					local v176 = v80 and v98.Purify:IsReady() and v35;
					if ((v108.IsTankBelowHealthPercentage(v79) and v98.GuardianSpirit:IsReady() and ((v78 == "Tank Only") or (v78 == "Tank and Self"))) or ((552 + 3760) <= (2571 - (556 + 1139)))) then
						v102 = v108.FocusUnit(v176, nil, nil, "TANK", 35 - (6 + 9));
						if (((409 + 1823) <= (1330 + 1266)) and v102) then
							return v102;
						end
					elseif (((2264 - (28 + 141)) < (1428 + 2258)) and (v12:HealthPercentage() < v79) and v98.GuardianSpirit:IsReady() and (v78 == "Tank and Self")) then
						local v178 = 0 - 0;
						while true do
							if ((v178 == (0 + 0)) or ((2912 - (486 + 831)) >= (11642 - 7168))) then
								v102 = v108.FocusUnit(v176, nil, nil, "HEALER", 70 - 50);
								if (v102 or ((873 + 3746) < (9112 - 6230))) then
									return v102;
								end
								break;
							end
						end
					else
						local v179 = 1263 - (668 + 595);
						while true do
							if ((v179 == (0 + 0)) or ((60 + 234) >= (13174 - 8343))) then
								v102 = v108.FocusUnit(v176, nil, nil, nil, 310 - (23 + 267));
								if (((3973 - (1129 + 815)) <= (3471 - (371 + 16))) and v102) then
									return v102;
								end
								break;
							end
						end
					end
				end
				v105 = v12:GetEnemiesInRange(1790 - (1326 + 424));
				v103 = v12:GetEnemiesInMeleeRange(22 - 10);
				v147 = 14 - 10;
			end
			if (((119 - (88 + 30)) == v147) or ((2808 - (720 + 51)) == (5383 - 2963))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v147 = 1778 - (421 + 1355);
			end
			if (((7354 - 2896) > (1918 + 1986)) and (v147 == (1087 - (286 + 797)))) then
				if (((1593 - 1157) >= (202 - 79)) and v33) then
					v104 = #v103;
				else
					v104 = 440 - (397 + 42);
				end
				v106 = v12:BuffDown(v98.EmpyrealBlazeBuff);
				v107 = v12:BuffDown(v98.SurgeofLight);
				v147 = 2 + 3;
			end
			if (((1300 - (24 + 776)) < (2797 - 981)) and (v147 == (787 - (222 + 563)))) then
				if (((7874 - 4300) == (2574 + 1000)) and v12:IsDeadOrGhost()) then
					return;
				end
				if (((411 - (23 + 167)) < (2188 - (690 + 1108))) and v12:IsMounted()) then
					return;
				end
				if (not v12:IsMoving() or ((799 + 1414) <= (1173 + 248))) then
					v97 = GetTime();
				end
				v147 = 851 - (40 + 808);
			end
		end
	end
	local function v123()
		local v148 = 0 + 0;
		while true do
			if (((11693 - 8635) < (4646 + 214)) and (v148 == (1 + 0))) then
				EpicSettings.SetupVersion("Holy Priest X v 10.2.01 By BoomK");
				break;
			end
			if ((v148 == (0 + 0)) or ((1867 - (47 + 524)) >= (2886 + 1560))) then
				v109();
				v20.Print("Holy Priest by Epic BoomK");
				v148 = 2 - 1;
			end
		end
	end
	v20.SetAPL(383 - 126, v122, v123);
end;
return v0["Epix_Priest_Holy.lua"]();

