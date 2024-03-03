local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((8908 - 5084) > (3616 + 974))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DeathKnight_Unholy.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = v9.Cast;
	local v20 = v9.Mouseover;
	local v21 = v9.Macro;
	local v22 = v9.Commons.Everyone.num;
	local v23 = v9.Commons.Everyone.bool;
	local v24 = math.min;
	local v25 = math.abs;
	local v26 = math.max;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v19 = v9.Cast;
	local v30 = table.insert;
	local v31 = GetTime;
	local v32;
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
	local function v60()
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (1739 - (404 + 1335));
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (406 - (183 + 223));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 + 0);
		v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 + 0);
		v45 = EpicSettings.Settings['UseAMSAMZOffensively'];
		v46 = EpicSettings.Settings['AntiMagicShellGCD'];
		v47 = EpicSettings.Settings['AntiMagicZoneGCD'];
		v48 = EpicSettings.Settings['DeathAndDecayGCD'];
		v49 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
		v50 = EpicSettings.Settings['SacrificialPactGCD'];
		v51 = EpicSettings.Settings['MindFreezeOffGCD'];
		v52 = EpicSettings.Settings['RacialsOffGCD'];
		v53 = EpicSettings.Settings['ApocalypseGCD'];
		v54 = EpicSettings.Settings['DarkTransformationGCD'];
		v55 = EpicSettings.Settings['EpidemicGCD'];
		v56 = EpicSettings.Settings['SummonGargoyleGCD'];
		v57 = EpicSettings.Settings['UnholyAssaultGCD'];
		v58 = EpicSettings.Settings['UnholyBlightGCD'];
		v59 = EpicSettings.Settings['VileContagionGCD'];
	end
	local v61 = v16.DeathKnight.Unholy;
	local v62 = v18.DeathKnight.Unholy;
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {};
	local v65 = v13:GetEquipment();
	local v66 = (v65[350 - (10 + 327)] and v18(v65[10 + 3])) or v18(338 - (118 + 220));
	local v67 = (v65[5 + 9] and v18(v65[463 - (108 + 341)])) or v18(0 + 0);
	local v68;
	local v69;
	local v70 = v9.Commons.Everyone;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80, v81;
	local v82, v83;
	local v84, v85;
	local v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
	local v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
	local v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
	local v89;
	local v90 = 46975 - 35864;
	local v91 = 12604 - (711 + 782);
	local v92 = v9.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v65 = v13:GetEquipment();
		v66 = (v65[38 - 25] and v18(v65[13 + 0])) or v18(0 + 0);
		v67 = (v65[7 + 7] and v18(v65[36 - 22])) or v18(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v90 = 12278 - (645 + 522);
		v91 = 12901 - (1010 + 780);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
		v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
		v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v13:HealthPercentage() < v43) or ((v13:HealthPercentage() < v44) and v13:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v147)
		local v148 = 0 + 0;
		local v149;
		while true do
			if (((21589 - 17057) > (7900 - 5204)) and (v148 == (1837 - (1045 + 791)))) then
				return v149;
			end
			if (((2652 - 1604) >= (78 - 26)) and (v148 == (505 - (351 + 154)))) then
				v149 = 1574 - (1281 + 293);
				for v176, v177 in pairs(v147) do
					if (((3224 - (28 + 238)) < (10061 - 5558)) and v177:DebuffDown(v61.VirulentPlagueDebuff)) then
						v149 = v149 + (1560 - (1381 + 178));
					end
				end
				v148 = 1 + 0;
			end
		end
	end
	local function v101(v150)
		local v151 = {};
		for v171 in pairs(v150) do
			if (not v12:IsInBossList(v150[v171]['UnitNPCID']) or ((2206 + 529) == (559 + 750))) then
				v30(v151, v150[v171]);
			end
		end
		return v9.FightRemains(v151);
	end
	local function v102(v152)
		return (v152:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v153)
		return (v153:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v154)
		return (v61.BurstingSores:IsAvailable() and v154:DebuffUp(v61.FesteringWoundDebuff) and ((v13:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v13:Rune() < (10 - 7))) or (v13:BuffUp(v61.DeathAndDecayBuff) and (v13:Rune() == (0 + 0))))) or (not v61.BurstingSores:IsAvailable() and (v154:DebuffStack(v61.FesteringWoundDebuff) >= (474 - (381 + 89)))) or (v13:HasTier(28 + 3, 2 + 0) and v154:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v155)
		return v155:DebuffStack(v61.FesteringWoundDebuff) >= (6 - 2);
	end
	local function v106(v156)
		return v156:DebuffStack(v61.FesteringWoundDebuff) < (1160 - (1074 + 82));
	end
	local function v107(v157)
		return v157:DebuffStack(v61.FesteringWoundDebuff) < (8 - 4);
	end
	local function v108(v158)
		return v158:DebuffStack(v61.FesteringWoundDebuff) >= (1788 - (214 + 1570));
	end
	local function v109(v159)
		return ((v159:TimeToX(1490 - (990 + 465)) < (3 + 2)) or (v159:HealthPercentage() <= (16 + 19))) and (v159:TimeToDie() > (v159:DebuffRemains(v61.SoulReaper) + 5 + 0));
	end
	local function v110(v160)
		return (v160:DebuffStack(v61.FesteringWoundDebuff) <= (7 - 5)) or v14:BuffUp(v61.DarkTransformation);
	end
	local function v111(v161)
		return (v161:DebuffStack(v61.FesteringWoundDebuff) >= (1730 - (1668 + 58))) and (v87:CooldownRemains() < (629 - (512 + 114)));
	end
	local function v112(v162)
		return v162:DebuffStack(v61.FesteringWoundDebuff) >= (2 - 1);
	end
	local function v113(v163)
		return (v163:TimeToDie() > v163:DebuffRemains(v61.VirulentPlagueDebuff)) and (v163:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v163:DebuffRefreshable(v61.FrostFeverDebuff) or v163:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((30 - 15) / ((v22(v61.Superstrain:IsAvailable()) * (10 - 7)) + (v22(v61.Plaguebringer:IsAvailable()) * (1 + 1)) + (v22(v61.EbonFever:IsAvailable()) * (1 + 1)))))));
	end
	local function v114()
		if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive() or not v14:IsActive())) or ((3591 + 539) <= (9967 - 7012))) then
			if (v19(v61.RaiseDead, nil) or ((3958 - (109 + 1885)) <= (2809 - (1269 + 200)))) then
				return "raise_dead precombat 2 displaystyle";
			end
		end
		if (((4789 - 2290) == (3314 - (98 + 717))) and v61.ArmyoftheDead:IsReady() and v29) then
			if (v19(v61.ArmyoftheDead, nil) or ((3081 - (802 + 24)) < (37 - 15))) then
				return "army_of_the_dead precombat 4";
			end
		end
		if (v61.Outbreak:IsReady() or ((1371 - 285) >= (208 + 1197))) then
			if (v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak)) or ((1821 + 548) == (70 + 356))) then
				return "outbreak precombat 6";
			end
		end
		if (v61.FesteringStrike:IsReady() or ((664 + 2412) > (8854 - 5671))) then
			if (((4008 - 2806) > (379 + 679)) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(3 + 2))) then
				return "festering_strike precombat 8";
			end
		end
	end
	local function v115()
		local v164 = 0 + 0;
		while true do
			if (((2699 + 1012) > (1567 + 1788)) and (v164 == (1433 - (797 + 636)))) then
				v68 = v70.HandleTopTrinket(v64, v29, 194 - 154, nil);
				if (v68 or ((2525 - (1427 + 192)) >= (773 + 1456))) then
					return v68;
				end
				v164 = 2 - 1;
			end
			if (((1158 + 130) > (567 + 684)) and (v164 == (327 - (192 + 134)))) then
				v68 = v70.HandleBottomTrinket(v64, v29, 1316 - (316 + 960), nil);
				if (v68 or ((2512 + 2001) < (2587 + 765))) then
					return v68;
				end
				break;
			end
		end
	end
	local function v116()
		if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (10 + 0)))) or ((7894 - 5829) >= (3747 - (83 + 468)))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(1836 - (1202 + 604))) or ((20427 - 16051) <= (2464 - 983))) then
				return "epidemic aoe 2";
			end
		end
		if ((v86:IsReady() and v76) or ((9391 - 5999) >= (5066 - (45 + 280)))) then
			if (((3210 + 115) >= (1882 + 272)) and v70.CastTargetIf(v86, v93, "max", v102, nil, not v15:IsSpellInRange(v86))) then
				return "wound_spender aoe 4";
			end
		end
		if ((v61.FesteringStrike:IsReady() and not v76) or ((473 + 822) >= (1790 + 1443))) then
			if (((770 + 3607) > (3040 - 1398)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v15:IsInMeleeRange(1916 - (340 + 1571)))) then
				return "festering_strike aoe 6";
			end
		end
		if (((1863 + 2860) > (3128 - (1733 + 39))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((11365 - 7229) <= (4467 - (125 + 909)))) then
				return "death_coil aoe 8";
			end
		end
	end
	local function v117()
		if (((6193 - (1096 + 852)) <= (2078 + 2553)) and v61.Epidemic:IsReady() and ((v13:Rune() < (1 - 0)) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (0 + 0)))) and not v77 and ((v94 >= (518 - (409 + 103))) or (v13:RunicPowerDeficit() < (266 - (46 + 190))) or (v13:BuffStack(v61.FestermightBuff) == (115 - (51 + 44))))) then
			if (((1207 + 3069) >= (5231 - (1114 + 203))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(766 - (228 + 498)))) then
				return "epidemic aoe_burst 2";
			end
		end
		if (((43 + 155) <= (2412 + 1953)) and v86:IsReady()) then
			if (((5445 - (174 + 489)) > (12182 - 7506)) and v70.CastTargetIf(v86, v93, "max", v102, v112, not v15:IsSpellInRange(v86))) then
				return "wound_spender aoe_burst 4";
			end
		end
		if (((6769 - (830 + 1075)) > (2721 - (303 + 221))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (1279 - (231 + 1038))))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(34 + 6)) or ((4862 - (171 + 991)) == (10331 - 7824))) then
				return "epidemic aoe_burst 6";
			end
		end
		if (((12013 - 7539) >= (683 - 409)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((1516 + 378) <= (4928 - 3522))) then
				return "death_coil aoe_burst 8";
			end
		end
		if (((4534 - 2962) >= (2467 - 936)) and v86:IsReady()) then
			if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((14488 - 9801) < (5790 - (111 + 1137)))) then
				return "wound_spender aoe_burst 10";
			end
		end
	end
	local function v118()
		if (((3449 - (91 + 67)) > (4961 - 3294)) and v61.VileContagion:IsReady() and (v87:CooldownRemains() < (1 + 2))) then
			if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v15:IsSpellInRange(v61.VileContagion)) or ((1396 - (423 + 100)) == (15 + 2019))) then
				return "vile_contagion aoe_cooldowns 2";
			end
		end
		if (v61.SummonGargoyle:IsReady() or ((7796 - 4980) < (6 + 5))) then
			if (((4470 - (326 + 445)) < (20536 - 15830)) and v19(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle aoe_cooldowns 4";
			end
		end
		if (((5894 - 3248) >= (2044 - 1168)) and v61.AbominationLimb:IsCastable() and ((v13:Rune() < (713 - (530 + 181))) or (v89 > (891 - (614 + 267))) or not v61.Festermight:IsAvailable() or (v13:BuffUp(v61.FestermightBuff) and (v13:BuffRemains(v61.FestermightBuff) < (44 - (19 + 13)))))) then
			if (((999 - 385) <= (7419 - 4235)) and v19(v61.AbominationLimb, nil, nil, not v15:IsInRange(57 - 37))) then
				return "abomination_limb aoe_cooldowns 6";
			end
		end
		if (((812 + 2314) == (5497 - 2371)) and v61.Apocalypse:IsReady()) then
			if (v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v15:IsInMeleeRange(10 - 5)) or ((3999 - (1293 + 519)) >= (10107 - 5153))) then
				return "apocalypse aoe_cooldowns 8";
			end
		end
		if (v61.UnholyAssault:IsCastable() or ((10122 - 6245) == (6836 - 3261))) then
			if (((3048 - 2341) > (1488 - 856)) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v15:IsInMeleeRange(3 + 2), v57)) then
				return "unholy_assault aoe_cooldowns 10";
			end
		end
		if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) or ((112 + 434) >= (6236 - 3552))) then
			if (((339 + 1126) <= (1429 + 2872)) and v19(v61.RaiseDead, nil)) then
				return "raise_dead aoe_cooldowns 12";
			end
		end
		if (((1065 + 639) > (2521 - (709 + 387))) and v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (1868 - (673 + 1185))) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) then
			if (v19(v61.DarkTransformation, v54) or ((1992 - 1305) == (13595 - 9361))) then
				return "dark_transformation aoe_cooldowns 14";
			end
		end
		if ((v61.EmpowerRuneWeapon:IsCastable() and (v14:BuffUp(v61.DarkTransformation))) or ((5478 - 2148) < (1023 + 406))) then
			if (((858 + 289) >= (451 - 116)) and v19(v61.EmpowerRuneWeapon, v49)) then
				return "empower_rune_weapon aoe_cooldowns 16";
			end
		end
		if (((844 + 2591) > (4180 - 2083)) and v61.SacrificialPact:IsReady() and ((v14:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (11 - 5))) or (v91 < v13:GCD()))) then
			if (v19(v61.SacrificialPact, v50) or ((5650 - (446 + 1434)) >= (5324 - (1040 + 243)))) then
				return "sacrificial_pact aoe_cooldowns 18";
			end
		end
	end
	local function v119()
		if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (23 - 15))) and not v13:IsMoving() and (v94 >= (1848 - (559 + 1288)))) or ((5722 - (609 + 1322)) <= (2065 - (13 + 441)))) then
			if (v19(v88, v48) or ((17107 - 12529) <= (5259 - 3251))) then
				return "any_dnd aoe_setup 2";
			end
		end
		if (((5602 - 4477) <= (78 + 1998)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(18 - 13)) or ((264 + 479) >= (1928 + 2471))) then
				return "festering_strike aoe_setup 4";
			end
		end
		if (((3427 - 2272) < (916 + 757)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (18 - 8)))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(27 + 13)) or ((1293 + 1031) <= (416 + 162))) then
				return "epidemic aoe_setup 6";
			end
		end
		if (((3163 + 604) == (3686 + 81)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) then
			if (((4522 - (153 + 280)) == (11807 - 7718)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(5 + 0))) then
				return "festering_strike aoe_setup 8";
			end
		end
		if (((1761 + 2697) >= (877 + 797)) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
			if (((883 + 89) <= (1028 + 390)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v15:IsInMeleeRange(7 - 2))) then
				return "festering_strike aoe_setup 10";
			end
		end
		if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((3052 + 1886) < (5429 - (89 + 578)))) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((1789 + 715) > (8864 - 4600))) then
				return "death_coil aoe_setup 12";
			end
		end
	end
	local function v120()
		local v165 = 1049 - (572 + 477);
		while true do
			if (((291 + 1862) == (1293 + 860)) and (v165 == (1 + 2))) then
				if ((v61.UnholyAssault:IsReady() and v78) or ((593 - (84 + 2)) >= (4269 - 1678))) then
					if (((3229 + 1252) == (5323 - (497 + 345))) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v15:IsInMeleeRange(1 + 4), v57)) then
						return "unholy_assault cooldowns 14";
					end
				end
				if ((v61.SoulReaper:IsReady() and (v94 == (1 + 0)) and ((v15:TimeToX(1368 - (605 + 728)) < (4 + 1)) or (v15:HealthPercentage() <= (77 - 42))) and (v15:TimeToDie() > (1 + 4))) or ((8607 - 6279) < (625 + 68))) then
					if (((11991 - 7663) == (3268 + 1060)) and v19(v61.SoulReaper, nil, nil, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v165 = 493 - (457 + 32);
			end
			if (((674 + 914) >= (2734 - (832 + 570))) and (v165 == (2 + 0))) then
				if ((v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (6 + 17))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v14:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v14:BuffUp(v61.DarkTransformation)))) or (v91 <= (74 - 53)))) or ((2011 + 2163) > (5044 - (588 + 208)))) then
					if (v19(v61.EmpowerRuneWeapon, v49) or ((12360 - 7774) <= (1882 - (884 + 916)))) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if (((8087 - 4224) == (2240 + 1623)) and v61.AbominationLimb:IsCastable() and (v13:Rune() < (656 - (232 + 421))) and v78) then
					if (v19(v61.AbominationLimb) or ((2171 - (1569 + 320)) <= (11 + 31))) then
						return "abomination_limb cooldowns 12";
					end
				end
				v165 = 1 + 2;
			end
			if (((15531 - 10922) >= (1371 - (316 + 289))) and (v165 == (10 - 6))) then
				if ((v61.SoulReaper:IsReady() and (v94 >= (1 + 1))) or ((2605 - (666 + 787)) == (2913 - (360 + 65)))) then
					if (((3199 + 223) > (3604 - (79 + 175))) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if (((1382 - 505) > (294 + 82)) and ((2 - 1) == v165)) then
				if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (9 - 4))) or ((4017 - (503 + 396)) <= (2032 - (92 + 89)))) then
					if (v19(v61.DarkTransformation, v54) or ((319 - 154) >= (1791 + 1701))) then
						return "dark_transformation cooldowns 6";
					end
				end
				if (((2338 + 1611) < (19016 - 14160)) and v61.Apocalypse:IsReady() and v78) then
					if (v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v15:IsInMeleeRange(1 + 4), v53) or ((9749 - 5473) < (2632 + 384))) then
						return "apocalypse cooldowns 8";
					end
				end
				v165 = 1 + 1;
			end
			if (((14284 - 9594) > (515 + 3610)) and (v165 == (0 - 0))) then
				if ((v61.SummonGargoyle:IsCastable() and (v13:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) or ((1294 - (485 + 759)) >= (2073 - 1177))) then
					if (v19(v61.SummonGargoyle, v56) or ((2903 - (442 + 747)) >= (4093 - (832 + 303)))) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) or ((2437 - (88 + 858)) < (197 + 447))) then
					if (((583 + 121) < (41 + 946)) and v19(v61.RaiseDead, nil)) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v165 = 790 - (766 + 23);
			end
		end
	end
	local function v121()
		if (((18354 - 14636) > (2605 - 699)) and v61.Apocalypse:IsReady() and (v89 >= (10 - 6)) and ((v13:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (78 - 55))) or not v61.CommanderoftheDead:IsAvailable())) then
			if (v19(v61.Apocalypse, v53, nil, not v15:IsInMeleeRange(1078 - (1036 + 37))) or ((680 + 278) > (7078 - 3443))) then
				return "apocalypse garg_setup 2";
			end
		end
		if (((2755 + 746) <= (5972 - (641 + 839))) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (916 - (910 + 3))) or v13:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (25 - 15))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) then
			if (v19(v61.ArmyoftheDead) or ((5126 - (1466 + 218)) < (1172 + 1376))) then
				return "army_of_the_dead garg_setup 4";
			end
		end
		if (((4023 - (556 + 592)) >= (521 + 943)) and v61.SoulReaper:IsReady() and (v94 == (809 - (329 + 479))) and ((v15:TimeToX(889 - (174 + 680)) < (17 - 12)) or (v15:HealthPercentage() <= (72 - 37))) and (v15:TimeToDie() > (4 + 1))) then
			if (v19(v61.SoulReaper, nil, nil, not v15:IsInMeleeRange(744 - (396 + 343))) or ((425 + 4372) >= (6370 - (29 + 1448)))) then
				return "soul_reaper garg_setup 6";
			end
		end
		if ((v61.SummonGargoyle:IsCastable() and v29 and (v13:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() >= (1429 - (135 + 1254)))))) or ((2075 - 1524) > (9655 - 7587))) then
			if (((1409 + 705) > (2471 - (389 + 1138))) and v19(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle garg_setup 8";
			end
		end
		if ((v29 and v84 and (v85 <= (597 - (102 + 472)))) or ((2135 + 127) >= (1717 + 1379))) then
			if (v61.EmpowerRuneWeapon:IsCastable() or ((2103 + 152) >= (5082 - (320 + 1225)))) then
				if (v19(v61.EmpowerRuneWeapon, v49) or ((6829 - 2992) < (800 + 506))) then
					return "empower_rune_weapon garg_setup 10";
				end
			end
			if (((4414 - (157 + 1307)) == (4809 - (821 + 1038))) and v61.UnholyAssault:IsCastable()) then
				if (v19(v61.UnholyAssault, v57, nil, not v15:IsInMeleeRange(12 - 7)) or ((517 + 4206) < (5857 - 2559))) then
					return "unholy_assault garg_setup 12";
				end
			end
		end
		if (((423 + 713) >= (381 - 227)) and v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() > (1066 - (834 + 192)))) or not v61.CommanderoftheDead:IsAvailable())) then
			if (v19(v61.DarkTransformation, v54) or ((18 + 253) > (1219 + 3529))) then
				return "dark_transformation garg_setup 16";
			end
		end
		if (((102 + 4638) >= (4882 - 1730)) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and (v89 > (304 - (300 + 4))) and not v13:IsMoving() and (v94 >= (1 + 0))) then
			if (v19(v88, v48) or ((6748 - 4170) >= (3752 - (112 + 250)))) then
				return "any_dnd garg_setup 18";
			end
		end
		if (((17 + 24) <= (4161 - 2500)) and v61.FesteringStrike:IsReady() and ((v89 == (0 + 0)) or not v61.Apocalypse:IsAvailable() or ((v13:RunicPower() < (21 + 19)) and not v84))) then
			if (((450 + 151) < (1766 + 1794)) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(4 + 1))) then
				return "festering_strike garg_setup 20";
			end
		end
		if (((1649 - (1001 + 413)) < (1531 - 844)) and v61.DeathCoil:IsReady() and (v13:Rune() <= (883 - (244 + 638)))) then
			if (((5242 - (627 + 66)) > (3435 - 2282)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil garg_setup 22";
			end
		end
	end
	local function v122()
		local v166 = 602 - (512 + 90);
		local v167;
		while true do
			if ((v166 == (1910 - (1665 + 241))) or ((5391 - (373 + 344)) < (2108 + 2564))) then
				if (((971 + 2697) < (12030 - 7469)) and v61.Outbreak:IsReady()) then
					if (v70.CastCycle(v61.Outbreak, v93, v113, not v15:IsSpellInRange(v61.Outbreak)) or ((769 - 314) == (4704 - (35 + 1064)))) then
						return "outbreak high_prio_actions 14";
					end
				end
				break;
			end
			if ((v166 == (3 + 0)) or ((5697 - 3034) == (14 + 3298))) then
				if (((5513 - (298 + 938)) <= (5734 - (233 + 1026))) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (1669 - (636 + 1030)))) or (v94 >= (2 + 1))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v13:BuffRemains(v61.PlaguebringerBuff) < v13:GCD())) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((850 + 20) == (354 + 835))) then
						return "wound_spender high_prio_actions 10";
					end
				end
				if (((105 + 1448) <= (3354 - (55 + 166))) and v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (5 + 16)))) then
					if (v19(v61.UnholyBlight, v58, nil, not v15:IsInRange(1 + 7)) or ((8543 - 6306) >= (3808 - (36 + 261)))) then
						return "unholy_blight high_prio_actions 12";
					end
				end
				v166 = 6 - 2;
			end
			if ((v166 == (1368 - (34 + 1334))) or ((509 + 815) > (2347 + 673))) then
				v167 = v70.HandleDPSPotion();
				if (v167 or ((4275 - (1035 + 248)) == (1902 - (20 + 1)))) then
					return "DPS Pot";
				end
				v166 = 1 + 0;
			end
			if (((3425 - (134 + 185)) > (2659 - (549 + 584))) and (v166 == (687 - (314 + 371)))) then
				if (((10377 - 7354) < (4838 - (478 + 490))) and v61.DeathCoil:IsReady() and ((v94 <= (2 + 1)) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (1177 - (786 + 386))) and (v13:BuffRemains(v61.CommanderoftheDeadBuff) > (87 - 60))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil high_prio_actions 6";
					end
				end
				if (((16 + 2) < (223 + 1889)) and v61.Epidemic:IsReady() and (v96 >= (15 - 11)) and ((v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (16 - 11))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (((3121 - 2024) <= (4090 - 2462)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(15 + 25))) then
						return "epidemic high_prio_actions 8";
					end
				end
				v166 = 11 - 8;
			end
			if (((15958 - 11328) == (3492 + 1138)) and (v166 == (2 - 1))) then
				if (((4228 - (364 + 324)) > (7354 - 4671)) and v45) then
					local v178 = 0 - 0;
					while true do
						if (((1589 + 3205) >= (13703 - 10428)) and (v178 == (0 - 0))) then
							if (((4506 - 3022) == (2752 - (1249 + 19))) and v61.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (37 + 3)) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (155 - 115)))) then
								if (((2518 - (686 + 400)) < (2790 + 765)) and v19(v61.AntiMagicShell, v46)) then
									return "antimagic_shell ams_amz 2";
								end
							end
							if ((v61.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (299 - (73 + 156))) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) or ((6 + 1059) > (4389 - (721 + 90)))) then
								if (v19(v61.AntiMagicZone, v47) or ((54 + 4741) < (4568 - 3161))) then
									return "antimagic_zone ams_amz 4";
								end
							end
							break;
						end
					end
				end
				if (((2323 - (224 + 246)) < (7796 - 2983)) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (3 - 1))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (7 + 28)))) then
					if (v19(v61.ArmyoftheDead) or ((68 + 2753) < (1786 + 645))) then
						return "army_of_the_dead high_prio_actions 4";
					end
				end
				v166 = 3 - 1;
			end
		end
	end
	local function v123()
		if ((v61.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (66 - 46)) and ((v61.SummonGargoyle:CooldownRemains() < v13:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v13:Rune() < (515 - (203 + 310))) and (v89 < (1994 - (1238 + 755)))))) or ((201 + 2673) < (3715 - (709 + 825)))) then
			if (v19(v61.ArcaneTorrent, v52, nil, not v15:IsInRange(14 - 6)) or ((3916 - 1227) <= (1207 - (196 + 668)))) then
				return "arcane_torrent racials 2";
			end
		end
		if ((v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + (11 - 8)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (124 - 64))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (836 - (171 + 662))))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + (96 - (4 + 89))))) or ((v94 >= (6 - 4)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + 2 + 1)))) or ((8208 - 6339) == (788 + 1221))) then
			if (v19(v61.BloodFury, v52) or ((5032 - (35 + 1451)) < (3775 - (28 + 1425)))) then
				return "blood_fury racials 4";
			end
		end
		if ((v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (1996 - (941 + 1052))) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (58 + 2))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (1517 - (822 + 692))))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + (3 - 0)))) or ((v94 >= (1 + 1)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + (300 - (45 + 252)))))) or ((2060 + 22) == (1643 + 3130))) then
			if (((7894 - 4650) > (1488 - (114 + 319))) and v19(v61.Berserking, v52)) then
				return "berserking racials 6";
			end
		end
		if ((v61.LightsJudgment:IsCastable() and v13:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v13:BuffRemains(v61.FestermightBuff) < v15:TimeToDie()) or (v13:BuffRemains(v61.UnholyStrengthBuff) < v15:TimeToDie()))) or ((4755 - 1442) <= (2277 - 499))) then
			if (v19(v61.LightsJudgment, v52, nil, not v15:IsSpellInRange(v61.LightsJudgment)) or ((906 + 515) >= (3134 - 1030))) then
				return "lights_judgment racials 8";
			end
		end
		if (((3796 - 1984) <= (5212 - (556 + 1407))) and v61.AncestralCall:IsCastable() and ((((1224 - (741 + 465)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (525 - (170 + 295)))) and ((v82 and (v83 <= (10 + 8))) or (v80 and (v81 <= (17 + 1))) or ((v94 >= (4 - 2)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (15 + 3)))) then
			if (((1041 + 582) <= (1109 + 848)) and v19(v61.AncestralCall, v52)) then
				return "ancestral_call racials 10";
			end
		end
		if (((5642 - (957 + 273)) == (1181 + 3231)) and v61.ArcanePulse:IsCastable() and ((v94 >= (1 + 1)) or ((v13:Rune() <= (3 - 2)) and (v13:RunicPowerDeficit() >= (158 - 98))))) then
			if (((5345 - 3595) >= (4169 - 3327)) and v19(v61.ArcanePulse, v52, nil, not v15:IsInRange(1788 - (389 + 1391)))) then
				return "arcane_pulse racials 12";
			end
		end
		if (((2743 + 1629) > (193 + 1657)) and v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + (6 - 3)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1011 - (783 + 168)))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (9 - 6)))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 3 + 0))) or ((v94 >= (313 - (309 + 2))) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + (9 - 6))))) then
			if (((1444 - (1090 + 122)) < (267 + 554)) and v19(v61.Fireblood, v52)) then
				return "fireblood racials 14";
			end
		end
		if (((1739 - 1221) < (618 + 284)) and v61.BagofTricks:IsCastable() and (v94 == (1119 - (628 + 490))) and (v13:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 1 + 4))) then
			if (((7412 - 4418) > (3920 - 3062)) and v19(v61.BagofTricks, v52, nil, not v15:IsSpellInRange(v61.BagofTricks))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v124()
		local v168 = 774 - (431 + 343);
		while true do
			if (((1 - 0) == v168) or ((10863 - 7108) <= (723 + 192))) then
				if (((505 + 3441) > (5438 - (556 + 1139))) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (17 - (6 + 9))) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (3 + 10))) or (v84 and (v85 > (5 + 3))) or (v82 and (v83 > (177 - (28 + 141)))) or (not v76 and (v89 >= (2 + 2))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v14:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 - 0))) and not v13:IsMoving() and (v94 >= (1 + 0))) then
					if (v19(v88, v48) or ((2652 - (486 + 831)) >= (8602 - 5296))) then
						return "any_dnd st 6";
					end
				end
				if (((17053 - 12209) > (426 + 1827)) and v86:IsReady() and (v76 or ((v94 >= (6 - 4)) and v13:BuffUp(v61.DeathAndDecayBuff)))) then
					if (((1715 - (668 + 595)) == (407 + 45)) and v19(v86, nil, nil, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 8";
					end
				end
				v168 = 1 + 1;
			end
			if ((v168 == (0 - 0)) or ((4847 - (23 + 267)) < (4031 - (1129 + 815)))) then
				if (((4261 - (371 + 16)) == (5624 - (1326 + 424))) and v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (18 - 8)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((7081 - 5143) > (5053 - (88 + 30)))) then
						return "death_coil st 2";
					end
				end
				if ((v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (781 - (720 + 51))))) or ((9465 - 5210) < (5199 - (421 + 1355)))) then
					if (((2398 - 944) <= (1224 + 1267)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(1123 - (286 + 797)))) then
						return "epidemic st 4";
					end
				end
				v168 = 3 - 2;
			end
			if (((4 - 1) == v168) or ((4596 - (397 + 42)) <= (876 + 1927))) then
				if (((5653 - (24 + 776)) >= (4593 - 1611)) and v86:IsReady() and not v76) then
					if (((4919 - (222 + 563)) > (7396 - 4039)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if ((v168 == (2 + 0)) or ((3607 - (23 + 167)) < (4332 - (690 + 1108)))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((983 + 1739) <= (136 + 28))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v15:IsInMeleeRange(853 - (40 + 808))) or ((397 + 2011) < (8064 - 5955))) then
						return "festering_strike st 10";
					end
				end
				if (v61.DeathCoil:IsReady() or ((32 + 1) == (770 + 685))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((243 + 200) >= (4586 - (47 + 524)))) then
						return "death_coil st 12";
					end
				end
				v168 = 2 + 1;
			end
		end
	end
	local function v125()
		if (((9244 - 5862) > (247 - 81)) and v33) then
			local v172 = v115();
			if (v172 or ((638 - 358) == (4785 - (1165 + 561)))) then
				return v172;
			end
		end
	end
	local function v126()
		v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (1 + 2))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (12 - 8))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (1 + 1)));
		v71 = (v94 >= (482 - (341 + 138))) or ((v61.SummonGargoyle:CooldownRemains() > (1 + 0)) and ((v61.Apocalypse:CooldownRemains() > (1 - 0)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v9.CombatTime() > (346 - (89 + 237)));
		v74 = ((v61.Apocalypse:CooldownRemains() < (32 - 22)) and (v89 <= (8 - 4)) and (v61.UnholyAssault:CooldownRemains() > (891 - (581 + 300))) and (1227 - (855 + 365))) or (4 - 2);
		if (((615 + 1266) > (2528 - (1030 + 205))) and not v84 and v61.Festermight:IsAvailable() and v13:BuffUp(v61.FestermightBuff) and ((v13:BuffRemains(v61.FestermightBuff) / ((5 + 0) * v13:GCD())) >= (1 + 0))) then
			v75 = v89 >= (287 - (156 + 130));
		else
			v75 = v89 >= ((6 - 3) - v22(v61.InfectedClaws:IsAvailable()));
		end
		v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (1 - 0)) and (v61.UnholyAssault:CooldownRemains() < (40 - 20)) and v61.UnholyAssault:IsAvailable() and v78) or (v15:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1 + 0))) or (v89 > (3 + 1)) or (v13:HasTier(100 - (10 + 59), 2 + 2) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (4 - 3))))) or ((v91 < (1168 - (671 + 492))) and (v89 >= (1 + 0)));
		v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (1218 - (369 + 846))) and (v13:RunicPower() < (16 + 44)) and not v78;
		v78 = (v94 == (1 + 0)) or not v28;
		v79 = (v94 >= (1947 - (1036 + 909))) and v28;
		v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v15:DebuffDown(v61.RottenTouchDebuff)) or (v13:RunicPowerDeficit() < (16 + 4))) and (not v13:HasTier(51 - 20, 207 - (11 + 192)) or (v13:HasTier(16 + 15, 179 - (135 + 40)) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v13:RunicPowerDeficit() < (48 - 28)) or (v13:Rune() < (2 + 1))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (4 - 2)) or v61.CoilofDevastation:IsAvailable())) or (v13:Rune() < (4 - 1)) or v84 or v13:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (186 - (50 + 126))) and (v89 > (8 - 5))) or (not v76 and (v89 >= (1 + 3))));
	end
	local function v127()
		local v169 = 1413 - (1233 + 180);
		while true do
			if (((3326 - (522 + 447)) == (3778 - (107 + 1314))) and (v169 == (2 + 2))) then
				if (((374 - 251) == (53 + 70)) and (v70.TargetIsValid() or v13:AffectingCombat())) then
					v90 = v9.BossFightRemains();
					v91 = v90;
					if ((v91 == (22064 - 10953)) or ((4178 - 3122) >= (5302 - (716 + 1194)))) then
						v91 = v9.FightRemains(v93, false);
					end
					v97 = v100(v95);
					v80 = v61.Apocalypse:TimeSinceLastCast() <= (1 + 14);
					v81 = (v80 and ((2 + 13) - v61.Apocalypse:TimeSinceLastCast())) or (503 - (74 + 429));
					v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (57 - 27);
					v83 = (v82 and ((15 + 15) - v61.ArmyoftheDead:TimeSinceLastCast())) or (0 - 0);
					v84 = v92:GargActive();
					v85 = v92:GargRemains();
					v89 = v15:DebuffStack(v61.FesteringWoundDebuff);
				end
				if (v70.TargetIsValid() or ((765 + 316) < (3313 - 2238))) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2593 - 1544) >= (4865 - (279 + 154)))) then
						local v180 = v70.Interrupt(v61.MindFreeze, 793 - (454 + 324), true);
						if (v180 or ((3752 + 1016) <= (863 - (12 + 5)))) then
							return v180;
						end
						v180 = v70.Interrupt(v61.MindFreeze, 9 + 6, true, v20, v63.MindFreezeMouseover);
						if (v180 or ((8556 - 5198) <= (525 + 895))) then
							return v180;
						end
					end
					if (not v13:AffectingCombat() or ((4832 - (277 + 816)) <= (12840 - 9835))) then
						local v181 = 1183 - (1058 + 125);
						local v182;
						while true do
							if ((v181 == (0 + 0)) or ((2634 - (815 + 160)) >= (9156 - 7022))) then
								v182 = v114();
								if (v182 or ((7738 - 4478) < (562 + 1793))) then
									return v182;
								end
								break;
							end
						end
					end
					if ((v61.DeathStrike:IsReady() and not v69) or ((1955 - 1286) == (6121 - (41 + 1857)))) then
						if (v19(v61.DeathStrike) or ((3585 - (1222 + 671)) < (1519 - 931))) then
							return "death_strike low hp or proc";
						end
					end
					if ((v94 == (0 - 0)) or ((5979 - (229 + 953)) < (5425 - (1111 + 663)))) then
						if ((v61.Outbreak:IsReady() and (v97 > (1579 - (874 + 705)))) or ((585 + 3592) > (3310 + 1540))) then
							if (v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak)) or ((831 - 431) > (32 + 1079))) then
								return "outbreak out_of_range";
							end
						end
						if (((3730 - (642 + 37)) > (230 + 775)) and v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (1 + 0)) and not v77) then
							if (((9271 - 5578) <= (4836 - (233 + 221))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(92 - 52))) then
								return "epidemic out_of_range";
							end
						end
						if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (2 + 0)) and not v77) or ((4823 - (718 + 823)) > (2580 + 1520))) then
							if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((4385 - (266 + 539)) < (8051 - 5207))) then
								return "death_coil out_of_range";
							end
						end
					end
					v126();
					local v179 = v122();
					if (((1314 - (636 + 589)) < (10658 - 6168)) and v179) then
						return v179;
					end
					local v179 = v115();
					if (v179 or ((10277 - 5294) < (1433 + 375))) then
						return v179;
					end
					if (((1392 + 2437) > (4784 - (657 + 358))) and v29 and not v71) then
						local v183 = v121();
						if (((3931 - 2446) <= (6615 - 3711)) and v183) then
							return v183;
						end
					end
					if (((5456 - (1151 + 36)) == (4123 + 146)) and v29 and v78) then
						local v184 = 0 + 0;
						local v185;
						while true do
							if (((1155 - 768) <= (4614 - (1552 + 280))) and (v184 == (834 - (64 + 770)))) then
								v185 = v120();
								if (v185 or ((1290 + 609) <= (2081 - 1164))) then
									return v185;
								end
								break;
							end
						end
					end
					if ((v28 and v29 and v79) or ((766 + 3546) <= (2119 - (157 + 1086)))) then
						local v186 = v118();
						if (((4466 - 2234) <= (11369 - 8773)) and v186) then
							return v186;
						end
					end
					if (((3213 - 1118) < (5030 - 1344)) and v29) then
						local v187 = v123();
						if (v187 or ((2414 - (599 + 220)) >= (8909 - 4435))) then
							return v187;
						end
					end
					if (v28 or ((6550 - (1813 + 118)) < (2107 + 775))) then
						local v188 = 1217 - (841 + 376);
						while true do
							if ((v188 == (0 - 0)) or ((69 + 225) >= (13186 - 8355))) then
								if (((2888 - (464 + 395)) <= (7914 - 4830)) and v79 and (v87:CooldownRemains() < (5 + 5)) and v13:BuffDown(v61.DeathAndDecayBuff)) then
									local v191 = v119();
									if (v191 or ((2874 - (467 + 370)) == (5001 - 2581))) then
										return v191;
									end
								end
								if (((3273 + 1185) > (13382 - 9478)) and (v94 >= (1 + 3)) and v13:BuffUp(v61.DeathAndDecayBuff)) then
									local v192 = v117();
									if (((1014 - 578) >= (643 - (150 + 370))) and v192) then
										return v192;
									end
								end
								v188 = 1283 - (74 + 1208);
							end
							if (((1229 - 729) < (8612 - 6796)) and (v188 == (1 + 0))) then
								if (((3964 - (14 + 376)) == (6198 - 2624)) and (v94 >= (3 + 1)) and (((v87:CooldownRemains() > (9 + 1)) and v13:BuffDown(v61.DeathAndDecayBuff)) or not v79)) then
									local v193 = v116();
									if (((211 + 10) < (1142 - 752)) and v193) then
										return v193;
									end
								end
								break;
							end
						end
					end
					if ((v94 <= (3 + 0)) or ((2291 - (23 + 55)) <= (3367 - 1946))) then
						local v189 = 0 + 0;
						local v190;
						while true do
							if (((2747 + 311) < (7535 - 2675)) and ((0 + 0) == v189)) then
								v190 = v124();
								if (v190 or ((2197 - (652 + 249)) >= (11898 - 7452))) then
									return v190;
								end
								break;
							end
						end
					end
					if (v61.FesteringStrike:IsReady() or ((3261 - (708 + 1160)) > (12184 - 7695))) then
						if (v19(v61.FesteringStrike, nil, nil) or ((8065 - 3641) < (54 - (10 + 17)))) then
							return "festering_strike precombat 8";
						end
					end
				end
				break;
			end
			if ((v169 == (1 + 1)) or ((3729 - (1400 + 332)) > (7317 - 3502))) then
				v69 = not v99();
				v93 = v13:GetEnemiesInMeleeRange(1913 - (242 + 1666));
				v169 = 2 + 1;
			end
			if (((1270 + 2195) > (1631 + 282)) and (v169 == (943 - (850 + 90)))) then
				v95 = v15:GetEnemiesInSplashRange(17 - 7);
				if (((2123 - (360 + 1030)) < (1610 + 209)) and v28) then
					v94 = #v93;
					v96 = v15:GetEnemiesInSplashRangeCount(28 - 18);
				else
					v94 = 1 - 0;
					v96 = 1662 - (909 + 752);
				end
				v169 = 1227 - (109 + 1114);
			end
			if ((v169 == (0 - 0)) or ((1711 + 2684) == (4997 - (6 + 236)))) then
				v60();
				v27 = EpicSettings.Toggles['ooc'];
				v169 = 1 + 0;
			end
			if ((v169 == (1 + 0)) or ((8945 - 5152) < (4137 - 1768))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v169 = 1135 - (1076 + 57);
			end
		end
	end
	local function v128()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (689 - (579 + 110))) or ((323 + 3761) == (235 + 30))) then
				v61.VirulentPlagueDebuff:RegisterAuraTracking();
				v61.FesteringWoundDebuff:RegisterAuraTracking();
				v170 = 1 + 0;
			end
			if (((4765 - (174 + 233)) == (12173 - 7815)) and (v170 == (1 - 0))) then
				v9.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(113 + 139, v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

