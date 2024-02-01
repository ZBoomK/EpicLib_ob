local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1958 - (765 + 135)) >= (2603 - 1401))) then
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
	local v108 = 4940 + 6171;
	local v109 = 10682 + 429;
	local v110 = 47 - (20 + 27);
	v9:RegisterForEvent(function()
		local v128 = 287 - (50 + 237);
		while true do
			if (((2118 + 1593) > (5446 - 2091)) and (v128 == (0 + 0))) then
				v108 = 46975 - 35864;
				v109 = 12604 - (711 + 782);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		if (v97.CleanseToxins:IsAvailable() or ((1736 - 830) >= (2698 - (270 + 199)))) then
			v107.DispellableDebuffs = v12.MergeTable(v107.DispellableDiseaseDebuffs, v107.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v111();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v112(v129)
		return v129:DebuffRemains(v97.JudgmentDebuff);
	end
	local function v113()
		return v14:BuffDown(v97.RetributionAura) and v14:BuffDown(v97.DevotionAura) and v14:BuffDown(v97.ConcentrationAura) and v14:BuffDown(v97.CrusaderAura);
	end
	local v114 = 0 + 0;
	local function v115()
		if (((3107 - (580 + 1239)) > (3718 - 2467)) and v97.CleanseToxins:IsReady() and v107.DispellableFriendlyUnit(24 + 1)) then
			if ((v114 == (0 + 0)) or ((1966 + 2547) < (8751 - 5399))) then
				v114 = GetTime();
			end
			if (v107.Wait(311 + 189, v114) or ((3232 - (645 + 522)) >= (4986 - (1010 + 780)))) then
				local v203 = 0 + 0;
				while true do
					if ((v203 == (0 - 0)) or ((12823 - 8447) <= (3317 - (1045 + 791)))) then
						if (v24(v99.CleanseToxinsFocus) or ((8585 - 5193) >= (7238 - 2497))) then
							return "cleanse_toxins dispel";
						end
						v114 = 505 - (351 + 154);
						break;
					end
				end
			end
		end
	end
	local function v116()
		if (((4899 - (1281 + 293)) >= (2420 - (28 + 238))) and v95 and (v14:HealthPercentage() <= v96)) then
			if (v97.FlashofLight:IsReady() or ((2893 - 1598) >= (4792 - (1381 + 178)))) then
				if (((4106 + 271) > (1325 + 317)) and v24(v97.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v117()
		local v130 = 0 + 0;
		while true do
			if (((16282 - 11559) > (703 + 653)) and (v130 == (471 - (381 + 89)))) then
				v28 = v107.HandleBottomTrinket(v100, v31, 36 + 4, nil);
				if (v28 or ((2798 + 1338) <= (5880 - 2447))) then
					return v28;
				end
				break;
			end
			if (((5401 - (1074 + 82)) <= (10148 - 5517)) and (v130 == (1784 - (214 + 1570)))) then
				v28 = v107.HandleTopTrinket(v100, v31, 1495 - (990 + 465), nil);
				if (((1763 + 2513) >= (1704 + 2210)) and v28) then
					return v28;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v118()
		local v131 = 0 - 0;
		while true do
			if (((1924 - (1668 + 58)) <= (4991 - (512 + 114))) and (v131 == (7 - 4))) then
				if (((9885 - 5103) > (16270 - 11594)) and v98.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) then
					if (((2263 + 2601) > (412 + 1785)) and v24(v99.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v90 and (v14:HealthPercentage() <= v92)) or ((3217 + 483) == (8455 - 5948))) then
					if (((6468 - (109 + 1885)) >= (1743 - (1269 + 200))) and (v94 == "Refreshing Healing Potion")) then
						if (v98.RefreshingHealingPotion:IsReady() or ((3629 - 1735) <= (2221 - (98 + 717)))) then
							if (((2398 - (802 + 24)) >= (2639 - 1108)) and v24(v99.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v94 == "Dreamwalker's Healing Potion") or ((5919 - 1232) < (671 + 3871))) then
						if (((2529 + 762) > (274 + 1393)) and v98.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v99.RefreshingHealingPotion) or ((189 + 684) == (5658 - 3624))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v131 == (6 - 4)) or ((1008 + 1808) < (5 + 6))) then
				if (((3052 + 647) < (3422 + 1284)) and v97.WordofGlory:IsReady() and (v14:HealthPercentage() <= v69) and v58 and not v14:HealingAbsorbed()) then
					if (((1236 + 1410) >= (2309 - (797 + 636))) and ((v14:BuffRemains(v97.ShieldoftheRighteousBuff) >= (24 - 19)) or v14:BuffUp(v97.DivinePurposeBuff) or v14:BuffUp(v97.ShiningLightFreeBuff))) then
						if (((2233 - (1427 + 192)) <= (1104 + 2080)) and v24(v99.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((7257 - 4131) == (2810 + 316)) and v97.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (1 + 1)) and v14:BuffRefreshable(v97.ShieldoftheRighteousBuff) and v59 and (v101 or (v14:HealthPercentage() <= v70))) then
					if (v24(v97.ShieldoftheRighteous) or ((2513 - (192 + 134)) >= (6230 - (316 + 960)))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v131 = 2 + 1;
			end
			if ((v131 == (1 + 0)) or ((3584 + 293) == (13667 - 10092))) then
				if (((1258 - (83 + 468)) > (2438 - (1202 + 604))) and v97.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v97.ArdentDefenderBuff)) then
					if (v24(v97.GuardianofAncientKings) or ((2548 - 2002) >= (4466 - 1782))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if (((4056 - 2591) <= (4626 - (45 + 280))) and v97.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v65) and v54 and v14:BuffDown(v97.GuardianofAncientKingsBuff)) then
					if (((1645 + 59) > (1245 + 180)) and v24(v97.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v131 = 1 + 1;
			end
			if ((v131 == (0 + 0)) or ((121 + 566) == (7839 - 3605))) then
				if (((v14:HealthPercentage() <= v66) and v55 and v97.DivineShield:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((5241 - (340 + 1571)) < (564 + 865))) then
					if (((2919 - (1733 + 39)) >= (920 - 585)) and v24(v97.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((4469 - (125 + 909)) > (4045 - (1096 + 852))) and (v14:HealthPercentage() <= v68) and v57 and v97.LayonHands:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) then
					if (v24(v99.LayonHandsPlayer) or ((1692 + 2078) >= (5770 - 1729))) then
						return "lay_on_hands defensive 2";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v119()
		if (v15:Exists() or ((4303 - (409 + 103)) <= (1847 - (46 + 190)))) then
			if ((v97.WordofGlory:IsReady() and v62 and (v15:HealthPercentage() <= v73)) or ((4673 - (51 + 44)) <= (567 + 1441))) then
				if (((2442 - (1114 + 203)) <= (2802 - (228 + 498))) and v24(v99.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v13 or not v13:Exists() or not v13:IsInRange(7 + 23) or ((411 + 332) >= (5062 - (174 + 489)))) then
			return;
		end
		if (((3008 - 1853) < (3578 - (830 + 1075))) and v13) then
			if ((v97.WordofGlory:IsReady() and v61 and v14:BuffUp(v97.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v72)) or ((2848 - (303 + 221)) <= (1847 - (231 + 1038)))) then
				if (((3140 + 627) == (4929 - (171 + 991))) and v24(v99.WordofGloryFocus)) then
					return "word_of_glory defensive focus";
				end
			end
			if (((16851 - 12762) == (10979 - 6890)) and v97.LayonHands:IsCastable() and v60 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v71)) then
				if (((11124 - 6666) >= (1340 + 334)) and v24(v99.LayonHandsFocus)) then
					return "lay_on_hands defensive focus";
				end
			end
			if (((3407 - 2435) <= (4090 - 2672)) and v97.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) then
				if (v24(v99.BlessingofSacrificeFocus) or ((7959 - 3021) < (14720 - 9958))) then
					return "blessing_of_sacrifice defensive focus";
				end
			end
			if ((v97.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) or ((3752 - (111 + 1137)) > (4422 - (91 + 67)))) then
				if (((6407 - 4254) == (538 + 1615)) and v24(v99.BlessingofProtectionFocus)) then
					return "blessing_of_protection defensive focus";
				end
			end
		end
	end
	local function v120()
		local v132 = 523 - (423 + 100);
		while true do
			if ((v132 == (1 + 1)) or ((1403 - 896) >= (1351 + 1240))) then
				if (((5252 - (326 + 445)) == (19554 - 15073)) and v97.Judgment:IsReady() and v39) then
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((5186 - 2858) < (1616 - 923))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((5039 - (530 + 181)) == (5209 - (614 + 267))) and (v132 == (32 - (19 + 13)))) then
				if (((2584 - 996) >= (3103 - 1771)) and (v85 < v109) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89)) then
					if (v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment)) or ((11923 - 7749) > (1104 + 3144))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v85 < v109) and v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (8 - 3))) or ((9510 - 4924) <= (1894 - (1293 + 519)))) then
					if (((7881 - 4018) == (10085 - 6222)) and v24(v97.ArcaneTorrent, not v16:IsInRange(14 - 6))) then
						return "arcane_torrent precombat 6";
					end
				end
				v132 = 4 - 3;
			end
			if (((2 - 1) == v132) or ((150 + 132) <= (9 + 33))) then
				if (((10708 - 6099) >= (178 + 588)) and v97.Consecration:IsCastable() and v35) then
					if (v24(v97.Consecration, not v16:IsInRange(3 + 5)) or ((720 + 432) == (3584 - (709 + 387)))) then
						return "consecration";
					end
				end
				if (((5280 - (673 + 1185)) > (9715 - 6365)) and v97.AvengersShield:IsCastable() and v33) then
					if (((2815 - 1938) > (618 - 242)) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v132 = 2 + 0;
			end
		end
	end
	local function v121()
		if ((v97.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (2 + 0)) and v14:HasTier(38 - 9, 1 + 1)) or ((6216 - 3098) <= (3633 - 1782))) then
			if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((2045 - (446 + 1434)) >= (4775 - (1040 + 243)))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((11786 - 7837) < (6703 - (559 + 1288))) and v97.LightsJudgment:IsCastable() and v88 and ((v89 and v31) or not v89) and (v106 >= (1933 - (609 + 1322)))) then
			if (v24(v97.LightsJudgment, not v16:IsSpellInRange(v97.LightsJudgment)) or ((4730 - (13 + 441)) < (11270 - 8254))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((12284 - 7594) > (20544 - 16419)) and v97.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) then
			if (v24(v97.AvengingWrath, not v16:IsInRange(1 + 7)) or ((181 - 131) >= (319 + 577))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if ((v97.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) or ((752 + 962) >= (8777 - 5819))) then
			if (v24(v97.Sentinel, not v16:IsInRange(5 + 3)) or ((2742 - 1251) < (426 + 218))) then
				return "sentinel cooldowns 8";
			end
		end
		local v133 = v107.HandleDPSPotion(v14:BuffUp(v97.AvengingWrathBuff));
		if (((392 + 312) < (710 + 277)) and v133) then
			return v133;
		end
		if (((3122 + 596) > (1865 + 41)) and v97.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v97.SentinelBuff) < (448 - (153 + 280))) or (((v9.CombatTime() > (28 - 18)) or (v97.Sentinel:CooldownRemains() > (14 + 1)) or (v97.AvengingWrath:CooldownRemains() > (6 + 9))) and (v97.AvengersShield:CooldownRemains() > (0 + 0)) and (v97.Judgment:CooldownRemains() > (0 + 0)) and (v97.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (v24(v97.MomentofGlory, not v16:IsInRange(11 - 3)) or ((593 + 365) > (4302 - (89 + 578)))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((2501 + 1000) <= (9338 - 4846)) and v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady() and (v105 >= (1052 - (572 + 477)))) then
			if (v24(v97.DivineToll, not v16:IsInRange(5 + 25)) or ((2066 + 1376) < (305 + 2243))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((2961 - (84 + 2)) >= (2412 - 948)) and v97.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v97.AvengingWrathBuff) or (v97.AvengingWrath:CooldownRemains() <= (22 + 8)))) then
			if (v24(v97.BastionofLight, not v16:IsInRange(850 - (497 + 345))) or ((123 + 4674) >= (828 + 4065))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v122()
		if ((v97.Consecration:IsCastable() and v35 and (v14:BuffStack(v97.SanctificationBuff) == (1338 - (605 + 728)))) or ((394 + 157) > (4597 - 2529))) then
			if (((97 + 2017) > (3490 - 2546)) and v24(v97.Consecration, not v16:IsInRange(8 + 0))) then
				return "consecration standard 2";
			end
		end
		if ((v97.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (5 - 3)) or v14:BuffUp(v97.BastionofLightBuff) or v14:BuffUp(v97.DivinePurposeBuff)) and (v14:BuffDown(v97.SanctificationBuff) or (v14:BuffStack(v97.SanctificationBuff) < (4 + 1)))) or ((2751 - (457 + 32)) >= (1314 + 1782))) then
			if (v24(v97.ShieldoftheRighteous) or ((3657 - (832 + 570)) >= (3333 + 204))) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if ((v97.Judgment:IsReady() and v39 and (v105 > (1 + 2)) and (v14:BuffStack(v97.BulwarkofRighteousFuryBuff) >= (10 - 7)) and (v14:HolyPower() < (2 + 1))) or ((4633 - (588 + 208)) < (3519 - 2213))) then
			if (((4750 - (884 + 916)) == (6176 - 3226)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 6";
			end
			if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2739 + 1984) < (3951 - (232 + 421)))) then
				return "judgment standard 6";
			end
		end
		if (((3025 - (1569 + 320)) >= (38 + 116)) and v97.Judgment:IsReady() and v39 and v14:BuffDown(v97.SanctificationEmpowerBuff) and v14:HasTier(6 + 25, 6 - 4)) then
			local v158 = 605 - (316 + 289);
			while true do
				if (((0 - 0) == v158) or ((13 + 258) > (6201 - (666 + 787)))) then
					if (((5165 - (360 + 65)) >= (2946 + 206)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment standard 8";
					end
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2832 - (79 + 175)) >= (5345 - 1955))) then
						return "judgment standard 8";
					end
					break;
				end
			end
		end
		if (((32 + 9) <= (5091 - 3430)) and v97.HammerofWrath:IsReady() and v38) then
			if (((1157 - 556) < (4459 - (503 + 396))) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((416 - (92 + 89)) < (1332 - 645)) and v97.Judgment:IsReady() and v39 and ((v97.Judgment:Charges() >= (2 + 0)) or (v97.Judgment:FullRechargeTime() <= v14:GCD()))) then
			if (((2693 + 1856) > (4515 - 3362)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 12";
			end
			if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((640 + 4034) < (10652 - 5980))) then
				return "judgment standard 12";
			end
		end
		if (((3201 + 467) < (2179 + 2382)) and v97.AvengersShield:IsCastable() and v33 and ((v106 > (5 - 3)) or v14:BuffUp(v97.MomentofGloryBuff))) then
			if (v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield)) or ((57 + 398) == (5497 - 1892))) then
				return "avengers_shield standard 14";
			end
		end
		if ((v42 and ((v48 and v31) or not v48) and v97.DivineToll:IsReady()) or ((3907 - (485 + 759)) == (7663 - 4351))) then
			if (((5466 - (442 + 747)) <= (5610 - (832 + 303))) and v24(v97.DivineToll, not v16:IsInRange(976 - (88 + 858)))) then
				return "divine_toll standard 16";
			end
		end
		if ((v97.AvengersShield:IsCastable() and v33) or ((266 + 604) == (985 + 204))) then
			if (((64 + 1489) <= (3922 - (766 + 23))) and v24(v97.AvengersShield, not v16:IsSpellInRange(v97.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if ((v97.HammerofWrath:IsReady() and v38) or ((11043 - 8806) >= (4801 - 1290))) then
			if (v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath)) or ((3488 - 2164) > (10249 - 7229))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if ((v97.Judgment:IsReady() and v39) or ((4065 - (1036 + 37)) == (1334 + 547))) then
			if (((6048 - 2942) > (1201 + 325)) and v107.CastCycle(v97.Judgment, v103, v112, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 22";
			end
			if (((4503 - (641 + 839)) < (4783 - (910 + 3))) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
				return "judgment standard 22";
			end
		end
		if (((364 - 221) > (1758 - (1466 + 218))) and v97.Consecration:IsCastable() and v35 and v14:BuffDown(v97.ConsecrationBuff) and ((v14:BuffStack(v97.SanctificationBuff) < (3 + 2)) or not v14:HasTier(1179 - (556 + 592), 1 + 1))) then
			if (((826 - (329 + 479)) < (2966 - (174 + 680))) and v24(v97.Consecration, not v16:IsInRange(27 - 19))) then
				return "consecration standard 24";
			end
		end
		if (((2273 - 1176) <= (1163 + 465)) and (v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and v97.InmostLight:IsAvailable() and (v105 >= (742 - (396 + 343)))) then
			if (((410 + 4220) == (6107 - (29 + 1448))) and v24(v97.EyeofTyr, not v16:IsInRange(1397 - (135 + 1254)))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((13335 - 9795) > (12527 - 9844)) and v97.BlessedHammer:IsCastable() and v34) then
			if (((3195 + 1599) >= (4802 - (389 + 1138))) and v24(v97.BlessedHammer, not v16:IsInRange(582 - (102 + 472)))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((1401 + 83) == (823 + 661)) and v97.HammeroftheRighteous:IsCastable() and v37) then
			if (((1336 + 96) < (5100 - (320 + 1225))) and v24(v97.HammeroftheRighteous, not v16:IsInRange(14 - 6))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if ((v97.CrusaderStrike:IsCastable() and v36) or ((652 + 413) > (5042 - (157 + 1307)))) then
			if (v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike)) or ((6654 - (821 + 1038)) < (3510 - 2103))) then
				return "crusader_strike standard 32";
			end
		end
		if (((203 + 1650) < (8548 - 3735)) and (v85 < v109) and v43 and ((v49 and v31) or not v49) and v97.EyeofTyr:IsCastable() and not v97.InmostLight:IsAvailable()) then
			if (v24(v97.EyeofTyr, not v16:IsInRange(3 + 5)) or ((6991 - 4170) < (3457 - (834 + 192)))) then
				return "eye_of_tyr standard 34";
			end
		end
		if ((v97.ArcaneTorrent:IsCastable() and v88 and ((v89 and v31) or not v89) and (v110 < (1 + 4))) or ((738 + 2136) < (47 + 2134))) then
			if (v24(v97.ArcaneTorrent, not v16:IsInRange(12 - 4)) or ((2993 - (300 + 4)) <= (92 + 251))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v97.Consecration:IsCastable() and v35 and (v14:BuffDown(v97.SanctificationEmpowerBuff))) or ((4892 - 3023) == (2371 - (112 + 250)))) then
			if (v24(v97.Consecration, not v16:IsInRange(4 + 4)) or ((8883 - 5337) < (1331 + 991))) then
				return "consecration standard 38";
			end
		end
	end
	local function v123()
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
	local function v124()
		local v153 = 0 + 0;
		while true do
			if ((v153 == (2 + 0)) or ((1033 + 1049) == (3546 + 1227))) then
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v153 = 1417 - (1001 + 413);
			end
			if (((7233 - 3989) > (1937 - (244 + 638))) and (v153 == (699 - (627 + 66)))) then
				v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v71 = EpicSettings.Settings['layOnHandsFocusHP'];
				v72 = EpicSettings.Settings['wordofGloryFocusHP'];
				v153 = 20 - 13;
			end
			if ((v153 == (602 - (512 + 90))) or ((5219 - (1665 + 241)) <= (2495 - (373 + 344)))) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v153 = 1 + 0;
			end
			if ((v153 == (2 + 2)) or ((3748 - 2327) >= (3560 - 1456))) then
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v65 = EpicSettings.Settings['ardentDefenderHP'];
				v66 = EpicSettings.Settings['divineShieldHP'];
				v153 = 1104 - (35 + 1064);
			end
			if (((1319 + 493) <= (6950 - 3701)) and ((1 + 2) == v153)) then
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useWordofGloryMouseover'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v153 = 1240 - (298 + 938);
			end
			if (((2882 - (233 + 1026)) <= (3623 - (636 + 1030))) and ((3 + 2) == v153)) then
				v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v68 = EpicSettings.Settings['layonHandsHP'];
				v69 = EpicSettings.Settings['wordofGloryHP'];
				v153 = 6 + 0;
			end
			if (((1311 + 3101) == (299 + 4113)) and (v153 == (222 - (55 + 166)))) then
				v55 = EpicSettings.Settings['useDivineShield'];
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v153 = 1 + 1;
			end
			if (((176 + 1574) >= (3215 - 2373)) and (v153 == (305 - (36 + 261)))) then
				v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((7645 - 3273) > (3218 - (34 + 1334))) and (v153 == (3 + 4))) then
				v73 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v74 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v153 = 7 + 1;
			end
		end
	end
	local function v125()
		local v154 = 1283 - (1035 + 248);
		while true do
			if (((253 - (20 + 1)) < (428 + 393)) and (v154 == (320 - (134 + 185)))) then
				v84 = EpicSettings.Settings['InterruptThreshold'];
				v79 = EpicSettings.Settings['DispelDebuffs'];
				v78 = EpicSettings.Settings['DispelBuffs'];
				v154 = 1135 - (549 + 584);
			end
			if (((1203 - (314 + 371)) < (3096 - 2194)) and (v154 == (974 - (478 + 490)))) then
				v96 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
			if (((4166 - (786 + 386)) > (2778 - 1920)) and (v154 == (1379 - (1055 + 324)))) then
				v85 = EpicSettings.Settings['fightRemainsCheck'] or (1340 - (1093 + 247));
				v82 = EpicSettings.Settings['InterruptWithStun'];
				v83 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v154 = 1 + 0;
			end
			if ((v154 == (1 + 2)) or ((14908 - 11153) <= (3105 - 2190))) then
				v89 = EpicSettings.Settings['racialsWithCD'];
				v91 = EpicSettings.Settings['useHealthstone'];
				v90 = EpicSettings.Settings['useHealingPotion'];
				v154 = 10 - 6;
			end
			if (((9915 - 5969) > (1332 + 2411)) and (v154 == (15 - 11))) then
				v93 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v92 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v94 = EpicSettings.Settings['HealingPotionName'] or "";
				v154 = 12 - 7;
			end
			if ((v154 == (690 - (364 + 324))) or ((3659 - 2324) >= (7932 - 4626))) then
				v86 = EpicSettings.Settings['useTrinkets'];
				v88 = EpicSettings.Settings['useRacials'];
				v87 = EpicSettings.Settings['trinketsWithCD'];
				v154 = 1 + 2;
			end
			if (((20268 - 15424) > (3608 - 1355)) and (v154 == (15 - 10))) then
				v80 = EpicSettings.Settings['handleAfflicted'];
				v81 = EpicSettings.Settings['HandleIncorporeal'];
				v95 = EpicSettings.Settings['HealOOC'];
				v154 = 1274 - (1249 + 19);
			end
		end
	end
	local function v126()
		local v155 = 0 + 0;
		while true do
			if (((1759 - 1307) == (1538 - (686 + 400))) and (v155 == (3 + 0))) then
				v104 = v14:GetEnemiesInRange(259 - (73 + 156));
				if (v30 or ((22 + 4535) < (2898 - (721 + 90)))) then
					v105 = #v103;
					v106 = #v104;
				else
					v105 = 1 + 0;
					v106 = 3 - 2;
				end
				v101 = v14:ActiveMitigationNeeded();
				v155 = 474 - (224 + 246);
			end
			if (((6275 - 2401) == (7132 - 3258)) and (v155 == (1 + 0))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v155 = 1 + 1;
			end
			if ((v155 == (6 + 2)) or ((3852 - 1914) > (16422 - 11487))) then
				if (v28 or ((4768 - (203 + 310)) < (5416 - (1238 + 755)))) then
					return v28;
				end
				if (((102 + 1352) <= (4025 - (709 + 825))) and v79 and v32) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (0 - 0)) or ((5021 - (196 + 668)) <= (11066 - 8263))) then
							if (((10052 - 5199) >= (3815 - (171 + 662))) and v13) then
								v28 = v115();
								if (((4227 - (4 + 89)) > (11766 - 8409)) and v28) then
									return v28;
								end
							end
							if ((v15 and v15:Exists() and v15:IsAPlayer() and (v107.UnitHasCurseDebuff(v15) or v107.UnitHasPoisonDebuff(v15))) or ((1245 + 2172) < (11129 - 8595))) then
								if (v97.CleanseToxins:IsReady() or ((1068 + 1654) <= (1650 - (35 + 1451)))) then
									if (v24(v99.CleanseToxinsMouseover) or ((3861 - (28 + 1425)) < (4102 - (941 + 1052)))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v119();
				v155 = 9 + 0;
			end
			if ((v155 == (1516 - (822 + 692))) or ((46 - 13) == (686 + 769))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((740 - (45 + 252)) >= (3973 + 42))) then
					return v28;
				end
				v103 = v14:GetEnemiesInMeleeRange(3 + 5);
				v155 = 7 - 4;
			end
			if (((3815 - (114 + 319)) > (237 - 71)) and (v155 == (6 - 1))) then
				if ((v97.Redemption:IsCastable() and v97.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((179 + 101) == (4556 - 1497))) then
					if (((3941 - 2060) > (3256 - (556 + 1407))) and v24(v99.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((3563 - (741 + 465)) == (2822 - (170 + 295))) and v14:AffectingCombat()) then
					if (((65 + 58) == (113 + 10)) and v97.Intercession:IsCastable() and (v14:HolyPower() >= (7 - 4)) and v97.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (v24(v99.IntercessionMouseover) or ((876 + 180) >= (2176 + 1216))) then
							return "Intercession";
						end
					end
				end
				if (v14:AffectingCombat() or (v79 and v97.CleanseToxins:IsAvailable()) or ((613 + 468) < (2305 - (957 + 273)))) then
					local v205 = v79 and v97.CleanseToxins:IsReady() and v32;
					v28 = v107.FocusUnit(v205, v99, 6 + 14, nil, 11 + 14);
					if (v28 or ((3997 - 2948) >= (11679 - 7247))) then
						return v28;
					end
				end
				v155 = 18 - 12;
			end
			if ((v155 == (34 - 27)) or ((6548 - (389 + 1391)) <= (531 + 315))) then
				if (v80 or ((350 + 3008) <= (3232 - 1812))) then
					if (v76 or ((4690 - (783 + 168)) <= (10085 - 7080))) then
						local v208 = 0 + 0;
						while true do
							if (((311 - (309 + 2)) == v208) or ((5094 - 3435) >= (3346 - (1090 + 122)))) then
								v28 = v107.HandleAfflicted(v97.CleanseToxins, v99.CleanseToxinsMouseover, 13 + 27);
								if (v28 or ((10948 - 7688) < (1612 + 743))) then
									return v28;
								end
								break;
							end
						end
					end
					if ((v14:BuffUp(v97.ShiningLightFreeBuff) and v77) or ((1787 - (628 + 490)) == (758 + 3465))) then
						local v209 = 0 - 0;
						while true do
							if (((0 - 0) == v209) or ((2466 - (431 + 343)) < (1187 - 599))) then
								v28 = v107.HandleAfflicted(v97.WordofGlory, v99.WordofGloryMouseover, 115 - 75, true);
								if (v28 or ((3790 + 1007) < (467 + 3184))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (v81 or ((5872 - (556 + 1139)) > (4865 - (6 + 9)))) then
					local v206 = 0 + 0;
					while true do
						if ((v206 == (0 + 0)) or ((569 - (28 + 141)) > (431 + 680))) then
							v28 = v107.HandleIncorporeal(v97.Repentance, v99.RepentanceMouseOver, 37 - 7, true);
							if (((2161 + 890) > (2322 - (486 + 831))) and v28) then
								return v28;
							end
							v206 = 2 - 1;
						end
						if (((13001 - 9308) <= (829 + 3553)) and (v206 == (3 - 2))) then
							v28 = v107.HandleIncorporeal(v97.TurnEvil, v99.TurnEvilMouseOver, 1293 - (668 + 595), true);
							if (v28 or ((2954 + 328) > (827 + 3273))) then
								return v28;
							end
							break;
						end
					end
				end
				v28 = v116();
				v155 = 21 - 13;
			end
			if ((v155 == (296 - (23 + 267))) or ((5524 - (1129 + 815)) < (3231 - (371 + 16)))) then
				if (((1839 - (1326 + 424)) < (8503 - 4013)) and v32 and v79) then
					v28 = v107.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 146 - 106, 143 - (88 + 30));
					if (v28 or ((5754 - (720 + 51)) < (4021 - 2213))) then
						return v28;
					end
					if (((5605 - (421 + 1355)) > (6217 - 2448)) and v97.BlessingofFreedom:IsReady() and v107.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
						if (((730 + 755) <= (3987 - (286 + 797))) and v24(v99.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((15605 - 11336) == (7070 - 2801)) and (v107.TargetIsValid() or v14:AffectingCombat())) then
					local v207 = 439 - (397 + 42);
					while true do
						if (((121 + 266) <= (3582 - (24 + 776))) and (v207 == (0 - 0))) then
							v108 = v9.BossFightRemains(nil, true);
							v109 = v108;
							v207 = 786 - (222 + 563);
						end
						if ((v207 == (1 - 0)) or ((1368 + 531) <= (1107 - (23 + 167)))) then
							if ((v109 == (12909 - (690 + 1108))) or ((1556 + 2756) <= (723 + 153))) then
								v109 = v9.FightRemains(v103, false);
							end
							v110 = v14:HolyPower();
							break;
						end
					end
				end
				if (((3080 - (40 + 808)) <= (428 + 2168)) and not v14:AffectingCombat()) then
					if (((8011 - 5916) < (3523 + 163)) and v97.DevotionAura:IsCastable() and (v113())) then
						if (v24(v97.DevotionAura) or ((844 + 751) >= (2454 + 2020))) then
							return "devotion_aura";
						end
					end
				end
				v155 = 578 - (47 + 524);
			end
			if ((v155 == (3 + 1)) or ((12626 - 8007) < (4308 - 1426))) then
				v102 = v14:IsTankingAoE(17 - 9) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((2020 - (1165 + 561)) >= (144 + 4687))) then
					if (((6283 - 4254) <= (1177 + 1907)) and v97.CrusaderAura:IsCastable() and (v14:BuffDown(v97.CrusaderAura))) then
						if (v24(v97.CrusaderAura) or ((2516 - (341 + 138)) == (654 + 1766))) then
							return "crusader_aura";
						end
					end
				end
				if (((9199 - 4741) > (4230 - (89 + 237))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (((1402 - 966) >= (258 - 135)) and v14:AffectingCombat()) then
						if (((1381 - (581 + 300)) < (3036 - (855 + 365))) and v97.Intercession:IsCastable()) then
							if (((8488 - 4914) == (1167 + 2407)) and v24(v97.Intercession, not v16:IsInRange(1265 - (1030 + 205)), true)) then
								return "intercession target";
							end
						end
					elseif (((208 + 13) < (363 + 27)) and v97.Redemption:IsCastable()) then
						if (v24(v97.Redemption, not v16:IsInRange(316 - (156 + 130)), true) or ((5028 - 2815) <= (2394 - 973))) then
							return "redemption target";
						end
					end
				end
				v155 = 10 - 5;
			end
			if (((806 + 2252) < (2835 + 2025)) and ((78 - (10 + 59)) == v155)) then
				if (v28 or ((367 + 929) >= (21895 - 17449))) then
					return v28;
				end
				if ((v107.TargetIsValid() and not v14:AffectingCombat() and v29) or ((2556 - (671 + 492)) > (3574 + 915))) then
					v28 = v120();
					if (v28 or ((5639 - (369 + 846)) < (8 + 19))) then
						return v28;
					end
				end
				if ((v107.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((1705 + 292) > (5760 - (1036 + 909)))) then
					if (((2755 + 710) > (3211 - 1298)) and v102) then
						v28 = v118();
						if (((936 - (11 + 192)) < (920 + 899)) and v28) then
							return v28;
						end
					end
					if ((v85 < v109) or ((4570 - (135 + 40)) == (11520 - 6765))) then
						v28 = v121();
						if (v28 or ((2287 + 1506) < (5218 - 2849))) then
							return v28;
						end
					end
					if ((v86 and ((v31 and v87) or not v87) and v16:IsInRange(11 - 3)) or ((4260 - (50 + 126)) == (737 - 472))) then
						local v210 = 0 + 0;
						while true do
							if (((5771 - (1233 + 180)) == (5327 - (522 + 447))) and (v210 == (1421 - (107 + 1314)))) then
								v28 = v117();
								if (v28 or ((1457 + 1681) < (3025 - 2032))) then
									return v28;
								end
								break;
							end
						end
					end
					v28 = v122();
					if (((1415 + 1915) > (4612 - 2289)) and v28) then
						return v28;
					end
					if (v24(v97.Pool) or ((14346 - 10720) == (5899 - (716 + 1194)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v155 == (0 + 0)) or ((99 + 817) == (3174 - (74 + 429)))) then
				v124();
				v123();
				v125();
				v155 = 1 - 0;
			end
		end
	end
	local function v127()
		local v156 = 0 + 0;
		while true do
			if (((622 - 350) == (193 + 79)) and (v156 == (0 - 0))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v111();
				break;
			end
		end
	end
	v20.SetAPL(162 - 96, v126, v127);
end;
return v0["Epix_Paladin_Protection.lua"]();

