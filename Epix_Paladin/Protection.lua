local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((1421 + 543) < (2401 - (810 + 251)))) then
			return v6(...);
		end
		if (((1735 + 764) == (767 + 1732)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2788 - (43 + 490)) < (755 - (711 + 22)))) then
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
	local v109 = 11970 - (240 + 619);
	local v110 = 2682 + 8429;
	local v111 = 0 - 0;
	v10:RegisterForEvent(function()
		v109 = 736 + 10375;
		v110 = 12855 - (1344 + 400);
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		if (v98.CleanseToxins:IsAvailable() or ((1491 - (255 + 150)) >= (1107 + 298))) then
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
	local v115 = 0 + 0;
	local function v116()
		if ((v98.CleanseToxins:IsReady() and v108.DispellableFriendlyUnit(106 - 81)) or ((7651 - 5282) == (2165 - (404 + 1335)))) then
			local v156 = 406 - (183 + 223);
			while true do
				if ((v156 == (0 - 0)) or ((2039 + 1037) > (1146 + 2037))) then
					if (((1539 - (10 + 327)) > (737 + 321)) and (v115 == (338 - (118 + 220)))) then
						v115 = GetTime();
					end
					if (((1237 + 2474) > (3804 - (108 + 341))) and v108.Wait(225 + 275, v115)) then
						local v213 = 0 - 0;
						while true do
							if ((v213 == (1493 - (711 + 782))) or ((1736 - 830) >= (2698 - (270 + 199)))) then
								if (((418 + 870) > (3070 - (580 + 1239))) and v25(v100.CleanseToxinsFocus)) then
									return "cleanse_toxins dispel";
								end
								v115 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((4316 + 197) < (121 + 3231))) then
			if (v98.FlashofLight:IsReady() or ((900 + 1165) >= (8344 - 5148))) then
				if (v25(v98.FlashofLight) or ((2719 + 1657) <= (2648 - (645 + 522)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v130 = 1790 - (1010 + 780);
		while true do
			if ((v130 == (1 + 0)) or ((16159 - 12767) >= (13893 - 9152))) then
				v29 = v108.HandleBottomTrinket(v101, v32, 1876 - (1045 + 791), nil);
				if (((8416 - 5091) >= (3288 - 1134)) and v29) then
					return v29;
				end
				break;
			end
			if ((v130 == (505 - (351 + 154))) or ((2869 - (1281 + 293)) >= (3499 - (28 + 238)))) then
				v29 = v108.HandleTopTrinket(v101, v32, 89 - 49, nil);
				if (((5936 - (1381 + 178)) > (1541 + 101)) and v29) then
					return v29;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v119()
		if (((2015 + 2708) > (4674 - 3318)) and (v15:HealthPercentage() <= v67) and v56 and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
			if (v25(v98.DivineShield) or ((2143 + 1993) <= (3903 - (381 + 89)))) then
				return "divine_shield defensive";
			end
		end
		if (((3765 + 480) <= (3132 + 1499)) and (v15:HealthPercentage() <= v69) and v58 and v98.LayonHands:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
			if (((7324 - 3048) >= (5070 - (1074 + 82))) and v25(v100.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((433 - 235) <= (6149 - (214 + 1570))) and v98.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v98.ArdentDefenderBuff)) then
			if (((6237 - (990 + 465)) > (1928 + 2748)) and v25(v98.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((2117 + 2747) > (2137 + 60)) and v98.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v66) and v55 and v15:BuffDown(v98.GuardianofAncientKingsBuff)) then
			if (v25(v98.ArdentDefender) or ((14561 - 10861) == (4233 - (1668 + 58)))) then
				return "ardent_defender defensive 6";
			end
		end
		if (((5100 - (512 + 114)) >= (714 - 440)) and v98.WordofGlory:IsReady() and (v15:HealthPercentage() <= v70) and v59 and not v15:HealingAbsorbed()) then
			if ((v15:BuffRemains(v98.ShieldoftheRighteousBuff) >= (10 - 5)) or v15:BuffUp(v98.DivinePurposeBuff) or v15:BuffUp(v98.ShiningLightFreeBuff) or ((6590 - 4696) <= (655 + 751))) then
				if (((295 + 1277) >= (1331 + 200)) and v25(v100.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v98.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (6 - 4)) and v15:BuffRefreshable(v98.ShieldoftheRighteousBuff) and v60 and (v102 or (v15:HealthPercentage() <= v71))) or ((6681 - (109 + 1885)) < (6011 - (1269 + 200)))) then
			if (((6307 - 3016) > (2482 - (98 + 717))) and v25(v98.ShieldoftheRighteous)) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v99.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((1699 - (802 + 24)) == (3507 - 1473))) then
			if (v25(v100.Healthstone) or ((3556 - 740) < (2 + 9))) then
				return "healthstone defensive";
			end
		end
		if (((2843 + 856) < (773 + 3933)) and v91 and (v15:HealthPercentage() <= v93)) then
			if (((571 + 2075) >= (2436 - 1560)) and (v95 == "Refreshing Healing Potion")) then
				if (((2047 - 1433) <= (1139 + 2045)) and v99.RefreshingHealingPotion:IsReady()) then
					if (((1273 + 1853) == (2579 + 547)) and v25(v100.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v95 == "Dreamwalker's Healing Potion") or ((1591 + 596) >= (2313 + 2641))) then
				if (v99.DreamwalkersHealingPotion:IsReady() or ((5310 - (797 + 636)) == (17357 - 13782))) then
					if (((2326 - (1427 + 192)) > (219 + 413)) and v25(v100.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v120()
		if (v16:Exists() or ((1267 - 721) >= (2413 + 271))) then
			if (((664 + 801) <= (4627 - (192 + 134))) and v98.WordofGlory:IsReady() and v63 and (v16:HealthPercentage() <= v74)) then
				if (((2980 - (316 + 960)) > (794 + 631)) and v25(v100.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(24 + 6) or ((636 + 51) == (16186 - 11952))) then
			return;
		end
		if (v14 or ((3881 - (83 + 468)) < (3235 - (1202 + 604)))) then
			if (((5354 - 4207) >= (557 - 222)) and v98.WordofGlory:IsReady() and v62 and v15:BuffUp(v98.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v73)) then
				if (((9510 - 6075) > (2422 - (45 + 280))) and v25(v100.WordofGloryFocus)) then
					return "word_of_glory defensive focus";
				end
			end
			if ((v98.LayonHands:IsCastable() and v61 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) or ((3639 + 131) >= (3531 + 510))) then
				if (v25(v100.LayonHandsFocus) or ((1385 + 2406) <= (892 + 719))) then
					return "lay_on_hands defensive focus";
				end
			end
			if ((v98.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((806 + 3772) <= (3717 - 1709))) then
				if (((3036 - (340 + 1571)) <= (819 + 1257)) and v25(v100.BlessingofSacrificeFocus)) then
					return "blessing_of_sacrifice defensive focus";
				end
			end
			if ((v98.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((2515 - (1733 + 39)) >= (12087 - 7688))) then
				if (((2189 - (125 + 909)) < (3621 - (1096 + 852))) and v25(v100.BlessingofProtectionFocus)) then
					return "blessing_of_protection defensive focus";
				end
			end
		end
	end
	local function v121()
		if (((v86 < v110) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90)) or ((1043 + 1281) <= (825 - 247))) then
			if (((3654 + 113) == (4279 - (409 + 103))) and v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((4325 - (46 + 190)) == (4184 - (51 + 44))) and (v86 < v110) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (2 + 3))) then
			if (((5775 - (1114 + 203)) >= (2400 - (228 + 498))) and v25(v98.ArcaneTorrent, not v17:IsInRange(2 + 6))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((537 + 435) <= (2081 - (174 + 489))) and v98.Consecration:IsCastable() and v36) then
			if (v25(v98.Consecration, not v17:IsInRange(20 - 12)) or ((6843 - (830 + 1075)) < (5286 - (303 + 221)))) then
				return "consecration";
			end
		end
		if ((v98.AvengersShield:IsCastable() and v34) or ((3773 - (231 + 1038)) > (3554 + 710))) then
			if (((3315 - (171 + 991)) == (8872 - 6719)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield precombat 10";
			end
		end
		if ((v98.Judgment:IsReady() and v40) or ((1361 - 854) >= (6465 - 3874))) then
			if (((3587 + 894) == (15707 - 11226)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v122()
		local v131 = 0 - 0;
		local v132;
		while true do
			if ((v131 == (5 - 1)) or ((7196 - 4868) < (1941 - (111 + 1137)))) then
				if (((4486 - (91 + 67)) == (12881 - 8553)) and v98.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v98.AvengingWrathBuff) or (v98.AvengingWrath:CooldownRemains() <= (8 + 22)))) then
					if (((2111 - (423 + 100)) >= (10 + 1322)) and v25(v98.BastionofLight, not v17:IsInRange(21 - 13))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v131 == (2 + 1)) or ((4945 - (326 + 445)) > (18538 - 14290))) then
				if ((v98.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v98.SentinelBuff) < (33 - 18)) or (((v10.CombatTime() > (23 - 13)) or (v98.Sentinel:CooldownRemains() > (726 - (530 + 181))) or (v98.AvengingWrath:CooldownRemains() > (896 - (614 + 267)))) and (v98.AvengersShield:CooldownRemains() > (32 - (19 + 13))) and (v98.Judgment:CooldownRemains() > (0 - 0)) and (v98.HammerofWrath:CooldownRemains() > (0 - 0))))) or ((13100 - 8514) <= (22 + 60))) then
					if (((6793 - 2930) == (8011 - 4148)) and v25(v98.MomentofGlory, not v17:IsInRange(1820 - (1293 + 519)))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady() and (v106 >= (5 - 2))) or ((736 - 454) <= (80 - 38))) then
					if (((19874 - 15265) >= (1804 - 1038)) and v25(v98.DivineToll, not v17:IsInRange(16 + 14))) then
						return "divine_toll cooldowns 12";
					end
				end
				v131 = 1 + 3;
			end
			if ((v131 == (0 - 0)) or ((267 + 885) == (827 + 1661))) then
				if (((2139 + 1283) > (4446 - (709 + 387))) and v98.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (1860 - (673 + 1185))) and v15:HasTier(83 - 54, 6 - 4)) then
					if (((1442 - 565) > (269 + 107)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90) and (v107 >= (2 + 0))) or ((4209 - 1091) <= (455 + 1396))) then
					if (v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment)) or ((328 - 163) >= (6854 - 3362))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v131 = 1881 - (446 + 1434);
			end
			if (((5232 - (1040 + 243)) < (14493 - 9637)) and (v131 == (1848 - (559 + 1288)))) then
				if ((v98.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((6207 - (609 + 1322)) < (3470 - (13 + 441)))) then
					if (((17525 - 12835) > (10804 - 6679)) and v25(v98.AvengingWrath, not v17:IsInRange(39 - 31))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v98.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) or ((2 + 48) >= (3254 - 2358))) then
					if (v25(v98.Sentinel, not v17:IsInRange(3 + 5)) or ((752 + 962) >= (8777 - 5819))) then
						return "sentinel cooldowns 8";
					end
				end
				v131 = 2 + 0;
			end
			if ((v131 == (3 - 1)) or ((986 + 505) < (359 + 285))) then
				v132 = v108.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff));
				if (((506 + 198) < (829 + 158)) and v132) then
					return v132;
				end
				v131 = 3 + 0;
			end
		end
	end
	local function v123()
		if (((4151 - (153 + 280)) > (5503 - 3597)) and v98.Consecration:IsCastable() and v36 and (v15:BuffStack(v98.SanctificationBuff) == (5 + 0))) then
			if (v25(v98.Consecration, not v17:IsInRange(4 + 4)) or ((502 + 456) > (3299 + 336))) then
				return "consecration standard 2";
			end
		end
		if (((2537 + 964) <= (6839 - 2347)) and v98.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (2 + 0)) or v15:BuffUp(v98.BastionofLightBuff) or v15:BuffUp(v98.DivinePurposeBuff)) and (v15:BuffDown(v98.SanctificationBuff) or (v15:BuffStack(v98.SanctificationBuff) < (672 - (89 + 578))))) then
			if (v25(v98.ShieldoftheRighteous) or ((2459 + 983) < (5296 - 2748))) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if (((3924 - (572 + 477)) >= (198 + 1266)) and v98.Judgment:IsReady() and v40 and (v106 > (2 + 1)) and (v15:BuffStack(v98.BulwarkofRighteousFuryBuff) >= (1 + 2)) and (v15:HolyPower() < (89 - (84 + 2)))) then
			if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((7905 - 3108) >= (3525 + 1368))) then
				return "judgment standard 6";
			end
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1393 - (497 + 345)) > (53 + 2015))) then
				return "judgment standard 6";
			end
		end
		if (((358 + 1756) > (2277 - (605 + 728))) and v98.Judgment:IsReady() and v40 and v15:BuffDown(v98.SanctificationEmpowerBuff) and v15:HasTier(23 + 8, 3 - 1)) then
			local v157 = 0 + 0;
			while true do
				if ((v157 == (0 - 0)) or ((2040 + 222) >= (8577 - 5481))) then
					if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((1703 + 552) >= (4026 - (457 + 32)))) then
						return "judgment standard 8";
					end
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1628 + 2209) < (2708 - (832 + 570)))) then
						return "judgment standard 8";
					end
					break;
				end
			end
		end
		if (((2780 + 170) == (770 + 2180)) and v98.HammerofWrath:IsReady() and v39) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((16713 - 11990) < (1589 + 1709))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((1932 - (588 + 208)) >= (414 - 260)) and v98.Judgment:IsReady() and v40 and ((v98.Judgment:Charges() >= (1802 - (884 + 916))) or (v98.Judgment:FullRechargeTime() <= v15:GCD()))) then
			if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((567 - 296) > (2753 + 1995))) then
				return "judgment standard 12";
			end
			if (((5393 - (232 + 421)) >= (5041 - (1569 + 320))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment standard 12";
			end
		end
		if ((v98.AvengersShield:IsCastable() and v34 and ((v107 > (1 + 1)) or v15:BuffUp(v98.MomentofGloryBuff))) or ((490 + 2088) >= (11423 - 8033))) then
			if (((646 - (316 + 289)) <= (4347 - 2686)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield standard 14";
			end
		end
		if (((28 + 573) < (5013 - (666 + 787))) and v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady()) then
			if (((660 - (360 + 65)) < (643 + 44)) and v25(v98.DivineToll, not v17:IsInRange(284 - (79 + 175)))) then
				return "divine_toll standard 16";
			end
		end
		if (((7172 - 2623) > (900 + 253)) and v98.AvengersShield:IsCastable() and v34) then
			if (v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield)) or ((14327 - 9653) < (8997 - 4325))) then
				return "avengers_shield standard 18";
			end
		end
		if (((4567 - (503 + 396)) < (4742 - (92 + 89))) and v98.HammerofWrath:IsReady() and v39) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((882 - 427) == (1849 + 1756))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if ((v98.Judgment:IsReady() and v40) or ((1577 + 1086) == (12970 - 9658))) then
			local v158 = 0 + 0;
			while true do
				if (((9751 - 5474) <= (3905 + 570)) and ((0 + 0) == v158)) then
					if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((2649 - 1779) == (149 + 1040))) then
						return "judgment standard 22";
					end
					if (((2368 - 815) <= (4377 - (485 + 759))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 22";
					end
					break;
				end
			end
		end
		if ((v98.Consecration:IsCastable() and v36 and v15:BuffDown(v98.ConsecrationBuff) and ((v15:BuffStack(v98.SanctificationBuff) < (11 - 6)) or not v15:HasTier(1220 - (442 + 747), 1137 - (832 + 303)))) or ((3183 - (88 + 858)) >= (1071 + 2440))) then
			if (v25(v98.Consecration, not v17:IsInRange(7 + 1)) or ((55 + 1269) > (3809 - (766 + 23)))) then
				return "consecration standard 24";
			end
		end
		if (((v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and v98.InmostLight:IsAvailable() and (v106 >= (14 - 11))) or ((4091 - 1099) == (4955 - 3074))) then
			if (((10541 - 7435) > (2599 - (1036 + 37))) and v25(v98.EyeofTyr, not v17:IsInRange(6 + 2))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((5886 - 2863) < (3045 + 825)) and v98.BlessedHammer:IsCastable() and v35) then
			if (((1623 - (641 + 839)) > (987 - (910 + 3))) and v25(v98.BlessedHammer, not v17:IsInRange(20 - 12))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((1702 - (1466 + 218)) < (971 + 1141)) and v98.HammeroftheRighteous:IsCastable() and v38) then
			if (((2245 - (556 + 592)) <= (579 + 1049)) and v25(v98.HammeroftheRighteous, not v17:IsInRange(816 - (329 + 479)))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((5484 - (174 + 680)) == (15909 - 11279)) and v98.CrusaderStrike:IsCastable() and v37) then
			if (((7337 - 3797) > (1916 + 767)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((5533 - (396 + 343)) >= (290 + 2985)) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and not v98.InmostLight:IsAvailable()) then
			if (((2961 - (29 + 1448)) == (2873 - (135 + 1254))) and v25(v98.EyeofTyr, not v17:IsInRange(30 - 22))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((6686 - 5254) < (2370 + 1185)) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (1532 - (389 + 1138)))) then
			if (v25(v98.ArcaneTorrent, not v17:IsInRange(582 - (102 + 472))) or ((1006 + 59) > (1985 + 1593))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v98.Consecration:IsCastable() and v36 and (v15:BuffDown(v98.SanctificationEmpowerBuff))) or ((4471 + 324) < (2952 - (320 + 1225)))) then
			if (((3298 - 1445) < (2945 + 1868)) and v25(v98.Consecration, not v17:IsInRange(1472 - (157 + 1307)))) then
				return "consecration standard 38";
			end
		end
	end
	local function v124()
		local v133 = 1859 - (821 + 1038);
		while true do
			if ((v133 == (2 - 1)) or ((309 + 2512) < (4317 - 1886))) then
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v133 = 1 + 1;
			end
			if ((v133 == (0 - 0)) or ((3900 - (834 + 192)) < (139 + 2042))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v133 = 1 + 0;
			end
			if ((v133 == (1 + 1)) or ((4165 - 1476) <= (647 - (300 + 4)))) then
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v42 = EpicSettings.Settings['useBastionofLight'];
				v133 = 1 + 2;
			end
			if ((v133 == (10 - 6)) or ((2231 - (112 + 250)) == (801 + 1208))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v133 = 12 - 7;
			end
			if ((v133 == (4 + 2)) or ((1834 + 1712) < (1737 + 585))) then
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v133 == (3 + 2)) or ((1547 + 535) == (6187 - (1001 + 413)))) then
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v133 = 13 - 7;
			end
			if (((4126 - (244 + 638)) > (1748 - (627 + 66))) and ((8 - 5) == v133)) then
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v133 = 606 - (512 + 90);
			end
		end
	end
	local function v125()
		local v134 = 1906 - (1665 + 241);
		while true do
			if ((v134 == (722 - (373 + 344))) or ((1495 + 1818) <= (471 + 1307))) then
				v73 = EpicSettings.Settings['wordofGloryFocusHP'];
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v134 = 15 - 9;
			end
			if ((v134 == (4 - 1)) or ((2520 - (35 + 1064)) >= (1531 + 573))) then
				v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v66 = EpicSettings.Settings['ardentDefenderHP'];
				v67 = EpicSettings.Settings['divineShieldHP'];
				v68 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v134 = 8 - 4;
			end
			if (((8 + 1804) <= (4485 - (298 + 938))) and (v134 == (1259 - (233 + 1026)))) then
				v53 = EpicSettings.Settings['useRebuke'];
				v54 = EpicSettings.Settings['useHammerofJustice'];
				v55 = EpicSettings.Settings['useArdentDefender'];
				v56 = EpicSettings.Settings['useDivineShield'];
				v134 = 1667 - (636 + 1030);
			end
			if (((830 + 793) <= (1912 + 45)) and (v134 == (1 + 0))) then
				v57 = EpicSettings.Settings['useGuardianofAncientKings'];
				v58 = EpicSettings.Settings['useLayOnHands'];
				v59 = EpicSettings.Settings['useWordofGloryPlayer'];
				v60 = EpicSettings.Settings['useShieldoftheRighteous'];
				v134 = 1 + 1;
			end
			if (((4633 - (55 + 166)) == (856 + 3556)) and (v134 == (1 + 1))) then
				v61 = EpicSettings.Settings['useLayOnHandsFocus'];
				v62 = EpicSettings.Settings['useWordofGloryFocus'];
				v63 = EpicSettings.Settings['useWordofGloryMouseover'];
				v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v134 = 11 - 8;
			end
			if (((2047 - (36 + 261)) >= (1472 - 630)) and (v134 == (1374 - (34 + 1334)))) then
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((1681 + 2691) > (1438 + 412)) and (v134 == (1287 - (1035 + 248)))) then
				v69 = EpicSettings.Settings['layonHandsHP'];
				v70 = EpicSettings.Settings['wordofGloryHP'];
				v71 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v72 = EpicSettings.Settings['layOnHandsFocusHP'];
				v134 = 26 - (20 + 1);
			end
		end
	end
	local function v126()
		v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v83 = EpicSettings.Settings['InterruptWithStun'];
		v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v85 = EpicSettings.Settings['InterruptThreshold'];
		v80 = EpicSettings.Settings['DispelDebuffs'];
		v79 = EpicSettings.Settings['DispelBuffs'];
		v87 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v88 = EpicSettings.Settings['trinketsWithCD'];
		v90 = EpicSettings.Settings['racialsWithCD'];
		v92 = EpicSettings.Settings['useHealthstone'];
		v91 = EpicSettings.Settings['useHealingPotion'];
		v94 = EpicSettings.Settings['healthstoneHP'] or (319 - (134 + 185));
		v93 = EpicSettings.Settings['healingPotionHP'] or (1133 - (549 + 584));
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v81 = EpicSettings.Settings['handleAfflicted'];
		v82 = EpicSettings.Settings['HandleIncorporeal'];
		v96 = EpicSettings.Settings['HealOOC'];
		v97 = EpicSettings.Settings['HealOOCHP'] or (685 - (314 + 371));
	end
	local function v127()
		v125();
		v124();
		v126();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((796 - 564) < (1789 - (478 + 490))) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v104 = v15:GetEnemiesInMeleeRange(5 + 3);
		v105 = v15:GetEnemiesInRange(1202 - (786 + 386));
		if (((1677 - 1159) < (2281 - (1055 + 324))) and v31) then
			local v159 = 1340 - (1093 + 247);
			while true do
				if (((2661 + 333) > (91 + 767)) and (v159 == (0 - 0))) then
					v106 = #v104;
					v107 = #v105;
					break;
				end
			end
		else
			v106 = 3 - 2;
			v107 = 2 - 1;
		end
		v102 = v15:ActiveMitigationNeeded();
		v103 = v15:IsTankingAoE(19 - 11) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1336 + 2419) <= (3524 - 2609))) then
			if (((13600 - 9654) > (2823 + 920)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
				if (v25(v98.CrusaderAura) or ((3414 - 2079) >= (3994 - (364 + 324)))) then
					return "crusader_aura";
				end
			end
		end
		if (((13279 - 8435) > (5406 - 3153)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (((150 + 302) == (1891 - 1439)) and v15:AffectingCombat()) then
				if (v98.Intercession:IsCastable() or ((7297 - 2740) < (6338 - 4251))) then
					if (((5142 - (1249 + 19)) == (3497 + 377)) and v25(v98.Intercession, not v17:IsInRange(116 - 86), true)) then
						return "intercession target";
					end
				end
			elseif (v98.Redemption:IsCastable() or ((3024 - (686 + 400)) > (3873 + 1062))) then
				if (v25(v98.Redemption, not v17:IsInRange(259 - (73 + 156)), true) or ((21 + 4234) < (4234 - (721 + 90)))) then
					return "redemption target";
				end
			end
		end
		if (((17 + 1437) <= (8087 - 5596)) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v100.RedemptionMouseover) or ((4627 - (224 + 246)) <= (4540 - 1737))) then
				return "redemption mouseover";
			end
		end
		if (((8935 - 4082) >= (541 + 2441)) and v15:AffectingCombat()) then
			if (((99 + 4035) > (2466 + 891)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (5 - 2)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v100.IntercessionMouseover) or ((11371 - 7954) < (3047 - (203 + 310)))) then
					return "Intercession";
				end
			end
		end
		if (v15:AffectingCombat() or (v80 and v98.CleanseToxins:IsAvailable()) or ((4715 - (1238 + 755)) <= (12 + 152))) then
			local v160 = 1534 - (709 + 825);
			local v161;
			while true do
				if ((v160 == (0 - 0)) or ((3507 - 1099) < (2973 - (196 + 668)))) then
					v161 = v80 and v98.CleanseToxins:IsReady() and v33;
					v29 = v108.FocusUnit(v161, v100, 78 - 58, nil, 51 - 26);
					v160 = 834 - (171 + 662);
				end
				if ((v160 == (94 - (4 + 89))) or ((115 - 82) == (530 + 925))) then
					if (v29 or ((1945 - 1502) >= (1575 + 2440))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((4868 - (35 + 1451)) > (1619 - (28 + 1425))) and v33 and v80) then
			local v162 = 1993 - (941 + 1052);
			while true do
				if ((v162 == (1 + 0)) or ((1794 - (822 + 692)) == (4366 - 1307))) then
					if (((886 + 995) > (1590 - (45 + 252))) and v98.BlessingofFreedom:IsReady() and v108.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (((2333 + 24) == (812 + 1545)) and v25(v100.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if (((299 - 176) == (556 - (114 + 319))) and (v162 == (0 - 0))) then
					v29 = v108.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 51 - 11, 16 + 9);
					if (v29 or ((1572 - 516) >= (7106 - 3714))) then
						return v29;
					end
					v162 = 1964 - (556 + 1407);
				end
			end
		end
		if (v108.TargetIsValid() or v15:AffectingCombat() or ((2287 - (741 + 465)) < (1540 - (170 + 295)))) then
			local v163 = 0 + 0;
			while true do
				if ((v163 == (1 + 0)) or ((2582 - 1533) >= (3674 + 758))) then
					if ((v110 == (7126 + 3985)) or ((2700 + 2068) <= (2076 - (957 + 273)))) then
						v110 = v10.FightRemains(v104, false);
					end
					v111 = v15:HolyPower();
					break;
				end
				if ((v163 == (0 + 0)) or ((1345 + 2013) <= (5410 - 3990))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v163 = 2 - 1;
				end
			end
		end
		if (not v15:AffectingCombat() or ((11420 - 7681) <= (14879 - 11874))) then
			if ((v98.DevotionAura:IsCastable() and (v114())) or ((3439 - (389 + 1391)) >= (1339 + 795))) then
				if (v25(v98.DevotionAura) or ((340 + 2920) < (5361 - 3006))) then
					return "devotion_aura";
				end
			end
		end
		if (v81 or ((1620 - (783 + 168)) == (14173 - 9950))) then
			if (v77 or ((1665 + 27) < (899 - (309 + 2)))) then
				local v210 = 0 - 0;
				while true do
					if (((1212 - (1090 + 122)) == v210) or ((1556 + 3241) < (12261 - 8610))) then
						v29 = v108.HandleAfflicted(v98.CleanseToxins, v100.CleanseToxinsMouseover, 28 + 12);
						if (v29 or ((5295 - (628 + 490)) > (870 + 3980))) then
							return v29;
						end
						break;
					end
				end
			end
			if ((v15:BuffUp(v98.ShiningLightFreeBuff) and v78) or ((990 - 590) > (5077 - 3966))) then
				v29 = v108.HandleAfflicted(v98.WordofGlory, v100.WordofGloryMouseover, 814 - (431 + 343), true);
				if (((6161 - 3110) > (2907 - 1902)) and v29) then
					return v29;
				end
			end
		end
		if (((2918 + 775) <= (561 + 3821)) and v82) then
			v29 = v108.HandleIncorporeal(v98.Repentance, v100.RepentanceMouseOver, 1725 - (556 + 1139), true);
			if (v29 or ((3297 - (6 + 9)) > (751 + 3349))) then
				return v29;
			end
			v29 = v108.HandleIncorporeal(v98.TurnEvil, v100.TurnEvilMouseOver, 16 + 14, true);
			if (v29 or ((3749 - (28 + 141)) < (1102 + 1742))) then
				return v29;
			end
		end
		v29 = v117();
		if (((109 - 20) < (3181 + 1309)) and v29) then
			return v29;
		end
		if ((v80 and v33) or ((6300 - (486 + 831)) < (4704 - 2896))) then
			if (((13480 - 9651) > (713 + 3056)) and v14) then
				local v211 = 0 - 0;
				while true do
					if (((2748 - (668 + 595)) <= (2614 + 290)) and (v211 == (0 + 0))) then
						v29 = v116();
						if (((11641 - 7372) == (4559 - (23 + 267))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if (((2331 - (1129 + 815)) <= (3169 - (371 + 16))) and v16 and v16:Exists() and v16:IsAPlayer() and (v108.UnitHasCurseDebuff(v16) or v108.UnitHasPoisonDebuff(v16))) then
				if (v98.CleanseToxins:IsReady() or ((3649 - (1326 + 424)) <= (1736 - 819))) then
					if (v25(v100.CleanseToxinsMouseover) or ((15757 - 11445) <= (994 - (88 + 30)))) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v29 = v120();
		if (((3003 - (720 + 51)) <= (5774 - 3178)) and v29) then
			return v29;
		end
		if (((3871 - (421 + 1355)) < (6080 - 2394)) and v103) then
			v29 = v119();
			if (v29 or ((784 + 811) >= (5557 - (286 + 797)))) then
				return v29;
			end
		end
		if ((v108.TargetIsValid() and not v15:AffectingCombat() and v30) or ((16885 - 12266) < (4773 - 1891))) then
			local v164 = 439 - (397 + 42);
			while true do
				if ((v164 == (0 + 0)) or ((1094 - (24 + 776)) >= (7442 - 2611))) then
					v29 = v121();
					if (((2814 - (222 + 563)) <= (6794 - 3710)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v108.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) or ((1467 + 570) == (2610 - (23 + 167)))) then
			if (((6256 - (690 + 1108)) > (1409 + 2495)) and (v86 < v110)) then
				v29 = v122();
				if (((360 + 76) >= (971 - (40 + 808))) and v29) then
					return v29;
				end
			end
			if (((83 + 417) < (6944 - 5128)) and v87 and ((v32 and v88) or not v88) and v17:IsInRange(8 + 0)) then
				local v212 = 0 + 0;
				while true do
					if (((1960 + 1614) == (4145 - (47 + 524))) and (v212 == (0 + 0))) then
						v29 = v118();
						if (((604 - 383) < (583 - 193)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			v29 = v123();
			if (v29 or ((5046 - 2833) <= (3147 - (1165 + 561)))) then
				return v29;
			end
			if (((91 + 2967) < (15052 - 10192)) and v25(v98.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v128()
		local v153 = 0 + 0;
		while true do
			if ((v153 == (479 - (341 + 138))) or ((350 + 946) >= (9175 - 4729))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v112();
				break;
			end
		end
	end
	v21.SetAPL(392 - (89 + 237), v127, v128);
end;
return v0["Epix_Paladin_Protection.lua"]();

