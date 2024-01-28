local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2845 - (586 + 211)) == (14852 - 11821))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Assassination.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Cast;
	local v18 = v9.CastCycle;
	local v19 = v12.MouseOver;
	local v20 = v9.Item;
	local v21 = v9.Macro;
	local v22 = v9.Press;
	local v23 = v9.CastLeftNameplate;
	local v24 = v9.Commons.Everyone.num;
	local v25 = v9.Commons.Everyone.bool;
	local v26 = math.min;
	local v27 = math.abs;
	local v28 = math.max;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = v9.Press;
	local v33 = pairs;
	local v34 = math.floor;
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
	local v73;
	local v74;
	local v75;
	local v76;
	local function v77()
		v35 = EpicSettings.Settings['UseRacials'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v38 = EpicSettings.Settings['HealingPotionName'] or (1056 - (657 + 399));
		v39 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v40 = EpicSettings.Settings['UseHealthstone'];
		v41 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v42 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v43 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v44 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v46 = EpicSettings.Settings['PoisonRefresh'];
		v47 = EpicSettings.Settings['PoisonRefreshCombat'];
		v48 = EpicSettings.Settings['RangedMultiDoT'];
		v49 = EpicSettings.Settings['UsePriorityRotation'];
		v53 = EpicSettings.Settings['STMfDAsDPSCD'];
		v54 = EpicSettings.Settings['KidneyShotInterrupt'];
		v55 = EpicSettings.Settings['RacialsGCD'];
		v56 = EpicSettings.Settings['RacialsOffGCD'];
		v57 = EpicSettings.Settings['VanishOffGCD'];
		v58 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v59 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v60 = EpicSettings.Settings['ColdBloodOffGCD'];
		v61 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v62 = EpicSettings.Settings['CrimsonVialHP'] or (1 + 0);
		v63 = EpicSettings.Settings['FeintHP'] or (1097 - (709 + 387));
		v64 = EpicSettings.Settings['StealthOOC'];
		v65 = EpicSettings.Settings['EnvenomDMGOffset'] or (1859 - (673 + 1185));
		v66 = EpicSettings.Settings['MutilateDMGOffset'] or (2 - 1);
		v67 = EpicSettings.Settings['AlwaysSuggestGarrote'];
		v68 = EpicSettings.Settings['PotionTypeSelected'];
		v69 = EpicSettings.Settings['ExsanguinateGCD'];
		v70 = EpicSettings.Settings['KingsbaneGCD'];
		v71 = EpicSettings.Settings['ShivGCD'];
		v72 = EpicSettings.Settings['DeathmarkOffGCD'];
		v74 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
		v73 = EpicSettings.Settings['KickOffGCD'];
		v75 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
		v76 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
	end
	local v78 = v9.Commons.Everyone;
	local v79 = v9.Commons.Rogue;
	local v80 = v15.Rogue.Assassination;
	local v81 = v21.Rogue.Assassination;
	local v82 = v20.Rogue.Assassination;
	local v83 = {v82.AlgetharPuzzleBox,v82.AshesoftheEmbersoul,v82.WitherbarksBranch};
	local v84, v85, v86, v87;
	local v88, v89, v90, v91;
	local v92;
	local v93, v94 = (1 + 1) * v13:SpellHaste(), (1 - 0) * v13:SpellHaste();
	local v95, v96;
	local v97, v98, v99, v100, v101, v102, v103;
	local v104;
	local v105, v106, v107, v108, v109, v110, v111, v112;
	local v113 = 0 - 0;
	local v114 = v13:GetEquipment();
	local v115 = (v114[1893 - (446 + 1434)] and v20(v114[1296 - (1040 + 243)])) or v20(0 - 0);
	local v116 = (v114[1861 - (559 + 1288)] and v20(v114[1945 - (609 + 1322)])) or v20(454 - (13 + 441));
	local function v117()
		if ((v115:HasStatAnyDps() and (not v116:HasStatAnyDps() or (v115:Cooldown() >= v116:Cooldown()))) or ((4480 - 3281) >= (5681 - 3512))) then
			v113 = 4 - 3;
		elseif ((v116:HasStatAnyDps() and (not v115:HasStatAnyDps() or (v116:Cooldown() > v115:Cooldown()))) or ((24 + 612) == (6907 - 5005))) then
			v113 = 1 + 1;
		else
			v113 = 0 + 0;
		end
	end
	v117();
	v9:RegisterForEvent(function()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (0 + 0)) or ((8899 - 4060) <= (2169 + 1111))) then
				v114 = v13:GetEquipment();
				v115 = (v114[8 + 5] and v20(v114[10 + 3])) or v20(0 + 0);
				v166 = 1 + 0;
			end
			if ((v166 == (434 - (153 + 280))) or ((10608 - 6934) <= (1762 + 200))) then
				v116 = (v114[6 + 8] and v20(v114[8 + 6])) or v20(0 + 0);
				v117();
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v118 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v80.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v95 > (0 + 0);
	end}};
	v80.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v95 * (0.22 + 0) * (87 - (84 + 2)) * ((v14:DebuffUp(v80.ShivDebuff) and (1.3 - 0)) or (1 + 0)) * ((v80.DeeperStratagem:IsAvailable() and (843.05 - (497 + 345))) or (1 + 0)) * (1 + 0 + (v13:MasteryPct() / (1433 - (605 + 728)))) * (1 + 0 + (v13:VersatilityDmgPct() / (222 - 122)));
	end);
	v80.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (0.485 + 0) * (3 - 2) * (1 + 0 + (v13:VersatilityDmgPct() / (277 - 177)));
	end);
	local function v119()
		return v13:BuffRemains(v80.MasterAssassinBuff) == (7550 + 2449);
	end
	local function v120()
		if (v119() or ((2383 - (457 + 32)) < (597 + 809))) then
			return v13:GCDRemains() + (1405 - (832 + 570));
		end
		return v13:BuffRemains(v80.MasterAssassinBuff);
	end
	local function v121()
		if (((1481 + 91) >= (400 + 1131)) and v13:BuffUp(v80.ImprovedGarroteAura)) then
			return v13:GCDRemains() + (10 - 7);
		end
		return v13:BuffRemains(v80.ImprovedGarroteBuff);
	end
	local function v122()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (796 - (588 + 208))) or ((12632 - 7945) < (6342 - (884 + 916)))) then
				if (((6889 - 3598) > (967 + 700)) and v13:BuffUp(v80.IndiscriminateCarnageAura)) then
					return v13:GCDRemains() + (663 - (232 + 421));
				end
				return v13:BuffRemains(v80.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v49()
		local v168 = 1889 - (1569 + 320);
		while true do
			if ((v168 == (0 + 0)) or ((166 + 707) == (6853 - 4819))) then
				if ((v90 < (607 - (316 + 289))) or ((7371 - 4555) < (1 + 10))) then
					return false;
				elseif (((5152 - (666 + 787)) < (5131 - (360 + 65))) and (v49 == "Always")) then
					return true;
				elseif (((2473 + 173) >= (1130 - (79 + 175))) and (v49 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif (((967 - 353) <= (2485 + 699)) and (v49 == "Auto")) then
					if (((9581 - 6455) == (6019 - 2893)) and (v13:InstanceDifficulty() == (915 - (503 + 396))) and (v14:NPCID() == (139148 - (92 + 89)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v123()
		local v169 = 0 - 0;
		while true do
			if ((v169 == (0 + 0)) or ((1295 + 892) >= (19400 - 14446))) then
				if (v14:DebuffUp(v80.Deathmark) or v14:DebuffUp(v80.Kingsbane) or v13:BuffUp(v80.ShadowDanceBuff) or v14:DebuffUp(v80.ShivDebuff) or (v80.ThistleTea:FullRechargeTime() < (3 + 17)) or (v13:EnergyPercentage() >= (182 - 102)) or (v13:HasTier(28 + 3, 2 + 2) and ((v13:BuffUp(v80.Envenom) and (v13:BuffRemains(v80.Envenom) <= (5 - 3))) or v9.BossFilteredFightRemains("<=", 12 + 78))) or ((5911 - 2034) == (4819 - (485 + 759)))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v124()
		if (((1635 - 928) > (1821 - (442 + 747))) and (v80.Deathmark:CooldownRemains() > v80.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v80.Deathmark:CooldownRemains()))) then
			return v80.Deathmark:CooldownRemains();
		end
		return v80.Sepsis:CooldownRemains();
	end
	local function v125()
		if (not v80.ScentOfBlood:IsAvailable() or ((1681 - (832 + 303)) >= (3630 - (88 + 858)))) then
			return true;
		end
		return v13:BuffStack(v80.ScentOfBloodBuff) >= v26(7 + 13, v80.ScentOfBlood:TalentRank() * (2 + 0) * v90);
	end
	local function v126(v170, v171, v172)
		local v173 = 0 + 0;
		local v172;
		while true do
			if (((2254 - (766 + 23)) <= (21232 - 16931)) and (v173 == (0 - 0))) then
				v172 = v172 or v171:PandemicThreshold();
				return v170:DebuffRefreshable(v171, v172);
			end
		end
	end
	local function v127(v174, v175, v176, v177)
		local v178 = 0 - 0;
		local v179;
		local v180;
		local v181;
		while true do
			if (((5783 - 4079) > (2498 - (1036 + 37))) and (v178 == (1 + 0))) then
				for v227, v228 in v33(v177) do
					if (((v228:GUID() ~= v181) and v78.UnitIsCycleValid(v228, v180, -v228:DebuffRemains(v174)) and v175(v228)) or ((1337 - 650) == (3331 + 903))) then
						v179, v180 = v228, v228:TimeToDie();
					end
				end
				if (v179 or ((4810 - (641 + 839)) < (2342 - (910 + 3)))) then
					v23(v179, v174);
				elseif (((2923 - 1776) >= (2019 - (1466 + 218))) and v48) then
					local v245 = 0 + 0;
					while true do
						if (((4583 - (556 + 592)) > (746 + 1351)) and (v245 == (808 - (329 + 479)))) then
							v179, v180 = nil, v176;
							for v256, v257 in v33(v89) do
								if (((v257:GUID() ~= v181) and v78.UnitIsCycleValid(v257, v180, -v257:DebuffRemains(v174)) and v175(v257)) or ((4624 - (174 + 680)) >= (13885 - 9844))) then
									v179, v180 = v257, v257:TimeToDie();
								end
							end
							v245 = 1 - 0;
						end
						if ((v245 == (1 + 0)) or ((4530 - (396 + 343)) <= (143 + 1468))) then
							if (v179 or ((6055 - (29 + 1448)) <= (3397 - (135 + 1254)))) then
								v23(v179, v174);
							end
							break;
						end
					end
				end
				break;
			end
			if (((4238 - 3113) <= (9693 - 7617)) and (v178 == (0 + 0))) then
				v179, v180 = nil, v176;
				v181 = v14:GUID();
				v178 = 1528 - (389 + 1138);
			end
		end
	end
	local function v128(v182, v183, v184)
		local v185 = 574 - (102 + 472);
		local v186;
		local v187;
		local v188;
		local v189;
		while true do
			if ((v185 == (2 + 0)) or ((413 + 330) >= (4102 + 297))) then
				function v189(v229)
					for v231, v232 in v33(v229) do
						local v233 = 1545 - (320 + 1225);
						local v234;
						while true do
							if (((2056 - 901) < (1024 + 649)) and (v233 == (1464 - (157 + 1307)))) then
								v234 = v183(v232);
								if ((not v187 and (v182 == "first")) or ((4183 - (821 + 1038)) <= (1442 - 864))) then
									if (((412 + 3355) == (6691 - 2924)) and (v234 ~= (0 + 0))) then
										v187, v188 = v232, v234;
									end
								elseif (((10134 - 6045) == (5115 - (834 + 192))) and (v182 == "min")) then
									if (((284 + 4174) >= (430 + 1244)) and (not v187 or (v234 < v188))) then
										v187, v188 = v232, v234;
									end
								elseif (((21 + 951) <= (2196 - 778)) and (v182 == "max")) then
									if (not v187 or (v234 > v188) or ((5242 - (300 + 4)) < (1272 + 3490))) then
										v187, v188 = v232, v234;
									end
								end
								v233 = 2 - 1;
							end
							if ((v233 == (363 - (112 + 250))) or ((999 + 1505) > (10681 - 6417))) then
								if (((1234 + 919) == (1114 + 1039)) and v187 and (v234 == v188) and (v232:TimeToDie() > v187:TimeToDie())) then
									v187, v188 = v232, v234;
								end
								break;
							end
						end
					end
				end
				v189(v91);
				v185 = 3 + 0;
			end
			if (((2 + 2) == v185) or ((377 + 130) >= (4005 - (1001 + 413)))) then
				if (((9992 - 5511) == (5363 - (244 + 638))) and v187 and v184(v187)) then
					return v187;
				end
				return nil;
			end
			if ((v185 == (696 - (627 + 66))) or ((6936 - 4608) < (1295 - (512 + 90)))) then
				if (((6234 - (1665 + 241)) == (5045 - (373 + 344))) and v48) then
					v189(v89);
				end
				if (((717 + 871) >= (353 + 979)) and v187 and (v188 == v186) and v184(v14)) then
					return v14;
				end
				v185 = 10 - 6;
			end
			if ((v185 == (1 - 0)) or ((5273 - (35 + 1064)) > (3091 + 1157))) then
				v187, v188 = nil, 0 - 0;
				v189 = nil;
				v185 = 1 + 1;
			end
			if (((1236 - (298 + 938)) == v185) or ((5845 - (233 + 1026)) <= (1748 - (636 + 1030)))) then
				v186 = v183(v14);
				if (((1976 + 1887) == (3774 + 89)) and (v182 == "first") and (v186 ~= (0 + 0))) then
					return v14;
				end
				v185 = 1 + 0;
			end
		end
	end
	local function v129(v190, v191, v192)
		local v193 = 221 - (55 + 166);
		local v194;
		while true do
			if ((v193 == (0 + 0)) or ((29 + 253) <= (160 - 118))) then
				v194 = v14:TimeToDie();
				if (((4906 - (36 + 261)) >= (1339 - 573)) and not v9.BossFightRemainsIsNotValid()) then
					v194 = v9.BossFightRemains();
				elseif ((v194 < v192) or ((2520 - (34 + 1334)) == (957 + 1531))) then
					return false;
				end
				v193 = 1 + 0;
			end
			if (((4705 - (1035 + 248)) > (3371 - (20 + 1))) and (v193 == (1 + 0))) then
				if (((1196 - (134 + 185)) > (1509 - (549 + 584))) and (v34((v194 - v192) / v190) > v34(((v194 - v192) - v191) / v190))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v130(v195)
		local v196 = 685 - (314 + 371);
		while true do
			if ((v196 == (0 - 0)) or ((4086 - (478 + 490)) <= (981 + 870))) then
				if (v195:DebuffUp(v80.SerratedBoneSpikeDebuff) or ((1337 - (786 + 386)) >= (11310 - 7818))) then
					return 1001379 - (1055 + 324);
				end
				return v195:TimeToDie();
			end
		end
	end
	local function v131(v197)
		return not v197:DebuffUp(v80.SerratedBoneSpikeDebuff);
	end
	local function v132()
		local v198 = 1340 - (1093 + 247);
		while true do
			if (((3510 + 439) < (511 + 4345)) and (v198 == (0 - 0))) then
				if (v80.BloodFury:IsCastable() or ((14511 - 10235) < (8581 - 5565))) then
					if (((11785 - 7095) > (1468 + 2657)) and v9.Cast(v80.BloodFury, v35)) then
						return "Cast Blood Fury";
					end
				end
				if (v80.Berserking:IsCastable() or ((192 - 142) >= (3088 - 2192))) then
					if (v9.Cast(v80.Berserking, v35) or ((1293 + 421) >= (7564 - 4606))) then
						return "Cast Berserking";
					end
				end
				v198 = 689 - (364 + 324);
			end
			if ((v198 == (5 - 3)) or ((3577 - 2086) < (214 + 430))) then
				if (((2945 - 2241) < (1580 - 593)) and v80.ArcaneTorrent:IsCastable() and (v13:EnergyDeficit() > (45 - 30))) then
					if (((4986 - (1249 + 19)) > (1721 + 185)) and v9.Cast(v80.ArcaneTorrent, v35)) then
						return "Cast Arcane Torrent";
					end
				end
				if (v80.ArcanePulse:IsCastable() or ((3728 - 2770) > (4721 - (686 + 400)))) then
					if (((2747 + 754) <= (4721 - (73 + 156))) and v9.Cast(v80.ArcanePulse, v35)) then
						return "Cast Arcane Pulse";
					end
				end
				v198 = 1 + 2;
			end
			if ((v198 == (815 - (721 + 90))) or ((39 + 3403) < (8273 - 5725))) then
				return false;
			end
			if (((3345 - (224 + 246)) >= (2371 - 907)) and (v198 == (5 - 2))) then
				if (v80.LightsJudgment:IsCastable() or ((871 + 3926) >= (117 + 4776))) then
					if (v9.Cast(v80.LightsJudgment, v35) or ((405 + 146) > (4111 - 2043))) then
						return "Cast Lights Judgment";
					end
				end
				if (((7034 - 4920) > (1457 - (203 + 310))) and v80.BagofTricks:IsCastable()) then
					if (v9.Cast(v80.BagofTricks, v35) or ((4255 - (1238 + 755)) >= (217 + 2879))) then
						return "Cast Bag of Tricks";
					end
				end
				v198 = 1538 - (709 + 825);
			end
			if ((v198 == (1 - 0)) or ((3284 - 1029) >= (4401 - (196 + 668)))) then
				if (v80.Fireblood:IsCastable() or ((15149 - 11312) < (2705 - 1399))) then
					if (((3783 - (171 + 662)) == (3043 - (4 + 89))) and v9.Cast(v80.Fireblood, v35)) then
						return "Cast Fireblood";
					end
				end
				if (v80.AncestralCall:IsCastable() or ((16553 - 11830) < (1201 + 2097))) then
					if (((4989 - 3853) >= (61 + 93)) and ((not v80.Kingsbane:IsAvailable() and v14:DebuffUp(v80.ShivDebuff)) or (v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (1494 - (35 + 1451)))))) then
						if (v9.Cast(v80.AncestralCall, v35) or ((1724 - (28 + 1425)) > (6741 - (941 + 1052)))) then
							return "Cast Ancestral Call";
						end
					end
				end
				v198 = 2 + 0;
			end
		end
	end
	local function v133()
		if (((6254 - (822 + 692)) >= (4499 - 1347)) and v80.ShadowDance:IsCastable() and not v80.Kingsbane:IsAvailable()) then
			local v207 = 0 + 0;
			while true do
				if (((297 - (45 + 252)) == v207) or ((2551 + 27) >= (1167 + 2223))) then
					if (((99 - 58) <= (2094 - (114 + 319))) and v80.ImprovedGarrote:IsAvailable() and v80.Garrote:CooldownUp() and ((v14:PMultiplier(v80.Garrote) <= (1 - 0)) or v126(v14, v80.Garrote)) and (v80.Deathmark:AnyDebuffUp() or (v80.Deathmark:CooldownRemains() < (14 - 2)) or (v80.Deathmark:CooldownRemains() > (39 + 21))) and (v96 >= math.min(v90, 5 - 1))) then
						if (((1259 - 658) < (5523 - (556 + 1407))) and (v13:EnergyPredicted() < (1251 - (741 + 465)))) then
							if (((700 - (170 + 295)) < (362 + 325)) and v22(v80.PoolEnergy)) then
								return "Pool for Shadow Dance (Garrote)";
							end
						end
						if (((4179 + 370) > (2838 - 1685)) and v22(v80.ShadowDance, v58)) then
							return "Cast Shadow Dance (Garrote)";
						end
					end
					if ((not v80.ImprovedGarrote:IsAvailable() and v80.MasterAssassin:IsAvailable() and not v126(v14, v80.Rupture) and (v14:DebuffRemains(v80.Garrote) > (3 + 0)) and (v14:DebuffUp(v80.Deathmark) or (v80.Deathmark:CooldownRemains() > (39 + 21))) and (v14:DebuffUp(v80.ShivDebuff) or (v14:DebuffRemains(v80.Deathmark) < (3 + 1)) or v14:DebuffUp(v80.Sepsis)) and (v14:DebuffRemains(v80.Sepsis) < (1233 - (957 + 273)))) or ((1251 + 3423) < (1871 + 2801))) then
						if (((13976 - 10308) < (12019 - 7458)) and v22(v80.ShadowDance, v58)) then
							return "Cast Shadow Dance (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if ((v80.Vanish:IsCastable() and not v13:IsTanking(v14)) or ((1389 - 934) == (17850 - 14245))) then
			if ((v80.ImprovedGarrote:IsAvailable() and not v80.MasterAssassin:IsAvailable() and v80.Garrote:CooldownUp() and ((v14:PMultiplier(v80.Garrote) <= (1781 - (389 + 1391))) or v126(v14, v80.Garrote))) or ((1671 + 992) == (345 + 2967))) then
				local v230 = 0 - 0;
				while true do
					if (((5228 - (783 + 168)) <= (15018 - 10543)) and (v230 == (0 + 0))) then
						if ((not v80.IndiscriminateCarnage:IsAvailable() and (v80.Deathmark:AnyDebuffUp() or (v80.Deathmark:CooldownRemains() < (315 - (309 + 2)))) and (v96 >= v26(v90, 12 - 8))) or ((2082 - (1090 + 122)) == (386 + 803))) then
							local v253 = 0 - 0;
							while true do
								if (((1063 + 490) <= (4251 - (628 + 490))) and (v253 == (0 + 0))) then
									if ((v13:EnergyPredicted() < (111 - 66)) or ((10223 - 7986) >= (4285 - (431 + 343)))) then
										if (v22(v80.PoolEnergy) or ((2673 - 1349) > (8736 - 5716))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (v22(v80.Vanish, v57) or ((2364 + 628) == (241 + 1640))) then
										return "Cast Vanish (Garrote Deathmark)";
									end
									break;
								end
							end
						end
						if (((4801 - (556 + 1139)) > (1541 - (6 + 9))) and v80.IndiscriminateCarnage:IsAvailable() and (v90 > (1 + 1))) then
							local v254 = 0 + 0;
							while true do
								if (((3192 - (28 + 141)) < (1499 + 2371)) and (v254 == (0 - 0))) then
									if (((102 + 41) > (1391 - (486 + 831))) and (v13:EnergyPredicted() < (116 - 71))) then
										if (((63 - 45) < (400 + 1712)) and v22(v80.PoolEnergy)) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((3468 - 2371) <= (2891 - (668 + 595))) and v22(v80.Vanish, v57)) then
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
			if (((4167 + 463) == (934 + 3696)) and v80.MasterAssassin:IsAvailable() and v80.Kingsbane:IsAvailable() and v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) <= (8 - 5)) and v14:DebuffUp(v80.Deathmark) and (v14:DebuffRemains(v80.Deathmark) <= (293 - (23 + 267)))) then
				if (((5484 - (1129 + 815)) > (3070 - (371 + 16))) and v22(v80.Vanish, v57)) then
					return "Cast Vanish (Kingsbane)";
				end
			end
			if (((6544 - (1326 + 424)) >= (6202 - 2927)) and not v80.ImprovedGarrote:IsAvailable() and v80.MasterAssassin:IsAvailable() and not v126(v14, v80.Rupture) and (v14:DebuffRemains(v80.Garrote) > (10 - 7)) and v14:DebuffUp(v80.Deathmark) and (v14:DebuffUp(v80.ShivDebuff) or (v14:DebuffRemains(v80.Deathmark) < (122 - (88 + 30))) or v14:DebuffUp(v80.Sepsis)) and (v14:DebuffRemains(v80.Sepsis) < (774 - (720 + 51)))) then
				if (((3300 - 1816) == (3260 - (421 + 1355))) and v22(v80.Vanish, v57)) then
					return "Cast Vanish (Master Assassin)";
				end
			end
		end
	end
	local function v134()
		if (((2361 - 929) < (1747 + 1808)) and v115:IsReady()) then
			local v208 = 1083 - (286 + 797);
			local v209;
			while true do
				if ((v208 == (0 - 0)) or ((1763 - 698) > (4017 - (397 + 42)))) then
					v209 = v78.HandleTopTrinket(v83, v31, 3 + 5, nil);
					if (v209 or ((5595 - (24 + 776)) < (2166 - 759))) then
						return v209;
					end
					break;
				end
			end
		end
		if (((2638 - (222 + 563)) < (10604 - 5791)) and v116:IsReady()) then
			local v210 = 0 + 0;
			local v211;
			while true do
				if ((v210 == (190 - (23 + 167))) or ((4619 - (690 + 1108)) < (878 + 1553))) then
					v211 = v78.HandleBottomTrinket(v83, v31, 7 + 1, nil);
					if (v211 or ((3722 - (40 + 808)) < (360 + 1821))) then
						return v211;
					end
					break;
				end
			end
		end
	end
	local function v135()
		local v199 = 0 - 0;
		local v200;
		local v201;
		local v202;
		while true do
			if ((v199 == (0 + 0)) or ((1423 + 1266) <= (189 + 154))) then
				if ((v80.Sepsis:IsReady() and (v14:DebuffRemains(v80.Rupture) > (591 - (47 + 524))) and ((not v80.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v80.Garrote)) or (v80.ImprovedGarrote:IsAvailable() and v80.Garrote:CooldownUp() and (v14:PMultiplier(v80.Garrote) <= (1 + 0)))) and (v14:FilteredTimeToDie(">", 27 - 17) or v9.BossFilteredFightRemains("<=", 14 - 4))) or ((4262 - 2393) == (3735 - (1165 + 561)))) then
					if (v22(v80.Sepsis, nil, true) or ((106 + 3440) < (7191 - 4869))) then
						return "Cast Sepsis";
					end
				end
				v200 = v78.HandleDPSPotion();
				if (v200 or ((795 + 1287) == (5252 - (341 + 138)))) then
					return v200;
				end
				v199 = 1 + 0;
			end
			if (((6694 - 3450) > (1381 - (89 + 237))) and ((12 - 8) == v199)) then
				if ((v80.ColdBlood:IsReady() and v13:DebuffDown(v80.ColdBlood) and (v95 >= (8 - 4))) or ((4194 - (581 + 300)) <= (2998 - (855 + 365)))) then
					if (v9.Press(v80.ColdBlood, v60) or ((3375 - 1954) >= (687 + 1417))) then
						return "Cast Cold Blood";
					end
				end
				return false;
			end
			if (((3047 - (1030 + 205)) <= (3051 + 198)) and (v199 == (3 + 0))) then
				if (((1909 - (156 + 130)) <= (4446 - 2489)) and v80.Kingsbane:IsReady() and (v14:DebuffUp(v80.ShivDebuff) or (v80.Shiv:CooldownRemains() < (9 - 3))) and v13:BuffUp(v80.Envenom) and ((v80.Deathmark:CooldownRemains() >= (102 - 52)) or v14:DebuffUp(v80.Deathmark))) then
					if (((1163 + 3249) == (2573 + 1839)) and v22(v80.Kingsbane)) then
						return "Cast Kingsbane";
					end
				end
				if (((1819 - (10 + 59)) >= (239 + 603)) and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and (((v13:EnergyDeficit() >= ((492 - 392) + v108)) and (not v80.Kingsbane:IsAvailable() or (v80.ThistleTea:Charges() >= (1165 - (671 + 492))))) or (v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (5 + 1))) or (not v80.Kingsbane:IsAvailable() and v80.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (1221 - (369 + 846))))) then
					if (((1158 + 3214) > (1579 + 271)) and v9.Cast(v80.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (((2177 - (1036 + 909)) < (653 + 168)) and not v13:StealthUp(true, true) and (v121() <= (0 - 0)) and (v120() <= (203 - (11 + 192)))) then
					local v235 = 0 + 0;
					local v236;
					while true do
						if (((693 - (135 + 40)) < (2185 - 1283)) and (v235 == (0 + 0))) then
							v236 = v133();
							if (((6595 - 3601) > (1286 - 428)) and v236) then
								return v236;
							end
							break;
						end
					end
				end
				v199 = 180 - (50 + 126);
			end
			if ((v199 == (5 - 3)) or ((832 + 2923) <= (2328 - (1233 + 180)))) then
				if (((4915 - (522 + 447)) > (5164 - (107 + 1314))) and v80.Deathmark:IsCastable() and (v202 or v9.BossFilteredFightRemains("<=", 10 + 10))) then
					if (v22(v80.Deathmark, v72) or ((4067 - 2732) >= (1405 + 1901))) then
						return "Cast Deathmark";
					end
				end
				if (((9618 - 4774) > (8914 - 6661)) and v80.Shiv:IsReady() and not v14:DebuffUp(v80.ShivDebuff) and v14:DebuffUp(v80.Garrote) and v14:DebuffUp(v80.Rupture)) then
					local v237 = 1910 - (716 + 1194);
					while true do
						if (((8 + 444) == (49 + 403)) and (v237 == (504 - (74 + 429)))) then
							if ((v80.ArterialPrecision:IsAvailable() and v80.Deathmark:AnyDebuffUp()) or ((8790 - 4233) < (1035 + 1052))) then
								if (((8867 - 4993) == (2741 + 1133)) and v22(v80.Shiv)) then
									return "Cast Shiv (Arterial Precision)";
								end
							end
							if ((not v80.Kingsbane:IsAvailable() and not v80.ArterialPrecision:IsAvailable()) or ((5974 - 4036) > (12202 - 7267))) then
								if (v80.Sepsis:IsAvailable() or ((4688 - (279 + 154)) < (4201 - (454 + 324)))) then
									if (((1144 + 310) <= (2508 - (12 + 5))) and (((v80.Shiv:ChargesFractional() > (0.9 + 0 + v24(v80.LightweightShiv:IsAvailable()))) and (v106 > (12 - 7))) or v14:DebuffUp(v80.Sepsis) or v14:DebuffUp(v80.Deathmark))) then
										if (v22(v80.Shiv) or ((1537 + 2620) <= (3896 - (277 + 816)))) then
											return "Cast Shiv (Sepsis)";
										end
									end
								elseif (((20737 - 15884) >= (4165 - (1058 + 125))) and (not v80.CrimsonTempest:IsAvailable() or v111 or v14:DebuffUp(v80.CrimsonTempest))) then
									if (((776 + 3358) > (4332 - (815 + 160))) and v22(v80.Shiv)) then
										return "Cast Shiv";
									end
								end
							end
							break;
						end
						if ((v237 == (0 - 0)) or ((8111 - 4694) < (605 + 1929))) then
							if (v9.BossFilteredFightRemains("<=", v80.Shiv:Charges() * (23 - 15)) or ((4620 - (41 + 1857)) <= (2057 - (1222 + 671)))) then
								if (v22(v80.Shiv) or ((6223 - 3815) < (3030 - 921))) then
									return "Cast Shiv (End of Fight)";
								end
							end
							if ((v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom)) or ((1215 - (229 + 953)) == (3229 - (1111 + 663)))) then
								local v255 = 1579 - (874 + 705);
								while true do
									if ((v255 == (0 + 0)) or ((303 + 140) >= (8345 - 4330))) then
										if (((96 + 3286) > (845 - (642 + 37))) and not v80.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (2 + 6))) or (v80.Kingsbane:CooldownRemains() >= (4 + 20))) and (not v80.CrimsonTempest:IsAvailable() or v111 or v14:DebuffUp(v80.CrimsonTempest))) then
											if (v22(v80.Shiv) or ((703 - 423) == (3513 - (233 + 221)))) then
												return "Cast Shiv (Kingsbane)";
											end
										end
										if (((4349 - 2468) > (1139 + 154)) and v80.LightweightShiv:IsAvailable() and (v14:DebuffUp(v80.Kingsbane) or (v80.Kingsbane:CooldownRemains() <= (1542 - (718 + 823))))) then
											if (((1484 + 873) == (3162 - (266 + 539))) and v22(v80.Shiv)) then
												return "Cast Shiv (Kingsbane Lightweight)";
											end
										end
										break;
									end
								end
							end
							v237 = 2 - 1;
						end
					end
				end
				if (((1348 - (636 + 589)) == (291 - 168)) and v80.ShadowDance:IsCastable() and v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom) and ((v80.Deathmark:CooldownRemains() >= (103 - 53)) or v202)) then
					if (v22(v80.ShadowDance) or ((837 + 219) >= (1233 + 2159))) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				v199 = 1018 - (657 + 358);
			end
			if ((v199 == (2 - 1)) or ((2462 - 1381) < (2262 - (1151 + 36)))) then
				v201 = v134();
				if (v201 or ((1014 + 35) >= (1166 + 3266))) then
					return v201;
				end
				v202 = not v13:StealthUp(true, false) and v14:DebuffUp(v80.Rupture) and v13:BuffUp(v80.Envenom) and not v80.Deathmark:AnyDebuffUp() and (not v80.MasterAssassin:IsAvailable() or v14:DebuffUp(v80.Garrote)) and (not v80.Kingsbane:IsAvailable() or (v80.Kingsbane:CooldownRemains() <= (5 - 3)));
				v199 = 1834 - (1552 + 280);
			end
		end
	end
	local function v136()
		if ((v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom)) or ((5602 - (64 + 770)) <= (575 + 271))) then
			if ((v80.Shiv:IsReady() and (v14:DebuffUp(v80.Kingsbane) or v80.Kingsbane:CooldownUp()) and v14:DebuffDown(v80.ShivDebuff)) or ((7622 - 4264) <= (253 + 1167))) then
				if (v22(v80.Shiv) or ((4982 - (157 + 1086)) <= (6014 - 3009))) then
					return "Cast Shiv (Stealth Kingsbane)";
				end
			end
			if ((v80.Kingsbane:IsReady() and (v13:BuffRemains(v80.ShadowDanceBuff) >= (8 - 6))) or ((2544 - 885) >= (2912 - 778))) then
				if (v22(v80.Kingsbane, v70) or ((4079 - (599 + 220)) < (4689 - 2334))) then
					return "Cast Kingsbane (Dance)";
				end
			end
		end
		if ((v95 >= (1935 - (1813 + 118))) or ((490 + 179) == (5440 - (841 + 376)))) then
			if ((v14:DebuffUp(v80.Kingsbane) and (v13:BuffRemains(v80.Envenom) <= (2 - 0))) or ((394 + 1298) < (1604 - 1016))) then
				if (v17(v80.Envenom, nil, nil, not v86) or ((5656 - (464 + 395)) < (9369 - 5718))) then
					return "Cast Envenom (Stealth Kingsbane)";
				end
			end
			if ((v111 and v119() and v13:BuffDown(v80.ShadowDanceBuff)) or ((2006 + 2171) > (5687 - (467 + 370)))) then
				if (v17(v80.Envenom, nil, nil, not v86) or ((826 - 426) > (816 + 295))) then
					return "Cast Envenom (Master Assassin)";
				end
			end
		end
		if (((10458 - 7407) > (157 + 848)) and v30 and v80.CrimsonTempest:IsReady() and v80.Nightstalker:IsAvailable() and (v90 >= (6 - 3)) and (v95 >= (524 - (150 + 370))) and not v80.Deathmark:IsReady()) then
			for v222, v223 in v33(v89) do
				if (((4975 - (74 + 1208)) <= (10777 - 6395)) and v126(v223, v80.CrimsonTempest, v98) and v223:FilteredTimeToDie(">", 28 - 22, -v223:DebuffRemains(v80.CrimsonTempest))) then
					if (v17(v80.CrimsonTempest) or ((2336 + 946) > (4490 - (14 + 376)))) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
			end
		end
		if ((v80.Garrote:IsCastable() and (v121() > (0 - 0))) or ((2317 + 1263) < (2499 + 345))) then
			local v212 = 0 + 0;
			local v213;
			local v214;
			while true do
				if (((260 - 171) < (3378 + 1112)) and (v212 == (78 - (23 + 55)))) then
					v213 = nil;
					function v213(v240)
						return v240:DebuffRemains(v80.Garrote);
					end
					v212 = 2 - 1;
				end
				if ((v212 == (3 + 0)) or ((4475 + 508) < (2802 - 994))) then
					if (((1205 + 2624) > (4670 - (652 + 249))) and (v96 >= ((2 - 1) + ((1870 - (708 + 1160)) * v24(v80.ShroudedSuffocation:IsAvailable()))))) then
						if (((4030 - 2545) <= (5294 - 2390)) and v13:BuffDown(v80.ShadowDanceBuff) and ((v14:PMultiplier(v80.Garrote) <= (28 - (10 + 17))) or (v14:DebuffUp(v80.Deathmark) and (v120() < (1 + 2))))) then
							if (((6001 - (1400 + 332)) == (8187 - 3918)) and v17(v80.Garrote)) then
								return "Cast Garrote (Improved Garrote Low CP)";
							end
						end
						if (((2295 - (242 + 1666)) <= (1191 + 1591)) and ((v14:PMultiplier(v80.Garrote) <= (1 + 0)) or (v14:DebuffRemains(v80.Garrote) < (11 + 1)))) then
							if (v17(v80.Garrote) or ((2839 - (850 + 90)) <= (1606 - 689))) then
								return "Cast Garrote (Improved Garrote Low CP 2)";
							end
						end
					end
					break;
				end
				if ((v212 == (1391 - (360 + 1030))) or ((3816 + 496) <= (2472 - 1596))) then
					v214 = nil;
					function v214(v241)
						return ((v241:PMultiplier(v80.Garrote) <= (1 - 0)) or (v241:DebuffRemains(v80.Garrote) < ((1673 - (909 + 752)) / v79.ExsanguinatedRate(v241, v80.Garrote))) or ((v122() > (1223 - (109 + 1114))) and (v80.Garrote:AuraActiveCount() < v90))) and not v111 and (v241:FilteredTimeToDie(">", 3 - 1, -v241:DebuffRemains(v80.Garrote)) or v241:TimeToDieIsNotValid()) and v79.CanDoTUnit(v241, v100);
					end
					v212 = 1 + 1;
				end
				if (((2474 - (6 + 236)) <= (1636 + 960)) and ((2 + 0) == v212)) then
					if (((4940 - 2845) < (6438 - 2752)) and v30) then
						local v246 = v128("min", v213, v214);
						if ((v246 and (v246:GUID() == v19:GUID())) or ((2728 - (1076 + 57)) >= (736 + 3738))) then
							v22(v81.GarroteMouseOver);
						end
					end
					if (v214(v14) or ((5308 - (579 + 110)) < (228 + 2654))) then
						if (v17(v80.Garrote) or ((260 + 34) >= (2564 + 2267))) then
							return "Cast Garrote (Improved Garrote)";
						end
					end
					v212 = 410 - (174 + 233);
				end
			end
		end
		if (((5667 - 3638) <= (5412 - 2328)) and (v95 >= (2 + 2)) and (v14:PMultiplier(v80.Rupture) <= (1175 - (663 + 511))) and (v13:BuffUp(v80.ShadowDanceBuff) or v14:DebuffUp(v80.Deathmark))) then
			if (v17(v80.Rupture) or ((1818 + 219) == (526 + 1894))) then
				return "Cast Rupture (Nightstalker)";
			end
		end
	end
	local function v137()
		if (((13743 - 9285) > (2365 + 1539)) and v30 and v80.CrimsonTempest:IsReady() and (v90 >= (4 - 2)) and (v95 >= (9 - 5)) and (v108 > (12 + 13)) and not v80.Deathmark:IsReady()) then
			for v224, v225 in v33(v89) do
				if (((848 - 412) >= (88 + 35)) and v126(v225, v80.CrimsonTempest, v98) and (v225:PMultiplier(v80.CrimsonTempest) <= (1 + 0)) and v225:FilteredTimeToDie(">", 728 - (478 + 244), -v225:DebuffRemains(v80.CrimsonTempest))) then
					if (((1017 - (440 + 77)) < (826 + 990)) and v17(v80.CrimsonTempest)) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
			end
		end
		if (((13081 - 9507) == (5130 - (655 + 901))) and v80.Garrote:IsCastable() and (v96 >= (1 + 0))) then
			local v215 = 0 + 0;
			local v216;
			while true do
				if (((150 + 71) < (1571 - 1181)) and (v215 == (1446 - (695 + 750)))) then
					if ((v216(v14) and v79.CanDoTUnit(v14, v100) and (v14:FilteredTimeToDie(">", 40 - 28, -v14:DebuffRemains(v80.Garrote)) or v14:TimeToDieIsNotValid())) or ((3414 - 1201) <= (5714 - 4293))) then
						if (((3409 - (285 + 66)) < (11329 - 6469)) and v32(v80.Garrote)) then
							return "Pool for Garrote (ST)";
						end
					end
					break;
				end
				if ((v215 == (1310 - (682 + 628))) or ((209 + 1087) >= (4745 - (176 + 123)))) then
					v216 = nil;
					function v216(v242)
						return v126(v242, v80.Garrote) and (v242:PMultiplier(v80.Garrote) <= (1 + 0));
					end
					v215 = 1 + 0;
				end
			end
		end
		if ((v80.Rupture:IsReady() and (v95 >= (273 - (239 + 30)))) or ((379 + 1014) > (4315 + 174))) then
			v101 = (6 - 2) + (v24(v80.DashingScoundrel:IsAvailable()) * (15 - 10)) + (v24(v80.Doomblade:IsAvailable()) * (320 - (306 + 9))) + (v24(v110) * (20 - 14));
			local function v217(v226)
				return v126(v226, v80.Rupture, v97) and (v226:PMultiplier(v80.Rupture) <= (1 + 0)) and (v226:FilteredTimeToDie(">", v101, -v226:DebuffRemains(v80.Rupture)) or v226:TimeToDieIsNotValid());
			end
			if ((v217(v14) and v79.CanDoTUnit(v14, v99)) or ((2715 + 1709) < (13 + 14))) then
				if (v22(v80.Rupture) or ((5710 - 3713) > (5190 - (1140 + 235)))) then
					return "Cast Rupture";
				end
			end
		end
		if (((2206 + 1259) > (1755 + 158)) and v80.Garrote:IsCastable() and (v96 >= (1 + 0)) and (v120() <= (52 - (33 + 19))) and ((v14:PMultiplier(v80.Garrote) <= (1 + 0)) or ((v14:DebuffRemains(v80.Garrote) < v93) and (v90 >= (8 - 5)))) and (v14:DebuffRemains(v80.Garrote) < (v93 * (1 + 1))) and (v90 >= (5 - 2)) and (v14:FilteredTimeToDie(">", 4 + 0, -v14:DebuffRemains(v80.Garrote)) or v14:TimeToDieIsNotValid())) then
			if (((1422 - (586 + 103)) < (166 + 1653)) and v22(v80.Garrote)) then
				return "Garrote (Fallback)";
			end
		end
		return false;
	end
	local function v138()
		local v203 = 0 - 0;
		while true do
			if ((v203 == (1490 - (1309 + 179))) or ((7934 - 3539) == (2070 + 2685))) then
				if ((v31 and v80.EchoingReprimand:IsReady()) or ((10186 - 6393) < (1790 + 579))) then
					if (v22(v80.EchoingReprimand) or ((8676 - 4592) == (528 - 263))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((4967 - (295 + 314)) == (10703 - 6345)) and v80.FanofKnives:IsCastable()) then
					if ((v30 and (v90 >= (1964 - (1300 + 662))) and (v90 >= ((6 - 4) + v24(v13:StealthUp(true, false)) + v24(v80.DragonTemperedBlades:IsAvailable())))) or ((4893 - (1178 + 577)) < (516 + 477))) then
						if (((9844 - 6514) > (3728 - (851 + 554))) and v22(v80.FanofKnives)) then
							return "Cast Fan of Knives";
						end
					end
					if ((v30 and v13:BuffUp(v80.DeadlyPoison) and (v90 >= (3 + 0))) or ((10056 - 6430) == (8663 - 4674))) then
						for v251, v252 in v33(v89) do
							if ((not v252:DebuffUp(v80.DeadlyPoisonDebuff, true) and (not v104 or v252:DebuffUp(v80.Garrote) or v252:DebuffUp(v80.Rupture))) or ((1218 - (115 + 187)) == (2046 + 625))) then
								if (((258 + 14) == (1071 - 799)) and v22(v80.FanofKnives)) then
									return "Cast Fan of Knives (DP Refresh)";
								end
							end
						end
					end
				end
				v203 = 1164 - (160 + 1001);
			end
			if (((3718 + 531) <= (3339 + 1500)) and (v203 == (0 - 0))) then
				if (((3135 - (237 + 121)) < (4097 - (525 + 372))) and v80.Envenom:IsReady() and (v95 >= (7 - 3)) and (v105 or (v14:DebuffStack(v80.AmplifyingPoisonDebuff) >= (65 - 45)) or (v95 > v79.CPMaxSpend()) or not v111)) then
					if (((237 - (96 + 46)) < (2734 - (643 + 134))) and v22(v80.Envenom)) then
						return "Cast Envenom";
					end
				end
				if (((299 + 527) < (4116 - 2399)) and not ((v96 > (3 - 2)) or v105 or not v111)) then
					return false;
				end
				v203 = 1 + 0;
			end
			if (((2798 - 1372) >= (2258 - 1153)) and (v203 == (722 - (316 + 403)))) then
				if (((1831 + 923) <= (9290 - 5911)) and (v80.Ambush:IsCastable() or v80.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v80.BlindsideBuff) or v13:BuffUp(v80.SepsisBuff)) and (v14:DebuffDown(v80.Kingsbane) or v14:DebuffDown(v80.Deathmark) or v13:BuffUp(v80.BlindsideBuff))) then
					if (v22(v80.Ambush) or ((1420 + 2507) == (3558 - 2145))) then
						return "Cast Ambush";
					end
				end
				if ((v80.Mutilate:IsCastable() and (v90 == (2 + 0)) and v14:DebuffDown(v80.DeadlyPoisonDebuff, true) and v14:DebuffDown(v80.AmplifyingPoisonDebuff, true)) or ((372 + 782) <= (2730 - 1942))) then
					local v238 = v14:GUID();
					for v243, v244 in v33(v91) do
					end
				end
				v203 = 19 - 15;
			end
			if ((v203 == (7 - 3)) or ((95 + 1548) > (6651 - 3272))) then
				if (v80.Mutilate:IsCastable() or ((137 + 2666) > (13383 - 8834))) then
					if (v22(v80.Mutilate) or ((237 - (12 + 5)) >= (11737 - 8715))) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
			if (((6020 - 3198) == (5998 - 3176)) and (v203 == (2 - 1))) then
				if ((not v111 and v80.CausticSpatter:IsAvailable() and v14:DebuffUp(v80.Rupture) and (v14:DebuffRemains(v80.CausticSpatterDebuff) <= (1 + 1))) or ((3034 - (1656 + 317)) == (1655 + 202))) then
					local v239 = 0 + 0;
					while true do
						if (((7338 - 4578) > (6712 - 5348)) and (v239 == (354 - (5 + 349)))) then
							if (v80.Mutilate:IsCastable() or ((23283 - 18381) <= (4866 - (266 + 1005)))) then
								if (v22(v80.Mutilate) or ((2539 + 1313) == (999 - 706))) then
									return "Cast Mutilate (Casutic)";
								end
							end
							if (((v80.Ambush:IsCastable() or v80.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v80.BlindsideBuff))) or ((2051 - 492) == (6284 - (561 + 1135)))) then
								if (v22(v80.Ambush) or ((5843 - 1359) == (2590 - 1802))) then
									return "Cast Ambush (Caustic)";
								end
							end
							break;
						end
					end
				end
				if (((5634 - (507 + 559)) >= (9803 - 5896)) and v80.SerratedBoneSpike:IsReady()) then
					if (((3853 - 2607) < (3858 - (212 + 176))) and not v14:DebuffUp(v80.SerratedBoneSpikeDebuff)) then
						if (((4973 - (250 + 655)) >= (2650 - 1678)) and v22(v80.SerratedBoneSpike)) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v247 = 0 - 0;
						while true do
							if (((770 - 277) < (5849 - (1869 + 87))) and (v247 == (0 - 0))) then
								if (v30 or ((3374 - (484 + 1417)) >= (7141 - 3809))) then
									if (v78.CastTargetIf(v80.SerratedBoneSpike, v88, "min", v130, v131) or ((6788 - 2737) <= (1930 - (48 + 725)))) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if (((986 - 382) < (7729 - 4848)) and (v120() < (0.8 + 0))) then
									if ((v9.BossFightRemains() <= (13 - 8)) or ((v80.SerratedBoneSpike:MaxCharges() - v80.SerratedBoneSpike:ChargesFractional()) <= (0.25 + 0)) or ((263 + 637) == (4230 - (152 + 701)))) then
										if (((5770 - (430 + 881)) > (227 + 364)) and v22(v80.SerratedBoneSpike)) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif (((4293 - (557 + 338)) >= (708 + 1687)) and not v111 and v14:DebuffUp(v80.ShivDebuff)) then
										if (v22(v80.SerratedBoneSpike) or ((6151 - 3968) >= (9888 - 7064))) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v203 = 4 - 2;
			end
		end
	end
	local function v139()
		v77();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v84 = (v80.AcrobaticStrikes:IsAvailable() and (17 - 9)) or (806 - (499 + 302));
		v85 = (v80.AcrobaticStrikes:IsAvailable() and (879 - (39 + 827))) or (27 - 17);
		v86 = v14:IsInMeleeRange(v84);
		v87 = v14:IsInMeleeRange(v85);
		if (((4323 - 2387) == (7689 - 5753)) and v30) then
			v88 = v13:GetEnemiesInRange(46 - 16);
			v89 = v13:GetEnemiesInMeleeRange(v85);
			v90 = #v89;
			v91 = v13:GetEnemiesInMeleeRange(v84);
		else
			v88 = {};
			v89 = {};
			v90 = 1 + 0;
			v91 = {};
		end
		v93, v94 = (5 - 3) * v13:SpellHaste(), (1 + 0) * v13:SpellHaste();
		v95 = v79.EffectiveComboPoints(v13:ComboPoints());
		v96 = v13:ComboPointsMax() - v95;
		v97 = ((5 - 1) + (v95 * (108 - (103 + 1)))) * (554.3 - (475 + 79));
		v98 = ((8 - 4) + (v95 * (6 - 4))) * (0.3 + 0);
		v99 = v80.Envenom:Damage() * v65;
		v100 = v80.Mutilate:Damage() * v66;
		v104 = v49();
		v92 = v79.CrimsonVial();
		if (v92 or ((4253 + 579) < (5816 - (1395 + 108)))) then
			return v92;
		end
		if (((11895 - 7807) > (5078 - (7 + 1197))) and v37 and (v13:HealthPercentage() <= v39)) then
			if (((1889 + 2443) == (1512 + 2820)) and (v38 == "Refreshing Healing Potion")) then
				if (((4318 - (27 + 292)) >= (8498 - 5598)) and v82.RefreshingHealingPotion:IsReady()) then
					if (v9.Press(v81.RefreshingHealingPotion) or ((3220 - 695) > (17043 - 12979))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((8619 - 4248) == (8324 - 3953)) and (v38 == "Dreamwalker's Healing Potion")) then
				if (v82.DreamwalkersHealingPotion:IsReady() or ((405 - (43 + 96)) > (20338 - 15352))) then
					if (((4501 - 2510) >= (768 + 157)) and v9.Press(v81.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		v92 = v79.Feint();
		if (((129 + 326) < (4057 - 2004)) and v92) then
			return v92;
		end
		if ((v80.Evasion:IsCastable() and v80.Evasion:IsReady() and (v13:HealthPercentage() <= v75)) or ((317 + 509) == (9091 - 4240))) then
			if (((58 + 125) == (14 + 169)) and v9.Cast(v80.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((2910 - (1414 + 337)) <= (3728 - (1642 + 298))) and not v13:AffectingCombat() and not v13:IsMounted() and v78.TargetIsValid()) then
			v92 = v79.Stealth(v80.Stealth2, nil);
			if (v92 or ((9142 - 5635) > (12422 - 8104))) then
				return "Stealth (OOC): " .. v92;
			end
		end
		v79.Poisons();
		if (not v13:AffectingCombat() or ((9125 - 6050) <= (976 + 1989))) then
			local v218 = 0 + 0;
			while true do
				if (((2337 - (357 + 615)) <= (1412 + 599)) and (v218 == (0 - 0))) then
					if (not v13:BuffUp(v79.VanishBuffSpell()) or ((2379 + 397) > (7661 - 4086))) then
						local v248 = 0 + 0;
						while true do
							if ((v248 == (0 + 0)) or ((1606 + 948) == (6105 - (384 + 917)))) then
								v92 = v79.Stealth(v79.StealthSpell());
								if (((3274 - (128 + 569)) == (4120 - (1407 + 136))) and v92) then
									return v92;
								end
								break;
							end
						end
					end
					if (v78.TargetIsValid() or ((1893 - (687 + 1200)) >= (3599 - (556 + 1154)))) then
						local v249 = 0 - 0;
						while true do
							if (((601 - (9 + 86)) <= (2313 - (275 + 146))) and (v249 == (0 + 0))) then
								if (v31 or ((2072 - (29 + 35)) > (9829 - 7611))) then
									if (((1131 - 752) <= (18306 - 14159)) and v29 and v80.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v79.CPMaxSpend()) and v78.TargetIsValid()) then
										if (v9.Press(v80.MarkedforDeath, v61) or ((2941 + 1573) <= (2021 - (53 + 959)))) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (not v13:BuffUp(v80.SliceandDice) or ((3904 - (312 + 96)) == (2068 - 876))) then
									if ((v80.SliceandDice:IsReady() and (v95 >= (287 - (147 + 138)))) or ((1107 - (813 + 86)) == (2674 + 285))) then
										if (((7924 - 3647) >= (1805 - (18 + 474))) and v9.Press(v80.SliceandDice)) then
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
		v79.MfDSniping(v80.MarkedforDeath);
		if (((873 + 1714) < (10359 - 7185)) and v78.TargetIsValid()) then
			local v219 = 1086 - (860 + 226);
			local v220;
			local v221;
			while true do
				if ((v219 == (303 - (121 + 182))) or ((508 + 3612) <= (3438 - (988 + 252)))) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((181 + 1415) == (269 + 589))) then
						local v250 = v78.Interrupt(v80.Kick, 1978 - (49 + 1921), true);
						if (((4110 - (223 + 667)) == (3272 - (51 + 1))) and v250) then
							return v250;
						end
						v250 = v78.Interrupt(v80.Kick, 13 - 5, true, v19, v81.KickMouseover);
						if (v250 or ((3001 - 1599) > (4745 - (146 + 979)))) then
							return v250;
						end
						v250 = v78.Interrupt(v80.Blind, 5 + 10, v76);
						if (((3179 - (311 + 294)) == (7178 - 4604)) and v250) then
							return v250;
						end
						v250 = v78.Interrupt(v80.Blind, 7 + 8, v76, v19, v81.BlindMouseover);
						if (((3241 - (496 + 947)) < (4115 - (1233 + 125))) and v250) then
							return v250;
						end
						v250 = v78.InterruptWithStun(v80.CheapShot, 4 + 4, v13:StealthUp(false, false));
						if (v250 or ((339 + 38) > (495 + 2109))) then
							return v250;
						end
						v250 = v78.InterruptWithStun(v80.KidneyShot, 1653 - (963 + 682), v13:ComboPoints() > (0 + 0));
						if (((2072 - (504 + 1000)) < (614 + 297)) and v250) then
							return v250;
						end
					end
					v107 = v79.PoisonedBleeds();
					v108 = v13:EnergyRegen() + ((v107 * (6 + 0)) / ((1 + 1) * v13:SpellHaste()));
					v109 = v13:EnergyDeficit() / v108;
					v219 = 1 - 0;
				end
				if (((2807 + 478) < (2459 + 1769)) and ((184 - (156 + 26)) == v219)) then
					v111 = v90 < (2 + 0);
					if (((6126 - 2210) > (3492 - (149 + 15))) and (v13:StealthUp(true, false) or (v121() > (960 - (890 + 70))) or (v120() > (117 - (39 + 78))))) then
						v92 = v136();
						if (((2982 - (14 + 468)) < (8441 - 4602)) and v92) then
							return v92 .. " (Stealthed)";
						end
					end
					v92 = v134();
					if (((1417 - 910) == (262 + 245)) and v92) then
						return v92;
					end
					v219 = 2 + 1;
				end
				if (((51 + 189) <= (1430 + 1735)) and (v219 == (2 + 4))) then
					if (((1595 - 761) >= (796 + 9)) and v80.Mutilate:IsCastable() and (v13:ComboPoints() < (17 - 12))) then
						if (v22(v80.Mutilate) or ((97 + 3715) < (2367 - (12 + 39)))) then
							return "Cast Mutilate (Fallback)";
						end
					end
					if ((v80.Envenom:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (5 + 0)) and (v13:ComboPoints() >= (12 - 8))) or ((9445 - 6793) <= (455 + 1078))) then
						if (v22(v80.Envenom) or ((1894 + 1704) < (3702 - 2242))) then
							return "Cast Envenom (ppolling)";
						end
					end
					break;
				end
				if ((v219 == (1 + 0)) or ((19891 - 15775) < (2902 - (1596 + 114)))) then
					v110 = v108 > (91 - 56);
					v105 = v123();
					v106 = v124();
					v112 = v125();
					v219 = 715 - (164 + 549);
				end
				if ((v219 == (1443 - (1059 + 379))) or ((4192 - 815) <= (468 + 435))) then
					if (((671 + 3305) >= (831 - (145 + 247))) and v92) then
						return v92;
					end
					v92 = v138();
					if (((3079 + 673) == (1734 + 2018)) and v92) then
						return v92;
					end
					if (((11994 - 7948) > (518 + 2177)) and (v80.Ambush:IsCastable() or (v80.AmbushOverride:IsCastable() and (v13:ComboPoints() < (4 + 0))))) then
						if (v22(v80.Ambush) or ((5755 - 2210) == (3917 - (254 + 466)))) then
							return "Ambush";
						end
					end
					v219 = 566 - (544 + 16);
				end
				if (((7608 - 5214) > (1001 - (294 + 334))) and (v219 == (257 - (236 + 17)))) then
					v221 = v132();
					if (((1792 + 2363) <= (3295 + 937)) and v221) then
						return v221;
					end
					if (not v13:BuffUp(v80.SliceandDice) or ((13486 - 9905) == (16442 - 12969))) then
						if (((2572 + 2423) > (2758 + 590)) and ((v80.SliceandDice:IsReady() and (v13:ComboPoints() >= (796 - (413 + 381))) and v14:DebuffUp(v80.Rupture)) or (not v80.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (1 + 3)) and (v13:BuffRemains(v80.SliceandDice) < (((1 - 0) + v13:ComboPoints()) * (2.8 - 1)))))) then
							if (v22(v80.SliceandDice) or ((2724 - (582 + 1388)) > (6344 - 2620))) then
								return "Cast Slice and Dice";
							end
						end
					elseif (((156 + 61) >= (421 - (326 + 38))) and v87 and v80.CutToTheChase:IsAvailable()) then
						if ((v80.Envenom:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (14 - 9)) and (v13:ComboPoints() >= (5 - 1))) or ((2690 - (47 + 573)) >= (1424 + 2613))) then
							if (((11488 - 8783) == (4390 - 1685)) and v22(v80.Envenom)) then
								return "Cast Envenom (CttC)";
							end
						end
					elseif (((1725 - (1269 + 395)) == (553 - (76 + 416))) and v80.PoisonedKnife:IsCastable() and v14:IsInRange(473 - (319 + 124)) and not v13:StealthUp(true, true) and (v90 == (0 - 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (1008.5 - (564 + 443))))) then
						if (v22(v80.PoisonedKnife) or ((1934 - 1235) >= (1754 - (337 + 121)))) then
							return "Cast Poisoned Knife";
						end
					end
					v92 = v137();
					v219 = 14 - 9;
				end
				if ((v219 == (9 - 6)) or ((3694 - (1261 + 650)) >= (1530 + 2086))) then
					v220 = v78.HandleDPSPotion();
					if (v220 or ((6235 - 2322) > (6344 - (772 + 1045)))) then
						return v220;
					end
					v92 = v135();
					if (((618 + 3758) > (961 - (102 + 42))) and v92) then
						return v92;
					end
					v219 = 1848 - (1524 + 320);
				end
			end
		end
	end
	local function v140()
		v80.Deathmark:RegisterAuraTracking();
		v80.Sepsis:RegisterAuraTracking();
		v80.Garrote:RegisterAuraTracking();
		v9.Print("Assassination Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(1529 - (1049 + 221), v139, v140);
end;
return v0["Epix_Rogue_Assassination.lua"]();

