local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 326 - (192 + 134);
	local v6;
	while true do
		if ((v5 == (1276 - (316 + 960))) or ((2486 + 1981) <= (359 + 105))) then
			v6 = v0[v4];
			if (not v6 or ((481 + 39) > (7240 - 5346))) then
				return v1(v4, ...);
			end
			v5 = 552 - (83 + 468);
		end
		if ((v5 == (1807 - (1202 + 604))) or ((7338 - 5766) > (6448 - 2573))) then
			return v6(...);
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
	local v98 = v19.Paladin.Protection;
	local v99 = v20.Paladin.Protection;
	local v100 = v24.Paladin.Protection;
	local v101 = {};
	local v102;
	local v103;
	local v104, v105;
	local v106, v107;
	local v108 = v21.Commons.Everyone;
	local v109 = 30763 - 19652;
	local v110 = 11436 - (45 + 280);
	local v111 = 0 + 0;
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if (((1659 + 2883) == (2514 + 2028)) and (v129 == (0 + 0))) then
				v109 = 20574 - 9463;
				v110 = 13022 - (340 + 1571);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		if (v98.CleanseToxins:IsAvailable() or ((1054 + 1616) < (3511 - (1733 + 39)))) then
			v108.DispellableDebuffs = v13.MergeTable(v108.DispellableDiseaseDebuffs, v108.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v113(v130)
		return v130:DebuffRemains(v98.JudgmentDebuff);
	end
	local function v114()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local v115 = 0 - 0;
	local function v116()
		if ((v98.CleanseToxins:IsReady() and v108.DispellableFriendlyUnit(1059 - (125 + 909))) or ((2280 - (1096 + 852)) >= (1796 + 2207))) then
			local v169 = 0 - 0;
			while true do
				if ((v169 == (0 + 0)) or ((3803 - (409 + 103)) <= (3516 - (46 + 190)))) then
					if (((4481 - (51 + 44)) >= (247 + 626)) and (v115 == (1317 - (1114 + 203)))) then
						v115 = GetTime();
					end
					if (((1647 - (228 + 498)) <= (239 + 863)) and v108.Wait(277 + 223, v115)) then
						local v222 = 663 - (174 + 489);
						while true do
							if (((12260 - 7554) >= (2868 - (830 + 1075))) and (v222 == (524 - (303 + 221)))) then
								if (v25(v100.CleanseToxinsFocus) or ((2229 - (231 + 1038)) <= (730 + 146))) then
									return "cleanse_toxins dispel";
								end
								v115 = 1162 - (171 + 991);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((8514 - 6448) == (2502 - 1570))) then
			if (((12040 - 7215) < (3877 + 966)) and v98.FlashofLight:IsReady()) then
				if (v25(v98.FlashofLight) or ((13590 - 9713) >= (13088 - 8551))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 - 0)) or ((5563 - (111 + 1137)) < (1884 - (91 + 67)))) then
				v29 = v108.HandleTopTrinket(v101, v32, 119 - 79, nil);
				if (v29 or ((918 + 2761) < (1148 - (423 + 100)))) then
					return v29;
				end
				v131 = 1 + 0;
			end
			if ((v131 == (2 - 1)) or ((2411 + 2214) < (1403 - (326 + 445)))) then
				v29 = v108.HandleBottomTrinket(v101, v32, 174 - 134, nil);
				if (v29 or ((184 - 101) > (4154 - 2374))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v119()
		local v132 = 711 - (530 + 181);
		while true do
			if (((1427 - (614 + 267)) <= (1109 - (19 + 13))) and (v132 == (1 - 0))) then
				if ((v98.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v98.ArdentDefenderBuff)) or ((2320 - 1324) > (12286 - 7985))) then
					if (((1058 + 3012) > (1208 - 521)) and v25(v98.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v98.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v66) and v55 and v15:BuffDown(v98.GuardianofAncientKingsBuff)) or ((1360 - 704) >= (5142 - (1293 + 519)))) then
					if (v25(v98.ArdentDefender) or ((5083 - 2591) <= (874 - 539))) then
						return "ardent_defender defensive 6";
					end
				end
				v132 = 3 - 1;
			end
			if (((18636 - 14314) >= (6035 - 3473)) and (v132 == (2 + 1))) then
				if ((v99.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((743 + 2894) >= (8759 - 4989))) then
					if (v25(v100.Healthstone) or ((550 + 1829) > (1521 + 3057))) then
						return "healthstone defensive";
					end
				end
				if ((v91 and (v15:HealthPercentage() <= v93)) or ((302 + 181) > (1839 - (709 + 387)))) then
					local v207 = 1858 - (673 + 1185);
					while true do
						if (((7116 - 4662) > (1855 - 1277)) and (v207 == (0 - 0))) then
							if (((666 + 264) < (3332 + 1126)) and (v95 == "Refreshing Healing Potion")) then
								if (((893 - 231) <= (239 + 733)) and v99.RefreshingHealingPotion:IsReady()) then
									if (((8713 - 4343) == (8578 - 4208)) and v25(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v95 == "Dreamwalker's Healing Potion") or ((6642 - (446 + 1434)) <= (2144 - (1040 + 243)))) then
								if (v99.DreamwalkersHealingPotion:IsReady() or ((4214 - 2802) == (6111 - (559 + 1288)))) then
									if (v25(v100.RefreshingHealingPotion) or ((5099 - (609 + 1322)) < (2607 - (13 + 441)))) then
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
			if (((0 - 0) == v132) or ((13033 - 8057) < (6633 - 5301))) then
				if (((173 + 4455) == (16807 - 12179)) and (v15:HealthPercentage() <= v67) and v56 and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
					if (v25(v98.DivineShield) or ((20 + 34) == (174 + 221))) then
						return "divine_shield defensive";
					end
				end
				if (((243 - 161) == (45 + 37)) and (v15:HealthPercentage() <= v69) and v58 and v98.LayonHands:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
					if (v25(v100.LayonHandsPlayer) or ((1068 - 487) < (187 + 95))) then
						return "lay_on_hands defensive 2";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (2 + 0)) or ((3870 + 739) < (2442 + 53))) then
				if (((1585 - (153 + 280)) == (3326 - 2174)) and v98.WordofGlory:IsReady() and (v15:HealthPercentage() <= v70) and v59 and not v15:HealingAbsorbed()) then
					if (((1703 + 193) <= (1352 + 2070)) and ((v15:BuffRemains(v98.ShieldoftheRighteousBuff) >= (3 + 2)) or v15:BuffUp(v98.DivinePurposeBuff) or v15:BuffUp(v98.ShiningLightFreeBuff))) then
						if (v25(v100.WordofGloryPlayer) or ((899 + 91) > (1174 + 446))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v98.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 - 0)) and v15:BuffRefreshable(v98.ShieldoftheRighteousBuff) and v60 and (v102 or (v15:HealthPercentage() <= v71))) or ((543 + 334) > (5362 - (89 + 578)))) then
					if (((1923 + 768) >= (3847 - 1996)) and v25(v98.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v132 = 1052 - (572 + 477);
			end
		end
	end
	local function v120()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 + 0)) or ((357 + 2628) >= (4942 - (84 + 2)))) then
				if (((7046 - 2770) >= (861 + 334)) and v16:Exists()) then
					if (((4074 - (497 + 345)) <= (120 + 4570)) and v98.WordofGlory:IsReady() and v63 and (v16:HealthPercentage() <= v74)) then
						if (v25(v100.WordofGloryMouseover) or ((152 + 744) >= (4479 - (605 + 728)))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((2184 + 877) >= (6576 - 3618)) and (not v14 or not v14:Exists() or not v14:IsInRange(2 + 28))) then
					return;
				end
				v133 = 3 - 2;
			end
			if (((2874 + 313) >= (1784 - 1140)) and (v133 == (1 + 0))) then
				if (((1133 - (457 + 32)) <= (299 + 405)) and v14) then
					if (((2360 - (832 + 570)) > (893 + 54)) and v98.WordofGlory:IsReady() and v62 and v15:BuffUp(v98.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v73)) then
						if (((1172 + 3320) >= (9391 - 6737)) and v25(v100.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((1659 + 1783) >= (2299 - (588 + 208))) and v98.LayonHands:IsCastable() and v61 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) then
						if (v25(v100.LayonHandsFocus) or ((8543 - 5373) <= (3264 - (884 + 916)))) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v98.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((10042 - 5245) == (2545 + 1843))) then
						if (((1204 - (232 + 421)) <= (2570 - (1569 + 320))) and v25(v100.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((804 + 2473) > (78 + 329)) and v98.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
						if (((15821 - 11126) >= (2020 - (316 + 289))) and v25(v100.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (1 + 1)) or ((4665 - (666 + 787)) <= (1369 - (360 + 65)))) then
				if ((v98.Judgment:IsReady() and v40) or ((2894 + 202) <= (2052 - (79 + 175)))) then
					if (((5576 - 2039) == (2761 + 776)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((11761 - 7924) >= (3023 - 1453)) and (v134 == (899 - (503 + 396)))) then
				if (((v86 < v110) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90)) or ((3131 - (92 + 89)) == (7394 - 3582))) then
					if (((2423 + 2300) >= (1372 + 946)) and v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v86 < v110) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (19 - 14))) or ((278 + 1749) > (6502 - 3650))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(7 + 1)) or ((543 + 593) > (13148 - 8831))) then
						return "arcane_torrent precombat 6";
					end
				end
				v134 = 1 + 0;
			end
			if (((7240 - 2492) == (5992 - (485 + 759))) and ((2 - 1) == v134)) then
				if (((4925 - (442 + 747)) <= (5875 - (832 + 303))) and v98.Consecration:IsCastable() and v36) then
					if (v25(v98.Consecration, not v17:IsInRange(954 - (88 + 858))) or ((1034 + 2356) <= (2533 + 527))) then
						return "consecration";
					end
				end
				if ((v98.AvengersShield:IsCastable() and v34) or ((42 + 957) > (3482 - (766 + 23)))) then
					if (((2285 - 1822) < (821 - 220)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v134 = 4 - 2;
			end
		end
	end
	local function v122()
		if ((v98.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (6 - 4)) and v15:HasTier(1102 - (1036 + 37), 2 + 0)) or ((4250 - 2067) < (541 + 146))) then
			if (((6029 - (641 + 839)) == (5462 - (910 + 3))) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield cooldowns 2";
			end
		end
		if (((11910 - 7238) == (6356 - (1466 + 218))) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90) and (v107 >= (1 + 1))) then
			if (v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment)) or ((4816 - (556 + 592)) < (141 + 254))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((4974 - (329 + 479)) == (1309 - (174 + 680)))) then
			if (v25(v98.AvengingWrath, not v17:IsInRange(27 - 19)) or ((9221 - 4772) == (1902 + 761))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if ((v98.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) or ((5016 - (396 + 343)) < (265 + 2724))) then
			if (v25(v98.Sentinel, not v17:IsInRange(1485 - (29 + 1448))) or ((2259 - (135 + 1254)) >= (15630 - 11481))) then
				return "sentinel cooldowns 8";
			end
		end
		local v135 = v108.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff));
		if (((10328 - 8116) < (2122 + 1061)) and v135) then
			return v135;
		end
		if (((6173 - (389 + 1138)) > (3566 - (102 + 472))) and v98.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v98.SentinelBuff) < (15 + 0)) or (((v10.CombatTime() > (6 + 4)) or (v98.Sentinel:CooldownRemains() > (14 + 1)) or (v98.AvengingWrath:CooldownRemains() > (1560 - (320 + 1225)))) and (v98.AvengersShield:CooldownRemains() > (0 - 0)) and (v98.Judgment:CooldownRemains() > (0 + 0)) and (v98.HammerofWrath:CooldownRemains() > (1464 - (157 + 1307)))))) then
			if (((3293 - (821 + 1038)) < (7749 - 4643)) and v25(v98.MomentofGlory, not v17:IsInRange(1 + 7))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if (((1395 - 609) < (1125 + 1898)) and v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady() and (v106 >= (7 - 4))) then
			if (v25(v98.DivineToll, not v17:IsInRange(1056 - (834 + 192))) or ((156 + 2286) < (19 + 55))) then
				return "divine_toll cooldowns 12";
			end
		end
		if (((98 + 4437) == (7025 - 2490)) and v98.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v98.AvengingWrathBuff) or (v98.AvengingWrath:CooldownRemains() <= (334 - (300 + 4))))) then
			if (v25(v98.BastionofLight, not v17:IsInRange(3 + 5)) or ((7876 - 4867) <= (2467 - (112 + 250)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v123()
		local v136 = 0 + 0;
		while true do
			if (((4584 - 2754) < (2102 + 1567)) and (v136 == (2 + 0))) then
				if ((v98.AvengersShield:IsCastable() and v34 and ((v107 > (2 + 0)) or v15:BuffUp(v98.MomentofGloryBuff))) or ((710 + 720) >= (2684 + 928))) then
					if (((4097 - (1001 + 413)) >= (5485 - 3025)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady()) or ((2686 - (244 + 638)) >= (3968 - (627 + 66)))) then
					if (v25(v98.DivineToll, not v17:IsInRange(89 - 59)) or ((2019 - (512 + 90)) > (5535 - (1665 + 241)))) then
						return "divine_toll standard 16";
					end
				end
				if (((5512 - (373 + 344)) > (182 + 220)) and v98.AvengersShield:IsCastable() and v34) then
					if (((1274 + 3539) > (9403 - 5838)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v136 = 4 - 1;
			end
			if (((5011 - (35 + 1064)) == (2847 + 1065)) and (v136 == (0 - 0))) then
				if (((12 + 2809) <= (6060 - (298 + 938))) and v98.Consecration:IsCastable() and v36 and (v15:BuffStack(v98.SanctificationBuff) == (1264 - (233 + 1026)))) then
					if (((3404 - (636 + 1030)) <= (1123 + 1072)) and v25(v98.Consecration, not v17:IsInRange(8 + 0))) then
						return "consecration standard 2";
					end
				end
				if (((13 + 28) <= (204 + 2814)) and v98.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (223 - (55 + 166))) or v15:BuffUp(v98.BastionofLightBuff) or v15:BuffUp(v98.DivinePurposeBuff)) and (v15:BuffDown(v98.SanctificationBuff) or (v15:BuffStack(v98.SanctificationBuff) < (1 + 4)))) then
					if (((216 + 1929) <= (15673 - 11569)) and v25(v98.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((2986 - (36 + 261)) < (8472 - 3627)) and v98.Judgment:IsReady() and v40 and (v106 > (1371 - (34 + 1334))) and (v15:BuffStack(v98.BulwarkofRighteousFuryBuff) >= (2 + 1)) and (v15:HolyPower() < (3 + 0))) then
					local v208 = 1283 - (1035 + 248);
					while true do
						if ((v208 == (21 - (20 + 1))) or ((1210 + 1112) > (2941 - (134 + 185)))) then
							if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((5667 - (549 + 584)) == (2767 - (314 + 371)))) then
								return "judgment standard 6";
							end
							if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((5393 - 3822) > (2835 - (478 + 490)))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v136 = 1 + 0;
			end
			if ((v136 == (1177 - (786 + 386))) or ((8596 - 5942) >= (4375 - (1055 + 324)))) then
				if (((5318 - (1093 + 247)) > (1870 + 234)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((315 + 2680) > (6118 - 4577)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((11026 - 7777) > (2711 - 1758)) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and not v98.InmostLight:IsAvailable()) then
					if (v25(v98.EyeofTyr, not v17:IsInRange(19 - 11)) or ((1165 + 2108) > (17616 - 13043))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (17 - 12))) or ((2376 + 775) < (3283 - 1999))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(696 - (364 + 324))) or ((5071 - 3221) == (3668 - 2139))) then
						return "arcane_torrent standard 36";
					end
				end
				v136 = 2 + 4;
			end
			if (((3435 - 2614) < (3399 - 1276)) and (v136 == (18 - 12))) then
				if (((2170 - (1249 + 19)) < (2099 + 226)) and v98.Consecration:IsCastable() and v36 and (v15:BuffDown(v98.SanctificationEmpowerBuff))) then
					if (((3339 - 2481) <= (4048 - (686 + 400))) and v25(v98.Consecration, not v17:IsInRange(7 + 1))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v136 == (233 - (73 + 156))) or ((19 + 3927) < (2099 - (721 + 90)))) then
				if (((v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and v98.InmostLight:IsAvailable() and (v106 >= (1 + 2))) or ((10526 - 7284) == (1037 - (224 + 246)))) then
					if (v25(v98.EyeofTyr, not v17:IsInRange(12 - 4)) or ((1559 - 712) >= (230 + 1033))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((v98.BlessedHammer:IsCastable() and v35) or ((54 + 2199) == (1360 + 491))) then
					if (v25(v98.BlessedHammer, not v17:IsInRange(15 - 7)) or ((6944 - 4857) > (2885 - (203 + 310)))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v98.HammeroftheRighteous:IsCastable() and v38) or ((6438 - (1238 + 755)) < (290 + 3859))) then
					if (v25(v98.HammeroftheRighteous, not v17:IsInRange(1542 - (709 + 825))) or ((3349 - 1531) == (123 - 38))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v136 = 869 - (196 + 668);
			end
			if (((2487 - 1857) < (4405 - 2278)) and (v136 == (834 - (171 + 662)))) then
				if ((v98.Judgment:IsReady() and v40 and v15:BuffDown(v98.SanctificationEmpowerBuff) and v15:HasTier(124 - (4 + 89), 6 - 4)) or ((706 + 1232) == (11042 - 8528))) then
					local v209 = 0 + 0;
					while true do
						if (((5741 - (35 + 1451)) >= (1508 - (28 + 1425))) and (v209 == (1993 - (941 + 1052)))) then
							if (((2876 + 123) > (2670 - (822 + 692))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 8";
							end
							if (((3355 - 1005) > (545 + 610)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if (((4326 - (45 + 252)) <= (4802 + 51)) and v98.HammerofWrath:IsReady() and v39) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((178 + 338) > (8357 - 4923))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((4479 - (114 + 319)) >= (4353 - 1320)) and v98.Judgment:IsReady() and v40 and ((v98.Judgment:Charges() >= (2 - 0)) or (v98.Judgment:FullRechargeTime() <= v15:GCD()))) then
					local v210 = 0 + 0;
					while true do
						if ((v210 == (0 - 0)) or ((5696 - 2977) <= (3410 - (556 + 1407)))) then
							if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((5340 - (741 + 465)) < (4391 - (170 + 295)))) then
								return "judgment standard 12";
							end
							if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((87 + 77) >= (2559 + 226))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v136 = 4 - 2;
			end
			if ((v136 == (3 + 0)) or ((337 + 188) == (1195 + 914))) then
				if (((1263 - (957 + 273)) == (9 + 24)) and v98.HammerofWrath:IsReady() and v39) then
					if (((1223 + 1831) <= (15298 - 11283)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((4930 - 3059) < (10329 - 6947)) and v98.Judgment:IsReady() and v40) then
					local v211 = 0 - 0;
					while true do
						if (((3073 - (389 + 1391)) <= (1359 + 807)) and (v211 == (0 + 0))) then
							if (v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment)) or ((5871 - 3292) < (1074 - (783 + 168)))) then
								return "judgment standard 22";
							end
							if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((2839 - 1993) >= (2330 + 38))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v15:BuffDown(v98.ConsecrationBuff) and ((v15:BuffStack(v98.SanctificationBuff) < (316 - (309 + 2))) or not v15:HasTier(95 - 64, 1214 - (1090 + 122)))) or ((1301 + 2711) <= (11277 - 7919))) then
					if (((1023 + 471) <= (4123 - (628 + 490))) and v25(v98.Consecration, not v17:IsInRange(2 + 6))) then
						return "consecration standard 24";
					end
				end
				v136 = 9 - 5;
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (776 - (431 + 343))) or ((6282 - 3171) == (6173 - 4039))) then
				v42 = EpicSettings.Settings['useBastionofLight'];
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v137 = 3 + 0;
			end
			if (((302 + 2053) == (4050 - (556 + 1139))) and (v137 == (19 - (6 + 9)))) then
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v137 == (1 + 2)) or ((302 + 286) <= (601 - (28 + 141)))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v137 = 2 + 2;
			end
			if (((5920 - 1123) >= (2759 + 1136)) and (v137 == (1318 - (486 + 831)))) then
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v137 = 5 - 3;
			end
			if (((12593 - 9016) == (676 + 2901)) and (v137 == (0 - 0))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v137 = 1264 - (668 + 595);
			end
		end
	end
	local function v125()
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
		v63 = EpicSettings.Settings['useWordofGloryMouseover'];
		v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v66 = EpicSettings.Settings['ardentDefenderHP'];
		v67 = EpicSettings.Settings['divineShieldHP'];
		v68 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v69 = EpicSettings.Settings['layonHandsHP'];
		v70 = EpicSettings.Settings['wordofGloryHP'];
		v71 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v72 = EpicSettings.Settings['layOnHandsFocusHP'];
		v73 = EpicSettings.Settings['wordofGloryFocusHP'];
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v126()
		local v164 = 0 + 0;
		while true do
			if (((765 + 3029) > (10071 - 6378)) and ((292 - (23 + 267)) == v164)) then
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v164 = 1947 - (1129 + 815);
			end
			if (((391 - (371 + 16)) == v164) or ((3025 - (1326 + 424)) == (7765 - 3665))) then
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if ((v164 == (118 - (88 + 30))) or ((2362 - (720 + 51)) >= (7963 - 4383))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (1776 - (421 + 1355));
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v164 = 1 - 0;
			end
			if (((483 + 500) <= (2891 - (286 + 797))) and (v164 == (3 - 2))) then
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v164 = 2 - 0;
			end
			if ((v164 == (442 - (397 + 42))) or ((672 + 1478) <= (1997 - (24 + 776)))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (785 - (222 + 563));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v81 = EpicSettings.Settings['handleAfflicted'];
				v164 = 8 - 4;
			end
		end
	end
	local function v127()
		local v165 = 0 + 0;
		while true do
			if (((3959 - (23 + 167)) >= (2971 - (690 + 1108))) and (v165 == (2 + 3))) then
				if (((1225 + 260) == (2333 - (40 + 808))) and v108.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
					if ((v86 < v110) or ((546 + 2769) <= (10638 - 7856))) then
						local v223 = 0 + 0;
						while true do
							if ((v223 == (1 + 0)) or ((481 + 395) >= (3535 - (47 + 524)))) then
								if ((v32 and v99.FyralathTheDreamrender:IsEquippedAndReady()) or ((1449 + 783) > (6825 - 4328))) then
									if (v25(v100.UseWeapon) or ((3155 - 1045) <= (756 - 424))) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
							if (((5412 - (1165 + 561)) > (95 + 3077)) and (v223 == (0 - 0))) then
								v29 = v122();
								if (v29 or ((1708 + 2766) < (1299 - (341 + 138)))) then
									return v29;
								end
								v223 = 1 + 0;
							end
						end
					end
					if (((8830 - 4551) >= (3208 - (89 + 237))) and v87 and ((v32 and v88) or not v88) and v17:IsInRange(25 - 17)) then
						v29 = v118();
						if (v29 or ((4271 - 2242) >= (4402 - (581 + 300)))) then
							return v29;
						end
					end
					v29 = v123();
					if (v29 or ((3257 - (855 + 365)) >= (11025 - 6383))) then
						return v29;
					end
					if (((562 + 1158) < (5693 - (1030 + 205))) and v25(v98.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v165 == (2 + 0)) or ((406 + 30) > (3307 - (156 + 130)))) then
				v103 = v15:IsTankingAoE(17 - 9) or v15:IsTanking(v17);
				if (((1201 - 488) <= (1734 - 887)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if (((568 + 1586) <= (2351 + 1680)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
						if (((4684 - (10 + 59)) == (1306 + 3309)) and v25(v98.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((18664 - 14874) == (1663 - (671 + 492)))) then
					if (((71 + 18) < (1436 - (369 + 846))) and v15:AffectingCombat()) then
						if (((544 + 1510) >= (1213 + 208)) and v98.Intercession:IsCastable()) then
							if (((2637 - (1036 + 909)) < (2432 + 626)) and v25(v98.Intercession, not v17:IsInRange(50 - 20), true)) then
								return "intercession target";
							end
						end
					elseif (v98.Redemption:IsCastable() or ((3457 - (11 + 192)) == (837 + 818))) then
						if (v25(v98.Redemption, not v17:IsInRange(205 - (135 + 40)), true) or ((3139 - 1843) == (2960 + 1950))) then
							return "redemption target";
						end
					end
				end
				if (((7419 - 4051) == (5048 - 1680)) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((2819 - (50 + 126)) < (10622 - 6807)) and v25(v100.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((424 + 1489) > (1906 - (1233 + 180))) and v15:AffectingCombat()) then
					if (((5724 - (522 + 447)) > (4849 - (107 + 1314))) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (2 + 1)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (((4207 - 2826) <= (1007 + 1362)) and v25(v100.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (v15:AffectingCombat() or (v80 and v98.CleanseToxins:IsAvailable()) or ((9617 - 4774) == (16158 - 12074))) then
					local v212 = 1910 - (716 + 1194);
					local v213;
					while true do
						if (((80 + 4589) > (39 + 324)) and (v212 == (504 - (74 + 429)))) then
							if (v29 or ((3620 - 1743) >= (1556 + 1582))) then
								return v29;
							end
							break;
						end
						if (((10854 - 6112) >= (2566 + 1060)) and ((0 - 0) == v212)) then
							v213 = v80 and v98.CleanseToxins:IsReady() and v33;
							v29 = v108.FocusUnit(v213, v100, 49 - 29, nil, 458 - (279 + 154));
							v212 = 779 - (454 + 324);
						end
					end
				end
				v165 = 3 + 0;
			end
			if (((20 - (12 + 5)) == v165) or ((2448 + 2092) == (2333 - 1417))) then
				if ((v33 and v80) or ((428 + 728) > (5438 - (277 + 816)))) then
					local v214 = 0 - 0;
					while true do
						if (((3420 - (1058 + 125)) < (797 + 3452)) and (v214 == (975 - (815 + 160)))) then
							v29 = v108.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 171 - 131, 59 - 34);
							if (v29 or ((641 + 2042) < (67 - 44))) then
								return v29;
							end
							v214 = 1899 - (41 + 1857);
						end
						if (((2590 - (1222 + 671)) <= (2134 - 1308)) and (v214 == (1 - 0))) then
							if (((2287 - (229 + 953)) <= (2950 - (1111 + 663))) and v98.BlessingofFreedom:IsReady() and v108.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (((4958 - (874 + 705)) <= (534 + 3278)) and v25(v100.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				if (v108.TargetIsValid() or v15:AffectingCombat() or ((538 + 250) >= (3358 - 1742))) then
					local v215 = 0 + 0;
					while true do
						if (((2533 - (642 + 37)) <= (771 + 2608)) and (v215 == (0 + 0))) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v215 = 2 - 1;
						end
						if (((5003 - (233 + 221)) == (10518 - 5969)) and (v215 == (1 + 0))) then
							if ((v110 == (12652 - (718 + 823))) or ((1902 + 1120) >= (3829 - (266 + 539)))) then
								v110 = v10.FightRemains(v104, false);
							end
							v111 = v15:HolyPower();
							break;
						end
					end
				end
				if (((13646 - 8826) > (3423 - (636 + 589))) and not v15:AffectingCombat()) then
					if ((v98.DevotionAura:IsCastable() and (v114())) or ((2518 - 1457) >= (10087 - 5196))) then
						if (((1081 + 283) <= (1626 + 2847)) and v25(v98.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (v81 or ((4610 - (657 + 358)) <= (7 - 4))) then
					local v216 = 0 - 0;
					while true do
						if ((v216 == (1187 - (1151 + 36))) or ((4512 + 160) == (1013 + 2839))) then
							if (((4655 - 3096) == (3391 - (1552 + 280))) and v77) then
								v29 = v108.HandleAfflicted(v98.CleanseToxins, v100.CleanseToxinsMouseover, 874 - (64 + 770));
								if (v29 or ((1190 + 562) <= (1788 - 1000))) then
									return v29;
								end
							end
							if ((v15:BuffUp(v98.ShiningLightFreeBuff) and v78) or ((694 + 3213) == (1420 - (157 + 1086)))) then
								local v224 = 0 - 0;
								while true do
									if (((15197 - 11727) > (850 - 295)) and ((0 - 0) == v224)) then
										v29 = v108.HandleAfflicted(v98.WordofGlory, v100.WordofGloryMouseover, 859 - (599 + 220), true);
										if (v29 or ((1935 - 963) == (2576 - (1813 + 118)))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((2326 + 856) >= (3332 - (841 + 376))) and v82) then
					local v217 = 0 - 0;
					while true do
						if (((905 + 2988) < (12088 - 7659)) and (v217 == (859 - (464 + 395)))) then
							v29 = v108.HandleIncorporeal(v98.Repentance, v100.RepentanceMouseOver, 76 - 46, true);
							if (v29 or ((1377 + 1490) < (2742 - (467 + 370)))) then
								return v29;
							end
							v217 = 1 - 0;
						end
						if ((v217 == (1 + 0)) or ((6156 - 4360) >= (633 + 3418))) then
							v29 = v108.HandleIncorporeal(v98.TurnEvil, v100.TurnEvilMouseOver, 69 - 39, true);
							if (((2139 - (150 + 370)) <= (5038 - (74 + 1208))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v117();
				v165 = 9 - 5;
			end
			if (((2864 - 2260) == (430 + 174)) and (v165 == (390 - (14 + 376)))) then
				v125();
				v124();
				v126();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v165 = 1 - 0;
			end
			if ((v165 == (1 + 0)) or ((3939 + 545) == (859 + 41))) then
				v33 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((13065 - 8606) <= (838 + 275))) then
					return v29;
				end
				v104 = v15:GetEnemiesInMeleeRange(86 - (23 + 55));
				v105 = v15:GetEnemiesInRange(71 - 41);
				if (((2424 + 1208) > (3052 + 346)) and v31) then
					local v218 = 0 - 0;
					while true do
						if (((1285 + 2797) <= (5818 - (652 + 249))) and ((0 - 0) == v218)) then
							v106 = #v104;
							v107 = #v105;
							break;
						end
					end
				else
					local v219 = 1868 - (708 + 1160);
					while true do
						if (((13116 - 8284) >= (2526 - 1140)) and (v219 == (27 - (10 + 17)))) then
							v106 = 1 + 0;
							v107 = 1733 - (1400 + 332);
							break;
						end
					end
				end
				v102 = v15:ActiveMitigationNeeded();
				v165 = 3 - 1;
			end
			if (((2045 - (242 + 1666)) == (59 + 78)) and ((2 + 2) == v165)) then
				if (v29 or ((1339 + 231) >= (5272 - (850 + 90)))) then
					return v29;
				end
				if ((v80 and v33) or ((7117 - 3053) <= (3209 - (360 + 1030)))) then
					if (v14 or ((4413 + 573) < (4442 - 2868))) then
						v29 = v116();
						if (((6088 - 1662) > (1833 - (909 + 752))) and v29) then
							return v29;
						end
					end
					if (((1809 - (109 + 1114)) > (833 - 378)) and v16 and v16:Exists() and v16:IsAPlayer() and (v108.UnitHasCurseDebuff(v16) or v108.UnitHasPoisonDebuff(v16))) then
						if (((322 + 504) == (1068 - (6 + 236))) and v98.CleanseToxins:IsReady()) then
							if (v25(v100.CleanseToxinsMouseover) or ((2533 + 1486) > (3575 + 866))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v29 = v120();
				if (((4756 - 2739) < (7442 - 3181)) and v29) then
					return v29;
				end
				if (((5849 - (1076 + 57)) > (14 + 66)) and v103) then
					local v220 = 689 - (579 + 110);
					while true do
						if ((v220 == (0 + 0)) or ((3101 + 406) == (1737 + 1535))) then
							v29 = v119();
							if (v29 or ((1283 - (174 + 233)) >= (8589 - 5514))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((7638 - 3286) > (1136 + 1418)) and v108.TargetIsValid() and not v15:AffectingCombat() and v30) then
					local v221 = 1174 - (663 + 511);
					while true do
						if ((v221 == (0 + 0)) or ((957 + 3449) < (12464 - 8421))) then
							v29 = v121();
							if (v29 or ((1144 + 745) >= (7964 - 4581))) then
								return v29;
							end
							break;
						end
					end
				end
				v165 = 12 - 7;
			end
		end
	end
	local function v128()
		local v166 = 0 + 0;
		while true do
			if (((3682 - 1790) <= (1949 + 785)) and (v166 == (0 + 0))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v112();
				break;
			end
		end
	end
	v21.SetAPL(788 - (478 + 244), v127, v128);
end;
return v0["Epix_Paladin_Protection.lua"]();

