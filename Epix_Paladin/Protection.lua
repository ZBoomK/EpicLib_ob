local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((70 - 48) <= (3994 - (404 + 1335))) and not v5) then
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
	local v97;
	local v98;
	local v99 = v18.Paladin.Protection;
	local v100 = v19.Paladin.Protection;
	local v101 = v23.Paladin.Protection;
	local v102 = {};
	local v103;
	local v104;
	local v105, v106;
	local v107, v108;
	local v109 = v20.Commons.Everyone;
	local v110 = 11517 - (183 + 223);
	local v111 = 13520 - 2409;
	local v112 = 0 + 0;
	v9:RegisterForEvent(function()
		v110 = 3999 + 7112;
		v111 = 11448 - (10 + 327);
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((757 + 329) >= (1743 - (118 + 220)))) then
			v109.DispellableDebuffs = v12.MergeTable(v109.DispellableDiseaseDebuffs, v109.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v114(v130)
		return v130:DebuffRemains(v99.JudgmentDebuff);
	end
	local function v115()
		return v14:BuffDown(v99.RetributionAura) and v14:BuffDown(v99.DevotionAura) and v14:BuffDown(v99.ConcentrationAura) and v14:BuffDown(v99.CrusaderAura);
	end
	local v116 = 0 + 0;
	local function v117()
		if ((v99.CleanseToxins:IsReady() and (v109.UnitHasDispellableDebuffByPlayer(v13) or v109.DispellableFriendlyUnit(469 - (108 + 341)) or v109.UnitHasCurseDebuff(v13) or v109.UnitHasPoisonDebuff(v13))) or ((1065 + 1304) == (1800 - 1374))) then
			local v200 = 1493 - (711 + 782);
			while true do
				if ((v200 == (0 - 0)) or ((3545 - (270 + 199)) > (1032 + 2151))) then
					if (((3021 - (580 + 1239)) > (3145 - 2087)) and (v116 == (0 + 0))) then
						v116 = GetTime();
					end
					if (((134 + 3577) > (1462 + 1893)) and v109.Wait(1305 - 805, v116)) then
						local v216 = 0 + 0;
						while true do
							if ((v216 == (1167 - (645 + 522))) or ((2696 - (1010 + 780)) >= (2228 + 1))) then
								if (((6135 - 4847) > (3665 - 2414)) and v24(v101.CleanseToxinsFocus)) then
									return "cleanse_toxins dispel";
								end
								v116 = 1836 - (1045 + 791);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v118()
		if ((v97 and (v14:HealthPercentage() <= v98)) or ((11423 - 6910) < (5117 - 1765))) then
			if (v99.FlashofLight:IsReady() or ((2570 - (351 + 154)) >= (4770 - (1281 + 293)))) then
				if (v24(v99.FlashofLight) or ((4642 - (28 + 238)) <= (3309 - 1828))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		local v131 = 1559 - (1381 + 178);
		while true do
			if ((v131 == (1 + 0)) or ((2736 + 656) >= (2023 + 2718))) then
				v28 = v109.HandleBottomTrinket(v102, v31, 137 - 97, nil);
				if (((1723 + 1602) >= (2624 - (381 + 89))) and v28) then
					return v28;
				end
				break;
			end
			if ((v131 == (0 + 0)) or ((876 + 419) >= (5537 - 2304))) then
				v28 = v109.HandleTopTrinket(v102, v31, 1196 - (1074 + 82), nil);
				if (((9591 - 5214) > (3426 - (214 + 1570))) and v28) then
					return v28;
				end
				v131 = 1456 - (990 + 465);
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if (((2056 + 2667) > (1319 + 37)) and (v132 == (0 - 0))) then
				if (((v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((5862 - (1668 + 58)) <= (4059 - (512 + 114)))) then
					if (((11067 - 6822) <= (9573 - 4942)) and v24(v99.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((14878 - 10602) >= (1821 + 2093)) and (v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
					if (((38 + 160) <= (3795 + 570)) and v24(v101.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v132 = 3 - 2;
			end
			if (((6776 - (109 + 1885)) > (6145 - (1269 + 200))) and (v132 == (5 - 2))) then
				if (((5679 - (98 + 717)) > (3023 - (802 + 24))) and v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) then
					if (v24(v101.Healthstone) or ((6380 - 2680) == (3165 - 658))) then
						return "healthstone defensive";
					end
				end
				if (((661 + 3813) >= (211 + 63)) and v92 and (v14:HealthPercentage() <= v94)) then
					local v205 = 0 + 0;
					while true do
						if ((v205 == (0 + 0)) or ((5268 - 3374) <= (4688 - 3282))) then
							if (((563 + 1009) >= (624 + 907)) and (v96 == "Refreshing Healing Potion")) then
								if (v100.RefreshingHealingPotion:IsReady() or ((3867 + 820) < (3303 + 1239))) then
									if (((1537 + 1754) > (3100 - (797 + 636))) and v24(v101.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((4238 - 3365) == (3653 - (1427 + 192)))) then
								if (v100.DreamwalkersHealingPotion:IsReady() or ((976 + 1840) < (25 - 14))) then
									if (((3325 + 374) < (2133 + 2573)) and v24(v101.RefreshingHealingPotion)) then
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
			if (((2972 - (192 + 134)) >= (2152 - (316 + 960))) and (v132 == (2 + 0))) then
				if (((474 + 140) <= (2943 + 241)) and v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) then
					if (((11950 - 8824) == (3677 - (83 + 468))) and ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (1811 - (1202 + 604))) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff))) then
						if (v24(v101.WordofGloryPlayer) or ((10209 - 8022) >= (8244 - 3290))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (5 - 3)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) or ((4202 - (45 + 280)) == (3451 + 124))) then
					if (((618 + 89) > (231 + 401)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v132 = 2 + 1;
			end
			if ((v132 == (1 + 0)) or ((1010 - 464) >= (4595 - (340 + 1571)))) then
				if (((578 + 887) <= (6073 - (1733 + 39))) and v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) then
					if (((4682 - 2978) > (2459 - (125 + 909))) and v24(v99.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) or ((2635 - (1096 + 852)) == (1900 + 2334))) then
					if (v24(v99.ArdentDefender) or ((4755 - 1425) < (1387 + 42))) then
						return "ardent_defender defensive 6";
					end
				end
				v132 = 514 - (409 + 103);
			end
		end
	end
	local function v121()
		local v133 = 236 - (46 + 190);
		while true do
			if (((1242 - (51 + 44)) >= (95 + 240)) and (v133 == (1318 - (1114 + 203)))) then
				if (((4161 - (228 + 498)) > (455 + 1642)) and v13) then
					if ((v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (2 + 1))) and (v13:HealthPercentage() <= v74)) or ((4433 - (174 + 489)) >= (10527 - 6486))) then
						if (v24(v101.WordofGloryFocus) or ((5696 - (830 + 1075)) <= (2135 - (303 + 221)))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73) and v14:AffectingCombat()) or ((5847 - (231 + 1038)) <= (1674 + 334))) then
						if (((2287 - (171 + 991)) <= (8555 - 6479)) and v24(v101.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) or ((1994 - 1251) >= (10977 - 6578))) then
						if (((925 + 230) < (5864 - 4191)) and v24(v101.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) or ((6704 - 4380) <= (931 - 353))) then
						if (((11644 - 7877) == (5015 - (111 + 1137))) and v24(v101.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((4247 - (91 + 67)) == (12169 - 8080)) and (v133 == (0 + 0))) then
				if (((4981 - (423 + 100)) >= (12 + 1662)) and v15:Exists()) then
					if (((2690 - 1718) <= (740 + 678)) and v99.WordofGlory:IsReady() and v64 and not v14:CanAttack(v15) and (v15:HealthPercentage() <= v75)) then
						if (v24(v101.WordofGloryMouseover) or ((5709 - (326 + 445)) < (20781 - 16019))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(66 - 36) or ((5844 - 3340) > (4975 - (530 + 181)))) then
					return;
				end
				v133 = 882 - (614 + 267);
			end
		end
	end
	local function v122()
		if (((2185 - (19 + 13)) == (3503 - 1350)) and (v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) then
			if (v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment)) or ((1181 - 674) >= (7401 - 4810))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((1164 + 3317) == (7880 - 3399)) and (v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (10 - 5))) then
			if (v24(v99.ArcaneTorrent, not v16:IsInRange(1820 - (1293 + 519))) or ((4749 - 2421) < (1809 - 1116))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((8276 - 3948) == (18662 - 14334)) and v99.Consecration:IsCastable() and v37) then
			if (((3740 - 2152) >= (706 + 626)) and v24(v99.Consecration, not v16:IsInRange(2 + 6))) then
				return "consecration precombat 8";
			end
		end
		if ((v99.AvengersShield:IsCastable() and v35) or ((9698 - 5524) > (982 + 3266))) then
			if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) or ((1524 + 3062) <= (52 + 30))) then
				if (((4959 - (709 + 387)) == (5721 - (673 + 1185))) and v24(v101.AvengersShieldMouseover)) then
					return "avengers_shield mouseover precombat 10";
				end
			end
			if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((817 - 535) <= (134 - 92))) then
				return "avengers_shield precombat 10";
			end
		end
		if (((7582 - 2973) >= (548 + 218)) and v99.Judgment:IsReady() and v41) then
			if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((861 + 291) == (3358 - 870))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v123()
		if (((841 + 2581) > (6679 - 3329)) and v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (3 - 1)) and v14:HasTier(1909 - (446 + 1434), 1285 - (1040 + 243))) then
			if (((2617 - 1740) > (2223 - (559 + 1288))) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) then
				if (v24(v101.AvengersShieldMouseover) or ((5049 - (609 + 1322)) <= (2305 - (13 + 441)))) then
					return "avengers_shield mouseover cooldowns 2";
				end
			end
			if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((616 - 451) >= (9146 - 5654))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((19667 - 15718) < (181 + 4675)) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (7 - 5))) then
			if (v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment)) or ((1519 + 2757) < (1322 + 1694))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((13917 - 9227) > (2258 + 1867)) and v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) then
			if (v24(v99.AvengingWrath, not v16:IsInRange(14 - 6)) or ((34 + 16) >= (499 + 397))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if ((v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) or ((1232 + 482) >= (2484 + 474))) then
			if (v24(v99.Sentinel, not v16:IsInRange(8 + 0)) or ((1924 - (153 + 280)) < (1859 - 1215))) then
				return "sentinel cooldowns 8";
			end
		end
		local v134 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
		if (((633 + 71) < (390 + 597)) and v134) then
			return v134;
		end
		if (((1946 + 1772) > (1730 + 176)) and v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (11 + 4)) or (((v9.CombatTime() > (15 - 5)) or (v99.Sentinel:CooldownRemains() > (10 + 5)) or (v99.AvengingWrath:CooldownRemains() > (682 - (89 + 578)))) and (v99.AvengersShield:CooldownRemains() > (0 + 0)) and (v99.Judgment:CooldownRemains() > (0 - 0)) and (v99.HammerofWrath:CooldownRemains() > (1049 - (572 + 477)))))) then
			if (v24(v99.MomentOfGlory, not v16:IsInRange(2 + 6)) or ((575 + 383) > (434 + 3201))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((3587 - (84 + 2)) <= (7402 - 2910)) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (3 + 0))) then
			if (v24(v99.DivineToll, not v16:IsInRange(872 - (497 + 345))) or ((89 + 3353) < (431 + 2117))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((4208 - (605 + 728)) >= (1045 + 419)) and v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (66 - 36)))) then
			if (v24(v99.BastionofLight, not v16:IsInRange(1 + 7)) or ((17735 - 12938) >= (4412 + 481))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v124()
		local v135 = 0 - 0;
		while true do
			if (((0 + 0) == v135) or ((1040 - (457 + 32)) > (878 + 1190))) then
				if (((3516 - (832 + 570)) > (890 + 54)) and v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (2 + 3))) then
					if (v24(v99.Consecration, not v16:IsInRange(28 - 20)) or ((1090 + 1172) >= (3892 - (588 + 208)))) then
						return "consecration standard 2";
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (5 - 3)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (1805 - (884 + 916))))) or ((4721 - 2466) >= (2051 + 1486))) then
					if (v24(v99.ShieldoftheRighteous) or ((4490 - (232 + 421)) < (3195 - (1569 + 320)))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((724 + 2226) == (561 + 2389)) and v99.Judgment:IsReady() and v41 and (v107 > (9 - 6)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (608 - (316 + 289))) and (v14:HolyPower() < (7 - 4))) then
					local v206 = 0 + 0;
					while true do
						if ((v206 == (1453 - (666 + 787))) or ((5148 - (360 + 65)) < (3083 + 215))) then
							if (((1390 - (79 + 175)) >= (242 - 88)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 6";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((212 + 59) > (14553 - 9805))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v135 = 1 - 0;
			end
			if (((5639 - (503 + 396)) >= (3333 - (92 + 89))) and (v135 == (5 - 2))) then
				if ((v99.HammerofWrath:IsReady() and v40) or ((1323 + 1255) >= (2007 + 1383))) then
					if (((160 - 119) <= (228 + 1433)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((1370 - 769) < (3107 + 453)) and v99.Judgment:IsReady() and v41) then
					local v207 = 0 + 0;
					while true do
						if (((715 - 480) < (86 + 601)) and (v207 == (0 - 0))) then
							if (((5793 - (485 + 759)) > (2667 - 1514)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 22";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((5863 - (442 + 747)) < (5807 - (832 + 303)))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if (((4614 - (88 + 858)) < (1391 + 3170)) and v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (5 + 0)) or not v14:HasTier(2 + 29, 791 - (766 + 23)))) then
					if (v24(v99.Consecration, not v16:IsInRange(39 - 31)) or ((621 - 166) == (9498 - 5893))) then
						return "consecration standard 24";
					end
				end
				v135 = 13 - 9;
			end
			if ((v135 == (1075 - (1036 + 37))) or ((1889 + 774) == (6449 - 3137))) then
				if (((3365 + 912) <= (5955 - (641 + 839))) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (915 - (910 + 3))) or v14:BuffUp(v99.MomentOfGloryBuff))) then
					if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) or ((2217 - 1347) == (2873 - (1466 + 218)))) then
						if (((714 + 839) <= (4281 - (556 + 592))) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 14";
						end
					end
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((796 + 1441) >= (4319 - (329 + 479)))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) or ((2178 - (174 + 680)) > (10377 - 7357))) then
					if (v24(v99.DivineToll, not v16:IsInRange(62 - 32)) or ((2137 + 855) == (2620 - (396 + 343)))) then
						return "divine_toll standard 16";
					end
				end
				if (((275 + 2831) > (3003 - (29 + 1448))) and v99.AvengersShield:IsCastable() and v35) then
					local v208 = 1389 - (135 + 1254);
					while true do
						if (((11388 - 8365) < (18069 - 14199)) and (v208 == (0 + 0))) then
							if (((1670 - (389 + 1138)) > (648 - (102 + 472))) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) then
								if (((17 + 1) < (1172 + 940)) and v24(v101.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 18";
								end
							end
							if (((1023 + 74) <= (3173 - (320 + 1225))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
								return "avengers_shield standard 18";
							end
							break;
						end
					end
				end
				v135 = 5 - 2;
			end
			if (((2833 + 1797) == (6094 - (157 + 1307))) and (v135 == (1864 - (821 + 1038)))) then
				if (((8832 - 5292) > (294 + 2389)) and v99.CrusaderStrike:IsCastable() and v38) then
					if (((8515 - 3721) >= (1219 + 2056)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((3678 - 2194) == (2510 - (834 + 192))) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) then
					if (((92 + 1340) < (913 + 2642)) and v24(v99.EyeofTyr, not v16:IsInRange(1 + 7))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (7 - 2))) or ((1369 - (300 + 4)) > (956 + 2622))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(20 - 12)) or ((5157 - (112 + 250)) < (561 + 846))) then
						return "arcane_torrent standard 36";
					end
				end
				v135 = 14 - 8;
			end
			if (((1062 + 791) < (2490 + 2323)) and (v135 == (1 + 0))) then
				if ((v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(16 + 15, 2 + 0)) or ((4235 - (1001 + 413)) < (5421 - 2990))) then
					local v209 = 882 - (244 + 638);
					while true do
						if ((v209 == (693 - (627 + 66))) or ((8563 - 5689) < (2783 - (512 + 90)))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((4595 - (1665 + 241)) <= (1060 - (373 + 344)))) then
								return "judgment standard 8";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((843 + 1026) == (532 + 1477))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v99.HammerofWrath:IsReady() and v40) or ((9353 - 5807) < (3928 - 1606))) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((3181 - (35 + 1064)) == (3473 + 1300))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((6940 - 3696) > (5 + 1050)) and v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (1238 - (298 + 938))) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) then
					local v210 = 1259 - (233 + 1026);
					while true do
						if ((v210 == (1666 - (636 + 1030))) or ((1694 + 1619) <= (1737 + 41))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((423 + 998) >= (143 + 1961))) then
								return "judgment standard 12";
							end
							if (((2033 - (55 + 166)) <= (630 + 2619)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v135 = 1 + 1;
			end
			if (((6198 - 4575) <= (2254 - (36 + 261))) and ((9 - 3) == v135)) then
				if (((5780 - (34 + 1334)) == (1697 + 2715)) and v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) then
					if (((1360 + 390) >= (2125 - (1035 + 248))) and v24(v99.Consecration, not v16:IsInRange(29 - (20 + 1)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((2278 + 2094) > (2169 - (134 + 185))) and ((1137 - (549 + 584)) == v135)) then
				if (((917 - (314 + 371)) < (2818 - 1997)) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (971 - (478 + 490)))) then
					if (((275 + 243) < (2074 - (786 + 386))) and v24(v99.EyeofTyr, not v16:IsInRange(25 - 17))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((4373 - (1055 + 324)) > (2198 - (1093 + 247))) and v99.BlessedHammer:IsCastable() and v36) then
					if (v24(v99.BlessedHammer, not v16:IsInRange(8 + 0)) or ((395 + 3360) <= (3632 - 2717))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((13391 - 9445) > (10650 - 6907)) and v99.HammeroftheRighteous:IsCastable() and v39) then
					if (v24(v99.HammeroftheRighteous, not v16:IsInRange(19 - 11)) or ((475 + 860) >= (12735 - 9429))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v135 = 17 - 12;
			end
		end
	end
	local function v125()
		v33 = EpicSettings.Settings['swapAuras'];
		v34 = EpicSettings.Settings['useWeapon'];
		v35 = EpicSettings.Settings['useAvengersShield'];
		v36 = EpicSettings.Settings['useBlessedHammer'];
		v37 = EpicSettings.Settings['useConsecration'];
		v38 = EpicSettings.Settings['useCrusaderStrike'];
		v39 = EpicSettings.Settings['useHammeroftheRighteous'];
		v40 = EpicSettings.Settings['useHammerofWrath'];
		v41 = EpicSettings.Settings['useJudgment'];
		v42 = EpicSettings.Settings['useAvengingWrath'];
		v43 = EpicSettings.Settings['useBastionofLight'];
		v44 = EpicSettings.Settings['useDivineToll'];
		v45 = EpicSettings.Settings['useEyeofTyr'];
		v46 = EpicSettings.Settings['useMomentOfGlory'];
		v47 = EpicSettings.Settings['useSentinel'];
		v48 = EpicSettings.Settings['avengingWrathWithCD'];
		v49 = EpicSettings.Settings['bastionofLightWithCD'];
		v50 = EpicSettings.Settings['divineTollWithCD'];
		v51 = EpicSettings.Settings['eyeofTyrWithCD'];
		v52 = EpicSettings.Settings['momentOfGloryWithCD'];
		v53 = EpicSettings.Settings['sentinelWithCD'];
	end
	local function v126()
		v54 = EpicSettings.Settings['useRebuke'];
		v55 = EpicSettings.Settings['useHammerofJustice'];
		v56 = EpicSettings.Settings['useArdentDefender'];
		v57 = EpicSettings.Settings['useDivineShield'];
		v58 = EpicSettings.Settings['useGuardianofAncientKings'];
		v59 = EpicSettings.Settings['useLayOnHands'];
		v60 = EpicSettings.Settings['useWordofGloryPlayer'];
		v61 = EpicSettings.Settings['useShieldoftheRighteous'];
		v62 = EpicSettings.Settings['useLayOnHandsFocus'];
		v63 = EpicSettings.Settings['useWordofGloryFocus'];
		v64 = EpicSettings.Settings['useWordofGloryMouseover'];
		v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v67 = EpicSettings.Settings['ardentDefenderHP'];
		v68 = EpicSettings.Settings['divineShieldHP'];
		v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v70 = EpicSettings.Settings['layonHandsHP'];
		v71 = EpicSettings.Settings['wordofGloryHP'];
		v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v73 = EpicSettings.Settings['layOnHandsFocusHP'];
		v74 = EpicSettings.Settings['wordofGloryFocusHP'];
		v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v127()
		v87 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v84 = EpicSettings.Settings['InterruptWithStun'];
		v85 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v86 = EpicSettings.Settings['InterruptThreshold'];
		v81 = EpicSettings.Settings['DispelDebuffs'];
		v80 = EpicSettings.Settings['DispelBuffs'];
		v88 = EpicSettings.Settings['useTrinkets'];
		v90 = EpicSettings.Settings['useRacials'];
		v89 = EpicSettings.Settings['trinketsWithCD'];
		v91 = EpicSettings.Settings['racialsWithCD'];
		v93 = EpicSettings.Settings['useHealthstone'];
		v92 = EpicSettings.Settings['useHealingPotion'];
		v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v94 = EpicSettings.Settings['healingPotionHP'] or (688 - (364 + 324));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v82 = EpicSettings.Settings['handleAfflicted'];
		v83 = EpicSettings.Settings['HandleIncorporeal'];
		v97 = EpicSettings.Settings['HealOOC'];
		v98 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v128()
		local v197 = 0 - 0;
		while true do
			if (((1606 + 3238) > (9427 - 7174)) and (v197 == (5 - 1))) then
				v28 = v121();
				if (((1372 - 920) == (1720 - (1249 + 19))) and v28) then
					return v28;
				end
				v28 = v118();
				if (v28 or ((4114 + 443) < (8123 - 6036))) then
					return v28;
				end
				if (((4960 - (686 + 400)) == (3040 + 834)) and not v14:AffectingCombat()) then
					if ((v99.DevotionAura:IsCastable() and (v115()) and v33) or ((2167 - (73 + 156)) > (24 + 4911))) then
						if (v24(v99.DevotionAura) or ((5066 - (721 + 90)) < (39 + 3384))) then
							return "devotion_aura";
						end
					end
				end
				v197 = 16 - 11;
			end
			if (((1924 - (224 + 246)) <= (4035 - 1544)) and (v197 == (5 - 2))) then
				if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((755 + 3402) <= (67 + 2736))) then
					local v211 = 0 + 0;
					local v212;
					while true do
						if (((9648 - 4795) >= (9923 - 6941)) and ((513 - (203 + 310)) == v211)) then
							v212 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v212, nil, 2013 - (1238 + 755), nil, 2 + 23, v99.WordofGlory);
							v211 = 1535 - (709 + 825);
						end
						if (((7617 - 3483) > (4890 - 1533)) and ((865 - (196 + 668)) == v211)) then
							if (v28 or ((13491 - 10074) < (5248 - 2714))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((3555 - (171 + 662)) <= (257 - (4 + 89)))) then
					if (v14:AffectingCombat() or ((8439 - 6031) < (768 + 1341))) then
						if (v99.Intercession:IsCastable() or ((144 - 111) == (571 + 884))) then
							if (v24(v99.Intercession, not v16:IsInRange(1516 - (35 + 1451)), true) or ((1896 - (28 + 1425)) >= (6008 - (941 + 1052)))) then
								return "intercession target";
							end
						end
					elseif (((3243 + 139) > (1680 - (822 + 692))) and v99.Redemption:IsCastable()) then
						if (v24(v99.Redemption, not v16:IsInRange(42 - 12), true) or ((132 + 148) == (3356 - (45 + 252)))) then
							return "redemption target";
						end
					end
				end
				if (((1862 + 19) > (445 + 848)) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((5735 - 3378) == (2790 - (114 + 319))) and v24(v101.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((175 - 52) == (157 - 34)) and v14:AffectingCombat()) then
					if ((v99.Intercession:IsCastable() and (v14:HolyPower() >= (2 + 1)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1572 - 516) >= (7106 - 3714))) then
						if (v24(v101.IntercessionMouseover) or ((3044 - (556 + 1407)) < (2281 - (741 + 465)))) then
							return "Intercession";
						end
					end
				end
				if ((v32 and v81) or ((1514 - (170 + 295)) >= (2336 + 2096))) then
					local v213 = 0 + 0;
					while true do
						if (((0 - 0) == v213) or ((3953 + 815) <= (543 + 303))) then
							v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 23 + 17, 1255 - (957 + 273), v99.WordofGlory, 1 + 1);
							if (v28 or ((1345 + 2013) <= (5410 - 3990))) then
								return v28;
							end
							v213 = 2 - 1;
						end
						if (((2 - 1) == v213) or ((18514 - 14775) <= (4785 - (389 + 1391)))) then
							if ((v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((1041 + 618) >= (223 + 1911))) then
								if (v24(v101.BlessingofFreedomFocus) or ((7421 - 4161) < (3306 - (783 + 168)))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				v197 = 13 - 9;
			end
			if ((v197 == (0 + 0)) or ((980 - (309 + 2)) == (12968 - 8745))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v197 = 1213 - (1090 + 122);
			end
			if ((v197 == (1 + 1)) or ((5682 - 3990) < (403 + 185))) then
				if (v30 or ((5915 - (628 + 490)) < (655 + 2996))) then
					v107 = #v105;
					v108 = #v106;
				else
					v107 = 2 - 1;
					v108 = 4 - 3;
				end
				v103 = v14:ActiveMitigationNeeded();
				v104 = v14:IsTankingAoE(782 - (431 + 343)) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((8435 - 4258) > (14030 - 9180))) then
					if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) or ((317 + 83) > (143 + 968))) then
						if (((4746 - (556 + 1139)) > (1020 - (6 + 9))) and v24(v99.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (((677 + 3016) <= (2245 + 2137)) and (v109.TargetIsValid() or v14:AffectingCombat())) then
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					if ((v111 == (11280 - (28 + 141))) or ((1272 + 2010) > (5060 - 960))) then
						v111 = v9.FightRemains(v105, false);
					end
					v112 = v14:HolyPower();
				end
				v197 = 3 + 0;
			end
			if ((v197 == (1323 - (486 + 831))) or ((9316 - 5736) < (10012 - 7168))) then
				if (((17 + 72) < (14197 - 9707)) and v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
					if ((v87 < v111) or ((6246 - (668 + 595)) < (1627 + 181))) then
						v28 = v123();
						if (((773 + 3056) > (10278 - 6509)) and v28) then
							return v28;
						end
						if (((1775 - (23 + 267)) <= (4848 - (1129 + 815))) and v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) then
							if (((4656 - (371 + 16)) == (6019 - (1326 + 424))) and v24(v101.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if (((732 - 345) <= (10166 - 7384)) and v88 and ((v31 and v89) or not v89) and v16:IsInRange(126 - (88 + 30))) then
						v28 = v119();
						if (v28 or ((2670 - (720 + 51)) <= (2039 - 1122))) then
							return v28;
						end
					end
					v28 = v124();
					if (v28 or ((6088 - (421 + 1355)) <= (1444 - 568))) then
						return v28;
					end
					if (((1097 + 1135) <= (3679 - (286 + 797))) and v24(v99.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((7658 - 5563) < (6104 - 2418)) and (v197 == (444 - (397 + 42)))) then
				if (v82 or ((499 + 1096) >= (5274 - (24 + 776)))) then
					local v214 = 0 - 0;
					while true do
						if ((v214 == (785 - (222 + 563))) or ((10176 - 5557) < (2075 + 807))) then
							if (v78 or ((484 - (23 + 167)) >= (6629 - (690 + 1108)))) then
								v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 15 + 25);
								if (((1674 + 355) <= (3932 - (40 + 808))) and v28) then
									return v28;
								end
							end
							if ((v14:BuffUp(v99.ShiningLightFreeBuff) and v79) or ((336 + 1701) == (9254 - 6834))) then
								local v218 = 0 + 0;
								while true do
									if (((2359 + 2099) > (2141 + 1763)) and ((571 - (47 + 524)) == v218)) then
										v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 26 + 14, true);
										if (((1191 - 755) >= (183 - 60)) and v28) then
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
				if (((1140 - 640) < (3542 - (1165 + 561))) and v83) then
					v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 1 + 29, true);
					if (((11069 - 7495) == (1364 + 2210)) and v28) then
						return v28;
					end
					v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 509 - (341 + 138), true);
					if (((60 + 161) < (804 - 414)) and v28) then
						return v28;
					end
				end
				if ((v81 and v32) or ((2539 - (89 + 237)) <= (4571 - 3150))) then
					if (((6437 - 3379) < (5741 - (581 + 300))) and v13) then
						local v217 = 1220 - (855 + 365);
						while true do
							if ((v217 == (0 - 0)) or ((424 + 872) >= (5681 - (1030 + 205)))) then
								v28 = v117();
								if (v28 or ((1308 + 85) > (4176 + 313))) then
									return v28;
								end
								break;
							end
						end
					end
					if ((v15 and v15:Exists() and not v14:CanAttack(v15) and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15) or v109.UnitHasDispellableDebuffByPlayer(v15))) or ((4710 - (156 + 130)) < (61 - 34))) then
						if (v99.CleanseToxins:IsReady() or ((3365 - 1368) > (7813 - 3998))) then
							if (((914 + 2551) > (1116 + 797)) and v24(v101.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				if (((802 - (10 + 59)) < (515 + 1304)) and v104) then
					v28 = v120();
					if (v28 or ((21644 - 17249) == (5918 - (671 + 492)))) then
						return v28;
					end
				end
				if ((v109.TargetIsValid() and not v14:AffectingCombat() and v29) or ((3020 + 773) < (3584 - (369 + 846)))) then
					local v215 = 0 + 0;
					while true do
						if ((v215 == (0 + 0)) or ((6029 - (1036 + 909)) == (211 + 54))) then
							v28 = v122();
							if (((7316 - 2958) == (4561 - (11 + 192))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v197 = 4 + 2;
			end
			if ((v197 == (176 - (135 + 40))) or ((7602 - 4464) < (599 + 394))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (((7336 - 4006) > (3482 - 1159)) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v105 = v14:GetEnemiesInMeleeRange(184 - (50 + 126));
				v106 = v14:GetEnemiesInRange(83 - 53);
				v197 = 1 + 1;
			end
		end
	end
	local function v129()
		local v198 = 1413 - (1233 + 180);
		while true do
			if ((v198 == (969 - (522 + 447))) or ((5047 - (107 + 1314)) == (1852 + 2137))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v113();
				break;
			end
		end
	end
	v20.SetAPL(201 - 135, v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

