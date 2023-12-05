local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4821 - (455 + 974)) >= (8548 - 3807))) then
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
	local v17 = v9.Item;
	local v18 = v9.Macro;
	local v19 = v9.Press;
	local v20 = v9.Commons.Everyone.num;
	local v21 = v9.Commons.Everyone.bool;
	local v22 = math.min;
	local v23 = math.abs;
	local v24 = math.max;
	local v25 = false;
	local v26 = false;
	local v27 = false;
	local v28 = v9.CastPooling;
	local v29 = pairs;
	local v30 = math.floor;
	local v31;
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
	local function v72()
		local v136 = 683 - (27 + 656);
		while true do
			if (((2905 + 420) >= (787 + 1367)) and (v136 == (2 + 0))) then
				v45 = EpicSettings.Settings['UsePriorityRotation'];
				v50 = EpicSettings.Settings['STMfDAsDPSCD'];
				v51 = EpicSettings.Settings['KidneyShotInterrupt'];
				v52 = EpicSettings.Settings['RacialsGCD'];
				v53 = EpicSettings.Settings['RacialsOffGCD'];
				v54 = EpicSettings.Settings['VanishOffGCD'];
				v136 = 1 + 2;
			end
			if ((v136 == (0 - 0)) or ((3206 - (340 + 1571)) >= (1276 + 1957))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (1772 - (1733 + 39));
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (1034 - (125 + 909));
				v136 = 1949 - (1096 + 852);
			end
			if (((1964 + 2413) > (2344 - 702)) and (v136 == (3 + 0))) then
				v55 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v56 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v57 = EpicSettings.Settings['ColdBloodOffGCD'];
				v58 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v59 = EpicSettings.Settings['CrimsonVialHP'] or (513 - (409 + 103));
				v60 = EpicSettings.Settings['FeintHP'] or (237 - (46 + 190));
				v136 = 99 - (51 + 44);
			end
			if (((1333 + 3390) > (2673 - (1114 + 203))) and ((730 - (228 + 498)) == v136)) then
				v61 = EpicSettings.Settings['StealthOOC'];
				v62 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 + 0);
				v63 = EpicSettings.Settings['MutilateDMGOffset'] or (1 + 0);
				v64 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v65 = EpicSettings.Settings['PotionTypeSelected'];
				v66 = EpicSettings.Settings['ExsanguinateGCD'];
				v136 = 668 - (174 + 489);
			end
			if ((v136 == (2 - 1)) or ((6041 - (830 + 1075)) <= (3957 - (303 + 221)))) then
				v38 = EpicSettings.Settings['InterruptWithStun'] or (1269 - (231 + 1038));
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v40 = EpicSettings.Settings['InterruptThreshold'] or (1162 - (171 + 991));
				v42 = EpicSettings.Settings['PoisonRefresh'];
				v43 = EpicSettings.Settings['PoisonRefreshCombat'];
				v44 = EpicSettings.Settings['RangedMultiDoT'];
				v136 = 8 - 6;
			end
			if (((11398 - 7153) <= (11556 - 6925)) and (v136 == (5 + 0))) then
				v67 = EpicSettings.Settings['KingsbaneGCD'];
				v68 = EpicSettings.Settings['ShivGCD'];
				v69 = EpicSettings.Settings['DeathmarkOffGCD'];
				v71 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v70 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
		end
	end
	local v73 = v9.Commons.Everyone;
	local v74 = v9.Commons.Rogue;
	local v75 = v15.Rogue.Assassination;
	local v76 = v18.Rogue.Assassination;
	local v77 = v17.Rogue.Assassination;
	local v78 = {v77.AlgetharPuzzleBox,v77.AshesoftheEmbersoul,v77.WitherbarksBranch};
	local v79, v80, v81, v82;
	local v83, v84, v85, v86;
	local v87;
	local v88, v89 = (6 - 4) * v13:SpellHaste(), (1249 - (111 + 1137)) * v13:SpellHaste();
	local v90, v91;
	local v92, v93, v94, v95, v96, v97, v98;
	local v99;
	local v100, v101, v102, v103, v104, v105, v106, v107;
	local v108 = 158 - (91 + 67);
	local v109 = v13:GetEquipment();
	local v110 = (v109[38 - 25] and v17(v109[4 + 9])) or v17(523 - (423 + 100));
	local v111 = (v109[1 + 13] and v17(v109[38 - 24])) or v17(0 + 0);
	local function v112()
		if (((5047 - (326 + 445)) >= (17080 - 13166)) and v110:HasStatAnyDps() and (not v111:HasStatAnyDps() or (v110:Cooldown() >= v111:Cooldown()))) then
			v108 = 2 - 1;
		elseif (((461 - 263) <= (5076 - (530 + 181))) and v111:HasStatAnyDps() and (not v110:HasStatAnyDps() or (v111:Cooldown() > v110:Cooldown()))) then
			v108 = 883 - (614 + 267);
		else
			v108 = 32 - (19 + 13);
		end
	end
	v112();
	v9:RegisterForEvent(function()
		local v137 = 0 - 0;
		while true do
			if (((11143 - 6361) > (13357 - 8681)) and ((1 + 0) == v137)) then
				v111 = (v109[24 - 10] and v17(v109[28 - 14])) or v17(1812 - (1293 + 519));
				v112();
				break;
			end
			if (((9923 - 5059) > (5736 - 3539)) and (v137 == (0 - 0))) then
				v109 = v13:GetEquipment();
				v110 = (v109[56 - 43] and v17(v109[30 - 17])) or v17(0 + 0);
				v137 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v113 = {{v75.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v75.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v90 > (0 - 0);
	end}};
	v75.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v90 * (0.22 + 0) * (1 + 0) * ((v14:DebuffUp(v75.ShivDebuff) and (1.3 - 0)) or (1 + 0)) * ((v75.DeeperStratagem:IsAvailable() and (1.05 - 0)) or (1 - 0)) * ((1881 - (446 + 1434)) + (v13:MasteryPct() / (1383 - (1040 + 243)))) * ((2 - 1) + (v13:VersatilityDmgPct() / (1947 - (559 + 1288))));
	end);
	v75.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (1931.485 - (609 + 1322)) * (455 - (13 + 441)) * ((3 - 2) + (v13:VersatilityDmgPct() / (261 - 161)));
	end);
	local function v114()
		return v13:BuffRemains(v75.MasterAssassinBuff) == (49799 - 39800);
	end
	local function v115()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (0 - 0)) or ((1315 + 2385) == (1099 + 1408))) then
				if (((13276 - 8802) >= (150 + 124)) and v114()) then
					return v13:GCDRemains() + (4 - 1);
				end
				return v13:BuffRemains(v75.MasterAssassinBuff);
			end
		end
	end
	local function v116()
		if (v13:BuffUp(v75.ImprovedGarroteAura) or ((1253 + 641) <= (782 + 624))) then
			return v13:GCDRemains() + 3 + 0;
		end
		return v13:BuffRemains(v75.ImprovedGarroteBuff);
	end
	local function v117()
		if (((1320 + 252) >= (1498 + 33)) and v13:BuffUp(v75.IndiscriminateCarnageAura)) then
			return v13:GCDRemains() + (443 - (153 + 280));
		end
		return v13:BuffRemains(v75.IndiscriminateCarnageBuff);
	end
	local function v45()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (0 + 0)) or ((1851 + 2836) < (2377 + 2165))) then
				if (((2987 + 304) > (1208 + 459)) and (v85 < (2 - 0))) then
					return false;
				elseif ((v45 == "Always") or ((540 + 333) == (2701 - (89 + 578)))) then
					return true;
				elseif (((v45 == "On Bosses") and v14:IsInBossList()) or ((2012 + 804) < (22 - 11))) then
					return true;
				elseif (((4748 - (572 + 477)) < (635 + 4071)) and (v45 == "Auto")) then
					if (((1588 + 1058) >= (105 + 771)) and (v13:InstanceDifficulty() == (102 - (84 + 2))) and (v14:NPCID() == (229026 - 90059))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v118()
		if (((443 + 171) <= (4026 - (497 + 345))) and (v14:DebuffUp(v75.Deathmark) or v14:DebuffUp(v75.Kingsbane) or v13:BuffUp(v75.ShadowDanceBuff) or v14:DebuffUp(v75.ShivDebuff) or (v75.ThistleTea:FullRechargeTime() < (1 + 19)) or (v13:EnergyPercentage() >= (14 + 66)) or (v13:HasTier(1364 - (605 + 728), 3 + 1) and ((v13:BuffUp(v75.Envenom) and (v13:BuffRemains(v75.Envenom) <= (3 - 1))) or v9.BossFilteredFightRemains("<=", 5 + 85))))) then
			return true;
		end
		return false;
	end
	local function v119()
		if (((11557 - 8431) == (2819 + 307)) and (v75.Deathmark:CooldownRemains() > v75.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v75.Deathmark:CooldownRemains()))) then
			return v75.Deathmark:CooldownRemains();
		end
		return v75.Sepsis:CooldownRemains();
	end
	local function v120()
		if (not v75.ScentOfBlood:IsAvailable() or ((6059 - 3872) >= (3741 + 1213))) then
			return true;
		end
		return v13:BuffStack(v75.ScentOfBloodBuff) >= v22(509 - (457 + 32), v75.ScentOfBlood:TalentRank() * (1 + 1) * v85);
	end
	local function v121(v140, v141, v142)
		local v143 = 1402 - (832 + 570);
		local v142;
		while true do
			if (((0 + 0) == v143) or ((1012 + 2865) == (12651 - 9076))) then
				v142 = v142 or v141:PandemicThreshold();
				return v140:DebuffRefreshable(v141, v142);
			end
		end
	end
	local function v122(v144, v145, v146, v147)
		local v148, v149 = nil, v146;
		local v150 = v14:GUID();
		for v172, v173 in v29(v147) do
			if (((341 + 366) > (1428 - (588 + 208))) and (v173:GUID() ~= v150) and v73.UnitIsCycleValid(v173, v149, -v173:DebuffRemains(v144)) and v145(v173)) then
				v148, v149 = v173, v173:TimeToDie();
			end
		end
		if (v148 or ((1471 - 925) >= (4484 - (884 + 916)))) then
			v19(v148, v144);
		elseif (((3067 - 1602) <= (2494 + 1807)) and v44) then
			local v213 = 653 - (232 + 421);
			while true do
				if (((3593 - (1569 + 320)) > (350 + 1075)) and (v213 == (0 + 0))) then
					v148, v149 = nil, v146;
					for v237, v238 in v29(v84) do
						if (((v238:GUID() ~= v150) and v73.UnitIsCycleValid(v238, v149, -v238:DebuffRemains(v144)) and v145(v238)) or ((2314 - 1627) == (4839 - (316 + 289)))) then
							v148, v149 = v238, v238:TimeToDie();
						end
					end
					v213 = 2 - 1;
				end
				if ((v213 == (1 + 0)) or ((4783 - (666 + 787)) < (1854 - (360 + 65)))) then
					if (((1072 + 75) >= (589 - (79 + 175))) and v148) then
						v19(v148, v144);
					end
					break;
				end
			end
		end
	end
	local function v123(v151, v152, v153)
		local v154 = 0 - 0;
		local v155;
		local v156;
		local v157;
		local v158;
		while true do
			if (((2681 + 754) > (6427 - 4330)) and (v154 == (1 - 0))) then
				v156, v157 = nil, 899 - (503 + 396);
				v158 = nil;
				v154 = 183 - (92 + 89);
			end
			if (((0 - 0) == v154) or ((1934 + 1836) >= (2392 + 1649))) then
				v155 = v152(v14);
				if (((v151 == "first") and (v155 ~= (0 - 0))) or ((519 + 3272) <= (3673 - 2062))) then
					return v14;
				end
				v154 = 1 + 0;
			end
			if ((v154 == (1 + 1)) or ((13942 - 9364) <= (251 + 1757))) then
				function v158(v214)
					for v216, v217 in v29(v214) do
						local v218 = 0 - 0;
						local v219;
						while true do
							if (((2369 - (485 + 759)) <= (4803 - 2727)) and (v218 == (1190 - (442 + 747)))) then
								if ((v156 and (v219 == v157) and (v217:TimeToDie() > v156:TimeToDie())) or ((1878 - (832 + 303)) >= (5345 - (88 + 858)))) then
									v156, v157 = v217, v219;
								end
								break;
							end
							if (((353 + 802) < (1385 + 288)) and (v218 == (0 + 0))) then
								v219 = v152(v217);
								if ((not v156 and (v151 == "first")) or ((3113 - (766 + 23)) <= (2853 - 2275))) then
									if (((5151 - 1384) == (9924 - 6157)) and (v219 ~= (0 - 0))) then
										v156, v157 = v217, v219;
									end
								elseif (((5162 - (1036 + 37)) == (2900 + 1189)) and (v151 == "min")) then
									if (((8681 - 4223) >= (1317 + 357)) and (not v156 or (v219 < v157))) then
										v156, v157 = v217, v219;
									end
								elseif (((2452 - (641 + 839)) <= (2331 - (910 + 3))) and (v151 == "max")) then
									if (not v156 or (v219 > v157) or ((12588 - 7650) < (6446 - (1466 + 218)))) then
										v156, v157 = v217, v219;
									end
								end
								v218 = 1 + 0;
							end
						end
					end
				end
				v158(v86);
				v154 = 1151 - (556 + 592);
			end
			if ((v154 == (2 + 2)) or ((3312 - (329 + 479)) > (5118 - (174 + 680)))) then
				if (((7397 - 5244) == (4461 - 2308)) and v156 and v153(v156)) then
					return v156;
				end
				return nil;
			end
			if ((v154 == (3 + 0)) or ((1246 - (396 + 343)) >= (230 + 2361))) then
				if (((5958 - (29 + 1448)) == (5870 - (135 + 1254))) and v44) then
					v158(v84);
				end
				if ((v156 and (v157 == v155) and v153(v14)) or ((8770 - 6442) < (3235 - 2542))) then
					return v14;
				end
				v154 = 3 + 1;
			end
		end
	end
	local function v124(v159, v160, v161)
		local v162 = v14:TimeToDie();
		if (((5855 - (389 + 1138)) == (4902 - (102 + 472))) and not v9.BossFightRemainsIsNotValid()) then
			v162 = v9.BossFightRemains();
		elseif (((1499 + 89) >= (739 + 593)) and (v162 < v161)) then
			return false;
		end
		if ((v30((v162 - v161) / v159) > v30(((v162 - v161) - v160) / v159)) or ((3892 + 282) > (5793 - (320 + 1225)))) then
			return true;
		end
		return false;
	end
	local function v125(v163)
		if (v163:DebuffUp(v75.SerratedBoneSpikeDebuff) or ((8163 - 3577) <= (51 + 31))) then
			return 1001464 - (157 + 1307);
		end
		return v163:TimeToDie();
	end
	local function v126(v164)
		return not v164:DebuffUp(v75.SerratedBoneSpikeDebuff);
	end
	local function v127()
		local v165 = 1859 - (821 + 1038);
		while true do
			if (((9638 - 5775) == (423 + 3440)) and (v165 == (3 - 1))) then
				return false;
			end
			if ((v165 == (1 + 0)) or ((698 - 416) <= (1068 - (834 + 192)))) then
				if (((294 + 4315) >= (197 + 569)) and v75.Fireblood:IsCastable()) then
					if (v9.Press(v75.Fireblood, v53) or ((25 + 1127) == (3854 - 1366))) then
						return "Cast Fireblood";
					end
				end
				if (((3726 - (300 + 4)) > (895 + 2455)) and v75.AncestralCall:IsCastable()) then
					if (((2295 - 1418) > (738 - (112 + 250))) and ((not v75.Kingsbane:IsAvailable() and v14:DebuffUp(v75.ShivDebuff)) or (v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (4 + 4))))) then
						if (v9.Press(v75.AncestralCall, v53) or ((7810 - 4692) <= (1061 + 790))) then
							return "Cast Ancestral Call";
						end
					end
				end
				v165 = 2 + 0;
			end
			if ((v165 == (0 + 0)) or ((82 + 83) >= (2595 + 897))) then
				if (((5363 - (1001 + 413)) < (10828 - 5972)) and v75.BloodFury:IsCastable()) then
					if (v9.Press(v75.BloodFury, v53) or ((5158 - (244 + 638)) < (3709 - (627 + 66)))) then
						return "Cast Blood Fury";
					end
				end
				if (((13974 - 9284) > (4727 - (512 + 90))) and v75.Berserking:IsCastable()) then
					if (v9.Press(v75.Berserking, v53) or ((1956 - (1665 + 241)) >= (1613 - (373 + 344)))) then
						return "Cast Berserking";
					end
				end
				v165 = 1 + 0;
			end
		end
	end
	local function v128()
		if ((v75.ShadowDance:IsCastable() and not v75.Kingsbane:IsAvailable()) or ((454 + 1260) >= (7802 - 4844))) then
			if ((v75.ImprovedGarrote:IsAvailable() and v75.Garrote:CooldownUp() and ((v14:PMultiplier(v75.Garrote) <= (1 - 0)) or v121(v14, v75.Garrote)) and (v75.Deathmark:AnyDebuffUp() or (v75.Deathmark:CooldownRemains() < (1111 - (35 + 1064))) or (v75.Deathmark:CooldownRemains() > (44 + 16))) and (v91 >= math.min(v85, 8 - 4))) or ((6 + 1485) < (1880 - (298 + 938)))) then
				local v215 = 1259 - (233 + 1026);
				while true do
					if (((2370 - (636 + 1030)) < (505 + 482)) and (v215 == (0 + 0))) then
						if (((1105 + 2613) > (129 + 1777)) and v49 and (v13:EnergyPredicted() < (266 - (55 + 166)))) then
							if (v19(v75.PoolEnergy) or ((186 + 772) > (366 + 3269))) then
								return "Pool for Shadow Dance (Garrote)";
							end
						end
						if (((13370 - 9869) <= (4789 - (36 + 261))) and v19(v75.ShadowDance, v55)) then
							return "Cast Shadow Dance (Garrote)";
						end
						break;
					end
				end
			end
			if ((not v75.ImprovedGarrote:IsAvailable() and v75.MasterAssassin:IsAvailable() and not v121(v14, v75.Rupture) and (v14:DebuffRemains(v75.Garrote) > (4 - 1)) and (v14:DebuffUp(v75.Deathmark) or (v75.Deathmark:CooldownRemains() > (1428 - (34 + 1334)))) and (v14:DebuffUp(v75.ShivDebuff) or (v14:DebuffRemains(v75.Deathmark) < (2 + 2)) or v14:DebuffUp(v75.Sepsis)) and (v14:DebuffRemains(v75.Sepsis) < (3 + 0))) or ((4725 - (1035 + 248)) < (2569 - (20 + 1)))) then
				if (((1498 + 1377) >= (1783 - (134 + 185))) and v19(v75.ShadowDance, v55)) then
					return "Cast Shadow Dance (Master Assassin)";
				end
			end
		end
		if ((v75.Vanish:IsCastable() and not v13:IsTanking(v14)) or ((5930 - (549 + 584)) >= (5578 - (314 + 371)))) then
			local v174 = 0 - 0;
			while true do
				if ((v174 == (969 - (478 + 490))) or ((292 + 259) > (3240 - (786 + 386)))) then
					if (((6847 - 4733) > (2323 - (1055 + 324))) and not v75.ImprovedGarrote:IsAvailable() and v75.MasterAssassin:IsAvailable() and not v121(v14, v75.Rupture) and (v14:DebuffRemains(v75.Garrote) > (1343 - (1093 + 247))) and v14:DebuffUp(v75.Deathmark) and (v14:DebuffUp(v75.ShivDebuff) or (v14:DebuffRemains(v75.Deathmark) < (4 + 0)) or v14:DebuffUp(v75.Sepsis)) and (v14:DebuffRemains(v75.Sepsis) < (1 + 2))) then
						if (v19(v75.Vanish, v54) or ((8980 - 6718) >= (10506 - 7410))) then
							return "Cast Vanish (Master Assassin)";
						end
					end
					break;
				end
				if (((0 - 0) == v174) or ((5666 - 3411) >= (1259 + 2278))) then
					if ((v75.ImprovedGarrote:IsAvailable() and not v75.MasterAssassin:IsAvailable() and v75.Garrote:CooldownUp() and ((v14:PMultiplier(v75.Garrote) <= (3 - 2)) or v121(v14, v75.Garrote))) or ((13225 - 9388) < (985 + 321))) then
						if (((7544 - 4594) == (3638 - (364 + 324))) and not v75.IndiscriminateCarnage:IsAvailable() and (v75.Deathmark:AnyDebuffUp() or (v75.Deathmark:CooldownRemains() < (10 - 6))) and (v91 >= v22(v85, 9 - 5))) then
							local v239 = 0 + 0;
							while true do
								if ((v239 == (0 - 0)) or ((7563 - 2840) < (10016 - 6718))) then
									if (((2404 - (1249 + 19)) >= (140 + 14)) and v49 and (v13:EnergyPredicted() < (175 - 130))) then
										if (v19(v75.PoolEnergy) or ((1357 - (686 + 400)) > (3726 + 1022))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((4969 - (73 + 156)) >= (15 + 3137)) and v19(v75.Vanish, v54)) then
										return "Cast Vanish (Garrote Deathmark)";
									end
									break;
								end
							end
						end
						if ((v75.IndiscriminateCarnage:IsAvailable() and (v85 > (813 - (721 + 90)))) or ((29 + 2549) >= (11006 - 7616))) then
							local v240 = 470 - (224 + 246);
							while true do
								if (((66 - 25) <= (3058 - 1397)) and (v240 == (0 + 0))) then
									if (((15 + 586) < (2615 + 945)) and v49 and (v13:EnergyPredicted() < (89 - 44))) then
										if (((782 - 547) < (1200 - (203 + 310))) and v19(v75.PoolEnergy)) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((6542 - (1238 + 755)) > (81 + 1072)) and v19(v75.Vanish, v54)) then
										return "Cast Vanish (Garrote Cleave)";
									end
									break;
								end
							end
						end
					end
					if ((v75.MasterAssassin:IsAvailable() and v75.Kingsbane:IsAvailable() and v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) <= (1537 - (709 + 825))) and v14:DebuffUp(v75.Deathmark) and (v14:DebuffRemains(v75.Deathmark) <= (4 - 1))) or ((6808 - 2134) < (5536 - (196 + 668)))) then
						if (((14482 - 10814) < (9447 - 4886)) and v19(v75.Vanish, v54)) then
							return "Cast Vanish (Kingsbane)";
						end
					end
					v174 = 834 - (171 + 662);
				end
			end
		end
	end
	local function v129()
		local v166 = 93 - (4 + 89);
		while true do
			if ((v166 == (0 - 0)) or ((166 + 289) == (15833 - 12228))) then
				v87 = v73.HandleTopTrinket(v78, v27, 16 + 24, nil);
				if (v87 or ((4149 - (35 + 1451)) == (4765 - (28 + 1425)))) then
					return v87;
				end
				v166 = 1994 - (941 + 1052);
			end
			if (((4102 + 175) <= (5989 - (822 + 692))) and (v166 == (1 - 0))) then
				v87 = v73.HandleBottomTrinket(v78, v27, 19 + 21, nil);
				if (v87 or ((1167 - (45 + 252)) == (1177 + 12))) then
					return v87;
				end
				break;
			end
		end
	end
	local function v130()
		if (((535 + 1018) <= (7624 - 4491)) and v75.Sepsis:IsReady() and (v14:DebuffRemains(v75.Rupture) > (453 - (114 + 319))) and ((not v75.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v75.Garrote)) or (v75.ImprovedGarrote:IsAvailable() and v75.Garrote:CooldownUp() and (v14:PMultiplier(v75.Garrote) <= (1 - 0)))) and (v14:FilteredTimeToDie(">", 12 - 2) or v9.BossFilteredFightRemains("<=", 7 + 3))) then
			if (v19(v75.Sepsis, nil, true) or ((3332 - 1095) >= (7356 - 3845))) then
				return "Cast Sepsis";
			end
		end
		v87 = v129();
		if (v87 or ((3287 - (556 + 1407)) > (4226 - (741 + 465)))) then
			return v87;
		end
		local v167 = not v13:StealthUp(true, false) and v14:DebuffUp(v75.Rupture) and v13:BuffUp(v75.Envenom) and not v75.Deathmark:AnyDebuffUp() and (not v75.MasterAssassin:IsAvailable() or v14:DebuffUp(v75.Garrote)) and (not v75.Kingsbane:IsAvailable() or (v75.Kingsbane:CooldownRemains() <= (467 - (170 + 295))));
		if ((v75.Deathmark:IsCastable() and (v167 or v9.BossFilteredFightRemains("<=", 11 + 9))) or ((2749 + 243) == (4631 - 2750))) then
			if (((2575 + 531) > (979 + 547)) and v19(v75.Deathmark)) then
				return "Cast Deathmark";
			end
		end
		if (((1712 + 1311) < (5100 - (957 + 273))) and v75.Shiv:IsReady() and not v14:DebuffUp(v75.ShivDebuff) and v14:DebuffUp(v75.Garrote) and v14:DebuffUp(v75.Rupture)) then
			local v175 = 0 + 0;
			while true do
				if (((58 + 85) > (281 - 207)) and (v175 == (2 - 1))) then
					if (((54 - 36) < (10457 - 8345)) and v75.ArterialPrecision:IsAvailable() and v75.Deathmark:AnyDebuffUp()) then
						if (((2877 - (389 + 1391)) <= (1022 + 606)) and v19(v75.Shi)) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if (((482 + 4148) == (10540 - 5910)) and not v75.Kingsbane:IsAvailable() and not v75.ArterialPrecision:IsAvailable()) then
						if (((4491 - (783 + 168)) > (9004 - 6321)) and v75.Sepsis:IsAvailable()) then
							if (((4716 + 78) >= (3586 - (309 + 2))) and (((v75.Shiv:ChargesFractional() > ((0.9 - 0) + v20(v75.LightweightShiv:IsAvailable()))) and (v101 > (1217 - (1090 + 122)))) or v14:DebuffUp(v75.Sepsis) or v14:DebuffUp(v75.Deathmark))) then
								if (((482 + 1002) == (4983 - 3499)) and v19(v75.Shiv)) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (((981 + 451) < (4673 - (628 + 490))) and (not v75.CrimsonTempest:IsAvailable() or v106 or v14:DebuffUp(v75.CrimsonTempest))) then
							if (v19(v75.Shiv) or ((191 + 874) > (8858 - 5280))) then
								return "Cast Shiv";
							end
						end
					end
					break;
				end
				if ((v175 == (0 - 0)) or ((5569 - (431 + 343)) < (2841 - 1434))) then
					if (((5360 - 3507) < (3803 + 1010)) and v9.BossFilteredFightRemains("<=", v75.Shiv:Charges() * (2 + 6))) then
						if (v19(v75.Shiv) or ((4516 - (556 + 1139)) < (2446 - (6 + 9)))) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if ((v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom)) or ((527 + 2347) < (1118 + 1063))) then
						local v232 = 169 - (28 + 141);
						while true do
							if ((v232 == (0 + 0)) or ((3318 - 629) <= (243 + 100))) then
								if ((not v75.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (1325 - (486 + 831)))) or (v75.Kingsbane:CooldownRemains() >= (62 - 38))) and (not v75.CrimsonTempest:IsAvailable() or v106 or v14:DebuffUp(v75.CrimsonTempest))) or ((6579 - 4710) == (380 + 1629))) then
									if (v19(v75.Shiv) or ((11212 - 7666) < (3585 - (668 + 595)))) then
										return "Cast Shiv (Kingsbane)";
									end
								end
								if ((v75.LightweightShiv:IsAvailable() and (v14:DebuffUp(v75.Kingsbane) or (v75.Kingsbane:CooldownRemains() <= (1 + 0)))) or ((420 + 1662) == (13016 - 8243))) then
									if (((3534 - (23 + 267)) > (2999 - (1129 + 815))) and v19(v75.Shiv)) then
										return "Cast Shiv (Kingsbane Lightweight)";
									end
								end
								break;
							end
						end
					end
					v175 = 388 - (371 + 16);
				end
			end
		end
		if ((v75.ShadowDance:IsCastable() and v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom) and ((v75.Deathmark:CooldownRemains() >= (1800 - (1326 + 424))) or v167)) or ((6274 - 2961) <= (6497 - 4719))) then
			if (v19(v75.ShadowDance) or ((1539 - (88 + 30)) >= (2875 - (720 + 51)))) then
				return "Cast Shadow Dance (Kingsbane Sync)";
			end
		end
		if (((4030 - 2218) <= (5025 - (421 + 1355))) and v75.Kingsbane:IsReady() and (v14:DebuffUp(v75.ShivDebuff) or (v75.Shiv:CooldownRemains() < (9 - 3))) and v13:BuffUp(v75.Envenom) and ((v75.Deathmark:CooldownRemains() >= (25 + 25)) or v14:DebuffUp(v75.Deathmark))) then
			if (((2706 - (286 + 797)) <= (7154 - 5197)) and v19(v75.Kingsbane)) then
				return "Cast Kingsbane";
			end
		end
		if (((7307 - 2895) == (4851 - (397 + 42))) and v75.ThistleTea:IsCastable() and not v13:BuffUp(v75.ThistleTea) and (((v13:EnergyDeficit() >= (32 + 68 + v103)) and (not v75.Kingsbane:IsAvailable() or (v75.ThistleTea:Charges() >= (802 - (24 + 776))))) or (v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (8 - 2))) or (not v75.Kingsbane:IsAvailable() and v75.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v75.ThistleTea:Charges() * (791 - (222 + 563))))) then
			if (((3855 - 2105) >= (607 + 235)) and v9.Cast(v75.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((4562 - (23 + 167)) > (3648 - (690 + 1108))) and v75.Deathmark:AnyDebuffUp() and (not v87 or v53)) then
			if (((84 + 148) < (678 + 143)) and v87) then
				v127();
			else
				v87 = v127();
			end
		end
		if (((1366 - (40 + 808)) < (149 + 753)) and not v13:StealthUp(true, true) and (v116() <= (0 - 0)) and (v115() <= (0 + 0))) then
			if (((1584 + 1410) > (471 + 387)) and v87) then
				v128();
			else
				v87 = v128();
			end
		end
		if ((v75.ColdBlood:IsReady() and v13:DebuffDown(v75.ColdBlood) and (v90 >= (575 - (47 + 524)))) or ((2437 + 1318) <= (2501 - 1586))) then
			if (((5900 - 1954) > (8536 - 4793)) and v9.Press(v75.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		return v87;
	end
	local function v131()
		if ((v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom)) or ((3061 - (1165 + 561)) >= (99 + 3207))) then
			if (((15002 - 10158) > (860 + 1393)) and v75.Shiv:IsReady() and (v14:DebuffUp(v75.Kingsbane) or v75.Kingsbane:CooldownUp()) and v14:DebuffDown(v75.ShivDebuff)) then
				if (((931 - (341 + 138)) == (123 + 329)) and v19(v75.Shiv)) then
					return "Cast Shiv (Stealth Kingsbane)";
				end
			end
			if ((v75.Kingsbane:IsReady() and (v13:BuffRemains(v75.ShadowDanceBuff) >= (3 - 1))) or ((4883 - (89 + 237)) < (6713 - 4626))) then
				if (((8155 - 4281) == (4755 - (581 + 300))) and v19(v75.Kingsbane, v67)) then
					return "Cast Kingsbane (Dance)";
				end
			end
		end
		if ((v90 >= (1224 - (855 + 365))) or ((4603 - 2665) > (1612 + 3323))) then
			local v176 = 1235 - (1030 + 205);
			while true do
				if ((v176 == (0 + 0)) or ((3959 + 296) < (3709 - (156 + 130)))) then
					if (((3303 - 1849) <= (4197 - 1706)) and v14:DebuffUp(v75.Kingsbane) and (v13:BuffRemains(v75.Envenom) <= (3 - 1))) then
						if (v19(v75.Envenom, nil, nil, not v81) or ((1096 + 3061) <= (1635 + 1168))) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if (((4922 - (10 + 59)) >= (844 + 2138)) and v106 and v114() and v13:BuffDown(v75.ShadowDanceBuff)) then
						if (((20359 - 16225) > (4520 - (671 + 492))) and v19(v75.Envenom, nil, nil, not v81)) then
							return "Cast Envenom (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if ((v26 and v75.CrimsonTempest:IsReady() and v75.Nightstalker:IsAvailable() and (v85 >= (3 + 0)) and (v90 >= (1219 - (369 + 846))) and not v75.Deathmark:IsReady()) or ((905 + 2512) < (2163 + 371))) then
			for v211, v212 in v29(v84) do
				if ((v121(v212, v75.CrimsonTempest, v93) and v212:FilteredTimeToDie(">", 1951 - (1036 + 909), -v212:DebuffRemains(v75.CrimsonTempest))) or ((2165 + 557) <= (274 - 110))) then
					if (v19(v75.CrimsonTempest) or ((2611 - (11 + 192)) < (1066 + 1043))) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
			end
		end
		if ((v75.Garrote:IsCastable() and (v116() > (175 - (135 + 40)))) or ((79 - 46) == (878 + 577))) then
			local v177 = 0 - 0;
			local v178;
			local v179;
			while true do
				if ((v177 == (2 - 0)) or ((619 - (50 + 126)) >= (11179 - 7164))) then
					if (((749 + 2633) > (1579 - (1233 + 180))) and v26) then
						local v233 = 969 - (522 + 447);
						local v234;
						while true do
							if (((1421 - (107 + 1314)) == v233) or ((130 + 150) == (9320 - 6261))) then
								v234 = v123("min", v178, v179);
								if (((799 + 1082) > (2567 - 1274)) and v234 and (v234:GUID() ~= v14:GUID())) then
									v19(v234, v75.Garrote);
								end
								break;
							end
						end
					end
					if (((9325 - 6968) == (4267 - (716 + 1194))) and v179(v14)) then
						if (((3 + 120) == (14 + 109)) and v19(v75.Garrote, nil, nil, not v81)) then
							return "Cast Garrote (Improved Garrote)";
						end
					end
					v177 = 506 - (74 + 429);
				end
				if ((v177 == (5 - 2)) or ((524 + 532) >= (7764 - 4372))) then
					if ((v91 >= (1 + 0 + ((5 - 3) * v20(v75.ShroudedSuffocation:IsAvailable())))) or ((2672 - 1591) < (1508 - (279 + 154)))) then
						local v235 = 778 - (454 + 324);
						while true do
							if ((v235 == (0 + 0)) or ((1066 - (12 + 5)) >= (2390 + 2042))) then
								if ((v13:BuffDown(v75.ShadowDanceBuff) and ((v14:PMultiplier(v75.Garrote) <= (2 - 1)) or (v14:DebuffUp(v75.Deathmark) and (v115() < (2 + 1))))) or ((5861 - (277 + 816)) <= (3614 - 2768))) then
									if (v19(v75.Garrote, nil, nil, not v81) or ((4541 - (1058 + 125)) <= (267 + 1153))) then
										return "Cast Garrote (Improved Garrote Low CP)";
									end
								end
								if ((v14:PMultiplier(v75.Garrote) <= (976 - (815 + 160))) or (v14:DebuffRemains(v75.Garrote) < (51 - 39)) or ((8875 - 5136) <= (717 + 2288))) then
									if (v19(v75.Garrote, nil, nil, not v81) or ((4849 - 3190) >= (4032 - (41 + 1857)))) then
										return "Cast Garrote (Improved Garrote Low CP 2)";
									end
								end
								break;
							end
						end
					end
					break;
				end
				if ((v177 == (1894 - (1222 + 671))) or ((8425 - 5165) < (3384 - 1029))) then
					v179 = nil;
					function v179(v225)
						return ((v225:PMultiplier(v75.Garrote) <= (1183 - (229 + 953))) or (v225:DebuffRemains(v75.Garrote) < ((1786 - (1111 + 663)) / v74.ExsanguinatedRate(v225, v75.Garrote))) or ((v117() > (1579 - (874 + 705))) and (v75.Garrote:AuraActiveCount() < v85))) and not v106 and (v225:FilteredTimeToDie(">", 1 + 1, -v225:DebuffRemains(v75.Garrote)) or v225:TimeToDieIsNotValid()) and v74.CanDoTUnit(v225, v95);
					end
					v177 = 2 + 0;
				end
				if (((0 - 0) == v177) or ((19 + 650) == (4902 - (642 + 37)))) then
					v178 = nil;
					function v178(v226)
						return v226:DebuffRemains(v75.Garrote);
					end
					v177 = 1 + 0;
				end
			end
		end
		if (((v90 >= (1 + 3)) and (v14:PMultiplier(v75.Rupture) <= (2 - 1)) and (v13:BuffUp(v75.ShadowDanceBuff) or v14:DebuffUp(v75.Deathmark))) or ((2146 - (233 + 221)) < (1359 - 771))) then
			if (v19(v75.Rupture, nil, nil, not v81) or ((4223 + 574) < (5192 - (718 + 823)))) then
				return "Cast Rupture (Nightstalker)";
			end
		end
	end
	local function v132()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (805 - (266 + 539))) or ((11826 - 7649) > (6075 - (636 + 589)))) then
				if ((v26 and v75.CrimsonTempest:IsReady() and (v85 >= (4 - 2)) and (v90 >= (8 - 4)) and (v103 > (20 + 5)) and not v75.Deathmark:IsReady()) or ((146 + 254) > (2126 - (657 + 358)))) then
					for v227, v228 in v29(v84) do
						if (((8078 - 5027) > (2289 - 1284)) and v121(v228, v75.CrimsonTempest, v93) and (v228:PMultiplier(v75.CrimsonTempest) <= (1188 - (1151 + 36))) and v228:FilteredTimeToDie(">", 6 + 0, -v228:DebuffRemains(v75.CrimsonTempest))) then
							if (((971 + 2722) <= (13086 - 8704)) and v19(v75.CrimsonTempest)) then
								return "Cast Crimson Tempest (AoE High Energy)";
							end
						end
					end
				end
				if ((v75.Garrote:IsCastable() and (v91 >= (1833 - (1552 + 280)))) or ((4116 - (64 + 770)) > (2784 + 1316))) then
					local v220 = 0 - 0;
					local v221;
					while true do
						if ((v220 == (0 + 0)) or ((4823 - (157 + 1086)) < (5692 - 2848))) then
							v221 = nil;
							function v221(v241)
								return v121(v241, v75.Garrote) and (v241:PMultiplier(v75.Garrote) <= (4 - 3));
							end
							v220 = 1 - 0;
						end
						if (((120 - 31) < (5309 - (599 + 220))) and (v220 == (1 - 0))) then
							if ((v221(v14) and v74.CanDoTUnit(v14, v95) and (v14:FilteredTimeToDie(">", 1943 - (1813 + 118), -v14:DebuffRemains(v75.Garrote)) or v14:TimeToDieIsNotValid())) or ((3643 + 1340) < (3025 - (841 + 376)))) then
								if (((5364 - 1535) > (876 + 2893)) and v28(v75.Garrote, nil, not v81)) then
									return "Pool for Garrote (ST)";
								end
							end
							if (((4053 - 2568) <= (3763 - (464 + 395))) and v26 and not v105 and (v85 >= (5 - 3))) then
								v122(v75.Garrote, v221, 6 + 6, v86);
							end
							break;
						end
					end
				end
				v168 = 838 - (467 + 370);
			end
			if (((8821 - 4552) == (3134 + 1135)) and (v168 == (3 - 2))) then
				if (((61 + 326) <= (6472 - 3690)) and v75.Rupture:IsReady() and (v90 >= (524 - (150 + 370)))) then
					v96 = (1286 - (74 + 1208)) + (v20(v75.DashingScoundrel:IsAvailable()) * (12 - 7)) + (v20(v75.Doomblade:IsAvailable()) * (23 - 18)) + (v20(v105) * (5 + 1));
					local function v222(v229)
						return v121(v229, v75.Rupture, v92) and (v229:PMultiplier(v75.Rupture) <= (391 - (14 + 376))) and (v229:FilteredTimeToDie(">", v96, -v229:DebuffRemains(v75.Rupture)) or v229:TimeToDieIsNotValid());
					end
					if ((v222(v14) and v74.CanDoTUnit(v14, v94)) or ((3293 - 1394) <= (594 + 323))) then
						if (v19(v75.Rupture, nil, nil, not v81) or ((3788 + 524) <= (836 + 40))) then
							return "Cast Rupture";
						end
					end
					if (((6539 - 4307) <= (1953 + 643)) and v26 and (not v105 or not v107)) then
						v122(v75.Rupture, v222, v96, v86);
					end
				end
				if (((2173 - (23 + 55)) < (8735 - 5049)) and v75.Garrote:IsCastable() and (v91 >= (1 + 0)) and (v115() <= (0 + 0)) and ((v14:PMultiplier(v75.Garrote) <= (1 - 0)) or ((v14:DebuffRemains(v75.Garrote) < v88) and (v85 >= (1 + 2)))) and (v14:DebuffRemains(v75.Garrote) < (v88 * (903 - (652 + 249)))) and (v85 >= (7 - 4)) and (v14:FilteredTimeToDie(">", 1872 - (708 + 1160), -v14:DebuffRemains(v75.Garrote)) or v14:TimeToDieIsNotValid())) then
					if (v19(v75.Garrote, nil, nil, not v81) or ((4329 - 2734) >= (8156 - 3682))) then
						return "Garrote (Fallback)";
					end
				end
				v168 = 29 - (10 + 17);
			end
			if ((v168 == (1 + 1)) or ((6351 - (1400 + 332)) < (5527 - 2645))) then
				return false;
			end
		end
	end
	local function v133()
		if ((v75.Envenom:IsReady() and (v90 >= (1912 - (242 + 1666))) and (v100 or (v14:DebuffStack(v75.AmplifyingPoisonDebuff) >= (9 + 11)) or (v90 > v74.CPMaxSpend()) or not v106)) or ((108 + 186) >= (4118 + 713))) then
			if (((2969 - (850 + 90)) <= (5401 - 2317)) and v19(v75.Envenom, nil, nil, not v81)) then
				return "Cast Envenom";
			end
		end
		if (not ((v91 > (1391 - (360 + 1030))) or v100 or not v106) or ((1803 + 234) == (6830 - 4410))) then
			return false;
		end
		if (((6133 - 1675) > (5565 - (909 + 752))) and not v106 and v75.CausticSpatter:IsAvailable() and v14:DebuffUp(v75.Rupture) and (v14:DebuffRemains(v75.CausticSpatterDebuff) <= (1225 - (109 + 1114)))) then
			local v180 = 0 - 0;
			while true do
				if (((170 + 266) >= (365 - (6 + 236))) and (v180 == (0 + 0))) then
					if (((403 + 97) < (4282 - 2466)) and v75.Mutilate:IsCastable()) then
						if (((6242 - 2668) == (4707 - (1076 + 57))) and v19(v75.Mutilate, nil, nil, not v81)) then
							return "Cast Mutilate (Casutic)";
						end
					end
					if (((37 + 184) < (1079 - (579 + 110))) and (v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v75.BlindsideBuff))) then
						if (v19(v75.Ambush, nil, nil, not v81) or ((175 + 2038) <= (1257 + 164))) then
							return "Cast Ambush (Caustic)";
						end
					end
					break;
				end
			end
		end
		if (((1623 + 1435) < (5267 - (174 + 233))) and v75.SerratedBoneSpike:IsReady()) then
			if (not v14:DebuffUp(v75.SerratedBoneSpikeDebuff) or ((3620 - 2324) >= (7803 - 3357))) then
				if (v19(v75.SerratedBoneSpike, nil, not v82) or ((620 + 773) > (5663 - (663 + 511)))) then
					return "Cast Serrated Bone Spike";
				end
			else
				if (v26 or ((3947 + 477) < (6 + 21))) then
					if (v73.CastTargetIf(v75.SerratedBoneSpike, v83, "min", v125, v126) or ((6156 - 4159) > (2311 + 1504))) then
						return "Cast Serrated Bone (AoE)";
					end
				end
				if (((8157 - 4692) > (4630 - 2717)) and (v115() < (0.8 + 0))) then
					if (((1426 - 693) < (1297 + 522)) and ((v9.BossFightRemains() <= (1 + 4)) or ((v75.SerratedBoneSpike:MaxCharges() - v75.SerratedBoneSpike:ChargesFractional()) <= (722.25 - (478 + 244))))) then
						if (v19(v75.SerratedBoneSpike, nil, true, not v82) or ((4912 - (440 + 77)) == (2162 + 2593))) then
							return "Cast Serrated Bone Spike (Dump Charge)";
						end
					elseif ((not v106 and v14:DebuffUp(v75.ShivDebuff)) or ((13882 - 10089) < (3925 - (655 + 901)))) then
						if (v19(v75.SerratedBoneSpike, nil, true, not v82) or ((758 + 3326) == (203 + 62))) then
							return "Cast Serrated Bone Spike (Shiv)";
						end
					end
				end
			end
		end
		if (((2943 + 1415) == (17556 - 13198)) and v27 and v75.EchoingReprimand:IsReady()) then
			if (v19(v75.EchoingReprimand, nil, not v81) or ((4583 - (695 + 750)) < (3390 - 2397))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((5139 - 1809) > (9342 - 7019)) and v75.FanofKnives:IsCastable()) then
			if ((v26 and (v85 >= (352 - (285 + 66))) and not v99 and (v85 >= ((4 - 2) + v20(v13:StealthUp(true, false)) + v20(v75.DragonTemperedBlades:IsAvailable())))) or ((4936 - (682 + 628)) == (643 + 3346))) then
				if (v28(v75.FanofKnives) or ((1215 - (176 + 123)) == (1118 + 1553))) then
					return "Cast Fan of Knives";
				end
			end
			if (((198 + 74) == (541 - (239 + 30))) and v26 and v13:BuffUp(v75.DeadlyPoison) and (v85 >= (1 + 2))) then
				for v223, v224 in v29(v84) do
					if (((4084 + 165) <= (8564 - 3725)) and not v224:DebuffUp(v75.DeadlyPoisonDebuff, true) and (not v99 or v224:DebuffUp(v75.Garrote) or v224:DebuffUp(v75.Rupture))) then
						if (((8663 - 5886) < (3515 - (306 + 9))) and v28(v75.FanofKnives)) then
							return "Cast Fan of Knives (DP Refresh)";
						end
					end
				end
			end
		end
		if (((331 - 236) < (341 + 1616)) and (v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v75.BlindsideBuff) or v13:BuffUp(v75.SepsisBuff)) and (v14:DebuffDown(v75.Kingsbane) or v14:DebuffDown(v75.Deathmark) or v13:BuffUp(v75.BlindsideBuff))) then
			if (((507 + 319) < (827 + 890)) and v28(v75.Ambush, nil, not v81)) then
				return "Cast Ambush";
			end
		end
		if (((4077 - 2651) >= (2480 - (1140 + 235))) and v75.Mutilate:IsCastable() and (v85 == (2 + 0)) and v14:DebuffDown(v75.DeadlyPoisonDebuff, true) and v14:DebuffDown(v75.AmplifyingPoisonDebuff, true)) then
			local v181 = 0 + 0;
			local v182;
			while true do
				if (((707 + 2047) <= (3431 - (33 + 19))) and (v181 == (0 + 0))) then
					v182 = v14:GUID();
					for v230, v231 in v29(v86) do
						if (((v231:GUID() ~= v182) and (v231:DebuffUp(v75.Garrote) or v231:DebuffUp(v75.Rupture)) and not v231:DebuffUp(v75.DeadlyPoisonDebuff, true) and not v231:DebuffUp(v75.AmplifyingPoisonDebuff, true)) or ((11770 - 7843) == (623 + 790))) then
							v19(v231, v75.Mutilate);
							break;
						end
					end
					break;
				end
			end
		end
		if (v75.Mutilate:IsCastable() or ((2262 - 1108) <= (739 + 49))) then
			if (v28(v75.Mutilate, nil, not v81) or ((2332 - (586 + 103)) > (308 + 3071))) then
				return "Cast Mutilate";
			end
		end
		return false;
	end
	local function v134()
		v72();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v79 = (v75.AcrobaticStrikes:IsAvailable() and (24 - 16)) or (1493 - (1309 + 179));
		v80 = (v75.AcrobaticStrikes:IsAvailable() and (23 - 10)) or (5 + 5);
		v81 = v14:IsInMeleeRange(v79);
		v82 = v14:IsInMeleeRange(v80);
		if (v26 or ((7527 - 4724) > (3437 + 1112))) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (1 - 0)) or ((829 - (295 + 314)) >= (7422 - 4400))) then
					v85 = #v84;
					v86 = v13:GetEnemiesInMeleeRange(v79);
					break;
				end
				if (((4784 - (1300 + 662)) == (8861 - 6039)) and (v183 == (1755 - (1178 + 577)))) then
					v83 = v13:GetEnemiesInRange(16 + 14);
					v84 = v13:GetEnemiesInMeleeRange(v80);
					v183 = 2 - 1;
				end
			end
		else
			local v184 = 1405 - (851 + 554);
			while true do
				if ((v184 == (0 + 0)) or ((2942 - 1881) == (4032 - 2175))) then
					v83 = {};
					v84 = {};
					v184 = 303 - (115 + 187);
				end
				if (((2114 + 646) > (1292 + 72)) and (v184 == (3 - 2))) then
					v85 = 1162 - (160 + 1001);
					v86 = {};
					break;
				end
			end
		end
		v88, v89 = (2 + 0) * v13:SpellHaste(), (1 + 0) * v13:SpellHaste();
		v90 = v74.EffectiveComboPoints(v13:ComboPoints());
		v91 = v13:ComboPointsMax() - v90;
		v92 = ((7 - 3) + (v90 * (362 - (237 + 121)))) * (897.3 - (525 + 372));
		v93 = ((7 - 3) + (v90 * (6 - 4))) * (142.3 - (96 + 46));
		v94 = v75.Envenom:Damage() * v62;
		v95 = v75.Mutilate:Damage() * v63;
		v99 = v45();
		v87 = v74.CrimsonVial();
		if (v87 or ((5679 - (643 + 134)) <= (1298 + 2297))) then
			return v87;
		end
		v87 = v74.Feint();
		if (v87 or ((9236 - 5384) == (1087 - 794))) then
			return v87;
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v73.TargetIsValid()) or ((1496 + 63) == (9003 - 4415))) then
			v87 = v74.Stealth(v75.Stealth2, nil);
			if (v87 or ((9165 - 4681) == (1507 - (316 + 403)))) then
				return "Stealth (OOC): " .. v87;
			end
		end
		v74.Poisons();
		if (((3037 + 1531) >= (10741 - 6834)) and not v13:AffectingCombat()) then
			local v185 = 0 + 0;
			while true do
				if (((3137 - 1891) < (2459 + 1011)) and (v185 == (0 + 0))) then
					if (((14095 - 10027) >= (4642 - 3670)) and not v13:BuffUp(v74.VanishBuffSpell())) then
						v87 = v74.Stealth(v74.StealthSpell());
						if (((1023 - 530) < (223 + 3670)) and v87) then
							return v87;
						end
					end
					if (v73.TargetIsValid() or ((2899 - 1426) >= (163 + 3169))) then
						local v236 = 0 - 0;
						while true do
							if ((v236 == (17 - (12 + 5))) or ((15734 - 11683) <= (2468 - 1311))) then
								if (((1283 - 679) < (7144 - 4263)) and v27) then
									if ((v25 and v75.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v74.CPMaxSpend()) and v73.TargetIsValid()) or ((183 + 717) == (5350 - (1656 + 317)))) then
										if (((3974 + 485) > (474 + 117)) and v9.Press(v75.MarkedforDeath, v58)) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (((9035 - 5637) >= (11787 - 9392)) and not v13:BuffUp(v75.SliceandDice)) then
									if ((v75.SliceandDice:IsReady() and (v90 >= (356 - (5 + 349)))) or ((10368 - 8185) >= (4095 - (266 + 1005)))) then
										if (((1276 + 660) == (6605 - 4669)) and v9.Press(v75.SliceandDice)) then
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
		v74.MfDSniping(v75.MarkedforDeath);
		if (v73.TargetIsValid() or ((6361 - 1529) < (6009 - (561 + 1135)))) then
			v102 = v74.PoisonedBleeds();
			v103 = v13:EnergyRegen() + ((v102 * (7 - 1)) / ((6 - 4) * v13:SpellHaste()));
			v104 = v13:EnergyDeficit() / v103;
			v105 = v103 > (1101 - (507 + 559));
			v100 = v118();
			v101 = v119();
			v107 = v120();
			v106 = v85 < (4 - 2);
			if (((12642 - 8554) > (4262 - (212 + 176))) and (v13:StealthUp(true, false) or (v116() > (905 - (250 + 655))) or (v115() > (0 - 0)))) then
				v87 = v131();
				if (((7568 - 3236) == (6777 - 2445)) and v87) then
					return v87 .. " (Stealthed)";
				end
			end
			v87 = v130();
			if (((5955 - (1869 + 87)) >= (10058 - 7158)) and v87) then
				return v87;
			end
			if (not v13:BuffUp(v75.SliceandDice) or ((4426 - (484 + 1417)) > (8710 - 4646))) then
				if (((7325 - 2954) == (5144 - (48 + 725))) and ((v75.SliceandDice:IsReady() and (v13:ComboPoints() >= (2 - 0)) and v14:DebuffUp(v75.Rupture)) or (not v75.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (10 - 6)) and (v13:BuffRemains(v75.SliceandDice) < ((1 + 0 + v13:ComboPoints()) * (2.8 - 1)))))) then
					if (v19(v75.SliceandDice) or ((75 + 191) > (1454 + 3532))) then
						return "Cast Slice and Dice";
					end
				end
			elseif (((2844 - (152 + 701)) >= (2236 - (430 + 881))) and v82 and v75.CutToTheChase:IsAvailable()) then
				if (((175 + 280) < (2948 - (557 + 338))) and v75.Envenom:IsReady() and (v13:BuffRemains(v75.SliceandDice) < (2 + 3)) and (v13:ComboPoints() >= (10 - 6))) then
					if (v19(v75.Envenom, nil, nil, not v81) or ((2892 - 2066) == (12887 - 8036))) then
						return "Cast Envenom (CttC)";
					end
				end
			elseif (((393 - 210) == (984 - (499 + 302))) and v75.PoisonedKnife:IsCastable() and v14:IsInRange(896 - (39 + 827)) and not v13:StealthUp(true, true) and (v85 == (0 - 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (2.5 - 1)))) then
				if (((4603 - 3444) <= (2744 - 956)) and v19(v75.PoisonedKnife)) then
					return "Cast Poisoned Knife";
				end
			end
			v87 = v132();
			if (v87 or ((301 + 3206) > (12638 - 8320))) then
				return v87;
			end
			v87 = v133();
			if (v87 or ((492 + 2583) <= (4691 - 1726))) then
				return v87;
			end
			if (((1469 - (103 + 1)) <= (2565 - (475 + 79))) and v27) then
				if ((v75.ArcaneTorrent:IsCastable() and v81 and (v13:EnergyDeficit() > (32 - 17))) or ((8883 - 6107) > (463 + 3112))) then
					if (v19(v75.ArcaneTorrent, v31) or ((2248 + 306) == (6307 - (1395 + 108)))) then
						return "Cast Arcane Torrent";
					end
				end
				if (((7498 - 4921) == (3781 - (7 + 1197))) and v75.ArcanePulse:IsCastable() and v81) then
					if (v19(v75.ArcanePulse, v31) or ((3 + 3) >= (660 + 1229))) then
						return "Cast Arcane Pulse";
					end
				end
				if (((825 - (27 + 292)) <= (5543 - 3651)) and v75.LightsJudgment:IsCastable() and v81) then
					if (v19(v75.LightsJudgment, v31) or ((2560 - 552) > (9301 - 7083))) then
						return "Cast Lights Judgment";
					end
				end
				if (((746 - 367) <= (7897 - 3750)) and v75.BagofTricks:IsCastable() and v81) then
					if (v19(v75.BagofTricks, v31) or ((4653 - (43 + 96)) <= (4115 - 3106))) then
						return "Cast Bag of Tricks";
					end
				end
			end
			if (v75.Mutilate:IsCastable() or v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable() or ((7903 - 4407) == (990 + 202))) then
				if (v19(v75.PoolEnergy) or ((59 + 149) == (5848 - 2889))) then
					return "Normal Pooling";
				end
			end
		end
	end
	local function v135()
		v75.Deathmark:RegisterAuraTracking();
		v75.Sepsis:RegisterAuraTracking();
		v75.Garrote:RegisterAuraTracking();
		v9.Print("Assassination Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(100 + 159, v134, v135);
end;
return v0["Epix_Rogue_Assassination.lua"]();

