local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (709 - (201 + 508))) or ((4612 - (497 + 345)) >= (104 + 3937))) then
			v6 = v0[v4];
			if (not v6 or ((641 + 3150) <= (2944 - (605 + 728)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((210 + 4368) <= (7424 - 5416))) then
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
		local v138 = 0 + 0;
		while true do
			if (((3116 - 1991) <= (1568 + 508)) and (v138 == (492 - (457 + 32)))) then
				v56 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v57 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v58 = EpicSettings.Settings['ColdBloodOffGCD'];
				v59 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v60 = EpicSettings.Settings['CrimsonVialHP'] or (1 + 0);
				v61 = EpicSettings.Settings['FeintHP'] or (1403 - (832 + 570));
				v138 = 4 + 0;
			end
			if ((v138 == (1 + 1)) or ((2629 - 1886) >= (2120 + 2279))) then
				v46 = EpicSettings.Settings['UsePriorityRotation'];
				v51 = EpicSettings.Settings['STMfDAsDPSCD'];
				v52 = EpicSettings.Settings['KidneyShotInterrupt'];
				v53 = EpicSettings.Settings['RacialsGCD'];
				v54 = EpicSettings.Settings['RacialsOffGCD'];
				v55 = EpicSettings.Settings['VanishOffGCD'];
				v138 = 799 - (588 + 208);
			end
			if (((3112 - 1957) < (3473 - (884 + 916))) and (v138 == (10 - 5))) then
				v68 = EpicSettings.Settings['KingsbaneGCD'];
				v69 = EpicSettings.Settings['ShivGCD'];
				v70 = EpicSettings.Settings['DeathmarkOffGCD'];
				v72 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v71 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
			if ((v138 == (0 + 0)) or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v138 = 606 - (316 + 289);
			end
			if (((9860 - 6093) == (174 + 3593)) and (v138 == (1457 - (666 + 787)))) then
				v62 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['EnvenomDMGOffset'] or (426 - (360 + 65));
				v64 = EpicSettings.Settings['MutilateDMGOffset'] or (1 + 0);
				v65 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v66 = EpicSettings.Settings['PotionTypeSelected'];
				v67 = EpicSettings.Settings['ExsanguinateGCD'];
				v138 = 259 - (79 + 175);
			end
			if (((6446 - 2357) == (3191 + 898)) and (v138 == (2 - 1))) then
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (899 - (503 + 396));
				v41 = EpicSettings.Settings['InterruptThreshold'] or (181 - (92 + 89));
				v43 = EpicSettings.Settings['PoisonRefresh'];
				v44 = EpicSettings.Settings['PoisonRefreshCombat'];
				v45 = EpicSettings.Settings['RangedMultiDoT'];
				v138 = 3 - 1;
			end
		end
	end
	local v74 = v10.Commons.Everyone;
	v10.Commons.Rogue = {};
	local v76 = v10.Commons.Rogue;
	local v77 = v16.Rogue.Assassination;
	local v78 = v19.Rogue.Assassination;
	local v79 = v18.Rogue.Assassination;
	local v80 = {v79.AlgetharPuzzleBox,v79.AshesoftheEmbersoul,v79.WitherbarksBranch};
	local v81, v82, v83, v84;
	local v85, v86, v87, v88;
	local v89;
	local v90, v91 = (1 + 1) * v14:SpellHaste(), (2 - 1) * v14:SpellHaste();
	local v92, v93;
	local v94, v95, v96, v97, v98, v99, v100;
	local v101;
	local v102, v103, v104, v105, v106, v107, v108, v109;
	local v110 = 0 + 0;
	local v111 = v14:GetEquipment();
	local v112 = (v111[7 + 6] and v18(v111[39 - 26])) or v18(0 + 0);
	local v113 = (v111[20 - 6] and v18(v111[1258 - (485 + 759)])) or v18(0 - 0);
	local function v114()
		if (((5647 - (442 + 747)) >= (2809 - (832 + 303))) and v112:HasStatAnyDps() and (not v113:HasStatAnyDps() or (v112:Cooldown() >= v113:Cooldown()))) then
			v110 = 947 - (88 + 858);
		elseif (((297 + 675) <= (1174 + 244)) and v113:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v113:Cooldown() > v112:Cooldown()))) then
			v110 = 1 + 1;
		else
			v110 = 789 - (766 + 23);
		end
	end
	v114();
	v10:RegisterForEvent(function()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (1 - 0)) or ((13010 - 8072) < (16162 - 11400))) then
				v113 = (v111[1087 - (1036 + 37)] and v18(v111[10 + 4])) or v18(0 - 0);
				v114();
				break;
			end
			if ((v139 == (0 + 0)) or ((3984 - (641 + 839)) > (5177 - (910 + 3)))) then
				v111 = v14:GetEquipment();
				v112 = (v111[32 - 19] and v18(v111[1697 - (1466 + 218)])) or v18(0 + 0);
				v139 = 1149 - (556 + 592);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v115 = {{v77.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v77.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v92 > (1477 - (29 + 1448));
	end}};
	v77.Envenom:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v92 * (1389.22 - (135 + 1254)) * (3 - 2) * ((v15:DebuffUp(v77.ShivDebuff) and (4.3 - 3)) or (1 + 0)) * ((v77.DeeperStratagem:IsAvailable() and (1528.05 - (389 + 1138))) or (575 - (102 + 472))) * (1 + 0 + (v14:MasteryPct() / (56 + 44))) * (1 + 0 + (v14:VersatilityDmgPct() / (1645 - (320 + 1225))));
	end);
	v77.Mutilate:RegisterDamageFormula(function()
		return (v14:AttackPowerDamageMod() + v14:AttackPowerDamageMod(true)) * (0.485 - 0) * (1 + 0) * ((1465 - (157 + 1307)) + (v14:VersatilityDmgPct() / (1959 - (821 + 1038))));
	end);
	local function v116()
		return v14:BuffRemains(v77.MasterAssassinBuff) == (24947 - 14948);
	end
	local function v117()
		local v140 = 0 + 0;
		while true do
			if (((3823 - 1670) == (802 + 1351)) and (v140 == (0 - 0))) then
				if (v116() or ((1533 - (834 + 192)) >= (165 + 2426))) then
					return v14:GCDRemains() + 1 + 2;
				end
				return v14:BuffRemains(v77.MasterAssassinBuff);
			end
		end
	end
	local function v118()
		local v141 = 0 + 0;
		while true do
			if (((6941 - 2460) == (4785 - (300 + 4))) and (v141 == (0 + 0))) then
				if (v14:BuffUp(v77.ImprovedGarroteAura) or ((6094 - 3766) < (1055 - (112 + 250)))) then
					return v14:GCDRemains() + 2 + 1;
				end
				return v14:BuffRemains(v77.ImprovedGarroteBuff);
			end
		end
	end
	local function v119()
		local v142 = 0 - 0;
		while true do
			if (((2480 + 1848) == (2239 + 2089)) and (v142 == (0 + 0))) then
				if (((788 + 800) >= (990 + 342)) and v14:BuffUp(v77.IndiscriminateCarnageAura)) then
					return v14:GCDRemains() + (1424 - (1001 + 413));
				end
				return v14:BuffRemains(v77.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v46()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (882 - (244 + 638))) or ((4867 - (627 + 66)) > (12657 - 8409))) then
				if ((v87 < (604 - (512 + 90))) or ((6492 - (1665 + 241)) <= (799 - (373 + 344)))) then
					return false;
				elseif (((1743 + 2120) == (1023 + 2840)) and (v46 == "Always")) then
					return true;
				elseif (((v46 == "On Bosses") and v15:IsInBossList()) or ((743 - 461) <= (70 - 28))) then
					return true;
				elseif (((5708 - (35 + 1064)) >= (558 + 208)) and (v46 == "Auto")) then
					if (((v14:InstanceDifficulty() == (34 - 18)) and (v15:NPCID() == (555 + 138412))) or ((2388 - (298 + 938)) == (3747 - (233 + 1026)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v120()
		local v144 = 1666 - (636 + 1030);
		while true do
			if (((1750 + 1672) > (3273 + 77)) and ((0 + 0) == v144)) then
				if (((60 + 817) > (597 - (55 + 166))) and (v15:DebuffUp(v77.Deathmark) or v15:DebuffUp(v77.Kingsbane) or v14:BuffUp(v77.ShadowDanceBuff) or v15:DebuffUp(v77.ShivDebuff) or (v77.ThistleTea:FullRechargeTime() < (4 + 16)) or (v14:EnergyPercentage() >= (9 + 71)) or (v14:HasTier(118 - 87, 301 - (36 + 261)) and ((v14:BuffUp(v77.Envenom) and (v14:BuffRemains(v77.Envenom) <= (3 - 1))) or v10.BossFilteredFightRemains("<=", 1458 - (34 + 1334)))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v121()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (0 + 0)) or ((4401 - (1035 + 248)) <= (1872 - (20 + 1)))) then
				if (((v77.Deathmark:CooldownRemains() > v77.Sepsis:CooldownRemains()) and (v10.BossFightRemainsIsNotValid() or v10.BossFilteredFightRemains(">", v77.Deathmark:CooldownRemains()))) or ((86 + 79) >= (3811 - (134 + 185)))) then
					return v77.Deathmark:CooldownRemains();
				end
				return v77.Sepsis:CooldownRemains();
			end
		end
	end
	local function v122()
		local v146 = 1133 - (549 + 584);
		while true do
			if (((4634 - (314 + 371)) < (16670 - 11814)) and (v146 == (968 - (478 + 490)))) then
				if (not v77.ScentOfBlood:IsAvailable() or ((2266 + 2010) < (4188 - (786 + 386)))) then
					return true;
				end
				return v14:BuffStack(v77.ScentOfBloodBuff) >= v23(64 - 44, v77.ScentOfBlood:TalentRank() * (1381 - (1055 + 324)) * v87);
			end
		end
	end
	local function v123(v147, v148, v149)
		local v150 = 1340 - (1093 + 247);
		local v149;
		while true do
			if (((4168 + 522) > (434 + 3691)) and ((0 - 0) == v150)) then
				v149 = v149 or v148:PandemicThreshold();
				return v147:DebuffRefreshable(v148, v149);
			end
		end
	end
	local function v124(v151, v152, v153, v154)
		local v155 = 0 - 0;
		local v156;
		local v157;
		local v158;
		while true do
			if (((2 - 1) == v155) or ((125 - 75) >= (319 + 577))) then
				for v222, v223 in v30(v154) do
					if (((v223:GUID() ~= v158) and v74.UnitIsCycleValid(v223, v157, -v223:DebuffRemains(v151)) and v152(v223)) or ((6603 - 4889) >= (10195 - 7237))) then
						v156, v157 = v223, v223:TimeToDie();
					end
				end
				if (v156 or ((1125 + 366) < (1646 - 1002))) then
					v20(v156, v151);
				elseif (((1392 - (364 + 324)) < (2705 - 1718)) and v45) then
					v156, v157 = nil, v153;
					for v251, v252 in v30(v86) do
						if (((8921 - 5203) > (632 + 1274)) and (v252:GUID() ~= v158) and v74.UnitIsCycleValid(v252, v157, -v252:DebuffRemains(v151)) and v152(v252)) then
							v156, v157 = v252, v252:TimeToDie();
						end
					end
					if (v156 or ((4008 - 3050) > (5821 - 2186))) then
						v20(v156, v151);
					end
				end
				break;
			end
			if (((10632 - 7131) <= (5760 - (1249 + 19))) and (v155 == (0 + 0))) then
				v156, v157 = nil, v153;
				v158 = v15:GUID();
				v155 = 3 - 2;
			end
		end
	end
	local function v125(v159, v160, v161)
		local v162 = 1086 - (686 + 400);
		local v163;
		local v164;
		local v165;
		local v166;
		while true do
			if ((v162 == (3 + 0)) or ((3671 - (73 + 156)) < (13 + 2535))) then
				if (((3686 - (721 + 90)) >= (17 + 1447)) and v45) then
					v166(v86);
				end
				if ((v164 and (v165 == v163) and v161(v15)) or ((15575 - 10778) >= (5363 - (224 + 246)))) then
					return v15;
				end
				v162 = 5 - 1;
			end
			if (((3 - 1) == v162) or ((100 + 451) > (50 + 2018))) then
				function v166(v224)
					for v225, v226 in v30(v224) do
						local v227 = 0 + 0;
						local v228;
						while true do
							if (((4202 - 2088) > (3141 - 2197)) and (v227 == (514 - (203 + 310)))) then
								if ((v164 and (v228 == v165) and (v226:TimeToDie() > v164:TimeToDie())) or ((4255 - (1238 + 755)) >= (217 + 2879))) then
									v164, v165 = v226, v228;
								end
								break;
							end
							if ((v227 == (1534 - (709 + 825))) or ((4155 - 1900) >= (5152 - 1615))) then
								v228 = v160(v226);
								if ((not v164 and (v159 == "first")) or ((4701 - (196 + 668)) < (5156 - 3850))) then
									if (((6110 - 3160) == (3783 - (171 + 662))) and (v228 ~= (93 - (4 + 89)))) then
										v164, v165 = v226, v228;
									end
								elseif ((v159 == "min") or ((16553 - 11830) < (1201 + 2097))) then
									if (((4989 - 3853) >= (61 + 93)) and (not v164 or (v228 < v165))) then
										v164, v165 = v226, v228;
									end
								elseif ((v159 == "max") or ((1757 - (35 + 1451)) > (6201 - (28 + 1425)))) then
									if (((6733 - (941 + 1052)) >= (3023 + 129)) and (not v164 or (v228 > v165))) then
										v164, v165 = v226, v228;
									end
								end
								v227 = 1515 - (822 + 692);
							end
						end
					end
				end
				v166(v88);
				v162 = 3 - 0;
			end
			if ((v162 == (1 + 0)) or ((2875 - (45 + 252)) >= (3355 + 35))) then
				v164, v165 = nil, 0 + 0;
				v166 = nil;
				v162 = 4 - 2;
			end
			if (((474 - (114 + 319)) <= (2384 - 723)) and ((0 - 0) == v162)) then
				v163 = v160(v15);
				if (((384 + 217) < (5303 - 1743)) and (v159 == "first") and (v163 ~= (0 - 0))) then
					return v15;
				end
				v162 = 1964 - (556 + 1407);
			end
			if (((1441 - (741 + 465)) < (1152 - (170 + 295))) and (v162 == (3 + 1))) then
				if (((4179 + 370) > (2838 - 1685)) and v164 and v161(v164)) then
					return v164;
				end
				return nil;
			end
		end
	end
	local function v126(v167, v168, v169)
		local v170 = v15:TimeToDie();
		if (not v10.BossFightRemainsIsNotValid() or ((3875 + 799) < (2997 + 1675))) then
			v170 = v10.BossFightRemains();
		elseif (((2078 + 1590) < (5791 - (957 + 273))) and (v170 < v169)) then
			return false;
		end
		if ((v31((v170 - v169) / v167) > v31(((v170 - v169) - v168) / v167)) or ((122 + 333) == (1444 + 2161))) then
			return true;
		end
		return false;
	end
	local function v127(v171)
		local v172 = 0 - 0;
		while true do
			if ((v172 == (0 - 0)) or ((8134 - 5471) == (16399 - 13087))) then
				if (((6057 - (389 + 1391)) <= (2808 + 1667)) and v171:DebuffUp(v77.SerratedBoneSpikeDebuff)) then
					return 104088 + 895912;
				end
				return v171:TimeToDie();
			end
		end
	end
	local function v128(v173)
		return not v173:DebuffUp(v77.SerratedBoneSpikeDebuff);
	end
	local function v129()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (953 - (783 + 168))) or ((2919 - 2049) == (1170 + 19))) then
				return false;
			end
			if (((1864 - (309 + 2)) <= (9621 - 6488)) and (v174 == (1212 - (1090 + 122)))) then
				if (v77.BloodFury:IsCastable() or ((726 + 1511) >= (11791 - 8280))) then
					if (v10.Press(v77.BloodFury, v54) or ((907 + 417) > (4138 - (628 + 490)))) then
						return "Cast Blood Fury";
					end
				end
				if (v77.Berserking:IsCastable() or ((537 + 2455) == (4656 - 2775))) then
					if (((14194 - 11088) > (2300 - (431 + 343))) and v10.Press(v77.Berserking, v54)) then
						return "Cast Berserking";
					end
				end
				v174 = 1 - 0;
			end
			if (((8745 - 5722) < (3058 + 812)) and (v174 == (1 + 0))) then
				if (((1838 - (556 + 1139)) > (89 - (6 + 9))) and v77.Fireblood:IsCastable()) then
					if (((4 + 14) < (1082 + 1030)) and v10.Press(v77.Fireblood, v54)) then
						return "Cast Fireblood";
					end
				end
				if (((1266 - (28 + 141)) <= (631 + 997)) and v77.AncestralCall:IsCastable()) then
					if (((5715 - 1085) == (3280 + 1350)) and ((not v77.Kingsbane:IsAvailable() and v15:DebuffUp(v77.ShivDebuff)) or (v15:DebuffUp(v77.Kingsbane) and (v15:DebuffRemains(v77.Kingsbane) < (1325 - (486 + 831)))))) then
						if (((9211 - 5671) > (9445 - 6762)) and v10.Press(v77.AncestralCall, v54)) then
							return "Cast Ancestral Call";
						end
					end
				end
				v174 = 1 + 1;
			end
		end
	end
	local function v130()
		local v175 = 0 - 0;
		while true do
			if (((6057 - (668 + 595)) >= (2947 + 328)) and ((0 + 0) == v175)) then
				if (((4046 - 2562) == (1774 - (23 + 267))) and v77.ShadowDance:IsCastable() and not v77.Kingsbane:IsAvailable()) then
					local v229 = 1944 - (1129 + 815);
					while true do
						if (((1819 - (371 + 16)) < (5305 - (1326 + 424))) and (v229 == (0 - 0))) then
							if ((v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and ((v15:PMultiplier(v77.Garrote) <= (3 - 2)) or v123(v15, v77.Garrote)) and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (130 - (88 + 30))) or (v77.Deathmark:CooldownRemains() > (831 - (720 + 51)))) and (v93 >= math.min(v87, 8 - 4))) or ((2841 - (421 + 1355)) > (5902 - 2324))) then
								if ((v50 and (v14:EnergyPredicted() < (23 + 22))) or ((5878 - (286 + 797)) < (5143 - 3736))) then
									if (((3068 - 1215) < (5252 - (397 + 42))) and v20(v77.PoolEnergy)) then
										return "Pool for Shadow Dance (Garrote)";
									end
								end
								if (v20(v77.ShadowDance, v56) or ((882 + 1939) < (3231 - (24 + 776)))) then
									return "Cast Shadow Dance (Garrote)";
								end
							end
							if ((not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v15, v77.Rupture) and (v15:DebuffRemains(v77.Garrote) > (4 - 1)) and (v15:DebuffUp(v77.Deathmark) or (v77.Deathmark:CooldownRemains() > (845 - (222 + 563)))) and (v15:DebuffUp(v77.ShivDebuff) or (v15:DebuffRemains(v77.Deathmark) < (8 - 4)) or v15:DebuffUp(v77.Sepsis)) and (v15:DebuffRemains(v77.Sepsis) < (3 + 0))) or ((3064 - (23 + 167)) < (3979 - (690 + 1108)))) then
								if (v20(v77.ShadowDance, v56) or ((971 + 1718) <= (283 + 60))) then
									return "Cast Shadow Dance (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				if ((v77.Vanish:IsCastable() and not v14:IsTanking(v15)) or ((2717 - (40 + 808)) == (331 + 1678))) then
					local v230 = 0 - 0;
					while true do
						if ((v230 == (1 + 0)) or ((1876 + 1670) < (1274 + 1048))) then
							if ((not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v15, v77.Rupture) and (v15:DebuffRemains(v77.Garrote) > (574 - (47 + 524))) and v15:DebuffUp(v77.Deathmark) and (v15:DebuffUp(v77.ShivDebuff) or (v15:DebuffRemains(v77.Deathmark) < (3 + 1)) or v15:DebuffUp(v77.Sepsis)) and (v15:DebuffRemains(v77.Sepsis) < (8 - 5))) or ((3112 - 1030) == (10885 - 6112))) then
								if (((4970 - (1165 + 561)) > (32 + 1023)) and v20(v77.Vanish, v55)) then
									return "Cast Vanish (Master Assassin)";
								end
							end
							break;
						end
						if ((v230 == (0 - 0)) or ((1265 + 2048) <= (2257 - (341 + 138)))) then
							if ((v77.ImprovedGarrote:IsAvailable() and not v77.MasterAssassin:IsAvailable() and v77.Garrote:CooldownUp() and ((v15:PMultiplier(v77.Garrote) <= (1 + 0)) or v123(v15, v77.Garrote))) or ((2932 - 1511) >= (2430 - (89 + 237)))) then
								local v255 = 0 - 0;
								while true do
									if (((3814 - 2002) <= (4130 - (581 + 300))) and ((1220 - (855 + 365)) == v255)) then
										if (((3854 - 2231) <= (639 + 1318)) and not v77.IndiscriminateCarnage:IsAvailable() and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (1239 - (1030 + 205)))) and (v93 >= v23(v87, 4 + 0))) then
											if (((4105 + 307) == (4698 - (156 + 130))) and v50 and (v14:EnergyPredicted() < (102 - 57))) then
												if (((2949 - 1199) >= (1723 - 881)) and v20(v77.PoolEnergy)) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (((1153 + 3219) > (1079 + 771)) and v20(v77.Vanish, v55)) then
												return "Cast Vanish (Garrote Deathmark)";
											end
										end
										if (((301 - (10 + 59)) < (233 + 588)) and v77.IndiscriminateCarnage:IsAvailable() and (v87 > (9 - 7))) then
											if (((1681 - (671 + 492)) < (719 + 183)) and v50 and (v14:EnergyPredicted() < (1260 - (369 + 846)))) then
												if (((793 + 2201) > (733 + 125)) and v20(v77.PoolEnergy)) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (v20(v77.Vanish, v55) or ((5700 - (1036 + 909)) <= (728 + 187))) then
												return "Cast Vanish (Garrote Cleave)";
											end
										end
										break;
									end
								end
							end
							if (((6624 - 2678) > (3946 - (11 + 192))) and v77.MasterAssassin:IsAvailable() and v77.Kingsbane:IsAvailable() and v15:DebuffUp(v77.Kingsbane) and (v15:DebuffRemains(v77.Kingsbane) <= (2 + 1)) and v15:DebuffUp(v77.Deathmark) and (v15:DebuffRemains(v77.Deathmark) <= (178 - (135 + 40)))) then
								if (v20(v77.Vanish, v55) or ((3234 - 1899) >= (1993 + 1313))) then
									return "Cast Vanish (Kingsbane)";
								end
							end
							v230 = 2 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v176 = 0 - 0;
		while true do
			if (((5020 - (50 + 126)) > (6273 - 4020)) and (v176 == (0 + 0))) then
				v89 = v74.HandleTopTrinket(v80, v28, 1453 - (1233 + 180), nil);
				if (((1421 - (522 + 447)) == (1873 - (107 + 1314))) and v89) then
					return v89;
				end
				v176 = 1 + 0;
			end
			if ((v176 == (2 - 1)) or ((1936 + 2621) < (4143 - 2056))) then
				v89 = v74.HandleBottomTrinket(v80, v28, 158 - 118, nil);
				if (((5784 - (716 + 1194)) == (67 + 3807)) and v89) then
					return v89;
				end
				break;
			end
		end
	end
	local function v132()
		if ((v77.Sepsis:IsReady() and (v15:DebuffRemains(v77.Rupture) > (3 + 17)) and ((not v77.ImprovedGarrote:IsAvailable() and v15:DebuffUp(v77.Garrote)) or (v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and (v15:PMultiplier(v77.Garrote) <= (504 - (74 + 429))))) and (v15:FilteredTimeToDie(">", 19 - 9) or v10.BossFilteredFightRemains("<=", 5 + 5))) or ((4436 - 2498) > (3492 + 1443))) then
			if (v20(v77.Sepsis, nil, true) or ((13117 - 8862) < (8463 - 5040))) then
				return "Cast Sepsis";
			end
		end
		v89 = v131();
		if (((1887 - (279 + 154)) <= (3269 - (454 + 324))) and v89) then
			return v89;
		end
		local v177 = not v14:StealthUp(true, false) and v15:DebuffUp(v77.Rupture) and v14:BuffUp(v77.Envenom) and not v77.Deathmark:AnyDebuffUp() and (not v77.MasterAssassin:IsAvailable() or v15:DebuffUp(v77.Garrote)) and (not v77.Kingsbane:IsAvailable() or (v77.Kingsbane:CooldownRemains() <= (2 + 0)));
		if ((v77.Deathmark:IsCastable() and (v177 or v10.BossFilteredFightRemains("<=", 37 - (12 + 5)))) or ((2242 + 1915) <= (7141 - 4338))) then
			if (((1794 + 3059) >= (4075 - (277 + 816))) and v20(v77.Deathmark)) then
				return "Cast Deathmark";
			end
		end
		if (((17664 - 13530) > (4540 - (1058 + 125))) and v77.Shiv:IsReady() and not v15:DebuffUp(v77.ShivDebuff) and v15:DebuffUp(v77.Garrote) and v15:DebuffUp(v77.Rupture)) then
			local v185 = 0 + 0;
			while true do
				if ((v185 == (976 - (815 + 160))) or ((14661 - 11244) < (6015 - 3481))) then
					if ((v77.ArterialPrecision:IsAvailable() and v77.Deathmark:AnyDebuffUp()) or ((650 + 2072) <= (479 - 315))) then
						if (v20(v77.Shi) or ((4306 - (41 + 1857)) < (4002 - (1222 + 671)))) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if ((not v77.Kingsbane:IsAvailable() and not v77.ArterialPrecision:IsAvailable()) or ((85 - 52) == (2090 - 635))) then
						if (v77.Sepsis:IsAvailable() or ((1625 - (229 + 953)) >= (5789 - (1111 + 663)))) then
							if (((4961 - (874 + 705)) > (24 + 142)) and (((v77.Shiv:ChargesFractional() > (0.9 + 0 + v21(v77.LightweightShiv:IsAvailable()))) and (v103 > (10 - 5))) or v15:DebuffUp(v77.Sepsis) or v15:DebuffUp(v77.Deathmark))) then
								if (v20(v77.Shiv) or ((8 + 272) == (3738 - (642 + 37)))) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (((429 + 1452) > (207 + 1086)) and (not v77.CrimsonTempest:IsAvailable() or v108 or v15:DebuffUp(v77.CrimsonTempest))) then
							if (((5917 - 3560) == (2811 - (233 + 221))) and v20(v77.Shiv)) then
								return "Cast Shiv";
							end
						end
					end
					break;
				end
				if (((284 - 161) == (109 + 14)) and (v185 == (1541 - (718 + 823)))) then
					if (v10.BossFilteredFightRemains("<=", v77.Shiv:Charges() * (6 + 2)) or ((1861 - (266 + 539)) >= (9603 - 6211))) then
						if (v20(v77.Shiv) or ((2306 - (636 + 589)) < (2551 - 1476))) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if ((v77.Kingsbane:IsAvailable() and v14:BuffUp(v77.Envenom)) or ((2163 - 1114) >= (3513 + 919))) then
						if ((not v77.LightweightShiv:IsAvailable() and ((v15:DebuffUp(v77.Kingsbane) and (v15:DebuffRemains(v77.Kingsbane) < (3 + 5))) or (v77.Kingsbane:CooldownRemains() >= (1039 - (657 + 358)))) and (not v77.CrimsonTempest:IsAvailable() or v108 or v15:DebuffUp(v77.CrimsonTempest))) or ((12624 - 7856) <= (1927 - 1081))) then
							if (v20(v77.Shiv) or ((4545 - (1151 + 36)) <= (1372 + 48))) then
								return "Cast Shiv (Kingsbane)";
							end
						end
						if ((v77.LightweightShiv:IsAvailable() and (v15:DebuffUp(v77.Kingsbane) or (v77.Kingsbane:CooldownRemains() <= (1 + 0)))) or ((11166 - 7427) <= (4837 - (1552 + 280)))) then
							if (v20(v77.Shiv) or ((2493 - (64 + 770)) >= (1449 + 685))) then
								return "Cast Shiv (Kingsbane Lightweight)";
							end
						end
					end
					v185 = 2 - 1;
				end
			end
		end
		if ((v77.ShadowDance:IsCastable() and v77.Kingsbane:IsAvailable() and v14:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (9 + 41)) or v177)) or ((4503 - (157 + 1086)) < (4713 - 2358))) then
			if (v20(v77.ShadowDance) or ((2929 - 2260) == (6477 - 2254))) then
				return "Cast Shadow Dance (Kingsbane Sync)";
			end
		end
		if ((v77.Kingsbane:IsReady() and (v15:DebuffUp(v77.ShivDebuff) or (v77.Shiv:CooldownRemains() < (7 - 1))) and v14:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (869 - (599 + 220))) or v15:DebuffUp(v77.Deathmark))) or ((3369 - 1677) < (2519 - (1813 + 118)))) then
			if (v20(v77.Kingsbane) or ((3507 + 1290) < (4868 - (841 + 376)))) then
				return "Cast Kingsbane";
			end
		end
		if ((v77.ThistleTea:IsCastable() and not v14:BuffUp(v77.ThistleTea) and (((v14:EnergyDeficit() >= ((140 - 40) + v105)) and (not v77.Kingsbane:IsAvailable() or (v77.ThistleTea:Charges() >= (1 + 1)))) or (v15:DebuffUp(v77.Kingsbane) and (v15:DebuffRemains(v77.Kingsbane) < (16 - 10))) or (not v77.Kingsbane:IsAvailable() and v77.Deathmark:AnyDebuffUp()) or v10.BossFilteredFightRemains("<", v77.ThistleTea:Charges() * (865 - (464 + 395))))) or ((10719 - 6542) > (2330 + 2520))) then
			if (v10.Cast(v77.ThistleTea) or ((1237 - (467 + 370)) > (2295 - 1184))) then
				return "Cast Thistle Tea";
			end
		end
		if (((2240 + 811) > (3445 - 2440)) and v77.Deathmark:AnyDebuffUp() and (not v89 or v54)) then
			if (((577 + 3116) <= (10194 - 5812)) and v89) then
				v129();
			else
				v89 = v129();
			end
		end
		if ((not v14:StealthUp(true, true) and (v118() <= (520 - (150 + 370))) and (v117() <= (1282 - (74 + 1208)))) or ((8071 - 4789) > (19444 - 15344))) then
			if (v89 or ((2548 + 1032) < (3234 - (14 + 376)))) then
				v130();
			else
				v89 = v130();
			end
		end
		if (((153 - 64) < (2906 + 1584)) and v77.ColdBlood:IsReady() and v14:DebuffDown(v77.ColdBlood) and (v92 >= (4 + 0))) then
			if (v10.Press(v77.ColdBlood) or ((4753 + 230) < (5297 - 3489))) then
				return "Cast Cold Blood";
			end
		end
		return v89;
	end
	local function v133()
		local v178 = 0 + 0;
		while true do
			if (((3907 - (23 + 55)) > (8931 - 5162)) and (v178 == (0 + 0))) then
				if (((1334 + 151) <= (4501 - 1597)) and v77.Kingsbane:IsAvailable() and v14:BuffUp(v77.Envenom)) then
					local v231 = 0 + 0;
					while true do
						if (((5170 - (652 + 249)) == (11424 - 7155)) and (v231 == (1868 - (708 + 1160)))) then
							if (((1050 - 663) <= (5071 - 2289)) and v77.Shiv:IsReady() and (v15:DebuffUp(v77.Kingsbane) or v77.Kingsbane:CooldownUp()) and v15:DebuffDown(v77.ShivDebuff)) then
								if (v20(v77.Shiv) or ((1926 - (10 + 17)) <= (206 + 711))) then
									return "Cast Shiv (Stealth Kingsbane)";
								end
							end
							if ((v77.Kingsbane:IsReady() and (v14:BuffRemains(v77.ShadowDanceBuff) >= (1734 - (1400 + 332)))) or ((8270 - 3958) <= (2784 - (242 + 1666)))) then
								if (((956 + 1276) <= (952 + 1644)) and v20(v77.Kingsbane, v68)) then
									return "Cast Kingsbane (Dance)";
								end
							end
							break;
						end
					end
				end
				if (((1786 + 309) < (4626 - (850 + 90))) and (v92 >= (6 - 2))) then
					local v232 = 1390 - (360 + 1030);
					while true do
						if ((v232 == (0 + 0)) or ((4501 - 2906) >= (6155 - 1681))) then
							if ((v15:DebuffUp(v77.Kingsbane) and (v14:BuffRemains(v77.Envenom) <= (1663 - (909 + 752)))) or ((5842 - (109 + 1114)) < (5275 - 2393))) then
								if (v20(v77.Envenom, nil, nil, not v83) or ((115 + 179) >= (5073 - (6 + 236)))) then
									return "Cast Envenom (Stealth Kingsbane)";
								end
							end
							if (((1279 + 750) <= (2483 + 601)) and v108 and v116() and v14:BuffDown(v77.ShadowDanceBuff)) then
								if (v20(v77.Envenom, nil, nil, not v83) or ((4803 - 2766) == (4227 - 1807))) then
									return "Cast Envenom (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				v178 = 1134 - (1076 + 57);
			end
			if (((734 + 3724) > (4593 - (579 + 110))) and (v178 == (1 + 1))) then
				if (((386 + 50) >= (66 + 57)) and (v92 >= (411 - (174 + 233))) and (v15:PMultiplier(v77.Rupture) <= (2 - 1)) and (v14:BuffUp(v77.ShadowDanceBuff) or v15:DebuffUp(v77.Deathmark))) then
					if (((877 - 377) < (808 + 1008)) and v20(v77.Rupture, nil, nil, not v83)) then
						return "Cast Rupture (Nightstalker)";
					end
				end
				break;
			end
			if (((4748 - (663 + 511)) == (3189 + 385)) and (v178 == (1 + 0))) then
				if (((681 - 460) < (237 + 153)) and v27 and v77.CrimsonTempest:IsReady() and v77.Nightstalker:IsAvailable() and (v87 >= (6 - 3)) and (v92 >= (9 - 5)) and not v77.Deathmark:IsReady()) then
					for v239, v240 in v30(v86) do
						if ((v123(v240, v77.CrimsonTempest, v95) and v240:FilteredTimeToDie(">", 3 + 3, -v240:DebuffRemains(v77.CrimsonTempest))) or ((4306 - 2093) <= (1013 + 408))) then
							if (((280 + 2778) < (5582 - (478 + 244))) and v20(v77.CrimsonTempest)) then
								return "Cast Crimson Tempest (Stealth)";
							end
						end
					end
				end
				if ((v77.Garrote:IsCastable() and (v118() > (517 - (440 + 77)))) or ((590 + 706) >= (16272 - 11826))) then
					local function v233(v241)
						return v241:DebuffRemains(v77.Garrote);
					end
					local function v234(v242)
						return ((v242:PMultiplier(v77.Garrote) <= (1557 - (655 + 901))) or (v242:DebuffRemains(v77.Garrote) < ((3 + 9) / v76.ExsanguinatedRate(v242, v77.Garrote))) or ((v119() > (0 + 0)) and (v77.Garrote:AuraActiveCount() < v87))) and not v108 and (v242:FilteredTimeToDie(">", 2 + 0, -v242:DebuffRemains(v77.Garrote)) or v242:TimeToDieIsNotValid()) and v76.CanDoTUnit(v242, v97);
					end
					if (v27 or ((5611 - 4218) > (5934 - (695 + 750)))) then
						local v245 = 0 - 0;
						local v246;
						while true do
							if ((v245 == (0 - 0)) or ((17792 - 13368) < (378 - (285 + 66)))) then
								v246 = v125("min", v233, v234);
								if ((v246 and (v246:GUID() ~= v15:GUID())) or ((4654 - 2657) > (5125 - (682 + 628)))) then
									v20(v246, v77.Garrote);
								end
								break;
							end
						end
					end
					if (((559 + 2906) > (2212 - (176 + 123))) and v234(v15)) then
						if (((307 + 426) < (1320 + 499)) and v20(v77.Garrote, nil, nil, not v83)) then
							return "Cast Garrote (Improved Garrote)";
						end
					end
					if ((v93 >= ((270 - (239 + 30)) + ((1 + 1) * v21(v77.ShroudedSuffocation:IsAvailable())))) or ((4225 + 170) == (8415 - 3660))) then
						if ((v14:BuffDown(v77.ShadowDanceBuff) and ((v15:PMultiplier(v77.Garrote) <= (2 - 1)) or (v15:DebuffUp(v77.Deathmark) and (v117() < (318 - (306 + 9)))))) or ((13236 - 9443) < (412 + 1957))) then
							if (v20(v77.Garrote, nil, nil, not v83) or ((2506 + 1578) == (128 + 137))) then
								return "Cast Garrote (Improved Garrote Low CP)";
							end
						end
						if (((12462 - 8104) == (5733 - (1140 + 235))) and ((v15:PMultiplier(v77.Garrote) <= (1 + 0)) or (v15:DebuffRemains(v77.Garrote) < (12 + 0)))) then
							if (v20(v77.Garrote, nil, nil, not v83) or ((806 + 2332) < (1045 - (33 + 19)))) then
								return "Cast Garrote (Improved Garrote Low CP 2)";
							end
						end
					end
				end
				v178 = 1 + 1;
			end
		end
	end
	local function v134()
		if (((9980 - 6650) > (1024 + 1299)) and v27 and v77.CrimsonTempest:IsReady() and (v87 >= (3 - 1)) and (v92 >= (4 + 0)) and (v105 > (714 - (586 + 103))) and not v77.Deathmark:IsReady()) then
			for v220, v221 in v30(v86) do
				if ((v123(v221, v77.CrimsonTempest, v95) and (v221:PMultiplier(v77.CrimsonTempest) <= (1 + 0)) and v221:FilteredTimeToDie(">", 18 - 12, -v221:DebuffRemains(v77.CrimsonTempest))) or ((5114 - (1309 + 179)) == (7200 - 3211))) then
					if (v20(v77.CrimsonTempest) or ((399 + 517) == (7173 - 4502))) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
			end
		end
		if (((206 + 66) == (577 - 305)) and v77.Garrote:IsCastable() and (v93 >= (1 - 0))) then
			local v186 = 609 - (295 + 314);
			local v187;
			while true do
				if (((10435 - 6186) <= (6801 - (1300 + 662))) and ((3 - 2) == v186)) then
					if (((4532 - (1178 + 577)) < (1662 + 1538)) and v187(v15) and v76.CanDoTUnit(v15, v97) and (v15:FilteredTimeToDie(">", 35 - 23, -v15:DebuffRemains(v77.Garrote)) or v15:TimeToDieIsNotValid())) then
						if (((1500 - (851 + 554)) < (1731 + 226)) and v29(v77.Garrote, nil, not v83)) then
							return "Pool for Garrote (ST)";
						end
					end
					if (((2290 - 1464) < (3728 - 2011)) and v27 and not v107 and (v87 >= (304 - (115 + 187)))) then
						v124(v77.Garrote, v187, 10 + 2, v88);
					end
					break;
				end
				if (((1350 + 76) >= (4354 - 3249)) and (v186 == (1161 - (160 + 1001)))) then
					v187 = nil;
					function v187(v243)
						return v123(v243, v77.Garrote) and (v243:PMultiplier(v77.Garrote) <= (1 + 0));
					end
					v186 = 1 + 0;
				end
			end
		end
		if (((5637 - 2883) <= (3737 - (237 + 121))) and v77.Rupture:IsReady() and (v92 >= (901 - (525 + 372)))) then
			local v188 = 0 - 0;
			local v189;
			while true do
				if ((v188 == (0 - 0)) or ((4069 - (96 + 46)) == (2190 - (643 + 134)))) then
					v98 = 2 + 2 + (v21(v77.DashingScoundrel:IsAvailable()) * (11 - 6)) + (v21(v77.Doomblade:IsAvailable()) * (18 - 13)) + (v21(v107) * (6 + 0));
					v189 = nil;
					v188 = 1 - 0;
				end
				if (((3 - 1) == v188) or ((1873 - (316 + 403)) <= (524 + 264))) then
					if ((v27 and (not v107 or not v109)) or ((4517 - 2874) > (1222 + 2157))) then
						v124(v77.Rupture, v189, v98, v88);
					end
					break;
				end
				if (((2 - 1) == v188) or ((1987 + 816) > (1467 + 3082))) then
					function v189(v244)
						return v123(v244, v77.Rupture, v94) and (v244:PMultiplier(v77.Rupture) <= (3 - 2)) and (v244:FilteredTimeToDie(">", v98, -v244:DebuffRemains(v77.Rupture)) or v244:TimeToDieIsNotValid());
					end
					if ((v189(v15) and v76.CanDoTUnit(v15, v96)) or ((1050 - 830) >= (6277 - 3255))) then
						if (((162 + 2660) == (5555 - 2733)) and v20(v77.Rupture, nil, nil, not v83)) then
							return "Cast Rupture";
						end
					end
					v188 = 1 + 1;
				end
			end
		end
		if ((v77.Garrote:IsCastable() and (v93 >= (2 - 1)) and (v117() <= (17 - (12 + 5))) and ((v15:PMultiplier(v77.Garrote) <= (3 - 2)) or ((v15:DebuffRemains(v77.Garrote) < v90) and (v87 >= (5 - 2)))) and (v15:DebuffRemains(v77.Garrote) < (v90 * (3 - 1))) and (v87 >= (7 - 4)) and (v15:FilteredTimeToDie(">", 1 + 3, -v15:DebuffRemains(v77.Garrote)) or v15:TimeToDieIsNotValid())) or ((3034 - (1656 + 317)) == (1655 + 202))) then
			if (((2212 + 548) > (3626 - 2262)) and v20(v77.Garrote, nil, nil, not v83)) then
				return "Garrote (Fallback)";
			end
		end
		return false;
	end
	local function v135()
		local v179 = 0 - 0;
		while true do
			if ((v179 == (356 - (5 + 349))) or ((23283 - 18381) <= (4866 - (266 + 1005)))) then
				if ((v28 and v77.EchoingReprimand:IsReady()) or ((2539 + 1313) == (999 - 706))) then
					if (v20(v77.EchoingReprimand, nil, not v83) or ((2051 - 492) == (6284 - (561 + 1135)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (v77.FanofKnives:IsCastable() or ((5843 - 1359) == (2590 - 1802))) then
					local v235 = 1066 - (507 + 559);
					while true do
						if (((11462 - 6894) >= (12083 - 8176)) and (v235 == (388 - (212 + 176)))) then
							if (((2151 - (250 + 655)) < (9462 - 5992)) and v27 and (v87 >= (1 - 0)) and not v101 and (v87 >= ((2 - 0) + v21(v14:StealthUp(true, false)) + v21(v77.DragonTemperedBlades:IsAvailable())))) then
								if (((6024 - (1869 + 87)) >= (3371 - 2399)) and v29(v77.FanofKnives)) then
									return "Cast Fan of Knives";
								end
							end
							if (((2394 - (484 + 1417)) < (8344 - 4451)) and v27 and v14:BuffUp(v77.DeadlyPoison) and (v87 >= (4 - 1))) then
								for v256, v257 in v30(v86) do
									if ((not v257:DebuffUp(v77.DeadlyPoisonDebuff, true) and (not v101 or v257:DebuffUp(v77.Garrote) or v257:DebuffUp(v77.Rupture))) or ((2246 - (48 + 725)) >= (5442 - 2110))) then
										if (v29(v77.FanofKnives) or ((10868 - 6817) <= (673 + 484))) then
											return "Cast Fan of Knives (DP Refresh)";
										end
									end
								end
							end
							break;
						end
					end
				end
				v179 = 7 - 4;
			end
			if (((170 + 434) < (840 + 2041)) and (v179 == (856 - (152 + 701)))) then
				if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v77.BlindsideBuff) or v14:BuffUp(v77.SepsisBuff)) and (v15:DebuffDown(v77.Kingsbane) or v15:DebuffDown(v77.Deathmark) or v14:BuffUp(v77.BlindsideBuff))) or ((2211 - (430 + 881)) == (1294 + 2083))) then
					if (((5354 - (557 + 338)) > (175 + 416)) and v29(v77.Ambush, nil, not v83)) then
						return "Cast Ambush";
					end
				end
				if (((9575 - 6177) >= (8386 - 5991)) and v77.Mutilate:IsCastable() and (v87 == (4 - 2)) and v15:DebuffDown(v77.DeadlyPoisonDebuff, true) and v15:DebuffDown(v77.AmplifyingPoisonDebuff, true)) then
					local v236 = 0 - 0;
					local v237;
					while true do
						if ((v236 == (801 - (499 + 302))) or ((3049 - (39 + 827)) >= (7795 - 4971))) then
							v237 = v15:GUID();
							for v253, v254 in v30(v88) do
								if (((4323 - 2387) == (7689 - 5753)) and (v254:GUID() ~= v237) and (v254:DebuffUp(v77.Garrote) or v254:DebuffUp(v77.Rupture)) and not v254:DebuffUp(v77.DeadlyPoisonDebuff, true) and not v254:DebuffUp(v77.AmplifyingPoisonDebuff, true)) then
									v20(v254, v77.Mutilate);
									break;
								end
							end
							break;
						end
					end
				end
				v179 = 5 - 1;
			end
			if ((v179 == (1 + 3)) or ((14142 - 9310) < (690 + 3623))) then
				if (((6468 - 2380) > (3978 - (103 + 1))) and v77.Mutilate:IsCastable()) then
					if (((4886 - (475 + 79)) == (9364 - 5032)) and v29(v77.Mutilate, nil, not v83)) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
			if (((12796 - 8797) >= (375 + 2525)) and (v179 == (0 + 0))) then
				if ((v77.Envenom:IsReady() and (v92 >= (1507 - (1395 + 108))) and (v102 or (v15:DebuffStack(v77.AmplifyingPoisonDebuff) >= (58 - 38)) or (v92 > v76.CPMaxSpend()) or not v108)) or ((3729 - (7 + 1197)) > (1772 + 2292))) then
					if (((1526 + 2845) == (4690 - (27 + 292))) and v20(v77.Envenom, nil, nil, not v83)) then
						return "Cast Envenom";
					end
				end
				if (not ((v93 > (2 - 1)) or v102 or not v108) or ((339 - 73) > (20910 - 15924))) then
					return false;
				end
				v179 = 1 - 0;
			end
			if (((3791 - 1800) >= (1064 - (43 + 96))) and (v179 == (4 - 3))) then
				if (((1028 - 573) < (1704 + 349)) and not v108 and v77.CausticSpatter:IsAvailable() and v15:DebuffUp(v77.Rupture) and (v15:DebuffRemains(v77.CausticSpatterDebuff) <= (1 + 1))) then
					local v238 = 0 - 0;
					while true do
						if (((0 + 0) == v238) or ((1547 - 721) == (1528 + 3323))) then
							if (((14 + 169) == (1934 - (1414 + 337))) and v77.Mutilate:IsCastable()) then
								if (((3099 - (1642 + 298)) <= (4660 - 2872)) and v20(v77.Mutilate, nil, nil, not v83)) then
									return "Cast Mutilate (Casutic)";
								end
							end
							if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v77.BlindsideBuff))) or ((10089 - 6582) > (12813 - 8495))) then
								if (v20(v77.Ambush, nil, nil, not v83) or ((1012 + 2063) <= (2307 + 658))) then
									return "Cast Ambush (Caustic)";
								end
							end
							break;
						end
					end
				end
				if (((2337 - (357 + 615)) <= (1412 + 599)) and v77.SerratedBoneSpike:IsReady()) then
					if (not v15:DebuffUp(v77.SerratedBoneSpikeDebuff) or ((6811 - 4035) > (3064 + 511))) then
						if (v20(v77.SerratedBoneSpike, nil, not v84) or ((5472 - 2918) == (3843 + 961))) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v247 = 0 + 0;
						while true do
							if (((1620 + 957) == (3878 - (384 + 917))) and (v247 == (697 - (128 + 569)))) then
								if (v27 or ((1549 - (1407 + 136)) >= (3776 - (687 + 1200)))) then
									if (((2216 - (556 + 1154)) <= (6656 - 4764)) and v74.CastTargetIf(v77.SerratedBoneSpike, v85, "min", v127, v128)) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if ((v117() < (95.8 - (9 + 86))) or ((2429 - (275 + 146)) > (361 + 1857))) then
									if (((443 - (29 + 35)) <= (18379 - 14232)) and ((v10.BossFightRemains() <= (14 - 9)) or ((v77.SerratedBoneSpike:MaxCharges() - v77.SerratedBoneSpike:ChargesFractional()) <= (0.25 - 0)))) then
										if (v20(v77.SerratedBoneSpike, nil, true, not v84) or ((2941 + 1573) <= (2021 - (53 + 959)))) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif ((not v108 and v15:DebuffUp(v77.ShivDebuff)) or ((3904 - (312 + 96)) == (2068 - 876))) then
										if (v20(v77.SerratedBoneSpike, nil, true, not v84) or ((493 - (147 + 138)) == (3858 - (813 + 86)))) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v179 = 2 + 0;
			end
		end
	end
	local function v136()
		v73();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v81 = (v77.AcrobaticStrikes:IsAvailable() and (14 - 6)) or (497 - (18 + 474));
		v82 = (v77.AcrobaticStrikes:IsAvailable() and (5 + 8)) or (32 - 22);
		v83 = v15:IsInMeleeRange(v81);
		v84 = v15:IsInMeleeRange(v82);
		if (((5363 - (860 + 226)) >= (1616 - (121 + 182))) and v27) then
			local v190 = 0 + 0;
			while true do
				if (((3827 - (988 + 252)) < (359 + 2815)) and (v190 == (1 + 0))) then
					v87 = #v86;
					v88 = v14:GetEnemiesInMeleeRange(v81);
					break;
				end
				if ((v190 == (1970 - (49 + 1921))) or ((5010 - (223 + 667)) <= (2250 - (51 + 1)))) then
					v85 = v14:GetEnemiesInRange(51 - 21);
					v86 = v14:GetEnemiesInMeleeRange(v82);
					v190 = 1 - 0;
				end
			end
		else
			local v191 = 1125 - (146 + 979);
			while true do
				if ((v191 == (1 + 0)) or ((2201 - (311 + 294)) == (2392 - 1534))) then
					v87 = 1 + 0;
					v88 = {};
					break;
				end
				if (((4663 - (496 + 947)) == (4578 - (1233 + 125))) and (v191 == (0 + 0))) then
					v85 = {};
					v86 = {};
					v191 = 1 + 0;
				end
			end
		end
		v90, v91 = (1 + 1) * v14:SpellHaste(), (1646 - (963 + 682)) * v14:SpellHaste();
		v92 = v76.EffectiveComboPoints(v14:ComboPoints());
		v93 = v14:ComboPointsMax() - v92;
		v94 = (4 + 0 + (v92 * (1508 - (504 + 1000)))) * (0.3 + 0);
		v95 = (4 + 0 + (v92 * (1 + 1))) * (0.3 - 0);
		v96 = v77.Envenom:Damage() * v63;
		v97 = v77.Mutilate:Damage() * v64;
		v101 = v46();
		v89 = v76.CrimsonVial();
		if (v89 or ((1198 + 204) > (2106 + 1514))) then
			return v89;
		end
		v89 = v76.Feint();
		if (((2756 - (156 + 26)) == (1483 + 1091)) and v89) then
			return v89;
		end
		if (((2812 - 1014) < (2921 - (149 + 15))) and not v14:AffectingCombat() and not v14:IsMounted() and v74.TargetIsValid()) then
			local v192 = 960 - (890 + 70);
			while true do
				if ((v192 == (117 - (39 + 78))) or ((859 - (14 + 468)) > (5725 - 3121))) then
					v89 = v76.Stealth(v77.Stealth2, nil);
					if (((1587 - 1019) < (471 + 440)) and v89) then
						return "Stealth (OOC): " .. v89;
					end
					break;
				end
			end
		end
		v76.Poisons();
		if (((1973 + 1312) < (899 + 3329)) and not v14:AffectingCombat()) then
			local v193 = 0 + 0;
			while true do
				if (((1026 + 2890) > (6369 - 3041)) and (v193 == (0 + 0))) then
					if (((8785 - 6285) < (97 + 3742)) and not v14:BuffUp(v76.VanishBuffSpell())) then
						local v248 = 51 - (12 + 39);
						while true do
							if (((472 + 35) == (1569 - 1062)) and (v248 == (0 - 0))) then
								v89 = v76.Stealth(v76.StealthSpell());
								if (((72 + 168) <= (1666 + 1499)) and v89) then
									return v89;
								end
								break;
							end
						end
					end
					if (((2114 - 1280) >= (537 + 268)) and v74.TargetIsValid()) then
						local v249 = 0 - 0;
						while true do
							if ((v249 == (1710 - (1596 + 114))) or ((9952 - 6140) < (3029 - (164 + 549)))) then
								if (v28 or ((4090 - (1059 + 379)) <= (1902 - 369))) then
									if ((v26 and v77.MarkedforDeath:IsCastable() and (v14:ComboPointsDeficit() >= v76.CPMaxSpend()) and v74.TargetIsValid()) or ((1865 + 1733) < (247 + 1213))) then
										if (v10.Press(v77.MarkedforDeath, v59) or ((4508 - (145 + 247)) < (979 + 213))) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (not v14:BuffUp(v77.SliceandDice) or ((1561 + 1816) <= (2676 - 1773))) then
									if (((763 + 3213) >= (379 + 60)) and v77.SliceandDice:IsReady() and (v92 >= (2 - 0))) then
										if (((4472 - (254 + 466)) == (4312 - (544 + 16))) and v10.Press(v77.SliceandDice)) then
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
		v76.MfDSniping(v77.MarkedforDeath);
		if (((12858 - 8812) > (3323 - (294 + 334))) and v74.TargetIsValid()) then
			local v194 = 253 - (236 + 17);
			while true do
				if (((2 + 1) == v194) or ((2760 + 785) == (12040 - 8843))) then
					v89 = v134();
					if (((11334 - 8940) > (193 + 180)) and v89) then
						return v89;
					end
					v89 = v135();
					if (((3423 + 732) <= (5026 - (413 + 381))) and v89) then
						return v89;
					end
					v194 = 1 + 3;
				end
				if (((8 - 4) == v194) or ((9301 - 5720) == (5443 - (582 + 1388)))) then
					if (((8510 - 3515) > (2397 + 951)) and v28) then
						if ((v77.ArcaneTorrent:IsCastable() and v83 and (v14:EnergyDeficit() > (379 - (326 + 38)))) or ((2230 - 1476) > (5315 - 1591))) then
							if (((837 - (47 + 573)) >= (21 + 36)) and v20(v77.ArcaneTorrent, v32)) then
								return "Cast Arcane Torrent";
							end
						end
						if ((v77.ArcanePulse:IsCastable() and v83) or ((8791 - 6721) >= (6551 - 2514))) then
							if (((4369 - (1269 + 395)) == (3197 - (76 + 416))) and v20(v77.ArcanePulse, v32)) then
								return "Cast Arcane Pulse";
							end
						end
						if (((504 - (319 + 124)) == (139 - 78)) and v77.LightsJudgment:IsCastable() and v83) then
							if (v20(v77.LightsJudgment, v32) or ((1706 - (564 + 443)) >= (3587 - 2291))) then
								return "Cast Lights Judgment";
							end
						end
						if ((v77.BagofTricks:IsCastable() and v83) or ((2241 - (337 + 121)) >= (10595 - 6979))) then
							if (v20(v77.BagofTricks, v32) or ((13034 - 9121) > (6438 - (1261 + 650)))) then
								return "Cast Bag of Tricks";
							end
						end
					end
					if (((1852 + 2524) > (1301 - 484)) and (v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and v84) then
						if (((6678 - (772 + 1045)) > (117 + 707)) and v20(v77.Ambush)) then
							return "Fill Ambush";
						end
					end
					if ((v77.Mutilate:IsCastable() and v84) or ((1527 - (102 + 42)) >= (3975 - (1524 + 320)))) then
						if (v20(v77.Mutilate) or ((3146 - (1049 + 221)) >= (2697 - (18 + 138)))) then
							return "Fill Mutilate";
						end
					end
					break;
				end
				if (((4361 - 2579) <= (4874 - (67 + 1035))) and (v194 == (348 - (136 + 212)))) then
					v104 = v76.PoisonedBleeds();
					v105 = v14:EnergyRegen() + ((v104 * (25 - 19)) / ((2 + 0) * v14:SpellHaste()));
					v106 = v14:EnergyDeficit() / v105;
					v107 = v105 > (33 + 2);
					v194 = 1605 - (240 + 1364);
				end
				if ((v194 == (1084 - (1050 + 32))) or ((16781 - 12081) < (481 + 332))) then
					if (((4254 - (331 + 724)) < (327 + 3723)) and (v14:StealthUp(true, false) or (v118() > (644 - (269 + 375))) or (v117() > (725 - (267 + 458))))) then
						local v250 = 0 + 0;
						while true do
							if ((v250 == (0 - 0)) or ((5769 - (667 + 151)) < (5927 - (1410 + 87)))) then
								v89 = v133();
								if (((1993 - (1504 + 393)) == (259 - 163)) and v89) then
									return v89 .. " (Stealthed)";
								end
								break;
							end
						end
					end
					v89 = v132();
					if (v89 or ((7105 - 4366) > (4804 - (461 + 335)))) then
						return v89;
					end
					if (not v14:BuffUp(v77.SliceandDice) or ((3 + 20) == (2895 - (1730 + 31)))) then
						if ((v77.SliceandDice:IsReady() and (v14:ComboPoints() >= (1669 - (728 + 939))) and v15:DebuffUp(v77.Rupture)) or (not v77.CutToTheChase:IsAvailable() and (v14:ComboPoints() >= (14 - 10)) and (v14:BuffRemains(v77.SliceandDice) < (((1 - 0) + v14:ComboPoints()) * (2.8 - 1)))) or ((3761 - (138 + 930)) >= (3757 + 354))) then
							if (v20(v77.SliceandDice) or ((3375 + 941) <= (1840 + 306))) then
								return "Cast Slice and Dice";
							end
						end
					elseif ((v84 and v77.CutToTheChase:IsAvailable()) or ((14479 - 10933) <= (4575 - (459 + 1307)))) then
						if (((6774 - (474 + 1396)) > (3782 - 1616)) and v77.Envenom:IsReady() and (v14:BuffRemains(v77.SliceandDice) < (5 + 0)) and (v14:ComboPoints() >= (1 + 3))) then
							if (((312 - 203) >= (12 + 78)) and v20(v77.Envenom, nil, nil, not v83)) then
								return "Cast Envenom (CttC)";
							end
						end
					elseif (((16617 - 11639) > (12669 - 9764)) and v77.PoisonedKnife:IsCastable() and v15:IsInRange(621 - (562 + 29)) and not v14:StealthUp(true, true) and (v87 == (0 + 0)) and (v14:EnergyTimeToMax() <= (v14:GCD() * (1420.5 - (374 + 1045))))) then
						if (v20(v77.PoisonedKnife) or ((2395 + 631) <= (7079 - 4799))) then
							return "Cast Poisoned Knife";
						end
					end
					v194 = 641 - (448 + 190);
				end
				if ((v194 == (1 + 0)) or ((747 + 906) <= (722 + 386))) then
					v102 = v120();
					v103 = v121();
					v109 = v122();
					v108 = v87 < (7 - 5);
					v194 = 5 - 3;
				end
			end
		end
	end
	local function v137()
		local v183 = 1494 - (1307 + 187);
		while true do
			if (((11535 - 8626) > (6108 - 3499)) and (v183 == (0 - 0))) then
				v77.Deathmark:RegisterAuraTracking();
				v77.Sepsis:RegisterAuraTracking();
				v183 = 684 - (232 + 451);
			end
			if (((723 + 34) > (172 + 22)) and (v183 == (565 - (510 + 54)))) then
				v77.Garrote:RegisterAuraTracking();
				v10.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v10.SetAPL(521 - 262, v136, v137);
end;
return v0["Epix_Rogue_Assassination.lua"]();

