local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1740 - (343 + 1397);
	local v6;
	while true do
		if (((5669 - (1074 + 82)) >= (5973 - 3247)) and (v5 == (1784 - (214 + 1570)))) then
			v6 = v0[v4];
			if (not v6 or ((2936 - (990 + 465)) >= (1096 + 1562))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 + 0)) or ((12672 - 9452) == (3090 - (1668 + 58)))) then
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
	local v98 = v19.Paladin.Protection;
	local v99 = v20.Paladin.Protection;
	local v100 = v24.Paladin.Protection;
	local v101 = {};
	local v102;
	local v103;
	local v104, v105;
	local v106, v107;
	local v108 = v21.Commons.Everyone;
	local v109 = 11737 - (512 + 114);
	local v110 = 28967 - 17856;
	local v111 = 0 - 0;
	v10:RegisterForEvent(function()
		v109 = 38662 - 27551;
		v110 = 5169 + 5942;
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		if (v98.CleanseToxins:IsAvailable() or ((198 + 856) > (2949 + 443))) then
			v108.DispellableDebuffs = v13.MergeTable(v108.DispellableDiseaseDebuffs, v108.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v113(v129)
		return v129:DebuffRemains(v98.JudgmentDebuff);
	end
	local function v114()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local v115 = 0 - 0;
	local function v116()
		if ((v98.CleanseToxins:IsReady() and v108.DispellableFriendlyUnit(2019 - (109 + 1885))) or ((2145 - (1269 + 200)) >= (3146 - 1504))) then
			if (((4951 - (98 + 717)) > (3223 - (802 + 24))) and (v115 == (0 - 0))) then
				v115 = GetTime();
			end
			if (v108.Wait(631 - 131, v115) or ((641 + 3693) == (3262 + 983))) then
				local v211 = 0 + 0;
				while true do
					if ((v211 == (0 + 0)) or ((11895 - 7619) <= (10107 - 7076))) then
						if (v25(v100.CleanseToxinsFocus) or ((1711 + 3071) <= (489 + 710))) then
							return "cleanse_toxins dispel";
						end
						v115 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((3537 + 1327) < (889 + 1013))) then
			if (((6272 - (797 + 636)) >= (17964 - 14264)) and v98.FlashofLight:IsReady()) then
				if (v25(v98.FlashofLight) or ((2694 - (1427 + 192)) > (665 + 1253))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		v29 = v108.HandleTopTrinket(v101, v32, 92 - 52, nil);
		if (((356 + 40) <= (1724 + 2080)) and v29) then
			return v29;
		end
		v29 = v108.HandleBottomTrinket(v101, v32, 366 - (192 + 134), nil);
		if (v29 or ((5445 - (316 + 960)) == (1218 + 969))) then
			return v29;
		end
	end
	local function v119()
		if (((1086 + 320) == (1300 + 106)) and (v15:HealthPercentage() <= v67) and v56 and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
			if (((5852 - 4321) < (4822 - (83 + 468))) and v25(v98.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((2441 - (1202 + 604)) == (2964 - 2329)) and (v15:HealthPercentage() <= v69) and v58 and v98.LayonHands:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
			if (((5613 - 2240) <= (9845 - 6289)) and v25(v100.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v98.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v98.ArdentDefenderBuff)) or ((3616 - (45 + 280)) < (3166 + 114))) then
			if (((3832 + 554) >= (319 + 554)) and v25(v98.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((510 + 411) <= (194 + 908)) and v98.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v66) and v55 and v15:BuffDown(v98.GuardianofAncientKingsBuff)) then
			if (((8714 - 4008) >= (2874 - (340 + 1571))) and v25(v98.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v98.WordofGlory:IsReady() and (v15:HealthPercentage() <= v70) and v59 and not v15:HealingAbsorbed()) or ((379 + 581) <= (2648 - (1733 + 39)))) then
			if ((v15:BuffRemains(v98.ShieldoftheRighteousBuff) >= (13 - 8)) or v15:BuffUp(v98.DivinePurposeBuff) or v15:BuffUp(v98.ShiningLightFreeBuff) or ((3100 - (125 + 909)) == (2880 - (1096 + 852)))) then
				if (((2165 + 2660) < (6915 - 2072)) and v25(v100.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v98.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 + 0)) and v15:BuffRefreshable(v98.ShieldoftheRighteousBuff) and v60 and (v102 or (v15:HealthPercentage() <= v71))) or ((4389 - (409 + 103)) >= (4773 - (46 + 190)))) then
			if (v25(v98.ShieldoftheRighteous) or ((4410 - (51 + 44)) < (487 + 1239))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v99.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((4996 - (1114 + 203)) < (1351 - (228 + 498)))) then
			if (v25(v100.Healthstone) or ((1003 + 3622) < (350 + 282))) then
				return "healthstone defensive";
			end
		end
		if ((v91 and (v15:HealthPercentage() <= v93)) or ((746 - (174 + 489)) > (4637 - 2857))) then
			local v168 = 1905 - (830 + 1075);
			while true do
				if (((1070 - (303 + 221)) <= (2346 - (231 + 1038))) and (v168 == (0 + 0))) then
					if ((v95 == "Refreshing Healing Potion") or ((2158 - (171 + 991)) > (17725 - 13424))) then
						if (((10928 - 6858) > (1714 - 1027)) and v99.RefreshingHealingPotion:IsReady()) then
							if (v25(v100.RefreshingHealingPotion) or ((526 + 130) >= (11672 - 8342))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v95 == "Dreamwalker's Healing Potion") or ((7188 - 4696) <= (540 - 205))) then
						if (((13360 - 9038) >= (3810 - (111 + 1137))) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (v25(v100.RefreshingHealingPotion) or ((3795 - (91 + 67)) >= (11220 - 7450))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v120()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (524 - (423 + 100))) or ((17 + 2362) > (12675 - 8097))) then
				if (v14 or ((252 + 231) > (1514 - (326 + 445)))) then
					if (((10709 - 8255) > (1287 - 709)) and v98.WordofGlory:IsReady() and v62 and (v15:BuffUp(v98.ShiningLightFreeBuff) or (v111 >= (6 - 3))) and (v14:HealthPercentage() <= v73)) then
						if (((1641 - (530 + 181)) < (5339 - (614 + 267))) and v25(v100.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((694 - (19 + 13)) <= (1581 - 609)) and v98.LayonHands:IsCastable() and v61 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) then
						if (((10183 - 5813) == (12483 - 8113)) and v25(v100.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v98.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((1237 + 3525) <= (1514 - 653))) then
						if (v25(v100.BlessingofSacrificeFocus) or ((2927 - 1515) == (6076 - (1293 + 519)))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v98.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((6463 - 3295) < (5621 - 3468))) then
						if (v25(v100.BlessingofProtectionFocus) or ((9515 - 4539) < (5743 - 4411))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((10902 - 6274) == (2452 + 2176)) and (v130 == (0 + 0))) then
				if (v16:Exists() or ((125 - 71) == (92 + 303))) then
					if (((28 + 54) == (52 + 30)) and v98.WordofGlory:IsReady() and v63 and (v16:HealthPercentage() <= v74)) then
						if (v25(v100.WordofGloryMouseover) or ((1677 - (709 + 387)) < (2140 - (673 + 1185)))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(87 - 57) or ((14800 - 10191) < (4105 - 1610))) then
					return;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v121()
		if (((861 + 291) == (1554 - 402)) and (v86 < v110) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90)) then
			if (((466 + 1430) <= (6822 - 3400)) and v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v86 < v110) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (9 - 4))) or ((2870 - (446 + 1434)) > (2903 - (1040 + 243)))) then
			if (v25(v98.ArcaneTorrent, not v17:IsInRange(23 - 15)) or ((2724 - (559 + 1288)) > (6626 - (609 + 1322)))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((3145 - (13 + 441)) >= (6916 - 5065)) and v98.Consecration:IsCastable() and v36) then
			if (v25(v98.Consecration, not v17:IsInRange(20 - 12)) or ((14866 - 11881) >= (181 + 4675))) then
				return "consecration";
			end
		end
		if (((15529 - 11253) >= (425 + 770)) and v98.AvengersShield:IsCastable() and v34) then
			if (((1417 + 1815) <= (13917 - 9227)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield precombat 10";
			end
		end
		if ((v98.Judgment:IsReady() and v40) or ((491 + 405) >= (5785 - 2639))) then
			if (((2024 + 1037) >= (1646 + 1312)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v122()
		local v131 = 0 + 0;
		local v132;
		while true do
			if (((2676 + 511) >= (631 + 13)) and ((435 - (153 + 280)) == v131)) then
				v132 = v108.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff));
				if (((1859 - 1215) <= (633 + 71)) and v132) then
					return v132;
				end
				v131 = 2 + 1;
			end
			if (((502 + 456) > (860 + 87)) and ((0 + 0) == v131)) then
				if (((6839 - 2347) >= (1641 + 1013)) and v98.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (669 - (89 + 578))) and v15:HasTier(21 + 8, 3 - 1)) then
					if (((4491 - (572 + 477)) >= (203 + 1300)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90) and (v107 >= (2 + 0))) or ((379 + 2791) <= (1550 - (84 + 2)))) then
					if (v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment)) or ((7905 - 3108) == (3162 + 1226))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v131 = 843 - (497 + 345);
			end
			if (((15 + 536) <= (116 + 565)) and (v131 == (1337 - (605 + 728)))) then
				if (((2339 + 938) > (904 - 497)) and v98.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v98.AvengingWrathBuff) or (v98.AvengingWrath:CooldownRemains() <= (2 + 28)))) then
					if (((17358 - 12663) >= (1276 + 139)) and v25(v98.BastionofLight, not v17:IsInRange(21 - 13))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v131 == (1 + 0)) or ((3701 - (457 + 32)) <= (401 + 543))) then
				if ((v98.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((4498 - (832 + 570)) <= (1694 + 104))) then
					if (((923 + 2614) == (12516 - 8979)) and v25(v98.AvengingWrath, not v17:IsInRange(4 + 4))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((4633 - (588 + 208)) >= (4231 - 2661)) and v98.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) then
					if (v25(v98.Sentinel, not v17:IsInRange(1808 - (884 + 916))) or ((6176 - 3226) == (2211 + 1601))) then
						return "sentinel cooldowns 8";
					end
				end
				v131 = 655 - (232 + 421);
			end
			if (((6612 - (1569 + 320)) >= (569 + 1749)) and (v131 == (1 + 2))) then
				if ((v98.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v98.SentinelBuff) < (50 - 35)) or (((v10.CombatTime() > (615 - (316 + 289))) or (v98.Sentinel:CooldownRemains() > (39 - 24)) or (v98.AvengingWrath:CooldownRemains() > (1 + 14))) and (v98.AvengersShield:CooldownRemains() > (1453 - (666 + 787))) and (v98.Judgment:CooldownRemains() > (425 - (360 + 65))) and (v98.HammerofWrath:CooldownRemains() > (0 + 0))))) or ((2281 - (79 + 175)) > (4496 - 1644))) then
					if (v25(v98.MomentofGlory, not v17:IsInRange(7 + 1)) or ((3481 - 2345) > (8313 - 3996))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((5647 - (503 + 396)) == (4929 - (92 + 89))) and v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady() and (v106 >= (5 - 2))) then
					if (((1916 + 1820) <= (2806 + 1934)) and v25(v98.DivineToll, not v17:IsInRange(117 - 87))) then
						return "divine_toll cooldowns 12";
					end
				end
				v131 = 1 + 3;
			end
		end
	end
	local function v123()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 + 0)) or ((1620 + 1770) <= (9319 - 6259))) then
				if ((v98.Consecration:IsCastable() and v36 and (v15:BuffStack(v98.SanctificationBuff) == (1 + 4))) or ((1522 - 523) > (3937 - (485 + 759)))) then
					if (((1071 - 608) < (1790 - (442 + 747))) and v25(v98.Consecration, not v17:IsInRange(1143 - (832 + 303)))) then
						return "consecration standard 2";
					end
				end
				if ((v98.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (948 - (88 + 858))) or v15:BuffUp(v98.BastionofLightBuff) or v15:BuffUp(v98.DivinePurposeBuff)) and (v15:BuffDown(v98.SanctificationBuff) or (v15:BuffStack(v98.SanctificationBuff) < (2 + 3)))) or ((1807 + 376) < (29 + 658))) then
					if (((5338 - (766 + 23)) == (22457 - 17908)) and v25(v98.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((6389 - 1717) == (12308 - 7636)) and v98.Judgment:IsReady() and v40 and (v106 > (10 - 7)) and (v15:BuffStack(v98.BulwarkofRighteousFuryBuff) >= (1076 - (1036 + 37))) and (v15:HolyPower() < (3 + 0))) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (0 + 0)) or ((5148 - (641 + 839)) < (1308 - (910 + 3)))) then
							if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((10620 - 6454) == (2139 - (1466 + 218)))) then
								return "judgment standard 6";
							end
							if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((2045 + 2404) == (3811 - (556 + 592)))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (809 - (329 + 479))) or ((5131 - (174 + 680)) < (10270 - 7281))) then
				if ((v98.Judgment:IsReady() and v40 and v15:BuffDown(v98.SanctificationEmpowerBuff) and v15:HasTier(64 - 33, 2 + 0)) or ((1609 - (396 + 343)) >= (368 + 3781))) then
					local v214 = 1477 - (29 + 1448);
					while true do
						if (((3601 - (135 + 1254)) < (11991 - 8808)) and (v214 == (0 - 0))) then
							if (((3097 + 1549) > (4519 - (389 + 1138))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 8";
							end
							if (((2008 - (102 + 472)) < (2932 + 174)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if (((436 + 350) < (2819 + 204)) and v98.HammerofWrath:IsReady() and v39) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((3987 - (320 + 1225)) < (131 - 57))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((2775 + 1760) == (5999 - (157 + 1307))) and v98.Judgment:IsReady() and v40 and ((v98.Judgment:Charges() >= (1861 - (821 + 1038))) or (v98.Judgment:FullRechargeTime() <= v15:GCD()))) then
					local v215 = 0 - 0;
					while true do
						if ((v215 == (0 + 0)) or ((5344 - 2335) <= (784 + 1321))) then
							if (((4535 - 2705) < (4695 - (834 + 192))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 12";
							end
							if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((91 + 1339) >= (928 + 2684))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v133 = 1 + 1;
			end
			if (((4156 - 1473) >= (2764 - (300 + 4))) and ((1 + 2) == v133)) then
				if ((v98.HammerofWrath:IsReady() and v39) or ((4722 - 2918) >= (3637 - (112 + 250)))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((565 + 852) > (9091 - 5462))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((2747 + 2048) > (208 + 194)) and v98.Judgment:IsReady() and v40) then
					if (((3600 + 1213) > (1768 + 1797)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 22";
					end
					if (((2907 + 1005) == (5326 - (1001 + 413))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 22";
					end
				end
				if (((6290 - 3469) <= (5706 - (244 + 638))) and v98.Consecration:IsCastable() and v36 and v15:BuffDown(v98.ConsecrationBuff) and ((v15:BuffStack(v98.SanctificationBuff) < (698 - (627 + 66))) or not v15:HasTier(92 - 61, 604 - (512 + 90)))) then
					if (((3644 - (1665 + 241)) <= (2912 - (373 + 344))) and v25(v98.Consecration, not v17:IsInRange(4 + 4))) then
						return "consecration standard 24";
					end
				end
				v133 = 2 + 2;
			end
			if (((108 - 67) <= (5106 - 2088)) and ((1104 - (35 + 1064)) == v133)) then
				if (((1561 + 584) <= (8780 - 4676)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((11 + 2678) < (6081 - (298 + 938))) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and not v98.InmostLight:IsAvailable()) or ((3581 - (233 + 1026)) > (4288 - (636 + 1030)))) then
					if (v25(v98.EyeofTyr, not v17:IsInRange(5 + 3)) or ((4429 + 105) == (619 + 1463))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (1 + 4))) or ((1792 - (55 + 166)) > (362 + 1505))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(1 + 7)) or ((10135 - 7481) >= (3293 - (36 + 261)))) then
						return "arcane_torrent standard 36";
					end
				end
				v133 = 9 - 3;
			end
			if (((5346 - (34 + 1334)) > (809 + 1295)) and (v133 == (4 + 0))) then
				if (((4278 - (1035 + 248)) > (1562 - (20 + 1))) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and v98.InmostLight:IsAvailable() and (v106 >= (2 + 1))) then
					if (((3568 - (134 + 185)) > (2086 - (549 + 584))) and v25(v98.EyeofTyr, not v17:IsInRange(693 - (314 + 371)))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((v98.BlessedHammer:IsCastable() and v35) or ((11235 - 7962) > (5541 - (478 + 490)))) then
					if (v25(v98.BlessedHammer, not v17:IsInRange(5 + 3)) or ((4323 - (786 + 386)) < (4158 - 2874))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v98.HammeroftheRighteous:IsCastable() and v38) or ((3229 - (1055 + 324)) == (2869 - (1093 + 247)))) then
					if (((730 + 91) < (224 + 1899)) and v25(v98.HammeroftheRighteous, not v17:IsInRange(31 - 23))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v133 = 16 - 11;
			end
			if (((2566 - 1664) < (5842 - 3517)) and (v133 == (3 + 3))) then
				if (((3305 - 2447) <= (10209 - 7247)) and v98.Consecration:IsCastable() and v36 and (v15:BuffDown(v98.SanctificationEmpowerBuff))) then
					if (v25(v98.Consecration, not v17:IsInRange(7 + 1)) or ((10091 - 6145) < (1976 - (364 + 324)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v133 == (5 - 3)) or ((7779 - 4537) == (188 + 379))) then
				if ((v98.AvengersShield:IsCastable() and v34 and ((v107 > (8 - 6)) or v15:BuffUp(v98.MomentofGloryBuff))) or ((1355 - 508) >= (3835 - 2572))) then
					if (v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield)) or ((3521 - (1249 + 19)) == (1671 + 180))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady()) or ((8123 - 6036) > (3458 - (686 + 400)))) then
					if (v25(v98.DivineToll, not v17:IsInRange(24 + 6)) or ((4674 - (73 + 156)) < (20 + 4129))) then
						return "divine_toll standard 16";
					end
				end
				if ((v98.AvengersShield:IsCastable() and v34) or ((2629 - (721 + 90)) == (1 + 84))) then
					if (((2045 - 1415) < (2597 - (224 + 246))) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v133 = 4 - 1;
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (0 + 0)) or ((47 + 1891) == (1847 + 667))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v134 = 1 - 0;
			end
			if (((14159 - 9904) >= (568 - (203 + 310))) and (v134 == (1995 - (1238 + 755)))) then
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v42 = EpicSettings.Settings['useBastionofLight'];
				v134 = 1 + 2;
			end
			if (((4533 - (709 + 825)) > (2129 - 973)) and (v134 == (3 - 0))) then
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v134 = 868 - (196 + 668);
			end
			if (((9278 - 6928) > (2392 - 1237)) and (v134 == (839 - (171 + 662)))) then
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((4122 - (4 + 89)) <= (17009 - 12156)) and (v134 == (1 + 0))) then
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v134 = 8 - 6;
			end
			if ((v134 == (2 + 2)) or ((2002 - (35 + 1451)) > (4887 - (28 + 1425)))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v134 = 1998 - (941 + 1052);
			end
			if (((3880 + 166) >= (4547 - (822 + 692))) and (v134 == (6 - 1))) then
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v134 = 3 + 3;
			end
		end
	end
	local function v125()
		v53 = EpicSettings.Settings['useRebuke'];
		v54 = EpicSettings.Settings['useHammerofJustice'];
		v55 = EpicSettings.Settings['useArdentDefender'];
		v56 = EpicSettings.Settings['useDivineShield'];
		v57 = EpicSettings.Settings['useGuardianofAncientKings'];
		v58 = EpicSettings.Settings['useLayOnHands'];
		v59 = EpicSettings.Settings['useWordofGloryPlayer'];
		v60 = EpicSettings.Settings['useShieldoftheRighteous'];
		v61 = EpicSettings.Settings['useLayOnHandsFocus'];
		v62 = EpicSettings.Settings['useWordofGloryFocus'];
		v63 = EpicSettings.Settings['useWordofGloryMouseover'];
		v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v66 = EpicSettings.Settings['ardentDefenderHP'];
		v67 = EpicSettings.Settings['divineShieldHP'];
		v68 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v69 = EpicSettings.Settings['layonHandsHP'];
		v70 = EpicSettings.Settings['wordofGloryHP'];
		v71 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v72 = EpicSettings.Settings['layOnHandsFocusHP'];
		v73 = EpicSettings.Settings['wordofGloryFocusHP'];
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v126()
		local v161 = 297 - (45 + 252);
		while true do
			if ((v161 == (5 + 0)) or ((936 + 1783) <= (3521 - 2074))) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v161 = 439 - (114 + 319);
			end
			if ((v161 == (1 - 0)) or ((5296 - 1162) < (2503 + 1423))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v161 = 2 - 0;
			end
			if ((v161 == (8 - 4)) or ((2127 - (556 + 1407)) >= (3991 - (741 + 465)))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (465 - (170 + 295));
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v161 = 5 + 0;
			end
			if ((v161 == (7 - 4)) or ((436 + 89) == (1353 + 756))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v161 = 3 + 1;
			end
			if (((1263 - (957 + 273)) == (9 + 24)) and (v161 == (1 + 1))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v161 = 11 - 8;
			end
			if (((8047 - 4993) <= (12263 - 8248)) and ((29 - 23) == v161)) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (1780 - (389 + 1391));
				break;
			end
			if (((1174 + 697) < (353 + 3029)) and (v161 == (0 - 0))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (951 - (783 + 168));
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v161 = 3 - 2;
			end
		end
	end
	local function v127()
		v125();
		v124();
		v126();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((1272 + 21) <= (2477 - (309 + 2))) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v104 = v15:GetEnemiesInMeleeRange(24 - 16);
		v105 = v15:GetEnemiesInRange(1242 - (1090 + 122));
		if (v31 or ((837 + 1742) < (412 - 289))) then
			local v169 = 0 + 0;
			while true do
				if ((v169 == (1118 - (628 + 490))) or ((152 + 694) >= (5862 - 3494))) then
					v106 = #v104;
					v107 = #v105;
					break;
				end
			end
		else
			local v170 = 0 - 0;
			while true do
				if ((v170 == (774 - (431 + 343))) or ((8102 - 4090) <= (9714 - 6356))) then
					v106 = 1 + 0;
					v107 = 1 + 0;
					break;
				end
			end
		end
		v102 = v15:ActiveMitigationNeeded();
		v103 = v15:IsTankingAoE(1703 - (556 + 1139)) or v15:IsTanking(v17);
		if (((1509 - (6 + 9)) <= (551 + 2454)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) or ((1594 + 1517) == (2303 - (28 + 141)))) then
				if (((913 + 1442) == (2906 - 551)) and v25(v98.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((417 + 171) <= (1749 - (486 + 831)))) then
			if (((12482 - 7685) >= (13712 - 9817)) and v15:AffectingCombat()) then
				if (((676 + 2901) == (11310 - 7733)) and v98.Intercession:IsCastable()) then
					if (((5057 - (668 + 595)) > (3324 + 369)) and v25(v98.Intercession, not v17:IsInRange(7 + 23), true)) then
						return "intercession target";
					end
				end
			elseif (v98.Redemption:IsCastable() or ((3477 - 2202) == (4390 - (23 + 267)))) then
				if (v25(v98.Redemption, not v17:IsInRange(1974 - (1129 + 815)), true) or ((1978 - (371 + 16)) >= (5330 - (1326 + 424)))) then
					return "redemption target";
				end
			end
		end
		if (((1861 - 878) <= (6606 - 4798)) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v100.RedemptionMouseover) or ((2268 - (88 + 30)) <= (1968 - (720 + 51)))) then
				return "redemption mouseover";
			end
		end
		if (((8383 - 4614) >= (2949 - (421 + 1355))) and v15:AffectingCombat()) then
			if (((2449 - 964) == (730 + 755)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (1086 - (286 + 797))) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v100.IntercessionMouseover) or ((12118 - 8803) <= (4607 - 1825))) then
					return "Intercession";
				end
			end
		end
		if (v15:AffectingCombat() or (v80 and v98.CleanseToxins:IsAvailable()) or ((1315 - (397 + 42)) >= (926 + 2038))) then
			local v171 = 800 - (24 + 776);
			local v172;
			while true do
				if (((1 - 0) == v171) or ((3017 - (222 + 563)) > (5501 - 3004))) then
					if (v29 or ((1520 + 590) <= (522 - (23 + 167)))) then
						return v29;
					end
					break;
				end
				if (((5484 - (690 + 1108)) > (1145 + 2027)) and (v171 == (0 + 0))) then
					v172 = v80 and v98.CleanseToxins:IsReady() and v33;
					v29 = v108.FocusUnit(v172, v100, 868 - (40 + 808), nil, 5 + 20);
					v171 = 3 - 2;
				end
			end
		end
		if ((v33 and v80) or ((4277 + 197) < (434 + 386))) then
			local v173 = 0 + 0;
			while true do
				if (((4850 - (47 + 524)) >= (1871 + 1011)) and (v173 == (2 - 1))) then
					if ((v98.BlessingofFreedom:IsReady() and v108.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((3033 - 1004) >= (8030 - 4509))) then
						if (v25(v100.BlessingofFreedomFocus) or ((3763 - (1165 + 561)) >= (138 + 4504))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if (((5327 - 3607) < (1701 + 2757)) and (v173 == (479 - (341 + 138)))) then
					v29 = v108.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 11 + 29, 51 - 26);
					if (v29 or ((762 - (89 + 237)) > (9718 - 6697))) then
						return v29;
					end
					v173 = 1 - 0;
				end
			end
		end
		if (((1594 - (581 + 300)) <= (2067 - (855 + 365))) and (v108.TargetIsValid() or v15:AffectingCombat())) then
			local v174 = 0 - 0;
			while true do
				if (((704 + 1450) <= (5266 - (1030 + 205))) and (v174 == (1 + 0))) then
					if (((4294 + 321) == (4901 - (156 + 130))) and (v110 == (25246 - 14135))) then
						v110 = v10.FightRemains(v104, false);
					end
					v111 = v15:HolyPower();
					break;
				end
				if ((v174 == (0 - 0)) or ((7762 - 3972) == (132 + 368))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v174 = 1 + 0;
				end
			end
		end
		if (((158 - (10 + 59)) < (63 + 158)) and not v15:AffectingCombat()) then
			if (((10115 - 8061) >= (2584 - (671 + 492))) and v98.DevotionAura:IsCastable() and (v114())) then
				if (((551 + 141) < (4273 - (369 + 846))) and v25(v98.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v81 or ((862 + 2392) == (1413 + 242))) then
			if (v77 or ((3241 - (1036 + 909)) == (3904 + 1006))) then
				v29 = v108.HandleAfflicted(v98.CleanseToxins, v100.CleanseToxinsMouseover, 67 - 27);
				if (((3571 - (11 + 192)) == (1703 + 1665)) and v29) then
					return v29;
				end
			end
			if (((2818 - (135 + 40)) < (9243 - 5428)) and v15:BuffUp(v98.ShiningLightFreeBuff) and v78) then
				v29 = v108.HandleAfflicted(v98.WordofGlory, v100.WordofGloryMouseover, 25 + 15, true);
				if (((4213 - 2300) > (738 - 245)) and v29) then
					return v29;
				end
			end
		end
		if (((4931 - (50 + 126)) > (9545 - 6117)) and v82) then
			local v175 = 0 + 0;
			while true do
				if (((2794 - (1233 + 180)) <= (3338 - (522 + 447))) and (v175 == (1422 - (107 + 1314)))) then
					v29 = v108.HandleIncorporeal(v98.TurnEvil, v100.TurnEvilMouseOver, 14 + 16, true);
					if (v29 or ((14756 - 9913) == (1735 + 2349))) then
						return v29;
					end
					break;
				end
				if (((9271 - 4602) > (1436 - 1073)) and (v175 == (1910 - (716 + 1194)))) then
					v29 = v108.HandleIncorporeal(v98.Repentance, v100.RepentanceMouseOver, 1 + 29, true);
					if (v29 or ((202 + 1675) >= (3641 - (74 + 429)))) then
						return v29;
					end
					v175 = 1 - 0;
				end
			end
		end
		v29 = v117();
		if (((2351 + 2391) >= (8300 - 4674)) and v29) then
			return v29;
		end
		if ((v80 and v33) or ((3212 + 1328) == (2823 - 1907))) then
			if (v14 or ((2858 - 1702) > (4778 - (279 + 154)))) then
				local v212 = 778 - (454 + 324);
				while true do
					if (((1760 + 477) < (4266 - (12 + 5))) and (v212 == (0 + 0))) then
						v29 = v116();
						if (v29 or ((6835 - 4152) < (9 + 14))) then
							return v29;
						end
						break;
					end
				end
			end
			if (((1790 - (277 + 816)) <= (3529 - 2703)) and v16 and v16:Exists() and v16:IsAPlayer() and (v108.UnitHasCurseDebuff(v16) or v108.UnitHasPoisonDebuff(v16))) then
				if (((2288 - (1058 + 125)) <= (221 + 955)) and v98.CleanseToxins:IsReady()) then
					if (((4354 - (815 + 160)) <= (16355 - 12543)) and v25(v100.CleanseToxinsMouseover)) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v29 = v120();
		if (v29 or ((1870 - 1082) >= (386 + 1230))) then
			return v29;
		end
		if (((5419 - 3565) <= (5277 - (41 + 1857))) and v103) then
			local v176 = 1893 - (1222 + 671);
			while true do
				if (((11757 - 7208) == (6538 - 1989)) and (v176 == (1182 - (229 + 953)))) then
					v29 = v119();
					if (v29 or ((4796 - (1111 + 663)) >= (4603 - (874 + 705)))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((675 + 4145) > (1500 + 698)) and v108.TargetIsValid() and not v15:AffectingCombat() and v30) then
			v29 = v121();
			if (v29 or ((2205 - 1144) >= (138 + 4753))) then
				return v29;
			end
		end
		if (((2043 - (642 + 37)) <= (1020 + 3453)) and v108.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
			local v177 = 0 + 0;
			while true do
				if ((v177 == (4 - 2)) or ((4049 - (233 + 221)) <= (6 - 3))) then
					if (v25(v98.Pool) or ((4113 + 559) == (5393 - (718 + 823)))) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if (((982 + 577) == (2364 - (266 + 539))) and (v177 == (0 - 0))) then
					if ((v86 < v110) or ((2977 - (636 + 589)) <= (1870 - 1082))) then
						v29 = v122();
						if (v29 or ((8058 - 4151) == (141 + 36))) then
							return v29;
						end
						if (((1261 + 2209) > (1570 - (657 + 358))) and v32 and v99.FyralathTheDreamrender:IsEquippedAndReady()) then
							if (v25(v100.UseWeapon) or ((2573 - 1601) == (1469 - 824))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if (((4369 - (1151 + 36)) >= (2043 + 72)) and v87 and ((v32 and v88) or not v88) and v17:IsInRange(3 + 5)) then
						local v216 = 0 - 0;
						while true do
							if (((5725 - (1552 + 280)) < (5263 - (64 + 770))) and (v216 == (0 + 0))) then
								v29 = v118();
								if (v29 or ((6507 - 3640) < (339 + 1566))) then
									return v29;
								end
								break;
							end
						end
					end
					v177 = 1244 - (157 + 1086);
				end
				if ((v177 == (1 - 0)) or ((7865 - 6069) >= (6213 - 2162))) then
					v29 = v123();
					if (((2209 - 590) <= (4575 - (599 + 220))) and v29) then
						return v29;
					end
					v177 = 3 - 1;
				end
			end
		end
	end
	local function v128()
		v21.Print("Protection Paladin by Epic. Supported by xKaneto");
		v112();
	end
	v21.SetAPL(1997 - (1813 + 118), v127, v128);
end;
return v0["Epix_Paladin_Protection.lua"]();

