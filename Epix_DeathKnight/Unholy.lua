local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1490 + 1168) >= (3775 - 2294)) and not v5) then
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
		local v129 = 387 - (370 + 17);
		while true do
			if ((v129 == (1296 - (783 + 508))) or ((4992 - (1733 + 39)) == (3748 - 2384))) then
				v54 = EpicSettings.Settings['DarkTransformationGCD'];
				v55 = EpicSettings.Settings['EpidemicGCD'];
				v56 = EpicSettings.Settings['SummonGargoyleGCD'];
				v57 = EpicSettings.Settings['UnholyAssaultGCD'];
				v129 = 1040 - (125 + 909);
			end
			if ((v129 == (1949 - (1096 + 852))) or ((473 + 581) > (4843 - 1451))) then
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptWithStun'] or (512 - (409 + 103));
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (236 - (46 + 190));
				v129 = 97 - (51 + 44);
			end
			if ((v129 == (1 + 2)) or ((1993 - (1114 + 203)) >= (2368 - (228 + 498)))) then
				v46 = EpicSettings.Settings['AntiMagicShellGCD'];
				v47 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v48 = EpicSettings.Settings['DeathAndDecayGCD'];
				v49 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v129 = 1 + 3;
			end
			if (((2285 + 1851) > (3060 - (174 + 489))) and ((15 - 9) == v129)) then
				v58 = EpicSettings.Settings['UnholyBlightGCD'];
				v59 = EpicSettings.Settings['VileContagionGCD'];
				break;
			end
			if ((v129 == (1909 - (830 + 1075))) or ((4858 - (303 + 221)) == (5514 - (231 + 1038)))) then
				v50 = EpicSettings.Settings['SacrificialPactGCD'];
				v51 = EpicSettings.Settings['MindFreezeOffGCD'];
				v52 = EpicSettings.Settings['RacialsOffGCD'];
				v53 = EpicSettings.Settings['ApocalypseGCD'];
				v129 = 5 + 0;
			end
			if ((v129 == (1164 - (171 + 991))) or ((17622 - 13346) <= (8138 - 5107))) then
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 + 0);
				v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 - 0);
				v45 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v129 = 8 - 5;
			end
			if ((v129 == (0 - 0)) or ((14782 - 10000) <= (2447 - (111 + 1137)))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (158 - (91 + 67));
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v129 = 1 + 0;
			end
		end
	end
	local v61 = v16.DeathKnight.Unholy;
	local v62 = v18.DeathKnight.Unholy;
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {};
	local v65 = v13:GetEquipment();
	local v66 = (v65[536 - (423 + 100)] and v18(v65[1 + 12])) or v18(0 - 0);
	local v67 = (v65[8 + 6] and v18(v65[785 - (326 + 445)])) or v18(0 - 0);
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
	local v90 = 24753 - 13642;
	local v91 = 25935 - 14824;
	local v92 = v9.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v65 = v13:GetEquipment();
		v66 = (v65[29 - 16] and v18(v65[37 - 24])) or v18(0 + 0);
		v67 = (v65[24 - 10] and v18(v65[28 - 14])) or v18(1812 - (1293 + 519));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v90 = 22669 - 11558;
		v91 = 29010 - 17899;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (0 - 0)) or ((11458 - 6594) < (1008 + 894))) then
				v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
				v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
				v130 = 1 + 0;
			end
			if (((11242 - 6403) >= (856 + 2844)) and (v130 == (1 + 0))) then
				v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v13:HealthPercentage() < v43) or ((v13:HealthPercentage() < v44) and v13:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v131)
		local v132 = 0 + 0;
		local v133;
		while true do
			if (((1096 - (709 + 387)) == v132) or ((2933 - (673 + 1185)) > (5562 - 3644))) then
				v133 = 0 - 0;
				for v183, v184 in pairs(v131) do
					if (((651 - 255) <= (2721 + 1083)) and v184:DebuffDown(v61.VirulentPlagueDebuff)) then
						v133 = v133 + 1 + 0;
					end
				end
				v132 = 1 - 0;
			end
			if ((v132 == (1 + 0)) or ((8312 - 4143) == (4293 - 2106))) then
				return v133;
			end
		end
	end
	local function v101(v134)
		local v135 = 1880 - (446 + 1434);
		local v136;
		while true do
			if (((2689 - (1040 + 243)) == (4196 - 2790)) and (v135 == (1847 - (559 + 1288)))) then
				v136 = {};
				for v185 in pairs(v134) do
					if (((3462 - (609 + 1322)) < (4725 - (13 + 441))) and not v12:IsInBossList(v134[v185]['UnitNPCID'])) then
						v30(v136, v134[v185]);
					end
				end
				v135 = 3 - 2;
			end
			if (((1663 - 1028) == (3162 - 2527)) and ((1 + 0) == v135)) then
				return v9.FightRemains(v136);
			end
		end
	end
	local function v102(v137)
		return (v137:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v138)
		return (v138:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v139)
		return (v61.BurstingSores:IsAvailable() and v139:DebuffUp(v61.FesteringWoundDebuff) and ((v13:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v13:Rune() < (10 - 7))) or (v13:BuffUp(v61.DeathAndDecayBuff) and (v13:Rune() == (0 + 0))))) or (not v61.BurstingSores:IsAvailable() and (v139:DebuffStack(v61.FesteringWoundDebuff) >= (2 + 2))) or (v13:HasTier(91 - 60, 2 + 0) and v139:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v140)
		return v140:DebuffStack(v61.FesteringWoundDebuff) >= (7 - 3);
	end
	local function v106(v141)
		return v141:DebuffStack(v61.FesteringWoundDebuff) < (3 + 1);
	end
	local function v107(v142)
		return v142:DebuffStack(v61.FesteringWoundDebuff) < (3 + 1);
	end
	local function v108(v143)
		return v143:DebuffStack(v61.FesteringWoundDebuff) >= (3 + 1);
	end
	local function v109(v144)
		return ((v144:TimeToX(30 + 5) < (5 + 0)) or (v144:HealthPercentage() <= (468 - (153 + 280)))) and (v144:TimeToDie() > (v144:DebuffRemains(v61.SoulReaper) + (14 - 9)));
	end
	local function v110(v145)
		return (v145:DebuffStack(v61.FesteringWoundDebuff) <= (2 + 0)) or v14:BuffUp(v61.DarkTransformation);
	end
	local function v111(v146)
		return (v146:DebuffStack(v61.FesteringWoundDebuff) >= (2 + 2)) and (v87:CooldownRemains() < (2 + 1));
	end
	local function v112(v147)
		return v147:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v148)
		return (v148:TimeToDie() > v148:DebuffRemains(v61.VirulentPlagueDebuff)) and (v148:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v148:DebuffRefreshable(v61.FrostFeverDebuff) or v148:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((11 + 4) / ((v22(v61.Superstrain:IsAvailable()) * (4 - 1)) + (v22(v61.Plaguebringer:IsAvailable()) * (2 + 0)) + (v22(v61.EbonFever:IsAvailable()) * (669 - (89 + 578))))))));
	end
	local function v114()
		local v149 = 0 + 0;
		while true do
			if (((7011 - 3638) <= (4605 - (572 + 477))) and (v149 == (1 + 0))) then
				if (v61.Outbreak:IsReady() or ((1976 + 1315) < (392 + 2888))) then
					if (((4472 - (84 + 2)) >= (1438 - 565)) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
						return "outbreak precombat 6";
					end
				end
				if (((664 + 257) <= (1944 - (497 + 345))) and v61.FesteringStrike:IsReady()) then
					if (((121 + 4585) >= (163 + 800)) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(1338 - (605 + 728)))) then
						return "festering_strike precombat 8";
					end
				end
				break;
			end
			if ((v149 == (0 + 0)) or ((2134 - 1174) <= (41 + 835))) then
				if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive() or not v14:IsActive())) or ((7638 - 5572) == (841 + 91))) then
					if (((13368 - 8543) < (3657 + 1186)) and v19(v61.RaiseDead, nil)) then
						return "raise_dead precombat 2 displaystyle";
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v29) or ((4366 - (457 + 32)) >= (1925 + 2612))) then
					if (v19(v61.ArmyoftheDead, nil) or ((5717 - (832 + 570)) < (1627 + 99))) then
						return "army_of_the_dead precombat 4";
					end
				end
				v149 = 1 + 0;
			end
		end
	end
	local function v115()
		local v150 = 0 - 0;
		while true do
			if ((v150 == (0 + 0)) or ((4475 - (588 + 208)) < (1684 - 1059))) then
				v68 = v70.HandleTopTrinket(v64, v29, 1840 - (884 + 916), nil);
				if (v68 or ((9682 - 5057) < (367 + 265))) then
					return v68;
				end
				v150 = 654 - (232 + 421);
			end
			if (((1890 - (1569 + 320)) == v150) or ((21 + 62) > (339 + 1441))) then
				v68 = v70.HandleBottomTrinket(v64, v29, 134 - 94, nil);
				if (((1151 - (316 + 289)) <= (2819 - 1742)) and v68) then
					return v68;
				end
				break;
			end
		end
	end
	local function v116()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (1453 - (666 + 787))) or ((1421 - (360 + 65)) > (4020 + 281))) then
				if (((4324 - (79 + 175)) > (1082 - 395)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (8 + 2)))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(91 - 61)) or ((1263 - 607) >= (4229 - (503 + 396)))) then
						return "epidemic aoe 2";
					end
				end
				if ((v86:IsReady() and v76) or ((2673 - (92 + 89)) <= (649 - 314))) then
					if (((2217 + 2105) >= (1517 + 1045)) and v70.CastTargetIf(v86, v93, "max", v102, nil, not v15:IsSpellInRange(v86))) then
						return "wound_spender aoe 4";
					end
				end
				v151 = 3 - 2;
			end
			if ((v151 == (1 + 0)) or ((8292 - 4655) >= (3290 + 480))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((1137 + 1242) > (13942 - 9364))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v15:IsInMeleeRange(1 + 4)) or ((736 - 253) > (1987 - (485 + 759)))) then
						return "festering_strike aoe 6";
					end
				end
				if (((5677 - 3223) > (1767 - (442 + 747))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (((2065 - (832 + 303)) < (5404 - (88 + 858))) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v117()
		if (((202 + 460) <= (805 + 167)) and v61.Epidemic:IsReady() and ((v13:Rune() < (1 + 0)) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (789 - (766 + 23))))) and not v77 and ((v94 >= (29 - 23)) or (v13:RunicPowerDeficit() < (41 - 11)) or (v13:BuffStack(v61.FestermightBuff) == (52 - 32)))) then
			if (((14831 - 10461) == (5443 - (1036 + 37))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(29 + 11))) then
				return "epidemic aoe_burst 2";
			end
		end
		if (v86:IsReady() or ((9273 - 4511) <= (678 + 183))) then
			if (v70.CastTargetIf(v86, v93, "max", v102, v112, not v15:IsSpellInRange(v86)) or ((2892 - (641 + 839)) == (5177 - (910 + 3)))) then
				return "wound_spender aoe_burst 4";
			end
		end
		if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (25 - 15)))) or ((4852 - (1466 + 218)) < (990 + 1163))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(1188 - (556 + 592))) or ((1770 + 3206) < (2140 - (329 + 479)))) then
				return "epidemic aoe_burst 6";
			end
		end
		if (((5482 - (174 + 680)) == (15902 - 11274)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((111 - 57) == (283 + 112))) then
				return "death_coil aoe_burst 8";
			end
		end
		if (((821 - (396 + 343)) == (8 + 74)) and v86:IsReady()) then
			if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((2058 - (29 + 1448)) < (1671 - (135 + 1254)))) then
				return "wound_spender aoe_burst 10";
			end
		end
	end
	local function v118()
		if ((v61.VileContagion:IsReady() and (v87:CooldownRemains() < (11 - 8))) or ((21519 - 16910) < (1663 + 832))) then
			if (((2679 - (389 + 1138)) == (1726 - (102 + 472))) and v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v15:IsSpellInRange(v61.VileContagion))) then
				return "vile_contagion aoe_cooldowns 2";
			end
		end
		if (((1790 + 106) <= (1898 + 1524)) and v61.SummonGargoyle:IsReady()) then
			if (v19(v61.SummonGargoyle, v56) or ((924 + 66) > (3165 - (320 + 1225)))) then
				return "summon_gargoyle aoe_cooldowns 4";
			end
		end
		if ((v61.AbominationLimb:IsCastable() and ((v13:Rune() < (2 - 0)) or (v89 > (7 + 3)) or not v61.Festermight:IsAvailable() or (v13:BuffUp(v61.FestermightBuff) and (v13:BuffRemains(v61.FestermightBuff) < (1476 - (157 + 1307)))))) or ((2736 - (821 + 1038)) > (11713 - 7018))) then
			if (((295 + 2396) >= (3287 - 1436)) and v19(v61.AbominationLimb, nil, nil, not v15:IsInRange(8 + 12))) then
				return "abomination_limb aoe_cooldowns 6";
			end
		end
		if (v61.Apocalypse:IsReady() or ((7398 - 4413) >= (5882 - (834 + 192)))) then
			if (((272 + 4004) >= (307 + 888)) and v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v15:IsInMeleeRange(1 + 4))) then
				return "apocalypse aoe_cooldowns 8";
			end
		end
		if (((5006 - 1774) <= (4994 - (300 + 4))) and v61.UnholyAssault:IsCastable()) then
			if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v15:IsInMeleeRange(2 + 3), v57) or ((2345 - 1449) >= (3508 - (112 + 250)))) then
				return "unholy_assault aoe_cooldowns 10";
			end
		end
		if (((1221 + 1840) >= (7410 - 4452)) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
			if (((1826 + 1361) >= (334 + 310)) and v19(v61.RaiseDead, nil)) then
				return "raise_dead aoe_cooldowns 12";
			end
		end
		if (((482 + 162) <= (350 + 354)) and v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (8 + 2)) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) then
			if (((2372 - (1001 + 413)) > (2111 - 1164)) and v19(v61.DarkTransformation, nil, nil, not v15:IsInMeleeRange(890 - (244 + 638)))) then
				return "dark_transformation aoe_cooldowns 14";
			end
		end
		if (((5185 - (627 + 66)) >= (7907 - 5253)) and v61.EmpowerRuneWeapon:IsCastable() and (v14:BuffUp(v61.DarkTransformation))) then
			if (((4044 - (512 + 90)) >= (3409 - (1665 + 241))) and v19(v61.EmpowerRuneWeapon, v49)) then
				return "empower_rune_weapon aoe_cooldowns 16";
			end
		end
		if ((v61.SacrificialPact:IsReady() and ((v14:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (723 - (373 + 344)))) or (v91 < v13:GCD()))) or ((1430 + 1740) <= (388 + 1076))) then
			if (v19(v61.SacrificialPact, v50) or ((12653 - 7856) == (7425 - 3037))) then
				return "sacrificial_pact aoe_cooldowns 18";
			end
		end
	end
	local function v119()
		local v152 = 1099 - (35 + 1064);
		while true do
			if (((401 + 150) <= (1456 - 775)) and (v152 == (1 + 0))) then
				if (((4513 - (298 + 938)) > (1666 - (233 + 1026))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (1676 - (636 + 1030))))) then
					if (((2401 + 2294) >= (1383 + 32)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(12 + 28))) then
						return "epidemic aoe_setup 6";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) or ((218 + 2994) <= (1165 - (55 + 166)))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(1 + 4)) or ((312 + 2784) <= (6866 - 5068))) then
						return "festering_strike aoe_setup 8";
					end
				end
				v152 = 299 - (36 + 261);
			end
			if (((6185 - 2648) == (4905 - (34 + 1334))) and (v152 == (1 + 1))) then
				if (((2982 + 855) >= (2853 - (1035 + 248))) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v15:IsInMeleeRange(26 - (20 + 1))) or ((1537 + 1413) == (4131 - (134 + 185)))) then
						return "festering_strike aoe_setup 10";
					end
				end
				if (((5856 - (549 + 584)) >= (3003 - (314 + 371))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((6958 - 4931) > (3820 - (478 + 490)))) then
						return "death_coil aoe_setup 12";
					end
				end
				break;
			end
			if ((v152 == (0 + 0)) or ((2308 - (786 + 386)) > (13982 - 9665))) then
				if (((6127 - (1055 + 324)) == (6088 - (1093 + 247))) and v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (8 + 0))) and not v13:IsMoving() and (v94 >= (1 + 0))) then
					if (((14832 - 11096) <= (16086 - 11346)) and v19(v88, v48)) then
						return "any_dnd aoe_setup 2";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) or ((9646 - 6256) <= (7689 - 4629))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(2 + 3)) or ((3848 - 2849) > (9282 - 6589))) then
						return "festering_strike aoe_setup 4";
					end
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v120()
		local v153 = 0 - 0;
		while true do
			if (((1151 - (364 + 324)) < (1647 - 1046)) and (v153 == (0 - 0))) then
				if ((v61.SummonGargoyle:IsCastable() and (v13:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) or ((724 + 1459) < (2874 - 2187))) then
					if (((7284 - 2735) == (13815 - 9266)) and v19(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if (((5940 - (1249 + 19)) == (4218 + 454)) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
					if (v19(v61.RaiseDead, nil) or ((14277 - 10609) < (1481 - (686 + 400)))) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v153 = 1 + 0;
			end
			if ((v153 == (231 - (73 + 156))) or ((20 + 4146) == (1266 - (721 + 90)))) then
				if ((v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (1 + 22))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v14:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v14:BuffUp(v61.DarkTransformation)))) or (v91 <= (68 - 47)))) or ((4919 - (224 + 246)) == (4313 - 1650))) then
					if (v19(v61.EmpowerRuneWeapon, v49) or ((7874 - 3597) < (543 + 2446))) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if ((v61.AbominationLimb:IsCastable() and (v13:Rune() < (1 + 2)) and v78) or ((639 + 231) >= (8248 - 4099))) then
					if (((7360 - 5148) < (3696 - (203 + 310))) and v19(v61.AbominationLimb)) then
						return "abomination_limb cooldowns 12";
					end
				end
				v153 = 1996 - (1238 + 755);
			end
			if (((325 + 4321) > (4526 - (709 + 825))) and (v153 == (7 - 3))) then
				if (((2088 - 654) < (3970 - (196 + 668))) and v61.SoulReaper:IsReady() and (v94 >= (7 - 5))) then
					if (((1628 - 842) < (3856 - (171 + 662))) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if ((v153 == (96 - (4 + 89))) or ((8558 - 6116) < (27 + 47))) then
				if (((19918 - 15383) == (1779 + 2756)) and v61.UnholyAssault:IsReady() and v78) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v15:IsInMeleeRange(1491 - (35 + 1451)), v57) or ((4462 - (28 + 1425)) <= (4098 - (941 + 1052)))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if (((1755 + 75) < (5183 - (822 + 692))) and v61.SoulReaper:IsReady() and (v94 == (1 - 0)) and ((v15:TimeToX(17 + 18) < (302 - (45 + 252))) or (v15:HealthPercentage() <= (35 + 0))) and (v15:TimeToDie() > (2 + 3))) then
					if (v19(v61.SoulReaper, nil, nil, not v15:IsSpellInRange(v61.SoulReaper)) or ((3480 - 2050) >= (4045 - (114 + 319)))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v153 = 5 - 1;
			end
			if (((3437 - 754) >= (1569 + 891)) and (v153 == (1 - 0))) then
				if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (10 - 5))) or ((3767 - (556 + 1407)) >= (4481 - (741 + 465)))) then
					if (v19(v61.DarkTransformation, nil, nil, not v15:IsInMeleeRange(473 - (170 + 295))) or ((747 + 670) > (3334 + 295))) then
						return "dark_transformation cooldowns 6";
					end
				end
				if (((11805 - 7010) > (334 + 68)) and v61.Apocalypse:IsReady() and v78) then
					if (((3087 + 1726) > (2019 + 1546)) and v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v15:IsInMeleeRange(1235 - (957 + 273)))) then
						return "apocalypse cooldowns 8";
					end
				end
				v153 = 1 + 1;
			end
		end
	end
	local function v121()
		local v154 = 0 + 0;
		while true do
			if (((14906 - 10994) == (10308 - 6396)) and (v154 == (11 - 7))) then
				if (((13968 - 11147) <= (6604 - (389 + 1391))) and v61.DeathCoil:IsReady() and (v13:Rune() <= (1 + 0))) then
					if (((181 + 1557) <= (4997 - 2802)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
			if (((992 - (783 + 168)) <= (10128 - 7110)) and (v154 == (2 + 0))) then
				if (((2456 - (309 + 2)) <= (12602 - 8498)) and v29 and v84 and (v85 <= (1235 - (1090 + 122)))) then
					local v198 = 0 + 0;
					while true do
						if (((9030 - 6341) < (3316 + 1529)) and (v198 == (1118 - (628 + 490)))) then
							if (v61.EmpowerRuneWeapon:IsCastable() or ((417 + 1905) > (6491 - 3869))) then
								if (v19(v61.EmpowerRuneWeapon, v49) or ((20720 - 16186) == (2856 - (431 + 343)))) then
									return "empower_rune_weapon garg_setup 10";
								end
							end
							if (v61.UnholyAssault:IsCastable() or ((3172 - 1601) > (5400 - 3533))) then
								if (v19(v61.UnholyAssault, v57, nil, not v15:IsInMeleeRange(4 + 1)) or ((340 + 2314) >= (4691 - (556 + 1139)))) then
									return "unholy_assault garg_setup 12";
								end
							end
							break;
						end
					end
				end
				if (((3993 - (6 + 9)) > (386 + 1718)) and v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() > (21 + 19))) or not v61.CommanderoftheDead:IsAvailable())) then
					if (((3164 - (28 + 141)) > (597 + 944)) and v19(v61.DarkTransformation, nil, nil, not v15:IsInMeleeRange(9 - 1))) then
						return "dark_transformation garg_setup 16";
					end
				end
				v154 = 3 + 0;
			end
			if (((4566 - (486 + 831)) > (2479 - 1526)) and ((0 - 0) == v154)) then
				if ((v61.Apocalypse:IsReady() and (v89 >= (1 + 3)) and ((v13:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (72 - 49))) or not v61.CommanderoftheDead:IsAvailable())) or ((4536 - (668 + 595)) > (4115 + 458))) then
					if (v19(v61.Apocalypse, nil, not v15:IsInMeleeRange(2 + 3)) or ((8593 - 5442) < (1574 - (23 + 267)))) then
						return "apocalypse garg_setup 2";
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (1947 - (1129 + 815))) or v13:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (397 - (371 + 16)))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) or ((3600 - (1326 + 424)) == (2895 - 1366))) then
					if (((3000 - 2179) < (2241 - (88 + 30))) and v19(v61.ArmyoftheDead)) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v154 = 772 - (720 + 51);
			end
			if (((2006 - 1104) < (4101 - (421 + 1355))) and (v154 == (1 - 0))) then
				if (((422 + 436) <= (4045 - (286 + 797))) and v61.SoulReaper:IsReady() and (v94 == (3 - 2)) and ((v15:TimeToX(57 - 22) < (444 - (397 + 42))) or (v15:HealthPercentage() <= (11 + 24))) and (v15:TimeToDie() > (805 - (24 + 776)))) then
					if (v19(v61.SoulReaper, nil, nil, not v15:IsInMeleeRange(7 - 2)) or ((4731 - (222 + 563)) < (2837 - 1549))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if ((v61.SummonGargoyle:IsCastable() and v29 and (v13:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() >= (29 + 11))))) or ((3432 - (23 + 167)) == (2365 - (690 + 1108)))) then
					if (v19(v61.SummonGargoyle, v56) or ((306 + 541) >= (1042 + 221))) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v154 = 850 - (40 + 808);
			end
			if ((v154 == (1 + 2)) or ((8615 - 6362) == (1770 + 81))) then
				if ((v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 + 0)) and not v13:IsMoving() and (v94 >= (1 + 0))) or ((2658 - (47 + 524)) > (1540 + 832))) then
					if (v19(v88, v48) or ((12150 - 7705) < (6203 - 2054))) then
						return "any_dnd garg_setup 18";
					end
				end
				if ((v61.FesteringStrike:IsReady() and ((v89 == (0 - 0)) or not v61.Apocalypse:IsAvailable() or ((v13:RunicPower() < (1766 - (1165 + 561))) and not v84))) or ((55 + 1763) == (263 - 178))) then
					if (((241 + 389) < (2606 - (341 + 138))) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "festering_strike garg_setup 20";
					end
				end
				v154 = 7 - 3;
			end
		end
	end
	local function v122()
		local v155 = v70.HandleDPSPotion();
		if (v155 or ((2264 - (89 + 237)) == (8087 - 5573))) then
			return "DPS Pot";
		end
		if (((8958 - 4703) >= (936 - (581 + 300))) and v45) then
			local v162 = 1220 - (855 + 365);
			while true do
				if (((7123 - 4124) > (378 + 778)) and (v162 == (1235 - (1030 + 205)))) then
					if (((2207 + 143) > (1075 + 80)) and v61.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (326 - (156 + 130))) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (90 - 50)))) then
						if (((6789 - 2760) <= (9939 - 5086)) and v19(v61.AntiMagicShell, v46)) then
							return "antimagic_shell ams_amz 2";
						end
					end
					if ((v61.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (19 + 51)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) or ((301 + 215) > (3503 - (10 + 59)))) then
						if (((1145 + 2901) >= (14936 - 11903)) and v19(v61.AntiMagicZone, v47)) then
							return "antimagic_zone ams_amz 4";
						end
					end
					break;
				end
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (1165 - (671 + 492)))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (28 + 7)))) or ((3934 - (369 + 846)) <= (384 + 1063))) then
			if (v19(v61.ArmyoftheDead) or ((3528 + 606) < (5871 - (1036 + 909)))) then
				return "army_of_the_dead high_prio_actions 4";
			end
		end
		if ((v61.DeathCoil:IsReady() and ((v94 <= (3 + 0)) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (8 - 3)) and (v13:BuffRemains(v61.CommanderoftheDeadBuff) > (230 - (11 + 192)))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) or ((83 + 81) >= (2960 - (135 + 40)))) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((1271 - 746) == (1272 + 837))) then
				return "death_coil high_prio_actions 6";
			end
		end
		if (((72 - 39) == (49 - 16)) and v61.Epidemic:IsReady() and (v96 >= (180 - (50 + 126))) and ((v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (13 - 8))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
			if (((676 + 2378) <= (5428 - (1233 + 180))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(1009 - (522 + 447)))) then
				return "epidemic high_prio_actions 8";
			end
		end
		if (((3292 - (107 + 1314)) < (1570 + 1812)) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (8 - 5))) or (v94 >= (2 + 1))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v13:BuffRemains(v61.PlaguebringerBuff) < v13:GCD())) then
			if (((2567 - 1274) <= (8570 - 6404)) and v19(v86, nil, nil, not v15:IsSpellInRange(v86))) then
				return "wound_spender high_prio_actions 10";
			end
		end
		if ((v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (1931 - (716 + 1194))))) or ((45 + 2534) < (14 + 109))) then
			if (v19(v61.UnholyBlight, v58, nil, not v15:IsInRange(511 - (74 + 429))) or ((1631 - 785) >= (1174 + 1194))) then
				return "unholy_blight high_prio_actions 12";
			end
		end
		if (v61.Outbreak:IsReady() or ((9183 - 5171) <= (2376 + 982))) then
			if (((4605 - 3111) <= (7430 - 4425)) and v70.CastCycle(v61.Outbreak, v93, v113, not v15:IsSpellInRange(v61.Outbreak))) then
				return "outbreak high_prio_actions 14";
			end
		end
	end
	local function v123()
		local v156 = 433 - (279 + 154);
		while true do
			if (((778 - (454 + 324)) == v156) or ((2448 + 663) == (2151 - (12 + 5)))) then
				if (((1270 + 1085) == (6000 - 3645)) and v61.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (8 + 12)) and ((v61.SummonGargoyle:CooldownRemains() < v13:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v13:Rune() < (1095 - (277 + 816))) and (v89 < (4 - 3))))) then
					if (v19(v61.ArcaneTorrent, v52, nil, not v15:IsInRange(1191 - (1058 + 125))) or ((111 + 477) <= (1407 - (815 + 160)))) then
						return "arcane_torrent racials 2";
					end
				end
				if (((20582 - 15785) >= (9246 - 5351)) and v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (175 - 115))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (1901 - (41 + 1857))))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + (1896 - (1222 + 671))))) or ((v94 >= (5 - 3)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + (3 - 0))))) then
					if (((4759 - (229 + 953)) == (5351 - (1111 + 663))) and v19(v61.BloodFury, v52)) then
						return "blood_fury racials 4";
					end
				end
				v156 = 1580 - (874 + 705);
			end
			if (((532 + 3262) > (2520 + 1173)) and (v156 == (6 - 3))) then
				if ((v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (739 - (642 + 37)))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + 1 + 2))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 1 + 2))) or ((v94 >= (4 - 2)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + (457 - (233 + 221)))))) or ((2948 - 1673) == (3609 + 491))) then
					if (v19(v61.Fireblood, v52) or ((3132 - (718 + 823)) >= (2253 + 1327))) then
						return "fireblood racials 14";
					end
				end
				if (((1788 - (266 + 539)) <= (5118 - 3310)) and v61.BagofTricks:IsCastable() and (v94 == (1226 - (636 + 589))) and (v13:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 11 - 6))) then
					if (v19(v61.BagofTricks, v52, nil, not v15:IsSpellInRange(v61.BagofTricks)) or ((4434 - 2284) <= (949 + 248))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
			if (((1370 + 2399) >= (2188 - (657 + 358))) and ((2 - 1) == v156)) then
				if (((3383 - 1898) == (2672 - (1151 + 36))) and v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + 3 + 0) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (16 + 44))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (8 - 5)))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + (1835 - (1552 + 280))))) or ((v94 >= (836 - (64 + 770))) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + 3 + 0)))) then
					if (v19(v61.Berserking, v52) or ((7525 - 4210) <= (494 + 2288))) then
						return "berserking racials 6";
					end
				end
				if ((v61.LightsJudgment:IsCastable() and v13:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v13:BuffRemains(v61.FestermightBuff) < v15:TimeToDie()) or (v13:BuffRemains(v61.UnholyStrengthBuff) < v15:TimeToDie()))) or ((2119 - (157 + 1086)) >= (5932 - 2968))) then
					if (v19(v61.LightsJudgment, v52, nil, not v15:IsSpellInRange(v61.LightsJudgment)) or ((9775 - 7543) > (3830 - 1333))) then
						return "lights_judgment racials 8";
					end
				end
				v156 = 2 - 0;
			end
			if (((821 - (599 + 220)) == v156) or ((4201 - 2091) <= (2263 - (1813 + 118)))) then
				if (((2695 + 991) > (4389 - (841 + 376))) and v61.AncestralCall:IsCastable() and ((((24 - 6) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (14 + 46))) and ((v82 and (v83 <= (49 - 31))) or (v80 and (v81 <= (877 - (464 + 395)))) or ((v94 >= (5 - 3)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (9 + 9)))) then
					if (v19(v61.AncestralCall, v52) or ((5311 - (467 + 370)) < (1694 - 874))) then
						return "ancestral_call racials 10";
					end
				end
				if (((3142 + 1137) >= (9879 - 6997)) and v61.ArcanePulse:IsCastable() and ((v94 >= (1 + 1)) or ((v13:Rune() <= (2 - 1)) and (v13:RunicPowerDeficit() >= (580 - (150 + 370)))))) then
					if (v19(v61.ArcanePulse, v52, nil, not v15:IsInRange(1290 - (74 + 1208))) or ((4990 - 2961) >= (16698 - 13177))) then
						return "arcane_pulse racials 12";
					end
				end
				v156 = 3 + 0;
			end
		end
	end
	local function v124()
		local v157 = 390 - (14 + 376);
		while true do
			if ((v157 == (0 - 0)) or ((1319 + 718) >= (4078 + 564))) then
				if (((1641 + 79) < (13062 - 8604)) and v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (8 + 2)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((514 - (23 + 55)) > (7159 - 4138))) then
						return "death_coil st 2";
					end
				end
				if (((476 + 237) <= (761 + 86)) and v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (15 - 5)))) then
					if (((678 + 1476) <= (4932 - (652 + 249))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(107 - 67))) then
						return "epidemic st 4";
					end
				end
				v157 = 1869 - (708 + 1160);
			end
			if (((12527 - 7912) == (8414 - 3799)) and (v157 == (29 - (10 + 17)))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((852 + 2938) == (2232 - (1400 + 332)))) then
					if (((170 - 81) < (2129 - (242 + 1666))) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v15:IsInMeleeRange(3 + 2))) then
						return "festering_strike st 10";
					end
				end
				if (((753 + 1301) >= (1212 + 209)) and v61.DeathCoil:IsReady()) then
					if (((1632 - (850 + 90)) < (5355 - 2297)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil st 12";
					end
				end
				v157 = 1393 - (360 + 1030);
			end
			if ((v157 == (3 + 0)) or ((9184 - 5930) == (2276 - 621))) then
				if ((v86:IsReady() and not v76) or ((2957 - (909 + 752)) == (6133 - (109 + 1114)))) then
					if (((6166 - 2798) == (1312 + 2056)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v15:IsSpellInRange(v86))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if (((2885 - (6 + 236)) < (2404 + 1411)) and (v157 == (1 + 0))) then
				if (((4511 - 2598) > (860 - 367)) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (1135 - (1076 + 57))) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (3 + 10))) or (v84 and (v85 > (697 - (579 + 110)))) or (v82 and (v83 > (1 + 7))) or (not v76 and (v89 >= (4 + 0))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v14:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 + 0))) and not v13:IsMoving() and (v94 >= (408 - (174 + 233)))) then
					if (((13282 - 8527) > (6016 - 2588)) and v19(v88, v48)) then
						return "any_dnd st 6";
					end
				end
				if (((615 + 766) <= (3543 - (663 + 511))) and v86:IsReady() and (v76 or ((v94 >= (2 + 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((1052 + 3791) == (12590 - 8506))) then
						return "wound_spender st 8";
					end
				end
				v157 = 2 + 0;
			end
		end
	end
	local function v125()
		if (((10992 - 6323) > (878 - 515)) and v33) then
			local v163 = v115();
			if (v163 or ((896 + 981) >= (6107 - 2969))) then
				return v163;
			end
		end
	end
	local function v126()
		local v158 = 0 + 0;
		while true do
			if (((434 + 4308) >= (4348 - (478 + 244))) and (v158 == (519 - (440 + 77)))) then
				v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (1 + 0)) and (v61.UnholyAssault:CooldownRemains() < (73 - 53)) and v61.UnholyAssault:IsAvailable() and v78) or (v15:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1557 - (655 + 901)))) or (v89 > (1 + 3)) or (v13:HasTier(24 + 7, 3 + 1) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (3 - 2))))) or ((v91 < (1450 - (695 + 750))) and (v89 >= (3 - 2)));
				v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (3 - 0)) and (v13:RunicPower() < (241 - 181)) and not v78;
				v158 = 354 - (285 + 66);
			end
			if ((v158 == (0 - 0)) or ((5850 - (682 + 628)) == (148 + 768))) then
				v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (302 - (176 + 123)))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (2 + 2))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (2 + 0)));
				v71 = (v94 >= (272 - (239 + 30))) or ((v61.SummonGargoyle:CooldownRemains() > (1 + 0)) and ((v61.Apocalypse:CooldownRemains() > (1 + 0)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v9.CombatTime() > (35 - 15));
				v158 = 2 - 1;
			end
			if ((v158 == (316 - (306 + 9))) or ((4033 - 2877) > (756 + 3589))) then
				v74 = ((v61.Apocalypse:CooldownRemains() < (7 + 3)) and (v89 <= (2 + 2)) and (v61.UnholyAssault:CooldownRemains() > (28 - 18)) and (1382 - (1140 + 235))) or (2 + 0);
				if (((2052 + 185) < (1091 + 3158)) and not v84 and v61.Festermight:IsAvailable() and v13:BuffUp(v61.FestermightBuff) and ((v13:BuffRemains(v61.FestermightBuff) / ((57 - (33 + 19)) * v13:GCD())) >= (1 + 0))) then
					v75 = v89 >= (2 - 1);
				else
					v75 = v89 >= ((2 + 1) - v22(v61.InfectedClaws:IsAvailable()));
				end
				v158 = 3 - 1;
			end
			if ((v158 == (3 + 0)) or ((3372 - (586 + 103)) < (3 + 20))) then
				v78 = (v94 == (2 - 1)) or not v28;
				v79 = (v94 >= (1490 - (1309 + 179))) and v28;
				v158 = 6 - 2;
			end
			if (((304 + 393) <= (2218 - 1392)) and (v158 == (4 + 0))) then
				v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v15:DebuffDown(v61.RottenTouchDebuff)) or (v13:RunicPowerDeficit() < (42 - 22))) and (not v13:HasTier(61 - 30, 613 - (295 + 314)) or (v13:HasTier(76 - 45, 1966 - (1300 + 662)) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v13:RunicPowerDeficit() < (62 - 42)) or (v13:Rune() < (1758 - (1178 + 577)))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (2 + 0)) or v61.CoilofDevastation:IsAvailable())) or (v13:Rune() < (8 - 5)) or v84 or v13:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (1415 - (851 + 554))) and (v89 > (3 + 0))) or (not v76 and (v89 >= (10 - 6))));
				break;
			end
		end
	end
	local function v127()
		v60();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v69 = not v99();
		v93 = v13:GetEnemiesInMeleeRange(10 - 5);
		v95 = v15:GetEnemiesInSplashRange(312 - (115 + 187));
		if (((847 + 258) <= (1114 + 62)) and v28) then
			v94 = #v93;
			v96 = v15:GetEnemiesInSplashRangeCount(39 - 29);
		else
			v94 = 1162 - (160 + 1001);
			v96 = 1 + 0;
		end
		if (((2332 + 1047) <= (7803 - 3991)) and (v70.TargetIsValid() or v13:AffectingCombat())) then
			v90 = v9.BossFightRemains();
			v91 = v90;
			if ((v91 == (11469 - (237 + 121))) or ((1685 - (525 + 372)) >= (3063 - 1447))) then
				v91 = v9.FightRemains(v93, false);
			end
			v97 = v100(v95);
			v80 = v61.Apocalypse:TimeSinceLastCast() <= (49 - 34);
			v81 = (v80 and ((157 - (96 + 46)) - v61.Apocalypse:TimeSinceLastCast())) or (777 - (643 + 134));
			v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (11 + 19);
			v83 = (v82 and ((71 - 41) - v61.ArmyoftheDead:TimeSinceLastCast())) or (0 - 0);
			v84 = v92:GargActive();
			v85 = v92:GargRemains();
			v89 = v15:DebuffStack(v61.FesteringWoundDebuff);
		end
		if (((1779 + 75) <= (6630 - 3251)) and v70.TargetIsValid()) then
			if (((9298 - 4749) == (5268 - (316 + 403))) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v186 = 0 + 0;
				local v187;
				while true do
					if ((v186 == (2 - 1)) or ((1093 + 1929) >= (7615 - 4591))) then
						v187 = v70.Interrupt(v61.MindFreeze, 11 + 4, true, v20, v63.MindFreezeMouseover);
						if (((1554 + 3266) > (7615 - 5417)) and v187) then
							return v187;
						end
						break;
					end
					if ((v186 == (0 - 0)) or ((2204 - 1143) >= (280 + 4611))) then
						v187 = v70.Interrupt(v61.MindFreeze, 29 - 14, true);
						if (((67 + 1297) <= (13159 - 8686)) and v187) then
							return v187;
						end
						v186 = 18 - (12 + 5);
					end
				end
			end
			if (not v13:AffectingCombat() or ((13963 - 10368) <= (5 - 2))) then
				local v188 = 0 - 0;
				local v189;
				while true do
					if ((v188 == (0 - 0)) or ((949 + 3723) == (5825 - (1656 + 317)))) then
						v189 = v114();
						if (((1390 + 169) == (1250 + 309)) and v189) then
							return v189;
						end
						break;
					end
				end
			end
			if ((v61.DeathStrike:IsReady() and not v69) or ((4658 - 2906) <= (3878 - 3090))) then
				if (v19(v61.DeathStrike) or ((4261 - (5 + 349)) == (840 - 663))) then
					return "death_strike low hp or proc";
				end
			end
			if (((4741 - (266 + 1005)) > (366 + 189)) and (v94 == (0 - 0))) then
				if ((v61.Outbreak:IsReady() and (v97 > (0 - 0))) or ((2668 - (561 + 1135)) == (840 - 195))) then
					if (((10459 - 7277) >= (3181 - (507 + 559))) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
						return "outbreak out_of_range";
					end
				end
				if (((9768 - 5875) < (13697 - 9268)) and v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (389 - (212 + 176))) and not v77) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(945 - (250 + 655))) or ((7818 - 4951) < (3328 - 1423))) then
						return "epidemic out_of_range";
					end
				end
				if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (2 - 0)) and not v77) or ((3752 - (1869 + 87)) >= (14050 - 9999))) then
					if (((3520 - (484 + 1417)) <= (8050 - 4294)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil out_of_range";
					end
				end
			end
			if (((1012 - 408) == (1377 - (48 + 725))) and v61.Apocalypse:IsReady() and v53) then
				if (v19(v61.Apocalypse, nil, nil, not v15:IsInMeleeRange(8 - 3)) or ((12030 - 7546) == (524 + 376))) then
					return "apocalypse garg_setup 2";
				end
			end
			if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (13 - 8)) and v54) or ((1248 + 3211) <= (325 + 788))) then
				if (((4485 - (152 + 701)) > (4709 - (430 + 881))) and v19(v61.DarkTransformation, v54, nil, not v15:IsInMeleeRange(4 + 4))) then
					return "dark_transformation cooldowns 6";
				end
			end
			v126();
			local v164 = v122();
			if (((4977 - (557 + 338)) <= (1454 + 3463)) and v164) then
				return v164;
			end
			local v164 = v115();
			if (((13616 - 8784) >= (4853 - 3467)) and v164) then
				return v164;
			end
			if (((363 - 226) == (295 - 158)) and v29 and not v71) then
				local v190 = 801 - (499 + 302);
				local v191;
				while true do
					if ((v190 == (866 - (39 + 827))) or ((4334 - 2764) >= (9674 - 5342))) then
						v191 = v121();
						if (v191 or ((16141 - 12077) <= (2792 - 973))) then
							return v191;
						end
						break;
					end
				end
			end
			if ((v29 and v78) or ((427 + 4559) < (4606 - 3032))) then
				local v192 = 0 + 0;
				local v193;
				while true do
					if (((7003 - 2577) > (276 - (103 + 1))) and (v192 == (554 - (475 + 79)))) then
						v193 = v120();
						if (((1266 - 680) > (1456 - 1001)) and v193) then
							return v193;
						end
						break;
					end
				end
			end
			if (((107 + 719) == (727 + 99)) and v28 and v29 and v79) then
				local v194 = v118();
				if (v194 or ((5522 - (1395 + 108)) > (12923 - 8482))) then
					return v194;
				end
			end
			if (((3221 - (7 + 1197)) < (1858 + 2403)) and v29) then
				local v195 = v123();
				if (((1646 + 3070) > (399 - (27 + 292))) and v195) then
					return v195;
				end
			end
			if (v28 or ((10276 - 6769) == (4172 - 900))) then
				local v196 = 0 - 0;
				while true do
					if ((v196 == (1 - 0)) or ((1668 - 792) >= (3214 - (43 + 96)))) then
						if (((17752 - 13400) > (5773 - 3219)) and (v94 >= (4 + 0)) and (((v87:CooldownRemains() > (3 + 7)) and v13:BuffDown(v61.DeathAndDecayBuff)) or not v79)) then
							local v199 = v116();
							if (v199 or ((8708 - 4302) < (1550 + 2493))) then
								return v199;
							end
						end
						break;
					end
					if ((v196 == (0 - 0)) or ((595 + 1294) >= (249 + 3134))) then
						if (((3643 - (1414 + 337)) <= (4674 - (1642 + 298))) and v79 and (v87:CooldownRemains() < (26 - 16)) and v13:BuffDown(v61.DeathAndDecayBuff)) then
							local v200 = v119();
							if (((5531 - 3608) < (6581 - 4363)) and v200) then
								return v200;
							end
						end
						if (((716 + 1457) > (295 + 84)) and (v94 >= (976 - (357 + 615))) and v13:BuffUp(v61.DeathAndDecayBuff)) then
							local v201 = 0 + 0;
							local v202;
							while true do
								if ((v201 == (0 - 0)) or ((2221 + 370) == (7305 - 3896))) then
									v202 = v117();
									if (((3611 + 903) > (226 + 3098)) and v202) then
										return v202;
									end
									break;
								end
							end
						end
						v196 = 1 + 0;
					end
				end
			end
			if ((v94 <= (1304 - (384 + 917))) or ((905 - (128 + 569)) >= (6371 - (1407 + 136)))) then
				local v197 = v124();
				if (v197 or ((3470 - (687 + 1200)) > (5277 - (556 + 1154)))) then
					return v197;
				end
			end
			if (v61.FesteringStrike:IsReady() or ((4619 - 3306) == (889 - (9 + 86)))) then
				if (((3595 - (275 + 146)) > (472 + 2430)) and v19(v61.FesteringStrike, nil, nil)) then
					return "festering_strike precombat 8";
				end
			end
		end
	end
	local function v128()
		v61.VirulentPlagueDebuff:RegisterAuraTracking();
		v61.FesteringWoundDebuff:RegisterAuraTracking();
		v9.Print("Unholy DK by Epic. Work in Progress Gojira");
	end
	v9.SetAPL(316 - (29 + 35), v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

