local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((10365 - 5852) < (4753 - 1401))) then
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
	local v108 = 400 + 10711;
	local v109 = 4841 + 6270;
	local v110 = 0 - 0;
	v9:RegisterForEvent(function()
		v108 = 6903 + 4208;
		v109 = 12278 - (645 + 522);
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (v97.CleanseToxins:IsAvailable() or ((3855 - (1010 + 780)) >= (3195 + 1))) then
			v107.DispellableDebuffs = v12.MergeTable(v107.DispellableDiseaseDebuffs, v107.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v111();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v112(v127)
		return v127:DebuffRemains(v97.JudgmentDebuff);
	end
	local function v113()
		return v14:BuffDown(v97.RetributionAura) and v14:BuffDown(v97.DevotionAura) and v14:BuffDown(v97.ConcentrationAura) and v14:BuffDown(v97.CrusaderAura);
	end
	local function v114()
		if ((v97.CleanseToxins:IsReady() and v107.DispellableFriendlyUnit(119 - 94)) or ((12823 - 8447) <= (3317 - (1045 + 791)))) then
			if (v24(v99.CleanseToxinsFocus) or ((8585 - 5193) >= (7238 - 2497))) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v115()
		if (((3830 - (351 + 154)) >= (3728 - (1281 + 293))) and v95 and (v14:HealthPercentage() <= v96)) then
			if (v97.FlashofLight:IsReady() or ((1561 - (28 + 238)) >= (7223 - 3990))) then
				if (((5936 - (1381 + 178)) > (1541 + 101)) and v24(v97.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v116()
		local v128 = 0 + 0;
		while true do
			if (((2015 + 2708) > (4674 - 3318)) and (v128 == (1 + 0))) then
				v28 = v107.HandleBottomTrinket(v100, v31, 510 - (381 + 89), nil);
				if (v28 or ((3668 + 468) <= (2322 + 1111))) then
					return v28;
				end
				break;
			end
			if (((7271 - 3026) <= (5787 - (1074 + 82))) and (v128 == (0 - 0))) then
				v28 = v107.HandleTopTrinket(v100, v31, 1824 - (214 + 1570), nil);
				if (((5731 - (990 + 465)) >= (1614 + 2300)) and v28) then
					return v28;
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v117()
		local v129 = 0 + 0;
		while true do
			if (((779 - 581) <= (6091 - (1668 + 58))) and (v129 == (628 - (512 + 114)))) then
				if (((12467 - 7685) > (9666 - 4990)) and v97.WordofGlory:IsReady() and (v14:HealthPercentage() <= v69) and v58 and not v14:HealingAbsorbed()) then
					if (((16924 - 12060) > (1023 + 1174)) and ((v14:BuffRemains(v97.ShieldoftheRighteousBuff) >= (1 + 4)) or v14:BuffUp(v97.DivinePurposeBuff) or v14:BuffUp(v97.ShiningLightFreeBuff))) then
						if (v24(v99.WordofGloryPlayer) or ((3217 + 483) == (8455 - 5948))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((6468 - (109 + 1885)) >= (1743 - (1269 + 200))) and v97.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (3 - 1)) and v14:BuffRefreshable(v97.ShieldoftheRighteousBuff) and v59 and (v101 or (v14:HealthPercentage() <= v70))) then
					if (v24(v97.ShieldoftheRighteous) or ((2709 - (98 + 717)) <= (2232 - (802 + 24)))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v129 = 5 - 2;
			end
			if (((1984 - 412) >= (227 + 1304)) and (v129 == (1 + 0))) then
				if ((v97.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v97.ArdentDefenderBuff)) or ((770 + 3917) < (980 + 3562))) then
					if (((9155 - 5864) > (5559 - 3892)) and v24(v97.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v97.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v65) and v54 and v14:BuffDown(v97.GuardianofAncientKingsBuff)) or ((313 + 560) == (828 + 1206))) then
					if (v24(v97.ArdentDefender) or ((2323 + 493) < (8 + 3))) then
						return "ardent_defender defensive 6";
					end
				end
				v129 = 1 + 1;
			end
			if (((5132 - (797 + 636)) < (22849 - 18143)) and (v129 == (1622 - (1427 + 192)))) then
				if (((917 + 1729) >= (2033 - 1157)) and v98.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) then
					if (((552 + 62) <= (1443 + 1741)) and v24(v99.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if (((3452 - (192 + 134)) == (4402 - (316 + 960))) and v90 and (v14:HealthPercentage() <= v92)) then
					local v201 = 0 + 0;
					while true do
						if ((v201 == (0 + 0)) or ((2022 + 165) >= (18939 - 13985))) then
							if ((v94 == "Refreshing Healing Potion") or ((4428 - (83 + 468)) == (5381 - (1202 + 604)))) then
								if (((3300 - 2593) > (1051 - 419)) and v98.RefreshingHealingPotion:IsReady()) then
									if (v24(v99.RefreshingHealingPotion) or ((1511 - 965) >= (3009 - (45 + 280)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((1415 + 50) <= (3758 + 543)) and (v94 == "Dreamwalker's Healing Potion")) then
								if (((623 + 1081) > (789 + 636)) and v98.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v99.RefreshingHealingPotion) or ((121 + 566) == (7839 - 3605))) then
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
			if ((v129 == (1911 - (340 + 1571))) or ((1314 + 2016) < (3201 - (1733 + 39)))) then
				if (((3151 - 2004) >= (1369 - (125 + 909))) and (v14:HealthPercentage() <= v66) and v55 and v97.DivineShield:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) then
					if (((5383 - (1096 + 852)) > (941 + 1156)) and v24(v97.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((v14:HealthPercentage() <= v68) and v57 and v97.LayonHands:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((5383 - 1613) >= (3920 + 121))) then
					if (v24(v99.LayonHandsPlayer) or ((4303 - (409 + 103)) <= (1847 - (46 + 190)))) then
						return "lay_on_hands defensive 2";
					end
				end
				v129 = 96 - (51 + 44);
			end
		end
	end
	local function v118()
		if (v15:Exists() or ((1292 + 3286) <= (3325 - (1114 + 203)))) then
			if (((1851 - (228 + 498)) <= (450 + 1626)) and v97.WordofGlory:IsReady() and v62 and (v15:HealthPercentage() <= v73)) then
				if (v24(v99.WordofGloryMouseover) or ((411 + 332) >= (5062 - (174 + 489)))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (((3008 - 1853) < (3578 - (830 + 1075))) and (not v13 or not v13:Exists() or not v13:IsInRange(554 - (303 + 221)))) then
			return;
		end
		if (v13 or ((3593 - (231 + 1038)) <= (482 + 96))) then
			local v151 = 1162 - (171 + 991);
			while true do
				if (((15524 - 11757) == (10114 - 6347)) and (v151 == (0 - 0))) then
					if (((3273 + 816) == (14333 - 10244)) and v97.WordofGlory:IsReady() and v61 and v14:BuffUp(v97.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v72)) then
						if (((12860 - 8402) >= (2697 - 1023)) and v24(v99.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((3004 - 2032) <= (2666 - (111 + 1137))) and v97.LayonHands:IsCastable() and v60 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v71)) then
						if (v24(v99.LayonHandsFocus) or ((5096 - (91 + 67)) < (14172 - 9410))) then
							return "lay_on_hands defensive focus";
						end
					end
					v151 = 1 + 0;
				end
				if ((v151 == (524 - (423 + 100))) or ((18 + 2486) > (11806 - 7542))) then
					if (((1123 + 1030) == (2924 - (326 + 445))) and v97.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) then
						if (v24(v99.BlessingofSacrificeFocus) or ((2212 - 1705) >= (5772 - 3181))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((10459 - 5978) == (5192 - (530 + 181))) and v97.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) then
						if (v24(v99.BlessingofProtectionFocus) or ((3209 - (614 + 267)) < (725 - (19 + 13)))) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
			end
		end
	end
	local function v119()
		local v130 = 0 - 0;
		while true do
			if (((10085 - 5757) == (12363 - 8035)) and (v130 == (1 + 1))) then
				if (((2792 - 1204) >= (2761 - 1429)) and v97.Judgment:IsReady() and v39) then
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((5986 - (1293 + 519)) > (8667 - 4419))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v130 == (0 - 0)) or ((8769 - 4183) <= (353 - 271))) then
				if (((9099 - 5236) == (2047 + 1816)) and (v85 < v109) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89)) then
					if (v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment)) or ((58 + 224) <= (97 - 55))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((1066 + 3543) >= (255 + 511)) and (v85 < v109) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (4 + 1))) then
					if (v24(v97.ArcaneTorrent, not v16:IsInRange(1104 - (709 + 387))) or ((3010 - (673 + 1185)) == (7215 - 4727))) then
						return "arcane_torrent precombat 6";
					end
				end
				v130 = 3 - 2;
			end
			if (((5629 - 2207) > (2397 + 953)) and ((1 + 0) == v130)) then
				if (((1183 - 306) > (93 + 283)) and v97.Consecration:IsCastable() and v35) then
					if (v24(v97.Consecration, not v16:IsInRange(15 - 7)) or ((6120 - 3002) <= (3731 - (446 + 1434)))) then
						return "consecration";
					end
				end
				if ((v97.AvengersShield:IsCastable() and v33) or ((1448 - (1040 + 243)) >= (10422 - 6930))) then
					if (((5796 - (559 + 1288)) < (6787 - (609 + 1322))) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v130 = 456 - (13 + 441);
			end
		end
	end
	local function v120()
		if ((v97.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (7 - 5)) and v14:HasTier(75 - 46, 9 - 7)) or ((160 + 4116) < (10953 - 7937))) then
			if (((1666 + 3024) > (1808 + 2317)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if ((v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89) and (v106 >= (5 - 3))) or ((28 + 22) >= (1647 - 751))) then
			if (v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment)) or ((1134 + 580) >= (1646 + 1312))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v97.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) or ((1072 + 419) < (541 + 103))) then
			if (((689 + 15) < (1420 - (153 + 280))) and v24(v97.AvengingWrath, not v16:IsInRange(23 - 15))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((3339 + 379) > (753 + 1153)) and v97.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) then
			if (v24(v97.Sentinel, not v16:IsInRange(5 + 3)) or ((870 + 88) > (2634 + 1001))) then
				return "sentinel cooldowns 8";
			end
		end
		local v131 = v107.HandleDPSPotion(v14:BuffUp(v97.AvengingWrathBuff));
		if (((5330 - 1829) <= (2777 + 1715)) and v131) then
			return v131;
		end
		if ((v97.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v97.SentinelBuff) < (682 - (89 + 578))) or (((v9.CombatTime() > (8 + 2)) or (v97.Sentinel:CooldownRemains() > (30 - 15)) or (v97.AvengingWrath:CooldownRemains() > (1064 - (572 + 477)))) and (v97.AvengersShield:CooldownRemains() > (0 + 0)) and (v97.Judgment:CooldownRemains() > (0 + 0)) and (v97.HammerofWrath:CooldownRemains() > (0 + 0))))) or ((3528 - (84 + 2)) < (4199 - 1651))) then
			if (((2072 + 803) >= (2306 - (497 + 345))) and v24(v97.MomentofGlory, not v16:IsInRange(1 + 7))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady() and (v105 >= (1 + 2))) or ((6130 - (605 + 728)) >= (3492 + 1401))) then
			if (v24(v97.DivineToll, not v16:IsInRange(66 - 36)) or ((26 + 525) > (7645 - 5577))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((1906 + 208) > (2615 - 1671)) and v97.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v97.AvengingWrathBuff) or (v97.AvengingWrath:CooldownRemains() <= (23 + 7)))) then
			if (v24(v97.BastionofLight, not v16:IsInRange(497 - (457 + 32))) or ((960 + 1302) >= (4498 - (832 + 570)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v121()
		local v132 = 0 + 0;
		while true do
			if (((1 + 0) == v132) or ((7980 - 5725) >= (1704 + 1833))) then
				if ((v97.HammerofWrath:IsReady() and v38) or ((4633 - (588 + 208)) < (3519 - 2213))) then
					if (((4750 - (884 + 916)) == (6176 - 3226)) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v97.Judgment:IsReady() and v39 and ((v97.Judgment:Charges() >= (2 + 0)) or (v97.Judgment:FullRechargeTime() <= v14:GCD()))) or ((5376 - (232 + 421)) < (5187 - (1569 + 320)))) then
					if (((279 + 857) >= (30 + 124)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment standard 12";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((913 - 642) > (5353 - (316 + 289)))) then
						return "judgment standard 12";
					end
				end
				if (((12407 - 7667) >= (146 + 3006)) and v97.AvengersShield:IsCastable() and v33 and ((v106 > (1455 - (666 + 787))) or v14:BuffUp(v97.MomentofGloryBuff))) then
					if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((3003 - (360 + 65)) >= (3169 + 221))) then
						return "avengers_shield standard 14";
					end
				end
				if (((295 - (79 + 175)) <= (2618 - 957)) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady()) then
					if (((469 + 132) < (10912 - 7352)) and v24(v97.DivineToll, not v16:IsInRange(57 - 27))) then
						return "divine_toll standard 16";
					end
				end
				v132 = 901 - (503 + 396);
			end
			if (((416 - (92 + 89)) < (1332 - 645)) and (v132 == (2 + 0))) then
				if (((2693 + 1856) > (4515 - 3362)) and v97.AvengersShield:IsCastable() and v33) then
					if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((640 + 4034) < (10652 - 5980))) then
						return "avengers_shield standard 18";
					end
				end
				if (((3201 + 467) < (2179 + 2382)) and v97.HammerofWrath:IsReady() and v38) then
					if (v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath)) or ((1385 - 930) == (450 + 3155))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v97.Judgment:IsReady() and v39) or ((4060 - 1397) == (4556 - (485 + 759)))) then
					if (((9896 - 5619) <= (5664 - (442 + 747))) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment standard 22";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2005 - (832 + 303)) == (2135 - (88 + 858)))) then
						return "judgment standard 22";
					end
				end
				if (((474 + 1079) <= (2593 + 540)) and v97.Consecration:IsCastable() and v35 and v14:BuffDown(v97.ConsecrationBuff) and ((v14:BuffStack(v97.SanctificationBuff) < (1 + 4)) or not v14:HasTier(820 - (766 + 23), 9 - 7))) then
					if (v24(v97.Consecration, not v16:IsInRange(10 - 2)) or ((5893 - 3656) >= (11916 - 8405))) then
						return "consecration standard 24";
					end
				end
				v132 = 1076 - (1036 + 37);
			end
			if ((v132 == (3 + 0)) or ((2577 - 1253) > (2376 + 644))) then
				if (((v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and v97.InmostLight:IsAvailable() and (v105 >= (1483 - (641 + 839)))) or ((3905 - (910 + 3)) == (4795 - 2914))) then
					if (((4790 - (1466 + 218)) > (702 + 824)) and v24(v97.EyeofTyr, not v16:IsInRange(1156 - (556 + 592)))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((1075 + 1948) < (4678 - (329 + 479))) and v97.BlessedHammer:IsCastable() and v34) then
					if (((997 - (174 + 680)) > (253 - 179)) and v24(v97.BlessedHammer, not v16:IsInRange(16 - 8))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((13 + 5) < (2851 - (396 + 343))) and v97.HammeroftheRighteous:IsCastable() and v37) then
					if (((98 + 999) <= (3105 - (29 + 1448))) and v24(v97.HammeroftheRighteous, not v16:IsInRange(1397 - (135 + 1254)))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				if (((17442 - 12812) == (21618 - 16988)) and v97.CrusaderStrike:IsCastable() and v36) then
					if (((2360 + 1180) > (4210 - (389 + 1138))) and v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				v132 = 578 - (102 + 472);
			end
			if (((4525 + 269) >= (1817 + 1458)) and ((0 + 0) == v132)) then
				if (((3029 - (320 + 1225)) == (2641 - 1157)) and v97.Consecration:IsCastable() and v35 and (v14:BuffStack(v97.SanctificationBuff) == (4 + 1))) then
					if (((2896 - (157 + 1307)) < (5414 - (821 + 1038))) and v24(v97.Consecration, not v16:IsInRange(19 - 11))) then
						return "consecration standard 2";
					end
				end
				if ((v97.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (1 + 1)) or v14:BuffUp(v97.BastionofLightBuff) or v14:BuffUp(v97.DivinePurposeBuff)) and (v14:BuffDown(v97.SanctificationBuff) or (v14:BuffStack(v97.SanctificationBuff) < (8 - 3)))) or ((397 + 668) > (8868 - 5290))) then
					if (v24(v97.ShieldoftheRighteous) or ((5821 - (834 + 192)) < (90 + 1317))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((476 + 1377) < (104 + 4709)) and v97.Judgment:IsReady() and v39 and (v105 > (4 - 1)) and (v14:BuffStack(v97.BulwarkofRighteousFuryBuff) >= (307 - (300 + 4))) and (v14:HolyPower() < (1 + 2))) then
					local v202 = 0 - 0;
					while true do
						if ((v202 == (362 - (112 + 250))) or ((1125 + 1696) < (6090 - 3659))) then
							if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((1647 + 1227) < (1128 + 1053))) then
								return "judgment standard 6";
							end
							if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2012 + 677) <= (171 + 172))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				if ((v97.Judgment:IsReady() and v39 and v14:BuffDown(v97.SanctificationEmpowerBuff) and v14:HasTier(24 + 7, 1416 - (1001 + 413))) or ((4167 - 2298) == (2891 - (244 + 638)))) then
					if (v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment)) or ((4239 - (627 + 66)) < (6918 - 4596))) then
						return "judgment standard 8";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2684 - (512 + 90)) == (6679 - (1665 + 241)))) then
						return "judgment standard 8";
					end
				end
				v132 = 718 - (373 + 344);
			end
			if (((1464 + 1780) > (280 + 775)) and (v132 == (10 - 6))) then
				if (((v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and not v97.InmostLight:IsAvailable()) or ((5605 - 2292) <= (2877 - (35 + 1064)))) then
					if (v24(v97.EyeofTyr, not v16:IsInRange(6 + 2)) or ((3040 - 1619) >= (9 + 2095))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((3048 - (298 + 938)) <= (4508 - (233 + 1026))) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (1671 - (636 + 1030)))) then
					if (((830 + 793) <= (1912 + 45)) and v24(v97.ArcaneTorrent, not v16:IsInRange(3 + 5))) then
						return "arcane_torrent standard 36";
					end
				end
				if (((299 + 4113) == (4633 - (55 + 166))) and v97.Consecration:IsCastable() and v35 and (v14:BuffDown(v97.SanctificationEmpowerBuff))) then
					if (((340 + 1410) >= (85 + 757)) and v24(v97.Consecration, not v16:IsInRange(30 - 22))) then
						return "consecration standard 38";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v133 = 297 - (36 + 261);
		while true do
			if (((7645 - 3273) > (3218 - (34 + 1334))) and (v133 == (2 + 2))) then
				v49 = EpicSettings.Settings['eyeofTyrWithCD'];
				v50 = EpicSettings.Settings['momentofGloryWithCD'];
				v51 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((181 + 51) < (2104 - (1035 + 248))) and (v133 == (23 - (20 + 1)))) then
				v41 = EpicSettings.Settings['useBastionofLight'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v43 = EpicSettings.Settings['useEyeofTyr'];
				v44 = EpicSettings.Settings['useMomentOfGlory'];
				v133 = 2 + 1;
			end
			if (((837 - (134 + 185)) < (2035 - (549 + 584))) and (v133 == (688 - (314 + 371)))) then
				v45 = EpicSettings.Settings['useSentinel'];
				v46 = EpicSettings.Settings['avengingWrathWithCD'];
				v47 = EpicSettings.Settings['bastionofLightWithCD'];
				v48 = EpicSettings.Settings['divineTollWithCD'];
				v133 = 13 - 9;
			end
			if (((3962 - (478 + 490)) > (455 + 403)) and (v133 == (1172 - (786 + 386)))) then
				v33 = EpicSettings.Settings['useAvengersShield'];
				v34 = EpicSettings.Settings['useBlessedHammer'];
				v35 = EpicSettings.Settings['useConsecration'];
				v36 = EpicSettings.Settings['useCrusaderStrike'];
				v133 = 3 - 2;
			end
			if ((v133 == (1380 - (1055 + 324))) or ((5095 - (1093 + 247)) <= (814 + 101))) then
				v37 = EpicSettings.Settings['useHammeroftheRighteous'];
				v38 = EpicSettings.Settings['useHammerofWrath'];
				v39 = EpicSettings.Settings['useJudgment'];
				v40 = EpicSettings.Settings['useAvengingWrath'];
				v133 = 1 + 1;
			end
		end
	end
	local function v123()
		local v134 = 0 - 0;
		while true do
			if (((13391 - 9445) > (10650 - 6907)) and (v134 == (19 - 11))) then
				v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v134 == (3 + 3)) or ((5142 - 3807) >= (11394 - 8088))) then
				v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v71 = EpicSettings.Settings['layOnHandsFocusHP'];
				v72 = EpicSettings.Settings['wordofGloryFocusHP'];
				v134 = 6 + 1;
			end
			if (((12387 - 7543) > (2941 - (364 + 324))) and (v134 == (7 - 4))) then
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useWordofGloryMouseover'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v134 = 9 - 5;
			end
			if (((150 + 302) == (1891 - 1439)) and (v134 == (1 - 0))) then
				v55 = EpicSettings.Settings['useDivineShield'];
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v134 = 5 - 3;
			end
			if (((1275 - (1249 + 19)) == v134) or ((4114 + 443) < (8123 - 6036))) then
				v73 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v74 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v134 = 1094 - (686 + 400);
			end
			if (((3040 + 834) == (4103 - (73 + 156))) and (v134 == (0 + 0))) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v134 = 812 - (721 + 90);
			end
			if (((1 + 4) == v134) or ((6292 - 4354) > (5405 - (224 + 246)))) then
				v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v68 = EpicSettings.Settings['layonHandsHP'];
				v69 = EpicSettings.Settings['wordofGloryHP'];
				v134 = 9 - 3;
			end
			if ((v134 == (6 - 2)) or ((772 + 3483) < (82 + 3341))) then
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v65 = EpicSettings.Settings['ardentDefenderHP'];
				v66 = EpicSettings.Settings['divineShieldHP'];
				v134 = 4 + 1;
			end
			if (((2890 - 1436) <= (8289 - 5798)) and (v134 == (515 - (203 + 310)))) then
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v134 = 1996 - (1238 + 755);
			end
		end
	end
	local function v124()
		v85 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
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
		v93 = EpicSettings.Settings['healthstoneHP'] or (1534 - (709 + 825));
		v92 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v94 = EpicSettings.Settings['HealingPotionName'] or "";
		v80 = EpicSettings.Settings['handleAfflicted'];
		v81 = EpicSettings.Settings['HandleIncorporeal'];
		v95 = EpicSettings.Settings['HealOOC'];
		v96 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v125()
		local v149 = 864 - (196 + 668);
		while true do
			if (((0 - 0) == v149) or ((8610 - 4453) <= (3636 - (171 + 662)))) then
				v123();
				v122();
				v124();
				v29 = EpicSettings.Toggles['ooc'];
				v149 = 94 - (4 + 89);
			end
			if (((17009 - 12156) >= (1086 + 1896)) and (v149 == (21 - 16))) then
				v28 = v115();
				if (((1622 + 2512) > (4843 - (35 + 1451))) and v28) then
					return v28;
				end
				if ((v79 and v32) or ((4870 - (28 + 1425)) < (4527 - (941 + 1052)))) then
					local v203 = 0 + 0;
					while true do
						if ((v203 == (1514 - (822 + 692))) or ((3885 - 1163) <= (78 + 86))) then
							if (v13 or ((2705 - (45 + 252)) < (2087 + 22))) then
								local v209 = 0 + 0;
								while true do
									if ((v209 == (0 - 0)) or ((466 - (114 + 319)) == (2088 - 633))) then
										v28 = v114();
										if (v28 or ((567 - 124) >= (2560 + 1455))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((5037 - 1655) > (347 - 181)) and v15 and v15:Exists() and v15:IsAPlayer() and (v107.UnitHasCurseDebuff(v15) or v107.UnitHasPoisonDebuff(v15))) then
								if (v97.CleanseToxins:IsReady() or ((2243 - (556 + 1407)) == (4265 - (741 + 465)))) then
									if (((2346 - (170 + 295)) > (682 + 611)) and v24(v99.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v118();
				v149 = 6 + 0;
			end
			if (((5803 - 3446) == (1954 + 403)) and (v149 == (2 + 1))) then
				v102 = v14:IsTankingAoE(5 + 3) or v14:IsTanking(v16);
				if (((1353 - (957 + 273)) == (33 + 90)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if ((v97.CrusaderAura:IsCastable() and (v14:BuffDown(v97.CrusaderAura))) or ((423 + 633) >= (12924 - 9532))) then
						if (v24(v97.CrusaderAura) or ((2848 - 1767) < (3283 - 2208))) then
							return "crusader_aura";
						end
					end
				end
				if (v14:AffectingCombat() or (v79 and v97.CleanseToxins:IsAvailable()) or ((5194 - 4145) >= (6212 - (389 + 1391)))) then
					local v204 = v79 and v97.CleanseToxins:IsReady() and v32;
					v28 = v107.FocusUnit(v204, v99, 13 + 7, nil, 3 + 22);
					if (v28 or ((10854 - 6086) <= (1797 - (783 + 168)))) then
						return v28;
					end
				end
				if ((v32 and v79) or ((11270 - 7912) <= (1397 + 23))) then
					v28 = v107.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 351 - (309 + 2), 76 - 51);
					if (v28 or ((4951 - (1090 + 122)) <= (975 + 2030))) then
						return v28;
					end
					if ((v97.BlessingofFreedom:IsReady() and v107.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((5571 - 3912) >= (1461 + 673))) then
						if (v24(v99.BlessingofFreedomFocus) or ((4378 - (628 + 490)) < (423 + 1932))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v149 = 9 - 5;
			end
			if (((4 - 3) == v149) or ((1443 - (431 + 343)) == (8528 - 4305))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((4894 - 3202) < (465 + 123))) then
					return v28;
				end
				v149 = 1 + 1;
			end
			if ((v149 == (1701 - (556 + 1139))) or ((4812 - (6 + 9)) < (669 + 2982))) then
				if (v28 or ((2140 + 2037) > (5019 - (28 + 141)))) then
					return v28;
				end
				if ((v97.Redemption:IsCastable() and v97.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((155 + 245) > (1371 - 260))) then
					if (((2161 + 890) > (2322 - (486 + 831))) and v24(v99.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((9609 - 5916) <= (15427 - 11045)) and v14:AffectingCombat()) then
					if ((v97.Intercession:IsCastable() and (v14:HolyPower() >= (1 + 2)) and v97.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((10377 - 7095) > (5363 - (668 + 595)))) then
						if (v24(v99.IntercessionMouseover) or ((3222 + 358) < (574 + 2270))) then
							return "Intercession";
						end
					end
				end
				if (((242 - 153) < (4780 - (23 + 267))) and v107.TargetIsValid() and not v14:AffectingCombat() and v29) then
					v28 = v119();
					if (v28 or ((6927 - (1129 + 815)) < (2195 - (371 + 16)))) then
						return v28;
					end
				end
				v149 = 1757 - (1326 + 424);
			end
			if (((7251 - 3422) > (13772 - 10003)) and (v149 == (125 - (88 + 30)))) then
				if (((2256 - (720 + 51)) <= (6459 - 3555)) and v107.TargetIsValid()) then
					local v205 = 1776 - (421 + 1355);
					while true do
						if (((7042 - 2773) == (2097 + 2172)) and (v205 == (1083 - (286 + 797)))) then
							if (((1414 - 1027) <= (4607 - 1825)) and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
								if (v14:AffectingCombat() or ((2338 - (397 + 42)) <= (287 + 630))) then
									if (v97.Intercession:IsCastable() or ((5112 - (24 + 776)) <= (1349 - 473))) then
										if (((3017 - (222 + 563)) <= (5719 - 3123)) and v24(v97.Intercession, not v16:IsInRange(22 + 8), true)) then
											return "intercession";
										end
									end
								elseif (((2285 - (23 + 167)) < (5484 - (690 + 1108))) and v97.Redemption:IsCastable()) then
									if (v24(v97.Redemption, not v16:IsInRange(11 + 19), true) or ((1316 + 279) >= (5322 - (40 + 808)))) then
										return "redemption";
									end
								end
							end
							if ((v107.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((761 + 3858) < (11020 - 8138))) then
								local v210 = 0 + 0;
								while true do
									if ((v210 == (2 + 0)) or ((162 + 132) >= (5402 - (47 + 524)))) then
										if (((1317 + 712) <= (8430 - 5346)) and v28) then
											return v28;
										end
										if (v24(v97.Pool) or ((3045 - 1008) == (5519 - 3099))) then
											return "Wait/Pool Resources";
										end
										break;
									end
									if (((6184 - (1165 + 561)) > (116 + 3788)) and (v210 == (3 - 2))) then
										if (((167 + 269) >= (602 - (341 + 138))) and v86 and ((v31 and v87) or not v87) and v16:IsInRange(3 + 5)) then
											local v212 = 0 - 0;
											while true do
												if (((826 - (89 + 237)) < (5842 - 4026)) and (v212 == (0 - 0))) then
													v28 = v116();
													if (((4455 - (581 + 300)) == (4794 - (855 + 365))) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										v28 = v121();
										v210 = 4 - 2;
									end
									if (((73 + 148) < (1625 - (1030 + 205))) and (v210 == (0 + 0))) then
										if (v102 or ((2059 + 154) <= (1707 - (156 + 130)))) then
											local v213 = 0 - 0;
											while true do
												if (((5153 - 2095) < (9953 - 5093)) and (v213 == (0 + 0))) then
													v28 = v117();
													if (v28 or ((756 + 540) >= (4515 - (10 + 59)))) then
														return v28;
													end
													break;
												end
											end
										end
										if ((v85 < v109) or ((394 + 999) > (22107 - 17618))) then
											v28 = v120();
											if (v28 or ((5587 - (671 + 492)) < (22 + 5))) then
												return v28;
											end
										end
										v210 = 1216 - (369 + 846);
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((2 + 2) == v149) or ((1705 + 292) > (5760 - (1036 + 909)))) then
				if (((2755 + 710) > (3211 - 1298)) and (v107.TargetIsValid() or v14:AffectingCombat())) then
					v108 = v9.BossFightRemains(nil, true);
					v109 = v108;
					if (((936 - (11 + 192)) < (920 + 899)) and (v109 == (11286 - (135 + 40)))) then
						v109 = v9.FightRemains(v103, false);
					end
					v110 = v14:HolyPower();
				end
				if (not v14:AffectingCombat() or ((10648 - 6253) == (2867 + 1888))) then
					if ((v97.DevotionAura:IsCastable() and (v113())) or ((8355 - 4562) < (3550 - 1181))) then
						if (v24(v97.DevotionAura) or ((4260 - (50 + 126)) == (737 - 472))) then
							return "devotion_aura";
						end
					end
				end
				if (((965 + 3393) == (5771 - (1233 + 180))) and v80) then
					local v206 = 969 - (522 + 447);
					while true do
						if ((v206 == (1421 - (107 + 1314))) or ((1457 + 1681) < (3025 - 2032))) then
							if (((1415 + 1915) > (4612 - 2289)) and v76) then
								local v211 = 0 - 0;
								while true do
									if ((v211 == (1910 - (716 + 1194))) or ((62 + 3564) == (428 + 3561))) then
										v28 = v107.HandleAfflicted(v97.CleanseToxins, v99.CleanseToxinsMouseover, 543 - (74 + 429));
										if (v28 or ((1766 - 850) == (1324 + 1347))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((622 - 350) == (193 + 79)) and v14:BuffUp(v97.ShiningLightFreeBuff) and v77) then
								v28 = v107.HandleAfflicted(v97.WordofGlory, v99.WordofGloryMouseover, 123 - 83, true);
								if (((10505 - 6256) <= (5272 - (279 + 154))) and v28) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if (((3555 - (454 + 324)) < (2518 + 682)) and v81) then
					local v207 = 17 - (12 + 5);
					while true do
						if (((52 + 43) < (4986 - 3029)) and (v207 == (0 + 0))) then
							v28 = v107.HandleIncorporeal(v97.Repentance, v99.RepentanceMouseOver, 1123 - (277 + 816), true);
							if (((3529 - 2703) < (2900 - (1058 + 125))) and v28) then
								return v28;
							end
							v207 = 1 + 0;
						end
						if (((2401 - (815 + 160)) >= (4741 - 3636)) and (v207 == (2 - 1))) then
							v28 = v107.HandleIncorporeal(v97.TurnEvil, v99.TurnEvilMouseOver, 8 + 22, true);
							if (((8050 - 5296) <= (5277 - (41 + 1857))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v149 = 1898 - (1222 + 671);
			end
			if ((v149 == (5 - 3)) or ((5644 - 1717) == (2595 - (229 + 953)))) then
				v103 = v14:GetEnemiesInMeleeRange(1782 - (1111 + 663));
				v104 = v14:GetEnemiesInRange(1609 - (874 + 705));
				if (v30 or ((162 + 992) <= (538 + 250))) then
					local v208 = 0 - 0;
					while true do
						if ((v208 == (0 + 0)) or ((2322 - (642 + 37)) > (771 + 2608))) then
							v105 = #v103;
							v106 = #v104;
							break;
						end
					end
				else
					v105 = 1 + 0;
					v106 = 2 - 1;
				end
				v101 = v14:ActiveMitigationNeeded();
				v149 = 457 - (233 + 221);
			end
		end
	end
	local function v126()
		v20.Print("Protection Paladin by Epic. Supported by xKaneto");
		v111();
	end
	v20.SetAPL(152 - 86, v125, v126);
end;
return v0["Epix_Paladin_Protection.lua"]();

