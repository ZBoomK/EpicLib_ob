local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1009 - (922 + 87))) or ((11787 - 7329) <= (348 + 582))) then
			v6 = v0[v4];
			if (((61 + 601) <= (3488 - 2516)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((2616 + 1754) == (5048 - (356 + 322))) and (v5 == (2 - 1))) then
			return v6(...);
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
	local v29 = v10.CastPooling;
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
			if ((v137 == (1 - 0)) or ((6006 - (485 + 759)) <= (1992 - 1131))) then
				v39 = EpicSettings.Settings['InterruptWithStun'] or (1189 - (442 + 747));
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1135 - (832 + 303));
				v41 = EpicSettings.Settings['InterruptThreshold'] or (946 - (88 + 858));
				v43 = EpicSettings.Settings['PoisonRefresh'];
				v44 = EpicSettings.Settings['PoisonRefreshCombat'];
				v45 = EpicSettings.Settings['RangedMultiDoT'];
				v137 = 1 + 1;
			end
			if ((v137 == (0 + 0)) or ((59 + 1353) == (5053 - (766 + 23)))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v137 = 3 - 2;
			end
			if ((v137 == (1077 - (1036 + 37))) or ((2247 + 921) < (4192 - 2039))) then
				v62 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 + 0);
				v64 = EpicSettings.Settings['MutilateDMGOffset'] or (1481 - (641 + 839));
				v65 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v66 = EpicSettings.Settings['PotionTypeSelected'];
				v67 = EpicSettings.Settings['ExsanguinateGCD'];
				v137 = 918 - (910 + 3);
			end
			if ((v137 == (12 - 7)) or ((6660 - (1466 + 218)) < (613 + 719))) then
				v68 = EpicSettings.Settings['KingsbaneGCD'];
				v69 = EpicSettings.Settings['ShivGCD'];
				v70 = EpicSettings.Settings['DeathmarkOffGCD'];
				v72 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v71 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
			if (((5776 - (556 + 592)) == (1646 + 2982)) and (v137 == (811 - (329 + 479)))) then
				v56 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v57 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v58 = EpicSettings.Settings['ColdBloodOffGCD'];
				v59 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v60 = EpicSettings.Settings['CrimsonVialHP'] or (855 - (174 + 680));
				v61 = EpicSettings.Settings['FeintHP'] or (3 - 2);
				v137 = 8 - 4;
			end
			if ((v137 == (2 + 0)) or ((793 - (396 + 343)) == (35 + 360))) then
				v46 = EpicSettings.Settings['UsePriorityRotation'];
				v51 = EpicSettings.Settings['STMfDAsDPSCD'];
				v52 = EpicSettings.Settings['KidneyShotInterrupt'];
				v53 = EpicSettings.Settings['RacialsGCD'];
				v54 = EpicSettings.Settings['RacialsOffGCD'];
				v55 = EpicSettings.Settings['VanishOffGCD'];
				v137 = 1480 - (29 + 1448);
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
	local v89, v90 = (2 + 0) * v14:SpellHaste(), (1528 - (389 + 1138)) * v14:SpellHaste();
	local v91, v92;
	local v93, v94, v95, v96, v97, v98, v99;
	local v100;
	local v101, v102, v103, v104, v105, v106, v107, v108;
	local v109 = 574 - (102 + 472);
	local v110 = v14:GetEquipment();
	local v111 = (v110[13 + 0] and v18(v110[8 + 5])) or v18(0 + 0);
	local v112 = (v110[1559 - (320 + 1225)] and v18(v110[24 - 10])) or v18(0 + 0);
	local function v113()
		if (((1546 - (157 + 1307)) == (1941 - (821 + 1038))) and v111:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v111:Cooldown() >= v112:Cooldown()))) then
			v109 = 2 - 1;
		elseif ((v112:HasStatAnyDps() and (not v111:HasStatAnyDps() or (v112:Cooldown() > v111:Cooldown()))) or ((64 + 517) < (500 - 218))) then
			v109 = 1 + 1;
		else
			v109 = 0 - 0;
		end
	end
	v113();
	v10:RegisterForEvent(function()
		local v138 = 1026 - (834 + 192);
		while true do
			if ((v138 == (1 + 0)) or ((1184 + 3425) < (54 + 2441))) then
				v112 = (v110[21 - 7] and v18(v110[318 - (300 + 4)])) or v18(0 + 0);
				v113();
				break;
			end
			if (((3015 - 1863) == (1514 - (112 + 250))) and (v138 == (0 + 0))) then
				v110 = v14:GetEquipment();
				v111 = (v110[32 - 19] and v18(v110[8 + 5])) or v18(0 + 0);
				v138 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v114 = {{v76.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v76.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v91 > (1906 - (1665 + 241));
	end}};
	v76.Envenom:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v91 * (717.22 - (373 + 344)) * (1 + 0) * ((v15:DebuffUp(v76.ShivDebuff) and (1.3 + 0)) or (2 - 1)) * ((v76.DeeperStratagem:IsAvailable() and (1.05 - 0)) or (1100 - (35 + 1064))) * (1 + 0 + (v14:MasteryPct() / (213 - 113))) * (1 + 0 + (v14:VersatilityDmgPct() / (1336 - (298 + 938))));
	end);
	v76.Mutilate:RegisterDamageFormula(function()
		return (v14:AttackPowerDamageMod() + v14:AttackPowerDamageMod(true)) * (1259.485 - (233 + 1026)) * (1667 - (636 + 1030)) * (1 + 0 + (v14:VersatilityDmgPct() / (98 + 2)));
	end);
	local function v115()
		return v14:BuffRemains(v76.MasterAssassinBuff) == (2971 + 7028);
	end
	local function v116()
		local v139 = 0 + 0;
		while true do
			if (((2117 - (55 + 166)) <= (664 + 2758)) and (v139 == (0 + 0))) then
				if (v115() or ((3780 - 2790) > (1917 - (36 + 261)))) then
					return v14:GCDRemains() + (4 - 1);
				end
				return v14:BuffRemains(v76.MasterAssassinBuff);
			end
		end
	end
	local function v117()
		local v140 = 1368 - (34 + 1334);
		while true do
			if ((v140 == (0 + 0)) or ((682 + 195) > (5978 - (1035 + 248)))) then
				if (((2712 - (20 + 1)) >= (965 + 886)) and v14:BuffUp(v76.ImprovedGarroteAura)) then
					return v14:GCDRemains() + (322 - (134 + 185));
				end
				return v14:BuffRemains(v76.ImprovedGarroteBuff);
			end
		end
	end
	local function v118()
		local v141 = 1133 - (549 + 584);
		while true do
			if (((685 - (314 + 371)) == v141) or ((10247 - 7262) >= (5824 - (478 + 490)))) then
				if (((2266 + 2010) >= (2367 - (786 + 386))) and v14:BuffUp(v76.IndiscriminateCarnageAura)) then
					return v14:GCDRemains() + (32 - 22);
				end
				return v14:BuffRemains(v76.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v46()
		if (((4611 - (1055 + 324)) <= (6030 - (1093 + 247))) and (v86 < (2 + 0))) then
			return false;
		elseif ((v46 == "Always") or ((95 + 801) >= (12490 - 9344))) then
			return true;
		elseif (((10388 - 7327) >= (8416 - 5458)) and (v46 == "On Bosses") and v15:IsInBossList()) then
			return true;
		elseif (((8008 - 4821) >= (230 + 414)) and (v46 == "Auto")) then
			if (((2480 - 1836) <= (2426 - 1722)) and (v14:InstanceDifficulty() == (13 + 3)) and (v15:NPCID() == (355396 - 216429))) then
				return true;
			end
		end
		return false;
	end
	local function v119()
		if (((1646 - (364 + 324)) > (2596 - 1649)) and (v15:DebuffUp(v76.Deathmark) or v15:DebuffUp(v76.Kingsbane) or v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.ShivDebuff) or (v76.ThistleTea:FullRechargeTime() < (47 - 27)) or (v14:EnergyPercentage() >= (27 + 53)) or (v14:HasTier(129 - 98, 5 - 1) and ((v14:BuffUp(v76.Envenom) and (v14:BuffRemains(v76.Envenom) <= (5 - 3))) or v10.BossFilteredFightRemains("<=", 1358 - (1249 + 19)))))) then
			return true;
		end
		return false;
	end
	local function v120()
		local v142 = 0 + 0;
		while true do
			if (((17484 - 12992) >= (3740 - (686 + 400))) and (v142 == (0 + 0))) then
				if (((3671 - (73 + 156)) >= (8 + 1495)) and (v76.Deathmark:CooldownRemains() > v76.Sepsis:CooldownRemains()) and (v10.BossFightRemainsIsNotValid() or v10.BossFilteredFightRemains(">", v76.Deathmark:CooldownRemains()))) then
					return v76.Deathmark:CooldownRemains();
				end
				return v76.Sepsis:CooldownRemains();
			end
		end
	end
	local function v121()
		local v143 = 811 - (721 + 90);
		while true do
			if ((v143 == (0 + 0)) or ((10292 - 7122) <= (1934 - (224 + 246)))) then
				if (not v76.ScentOfBlood:IsAvailable() or ((7770 - 2973) == (8078 - 3690))) then
					return true;
				end
				return v14:BuffStack(v76.ScentOfBloodBuff) >= v23(4 + 16, v76.ScentOfBlood:TalentRank() * (1 + 1) * v86);
			end
		end
	end
	local function v122(v144, v145, v146)
		local v147 = 0 + 0;
		local v146;
		while true do
			if (((1095 - 544) <= (2266 - 1585)) and ((513 - (203 + 310)) == v147)) then
				v146 = v146 or v145:PandemicThreshold();
				return v144:DebuffRefreshable(v145, v146);
			end
		end
	end
	local function v123(v148, v149, v150, v151)
		local v152, v153 = nil, v150;
		local v154 = v15:GUID();
		for v178, v179 in v30(v151) do
			if (((5270 - (1238 + 755)) > (29 + 378)) and (v179:GUID() ~= v154) and v74.UnitIsCycleValid(v179, v153, -v179:DebuffRemains(v148)) and v149(v179)) then
				v152, v153 = v179, v179:TimeToDie();
			end
		end
		if (((6229 - (709 + 825)) >= (2607 - 1192)) and v152) then
			v20(v152, v148);
		elseif (v45 or ((4678 - 1466) <= (1808 - (196 + 668)))) then
			v152, v153 = nil, v150;
			for v221, v222 in v30(v85) do
				if (((v222:GUID() ~= v154) and v74.UnitIsCycleValid(v222, v153, -v222:DebuffRemains(v148)) and v149(v222)) or ((12223 - 9127) <= (3724 - 1926))) then
					v152, v153 = v222, v222:TimeToDie();
				end
			end
			if (((4370 - (171 + 662)) == (3630 - (4 + 89))) and v152) then
				v20(v152, v148);
			end
		end
	end
	local function v124(v155, v156, v157)
		local v158 = 0 - 0;
		local v159;
		local v160;
		local v161;
		local v162;
		while true do
			if (((1398 + 2439) >= (6895 - 5325)) and (v158 == (2 + 1))) then
				if (v45 or ((4436 - (35 + 1451)) == (5265 - (28 + 1425)))) then
					v162(v85);
				end
				if (((6716 - (941 + 1052)) >= (2223 + 95)) and v160 and (v161 == v159) and v157(v15)) then
					return v15;
				end
				v158 = 1518 - (822 + 692);
			end
			if (((1 - 0) == v158) or ((955 + 1072) > (3149 - (45 + 252)))) then
				v160, v161 = nil, 0 + 0;
				v162 = nil;
				v158 = 1 + 1;
			end
			if ((v158 == (9 - 5)) or ((1569 - (114 + 319)) > (6198 - 1881))) then
				if (((6083 - 1335) == (3027 + 1721)) and v160 and v157(v160)) then
					return v160;
				end
				return nil;
			end
			if (((5565 - 1829) <= (9931 - 5191)) and (v158 == (1965 - (556 + 1407)))) then
				function v162(v217)
					for v223, v224 in v30(v217) do
						local v225 = 1206 - (741 + 465);
						local v226;
						while true do
							if ((v225 == (466 - (170 + 295))) or ((1787 + 1603) <= (2811 + 249))) then
								if ((v160 and (v226 == v161) and (v224:TimeToDie() > v160:TimeToDie())) or ((2459 - 1460) > (2233 + 460))) then
									v160, v161 = v224, v226;
								end
								break;
							end
							if (((297 + 166) < (341 + 260)) and ((1230 - (957 + 273)) == v225)) then
								v226 = v156(v224);
								if ((not v160 and (v155 == "first")) or ((584 + 1599) < (276 + 411))) then
									if (((17333 - 12784) == (11987 - 7438)) and (v226 ~= (0 - 0))) then
										v160, v161 = v224, v226;
									end
								elseif (((23134 - 18462) == (6452 - (389 + 1391))) and (v155 == "min")) then
									if (not v160 or (v226 < v161) or ((2302 + 1366) < (42 + 353))) then
										v160, v161 = v224, v226;
									end
								elseif ((v155 == "max") or ((9484 - 5318) == (1406 - (783 + 168)))) then
									if (not v160 or (v226 > v161) or ((14931 - 10482) == (2620 + 43))) then
										v160, v161 = v224, v226;
									end
								end
								v225 = 312 - (309 + 2);
							end
						end
					end
				end
				v162(v87);
				v158 = 9 - 6;
			end
			if ((v158 == (1212 - (1090 + 122))) or ((1387 + 2890) < (10038 - 7049))) then
				v159 = v156(v15);
				if (((v155 == "first") and (v159 ~= (0 + 0))) or ((1988 - (628 + 490)) >= (744 + 3405))) then
					return v15;
				end
				v158 = 2 - 1;
			end
		end
	end
	local function v125(v163, v164, v165)
		local v166 = v15:TimeToDie();
		if (((10108 - 7896) < (3957 - (431 + 343))) and not v10.BossFightRemainsIsNotValid()) then
			v166 = v10.BossFightRemains();
		elseif (((9382 - 4736) > (8655 - 5663)) and (v166 < v165)) then
			return false;
		end
		if (((1133 + 301) < (398 + 2708)) and (v31((v166 - v165) / v163) > v31(((v166 - v165) - v164) / v163))) then
			return true;
		end
		return false;
	end
	local function v126(v167)
		local v168 = 1695 - (556 + 1139);
		while true do
			if (((801 - (6 + 9)) < (554 + 2469)) and (v168 == (0 + 0))) then
				if (v167:DebuffUp(v76.SerratedBoneSpikeDebuff) or ((2611 - (28 + 141)) < (29 + 45))) then
					return 1234356 - 234356;
				end
				return v167:TimeToDie();
			end
		end
	end
	local function v127(v169)
		return not v169:DebuffUp(v76.SerratedBoneSpikeDebuff);
	end
	local function v128()
		local v170 = 0 + 0;
		while true do
			if (((5852 - (486 + 831)) == (11801 - 7266)) and (v170 == (0 - 0))) then
				if (v76.BloodFury:IsCastable() or ((569 + 2440) <= (6655 - 4550))) then
					if (((3093 - (668 + 595)) < (3302 + 367)) and v10.Press(v76.BloodFury, v54)) then
						return "Cast Blood Fury";
					end
				end
				if (v76.Berserking:IsCastable() or ((289 + 1141) >= (9850 - 6238))) then
					if (((2973 - (23 + 267)) >= (4404 - (1129 + 815))) and v10.Press(v76.Berserking, v54)) then
						return "Cast Berserking";
					end
				end
				v170 = 388 - (371 + 16);
			end
			if ((v170 == (1751 - (1326 + 424))) or ((3416 - 1612) >= (11967 - 8692))) then
				if (v76.Fireblood:IsCastable() or ((1535 - (88 + 30)) > (4400 - (720 + 51)))) then
					if (((10666 - 5871) > (2178 - (421 + 1355))) and v10.Press(v76.Fireblood, v54)) then
						return "Cast Fireblood";
					end
				end
				if (((7940 - 3127) > (1752 + 1813)) and v76.AncestralCall:IsCastable()) then
					if (((4995 - (286 + 797)) == (14300 - 10388)) and ((not v76.Kingsbane:IsAvailable() and v15:DebuffUp(v76.ShivDebuff)) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (12 - 4))))) then
						if (((3260 - (397 + 42)) <= (1507 + 3317)) and v10.Press(v76.AncestralCall, v54)) then
							return "Cast Ancestral Call";
						end
					end
				end
				v170 = 802 - (24 + 776);
			end
			if (((2677 - 939) <= (2980 - (222 + 563))) and (v170 == (3 - 1))) then
				return false;
			end
		end
	end
	local function v129()
		local v171 = 0 + 0;
		while true do
			if (((231 - (23 + 167)) <= (4816 - (690 + 1108))) and (v171 == (0 + 0))) then
				if (((1770 + 375) <= (4952 - (40 + 808))) and v76.ShadowDance:IsCastable() and not v76.Kingsbane:IsAvailable()) then
					if (((443 + 2246) < (18527 - 13682)) and v76.ImprovedGarrote:IsAvailable() and v76.Garrote:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or v122(v15, v76.Garrote)) and (v76.Deathmark:AnyDebuffUp() or (v76.Deathmark:CooldownRemains() < (7 + 5)) or (v76.Deathmark:CooldownRemains() > (33 + 27))) and (v92 >= math.min(v86, 575 - (47 + 524)))) then
						local v242 = 0 + 0;
						while true do
							if ((v242 == (0 - 0)) or ((3471 - 1149) > (5979 - 3357))) then
								if ((v50 and (v14:EnergyPredicted() < (1771 - (1165 + 561)))) or ((135 + 4399) == (6448 - 4366))) then
									if (v20(v76.PoolEnergy) or ((600 + 971) > (2346 - (341 + 138)))) then
										return "Pool for Shadow Dance (Garrote)";
									end
								end
								if (v20(v76.ShadowDance, v56) or ((717 + 1937) >= (6182 - 3186))) then
									return "Cast Shadow Dance (Garrote)";
								end
								break;
							end
						end
					end
					if (((4304 - (89 + 237)) > (6768 - 4664)) and not v76.ImprovedGarrote:IsAvailable() and v76.MasterAssassin:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > (6 - 3)) and (v15:DebuffUp(v76.Deathmark) or (v76.Deathmark:CooldownRemains() > (941 - (581 + 300)))) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < (1224 - (855 + 365))) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < (6 - 3))) then
						if (((978 + 2017) > (2776 - (1030 + 205))) and v20(v76.ShadowDance, v56)) then
							return "Cast Shadow Dance (Master Assassin)";
						end
					end
				end
				if (((3051 + 198) > (887 + 66)) and v76.Vanish:IsCastable() and not v14:IsTanking(v15)) then
					local v227 = 286 - (156 + 130);
					while true do
						if ((v227 == (0 - 0)) or ((5516 - 2243) > (9365 - 4792))) then
							if ((v76.ImprovedGarrote:IsAvailable() and not v76.MasterAssassin:IsAvailable() and v76.Garrote:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or v122(v15, v76.Garrote))) or ((1838 + 1313) < (1353 - (10 + 59)))) then
								local v248 = 0 + 0;
								while true do
									if ((v248 == (0 - 0)) or ((3013 - (671 + 492)) == (1218 + 311))) then
										if (((2036 - (369 + 846)) < (563 + 1560)) and not v76.IndiscriminateCarnage:IsAvailable() and (v76.Deathmark:AnyDebuffUp() or (v76.Deathmark:CooldownRemains() < (4 + 0))) and (v92 >= v23(v86, 1949 - (1036 + 909)))) then
											if (((718 + 184) < (3903 - 1578)) and v50 and (v14:EnergyPredicted() < (248 - (11 + 192)))) then
												if (((434 + 424) <= (3137 - (135 + 40))) and v20(v76.PoolEnergy)) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (v20(v76.Vanish, v55) or ((9560 - 5614) < (777 + 511))) then
												return "Cast Vanish (Garrote Deathmark)";
											end
										end
										if ((v76.IndiscriminateCarnage:IsAvailable() and (v86 > (4 - 2))) or ((4859 - 1617) == (743 - (50 + 126)))) then
											if ((v50 and (v14:EnergyPredicted() < (125 - 80))) or ((188 + 659) >= (2676 - (1233 + 180)))) then
												if (v20(v76.PoolEnergy) or ((3222 - (522 + 447)) == (3272 - (107 + 1314)))) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (v20(v76.Vanish, v55) or ((969 + 1118) > (7227 - 4855))) then
												return "Cast Vanish (Garrote Cleave)";
											end
										end
										break;
									end
								end
							end
							if ((v76.MasterAssassin:IsAvailable() and v76.Kingsbane:IsAvailable() and v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) <= (2 + 1)) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffRemains(v76.Deathmark) <= (5 - 2))) or ((17587 - 13142) < (6059 - (716 + 1194)))) then
								if (v20(v76.Vanish, v55) or ((32 + 1786) == (10 + 75))) then
									return "Cast Vanish (Kingsbane)";
								end
							end
							v227 = 504 - (74 + 429);
						end
						if (((1215 - 585) < (1055 + 1072)) and (v227 == (2 - 1))) then
							if ((not v76.ImprovedGarrote:IsAvailable() and v76.MasterAssassin:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > (3 + 0)) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < (12 - 8)) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < (7 - 4))) or ((2371 - (279 + 154)) == (3292 - (454 + 324)))) then
								if (((3348 + 907) >= (72 - (12 + 5))) and v20(v76.Vanish, v55)) then
									return "Cast Vanish (Master Assassin)";
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
	local function v130()
		v88 = v74.HandleTopTrinket(v79, v28, 22 + 18, nil);
		if (((7641 - 4642) > (428 + 728)) and v88) then
			return v88;
		end
		v88 = v74.HandleBottomTrinket(v79, v28, 1133 - (277 + 816), nil);
		if (((10041 - 7691) > (2338 - (1058 + 125))) and v88) then
			return v88;
		end
	end
	local function v131()
		local v172 = 0 + 0;
		local v173;
		while true do
			if (((5004 - (815 + 160)) <= (20822 - 15969)) and (v172 == (4 - 2))) then
				if ((v76.ShadowDance:IsCastable() and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom) and ((v76.Deathmark:CooldownRemains() >= (12 + 38)) or v173)) or ((1508 - 992) > (5332 - (41 + 1857)))) then
					if (((5939 - (1222 + 671)) >= (7838 - 4805)) and v20(v76.ShadowDance, v56)) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				if ((v76.Kingsbane:IsReady() and (v15:DebuffUp(v76.ShivDebuff) or (v76.Shiv:CooldownRemains() < (7 - 1))) and v14:BuffUp(v76.Envenom) and ((v76.Deathmark:CooldownRemains() >= (1232 - (229 + 953))) or v15:DebuffUp(v76.Deathmark))) or ((4493 - (1111 + 663)) <= (3026 - (874 + 705)))) then
					if (v20(v76.Kingsbane, v68) or ((579 + 3555) < (2679 + 1247))) then
						return "Cast Kingsbane";
					end
				end
				if ((v76.ThistleTea:IsCastable() and not v14:BuffUp(v76.ThistleTea) and (((v14:EnergyDeficit() >= ((207 - 107) + v104)) and (not v76.Kingsbane:IsAvailable() or (v76.ThistleTea:Charges() >= (1 + 1)))) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (685 - (642 + 37)))) or (not v76.Kingsbane:IsAvailable() and v76.Deathmark:AnyDebuffUp()) or v10.BossFilteredFightRemains("<", v76.ThistleTea:Charges() * (2 + 4)))) or ((27 + 137) >= (6992 - 4207))) then
					if (v10.Cast(v76.ThistleTea, v57) or ((979 - (233 + 221)) == (4876 - 2767))) then
						return "Cast Thistle Tea";
					end
				end
				v172 = 3 + 0;
			end
			if (((1574 - (718 + 823)) == (21 + 12)) and (v172 == (806 - (266 + 539)))) then
				v173 = not v14:StealthUp(true, false) and v15:DebuffUp(v76.Rupture) and v14:BuffUp(v76.Envenom) and not v76.Deathmark:AnyDebuffUp() and (not v76.MasterAssassin:IsAvailable() or v15:DebuffUp(v76.Garrote)) and (not v76.Kingsbane:IsAvailable() or (v76.Kingsbane:CooldownRemains() <= (5 - 3)));
				if (((4279 - (636 + 589)) <= (9530 - 5515)) and v76.Deathmark:IsCastable() and (v173 or v10.BossFilteredFightRemains("<=", 41 - 21))) then
					if (((1483 + 388) < (1229 + 2153)) and v20(v76.Deathmark, v70)) then
						return "Cast Deathmark";
					end
				end
				if (((2308 - (657 + 358)) <= (5734 - 3568)) and v76.Shiv:IsReady() and not v15:DebuffUp(v76.ShivDebuff) and v15:DebuffUp(v76.Garrote) and v15:DebuffUp(v76.Rupture)) then
					local v228 = 0 - 0;
					while true do
						if (((1188 - (1151 + 36)) == v228) or ((2491 + 88) < (33 + 90))) then
							if ((v76.ArterialPrecision:IsAvailable() and v76.Deathmark:AnyDebuffUp()) or ((2526 - 1680) >= (4200 - (1552 + 280)))) then
								if (v20(v76.Shi) or ((4846 - (64 + 770)) <= (2280 + 1078))) then
									return "Cast Shiv (Arterial Precision)";
								end
							end
							if (((3391 - 1897) <= (534 + 2471)) and not v76.Kingsbane:IsAvailable() and not v76.ArterialPrecision:IsAvailable()) then
								if (v76.Sepsis:IsAvailable() or ((4354 - (157 + 1086)) == (4270 - 2136))) then
									if (((10314 - 7959) == (3612 - 1257)) and (((v76.Shiv:ChargesFractional() > ((0.9 - 0) + v21(v76.LightweightShiv:IsAvailable()))) and (v102 > (824 - (599 + 220)))) or v15:DebuffUp(v76.Sepsis) or v15:DebuffUp(v76.Deathmark))) then
										if (v20(v76.Shiv) or ((1170 - 582) <= (2363 - (1813 + 118)))) then
											return "Cast Shiv (Sepsis)";
										end
									end
								elseif (((3507 + 1290) >= (5112 - (841 + 376))) and (not v76.CrimsonTempest:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest))) then
									if (((5012 - 1435) == (831 + 2746)) and v20(v76.Shiv)) then
										return "Cast Shiv";
									end
								end
							end
							break;
						end
						if (((10355 - 6561) > (4552 - (464 + 395))) and (v228 == (0 - 0))) then
							if (v10.BossFilteredFightRemains("<=", v76.Shiv:Charges() * (4 + 4)) or ((2112 - (467 + 370)) == (8472 - 4372))) then
								if (v20(v76.Shiv) or ((1168 + 423) >= (12272 - 8692))) then
									return "Cast Shiv (End of Fight)";
								end
							end
							if (((154 + 829) <= (4206 - 2398)) and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom)) then
								if ((not v76.LightweightShiv:IsAvailable() and ((v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < (528 - (150 + 370)))) or (v76.Kingsbane:CooldownRemains() >= (1306 - (74 + 1208)))) and (not v76.CrimsonTempest:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest))) or ((5288 - 3138) <= (5676 - 4479))) then
									if (((2682 + 1087) >= (1563 - (14 + 376))) and v20(v76.Shiv)) then
										return "Cast Shiv (Kingsbane)";
									end
								end
								if (((2575 - 1090) == (961 + 524)) and v76.LightweightShiv:IsAvailable() and (v15:DebuffUp(v76.Kingsbane) or (v76.Kingsbane:CooldownRemains() <= (1 + 0)))) then
									if (v20(v76.Shiv) or ((3162 + 153) <= (8151 - 5369))) then
										return "Cast Shiv (Kingsbane Lightweight)";
									end
								end
							end
							v228 = 1 + 0;
						end
					end
				end
				v172 = 80 - (23 + 55);
			end
			if ((v172 == (9 - 5)) or ((585 + 291) >= (2662 + 302))) then
				return v88;
			end
			if ((v172 == (4 - 1)) or ((703 + 1529) > (3398 - (652 + 249)))) then
				if ((v76.Deathmark:AnyDebuffUp() and (not v88 or v54)) or ((5646 - 3536) <= (2200 - (708 + 1160)))) then
					if (((10005 - 6319) > (5782 - 2610)) and v88) then
						v128();
					else
						v88 = v128();
					end
				end
				if ((not v14:StealthUp(true, true) and (v117() <= (27 - (10 + 17))) and (v116() <= (0 + 0))) or ((6206 - (1400 + 332)) < (1572 - 752))) then
					if (((6187 - (242 + 1666)) >= (1234 + 1648)) and v88) then
						v129();
					else
						v88 = v129();
					end
				end
				if ((v76.ColdBlood:IsReady() and v14:DebuffDown(v76.ColdBlood) and (v91 >= (2 + 2)) and (v58 or not v88)) or ((1730 + 299) >= (4461 - (850 + 90)))) then
					if (v10.Press(v76.ColdBlood, v58) or ((3567 - 1530) >= (6032 - (360 + 1030)))) then
						return "Cast Cold Blood";
					end
				end
				v172 = 4 + 0;
			end
			if (((4854 - 3134) < (6133 - 1675)) and (v172 == (1661 - (909 + 752)))) then
				if ((v76.Sepsis:IsReady() and (v15:DebuffRemains(v76.Rupture) > (1243 - (109 + 1114))) and ((not v76.ImprovedGarrote:IsAvailable() and v15:DebuffUp(v76.Garrote)) or (v76.ImprovedGarrote:IsAvailable() and v76.Garrote:CooldownUp() and (v15:PMultiplier(v76.Garrote) <= (1 - 0)))) and (v15:FilteredTimeToDie(">", 4 + 6) or v10.BossFilteredFightRemains("<=", 252 - (6 + 236)))) or ((275 + 161) > (2432 + 589))) then
					if (((1681 - 968) <= (1479 - 632)) and v20(v76.Sepsis, nil, true)) then
						return "Cast Sepsis";
					end
				end
				v88 = v130();
				if (((3287 - (1076 + 57)) <= (663 + 3368)) and v88) then
					return v88;
				end
				v172 = 690 - (579 + 110);
			end
		end
	end
	local function v132()
		if (((365 + 4250) == (4081 + 534)) and v76.Kingsbane:IsAvailable() and v14:BuffUp(v76.Envenom)) then
			local v181 = 0 + 0;
			while true do
				if ((v181 == (407 - (174 + 233))) or ((10586 - 6796) == (877 - 377))) then
					if (((40 + 49) < (1395 - (663 + 511))) and v76.Shiv:IsReady() and (v15:DebuffUp(v76.Kingsbane) or v76.Kingsbane:CooldownUp()) and v15:DebuffDown(v76.ShivDebuff)) then
						if (((1833 + 221) >= (309 + 1112)) and v20(v76.Shiv)) then
							return "Cast Shiv (Stealth Kingsbane)";
						end
					end
					if (((2133 - 1441) < (1852 + 1206)) and v76.Kingsbane:IsReady() and (v14:BuffRemains(v76.ShadowDanceBuff) >= (4 - 2))) then
						if (v20(v76.Kingsbane, v68) or ((7876 - 4622) == (790 + 865))) then
							return "Cast Kingsbane (Dance)";
						end
					end
					break;
				end
			end
		end
		if ((v91 >= (7 - 3)) or ((924 + 372) == (449 + 4461))) then
			local v182 = 722 - (478 + 244);
			while true do
				if (((3885 - (440 + 77)) == (1532 + 1836)) and (v182 == (0 - 0))) then
					if (((4199 - (655 + 901)) < (708 + 3107)) and v15:DebuffUp(v76.Kingsbane) and (v14:BuffRemains(v76.Envenom) <= (2 + 0))) then
						if (((1292 + 621) > (1985 - 1492)) and v20(v76.Envenom, nil, nil, not v82)) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if (((6200 - (695 + 750)) > (11705 - 8277)) and v107 and v115() and v14:BuffDown(v76.ShadowDanceBuff)) then
						if (((2131 - 750) <= (9527 - 7158)) and v20(v76.Envenom, nil, nil, not v82)) then
							return "Cast Envenom (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if ((v27 and v76.CrimsonTempest:IsReady() and v76.Nightstalker:IsAvailable() and (v86 >= (354 - (285 + 66))) and (v91 >= (8 - 4)) and not v76.Deathmark:IsReady()) or ((6153 - (682 + 628)) == (659 + 3425))) then
			for v210, v211 in v30(v85) do
				if (((4968 - (176 + 123)) > (152 + 211)) and v122(v211, v76.CrimsonTempest, v94) and v211:FilteredTimeToDie(">", 5 + 1, -v211:DebuffRemains(v76.CrimsonTempest))) then
					if (v20(v76.CrimsonTempest) or ((2146 - (239 + 30)) >= (854 + 2284))) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
			end
		end
		if (((4558 + 184) >= (6417 - 2791)) and v76.Garrote:IsCastable() and (v117() > (0 - 0))) then
			local function v183(v212)
				return v212:DebuffRemains(v76.Garrote);
			end
			local function v184(v213)
				return ((v213:PMultiplier(v76.Garrote) <= (316 - (306 + 9))) or (v213:DebuffRemains(v76.Garrote) < ((41 - 29) / v75.ExsanguinatedRate(v213, v76.Garrote))) or ((v118() > (0 + 0)) and (v76.Garrote:AuraActiveCount() < v86))) and not v107 and (v213:FilteredTimeToDie(">", 2 + 0, -v213:DebuffRemains(v76.Garrote)) or v213:TimeToDieIsNotValid()) and v75.CanDoTUnit(v213, v96);
			end
			if (v27 or ((2186 + 2354) == (2619 - 1703))) then
				local v218 = 1375 - (1140 + 235);
				local v219;
				while true do
					if ((v218 == (0 + 0)) or ((1061 + 95) > (1116 + 3229))) then
						v219 = v124("min", v183, v184);
						if (((2289 - (33 + 19)) < (1535 + 2714)) and v219 and (v219:GUID() ~= v15:GUID())) then
							v20(v219, v76.Garrote);
						end
						break;
					end
				end
			end
			if (v184(v15) or ((8041 - 5358) < (11 + 12))) then
				if (((1366 - 669) <= (775 + 51)) and v20(v76.Garrote, nil, nil, not v82)) then
					return "Cast Garrote (Improved Garrote)";
				end
			end
			if (((1794 - (586 + 103)) <= (108 + 1068)) and (v92 >= ((2 - 1) + ((1490 - (1309 + 179)) * v21(v76.ShroudedSuffocation:IsAvailable()))))) then
				local v220 = 0 - 0;
				while true do
					if (((1471 + 1908) <= (10237 - 6425)) and (v220 == (0 + 0))) then
						if ((v14:BuffDown(v76.ShadowDanceBuff) and ((v15:PMultiplier(v76.Garrote) <= (1 - 0)) or (v15:DebuffUp(v76.Deathmark) and (v116() < (5 - 2))))) or ((1397 - (295 + 314)) >= (3969 - 2353))) then
							if (((3816 - (1300 + 662)) <= (10610 - 7231)) and v20(v76.Garrote, nil, nil, not v82)) then
								return "Cast Garrote (Improved Garrote Low CP)";
							end
						end
						if (((6304 - (1178 + 577)) == (2363 + 2186)) and ((v15:PMultiplier(v76.Garrote) <= (2 - 1)) or (v15:DebuffRemains(v76.Garrote) < (1417 - (851 + 554))))) then
							if (v20(v76.Garrote, nil, nil, not v82) or ((2673 + 349) >= (8386 - 5362))) then
								return "Cast Garrote (Improved Garrote Low CP 2)";
							end
						end
						break;
					end
				end
			end
		end
		if (((10468 - 5648) > (2500 - (115 + 187))) and (v91 >= (4 + 0)) and (v15:PMultiplier(v76.Rupture) <= (1 + 0)) and (v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.Deathmark))) then
			if (v20(v76.Rupture, nil, nil, not v82) or ((4181 - 3120) >= (6052 - (160 + 1001)))) then
				return "Cast Rupture (Nightstalker)";
			end
		end
	end
	local function v133()
		local v174 = 0 + 0;
		while true do
			if (((942 + 422) <= (9156 - 4683)) and (v174 == (359 - (237 + 121)))) then
				if ((v76.Rupture:IsReady() and (v91 >= (901 - (525 + 372)))) or ((6815 - 3220) <= (9 - 6))) then
					local v229 = 142 - (96 + 46);
					local v230;
					while true do
						if (((778 - (643 + 134)) == v229) or ((1687 + 2985) == (9236 - 5384))) then
							function v230(v246)
								return v122(v246, v76.Rupture, v93) and (v246:PMultiplier(v76.Rupture) <= (3 - 2)) and (v246:FilteredTimeToDie(">", v97, -v246:DebuffRemains(v76.Rupture)) or v246:TimeToDieIsNotValid());
							end
							if (((1496 + 63) == (3058 - 1499)) and v230(v15) and v75.CanDoTUnit(v15, v95)) then
								if (v20(v76.Rupture, nil, nil, not v82) or ((3581 - 1829) <= (1507 - (316 + 403)))) then
									return "Cast Rupture";
								end
							end
							v229 = 2 + 0;
						end
						if (((0 - 0) == v229) or ((1412 + 2495) == (445 - 268))) then
							v97 = 3 + 1 + (v21(v76.DashingScoundrel:IsAvailable()) * (2 + 3)) + (v21(v76.Doomblade:IsAvailable()) * (17 - 12)) + (v21(v106) * (28 - 22));
							v230 = nil;
							v229 = 1 - 0;
						end
						if (((199 + 3271) > (1092 - 537)) and (v229 == (1 + 1))) then
							if ((v27 and (not v106 or not v108)) or ((2859 - 1887) == (662 - (12 + 5)))) then
								v123(v76.Rupture, v230, v97, v87);
							end
							break;
						end
					end
				end
				if (((12358 - 9176) >= (4512 - 2397)) and v76.Garrote:IsCastable() and (v92 >= (1 - 0)) and (v116() <= (0 - 0)) and ((v15:PMultiplier(v76.Garrote) <= (1 + 0)) or ((v15:DebuffRemains(v76.Garrote) < v89) and (v86 >= (1976 - (1656 + 317))))) and (v15:DebuffRemains(v76.Garrote) < (v89 * (2 + 0))) and (v86 >= (3 + 0)) and (v15:FilteredTimeToDie(">", 10 - 6, -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) then
					if (((19159 - 15266) < (4783 - (5 + 349))) and v20(v76.Garrote, nil, nil, not v82)) then
						return "Garrote (Fallback)";
					end
				end
				v174 = 9 - 7;
			end
			if ((v174 == (1271 - (266 + 1005))) or ((1890 + 977) < (6499 - 4594))) then
				if ((v27 and v76.CrimsonTempest:IsReady() and (v86 >= (2 - 0)) and (v91 >= (1700 - (561 + 1135))) and (v104 > (32 - 7)) and not v76.Deathmark:IsReady()) or ((5903 - 4107) >= (5117 - (507 + 559)))) then
					for v238, v239 in v30(v85) do
						if (((4062 - 2443) <= (11616 - 7860)) and v122(v239, v76.CrimsonTempest, v94) and (v239:PMultiplier(v76.CrimsonTempest) <= (389 - (212 + 176))) and v239:FilteredTimeToDie(">", 911 - (250 + 655), -v239:DebuffRemains(v76.CrimsonTempest))) then
							if (((1647 - 1043) == (1054 - 450)) and v20(v76.CrimsonTempest)) then
								return "Cast Crimson Tempest (AoE High Energy)";
							end
						end
					end
				end
				if ((v76.Garrote:IsCastable() and (v92 >= (1 - 0))) or ((6440 - (1869 + 87)) == (3121 - 2221))) then
					local v231 = 1901 - (484 + 1417);
					local v232;
					while true do
						if (((0 - 0) == v231) or ((7472 - 3013) <= (1886 - (48 + 725)))) then
							v232 = nil;
							function v232(v247)
								return v122(v247, v76.Garrote) and (v247:PMultiplier(v76.Garrote) <= (1 - 0));
							end
							v231 = 2 - 1;
						end
						if (((2111 + 1521) > (9080 - 5682)) and ((1 + 0) == v231)) then
							if (((1190 + 2892) <= (5770 - (152 + 701))) and v232(v15) and v75.CanDoTUnit(v15, v96) and (v15:FilteredTimeToDie(">", 1323 - (430 + 881), -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) then
								if (((1851 + 2981) >= (2281 - (557 + 338))) and v29(v76.Garrote, nil, not v82)) then
									return "Pool for Garrote (ST)";
								end
							end
							if (((41 + 96) == (385 - 248)) and v27 and not v106 and (v86 >= (6 - 4))) then
								v123(v76.Garrote, v232, 31 - 19, v87);
							end
							break;
						end
					end
				end
				v174 = 2 - 1;
			end
			if ((v174 == (803 - (499 + 302))) or ((2436 - (39 + 827)) >= (11958 - 7626))) then
				return false;
			end
		end
	end
	local function v134()
		local v175 = 0 - 0;
		while true do
			if ((v175 == (15 - 11)) or ((6239 - 2175) <= (156 + 1663))) then
				if (v76.Mutilate:IsCastable() or ((14593 - 9607) < (252 + 1322))) then
					if (((7003 - 2577) > (276 - (103 + 1))) and v29(v76.Mutilate, nil, not v82)) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
			if (((1140 - (475 + 79)) > (983 - 528)) and (v175 == (9 - 6))) then
				if (((107 + 719) == (727 + 99)) and (v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff) or v14:BuffUp(v76.SepsisBuff)) and (v15:DebuffDown(v76.Kingsbane) or v15:DebuffDown(v76.Deathmark) or v14:BuffUp(v76.BlindsideBuff))) then
					if (v29(v76.Ambush, nil, not v82) or ((5522 - (1395 + 108)) > (12923 - 8482))) then
						return "Cast Ambush";
					end
				end
				if (((3221 - (7 + 1197)) < (1858 + 2403)) and v76.Mutilate:IsCastable() and (v86 == (1 + 1)) and v15:DebuffDown(v76.DeadlyPoisonDebuff, true) and v15:DebuffDown(v76.AmplifyingPoisonDebuff, true)) then
					local v233 = v15:GUID();
					for v240, v241 in v30(v87) do
						if (((5035 - (27 + 292)) > (234 - 154)) and (v241:GUID() ~= v233) and (v241:DebuffUp(v76.Garrote) or v241:DebuffUp(v76.Rupture)) and not v241:DebuffUp(v76.DeadlyPoisonDebuff, true) and not v241:DebuffUp(v76.AmplifyingPoisonDebuff, true)) then
							v20(v241, v76.Mutilate);
							break;
						end
					end
				end
				v175 = 4 - 0;
			end
			if ((v175 == (0 - 0)) or ((6915 - 3408) == (6231 - 2959))) then
				if ((v76.Envenom:IsReady() and (v91 >= (143 - (43 + 96))) and (v101 or (v15:DebuffStack(v76.AmplifyingPoisonDebuff) >= (81 - 61)) or (v91 > v75.CPMaxSpend()) or not v107)) or ((1980 - 1104) >= (2552 + 523))) then
					if (((1229 + 3123) > (5047 - 2493)) and v20(v76.Envenom, nil, nil, not v82)) then
						return "Cast Envenom";
					end
				end
				if (not ((v92 > (1 + 0)) or v101 or not v107) or ((8257 - 3851) < (1273 + 2770))) then
					return false;
				end
				v175 = 1 + 0;
			end
			if ((v175 == (1753 - (1414 + 337))) or ((3829 - (1642 + 298)) >= (8818 - 5435))) then
				if (((5442 - 3550) <= (8113 - 5379)) and v28 and v76.EchoingReprimand:IsReady()) then
					if (((633 + 1290) < (1726 + 492)) and v20(v76.EchoingReprimand, nil, not v82)) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((3145 - (357 + 615)) > (267 + 112)) and v76.FanofKnives:IsCastable()) then
					local v234 = 0 - 0;
					while true do
						if ((v234 == (0 + 0)) or ((5552 - 2961) == (2727 + 682))) then
							if (((307 + 4207) > (2090 + 1234)) and v27 and (v86 >= (1302 - (384 + 917))) and not v100 and (v86 >= ((699 - (128 + 569)) + v21(v14:StealthUp(true, false)) + v21(v76.DragonTemperedBlades:IsAvailable())))) then
								if (v29(v76.FanofKnives) or ((1751 - (1407 + 136)) >= (6715 - (687 + 1200)))) then
									return "Cast Fan of Knives";
								end
							end
							if ((v27 and v14:BuffUp(v76.DeadlyPoison) and (v86 >= (1713 - (556 + 1154)))) or ((5568 - 3985) > (3662 - (9 + 86)))) then
								for v251, v252 in v30(v85) do
									if ((not v252:DebuffUp(v76.DeadlyPoisonDebuff, true) and (not v100 or v252:DebuffUp(v76.Garrote) or v252:DebuffUp(v76.Rupture))) or ((1734 - (275 + 146)) == (130 + 664))) then
										if (((3238 - (29 + 35)) > (12861 - 9959)) and v29(v76.FanofKnives)) then
											return "Cast Fan of Knives (DP Refresh)";
										end
									end
								end
							end
							break;
						end
					end
				end
				v175 = 8 - 5;
			end
			if (((18187 - 14067) <= (2775 + 1485)) and ((1013 - (53 + 959)) == v175)) then
				if ((not v107 and v76.CausticSpatter:IsAvailable() and v15:DebuffUp(v76.Rupture) and (v15:DebuffRemains(v76.CausticSpatterDebuff) <= (410 - (312 + 96)))) or ((1532 - 649) > (5063 - (147 + 138)))) then
					local v235 = 899 - (813 + 86);
					while true do
						if ((v235 == (0 + 0)) or ((6707 - 3087) >= (5383 - (18 + 474)))) then
							if (((1437 + 2821) > (3058 - 2121)) and v76.Mutilate:IsCastable()) then
								if (v20(v76.Mutilate, nil, nil, not v82) or ((5955 - (860 + 226)) < (1209 - (121 + 182)))) then
									return "Cast Mutilate (Casutic)";
								end
							end
							if (((v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff))) or ((151 + 1074) > (5468 - (988 + 252)))) then
								if (((376 + 2952) > (702 + 1536)) and v20(v76.Ambush, nil, nil, not v82)) then
									return "Cast Ambush (Caustic)";
								end
							end
							break;
						end
					end
				end
				if (((5809 - (49 + 1921)) > (2295 - (223 + 667))) and v76.SerratedBoneSpike:IsReady()) then
					if (not v15:DebuffUp(v76.SerratedBoneSpikeDebuff) or ((1345 - (51 + 1)) <= (872 - 365))) then
						if (v20(v76.SerratedBoneSpike, nil, not v83) or ((6201 - 3305) < (1930 - (146 + 979)))) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v243 = 0 + 0;
						while true do
							if (((2921 - (311 + 294)) == (6458 - 4142)) and ((0 + 0) == v243)) then
								if (v27 or ((4013 - (496 + 947)) == (2891 - (1233 + 125)))) then
									if (v74.CastTargetIf(v76.SerratedBoneSpike, v84, "min", v126, v127) or ((359 + 524) == (1310 + 150))) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if ((v116() < (0.8 + 0)) or ((6264 - (963 + 682)) <= (834 + 165))) then
									if ((v10.BossFightRemains() <= (1509 - (504 + 1000))) or ((v76.SerratedBoneSpike:MaxCharges() - v76.SerratedBoneSpike:ChargesFractional()) <= (0.25 + 0)) or ((3106 + 304) > (389 + 3727))) then
										if (v20(v76.SerratedBoneSpike, nil, true, not v83) or ((1331 - 428) >= (2614 + 445))) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif ((not v107 and v15:DebuffUp(v76.ShivDebuff)) or ((2313 + 1663) < (3039 - (156 + 26)))) then
										if (((2841 + 2089) > (3609 - 1302)) and v20(v76.SerratedBoneSpike, nil, true, not v83)) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v175 = 166 - (149 + 15);
			end
		end
	end
	local function v135()
		local v176 = 960 - (890 + 70);
		while true do
			if ((v176 == (121 - (39 + 78))) or ((4528 - (14 + 468)) < (2838 - 1547))) then
				if (v88 or ((11853 - 7612) == (1830 + 1715))) then
					return v88;
				end
				v88 = v75.Feint();
				if (v88 or ((2431 + 1617) > (900 + 3332))) then
					return v88;
				end
				if ((not v14:AffectingCombat() and not v14:IsMounted() and v74.TargetIsValid()) or ((791 + 959) >= (910 + 2563))) then
					local v236 = 0 - 0;
					while true do
						if (((3130 + 36) == (11125 - 7959)) and (v236 == (0 + 0))) then
							v88 = v75.Stealth(v76.Stealth2, nil);
							if (((1814 - (12 + 39)) < (3465 + 259)) and v88) then
								return "Stealth (OOC): " .. v88;
							end
							break;
						end
					end
				end
				v176 = 15 - 10;
			end
			if (((202 - 145) <= (808 + 1915)) and (v176 == (2 + 0))) then
				v91 = v75.EffectiveComboPoints(v14:ComboPoints());
				v92 = v14:ComboPointsMax() - v91;
				v93 = ((9 - 5) + (v91 * (3 + 1))) * (0.3 - 0);
				v94 = ((1714 - (1596 + 114)) + (v91 * (4 - 2))) * (713.3 - (164 + 549));
				v176 = 1441 - (1059 + 379);
			end
			if ((v176 == (3 - 0)) or ((1073 + 997) == (75 + 368))) then
				v95 = v76.Envenom:Damage() * v63;
				v96 = v76.Mutilate:Damage() * v64;
				v100 = v46();
				v88 = v75.CrimsonVial();
				v176 = 396 - (145 + 247);
			end
			if ((v176 == (0 + 0)) or ((1250 + 1455) == (4129 - 2736))) then
				v73();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v176 = 1 + 0;
			end
			if ((v176 == (5 + 0)) or ((7470 - 2869) < (781 - (254 + 466)))) then
				v75.Poisons();
				if (not v14:AffectingCombat() or ((1950 - (544 + 16)) >= (15076 - 10332))) then
					if (not v14:BuffUp(v75.VanishBuffSpell()) or ((2631 - (294 + 334)) > (4087 - (236 + 17)))) then
						local v244 = 0 + 0;
						while true do
							if ((v244 == (0 + 0)) or ((587 - 431) > (18526 - 14613))) then
								v88 = v75.Stealth(v75.StealthSpell());
								if (((101 + 94) == (161 + 34)) and v88) then
									return v88;
								end
								break;
							end
						end
					end
					if (((3899 - (413 + 381)) >= (76 + 1720)) and v74.TargetIsValid()) then
						local v245 = 0 - 0;
						while true do
							if (((11374 - 6995) >= (4101 - (582 + 1388))) and (v245 == (0 - 0))) then
								if (((2752 + 1092) >= (2407 - (326 + 38))) and v28) then
									if ((v26 and v76.MarkedforDeath:IsCastable() and (v14:ComboPointsDeficit() >= v75.CPMaxSpend()) and v74.TargetIsValid()) or ((9560 - 6328) <= (3898 - 1167))) then
										if (((5525 - (47 + 573)) == (1730 + 3175)) and v10.Press(v76.MarkedforDeath, v59)) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (not v14:BuffUp(v76.SliceandDice) or ((17565 - 13429) >= (7159 - 2748))) then
									if ((v76.SliceandDice:IsReady() and (v91 >= (1666 - (1269 + 395)))) or ((3450 - (76 + 416)) == (4460 - (319 + 124)))) then
										if (((2806 - 1578) >= (1820 - (564 + 443))) and v10.Press(v76.SliceandDice)) then
											return "Cast Slice and Dice";
										end
									end
								end
								break;
							end
						end
					end
				end
				v75.MfDSniping(v76.MarkedforDeath);
				if (v74.TargetIsValid() or ((9564 - 6109) > (4508 - (337 + 121)))) then
					local v237 = 0 - 0;
					while true do
						if (((809 - 566) == (2154 - (1261 + 650))) and (v237 == (0 + 0))) then
							v103 = v75.PoisonedBleeds();
							v104 = v14:EnergyRegen() + ((v103 * (8 - 2)) / ((1819 - (772 + 1045)) * v14:SpellHaste()));
							v105 = v14:EnergyDeficit() / v104;
							v106 = v104 > (5 + 30);
							v237 = 145 - (102 + 42);
						end
						if ((v237 == (1846 - (1524 + 320))) or ((1541 - (1049 + 221)) > (1728 - (18 + 138)))) then
							if (((6704 - 3965) < (4395 - (67 + 1035))) and (v14:StealthUp(true, false) or (v117() > (348 - (136 + 212))) or (v116() > (0 - 0)))) then
								local v249 = 0 + 0;
								while true do
									if ((v249 == (0 + 0)) or ((5546 - (240 + 1364)) < (2216 - (1050 + 32)))) then
										v88 = v132();
										if (v88 or ((9615 - 6922) == (2942 + 2031))) then
											return v88 .. " (Stealthed)";
										end
										break;
									end
								end
							end
							v88 = v131();
							if (((3201 - (331 + 724)) == (174 + 1972)) and v88) then
								return v88;
							end
							if (not v14:BuffUp(v76.SliceandDice) or ((2888 - (269 + 375)) == (3949 - (267 + 458)))) then
								if ((v76.SliceandDice:IsReady() and (v14:ComboPoints() >= (1 + 1)) and v15:DebuffUp(v76.Rupture)) or (not v76.CutToTheChase:IsAvailable() and (v14:ComboPoints() >= (7 - 3)) and (v14:BuffRemains(v76.SliceandDice) < (((819 - (667 + 151)) + v14:ComboPoints()) * (1498.8 - (1410 + 87))))) or ((6801 - (1504 + 393)) <= (5178 - 3262))) then
									if (((233 - 143) <= (1861 - (461 + 335))) and v20(v76.SliceandDice)) then
										return "Cast Slice and Dice";
									end
								end
							elseif (((614 + 4188) == (6563 - (1730 + 31))) and v83 and v76.CutToTheChase:IsAvailable()) then
								if ((v76.Envenom:IsReady() and (v14:BuffRemains(v76.SliceandDice) < (1672 - (728 + 939))) and (v14:ComboPoints() >= (14 - 10))) or ((4624 - 2344) <= (1170 - 659))) then
									if (v20(v76.Envenom, nil, nil, not v82) or ((2744 - (138 + 930)) <= (424 + 39))) then
										return "Cast Envenom (CttC)";
									end
								end
							elseif (((3025 + 844) == (3316 + 553)) and v76.PoisonedKnife:IsCastable() and v15:IsInRange(122 - 92) and not v14:StealthUp(true, true) and (v86 == (1766 - (459 + 1307))) and (v14:EnergyTimeToMax() <= (v14:GCD() * (1871.5 - (474 + 1396))))) then
								if (((2021 - 863) <= (2449 + 164)) and v20(v76.PoisonedKnife)) then
									return "Cast Poisoned Knife";
								end
							end
							v237 = 1 + 2;
						end
						if ((v237 == (8 - 5)) or ((300 + 2064) <= (6673 - 4674))) then
							v88 = v133();
							if (v88 or ((21465 - 16543) < (785 - (562 + 29)))) then
								return v88;
							end
							v88 = v134();
							if (v88 or ((1783 + 308) < (1450 - (374 + 1045)))) then
								return v88;
							end
							v237 = 4 + 0;
						end
						if ((v237 == (2 - 1)) or ((3068 - (448 + 190)) >= (1573 + 3299))) then
							v101 = v119();
							v102 = v120();
							v108 = v121();
							v107 = v86 < (1 + 1);
							v237 = 2 + 0;
						end
						if ((v237 == (15 - 11)) or ((14821 - 10051) < (3229 - (1307 + 187)))) then
							if (v28 or ((17602 - 13163) <= (5502 - 3152))) then
								local v250 = 0 - 0;
								while true do
									if ((v250 == (683 - (232 + 451))) or ((4277 + 202) < (3946 + 520))) then
										if (((3111 - (510 + 54)) > (2468 - 1243)) and v76.ArcaneTorrent:IsCastable() and v82 and (v14:EnergyDeficit() > (51 - (13 + 23)))) then
											if (((9105 - 4434) > (3842 - 1168)) and v20(v76.ArcaneTorrent, v32)) then
												return "Cast Arcane Torrent";
											end
										end
										if ((v76.ArcanePulse:IsCastable() and v82) or ((6714 - 3018) < (4415 - (830 + 258)))) then
											if (v20(v76.ArcanePulse, v32) or ((16022 - 11480) == (1859 + 1111))) then
												return "Cast Arcane Pulse";
											end
										end
										v250 = 1 + 0;
									end
									if (((1693 - (860 + 581)) <= (7292 - 5315)) and (v250 == (1 + 0))) then
										if ((v76.LightsJudgment:IsCastable() and v82) or ((1677 - (237 + 4)) == (8871 - 5096))) then
											if (v20(v76.LightsJudgment, v32) or ((4093 - 2475) < (1763 - 833))) then
												return "Cast Lights Judgment";
											end
										end
										if (((3866 + 857) > (2386 + 1767)) and v76.BagofTricks:IsCastable() and v82) then
											if (v20(v76.BagofTricks, v32) or ((13795 - 10141) >= (1998 + 2656))) then
												return "Cast Bag of Tricks";
											end
										end
										break;
									end
								end
							end
							if (((518 + 433) <= (2922 - (85 + 1341))) and (v76.Ambush:IsCastable() or v76.AmbushOverride:IsCastable()) and v83) then
								if (v20(v76.Ambush) or ((2962 - 1226) == (1612 - 1041))) then
									return "Fill Ambush";
								end
							end
							if ((v76.Mutilate:IsCastable() and v83) or ((1268 - (45 + 327)) > (8998 - 4229))) then
								if (v20(v76.Mutilate) or ((1547 - (444 + 58)) <= (444 + 576))) then
									return "Fill Mutilate";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v176 == (1 + 0)) or ((568 + 592) <= (950 - 622))) then
				v82 = v15:IsInMeleeRange(1737 - (64 + 1668));
				v83 = v15:IsInMeleeRange(1983 - (1227 + 746));
				if (((11704 - 7896) > (5426 - 2502)) and v27) then
					v84 = v14:GetEnemiesInRange(524 - (415 + 79));
					v85 = v14:GetEnemiesInMeleeRange(1 + 9);
					v86 = #v85;
					v87 = v14:GetEnemiesInMeleeRange(496 - (142 + 349));
				else
					v84 = {};
					v85 = {};
					v86 = 1 + 0;
					v87 = {};
				end
				v89, v90 = (2 - 0) * v14:SpellHaste(), (1 + 0) * v14:SpellHaste();
				v176 = 2 + 0;
			end
		end
	end
	local function v136()
		local v177 = 0 - 0;
		while true do
			if (((5755 - (1710 + 154)) < (5237 - (200 + 118))) and (v177 == (0 + 0))) then
				v76.Deathmark:RegisterAuraTracking();
				v76.Sepsis:RegisterAuraTracking();
				v177 = 1 - 0;
			end
			if ((v177 == (1 - 0)) or ((1985 + 249) <= (1486 + 16))) then
				v76.Garrote:RegisterAuraTracking();
				v10.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v10.SetAPL(139 + 120, v135, v136);
end;
return v0["Epix_Rogue_Assassination.lua"]();

