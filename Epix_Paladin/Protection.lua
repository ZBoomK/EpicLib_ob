local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((509 + 1063) > (1530 + 1)) and not v5) then
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
	local v110 = 5982 + 5129;
	local v111 = 11873 - (418 + 344);
	local v112 = 326 - (192 + 134);
	v9:RegisterForEvent(function()
		local v130 = 1276 - (316 + 960);
		while true do
			if ((v130 == (0 + 0)) or ((3618 + 1069) < (4199 + 343))) then
				v110 = 42477 - 31366;
				v111 = 11662 - (83 + 468);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (((5097 - (1202 + 604)) > (7781 - 6114)) and v99.CleanseToxins:IsAvailable()) then
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
		if ((v99.CleanseToxins:IsReady() and (v109.UnitHasDispellableDebuffByPlayer(v13) or v109.DispellableFriendlyUnit(69 - 44) or v109.UnitHasCurseDebuff(v13) or v109.UnitHasPoisonDebuff(v13))) or ((1198 - (45 + 280)) == (1964 + 70))) then
			if ((v116 == (0 + 0)) or ((1029 + 1787) < (7 + 4))) then
				v116 = GetTime();
			end
			if (((651 + 3048) < (8714 - 4008)) and v109.Wait(2411 - (340 + 1571), v116)) then
				if (((1044 + 1602) >= (2648 - (1733 + 39))) and v24(v101.CleanseToxinsFocus)) then
					return "cleanse_toxins dispel";
				end
				v116 = 0 - 0;
			end
		end
	end
	local function v118()
		if (((1648 - (125 + 909)) <= (5132 - (1096 + 852))) and v97 and (v14:HealthPercentage() <= v98)) then
			if (((1403 + 1723) == (4463 - 1337)) and v99.FlashofLight:IsReady()) then
				if (v24(v99.FlashofLight) or ((2122 + 65) >= (5466 - (409 + 103)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		v28 = v109.HandleTopTrinket(v102, v31, 276 - (46 + 190), nil);
		if (v28 or ((3972 - (51 + 44)) == (1009 + 2566))) then
			return v28;
		end
		v28 = v109.HandleBottomTrinket(v102, v31, 1357 - (1114 + 203), nil);
		if (((1433 - (228 + 498)) > (137 + 495)) and v28) then
			return v28;
		end
	end
	local function v120()
		if (((v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((302 + 244) >= (3347 - (174 + 489)))) then
			if (((3816 - 2351) <= (6206 - (830 + 1075))) and v24(v99.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((2228 - (303 + 221)) > (2694 - (231 + 1038))) and (v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
			if (v24(v101.LayonHandsPlayer) or ((573 + 114) == (5396 - (171 + 991)))) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) or ((13723 - 10393) < (3836 - 2407))) then
			if (((2862 - 1715) >= (269 + 66)) and v24(v99.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((12040 - 8605) > (6049 - 3952)) and v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) then
			if (v24(v99.ArdentDefender) or ((6077 - 2307) >= (12491 - 8450))) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((5039 - (111 + 1137)) <= (1769 - (91 + 67)))) then
			if ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (14 - 9)) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff) or ((1143 + 3435) <= (2531 - (423 + 100)))) then
				if (((8 + 1117) <= (5747 - 3671)) and v24(v101.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (2 + 0)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) or ((1514 - (326 + 445)) >= (19197 - 14798))) then
			if (((2572 - 1417) < (3904 - 2231)) and v24(v99.ShieldoftheRighteous)) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((3035 - (530 + 181)) <= (1459 - (614 + 267)))) then
			if (((3799 - (19 + 13)) == (6131 - 2364)) and v24(v101.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((9528 - 5439) == (11680 - 7591)) and v92 and (v14:HealthPercentage() <= v94)) then
			if (((1158 + 3300) >= (2943 - 1269)) and (v96 == "Refreshing Healing Potion")) then
				if (((2015 - 1043) <= (3230 - (1293 + 519))) and v100.RefreshingHealingPotion:IsReady()) then
					if (v24(v101.RefreshingHealingPotion) or ((10074 - 5136) < (12433 - 7671))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v96 == "Dreamwalker's Healing Potion") or ((4787 - 2283) > (18386 - 14122))) then
				if (((5071 - 2918) == (1141 + 1012)) and v100.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v101.RefreshingHealingPotion) or ((104 + 403) >= (6020 - 3429))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v121()
		local v132 = 0 + 0;
		while true do
			if (((1489 + 2992) == (2801 + 1680)) and (v132 == (1097 - (709 + 387)))) then
				if (v13 or ((4186 - (673 + 1185)) < (2009 - 1316))) then
					if (((13897 - 9569) == (7120 - 2792)) and v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (3 + 0))) and (v13:HealthPercentage() <= v74)) then
						if (((1187 + 401) >= (1797 - 465)) and v24(v101.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73) and v14:AffectingCombat()) or ((1026 + 3148) > (8470 - 4222))) then
						if (v24(v101.LayonHandsFocus) or ((9001 - 4415) <= (1962 - (446 + 1434)))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((5146 - (1040 + 243)) == (11529 - 7666)) and v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) then
						if (v24(v101.BlessingofSacrificeFocus) or ((2129 - (559 + 1288)) <= (1973 - (609 + 1322)))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((5063 - (13 + 441)) >= (2862 - 2096)) and v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) then
						if (v24(v101.BlessingofProtectionFocus) or ((3017 - 1865) == (12391 - 9903))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((128 + 3294) > (12166 - 8816)) and (v132 == (0 + 0))) then
				if (((385 + 492) > (1115 - 739)) and v15:Exists()) then
					if ((v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) or ((1707 + 1411) <= (3404 - 1553))) then
						if (v24(v101.WordofGloryMouseover) or ((110 + 55) >= (1943 + 1549))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((2838 + 1111) < (4078 + 778)) and (not v13 or not v13:Exists() or not v13:IsInRange(30 + 0))) then
					return;
				end
				v132 = 434 - (153 + 280);
			end
		end
	end
	local function v122()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (1 + 0)) or ((1689 + 2587) < (1579 + 1437))) then
				if (((4257 + 433) > (2989 + 1136)) and v99.Consecration:IsCastable() and v37) then
					if (v24(v99.Consecration, not v16:IsInRange(11 - 3)) or ((31 + 19) >= (1563 - (89 + 578)))) then
						return "consecration precombat 8";
					end
				end
				if ((v99.AvengersShield:IsCastable() and v35) or ((1225 + 489) >= (6149 - 3191))) then
					local v207 = 1049 - (572 + 477);
					while true do
						if ((v207 == (0 + 0)) or ((895 + 596) < (77 + 567))) then
							if (((790 - (84 + 2)) < (1625 - 638)) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) then
								if (((2679 + 1039) > (2748 - (497 + 345))) and v24(v101.AvengersShieldMouseover)) then
									return "avengers_shield mouseover precombat 10";
								end
							end
							if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((25 + 933) > (615 + 3020))) then
								return "avengers_shield precombat 10";
							end
							break;
						end
					end
				end
				v133 = 1335 - (605 + 728);
			end
			if (((2498 + 1003) <= (9986 - 5494)) and (v133 == (1 + 1))) then
				if ((v99.Judgment:IsReady() and v41) or ((12725 - 9283) < (2298 + 250))) then
					if (((7965 - 5090) >= (1106 + 358)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v133 == (489 - (457 + 32))) or ((2036 + 2761) >= (6295 - (832 + 570)))) then
				if (((v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) or ((520 + 31) > (540 + 1528))) then
					if (((7480 - 5366) > (455 + 489)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (801 - (588 + 208)))) or ((6096 - 3834) >= (4896 - (884 + 916)))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(16 - 8)) or ((1308 + 947) >= (4190 - (232 + 421)))) then
						return "arcane_torrent precombat 6";
					end
				end
				v133 = 1890 - (1569 + 320);
			end
		end
	end
	local function v123()
		local v134 = 0 + 0;
		local v135;
		while true do
			if (((1 + 1) == v134) or ((12929 - 9092) < (1911 - (316 + 289)))) then
				v135 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
				if (((7722 - 4772) == (137 + 2813)) and v135) then
					return v135;
				end
				v134 = 1456 - (666 + 787);
			end
			if (((425 - (360 + 65)) == v134) or ((4414 + 309) < (3552 - (79 + 175)))) then
				if (((1791 - 655) >= (121 + 33)) and v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (5 - 3)) and v14:HasTier(55 - 26, 901 - (503 + 396))) then
					local v208 = 181 - (92 + 89);
					while true do
						if ((v208 == (0 - 0)) or ((139 + 132) > (2811 + 1937))) then
							if (((18562 - 13822) >= (432 + 2720)) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) then
								if (v24(v101.AvengersShieldMouseover) or ((5877 - 3299) >= (2958 + 432))) then
									return "avengers_shield mouseover cooldowns 2";
								end
							end
							if (((20 + 21) <= (5058 - 3397)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
								return "avengers_shield cooldowns 2";
							end
							break;
						end
					end
				end
				if (((76 + 525) < (5429 - 1869)) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (1246 - (485 + 759)))) then
					if (((543 - 308) < (1876 - (442 + 747))) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v134 = 1136 - (832 + 303);
			end
			if (((5495 - (88 + 858)) > (352 + 801)) and (v134 == (4 + 0))) then
				if ((v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (2 + 28)))) or ((5463 - (766 + 23)) < (23064 - 18392))) then
					if (((5016 - 1348) < (12016 - 7455)) and v24(v99.BastionofLight, not v16:IsInRange(27 - 19))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v134 == (1074 - (1036 + 37))) or ((323 + 132) == (7020 - 3415))) then
				if ((v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) or ((2095 + 568) == (4792 - (641 + 839)))) then
					if (((5190 - (910 + 3)) <= (11408 - 6933)) and v24(v99.AvengingWrath, not v16:IsInRange(1692 - (1466 + 218)))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) or ((400 + 470) == (2337 - (556 + 592)))) then
					if (((553 + 1000) <= (3941 - (329 + 479))) and v24(v99.Sentinel, not v16:IsInRange(862 - (174 + 680)))) then
						return "sentinel cooldowns 8";
					end
				end
				v134 = 6 - 4;
			end
			if ((v134 == (5 - 2)) or ((1598 + 639) >= (4250 - (396 + 343)))) then
				if ((v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (2 + 13)) or (((v9.CombatTime() > (1487 - (29 + 1448))) or (v99.Sentinel:CooldownRemains() > (1404 - (135 + 1254))) or (v99.AvengingWrath:CooldownRemains() > (56 - 41))) and (v99.AvengersShield:CooldownRemains() > (0 - 0)) and (v99.Judgment:CooldownRemains() > (0 + 0)) and (v99.HammerofWrath:CooldownRemains() > (1527 - (389 + 1138)))))) or ((1898 - (102 + 472)) > (2850 + 170))) then
					if (v24(v99.MomentOfGlory, not v16:IsInRange(5 + 3)) or ((2790 + 202) == (3426 - (320 + 1225)))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((5528 - 2422) > (934 + 592)) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (1467 - (157 + 1307)))) then
					if (((4882 - (821 + 1038)) < (9655 - 5785)) and v24(v99.DivineToll, not v16:IsInRange(4 + 26))) then
						return "divine_toll cooldowns 12";
					end
				end
				v134 = 6 - 2;
			end
		end
	end
	local function v124()
		local v136 = 0 + 0;
		while true do
			if (((354 - 211) > (1100 - (834 + 192))) and (v136 == (1 + 1))) then
				if (((5 + 13) < (46 + 2066)) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (2 - 0)) or v14:BuffUp(v99.MomentOfGloryBuff))) then
					local v209 = 304 - (300 + 4);
					while true do
						if (((293 + 804) <= (4261 - 2633)) and ((362 - (112 + 250)) == v209)) then
							if (((1846 + 2784) == (11599 - 6969)) and v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) then
								if (((2028 + 1512) > (1388 + 1295)) and v24(v101.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 14";
								end
							end
							if (((3586 + 1208) >= (1624 + 1651)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
								return "avengers_shield standard 14";
							end
							break;
						end
					end
				end
				if (((1103 + 381) == (2898 - (1001 + 413))) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) then
					if (((3193 - 1761) < (4437 - (244 + 638))) and v24(v99.DivineToll, not v16:IsInRange(723 - (627 + 66)))) then
						return "divine_toll standard 16";
					end
				end
				if ((v99.AvengersShield:IsCastable() and v35) or ((3173 - 2108) > (4180 - (512 + 90)))) then
					if ((v15:Exists() and v15 and v14:CanAttack(v15) and v15:IsSpellInRange(v99.AvengersShield)) or ((6701 - (1665 + 241)) < (2124 - (373 + 344)))) then
						if (((836 + 1017) < (1274 + 3539)) and v24(v101.AvengersShieldMouseover)) then
							return "avengers_shield mouseover standard 18";
						end
					end
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((7440 - 4619) < (4113 - 1682))) then
						return "avengers_shield standard 18";
					end
				end
				v136 = 1102 - (35 + 1064);
			end
			if ((v136 == (0 + 0)) or ((6148 - 3274) < (9 + 2172))) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (1241 - (298 + 938)))) or ((3948 - (233 + 1026)) <= (2009 - (636 + 1030)))) then
					if (v24(v99.Consecration, not v16:IsInRange(5 + 3)) or ((1826 + 43) == (597 + 1412))) then
						return "consecration standard 2";
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (1 + 1)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (226 - (55 + 166))))) or ((688 + 2858) < (234 + 2088))) then
					if (v24(v99.ShieldoftheRighteous) or ((7951 - 5869) == (5070 - (36 + 261)))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((5673 - 2429) > (2423 - (34 + 1334))) and v99.Judgment:IsReady() and v41 and (v107 > (2 + 1)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (3 + 0)) and (v14:HolyPower() < (1286 - (1035 + 248)))) then
					local v210 = 21 - (20 + 1);
					while true do
						if ((v210 == (0 + 0)) or ((3632 - (134 + 185)) <= (2911 - (549 + 584)))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((2106 - (314 + 371)) >= (7222 - 5118))) then
								return "judgment standard 6";
							end
							if (((2780 - (478 + 490)) <= (1722 + 1527)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v136 = 1173 - (786 + 386);
			end
			if (((5256 - 3633) <= (3336 - (1055 + 324))) and (v136 == (1345 - (1093 + 247)))) then
				if (((3921 + 491) == (464 + 3948)) and v99.CrusaderStrike:IsCastable() and v38) then
					if (((6947 - 5197) >= (2857 - 2015)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((12440 - 8068) > (4648 - 2798)) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) then
					if (((83 + 149) < (3162 - 2341)) and v24(v99.EyeofTyr, not v16:IsInRange(27 - 19))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((391 + 127) < (2306 - 1404)) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (693 - (364 + 324)))) then
					if (((8207 - 5213) > (2058 - 1200)) and v24(v99.ArcaneTorrent, not v16:IsInRange(3 + 5))) then
						return "arcane_torrent standard 36";
					end
				end
				v136 = 24 - 18;
			end
			if ((v136 == (9 - 3)) or ((11404 - 7649) <= (2183 - (1249 + 19)))) then
				if (((3562 + 384) > (14569 - 10826)) and v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) then
					if (v24(v99.Consecration, not v16:IsInRange(1094 - (686 + 400))) or ((1048 + 287) >= (3535 - (73 + 156)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((23 + 4821) > (3064 - (721 + 90))) and (v136 == (1 + 3))) then
				if (((1467 - 1015) == (922 - (224 + 246))) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (4 - 1))) then
					if (v24(v99.EyeofTyr, not v16:IsInRange(14 - 6)) or ((827 + 3730) < (50 + 2037))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((2846 + 1028) == (7701 - 3827)) and v99.BlessedHammer:IsCastable() and v36) then
					if (v24(v99.BlessedHammer, not v16:IsInRange(26 - 18)) or ((2451 - (203 + 310)) > (6928 - (1238 + 755)))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v99.HammeroftheRighteous:IsCastable() and v39) or ((298 + 3957) < (4957 - (709 + 825)))) then
					if (((2679 - 1225) <= (3628 - 1137)) and v24(v99.HammeroftheRighteous, not v16:IsInRange(872 - (196 + 668)))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v136 = 19 - 14;
			end
			if ((v136 == (1 - 0)) or ((4990 - (171 + 662)) <= (2896 - (4 + 89)))) then
				if (((17009 - 12156) >= (1086 + 1896)) and v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(136 - 105, 1 + 1)) then
					local v211 = 1486 - (35 + 1451);
					while true do
						if (((5587 - (28 + 1425)) > (5350 - (941 + 1052))) and (v211 == (0 + 0))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((4931 - (822 + 692)) < (3617 - 1083))) then
								return "judgment standard 8";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((1283 + 1439) <= (461 - (45 + 252)))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v99.HammerofWrath:IsReady() and v40) or ((2383 + 25) < (726 + 1383))) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((80 - 47) == (1888 - (114 + 319)))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (2 - 0)) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((567 - 124) >= (2560 + 1455))) then
					if (((5037 - 1655) > (347 - 181)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 12";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((2243 - (556 + 1407)) == (4265 - (741 + 465)))) then
						return "judgment standard 12";
					end
				end
				v136 = 467 - (170 + 295);
			end
			if (((992 + 889) > (1188 + 105)) and (v136 == (7 - 4))) then
				if (((1954 + 403) == (1512 + 845)) and v99.HammerofWrath:IsReady() and v40) then
					if (((70 + 53) == (1353 - (957 + 273))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v99.Judgment:IsReady() and v41) or ((283 + 773) >= (1358 + 2034))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((4119 - 3038) < (2832 - 1757))) then
						return "judgment standard 22";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((3203 - 2154) >= (21945 - 17513))) then
						return "judgment standard 22";
					end
				end
				if ((v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (1785 - (389 + 1391))) or not v14:HasTier(20 + 11, 1 + 1))) or ((10854 - 6086) <= (1797 - (783 + 168)))) then
					if (v24(v99.Consecration, not v16:IsInRange(26 - 18)) or ((3304 + 54) <= (1731 - (309 + 2)))) then
						return "consecration standard 24";
					end
				end
				v136 = 12 - 8;
			end
		end
	end
	local function v125()
		local v137 = 1212 - (1090 + 122);
		while true do
			if ((v137 == (1 + 0)) or ((12557 - 8818) <= (2057 + 948))) then
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v39 = EpicSettings.Settings['useHammeroftheRighteous'];
				v40 = EpicSettings.Settings['useHammerofWrath'];
				v137 = 1120 - (628 + 490);
			end
			if ((v137 == (0 + 0)) or ((4107 - 2448) >= (9752 - 7618))) then
				v33 = EpicSettings.Settings['swapAuras'];
				v34 = EpicSettings.Settings['useWeapon'];
				v35 = EpicSettings.Settings['useAvengersShield'];
				v36 = EpicSettings.Settings['useBlessedHammer'];
				v137 = 775 - (431 + 343);
			end
			if ((v137 == (5 - 2)) or ((9431 - 6171) < (1861 + 494))) then
				v45 = EpicSettings.Settings['useEyeofTyr'];
				v46 = EpicSettings.Settings['useMomentOfGlory'];
				v47 = EpicSettings.Settings['useSentinel'];
				v48 = EpicSettings.Settings['avengingWrathWithCD'];
				v137 = 1 + 3;
			end
			if ((v137 == (1700 - (556 + 1139))) or ((684 - (6 + 9)) == (774 + 3449))) then
				v53 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v137 == (2 + 0)) or ((1861 - (28 + 141)) < (228 + 360))) then
				v41 = EpicSettings.Settings['useJudgment'];
				v42 = EpicSettings.Settings['useAvengingWrath'];
				v43 = EpicSettings.Settings['useBastionofLight'];
				v44 = EpicSettings.Settings['useDivineToll'];
				v137 = 3 - 0;
			end
			if ((v137 == (3 + 1)) or ((6114 - (486 + 831)) < (9500 - 5849))) then
				v49 = EpicSettings.Settings['bastionofLightWithCD'];
				v50 = EpicSettings.Settings['divineTollWithCD'];
				v51 = EpicSettings.Settings['eyeofTyrWithCD'];
				v52 = EpicSettings.Settings['momentOfGloryWithCD'];
				v137 = 17 - 12;
			end
		end
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
		local v164 = 0 + 0;
		while true do
			if ((v164 == (9 - 6)) or ((5440 - (668 + 595)) > (4365 + 485))) then
				v91 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v164 = 1 + 3;
			end
			if ((v164 == (16 - 10)) or ((690 - (23 + 267)) > (3055 - (1129 + 815)))) then
				v98 = EpicSettings.Settings['HealOOCHP'] or (387 - (371 + 16));
				break;
			end
			if (((4801 - (1326 + 424)) > (1903 - 898)) and (v164 == (14 - 10))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (118 - (88 + 30));
				v94 = EpicSettings.Settings['healingPotionHP'] or (771 - (720 + 51));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v164 = 11 - 6;
			end
			if (((5469 - (421 + 1355)) <= (7228 - 2846)) and (v164 == (1 + 0))) then
				v86 = EpicSettings.Settings['InterruptThreshold'];
				v81 = EpicSettings.Settings['DispelDebuffs'];
				v80 = EpicSettings.Settings['DispelBuffs'];
				v164 = 1085 - (286 + 797);
			end
			if ((v164 == (0 - 0)) or ((5435 - 2153) > (4539 - (397 + 42)))) then
				v87 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v84 = EpicSettings.Settings['InterruptWithStun'];
				v85 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v164 = 801 - (24 + 776);
			end
			if ((v164 == (2 - 0)) or ((4365 - (222 + 563)) < (6265 - 3421))) then
				v88 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v89 = EpicSettings.Settings['trinketsWithCD'];
				v164 = 3 + 0;
			end
			if (((279 - (23 + 167)) < (6288 - (690 + 1108))) and (v164 == (2 + 3))) then
				v82 = EpicSettings.Settings['handleAfflicted'];
				v83 = EpicSettings.Settings['HandleIncorporeal'];
				v97 = EpicSettings.Settings['HealOOC'];
				v164 = 5 + 1;
			end
		end
	end
	local function v128()
		local v165 = 848 - (40 + 808);
		while true do
			if ((v165 == (0 + 0)) or ((19054 - 14071) < (1729 + 79))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v165 = 1 + 0;
			end
			if (((2100 + 1729) > (4340 - (47 + 524))) and (v165 == (2 + 0))) then
				if (((4059 - 2574) <= (4341 - 1437)) and v30) then
					local v212 = 0 - 0;
					while true do
						if (((5995 - (1165 + 561)) == (127 + 4142)) and (v212 == (0 - 0))) then
							v107 = #v105;
							v108 = #v106;
							break;
						end
					end
				else
					v107 = 1 + 0;
					v108 = 480 - (341 + 138);
				end
				v103 = v14:ActiveMitigationNeeded();
				v104 = v14:IsTankingAoE(3 + 5) or v14:IsTanking(v16);
				if (((798 - 411) <= (3108 - (89 + 237))) and not v14:AffectingCombat() and v14:IsMounted()) then
					if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) or ((6108 - 4209) <= (1930 - 1013))) then
						if (v24(v99.CrusaderAura) or ((5193 - (581 + 300)) <= (2096 - (855 + 365)))) then
							return "crusader_aura";
						end
					end
				end
				if (((5301 - 3069) <= (848 + 1748)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (((3330 - (1030 + 205)) < (3461 + 225)) and v14:AffectingCombat()) then
						if (v99.Intercession:IsCastable() or ((1484 + 111) >= (4760 - (156 + 130)))) then
							if (v24(v99.Intercession, not v16:IsInRange(68 - 38), true) or ((7784 - 3165) < (5902 - 3020))) then
								return "intercession target";
							end
						end
					elseif (v99.Redemption:IsCastable() or ((78 + 216) >= (2818 + 2013))) then
						if (((2098 - (10 + 59)) <= (873 + 2211)) and v24(v99.Redemption, not v16:IsInRange(147 - 117), true)) then
							return "redemption target";
						end
					end
				end
				v165 = 1166 - (671 + 492);
			end
			if ((v165 == (3 + 0)) or ((3252 - (369 + 846)) == (641 + 1779))) then
				if (((3805 + 653) > (5849 - (1036 + 909))) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((347 + 89) >= (206 - 83)) and v24(v101.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((703 - (11 + 192)) < (918 + 898)) and v14:AffectingCombat()) then
					if (((3749 - (135 + 40)) == (8659 - 5085)) and v99.Intercession:IsCastable() and (v14:HolyPower() >= (2 + 1)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (((486 - 265) < (584 - 194)) and v24(v101.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((2389 - (50 + 126)) <= (3956 - 2535))) then
					local v213 = 0 + 0;
					local v214;
					while true do
						if (((4471 - (1233 + 180)) < (5829 - (522 + 447))) and ((1421 - (107 + 1314)) == v213)) then
							v214 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v214, nil, 10 + 10, nil, 76 - 51, v99.FlashofLight);
							v213 = 1 + 0;
						end
						if ((v213 == (1 - 0)) or ((5127 - 3831) >= (6356 - (716 + 1194)))) then
							if (v28 or ((24 + 1369) > (481 + 4008))) then
								return v28;
							end
							break;
						end
					end
				end
				if ((v32 and v81) or ((4927 - (74 + 429)) < (51 - 24))) then
					local v215 = 0 + 0;
					while true do
						if (((2 - 1) == v215) or ((1413 + 584) > (11761 - 7946))) then
							if (((8567 - 5102) > (2346 - (279 + 154))) and v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
								if (((1511 - (454 + 324)) < (1432 + 387)) and v24(v101.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if ((v215 == (17 - (12 + 5))) or ((2370 + 2025) == (12115 - 7360))) then
							v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 15 + 25, 1118 - (277 + 816), v99.FlashofLight);
							if (v28 or ((16207 - 12414) < (3552 - (1058 + 125)))) then
								return v28;
							end
							v215 = 1 + 0;
						end
					end
				end
				if (v109.TargetIsValid() or v14:AffectingCombat() or ((5059 - (815 + 160)) == (1137 - 872))) then
					local v216 = 0 - 0;
					while true do
						if (((1040 + 3318) == (12739 - 8381)) and ((1899 - (41 + 1857)) == v216)) then
							if ((v111 == (13004 - (1222 + 671))) or ((8110 - 4972) < (1426 - 433))) then
								v111 = v9.FightRemains(v105, false);
							end
							v112 = v14:HolyPower();
							break;
						end
						if (((4512 - (229 + 953)) > (4097 - (1111 + 663))) and (v216 == (1579 - (874 + 705)))) then
							v110 = v9.BossFightRemains(nil, true);
							v111 = v110;
							v216 = 1 + 0;
						end
					end
				end
				v165 = 3 + 1;
			end
			if ((v165 == (12 - 6)) or ((103 + 3523) == (4668 - (642 + 37)))) then
				if ((v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((209 + 707) == (428 + 2243))) then
					local v217 = 0 - 0;
					while true do
						if (((726 - (233 + 221)) == (628 - 356)) and (v217 == (0 + 0))) then
							if (((5790 - (718 + 823)) <= (3046 + 1793)) and (v87 < v111)) then
								local v222 = 805 - (266 + 539);
								while true do
									if (((7862 - 5085) < (4425 - (636 + 589))) and ((0 - 0) == v222)) then
										v28 = v123();
										if (((195 - 100) < (1551 + 406)) and v28) then
											return v28;
										end
										v222 = 1 + 0;
									end
									if (((1841 - (657 + 358)) < (4545 - 2828)) and (v222 == (2 - 1))) then
										if (((2613 - (1151 + 36)) >= (1068 + 37)) and v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) then
											if (((725 + 2029) <= (10091 - 6712)) and v24(v101.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if ((v88 and ((v31 and v89) or not v89) and v16:IsInRange(1840 - (1552 + 280))) or ((4761 - (64 + 770)) == (960 + 453))) then
								local v223 = 0 - 0;
								while true do
									if ((v223 == (0 + 0)) or ((2397 - (157 + 1086)) <= (1577 - 789))) then
										v28 = v119();
										if (v28 or ((7195 - 5552) > (5182 - 1803))) then
											return v28;
										end
										break;
									end
								end
							end
							v217 = 1 - 0;
						end
						if ((v217 == (821 - (599 + 220))) or ((5581 - 2778) > (6480 - (1813 + 118)))) then
							if (v24(v99.Pool) or ((161 + 59) >= (4239 - (841 + 376)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((3953 - 1131) == (656 + 2166)) and (v217 == (2 - 1))) then
							v28 = v124();
							if (v28 or ((1920 - (464 + 395)) == (4765 - 2908))) then
								return v28;
							end
							v217 = 1 + 1;
						end
					end
				end
				break;
			end
			if (((3597 - (467 + 370)) > (2818 - 1454)) and (v165 == (1 + 0))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((16803 - 11901) <= (561 + 3034))) then
					return v28;
				end
				v105 = v14:GetEnemiesInMeleeRange(18 - 10);
				v106 = v14:GetEnemiesInRange(550 - (150 + 370));
				v165 = 1284 - (74 + 1208);
			end
			if ((v165 == (9 - 5)) or ((18268 - 14416) == (209 + 84))) then
				if (not v14:AffectingCombat() or ((1949 - (14 + 376)) == (7957 - 3369))) then
					if ((v99.DevotionAura:IsCastable() and (v115()) and v33) or ((2902 + 1582) == (693 + 95))) then
						if (((4357 + 211) >= (11447 - 7540)) and v24(v99.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (((938 + 308) < (3548 - (23 + 55))) and v82) then
					local v218 = 0 - 0;
					while true do
						if (((2715 + 1353) >= (873 + 99)) and (v218 == (0 - 0))) then
							if (((156 + 337) < (4794 - (652 + 249))) and v78) then
								local v224 = 0 - 0;
								while true do
									if ((v224 == (1868 - (708 + 1160))) or ((3998 - 2525) >= (6074 - 2742))) then
										v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 67 - (10 + 17));
										if (v28 or ((910 + 3141) <= (2889 - (1400 + 332)))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((1158 - 554) < (4789 - (242 + 1666))) and v14:BuffUp(v99.ShiningLightFreeBuff) and v79) then
								v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 18 + 22, true);
								if (v28 or ((330 + 570) == (2879 + 498))) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if (((5399 - (850 + 90)) > (1034 - 443)) and v83) then
					local v219 = 1390 - (360 + 1030);
					while true do
						if (((3008 + 390) >= (6759 - 4364)) and (v219 == (0 - 0))) then
							v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 1691 - (909 + 752), true);
							if (v28 or ((3406 - (109 + 1114)) >= (5169 - 2345))) then
								return v28;
							end
							v219 = 1 + 0;
						end
						if (((2178 - (6 + 236)) == (1220 + 716)) and (v219 == (1 + 0))) then
							v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 70 - 40, true);
							if (v28 or ((8439 - 3607) < (5446 - (1076 + 57)))) then
								return v28;
							end
							break;
						end
					end
				end
				v28 = v118();
				if (((673 + 3415) > (4563 - (579 + 110))) and v28) then
					return v28;
				end
				v165 = 1 + 4;
			end
			if (((3831 + 501) == (2300 + 2032)) and (v165 == (412 - (174 + 233)))) then
				if (((11170 - 7171) >= (5089 - 2189)) and v81 and v32) then
					local v220 = 0 + 0;
					while true do
						if ((v220 == (1174 - (663 + 511))) or ((2253 + 272) > (883 + 3181))) then
							if (((13475 - 9104) == (2647 + 1724)) and v13) then
								local v225 = 0 - 0;
								while true do
									if (((0 - 0) == v225) or ((127 + 139) > (9704 - 4718))) then
										v28 = v117();
										if (((1419 + 572) >= (85 + 840)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (((1177 - (478 + 244)) < (2570 - (440 + 77))) and v15 and v15:Exists() and not v14:CanAttack(v15) and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15) or v109.UnitHasDispellableDebuffByPlayer(v15))) then
								if (v99.CleanseToxins:IsReady() or ((376 + 450) == (17754 - 12903))) then
									if (((1739 - (655 + 901)) == (34 + 149)) and v24(v101.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v121();
				if (((888 + 271) <= (1208 + 580)) and v28) then
					return v28;
				end
				if (v104 or ((14128 - 10621) > (5763 - (695 + 750)))) then
					v28 = v120();
					if (v28 or ((10500 - 7425) <= (4575 - 1610))) then
						return v28;
					end
				end
				if (((5489 - 4124) <= (2362 - (285 + 66))) and v109.TargetIsValid() and not v14:AffectingCombat() and v29) then
					local v221 = 0 - 0;
					while true do
						if (((1310 - (682 + 628)) == v221) or ((448 + 2328) > (3874 - (176 + 123)))) then
							v28 = v122();
							if (v28 or ((1069 + 1485) == (3485 + 1319))) then
								return v28;
							end
							break;
						end
					end
				end
				v165 = 275 - (239 + 30);
			end
		end
	end
	local function v129()
		local v166 = 0 + 0;
		while true do
			if (((2477 + 100) == (4561 - 1984)) and ((0 - 0) == v166)) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v113();
				break;
			end
		end
	end
	v20.SetAPL(381 - (306 + 9), v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

