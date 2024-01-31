local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1335 - (622 + 713);
	local v6;
	while true do
		if (((12625 - 9670) == (9544 - 6589)) and (v5 == (1739 - (404 + 1335)))) then
			v6 = v0[v4];
			if (not v6 or ((3309 - (183 + 223)) == (1819 - 324))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((1636 + 2910) >= (2612 - (10 + 327))) and (v5 == (1 + 0))) then
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
	local v109 = 11449 - (118 + 220);
	local v110 = 3703 + 7408;
	local v111 = 449 - (108 + 341);
	v10:RegisterForEvent(function()
		v109 = 4991 + 6120;
		v110 = 46975 - 35864;
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		if (((2312 - (711 + 782)) >= (41 - 19)) and v98.CleanseToxins:IsAvailable()) then
			v108.DispellableDebuffs = v13.MergeTable(v108.DispellableDiseaseDebuffs, v108.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v113(v128)
		return v128:DebuffRemains(v98.JudgmentDebuff);
	end
	local function v114()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v115()
		if (((3631 - (270 + 199)) == (1026 + 2136)) and v98.CleanseToxins:IsReady() and v108.DispellableFriendlyUnit(1844 - (580 + 1239))) then
			v108.Wait(2 - 1);
			if (v25(v100.CleanseToxinsFocus) or ((2266 + 103) > (160 + 4269))) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v116()
		if (((1784 + 2311) >= (8310 - 5127)) and v96 and (v15:HealthPercentage() <= v97)) then
			if (v98.FlashofLight:IsReady() or ((2306 + 1405) < (2175 - (645 + 522)))) then
				if (v25(v98.FlashofLight) or ((2839 - (1010 + 780)) <= (906 + 0))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v117()
		v29 = v108.HandleTopTrinket(v101, v32, 190 - 150, nil);
		if (((13225 - 8712) > (4562 - (1045 + 791))) and v29) then
			return v29;
		end
		v29 = v108.HandleBottomTrinket(v101, v32, 101 - 61, nil);
		if (v29 or ((2261 - 780) >= (3163 - (351 + 154)))) then
			return v29;
		end
	end
	local function v118()
		local v129 = 1574 - (1281 + 293);
		while true do
			if (((269 - (28 + 238)) == v129) or ((7195 - 3975) == (2923 - (1381 + 178)))) then
				if ((v99.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((989 + 65) > (2736 + 656))) then
					if (v25(v100.Healthstone) or ((289 + 387) >= (5660 - 4018))) then
						return "healthstone defensive";
					end
				end
				if (((2143 + 1993) > (2867 - (381 + 89))) and v91 and (v15:HealthPercentage() <= v93)) then
					local v209 = 0 + 0;
					while true do
						if ((v209 == (0 + 0)) or ((7423 - 3089) == (5401 - (1074 + 82)))) then
							if ((v95 == "Refreshing Healing Potion") or ((9370 - 5094) <= (4815 - (214 + 1570)))) then
								if (v99.RefreshingHealingPotion:IsReady() or ((6237 - (990 + 465)) <= (495 + 704))) then
									if (v25(v100.RefreshingHealingPotion) or ((2117 + 2747) < (1850 + 52))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((19043 - 14204) >= (5426 - (1668 + 58))) and (v95 == "Dreamwalker's Healing Potion")) then
								if (v99.DreamwalkersHealingPotion:IsReady() or ((1701 - (512 + 114)) > (5000 - 3082))) then
									if (((818 - 422) <= (13236 - 9432)) and v25(v100.RefreshingHealingPotion)) then
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
			if ((v129 == (1 + 1)) or ((781 + 3388) == (1902 + 285))) then
				if (((4742 - 3336) == (3400 - (109 + 1885))) and v98.WordofGlory:IsReady() and (v15:HealthPercentage() <= v70) and v59 and not v15:HealingAbsorbed()) then
					if (((3000 - (1269 + 200)) < (8186 - 3915)) and ((v15:BuffRemains(v98.ShieldoftheRighteousBuff) >= (820 - (98 + 717))) or v15:BuffUp(v98.DivinePurposeBuff) or v15:BuffUp(v98.ShiningLightFreeBuff))) then
						if (((1461 - (802 + 24)) == (1095 - 460)) and v25(v100.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((4259 - 886) <= (526 + 3030)) and v98.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 + 0)) and v15:BuffRefreshable(v98.ShieldoftheRighteousBuff) and v60 and (v102 or (v15:HealthPercentage() <= v71))) then
					if (v25(v98.ShieldoftheRighteous) or ((541 + 2750) < (708 + 2572))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v129 = 8 - 5;
			end
			if (((14626 - 10240) >= (313 + 560)) and (v129 == (1 + 0))) then
				if (((760 + 161) <= (802 + 300)) and v98.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v98.ArdentDefenderBuff)) then
					if (((2198 + 2508) >= (2396 - (797 + 636))) and v25(v98.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v98.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v66) and v55 and v15:BuffDown(v98.GuardianofAncientKingsBuff)) or ((4661 - 3701) <= (2495 - (1427 + 192)))) then
					if (v25(v98.ArdentDefender) or ((716 + 1350) == (2163 - 1231))) then
						return "ardent_defender defensive 6";
					end
				end
				v129 = 2 + 0;
			end
			if (((2187 + 2638) < (5169 - (192 + 134))) and (v129 == (1276 - (316 + 960)))) then
				if (((v15:HealthPercentage() <= v67) and v56 and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((2158 + 1719) >= (3502 + 1035))) then
					if (v25(v98.DivineShield) or ((3989 + 326) < (6598 - 4872))) then
						return "divine_shield defensive";
					end
				end
				if (((v15:HealthPercentage() <= v69) and v58 and v98.LayonHands:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((4230 - (83 + 468)) < (2431 - (1202 + 604)))) then
					if (v25(v100.LayonHandsPlayer) or ((21590 - 16965) < (1051 - 419))) then
						return "lay_on_hands defensive 2";
					end
				end
				v129 = 2 - 1;
			end
		end
	end
	local function v119()
		local v130 = 325 - (45 + 280);
		while true do
			if (((1 + 0) == v130) or ((73 + 10) > (650 + 1130))) then
				if (((303 + 243) <= (190 + 887)) and v14) then
					if ((v98.WordofGlory:IsReady() and v62 and v15:BuffUp(v98.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v73)) or ((1844 - 848) > (6212 - (340 + 1571)))) then
						if (((1606 + 2464) > (2459 - (1733 + 39))) and v25(v100.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v98.LayonHands:IsCastable() and v61 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) or ((1802 - 1146) >= (4364 - (125 + 909)))) then
						if (v25(v100.LayonHandsFocus) or ((4440 - (1096 + 852)) <= (151 + 184))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((6171 - 1849) >= (2485 + 77)) and v98.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) then
						if (v25(v100.BlessingofSacrificeFocus) or ((4149 - (409 + 103)) >= (4006 - (46 + 190)))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v98.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((2474 - (51 + 44)) > (1292 + 3286))) then
						if (v25(v100.BlessingofProtectionFocus) or ((1800 - (1114 + 203)) > (1469 - (228 + 498)))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((532 + 1922) > (320 + 258)) and (v130 == (663 - (174 + 489)))) then
				if (((2422 - 1492) < (6363 - (830 + 1075))) and v16:Exists()) then
					if (((1186 - (303 + 221)) <= (2241 - (231 + 1038))) and v98.WordofGlory:IsReady() and v63 and (v16:HealthPercentage() <= v74)) then
						if (((3642 + 728) == (5532 - (171 + 991))) and v25(v100.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(123 - 93) or ((12786 - 8024) <= (2148 - 1287))) then
					return;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v120()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (5 - 3)) or ((2275 - 863) == (13180 - 8916))) then
				if ((v98.Judgment:IsReady() and v40) or ((4416 - (111 + 1137)) < (2311 - (91 + 67)))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((14809 - 9833) < (333 + 999))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((5151 - (423 + 100)) == (33 + 4595)) and (v131 == (2 - 1))) then
				if ((v98.Consecration:IsCastable() and v36) or ((29 + 25) == (1166 - (326 + 445)))) then
					if (((357 - 275) == (182 - 100)) and v25(v98.Consecration, not v17:IsInRange(18 - 10))) then
						return "consecration";
					end
				end
				if ((v98.AvengersShield:IsCastable() and v34) or ((1292 - (530 + 181)) < (1163 - (614 + 267)))) then
					if (v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield)) or ((4641 - (19 + 13)) < (4060 - 1565))) then
						return "avengers_shield precombat 10";
					end
				end
				v131 = 4 - 2;
			end
			if (((3290 - 2138) == (300 + 852)) and (v131 == (0 - 0))) then
				if (((3931 - 2035) <= (5234 - (1293 + 519))) and (v86 < v110) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90)) then
					if (v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment)) or ((2019 - 1029) > (4229 - 2609))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v86 < v110) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (9 - 4))) or ((3781 - 2904) > (11060 - 6365))) then
					if (((1426 + 1265) >= (378 + 1473)) and v25(v98.ArcaneTorrent, not v17:IsInRange(18 - 10))) then
						return "arcane_torrent precombat 6";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v121()
		if ((v98.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (1 + 1)) and v15:HasTier(19 + 10, 1098 - (709 + 387))) or ((4843 - (673 + 1185)) >= (14082 - 9226))) then
			if (((13730 - 9454) >= (1966 - 771)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((2312 + 920) <= (3505 + 1185)) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90) and (v107 >= (2 - 0))) then
			if (v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment)) or ((221 + 675) >= (6272 - 3126))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((6008 - 2947) >= (4838 - (446 + 1434))) and v98.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) then
			if (((4470 - (1040 + 243)) >= (1922 - 1278)) and v25(v98.AvengingWrath, not v17:IsInRange(1855 - (559 + 1288)))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((2575 - (609 + 1322)) <= (1158 - (13 + 441))) and v98.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) then
			if (((3579 - 2621) > (2480 - 1533)) and v25(v98.Sentinel, not v17:IsInRange(39 - 31))) then
				return "sentinel cooldowns 8";
			end
		end
		local v132 = v108.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff));
		if (((168 + 4324) >= (9638 - 6984)) and v132) then
			return v132;
		end
		if (((1223 + 2219) >= (659 + 844)) and v98.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v98.SentinelBuff) < (44 - 29)) or (((v10.CombatTime() > (6 + 4)) or (v98.Sentinel:CooldownRemains() > (27 - 12)) or (v98.AvengingWrath:CooldownRemains() > (10 + 5))) and (v98.AvengersShield:CooldownRemains() > (0 + 0)) and (v98.Judgment:CooldownRemains() > (0 + 0)) and (v98.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (v25(v98.MomentofGlory, not v17:IsInRange(8 + 0)) or ((3603 - (153 + 280)) <= (4227 - 2763))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady() and (v106 >= (3 + 0))) or ((1895 + 2902) == (2297 + 2091))) then
			if (((501 + 50) <= (494 + 187)) and v25(v98.DivineToll, not v17:IsInRange(45 - 15))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((2026 + 1251) > (1074 - (89 + 578))) and v98.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v98.AvengingWrathBuff) or (v98.AvengingWrath:CooldownRemains() <= (22 + 8)))) then
			if (((9760 - 5065) >= (2464 - (572 + 477))) and v25(v98.BastionofLight, not v17:IsInRange(2 + 6))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v122()
		if ((v98.Consecration:IsCastable() and v36 and (v15:BuffStack(v98.SanctificationBuff) == (4 + 1))) or ((384 + 2828) <= (1030 - (84 + 2)))) then
			if (v25(v98.Consecration, not v17:IsInRange(13 - 5)) or ((2231 + 865) <= (2640 - (497 + 345)))) then
				return "consecration standard 2";
			end
		end
		if (((91 + 3446) == (598 + 2939)) and v98.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (1335 - (605 + 728))) or v15:BuffUp(v98.BastionofLightBuff) or v15:BuffUp(v98.DivinePurposeBuff)) and (v15:BuffDown(v98.SanctificationBuff) or (v15:BuffStack(v98.SanctificationBuff) < (4 + 1)))) then
			if (((8530 - 4693) >= (72 + 1498)) and v25(v98.ShieldoftheRighteous)) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if ((v98.Judgment:IsReady() and v40 and (v106 > (10 - 7)) and (v15:BuffStack(v98.BulwarkofRighteousFuryBuff) >= (3 + 0)) and (v15:HolyPower() < (7 - 4))) or ((2228 + 722) == (4301 - (457 + 32)))) then
			if (((2004 + 2719) >= (3720 - (832 + 570))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment standard 6";
			end
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1910 + 117) > (744 + 2108))) then
				return "judgment standard 6";
			end
		end
		if ((v98.Judgment:IsReady() and v40 and v15:BuffDown(v98.SanctificationEmpowerBuff) and v15:HasTier(109 - 78, 1 + 1)) or ((1932 - (588 + 208)) > (11635 - 7318))) then
			if (((6548 - (884 + 916)) == (9940 - 5192)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment standard 8";
			end
			if (((2167 + 1569) <= (5393 - (232 + 421))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
				return "judgment standard 8";
			end
		end
		if ((v98.HammerofWrath:IsReady() and v39) or ((5279 - (1569 + 320)) <= (751 + 2309))) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((190 + 809) > (9074 - 6381))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((1068 - (316 + 289)) < (1573 - 972)) and v98.Judgment:IsReady() and v40 and ((v98.Judgment:Charges() >= (1 + 1)) or (v98.Judgment:FullRechargeTime() <= v15:GCD()))) then
			local v161 = 1453 - (666 + 787);
			while true do
				if (((425 - (360 + 65)) == v161) or ((2041 + 142) < (941 - (79 + 175)))) then
					if (((7172 - 2623) == (3550 + 999)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 12";
					end
					if (((14320 - 9648) == (8997 - 4325)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 12";
					end
					break;
				end
			end
		end
		if ((v98.AvengersShield:IsCastable() and v34 and ((v107 > (901 - (503 + 396))) or v15:BuffUp(v98.MomentofGloryBuff))) or ((3849 - (92 + 89)) < (765 - 370))) then
			if (v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield)) or ((2137 + 2029) == (270 + 185))) then
				return "avengers_shield standard 14";
			end
		end
		if ((v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady()) or ((17422 - 12973) == (365 + 2298))) then
			if (v25(v98.DivineToll, not v17:IsInRange(68 - 38)) or ((3732 + 545) < (1428 + 1561))) then
				return "divine_toll standard 16";
			end
		end
		if ((v98.AvengersShield:IsCastable() and v34) or ((2649 - 1779) >= (518 + 3631))) then
			if (((3372 - 1160) < (4427 - (485 + 759))) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if (((10750 - 6104) > (4181 - (442 + 747))) and v98.HammerofWrath:IsReady() and v39) then
			if (((2569 - (832 + 303)) < (4052 - (88 + 858))) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if (((240 + 546) < (2502 + 521)) and v98.Judgment:IsReady() and v40) then
			local v162 = 0 + 0;
			while true do
				if ((v162 == (789 - (766 + 23))) or ((12055 - 9613) < (101 - 27))) then
					if (((11948 - 7413) == (15391 - 10856)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 22";
					end
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((4082 - (1036 + 37)) <= (1493 + 612))) then
						return "judgment standard 22";
					end
					break;
				end
			end
		end
		if (((3563 - 1733) < (2887 + 782)) and v98.Consecration:IsCastable() and v36 and v15:BuffDown(v98.ConsecrationBuff) and ((v15:BuffStack(v98.SanctificationBuff) < (1485 - (641 + 839))) or not v15:HasTier(944 - (910 + 3), 4 - 2))) then
			if (v25(v98.Consecration, not v17:IsInRange(1692 - (1466 + 218))) or ((658 + 772) >= (4760 - (556 + 592)))) then
				return "consecration standard 24";
			end
		end
		if (((955 + 1728) >= (3268 - (329 + 479))) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and v98.InmostLight:IsAvailable() and (v106 >= (857 - (174 + 680)))) then
			if (v25(v98.EyeofTyr, not v17:IsInRange(27 - 19)) or ((3739 - 1935) >= (2339 + 936))) then
				return "eye_of_tyr standard 26";
			end
		end
		if ((v98.BlessedHammer:IsCastable() and v35) or ((2156 - (396 + 343)) > (322 + 3307))) then
			if (((6272 - (29 + 1448)) > (1791 - (135 + 1254))) and v25(v98.BlessedHammer, not v17:IsInRange(30 - 22))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((22472 - 17659) > (2376 + 1189)) and v98.HammeroftheRighteous:IsCastable() and v38) then
			if (((5439 - (389 + 1138)) == (4486 - (102 + 472))) and v25(v98.HammeroftheRighteous, not v17:IsInRange(8 + 0))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((1565 + 1256) <= (4499 + 325)) and v98.CrusaderStrike:IsCastable() and v37) then
			if (((3283 - (320 + 1225)) <= (3907 - 1712)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((26 + 15) <= (4482 - (157 + 1307))) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and not v98.InmostLight:IsAvailable()) then
			if (((4004 - (821 + 1038)) <= (10239 - 6135)) and v25(v98.EyeofTyr, not v17:IsInRange(1 + 7))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((4775 - 2086) < (1803 + 3042)) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (12 - 7))) then
			if (v25(v98.ArcaneTorrent, not v17:IsInRange(1034 - (834 + 192))) or ((148 + 2174) > (673 + 1949))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v98.Consecration:IsCastable() and v36 and (v15:BuffDown(v98.SanctificationEmpowerBuff))) or ((98 + 4436) == (3224 - 1142))) then
			if (v25(v98.Consecration, not v17:IsInRange(312 - (300 + 4))) or ((420 + 1151) > (4887 - 3020))) then
				return "consecration standard 38";
			end
		end
	end
	local function v123()
		v34 = EpicSettings.Settings['useAvengersShield'];
		v35 = EpicSettings.Settings['useBlessedHammer'];
		v36 = EpicSettings.Settings['useConsecration'];
		v37 = EpicSettings.Settings['useCrusaderStrike'];
		v38 = EpicSettings.Settings['useHammeroftheRighteous'];
		v39 = EpicSettings.Settings['useHammerofWrath'];
		v40 = EpicSettings.Settings['useJudgment'];
		v41 = EpicSettings.Settings['useAvengingWrath'];
		v42 = EpicSettings.Settings['useBastionofLight'];
		v43 = EpicSettings.Settings['useDivineToll'];
		v44 = EpicSettings.Settings['useEyeofTyr'];
		v45 = EpicSettings.Settings['useMomentOfGlory'];
		v46 = EpicSettings.Settings['useSentinel'];
		v47 = EpicSettings.Settings['avengingWrathWithCD'];
		v48 = EpicSettings.Settings['bastionofLightWithCD'];
		v49 = EpicSettings.Settings['divineTollWithCD'];
		v50 = EpicSettings.Settings['eyeofTyrWithCD'];
		v51 = EpicSettings.Settings['momentofGloryWithCD'];
		v52 = EpicSettings.Settings['sentinelWithCD'];
	end
	local function v124()
		local v152 = 362 - (112 + 250);
		while true do
			if ((v152 == (2 + 3)) or ((6648 - 3994) >= (1717 + 1279))) then
				v73 = EpicSettings.Settings['wordofGloryFocusHP'];
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v152 = 4 + 2;
			end
			if (((2976 + 1002) > (1044 + 1060)) and (v152 == (1 + 0))) then
				v57 = EpicSettings.Settings['useGuardianofAncientKings'];
				v58 = EpicSettings.Settings['useLayOnHands'];
				v59 = EpicSettings.Settings['useWordofGloryPlayer'];
				v60 = EpicSettings.Settings['useShieldoftheRighteous'];
				v152 = 1416 - (1001 + 413);
			end
			if (((6678 - 3683) > (2423 - (244 + 638))) and (v152 == (695 - (627 + 66)))) then
				v61 = EpicSettings.Settings['useLayOnHandsFocus'];
				v62 = EpicSettings.Settings['useWordofGloryFocus'];
				v63 = EpicSettings.Settings['useWordofGloryMouseover'];
				v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v152 = 8 - 5;
			end
			if (((3851 - (512 + 90)) > (2859 - (1665 + 241))) and ((717 - (373 + 344)) == v152)) then
				v53 = EpicSettings.Settings['useRebuke'];
				v54 = EpicSettings.Settings['useHammerofJustice'];
				v55 = EpicSettings.Settings['useArdentDefender'];
				v56 = EpicSettings.Settings['useDivineShield'];
				v152 = 1 + 0;
			end
			if ((v152 == (2 + 2)) or ((8633 - 5360) > (7738 - 3165))) then
				v69 = EpicSettings.Settings['layonHandsHP'];
				v70 = EpicSettings.Settings['wordofGloryHP'];
				v71 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v72 = EpicSettings.Settings['layOnHandsFocusHP'];
				v152 = 1104 - (35 + 1064);
			end
			if ((v152 == (3 + 0)) or ((6741 - 3590) < (6 + 1278))) then
				v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v66 = EpicSettings.Settings['ardentDefenderHP'];
				v67 = EpicSettings.Settings['divineShieldHP'];
				v68 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v152 = 1240 - (298 + 938);
			end
			if ((v152 == (1265 - (233 + 1026))) or ((3516 - (636 + 1030)) == (782 + 747))) then
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
		end
	end
	local function v125()
		local v153 = 0 + 0;
		while true do
			if (((244 + 577) < (144 + 1979)) and (v153 == (221 - (55 + 166)))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v153 = 1 + 0;
			end
			if (((3444 - 2542) < (2622 - (36 + 261))) and (v153 == (9 - 3))) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (1368 - (34 + 1334));
				break;
			end
			if (((330 + 528) <= (2302 + 660)) and (v153 == (1286 - (1035 + 248)))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v153 = 25 - (20 + 1);
			end
			if ((v153 == (1 + 0)) or ((4265 - (134 + 185)) < (2421 - (549 + 584)))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v153 = 687 - (314 + 371);
			end
			if ((v153 == (13 - 9)) or ((4210 - (478 + 490)) == (301 + 266))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (1172 - (786 + 386));
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v153 = 1384 - (1055 + 324);
			end
			if ((v153 == (1345 - (1093 + 247))) or ((753 + 94) >= (133 + 1130))) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v153 = 23 - 17;
			end
			if ((v153 == (6 - 4)) or ((6410 - 4157) == (4651 - 2800))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v153 = 2 + 1;
			end
		end
	end
	local function v126()
		v124();
		v123();
		v125();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((8040 - 5953) > (8175 - 5803))) then
			return v29;
		end
		v104 = v15:GetEnemiesInMeleeRange(7 + 1);
		v105 = v15:GetEnemiesInRange(76 - 46);
		if (v31 or ((5133 - (364 + 324)) < (11373 - 7224))) then
			v106 = #v104;
			v107 = #v105;
		else
			v106 = 2 - 1;
			v107 = 1 + 0;
		end
		v102 = v15:ActiveMitigationNeeded();
		v103 = v15:IsTankingAoE(33 - 25) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((2911 - 1093) == (258 - 173))) then
			if (((1898 - (1249 + 19)) < (1920 + 207)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
				if (v25(v98.CrusaderAura) or ((7543 - 5605) == (3600 - (686 + 400)))) then
					return "crusader_aura";
				end
			end
		end
		if (((3339 + 916) >= (284 - (73 + 156))) and (v15:AffectingCombat() or (v80 and v98.CleanseToxins:IsAvailable()))) then
			local v163 = 0 + 0;
			local v164;
			while true do
				if (((3810 - (721 + 90)) > (13 + 1143)) and (v163 == (0 - 0))) then
					v164 = v80 and v98.CleanseToxins:IsReady() and v33;
					v29 = v108.FocusUnit(v164, v100, 490 - (224 + 246), nil, 40 - 15);
					v163 = 1 - 0;
				end
				if (((427 + 1923) > (28 + 1127)) and (v163 == (1 + 0))) then
					if (((8009 - 3980) <= (16149 - 11296)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v33 and v80) or ((1029 - (203 + 310)) > (5427 - (1238 + 755)))) then
			v29 = v108.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 3 + 37, 1559 - (709 + 825));
			if (((7455 - 3409) >= (4417 - 1384)) and v29) then
				return v29;
			end
			if ((v98.BlessingofFreedom:IsReady() and v108.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((3583 - (196 + 668)) <= (5713 - 4266))) then
				if (v25(v100.BlessingofFreedomFocus) or ((8562 - 4428) < (4759 - (171 + 662)))) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (v108.TargetIsValid() or v15:AffectingCombat() or ((257 - (4 + 89)) >= (9761 - 6976))) then
			v109 = v10.BossFightRemains(nil, true);
			v110 = v109;
			if ((v110 == (4046 + 7065)) or ((2305 - 1780) == (828 + 1281))) then
				v110 = v10.FightRemains(v104, false);
			end
			v111 = v15:HolyPower();
		end
		if (((1519 - (35 + 1451)) == (1486 - (28 + 1425))) and not v15:AffectingCombat()) then
			if (((5047 - (941 + 1052)) <= (3850 + 165)) and v98.DevotionAura:IsCastable() and (v114())) then
				if (((3385 - (822 + 692)) < (4827 - 1445)) and v25(v98.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (((610 + 683) <= (2463 - (45 + 252))) and v81) then
			if (v77 or ((2552 + 27) < (43 + 80))) then
				local v207 = 0 - 0;
				while true do
					if ((v207 == (433 - (114 + 319))) or ((1213 - 367) >= (3033 - 665))) then
						v29 = v108.HandleAfflicted(v98.CleanseToxins, v100.CleanseToxinsMouseover, 26 + 14);
						if (v29 or ((5976 - 1964) <= (7035 - 3677))) then
							return v29;
						end
						break;
					end
				end
			end
			if (((3457 - (556 + 1407)) <= (4211 - (741 + 465))) and v15:BuffUp(v98.ShiningLightFreeBuff) and v78) then
				v29 = v108.HandleAfflicted(v98.WordofGlory, v100.WordofGloryMouseover, 505 - (170 + 295), true);
				if (v29 or ((1640 + 1471) == (1961 + 173))) then
					return v29;
				end
			end
		end
		if (((5797 - 3442) == (1953 + 402)) and v82) then
			local v165 = 0 + 0;
			while true do
				if (((0 + 0) == v165) or ((1818 - (957 + 273)) <= (116 + 316))) then
					v29 = v108.HandleIncorporeal(v98.Repentance, v100.RepentanceMouseOver, 13 + 17, true);
					if (((18278 - 13481) >= (10264 - 6369)) and v29) then
						return v29;
					end
					v165 = 2 - 1;
				end
				if (((17712 - 14135) == (5357 - (389 + 1391))) and ((1 + 0) == v165)) then
					v29 = v108.HandleIncorporeal(v98.TurnEvil, v100.TurnEvilMouseOver, 4 + 26, true);
					if (((8637 - 4843) > (4644 - (783 + 168))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		v29 = v116();
		if (v29 or ((4279 - 3004) == (4033 + 67))) then
			return v29;
		end
		if ((v80 and v33) or ((1902 - (309 + 2)) >= (10993 - 7413))) then
			if (((2195 - (1090 + 122)) <= (587 + 1221)) and v14) then
				local v208 = 0 - 0;
				while true do
					if (((0 + 0) == v208) or ((3268 - (628 + 490)) <= (215 + 982))) then
						v29 = v115();
						if (((9331 - 5562) >= (5360 - 4187)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if (((2259 - (431 + 343)) == (2999 - 1514)) and v16 and v16:Exists() and v16:IsAPlayer() and (v108.UnitHasCurseDebuff(v16) or v108.UnitHasPoisonDebuff(v16))) then
				if (v98.CleanseToxins:IsReady() or ((9590 - 6275) <= (2198 + 584))) then
					if (v25(v100.CleanseToxinsMouseover) or ((113 + 763) >= (4659 - (556 + 1139)))) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v29 = v119();
		if (v29 or ((2247 - (6 + 9)) > (458 + 2039))) then
			return v29;
		end
		if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1081 + 1029) <= (501 - (28 + 141)))) then
			if (((1428 + 2258) > (3914 - 742)) and v25(v100.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (v15:AffectingCombat() or ((3169 + 1305) < (2137 - (486 + 831)))) then
			if (((11134 - 6855) >= (10146 - 7264)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (1 + 2)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v100.IntercessionMouseover) or ((6415 - 4386) >= (4784 - (668 + 595)))) then
					return "Intercession";
				end
			end
		end
		if ((v108.TargetIsValid() and not v15:AffectingCombat() and v30) or ((1833 + 204) >= (936 + 3706))) then
			local v166 = 0 - 0;
			while true do
				if (((2010 - (23 + 267)) < (6402 - (1129 + 815))) and ((387 - (371 + 16)) == v166)) then
					v29 = v120();
					if (v29 or ((2186 - (1326 + 424)) > (5721 - 2700))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((2605 - 1892) <= (965 - (88 + 30))) and v108.TargetIsValid()) then
			if (((2925 - (720 + 51)) <= (8966 - 4935)) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
				if (((6391 - (421 + 1355)) == (7613 - 2998)) and v15:AffectingCombat()) then
					if (v98.Intercession:IsCastable() or ((1862 + 1928) == (1583 - (286 + 797)))) then
						if (((325 - 236) < (365 - 144)) and v25(v98.Intercession, not v17:IsInRange(469 - (397 + 42)), true)) then
							return "intercession";
						end
					end
				elseif (((642 + 1412) >= (2221 - (24 + 776))) and v98.Redemption:IsCastable()) then
					if (((1065 - 373) < (3843 - (222 + 563))) and v25(v98.Redemption, not v17:IsInRange(66 - 36), true)) then
						return "redemption";
					end
				end
			end
			if ((v108.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) or ((2343 + 911) == (1845 - (23 + 167)))) then
				if (v103 or ((3094 - (690 + 1108)) == (1772 + 3138))) then
					v29 = v118();
					if (((2779 + 589) == (4216 - (40 + 808))) and v29) then
						return v29;
					end
				end
				if (((436 + 2207) < (14588 - 10773)) and (v86 < v110)) then
					v29 = v121();
					if (((1829 + 84) > (261 + 232)) and v29) then
						return v29;
					end
				end
				if (((2608 + 2147) > (3999 - (47 + 524))) and v87 and ((v32 and v88) or not v88) and v17:IsInRange(6 + 2)) then
					v29 = v117();
					if (((3774 - 2393) <= (3541 - 1172)) and v29) then
						return v29;
					end
				end
				v29 = v122();
				if (v29 or ((11044 - 6201) == (5810 - (1165 + 561)))) then
					return v29;
				end
				if (((139 + 4530) > (1124 - 761)) and v25(v98.Pool)) then
					return "Wait/Pool Resources";
				end
			end
		end
	end
	local function v127()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (479 - (341 + 138))) or ((507 + 1370) >= (6475 - 3337))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v112();
				break;
			end
		end
	end
	v21.SetAPL(392 - (89 + 237), v126, v127);
end;
return v0["Epix_Paladin_Protection.lua"]();

