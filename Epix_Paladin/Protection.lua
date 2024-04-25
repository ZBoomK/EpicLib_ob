local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3369 - (343 + 1397)) > (2358 - (1074 + 82))) and not v5) then
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
	local v110 = 24349 - 13238;
	local v111 = 12895 - (214 + 1570);
	local v112 = 1455 - (990 + 465);
	v9:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if (((439 + 569) < (3609 + 102)) and (v130 == (0 - 0))) then
				v110 = 12837 - (1668 + 58);
				v111 = 11737 - (512 + 114);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((2734 - 1685) <= (1872 - 966))) then
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
		if (((2100 + 2413) > (511 + 2215)) and v99.CleanseToxins:IsReady() and (v109.UnitHasDispellableDebuffByPlayer(v13) or v109.DispellableFriendlyUnit(22 + 3) or v109.UnitHasCurseDebuff(v13) or v109.UnitHasPoisonDebuff(v13))) then
			if ((v116 == (0 - 0)) or ((3475 - (109 + 1885)) >= (4127 - (1269 + 200)))) then
				v116 = GetTime();
			end
			if (v109.Wait(958 - 458, v116) or ((4035 - (98 + 717)) == (2190 - (802 + 24)))) then
				local v211 = 0 - 0;
				while true do
					if ((v211 == (0 - 0)) or ((156 + 898) > (2607 + 785))) then
						if (v24(v101.CleanseToxinsFocus) or ((112 + 564) >= (355 + 1287))) then
							return "cleanse_toxins dispel";
						end
						v116 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v118()
		if (((13792 - 9656) > (858 + 1539)) and v97 and (v14:HealthPercentage() <= v98)) then
			if (v99.FlashofLight:IsReady() or ((1765 + 2569) == (3502 + 743))) then
				if (v24(v99.FlashofLight) or ((3110 + 1166) <= (1416 + 1615))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		v28 = v109.HandleTopTrinket(v102, v31, 1473 - (797 + 636), nil);
		if (v28 or ((23218 - 18436) <= (2818 - (1427 + 192)))) then
			return v28;
		end
		v28 = v109.HandleBottomTrinket(v102, v31, 14 + 26, nil);
		if (v28 or ((11292 - 6428) < (1710 + 192))) then
			return v28;
		end
	end
	local function v120()
		if (((2193 + 2646) >= (4026 - (192 + 134))) and (v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
			if (v24(v99.DivineShield) or ((2351 - (316 + 960)) > (1068 + 850))) then
				return "divine_shield defensive";
			end
		end
		if (((306 + 90) <= (3517 + 287)) and (v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
			if (v24(v101.LayonHandsPlayer) or ((15937 - 11768) == (2738 - (83 + 468)))) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((3212 - (1202 + 604)) == (6563 - 5157)) and v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) then
			if (((2547 - 1016) < (11825 - 7554)) and v24(v99.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((960 - (45 + 280)) == (613 + 22)) and v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) then
			if (((2947 + 426) <= (1299 + 2257)) and v24(v99.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((1822 + 1469) < (577 + 2703))) then
			if (((8121 - 3735) >= (2784 - (340 + 1571))) and ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (2 + 3)) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff))) then
				if (((2693 - (1733 + 39)) <= (3028 - 1926)) and v24(v101.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((5740 - (125 + 909)) >= (2911 - (1096 + 852))) and v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (1 + 1)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) then
			if (v24(v99.ShieldoftheRighteous) or ((1370 - 410) <= (850 + 26))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((2578 - (409 + 103)) == (1168 - (46 + 190)))) then
			if (((4920 - (51 + 44)) < (1366 + 3477)) and v24(v101.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v92 and (v14:HealthPercentage() <= v94)) or ((5194 - (1114 + 203)) >= (5263 - (228 + 498)))) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (0 + 0)) or ((4978 - (174 + 489)) < (4496 - 2770))) then
					if ((v96 == "Refreshing Healing Potion") or ((5584 - (830 + 1075)) < (1149 - (303 + 221)))) then
						if (v100.RefreshingHealingPotion:IsReady() or ((5894 - (231 + 1038)) < (527 + 105))) then
							if (v24(v101.RefreshingHealingPotion) or ((1245 - (171 + 991)) > (7335 - 5555))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((1466 - 920) <= (2687 - 1610)) and (v96 == "Dreamwalker's Healing Potion")) then
						if (v100.DreamwalkersHealingPotion:IsReady() or ((798 + 198) > (15076 - 10775))) then
							if (((11741 - 7671) > (1106 - 419)) and v24(v101.RefreshingHealingPotion)) then
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
		local v132 = 0 - 0;
		while true do
			if ((v132 == (1249 - (111 + 1137))) or ((814 - (91 + 67)) >= (9910 - 6580))) then
				if (v13 or ((622 + 1870) <= (858 - (423 + 100)))) then
					if (((31 + 4291) >= (7093 - 4531)) and v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (2 + 1))) and (v13:HealthPercentage() <= v74)) then
						if (v24(v101.WordofGloryFocus) or ((4408 - (326 + 445)) >= (16452 - 12682))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73) and v14:AffectingCombat()) or ((5299 - 2920) > (10685 - 6107))) then
						if (v24(v101.LayonHandsFocus) or ((1194 - (530 + 181)) > (1624 - (614 + 267)))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((2486 - (19 + 13)) > (940 - 362)) and v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) then
						if (((2167 - 1237) < (12734 - 8276)) and v24(v101.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((172 + 490) <= (1708 - 736)) and v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) then
						if (((9062 - 4692) == (6182 - (1293 + 519))) and v24(v101.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((12433 - 7671) <= (1646 - 785))) then
				if (v15:Exists() or ((6088 - 4676) == (10044 - 5780))) then
					if ((v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) or ((1678 + 1490) < (440 + 1713))) then
						if (v24(v101.WordofGloryMouseover) or ((11561 - 6585) < (308 + 1024))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((1538 + 3090) == (2893 + 1735)) and (not v13 or not v13:Exists() or not v13:IsInRange(1126 - (709 + 387)))) then
					return;
				end
				v132 = 1859 - (673 + 1185);
			end
		end
	end
	local function v122()
		if (((v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) or ((156 - 102) == (1268 - 873))) then
			if (((134 - 52) == (59 + 23)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (4 + 1))) or ((784 - 203) < (70 + 212))) then
			if (v24(v99.ArcaneTorrent, not v16:IsInRange(15 - 7)) or ((9047 - 4438) < (4375 - (446 + 1434)))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((2435 - (1040 + 243)) == (3438 - 2286)) and v99.Consecration:IsCastable() and v37) then
			if (((3743 - (559 + 1288)) <= (5353 - (609 + 1322))) and v24(v99.Consecration, not v16:IsInRange(462 - (13 + 441)))) then
				return "consecration precombat 8";
			end
		end
		if ((v99.AvengersShield:IsCastable() and v35) or ((3699 - 2709) > (4243 - 2623))) then
			if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) or ((4367 - 3490) > (175 + 4520))) then
				if (((9773 - 7082) >= (658 + 1193)) and v24(v101.AvengersShieldMouseover)) then
					return "avengers_shield mouseover precombat 10";
				end
			end
			if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((1308 + 1677) >= (14410 - 9554))) then
				return "avengers_shield precombat 10";
			end
		end
		if (((2340 + 1936) >= (2197 - 1002)) and v99.Judgment:IsReady() and v41) then
			if (((2137 + 1095) <= (2609 + 2081)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v123()
		if ((v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (2 + 0)) and v14:HasTier(25 + 4, 2 + 0)) or ((1329 - (153 + 280)) >= (9084 - 5938))) then
			local v157 = 0 + 0;
			while true do
				if (((1209 + 1852) >= (1548 + 1410)) and (v157 == (0 + 0))) then
					if (((2310 + 877) >= (980 - 336)) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(19 + 11)) then
						if (((1311 - (89 + 578)) <= (503 + 201)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (((1991 - 1033) > (1996 - (572 + 477))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
					break;
				end
			end
		end
		if (((606 + 3886) >= (1593 + 1061)) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (1 + 1))) then
			if (((3528 - (84 + 2)) >= (2476 - 973)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) or ((2284 + 886) <= (2306 - (497 + 345)))) then
			if (v24(v99.AvengingWrath, not v16:IsInRange(1 + 7)) or ((811 + 3986) == (5721 - (605 + 728)))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((394 + 157) <= (1513 - 832)) and v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) then
			if (((151 + 3126) > (1504 - 1097)) and v24(v99.Sentinel, not v16:IsInRange(8 + 0))) then
				return "sentinel cooldowns 8";
			end
		end
		local v133 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
		if (((13007 - 8312) >= (1069 + 346)) and v133) then
			return v133;
		end
		if ((v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (504 - (457 + 32))) or (((v9.CombatTime() > (5 + 5)) or (v99.Sentinel:CooldownRemains() > (1417 - (832 + 570))) or (v99.AvengingWrath:CooldownRemains() > (15 + 0))) and (v99.AvengersShield:CooldownRemains() > (0 + 0)) and (v99.Judgment:CooldownRemains() > (0 - 0)) and (v99.HammerofWrath:CooldownRemains() > (0 + 0))))) or ((4008 - (588 + 208)) <= (2544 - 1600))) then
			if (v24(v99.MomentOfGlory, not v16:IsInRange(1808 - (884 + 916))) or ((6481 - 3385) <= (1043 + 755))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((4190 - (232 + 421)) == (5426 - (1569 + 320))) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (1 + 2))) then
			if (((729 + 3108) >= (5290 - 3720)) and v24(v99.DivineToll, not v16:IsInRange(635 - (316 + 289)))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (78 - 48)))) or ((137 + 2813) == (5265 - (666 + 787)))) then
			if (((5148 - (360 + 65)) >= (2167 + 151)) and v24(v99.BastionofLight, not v16:IsInRange(262 - (79 + 175)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		while true do
			if (((1 + 0) == v134) or ((6213 - 4186) > (5492 - 2640))) then
				if ((v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(930 - (503 + 396), 183 - (92 + 89))) or ((2203 - 1067) > (2214 + 2103))) then
					local v213 = 0 + 0;
					while true do
						if (((18593 - 13845) == (650 + 4098)) and ((0 - 0) == v213)) then
							if (((3260 + 476) <= (2264 + 2476)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 8";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((10324 - 6934) <= (382 + 2678))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v99.HammerofWrath:IsReady() and v40) or ((1522 - 523) > (3937 - (485 + 759)))) then
					if (((1071 - 608) < (1790 - (442 + 747))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (1137 - (832 + 303))) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((3129 - (88 + 858)) < (210 + 477))) then
					local v214 = 0 + 0;
					while true do
						if (((188 + 4361) == (5338 - (766 + 23))) and (v214 == (0 - 0))) then
							if (((6389 - 1717) == (12308 - 7636)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 12";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((12449 - 8781) < (1468 - (1036 + 37)))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v134 = 2 + 0;
			end
			if (((5 - 2) == v134) or ((3278 + 888) == (1935 - (641 + 839)))) then
				if ((v99.HammerofWrath:IsReady() and v40) or ((5362 - (910 + 3)) == (6788 - 4125))) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((5961 - (1466 + 218)) < (1374 + 1615))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v99.Judgment:IsReady() and v41) or ((2018 - (556 + 592)) >= (1476 + 2673))) then
					local v215 = 808 - (329 + 479);
					while true do
						if (((3066 - (174 + 680)) < (10937 - 7754)) and (v215 == (0 - 0))) then
							if (((3318 + 1328) > (3731 - (396 + 343))) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 22";
							end
							if (((127 + 1307) < (4583 - (29 + 1448))) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if (((2175 - (135 + 1254)) < (11388 - 8365)) and v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (23 - 18)) or not v14:HasTier(21 + 10, 1529 - (389 + 1138)))) then
					if (v24(v99.Consecration, not v16:IsInRange(582 - (102 + 472))) or ((2305 + 137) < (42 + 32))) then
						return "consecration standard 24";
					end
				end
				v134 = 4 + 0;
			end
			if (((6080 - (320 + 1225)) == (8073 - 3538)) and (v134 == (4 + 2))) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) or ((4473 - (157 + 1307)) <= (3964 - (821 + 1038)))) then
					if (((4565 - 2735) < (402 + 3267)) and v24(v99.Consecration, not v16:IsInRange(13 - 5))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v134 == (1 + 1)) or ((3544 - 2114) >= (4638 - (834 + 192)))) then
				if (((171 + 2512) >= (632 + 1828)) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (1 + 1)) or v14:BuffUp(v99.MomentOfGloryBuff))) then
					local v216 = 0 - 0;
					while true do
						if ((v216 == (304 - (300 + 4))) or ((482 + 1322) >= (8573 - 5298))) then
							if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(392 - (112 + 250))) or ((565 + 852) > (9091 - 5462))) then
								if (((2747 + 2048) > (208 + 194)) and v24(v101.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 14";
								end
							end
							if (((3600 + 1213) > (1768 + 1797)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
								return "avengers_shield standard 14";
							end
							break;
						end
					end
				end
				if (((2907 + 1005) == (5326 - (1001 + 413))) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) then
					if (((6290 - 3469) <= (5706 - (244 + 638))) and v24(v99.DivineToll, not v16:IsInRange(723 - (627 + 66)))) then
						return "divine_toll standard 16";
					end
				end
				if (((5178 - 3440) <= (2797 - (512 + 90))) and v99.AvengersShield:IsCastable() and v35) then
					local v217 = 1906 - (1665 + 241);
					while true do
						if (((758 - (373 + 344)) <= (1362 + 1656)) and (v217 == (0 + 0))) then
							if (((5657 - 3512) <= (6944 - 2840)) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(1129 - (35 + 1064))) then
								if (((1957 + 732) < (10366 - 5521)) and v24(v101.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 18";
								end
							end
							if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((10 + 2312) > (3858 - (298 + 938)))) then
								return "avengers_shield standard 18";
							end
							break;
						end
					end
				end
				v134 = 1262 - (233 + 1026);
			end
			if ((v134 == (1671 - (636 + 1030))) or ((2319 + 2215) == (2034 + 48))) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((467 + 1104) > (127 + 1740))) then
					if (v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike)) or ((2875 - (55 + 166)) >= (581 + 2415))) then
						return "crusader_strike standard 32";
					end
				end
				if (((401 + 3577) > (8035 - 5931)) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) then
					if (((3292 - (36 + 261)) > (2694 - 1153)) and v24(v99.EyeofTyr, not v16:IsInRange(1376 - (34 + 1334)))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((1250 + 1999) > (741 + 212)) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (1288 - (1035 + 248)))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(29 - (20 + 1))) or ((1706 + 1567) > (4892 - (134 + 185)))) then
						return "arcane_torrent standard 36";
					end
				end
				v134 = 1139 - (549 + 584);
			end
			if ((v134 == (685 - (314 + 371))) or ((10817 - 7666) < (2252 - (478 + 490)))) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (3 + 2))) or ((3022 - (786 + 386)) == (4952 - 3423))) then
					if (((2200 - (1055 + 324)) < (3463 - (1093 + 247))) and v24(v99.Consecration, not v16:IsInRange(8 + 0))) then
						return "consecration standard 2";
					end
				end
				if (((95 + 807) < (9230 - 6905)) and v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (6 - 4)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (14 - 9)))) then
					if (((2155 - 1297) <= (1054 + 1908)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and (v107 > (11 - 8)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (10 - 7)) and (v14:HolyPower() < (3 + 0))) or ((10091 - 6145) < (1976 - (364 + 324)))) then
					local v218 = 0 - 0;
					while true do
						if ((v218 == (0 - 0)) or ((1075 + 2167) == (2372 - 1805))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((1355 - 508) >= (3835 - 2572))) then
								return "judgment standard 6";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((3521 - (1249 + 19)) == (1671 + 180))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v134 = 3 - 2;
			end
			if ((v134 == (1090 - (686 + 400))) or ((1638 + 449) > (2601 - (73 + 156)))) then
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (1 + 2))) or ((5256 - (721 + 90)) < (47 + 4102))) then
					if (v24(v99.EyeofTyr, not v16:IsInRange(25 - 17)) or ((2288 - (224 + 246)) == (137 - 52))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((1159 - 529) < (386 + 1741)) and v99.BlessedHammer:IsCastable() and v36) then
					if (v24(v99.BlessedHammer, not v16:IsInRange(1 + 7)) or ((1424 + 514) == (4997 - 2483))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((14159 - 9904) >= (568 - (203 + 310))) and v99.HammeroftheRighteous:IsCastable() and v39) then
					if (((4992 - (1238 + 755)) > (81 + 1075)) and v24(v99.HammeroftheRighteous, not v16:IsInRange(1542 - (709 + 825)))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v134 = 8 - 3;
			end
		end
	end
	local function v125()
		local v135 = 0 - 0;
		while true do
			if (((3214 - (196 + 668)) > (4560 - 3405)) and (v135 == (10 - 5))) then
				v48 = EpicSettings.Settings['avengingWrathWithCD'];
				v49 = EpicSettings.Settings['bastionofLightWithCD'];
				v50 = EpicSettings.Settings['divineTollWithCD'];
				v135 = 839 - (171 + 662);
			end
			if (((4122 - (4 + 89)) <= (17009 - 12156)) and (v135 == (0 + 0))) then
				v33 = EpicSettings.Settings['swapAuras'];
				v34 = EpicSettings.Settings['useWeapon'];
				v35 = EpicSettings.Settings['useAvengersShield'];
				v135 = 4 - 3;
			end
			if ((v135 == (1 + 1)) or ((2002 - (35 + 1451)) > (4887 - (28 + 1425)))) then
				v39 = EpicSettings.Settings['useHammeroftheRighteous'];
				v40 = EpicSettings.Settings['useHammerofWrath'];
				v41 = EpicSettings.Settings['useJudgment'];
				v135 = 1996 - (941 + 1052);
			end
			if (((3880 + 166) >= (4547 - (822 + 692))) and (v135 == (3 - 0))) then
				v42 = EpicSettings.Settings['useAvengingWrath'];
				v43 = EpicSettings.Settings['useBastionofLight'];
				v44 = EpicSettings.Settings['useDivineToll'];
				v135 = 2 + 2;
			end
			if ((v135 == (303 - (45 + 252))) or ((2691 + 28) <= (498 + 949))) then
				v51 = EpicSettings.Settings['eyeofTyrWithCD'];
				v52 = EpicSettings.Settings['momentOfGloryWithCD'];
				v53 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v135 == (9 - 5)) or ((4567 - (114 + 319)) < (5636 - 1710))) then
				v45 = EpicSettings.Settings['useEyeofTyr'];
				v46 = EpicSettings.Settings['useMomentOfGlory'];
				v47 = EpicSettings.Settings['useSentinel'];
				v135 = 6 - 1;
			end
			if ((v135 == (1 + 0)) or ((243 - 79) >= (5835 - 3050))) then
				v36 = EpicSettings.Settings['useBlessedHammer'];
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v135 = 1965 - (556 + 1407);
			end
		end
	end
	local function v126()
		local v136 = 1206 - (741 + 465);
		while true do
			if ((v136 == (468 - (170 + 295))) or ((277 + 248) == (1938 + 171))) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['ardentDefenderHP'];
				v68 = EpicSettings.Settings['divineShieldHP'];
				v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v136 = 9 - 5;
			end
			if (((28 + 5) == (22 + 11)) and (v136 == (0 + 0))) then
				v54 = EpicSettings.Settings['useRebuke'];
				v55 = EpicSettings.Settings['useHammerofJustice'];
				v56 = EpicSettings.Settings['useArdentDefender'];
				v57 = EpicSettings.Settings['useDivineShield'];
				v136 = 1231 - (957 + 273);
			end
			if (((817 + 2237) <= (1608 + 2407)) and (v136 == (15 - 11))) then
				v70 = EpicSettings.Settings['layonHandsHP'];
				v71 = EpicSettings.Settings['wordofGloryHP'];
				v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v73 = EpicSettings.Settings['layOnHandsFocusHP'];
				v136 = 13 - 8;
			end
			if (((5714 - 3843) < (16746 - 13364)) and ((1786 - (389 + 1391)) == v136)) then
				v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((812 + 481) <= (226 + 1940)) and (v136 == (4 - 2))) then
				v62 = EpicSettings.Settings['useLayOnHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v136 = 954 - (783 + 168);
			end
			if ((v136 == (16 - 11)) or ((2537 + 42) < (434 - (309 + 2)))) then
				v74 = EpicSettings.Settings['wordofGloryFocusHP'];
				v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v136 = 18 - 12;
			end
			if ((v136 == (1213 - (1090 + 122))) or ((275 + 571) >= (7952 - 5584))) then
				v58 = EpicSettings.Settings['useGuardianofAncientKings'];
				v59 = EpicSettings.Settings['useLayOnHands'];
				v60 = EpicSettings.Settings['useWordofGloryPlayer'];
				v61 = EpicSettings.Settings['useShieldoftheRighteous'];
				v136 = 2 + 0;
			end
		end
	end
	local function v127()
		v87 = EpicSettings.Settings['fightRemainsCheck'] or (1118 - (628 + 490));
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
		v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v94 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v82 = EpicSettings.Settings['handleAfflicted'];
		v83 = EpicSettings.Settings['HandleIncorporeal'];
		v97 = EpicSettings.Settings['HealOOC'];
		v98 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v128()
		v126();
		v125();
		v127();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		if (v14:IsDeadOrGhost() or ((4786 - (431 + 343)) <= (6781 - 3423))) then
			return v28;
		end
		v105 = v14:GetEnemiesInMeleeRange(23 - 15);
		v106 = v14:GetEnemiesInRange(24 + 6);
		if (((192 + 1302) <= (4700 - (556 + 1139))) and v30) then
			local v158 = 15 - (6 + 9);
			while true do
				if ((v158 == (0 + 0)) or ((1594 + 1517) == (2303 - (28 + 141)))) then
					v107 = #v105;
					v108 = #v106;
					break;
				end
			end
		else
			v107 = 1 + 0;
			v108 = 1 - 0;
		end
		v103 = v14:ActiveMitigationNeeded();
		v104 = v14:IsTankingAoE(6 + 2) or v14:IsTanking(v16);
		if (((3672 - (486 + 831)) == (6128 - 3773)) and not v14:AffectingCombat() and v14:IsMounted()) then
			if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) or ((2069 - 1481) <= (82 + 350))) then
				if (((15167 - 10370) >= (5158 - (668 + 595))) and v24(v99.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (((3219 + 358) == (722 + 2855)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
			if (((10346 - 6552) > (3983 - (23 + 267))) and v14:AffectingCombat()) then
				if (v99.Intercession:IsCastable() or ((3219 - (1129 + 815)) == (4487 - (371 + 16)))) then
					if (v24(v99.Intercession, not v16:IsInRange(1780 - (1326 + 424)), true) or ((3013 - 1422) >= (13082 - 9502))) then
						return "intercession target";
					end
				end
			elseif (((1101 - (88 + 30)) <= (2579 - (720 + 51))) and v99.Redemption:IsCastable()) then
				if (v24(v99.Redemption, not v16:IsInRange(66 - 36), true) or ((3926 - (421 + 1355)) <= (1974 - 777))) then
					return "redemption target";
				end
			end
		end
		if (((1852 + 1917) >= (2256 - (286 + 797))) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
			if (((5428 - 3943) == (2459 - 974)) and v24(v101.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (v14:AffectingCombat() or ((3754 - (397 + 42)) <= (869 + 1913))) then
			if ((v99.Intercession:IsCastable() and (v14:HolyPower() >= (803 - (24 + 776))) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1349 - 473) >= (3749 - (222 + 563)))) then
				if (v24(v101.IntercessionMouseover) or ((4917 - 2685) > (1798 + 699))) then
					return "Intercession";
				end
			end
		end
		if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((2300 - (23 + 167)) <= (2130 - (690 + 1108)))) then
			local v159 = 0 + 0;
			local v160;
			while true do
				if (((3041 + 645) > (4020 - (40 + 808))) and (v159 == (1 + 0))) then
					if (v28 or ((17108 - 12634) < (784 + 36))) then
						return v28;
					end
					break;
				end
				if (((2264 + 2015) >= (1581 + 1301)) and (v159 == (571 - (47 + 524)))) then
					v160 = v81 and v99.CleanseToxins:IsReady() and v32;
					v28 = v109.FocusUnit(v160, nil, 13 + 7, nil, 68 - 43, v99.FlashofLight);
					v159 = 1 - 0;
				end
			end
		end
		if ((v32 and v81) or ((4626 - 2597) >= (5247 - (1165 + 561)))) then
			v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 2 + 38, 77 - 52, v99.FlashofLight);
			if (v28 or ((778 + 1259) >= (5121 - (341 + 138)))) then
				return v28;
			end
			if (((465 + 1255) < (9199 - 4741)) and v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
				if (v24(v101.BlessingofFreedomFocus) or ((762 - (89 + 237)) > (9718 - 6697))) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((1500 - 787) <= (1728 - (581 + 300))) and (v109.TargetIsValid() or v14:AffectingCombat())) then
			local v161 = 1220 - (855 + 365);
			while true do
				if (((5116 - 2962) <= (1317 + 2714)) and (v161 == (1236 - (1030 + 205)))) then
					if (((4333 + 282) == (4294 + 321)) and (v111 == (11397 - (156 + 130)))) then
						v111 = v9.FightRemains(v105, false);
					end
					v112 = v14:HolyPower();
					break;
				end
				if ((v161 == (0 - 0)) or ((6387 - 2597) == (1024 - 524))) then
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					v161 = 1 + 0;
				end
			end
		end
		if (((52 + 37) < (290 - (10 + 59))) and not v14:AffectingCombat()) then
			if (((581 + 1473) >= (6998 - 5577)) and v99.DevotionAura:IsCastable() and (v115()) and v33) then
				if (((1855 - (671 + 492)) < (2435 + 623)) and v24(v99.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v82 or ((4469 - (369 + 846)) == (439 + 1216))) then
			if (v78 or ((1107 + 189) == (6855 - (1036 + 909)))) then
				local v212 = 0 + 0;
				while true do
					if (((5654 - 2286) == (3571 - (11 + 192))) and (v212 == (0 + 0))) then
						v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 215 - (135 + 40));
						if (((6403 - 3760) < (2300 + 1515)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
			if (((4213 - 2300) > (738 - 245)) and v14:BuffUp(v99.ShiningLightFreeBuff) and v79) then
				v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 216 - (50 + 126), true);
				if (((13240 - 8485) > (759 + 2669)) and v28) then
					return v28;
				end
			end
		end
		if (((2794 - (1233 + 180)) <= (3338 - (522 + 447))) and v83) then
			v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 1451 - (107 + 1314), true);
			if (v28 or ((2248 + 2595) == (12444 - 8360))) then
				return v28;
			end
			v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 13 + 17, true);
			if (((9271 - 4602) > (1436 - 1073)) and v28) then
				return v28;
			end
		end
		v28 = v118();
		if (v28 or ((3787 - (716 + 1194)) >= (54 + 3084))) then
			return v28;
		end
		if (((508 + 4234) >= (4129 - (74 + 429))) and v81 and v32) then
			if (v13 or ((8758 - 4218) == (454 + 462))) then
				v28 = v117();
				if (v28 or ((2645 - 1489) > (3074 + 1271))) then
					return v28;
				end
			end
			if (((6896 - 4659) < (10505 - 6256)) and v15 and v15:Exists() and not v14:CanAttack(v15) and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15) or v109.UnitHasDispellableDebuffByPlayer(v15))) then
				if (v99.CleanseToxins:IsReady() or ((3116 - (279 + 154)) < (801 - (454 + 324)))) then
					if (((549 + 148) <= (843 - (12 + 5))) and v24(v101.CleanseToxinsMouseover)) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v28 = v121();
		if (((596 + 509) <= (2996 - 1820)) and v28) then
			return v28;
		end
		if (((1249 + 2130) <= (4905 - (277 + 816))) and v104) then
			local v162 = 0 - 0;
			while true do
				if ((v162 == (1183 - (1058 + 125))) or ((148 + 640) >= (2591 - (815 + 160)))) then
					v28 = v120();
					if (((7954 - 6100) <= (8021 - 4642)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((1086 + 3463) == (13297 - 8748)) and v109.TargetIsValid() and not v14:AffectingCombat() and v29) then
			v28 = v122();
			if (v28 or ((4920 - (41 + 1857)) >= (4917 - (1222 + 671)))) then
				return v28;
			end
		end
		if (((12457 - 7637) > (3159 - 961)) and v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
			local v163 = 1182 - (229 + 953);
			while true do
				if (((1775 - (1111 + 663)) == v163) or ((2640 - (874 + 705)) >= (685 + 4206))) then
					v28 = v124();
					if (((931 + 433) <= (9297 - 4824)) and v28) then
						return v28;
					end
					v163 = 1 + 1;
				end
				if (((679 - (642 + 37)) == v163) or ((820 + 2775) <= (1 + 2))) then
					if ((v87 < v111) or ((11730 - 7058) == (4306 - (233 + 221)))) then
						local v219 = 0 - 0;
						while true do
							if (((1373 + 186) == (3100 - (718 + 823))) and (v219 == (1 + 0))) then
								if ((v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) or ((2557 - (266 + 539)) <= (2230 - 1442))) then
									if (v24(v101.UseWeapon) or ((5132 - (636 + 589)) == (419 - 242))) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
							if (((7157 - 3687) > (440 + 115)) and (v219 == (0 + 0))) then
								v28 = v123();
								if (v28 or ((1987 - (657 + 358)) == (1707 - 1062))) then
									return v28;
								end
								v219 = 2 - 1;
							end
						end
					end
					if (((4369 - (1151 + 36)) >= (2043 + 72)) and v88 and ((v31 and v89) or not v89) and v16:IsInRange(3 + 5)) then
						local v220 = 0 - 0;
						while true do
							if (((5725 - (1552 + 280)) < (5263 - (64 + 770))) and (v220 == (0 + 0))) then
								v28 = v119();
								if (v28 or ((6507 - 3640) < (339 + 1566))) then
									return v28;
								end
								break;
							end
						end
					end
					v163 = 1244 - (157 + 1086);
				end
				if ((v163 == (3 - 1)) or ((7865 - 6069) >= (6213 - 2162))) then
					if (((2209 - 590) <= (4575 - (599 + 220))) and v24(v99.Pool)) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v129()
		v20.Print("Protection Paladin by Epic. Supported by xKaneto");
		v113();
	end
	v20.SetAPL(130 - 64, v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

