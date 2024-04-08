local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((20231 - 15897) == (7064 - 2819))) then
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
	local v110 = 30763 - 19652;
	local v111 = 11436 - (45 + 280);
	local v112 = 0 + 0;
	v9:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 + 0)) or ((2367 + 1909) <= (534 + 2497))) then
				v110 = 20574 - 9463;
				v111 = 13022 - (340 + 1571);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((1887 + 2895) <= (2971 - (1733 + 39)))) then
			v109.DispellableDebuffs = v12.MergeTable(v109.DispellableDiseaseDebuffs, v109.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v114(v131)
		return v131:DebuffRemains(v99.JudgmentDebuff);
	end
	local function v115()
		return v14:BuffDown(v99.RetributionAura) and v14:BuffDown(v99.DevotionAura) and v14:BuffDown(v99.ConcentrationAura) and v14:BuffDown(v99.CrusaderAura);
	end
	local v116 = 0 - 0;
	local function v117()
		if ((v99.CleanseToxins:IsReady() and (v109.UnitHasDispellableDebuffByPlayer(v13) or v109.DispellableFriendlyUnit(1059 - (125 + 909)))) or ((6812 - (1096 + 852)) < (854 + 1048))) then
			local v141 = 0 - 0;
			while true do
				if (((4694 + 145) >= (4212 - (409 + 103))) and (v141 == (236 - (46 + 190)))) then
					if ((v116 == (95 - (51 + 44))) or ((304 + 771) > (3235 - (1114 + 203)))) then
						v116 = GetTime();
					end
					if (((1122 - (228 + 498)) <= (825 + 2979)) and v109.Wait(277 + 223, v116)) then
						if (v24(v101.CleanseToxinsFocus) or ((4832 - (174 + 489)) == (5697 - 3510))) then
							return "cleanse_toxins dispel";
						end
						v116 = 1905 - (830 + 1075);
					end
					break;
				end
			end
		end
	end
	local function v118()
		if (((1930 - (303 + 221)) == (2675 - (231 + 1038))) and v97 and (v14:HealthPercentage() <= v98)) then
			if (((1276 + 255) < (5433 - (171 + 991))) and v99.FlashofLight:IsReady()) then
				if (((2616 - 1981) == (1705 - 1070)) and v24(v99.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		while true do
			if (((2700 + 673) <= (12465 - 8909)) and (v132 == (2 - 1))) then
				v28 = v109.HandleBottomTrinket(v102, v31, 64 - 24, nil);
				if (v28 or ((10173 - 6882) < (4528 - (111 + 1137)))) then
					return v28;
				end
				break;
			end
			if (((4544 - (91 + 67)) >= (2598 - 1725)) and (v132 == (0 + 0))) then
				v28 = v109.HandleTopTrinket(v102, v31, 563 - (423 + 100), nil);
				if (((7 + 914) <= (3050 - 1948)) and v28) then
					return v28;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v120()
		if (((5477 - (326 + 445)) >= (4202 - 3239)) and (v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
			if (v24(v99.DivineShield) or ((2138 - 1178) <= (2044 - 1168))) then
				return "divine_shield defensive";
			end
		end
		if (((v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((2777 - (530 + 181)) == (1813 - (614 + 267)))) then
			if (((4857 - (19 + 13)) < (7881 - 3038)) and v24(v101.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) or ((9034 - 5157) >= (12960 - 8423))) then
			if (v24(v99.GuardianofAncientKings) or ((1121 + 3194) < (3034 - 1308))) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if ((v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) or ((7629 - 3950) < (2437 - (1293 + 519)))) then
			if (v24(v99.ArdentDefender) or ((9436 - 4811) < (1649 - 1017))) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((158 - 75) > (7675 - 5895))) then
			if (((1285 - 739) <= (571 + 506)) and ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (2 + 3)) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff))) then
				if (v24(v101.WordofGloryPlayer) or ((2313 - 1317) > (994 + 3307))) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((1353 + 2717) > (430 + 257)) and v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (1098 - (709 + 387))) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) then
			if (v24(v99.ShieldoftheRighteous) or ((2514 - (673 + 1185)) >= (9657 - 6327))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((8001 - 5509) <= (551 - 216))) then
			if (((3092 + 1230) >= (1915 + 647)) and v24(v101.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v92 and (v14:HealthPercentage() <= v94)) or ((4910 - 1273) >= (926 + 2844))) then
			local v142 = 0 - 0;
			while true do
				if ((v142 == (0 - 0)) or ((4259 - (446 + 1434)) > (5861 - (1040 + 243)))) then
					if ((v96 == "Refreshing Healing Potion") or ((1441 - 958) > (2590 - (559 + 1288)))) then
						if (((4385 - (609 + 1322)) > (1032 - (13 + 441))) and v100.RefreshingHealingPotion:IsReady()) then
							if (((3475 - 2545) < (11676 - 7218)) and v24(v101.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((3297 - 2635) <= (37 + 935)) and (v96 == "Dreamwalker's Healing Potion")) then
						if (((15870 - 11500) == (1553 + 2817)) and v100.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v101.RefreshingHealingPotion) or ((2087 + 2675) <= (2555 - 1694))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 - 0)) or ((934 + 478) == (2372 + 1892))) then
				if (v15:Exists() or ((2277 + 891) < (1808 + 345))) then
					if ((v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) or ((4869 + 107) < (1765 - (153 + 280)))) then
						if (((13363 - 8735) == (4156 + 472)) and v24(v101.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(12 + 18) or ((29 + 25) == (359 + 36))) then
					return;
				end
				v133 = 1 + 0;
			end
			if (((124 - 42) == (51 + 31)) and (v133 == (668 - (89 + 578)))) then
				if (v13 or ((416 + 165) < (585 - 303))) then
					local v210 = 1049 - (572 + 477);
					while true do
						if (((0 + 0) == v210) or ((2766 + 1843) < (298 + 2197))) then
							if (((1238 - (84 + 2)) == (1897 - 745)) and v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (3 + 0))) and (v13:HealthPercentage() <= v74)) then
								if (((2738 - (497 + 345)) <= (88 + 3334)) and v24(v101.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73) and v14:AffectingCombat()) or ((168 + 822) > (2953 - (605 + 728)))) then
								if (v24(v101.LayonHandsFocus) or ((626 + 251) > (10438 - 5743))) then
									return "lay_on_hands defensive focus";
								end
							end
							v210 = 1 + 0;
						end
						if (((9949 - 7258) >= (1669 + 182)) and (v210 == (2 - 1))) then
							if ((v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) or ((2254 + 731) >= (5345 - (457 + 32)))) then
								if (((1815 + 2461) >= (2597 - (832 + 570))) and v24(v101.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((3045 + 187) <= (1224 + 3466)) and v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) then
								if (v24(v101.BlessingofProtectionFocus) or ((3170 - 2274) >= (1516 + 1630))) then
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
	local function v122()
		if (((3857 - (588 + 208)) >= (7972 - 5014)) and (v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) then
			if (((4987 - (884 + 916)) >= (1347 - 703)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((374 + 270) <= (1357 - (232 + 421))) and (v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (1894 - (1569 + 320)))) then
			if (((236 + 722) > (180 + 767)) and v24(v99.ArcaneTorrent, not v16:IsInRange(26 - 18))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((5097 - (316 + 289)) >= (6947 - 4293)) and v99.Consecration:IsCastable() and v37) then
			if (((159 + 3283) >= (2956 - (666 + 787))) and v24(v99.Consecration, not v16:IsInRange(433 - (360 + 65)))) then
				return "consecration precombat 8";
			end
		end
		if ((v99.AvengersShield:IsCastable() and v35) or ((2963 + 207) <= (1718 - (79 + 175)))) then
			local v143 = 0 - 0;
			while true do
				if ((v143 == (0 + 0)) or ((14704 - 9907) == (8450 - 4062))) then
					if (((1450 - (503 + 396)) <= (862 - (92 + 89))) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(58 - 28)) then
						if (((1681 + 1596) > (241 + 166)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover precombat 10";
						end
					end
					if (((18386 - 13691) >= (194 + 1221)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
					break;
				end
			end
		end
		if ((v99.Judgment:IsReady() and v41) or ((7323 - 4111) <= (824 + 120))) then
			if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((1479 + 1617) <= (5475 - 3677))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v123()
		if (((442 + 3095) == (5393 - 1856)) and v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (1246 - (485 + 759))) and v14:HasTier(66 - 37, 1191 - (442 + 747))) then
			local v144 = 1135 - (832 + 303);
			while true do
				if (((4783 - (88 + 858)) >= (479 + 1091)) and ((0 + 0) == v144)) then
					if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(2 + 28)) or ((3739 - (766 + 23)) == (18818 - 15006))) then
						if (((6458 - 1735) >= (6107 - 3789)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((6879 - 4852) > (3925 - (1036 + 37)))) then
						return "avengers_shield cooldowns 2";
					end
					break;
				end
			end
		end
		if ((v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (2 + 0))) or ((2212 - 1076) > (3396 + 921))) then
			if (((6228 - (641 + 839)) == (5661 - (910 + 3))) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((9524 - 5788) <= (6424 - (1466 + 218))) and v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) then
			if (v24(v99.AvengingWrath, not v16:IsInRange(4 + 4)) or ((4538 - (556 + 592)) <= (1089 + 1971))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if ((v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) or ((1807 - (329 + 479)) > (3547 - (174 + 680)))) then
			if (((1590 - 1127) < (1245 - 644)) and v24(v99.Sentinel, not v16:IsInRange(6 + 2))) then
				return "sentinel cooldowns 8";
			end
		end
		local v134 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
		if (v134 or ((2922 - (396 + 343)) < (61 + 626))) then
			return v134;
		end
		if (((6026 - (29 + 1448)) == (5938 - (135 + 1254))) and v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (56 - 41)) or (((v9.CombatTime() > (46 - 36)) or (v99.Sentinel:CooldownRemains() > (10 + 5)) or (v99.AvengingWrath:CooldownRemains() > (1542 - (389 + 1138)))) and (v99.AvengersShield:CooldownRemains() > (574 - (102 + 472))) and (v99.Judgment:CooldownRemains() > (0 + 0)) and (v99.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (((4357 + 315) == (6217 - (320 + 1225))) and v24(v99.MomentOfGlory, not v16:IsInRange(14 - 6))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (2 + 1))) or ((5132 - (157 + 1307)) < (2254 - (821 + 1038)))) then
			if (v24(v99.DivineToll, not v16:IsInRange(74 - 44)) or ((456 + 3710) == (807 - 352))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (12 + 18)))) or ((11026 - 6577) == (3689 - (834 + 192)))) then
			if (v24(v99.BastionofLight, not v16:IsInRange(1 + 7)) or ((1098 + 3179) < (65 + 2924))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v124()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (304 - (300 + 4))) or ((233 + 637) >= (10860 - 6711))) then
				if (((2574 - (112 + 250)) < (1269 + 1914)) and v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (12 - 7))) then
					if (((2662 + 1984) > (1548 + 1444)) and v24(v99.Consecration, not v16:IsInRange(6 + 2))) then
						return "consecration standard 2";
					end
				end
				if (((712 + 722) < (2308 + 798)) and v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (1416 - (1001 + 413))) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (11 - 6)))) then
					if (((1668 - (244 + 638)) < (3716 - (627 + 66))) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and (v107 > (8 - 5)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (605 - (512 + 90))) and (v14:HolyPower() < (1909 - (1665 + 241)))) or ((3159 - (373 + 344)) < (34 + 40))) then
					if (((1200 + 3335) == (11962 - 7427)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 6";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((5091 - 2082) <= (3204 - (35 + 1064)))) then
						return "judgment standard 6";
					end
				end
				v135 = 1 + 0;
			end
			if (((3915 - 2085) < (15 + 3654)) and (v135 == (1239 - (298 + 938)))) then
				if ((v99.HammerofWrath:IsReady() and v40) or ((2689 - (233 + 1026)) >= (5278 - (636 + 1030)))) then
					if (((1372 + 1311) >= (2403 + 57)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v99.Judgment:IsReady() and v41) or ((536 + 1268) >= (222 + 3053))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((1638 - (55 + 166)) > (704 + 2925))) then
						return "judgment standard 22";
					end
					if (((483 + 4312) > (1535 - 1133)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 22";
					end
				end
				if (((5110 - (36 + 261)) > (6234 - 2669)) and v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (1373 - (34 + 1334))) or not v14:HasTier(12 + 19, 2 + 0))) then
					if (((5195 - (1035 + 248)) == (3933 - (20 + 1))) and v24(v99.Consecration, not v16:IsInRange(5 + 3))) then
						return "consecration standard 24";
					end
				end
				v135 = 323 - (134 + 185);
			end
			if (((3954 - (549 + 584)) <= (5509 - (314 + 371))) and ((6 - 4) == v135)) then
				if (((2706 - (478 + 490)) <= (1163 + 1032)) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (1174 - (786 + 386))) or v14:BuffUp(v99.MomentOfGloryBuff))) then
					if (((132 - 91) <= (4397 - (1055 + 324))) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(1370 - (1093 + 247))) then
						if (((1907 + 238) <= (432 + 3672)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 14";
						end
					end
					if (((10675 - 7986) < (16442 - 11597)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) or ((6607 - 4285) > (6588 - 3966))) then
					if (v24(v99.DivineToll, not v16:IsInRange(11 + 19)) or ((17466 - 12932) == (7176 - 5094))) then
						return "divine_toll standard 16";
					end
				end
				if ((v99.AvengersShield:IsCastable() and v35) or ((1185 + 386) > (4774 - 2907))) then
					if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(718 - (364 + 324))) or ((7275 - 4621) >= (7189 - 4193))) then
						if (((1319 + 2659) > (8803 - 6699)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 18";
						end
					end
					if (((4796 - 1801) > (4680 - 3139)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v135 = 1271 - (1249 + 19);
			end
			if (((2933 + 316) > (3709 - 2756)) and (v135 == (1087 - (686 + 400)))) then
				if ((v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(25 + 6, 231 - (73 + 156))) or ((16 + 3257) > (5384 - (721 + 90)))) then
					local v211 = 0 + 0;
					while true do
						if ((v211 == (0 - 0)) or ((3621 - (224 + 246)) < (2079 - 795))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((3406 - 1556) == (278 + 1251))) then
								return "judgment standard 8";
							end
							if (((20 + 801) < (1560 + 563)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if (((1792 - 890) < (7737 - 5412)) and v99.HammerofWrath:IsReady() and v40) then
					if (((1371 - (203 + 310)) <= (4955 - (1238 + 755))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (1 + 1)) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((5480 - (709 + 825)) < (2373 - 1085))) then
					local v212 = 0 - 0;
					while true do
						if ((v212 == (864 - (196 + 668))) or ((12800 - 9558) == (1174 - 607))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((1680 - (171 + 662)) >= (1356 - (4 + 89)))) then
								return "judgment standard 12";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((7896 - 5643) == (674 + 1177))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v135 = 8 - 6;
			end
			if ((v135 == (3 + 3)) or ((3573 - (35 + 1451)) > (3825 - (28 + 1425)))) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) or ((6438 - (941 + 1052)) < (3979 + 170))) then
					if (v24(v99.Consecration, not v16:IsInRange(1522 - (822 + 692))) or ((2595 - 777) == (41 + 44))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((927 - (45 + 252)) < (2105 + 22)) and (v135 == (2 + 2))) then
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (7 - 4))) or ((2371 - (114 + 319)) == (3609 - 1095))) then
					if (((5452 - 1197) >= (36 + 19)) and v24(v99.EyeofTyr, not v16:IsInRange(11 - 3))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((6283 - 3284) > (3119 - (556 + 1407))) and v99.BlessedHammer:IsCastable() and v36) then
					if (((3556 - (741 + 465)) > (1620 - (170 + 295))) and v24(v99.BlessedHammer, not v16:IsInRange(5 + 3))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((3701 + 328) <= (11948 - 7095)) and v99.HammeroftheRighteous:IsCastable() and v39) then
					if (v24(v99.HammeroftheRighteous, not v16:IsInRange(7 + 1)) or ((331 + 185) > (1945 + 1489))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v135 = 1235 - (957 + 273);
			end
			if (((1083 + 2963) >= (1215 + 1818)) and (v135 == (19 - 14))) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((7165 - 4446) <= (4419 - 2972))) then
					if (v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike)) or ((20470 - 16336) < (5706 - (389 + 1391)))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) or ((103 + 61) >= (290 + 2495))) then
					if (v24(v99.EyeofTyr, not v16:IsInRange(18 - 10)) or ((1476 - (783 + 168)) == (7078 - 4969))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((33 + 0) == (344 - (309 + 2))) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (15 - 10))) then
					if (((4266 - (1090 + 122)) <= (1302 + 2713)) and v24(v99.ArcaneTorrent, not v16:IsInRange(26 - 18))) then
						return "arcane_torrent standard 36";
					end
				end
				v135 = 5 + 1;
			end
		end
	end
	local function v125()
		local v136 = 1118 - (628 + 490);
		while true do
			if (((336 + 1535) < (8373 - 4991)) and (v136 == (9 - 7))) then
				v39 = EpicSettings.Settings['useHammeroftheRighteous'];
				v40 = EpicSettings.Settings['useHammerofWrath'];
				v41 = EpicSettings.Settings['useJudgment'];
				v136 = 777 - (431 + 343);
			end
			if (((2611 - 1318) <= (6265 - 4099)) and (v136 == (4 + 0))) then
				v45 = EpicSettings.Settings['useEyeofTyr'];
				v46 = EpicSettings.Settings['useMomentOfGlory'];
				v47 = EpicSettings.Settings['useSentinel'];
				v136 = 1 + 4;
			end
			if ((v136 == (1695 - (556 + 1139))) or ((2594 - (6 + 9)) < (23 + 100))) then
				v33 = EpicSettings.Settings['swapAuras'];
				v34 = EpicSettings.Settings['useWeapon'];
				v35 = EpicSettings.Settings['useAvengersShield'];
				v136 = 1 + 0;
			end
			if ((v136 == (170 - (28 + 141))) or ((328 + 518) >= (2922 - 554))) then
				v36 = EpicSettings.Settings['useBlessedHammer'];
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v136 = 2 + 0;
			end
			if ((v136 == (1323 - (486 + 831))) or ((10440 - 6428) <= (11822 - 8464))) then
				v51 = EpicSettings.Settings['eyeofTyrWithCD'];
				v52 = EpicSettings.Settings['momentOfGloryWithCD'];
				v53 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((283 + 1211) <= (9501 - 6496)) and ((1268 - (668 + 595)) == v136)) then
				v48 = EpicSettings.Settings['avengingWrathWithCD'];
				v49 = EpicSettings.Settings['bastionofLightWithCD'];
				v50 = EpicSettings.Settings['divineTollWithCD'];
				v136 = 6 + 0;
			end
			if ((v136 == (1 + 2)) or ((8483 - 5372) == (2424 - (23 + 267)))) then
				v42 = EpicSettings.Settings['useAvengingWrath'];
				v43 = EpicSettings.Settings['useBastionofLight'];
				v44 = EpicSettings.Settings['useDivineToll'];
				v136 = 1948 - (1129 + 815);
			end
		end
	end
	local function v126()
		local v137 = 387 - (371 + 16);
		while true do
			if (((4105 - (1326 + 424)) == (4459 - 2104)) and ((14 - 10) == v137)) then
				v70 = EpicSettings.Settings['layonHandsHP'];
				v71 = EpicSettings.Settings['wordofGloryHP'];
				v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v73 = EpicSettings.Settings['layOnHandsFocusHP'];
				v137 = 123 - (88 + 30);
			end
			if ((v137 == (772 - (720 + 51))) or ((1307 - 719) <= (2208 - (421 + 1355)))) then
				v58 = EpicSettings.Settings['useGuardianofAncientKings'];
				v59 = EpicSettings.Settings['useLayOnHands'];
				v60 = EpicSettings.Settings['useWordofGloryPlayer'];
				v61 = EpicSettings.Settings['useShieldoftheRighteous'];
				v137 = 2 - 0;
			end
			if (((2357 + 2440) >= (4978 - (286 + 797))) and ((10 - 7) == v137)) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['ardentDefenderHP'];
				v68 = EpicSettings.Settings['divineShieldHP'];
				v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v137 = 6 - 2;
			end
			if (((4016 - (397 + 42)) == (1118 + 2459)) and (v137 == (802 - (24 + 776)))) then
				v62 = EpicSettings.Settings['useLayOnHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v137 = 4 - 1;
			end
			if (((4579 - (222 + 563)) > (8136 - 4443)) and (v137 == (4 + 1))) then
				v74 = EpicSettings.Settings['wordofGloryFocusHP'];
				v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v137 = 196 - (23 + 167);
			end
			if ((v137 == (1804 - (690 + 1108))) or ((461 + 814) == (3382 + 718))) then
				v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v137 == (848 - (40 + 808))) or ((262 + 1329) >= (13689 - 10109))) then
				v54 = EpicSettings.Settings['useRebuke'];
				v55 = EpicSettings.Settings['useHammerofJustice'];
				v56 = EpicSettings.Settings['useArdentDefender'];
				v57 = EpicSettings.Settings['useDivineShield'];
				v137 = 1 + 0;
			end
		end
	end
	local function v127()
		local v138 = 0 + 0;
		while true do
			if (((540 + 443) <= (2379 - (47 + 524))) and (v138 == (4 + 2))) then
				v98 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if ((v138 == (0 - 0)) or ((4903 - 2753) <= (2923 - (1165 + 561)))) then
				v87 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v84 = EpicSettings.Settings['InterruptWithStun'];
				v85 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v138 = 3 - 2;
			end
			if (((1439 + 2330) >= (1652 - (341 + 138))) and (v138 == (2 + 2))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (326 - (89 + 237));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v138 = 16 - 11;
			end
			if (((3126 - 1641) == (2366 - (581 + 300))) and (v138 == (1221 - (855 + 365)))) then
				v86 = EpicSettings.Settings['InterruptThreshold'];
				v81 = EpicSettings.Settings['DispelDebuffs'];
				v80 = EpicSettings.Settings['DispelBuffs'];
				v138 = 4 - 2;
			end
			if ((v138 == (1 + 1)) or ((4550 - (1030 + 205)) <= (2612 + 170))) then
				v88 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v89 = EpicSettings.Settings['trinketsWithCD'];
				v138 = 3 + 0;
			end
			if (((291 - (156 + 130)) == v138) or ((1990 - 1114) >= (4995 - 2031))) then
				v82 = EpicSettings.Settings['handleAfflicted'];
				v83 = EpicSettings.Settings['HandleIncorporeal'];
				v97 = EpicSettings.Settings['HealOOC'];
				v138 = 11 - 5;
			end
			if ((v138 == (1 + 2)) or ((1302 + 930) > (2566 - (10 + 59)))) then
				v91 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v138 = 2 + 2;
			end
		end
	end
	local function v128()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (1164 - (671 + 492))) or ((1680 + 430) <= (1547 - (369 + 846)))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (((976 + 2710) > (2707 + 465)) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v105 = v14:GetEnemiesInMeleeRange(1953 - (1036 + 909));
				v106 = v14:GetEnemiesInRange(24 + 6);
				if (v30 or ((7511 - 3037) < (1023 - (11 + 192)))) then
					local v213 = 0 + 0;
					while true do
						if (((4454 - (135 + 40)) >= (6982 - 4100)) and (v213 == (0 + 0))) then
							v107 = #v105;
							v108 = #v106;
							break;
						end
					end
				else
					v107 = 2 - 1;
					v108 = 1 - 0;
				end
				v103 = v14:ActiveMitigationNeeded();
				v139 = 178 - (50 + 126);
			end
			if ((v139 == (13 - 8)) or ((450 + 1579) >= (4934 - (1233 + 180)))) then
				if ((v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((3006 - (522 + 447)) >= (6063 - (107 + 1314)))) then
					local v214 = 0 + 0;
					while true do
						if (((5241 - 3521) < (1894 + 2564)) and (v214 == (3 - 1))) then
							if (v24(v99.Pool) or ((1725 - 1289) > (4931 - (716 + 1194)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((13 + 700) <= (91 + 756)) and (v214 == (504 - (74 + 429)))) then
							v28 = v124();
							if (((4154 - 2000) <= (1998 + 2033)) and v28) then
								return v28;
							end
							v214 = 4 - 2;
						end
						if (((3266 + 1349) == (14227 - 9612)) and (v214 == (0 - 0))) then
							if ((v87 < v111) or ((4223 - (279 + 154)) == (1278 - (454 + 324)))) then
								local v222 = 0 + 0;
								while true do
									if (((106 - (12 + 5)) < (120 + 101)) and (v222 == (2 - 1))) then
										if (((760 + 1294) >= (2514 - (277 + 816))) and v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) then
											if (((2956 - 2264) < (4241 - (1058 + 125))) and v24(v101.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
									if ((v222 == (0 + 0)) or ((4229 - (815 + 160)) == (7101 - 5446))) then
										v28 = v123();
										if (v28 or ((3076 - 1780) == (1172 + 3738))) then
											return v28;
										end
										v222 = 2 - 1;
									end
								end
							end
							if (((5266 - (41 + 1857)) == (5261 - (1222 + 671))) and v88 and ((v31 and v89) or not v89) and v16:IsInRange(20 - 12)) then
								local v223 = 0 - 0;
								while true do
									if (((3825 - (229 + 953)) < (5589 - (1111 + 663))) and (v223 == (1579 - (874 + 705)))) then
										v28 = v119();
										if (((268 + 1645) > (337 + 156)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v214 = 1 - 0;
						end
					end
				end
				break;
			end
			if (((134 + 4621) > (4107 - (642 + 37))) and (v139 == (0 + 0))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v139 = 1 + 0;
			end
			if (((3467 - 2086) <= (2823 - (233 + 221))) and (v139 == (4 - 2))) then
				v104 = v14:IsTankingAoE(8 + 0) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((6384 - (718 + 823)) == (2570 + 1514))) then
					if (((5474 - (266 + 539)) > (1027 - 664)) and v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) then
						if (v24(v99.CrusaderAura) or ((3102 - (636 + 589)) >= (7448 - 4310))) then
							return "crusader_aura";
						end
					end
				end
				if (((9780 - 5038) >= (2874 + 752)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (v14:AffectingCombat() or ((1650 + 2890) == (1931 - (657 + 358)))) then
						if (v99.Intercession:IsCastable() or ((3060 - 1904) > (9899 - 5554))) then
							if (((3424 - (1151 + 36)) < (4104 + 145)) and v24(v99.Intercession, not v16:IsInRange(8 + 22), true)) then
								return "intercession target";
							end
						end
					elseif (v99.Redemption:IsCastable() or ((8012 - 5329) < (1855 - (1552 + 280)))) then
						if (((1531 - (64 + 770)) <= (561 + 265)) and v24(v99.Redemption, not v16:IsInRange(68 - 38), true)) then
							return "redemption target";
						end
					end
				end
				if (((197 + 908) <= (2419 - (157 + 1086))) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((6762 - 3383) <= (16695 - 12883)) and v24(v101.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((1208 - 420) >= (2204 - 588))) then
					if (((2673 - (599 + 220)) <= (6728 - 3349)) and v99.Intercession:IsCastable() and (v14:HolyPower() >= (1934 - (1813 + 118))) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (((3326 + 1223) == (5766 - (841 + 376))) and v24(v101.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((4233 - 1211) >= (703 + 2321))) then
					local v215 = 0 - 0;
					local v216;
					while true do
						if (((5679 - (464 + 395)) > (5640 - 3442)) and (v215 == (1 + 0))) then
							if (v28 or ((1898 - (467 + 370)) >= (10107 - 5216))) then
								return v28;
							end
							break;
						end
						if (((1002 + 362) <= (15333 - 10860)) and (v215 == (0 + 0))) then
							v216 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v216, nil, 46 - 26, nil, 545 - (150 + 370), v99.FlashofLight);
							v215 = 1283 - (74 + 1208);
						end
					end
				end
				v139 = 7 - 4;
			end
			if ((v139 == (14 - 11)) or ((2559 + 1036) <= (393 - (14 + 376)))) then
				if ((v32 and v81) or ((8103 - 3431) == (2493 + 1359))) then
					v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 36 + 4, 24 + 1, v99.FlashofLight);
					if (((4568 - 3009) == (1173 + 386)) and v28) then
						return v28;
					end
					if ((v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((1830 - (23 + 55)) <= (1867 - 1079))) then
						if (v24(v101.BlessingofFreedomFocus) or ((2608 + 1299) == (159 + 18))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((5380 - 1910) > (175 + 380)) and (v109.TargetIsValid() or v14:AffectingCombat())) then
					local v217 = 901 - (652 + 249);
					while true do
						if ((v217 == (2 - 1)) or ((2840 - (708 + 1160)) == (1750 - 1105))) then
							if (((5800 - 2618) >= (2142 - (10 + 17))) and (v111 == (2496 + 8615))) then
								v111 = v9.FightRemains(v105, false);
							end
							v112 = v14:HolyPower();
							break;
						end
						if (((5625 - (1400 + 332)) < (8494 - 4065)) and (v217 == (1908 - (242 + 1666)))) then
							v110 = v9.BossFightRemains(nil, true);
							v111 = v110;
							v217 = 1 + 0;
						end
					end
				end
				if (not v14:AffectingCombat() or ((1051 + 1816) < (1624 + 281))) then
					if ((v99.DevotionAura:IsCastable() and (v115()) and v33) or ((2736 - (850 + 90)) >= (7094 - 3043))) then
						if (((3009 - (360 + 1030)) <= (3324 + 432)) and v24(v99.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (((1704 - 1100) == (830 - 226)) and v82) then
					if (v78 or ((6145 - (909 + 752)) == (2123 - (109 + 1114)))) then
						v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 73 - 33);
						if (v28 or ((1736 + 2723) <= (1355 - (6 + 236)))) then
							return v28;
						end
					end
					if (((2289 + 1343) > (2736 + 662)) and v14:BuffUp(v99.ShiningLightFreeBuff) and v79) then
						v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 94 - 54, true);
						if (((7129 - 3047) <= (6050 - (1076 + 57))) and v28) then
							return v28;
						end
					end
				end
				if (((795 + 4037) >= (2075 - (579 + 110))) and v83) then
					local v218 = 0 + 0;
					while true do
						if (((122 + 15) == (73 + 64)) and (v218 == (407 - (174 + 233)))) then
							v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 83 - 53, true);
							if (v28 or ((2755 - 1185) >= (1927 + 2405))) then
								return v28;
							end
							v218 = 1175 - (663 + 511);
						end
						if ((v218 == (1 + 0)) or ((883 + 3181) <= (5607 - 3788))) then
							v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 19 + 11, true);
							if (v28 or ((11738 - 6752) < (3810 - 2236))) then
								return v28;
							end
							break;
						end
					end
				end
				v28 = v118();
				v139 = 2 + 2;
			end
			if (((8614 - 4188) > (123 + 49)) and (v139 == (1 + 3))) then
				if (((1308 - (478 + 244)) > (972 - (440 + 77))) and v28) then
					return v28;
				end
				if (((376 + 450) == (3022 - 2196)) and v81 and v32) then
					local v219 = 1556 - (655 + 901);
					while true do
						if ((v219 == (0 + 0)) or ((3077 + 942) > (2999 + 1442))) then
							if (((8125 - 6108) < (5706 - (695 + 750))) and v13) then
								v28 = v117();
								if (((16103 - 11387) > (123 - 43)) and v28) then
									return v28;
								end
							end
							if ((v15 and v15:Exists() and not v14:CanAttack(v15) and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15))) or ((14104 - 10597) == (3623 - (285 + 66)))) then
								if (v99.CleanseToxins:IsReady() or ((2041 - 1165) >= (4385 - (682 + 628)))) then
									if (((702 + 3650) > (2853 - (176 + 123))) and v24(v101.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v121();
				if (v28 or ((1843 + 2563) < (2933 + 1110))) then
					return v28;
				end
				if (v104 or ((2158 - (239 + 30)) >= (920 + 2463))) then
					local v220 = 0 + 0;
					while true do
						if (((3348 - 1456) <= (8529 - 5795)) and (v220 == (315 - (306 + 9)))) then
							v28 = v120();
							if (((6710 - 4787) < (386 + 1832)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((1334 + 839) > (183 + 196)) and v109.TargetIsValid() and not v14:AffectingCombat() and v29) then
					local v221 = 0 - 0;
					while true do
						if ((v221 == (1375 - (1140 + 235))) or ((1649 + 942) == (3127 + 282))) then
							v28 = v122();
							if (((1159 + 3355) > (3376 - (33 + 19))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v139 = 2 + 3;
			end
		end
	end
	local function v129()
		v20.Print("Protection Paladin by Epic. Supported by xKaneto");
		v113();
	end
	v20.SetAPL(197 - 131, v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

