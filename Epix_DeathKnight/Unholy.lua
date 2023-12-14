local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (827 - (802 + 24))) or ((3714 - 1560) >= (4199 - 874))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((995 + 300) >= (532 + 2701))) then
			v6 = v0[v4];
			if (((945 + 3432) > (4567 - 2925)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
	local v20 = v10.Cast;
	local v21 = v10.Macro;
	local v22 = v10.Commons.Everyone.num;
	local v23 = v10.Commons.Everyone.bool;
	local v24 = math.min;
	local v25 = math.abs;
	local v26 = math.max;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v20 = v10.Cast;
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
		local v129 = 0 + 0;
		while true do
			if (((1923 + 2800) > (1119 + 237)) and (v129 == (5 + 1))) then
				v58 = EpicSettings.Settings['UnholyBlightGCD'];
				v59 = EpicSettings.Settings['VileContagionGCD'];
				break;
			end
			if ((v129 == (0 + 0)) or ((5569 - (797 + 636)) <= (16668 - 13235))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (1619 - (1427 + 192));
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v129 = 2 - 1;
			end
			if (((3816 + 429) <= (2099 + 2532)) and (v129 == (330 - (192 + 134)))) then
				v50 = EpicSettings.Settings['SacrificialPactGCD'];
				v51 = EpicSettings.Settings['MindFreezeOffGCD'];
				v52 = EpicSettings.Settings['RacialsOffGCD'];
				v53 = EpicSettings.Settings['ApocalypseGCD'];
				v129 = 1281 - (316 + 960);
			end
			if (((2380 + 1896) >= (3021 + 893)) and (v129 == (5 + 0))) then
				v54 = EpicSettings.Settings['DarkTransformationGCD'];
				v55 = EpicSettings.Settings['EpidemicGCD'];
				v56 = EpicSettings.Settings['SummonGargoyleGCD'];
				v57 = EpicSettings.Settings['UnholyAssaultGCD'];
				v129 = 22 - 16;
			end
			if (((749 - (83 + 468)) <= (6171 - (1202 + 604))) and (v129 == (13 - 10))) then
				v46 = EpicSettings.Settings['AntiMagicShellGCD'];
				v47 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v48 = EpicSettings.Settings['DeathAndDecayGCD'];
				v49 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v129 = 6 - 2;
			end
			if (((13239 - 8457) > (5001 - (45 + 280))) and ((2 + 0) == v129)) then
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 + 0);
				v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 + 0);
				v45 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v129 = 1 + 2;
			end
			if (((9006 - 4142) > (4108 - (340 + 1571))) and (v129 == (1 + 0))) then
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (1772 - (1733 + 39));
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1034 - (125 + 909));
				v129 = 1950 - (1096 + 852);
			end
		end
	end
	local v61 = v17.DeathKnight.Unholy;
	local v62 = v19.DeathKnight.Unholy;
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {v62.AlgetharPuzzleBox:ID(),v62.Fyralath:ID(),v62.IrideusFragment:ID(),v62.VialofAnimatedBlood:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[249 - (46 + 190)] and v19(v65[108 - (51 + 44)])) or v19(0 + 0);
	local v67 = (v65[1331 - (1114 + 203)] and v19(v65[740 - (228 + 498)])) or v19(0 + 0);
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
	local v90 = 6139 + 4972;
	local v91 = 11774 - (174 + 489);
	local v92 = v10.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (1163 - (171 + 991))) or ((15248 - 11548) == (6731 - 4224))) then
				v67 = (v65[34 - 20] and v19(v65[12 + 2])) or v19(0 - 0);
				break;
			end
			if (((12906 - 8432) >= (441 - 167)) and (v130 == (0 - 0))) then
				v65 = v14:GetEquipment();
				v66 = (v65[1261 - (111 + 1137)] and v19(v65[171 - (91 + 67)])) or v19(0 - 0);
				v130 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v131 = 523 - (423 + 100);
		while true do
			if (((0 + 0) == v131) or ((5244 - 3350) <= (733 + 673))) then
				v90 = 11882 - (326 + 445);
				v91 = 48488 - 37377;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v132 = 0 - 0;
		while true do
			if (((3668 - 2096) >= (2242 - (530 + 181))) and (v132 == (881 - (614 + 267)))) then
				v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
				v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
				v132 = 33 - (19 + 13);
			end
			if ((v132 == (1 - 0)) or ((10922 - 6235) < (12974 - 8432))) then
				v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v14:HealthPercentage() < v43) or ((v14:HealthPercentage() < v44) and v14:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v133)
		local v134 = 0 + 0;
		local v135;
		while true do
			if (((5787 - 2496) > (3456 - 1789)) and (v134 == (1813 - (1293 + 519)))) then
				return v135;
			end
			if (((0 - 0) == v134) or ((2278 - 1405) == (3889 - 1855))) then
				v135 = 0 - 0;
				for v183, v184 in pairs(v133) do
					if (v184:DebuffDown(v61.VirulentPlagueDebuff) or ((6633 - 3817) < (6 + 5))) then
						v135 = v135 + 1 + 0;
					end
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v101(v136)
		local v137 = 0 + 0;
		local v138;
		while true do
			if (((1229 + 2470) < (2941 + 1765)) and (v137 == (1096 - (709 + 387)))) then
				v138 = {};
				for v185 in pairs(v136) do
					if (((4504 - (673 + 1185)) >= (2540 - 1664)) and not v13:IsInBossList(v136[v185]['UnitNPCID'])) then
						v30(v138, v136[v185]);
					end
				end
				v137 = 3 - 2;
			end
			if (((1009 - 395) <= (2278 + 906)) and (v137 == (1 + 0))) then
				return v10.FightRemains(v138);
			end
		end
	end
	local function v102(v139)
		return (v139:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v140)
		return (v140:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v141)
		return (v61.BurstingSores:IsAvailable() and v141:DebuffUp(v61.FesteringWoundDebuff) and ((v14:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v14:Rune() < (3 - 0))) or (v14:BuffUp(v61.DeathAndDecayBuff) and (v14:Rune() == (0 + 0))))) or (not v61.BurstingSores:IsAvailable() and (v141:DebuffStack(v61.FesteringWoundDebuff) >= (7 - 3))) or (v14:HasTier(60 - 29, 1882 - (446 + 1434)) and v141:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v142)
		return v142:DebuffStack(v61.FesteringWoundDebuff) >= (1287 - (1040 + 243));
	end
	local function v106(v143)
		return v143:DebuffStack(v61.FesteringWoundDebuff) < (11 - 7);
	end
	local function v107(v144)
		return v144:DebuffStack(v61.FesteringWoundDebuff) < (1851 - (559 + 1288));
	end
	local function v108(v145)
		return v145:DebuffStack(v61.FesteringWoundDebuff) >= (1935 - (609 + 1322));
	end
	local function v109(v146)
		return ((v146:TimeToX(489 - (13 + 441)) < (18 - 13)) or (v146:HealthPercentage() <= (91 - 56))) and (v146:TimeToDie() > (v146:DebuffRemains(v61.SoulReaper) + (24 - 19)));
	end
	local function v110(v147)
		return (v147:DebuffStack(v61.FesteringWoundDebuff) <= (1 + 1)) or v15:BuffUp(v61.DarkTransformation);
	end
	local function v111(v148)
		return (v148:DebuffStack(v61.FesteringWoundDebuff) >= (14 - 10)) and (v87:CooldownRemains() < (2 + 1));
	end
	local function v112(v149)
		return v149:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v150)
		return (v150:TimeToDie() > v150:DebuffRemains(v61.VirulentPlagueDebuff)) and (v150:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v150:DebuffRefreshable(v61.FrostFeverDebuff) or v150:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((44 - 29) / ((v22(v61.Superstrain:IsAvailable()) * (2 + 1)) + (v22(v61.Plaguebringer:IsAvailable()) * (3 - 1)) + (v22(v61.EbonFever:IsAvailable()) * (2 + 0)))))));
	end
	local function v114()
		if (((1739 + 1387) == (2247 + 879)) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive() or not v15:IsActive())) then
			if (v20(v61.RaiseDead, nil) or ((1837 + 350) >= (4847 + 107))) then
				return "raise_dead precombat 2 displaystyle";
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v29) or ((4310 - (153 + 280)) == (10323 - 6748))) then
			if (((635 + 72) > (250 + 382)) and v20(v61.ArmyoftheDead, nil)) then
				return "army_of_the_dead precombat 4";
			end
		end
		if (v61.Outbreak:IsReady() or ((286 + 260) >= (2436 + 248))) then
			if (((1062 + 403) <= (6548 - 2247)) and v20(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak))) then
				return "outbreak precombat 6";
			end
		end
		if (((1054 + 650) > (2092 - (89 + 578))) and v61.FesteringStrike:IsReady()) then
			if (v20(v61.FesteringStrike, nil, nil, not v16:IsInMeleeRange(4 + 1)) or ((1428 - 741) == (5283 - (572 + 477)))) then
				return "festering_strike precombat 8";
			end
		end
	end
	local function v115()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (1 + 0)) or ((398 + 2932) < (1515 - (84 + 2)))) then
				v68 = v70.HandleBottomTrinket(v64, v29, 65 - 25, nil);
				if (((827 + 320) >= (1177 - (497 + 345))) and v68) then
					return v68;
				end
				break;
			end
			if (((88 + 3347) > (355 + 1742)) and (v151 == (1333 - (605 + 728)))) then
				v68 = v70.HandleTopTrinket(v64, v29, 29 + 11, nil);
				if (v68 or ((8381 - 4611) >= (186 + 3855))) then
					return v68;
				end
				v151 = 3 - 2;
			end
		end
	end
	local function v116()
		if ((v61.Epidemic:IsReady() and (not v77 or (v91 < (10 + 0)))) or ((10503 - 6712) <= (1217 + 394))) then
			if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(519 - (457 + 32))) or ((1943 + 2635) <= (3410 - (832 + 570)))) then
				return "epidemic aoe 2";
			end
		end
		if (((1060 + 65) <= (542 + 1534)) and v86:IsReady() and v76) then
			if (v70.CastTargetIf(v86, v93, "max", v102, nil, not v16:IsSpellInRange(v86)) or ((2629 - 1886) >= (2120 + 2279))) then
				return "wound_spender aoe 4";
			end
		end
		if (((1951 - (588 + 208)) < (4509 - 2836)) and v61.FesteringStrike:IsReady() and not v76) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v16:IsInMeleeRange(1805 - (884 + 916))) or ((4865 - 2541) <= (336 + 242))) then
				return "festering_strike aoe 6";
			end
		end
		if (((4420 - (232 + 421)) == (5656 - (1569 + 320))) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
			if (((1004 + 3085) == (777 + 3312)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil aoe 8";
			end
		end
	end
	local function v117()
		local v152 = 0 - 0;
		while true do
			if (((5063 - (316 + 289)) >= (4381 - 2707)) and (v152 == (1 + 0))) then
				if (((2425 - (666 + 787)) <= (1843 - (360 + 65))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (10 + 0)))) then
					if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(294 - (79 + 175))) or ((7785 - 2847) < (3716 + 1046))) then
						return "epidemic aoe_burst 6";
					end
				end
				if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((7675 - 5171) > (8211 - 3947))) then
					if (((3052 - (503 + 396)) == (2334 - (92 + 89))) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil aoe_burst 8";
					end
				end
				v152 = 3 - 1;
			end
			if ((v152 == (2 + 0)) or ((301 + 206) >= (10146 - 7555))) then
				if (((613 + 3868) == (10217 - 5736)) and v86:IsReady()) then
					if (v20(v86, nil, nil, not v16:IsSpellInRange(v86)) or ((2032 + 296) < (331 + 362))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if (((13181 - 8853) == (541 + 3787)) and (v152 == (0 - 0))) then
				if (((2832 - (485 + 759)) >= (3081 - 1749)) and v61.Epidemic:IsReady() and ((v14:Rune() < (1190 - (442 + 747))) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (1135 - (832 + 303))))) and not v77 and ((v94 >= (952 - (88 + 858))) or (v14:RunicPowerDeficit() < (10 + 20)) or (v14:BuffStack(v61.FestermightBuff) == (17 + 3)))) then
					if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(2 + 38)) or ((4963 - (766 + 23)) > (20971 - 16723))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (v86:IsReady() or ((6271 - 1685) <= (215 - 133))) then
					if (((13111 - 9248) == (4936 - (1036 + 37))) and v70.CastTargetIf(v86, v93, "max", v102, v112, not v16:IsSpellInRange(v86))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v118()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (0 + 0)) or ((1762 - (641 + 839)) <= (955 - (910 + 3)))) then
				if (((11749 - 7140) >= (2450 - (1466 + 218))) and v61.VileContagion:IsReady() and (v87:CooldownRemains() < (2 + 1))) then
					if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v16:IsSpellInRange(v61.VileContagion)) or ((2300 - (556 + 592)) == (885 + 1603))) then
						return "vile_contagion aoe_cooldowns 2";
					end
				end
				if (((4230 - (329 + 479)) > (4204 - (174 + 680))) and v61.SummonGargoyle:IsReady()) then
					if (((3013 - 2136) > (778 - 402)) and v20(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle aoe_cooldowns 4";
					end
				end
				v153 = 1 + 0;
			end
			if ((v153 == (742 - (396 + 343))) or ((276 + 2842) <= (3328 - (29 + 1448)))) then
				if ((v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (1399 - (135 + 1254))) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) or ((621 - 456) >= (16304 - 12812))) then
					if (((2632 + 1317) < (6383 - (389 + 1138))) and v20(v61.DarkTransformation, v54)) then
						return "dark_transformation aoe_cooldowns 14";
					end
				end
				if ((v61.EmpowerRuneWeapon:IsCastable() and (v15:BuffUp(v61.DarkTransformation))) or ((4850 - (102 + 472)) < (2847 + 169))) then
					if (((2601 + 2089) > (3847 + 278)) and v20(v61.EmpowerRuneWeapon, v49)) then
						return "empower_rune_weapon aoe_cooldowns 16";
					end
				end
				v153 = 1549 - (320 + 1225);
			end
			if ((v153 == (2 - 0)) or ((31 + 19) >= (2360 - (157 + 1307)))) then
				if (v61.UnholyAssault:IsCastable() or ((3573 - (821 + 1038)) >= (7380 - 4422))) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v16:IsInMeleeRange(1 + 4), v57) or ((2648 - 1157) < (240 + 404))) then
						return "unholy_assault aoe_cooldowns 10";
					end
				end
				if (((1744 - 1040) < (2013 - (834 + 192))) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
					if (((237 + 3481) > (490 + 1416)) and v20(v61.RaiseDead, nil)) then
						return "raise_dead aoe_cooldowns 12";
					end
				end
				v153 = 1 + 2;
			end
			if ((v153 == (5 - 1)) or ((1262 - (300 + 4)) > (971 + 2664))) then
				if (((9164 - 5663) <= (4854 - (112 + 250))) and v61.SacrificialPact:IsReady() and ((v15:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (3 + 3))) or (v91 < v14:GCD()))) then
					if (v20(v61.SacrificialPact, v50) or ((8622 - 5180) < (1460 + 1088))) then
						return "sacrificial_pact aoe_cooldowns 18";
					end
				end
				break;
			end
			if (((1487 + 1388) >= (1095 + 369)) and (v153 == (1 + 0))) then
				if ((v61.AbominationLimb:IsCastable() and ((v14:Rune() < (2 + 0)) or (v89 > (1424 - (1001 + 413))) or not v61.Festermight:IsAvailable() or (v14:BuffUp(v61.FestermightBuff) and (v14:BuffRemains(v61.FestermightBuff) < (26 - 14))))) or ((5679 - (244 + 638)) >= (5586 - (627 + 66)))) then
					if (v20(v61.AbominationLimb, nil, nil, not v16:IsInRange(59 - 39)) or ((1153 - (512 + 90)) > (3974 - (1665 + 241)))) then
						return "abomination_limb aoe_cooldowns 6";
					end
				end
				if (((2831 - (373 + 344)) > (426 + 518)) and v61.Apocalypse:IsReady()) then
					if (v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v16:IsInMeleeRange(2 + 3)) or ((5966 - 3704) >= (5238 - 2142))) then
						return "apocalypse aoe_cooldowns 8";
					end
				end
				v153 = 1101 - (35 + 1064);
			end
		end
	end
	local function v119()
		if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (6 + 2)))) or ((4824 - 2569) >= (15 + 3522))) then
			if (v20(v88, v48) or ((5073 - (298 + 938)) < (2565 - (233 + 1026)))) then
				return "any_dnd aoe_setup 2";
			end
		end
		if (((4616 - (636 + 1030)) == (1509 + 1441)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v16:IsInMeleeRange(5 + 0)) or ((1404 + 3319) < (223 + 3075))) then
				return "festering_strike aoe_setup 4";
			end
		end
		if (((1357 - (55 + 166)) >= (30 + 124)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (2 + 8)))) then
			if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(152 - 112)) or ((568 - (36 + 261)) > (8303 - 3555))) then
				return "epidemic aoe_setup 6";
			end
		end
		if (((6108 - (34 + 1334)) >= (1212 + 1940)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v16:IsInMeleeRange(4 + 1)) or ((3861 - (1035 + 248)) >= (3411 - (20 + 1)))) then
				return "festering_strike aoe_setup 8";
			end
		end
		if (((22 + 19) <= (1980 - (134 + 185))) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
			if (((1734 - (549 + 584)) < (4245 - (314 + 371))) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v16:IsInMeleeRange(17 - 12))) then
				return "festering_strike aoe_setup 10";
			end
		end
		if (((1203 - (478 + 490)) < (364 + 323)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
			if (((5721 - (786 + 386)) > (3734 - 2581)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil aoe_setup 12";
			end
		end
	end
	local function v120()
		local v154 = 1379 - (1055 + 324);
		while true do
			if ((v154 == (1342 - (1093 + 247))) or ((4154 + 520) < (492 + 4180))) then
				if (((14562 - 10894) < (15478 - 10917)) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (65 - 42))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v15:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v15:BuffUp(v61.DarkTransformation)))) or (v91 <= (52 - 31)))) then
					if (v20(v61.EmpowerRuneWeapon, v49) or ((162 + 293) == (13887 - 10282))) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if ((v61.AbominationLimb:IsCastable() and (v14:Rune() < (10 - 7)) and v78) or ((2008 + 655) == (8469 - 5157))) then
					if (((4965 - (364 + 324)) <= (12267 - 7792)) and v20(v61.AbominationLimb)) then
						return "abomination_limb cooldowns 12";
					end
				end
				v154 = 6 - 3;
			end
			if ((v154 == (1 + 0)) or ((3640 - 2770) == (1903 - 714))) then
				if (((4716 - 3163) <= (4401 - (1249 + 19))) and v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (5 + 0))) then
					if (v20(v61.DarkTransformation, v54) or ((8707 - 6470) >= (4597 - (686 + 400)))) then
						return "dark_transformation cooldowns 6";
					end
				end
				if ((v61.Apocalypse:IsReady() and v78) or ((1039 + 285) > (3249 - (73 + 156)))) then
					if (v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v16:IsInMeleeRange(1 + 4), v53) or ((3803 - (721 + 90)) == (22 + 1859))) then
						return "apocalypse cooldowns 8";
					end
				end
				v154 = 6 - 4;
			end
			if (((3576 - (224 + 246)) > (2471 - 945)) and (v154 == (6 - 2))) then
				if (((549 + 2474) < (93 + 3777)) and v61.SoulReaper:IsReady() and (v94 >= (2 + 0))) then
					if (((284 - 141) > (245 - 171)) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v16:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if (((531 - (203 + 310)) < (4105 - (1238 + 755))) and (v154 == (0 + 0))) then
				if (((2631 - (709 + 825)) <= (2999 - 1371)) and v61.SummonGargoyle:IsCastable() and (v14:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) then
					if (((6744 - 2114) == (5494 - (196 + 668))) and v20(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if (((13976 - 10436) > (5557 - 2874)) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
					if (((5627 - (171 + 662)) >= (3368 - (4 + 89))) and v20(v61.RaiseDead, nil)) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v154 = 3 - 2;
			end
			if (((541 + 943) == (6518 - 5034)) and (v154 == (2 + 1))) then
				if (((2918 - (35 + 1451)) < (5008 - (28 + 1425))) and v61.UnholyAssault:IsReady() and v78) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v16:IsInMeleeRange(1998 - (941 + 1052)), v57) or ((1022 + 43) > (5092 - (822 + 692)))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if ((v61.SoulReaper:IsReady() and (v94 == (1 - 0)) and ((v16:TimeToX(17 + 18) < (302 - (45 + 252))) or (v16:HealthPercentage() <= (35 + 0))) and (v16:TimeToDie() > (2 + 3))) or ((11669 - 6874) < (1840 - (114 + 319)))) then
					if (((2659 - 806) < (6166 - 1353)) and v20(v61.SoulReaper, nil, nil, not v16:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v154 = 3 + 1;
			end
		end
	end
	local function v121()
		if ((v61.Apocalypse:IsReady() and (v89 >= (5 - 1)) and ((v14:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (47 - 24))) or not v61.CommanderoftheDead:IsAvailable())) or ((4784 - (556 + 1407)) < (3637 - (741 + 465)))) then
			if (v20(v61.Apocalypse, v53, nil, not v16:IsInMeleeRange(470 - (170 + 295))) or ((1515 + 1359) < (2004 + 177))) then
				return "apocalypse garg_setup 2";
			end
		end
		if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (7 - 4)) or v14:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (9 + 1))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) or ((1725 + 964) <= (195 + 148))) then
			if (v20(v61.ArmyoftheDead) or ((3099 - (957 + 273)) == (538 + 1471))) then
				return "army_of_the_dead garg_setup 4";
			end
		end
		if ((v61.SoulReaper:IsReady() and (v94 == (1 + 0)) and ((v16:TimeToX(133 - 98) < (13 - 8)) or (v16:HealthPercentage() <= (106 - 71))) and (v16:TimeToDie() > (24 - 19))) or ((5326 - (389 + 1391)) < (1457 + 865))) then
			if (v20(v61.SoulReaper, nil, nil, not v16:IsInMeleeRange(1 + 4)) or ((4739 - 2657) == (5724 - (783 + 168)))) then
				return "soul_reaper garg_setup 6";
			end
		end
		if (((10887 - 7643) > (1038 + 17)) and v61.SummonGargoyle:IsCastable() and v29 and (v14:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() >= (351 - (309 + 2)))))) then
			if (v20(v61.SummonGargoyle, v56) or ((10173 - 6860) <= (2990 - (1090 + 122)))) then
				return "summon_gargoyle garg_setup 8";
			end
		end
		if ((v29 and v84 and (v85 <= (8 + 15))) or ((4772 - 3351) >= (1440 + 664))) then
			if (((2930 - (628 + 490)) <= (583 + 2666)) and v61.EmpowerRuneWeapon:IsCastable()) then
				if (((4018 - 2395) <= (8943 - 6986)) and v20(v61.EmpowerRuneWeapon, v49)) then
					return "empower_rune_weapon garg_setup 10";
				end
			end
			if (((5186 - (431 + 343)) == (8910 - 4498)) and v61.UnholyAssault:IsCastable()) then
				if (((5062 - 3312) >= (666 + 176)) and v20(v61.UnholyAssault, v57, nil, not v16:IsInMeleeRange(1 + 4))) then
					return "unholy_assault garg_setup 12";
				end
			end
		end
		if (((6067 - (556 + 1139)) > (1865 - (6 + 9))) and v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() > (8 + 32))) or not v61.CommanderoftheDead:IsAvailable())) then
			if (((119 + 113) < (990 - (28 + 141))) and v20(v61.DarkTransformation, v54)) then
				return "dark_transformation garg_setup 16";
			end
		end
		if (((201 + 317) < (1112 - 210)) and v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 + 0))) then
			if (((4311 - (486 + 831)) > (2232 - 1374)) and v20(v88, v48)) then
				return "any_dnd garg_setup 18";
			end
		end
		if ((v61.FesteringStrike:IsReady() and ((v89 == (0 - 0)) or not v61.Apocalypse:IsAvailable() or ((v14:RunicPower() < (8 + 32)) and not v84))) or ((11873 - 8118) <= (2178 - (668 + 595)))) then
			if (((3551 + 395) > (755 + 2988)) and v20(v61.FesteringStrike, nil, nil, not v16:IsInMeleeRange(13 - 8))) then
				return "festering_strike garg_setup 20";
			end
		end
		if ((v61.DeathCoil:IsReady() and (v14:Rune() <= (291 - (23 + 267)))) or ((3279 - (1129 + 815)) >= (3693 - (371 + 16)))) then
			if (((6594 - (1326 + 424)) > (4266 - 2013)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil garg_setup 22";
			end
		end
	end
	local function v122()
		if (((1651 - 1199) == (570 - (88 + 30))) and v45) then
			if ((v61.AntiMagicShell:IsCastable() and (v14:RunicPowerDeficit() > (811 - (720 + 51))) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (88 - 48)))) or ((6333 - (421 + 1355)) < (3442 - 1355))) then
				if (((1903 + 1971) == (4957 - (286 + 797))) and v20(v61.AntiMagicShell, v46)) then
					return "antimagic_shell ams_amz 2";
				end
			end
			if ((v61.AntiMagicZone:IsCastable() and (v14:RunicPowerDeficit() > (255 - 185)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) or ((3209 - 1271) > (5374 - (397 + 42)))) then
				if (v20(v61.AntiMagicZone, v47) or ((1329 + 2926) < (4223 - (24 + 776)))) then
					return "antimagic_zone ams_amz 4";
				end
			end
		end
		if (((2239 - 785) <= (3276 - (222 + 563))) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (3 - 1))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (26 + 9)))) then
			if (v20(v61.ArmyoftheDead) or ((4347 - (23 + 167)) <= (4601 - (690 + 1108)))) then
				return "army_of_the_dead high_prio_actions 4";
			end
		end
		if (((1751 + 3102) >= (2460 + 522)) and v61.DeathCoil:IsReady() and ((v94 <= (851 - (40 + 808))) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (1 + 4)) and (v14:BuffRemains(v61.CommanderoftheDeadBuff) > (103 - 76))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) then
			if (((3952 + 182) > (1776 + 1581)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil high_prio_actions 6";
			end
		end
		if ((v61.Epidemic:IsReady() and (v96 >= (3 + 1)) and ((v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (576 - (47 + 524)))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) or ((2218 + 1199) < (6926 - 4392))) then
			if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(59 - 19)) or ((6207 - 3485) <= (1890 - (1165 + 561)))) then
				return "epidemic high_prio_actions 8";
			end
		end
		if ((v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + 1 + 2)) or (v94 >= (9 - 6))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v14:BuffRemains(v61.PlaguebringerBuff) < v14:GCD())) or ((919 + 1489) < (2588 - (341 + 138)))) then
			if (v20(v86, nil, nil, not v16:IsSpellInRange(v86)) or ((9 + 24) == (3002 - 1547))) then
				return "wound_spender high_prio_actions 10";
			end
		end
		if ((v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (347 - (89 + 237))))) or ((1424 - 981) >= (8452 - 4437))) then
			if (((4263 - (581 + 300)) > (1386 - (855 + 365))) and v20(v61.UnholyBlight, v58, nil, not v16:IsInRange(18 - 10))) then
				return "unholy_blight high_prio_actions 12";
			end
		end
		if (v61.Outbreak:IsReady() or ((92 + 188) == (4294 - (1030 + 205)))) then
			if (((1766 + 115) > (1203 + 90)) and v70.CastCycle(v61.Outbreak, v93, v113, not v16:IsSpellInRange(v61.Outbreak))) then
				return "outbreak high_prio_actions 14";
			end
		end
	end
	local function v123()
		local v155 = 286 - (156 + 130);
		while true do
			if (((5355 - 2998) == (3971 - 1614)) and (v155 == (3 - 1))) then
				if (((33 + 90) == (72 + 51)) and v61.AncestralCall:IsCastable() and ((((87 - (10 + 59)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (17 + 43))) and ((v82 and (v83 <= (88 - 70))) or (v80 and (v81 <= (1181 - (671 + 492)))) or ((v94 >= (2 + 0)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (1233 - (369 + 846))))) then
					if (v20(v61.AncestralCall, v52) or ((280 + 776) >= (2895 + 497))) then
						return "ancestral_call racials 10";
					end
				end
				if ((v61.ArcanePulse:IsCastable() and ((v94 >= (1947 - (1036 + 909))) or ((v14:Rune() <= (1 + 0)) and (v14:RunicPowerDeficit() >= (100 - 40))))) or ((1284 - (11 + 192)) < (544 + 531))) then
					if (v20(v61.ArcanePulse, v52, nil, not v16:IsInRange(183 - (135 + 40))) or ((2541 - 1492) >= (2672 + 1760))) then
						return "arcane_pulse racials 12";
					end
				end
				v155 = 6 - 3;
			end
			if ((v155 == (0 - 0)) or ((4944 - (50 + 126)) <= (2355 - 1509))) then
				if ((v61.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (5 + 15)) and ((v61.SummonGargoyle:CooldownRemains() < v14:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v14:Rune() < (1415 - (1233 + 180))) and (v89 < (970 - (522 + 447)))))) or ((4779 - (107 + 1314)) <= (659 + 761))) then
					if (v20(v61.ArcaneTorrent, v52, nil, not v16:IsInRange(24 - 16)) or ((1589 + 2150) <= (5967 - 2962))) then
						return "arcane_torrent racials 2";
					end
				end
				if ((v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + (11 - 8)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1970 - (716 + 1194)))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + 1 + 2))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + 1 + 2))) or ((v94 >= (505 - (74 + 429))) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + (5 - 2))))) or ((823 + 836) >= (4884 - 2750))) then
					if (v20(v61.BloodFury, v52) or ((2307 + 953) < (7260 - 4905))) then
						return "blood_fury racials 4";
					end
				end
				v155 = 2 - 1;
			end
			if (((434 - (279 + 154)) == v155) or ((1447 - (454 + 324)) == (3323 + 900))) then
				if ((v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (20 - (12 + 5))) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (33 + 27))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (7 - 4)))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + 2 + 1))) or ((v94 >= (1095 - (277 + 816))) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + (12 - 9))))) or ((2875 - (1058 + 125)) < (111 + 477))) then
					if (v20(v61.Berserking, v52) or ((5772 - (815 + 160)) < (15665 - 12014))) then
						return "berserking racials 6";
					end
				end
				if ((v61.LightsJudgment:IsCastable() and v14:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v14:BuffRemains(v61.FestermightBuff) < v16:TimeToDie()) or (v14:BuffRemains(v61.UnholyStrengthBuff) < v16:TimeToDie()))) or ((9915 - 5738) > (1157 + 3693))) then
					if (v20(v61.LightsJudgment, v52, nil, not v16:IsSpellInRange(v61.LightsJudgment)) or ((1169 - 769) > (3009 - (41 + 1857)))) then
						return "lights_judgment racials 8";
					end
				end
				v155 = 1895 - (1222 + 671);
			end
			if (((7885 - 4834) > (1444 - 439)) and (v155 == (1185 - (229 + 953)))) then
				if (((5467 - (1111 + 663)) <= (5961 - (874 + 705))) and v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (41 + 19))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (6 - 3)))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 1 + 2))) or ((v94 >= (681 - (642 + 37))) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + 1 + 2)))) then
					if (v20(v61.Fireblood, v52) or ((526 + 2756) > (10294 - 6194))) then
						return "fireblood racials 14";
					end
				end
				if ((v61.BagofTricks:IsCastable() and (v94 == (455 - (233 + 221))) and (v14:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 11 - 6))) or ((3152 + 428) < (4385 - (718 + 823)))) then
					if (((57 + 32) < (5295 - (266 + 539))) and v20(v61.BagofTricks, v52, nil, not v16:IsSpellInRange(v61.BagofTricks))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (1226 - (636 + 589))) or ((11828 - 6845) < (3728 - 1920))) then
				if (((3035 + 794) > (1370 + 2399)) and v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (1017 - (657 + 358))) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (34 - 21))) or (v84 and (v85 > (18 - 10))) or (v82 and (v83 > (1195 - (1151 + 36)))) or (not v76 and (v89 >= (4 + 0))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v15:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 + 0)))) then
					if (((4434 - 2949) <= (4736 - (1552 + 280))) and v20(v88, v48)) then
						return "any_dnd st 6";
					end
				end
				if (((5103 - (64 + 770)) == (2899 + 1370)) and v86:IsReady() and (v76 or ((v94 >= (4 - 2)) and v14:BuffUp(v61.DeathAndDecayBuff)))) then
					if (((69 + 318) <= (4025 - (157 + 1086))) and v20(v86, nil, nil, not v16:IsSpellInRange(v86))) then
						return "wound_spender st 8";
					end
				end
				v156 = 3 - 1;
			end
			if ((v156 == (13 - 10)) or ((2912 - 1013) <= (1251 - 334))) then
				if ((v86:IsReady() and not v76) or ((5131 - (599 + 220)) <= (1743 - 867))) then
					if (((4163 - (1813 + 118)) <= (1898 + 698)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v16:IsSpellInRange(v86))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if (((3312 - (841 + 376)) < (5164 - 1478)) and (v156 == (0 + 0))) then
				if ((v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (27 - 17)))) or ((2454 - (464 + 395)) >= (11481 - 7007))) then
					if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((2219 + 2400) < (3719 - (467 + 370)))) then
						return "death_coil st 2";
					end
				end
				if ((v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (20 - 10)))) or ((216 + 78) >= (16560 - 11729))) then
					if (((317 + 1712) <= (7174 - 4090)) and v20(v61.Epidemic, v55, nil, not v16:IsInRange(560 - (150 + 370)))) then
						return "epidemic st 4";
					end
				end
				v156 = 1283 - (74 + 1208);
			end
			if ((v156 == (4 - 2)) or ((9660 - 7623) == (1722 + 698))) then
				if (((4848 - (14 + 376)) > (6770 - 2866)) and v61.FesteringStrike:IsReady() and not v76) then
					if (((283 + 153) >= (109 + 14)) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v16:IsInMeleeRange(5 + 0))) then
						return "festering_strike st 10";
					end
				end
				if (((1465 - 965) < (1367 + 449)) and v61.DeathCoil:IsReady()) then
					if (((3652 - (23 + 55)) == (8469 - 4895)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil st 12";
					end
				end
				v156 = 3 + 0;
			end
		end
	end
	local function v125()
		if (((199 + 22) < (604 - 214)) and v33) then
			local v161 = v115();
			if (v161 or ((697 + 1516) <= (2322 - (652 + 249)))) then
				return v161;
			end
		end
	end
	local function v126()
		v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (7 - 4))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (1872 - (708 + 1160)))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (5 - 3)));
		v71 = (v94 >= (5 - 2)) or ((v61.SummonGargoyle:CooldownRemains() > (28 - (10 + 17))) and ((v61.Apocalypse:CooldownRemains() > (1 + 0)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v10.CombatTime() > (1752 - (1400 + 332)));
		v74 = ((v61.Apocalypse:CooldownRemains() < (19 - 9)) and (v89 <= (1912 - (242 + 1666))) and (v61.UnholyAssault:CooldownRemains() > (5 + 5)) and (3 + 4)) or (2 + 0);
		if (((3998 - (850 + 90)) < (8512 - 3652)) and not v84 and v61.Festermight:IsAvailable() and v14:BuffUp(v61.FestermightBuff) and ((v14:BuffRemains(v61.FestermightBuff) / ((1395 - (360 + 1030)) * v14:GCD())) >= (1 + 0))) then
			v75 = v89 >= (2 - 1);
		else
			v75 = v89 >= ((3 - 0) - v22(v61.InfectedClaws:IsAvailable()));
		end
		v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (1662 - (909 + 752))) and (v61.UnholyAssault:CooldownRemains() < (1243 - (109 + 1114))) and v61.UnholyAssault:IsAvailable() and v78) or (v16:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1 - 0))) or (v89 > (2 + 2)) or (v14:HasTier(273 - (6 + 236), 3 + 1) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 + 0))))) or ((v91 < (11 - 6)) and (v89 >= (1 - 0)));
		v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (1136 - (1076 + 57))) and (v14:RunicPower() < (10 + 50)) and not v78;
		v78 = (v94 == (690 - (579 + 110))) or not v28;
		v79 = (v94 >= (1 + 1)) and v28;
		v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v16:DebuffDown(v61.RottenTouchDebuff)) or (v14:RunicPowerDeficit() < (18 + 2))) and (not v14:HasTier(17 + 14, 411 - (174 + 233)) or (v14:HasTier(86 - 55, 6 - 2) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v14:RunicPowerDeficit() < (9 + 11)) or (v14:Rune() < (1177 - (663 + 511)))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (2 + 0)) or v61.CoilofDevastation:IsAvailable())) or (v14:Rune() < (1 + 2)) or v84 or v14:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (30 - 20)) and (v89 > (2 + 1))) or (not v76 and (v89 >= (9 - 5))));
	end
	local function v127()
		v60();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v69 = not v99();
		v93 = v14:GetEnemiesInMeleeRange(12 - 7);
		v95 = v16:GetEnemiesInSplashRange(5 + 5);
		if (v28 or ((2522 - 1226) >= (3169 + 1277))) then
			v94 = #v93;
			v96 = v16:GetEnemiesInSplashRangeCount(1 + 9);
		else
			v94 = 723 - (478 + 244);
			v96 = 518 - (440 + 77);
		end
		if (v70.TargetIsValid() or v14:AffectingCombat() or ((634 + 759) > (16429 - 11940))) then
			local v162 = 1556 - (655 + 901);
			while true do
				if ((v162 == (0 + 0)) or ((3387 + 1037) < (19 + 8))) then
					v90 = v10.BossFightRemains();
					v91 = v90;
					if ((v91 == (44762 - 33651)) or ((3442 - (695 + 750)) > (13026 - 9211))) then
						v91 = v10.FightRemains(v93, false);
					end
					v97 = v100(v95);
					v162 = 1 - 0;
				end
				if (((13935 - 10470) > (2264 - (285 + 66))) and (v162 == (2 - 1))) then
					v80 = v61.Apocalypse:TimeSinceLastCast() <= (1325 - (682 + 628));
					v81 = (v80 and ((3 + 12) - v61.Apocalypse:TimeSinceLastCast())) or (299 - (176 + 123));
					v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (13 + 17);
					v83 = (v82 and ((22 + 8) - v61.ArmyoftheDead:TimeSinceLastCast())) or (269 - (239 + 30));
					v162 = 1 + 1;
				end
				if (((705 + 28) < (3219 - 1400)) and (v162 == (5 - 3))) then
					v84 = v92:GargActive();
					v85 = v92:GargRemains();
					v89 = v16:DebuffStack(v61.FesteringWoundDebuff);
					break;
				end
			end
		end
		if (v70.TargetIsValid() or ((4710 - (306 + 9)) == (16593 - 11838))) then
			local v163 = 0 + 0;
			local v164;
			while true do
				if ((v163 == (1 + 0)) or ((1826 + 1967) < (6774 - 4405))) then
					v126();
					v164 = v122();
					if (v164 or ((5459 - (1140 + 235)) == (169 + 96))) then
						return v164;
					end
					v163 = 2 + 0;
				end
				if (((1119 + 3239) == (4410 - (33 + 19))) and (v163 == (1 + 1))) then
					if (v33 or ((9405 - 6267) < (438 + 555))) then
						local v186 = v125();
						if (((6530 - 3200) > (2179 + 144)) and v186) then
							return v186;
						end
					end
					if ((v29 and not v71) or ((4315 - (586 + 103)) == (364 + 3625))) then
						local v187 = 0 - 0;
						local v188;
						while true do
							if ((v187 == (1488 - (1309 + 179))) or ((1653 - 737) == (1163 + 1508))) then
								v188 = v121();
								if (((730 - 458) == (206 + 66)) and v188) then
									return v188;
								end
								break;
							end
						end
					end
					if (((9027 - 4778) <= (9641 - 4802)) and v29 and v78) then
						local v189 = v120();
						if (((3386 - (295 + 314)) < (7859 - 4659)) and v189) then
							return v189;
						end
					end
					v163 = 1965 - (1300 + 662);
				end
				if (((298 - 203) < (3712 - (1178 + 577))) and (v163 == (3 + 1))) then
					if (((2441 - 1615) < (3122 - (851 + 554))) and (v94 <= (3 + 0))) then
						local v190 = 0 - 0;
						local v191;
						while true do
							if (((3096 - 1670) >= (1407 - (115 + 187))) and (v190 == (0 + 0))) then
								v191 = v124();
								if (((2608 + 146) <= (13315 - 9936)) and v191) then
									return v191;
								end
								break;
							end
						end
					end
					if (v61.FesteringStrike:IsReady() or ((5088 - (160 + 1001)) == (1237 + 176))) then
						if (v20(v61.FesteringStrike, nil, nil) or ((797 + 357) <= (1612 - 824))) then
							return "festering_strike precombat 8";
						end
					end
					break;
				end
				if ((v163 == (358 - (237 + 121))) or ((2540 - (525 + 372)) > (6405 - 3026))) then
					if (not v14:AffectingCombat() or ((9209 - 6406) > (4691 - (96 + 46)))) then
						local v192 = 777 - (643 + 134);
						local v193;
						while true do
							if ((v192 == (0 + 0)) or ((527 - 307) >= (11219 - 8197))) then
								v193 = v114();
								if (((2707 + 115) == (5537 - 2715)) and v193) then
									return v193;
								end
								break;
							end
						end
					end
					if ((v61.DeathStrike:IsReady() and not v69) or ((2168 - 1107) == (2576 - (316 + 403)))) then
						if (((1835 + 925) > (3750 - 2386)) and v20(v61.DeathStrike)) then
							return "death_strike low hp or proc";
						end
					end
					if ((v94 == (0 + 0)) or ((12344 - 7442) <= (2548 + 1047))) then
						if ((v61.Outbreak:IsReady() and (v97 > (0 + 0))) or ((13346 - 9494) == (1399 - 1106))) then
							if (v20(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or ((3238 - 1679) == (263 + 4325))) then
								return "outbreak out_of_range";
							end
						end
						if ((v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (1 - 0)) and not v77) or ((220 + 4264) == (2318 - 1530))) then
							if (((4585 - (12 + 5)) >= (15174 - 11267)) and v20(v61.Epidemic, v55, nil, not v16:IsInRange(85 - 45))) then
								return "epidemic out_of_range";
							end
						end
						if (((2648 - 1402) < (8605 - 5135)) and v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (1 + 1)) and not v77) then
							if (((6041 - (1656 + 317)) >= (867 + 105)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
								return "death_coil out_of_range";
							end
						end
					end
					v163 = 1 + 0;
				end
				if (((1310 - 817) < (19159 - 15266)) and (v163 == (357 - (5 + 349)))) then
					if ((v28 and v29 and v79) or ((6996 - 5523) >= (4603 - (266 + 1005)))) then
						local v194 = 0 + 0;
						local v195;
						while true do
							if ((v194 == (0 - 0)) or ((5333 - 1282) <= (2853 - (561 + 1135)))) then
								v195 = v118();
								if (((786 - 182) < (9470 - 6589)) and v195) then
									return v195;
								end
								break;
							end
						end
					end
					if (v29 or ((1966 - (507 + 559)) == (8473 - 5096))) then
						local v196 = 0 - 0;
						local v197;
						while true do
							if (((4847 - (212 + 176)) > (1496 - (250 + 655))) and (v196 == (0 - 0))) then
								v197 = v123();
								if (((5937 - 2539) >= (3747 - 1352)) and v197) then
									return v197;
								end
								break;
							end
						end
					end
					if (v28 or ((4139 - (1869 + 87)) >= (9794 - 6970))) then
						if (((3837 - (484 + 1417)) == (4149 - 2213)) and v79 and (v87:CooldownRemains() < (16 - 6)) and v14:BuffDown(v61.DeathAndDecayBuff)) then
							local v198 = 773 - (48 + 725);
							local v199;
							while true do
								if ((v198 == (0 - 0)) or ((12963 - 8131) < (2507 + 1806))) then
									v199 = v119();
									if (((10924 - 6836) > (1085 + 2789)) and v199) then
										return v199;
									end
									break;
								end
							end
						end
						if (((1263 + 3069) == (5185 - (152 + 701))) and (v94 >= (1315 - (430 + 881))) and v14:BuffUp(v61.DeathAndDecayBuff)) then
							local v200 = 0 + 0;
							local v201;
							while true do
								if (((4894 - (557 + 338)) >= (858 + 2042)) and (v200 == (0 - 0))) then
									v201 = v117();
									if (v201 or ((8841 - 6316) > (10796 - 6732))) then
										return v201;
									end
									break;
								end
							end
						end
						if (((9420 - 5049) == (5172 - (499 + 302))) and (v94 >= (870 - (39 + 827))) and (((v87:CooldownRemains() > (27 - 17)) and v14:BuffDown(v61.DeathAndDecayBuff)) or not v79)) then
							local v202 = 0 - 0;
							local v203;
							while true do
								if ((v202 == (0 - 0)) or ((407 - 141) > (427 + 4559))) then
									v203 = v116();
									if (((5827 - 3836) >= (148 + 777)) and v203) then
										return v203;
									end
									break;
								end
							end
						end
					end
					v163 = 5 - 1;
				end
			end
		end
	end
	local function v128()
		v61.VirulentPlagueDebuff:RegisterAuraTracking();
		v61.FesteringWoundDebuff:RegisterAuraTracking();
		v10.Print("Unholy DK by Epic. Work in Progress Gojira");
	end
	v10.SetAPL(356 - (103 + 1), v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

