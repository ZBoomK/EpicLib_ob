local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1519 - (381 + 89)) <= (804 + 102))) then
			return v6(...);
		end
		if (((3053 + 1460) > (4669 - 1943)) and (v5 == (1156 - (1074 + 82)))) then
			v6 = v0[v4];
			if (not v6 or ((3245 - 1764) >= (4442 - (214 + 1570)))) then
				return v1(v4, ...);
			end
			v5 = 1456 - (990 + 465);
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
	local v96;
	local v97;
	local v98;
	local v99;
	local v100 = v19.Paladin.Protection;
	local v101 = v20.Paladin.Protection;
	local v102 = v24.Paladin.Protection;
	local v103 = {};
	local v104;
	local v105;
	local v106, v107;
	local v108, v109;
	local v110 = v21.Commons.Everyone;
	local v111 = 4581 + 6530;
	local v112 = 4835 + 6276;
	local v113 = 0 + 0;
	v10:RegisterForEvent(function()
		v111 = 43727 - 32616;
		v112 = 12837 - (1668 + 58);
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (v100.CleanseToxins:IsAvailable() or ((3846 - (512 + 114)) == (3556 - 2192))) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v131)
		return v131:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 0 - 0;
	local function v118()
		if ((v100.CleanseToxins:IsReady() and v110.UnitHasDispellableDebuffByPlayer(v14)) or ((3667 - 2613) > (1578 + 1814))) then
			local v167 = 0 + 0;
			while true do
				if ((v167 == (0 + 0)) or ((2280 - 1604) >= (3636 - (109 + 1885)))) then
					if (((5605 - (1269 + 200)) > (4594 - 2197)) and (v117 == (815 - (98 + 717)))) then
						v117 = GetTime();
					end
					if (v110.Wait(1326 - (802 + 24), v117) or ((7473 - 3139) == (5361 - 1116))) then
						if (v25(v102.CleanseToxinsFocus) or ((632 + 3644) <= (2329 + 702))) then
							return "cleanse_toxins dispel";
						end
						v117 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((1032 + 3750) <= (3335 - 2136))) then
			if (v100.FlashofLight:IsReady() or ((16220 - 11356) < (681 + 1221))) then
				if (((1970 + 2869) >= (3052 + 648)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (1 + 0)) or ((2508 - (797 + 636)) > (9312 - 7394))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 1659 - (1427 + 192), nil);
				if (((138 + 258) <= (8831 - 5027)) and v29) then
					return v29;
				end
				break;
			end
			if ((v132 == (0 + 0)) or ((1890 + 2279) == (2513 - (192 + 134)))) then
				v29 = v110.HandleTopTrinket(v103, v32, 1316 - (316 + 960), nil);
				if (((783 + 623) == (1086 + 320)) and v29) then
					return v29;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v121()
		local v133 = 0 - 0;
		while true do
			if (((2082 - (83 + 468)) < (6077 - (1202 + 604))) and (v133 == (4 - 3))) then
				if (((1056 - 421) == (1758 - 1123)) and v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) then
					if (((3698 - (45 + 280)) <= (3433 + 123)) and v25(v100.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) or ((2876 + 415) < (1198 + 2082))) then
					if (((2428 + 1958) >= (154 + 719)) and v25(v100.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v133 = 3 - 1;
			end
			if (((2832 - (340 + 1571)) <= (435 + 667)) and (v133 == (1774 - (1733 + 39)))) then
				if (((12931 - 8225) >= (1997 - (125 + 909))) and v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) then
					if ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (1953 - (1096 + 852))) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff) or ((431 + 529) <= (1250 - 374))) then
						if (v25(v102.WordofGloryPlayer) or ((2004 + 62) == (1444 - (409 + 103)))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((5061 - (46 + 190)) < (4938 - (51 + 44))) and v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (1 + 1)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) then
					if (v25(v100.ShieldoftheRighteous) or ((5194 - (1114 + 203)) >= (5263 - (228 + 498)))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v133 = 1 + 2;
			end
			if ((v133 == (0 + 0)) or ((4978 - (174 + 489)) < (4496 - 2770))) then
				if (((v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((5584 - (830 + 1075)) < (1149 - (303 + 221)))) then
					if (v25(v100.DivineShield) or ((5894 - (231 + 1038)) < (527 + 105))) then
						return "divine_shield defensive";
					end
				end
				if (((v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((1245 - (171 + 991)) > (7335 - 5555))) then
					if (((1466 - 920) <= (2687 - 1610)) and v25(v102.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (10 - 7)) or ((2873 - 1877) > (6932 - 2631))) then
				if (((12581 - 8511) > (1935 - (111 + 1137))) and v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) then
					if (v25(v102.Healthstone) or ((814 - (91 + 67)) >= (9910 - 6580))) then
						return "healthstone defensive";
					end
				end
				if ((v93 and (v15:HealthPercentage() <= v95)) or ((622 + 1870) <= (858 - (423 + 100)))) then
					local v215 = 0 + 0;
					while true do
						if (((11966 - 7644) >= (1336 + 1226)) and (v215 == (771 - (326 + 445)))) then
							if ((v97 == "Refreshing Healing Potion") or ((15871 - 12234) >= (8398 - 4628))) then
								if (v101.RefreshingHealingPotion:IsReady() or ((5552 - 3173) > (5289 - (530 + 181)))) then
									if (v25(v102.RefreshingHealingPotion) or ((1364 - (614 + 267)) > (775 - (19 + 13)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((3993 - 1539) > (1346 - 768)) and (v97 == "Dreamwalker's Healing Potion")) then
								if (((2656 - 1726) < (1158 + 3300)) and v101.DreamwalkersHealingPotion:IsReady()) then
									if (((1163 - 501) <= (2015 - 1043)) and v25(v102.RefreshingHealingPotion)) then
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
		end
	end
	local function v122()
		local v134 = 1812 - (1293 + 519);
		while true do
			if (((8916 - 4546) == (11409 - 7039)) and ((1 - 0) == v134)) then
				if (v14 or ((20534 - 15772) <= (2028 - 1167))) then
					if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (2 + 1))) and (v14:HealthPercentage() <= v75)) or ((289 + 1123) == (9907 - 5643))) then
						if (v25(v102.WordofGloryFocus) or ((733 + 2435) < (716 + 1437))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) or ((3110 + 1866) < (2428 - (709 + 387)))) then
						if (((6486 - (673 + 1185)) == (13421 - 8793)) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) or ((173 - 119) == (649 - 254))) then
						if (((59 + 23) == (62 + 20)) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) or ((784 - 203) < (70 + 212))) then
						if (v25(v102.BlessingofProtectionFocus) or ((9189 - 4580) < (4897 - 2402))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((3032 - (446 + 1434)) == (2435 - (1040 + 243))) and (v134 == (0 - 0))) then
				if (((3743 - (559 + 1288)) <= (5353 - (609 + 1322))) and v16:Exists()) then
					if ((v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) or ((1444 - (13 + 441)) > (6053 - 4433))) then
						if (v25(v102.WordofGloryMouseover) or ((2297 - 1420) > (23383 - 18688))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((101 + 2590) >= (6722 - 4871)) and (not v14 or not v14:Exists() or not v14:IsInRange(11 + 19))) then
					return;
				end
				v134 = 1 + 0;
			end
		end
	end
	local function v123()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (1 + 0)) or ((5489 - 2504) >= (3211 + 1645))) then
				if (((2379 + 1897) >= (859 + 336)) and v100.Consecration:IsCastable() and v38) then
					if (((2714 + 518) <= (4589 + 101)) and v25(v100.Consecration, not v17:IsInRange(441 - (153 + 280)))) then
						return "consecration";
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36) or ((2587 - 1691) >= (2825 + 321))) then
					if (((1209 + 1852) >= (1548 + 1410)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v135 = 2 + 0;
			end
			if (((2310 + 877) >= (980 - 336)) and (v135 == (0 + 0))) then
				if (((1311 - (89 + 578)) <= (503 + 201)) and (v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) then
					if (((1991 - 1033) > (1996 - (572 + 477))) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((606 + 3886) >= (1593 + 1061)) and (v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1 + 4))) then
					if (((3528 - (84 + 2)) >= (2476 - 973)) and v25(v100.ArcaneTorrent, not v17:IsInRange(6 + 2))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 843 - (497 + 345);
			end
			if ((v135 == (1 + 1)) or ((536 + 2634) <= (2797 - (605 + 728)))) then
				if ((v100.Judgment:IsReady() and v42) or ((3423 + 1374) == (9755 - 5367))) then
					if (((26 + 525) <= (2517 - 1836)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if (((2955 + 322) > (1127 - 720)) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (2 + 0)) and v15:HasTier(518 - (457 + 32), 1 + 1)) then
			if (((6097 - (832 + 570)) >= (1334 + 81)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (1 + 1))) or ((11366 - 8154) <= (455 + 489))) then
			if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((3892 - (588 + 208)) <= (4845 - 3047))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((5337 - (884 + 916)) == (7404 - 3867)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
			if (((2225 + 1612) >= (2223 - (232 + 421))) and v25(v100.AvengingWrath, not v17:IsInRange(1897 - (1569 + 320)))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if ((v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) or ((724 + 2226) == (725 + 3087))) then
			if (((15915 - 11192) >= (2923 - (316 + 289))) and v25(v100.Sentinel, not v17:IsInRange(20 - 12))) then
				return "sentinel cooldowns 8";
			end
		end
		local v136 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
		if (v136 or ((94 + 1933) > (4305 - (666 + 787)))) then
			return v136;
		end
		if ((v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (440 - (360 + 65))) or (((v10.CombatTime() > (10 + 0)) or (v100.Sentinel:CooldownRemains() > (269 - (79 + 175))) or (v100.AvengingWrath:CooldownRemains() > (23 - 8))) and (v100.AvengersShield:CooldownRemains() > (0 + 0)) and (v100.Judgment:CooldownRemains() > (0 - 0)) and (v100.HammerofWrath:CooldownRemains() > (0 - 0))))) or ((2035 - (503 + 396)) > (4498 - (92 + 89)))) then
			if (((9210 - 4462) == (2435 + 2313)) and v25(v100.MomentOfGlory, not v17:IsInRange(5 + 3))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((14630 - 10894) <= (649 + 4091)) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (6 - 3))) then
			if (v25(v100.DivineToll, not v17:IsInRange(27 + 3)) or ((1620 + 1770) <= (9319 - 6259))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (4 + 26)))) or ((1522 - 523) > (3937 - (485 + 759)))) then
			if (((1071 - 608) < (1790 - (442 + 747))) and v25(v100.BastionofLight, not v17:IsInRange(1143 - (832 + 303)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v125()
		local v137 = 946 - (88 + 858);
		while true do
			if ((v137 == (2 + 3)) or ((1807 + 376) < (29 + 658))) then
				if (((5338 - (766 + 23)) == (22457 - 17908)) and v100.CrusaderStrike:IsCastable() and v39) then
					if (((6389 - 1717) == (12308 - 7636)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) or ((12449 - 8781) < (1468 - (1036 + 37)))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(6 + 2)) or ((8112 - 3946) == (358 + 97))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1485 - (641 + 839)))) or ((5362 - (910 + 3)) == (6788 - 4125))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(1692 - (1466 + 218))) or ((1966 + 2311) < (4137 - (556 + 592)))) then
						return "arcane_torrent standard 36";
					end
				end
				v137 = 3 + 3;
			end
			if ((v137 == (810 - (329 + 479))) or ((1724 - (174 + 680)) >= (14256 - 10107))) then
				if (((4584 - 2372) < (2273 + 910)) and v100.AvengersShield:IsCastable() and v36 and ((v109 > (741 - (396 + 343))) or v15:BuffUp(v100.MomentOfGloryBuff))) then
					if (((412 + 4234) > (4469 - (29 + 1448))) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((2823 - (135 + 1254)) < (11700 - 8594)) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) then
					if (((3669 - 2883) < (2015 + 1008)) and v25(v100.DivineToll, not v17:IsInRange(1557 - (389 + 1138)))) then
						return "divine_toll standard 16";
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36) or ((3016 - (102 + 472)) < (70 + 4))) then
					if (((2515 + 2020) == (4229 + 306)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v137 = 1548 - (320 + 1225);
			end
			if ((v137 == (5 - 2)) or ((1842 + 1167) <= (3569 - (157 + 1307)))) then
				if (((3689 - (821 + 1038)) < (9153 - 5484)) and v100.HammerofWrath:IsReady() and v41) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((157 + 1273) >= (6415 - 2803))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((999 + 1684) >= (6097 - 3637)) and v100.Judgment:IsReady() and v42) then
					local v216 = 1026 - (834 + 192);
					while true do
						if ((v216 == (0 + 0)) or ((464 + 1340) >= (71 + 3204))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((2194 - 777) > (3933 - (300 + 4)))) then
								return "judgment standard 22";
							end
							if (((1281 + 3514) > (1052 - 650)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if (((5175 - (112 + 250)) > (1422 + 2143)) and v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (12 - 7)) or not v15:HasTier(18 + 13, 2 + 0))) then
					if (((2926 + 986) == (1940 + 1972)) and v25(v100.Consecration, not v17:IsInRange(6 + 2))) then
						return "consecration standard 24";
					end
				end
				v137 = 1418 - (1001 + 413);
			end
			if (((6290 - 3469) <= (5706 - (244 + 638))) and (v137 == (693 - (627 + 66)))) then
				if (((5178 - 3440) <= (2797 - (512 + 90))) and v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (1911 - (1665 + 241)))) then
					if (((758 - (373 + 344)) <= (1362 + 1656)) and v25(v100.Consecration, not v17:IsInRange(3 + 5))) then
						return "consecration standard 2";
					end
				end
				if (((5657 - 3512) <= (6944 - 2840)) and v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (1101 - (35 + 1064))) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (4 + 1)))) then
					if (((5752 - 3063) < (20 + 4825)) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v100.Judgment:IsReady() and v42 and (v108 > (1239 - (298 + 938))) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (1262 - (233 + 1026))) and (v15:HolyPower() < (1669 - (636 + 1030)))) or ((1188 + 1134) > (2562 + 60))) then
					local v217 = 0 + 0;
					while true do
						if ((v217 == (0 + 0)) or ((4755 - (55 + 166)) == (404 + 1678))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((158 + 1413) > (7130 - 5263))) then
								return "judgment standard 6";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2951 - (36 + 261)) >= (5238 - 2242))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v137 = 1369 - (34 + 1334);
			end
			if (((1530 + 2448) > (1635 + 469)) and (v137 == (1284 - (1035 + 248)))) then
				if (((3016 - (20 + 1)) > (803 + 738)) and v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(350 - (134 + 185), 1135 - (549 + 584))) then
					local v218 = 685 - (314 + 371);
					while true do
						if (((11153 - 7904) > (1921 - (478 + 490))) and (v218 == (0 + 0))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((4445 - (786 + 386)) > (14811 - 10238))) then
								return "judgment standard 8";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((4530 - (1055 + 324)) < (2624 - (1093 + 247)))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v100.HammerofWrath:IsReady() and v41) or ((1644 + 206) == (161 + 1368))) then
					if (((3259 - 2438) < (7204 - 5081)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((2566 - 1664) < (5842 - 3517)) and v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (1 + 1)) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) then
					if (((3305 - 2447) <= (10209 - 7247)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 12";
					end
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2976 + 970) < (3293 - 2005))) then
						return "judgment standard 12";
					end
				end
				v137 = 690 - (364 + 324);
			end
			if ((v137 == (16 - 10)) or ((7779 - 4537) == (188 + 379))) then
				if ((v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) or ((3544 - 2697) >= (2022 - 759))) then
					if (v25(v100.Consecration, not v17:IsInRange(24 - 16)) or ((3521 - (1249 + 19)) == (1671 + 180))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v137 == (15 - 11)) or ((3173 - (686 + 400)) > (1862 + 510))) then
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (232 - (73 + 156)))) or ((22 + 4423) < (4960 - (721 + 90)))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(1 + 7)) or ((5902 - 4084) == (555 - (224 + 246)))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((1020 - 390) < (3916 - 1789)) and v100.BlessedHammer:IsCastable() and v37) then
					if (v25(v100.BlessedHammer, not v17:IsInRange(2 + 6)) or ((47 + 1891) == (1847 + 667))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((8459 - 4204) >= (183 - 128)) and v100.HammeroftheRighteous:IsCastable() and v40) then
					if (((3512 - (203 + 310)) > (3149 - (1238 + 755))) and v25(v100.HammeroftheRighteous, not v17:IsInRange(1 + 7))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v137 = 1539 - (709 + 825);
			end
		end
	end
	local function v126()
		v34 = EpicSettings.Settings['swapAuras'];
		v35 = EpicSettings.Settings['useWeapon'];
		v36 = EpicSettings.Settings['useAvengersShield'];
		v37 = EpicSettings.Settings['useBlessedHammer'];
		v38 = EpicSettings.Settings['useConsecration'];
		v39 = EpicSettings.Settings['useCrusaderStrike'];
		v40 = EpicSettings.Settings['useHammeroftheRighteous'];
		v41 = EpicSettings.Settings['useHammerofWrath'];
		v42 = EpicSettings.Settings['useJudgment'];
		v43 = EpicSettings.Settings['useAvengingWrath'];
		v44 = EpicSettings.Settings['useBastionofLight'];
		v45 = EpicSettings.Settings['useDivineToll'];
		v46 = EpicSettings.Settings['useEyeofTyr'];
		v47 = EpicSettings.Settings['useMomentOfGlory'];
		v48 = EpicSettings.Settings['useSentinel'];
		v49 = EpicSettings.Settings['avengingWrathWithCD'];
		v50 = EpicSettings.Settings['bastionofLightWithCD'];
		v51 = EpicSettings.Settings['divineTollWithCD'];
		v52 = EpicSettings.Settings['eyeofTyrWithCD'];
		v53 = EpicSettings.Settings['momentOfGloryWithCD'];
		v54 = EpicSettings.Settings['sentinelWithCD'];
	end
	local function v127()
		local v159 = 0 - 0;
		while true do
			if (((3423 - 1073) > (2019 - (196 + 668))) and ((3 - 2) == v159)) then
				v59 = EpicSettings.Settings['useGuardianofAncientKings'];
				v60 = EpicSettings.Settings['useLayOnHands'];
				v61 = EpicSettings.Settings['useWordofGloryPlayer'];
				v62 = EpicSettings.Settings['useShieldoftheRighteous'];
				v159 = 3 - 1;
			end
			if (((4862 - (171 + 662)) <= (4946 - (4 + 89))) and (v159 == (17 - 12))) then
				v75 = EpicSettings.Settings['wordofGloryFocusHP'];
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v159 = 3 + 3;
			end
			if ((v159 == (0 - 0)) or ((203 + 313) > (4920 - (35 + 1451)))) then
				v55 = EpicSettings.Settings['useRebuke'];
				v56 = EpicSettings.Settings['useHammerofJustice'];
				v57 = EpicSettings.Settings['useArdentDefender'];
				v58 = EpicSettings.Settings['useDivineShield'];
				v159 = 1454 - (28 + 1425);
			end
			if (((6039 - (941 + 1052)) >= (2909 + 124)) and (v159 == (1517 - (822 + 692)))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['ardentDefenderHP'];
				v69 = EpicSettings.Settings['divineShieldHP'];
				v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v159 = 5 - 1;
			end
			if ((v159 == (2 + 2)) or ((3016 - (45 + 252)) <= (1432 + 15))) then
				v71 = EpicSettings.Settings['layonHandsHP'];
				v72 = EpicSettings.Settings['wordofGloryHP'];
				v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v74 = EpicSettings.Settings['layOnHandsFocusHP'];
				v159 = 2 + 3;
			end
			if ((v159 == (14 - 8)) or ((4567 - (114 + 319)) < (5636 - 1710))) then
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v159 == (2 - 0)) or ((105 + 59) >= (4149 - 1364))) then
				v63 = EpicSettings.Settings['useLayOnHandsFocus'];
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v159 = 5 - 2;
			end
		end
	end
	local function v128()
		local v160 = 1963 - (556 + 1407);
		while true do
			if (((1212 - (741 + 465)) == v160) or ((990 - (170 + 295)) == (1112 + 997))) then
				v99 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
			if (((80 - 47) == (28 + 5)) and (v160 == (0 + 0))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v160 = 1231 - (957 + 273);
			end
			if (((817 + 2237) <= (1608 + 2407)) and ((3 - 2) == v160)) then
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v160 = 5 - 3;
			end
			if (((5714 - 3843) < (16746 - 13364)) and (v160 == (1785 - (389 + 1391)))) then
				v83 = EpicSettings.Settings['handleAfflicted'];
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				v98 = EpicSettings.Settings['HealOOC'];
				v160 = 4 + 2;
			end
			if (((135 + 1158) <= (4930 - 2764)) and (v160 == (955 - (783 + 168)))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v160 = 316 - (309 + 2);
			end
			if ((v160 == (9 - 6)) or ((3791 - (1090 + 122)) < (40 + 83))) then
				v92 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v160 = 13 - 9;
			end
			if ((v160 == (2 + 0)) or ((1964 - (628 + 490)) >= (425 + 1943))) then
				v89 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v160 = 7 - 4;
			end
		end
	end
	local function v129()
		v127();
		v126();
		v128();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((18334 - 14322) <= (4132 - (431 + 343)))) then
			return v29;
		end
		v106 = v15:GetEnemiesInMeleeRange(16 - 8);
		v107 = v15:GetEnemiesInRange(86 - 56);
		if (((1181 + 313) <= (385 + 2620)) and v31) then
			v108 = #v106;
			v109 = #v107;
		else
			v108 = 1696 - (556 + 1139);
			v109 = 16 - (6 + 9);
		end
		v104 = v15:ActiveMitigationNeeded();
		v105 = v15:IsTankingAoE(2 + 6) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1594 + 1517) == (2303 - (28 + 141)))) then
			if (((913 + 1442) == (2906 - 551)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) then
				if (v25(v100.CrusaderAura) or ((417 + 171) <= (1749 - (486 + 831)))) then
					return "crusader_aura";
				end
			end
		end
		if (((12482 - 7685) >= (13712 - 9817)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (((676 + 2901) == (11310 - 7733)) and v15:AffectingCombat()) then
				if (((5057 - (668 + 595)) > (3324 + 369)) and v100.Intercession:IsCastable()) then
					if (v25(v100.Intercession, not v17:IsInRange(7 + 23), true) or ((3477 - 2202) == (4390 - (23 + 267)))) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((3535 - (1129 + 815)) >= (3967 - (371 + 16)))) then
				if (((2733 - (1326 + 424)) <= (3424 - 1616)) and v25(v100.Redemption, not v17:IsInRange(109 - 79), true)) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((2268 - (88 + 30)) <= (1968 - (720 + 51)))) then
			if (((8383 - 4614) >= (2949 - (421 + 1355))) and v25(v102.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((2449 - 964) == (730 + 755)) and v15:AffectingCombat()) then
			if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (1086 - (286 + 797))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((12118 - 8803) <= (4607 - 1825))) then
				if (v25(v102.IntercessionMouseover) or ((1315 - (397 + 42)) >= (926 + 2038))) then
					return "Intercession";
				end
			end
		end
		if (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()) or ((3032 - (24 + 776)) > (3846 - 1349))) then
			local v168 = 785 - (222 + 563);
			local v169;
			while true do
				if ((v168 == (0 - 0)) or ((1520 + 590) <= (522 - (23 + 167)))) then
					v169 = v82 and v100.CleanseToxins:IsReady() and v33;
					v29 = v110.FocusUnit(v169, nil, 1818 - (690 + 1108), nil, 10 + 15, v100.FlashofLight);
					v168 = 1 + 0;
				end
				if (((4534 - (40 + 808)) > (523 + 2649)) and (v168 == (3 - 2))) then
					if (v29 or ((4277 + 197) < (434 + 386))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((2347 + 1932) >= (3453 - (47 + 524))) and v33 and v82) then
			local v170 = 0 + 0;
			while true do
				if ((v170 == (0 - 0)) or ((3033 - 1004) >= (8030 - 4509))) then
					v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1766 - (1165 + 561), 1 + 24, v100.FlashofLight);
					if (v29 or ((6308 - 4271) >= (1772 + 2870))) then
						return v29;
					end
					v170 = 480 - (341 + 138);
				end
				if (((465 + 1255) < (9199 - 4741)) and (v170 == (327 - (89 + 237)))) then
					if ((v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((1402 - 966) > (6359 - 3338))) then
						if (((1594 - (581 + 300)) <= (2067 - (855 + 365))) and v25(v102.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (((5116 - 2962) <= (1317 + 2714)) and (v110.TargetIsValid() or v15:AffectingCombat())) then
			local v171 = 1235 - (1030 + 205);
			while true do
				if (((4333 + 282) == (4294 + 321)) and (v171 == (286 - (156 + 130)))) then
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					v171 = 2 - 1;
				end
				if ((v171 == (1 - 0)) or ((7762 - 3972) == (132 + 368))) then
					if (((52 + 37) < (290 - (10 + 59))) and (v112 == (3143 + 7968))) then
						v112 = v10.FightRemains(v106, false);
					end
					v113 = v15:HolyPower();
					break;
				end
			end
		end
		if (((10115 - 8061) >= (2584 - (671 + 492))) and not v15:AffectingCombat()) then
			if (((551 + 141) < (4273 - (369 + 846))) and v100.DevotionAura:IsCastable() and (v116()) and v34) then
				if (v25(v100.DevotionAura) or ((862 + 2392) == (1413 + 242))) then
					return "devotion_aura";
				end
			end
		end
		if (v83 or ((3241 - (1036 + 909)) == (3904 + 1006))) then
			local v172 = 0 - 0;
			while true do
				if (((3571 - (11 + 192)) == (1703 + 1665)) and (v172 == (175 - (135 + 40)))) then
					if (((6403 - 3760) < (2300 + 1515)) and v79) then
						v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 88 - 48);
						if (((2867 - 954) > (669 - (50 + 126))) and v29) then
							return v29;
						end
					end
					if (((13240 - 8485) > (759 + 2669)) and v15:BuffUp(v100.ShiningLightFreeBuff) and v80) then
						v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 1453 - (1233 + 180), true);
						if (((2350 - (522 + 447)) <= (3790 - (107 + 1314))) and v29) then
							return v29;
						end
					end
					break;
				end
			end
		end
		if (v84 or ((2248 + 2595) == (12444 - 8360))) then
			local v173 = 0 + 0;
			while true do
				if (((9271 - 4602) > (1436 - 1073)) and (v173 == (1911 - (716 + 1194)))) then
					v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 1 + 29, true);
					if (v29 or ((202 + 1675) >= (3641 - (74 + 429)))) then
						return v29;
					end
					break;
				end
				if (((9147 - 4405) >= (1798 + 1828)) and (v173 == (0 - 0))) then
					v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 22 + 8, true);
					if (v29 or ((13996 - 9456) == (2264 - 1348))) then
						return v29;
					end
					v173 = 434 - (279 + 154);
				end
			end
		end
		v29 = v119();
		if (v29 or ((1934 - (454 + 324)) > (3419 + 926))) then
			return v29;
		end
		if (((2254 - (12 + 5)) < (2291 + 1958)) and v82 and v33) then
			if (v14 or ((6835 - 4152) < (9 + 14))) then
				v29 = v118();
				if (((1790 - (277 + 816)) <= (3529 - 2703)) and v29) then
					return v29;
				end
			end
			if (((2288 - (1058 + 125)) <= (221 + 955)) and v16 and v16:Exists() and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16))) then
				if (((4354 - (815 + 160)) <= (16355 - 12543)) and v100.CleanseToxins:IsReady()) then
					if (v25(v102.CleanseToxinsMouseover) or ((1870 - 1082) >= (386 + 1230))) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v29 = v122();
		if (((5419 - 3565) <= (5277 - (41 + 1857))) and v29) then
			return v29;
		end
		if (((6442 - (1222 + 671)) == (11757 - 7208)) and v105) then
			v29 = v121();
			if (v29 or ((4343 - 1321) >= (4206 - (229 + 953)))) then
				return v29;
			end
		end
		if (((6594 - (1111 + 663)) > (3777 - (874 + 705))) and v110.TargetIsValid() and not v15:AffectingCombat() and v30) then
			v29 = v123();
			if (v29 or ((149 + 912) >= (3337 + 1554))) then
				return v29;
			end
		end
		if (((2834 - 1470) <= (126 + 4347)) and v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
			if ((v88 < v112) or ((4274 - (642 + 37)) <= (1 + 2))) then
				local v214 = 0 + 0;
				while true do
					if ((v214 == (0 - 0)) or ((5126 - (233 + 221)) == (8907 - 5055))) then
						v29 = v124();
						if (((1373 + 186) == (3100 - (718 + 823))) and v29) then
							return v29;
						end
						v214 = 1 + 0;
					end
					if ((v214 == (806 - (266 + 539))) or ((4960 - 3208) <= (2013 - (636 + 589)))) then
						if ((v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((9274 - 5367) == (365 - 188))) then
							if (((2750 + 720) > (202 + 353)) and v25(v102.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
						break;
					end
				end
			end
			if ((v89 and ((v32 and v90) or not v90) and v17:IsInRange(1023 - (657 + 358))) or ((2573 - 1601) == (1469 - 824))) then
				v29 = v120();
				if (((4369 - (1151 + 36)) >= (2043 + 72)) and v29) then
					return v29;
				end
			end
			v29 = v125();
			if (((1024 + 2869) < (13226 - 8797)) and v29) then
				return v29;
			end
			if (v25(v100.Pool) or ((4699 - (1552 + 280)) < (2739 - (64 + 770)))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v130()
		v21.Print("Protection Paladin by Epic. Supported by xKaneto");
		v114();
	end
	v21.SetAPL(45 + 21, v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

