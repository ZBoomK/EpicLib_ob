local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2719 + 1657) <= (2648 - (645 + 522)))) then
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
	local v108 = 12901 - (1010 + 780);
	local v109 = 11106 + 5;
	local v110 = 0 - 0;
	v9:RegisterForEvent(function()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (1836 - (1045 + 791))) or ((8585 - 5193) >= (7238 - 2497))) then
				v108 = 11616 - (351 + 154);
				v109 = 12685 - (1281 + 293);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (((3591 - (28 + 238)) >= (4812 - 2658)) and v97.CleanseToxins:IsAvailable()) then
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
		if ((v97.CleanseToxins:IsReady() and v107.DispellableFriendlyUnit(1584 - (1381 + 178))) or ((1215 + 80) >= (2607 + 626))) then
			if (((1868 + 2509) > (5660 - 4018)) and v24(v99.CleanseToxinsFocus)) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v115()
		if (((2447 + 2276) > (1826 - (381 + 89))) and v95 and (v14:HealthPercentage() <= v96)) then
			if (v97.FlashofLight:IsReady() or ((3668 + 468) <= (2322 + 1111))) then
				if (((7271 - 3026) <= (5787 - (1074 + 82))) and v24(v97.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v116()
		local v129 = 0 - 0;
		while true do
			if (((6060 - (214 + 1570)) >= (5369 - (990 + 465))) and (v129 == (1 + 0))) then
				v28 = v107.HandleBottomTrinket(v100, v31, 18 + 22, nil);
				if (((193 + 5) <= (17178 - 12813)) and v28) then
					return v28;
				end
				break;
			end
			if (((6508 - (1668 + 58)) > (5302 - (512 + 114))) and (v129 == (0 - 0))) then
				v28 = v107.HandleTopTrinket(v100, v31, 82 - 42, nil);
				if (((16924 - 12060) > (1023 + 1174)) and v28) then
					return v28;
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v117()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (10 - 7)) or ((5694 - (109 + 1885)) == (3976 - (1269 + 200)))) then
				if (((8574 - 4100) >= (1089 - (98 + 717))) and v98.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) then
					if (v24(v99.Healthstone) or ((2720 - (802 + 24)) <= (2424 - 1018))) then
						return "healthstone defensive";
					end
				end
				if (((1984 - 412) >= (227 + 1304)) and v90 and (v14:HealthPercentage() <= v92)) then
					if ((v94 == "Refreshing Healing Potion") or ((3602 + 1085) < (747 + 3795))) then
						if (((710 + 2581) > (4637 - 2970)) and v98.RefreshingHealingPotion:IsReady()) then
							if (v24(v99.RefreshingHealingPotion) or ((2911 - 2038) == (728 + 1306))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v94 == "Dreamwalker's Healing Potion") or ((1147 + 1669) < (10 + 1))) then
						if (((2690 + 1009) < (2198 + 2508)) and v98.DreamwalkersHealingPotion:IsReady()) then
							if (((4079 - (797 + 636)) >= (4253 - 3377)) and v24(v99.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((2233 - (1427 + 192)) <= (1104 + 2080)) and (v130 == (0 - 0))) then
				if (((2810 + 316) == (1417 + 1709)) and (v14:HealthPercentage() <= v66) and v55 and v97.DivineShield:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) then
					if (v24(v97.DivineShield) or ((2513 - (192 + 134)) >= (6230 - (316 + 960)))) then
						return "divine_shield defensive";
					end
				end
				if (((v14:HealthPercentage() <= v68) and v57 and v97.LayonHands:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((2158 + 1719) == (2759 + 816))) then
					if (((654 + 53) > (2415 - 1783)) and v24(v99.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v130 = 552 - (83 + 468);
			end
			if ((v130 == (1808 - (1202 + 604))) or ((2548 - 2002) >= (4466 - 1782))) then
				if (((4056 - 2591) <= (4626 - (45 + 280))) and v97.WordofGlory:IsReady() and (v14:HealthPercentage() <= v69) and v58 and not v14:HealingAbsorbed()) then
					if (((1645 + 59) > (1245 + 180)) and ((v14:BuffRemains(v97.ShieldoftheRighteousBuff) >= (2 + 3)) or v14:BuffUp(v97.DivinePurposeBuff) or v14:BuffUp(v97.ShiningLightFreeBuff))) then
						if (v24(v99.WordofGloryPlayer) or ((381 + 306) == (745 + 3489))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v97.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (3 - 1)) and v14:BuffRefreshable(v97.ShieldoftheRighteousBuff) and v59 and (v101 or (v14:HealthPercentage() <= v70))) or ((5241 - (340 + 1571)) < (564 + 865))) then
					if (((2919 - (1733 + 39)) >= (920 - 585)) and v24(v97.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v130 = 1037 - (125 + 909);
			end
			if (((5383 - (1096 + 852)) > (941 + 1156)) and (v130 == (1 - 0))) then
				if ((v97.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v97.ArdentDefenderBuff)) or ((3657 + 113) >= (4553 - (409 + 103)))) then
					if (v24(v97.GuardianofAncientKings) or ((4027 - (46 + 190)) <= (1706 - (51 + 44)))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v97.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v65) and v54 and v14:BuffDown(v97.GuardianofAncientKingsBuff)) or ((1292 + 3286) <= (3325 - (1114 + 203)))) then
					if (((1851 - (228 + 498)) <= (450 + 1626)) and v24(v97.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v130 = 2 + 0;
			end
		end
	end
	local function v118()
		local v131 = 663 - (174 + 489);
		while true do
			if ((v131 == (0 - 0)) or ((2648 - (830 + 1075)) >= (4923 - (303 + 221)))) then
				if (((2424 - (231 + 1038)) < (1395 + 278)) and v15:Exists()) then
					if ((v97.WordofGlory:IsReady() and v62 and (v15:HealthPercentage() <= v73)) or ((3486 - (171 + 991)) <= (2381 - 1803))) then
						if (((10114 - 6347) == (9400 - 5633)) and v24(v99.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((3273 + 816) == (14333 - 10244)) and (not v13 or not v13:Exists() or not v13:IsInRange(86 - 56))) then
					return;
				end
				v131 = 1 - 0;
			end
			if (((13780 - 9322) >= (2922 - (111 + 1137))) and (v131 == (159 - (91 + 67)))) then
				if (((2892 - 1920) <= (354 + 1064)) and v13) then
					if ((v97.WordofGlory:IsReady() and v61 and v14:BuffUp(v97.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v72)) or ((5461 - (423 + 100)) < (34 + 4728))) then
						if (v24(v99.WordofGloryFocus) or ((6933 - 4429) > (2223 + 2041))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((2924 - (326 + 445)) == (9395 - 7242)) and v97.LayonHands:IsCastable() and v60 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v71)) then
						if (v24(v99.LayonHandsFocus) or ((1129 - 622) >= (6047 - 3456))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((5192 - (530 + 181)) == (5362 - (614 + 267))) and v97.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) then
						if (v24(v99.BlessingofSacrificeFocus) or ((2360 - (19 + 13)) < (1127 - 434))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((10085 - 5757) == (12363 - 8035)) and v97.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) then
						if (((413 + 1175) >= (2342 - 1010)) and v24(v99.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (1814 - (1293 + 519))) or ((8515 - 4341) > (11090 - 6842))) then
				if ((v97.Judgment:IsReady() and v39) or ((8769 - 4183) <= (353 - 271))) then
					if (((9099 - 5236) == (2047 + 1816)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v132 == (0 + 0)) or ((654 - 372) <= (10 + 32))) then
				if (((1532 + 3077) >= (479 + 287)) and (v85 < v109) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89)) then
					if (v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment)) or ((2248 - (709 + 387)) == (4346 - (673 + 1185)))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((9923 - 6501) > (10757 - 7407)) and (v85 < v109) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (8 - 3))) then
					if (((628 + 249) > (281 + 95)) and v24(v97.ArcaneTorrent, not v16:IsInRange(10 - 2))) then
						return "arcane_torrent precombat 6";
					end
				end
				v132 = 1 + 0;
			end
			if (((1 - 0) == v132) or ((6120 - 3002) <= (3731 - (446 + 1434)))) then
				if ((v97.Consecration:IsCastable() and v35) or ((1448 - (1040 + 243)) >= (10422 - 6930))) then
					if (((5796 - (559 + 1288)) < (6787 - (609 + 1322))) and v24(v97.Consecration, not v16:IsInRange(462 - (13 + 441)))) then
						return "consecration";
					end
				end
				if ((v97.AvengersShield:IsCastable() and v33) or ((15978 - 11702) < (7899 - 4883))) then
					if (((23358 - 18668) > (154 + 3971)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v132 = 7 - 5;
			end
		end
	end
	local function v120()
		if ((v97.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (1 + 1)) and v14:HasTier(13 + 16, 5 - 3)) or ((28 + 22) >= (1647 - 751))) then
			if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((1134 + 580) >= (1646 + 1312))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if ((v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89) and (v106 >= (2 + 0))) or ((1252 + 239) < (631 + 13))) then
			if (((1137 - (153 + 280)) < (2849 - 1862)) and v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((3339 + 379) > (753 + 1153)) and v97.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) then
			if (v24(v97.AvengingWrath, not v16:IsInRange(5 + 3)) or ((870 + 88) > (2634 + 1001))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((5330 - 1829) <= (2777 + 1715)) and v97.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) then
			if (v24(v97.Sentinel, not v16:IsInRange(675 - (89 + 578))) or ((2459 + 983) < (5296 - 2748))) then
				return "sentinel cooldowns 8";
			end
		end
		local v133 = v107.HandleDPSPotion(v14:BuffUp(v97.AvengingWrathBuff));
		if (((3924 - (572 + 477)) >= (198 + 1266)) and v133) then
			return v133;
		end
		if ((v97.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v97.SentinelBuff) < (10 + 5)) or (((v9.CombatTime() > (2 + 8)) or (v97.Sentinel:CooldownRemains() > (101 - (84 + 2))) or (v97.AvengingWrath:CooldownRemains() > (24 - 9))) and (v97.AvengersShield:CooldownRemains() > (0 + 0)) and (v97.Judgment:CooldownRemains() > (842 - (497 + 345))) and (v97.HammerofWrath:CooldownRemains() > (0 + 0))))) or ((811 + 3986) >= (6226 - (605 + 728)))) then
			if (v24(v97.MomentofGlory, not v16:IsInRange(6 + 2)) or ((1224 - 673) > (95 + 1973))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((7815 - 5701) > (852 + 92)) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady() and (v105 >= (7 - 4))) then
			if (v24(v97.DivineToll, not v16:IsInRange(23 + 7)) or ((2751 - (457 + 32)) >= (1314 + 1782))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v97.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v97.AvengingWrathBuff) or (v97.AvengingWrath:CooldownRemains() <= (1432 - (832 + 570))))) or ((2125 + 130) >= (923 + 2614))) then
			if (v24(v97.BastionofLight, not v16:IsInRange(28 - 20)) or ((1849 + 1988) < (2102 - (588 + 208)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v121()
		local v134 = 0 - 0;
		while true do
			if (((4750 - (884 + 916)) == (6176 - 3226)) and ((1 + 0) == v134)) then
				if ((v97.HammerofWrath:IsReady() and v38) or ((5376 - (232 + 421)) < (5187 - (1569 + 320)))) then
					if (((279 + 857) >= (30 + 124)) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v97.Judgment:IsReady() and v39 and ((v97.Judgment:Charges() >= (6 - 4)) or (v97.Judgment:FullRechargeTime() <= v14:GCD()))) or ((876 - (316 + 289)) > (12428 - 7680))) then
					local v203 = 0 + 0;
					while true do
						if (((6193 - (666 + 787)) >= (3577 - (360 + 65))) and (v203 == (0 + 0))) then
							if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((2832 - (79 + 175)) >= (5345 - 1955))) then
								return "judgment standard 12";
							end
							if (((32 + 9) <= (5091 - 3430)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				if (((1157 - 556) < (4459 - (503 + 396))) and v97.AvengersShield:IsCastable() and v33 and ((v106 > (183 - (92 + 89))) or v14:BuffUp(v97.MomentofGloryBuff))) then
					if (((455 - 220) < (353 + 334)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((2693 + 1856) > (4515 - 3362)) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady()) then
					if (v24(v97.DivineToll, not v16:IsInRange(5 + 25)) or ((10656 - 5982) < (4077 + 595))) then
						return "divine_toll standard 16";
					end
				end
				v134 = 1 + 1;
			end
			if (((11171 - 7503) < (570 + 3991)) and (v134 == (2 - 0))) then
				if ((v97.AvengersShield:IsCastable() and v33) or ((1699 - (485 + 759)) == (8341 - 4736))) then
					if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((3852 - (442 + 747)) == (4447 - (832 + 303)))) then
						return "avengers_shield standard 18";
					end
				end
				if (((5223 - (88 + 858)) <= (1364 + 3111)) and v97.HammerofWrath:IsReady() and v38) then
					if (v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath)) or ((721 + 149) == (49 + 1140))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((2342 - (766 + 23)) <= (15466 - 12333)) and v97.Judgment:IsReady() and v39) then
					if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((3059 - 822) >= (9250 - 5739))) then
						return "judgment standard 22";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((4493 - 3169) > (4093 - (1036 + 37)))) then
						return "judgment standard 22";
					end
				end
				if ((v97.Consecration:IsCastable() and v35 and v14:BuffDown(v97.ConsecrationBuff) and ((v14:BuffStack(v97.SanctificationBuff) < (4 + 1)) or not v14:HasTier(60 - 29, 2 + 0))) or ((4472 - (641 + 839)) == (2794 - (910 + 3)))) then
					if (((7918 - 4812) > (3210 - (1466 + 218))) and v24(v97.Consecration, not v16:IsInRange(4 + 4))) then
						return "consecration standard 24";
					end
				end
				v134 = 1151 - (556 + 592);
			end
			if (((1075 + 1948) < (4678 - (329 + 479))) and (v134 == (857 - (174 + 680)))) then
				if (((491 - 348) > (153 - 79)) and (v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and v97.InmostLight:IsAvailable() and (v105 >= (3 + 0))) then
					if (((757 - (396 + 343)) < (187 + 1925)) and v24(v97.EyeofTyr, not v16:IsInRange(1485 - (29 + 1448)))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((2486 - (135 + 1254)) <= (6132 - 4504)) and v97.BlessedHammer:IsCastable() and v34) then
					if (((21618 - 16988) == (3086 + 1544)) and v24(v97.BlessedHammer, not v16:IsInRange(1535 - (389 + 1138)))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((4114 - (102 + 472)) > (2532 + 151)) and v97.HammeroftheRighteous:IsCastable() and v37) then
					if (((2659 + 2135) >= (3054 + 221)) and v24(v97.HammeroftheRighteous, not v16:IsInRange(1553 - (320 + 1225)))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				if (((2641 - 1157) == (909 + 575)) and v97.CrusaderStrike:IsCastable() and v36) then
					if (((2896 - (157 + 1307)) < (5414 - (821 + 1038))) and v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				v134 = 9 - 5;
			end
			if (((0 + 0) == v134) or ((1891 - 826) > (1332 + 2246))) then
				if ((v97.Consecration:IsCastable() and v35 and (v14:BuffStack(v97.SanctificationBuff) == (12 - 7))) or ((5821 - (834 + 192)) < (90 + 1317))) then
					if (((476 + 1377) < (104 + 4709)) and v24(v97.Consecration, not v16:IsInRange(12 - 4))) then
						return "consecration standard 2";
					end
				end
				if ((v97.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (306 - (300 + 4))) or v14:BuffUp(v97.BastionofLightBuff) or v14:BuffUp(v97.DivinePurposeBuff)) and (v14:BuffDown(v97.SanctificationBuff) or (v14:BuffStack(v97.SanctificationBuff) < (2 + 3)))) or ((7384 - 4563) < (2793 - (112 + 250)))) then
					if (v24(v97.ShieldoftheRighteous) or ((1146 + 1728) < (5463 - 3282))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v97.Judgment:IsReady() and v39 and (v105 > (2 + 1)) and (v14:BuffStack(v97.BulwarkofRighteousFuryBuff) >= (2 + 1)) and (v14:HolyPower() < (3 + 0))) or ((1334 + 1355) <= (255 + 88))) then
					if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((3283 - (1001 + 413)) == (4479 - 2470))) then
						return "judgment standard 6";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((4428 - (244 + 638)) < (3015 - (627 + 66)))) then
						return "judgment standard 6";
					end
				end
				if ((v97.Judgment:IsReady() and v39 and v14:BuffDown(v97.SanctificationEmpowerBuff) and v14:HasTier(92 - 61, 604 - (512 + 90))) or ((3988 - (1665 + 241)) == (5490 - (373 + 344)))) then
					local v204 = 0 + 0;
					while true do
						if (((859 + 2385) > (2782 - 1727)) and (v204 == (0 - 0))) then
							if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((4412 - (35 + 1064)) <= (1294 + 484))) then
								return "judgment standard 8";
							end
							if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((3040 - 1619) >= (9 + 2095))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				v134 = 1237 - (298 + 938);
			end
			if (((3071 - (233 + 1026)) <= (4915 - (636 + 1030))) and (v134 == (3 + 1))) then
				if (((1586 + 37) <= (582 + 1375)) and (v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and not v97.InmostLight:IsAvailable()) then
					if (((299 + 4113) == (4633 - (55 + 166))) and v24(v97.EyeofTyr, not v16:IsInRange(2 + 6))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((176 + 1574) >= (3215 - 2373)) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (302 - (36 + 261)))) then
					if (((7645 - 3273) > (3218 - (34 + 1334))) and v24(v97.ArcaneTorrent, not v16:IsInRange(4 + 4))) then
						return "arcane_torrent standard 36";
					end
				end
				if (((181 + 51) < (2104 - (1035 + 248))) and v97.Consecration:IsCastable() and v35 and (v14:BuffDown(v97.SanctificationEmpowerBuff))) then
					if (((539 - (20 + 1)) < (470 + 432)) and v24(v97.Consecration, not v16:IsInRange(327 - (134 + 185)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v135 = 1133 - (549 + 584);
		while true do
			if (((3679 - (314 + 371)) > (2945 - 2087)) and (v135 == (973 - (478 + 490)))) then
				v48 = EpicSettings.Settings['divineTollWithCD'];
				v49 = EpicSettings.Settings['eyeofTyrWithCD'];
				v50 = EpicSettings.Settings['momentofGloryWithCD'];
				v135 = 4 + 2;
			end
			if ((v135 == (1172 - (786 + 386))) or ((12162 - 8407) <= (2294 - (1055 + 324)))) then
				v33 = EpicSettings.Settings['useAvengersShield'];
				v34 = EpicSettings.Settings['useBlessedHammer'];
				v35 = EpicSettings.Settings['useConsecration'];
				v135 = 1341 - (1093 + 247);
			end
			if (((3507 + 439) > (394 + 3349)) and (v135 == (11 - 8))) then
				v42 = EpicSettings.Settings['useDivineToll'];
				v43 = EpicSettings.Settings['useEyeofTyr'];
				v44 = EpicSettings.Settings['useMomentOfGlory'];
				v135 = 13 - 9;
			end
			if ((v135 == (5 - 3)) or ((3354 - 2019) >= (1177 + 2129))) then
				v39 = EpicSettings.Settings['useJudgment'];
				v40 = EpicSettings.Settings['useAvengingWrath'];
				v41 = EpicSettings.Settings['useBastionofLight'];
				v135 = 11 - 8;
			end
			if (((16696 - 11852) > (1699 + 554)) and (v135 == (15 - 9))) then
				v51 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((1140 - (364 + 324)) == (1238 - 786)) and (v135 == (2 - 1))) then
				v36 = EpicSettings.Settings['useCrusaderStrike'];
				v37 = EpicSettings.Settings['useHammeroftheRighteous'];
				v38 = EpicSettings.Settings['useHammerofWrath'];
				v135 = 1 + 1;
			end
			if ((v135 == (16 - 12)) or ((7297 - 2740) < (6338 - 4251))) then
				v45 = EpicSettings.Settings['useSentinel'];
				v46 = EpicSettings.Settings['avengingWrathWithCD'];
				v47 = EpicSettings.Settings['bastionofLightWithCD'];
				v135 = 1273 - (1249 + 19);
			end
		end
	end
	local function v123()
		local v136 = 0 + 0;
		while true do
			if (((15079 - 11205) == (4960 - (686 + 400))) and ((0 + 0) == v136)) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v55 = EpicSettings.Settings['useDivineShield'];
				v136 = 230 - (73 + 156);
			end
			if ((v136 == (1 + 2)) or ((2749 - (721 + 90)) > (56 + 4879))) then
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v65 = EpicSettings.Settings['ardentDefenderHP'];
				v66 = EpicSettings.Settings['divineShieldHP'];
				v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v136 = 12 - 8;
			end
			if (((472 - (224 + 246)) == v136) or ((6893 - 2638) < (6302 - 2879))) then
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useWordofGloryMouseover'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v136 = 1 + 2;
			end
			if (((35 + 1419) <= (1830 + 661)) and (v136 == (11 - 5))) then
				v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v136 == (16 - 11)) or ((4670 - (203 + 310)) <= (4796 - (1238 + 755)))) then
				v72 = EpicSettings.Settings['wordofGloryFocusHP'];
				v73 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v74 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v136 = 1 + 5;
			end
			if (((6387 - (709 + 825)) >= (5494 - 2512)) and (v136 == (1 - 0))) then
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v136 = 866 - (196 + 668);
			end
			if (((16321 - 12187) > (6953 - 3596)) and (v136 == (837 - (171 + 662)))) then
				v68 = EpicSettings.Settings['layonHandsHP'];
				v69 = EpicSettings.Settings['wordofGloryHP'];
				v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v71 = EpicSettings.Settings['layOnHandsFocusHP'];
				v136 = 98 - (4 + 89);
			end
		end
	end
	local function v124()
		v85 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v82 = EpicSettings.Settings['InterruptWithStun'];
		v83 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v84 = EpicSettings.Settings['InterruptThreshold'];
		v79 = EpicSettings.Settings['DispelDebuffs'];
		v78 = EpicSettings.Settings['DispelBuffs'];
		v86 = EpicSettings.Settings['useTrinkets'];
		v88 = EpicSettings.Settings['useRacials'];
		v87 = EpicSettings.Settings['trinketsWithCD'];
		v89 = EpicSettings.Settings['racialsWithCD'];
		v91 = EpicSettings.Settings['useHealthstone'];
		v90 = EpicSettings.Settings['useHealingPotion'];
		v93 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v92 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v94 = EpicSettings.Settings['HealingPotionName'] or "";
		v80 = EpicSettings.Settings['handleAfflicted'];
		v81 = EpicSettings.Settings['HandleIncorporeal'];
		v95 = EpicSettings.Settings['HealOOC'];
		v96 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v125()
		local v151 = 1486 - (35 + 1451);
		while true do
			if ((v151 == (1454 - (28 + 1425))) or ((5410 - (941 + 1052)) < (2430 + 104))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((4236 - (822 + 692)) <= (233 - 69))) then
					return v28;
				end
				v151 = 1 + 1;
			end
			if ((v151 == (300 - (45 + 252))) or ((2383 + 25) < (726 + 1383))) then
				v102 = v14:IsTankingAoE(19 - 11) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((466 - (114 + 319)) == (2088 - 633))) then
					if ((v97.CrusaderAura:IsCastable() and (v14:BuffDown(v97.CrusaderAura))) or ((567 - 124) >= (2560 + 1455))) then
						if (((5037 - 1655) > (347 - 181)) and v24(v97.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (v14:AffectingCombat() or (v79 and v97.CleanseToxins:IsAvailable()) or ((2243 - (556 + 1407)) == (4265 - (741 + 465)))) then
					local v205 = v79 and v97.CleanseToxins:IsReady() and v32;
					v28 = v107.FocusUnit(v205, v99, 485 - (170 + 295), nil, 14 + 11);
					if (((1728 + 153) > (3183 - 1890)) and v28) then
						return v28;
					end
				end
				if (((1954 + 403) == (1512 + 845)) and v32 and v79) then
					local v206 = 0 + 0;
					while true do
						if (((1353 - (957 + 273)) == (33 + 90)) and (v206 == (1 + 0))) then
							if ((v97.BlessingofFreedom:IsReady() and v107.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((4023 - 2967) >= (8938 - 5546))) then
								if (v24(v99.BlessingofFreedomFocus) or ((3301 - 2220) < (5323 - 4248))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if ((v206 == (1780 - (389 + 1391))) or ((659 + 390) >= (462 + 3970))) then
							v28 = v107.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 91 - 51, 976 - (783 + 168));
							if (v28 or ((16002 - 11234) <= (833 + 13))) then
								return v28;
							end
							v206 = 312 - (309 + 2);
						end
					end
				end
				v151 = 12 - 8;
			end
			if ((v151 == (1212 - (1090 + 122))) or ((1089 + 2269) <= (4769 - 3349))) then
				v123();
				v122();
				v124();
				v29 = EpicSettings.Toggles['ooc'];
				v151 = 1 + 0;
			end
			if (((1125 - (628 + 490)) == v151) or ((671 + 3068) <= (7440 - 4435))) then
				if (v107.TargetIsValid() or ((7581 - 5922) >= (2908 - (431 + 343)))) then
					if ((v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((6583 - 3323) < (6812 - 4457))) then
						if (v14:AffectingCombat() or ((529 + 140) == (541 + 3682))) then
							if (v97.Intercession:IsCastable() or ((3387 - (556 + 1139)) < (603 - (6 + 9)))) then
								if (v24(v97.Intercession, not v16:IsInRange(6 + 24), true) or ((2458 + 2339) < (3820 - (28 + 141)))) then
									return "intercession";
								end
							end
						elseif (v97.Redemption:IsCastable() or ((1618 + 2559) > (5986 - 1136))) then
							if (v24(v97.Redemption, not v16:IsInRange(22 + 8), true) or ((1717 - (486 + 831)) > (2891 - 1780))) then
								return "redemption";
							end
						end
					end
					if (((10741 - 7690) > (190 + 815)) and v107.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
						local v210 = 0 - 0;
						while true do
							if (((4956 - (668 + 595)) <= (3944 + 438)) and (v210 == (1 + 0))) then
								if ((v86 and ((v31 and v87) or not v87) and v16:IsInRange(21 - 13)) or ((3572 - (23 + 267)) > (6044 - (1129 + 815)))) then
									local v213 = 387 - (371 + 16);
									while true do
										if ((v213 == (1750 - (1326 + 424))) or ((6780 - 3200) < (10392 - 7548))) then
											v28 = v116();
											if (((207 - (88 + 30)) < (5261 - (720 + 51))) and v28) then
												return v28;
											end
											break;
										end
									end
								end
								v28 = v121();
								v210 = 4 - 2;
							end
							if ((v210 == (1778 - (421 + 1355))) or ((8220 - 3237) < (889 + 919))) then
								if (((4912 - (286 + 797)) > (13777 - 10008)) and v28) then
									return v28;
								end
								if (((2459 - 974) <= (3343 - (397 + 42))) and v24(v97.Pool)) then
									return "Wait/Pool Resources";
								end
								break;
							end
							if (((1334 + 2935) == (5069 - (24 + 776))) and (v210 == (0 - 0))) then
								if (((1172 - (222 + 563)) <= (6129 - 3347)) and v102) then
									v28 = v117();
									if (v28 or ((1368 + 531) <= (1107 - (23 + 167)))) then
										return v28;
									end
								end
								if ((v85 < v109) or ((6110 - (690 + 1108)) <= (317 + 559))) then
									v28 = v120();
									if (((1842 + 390) <= (3444 - (40 + 808))) and v28) then
										return v28;
									end
								end
								v210 = 1 + 0;
							end
						end
					end
				end
				break;
			end
			if (((8011 - 5916) < (3523 + 163)) and (v151 == (3 + 2))) then
				v28 = v115();
				if (v28 or ((875 + 720) >= (5045 - (47 + 524)))) then
					return v28;
				end
				if ((v79 and v32) or ((2998 + 1621) < (7878 - 4996))) then
					if (v13 or ((439 - 145) >= (11017 - 6186))) then
						local v211 = 1726 - (1165 + 561);
						while true do
							if (((61 + 1968) <= (9551 - 6467)) and (v211 == (0 + 0))) then
								v28 = v114();
								if (v28 or ((2516 - (341 + 138)) == (654 + 1766))) then
									return v28;
								end
								break;
							end
						end
					end
					if (((9199 - 4741) > (4230 - (89 + 237))) and v15 and v15:Exists() and v15:IsAPlayer() and (v107.UnitHasCurseDebuff(v15) or v107.UnitHasPoisonDebuff(v15))) then
						if (((1402 - 966) >= (258 - 135)) and v97.CleanseToxins:IsReady()) then
							if (((1381 - (581 + 300)) < (3036 - (855 + 365))) and v24(v99.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v28 = v118();
				v151 = 13 - 7;
			end
			if (((1167 + 2407) == (4809 - (1030 + 205))) and (v151 == (6 + 0))) then
				if (((206 + 15) < (676 - (156 + 130))) and v28) then
					return v28;
				end
				if ((v97.Redemption:IsCastable() and v97.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((5028 - 2815) <= (2394 - 973))) then
					if (((6262 - 3204) < (1281 + 3579)) and v24(v99.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((756 + 540) >= (4515 - (10 + 59)))) then
					if ((v97.Intercession:IsCastable() and (v14:HolyPower() >= (1 + 2)) and v97.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((6860 - 5467) > (5652 - (671 + 492)))) then
						if (v24(v99.IntercessionMouseover) or ((3522 + 902) < (1242 - (369 + 846)))) then
							return "Intercession";
						end
					end
				end
				if ((v107.TargetIsValid() and not v14:AffectingCombat() and v29) or ((529 + 1468) > (3256 + 559))) then
					v28 = v119();
					if (((5410 - (1036 + 909)) > (1521 + 392)) and v28) then
						return v28;
					end
				end
				v151 = 11 - 4;
			end
			if (((936 - (11 + 192)) < (920 + 899)) and (v151 == (179 - (135 + 40)))) then
				if (v107.TargetIsValid() or v14:AffectingCombat() or ((10648 - 6253) == (2867 + 1888))) then
					local v207 = 0 - 0;
					while true do
						if ((v207 == (1 - 0)) or ((3969 - (50 + 126)) < (6596 - 4227))) then
							if ((v109 == (2460 + 8651)) or ((5497 - (1233 + 180)) == (1234 - (522 + 447)))) then
								v109 = v9.FightRemains(v103, false);
							end
							v110 = v14:HolyPower();
							break;
						end
						if (((5779 - (107 + 1314)) == (2023 + 2335)) and (v207 == (0 - 0))) then
							v108 = v9.BossFightRemains(nil, true);
							v109 = v108;
							v207 = 1 + 0;
						end
					end
				end
				if (not v14:AffectingCombat() or ((6231 - 3093) < (3928 - 2935))) then
					if (((5240 - (716 + 1194)) > (40 + 2283)) and v97.DevotionAura:IsCastable() and (v113())) then
						if (v24(v97.DevotionAura) or ((389 + 3237) == (4492 - (74 + 429)))) then
							return "devotion_aura";
						end
					end
				end
				if (v80 or ((1766 - 850) == (1324 + 1347))) then
					if (((622 - 350) == (193 + 79)) and v76) then
						v28 = v107.HandleAfflicted(v97.CleanseToxins, v99.CleanseToxinsMouseover, 123 - 83);
						if (((10505 - 6256) <= (5272 - (279 + 154))) and v28) then
							return v28;
						end
					end
					if (((3555 - (454 + 324)) < (2518 + 682)) and v14:BuffUp(v97.ShiningLightFreeBuff) and v77) then
						local v212 = 17 - (12 + 5);
						while true do
							if (((52 + 43) < (4986 - 3029)) and (v212 == (0 + 0))) then
								v28 = v107.HandleAfflicted(v97.WordofGlory, v99.WordofGloryMouseover, 1133 - (277 + 816), true);
								if (((3529 - 2703) < (2900 - (1058 + 125))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (((268 + 1158) >= (2080 - (815 + 160))) and v81) then
					local v208 = 0 - 0;
					while true do
						if (((6537 - 3783) <= (807 + 2572)) and (v208 == (2 - 1))) then
							v28 = v107.HandleIncorporeal(v97.TurnEvil, v99.TurnEvilMouseOver, 1928 - (41 + 1857), true);
							if (v28 or ((5820 - (1222 + 671)) == (3651 - 2238))) then
								return v28;
							end
							break;
						end
						if ((v208 == (0 - 0)) or ((2336 - (229 + 953)) <= (2562 - (1111 + 663)))) then
							v28 = v107.HandleIncorporeal(v97.Repentance, v99.RepentanceMouseOver, 1609 - (874 + 705), true);
							if (v28 or ((230 + 1413) > (2306 + 1073))) then
								return v28;
							end
							v208 = 1 - 0;
						end
					end
				end
				v151 = 1 + 4;
			end
			if (((681 - (642 + 37)) == v151) or ((640 + 2163) > (728 + 3821))) then
				v103 = v14:GetEnemiesInMeleeRange(19 - 11);
				v104 = v14:GetEnemiesInRange(484 - (233 + 221));
				if (v30 or ((508 - 288) >= (2660 + 362))) then
					v105 = #v103;
					v106 = #v104;
				else
					local v209 = 1541 - (718 + 823);
					while true do
						if (((1776 + 1046) == (3627 - (266 + 539))) and (v209 == (0 - 0))) then
							v105 = 1226 - (636 + 589);
							v106 = 2 - 1;
							break;
						end
					end
				end
				v101 = v14:ActiveMitigationNeeded();
				v151 = 5 - 2;
			end
		end
	end
	local function v126()
		local v152 = 0 + 0;
		while true do
			if ((v152 == (0 + 0)) or ((2076 - (657 + 358)) == (4916 - 3059))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v111();
				break;
			end
		end
	end
	v20.SetAPL(150 - 84, v125, v126);
end;
return v0["Epix_Paladin_Protection.lua"]();

