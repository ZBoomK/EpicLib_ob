local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3569 + 973) == (12575 - 8033)) and not v5) then
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
	local v110 = 11436 - (45 + 280);
	local v111 = 10725 + 386;
	local v112 = 0 + 0;
	v9:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 + 0)) or ((470 + 2200) < (3219 - 1480))) then
				v110 = 13022 - (340 + 1571);
				v111 = 4383 + 6728;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((2104 - (1733 + 39)) >= (10999 - 6996))) then
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
	local v116 = 1034 - (125 + 909);
	local function v117()
		if ((v99.CleanseToxins:IsReady() and v109.UnitHasDispellableDebuffByPlayer(v13)) or ((5239 - (1096 + 852)) <= (1472 + 1808))) then
			if (((6262 - 1876) >= (847 + 26)) and (v116 == (512 - (409 + 103)))) then
				v116 = GetTime();
			end
			if (((1157 - (46 + 190)) <= (1197 - (51 + 44))) and v109.Wait(142 + 358, v116)) then
				local v212 = 1317 - (1114 + 203);
				while true do
					if (((5432 - (228 + 498)) >= (209 + 754)) and (v212 == (0 + 0))) then
						if (v24(v101.CleanseToxinsFocus) or ((1623 - (174 + 489)) <= (2282 - 1406))) then
							return "cleanse_toxins dispel";
						end
						v116 = 1905 - (830 + 1075);
						break;
					end
				end
			end
		end
	end
	local function v118()
		if ((v97 and (v14:HealthPercentage() <= v98)) or ((2590 - (303 + 221)) == (2201 - (231 + 1038)))) then
			if (((4021 + 804) < (6005 - (171 + 991))) and v99.FlashofLight:IsReady()) then
				if (v24(v99.FlashofLight) or ((15977 - 12100) >= (12182 - 7645))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (0 + 0)) or ((15125 - 10810) < (4979 - 3253))) then
				v28 = v109.HandleTopTrinket(v102, v31, 64 - 24, nil);
				if (v28 or ((11372 - 7693) < (1873 - (111 + 1137)))) then
					return v28;
				end
				v132 = 159 - (91 + 67);
			end
			if ((v132 == (2 - 1)) or ((1154 + 3471) < (1155 - (423 + 100)))) then
				v28 = v109.HandleBottomTrinket(v102, v31, 1 + 39, nil);
				if (v28 or ((229 - 146) > (928 + 852))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v120()
		local v133 = 771 - (326 + 445);
		while true do
			if (((2382 - 1836) <= (2399 - 1322)) and (v133 == (6 - 3))) then
				if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((1707 - (530 + 181)) > (5182 - (614 + 267)))) then
					if (((4102 - (19 + 13)) > (1118 - 431)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v92 and (v14:HealthPercentage() <= v94)) or ((1528 - 872) >= (9512 - 6182))) then
					if ((v96 == "Refreshing Healing Potion") or ((648 + 1844) <= (588 - 253))) then
						if (((8962 - 4640) >= (4374 - (1293 + 519))) and v100.RefreshingHealingPotion:IsReady()) then
							if (v24(v101.RefreshingHealingPotion) or ((7420 - 3783) >= (9843 - 6073))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((4548 - 2169) > (19740 - 15162))) then
						if (v100.DreamwalkersHealingPotion:IsReady() or ((1137 - 654) > (394 + 349))) then
							if (((501 + 1953) > (1342 - 764)) and v24(v101.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((215 + 715) < (1481 + 2977)) and (v133 == (0 + 0))) then
				if (((1758 - (709 + 387)) <= (2830 - (673 + 1185))) and (v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
					if (((12673 - 8303) == (14032 - 9662)) and v24(v99.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((7834 - 3072) <= (616 + 245))) then
					if (v24(v101.LayonHandsPlayer) or ((1056 + 356) == (5756 - 1492))) then
						return "lay_on_hands defensive 2";
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (3 - 1)) or ((6218 - 3050) < (4033 - (446 + 1434)))) then
				if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((6259 - (1040 + 243)) < (3975 - 2643))) then
					if (((6475 - (559 + 1288)) == (6559 - (609 + 1322))) and ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (459 - (13 + 441))) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff))) then
						if (v24(v101.WordofGloryPlayer) or ((201 - 147) == (1034 - 639))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((408 - 326) == (4 + 78)) and v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (7 - 5)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) then
					if (v24(v99.ShieldoftheRighteous) or ((207 + 374) < (124 + 158))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v133 = 8 - 5;
			end
			if ((v133 == (1 + 0)) or ((8476 - 3867) < (1650 + 845))) then
				if (((641 + 511) == (828 + 324)) and v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) then
					if (((1592 + 304) <= (3349 + 73)) and v24(v99.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) or ((1423 - (153 + 280)) > (4677 - 3057))) then
					if (v24(v99.ArdentDefender) or ((788 + 89) > (1854 + 2841))) then
						return "ardent_defender defensive 6";
					end
				end
				v133 = 2 + 0;
			end
		end
	end
	local function v121()
		local v134 = 0 + 0;
		while true do
			if (((1950 + 741) >= (2818 - 967)) and (v134 == (0 + 0))) then
				if (v15:Exists() or ((3652 - (89 + 578)) >= (3469 + 1387))) then
					if (((8889 - 4613) >= (2244 - (572 + 477))) and v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) then
						if (((436 + 2796) <= (2815 + 1875)) and v24(v101.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(4 + 26) or ((982 - (84 + 2)) >= (5184 - 2038))) then
					return;
				end
				v134 = 1 + 0;
			end
			if (((3903 - (497 + 345)) >= (76 + 2882)) and (v134 == (1 + 0))) then
				if (((4520 - (605 + 728)) >= (460 + 184)) and v13) then
					local v213 = 0 - 0;
					while true do
						if (((30 + 614) <= (2602 - 1898)) and (v213 == (0 + 0))) then
							if (((2654 - 1696) > (716 + 231)) and v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (492 - (457 + 32)))) and (v13:HealthPercentage() <= v74)) then
								if (((1906 + 2586) >= (4056 - (832 + 570))) and v24(v101.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if (((3243 + 199) >= (392 + 1111)) and v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73)) then
								if (v24(v101.LayonHandsFocus) or ((11218 - 8048) <= (706 + 758))) then
									return "lay_on_hands defensive focus";
								end
							end
							v213 = 797 - (588 + 208);
						end
						if ((v213 == (2 - 1)) or ((6597 - (884 + 916)) == (9186 - 4798))) then
							if (((320 + 231) <= (1334 - (232 + 421))) and v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) then
								if (((5166 - (1569 + 320)) > (100 + 307)) and v24(v101.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((892 + 3803) >= (4768 - 3353)) and v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) then
								if (v24(v101.BlessingofProtectionFocus) or ((3817 - (316 + 289)) <= (2470 - 1526))) then
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
		local v135 = 0 + 0;
		while true do
			if ((v135 == (1455 - (666 + 787))) or ((3521 - (360 + 65)) <= (1681 + 117))) then
				if (((3791 - (79 + 175)) == (5576 - 2039)) and v99.Judgment:IsReady() and v41) then
					if (((2995 + 842) >= (4812 - 3242)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((3849 - (503 + 396)) == (3993 - (92 + 89)))) then
				if (((9161 - 4438) >= (1189 + 1129)) and (v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) then
					if (v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment)) or ((1200 + 827) > (11168 - 8316))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (1 + 4))) or ((2590 - 1454) > (3767 + 550))) then
					if (((2268 + 2480) == (14460 - 9712)) and v24(v99.ArcaneTorrent, not v16:IsInRange(1 + 7))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 1 - 0;
			end
			if (((4980 - (485 + 759)) <= (10967 - 6227)) and ((1190 - (442 + 747)) == v135)) then
				if ((v99.Consecration:IsCastable() and v37) or ((4525 - (832 + 303)) <= (4006 - (88 + 858)))) then
					if (v24(v99.Consecration, not v16:IsInRange(3 + 5)) or ((827 + 172) > (111 + 2582))) then
						return "consecration";
					end
				end
				if (((1252 - (766 + 23)) < (2966 - 2365)) and v99.AvengersShield:IsCastable() and v35) then
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((2984 - 801) < (1809 - 1122))) then
						return "avengers_shield precombat 10";
					end
				end
				v135 = 6 - 4;
			end
		end
	end
	local function v123()
		local v136 = 1073 - (1036 + 37);
		local v137;
		while true do
			if (((3226 + 1323) == (8858 - 4309)) and (v136 == (0 + 0))) then
				if (((6152 - (641 + 839)) == (5585 - (910 + 3))) and v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (4 - 2)) and v14:HasTier(1713 - (1466 + 218), 1 + 1)) then
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((4816 - (556 + 592)) < (141 + 254))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (810 - (329 + 479)))) or ((5020 - (174 + 680)) == (1563 - 1108))) then
					if (v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment)) or ((9221 - 4772) == (1902 + 761))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v136 = 740 - (396 + 343);
			end
			if ((v136 == (1 + 3)) or ((5754 - (29 + 1448)) < (4378 - (135 + 1254)))) then
				if ((v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (113 - 83)))) or ((4062 - 3192) >= (2766 + 1383))) then
					if (((3739 - (389 + 1138)) < (3757 - (102 + 472))) and v24(v99.BastionofLight, not v16:IsInRange(8 + 0))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if (((2577 + 2069) > (2790 + 202)) and (v136 == (1546 - (320 + 1225)))) then
				if (((2552 - 1118) < (1901 + 1205)) and v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) then
					if (((2250 - (157 + 1307)) < (4882 - (821 + 1038))) and v24(v99.AvengingWrath, not v16:IsInRange(19 - 11))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) or ((268 + 2174) < (131 - 57))) then
					if (((1688 + 2847) == (11240 - 6705)) and v24(v99.Sentinel, not v16:IsInRange(1034 - (834 + 192)))) then
						return "sentinel cooldowns 8";
					end
				end
				v136 = 1 + 1;
			end
			if ((v136 == (1 + 2)) or ((65 + 2944) <= (3261 - 1156))) then
				if (((2134 - (300 + 4)) < (980 + 2689)) and v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (39 - 24)) or (((v9.CombatTime() > (372 - (112 + 250))) or (v99.Sentinel:CooldownRemains() > (6 + 9)) or (v99.AvengingWrath:CooldownRemains() > (37 - 22))) and (v99.AvengersShield:CooldownRemains() > (0 + 0)) and (v99.Judgment:CooldownRemains() > (0 + 0)) and (v99.HammerofWrath:CooldownRemains() > (0 + 0))))) then
					if (v24(v99.MomentOfGlory, not v16:IsInRange(4 + 4)) or ((1063 + 367) >= (5026 - (1001 + 413)))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((5982 - 3299) >= (3342 - (244 + 638))) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (696 - (627 + 66)))) then
					if (v24(v99.DivineToll, not v16:IsInRange(89 - 59)) or ((2406 - (512 + 90)) >= (5181 - (1665 + 241)))) then
						return "divine_toll cooldowns 12";
					end
				end
				v136 = 721 - (373 + 344);
			end
			if ((v136 == (1 + 1)) or ((375 + 1042) > (9572 - 5943))) then
				v137 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
				if (((8114 - 3319) > (1501 - (35 + 1064))) and v137) then
					return v137;
				end
				v136 = 3 + 0;
			end
		end
	end
	local function v124()
		if (((10297 - 5484) > (15 + 3550)) and v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (1241 - (298 + 938)))) then
			if (((5171 - (233 + 1026)) == (5578 - (636 + 1030))) and v24(v99.Consecration, not v16:IsInRange(5 + 3))) then
				return "consecration standard 2";
			end
		end
		if (((2756 + 65) <= (1434 + 3390)) and v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (1 + 1)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (226 - (55 + 166))))) then
			if (((337 + 1401) <= (221 + 1974)) and v24(v99.ShieldoftheRighteous)) then
				return "shield_of_the_righteous standard 4";
			end
		end
		if (((156 - 115) <= (3315 - (36 + 261))) and v99.Judgment:IsReady() and v41 and (v107 > (4 - 1)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (1371 - (34 + 1334))) and (v14:HolyPower() < (2 + 1))) then
			local v164 = 0 + 0;
			while true do
				if (((3428 - (1035 + 248)) <= (4125 - (20 + 1))) and ((0 + 0) == v164)) then
					if (((3008 - (134 + 185)) < (5978 - (549 + 584))) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 6";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((3007 - (314 + 371)) > (9001 - 6379))) then
						return "judgment standard 6";
					end
					break;
				end
			end
		end
		if ((v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(999 - (478 + 490), 2 + 0)) or ((5706 - (786 + 386)) == (6743 - 4661))) then
			local v165 = 1379 - (1055 + 324);
			while true do
				if (((1340 - (1093 + 247)) == v165) or ((1397 + 174) > (197 + 1670))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((10536 - 7882) >= (10167 - 7171))) then
						return "judgment standard 8";
					end
					if (((11319 - 7341) > (5286 - 3182)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 8";
					end
					break;
				end
			end
		end
		if (((1066 + 1929) > (5936 - 4395)) and v99.HammerofWrath:IsReady() and v40) then
			if (((11198 - 7949) > (719 + 234)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
				return "hammer_of_wrath standard 10";
			end
		end
		if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (4 - 2)) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((3961 - (364 + 324)) > (12535 - 7962))) then
			local v166 = 0 - 0;
			while true do
				if ((v166 == (0 + 0)) or ((13184 - 10033) < (2055 - 771))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((5618 - 3768) == (2797 - (1249 + 19)))) then
						return "judgment standard 12";
					end
					if (((742 + 79) < (8263 - 6140)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 12";
					end
					break;
				end
			end
		end
		if (((1988 - (686 + 400)) < (1825 + 500)) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (231 - (73 + 156))) or v14:BuffUp(v99.MomentOfGloryBuff))) then
			if (((5 + 853) <= (3773 - (721 + 90))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
				return "avengers_shield standard 14";
			end
		end
		if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) or ((45 + 3901) < (4181 - 2893))) then
			if (v24(v99.DivineToll, not v16:IsInRange(500 - (224 + 246))) or ((5251 - 2009) == (1043 - 476))) then
				return "divine_toll standard 16";
			end
		end
		if ((v99.AvengersShield:IsCastable() and v35) or ((154 + 693) >= (31 + 1232))) then
			if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((1655 + 598) == (3679 - 1828))) then
				return "avengers_shield standard 18";
			end
		end
		if ((v99.HammerofWrath:IsReady() and v40) or ((6944 - 4857) > (2885 - (203 + 310)))) then
			if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((6438 - (1238 + 755)) < (290 + 3859))) then
				return "hammer_of_wrath standard 20";
			end
		end
		if ((v99.Judgment:IsReady() and v41) or ((3352 - (709 + 825)) == (156 - 71))) then
			local v167 = 0 - 0;
			while true do
				if (((1494 - (196 + 668)) < (8397 - 6270)) and (v167 == (0 - 0))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((2771 - (171 + 662)) == (2607 - (4 + 89)))) then
						return "judgment standard 22";
					end
					if (((14913 - 10658) >= (21 + 34)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 22";
					end
					break;
				end
			end
		end
		if (((13172 - 10173) > (454 + 702)) and v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (1491 - (35 + 1451))) or not v14:HasTier(1484 - (28 + 1425), 1995 - (941 + 1052)))) then
			if (((2254 + 96) > (2669 - (822 + 692))) and v24(v99.Consecration, not v16:IsInRange(11 - 3))) then
				return "consecration standard 24";
			end
		end
		if (((1898 + 2131) <= (5150 - (45 + 252))) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (3 + 0))) then
			if (v24(v99.EyeofTyr, not v16:IsInRange(3 + 5)) or ((1255 - 739) > (3867 - (114 + 319)))) then
				return "eye_of_tyr standard 26";
			end
		end
		if (((5808 - 1762) >= (3885 - 852)) and v99.BlessedHammer:IsCastable() and v36) then
			if (v24(v99.BlessedHammer, not v16:IsInRange(6 + 2)) or ((4050 - 1331) <= (3031 - 1584))) then
				return "blessed_hammer standard 28";
			end
		end
		if ((v99.HammeroftheRighteous:IsCastable() and v39) or ((6097 - (556 + 1407)) < (5132 - (741 + 465)))) then
			if (v24(v99.HammeroftheRighteous, not v16:IsInRange(473 - (170 + 295))) or ((87 + 77) >= (2559 + 226))) then
				return "hammer_of_the_righteous standard 30";
			end
		end
		if ((v99.CrusaderStrike:IsCastable() and v38) or ((1292 - 767) == (1749 + 360))) then
			if (((22 + 11) == (19 + 14)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
				return "crusader_strike standard 32";
			end
		end
		if (((4284 - (957 + 273)) <= (1074 + 2941)) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) then
			if (((749 + 1122) < (12886 - 9504)) and v24(v99.EyeofTyr, not v16:IsInRange(21 - 13))) then
				return "eye_of_tyr standard 34";
			end
		end
		if (((3949 - 2656) <= (10725 - 8559)) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (1785 - (389 + 1391)))) then
			if (v24(v99.ArcaneTorrent, not v16:IsInRange(6 + 2)) or ((269 + 2310) < (279 - 156))) then
				return "arcane_torrent standard 36";
			end
		end
		if ((v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) or ((1797 - (783 + 168)) >= (7947 - 5579))) then
			if (v24(v99.Consecration, not v16:IsInRange(8 + 0)) or ((4323 - (309 + 2)) <= (10312 - 6954))) then
				return "consecration standard 38";
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
		local v159 = 1212 - (1090 + 122);
		while true do
			if (((485 + 1009) <= (10092 - 7087)) and (v159 == (2 + 0))) then
				v60 = EpicSettings.Settings['useWordofGloryPlayer'];
				v61 = EpicSettings.Settings['useShieldoftheRighteous'];
				v62 = EpicSettings.Settings['useLayOnHandsFocus'];
				v159 = 1121 - (628 + 490);
			end
			if ((v159 == (2 + 4)) or ((7702 - 4591) == (9752 - 7618))) then
				v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v73 = EpicSettings.Settings['layOnHandsFocusHP'];
				v74 = EpicSettings.Settings['wordofGloryFocusHP'];
				v159 = 781 - (431 + 343);
			end
			if (((4756 - 2401) == (6812 - 4457)) and (v159 == (0 + 0))) then
				v54 = EpicSettings.Settings['useRebuke'];
				v55 = EpicSettings.Settings['useHammerofJustice'];
				v56 = EpicSettings.Settings['useArdentDefender'];
				v159 = 1 + 0;
			end
			if ((v159 == (1699 - (556 + 1139))) or ((603 - (6 + 9)) <= (80 + 352))) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['ardentDefenderHP'];
				v68 = EpicSettings.Settings['divineShieldHP'];
				v159 = 3 + 2;
			end
			if (((4966 - (28 + 141)) >= (1509 + 2386)) and ((3 - 0) == v159)) then
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v159 = 3 + 1;
			end
			if (((4894 - (486 + 831)) == (9308 - 5731)) and ((17 - 12) == v159)) then
				v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v70 = EpicSettings.Settings['layonHandsHP'];
				v71 = EpicSettings.Settings['wordofGloryHP'];
				v159 = 2 + 4;
			end
			if (((11996 - 8202) > (4956 - (668 + 595))) and (v159 == (1 + 0))) then
				v57 = EpicSettings.Settings['useDivineShield'];
				v58 = EpicSettings.Settings['useGuardianofAncientKings'];
				v59 = EpicSettings.Settings['useLayOnHands'];
				v159 = 1 + 1;
			end
			if ((v159 == (21 - 13)) or ((1565 - (23 + 267)) == (6044 - (1129 + 815)))) then
				v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v159 == (394 - (371 + 16))) or ((3341 - (1326 + 424)) >= (6780 - 3200))) then
				v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v159 = 29 - 21;
			end
		end
	end
	local function v127()
		local v160 = 118 - (88 + 30);
		while true do
			if (((1754 - (720 + 51)) <= (4021 - 2213)) and ((1778 - (421 + 1355)) == v160)) then
				v89 = EpicSettings.Settings['trinketsWithCD'];
				v91 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v160 = 4 - 1;
			end
			if ((v160 == (2 + 2)) or ((3233 - (286 + 797)) <= (4375 - 3178))) then
				v83 = EpicSettings.Settings['HandleIncorporeal'];
				v97 = EpicSettings.Settings['HealOOC'];
				v98 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((4208 - (397 + 42)) >= (367 + 806)) and (v160 == (803 - (24 + 776)))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (785 - (222 + 563));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v82 = EpicSettings.Settings['handleAfflicted'];
				v160 = 8 - 4;
			end
			if (((1070 + 415) == (1675 - (23 + 167))) and (v160 == (1798 - (690 + 1108)))) then
				v87 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v84 = EpicSettings.Settings['InterruptWithStun'];
				v85 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v86 = EpicSettings.Settings['InterruptThreshold'];
				v160 = 1 + 0;
			end
			if ((v160 == (849 - (40 + 808))) or ((546 + 2769) <= (10638 - 7856))) then
				v81 = EpicSettings.Settings['DispelDebuffs'];
				v80 = EpicSettings.Settings['DispelBuffs'];
				v88 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v160 = 2 + 0;
			end
		end
	end
	local function v128()
		local v161 = 0 + 0;
		while true do
			if ((v161 == (3 + 2)) or ((1447 - (47 + 524)) >= (1924 + 1040))) then
				if (not v14:AffectingCombat() or ((6101 - 3869) > (3733 - 1236))) then
					if ((v99.DevotionAura:IsCastable() and (v115()) and v33) or ((4812 - 2702) <= (2058 - (1165 + 561)))) then
						if (((110 + 3576) > (9824 - 6652)) and v24(v99.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (v82 or ((1708 + 2766) < (1299 - (341 + 138)))) then
					if (((1156 + 3123) >= (5947 - 3065)) and v78) then
						local v222 = 326 - (89 + 237);
						while true do
							if (((0 - 0) == v222) or ((4271 - 2242) >= (4402 - (581 + 300)))) then
								v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 1260 - (855 + 365));
								if (v28 or ((4838 - 2801) >= (1516 + 3126))) then
									return v28;
								end
								break;
							end
						end
					end
					if (((2955 - (1030 + 205)) < (4186 + 272)) and v14:BuffUp(v99.ShiningLightFreeBuff) and v79) then
						local v223 = 0 + 0;
						while true do
							if (((286 - (156 + 130)) == v223) or ((990 - 554) > (5091 - 2070))) then
								v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 81 - 41, true);
								if (((188 + 525) <= (494 + 353)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (((2223 - (10 + 59)) <= (1141 + 2890)) and v83) then
					v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 147 - 117, true);
					if (((5778 - (671 + 492)) == (3674 + 941)) and v28) then
						return v28;
					end
					v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 1245 - (369 + 846), true);
					if (v28 or ((1004 + 2786) == (427 + 73))) then
						return v28;
					end
				end
				v28 = v118();
				v161 = 1951 - (1036 + 909);
			end
			if (((71 + 18) < (370 - 149)) and (v161 == (203 - (11 + 192)))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v161 = 1 + 0;
			end
			if (((2229 - (135 + 40)) >= (3442 - 2021)) and (v161 == (3 + 1))) then
				if (((1524 - 832) < (4584 - 1526)) and v14:AffectingCombat()) then
					if ((v99.Intercession:IsCastable() and (v14:HolyPower() >= (179 - (50 + 126))) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((9060 - 5806) == (367 + 1288))) then
						if (v24(v101.IntercessionMouseover) or ((2709 - (1233 + 180)) == (5879 - (522 + 447)))) then
							return "Intercession";
						end
					end
				end
				if (((4789 - (107 + 1314)) == (1563 + 1805)) and (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()))) then
					local v214 = 0 - 0;
					local v215;
					while true do
						if (((1123 + 1520) < (7575 - 3760)) and (v214 == (0 - 0))) then
							v215 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v215, nil, 1930 - (716 + 1194), nil, 1 + 24, v99.FlashofLight);
							v214 = 1 + 0;
						end
						if (((2416 - (74 + 429)) > (950 - 457)) and (v214 == (1 + 0))) then
							if (((10884 - 6129) > (2426 + 1002)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((4257 - 2876) <= (5857 - 3488)) and v32 and v81) then
					local v216 = 433 - (279 + 154);
					while true do
						if (((778 - (454 + 324)) == v216) or ((3811 + 1032) == (4101 - (12 + 5)))) then
							v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 22 + 18, 63 - 38, v99.FlashofLight);
							if (((1726 + 2943) > (1456 - (277 + 816))) and v28) then
								return v28;
							end
							v216 = 4 - 3;
						end
						if ((v216 == (1184 - (1058 + 125))) or ((352 + 1525) >= (4113 - (815 + 160)))) then
							if (((20346 - 15604) >= (8607 - 4981)) and v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
								if (v24(v101.BlessingofFreedomFocus) or ((1084 + 3456) == (2677 - 1761))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				if (v109.TargetIsValid() or v14:AffectingCombat() or ((3054 - (41 + 1857)) > (6238 - (1222 + 671)))) then
					local v217 = 0 - 0;
					while true do
						if (((3215 - 978) < (5431 - (229 + 953))) and (v217 == (1775 - (1111 + 663)))) then
							if ((v111 == (12690 - (874 + 705))) or ((376 + 2307) < (16 + 7))) then
								v111 = v9.FightRemains(v105, false);
							end
							v112 = v14:HolyPower();
							break;
						end
						if (((1448 - 751) <= (24 + 802)) and ((679 - (642 + 37)) == v217)) then
							v110 = v9.BossFightRemains(nil, true);
							v111 = v110;
							v217 = 1 + 0;
						end
					end
				end
				v161 = 1 + 4;
			end
			if (((2774 - 1669) <= (1630 - (233 + 221))) and (v161 == (6 - 3))) then
				v104 = v14:IsTankingAoE(8 + 0) or v14:IsTanking(v16);
				if (((4920 - (718 + 823)) <= (2399 + 1413)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) or ((1593 - (266 + 539)) >= (4574 - 2958))) then
						if (((3079 - (636 + 589)) <= (8020 - 4641)) and v24(v99.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (((9382 - 4833) == (3605 + 944)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (v14:AffectingCombat() or ((1098 + 1924) >= (4039 - (657 + 358)))) then
						if (((12762 - 7942) > (5007 - 2809)) and v99.Intercession:IsCastable()) then
							if (v24(v99.Intercession, not v16:IsInRange(1217 - (1151 + 36)), true) or ((1025 + 36) >= (1286 + 3605))) then
								return "intercession target";
							end
						end
					elseif (((4073 - 2709) <= (6305 - (1552 + 280))) and v99.Redemption:IsCastable()) then
						if (v24(v99.Redemption, not v16:IsInRange(864 - (64 + 770)), true) or ((2441 + 1154) <= (6 - 3))) then
							return "redemption target";
						end
					end
				end
				if ((v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((830 + 3842) == (5095 - (157 + 1086)))) then
					if (((3120 - 1561) == (6827 - 5268)) and v24(v101.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				v161 = 5 - 1;
			end
			if ((v161 == (2 - 0)) or ((2571 - (599 + 220)) <= (1568 - 780))) then
				v105 = v14:GetEnemiesInMeleeRange(1939 - (1813 + 118));
				v106 = v14:GetEnemiesInRange(22 + 8);
				if (v30 or ((5124 - (841 + 376)) == (247 - 70))) then
					local v218 = 0 + 0;
					while true do
						if (((9471 - 6001) > (1414 - (464 + 395))) and (v218 == (0 - 0))) then
							v107 = #v105;
							v108 = #v106;
							break;
						end
					end
				else
					v107 = 1 + 0;
					v108 = 838 - (467 + 370);
				end
				v103 = v14:ActiveMitigationNeeded();
				v161 = 5 - 2;
			end
			if ((v161 == (1 + 0)) or ((3331 - 2359) == (101 + 544))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				if (((7402 - 4220) >= (2635 - (150 + 370))) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v161 = 1284 - (74 + 1208);
			end
			if (((9575 - 5682) < (21004 - 16575)) and (v161 == (5 + 1))) then
				if (v28 or ((3257 - (14 + 376)) < (3304 - 1399))) then
					return v28;
				end
				if ((v81 and v32) or ((1163 + 633) >= (3559 + 492))) then
					local v219 = 0 + 0;
					while true do
						if (((4743 - 3124) <= (2826 + 930)) and (v219 == (78 - (23 + 55)))) then
							if (((1431 - 827) == (404 + 200)) and v13) then
								v28 = v117();
								if (v28 or ((4027 + 457) == (1395 - 495))) then
									return v28;
								end
							end
							if ((v15 and v15:Exists() and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15))) or ((1403 + 3056) <= (2014 - (652 + 249)))) then
								if (((9719 - 6087) > (5266 - (708 + 1160))) and v99.CleanseToxins:IsReady()) then
									if (((11080 - 6998) <= (8964 - 4047)) and v24(v101.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v121();
				if (((4859 - (10 + 17)) >= (312 + 1074)) and v28) then
					return v28;
				end
				v161 = 1739 - (1400 + 332);
			end
			if (((262 - 125) == (2045 - (242 + 1666))) and (v161 == (3 + 4))) then
				if (v104 or ((576 + 994) >= (3692 + 640))) then
					v28 = v120();
					if (v28 or ((5004 - (850 + 90)) <= (3185 - 1366))) then
						return v28;
					end
				end
				if ((v109.TargetIsValid() and not v14:AffectingCombat() and v29) or ((6376 - (360 + 1030)) < (1393 + 181))) then
					local v220 = 0 - 0;
					while true do
						if (((6088 - 1662) > (1833 - (909 + 752))) and (v220 == (1223 - (109 + 1114)))) then
							v28 = v122();
							if (((1072 - 486) > (178 + 277)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((1068 - (6 + 236)) == (521 + 305)) and v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
					local v221 = 0 + 0;
					while true do
						if ((v221 == (0 - 0)) or ((7019 - 3000) > (5574 - (1076 + 57)))) then
							if (((332 + 1685) < (4950 - (579 + 110))) and (v87 < v111)) then
								local v224 = 0 + 0;
								while true do
									if (((4170 + 546) > (43 + 37)) and (v224 == (407 - (174 + 233)))) then
										v28 = v123();
										if (v28 or ((9795 - 6288) == (5742 - 2470))) then
											return v28;
										end
										v224 = 1 + 0;
									end
									if ((v224 == (1175 - (663 + 511))) or ((782 + 94) >= (668 + 2407))) then
										if (((13416 - 9064) > (1547 + 1007)) and v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) then
											if (v24(v101.UseWeapon) or ((10372 - 5966) < (9787 - 5744))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if ((v88 and ((v31 and v89) or not v89) and v16:IsInRange(4 + 4)) or ((3676 - 1787) >= (2411 + 972))) then
								v28 = v119();
								if (((173 + 1719) <= (3456 - (478 + 244))) and v28) then
									return v28;
								end
							end
							v221 = 518 - (440 + 77);
						end
						if (((875 + 1048) < (8117 - 5899)) and (v221 == (1558 - (655 + 901)))) then
							if (((403 + 1770) > (291 + 88)) and v24(v99.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((1 + 0) == v221) or ((10438 - 7847) == (4854 - (695 + 750)))) then
							v28 = v124();
							if (((15413 - 10899) > (5129 - 1805)) and v28) then
								return v28;
							end
							v221 = 7 - 5;
						end
					end
				end
				break;
			end
		end
	end
	local function v129()
		local v162 = 351 - (285 + 66);
		while true do
			if ((v162 == (0 - 0)) or ((1518 - (682 + 628)) >= (779 + 4049))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v113();
				break;
			end
		end
	end
	v20.SetAPL(365 - (176 + 123), v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

