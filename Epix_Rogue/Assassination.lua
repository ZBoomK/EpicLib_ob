local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2858 + 1056) == (4510 - 2335))) then
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
	local v23 = v9.Commons.Everyone.num;
	local v24 = v9.Commons.Everyone.bool;
	local v25 = math.min;
	local v26 = math.abs;
	local v27 = math.max;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = v9.Press;
	local v32 = pairs;
	local v33 = math.floor;
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
	local v73;
	local function v74()
		local v138 = 1812 - (1293 + 519);
		while true do
			if ((v138 == (3 - 1)) or ((12485 - 7703) < (2292 - 1093))) then
				v48 = EpicSettings.Settings['UsePriorityRotation'];
				v52 = EpicSettings.Settings['STMfDAsDPSCD'];
				v53 = EpicSettings.Settings['KidneyShotInterrupt'];
				v54 = EpicSettings.Settings['RacialsGCD'];
				v55 = EpicSettings.Settings['RacialsOffGCD'];
				v56 = EpicSettings.Settings['VanishOffGCD'];
				v138 = 12 - 9;
			end
			if ((v138 == (0 - 0)) or ((2577 + 2287) < (389 + 1513))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v138 = 1 + 0;
			end
			if (((5935 - (709 + 387)) >= (5558 - (673 + 1185))) and (v138 == (8 - 5))) then
				v57 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v58 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v59 = EpicSettings.Settings['ColdBloodOffGCD'];
				v60 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v61 = EpicSettings.Settings['CrimsonVialHP'] or (3 - 2);
				v62 = EpicSettings.Settings['FeintHP'] or (1 - 0);
				v138 = 3 + 1;
			end
			if (((3 + 1) == v138) or ((1450 - 375) > (472 + 1446))) then
				v63 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 - 0);
				v65 = EpicSettings.Settings['MutilateDMGOffset'] or (1 - 0);
				v66 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v67 = EpicSettings.Settings['PotionTypeSelected'];
				v68 = EpicSettings.Settings['ExsanguinateGCD'];
				v138 = 1885 - (446 + 1434);
			end
			if (((1679 - (1040 + 243)) <= (11353 - 7549)) and (v138 == (1848 - (559 + 1288)))) then
				v41 = EpicSettings.Settings['InterruptWithStun'] or (1931 - (609 + 1322));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (454 - (13 + 441));
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v45 = EpicSettings.Settings['PoisonRefresh'];
				v46 = EpicSettings.Settings['PoisonRefreshCombat'];
				v47 = EpicSettings.Settings['RangedMultiDoT'];
				v138 = 5 - 3;
			end
			if ((v138 == (24 - 19)) or ((156 + 4013) == (7942 - 5755))) then
				v69 = EpicSettings.Settings['KingsbaneGCD'];
				v70 = EpicSettings.Settings['ShivGCD'];
				v71 = EpicSettings.Settings['DeathmarkOffGCD'];
				v73 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v72 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
		end
	end
	local v75 = v9.Commons.Everyone;
	local v76 = v9.Commons.Rogue;
	local v77 = v15.Rogue.Assassination;
	local v78 = v21.Rogue.Assassination;
	local v79 = v20.Rogue.Assassination;
	local v80 = {v79.AlgetharPuzzleBox,v79.AshesoftheEmbersoul,v79.WitherbarksBranch};
	local v81, v82, v83, v84;
	local v85, v86, v87, v88;
	local v89;
	local v90, v91 = (2 + 0) * v13:SpellHaste(), (1 - 0) * v13:SpellHaste();
	local v92, v93;
	local v94, v95, v96, v97, v98, v99, v100;
	local v101;
	local v102, v103, v104, v105, v106, v107, v108, v109;
	local v110 = 0 + 0;
	local v111 = v13:GetEquipment();
	local v112 = (v111[8 + 5] and v20(v111[10 + 3])) or v20(0 + 0);
	local v113 = (v111[14 + 0] and v20(v111[447 - (153 + 280)])) or v20(0 - 0);
	local function v114()
		if (((1263 + 143) == (556 + 850)) and v112:HasStatAnyDps() and (not v113:HasStatAnyDps() or (v112:Cooldown() >= v113:Cooldown()))) then
			v110 = 1 + 0;
		elseif (((1390 + 141) < (3095 + 1176)) and v113:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v113:Cooldown() > v112:Cooldown()))) then
			v110 = 2 - 0;
		else
			v110 = 0 + 0;
		end
	end
	v114();
	v9:RegisterForEvent(function()
		local v139 = 667 - (89 + 578);
		while true do
			if (((454 + 181) == (1319 - 684)) and ((1050 - (572 + 477)) == v139)) then
				v113 = (v111[2 + 12] and v20(v111[9 + 5])) or v20(0 + 0);
				v114();
				break;
			end
			if (((3459 - (84 + 2)) <= (5860 - 2304)) and (v139 == (0 + 0))) then
				v111 = v13:GetEquipment();
				v112 = (v111[855 - (497 + 345)] and v20(v111[1 + 12])) or v20(0 + 0);
				v139 = 1334 - (605 + 728);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v115 = {{v77.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v77.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v92 > (0 + 0);
	end}};
	v77.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v92 * (1402.22 - (832 + 570)) * (1 + 0) * ((v14:DebuffUp(v77.ShivDebuff) and (1.3 + 0)) or (3 - 2)) * ((v77.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (797 - (588 + 208))) * ((2 - 1) + (v13:MasteryPct() / (1900 - (884 + 916)))) * ((1 - 0) + (v13:VersatilityDmgPct() / (58 + 42)));
	end);
	v77.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (653.485 - (232 + 421)) * (1890 - (1569 + 320)) * (1 + 0 + (v13:VersatilityDmgPct() / (19 + 81)));
	end);
	local function v116()
		return v13:BuffRemains(v77.MasterAssassinBuff) == (33694 - 23695);
	end
	local function v117()
		local v140 = 605 - (316 + 289);
		while true do
			if ((v140 == (0 - 0)) or ((152 + 3139) < (4733 - (666 + 787)))) then
				if (((4811 - (360 + 65)) >= (816 + 57)) and v116()) then
					return v13:GCDRemains() + (257 - (79 + 175));
				end
				return v13:BuffRemains(v77.MasterAssassinBuff);
			end
		end
	end
	local function v118()
		local v141 = 0 - 0;
		while true do
			if (((719 + 202) <= (3377 - 2275)) and (v141 == (0 - 0))) then
				if (((5605 - (503 + 396)) >= (1144 - (92 + 89))) and v13:BuffUp(v77.ImprovedGarroteAura)) then
					return v13:GCDRemains() + (5 - 2);
				end
				return v13:BuffRemains(v77.ImprovedGarroteBuff);
			end
		end
	end
	local function v119()
		local v142 = 0 + 0;
		while true do
			if (((0 + 0) == v142) or ((3759 - 2799) <= (120 + 756))) then
				if (v13:BuffUp(v77.IndiscriminateCarnageAura) or ((4710 - 2644) == (814 + 118))) then
					return v13:GCDRemains() + 5 + 5;
				end
				return v13:BuffRemains(v77.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v48()
		local v143 = 0 - 0;
		while true do
			if (((603 + 4222) < (7385 - 2542)) and (v143 == (1244 - (485 + 759)))) then
				if ((v87 < (4 - 2)) or ((5066 - (442 + 747)) >= (5672 - (832 + 303)))) then
					return false;
				elseif ((v48 == "Always") or ((5261 - (88 + 858)) < (527 + 1199))) then
					return true;
				elseif (((v48 == "On Bosses") and v14:IsInBossList()) or ((3045 + 634) < (26 + 599))) then
					return true;
				elseif ((v48 == "Auto") or ((5414 - (766 + 23)) < (3120 - 2488))) then
					if (((v13:InstanceDifficulty() == (21 - 5)) and (v14:NPCID() == (366137 - 227170))) or ((281 - 198) > (2853 - (1036 + 37)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v120()
		if (((388 + 158) <= (2097 - 1020)) and (v14:DebuffUp(v77.Deathmark) or v14:DebuffUp(v77.Kingsbane) or v13:BuffUp(v77.ShadowDanceBuff) or v14:DebuffUp(v77.ShivDebuff) or (v77.ThistleTea:FullRechargeTime() < (16 + 4)) or (v13:EnergyPercentage() >= (1560 - (641 + 839))) or (v13:HasTier(944 - (910 + 3), 9 - 5) and ((v13:BuffUp(v77.Envenom) and (v13:BuffRemains(v77.Envenom) <= (1686 - (1466 + 218)))) or v9.BossFilteredFightRemains("<=", 42 + 48))))) then
			return true;
		end
		return false;
	end
	local function v121()
		if (((v77.Deathmark:CooldownRemains() > v77.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v77.Deathmark:CooldownRemains()))) or ((2144 - (556 + 592)) > (1530 + 2771))) then
			return v77.Deathmark:CooldownRemains();
		end
		return v77.Sepsis:CooldownRemains();
	end
	local function v122()
		local v144 = 808 - (329 + 479);
		while true do
			if (((4924 - (174 + 680)) > (2360 - 1673)) and (v144 == (0 - 0))) then
				if (not v77.ScentOfBlood:IsAvailable() or ((469 + 187) >= (4069 - (396 + 343)))) then
					return true;
				end
				return v13:BuffStack(v77.ScentOfBloodBuff) >= v25(2 + 18, v77.ScentOfBlood:TalentRank() * (1479 - (29 + 1448)) * v87);
			end
		end
	end
	local function v123(v145, v146, v147)
		local v148 = 1389 - (135 + 1254);
		local v147;
		while true do
			if ((v148 == (0 - 0)) or ((11635 - 9143) <= (224 + 111))) then
				v147 = v147 or v146:PandemicThreshold();
				return v145:DebuffRefreshable(v146, v147);
			end
		end
	end
	local function v124(v149, v150, v151, v152)
		local v153 = 1527 - (389 + 1138);
		local v154;
		local v155;
		local v156;
		while true do
			if (((4896 - (102 + 472)) >= (2418 + 144)) and (v153 == (0 + 0))) then
				v154, v155 = nil, v151;
				v156 = v14:GUID();
				v153 = 1 + 0;
			end
			if ((v153 == (1546 - (320 + 1225))) or ((6473 - 2836) >= (2307 + 1463))) then
				for v222, v223 in v32(v152) do
					if (((v223:GUID() ~= v156) and v75.UnitIsCycleValid(v223, v155, -v223:DebuffRemains(v149)) and v150(v223)) or ((3843 - (157 + 1307)) > (6437 - (821 + 1038)))) then
						v154, v155 = v223, v223:TimeToDie();
					end
				end
				if (v154 or ((1205 - 722) > (82 + 661))) then
					CastLeftNameplate(v154, v149);
				elseif (((4358 - 1904) > (216 + 362)) and v47) then
					local v242 = 0 - 0;
					while true do
						if (((1956 - (834 + 192)) < (284 + 4174)) and (v242 == (0 + 0))) then
							v154, v155 = nil, v151;
							for v247, v248 in v32(v86) do
								if (((15 + 647) <= (1505 - 533)) and (v248:GUID() ~= v156) and v75.UnitIsCycleValid(v248, v155, -v248:DebuffRemains(v149)) and v150(v248)) then
									v154, v155 = v248, v248:TimeToDie();
								end
							end
							v242 = 305 - (300 + 4);
						end
						if (((1168 + 3202) == (11439 - 7069)) and (v242 == (363 - (112 + 250)))) then
							if (v154 or ((1899 + 2863) <= (2156 - 1295))) then
								CastLeftNameplate(v154, v149);
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v125(v157, v158, v159)
		local v160 = 0 + 0;
		local v161;
		local v162;
		local v163;
		local v164;
		while true do
			if ((v160 == (0 + 0)) or ((1057 + 355) == (2115 + 2149))) then
				v161 = v158(v14);
				if (((v157 == "first") and (v161 ~= (0 + 0))) or ((4582 - (1001 + 413)) < (4800 - 2647))) then
					return v14;
				end
				v160 = 883 - (244 + 638);
			end
			if ((v160 == (695 - (627 + 66))) or ((14826 - 9850) < (1934 - (512 + 90)))) then
				function v164(v224)
					for v227, v228 in v32(v224) do
						local v229 = v158(v228);
						if (((6534 - (1665 + 241)) == (5345 - (373 + 344))) and not v162 and (v157 == "first")) then
							if ((v229 ~= (0 + 0)) or ((15 + 39) == (1041 - 646))) then
								v162, v163 = v228, v229;
							end
						elseif (((138 - 56) == (1181 - (35 + 1064))) and (v157 == "min")) then
							if (not v162 or (v229 < v163) or ((423 + 158) < (603 - 321))) then
								v162, v163 = v228, v229;
							end
						elseif ((v157 == "max") or ((19 + 4590) < (3731 - (298 + 938)))) then
							if (((2411 - (233 + 1026)) == (2818 - (636 + 1030))) and (not v162 or (v229 > v163))) then
								v162, v163 = v228, v229;
							end
						end
						if (((970 + 926) <= (3343 + 79)) and v162 and (v229 == v163) and (v228:TimeToDie() > v162:TimeToDie())) then
							v162, v163 = v228, v229;
						end
					end
				end
				v164(v88);
				v160 = 1 + 2;
			end
			if ((v160 == (1 + 3)) or ((1211 - (55 + 166)) > (314 + 1306))) then
				if ((v162 and v159(v162)) or ((89 + 788) > (17930 - 13235))) then
					return v162;
				end
				return nil;
			end
			if (((2988 - (36 + 261)) >= (3236 - 1385)) and (v160 == (1371 - (34 + 1334)))) then
				if (v47 or ((1148 + 1837) >= (3774 + 1082))) then
					v164(v86);
				end
				if (((5559 - (1035 + 248)) >= (1216 - (20 + 1))) and v162 and (v163 == v161) and v159(v14)) then
					return v14;
				end
				v160 = 3 + 1;
			end
			if (((3551 - (134 + 185)) <= (5823 - (549 + 584))) and (v160 == (686 - (314 + 371)))) then
				v162, v163 = nil, 0 - 0;
				v164 = nil;
				v160 = 970 - (478 + 490);
			end
		end
	end
	local function v126(v165, v166, v167)
		local v168 = 0 + 0;
		local v169;
		while true do
			if ((v168 == (1172 - (786 + 386))) or ((2901 - 2005) >= (4525 - (1055 + 324)))) then
				v169 = v14:TimeToDie();
				if (((4401 - (1093 + 247)) >= (2629 + 329)) and not v9.BossFightRemainsIsNotValid()) then
					v169 = v9.BossFightRemains();
				elseif (((336 + 2851) >= (2556 - 1912)) and (v169 < v167)) then
					return false;
				end
				v168 = 3 - 2;
			end
			if (((1832 - 1188) <= (1768 - 1064)) and ((1 + 0) == v168)) then
				if (((3690 - 2732) > (3264 - 2317)) and (v33((v169 - v167) / v165) > v33(((v169 - v167) - v166) / v165))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v127(v170)
		if (((3388 + 1104) >= (6786 - 4132)) and v170:DebuffUp(v77.SerratedBoneSpikeDebuff)) then
			return 1000688 - (364 + 324);
		end
		return v170:TimeToDie();
	end
	local function v128(v171)
		return not v171:DebuffUp(v77.SerratedBoneSpikeDebuff);
	end
	local function v129()
		local v172 = 0 - 0;
		while true do
			if (((8259 - 4817) >= (499 + 1004)) and (v172 == (0 - 0))) then
				if (v77.BloodFury:IsCastable() or ((5076 - 1906) <= (4446 - 2982))) then
					if (v9.Cast(v77.BloodFury, v34) or ((6065 - (1249 + 19)) == (3961 + 427))) then
						return "Cast Blood Fury";
					end
				end
				if (((2144 - 1593) <= (1767 - (686 + 400))) and v77.Berserking:IsCastable()) then
					if (((2572 + 705) > (636 - (73 + 156))) and v9.Cast(v77.Berserking, v34)) then
						return "Cast Berserking";
					end
				end
				v172 = 1 + 0;
			end
			if (((5506 - (721 + 90)) >= (16 + 1399)) and (v172 == (6 - 4))) then
				if ((v77.ArcaneTorrent:IsCastable() and (v13:EnergyDeficit() > (485 - (224 + 246)))) or ((5203 - 1991) <= (1737 - 793))) then
					if (v9.Cast(v77.ArcaneTorrent, v34) or ((562 + 2534) <= (43 + 1755))) then
						return "Cast Arcane Torrent";
					end
				end
				if (((2598 + 939) == (7031 - 3494)) and v77.ArcanePulse:IsCastable()) then
					if (((12768 - 8931) >= (2083 - (203 + 310))) and v9.Cast(v77.ArcanePulse, v34)) then
						return "Cast Arcane Pulse";
					end
				end
				v172 = 1996 - (1238 + 755);
			end
			if ((v172 == (1 + 2)) or ((4484 - (709 + 825)) == (7024 - 3212))) then
				if (((6879 - 2156) >= (3182 - (196 + 668))) and v77.LightsJudgment:IsCastable()) then
					if (v9.Cast(v77.LightsJudgment, v34) or ((8003 - 5976) > (5907 - 3055))) then
						return "Cast Lights Judgment";
					end
				end
				if (v77.BagofTricks:IsCastable() or ((1969 - (171 + 662)) > (4410 - (4 + 89)))) then
					if (((16641 - 11893) == (1729 + 3019)) and v9.Cast(v77.BagofTricks, v34)) then
						return "Cast Bag of Tricks";
					end
				end
				v172 = 17 - 13;
			end
			if (((1466 + 2270) <= (6226 - (35 + 1451))) and (v172 == (1457 - (28 + 1425)))) then
				return false;
			end
			if ((v172 == (1994 - (941 + 1052))) or ((3251 + 139) <= (4574 - (822 + 692)))) then
				if (v77.Fireblood:IsCastable() or ((1425 - 426) > (1269 + 1424))) then
					if (((760 - (45 + 252)) < (595 + 6)) and v9.Cast(v77.Fireblood, v34)) then
						return "Cast Fireblood";
					end
				end
				if (v77.AncestralCall:IsCastable() or ((752 + 1431) < (1671 - 984))) then
					if (((4982 - (114 + 319)) == (6530 - 1981)) and ((not v77.Kingsbane:IsAvailable() and v14:DebuffUp(v77.ShivDebuff)) or (v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (9 - 1))))) then
						if (((2979 + 1693) == (6959 - 2287)) and v9.Cast(v77.AncestralCall, v34)) then
							return "Cast Ancestral Call";
						end
					end
				end
				v172 = 3 - 1;
			end
		end
	end
	local function v130()
		local v173 = 1963 - (556 + 1407);
		while true do
			if (((1206 - (741 + 465)) == v173) or ((4133 - (170 + 295)) < (209 + 186))) then
				if ((v77.ShadowDance:IsCastable() and not v77.Kingsbane:IsAvailable()) or ((3827 + 339) == (1120 - 665))) then
					local v230 = 0 + 0;
					while true do
						if ((v230 == (0 + 0)) or ((2520 + 1929) == (3893 - (957 + 273)))) then
							if ((v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and ((v14:PMultiplier(v77.Garrote) <= (1 + 0)) or v123(v14, v77.Garrote)) and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (5 + 7)) or (v77.Deathmark:CooldownRemains() > (228 - 168))) and (v93 >= math.min(v87, 10 - 6))) or ((13063 - 8786) < (14800 - 11811))) then
								local v245 = 1780 - (389 + 1391);
								while true do
									if ((v245 == (0 + 0)) or ((91 + 779) >= (9445 - 5296))) then
										if (((3163 - (783 + 168)) < (10682 - 7499)) and (v13:EnergyPredicted() < (45 + 0))) then
											if (((4957 - (309 + 2)) > (9187 - 6195)) and v22(v77.PoolEnergy)) then
												return "Pool for Shadow Dance (Garrote)";
											end
										end
										if (((2646 - (1090 + 122)) < (1007 + 2099)) and v22(v77.ShadowDance, v57)) then
											return "Cast Shadow Dance (Garrote)";
										end
										break;
									end
								end
							end
							if (((2639 - 1853) < (2069 + 954)) and not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v14, v77.Rupture) and (v14:DebuffRemains(v77.Garrote) > (1121 - (628 + 490))) and (v14:DebuffUp(v77.Deathmark) or (v77.Deathmark:CooldownRemains() > (11 + 49))) and (v14:DebuffUp(v77.ShivDebuff) or (v14:DebuffRemains(v77.Deathmark) < (9 - 5)) or v14:DebuffUp(v77.Sepsis)) and (v14:DebuffRemains(v77.Sepsis) < (13 - 10))) then
								if (v22(v77.ShadowDance, v57) or ((3216 - (431 + 343)) < (149 - 75))) then
									return "Cast Shadow Dance (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				if (((13119 - 8584) == (3583 + 952)) and v77.Vanish:IsCastable() and not v13:IsTanking(v14)) then
					if ((v77.ImprovedGarrote:IsAvailable() and not v77.MasterAssassin:IsAvailable() and v77.Garrote:CooldownUp() and ((v14:PMultiplier(v77.Garrote) <= (1 + 0)) or v123(v14, v77.Garrote))) or ((4704 - (556 + 1139)) <= (2120 - (6 + 9)))) then
						local v243 = 0 + 0;
						while true do
							if (((938 + 892) < (3838 - (28 + 141))) and (v243 == (0 + 0))) then
								if ((not v77.IndiscriminateCarnage:IsAvailable() and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (4 - 0))) and (v93 >= v25(v87, 3 + 1))) or ((2747 - (486 + 831)) >= (9399 - 5787))) then
									local v249 = 0 - 0;
									while true do
										if (((507 + 2176) >= (7778 - 5318)) and ((1263 - (668 + 595)) == v249)) then
											if ((v13:EnergyPredicted() < (41 + 4)) or ((364 + 1440) >= (8931 - 5656))) then
												if (v22(v77.PoolEnergy) or ((1707 - (23 + 267)) > (5573 - (1129 + 815)))) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (((5182 - (371 + 16)) > (2152 - (1326 + 424))) and v22(v77.Vanish, v56)) then
												return "Cast Vanish (Garrote Deathmark)";
											end
											break;
										end
									end
								end
								if (((9115 - 4302) > (13027 - 9462)) and v77.IndiscriminateCarnage:IsAvailable() and (v87 > (120 - (88 + 30)))) then
									if (((4683 - (720 + 51)) == (8702 - 4790)) and (v13:EnergyPredicted() < (1821 - (421 + 1355)))) then
										if (((4653 - 1832) <= (2370 + 2454)) and v22(v77.PoolEnergy)) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((2821 - (286 + 797)) <= (8024 - 5829)) and v22(v77.Vanish, v56)) then
										return "Cast Vanish (Garrote Cleave)";
									end
								end
								break;
							end
						end
					end
					if (((67 - 26) <= (3457 - (397 + 42))) and v77.MasterAssassin:IsAvailable() and v77.Kingsbane:IsAvailable() and v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) <= (1 + 2)) and v14:DebuffUp(v77.Deathmark) and (v14:DebuffRemains(v77.Deathmark) <= (803 - (24 + 776)))) then
						if (((3304 - 1159) <= (4889 - (222 + 563))) and v22(v77.Vanish, v56)) then
							return "Cast Vanish (Kingsbane)";
						end
					end
					if (((5924 - 3235) < (3489 + 1356)) and not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v14, v77.Rupture) and (v14:DebuffRemains(v77.Garrote) > (193 - (23 + 167))) and v14:DebuffUp(v77.Deathmark) and (v14:DebuffUp(v77.ShivDebuff) or (v14:DebuffRemains(v77.Deathmark) < (1802 - (690 + 1108))) or v14:DebuffUp(v77.Sepsis)) and (v14:DebuffRemains(v77.Sepsis) < (2 + 1))) then
						if (v22(v77.Vanish, v56) or ((1916 + 406) > (3470 - (40 + 808)))) then
							return "Cast Vanish (Master Assassin)";
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v174 = 0 + 0;
		while true do
			if ((v174 == (0 - 0)) or ((4334 + 200) == (1102 + 980))) then
				if (v112:IsReady() or ((862 + 709) > (2438 - (47 + 524)))) then
					local v231 = v75.HandleTopTrinket(v80, v30, 6 + 2, nil);
					if (v231 or ((7254 - 4600) >= (4479 - 1483))) then
						return v231;
					end
				end
				if (((9072 - 5094) > (3830 - (1165 + 561))) and v113:IsReady()) then
					local v232 = v75.HandleBottomTrinket(v80, v30, 1 + 7, nil);
					if (((9276 - 6281) > (588 + 953)) and v232) then
						return v232;
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v175 = 479 - (341 + 138);
		local v176;
		local v177;
		while true do
			if (((878 + 2371) > (1966 - 1013)) and (v175 == (327 - (89 + 237)))) then
				v177 = not v13:StealthUp(true, false) and v14:DebuffUp(v77.Rupture) and v13:BuffUp(v77.Envenom) and not v77.Deathmark:AnyDebuffUp() and (not v77.MasterAssassin:IsAvailable() or v14:DebuffUp(v77.Garrote)) and (not v77.Kingsbane:IsAvailable() or (v77.Kingsbane:CooldownRemains() <= (6 - 4)));
				if ((v77.Deathmark:IsCastable() and (v177 or v9.BossFilteredFightRemains("<=", 42 - 22))) or ((4154 - (581 + 300)) > (5793 - (855 + 365)))) then
					if (v22(v77.Deathmark) or ((7484 - 4333) < (420 + 864))) then
						return "Cast Deathmark";
					end
				end
				if ((v77.Shiv:IsReady() and not v14:DebuffUp(v77.ShivDebuff) and v14:DebuffUp(v77.Garrote) and v14:DebuffUp(v77.Rupture)) or ((3085 - (1030 + 205)) == (1436 + 93))) then
					local v233 = 0 + 0;
					while true do
						if (((1107 - (156 + 130)) < (4823 - 2700)) and (v233 == (1 - 0))) then
							if (((1846 - 944) < (613 + 1712)) and v77.ArterialPrecision:IsAvailable() and v77.Deathmark:AnyDebuffUp()) then
								if (((501 + 357) <= (3031 - (10 + 59))) and v22(v77.Shi)) then
									return "Cast Shiv (Arterial Precision)";
								end
							end
							if ((not v77.Kingsbane:IsAvailable() and not v77.ArterialPrecision:IsAvailable()) or ((1117 + 2829) < (6343 - 5055))) then
								if (v77.Sepsis:IsAvailable() or ((4405 - (671 + 492)) == (452 + 115))) then
									if (((v77.Shiv:ChargesFractional() > ((1215.9 - (369 + 846)) + v23(v77.LightweightShiv:IsAvailable()))) and (v103 > (2 + 3))) or v14:DebuffUp(v77.Sepsis) or v14:DebuffUp(v77.Deathmark) or ((723 + 124) >= (3208 - (1036 + 909)))) then
										if (v22(v77.Shiv) or ((1792 + 461) == (3107 - 1256))) then
											return "Cast Shiv (Sepsis)";
										end
									end
								elseif (not v77.CrimsonTempest:IsAvailable() or v108 or v14:DebuffUp(v77.CrimsonTempest) or ((2290 - (11 + 192)) > (1199 + 1173))) then
									if (v22(v77.Shiv) or ((4620 - (135 + 40)) < (10052 - 5903))) then
										return "Cast Shiv";
									end
								end
							end
							break;
						end
						if ((v233 == (0 + 0)) or ((4004 - 2186) == (127 - 42))) then
							if (((806 - (50 + 126)) < (5922 - 3795)) and v9.BossFilteredFightRemains("<=", v77.Shiv:Charges() * (2 + 6))) then
								if (v22(v77.Shiv) or ((3351 - (1233 + 180)) == (3483 - (522 + 447)))) then
									return "Cast Shiv (End of Fight)";
								end
							end
							if (((5676 - (107 + 1314)) >= (26 + 29)) and v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom)) then
								local v246 = 0 - 0;
								while true do
									if (((1274 + 1725) > (2295 - 1139)) and (v246 == (0 - 0))) then
										if (((4260 - (716 + 1194)) > (20 + 1135)) and not v77.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (1 + 7))) or (v77.Kingsbane:CooldownRemains() >= (527 - (74 + 429)))) and (not v77.CrimsonTempest:IsAvailable() or v108 or v14:DebuffUp(v77.CrimsonTempest))) then
											if (((7771 - 3742) <= (2406 + 2447)) and v22(v77.Shiv)) then
												return "Cast Shiv (Kingsbane)";
											end
										end
										if ((v77.LightweightShiv:IsAvailable() and (v14:DebuffUp(v77.Kingsbane) or (v77.Kingsbane:CooldownRemains() <= (2 - 1)))) or ((366 + 150) > (10586 - 7152))) then
											if (((10003 - 5957) >= (3466 - (279 + 154))) and v22(v77.Shiv)) then
												return "Cast Shiv (Kingsbane Lightweight)";
											end
										end
										break;
									end
								end
							end
							v233 = 779 - (454 + 324);
						end
					end
				end
				v175 = 2 + 0;
			end
			if ((v175 == (20 - (12 + 5))) or ((1466 + 1253) <= (3686 - 2239))) then
				if ((not v13:StealthUp(true, true) and (v118() <= (0 + 0)) and (v117() <= (1093 - (277 + 816)))) or ((17664 - 13530) < (5109 - (1058 + 125)))) then
					local v234 = 0 + 0;
					local v235;
					while true do
						if ((v234 == (975 - (815 + 160))) or ((703 - 539) >= (6611 - 3826))) then
							v235 = v130();
							if (v235 or ((126 + 399) == (6164 - 4055))) then
								return v235;
							end
							break;
						end
					end
				end
				if (((1931 - (41 + 1857)) == (1926 - (1222 + 671))) and v77.ColdBlood:IsReady() and v13:DebuffDown(v77.ColdBlood) and (v92 >= (10 - 6))) then
					if (((4389 - 1335) <= (5197 - (229 + 953))) and v9.Press(v77.ColdBlood)) then
						return "Cast Cold Blood";
					end
				end
				return false;
			end
			if (((3645 - (1111 + 663)) < (4961 - (874 + 705))) and ((0 + 0) == v175)) then
				if (((883 + 410) <= (4502 - 2336)) and v77.Sepsis:IsReady() and (v14:DebuffRemains(v77.Rupture) > (1 + 19)) and ((not v77.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v77.Garrote)) or (v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and (v14:PMultiplier(v77.Garrote) <= (680 - (642 + 37))))) and (v14:FilteredTimeToDie(">", 3 + 7) or v9.BossFilteredFightRemains("<=", 2 + 8))) then
					if (v22(v77.Sepsis, nil, true) or ((6474 - 3895) < (577 - (233 + 221)))) then
						return "Cast Sepsis";
					end
				end
				v176 = v75.HandleDPSPotion();
				if (v176 or ((1956 - 1110) >= (2085 + 283))) then
					return v176;
				end
				v175 = 1542 - (718 + 823);
			end
			if (((2 + 0) == v175) or ((4817 - (266 + 539)) <= (9507 - 6149))) then
				if (((2719 - (636 + 589)) <= (7133 - 4128)) and v77.ShadowDance:IsCastable() and v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (103 - 53)) or v177)) then
					if (v22(v77.ShadowDance) or ((2466 + 645) == (776 + 1358))) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				if (((3370 - (657 + 358)) == (6235 - 3880)) and v77.Kingsbane:IsReady() and (v14:DebuffUp(v77.ShivDebuff) or (v77.Shiv:CooldownRemains() < (13 - 7))) and v13:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (1237 - (1151 + 36))) or v14:DebuffUp(v77.Deathmark))) then
					if (v22(v77.Kingsbane) or ((568 + 20) <= (114 + 318))) then
						return "Cast Kingsbane";
					end
				end
				if (((14325 - 9528) >= (5727 - (1552 + 280))) and v77.ThistleTea:IsCastable() and not v13:BuffUp(v77.ThistleTea) and (((v13:EnergyDeficit() >= ((934 - (64 + 770)) + v105)) and (not v77.Kingsbane:IsAvailable() or (v77.ThistleTea:Charges() >= (2 + 0)))) or (v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (13 - 7))) or (not v77.Kingsbane:IsAvailable() and v77.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v77.ThistleTea:Charges() * (2 + 4)))) then
					if (((4820 - (157 + 1086)) == (7159 - 3582)) and v9.Cast(v77.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				v175 = 13 - 10;
			end
		end
	end
	local function v133()
		if (((5819 - 2025) > (5039 - 1346)) and v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom)) then
			local v183 = 819 - (599 + 220);
			while true do
				if ((v183 == (0 - 0)) or ((3206 - (1813 + 118)) == (2998 + 1102))) then
					if ((v77.Shiv:IsReady() and (v14:DebuffUp(v77.Kingsbane) or v77.Kingsbane:CooldownUp()) and v14:DebuffDown(v77.ShivDebuff)) or ((2808 - (841 + 376)) >= (5016 - 1436))) then
						if (((229 + 754) <= (4934 - 3126)) and v22(v77.Shiv)) then
							return "Cast Shiv (Stealth Kingsbane)";
						end
					end
					if ((v77.Kingsbane:IsReady() and (v13:BuffRemains(v77.ShadowDanceBuff) >= (861 - (464 + 395)))) or ((5517 - 3367) <= (575 + 622))) then
						if (((4606 - (467 + 370)) >= (2423 - 1250)) and v22(v77.Kingsbane, v69)) then
							return "Cast Kingsbane (Dance)";
						end
					end
					break;
				end
			end
		end
		if (((1091 + 394) == (5090 - 3605)) and (v92 >= (1 + 3))) then
			local v184 = 0 - 0;
			while true do
				if ((v184 == (520 - (150 + 370))) or ((4597 - (74 + 1208)) <= (6842 - 4060))) then
					if ((v14:DebuffUp(v77.Kingsbane) and (v13:BuffRemains(v77.Envenom) <= (9 - 7))) or ((624 + 252) >= (3354 - (14 + 376)))) then
						if (v22(v77.Envenom) or ((3871 - 1639) > (1616 + 881))) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if ((v108 and v116() and v13:BuffDown(v77.ShadowDanceBuff)) or ((1854 + 256) <= (317 + 15))) then
						if (((10800 - 7114) > (2387 + 785)) and v22(v77.Envenom)) then
							return "Cast Envenom (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if ((v29 and v77.CrimsonTempest:IsReady() and v77.Nightstalker:IsAvailable() and (v87 >= (81 - (23 + 55))) and (v92 >= (9 - 5)) and not v77.Deathmark:IsReady()) or ((2986 + 1488) < (737 + 83))) then
			if (((6633 - 2354) >= (907 + 1975)) and v22(v77.CrimsonTempest)) then
				return "Cast Crimson Tempest (Stealth)";
			end
		end
		if ((v77.Garrote:IsCastable() and (v118() > (901 - (652 + 249)))) or ((5429 - 3400) >= (5389 - (708 + 1160)))) then
			local function v185(v219)
				return v219:DebuffRemains(v77.Garrote);
			end
			local function v186(v220)
				return ((v220:PMultiplier(v77.Garrote) <= (2 - 1)) or (v220:DebuffRemains(v77.Garrote) < ((21 - 9) / v76.ExsanguinatedRate(v220, v77.Garrote))) or ((v119() > (27 - (10 + 17))) and (v77.Garrote:AuraActiveCount() < v87))) and not v108 and (v220:FilteredTimeToDie(">", 1 + 1, -v220:DebuffRemains(v77.Garrote)) or v220:TimeToDieIsNotValid()) and v76.CanDoTUnit(v220, v97);
			end
			if (v29 or ((3769 - (1400 + 332)) >= (8903 - 4261))) then
				local v225 = v125("min", v185, v186);
				if (((3628 - (242 + 1666)) < (1908 + 2550)) and v225 and (v225:GUID() == v19:GUID())) then
					v22(v78.GarroteMouseOver);
				end
			end
			if (v186(v14) or ((160 + 276) > (2575 + 446))) then
				if (((1653 - (850 + 90)) <= (1483 - 636)) and v17(v77.Garrote)) then
					return "Cast Garrote (Improved Garrote)";
				end
			end
			if (((3544 - (360 + 1030)) <= (3568 + 463)) and (v93 >= ((2 - 1) + ((2 - 0) * v23(v77.ShroudedSuffocation:IsAvailable()))))) then
				if (((6276 - (909 + 752)) == (5838 - (109 + 1114))) and v13:BuffDown(v77.ShadowDanceBuff) and ((v14:PMultiplier(v77.Garrote) <= (1 - 0)) or (v14:DebuffUp(v77.Deathmark) and (v117() < (2 + 1))))) then
					if (v17(v77.Garrote) or ((4032 - (6 + 236)) == (316 + 184))) then
						return "Cast Garrote (Improved Garrote Low CP)";
					end
				end
				if (((72 + 17) < (520 - 299)) and ((v14:PMultiplier(v77.Garrote) <= (1 - 0)) or (v14:DebuffRemains(v77.Garrote) < (1145 - (1076 + 57))))) then
					if (((338 + 1716) >= (2110 - (579 + 110))) and v17(v77.Garrote)) then
						return "Cast Garrote (Improved Garrote Low CP 2)";
					end
				end
			end
		end
		if (((55 + 637) < (2704 + 354)) and (v92 >= (3 + 1)) and (v14:PMultiplier(v77.Rupture) <= (408 - (174 + 233))) and (v13:BuffUp(v77.ShadowDanceBuff) or v14:DebuffUp(v77.Deathmark))) then
			if (v17(v77.Rupture) or ((9089 - 5835) == (2904 - 1249))) then
				return "Cast Rupture (Nightstalker)";
			end
		end
	end
	local function v134()
		if ((v29 and v77.CrimsonTempest:IsReady() and (v87 >= (1 + 1)) and (v92 >= (1178 - (663 + 511))) and (v105 > (23 + 2)) and not v77.Deathmark:IsReady()) or ((282 + 1014) == (15137 - 10227))) then
			if (((2040 + 1328) == (7929 - 4561)) and v22(v77.CrimsonTempest)) then
				return "Cast Crimson Tempest (AoE High Energy)";
			end
		end
		if (((6398 - 3755) < (1821 + 1994)) and v77.Garrote:IsCastable() and (v93 >= (1 - 0))) then
			local v187 = 0 + 0;
			local v188;
			while true do
				if (((175 + 1738) > (1215 - (478 + 244))) and (v187 == (518 - (440 + 77)))) then
					if (((2162 + 2593) > (12546 - 9118)) and v188(v14) and v76.CanDoTUnit(v14, v97) and (v14:FilteredTimeToDie(">", 1568 - (655 + 901), -v14:DebuffRemains(v77.Garrote)) or v14:TimeToDieIsNotValid())) then
						if (((257 + 1124) <= (1814 + 555)) and v31(v77.Garrote)) then
							return "Pool for Garrote (ST)";
						end
					end
					break;
				end
				if ((v187 == (0 + 0)) or ((19510 - 14667) == (5529 - (695 + 750)))) then
					v188 = nil;
					function v188(v239)
						return v123(v239, v77.Garrote) and (v239:PMultiplier(v77.Garrote) <= (3 - 2));
					end
					v187 = 1 - 0;
				end
			end
		end
		if (((18777 - 14108) > (714 - (285 + 66))) and v77.Rupture:IsReady() and (v92 >= (8 - 4))) then
			v98 = (1314 - (682 + 628)) + (v23(v77.DashingScoundrel:IsAvailable()) * (1 + 4)) + (v23(v77.Doomblade:IsAvailable()) * (304 - (176 + 123))) + (v23(v107) * (3 + 3));
			local function v189(v221)
				return v123(v221, v77.Rupture, v94) and (v221:PMultiplier(v77.Rupture) <= (1 + 0)) and (v221:FilteredTimeToDie(">", v98, -v221:DebuffRemains(v77.Rupture)) or v221:TimeToDieIsNotValid());
			end
			if ((v189(v14) and v76.CanDoTUnit(v14, v96)) or ((2146 - (239 + 30)) >= (854 + 2284))) then
				if (((4558 + 184) >= (6417 - 2791)) and v22(v77.Rupture)) then
					return "Cast Rupture";
				end
			end
		end
		if ((v77.Garrote:IsCastable() and (v93 >= (2 - 1)) and (v117() <= (315 - (306 + 9))) and ((v14:PMultiplier(v77.Garrote) <= (3 - 2)) or ((v14:DebuffRemains(v77.Garrote) < v90) and (v87 >= (1 + 2)))) and (v14:DebuffRemains(v77.Garrote) < (v90 * (2 + 0))) and (v87 >= (2 + 1)) and (v14:FilteredTimeToDie(">", 11 - 7, -v14:DebuffRemains(v77.Garrote)) or v14:TimeToDieIsNotValid())) or ((5915 - (1140 + 235)) == (583 + 333))) then
			if (v22(v77.Garrote) or ((1061 + 95) > (1116 + 3229))) then
				return "Garrote (Fallback)";
			end
		end
		return false;
	end
	local function v135()
		local v178 = 52 - (33 + 19);
		while true do
			if (((808 + 1429) < (12735 - 8486)) and (v178 == (2 + 1))) then
				if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v77.BlindsideBuff) or v13:BuffUp(v77.SepsisBuff)) and (v14:DebuffDown(v77.Kingsbane) or v14:DebuffDown(v77.Deathmark) or v13:BuffUp(v77.BlindsideBuff))) or ((5261 - 2578) < (22 + 1))) then
					if (((1386 - (586 + 103)) <= (76 + 750)) and v22(v77.Ambush)) then
						return "Cast Ambush";
					end
				end
				if (((3401 - 2296) <= (2664 - (1309 + 179))) and v77.Mutilate:IsCastable() and (v87 == (2 - 0)) and v14:DebuffDown(v77.DeadlyPoisonDebuff, true) and v14:DebuffDown(v77.AmplifyingPoisonDebuff, true)) then
					local v236 = v14:GUID();
					for v240, v241 in v32(v88) do
					end
				end
				v178 = 2 + 2;
			end
			if (((9074 - 5695) <= (2880 + 932)) and (v178 == (0 - 0))) then
				if ((v77.Envenom:IsReady() and (v92 >= (7 - 3)) and (v102 or (v14:DebuffStack(v77.AmplifyingPoisonDebuff) >= (629 - (295 + 314))) or (v92 > v76.CPMaxSpend()) or not v108)) or ((1935 - 1147) >= (3578 - (1300 + 662)))) then
					if (((5821 - 3967) <= (5134 - (1178 + 577))) and v22(v77.Envenom)) then
						return "Cast Envenom";
					end
				end
				if (((2363 + 2186) == (13447 - 8898)) and not ((v93 > (1406 - (851 + 554))) or v102 or not v108)) then
					return false;
				end
				v178 = 1 + 0;
			end
			if ((v178 == (2 - 1)) or ((6562 - 3540) >= (3326 - (115 + 187)))) then
				if (((3692 + 1128) > (2081 + 117)) and not v108 and v77.CausticSpatter:IsAvailable() and v14:DebuffUp(v77.Rupture) and (v14:DebuffRemains(v77.CausticSpatterDebuff) <= (7 - 5))) then
					local v237 = 1161 - (160 + 1001);
					while true do
						if ((v237 == (0 + 0)) or ((733 + 328) >= (10012 - 5121))) then
							if (((1722 - (237 + 121)) <= (5370 - (525 + 372))) and v77.Mutilate:IsCastable()) then
								if (v22(v77.Mutilate) or ((6815 - 3220) <= (9 - 6))) then
									return "Cast Mutilate (Casutic)";
								end
							end
							if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v77.BlindsideBuff))) or ((4814 - (96 + 46)) == (4629 - (643 + 134)))) then
								if (((563 + 996) == (3737 - 2178)) and v22(v77.Ambush)) then
									return "Cast Ambush (Caustic)";
								end
							end
							break;
						end
					end
				end
				if (v77.SerratedBoneSpike:IsReady() or ((6504 - 4752) <= (756 + 32))) then
					if (not v14:DebuffUp(v77.SerratedBoneSpikeDebuff) or ((7667 - 3760) == (361 - 184))) then
						if (((4189 - (316 + 403)) > (369 + 186)) and v22(v77.SerratedBoneSpike)) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v244 = 0 - 0;
						while true do
							if ((v244 == (0 + 0)) or ((2447 - 1475) == (458 + 187))) then
								if (((1026 + 2156) >= (7328 - 5213)) and v29) then
									if (((18592 - 14699) < (9200 - 4771)) and v75.CastTargetIf(v77.SerratedBoneSpike, v85, "min", v127, v128)) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if ((v117() < (0.8 + 0)) or ((5643 - 2776) < (94 + 1811))) then
									if ((v9.BossFightRemains() <= (14 - 9)) or ((v77.SerratedBoneSpike:MaxCharges() - v77.SerratedBoneSpike:ChargesFractional()) <= (17.25 - (12 + 5))) or ((6975 - 5179) >= (8643 - 4592))) then
										if (((3441 - 1822) <= (9314 - 5558)) and v22(v77.SerratedBoneSpike)) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif (((123 + 481) == (2577 - (1656 + 317))) and not v108 and v14:DebuffUp(v77.ShivDebuff)) then
										if (v22(v77.SerratedBoneSpike) or ((3996 + 488) == (722 + 178))) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v178 = 4 - 2;
			end
			if ((v178 == (19 - 15)) or ((4813 - (5 + 349)) <= (5286 - 4173))) then
				if (((4903 - (266 + 1005)) > (2240 + 1158)) and v77.Mutilate:IsCastable()) then
					if (((13928 - 9846) <= (6473 - 1556)) and v22(v77.Mutilate)) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
			if (((6528 - (561 + 1135)) >= (1805 - 419)) and (v178 == (6 - 4))) then
				if (((1203 - (507 + 559)) == (343 - 206)) and v30 and v77.EchoingReprimand:IsReady()) then
					if (v22(v77.EchoingReprimand) or ((4855 - 3285) >= (4720 - (212 + 176)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (v77.FanofKnives:IsCastable() or ((4969 - (250 + 655)) <= (4960 - 3141))) then
					local v238 = 0 - 0;
					while true do
						if ((v238 == (0 - 0)) or ((6942 - (1869 + 87)) < (5459 - 3885))) then
							if (((6327 - (484 + 1417)) > (368 - 196)) and v29 and (v87 >= (2 - 0)) and (v87 >= ((775 - (48 + 725)) + v23(v13:StealthUp(true, false)) + v23(v77.DragonTemperedBlades:IsAvailable())))) then
								if (((957 - 371) > (1220 - 765)) and v22(v77.FanofKnives)) then
									return "Cast Fan of Knives";
								end
							end
							if (((481 + 345) == (2207 - 1381)) and v29 and (v87 >= (1 + 1))) then
								if (v22(v77.FanofKnives) or ((1172 + 2847) > (5294 - (152 + 701)))) then
									return "Fillers Fan of knives";
								end
							end
							break;
						end
					end
				end
				v178 = 1314 - (430 + 881);
			end
		end
	end
	local function v136()
		v74();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v81 = (v77.AcrobaticStrikes:IsAvailable() and (4 + 4)) or (900 - (557 + 338));
		v82 = (v77.AcrobaticStrikes:IsAvailable() and (4 + 9)) or (28 - 18);
		v83 = v14:IsInMeleeRange(v81);
		v84 = v14:IsInMeleeRange(v82);
		if (((7063 - 5046) < (11320 - 7059)) and v29) then
			v85 = v13:GetEnemiesInRange(64 - 34);
			v86 = v13:GetEnemiesInMeleeRange(v82);
			v87 = #v86;
			v88 = v13:GetEnemiesInMeleeRange(v81);
		else
			v85 = {};
			v86 = {};
			v87 = 802 - (499 + 302);
			v88 = {};
		end
		v90, v91 = (868 - (39 + 827)) * v13:SpellHaste(), (2 - 1) * v13:SpellHaste();
		v92 = v76.EffectiveComboPoints(v13:ComboPoints());
		v93 = v13:ComboPointsMax() - v92;
		v94 = ((8 - 4) + (v92 * (15 - 11))) * (0.3 - 0);
		v95 = (1 + 3 + (v92 * (5 - 3))) * (0.3 + 0);
		v96 = v77.Envenom:Damage() * v64;
		v97 = v77.Mutilate:Damage() * v65;
		v101 = v48();
		v89 = v76.CrimsonVial();
		if (((7462 - 2746) > (184 - (103 + 1))) and v89) then
			return v89;
		end
		v89 = v76.Feint();
		if (v89 or ((4061 - (475 + 79)) == (7073 - 3801))) then
			return v89;
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v75.TargetIsValid()) or ((2803 - 1927) >= (398 + 2677))) then
			local v190 = 0 + 0;
			while true do
				if (((5855 - (1395 + 108)) > (7431 - 4877)) and (v190 == (1204 - (7 + 1197)))) then
					v89 = v76.Stealth(v77.Stealth2, nil);
					if (v89 or ((1922 + 2484) < (1411 + 2632))) then
						return "Stealth (OOC): " .. v89;
					end
					break;
				end
			end
		end
		v76.Poisons();
		if (not v13:AffectingCombat() or ((2208 - (27 + 292)) >= (9912 - 6529))) then
			local v191 = 0 - 0;
			while true do
				if (((7934 - 6042) <= (5391 - 2657)) and ((0 - 0) == v191)) then
					if (((2062 - (43 + 96)) < (9047 - 6829)) and not v13:BuffUp(v76.VanishBuffSpell())) then
						v89 = v76.Stealth(v76.StealthSpell());
						if (((4912 - 2739) > (315 + 64)) and v89) then
							return v89;
						end
					end
					if (v75.TargetIsValid() or ((732 + 1859) == (6737 - 3328))) then
						if (((1731 + 2783) > (6229 - 2905)) and v30) then
							if ((v28 and v77.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v76.CPMaxSpend()) and v75.TargetIsValid()) or ((66 + 142) >= (355 + 4473))) then
								if (v9.Press(v77.MarkedforDeath, v60) or ((3334 - (1414 + 337)) > (5507 - (1642 + 298)))) then
									return "Cast Marked for Death (OOC)";
								end
							end
						end
						if (not v13:BuffUp(v77.SliceandDice) or ((3422 - 2109) == (2284 - 1490))) then
							if (((9419 - 6245) > (956 + 1946)) and v77.SliceandDice:IsReady() and (v92 >= (2 + 0))) then
								if (((5092 - (357 + 615)) <= (2991 + 1269)) and v9.Press(v77.SliceandDice)) then
									return "Cast Slice and Dice";
								end
							end
						end
					end
					break;
				end
			end
		end
		v76.MfDSniping(v77.MarkedforDeath);
		if (v75.TargetIsValid() or ((2166 - 1283) > (4094 + 684))) then
			if ((not v13:IsCasting() and not v13:IsChanneling()) or ((7757 - 4137) >= (3912 + 979))) then
				local v226 = 0 + 0;
				while true do
					if (((2677 + 1581) > (2238 - (384 + 917))) and (v226 == (697 - (128 + 569)))) then
						v89 = v75.Interrupt(v77.Kick, 1551 - (1407 + 136), true);
						if (v89 or ((6756 - (687 + 1200)) < (2616 - (556 + 1154)))) then
							return v89;
						end
						v226 = 3 - 2;
					end
					if ((v226 == (97 - (9 + 86))) or ((1646 - (275 + 146)) > (688 + 3540))) then
						v89 = v75.InterruptWithStun(v77.KidneyShot, 72 - (29 + 35));
						if (((14749 - 11421) > (6684 - 4446)) and v89) then
							return v89;
						end
						break;
					end
					if (((16947 - 13108) > (916 + 489)) and (v226 == (1013 - (53 + 959)))) then
						v89 = v75.Interrupt(v77.Kick, 416 - (312 + 96), true, v19, v78.SilenceMouseover);
						if (v89 or ((2243 - 950) <= (792 - (147 + 138)))) then
							return v89;
						end
						v226 = 901 - (813 + 86);
					end
				end
			end
			v104 = v76.PoisonedBleeds();
			v105 = v13:EnergyRegen() + ((v104 * (6 + 0)) / ((3 - 1) * v13:SpellHaste()));
			v106 = v13:EnergyDeficit() / v105;
			v107 = v105 > (527 - (18 + 474));
			v102 = v120();
			v103 = v121();
			v109 = v122();
			v108 = v87 < (1 + 1);
			if (v13:StealthUp(true, false) or (v118() > (0 - 0)) or (v117() > (1086 - (860 + 226))) or ((3199 - (121 + 182)) < (100 + 705))) then
				v89 = v133();
				if (((3556 - (988 + 252)) == (262 + 2054)) and v89) then
					return v89 .. " (Stealthed)";
				end
			end
			v89 = v131();
			if (v89 or ((805 + 1765) == (3503 - (49 + 1921)))) then
				return v89;
			end
			local v192 = v75.HandleDPSPotion();
			if (v192 or ((1773 - (223 + 667)) == (1512 - (51 + 1)))) then
				return v192;
			end
			v89 = v132();
			if (v89 or ((7949 - 3330) <= (2138 - 1139))) then
				return v89;
			end
			local v193 = v129();
			if (v193 or ((4535 - (146 + 979)) > (1162 + 2954))) then
				return v193;
			end
			if (not v13:BuffUp(v77.SliceandDice) or ((1508 - (311 + 294)) >= (8530 - 5471))) then
				if ((v77.SliceandDice:IsReady() and (v13:ComboPoints() >= (1 + 1)) and v14:DebuffUp(v77.Rupture)) or (not v77.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (1447 - (496 + 947))) and (v13:BuffRemains(v77.SliceandDice) < (((1359 - (1233 + 125)) + v13:ComboPoints()) * (1.8 + 0)))) or ((3568 + 408) < (543 + 2314))) then
					if (((6575 - (963 + 682)) > (1926 + 381)) and v22(v77.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
			elseif ((v84 and v77.CutToTheChase:IsAvailable()) or ((5550 - (504 + 1000)) < (870 + 421))) then
				if ((v77.Envenom:IsReady() and (v13:BuffRemains(v77.SliceandDice) < (5 + 0)) and (v13:ComboPoints() >= (1 + 3))) or ((6253 - 2012) == (3029 + 516))) then
					if (v22(v77.Envenom) or ((2355 + 1693) > (4414 - (156 + 26)))) then
						return "Cast Envenom (CttC)";
					end
				end
			elseif ((v77.PoisonedKnife:IsCastable() and v14:IsInRange(18 + 12) and not v13:StealthUp(true, true) and (v87 == (0 - 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (165.5 - (149 + 15))))) or ((2710 - (890 + 70)) >= (3590 - (39 + 78)))) then
				if (((3648 - (14 + 468)) == (6962 - 3796)) and v22(v77.PoisonedKnife)) then
					return "Cast Poisoned Knife";
				end
			end
			v89 = v134();
			if (((4927 - 3164) < (1922 + 1802)) and v89) then
				return v89;
			end
			v89 = v135();
			if (((35 + 22) <= (579 + 2144)) and v89) then
				return v89;
			end
			if (v77.Mutilate:IsCastable() or v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable() or ((935 + 1135) == (117 + 326))) then
				if (v22(v77.PoolEnergy) or ((5177 - 2472) == (1377 + 16))) then
					return "Normal Pooling";
				end
			end
		end
	end
	local function v137()
		local v182 = 0 - 0;
		while true do
			if (((0 + 0) == v182) or ((4652 - (12 + 39)) < (57 + 4))) then
				v77.Deathmark:RegisterAuraTracking();
				v77.Sepsis:RegisterAuraTracking();
				v182 = 2 - 1;
			end
			if (((3 - 2) == v182) or ((413 + 977) >= (2498 + 2246))) then
				v77.Garrote:RegisterAuraTracking();
				v9.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v9.SetAPL(656 - 397, v136, v137);
end;
return v0["Epix_Rogue_Assassination.lua"]();

