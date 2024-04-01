local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1300 - 624) == (644 + 32)) and not v5) then
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
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (1162 - (171 + 991));
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 + 0);
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
	local v61 = v16.DeathKnight.Unholy;
	local v62 = v18.DeathKnight.Unholy;
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {};
	local v65 = v13:GetEquipment();
	local v66 = (v65[37 - 24] and v18(v65[20 - 7])) or v18(0 - 0);
	local v67 = (v65[1262 - (111 + 1137)] and v18(v65[172 - (91 + 67)])) or v18(0 - 0);
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
	local v90 = 2773 + 8338;
	local v91 = 11634 - (423 + 100);
	local v92 = v9.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		local v147 = 0 - 0;
		while true do
			if (((9213 - 5077) > (5595 - 3198)) and (v147 == (711 - (530 + 181)))) then
				v65 = v13:GetEquipment();
				v66 = (v65[894 - (614 + 267)] and v18(v65[45 - (19 + 13)])) or v18(0 - 0);
				v147 = 2 - 1;
			end
			if ((v147 == (2 - 1)) or ((1126 + 3208) == (7465 - 3220))) then
				v67 = (v65[28 - 14] and v18(v65[1826 - (1293 + 519)])) or v18(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v90 = 29010 - 17899;
		v91 = 21247 - 10136;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
		v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
		v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v13:HealthPercentage() < v43) or ((v13:HealthPercentage() < v44) and v13:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v148)
		local v149 = 0 - 0;
		for v176, v177 in pairs(v148) do
			if (v177:DebuffDown(v61.VirulentPlagueDebuff) or ((10072 - 5796) <= (1606 + 1425))) then
				v149 = v149 + 1 + 0;
			end
		end
		return v149;
	end
	local function v101(v150)
		local v151 = 0 - 0;
		local v152;
		while true do
			if (((1 + 0) == v151) or ((1589 + 3193) <= (750 + 449))) then
				return v9.FightRemains(v152);
			end
			if ((v151 == (1096 - (709 + 387))) or ((6722 - (673 + 1185)) < (5515 - 3613))) then
				v152 = {};
				for v183 in pairs(v150) do
					if (((15538 - 10699) >= (6087 - 2387)) and not v12:IsInBossList(v150[v183]['UnitNPCID'])) then
						v30(v152, v150[v183]);
					end
				end
				v151 = 1 + 0;
			end
		end
	end
	local function v102(v153)
		return (v153:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v154)
		return (v154:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v155)
		return (v61.BurstingSores:IsAvailable() and v155:DebuffUp(v61.FesteringWoundDebuff) and ((v13:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v13:Rune() < (3 + 0))) or (v13:BuffUp(v61.DeathAndDecayBuff) and (v13:Rune() == (0 - 0))))) or (not v61.BurstingSores:IsAvailable() and (v155:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 3))) or (v13:HasTier(61 - 30, 3 - 1) and v155:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v156)
		return v156:DebuffStack(v61.FesteringWoundDebuff) >= (1884 - (446 + 1434));
	end
	local function v106(v157)
		return v157:DebuffStack(v61.FesteringWoundDebuff) < (1287 - (1040 + 243));
	end
	local function v107(v158)
		return v158:DebuffStack(v61.FesteringWoundDebuff) < (11 - 7);
	end
	local function v108(v159)
		return v159:DebuffStack(v61.FesteringWoundDebuff) >= (1851 - (559 + 1288));
	end
	local function v109(v160)
		return ((v160:TimeToX(1966 - (609 + 1322)) < (459 - (13 + 441))) or (v160:HealthPercentage() <= (130 - 95))) and (v160:TimeToDie() > (v160:DebuffRemains(v61.SoulReaper) + (13 - 8)));
	end
	local function v110(v161)
		return (v161:DebuffStack(v61.FesteringWoundDebuff) <= (9 - 7)) or v14:BuffUp(v61.DarkTransformation);
	end
	local function v111(v162)
		return (v162:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 3)) and (v87:CooldownRemains() < (10 - 7));
	end
	local function v112(v163)
		return v163:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v164)
		return (v164:TimeToDie() > v164:DebuffRemains(v61.VirulentPlagueDebuff)) and (v164:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v164:DebuffRefreshable(v61.FrostFeverDebuff) or v164:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((7 + 8) / ((v22(v61.Superstrain:IsAvailable()) * (8 - 5)) + (v22(v61.Plaguebringer:IsAvailable()) * (2 + 0)) + (v22(v61.EbonFever:IsAvailable()) * (3 - 1)))))));
	end
	local function v114()
		if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive() or not v14:IsActive())) or ((711 + 364) > (1067 + 851))) then
			if (((285 + 111) <= (3195 + 609)) and v19(v61.RaiseDead, nil)) then
				return "raise_dead precombat 2 displaystyle";
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v29) or ((4079 + 90) == (2620 - (153 + 280)))) then
			if (((4059 - 2653) == (1263 + 143)) and v19(v61.ArmyoftheDead, nil)) then
				return "army_of_the_dead precombat 4";
			end
		end
		if (((605 + 926) < (2236 + 2035)) and v61.Outbreak:IsReady()) then
			if (((577 + 58) == (461 + 174)) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
				return "outbreak precombat 6";
			end
		end
		if (((5135 - 1762) <= (2198 + 1358)) and v61.FesteringStrike:IsReady()) then
			if (v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(672 - (89 + 578))) or ((2351 + 940) < (6819 - 3539))) then
				return "festering_strike precombat 8";
			end
		end
	end
	local function v115()
		v68 = v70.HandleTopTrinket(v64, v29, 1089 - (572 + 477), nil);
		if (((592 + 3794) >= (524 + 349)) and v68) then
			return v68;
		end
		v68 = v70.HandleBottomTrinket(v64, v29, 5 + 35, nil);
		if (((1007 - (84 + 2)) <= (1815 - 713)) and v68) then
			return v68;
		end
	end
	local function v116()
		if (((3391 + 1315) >= (1805 - (497 + 345))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (1 + 9)))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(6 + 24)) or ((2293 - (605 + 728)) <= (626 + 250))) then
				return "epidemic aoe 2";
			end
		end
		if ((v86:IsReady() and v76) or ((4593 - 2527) == (43 + 889))) then
			if (((17839 - 13014) < (4366 + 477)) and v70.CastTargetIf(v86, v93, "max", v102, nil, not v15:IsSpellInRange(v86))) then
				return "wound_spender aoe 4";
			end
		end
		if ((v61.FesteringStrike:IsReady() and not v76) or ((10741 - 6864) >= (3426 + 1111))) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v15:IsInMeleeRange(494 - (457 + 32))) or ((1831 + 2484) < (3128 - (832 + 570)))) then
				return "festering_strike aoe 6";
			end
		end
		if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((3466 + 213) < (163 + 462))) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((16367 - 11742) < (305 + 327))) then
				return "death_coil aoe 8";
			end
		end
	end
	local function v117()
		local v165 = 796 - (588 + 208);
		while true do
			if ((v165 == (0 - 0)) or ((1883 - (884 + 916)) > (3726 - 1946))) then
				if (((317 + 229) <= (1730 - (232 + 421))) and v61.Epidemic:IsReady() and ((v13:Rune() < (1890 - (1569 + 320))) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (0 + 0)))) and not v77 and ((v94 >= (2 + 4)) or (v13:RunicPowerDeficit() < (101 - 71)) or (v13:BuffStack(v61.FestermightBuff) == (625 - (316 + 289))))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(104 - 64)) or ((46 + 950) > (5754 - (666 + 787)))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (((4495 - (360 + 65)) > (643 + 44)) and v86:IsReady()) then
					if (v70.CastTargetIf(v86, v93, "max", v102, v112, not v15:IsSpellInRange(v86)) or ((910 - (79 + 175)) >= (5250 - 1920))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v165 = 1 + 0;
			end
			if ((v165 == (5 - 3)) or ((4798 - 2306) <= (1234 - (503 + 396)))) then
				if (((4503 - (92 + 89)) >= (4969 - 2407)) and v86:IsReady()) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((1866 + 1771) >= (2232 + 1538))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if ((v165 == (3 - 2)) or ((326 + 2053) > (10438 - 5860))) then
				if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (9 + 1)))) or ((231 + 252) > (2262 - 1519))) then
					if (((307 + 2147) > (881 - 303)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(1284 - (485 + 759)))) then
						return "epidemic aoe_burst 6";
					end
				end
				if (((2151 - 1221) < (5647 - (442 + 747))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (((1797 - (832 + 303)) <= (1918 - (88 + 858))) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil aoe_burst 8";
					end
				end
				v165 = 1 + 1;
			end
		end
	end
	local function v118()
		if (((3617 + 753) == (180 + 4190)) and v61.VileContagion:IsReady() and (v87:CooldownRemains() < (792 - (766 + 23)))) then
			if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v15:IsSpellInRange(v61.VileContagion)) or ((23508 - 18746) <= (1177 - 316))) then
				return "vile_contagion aoe_cooldowns 2";
			end
		end
		if (v61.SummonGargoyle:IsReady() or ((3719 - 2307) == (14472 - 10208))) then
			if (v19(v61.SummonGargoyle, v56) or ((4241 - (1036 + 37)) < (1527 + 626))) then
				return "summon_gargoyle aoe_cooldowns 4";
			end
		end
		if ((v61.AbominationLimb:IsCastable() and ((v13:Rune() < (3 - 1)) or (v89 > (8 + 2)) or not v61.Festermight:IsAvailable() or (v13:BuffUp(v61.FestermightBuff) and (v13:BuffRemains(v61.FestermightBuff) < (1492 - (641 + 839)))))) or ((5889 - (910 + 3)) < (3395 - 2063))) then
			if (((6312 - (1466 + 218)) == (2127 + 2501)) and v19(v61.AbominationLimb, nil, nil, not v15:IsInRange(1168 - (556 + 592)))) then
				return "abomination_limb aoe_cooldowns 6";
			end
		end
		if (v61.Apocalypse:IsReady() or ((20 + 34) == (1203 - (329 + 479)))) then
			if (((936 - (174 + 680)) == (281 - 199)) and v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v15:IsInMeleeRange(10 - 5))) then
				return "apocalypse aoe_cooldowns 8";
			end
		end
		if (v61.UnholyAssault:IsCastable() or ((415 + 166) < (1021 - (396 + 343)))) then
			if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v15:IsInMeleeRange(1 + 4), v57) or ((6086 - (29 + 1448)) < (3884 - (135 + 1254)))) then
				return "unholy_assault aoe_cooldowns 10";
			end
		end
		if (((4339 - 3187) == (5378 - 4226)) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
			if (((1264 + 632) <= (4949 - (389 + 1138))) and v19(v61.RaiseDead, nil)) then
				return "raise_dead aoe_cooldowns 12";
			end
		end
		if ((v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (584 - (102 + 472))) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) or ((935 + 55) > (899 + 721))) then
			if (v19(v61.DarkTransformation) or ((818 + 59) > (6240 - (320 + 1225)))) then
				return "dark_transformation aoe_cooldowns 14";
			end
		end
		if (((4790 - 2099) >= (1133 + 718)) and v61.EmpowerRuneWeapon:IsCastable() and (v14:BuffUp(v61.DarkTransformation))) then
			if (v19(v61.EmpowerRuneWeapon, v49) or ((4449 - (157 + 1307)) >= (6715 - (821 + 1038)))) then
				return "empower_rune_weapon aoe_cooldowns 16";
			end
		end
		if (((10668 - 6392) >= (131 + 1064)) and v61.SacrificialPact:IsReady() and ((v14:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (10 - 4))) or (v91 < v13:GCD()))) then
			if (((1203 + 2029) <= (11624 - 6934)) and v19(v61.SacrificialPact, v50)) then
				return "sacrificial_pact aoe_cooldowns 18";
			end
		end
	end
	local function v119()
		local v166 = 1026 - (834 + 192);
		while true do
			if ((v166 == (1 + 1)) or ((230 + 666) >= (68 + 3078))) then
				if (((4741 - 1680) >= (3262 - (300 + 4))) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
					if (((852 + 2335) >= (1685 - 1041)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v15:IsInMeleeRange(367 - (112 + 250)))) then
						return "festering_strike aoe_setup 10";
					end
				end
				if (((257 + 387) <= (1763 - 1059)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (((549 + 409) > (490 + 457)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil aoe_setup 12";
					end
				end
				break;
			end
			if (((3360 + 1132) >= (1316 + 1338)) and (v166 == (0 + 0))) then
				if (((4856 - (1001 + 413)) >= (3351 - 1848)) and v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (890 - (244 + 638)))) and not v13:IsMoving() and (v94 >= (694 - (627 + 66)))) then
					if (v19(v88, v48) or ((9445 - 6275) <= (2066 - (512 + 90)))) then
						return "any_dnd aoe_setup 2";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) or ((6703 - (1665 + 241)) == (5105 - (373 + 344)))) then
					if (((249 + 302) <= (181 + 500)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(13 - 8))) then
						return "festering_strike aoe_setup 4";
					end
				end
				v166 = 1 - 0;
			end
			if (((4376 - (35 + 1064)) > (297 + 110)) and ((2 - 1) == v166)) then
				if (((19 + 4676) >= (2651 - (298 + 938))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (1269 - (233 + 1026))))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(1706 - (636 + 1030))) or ((1643 + 1569) <= (923 + 21))) then
						return "epidemic aoe_setup 6";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) or ((920 + 2176) <= (122 + 1676))) then
					if (((3758 - (55 + 166)) == (686 + 2851)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(1 + 4))) then
						return "festering_strike aoe_setup 8";
					end
				end
				v166 = 7 - 5;
			end
		end
	end
	local function v120()
		local v167 = 297 - (36 + 261);
		while true do
			if (((6710 - 2873) >= (2938 - (34 + 1334))) and (v167 == (1 + 0))) then
				if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (4 + 1))) or ((4233 - (1035 + 248)) == (3833 - (20 + 1)))) then
					if (((2461 + 2262) >= (2637 - (134 + 185))) and v19(v61.DarkTransformation)) then
						return "dark_transformation cooldowns 6";
					end
				end
				if ((v61.Apocalypse:IsReady() and v78) or ((3160 - (549 + 584)) > (3537 - (314 + 371)))) then
					if (v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v15:IsInMeleeRange(17 - 12)) or ((2104 - (478 + 490)) > (2287 + 2030))) then
						return "apocalypse cooldowns 8";
					end
				end
				v167 = 1174 - (786 + 386);
			end
			if (((15378 - 10630) == (6127 - (1055 + 324))) and (v167 == (1342 - (1093 + 247)))) then
				if (((3320 + 416) <= (499 + 4241)) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (91 - 68))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v14:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v14:BuffUp(v61.DarkTransformation)))) or (v91 <= (71 - 50)))) then
					if (v19(v61.EmpowerRuneWeapon, v49) or ((9646 - 6256) <= (7689 - 4629))) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if ((v61.AbominationLimb:IsCastable() and (v13:Rune() < (2 + 1)) and v78) or ((3848 - 2849) > (9282 - 6589))) then
					if (((350 + 113) < (1536 - 935)) and v19(v61.AbominationLimb)) then
						return "abomination_limb cooldowns 12";
					end
				end
				v167 = 691 - (364 + 324);
			end
			if ((v167 == (10 - 6)) or ((5238 - 3055) < (228 + 459))) then
				if (((19034 - 14485) == (7284 - 2735)) and v61.SoulReaper:IsReady() and (v94 >= (5 - 3))) then
					if (((5940 - (1249 + 19)) == (4218 + 454)) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if ((v167 == (11 - 8)) or ((4754 - (686 + 400)) < (310 + 85))) then
				if ((v61.UnholyAssault:IsReady() and v78) or ((4395 - (73 + 156)) == (3 + 452))) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v15:IsInMeleeRange(816 - (721 + 90)), v57) or ((51 + 4398) == (8646 - 5983))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if ((v61.SoulReaper:IsReady() and (v94 == (471 - (224 + 246))) and ((v15:TimeToX(56 - 21) < (9 - 4)) or (v15:HealthPercentage() <= (7 + 28))) and (v15:TimeToDie() > (1 + 4))) or ((3142 + 1135) < (5942 - 2953))) then
					if (v19(v61.SoulReaper, nil, nil, not v15:IsSpellInRange(v61.SoulReaper)) or ((2895 - 2025) >= (4662 - (203 + 310)))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v167 = 1997 - (1238 + 755);
			end
			if (((155 + 2057) < (4717 - (709 + 825))) and ((0 - 0) == v167)) then
				if (((6767 - 2121) > (3856 - (196 + 668))) and v61.SummonGargoyle:IsCastable() and (v13:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) then
					if (((5661 - 4227) < (6433 - 3327)) and v19(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if (((1619 - (171 + 662)) < (3116 - (4 + 89))) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
					if (v19(v61.RaiseDead, nil) or ((8558 - 6116) < (27 + 47))) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v167 = 4 - 3;
			end
		end
	end
	local function v121()
		local v168 = 0 + 0;
		while true do
			if (((6021 - (35 + 1451)) == (5988 - (28 + 1425))) and (v168 == (1994 - (941 + 1052)))) then
				if ((v61.SoulReaper:IsReady() and (v94 == (1 + 0)) and ((v15:TimeToX(1549 - (822 + 692)) < (6 - 1)) or (v15:HealthPercentage() <= (17 + 18))) and (v15:TimeToDie() > (302 - (45 + 252)))) or ((2978 + 31) <= (725 + 1380))) then
					if (((4453 - 2623) < (4102 - (114 + 319))) and v19(v61.SoulReaper, nil, nil, not v15:IsInMeleeRange(6 - 1))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if ((v61.SummonGargoyle:IsCastable() and v29 and (v13:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() >= (51 - 11))))) or ((912 + 518) >= (5380 - 1768))) then
					if (((5621 - 2938) >= (4423 - (556 + 1407))) and v19(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v168 = 1208 - (741 + 465);
			end
			if ((v168 == (465 - (170 + 295))) or ((951 + 853) >= (3009 + 266))) then
				if ((v61.Apocalypse:IsReady() and (v89 >= (9 - 5)) and ((v13:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (20 + 3))) or not v61.CommanderoftheDead:IsAvailable())) or ((909 + 508) > (2055 + 1574))) then
					if (((6025 - (957 + 273)) > (108 + 294)) and v19(v61.Apocalypse, nil, not v15:IsInMeleeRange(3 + 2))) then
						return "apocalypse garg_setup 2";
					end
				end
				if (((18339 - 13526) > (9394 - 5829)) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (9 - 6)) or v13:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (49 - 39))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) then
					if (((5692 - (389 + 1391)) == (2455 + 1457)) and v19(v61.ArmyoftheDead)) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v168 = 1 + 0;
			end
			if (((6422 - 3601) <= (5775 - (783 + 168))) and (v168 == (9 - 6))) then
				if (((1710 + 28) <= (2506 - (309 + 2))) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 - 0)) and not v13:IsMoving() and (v94 >= (1213 - (1090 + 122)))) then
					if (((14 + 27) <= (10135 - 7117)) and v19(v88, v48)) then
						return "any_dnd garg_setup 18";
					end
				end
				if (((1468 + 677) <= (5222 - (628 + 490))) and v61.FesteringStrike:IsReady() and ((v89 == (0 + 0)) or not v61.Apocalypse:IsAvailable() or ((v13:RunicPower() < (99 - 59)) and not v84))) then
					if (((12288 - 9599) < (5619 - (431 + 343))) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(10 - 5))) then
						return "festering_strike garg_setup 20";
					end
				end
				v168 = 11 - 7;
			end
			if ((v168 == (2 + 0)) or ((297 + 2025) > (4317 - (556 + 1139)))) then
				if ((v29 and v84 and (v85 <= (38 - (6 + 9)))) or ((831 + 3703) == (1067 + 1015))) then
					local v184 = 169 - (28 + 141);
					while true do
						if ((v184 == (0 + 0)) or ((1938 - 367) > (1323 + 544))) then
							if (v61.EmpowerRuneWeapon:IsCastable() or ((3971 - (486 + 831)) >= (7796 - 4800))) then
								if (((14004 - 10026) > (398 + 1706)) and v19(v61.EmpowerRuneWeapon, v49)) then
									return "empower_rune_weapon garg_setup 10";
								end
							end
							if (((9469 - 6474) > (2804 - (668 + 595))) and v61.UnholyAssault:IsCastable()) then
								if (((2924 + 325) > (193 + 760)) and v19(v61.UnholyAssault, v57, nil, not v15:IsInMeleeRange(13 - 8))) then
									return "unholy_assault garg_setup 12";
								end
							end
							break;
						end
					end
				end
				if ((v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() > (330 - (23 + 267)))) or not v61.CommanderoftheDead:IsAvailable())) or ((5217 - (1129 + 815)) > (4960 - (371 + 16)))) then
					if (v19(v61.DarkTransformation) or ((4901 - (1326 + 424)) < (2431 - 1147))) then
						return "dark_transformation garg_setup 16";
					end
				end
				v168 = 10 - 7;
			end
			if ((v168 == (122 - (88 + 30))) or ((2621 - (720 + 51)) == (3400 - 1871))) then
				if (((2597 - (421 + 1355)) < (3502 - 1379)) and v61.DeathCoil:IsReady() and (v13:Rune() <= (1 + 0))) then
					if (((1985 - (286 + 797)) < (8499 - 6174)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v169 = 0 - 0;
		local v170;
		while true do
			if (((1297 - (397 + 42)) <= (926 + 2036)) and (v169 == (803 - (24 + 776)))) then
				if ((v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (4 - 1))) or (v94 >= (788 - (222 + 563)))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v13:BuffRemains(v61.PlaguebringerBuff) < v13:GCD())) or ((8694 - 4748) < (928 + 360))) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((3432 - (23 + 167)) == (2365 - (690 + 1108)))) then
						return "wound_spender high_prio_actions 10";
					end
				end
				if ((v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (8 + 13)))) or ((699 + 148) >= (2111 - (40 + 808)))) then
					if (v19(v61.UnholyBlight, v58, nil, not v15:IsInRange(2 + 6)) or ((8615 - 6362) == (1770 + 81))) then
						return "unholy_blight high_prio_actions 12";
					end
				end
				v169 = 3 + 1;
			end
			if ((v169 == (0 + 0)) or ((2658 - (47 + 524)) > (1540 + 832))) then
				v170 = v70.HandleDPSPotion();
				if (v170 or ((12150 - 7705) < (6203 - 2054))) then
					return "DPS Pot";
				end
				v169 = 2 - 1;
			end
			if ((v169 == (1728 - (1165 + 561))) or ((55 + 1763) == (263 - 178))) then
				if (((241 + 389) < (2606 - (341 + 138))) and v61.DeathCoil:IsReady() and ((v94 <= (1 + 2)) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (10 - 5)) and (v13:BuffRemains(v61.CommanderoftheDeadBuff) > (353 - (89 + 237)))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((6234 - 4296) == (5292 - 2778))) then
						return "death_coil high_prio_actions 6";
					end
				end
				if (((5136 - (581 + 300)) >= (1275 - (855 + 365))) and v61.Epidemic:IsReady() and (v96 >= (9 - 5)) and ((v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (2 + 3))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (((4234 - (1030 + 205)) > (1086 + 70)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(38 + 2))) then
						return "epidemic high_prio_actions 8";
					end
				end
				v169 = 289 - (156 + 130);
			end
			if (((5339 - 2989) > (1946 - 791)) and (v169 == (7 - 3))) then
				if (((1062 + 2967) <= (2830 + 2023)) and v61.Outbreak:IsReady()) then
					if (v70.CastCycle(v61.Outbreak, v93, v113, not v15:IsSpellInRange(v61.Outbreak)) or ((585 - (10 + 59)) > (972 + 2462))) then
						return "outbreak high_prio_actions 14";
					end
				end
				break;
			end
			if (((19925 - 15879) >= (4196 - (671 + 492))) and (v169 == (1 + 0))) then
				if (v45 or ((3934 - (369 + 846)) <= (384 + 1063))) then
					local v185 = 0 + 0;
					while true do
						if ((v185 == (1945 - (1036 + 909))) or ((3287 + 847) < (6591 - 2665))) then
							if ((v61.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (243 - (11 + 192))) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (21 + 19)))) or ((339 - (135 + 40)) >= (6747 - 3962))) then
								if (v19(v61.AntiMagicShell, v46) or ((317 + 208) == (4645 - 2536))) then
									return "antimagic_shell ams_amz 2";
								end
							end
							if (((49 - 16) == (209 - (50 + 126))) and v61.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (194 - 124)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) then
								if (((676 + 2378) <= (5428 - (1233 + 180))) and v19(v61.AntiMagicZone, v47)) then
									return "antimagic_zone ams_amz 4";
								end
							end
							break;
						end
					end
				end
				if (((2840 - (522 + 447)) < (4803 - (107 + 1314))) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (1 + 1))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (106 - 71)))) then
					if (((550 + 743) <= (4301 - 2135)) and v19(v61.ArmyoftheDead)) then
						return "army_of_the_dead high_prio_actions 4";
					end
				end
				v169 = 7 - 5;
			end
		end
	end
	local function v123()
		local v171 = 1910 - (716 + 1194);
		while true do
			if ((v171 == (1 + 2)) or ((277 + 2302) < (626 - (74 + 429)))) then
				if ((v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + (5 - 2)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (30 + 30))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (6 - 3)))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 3 + 0))) or ((v94 >= (5 - 3)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + (7 - 4))))) or ((1279 - (279 + 154)) >= (3146 - (454 + 324)))) then
					if (v19(v61.Fireblood, v52) or ((3157 + 855) <= (3375 - (12 + 5)))) then
						return "fireblood racials 14";
					end
				end
				if (((806 + 688) <= (7656 - 4651)) and v61.BagofTricks:IsCastable() and (v94 == (1 + 0)) and (v13:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 1098 - (277 + 816)))) then
					if (v19(v61.BagofTricks, v52, nil, not v15:IsSpellInRange(v61.BagofTricks)) or ((13293 - 10182) == (3317 - (1058 + 125)))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
			if (((442 + 1913) == (3330 - (815 + 160))) and (v171 == (8 - 6))) then
				if ((v61.AncestralCall:IsCastable() and ((((42 - 24) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (15 + 45))) and ((v82 and (v83 <= (52 - 34))) or (v80 and (v81 <= (1916 - (41 + 1857)))) or ((v94 >= (1895 - (1222 + 671))) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (46 - 28)))) or ((844 - 256) <= (1614 - (229 + 953)))) then
					if (((6571 - (1111 + 663)) >= (5474 - (874 + 705))) and v19(v61.AncestralCall, v52)) then
						return "ancestral_call racials 10";
					end
				end
				if (((501 + 3076) == (2441 + 1136)) and v61.ArcanePulse:IsCastable() and ((v94 >= (3 - 1)) or ((v13:Rune() <= (1 + 0)) and (v13:RunicPowerDeficit() >= (739 - (642 + 37)))))) then
					if (((866 + 2928) > (591 + 3102)) and v19(v61.ArcanePulse, v52, nil, not v15:IsInRange(19 - 11))) then
						return "arcane_pulse racials 12";
					end
				end
				v171 = 457 - (233 + 221);
			end
			if ((v171 == (0 - 0)) or ((1123 + 152) == (5641 - (718 + 823)))) then
				if ((v61.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (13 + 7)) and ((v61.SummonGargoyle:CooldownRemains() < v13:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v13:Rune() < (807 - (266 + 539))) and (v89 < (2 - 1))))) or ((2816 - (636 + 589)) >= (8498 - 4918))) then
					if (((2026 - 1043) <= (1433 + 375)) and v19(v61.ArcaneTorrent, v52, nil, not v15:IsInRange(3 + 5))) then
						return "arcane_torrent racials 2";
					end
				end
				if ((v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + (1018 - (657 + 358))) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (158 - 98))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (6 - 3)))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + (1190 - (1151 + 36))))) or ((v94 >= (2 + 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + 1 + 2)))) or ((6420 - 4270) <= (3029 - (1552 + 280)))) then
					if (((4603 - (64 + 770)) >= (797 + 376)) and v19(v61.BloodFury, v52)) then
						return "blood_fury racials 4";
					end
				end
				v171 = 2 - 1;
			end
			if (((264 + 1221) == (2728 - (157 + 1086))) and (v171 == (1 - 0))) then
				if ((v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (13 - 10)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (92 - 32))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (3 - 0)))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + (822 - (599 + 220))))) or ((v94 >= (3 - 1)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + (1934 - (1813 + 118)))))) or ((2424 + 891) <= (3999 - (841 + 376)))) then
					if (v19(v61.Berserking, v52) or ((1226 - 350) >= (689 + 2275))) then
						return "berserking racials 6";
					end
				end
				if ((v61.LightsJudgment:IsCastable() and v13:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v13:BuffRemains(v61.FestermightBuff) < v15:TimeToDie()) or (v13:BuffRemains(v61.UnholyStrengthBuff) < v15:TimeToDie()))) or ((6092 - 3860) > (3356 - (464 + 395)))) then
					if (v19(v61.LightsJudgment, v52, nil, not v15:IsSpellInRange(v61.LightsJudgment)) or ((5415 - 3305) <= (160 + 172))) then
						return "lights_judgment racials 8";
					end
				end
				v171 = 839 - (467 + 370);
			end
		end
	end
	local function v124()
		local v172 = 0 - 0;
		while true do
			if (((2706 + 980) > (10873 - 7701)) and (v172 == (1 + 1))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((10408 - 5934) < (1340 - (150 + 370)))) then
					if (((5561 - (74 + 1208)) >= (7088 - 4206)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v15:IsInMeleeRange(23 - 18))) then
						return "festering_strike st 10";
					end
				end
				if (v61.DeathCoil:IsReady() or ((1444 + 585) >= (3911 - (14 + 376)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((3532 - 1495) >= (3004 + 1638))) then
						return "death_coil st 12";
					end
				end
				v172 = 3 + 0;
			end
			if (((1641 + 79) < (13062 - 8604)) and (v172 == (1 + 0))) then
				if ((v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (80 - (23 + 55))) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (30 - 17))) or (v84 and (v85 > (6 + 2))) or (v82 and (v83 > (8 + 0))) or (not v76 and (v89 >= (5 - 1))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v14:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 + 0))) and not v13:IsMoving() and (v94 >= (902 - (652 + 249)))) or ((1166 - 730) > (4889 - (708 + 1160)))) then
					if (((1935 - 1222) <= (1543 - 696)) and v19(v88, v48)) then
						return "any_dnd st 6";
					end
				end
				if (((2181 - (10 + 17)) <= (906 + 3125)) and v86:IsReady() and (v76 or ((v94 >= (1734 - (1400 + 332))) and v13:BuffUp(v61.DeathAndDecayBuff)))) then
					if (((8851 - 4236) == (6523 - (242 + 1666))) and v19(v86, nil, nil, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 8";
					end
				end
				v172 = 1 + 1;
			end
			if (((2 + 1) == v172) or ((3230 + 560) == (1440 - (850 + 90)))) then
				if (((155 - 66) < (1611 - (360 + 1030))) and v86:IsReady() and not v76) then
					if (((1818 + 236) >= (4010 - 2589)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if (((951 - 259) < (4719 - (909 + 752))) and (v172 == (1223 - (109 + 1114)))) then
				if ((v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (18 - 8)))) or ((1267 + 1987) == (1897 - (6 + 236)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((817 + 479) == (3953 + 957))) then
						return "death_coil st 2";
					end
				end
				if (((7942 - 4574) == (5882 - 2514)) and v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (1143 - (1076 + 57))))) then
					if (((435 + 2208) < (4504 - (579 + 110))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(4 + 36))) then
						return "epidemic st 4";
					end
				end
				v172 = 1 + 0;
			end
		end
	end
	local function v125()
		if (((1016 + 897) > (900 - (174 + 233))) and v33) then
			local v178 = 0 - 0;
			local v179;
			while true do
				if (((8345 - 3590) > (1525 + 1903)) and (v178 == (1174 - (663 + 511)))) then
					v179 = v115();
					if (((1233 + 148) <= (515 + 1854)) and v179) then
						return v179;
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (2 + 0)) or ((11401 - 6558) == (9886 - 5802))) then
				v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (1 + 0)) and (v61.UnholyAssault:CooldownRemains() < (38 - 18)) and v61.UnholyAssault:IsAvailable() and v78) or (v15:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1 + 0))) or (v89 > (1 + 3)) or (v13:HasTier(753 - (478 + 244), 521 - (440 + 77)) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 + 0))))) or ((v91 < (18 - 13)) and (v89 >= (1557 - (655 + 901))));
				v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (1 + 2)) and (v13:RunicPower() < (46 + 14)) and not v78;
				v173 = 3 + 0;
			end
			if (((18809 - 14140) > (1808 - (695 + 750))) and (v173 == (13 - 9))) then
				v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v15:DebuffDown(v61.RottenTouchDebuff)) or (v13:RunicPowerDeficit() < (30 - 10))) and (not v13:HasTier(124 - 93, 355 - (285 + 66)) or (v13:HasTier(71 - 40, 1314 - (682 + 628)) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v13:RunicPowerDeficit() < (4 + 16)) or (v13:Rune() < (302 - (176 + 123)))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (1 + 1)) or v61.CoilofDevastation:IsAvailable())) or (v13:Rune() < (3 + 0)) or v84 or v13:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (279 - (239 + 30))) and (v89 > (1 + 2))) or (not v76 and (v89 >= (4 + 0))));
				break;
			end
			if ((v173 == (4 - 1)) or ((5856 - 3979) >= (3453 - (306 + 9)))) then
				v78 = (v94 == (3 - 2)) or not v28;
				v79 = (v94 >= (1 + 1)) and v28;
				v173 = 3 + 1;
			end
			if (((2283 + 2459) >= (10368 - 6742)) and (v173 == (1376 - (1140 + 235)))) then
				v74 = ((v61.Apocalypse:CooldownRemains() < (7 + 3)) and (v89 <= (4 + 0)) and (v61.UnholyAssault:CooldownRemains() > (3 + 7)) and (59 - (33 + 19))) or (1 + 1);
				if ((not v84 and v61.Festermight:IsAvailable() and v13:BuffUp(v61.FestermightBuff) and ((v13:BuffRemains(v61.FestermightBuff) / ((14 - 9) * v13:GCD())) >= (1 + 0))) or ((8903 - 4363) == (859 + 57))) then
					v75 = v89 >= (690 - (586 + 103));
				else
					v75 = v89 >= ((1 + 2) - v22(v61.InfectedClaws:IsAvailable()));
				end
				v173 = 5 - 3;
			end
			if (((1488 - (1309 + 179)) == v173) or ((2086 - 930) > (1892 + 2453))) then
				v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (7 - 4))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (4 + 0))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (3 - 1)));
				v71 = (v94 >= (5 - 2)) or ((v61.SummonGargoyle:CooldownRemains() > (610 - (295 + 314))) and ((v61.Apocalypse:CooldownRemains() > (2 - 1)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v9.CombatTime() > (1982 - (1300 + 662)));
				v173 = 3 - 2;
			end
		end
	end
	local function v127()
		local v174 = 1755 - (1178 + 577);
		while true do
			if (((1162 + 1075) < (12560 - 8311)) and (v174 == (1409 - (851 + 554)))) then
				if (v70.TargetIsValid() or v13:AffectingCombat() or ((2373 + 310) < (63 - 40))) then
					v90 = v9.BossFightRemains();
					v91 = v90;
					if (((1513 - 816) <= (1128 - (115 + 187))) and (v91 == (8510 + 2601))) then
						v91 = v9.FightRemains(v93, false);
					end
					v97 = v100(v95);
					v80 = v61.Apocalypse:TimeSinceLastCast() <= (15 + 0);
					v81 = (v80 and ((59 - 44) - v61.Apocalypse:TimeSinceLastCast())) or (1161 - (160 + 1001));
					v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (27 + 3);
					v83 = (v82 and ((21 + 9) - v61.ArmyoftheDead:TimeSinceLastCast())) or (0 - 0);
					v84 = v92:GargActive();
					v85 = v92:GargRemains();
					v89 = v15:DebuffStack(v61.FesteringWoundDebuff);
				end
				if (((1463 - (237 + 121)) <= (2073 - (525 + 372))) and v70.TargetIsValid()) then
					if (((6405 - 3026) <= (12524 - 8712)) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v189 = 142 - (96 + 46);
						local v190;
						while true do
							if ((v189 == (778 - (643 + 134))) or ((285 + 503) >= (3874 - 2258))) then
								v190 = v70.Interrupt(v61.MindFreeze, 55 - 40, true, v20, v63.MindFreezeMouseover);
								if (((1779 + 75) <= (6630 - 3251)) and v190) then
									return v190;
								end
								break;
							end
							if (((9298 - 4749) == (5268 - (316 + 403))) and (v189 == (0 + 0))) then
								v190 = v70.Interrupt(v61.MindFreeze, 41 - 26, true);
								if (v190 or ((1093 + 1929) >= (7615 - 4591))) then
									return v190;
								end
								v189 = 1 + 0;
							end
						end
					end
					if (((1554 + 3266) > (7615 - 5417)) and not v13:AffectingCombat()) then
						local v191 = 0 - 0;
						local v192;
						while true do
							if ((v191 == (0 - 0)) or ((61 + 1000) >= (9628 - 4737))) then
								v192 = v114();
								if (((67 + 1297) <= (13159 - 8686)) and v192) then
									return v192;
								end
								break;
							end
						end
					end
					if ((v61.DeathStrike:IsReady() and not v69) or ((3612 - (12 + 5)) <= (11 - 8))) then
						if (v19(v61.DeathStrike) or ((9967 - 5295) == (8187 - 4335))) then
							return "death_strike low hp or proc";
						end
					end
					if (((3865 - 2306) == (317 + 1242)) and (v94 == (1973 - (1656 + 317)))) then
						local v193 = 0 + 0;
						while true do
							if ((v193 == (0 + 0)) or ((4658 - 2906) <= (3878 - 3090))) then
								if ((v61.Outbreak:IsReady() and (v97 > (354 - (5 + 349)))) or ((18557 - 14650) == (1448 - (266 + 1005)))) then
									if (((2287 + 1183) > (1893 - 1338)) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
										return "outbreak out_of_range";
									end
								end
								if ((v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (1 - 0)) and not v77) or ((2668 - (561 + 1135)) == (840 - 195))) then
									if (((10459 - 7277) >= (3181 - (507 + 559))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(100 - 60))) then
										return "epidemic out_of_range";
									end
								end
								v193 = 3 - 2;
							end
							if (((4281 - (212 + 176)) < (5334 - (250 + 655))) and (v193 == (2 - 1))) then
								if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (2 - 0)) and not v77) or ((4485 - 1618) < (3861 - (1869 + 87)))) then
									if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((6229 - 4433) >= (5952 - (484 + 1417)))) then
										return "death_coil out_of_range";
									end
								end
								break;
							end
						end
					end
					if (((3469 - 1850) <= (6294 - 2538)) and v61.Apocalypse:IsReady() and v53) then
						if (((1377 - (48 + 725)) == (986 - 382)) and v19(v61.Apocalypse, nil, not v15:IsInMeleeRange(13 - 8), v53)) then
							return "apocalypse garg_setup 2";
						end
					end
					if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (3 + 2)) and v54) or ((11982 - 7498) == (252 + 648))) then
						if (v19(v61.DarkTransformation, v54) or ((1300 + 3159) <= (1966 - (152 + 701)))) then
							return "dark_transformation cooldowns 6";
						end
					end
					v126();
					local v186 = v122();
					if (((4943 - (430 + 881)) > (1302 + 2096)) and v186) then
						return v186;
					end
					local v186 = v115();
					if (((4977 - (557 + 338)) <= (1454 + 3463)) and v186) then
						return v186;
					end
					if (((13616 - 8784) >= (4853 - 3467)) and v29 and not v71) then
						local v194 = 0 - 0;
						local v195;
						while true do
							if (((295 - 158) == (938 - (499 + 302))) and (v194 == (866 - (39 + 827)))) then
								v195 = v121();
								if (v195 or ((4334 - 2764) >= (9674 - 5342))) then
									return v195;
								end
								break;
							end
						end
					end
					if ((v29 and v78) or ((16141 - 12077) <= (2792 - 973))) then
						local v196 = 0 + 0;
						local v197;
						while true do
							if ((v196 == (0 - 0)) or ((798 + 4188) < (2490 - 916))) then
								v197 = v120();
								if (((4530 - (103 + 1)) > (726 - (475 + 79))) and v197) then
									return v197;
								end
								break;
							end
						end
					end
					if (((1266 - 680) > (1456 - 1001)) and v28 and v29 and v79) then
						local v198 = 0 + 0;
						local v199;
						while true do
							if (((727 + 99) == (2329 - (1395 + 108))) and (v198 == (0 - 0))) then
								v199 = v118();
								if (v199 or ((5223 - (7 + 1197)) > (1937 + 2504))) then
									return v199;
								end
								break;
							end
						end
					end
					if (((704 + 1313) < (4580 - (27 + 292))) and v29) then
						local v200 = v123();
						if (((13819 - 9103) > (102 - 22)) and v200) then
							return v200;
						end
					end
					if (v28 or ((14707 - 11200) == (6452 - 3180))) then
						if ((v79 and (v87:CooldownRemains() < (19 - 9)) and v13:BuffDown(v61.DeathAndDecayBuff)) or ((1015 - (43 + 96)) >= (12543 - 9468))) then
							local v202 = 0 - 0;
							local v203;
							while true do
								if (((3612 + 740) > (722 + 1832)) and (v202 == (0 - 0))) then
									v203 = v119();
									if (v203 or ((1689 + 2717) < (7576 - 3533))) then
										return v203;
									end
									break;
								end
							end
						end
						if (((v94 >= (2 + 2)) and v13:BuffUp(v61.DeathAndDecayBuff)) or ((139 + 1750) >= (5134 - (1414 + 337)))) then
							local v204 = v117();
							if (((3832 - (1642 + 298)) <= (7127 - 4393)) and v204) then
								return v204;
							end
						end
						if (((5531 - 3608) < (6581 - 4363)) and (v94 >= (2 + 2)) and (((v87:CooldownRemains() > (8 + 2)) and v13:BuffDown(v61.DeathAndDecayBuff)) or not v79)) then
							local v205 = 972 - (357 + 615);
							local v206;
							while true do
								if (((1526 + 647) > (929 - 550)) and (v205 == (0 + 0))) then
									v206 = v116();
									if (v206 or ((5552 - 2961) == (2727 + 682))) then
										return v206;
									end
									break;
								end
							end
						end
					end
					if (((307 + 4207) > (2090 + 1234)) and (v94 <= (1304 - (384 + 917)))) then
						local v201 = v124();
						if (v201 or ((905 - (128 + 569)) >= (6371 - (1407 + 136)))) then
							return v201;
						end
					end
					if (v61.FesteringStrike:IsReady() or ((3470 - (687 + 1200)) > (5277 - (556 + 1154)))) then
						if (v19(v61.FesteringStrike, nil, nil) or ((4619 - 3306) == (889 - (9 + 86)))) then
							return "festering_strike precombat 8";
						end
					end
				end
				break;
			end
			if (((3595 - (275 + 146)) > (472 + 2430)) and (v174 == (64 - (29 + 35)))) then
				v60();
				v27 = EpicSettings.Toggles['ooc'];
				v174 = 4 - 3;
			end
			if (((12306 - 8186) <= (18805 - 14545)) and ((2 + 0) == v174)) then
				v69 = not v99();
				v93 = v13:GetEnemiesInMeleeRange(1017 - (53 + 959));
				v174 = 411 - (312 + 96);
			end
			if ((v174 == (4 - 1)) or ((1168 - (147 + 138)) > (5677 - (813 + 86)))) then
				v95 = v15:GetEnemiesInSplashRange(10 + 0);
				if (v28 or ((6707 - 3087) >= (5383 - (18 + 474)))) then
					local v187 = 0 + 0;
					while true do
						if (((13897 - 9639) > (2023 - (860 + 226))) and (v187 == (303 - (121 + 182)))) then
							v94 = #v93;
							v96 = v15:GetEnemiesInSplashRangeCount(2 + 8);
							break;
						end
					end
				else
					local v188 = 1240 - (988 + 252);
					while true do
						if ((v188 == (0 + 0)) or ((1526 + 3343) < (2876 - (49 + 1921)))) then
							v94 = 891 - (223 + 667);
							v96 = 53 - (51 + 1);
							break;
						end
					end
				end
				v174 = 6 - 2;
			end
			if (((1 - 0) == v174) or ((2350 - (146 + 979)) > (1194 + 3034))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v174 = 607 - (311 + 294);
			end
		end
	end
	local function v128()
		local v175 = 0 - 0;
		while true do
			if (((1410 + 1918) > (3681 - (496 + 947))) and (v175 == (1359 - (1233 + 125)))) then
				v9.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
			if (((1558 + 2281) > (1261 + 144)) and (v175 == (0 + 0))) then
				v61.VirulentPlagueDebuff:RegisterAuraTracking();
				v61.FesteringWoundDebuff:RegisterAuraTracking();
				v175 = 1646 - (963 + 682);
			end
		end
	end
	v9.SetAPL(211 + 41, v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

