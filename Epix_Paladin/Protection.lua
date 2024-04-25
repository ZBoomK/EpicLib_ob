local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1740 - (343 + 1397);
	local v6;
	while true do
		if (((2785 - (1074 + 82)) > (2633 - 1431)) and (v5 == (1784 - (214 + 1570)))) then
			v6 = v0[v4];
			if (((2463 - (990 + 465)) < (1530 + 2181)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 + 0)) or ((4128 - 3079) <= (2632 - (1668 + 58)))) then
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
	local v111 = 11737 - (512 + 114);
	local v112 = 28967 - 17856;
	local v113 = 0 - 0;
	v10:RegisterForEvent(function()
		local v131 = 0 - 0;
		while true do
			if (((2100 + 2413) > (511 + 2215)) and (v131 == (0 + 0))) then
				v111 = 37476 - 26365;
				v112 = 13105 - (109 + 1885);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (v100.CleanseToxins:IsAvailable() or ((2950 - (1269 + 200)) >= (5094 - 2436))) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v132)
		return v132:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 815 - (98 + 717);
	local function v118()
		if ((v100.CleanseToxins:IsReady() and (v110.UnitHasDispellableDebuffByPlayer(v14) or v110.DispellableFriendlyUnit(851 - (802 + 24)) or v110.UnitHasCurseDebuff(v14) or v110.UnitHasPoisonDebuff(v14))) or ((5552 - 2332) == (1721 - 357))) then
			if ((v117 == (0 + 0)) or ((810 + 244) > (558 + 2834))) then
				v117 = GetTime();
			end
			if (v110.Wait(108 + 392, v117) or ((1880 - 1204) >= (5475 - 3833))) then
				local v218 = 0 + 0;
				while true do
					if (((1684 + 2452) > (1978 + 419)) and (v218 == (0 + 0))) then
						if (v25(v102.CleanseToxinsFocus) or ((2024 + 2310) == (5678 - (797 + 636)))) then
							return "cleanse_toxins dispel";
						end
						v117 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((5895 - (1427 + 192)) <= (1051 + 1980))) then
			if (v100.FlashofLight:IsReady() or ((11102 - 6320) <= (1078 + 121))) then
				if (v25(v100.FlashofLight) or ((2205 + 2659) < (2228 - (192 + 134)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		v29 = v110.HandleTopTrinket(v103, v32, 1316 - (316 + 960), nil);
		if (((2693 + 2146) >= (2856 + 844)) and v29) then
			return v29;
		end
		v29 = v110.HandleBottomTrinket(v103, v32, 37 + 3, nil);
		if (v29 or ((4109 - 3034) > (2469 - (83 + 468)))) then
			return v29;
		end
	end
	local function v121()
		if (((2202 - (1202 + 604)) <= (17757 - 13953)) and (v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (v25(v100.DivineShield) or ((6938 - 2769) == (6055 - 3868))) then
				return "divine_shield defensive";
			end
		end
		if (((1731 - (45 + 280)) == (1358 + 48)) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (((1338 + 193) < (1560 + 2711)) and v25(v102.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((352 + 283) == (112 + 523)) and v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) then
			if (((6245 - 2872) <= (5467 - (340 + 1571))) and v25(v100.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if ((v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) or ((1299 + 1992) < (5052 - (1733 + 39)))) then
			if (((12052 - 7666) >= (1907 - (125 + 909))) and v25(v100.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if (((2869 - (1096 + 852)) <= (495 + 607)) and v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) then
			if (((6719 - 2013) >= (935 + 28)) and ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (517 - (409 + 103))) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff))) then
				if (v25(v102.WordofGloryPlayer) or ((1196 - (46 + 190)) <= (971 - (51 + 44)))) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (1 + 1)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) or ((3383 - (1114 + 203)) == (1658 - (228 + 498)))) then
			if (((1046 + 3779) < (2676 + 2167)) and v25(v100.ShieldoftheRighteous)) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) or ((4540 - (174 + 489)) >= (11820 - 7283))) then
			if (v25(v102.Healthstone) or ((6220 - (830 + 1075)) < (2250 - (303 + 221)))) then
				return "healthstone defensive";
			end
		end
		if ((v93 and (v15:HealthPercentage() <= v95)) or ((4948 - (231 + 1038)) < (521 + 104))) then
			if ((v97 == "Refreshing Healing Potion") or ((5787 - (171 + 991)) < (2604 - 1972))) then
				if (v101.RefreshingHealingPotion:IsReady() or ((222 - 139) > (4441 - 2661))) then
					if (((437 + 109) <= (3775 - 2698)) and v25(v102.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v97 == "Dreamwalker's Healing Potion") or ((2873 - 1877) > (6932 - 2631))) then
				if (((12581 - 8511) > (1935 - (111 + 1137))) and v101.DreamwalkersHealingPotion:IsReady()) then
					if (v25(v102.RefreshingHealingPotion) or ((814 - (91 + 67)) >= (9910 - 6580))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v122()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (524 - (423 + 100))) or ((18 + 2474) <= (927 - 592))) then
				if (((2253 + 2069) >= (3333 - (326 + 445))) and v14) then
					if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (13 - 10))) and (v14:HealthPercentage() <= v75)) or ((8102 - 4465) >= (8800 - 5030))) then
						if (v25(v102.WordofGloryFocus) or ((3090 - (530 + 181)) > (5459 - (614 + 267)))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) or ((515 - (19 + 13)) > (1208 - 465))) then
						if (((5718 - 3264) > (1651 - 1073)) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((242 + 688) < (7839 - 3381)) and v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) then
						if (((1372 - 710) <= (2784 - (1293 + 519))) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((8916 - 4546) == (11409 - 7039)) and v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) then
						if (v25(v102.BlessingofProtectionFocus) or ((9106 - 4344) <= (3712 - 2851))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if ((v133 == (0 - 0)) or ((748 + 664) == (870 + 3394))) then
				if (v16:Exists() or ((7360 - 4192) < (498 + 1655))) then
					if ((v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) or ((1654 + 3322) < (833 + 499))) then
						if (((5724 - (709 + 387)) == (6486 - (673 + 1185))) and v25(v102.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(87 - 57) or ((173 - 119) == (649 - 254))) then
					return;
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v123()
		if (((62 + 20) == (110 - 28)) and (v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) then
			if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((143 + 438) < (561 - 279))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (9 - 4))) or ((6489 - (446 + 1434)) < (3778 - (1040 + 243)))) then
			if (((3438 - 2286) == (2999 - (559 + 1288))) and v25(v100.ArcaneTorrent, not v17:IsInRange(1939 - (609 + 1322)))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((2350 - (13 + 441)) <= (12787 - 9365)) and v100.Consecration:IsCastable() and v38) then
			if (v25(v100.Consecration, not v17:IsInRange(20 - 12)) or ((4930 - 3940) > (61 + 1559))) then
				return "consecration precombat 8";
			end
		end
		if ((v100.AvengersShield:IsCastable() and v36) or ((3184 - 2307) > (1668 + 3027))) then
			local v145 = 0 + 0;
			while true do
				if (((7985 - 5294) >= (1013 + 838)) and (v145 == (0 - 0))) then
					if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(20 + 10)) or ((1661 + 1324) >= (3490 + 1366))) then
						if (((3591 + 685) >= (1170 + 25)) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover precombat 10";
						end
					end
					if (((3665 - (153 + 280)) <= (13542 - 8852)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
					break;
				end
			end
		end
		if ((v100.Judgment:IsReady() and v42) or ((805 + 91) >= (1243 + 1903))) then
			if (((1602 + 1459) >= (2685 + 273)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v124()
		if (((2310 + 877) >= (980 - 336)) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (2 + 0)) and v15:HasTier(696 - (89 + 578), 2 + 0)) then
			local v146 = 0 - 0;
			while true do
				if (((1693 - (572 + 477)) <= (95 + 609)) and ((0 + 0) == v146)) then
					if (((115 + 843) > (1033 - (84 + 2))) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(49 - 19)) then
						if (((3237 + 1255) >= (3496 - (497 + 345))) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (((89 + 3353) >= (255 + 1248)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
					break;
				end
			end
		end
		if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (1335 - (605 + 728)))) or ((2262 + 908) <= (3254 - 1790))) then
			if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((220 + 4577) == (16223 - 11835))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((497 + 54) <= (1886 - 1205)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
			if (((2475 + 802) > (896 - (457 + 32))) and v25(v100.AvengingWrath, not v17:IsInRange(4 + 4))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((6097 - (832 + 570)) >= (1334 + 81)) and v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) then
			if (v25(v100.Sentinel, not v17:IsInRange(3 + 5)) or ((11366 - 8154) <= (455 + 489))) then
				return "sentinel cooldowns 8";
			end
		end
		local v134 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
		if (v134 or ((3892 - (588 + 208)) <= (4845 - 3047))) then
			return v134;
		end
		if (((5337 - (884 + 916)) == (7404 - 3867)) and v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (9 + 6)) or (((v10.CombatTime() > (663 - (232 + 421))) or (v100.Sentinel:CooldownRemains() > (1904 - (1569 + 320))) or (v100.AvengingWrath:CooldownRemains() > (4 + 11))) and (v100.AvengersShield:CooldownRemains() > (0 + 0)) and (v100.Judgment:CooldownRemains() > (0 - 0)) and (v100.HammerofWrath:CooldownRemains() > (605 - (316 + 289)))))) then
			if (((10043 - 6206) >= (73 + 1497)) and v25(v100.MomentOfGlory, not v17:IsInRange(1461 - (666 + 787)))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (428 - (360 + 65)))) or ((2757 + 193) == (4066 - (79 + 175)))) then
			if (((7446 - 2723) >= (1809 + 509)) and v25(v100.DivineToll, not v17:IsInRange(91 - 61))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (57 - 27)))) or ((2926 - (503 + 396)) > (3033 - (92 + 89)))) then
			if (v25(v100.BastionofLight, not v17:IsInRange(15 - 7)) or ((583 + 553) > (2556 + 1761))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v125()
		if (((18593 - 13845) == (650 + 4098)) and v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (11 - 6))) then
			if (((3260 + 476) <= (2264 + 2476)) and v25(v100.Consecration, not v17:IsInRange(24 - 16))) then
				return "consecration standard 2";
			end
		end
		if ((v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (1 + 1)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (7 - 2)))) or ((4634 - (485 + 759)) <= (7080 - 4020))) then
			if (v25(v100.ShieldoftheRighteous) or ((2188 - (442 + 747)) > (3828 - (832 + 303)))) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if (((1409 - (88 + 858)) < (184 + 417)) and v100.Judgment:IsReady() and v42 and (v108 > (3 + 0)) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (1 + 2)) and (v15:HolyPower() < (792 - (766 + 23)))) then
			if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((10776 - 8593) < (939 - 252))) then
				return "judgment standard 6";
			end
			if (((11984 - 7435) == (15439 - 10890)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 6";
			end
		end
		if (((5745 - (1036 + 37)) == (3313 + 1359)) and v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(60 - 29, 2 + 0)) then
			local v147 = 1480 - (641 + 839);
			while true do
				if (((913 - (910 + 3)) == v147) or ((9350 - 5682) < (2079 - (1466 + 218)))) then
					if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1915 + 2251) == (1603 - (556 + 592)))) then
						return "judgment standard 8";
					end
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((1583 + 2866) == (3471 - (329 + 479)))) then
						return "judgment standard 8";
					end
					break;
				end
			end
		end
		if ((v100.HammerofWrath:IsReady() and v41) or ((5131 - (174 + 680)) < (10270 - 7281))) then
			if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((1803 - 933) >= (2963 + 1186))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((2951 - (396 + 343)) < (282 + 2901)) and v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (1479 - (29 + 1448))) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) then
			if (((6035 - (135 + 1254)) > (11271 - 8279)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 12";
			end
			if (((6695 - 5261) < (2070 + 1036)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 12";
			end
		end
		if (((2313 - (389 + 1138)) < (3597 - (102 + 472))) and v100.AvengersShield:IsCastable() and v36 and ((v109 > (2 + 0)) or v15:BuffUp(v100.MomentOfGloryBuff))) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (0 + 0)) or ((3987 - (320 + 1225)) < (131 - 57))) then
					if (((2775 + 1760) == (5999 - (157 + 1307))) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(1889 - (821 + 1038))) then
						if (v25(v102.AvengersShieldMouseover) or ((7507 - 4498) <= (231 + 1874))) then
							return "avengers_shield mouseover standard 14";
						end
					end
					if (((3250 - 1420) < (1366 + 2303)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 14";
					end
					break;
				end
			end
		end
		if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) or ((3544 - 2114) >= (4638 - (834 + 192)))) then
			if (((171 + 2512) >= (632 + 1828)) and v25(v100.DivineToll, not v17:IsInRange(1 + 29))) then
				return "divine_toll standard 16";
			end
		end
		if ((v100.AvengersShield:IsCastable() and v36) or ((2794 - 990) >= (3579 - (300 + 4)))) then
			local v149 = 0 + 0;
			while true do
				if (((0 - 0) == v149) or ((1779 - (112 + 250)) > (1447 + 2182))) then
					if (((12012 - 7217) > (231 + 171)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(16 + 14)) then
						if (((3600 + 1213) > (1768 + 1797)) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 18";
						end
					end
					if (((2907 + 1005) == (5326 - (1001 + 413))) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 18";
					end
					break;
				end
			end
		end
		if (((6290 - 3469) <= (5706 - (244 + 638))) and v100.HammerofWrath:IsReady() and v41) then
			if (((2431 - (627 + 66)) <= (6540 - 4345)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if (((643 - (512 + 90)) <= (4924 - (1665 + 241))) and v100.Judgment:IsReady() and v42) then
			if (((2862 - (373 + 344)) <= (1851 + 2253)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 22";
			end
			if (((712 + 1977) < (12779 - 7934)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment standard 22";
			end
		end
		if ((v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (8 - 3)) or not v15:HasTier(1130 - (35 + 1064), 2 + 0))) or ((4967 - 2645) > (11 + 2611))) then
			if (v25(v100.Consecration, not v17:IsInRange(1244 - (298 + 938))) or ((5793 - (233 + 1026)) == (3748 - (636 + 1030)))) then
				return "consecration standard 24";
			end
		end
		if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (2 + 1))) or ((1535 + 36) > (555 + 1312))) then
			if (v25(v100.EyeofTyr, not v17:IsInRange(1 + 7)) or ((2875 - (55 + 166)) >= (581 + 2415))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((401 + 3577) > (8035 - 5931)) and v100.BlessedHammer:IsCastable() and v37) then
			if (((3292 - (36 + 261)) > (2694 - 1153)) and v25(v100.BlessedHammer, not v17:IsInRange(1376 - (34 + 1334)))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((1250 + 1999) > (741 + 212)) and v100.HammeroftheRighteous:IsCastable() and v40) then
			if (v25(v100.HammeroftheRighteous, not v17:IsInRange(1291 - (1035 + 248))) or ((3294 - (20 + 1)) > (2383 + 2190))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39) or ((3470 - (134 + 185)) < (2417 - (549 + 584)))) then
			if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((2535 - (314 + 371)) == (5248 - 3719))) then
				return "crusader_strike standard 32";
			end
		end
		if (((1789 - (478 + 490)) < (1125 + 998)) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) then
			if (((2074 - (786 + 386)) < (7530 - 5205)) and v25(v100.EyeofTyr, not v17:IsInRange(1387 - (1055 + 324)))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((2198 - (1093 + 247)) <= (2633 + 329)) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1 + 4))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(31 - 23)) or ((13391 - 9445) < (3664 - 2376))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) or ((8146 - 4904) == (202 + 365))) then
			if (v25(v100.Consecration, not v17:IsInRange(30 - 22)) or ((2919 - 2072) >= (953 + 310))) then
				return "consecration standard 38";
			end
		end
	end
	local function v126()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (688 - (364 + 324))) or ((6175 - 3922) == (4441 - 2590))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v135 = 1 + 0;
			end
			if ((v135 == (4 - 3)) or ((3341 - 1254) > (7203 - 4831))) then
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v135 = 1270 - (1249 + 19);
			end
			if (((3 + 0) == v135) or ((17302 - 12857) < (5235 - (686 + 400)))) then
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v135 = 4 + 0;
			end
			if (((234 - (73 + 156)) == v135) or ((9 + 1809) == (896 - (721 + 90)))) then
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v135 = 1 + 5;
			end
			if (((2045 - 1415) < (2597 - (224 + 246))) and (v135 == (5 - 1))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v135 = 9 - 4;
			end
			if ((v135 == (2 + 4)) or ((47 + 1891) == (1847 + 667))) then
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((8459 - 4204) >= (183 - 128)) and (v135 == (515 - (203 + 310)))) then
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v42 = EpicSettings.Settings['useJudgment'];
				v135 = 1996 - (1238 + 755);
			end
		end
	end
	local function v127()
		local v136 = 0 + 0;
		while true do
			if (((4533 - (709 + 825)) > (2129 - 973)) and (v136 == (2 - 0))) then
				v63 = EpicSettings.Settings['useLayOnHandsFocus'];
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v136 = 867 - (196 + 668);
			end
			if (((9278 - 6928) > (2392 - 1237)) and (v136 == (833 - (171 + 662)))) then
				v55 = EpicSettings.Settings['useRebuke'];
				v56 = EpicSettings.Settings['useHammerofJustice'];
				v57 = EpicSettings.Settings['useArdentDefender'];
				v58 = EpicSettings.Settings['useDivineShield'];
				v136 = 94 - (4 + 89);
			end
			if (((14121 - 10092) <= (1768 + 3085)) and (v136 == (17 - 13))) then
				v71 = EpicSettings.Settings['layonHandsHP'];
				v72 = EpicSettings.Settings['wordofGloryHP'];
				v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v74 = EpicSettings.Settings['layOnHandsFocusHP'];
				v136 = 2 + 3;
			end
			if ((v136 == (1487 - (35 + 1451))) or ((1969 - (28 + 1425)) > (5427 - (941 + 1052)))) then
				v59 = EpicSettings.Settings['useGuardianofAncientKings'];
				v60 = EpicSettings.Settings['useLayOnHands'];
				v61 = EpicSettings.Settings['useWordofGloryPlayer'];
				v62 = EpicSettings.Settings['useShieldoftheRighteous'];
				v136 = 2 + 0;
			end
			if (((5560 - (822 + 692)) >= (4329 - 1296)) and (v136 == (3 + 2))) then
				v75 = EpicSettings.Settings['wordofGloryFocusHP'];
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v136 = 303 - (45 + 252);
			end
			if ((v136 == (3 + 0)) or ((936 + 1783) <= (3521 - 2074))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['ardentDefenderHP'];
				v69 = EpicSettings.Settings['divineShieldHP'];
				v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v136 = 437 - (114 + 319);
			end
			if ((v136 == (7 - 1)) or ((5296 - 1162) < (2503 + 1423))) then
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
		end
	end
	local function v128()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (3 - 1)) or ((2127 - (556 + 1407)) >= (3991 - (741 + 465)))) then
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v137 = 468 - (170 + 295);
			end
			if ((v137 == (0 + 0)) or ((483 + 42) == (5192 - 3083))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v137 = 1 + 0;
			end
			if (((19 + 14) == (1263 - (957 + 273))) and (v137 == (1 + 2))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v83 = EpicSettings.Settings['handleAfflicted'];
				v137 = 10 - 6;
			end
			if (((9328 - 6274) <= (19880 - 15865)) and ((1781 - (389 + 1391)) == v137)) then
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v89 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v137 = 2 + 0;
			end
			if (((195 + 1676) < (7699 - 4317)) and (v137 == (955 - (783 + 168)))) then
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				v98 = EpicSettings.Settings['HealOOC'];
				v99 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
		end
	end
	local function v129()
		v127();
		v126();
		v128();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((1272 + 21) <= (2477 - (309 + 2))) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v106 = v15:GetEnemiesInMeleeRange(24 - 16);
		v107 = v15:GetEnemiesInRange(1242 - (1090 + 122));
		if (v31 or ((837 + 1742) < (412 - 289))) then
			v108 = #v106;
			v109 = #v107;
		else
			v108 = 1 + 0;
			v109 = 1119 - (628 + 490);
		end
		v104 = v15:ActiveMitigationNeeded();
		v105 = v15:IsTankingAoE(2 + 6) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((2094 - 1248) >= (10821 - 8453))) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) or ((4786 - (431 + 343)) <= (6781 - 3423))) then
				if (((4321 - 2827) <= (2374 + 631)) and v25(v100.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((398 + 2713) == (3829 - (556 + 1139)))) then
			if (((2370 - (6 + 9)) == (432 + 1923)) and v15:AffectingCombat()) then
				if (v100.Intercession:IsCastable() or ((302 + 286) <= (601 - (28 + 141)))) then
					if (((1859 + 2938) >= (4807 - 912)) and v25(v100.Intercession, not v17:IsInRange(22 + 8), true)) then
						return "intercession target";
					end
				end
			elseif (((4894 - (486 + 831)) == (9308 - 5731)) and v100.Redemption:IsCastable()) then
				if (((13356 - 9562) > (698 + 2995)) and v25(v100.Redemption, not v17:IsInRange(94 - 64), true)) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((2538 - (668 + 595)) == (3690 + 410))) then
			if (v25(v102.RedemptionMouseover) or ((321 + 1270) >= (9763 - 6183))) then
				return "redemption mouseover";
			end
		end
		if (((1273 - (23 + 267)) <= (3752 - (1129 + 815))) and v15:AffectingCombat()) then
			if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (390 - (371 + 16))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((3900 - (1326 + 424)) <= (2267 - 1070))) then
				if (((13772 - 10003) >= (1291 - (88 + 30))) and v25(v102.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if (((2256 - (720 + 51)) == (3303 - 1818)) and (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()))) then
			local v150 = 1776 - (421 + 1355);
			local v151;
			while true do
				if ((v150 == (0 - 0)) or ((1629 + 1686) <= (3865 - (286 + 797)))) then
					v151 = v82 and v100.CleanseToxins:IsReady() and v33;
					v29 = v110.FocusUnit(v151, nil, 73 - 53, nil, 40 - 15, v100.FlashofLight);
					v150 = 440 - (397 + 42);
				end
				if ((v150 == (1 + 0)) or ((1676 - (24 + 776)) >= (4565 - 1601))) then
					if (v29 or ((3017 - (222 + 563)) > (5501 - 3004))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v33 and v82) or ((1520 + 590) <= (522 - (23 + 167)))) then
			v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1838 - (690 + 1108), 10 + 15, v100.FlashofLight);
			if (((3041 + 645) > (4020 - (40 + 808))) and v29) then
				return v29;
			end
			if ((v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((737 + 3737) < (3135 - 2315))) then
				if (((4090 + 189) >= (1525 + 1357)) and v25(v102.BlessingofFreedomFocus)) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (v110.TargetIsValid() or v15:AffectingCombat() or ((1113 + 916) >= (4092 - (47 + 524)))) then
			local v152 = 0 + 0;
			while true do
				if (((2 - 1) == v152) or ((3045 - 1008) >= (10586 - 5944))) then
					if (((3446 - (1165 + 561)) < (133 + 4325)) and (v112 == (34412 - 23301))) then
						v112 = v10.FightRemains(v106, false);
					end
					v113 = v15:HolyPower();
					break;
				end
				if ((v152 == (0 + 0)) or ((915 - (341 + 138)) > (816 + 2205))) then
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					v152 = 1 - 0;
				end
			end
		end
		if (((1039 - (89 + 237)) <= (2724 - 1877)) and not v15:AffectingCombat()) then
			if (((4534 - 2380) <= (4912 - (581 + 300))) and v100.DevotionAura:IsCastable() and (v116()) and v34) then
				if (((5835 - (855 + 365)) == (10961 - 6346)) and v25(v100.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v83 or ((1238 + 2552) == (1735 - (1030 + 205)))) then
			if (((84 + 5) < (206 + 15)) and v79) then
				local v219 = 286 - (156 + 130);
				while true do
					if (((4666 - 2612) >= (2394 - 973)) and ((0 - 0) == v219)) then
						v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 11 + 29);
						if (((404 + 288) < (3127 - (10 + 59))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if ((v15:BuffUp(v100.ShiningLightFreeBuff) and v80) or ((921 + 2333) == (8150 - 6495))) then
				v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 1203 - (671 + 492), true);
				if (v29 or ((1032 + 264) == (6125 - (369 + 846)))) then
					return v29;
				end
			end
		end
		if (((892 + 2476) == (2875 + 493)) and v84) then
			local v153 = 1945 - (1036 + 909);
			while true do
				if (((2102 + 541) < (6405 - 2590)) and (v153 == (203 - (11 + 192)))) then
					v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 16 + 14, true);
					if (((2088 - (135 + 40)) > (1194 - 701)) and v29) then
						return v29;
					end
					v153 = 1 + 0;
				end
				if (((10475 - 5720) > (5138 - 1710)) and (v153 == (177 - (50 + 126)))) then
					v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 83 - 53, true);
					if (((306 + 1075) <= (3782 - (1233 + 180))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		v29 = v119();
		if (v29 or ((5812 - (522 + 447)) == (5505 - (107 + 1314)))) then
			return v29;
		end
		if (((2167 + 2502) > (1105 - 742)) and v82 and v33) then
			if (v14 or ((798 + 1079) >= (6231 - 3093))) then
				v29 = v118();
				if (((18762 - 14020) >= (5536 - (716 + 1194))) and v29) then
					return v29;
				end
			end
			if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16) or v110.UnitHasDispellableDebuffByPlayer(v16))) or ((78 + 4462) == (99 + 817))) then
				if (v100.CleanseToxins:IsReady() or ((1659 - (74 + 429)) > (8381 - 4036))) then
					if (((1109 + 1128) < (9725 - 5476)) and v25(v102.CleanseToxinsMouseover)) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v29 = v122();
		if (v29 or ((1899 + 784) < (70 - 47))) then
			return v29;
		end
		if (((1722 - 1025) <= (1259 - (279 + 154))) and v105) then
			local v154 = 778 - (454 + 324);
			while true do
				if (((870 + 235) <= (1193 - (12 + 5))) and (v154 == (0 + 0))) then
					v29 = v121();
					if (((8609 - 5230) <= (1409 + 2403)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v110.TargetIsValid() and not v15:AffectingCombat() and v30) or ((1881 - (277 + 816)) >= (6905 - 5289))) then
			local v155 = 1183 - (1058 + 125);
			while true do
				if (((348 + 1506) <= (4354 - (815 + 160))) and (v155 == (0 - 0))) then
					v29 = v123();
					if (((10798 - 6249) == (1086 + 3463)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) or ((8833 - 5811) >= (4922 - (41 + 1857)))) then
			local v156 = 1893 - (1222 + 671);
			while true do
				if (((12457 - 7637) > (3159 - 961)) and (v156 == (1182 - (229 + 953)))) then
					if ((v88 < v112) or ((2835 - (1111 + 663)) >= (6470 - (874 + 705)))) then
						local v220 = 0 + 0;
						while true do
							if (((931 + 433) <= (9297 - 4824)) and (v220 == (0 + 0))) then
								v29 = v124();
								if (v29 or ((4274 - (642 + 37)) <= (1 + 2))) then
									return v29;
								end
								v220 = 1 + 0;
							end
							if ((v220 == (2 - 1)) or ((5126 - (233 + 221)) == (8907 - 5055))) then
								if (((1373 + 186) == (3100 - (718 + 823))) and v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) then
									if (v25(v102.UseWeapon) or ((1103 + 649) <= (1593 - (266 + 539)))) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
						end
					end
					if ((v89 and ((v32 and v90) or not v90) and v17:IsInRange(22 - 14)) or ((5132 - (636 + 589)) == (419 - 242))) then
						local v221 = 0 - 0;
						while true do
							if (((2750 + 720) > (202 + 353)) and (v221 == (1015 - (657 + 358)))) then
								v29 = v120();
								if (v29 or ((2573 - 1601) == (1469 - 824))) then
									return v29;
								end
								break;
							end
						end
					end
					v156 = 1188 - (1151 + 36);
				end
				if (((3073 + 109) >= (557 + 1558)) and ((5 - 3) == v156)) then
					if (((5725 - (1552 + 280)) < (5263 - (64 + 770))) and v25(v100.Pool)) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if ((v156 == (1 + 0)) or ((6507 - 3640) < (339 + 1566))) then
					v29 = v125();
					if (v29 or ((3039 - (157 + 1086)) >= (8108 - 4057))) then
						return v29;
					end
					v156 = 8 - 6;
				end
			end
		end
	end
	local function v130()
		local v142 = 0 - 0;
		while true do
			if (((2209 - 590) <= (4575 - (599 + 220))) and (v142 == (0 - 0))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v114();
				break;
			end
		end
	end
	v21.SetAPL(1997 - (1813 + 118), v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

