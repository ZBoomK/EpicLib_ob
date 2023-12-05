local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((14318 - 11415) == (3291 - (503 + 1293)))) then
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
		if (((12696 - 8150) >= (1646 + 629)) and v95.CleanseToxins:IsAvailable()) then
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
		if (((1880 - (810 + 251)) >= (16 + 6)) and v95.CleanseToxins:IsReady() and v32 and v105.DispellableFriendlyUnit(8 + 17)) then
			if (((2851 + 311) == (3695 - (43 + 490))) and v24(v97.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v110()
		if ((v93 and (v14:HealthPercentage() <= v94)) or ((3102 - (711 + 22)) > (17132 - 12703))) then
			if (((4954 - (240 + 619)) >= (769 + 2414)) and v95.FlashofLight:IsReady()) then
				if (v24(v95.FlashofLight) or ((5902 - 2191) < (67 + 941))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v111()
		local v123 = 1744 - (1344 + 400);
		while true do
			if ((v123 == (406 - (255 + 150))) or ((827 + 222) <= (486 + 420))) then
				v28 = v105.HandleBottomTrinket(v98, v31, 170 - 130, nil);
				if (((14576 - 10063) > (4465 - (404 + 1335))) and v28) then
					return v28;
				end
				break;
			end
			if ((v123 == (406 - (183 + 223))) or ((1801 - 320) >= (1762 + 896))) then
				v28 = v105.HandleTopTrinket(v98, v31, 15 + 25, nil);
				if (v28 or ((3557 - (10 + 327)) == (950 + 414))) then
					return v28;
				end
				v123 = 339 - (118 + 220);
			end
		end
	end
	local function v112()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (452 - (108 + 341))) or ((474 + 580) > (14340 - 10948))) then
				if ((v96.Healthstone:IsReady() and v89 and (v14:HealthPercentage() <= v91)) or ((2169 - (711 + 782)) >= (3147 - 1505))) then
					if (((4605 - (270 + 199)) > (778 + 1619)) and v24(v97.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v88 and (v14:HealthPercentage() <= v90)) or ((6153 - (580 + 1239)) == (12619 - 8374))) then
					if ((v92 == "Refreshing Healing Potion") or ((4089 + 187) <= (109 + 2922))) then
						if (v96.RefreshingHealingPotion:IsReady() or ((2084 + 2698) <= (3130 - 1931))) then
							if (v24(v97.RefreshingHealingPotion) or ((3022 + 1842) < (3069 - (645 + 522)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((6629 - (1010 + 780)) >= (3699 + 1)) and (v92 == "Dreamwalker's Healing Potion")) then
						if (v96.DreamwalkersHealingPotion:IsReady() or ((5121 - 4046) > (5620 - 3702))) then
							if (((2232 - (1045 + 791)) <= (9628 - 5824)) and v24(v97.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v124 == (0 - 0)) or ((4674 - (351 + 154)) == (3761 - (1281 + 293)))) then
				if (((1672 - (28 + 238)) == (3141 - 1735)) and (v14:HealthPercentage() <= v65) and v55 and v95.DivineShield:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) then
					if (((3090 - (1381 + 178)) < (4006 + 265)) and v24(v95.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((513 + 122) == (271 + 364)) and (v14:HealthPercentage() <= v67) and v57 and v95.LayonHands:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) then
					if (((11628 - 8255) <= (1843 + 1713)) and v24(v97.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v124 = 471 - (381 + 89);
			end
			if ((v124 == (2 + 0)) or ((2226 + 1065) < (5618 - 2338))) then
				if (((5542 - (1074 + 82)) >= (1913 - 1040)) and v95.WordofGlory:IsReady() and (v14:HealthPercentage() <= v68) and v58 and not v14:HealingAbsorbed()) then
					if (((2705 - (214 + 1570)) <= (2557 - (990 + 465))) and ((v14:BuffRemains(v95.ShieldoftheRighteousBuff) >= (3 + 2)) or v14:BuffUp(v95.DivinePurposeBuff) or v14:BuffUp(v95.ShiningLightFreeBuff))) then
						if (((2048 + 2658) >= (937 + 26)) and v24(v97.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v95.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (7 - 5)) and v14:BuffRefreshable(v95.ShieldoftheRighteousBuff) and v59 and (v99 or (v14:HealthPercentage() <= v69))) or ((2686 - (1668 + 58)) <= (1502 - (512 + 114)))) then
					if (v24(v95.ShieldoftheRighteous) or ((5386 - 3320) == (1926 - 994))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v124 = 10 - 7;
			end
			if (((2245 + 2580) < (907 + 3936)) and (v124 == (1 + 0))) then
				if ((v95.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v66) and v56 and v14:BuffDown(v95.ArdentDefenderBuff)) or ((13076 - 9199) >= (6531 - (109 + 1885)))) then
					if (v24(v95.GuardianofAncientKings) or ((5784 - (1269 + 200)) < (3308 - 1582))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v95.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v64) and v54 and v14:BuffDown(v95.GuardianofAncientKingsBuff)) or ((4494 - (98 + 717)) < (1451 - (802 + 24)))) then
					if (v24(v95.ArdentDefender) or ((7975 - 3350) < (797 - 165))) then
						return "ardent_defender defensive 6";
					end
				end
				v124 = 1 + 1;
			end
		end
	end
	local function v113()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (0 + 0)) or ((18 + 65) > (4951 - 3171))) then
				if (((1820 - 1274) <= (386 + 691)) and (not v13 or not v13:Exists() or not v13:IsInRange(13 + 17))) then
					return;
				end
				if (v13 or ((822 + 174) > (3128 + 1173))) then
					if (((1901 + 2169) > (2120 - (797 + 636))) and v95.WordofGlory:IsReady() and v61 and v14:BuffUp(v95.ShiningLightFreeBuff) and (v13:HealthPercentage() <= v71)) then
						if (v24(v97.WordofGloryFocus) or ((3185 - 2529) >= (4949 - (1427 + 192)))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v95.LayonHands:IsCastable() and v60 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v70)) or ((864 + 1628) <= (777 - 442))) then
						if (((3885 + 437) >= (1162 + 1400)) and v24(v97.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v95.BlessingofSacrifice:IsCastable() and v63 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v73)) or ((3963 - (192 + 134)) >= (5046 - (316 + 960)))) then
						if (v24(v97.BlessingofSacrificeFocus) or ((1324 + 1055) > (3533 + 1045))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v95.BlessingofProtection:IsCastable() and v62 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v72)) or ((447 + 36) > (2840 - 2097))) then
						if (((3005 - (83 + 468)) > (2384 - (1202 + 604))) and v24(v97.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		if (((4341 - 3411) < (7419 - 2961)) and (v83 < FightRemains) and v95.LightsJudgment:IsCastable() and v86 and ((v87 and v31) or not v87)) then
			if (((1832 - 1170) <= (1297 - (45 + 280))) and v24(v95.LightsJudgment, not v16:IsSpellInRange(v95.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((4218 + 152) == (3818 + 552)) and (v83 < FightRemains) and v95.ArcaneTorrent:IsCastable() and v86 and ((v87 and v31) or not v87) and (HolyPower < (2 + 3))) then
			if (v24(v95.ArcaneTorrent, not v16:IsInRange(5 + 3)) or ((838 + 3924) <= (1594 - 733))) then
				return "arcane_torrent precombat 6";
			end
		end
		if ((v95.Consecration:IsCastable() and v35) or ((3323 - (340 + 1571)) == (1682 + 2582))) then
			if (v24(v95.Consecration, not v16:IsInRange(1780 - (1733 + 39))) or ((8705 - 5537) < (3187 - (125 + 909)))) then
				return "consecration";
			end
		end
		if ((v95.AvengersShield:IsCastable() and v33) or ((6924 - (1096 + 852)) < (598 + 734))) then
			if (((6608 - 1980) == (4489 + 139)) and v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield))) then
				return "avengers_shield precombat 10";
			end
		end
		if ((v95.Judgment:IsReady() and v39) or ((566 - (409 + 103)) == (631 - (46 + 190)))) then
			if (((177 - (51 + 44)) == (24 + 58)) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v115()
		if ((v95.AvengersShield:IsCastable() and v33 and (v9.CombatTime() < (1319 - (1114 + 203))) and v14:HasTier(755 - (228 + 498), 1 + 1)) or ((321 + 260) < (945 - (174 + 489)))) then
			if (v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield)) or ((12007 - 7398) < (4400 - (830 + 1075)))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((1676 - (303 + 221)) == (2421 - (231 + 1038))) and v95.LightsJudgment:IsCastable() and v86 and ((v87 and v31) or not v87) and (v104 >= (2 + 0))) then
			if (((3058 - (171 + 991)) <= (14102 - 10680)) and v24(v95.LightsJudgment, not v16:IsSpellInRange(v95.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v95.AvengingWrath:IsCastable() and v40 and ((v46 and v31) or not v46)) or ((2658 - 1668) > (4042 - 2422))) then
			if (v24(v95.AvengingWrath, not v16:IsInRange(7 + 1)) or ((3074 - 2197) > (13544 - 8849))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((4337 - 1646) >= (5721 - 3870)) and v95.Sentinel:IsCastable() and v45 and ((v51 and v31) or not v51)) then
			if (v24(v95.Sentinel, not v16:IsInRange(1256 - (111 + 1137))) or ((3143 - (91 + 67)) >= (14452 - 9596))) then
				return "sentinel cooldowns 8";
			end
		end
		local v126 = v105.HandleDPSPotion(v14:BuffUp(v95.AvengingWrathBuff));
		if (((1067 + 3209) >= (1718 - (423 + 100))) and v126) then
			return v126;
		end
		if (((23 + 3209) <= (12985 - 8295)) and v95.MomentofGlory:IsCastable() and v44 and ((v50 and v31) or not v50) and ((v14:BuffRemains(v95.SentinelBuff) < (8 + 7)) or (((v9.CombatTime() > (781 - (326 + 445))) or (v95.Sentinel:CooldownRemains() > (65 - 50)) or (v95.AvengingWrath:CooldownRemains() > (33 - 18))) and (v95.AvengersShield:CooldownRemains() > (0 - 0)) and (v95.Judgment:CooldownRemains() > (711 - (530 + 181))) and (v95.HammerofWrath:CooldownRemains() > (881 - (614 + 267)))))) then
			if (v24(v95.MomentofGlory, not v16:IsInRange(40 - (19 + 13))) or ((1457 - 561) >= (7330 - 4184))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((8744 - 5683) >= (769 + 2189)) and v42 and ((v48 and v31) or not v48) and v95.DivineToll:IsReady() and (v103 >= (4 - 1))) then
			if (((6608 - 3421) >= (2456 - (1293 + 519))) and v24(v95.DivineToll, not v16:IsInRange(61 - 31))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((1680 - 1036) <= (1345 - 641)) and v95.BastionofLight:IsCastable() and v41 and ((v47 and v31) or not v47) and (v14:BuffUp(v95.AvengingWrathBuff) or (v95.AvengingWrath:CooldownRemains() <= (129 - 99)))) then
			if (((2256 - 1298) > (502 + 445)) and v24(v95.BastionofLight, not v16:IsInRange(2 + 6))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v116()
		local v127 = 0 - 0;
		while true do
			if (((1039 + 3453) >= (882 + 1772)) and ((2 + 0) == v127)) then
				if (((4538 - (709 + 387)) >= (3361 - (673 + 1185))) and v95.AvengersShield:IsCastable() and v33) then
					if (v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield)) or ((9193 - 6023) <= (4700 - 3236))) then
						return "avengers_shield standard 18";
					end
				end
				if ((v95.HammerofWrath:IsReady() and v38) or ((7891 - 3094) == (3139 + 1249))) then
					if (((412 + 139) <= (919 - 238)) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((805 + 2472) > (811 - 404)) and v95.Judgment:IsReady() and v39) then
					if (((9216 - 4521) >= (3295 - (446 + 1434))) and v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment standard 22";
					end
				end
				if ((v95.Consecration:IsCastable() and v35 and v14:BuffDown(v95.ConsecrationBuff) and ((v14:BuffStack(v95.SanctificationBuff) < (1288 - (1040 + 243))) or not v14:HasTier(92 - 61, 1849 - (559 + 1288)))) or ((5143 - (609 + 1322)) <= (1398 - (13 + 441)))) then
					if (v24(v95.Consecration, not v16:IsInRange(29 - 21)) or ((8109 - 5013) <= (8954 - 7156))) then
						return "consecration standard 24";
					end
				end
				v127 = 1 + 2;
			end
			if (((12845 - 9308) == (1257 + 2280)) and ((0 + 0) == v127)) then
				if (((11386 - 7549) >= (860 + 710)) and v95.Consecration:IsCastable() and v35 and (v14:BuffStack(v95.SanctificationBuff) == (8 - 3))) then
					if (v24(v95.Consecration, not v16:IsInRange(6 + 2)) or ((1641 + 1309) == (2739 + 1073))) then
						return "consecration standard 2";
					end
				end
				if (((3966 + 757) >= (2268 + 50)) and v95.ShieldoftheRighteous:IsCastable() and v59 and ((v14:HolyPower() > (435 - (153 + 280))) or v14:BuffUp(v95.BastionofLightBuff) or v14:BuffUp(v95.DivinePurposeBuff)) and (v14:BuffDown(v95.SanctificationBuff) or (v14:BuffStack(v95.SanctificationBuff) < (14 - 9)))) then
					if (v24(v95.ShieldoftheRighteous) or ((1820 + 207) > (1127 + 1725))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v95.Judgment:IsReady() and v39 and (v103 > (2 + 1)) and (v14:BuffStack(v95.BulwarkofRighteousFuryBuff) >= (3 + 0)) and (v14:HolyPower() < (3 + 0))) or ((1729 - 593) > (2669 + 1648))) then
					if (((5415 - (89 + 578)) == (3392 + 1356)) and v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment standard 6";
					end
				end
				if (((7766 - 4030) <= (5789 - (572 + 477))) and v95.Judgment:IsReady() and v39 and v14:BuffDown(v95.SanctificationEmpowerBuff) and v14:HasTier(5 + 26, 2 + 0)) then
					if (v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment)) or ((405 + 2985) <= (3146 - (84 + 2)))) then
						return "judgment standard 8";
					end
				end
				v127 = 1 - 0;
			end
			if ((v127 == (3 + 1)) or ((1841 - (497 + 345)) > (69 + 2624))) then
				if (((79 + 384) < (1934 - (605 + 728))) and (v83 < FightRemains) and v43 and ((v49 and v31) or not v49) and v95.EyeofTyr:IsCastable() and not v95.InmostLight:IsAvailable()) then
					if (v24(v95.EyeofTyr, not v16:IsInRange(6 + 2)) or ((4853 - 2670) < (32 + 655))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((16818 - 12269) == (4101 + 448)) and v95.ArcaneTorrent:IsCastable() and v86 and ((v87 and v31) or not v87) and (HolyPower < (13 - 8))) then
					if (((3528 + 1144) == (5161 - (457 + 32))) and v24(v95.ArcaneTorrent, not v16:IsInRange(4 + 4))) then
						return "arcane_torrent standard 36";
					end
				end
				if ((v95.Consecration:IsCastable() and v35 and (v14:BuffDown(v95.SanctificationEmpowerBuff))) or ((5070 - (832 + 570)) < (373 + 22))) then
					if (v24(v95.Consecration, not v16:IsInRange(3 + 5)) or ((14742 - 10576) == (220 + 235))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v127 == (797 - (588 + 208))) or ((11990 - 7541) == (4463 - (884 + 916)))) then
				if ((v95.HammerofWrath:IsReady() and v38) or ((8953 - 4676) < (1734 + 1255))) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((1523 - (232 + 421)) >= (6038 - (1569 + 320)))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((543 + 1669) < (605 + 2578)) and v95.Judgment:IsReady() and v39 and ((v95.Judgment:Charges() >= (6 - 4)) or (v95.Judgment:FullRechargeTime() <= v14:GCD()))) then
					if (((5251 - (316 + 289)) > (7832 - 4840)) and v105.CastCycle(v95.Judgment, v101, v107, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment standard 12";
					end
				end
				if (((67 + 1367) < (4559 - (666 + 787))) and v95.AvengersShield:IsCastable() and v33 and ((v104 > (427 - (360 + 65))) or v14:BuffUp(v95.MomentofGloryBuff))) then
					if (((735 + 51) < (3277 - (79 + 175))) and v24(v95.AvengersShield, not v16:IsSpellInRange(v95.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v42 and ((v48 and v31) or not v48) and v95.DivineToll:IsReady()) or ((3850 - 1408) < (58 + 16))) then
					if (((13900 - 9365) == (8733 - 4198)) and v24(v95.DivineToll, not v16:IsInRange(929 - (503 + 396)))) then
						return "divine_toll standard 16";
					end
				end
				v127 = 183 - (92 + 89);
			end
			if ((v127 == (5 - 2)) or ((1544 + 1465) <= (1246 + 859))) then
				if (((7166 - 5336) < (502 + 3167)) and (v83 < FightRemains) and v43 and ((v49 and v31) or not v49) and v95.EyeofTyr:IsCastable() and v95.InmostLight:IsAvailable() and (v103 >= (6 - 3))) then
					if (v24(v95.EyeofTyr, not v16:IsInRange(7 + 1)) or ((684 + 746) >= (11000 - 7388))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((335 + 2348) >= (3751 - 1291)) and v95.BlessedHammer:IsCastable() and v34) then
					if (v24(v95.BlessedHammer, not v16:IsInRange(1252 - (485 + 759))) or ((4173 - 2369) >= (4464 - (442 + 747)))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v95.HammeroftheRighteous:IsCastable() and v37) or ((2552 - (832 + 303)) > (4575 - (88 + 858)))) then
					if (((1462 + 3333) > (333 + 69)) and v24(v95.HammeroftheRighteous, not v16:IsInRange(1 + 7))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				if (((5602 - (766 + 23)) > (17599 - 14034)) and v95.CrusaderStrike:IsCastable() and v36) then
					if (((5349 - 1437) == (10306 - 6394)) and v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				v127 = 13 - 9;
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
		local v147 = 1073 - (1036 + 37);
		while true do
			if (((2001 + 820) <= (9393 - 4569)) and (v147 == (0 + 0))) then
				v52 = EpicSettings.Settings['useRebuke'];
				v53 = EpicSettings.Settings['useHammerofJustice'];
				v54 = EpicSettings.Settings['useArdentDefender'];
				v147 = 1481 - (641 + 839);
			end
			if (((2651 - (910 + 3)) <= (5595 - 3400)) and ((1687 - (1466 + 218)) == v147)) then
				v61 = EpicSettings.Settings['useWordofGloryFocus'];
				v62 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v63 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v147 = 2 + 2;
			end
			if (((1189 - (556 + 592)) <= (1074 + 1944)) and (v147 == (810 - (329 + 479)))) then
				v58 = EpicSettings.Settings['useWordofGloryPlayer'];
				v59 = EpicSettings.Settings['useShieldoftheRighteous'];
				v60 = EpicSettings.Settings['useLayOnHandsFocus'];
				v147 = 857 - (174 + 680);
			end
			if (((7370 - 5225) <= (8506 - 4402)) and (v147 == (1 + 0))) then
				v55 = EpicSettings.Settings['useDivineShield'];
				v56 = EpicSettings.Settings['useGuardianofAncientKings'];
				v57 = EpicSettings.Settings['useLayOnHands'];
				v147 = 741 - (396 + 343);
			end
			if (((238 + 2451) < (6322 - (29 + 1448))) and (v147 == (1395 - (135 + 1254)))) then
				v70 = EpicSettings.Settings['layOnHandsFocusHP'];
				v71 = EpicSettings.Settings['wordofGloryFocusHP'];
				v72 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v147 = 26 - 19;
			end
			if ((v147 == (18 - 14)) or ((1548 + 774) > (4149 - (389 + 1138)))) then
				v64 = EpicSettings.Settings['ardentDefenderHP'];
				v65 = EpicSettings.Settings['divineShieldHP'];
				v66 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v147 = 579 - (102 + 472);
			end
			if (((5 + 0) == v147) or ((2515 + 2019) == (1942 + 140))) then
				v67 = EpicSettings.Settings['layonHandsHP'];
				v68 = EpicSettings.Settings['wordofGloryHP'];
				v69 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v147 = 1551 - (320 + 1225);
			end
			if ((v147 == (11 - 4)) or ((962 + 609) > (3331 - (157 + 1307)))) then
				v73 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v74 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v75 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
		end
	end
	local function v119()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (1859 - (821 + 1038));
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
		v90 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v92 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
		v93 = EpicSettings.Settings['HealOOC'];
		v94 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v120()
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (4 - 2)) or ((3680 - (834 + 192)) >= (191 + 2805))) then
				v100 = v14:IsTankingAoE(3 + 5) or v14:IsTanking(v16);
				if (((86 + 3892) > (3258 - 1154)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if (((3299 - (300 + 4)) > (412 + 1129)) and v95.CrusaderAura:IsCastable() and (v14:BuffDown(v95.CrusaderAura))) then
						if (((8504 - 5255) > (1315 - (112 + 250))) and v24(v95.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (v14:AffectingCombat() or v77 or ((1305 + 1968) > (11456 - 6883))) then
					local v193 = 0 + 0;
					local v194;
					while true do
						if ((v193 == (0 + 0)) or ((2357 + 794) < (637 + 647))) then
							v194 = v77 and v95.CleanseToxins:IsReady() and v32;
							v163 = v105.FocusUnit(v194, v97, 15 + 5, nil, 1439 - (1001 + 413));
							v193 = 2 - 1;
						end
						if ((v193 == (883 - (244 + 638))) or ((2543 - (627 + 66)) == (4555 - 3026))) then
							if (((1423 - (512 + 90)) < (4029 - (1665 + 241))) and v163) then
								return v163;
							end
							break;
						end
					end
				end
				v163 = v105.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 757 - (373 + 344), 12 + 13);
				if (((239 + 663) < (6132 - 3807)) and v163) then
					return v163;
				end
				if (((1451 - 593) <= (4061 - (35 + 1064))) and v95.BlessingofFreedom:IsReady() and v105.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
					if (v24(v97.BlessingofFreedomFocus) or ((2872 + 1074) < (2755 - 1467))) then
						return "blessing_of_freedom combat";
					end
				end
				v162 = 1 + 2;
			end
			if ((v162 == (1236 - (298 + 938))) or ((4501 - (233 + 1026)) == (2233 - (636 + 1030)))) then
				v118();
				v117();
				v119();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v162 = 1 + 0;
			end
			if ((v162 == (4 + 0)) or ((252 + 595) >= (86 + 1177))) then
				if (v13 or ((2474 - (55 + 166)) == (359 + 1492))) then
					if (v77 or ((210 + 1877) > (9058 - 6686))) then
						v163 = v109();
						if (v163 or ((4742 - (36 + 261)) < (7255 - 3106))) then
							return v163;
						end
					end
				end
				v163 = v113();
				if (v163 or ((3186 - (34 + 1334)) == (33 + 52))) then
					return v163;
				end
				if (((490 + 140) < (3410 - (1035 + 248))) and v95.Redemption:IsCastable() and v95.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v24(v97.RedemptionMouseover) or ((1959 - (20 + 1)) == (1310 + 1204))) then
						return "redemption mouseover";
					end
				end
				if (((4574 - (134 + 185)) >= (1188 - (549 + 584))) and v14:AffectingCombat()) then
					if (((3684 - (314 + 371)) > (3968 - 2812)) and v95.Intercession:IsCastable() and (v14:HolyPower() >= (971 - (478 + 490))) and v95.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (((1245 + 1105) > (2327 - (786 + 386))) and v24(v97.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (((13049 - 9020) <= (6232 - (1055 + 324))) and v105.TargetIsValid() and not v14:AffectingCombat() and v29) then
					local v195 = 1340 - (1093 + 247);
					while true do
						if ((v195 == (0 + 0)) or ((55 + 461) > (13633 - 10199))) then
							v163 = v114();
							if (((13730 - 9684) >= (8630 - 5597)) and v163) then
								return v163;
							end
							break;
						end
					end
				end
				v162 = 12 - 7;
			end
			if ((v162 == (1 + 0)) or ((10474 - 7755) <= (4987 - 3540))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((3118 + 1016) < (10040 - 6114))) then
					return;
				end
				v101 = v14:GetEnemiesInMeleeRange(696 - (364 + 324));
				v102 = v14:GetEnemiesInRange(82 - 52);
				if (v30 or ((393 - 229) >= (924 + 1861))) then
					v103 = #v101;
					v104 = #v102;
				else
					local v196 = 0 - 0;
					while true do
						if ((v196 == (0 - 0)) or ((1594 - 1069) == (3377 - (1249 + 19)))) then
							v103 = 1 + 0;
							v104 = 3 - 2;
							break;
						end
					end
				end
				v99 = v14:ActiveMitigationNeeded();
				v162 = 1088 - (686 + 400);
			end
			if (((26 + 7) == (262 - (73 + 156))) and (v162 == (1 + 4))) then
				if (((3865 - (721 + 90)) <= (46 + 3969)) and v105.TargetIsValid()) then
					local v197 = 0 - 0;
					while true do
						if (((2341 - (224 + 246)) < (5478 - 2096)) and (v197 == (0 - 0))) then
							if (((235 + 1058) <= (52 + 2114)) and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
								if (v14:AffectingCombat() or ((1895 + 684) < (244 - 121))) then
									if (v95.Intercession:IsCastable() or ((2815 - 1969) >= (2881 - (203 + 310)))) then
										if (v24(v95.Intercession, not v16:IsInRange(2023 - (1238 + 755)), true) or ((281 + 3731) <= (4892 - (709 + 825)))) then
											return "intercession";
										end
									end
								elseif (((2752 - 1258) <= (4376 - 1371)) and v95.Redemption:IsCastable()) then
									if (v24(v95.Redemption, not v16:IsInRange(894 - (196 + 668)), true) or ((12283 - 9172) == (4420 - 2286))) then
										return "redemption";
									end
								end
							end
							if (((3188 - (171 + 662)) == (2448 - (4 + 89))) and v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
								local v199 = 0 - 0;
								while true do
									if (((1 + 1) == v199) or ((2582 - 1994) <= (170 + 262))) then
										if (((6283 - (35 + 1451)) >= (5348 - (28 + 1425))) and v163) then
											return v163;
										end
										if (((5570 - (941 + 1052)) == (3430 + 147)) and v24(v95.Pool)) then
											return "Wait/Pool Resources";
										end
										break;
									end
									if (((5308 - (822 + 692)) > (5271 - 1578)) and ((0 + 0) == v199)) then
										if (v100 or ((1572 - (45 + 252)) == (4057 + 43))) then
											v163 = v112();
											if (v163 or ((548 + 1043) >= (8712 - 5132))) then
												return v163;
											end
										end
										if (((1416 - (114 + 319)) <= (2595 - 787)) and (v83 < FightRemains)) then
											v163 = v115();
											if (v163 or ((2754 - 604) <= (764 + 433))) then
												return v163;
											end
										end
										v199 = 1 - 0;
									end
									if (((7896 - 4127) >= (3136 - (556 + 1407))) and ((1207 - (741 + 465)) == v199)) then
										if (((1950 - (170 + 295)) == (783 + 702)) and v84 and ((v31 and v85) or not v85) and v16:IsInRange(8 + 0)) then
											local v201 = 0 - 0;
											while true do
												if ((v201 == (0 + 0)) or ((2126 + 1189) <= (1576 + 1206))) then
													v163 = v111();
													if (v163 or ((2106 - (957 + 273)) >= (793 + 2171))) then
														return v163;
													end
													break;
												end
											end
										end
										v163 = v116();
										v199 = 1 + 1;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v162 == (11 - 8)) or ((5881 - 3649) > (7626 - 5129))) then
				if (v105.TargetIsValid() or v14:AffectingCombat() or ((10448 - 8338) <= (2112 - (389 + 1391)))) then
					BossFightRemains = v9.BossFightRemains(nil, true);
					FightRemains = BossFightRemains;
					if (((2313 + 1373) > (331 + 2841)) and (FightRemains == (25295 - 14184))) then
						FightRemains = v9.FightRemains(v101, false);
					end
				end
				if (not v14:AffectingCombat() or ((5425 - (783 + 168)) < (2752 - 1932))) then
					if (((4209 + 70) >= (3193 - (309 + 2))) and v95.DevotionAura:IsCastable() and (v108())) then
						if (v24(v95.DevotionAura) or ((6230 - 4201) >= (4733 - (1090 + 122)))) then
							return "devotion_aura";
						end
					end
				end
				if (v78 or ((661 + 1376) >= (15589 - 10947))) then
					local v198 = 0 + 0;
					while true do
						if (((2838 - (628 + 490)) < (800 + 3658)) and (v198 == (0 - 0))) then
							if (v74 or ((1992 - 1556) > (3795 - (431 + 343)))) then
								local v200 = 0 - 0;
								while true do
									if (((2062 - 1349) <= (670 + 177)) and (v200 == (0 + 0))) then
										v163 = v105.HandleAfflicted(v95.CleanseToxins, v97.CleanseToxinsMouseover, 1735 - (556 + 1139));
										if (((2169 - (6 + 9)) <= (739 + 3292)) and v163) then
											return v163;
										end
										break;
									end
								end
							end
							if (((2365 + 2250) == (4784 - (28 + 141))) and v14:BuffUp(v95.ShiningLightFreeBuff) and v75) then
								v163 = v105.HandleAfflicted(v95.WordofGlory, v97.WordofGloryMouseover, 16 + 24, true);
								if (v163 or ((4678 - 888) == (355 + 145))) then
									return v163;
								end
							end
							break;
						end
					end
				end
				if (((1406 - (486 + 831)) < (575 - 354)) and v79) then
					v163 = v105.HandleIncorporeal(v95.Repentance, v97.RepentanceMouseOver, 105 - 75, true);
					if (((389 + 1665) >= (4493 - 3072)) and v163) then
						return v163;
					end
					v163 = v105.HandleIncorporeal(v95.TurnEvil, v97.TurnEvilMouseOver, 1293 - (668 + 595), true);
					if (((623 + 69) < (617 + 2441)) and v163) then
						return v163;
					end
				end
				v163 = v110();
				if (v163 or ((8873 - 5619) == (1945 - (23 + 267)))) then
					return v163;
				end
				v162 = 1948 - (1129 + 815);
			end
		end
	end
	local function v121()
		v20.Print("Protection Paladin by Epic. Supported by xKaneto");
		v106();
	end
	v20.SetAPL(453 - (371 + 16), v120, v121);
end;
return v0["Epix_Paladin_Protection.lua"]();

