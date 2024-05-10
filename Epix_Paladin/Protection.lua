local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1149 + 1754) >= (2239 - (717 + 27))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((11869 - 7323) >= (1414 + 861)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1168 - (645 + 522);
		end
		if (((2609 - (1010 + 780)) >= (22 + 0)) and (v5 == (4 - 3))) then
			return v6(...);
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
	local v29;
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
	local v100 = v19.Paladin.Protection;
	local v101 = v20.Paladin.Protection;
	local v102 = v24.Paladin.Protection;
	local v103 = {};
	local v104;
	local v105;
	local v106, v107;
	local v108, v109;
	local v110 = v21.Commons.Everyone;
	local v111 = 32560 - 21449;
	local v112 = 12947 - (1045 + 791);
	local v113 = 0 - 0;
	v10:RegisterForEvent(function()
		v111 = 16965 - 5854;
		v112 = 11616 - (351 + 154);
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (((4736 - (1281 + 293)) == (3428 - (28 + 238))) and v100.CleanseToxins:IsAvailable()) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v131)
		return v131:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 0 - 0;
	local function v118()
		if ((v100.CleanseToxins:IsReady() and (v110.UnitHasDispellableDebuffByPlayer(v14) or v110.DispellableFriendlyUnit(1579 - (1381 + 178)) or v110.UnitHasCurseDebuff(v14) or v110.UnitHasPoisonDebuff(v14))) or ((2222 + 147) > (3572 + 857))) then
			local v183 = 0 + 0;
			while true do
				if (((14117 - 10022) >= (1649 + 1534)) and (v183 == (470 - (381 + 89)))) then
					if ((v117 == (0 + 0)) or ((2510 + 1201) < (1726 - 718))) then
						v117 = GetTime();
					end
					if (v110.Wait(1656 - (1074 + 82), v117) or ((2298 - 1249) <= (2690 - (214 + 1570)))) then
						if (((5968 - (990 + 465)) > (1124 + 1602)) and v25(v102.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v117 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((1441 + 40) >= (10460 - 7802))) then
			if (v100.FlashofLight:IsReady() or ((4946 - (1668 + 58)) == (1990 - (512 + 114)))) then
				if (v25(v100.FlashofLight) or ((2747 - 1693) > (7012 - 3620))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v132 = 0 - 0;
		while true do
			if (((1 + 0) == v132) or ((127 + 549) >= (1428 + 214))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 134 - 94, nil);
				if (((6130 - (109 + 1885)) > (3866 - (1269 + 200))) and v29) then
					return v29;
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((5149 - (98 + 717)) == (5071 - (802 + 24)))) then
				v29 = v110.HandleTopTrinket(v103, v32, 68 - 28, nil);
				if (v29 or ((5400 - 1124) <= (448 + 2583))) then
					return v29;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v121()
		if (((v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((786 + 3996) <= (259 + 940))) then
			if (v25(v100.DivineShield) or ((13531 - 8667) < (6342 - 4440))) then
				return "divine_shield defensive";
			end
		end
		if (((1731 + 3108) >= (1507 + 2193)) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (v25(v102.LayonHandsPlayer) or ((887 + 188) > (1395 + 523))) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((185 + 211) <= (5237 - (797 + 636))) and v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) then
			if (v25(v100.GuardianofAncientKings) or ((20241 - 16072) == (3806 - (1427 + 192)))) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((488 + 918) == (3264 - 1858)) and v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) then
			if (((1377 + 154) < (1936 + 2335)) and v25(v100.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if (((961 - (192 + 134)) == (1911 - (316 + 960))) and v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) then
			if (((1878 + 1495) <= (2745 + 811)) and ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (5 + 0)) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff))) then
				if (v25(v102.WordofGloryPlayer) or ((12581 - 9290) < (3831 - (83 + 468)))) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((6192 - (1202 + 604)) >= (4075 - 3202)) and v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 - 0)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) then
			if (((2549 - 1628) <= (1427 - (45 + 280))) and v25(v100.ShieldoftheRighteous)) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if (((4543 + 163) >= (842 + 121)) and v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) then
			if (v25(v102.Healthstone) or ((351 + 609) <= (485 + 391))) then
				return "healthstone defensive";
			end
		end
		if ((v93 and (v15:HealthPercentage() <= v95)) or ((364 + 1702) == (1725 - 793))) then
			local v184 = 1911 - (340 + 1571);
			while true do
				if (((1904 + 2921) < (6615 - (1733 + 39))) and (v184 == (0 - 0))) then
					if ((v97 == "Refreshing Healing Potion") or ((4911 - (125 + 909)) >= (6485 - (1096 + 852)))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((1936 + 2379) < (2464 - 738))) then
							if (v25(v102.RefreshingHealingPotion) or ((3569 + 110) < (1137 - (409 + 103)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((4861 - (46 + 190)) < (727 - (51 + 44)))) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((24 + 59) > (3097 - (1114 + 203)))) then
							if (((1272 - (228 + 498)) <= (234 + 843)) and v25(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		if (v16:Exists() or ((551 + 445) > (4964 - (174 + 489)))) then
			if (((10603 - 6533) > (2592 - (830 + 1075))) and v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) then
				if (v25(v102.WordofGloryMouseover) or ((1180 - (303 + 221)) >= (4599 - (231 + 1038)))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(25 + 5) or ((3654 - (171 + 991)) <= (1380 - 1045))) then
			return;
		end
		if (((11605 - 7283) >= (6393 - 3831)) and v14) then
			local v185 = 0 + 0;
			while true do
				if ((v185 == (0 - 0)) or ((10491 - 6854) >= (6077 - 2307))) then
					if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (9 - 6))) and (v14:HealthPercentage() <= v75)) or ((3627 - (111 + 1137)) > (4736 - (91 + 67)))) then
						if (v25(v102.WordofGloryFocus) or ((1437 - 954) > (186 + 557))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((2977 - (423 + 100)) > (5 + 573)) and v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) then
						if (((2575 - 1645) < (2324 + 2134)) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					v185 = 772 - (326 + 445);
				end
				if (((2888 - 2226) <= (2164 - 1192)) and (v185 == (2 - 1))) then
					if (((5081 - (530 + 181)) == (5251 - (614 + 267))) and v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) then
						if (v25(v102.BlessingofSacrificeFocus) or ((4794 - (19 + 13)) <= (1401 - 540))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) or ((3290 - 1878) == (12180 - 7916))) then
						if (v25(v102.BlessingofProtectionFocus) or ((823 + 2345) < (3785 - 1632))) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (1814 - (1293 + 519))) or ((10152 - 5176) < (3477 - 2145))) then
				if (((8849 - 4221) == (19956 - 15328)) and v100.Judgment:IsReady() and v42) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((127 - 73) == (210 + 185))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((17 + 65) == (190 - 108)) and (v133 == (1 + 0))) then
				if ((v100.Consecration:IsCastable() and v38) or ((194 + 387) < (177 + 105))) then
					if (v25(v100.Consecration, not v17:IsInRange(1104 - (709 + 387))) or ((6467 - (673 + 1185)) < (7235 - 4740))) then
						return "consecration precombat 8";
					end
				end
				if (((3698 - 2546) == (1894 - 742)) and v100.AvengersShield:IsCastable() and v36) then
					if (((1357 + 539) <= (2557 + 865)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
						if (v25(v102.AvengersShieldMouseover) or ((1336 - 346) > (398 + 1222))) then
							return "avengers_shield mouseover precombat 10";
						end
					end
					if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((1748 - 871) > (9216 - 4521))) then
						return "avengers_shield precombat 10";
					end
				end
				v133 = 1882 - (446 + 1434);
			end
			if (((3974 - (1040 + 243)) >= (5524 - 3673)) and (v133 == (1847 - (559 + 1288)))) then
				if (((v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) or ((4916 - (609 + 1322)) >= (5310 - (13 + 441)))) then
					if (((15978 - 11702) >= (3130 - 1935)) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((16096 - 12864) <= (175 + 4515)) and (v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (18 - 13))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(3 + 5)) or ((393 + 503) >= (9335 - 6189))) then
						return "arcane_torrent precombat 6";
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		local v135;
		while true do
			if (((2024 + 1037) >= (1646 + 1312)) and ((1 + 0) == v134)) then
				if (((2676 + 511) >= (631 + 13)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
					if (((1077 - (153 + 280)) <= (2032 - 1328)) and v25(v100.AvengingWrath, not v17:IsInRange(8 + 0))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((379 + 579) > (496 + 451)) and v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) then
					if (((4077 + 415) >= (1924 + 730)) and v25(v100.Sentinel, not v17:IsInRange(11 - 3))) then
						return "sentinel cooldowns 8";
					end
				end
				v134 = 2 + 0;
			end
			if (((4109 - (89 + 578)) >= (1074 + 429)) and (v134 == (3 - 1))) then
				v135 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
				if (v135 or ((4219 - (572 + 477)) <= (198 + 1266))) then
					return v135;
				end
				v134 = 2 + 1;
			end
			if ((v134 == (1 + 2)) or ((4883 - (84 + 2)) == (7231 - 2843))) then
				if (((397 + 154) <= (1523 - (497 + 345))) and v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (1 + 14)) or (((v10.CombatTime() > (2 + 8)) or (v100.Sentinel:CooldownRemains() > (1348 - (605 + 728))) or (v100.AvengingWrath:CooldownRemains() > (11 + 4))) and (v100.AvengersShield:CooldownRemains() > (0 - 0)) and (v100.Judgment:CooldownRemains() > (0 + 0)) and (v100.HammerofWrath:CooldownRemains() > (0 - 0))))) then
					if (((2955 + 322) > (1127 - 720)) and v25(v100.MomentOfGlory, not v17:IsInRange(7 + 1))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((5184 - (457 + 32)) >= (601 + 814)) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (1405 - (832 + 570)))) then
					if (v25(v100.DivineToll, not v17:IsInRange(29 + 1)) or ((838 + 2374) <= (3340 - 2396))) then
						return "divine_toll cooldowns 12";
					end
				end
				v134 = 2 + 2;
			end
			if (((796 - (588 + 208)) == v134) or ((8344 - 5248) <= (3598 - (884 + 916)))) then
				if (((7404 - 3867) == (2051 + 1486)) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (655 - (232 + 421))) and v15:HasTier(1918 - (1569 + 320), 1 + 1)) then
					if (((729 + 3108) >= (5290 - 3720)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
						if (v25(v102.AvengersShieldMouseover) or ((3555 - (316 + 289)) == (9978 - 6166))) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (((219 + 4504) >= (3771 - (666 + 787))) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (427 - (360 + 65)))) or ((1895 + 132) > (3106 - (79 + 175)))) then
					if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((1791 - 655) > (3369 + 948))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v134 = 2 - 1;
			end
			if (((9143 - 4395) == (5647 - (503 + 396))) and (v134 == (185 - (92 + 89)))) then
				if (((7247 - 3511) <= (2431 + 2309)) and v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (18 + 12)))) then
					if (v25(v100.BastionofLight, not v17:IsInRange(31 - 23)) or ((464 + 2926) <= (6977 - 3917))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
		end
	end
	local function v125()
		if ((v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (5 + 0))) or ((478 + 521) > (8201 - 5508))) then
			if (((58 + 405) < (916 - 315)) and v25(v100.Consecration, not v17:IsInRange(1252 - (485 + 759)))) then
				return "consecration standard 2";
			end
		end
		if ((v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (4 - 2)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (1194 - (442 + 747))))) or ((3318 - (832 + 303)) < (1633 - (88 + 858)))) then
			if (((1387 + 3162) == (3765 + 784)) and v25(v100.ShieldoftheRighteous)) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if (((193 + 4479) == (5461 - (766 + 23))) and v100.Judgment:IsReady() and v42 and (v108 > (14 - 11)) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (3 - 0)) and (v15:HolyPower() < (7 - 4))) then
			if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((12449 - 8781) < (1468 - (1036 + 37)))) then
				return "judgment standard 6";
			end
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2954 + 1212) == (886 - 431))) then
				return "judgment standard 6";
			end
		end
		if ((v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(25 + 6, 1482 - (641 + 839))) or ((5362 - (910 + 3)) == (6788 - 4125))) then
			local v186 = 1684 - (1466 + 218);
			while true do
				if ((v186 == (0 + 0)) or ((5425 - (556 + 592)) < (1063 + 1926))) then
					if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1678 - (329 + 479)) >= (5003 - (174 + 680)))) then
						return "judgment standard 8";
					end
					if (((7600 - 5388) < (6596 - 3413)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 8";
					end
					break;
				end
			end
		end
		if (((3318 + 1328) > (3731 - (396 + 343))) and v100.HammerofWrath:IsReady() and v41) then
			if (((127 + 1307) < (4583 - (29 + 1448))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((2175 - (135 + 1254)) < (11388 - 8365)) and v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (9 - 7)) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) then
			if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1628 + 814) < (1601 - (389 + 1138)))) then
				return "judgment standard 12";
			end
			if (((5109 - (102 + 472)) == (4280 + 255)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 12";
			end
		end
		if ((v100.AvengersShield:IsCastable() and v36 and ((v109 > (2 + 0)) or v15:BuffUp(v100.MomentOfGloryBuff))) or ((2806 + 203) <= (3650 - (320 + 1225)))) then
			local v187 = 0 - 0;
			while true do
				if (((1120 + 710) < (5133 - (157 + 1307))) and (v187 == (1859 - (821 + 1038)))) then
					if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) or ((3567 - 2137) >= (396 + 3216))) then
						if (((4765 - 2082) >= (916 + 1544)) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 14";
						end
					end
					if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((4471 - 2667) >= (4301 - (834 + 192)))) then
						return "avengers_shield standard 14";
					end
					break;
				end
			end
		end
		if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) or ((91 + 1326) > (932 + 2697))) then
			if (((103 + 4692) > (622 - 220)) and v25(v100.DivineToll, not v17:IsInRange(334 - (300 + 4)))) then
				return "divine_toll standard 16";
			end
		end
		if (((1286 + 3527) > (9332 - 5767)) and v100.AvengersShield:IsCastable() and v36) then
			if (((4274 - (112 + 250)) == (1560 + 2352)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
				if (((7067 - 4246) <= (2764 + 2060)) and v25(v102.AvengersShieldMouseover)) then
					return "avengers_shield mouseover standard 18";
				end
			end
			if (((899 + 839) <= (1642 + 553)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if (((21 + 20) <= (2243 + 775)) and v100.HammerofWrath:IsReady() and v41) then
			if (((3559 - (1001 + 413)) <= (9151 - 5047)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if (((3571 - (244 + 638)) < (5538 - (627 + 66))) and v100.Judgment:IsReady() and v42) then
			if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((6918 - 4596) > (3224 - (512 + 90)))) then
				return "judgment standard 22";
			end
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((6440 - (1665 + 241)) == (2799 - (373 + 344)))) then
				return "judgment standard 22";
			end
		end
		if ((v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (3 + 2)) or not v15:HasTier(9 + 22, 5 - 3))) or ((2658 - 1087) > (2966 - (35 + 1064)))) then
			if (v25(v100.Consecration, not v17:IsInRange(6 + 2)) or ((5677 - 3023) >= (12 + 2984))) then
				return "consecration standard 24";
			end
		end
		if (((5214 - (298 + 938)) > (3363 - (233 + 1026))) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (1669 - (636 + 1030)))) then
			if (((1532 + 1463) > (1506 + 35)) and v25(v100.EyeofTyr, not v17:IsInRange(3 + 5))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((220 + 3029) > (1174 - (55 + 166))) and v100.BlessedHammer:IsCastable() and v37) then
			if (v25(v100.BlessedHammer, not v17:IsInRange(2 + 6)) or ((330 + 2943) > (17464 - 12891))) then
				return "blessed_hammer standard 28";
			end
		end
		if ((v100.HammeroftheRighteous:IsCastable() and v40) or ((3448 - (36 + 261)) < (2245 - 961))) then
			if (v25(v100.HammeroftheRighteous, not v17:IsInRange(1376 - (34 + 1334))) or ((712 + 1138) == (1189 + 340))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((2104 - (1035 + 248)) < (2144 - (20 + 1))) and v100.CrusaderStrike:IsCastable() and v39) then
			if (((470 + 432) < (2644 - (134 + 185))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((1991 - (549 + 584)) <= (3647 - (314 + 371))) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) then
			if (v25(v100.EyeofTyr, not v17:IsInRange(27 - 19)) or ((4914 - (478 + 490)) < (683 + 605))) then
				return "eye_of_tyr standard 34";
			end
		end
		if ((v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1177 - (786 + 386)))) or ((10500 - 7258) == (1946 - (1055 + 324)))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(1348 - (1093 + 247))) or ((753 + 94) >= (133 + 1130))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) or ((8944 - 6691) == (6281 - 4430))) then
			if (v25(v100.Consecration, not v17:IsInRange(22 - 14)) or ((5244 - 3157) > (844 + 1528))) then
				return "consecration standard 38";
			end
		end
	end
	local function v126()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (17 - 12)) or ((3352 + 1093) < (10610 - 6461))) then
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v136 = 694 - (364 + 324);
			end
			if ((v136 == (0 - 0)) or ((4362 - 2544) == (29 + 56))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v136 = 4 - 3;
			end
			if (((1008 - 378) < (6459 - 4332)) and (v136 == (1271 - (1249 + 19)))) then
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v136 = 4 + 0;
			end
			if ((v136 == (7 - 5)) or ((3024 - (686 + 400)) == (1973 + 541))) then
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v42 = EpicSettings.Settings['useJudgment'];
				v136 = 232 - (73 + 156);
			end
			if (((21 + 4234) >= (866 - (721 + 90))) and (v136 == (1 + 5))) then
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((9737 - 6738) > (1626 - (224 + 246))) and (v136 == (1 - 0))) then
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v136 = 3 - 1;
			end
			if (((427 + 1923) > (28 + 1127)) and (v136 == (3 + 1))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v136 = 9 - 4;
			end
		end
	end
	local function v127()
		v55 = EpicSettings.Settings['useRebuke'];
		v56 = EpicSettings.Settings['useHammerofJustice'];
		v57 = EpicSettings.Settings['useArdentDefender'];
		v58 = EpicSettings.Settings['useDivineShield'];
		v59 = EpicSettings.Settings['useGuardianofAncientKings'];
		v60 = EpicSettings.Settings['useLayOnHands'];
		v61 = EpicSettings.Settings['useWordofGloryPlayer'];
		v62 = EpicSettings.Settings['useShieldoftheRighteous'];
		v63 = EpicSettings.Settings['useLayOnHandsFocus'];
		v64 = EpicSettings.Settings['useWordofGloryFocus'];
		v65 = EpicSettings.Settings['useWordofGloryMouseover'];
		v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v68 = EpicSettings.Settings['ardentDefenderHP'];
		v69 = EpicSettings.Settings['divineShieldHP'];
		v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v71 = EpicSettings.Settings['layonHandsHP'];
		v72 = EpicSettings.Settings['wordofGloryHP'];
		v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v74 = EpicSettings.Settings['layOnHandsFocusHP'];
		v75 = EpicSettings.Settings['wordofGloryFocusHP'];
		v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v128()
		v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v85 = EpicSettings.Settings['InterruptWithStun'];
		v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v87 = EpicSettings.Settings['InterruptThreshold'];
		v82 = EpicSettings.Settings['DispelDebuffs'];
		v81 = EpicSettings.Settings['DispelBuffs'];
		v89 = EpicSettings.Settings['useTrinkets'];
		v91 = EpicSettings.Settings['useRacials'];
		v90 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useHealthstone'];
		v93 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['healthstoneHP'] or (513 - (203 + 310));
		v95 = EpicSettings.Settings['healingPotionHP'] or (1993 - (1238 + 755));
		v97 = EpicSettings.Settings['HealingPotionName'] or "";
		v83 = EpicSettings.Settings['handleAfflicted'];
		v84 = EpicSettings.Settings['HandleIncorporeal'];
		v98 = EpicSettings.Settings['HealOOC'];
		v99 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v129()
		v127();
		v126();
		v128();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((5563 - (709 + 825)) <= (8942 - 4089)) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v106 = v15:GetEnemiesInMeleeRange(11 - 3);
		v107 = v15:GetEnemiesInRange(894 - (196 + 668));
		if (v31 or ((2037 - 1521) > (7112 - 3678))) then
			local v188 = 833 - (171 + 662);
			while true do
				if (((4139 - (4 + 89)) >= (10630 - 7597)) and (v188 == (0 + 0))) then
					v108 = #v106;
					v109 = #v107;
					break;
				end
			end
		else
			v108 = 4 - 3;
			v109 = 1 + 0;
		end
		v104 = v15:ActiveMitigationNeeded();
		v105 = v15:IsTankingAoE(1494 - (35 + 1451)) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((4172 - (28 + 1425)) <= (3440 - (941 + 1052)))) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) or ((3964 + 170) < (5440 - (822 + 692)))) then
				if (v25(v100.CrusaderAura) or ((233 - 69) >= (1312 + 1473))) then
					return "crusader_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((822 - (45 + 252)) == (2087 + 22))) then
			if (((12 + 21) == (80 - 47)) and v15:AffectingCombat()) then
				if (((3487 - (114 + 319)) <= (5764 - 1749)) and v100.Intercession:IsCastable()) then
					if (((2397 - 526) < (2156 + 1226)) and v25(v100.Intercession, not v17:IsInRange(44 - 14), true)) then
						return "intercession target";
					end
				end
			elseif (((2708 - 1415) <= (4129 - (556 + 1407))) and v100.Redemption:IsCastable()) then
				if (v25(v100.Redemption, not v17:IsInRange(1236 - (741 + 465)), true) or ((3044 - (170 + 295)) < (65 + 58))) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((778 + 68) >= (5830 - 3462))) then
			if (v25(v102.RedemptionMouseover) or ((3326 + 686) <= (2154 + 1204))) then
				return "redemption mouseover";
			end
		end
		if (((847 + 647) <= (4235 - (957 + 273))) and v15:AffectingCombat()) then
			if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (1 + 2)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1246 + 1865) == (8131 - 5997))) then
				if (((6205 - 3850) == (7193 - 4838)) and v25(v102.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()) or ((2911 - 2323) <= (2212 - (389 + 1391)))) then
			local v189 = v82 and v100.CleanseToxins:IsReady() and v33;
			v29 = v110.FocusUnit(v189, nil, 13 + 7, nil, 3 + 22, v100.FlashofLight);
			if (((10920 - 6123) >= (4846 - (783 + 168))) and v29) then
				return v29;
			end
		end
		if (((12005 - 8428) == (3519 + 58)) and v33 and v82) then
			local v190 = 311 - (309 + 2);
			while true do
				if (((11650 - 7856) > (4905 - (1090 + 122))) and (v190 == (1 + 0))) then
					if ((v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((4281 - 3006) == (2806 + 1294))) then
						if (v25(v102.BlessingofFreedomFocus) or ((2709 - (628 + 490)) >= (642 + 2938))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if (((2433 - 1450) <= (8262 - 6454)) and (v190 == (774 - (431 + 343)))) then
					v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 80 - 40, 72 - 47, v100.FlashofLight, 2 + 0);
					if (v29 or ((275 + 1875) <= (2892 - (556 + 1139)))) then
						return v29;
					end
					v190 = 16 - (6 + 9);
				end
			end
		end
		if (((691 + 3078) >= (601 + 572)) and (v110.TargetIsValid() or v15:AffectingCombat())) then
			local v191 = 169 - (28 + 141);
			while true do
				if (((576 + 909) == (1833 - 348)) and (v191 == (0 + 0))) then
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					v191 = 1318 - (486 + 831);
				end
				if ((v191 == (2 - 1)) or ((11670 - 8355) <= (526 + 2256))) then
					if ((v112 == (35132 - 24021)) or ((2139 - (668 + 595)) >= (2668 + 296))) then
						v112 = v10.FightRemains(v106, false);
					end
					v113 = v15:HolyPower();
					break;
				end
			end
		end
		if (not v15:AffectingCombat() or ((451 + 1781) > (6809 - 4312))) then
			if ((v100.DevotionAura:IsCastable() and (v116()) and v34) or ((2400 - (23 + 267)) <= (2276 - (1129 + 815)))) then
				if (((4073 - (371 + 16)) > (4922 - (1326 + 424))) and v25(v100.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v83 or ((8473 - 3999) < (2996 - 2176))) then
			if (((4397 - (88 + 30)) >= (3653 - (720 + 51))) and v79) then
				v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 88 - 48);
				if (v29 or ((3805 - (421 + 1355)) >= (5808 - 2287))) then
					return v29;
				end
			end
			if ((v15:BuffUp(v100.ShiningLightFreeBuff) and v80) or ((1001 + 1036) >= (5725 - (286 + 797)))) then
				v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 146 - 106, true);
				if (((2848 - 1128) < (4897 - (397 + 42))) and v29) then
					return v29;
				end
			end
		end
		if (v84 or ((137 + 299) > (3821 - (24 + 776)))) then
			v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 46 - 16, true);
			if (((1498 - (222 + 563)) <= (1865 - 1018)) and v29) then
				return v29;
			end
			v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 22 + 8, true);
			if (((2344 - (23 + 167)) <= (5829 - (690 + 1108))) and v29) then
				return v29;
			end
		end
		v29 = v119();
		if (((1666 + 2949) == (3807 + 808)) and v29) then
			return v29;
		end
		if ((v82 and v33) or ((4638 - (40 + 808)) == (83 + 417))) then
			local v192 = 0 - 0;
			while true do
				if (((86 + 3) < (117 + 104)) and (v192 == (0 + 0))) then
					if (((2625 - (47 + 524)) >= (923 + 498)) and v14) then
						v29 = v118();
						if (((1891 - 1199) < (4572 - 1514)) and v29) then
							return v29;
						end
					end
					if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16) or v110.UnitHasDispellableDebuffByPlayer(v16))) or ((7420 - 4166) == (3381 - (1165 + 561)))) then
						if (v100.CleanseToxins:IsReady() or ((39 + 1257) == (15207 - 10297))) then
							if (((1286 + 2082) == (3847 - (341 + 138))) and v25(v102.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v29 = v122();
		if (((714 + 1929) < (7873 - 4058)) and v29) then
			return v29;
		end
		if (((2239 - (89 + 237)) > (1585 - 1092)) and v105) then
			v29 = v121();
			if (((10010 - 5255) > (4309 - (581 + 300))) and v29) then
				return v29;
			end
		end
		if (((2601 - (855 + 365)) <= (5626 - 3257)) and v110.TargetIsValid() and not v15:AffectingCombat() and v30) then
			local v193 = 0 + 0;
			while true do
				if (((1235 - (1030 + 205)) == v193) or ((4547 + 296) == (3800 + 284))) then
					v29 = v123();
					if (((4955 - (156 + 130)) > (824 - 461)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) or ((3162 - 1285) >= (6426 - 3288))) then
			if (((1250 + 3492) >= (2115 + 1511)) and (v88 < v112)) then
				local v215 = 69 - (10 + 59);
				while true do
					if (((1 + 0) == v215) or ((22358 - 17818) == (2079 - (671 + 492)))) then
						if ((v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((921 + 235) > (5560 - (369 + 846)))) then
							if (((593 + 1644) < (3627 + 622)) and v25(v102.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
						break;
					end
					if ((v215 == (1945 - (1036 + 909))) or ((2134 + 549) < (38 - 15))) then
						v29 = v124();
						if (((900 - (11 + 192)) <= (418 + 408)) and v29) then
							return v29;
						end
						v215 = 176 - (135 + 40);
					end
				end
			end
			if (((2677 - 1572) <= (709 + 467)) and v89 and ((v32 and v90) or not v90) and v17:IsInRange(17 - 9)) then
				local v216 = 0 - 0;
				while true do
					if (((3555 - (50 + 126)) <= (10614 - 6802)) and ((0 + 0) == v216)) then
						v29 = v120();
						if (v29 or ((2201 - (1233 + 180)) >= (2585 - (522 + 447)))) then
							return v29;
						end
						break;
					end
				end
			end
			v29 = v125();
			if (((3275 - (107 + 1314)) <= (1568 + 1811)) and v29) then
				return v29;
			end
			if (((13860 - 9311) == (1933 + 2616)) and v25(v100.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v130()
		v21.Print("Protection Paladin by Epic. Supported by xKaneto");
		v114();
	end
	v21.SetAPL(130 - 64, v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

