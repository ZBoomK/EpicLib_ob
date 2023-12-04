local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1670 - (243 + 1427);
	local v6;
	while true do
		if ((v5 == (1841 - (1206 + 635))) or ((4883 - 3419) > (3735 - (617 + 918)))) then
			v6 = v0[v4];
			if (not v6 or ((3837 - 2481) > (21773 - 17050))) then
				return v1(v4, ...);
			end
			v5 = 1812 - (1418 + 393);
		end
		if ((v5 == (749 - (655 + 93))) or ((4223 - (36 + 51)) <= (14803 - 11370))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Subtlety.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.MouseOver;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = v10.Utils;
	local v21 = v10.Utils.BoolToInt;
	local v22 = v10.AoEON;
	local v23 = v10.CDsON;
	local v24 = v10.Bind;
	local v25 = v10.Macro;
	local v26 = v10.Press;
	local v27 = v10.CastQueue;
	local v28 = v10.CastQueuePooling;
	local v29 = v10.Commons.Everyone.num;
	local v30 = v10.Commons.Everyone.bool;
	local v31 = pairs;
	local v32 = table.insert;
	local v33 = math.min;
	local v34 = math.max;
	local v35 = math.abs;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local function v85()
		v39 = EpicSettings.Settings['UseRacials'];
		v53 = EpicSettings.Settings['UseTrinkets'];
		v40 = EpicSettings.Settings['UseHealingPotion'];
		v41 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v42 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v43 = EpicSettings.Settings['UseHealthstone'];
		v44 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v45 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v47 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v49 = EpicSettings.Settings['PoisonRefresh'];
		v50 = EpicSettings.Settings['PoisonRefreshCombat'];
		v51 = EpicSettings.Settings['RangedMultiDoT'];
		v52 = EpicSettings.Settings['UsePriorityRotation'];
		v58 = EpicSettings.Settings['STMfDAsDPSCD'];
		v59 = EpicSettings.Settings['KidneyShotInterrupt'];
		v60 = EpicSettings.Settings['RacialsGCD'];
		v61 = EpicSettings.Settings['RacialsOffGCD'];
		v62 = EpicSettings.Settings['VanishOffGCD'];
		v63 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v64 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v65 = EpicSettings.Settings['ColdBloodOffGCD'];
		v66 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v67 = EpicSettings.Settings['CrimsonVialHP'];
		v68 = EpicSettings.Settings['FeintHP'];
		v69 = EpicSettings.Settings['StealthOOC'];
		v70 = EpicSettings.Settings['CrimsonVialGCD'];
		v71 = EpicSettings.Settings['FeintGCD'];
		v72 = EpicSettings.Settings['KickOffGCD'];
		v73 = EpicSettings.Settings['StealthOffGCD'];
		v74 = EpicSettings.Settings['EviscerateDMGOffset'] or true;
		v75 = EpicSettings.Settings['ShDEcoCharge'];
		v76 = EpicSettings.Settings['BurnShadowDance'];
		v77 = EpicSettings.Settings['PotionTypeSelectedSubtlety'];
		v78 = EpicSettings.Settings['ShurikenTornadoGCD'];
		v79 = EpicSettings.Settings['SymbolsofDeathOffGCD'];
		v80 = EpicSettings.Settings['ShadowBladesOffGCD'];
		v81 = EpicSettings.Settings['VanishStealthMacro'];
		v82 = EpicSettings.Settings['ShadowmeldStealthMacro'];
		v83 = EpicSettings.Settings['ShadowDanceStealthMacro'];
	end
	local v86 = v10.Commons.Everyone;
	local v87 = v10.Commons.Rogue;
	local v88 = v17.Rogue.Subtlety;
	local v89 = v19.Rogue.Subtlety;
	local v90 = v25.Rogue.Subtlety;
	local v91 = {v89.ManicGrieftorch:ID(),v89.BeaconToTheBeyond:ID(),v89.Mirror:ID()};
	local v92, v93, v94, v95;
	local v96, v97, v98, v99, v100;
	local v101;
	local v102, v103, v104;
	local v105, v106;
	local v107, v108, v109, v110;
	local v111;
	v88.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v107 * (0.176 - 0) * (3.21 - 2) * ((v88.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (1.08 - 0)) or (1 + 0)) * ((v88.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 - 0)) * ((v88.DarkShadow:IsAvailable() and v13:BuffUp(v88.ShadowDanceBuff) and (1.3 + 0)) or (1 - 0)) * ((v13:BuffUp(v88.SymbolsofDeath) and (1.1 - 0)) or (1881 - (446 + 1434))) * ((v13:BuffUp(v88.FinalityEviscerateBuff) and (1284.3 - (1040 + 243))) or (2 - 1)) * ((1848 - (559 + 1288)) + (v13:MasteryPct() / (2031 - (609 + 1322)))) * ((455 - (13 + 441)) + (v13:VersatilityDmgPct() / (373 - 273))) * ((v14:DebuffUp(v88.FindWeaknessDebuff) and (2.5 - 1)) or (4 - 3));
	end);
	v88.Rupture:RegisterPMultiplier(function()
		return (v13:BuffUp(v88.FinalityRuptureBuff) and (1.3 + 0)) or (3 - 2);
	end);
	local function v112(v171, v172)
		if (((1508 + 2737) <= (2030 + 2601)) and not v102) then
			v102 = v171;
			v103 = v172 or (0 - 0);
		end
	end
	local function v113(v173)
		if (((2340 + 1936) >= (7198 - 3284)) and not v104) then
			v104 = v173;
		end
	end
	local function v114()
		if (((131 + 67) <= (2428 + 1937)) and (v76 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) then
			return false;
		elseif (((3436 + 1346) > (3927 + 749)) and (v76 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v115()
		local v174 = 0 + 0;
		while true do
			if (((5297 - (153 + 280)) > (6343 - 4146)) and (v174 == (0 + 0))) then
				if ((v98 < (1 + 1)) or ((1937 + 1763) == (2276 + 231))) then
					return false;
				elseif (((3242 + 1232) >= (416 - 142)) and (v52 == "Always")) then
					return true;
				elseif (((v52 == "On Bosses") and v14:IsInBossList()) or ((1171 + 723) <= (2073 - (89 + 578)))) then
					return true;
				elseif (((1123 + 449) >= (3182 - 1651)) and (v52 == "Auto")) then
					if (((v13:InstanceDifficulty() == (1065 - (572 + 477))) and (v14:NPCID() == (18743 + 120224))) or ((2813 + 1874) < (543 + 3999))) then
						return true;
					elseif (((3377 - (84 + 2)) > (2746 - 1079)) and ((v14:NPCID() == (120287 + 46682)) or (v14:NPCID() == (167813 - (497 + 345))) or (v14:NPCID() == (4272 + 162698)))) then
						return true;
					elseif ((v14:NPCID() == (31014 + 152449)) or (v14:NPCID() == (185004 - (605 + 728))) or ((623 + 250) == (4521 - 2487))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v116(v175, v176, v177, v178, v179)
		local v180, v181 = nil, v177;
		local v182 = v14:GUID();
		for v224, v225 in v31(v178) do
			if (((v225:GUID() ~= v182) and v86.UnitIsCycleValid(v225, v181, -v225:DebuffRemains(v175)) and v176(v225)) or ((130 + 2686) < (40 - 29))) then
				v180, v181 = v225, v225:TimeToDie();
			end
		end
		if (((3335 + 364) < (13038 - 8332)) and v180) then
			v10.Press(v180, v175);
		elseif (((1998 + 648) >= (1365 - (457 + 32))) and v51) then
			local v230 = 0 + 0;
			while true do
				if (((2016 - (832 + 570)) <= (3000 + 184)) and ((1 + 0) == v230)) then
					if (((11062 - 7936) == (1506 + 1620)) and v180) then
						v10.Press(v180, v175);
					end
					break;
				end
				if ((v230 == (796 - (588 + 208))) or ((5894 - 3707) >= (6754 - (884 + 916)))) then
					v180, v181 = nil, v177;
					for v252, v253 in v31(v97) do
						if (((v253:GUID() ~= v182) and v86.UnitIsCycleValid(v253, v181, -v253:DebuffRemains(v175)) and v176(v253)) or ((8116 - 4239) == (2073 + 1502))) then
							v180, v181 = v253, v253:TimeToDie();
						end
					end
					v230 = 654 - (232 + 421);
				end
			end
		end
	end
	local function v117()
		return (1909 - (1569 + 320)) + (v88.Vigor:TalentRank() * (7 + 18)) + (v29(v88.ThistleTea:IsAvailable()) * (4 + 16)) + (v29(v88.Shadowcraft:IsAvailable()) * (67 - 47));
	end
	local function v118()
		return v88.ShadowDance:ChargesFractional() >= ((605.75 - (316 + 289)) + v21(v88.ShadowDanceTalent:IsAvailable()));
	end
	local function v119()
		return v109 >= (7 - 4);
	end
	local function v120()
		return v13:BuffUp(v88.SliceandDice) or (v98 >= v87.CPMaxSpend());
	end
	local function v121()
		return v88.Premeditation:IsAvailable() and (v98 < (1 + 4));
	end
	local function v122(v183)
		return (v13:BuffUp(v88.ThistleTea) and (v98 == (1454 - (666 + 787)))) or (v183 and ((v98 == (426 - (360 + 65))) or (v14:DebuffUp(v88.Rupture) and (v98 >= (2 + 0)))));
	end
	local function v123()
		return (not v13:BuffUp(v88.Premeditation) and (v98 == (255 - (79 + 175)))) or not v88.TheRotten:IsAvailable() or (v98 > (1 - 0));
	end
	local function v124()
		return v13:BuffDown(v88.PremeditationBuff) or (v98 > (1 + 0)) or ((v108 <= (5 - 3)) and v13:BuffUp(v88.TheRottenBuff) and not v13:HasTier(57 - 27, 901 - (503 + 396)));
	end
	local function v125(v184, v185)
		return v184 and ((v13:BuffStack(v88.DanseMacabreBuff) >= (184 - (92 + 89))) or not v88.DanseMacabre:IsAvailable()) and (not v185 or (v98 ~= (3 - 1)));
	end
	local function v126()
		return (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(16 + 14, 2 + 0)) and (not v88.ColdBlood:IsAvailable() or (v88.ColdBlood:CooldownRemains() < (15 - 11)) or (v88.ColdBlood:CooldownRemains() > (2 + 8)));
	end
	local function v127(v186)
		return v13:BuffUp(v88.ShadowDanceBuff) and (v186:TimeSinceLastCast() < v88.ShadowDance:TimeSinceLastCast());
	end
	local function v125()
		return ((v127(v88.Shadowstrike) or v127(v88.ShurikenStorm)) and (v127(v88.Eviscerate) or v127(v88.BlackPowder) or v127(v88.Rupture))) or not v88.DanseMacabre:IsAvailable();
	end
	local function v128()
		return (not v89.WitherbarksBranch:IsEquipped() and not v89.AshesoftheEmbersoul:IsEquipped()) or (not v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (17 - 9))) or (v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (7 + 1))) or v89.BandolierOfTwistedBlades:IsEquipped() or v88.InvigoratingShadowdust:IsAvailable();
	end
	local function v129(v187, v188)
		local v189 = 0 + 0;
		local v190;
		local v191;
		local v192;
		local v193;
		local v194;
		local v195;
		local v196;
		while true do
			if (((2153 - 1446) > (79 + 553)) and (v189 == (2 - 0))) then
				v196 = v13:BuffUp(v88.PremeditationBuff) or (v188 and v88.Premeditation:IsAvailable());
				if ((v188 and (v188:ID() == v88.ShadowDance:ID())) or ((1790 - (485 + 759)) >= (6210 - 3526))) then
					local v236 = 1189 - (442 + 747);
					while true do
						if (((2600 - (832 + 303)) <= (5247 - (88 + 858))) and (v236 == (1 + 0))) then
							if (((1411 + 293) > (59 + 1366)) and v88.TheFirstDance:IsAvailable()) then
								v193 = v33(v13:ComboPointsMax(), v108 + (793 - (766 + 23)));
							end
							if (v13:HasTier(148 - 118, 2 - 0) or ((1809 - 1122) == (14370 - 10136))) then
								v192 = v34(v192, 1079 - (1036 + 37));
							end
							break;
						end
						if (((0 + 0) == v236) or ((6484 - 3154) < (1125 + 304))) then
							v190 = true;
							v191 = (1488 - (641 + 839)) + v88.ImprovedShadowDance:TalentRank();
							v236 = 914 - (910 + 3);
						end
					end
				end
				if (((2923 - 1776) >= (2019 - (1466 + 218))) and v188 and (v188:ID() == v88.Vanish:ID())) then
					v194 = v33(0 + 0, v88.ColdBlood:CooldownRemains() - ((1163 - (556 + 592)) * v88.InvigoratingShadowdust:TalentRank()));
					v195 = v33(0 + 0, v88.SymbolsofDeath:CooldownRemains() - ((823 - (329 + 479)) * v88.InvigoratingShadowdust:TalentRank()));
				end
				v189 = 857 - (174 + 680);
			end
			if (((11803 - 8368) > (4346 - 2249)) and (v189 == (1 + 0))) then
				v193 = v108;
				v194 = v88.ColdBlood:CooldownRemains();
				v195 = v88.SymbolsofDeath:CooldownRemains();
				v189 = 741 - (396 + 343);
			end
			if ((v189 == (1 + 3)) or ((5247 - (29 + 1448)) >= (5430 - (135 + 1254)))) then
				if ((v13:BuffUp(v88.FinalityRuptureBuff) and v190 and (v98 <= (14 - 10)) and not v127(v88.Rupture)) or ((17700 - 13909) <= (1074 + 537))) then
					if (v187 or ((6105 - (389 + 1138)) <= (2582 - (102 + 472)))) then
						return v88.Rupture;
					else
						local v246 = 0 + 0;
						while true do
							if (((624 + 501) <= (1936 + 140)) and (v246 == (1545 - (320 + 1225)))) then
								if ((v88.Rupture:IsReady() and v10.Press(v88.Rupture)) or ((1322 - 579) >= (2692 + 1707))) then
									return "Cast Rupture Finality";
								end
								v113(v88.Rupture);
								break;
							end
						end
					end
				end
				if (((2619 - (157 + 1307)) < (3532 - (821 + 1038))) and v88.ColdBlood:IsReady() and v125(v190, v196) and v88.SecretTechnique:IsReady()) then
					if (v65 or ((5798 - 3474) <= (64 + 514))) then
						v10.Press(v88.ColdBlood);
					else
						local v247 = 0 - 0;
						while true do
							if (((1402 + 2365) == (9336 - 5569)) and (v247 == (1026 - (834 + 192)))) then
								if (((260 + 3829) == (1050 + 3039)) and v187) then
									return v88.ColdBlood;
								end
								if (((96 + 4362) >= (2592 - 918)) and v10.Press(v88.ColdBlood)) then
									return "Cast Cold Blood (SecTec)";
								end
								break;
							end
						end
					end
				end
				if (((1276 - (300 + 4)) <= (379 + 1039)) and v88.SecretTechnique:IsReady()) then
					if ((v125(v190, v196) and (not v88.ColdBlood:IsAvailable() or (v65 and v88.ColdBlood:IsReady()) or v13:BuffUp(v88.ColdBlood) or (v194 > (v191 - (5 - 3))) or not v88.ImprovedShadowDance:IsAvailable())) or ((5300 - (112 + 250)) < (1899 + 2863))) then
						if (v187 or ((6272 - 3768) > (2443 + 1821))) then
							return v88.SecretTechnique;
						end
						if (((1114 + 1039) == (1611 + 542)) and v10.Press(v88.SecretTechnique)) then
							return "Cast Secret Technique";
						end
					end
				end
				v189 = 3 + 2;
			end
			if ((v189 == (4 + 1)) or ((1921 - (1001 + 413)) >= (5777 - 3186))) then
				if (((5363 - (244 + 638)) == (5174 - (627 + 66))) and not v122(v190) and v88.Rupture:IsCastable()) then
					local v237 = 0 - 0;
					while true do
						if ((v237 == (602 - (512 + 90))) or ((4234 - (1665 + 241)) < (1410 - (373 + 344)))) then
							if (((1953 + 2375) == (1146 + 3182)) and not v187 and v37 and not v111 and (v98 >= (5 - 3))) then
								local function v256(v259)
									return v86.CanDoTUnit(v259, v106) and v259:DebuffRefreshable(v88.Rupture, v105);
								end
								v116(v88.Rupture, v256, (2 - 0) * v193, v99);
							end
							if (((2687 - (35 + 1064)) >= (970 + 362)) and v94 and (v14:DebuffRemains(v88.Rupture) < (v88.SymbolsofDeath:CooldownRemains() + (21 - 11))) and (v108 > (0 + 0)) and (v88.SymbolsofDeath:CooldownRemains() <= (1241 - (298 + 938))) and v87.CanDoTUnit(v14, v106) and v14:FilteredTimeToDie(">", (1264 - (233 + 1026)) + v88.SymbolsofDeath:CooldownRemains(), -v14:DebuffRemains(v88.Rupture))) then
								if (v187 or ((5840 - (636 + 1030)) > (2172 + 2076))) then
									return v88.Rupture;
								else
									local v261 = 0 + 0;
									while true do
										if ((v261 == (0 + 0)) or ((310 + 4276) <= (303 - (55 + 166)))) then
											if (((749 + 3114) == (389 + 3474)) and v88.Rupture:IsReady() and v10.Cast(v88.Rupture)) then
												return "Cast Rupture 2";
											end
											v113(v88.Rupture);
											break;
										end
									end
								end
							end
							break;
						end
					end
				end
				if ((v88.BlackPowder:IsCastable() and not v111 and (v98 >= (11 - 8))) or ((579 - (36 + 261)) <= (73 - 31))) then
					if (((5977 - (34 + 1334)) >= (295 + 471)) and v187) then
						return v88.BlackPowder;
					else
						if ((v88.BlackPowder:IsReady() and v26(v88.BlackPowder)) or ((896 + 256) == (3771 - (1035 + 248)))) then
							return "Cast Black Powder";
						end
						v113(v88.BlackPowder);
					end
				end
				if (((3443 - (20 + 1)) > (1746 + 1604)) and v88.Eviscerate:IsCastable() and v94 and (v108 > (320 - (134 + 185)))) then
					if (((2010 - (549 + 584)) > (1061 - (314 + 371))) and v187) then
						return v88.Eviscerate;
					else
						if ((v88.Eviscerate:IsReady() and v26(v88.Eviscerate)) or ((10703 - 7585) <= (2819 - (478 + 490)))) then
							return "Cast Eviscerate";
						end
						v113(v88.Eviscerate);
					end
				end
				v189 = 4 + 2;
			end
			if ((v189 == (1172 - (786 + 386))) or ((534 - 369) >= (4871 - (1055 + 324)))) then
				v190 = v13:BuffUp(v88.ShadowDanceBuff);
				v191 = v13:BuffRemains(v88.ShadowDanceBuff);
				v192 = v13:BuffRemains(v88.SymbolsofDeath);
				v189 = 1341 - (1093 + 247);
			end
			if (((3510 + 439) < (511 + 4345)) and (v189 == (11 - 8))) then
				if ((v88.Rupture:IsCastable() and v88.Rupture:IsReady()) or ((14511 - 10235) < (8581 - 5565))) then
					if (((11785 - 7095) > (1468 + 2657)) and v14:DebuffDown(v88.Rupture) and (v14:TimeToDie() > (22 - 16))) then
						if (v187 or ((172 - 122) >= (676 + 220))) then
							return v88.Rupture;
						else
							local v254 = 0 - 0;
							while true do
								if ((v254 == (688 - (364 + 324))) or ((4698 - 2984) >= (7097 - 4139))) then
									if ((v88.Rupture:IsReady() and v10.Press(v88.Rupture)) or ((495 + 996) < (2694 - 2050))) then
										return "Cast Rupture";
									end
									v113(v88.Rupture);
									break;
								end
							end
						end
					end
				end
				if (((1126 - 422) < (2997 - 2010)) and not v13:StealthUp(true, true) and not v121() and (v98 < (1274 - (1249 + 19))) and not v190 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v88.SliceandDice)) and (v13:BuffRemains(v88.SliceandDice) < ((1 + 0 + v13:ComboPoints()) * (3.8 - 2)))) then
					if (((4804 - (686 + 400)) > (1496 + 410)) and v187) then
						return v88.SliceandDice;
					else
						local v248 = 229 - (73 + 156);
						while true do
							if ((v248 == (0 + 0)) or ((1769 - (721 + 90)) > (41 + 3594))) then
								if (((11367 - 7866) <= (4962 - (224 + 246))) and v88.SliceandDice:IsReady() and v10.Press(v88.SliceandDice)) then
									return "Cast Slice and Dice Premed";
								end
								v113(v88.SliceandDice);
								break;
							end
						end
					end
				end
				if (((not v122(v190) or v111) and (v14:TimeToDie() > (9 - 3)) and v14:DebuffRefreshable(v88.Rupture, v105)) or ((6337 - 2895) < (463 + 2085))) then
					if (((69 + 2806) >= (1076 + 388)) and v187) then
						return v88.Rupture;
					else
						if ((v88.Rupture:IsReady() and v10.Press(v88.Rupture)) or ((9536 - 4739) >= (16282 - 11389))) then
							return "Cast Rupture";
						end
						v113(v88.Rupture);
					end
				end
				v189 = 517 - (203 + 310);
			end
			if ((v189 == (1999 - (1238 + 755))) or ((39 + 512) > (3602 - (709 + 825)))) then
				return false;
			end
		end
	end
	local function v130(v197, v198)
		local v199 = v13:BuffUp(v88.ShadowDanceBuff);
		local v200 = v13:BuffRemains(v88.ShadowDanceBuff);
		local v201 = v13:BuffUp(v88.TheRottenBuff);
		local v202, v203 = v108, v109;
		local v204 = v13:BuffUp(v88.PremeditationBuff) or (v198 and v88.Premeditation:IsAvailable());
		local v205 = v13:BuffUp(v87.StealthSpell()) or (v198 and (v198:ID() == v87.StealthSpell():ID()));
		local v206 = v13:BuffUp(v87.VanishBuffSpell()) or (v198 and (v198:ID() == v88.Vanish:ID()));
		if (((3895 - 1781) > (1374 - 430)) and v198 and (v198:ID() == v88.ShadowDance:ID())) then
			v199 = true;
			v200 = (872 - (196 + 668)) + v88.ImprovedShadowDance:TalentRank();
			if ((v88.TheRotten:IsAvailable() and v13:HasTier(118 - 88, 3 - 1)) or ((3095 - (171 + 662)) >= (3189 - (4 + 89)))) then
				v201 = true;
			end
			if (v88.TheFirstDance:IsAvailable() or ((7903 - 5648) >= (1288 + 2249))) then
				v202 = v33(v13:ComboPointsMax(), v108 + (17 - 13));
				v203 = v13:ComboPointsMax() - v202;
			end
		end
		local v207 = v87.EffectiveComboPoints(v202);
		local v208 = v88.Shadowstrike:IsCastable() or v205 or v206 or v199 or v13:BuffUp(v88.SepsisBuff);
		if (v205 or v206 or ((1505 + 2332) < (2792 - (35 + 1451)))) then
			v208 = v208 and v14:IsInRange(1478 - (28 + 1425));
		else
			v208 = v208 and v94;
		end
		if (((4943 - (941 + 1052)) == (2829 + 121)) and v208 and v205 and ((v98 < (1518 - (822 + 692))) or v111)) then
			if (v197 or ((6742 - 2019) < (1554 + 1744))) then
				return v88.Shadowstrike;
			elseif (((1433 - (45 + 252)) >= (153 + 1)) and v26(v88.Shadowstrike)) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if ((v207 >= v87.CPMaxSpend()) or ((94 + 177) > (11555 - 6807))) then
			return v129(v197, v198);
		end
		if (((5173 - (114 + 319)) >= (4525 - 1373)) and v13:BuffUp(v88.ShurikenTornado) and (v203 <= (2 - 0))) then
			return v129(v197, v198);
		end
		if ((v109 <= (1 + 0 + v29(v88.DeeperStratagem:IsAvailable() or v88.SecretStratagem:IsAvailable()))) or ((3840 - 1262) >= (7102 - 3712))) then
			return v129(v197, v198);
		end
		if (((2004 - (556 + 1407)) <= (2867 - (741 + 465))) and v88.Backstab:IsCastable() and not v204 and (v200 >= (468 - (170 + 295))) and v13:BuffUp(v88.ShadowBlades) and not v127(v88.Backstab) and v88.DanseMacabre:IsAvailable() and (v98 <= (2 + 1)) and not v201) then
			if (((553 + 48) < (8764 - 5204)) and v197) then
				if (((195 + 40) < (441 + 246)) and v198) then
					return v88.Backstab;
				else
					return {v88.Backstab,v88.Stealth};
				end
			elseif (((1217 + 3332) > (462 + 691)) and v26(v88.Backstab, v88.Stealth)) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v88.Gloomblade:IsAvailable() or ((17809 - 13135) < (12311 - 7639))) then
			if (((11203 - 7535) < (22584 - 18023)) and not v204 and (v200 >= (1783 - (389 + 1391))) and v13:BuffUp(v88.ShadowBlades) and not v127(v88.Gloomblade) and v88.DanseMacabre:IsAvailable() and (v98 <= (3 + 1))) then
				if (v197 or ((48 + 407) == (8207 - 4602))) then
					if (v198 or ((3614 - (783 + 168)) == (11115 - 7803))) then
						return v88.Gloomblade;
					else
						return {v88.Gloomblade,v88.Stealth};
					end
				elseif (((13133 - 8856) <= (5687 - (1090 + 122))) and v27(v88.Gloomblade, v88.Stealth)) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if ((not v127(v88.Shadowstrike) and v13:BuffUp(v88.ShadowBlades)) or ((283 + 587) == (3993 - 2804))) then
			if (((1063 + 490) <= (4251 - (628 + 490))) and v197) then
				return v88.Shadowstrike;
			elseif (v26(v88.Shadowstrike) or ((402 + 1835) >= (8692 - 5181))) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v204 and (v98 >= (18 - 14))) or ((2098 - (431 + 343)) > (6099 - 3079))) then
			if (v197 or ((8655 - 5663) == (1487 + 394))) then
				return v88.ShurikenStorm;
			elseif (((398 + 2708) > (3221 - (556 + 1139))) and v26(v88.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
		end
		if (((3038 - (6 + 9)) < (709 + 3161)) and v208) then
			if (((74 + 69) > (243 - (28 + 141))) and v197) then
				return v88.Shadowstrike;
			elseif (((7 + 11) < (2606 - 494)) and v26(v88.Shadowstrike)) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v131(v209, v210)
		local v211 = 0 + 0;
		local v212;
		local v213;
		while true do
			if (((2414 - (486 + 831)) <= (4236 - 2608)) and (v211 == (0 - 0))) then
				v212 = v130(true, v209);
				if (((875 + 3755) == (14639 - 10009)) and (v209:ID() == v88.Vanish:ID())) then
					local v238 = 1263 - (668 + 595);
					while true do
						if (((3186 + 354) > (541 + 2142)) and (v238 == (0 - 0))) then
							if (((5084 - (23 + 267)) >= (5219 - (1129 + 815))) and v26(v88.Vanish, v62)) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((1871 - (371 + 16)) == (3234 - (1326 + 424))) and (v209:ID() == v88.Shadowmeld:ID())) then
					local v249 = 0 - 0;
					while true do
						if (((5232 - 3800) < (3673 - (88 + 30))) and (v249 == (771 - (720 + 51)))) then
							if (v26(v88.Shadowmeld, v39) or ((2369 - 1304) > (5354 - (421 + 1355)))) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif ((v209:ID() == v88.ShadowDance:ID()) or ((7910 - 3115) < (692 + 715))) then
					local v255 = 1083 - (286 + 797);
					while true do
						if (((6773 - 4920) < (7971 - 3158)) and (v255 == (439 - (397 + 42)))) then
							if (v26(v88.ShadowDance, v63) or ((882 + 1939) < (3231 - (24 + 776)))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v211 = 1 - 0;
			end
			if ((v211 == (787 - (222 + 563))) or ((6331 - 3457) < (1571 + 610))) then
				v101 = v27(unpack(v213));
				if (v101 or ((2879 - (23 + 167)) <= (2141 - (690 + 1108)))) then
					return "| " .. v213[1 + 1]:Name();
				end
				v211 = 3 + 0;
			end
			if ((v211 == (849 - (40 + 808))) or ((308 + 1561) == (7682 - 5673))) then
				v213 = {v209,v212};
				if ((v210 and (v13:EnergyPredicted() < v210)) or ((1945 + 1601) < (2893 - (47 + 524)))) then
					local v239 = 0 + 0;
					while true do
						if ((v239 == (0 - 0)) or ((3112 - 1030) == (10885 - 6112))) then
							v112(v213, v210);
							return false;
						end
					end
				end
				v211 = 1728 - (1165 + 561);
			end
			if (((97 + 3147) > (3267 - 2212)) and (v211 == (2 + 1))) then
				return false;
			end
		end
	end
	local function v132()
		v101 = v86.HandleTopTrinket(v91, v38, 519 - (341 + 138), nil);
		if (v101 or ((895 + 2418) <= (3668 - 1890))) then
			return v101;
		end
		v101 = v86.HandleBottomTrinket(v91, v38, 366 - (89 + 237), nil);
		if (v101 or ((4571 - 3150) >= (4429 - 2325))) then
			return v101;
		end
	end
	local function v133()
		if (((2693 - (581 + 300)) <= (4469 - (855 + 365))) and v10.CD and v88.ColdBlood:IsReady() and not v88.SecretTechnique:IsAvailable() and (v108 >= (11 - 6))) then
			if (((530 + 1093) <= (3192 - (1030 + 205))) and v26(v88.ColdBlood, v65)) then
				return "Cast Cold Blood";
			end
		end
		if (((4142 + 270) == (4105 + 307)) and v10.CD and v88.Sepsis:IsAvailable() and v88.Sepsis:IsReady()) then
			if (((2036 - (156 + 130)) >= (1913 - 1071)) and v120() and v14:FilteredTimeToDie(">=", 26 - 10) and (v13:BuffUp(v88.PerforatedVeins) or not v88.PerforatedVeins:IsAvailable())) then
				if (((8953 - 4581) > (488 + 1362)) and v26(v88.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((136 + 96) < (890 - (10 + 59))) and v38 and v88.Flagellation:IsAvailable() and v88.Flagellation:IsReady()) then
			if (((147 + 371) < (4442 - 3540)) and v120() and (v107 >= (1168 - (671 + 492))) and (v14:TimeToDie() > (8 + 2)) and ((v128() and (v88.ShadowBlades:CooldownRemains() <= (1218 - (369 + 846)))) or v10.BossFilteredFightRemains("<=", 8 + 20) or ((v88.ShadowBlades:CooldownRemains() >= (12 + 2)) and v88.InvigoratingShadowdust:IsAvailable() and v88.ShadowDance:IsAvailable())) and (not v88.InvigoratingShadowdust:IsAvailable() or v88.Sepsis:IsAvailable() or not v88.ShadowDance:IsAvailable() or ((v88.InvigoratingShadowdust:TalentRank() == (1947 - (1036 + 909))) and (v98 >= (2 + 0))) or (v88.SymbolsofDeath:CooldownRemains() <= (4 - 1)) or (v13:BuffRemains(v88.SymbolsofDeath) > (206 - (11 + 192))))) then
				if (((1514 + 1480) > (1033 - (135 + 40))) and v26(v88.Flagellation)) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v38 and v88.SymbolsofDeath:IsReady()) or ((9097 - 5342) <= (552 + 363))) then
			if (((8692 - 4746) > (5610 - 1867)) and v120() and (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(206 - (50 + 126), 5 - 3)) and (v13:BuffRemains(v88.SymbolsofDeath) <= (1 + 2)) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (1423 - (1233 + 180))) or ((v13:BuffRemains(v88.ShadowDance) >= (971 - (522 + 447))) and v88.InvigoratingShadowdust:IsAvailable()) or (v88.Flagellation:IsReady() and (v107 >= (1426 - (107 + 1314))) and not v88.InvigoratingShadowdust:IsAvailable()))) then
				if (v26(v88.SymbolsofDeath) or ((620 + 715) >= (10073 - 6767))) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((2058 + 2786) > (4473 - 2220)) and v10.CD and v88.ShadowBlades:IsReady()) then
			if (((1788 - 1336) == (2362 - (716 + 1194))) and v120() and ((v107 <= (1 + 0)) or v13:HasTier(4 + 27, 507 - (74 + 429))) and (v13:BuffUp(v88.Flagellation) or v13:BuffUp(v88.FlagellationPersistBuff) or not v88.Flagellation:IsAvailable())) then
				if (v26(v88.ShadowBlades) or ((8790 - 4233) < (1035 + 1052))) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((8867 - 4993) == (2741 + 1133)) and v10.CD and v88.EchoingReprimand:IsCastable() and v88.EchoingReprimand:IsAvailable()) then
			if ((v120() and (v109 >= (8 - 5))) or ((4791 - 2853) > (5368 - (279 + 154)))) then
				if (v26(v88.EchoingReprimand) or ((5033 - (454 + 324)) < (2694 + 729))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if (((1471 - (12 + 5)) <= (1344 + 1147)) and v10.CD and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) then
			if ((v120() and v13:BuffUp(v88.SymbolsofDeath) and (v107 <= (4 - 2)) and not v13:BuffUp(v88.Premeditation) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (8 + 12))) and (v98 >= (1096 - (277 + 816)))) or ((17763 - 13606) <= (3986 - (1058 + 125)))) then
				if (((910 + 3943) >= (3957 - (815 + 160))) and v26(v88.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((17737 - 13603) > (7968 - 4611)) and v10.CD and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) then
			if ((v120() and not v13:BuffUp(v88.ShadowDance) and not v13:BuffUp(v88.Flagellation) and not v13:BuffUp(v88.FlagellationPersistBuff) and not v13:BuffUp(v88.ShadowBlades) and (v98 <= (1 + 1))) or ((9988 - 6571) < (4432 - (41 + 1857)))) then
				if (v26(v88.ShurikenTornado) or ((4615 - (1222 + 671)) <= (423 - 259))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v10.CD and v88.ShadowDance:IsAvailable() and v114() and v88.ShadowDance:IsReady()) or ((3460 - 1052) < (3291 - (229 + 953)))) then
			if ((not v13:BuffUp(v88.ShadowDance) and HL.BossFilteredFightRemains("<=", (1782 - (1111 + 663)) + ((1582 - (874 + 705)) * v29(v88.Subterfuge:IsAvailable())))) or ((5 + 28) == (993 + 462))) then
				if (v26(v88.ShadowDance) or ((920 - 477) >= (113 + 3902))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if (((4061 - (642 + 37)) > (38 + 128)) and v10.CD and v88.GoremawsBite:IsAvailable() and v88.GoremawsBite:IsReady()) then
			if ((v120() and (v109 >= (1 + 2)) and (not v88.ShadowDance:IsReady() or (v88.ShadowDance:IsAvailable() and v13:BuffUp(v88.ShadowDance) and not v88.InvigoratingShadowdust:IsAvailable()) or ((v98 < (9 - 5)) and not v88.InvigoratingShadowdust:IsAvailable()) or v88.TheRotten:IsAvailable())) or ((734 - (233 + 221)) == (7073 - 4014))) then
				if (((1656 + 225) > (2834 - (718 + 823))) and v26(v88.GoremawsBite)) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((1484 + 873) == (3162 - (266 + 539))) and v88.ThistleTea:IsReady()) then
			if (((347 - 224) == (1348 - (636 + 589))) and ((((v88.SymbolsofDeath:CooldownRemains() >= (6 - 3)) or v13:BuffUp(v88.SymbolsofDeath)) and not v13:BuffUp(v88.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (206 - 106)) and ((v109 >= (2 + 0)) or (v98 >= (2 + 1)))) or ((v88.ThistleTea:ChargesFractional() >= ((1017.75 - (657 + 358)) - ((0.15 - 0) * v88.InvigoratingShadowdust:TalentRank()))) and v88.Vanish:IsReady() and v13:BuffUp(v88.ShadowDance) and v14:DebuffUp(v88.Rupture) and (v98 < (6 - 3))))) or ((v13:BuffRemains(v88.ShadowDance) >= (1191 - (1151 + 36))) and not v13:BuffUp(v88.ThistleTea) and (v98 >= (3 + 0))) or (not v13:BuffUp(v88.ThistleTea) and HL.BossFilteredFightRemains("<=", (2 + 4) * v88.ThistleTea:Charges())))) then
				if (v26(v88.ThistleTea) or ((3153 - 2097) >= (5224 - (1552 + 280)))) then
					return "Thistle Tea";
				end
			end
		end
		local v214 = v13:BuffUp(v88.ShadowBlades) or (not v88.ShadowBlades:IsAvailable() and v13:BuffUp(v88.SymbolsofDeath)) or HL.BossFilteredFightRemains("<", 854 - (64 + 770));
		if ((v88.BloodFury:IsCastable() and v214) or ((734 + 347) < (2440 - 1365))) then
			if (v26(v88.BloodFury, v61) or ((187 + 862) >= (5675 - (157 + 1086)))) then
				return "Cast Blood Fury";
			end
		end
		if (v88.Berserking:IsCastable() or ((9543 - 4775) <= (3705 - 2859))) then
			if (v10.Cast(v88.Berserking, v61) or ((5150 - 1792) <= (1938 - 518))) then
				return "Cast Berserking";
			end
		end
		if (v88.Fireblood:IsCastable() or ((4558 - (599 + 220)) <= (5983 - 2978))) then
			if (v10.Cast(v88.Fireblood, v61) or ((3590 - (1813 + 118)) >= (1560 + 574))) then
				return "Cast Fireblood";
			end
		end
		if (v88.AncestralCall:IsCastable() or ((4477 - (841 + 376)) < (3299 - 944))) then
			if (v10.Cast(v88.AncestralCall, v61) or ((156 + 513) == (11526 - 7303))) then
				return "Cast Ancestral Call";
			end
		end
		if ((v53 and v38) or ((2551 - (464 + 395)) < (1508 - 920))) then
			v101 = v132();
			if (v101 or ((2304 + 2493) < (4488 - (467 + 370)))) then
				return v101;
			end
		end
		return false;
	end
	local function v134(v215)
		local v216 = 0 - 0;
		while true do
			if ((v216 == (0 + 0)) or ((14318 - 10141) > (757 + 4093))) then
				if ((v10.CD and not (v86.IsSoloMode() and v13:IsTanking(v14))) or ((930 - 530) > (1631 - (150 + 370)))) then
					local v240 = 1282 - (74 + 1208);
					while true do
						if (((7504 - 4453) > (4766 - 3761)) and ((0 + 0) == v240)) then
							if (((4083 - (14 + 376)) <= (7600 - 3218)) and v88.Vanish:IsCastable()) then
								if ((((v109 > (1 + 0)) or (v13:BuffUp(v88.ShadowBlades) and v88.InvigoratingShadowdust:IsAvailable())) and not v118() and ((v88.Flagellation:CooldownRemains() >= (53 + 7)) or not v88.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (29 + 1) * v88.Vanish:Charges())) and ((v88.SymbolsofDeath:CooldownRemains() > (8 - 5)) or not v13:HasTier(23 + 7, 80 - (23 + 55))) and ((v88.SecretTechnique:CooldownRemains() >= (23 - 13)) or not v88.SecretTechnique:IsAvailable() or ((v88.Vanish:Charges() >= (2 + 0)) and v88.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v88.TheRotten) or not v88.TheRotten:IsAvailable())))) or ((2948 + 334) > (6357 - 2257))) then
									v101 = v131(v88.Vanish, v215);
									if (v101 or ((1127 + 2453) < (3745 - (652 + 249)))) then
										return "Vanish Macro " .. v101;
									end
								end
							end
							if (((238 - 149) < (6358 - (708 + 1160))) and (v13:Energy() < (108 - 68)) and v88.Shadowmeld:IsCastable()) then
								if (v26(v88.Shadowmeld, v13:EnergyTimeToX(72 - 32)) or ((5010 - (10 + 17)) < (407 + 1401))) then
									return "Pool for Shadowmeld";
								end
							end
							v240 = 1733 - (1400 + 332);
						end
						if (((7343 - 3514) > (5677 - (242 + 1666))) and (v240 == (1 + 0))) then
							if (((545 + 940) <= (2475 + 429)) and v88.Shadowmeld:IsCastable() and v94 and not v13:IsMoving() and (v13:EnergyPredicted() >= (980 - (850 + 90))) and (v13:EnergyDeficitPredicted() >= (17 - 7)) and not v118() and (v109 > (1394 - (360 + 1030)))) then
								local v257 = 0 + 0;
								while true do
									if (((12048 - 7779) == (5872 - 1603)) and ((1661 - (909 + 752)) == v257)) then
										v101 = v131(v88.Shadowmeld, v215);
										if (((1610 - (109 + 1114)) <= (5092 - 2310)) and v101) then
											return "Shadowmeld Macro " .. v101;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if ((v94 and v88.ShadowDance:IsCastable()) or ((740 + 1159) <= (1159 - (6 + 236)))) then
					if (((v14:DebuffUp(v88.Rupture) or v88.InvigoratingShadowdust:IsAvailable()) and v126() and (not v88.TheFirstDance:IsAvailable() or (v109 >= (3 + 1)) or v13:BuffUp(v88.ShadowBlades)) and ((v119() and v118()) or ((v13:BuffUp(v88.ShadowBlades) or (v13:BuffUp(v88.SymbolsofDeath) and not v88.Sepsis:IsAvailable()) or ((v13:BuffRemains(v88.SymbolsofDeath) >= (4 + 0)) and not v13:HasTier(70 - 40, 3 - 1)) or (not v13:BuffUp(v88.SymbolsofDeath) and v13:HasTier(1163 - (1076 + 57), 1 + 1))) and (v88.SecretTechnique:CooldownRemains() < ((699 - (579 + 110)) + ((1 + 11) * v29(not v88.InvigoratingShadowdust:IsAvailable() or v13:HasTier(27 + 3, 2 + 0)))))))) or ((4719 - (174 + 233)) <= (2446 - 1570))) then
						local v250 = 0 - 0;
						while true do
							if (((993 + 1239) <= (3770 - (663 + 511))) and ((0 + 0) == v250)) then
								v101 = v131(v88.ShadowDance, v215);
								if (((455 + 1640) < (11363 - 7677)) and v101) then
									return "ShadowDance Macro 1 " .. v101;
								end
								break;
							end
						end
					end
				end
				v216 = 1 + 0;
			end
			if ((v216 == (2 - 1)) or ((3861 - 2266) >= (2135 + 2339))) then
				return false;
			end
		end
	end
	local function v135(v217)
		local v218 = 0 - 0;
		local v219;
		while true do
			if ((v218 == (0 + 0)) or ((423 + 4196) < (3604 - (478 + 244)))) then
				v219 = not v217 or (v13:EnergyPredicted() >= v217);
				if ((v37 and v88.ShurikenStorm:IsCastable() and (v98 >= ((519 - (440 + 77)) + v21((v88.Gloomblade:IsAvailable() and (v13:BuffRemains(v88.LingeringShadowBuff) >= (3 + 3))) or v13:BuffUp(v88.PerforatedVeinsBuff))))) or ((1075 - 781) >= (6387 - (655 + 901)))) then
					local v241 = 0 + 0;
					while true do
						if (((1554 + 475) <= (2083 + 1001)) and (v241 == (0 - 0))) then
							if ((v219 and v10.Cast(v88.ShurikenStorm)) or ((3482 - (695 + 750)) == (8263 - 5843))) then
								return "Cast Shuriken Storm";
							end
							v112(v88.ShurikenStorm, v217);
							break;
						end
					end
				end
				v218 = 1 - 0;
			end
			if (((17928 - 13470) > (4255 - (285 + 66))) and (v218 == (2 - 1))) then
				if (((1746 - (682 + 628)) >= (20 + 103)) and v94) then
					if (((799 - (176 + 123)) < (760 + 1056)) and v88.Gloomblade:IsCastable()) then
						local v251 = 0 + 0;
						while true do
							if (((3843 - (239 + 30)) == (972 + 2602)) and (v251 == (0 + 0))) then
								if (((390 - 169) < (1216 - 826)) and v219 and v26(v88.Gloomblade)) then
									return "Cast Gloomblade";
								end
								v112(v88.Gloomblade, v217);
								break;
							end
						end
					elseif (v88.Backstab:IsCastable() or ((2528 - (306 + 9)) <= (4958 - 3537))) then
						if (((532 + 2526) < (2982 + 1878)) and v219 and v26(v88.Backstab)) then
							return "Cast Backstab";
						end
						v112(v88.Backstab, v217);
					end
				end
				return false;
			end
		end
	end
	local function v136()
		v85();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		ToggleMain = EpicSettings.Toggles['toggle'];
		v102 = nil;
		v104 = nil;
		v103 = 0 + 0;
		v92 = (v88.AcrobaticStrikes:IsAvailable() and (22 - 14)) or (1380 - (1140 + 235));
		v93 = (v88.AcrobaticStrikes:IsAvailable() and (9 + 4)) or (10 + 0);
		v94 = v14:IsInMeleeRange(v92);
		v95 = v14:IsInMeleeRange(v93);
		if (v37 or ((333 + 963) >= (4498 - (33 + 19)))) then
			local v227 = 0 + 0;
			while true do
				if ((v227 == (2 - 1)) or ((614 + 779) > (8802 - 4313))) then
					v98 = #v97;
					v99 = v13:GetEnemiesInMeleeRange(v92);
					break;
				end
				if ((v227 == (0 + 0)) or ((5113 - (586 + 103)) < (3 + 24))) then
					v96 = v13:GetEnemiesInRange(92 - 62);
					v97 = v13:GetEnemiesInMeleeRange(v93);
					v227 = 1489 - (1309 + 179);
				end
			end
		else
			v96 = {};
			v97 = {};
			v98 = 1 - 0;
			v99 = {};
		end
		v108 = v13:ComboPoints();
		v107 = v87.EffectiveComboPoints(v108);
		v109 = v13:ComboPointsDeficit();
		v111 = v115();
		v110 = v13:EnergyMax() - v117();
		if (((v107 > v108) and (v109 > (1 + 1)) and v13:AffectingCombat()) or ((5363 - 3366) > (2882 + 933))) then
			if (((7362 - 3897) > (3811 - 1898)) and (((v108 == (611 - (295 + 314))) and not v13:BuffUp(v88.EchoingReprimand3)) or ((v108 == (6 - 3)) and not v13:BuffUp(v88.EchoingReprimand4)) or ((v108 == (1966 - (1300 + 662))) and not v13:BuffUp(v88.EchoingReprimand5)))) then
				local v231 = v87.TimeToSht(12 - 8);
				if (((2488 - (1178 + 577)) < (945 + 874)) and (v231 == (0 - 0))) then
					v231 = v87.TimeToSht(1410 - (851 + 554));
				end
				if ((v231 < (v34(v13:EnergyTimeToX(31 + 4), v13:GCDRemains()) + (0.5 - 0))) or ((9545 - 5150) == (5057 - (115 + 187)))) then
					v107 = v108;
				end
			end
		end
		if ((v13:BuffUp(v88.ShurikenTornado, nil, true) and (v108 < v87.CPMaxSpend())) or ((2905 + 888) < (2243 + 126))) then
			local v228 = v87.TimeToNextTornado();
			if ((v228 <= v13:GCDRemains()) or (v35(v13:GCDRemains() - v228) < (0.25 - 0)) or ((5245 - (160 + 1001)) == (232 + 33))) then
				local v232 = 0 + 0;
				local v233;
				while true do
					if (((8921 - 4563) == (4716 - (237 + 121))) and (v232 == (898 - (525 + 372)))) then
						v109 = v34(v109 - v233, 0 - 0);
						if ((v107 < v87.CPMaxSpend()) or ((10310 - 7172) < (1135 - (96 + 46)))) then
							v107 = v108;
						end
						break;
					end
					if (((4107 - (643 + 134)) > (839 + 1484)) and (v232 == (0 - 0))) then
						v233 = v98 + v29(v13:BuffUp(v88.ShadowBlades));
						v108 = v33(v108 + v233, v87.CPMaxSpend());
						v232 = 3 - 2;
					end
				end
			end
		end
		v105 = (4 + 0 + (v107 * (7 - 3))) * (0.3 - 0);
		v106 = v88.Eviscerate:Damage() * v74;
		if ((v89.Healthstone:IsReady() and (v13:HealthPercentage() < v44) and not (v13:IsChanneling() or v13:IsCasting())) or ((4345 - (316 + 403)) == (2652 + 1337))) then
			if (v10.Cast(v90.Healthstone) or ((2518 - 1602) == (966 + 1705))) then
				return "Healthstone ";
			end
		end
		if (((684 - 412) == (193 + 79)) and v89.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) then
			if (((1370 + 2879) <= (16766 - 11927)) and v10.Cast(v90.RefreshingHealingPotion)) then
				return "RefreshingHealingPotion ";
			end
		end
		v101 = v87.CrimsonVial();
		if (((13262 - 10485) < (6647 - 3447)) and v101) then
			return v101;
		end
		v87.Poisons();
		if (((6 + 89) < (3852 - 1895)) and not v13:AffectingCombat()) then
			local v229 = 0 + 0;
			while true do
				if (((2430 - 1604) < (1734 - (12 + 5))) and (v229 == (3 - 2))) then
					if (((3041 - 1615) >= (2348 - 1243)) and v86.TargetIsValid()) then
						if (((6829 - 4075) <= (686 + 2693)) and v15:Exists() and v88.TricksoftheTrade:IsReady()) then
							if (v26(v90.TricksoftheTradeFocus) or ((5900 - (1656 + 317)) == (1260 + 153))) then
								return "precombat tricks_of_the_trade";
							end
						end
					end
					break;
				end
				if ((v229 == (0 + 0)) or ((3068 - 1914) <= (3878 - 3090))) then
					v101 = v87.Poisons();
					if (v101 or ((1997 - (5 + 349)) > (16049 - 12670))) then
						return v101;
					end
					v229 = 1272 - (266 + 1005);
				end
			end
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v86.TargetIsValid()) or ((1848 + 955) > (15521 - 10972))) then
			v101 = v87.Stealth(v88.Stealth2, nil);
			if (v101 or ((289 - 69) >= (4718 - (561 + 1135)))) then
				return "Stealth (OOC): " .. v101;
			end
		end
		if (((3676 - 854) == (9276 - 6454)) and not v13:IsChanneling() and ToggleMain) then
			if ((not v13:AffectingCombat() and v14:AffectingCombat() and (v88.Vanish:TimeSinceLastCast() > (1067 - (507 + 559)))) or ((2662 - 1601) == (5743 - 3886))) then
				local v234 = 388 - (212 + 176);
				while true do
					if (((3665 - (250 + 655)) > (3719 - 2355)) and (v234 == (0 - 0))) then
						if ((v86.TargetIsValid() and (v14:IsSpellInRange(v88.Shadowstrike) or v94)) or ((7669 - 2767) <= (5551 - (1869 + 87)))) then
							if (v13:StealthUp(true, true) or ((13360 - 9508) == (2194 - (484 + 1417)))) then
								local v260 = 0 - 0;
								while true do
									if ((v260 == (0 - 0)) or ((2332 - (48 + 725)) == (7494 - 2906))) then
										v102 = v130(true);
										if (v102 or ((12030 - 7546) == (458 + 330))) then
											if (((12207 - 7639) >= (1094 + 2813)) and (type(v102) == "table") and (#v102 > (1 + 0))) then
												if (((2099 - (152 + 701)) < (4781 - (430 + 881))) and v26(nil, unpack(v102))) then
													return "Stealthed Macro Cast or Pool (OOC): " .. v102[1 + 0]:Name();
												end
											elseif (((4963 - (557 + 338)) >= (288 + 684)) and v26(v102)) then
												return "Stealthed Cast or Pool (OOC): " .. v102:Name();
											end
										end
										break;
									end
								end
							elseif (((1388 - 895) < (13632 - 9739)) and (v108 >= (13 - 8))) then
								local v262 = 0 - 0;
								while true do
									if ((v262 == (801 - (499 + 302))) or ((2339 - (39 + 827)) >= (9197 - 5865))) then
										v101 = v129();
										if (v101 or ((9047 - 4996) <= (4595 - 3438))) then
											return v101 .. " (OOC)";
										end
										break;
									end
								end
							end
						end
						return;
					end
				end
			end
			if (((927 - 323) < (247 + 2634)) and v86.TargetIsValid() and (v36 or v13:AffectingCombat())) then
				if ((v84 and v88.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v86.UnitHasEnrageBuff(v14)) or ((2634 - 1734) == (541 + 2836))) then
					if (((7055 - 2596) > (695 - (103 + 1))) and v26(v88.Shiv, not v94)) then
						return "dispel";
					end
				end
				if (((3952 - (475 + 79)) >= (5177 - 2782)) and (v10.CombatTime() < (32 - 22)) and (v10.CombatTime() > (0 + 0)) and v88.ShadowDance:CooldownUp() and (v88.Vanish:TimeSinceLastCast() > (10 + 1))) then
					local v242 = 1503 - (1395 + 108);
					while true do
						if ((v242 == (8 - 5)) or ((3387 - (7 + 1197)) >= (1232 + 1592))) then
							if (((676 + 1260) == (2255 - (27 + 292))) and v88.ShadowDance:IsCastable() and v38 and v10.Cast(v90.ShadowDance, true)) then
								return "Opener ShadowDance";
							end
							break;
						end
						if ((v242 == (2 - 1)) or ((6161 - 1329) < (18087 - 13774))) then
							if (((8061 - 3973) > (7377 - 3503)) and v88.ShadowBlades:IsCastable() and v13:BuffDown(v88.ShadowBlades)) then
								if (((4471 - (43 + 96)) == (17670 - 13338)) and v10.Cast(v88.ShadowBlades, true)) then
									return "Opener ShadowBlades";
								end
							end
							if (((9040 - 5041) >= (2407 + 493)) and v88.ShurikenStorm:IsCastable() and (v98 >= (1 + 1))) then
								if (v10.Cast(v88.ShurikenStorm) or ((4990 - 2465) > (1558 + 2506))) then
									return "Opener Shuriken Tornado";
								end
							end
							v242 = 3 - 1;
						end
						if (((1377 + 2994) == (321 + 4050)) and (v242 == (1751 - (1414 + 337)))) then
							if (v13:StealthUp(true, true) or ((2206 - (1642 + 298)) > (12997 - 8011))) then
								if (((5727 - 3736) >= (2744 - 1819)) and v10.Cast(v88.Shadowstrike)) then
									return "Opener SS";
								end
							end
							if (((150 + 305) < (1598 + 455)) and v88.SymbolsofDeath:IsCastable() and v13:BuffDown(v88.SymbolsofDeath)) then
								if (v10.Cast(v88.SymbolsofDeath, true) or ((1798 - (357 + 615)) == (3406 + 1445))) then
									return "Opener SymbolsofDeath";
								end
							end
							v242 = 2 - 1;
						end
						if (((157 + 26) == (391 - 208)) and (v242 == (2 + 0))) then
							if (((79 + 1080) <= (1124 + 664)) and (v88.Gloomblade:TimeSinceLastCast() > (1304 - (384 + 917))) and (v98 <= (698 - (128 + 569)))) then
								if (v10.Cast(v88.Gloomblade) or ((5050 - (1407 + 136)) > (6205 - (687 + 1200)))) then
									return "Opener Gloomblade";
								end
							end
							if ((v14:DebuffDown(v88.Rupture) and (v98 <= (1711 - (556 + 1154))) and (v108 > (0 - 0))) or ((3170 - (9 + 86)) <= (3386 - (275 + 146)))) then
								if (((222 + 1143) <= (2075 - (29 + 35))) and v10.Cast(v88.Rupture)) then
									return "Opener Rupture";
								end
							end
							v242 = 13 - 10;
						end
					end
				end
				v101 = v133();
				if (v101 or ((8291 - 5515) > (15781 - 12206))) then
					return "CDs: " .. v101;
				end
				if ((v88.SliceandDice:IsCastable() and (v98 < v87.CPMaxSpend()) and (v13:BuffRemains(v88.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 4 + 2) and (v108 >= (1016 - (53 + 959)))) or ((2962 - (312 + 96)) == (8337 - 3533))) then
					if (((2862 - (147 + 138)) == (3476 - (813 + 86))) and v88.SliceandDice:IsReady() and v26(v88.SliceandDice)) then
						return "Cast Slice and Dice (Low Duration)";
					end
					v113(v88.SliceandDice);
				end
				if (v13:StealthUp(true, true) or ((6 + 0) >= (3499 - 1610))) then
					local v243 = 492 - (18 + 474);
					while true do
						if (((171 + 335) <= (6175 - 4283)) and (v243 == (1086 - (860 + 226)))) then
							v102 = v130(true);
							if (v102 or ((2311 - (121 + 182)) > (274 + 1944))) then
								if (((1619 - (988 + 252)) <= (469 + 3678)) and (type(v102) == "table") and (#v102 > (1 + 0))) then
									if (v28(nil, unpack(v102)) or ((6484 - (49 + 1921)) <= (1899 - (223 + 667)))) then
										return "Stealthed Macro " .. v102[53 - (51 + 1)]:Name() .. "|" .. v102[2 - 0]:Name();
									end
								elseif ((v13:BuffUp(v88.ShurikenTornado) and (v108 ~= v13:ComboPoints()) and ((v102 == v88.BlackPowder) or (v102 == v88.Eviscerate) or (v102 == v88.Rupture) or (v102 == v88.SliceandDice))) or ((7486 - 3990) == (2317 - (146 + 979)))) then
									if (v28(nil, v88.ShurikenTornado, v102) or ((59 + 149) == (3564 - (311 + 294)))) then
										return "Stealthed Tornado Cast  " .. v102:Name();
									end
								elseif (((11927 - 7650) >= (557 + 756)) and v26(v102)) then
									return "Stealthed Cast " .. v102:Name();
								end
							end
							v243 = 1444 - (496 + 947);
						end
						if (((3945 - (1233 + 125)) < (1288 + 1886)) and (v243 == (1 + 0))) then
							v26(v88.PoolEnergy);
							return "Stealthed Pooling";
						end
					end
				end
				local v235;
				if (not v88.Vigor:IsAvailable() or v88.Shadowcraft:IsAvailable() or ((783 + 3337) <= (3843 - (963 + 682)))) then
					v235 = v13:EnergyDeficitPredicted() <= v117();
				else
					v235 = v13:EnergyPredicted() >= v117();
				end
				if (v235 or v88.InvigoratingShadowdust:IsAvailable() or ((1332 + 264) == (2362 - (504 + 1000)))) then
					v101 = v134(v110);
					if (((2169 + 1051) == (2933 + 287)) and v101) then
						return "Stealth CDs: " .. v101;
					end
				end
				if ((v107 >= v87.CPMaxSpend()) or ((133 + 1269) > (5338 - 1718))) then
					local v244 = 0 + 0;
					while true do
						if (((1497 + 1077) == (2756 - (156 + 26))) and (v244 == (0 + 0))) then
							v101 = v129();
							if (((2812 - 1014) < (2921 - (149 + 15))) and v101) then
								return "Finish: " .. v101;
							end
							break;
						end
					end
				end
				if ((v109 <= (961 - (890 + 70))) or (HL.BossFilteredFightRemains("<=", 118 - (39 + 78)) and (v107 >= (485 - (14 + 468)))) or ((828 - 451) > (7278 - 4674))) then
					v101 = v129();
					if (((294 + 274) < (548 + 363)) and v101) then
						return "Finish: " .. v101;
					end
				end
				if (((698 + 2587) < (1910 + 2318)) and (v98 >= (2 + 2)) and (v107 >= (7 - 3))) then
					v101 = v129();
					if (((3871 + 45) > (11694 - 8366)) and v101) then
						return "Finish: " .. v101;
					end
				end
				v101 = v135(v110);
				if (((64 + 2436) < (3890 - (12 + 39))) and v101) then
					return "Build: " .. v101;
				end
				if (((472 + 35) == (1569 - 1062)) and v10.CD) then
					local v245 = 0 - 0;
					while true do
						if (((72 + 168) <= (1666 + 1499)) and (v245 == (2 - 1))) then
							if (((556 + 278) >= (3890 - 3085)) and v88.LightsJudgment:IsReady()) then
								if (v26(v88.LightsJudgment, v39) or ((5522 - (1596 + 114)) < (6046 - 3730))) then
									return "Cast Lights Judgment";
								end
							end
							if (v88.BagofTricks:IsReady() or ((3365 - (164 + 549)) <= (2971 - (1059 + 379)))) then
								if (v26(v88.BagofTricks, v39) or ((4467 - 869) < (757 + 703))) then
									return "Cast Bag of Tricks";
								end
							end
							break;
						end
						if ((v245 == (0 + 0)) or ((4508 - (145 + 247)) < (979 + 213))) then
							if ((v88.ArcaneTorrent:IsReady() and v94 and (v13:EnergyDeficitPredicted() >= (7 + 8 + v13:EnergyRegen()))) or ((10011 - 6634) <= (174 + 729))) then
								if (((3425 + 551) >= (712 - 273)) and v26(v88.ArcaneTorrent, v39)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((4472 - (254 + 466)) == (4312 - (544 + 16))) and v88.ArcanePulse:IsReady() and v94) then
								if (((12858 - 8812) > (3323 - (294 + 334))) and v26(v88.ArcanePulse, v39)) then
									return "Cast Arcane Pulse";
								end
							end
							v245 = 254 - (236 + 17);
						end
					end
				end
				if (v104 or ((1529 + 2016) == (2489 + 708))) then
					v112(v104);
				end
				if (((9016 - 6622) > (1765 - 1392)) and v102 and v94) then
					if (((2140 + 2015) <= (3486 + 746)) and (type(v102) == "table") and (#v102 > (795 - (413 + 381)))) then
						if (v28(v13:EnergyTimeToX(v103), unpack(v102)) or ((151 + 3430) == (7385 - 3912))) then
							return "Macro pool towards " .. v102[2 - 1]:Name() .. " at " .. v103;
						end
					elseif (((6965 - (582 + 1388)) > (5704 - 2356)) and v102:IsCastable()) then
						local v258 = 0 + 0;
						while true do
							if ((v258 == (364 - (326 + 38))) or ((2230 - 1476) > (5315 - 1591))) then
								v103 = v34(v103, v102:Cost());
								if (((837 - (47 + 573)) >= (21 + 36)) and v26(v102, v13:EnergyTimeToX(v103))) then
									return "Pool towards: " .. v102:Name() .. " at " .. v103;
								end
								break;
							end
						end
					end
				end
			end
			if ((v88.ShurikenToss:IsCastable() and v14:IsInRange(127 - 97) and not v95 and not v13:StealthUp(true, true) and not v13:BuffUp(v88.Sprint) and (v13:EnergyDeficitPredicted() < (32 - 12)) and ((v109 >= (1665 - (1269 + 395))) or (v13:EnergyTimeToMax() <= (493.2 - (76 + 416))))) or ((2513 - (319 + 124)) >= (9228 - 5191))) then
				if (((3712 - (564 + 443)) == (7488 - 4783)) and v26(v88.ShurikenToss)) then
					return "Cast Shuriken Toss";
				end
			end
		end
	end
	local function v137()
		v10.Print("Subtlety Rogue rotation has NOT been updated for patch 10.2.0. It is unlikely to work properly at this time.");
	end
	v10.SetAPL(719 - (337 + 121), v136, v137);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

