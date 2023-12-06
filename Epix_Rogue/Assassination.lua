local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((6971 - 3641) > (381 + 275)) and (v5 == (654 - (232 + 421)))) then
			return v6(...);
		end
		if ((v5 == (1889 - (1569 + 320))) or ((612 + 1880) <= (64 + 271))) then
			v6 = v0[v4];
			if (((14564 - 10242) >= (3167 - (316 + 289))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
	end
end
v0["Epix_Rogue_Assassination.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Macro;
	local v20 = v10.Press;
	local v21 = v10.Commons.Everyone.num;
	local v22 = v10.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = v10.Press;
	local v30 = pairs;
	local v31 = math.floor;
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
	local function v73()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (1456 - (666 + 787))) or ((4062 - (360 + 65)) >= (3524 + 246))) then
				v56 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v57 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v58 = EpicSettings.Settings['ColdBloodOffGCD'];
				v59 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v60 = EpicSettings.Settings['CrimsonVialHP'] or (255 - (79 + 175));
				v61 = EpicSettings.Settings['FeintHP'] or (1 - 0);
				v137 = 4 + 0;
			end
			if ((v137 == (5 - 3)) or ((4581 - 2202) > (5477 - (503 + 396)))) then
				v46 = EpicSettings.Settings['UsePriorityRotation'];
				v51 = EpicSettings.Settings['STMfDAsDPSCD'];
				v52 = EpicSettings.Settings['KidneyShotInterrupt'];
				v53 = EpicSettings.Settings['RacialsGCD'];
				v54 = EpicSettings.Settings['RacialsOffGCD'];
				v55 = EpicSettings.Settings['VanishOffGCD'];
				v137 = 184 - (92 + 89);
			end
			if ((v137 == (9 - 4)) or ((248 + 235) > (440 + 303))) then
				v68 = EpicSettings.Settings['KingsbaneGCD'];
				v69 = EpicSettings.Settings['ShivGCD'];
				v70 = EpicSettings.Settings['DeathmarkOffGCD'];
				v72 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v71 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
			if (((9610 - 7156) > (80 + 498)) and (v137 == (0 - 0))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v137 = 1 + 0;
			end
			if (((1418 - 488) < (5702 - (485 + 759))) and (v137 == (8 - 4))) then
				v62 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['EnvenomDMGOffset'] or (1190 - (442 + 747));
				v64 = EpicSettings.Settings['MutilateDMGOffset'] or (1136 - (832 + 303));
				v65 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v66 = EpicSettings.Settings['PotionTypeSelected'];
				v67 = EpicSettings.Settings['ExsanguinateGCD'];
				v137 = 951 - (88 + 858);
			end
			if (((202 + 460) <= (805 + 167)) and (v137 == (1 + 0))) then
				v39 = EpicSettings.Settings['InterruptWithStun'] or (789 - (766 + 23));
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v43 = EpicSettings.Settings['PoisonRefresh'];
				v44 = EpicSettings.Settings['PoisonRefreshCombat'];
				v45 = EpicSettings.Settings['RangedMultiDoT'];
				v137 = 4 - 2;
			end
		end
	end
	local v74 = v10.Commons.Everyone;
	local v75 = v10.Commons.Rogue;
	local v76 = v16.Rogue.Assassination;
	local v77 = v19.Rogue.Assassination;
	local v78 = v18.Rogue.Assassination;
	local v79 = {v78.AlgetharPuzzleBox,v78.AshesoftheEmbersoul,v78.WitherbarksBranch};
	local v80, v81, v82, v83;
	local v84, v85, v86, v87;
	local v88;
	local v89, v90 = (3 - 1) * v14:SpellHaste(), (1 + 0) * v14:SpellHaste();
	local v91, v92;
	local v93, v94, v95, v96, v97, v98, v99;
	local v100;
	local v101, v102, v103, v104, v105, v106, v107, v108;
	local v109 = 1480 - (641 + 839);
	local v110 = v14:GetEquipment();
	local v111 = (v110[926 - (910 + 3)] and v18(v110[32 - 19])) or v18(1684 - (1466 + 218));
	local v112 = (v110[7 + 7] and v18(v110[1162 - (556 + 592)])) or v18(0 + 0);
	local function v113()
		if (((5178 - (329 + 479)) == (5224 - (174 + 680))) and v111:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v111:Cooldown() >= v112:Cooldown()))) then
			v109 = 3 - 2;
		elseif ((v112:HasStatAnyDps() and (not v111:HasStatAnyDps() or (v112:Cooldown() > v111:Cooldown()))) or ((9869 - 5107) <= (615 + 246))) then
			v109 = 741 - (396 + 343);
		else
			v109 = 0 + 0;
		end
	end
	v113();
	v10:RegisterForEvent(function()
		local v138 = 1477 - (29 + 1448);
		while true do
			if ((v138 == (1390 - (135 + 1254))) or ((5319 - 3907) == (19909 - 15645))) then
				v112 = (v110[10 + 4] and v18(v110[1541 - (389 + 1138)])) or v18(574 - (102 + 472));
				v113();
				break;
			end
			if ((v138 == (0 + 0)) or ((1757 + 1411) < (2008 + 145))) then
				v110 = v14:GetEquipment();
				v111 = (v110[1558 - (320 + 1225)] and v18(v110[22 - 9])) or v18(0 + 0);
				v138 = 1465 - (157 + 1307);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v114 = {{v76.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v76.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v91 > (0 + 0);
	end}};
	v76.Envenom:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v91 * (0.22 + 0) * (1 - 0) * ((v15:DebuffUp(v76.ShivDebuff) and (305.3 - (300 + 4))) or (1 + 0)) * ((v76.DeeperStratagem:IsAvailable() and (2.05 - 1)) or (363 - (112 + 250))) * (1 + 0 + (v14:MasteryPct() / (250 - 150))) * (1 + 0 + (v14:VersatilityDmgPct() / (52 + 48)));
	end);
	v76.Mutilate:RegisterDamageFormula(function()
		return (v14:AttackPowerDamageMod() + v14:AttackPowerDamageMod(true)) * (0.485 + 0) * (1 + 0) * (1 + 0 + (v14:VersatilityDmgPct() / (1514 - (1001 + 413))));
	end);
	local function v115()
		return v14:BuffRemains(v76.MasterAssassinBuff) == (22297 - 12298);
	end
	local function v116()
		if (v115() or ((5858 - (244 + 638)) < (2025 - (627 + 66)))) then
			return v14:GCDRemains() + (8 - 5);
		end
		return v14:BuffRemains(v76.MasterAssassinBuff);
	end
	local function v117()
		local v139 = 602 - (512 + 90);
		while true do
			if (((6534 - (1665 + 241)) == (5345 - (373 + 344))) and (v139 == (0 + 0))) then
				if (v14:BuffUp(v76.ImprovedGarroteAura) or ((15 + 39) == (1041 - 646))) then
					return v14:GCDRemains() + (4 - 1);
				end
				return v14:BuffRemains(v76.ImprovedGarroteBuff);
			end
		end
	end
	local function v118()
		local v140 = 1099 - (35 + 1064);
		while true do
			if (((60 + 22) == (175 - 93)) and (v140 == (0 + 0))) then
				if (v14:BuffUp(v76.IndiscriminateCarnageAura) or ((1817 - (298 + 938)) < (1541 - (233 + 1026)))) then
					return v14:GCDRemains() + (1676 - (636 + 1030));
				end
				return v14:BuffRemains(v76.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v46()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (0 + 0)) or ((1370 + 3239) < (169 + 2326))) then
				if (((1373 - (55 + 166)) == (224 + 928)) and (v86 < (1 + 1))) then
					return false;
				elseif (((7240 - 5344) <= (3719 - (36 + 261))) and (v46 == "Always")) then
					return true;
				elseif (((v46 == "On Bosses") and v15:IsInBossList()) or ((1731 - 741) > (2988 - (34 + 1334)))) then
					return true;
				elseif ((v46 == "Auto") or ((338 + 539) > (3648 + 1047))) then
					if (((3974 - (1035 + 248)) >= (1872 - (20 + 1))) and (v14:InstanceDifficulty() == (9 + 7)) and (v15:NPCID() == (139286 - (134 + 185)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v119()
		local v142 = 1133 - (549 + 584);
		while true do
			if (((685 - (314 + 371)) == v142) or ((10247 - 7262) >= (5824 - (478 + 490)))) then
				if (((2266 + 2010) >= (2367 - (786 + 386))) and (v15:DebuffUp(v76.Deathmark) or v15:DebuffUp(v76.Kingsbane) or v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.ShivDebuff) or (v76.ThistleTea:FullRechargeTime() < (64 - 44)) or (v14:EnergyPercentage() >= (1459 - (1055 + 324))) or (v14:HasTier(1371 - (1093 + 247), 4 + 0) and ((v14:BuffUp(v76.Envenom) and (v14:BuffRemains(v76.Envenom) <= (1 + 1))) or v10.BossFilteredFightRemains("<=", 357 - 267))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v120()
		local v143 = 0 - 0;
		while true do
			if (((9196 - 5964) <= (11785 - 7095)) and (v143 == (0 + 0))) then
				if (((v76.Deathmark:CooldownRemains() > v76.Sepsis:CooldownRemains()) and (v10.BossFightRemainsIsNotValid() or v10.BossFilteredFightRemains(">", v76.Deathmark:CooldownRemains()))) or ((3451 - 2555) >= (10843 - 7697))) then
					return v76.Deathmark:CooldownRemains();
				end
				return v76.Sepsis:CooldownRemains();
			end
		end
	end
	local function v121()
		local v144 = 0 + 0;
		while true do
			if (((7828 - 4767) >= (3646 - (364 + 324))) and (v144 == (0 - 0))) then
				if (((7647 - 4460) >= (214 + 430)) and not v76.ScentOfBlood:IsAvailable()) then
					return true;
				end
				return v14:BuffStack(v76.ScentOfBloodBuff) >= v23(83 - 63, v76.ScentOfBlood:TalentRank() * (2 - 0) * v86);
			end
		end
	end
	local function v122(v145, v146, v147)
		local v148 = 0 - 0;
		local v147;
		while true do
			if (((1912 - (1249 + 19)) <= (636 + 68)) and (v148 == (0 - 0))) then
				v147 = v147 or v146:PandemicThreshold();
				return v145:DebuffRefreshable(v146, v147);
			end
		end
	end
	local function v123(v149, v150, v151, v152)
		local v153, v154 = nil, v151;
		local v155 = v15:GUID();
		for v177, v178 in v30(v152) do
			if (((2044 - (686 + 400)) > (744 + 203)) and (v178:GUID() ~= v155) and v74.UnitIsCycleValid(v178, v154, -v178:DebuffRemains(v149)) and v150(v178)) then
				v153, v154 = v178, v178:TimeToDie();
			end
		end
		if (((4721 - (73 + 156)) >= (13 + 2641)) and v153) then
			v20(v153, v149);
		elseif (((4253 - (721 + 90)) >= (17 + 1486)) and v45) then
			v153, v154 = nil, v151;
			for v220, v221 in v30(v85) do
				if (((v221:GUID() ~= v155) and v74.UnitIsCycleValid(v221, v154, -v221:DebuffRemains(v149)) and v150(v221)) or ((10292 - 7122) <= (1934 - (224 + 246)))) then
					v153, v154 = v221, v221:TimeToDie();
				end
			end
			if (v153 or ((7770 - 2973) == (8078 - 3690))) then
				v20(v153, v149);
			end
		end
	end
	local function v124(v156, v157, v158)
		local v159 = v157(v15);
		if (((100 + 451) <= (17 + 664)) and (v156 == "first") and (v159 ~= (0 + 0))) then
			return v15;
		end
		local v160, v161 = nil, 0 - 0;
		local function v162(v179)
			for v181, v182 in v30(v179) do
				local v183 = 0 - 0;
				local v184;
				while true do
					if (((3790 - (203 + 310)) > (2400 - (1238 + 755))) and (v183 == (0 + 0))) then
						v184 = v157(v182);
						if (((6229 - (709 + 825)) >= (2607 - 1192)) and not v160 and (v156 == "first")) then
							if ((v184 ~= (0 - 0)) or ((4076 - (196 + 668)) <= (3726 - 2782))) then
								v160, v161 = v182, v184;
							end
						elseif ((v156 == "min") or ((6413 - 3317) <= (2631 - (171 + 662)))) then
							if (((3630 - (4 + 89)) == (12397 - 8860)) and (not v160 or (v184 < v161))) then
								v160, v161 = v182, v184;
							end
						elseif (((1398 + 2439) >= (6895 - 5325)) and (v156 == "max")) then
							if (not v160 or (v184 > v161) or ((1157 + 1793) == (5298 - (35 + 1451)))) then
								v160, v161 = v182, v184;
							end
						end
						v183 = 1454 - (28 + 1425);
					end
					if (((6716 - (941 + 1052)) >= (2223 + 95)) and (v183 == (1515 - (822 + 692)))) then
						if ((v160 and (v184 == v161) and (v182:TimeToDie() > v160:TimeToDie())) or ((2893 - 866) > (1344 + 1508))) then
							v160, v161 = v182, v184;
						end
						break;
					end
				end
			end
		end
		v162(v87);
		if (v45 or ((1433 - (45 + 252)) > (4272 + 45))) then
			v162(v85);
		end
		if (((1635 + 3113) == (11555 - 6807)) and v160 and (v161 == v159) and v158(v15)) then
			return v15;
		end
		if (((4169 - (114 + 319)) <= (6805 - 2065)) and v160 and v158(v160)) then
			return v160;
		end
		return nil;
	end
	local function v125(v163, v164, v165)
		local v166 = 0 - 0;
		local v167;
		while true do
			if ((v166 == (0 + 0)) or ((5050 - 1660) <= (6411 - 3351))) then
				v167 = v15:TimeToDie();
				if (not v10.BossFightRemainsIsNotValid() or ((2962 - (556 + 1407)) > (3899 - (741 + 465)))) then
					v167 = v10.BossFightRemains();
				elseif (((928 - (170 + 295)) < (317 + 284)) and (v167 < v165)) then
					return false;
				end
				v166 = 1 + 0;
			end
			if ((v166 == (2 - 1)) or ((1810 + 373) < (441 + 246))) then
				if (((2576 + 1973) == (5779 - (957 + 273))) and (v31((v167 - v165) / v163) > v31(((v167 - v165) - v164) / v163))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v126(v168)
		local v169 = 0 + 0;
		while true do
			if (((1871 + 2801) == (17802 - 13130)) and (v169 == (0 - 0))) then
				if (v168:DebuffUp(v76.SerratedBoneSpikeDebuff) or ((11203 - 7535) < (1955 - 1560))) then
					return 1001780 - (389 + 1391);
				end
				return v168:TimeToDie();
			end
		end
	end
	local function v127(v170)
		return not v170:DebuffUp(v76.SerratedBoneSpikeDebuff);
	end
	local function v128()
		if (v76.BloodFury:IsCastable() or ((2614 + 1552) == (48 + 407))) then
			if (v10.Press(v76.BloodFury, v54) or ((10128 - 5679) == (3614 - (783 + 168)))) then
				return "Cast Blood Fury";
			end
		end
		if (v76.Berserking:IsCastable() or ((14354 - 10077) < (2941 + 48))) then
			if (v10.Press(v76.Berserking, v54) or ((1181 - (309 + 2)) >= (12740 - 8591))) then
				return "Cast Berserking";
			end
		end
		if (((3424 - (1090 + 122)) < (1032 + 2151)) and v76.Fireblood:IsCastable()) then
			if (((15603 - 10957) > (2048 + 944)) and v10.Press(v76.Fireblood, v54)) then
				return "Cast Fireblood";
			end
		end
		if (((2552 - (628 + 490)) < (557 + 2549)) and v76.AncestralCall:IsCastable()) then
			if (((1945 - 1159) < (13815 - 10792)) and ((not v76.Kingsbane:IsAvailable() and v15:DebuffUp(v76.ShivDebuff)) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (782 - (431 + 343)))))) then
				if (v10.Press(v76.AncestralCall, v54) or ((4931 - 2489) < (213 - 139))) then
					return "Cast Ancestral Call";
				end
			end
		end
		return false;
	end
	local function v129()
		local v171 = 0 + 0;
		while true do
			if (((581 + 3954) == (6230 - (556 + 1139))) and (v171 == (15 - (6 + 9)))) then
				if ((v76.ShadowDance:IsCastable() and not v76.Kingsbane:IsAvailable()) or ((551 + 2458) <= (1079 + 1026))) then
					if (((1999 - (28 + 141)) < (1422 + 2247)) and v76.ImprovedGarrote:IsAvailable() and v76.Garrote:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= (1 - 0)) or v122(v15, v76.Garrote)) and (v76.Deathmark:AnyDebuffUp() or (v76.Deathmark:CooldownRemains() < (9 + 3)) or (v76.Deathmark:CooldownRemains() > (1377 - (486 + 831)))) and (v92 >= math.min(v86, 10 - 6))) then
						local v238 = 0 - 0;
						while true do
							if ((v238 == (0 + 0)) or ((4521 - 3091) >= (4875 - (668 + 595)))) then
								if (((2415 + 268) >= (497 + 1963)) and v50 and (v14:EnergyPredicted() < (122 - 77))) then
									if (v20(v76.PoolEnergy) or ((2094 - (23 + 267)) >= (5219 - (1129 + 815)))) then
										return "Pool for Shadow Dance (Garrote)";
									end
								end
								if (v20(v76.ShadowDance, v56) or ((1804 - (371 + 16)) > (5379 - (1326 + 424)))) then
									return "Cast Shadow Dance (Garrote)";
								end
								break;
							end
						end
					end
					if (((9081 - 4286) > (1468 - 1066)) and not v76.ImprovedGarrote:IsAvailable() and v76.MasterAssassin:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > (121 - (88 + 30))) and (v15:DebuffUp(v76.Deathmark) or (v76.Deathmark:CooldownRemains() > (831 - (720 + 51)))) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < (8 - 4)) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < (1779 - (421 + 1355)))) then
						if (((7940 - 3127) > (1752 + 1813)) and v20(v76.ShadowDance, v56)) then
							return "Cast Shadow Dance (Master Assassin)";
						end
					end
				end
				if (((4995 - (286 + 797)) == (14300 - 10388)) and v76.Vanish:IsCastable() and not v14:IsTanking(v15)) then
					local v222 = 0 - 0;
					while true do
						if (((3260 - (397 + 42)) <= (1507 + 3317)) and (v222 == (801 - (24 + 776)))) then
							if (((2677 - 939) <= (2980 - (222 + 563))) and not v76.ImprovedGarrote:IsAvailable() and v76.MasterAssassin:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > (6 - 3)) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < (3 + 1)) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < (193 - (23 + 167)))) then
								if (((1839 - (690 + 1108)) <= (1089 + 1929)) and v20(v76.Vanish, v55)) then
									return "Cast Vanish (Master Assassin)";
								end
							end
							break;
						end
						if (((1770 + 375) <= (4952 - (40 + 808))) and (v222 == (0 + 0))) then
							if (((10282 - 7593) < (4631 + 214)) and v76.ImprovedGarrote:IsAvailable() and not v76.MasterAssassin:IsAvailable() and v76.Garrote:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or v122(v15, v76.Garrote))) then
								local v245 = 0 + 0;
								while true do
									if ((v245 == (571 - (47 + 524))) or ((1507 + 815) > (7167 - 4545))) then
										if ((not v76.IndiscriminateCarnage:IsAvailable() and (v76.Deathmark:AnyDebuffUp() or (v76.Deathmark:CooldownRemains() < (5 - 1))) and (v92 >= v23(v86, 8 - 4))) or ((6260 - (1165 + 561)) == (62 + 2020))) then
											if ((v50 and (v14:EnergyPredicted() < (139 - 94))) or ((600 + 971) > (2346 - (341 + 138)))) then
												if (v20(v76.PoolEnergy) or ((717 + 1937) >= (6182 - 3186))) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (((4304 - (89 + 237)) > (6768 - 4664)) and v20(v76.Vanish, v55)) then
												return "Cast Vanish (Garrote Deathmark)";
											end
										end
										if (((6305 - 3310) > (2422 - (581 + 300))) and v76.IndiscriminateCarnage:IsAvailable() and (v86 > (1222 - (855 + 365)))) then
											local v253 = 0 - 0;
											while true do
												if (((1061 + 2188) > (2188 - (1030 + 205))) and ((0 + 0) == v253)) then
													if ((v50 and (v14:EnergyPredicted() < (42 + 3))) or ((3559 - (156 + 130)) > (10390 - 5817))) then
														if (v20(v76.PoolEnergy) or ((5310 - 2159) < (2629 - 1345))) then
															return "Pool for Vanish (Garrote Deathmark)";
														end
													end
													if (v20(v76.Vanish, v55) or ((488 + 1362) == (892 + 637))) then
														return "Cast Vanish (Garrote Cleave)";
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if (((890 - (10 + 59)) < (601 + 1522)) and v76.MasterAssassin:IsAvailable() and v76.Kingsbane:IsAvailable() and v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) <= (14 - 11)) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffRemains(v76.Deathmark) <= (1166 - (671 + 492)))) then
								if (((719 + 183) < (3540 - (369 + 846))) and v20(v76.Vanish, v55)) then
									return "Cast Vanish (Kingsbane)";
								end
							end
							v222 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		v88 = v74.HandleTopTrinket(v79, v28, 35 + 5, nil);
		if (((2803 - (1036 + 909)) <= (2356 + 606)) and v88) then
			return v88;
		end
		v88 = v74.HandleBottomTrinket(v79, v28, 67 - 27, nil);
		if (v88 or ((4149 - (11 + 192)) < (651 + 637))) then
			return v88;
		end
	end
	local function v131()
		if ((v76.Sepsis:IsReady() and (v15:DebuffRemains(v76.Rupture) > (195 - (135 + 40))) and ((not v76.ImprovedGarrote:IsAvailable() and v15:DebuffUp(v76.Garrote)) or (v76.ImprovedGarrote:IsAvailable() and v76.Garrote:CooldownUp() and (v15:PMultiplier(v76.Garrote) <= (2 - 1)))) and (v15:FilteredTimeToDie(">", 7 + 3) or v10.BossFilteredFightRemains("<=", 22 - 12))) or ((4859 - 1617) == (743 - (50 + 126)))) then
			if (v20(v76.Sepsis, nil, true) or ((2358 - 1511) >= (280 + 983))) then
				return "Cast Sepsis";
			end
		end
		v88 = v130();
		if (v88 or ((3666 - (1233 + 180)) == (2820 - (522 + 447)))) then
			return v88;
		end
		local v172 = not v14:StealthUp(true, false) and v15:DebuffUp(v76.Rupture) and v14:BuffUp(v76.Envenom) and not v76.Deathmark:AnyDebuffUp() and (not v76.MasterAssassin:IsAvailable() or v15:DebuffUp(v76.Garrote)) and (not v76.Kingsbane:IsAvailable() or (v76.Kingsbane:CooldownRemains() <= (1423 - (107 + 1314))));
		if ((v76.Deathmark:IsCastable() and (v172 or v10.BossFilteredFightRemains("<=", 10 + 10))) or ((6359 - 4272) > (1008 + 1364))) then
			if (v20(v76.Deathmark) or ((8826 - 4381) < (16415 - 12266))) then
				return "Cast Deathmark";
			end
		end
		if ((v76.Shiv:IsReady() and not v15:DebuffUp(v76.ShivDebuff) and v15:DebuffUp(v76.Garrote) and v15:DebuffUp(v76.Rupture)) or ((3728 - (716 + 1194)) == (2 + 83))) then
			local v185 = 0 + 0;
			while true do
				if (((1133 - (74 + 429)) < (4102 - 1975)) and (v185 == (0 + 0))) then
					if (v10.BossFilteredFightRemains("<=", v76.Shiv:Charges() * (18 - 10)) or ((1372 + 566) == (7750 - 5236))) then
						if (((10520 - 6265) >= (488 - (279 + 154))) and v20(v76.Shiv)) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if (((3777 - (454 + 324)) > (910 + 246)) and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom)) then
						local v239 = 17 - (12 + 5);
						while true do
							if (((1268 + 1082) > (2942 - 1787)) and (v239 == (0 + 0))) then
								if (((5122 - (277 + 816)) <= (20737 - 15884)) and not v76.LightweightShiv:IsAvailable() and ((v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (1191 - (1058 + 125)))) or (v76.Kingsbane:CooldownRemains() >= (5 + 19))) and (not v76.CrimsonTempest:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest))) then
									if (v20(v76.Shiv) or ((1491 - (815 + 160)) > (14733 - 11299))) then
										return "Cast Shiv (Kingsbane)";
									end
								end
								if (((9604 - 5558) >= (724 + 2309)) and v76.LightweightShiv:IsAvailable() and (v15:DebuffUp(v76.Kingsbane) or (v76.Kingsbane:CooldownRemains() <= (2 - 1)))) then
									if (v20(v76.Shiv) or ((4617 - (41 + 1857)) <= (3340 - (1222 + 671)))) then
										return "Cast Shiv (Kingsbane Lightweight)";
									end
								end
								break;
							end
						end
					end
					v185 = 2 - 1;
				end
				if ((v185 == (1 - 0)) or ((5316 - (229 + 953)) < (5700 - (1111 + 663)))) then
					if ((v76.ArterialPrecision:IsAvailable() and v76.Deathmark:AnyDebuffUp()) or ((1743 - (874 + 705)) >= (390 + 2395))) then
						if (v20(v76.Shi) or ((359 + 166) == (4383 - 2274))) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if (((1 + 32) == (712 - (642 + 37))) and not v76.Kingsbane:IsAvailable() and not v76.ArterialPrecision:IsAvailable()) then
						if (((697 + 2357) <= (643 + 3372)) and v76.Sepsis:IsAvailable()) then
							if (((4697 - 2826) < (3836 - (233 + 221))) and (((v76.Shiv:ChargesFractional() > ((0.9 - 0) + v21(v76.LightweightShiv:IsAvailable()))) and (v102 > (5 + 0))) or v15:DebuffUp(v76.Sepsis) or v15:DebuffUp(v76.Deathmark))) then
								if (((2834 - (718 + 823)) <= (1363 + 803)) and v20(v76.Shiv)) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (not v76.CrimsonTempest:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest) or ((3384 - (266 + 539)) < (347 - 224))) then
							if (v20(v76.Shiv) or ((2071 - (636 + 589)) >= (5620 - 3252))) then
								return "Cast Shiv";
							end
						end
					end
					break;
				end
			end
		end
		if ((v76.ShadowDance:IsCastable() and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom) and ((v76.Deathmark:CooldownRemains() >= (103 - 53)) or v172)) or ((3180 + 832) <= (1220 + 2138))) then
			if (((2509 - (657 + 358)) <= (7956 - 4951)) and v20(v76.ShadowDance)) then
				return "Cast Shadow Dance (Kingsbane Sync)";
			end
		end
		if ((v76.Kingsbane:IsReady() and (v15:DebuffUp(v76.ShivDebuff) or (v76.Shiv:CooldownRemains() < (13 - 7))) and v14:BuffUp(v76.Envenom) and ((v76.Deathmark:CooldownRemains() >= (1237 - (1151 + 36))) or v15:DebuffUp(v76.Deathmark))) or ((3005 + 106) == (562 + 1572))) then
			if (((7032 - 4677) == (4187 - (1552 + 280))) and v20(v76.Kingsbane)) then
				return "Cast Kingsbane";
			end
		end
		if ((v76.ThistleTea:IsCastable() and not v14:BuffUp(v76.ThistleTea) and (((v14:EnergyDeficit() >= ((934 - (64 + 770)) + v104)) and (not v76.Kingsbane:IsAvailable() or (v76.ThistleTea:Charges() >= (2 + 0)))) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (13 - 7))) or (not v76.Kingsbane:IsAvailable() and v76.Deathmark:AnyDebuffUp()) or v10.BossFilteredFightRemains("<", v76.ThistleTea:Charges() * (2 + 4)))) or ((1831 - (157 + 1086)) <= (864 - 432))) then
			if (((21009 - 16212) >= (5974 - 2079)) and v10.Cast(v76.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((4882 - 1305) == (4396 - (599 + 220))) and v76.Deathmark:AnyDebuffUp() and (not v88 or v54)) then
			if (((7555 - 3761) > (5624 - (1813 + 118))) and v88) then
				v128();
			else
				v88 = v128();
			end
		end
		if ((not v14:StealthUp(true, true) and (v117() <= (0 + 0)) and (v116() <= (1217 - (841 + 376)))) or ((1786 - 511) == (953 + 3147))) then
			if (v88 or ((4342 - 2751) >= (4439 - (464 + 395)))) then
				v129();
			else
				v88 = v129();
			end
		end
		if (((2522 - 1539) <= (869 + 939)) and v76.ColdBlood:IsReady() and v14:DebuffDown(v76.ColdBlood) and (v91 >= (841 - (467 + 370)))) then
			if (v10.Press(v76.ColdBlood) or ((4443 - 2293) <= (879 + 318))) then
				return "Cast Cold Blood";
			end
		end
		return v88;
	end
	local function v132()
		local v173 = 0 - 0;
		while true do
			if (((589 + 3180) >= (2728 - 1555)) and (v173 == (522 - (150 + 370)))) then
				if (((2767 - (74 + 1208)) == (3652 - 2167)) and (v91 >= (18 - 14)) and (v15:PMultiplier(v76.Rupture) <= (1 + 0)) and (v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.Deathmark))) then
					if (v20(v76.Rupture, nil, nil, not v82) or ((3705 - (14 + 376)) <= (4825 - 2043))) then
						return "Cast Rupture (Nightstalker)";
					end
				end
				break;
			end
			if ((v173 == (1 + 0)) or ((770 + 106) >= (2827 + 137))) then
				if ((v27 and v76.CrimsonTempest:IsReady() and v76.Nightstalker:IsAvailable() and (v86 >= (8 - 5)) and (v91 >= (4 + 0)) and not v76.Deathmark:IsReady()) or ((2310 - (23 + 55)) > (5917 - 3420))) then
					for v235, v236 in v30(v85) do
						if ((v122(v236, v76.CrimsonTempest, v94) and v236:FilteredTimeToDie(">", 5 + 1, -v236:DebuffRemains(v76.CrimsonTempest))) or ((1895 + 215) <= (514 - 182))) then
							if (((1160 + 2526) > (4073 - (652 + 249))) and v20(v76.CrimsonTempest)) then
								return "Cast Crimson Tempest (Stealth)";
							end
						end
					end
				end
				if ((v76.Garrote:IsCastable() and (v117() > (0 - 0))) or ((6342 - (708 + 1160)) < (2225 - 1405))) then
					local v223 = 0 - 0;
					local v224;
					local v225;
					while true do
						if (((4306 - (10 + 17)) >= (648 + 2234)) and (v223 == (1732 - (1400 + 332)))) then
							v224 = nil;
							function v224(v241)
								return v241:DebuffRemains(v76.Garrote);
							end
							v223 = 1 - 0;
						end
						if ((v223 == (1911 - (242 + 1666))) or ((869 + 1160) >= (1291 + 2230))) then
							if ((v92 >= (1 + 0 + ((942 - (850 + 90)) * v21(v76.ShroudedSuffocation:IsAvailable())))) or ((3567 - 1530) >= (6032 - (360 + 1030)))) then
								if (((1523 + 197) < (12582 - 8124)) and v14:BuffDown(v76.ShadowDanceBuff) and ((v15:PMultiplier(v76.Garrote) <= (1 - 0)) or (v15:DebuffUp(v76.Deathmark) and (v116() < (1664 - (909 + 752)))))) then
									if (v20(v76.Garrote, nil, nil, not v82) or ((1659 - (109 + 1114)) > (5530 - 2509))) then
										return "Cast Garrote (Improved Garrote Low CP)";
									end
								end
								if (((278 + 435) <= (1089 - (6 + 236))) and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or (v15:DebuffRemains(v76.Garrote) < (10 + 2)))) then
									if (((5079 - 2925) <= (7040 - 3009)) and v20(v76.Garrote, nil, nil, not v82)) then
										return "Cast Garrote (Improved Garrote Low CP 2)";
									end
								end
							end
							break;
						end
						if (((5748 - (1076 + 57)) == (759 + 3856)) and (v223 == (691 - (579 + 110)))) then
							if (v27 or ((300 + 3490) == (443 + 57))) then
								local v246 = 0 + 0;
								local v247;
								while true do
									if (((496 - (174 + 233)) < (617 - 396)) and (v246 == (0 - 0))) then
										v247 = v124("min", v224, v225);
										if (((914 + 1140) >= (2595 - (663 + 511))) and v247 and (v247:GUID() ~= v15:GUID())) then
											v20(v247, v76.Garrote);
										end
										break;
									end
								end
							end
							if (((618 + 74) < (664 + 2394)) and v225(v15)) then
								if (v20(v76.Garrote, nil, nil, not v82) or ((10031 - 6777) == (1003 + 652))) then
									return "Cast Garrote (Improved Garrote)";
								end
							end
							v223 = 6 - 3;
						end
						if (((2 - 1) == v223) or ((619 + 677) == (9556 - 4646))) then
							v225 = nil;
							function v225(v242)
								return ((v242:PMultiplier(v76.Garrote) <= (1 + 0)) or (v242:DebuffRemains(v76.Garrote) < ((2 + 10) / v75.ExsanguinatedRate(v242, v76.Garrote))) or ((v118() > (722 - (478 + 244))) and (v76.Garrote:AuraActiveCount() < v86))) and not v107 and (v242:FilteredTimeToDie(">", 519 - (440 + 77), -v242:DebuffRemains(v76.Garrote)) or v242:TimeToDieIsNotValid()) and v75.CanDoTUnit(v242, v96);
							end
							v223 = 1 + 1;
						end
					end
				end
				v173 = 7 - 5;
			end
			if (((4924 - (655 + 901)) == (625 + 2743)) and (v173 == (0 + 0))) then
				if (((1785 + 858) < (15369 - 11554)) and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom)) then
					local v226 = 1445 - (695 + 750);
					while true do
						if (((6531 - 4618) > (760 - 267)) and (v226 == (0 - 0))) then
							if (((5106 - (285 + 66)) > (7990 - 4562)) and v76.Shiv:IsReady() and (v15:DebuffUp(v76.Kingsbane) or v76.Kingsbane:CooldownUp()) and v15:DebuffDown(v76.ShivDebuff)) then
								if (((2691 - (682 + 628)) <= (382 + 1987)) and v20(v76.Shiv)) then
									return "Cast Shiv (Stealth Kingsbane)";
								end
							end
							if ((v76.Kingsbane:IsReady() and (v14:BuffRemains(v76.ShadowDanceBuff) >= (301 - (176 + 123)))) or ((2026 + 2817) == (2963 + 1121))) then
								if (((4938 - (239 + 30)) > (99 + 264)) and v20(v76.Kingsbane, v68)) then
									return "Cast Kingsbane (Dance)";
								end
							end
							break;
						end
					end
				end
				if ((v91 >= (4 + 0)) or ((3322 - 1445) >= (9790 - 6652))) then
					if (((5057 - (306 + 9)) >= (12653 - 9027)) and v15:DebuffUp(v76.Kingsbane) and (v14:BuffRemains(v76.Envenom) <= (1 + 1))) then
						if (v20(v76.Envenom, nil, nil, not v82) or ((2786 + 1754) == (441 + 475))) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if ((v107 and v115() and v14:BuffDown(v76.ShadowDanceBuff)) or ((3305 - 2149) > (5720 - (1140 + 235)))) then
						if (((1424 + 813) < (3897 + 352)) and v20(v76.Envenom, nil, nil, not v82)) then
							return "Cast Envenom (Master Assassin)";
						end
					end
				end
				v173 = 1 + 0;
			end
		end
	end
	local function v133()
		if ((v27 and v76.CrimsonTempest:IsReady() and (v86 >= (54 - (33 + 19))) and (v91 >= (2 + 2)) and (v104 > (74 - 49)) and not v76.Deathmark:IsReady()) or ((1182 + 1501) < (44 - 21))) then
			for v214, v215 in v30(v85) do
				if (((654 + 43) <= (1515 - (586 + 103))) and v122(v215, v76.CrimsonTempest, v94) and (v215:PMultiplier(v76.CrimsonTempest) <= (1 + 0)) and v215:FilteredTimeToDie(">", 18 - 12, -v215:DebuffRemains(v76.CrimsonTempest))) then
					if (((2593 - (1309 + 179)) <= (2122 - 946)) and v20(v76.CrimsonTempest)) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
			end
		end
		if (((1471 + 1908) <= (10237 - 6425)) and v76.Garrote:IsCastable() and (v92 >= (1 + 0))) then
			local v186 = 0 - 0;
			local v187;
			while true do
				if (((1 - 0) == v186) or ((1397 - (295 + 314)) >= (3969 - 2353))) then
					if (((3816 - (1300 + 662)) <= (10610 - 7231)) and v187(v15) and v75.CanDoTUnit(v15, v96) and (v15:FilteredTimeToDie(">", 1767 - (1178 + 577), -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) then
						if (((2363 + 2186) == (13447 - 8898)) and v29(v76.Garrote, nil, not v82)) then
							return "Pool for Garrote (ST)";
						end
					end
					if ((v27 and not v106 and (v86 >= (1407 - (851 + 554)))) or ((2673 + 349) >= (8386 - 5362))) then
						v123(v76.Garrote, v187, 25 - 13, v87);
					end
					break;
				end
				if (((5122 - (115 + 187)) > (1684 + 514)) and (v186 == (0 + 0))) then
					v187 = nil;
					function v187(v237)
						return v122(v237, v76.Garrote) and (v237:PMultiplier(v76.Garrote) <= (3 - 2));
					end
					v186 = 1162 - (160 + 1001);
				end
			end
		end
		if ((v76.Rupture:IsReady() and (v91 >= (4 + 0))) or ((733 + 328) >= (10012 - 5121))) then
			v97 = (362 - (237 + 121)) + (v21(v76.DashingScoundrel:IsAvailable()) * (902 - (525 + 372))) + (v21(v76.Doomblade:IsAvailable()) * (9 - 4)) + (v21(v106) * (19 - 13));
			local function v188(v216)
				return v122(v216, v76.Rupture, v93) and (v216:PMultiplier(v76.Rupture) <= (143 - (96 + 46))) and (v216:FilteredTimeToDie(">", v97, -v216:DebuffRemains(v76.Rupture)) or v216:TimeToDieIsNotValid());
			end
			if (((2141 - (643 + 134)) <= (1615 + 2858)) and v188(v15) and v75.CanDoTUnit(v15, v95)) then
				if (v20(v76.Rupture, nil, nil, not v82) or ((8619 - 5024) <= (11 - 8))) then
					return "Cast Rupture";
				end
			end
			if ((v27 and (not v106 or not v108)) or ((4481 + 191) == (7559 - 3707))) then
				v123(v76.Rupture, v188, v97, v87);
			end
		end
		if (((3186 - 1627) == (2278 - (316 + 403))) and v76.Garrote:IsCastable() and (v92 >= (1 + 0)) and (v116() <= (0 - 0)) and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or ((v15:DebuffRemains(v76.Garrote) < v89) and (v86 >= (7 - 4)))) and (v15:DebuffRemains(v76.Garrote) < (v89 * (2 + 0))) and (v86 >= (1 + 2)) and (v15:FilteredTimeToDie(">", 13 - 9, -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) then
			if (v20(v76.Garrote, nil, nil, not v82) or ((8367 - 6615) <= (1636 - 848))) then
				return "Garrote (Fallback)";
			end
		end
		return false;
	end
	local function v134()
		local v174 = 0 + 0;
		while true do
			if ((v174 == (3 - 1)) or ((191 + 3716) == (520 - 343))) then
				if (((3487 - (12 + 5)) > (2155 - 1600)) and v28 and v76.EchoingReprimand:IsReady()) then
					if (v20(v76.EchoingReprimand, nil, not v82) or ((2073 - 1101) == (1371 - 726))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((7890 - 4708) >= (430 + 1685)) and v76.FanofKnives:IsCastable()) then
					local v227 = 1973 - (1656 + 317);
					while true do
						if (((3470 + 423) < (3550 + 879)) and (v227 == (0 - 0))) then
							if ((v27 and (v86 >= (4 - 3)) and not v100 and (v86 >= ((356 - (5 + 349)) + v21(v14:StealthUp(true, false)) + v21(v76.DragonTemperedBlades:IsAvailable())))) or ((13617 - 10750) < (3176 - (266 + 1005)))) then
								if (v20(v76.FanofKnives) or ((1184 + 612) >= (13822 - 9771))) then
									return "Cast Fan of Knives";
								end
							end
							if (((2130 - 511) <= (5452 - (561 + 1135))) and v27 and v14:BuffUp(v76.DeadlyPoison) and (v86 >= (3 - 0))) then
								for v251, v252 in v30(v85) do
									if (((1985 - 1381) == (1670 - (507 + 559))) and not v252:DebuffUp(v76.DeadlyPoisonDebuff, true) and (not v100 or v252:DebuffUp(v76.Garrote) or v252:DebuffUp(v76.Rupture))) then
										if (v20(v76.FanofKnives) or ((11251 - 6767) == (2783 - 1883))) then
											return "Cast Fan of Knives (DP Refresh)";
										end
									end
								end
							end
							break;
						end
					end
				end
				v174 = 391 - (212 + 176);
			end
			if ((v174 == (905 - (250 + 655))) or ((12159 - 7700) <= (1944 - 831))) then
				if (((5682 - 2050) > (5354 - (1869 + 87))) and v76.Envenom:IsReady() and (v91 >= (13 - 9)) and (v101 or (v15:DebuffStack(v76.AmplifyingPoisonDebuff) >= (1921 - (484 + 1417))) or (v91 > v75.CPMaxSpend()) or not v107)) then
					if (((8749 - 4667) <= (8240 - 3323)) and v20(v76.Envenom, nil, nil, not v82)) then
						return "Cast Envenom";
					end
				end
				if (((5605 - (48 + 725)) >= (2264 - 878)) and not ((v92 > (2 - 1)) or v101 or not v107)) then
					return false;
				end
				v174 = 1 + 0;
			end
			if (((365 - 228) == (39 + 98)) and (v174 == (1 + 0))) then
				if ((not v107 and v76.CausticSpatter:IsAvailable() and v15:DebuffUp(v76.Rupture) and (v15:DebuffRemains(v76.CausticSpatterDebuff) <= (855 - (152 + 701)))) or ((2881 - (430 + 881)) >= (1659 + 2673))) then
					if (v76.Mutilate:IsCastable() or ((4959 - (557 + 338)) <= (538 + 1281))) then
						if (v20(v76.Mutilate, nil, nil, not v82) or ((14050 - 9064) < (5511 - 3937))) then
							return "Cast Mutilate (Casutic)";
						end
					end
					if (((11758 - 7332) > (370 - 198)) and (v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff))) then
						if (((1387 - (499 + 302)) > (1321 - (39 + 827))) and v20(v76.Ambush, nil, nil, not v82)) then
							return "Cast Ambush (Caustic)";
						end
					end
				end
				if (((2279 - 1453) == (1844 - 1018)) and v76.SerratedBoneSpike:IsReady()) then
					if (not v15:DebuffUp(v76.SerratedBoneSpikeDebuff) or ((15962 - 11943) > (6818 - 2377))) then
						if (((173 + 1844) < (12471 - 8210)) and v20(v76.SerratedBoneSpike, nil, not v83)) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v240 = 0 + 0;
						while true do
							if (((7462 - 2746) > (184 - (103 + 1))) and (v240 == (554 - (475 + 79)))) then
								if (v27 or ((7581 - 4074) == (10470 - 7198))) then
									if (v74.CastTargetIf(v76.SerratedBoneSpike, v84, "min", v126, v127) or ((114 + 762) >= (2707 + 368))) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if (((5855 - (1395 + 108)) > (7431 - 4877)) and (v116() < (1204.8 - (7 + 1197)))) then
									if ((v10.BossFightRemains() <= (3 + 2)) or ((v76.SerratedBoneSpike:MaxCharges() - v76.SerratedBoneSpike:ChargesFractional()) <= (0.25 + 0)) or ((4725 - (27 + 292)) < (11846 - 7803))) then
										if (v20(v76.SerratedBoneSpike, nil, true, not v83) or ((2408 - 519) >= (14187 - 10804))) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif (((3730 - 1838) <= (5206 - 2472)) and not v107 and v15:DebuffUp(v76.ShivDebuff)) then
										if (((2062 - (43 + 96)) < (9047 - 6829)) and v20(v76.SerratedBoneSpike, nil, true, not v83)) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v174 = 3 - 1;
			end
			if (((1804 + 369) > (108 + 271)) and ((5 - 2) == v174)) then
				if (((v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff) or v14:BuffUp(v76.SepsisBuff)) and (v15:DebuffDown(v76.Kingsbane) or v15:DebuffDown(v76.Deathmark) or v14:BuffUp(v76.BlindsideBuff))) or ((994 + 1597) == (6388 - 2979))) then
					if (((1422 + 3092) > (244 + 3080)) and v20(v76.Ambush, nil, not v82)) then
						return "Cast Ambush";
					end
				end
				if ((v76.Mutilate:IsCastable() and (v86 == (1753 - (1414 + 337))) and v15:DebuffDown(v76.DeadlyPoisonDebuff, true) and v15:DebuffDown(v76.AmplifyingPoisonDebuff, true)) or ((2148 - (1642 + 298)) >= (12585 - 7757))) then
					local v228 = 0 - 0;
					local v229;
					while true do
						if ((v228 == (0 - 0)) or ((521 + 1062) > (2776 + 791))) then
							v229 = v15:GUID();
							for v243, v244 in v30(v87) do
								if (((v244:GUID() ~= v229) and (v244:DebuffUp(v76.Garrote) or v244:DebuffUp(v76.Rupture)) and not v244:DebuffUp(v76.DeadlyPoisonDebuff, true) and not v244:DebuffUp(v76.AmplifyingPoisonDebuff, true)) or ((2285 - (357 + 615)) == (558 + 236))) then
									v20(v244, v76.Mutilate);
									break;
								end
							end
							break;
						end
					end
				end
				v174 = 9 - 5;
			end
			if (((2720 + 454) > (6218 - 3316)) and (v174 == (4 + 0))) then
				if (((280 + 3840) <= (2678 + 1582)) and v76.Mutilate:IsCastable()) then
					if (v20(v76.Mutilate, nil, not v82) or ((2184 - (384 + 917)) > (5475 - (128 + 569)))) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
		end
	end
	local function v135()
		local v175 = 1543 - (1407 + 136);
		while true do
			if ((v175 == (1893 - (687 + 1200))) or ((5330 - (556 + 1154)) >= (17206 - 12315))) then
				if (((4353 - (9 + 86)) > (1358 - (275 + 146))) and v88) then
					return v88;
				end
				v88 = v75.Feint();
				if (v88 or ((792 + 4077) < (970 - (29 + 35)))) then
					return v88;
				end
				v175 = 30 - 23;
			end
			if ((v175 == (11 - 7)) or ((5407 - 4182) > (2754 + 1474))) then
				v93 = ((1016 - (53 + 959)) + (v91 * (412 - (312 + 96)))) * (0.3 - 0);
				v94 = ((289 - (147 + 138)) + (v91 * (901 - (813 + 86)))) * (0.3 + 0);
				v95 = v76.Envenom:Damage() * v63;
				v175 = 8 - 3;
			end
			if (((3820 - (18 + 474)) > (756 + 1482)) and (v175 == (9 - 6))) then
				v89, v90 = (1088 - (860 + 226)) * v14:SpellHaste(), (304 - (121 + 182)) * v14:SpellHaste();
				v91 = v75.EffectiveComboPoints(v14:ComboPoints());
				v92 = v14:ComboPointsMax() - v91;
				v175 = 1 + 3;
			end
			if (((5079 - (988 + 252)) > (159 + 1246)) and ((0 + 0) == v175)) then
				v73();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v175 = 1971 - (49 + 1921);
			end
			if ((v175 == (895 - (223 + 667))) or ((1345 - (51 + 1)) <= (872 - 365))) then
				v96 = v76.Mutilate:Damage() * v64;
				v100 = v46();
				v88 = v75.CrimsonVial();
				v175 = 12 - 6;
			end
			if ((v175 == (1132 - (146 + 979))) or ((818 + 2078) < (1410 - (311 + 294)))) then
				if (((6458 - 4142) == (982 + 1334)) and not v14:AffectingCombat() and not v14:IsMounted() and v74.TargetIsValid()) then
					local v230 = 1443 - (496 + 947);
					while true do
						if ((v230 == (1358 - (1233 + 125))) or ((1043 + 1527) == (1376 + 157))) then
							v88 = v75.Stealth(v76.Stealth2, nil);
							if (v88 or ((168 + 715) == (3105 - (963 + 682)))) then
								return "Stealth (OOC): " .. v88;
							end
							break;
						end
					end
				end
				v75.Poisons();
				if (not v14:AffectingCombat() or ((3855 + 764) <= (2503 - (504 + 1000)))) then
					local v231 = 0 + 0;
					while true do
						if ((v231 == (0 + 0)) or ((322 + 3088) > (6069 - 1953))) then
							if (not v14:BuffUp(v75.VanishBuffSpell()) or ((772 + 131) >= (1779 + 1280))) then
								local v248 = 182 - (156 + 26);
								while true do
									if ((v248 == (0 + 0)) or ((6219 - 2243) < (3021 - (149 + 15)))) then
										v88 = v75.Stealth(v75.StealthSpell());
										if (((5890 - (890 + 70)) > (2424 - (39 + 78))) and v88) then
											return v88;
										end
										break;
									end
								end
							end
							if (v74.TargetIsValid() or ((4528 - (14 + 468)) < (2838 - 1547))) then
								local v249 = 0 - 0;
								while true do
									if ((v249 == (0 + 0)) or ((2547 + 1694) == (754 + 2791))) then
										if (v28 or ((1829 + 2219) > (1109 + 3123))) then
											if ((v26 and v76.MarkedforDeath:IsCastable() and (v14:ComboPointsDeficit() >= v75.CPMaxSpend()) and v74.TargetIsValid()) or ((3349 - 1599) >= (3433 + 40))) then
												if (((11125 - 7959) == (80 + 3086)) and v10.Press(v76.MarkedforDeath, v59)) then
													return "Cast Marked for Death (OOC)";
												end
											end
										end
										if (((1814 - (12 + 39)) < (3465 + 259)) and not v14:BuffUp(v76.SliceandDice)) then
											if (((176 - 119) <= (9697 - 6974)) and v76.SliceandDice:IsReady() and (v91 >= (1 + 1))) then
												if (v10.Press(v76.SliceandDice) or ((1090 + 980) == (1123 - 680))) then
													return "Cast Slice and Dice";
												end
											end
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v175 = 6 + 2;
			end
			if ((v175 == (38 - 30)) or ((4415 - (1596 + 114)) == (3636 - 2243))) then
				v75.MfDSniping(v76.MarkedforDeath);
				if (v74.TargetIsValid() or ((5314 - (164 + 549)) < (1499 - (1059 + 379)))) then
					local v232 = 0 - 0;
					while true do
						if ((v232 == (2 + 1)) or ((235 + 1155) >= (5136 - (145 + 247)))) then
							v88 = v133();
							if (v88 or ((1644 + 359) > (1772 + 2062))) then
								return v88;
							end
							v88 = v134();
							if (v88 or ((462 - 306) > (751 + 3162))) then
								return v88;
							end
							v232 = 4 + 0;
						end
						if (((316 - 121) == (915 - (254 + 466))) and (v232 == (562 - (544 + 16)))) then
							if (((9867 - 6762) >= (2424 - (294 + 334))) and (v14:StealthUp(true, false) or (v117() > (253 - (236 + 17))) or (v116() > (0 + 0)))) then
								v88 = v132();
								if (((3409 + 970) >= (8025 - 5894)) and v88) then
									return v88 .. " (Stealthed)";
								end
							end
							v88 = v131();
							if (((18199 - 14355) >= (1052 + 991)) and v88) then
								return v88;
							end
							if (not v14:BuffUp(v76.SliceandDice) or ((2662 + 570) <= (3525 - (413 + 381)))) then
								if (((207 + 4698) == (10431 - 5526)) and ((v76.SliceandDice:IsReady() and (v14:ComboPoints() >= (4 - 2)) and v15:DebuffUp(v76.Rupture)) or (not v76.CutToTheChase:IsAvailable() and (v14:ComboPoints() >= (1974 - (582 + 1388))) and (v14:BuffRemains(v76.SliceandDice) < (((1 - 0) + v14:ComboPoints()) * (1.8 + 0)))))) then
									if (v20(v76.SliceandDice) or ((4500 - (326 + 38)) >= (13048 - 8637))) then
										return "Cast Slice and Dice";
									end
								end
							elseif ((v83 and v76.CutToTheChase:IsAvailable()) or ((4222 - 1264) == (4637 - (47 + 573)))) then
								if (((433 + 795) >= (3452 - 2639)) and v76.Envenom:IsReady() and (v14:BuffRemains(v76.SliceandDice) < (8 - 3)) and (v14:ComboPoints() >= (1668 - (1269 + 395)))) then
									if (v20(v76.Envenom, nil, nil, not v82) or ((3947 - (76 + 416)) > (4493 - (319 + 124)))) then
										return "Cast Envenom (CttC)";
									end
								end
							elseif (((555 - 312) == (1250 - (564 + 443))) and v76.PoisonedKnife:IsCastable() and v15:IsInRange(83 - 53) and not v14:StealthUp(true, true) and (v86 == (458 - (337 + 121))) and (v14:EnergyTimeToMax() <= (v14:GCD() * (2.5 - 1)))) then
								if (v20(v76.PoisonedKnife) or ((902 - 631) > (3483 - (1261 + 650)))) then
									return "Cast Poisoned Knife";
								end
							end
							v232 = 2 + 1;
						end
						if (((4364 - 1625) < (5110 - (772 + 1045))) and (v232 == (0 + 0))) then
							v103 = v75.PoisonedBleeds();
							v104 = v14:EnergyRegen() + ((v103 * (150 - (102 + 42))) / ((1846 - (1524 + 320)) * v14:SpellHaste()));
							v105 = v14:EnergyDeficit() / v104;
							v106 = v104 > (1305 - (1049 + 221));
							v232 = 157 - (18 + 138);
						end
						if ((v232 == (9 - 5)) or ((5044 - (67 + 1035)) < (1482 - (136 + 212)))) then
							if (v28 or ((11443 - 8750) == (3984 + 989))) then
								local v250 = 0 + 0;
								while true do
									if (((3750 - (240 + 1364)) == (3228 - (1050 + 32))) and ((3 - 2) == v250)) then
										if ((v76.LightsJudgment:IsCastable() and v82) or ((1328 + 916) == (4279 - (331 + 724)))) then
											if (v20(v76.LightsJudgment, v32) or ((396 + 4508) <= (2560 - (269 + 375)))) then
												return "Cast Lights Judgment";
											end
										end
										if (((815 - (267 + 458)) <= (332 + 733)) and v76.BagofTricks:IsCastable() and v82) then
											if (((9234 - 4432) == (5620 - (667 + 151))) and v20(v76.BagofTricks, v32)) then
												return "Cast Bag of Tricks";
											end
										end
										break;
									end
									if ((v250 == (1497 - (1410 + 87))) or ((4177 - (1504 + 393)) <= (1381 - 870))) then
										if ((v76.ArcaneTorrent:IsCastable() and v82 and (v14:EnergyDeficit() > (38 - 23))) or ((2472 - (461 + 335)) <= (60 + 403))) then
											if (((5630 - (1730 + 31)) == (5536 - (728 + 939))) and v20(v76.ArcaneTorrent, v32)) then
												return "Cast Arcane Torrent";
											end
										end
										if (((4101 - 2943) <= (5299 - 2686)) and v76.ArcanePulse:IsCastable() and v82) then
											if (v20(v76.ArcanePulse, v32) or ((5416 - 3052) <= (3067 - (138 + 930)))) then
												return "Cast Arcane Pulse";
											end
										end
										v250 = 1 + 0;
									end
								end
							end
							if (v76.Mutilate:IsCastable() or v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable() or ((3849 + 1073) < (167 + 27))) then
								if (v20(v76.PoolEnergy) or ((8538 - 6447) < (1797 - (459 + 1307)))) then
									return "Normal Pooling";
								end
							end
							break;
						end
						if (((1871 - (474 + 1396)) == v232) or ((4243 - 1813) >= (4567 + 305))) then
							v101 = v119();
							v102 = v120();
							v108 = v121();
							v107 = v86 < (1 + 1);
							v232 = 5 - 3;
						end
					end
				end
				break;
			end
			if ((v175 == (1 + 0)) or ((15923 - 11153) < (7566 - 5831))) then
				v28 = EpicSettings.Toggles['cds'];
				v80 = (v76.AcrobaticStrikes:IsAvailable() and (599 - (562 + 29))) or (5 + 0);
				v81 = (v76.AcrobaticStrikes:IsAvailable() and (1432 - (374 + 1045))) or (8 + 2);
				v175 = 5 - 3;
			end
			if ((v175 == (640 - (448 + 190))) or ((1434 + 3005) <= (1061 + 1289))) then
				v82 = v15:IsInMeleeRange(v80);
				v83 = v15:IsInMeleeRange(v81);
				if (v27 or ((2919 + 1560) < (17170 - 12704))) then
					local v233 = 0 - 0;
					while true do
						if (((4041 - (1307 + 187)) > (4857 - 3632)) and (v233 == (2 - 1))) then
							v86 = #v85;
							v87 = v14:GetEnemiesInMeleeRange(v80);
							break;
						end
						if (((14322 - 9651) > (3357 - (232 + 451))) and (v233 == (0 + 0))) then
							v84 = v14:GetEnemiesInRange(27 + 3);
							v85 = v14:GetEnemiesInMeleeRange(v81);
							v233 = 565 - (510 + 54);
						end
					end
				else
					local v234 = 0 - 0;
					while true do
						if ((v234 == (36 - (13 + 23))) or ((7204 - 3508) < (4780 - 1453))) then
							v84 = {};
							v85 = {};
							v234 = 1 - 0;
						end
						if (((1089 - (830 + 258)) == v234) or ((16022 - 11480) == (1859 + 1111))) then
							v86 = 1 + 0;
							v87 = {};
							break;
						end
					end
				end
				v175 = 1444 - (860 + 581);
			end
		end
	end
	local function v136()
		local v176 = 0 - 0;
		while true do
			if (((200 + 52) <= (2218 - (237 + 4))) and (v176 == (2 - 1))) then
				v76.Garrote:RegisterAuraTracking();
				v10.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
			if ((v176 == (0 - 0)) or ((2722 - 1286) == (3090 + 685))) then
				v76.Deathmark:RegisterAuraTracking();
				v76.Sepsis:RegisterAuraTracking();
				v176 = 1 + 0;
			end
		end
	end
	v10.SetAPL(977 - 718, v135, v136);
end;
return v0["Epix_Rogue_Assassination.lua"]();

