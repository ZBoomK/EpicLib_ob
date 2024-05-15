local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((5190 - 1080) > (647 + 3729))) then
			v6 = v0[v4];
			if (not v6 or ((1253 + 377) > (690 + 3508))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((2932 - 1878) == (3514 - 2460)) and (v5 == (1 + 0))) then
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
	local v111 = 4523 + 6588;
	local v112 = 9166 + 1945;
	local v113 = 0 + 0;
	v10:RegisterForEvent(function()
		v111 = 5188 + 5923;
		v112 = 12544 - (797 + 636);
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (v100.CleanseToxins:IsAvailable() or ((3282 - 2606) >= (3261 - (1427 + 192)))) then
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
	local v117 = 0 + 0;
	local function v118()
		if (((9602 - 5466) > (2155 + 242)) and v100.CleanseToxins:IsReady() and (v110.UnitHasDispellableDebuffByPlayer(v14) or v110.DispellableFriendlyUnit(10 + 10) or v110.UnitHasCurseDebuff(v14) or v110.UnitHasPoisonDebuff(v14))) then
			local v160 = 326 - (192 + 134);
			while true do
				if ((v160 == (1276 - (316 + 960))) or ((2412 + 1922) == (3276 + 969))) then
					if ((v117 == (0 + 0)) or ((16346 - 12070) <= (3582 - (83 + 468)))) then
						v117 = GetTime();
					end
					if (v110.Wait(2306 - (1202 + 604), v117) or ((22323 - 17541) <= (1994 - 795))) then
						if (v25(v102.CleanseToxinsFocus) or ((13467 - 8603) < (2227 - (45 + 280)))) then
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
		if (((4228 + 611) >= (1352 + 2348)) and v98 and (v15:HealthPercentage() <= v99)) then
			if (v100.FlashofLight:IsReady() or ((595 + 480) > (338 + 1580))) then
				if (((733 - 337) <= (5715 - (340 + 1571))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if (((1773 - (1733 + 39)) == v132) or ((11455 - 7286) == (3221 - (125 + 909)))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 1988 - (1096 + 852), nil);
				if (((631 + 775) == (2007 - 601)) and v29) then
					return v29;
				end
				break;
			end
			if (((1485 + 46) < (4783 - (409 + 103))) and (v132 == (236 - (46 + 190)))) then
				v29 = v110.HandleTopTrinket(v103, v32, 135 - (51 + 44), nil);
				if (((180 + 455) == (1952 - (1114 + 203))) and v29) then
					return v29;
				end
				v132 = 727 - (228 + 498);
			end
		end
	end
	local function v121()
		if (((731 + 2642) <= (1965 + 1591)) and (v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (v25(v100.DivineShield) or ((3954 - (174 + 489)) < (8545 - 5265))) then
				return "divine_shield defensive";
			end
		end
		if (((6291 - (830 + 1075)) >= (1397 - (303 + 221))) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (((2190 - (231 + 1038)) <= (919 + 183)) and v25(v102.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if (((5868 - (171 + 991)) >= (3968 - 3005)) and v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) then
			if (v25(v100.GuardianofAncientKings) or ((2577 - 1617) <= (2185 - 1309))) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if ((v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) or ((1654 + 412) == (3266 - 2334))) then
			if (((13919 - 9094) < (7806 - 2963)) and v25(v100.ArdentDefender)) then
				return "ardent_defender defensive 6";
			end
		end
		if ((v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) or ((11984 - 8107) >= (5785 - (111 + 1137)))) then
			if ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (163 - (91 + 67))) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff) or ((12842 - 8527) < (431 + 1295))) then
				if (v25(v102.WordofGloryPlayer) or ((4202 - (423 + 100)) < (5 + 620))) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if ((v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (5 - 3)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) or ((2411 + 2214) < (1403 - (326 + 445)))) then
			if (v25(v100.ShieldoftheRighteous) or ((362 - 279) > (3965 - 2185))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if (((1273 - 727) <= (1788 - (530 + 181))) and v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) then
			if (v25(v102.Healthstone) or ((1877 - (614 + 267)) > (4333 - (19 + 13)))) then
				return "healthstone defensive";
			end
		end
		if (((6624 - 2554) > (1600 - 913)) and v93 and (v15:HealthPercentage() <= v95)) then
			local v161 = 0 - 0;
			while true do
				if ((v161 == (0 + 0)) or ((1153 - 497) >= (6905 - 3575))) then
					if ((v97 == "Refreshing Healing Potion") or ((4304 - (1293 + 519)) <= (683 - 348))) then
						if (((11284 - 6962) >= (4899 - 2337)) and v101.RefreshingHealingPotion:IsReady()) then
							if (v25(v102.RefreshingHealingPotion) or ((15682 - 12045) >= (8881 - 5111))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((1261 + 1118) > (934 + 3644))) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((1121 - 638) > (172 + 571))) then
							if (((816 + 1638) > (362 + 216)) and v25(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v133 = 1096 - (709 + 387);
		while true do
			if (((2788 - (673 + 1185)) < (12928 - 8470)) and (v133 == (0 - 0))) then
				if (((1088 - 426) <= (696 + 276)) and v16:Exists()) then
					if (((3266 + 1104) == (5900 - 1530)) and v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) then
						if (v25(v102.WordofGloryMouseover) or ((1170 + 3592) <= (1716 - 855))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(58 - 28) or ((3292 - (446 + 1434)) == (5547 - (1040 + 243)))) then
					return;
				end
				v133 = 2 - 1;
			end
			if ((v133 == (1848 - (559 + 1288))) or ((5099 - (609 + 1322)) < (2607 - (13 + 441)))) then
				if (v14 or ((18594 - 13618) < (3488 - 2156))) then
					if (((23049 - 18421) == (173 + 4455)) and v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (10 - 7))) and (v14:HealthPercentage() <= v75)) then
						if (v25(v102.WordofGloryFocus) or ((20 + 34) == (174 + 221))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((243 - 161) == (45 + 37)) and v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) then
						if (v25(v102.LayonHandsFocus) or ((1068 - 487) < (187 + 95))) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) or ((2564 + 2045) < (1793 + 702))) then
						if (((968 + 184) == (1128 + 24)) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((2329 - (153 + 280)) <= (9881 - 6459)) and v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) then
						if (v25(v102.BlessingofProtectionFocus) or ((889 + 101) > (640 + 980))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) or ((459 + 418) > (4261 + 434))) then
			if (((1950 + 741) >= (2818 - 967)) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (4 + 1))) or ((3652 - (89 + 578)) >= (3469 + 1387))) then
			if (((8889 - 4613) >= (2244 - (572 + 477))) and v25(v100.ArcaneTorrent, not v17:IsInRange(2 + 6))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((1940 + 1292) <= (560 + 4130)) and v100.Consecration:IsCastable() and v38) then
			if (v25(v100.Consecration, not v17:IsInRange(94 - (84 + 2))) or ((1476 - 580) >= (2267 + 879))) then
				return "consecration precombat 8";
			end
		end
		if (((3903 - (497 + 345)) >= (76 + 2882)) and v100.AvengersShield:IsCastable() and v36) then
			local v162 = 0 + 0;
			while true do
				if (((4520 - (605 + 728)) >= (460 + 184)) and (v162 == (0 - 0))) then
					if (((30 + 614) <= (2602 - 1898)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
						if (((864 + 94) > (2623 - 1676)) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover precombat 10";
						end
					end
					if (((3392 + 1100) >= (3143 - (457 + 32))) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
					break;
				end
			end
		end
		if (((1461 + 1981) >= (2905 - (832 + 570))) and v100.Judgment:IsReady() and v42) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2987 + 183) <= (382 + 1082))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v124()
		local v134 = 0 - 0;
		local v135;
		while true do
			if (((2 + 1) == v134) or ((5593 - (588 + 208)) == (11826 - 7438))) then
				if (((2351 - (884 + 916)) <= (1425 - 744)) and v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (9 + 6)) or (((v10.CombatTime() > (663 - (232 + 421))) or (v100.Sentinel:CooldownRemains() > (1904 - (1569 + 320))) or (v100.AvengingWrath:CooldownRemains() > (4 + 11))) and (v100.AvengersShield:CooldownRemains() > (0 + 0)) and (v100.Judgment:CooldownRemains() > (0 - 0)) and (v100.HammerofWrath:CooldownRemains() > (605 - (316 + 289)))))) then
					if (((8578 - 5301) > (19 + 388)) and v25(v100.MomentOfGlory, not v17:IsInRange(1461 - (666 + 787)))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((5120 - (360 + 65)) >= (1323 + 92)) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (257 - (79 + 175)))) then
					if (v25(v100.DivineToll, not v17:IsInRange(47 - 17)) or ((2507 + 705) <= (2893 - 1949))) then
						return "divine_toll cooldowns 12";
					end
				end
				v134 = 7 - 3;
			end
			if ((v134 == (900 - (503 + 396))) or ((3277 - (92 + 89)) <= (3487 - 1689))) then
				if (((1814 + 1723) == (2094 + 1443)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
					if (((15025 - 11188) >= (215 + 1355)) and v25(v100.AvengingWrath, not v17:IsInRange(17 - 9))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) or ((2574 + 376) == (1821 + 1991))) then
					if (((14384 - 9661) >= (290 + 2028)) and v25(v100.Sentinel, not v17:IsInRange(12 - 4))) then
						return "sentinel cooldowns 8";
					end
				end
				v134 = 1246 - (485 + 759);
			end
			if (((8 - 4) == v134) or ((3216 - (442 + 747)) > (3987 - (832 + 303)))) then
				if ((v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (976 - (88 + 858))))) or ((347 + 789) > (3573 + 744))) then
					if (((196 + 4552) == (5537 - (766 + 23))) and v25(v100.BastionofLight, not v17:IsInRange(39 - 31))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if (((5108 - 1372) <= (12488 - 7748)) and (v134 == (6 - 4))) then
				v135 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
				if (v135 or ((4463 - (1036 + 37)) <= (2170 + 890))) then
					return v135;
				end
				v134 = 5 - 2;
			end
			if ((v134 == (0 + 0)) or ((2479 - (641 + 839)) > (3606 - (910 + 3)))) then
				if (((1180 - 717) < (2285 - (1466 + 218))) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (1 + 1)) and v15:HasTier(1177 - (556 + 592), 1 + 1)) then
					local v219 = 808 - (329 + 479);
					while true do
						if (((854 - (174 + 680)) == v219) or ((7500 - 5317) < (1423 - 736))) then
							if (((3248 + 1301) == (5288 - (396 + 343))) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
								if (((414 + 4258) == (6149 - (29 + 1448))) and v25(v102.AvengersShieldMouseover)) then
									return "avengers_shield mouseover cooldowns 2";
								end
							end
							if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((5057 - (135 + 1254)) < (1488 - 1093))) then
								return "avengers_shield cooldowns 2";
							end
							break;
						end
					end
				end
				if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (9 - 7))) or ((2777 + 1389) == (1982 - (389 + 1138)))) then
					if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((5023 - (102 + 472)) == (2514 + 149))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v134 = 1 + 0;
			end
		end
	end
	local function v125()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (1550 - (320 + 1225))) or ((7613 - 3336) < (1829 + 1160))) then
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((2334 - (157 + 1307)) >= (6008 - (821 + 1038)))) then
					if (((5518 - 3306) < (349 + 2834)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((8251 - 3605) > (1114 + 1878)) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) then
					if (((3554 - 2120) < (4132 - (834 + 192))) and v25(v100.EyeofTyr, not v17:IsInRange(1 + 7))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((202 + 584) < (65 + 2958)) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (7 - 2))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(312 - (300 + 4))) or ((653 + 1789) < (193 - 119))) then
						return "arcane_torrent standard 36";
					end
				end
				v136 = 368 - (112 + 250);
			end
			if (((1808 + 2727) == (11361 - 6826)) and (v136 == (2 + 0))) then
				if ((v100.AvengersShield:IsCastable() and v36 and ((v109 > (2 + 0)) or v15:BuffUp(v100.MomentOfGloryBuff))) or ((2251 + 758) <= (1044 + 1061))) then
					local v220 = 0 + 0;
					while true do
						if (((3244 - (1001 + 413)) < (8181 - 4512)) and (v220 == (882 - (244 + 638)))) then
							if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) or ((2123 - (627 + 66)) >= (10762 - 7150))) then
								if (((3285 - (512 + 90)) >= (4366 - (1665 + 241))) and v25(v102.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 14";
								end
							end
							if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((2521 - (373 + 344)) >= (1478 + 1797))) then
								return "avengers_shield standard 14";
							end
							break;
						end
					end
				end
				if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) or ((375 + 1042) > (9572 - 5943))) then
					if (((8114 - 3319) > (1501 - (35 + 1064))) and v25(v100.DivineToll, not v17:IsInRange(22 + 8))) then
						return "divine_toll standard 16";
					end
				end
				if (((10297 - 5484) > (15 + 3550)) and v100.AvengersShield:IsCastable() and v36) then
					local v221 = 1236 - (298 + 938);
					while true do
						if (((5171 - (233 + 1026)) == (5578 - (636 + 1030))) and (v221 == (0 + 0))) then
							if (((2756 + 65) <= (1434 + 3390)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
								if (((118 + 1620) <= (2416 - (55 + 166))) and v25(v102.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 18";
								end
							end
							if (((8 + 33) <= (304 + 2714)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
								return "avengers_shield standard 18";
							end
							break;
						end
					end
				end
				v136 = 11 - 8;
			end
			if (((2442 - (36 + 261)) <= (7177 - 3073)) and (v136 == (1371 - (34 + 1334)))) then
				if (((1034 + 1655) < (3765 + 1080)) and v100.HammerofWrath:IsReady() and v41) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((3605 - (1035 + 248)) > (2643 - (20 + 1)))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v100.Judgment:IsReady() and v42) or ((2363 + 2171) == (2401 - (134 + 185)))) then
					local v222 = 1133 - (549 + 584);
					while true do
						if ((v222 == (685 - (314 + 371))) or ((5393 - 3822) > (2835 - (478 + 490)))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1406 + 1248) >= (4168 - (786 + 386)))) then
								return "judgment standard 22";
							end
							if (((12884 - 8906) > (3483 - (1055 + 324))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if (((4335 - (1093 + 247)) > (1370 + 171)) and v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (1 + 4)) or not v15:HasTier(123 - 92, 6 - 4))) then
					if (((9244 - 5995) > (2394 - 1441)) and v25(v100.Consecration, not v17:IsInRange(3 + 5))) then
						return "consecration standard 24";
					end
				end
				v136 = 15 - 11;
			end
			if ((v136 == (0 - 0)) or ((2468 + 805) > (11694 - 7121))) then
				if ((v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (693 - (364 + 324)))) or ((8637 - 5486) < (3081 - 1797))) then
					if (v25(v100.Consecration, not v17:IsInRange(3 + 5)) or ((7741 - 5891) == (2448 - 919))) then
						return "consecration standard 2";
					end
				end
				if (((2493 - 1672) < (3391 - (1249 + 19))) and v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (2 + 0)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (19 - 14)))) then
					if (((1988 - (686 + 400)) < (1825 + 500)) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((1087 - (73 + 156)) <= (15 + 2947)) and v100.Judgment:IsReady() and v42 and (v108 > (814 - (721 + 90))) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (1 + 2)) and (v15:HolyPower() < (9 - 6))) then
					if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((4416 - (224 + 246)) < (2086 - 798))) then
						return "judgment standard 6";
					end
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((5968 - 2726) == (103 + 464))) then
						return "judgment standard 6";
					end
				end
				v136 = 1 + 0;
			end
			if ((v136 == (1 + 0)) or ((1683 - 836) >= (4202 - 2939))) then
				if ((v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(544 - (203 + 310), 1995 - (1238 + 755))) or ((158 + 2095) == (3385 - (709 + 825)))) then
					if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((3845 - 1758) > (3454 - 1082))) then
						return "judgment standard 8";
					end
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((5309 - (196 + 668)) < (16381 - 12232))) then
						return "judgment standard 8";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v41) or ((3765 - 1947) == (918 - (171 + 662)))) then
					if (((723 - (4 + 89)) < (7455 - 5328)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (1 + 1)) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) or ((8512 - 6574) == (986 + 1528))) then
					if (((5741 - (35 + 1451)) >= (1508 - (28 + 1425))) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 12";
					end
					if (((4992 - (941 + 1052)) > (1109 + 47)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 12";
					end
				end
				v136 = 1516 - (822 + 692);
			end
			if (((3355 - 1005) > (545 + 610)) and (v136 == (303 - (45 + 252)))) then
				if (((3987 + 42) <= (1671 + 3182)) and v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) then
					if (v25(v100.Consecration, not v17:IsInRange(19 - 11)) or ((949 - (114 + 319)) > (4930 - 1496))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((5184 - 1138) >= (1934 + 1099)) and (v136 == (5 - 1))) then
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (5 - 2))) or ((4682 - (556 + 1407)) <= (2653 - (741 + 465)))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(473 - (170 + 295))) or ((2179 + 1955) < (3607 + 319))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((v100.BlessedHammer:IsCastable() and v37) or ((403 - 239) >= (2309 + 476))) then
					if (v25(v100.BlessedHammer, not v17:IsInRange(6 + 2)) or ((298 + 227) == (3339 - (957 + 273)))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((9 + 24) == (14 + 19)) and v100.HammeroftheRighteous:IsCastable() and v40) then
					if (((11637 - 8583) <= (10580 - 6565)) and v25(v100.HammeroftheRighteous, not v17:IsInRange(24 - 16))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v136 = 24 - 19;
			end
		end
	end
	local function v126()
		local v137 = 1780 - (389 + 1391);
		while true do
			if (((1174 + 697) < (353 + 3029)) and (v137 == (0 - 0))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v137 = 952 - (783 + 168);
			end
			if (((4339 - 3046) <= (2131 + 35)) and (v137 == (313 - (309 + 2)))) then
				v42 = EpicSettings.Settings['useJudgment'];
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v137 = 9 - 6;
			end
			if ((v137 == (1217 - (1090 + 122))) or ((837 + 1742) < (412 - 289))) then
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v137 == (3 + 1)) or ((1964 - (628 + 490)) >= (425 + 1943))) then
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v137 = 12 - 7;
			end
			if (((4 - 3) == v137) or ((4786 - (431 + 343)) <= (6781 - 3423))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v137 = 5 - 3;
			end
			if (((1181 + 313) <= (385 + 2620)) and (v137 == (1698 - (556 + 1139)))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v137 = 19 - (6 + 9);
			end
		end
	end
	local function v127()
		local v138 = 0 + 0;
		while true do
			if (((2 + 0) == v138) or ((3280 - (28 + 141)) == (827 + 1307))) then
				v61 = EpicSettings.Settings['useWordofGloryPlayer'];
				v62 = EpicSettings.Settings['useShieldoftheRighteous'];
				v63 = EpicSettings.Settings['useLayOnHandsFocus'];
				v138 = 3 - 0;
			end
			if (((1668 + 687) == (3672 - (486 + 831))) and (v138 == (20 - 12))) then
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((13 - 9) == v138) or ((112 + 476) <= (1365 - 933))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['ardentDefenderHP'];
				v69 = EpicSettings.Settings['divineShieldHP'];
				v138 = 1268 - (668 + 595);
			end
			if (((4317 + 480) >= (786 + 3109)) and (v138 == (0 - 0))) then
				v55 = EpicSettings.Settings['useRebuke'];
				v56 = EpicSettings.Settings['useHammerofJustice'];
				v57 = EpicSettings.Settings['useArdentDefender'];
				v138 = 291 - (23 + 267);
			end
			if (((5521 - (1129 + 815)) == (3964 - (371 + 16))) and (v138 == (1751 - (1326 + 424)))) then
				v58 = EpicSettings.Settings['useDivineShield'];
				v59 = EpicSettings.Settings['useGuardianofAncientKings'];
				v60 = EpicSettings.Settings['useLayOnHands'];
				v138 = 3 - 1;
			end
			if (((13864 - 10070) > (3811 - (88 + 30))) and ((774 - (720 + 51)) == v138)) then
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v138 = 8 - 4;
			end
			if ((v138 == (1783 - (421 + 1355))) or ((2103 - 828) == (2014 + 2086))) then
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v138 = 1091 - (286 + 797);
			end
			if ((v138 == (21 - 15)) or ((2635 - 1044) >= (4019 - (397 + 42)))) then
				v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v74 = EpicSettings.Settings['layOnHandsFocusHP'];
				v75 = EpicSettings.Settings['wordofGloryFocusHP'];
				v138 = 3 + 4;
			end
			if (((1783 - (24 + 776)) <= (2785 - 977)) and ((790 - (222 + 563)) == v138)) then
				v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v71 = EpicSettings.Settings['layonHandsHP'];
				v72 = EpicSettings.Settings['wordofGloryHP'];
				v138 = 12 - 6;
			end
		end
	end
	local function v128()
		v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v85 = EpicSettings.Settings['InterruptWithStun'];
		v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v87 = EpicSettings.Settings['InterruptThreshold'];
		v82 = EpicSettings.Settings['DispelDebuffs'];
		v81 = EpicSettings.Settings['DispelBuffs'];
		v89 = EpicSettings.Settings['useTrinkets'];
		v91 = EpicSettings.Settings['useRacials'];
		v90 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useHealthstone'];
		v93 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['healthstoneHP'] or (190 - (23 + 167));
		v95 = EpicSettings.Settings['healingPotionHP'] or (1798 - (690 + 1108));
		v97 = EpicSettings.Settings['HealingPotionName'] or "";
		v83 = EpicSettings.Settings['handleAfflicted'];
		v84 = EpicSettings.Settings['HandleIncorporeal'];
		v98 = EpicSettings.Settings['HealOOC'];
		v99 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v129()
		v127();
		v126();
		v128();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((1774 + 376) <= (2045 - (40 + 808)))) then
			return v29;
		end
		v106 = v15:GetEnemiesInMeleeRange(2 + 6);
		v107 = v15:GetEnemiesInRange(114 - 84);
		if (((3603 + 166) >= (621 + 552)) and v31) then
			v108 = #v106;
			v109 = #v107;
		else
			v108 = 1 + 0;
			v109 = 572 - (47 + 524);
		end
		v104 = v15:ActiveMitigationNeeded();
		v105 = v15:IsTankingAoE(6 + 2) or v15:IsTanking(v17);
		if (((4059 - 2574) == (2220 - 735)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) or ((7560 - 4245) <= (4508 - (1165 + 561)))) then
				if (v25(v100.CrusaderAura) or ((27 + 849) >= (9179 - 6215))) then
					return "crusader_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((852 + 1380) > (2976 - (341 + 138)))) then
			if (v15:AffectingCombat() or ((570 + 1540) <= (684 - 352))) then
				if (((4012 - (89 + 237)) > (10204 - 7032)) and v100.Intercession:IsCastable()) then
					if (v25(v100.Intercession, not v17:IsInRange(63 - 33), true) or ((5355 - (581 + 300)) < (2040 - (855 + 365)))) then
						return "intercession target";
					end
				end
			elseif (((10163 - 5884) >= (942 + 1940)) and v100.Redemption:IsCastable()) then
				if (v25(v100.Redemption, not v17:IsInRange(1265 - (1030 + 205)), true) or ((1905 + 124) >= (3276 + 245))) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((2323 - (156 + 130)) >= (10547 - 5905))) then
			if (((2898 - 1178) < (9130 - 4672)) and v25(v102.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (v15:AffectingCombat() or ((115 + 321) > (1762 + 1259))) then
			if (((782 - (10 + 59)) <= (240 + 607)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (14 - 11)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (((3317 - (671 + 492)) <= (3209 + 822)) and v25(v102.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if (((5830 - (369 + 846)) == (1222 + 3393)) and (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()))) then
			local v163 = 0 + 0;
			local v164;
			while true do
				if (((1945 - (1036 + 909)) == v163) or ((3014 + 776) == (839 - 339))) then
					v164 = v82 and v100.CleanseToxins:IsReady() and v33;
					v29 = v110.FocusUnit(v164, nil, 223 - (11 + 192), nil, 13 + 12, v100.FlashofLight);
					v163 = 176 - (135 + 40);
				end
				if (((215 - 126) < (134 + 87)) and (v163 == (2 - 1))) then
					if (((3078 - 1024) >= (1597 - (50 + 126))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((1926 - 1234) < (677 + 2381)) and v33 and v82) then
			v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 1453 - (1233 + 180), 994 - (522 + 447), v100.FlashofLight, 1423 - (107 + 1314));
			if (v29 or ((1510 + 1744) == (5042 - 3387))) then
				return v29;
			end
			if ((v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((551 + 745) == (9750 - 4840))) then
				if (((13325 - 9957) == (5278 - (716 + 1194))) and v25(v102.BlessingofFreedomFocus)) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((46 + 2597) < (409 + 3406)) and (v110.TargetIsValid() or v15:AffectingCombat())) then
			local v165 = 503 - (74 + 429);
			while true do
				if (((3689 - 1776) > (245 + 248)) and ((0 - 0) == v165)) then
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					v165 = 1 + 0;
				end
				if (((14659 - 9904) > (8475 - 5047)) and (v165 == (434 - (279 + 154)))) then
					if (((2159 - (454 + 324)) <= (1864 + 505)) and (v112 == (11128 - (12 + 5)))) then
						v112 = v10.FightRemains(v106, false);
					end
					v113 = v15:HolyPower();
					break;
				end
			end
		end
		v29 = v122();
		if (v29 or ((2612 + 2231) == (10406 - 6322))) then
			return v29;
		end
		v29 = v119();
		if (((1726 + 2943) > (1456 - (277 + 816))) and v29) then
			return v29;
		end
		if (not v15:AffectingCombat() or ((8020 - 6143) >= (4321 - (1058 + 125)))) then
			if (((890 + 3852) >= (4601 - (815 + 160))) and v100.DevotionAura:IsCastable() and (v116()) and v34) then
				if (v25(v100.DevotionAura) or ((19479 - 14939) == (2174 - 1258))) then
					return "devotion_aura";
				end
			end
		end
		if (v83 or ((276 + 880) > (12701 - 8356))) then
			if (((4135 - (41 + 1857)) < (6142 - (1222 + 671))) and v79) then
				v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 103 - 63);
				if (v29 or ((3855 - 1172) < (1205 - (229 + 953)))) then
					return v29;
				end
			end
			if (((2471 - (1111 + 663)) <= (2405 - (874 + 705))) and v15:BuffUp(v100.ShiningLightFreeBuff) and v80) then
				v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 6 + 34, true);
				if (((754 + 351) <= (2444 - 1268)) and v29) then
					return v29;
				end
			end
		end
		if (((96 + 3283) <= (4491 - (642 + 37))) and v84) then
			local v166 = 0 + 0;
			while true do
				if (((0 + 0) == v166) or ((1978 - 1190) >= (2070 - (233 + 221)))) then
					v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 69 - 39, true);
					if (((1632 + 222) <= (4920 - (718 + 823))) and v29) then
						return v29;
					end
					v166 = 1 + 0;
				end
				if (((5354 - (266 + 539)) == (12878 - 8329)) and (v166 == (1226 - (636 + 589)))) then
					v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 71 - 41, true);
					if (v29 or ((6232 - 3210) >= (2397 + 627))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((1752 + 3068) > (3213 - (657 + 358))) and v82 and v33) then
			local v167 = 0 - 0;
			while true do
				if ((v167 == (0 - 0)) or ((2248 - (1151 + 36)) >= (4724 + 167))) then
					if (((359 + 1005) <= (13358 - 8885)) and v14) then
						local v223 = 1832 - (1552 + 280);
						while true do
							if ((v223 == (834 - (64 + 770))) or ((2441 + 1154) <= (6 - 3))) then
								v29 = v118();
								if (v29 or ((830 + 3842) == (5095 - (157 + 1086)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((3120 - 1561) == (6827 - 5268)) and v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16) or v110.UnitHasDispellableDebuffByPlayer(v16))) then
						if (v100.CleanseToxins:IsReady() or ((2686 - 934) <= (1075 - 287))) then
							if (v25(v102.CleanseToxinsMouseover) or ((4726 - (599 + 220)) == (352 - 175))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		if (((5401 - (1813 + 118)) > (406 + 149)) and v105) then
			local v168 = 1217 - (841 + 376);
			while true do
				if ((v168 == (0 - 0)) or ((226 + 746) == (1760 - 1115))) then
					v29 = v121();
					if (((4041 - (464 + 395)) >= (5427 - 3312)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((1870 + 2023) < (5266 - (467 + 370))) and v110.TargetIsValid() and not v15:AffectingCombat() and v30) then
			local v169 = 0 - 0;
			while true do
				if ((v169 == (0 + 0)) or ((9827 - 6960) < (298 + 1607))) then
					v29 = v123();
					if (v29 or ((4178 - 2382) >= (4571 - (150 + 370)))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((2901 - (74 + 1208)) <= (9238 - 5482)) and v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
			if (((2864 - 2260) == (430 + 174)) and (v88 < v112)) then
				local v217 = 390 - (14 + 376);
				while true do
					if ((v217 == (1 - 0)) or ((2902 + 1582) == (791 + 109))) then
						if ((v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((4253 + 206) <= (3261 - 2148))) then
							if (((2733 + 899) > (3476 - (23 + 55))) and v25(v102.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
						break;
					end
					if (((9673 - 5591) <= (3282 + 1635)) and (v217 == (0 + 0))) then
						v29 = v124();
						if (((7491 - 2659) >= (436 + 950)) and v29) then
							return v29;
						end
						v217 = 902 - (652 + 249);
					end
				end
			end
			if (((366 - 229) == (2005 - (708 + 1160))) and v89 and ((v32 and v90) or not v90) and v17:IsInRange(21 - 13)) then
				local v218 = 0 - 0;
				while true do
					if (((27 - (10 + 17)) == v218) or ((353 + 1217) >= (6064 - (1400 + 332)))) then
						v29 = v120();
						if (v29 or ((7794 - 3730) <= (3727 - (242 + 1666)))) then
							return v29;
						end
						break;
					end
				end
			end
			v29 = v125();
			if (v29 or ((2134 + 2852) < (577 + 997))) then
				return v29;
			end
			if (((3773 + 653) > (1112 - (850 + 90))) and v25(v100.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v130()
		local v157 = 0 - 0;
		while true do
			if (((1976 - (360 + 1030)) > (403 + 52)) and (v157 == (0 - 0))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v114();
				break;
			end
		end
	end
	v21.SetAPL(90 - 24, v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

