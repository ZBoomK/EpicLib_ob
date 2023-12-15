local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 432 - (317 + 115);
	local v6;
	while true do
		if (((9134 - 4592) == (3703 + 839)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (826 - (802 + 24))) or ((4604 - 1934) < (2195 - 456))) then
			v6 = v0[v4];
			if (not v6 or ((50 + 282) >= (3076 + 927))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v96 = v19.Paladin.Protection;
	local v97 = v20.Paladin.Protection;
	local v98 = v24.Paladin.Protection;
	local v99 = {};
	local v100;
	local v101;
	local v102, v103;
	local v104, v105;
	local v106 = v21.Commons.Everyone;
	local v107 = 2397 + 8714;
	local v108 = 30910 - 19799;
	local v109 = 0 - 0;
	v10:RegisterForEvent(function()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (0 + 0)) or ((2715 + 576) <= (2385 + 895))) then
				v107 = 5188 + 5923;
				v108 = 12544 - (797 + 636);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		if (((21295 - 16909) >= (2492 - (1427 + 192))) and v96.CleanseToxins:IsAvailable()) then
			v106.DispellableDebuffs = v13.MergeTable(v106.DispellableDiseaseDebuffs, v106.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v110();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v111(v127)
		return v127:DebuffRemains(v96.JudgmentDebuff);
	end
	local function v112()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v113()
		if (((320 + 601) <= (2558 - 1456)) and v96.CleanseToxins:IsReady() and v33 and v106.DispellableFriendlyUnit(23 + 2)) then
			if (((2133 + 2573) >= (1289 - (192 + 134))) and v25(v98.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v114()
		if ((v94 and (v15:HealthPercentage() <= v95)) or ((2236 - (316 + 960)) <= (488 + 388))) then
			if (v96.FlashofLight:IsReady() or ((1595 + 471) == (862 + 70))) then
				if (((18445 - 13620) < (5394 - (83 + 468))) and v25(v96.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v128 = 1806 - (1202 + 604);
		while true do
			if ((v128 == (0 - 0)) or ((6452 - 2575) >= (12561 - 8024))) then
				v29 = v106.HandleTopTrinket(v99, v32, 365 - (45 + 280), nil);
				if (v29 or ((4165 + 150) < (1508 + 218))) then
					return v29;
				end
				v128 = 1 + 0;
			end
			if ((v128 == (1 + 0)) or ((648 + 3031) < (1157 - 532))) then
				v29 = v106.HandleBottomTrinket(v99, v32, 1951 - (340 + 1571), nil);
				if (v29 or ((1825 + 2800) < (2404 - (1733 + 39)))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v116()
		local v129 = 0 - 0;
		while true do
			if ((v129 == (1037 - (125 + 909))) or ((2031 - (1096 + 852)) > (799 + 981))) then
				if (((779 - 233) <= (1045 + 32)) and v97.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
					if (v25(v98.Healthstone) or ((1508 - (409 + 103)) > (4537 - (46 + 190)))) then
						return "healthstone defensive";
					end
				end
				if (((4165 - (51 + 44)) > (194 + 493)) and v89 and (v15:HealthPercentage() <= v91)) then
					local v201 = 1317 - (1114 + 203);
					while true do
						if ((v201 == (726 - (228 + 498))) or ((143 + 513) >= (1840 + 1490))) then
							if ((v93 == "Refreshing Healing Potion") or ((3155 - (174 + 489)) <= (872 - 537))) then
								if (((6227 - (830 + 1075)) >= (3086 - (303 + 221))) and v97.RefreshingHealingPotion:IsReady()) then
									if (v25(v98.RefreshingHealingPotion) or ((4906 - (231 + 1038)) >= (3142 + 628))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v93 == "Dreamwalker's Healing Potion") or ((3541 - (171 + 991)) > (18866 - 14288))) then
								if (v97.DreamwalkersHealingPotion:IsReady() or ((1296 - 813) > (1853 - 1110))) then
									if (((1965 + 489) > (2025 - 1447)) and v25(v98.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((2682 - 1752) < (7185 - 2727)) and (v129 == (0 - 0))) then
				if (((1910 - (111 + 1137)) <= (1130 - (91 + 67))) and (v15:HealthPercentage() <= v66) and v56 and v96.DivineShield:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
					if (((13006 - 8636) == (1091 + 3279)) and v25(v96.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((v15:HealthPercentage() <= v68) and v58 and v96.LayonHands:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((5285 - (423 + 100)) <= (7 + 854))) then
					if (v25(v98.LayonHandsPlayer) or ((3909 - 2497) == (2223 + 2041))) then
						return "lay_on_hands defensive 2";
					end
				end
				v129 = 772 - (326 + 445);
			end
			if ((v129 == (8 - 6)) or ((7057 - 3889) < (5024 - 2871))) then
				if ((v96.WordofGlory:IsReady() and (v15:HealthPercentage() <= v69) and v59 and not v15:HealingAbsorbed()) or ((5687 - (530 + 181)) < (2213 - (614 + 267)))) then
					if (((4660 - (19 + 13)) == (7532 - 2904)) and ((v15:BuffRemains(v96.ShieldoftheRighteousBuff) >= (11 - 6)) or v15:BuffUp(v96.DivinePurposeBuff) or v15:BuffUp(v96.ShiningLightFreeBuff))) then
						if (v25(v98.WordofGloryPlayer) or ((154 - 100) == (103 + 292))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((143 - 61) == (169 - 87)) and v96.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (1814 - (1293 + 519))) and v15:BuffRefreshable(v96.ShieldoftheRighteousBuff) and v60 and (v100 or (v15:HealthPercentage() <= v70))) then
					if (v25(v96.ShieldoftheRighteous) or ((1185 - 604) < (736 - 454))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v129 = 5 - 2;
			end
			if ((v129 == (4 - 3)) or ((10857 - 6248) < (1322 + 1173))) then
				if (((236 + 916) == (2676 - 1524)) and v96.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v67) and v57 and v15:BuffDown(v96.ArdentDefenderBuff)) then
					if (((439 + 1457) <= (1137 + 2285)) and v25(v96.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v96.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v65) and v55 and v15:BuffDown(v96.GuardianofAncientKingsBuff)) or ((619 + 371) > (2716 - (709 + 387)))) then
					if (v25(v96.ArdentDefender) or ((2735 - (673 + 1185)) > (13616 - 8921))) then
						return "ardent_defender defensive 6";
					end
				end
				v129 = 6 - 4;
			end
		end
	end
	local function v117()
		local v130 = 0 - 0;
		while true do
			if (((1925 + 766) >= (1384 + 467)) and (v130 == (0 - 0))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(8 + 22) or ((5951 - 2966) >= (9531 - 4675))) then
					return;
				end
				if (((6156 - (446 + 1434)) >= (2478 - (1040 + 243))) and v14) then
					local v202 = 0 - 0;
					while true do
						if (((5079 - (559 + 1288)) <= (6621 - (609 + 1322))) and (v202 == (454 - (13 + 441)))) then
							if ((v96.WordofGlory:IsReady() and v62 and v15:BuffUp(v96.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v72)) or ((3347 - 2451) >= (8240 - 5094))) then
								if (((15245 - 12184) >= (111 + 2847)) and v25(v98.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if (((11574 - 8387) >= (229 + 415)) and v96.LayonHands:IsCastable() and v61 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) then
								if (((283 + 361) <= (2089 - 1385)) and v25(v98.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v202 = 1 + 0;
						end
						if (((1761 - 803) > (627 + 320)) and (v202 == (1 + 0))) then
							if (((3228 + 1264) >= (2229 + 425)) and v96.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) then
								if (((3368 + 74) >= (1936 - (153 + 280))) and v25(v98.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v96.BlessingofProtection:IsCastable() and v63 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) or ((9153 - 5983) <= (1315 + 149))) then
								if (v25(v98.BlessingofProtectionFocus) or ((1895 + 2902) == (2297 + 2091))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v131 = 0 + 0;
		while true do
			if (((400 + 151) <= (1036 - 355)) and (v131 == (1 + 0))) then
				if (((3944 - (89 + 578)) > (291 + 116)) and v96.Consecration:IsCastable() and v36) then
					if (((9760 - 5065) >= (2464 - (572 + 477))) and v25(v96.Consecration, not v17:IsInRange(2 + 6))) then
						return "consecration";
					end
				end
				if ((v96.AvengersShield:IsCastable() and v34) or ((1928 + 1284) <= (113 + 831))) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((3182 - (84 + 2)) <= (2963 - 1165))) then
						return "avengers_shield precombat 10";
					end
				end
				v131 = 2 + 0;
			end
			if (((4379 - (497 + 345)) == (91 + 3446)) and (v131 == (1 + 1))) then
				if (((5170 - (605 + 728)) >= (1121 + 449)) and v96.Judgment:IsReady() and v40) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((6558 - 3608) == (175 + 3637))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((17461 - 12738) >= (2090 + 228)) and (v131 == (0 - 0))) then
				if (((v84 < v108) and v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88)) or ((1531 + 496) > (3341 - (457 + 32)))) then
					if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or ((482 + 654) > (5719 - (832 + 570)))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((4474 + 274) == (1239 + 3509)) and (v84 < v108) and v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (17 - 12))) then
					if (((1800 + 1936) <= (5536 - (588 + 208))) and v25(v96.ArcaneTorrent, not v17:IsInRange(21 - 13))) then
						return "arcane_torrent precombat 6";
					end
				end
				v131 = 1801 - (884 + 916);
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		local v133;
		while true do
			if ((v132 == (2 + 1)) or ((4043 - (232 + 421)) <= (4949 - (1569 + 320)))) then
				if ((v96.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v96.SentinelBuff) < (4 + 11)) or (((v10.CombatTime() > (2 + 8)) or (v96.Sentinel:CooldownRemains() > (50 - 35)) or (v96.AvengingWrath:CooldownRemains() > (620 - (316 + 289)))) and (v96.AvengersShield:CooldownRemains() > (0 - 0)) and (v96.Judgment:CooldownRemains() > (0 + 0)) and (v96.HammerofWrath:CooldownRemains() > (1453 - (666 + 787)))))) or ((1424 - (360 + 65)) > (2517 + 176))) then
					if (((717 - (79 + 175)) < (947 - 346)) and v25(v96.MomentofGlory, not v17:IsInRange(7 + 1))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady() and (v104 >= (8 - 5))) or ((4204 - 2021) < (1586 - (503 + 396)))) then
					if (((4730 - (92 + 89)) == (8824 - 4275)) and v25(v96.DivineToll, not v17:IsInRange(16 + 14))) then
						return "divine_toll cooldowns 12";
					end
				end
				v132 = 3 + 1;
			end
			if (((18295 - 13623) == (639 + 4033)) and (v132 == (2 - 1))) then
				if ((v96.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((3201 + 467) < (189 + 206))) then
					if (v25(v96.AvengingWrath, not v17:IsInRange(24 - 16)) or ((520 + 3646) == (693 - 238))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v96.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) or ((5693 - (485 + 759)) == (6161 - 3498))) then
					if (v25(v96.Sentinel, not v17:IsInRange(1197 - (442 + 747))) or ((5412 - (832 + 303)) < (3935 - (88 + 858)))) then
						return "sentinel cooldowns 8";
					end
				end
				v132 = 1 + 1;
			end
			if ((v132 == (0 + 0)) or ((36 + 834) >= (4938 - (766 + 23)))) then
				if (((10920 - 8708) < (4352 - 1169)) and v96.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (4 - 2)) and v15:HasTier(98 - 69, 1075 - (1036 + 37))) then
					if (((3294 + 1352) > (5826 - 2834)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if (((1129 + 305) < (4586 - (641 + 839))) and v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88) and (v105 >= (915 - (910 + 3)))) then
					if (((2003 - 1217) < (4707 - (1466 + 218))) and v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (1150 - (556 + 592))) or ((869 + 1573) < (882 - (329 + 479)))) then
				v133 = v106.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff));
				if (((5389 - (174 + 680)) == (15583 - 11048)) and v133) then
					return v133;
				end
				v132 = 5 - 2;
			end
			if ((v132 == (3 + 1)) or ((3748 - (396 + 343)) <= (187 + 1918))) then
				if (((3307 - (29 + 1448)) < (5058 - (135 + 1254))) and v96.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v96.AvengingWrathBuff) or (v96.AvengingWrath:CooldownRemains() <= (113 - 83)))) then
					if (v25(v96.BastionofLight, not v17:IsInRange(37 - 29)) or ((954 + 476) >= (5139 - (389 + 1138)))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
		end
	end
	local function v120()
		if (((3257 - (102 + 472)) >= (2322 + 138)) and v96.Consecration:IsCastable() and v36 and (v15:BuffStack(v96.SanctificationBuff) == (3 + 2))) then
			if (v25(v96.Consecration, not v17:IsInRange(8 + 0)) or ((3349 - (320 + 1225)) >= (5830 - 2555))) then
				return "consecration standard 2";
			end
		end
		if ((v96.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (2 + 0)) or v15:BuffUp(v96.BastionofLightBuff) or v15:BuffUp(v96.DivinePurposeBuff)) and (v15:BuffDown(v96.SanctificationBuff) or (v15:BuffStack(v96.SanctificationBuff) < (1469 - (157 + 1307))))) or ((3276 - (821 + 1038)) > (9054 - 5425))) then
			if (((525 + 4270) > (713 - 311)) and v25(v96.ShieldoftheRighteous)) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if (((1791 + 3022) > (8836 - 5271)) and v96.Judgment:IsReady() and v40 and (v104 > (1029 - (834 + 192))) and (v15:BuffStack(v96.BulwarkofRighteousFuryBuff) >= (1 + 2)) and (v15:HolyPower() < (1 + 2))) then
			local v176 = 0 + 0;
			while true do
				if (((6059 - 2147) == (4216 - (300 + 4))) and ((0 + 0) == v176)) then
					if (((7384 - 4563) <= (5186 - (112 + 250))) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 6";
					end
					if (((693 + 1045) <= (5499 - 3304)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 6";
					end
					break;
				end
			end
		end
		if (((24 + 17) <= (1561 + 1457)) and v96.Judgment:IsReady() and v40 and v15:BuffDown(v96.SanctificationEmpowerBuff) and v15:HasTier(24 + 7, 1 + 1)) then
			if (((1594 + 551) <= (5518 - (1001 + 413))) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment standard 8";
			end
			if (((5996 - 3307) < (5727 - (244 + 638))) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment standard 8";
			end
		end
		if ((v96.HammerofWrath:IsReady() and v39) or ((3015 - (627 + 66)) > (7812 - 5190))) then
			if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((5136 - (512 + 90)) == (3988 - (1665 + 241)))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if ((v96.Judgment:IsReady() and v40 and ((v96.Judgment:Charges() >= (719 - (373 + 344))) or (v96.Judgment:FullRechargeTime() <= v15:GCD()))) or ((709 + 862) > (494 + 1373))) then
			local v177 = 0 - 0;
			while true do
				if ((v177 == (0 - 0)) or ((3753 - (35 + 1064)) >= (2180 + 816))) then
					if (((8510 - 4532) > (9 + 2095)) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 12";
					end
					if (((4231 - (298 + 938)) > (2800 - (233 + 1026))) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 12";
					end
					break;
				end
			end
		end
		if (((4915 - (636 + 1030)) > (488 + 465)) and v96.AvengersShield:IsCastable() and v34 and ((v105 > (2 + 0)) or v15:BuffUp(v96.MomentofGloryBuff))) then
			if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((973 + 2300) > (309 + 4264))) then
				return "avengers_shield standard 14";
			end
		end
		if ((v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady()) or ((3372 - (55 + 166)) < (249 + 1035))) then
			if (v25(v96.DivineToll, not v17:IsInRange(4 + 26)) or ((7065 - 5215) == (1826 - (36 + 261)))) then
				return "divine_toll standard 16";
			end
		end
		if (((1435 - 614) < (3491 - (34 + 1334))) and v96.AvengersShield:IsCastable() and v34) then
			if (((347 + 555) < (1807 + 518)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if (((2141 - (1035 + 248)) <= (2983 - (20 + 1))) and v96.HammerofWrath:IsReady() and v39) then
			if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((2056 + 1890) < (1607 - (134 + 185)))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if ((v96.Judgment:IsReady() and v40) or ((4375 - (549 + 584)) == (1252 - (314 + 371)))) then
			if (v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment)) or ((2907 - 2060) >= (2231 - (478 + 490)))) then
				return "judgment standard 22";
			end
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((1194 + 1059) == (3023 - (786 + 386)))) then
				return "judgment standard 22";
			end
		end
		if ((v96.Consecration:IsCastable() and v36 and v15:BuffDown(v96.ConsecrationBuff) and ((v15:BuffStack(v96.SanctificationBuff) < (16 - 11)) or not v15:HasTier(1410 - (1055 + 324), 1342 - (1093 + 247)))) or ((1855 + 232) > (250 + 2122))) then
			if (v25(v96.Consecration, not v17:IsInRange(31 - 23)) or ((15085 - 10640) < (11805 - 7656))) then
				return "consecration standard 24";
			end
		end
		if (((v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and v96.InmostLight:IsAvailable() and (v104 >= (7 - 4))) or ((647 + 1171) == (327 - 242))) then
			if (((2171 - 1541) < (1604 + 523)) and v25(v96.EyeofTyr, not v17:IsInRange(20 - 12))) then
				return "eye_of_tyr standard 26";
			end
		end
		if ((v96.BlessedHammer:IsCastable() and v35) or ((2626 - (364 + 324)) == (6891 - 4377))) then
			if (((10210 - 5955) >= (19 + 36)) and v25(v96.BlessedHammer, not v17:IsInRange(33 - 25))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((4802 - 1803) > (3510 - 2354)) and v96.HammeroftheRighteous:IsCastable() and v38) then
			if (((3618 - (1249 + 19)) > (1043 + 112)) and v25(v96.HammeroftheRighteous, not v17:IsInRange(31 - 23))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((5115 - (686 + 400)) <= (3808 + 1045)) and v96.CrusaderStrike:IsCastable() and v37) then
			if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or ((745 - (73 + 156)) > (17 + 3417))) then
				return "crusader_strike standard 32";
			end
		end
		if (((4857 - (721 + 90)) >= (35 + 2998)) and (v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and not v96.InmostLight:IsAvailable()) then
			if (v25(v96.EyeofTyr, not v17:IsInRange(25 - 17)) or ((3189 - (224 + 246)) <= (2343 - 896))) then
				return "eye_of_tyr standard 34";
			end
		end
		if ((v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (9 - 4))) or ((750 + 3384) < (94 + 3832))) then
			if (v25(v96.ArcaneTorrent, not v17:IsInRange(6 + 2)) or ((325 - 161) >= (9267 - 6482))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v96.Consecration:IsCastable() and v36 and (v15:BuffDown(v96.SanctificationEmpowerBuff))) or ((1038 - (203 + 310)) == (4102 - (1238 + 755)))) then
			if (((3 + 30) == (1567 - (709 + 825))) and v25(v96.Consecration, not v17:IsInRange(14 - 6))) then
				return "consecration standard 38";
			end
		end
	end
	local function v121()
		local v134 = 0 - 0;
		while true do
			if (((3918 - (196 + 668)) <= (15852 - 11837)) and (v134 == (0 - 0))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v134 = 834 - (171 + 662);
			end
			if (((1964 - (4 + 89)) < (11853 - 8471)) and ((1 + 0) == v134)) then
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v134 = 8 - 6;
			end
			if (((508 + 785) <= (3652 - (35 + 1451))) and (v134 == (1457 - (28 + 1425)))) then
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v134 == (1996 - (941 + 1052))) or ((2473 + 106) < (1637 - (822 + 692)))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v134 = 5 - 1;
			end
			if ((v134 == (1 + 1)) or ((1143 - (45 + 252)) >= (2343 + 25))) then
				v42 = EpicSettings.Settings['useBastionofLight'];
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v134 = 2 + 1;
			end
		end
	end
	local function v122()
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
		v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v65 = EpicSettings.Settings['ardentDefenderHP'];
		v66 = EpicSettings.Settings['divineShieldHP'];
		v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v68 = EpicSettings.Settings['layonHandsHP'];
		v69 = EpicSettings.Settings['wordofGloryHP'];
		v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v71 = EpicSettings.Settings['layOnHandsFocusHP'];
		v72 = EpicSettings.Settings['wordofGloryFocusHP'];
		v73 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v123()
		v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v81 = EpicSettings.Settings['InterruptWithStun'];
		v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v83 = EpicSettings.Settings['InterruptThreshold'];
		v78 = EpicSettings.Settings['DispelDebuffs'];
		v77 = EpicSettings.Settings['DispelBuffs'];
		v85 = EpicSettings.Settings['useTrinkets'];
		v87 = EpicSettings.Settings['useRacials'];
		v86 = EpicSettings.Settings['trinketsWithCD'];
		v88 = EpicSettings.Settings['racialsWithCD'];
		v90 = EpicSettings.Settings['useHealthstone'];
		v89 = EpicSettings.Settings['useHealingPotion'];
		v92 = EpicSettings.Settings['healthstoneHP'] or (433 - (114 + 319));
		v91 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v93 = EpicSettings.Settings['HealingPotionName'] or "";
		v79 = EpicSettings.Settings['handleAfflicted'];
		v80 = EpicSettings.Settings['HandleIncorporeal'];
		v94 = EpicSettings.Settings['HealOOC'];
		v95 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v124()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (2 - 0)) or ((8405 - 4393) <= (5321 - (556 + 1407)))) then
				v33 = EpicSettings.Toggles['dispel'];
				if (((2700 - (741 + 465)) <= (3470 - (170 + 295))) and v15:IsDeadOrGhost()) then
					return v29;
				end
				v102 = v15:GetEnemiesInMeleeRange(5 + 3);
				v173 = 3 + 0;
			end
			if ((v173 == (9 - 5)) or ((2579 + 532) == (1369 + 765))) then
				v101 = v15:IsTankingAoE(5 + 3) or v15:IsTanking(v17);
				if (((3585 - (957 + 273)) == (630 + 1725)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((v96.CrusaderAura:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) or ((236 + 352) <= (1646 - 1214))) then
						if (((12641 - 7844) >= (11897 - 8002)) and v25(v96.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (((17712 - 14135) == (5357 - (389 + 1391))) and (v15:AffectingCombat() or v78)) then
					local v203 = v78 and v96.CleanseToxins:IsReady() and v33;
					v29 = v106.FocusUnit(v203, v98, 13 + 7, nil, 3 + 22);
					if (((8637 - 4843) > (4644 - (783 + 168))) and v29) then
						return v29;
					end
				end
				v173 = 16 - 11;
			end
			if ((v173 == (1 + 0)) or ((1586 - (309 + 2)) == (12590 - 8490))) then
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v173 = 1214 - (1090 + 122);
			end
			if ((v173 == (2 + 3)) or ((5343 - 3752) >= (2451 + 1129))) then
				if (((2101 - (628 + 490)) <= (325 + 1483)) and v33) then
					local v204 = 0 - 0;
					local v205;
					while true do
						if ((v204 == (9 - 7)) or ((2924 - (431 + 343)) <= (2416 - 1219))) then
							if (((10903 - 7134) >= (927 + 246)) and v96.BlessingofFreedom:IsReady() and v106.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (((190 + 1295) == (3180 - (556 + 1139))) and v25(v98.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if ((v204 == (15 - (6 + 9))) or ((607 + 2708) <= (1426 + 1356))) then
							v29 = v106.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 209 - (28 + 141), 10 + 15);
							if (v29 or ((1081 - 205) >= (2100 + 864))) then
								return v29;
							end
							v204 = 1318 - (486 + 831);
						end
						if ((v204 == (2 - 1)) or ((7857 - 5625) > (472 + 2025))) then
							v205 = v106.LowestFriendlyUnit(126 - 86, "TANK", 1288 - (668 + 595));
							if ((v96.BlessingofFreedom:IsReady() and v106.UnitHasDebuffFromList(v205, v19.Paladin.FreedomDebuffTankList) and v106.FocusSpecifiedUnit(v205, 36 + 4)) or ((426 + 1684) <= (905 - 573))) then
								if (((3976 - (23 + 267)) > (5116 - (1129 + 815))) and v25(v98.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							v204 = 389 - (371 + 16);
						end
					end
				end
				if (v106.TargetIsValid() or v15:AffectingCombat() or ((6224 - (1326 + 424)) < (1553 - 733))) then
					local v206 = 0 - 0;
					while true do
						if (((4397 - (88 + 30)) >= (3653 - (720 + 51))) and (v206 == (0 - 0))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v206 = 1777 - (421 + 1355);
						end
						if ((v206 == (1 - 0)) or ((997 + 1032) >= (4604 - (286 + 797)))) then
							if ((v108 == (40617 - 29506)) or ((3373 - 1336) >= (5081 - (397 + 42)))) then
								v108 = v10.FightRemains(v102, false);
							end
							v109 = v15:HolyPower();
							break;
						end
					end
				end
				if (((538 + 1182) < (5258 - (24 + 776))) and not v15:AffectingCombat()) then
					if ((v96.DevotionAura:IsCastable() and (v112())) or ((671 - 235) > (3806 - (222 + 563)))) then
						if (((1570 - 857) <= (610 + 237)) and v25(v96.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				v173 = 196 - (23 + 167);
			end
			if (((3952 - (690 + 1108)) <= (1455 + 2576)) and ((0 + 0) == v173)) then
				v122();
				v121();
				v123();
				v173 = 849 - (40 + 808);
			end
			if (((760 + 3855) == (17647 - 13032)) and ((8 + 0) == v173)) then
				if (v29 or ((2005 + 1785) == (275 + 225))) then
					return v29;
				end
				if (((660 - (47 + 524)) < (144 + 77)) and v96.Redemption:IsCastable() and v96.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((5614 - 3560) >= (2124 - 703)) and v25(v98.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((1577 - 885) < (4784 - (1165 + 561))) and v15:AffectingCombat()) then
					if ((v96.Intercession:IsCastable() and (v15:HolyPower() >= (1 + 2)) and v96.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((10077 - 6823) == (632 + 1023))) then
						if (v25(v98.IntercessionMouseover) or ((1775 - (341 + 138)) == (1326 + 3584))) then
							return "Intercession";
						end
					end
				end
				v173 = 18 - 9;
			end
			if (((3694 - (89 + 237)) == (10834 - 7466)) and (v173 == (6 - 3))) then
				v103 = v15:GetEnemiesInRange(911 - (581 + 300));
				if (((3863 - (855 + 365)) < (9061 - 5246)) and v31) then
					local v207 = 0 + 0;
					while true do
						if (((3148 - (1030 + 205)) > (463 + 30)) and (v207 == (0 + 0))) then
							v104 = #v102;
							v105 = #v103;
							break;
						end
					end
				else
					v104 = 287 - (156 + 130);
					v105 = 2 - 1;
				end
				v100 = v15:ActiveMitigationNeeded();
				v173 = 6 - 2;
			end
			if (((9738 - 4983) > (904 + 2524)) and (v173 == (6 + 3))) then
				if (((1450 - (10 + 59)) <= (671 + 1698)) and v106.TargetIsValid() and not v15:AffectingCombat() and v30) then
					v29 = v118();
					if (v29 or ((23850 - 19007) == (5247 - (671 + 492)))) then
						return v29;
					end
				end
				if (((3717 + 952) > (1578 - (369 + 846))) and v106.TargetIsValid()) then
					local v208 = 0 + 0;
					while true do
						if ((v208 == (0 + 0)) or ((3822 - (1036 + 909)) >= (2495 + 643))) then
							if (((7960 - 3218) >= (3829 - (11 + 192))) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
								if (v15:AffectingCombat() or ((2295 + 2245) == (1091 - (135 + 40)))) then
									if (v96.Intercession:IsCastable() or ((2800 - 1644) > (2619 + 1726))) then
										if (((4928 - 2691) < (6369 - 2120)) and v25(v96.Intercession, not v17:IsInRange(206 - (50 + 126)), true)) then
											return "intercession";
										end
									end
								elseif (v96.Redemption:IsCastable() or ((7470 - 4787) < (6 + 17))) then
									if (((2110 - (1233 + 180)) <= (1795 - (522 + 447))) and v25(v96.Redemption, not v17:IsInRange(1451 - (107 + 1314)), true)) then
										return "redemption";
									end
								end
							end
							if (((513 + 592) <= (3583 - 2407)) and v106.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
								local v211 = 0 + 0;
								while true do
									if (((6709 - 3330) <= (15082 - 11270)) and (v211 == (1911 - (716 + 1194)))) then
										if ((v85 and ((v32 and v86) or not v86) and v17:IsInRange(1 + 7)) or ((85 + 703) >= (2119 - (74 + 429)))) then
											local v212 = 0 - 0;
											while true do
												if (((919 + 935) <= (7734 - 4355)) and (v212 == (0 + 0))) then
													v29 = v115();
													if (((14024 - 9475) == (11247 - 6698)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										v29 = v120();
										v211 = 435 - (279 + 154);
									end
									if ((v211 == (778 - (454 + 324))) or ((2378 + 644) >= (3041 - (12 + 5)))) then
										if (((2599 + 2221) > (5600 - 3402)) and v101) then
											local v213 = 0 + 0;
											while true do
												if ((v213 == (1093 - (277 + 816))) or ((4533 - 3472) >= (6074 - (1058 + 125)))) then
													v29 = v116();
													if (((256 + 1108) <= (5448 - (815 + 160))) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if ((v84 < v108) or ((15424 - 11829) <= (7 - 4))) then
											local v214 = 0 + 0;
											while true do
												if ((v214 == (0 - 0)) or ((6570 - (41 + 1857)) == (5745 - (1222 + 671)))) then
													v29 = v119();
													if (((4029 - 2470) == (2240 - 681)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										v211 = 1183 - (229 + 953);
									end
									if ((v211 == (1776 - (1111 + 663))) or ((3331 - (874 + 705)) <= (111 + 677))) then
										if (v29 or ((2666 + 1241) == (367 - 190))) then
											return v29;
										end
										if (((98 + 3372) > (1234 - (642 + 37))) and v25(v96.Pool)) then
											return "Wait/Pool Resources";
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((2 + 5) == v173) or ((156 + 816) == (1619 - 974))) then
				if (((3636 - (233 + 221)) >= (4890 - 2775)) and v29) then
					return v29;
				end
				if (((3427 + 466) < (5970 - (718 + 823))) and v14) then
					if (v78 or ((1805 + 1062) < (2710 - (266 + 539)))) then
						local v210 = 0 - 0;
						while true do
							if ((v210 == (1225 - (636 + 589))) or ((4263 - 2467) >= (8355 - 4304))) then
								v29 = v113();
								if (((1283 + 336) <= (1365 + 2391)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v29 = v117();
				v173 = 1023 - (657 + 358);
			end
			if (((1598 - 994) == (1375 - 771)) and (v173 == (1193 - (1151 + 36)))) then
				if (v79 or ((4331 + 153) == (237 + 663))) then
					local v209 = 0 - 0;
					while true do
						if ((v209 == (1832 - (1552 + 280))) or ((5293 - (64 + 770)) <= (756 + 357))) then
							if (((8244 - 4612) > (604 + 2794)) and v75) then
								v29 = v106.HandleAfflicted(v96.CleanseToxins, v98.CleanseToxinsMouseover, 1283 - (157 + 1086));
								if (((8169 - 4087) <= (21535 - 16618)) and v29) then
									return v29;
								end
							end
							if (((7411 - 2579) >= (1890 - 504)) and v15:BuffUp(v96.ShiningLightFreeBuff) and v76) then
								v29 = v106.HandleAfflicted(v96.WordofGlory, v98.WordofGloryMouseover, 859 - (599 + 220), true);
								if (((272 - 135) == (2068 - (1813 + 118))) and v29) then
									return v29;
								end
							end
							break;
						end
					end
				end
				if (v80 or ((1148 + 422) >= (5549 - (841 + 376)))) then
					v29 = v106.HandleIncorporeal(v96.Repentance, v98.RepentanceMouseOver, 42 - 12, true);
					if (v29 or ((945 + 3119) <= (4964 - 3145))) then
						return v29;
					end
					v29 = v106.HandleIncorporeal(v96.TurnEvil, v98.TurnEvilMouseOver, 889 - (464 + 395), true);
					if (v29 or ((12796 - 7810) < (756 + 818))) then
						return v29;
					end
				end
				v29 = v114();
				v173 = 844 - (467 + 370);
			end
		end
	end
	local function v125()
		v21.Print("Protection Paladin by Epic. Supported by xKaneto");
		v110();
	end
	v21.SetAPL(135 - 69, v124, v125);
end;
return v0["Epix_Paladin_Protection.lua"]();

