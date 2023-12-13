local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3460 - (25 + 23)) > (159 + 660)) and (v5 == (1887 - (927 + 959)))) then
			return v6(...);
		end
		if (((10658 - 7496) <= (4173 - (16 + 716))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((4803 - (11 + 86)) > (10802 - 6373)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 286 - (175 + 110);
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = string.format;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v96 = v19.Paladin.Protection;
	local v97 = v20.Paladin.Protection;
	local v98 = v24.Paladin.Protection;
	local v99 = {};
	local v100;
	local v101;
	local v102, v103;
	local v104, v105;
	local v106 = v21.Commons.Everyone;
	local v107 = 28052 - 16941;
	local v108 = 54802 - 43691;
	local v109 = 1796 - (503 + 1293);
	v10:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if (((2064 + 790) < (5156 - (810 + 251))) and (v126 == (0 + 0))) then
				v107 = 3410 + 7701;
				v108 = 10017 + 1094;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		if (v96.CleanseToxins:IsAvailable() or ((1591 - (43 + 490)) >= (1935 - (711 + 22)))) then
			v106.DispellableDebuffs = v13.MergeTable(v106.DispellableDiseaseDebuffs, v106.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v110();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v111(v127)
		return v127:DebuffRemains(v96.JudgmentDebuff);
	end
	local function v112()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v113()
		if (((14354 - 10643) > (4214 - (240 + 619))) and v96.CleanseToxins:IsReady() and v33 and v106.DispellableFriendlyUnit(7 + 18)) then
			if (v25(v98.CleanseToxinsFocus) or ((1440 - 534) >= (148 + 2081))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v114()
		if (((3032 - (1344 + 400)) > (1656 - (255 + 150))) and v94 and (v15:HealthPercentage() <= v95)) then
			if (v96.FlashofLight:IsReady() or ((3555 + 958) < (1795 + 1557))) then
				if (v25(v96.FlashofLight) or ((8822 - 6757) >= (10322 - 7126))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v128 = 1739 - (404 + 1335);
		while true do
			if ((v128 == (407 - (183 + 223))) or ((5324 - 948) <= (982 + 499))) then
				v29 = v106.HandleBottomTrinket(v99, v32, 15 + 25, nil);
				if (v29 or ((3729 - (10 + 327)) >= (3302 + 1439))) then
					return v29;
				end
				break;
			end
			if (((3663 - (118 + 220)) >= (718 + 1436)) and (v128 == (449 - (108 + 341)))) then
				v29 = v106.HandleTopTrinket(v99, v32, 18 + 22, nil);
				if (v29 or ((5475 - 4180) >= (4726 - (711 + 782)))) then
					return v29;
				end
				v128 = 1 - 0;
			end
		end
	end
	local function v116()
		if (((4846 - (270 + 199)) > (533 + 1109)) and (v15:HealthPercentage() <= v66) and v56 and v96.DivineShield:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
			if (((6542 - (580 + 1239)) > (4030 - 2674)) and v25(v96.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((v15:HealthPercentage() <= v68) and v58 and v96.LayonHands:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((3955 + 181) <= (124 + 3309))) then
			if (((1850 + 2395) <= (12091 - 7460)) and v25(v98.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((2657 + 1619) >= (5081 - (645 + 522))) and v96.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v67) and v57 and v15:BuffDown(v96.ArdentDefenderBuff)) then
			if (((1988 - (1010 + 780)) <= (4363 + 2)) and v25(v96.GuardianofAncientKings)) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((22780 - 17998) > (13702 - 9026)) and v96.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v65) and v55 and v15:BuffDown(v96.GuardianofAncientKingsBuff)) then
			if (((6700 - (1045 + 791)) > (5560 - 3363)) and v25(v96.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v96.WordofGlory:IsReady() and (v15:HealthPercentage() <= v69) and v59 and not v15:HealingAbsorbed()) or ((5649 - 1949) == (3012 - (351 + 154)))) then
			if (((6048 - (1281 + 293)) >= (540 - (28 + 238))) and ((v15:BuffRemains(v96.ShieldoftheRighteousBuff) >= (10 - 5)) or v15:BuffUp(v96.DivinePurposeBuff) or v15:BuffUp(v96.ShiningLightFreeBuff))) then
				if (v25(v98.WordofGloryPlayer) or ((3453 - (1381 + 178)) <= (1319 + 87))) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((1268 + 304) >= (654 + 877)) and v96.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (6 - 4)) and v15:BuffRefreshable(v96.ShieldoftheRighteousBuff) and v60 and (v100 or (v15:HealthPercentage() <= v70))) then
			if (v25(v96.ShieldoftheRighteous) or ((2429 + 2258) < (5012 - (381 + 89)))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if (((2919 + 372) > (1128 + 539)) and v97.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
			if (v25(v98.Healthstone) or ((1495 - 622) == (3190 - (1074 + 82)))) then
				return "healthstone defensive";
			end
		end
		if ((v89 and (v15:HealthPercentage() <= v91)) or ((6170 - 3354) < (1795 - (214 + 1570)))) then
			if (((5154 - (990 + 465)) < (1941 + 2765)) and (v93 == "Refreshing Healing Potion")) then
				if (((1152 + 1494) >= (852 + 24)) and v97.RefreshingHealingPotion:IsReady()) then
					if (((2416 - 1802) <= (4910 - (1668 + 58))) and v25(v98.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((3752 - (512 + 114)) == (8149 - 5023)) and (v93 == "Dreamwalker's Healing Potion")) then
				if (v97.DreamwalkersHealingPotion:IsReady() or ((4521 - 2334) >= (17238 - 12284))) then
					if (v25(v98.RefreshingHealingPotion) or ((1804 + 2073) == (670 + 2905))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v117()
		local v129 = 0 + 0;
		while true do
			if (((2384 - 1677) > (2626 - (109 + 1885))) and (v129 == (1469 - (1269 + 200)))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(57 - 27) or ((1361 - (98 + 717)) >= (3510 - (802 + 24)))) then
					return;
				end
				if (((2526 - 1061) <= (5431 - 1130)) and v14) then
					local v204 = 0 + 0;
					while true do
						if (((1310 + 394) > (235 + 1190)) and (v204 == (0 + 0))) then
							if ((v96.WordofGlory:IsReady() and v62 and v15:BuffUp(v96.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v72)) or ((1911 - 1224) == (14119 - 9885))) then
								if (v25(v98.WordofGloryFocus) or ((1192 + 2138) < (582 + 847))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((947 + 200) >= (244 + 91)) and v96.LayonHands:IsCastable() and v61 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) then
								if (((1604 + 1831) > (3530 - (797 + 636))) and v25(v98.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v204 = 4 - 3;
						end
						if ((v204 == (1620 - (1427 + 192))) or ((1307 + 2463) >= (9382 - 5341))) then
							if ((v96.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((3408 + 383) <= (731 + 880))) then
								if (v25(v98.BlessingofSacrificeFocus) or ((4904 - (192 + 134)) <= (3284 - (316 + 960)))) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((627 + 498) <= (1603 + 473)) and v96.BlessingofProtection:IsCastable() and v63 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
								if (v25(v98.BlessingofProtectionFocus) or ((687 + 56) >= (16817 - 12418))) then
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
	local function v118()
		if (((1706 - (83 + 468)) < (3479 - (1202 + 604))) and (v84 < v108) and v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88)) then
			if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or ((10848 - 8524) <= (961 - 383))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((10429 - 6662) == (4092 - (45 + 280))) and (v84 < v108) and v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (5 + 0))) then
			if (((3573 + 516) == (1494 + 2595)) and v25(v96.ArcaneTorrent, not v17:IsInRange(5 + 3))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((785 + 3673) >= (3099 - 1425)) and v96.Consecration:IsCastable() and v36) then
			if (((2883 - (340 + 1571)) <= (560 + 858)) and v25(v96.Consecration, not v17:IsInRange(1780 - (1733 + 39)))) then
				return "consecration";
			end
		end
		if ((v96.AvengersShield:IsCastable() and v34) or ((13569 - 8631) < (5796 - (125 + 909)))) then
			if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((4452 - (1096 + 852)) > (1913 + 2351))) then
				return "avengers_shield precombat 10";
			end
		end
		if (((3073 - 920) == (2089 + 64)) and v96.Judgment:IsReady() and v40) then
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((1019 - (409 + 103)) >= (2827 - (46 + 190)))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v119()
		local v130 = 95 - (51 + 44);
		local v131;
		while true do
			if (((1264 + 3217) == (5798 - (1114 + 203))) and (v130 == (727 - (228 + 498)))) then
				if ((v96.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((505 + 1823) < (383 + 310))) then
					if (((4991 - (174 + 489)) == (11275 - 6947)) and v25(v96.AvengingWrath, not v17:IsInRange(1913 - (830 + 1075)))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((2112 - (303 + 221)) >= (2601 - (231 + 1038))) and v96.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) then
					if (v25(v96.Sentinel, not v17:IsInRange(7 + 1)) or ((5336 - (171 + 991)) > (17506 - 13258))) then
						return "sentinel cooldowns 8";
					end
				end
				v130 = 5 - 3;
			end
			if ((v130 == (7 - 4)) or ((3671 + 915) <= (287 - 205))) then
				if (((11143 - 7280) == (6226 - 2363)) and v96.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v96.SentinelBuff) < (46 - 31)) or (((v10.CombatTime() > (1258 - (111 + 1137))) or (v96.Sentinel:CooldownRemains() > (173 - (91 + 67))) or (v96.AvengingWrath:CooldownRemains() > (44 - 29))) and (v96.AvengersShield:CooldownRemains() > (0 + 0)) and (v96.Judgment:CooldownRemains() > (523 - (423 + 100))) and (v96.HammerofWrath:CooldownRemains() > (0 + 0))))) then
					if (v25(v96.MomentofGlory, not v17:IsInRange(21 - 13)) or ((147 + 135) <= (813 - (326 + 445)))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((20113 - 15504) >= (1705 - 939)) and v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady() and (v104 >= (6 - 3))) then
					if (v25(v96.DivineToll, not v17:IsInRange(741 - (530 + 181))) or ((2033 - (614 + 267)) == (2520 - (19 + 13)))) then
						return "divine_toll cooldowns 12";
					end
				end
				v130 = 6 - 2;
			end
			if (((7973 - 4551) > (9569 - 6219)) and ((2 + 2) == v130)) then
				if (((1542 - 665) > (779 - 403)) and v96.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v96.AvengingWrathBuff) or (v96.AvengingWrath:CooldownRemains() <= (1842 - (1293 + 519))))) then
					if (v25(v96.BastionofLight, not v17:IsInRange(16 - 8)) or ((8140 - 5022) <= (3539 - 1688))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v130 == (8 - 6)) or ((388 - 223) >= (1850 + 1642))) then
				v131 = v106.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff));
				if (((806 + 3143) < (11282 - 6426)) and v131) then
					return v131;
				end
				v130 = 1 + 2;
			end
			if (((0 + 0) == v130) or ((2673 + 1603) < (4112 - (709 + 387)))) then
				if (((6548 - (673 + 1185)) > (11963 - 7838)) and v96.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (6 - 4)) and v15:HasTier(47 - 18, 2 + 0)) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((38 + 12) >= (1208 - 312))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88) and (v105 >= (1 + 1))) or ((3417 - 1703) >= (5806 - 2848))) then
					if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or ((3371 - (446 + 1434)) < (1927 - (1040 + 243)))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v130 = 2 - 1;
			end
		end
	end
	local function v120()
		if (((2551 - (559 + 1288)) < (2918 - (609 + 1322))) and v96.Consecration:IsCastable() and v36 and (v15:BuffStack(v96.SanctificationBuff) == (459 - (13 + 441)))) then
			if (((13893 - 10175) > (4992 - 3086)) and v25(v96.Consecration, not v17:IsInRange(39 - 31))) then
				return "consecration standard 2";
			end
		end
		if ((v96.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (1 + 1)) or v15:BuffUp(v96.BastionofLightBuff) or v15:BuffUp(v96.DivinePurposeBuff)) and (v15:BuffDown(v96.SanctificationBuff) or (v15:BuffStack(v96.SanctificationBuff) < (18 - 13)))) or ((341 + 617) > (1593 + 2042))) then
			if (((10389 - 6888) <= (2459 + 2033)) and v25(v96.ShieldoftheRighteous)) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if ((v96.Judgment:IsReady() and v40 and (v104 > (4 - 1)) and (v15:BuffStack(v96.BulwarkofRighteousFuryBuff) >= (2 + 1)) and (v15:HolyPower() < (2 + 1))) or ((2474 + 968) < (2140 + 408))) then
			if (((2813 + 62) >= (1897 - (153 + 280))) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment standard 6";
			end
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((13851 - 9054) >= (4393 + 500))) then
				return "judgment standard 6";
			end
		end
		if ((v96.Judgment:IsReady() and v40 and v15:BuffDown(v96.SanctificationEmpowerBuff) and v15:HasTier(13 + 18, 2 + 0)) or ((501 + 50) > (1499 + 569))) then
			if (((3218 - 1104) > (584 + 360)) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment standard 8";
			end
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((2929 - (89 + 578)) >= (2212 + 884))) then
				return "judgment standard 8";
			end
		end
		if ((v96.HammerofWrath:IsReady() and v39) or ((4687 - 2432) >= (4586 - (572 + 477)))) then
			if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((518 + 3319) < (784 + 522))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if (((353 + 2597) == (3036 - (84 + 2))) and v96.Judgment:IsReady() and v40 and ((v96.Judgment:Charges() >= (2 - 0)) or (v96.Judgment:FullRechargeTime() <= v15:GCD()))) then
			if (v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment)) or ((3403 + 1320) < (4140 - (497 + 345)))) then
				return "judgment standard 12";
			end
			if (((30 + 1106) >= (27 + 127)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment standard 12";
			end
		end
		if ((v96.AvengersShield:IsCastable() and v34 and ((v105 > (1335 - (605 + 728))) or v15:BuffUp(v96.MomentofGloryBuff))) or ((194 + 77) > (10556 - 5808))) then
			if (((218 + 4522) >= (11653 - 8501)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
				return "avengers_shield standard 14";
			end
		end
		if ((v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady()) or ((2325 + 253) >= (9392 - 6002))) then
			if (((31 + 10) <= (2150 - (457 + 32))) and v25(v96.DivineToll, not v17:IsInRange(13 + 17))) then
				return "divine_toll standard 16";
			end
		end
		if (((2003 - (832 + 570)) < (3354 + 206)) and v96.AvengersShield:IsCastable() and v34) then
			if (((62 + 173) < (2430 - 1743)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
				return "avengers_shield standard 18";
			end
		end
		if (((2192 + 2357) > (1949 - (588 + 208))) and v96.HammerofWrath:IsReady() and v39) then
			if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((12597 - 7923) < (6472 - (884 + 916)))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if (((7679 - 4011) < (2645 + 1916)) and v96.Judgment:IsReady() and v40) then
			local v164 = 653 - (232 + 421);
			while true do
				if ((v164 == (1889 - (1569 + 320))) or ((112 + 343) == (685 + 2920))) then
					if (v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment)) or ((8973 - 6310) == (3917 - (316 + 289)))) then
						return "judgment standard 22";
					end
					if (((11195 - 6918) <= (207 + 4268)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 22";
					end
					break;
				end
			end
		end
		if ((v96.Consecration:IsCastable() and v36 and v15:BuffDown(v96.ConsecrationBuff) and ((v15:BuffStack(v96.SanctificationBuff) < (1458 - (666 + 787))) or not v15:HasTier(456 - (360 + 65), 2 + 0))) or ((1124 - (79 + 175)) == (1874 - 685))) then
			if (((1212 + 341) <= (9603 - 6470)) and v25(v96.Consecration, not v17:IsInRange(15 - 7))) then
				return "consecration standard 24";
			end
		end
		if (((v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and v96.InmostLight:IsAvailable() and (v104 >= (902 - (503 + 396)))) or ((2418 - (92 + 89)) >= (6810 - 3299))) then
			if (v25(v96.EyeofTyr, not v17:IsInRange(5 + 3)) or ((784 + 540) > (11826 - 8806))) then
				return "eye_of_tyr standard 26";
			end
		end
		if ((v96.BlessedHammer:IsCastable() and v35) or ((410 + 2582) == (4288 - 2407))) then
			if (((2710 + 396) > (729 + 797)) and v25(v96.BlessedHammer, not v17:IsInRange(24 - 16))) then
				return "blessed_hammer standard 28";
			end
		end
		if (((378 + 2645) < (5901 - 2031)) and v96.HammeroftheRighteous:IsCastable() and v38) then
			if (((1387 - (485 + 759)) > (170 - 96)) and v25(v96.HammeroftheRighteous, not v17:IsInRange(1197 - (442 + 747)))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if (((1153 - (832 + 303)) < (3058 - (88 + 858))) and v96.CrusaderStrike:IsCastable() and v37) then
			if (((335 + 762) <= (1348 + 280)) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((191 + 4439) == (5419 - (766 + 23))) and (v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and not v96.InmostLight:IsAvailable()) then
			if (((17476 - 13936) > (3668 - 985)) and v25(v96.EyeofTyr, not v17:IsInRange(20 - 12))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((16270 - 11476) >= (4348 - (1036 + 37))) and v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (4 + 1))) then
			if (((2889 - 1405) == (1168 + 316)) and v25(v96.ArcaneTorrent, not v17:IsInRange(1488 - (641 + 839)))) then
				return "arcane_torrent standard 36";
			end
		end
		if (((2345 - (910 + 3)) < (9062 - 5507)) and v96.Consecration:IsCastable() and v36 and (v15:BuffDown(v96.SanctificationEmpowerBuff))) then
			if (v25(v96.Consecration, not v17:IsInRange(1692 - (1466 + 218))) or ((490 + 575) > (4726 - (556 + 592)))) then
				return "consecration standard 38";
			end
		end
	end
	local function v121()
		local v132 = 0 + 0;
		while true do
			if (((809 - (329 + 479)) == v132) or ((5649 - (174 + 680)) < (4834 - 3427))) then
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v132 = 3 - 1;
			end
			if (((1323 + 530) < (5552 - (396 + 343))) and (v132 == (1 + 5))) then
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v132 == (1480 - (29 + 1448))) or ((4210 - (135 + 1254)) < (9157 - 6726))) then
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v132 = 18 - 14;
			end
			if ((v132 == (2 + 0)) or ((4401 - (389 + 1138)) < (2755 - (102 + 472)))) then
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v42 = EpicSettings.Settings['useBastionofLight'];
				v132 = 3 + 0;
			end
			if ((v132 == (0 + 0)) or ((2508 + 181) <= (1888 - (320 + 1225)))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v132 = 1 - 0;
			end
			if ((v132 == (4 + 1)) or ((3333 - (157 + 1307)) == (3868 - (821 + 1038)))) then
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v132 = 14 - 8;
			end
			if ((v132 == (1 + 3)) or ((6298 - 2752) < (864 + 1458))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v132 = 12 - 7;
			end
		end
	end
	local function v122()
		v53 = EpicSettings.Settings['useRebuke'];
		v54 = EpicSettings.Settings['useHammerofJustice'];
		v55 = EpicSettings.Settings['useArdentDefender'];
		v56 = EpicSettings.Settings['useDivineShield'];
		v57 = EpicSettings.Settings['useGuardianofAncientKings'];
		v58 = EpicSettings.Settings['useLayOnHands'];
		v59 = EpicSettings.Settings['useWordofGloryPlayer'];
		v60 = EpicSettings.Settings['useShieldoftheRighteous'];
		v61 = EpicSettings.Settings['useLayOnHandsFocus'];
		v62 = EpicSettings.Settings['useWordofGloryFocus'];
		v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v65 = EpicSettings.Settings['ardentDefenderHP'];
		v66 = EpicSettings.Settings['divineShieldHP'];
		v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v68 = EpicSettings.Settings['layonHandsHP'];
		v69 = EpicSettings.Settings['wordofGloryHP'];
		v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v71 = EpicSettings.Settings['layOnHandsFocusHP'];
		v72 = EpicSettings.Settings['wordofGloryFocusHP'];
		v73 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v123()
		local v157 = 1026 - (834 + 192);
		while true do
			if ((v157 == (0 + 0)) or ((535 + 1547) == (103 + 4670))) then
				v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v81 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v157 = 305 - (300 + 4);
			end
			if (((867 + 2377) > (2761 - 1706)) and (v157 == (365 - (112 + 250)))) then
				v88 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v157 = 2 + 2;
			end
			if ((v157 == (4 - 2)) or ((1898 + 1415) <= (920 + 858))) then
				v85 = EpicSettings.Settings['useTrinkets'];
				v87 = EpicSettings.Settings['useRacials'];
				v86 = EpicSettings.Settings['trinketsWithCD'];
				v157 = 3 + 0;
			end
			if ((v157 == (2 + 2)) or ((1056 + 365) >= (3518 - (1001 + 413)))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (882 - (244 + 638));
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v157 = 698 - (627 + 66);
			end
			if (((5398 - 3586) <= (3851 - (512 + 90))) and (v157 == (1907 - (1665 + 241)))) then
				v83 = EpicSettings.Settings['InterruptThreshold'];
				v78 = EpicSettings.Settings['DispelDebuffs'];
				v77 = EpicSettings.Settings['DispelBuffs'];
				v157 = 719 - (373 + 344);
			end
			if (((733 + 890) <= (518 + 1439)) and (v157 == (13 - 8))) then
				v79 = EpicSettings.Settings['handleAfflicted'];
				v80 = EpicSettings.Settings['HandleIncorporeal'];
				v94 = EpicSettings.Settings['HealOOC'];
				v157 = 9 - 3;
			end
			if (((5511 - (35 + 1064)) == (3211 + 1201)) and (v157 == (12 - 6))) then
				v95 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
		end
	end
	local function v124()
		v122();
		v121();
		v123();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((2986 - (298 + 938)) >= (2101 - (233 + 1026))) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v102 = v15:GetEnemiesInMeleeRange(1674 - (636 + 1030));
		v103 = v15:GetEnemiesInRange(16 + 14);
		if (((4271 + 101) > (550 + 1300)) and v31) then
			v104 = #v102;
			v105 = #v103;
		else
			v104 = 1 + 0;
			v105 = 222 - (55 + 166);
		end
		v100 = v15:ActiveMitigationNeeded();
		v101 = v15:IsTankingAoE(2 + 6) or v15:IsTanking(v17);
		if (((24 + 208) < (3135 - 2314)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if (((815 - (36 + 261)) < (1577 - 675)) and v96.CrusaderAura:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
				if (((4362 - (34 + 1334)) > (330 + 528)) and v25(v96.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (v15:AffectingCombat() or v78 or ((2918 + 837) <= (2198 - (1035 + 248)))) then
			local v165 = 21 - (20 + 1);
			local v166;
			while true do
				if (((2056 + 1890) > (4062 - (134 + 185))) and (v165 == (1134 - (549 + 584)))) then
					if (v29 or ((2020 - (314 + 371)) >= (11349 - 8043))) then
						return v29;
					end
					break;
				end
				if (((5812 - (478 + 490)) > (1194 + 1059)) and (v165 == (1172 - (786 + 386)))) then
					v166 = v78 and v96.CleanseToxins:IsReady() and v33;
					v29 = v106.FocusUnit(v166, v98, 64 - 44, nil, 1404 - (1055 + 324));
					v165 = 1341 - (1093 + 247);
				end
			end
		end
		v29 = v106.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 36 + 4, 3 + 22);
		if (((1794 - 1342) == (1533 - 1081)) and v29) then
			return v29;
		end
		if ((v96.BlessingofFreedom:IsReady() and v106.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((12966 - 8409) < (5244 - 3157))) then
			if (((1379 + 2495) == (14924 - 11050)) and v25(v98.BlessingofFreedomFocus)) then
				return "blessing_of_freedom combat";
			end
		end
		if (v106.TargetIsValid() or v15:AffectingCombat() or ((6679 - 4741) > (3722 + 1213))) then
			local v167 = 0 - 0;
			while true do
				if ((v167 == (689 - (364 + 324))) or ((11664 - 7409) < (8213 - 4790))) then
					if (((482 + 972) <= (10423 - 7932)) and (v108 == (17794 - 6683))) then
						v108 = v10.FightRemains(v102, false);
					end
					v109 = v15:HolyPower();
					break;
				end
				if ((v167 == (0 - 0)) or ((5425 - (1249 + 19)) <= (2531 + 272))) then
					v107 = v10.BossFightRemains(nil, true);
					v108 = v107;
					v167 = 3 - 2;
				end
			end
		end
		if (((5939 - (686 + 400)) >= (2340 + 642)) and not v15:AffectingCombat()) then
			if (((4363 - (73 + 156)) > (16 + 3341)) and v96.DevotionAura:IsCastable() and (v112())) then
				if (v25(v96.DevotionAura) or ((4228 - (721 + 90)) < (29 + 2505))) then
					return "devotion_aura";
				end
			end
		end
		if (v79 or ((8837 - 6115) <= (634 - (224 + 246)))) then
			if (v75 or ((3900 - 1492) < (3882 - 1773))) then
				local v201 = 0 + 0;
				while true do
					if ((v201 == (0 + 0)) or ((25 + 8) == (2892 - 1437))) then
						v29 = v106.HandleAfflicted(v96.CleanseToxins, v98.CleanseToxinsMouseover, 133 - 93);
						if (v29 or ((956 - (203 + 310)) >= (6008 - (1238 + 755)))) then
							return v29;
						end
						break;
					end
				end
			end
			if (((237 + 3145) > (1700 - (709 + 825))) and v15:BuffUp(v96.ShiningLightFreeBuff) and v76) then
				local v202 = 0 - 0;
				while true do
					if (((0 - 0) == v202) or ((1144 - (196 + 668)) == (12077 - 9018))) then
						v29 = v106.HandleAfflicted(v96.WordofGlory, v98.WordofGloryMouseover, 82 - 42, true);
						if (((2714 - (171 + 662)) > (1386 - (4 + 89))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if (((8261 - 5904) == (859 + 1498)) and v80) then
			v29 = v106.HandleIncorporeal(v96.Repentance, v98.RepentanceMouseOver, 131 - 101, true);
			if (((49 + 74) == (1609 - (35 + 1451))) and v29) then
				return v29;
			end
			v29 = v106.HandleIncorporeal(v96.TurnEvil, v98.TurnEvilMouseOver, 1483 - (28 + 1425), true);
			if (v29 or ((3049 - (941 + 1052)) >= (3253 + 139))) then
				return v29;
			end
		end
		v29 = v114();
		if (v29 or ((2595 - (822 + 692)) < (1534 - 459))) then
			return v29;
		end
		if (v14 or ((495 + 554) >= (4729 - (45 + 252)))) then
			if (v78 or ((4718 + 50) <= (292 + 554))) then
				v29 = v113();
				if (v29 or ((8172 - 4814) <= (1853 - (114 + 319)))) then
					return v29;
				end
			end
		end
		v29 = v117();
		if (v29 or ((5367 - 1628) <= (3850 - 845))) then
			return v29;
		end
		if ((v96.Redemption:IsCastable() and v96.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1058 + 601) >= (3178 - 1044))) then
			if (v25(v98.RedemptionMouseover) or ((6830 - 3570) < (4318 - (556 + 1407)))) then
				return "redemption mouseover";
			end
		end
		if (v15:AffectingCombat() or ((1875 - (741 + 465)) == (4688 - (170 + 295)))) then
			if ((v96.Intercession:IsCastable() and (v15:HolyPower() >= (2 + 1)) and v96.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1555 + 137) < (1447 - 859))) then
				if (v25(v98.IntercessionMouseover) or ((3977 + 820) < (2342 + 1309))) then
					return "Intercession";
				end
			end
		end
		if ((v106.TargetIsValid() and not v15:AffectingCombat() and v30) or ((2366 + 1811) > (6080 - (957 + 273)))) then
			v29 = v118();
			if (v29 or ((107 + 293) > (445 + 666))) then
				return v29;
			end
		end
		if (((11625 - 8574) > (2648 - 1643)) and v106.TargetIsValid()) then
			if (((11280 - 7587) <= (21698 - 17316)) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
				if (v15:AffectingCombat() or ((5062 - (389 + 1391)) > (2573 + 1527))) then
					if (v96.Intercession:IsCastable() or ((373 + 3207) < (6474 - 3630))) then
						if (((1040 - (783 + 168)) < (15069 - 10579)) and v25(v96.Intercession, not v17:IsInRange(30 + 0), true)) then
							return "intercession";
						end
					end
				elseif (v96.Redemption:IsCastable() or ((5294 - (309 + 2)) < (5552 - 3744))) then
					if (((5041 - (1090 + 122)) > (1222 + 2547)) and v25(v96.Redemption, not v17:IsInRange(100 - 70), true)) then
						return "redemption";
					end
				end
			end
			if (((1017 + 468) <= (4022 - (628 + 490))) and v106.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
				local v203 = 0 + 0;
				while true do
					if (((10569 - 6300) == (19509 - 15240)) and (v203 == (774 - (431 + 343)))) then
						if (((781 - 394) <= (8047 - 5265)) and v101) then
							local v205 = 0 + 0;
							while true do
								if ((v205 == (0 + 0)) or ((3594 - (556 + 1139)) <= (932 - (6 + 9)))) then
									v29 = v116();
									if (v29 or ((790 + 3522) <= (449 + 427))) then
										return v29;
									end
									break;
								end
							end
						end
						if (((2401 - (28 + 141)) <= (1006 + 1590)) and (v84 < v108)) then
							v29 = v119();
							if (((2585 - 490) < (2611 + 1075)) and v29) then
								return v29;
							end
						end
						v203 = 1318 - (486 + 831);
					end
					if ((v203 == (5 - 3)) or ((5615 - 4020) >= (846 + 3628))) then
						if (v29 or ((14604 - 9985) < (4145 - (668 + 595)))) then
							return v29;
						end
						if (v25(v96.Pool) or ((265 + 29) >= (975 + 3856))) then
							return "Wait/Pool Resources";
						end
						break;
					end
					if (((5533 - 3504) <= (3374 - (23 + 267))) and (v203 == (1945 - (1129 + 815)))) then
						if ((v85 and ((v32 and v86) or not v86) and v17:IsInRange(395 - (371 + 16))) or ((3787 - (1326 + 424)) == (4583 - 2163))) then
							local v206 = 0 - 0;
							while true do
								if (((4576 - (88 + 30)) > (4675 - (720 + 51))) and (v206 == (0 - 0))) then
									v29 = v115();
									if (((2212 - (421 + 1355)) >= (202 - 79)) and v29) then
										return v29;
									end
									break;
								end
							end
						end
						v29 = v120();
						v203 = 1 + 1;
					end
				end
			end
		end
	end
	local function v125()
		v21.Print("Protection Paladin by Epic. Supported by xKaneto");
		v110();
	end
	v21.SetAPL(1149 - (286 + 797), v124, v125);
end;
return v0["Epix_Paladin_Protection.lua"]();

