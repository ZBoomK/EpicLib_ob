local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1513 + 2311) >= (1153 - (717 + 27))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((5448 - 3361) == (1297 + 790)) and (v5 == (1167 - (645 + 522)))) then
			v6 = v0[v4];
			if (not v6 or ((5194 - (1010 + 780)) > (4501 + 2))) then
				return v1(v4, ...);
			end
			v5 = 4 - 3;
		end
	end
end
v0["Epix_DeathKnight_Unholy.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Pet;
	local v16 = v13.Target;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = v10.Macro;
	local v21 = v10.Commons.Everyone.num;
	local v22 = v10.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = v10.Cast;
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
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (1836 - (1045 + 791));
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (505 - (351 + 154));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (1574 - (1281 + 293));
		v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (266 - (28 + 238));
		v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 - 0);
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
	local v61 = v17.DeathKnight.Unholy;
	local v62 = v19.DeathKnight.Unholy;
	local v63 = v20.DeathKnight.Unholy;
	local v64 = {v62.AlgetharPuzzleBox:ID(),v62.IrideusFragment:ID(),v62.VialofAnimatedBlood:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[6 + 7] and v19(v65[44 - 31])) or v19(0 + 0);
	local v67 = (v65[484 - (381 + 89)] and v19(v65[13 + 1])) or v19(0 + 0);
	local v68;
	local v69;
	local v70 = v10.Commons.Everyone;
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
	local v90 = 19032 - 7921;
	local v91 = 12267 - (1074 + 82);
	local v92 = v10.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (0 + 0)) or ((13797 - 10291) <= (3035 - (1668 + 58)))) then
				v65 = v14:GetEquipment();
				v66 = (v65[639 - (512 + 114)] and v19(v65[33 - 20])) or v19(0 - 0);
				v147 = 3 - 2;
			end
			if (((1375 + 1580) == (554 + 2401)) and (v147 == (1 + 0))) then
				v67 = (v65[47 - 33] and v19(v65[2008 - (109 + 1885)])) or v19(1469 - (1269 + 200));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v148 = 0 - 0;
		while true do
			if ((v148 == (815 - (98 + 717))) or ((3729 - (802 + 24)) == (2578 - 1083))) then
				v90 = 14032 - 2921;
				v91 = 1641 + 9470;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
		v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
		v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v14:HealthPercentage() < v43) or ((v14:HealthPercentage() < v44) and v14:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v149)
		local v150 = 0 + 0;
		for v175, v176 in pairs(v149) do
			if (((747 + 3799) >= (491 + 1784)) and v176:DebuffDown(v61.VirulentPlagueDebuff)) then
				v150 = v150 + (2 - 1);
			end
		end
		return v150;
	end
	local function v101(v151)
		local v152 = 0 - 0;
		local v153;
		while true do
			if (((293 + 526) >= (9 + 13)) and (v152 == (1 + 0))) then
				return v10.FightRemains(v153);
			end
			if (((2300 + 862) == (1477 + 1685)) and (v152 == (1433 - (797 + 636)))) then
				v153 = {};
				for v181 in pairs(v151) do
					if (not v13:IsInBossList(v151[v181]['UnitNPCID']) or ((11502 - 9133) > (6048 - (1427 + 192)))) then
						v30(v153, v151[v181]);
					end
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v102(v154)
		return (v154:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v155)
		return (v155:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v156)
		return (v61.BurstingSores:IsAvailable() and v156:DebuffUp(v61.FesteringWoundDebuff) and ((v14:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v14:Rune() < (6 - 3))) or (v14:BuffUp(v61.DeathAndDecayBuff) and (v14:Rune() == (0 + 0))))) or (not v61.BurstingSores:IsAvailable() and (v156:DebuffStack(v61.FesteringWoundDebuff) >= (2 + 2))) or (v14:HasTier(357 - (192 + 134), 1278 - (316 + 960)) and v156:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v157)
		return v157:DebuffStack(v61.FesteringWoundDebuff) >= (3 + 1);
	end
	local function v106(v158)
		return v158:DebuffStack(v61.FesteringWoundDebuff) < (4 + 0);
	end
	local function v107(v159)
		return v159:DebuffStack(v61.FesteringWoundDebuff) < (4 + 0);
	end
	local function v108(v160)
		return v160:DebuffStack(v61.FesteringWoundDebuff) >= (15 - 11);
	end
	local function v109(v161)
		return ((v161:TimeToX(586 - (83 + 468)) < (1811 - (1202 + 604))) or (v161:HealthPercentage() <= (163 - 128))) and (v161:TimeToDie() > (v161:DebuffRemains(v61.SoulReaper) + (7 - 2)));
	end
	local function v110(v162)
		return (v162:DebuffStack(v61.FesteringWoundDebuff) <= (5 - 3)) or v15:BuffUp(v61.DarkTransformation);
	end
	local function v111(v163)
		return (v163:DebuffStack(v61.FesteringWoundDebuff) >= (329 - (45 + 280))) and (v87:CooldownRemains() < (3 + 0));
	end
	local function v112(v164)
		return v164:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v165)
		return (v165:TimeToDie() > v165:DebuffRemains(v61.VirulentPlagueDebuff)) and (v165:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v165:DebuffRefreshable(v61.FrostFeverDebuff) or v165:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((6 + 9) / ((v21(v61.Superstrain:IsAvailable()) * (2 + 1)) + (v21(v61.Plaguebringer:IsAvailable()) * (1 + 1)) + (v21(v61.EbonFever:IsAvailable()) * (3 - 1)))))));
	end
	local function v114()
		local v166 = 1911 - (340 + 1571);
		while true do
			if (((1616 + 2479) >= (4955 - (1733 + 39))) and (v166 == (0 - 0))) then
				if ((v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive() or not v15:IsActive())) or ((4745 - (125 + 909)) < (2956 - (1096 + 852)))) then
					if (v10.Press(v61.RaiseDead, nil) or ((471 + 578) <= (1293 - 387))) then
						return "raise_dead precombat 2 displaystyle";
					end
				end
				if (((4378 + 135) > (3238 - (409 + 103))) and v61.ArmyoftheDead:IsReady() and v28) then
					if (v10.Press(v61.ArmyoftheDead, nil) or ((1717 - (46 + 190)) >= (2753 - (51 + 44)))) then
						return "army_of_the_dead precombat 4";
					end
				end
				v166 = 1 + 0;
			end
			if ((v166 == (1318 - (1114 + 203))) or ((3946 - (228 + 498)) == (296 + 1068))) then
				if (v61.Outbreak:IsReady() or ((583 + 471) > (4055 - (174 + 489)))) then
					if (v10.Press(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or ((1760 - 1084) >= (3547 - (830 + 1075)))) then
						return "outbreak precombat 6";
					end
				end
				if (((4660 - (303 + 221)) > (3666 - (231 + 1038))) and v61.FesteringStrike:IsReady()) then
					if (v10.Press(v61.FesteringStrike, nil, nil) or ((3612 + 722) == (5407 - (171 + 991)))) then
						return "festering_strike precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v115()
		v68 = v70.HandleTopTrinket(v64, v28, 164 - 124, nil);
		if (v68 or ((11481 - 7205) <= (7563 - 4532))) then
			return v68;
		end
		v68 = v70.HandleBottomTrinket(v64, v28, 33 + 7, nil);
		if (v68 or ((16762 - 11980) <= (3458 - 2259))) then
			return v68;
		end
	end
	local function v116()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (0 - 0)) or ((6112 - (111 + 1137)) < (2060 - (91 + 67)))) then
				if (((14402 - 9563) >= (924 + 2776)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (533 - (423 + 100))))) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(1 + 29)) or ((2976 - 1901) > (1000 + 918))) then
						return "epidemic aoe 2";
					end
				end
				if (((1167 - (326 + 445)) <= (16600 - 12796)) and v86:IsReady() and v76) then
					if (v70.CastTargetIf(v86, v93, "max", v102, nil, not v16:IsSpellInRange(v86)) or ((9287 - 5118) == (5104 - 2917))) then
						return "wound_spender aoe 4";
					end
				end
				v167 = 712 - (530 + 181);
			end
			if (((2287 - (614 + 267)) == (1438 - (19 + 13))) and (v167 == (1 - 0))) then
				if (((3567 - 2036) < (12200 - 7929)) and v61.FesteringStrike:IsReady() and not v76) then
					if (((165 + 470) == (1116 - 481)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil)) then
						return "festering_strike aoe 6";
					end
				end
				if (((6994 - 3621) <= (5368 - (1293 + 519))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((6714 - 3423) < (8563 - 5283))) then
						return "death_coil aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v168 = 0 - 0;
		while true do
			if (((18912 - 14526) >= (2056 - 1183)) and ((1 + 0) == v168)) then
				if (((188 + 733) <= (2560 - 1458)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (3 + 7)))) then
					if (((1564 + 3142) >= (602 + 361)) and v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(1126 - (709 + 387)))) then
						return "epidemic aoe_burst 6";
					end
				end
				if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((2818 - (673 + 1185)) <= (2540 - 1664))) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((6634 - 4568) == (1532 - 600))) then
						return "death_coil aoe_burst 8";
					end
				end
				v168 = 2 + 0;
			end
			if (((3606 + 1219) < (6537 - 1694)) and (v168 == (1 + 1))) then
				if (v86:IsReady() or ((7729 - 3852) >= (8906 - 4369))) then
					if (v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86)) or ((6195 - (446 + 1434)) < (3009 - (1040 + 243)))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if ((v168 == (0 - 0)) or ((5526 - (559 + 1288)) < (2556 - (609 + 1322)))) then
				if ((v61.Epidemic:IsReady() and (not v61.BurstingSores:IsAvailable() or (v14:Rune() < (455 - (13 + 441))) or (v61.BurstingSores:IsAvailable() and (v89 == (0 - 0)))) and not v77 and ((v94 >= (15 - 9)) or (v14:RunicPowerDeficit() < (149 - 119)) or (v14:BuffStack(v61.FestermightBuff) == (1 + 19)))) or ((16797 - 12172) < (225 + 407))) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(14 + 16)) or ((246 - 163) > (975 + 805))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (((1003 - 457) <= (713 + 364)) and v86:IsReady()) then
					if (v70.CastTargetIf(v86, v93, "max", v102, v112, not v16:IsSpellInRange(v86)) or ((554 + 442) > (3091 + 1210))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v168 = 1 + 0;
			end
		end
	end
	local function v118()
		if (((3983 + 87) > (1120 - (153 + 280))) and v61.VileContagion:IsReady() and (v87:CooldownRemains() < (8 - 5))) then
			if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v16:IsSpellInRange(v61.VileContagion)) or ((589 + 67) >= (1315 + 2015))) then
				return "vile_contagion aoe_cooldowns 2";
			end
		end
		if (v61.SummonGargoyle:IsReady() or ((1305 + 1187) <= (305 + 30))) then
			if (((3132 + 1190) >= (3900 - 1338)) and v10.Press(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle aoe_cooldowns 4";
			end
		end
		if ((v61.AbominationLimb:IsCastable() and ((v14:Rune() < (2 + 0)) or (v89 > (677 - (89 + 578))) or not v61.Festermight:IsAvailable() or (v14:BuffUp(v61.FestermightBuff) and (v14:BuffRemains(v61.FestermightBuff) < (9 + 3))))) or ((7561 - 3924) >= (4819 - (572 + 477)))) then
			if (v10.Press(v61.AbominationLimb, nil, not v16:IsInRange(3 + 17)) or ((1428 + 951) > (547 + 4031))) then
				return "abomination_limb aoe_cooldowns 6";
			end
		end
		if (v61.Apocalypse:IsReady() or ((569 - (84 + 2)) > (1224 - 481))) then
			if (((1768 + 686) > (1420 - (497 + 345))) and v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104)) then
				return "apocalypse aoe_cooldowns 8";
			end
		end
		if (((24 + 906) < (754 + 3704)) and v61.UnholyAssault:IsCastable()) then
			if (((1995 - (605 + 728)) <= (694 + 278)) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, v57)) then
				return "unholy_assault aoe_cooldowns 10";
			end
		end
		if (((9715 - 5345) == (201 + 4169)) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
			if (v10.Press(v61.RaiseDead, nil) or ((17606 - 12844) <= (777 + 84))) then
				return "raise_dead aoe_cooldowns 12 displaystyle";
			end
		end
		if ((v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (27 - 17)) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) or ((1067 + 345) == (4753 - (457 + 32)))) then
			if (v10.Press(v61.DarkTransformation, v54) or ((1345 + 1823) < (3555 - (832 + 570)))) then
				return "dark_transformation aoe_cooldowns 14";
			end
		end
		if ((v61.EmpowerRuneWeapon:IsCastable() and (v15:BuffUp(v61.DarkTransformation))) or ((4688 + 288) < (348 + 984))) then
			if (((16377 - 11749) == (2230 + 2398)) and v10.Press(v61.EmpowerRuneWeapon, v49)) then
				return "empower_rune_weapon aoe_cooldowns 16";
			end
		end
		if ((v61.SacrificialPact:IsReady() and ((v15:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (802 - (588 + 208)))) or (v91 < v14:GCD()))) or ((145 - 91) == (2195 - (884 + 916)))) then
			if (((171 - 89) == (48 + 34)) and v10.Press(v61.SacrificialPact, v50)) then
				return "sacrificial_pact aoe_cooldowns 18";
			end
		end
	end
	local function v119()
		if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (661 - (232 + 421))))) or ((2470 - (1569 + 320)) < (70 + 212))) then
			if (v10.Press(v88, v48) or ((876 + 3733) < (8407 - 5912))) then
				return "any_dnd aoe_setup 2";
			end
		end
		if (((1757 - (316 + 289)) == (3015 - 1863)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
			if (((88 + 1808) <= (4875 - (666 + 787))) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil)) then
				return "festering_strike aoe_setup 4";
			end
		end
		if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (435 - (360 + 65))))) or ((926 + 64) > (1874 - (79 + 175)))) then
			if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(47 - 17)) or ((685 + 192) > (14391 - 9696))) then
				return "epidemic aoe_setup 6";
			end
		end
		if (((5182 - 2491) >= (2750 - (503 + 396))) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil) or ((3166 - (92 + 89)) >= (9419 - 4563))) then
				return "festering_strike aoe_setup 8";
			end
		end
		if (((2193 + 2083) >= (708 + 487)) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
			if (((12656 - 9424) <= (642 + 4048)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106)) then
				return "festering_strike aoe_setup 10";
			end
		end
		if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((2042 - 1146) >= (2745 + 401))) then
			if (((1463 + 1598) >= (9008 - 6050)) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil aoe_setup 12";
			end
		end
	end
	local function v120()
		if (((398 + 2789) >= (981 - 337)) and v61.SummonGargoyle:IsCastable() and (v14:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) then
			if (((1888 - (485 + 759)) <= (1628 - 924)) and v10.Press(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle cooldowns 2";
			end
		end
		if (((2147 - (442 + 747)) > (2082 - (832 + 303))) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
			if (((5438 - (88 + 858)) >= (809 + 1845)) and v10.Press(v61.RaiseDead, nil)) then
				return "raise_dead cooldowns 4 displaystyle";
			end
		end
		if (((2849 + 593) >= (62 + 1441)) and v61.DarkTransformation:IsCastable() and (v61.Apocalypse:CooldownRemains() < (794 - (766 + 23)))) then
			if (v10.Press(v61.DarkTransformation, v54) or ((15649 - 12479) <= (2002 - 538))) then
				return "dark_transformation cooldowns 6";
			end
		end
		if ((v61.Apocalypse:IsReady() and v78) or ((12638 - 7841) == (14892 - 10504))) then
			if (((1624 - (1036 + 37)) <= (483 + 198)) and v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, v53)) then
				return "apocalypse cooldowns 8";
			end
		end
		if (((6381 - 3104) > (321 + 86)) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (1503 - (641 + 839)))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v15:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v15:BuffUp(v61.DarkTransformation)))) or (v91 <= (934 - (910 + 3))))) then
			if (((11968 - 7273) >= (3099 - (1466 + 218))) and v10.Press(v61.EmpowerRuneWeapon, v49)) then
				return "empower_rune_weapon cooldowns 10";
			end
		end
		if ((v61.AbominationLimb:IsCastable() and (v14:Rune() < (2 + 1)) and v78) or ((4360 - (556 + 592)) <= (336 + 608))) then
			if (v10.Press(v61.AbominationLimb, nil) or ((3904 - (329 + 479)) <= (2652 - (174 + 680)))) then
				return "abomination_limb cooldowns 12";
			end
		end
		if (((12153 - 8616) == (7331 - 3794)) and v61.UnholyAssault:IsReady() and v78) then
			if (((2740 + 1097) >= (2309 - (396 + 343))) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, v57)) then
				return "unholy_assault cooldowns 14";
			end
		end
		if ((v61.SoulReaper:IsReady() and (v94 == (1 + 0)) and ((v16:TimeToX(1512 - (29 + 1448)) < (1394 - (135 + 1254))) or (v16:HealthPercentage() <= (131 - 96))) and (v16:TimeToDie() > (23 - 18))) or ((1966 + 984) == (5339 - (389 + 1138)))) then
			if (((5297 - (102 + 472)) >= (2188 + 130)) and v10.Press(v61.SoulReaper, nil, nil, not v16:IsSpellInRange(v61.SoulReaper))) then
				return "soul_reaper cooldowns 16";
			end
		end
		if ((v61.SoulReaper:IsReady() and (v94 >= (2 + 0))) or ((1891 + 136) > (4397 - (320 + 1225)))) then
			if (v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v16:IsSpellInRange(v61.SoulReaper)) or ((2021 - 885) > (2642 + 1675))) then
				return "soul_reaper cooldowns 18";
			end
		end
	end
	local function v121()
		if (((6212 - (157 + 1307)) == (6607 - (821 + 1038))) and v61.Apocalypse:IsReady() and (v89 >= (9 - 5)) and ((v14:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (3 + 20))) or not v61.CommanderoftheDead:IsAvailable())) then
			if (((6635 - 2899) <= (1764 + 2976)) and v10.Press(v61.Apocalypse, v53, nil)) then
				return "apocalypse garg_setup 2";
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v28 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (7 - 4)) or v14:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (1036 - (834 + 192)))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) or ((216 + 3174) <= (786 + 2274))) then
			if (v10.Press(v61.ArmyoftheDead, nil) or ((22 + 977) > (4171 - 1478))) then
				return "army_of_the_dead garg_setup 4";
			end
		end
		if (((767 - (300 + 4)) < (161 + 440)) and v61.SoulReaper:IsReady() and (v94 == (2 - 1)) and ((v16:TimeToX(397 - (112 + 250)) < (2 + 3)) or (v16:HealthPercentage() <= (87 - 52))) and (v16:TimeToDie() > (3 + 2))) then
			if (v10.Press(v61.SoulReaper, nil, nil) or ((1129 + 1054) < (514 + 173))) then
				return "soul_reaper garg_setup 6";
			end
		end
		if (((2256 + 2293) == (3380 + 1169)) and v61.SummonGargoyle:IsCastable() and v28 and (v14:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() >= (1454 - (1001 + 413)))))) then
			if (((10418 - 5746) == (5554 - (244 + 638))) and v10.Press(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle garg_setup 8";
			end
		end
		if ((v28 and v84 and (v85 <= (716 - (627 + 66)))) or ((10929 - 7261) < (997 - (512 + 90)))) then
			if (v61.EmpowerRuneWeapon:IsCastable() or ((6072 - (1665 + 241)) == (1172 - (373 + 344)))) then
				if (v10.Press(v61.EmpowerRuneWeapon, v49) or ((2007 + 2442) == (705 + 1958))) then
					return "empower_rune_weapon garg_setup 10";
				end
			end
			if (v61.UnholyAssault:IsCastable() or ((11281 - 7004) < (5057 - 2068))) then
				if (v10.Press(v61.UnholyAssault, v57, nil) or ((1969 - (35 + 1064)) >= (3019 + 1130))) then
					return "unholy_assault garg_setup 12";
				end
			end
		end
		if (((4732 - 2520) < (13 + 3170)) and v61.DarkTransformation:IsCastable() and ((v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() > (1276 - (298 + 938)))) or not v61.CommanderoftheDead:IsAvailable())) then
			if (((5905 - (233 + 1026)) > (4658 - (636 + 1030))) and v10.Press(v61.DarkTransformation, v54)) then
				return "dark_transformation garg_setup 16";
			end
		end
		if (((734 + 700) < (3034 + 72)) and v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 + 0))) then
			if (((54 + 732) < (3244 - (55 + 166))) and v10.Press(v88, v48)) then
				return "any_dnd garg_setup 18";
			end
		end
		if ((v61.FesteringStrike:IsReady() and ((v89 == (0 + 0)) or not v61.Apocalypse:IsAvailable() or ((v14:RunicPower() < (5 + 35)) and not v84))) or ((9325 - 6883) < (371 - (36 + 261)))) then
			if (((7930 - 3395) == (5903 - (34 + 1334))) and v10.Press(v61.FesteringStrike, nil, nil)) then
				return "festering_strike garg_setup 20";
			end
		end
		if ((v61.DeathCoil:IsReady() and (v14:Rune() <= (1 + 0))) or ((2338 + 671) <= (3388 - (1035 + 248)))) then
			if (((1851 - (20 + 1)) < (1912 + 1757)) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil garg_setup 22";
			end
		end
	end
	local function v122()
		local v169 = 319 - (134 + 185);
		while true do
			if ((v169 == (1136 - (549 + 584))) or ((2115 - (314 + 371)) >= (12399 - 8787))) then
				if (((3651 - (478 + 490)) >= (1304 + 1156)) and v61.Outbreak:IsReady()) then
					if (v70.CastCycle(v61.Outbreak, v93, v113, not v16:IsSpellInRange(v61.Outbreak)) or ((2976 - (786 + 386)) >= (10607 - 7332))) then
						return "outbreak high_prio_actions 14";
					end
				end
				break;
			end
			if (((1381 - (1055 + 324)) == v169) or ((2757 - (1093 + 247)) > (3225 + 404))) then
				if (((505 + 4290) > (1596 - 1194)) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (9 - 6))) or (v94 >= (8 - 5))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v14:BuffRemains(v61.PlaguebringerBuff) < v14:GCD())) then
					if (((12094 - 7281) > (1269 + 2296)) and v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86))) then
						return "wound_spender high_prio_actions 10";
					end
				end
				if (((15070 - 11158) == (13483 - 9571)) and v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (16 + 5)))) then
					if (((7214 - 4393) <= (5512 - (364 + 324))) and v10.Press(v61.UnholyBlight, v58, nil)) then
						return "unholy_blight high_prio_actions 12";
					end
				end
				v169 = 7 - 4;
			end
			if (((4170 - 2432) <= (728 + 1467)) and (v169 == (4 - 3))) then
				if (((65 - 24) <= (9165 - 6147)) and v61.DeathCoil:IsReady() and ((v94 <= (1271 - (1249 + 19))) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (5 + 0)) and (v14:BuffRemains(v61.CommanderoftheDeadBuff) > (104 - 77))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) then
					if (((3231 - (686 + 400)) <= (3221 + 883)) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil high_prio_actions 6";
					end
				end
				if (((2918 - (73 + 156)) < (23 + 4822)) and v61.Epidemic:IsReady() and (v96 >= (815 - (721 + 90))) and ((v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (1 + 4))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(97 - 67)) or ((2792 - (224 + 246)) > (4247 - 1625))) then
						return "epidemic high_prio_actions 8";
					end
				end
				v169 = 3 - 1;
			end
			if ((v169 == (0 + 0)) or ((108 + 4426) == (1530 + 552))) then
				if (v45 or ((3123 - 1552) > (6212 - 4345))) then
					local v191 = 513 - (203 + 310);
					while true do
						if ((v191 == (1993 - (1238 + 755))) or ((186 + 2468) >= (4530 - (709 + 825)))) then
							if (((7330 - 3352) > (3064 - 960)) and v61.AntiMagicShell:IsCastable() and (v14:RunicPowerDeficit() > (904 - (196 + 668))) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (157 - 117)))) then
								if (((6203 - 3208) > (2374 - (171 + 662))) and v10.Press(v61.AntiMagicShell, v46)) then
									return "antimagic_shell ams_amz 2";
								end
							end
							if (((3342 - (4 + 89)) > (3339 - 2386)) and v61.AntiMagicZone:IsCastable() and (v14:RunicPowerDeficit() > (26 + 44)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) then
								if (v10.Press(v61.AntiMagicZone, v47) or ((14375 - 11102) > (1794 + 2779))) then
									return "antimagic_zone ams_amz 4";
								end
							end
							break;
						end
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v28 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (1488 - (35 + 1451)))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (1488 - (28 + 1425))))) or ((5144 - (941 + 1052)) < (1232 + 52))) then
					if (v10.Press(v61.ArmyoftheDead, nil) or ((3364 - (822 + 692)) == (2182 - 653))) then
						return "army_of_the_dead high_prio_actions 4";
					end
				end
				v169 = 1 + 0;
			end
		end
	end
	local function v123()
		if (((1118 - (45 + 252)) < (2101 + 22)) and v61.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (7 + 13)) and ((v61.SummonGargoyle:CooldownRemains() < v14:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v14:Rune() < (4 - 2)) and (v89 < (434 - (114 + 319)))))) then
			if (((1294 - 392) < (2979 - 654)) and v10.Press(v61.ArcaneTorrent, v52, nil)) then
				return "arcane_torrent racials 2";
			end
		end
		if (((547 + 311) <= (4412 - 1450)) and v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + (5 - 2)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (2023 - (556 + 1407)))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (1209 - (741 + 465))))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + (468 - (170 + 295))))) or ((v94 >= (2 + 0)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + 3 + 0)))) then
			if (v10.Press(v61.BloodFury, v52) or ((9714 - 5768) < (1068 + 220))) then
				return "blood_fury racials 4";
			end
		end
		if ((v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + 2 + 1) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (34 + 26))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (1233 - (957 + 273))))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + 1 + 2))) or ((v94 >= (1 + 1)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + (11 - 8))))) or ((8543 - 5301) == (1731 - 1164))) then
			if (v10.Press(v61.Berserking, v52) or ((4194 - 3347) >= (3043 - (389 + 1391)))) then
				return "berserking racials 6";
			end
		end
		if ((v61.LightsJudgment:IsCastable() and v14:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v14:BuffRemains(v61.FestermightBuff) < v16:TimeToDie()) or (v14:BuffRemains(v61.UnholyStrengthBuff) < v16:TimeToDie()))) or ((1414 + 839) == (193 + 1658))) then
			if (v10.Press(v61.LightsJudgment, v52, nil, not v16:IsSpellInRange(v61.LightsJudgment)) or ((4750 - 2663) > (3323 - (783 + 168)))) then
				return "lights_judgment racials 8";
			end
		end
		if ((v61.AncestralCall:IsCastable() and ((((60 - 42) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (60 + 0))) and ((v82 and (v83 <= (329 - (309 + 2)))) or (v80 and (v81 <= (55 - 37))) or ((v94 >= (1214 - (1090 + 122))) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (6 + 12)))) or ((14928 - 10483) < (2840 + 1309))) then
			if (v10.Press(v61.AncestralCall, v52) or ((2936 - (628 + 490)) == (16 + 69))) then
				return "ancestral_call racials 10";
			end
		end
		if (((1559 - 929) < (9720 - 7593)) and v61.ArcanePulse:IsCastable() and ((v94 >= (776 - (431 + 343))) or ((v14:Rune() <= (1 - 0)) and (v14:RunicPowerDeficit() >= (173 - 113))))) then
			if (v10.Press(v61.ArcanePulse, v52, nil) or ((1532 + 406) == (322 + 2192))) then
				return "arcane_pulse racials 12";
			end
		end
		if (((5950 - (556 + 1139)) >= (70 - (6 + 9))) and v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (31 + 29))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (172 - (28 + 141))))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 2 + 1))) or ((v94 >= (2 - 0)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + 3 + 0)))) then
			if (((4316 - (486 + 831)) > (3007 - 1851)) and v10.Press(v61.Fireblood, v52)) then
				return "fireblood racials 14";
			end
		end
		if (((8273 - 5923) > (219 + 936)) and v61.BagofTricks:IsCastable() and (v94 == (3 - 2)) and (v14:BuffUp(v61.UnholyStrengthBuff) or v10.FilteredFightRemains(v93, "<", 1268 - (668 + 595)))) then
			if (((3626 + 403) <= (979 + 3874)) and v10.Press(v61.BagofTricks, v52, nil, not v16:IsSpellInRange(v61.BagofTricks))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v124()
		if ((v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (27 - 17)))) or ((806 - (23 + 267)) > (5378 - (1129 + 815)))) then
			if (((4433 - (371 + 16)) >= (4783 - (1326 + 424))) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil st 2";
			end
		end
		if ((v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (18 - 8)))) or ((9935 - 7216) <= (1565 - (88 + 30)))) then
			if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(801 - (720 + 51))) or ((9195 - 5061) < (5702 - (421 + 1355)))) then
				return "epidemic st 4";
			end
		end
		if ((v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (2 - 0)) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (7 + 6))) or (v84 and (v85 > (1091 - (286 + 797)))) or (v82 and (v83 > (29 - 21))) or (not v76 and (v89 >= (6 - 2))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v15:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (440 - (397 + 42))))) or ((52 + 112) >= (3585 - (24 + 776)))) then
			if (v10.Press(v88, v48) or ((808 - 283) == (2894 - (222 + 563)))) then
				return "any_dnd st 6";
			end
		end
		if (((72 - 39) == (24 + 9)) and v86:IsReady() and (v76 or ((v94 >= (192 - (23 + 167))) and v14:BuffUp(v61.DeathAndDecayBuff)))) then
			if (((4852 - (690 + 1108)) <= (1449 + 2566)) and v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86))) then
				return "wound_spender st 8";
			end
		end
		if (((1544 + 327) < (4230 - (40 + 808))) and v61.FesteringStrike:IsReady() and not v76) then
			if (((213 + 1080) <= (8282 - 6116)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107)) then
				return "festering_strike st 10";
			end
		end
		if (v61.DeathCoil:IsReady() or ((2465 + 114) < (66 + 57))) then
			if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((464 + 382) >= (2939 - (47 + 524)))) then
				return "death_coil st 12";
			end
		end
		if ((v86:IsReady() and not v76) or ((2604 + 1408) <= (9179 - 5821))) then
			if (((2233 - 739) <= (6853 - 3848)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v16:IsSpellInRange(v86))) then
				return "wound_spender st 14";
			end
		end
	end
	local function v125()
		if (v33 or ((4837 - (1165 + 561)) == (64 + 2070))) then
			local v178 = v115();
			if (((7293 - 4938) == (899 + 1456)) and v178) then
				return v178;
			end
		end
	end
	local function v126()
		local v170 = 479 - (341 + 138);
		while true do
			if ((v170 == (1 + 0)) or ((1213 - 625) <= (758 - (89 + 237)))) then
				v74 = ((v61.Apocalypse:CooldownRemains() < (32 - 22)) and (v89 <= (8 - 4)) and (v61.UnholyAssault:CooldownRemains() > (891 - (581 + 300))) and (1227 - (855 + 365))) or (4 - 2);
				if (((1567 + 3230) >= (5130 - (1030 + 205))) and not v84 and v61.Festermight:IsAvailable() and v14:BuffUp(v61.FestermightBuff) and ((v14:BuffRemains(v61.FestermightBuff) / ((5 + 0) * v14:GCD())) >= (1 + 0))) then
					v75 = v89 >= (287 - (156 + 130));
				else
					v75 = v89 >= ((6 - 3) - v21(v61.InfectedClaws:IsAvailable()));
				end
				v170 = 2 - 0;
			end
			if (((7325 - 3748) == (943 + 2634)) and (v170 == (2 + 0))) then
				v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (70 - (10 + 59))) and (v61.UnholyAssault:CooldownRemains() < (6 + 14)) and v61.UnholyAssault:IsAvailable() and v78) or (v16:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (4 - 3))) or (v89 > (1167 - (671 + 492))) or (v14:HasTier(25 + 6, 1219 - (369 + 846)) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 + 0))))) or ((v91 < (5 + 0)) and (v89 >= (1946 - (1036 + 909))));
				v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (3 + 0)) and (v14:RunicPower() < (100 - 40)) and not v78;
				v170 = 206 - (11 + 192);
			end
			if (((1918 + 1876) > (3868 - (135 + 40))) and (v170 == (6 - 3))) then
				v78 = (v94 == (1 + 0)) or not v27;
				v79 = (v94 >= (4 - 2)) and v27;
				v170 = 5 - 1;
			end
			if ((v170 == (180 - (50 + 126))) or ((3550 - 2275) == (908 + 3192))) then
				v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v16:DebuffDown(v61.RottenTouchDebuff)) or (v14:RunicPowerDeficit() < (1433 - (1233 + 180)))) and (not v14:HasTier(1000 - (522 + 447), 1425 - (107 + 1314)) or (v14:HasTier(15 + 16, 11 - 7) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v14:RunicPowerDeficit() < (9 + 11)) or (v14:Rune() < (5 - 2))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (7 - 5)) or v61.CoilofDevastation:IsAvailable())) or (v14:Rune() < (1913 - (716 + 1194))) or v84 or v14:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (1 + 9)) and (v89 > (1 + 2))) or (not v76 and (v89 >= (507 - (74 + 429)))));
				break;
			end
			if ((v170 == (0 - 0)) or ((789 + 802) >= (8194 - 4614))) then
				v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (3 + 0))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (12 - 8))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (4 - 2)));
				v71 = (v94 >= (436 - (279 + 154))) or ((v61.SummonGargoyle:CooldownRemains() > (779 - (454 + 324))) and ((v61.Apocalypse:CooldownRemains() > (1 + 0)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v10.CombatTime() > (37 - (12 + 5)));
				v170 = 1 + 0;
			end
		end
	end
	local function v127()
		v60();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v69 = not v99();
		v93 = v14:GetEnemiesInMeleeRange(20 - 12, v61.FesteringStrike);
		v95 = v16:GetEnemiesInSplashRange(4 + 6);
		if (((2076 - (277 + 816)) <= (7725 - 5917)) and v27) then
			v94 = #v93;
			v96 = v16:GetEnemiesInSplashRangeCount(1193 - (1058 + 125));
		else
			local v179 = 0 + 0;
			while true do
				if ((v179 == (975 - (815 + 160))) or ((9224 - 7074) <= (2841 - 1644))) then
					v94 = 1 + 0;
					v96 = 2 - 1;
					break;
				end
			end
		end
		if (((5667 - (41 + 1857)) >= (3066 - (1222 + 671))) and (v70.TargetIsValid() or v14:AffectingCombat())) then
			v90 = v10.BossFightRemains();
			v91 = v90;
			if (((3837 - 2352) == (2134 - 649)) and (v91 == (12293 - (229 + 953)))) then
				v91 = v10.FightRemains(v93, false);
			end
			v97 = v100(v95);
			v80 = v61.Apocalypse:TimeSinceLastCast() <= (1789 - (1111 + 663));
			v81 = (v80 and ((1594 - (874 + 705)) - v61.Apocalypse:TimeSinceLastCast())) or (0 + 0);
			v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (21 + 9);
			v83 = (v82 and ((62 - 32) - v61.ArmyoftheDead:TimeSinceLastCast())) or (0 + 0);
			v84 = v92:GargActive();
			v85 = v92:GargRemains();
			v89 = v16:DebuffStack(v61.FesteringWoundDebuff);
		end
		if (v70.TargetIsValid() or ((3994 - (642 + 37)) <= (635 + 2147))) then
			if (not v14:AffectingCombat() or ((141 + 735) >= (7441 - 4477))) then
				local v182 = v114();
				if (v182 or ((2686 - (233 + 221)) > (5773 - 3276))) then
					return v182;
				end
			end
			if ((v61.DeathStrike:IsReady() and not v69) or ((1858 + 252) <= (1873 - (718 + 823)))) then
				if (((2320 + 1366) > (3977 - (266 + 539))) and v10.Press(v61.DeathStrike)) then
					return "death_strike low hp or proc";
				end
			end
			if ((v94 == (0 - 0)) or ((5699 - (636 + 589)) < (1946 - 1126))) then
				if (((8825 - 4546) >= (2284 + 598)) and v61.Outbreak:IsReady() and (v97 > (0 + 0))) then
					if (v10.Press(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or ((3044 - (657 + 358)) >= (9322 - 5801))) then
						return "outbreak out_of_range";
					end
				end
				if ((v61.Epidemic:IsReady() and v27 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (2 - 1)) and not v77) or ((3224 - (1151 + 36)) >= (4483 + 159))) then
					if (((453 + 1267) < (13313 - 8855)) and v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(1862 - (1552 + 280)))) then
						return "epidemic out_of_range";
					end
				end
				if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (836 - (64 + 770))) and not v77) or ((297 + 139) > (6857 - 3836))) then
					if (((127 + 586) <= (2090 - (157 + 1086))) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil out_of_range";
					end
				end
			end
			v126();
			local v180 = v122();
			if (((4311 - 2157) <= (17654 - 13623)) and v180) then
				return v180;
			end
			if (((7078 - 2463) == (6298 - 1683)) and v33) then
				local v183 = v125();
				if (v183 or ((4609 - (599 + 220)) == (995 - 495))) then
					return v183;
				end
			end
			if (((2020 - (1813 + 118)) < (162 + 59)) and v28 and not v71) then
				local v184 = v121();
				if (((3271 - (841 + 376)) >= (1990 - 569)) and v184) then
					return v184;
				end
			end
			if (((161 + 531) < (8346 - 5288)) and v28 and v78) then
				local v185 = v120();
				if (v185 or ((4113 - (464 + 395)) == (4247 - 2592))) then
					return v185;
				end
			end
			if ((v27 and v28 and v79) or ((623 + 673) == (5747 - (467 + 370)))) then
				local v186 = v118();
				if (((6959 - 3591) == (2473 + 895)) and v186) then
					return v186;
				end
			end
			if (((9060 - 6417) < (596 + 3219)) and v28) then
				local v187 = v123();
				if (((4450 - 2537) > (1013 - (150 + 370))) and v187) then
					return v187;
				end
			end
			if (((6037 - (74 + 1208)) > (8431 - 5003)) and v27) then
				local v188 = 0 - 0;
				while true do
					if (((983 + 398) <= (2759 - (14 + 376))) and (v188 == (1 - 0))) then
						if (((v94 >= (3 + 1)) and (((v87:CooldownRemains() > (9 + 1)) and v14:BuffDown(v61.DeathAndDecayBuff)) or not v79)) or ((4619 + 224) == (11966 - 7882))) then
							local v192 = v116();
							if (((3513 + 1156) > (441 - (23 + 55))) and v192) then
								return v192;
							end
						end
						break;
					end
					if ((v188 == (0 - 0)) or ((1253 + 624) >= (2818 + 320))) then
						if (((7352 - 2610) >= (1141 + 2485)) and v79 and (v87:CooldownRemains() < (911 - (652 + 249))) and v14:BuffDown(v61.DeathAndDecayBuff)) then
							local v193 = v119();
							if (v193 or ((12149 - 7609) == (2784 - (708 + 1160)))) then
								return v193;
							end
						end
						if (((v94 >= (10 - 6)) and v14:BuffUp(v61.DeathAndDecayBuff)) or ((2107 - 951) > (4372 - (10 + 17)))) then
							local v194 = v117();
							if (((503 + 1734) < (5981 - (1400 + 332))) and v194) then
								return v194;
							end
						end
						v188 = 1 - 0;
					end
				end
			end
			if ((v94 <= (1911 - (242 + 1666))) or ((1149 + 1534) < (9 + 14))) then
				local v189 = 0 + 0;
				local v190;
				while true do
					if (((1637 - (850 + 90)) <= (1446 - 620)) and (v189 == (1390 - (360 + 1030)))) then
						v190 = v124();
						if (((978 + 127) <= (3318 - 2142)) and v190) then
							return v190;
						end
						break;
					end
				end
			end
			if (((4648 - 1269) <= (5473 - (909 + 752))) and v61.FesteringStrike:IsReady()) then
				if (v10.Press(v61.FesteringStrike, nil, nil) or ((2011 - (109 + 1114)) >= (2958 - 1342))) then
					return "festering_strike precombat 8";
				end
			end
		end
	end
	local function v128()
		local v174 = 0 + 0;
		while true do
			if (((2096 - (6 + 236)) <= (2129 + 1250)) and (v174 == (1 + 0))) then
				v10.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
			if (((10727 - 6178) == (7945 - 3396)) and (v174 == (1133 - (1076 + 57)))) then
				v61.VirulentPlagueDebuff:RegisterAuraTracking();
				v61.FesteringWoundDebuff:RegisterAuraTracking();
				v174 = 1 + 0;
			end
		end
	end
	v10.SetAPL(941 - (579 + 110), v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

