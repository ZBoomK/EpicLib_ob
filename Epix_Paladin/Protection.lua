local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5378 - (580 + 1239)) <= (1266 - 840))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Focus;
	local v14 = v11.Player;
	local v15 = v11.MouseOver;
	local v16 = v11.Target;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = string.format;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33;
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
	local v97 = v18.Paladin.Protection;
	local v98 = v19.Paladin.Protection;
	local v99 = v23.Paladin.Protection;
	local v100 = {};
	local v101;
	local v102;
	local v103, v104;
	local v105, v106;
	local v107 = v20.Commons.Everyone;
	local v108 = 10624 + 487;
	local v109 = 400 + 10711;
	local v110 = 0 + 0;
	v9:RegisterForEvent(function()
		local v127 = 0 - 0;
		while true do
			if (((627 + 381) <= (4878 - (645 + 522))) and (v127 == (1790 - (1010 + 780)))) then
				v108 = 11106 + 5;
				v109 = 52931 - 41820;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (v97.CleanseToxins:IsAvailable() or ((3074 - 2025) <= (2742 - (1045 + 791)))) then
			v107.DispellableDebuffs = v12.MergeTable(v107.DispellableDiseaseDebuffs, v107.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v111();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v112(v128)
		return v128:DebuffRemains(v97.JudgmentDebuff);
	end
	local function v113()
		return v14:BuffDown(v97.RetributionAura) and v14:BuffDown(v97.DevotionAura) and v14:BuffDown(v97.ConcentrationAura) and v14:BuffDown(v97.CrusaderAura);
	end
	local function v114()
		if (((11423 - 6910) > (4162 - 1436)) and v97.CleanseToxins:IsReady() and v32 and v107.DispellableFriendlyUnit(530 - (351 + 154))) then
			if (v24(v99.CleanseToxinsFocus) or ((3055 - (1281 + 293)) >= (2924 - (28 + 238)))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v115()
		if ((v95 and (v14:HealthPercentage() <= v96)) or ((7195 - 3975) == (2923 - (1381 + 178)))) then
			if (v97.FlashofLight:IsReady() or ((989 + 65) > (2736 + 656))) then
				if (v24(v97.FlashofLight) or ((289 + 387) >= (5660 - 4018))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v116()
		local v129 = 0 + 0;
		while true do
			if (((4606 - (381 + 89)) > (2126 + 271)) and (v129 == (1 + 0))) then
				v28 = v107.HandleBottomTrinket(v100, v31, 68 - 28, nil);
				if (v28 or ((5490 - (1074 + 82)) == (9302 - 5057))) then
					return v28;
				end
				break;
			end
			if ((v129 == (1784 - (214 + 1570))) or ((5731 - (990 + 465)) <= (1250 + 1781))) then
				v28 = v107.HandleTopTrinket(v100, v31, 18 + 22, nil);
				if (v28 or ((4651 + 131) <= (4718 - 3519))) then
					return v28;
				end
				v129 = 1727 - (1668 + 58);
			end
		end
	end
	local function v117()
		if (((v14:HealthPercentage() <= v66) and v55 and v97.DivineShield:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((5490 - (512 + 114)) < (4958 - 3056))) then
			if (((10003 - 5164) >= (12874 - 9174)) and v24(v97.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((v14:HealthPercentage() <= v68) and v57 and v97.LayonHands:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((501 + 574) > (360 + 1558))) then
			if (((345 + 51) <= (12830 - 9026)) and v24(v99.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v97.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v97.ArdentDefenderBuff)) or ((6163 - (109 + 1885)) == (3656 - (1269 + 200)))) then
			if (((2694 - 1288) == (2221 - (98 + 717))) and v24(v97.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((2357 - (802 + 24)) < (7365 - 3094)) and v97.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v65) and v54 and v14:BuffDown(v97.GuardianofAncientKingsBuff)) then
			if (((801 - 166) == (94 + 541)) and v24(v97.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if (((2592 + 781) <= (585 + 2971)) and v97.WordofGlory:IsReady() and (v14:HealthPercentage() <= v69) and v58 and not v14:HealingAbsorbed()) then
			if ((v14:BuffRemains(v97.ShieldoftheRighteousBuff) >= (2 + 3)) or v14:BuffUp(v97.DivinePurposeBuff) or v14:BuffUp(v97.ShiningLightFreeBuff) or ((9155 - 5864) < (10938 - 7658))) then
				if (((1569 + 2817) >= (356 + 517)) and v24(v99.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((760 + 161) <= (802 + 300)) and v97.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (1 + 1)) and v14:BuffRefreshable(v97.ShieldoftheRighteousBuff) and v59 and (v101 or (v14:HealthPercentage() <= v70))) then
			if (((6139 - (797 + 636)) >= (4675 - 3712)) and v24(v97.ShieldoftheRighteous)) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v98.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or ((2579 - (1427 + 192)) <= (304 + 572))) then
			if (v24(v99.Healthstone) or ((4796 - 2730) == (838 + 94))) then
				return "healthstone defensive";
			end
		end
		if (((2187 + 2638) < (5169 - (192 + 134))) and v90 and (v14:HealthPercentage() <= v92)) then
			local v157 = 1276 - (316 + 960);
			while true do
				if ((v157 == (0 + 0)) or ((2992 + 885) >= (4194 + 343))) then
					if ((v94 == "Refreshing Healing Potion") or ((16496 - 12181) < (2277 - (83 + 468)))) then
						if (v98.RefreshingHealingPotion:IsReady() or ((5485 - (1202 + 604)) < (2917 - 2292))) then
							if (v24(v99.RefreshingHealingPotion) or ((7697 - 3072) < (1749 - 1117))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v94 == "Dreamwalker's Healing Potion") or ((408 - (45 + 280)) > (1719 + 61))) then
						if (((478 + 68) <= (394 + 683)) and v98.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v99.RefreshingHealingPotion) or ((552 + 444) > (757 + 3544))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v118()
		local v130 = 0 - 0;
		while true do
			if (((5981 - (340 + 1571)) > (271 + 416)) and (v130 == (1773 - (1733 + 39)))) then
				if (v13 or ((1802 - 1146) >= (4364 - (125 + 909)))) then
					if ((v97.WordofGlory:IsReady() and v61 and v14:BuffUp(v97.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v72)) or ((4440 - (1096 + 852)) <= (151 + 184))) then
						if (((6171 - 1849) >= (2485 + 77)) and v24(v99.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v97.LayonHands:IsCastable() and v60 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v71)) or ((4149 - (409 + 103)) >= (4006 - (46 + 190)))) then
						if (v24(v99.LayonHandsFocus) or ((2474 - (51 + 44)) > (1292 + 3286))) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v97.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) or ((1800 - (1114 + 203)) > (1469 - (228 + 498)))) then
						if (((532 + 1922) > (320 + 258)) and v24(v99.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((1593 - (174 + 489)) < (11614 - 7156)) and v97.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) then
						if (((2567 - (830 + 1075)) <= (1496 - (303 + 221))) and v24(v99.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((5639 - (231 + 1038)) == (3642 + 728)) and (v130 == (1162 - (171 + 991)))) then
				if (v15:Exists() or ((19625 - 14863) <= (2311 - 1450))) then
					if ((v97.WordofGlory:IsReady() and v62 and (v15:HealthPercentage() <= v73)) or ((3523 - 2111) == (3413 + 851))) then
						if (v24(v99.WordofGloryMouseover) or ((11104 - 7936) < (6210 - 4057))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(48 - 18) or ((15382 - 10406) < (2580 - (111 + 1137)))) then
					return;
				end
				v130 = 159 - (91 + 67);
			end
		end
	end
	local function v119()
		local v131 = 0 - 0;
		while true do
			if (((1155 + 3473) == (5151 - (423 + 100))) and ((0 + 0) == v131)) then
				if (((v85 < v109) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89)) or ((149 - 95) == (206 + 189))) then
					if (((853 - (326 + 445)) == (357 - 275)) and v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v85 < v109) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (10 - 5))) or ((1355 - 774) < (993 - (530 + 181)))) then
					if (v24(v97.ArcaneTorrent, not v16:IsInRange(889 - (614 + 267))) or ((4641 - (19 + 13)) < (4060 - 1565))) then
						return "arcane_torrent precombat 6";
					end
				end
				v131 = 2 - 1;
			end
			if (((3290 - 2138) == (300 + 852)) and (v131 == (1 - 0))) then
				if (((3931 - 2035) <= (5234 - (1293 + 519))) and v97.Consecration:IsCastable() and v35) then
					if (v24(v97.Consecration, not v16:IsInRange(16 - 8)) or ((2584 - 1594) > (3097 - 1477))) then
						return "consecration";
					end
				end
				if ((v97.AvengersShield:IsCastable() and v33) or ((3781 - 2904) > (11060 - 6365))) then
					if (((1426 + 1265) >= (378 + 1473)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v131 = 4 - 2;
			end
			if (((1 + 1) == v131) or ((992 + 1993) >= (3035 + 1821))) then
				if (((5372 - (709 + 387)) >= (3053 - (673 + 1185))) and v97.Judgment:IsReady() and v39) then
					if (((9372 - 6140) <= (15060 - 10370)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v120()
		if ((v97.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (2 - 0)) and v14:HasTier(21 + 8, 2 + 0)) or ((1208 - 312) >= (773 + 2373))) then
			if (((6103 - 3042) >= (5806 - 2848)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((5067 - (446 + 1434)) >= (1927 - (1040 + 243))) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89) and (v106 >= (5 - 3))) then
			if (((2491 - (559 + 1288)) <= (2635 - (609 + 1322))) and v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((1412 - (13 + 441)) > (3538 - 2591)) and v97.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) then
			if (((11766 - 7274) >= (13218 - 10564)) and v24(v97.AvengingWrath, not v16:IsInRange(1 + 7))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((12500 - 9058) >= (534 + 969)) and v97.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) then
			if (v24(v97.Sentinel, not v16:IsInRange(4 + 4)) or ((9407 - 6237) <= (802 + 662))) then
				return "sentinel cooldowns 8";
			end
		end
		local v132 = v107.HandleDPSPotion(v14:BuffUp(v97.AvengingWrathBuff));
		if (v132 or ((8822 - 4025) == (2901 + 1487))) then
			return v132;
		end
		if (((307 + 244) <= (490 + 191)) and v97.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v97.SentinelBuff) < (13 + 2)) or (((v9.CombatTime() > (10 + 0)) or (v97.Sentinel:CooldownRemains() > (448 - (153 + 280))) or (v97.AvengingWrath:CooldownRemains() > (43 - 28))) and (v97.AvengersShield:CooldownRemains() > (0 + 0)) and (v97.Judgment:CooldownRemains() > (0 + 0)) and (v97.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (((2974 + 303) > (295 + 112)) and v24(v97.MomentofGlory, not v16:IsInRange(11 - 3))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((2902 + 1793) >= (2082 - (89 + 578))) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady() and (v105 >= (3 + 0))) then
			if (v24(v97.DivineToll, not v16:IsInRange(62 - 32)) or ((4261 - (572 + 477)) <= (128 + 816))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v97.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v97.AvengingWrathBuff) or (v97.AvengingWrath:CooldownRemains() <= (19 + 11)))) or ((370 + 2726) <= (1884 - (84 + 2)))) then
			if (((5828 - 2291) == (2549 + 988)) and v24(v97.BastionofLight, not v16:IsInRange(850 - (497 + 345)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v121()
		if (((99 + 3738) >= (266 + 1304)) and v97.Consecration:IsCastable() and v35 and (v14:BuffStack(v97.SanctificationBuff) == (1338 - (605 + 728)))) then
			if (v24(v97.Consecration, not v16:IsInRange(6 + 2)) or ((6558 - 3608) == (175 + 3637))) then
				return "consecration standard 2";
			end
		end
		if (((17461 - 12738) >= (2090 + 228)) and v97.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (5 - 3)) or v14:BuffUp(v97.BastionofLightBuff) or v14:BuffUp(v97.DivinePurposeBuff)) and (v14:BuffDown(v97.SanctificationBuff) or (v14:BuffStack(v97.SanctificationBuff) < (4 + 1)))) then
			if (v24(v97.ShieldoftheRighteous) or ((2516 - (457 + 32)) > (1211 + 1641))) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if ((v97.Judgment:IsReady() and v39 and (v105 > (1405 - (832 + 570))) and (v14:BuffStack(v97.BulwarkofRighteousFuryBuff) >= (3 + 0)) and (v14:HolyPower() < (1 + 2))) or ((4019 - 2883) > (2080 + 2237))) then
			if (((5544 - (588 + 208)) == (12796 - 8048)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 6";
			end
			if (((5536 - (884 + 916)) <= (9923 - 5183)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 6";
			end
		end
		if ((v97.Judgment:IsReady() and v39 and v14:BuffDown(v97.SanctificationEmpowerBuff) and v14:HasTier(18 + 13, 655 - (232 + 421))) or ((5279 - (1569 + 320)) <= (751 + 2309))) then
			if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((190 + 809) > (9074 - 6381))) then
				return "judgment standard 8";
			end
			if (((1068 - (316 + 289)) < (1573 - 972)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 8";
			end
		end
		if ((v97.HammerofWrath:IsReady() and v38) or ((101 + 2082) < (2140 - (666 + 787)))) then
			if (((4974 - (360 + 65)) == (4252 + 297)) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((4926 - (79 + 175)) == (7366 - 2694)) and v97.Judgment:IsReady() and v39 and ((v97.Judgment:Charges() >= (2 + 0)) or (v97.Judgment:FullRechargeTime() <= v14:GCD()))) then
			local v158 = 0 - 0;
			while true do
				if ((v158 == (0 - 0)) or ((4567 - (503 + 396)) < (576 - (92 + 89)))) then
					if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((8081 - 3915) == (234 + 221))) then
						return "judgment standard 12";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2634 + 1815) == (10428 - 7765))) then
						return "judgment standard 12";
					end
					break;
				end
			end
		end
		if ((v97.AvengersShield:IsCastable() and v33 and ((v106 > (1 + 1)) or v14:BuffUp(v97.MomentofGloryBuff))) or ((9751 - 5474) < (2608 + 381))) then
			if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((416 + 454) >= (12636 - 8487))) then
				return "avengers_shield standard 14";
			end
		end
		if (((277 + 1935) < (4853 - 1670)) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady()) then
			if (((5890 - (485 + 759)) > (6922 - 3930)) and v24(v97.DivineToll, not v16:IsInRange(1219 - (442 + 747)))) then
				return "divine_toll standard 16";
			end
		end
		if (((2569 - (832 + 303)) < (4052 - (88 + 858))) and v97.AvengersShield:IsCastable() and v33) then
			if (((240 + 546) < (2502 + 521)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if ((v97.HammerofWrath:IsReady() and v38) or ((101 + 2341) < (863 - (766 + 23)))) then
			if (((22388 - 17853) == (6201 - 1666)) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if ((v97.Judgment:IsReady() and v39) or ((7927 - 4918) <= (7144 - 5039))) then
			local v159 = 1073 - (1036 + 37);
			while true do
				if (((1298 + 532) < (7144 - 3475)) and (v159 == (0 + 0))) then
					if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((2910 - (641 + 839)) >= (4525 - (910 + 3)))) then
						return "judgment standard 22";
					end
					if (((6839 - 4156) >= (4144 - (1466 + 218))) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment standard 22";
					end
					break;
				end
			end
		end
		if ((v97.Consecration:IsCastable() and v35 and v14:BuffDown(v97.ConsecrationBuff) and ((v14:BuffStack(v97.SanctificationBuff) < (3 + 2)) or not v14:HasTier(1179 - (556 + 592), 1 + 1))) or ((2612 - (329 + 479)) >= (4129 - (174 + 680)))) then
			if (v24(v97.Consecration, not v16:IsInRange(27 - 19)) or ((2936 - 1519) > (2591 + 1038))) then
				return "consecration standard 24";
			end
		end
		if (((5534 - (396 + 343)) > (36 + 366)) and (v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and v97.InmostLight:IsAvailable() and (v105 >= (1480 - (29 + 1448)))) then
			if (((6202 - (135 + 1254)) > (13430 - 9865)) and v24(v97.EyeofTyr, not v16:IsInRange(37 - 29))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((2608 + 1304) == (5439 - (389 + 1138))) and v97.BlessedHammer:IsCastable() and v34) then
			if (((3395 - (102 + 472)) <= (4553 + 271)) and v24(v97.BlessedHammer, not v16:IsInRange(5 + 3))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((1621 + 117) <= (3740 - (320 + 1225))) and v97.HammeroftheRighteous:IsCastable() and v37) then
			if (((72 - 31) <= (1847 + 1171)) and v24(v97.HammeroftheRighteous, not v16:IsInRange(1472 - (157 + 1307)))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((4004 - (821 + 1038)) <= (10239 - 6135)) and v97.CrusaderStrike:IsCastable() and v36) then
			if (((295 + 2394) < (8605 - 3760)) and v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and not v97.InmostLight:IsAvailable()) or ((864 + 1458) > (6498 - 3876))) then
			if (v24(v97.EyeofTyr, not v16:IsInRange(1034 - (834 + 192))) or ((289 + 4245) == (535 + 1547))) then
				return "eye_of_tyr standard 34";
			end
		end
		if ((v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (1 + 4))) or ((2433 - 862) > (2171 - (300 + 4)))) then
			if (v24(v97.ArcaneTorrent, not v16:IsInRange(3 + 5)) or ((6947 - 4293) >= (3358 - (112 + 250)))) then
				return "arcane_torrent standard 36";
			end
		end
		if (((1586 + 2392) > (5270 - 3166)) and v97.Consecration:IsCastable() and v35 and (v14:BuffDown(v97.SanctificationEmpowerBuff))) then
			if (((1716 + 1279) > (797 + 744)) and v24(v97.Consecration, not v16:IsInRange(6 + 2))) then
				return "consecration standard 38";
			end
		end
	end
	local function v122()
		v33 = EpicSettings.Settings['useAvengersShield'];
		v34 = EpicSettings.Settings['useBlessedHammer'];
		v35 = EpicSettings.Settings['useConsecration'];
		v36 = EpicSettings.Settings['useCrusaderStrike'];
		v37 = EpicSettings.Settings['useHammeroftheRighteous'];
		v38 = EpicSettings.Settings['useHammerofWrath'];
		v39 = EpicSettings.Settings['useJudgment'];
		v40 = EpicSettings.Settings['useAvengingWrath'];
		v41 = EpicSettings.Settings['useBastionofLight'];
		v42 = EpicSettings.Settings['useDivineToll'];
		v43 = EpicSettings.Settings['useEyeofTyr'];
		v44 = EpicSettings.Settings['useMomentOfGlory'];
		v45 = EpicSettings.Settings['useSentinel'];
		v46 = EpicSettings.Settings['avengingWrathWithCD'];
		v47 = EpicSettings.Settings['bastionofLightWithCD'];
		v48 = EpicSettings.Settings['divineTollWithCD'];
		v49 = EpicSettings.Settings['eyeofTyrWithCD'];
		v50 = EpicSettings.Settings['momentofGloryWithCD'];
		v51 = EpicSettings.Settings['sentinelWithCD'];
	end
	local function v123()
		local v152 = 0 + 0;
		while true do
			if (((2414 + 835) > (2367 - (1001 + 413))) and ((4 - 2) == v152)) then
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useWordofGloryMouseover'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v152 = 885 - (244 + 638);
			end
			if ((v152 == (694 - (627 + 66))) or ((9752 - 6479) > (5175 - (512 + 90)))) then
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v152 = 1908 - (1665 + 241);
			end
			if ((v152 == (717 - (373 + 344))) or ((1422 + 1729) < (340 + 944))) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v55 = EpicSettings.Settings['useDivineShield'];
				v152 = 2 - 1;
			end
			if ((v152 == (8 - 3)) or ((2949 - (35 + 1064)) == (1113 + 416))) then
				v72 = EpicSettings.Settings['wordofGloryFocusHP'];
				v73 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v74 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v152 = 12 - 6;
			end
			if (((4 + 817) < (3359 - (298 + 938))) and (v152 == (1262 - (233 + 1026)))) then
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v65 = EpicSettings.Settings['ardentDefenderHP'];
				v66 = EpicSettings.Settings['divineShieldHP'];
				v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v152 = 1670 - (636 + 1030);
			end
			if (((462 + 440) < (2271 + 54)) and ((2 + 2) == v152)) then
				v68 = EpicSettings.Settings['layonHandsHP'];
				v69 = EpicSettings.Settings['wordofGloryHP'];
				v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v71 = EpicSettings.Settings['layOnHandsFocusHP'];
				v152 = 1 + 4;
			end
			if (((1079 - (55 + 166)) <= (575 + 2387)) and (v152 == (1 + 5))) then
				v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
		end
	end
	local function v124()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (300 - (36 + 261))) or ((6900 - 2954) < (2656 - (34 + 1334)))) then
				v89 = EpicSettings.Settings['racialsWithCD'];
				v91 = EpicSettings.Settings['useHealthstone'];
				v90 = EpicSettings.Settings['useHealingPotion'];
				v153 = 2 + 2;
			end
			if ((v153 == (0 + 0)) or ((4525 - (1035 + 248)) == (588 - (20 + 1)))) then
				v85 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v82 = EpicSettings.Settings['InterruptWithStun'];
				v83 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v153 = 320 - (134 + 185);
			end
			if ((v153 == (1139 - (549 + 584))) or ((1532 - (314 + 371)) >= (4335 - 3072))) then
				v96 = EpicSettings.Settings['HealOOCHP'] or (968 - (478 + 490));
				break;
			end
			if ((v153 == (3 + 1)) or ((3425 - (786 + 386)) == (5995 - 4144))) then
				v93 = EpicSettings.Settings['healthstoneHP'] or (1379 - (1055 + 324));
				v92 = EpicSettings.Settings['healingPotionHP'] or (1340 - (1093 + 247));
				v94 = EpicSettings.Settings['HealingPotionName'] or "";
				v153 = 5 + 0;
			end
			if ((v153 == (1 + 0)) or ((8285 - 6198) > (8049 - 5677))) then
				v84 = EpicSettings.Settings['InterruptThreshold'];
				v79 = EpicSettings.Settings['DispelDebuffs'];
				v78 = EpicSettings.Settings['DispelBuffs'];
				v153 = 5 - 3;
			end
			if ((v153 == (4 - 2)) or ((1582 + 2863) < (15983 - 11834))) then
				v86 = EpicSettings.Settings['useTrinkets'];
				v88 = EpicSettings.Settings['useRacials'];
				v87 = EpicSettings.Settings['trinketsWithCD'];
				v153 = 10 - 7;
			end
			if ((v153 == (4 + 1)) or ((4648 - 2830) == (773 - (364 + 324)))) then
				v80 = EpicSettings.Settings['handleAfflicted'];
				v81 = EpicSettings.Settings['HandleIncorporeal'];
				v95 = EpicSettings.Settings['HealOOC'];
				v153 = 16 - 10;
			end
		end
	end
	local function v125()
		local v154 = 0 - 0;
		while true do
			if (((209 + 421) < (8900 - 6773)) and (v154 == (13 - 4))) then
				if ((v107.TargetIsValid() and not v14:AffectingCombat() and v29) or ((5885 - 3947) == (3782 - (1249 + 19)))) then
					local v204 = 0 + 0;
					while true do
						if (((16562 - 12307) >= (1141 - (686 + 400))) and ((0 + 0) == v204)) then
							v28 = v119();
							if (((3228 - (73 + 156)) > (6 + 1150)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((3161 - (721 + 90)) > (13 + 1142)) and v107.TargetIsValid()) then
					if (((13081 - 9052) <= (5323 - (224 + 246))) and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
						if (v14:AffectingCombat() or ((835 - 319) > (6322 - 2888))) then
							if (((734 + 3312) >= (73 + 2960)) and v97.Intercession:IsCastable()) then
								if (v24(v97.Intercession, not v16:IsInRange(23 + 7), true) or ((5405 - 2686) <= (4815 - 3368))) then
									return "intercession";
								end
							end
						elseif (v97.Redemption:IsCastable() or ((4647 - (203 + 310)) < (5919 - (1238 + 755)))) then
							if (v24(v97.Redemption, not v16:IsInRange(3 + 27), true) or ((1698 - (709 + 825)) >= (5131 - 2346))) then
								return "redemption";
							end
						end
					end
					if ((v107.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((764 - 239) == (2973 - (196 + 668)))) then
						if (((130 - 97) == (68 - 35)) and v102) then
							local v208 = 833 - (171 + 662);
							while true do
								if (((3147 - (4 + 89)) <= (14072 - 10057)) and (v208 == (0 + 0))) then
									v28 = v117();
									if (((8217 - 6346) < (1327 + 2055)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if (((2779 - (35 + 1451)) <= (3619 - (28 + 1425))) and (v85 < v109)) then
							local v209 = 1993 - (941 + 1052);
							while true do
								if ((v209 == (0 + 0)) or ((4093 - (822 + 692)) < (174 - 51))) then
									v28 = v120();
									if (v28 or ((399 + 447) >= (2665 - (45 + 252)))) then
										return v28;
									end
									break;
								end
							end
						end
						if ((v86 and ((v31 and v87) or not v87) and v16:IsInRange(8 + 0)) or ((1381 + 2631) <= (8172 - 4814))) then
							v28 = v116();
							if (((1927 - (114 + 319)) <= (4314 - 1309)) and v28) then
								return v28;
							end
						end
						v28 = v121();
						if (v28 or ((3986 - 875) == (1361 + 773))) then
							return v28;
						end
						if (((3508 - 1153) == (4934 - 2579)) and v24(v97.Pool)) then
							return "Wait/Pool Resources";
						end
					end
				end
				break;
			end
			if ((v154 == (1970 - (556 + 1407))) or ((1794 - (741 + 465)) <= (897 - (170 + 295)))) then
				if (((2528 + 2269) >= (3578 + 317)) and v28) then
					return v28;
				end
				if (((8806 - 5229) == (2966 + 611)) and v13) then
					if (((2434 + 1360) > (2092 + 1601)) and v79) then
						v28 = v114();
						if (v28 or ((2505 - (957 + 273)) == (1097 + 3003))) then
							return v28;
						end
					end
				end
				v28 = v118();
				v154 = 4 + 4;
			end
			if ((v154 == (11 - 8)) or ((4192 - 2601) >= (10935 - 7355))) then
				v104 = v14:GetEnemiesInRange(148 - 118);
				if (((2763 - (389 + 1391)) <= (1135 + 673)) and v30) then
					v105 = #v103;
					v106 = #v104;
				else
					v105 = 1 + 0;
					v106 = 2 - 1;
				end
				v101 = v14:ActiveMitigationNeeded();
				v154 = 955 - (783 + 168);
			end
			if ((v154 == (6 - 4)) or ((2115 + 35) <= (1508 - (309 + 2)))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (((11574 - 7805) >= (2385 - (1090 + 122))) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v103 = v14:GetEnemiesInMeleeRange(3 + 5);
				v154 = 9 - 6;
			end
			if (((1017 + 468) == (2603 - (628 + 490))) and (v154 == (1 + 4))) then
				if (v32 or ((8207 - 4892) <= (12713 - 9931))) then
					v28 = v107.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 814 - (431 + 343), 50 - 25);
					if (v28 or ((2534 - 1658) >= (2342 + 622))) then
						return v28;
					end
					if ((v97.BlessingofFreedom:IsReady() and v107.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((286 + 1946) > (4192 - (556 + 1139)))) then
						if (v24(v99.BlessingofFreedomFocus) or ((2125 - (6 + 9)) <= (61 + 271))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((1889 + 1797) > (3341 - (28 + 141))) and (v107.TargetIsValid() or v14:AffectingCombat())) then
					v108 = v9.BossFightRemains(nil, true);
					v109 = v108;
					if ((v109 == (4304 + 6807)) or ((5521 - 1047) < (581 + 239))) then
						v109 = v9.FightRemains(v103, false);
					end
					v110 = v14:HolyPower();
				end
				if (((5596 - (486 + 831)) >= (7499 - 4617)) and not v14:AffectingCombat()) then
					if ((v97.DevotionAura:IsCastable() and (v113())) or ((7143 - 5114) >= (666 + 2855))) then
						if (v24(v97.DevotionAura) or ((6440 - 4403) >= (5905 - (668 + 595)))) then
							return "devotion_aura";
						end
					end
				end
				v154 = 6 + 0;
			end
			if (((347 + 1373) < (12157 - 7699)) and (v154 == (298 - (23 + 267)))) then
				if (v28 or ((2380 - (1129 + 815)) > (3408 - (371 + 16)))) then
					return v28;
				end
				if (((2463 - (1326 + 424)) <= (1604 - 757)) and v97.Redemption:IsCastable() and v97.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((7871 - 5717) <= (4149 - (88 + 30))) and v24(v99.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((5386 - (720 + 51)) == (10266 - 5651)) and v14:AffectingCombat()) then
					if ((v97.Intercession:IsCastable() and (v14:HolyPower() >= (1779 - (421 + 1355))) and v97.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((6252 - 2462) == (246 + 254))) then
						if (((1172 - (286 + 797)) < (807 - 586)) and v24(v99.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				v154 = 14 - 5;
			end
			if (((2493 - (397 + 42)) >= (444 + 977)) and ((800 - (24 + 776)) == v154)) then
				v123();
				v122();
				v124();
				v154 = 1 - 0;
			end
			if (((1477 - (222 + 563)) < (6737 - 3679)) and (v154 == (1 + 0))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v154 = 192 - (23 + 167);
			end
			if ((v154 == (1804 - (690 + 1108))) or ((1175 + 2079) == (1366 + 289))) then
				if (v80 or ((2144 - (40 + 808)) == (809 + 4101))) then
					local v205 = 0 - 0;
					while true do
						if (((3220 + 148) == (1782 + 1586)) and (v205 == (0 + 0))) then
							if (((3214 - (47 + 524)) < (2476 + 1339)) and v76) then
								v28 = v107.HandleAfflicted(v97.CleanseToxins, v99.CleanseToxinsMouseover, 109 - 69);
								if (((2860 - 947) > (1123 - 630)) and v28) then
									return v28;
								end
							end
							if (((6481 - (1165 + 561)) > (102 + 3326)) and v14:BuffUp(v97.ShiningLightFreeBuff) and v77) then
								local v210 = 0 - 0;
								while true do
									if (((527 + 854) <= (2848 - (341 + 138))) and ((0 + 0) == v210)) then
										v28 = v107.HandleAfflicted(v97.WordofGlory, v99.WordofGloryMouseover, 82 - 42, true);
										if (v28 or ((5169 - (89 + 237)) == (13138 - 9054))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((9829 - 5160) > (1244 - (581 + 300))) and v81) then
					v28 = v107.HandleIncorporeal(v97.Repentance, v99.RepentanceMouseOver, 1250 - (855 + 365), true);
					if (v28 or ((4458 - 2581) >= (1025 + 2113))) then
						return v28;
					end
					v28 = v107.HandleIncorporeal(v97.TurnEvil, v99.TurnEvilMouseOver, 1265 - (1030 + 205), true);
					if (((4452 + 290) >= (3374 + 252)) and v28) then
						return v28;
					end
				end
				v28 = v115();
				v154 = 293 - (156 + 130);
			end
			if ((v154 == (8 - 4)) or ((7651 - 3111) == (1875 - 959))) then
				v102 = v14:IsTankingAoE(3 + 5) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((675 + 481) > (4414 - (10 + 59)))) then
					if (((633 + 1604) < (20925 - 16676)) and v97.CrusaderAura:IsCastable() and (v14:BuffDown(v97.CrusaderAura))) then
						if (v24(v97.CrusaderAura) or ((3846 - (671 + 492)) < (19 + 4))) then
							return "crusader_aura";
						end
					end
				end
				if (((1912 - (369 + 846)) <= (219 + 607)) and (v14:AffectingCombat() or v79)) then
					local v206 = 0 + 0;
					local v207;
					while true do
						if (((3050 - (1036 + 909)) <= (936 + 240)) and ((1 - 0) == v206)) then
							if (((3582 - (11 + 192)) <= (1927 + 1885)) and v28) then
								return v28;
							end
							break;
						end
						if ((v206 == (175 - (135 + 40))) or ((1909 - 1121) >= (975 + 641))) then
							v207 = v79 and v97.CleanseToxins:IsReady() and v32;
							v28 = v107.FocusUnit(v207, v99, 44 - 24, nil, 37 - 12);
							v206 = 177 - (50 + 126);
						end
					end
				end
				v154 = 13 - 8;
			end
		end
	end
	local function v126()
		local v155 = 0 + 0;
		while true do
			if (((3267 - (1233 + 180)) <= (4348 - (522 + 447))) and (v155 == (1421 - (107 + 1314)))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v111();
				break;
			end
		end
	end
	v20.SetAPL(31 + 35, v125, v126);
end;
return v0["Epix_Paladin_Protection.lua"]();

