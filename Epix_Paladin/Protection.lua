local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1598 - (939 + 250)) <= (146 + 886)) and not v5) then
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
	local v95 = v18.Paladin.Protection;
	local v96 = v19.Paladin.Protection;
	local v97 = v23.Paladin.Protection;
	local v98 = {};
	local v99;
	local v100;
	local v101, v102;
	local v103, v104;
	local v105 = v20.Commons.Everyone;
	local function v106()
		if (v95.CleanseToxins:IsAvailable() or ((17260 - 13696) <= (3728 - (1078 + 563)))) then
			v105.DispellableDebuffs = v12.MergeTable(v105.DispellableDiseaseDebuffs, v105.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v107(v122)
		return v122:DebuffRemains(v95.JudgmentDebuff);
	end
	local function v108()
		return v14:BuffDown(v95.RetributionAura) and v14:BuffDown(v95.DevotionAura) and v14:BuffDown(v95.ConcentrationAura) and v14:BuffDown(v95.CrusaderAura);
	end
	local function v109()
		if (((7445 - 4487) < (4739 - (141 + 95))) and v95.CleanseToxins:IsReady() and v32 and v105.DispellableFriendlyUnit(25 + 0)) then
			if (v24(v97.CleanseToxinsFocus) or ((7039 - 4304) == (3146 - 1837))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v110()
		if ((v93 and (v14:HealthPercentage() <= v94)) or ((968 + 3162) <= (8096 - 5141))) then
			if (v95.FlashofLight:IsReady() or ((1381 + 583) <= (698 + 642))) then
				if (((3518 - 1019) == (1475 + 1024)) and v24(v95.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v111()
		v28 = v105.HandleTopTrinket(v98, v31, 203 - (92 + 71), nil);
		if (v28 or ((1114 + 1141) < (36 - 14))) then
			return v28;
		end
		v28 = v105.HandleBottomTrinket(v98, v31, 805 - (574 + 191), nil);
		if (v28 or ((896 + 190) >= (3519 - 2114))) then
			return v28;
		end
	end
	local function v112()
		local v123 = 0 + 0;
		while true do
			if ((v123 == (849 - (254 + 595))) or ((2495 - (55 + 71)) == (560 - 134))) then
				if (((v14:HealthPercentage() <= v65) and v55 and v95.DivineShield:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) or ((4866 - (573 + 1217)) > (8815 - 5632))) then
					if (((92 + 1110) > (1704 - 646)) and v24(v95.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((4650 - (714 + 225)) > (9804 - 6449)) and (v14:HealthPercentage() <= v67) and v57 and v95.LayonHands:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) then
					if (v24(v97.LayonHandsPlayer) or ((1262 - 356) >= (242 + 1987))) then
						return "lay_on_hands defensive 2";
					end
				end
				v123 = 1 - 0;
			end
			if (((2094 - (118 + 688)) > (1299 - (25 + 23))) and (v123 == (1 + 2))) then
				if ((v96.Healthstone:IsReady() and v89 and (v14:HealthPercentage() <= v91)) or ((6399 - (927 + 959)) < (11299 - 7947))) then
					if (v24(v97.Healthstone) or ((2797 - (16 + 716)) >= (6169 - 2973))) then
						return "healthstone defensive";
					end
				end
				if ((v88 and (v14:HealthPercentage() <= v90)) or ((4473 - (11 + 86)) <= (3612 - 2131))) then
					local v196 = 285 - (175 + 110);
					while true do
						if ((v196 == (0 - 0)) or ((16730 - 13338) >= (6537 - (503 + 1293)))) then
							if (((9286 - 5961) >= (1558 + 596)) and (v92 == "Refreshing Healing Potion")) then
								if (v96.RefreshingHealingPotion:IsReady() or ((2356 - (810 + 251)) >= (2244 + 989))) then
									if (((1344 + 3033) > (1481 + 161)) and v24(v97.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((5256 - (43 + 490)) > (2089 - (711 + 22))) and (v92 == "Dreamwalker's Healing Potion")) then
								if (v96.DreamwalkersHealingPotion:IsReady() or ((15998 - 11862) <= (4292 - (240 + 619)))) then
									if (((1025 + 3220) <= (7366 - 2735)) and v24(v97.RefreshingHealingPotion)) then
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
			if (((283 + 3993) >= (5658 - (1344 + 400))) and (v123 == (407 - (255 + 150)))) then
				if (((156 + 42) <= (2337 + 2028)) and v95.WordofGlory:IsReady() and (v14:HealthPercentage() <= v68) and v58 and not v14:HealingAbsorbed()) then
					if (((20431 - 15649) > (15103 - 10427)) and ((v14:BuffRemains(v95.ShieldoftheRighteousBuff) >= (1744 - (404 + 1335))) or v14:BuffUp(v95.DivinePurposeBuff) or v14:BuffUp(v95.ShiningLightFreeBuff))) then
						if (((5270 - (183 + 223)) > (2673 - 476)) and v24(v97.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v95.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (2 + 0)) and v14:BuffRefreshable(v95.ShieldoftheRighteousBuff) and v59 and (v99 or (v14:HealthPercentage() <= v69))) or ((1332 + 2368) == (2844 - (10 + 327)))) then
					if (((3116 + 1358) >= (612 - (118 + 220))) and v24(v95.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v123 = 1 + 2;
			end
			if ((v123 == (450 - (108 + 341))) or ((851 + 1043) <= (5944 - 4538))) then
				if (((3065 - (711 + 782)) >= (2934 - 1403)) and v95.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v66) and v56 and v14:BuffDown(v95.ArdentDefenderBuff)) then
					if (v24(v95.GuardianofAncientKings) or ((5156 - (270 + 199)) < (1473 + 3069))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if (((5110 - (580 + 1239)) > (4955 - 3288)) and v95.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v64) and v54 and v14:BuffDown(v95.GuardianofAncientKingsBuff)) then
					if (v24(v95.ArdentDefender) or ((835 + 38) == (74 + 1960))) then
						return "ardent_defender defensive 6";
					end
				end
				v123 = 1 + 1;
			end
		end
	end
	local function v113()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (0 + 0)) or ((3983 - (645 + 522)) < (1801 - (1010 + 780)))) then
				if (((3698 + 1) < (22418 - 17712)) and (not v13 or not v13:Exists() or not v13:IsInRange(87 - 57))) then
					return;
				end
				if (((4482 - (1045 + 791)) >= (2217 - 1341)) and v13) then
					if (((936 - 322) <= (3689 - (351 + 154))) and v95.WordofGlory:IsReady() and v61 and v14:BuffUp(v95.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v71)) then
						if (((4700 - (1281 + 293)) == (3392 - (28 + 238))) and v24(v97.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v95.LayonHands:IsCastable() and v60 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v70)) or ((4886 - 2699) >= (6513 - (1381 + 178)))) then
						if (v24(v97.LayonHandsFocus) or ((3637 + 240) == (2883 + 692))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((302 + 405) > (2178 - 1546)) and v95.BlessingofSacrifice:IsCastable() and v63 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v73)) then
						if (v24(v97.BlessingofSacrificeFocus) or ((283 + 263) >= (3154 - (381 + 89)))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((1300 + 165) <= (2909 + 1392)) and v95.BlessingofProtection:IsCastable() and v62 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v72)) then
						if (((2918 - 1214) > (2581 - (1074 + 82))) and v24(v97.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v125 = 0 - 0;
		while true do
			if ((v125 == (1785 - (214 + 1570))) or ((2142 - (990 + 465)) == (1746 + 2488))) then
				if ((v95.Consecration:IsCastable() and v35) or ((1449 + 1881) < (1390 + 39))) then
					if (((4514 - 3367) >= (2061 - (1668 + 58))) and v24(v95.Consecration, not v16:IsInRange(634 - (512 + 114)))) then
						return "consecration";
					end
				end
				if (((8955 - 5520) > (4335 - 2238)) and v95.AvengersShield:IsCastable() and v33) then
					if (v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield)) or ((13118 - 9348) >= (1880 + 2161))) then
						return "avengers_shield precombat 10";
					end
				end
				v125 = 1 + 1;
			end
			if (((2 + 0) == v125) or ((12786 - 8995) <= (3605 - (109 + 1885)))) then
				if ((v95.Judgment:IsReady() and v39) or ((6047 - (1269 + 200)) <= (3848 - 1840))) then
					if (((1940 - (98 + 717)) <= (2902 - (802 + 24))) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v125 == (0 - 0)) or ((937 - 194) >= (650 + 3749))) then
				if (((888 + 267) < (275 + 1398)) and (v83 < FightRemains) and v95.LightsJudgment:IsCastable() and v86 and ((v87 and v31) or not v87)) then
					if (v24(v95.LightsJudgment, not v16:IsSpellInRange(v95.LightsJudgment)) or ((502 + 1822) <= (1607 - 1029))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((12562 - 8795) == (1348 + 2419)) and (v83 < FightRemains) and v95.ArcaneTorrent:IsCastable() and v86 and ((v87 and v31) or not v87) and (HolyPower < (3 + 2))) then
					if (((3373 + 716) == (2974 + 1115)) and v24(v95.ArcaneTorrent, not v16:IsInRange(4 + 4))) then
						return "arcane_torrent precombat 6";
					end
				end
				v125 = 1434 - (797 + 636);
			end
		end
	end
	local function v115()
		local v126 = 0 - 0;
		local v127;
		while true do
			if (((6077 - (1427 + 192)) >= (581 + 1093)) and (v126 == (4 - 2))) then
				v127 = v105.HandleDPSPotion(v14:BuffUp(v95.AvengingWrathBuff));
				if (((874 + 98) <= (643 + 775)) and v127) then
					return v127;
				end
				v126 = 329 - (192 + 134);
			end
			if (((1279 - (316 + 960)) == v126) or ((2748 + 2190) < (3675 + 1087))) then
				if ((v95.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v95.SentinelBuff) < (14 + 1)) or (((v9.CombatTime() > (38 - 28)) or (v95.Sentinel:CooldownRemains() > (566 - (83 + 468))) or (v95.AvengingWrath:CooldownRemains() > (1821 - (1202 + 604)))) and (v95.AvengersShield:CooldownRemains() > (0 - 0)) and (v95.Judgment:CooldownRemains() > (0 - 0)) and (v95.HammerofWrath:CooldownRemains() > (0 - 0))))) or ((2829 - (45 + 280)) > (4116 + 148))) then
					if (((1882 + 271) == (787 + 1366)) and v24(v95.MomentofGlory, not v16:IsInRange(5 + 3))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v42 and ((v48 and v31) or not v48) and v95.DivineToll:IsReady() and (v103 >= (1 + 2))) or ((938 - 431) >= (4502 - (340 + 1571)))) then
					if (((1768 + 2713) == (6253 - (1733 + 39))) and v24(v95.DivineToll, not v16:IsInRange(82 - 52))) then
						return "divine_toll cooldowns 12";
					end
				end
				v126 = 1038 - (125 + 909);
			end
			if ((v126 == (1949 - (1096 + 852))) or ((1045 + 1283) < (988 - 295))) then
				if (((4198 + 130) == (4840 - (409 + 103))) and v95.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) then
					if (((1824 - (46 + 190)) >= (1427 - (51 + 44))) and v24(v95.AvengingWrath, not v16:IsInRange(3 + 5))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v95.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) or ((5491 - (1114 + 203)) > (4974 - (228 + 498)))) then
					if (v24(v95.Sentinel, not v16:IsInRange(2 + 6)) or ((2534 + 2052) <= (745 - (174 + 489)))) then
						return "sentinel cooldowns 8";
					end
				end
				v126 = 5 - 3;
			end
			if (((5768 - (830 + 1075)) == (4387 - (303 + 221))) and (v126 == (1273 - (231 + 1038)))) then
				if ((v95.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v95.AvengingWrathBuff) or (v95.AvengingWrath:CooldownRemains() <= (25 + 5)))) or ((1444 - (171 + 991)) <= (172 - 130))) then
					if (((12375 - 7766) >= (1911 - 1145)) and v24(v95.BastionofLight, not v16:IsInRange(7 + 1))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v126 == (0 - 0)) or ((3322 - 2170) == (4010 - 1522))) then
				if (((10578 - 7156) > (4598 - (111 + 1137))) and v95.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (160 - (91 + 67))) and v14:HasTier(86 - 57, 1 + 1)) then
					if (((1400 - (423 + 100)) > (3 + 373)) and v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v95.LightsJudgment:IsCastable() and v86 and ((v87 and v31) or not v87) and (v104 >= (5 - 3))) or ((1626 + 1492) <= (2622 - (326 + 445)))) then
					if (v24(v95.LightsJudgment, not v16:IsSpellInRange(v95.LightsJudgment)) or ((720 - 555) >= (7779 - 4287))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v126 = 2 - 1;
			end
		end
	end
	local function v116()
		if (((4660 - (530 + 181)) < (5737 - (614 + 267))) and v95.Consecration:IsCastable() and v35 and (v14:BuffStack(v95.SanctificationBuff) == (37 - (19 + 13)))) then
			if (v24(v95.Consecration, not v16:IsInRange(12 - 4)) or ((9963 - 5687) < (8615 - 5599))) then
				return "consecration standard 2";
			end
		end
		if (((1219 + 3471) > (7254 - 3129)) and v95.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (3 - 1)) or v14:BuffUp(v95.BastionofLightBuff) or v14:BuffUp(v95.DivinePurposeBuff)) and (v14:BuffDown(v95.SanctificationBuff) or (v14:BuffStack(v95.SanctificationBuff) < (1817 - (1293 + 519))))) then
			if (v24(v95.ShieldoftheRighteous) or ((102 - 52) >= (2339 - 1443))) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if ((v95.Judgment:IsReady() and v39 and (v103 > (5 - 2)) and (v14:BuffStack(v95.BulwarkofRighteousFuryBuff) >= (12 - 9)) and (v14:HolyPower() < (6 - 3))) or ((908 + 806) >= (604 + 2354))) then
			if (v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment)) or ((3464 - 1973) < (149 + 495))) then
				return "judgment standard 6";
			end
		end
		if (((234 + 470) < (617 + 370)) and v95.Judgment:IsReady() and v39 and v14:BuffDown(v95.SanctificationEmpowerBuff) and v14:HasTier(1127 - (709 + 387), 1860 - (673 + 1185))) then
			if (((10782 - 7064) > (6120 - 4214)) and v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment))) then
				return "judgment standard 8";
			end
		end
		if ((v95.HammerofWrath:IsReady() and v38) or ((1576 - 618) > (2600 + 1035))) then
			if (((2616 + 885) <= (6064 - 1572)) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if ((v95.Judgment:IsReady() and v39 and ((v95.Judgment:Charges() >= (1 + 1)) or (v95.Judgment:FullRechargeTime() <= v14:GCD()))) or ((6862 - 3420) < (5001 - 2453))) then
			if (((4755 - (446 + 1434)) >= (2747 - (1040 + 243))) and v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment))) then
				return "judgment standard 12";
			end
		end
		if ((v95.AvengersShield:IsCastable() and v33 and ((v104 > (5 - 3)) or v14:BuffUp(v95.MomentofGloryBuff))) or ((6644 - (559 + 1288)) >= (6824 - (609 + 1322)))) then
			if (v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield)) or ((1005 - (13 + 441)) > (7727 - 5659))) then
				return "avengers_shield standard 14";
			end
		end
		if (((5537 - 3423) > (4701 - 3757)) and v42 and ((v48 and v31) or not v48) and v95.DivineToll:IsReady()) then
			if (v24(v95.DivineToll, not v16:IsInRange(2 + 28)) or ((8215 - 5953) >= (1100 + 1996))) then
				return "divine_toll standard 16";
			end
		end
		if ((v95.AvengersShield:IsCastable() and v33) or ((989 + 1266) >= (10496 - 6959))) then
			if (v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield)) or ((2100 + 1737) < (2401 - 1095))) then
				return "avengers_shield standard 18";
			end
		end
		if (((1951 + 999) == (1641 + 1309)) and v95.HammerofWrath:IsReady() and v38) then
			if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((3394 + 1329) < (2770 + 528))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if (((1112 + 24) >= (587 - (153 + 280))) and v95.Judgment:IsReady() and v39) then
			if (v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment)) or ((782 - 511) > (4263 + 485))) then
				return "judgment standard 22";
			end
		end
		if (((1872 + 2868) >= (1650 + 1502)) and v95.Consecration:IsCastable() and v35 and v14:BuffDown(v95.ConsecrationBuff) and ((v14:BuffStack(v95.SanctificationBuff) < (5 + 0)) or not v14:HasTier(23 + 8, 2 - 0))) then
			if (v24(v95.Consecration, not v16:IsInRange(5 + 3)) or ((3245 - (89 + 578)) >= (2422 + 968))) then
				return "consecration standard 24";
			end
		end
		if (((85 - 44) <= (2710 - (572 + 477))) and (v83 < FightRemains) and v43 and ((v49 and v31) or not v49) and v95.EyeofTyr:IsCastable() and v95.InmostLight:IsAvailable() and (v103 >= (1 + 2))) then
			if (((361 + 240) < (425 + 3135)) and v24(v95.EyeofTyr, not v16:IsInRange(94 - (84 + 2)))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((387 - 152) < (495 + 192)) and v95.BlessedHammer:IsCastable() and v34) then
			if (((5391 - (497 + 345)) > (30 + 1123)) and v24(v95.BlessedHammer, not v16:IsInRange(2 + 6))) then
				return "blessed_hammer standard 28";
			end
		end
		if ((v95.HammeroftheRighteous:IsCastable() and v37) or ((6007 - (605 + 728)) < (3334 + 1338))) then
			if (((8154 - 4486) < (210 + 4351)) and v24(v95.HammeroftheRighteous, not v16:IsInRange(29 - 21))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if ((v95.CrusaderStrike:IsCastable() and v36) or ((411 + 44) == (9987 - 6382))) then
			if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((2011 + 652) == (3801 - (457 + 32)))) then
				return "crusader_strike standard 32";
			end
		end
		if (((1815 + 2462) <= (5877 - (832 + 570))) and (v83 < FightRemains) and v43 and ((v49 and v31) or not v49) and v95.EyeofTyr:IsCastable() and not v95.InmostLight:IsAvailable()) then
			if (v24(v95.EyeofTyr, not v16:IsInRange(8 + 0)) or ((227 + 643) == (4207 - 3018))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((749 + 804) <= (3929 - (588 + 208))) and v95.ArcaneTorrent:IsCastable() and v86 and ((v87 and v31) or not v87) and (HolyPower < (13 - 8))) then
			if (v24(v95.ArcaneTorrent, not v16:IsInRange(1808 - (884 + 916))) or ((4682 - 2445) >= (2036 + 1475))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v95.Consecration:IsCastable() and v35 and (v14:BuffDown(v95.SanctificationEmpowerBuff))) or ((1977 - (232 + 421)) > (4909 - (1569 + 320)))) then
			if (v24(v95.Consecration, not v16:IsInRange(2 + 6)) or ((569 + 2423) == (6338 - 4457))) then
				return "consecration standard 38";
			end
		end
	end
	local function v117()
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
	local function v118()
		local v147 = 605 - (316 + 289);
		while true do
			if (((8130 - 5024) > (71 + 1455)) and ((1455 - (666 + 787)) == v147)) then
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v147 = 428 - (360 + 65);
			end
			if (((2826 + 197) < (4124 - (79 + 175))) and ((0 - 0) == v147)) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v147 = 1 + 0;
			end
			if (((437 - 294) > (142 - 68)) and (v147 == (906 - (503 + 396)))) then
				v73 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v74 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v75 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((199 - (92 + 89)) < (4096 - 1984)) and (v147 == (3 + 1))) then
				v64 = EpicSettings.Settings['ardentDefenderHP'];
				v65 = EpicSettings.Settings['divineShieldHP'];
				v66 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v147 = 3 + 2;
			end
			if (((4295 - 3198) <= (223 + 1405)) and (v147 == (6 - 3))) then
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v63 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v147 = 4 + 0;
			end
			if (((2212 + 2418) == (14101 - 9471)) and (v147 == (1 + 0))) then
				v55 = EpicSettings.Settings['useDivineShield'];
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v147 = 2 - 0;
			end
			if (((4784 - (485 + 759)) > (6207 - 3524)) and (v147 == (1195 - (442 + 747)))) then
				v70 = EpicSettings.Settings['layOnHandsFocusHP'];
				v71 = EpicSettings.Settings['wordofGloryFocusHP'];
				v72 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v147 = 1142 - (832 + 303);
			end
			if (((5740 - (88 + 858)) >= (999 + 2276)) and (v147 == (5 + 0))) then
				v67 = EpicSettings.Settings['layonHandsHP'];
				v68 = EpicSettings.Settings['wordofGloryHP'];
				v69 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v147 = 1 + 5;
			end
		end
	end
	local function v119()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (789 - (766 + 23));
		v80 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v82 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['DispelDebuffs'];
		v76 = EpicSettings.Settings['DispelBuffs'];
		v84 = EpicSettings.Settings['useTrinkets'];
		v86 = EpicSettings.Settings['useRacials'];
		v85 = EpicSettings.Settings['trinketsWithCD'];
		v87 = EpicSettings.Settings['racialsWithCD'];
		v89 = EpicSettings.Settings['useHealthstone'];
		v88 = EpicSettings.Settings['useHealingPotion'];
		v91 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v90 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v92 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
		v93 = EpicSettings.Settings['HealOOC'];
		v94 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v120()
		v118();
		v117();
		v119();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		if (((5036 - 3552) == (2557 - (1036 + 37))) and v14:IsDeadOrGhost()) then
			return;
		end
		v101 = v14:GetEnemiesInMeleeRange(8 + 2);
		v102 = v14:GetEnemiesInRange(58 - 28);
		if (((1127 + 305) < (5035 - (641 + 839))) and v30) then
			v103 = #v101;
			v104 = #v102;
		else
			v103 = 914 - (910 + 3);
			v104 = 2 - 1;
		end
		v99 = v14:ActiveMitigationNeeded();
		v100 = v14:IsTankingAoE(1692 - (1466 + 218)) or v14:IsTanking(v16);
		if ((not v14:AffectingCombat() and v14:IsMounted()) or ((490 + 575) > (4726 - (556 + 592)))) then
			if ((v95.CrusaderAura:IsCastable() and (v14:BuffDown(v95.CrusaderAura))) or ((1706 + 3089) < (2215 - (329 + 479)))) then
				if (((2707 - (174 + 680)) < (16538 - 11725)) and v24(v95.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (v14:AffectingCombat() or v77 or ((5846 - 3025) < (1736 + 695))) then
			local v168 = v77 and v95.CleanseToxins:IsReady() and v32;
			v28 = v105.FocusUnit(v168, v97, 759 - (396 + 343), nil, 3 + 22);
			if (v28 or ((4351 - (29 + 1448)) < (3570 - (135 + 1254)))) then
				return v28;
			end
		end
		local v166 = v105.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 150 - 110, 116 - 91);
		if (v166 or ((1793 + 896) <= (1870 - (389 + 1138)))) then
			return v166;
		end
		if ((v95.BlessingofFreedom:IsReady() and v105.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((2443 - (102 + 472)) == (1896 + 113))) then
			if (v24(v97.BlessingofFreedomFocus) or ((1967 + 1579) < (2166 + 156))) then
				return "blessing_of_freedom combat";
			end
		end
		if (v105.TargetIsValid() or v14:AffectingCombat() or ((3627 - (320 + 1225)) == (8496 - 3723))) then
			BossFightRemains = v9.BossFightRemains(nil, true);
			FightRemains = BossFightRemains;
			if (((1985 + 1259) > (2519 - (157 + 1307))) and (FightRemains == (12970 - (821 + 1038)))) then
				FightRemains = v9.FightRemains(v101, false);
			end
		end
		if (not v14:AffectingCombat() or ((8265 - 4952) <= (195 + 1583))) then
			if ((v95.DevotionAura:IsCastable() and (v108())) or ((2523 - 1102) >= (783 + 1321))) then
				if (((4490 - 2678) <= (4275 - (834 + 192))) and v24(v95.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (((104 + 1519) <= (503 + 1454)) and v78) then
			if (((95 + 4317) == (6834 - 2422)) and v74) then
				v166 = v105.HandleAfflicted(v95.CleanseToxins, v97.CleanseToxinsMouseover, 344 - (300 + 4));
				if (((468 + 1282) >= (2203 - 1361)) and v166) then
					return v166;
				end
			end
			if (((4734 - (112 + 250)) > (738 + 1112)) and v14:BuffUp(v95.ShiningLightFreeBuff) and v75) then
				v166 = v105.HandleAfflicted(v95.WordofGlory, v97.WordofGloryMouseover, 100 - 60, true);
				if (((133 + 99) < (425 + 396)) and v166) then
					return v166;
				end
			end
		end
		if (((388 + 130) < (448 + 454)) and v79) then
			v166 = v105.HandleIncorporeal(v95.Repentance, v97.RepentanceMouseOver, 23 + 7, true);
			if (((4408 - (1001 + 413)) > (1913 - 1055)) and v166) then
				return v166;
			end
			v166 = v105.HandleIncorporeal(v95.TurnEvil, v97.TurnEvilMouseOver, 912 - (244 + 638), true);
			if (v166 or ((4448 - (627 + 66)) <= (2726 - 1811))) then
				return v166;
			end
		end
		v166 = v110();
		if (((4548 - (512 + 90)) > (5649 - (1665 + 241))) and v166) then
			return v166;
		end
		if (v13 or ((2052 - (373 + 344)) >= (1492 + 1814))) then
			if (((1282 + 3562) > (5942 - 3689)) and v77) then
				local v195 = 0 - 0;
				while true do
					if (((1551 - (35 + 1064)) == (329 + 123)) and (v195 == (0 - 0))) then
						v166 = v109();
						if (v166 or ((19 + 4538) < (3323 - (298 + 938)))) then
							return v166;
						end
						break;
					end
				end
			end
		end
		v166 = v113();
		if (((5133 - (233 + 1026)) == (5540 - (636 + 1030))) and v166) then
			return v166;
		end
		if ((v95.Redemption:IsCastable() and v95.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((991 + 947) > (4821 + 114))) then
			if (v24(v97.RedemptionMouseover) or ((1264 + 2991) < (232 + 3191))) then
				return "redemption mouseover";
			end
		end
		if (((1675 - (55 + 166)) <= (483 + 2008)) and v14:AffectingCombat()) then
			if ((v95.Intercession:IsCastable() and (v14:HolyPower() >= (1 + 2)) and v95.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((15875 - 11718) <= (3100 - (36 + 261)))) then
				if (((8486 - 3633) >= (4350 - (34 + 1334))) and v24(v97.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if (((1590 + 2544) > (2609 + 748)) and v105.TargetIsValid() and not v14:AffectingCombat() and v29) then
			local v169 = 1283 - (1035 + 248);
			while true do
				if ((v169 == (21 - (20 + 1))) or ((1781 + 1636) < (2853 - (134 + 185)))) then
					v166 = v114();
					if (v166 or ((3855 - (549 + 584)) <= (849 - (314 + 371)))) then
						return v166;
					end
					break;
				end
			end
		end
		if (v105.TargetIsValid() or ((8266 - 5858) < (3077 - (478 + 490)))) then
			local v170 = 0 + 0;
			while true do
				if ((v170 == (1172 - (786 + 386))) or ((106 - 73) == (2834 - (1055 + 324)))) then
					if ((v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((1783 - (1093 + 247)) >= (3568 + 447))) then
						if (((356 + 3026) > (659 - 493)) and v14:AffectingCombat()) then
							if (v95.Intercession:IsCastable() or ((950 - 670) == (8703 - 5644))) then
								if (((4726 - 2845) > (460 + 833)) and v24(v95.Intercession, not v16:IsInRange(115 - 85), true)) then
									return "intercession";
								end
							end
						elseif (((8124 - 5767) == (1778 + 579)) and v95.Redemption:IsCastable()) then
							if (((314 - 191) == (811 - (364 + 324))) and v24(v95.Redemption, not v16:IsInRange(82 - 52), true)) then
								return "redemption";
							end
						end
					end
					if ((v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((2533 - 1477) >= (1125 + 2267))) then
						local v197 = 0 - 0;
						while true do
							if ((v197 == (0 - 0)) or ((3283 - 2202) < (2343 - (1249 + 19)))) then
								if (v100 or ((947 + 102) >= (17251 - 12819))) then
									local v198 = 1086 - (686 + 400);
									while true do
										if ((v198 == (0 + 0)) or ((4997 - (73 + 156)) <= (5 + 841))) then
											v166 = v112();
											if (v166 or ((4169 - (721 + 90)) <= (16 + 1404))) then
												return v166;
											end
											break;
										end
									end
								end
								if ((v83 < FightRemains) or ((12139 - 8400) <= (3475 - (224 + 246)))) then
									v166 = v115();
									if (v166 or ((2686 - 1027) >= (3928 - 1794))) then
										return v166;
									end
								end
								v197 = 1 + 0;
							end
							if ((v197 == (1 + 0)) or ((2395 + 865) < (4682 - 2327))) then
								if ((v84 and ((v31 and v85) or not v85) and v16:IsInRange(26 - 18)) or ((1182 - (203 + 310)) == (6216 - (1238 + 755)))) then
									local v199 = 0 + 0;
									while true do
										if ((v199 == (1534 - (709 + 825))) or ((3117 - 1425) < (856 - 268))) then
											v166 = v111();
											if (v166 or ((5661 - (196 + 668)) < (14415 - 10764))) then
												return v166;
											end
											break;
										end
									end
								end
								v166 = v116();
								v197 = 3 - 1;
							end
							if ((v197 == (835 - (171 + 662))) or ((4270 - (4 + 89)) > (16999 - 12149))) then
								if (v166 or ((146 + 254) > (4879 - 3768))) then
									return v166;
								end
								if (((1197 + 1854) > (2491 - (35 + 1451))) and v24(v95.Pool)) then
									return "Wait/Pool Resources";
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		v20.Print("Protection Paladin by Epic. Supported by xKaneto");
		v106();
	end
	v20.SetAPL(1519 - (28 + 1425), v120, v121);
end;
return v0["Epix_Paladin_Protection.lua"]();

