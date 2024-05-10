local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1061 - (346 + 715);
	local v6;
	while true do
		if (((1726 - 718) <= (4867 - (1074 + 82))) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if ((v5 == (1784 - (214 + 1570))) or ((2504 - (990 + 465)) <= (374 + 532))) then
			v6 = v0[v4];
			if (((1964 + 2549) > (2651 + 75)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = string.format;
	local v29, v29, v30 = UnitClass("focus");
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v102 = v19.Paladin.Protection;
	local v103 = v20.Paladin.Protection;
	local v104 = v24.Paladin.Protection;
	local v105 = {};
	local v106;
	local v107;
	local v108, v109;
	local v110, v111;
	local v112 = v21.Commons.Everyone;
	local v113 = 12837 - (1668 + 58);
	local v114 = 11737 - (512 + 114);
	local v115 = 0 - 0;
	v10:RegisterForEvent(function()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 - 0)) or ((689 + 792) >= (498 + 2160))) then
				v113 = 9660 + 1451;
				v114 = 37476 - 26365;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v116()
		if (v102.CleanseToxins:IsAvailable() or ((5214 - (109 + 1885)) == (2833 - (1269 + 200)))) then
			v112.DispellableDebuffs = v13.MergeTable(v112.DispellableDiseaseDebuffs, v112.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v116();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v117(v134)
		return v134:DebuffRemains(v102.JudgmentDebuff);
	end
	local function v118()
		return v15:BuffDown(v102.RetributionAura) and v15:BuffDown(v102.DevotionAura) and v15:BuffDown(v102.ConcentrationAura) and v15:BuffDown(v102.CrusaderAura);
	end
	local v119 = 0 - 0;
	local function v120()
		if ((v102.CleanseToxins:IsReady() and (v112.UnitHasDispellableDebuffByPlayer(v14) or v112.DispellableFriendlyUnit(835 - (98 + 717)) or v112.UnitHasCurseDebuff(v14) or v112.UnitHasPoisonDebuff(v14))) or ((1880 - (802 + 24)) > (5848 - 2456))) then
			local v204 = 0 - 0;
			while true do
				if ((v204 == (0 + 0)) or ((520 + 156) >= (270 + 1372))) then
					if (((893 + 3243) > (6668 - 4271)) and (v119 == (0 - 0))) then
						v119 = GetTime();
					end
					if (v112.Wait(179 + 321, v119) or ((1765 + 2569) == (3502 + 743))) then
						local v221 = 0 + 0;
						while true do
							if ((v221 == (0 + 0)) or ((5709 - (797 + 636)) <= (14716 - 11685))) then
								if (v25(v104.CleanseToxinsFocus) or ((6401 - (1427 + 192)) <= (416 + 783))) then
									return "cleanse_toxins dispel";
								end
								v119 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		if ((v100 and (v15:HealthPercentage() <= v101)) or ((4373 + 491) < (862 + 1040))) then
			if (((5165 - (192 + 134)) >= (4976 - (316 + 960))) and v102.FlashofLight:IsReady()) then
				if (v25(v102.FlashofLight) or ((599 + 476) > (1481 + 437))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v122()
		v31 = v112.HandleTopTrinket(v105, v34, 37 + 3, nil);
		if (((1513 - 1117) <= (4355 - (83 + 468))) and v31) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v105, v34, 1846 - (1202 + 604), nil);
		if (v31 or ((19461 - 15292) == (3639 - 1452))) then
			return v31;
		end
	end
	local function v123()
		if (((3892 - 2486) == (1731 - (45 + 280))) and (v15:HealthPercentage() <= v71) and v60 and v102.DivineShield:IsCastable() and v15:DebuffDown(v102.ForbearanceDebuff)) then
			if (((1478 + 53) < (3732 + 539)) and v25(v102.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((232 + 403) == (352 + 283)) and (v15:HealthPercentage() <= v73) and v62 and v102.LayonHands:IsCastable() and v15:DebuffDown(v102.ForbearanceDebuff)) then
			if (((594 + 2779) <= (6584 - 3028)) and v25(v104.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v102.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v72) and v61 and v15:BuffDown(v102.ArdentDefenderBuff)) or ((5202 - (340 + 1571)) < (1294 + 1986))) then
			if (((6158 - (1733 + 39)) >= (2398 - 1525)) and v25(v102.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((1955 - (125 + 909)) <= (3050 - (1096 + 852))) and v102.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v102.GuardianofAncientKingsBuff)) then
			if (((2111 + 2595) >= (1374 - 411)) and v25(v102.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v102.WordofGlory:IsReady() and (v15:HealthPercentage() <= v74) and v63 and not v15:HealingAbsorbed()) or ((932 + 28) <= (1388 - (409 + 103)))) then
			if ((v15:BuffRemains(v102.ShieldoftheRighteousBuff) >= (241 - (46 + 190))) or v15:BuffUp(v102.DivinePurposeBuff) or v15:BuffUp(v102.ShiningLightFreeBuff) or ((2161 - (51 + 44)) == (263 + 669))) then
				if (((6142 - (1114 + 203)) < (5569 - (228 + 498))) and v25(v104.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v102.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (1 + 1)) and v15:BuffRefreshable(v102.ShieldoftheRighteousBuff) and v64 and (v106 or (v15:HealthPercentage() <= v75))) or ((2142 + 1735) >= (5200 - (174 + 489)))) then
			if (v25(v102.ShieldoftheRighteous) or ((11241 - 6926) < (3631 - (830 + 1075)))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v103.Healthstone:IsReady() and v96 and (v15:HealthPercentage() <= v98)) or ((4203 - (303 + 221)) < (1894 - (231 + 1038)))) then
			if (v25(v104.Healthstone) or ((3855 + 770) < (1794 - (171 + 991)))) then
				return "healthstone defensive";
			end
		end
		if ((v95 and (v15:HealthPercentage() <= v97)) or ((341 - 258) > (4779 - 2999))) then
			if (((1362 - 816) <= (862 + 215)) and (v99 == "Refreshing Healing Potion")) then
				if (v103.RefreshingHealingPotion:IsReady() or ((3491 - 2495) > (12407 - 8106))) then
					if (((6560 - 2490) > (2123 - 1436)) and v25(v104.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v99 == "Dreamwalker's Healing Potion") or ((1904 - (111 + 1137)) >= (3488 - (91 + 67)))) then
				if (v103.DreamwalkersHealingPotion:IsReady() or ((7416 - 4924) <= (84 + 251))) then
					if (((4845 - (423 + 100)) >= (18 + 2544)) and v25(v104.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v124()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (1 + 0)) or ((4408 - (326 + 445)) >= (16452 - 12682))) then
				if (v14 or ((5299 - 2920) > (10685 - 6107))) then
					local v210 = 711 - (530 + 181);
					while true do
						if ((v210 == (882 - (614 + 267))) or ((515 - (19 + 13)) > (1208 - 465))) then
							if (((5718 - 3264) > (1651 - 1073)) and v102.BlessingofSacrifice:IsCastable() and v69 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v80)) then
								if (((242 + 688) < (7839 - 3381)) and v25(v104.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((1372 - 710) <= (2784 - (1293 + 519))) and v102.BlessingofProtection:IsCastable() and v68 and v14:DebuffDown(v102.ForbearanceDebuff) and (v14:HealthPercentage() <= v79)) then
								if (((8916 - 4546) == (11409 - 7039)) and v25(v104.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v210 == (0 - 0)) or ((20534 - 15772) <= (2028 - 1167))) then
							if ((v102.WordofGlory:IsReady() and v66 and (v15:BuffUp(v102.ShiningLightFreeBuff) or (v115 >= (2 + 1))) and (v14:HealthPercentage() <= v77)) or ((289 + 1123) == (9907 - 5643))) then
								if (v25(v104.WordofGloryFocus) or ((733 + 2435) < (716 + 1437))) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v102.LayonHands:IsCastable() and v65 and v14:DebuffDown(v102.ForbearanceDebuff) and (v14:HealthPercentage() <= v76) and v15:AffectingCombat()) or ((3110 + 1866) < (2428 - (709 + 387)))) then
								if (((6486 - (673 + 1185)) == (13421 - 8793)) and v25(v104.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v210 = 3 - 2;
						end
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((39 + 15) == (296 + 99))) then
				if (((110 - 28) == (21 + 61)) and v16:Exists()) then
					if ((v102.WordofGlory:IsReady() and v67 and (v16:HealthPercentage() <= v78)) or ((1158 - 577) < (553 - 271))) then
						if (v25(v104.WordofGloryMouseover) or ((6489 - (446 + 1434)) < (3778 - (1040 + 243)))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((3438 - 2286) == (2999 - (559 + 1288))) and (not v14 or not v14:Exists() or not v14:IsInRange(1961 - (609 + 1322)))) then
					return;
				end
				v135 = 455 - (13 + 441);
			end
		end
	end
	local function v125()
		local v136 = 0 - 0;
		while true do
			if (((4966 - 3070) <= (17043 - 13621)) and ((1 + 1) == v136)) then
				if ((v102.Judgment:IsReady() and v44) or ((3595 - 2605) > (576 + 1044))) then
					if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((385 + 492) > (13932 - 9237))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((1473 + 1218) >= (3404 - 1553)) and (v136 == (1 + 0))) then
				if ((v102.Consecration:IsCastable() and v40) or ((1661 + 1324) >= (3490 + 1366))) then
					if (((3591 + 685) >= (1170 + 25)) and v25(v102.Consecration, not v17:IsInRange(441 - (153 + 280)))) then
						return "consecration precombat 8";
					end
				end
				if (((9332 - 6100) <= (4211 + 479)) and v102.AvengersShield:IsCastable() and v38) then
					if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v102.AvengersShield)) or ((354 + 542) >= (1647 + 1499))) then
						if (((2778 + 283) >= (2144 + 814)) and v25(v104.AvengersShieldMouseover)) then
							return "avengers_shield mouseover precombat 10";
						end
					end
					if (((4852 - 1665) >= (399 + 245)) and v25(v102.AvengersShield, not v17:IsSpellInRange(v102.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v136 = 669 - (89 + 578);
			end
			if (((461 + 183) <= (1463 - 759)) and (v136 == (1049 - (572 + 477)))) then
				if (((130 + 828) > (569 + 378)) and (v90 < v114) and v102.LightsJudgment:IsCastable() and v93 and ((v94 and v34) or not v94)) then
					if (((537 + 3955) >= (2740 - (84 + 2))) and v25(v102.LightsJudgment, not v17:IsSpellInRange(v102.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((5671 - 2229) >= (1083 + 420)) and (v90 < v114) and v102.ArcaneTorrent:IsCastable() and v93 and ((v94 and v34) or not v94) and (v115 < (847 - (497 + 345)))) then
					if (v25(v102.ArcaneTorrent, not v17:IsInRange(1 + 7)) or ((536 + 2634) <= (2797 - (605 + 728)))) then
						return "arcane_torrent precombat 6";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v126()
		if ((v102.AvengersShield:IsCastable() and v38 and (v10.CombatTime() < (3 - 1)) and v15:HasTier(2 + 27, 7 - 5)) or ((4325 + 472) == (12157 - 7769))) then
			local v205 = 0 + 0;
			while true do
				if (((1040 - (457 + 32)) <= (289 + 392)) and (v205 == (1402 - (832 + 570)))) then
					if (((3088 + 189) > (107 + 300)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v102.AvengersShield)) then
						if (((16614 - 11919) >= (682 + 733)) and v25(v104.AvengersShieldMouseover)) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (v25(v102.AvengersShield, not v17:IsSpellInRange(v102.AvengersShield)) or ((4008 - (588 + 208)) <= (2544 - 1600))) then
						return "avengers_shield cooldowns 2";
					end
					break;
				end
			end
		end
		if ((v102.LightsJudgment:IsCastable() and v93 and ((v94 and v34) or not v94) and (v111 >= (1802 - (884 + 916)))) or ((6481 - 3385) <= (1043 + 755))) then
			if (((4190 - (232 + 421)) == (5426 - (1569 + 320))) and v25(v102.LightsJudgment, not v17:IsSpellInRange(v102.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((942 + 2895) >= (299 + 1271)) and v102.AvengingWrath:IsCastable() and v45 and ((v51 and v34) or not v51)) then
			if (v25(v102.AvengingWrath, not v17:IsInRange(26 - 18)) or ((3555 - (316 + 289)) == (9978 - 6166))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((219 + 4504) >= (3771 - (666 + 787))) and v102.Sentinel:IsCastable() and v50 and ((v56 and v34) or not v56)) then
			if (v25(v102.Sentinel, not v17:IsInRange(433 - (360 + 65))) or ((1895 + 132) > (3106 - (79 + 175)))) then
				return "sentinel cooldowns 8";
			end
		end
		local v137 = v112.HandleDPSPotion(v15:BuffUp(v102.AvengingWrathBuff));
		if (v137 or ((1791 - 655) > (3369 + 948))) then
			return v137;
		end
		if (((14553 - 9805) == (9143 - 4395)) and v102.MomentOfGlory:IsCastable() and v49 and ((v55 and v34) or not v55) and ((v15:BuffRemains(v102.SentinelBuff) < (914 - (503 + 396))) or (((v10.CombatTime() > (191 - (92 + 89))) or (v102.Sentinel:CooldownRemains() > (28 - 13)) or (v102.AvengingWrath:CooldownRemains() > (8 + 7))) and (v102.AvengersShield:CooldownRemains() > (0 + 0)) and (v102.Judgment:CooldownRemains() > (0 - 0)) and (v102.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (((8518 - 4782) <= (4136 + 604)) and v25(v102.MomentOfGlory, not v17:IsInRange(4 + 4))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v47 and ((v53 and v34) or not v53) and v102.DivineToll:IsReady() and (v110 >= (8 - 5))) or ((424 + 2966) <= (4666 - 1606))) then
			if (v25(v102.DivineToll, not v17:IsInRange(1274 - (485 + 759))) or ((2311 - 1312) > (3882 - (442 + 747)))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((1598 - (832 + 303)) < (1547 - (88 + 858))) and v102.BastionofLight:IsCastable() and v46 and ((v52 and v34) or not v52) and (v15:BuffUp(v102.AvengingWrathBuff) or (v102.AvengingWrath:CooldownRemains() <= (10 + 20)))) then
			if (v25(v102.BastionofLight, not v17:IsInRange(7 + 1)) or ((90 + 2093) < (1476 - (766 + 23)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v127()
		local v138 = 0 - 0;
		while true do
			if (((6220 - 1671) == (11984 - 7435)) and ((6 - 4) == v138)) then
				if (((5745 - (1036 + 37)) == (3313 + 1359)) and v102.AvengersShield:IsCastable() and v38 and ((v111 > (3 - 1)) or v15:BuffUp(v102.MomentOfGloryBuff))) then
					if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v102.AvengersShield)) or ((2886 + 782) < (1875 - (641 + 839)))) then
						if (v25(v104.AvengersShieldMouseover) or ((5079 - (910 + 3)) == (1159 - 704))) then
							return "avengers_shield mouseover standard 14";
						end
					end
					if (v25(v102.AvengersShield, not v17:IsSpellInRange(v102.AvengersShield)) or ((6133 - (1466 + 218)) == (1224 + 1439))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v47 and ((v53 and v34) or not v53) and v102.DivineToll:IsReady()) or ((5425 - (556 + 592)) < (1063 + 1926))) then
					if (v25(v102.DivineToll, not v17:IsInRange(838 - (329 + 479))) or ((1724 - (174 + 680)) >= (14256 - 10107))) then
						return "divine_toll standard 16";
					end
				end
				if (((4584 - 2372) < (2273 + 910)) and v102.AvengersShield:IsCastable() and v38) then
					if (((5385 - (396 + 343)) > (265 + 2727)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v102.AvengersShield)) then
						if (((2911 - (29 + 1448)) < (4495 - (135 + 1254))) and v25(v104.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 18";
						end
					end
					if (((2960 - 2174) < (14114 - 11091)) and v25(v102.AvengersShield, not v17:IsSpellInRange(v102.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v138 = 2 + 1;
			end
			if ((v138 == (1533 - (389 + 1138))) or ((3016 - (102 + 472)) < (70 + 4))) then
				if (((2515 + 2020) == (4229 + 306)) and v102.Consecration:IsCastable() and v40 and (v15:BuffDown(v102.SanctificationEmpowerBuff))) then
					if (v25(v102.Consecration, not v17:IsInRange(1553 - (320 + 1225))) or ((5356 - 2347) <= (1288 + 817))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((3294 - (157 + 1307)) < (5528 - (821 + 1038))) and ((0 - 0) == v138)) then
				if ((v102.Consecration:IsCastable() and v40 and (v15:BuffStack(v102.SanctificationBuff) == (1 + 4))) or ((2540 - 1110) >= (1344 + 2268))) then
					if (((6649 - 3966) >= (3486 - (834 + 192))) and v25(v102.Consecration, not v17:IsInRange(1 + 7))) then
						return "consecration standard 2";
					end
				end
				if ((v102.ShieldoftheRighteous:IsCastable() and v64 and ((v15:HolyPower() > (1 + 1)) or v15:BuffUp(v102.BastionofLightBuff) or v15:BuffUp(v102.DivinePurposeBuff)) and (v15:BuffDown(v102.SanctificationBuff) or (v15:BuffStack(v102.SanctificationBuff) < (1 + 4)))) or ((2794 - 990) >= (3579 - (300 + 4)))) then
					if (v25(v102.ShieldoftheRighteous) or ((379 + 1038) > (9499 - 5870))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((5157 - (112 + 250)) > (161 + 241)) and v102.Judgment:IsReady() and v44 and (v110 > (7 - 4)) and (v15:BuffStack(v102.BulwarkofRighteousFuryBuff) >= (2 + 1)) and (v15:HolyPower() < (2 + 1))) then
					if (((3600 + 1213) > (1768 + 1797)) and v112.CastCycle(v102.Judgment, v108, v117, not v17:IsSpellInRange(v102.Judgment))) then
						return "judgment standard 6";
					end
					if (((2907 + 1005) == (5326 - (1001 + 413))) and v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment))) then
						return "judgment standard 6";
					end
				end
				v138 = 2 - 1;
			end
			if (((3703 - (244 + 638)) <= (5517 - (627 + 66))) and (v138 == (11 - 7))) then
				if (((2340 - (512 + 90)) <= (4101 - (1665 + 241))) and (v90 < v114) and v48 and ((v54 and v34) or not v54) and v102.EyeofTyr:IsCastable() and v102.InmostLight:IsAvailable() and (v110 >= (720 - (373 + 344)))) then
					if (((19 + 22) <= (799 + 2219)) and v25(v102.EyeofTyr, not v17:IsInRange(20 - 12))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((3629 - 1484) <= (5203 - (35 + 1064))) and v102.BlessedHammer:IsCastable() and v39) then
					if (((1957 + 732) < (10366 - 5521)) and v25(v102.BlessedHammer, not v17:IsInRange(1 + 7))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v102.HammeroftheRighteous:IsCastable() and v42) or ((3558 - (298 + 938)) > (3881 - (233 + 1026)))) then
					if (v25(v102.HammeroftheRighteous, not v17:IsInRange(1674 - (636 + 1030))) or ((2319 + 2215) == (2034 + 48))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v138 = 2 + 3;
			end
			if ((v138 == (1 + 2)) or ((1792 - (55 + 166)) > (362 + 1505))) then
				if ((v102.HammerofWrath:IsReady() and v43) or ((267 + 2387) >= (11441 - 8445))) then
					if (((4275 - (36 + 261)) > (3679 - 1575)) and v25(v102.HammerofWrath, not v17:IsSpellInRange(v102.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((4363 - (34 + 1334)) > (593 + 948)) and v102.Judgment:IsReady() and v44) then
					local v211 = 0 + 0;
					while true do
						if (((4532 - (1035 + 248)) > (974 - (20 + 1))) and (v211 == (0 + 0))) then
							if (v112.CastCycle(v102.Judgment, v108, v117, not v17:IsSpellInRange(v102.Judgment)) or ((3592 - (134 + 185)) > (5706 - (549 + 584)))) then
								return "judgment standard 22";
							end
							if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((3836 - (314 + 371)) < (4407 - 3123))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v102.Consecration:IsCastable() and v40 and v15:BuffDown(v102.ConsecrationBuff) and ((v15:BuffStack(v102.SanctificationBuff) < (973 - (478 + 490))) or not v15:HasTier(17 + 14, 1174 - (786 + 386)))) or ((5992 - 4142) == (2908 - (1055 + 324)))) then
					if (((2161 - (1093 + 247)) < (1887 + 236)) and v25(v102.Consecration, not v17:IsInRange(1 + 7))) then
						return "consecration standard 24";
					end
				end
				v138 = 15 - 11;
			end
			if (((3060 - 2158) < (6615 - 4290)) and (v138 == (12 - 7))) then
				if (((306 + 552) <= (11410 - 8448)) and v102.CrusaderStrike:IsCastable() and v41) then
					if (v25(v102.CrusaderStrike, not v17:IsSpellInRange(v102.CrusaderStrike)) or ((13600 - 9654) < (972 + 316))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v90 < v114) and v48 and ((v54 and v34) or not v54) and v102.EyeofTyr:IsCastable() and not v102.InmostLight:IsAvailable()) or ((8290 - 5048) == (1255 - (364 + 324)))) then
					if (v25(v102.EyeofTyr, not v17:IsInRange(21 - 13)) or ((2032 - 1185) >= (419 + 844))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v102.ArcaneTorrent:IsCastable() and v93 and ((v94 and v34) or not v94) and (v115 < (20 - 15))) or ((3608 - 1355) == (5621 - 3770))) then
					if (v25(v102.ArcaneTorrent, not v17:IsInRange(1276 - (1249 + 19))) or ((1884 + 203) > (9232 - 6860))) then
						return "arcane_torrent standard 36";
					end
				end
				v138 = 1092 - (686 + 400);
			end
			if ((v138 == (1 + 0)) or ((4674 - (73 + 156)) < (20 + 4129))) then
				if ((v102.Judgment:IsReady() and v44 and v15:BuffDown(v102.SanctificationEmpowerBuff) and v15:HasTier(842 - (721 + 90), 1 + 1)) or ((5902 - 4084) == (555 - (224 + 246)))) then
					local v212 = 0 - 0;
					while true do
						if (((1159 - 529) < (386 + 1741)) and (v212 == (0 + 0))) then
							if (v112.CastCycle(v102.Judgment, v108, v117, not v17:IsSpellInRange(v102.Judgment)) or ((1424 + 514) == (4997 - 2483))) then
								return "judgment standard 8";
							end
							if (((14159 - 9904) >= (568 - (203 + 310))) and v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if (((4992 - (1238 + 755)) > (81 + 1075)) and v102.HammerofWrath:IsReady() and v43) then
					if (((3884 - (709 + 825)) > (2127 - 972)) and v25(v102.HammerofWrath, not v17:IsSpellInRange(v102.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((5868 - 1839) <= (5717 - (196 + 668))) and v102.Judgment:IsReady() and v44 and ((v102.Judgment:Charges() >= (7 - 5)) or (v102.Judgment:FullRechargeTime() <= v15:GCD()))) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (833 - (171 + 662))) or ((609 - (4 + 89)) > (12036 - 8602))) then
							if (((1474 + 2572) >= (13321 - 10288)) and v112.CastCycle(v102.Judgment, v108, v117, not v17:IsSpellInRange(v102.Judgment))) then
								return "judgment standard 12";
							end
							if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((1067 + 1652) <= (2933 - (35 + 1451)))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v138 = 1455 - (28 + 1425);
			end
		end
	end
	local function v128()
		v36 = EpicSettings.Settings['swapAuras'];
		v37 = EpicSettings.Settings['useWeapon'];
		v38 = EpicSettings.Settings['useAvengersShield'];
		v39 = EpicSettings.Settings['useBlessedHammer'];
		v40 = EpicSettings.Settings['useConsecration'];
		v41 = EpicSettings.Settings['useCrusaderStrike'];
		v42 = EpicSettings.Settings['useHammeroftheRighteous'];
		v43 = EpicSettings.Settings['useHammerofWrath'];
		v44 = EpicSettings.Settings['useJudgment'];
		v45 = EpicSettings.Settings['useAvengingWrath'];
		v46 = EpicSettings.Settings['useBastionofLight'];
		v47 = EpicSettings.Settings['useDivineToll'];
		v48 = EpicSettings.Settings['useEyeofTyr'];
		v49 = EpicSettings.Settings['useMomentOfGlory'];
		v50 = EpicSettings.Settings['useSentinel'];
		v51 = EpicSettings.Settings['avengingWrathWithCD'];
		v52 = EpicSettings.Settings['bastionofLightWithCD'];
		v53 = EpicSettings.Settings['divineTollWithCD'];
		v54 = EpicSettings.Settings['eyeofTyrWithCD'];
		v55 = EpicSettings.Settings['momentOfGloryWithCD'];
		v56 = EpicSettings.Settings['sentinelWithCD'];
	end
	local function v129()
		v57 = EpicSettings.Settings['useRebuke'];
		v58 = EpicSettings.Settings['useHammerofJustice'];
		v59 = EpicSettings.Settings['useArdentDefender'];
		v60 = EpicSettings.Settings['useDivineShield'];
		v61 = EpicSettings.Settings['useGuardianofAncientKings'];
		v62 = EpicSettings.Settings['useLayOnHands'];
		v63 = EpicSettings.Settings['useWordofGloryPlayer'];
		v64 = EpicSettings.Settings['useShieldoftheRighteous'];
		v65 = EpicSettings.Settings['useLayOnHandsFocus'];
		v66 = EpicSettings.Settings['useWordofGloryFocus'];
		v67 = EpicSettings.Settings['useWordofGloryMouseover'];
		v68 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v69 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v70 = EpicSettings.Settings['ardentDefenderHP'];
		v71 = EpicSettings.Settings['divineShieldHP'];
		v72 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v73 = EpicSettings.Settings['layonHandsHP'];
		v74 = EpicSettings.Settings['wordofGloryHP'];
		v75 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v76 = EpicSettings.Settings['layOnHandsFocusHP'];
		v77 = EpicSettings.Settings['wordofGloryFocusHP'];
		v78 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v79 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v80 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v81 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v82 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v130()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (1993 - (941 + 1052));
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v84 = EpicSettings.Settings['DispelDebuffs'];
		v83 = EpicSettings.Settings['DispelBuffs'];
		v91 = EpicSettings.Settings['useTrinkets'];
		v93 = EpicSettings.Settings['useRacials'];
		v92 = EpicSettings.Settings['trinketsWithCD'];
		v94 = EpicSettings.Settings['racialsWithCD'];
		v96 = EpicSettings.Settings['useHealthstone'];
		v95 = EpicSettings.Settings['useHealingPotion'];
		v98 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v97 = EpicSettings.Settings['healingPotionHP'] or (1514 - (822 + 692));
		v99 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['handleAfflicted'];
		v86 = EpicSettings.Settings['HandleIncorporeal'];
		v100 = EpicSettings.Settings['HealOOC'];
		v101 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v131()
		local v200 = 0 + 0;
		while true do
			if ((v200 == (301 - (45 + 252))) or ((4091 + 43) < (1352 + 2574))) then
				if (not v15:AffectingCombat() or ((398 - 234) >= (3218 - (114 + 319)))) then
					if ((v102.DevotionAura:IsCastable() and (v118()) and v36) or ((753 - 228) == (2701 - 592))) then
						if (((22 + 11) == (48 - 15)) and v25(v102.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (((6398 - 3344) <= (5978 - (556 + 1407))) and v85) then
					local v214 = 1206 - (741 + 465);
					while true do
						if (((2336 - (170 + 295)) < (1782 + 1600)) and ((0 + 0) == v214)) then
							if (((3183 - 1890) <= (1796 + 370)) and v81) then
								v31 = v112.HandleAfflicted(v102.CleanseToxins, v104.CleanseToxinsMouseover, 26 + 14);
								if (v31 or ((1461 + 1118) < (1353 - (957 + 273)))) then
									return v31;
								end
							end
							if ((v15:BuffUp(v102.ShiningLightFreeBuff) and v82) or ((227 + 619) >= (948 + 1420))) then
								local v222 = 0 - 0;
								while true do
									if ((v222 == (0 - 0)) or ((12254 - 8242) <= (16627 - 13269))) then
										v31 = v112.HandleAfflicted(v102.WordofGlory, v104.WordofGloryMouseover, 1820 - (389 + 1391), true);
										if (((938 + 556) <= (313 + 2692)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v86 or ((7082 - 3971) == (3085 - (783 + 168)))) then
					v31 = v112.HandleIncorporeal(v102.Repentance, v104.RepentanceMouseOver, 100 - 70, true);
					if (((2317 + 38) == (2666 - (309 + 2))) and v31) then
						return v31;
					end
					v31 = v112.HandleIncorporeal(v102.TurnEvil, v104.TurnEvilMouseOver, 92 - 62, true);
					if (v31 or ((1800 - (1090 + 122)) <= (141 + 291))) then
						return v31;
					end
				end
				v31 = v121();
				if (((16110 - 11313) >= (2666 + 1229)) and v31) then
					return v31;
				end
				v200 = 1123 - (628 + 490);
			end
			if (((642 + 2935) == (8855 - 5278)) and (v200 == (13 - 10))) then
				if (((4568 - (431 + 343)) > (7458 - 3765)) and v102.Redemption:IsCastable() and v102.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (v25(v104.RedemptionMouseover) or ((3688 - 2413) == (3240 + 860))) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((204 + 1387) >= (5275 - (556 + 1139)))) then
					if (((998 - (6 + 9)) <= (332 + 1476)) and v102.Intercession:IsCastable() and (v15:HolyPower() >= (2 + 1)) and v102.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v104.IntercessionMouseover) or ((2319 - (28 + 141)) <= (464 + 733))) then
							return "Intercession";
						end
					end
				end
				if (((4651 - 882) >= (831 + 342)) and (v15:AffectingCombat() or (v84 and v102.CleanseToxins:IsAvailable()))) then
					local v215 = 1317 - (486 + 831);
					local v216;
					while true do
						if (((3864 - 2379) == (5228 - 3743)) and (v215 == (1 + 0))) then
							if (v31 or ((10481 - 7166) <= (4045 - (668 + 595)))) then
								return v31;
							end
							break;
						end
						if ((v215 == (0 + 0)) or ((177 + 699) >= (8083 - 5119))) then
							v216 = v84 and v102.CleanseToxins:IsReady() and v35;
							v31 = v112.FocusUnit(v216, nil, 310 - (23 + 267), nil, 1969 - (1129 + 815), v102.FlashofLight);
							v215 = 388 - (371 + 16);
						end
					end
				end
				if ((v35 and v84) or ((3982 - (1326 + 424)) > (4729 - 2232))) then
					local v217 = 0 - 0;
					while true do
						if (((118 - (88 + 30)) == v217) or ((2881 - (720 + 51)) <= (738 - 406))) then
							v31 = v112.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1816 - (421 + 1355), 41 - 16, v102.FlashofLight, 1 + 1);
							if (((4769 - (286 + 797)) > (11595 - 8423)) and v31) then
								return v31;
							end
							v217 = 1 - 0;
						end
						if (((440 - (397 + 42)) == v217) or ((1398 + 3076) < (1620 - (24 + 776)))) then
							if (((6591 - 2312) >= (3667 - (222 + 563))) and v102.BlessingofFreedom:IsReady() and v112.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (v25(v104.BlessingofFreedomFocus) or ((4470 - 2441) >= (2536 + 985))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				if (v112.TargetIsValid() or v15:AffectingCombat() or ((2227 - (23 + 167)) >= (6440 - (690 + 1108)))) then
					v113 = v10.BossFightRemains(nil, true);
					v114 = v113;
					if (((621 + 1099) < (3678 + 780)) and (v114 == (11959 - (40 + 808)))) then
						v114 = v10.FightRemains(v108, false);
					end
					v115 = v15:HolyPower();
				end
				v200 = 1 + 3;
			end
			if ((v200 == (0 - 0)) or ((417 + 19) > (1599 + 1422))) then
				v129();
				v128();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v200 = 1 + 0;
			end
			if (((1284 - (47 + 524)) <= (550 + 297)) and (v200 == (5 - 3))) then
				if (((3220 - 1066) <= (9193 - 5162)) and v33) then
					local v218 = 1726 - (1165 + 561);
					while true do
						if (((138 + 4477) == (14293 - 9678)) and ((0 + 0) == v218)) then
							v110 = #v108;
							v111 = #v109;
							break;
						end
					end
				else
					v110 = 480 - (341 + 138);
					v111 = 1 + 0;
				end
				v106 = v15:ActiveMitigationNeeded();
				v107 = v15:IsTankingAoE(16 - 8) or v15:IsTanking(v17);
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((4116 - (89 + 237)) == (1608 - 1108))) then
					if (((187 - 98) < (1102 - (581 + 300))) and v102.CrusaderAura:IsCastable() and (v15:BuffDown(v102.CrusaderAura)) and v36) then
						if (((3274 - (855 + 365)) >= (3375 - 1954)) and v25(v102.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (((226 + 466) < (4293 - (1030 + 205))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (v15:AffectingCombat() or ((3055 + 199) == (1540 + 115))) then
						if (v102.Intercession:IsCastable() or ((1582 - (156 + 130)) == (11156 - 6246))) then
							if (((5676 - 2308) == (6897 - 3529)) and v25(v102.Intercession, not v17:IsInRange(8 + 22), true)) then
								return "intercession target";
							end
						end
					elseif (((1542 + 1101) < (3884 - (10 + 59))) and v102.Redemption:IsCastable()) then
						if (((542 + 1371) > (2427 - 1934)) and v25(v102.Redemption, not v17:IsInRange(1193 - (671 + 492)), true)) then
							return "redemption target";
						end
					end
				end
				v200 = 3 + 0;
			end
			if (((5970 - (369 + 846)) > (908 + 2520)) and (v200 == (6 + 0))) then
				if (((3326 - (1036 + 909)) <= (1884 + 485)) and v112.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
					local v219 = 0 - 0;
					while true do
						if ((v219 == (204 - (11 + 192))) or ((2448 + 2395) == (4259 - (135 + 40)))) then
							v31 = v127();
							if (((11312 - 6643) > (219 + 144)) and v31) then
								return v31;
							end
							v219 = 4 - 2;
						end
						if ((v219 == (2 - 0)) or ((2053 - (50 + 126)) >= (8737 - 5599))) then
							if (((1050 + 3692) >= (5039 - (1233 + 180))) and v25(v102.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v219 == (969 - (522 + 447))) or ((5961 - (107 + 1314)) == (426 + 490))) then
							if ((v90 < v114) or ((3522 - 2366) > (1846 + 2499))) then
								local v223 = 0 - 0;
								while true do
									if (((8850 - 6613) < (6159 - (716 + 1194))) and (v223 == (1 + 0))) then
										if ((v34 and v103.FyralathTheDreamrender:IsEquippedAndReady() and v37) or ((288 + 2395) < (526 - (74 + 429)))) then
											if (((1344 - 647) <= (410 + 416)) and v25(v104.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
									if (((2529 - 1424) <= (832 + 344)) and (v223 == (0 - 0))) then
										v31 = v126();
										if (((8354 - 4975) <= (4245 - (279 + 154))) and v31) then
											return v31;
										end
										v223 = 779 - (454 + 324);
									end
								end
							end
							if ((v91 and ((v34 and v92) or not v92) and v17:IsInRange(7 + 1)) or ((805 - (12 + 5)) >= (872 + 744))) then
								v31 = v122();
								if (((4723 - 2869) <= (1249 + 2130)) and v31) then
									return v31;
								end
							end
							v219 = 1094 - (277 + 816);
						end
					end
				end
				break;
			end
			if (((19438 - 14889) == (5732 - (1058 + 125))) and (v200 == (1 + 4))) then
				if ((v84 and v35) or ((3997 - (815 + 160)) >= (12974 - 9950))) then
					if (((11442 - 6622) > (525 + 1673)) and v14) then
						v31 = v120();
						if (v31 or ((3101 - 2040) >= (6789 - (41 + 1857)))) then
							return v31;
						end
					end
					if (((3257 - (1222 + 671)) <= (11560 - 7087)) and v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v112.UnitHasCurseDebuff(v16) or v112.UnitHasPoisonDebuff(v16) or v112.UnitHasDispellableDebuffByPlayer(v16))) then
						if (v102.CleanseToxins:IsReady() or ((5167 - 1572) <= (1185 - (229 + 953)))) then
							if (v25(v104.CleanseToxinsMouseover) or ((6446 - (1111 + 663)) == (5431 - (874 + 705)))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v31 = v124();
				if (((219 + 1340) == (1064 + 495)) and v31) then
					return v31;
				end
				if (v107 or ((3641 - 1889) <= (23 + 765))) then
					local v220 = 679 - (642 + 37);
					while true do
						if ((v220 == (0 + 0)) or ((626 + 3281) == (444 - 267))) then
							v31 = v123();
							if (((3924 - (233 + 221)) > (1283 - 728)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				if ((v112.TargetIsValid() and not v15:AffectingCombat() and v32) or ((856 + 116) == (2186 - (718 + 823)))) then
					v31 = v125();
					if (((2003 + 1179) >= (2920 - (266 + 539))) and v31) then
						return v31;
					end
				end
				v200 = 16 - 10;
			end
			if (((5118 - (636 + 589)) < (10512 - 6083)) and (v200 == (1 - 0))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((2272 + 595) < (693 + 1212))) then
					return v31;
				end
				v108 = v15:GetEnemiesInMeleeRange(1023 - (657 + 358));
				v109 = v15:GetEnemiesInRange(79 - 49);
				v200 = 4 - 2;
			end
		end
	end
	local function v132()
		local v201 = 1187 - (1151 + 36);
		while true do
			if ((v201 == (0 + 0)) or ((473 + 1323) >= (12097 - 8046))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v116();
				break;
			end
		end
	end
	v21.SetAPL(1898 - (1552 + 280), v131, v132);
end;
return v0["Epix_Paladin_Protection.lua"]();

