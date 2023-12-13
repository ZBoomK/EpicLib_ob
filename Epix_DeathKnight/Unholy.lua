local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((816 + 233) < (4806 - 2889)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((1598 + 1238) > (2128 - (1607 + 27))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1727 - (1668 + 58))) or ((3352 - (512 + 114)) == (10086 - 6217))) then
			return v6(...);
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
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (1994 - (109 + 1885));
		v44 = EpicSettings.Settings['UseDarkSuccorHP'] or (1469 - (1269 + 200));
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
	local v63 = v21.DeathKnight.Unholy;
	local v64 = {v62.AlgetharPuzzleBox:ID(),v62.Fyralath:ID(),v62.IrideusFragment:ID(),v62.VialofAnimatedBlood:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[15 - 2] and v19(v65[2 + 11])) or v19(0 + 0);
	local v67 = (v65[3 + 11] and v19(v65[4 + 10])) or v19(0 - 0);
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
	local v90 = 37052 - 25941;
	local v91 = 3975 + 7136;
	local v92 = v10.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v147 = 1433 - (797 + 636);
		while true do
			if (((4 - 3) == v147) or ((5995 - (1427 + 192)) <= (514 + 967))) then
				v67 = (v65[32 - 18] and v19(v65[13 + 1])) or v19(0 + 0);
				break;
			end
			if ((v147 == (326 - (192 + 134))) or ((4668 - (316 + 960)) >= (2639 + 2102))) then
				v65 = v14:GetEquipment();
				v66 = (v65[11 + 2] and v19(v65[13 + 0])) or v19(0 - 0);
				v147 = 552 - (83 + 468);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v148 = 1806 - (1202 + 604);
		while true do
			if (((15521 - 12196) >= (3584 - 1430)) and (v148 == (0 - 0))) then
				v90 = 11436 - (45 + 280);
				v91 = 10725 + 386;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (0 + 0)) or ((717 + 578) >= (569 + 2664))) then
				v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
				v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
				v149 = 1 - 0;
			end
			if (((6288 - (340 + 1571)) > (648 + 994)) and (v149 == (1773 - (1733 + 39)))) then
				v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v14:HealthPercentage() < v43) or ((v14:HealthPercentage() < v44) and v14:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v150)
		local v151 = 0 - 0;
		local v152;
		while true do
			if (((5757 - (125 + 909)) > (3304 - (1096 + 852))) and (v151 == (0 + 0))) then
				v152 = 0 - 0;
				for v185, v186 in pairs(v150) do
					if (v186:DebuffDown(v61.VirulentPlagueDebuff) or ((4012 + 124) <= (3945 - (409 + 103)))) then
						v152 = v152 + (237 - (46 + 190));
					end
				end
				v151 = 96 - (51 + 44);
			end
			if (((1198 + 3047) <= (5948 - (1114 + 203))) and (v151 == (727 - (228 + 498)))) then
				return v152;
			end
		end
	end
	local function v101(v153)
		local v154 = 0 + 0;
		local v155;
		while true do
			if (((2363 + 1913) >= (4577 - (174 + 489))) and ((2 - 1) == v154)) then
				return v10.FightRemains(v155);
			end
			if (((2103 - (830 + 1075)) <= (4889 - (303 + 221))) and (v154 == (1269 - (231 + 1038)))) then
				v155 = {};
				for v187 in pairs(v153) do
					if (((3985 + 797) > (5838 - (171 + 991))) and not v13:IsInBossList(v153[v187]['UnitNPCID'])) then
						v30(v155, v153[v187]);
					end
				end
				v154 = 4 - 3;
			end
		end
	end
	local function v102(v156)
		return (v156:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v157)
		return (v157:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v158)
		return (v61.BurstingSores:IsAvailable() and v158:DebuffUp(v61.FesteringWoundDebuff) and ((v14:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v14:Rune() < (7 - 4))) or (v14:BuffUp(v61.DeathAndDecayBuff) and (v14:Rune() == (0 - 0))))) or (not v61.BurstingSores:IsAvailable() and (v158:DebuffStack(v61.FesteringWoundDebuff) >= (4 + 0))) or (v14:HasTier(108 - 77, 5 - 3) and v158:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v159)
		return v159:DebuffStack(v61.FesteringWoundDebuff) >= (5 - 1);
	end
	local function v106(v160)
		return v160:DebuffStack(v61.FesteringWoundDebuff) < (12 - 8);
	end
	local function v107(v161)
		return v161:DebuffStack(v61.FesteringWoundDebuff) < (1252 - (111 + 1137));
	end
	local function v108(v162)
		return v162:DebuffStack(v61.FesteringWoundDebuff) >= (162 - (91 + 67));
	end
	local function v109(v163)
		return ((v163:TimeToX(104 - 69) < (2 + 3)) or (v163:HealthPercentage() <= (558 - (423 + 100)))) and (v163:TimeToDie() > (v163:DebuffRemains(v61.SoulReaper) + 1 + 4));
	end
	local function v110(v164)
		return (v164:DebuffStack(v61.FesteringWoundDebuff) <= (5 - 3)) or v15:BuffUp(v61.DarkTransformation);
	end
	local function v111(v165)
		return (v165:DebuffStack(v61.FesteringWoundDebuff) >= (3 + 1)) and (v87:CooldownRemains() < (774 - (326 + 445)));
	end
	local function v112(v166)
		return v166:DebuffStack(v61.FesteringWoundDebuff) >= (4 - 3);
	end
	local function v113(v167)
		return (v167:TimeToDie() > v167:DebuffRemains(v61.VirulentPlagueDebuff)) and (v167:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v167:DebuffRefreshable(v61.FrostFeverDebuff) or v167:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((33 - 18) / ((v22(v61.Superstrain:IsAvailable()) * (6 - 3)) + (v22(v61.Plaguebringer:IsAvailable()) * (713 - (530 + 181))) + (v22(v61.EbonFever:IsAvailable()) * (883 - (614 + 267))))))));
	end
	local function v114()
		if (((4896 - (19 + 13)) > (3575 - 1378)) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive() or not v15:IsActive())) then
			if (v20(v61.RaiseDead, nil) or ((8622 - 4922) == (7161 - 4654))) then
				return "raise_dead precombat 2 displaystyle";
			end
		end
		if (((1162 + 3312) >= (481 - 207)) and v61.ArmyoftheDead:IsReady() and v29) then
			if (v20(v61.ArmyoftheDead, nil) or ((3927 - 2033) <= (3218 - (1293 + 519)))) then
				return "army_of_the_dead precombat 4";
			end
		end
		if (((3206 - 1634) >= (3997 - 2466)) and v61.Outbreak:IsReady()) then
			if (v20(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or ((8962 - 4275) < (19585 - 15043))) then
				return "outbreak precombat 6";
			end
		end
		if (((7752 - 4461) > (883 + 784)) and v61.FesteringStrike:IsReady()) then
			if (v20(v61.FesteringStrike, nil, nil, not v16:IsInMeleeRange(2 + 3)) or ((2027 - 1154) == (471 + 1563))) then
				return "festering_strike precombat 8";
			end
		end
	end
	local function v115()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (0 + 0)) or ((3912 - (709 + 387)) < (1869 - (673 + 1185)))) then
				v68 = v70.HandleTopTrinket(v64, v29, 116 - 76, nil);
				if (((11877 - 8178) < (7742 - 3036)) and v68) then
					return v68;
				end
				v168 = 1 + 0;
			end
			if (((1978 + 668) >= (1181 - 305)) and (v168 == (1 + 0))) then
				v68 = v70.HandleBottomTrinket(v64, v29, 79 - 39, nil);
				if (((1205 - 591) <= (5064 - (446 + 1434))) and v68) then
					return v68;
				end
				break;
			end
		end
	end
	local function v116()
		local v169 = 1283 - (1040 + 243);
		while true do
			if (((9329 - 6203) == (4973 - (559 + 1288))) and (v169 == (1932 - (609 + 1322)))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((2641 - (13 + 441)) >= (18512 - 13558))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v16:IsInMeleeRange(13 - 8)) or ((19309 - 15432) == (134 + 3441))) then
						return "festering_strike aoe 6";
					end
				end
				if (((2567 - 1860) > (225 + 407)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((240 + 306) >= (7964 - 5280))) then
						return "death_coil aoe 8";
					end
				end
				break;
			end
			if (((802 + 663) <= (7910 - 3609)) and ((0 + 0) == v169)) then
				if (((948 + 756) > (1024 + 401)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (9 + 1)))) then
					if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(30 + 0)) or ((1120 - (153 + 280)) == (12225 - 7991))) then
						return "epidemic aoe 2";
					end
				end
				if ((v86:IsReady() and v76) or ((2990 + 340) < (565 + 864))) then
					if (((601 + 546) >= (305 + 30)) and v70.CastTargetIf(v86, v93, "max", v102, nil, not v16:IsSpellInRange(v86))) then
						return "wound_spender aoe 4";
					end
				end
				v169 = 1 + 0;
			end
		end
	end
	local function v117()
		local v170 = 0 - 0;
		while true do
			if (((2124 + 1311) > (2764 - (89 + 578))) and (v170 == (2 + 0))) then
				if (v86:IsReady() or ((7837 - 4067) >= (5090 - (572 + 477)))) then
					if (v20(v86, nil, nil, not v16:IsSpellInRange(v86)) or ((512 + 3279) <= (967 + 644))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if ((v170 == (1 + 0)) or ((4664 - (84 + 2)) <= (3309 - 1301))) then
				if (((811 + 314) <= (2918 - (497 + 345))) and v61.Epidemic:IsReady() and (not v77 or (v91 < (1 + 9)))) then
					if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(7 + 33)) or ((2076 - (605 + 728)) >= (3139 + 1260))) then
						return "epidemic aoe_burst 6";
					end
				end
				if (((2567 - 1412) < (77 + 1596)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((8592 - 6268) <= (522 + 56))) then
						return "death_coil aoe_burst 8";
					end
				end
				v170 = 5 - 3;
			end
			if (((2845 + 922) == (4256 - (457 + 32))) and (v170 == (0 + 0))) then
				if (((5491 - (832 + 570)) == (3853 + 236)) and v61.Epidemic:IsReady() and ((v14:Rune() < (1 + 0)) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (0 - 0)))) and not v77 and ((v94 >= (3 + 3)) or (v14:RunicPowerDeficit() < (826 - (588 + 208))) or (v14:BuffStack(v61.FestermightBuff) == (53 - 33)))) then
					if (((6258 - (884 + 916)) >= (3504 - 1830)) and v20(v61.Epidemic, v55, nil, not v16:IsInRange(24 + 16))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (((1625 - (232 + 421)) <= (3307 - (1569 + 320))) and v86:IsReady()) then
					if (v70.CastTargetIf(v86, v93, "max", v102, v112, not v16:IsSpellInRange(v86)) or ((1212 + 3726) < (905 + 3857))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v170 = 3 - 2;
			end
		end
	end
	local function v118()
		if ((v61.VileContagion:IsReady() and (v87:CooldownRemains() < (608 - (316 + 289)))) or ((6554 - 4050) > (197 + 4067))) then
			if (((3606 - (666 + 787)) == (2578 - (360 + 65))) and v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v16:IsSpellInRange(v61.VileContagion))) then
				return "vile_contagion aoe_cooldowns 2";
			end
		end
		if (v61.SummonGargoyle:IsReady() or ((474 + 33) >= (2845 - (79 + 175)))) then
			if (((7065 - 2584) == (3497 + 984)) and v20(v61.SummonGargoyle, v56)) then
				return "summon_gargoyle aoe_cooldowns 4";
			end
		end
		if ((v61.AbominationLimb:IsCastable() and ((v14:Rune() < (5 - 3)) or (v89 > (19 - 9)) or not v61.Festermight:IsAvailable() or (v14:BuffUp(v61.FestermightBuff) and (v14:BuffRemains(v61.FestermightBuff) < (911 - (503 + 396)))))) or ((2509 - (92 + 89)) < (1343 - 650))) then
			if (((2220 + 2108) == (2562 + 1766)) and v20(v61.AbominationLimb, nil, nil, not v16:IsInRange(78 - 58))) then
				return "abomination_limb aoe_cooldowns 6";
			end
		end
		if (((218 + 1370) >= (3036 - 1704)) and v61.Apocalypse:IsReady()) then
			if (v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v16:IsInMeleeRange(5 + 0)) or ((1994 + 2180) > (12937 - 8689))) then
				return "apocalypse aoe_cooldowns 8";
			end
		end
		if (v61.UnholyAssault:IsCastable() or ((573 + 4013) <= (124 - 42))) then
			if (((5107 - (485 + 759)) == (8938 - 5075)) and v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v16:IsInMeleeRange(1194 - (442 + 747)), Settings.Unholy.GCDasOffGCD.UnholyAssault)) then
				return "unholy_assault aoe_cooldowns 10";
			end
		end
		if ((v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) or ((1417 - (832 + 303)) <= (988 - (88 + 858)))) then
			if (((1405 + 3204) >= (634 + 132)) and v20(v61.RaiseDead, nil)) then
				return "raise_dead aoe_cooldowns 12";
			end
		end
		if ((v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (1 + 9)) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) or ((1941 - (766 + 23)) == (12282 - 9794))) then
			if (((4679 - 1257) > (8826 - 5476)) and v20(v61.DarkTransformation, v54)) then
				return "dark_transformation aoe_cooldowns 14";
			end
		end
		if (((2976 - 2099) > (1449 - (1036 + 37))) and v61.EmpowerRuneWeapon:IsCastable() and (v15:BuffUp(v61.DarkTransformation))) then
			if (v20(v61.EmpowerRuneWeapon, v49) or ((2211 + 907) <= (3604 - 1753))) then
				return "empower_rune_weapon aoe_cooldowns 16";
			end
		end
		if ((v61.SacrificialPact:IsReady() and ((v15:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (5 + 1))) or (v91 < v14:GCD()))) or ((1645 - (641 + 839)) >= (4405 - (910 + 3)))) then
			if (((10066 - 6117) < (6540 - (1466 + 218))) and v20(v61.SacrificialPact, v50)) then
				return "sacrificial_pact aoe_cooldowns 18";
			end
		end
	end
	local function v119()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (1149 - (556 + 592))) or ((1521 + 2755) < (3824 - (329 + 479)))) then
				if (((5544 - (174 + 680)) > (14174 - 10049)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (20 - 10)))) then
					if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(29 + 11)) or ((789 - (396 + 343)) >= (80 + 816))) then
						return "epidemic aoe_setup 6";
					end
				end
				if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) or ((3191 - (29 + 1448)) >= (4347 - (135 + 1254)))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v16:IsInMeleeRange(18 - 13)) or ((6961 - 5470) < (430 + 214))) then
						return "festering_strike aoe_setup 8";
					end
				end
				v171 = 1529 - (389 + 1138);
			end
			if (((1278 - (102 + 472)) < (932 + 55)) and (v171 == (2 + 0))) then
				if (((3467 + 251) > (3451 - (320 + 1225))) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v16:IsInMeleeRange(8 - 3)) or ((587 + 371) > (5099 - (157 + 1307)))) then
						return "festering_strike aoe_setup 10";
					end
				end
				if (((5360 - (821 + 1038)) <= (11207 - 6715)) and v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) then
					if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((377 + 3065) < (4525 - 1977))) then
						return "death_coil aoe_setup 12";
					end
				end
				break;
			end
			if (((1070 + 1805) >= (3628 - 2164)) and (v171 == (1026 - (834 + 192)))) then
				if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (1 + 7)))) or ((1232 + 3565) >= (106 + 4787))) then
					if (v20(v88, v48) or ((853 - 302) > (2372 - (300 + 4)))) then
						return "any_dnd aoe_setup 2";
					end
				end
				if (((565 + 1549) > (2471 - 1527)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v16:IsInMeleeRange(367 - (112 + 250))) or ((902 + 1360) >= (7756 - 4660))) then
						return "festering_strike aoe_setup 4";
					end
				end
				v171 = 1 + 0;
			end
		end
	end
	local function v120()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (3 + 1)) or ((1119 + 1136) >= (2628 + 909))) then
				if ((v61.SoulReaper:IsReady() and (v94 >= (1416 - (1001 + 413)))) or ((8556 - 4719) < (2188 - (244 + 638)))) then
					if (((3643 - (627 + 66)) == (8789 - 5839)) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v16:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if ((v172 == (602 - (512 + 90))) or ((6629 - (1665 + 241)) < (4015 - (373 + 344)))) then
				if (((513 + 623) >= (41 + 113)) and v61.SummonGargoyle:IsCastable() and (v14:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) then
					if (v20(v61.SummonGargoyle, v56) or ((714 - 443) > (8034 - 3286))) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if (((5839 - (35 + 1064)) >= (2294 + 858)) and v61.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
					if (v20(v61.RaiseDead, nil) or ((5515 - 2937) >= (14 + 3376))) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v172 = 1237 - (298 + 938);
			end
			if (((1300 - (233 + 1026)) <= (3327 - (636 + 1030))) and (v172 == (2 + 0))) then
				if (((588 + 13) < (1058 + 2502)) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (2 + 21))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v15:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v15:BuffUp(v61.DarkTransformation)))) or (v91 <= (242 - (55 + 166))))) then
					if (((46 + 189) < (70 + 617)) and v20(v61.EmpowerRuneWeapon, v49)) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if (((17372 - 12823) > (1450 - (36 + 261))) and v61.AbominationLimb:IsCastable() and (v14:Rune() < (4 - 1)) and v78) then
					if (v20(v61.AbominationLimb) or ((6042 - (34 + 1334)) < (1797 + 2875))) then
						return "abomination_limb cooldowns 12";
					end
				end
				v172 = 3 + 0;
			end
			if (((4951 - (1035 + 248)) < (4582 - (20 + 1))) and (v172 == (2 + 1))) then
				if ((v61.UnholyAssault:IsReady() and v78) or ((774 - (134 + 185)) == (4738 - (549 + 584)))) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v16:IsInMeleeRange(690 - (314 + 371)), Settings.Unholy.GCDasOffGCD.UnholyAssault) or ((9141 - 6478) == (4280 - (478 + 490)))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if (((2266 + 2011) <= (5647 - (786 + 386))) and v61.SoulReaper:IsReady() and (v94 == (3 - 2)) and ((v16:TimeToX(1414 - (1055 + 324)) < (1345 - (1093 + 247))) or (v16:HealthPercentage() <= (32 + 3))) and (v16:TimeToDie() > (1 + 4))) then
					if (v20(v61.SoulReaper, nil, nil, not v16:IsSpellInRange(v61.SoulReaper)) or ((3454 - 2584) == (4034 - 2845))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v172 = 10 - 6;
			end
			if (((3902 - 2349) <= (1115 + 2018)) and (v172 == (3 - 2))) then
				if ((v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (17 - 12))) or ((1687 + 550) >= (8978 - 5467))) then
					if (v20(v61.DarkTransformation, v54) or ((2012 - (364 + 324)) > (8278 - 5258))) then
						return "dark_transformation cooldowns 6";
					end
				end
				if ((v61.Apocalypse:IsReady() and v78) or ((7179 - 4187) == (624 + 1257))) then
					if (((12996 - 9890) > (2443 - 917)) and v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v16:IsInMeleeRange(15 - 10), Settings.Unholy.GCDasOffGCD.Apocalypse)) then
						return "apocalypse cooldowns 8";
					end
				end
				v172 = 1270 - (1249 + 19);
			end
		end
	end
	local function v121()
		local v173 = 0 + 0;
		while true do
			if (((11766 - 8743) < (4956 - (686 + 400))) and (v173 == (0 + 0))) then
				if (((372 - (73 + 156)) > (1 + 73)) and v61.Apocalypse:IsReady() and (v89 >= (815 - (721 + 90))) and ((v14:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (1 + 22))) or not v61.CommanderoftheDead:IsAvailable())) then
					if (((58 - 40) < (2582 - (224 + 246))) and v20(v61.Apocalypse, v53, nil, not v16:IsInMeleeRange(8 - 3))) then
						return "apocalypse garg_setup 2";
					end
				end
				if (((2019 - 922) <= (296 + 1332)) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (1 + 2)) or v14:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (8 + 2))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) then
					if (((9205 - 4575) == (15407 - 10777)) and v20(v61.ArmyoftheDead)) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v173 = 514 - (203 + 310);
			end
			if (((5533 - (1238 + 755)) > (188 + 2495)) and (v173 == (1537 - (709 + 825)))) then
				if (((8834 - 4040) >= (4770 - 1495)) and v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and (v89 > (864 - (196 + 668)))) then
					if (((5859 - 4375) == (3073 - 1589)) and v20(v88, v48)) then
						return "any_dnd garg_setup 18";
					end
				end
				if (((2265 - (171 + 662)) < (3648 - (4 + 89))) and v61.FesteringStrike:IsReady() and ((v89 == (0 - 0)) or not v61.Apocalypse:IsAvailable() or ((v14:RunicPower() < (15 + 25)) and not v84))) then
					if (v20(v61.FesteringStrike, nil, nil, not v16:IsInMeleeRange(21 - 16)) or ((418 + 647) > (5064 - (35 + 1451)))) then
						return "festering_strike garg_setup 20";
					end
				end
				v173 = 1457 - (28 + 1425);
			end
			if ((v173 == (1995 - (941 + 1052))) or ((4598 + 197) < (2921 - (822 + 692)))) then
				if (((2644 - 791) < (2268 + 2545)) and v29 and v84 and (v85 <= (320 - (45 + 252)))) then
					local v188 = 0 + 0;
					while true do
						if ((v188 == (0 + 0)) or ((6865 - 4044) < (2864 - (114 + 319)))) then
							if (v61.EmpowerRuneWeapon:IsCastable() or ((4126 - 1252) < (2794 - 613))) then
								if (v20(v61.EmpowerRuneWeapon, v49) or ((1715 + 974) <= (510 - 167))) then
									return "empower_rune_weapon garg_setup 10";
								end
							end
							if (v61.UnholyAssault:IsCastable() or ((3915 - 2046) == (3972 - (556 + 1407)))) then
								if (v20(v61.UnholyAssault, v57, nil, not v16:IsInMeleeRange(1211 - (741 + 465))) or ((4011 - (170 + 295)) < (1224 + 1098))) then
									return "unholy_assault garg_setup 12";
								end
							end
							break;
						end
					end
				end
				if ((v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() > (37 + 3))) or not v61.CommanderoftheDead:IsAvailable())) or ((5125 - 3043) == (3957 + 816))) then
					if (((2081 + 1163) > (598 + 457)) and v20(v61.DarkTransformation, v54)) then
						return "dark_transformation garg_setup 16";
					end
				end
				v173 = 1233 - (957 + 273);
			end
			if ((v173 == (2 + 2)) or ((1327 + 1986) <= (6774 - 4996))) then
				if ((v61.DeathCoil:IsReady() and (v14:Rune() <= (2 - 1))) or ((4340 - 2919) >= (10418 - 8314))) then
					if (((3592 - (389 + 1391)) <= (2039 + 1210)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
			if (((169 + 1454) <= (4454 - 2497)) and (v173 == (952 - (783 + 168)))) then
				if (((14807 - 10395) == (4340 + 72)) and v61.SoulReaper:IsReady() and (v94 == (312 - (309 + 2))) and ((v16:TimeToX(107 - 72) < (1217 - (1090 + 122))) or (v16:HealthPercentage() <= (12 + 23))) and (v16:TimeToDie() > (16 - 11))) then
					if (((1198 + 552) >= (1960 - (628 + 490))) and v20(v61.SoulReaper, nil, nil, not v16:IsInMeleeRange(1 + 4))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if (((10824 - 6452) > (8454 - 6604)) and v61.SummonGargoyle:IsCastable() and v29 and (v14:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v14:RunicPower() >= (814 - (431 + 343)))))) then
					if (((468 - 236) < (2374 - 1553)) and v20(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v173 = 2 + 0;
			end
		end
	end
	local function v122()
		if (((67 + 451) < (2597 - (556 + 1139))) and v45) then
			if (((3009 - (6 + 9)) > (158 + 700)) and v61.AntiMagicShell:IsCastable() and (v14:RunicPowerDeficit() > (21 + 19)) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (209 - (28 + 141))))) then
				if (v20(v61.AntiMagicShell, v46) or ((1455 + 2300) <= (1129 - 214))) then
					return "antimagic_shell ams_amz 2";
				end
			end
			if (((2795 + 1151) > (5060 - (486 + 831))) and v61.AntiMagicZone:IsCastable() and (v14:RunicPowerDeficit() > (182 - 112)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) then
				if (v20(v61.AntiMagicZone, v47) or ((4700 - 3365) >= (625 + 2681))) then
					return "antimagic_zone ams_amz 4";
				end
			end
		end
		if (((15316 - 10472) > (3516 - (668 + 595))) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (2 + 0))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (8 + 27)))) then
			if (((1232 - 780) == (742 - (23 + 267))) and v20(v61.ArmyoftheDead)) then
				return "army_of_the_dead high_prio_actions 4";
			end
		end
		if ((v61.DeathCoil:IsReady() and ((v94 <= (1947 - (1129 + 815))) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (392 - (371 + 16))) and (v14:BuffRemains(v61.CommanderoftheDeadBuff) > (1777 - (1326 + 424)))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) or ((8630 - 4073) < (7626 - 5539))) then
			if (((3992 - (88 + 30)) == (4645 - (720 + 51))) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil high_prio_actions 6";
			end
		end
		if ((v61.Epidemic:IsReady() and (v96 >= (8 - 4)) and ((v61.CommanderoftheDead:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (1781 - (421 + 1355)))) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) or ((3197 - 1259) > (2425 + 2510))) then
			if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(1123 - (286 + 797))) or ((15554 - 11299) < (5668 - 2245))) then
				return "epidemic high_prio_actions 8";
			end
		end
		if (((1893 - (397 + 42)) <= (779 + 1712)) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (803 - (24 + 776)))) or (v94 >= (4 - 1))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v14:BuffRemains(v61.PlaguebringerBuff) < v14:GCD())) then
			if (v20(v86, nil, nil, not v16:IsSpellInRange(v86)) or ((4942 - (222 + 563)) <= (6175 - 3372))) then
				return "wound_spender high_prio_actions 10";
			end
		end
		if (((3495 + 1358) >= (3172 - (23 + 167))) and v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (1819 - (690 + 1108))))) then
			if (((1492 + 2642) > (2769 + 588)) and v20(v61.UnholyBlight, v58, nil, not v16:IsInRange(856 - (40 + 808)))) then
				return "unholy_blight high_prio_actions 12";
			end
		end
		if (v61.Outbreak:IsReady() or ((563 + 2854) < (9689 - 7155))) then
			if (v70.CastCycle(v61.Outbreak, v93, v113, not v16:IsSpellInRange(v61.Outbreak)) or ((2602 + 120) <= (87 + 77))) then
				return "outbreak high_prio_actions 14";
			end
		end
	end
	local function v123()
		local v174 = 0 + 0;
		while true do
			if (((574 - (47 + 524)) == v174) or ((1563 + 845) < (5764 - 3655))) then
				if ((v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + (4 - 1)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (136 - 76))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (1729 - (1165 + 561))))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 1 + 2))) or ((v94 >= (6 - 4)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + 2 + 1)))) or ((512 - (341 + 138)) == (393 + 1062))) then
					if (v20(v61.Fireblood, v52) or ((913 - 470) >= (4341 - (89 + 237)))) then
						return "fireblood racials 14";
					end
				end
				if (((10879 - 7497) > (349 - 183)) and v61.BagofTricks:IsCastable() and (v94 == (882 - (581 + 300))) and (v14:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 1225 - (855 + 365)))) then
					if (v20(v61.BagofTricks, v52, nil, not v16:IsSpellInRange(v61.BagofTricks)) or ((665 - 385) == (999 + 2060))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
			if (((3116 - (1030 + 205)) > (1214 + 79)) and ((1 + 0) == v174)) then
				if (((2643 - (156 + 130)) == (5355 - 2998)) and v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (4 - 1)) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (122 - 62))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + 1 + 2))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + 2 + 1))) or ((v94 >= (71 - (10 + 59))) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + 1 + 2)))) then
					if (((605 - 482) == (1286 - (671 + 492))) and v20(v61.Berserking, v52)) then
						return "berserking racials 6";
					end
				end
				if ((v61.LightsJudgment:IsCastable() and v14:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v14:BuffRemains(v61.FestermightBuff) < v16:TimeToDie()) or (v14:BuffRemains(v61.UnholyStrengthBuff) < v16:TimeToDie()))) or ((841 + 215) >= (4607 - (369 + 846)))) then
					if (v20(v61.LightsJudgment, v52, nil, not v16:IsSpellInRange(v61.LightsJudgment)) or ((287 + 794) < (918 + 157))) then
						return "lights_judgment racials 8";
					end
				end
				v174 = 1947 - (1036 + 909);
			end
			if (((0 + 0) == v174) or ((1760 - 711) >= (4635 - (11 + 192)))) then
				if ((v61.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (11 + 9)) and ((v61.SummonGargoyle:CooldownRemains() < v14:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v14:Rune() < (177 - (135 + 40))) and (v89 < (2 - 1))))) or ((2874 + 1894) <= (1863 - 1017))) then
					if (v20(v61.ArcaneTorrent, v52, nil, not v16:IsInRange(11 - 3)) or ((3534 - (50 + 126)) <= (3954 - 2534))) then
						return "arcane_torrent racials 2";
					end
				end
				if ((v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1473 - (1233 + 180)))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (972 - (522 + 447))))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + (1424 - (107 + 1314))))) or ((v94 >= (1 + 1)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + (8 - 5))))) or ((1589 + 2150) <= (5967 - 2962))) then
					if (v20(v61.BloodFury, v52) or ((6563 - 4904) >= (4044 - (716 + 1194)))) then
						return "blood_fury racials 4";
					end
				end
				v174 = 1 + 0;
			end
			if (((1 + 1) == v174) or ((3763 - (74 + 429)) < (4543 - 2188))) then
				if ((v61.AncestralCall:IsCastable() and ((((9 + 9) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (137 - 77))) and ((v82 and (v83 <= (13 + 5))) or (v80 and (v81 <= (55 - 37))) or ((v94 >= (4 - 2)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (451 - (279 + 154))))) or ((1447 - (454 + 324)) == (3323 + 900))) then
					if (v20(v61.AncestralCall, v52) or ((1709 - (12 + 5)) < (318 + 270))) then
						return "ancestral_call racials 10";
					end
				end
				if ((v61.ArcanePulse:IsCastable() and ((v94 >= (4 - 2)) or ((v14:Rune() <= (1 + 0)) and (v14:RunicPowerDeficit() >= (1153 - (277 + 816)))))) or ((20497 - 15700) < (4834 - (1058 + 125)))) then
					if (v20(v61.ArcanePulse, v52, nil, not v16:IsInRange(2 + 6)) or ((5152 - (815 + 160)) > (20809 - 15959))) then
						return "arcane_pulse racials 12";
					end
				end
				v174 = 7 - 4;
			end
		end
	end
	local function v124()
		if ((v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (3 + 7)))) or ((1169 - 769) > (3009 - (41 + 1857)))) then
			if (((4944 - (1222 + 671)) > (2597 - 1592)) and v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil st 2";
			end
		end
		if (((5307 - 1614) <= (5564 - (229 + 953))) and v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (1784 - (1111 + 663))))) then
			if (v20(v61.Epidemic, v55, nil, not v16:IsInRange(1619 - (874 + 705))) or ((460 + 2822) > (2798 + 1302))) then
				return "epidemic st 4";
			end
		end
		if ((v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (3 - 1)) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (1 + 12))) or (v84 and (v85 > (687 - (642 + 37)))) or (v82 and (v83 > (2 + 6))) or (not v76 and (v89 >= (1 + 3))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v15:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (2 - 1)))) or ((4034 - (233 + 221)) < (6576 - 3732))) then
			if (((79 + 10) < (6031 - (718 + 823))) and v20(v88, v48)) then
				return "any_dnd st 6";
			end
		end
		if ((v86:IsReady() and (v76 or ((v94 >= (2 + 0)) and v14:BuffUp(v61.DeathAndDecayBuff)))) or ((5788 - (266 + 539)) < (5118 - 3310))) then
			if (((5054 - (636 + 589)) > (8946 - 5177)) and v20(v86, nil, nil, not v16:IsSpellInRange(v86))) then
				return "wound_spender st 8";
			end
		end
		if (((3062 - 1577) <= (2302 + 602)) and v61.FesteringStrike:IsReady() and not v76) then
			if (((1551 + 2718) == (5284 - (657 + 358))) and v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v16:IsInMeleeRange(13 - 8))) then
				return "festering_strike st 10";
			end
		end
		if (((881 - 494) <= (3969 - (1151 + 36))) and v61.DeathCoil:IsReady()) then
			if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((1834 + 65) <= (242 + 675))) then
				return "death_coil st 12";
			end
		end
		if ((v86:IsReady() and not v76) or ((12877 - 8565) <= (2708 - (1552 + 280)))) then
			if (((3066 - (64 + 770)) <= (1763 + 833)) and v70.CastTargetIf(v86, v93, "max", v102, v108, not v16:IsSpellInRange(v86))) then
				return "wound_spender st 14";
			end
		end
	end
	local function v125()
		if (((4755 - 2660) < (655 + 3031)) and v33) then
			local v180 = 1243 - (157 + 1086);
			local v181;
			while true do
				if ((v180 == (0 - 0)) or ((6985 - 5390) >= (6862 - 2388))) then
					v181 = v115();
					if (v181 or ((6303 - 1684) < (3701 - (599 + 220)))) then
						return v181;
					end
					break;
				end
			end
		end
	end
	local function v126()
		v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (5 - 2))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (1935 - (1813 + 118)))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (2 + 0)));
		v71 = (v94 >= (1220 - (841 + 376))) or ((v61.SummonGargoyle:CooldownRemains() > (1 - 0)) and ((v61.Apocalypse:CooldownRemains() > (1 + 0)) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v10.CombatTime() > (54 - 34));
		v74 = ((v61.Apocalypse:CooldownRemains() < (869 - (464 + 395))) and (v89 <= (10 - 6)) and (v61.UnholyAssault:CooldownRemains() > (5 + 5)) and (844 - (467 + 370))) or (3 - 1);
		if ((not v84 and v61.Festermight:IsAvailable() and v14:BuffUp(v61.FestermightBuff) and ((v14:BuffRemains(v61.FestermightBuff) / ((4 + 1) * v14:GCD())) >= (3 - 2))) or ((46 + 248) >= (11239 - 6408))) then
			v75 = v89 >= (521 - (150 + 370));
		else
			v75 = v89 >= ((1285 - (74 + 1208)) - v22(v61.InfectedClaws:IsAvailable()));
		end
		v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (2 - 1)) and (v61.UnholyAssault:CooldownRemains() < (94 - 74)) and v61.UnholyAssault:IsAvailable() and v78) or (v16:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1 + 0))) or (v89 > (394 - (14 + 376))) or (v14:HasTier(53 - 22, 3 + 1) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 + 0))))) or ((v91 < (5 + 0)) and (v89 >= (2 - 1)));
		v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (3 + 0)) and (v14:RunicPower() < (138 - (23 + 55))) and not v78;
		v78 = (v94 == (2 - 1)) or not v28;
		v79 = (v94 >= (2 + 0)) and v28;
		v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v16:DebuffDown(v61.RottenTouchDebuff)) or (v14:RunicPowerDeficit() < (18 + 2))) and (not v14:HasTier(47 - 16, 2 + 2) or (v14:HasTier(932 - (652 + 249), 10 - 6) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v14:RunicPowerDeficit() < (1888 - (708 + 1160))) or (v14:Rune() < (8 - 5))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (3 - 1)) or v61.CoilofDevastation:IsAvailable())) or (v14:Rune() < (30 - (10 + 17))) or v84 or v14:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (3 + 7)) and (v89 > (1735 - (1400 + 332)))) or (not v76 and (v89 >= (7 - 3))));
	end
	local function v127()
		v60();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v69 = not v99();
		v93 = v14:GetEnemiesInMeleeRange(1913 - (242 + 1666));
		v95 = v16:GetEnemiesInSplashRange(5 + 5);
		if (((744 + 1285) <= (2629 + 455)) and v28) then
			local v182 = 940 - (850 + 90);
			while true do
				if ((v182 == (0 - 0)) or ((3427 - (360 + 1030)) == (2142 + 278))) then
					v94 = #v93;
					v96 = v16:GetEnemiesInSplashRangeCount(28 - 18);
					break;
				end
			end
		else
			v94 = 1 - 0;
			v96 = 1662 - (909 + 752);
		end
		if (((5681 - (109 + 1114)) > (7147 - 3243)) and (v70.TargetIsValid() or v14:AffectingCombat())) then
			v90 = v10.BossFightRemains();
			v91 = v90;
			if (((170 + 266) >= (365 - (6 + 236))) and (v91 == (7001 + 4110))) then
				v91 = v10.FightRemains(v93, false);
			end
			v97 = v100(v95);
			v80 = v61.Apocalypse:TimeSinceLastCast() <= (13 + 2);
			v81 = (v80 and ((35 - 20) - v61.Apocalypse:TimeSinceLastCast())) or (0 - 0);
			v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (1163 - (1076 + 57));
			v83 = (v82 and ((5 + 25) - v61.ArmyoftheDead:TimeSinceLastCast())) or (689 - (579 + 110));
			v84 = v92:GargActive();
			v85 = v92:GargRemains();
			v89 = v16:DebuffStack(v61.FesteringWoundDebuff);
		end
		if (((40 + 460) < (1606 + 210)) and v70.TargetIsValid()) then
			local v183 = 0 + 0;
			local v184;
			while true do
				if (((3981 - (174 + 233)) == (9983 - 6409)) and (v183 == (0 - 0))) then
					if (((99 + 122) < (1564 - (663 + 511))) and not v14:AffectingCombat()) then
						local v189 = v114();
						if (v189 or ((1975 + 238) <= (309 + 1112))) then
							return v189;
						end
					end
					if (((9427 - 6369) < (2943 + 1917)) and v61.DeathStrike:IsReady() and not v69) then
						if (v20(v61.DeathStrike) or ((3050 - 1754) >= (10762 - 6316))) then
							return "death_strike low hp or proc";
						end
					end
					if ((v94 == (0 + 0)) or ((2710 - 1317) > (3200 + 1289))) then
						if ((v61.Outbreak:IsReady() and (v97 > (0 + 0))) or ((5146 - (478 + 244)) < (544 - (440 + 77)))) then
							if (v20(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or ((908 + 1089) > (13962 - 10147))) then
								return "outbreak out_of_range";
							end
						end
						if (((5021 - (655 + 901)) > (355 + 1558)) and v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (1 + 0)) and not v77) then
							if (((495 + 238) < (7327 - 5508)) and v20(v61.Epidemic, v55, nil, not v16:IsInRange(1485 - (695 + 750)))) then
								return "epidemic out_of_range";
							end
						end
						if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (6 - 4)) and not v77) or ((6782 - 2387) == (19123 - 14368))) then
							if (v20(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or ((4144 - (285 + 66)) < (5521 - 3152))) then
								return "death_coil out_of_range";
							end
						end
					end
					v183 = 1311 - (682 + 628);
				end
				if ((v183 == (1 + 1)) or ((4383 - (176 + 123)) == (111 + 154))) then
					if (((3162 + 1196) == (4627 - (239 + 30))) and v33) then
						local v190 = 0 + 0;
						local v191;
						while true do
							if (((0 + 0) == v190) or ((5553 - 2415) < (3097 - 2104))) then
								v191 = v125();
								if (((3645 - (306 + 9)) > (8106 - 5783)) and v191) then
									return v191;
								end
								break;
							end
						end
					end
					if ((v29 and not v71) or ((631 + 2995) == (2448 + 1541))) then
						local v192 = v121();
						if (v192 or ((441 + 475) == (7637 - 4966))) then
							return v192;
						end
					end
					if (((1647 - (1140 + 235)) == (174 + 98)) and v29 and v78) then
						local v193 = v120();
						if (((3897 + 352) <= (1242 + 3597)) and v193) then
							return v193;
						end
					end
					v183 = 55 - (33 + 19);
				end
				if (((1003 + 1774) < (9591 - 6391)) and ((1 + 0) == v183)) then
					v126();
					v184 = v122();
					if (((185 - 90) < (1836 + 121)) and v184) then
						return v184;
					end
					v183 = 691 - (586 + 103);
				end
				if (((76 + 750) < (5285 - 3568)) and (v183 == (1491 - (1309 + 179)))) then
					if (((2574 - 1148) >= (481 + 624)) and v28 and v29 and v79) then
						local v194 = v118();
						if (((7396 - 4642) <= (2553 + 826)) and v194) then
							return v194;
						end
					end
					if (v29 or ((8343 - 4416) == (2815 - 1402))) then
						local v195 = v123();
						if (v195 or ((1763 - (295 + 314)) <= (1935 - 1147))) then
							return v195;
						end
					end
					if (v28 or ((3605 - (1300 + 662)) > (10610 - 7231))) then
						if ((v79 and (v87:CooldownRemains() < (1765 - (1178 + 577))) and v14:BuffDown(v61.DeathAndDecayBuff)) or ((1456 + 1347) > (13447 - 8898))) then
							local v198 = 1405 - (851 + 554);
							local v199;
							while true do
								if ((v198 == (0 + 0)) or ((610 - 390) >= (6562 - 3540))) then
									v199 = v119();
									if (((3124 - (115 + 187)) == (2162 + 660)) and v199) then
										return v199;
									end
									break;
								end
							end
						end
						if (((v94 >= (4 + 0)) and v14:BuffUp(v61.DeathAndDecayBuff)) or ((4181 - 3120) == (3018 - (160 + 1001)))) then
							local v200 = v117();
							if (((2415 + 345) > (942 + 422)) and v200) then
								return v200;
							end
						end
						if (((v94 >= (7 - 3)) and (((v87:CooldownRemains() > (368 - (237 + 121))) and v14:BuffDown(v61.DeathAndDecayBuff)) or not v79)) or ((5799 - (525 + 372)) <= (6815 - 3220))) then
							local v201 = 0 - 0;
							local v202;
							while true do
								if ((v201 == (142 - (96 + 46))) or ((4629 - (643 + 134)) == (106 + 187))) then
									v202 = v116();
									if (v202 or ((3737 - 2178) == (17033 - 12445))) then
										return v202;
									end
									break;
								end
							end
						end
					end
					v183 = 4 + 0;
				end
				if ((v183 == (7 - 3)) or ((9165 - 4681) == (1507 - (316 + 403)))) then
					if (((3037 + 1531) >= (10741 - 6834)) and (v94 <= (2 + 1))) then
						local v196 = 0 - 0;
						local v197;
						while true do
							if (((883 + 363) < (1119 + 2351)) and (v196 == (0 - 0))) then
								v197 = v124();
								if (((19428 - 15360) >= (2018 - 1046)) and v197) then
									return v197;
								end
								break;
							end
						end
					end
					if (((29 + 464) < (7663 - 3770)) and v61.FesteringStrike:IsReady()) then
						if (v20(v61.FesteringStrike, nil, nil) or ((72 + 1401) >= (9802 - 6470))) then
							return "festering_strike precombat 8";
						end
					end
					break;
				end
			end
		end
	end
	local function v128()
		local v178 = 17 - (12 + 5);
		while true do
			if ((v178 == (0 - 0)) or ((8643 - 4592) <= (2459 - 1302))) then
				v61.VirulentPlagueDebuff:RegisterAuraTracking();
				v61.FesteringWoundDebuff:RegisterAuraTracking();
				v178 = 2 - 1;
			end
			if (((123 + 481) < (4854 - (1656 + 317))) and (v178 == (1 + 0))) then
				v10.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(202 + 50, v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

