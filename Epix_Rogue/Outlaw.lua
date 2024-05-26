local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1873 - (326 + 445)) < (4019 - 3098))) then
			return v6(...);
		end
		if (((10483 - 5777) >= (2247 - 1284)) and (v5 == (711 - (530 + 181)))) then
			v6 = v0[v4];
			if (not v6 or ((1841 - (614 + 267)) <= (908 - (19 + 13)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Cast;
	local v13 = v10.Mouseover;
	local v14 = v10.Utils;
	local v15 = v10.Unit;
	local v16 = v15.Player;
	local v17 = v15.Target;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Macro;
	local v22 = v10.Commons.Everyone.num;
	local v23 = v10.Commons.Everyone.bool;
	local v24 = math.min;
	local v25 = math.abs;
	local v26 = math.max;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
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
	local function v82()
		local v128 = 0 - 0;
		while true do
			if (((8 - 5) == v128) or ((537 + 1529) == (1638 - 706))) then
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 7 - 3;
			end
			if (((6637 - (1293 + 519)) < (9881 - 5038)) and ((4 - 2) == v128)) then
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v128 = 12 - 9;
			end
			if ((v128 == (0 - 0)) or ((2054 + 1823) >= (926 + 3611))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v128 = 2 - 1;
			end
			if ((v128 == (2 + 5)) or ((1434 + 2881) < (1079 + 647))) then
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 1104 - (709 + 387);
			end
			if ((v128 == (1867 - (673 + 1185))) or ((10669 - 6990) < (2006 - 1381))) then
				v79 = EpicSettings.Settings['sepsis'];
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if ((v128 == (5 + 1)) or ((3456 + 1169) < (852 - 220))) then
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v128 = 2 + 5;
			end
			if ((v128 == (1 - 0)) or ((162 - 79) > (3660 - (446 + 1434)))) then
				v35 = EpicSettings.Settings['HealingPotionHP'] or (1283 - (1040 + 243));
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v128 = 1849 - (559 + 1288);
			end
			if (((2477 - (609 + 1322)) <= (1531 - (13 + 441))) and (v128 == (14 - 10))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v128 = 13 - 8;
			end
			if ((v128 == (24 - 19)) or ((38 + 958) > (15620 - 11319))) then
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v59 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v60 = EpicSettings.Settings['StealthOOC'];
				v128 = 17 - 11;
			end
			if (((2228 + 1842) > (1263 - 576)) and (v128 == (6 + 2))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v128 = 6 + 3;
			end
		end
	end
	local v83 = v10.Commons.Everyone;
	local v84 = v10.Commons.Rogue;
	local v85 = v18.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = v21.Rogue.Outlaw;
	local v88 = {};
	local v89 = v16:GetEquipment();
	local v90 = (v89[10 + 3] and v20(v89[11 + 2])) or v20(0 + 0);
	local v91 = (v89[447 - (153 + 280)] and v20(v89[40 - 26])) or v20(0 + 0);
	v10:RegisterForEvent(function()
		v89 = v16:GetEquipment();
		v90 = (v89[6 + 7] and v20(v89[7 + 6])) or v20(0 + 0);
		v91 = (v89[11 + 3] and v20(v89[20 - 6])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 673 - (89 + 578);
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 842 - (497 + 345), 0 + 0;
	local function v108(v129)
		local v130 = v16:EnergyTimeToMaxPredicted(nil, v129);
		if ((v130 < v106) or ((v130 - v106) > (0.5 + 0)) or ((1989 - (605 + 728)) >= (2376 + 954))) then
			v106 = v130;
		end
		return v106;
	end
	local function v109()
		local v131 = v16:EnergyPredicted();
		if ((v131 > v107) or ((v131 - v107) > (19 - 10)) or ((115 + 2377) <= (1238 - 903))) then
			v107 = v131;
		end
		return v107;
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		local v132 = 0 + 0;
		while true do
			if (((1128 + 3194) >= (9066 - 6504)) and (v132 == (0 + 0))) then
				if (not v11.APLVar.RtB_Buffs or ((4433 - (588 + 208)) >= (10161 - 6391))) then
					local v179 = 1800 - (884 + 916);
					local v180;
					while true do
						if ((v179 == (1 - 0)) or ((1380 + 999) > (5231 - (232 + 421)))) then
							v11.APLVar.RtB_Buffs.Total = 1889 - (1569 + 320);
							v11.APLVar.RtB_Buffs.Normal = 0 + 0;
							v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
							v179 = 6 - 4;
						end
						if ((v179 == (607 - (316 + 289))) or ((1264 - 781) > (35 + 708))) then
							v11.APLVar.RtB_Buffs.Longer = 1453 - (666 + 787);
							v11.APLVar.RtB_Buffs.MaxRemains = 425 - (360 + 65);
							v180 = v84.RtBRemains();
							v179 = 3 + 0;
						end
						if (((2708 - (79 + 175)) > (910 - 332)) and (v179 == (0 + 0))) then
							v11.APLVar.RtB_Buffs = {};
							v11.APLVar.RtB_Buffs.Will_Lose = {};
							v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
							v179 = 1 - 0;
						end
						if (((1829 - (503 + 396)) < (4639 - (92 + 89))) and (v179 == (5 - 2))) then
							for v194 = 1 + 0, #v110 do
								local v195 = 0 + 0;
								local v196;
								while true do
									if (((2592 - 1930) <= (133 + 839)) and (v195 == (2 - 1))) then
										if (((3813 + 557) == (2088 + 2282)) and v111) then
											local v201 = 0 - 0;
											while true do
												if ((v201 == (0 + 0)) or ((7261 - 2499) <= (2105 - (485 + 759)))) then
													print("RtbRemains", v180);
													print(v110[v194]:Name(), v196);
													break;
												end
											end
										end
										break;
									end
									if ((v195 == (0 - 0)) or ((2601 - (442 + 747)) == (5399 - (832 + 303)))) then
										v196 = v16:BuffRemains(v110[v194]);
										if ((v196 > (946 - (88 + 858))) or ((966 + 2202) < (1782 + 371))) then
											local v202 = 0 + 0;
											local v203;
											while true do
												if ((v202 == (790 - (766 + 23))) or ((24565 - 19589) < (1821 - 489))) then
													v203 = math.abs(v196 - v180);
													if (((12193 - 7565) == (15707 - 11079)) and (v203 <= (1073.5 - (1036 + 37)))) then
														v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
														v11.APLVar.RtB_Buffs.Will_Lose[v110[v194]:Name()] = true;
														v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1 - 0);
													elseif ((v196 > v180) or ((43 + 11) == (1875 - (641 + 839)))) then
														v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (914 - (910 + 3));
													else
														local v214 = 0 - 0;
														while true do
															if (((1766 - (1466 + 218)) == (38 + 44)) and (v214 == (1149 - (556 + 592)))) then
																v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
																break;
															end
															if (((808 - (329 + 479)) == v214) or ((1435 - (174 + 680)) < (968 - 686))) then
																v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (1 - 0);
																v11.APLVar.RtB_Buffs.Will_Lose[v110[v194]:Name()] = true;
																v214 = 1 + 0;
															end
														end
													end
													break;
												end
												if ((v202 == (739 - (396 + 343))) or ((408 + 4201) < (3972 - (29 + 1448)))) then
													v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (1390 - (135 + 1254));
													if (((4339 - 3187) == (5378 - 4226)) and (v196 > v11.APLVar.RtB_Buffs.MaxRemains)) then
														v11.APLVar.RtB_Buffs.MaxRemains = v196;
													end
													v202 = 1 + 0;
												end
											end
										end
										v195 = 1528 - (389 + 1138);
									end
								end
							end
							if (((2470 - (102 + 472)) <= (3230 + 192)) and v111) then
								print("have: ", v11.APLVar.RtB_Buffs.Total);
								print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
								print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v11.APLVar.RtB_Buffs.Normal);
								print("longer: ", v11.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
							end
							break;
						end
					end
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v113(v133)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v114()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 + 0)) or ((2535 - (320 + 1225)) > (2883 - 1263))) then
				if (not v11.APLVar.RtB_Reroll or ((537 + 340) > (6159 - (157 + 1307)))) then
					if (((4550 - (821 + 1038)) >= (4618 - 2767)) and (v65 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v112() <= (0 + 0)) and true) or false;
					elseif ((v65 == "Broadside") or ((5301 - 2316) >= (1807 + 3049))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
					elseif (((10598 - 6322) >= (2221 - (834 + 192))) and (v65 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
					elseif (((206 + 3026) <= (1204 + 3486)) and (v65 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
					elseif ((v65 == "Skull and Crossbones") or ((20 + 876) >= (4873 - 1727))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
					elseif (((3365 - (300 + 4)) >= (790 + 2168)) and (v65 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
					elseif (((8342 - 5155) >= (1006 - (112 + 250))) and (v65 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
					else
						v11.APLVar.RtB_Reroll = false;
						v112();
						v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (1 + 1))));
						if (((1612 - 968) <= (404 + 300)) and v85.Crackshot:IsAvailable() and not v16:HasTier(17 + 14, 3 + 1)) then
							v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
						end
						if (((712 + 246) > (2361 - (1001 + 413))) and v85.Crackshot:IsAvailable() and v16:HasTier(69 - 38, 886 - (244 + 638))) then
							v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((694 - (627 + 66)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
						end
						if (((13384 - 8892) >= (3256 - (512 + 90))) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((1908 - (1665 + 241)) + v22(v113(v85.GrandMelee)))) and (v94 < (719 - (373 + 344)))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (2 - 1)) and (v112() < (9 - 3)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (1138 - (35 + 1064))) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
						if (((2505 + 937) >= (3215 - 1712)) and (v17:FilteredTimeToDie("<", 1 + 11) or v10.BossFilteredFightRemains("<", 1248 - (298 + 938)))) then
							v11.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1260 - (233 + 1026))) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((1668 - (636 + 1030)) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (26 + 24));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (2 + 0)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (1 + 0)) or ((3391 - (55 + 166)) <= (284 + 1180))) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (1 + 5)) or not v68) and not v16:StealthUp(true, false)) or ((18320 - 13523) == (4685 - (36 + 261)))) then
					if (((963 - 412) <= (2049 - (34 + 1334))) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((1260 + 2017) > (317 + 90)) and v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) then
					if (((5978 - (1035 + 248)) >= (1436 - (20 + 1))) and v12(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance";
					end
				end
				v135 = 2 + 0;
			end
			if ((v135 == (321 - (134 + 185))) or ((4345 - (549 + 584)) <= (1629 - (314 + 371)))) then
				if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (102 - 72)) or ((v85.KeepItRolling:CooldownRemains() >= (1088 - (478 + 490))) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((1641 + 1455) <= (2970 - (786 + 386)))) then
					if (((11456 - 7919) == (4916 - (1055 + 324))) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance";
					end
				end
				if (((5177 - (1093 + 247)) >= (1396 + 174)) and v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) then
					if ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())) or ((311 + 2639) == (15134 - 11322))) then
						if (((16028 - 11305) >= (6595 - 4277)) and v10.Cast(v85.Shadowmeld, v31)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if ((v135 == (0 - 0)) or ((722 + 1305) > (10986 - 8134))) then
				if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (20 - 14))) and v116()) or ((857 + 279) > (11040 - 6723))) then
					if (((5436 - (364 + 324)) == (13015 - 8267)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((8964 - 5228) <= (1571 + 3169)) and v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) then
					if (v10.Cast(v85.Vanish, v68) or ((14184 - 10794) <= (4900 - 1840))) then
						return "Cast Vanish (Finish)";
					end
				end
				v135 = 2 - 1;
			end
		end
	end
	local function v121()
		local v136 = 1268 - (1249 + 19);
		local v137;
		while true do
			if ((v136 == (0 + 0)) or ((3888 - 2889) > (3779 - (686 + 400)))) then
				v137 = v83.HandleTopTrinket(v88, v29, 32 + 8, nil);
				if (((692 - (73 + 156)) < (3 + 598)) and v137) then
					return v137;
				end
				v136 = 812 - (721 + 90);
			end
			if ((v136 == (1 + 0)) or ((7087 - 4904) < (1157 - (224 + 246)))) then
				v137 = v83.HandleBottomTrinket(v88, v29, 64 - 24, nil);
				if (((8375 - 3826) == (826 + 3723)) and v137) then
					return v137;
				end
				break;
			end
		end
	end
	local function v122()
		local v138 = 0 + 0;
		local v139;
		local v140;
		while true do
			if (((3432 + 1240) == (9288 - 4616)) and (v138 == (0 - 0))) then
				v139 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (v139 or ((4181 - (203 + 310)) < (2388 - (1238 + 755)))) then
					return "DPS Pot";
				end
				if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1 + 1))))) or ((5700 - (709 + 825)) == (838 - 383))) then
					if (v12(v85.AdrenalineRush, v76) or ((6480 - 2031) == (3527 - (196 + 668)))) then
						return "Cast Adrenaline Rush";
					end
				end
				if (v85.BladeFlurry:IsReady() or ((16886 - 12609) < (6191 - 3202))) then
					if (((v94 >= ((835 - (171 + 662)) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) or ((963 - (4 + 89)) >= (14541 - 10392))) then
						if (((806 + 1406) < (13980 - 10797)) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((6132 - (35 + 1451)) > (4445 - (28 + 1425))) and (v138 == (1996 - (941 + 1052)))) then
				if (((1376 + 58) < (4620 - (822 + 692))) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
					local v181 = 0 - 0;
					while true do
						if (((371 + 415) < (3320 - (45 + 252))) and ((0 + 0) == v181)) then
							v140 = v120();
							if (v140 or ((841 + 1601) < (179 - 105))) then
								return v140;
							end
							break;
						end
					end
				end
				if (((4968 - (114 + 319)) == (6510 - 1975)) and v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (128 - 28)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (4 + 2)))) then
					if (v10.Cast(v85.ThistleTea) or ((4482 - 1473) <= (4410 - 2305))) then
						return "Cast Thistle Tea";
					end
				end
				if (((3793 - (556 + 1407)) < (4875 - (741 + 465))) and v85.BladeRush:IsCastable() and (v103 > (469 - (170 + 295))) and not v16:StealthUp(true, true)) then
					if (v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush)) or ((754 + 676) >= (3318 + 294))) then
						return "Cast Blade Rush";
					end
				end
				if (((6605 - 3922) >= (2040 + 420)) and v85.BloodFury:IsCastable()) then
					if (v10.Cast(v85.BloodFury, v31) or ((1157 + 647) >= (1855 + 1420))) then
						return "Cast Blood Fury";
					end
				end
				v138 = 1234 - (957 + 273);
			end
			if ((v138 == (2 + 2)) or ((568 + 849) > (13828 - 10199))) then
				if (((12635 - 7840) > (1227 - 825)) and v85.Berserking:IsCastable()) then
					if (((23832 - 19019) > (5345 - (389 + 1391))) and v10.Cast(v85.Berserking, v31)) then
						return "Cast Berserking";
					end
				end
				if (((2455 + 1457) == (408 + 3504)) and v85.Fireblood:IsCastable()) then
					if (((6422 - 3601) <= (5775 - (783 + 168))) and v10.Cast(v85.Fireblood, v31)) then
						return "Cast Fireblood";
					end
				end
				if (((5832 - 4094) <= (2160 + 35)) and v85.AncestralCall:IsCastable()) then
					if (((352 - (309 + 2)) <= (9267 - 6249)) and v10.Cast(v85.AncestralCall, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((3357 - (1090 + 122)) <= (1331 + 2773)) and (v138 == (6 - 4))) then
				if (((1841 + 848) < (5963 - (628 + 490))) and v85.KeepItRolling:IsReady() and not v114() and (v112() >= (1 + 2 + v22(v16:HasTier(76 - 45, 18 - 14)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (780 - (431 + 343))))) then
					if (v10.Cast(v85.KeepItRolling) or ((4689 - 2367) > (7584 - 4962))) then
						return "Cast Keep it Rolling";
					end
				end
				if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (6 + 1))) or ((580 + 3954) == (3777 - (556 + 1139)))) then
					if (v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike)) or ((1586 - (6 + 9)) > (342 + 1525))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((1360 + 1294) >= (3165 - (28 + 141)))) then
					if (((1541 + 2437) > (2596 - 492)) and ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 8 + 3) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1328 - (486 + 831)))) then
						if (((7793 - 4798) > (5425 - 3884)) and v10.Cast(v85.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((614 + 2635) > (3013 - 2060)) and v85.BladeRush:IsReady() and (v103 > (1267 - (668 + 595))) and not v16:StealthUp(true, true)) then
					if (v10.Cast(v85.BladeRush) or ((2946 + 327) > (923 + 3650))) then
						return "Cast Blade Rush";
					end
				end
				v138 = 8 - 5;
			end
			if (((291 - (23 + 267)) == v138) or ((5095 - (1129 + 815)) < (1671 - (371 + 16)))) then
				if (v85.BladeFlurry:IsReady() or ((3600 - (1326 + 424)) == (2895 - 1366))) then
					if (((3000 - 2179) < (2241 - (88 + 30))) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (774 - (720 + 51))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (11 - 6)))) then
						if (((2678 - (421 + 1355)) < (3835 - 1510)) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((422 + 436) <= (4045 - (286 + 797))) and v85.RolltheBones:IsReady()) then
					if (v114() or (v112() == (0 - 0)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (4 - 1)) and v16:HasTier(470 - (397 + 42), 2 + 2)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (807 - (24 + 776))) and ((v85.ShadowDance:CooldownRemains() <= (4 - 1)) or (v85.Vanish:CooldownRemains() <= (788 - (222 + 563))))) or ((8694 - 4748) < (928 + 360))) then
						if (v12(v85.RolltheBones) or ((3432 - (23 + 167)) == (2365 - (690 + 1108)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v140 = v121();
				if (v140 or ((306 + 541) >= (1042 + 221))) then
					return v140;
				end
				v138 = 850 - (40 + 808);
			end
		end
	end
	local function v123()
		local v141 = 0 + 0;
		while true do
			if (((0 - 0) == v141) or ((2154 + 99) == (980 + 871))) then
				if ((v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (2 + 0)) and (v16:BuffRemains(v85.BladeFlurry) <= v16:GCD()) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((2658 - (47 + 524)) > (1540 + 832))) then
					if (v71 or ((12150 - 7705) < (6203 - 2054))) then
						v10.Cast(v85.BladeFlurry);
					elseif (v10.Cast(v85.BladeFlurry) or ((4145 - 2327) == (1811 - (1165 + 561)))) then
						return "Cast Blade Flurry";
					end
				end
				if (((19 + 611) < (6587 - 4460)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (v10.Cast(v85.ColdBlood, v56) or ((740 + 1198) == (2993 - (341 + 138)))) then
						return "Cast Cold Blood";
					end
				end
				v141 = 1 + 0;
			end
			if (((8781 - 4526) >= (381 - (89 + 237))) and (v141 == (9 - 6))) then
				if (((6313 - 3314) > (2037 - (581 + 300))) and v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) then
					if (((3570 - (855 + 365)) > (2743 - 1588)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((1316 + 2713) <= (6088 - (1030 + 205))) and (v141 == (2 + 0))) then
				if ((v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (2 + 0)) and (v16:BuffStack(v85.Opportunity) >= (292 - (156 + 130))) and ((v16:BuffUp(v85.Broadside) and (v98 <= (2 - 1))) or v16:BuffUp(v85.GreenskinsWickersBuff))) or ((869 - 353) > (7032 - 3598))) then
					if (((1067 + 2979) >= (1769 + 1264)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((2788 - (10 + 59)) <= (410 + 1037))) then
					if (v10.Cast(v85.SinisterStrike, nil, not v17:IsSpellInRange(v85.Ambush)) or ((20359 - 16225) < (5089 - (671 + 492)))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v141 = 3 + 0;
			end
			if ((v141 == (1216 - (369 + 846))) or ((44 + 120) >= (2377 + 408))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) or ((2470 - (1036 + 909)) == (1677 + 432))) then
					if (((55 - 22) == (236 - (11 + 192))) and v10.Cast(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((1544 + 1510) <= (4190 - (135 + 40))) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (((4533 - 2662) < (2039 + 1343)) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v141 = 4 - 2;
			end
		end
	end
	local function v124()
		local v142 = 0 - 0;
		while true do
			if (((1469 - (50 + 126)) <= (6031 - 3865)) and (v142 == (1 + 0))) then
				if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (1413 - (1233 + 180)))) and (v16:BuffRemains(v85.SliceandDice) < (((970 - (522 + 447)) + v98) * (1422.8 - (107 + 1314))))) or ((1197 + 1382) < (374 - 251))) then
					if (v10.Press(v85.SliceandDice) or ((360 + 486) >= (4702 - 2334))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((15873 - 11861) <= (5268 - (716 + 1194)))) then
					if (((26 + 1468) <= (322 + 2683)) and v10.Cast(v85.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v142 = 505 - (74 + 429);
			end
			if ((v142 == (0 - 0)) or ((1542 + 1569) == (4884 - 2750))) then
				if (((1667 + 688) == (7260 - 4905)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (9 - 5)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(463 - (279 + 154), 782 - (454 + 324))) and v16:BuffDown(v85.GreenskinsWickers)) then
					if (v10.Press(v85.BetweentheEyes) or ((463 + 125) <= (449 - (12 + 5)))) then
						return "Cast Between the Eyes";
					end
				end
				if (((2587 + 2210) >= (9924 - 6029)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (17 + 28)) and (v85.ShadowDance:CooldownRemains() > (1105 - (277 + 816)))) then
					if (((15284 - 11707) == (4760 - (1058 + 125))) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v142 = 1 + 0;
			end
			if (((4769 - (815 + 160)) > (15845 - 12152)) and (v142 == (4 - 2))) then
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((305 + 970) == (11984 - 7884))) then
					if (v10.Cast(v85.ColdBlood, v56) or ((3489 - (41 + 1857)) >= (5473 - (1222 + 671)))) then
						return "Cast Cold Blood";
					end
				end
				if (((2540 - 1557) <= (2598 - 790)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Press(v85.Dispatch) or ((3332 - (229 + 953)) <= (2971 - (1111 + 663)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v143 = 1579 - (874 + 705);
		while true do
			if (((528 + 3241) >= (801 + 372)) and (v143 == (6 - 3))) then
				if (((42 + 1443) == (2164 - (642 + 37))) and v85.SinisterStrike:IsCastable()) then
					if (v10.Press(v85.SinisterStrike) or ((756 + 2559) <= (446 + 2336))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v143 == (2 - 1)) or ((1330 - (233 + 221)) >= (6853 - 3889))) then
				if ((v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((1965 + 267) > (4038 - (718 + 823)))) then
					if (v10.Press(v85.PistolShot) or ((1328 + 782) <= (1137 - (266 + 539)))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((10435 - 6749) > (4397 - (636 + 589))) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (14 - 8)) or (v16:BuffRemains(v85.Opportunity) < (3 - 1)))) then
					if (v10.Press(v85.PistolShot) or ((3546 + 928) < (298 + 522))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v143 = 1017 - (657 + 358);
			end
			if (((11329 - 7050) >= (6565 - 3683)) and ((1187 - (1151 + 36)) == v143)) then
				if ((v29 and v85.EchoingReprimand:IsReady()) or ((1960 + 69) >= (926 + 2595))) then
					if (v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand)) or ((6083 - 4046) >= (6474 - (1552 + 280)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((2554 - (64 + 770)) < (3027 + 1431)) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
					if (v10.Press(v85.Ambush) or ((989 - 553) > (537 + 2484))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v143 = 1244 - (157 + 1086);
			end
			if (((1426 - 713) <= (3709 - 2862)) and (v143 == (2 - 0))) then
				if (((2939 - 785) <= (4850 - (599 + 220))) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((1 - 0) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (1932 - (1813 + 118)))))) or (v98 <= (1 + 0)))) then
					if (((5832 - (841 + 376)) == (6466 - 1851)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1.5 + 0)) or (v99 <= ((2 - 1) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) or ((4649 - (464 + 395)) == (1283 - 783))) then
					if (((43 + 46) < (1058 - (467 + 370))) and v10.Cast(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				v143 = 5 - 2;
			end
		end
	end
	local function v126()
		v82();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v98 = v16:ComboPoints();
		v97 = v84.EffectiveComboPoints(v98);
		v99 = v16:ComboPointsDeficit();
		v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(37 + 13)) or (0 - 0);
		v100 = v109();
		v101 = v16:EnergyRegen();
		v103 = v108(v104);
		v102 = v16:EnergyDeficitPredicted(nil, v104);
		if (((321 + 1733) >= (3305 - 1884)) and v28) then
			local v148 = 520 - (150 + 370);
			while true do
				if (((1974 - (74 + 1208)) < (7521 - 4463)) and (v148 == (4 - 3))) then
					v94 = #v93;
					break;
				end
				if ((v148 == (0 + 0)) or ((3644 - (14 + 376)) == (2870 - 1215))) then
					v92 = v16:GetEnemiesInRange(20 + 10);
					v93 = v16:GetEnemiesInRange(v96);
					v148 = 1 + 0;
				end
			end
		else
			v94 = 1 + 0;
		end
		v95 = v84.CrimsonVial();
		if (v95 or ((3797 - 2501) == (3694 + 1216))) then
			return v95;
		end
		v84.Poisons();
		if (((3446 - (23 + 55)) == (7981 - 4613)) and v33 and (v16:HealthPercentage() <= v35)) then
			local v149 = 0 + 0;
			while true do
				if (((2374 + 269) < (5915 - 2100)) and (v149 == (0 + 0))) then
					if (((2814 - (652 + 249)) > (1319 - 826)) and (v34 == "Refreshing Healing Potion")) then
						if (((6623 - (708 + 1160)) > (9304 - 5876)) and v86.RefreshingHealingPotion:IsReady()) then
							if (((2517 - 1136) <= (2396 - (10 + 17))) and v10.Press(v87.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v34 == "Dreamwalker's Healing Potion") or ((1088 + 3755) == (5816 - (1400 + 332)))) then
						if (((8955 - 4286) > (2271 - (242 + 1666))) and v86.DreamwalkersHealingPotion:IsReady()) then
							if (v10.Press(v87.RefreshingHealingPotion) or ((804 + 1073) >= (1151 + 1987))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((4042 + 700) >= (4566 - (850 + 90))) and v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) then
			if (v10.Cast(v85.Feint) or ((7951 - 3411) == (2306 - (360 + 1030)))) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) or ((1024 + 132) > (12263 - 7918))) then
			if (((3077 - 840) < (5910 - (909 + 752))) and v10.Cast(v85.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if ((not v16:IsCasting() and not v16:IsChanneling()) or ((3906 - (109 + 1114)) < (41 - 18))) then
			local v150 = 0 + 0;
			local v151;
			while true do
				if (((939 - (6 + 236)) <= (521 + 305)) and ((3 + 0) == v150)) then
					if (((2606 - 1501) <= (2053 - 877)) and v151) then
						return v151;
					end
					v151 = v83.InterruptWithStun(v85.KidneyShot, 1141 - (1076 + 57), v16:ComboPoints() > (0 + 0));
					if (((4068 - (579 + 110)) <= (301 + 3511)) and v151) then
						return v151;
					end
					break;
				end
				if ((v150 == (0 + 0)) or ((419 + 369) >= (2023 - (174 + 233)))) then
					v151 = v83.Interrupt(v85.Kick, 22 - 14, true);
					if (((3253 - 1399) <= (1503 + 1876)) and v151) then
						return v151;
					end
					v151 = v83.Interrupt(v85.Kick, 1182 - (663 + 511), true, v13, v87.KickMouseover);
					v150 = 1 + 0;
				end
				if (((988 + 3561) == (14024 - 9475)) and ((1 + 0) == v150)) then
					if (v151 or ((7114 - 4092) >= (7320 - 4296))) then
						return v151;
					end
					v151 = v83.Interrupt(v85.Blind, 8 + 7, v80);
					if (((9381 - 4561) > (1567 + 631)) and v151) then
						return v151;
					end
					v150 = 1 + 1;
				end
				if ((v150 == (724 - (478 + 244))) or ((1578 - (440 + 77)) >= (2224 + 2667))) then
					v151 = v83.Interrupt(v85.Blind, 54 - 39, v80, v13, v87.BlindMouseover);
					if (((2920 - (655 + 901)) <= (830 + 3643)) and v151) then
						return v151;
					end
					v151 = v83.InterruptWithStun(v85.CheapShot, 7 + 1, v16:StealthUp(false, false));
					v150 = 3 + 0;
				end
			end
		end
		if (v30 or ((14482 - 10887) <= (1448 - (695 + 750)))) then
			local v152 = 0 - 0;
			while true do
				if ((v152 == (0 - 0)) or ((18789 - 14117) == (4203 - (285 + 66)))) then
					v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 69 - 39, true);
					if (((2869 - (682 + 628)) == (252 + 1307)) and v95) then
						return v95;
					end
					break;
				end
			end
		end
		if ((not v16:AffectingCombat() and not v16:IsMounted() and v60) or ((2051 - (176 + 123)) <= (330 + 458))) then
			v95 = v84.Stealth(v85.Stealth2, nil);
			if (v95 or ((2835 + 1072) == (446 - (239 + 30)))) then
				return "Stealth (OOC): " .. v95;
			end
		end
		if (((944 + 2526) > (534 + 21)) and not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1 - 0)) and v17:IsInRange(24 - 16) and v27) then
			if ((v83.TargetIsValid() and v17:IsInRange(325 - (306 + 9)) and not (v16:IsChanneling() or v16:IsCasting())) or ((3391 - 2419) == (113 + 532))) then
				if (((1953 + 1229) >= (1019 + 1096)) and v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
					if (((11132 - 7239) < (5804 - (1140 + 235))) and v12(v85.BladeFlurry)) then
						return "Blade Flurry (Opener)";
					end
				end
				if (not v16:StealthUp(true, false) or ((1825 + 1042) < (1747 + 158))) then
					v95 = v84.Stealth(v84.StealthSpell());
					if (v95 or ((461 + 1335) >= (4103 - (33 + 19)))) then
						return v95;
					end
				end
				if (((585 + 1034) <= (11257 - 7501)) and v83.TargetIsValid()) then
					if (((267 + 337) == (1184 - 580)) and v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (0 + 0)) or v114())) then
						if (v10.Cast(v85.RolltheBones) or ((5173 - (586 + 103)) == (82 + 818))) then
							return "Cast Roll the Bones (Opener)";
						end
					end
					if ((v85.AdrenalineRush:IsReady() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (5 - 3))) or ((5947 - (1309 + 179)) <= (2009 - 896))) then
						if (((1581 + 2051) > (9125 - 5727)) and v10.Cast(v85.AdrenalineRush)) then
							return "Cast Adrenaline Rush (Opener)";
						end
					end
					if (((3084 + 998) <= (10446 - 5529)) and v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((1 - 0) + v98) * (610.8 - (295 + 314))))) then
						if (((11868 - 7036) >= (3348 - (1300 + 662))) and v10.Press(v85.SliceandDice)) then
							return "Cast Slice and Dice (Opener)";
						end
					end
					if (((430 - 293) == (1892 - (1178 + 577))) and v16:StealthUp(true, false)) then
						local v193 = 0 + 0;
						while true do
							if ((v193 == (0 - 0)) or ((2975 - (851 + 554)) >= (3831 + 501))) then
								v95 = v123();
								if (v95 or ((11270 - 7206) <= (3950 - 2131))) then
									return "Stealth (Opener): " .. v95;
								end
								v193 = 303 - (115 + 187);
							end
							if ((v193 == (1 + 0)) or ((4721 + 265) < (6202 - 4628))) then
								if (((5587 - (160 + 1001)) > (151 + 21)) and v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) then
									if (((405 + 181) > (931 - 476)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if (((1184 - (237 + 121)) == (1723 - (525 + 372))) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) then
									if (v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush)) or ((7619 - 3600) > (14591 - 10150))) then
										return "Cast Ambush (Opener)";
									end
								elseif (((2159 - (96 + 46)) < (5038 - (643 + 134))) and v85.SinisterStrike:IsCastable()) then
									if (((1703 + 3013) > (191 - 111)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
										return "Cast Sinister Strike (Opener)";
									end
								end
								break;
							end
						end
					elseif (v115() or ((13020 - 9513) == (3138 + 134))) then
						local v198 = 0 - 0;
						while true do
							if ((v198 == (0 - 0)) or ((1595 - (316 + 403)) >= (2044 + 1031))) then
								v95 = v124();
								if (((11965 - 7613) > (924 + 1630)) and v95) then
									return "Finish (Opener): " .. v95;
								end
								break;
							end
						end
					end
					if (v85.SinisterStrike:IsCastable() or ((11095 - 6689) < (2866 + 1177))) then
						if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((609 + 1280) >= (11721 - 8338))) then
							return "Cast Sinister Strike (Opener)";
						end
					end
				end
				return;
			end
		end
		if (((9035 - 7143) <= (5679 - 2945)) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
			local v153 = 0 + 0;
			while true do
				if (((3785 - 1862) < (109 + 2109)) and (v153 == (2 - 1))) then
					v99 = v16:ComboPointsDeficit();
					break;
				end
				if (((2190 - (12 + 5)) > (1471 - 1092)) and (v153 == (0 - 0))) then
					v98 = v26(v98, v84.FanTheHammerCP());
					v97 = v84.EffectiveComboPoints(v98);
					v153 = 1 - 0;
				end
			end
		end
		if (v83.TargetIsValid() or ((6425 - 3834) == (692 + 2717))) then
			local v154 = 1973 - (1656 + 317);
			while true do
				if (((4023 + 491) > (2664 + 660)) and (v154 == (7 - 4))) then
					if ((v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(24 - 19)) or ((562 - (5 + 349)) >= (22932 - 18104))) then
						if (v10.Cast(v85.BagofTricks, v31) or ((2854 - (266 + 1005)) > (2351 + 1216))) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (85 - 60)) and ((v99 >= (1 - 0)) or (v103 <= (1697.2 - (561 + 1135))))) or ((1710 - 397) == (2609 - 1815))) then
						if (((4240 - (507 + 559)) > (7281 - 4379)) and v10.Cast(v85.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((12741 - 8621) <= (4648 - (212 + 176))) and v85.SinisterStrike:IsCastable()) then
						if (v10.Cast(v85.SinisterStrike) or ((1788 - (250 + 655)) > (13029 - 8251))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((0 - 0) == v154) or ((5663 - 2043) >= (6847 - (1869 + 87)))) then
					v95 = v122();
					if (((14768 - 10510) > (2838 - (484 + 1417))) and v95) then
						return "CDs: " .. v95;
					end
					if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((10435 - 5566) < (1517 - 611))) then
						local v183 = 773 - (48 + 725);
						while true do
							if ((v183 == (0 - 0)) or ((3286 - 2061) > (2458 + 1770))) then
								v95 = v123();
								if (((8893 - 5565) > (627 + 1611)) and v95) then
									return "Stealth: " .. v95;
								end
								break;
							end
						end
					end
					v154 = 1 + 0;
				end
				if (((4692 - (152 + 701)) > (2716 - (430 + 881))) and (v154 == (1 + 1))) then
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > ((910 - (557 + 338)) + v101))) or ((383 + 910) <= (1428 - 921))) then
						if (v10.Cast(v85.ArcaneTorrent, v31) or ((10140 - 7244) < (2138 - 1333))) then
							return "Cast Arcane Torrent";
						end
					end
					if (((4990 - 2674) == (3117 - (499 + 302))) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
						if (v10.Cast(v85.ArcanePulse) or ((3436 - (39 + 827)) == (4231 - 2698))) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(11 - 6)) or ((3507 - 2624) == (2241 - 781))) then
						if (v10.Cast(v85.LightsJudgment, v31) or ((396 + 4223) <= (2923 - 1924))) then
							return "Cast Lights Judgment";
						end
					end
					v154 = 1 + 2;
				end
				if ((v154 == (1 - 0)) or ((3514 - (103 + 1)) > (4670 - (475 + 79)))) then
					if (v115() or ((1951 - 1048) >= (9788 - 6729))) then
						local v184 = 0 + 0;
						while true do
							if ((v184 == (1 + 0)) or ((5479 - (1395 + 108)) < (8313 - 5456))) then
								return "Finish Pooling";
							end
							if (((6134 - (7 + 1197)) > (1006 + 1301)) and (v184 == (0 + 0))) then
								v95 = v124();
								if (v95 or ((4365 - (27 + 292)) < (3782 - 2491))) then
									return "Finish: " .. v95;
								end
								v184 = 1 - 0;
							end
						end
					end
					v95 = v125();
					if (v95 or ((17785 - 13544) == (6990 - 3445))) then
						return "Build: " .. v95;
					end
					v154 = 3 - 1;
				end
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(399 - (43 + 96), v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

