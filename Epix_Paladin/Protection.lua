local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5919 - 2282) >= (8785 - 5015))) then
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
	local v110 = 31739 - 20628;
	local v111 = 2886 + 8225;
	local v112 = 0 - 0;
	v9:RegisterForEvent(function()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (1812 - (1293 + 519))) or ((4853 - 2474) > (11952 - 7374))) then
				v110 = 21247 - 10136;
				v111 = 47911 - 36800;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((1137 - 654) > (394 + 349))) then
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
	local v116 = 0 + 0;
	local function v117()
		if (((5701 - 3247) > (134 + 444)) and v99.CleanseToxins:IsReady() and v109.DispellableFriendlyUnit(9 + 16)) then
			local v158 = 0 + 0;
			while true do
				if (((2026 - (709 + 387)) < (6316 - (673 + 1185))) and (v158 == (0 - 0))) then
					if (((2125 - 1463) <= (1598 - 626)) and (v116 == (0 + 0))) then
						v116 = GetTime();
					end
					if (((3266 + 1104) == (5900 - 1530)) and v109.Wait(123 + 377, v116)) then
						if (v24(v101.CleanseToxinsFocus) or ((9494 - 4732) <= (1689 - 828))) then
							return "cleanse_toxins dispel";
						end
						v116 = 1880 - (446 + 1434);
					end
					break;
				end
			end
		end
	end
	local function v118()
		if ((v97 and (v14:HealthPercentage() <= v98)) or ((2695 - (1040 + 243)) == (12726 - 8462))) then
			if (v99.FlashofLight:IsReady() or ((5015 - (559 + 1288)) < (4084 - (609 + 1322)))) then
				if (v24(v99.FlashofLight) or ((5430 - (13 + 441)) < (4977 - 3645))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		while true do
			if (((23049 - 18421) == (173 + 4455)) and (v132 == (3 - 2))) then
				v28 = v109.HandleBottomTrinket(v102, v31, 15 + 25, nil);
				if (v28 or ((24 + 30) == (1172 - 777))) then
					return v28;
				end
				break;
			end
			if (((45 + 37) == (150 - 68)) and (v132 == (0 + 0))) then
				v28 = v109.HandleTopTrinket(v102, v31, 23 + 17, nil);
				if (v28 or ((418 + 163) < (237 + 45))) then
					return v28;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v120()
		local v133 = 433 - (153 + 280);
		while true do
			if ((v133 == (2 - 1)) or ((4138 + 471) < (986 + 1509))) then
				if (((603 + 549) == (1046 + 106)) and v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) then
					if (((1374 + 522) <= (5209 - 1787)) and v24(v99.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) or ((612 + 378) > (2287 - (89 + 578)))) then
					if (v24(v99.ArdentDefender) or ((627 + 250) > (9760 - 5065))) then
						return "ardent_defender defensive 6";
					end
				end
				v133 = 1051 - (572 + 477);
			end
			if (((363 + 2328) >= (1111 + 740)) and (v133 == (1 + 2))) then
				if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((3071 - (84 + 2)) >= (8002 - 3146))) then
					if (((3081 + 1195) >= (2037 - (497 + 345))) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if (((83 + 3149) <= (793 + 3897)) and v92 and (v14:HealthPercentage() <= v94)) then
					local v210 = 1333 - (605 + 728);
					while true do
						if ((v210 == (0 + 0)) or ((1991 - 1095) >= (145 + 3001))) then
							if (((11317 - 8256) >= (2667 + 291)) and (v96 == "Refreshing Healing Potion")) then
								if (((8829 - 5642) >= (487 + 157)) and v100.RefreshingHealingPotion:IsReady()) then
									if (((1133 - (457 + 32)) <= (299 + 405)) and v24(v101.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((2360 - (832 + 570)) > (893 + 54)) and (v96 == "Dreamwalker's Healing Potion")) then
								if (((1172 + 3320) >= (9391 - 6737)) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (((1659 + 1783) >= (2299 - (588 + 208))) and v24(v101.RefreshingHealingPotion)) then
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
			if ((v133 == (0 - 0)) or ((4970 - (884 + 916)) <= (3064 - 1600))) then
				if (((v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((2782 + 2015) == (5041 - (232 + 421)))) then
					if (((2440 - (1569 + 320)) <= (168 + 513)) and v24(v99.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((623 + 2654) > (1371 - 964)) and (v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
					if (((5300 - (316 + 289)) >= (3704 - 2289)) and v24(v101.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (1455 - (666 + 787))) or ((3637 - (360 + 65)) <= (883 + 61))) then
				if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((3350 - (79 + 175)) <= (2834 - 1036))) then
					if (((2761 + 776) == (10841 - 7304)) and ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (9 - 4)) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff))) then
						if (((4736 - (503 + 396)) >= (1751 - (92 + 89))) and v24(v101.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (3 - 1)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) or ((1513 + 1437) == (2257 + 1555))) then
					if (((18495 - 13772) >= (317 + 2001)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v133 = 6 - 3;
			end
		end
	end
	local function v121()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 + 0)) or ((6173 - 4146) > (356 + 2496))) then
				if (v15:Exists() or ((1732 - 596) > (5561 - (485 + 759)))) then
					if (((10986 - 6238) == (5937 - (442 + 747))) and v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) then
						if (((4871 - (832 + 303)) <= (5686 - (88 + 858))) and v24(v101.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(10 + 20) or ((2806 + 584) <= (127 + 2933))) then
					return;
				end
				v134 = 790 - (766 + 23);
			end
			if ((v134 == (4 - 3)) or ((1365 - 366) > (7095 - 4402))) then
				if (((1571 - 1108) < (1674 - (1036 + 37))) and v13) then
					local v211 = 0 + 0;
					while true do
						if ((v211 == (1 - 0)) or ((1718 + 465) < (2167 - (641 + 839)))) then
							if (((5462 - (910 + 3)) == (11596 - 7047)) and v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) then
								if (((6356 - (1466 + 218)) == (2148 + 2524)) and v24(v101.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) or ((4816 - (556 + 592)) < (141 + 254))) then
								if (v24(v101.BlessingofProtectionFocus) or ((4974 - (329 + 479)) == (1309 - (174 + 680)))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v211 == (0 - 0)) or ((9221 - 4772) == (1902 + 761))) then
							if ((v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (742 - (396 + 343)))) and (v13:HealthPercentage() <= v74)) or ((379 + 3898) < (4466 - (29 + 1448)))) then
								if (v24(v101.WordofGloryFocus) or ((2259 - (135 + 1254)) >= (15630 - 11481))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((10328 - 8116) < (2122 + 1061)) and v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73)) then
								if (((6173 - (389 + 1138)) > (3566 - (102 + 472))) and v24(v101.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v211 = 1 + 0;
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
			if (((1338 + 96) < (4651 - (320 + 1225))) and (v135 == (2 - 0))) then
				if (((481 + 305) < (4487 - (157 + 1307))) and v99.Judgment:IsReady() and v41) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((4301 - (821 + 1038)) < (184 - 110))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((496 + 4039) == (8055 - 3520)) and (v135 == (1 + 0))) then
				if ((v99.Consecration:IsCastable() and v37) or ((7457 - 4448) <= (3131 - (834 + 192)))) then
					if (((117 + 1713) < (942 + 2727)) and v24(v99.Consecration, not v16:IsInRange(1 + 7))) then
						return "consecration";
					end
				end
				if ((v99.AvengersShield:IsCastable() and v35) or ((2215 - 785) >= (3916 - (300 + 4)))) then
					if (((717 + 1966) >= (6439 - 3979)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v135 = 364 - (112 + 250);
			end
			if ((v135 == (0 + 0)) or ((4518 - 2714) >= (1877 + 1398))) then
				if (((v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) or ((733 + 684) > (2715 + 914))) then
					if (((2378 + 2417) > (299 + 103)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((6227 - (1001 + 413)) > (7949 - 4384)) and (v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (887 - (244 + 638)))) then
					if (((4605 - (627 + 66)) == (11656 - 7744)) and v24(v99.ArcaneTorrent, not v16:IsInRange(610 - (512 + 90)))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 1907 - (1665 + 241);
			end
		end
	end
	local function v123()
		local v136 = 717 - (373 + 344);
		local v137;
		while true do
			if (((1273 + 1548) <= (1277 + 3547)) and (v136 == (0 - 0))) then
				if (((2940 - 1202) <= (3294 - (35 + 1064))) and v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (2 + 0)) and v14:HasTier(61 - 32, 1 + 1)) then
					if (((1277 - (298 + 938)) <= (4277 - (233 + 1026))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if (((3811 - (636 + 1030)) <= (2099 + 2005)) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (2 + 0))) then
					if (((799 + 1890) < (328 + 4517)) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v136 = 222 - (55 + 166);
			end
			if ((v136 == (1 + 0)) or ((234 + 2088) > (10013 - 7391))) then
				if ((v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) or ((4831 - (36 + 261)) == (3640 - 1558))) then
					if (v24(v99.AvengingWrath, not v16:IsInRange(1376 - (34 + 1334))) or ((604 + 967) > (1451 + 416))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) or ((3937 - (1035 + 248)) >= (3017 - (20 + 1)))) then
					if (((2073 + 1905) > (2423 - (134 + 185))) and v24(v99.Sentinel, not v16:IsInRange(1141 - (549 + 584)))) then
						return "sentinel cooldowns 8";
					end
				end
				v136 = 687 - (314 + 371);
			end
			if (((10281 - 7286) > (2509 - (478 + 490))) and (v136 == (3 + 1))) then
				if (((4421 - (786 + 386)) > (3086 - 2133)) and v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (1409 - (1055 + 324))))) then
					if (v24(v99.BastionofLight, not v16:IsInRange(1348 - (1093 + 247))) or ((2909 + 364) > (481 + 4092))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v136 == (11 - 8)) or ((10693 - 7542) < (3653 - 2369))) then
				if ((v99.MomentOfGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (37 - 22)) or (((v9.CombatTime() > (4 + 6)) or (v99.Sentinel:CooldownRemains() > (57 - 42)) or (v99.AvengingWrath:CooldownRemains() > (51 - 36))) and (v99.AvengersShield:CooldownRemains() > (0 + 0)) and (v99.Judgment:CooldownRemains() > (0 - 0)) and (v99.HammerofWrath:CooldownRemains() > (688 - (364 + 324)))))) or ((5071 - 3221) == (3668 - 2139))) then
					if (((273 + 548) < (8883 - 6760)) and v24(v99.MomentOfGlory, not v16:IsInRange(12 - 4))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((2739 - 1837) < (3593 - (1249 + 19))) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (3 + 0))) then
					if (((3339 - 2481) <= (4048 - (686 + 400))) and v24(v99.DivineToll, not v16:IsInRange(24 + 6))) then
						return "divine_toll cooldowns 12";
					end
				end
				v136 = 233 - (73 + 156);
			end
			if ((v136 == (1 + 1)) or ((4757 - (721 + 90)) < (15 + 1273))) then
				v137 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
				if (v137 or ((10526 - 7284) == (1037 - (224 + 246)))) then
					return v137;
				end
				v136 = 4 - 1;
			end
		end
	end
	local function v124()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (2 + 4)) or ((21 + 826) >= (928 + 335))) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) or ((4479 - 2226) == (6159 - 4308))) then
					if (v24(v99.Consecration, not v16:IsInRange(521 - (203 + 310))) or ((4080 - (1238 + 755)) > (166 + 2206))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v138 == (1536 - (709 + 825))) or ((8190 - 3745) < (6043 - 1894))) then
				if ((v99.AvengersShield:IsCastable() and v35 and ((v108 > (866 - (196 + 668))) or v14:BuffUp(v99.MomentOfGloryBuff))) or ((7177 - 5359) == (176 - 91))) then
					if (((1463 - (171 + 662)) < (2220 - (4 + 89))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) or ((6792 - 4854) == (916 + 1598))) then
					if (((18688 - 14433) >= (22 + 33)) and v24(v99.DivineToll, not v16:IsInRange(1516 - (35 + 1451)))) then
						return "divine_toll standard 16";
					end
				end
				if (((4452 - (28 + 1425)) > (3149 - (941 + 1052))) and v99.AvengersShield:IsCastable() and v35) then
					if (((2254 + 96) > (2669 - (822 + 692))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v138 = 3 - 0;
			end
			if (((1898 + 2131) <= (5150 - (45 + 252))) and (v138 == (4 + 0))) then
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (2 + 1))) or ((1255 - 739) > (3867 - (114 + 319)))) then
					if (((5808 - 1762) >= (3885 - 852)) and v24(v99.EyeofTyr, not v16:IsInRange(6 + 2))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((v99.BlessedHammer:IsCastable() and v36) or ((4050 - 1331) <= (3031 - 1584))) then
					if (v24(v99.BlessedHammer, not v16:IsInRange(1971 - (556 + 1407))) or ((5340 - (741 + 465)) < (4391 - (170 + 295)))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v99.HammeroftheRighteous:IsCastable() and v39) or ((87 + 77) >= (2559 + 226))) then
					if (v24(v99.HammeroftheRighteous, not v16:IsInRange(19 - 11)) or ((436 + 89) == (1353 + 756))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v138 = 3 + 2;
			end
			if (((1263 - (957 + 273)) == (9 + 24)) and (v138 == (1 + 0))) then
				if (((11637 - 8583) <= (10580 - 6565)) and v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(94 - 63, 9 - 7)) then
					if (((3651 - (389 + 1391)) < (2122 + 1260)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 8";
					end
					if (((135 + 1158) <= (4930 - 2764)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 8";
					end
				end
				if ((v99.HammerofWrath:IsReady() and v40) or ((3530 - (783 + 168)) < (412 - 289))) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((833 + 13) >= (2679 - (309 + 2)))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (5 - 3)) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((5224 - (1090 + 122)) <= (1089 + 2269))) then
					if (((5017 - 3523) <= (2057 + 948)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment standard 12";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((4229 - (628 + 490)) == (383 + 1751))) then
						return "judgment standard 12";
					end
				end
				v138 = 4 - 2;
			end
			if (((10762 - 8407) == (3129 - (431 + 343))) and ((10 - 5) == v138)) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((1700 - 1112) <= (342 + 90))) then
					if (((614 + 4183) >= (5590 - (556 + 1139))) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((3592 - (6 + 9)) == (655 + 2922)) and (v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) then
					if (((1944 + 1850) > (3862 - (28 + 141))) and v24(v99.EyeofTyr, not v16:IsInRange(4 + 4))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (6 - 1))) or ((904 + 371) == (5417 - (486 + 831)))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(20 - 12)) or ((5601 - 4010) >= (677 + 2903))) then
						return "arcane_torrent standard 36";
					end
				end
				v138 = 18 - 12;
			end
			if (((2246 - (668 + 595)) <= (1627 + 181)) and (v138 == (1 + 2))) then
				if ((v99.HammerofWrath:IsReady() and v40) or ((5863 - 3713) <= (1487 - (23 + 267)))) then
					if (((5713 - (1129 + 815)) >= (1560 - (371 + 16))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((3235 - (1326 + 424)) == (2812 - 1327)) and v99.Judgment:IsReady() and v41) then
					local v212 = 0 - 0;
					while true do
						if ((v212 == (118 - (88 + 30))) or ((4086 - (720 + 51)) <= (6188 - 3406))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((2652 - (421 + 1355)) >= (4889 - 1925))) then
								return "judgment standard 22";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((1097 + 1135) > (3580 - (286 + 797)))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (18 - 13)) or not v14:HasTier(51 - 20, 441 - (397 + 42)))) or ((660 + 1450) <= (1132 - (24 + 776)))) then
					if (((5678 - 1992) > (3957 - (222 + 563))) and v24(v99.Consecration, not v16:IsInRange(17 - 9))) then
						return "consecration standard 24";
					end
				end
				v138 = 3 + 1;
			end
			if ((v138 == (190 - (23 + 167))) or ((6272 - (690 + 1108)) < (296 + 524))) then
				if (((3530 + 749) >= (3730 - (40 + 808))) and v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (1 + 4))) then
					if (v24(v99.Consecration, not v16:IsInRange(30 - 22)) or ((1940 + 89) >= (1863 + 1658))) then
						return "consecration standard 2";
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (2 + 0)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (576 - (47 + 524))))) or ((1322 + 715) >= (12689 - 8047))) then
					if (((2571 - 851) < (10166 - 5708)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and (v107 > (1729 - (1165 + 561))) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (1 + 2)) and (v14:HolyPower() < (9 - 6))) or ((167 + 269) > (3500 - (341 + 138)))) then
					local v213 = 0 + 0;
					while true do
						if (((1471 - 758) <= (1173 - (89 + 237))) and (v213 == (0 - 0))) then
							if (((4534 - 2380) <= (4912 - (581 + 300))) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 6";
							end
							if (((5835 - (855 + 365)) == (10961 - 6346)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v125()
		local v139 = 1235 - (1030 + 205);
		while true do
			if ((v139 == (5 + 0)) or ((3526 + 264) == (786 - (156 + 130)))) then
				v48 = EpicSettings.Settings['avengingWrathWithCD'];
				v49 = EpicSettings.Settings['bastionofLightWithCD'];
				v50 = EpicSettings.Settings['divineTollWithCD'];
				v139 = 13 - 7;
			end
			if (((149 - 60) < (452 - 231)) and (v139 == (0 + 0))) then
				v33 = EpicSettings.Settings['swapAuras'];
				v34 = EpicSettings.Settings['useWeapon'];
				v35 = EpicSettings.Settings['useAvengersShield'];
				v139 = 1 + 0;
			end
			if (((2123 - (10 + 59)) >= (402 + 1019)) and (v139 == (9 - 7))) then
				v39 = EpicSettings.Settings['useHammeroftheRighteous'];
				v40 = EpicSettings.Settings['useHammerofWrath'];
				v41 = EpicSettings.Settings['useJudgment'];
				v139 = 1166 - (671 + 492);
			end
			if (((551 + 141) < (4273 - (369 + 846))) and (v139 == (1 + 2))) then
				v42 = EpicSettings.Settings['useAvengingWrath'];
				v43 = EpicSettings.Settings['useBastionofLight'];
				v44 = EpicSettings.Settings['useDivineToll'];
				v139 = 4 + 0;
			end
			if ((v139 == (1951 - (1036 + 909))) or ((2588 + 666) == (2778 - 1123))) then
				v51 = EpicSettings.Settings['eyeofTyrWithCD'];
				v52 = EpicSettings.Settings['momentOfGloryWithCD'];
				v53 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v139 == (207 - (11 + 192))) or ((655 + 641) == (5085 - (135 + 40)))) then
				v45 = EpicSettings.Settings['useEyeofTyr'];
				v46 = EpicSettings.Settings['useMomentOfGlory'];
				v47 = EpicSettings.Settings['useSentinel'];
				v139 = 11 - 6;
			end
			if (((2031 + 1337) == (7419 - 4051)) and (v139 == (1 - 0))) then
				v36 = EpicSettings.Settings['useBlessedHammer'];
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v139 = 178 - (50 + 126);
			end
		end
	end
	local function v126()
		local v140 = 0 - 0;
		while true do
			if (((585 + 2058) < (5228 - (1233 + 180))) and (v140 == (975 - (522 + 447)))) then
				v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v73 = EpicSettings.Settings['layOnHandsFocusHP'];
				v74 = EpicSettings.Settings['wordofGloryFocusHP'];
				v140 = 1428 - (107 + 1314);
			end
			if (((888 + 1025) > (1501 - 1008)) and ((3 + 2) == v140)) then
				v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v70 = EpicSettings.Settings['layonHandsHP'];
				v71 = EpicSettings.Settings['wordofGloryHP'];
				v140 = 11 - 5;
			end
			if (((18813 - 14058) > (5338 - (716 + 1194))) and (v140 == (1 + 7))) then
				v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((148 + 1233) <= (2872 - (74 + 429))) and (v140 == (7 - 3))) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['ardentDefenderHP'];
				v68 = EpicSettings.Settings['divineShieldHP'];
				v140 = 3 + 2;
			end
			if (((0 - 0) == v140) or ((3427 + 1416) == (12590 - 8506))) then
				v54 = EpicSettings.Settings['useRebuke'];
				v55 = EpicSettings.Settings['useHammerofJustice'];
				v56 = EpicSettings.Settings['useArdentDefender'];
				v140 = 2 - 1;
			end
			if (((5102 - (279 + 154)) > (1141 - (454 + 324))) and (v140 == (3 + 0))) then
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v140 = 21 - (12 + 5);
			end
			if ((v140 == (2 + 0)) or ((4782 - 2905) >= (1160 + 1978))) then
				v60 = EpicSettings.Settings['useWordofGloryPlayer'];
				v61 = EpicSettings.Settings['useShieldoftheRighteous'];
				v62 = EpicSettings.Settings['useLayOnHandsFocus'];
				v140 = 1096 - (277 + 816);
			end
			if (((20262 - 15520) >= (4809 - (1058 + 125))) and ((1 + 0) == v140)) then
				v57 = EpicSettings.Settings['useDivineShield'];
				v58 = EpicSettings.Settings['useGuardianofAncientKings'];
				v59 = EpicSettings.Settings['useLayOnHands'];
				v140 = 977 - (815 + 160);
			end
			if ((v140 == (29 - 22)) or ((10777 - 6237) == (219 + 697))) then
				v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v140 = 23 - 15;
			end
		end
	end
	local function v127()
		v87 = EpicSettings.Settings['fightRemainsCheck'] or (1898 - (41 + 1857));
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
		v95 = EpicSettings.Settings['healthstoneHP'] or (1893 - (1222 + 671));
		v94 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v82 = EpicSettings.Settings['handleAfflicted'];
		v83 = EpicSettings.Settings['HandleIncorporeal'];
		v97 = EpicSettings.Settings['HealOOC'];
		v98 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v128()
		local v155 = 1182 - (229 + 953);
		while true do
			if ((v155 == (1777 - (1111 + 663))) or ((2735 - (874 + 705)) > (609 + 3736))) then
				if (((1527 + 710) < (8831 - 4582)) and v32 and v81) then
					v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 2 + 38, 704 - (642 + 37));
					if (v28 or ((612 + 2071) < (4 + 19))) then
						return v28;
					end
					if (((1749 - 1052) <= (1280 - (233 + 221))) and v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
						if (((2555 - 1450) <= (1036 + 140)) and v24(v101.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((4920 - (718 + 823)) <= (2399 + 1413)) and (v109.TargetIsValid() or v14:AffectingCombat())) then
					local v214 = 805 - (266 + 539);
					while true do
						if ((v214 == (0 - 0)) or ((2013 - (636 + 589)) >= (3835 - 2219))) then
							v110 = v9.BossFightRemains(nil, true);
							v111 = v110;
							v214 = 1 - 0;
						end
						if (((1470 + 384) <= (1228 + 2151)) and (v214 == (1016 - (657 + 358)))) then
							if (((12044 - 7495) == (10363 - 5814)) and (v111 == (12298 - (1151 + 36)))) then
								v111 = v9.FightRemains(v105, false);
							end
							v112 = v14:HolyPower();
							break;
						end
					end
				end
				if (not v14:AffectingCombat() or ((2919 + 103) >= (796 + 2228))) then
					if (((14394 - 9574) > (4030 - (1552 + 280))) and v99.DevotionAura:IsCastable() and (v115()) and v33) then
						if (v24(v99.DevotionAura) or ((1895 - (64 + 770)) >= (3321 + 1570))) then
							return "devotion_aura";
						end
					end
				end
				if (((3096 - 1732) <= (795 + 3678)) and v82) then
					if (v78 or ((4838 - (157 + 1086)) <= (5 - 2))) then
						local v223 = 0 - 0;
						while true do
							if ((v223 == (0 - 0)) or ((6376 - 1704) == (4671 - (599 + 220)))) then
								v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 79 - 39);
								if (((3490 - (1813 + 118)) == (1140 + 419)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if ((v14:BuffUp(v99.ShiningLightFreeBuff) and v79) or ((2969 - (841 + 376)) <= (1103 - 315))) then
						local v224 = 0 + 0;
						while true do
							if (((0 - 0) == v224) or ((4766 - (464 + 395)) == (454 - 277))) then
								v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 20 + 20, true);
								if (((4307 - (467 + 370)) > (1146 - 591)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (v83 or ((714 + 258) == (2211 - 1566))) then
					local v215 = 0 + 0;
					while true do
						if (((7402 - 4220) >= (2635 - (150 + 370))) and (v215 == (1282 - (74 + 1208)))) then
							v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 73 - 43, true);
							if (((18462 - 14569) < (3152 + 1277)) and v28) then
								return v28;
							end
							v215 = 391 - (14 + 376);
						end
						if ((v215 == (1 - 0)) or ((1856 + 1011) < (1674 + 231))) then
							v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 29 + 1, true);
							if (v28 or ((5262 - 3466) >= (3048 + 1003))) then
								return v28;
							end
							break;
						end
					end
				end
				v28 = v118();
				v155 = 82 - (23 + 55);
			end
			if (((3836 - 2217) <= (2507 + 1249)) and (v155 == (1 + 0))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (((935 - 331) == (190 + 414)) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v105 = v14:GetEnemiesInMeleeRange(909 - (652 + 249));
				v106 = v14:GetEnemiesInRange(80 - 50);
				if (v30 or ((6352 - (708 + 1160)) == (2442 - 1542))) then
					local v216 = 0 - 0;
					while true do
						if (((27 - (10 + 17)) == v216) or ((1002 + 3457) <= (2845 - (1400 + 332)))) then
							v107 = #v105;
							v108 = #v106;
							break;
						end
					end
				else
					local v217 = 0 - 0;
					while true do
						if (((5540 - (242 + 1666)) > (1455 + 1943)) and ((0 + 0) == v217)) then
							v107 = 1 + 0;
							v108 = 941 - (850 + 90);
							break;
						end
					end
				end
				v103 = v14:ActiveMitigationNeeded();
				v155 = 3 - 1;
			end
			if (((5472 - (360 + 1030)) <= (4352 + 565)) and (v155 == (5 - 3))) then
				v104 = v14:IsTankingAoE(10 - 2) or v14:IsTanking(v16);
				if (((6493 - (909 + 752)) >= (2609 - (109 + 1114))) and not v14:AffectingCombat() and v14:IsMounted()) then
					if (((250 - 113) == (54 + 83)) and v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) then
						if (v24(v99.CrusaderAura) or ((1812 - (6 + 236)) >= (2730 + 1602))) then
							return "crusader_aura";
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((3272 + 792) <= (4289 - 2470))) then
					if (v14:AffectingCombat() or ((8708 - 3722) < (2707 - (1076 + 57)))) then
						if (((728 + 3698) > (861 - (579 + 110))) and v99.Intercession:IsCastable()) then
							if (((47 + 539) > (403 + 52)) and v24(v99.Intercession, not v16:IsInRange(16 + 14), true)) then
								return "intercession target";
							end
						end
					elseif (((1233 - (174 + 233)) == (2307 - 1481)) and v99.Redemption:IsCastable()) then
						if (v24(v99.Redemption, not v16:IsInRange(52 - 22), true) or ((1788 + 2231) > (5615 - (663 + 511)))) then
							return "redemption target";
						end
					end
				end
				if (((1800 + 217) < (926 + 3335)) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((14539 - 9823) > (49 + 31)) and v24(v101.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((8256 - 4749) == (7920 - 4648))) then
					if ((v99.Intercession:IsCastable() and (v14:HolyPower() >= (2 + 1)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1704 - 828) >= (2192 + 883))) then
						if (((398 + 3954) > (3276 - (478 + 244))) and v24(v101.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((4923 - (440 + 77)) < (1839 + 2204))) then
					local v218 = 0 - 0;
					local v219;
					while true do
						if (((1557 - (655 + 901)) == v218) or ((351 + 1538) >= (2590 + 793))) then
							if (((1278 + 614) <= (11014 - 8280)) and v28) then
								return v28;
							end
							break;
						end
						if (((3368 - (695 + 750)) < (7573 - 5355)) and ((0 - 0) == v218)) then
							v219 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v219, v101, 80 - 60, nil, 376 - (285 + 66));
							v218 = 2 - 1;
						end
					end
				end
				v155 = 1313 - (682 + 628);
			end
			if (((351 + 1822) > (678 - (176 + 123))) and (v155 == (3 + 2))) then
				if ((v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) or ((1880 + 711) == (3678 - (239 + 30)))) then
					local v220 = 0 + 0;
					while true do
						if (((4339 + 175) > (5883 - 2559)) and (v220 == (2 - 1))) then
							v28 = v124();
							if (v28 or ((523 - (306 + 9)) >= (16847 - 12019))) then
								return v28;
							end
							v220 = 1 + 1;
						end
						if (((2 + 0) == v220) or ((762 + 821) > (10199 - 6632))) then
							if (v24(v99.Pool) or ((2688 - (1140 + 235)) == (506 + 288))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((2911 + 263) > (745 + 2157)) and (v220 == (52 - (33 + 19)))) then
							if (((1488 + 2632) <= (12768 - 8508)) and (v87 < v111)) then
								v28 = v123();
								if (v28 or ((389 + 494) > (9369 - 4591))) then
									return v28;
								end
								if ((v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) or ((3395 + 225) >= (5580 - (586 + 103)))) then
									if (((388 + 3870) > (2884 - 1947)) and v24(v101.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if ((v88 and ((v31 and v89) or not v89) and v16:IsInRange(1496 - (1309 + 179))) or ((8789 - 3920) < (395 + 511))) then
								local v225 = 0 - 0;
								while true do
									if (((0 + 0) == v225) or ((2602 - 1377) > (8424 - 4196))) then
										v28 = v119();
										if (((3937 - (295 + 314)) > (5496 - 3258)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v220 = 1963 - (1300 + 662);
						end
					end
				end
				break;
			end
			if (((12054 - 8215) > (3160 - (1178 + 577))) and (v155 == (0 + 0))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v155 = 2 - 1;
			end
			if ((v155 == (1409 - (851 + 554))) or ((1144 + 149) <= (1405 - 898))) then
				if (v28 or ((6289 - 3393) < (1107 - (115 + 187)))) then
					return v28;
				end
				if (((1774 + 542) == (2193 + 123)) and v81 and v32) then
					local v221 = 0 - 0;
					while true do
						if ((v221 == (1161 - (160 + 1001))) or ((2249 + 321) == (1058 + 475))) then
							if (v13 or ((1807 - 924) == (1818 - (237 + 121)))) then
								local v226 = 897 - (525 + 372);
								while true do
									if ((v226 == (0 - 0)) or ((15176 - 10557) <= (1141 - (96 + 46)))) then
										v28 = v117();
										if (v28 or ((4187 - (643 + 134)) > (1486 + 2630))) then
											return v28;
										end
										break;
									end
								end
							end
							if ((v15 and v15:Exists() and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15))) or ((2164 - 1261) >= (11356 - 8297))) then
								if (v99.CleanseToxins:IsReady() or ((3814 + 162) < (5606 - 2749))) then
									if (((10077 - 5147) > (3026 - (316 + 403))) and v24(v101.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v121();
				if (v28 or ((2690 + 1356) < (3549 - 2258))) then
					return v28;
				end
				if (v104 or ((1533 + 2708) == (8927 - 5382))) then
					v28 = v120();
					if (v28 or ((2869 + 1179) > (1364 + 2868))) then
						return v28;
					end
				end
				if ((v109.TargetIsValid() and not v14:AffectingCombat() and v29) or ((6063 - 4313) >= (16586 - 13113))) then
					local v222 = 0 - 0;
					while true do
						if (((182 + 2984) == (6232 - 3066)) and (v222 == (0 + 0))) then
							v28 = v122();
							if (((5186 - 3423) < (3741 - (12 + 5))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v155 = 19 - 14;
			end
		end
	end
	local function v129()
		local v156 = 0 - 0;
		while true do
			if (((120 - 63) <= (6752 - 4029)) and (v156 == (0 + 0))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v113();
				break;
			end
		end
	end
	v20.SetAPL(2039 - (1656 + 317), v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

