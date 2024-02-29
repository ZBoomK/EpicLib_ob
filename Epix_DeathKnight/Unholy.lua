local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1155 - (59 + 1096);
	local v6;
	while true do
		if (((1 + 0) == v5) or ((1823 + 364) >= (6116 - (171 + 991)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((10410 - 6533) == (8921 - 5346))) then
			v6 = v0[v4];
			if (((566 + 141) > (2215 - 1583)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v21 = v10.Mouseover;
	local v22 = v10.Macro;
	local v23 = v10.Commons.Everyone.num;
	local v24 = v10.Commons.Everyone.bool;
	local v25 = math.min;
	local v26 = math.abs;
	local v27 = math.max;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v20 = v10.Cast;
	local v31 = table.insert;
	local v32 = GetTime;
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
	local function v61()
		local v130 = 0 - 0;
		while true do
			if (((12 - 8) == v130) or ((1794 - (111 + 1137)) >= (2842 - (91 + 67)))) then
				v47 = EpicSettings.Settings['AntiMagicShellGCD'];
				v48 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v49 = EpicSettings.Settings['DeathAndDecayGCD'];
				v130 = 14 - 9;
			end
			if (((366 + 1099) <= (4824 - (423 + 100))) and (v130 == (1 + 6))) then
				v56 = EpicSettings.Settings['EpidemicGCD'];
				v57 = EpicSettings.Settings['SummonGargoyleGCD'];
				v58 = EpicSettings.Settings['UnholyAssaultGCD'];
				v130 = 21 - 13;
			end
			if (((889 + 815) > (2196 - (326 + 445))) and (v130 == (13 - 10))) then
				v44 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 - 0);
				v45 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 - 0);
				v46 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v130 = 715 - (530 + 181);
			end
			if ((v130 == (881 - (614 + 267))) or ((719 - (19 + 13)) == (6891 - 2657))) then
				v33 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v130 = 2 - 1;
			end
			if ((v130 == (2 + 3)) or ((5856 - 2526) < (2963 - 1534))) then
				v50 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v51 = EpicSettings.Settings['SacrificialPactGCD'];
				v52 = EpicSettings.Settings['MindFreezeOffGCD'];
				v130 = 1818 - (1293 + 519);
			end
			if (((2339 - 1192) >= (874 - 539)) and (v130 == (11 - 5))) then
				v53 = EpicSettings.Settings['RacialsOffGCD'];
				v54 = EpicSettings.Settings['ApocalypseGCD'];
				v55 = EpicSettings.Settings['DarkTransformationGCD'];
				v130 = 30 - 23;
			end
			if (((8091 - 4656) > (1111 + 986)) and (v130 == (2 + 6))) then
				v59 = EpicSettings.Settings['UnholyBlightGCD'];
				v60 = EpicSettings.Settings['VileContagionGCD'];
				break;
			end
			if ((v130 == (4 - 2)) or ((872 + 2898) >= (1343 + 2698))) then
				v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1096 - (709 + 387));
				v42 = EpicSettings.Settings['InterruptThreshold'] or (1858 - (673 + 1185));
				v130 = 8 - 5;
			end
			if ((v130 == (3 - 2)) or ((6237 - 2446) <= (1153 + 458))) then
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v38 = EpicSettings.Settings['UseHealthstone'];
				v39 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v130 = 1 + 1;
			end
		end
	end
	local v62 = v17.DeathKnight.Unholy;
	local v63 = v19.DeathKnight.Unholy;
	local v64 = v22.DeathKnight.Unholy;
	local v65 = {};
	local v66 = v14:GetEquipment();
	local v67 = (v66[25 - 12] and v19(v66[24 - 11])) or v19(1880 - (446 + 1434));
	local v68 = (v66[1297 - (1040 + 243)] and v19(v66[41 - 27])) or v19(1847 - (559 + 1288));
	local v69;
	local v70;
	local v71 = v10.Commons.Everyone;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81, v82;
	local v83, v84;
	local v85, v86;
	local v87 = ((v62.ClawingShadows:IsAvailable()) and v62.ClawingShadows) or v62.ScourgeStrike;
	local v88 = ((v62.Defile:IsAvailable()) and v62.Defile) or v62.DeathAndDecay;
	local v89 = ((v62.Defile:IsAvailable()) and v64.DefilePlayer) or v64.DaDPlayer;
	local v90;
	local v91 = 13042 - (609 + 1322);
	local v92 = 11565 - (13 + 441);
	local v93 = v10.GhoulTable;
	local v94, v95;
	local v96, v97;
	local v98;
	local v99 = {{v62.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (1 + 0)) or ((2007 + 2571) <= (5958 - 3950))) then
				v68 = (v66[8 + 6] and v19(v66[25 - 11])) or v19(0 + 0);
				break;
			end
			if (((626 + 499) <= (1492 + 584)) and (v131 == (0 + 0))) then
				v66 = v14:GetEquipment();
				v67 = (v66[13 + 0] and v19(v66[446 - (153 + 280)])) or v19(0 - 0);
				v131 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (0 + 0)) or ((675 + 68) >= (3188 + 1211))) then
				v91 = 16918 - 5807;
				v92 = 6868 + 4243;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v87 = ((v62.ClawingShadows:IsAvailable()) and v62.ClawingShadows) or v62.ScourgeStrike;
		v89 = ((v62.Defile:IsAvailable()) and v64.DefilePlayer) or v64.DaDPlayer;
		v88 = ((v62.Defile:IsAvailable()) and v62.Defile) or v62.DeathAndDecay;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v100()
		return (v14:HealthPercentage() < v44) or ((v14:HealthPercentage() < v45) and v14:BuffUp(v62.DeathStrikeBuff));
	end
	local function v101(v133)
		local v134 = 667 - (89 + 578);
		local v135;
		while true do
			if (((826 + 329) < (3477 - 1804)) and (v134 == (1050 - (572 + 477)))) then
				return v135;
			end
			if ((v134 == (0 + 0)) or ((1395 + 929) <= (69 + 509))) then
				v135 = 86 - (84 + 2);
				for v186, v187 in pairs(v133) do
					if (((6207 - 2440) == (2714 + 1053)) and v187:DebuffDown(v62.VirulentPlagueDebuff)) then
						v135 = v135 + (843 - (497 + 345));
					end
				end
				v134 = 1 + 0;
			end
		end
	end
	local function v102(v136)
		local v137 = 0 + 0;
		local v138;
		while true do
			if (((5422 - (605 + 728)) == (2918 + 1171)) and (v137 == (1 - 0))) then
				return v10.FightRemains(v138);
			end
			if (((205 + 4253) >= (6189 - 4515)) and (v137 == (0 + 0))) then
				v138 = {};
				for v188 in pairs(v136) do
					if (((2692 - 1720) <= (1071 + 347)) and not v13:IsInBossList(v136[v188]['UnitNPCID'])) then
						v31(v138, v136[v188]);
					end
				end
				v137 = 490 - (457 + 32);
			end
		end
	end
	local function v103(v139)
		return (v139:DebuffStack(v62.FesteringWoundDebuff));
	end
	local function v104(v140)
		return (v140:DebuffRemains(v62.SoulReaper));
	end
	local function v105(v141)
		return (v62.BurstingSores:IsAvailable() and v141:DebuffUp(v62.FesteringWoundDebuff) and ((v14:BuffDown(v62.DeathAndDecayBuff) and v62.DeathAndDecay:CooldownDown() and (v14:Rune() < (2 + 1))) or (v14:BuffUp(v62.DeathAndDecayBuff) and (v14:Rune() == (1402 - (832 + 570)))))) or (not v62.BurstingSores:IsAvailable() and (v141:DebuffStack(v62.FesteringWoundDebuff) >= (4 + 0))) or (v14:HasTier(9 + 22, 6 - 4) and v141:DebuffUp(v62.FesteringWoundDebuff));
	end
	local function v106(v142)
		return v142:DebuffStack(v62.FesteringWoundDebuff) >= (2 + 2);
	end
	local function v107(v143)
		return v143:DebuffStack(v62.FesteringWoundDebuff) < (800 - (588 + 208));
	end
	local function v108(v144)
		return v144:DebuffStack(v62.FesteringWoundDebuff) < (10 - 6);
	end
	local function v109(v145)
		return v145:DebuffStack(v62.FesteringWoundDebuff) >= (1804 - (884 + 916));
	end
	local function v110(v146)
		return ((v146:TimeToX(73 - 38) < (3 + 2)) or (v146:HealthPercentage() <= (688 - (232 + 421)))) and (v146:TimeToDie() > (v146:DebuffRemains(v62.SoulReaper) + (1894 - (1569 + 320))));
	end
	local function v111(v147)
		return (v147:DebuffStack(v62.FesteringWoundDebuff) <= (1 + 1)) or v15:BuffUp(v62.DarkTransformation);
	end
	local function v112(v148)
		return (v148:DebuffStack(v62.FesteringWoundDebuff) >= (1 + 3)) and (v88:CooldownRemains() < (9 - 6));
	end
	local function v113(v149)
		return v149:DebuffStack(v62.FesteringWoundDebuff) >= (606 - (316 + 289));
	end
	local function v114(v150)
		return (v150:TimeToDie() > v150:DebuffRemains(v62.VirulentPlagueDebuff)) and (v150:DebuffRefreshable(v62.VirulentPlagueDebuff) or (v62.Superstrain:IsAvailable() and (v150:DebuffRefreshable(v62.FrostFeverDebuff) or v150:DebuffRefreshable(v62.BloodPlagueDebuff)))) and (not v62.UnholyBlight:IsAvailable() or (v62.UnholyBlight:IsAvailable() and (v62.UnholyBlight:CooldownRemains() > ((39 - 24) / ((v23(v62.Superstrain:IsAvailable()) * (1 + 2)) + (v23(v62.Plaguebringer:IsAvailable()) * (1455 - (666 + 787))) + (v23(v62.EbonFever:IsAvailable()) * (427 - (360 + 65))))))));
	end
	local function v115()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (255 - (79 + 175))) or ((7785 - 2847) < (3716 + 1046))) then
				if (v62.Outbreak:IsReady() or ((7675 - 5171) > (8211 - 3947))) then
					if (((3052 - (503 + 396)) == (2334 - (92 + 89))) and v20(v62.Outbreak, nil, nil, not v16:IsSpellInRange(v62.Outbreak))) then
						return "outbreak precombat 6";
					end
				end
				if (v62.FesteringStrike:IsReady() or ((983 - 476) >= (1329 + 1262))) then
					if (((2653 + 1828) == (17548 - 13067)) and v20(v62.FesteringStrike, nil, nil, not v16:IsInMeleeRange(1 + 4))) then
						return "festering_strike precombat 8";
					end
				end
				break;
			end
			if ((v151 == (0 - 0)) or ((2032 + 296) < (331 + 362))) then
				if (((13181 - 8853) == (541 + 3787)) and v62.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive() or not v15:IsActive())) then
					if (((2421 - 833) >= (2576 - (485 + 759))) and v20(v62.RaiseDead, nil)) then
						return "raise_dead precombat 2 displaystyle";
					end
				end
				if ((v62.ArmyoftheDead:IsReady() and v30) or ((9657 - 5483) > (5437 - (442 + 747)))) then
					if (v20(v62.ArmyoftheDead, nil) or ((5721 - (832 + 303)) <= (1028 - (88 + 858)))) then
						return "army_of_the_dead precombat 4";
					end
				end
				v151 = 1 + 0;
			end
		end
	end
	local function v116()
		v69 = v71.HandleTopTrinket(v65, v30, 34 + 6, nil);
		if (((160 + 3703) == (4652 - (766 + 23))) and v69) then
			return v69;
		end
		v69 = v71.HandleBottomTrinket(v65, v30, 197 - 157, nil);
		if (v69 or ((385 - 103) <= (110 - 68))) then
			return v69;
		end
	end
	local function v117()
		local v152 = 0 - 0;
		while true do
			if (((5682 - (1036 + 37)) >= (544 + 222)) and (v152 == (0 - 0))) then
				if ((v62.Epidemic:IsReady() and (not v78 or (v92 < (8 + 2)))) or ((2632 - (641 + 839)) == (3401 - (910 + 3)))) then
					if (((8723 - 5301) > (5034 - (1466 + 218))) and v20(v62.Epidemic, v56, nil, not v16:IsInRange(14 + 16))) then
						return "epidemic aoe 2";
					end
				end
				if (((2025 - (556 + 592)) > (134 + 242)) and v87:IsReady() and v77) then
					if (v71.CastTargetIf(v87, v94, "max", v103, nil, not v16:IsSpellInRange(v87)) or ((3926 - (329 + 479)) <= (2705 - (174 + 680)))) then
						return "wound_spender aoe 4";
					end
				end
				v152 = 3 - 2;
			end
			if ((v152 == (1 - 0)) or ((118 + 47) >= (4231 - (396 + 343)))) then
				if (((350 + 3599) < (6333 - (29 + 1448))) and v62.FesteringStrike:IsReady() and not v77) then
					if (v71.CastTargetIf(v62.FesteringStrike, v94, "max", v103, nil, not v16:IsInMeleeRange(1394 - (135 + 1254))) or ((16108 - 11832) < (14082 - 11066))) then
						return "festering_strike aoe 6";
					end
				end
				if (((3126 + 1564) > (5652 - (389 + 1138))) and v62.DeathCoil:IsReady() and not v78 and not v62.Epidemic:IsAvailable()) then
					if (v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil)) or ((624 - (102 + 472)) >= (846 + 50))) then
						return "death_coil aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v118()
		if ((v62.Epidemic:IsReady() and ((v14:Rune() < (1 + 0)) or (v62.BurstingSores:IsAvailable() and (v62.FesteringWoundDebuff:AuraActiveCount() == (0 + 0)))) and not v78 and ((v95 >= (1551 - (320 + 1225))) or (v14:RunicPowerDeficit() < (53 - 23)) or (v14:BuffStack(v62.FestermightBuff) == (13 + 7)))) or ((3178 - (157 + 1307)) >= (4817 - (821 + 1038)))) then
			if (v20(v62.Epidemic, v56, nil, not v16:IsInRange(99 - 59)) or ((164 + 1327) < (1143 - 499))) then
				return "epidemic aoe_burst 2";
			end
		end
		if (((262 + 442) < (2446 - 1459)) and v87:IsReady()) then
			if (((4744 - (834 + 192)) > (122 + 1784)) and v71.CastTargetIf(v87, v94, "max", v103, v113, not v16:IsSpellInRange(v87))) then
				return "wound_spender aoe_burst 4";
			end
		end
		if ((v62.Epidemic:IsReady() and (not v78 or (v92 < (3 + 7)))) or ((21 + 937) > (5631 - 1996))) then
			if (((3805 - (300 + 4)) <= (1200 + 3292)) and v20(v62.Epidemic, v56, nil, not v16:IsInRange(104 - 64))) then
				return "epidemic aoe_burst 6";
			end
		end
		if ((v62.DeathCoil:IsReady() and not v78 and not v62.Epidemic:IsAvailable()) or ((3804 - (112 + 250)) < (1016 + 1532))) then
			if (((7202 - 4327) >= (839 + 625)) and v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil))) then
				return "death_coil aoe_burst 8";
			end
		end
		if (v87:IsReady() or ((2481 + 2316) >= (3660 + 1233))) then
			if (v20(v87, nil, nil, not v16:IsSpellInRange(v87)) or ((274 + 277) > (1537 + 531))) then
				return "wound_spender aoe_burst 10";
			end
		end
	end
	local function v119()
		local v153 = 1414 - (1001 + 413);
		while true do
			if (((4713 - 2599) > (1826 - (244 + 638))) and ((695 - (627 + 66)) == v153)) then
				if (v62.UnholyAssault:IsCastable() or ((6739 - 4477) >= (3698 - (512 + 90)))) then
					if (v71.CastTargetIf(v62.UnholyAssault, v94, "min", v103, v111, not v16:IsInMeleeRange(1911 - (1665 + 241)), v58) or ((2972 - (373 + 344)) >= (1596 + 1941))) then
						return "unholy_assault aoe_cooldowns 10";
					end
				end
				if ((v62.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) or ((1016 + 2821) < (3444 - 2138))) then
					if (((4992 - 2042) == (4049 - (35 + 1064))) and v20(v62.RaiseDead, nil)) then
						return "raise_dead aoe_cooldowns 12";
					end
				end
				v153 = 3 + 0;
			end
			if (((0 - 0) == v153) or ((19 + 4704) < (4534 - (298 + 938)))) then
				if (((2395 - (233 + 1026)) >= (1820 - (636 + 1030))) and v62.VileContagion:IsReady() and (v88:CooldownRemains() < (2 + 1))) then
					if (v71.CastTargetIf(v62.VileContagion, v94, "max", v103, v112, not v16:IsSpellInRange(v62.VileContagion)) or ((265 + 6) > (1411 + 3337))) then
						return "vile_contagion aoe_cooldowns 2";
					end
				end
				if (((321 + 4419) >= (3373 - (55 + 166))) and v62.SummonGargoyle:IsReady()) then
					if (v20(v62.SummonGargoyle, v57) or ((500 + 2078) >= (341 + 3049))) then
						return "summon_gargoyle aoe_cooldowns 4";
					end
				end
				v153 = 3 - 2;
			end
			if (((338 - (36 + 261)) <= (2904 - 1243)) and (v153 == (1372 - (34 + 1334)))) then
				if (((232 + 369) < (2767 + 793)) and v62.SacrificialPact:IsReady() and ((v15:BuffDown(v62.DarkTransformation) and (v62.DarkTransformation:CooldownRemains() > (1289 - (1035 + 248)))) or (v92 < v14:GCD()))) then
					if (((256 - (20 + 1)) < (358 + 329)) and v20(v62.SacrificialPact, v51)) then
						return "sacrificial_pact aoe_cooldowns 18";
					end
				end
				break;
			end
			if (((4868 - (134 + 185)) > (2286 - (549 + 584))) and (v153 == (686 - (314 + 371)))) then
				if ((v62.AbominationLimb:IsCastable() and ((v14:Rune() < (6 - 4)) or (v90 > (978 - (478 + 490))) or not v62.Festermight:IsAvailable() or (v14:BuffUp(v62.FestermightBuff) and (v14:BuffRemains(v62.FestermightBuff) < (7 + 5))))) or ((5846 - (786 + 386)) < (15132 - 10460))) then
					if (((5047 - (1055 + 324)) < (5901 - (1093 + 247))) and v20(v62.AbominationLimb, nil, nil, not v16:IsInRange(18 + 2))) then
						return "abomination_limb aoe_cooldowns 6";
					end
				end
				if (v62.Apocalypse:IsReady() or ((48 + 407) == (14312 - 10707))) then
					if (v71.CastTargetIf(v62.Apocalypse, v94, "min", v103, v105, not v16:IsInMeleeRange(16 - 11)) or ((7577 - 4914) == (8322 - 5010))) then
						return "apocalypse aoe_cooldowns 8";
					end
				end
				v153 = 1 + 1;
			end
			if (((16476 - 12199) <= (15424 - 10949)) and (v153 == (3 + 0))) then
				if ((v62.DarkTransformation:IsReady() and v62.DarkTransformation:IsCastable() and (((v88:CooldownRemains() < (25 - 15)) and v62.InfectedClaws:IsAvailable() and ((v62.FesteringWoundDebuff:AuraActiveCount() < v97) or not v62.VileContagion:IsAvailable())) or not v62.InfectedClaws:IsAvailable())) or ((1558 - (364 + 324)) == (3259 - 2070))) then
					if (((3726 - 2173) <= (1039 + 2094)) and v20(v62.DarkTransformation, v55)) then
						return "dark_transformation aoe_cooldowns 14";
					end
				end
				if ((v62.EmpowerRuneWeapon:IsCastable() and (v15:BuffUp(v62.DarkTransformation))) or ((9360 - 7123) >= (5622 - 2111))) then
					if (v20(v62.EmpowerRuneWeapon, v50) or ((4020 - 2696) > (4288 - (1249 + 19)))) then
						return "empower_rune_weapon aoe_cooldowns 16";
					end
				end
				v153 = 4 + 0;
			end
		end
	end
	local function v120()
		local v154 = 0 - 0;
		while true do
			if ((v154 == (1086 - (686 + 400))) or ((2348 + 644) == (2110 - (73 + 156)))) then
				if (((15 + 3091) > (2337 - (721 + 90))) and v88:IsReady() and (not v62.BurstingSores:IsAvailable() or (v62.FesteringWoundDebuff:AuraActiveCount() == v97) or (v62.FesteringWoundDebuff:AuraActiveCount() >= (1 + 7)))) then
					if (((9815 - 6792) < (4340 - (224 + 246))) and v20(v89, v49)) then
						return "any_dnd aoe_setup 2";
					end
				end
				if (((231 - 88) > (135 - 61)) and v62.FesteringStrike:IsReady() and (v62.FesteringWoundDebuff:AuraActiveCount() < v97) and v62.BurstingSores:IsAvailable()) then
					if (((4 + 14) < (51 + 2061)) and v71.CastTargetIf(v62.FesteringStrike, v94, "min", v103, nil, not v16:IsInMeleeRange(4 + 1))) then
						return "festering_strike aoe_setup 4";
					end
				end
				v154 = 1 - 0;
			end
			if (((3650 - 2553) <= (2141 - (203 + 310))) and (v154 == (1994 - (1238 + 755)))) then
				if (((324 + 4306) == (6164 - (709 + 825))) and v62.Epidemic:IsReady() and (not v78 or (v92 < (18 - 8)))) then
					if (((5156 - 1616) > (3547 - (196 + 668))) and v20(v62.Epidemic, v56, nil, not v16:IsInRange(157 - 117))) then
						return "epidemic aoe_setup 6";
					end
				end
				if (((9930 - 5136) >= (4108 - (171 + 662))) and v62.FesteringStrike:IsReady() and (v62.FesteringWoundDebuff:AuraActiveCount() < v97)) then
					if (((1577 - (4 + 89)) == (5201 - 3717)) and v71.CastTargetIf(v62.FesteringStrike, v94, "min", v103, nil, not v16:IsInMeleeRange(2 + 3))) then
						return "festering_strike aoe_setup 8";
					end
				end
				v154 = 8 - 6;
			end
			if (((562 + 870) < (5041 - (35 + 1451))) and ((1455 - (28 + 1425)) == v154)) then
				if ((v62.FesteringStrike:IsReady() and (v62.Apocalypse:CooldownRemains() < v75)) or ((3058 - (941 + 1052)) > (3431 + 147))) then
					if (v71.CastTargetIf(v62.FesteringStrike, v94, "max", v103, v107, not v16:IsInMeleeRange(1519 - (822 + 692))) or ((6845 - 2050) < (663 + 744))) then
						return "festering_strike aoe_setup 10";
					end
				end
				if (((2150 - (45 + 252)) < (4763 + 50)) and v62.DeathCoil:IsReady() and not v78 and not v62.Epidemic:IsAvailable()) then
					if (v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil)) or ((971 + 1850) < (5916 - 3485))) then
						return "death_coil aoe_setup 12";
					end
				end
				break;
			end
		end
	end
	local function v121()
		if ((v62.SummonGargoyle:IsCastable() and (v14:BuffUp(v62.CommanderoftheDeadBuff) or not v62.CommanderoftheDead:IsAvailable())) or ((3307 - (114 + 319)) < (3131 - 950))) then
			if (v20(v62.SummonGargoyle, v57) or ((3444 - 755) <= (219 + 124))) then
				return "summon_gargoyle cooldowns 2";
			end
		end
		if ((v62.RaiseDead:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) or ((2783 - 914) == (4209 - 2200))) then
			if (v20(v62.RaiseDead, nil) or ((5509 - (556 + 1407)) < (3528 - (741 + 465)))) then
				return "raise_dead cooldowns 4 displaystyle";
			end
		end
		if ((v62.DarkTransformation:IsReady() and (v62.Apocalypse:CooldownRemains() < (470 - (170 + 295)))) or ((1097 + 985) == (4385 + 388))) then
			if (((7986 - 4742) > (875 + 180)) and v20(v62.DarkTransformation, v55)) then
				return "dark_transformation cooldowns 6";
			end
		end
		if ((v62.Apocalypse:IsReady() and v79) or ((2125 + 1188) <= (1007 + 771))) then
			if (v71.CastTargetIf(v62.Apocalypse, v94, "max", v103, v106, not v16:IsInMeleeRange(1235 - (957 + 273)), v54) or ((381 + 1040) >= (843 + 1261))) then
				return "apocalypse cooldowns 8";
			end
		end
		if (((6904 - 5092) <= (8561 - 5312)) and v62.EmpowerRuneWeapon:IsCastable() and ((v79 and ((v85 and (v86 <= (70 - 47))) or (not v62.SummonGargoyle:IsAvailable() and v62.ArmyoftheDamned:IsAvailable() and v83 and v81) or (not v62.SummonGargoyle:IsAvailable() and not v62.ArmyoftheDamned:IsAvailable() and v15:BuffUp(v62.DarkTransformation)) or (not v62.SummonGargoyle:IsAvailable() and v15:BuffUp(v62.DarkTransformation)))) or (v92 <= (103 - 82)))) then
			if (((3403 - (389 + 1391)) <= (1228 + 729)) and v20(v62.EmpowerRuneWeapon, v50)) then
				return "empower_rune_weapon cooldowns 10";
			end
		end
		if (((460 + 3952) == (10044 - 5632)) and v62.AbominationLimb:IsCastable() and (v14:Rune() < (954 - (783 + 168))) and v79) then
			if (((5873 - 4123) >= (829 + 13)) and v20(v62.AbominationLimb)) then
				return "abomination_limb cooldowns 12";
			end
		end
		if (((4683 - (309 + 2)) > (5681 - 3831)) and v62.UnholyAssault:IsReady() and v79) then
			if (((1444 - (1090 + 122)) < (267 + 554)) and v71.CastTargetIf(v62.UnholyAssault, v94, "min", v103, nil, not v16:IsInMeleeRange(16 - 11), v58)) then
				return "unholy_assault cooldowns 14";
			end
		end
		if (((355 + 163) < (2020 - (628 + 490))) and v62.SoulReaper:IsReady() and (v95 == (1 + 0)) and ((v16:TimeToX(86 - 51) < (22 - 17)) or (v16:HealthPercentage() <= (809 - (431 + 343)))) and (v16:TimeToDie() > (10 - 5))) then
			if (((8661 - 5667) > (678 + 180)) and v20(v62.SoulReaper, nil, nil, not v16:IsSpellInRange(v62.SoulReaper))) then
				return "soul_reaper cooldowns 16";
			end
		end
		if ((v62.SoulReaper:IsReady() and (v95 >= (1 + 1))) or ((5450 - (556 + 1139)) <= (930 - (6 + 9)))) then
			if (((723 + 3223) > (1918 + 1825)) and v71.CastTargetIf(v62.SoulReaper, v94, "min", v104, v110, not v16:IsSpellInRange(v62.SoulReaper))) then
				return "soul_reaper cooldowns 18";
			end
		end
	end
	local function v122()
		local v155 = 169 - (28 + 141);
		while true do
			if ((v155 == (1 + 1)) or ((1647 - 312) >= (2342 + 964))) then
				if (((6161 - (486 + 831)) > (5862 - 3609)) and v30 and v85 and (v86 <= (80 - 57))) then
					local v204 = 0 + 0;
					while true do
						if (((1429 - 977) == (1715 - (668 + 595))) and (v204 == (0 + 0))) then
							if (v62.EmpowerRuneWeapon:IsCastable() or ((919 + 3638) < (5691 - 3604))) then
								if (((4164 - (23 + 267)) == (5818 - (1129 + 815))) and v20(v62.EmpowerRuneWeapon, v50)) then
									return "empower_rune_weapon garg_setup 10";
								end
							end
							if (v62.UnholyAssault:IsCastable() or ((2325 - (371 + 16)) > (6685 - (1326 + 424)))) then
								if (v20(v62.UnholyAssault, v58, nil, not v16:IsInMeleeRange(9 - 4)) or ((15548 - 11293) < (3541 - (88 + 30)))) then
									return "unholy_assault garg_setup 12";
								end
							end
							break;
						end
					end
				end
				if (((2225 - (720 + 51)) <= (5541 - 3050)) and v62.DarkTransformation:IsReady() and ((v62.CommanderoftheDead:IsAvailable() and (v14:RunicPower() > (1816 - (421 + 1355)))) or not v62.CommanderoftheDead:IsAvailable())) then
					if (v20(v62.DarkTransformation, v55) or ((6857 - 2700) <= (1377 + 1426))) then
						return "dark_transformation garg_setup 16";
					end
				end
				v155 = 1086 - (286 + 797);
			end
			if (((17740 - 12887) >= (4938 - 1956)) and (v155 == (442 - (397 + 42)))) then
				if (((1292 + 2842) > (4157 - (24 + 776))) and v88:IsReady() and v14:BuffDown(v62.DeathAndDecayBuff) and (v90 > (0 - 0))) then
					if (v20(v89, v49) or ((4202 - (222 + 563)) < (5582 - 3048))) then
						return "any_dnd garg_setup 18";
					end
				end
				if ((v62.FesteringStrike:IsReady() and ((v90 == (0 + 0)) or not v62.Apocalypse:IsAvailable() or ((v14:RunicPower() < (230 - (23 + 167))) and not v85))) or ((4520 - (690 + 1108)) <= (60 + 104))) then
					if (v20(v62.FesteringStrike, nil, nil, not v16:IsInMeleeRange(5 + 0)) or ((3256 - (40 + 808)) < (348 + 1761))) then
						return "festering_strike garg_setup 20";
					end
				end
				v155 = 15 - 11;
			end
			if ((v155 == (0 + 0)) or ((18 + 15) == (798 + 657))) then
				if ((v62.Apocalypse:IsReady() and (v90 >= (575 - (47 + 524))) and ((v14:BuffUp(v62.CommanderoftheDeadBuff) and (v86 < (15 + 8))) or not v62.CommanderoftheDead:IsAvailable())) or ((1210 - 767) >= (6003 - 1988))) then
					if (((7712 - 4330) > (1892 - (1165 + 561))) and v20(v62.Apocalypse, v54, nil, not v16:IsInMeleeRange(1 + 4))) then
						return "apocalypse garg_setup 2";
					end
				end
				if ((v62.ArmyoftheDead:IsReady() and v30 and ((v62.CommanderoftheDead:IsAvailable() and ((v62.DarkTransformation:CooldownRemains() < (9 - 6)) or v14:BuffUp(v62.CommanderoftheDeadBuff))) or (not v62.CommanderoftheDead:IsAvailable() and v62.UnholyAssault:IsAvailable() and (v62.UnholyAssault:CooldownRemains() < (4 + 6))) or (not v62.UnholyAssault:IsAvailable() and not v62.CommanderoftheDead:IsAvailable()))) or ((759 - (341 + 138)) == (826 + 2233))) then
					if (((3881 - 2000) > (1619 - (89 + 237))) and v20(v62.ArmyoftheDead)) then
						return "army_of_the_dead garg_setup 4";
					end
				end
				v155 = 3 - 2;
			end
			if (((4961 - 2604) == (3238 - (581 + 300))) and ((1224 - (855 + 365)) == v155)) then
				if (((291 - 168) == (41 + 82)) and v62.DeathCoil:IsReady() and (v14:Rune() <= (1236 - (1030 + 205)))) then
					if (v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil)) or ((992 + 64) >= (3156 + 236))) then
						return "death_coil garg_setup 22";
					end
				end
				break;
			end
			if ((v155 == (287 - (156 + 130))) or ((2456 - 1375) < (1811 - 736))) then
				if ((v62.SoulReaper:IsReady() and (v95 == (1 - 0)) and ((v16:TimeToX(10 + 25) < (3 + 2)) or (v16:HealthPercentage() <= (104 - (10 + 59)))) and (v16:TimeToDie() > (2 + 3))) or ((5166 - 4117) >= (5595 - (671 + 492)))) then
					if (v20(v62.SoulReaper, nil, nil, not v16:IsInMeleeRange(4 + 1)) or ((5983 - (369 + 846)) <= (224 + 622))) then
						return "soul_reaper garg_setup 6";
					end
				end
				if ((v62.SummonGargoyle:IsCastable() and v30 and (v14:BuffUp(v62.CommanderoftheDeadBuff) or (not v62.CommanderoftheDead:IsAvailable() and (v14:RunicPower() >= (35 + 5))))) or ((5303 - (1036 + 909)) <= (1130 + 290))) then
					if (v20(v62.SummonGargoyle, v57) or ((6276 - 2537) <= (3208 - (11 + 192)))) then
						return "summon_gargoyle garg_setup 8";
					end
				end
				v155 = 2 + 0;
			end
		end
	end
	local function v123()
		local v156 = 175 - (135 + 40);
		local v157;
		while true do
			if (((4 - 2) == v156) or ((1000 + 659) >= (4701 - 2567))) then
				if ((v62.DeathCoil:IsReady() and ((v95 <= (4 - 1)) or not v62.Epidemic:IsAvailable()) and ((v85 and v62.CommanderoftheDead:IsAvailable() and v14:BuffUp(v62.CommanderoftheDeadBuff) and (v62.Apocalypse:CooldownRemains() < (181 - (50 + 126))) and (v14:BuffRemains(v62.CommanderoftheDeadBuff) > (75 - 48))) or (v16:DebuffUp(v62.DeathRotDebuff) and (v16:DebuffRemains(v62.DeathRotDebuff) < v14:GCD())))) or ((722 + 2538) < (3768 - (1233 + 180)))) then
					if (v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil)) or ((1638 - (522 + 447)) == (5644 - (107 + 1314)))) then
						return "death_coil high_prio_actions 6";
					end
				end
				if ((v62.Epidemic:IsReady() and (v97 >= (2 + 2)) and ((v62.CommanderoftheDead:IsAvailable() and v14:BuffUp(v62.CommanderoftheDeadBuff) and (v62.Apocalypse:CooldownRemains() < (15 - 10))) or (v16:DebuffUp(v62.DeathRotDebuff) and (v16:DebuffRemains(v62.DeathRotDebuff) < v14:GCD())))) or ((719 + 973) < (1167 - 579))) then
					if (v20(v62.Epidemic, v56, nil, not v16:IsInRange(158 - 118)) or ((6707 - (716 + 1194)) < (63 + 3588))) then
						return "epidemic high_prio_actions 8";
					end
				end
				v156 = 1 + 2;
			end
			if ((v156 == (506 - (74 + 429))) or ((8057 - 3880) > (2404 + 2446))) then
				if ((v87:IsReady() and ((v62.Apocalypse:CooldownRemains() > (v75 + (6 - 3))) or (v95 >= (3 + 0))) and v62.Plaguebringer:IsAvailable() and (v62.Superstrain:IsAvailable() or v62.UnholyBlight:IsAvailable()) and (v14:BuffRemains(v62.PlaguebringerBuff) < v14:GCD())) or ((1233 - 833) > (2746 - 1635))) then
					if (((3484 - (279 + 154)) > (1783 - (454 + 324))) and v20(v87, nil, nil, not v16:IsSpellInRange(v87))) then
						return "wound_spender high_prio_actions 10";
					end
				end
				if (((2906 + 787) <= (4399 - (12 + 5))) and v62.UnholyBlight:IsReady() and ((v79 and (((not v62.Apocalypse:IsAvailable() or v62.Apocalypse:CooldownDown()) and v62.Morbidity:IsAvailable()) or not v62.Morbidity:IsAvailable())) or v80 or (v92 < (12 + 9)))) then
					if (v20(v62.UnholyBlight, v59, nil, not v16:IsInRange(20 - 12)) or ((1213 + 2069) > (5193 - (277 + 816)))) then
						return "unholy_blight high_prio_actions 12";
					end
				end
				v156 = 17 - 13;
			end
			if ((v156 == (1187 - (1058 + 125))) or ((672 + 2908) < (3819 - (815 + 160)))) then
				if (((381 - 292) < (10658 - 6168)) and v62.Outbreak:IsReady()) then
					if (v71.CastCycle(v62.Outbreak, v94, v114, not v16:IsSpellInRange(v62.Outbreak)) or ((1189 + 3794) < (5285 - 3477))) then
						return "outbreak high_prio_actions 14";
					end
				end
				break;
			end
			if (((5727 - (41 + 1857)) > (5662 - (1222 + 671))) and (v156 == (0 - 0))) then
				v157 = v71.HandleDPSPotion();
				if (((2134 - 649) <= (4086 - (229 + 953))) and v157) then
					return "DPS Pot";
				end
				v156 = 1775 - (1111 + 663);
			end
			if (((5848 - (874 + 705)) == (598 + 3671)) and (v156 == (1 + 0))) then
				if (((803 - 416) <= (79 + 2703)) and v46) then
					local v205 = 679 - (642 + 37);
					while true do
						if ((v205 == (0 + 0)) or ((304 + 1595) <= (2302 - 1385))) then
							if ((v62.AntiMagicShell:IsCastable() and (v14:RunicPowerDeficit() > (494 - (233 + 221))) and (v85 or not v62.SummonGargoyle:IsAvailable() or (v62.SummonGargoyle:CooldownRemains() > (92 - 52)))) or ((3796 + 516) <= (2417 - (718 + 823)))) then
								if (((1405 + 827) <= (3401 - (266 + 539))) and v20(v62.AntiMagicShell, v47)) then
									return "antimagic_shell ams_amz 2";
								end
							end
							if (((5931 - 3836) < (4911 - (636 + 589))) and v62.AntiMagicZone:IsCastable() and (v14:RunicPowerDeficit() > (166 - 96)) and v62.Assimilation:IsAvailable() and (v85 or not v62.SummonGargoyle:IsAvailable())) then
								if (v20(v62.AntiMagicZone, v48) or ((3289 - 1694) >= (3546 + 928))) then
									return "antimagic_zone ams_amz 4";
								end
							end
							break;
						end
					end
				end
				if ((v62.ArmyoftheDead:IsReady() and v30 and ((v62.SummonGargoyle:IsAvailable() and (v62.SummonGargoyle:CooldownRemains() < (1 + 1))) or not v62.SummonGargoyle:IsAvailable() or (v92 < (1050 - (657 + 358))))) or ((12229 - 7610) < (6565 - 3683))) then
					if (v20(v62.ArmyoftheDead) or ((1481 - (1151 + 36)) >= (4666 + 165))) then
						return "army_of_the_dead high_prio_actions 4";
					end
				end
				v156 = 1 + 1;
			end
		end
	end
	local function v124()
		if (((6059 - 4030) <= (4916 - (1552 + 280))) and v62.ArcaneTorrent:IsCastable() and (v14:RunicPowerDeficit() > (854 - (64 + 770))) and ((v62.SummonGargoyle:CooldownRemains() < v14:GCD()) or not v62.SummonGargoyle:IsAvailable() or (v85 and (v14:Rune() < (2 + 0)) and (v90 < (2 - 1))))) then
			if (v20(v62.ArcaneTorrent, v53, nil, not v16:IsInRange(2 + 6)) or ((3280 - (157 + 1086)) == (4843 - 2423))) then
				return "arcane_torrent racials 2";
			end
		end
		if (((19524 - 15066) > (5988 - 2084)) and v62.BloodFury:IsCastable() and ((((v62.BloodFury:BaseDuration() + (3 - 0)) >= v86) and v85) or ((not v62.SummonGargoyle:IsAvailable() or (v62.SummonGargoyle:CooldownRemains() > (879 - (599 + 220)))) and ((v83 and (v84 <= (v62.BloodFury:BaseDuration() + (5 - 2)))) or (v81 and (v82 <= (v62.BloodFury:BaseDuration() + (1934 - (1813 + 118))))) or ((v95 >= (2 + 0)) and v14:BuffUp(v62.DeathAndDecayBuff)))) or (v92 <= (v62.BloodFury:BaseDuration() + (1220 - (841 + 376)))))) then
			if (((610 - 174) >= (29 + 94)) and v20(v62.BloodFury, v53)) then
				return "blood_fury racials 4";
			end
		end
		if (((1364 - 864) < (2675 - (464 + 395))) and v62.Berserking:IsCastable() and ((((v62.Berserking:BaseDuration() + (7 - 4)) >= v86) and v85) or ((not v62.SummonGargoyle:IsAvailable() or (v62.SummonGargoyle:CooldownRemains() > (29 + 31))) and ((v83 and (v84 <= (v62.Berserking:BaseDuration() + (840 - (467 + 370))))) or (v81 and (v82 <= (v62.Berserking:BaseDuration() + (5 - 2)))) or ((v95 >= (2 + 0)) and v14:BuffUp(v62.DeathAndDecayBuff)))) or (v92 <= (v62.Berserking:BaseDuration() + (10 - 7))))) then
			if (((558 + 3016) == (8314 - 4740)) and v20(v62.Berserking, v53)) then
				return "berserking racials 6";
			end
		end
		if (((741 - (150 + 370)) < (1672 - (74 + 1208))) and v62.LightsJudgment:IsCastable() and v14:BuffUp(v62.UnholyStrengthBuff) and (not v62.Festermight:IsAvailable() or (v14:BuffRemains(v62.FestermightBuff) < v16:TimeToDie()) or (v14:BuffRemains(v62.UnholyStrengthBuff) < v16:TimeToDie()))) then
			if (v20(v62.LightsJudgment, v53, nil, not v16:IsSpellInRange(v62.LightsJudgment)) or ((5443 - 3230) <= (6739 - 5318))) then
				return "lights_judgment racials 8";
			end
		end
		if (((2176 + 882) < (5250 - (14 + 376))) and v62.AncestralCall:IsCastable() and ((((30 - 12) >= v86) and v85) or ((not v62.SummonGargoyle:IsAvailable() or (v62.SummonGargoyle:CooldownRemains() > (39 + 21))) and ((v83 and (v84 <= (16 + 2))) or (v81 and (v82 <= (18 + 0))) or ((v95 >= (5 - 3)) and v14:BuffUp(v62.DeathAndDecayBuff)))) or (v92 <= (14 + 4)))) then
			if (v20(v62.AncestralCall, v53) or ((1374 - (23 + 55)) >= (10536 - 6090))) then
				return "ancestral_call racials 10";
			end
		end
		if ((v62.ArcanePulse:IsCastable() and ((v95 >= (2 + 0)) or ((v14:Rune() <= (1 + 0)) and (v14:RunicPowerDeficit() >= (93 - 33))))) or ((439 + 954) > (5390 - (652 + 249)))) then
			if (v20(v62.ArcanePulse, v53, nil, not v16:IsInRange(21 - 13)) or ((6292 - (708 + 1160)) < (73 - 46))) then
				return "arcane_pulse racials 12";
			end
		end
		if ((v62.Fireblood:IsCastable() and ((((v62.Fireblood:BaseDuration() + (5 - 2)) >= v86) and v85) or ((not v62.SummonGargoyle:IsAvailable() or (v62.SummonGargoyle:CooldownRemains() > (87 - (10 + 17)))) and ((v83 and (v84 <= (v62.Fireblood:BaseDuration() + 1 + 2))) or (v81 and (v82 <= (v62.Fireblood:BaseDuration() + (1735 - (1400 + 332))))) or ((v95 >= (3 - 1)) and v14:BuffUp(v62.DeathAndDecayBuff)))) or (v92 <= (v62.Fireblood:BaseDuration() + (1911 - (242 + 1666)))))) or ((855 + 1142) > (1399 + 2416))) then
			if (((2954 + 511) > (2853 - (850 + 90))) and v20(v62.Fireblood, v53)) then
				return "fireblood racials 14";
			end
		end
		if (((1283 - 550) < (3209 - (360 + 1030))) and v62.BagofTricks:IsCastable() and (v95 == (1 + 0)) and (v14:BuffUp(v62.UnholyStrengthBuff) or HL.FilteredFightRemains(v94, "<", 13 - 8))) then
			if (v20(v62.BagofTricks, v53, nil, not v16:IsSpellInRange(v62.BagofTricks)) or ((6046 - 1651) == (6416 - (909 + 752)))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v125()
		local v158 = 1223 - (109 + 1114);
		while true do
			if ((v158 == (1 - 0)) or ((1477 + 2316) < (2611 - (6 + 236)))) then
				if ((v88:IsReady() and v14:BuffDown(v62.DeathAndDecayBuff) and ((v95 >= (2 + 0)) or (v62.UnholyGround:IsAvailable() and ((v81 and (v82 >= (11 + 2))) or (v85 and (v86 > (18 - 10))) or (v83 and (v84 > (13 - 5))) or (not v77 and (v90 >= (1137 - (1076 + 57)))))) or (v62.Defile:IsAvailable() and (v85 or v81 or v83 or v15:BuffUp(v62.DarkTransformation)))) and ((v62.FesteringWoundDebuff:AuraActiveCount() == v95) or (v95 == (1 + 0)))) or ((4773 - (579 + 110)) == (21 + 244))) then
					if (((3854 + 504) == (2313 + 2045)) and v20(v89, v49)) then
						return "any_dnd st 6";
					end
				end
				if ((v87:IsReady() and (v77 or ((v95 >= (409 - (174 + 233))) and v14:BuffUp(v62.DeathAndDecayBuff)))) or ((8765 - 5627) < (1742 - 749))) then
					if (((1481 + 1849) > (3497 - (663 + 511))) and v20(v87, nil, nil, not v16:IsSpellInRange(v87))) then
						return "wound_spender st 8";
					end
				end
				v158 = 2 + 0;
			end
			if ((v158 == (1 + 1)) or ((11178 - 7552) == (2416 + 1573))) then
				if ((v62.FesteringStrike:IsReady() and not v77) or ((2156 - 1240) == (6465 - 3794))) then
					if (((130 + 142) == (529 - 257)) and v71.CastTargetIf(v62.FesteringStrike, v94, "min", v103, v108, not v16:IsInMeleeRange(4 + 1))) then
						return "festering_strike st 10";
					end
				end
				if (((389 + 3860) <= (5561 - (478 + 244))) and v62.DeathCoil:IsReady()) then
					if (((3294 - (440 + 77)) < (1455 + 1745)) and v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil))) then
						return "death_coil st 12";
					end
				end
				v158 = 10 - 7;
			end
			if (((1651 - (655 + 901)) < (363 + 1594)) and (v158 == (3 + 0))) then
				if (((558 + 268) < (6917 - 5200)) and v87:IsReady() and not v77) then
					if (((2871 - (695 + 750)) >= (3773 - 2668)) and v71.CastTargetIf(v87, v94, "max", v103, v109, not v16:IsSpellInRange(v87))) then
						return "wound_spender st 14";
					end
				end
				break;
			end
			if (((4250 - 1496) <= (13589 - 10210)) and (v158 == (351 - (285 + 66)))) then
				if ((v62.DeathCoil:IsReady() and not v73 and ((not v78 and v74) or (v92 < (23 - 13)))) or ((5237 - (682 + 628)) == (228 + 1185))) then
					if (v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil)) or ((1453 - (176 + 123)) <= (330 + 458))) then
						return "death_coil st 2";
					end
				end
				if ((v62.Epidemic:IsReady() and v73 and ((not v78 and v74) or (v92 < (8 + 2)))) or ((1912 - (239 + 30)) > (919 + 2460))) then
					if (v20(v62.Epidemic, v56, nil, not v16:IsInRange(39 + 1)) or ((4960 - 2157) > (14192 - 9643))) then
						return "epidemic st 4";
					end
				end
				v158 = 316 - (306 + 9);
			end
		end
	end
	local function v126()
		if (v34 or ((767 - 547) >= (526 + 2496))) then
			local v164 = v116();
			if (((1732 + 1090) == (1359 + 1463)) and v164) then
				return v164;
			end
		end
	end
	local function v127()
		v73 = (v62.ImprovedDeathCoil:IsAvailable() and not v62.CoilofDevastation:IsAvailable() and (v95 >= (8 - 5))) or (v62.CoilofDevastation:IsAvailable() and (v95 >= (1379 - (1140 + 235)))) or (not v62.ImprovedDeathCoil:IsAvailable() and (v95 >= (2 + 0)));
		v72 = (v95 >= (3 + 0)) or ((v62.SummonGargoyle:CooldownRemains() > (1 + 0)) and ((v62.Apocalypse:CooldownRemains() > (53 - (33 + 19))) or not v62.Apocalypse:IsAvailable())) or not v62.SummonGargoyle:IsAvailable() or (v10.CombatTime() > (8 + 12));
		v75 = ((v62.Apocalypse:CooldownRemains() < (29 - 19)) and (v90 <= (2 + 2)) and (v62.UnholyAssault:CooldownRemains() > (19 - 9)) and (7 + 0)) or (691 - (586 + 103));
		if ((not v85 and v62.Festermight:IsAvailable() and v14:BuffUp(v62.FestermightBuff) and ((v14:BuffRemains(v62.FestermightBuff) / ((1 + 4) * v14:GCD())) >= (2 - 1))) or ((2549 - (1309 + 179)) == (3351 - 1494))) then
			v76 = v90 >= (1 + 0);
		else
			v76 = v90 >= ((7 - 4) - v23(v62.InfectedClaws:IsAvailable()));
		end
		v77 = (((v62.Apocalypse:CooldownRemains() > v75) or not v62.Apocalypse:IsAvailable()) and (v76 or ((v90 >= (1 + 0)) and (v62.UnholyAssault:CooldownRemains() < (42 - 22)) and v62.UnholyAssault:IsAvailable() and v79) or (v16:DebuffUp(v62.RottenTouchDebuff) and (v90 >= (1 - 0))) or (v90 > (613 - (295 + 314))) or (v14:HasTier(76 - 45, 1966 - (1300 + 662)) and (v93:ApocMagusActive() or v93:ArmyMagusActive()) and (v90 >= (3 - 2))))) or ((v92 < (1760 - (1178 + 577))) and (v90 >= (1 + 0)));
		v78 = v62.VileContagion:IsAvailable() and (v62.VileContagion:CooldownRemains() < (8 - 5)) and (v14:RunicPower() < (1465 - (851 + 554))) and not v79;
		v79 = (v95 == (1 + 0)) or not v29;
		v80 = (v95 >= (5 - 3)) and v29;
		v74 = (not v62.RottenTouch:IsAvailable() or (v62.RottenTouch:IsAvailable() and v16:DebuffDown(v62.RottenTouchDebuff)) or (v14:RunicPowerDeficit() < (43 - 23))) and (not v14:HasTier(333 - (115 + 187), 4 + 0) or (v14:HasTier(30 + 1, 15 - 11) and not (v93:ApocMagusActive() or v93:ArmyMagusActive())) or (v14:RunicPowerDeficit() < (1181 - (160 + 1001))) or (v14:Rune() < (3 + 0))) and ((v62.ImprovedDeathCoil:IsAvailable() and ((v95 == (2 + 0)) or v62.CoilofDevastation:IsAvailable())) or (v14:Rune() < (5 - 2)) or v85 or v14:BuffUp(v62.SuddenDoomBuff) or ((v62.Apocalypse:CooldownRemains() < (368 - (237 + 121))) and (v90 > (900 - (525 + 372)))) or (not v77 and (v90 >= (7 - 3))));
	end
	local function v128()
		v61();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v70 = not v100();
		v94 = v14:GetEnemiesInMeleeRange(16 - 11);
		v96 = v16:GetEnemiesInSplashRange(152 - (96 + 46));
		if (((3537 - (643 + 134)) > (493 + 871)) and v29) then
			local v165 = 0 - 0;
			while true do
				if ((v165 == (0 - 0)) or ((4702 + 200) <= (7055 - 3460))) then
					v95 = #v94;
					v97 = v16:GetEnemiesInSplashRangeCount(20 - 10);
					break;
				end
			end
		else
			local v166 = 719 - (316 + 403);
			while true do
				if ((v166 == (0 + 0)) or ((10590 - 6738) == (106 + 187))) then
					v95 = 2 - 1;
					v97 = 1 + 0;
					break;
				end
			end
		end
		if (v71.TargetIsValid() or v14:AffectingCombat() or ((503 + 1056) == (15897 - 11309))) then
			v91 = v10.BossFightRemains();
			v92 = v91;
			if ((v92 == (53064 - 41953)) or ((9314 - 4830) == (46 + 742))) then
				v92 = v10.FightRemains(v94, false);
			end
			v98 = v101(v96);
			v81 = v62.Apocalypse:TimeSinceLastCast() <= (29 - 14);
			v82 = (v81 and ((1 + 14) - v62.Apocalypse:TimeSinceLastCast())) or (0 - 0);
			v83 = v62.ArmyoftheDead:TimeSinceLastCast() <= (47 - (12 + 5));
			v84 = (v83 and ((116 - 86) - v62.ArmyoftheDead:TimeSinceLastCast())) or (0 - 0);
			v85 = v93:GargActive();
			v86 = v93:GargRemains();
			v90 = v16:DebuffStack(v62.FesteringWoundDebuff);
		end
		if (((9710 - 5142) >= (9688 - 5781)) and v71.TargetIsValid()) then
			if (((253 + 993) < (5443 - (1656 + 317))) and not v14:IsCasting() and not v14:IsChanneling()) then
				local v189 = 0 + 0;
				local v190;
				while true do
					if (((3260 + 808) >= (2584 - 1612)) and (v189 == (4 - 3))) then
						v190 = v71.Interrupt(v62.MindFreeze, 369 - (5 + 349), true, v21, v64.MindFreezeMouseover);
						if (((2341 - 1848) < (5164 - (266 + 1005))) and v190) then
							return v190;
						end
						break;
					end
					if (((0 + 0) == v189) or ((5025 - 3552) >= (4386 - 1054))) then
						v190 = v71.Interrupt(v62.MindFreeze, 1711 - (561 + 1135), true);
						if (v190 or ((5278 - 1227) <= (3802 - 2645))) then
							return v190;
						end
						v189 = 1067 - (507 + 559);
					end
				end
			end
			if (((1515 - 911) < (8909 - 6028)) and not v14:AffectingCombat()) then
				local v191 = 388 - (212 + 176);
				local v192;
				while true do
					if ((v191 == (905 - (250 + 655))) or ((2454 - 1554) == (5900 - 2523))) then
						v192 = v115();
						if (((6975 - 2516) > (2547 - (1869 + 87))) and v192) then
							return v192;
						end
						break;
					end
				end
			end
			if (((11785 - 8387) >= (4296 - (484 + 1417))) and v62.DeathStrike:IsReady() and not v70) then
				if (v20(v62.DeathStrike) or ((4678 - 2495) >= (4732 - 1908))) then
					return "death_strike low hp or proc";
				end
			end
			if (((2709 - (48 + 725)) == (3162 - 1226)) and (v95 == (0 - 0))) then
				if ((v62.Outbreak:IsReady() and (v98 > (0 + 0))) or ((12912 - 8080) < (1208 + 3105))) then
					if (((1192 + 2896) > (4727 - (152 + 701))) and v20(v62.Outbreak, nil, nil, not v16:IsSpellInRange(v62.Outbreak))) then
						return "outbreak out_of_range";
					end
				end
				if (((5643 - (430 + 881)) == (1659 + 2673)) and v62.Epidemic:IsReady() and v29 and (v62.VirulentPlagueDebuff:AuraActiveCount() > (896 - (557 + 338))) and not v78) then
					if (((1182 + 2817) >= (8172 - 5272)) and v20(v62.Epidemic, v56, nil, not v16:IsInRange(140 - 100))) then
						return "epidemic out_of_range";
					end
				end
				if ((v62.DeathCoil:IsReady() and (v62.VirulentPlagueDebuff:AuraActiveCount() < (4 - 2)) and not v78) or ((5441 - 2916) > (4865 - (499 + 302)))) then
					if (((5237 - (39 + 827)) == (12066 - 7695)) and v20(v62.DeathCoil, nil, nil, not v16:IsSpellInRange(v62.DeathCoil))) then
						return "death_coil out_of_range";
					end
				end
			end
			v127();
			local v167 = v123();
			if (v167 or ((593 - 327) > (19803 - 14817))) then
				return v167;
			end
			local v167 = v116();
			if (((3056 - 1065) >= (80 + 845)) and v167) then
				return v167;
			end
			if (((1331 - 876) < (329 + 1724)) and v30 and not v72) then
				local v193 = 0 - 0;
				local v194;
				while true do
					if ((v193 == (104 - (103 + 1))) or ((1380 - (475 + 79)) == (10486 - 5635))) then
						v194 = v122();
						if (((585 - 402) == (24 + 159)) and v194) then
							return v194;
						end
						break;
					end
				end
			end
			if (((1021 + 138) <= (3291 - (1395 + 108))) and v30 and v79) then
				local v195 = 0 - 0;
				local v196;
				while true do
					if ((v195 == (1204 - (7 + 1197))) or ((1530 + 1977) > (1507 + 2811))) then
						v196 = v121();
						if (v196 or ((3394 - (27 + 292)) <= (8688 - 5723))) then
							return v196;
						end
						break;
					end
				end
			end
			if (((1740 - 375) <= (8433 - 6422)) and v29 and v30 and v80) then
				local v197 = 0 - 0;
				local v198;
				while true do
					if ((v197 == (0 - 0)) or ((2915 - (43 + 96)) > (14582 - 11007))) then
						v198 = v119();
						if (v198 or ((5773 - 3219) == (3987 + 817))) then
							return v198;
						end
						break;
					end
				end
			end
			if (((728 + 1849) == (5092 - 2515)) and v30) then
				local v199 = 0 + 0;
				local v200;
				while true do
					if ((v199 == (0 - 0)) or ((2 + 4) >= (139 + 1750))) then
						v200 = v124();
						if (((2257 - (1414 + 337)) <= (3832 - (1642 + 298))) and v200) then
							return v200;
						end
						break;
					end
				end
			end
			if (v29 or ((5234 - 3226) > (6380 - 4162))) then
				local v201 = 0 - 0;
				while true do
					if (((125 + 254) <= (3227 + 920)) and ((972 - (357 + 615)) == v201)) then
						if ((v80 and (v88:CooldownRemains() < (8 + 2)) and v14:BuffDown(v62.DeathAndDecayBuff)) or ((11075 - 6561) <= (865 + 144))) then
							local v206 = 0 - 0;
							local v207;
							while true do
								if (((0 + 0) == v206) or ((238 + 3258) == (750 + 442))) then
									v207 = v120();
									if (v207 or ((1509 - (384 + 917)) == (3656 - (128 + 569)))) then
										return v207;
									end
									break;
								end
							end
						end
						if (((5820 - (1407 + 136)) >= (3200 - (687 + 1200))) and (v95 >= (1714 - (556 + 1154))) and v14:BuffUp(v62.DeathAndDecayBuff)) then
							local v208 = 0 - 0;
							local v209;
							while true do
								if (((2682 - (9 + 86)) < (3595 - (275 + 146))) and ((0 + 0) == v208)) then
									v209 = v118();
									if (v209 or ((4184 - (29 + 35)) <= (9741 - 7543))) then
										return v209;
									end
									break;
								end
							end
						end
						v201 = 2 - 1;
					end
					if (((4 - 3) == v201) or ((1040 + 556) == (1870 - (53 + 959)))) then
						if (((3628 - (312 + 96)) == (5588 - 2368)) and (v95 >= (289 - (147 + 138))) and (((v88:CooldownRemains() > (909 - (813 + 86))) and v14:BuffDown(v62.DeathAndDecayBuff)) or not v80)) then
							local v210 = 0 + 0;
							local v211;
							while true do
								if ((v210 == (0 - 0)) or ((1894 - (18 + 474)) > (1222 + 2398))) then
									v211 = v117();
									if (((8401 - 5827) == (3660 - (860 + 226))) and v211) then
										return v211;
									end
									break;
								end
							end
						end
						break;
					end
				end
			end
			if (((2101 - (121 + 182)) < (340 + 2417)) and (v95 <= (1243 - (988 + 252)))) then
				local v202 = 0 + 0;
				local v203;
				while true do
					if ((v202 == (0 + 0)) or ((2347 - (49 + 1921)) > (3494 - (223 + 667)))) then
						v203 = v125();
						if (((620 - (51 + 1)) < (1567 - 656)) and v203) then
							return v203;
						end
						break;
					end
				end
			end
			if (((7034 - 3749) < (5353 - (146 + 979))) and v62.FesteringStrike:IsReady()) then
				if (((1106 + 2810) > (3933 - (311 + 294))) and v20(v62.FesteringStrike, nil, nil)) then
					return "festering_strike precombat 8";
				end
			end
		end
	end
	local function v129()
		local v162 = 0 - 0;
		while true do
			if (((1059 + 1441) < (5282 - (496 + 947))) and (v162 == (1358 - (1233 + 125)))) then
				v62.VirulentPlagueDebuff:RegisterAuraTracking();
				v62.FesteringWoundDebuff:RegisterAuraTracking();
				v162 = 1 + 0;
			end
			if (((455 + 52) == (97 + 410)) and (v162 == (1646 - (963 + 682)))) then
				v10.Print("Unholy DK by Epic. Work in Progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(211 + 41, v128, v129);
end;
return v0["Epix_DeathKnight_Unholy.lua"]();

