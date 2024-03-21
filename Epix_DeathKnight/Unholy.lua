local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((11373 - 6667) > (5197 - (442 + 326))) and not v5) then
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
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (470 - (381 + 89));
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['UseDeathStrikeHP'] or (1156 - (1074 + 82));
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
	local v66 = (v65[1797 - (214 + 1570)] and v18(v65[1468 - (990 + 465)])) or v18(0 + 0);
	local v67 = (v65[7 + 7] and v18(v65[14 + 0])) or v18(0 - 0);
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
	local v90 = 12837 - (1668 + 58);
	local v91 = 11737 - (512 + 114);
	local v92 = v9.GhoulTable;
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if (((2482 + 372) < (13812 - 9717)) and (v147 == (1994 - (109 + 1885)))) then
				v65 = v13:GetEquipment();
				v66 = (v65[1482 - (1269 + 200)] and v18(v65[24 - 11])) or v18(815 - (98 + 717));
				v147 = 827 - (802 + 24);
			end
			if ((v147 == (1 - 0)) or ((1335 - 277) >= (178 + 1024))) then
				v67 = (v65[11 + 3] and v18(v65[3 + 11])) or v18(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v90 = 30910 - 19799;
		v91 = 37052 - 25941;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v148 = 0 + 0;
		while true do
			if (((1511 + 2200) > (2768 + 587)) and (v148 == (0 + 0))) then
				v86 = ((v61.ClawingShadows:IsAvailable()) and v61.ClawingShadows) or v61.ScourgeStrike;
				v88 = ((v61.Defile:IsAvailable()) and v63.DefilePlayer) or v63.DaDPlayer;
				v148 = 1 + 0;
			end
			if ((v148 == (1434 - (797 + 636))) or ((4398 - 3492) >= (3848 - (1427 + 192)))) then
				v87 = ((v61.Defile:IsAvailable()) and v61.Defile) or v61.DeathAndDecay;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v99()
		return (v13:HealthPercentage() < v43) or ((v13:HealthPercentage() < v44) and v13:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v149)
		local v150 = 0 + 0;
		local v151;
		while true do
			if (((2990 - 1702) > (1125 + 126)) and (v150 == (1 + 0))) then
				return v151;
			end
			if ((v150 == (326 - (192 + 134))) or ((5789 - (316 + 960)) < (1866 + 1486))) then
				v151 = 0 + 0;
				for v182, v183 in pairs(v149) do
					if (v183:DebuffDown(v61.VirulentPlagueDebuff) or ((1909 + 156) >= (12218 - 9022))) then
						v151 = v151 + (552 - (83 + 468));
					end
				end
				v150 = 1807 - (1202 + 604);
			end
		end
	end
	local function v101(v152)
		local v153 = {};
		for v178 in pairs(v152) do
			if (not v12:IsInBossList(v152[v178]['UnitNPCID']) or ((20427 - 16051) <= (2464 - 983))) then
				v30(v153, v152[v178]);
			end
		end
		return v9.FightRemains(v153);
	end
	local function v102(v154)
		return (v154:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v155)
		return (v155:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v156)
		return (v61.BurstingSores:IsAvailable() and v156:DebuffUp(v61.FesteringWoundDebuff) and ((v13:BuffDown(v61.DeathAndDecayBuff) and v61.DeathAndDecay:CooldownDown() and (v13:Rune() < (8 - 5))) or (v13:BuffUp(v61.DeathAndDecayBuff) and (v13:Rune() == (325 - (45 + 280)))))) or (not v61.BurstingSores:IsAvailable() and (v156:DebuffStack(v61.FesteringWoundDebuff) >= (4 + 0))) or (v13:HasTier(28 + 3, 1 + 1) and v156:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v157)
		return v157:DebuffStack(v61.FesteringWoundDebuff) >= (3 + 1);
	end
	local function v106(v158)
		return v158:DebuffStack(v61.FesteringWoundDebuff) < (1 + 3);
	end
	local function v107(v159)
		return v159:DebuffStack(v61.FesteringWoundDebuff) < (6 - 2);
	end
	local function v108(v160)
		return v160:DebuffStack(v61.FesteringWoundDebuff) >= (1915 - (340 + 1571));
	end
	local function v109(v161)
		return ((v161:TimeToX(14 + 21) < (1777 - (1733 + 39))) or (v161:HealthPercentage() <= (96 - 61))) and (v161:TimeToDie() > (v161:DebuffRemains(v61.SoulReaper) + (1039 - (125 + 909))));
	end
	local function v110(v162)
		return (v162:DebuffStack(v61.FesteringWoundDebuff) <= (1950 - (1096 + 852))) or v14:BuffUp(v61.DarkTransformation);
	end
	local function v111(v163)
		return (v163:DebuffStack(v61.FesteringWoundDebuff) >= (2 + 2)) and (v87:CooldownRemains() < (3 - 0));
	end
	local function v112(v164)
		return v164:DebuffStack(v61.FesteringWoundDebuff) >= (1 + 0);
	end
	local function v113(v165)
		return (v165:TimeToDie() > v165:DebuffRemains(v61.VirulentPlagueDebuff)) and (v165:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61.Superstrain:IsAvailable() and (v165:DebuffRefreshable(v61.FrostFeverDebuff) or v165:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61.UnholyBlight:IsAvailable() or (v61.UnholyBlight:IsAvailable() and (v61.UnholyBlight:CooldownRemains() > ((527 - (409 + 103)) / ((v22(v61.Superstrain:IsAvailable()) * (239 - (46 + 190))) + (v22(v61.Plaguebringer:IsAvailable()) * (97 - (51 + 44))) + (v22(v61.EbonFever:IsAvailable()) * (1 + 1)))))));
	end
	local function v114()
		local v166 = 1317 - (1114 + 203);
		while true do
			if ((v166 == (726 - (228 + 498))) or ((735 + 2657) >= (2620 + 2121))) then
				if (((3988 - (174 + 489)) >= (5611 - 3457)) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive() or not v14:IsActive())) then
					if (v19(v61.RaiseDead, nil) or ((3200 - (830 + 1075)) >= (3757 - (303 + 221)))) then
						return "raise_dead precombat 2 displaystyle";
					end
				end
				if (((5646 - (231 + 1038)) > (1369 + 273)) and v61.ArmyoftheDead:IsReady() and v29) then
					if (((5885 - (171 + 991)) > (5588 - 4232)) and v19(v61.ArmyoftheDead, nil)) then
						return "army_of_the_dead precombat 4";
					end
				end
				v166 = 2 - 1;
			end
			if ((v166 == (2 - 1)) or ((3311 + 825) <= (12033 - 8600))) then
				if (((12246 - 8001) <= (7464 - 2833)) and v61.Outbreak:IsReady()) then
					if (((13218 - 8942) >= (5162 - (111 + 1137))) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
						return "outbreak precombat 6";
					end
				end
				if (((356 - (91 + 67)) <= (12991 - 8626)) and v61.FesteringStrike:IsReady()) then
					if (((1194 + 3588) > (5199 - (423 + 100))) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(1 + 4))) then
						return "festering_strike precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v167 = 0 - 0;
		while true do
			if (((2536 + 2328) > (2968 - (326 + 445))) and (v167 == (0 - 0))) then
				v68 = v70.HandleTopTrinket(v64, v29, 89 - 49, nil);
				if (v68 or ((8636 - 4936) == (3218 - (530 + 181)))) then
					return v68;
				end
				v167 = 882 - (614 + 267);
			end
			if (((4506 - (19 + 13)) >= (445 - 171)) and ((2 - 1) == v167)) then
				v68 = v70.HandleBottomTrinket(v64, v29, 114 - 74, nil);
				if (v68 or ((492 + 1402) <= (2472 - 1066))) then
					return v68;
				end
				break;
			end
		end
	end
	local function v116()
		local v168 = 0 - 0;
		while true do
			if (((3384 - (1293 + 519)) >= (3123 - 1592)) and (v168 == (2 - 1))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((8962 - 4275) < (19585 - 15043))) then
					if (((7752 - 4461) > (883 + 784)) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "festering_strike aoe 6";
					end
				end
				if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((2027 - 1154) == (471 + 1563))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((936 + 1880) < (7 + 4))) then
						return "death_coil aoe 8";
					end
				end
				break;
			end
			if (((4795 - (709 + 387)) < (6564 - (673 + 1185))) and (v168 == (0 - 0))) then
				if (((8496 - 5850) >= (1440 - 564)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (8 + 2)))) then
					if (((459 + 155) <= (4298 - 1114)) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(8 + 22))) then
						return "epidemic aoe 2";
					end
				end
				if (((6232 - 3106) == (6135 - 3009)) and v86:IsReady() and v76) then
					if (v70.CastTargetIf(v86, v93, "max", v102, nil, not v15:IsSpellInRange(v86)) or ((4067 - (446 + 1434)) >= (6237 - (1040 + 243)))) then
						return "wound_spender aoe 4";
					end
				end
				v168 = 2 - 1;
			end
		end
	end
	local function v117()
		local v169 = 1847 - (559 + 1288);
		while true do
			if ((v169 == (1933 - (609 + 1322))) or ((4331 - (13 + 441)) == (13359 - 9784))) then
				if (((1851 - 1144) > (3147 - 2515)) and v86:IsReady()) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((21 + 525) >= (9747 - 7063))) then
						return "wound_spender aoe_burst 10";
					end
				end
				break;
			end
			if (((521 + 944) <= (1885 + 2416)) and (v169 == (2 - 1))) then
				if (((933 + 771) > (2620 - 1195)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (7 + 3)))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(23 + 17)) or ((494 + 193) == (3556 + 678))) then
						return "epidemic aoe_burst 6";
					end
				end
				if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((3259 + 71) < (1862 - (153 + 280)))) then
					if (((3311 - 2164) >= (301 + 34)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil aoe_burst 8";
					end
				end
				v169 = 1 + 1;
			end
			if (((1798 + 1637) > (1903 + 194)) and (v169 == (0 + 0))) then
				if ((v61.Epidemic:IsReady() and ((v13:Rune() < (1 - 0)) or (v61.BurstingSores:IsAvailable() and (v61.FesteringWoundDebuff:AuraActiveCount() == (0 + 0)))) and not v77 and ((v94 >= (673 - (89 + 578))) or (v13:RunicPowerDeficit() < (22 + 8)) or (v13:BuffStack(v61.FestermightBuff) == (41 - 21)))) or ((4819 - (572 + 477)) >= (545 + 3496))) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(25 + 15)) or ((453 + 3338) <= (1697 - (84 + 2)))) then
						return "epidemic aoe_burst 2";
					end
				end
				if (v86:IsReady() or ((7544 - 2966) <= (1447 + 561))) then
					if (((1967 - (497 + 345)) <= (54 + 2022)) and v70.CastTargetIf(v86, v93, "max", v102, v112, not v15:IsSpellInRange(v86))) then
						return "wound_spender aoe_burst 4";
					end
				end
				v169 = 1 + 0;
			end
		end
	end
	local function v118()
		local v170 = 1333 - (605 + 728);
		while true do
			if ((v170 == (0 + 0)) or ((1651 - 908) >= (202 + 4197))) then
				if (((4270 - 3115) < (1509 + 164)) and v61.VileContagion:IsReady() and (v87:CooldownRemains() < (7 - 4))) then
					if (v70.CastTargetIf(v61.VileContagion, v93, "max", v102, v111, not v15:IsSpellInRange(v61.VileContagion)) or ((1755 + 569) <= (1067 - (457 + 32)))) then
						return "vile_contagion aoe_cooldowns 2";
					end
				end
				if (((1599 + 2168) == (5169 - (832 + 570))) and v61.SummonGargoyle:IsReady()) then
					if (((3853 + 236) == (1067 + 3022)) and v19(v61.SummonGargoyle, v56)) then
						return "summon_gargoyle aoe_cooldowns 4";
					end
				end
				v170 = 3 - 2;
			end
			if (((2148 + 2310) >= (2470 - (588 + 208))) and (v170 == (8 - 5))) then
				if (((2772 - (884 + 916)) <= (2968 - 1550)) and v61.DarkTransformation:IsReady() and v61.DarkTransformation:IsCastable() and (((v87:CooldownRemains() < (6 + 4)) and v61.InfectedClaws:IsAvailable() and ((v61.FesteringWoundDebuff:AuraActiveCount() < v96) or not v61.VileContagion:IsAvailable())) or not v61.InfectedClaws:IsAvailable())) then
					if (v19(v61.DarkTransformation) or ((5591 - (232 + 421)) < (6651 - (1569 + 320)))) then
						return "dark_transformation aoe_cooldowns 14";
					end
				end
				if ((v61.EmpowerRuneWeapon:IsCastable() and (v14:BuffUp(v61.DarkTransformation))) or ((615 + 1889) > (811 + 3453))) then
					if (((7254 - 5101) == (2758 - (316 + 289))) and v19(v61.EmpowerRuneWeapon, v49)) then
						return "empower_rune_weapon aoe_cooldowns 16";
					end
				end
				v170 = 10 - 6;
			end
			if ((v170 == (1 + 1)) or ((1960 - (666 + 787)) >= (3016 - (360 + 65)))) then
				if (((4188 + 293) == (4735 - (79 + 175))) and v61.UnholyAssault:IsCastable()) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, v110, not v15:IsInMeleeRange(7 - 2), v57) or ((1817 + 511) < (2123 - 1430))) then
						return "unholy_assault aoe_cooldowns 10";
					end
				end
				if (((8334 - 4006) == (5227 - (503 + 396))) and v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) then
					if (((1769 - (92 + 89)) >= (2583 - 1251)) and v19(v61.RaiseDead, nil)) then
						return "raise_dead aoe_cooldowns 12";
					end
				end
				v170 = 2 + 1;
			end
			if ((v170 == (1 + 0)) or ((16345 - 12171) > (581 + 3667))) then
				if ((v61.AbominationLimb:IsCastable() and ((v13:Rune() < (4 - 2)) or (v89 > (9 + 1)) or not v61.Festermight:IsAvailable() or (v13:BuffUp(v61.FestermightBuff) and (v13:BuffRemains(v61.FestermightBuff) < (6 + 6))))) or ((13967 - 9381) <= (11 + 71))) then
					if (((5890 - 2027) == (5107 - (485 + 759))) and v19(v61.AbominationLimb, nil, nil, not v15:IsInRange(46 - 26))) then
						return "abomination_limb aoe_cooldowns 6";
					end
				end
				if (v61.Apocalypse:IsReady() or ((1471 - (442 + 747)) <= (1177 - (832 + 303)))) then
					if (((5555 - (88 + 858)) >= (234 + 532)) and v70.CastTargetIf(v61.Apocalypse, v93, "min", v102, v104, not v15:IsInMeleeRange(5 + 0))) then
						return "apocalypse aoe_cooldowns 8";
					end
				end
				v170 = 1 + 1;
			end
			if ((v170 == (793 - (766 + 23))) or ((5687 - 4535) == (3402 - 914))) then
				if (((9015 - 5593) > (11370 - 8020)) and v61.SacrificialPact:IsReady() and ((v14:BuffDown(v61.DarkTransformation) and (v61.DarkTransformation:CooldownRemains() > (1079 - (1036 + 37)))) or (v91 < v13:GCD()))) then
					if (((622 + 255) > (732 - 356)) and v19(v61.SacrificialPact, v50)) then
						return "sacrificial_pact aoe_cooldowns 18";
					end
				end
				break;
			end
		end
	end
	local function v119()
		if ((v87:IsReady() and (not v61.BurstingSores:IsAvailable() or (v61.FesteringWoundDebuff:AuraActiveCount() == v96) or (v61.FesteringWoundDebuff:AuraActiveCount() >= (7 + 1))) and not v13:IsMoving() and (v94 >= (1481 - (641 + 839)))) or ((4031 - (910 + 3)) <= (4718 - 2867))) then
			if (v19(v88, v48) or ((1849 - (1466 + 218)) >= (1605 + 1887))) then
				return "any_dnd aoe_setup 2";
			end
		end
		if (((5097 - (556 + 592)) < (1727 + 3129)) and v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96) and v61.BurstingSores:IsAvailable()) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(813 - (329 + 479))) or ((5130 - (174 + 680)) < (10363 - 7347))) then
				return "festering_strike aoe_setup 4";
			end
		end
		if (((9721 - 5031) > (2946 + 1179)) and v61.Epidemic:IsReady() and (not v77 or (v91 < (749 - (396 + 343))))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(4 + 36)) or ((1527 - (29 + 1448)) >= (2285 - (135 + 1254)))) then
				return "epidemic aoe_setup 6";
			end
		end
		if ((v61.FesteringStrike:IsReady() and (v61.FesteringWoundDebuff:AuraActiveCount() < v96)) or ((6456 - 4742) >= (13811 - 10853))) then
			if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, nil, not v15:IsInMeleeRange(4 + 1)) or ((3018 - (389 + 1138)) < (1218 - (102 + 472)))) then
				return "festering_strike aoe_setup 8";
			end
		end
		if (((665 + 39) < (548 + 439)) and v61.FesteringStrike:IsReady() and (v61.Apocalypse:CooldownRemains() < v74)) then
			if (((3467 + 251) > (3451 - (320 + 1225))) and v70.CastTargetIf(v61.FesteringStrike, v93, "max", v102, v106, not v15:IsInMeleeRange(8 - 3))) then
				return "festering_strike aoe_setup 10";
			end
		end
		if ((v61.DeathCoil:IsReady() and not v77 and not v61.Epidemic:IsAvailable()) or ((587 + 371) > (5099 - (157 + 1307)))) then
			if (((5360 - (821 + 1038)) <= (11207 - 6715)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
				return "death_coil aoe_setup 12";
			end
		end
	end
	local function v120()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (0 - 0)) or ((1281 + 2161) < (6315 - 3767))) then
				if (((3901 - (834 + 192)) >= (94 + 1370)) and v61.SummonGargoyle:IsCastable() and (v13:BuffUp(v61.CommanderoftheDeadBuff) or not v61.CommanderoftheDead:IsAvailable())) then
					if (v19(v61.SummonGargoyle, v56) or ((1232 + 3565) >= (106 + 4787))) then
						return "summon_gargoyle cooldowns 2";
					end
				end
				if ((v61.RaiseDead:IsCastable() and (v14:IsDeadOrGhost() or not v14:IsActive())) or ((853 - 302) > (2372 - (300 + 4)))) then
					if (((565 + 1549) > (2471 - 1527)) and v19(v61.RaiseDead, nil)) then
						return "raise_dead cooldowns 4 displaystyle";
					end
				end
				v171 = 363 - (112 + 250);
			end
			if ((v171 == (2 + 1)) or ((5666 - 3404) >= (1774 + 1322))) then
				if ((v61.UnholyAssault:IsReady() and v78) or ((1167 + 1088) >= (2646 + 891))) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, "min", v102, nil, not v15:IsInMeleeRange(3 + 2), v57) or ((2851 + 986) < (2720 - (1001 + 413)))) then
						return "unholy_assault cooldowns 14";
					end
				end
				if (((6578 - 3628) == (3832 - (244 + 638))) and v61.SoulReaper:IsReady() and (v94 == (694 - (627 + 66))) and ((v15:TimeToX(104 - 69) < (607 - (512 + 90))) or (v15:HealthPercentage() <= (1941 - (1665 + 241)))) and (v15:TimeToDie() > (722 - (373 + 344)))) then
					if (v19(v61.SoulReaper, nil, nil, not v15:IsSpellInRange(v61.SoulReaper)) or ((2131 + 2592) < (873 + 2425))) then
						return "soul_reaper cooldowns 16";
					end
				end
				v171 = 10 - 6;
			end
			if (((1921 - 785) >= (1253 - (35 + 1064))) and (v171 == (3 + 1))) then
				if ((v61.SoulReaper:IsReady() and (v94 >= (4 - 2))) or ((2 + 269) > (5984 - (298 + 938)))) then
					if (((5999 - (233 + 1026)) >= (4818 - (636 + 1030))) and v70.CastTargetIf(v61.SoulReaper, v93, "min", v103, v109, not v15:IsSpellInRange(v61.SoulReaper))) then
						return "soul_reaper cooldowns 18";
					end
				end
				break;
			end
			if ((v171 == (1 + 0)) or ((2519 + 59) >= (1008 + 2382))) then
				if (((3 + 38) <= (1882 - (55 + 166))) and v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (1 + 4))) then
					if (((61 + 540) < (13595 - 10035)) and v19(v61.DarkTransformation)) then
						return "dark_transformation cooldowns 6";
					end
				end
				if (((532 - (36 + 261)) < (1201 - 514)) and v61.Apocalypse:IsReady() and v78) then
					if (((5917 - (34 + 1334)) > (444 + 709)) and v70.CastTargetIf(v61.Apocalypse, v93, "max", v102, v105, not v15:IsInMeleeRange(4 + 1))) then
						return "apocalypse cooldowns 8";
					end
				end
				v171 = 1285 - (1035 + 248);
			end
			if ((v171 == (23 - (20 + 1))) or ((2436 + 2238) < (4991 - (134 + 185)))) then
				if (((4801 - (549 + 584)) < (5246 - (314 + 371))) and v61.EmpowerRuneWeapon:IsCastable() and ((v78 and ((v84 and (v85 <= (78 - 55))) or (not v61.SummonGargoyle:IsAvailable() and v61.ArmyoftheDamned:IsAvailable() and v82 and v80) or (not v61.SummonGargoyle:IsAvailable() and not v61.ArmyoftheDamned:IsAvailable() and v14:BuffUp(v61.DarkTransformation)) or (not v61.SummonGargoyle:IsAvailable() and v14:BuffUp(v61.DarkTransformation)))) or (v91 <= (989 - (478 + 490))))) then
					if (v19(v61.EmpowerRuneWeapon, v49) or ((242 + 213) == (4777 - (786 + 386)))) then
						return "empower_rune_weapon cooldowns 10";
					end
				end
				if ((v61.AbominationLimb:IsCastable() and (v13:Rune() < (9 - 6)) and v78) or ((4042 - (1055 + 324)) == (4652 - (1093 + 247)))) then
					if (((3801 + 476) <= (471 + 4004)) and v19(v61.AbominationLimb)) then
						return "abomination_limb cooldowns 12";
					end
				end
				v171 = 11 - 8;
			end
		end
	end
	local function v121()
		local v172 = 0 - 0;
		while true do
			if ((v172 == (0 - 0)) or ((2186 - 1316) == (423 + 766))) then
				if (((5982 - 4429) <= (10798 - 7665)) and v61.Apocalypse:IsReady() and (v89 >= (4 + 0)) and ((v13:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < (58 - 35))) or not v61.CommanderoftheDead:IsAvailable())) then
					if (v19(v61.Apocalypse, nil, not v15:IsInMeleeRange(693 - (364 + 324))) or ((6132 - 3895) >= (8424 - 4913))) then
						return "apocalypse garg_setup 2";
					end
				end
				if ((v61.ArmyoftheDead:IsReady() and v29 and ((v61.CommanderoftheDead:IsAvailable() and ((v61.DarkTransformation:CooldownRemains() < (1 + 2)) or v13:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61.CommanderoftheDead:IsAvailable() and v61.UnholyAssault:IsAvailable() and (v61.UnholyAssault:CooldownRemains() < (41 - 31))) or (not v61.UnholyAssault:IsAvailable() and not v61.CommanderoftheDead:IsAvailable()))) or ((2119 - 795) > (9172 - 6152))) then
					if (v19(v61.ArmyoftheDead) or ((4260 - (1249 + 19)) == (1698 + 183))) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v172 = 3 - 2;
			end
			if (((4192 - (686 + 400)) > (1198 + 328)) and (v172 == (231 - (73 + 156)))) then
				if (((15 + 3008) < (4681 - (721 + 90))) and v29 and v84 and (v85 <= (1 + 22))) then
					if (((464 - 321) > (544 - (224 + 246))) and v61.EmpowerRuneWeapon:IsCastable()) then
						if (((28 - 10) < (3888 - 1776)) and v19(v61.EmpowerRuneWeapon, v49)) then
							return "empower_rune_weapon garg_setup 10";
						end
					end
					if (((199 + 898) <= (39 + 1589)) and v61.UnholyAssault:IsCastable()) then
						if (((3401 + 1229) == (9205 - 4575)) and v19(v61.UnholyAssault, v57, nil, not v15:IsInMeleeRange(16 - 11))) then
							return "unholy_assault garg_setup 12";
						end
					end
				end
				if (((4053 - (203 + 310)) > (4676 - (1238 + 755))) and v61.DarkTransformation:IsReady() and ((v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() > (3 + 37))) or not v61.CommanderoftheDead:IsAvailable())) then
					if (((6328 - (709 + 825)) >= (6034 - 2759)) and v19(v61.DarkTransformation)) then
						return "dark_transformation garg_setup 16";
					end
				end
				v172 = 3 - 0;
			end
			if (((2348 - (196 + 668)) == (5859 - 4375)) and (v172 == (5 - 2))) then
				if (((2265 - (171 + 662)) < (3648 - (4 + 89))) and v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and (v89 > (0 - 0)) and not v13:IsMoving() and (v94 >= (1 + 0))) then
					if (v19(v88, v48) or ((4677 - 3612) > (1404 + 2174))) then
						return "any_dnd garg_setup 18";
					end
				end
				if ((v61.FesteringStrike:IsReady() and ((v89 == (1486 - (35 + 1451))) or not v61.Apocalypse:IsAvailable() or ((v13:RunicPower() < (1493 - (28 + 1425))) and not v84))) or ((6788 - (941 + 1052)) < (1350 + 57))) then
					if (((3367 - (822 + 692)) < (6870 - 2057)) and v19(v61.FesteringStrike, nil, nil, not v15:IsInMeleeRange(3 + 2))) then
						return "festering_strike garg_setup 20";
					end
				end
				v172 = 301 - (45 + 252);
			end
			if ((v172 == (4 + 0)) or ((971 + 1850) < (5916 - 3485))) then
				if ((v61.DeathCoil:IsReady() and (v13:Rune() <= (434 - (114 + 319)))) or ((4126 - 1252) < (2794 - 613))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((1715 + 974) <= (510 - 167))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
			if ((v172 == (1 - 0)) or ((3832 - (556 + 1407)) == (3215 - (741 + 465)))) then
				if ((v61.SoulReaper:IsReady() and (v94 == (466 - (170 + 295))) and ((v15:TimeToX(19 + 16) < (5 + 0)) or (v15:HealthPercentage() <= (86 - 51))) and (v15:TimeToDie() > (5 + 0))) or ((2275 + 1271) < (1315 + 1007))) then
					if (v19(v61.SoulReaper, nil, nil, not v15:IsInMeleeRange(1235 - (957 + 273))) or ((557 + 1525) == (1911 + 2862))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if (((12361 - 9117) > (2780 - 1725)) and v61.SummonGargoyle:IsCastable() and v29 and (v13:BuffUp(v61.CommanderoftheDeadBuff) or (not v61.CommanderoftheDead:IsAvailable() and (v13:RunicPower() >= (122 - 82))))) then
					if (v19(v61.SummonGargoyle, v56) or ((16404 - 13091) <= (3558 - (389 + 1391)))) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v172 = 2 + 0;
			end
		end
	end
	local function v122()
		local v173 = v70.HandleDPSPotion();
		if (v173 or ((148 + 1273) >= (4789 - 2685))) then
			return "DPS Pot";
		end
		if (((2763 - (783 + 168)) <= (10904 - 7655)) and v45) then
			if (((1597 + 26) <= (2268 - (309 + 2))) and v61.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (122 - 82)) and (v84 or not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (1252 - (1090 + 122))))) then
				if (((1431 + 2981) == (14817 - 10405)) and v19(v61.AntiMagicShell, v46)) then
					return "antimagic_shell ams_amz 2";
				end
			end
			if (((1198 + 552) >= (1960 - (628 + 490))) and v61.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (13 + 57)) and v61.Assimilation:IsAvailable() and (v84 or not v61.SummonGargoyle:IsAvailable())) then
				if (((10824 - 6452) > (8454 - 6604)) and v19(v61.AntiMagicZone, v47)) then
					return "antimagic_zone ams_amz 4";
				end
			end
		end
		if (((1006 - (431 + 343)) < (1657 - 836)) and v61.ArmyoftheDead:IsReady() and v29 and ((v61.SummonGargoyle:IsAvailable() and (v61.SummonGargoyle:CooldownRemains() < (5 - 3))) or not v61.SummonGargoyle:IsAvailable() or (v91 < (28 + 7)))) then
			if (((67 + 451) < (2597 - (556 + 1139))) and v19(v61.ArmyoftheDead)) then
				return "army_of_the_dead high_prio_actions 4";
			end
		end
		if (((3009 - (6 + 9)) > (158 + 700)) and v61.DeathCoil:IsReady() and ((v94 <= (2 + 1)) or not v61.Epidemic:IsAvailable()) and ((v84 and v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (174 - (28 + 141))) and (v13:BuffRemains(v61.CommanderoftheDeadBuff) > (11 + 16))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
			if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((4635 - 880) <= (649 + 266))) then
				return "death_coil high_prio_actions 6";
			end
		end
		if (((5263 - (486 + 831)) > (9739 - 5996)) and v61.Epidemic:IsReady() and (v96 >= (13 - 9)) and ((v61.CommanderoftheDead:IsAvailable() and v13:BuffUp(v61.CommanderoftheDeadBuff) and (v61.Apocalypse:CooldownRemains() < (1 + 4))) or (v15:DebuffUp(v61.DeathRotDebuff) and (v15:DebuffRemains(v61.DeathRotDebuff) < v13:GCD())))) then
			if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(126 - 86)) or ((2598 - (668 + 595)) >= (2975 + 331))) then
				return "epidemic high_prio_actions 8";
			end
		end
		if (((977 + 3867) > (6144 - 3891)) and v86:IsReady() and ((v61.Apocalypse:CooldownRemains() > (v74 + (293 - (23 + 267)))) or (v94 >= (1947 - (1129 + 815)))) and v61.Plaguebringer:IsAvailable() and (v61.Superstrain:IsAvailable() or v61.UnholyBlight:IsAvailable()) and (v13:BuffRemains(v61.PlaguebringerBuff) < v13:GCD())) then
			if (((839 - (371 + 16)) == (2202 - (1326 + 424))) and v19(v86, nil, nil, not v15:IsSpellInRange(v86))) then
				return "wound_spender high_prio_actions 10";
			end
		end
		if ((v61.UnholyBlight:IsReady() and ((v78 and (((not v61.Apocalypse:IsAvailable() or v61.Apocalypse:CooldownDown()) and v61.Morbidity:IsAvailable()) or not v61.Morbidity:IsAvailable())) or v79 or (v91 < (39 - 18)))) or ((16652 - 12095) < (2205 - (88 + 30)))) then
			if (((4645 - (720 + 51)) == (8617 - 4743)) and v19(v61.UnholyBlight, v58, nil, not v15:IsInRange(1784 - (421 + 1355)))) then
				return "unholy_blight high_prio_actions 12";
			end
		end
		if (v61.Outbreak:IsReady() or ((3197 - 1259) > (2425 + 2510))) then
			if (v70.CastCycle(v61.Outbreak, v93, v113, not v15:IsSpellInRange(v61.Outbreak)) or ((5338 - (286 + 797)) < (12513 - 9090))) then
				return "outbreak high_prio_actions 14";
			end
		end
	end
	local function v123()
		if (((2408 - 954) <= (2930 - (397 + 42))) and v61.ArcaneTorrent:IsCastable() and (v13:RunicPowerDeficit() > (7 + 13)) and ((v61.SummonGargoyle:CooldownRemains() < v13:GCD()) or not v61.SummonGargoyle:IsAvailable() or (v84 and (v13:Rune() < (802 - (24 + 776))) and (v89 < (1 - 0))))) then
			if (v19(v61.ArcaneTorrent, v52, nil, not v15:IsInRange(793 - (222 + 563))) or ((9158 - 5001) <= (2019 + 784))) then
				return "arcane_torrent racials 2";
			end
		end
		if (((5043 - (23 + 167)) >= (4780 - (690 + 1108))) and v61.BloodFury:IsCastable() and ((((v61.BloodFury:BaseDuration() + 2 + 1) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (50 + 10))) and ((v82 and (v83 <= (v61.BloodFury:BaseDuration() + (851 - (40 + 808))))) or (v80 and (v81 <= (v61.BloodFury:BaseDuration() + 1 + 2))) or ((v94 >= (7 - 5)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.BloodFury:BaseDuration() + 3 + 0)))) then
			if (((2187 + 1947) > (1841 + 1516)) and v19(v61.BloodFury, v52)) then
				return "blood_fury racials 4";
			end
		end
		if ((v61.Berserking:IsCastable() and ((((v61.Berserking:BaseDuration() + (574 - (47 + 524))) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (39 + 21))) and ((v82 and (v83 <= (v61.Berserking:BaseDuration() + (8 - 5)))) or (v80 and (v81 <= (v61.Berserking:BaseDuration() + (4 - 1)))) or ((v94 >= (4 - 2)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Berserking:BaseDuration() + (1729 - (1165 + 561)))))) or ((102 + 3315) < (7847 - 5313))) then
			if (v19(v61.Berserking, v52) or ((1039 + 1683) <= (643 - (341 + 138)))) then
				return "berserking racials 6";
			end
		end
		if ((v61.LightsJudgment:IsCastable() and v13:BuffUp(v61.UnholyStrengthBuff) and (not v61.Festermight:IsAvailable() or (v13:BuffRemains(v61.FestermightBuff) < v15:TimeToDie()) or (v13:BuffRemains(v61.UnholyStrengthBuff) < v15:TimeToDie()))) or ((651 + 1757) < (4351 - 2242))) then
			if (v19(v61.LightsJudgment, v52, nil, not v15:IsSpellInRange(v61.LightsJudgment)) or ((359 - (89 + 237)) == (4680 - 3225))) then
				return "lights_judgment racials 8";
			end
		end
		if ((v61.AncestralCall:IsCastable() and ((((37 - 19) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (941 - (581 + 300)))) and ((v82 and (v83 <= (1238 - (855 + 365)))) or (v80 and (v81 <= (42 - 24))) or ((v94 >= (1 + 1)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (1253 - (1030 + 205))))) or ((416 + 27) >= (3736 + 279))) then
			if (((3668 - (156 + 130)) > (377 - 211)) and v19(v61.AncestralCall, v52)) then
				return "ancestral_call racials 10";
			end
		end
		if ((v61.ArcanePulse:IsCastable() and ((v94 >= (2 - 0)) or ((v13:Rune() <= (1 - 0)) and (v13:RunicPowerDeficit() >= (16 + 44))))) or ((164 + 116) == (3128 - (10 + 59)))) then
			if (((532 + 1349) > (6367 - 5074)) and v19(v61.ArcanePulse, v52, nil, not v15:IsInRange(1171 - (671 + 492)))) then
				return "arcane_pulse racials 12";
			end
		end
		if (((1877 + 480) == (3572 - (369 + 846))) and v61.Fireblood:IsCastable() and ((((v61.Fireblood:BaseDuration() + 1 + 2) >= v85) and v84) or ((not v61.SummonGargoyle:IsAvailable() or (v61.SummonGargoyle:CooldownRemains() > (52 + 8))) and ((v82 and (v83 <= (v61.Fireblood:BaseDuration() + (1948 - (1036 + 909))))) or (v80 and (v81 <= (v61.Fireblood:BaseDuration() + 3 + 0))) or ((v94 >= (2 - 0)) and v13:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61.Fireblood:BaseDuration() + (206 - (11 + 192)))))) then
			if (((63 + 60) == (298 - (135 + 40))) and v19(v61.Fireblood, v52)) then
				return "fireblood racials 14";
			end
		end
		if ((v61.BagofTricks:IsCastable() and (v94 == (2 - 1)) and (v13:BuffUp(v61.UnholyStrengthBuff) or HL.FilteredFightRemains(v93, "<", 4 + 1))) or ((2326 - 1270) >= (5084 - 1692))) then
			if (v19(v61.BagofTricks, v52, nil, not v15:IsSpellInRange(v61.BagofTricks)) or ((1257 - (50 + 126)) < (2993 - 1918))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v124()
		local v174 = 0 + 0;
		while true do
			if (((1416 - (1233 + 180)) == v174) or ((2018 - (522 + 447)) >= (5853 - (107 + 1314)))) then
				if ((v86:IsReady() and not v76) or ((2213 + 2555) <= (2577 - 1731))) then
					if (v70.CastTargetIf(v86, v93, "max", v102, v108, not v15:IsSpellInRange(v86)) or ((1427 + 1931) <= (2819 - 1399))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if ((v174 == (3 - 2)) or ((5649 - (716 + 1194)) <= (52 + 2953))) then
				if ((v87:IsReady() and v13:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= (1 + 1)) or (v61.UnholyGround:IsAvailable() and ((v80 and (v81 >= (516 - (74 + 429)))) or (v84 and (v85 > (14 - 6))) or (v82 and (v83 > (4 + 4))) or (not v76 and (v89 >= (8 - 4))))) or (v61.Defile:IsAvailable() and (v84 or v80 or v82 or v14:BuffUp(v61.DarkTransformation)))) and ((v61.FesteringWoundDebuff:AuraActiveCount() == v94) or (v94 == (1 + 0))) and not v13:IsMoving() and (v94 >= (2 - 1))) or ((4101 - 2442) >= (2567 - (279 + 154)))) then
					if (v19(v88, v48) or ((4038 - (454 + 324)) < (1853 + 502))) then
						return "any_dnd st 6";
					end
				end
				if ((v86:IsReady() and (v76 or ((v94 >= (19 - (12 + 5))) and v13:BuffUp(v61.DeathAndDecayBuff)))) or ((361 + 308) == (10759 - 6536))) then
					if (v19(v86, nil, nil, not v15:IsSpellInRange(v86)) or ((626 + 1066) < (1681 - (277 + 816)))) then
						return "wound_spender st 8";
					end
				end
				v174 = 8 - 6;
			end
			if ((v174 == (1185 - (1058 + 125))) or ((900 + 3897) < (4626 - (815 + 160)))) then
				if ((v61.FesteringStrike:IsReady() and not v76) or ((17921 - 13744) > (11513 - 6663))) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, "min", v102, v107, not v15:IsInMeleeRange(2 + 3)) or ((1169 - 769) > (3009 - (41 + 1857)))) then
						return "festering_strike st 10";
					end
				end
				if (((4944 - (1222 + 671)) > (2597 - 1592)) and v61.DeathCoil:IsReady()) then
					if (((5307 - 1614) <= (5564 - (229 + 953))) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil st 12";
					end
				end
				v174 = 1777 - (1111 + 663);
			end
			if ((v174 == (1579 - (874 + 705))) or ((460 + 2822) > (2798 + 1302))) then
				if ((v61.DeathCoil:IsReady() and not v72 and ((not v77 and v73) or (v91 < (20 - 10)))) or ((101 + 3479) < (3523 - (642 + 37)))) then
					if (((21 + 68) < (719 + 3771)) and v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil))) then
						return "death_coil st 2";
					end
				end
				if ((v61.Epidemic:IsReady() and v72 and ((not v77 and v73) or (v91 < (25 - 15)))) or ((5437 - (233 + 221)) < (4180 - 2372))) then
					if (((3371 + 458) > (5310 - (718 + 823))) and v19(v61.Epidemic, v55, nil, not v15:IsInRange(26 + 14))) then
						return "epidemic st 4";
					end
				end
				v174 = 806 - (266 + 539);
			end
		end
	end
	local function v125()
		if (((4204 - 2719) <= (4129 - (636 + 589))) and v33) then
			local v179 = v115();
			if (((10133 - 5864) == (8804 - 4535)) and v179) then
				return v179;
			end
		end
	end
	local function v126()
		v72 = (v61.ImprovedDeathCoil:IsAvailable() and not v61.CoilofDevastation:IsAvailable() and (v94 >= (3 + 0))) or (v61.CoilofDevastation:IsAvailable() and (v94 >= (2 + 2))) or (not v61.ImprovedDeathCoil:IsAvailable() and (v94 >= (1017 - (657 + 358))));
		v71 = (v94 >= (7 - 4)) or ((v61.SummonGargoyle:CooldownRemains() > (2 - 1)) and ((v61.Apocalypse:CooldownRemains() > (1188 - (1151 + 36))) or not v61.Apocalypse:IsAvailable())) or not v61.SummonGargoyle:IsAvailable() or (v9.CombatTime() > (20 + 0));
		v74 = ((v61.Apocalypse:CooldownRemains() < (3 + 7)) and (v89 <= (11 - 7)) and (v61.UnholyAssault:CooldownRemains() > (1842 - (1552 + 280))) and (841 - (64 + 770))) or (2 + 0);
		if (((878 - 491) <= (494 + 2288)) and not v84 and v61.Festermight:IsAvailable() and v13:BuffUp(v61.FestermightBuff) and ((v13:BuffRemains(v61.FestermightBuff) / ((1248 - (157 + 1086)) * v13:GCD())) >= (1 - 0))) then
			v75 = v89 >= (4 - 3);
		else
			v75 = v89 >= ((3 - 0) - v22(v61.InfectedClaws:IsAvailable()));
		end
		v76 = (((v61.Apocalypse:CooldownRemains() > v74) or not v61.Apocalypse:IsAvailable()) and (v75 or ((v89 >= (1 - 0)) and (v61.UnholyAssault:CooldownRemains() < (839 - (599 + 220))) and v61.UnholyAssault:IsAvailable() and v78) or (v15:DebuffUp(v61.RottenTouchDebuff) and (v89 >= (1 - 0))) or (v89 > (1935 - (1813 + 118))) or (v13:HasTier(23 + 8, 1221 - (841 + 376)) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= (1 - 0))))) or ((v91 < (2 + 3)) and (v89 >= (2 - 1)));
		v77 = v61.VileContagion:IsAvailable() and (v61.VileContagion:CooldownRemains() < (862 - (464 + 395))) and (v13:RunicPower() < (153 - 93)) and not v78;
		v78 = (v94 == (1 + 0)) or not v28;
		v79 = (v94 >= (839 - (467 + 370))) and v28;
		v73 = (not v61.RottenTouch:IsAvailable() or (v61.RottenTouch:IsAvailable() and v15:DebuffDown(v61.RottenTouchDebuff)) or (v13:RunicPowerDeficit() < (41 - 21))) and (not v13:HasTier(23 + 8, 13 - 9) or (v13:HasTier(5 + 26, 8 - 4) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v13:RunicPowerDeficit() < (540 - (150 + 370))) or (v13:Rune() < (1285 - (74 + 1208)))) and ((v61.ImprovedDeathCoil:IsAvailable() and ((v94 == (4 - 2)) or v61.CoilofDevastation:IsAvailable())) or (v13:Rune() < (14 - 11)) or v84 or v13:BuffUp(v61.SuddenDoomBuff) or ((v61.Apocalypse:CooldownRemains() < (8 + 2)) and (v89 > (393 - (14 + 376)))) or (not v76 and (v89 >= (6 - 2))));
	end
	local function v127()
		v60();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v69 = not v99();
		v93 = v13:GetEnemiesInMeleeRange(4 + 1);
		v95 = v15:GetEnemiesInSplashRange(9 + 1);
		if (v28 or ((1812 + 87) <= (2686 - 1769))) then
			v94 = #v93;
			v96 = v15:GetEnemiesInSplashRangeCount(8 + 2);
		else
			v94 = 79 - (23 + 55);
			v96 = 2 - 1;
		end
		if (v70.TargetIsValid() or v13:AffectingCombat() or ((2878 + 1434) <= (787 + 89))) then
			local v180 = 0 - 0;
			while true do
				if (((703 + 1529) <= (3497 - (652 + 249))) and (v180 == (7 - 4))) then
					v85 = v92:GargRemains();
					v89 = v15:DebuffStack(v61.FesteringWoundDebuff);
					break;
				end
				if (((3963 - (708 + 1160)) < (10005 - 6319)) and ((0 - 0) == v180)) then
					v90 = v9.BossFightRemains();
					v91 = v90;
					if ((v91 == (11138 - (10 + 17))) or ((359 + 1236) >= (6206 - (1400 + 332)))) then
						v91 = v9.FightRemains(v93, false);
					end
					v180 = 1 - 0;
				end
				if ((v180 == (1910 - (242 + 1666))) or ((1977 + 2642) < (1057 + 1825))) then
					v82 = v61.ArmyoftheDead:TimeSinceLastCast() <= (26 + 4);
					v83 = (v82 and ((970 - (850 + 90)) - v61.ArmyoftheDead:TimeSinceLastCast())) or (0 - 0);
					v84 = v92:GargActive();
					v180 = 1393 - (360 + 1030);
				end
				if ((v180 == (1 + 0)) or ((829 - 535) >= (6646 - 1815))) then
					v97 = v100(v95);
					v80 = v61.Apocalypse:TimeSinceLastCast() <= (1676 - (909 + 752));
					v81 = (v80 and ((1238 - (109 + 1114)) - v61.Apocalypse:TimeSinceLastCast())) or (0 - 0);
					v180 = 1 + 1;
				end
			end
		end
		if (((2271 - (6 + 236)) <= (1944 + 1140)) and v70.TargetIsValid()) then
			if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1640 + 397) == (5707 - 3287))) then
				local v184 = 0 - 0;
				local v185;
				while true do
					if (((5591 - (1076 + 57)) > (643 + 3261)) and (v184 == (690 - (579 + 110)))) then
						v185 = v70.Interrupt(v61.MindFreeze, 2 + 13, true, v20, v63.MindFreezeMouseover);
						if (((386 + 50) >= (66 + 57)) and v185) then
							return v185;
						end
						break;
					end
					if (((907 - (174 + 233)) < (5072 - 3256)) and (v184 == (0 - 0))) then
						v185 = v70.Interrupt(v61.MindFreeze, 7 + 8, true);
						if (((4748 - (663 + 511)) == (3189 + 385)) and v185) then
							return v185;
						end
						v184 = 1 + 0;
					end
				end
			end
			if (((681 - 460) < (237 + 153)) and not v13:AffectingCombat()) then
				local v186 = 0 - 0;
				local v187;
				while true do
					if ((v186 == (0 - 0)) or ((1056 + 1157) <= (2765 - 1344))) then
						v187 = v114();
						if (((2180 + 878) < (445 + 4415)) and v187) then
							return v187;
						end
						break;
					end
				end
			end
			if ((v61.DeathStrike:IsReady() and not v69) or ((2018 - (478 + 244)) >= (4963 - (440 + 77)))) then
				if (v19(v61.DeathStrike) or ((634 + 759) > (16429 - 11940))) then
					return "death_strike low hp or proc";
				end
			end
			if ((v94 == (1556 - (655 + 901))) or ((821 + 3603) < (21 + 6))) then
				if ((v61.Outbreak:IsReady() and (v97 > (0 + 0))) or ((8045 - 6048) > (5260 - (695 + 750)))) then
					if (((11831 - 8366) > (2951 - 1038)) and v19(v61.Outbreak, nil, nil, not v15:IsSpellInRange(v61.Outbreak))) then
						return "outbreak out_of_range";
					end
				end
				if (((2947 - 2214) < (2170 - (285 + 66))) and v61.Epidemic:IsReady() and v28 and (v61.VirulentPlagueDebuff:AuraActiveCount() > (2 - 1)) and not v77) then
					if (v19(v61.Epidemic, v55, nil, not v15:IsInRange(1350 - (682 + 628))) or ((709 + 3686) == (5054 - (176 + 123)))) then
						return "epidemic out_of_range";
					end
				end
				if ((v61.DeathCoil:IsReady() and (v61.VirulentPlagueDebuff:AuraActiveCount() < (1 + 1)) and not v77) or ((2752 + 1041) < (2638 - (239 + 30)))) then
					if (v19(v61.DeathCoil, nil, nil, not v15:IsSpellInRange(v61.DeathCoil)) or ((1111 + 2973) == (255 + 10))) then
						return "death_coil out_of_range";
					end
				end
			end
			if (((7713 - 3355) == (13596 - 9238)) and v61.Apocalypse:IsReady() and v53 and (v89 >= (319 - (306 + 9)))) then
				if (v19(v61.Apocalypse, nil, not v15:IsInMeleeRange(17 - 12), v53) or ((546 + 2592) < (610 + 383))) then
					return "apocalypse garg_setup 2";
				end
			end
			if (((1603 + 1727) > (6642 - 4319)) and v61.DarkTransformation:IsReady() and (v61.Apocalypse:CooldownRemains() < (1380 - (1140 + 235))) and v54) then
				if (v19(v61.DarkTransformation, v54) or ((2308 + 1318) == (3658 + 331))) then
					return "dark_transformation cooldowns 6";
				end
			end
			v126();
			local v181 = v122();
			if (v181 or ((236 + 680) == (2723 - (33 + 19)))) then
				return v181;
			end
			local v181 = v115();
			if (((99 + 173) == (815 - 543)) and v181) then
				return v181;
			end
			if (((1872 + 2377) <= (9489 - 4650)) and v29 and not v71) then
				local v188 = v121();
				if (((2604 + 173) < (3889 - (586 + 103))) and v188) then
					return v188;
				end
			end
			if (((9 + 86) < (6024 - 4067)) and v29 and v78) then
				local v189 = 1488 - (1309 + 179);
				local v190;
				while true do
					if (((1490 - 664) < (748 + 969)) and (v189 == (0 - 0))) then
						v190 = v120();
						if (((1078 + 348) >= (2347 - 1242)) and v190) then
							return v190;
						end
						break;
					end
				end
			end
			if (((5487 - 2733) <= (3988 - (295 + 314))) and v28 and v29 and v79) then
				local v191 = 0 - 0;
				local v192;
				while true do
					if (((1962 - (1300 + 662)) == v191) or ((12331 - 8404) == (3168 - (1178 + 577)))) then
						v192 = v118();
						if (v192 or ((600 + 554) <= (2329 - 1541))) then
							return v192;
						end
						break;
					end
				end
			end
			if (v29 or ((3048 - (851 + 554)) > (2988 + 391))) then
				local v193 = 0 - 0;
				local v194;
				while true do
					if ((v193 == (0 - 0)) or ((3105 - (115 + 187)) > (3484 + 1065))) then
						v194 = v123();
						if (v194 or ((209 + 11) >= (11908 - 8886))) then
							return v194;
						end
						break;
					end
				end
			end
			if (((3983 - (160 + 1001)) == (2469 + 353)) and v28) then
				if ((v79 and (v87:CooldownRemains() < (7 + 3)) and v13:BuffDown(v61.DeathAndDecayBuff)) or ((2171 - 1110) == (2215 - (237 + 121)))) then
					local v196 = v119();
					if (((3657 - (525 + 372)) > (2585 - 1221)) and v196) then
						return v196;
					end
				end
				if (((v94 >= (12 - 8)) and v13:BuffUp(v61.DeathAndDecayBuff)) or ((5044 - (96 + 46)) <= (4372 - (643 + 134)))) then
					local v197 = v117();
					if (v197 or ((1391 + 2461) == (702 - 409))) then
						return v197;
					end
				end
				if (((v94 >= (14 - 10)) and (((v87:CooldownRemains() > (10 + 0)) and v13:BuffDown(v61.DeathAndDecayBuff)) or not v79)) or ((3058 - 1499) == (9378 - 4790))) then
					local v198 = v116();
					if (v198 or ((5203 - (316 + 403)) == (524 + 264))) then
						return v198;
					end
				end
			end
			if (((12559 - 7991) >= (1412 + 2495)) and (v94 <= (7 - 4))) then
				local v195 = v124();
				if (((883 + 363) < (1119 + 2351)) and v195) then
					return v195;
				end
			end
			if (((14095 - 10027) >= (4642 - 3670)) and v61.FesteringStrike:IsReady()) then
				if (((1023 - 530) < (223 + 3670)) and v19(v61.FesteringStrike, nil, nil)) then
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
	v9.SetAPL(495 - 243, v127, v128);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

