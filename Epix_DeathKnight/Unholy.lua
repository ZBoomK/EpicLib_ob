local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1083 + 3086) > (3846 - 1659)) and not v5) then
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
		local v129 = 0 - 0;
		while true do
			if (((3218 - (1293 + 519)) == (2868 - 1462)) and (v129 == (4 - 2))) then
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v129 = 2 + 1;
			end
			if (((313 + 1218) < (9923 - 5652)) and (v129 == (2 + 6))) then
				v58 = EpicSettings.Settings['UnholyBlightGCD'];
				v59 = EpicSettings.Settings['VileContagionGCD'];
				break;
			end
			if (((211 + 424) == (397 + 238)) and (v129 == (1101 - (709 + 387)))) then
				v49 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v50 = EpicSettings.Settings['SacrificialPactGCD'];
				v51 = EpicSettings.Settings['MindFreezeOffGCD'];
				v129 = 1864 - (673 + 1185);
			end
			if (((9782 - 6409) <= (11418 - 7862)) and (v129 == (0 - 0))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v129 = 1 + 0;
			end
			if ((v129 == (3 - 0)) or ((809 + 2482) < (6540 - 3260))) then
				v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 - 0);
				v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (1880 - (446 + 1434));
				v45 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v129 = 1287 - (1040 + 243);
			end
			if (((13090 - 8704) >= (2720 - (559 + 1288))) and (v129 == (1937 - (609 + 1322)))) then
				v52 = EpicSettings.Settings['RacialsOffGCD'];
				v53 = EpicSettings.Settings['ApocalypseGCD'];
				v54 = EpicSettings.Settings['DarkTransformationGCD'];
				v129 = 461 - (13 + 441);
			end
			if (((3441 - 2520) <= (2886 - 1784)) and (v129 == (4 - 3))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v129 = 1 + 1;
			end
			if (((2063 + 2643) >= (2857 - 1894)) and (v129 == (4 + 3))) then
				v55 = EpicSettings.Settings['EpidemicGCD'];
				v56 = EpicSettings.Settings['SummonGargoyleGCD'];
				v57 = EpicSettings.Settings['UnholyAssaultGCD'];
				v129 = 14 - 6;
			end
			if ((v129 == (3 + 1)) or ((534 + 426) <= (630 + 246))) then
				v46 = EpicSettings.Settings['AntiMagicShellGCD'];
				v47 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v48 = EpicSettings.Settings['DeathAndDecayGCD'];
				v129 = 5 + 0;
			end
		end
	end
	local v61 = v16.DeathKnight.Unholy;
	local v62 = v18.DeathKnight.Unholy;
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {};
	local v65 = v13:GetEquipment();
	local v66 = (v65[13 + 0] and v18(v65[446 - (153 + 280)])) or v18(0 - 0);
	local v67 = (v65[13 + 1] and v18(v65[6 + 8])) or v18(0 + 0);
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
	local v90 = 10084 + 1027;
	local v91 = 8052 + 3059;
	local v92 = v9.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (1050 - (572 + 477))) or ((279 + 1787) == (560 + 372))) then
				v67 = (v65[2 + 12] and v18(v65[100 - (84 + 2)])) or v18(0 - 0);
				break;
			end
			if (((3476 + 1349) < (5685 - (497 + 345))) and ((0 + 0) == v130)) then
				v65 = v13:GetEquipment();
				v66 = (v65[3 + 10] and v18(v65[1346 - (605 + 728)])) or v18(0 + 0);
				v130 = 1 - 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (0 - 0)) or ((3496 + 381) >= (12570 - 8033))) then
				v90 = 8390 + 2721;
				v91 = 11600 - (457 + 32);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
		v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
		v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v13:HealthPercentage() < v43) or ((v13:HealthPercentage() < v44) and v13:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v132)
		local v133 = 0 + 0;
		local v134;
		while true do
			if ((v133 == (1402 - (832 + 570))) or ((4066 + 249) < (451 + 1275))) then
				v134 = 0 - 0;
				for v183, v184 in pairs(v132) do
					if (v184:DebuffDown(v61.VirulentPlagueDebuff) or ((1773 + 1906) < (1421 - (588 + 208)))) then
						v134 = v134 + (2 - 1);
					end
				end
				v133 = 1801 - (884 + 916);
			end
			if (((1 - 0) == v133) or ((2682 + 1943) < (1285 - (232 + 421)))) then
				return v134;
			end
		end
	end
	local function v101(v135)
		local v136 = 1889 - (1569 + 320);
		local v137;
		while true do
			if ((v136 == (1 + 0)) or ((16 + 67) > (5998 - 4218))) then
				return v9.FightRemains(v137);
			end
			if (((1151 - (316 + 289)) <= (2819 - 1742)) and (v136 == (0 + 0))) then
				v137 = {};
				for v185 in pairs(v135) do
					if (not v12:IsInBossList(v135[v185]['UnitNPCID']) or ((2449 - (666 + 787)) > (4726 - (360 + 65)))) then
						v30(v137, v135[v185]);
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v102(v138)
		return (v138:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v139)
		return (v139:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v140)
		return (v61.BurstingSores:IsAvailable() and v140:DebuffUp(v61.FesteringWoundDebuff) and ((v13:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v13:Rune() < (257 - (79 + 175)))) or (v13:BuffUp(v61.DeathAndDecayBuff) and (v13:Rune() == (0 - 0))))) or (not v61.BurstingSores:IsAvailable() and (v140:DebuffStack(v61.FesteringWoundDebuff) >= (4 + 0))) or (v13:HasTier(94 - 63, 3 - 1) and v140:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v141)
		return v141:DebuffStack(v61.FesteringWoundDebuff) >= (903 - (503 + 396));
	end
	local function v106(v142)
		return v142:DebuffStack(v61.FesteringWoundDebuff) < (185 - (92 + 89));
	end
	local function v107(v143)
		return v143:DebuffStack(v61.FesteringWoundDebuff) < (7 - 3);
	end
	local function v108(v144)
		return v144:DebuffStack(v61.FesteringWoundDebuff) >= (3 + 1);
	end
	local function v109(v145)
		return ((v145:TimeToX(21 + 14) < (19 - 14)) or (v145:HealthPercentage() <= (5 + 30))) and (v145:TimeToDie() > (v145:DebuffRemains(v61.SoulReaper) + (11 - 6)));
	end
	local function v110(v146)
		return (v146:DebuffStack(v61.FesteringWoundDebuff) <= (2 + 0)) or v14:BuffUp(v61.DarkTransformation);
	end
	local function v111(v147)
		return (v147:DebuffStack(v61.FesteringWoundDebuff) >= (2 + 2)) and (v87:CooldownRemains() < (8 - 5));
	end
	local function v112(v148)
		return v148:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v149)
		return (v149:TimeToDie() > v149:DebuffRemains(v61.VirulentPlagueDebuff)) and (v149:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v149:DebuffRefreshable(v61.FrostFeverDebuff) or v149:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((22 - 7) / ((v22(v61.Superstrain:IsAvailable()) * (1247 - (485 + 759))) + (v22(v61.Plaguebringer:IsAvailable()) * (4 - 2)) + (v22(v61.EbonFever:IsAvailable()) * (1191 - (442 + 747))))))));
	end
	local function v114()
		if (((5205 - (832 + 303)) > (1633 - (88 + 858))) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive() or not v14:IsActive())) then
			if (v19(v61.RaiseDead, nil) or ((200 + 456) >= (2756 + 574))) then
				return "raise_dead precombat 2 displaystyle";
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v29) or ((103 + 2389) <= (1124 - (766 + 23)))) then
			if (((21336 - 17014) >= (3503 - 941)) and v19(v61.ArmyoftheDead, nil)) then
				return "army_of_the_dead precombat 4";
			end
		end
		if (v61.Outbreak:IsReady() or ((9582 - 5945) >= (12795 - 9025))) then
			if (v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak)) or ((3452 - (1036 + 37)) > (3246 + 1332))) then
				return "outbreak precombat 6";
			end
		end
		if (v61.FesteringStrike:IsReady() or ((940 - 457) > (585 + 158))) then
			if (((3934 - (641 + 839)) > (1491 - (910 + 3))) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(12 - 7))) then
				return "festering_strike precombat 8";
			end
		end
	end
	local function v115()
		v68 = v70.HandleTopTrinket(v64, v29, 1724 - (1466 + 218), nil);
		if (((428 + 502) < (5606 - (556 + 592))) and v68) then
			return v68;
		end
		v68 = v70.HandleBottomTrinket(v64, v29, 15 + 25, nil);
		if (((1470 - (329 + 479)) <= (1826 - (174 + 680))) and v68) then
			return v68;
		end
	end
	local function v116()
		if (((15016 - 10646) == (9057 - 4687)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (8 + 2)))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(769 - (396 + 343))) or ((422 + 4340) <= (2338 - (29 + 1448)))) then
				return "epidemic aoe 2";
			end
		end
		if ((v86:IsReady() and v76) or ((2801 - (135 + 1254)) == (16063 - 11799))) then
			if (v70.CastTargetIf(v86, v93, "max", v102, nil, not v15:IsSpellInRange(v86)) or ((14791 - 11623) < (1435 + 718))) then
				return "wound_spender aoe 4";
			end
		end
		if ((v61.FesteringStrike:IsReady() and not v76) or ((6503 - (389 + 1138)) < (1906 - (102 + 472)))) then
			if (((4368 + 260) == (2567 + 2061)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v15:IsInMeleeRange(5 + 0))) then
				return "festering_strike aoe 6";
			end
		end
		if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((1599 - (320 + 1225)) == (703 - 308))) then
			if (((51 + 31) == (1546 - (157 + 1307))) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil aoe 8";
			end
		end
	end
	local function v117()
		local v150 = 1859 - (821 + 1038);
		while true do
			if (((2 - 1) == v150) or ((64 + 517) < (500 - 218))) then
				if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (4 + 6)))) or ((11423 - 6814) < (3521 - (834 + 192)))) then
					if (((74 + 1078) == (296 + 856)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(1 + 39))) then
						return "epidemic aoe_burst 6";
					end
				end
				if (((2936 - 1040) <= (3726 - (300 + 4))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((265 + 725) > (4240 - 2620))) then
						return "death_coil aoe_burst 8";
					end
				end
				v150 = 364 - (112 + 250);
			end
			if ((v150 == (1 + 1)) or ((2196 - 1319) > (2690 + 2005))) then
				if (((1392 + 1299) >= (1385 + 466)) and v86:IsReady()) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((1481 + 1504) >= (3608 + 1248))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if (((5690 - (1001 + 413)) >= (2664 - 1469)) and (v150 == (882 - (244 + 638)))) then
				if (((3925 - (627 + 66)) <= (13974 - 9284)) and v61.Epidemic:IsReady() and ((v13:Rune() < (603 - (512 + 90))) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (1906 - (1665 + 241))))) and not v77 and ((v94 >= (723 - (373 + 344))) or (v13:RunicPowerDeficit() < (14 + 16)) or (v13:BuffStack(v61.FestermightBuff) == (6 + 14)))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(105 - 65)) or ((1515 - 619) >= (4245 - (35 + 1064)))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (((2228 + 833) >= (6328 - 3370)) and v86:IsReady()) then
					if (((13 + 3174) >= (1880 - (298 + 938))) and v70.CastTargetIf(v86, v93, "max", v102, v112, not v15:IsSpellInRange(v86))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v150 = 1260 - (233 + 1026);
			end
		end
	end
	local function v118()
		local v151 = 1666 - (636 + 1030);
		while true do
			if (((330 + 314) <= (688 + 16)) and (v151 == (1 + 2))) then
				if (((65 + 893) > (1168 - (55 + 166))) and v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (2 + 8)) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) then
					if (((452 + 4040) >= (10135 - 7481)) and v19(v61.DarkTransformation, v54)) then
						return "dark_transformation aoe_cooldowns 14";
					end
				end
				if (((3739 - (36 + 261)) >= (2627 - 1124)) and v61.EmpowerRuneWeapon:IsCastable() and (v14:BuffUp(v61.DarkTransformation))) then
					if (v19(v61.EmpowerRuneWeapon, v49) or ((4538 - (34 + 1334)) <= (563 + 901))) then
						return "empower_rune_weapon aoe_cooldowns 16";
					end
				end
				v151 = 4 + 0;
			end
			if ((v151 == (1285 - (1035 + 248))) or ((4818 - (20 + 1)) == (2287 + 2101))) then
				if (((870 - (134 + 185)) <= (1814 - (549 + 584))) and v61.UnholyAssault:IsCastable()) then
					if (((3962 - (314 + 371)) > (1397 - 990)) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v15:IsInMeleeRange(973 - (478 + 490)), v57)) then
						return "unholy_assault aoe_cooldowns 10";
					end
				end
				if (((2488 + 2207) >= (2587 - (786 + 386))) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
					if (v19(v61.RaiseDead, nil) or ((10403 - 7191) <= (2323 - (1055 + 324)))) then
						return "raise_dead aoe_cooldowns 12";
					end
				end
				v151 = 1343 - (1093 + 247);
			end
			if ((v151 == (4 + 0)) or ((326 + 2770) <= (7138 - 5340))) then
				if (((12003 - 8466) == (10064 - 6527)) and v61.SacrificialPact:IsReady() and ((v14:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (15 - 9))) or (v91 < v13:GCD()))) then
					if (((1365 + 2472) >= (6048 - 4478)) and v19(v61.SacrificialPact, v50)) then
						return "sacrificial_pact aoe_cooldowns 18";
					end
				end
				break;
			end
			if ((v151 == (3 - 2)) or ((2225 + 725) == (9748 - 5936))) then
				if (((5411 - (364 + 324)) >= (6354 - 4036)) and v61.AbominationLimb:IsCastable() and ((v13:Rune() < (4 - 2)) or (v89 > (4 + 6)) or not v61.Festermight:IsAvailable() or (v13:BuffUp(v61.FestermightBuff) and (v13:BuffRemains(v61.FestermightBuff) < (50 - 38))))) then
					if (v19(v61.AbominationLimb, nil, nil, not v15:IsInRange(32 - 12)) or ((6156 - 4129) > (4120 - (1249 + 19)))) then
						return "abomination_limb aoe_cooldowns 6";
					end
				end
				if (v61.Apocalypse:IsReady() or ((1026 + 110) > (16803 - 12486))) then
					if (((5834 - (686 + 400)) == (3726 + 1022)) and v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v15:IsInMeleeRange(234 - (73 + 156)))) then
						return "apocalypse aoe_cooldowns 8";
					end
				end
				v151 = 1 + 1;
			end
			if (((4547 - (721 + 90)) <= (54 + 4686)) and (v151 == (0 - 0))) then
				if ((v61.VileContagion:IsReady() and (v87:CooldownRemains() < (473 - (224 + 246)))) or ((5491 - 2101) <= (5634 - 2574))) then
					if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v15:IsSpellInRange(v61.VileContagion)) or ((182 + 817) > (65 + 2628))) then
						return "vile_contagion aoe_cooldowns 2";
					end
				end
				if (((341 + 122) < (1194 - 593)) and v61.SummonGargoyle:IsReady()) then
					if (v19(v61.SummonGargoyle, v56) or ((7264 - 5081) < (1200 - (203 + 310)))) then
						return "summon_gargoyle aoe_cooldowns 4";
					end
				end
				v151 = 1994 - (1238 + 755);
			end
		end
	end
	local function v119()
		local v152 = 0 + 0;
		while true do
			if (((6083 - (709 + 825)) == (8382 - 3833)) and (v152 == (2 - 0))) then
				if (((5536 - (196 + 668)) == (18446 - 13774)) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v15:IsInMeleeRange(10 - 5)) or ((4501 - (171 + 662)) < (488 - (4 + 89)))) then
						return "festering_strike aoe_setup 10";
					end
				end
				if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((14601 - 10435) == (166 + 289))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((19540 - 15091) == (1045 + 1618))) then
						return "death_coil aoe_setup 12";
					end
				end
				break;
			end
			if ((v152 == (1486 - (35 + 1451))) or ((5730 - (28 + 1425)) < (4982 - (941 + 1052)))) then
				if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (8 + 0)))) or ((2384 - (822 + 692)) >= (5922 - 1773))) then
					if (((1042 + 1170) < (3480 - (45 + 252))) and v19(v88, v48)) then
						return "any_dnd aoe_setup 2";
					end
				end
				if (((4597 + 49) > (1030 + 1962)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
					if (((3489 - 2055) < (3539 - (114 + 319))) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(6 - 1))) then
						return "festering_strike aoe_setup 4";
					end
				end
				v152 = 1 - 0;
			end
			if (((502 + 284) < (4503 - 1480)) and (v152 == (1 - 0))) then
				if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (1973 - (556 + 1407))))) or ((3648 - (741 + 465)) < (539 - (170 + 295)))) then
					if (((2390 + 2145) == (4166 + 369)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(98 - 58))) then
						return "epidemic aoe_setup 6";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) or ((2495 + 514) <= (1350 + 755))) then
					if (((1037 + 793) < (4899 - (957 + 273))) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "festering_strike aoe_setup 8";
					end
				end
				v152 = 1 + 1;
			end
		end
	end
	local function v120()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (2 - 1)) or ((4367 - 2937) >= (17885 - 14273))) then
				if (((4463 - (389 + 1391)) >= (1544 + 916)) and v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (1 + 4))) then
					if (v19(v61.DarkTransformation, v54) or ((4106 - 2302) >= (4226 - (783 + 168)))) then
						return "dark_transformation cooldowns 6";
					end
				end
				if ((v61.Apocalypse:IsReady() and v78) or ((4755 - 3338) > (3570 + 59))) then
					if (((5106 - (309 + 2)) > (1234 - 832)) and v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v15:IsInMeleeRange(1217 - (1090 + 122)), v53)) then
						return "apocalypse cooldowns 8";
					end
				end
				v153 = 1 + 1;
			end
			if (((16164 - 11351) > (2440 + 1125)) and (v153 == (1122 - (628 + 490)))) then
				if (((702 + 3210) == (9685 - 5773)) and v61.SoulReaper:IsReady() and (v94 >= (9 - 7))) then
					if (((3595 - (431 + 343)) <= (9742 - 4918)) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if (((5027 - 3289) <= (1735 + 460)) and ((1 + 1) == v153)) then
				if (((1736 - (556 + 1139)) <= (3033 - (6 + 9))) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (5 + 18))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v14:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v14:BuffUp(v61.DarkTransformation)))) or (v91 <= (11 + 10)))) then
					if (((2314 - (28 + 141)) <= (1590 + 2514)) and v19(v61.EmpowerRuneWeapon, v49)) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if (((3318 - 629) < (3432 + 1413)) and v61.AbominationLimb:IsCastable() and (v13:Rune() < (1320 - (486 + 831))) and v78) then
					if (v19(v61.AbominationLimb) or ((6042 - 3720) > (9230 - 6608))) then
						return "abomination_limb cooldowns 12";
					end
				end
				v153 = 1 + 2;
			end
			if (((0 - 0) == v153) or ((5797 - (668 + 595)) == (1874 + 208))) then
				if ((v61.SummonGargoyle:IsCastable() and (v13:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) or ((317 + 1254) > (5091 - 3224))) then
					if (v19(v61.SummonGargoyle, v56) or ((2944 - (23 + 267)) >= (4940 - (1129 + 815)))) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if (((4365 - (371 + 16)) > (3854 - (1326 + 424))) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
					if (((5672 - 2677) > (5631 - 4090)) and v19(v61.RaiseDead, nil)) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v153 = 119 - (88 + 30);
			end
			if (((4020 - (720 + 51)) > (2119 - 1166)) and (v153 == (1779 - (421 + 1355)))) then
				if ((v61.UnholyAssault:IsReady() and v78) or ((5399 - 2126) > (2247 + 2326))) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v15:IsInMeleeRange(1088 - (286 + 797)), v57) or ((11518 - 8367) < (2126 - 842))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if ((v61.SoulReaper:IsReady() and (v94 == (440 - (397 + 42))) and ((v15:TimeToX(11 + 24) < (805 - (24 + 776))) or (v15:HealthPercentage() <= (53 - 18))) and (v15:TimeToDie() > (790 - (222 + 563)))) or ((4076 - 2226) == (1101 + 428))) then
					if (((1011 - (23 + 167)) < (3921 - (690 + 1108))) and v19(v61.SoulReaper, nil, nil, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v153 = 2 + 2;
			end
		end
	end
	local function v121()
		local v154 = 0 + 0;
		while true do
			if (((1750 - (40 + 808)) < (383 + 1942)) and (v154 == (15 - 11))) then
				if (((821 + 37) <= (1567 + 1395)) and v61.DeathCoil:IsReady() and (v13:Rune() <= (1 + 0))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((4517 - (47 + 524)) < (836 + 452))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
			if ((v154 == (5 - 3)) or ((4847 - 1605) == (1292 - 725))) then
				if ((v29 and v84 and (v85 <= (1749 - (1165 + 561)))) or ((26 + 821) >= (3911 - 2648))) then
					local v186 = 0 + 0;
					while true do
						if (((479 - (341 + 138)) == v186) or ((609 + 1644) == (3819 - 1968))) then
							if (v61.EmpowerRuneWeapon:IsCastable() or ((2413 - (89 + 237)) > (7630 - 5258))) then
								if (v19(v61.EmpowerRuneWeapon, v49) or ((9358 - 4913) < (5030 - (581 + 300)))) then
									return "empower_rune_weapon garg_setup 10";
								end
							end
							if (v61.UnholyAssault:IsCastable() or ((3038 - (855 + 365)) == (201 - 116))) then
								if (((206 + 424) < (3362 - (1030 + 205))) and v19(v61.UnholyAssault, v57, nil, not v15:IsInMeleeRange(5 + 0))) then
									return "unholy_assault garg_setup 12";
								end
							end
							break;
						end
					end
				end
				if ((v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() > (38 + 2))) or not v61.CommanderoftheDead:IsAvailable())) or ((2224 - (156 + 130)) == (5711 - 3197))) then
					if (((7171 - 2916) >= (112 - 57)) and v19(v61.DarkTransformation, v54)) then
						return "dark_transformation garg_setup 16";
					end
				end
				v154 = 1 + 2;
			end
			if (((1749 + 1250) > (1225 - (10 + 59))) and (v154 == (1 + 2))) then
				if (((11573 - 9223) > (2318 - (671 + 492))) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 + 0))) then
					if (((5244 - (369 + 846)) <= (1285 + 3568)) and v19(v88, v48)) then
						return "any_dnd garg_setup 18";
					end
				end
				if ((v61.FesteringStrike:IsReady() and ((v89 == (0 + 0)) or not v61.Apocalypse:IsAvailable() or ((v13:RunicPower() < (1985 - (1036 + 909))) and not v84))) or ((411 + 105) > (5764 - 2330))) then
					if (((4249 - (11 + 192)) >= (1533 + 1500)) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(180 - (135 + 40)))) then
						return "festering_strike garg_setup 20";
					end
				end
				v154 = 9 - 5;
			end
			if ((v154 == (0 + 0)) or ((5989 - 3270) <= (2168 - 721))) then
				if ((v61.Apocalypse:IsReady() and (v89 >= (180 - (50 + 126))) and ((v13:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (63 - 40))) or not v61.CommanderoftheDead:IsAvailable())) or ((915 + 3219) < (5339 - (1233 + 180)))) then
					if (v19(v61.Apocalypse, v53, nil, not v15:IsInMeleeRange(974 - (522 + 447))) or ((1585 - (107 + 1314)) >= (1293 + 1492))) then
						return "apocalypse garg_setup 2";
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (8 - 5)) or v13:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (5 + 5))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) or ((1042 - 517) == (8344 - 6235))) then
					if (((1943 - (716 + 1194)) == (1 + 32)) and v19(v61.ArmyoftheDead)) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v154 = 1 + 0;
			end
			if (((3557 - (74 + 429)) <= (7745 - 3730)) and (v154 == (1 + 0))) then
				if (((4282 - 2411) < (2393 + 989)) and v61.SoulReaper:IsReady() and (v94 == (2 - 1)) and ((v15:TimeToX(86 - 51) < (438 - (279 + 154))) or (v15:HealthPercentage() <= (813 - (454 + 324)))) and (v15:TimeToDie() > (4 + 1))) then
					if (((1310 - (12 + 5)) <= (1168 + 998)) and v19(v61.SoulReaper, nil, nil, not v15:IsInMeleeRange(12 - 7))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if ((v61.SummonGargoyle:IsCastable() and v29 and (v13:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() >= (15 + 25))))) or ((3672 - (277 + 816)) < (525 - 402))) then
					if (v19(v61.SummonGargoyle, v56) or ((2029 - (1058 + 125)) >= (444 + 1924))) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v154 = 977 - (815 + 160);
			end
		end
	end
	local function v122()
		local v155 = 0 - 0;
		while true do
			if ((v155 == (4 - 2)) or ((958 + 3054) <= (9815 - 6457))) then
				if (((3392 - (41 + 1857)) <= (4898 - (1222 + 671))) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (7 - 4))) or (v94 >= (3 - 0))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v13:BuffRemains(v61.PlaguebringerBuff) < v13:GCD())) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((4293 - (229 + 953)) == (3908 - (1111 + 663)))) then
						return "wound_spender high_prio_actions 10";
					end
				end
				if (((3934 - (874 + 705)) == (330 + 2025)) and v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (15 + 6)))) then
					if (v19(v61.UnholyBlight, v58, nil, not v15:IsInRange(16 - 8)) or ((17 + 571) <= (1111 - (642 + 37)))) then
						return "unholy_blight high_prio_actions 12";
					end
				end
				v155 = 1 + 2;
			end
			if (((768 + 4029) >= (9779 - 5884)) and (v155 == (457 - (233 + 221)))) then
				if (((8271 - 4694) == (3149 + 428)) and v61.Outbreak:IsReady()) then
					if (((5335 - (718 + 823)) > (2324 + 1369)) and v70.CastCycle(v61.Outbreak, v93, v113, not v15:IsSpellInRange(v61.Outbreak))) then
						return "outbreak high_prio_actions 14";
					end
				end
				break;
			end
			if ((v155 == (805 - (266 + 539))) or ((3609 - 2334) == (5325 - (636 + 589)))) then
				if (v45 or ((3776 - 2185) >= (7383 - 3803))) then
					local v187 = 0 + 0;
					while true do
						if (((358 + 625) <= (2823 - (657 + 358))) and (v187 == (0 - 0))) then
							if ((v61.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (91 - 51)) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1227 - (1151 + 36))))) or ((2077 + 73) <= (315 + 882))) then
								if (((11255 - 7486) >= (3005 - (1552 + 280))) and v19(v61.AntiMagicShell, v46)) then
									return "antimagic_shell ams_amz 2";
								end
							end
							if (((2319 - (64 + 770)) == (1009 + 476)) and v61.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (158 - 88)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) then
								if (v19(v61.AntiMagicZone, v47) or ((589 + 2726) <= (4025 - (157 + 1086)))) then
									return "antimagic_zone ams_amz 4";
								end
							end
							break;
						end
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (3 - 1))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (153 - 118)))) or ((1343 - 467) >= (4045 - 1081))) then
					if (v19(v61.ArmyoftheDead) or ((3051 - (599 + 220)) > (4972 - 2475))) then
						return "army_of_the_dead high_prio_actions 4";
					end
				end
				v155 = 1932 - (1813 + 118);
			end
			if ((v155 == (1 + 0)) or ((3327 - (841 + 376)) <= (464 - 132))) then
				if (((857 + 2829) > (8657 - 5485)) and v61.DeathCoil:IsReady() and ((v94 <= (862 - (464 + 395))) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (12 - 7)) and (v13:BuffRemains(v61.CommanderoftheDeadBuff) > (13 + 14))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((5311 - (467 + 370)) < (1694 - 874))) then
						return "death_coil high_prio_actions 6";
					end
				end
				if (((3142 + 1137) >= (9879 - 6997)) and v61.Epidemic:IsReady() and (v96 >= (1 + 3)) and ((v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (11 - 6))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(560 - (150 + 370))) or ((3311 - (74 + 1208)) >= (8660 - 5139))) then
						return "epidemic high_prio_actions 8";
					end
				end
				v155 = 9 - 7;
			end
		end
	end
	local function v123()
		local v156 = 0 + 0;
		while true do
			if (((391 - (14 + 376)) == v156) or ((3532 - 1495) >= (3004 + 1638))) then
				if (((1511 + 209) < (4252 + 206)) and v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (8 - 5)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (46 + 14))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (81 - (23 + 55))))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + (6 - 3)))) or ((v94 >= (2 + 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + 3 + 0)))) then
					if (v19(v61.Berserking, v52) or ((675 - 239) > (951 + 2070))) then
						return "berserking racials 6";
					end
				end
				if (((1614 - (652 + 249)) <= (2266 - 1419)) and v61.LightsJudgment:IsCastable() and v13:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v13:BuffRemains(v61.FestermightBuff) < v15:TimeToDie()) or (v13:BuffRemains(v61.UnholyStrengthBuff) < v15:TimeToDie()))) then
					if (((4022 - (708 + 1160)) <= (10941 - 6910)) and v19(v61.LightsJudgment, v52, nil, not v15:IsSpellInRange(v61.LightsJudgment))) then
						return "lights_judgment racials 8";
					end
				end
				v156 = 3 - 1;
			end
			if (((4642 - (10 + 17)) == (1037 + 3578)) and (v156 == (1735 - (1400 + 332)))) then
				if ((v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + (5 - 2)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1968 - (242 + 1666)))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + 2 + 1))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 2 + 1))) or ((v94 >= (2 + 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + (943 - (850 + 90)))))) or ((6638 - 2848) == (1890 - (360 + 1030)))) then
					if (((79 + 10) < (623 - 402)) and v19(v61.Fireblood, v52)) then
						return "fireblood racials 14";
					end
				end
				if (((2825 - 771) >= (3082 - (909 + 752))) and v61.BagofTricks:IsCastable() and (v94 == (1224 - (109 + 1114))) and (v13:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 9 - 4))) then
					if (((270 + 422) < (3300 - (6 + 236))) and v19(v61.BagofTricks, v52, nil, not v15:IsSpellInRange(v61.BagofTricks))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
			if ((v156 == (0 + 0)) or ((2620 + 634) == (3903 - 2248))) then
				if ((v61.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (34 - 14)) and ((v61.SummonGargoyle:CooldownRemains() < v13:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v13:Rune() < (1135 - (1076 + 57))) and (v89 < (1 + 0))))) or ((1985 - (579 + 110)) == (388 + 4522))) then
					if (((2978 + 390) == (1788 + 1580)) and v19(v61.ArcaneTorrent, v52, nil, not v15:IsInRange(415 - (174 + 233)))) then
						return "arcane_torrent racials 2";
					end
				end
				if (((7382 - 4739) < (6695 - 2880)) and v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + 2 + 1) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1234 - (663 + 511)))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + 3 + 0))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + 1 + 2))) or ((v94 >= (5 - 3)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + 2 + 1)))) then
					if (((4503 - 2590) > (1193 - 700)) and v19(v61.BloodFury, v52)) then
						return "blood_fury racials 4";
					end
				end
				v156 = 1 + 0;
			end
			if (((9254 - 4499) > (2444 + 984)) and ((1 + 1) == v156)) then
				if (((2103 - (478 + 244)) <= (2886 - (440 + 77))) and v61.AncestralCall:IsCastable() and ((((9 + 9) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (219 - 159))) and ((v82 and (v83 <= (1574 - (655 + 901)))) or (v80 and (v81 <= (4 + 14))) or ((v94 >= (2 + 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (13 + 5)))) then
					if (v19(v61.AncestralCall, v52) or ((19510 - 14667) == (5529 - (695 + 750)))) then
						return "ancestral_call racials 10";
					end
				end
				if (((15943 - 11274) > (559 - 196)) and v61.ArcanePulse:IsCastable() and ((v94 >= (7 - 5)) or ((v13:Rune() <= (352 - (285 + 66))) and (v13:RunicPowerDeficit() >= (139 - 79))))) then
					if (v19(v61.ArcanePulse, v52, nil, not v15:IsInRange(1318 - (682 + 628))) or ((303 + 1574) >= (3437 - (176 + 123)))) then
						return "arcane_pulse racials 12";
					end
				end
				v156 = 2 + 1;
			end
		end
	end
	local function v124()
		local v157 = 0 + 0;
		while true do
			if (((5011 - (239 + 30)) >= (986 + 2640)) and (v157 == (1 + 0))) then
				if ((v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (3 - 1)) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (40 - 27))) or (v84 and (v85 > (323 - (306 + 9)))) or (v82 and (v83 > (27 - 19))) or (not v76 and (v89 >= (1 + 3))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v14:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 + 0)))) or ((2186 + 2354) == (2619 - 1703))) then
					if (v19(v88, v48) or ((2531 - (1140 + 235)) > (2766 + 1579))) then
						return "any_dnd st 6";
					end
				end
				if (((2052 + 185) < (1091 + 3158)) and v86:IsReady() and (v76 or ((v94 >= (54 - (33 + 19))) and v13:BuffUp(v61.DeathAndDecayBuff)))) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((969 + 1714) < (68 - 45))) then
						return "wound_spender st 8";
					end
				end
				v157 = 1 + 1;
			end
			if (((1366 - 669) <= (775 + 51)) and (v157 == (691 - (586 + 103)))) then
				if (((101 + 1004) <= (3620 - 2444)) and v61.FesteringStrike:IsReady() and not v76) then
					if (((4867 - (1309 + 179)) <= (6881 - 3069)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v15:IsInMeleeRange(3 + 2))) then
						return "festering_strike st 10";
					end
				end
				if (v61.DeathCoil:IsReady() or ((2116 - 1328) >= (1221 + 395))) then
					if (((3938 - 2084) <= (6732 - 3353)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil st 12";
					end
				end
				v157 = 612 - (295 + 314);
			end
			if (((11172 - 6623) == (6511 - (1300 + 662))) and (v157 == (9 - 6))) then
				if ((v86:IsReady() and not v76) or ((4777 - (1178 + 577)) >= (1571 + 1453))) then
					if (((14249 - 9429) > (3603 - (851 + 554))) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if ((v157 == (0 + 0)) or ((2942 - 1881) >= (10622 - 5731))) then
				if (((1666 - (115 + 187)) <= (3426 + 1047)) and v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (10 + 0)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((14166 - 10571) <= (1164 - (160 + 1001)))) then
						return "death_coil st 2";
					end
				end
				if ((v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (9 + 1)))) or ((3224 + 1448) == (7884 - 4032))) then
					if (((1917 - (237 + 121)) == (2456 - (525 + 372))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(75 - 35))) then
						return "epidemic st 4";
					end
				end
				v157 = 3 - 2;
			end
		end
	end
	local function v125()
		if (v33 or ((1894 - (96 + 46)) <= (1565 - (643 + 134)))) then
			local v161 = v115();
			if (v161 or ((1411 + 2496) == (424 - 247))) then
				return v161;
			end
		end
	end
	local function v126()
		local v158 = 0 - 0;
		while true do
			if (((3328 + 142) > (1089 - 534)) and (v158 == (3 - 1))) then
				v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (720 - (316 + 403))) and (v61.UnholyAssault:CooldownRemains() < (14 + 6)) and v61.UnholyAssault:IsAvailable() and v78) or (v15:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (2 - 1))) or (v89 > (2 + 2)) or (v13:HasTier(77 - 46, 3 + 1) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 + 0))))) or ((v91 < (17 - 12)) and (v89 >= (4 - 3)));
				v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (5 - 2)) and (v13:RunicPower() < (4 + 56)) and not v78;
				v158 = 5 - 2;
			end
			if ((v158 == (1 + 2)) or ((2859 - 1887) == (662 - (12 + 5)))) then
				v78 = (v94 == (3 - 2)) or not v28;
				v79 = (v94 >= (3 - 1)) and v28;
				v158 = 8 - 4;
			end
			if (((7890 - 4708) >= (430 + 1685)) and (v158 == (1973 - (1656 + 317)))) then
				v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (3 + 0))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (4 + 0))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (4 - 2)));
				v71 = (v94 >= (14 - 11)) or ((v61.SummonGargoyle:CooldownRemains() > (355 - (5 + 349))) and ((v61.Apocalypse:CooldownRemains() > (4 - 3)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v9.CombatTime() > (1291 - (266 + 1005)));
				v158 = 1 + 0;
			end
			if (((13283 - 9390) < (5830 - 1401)) and (v158 == (1700 - (561 + 1135)))) then
				v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v15:DebuffDown(v61.RottenTouchDebuff)) or (v13:RunicPowerDeficit() < (26 - 6))) and (not v13:HasTier(101 - 70, 1070 - (507 + 559)) or (v13:HasTier(77 - 46, 12 - 8) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v13:RunicPowerDeficit() < (408 - (212 + 176))) or (v13:Rune() < (908 - (250 + 655)))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (5 - 3)) or v61.CoilofDevastation:IsAvailable())) or (v13:Rune() < (5 - 2)) or v84 or v13:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (15 - 5)) and (v89 > (1959 - (1869 + 87)))) or (not v76 and (v89 >= (13 - 9))));
				break;
			end
			if ((v158 == (1902 - (484 + 1417))) or ((6144 - 3277) < (3192 - 1287))) then
				v74 = ((v61.Apocalypse:CooldownRemains() < (783 - (48 + 725))) and (v89 <= (5 - 1)) and (v61.UnholyAssault:CooldownRemains() > (26 - 16)) and (5 + 2)) or (4 - 2);
				if ((not v84 and v61.Festermight:IsAvailable() and v13:BuffUp(v61.FestermightBuff) and ((v13:BuffRemains(v61.FestermightBuff) / ((2 + 3) * v13:GCD())) >= (1 + 0))) or ((2649 - (152 + 701)) >= (5362 - (430 + 881)))) then
					v75 = v89 >= (1 + 0);
				else
					v75 = v89 >= ((898 - (557 + 338)) - v22(v61.InfectedClaws:IsAvailable()));
				end
				v158 = 1 + 1;
			end
		end
	end
	local function v127()
		local v159 = 0 - 0;
		while true do
			if (((5669 - 4050) <= (9978 - 6222)) and (v159 == (8 - 4))) then
				if (((1405 - (499 + 302)) == (1470 - (39 + 827))) and (v70.TargetIsValid() or v13:AffectingCombat())) then
					v90 = v9.BossFightRemains();
					v91 = v90;
					if ((v91 == (30672 - 19561)) or ((10013 - 5529) == (3574 - 2674))) then
						v91 = v9.FightRemains(v93, false);
					end
					v97 = v100(v95);
					v80 = v61.Apocalypse:TimeSinceLastCast() <= (22 - 7);
					v81 = (v80 and ((2 + 13) - v61.Apocalypse:TimeSinceLastCast())) or (0 - 0);
					v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (5 + 25);
					v83 = (v82 and ((47 - 17) - v61.ArmyoftheDead:TimeSinceLastCast())) or (104 - (103 + 1));
					v84 = v92:GargActive();
					v85 = v92:GargRemains();
					v89 = v15:DebuffStack(v61.FesteringWoundDebuff);
				end
				if (v70.TargetIsValid() or ((5013 - (475 + 79)) <= (2405 - 1292))) then
					if (((11622 - 7990) > (440 + 2958)) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v191 = 0 + 0;
						local v192;
						while true do
							if (((5585 - (1395 + 108)) <= (14308 - 9391)) and ((1205 - (7 + 1197)) == v191)) then
								v192 = v70.Interrupt(v61.MindFreeze, 7 + 8, true, v20, v63.MindFreezeMouseover);
								if (((1687 + 3145) >= (1705 - (27 + 292))) and v192) then
									return v192;
								end
								break;
							end
							if (((401 - 264) == (174 - 37)) and (v191 == (0 - 0))) then
								v192 = v70.Interrupt(v61.MindFreeze, 29 - 14, true);
								if (v192 or ((2990 - 1420) >= (4471 - (43 + 96)))) then
									return v192;
								end
								v191 = 4 - 3;
							end
						end
					end
					if (not v13:AffectingCombat() or ((9187 - 5123) <= (1510 + 309))) then
						local v193 = 0 + 0;
						local v194;
						while true do
							if ((v193 == (0 - 0)) or ((1911 + 3075) < (2949 - 1375))) then
								v194 = v114();
								if (((1394 + 3032) > (13 + 159)) and v194) then
									return v194;
								end
								break;
							end
						end
					end
					if (((2337 - (1414 + 337)) > (2395 - (1642 + 298))) and v61.DeathStrike:IsReady() and not v69) then
						if (((2152 - 1326) == (2375 - 1549)) and v19(v61.DeathStrike)) then
							return "death_strike low hp or proc";
						end
					end
					if ((v94 == (0 - 0)) or ((1323 + 2696) > (3456 + 985))) then
						if (((2989 - (357 + 615)) < (2992 + 1269)) and v61.Outbreak:IsReady() and (v97 > (0 - 0))) then
							if (((4041 + 675) > (171 - 91)) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
								return "outbreak out_of_range";
							end
						end
						if ((v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (1 + 0)) and not v77) or ((239 + 3268) == (2057 + 1215))) then
							if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(1341 - (384 + 917))) or ((1573 - (128 + 569)) >= (4618 - (1407 + 136)))) then
								return "epidemic out_of_range";
							end
						end
						if (((6239 - (687 + 1200)) > (4264 - (556 + 1154))) and v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (6 - 4)) and not v77) then
							if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((4501 - (9 + 86)) < (4464 - (275 + 146)))) then
								return "death_coil out_of_range";
							end
						end
					end
					v126();
					local v188 = v122();
					if (v188 or ((308 + 1581) >= (3447 - (29 + 35)))) then
						return v188;
					end
					local v188 = v115();
					if (((8385 - 6493) <= (8165 - 5431)) and v188) then
						return v188;
					end
					if (((8488 - 6565) < (1445 + 773)) and v29 and not v71) then
						local v195 = 1012 - (53 + 959);
						local v196;
						while true do
							if (((2581 - (312 + 96)) > (657 - 278)) and (v195 == (285 - (147 + 138)))) then
								v196 = v121();
								if (v196 or ((3490 - (813 + 86)) == (3081 + 328))) then
									return v196;
								end
								break;
							end
						end
					end
					if (((8363 - 3849) > (3816 - (18 + 474))) and v29 and v78) then
						local v197 = 0 + 0;
						local v198;
						while true do
							if ((v197 == (0 - 0)) or ((1294 - (860 + 226)) >= (5131 - (121 + 182)))) then
								v198 = v120();
								if (v198 or ((195 + 1388) > (4807 - (988 + 252)))) then
									return v198;
								end
								break;
							end
						end
					end
					if ((v28 and v29 and v79) or ((149 + 1164) == (249 + 545))) then
						local v199 = 1970 - (49 + 1921);
						local v200;
						while true do
							if (((4064 - (223 + 667)) > (2954 - (51 + 1))) and (v199 == (0 - 0))) then
								v200 = v118();
								if (((8822 - 4702) <= (5385 - (146 + 979))) and v200) then
									return v200;
								end
								break;
							end
						end
					end
					if (v29 or ((250 + 633) > (5383 - (311 + 294)))) then
						local v201 = 0 - 0;
						local v202;
						while true do
							if ((v201 == (0 + 0)) or ((5063 - (496 + 947)) >= (6249 - (1233 + 125)))) then
								v202 = v123();
								if (((1728 + 2530) > (841 + 96)) and v202) then
									return v202;
								end
								break;
							end
						end
					end
					if (v28 or ((926 + 3943) < (2551 - (963 + 682)))) then
						local v203 = 0 + 0;
						while true do
							if (((1504 - (504 + 1000)) == v203) or ((825 + 400) > (3851 + 377))) then
								if (((315 + 3013) > (3300 - 1062)) and v79 and (v87:CooldownRemains() < (9 + 1)) and v13:BuffDown(v61.DeathAndDecayBuff)) then
									local v205 = 0 + 0;
									local v206;
									while true do
										if (((4021 - (156 + 26)) > (810 + 595)) and (v205 == (0 - 0))) then
											v206 = v119();
											if (v206 or ((1457 - (149 + 15)) <= (1467 - (890 + 70)))) then
												return v206;
											end
											break;
										end
									end
								end
								if (((v94 >= (121 - (39 + 78))) and v13:BuffUp(v61.DeathAndDecayBuff)) or ((3378 - (14 + 468)) < (1770 - 965))) then
									local v207 = 0 - 0;
									local v208;
									while true do
										if (((1195 + 1121) == (1391 + 925)) and (v207 == (0 + 0))) then
											v208 = v117();
											if (v208 or ((1161 + 1409) == (402 + 1131))) then
												return v208;
											end
											break;
										end
									end
								end
								v203 = 1 - 0;
							end
							if ((v203 == (1 + 0)) or ((3102 - 2219) == (37 + 1423))) then
								if (((v94 >= (55 - (12 + 39))) and (((v87:CooldownRemains() > (10 + 0)) and v13:BuffDown(v61.DeathAndDecayBuff)) or not v79)) or ((14297 - 9678) <= (3557 - 2558))) then
									local v209 = v116();
									if (v209 or ((1011 + 2399) > (2167 + 1949))) then
										return v209;
									end
								end
								break;
							end
						end
					end
					if ((v94 <= (7 - 4)) or ((602 + 301) >= (14783 - 11724))) then
						local v204 = v124();
						if (v204 or ((5686 - (1596 + 114)) < (7459 - 4602))) then
							return v204;
						end
					end
					if (((5643 - (164 + 549)) > (3745 - (1059 + 379))) and v61.FesteringStrike:IsReady()) then
						if (v19(v61.FesteringStrike, nil, nil) or ((5023 - 977) < (670 + 621))) then
							return "festering_strike precombat 8";
						end
					end
				end
				break;
			end
			if ((v159 == (0 + 0)) or ((4633 - (145 + 247)) == (2909 + 636))) then
				v60();
				v27 = EpicSettings.Toggles['ooc'];
				v159 = 1 + 0;
			end
			if ((v159 == (5 - 3)) or ((777 + 3271) > (3646 + 586))) then
				v69 = not v99();
				v93 = v13:GetEnemiesInMeleeRange(7 - 2);
				v159 = 723 - (254 + 466);
			end
			if ((v159 == (561 - (544 + 16))) or ((5561 - 3811) >= (4101 - (294 + 334)))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v159 = 255 - (236 + 17);
			end
			if (((1365 + 1801) == (2465 + 701)) and (v159 == (10 - 7))) then
				v95 = v15:GetEnemiesInSplashRange(47 - 37);
				if (((908 + 855) < (3068 + 656)) and v28) then
					local v189 = 794 - (413 + 381);
					while true do
						if (((3 + 54) <= (5790 - 3067)) and (v189 == (0 - 0))) then
							v94 = #v93;
							v96 = v15:GetEnemiesInSplashRangeCount(1980 - (582 + 1388));
							break;
						end
					end
				else
					local v190 = 0 - 0;
					while true do
						if ((v190 == (0 + 0)) or ((2434 - (326 + 38)) == (1310 - 867))) then
							v94 = 1 - 0;
							v96 = 621 - (47 + 573);
							break;
						end
					end
				end
				v159 = 2 + 2;
			end
		end
	end
	local function v128()
		local v160 = 0 - 0;
		while true do
			if (((0 - 0) == v160) or ((4369 - (1269 + 395)) == (1885 - (76 + 416)))) then
				v61.VirulentPlagueDebuff:RegisterAuraTracking();
				v61.FesteringWoundDebuff:RegisterAuraTracking();
				v160 = 444 - (319 + 124);
			end
			if ((v160 == (2 - 1)) or ((5608 - (564 + 443)) < (168 - 107))) then
				v9.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(710 - (337 + 121), v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

