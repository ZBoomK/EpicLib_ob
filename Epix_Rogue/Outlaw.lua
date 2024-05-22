local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5596 - 4132) <= (4928 - (83 + 468))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Cast;
	local v12 = v9.Mouseover;
	local v13 = v9.Utils;
	local v14 = v9.Unit;
	local v15 = v14.Player;
	local v16 = v14.Target;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Macro;
	local v21 = v9.Commons.Everyone.num;
	local v22 = v9.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29;
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
	local function v81()
		local v127 = 1806 - (1202 + 604);
		while true do
			if (((12552 - 9863) < (7859 - 3136)) and (v127 == (22 - 14))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 334 - (45 + 280);
			end
			if (((3993 + 143) >= (2095 + 302)) and (v127 == (3 + 3))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 4 + 3;
			end
			if ((v127 == (1 + 0)) or ((8024 - 3690) == (6156 - (340 + 1571)))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (1772 - (1733 + 39));
				v127 = 5 - 3;
			end
			if ((v127 == (1034 - (125 + 909))) or ((6224 - (1096 + 852)) <= (1360 + 1671))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1 - 0;
			end
			if ((v127 == (9 + 0)) or ((5294 - (409 + 103)) <= (1435 - (46 + 190)))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (95 - (51 + 44));
				break;
			end
			if ((v127 == (2 + 5)) or ((6181 - (1114 + 203)) < (2628 - (228 + 498)))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 2 + 6;
			end
			if (((2674 + 2165) >= (4363 - (174 + 489))) and (v127 == (12 - 7))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1905 - (830 + 1075));
				v58 = EpicSettings.Settings['FeintHP'] or (524 - (303 + 221));
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 1275 - (231 + 1038);
			end
			if ((v127 == (3 + 0)) or ((2237 - (171 + 991)) > (7904 - 5986))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 10 - 6;
			end
			if (((988 - 592) <= (3045 + 759)) and (v127 == (6 - 4))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v127 = 4 - 1;
			end
			if ((v127 == (12 - 8)) or ((5417 - (111 + 1137)) == (2345 - (91 + 67)))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 14 - 9;
			end
		end
	end
	local v82 = v9.Commons.Everyone;
	local v83 = v9.Commons.Rogue;
	local v84 = v17.Rogue.Outlaw;
	local v85 = v19.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = {};
	local v88 = v15:GetEquipment();
	local v89 = (v88[4 + 9] and v19(v88[536 - (423 + 100)])) or v19(0 + 0);
	local v90 = (v88[38 - 24] and v19(v88[8 + 6])) or v19(771 - (326 + 445));
	v9:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if (((3131 - 1725) == (3281 - 1875)) and (v128 == (712 - (530 + 181)))) then
				v90 = (v88[895 - (614 + 267)] and v19(v88[46 - (19 + 13)])) or v19(0 - 0);
				break;
			end
			if (((3567 - 2036) < (12200 - 7929)) and (v128 == (0 + 0))) then
				v88 = v15:GetEquipment();
				v89 = (v88[22 - 9] and v19(v88[26 - 13])) or v19(1812 - (1293 + 519));
				v128 = 1 - 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 15 - 9;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 1096 - (709 + 387), 1858 - (673 + 1185);
	local function v107(v129)
		local v130 = 0 - 0;
		local v131;
		while true do
			if (((2039 - 1404) == (1044 - 409)) and (v130 == (0 + 0))) then
				v131 = v15:EnergyTimeToMaxPredicted(nil, v129);
				if (((2521 + 852) <= (4800 - 1244)) and ((v131 < v105) or ((v131 - v105) > (0.5 + 0)))) then
					v105 = v131;
				end
				v130 = 1 - 0;
			end
			if ((v130 == (1 - 0)) or ((5171 - (446 + 1434)) < (4563 - (1040 + 243)))) then
				return v105;
			end
		end
	end
	local function v108()
		local v132 = v15:EnergyPredicted();
		if (((13090 - 8704) >= (2720 - (559 + 1288))) and ((v132 > v106) or ((v132 - v106) > (1940 - (609 + 1322))))) then
			v106 = v132;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		local v133 = 0 + 0;
		while true do
			if (((404 + 517) <= (3270 - 2168)) and (v133 == (0 + 0))) then
				if (((8654 - 3948) >= (637 + 326)) and not v10.APLVar.RtB_Buffs) then
					local v173 = 0 + 0;
					local v174;
					while true do
						if ((v173 == (0 + 0)) or ((807 + 153) <= (858 + 18))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Will_Lose = {};
							v10.APLVar.RtB_Buffs.Will_Lose.Total = 433 - (153 + 280);
							v173 = 2 - 1;
						end
						if ((v173 == (1 + 0)) or ((816 + 1250) == (488 + 444))) then
							v10.APLVar.RtB_Buffs.Total = 0 + 0;
							v10.APLVar.RtB_Buffs.Normal = 0 + 0;
							v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
							v173 = 2 + 0;
						end
						if (((5492 - (89 + 578)) < (3460 + 1383)) and (v173 == (5 - 2))) then
							for v188 = 1050 - (572 + 477), #v109 do
								local v189 = 0 + 0;
								local v190;
								while true do
									if ((v189 == (0 + 0)) or ((463 + 3414) >= (4623 - (84 + 2)))) then
										v190 = v15:BuffRemains(v109[v188]);
										if ((v190 > (0 - 0)) or ((3109 + 1206) < (2568 - (497 + 345)))) then
											local v195 = 0 + 0;
											local v196;
											while true do
												if ((v195 == (1 + 0)) or ((5012 - (605 + 728)) < (446 + 179))) then
													v196 = math.abs(v190 - v174);
													if ((v196 <= (0.5 - 0)) or ((212 + 4413) < (2336 - 1704))) then
														v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
														v10.APLVar.RtB_Buffs.Will_Lose[v109[v188]:Name()] = true;
														v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
													elseif ((v190 > v174) or ((63 + 20) > (2269 - (457 + 32)))) then
														v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
													else
														local v208 = 1402 - (832 + 570);
														while true do
															if (((515 + 31) <= (281 + 796)) and (v208 == (3 - 2))) then
																v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
																break;
															end
															if ((v208 == (796 - (588 + 208))) or ((2684 - 1688) > (6101 - (884 + 916)))) then
																v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1 - 0);
																v10.APLVar.RtB_Buffs.Will_Lose[v109[v188]:Name()] = true;
																v208 = 1 + 0;
															end
														end
													end
													break;
												end
												if (((4723 - (232 + 421)) > (2576 - (1569 + 320))) and (v195 == (0 + 0))) then
													v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
													if ((v190 > v10.APLVar.RtB_Buffs.MaxRemains) or ((2210 - 1554) >= (3935 - (316 + 289)))) then
														v10.APLVar.RtB_Buffs.MaxRemains = v190;
													end
													v195 = 2 - 1;
												end
											end
										end
										v189 = 1 + 0;
									end
									if ((v189 == (1454 - (666 + 787))) or ((2917 - (360 + 65)) <= (314 + 21))) then
										if (((4576 - (79 + 175)) >= (4039 - 1477)) and v110) then
											local v197 = 0 + 0;
											while true do
												if ((v197 == (0 - 0)) or ((7003 - 3366) >= (4669 - (503 + 396)))) then
													print("RtbRemains", v174);
													print(v109[v188]:Name(), v190);
													break;
												end
											end
										end
										break;
									end
								end
							end
							if (v110 or ((2560 - (92 + 89)) > (8880 - 4302))) then
								local v192 = 0 + 0;
								while true do
									if ((v192 == (0 + 0)) or ((1891 - 1408) > (102 + 641))) then
										print("have: ", v10.APLVar.RtB_Buffs.Total);
										print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
										v192 = 2 - 1;
									end
									if (((2142 + 312) > (277 + 301)) and (v192 == (5 - 3))) then
										print("longer: ", v10.APLVar.RtB_Buffs.Longer);
										print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
										break;
									end
									if (((117 + 813) < (6798 - 2340)) and (v192 == (1245 - (485 + 759)))) then
										print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
										print("normal: ", v10.APLVar.RtB_Buffs.Normal);
										v192 = 4 - 2;
									end
								end
							end
							break;
						end
						if (((1851 - (442 + 747)) <= (2107 - (832 + 303))) and (v173 == (948 - (88 + 858)))) then
							v10.APLVar.RtB_Buffs.Longer = 0 + 0;
							v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
							v174 = v83.RtBRemains();
							v173 = 1 + 2;
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v112(v134)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v134] and true) or false;
	end
	local function v113()
		local v135 = 789 - (766 + 23);
		while true do
			if (((21573 - 17203) == (5976 - 1606)) and (v135 == (0 - 0))) then
				if (not v10.APLVar.RtB_Reroll or ((16162 - 11400) <= (1934 - (1036 + 37)))) then
					if ((v64 == "1+ Buff") or ((1002 + 410) == (8303 - 4039))) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
					elseif ((v64 == "Broadside") or ((4648 - (641 + 839)) < (3066 - (910 + 3)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif ((v64 == "Buried Treasure") or ((12685 - 7709) < (3016 - (1466 + 218)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((2127 + 2501) == (5776 - (556 + 592))) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif ((v64 == "Skull and Crossbones") or ((20 + 34) == (1203 - (329 + 479)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif (((936 - (174 + 680)) == (281 - 199)) and (v64 == "Ruthless Precision")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((1204 - 623) < (202 + 80))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						local v206 = 739 - (396 + 343);
						while true do
							if (((1 + 0) == v206) or ((6086 - (29 + 1448)) < (3884 - (135 + 1254)))) then
								v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (7 - 5))));
								if (((5378 - 4226) == (768 + 384)) and v84.Crackshot:IsAvailable() and not v15:HasTier(1558 - (389 + 1138), 578 - (102 + 472))) then
									v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
								end
								v206 = 2 + 0;
							end
							if (((1768 + 128) <= (4967 - (320 + 1225))) and (v206 == (5 - 2))) then
								v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v10.APLVar.RtB_Buffs.Normal == (1464 - (157 + 1307))) and (v10.APLVar.RtB_Buffs.Longer >= (1860 - (821 + 1038))) and (v111() < (14 - 8)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (5 + 34)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
								if (v16:FilteredTimeToDie("<", 20 - 8) or v9.BossFilteredFightRemains("<", 5 + 7) or ((2453 - 1463) > (2646 - (834 + 192)))) then
									v10.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if ((v206 == (0 + 0)) or ((226 + 651) > (101 + 4594))) then
								v10.APLVar.RtB_Reroll = false;
								v111();
								v206 = 1 - 0;
							end
							if (((2995 - (300 + 4)) >= (495 + 1356)) and ((5 - 3) == v206)) then
								if ((v84.Crackshot:IsAvailable() and v15:HasTier(393 - (112 + 250), 2 + 2)) or ((7478 - 4493) >= (2782 + 2074))) then
									v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff)));
								end
								if (((3198 + 1078) >= (593 + 602)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < (2 + 0 + v21(v112(v84.GrandMelee)))) and (v93 < (1416 - (1001 + 413)))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v206 = 6 - 3;
							end
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (883 - (244 + 638))) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((695 - (627 + 66)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (148 - 98));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (604 - (512 + 90))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		if (((5138 - (1665 + 241)) <= (5407 - (373 + 344))) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (3 + 3))) and v115()) then
			if (v9.Cast(v84.Vanish, v67) or ((238 + 658) >= (8298 - 5152))) then
				return "Cast Vanish (HO)";
			end
		end
		if (((5179 - 2118) >= (4057 - (35 + 1064))) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
			if (((2319 + 868) >= (1377 - 733)) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((3 + 641) <= (1940 - (298 + 938))) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (1265 - (233 + 1026))) or not v67) and not v15:StealthUp(true, false)) then
			if (((2624 - (636 + 1030)) > (485 + 462)) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((4388 + 104) >= (789 + 1865)) and v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) then
			if (((233 + 3209) >= (1724 - (55 + 166))) and v11(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (6 + 24)) or ((v84.KeepItRolling:CooldownRemains() >= (13 + 107)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((12106 - 8936) <= (1761 - (36 + 261)))) then
			if (v9.Cast(v84.ShadowDance, v53) or ((8389 - 3592) == (5756 - (34 + 1334)))) then
				return "Cast Shadow Dance";
			end
		end
		if (((212 + 339) <= (530 + 151)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
			if (((4560 - (1035 + 248)) > (428 - (20 + 1))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
				if (((2447 + 2248) >= (1734 - (134 + 185))) and v9.Cast(v84.Shadowmeld, v30)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v136 = 1133 - (549 + 584);
		local v137;
		while true do
			if (((685 - (314 + 371)) == v136) or ((11026 - 7814) <= (1912 - (478 + 490)))) then
				v137 = v82.HandleTopTrinket(v87, v28, 5 + 3, nil);
				if (v137 or ((4268 - (786 + 386)) <= (5823 - 4025))) then
					return v137;
				end
				v136 = 1380 - (1055 + 324);
			end
			if (((4877 - (1093 + 247)) == (3144 + 393)) and ((1 + 0) == v136)) then
				v137 = v82.HandleBottomTrinket(v87, v28, 31 - 23, nil);
				if (((13021 - 9184) >= (4467 - 2897)) and v137) then
					return v137;
				end
				break;
			end
		end
	end
	local function v121()
		local v138 = 0 - 0;
		local v139;
		local v140;
		while true do
			if ((v138 == (1 + 0)) or ((11364 - 8414) == (13139 - 9327))) then
				if (((3562 + 1161) >= (5927 - 3609)) and v84.BladeFlurry:IsReady()) then
					if (((v93 >= ((690 - (364 + 324)) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((5556 - 3529) > (6843 - 3991))) then
						if (v11(v84.BladeFlurry) or ((377 + 759) > (18063 - 13746))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((7603 - 2855) == (14420 - 9672)) and v84.BladeFlurry:IsReady()) then
					if (((5004 - (1249 + 19)) <= (4279 + 461)) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (11 - 8)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1091 - (686 + 400))))) then
						if (v11(v84.BladeFlurry) or ((2660 + 730) <= (3289 - (73 + 156)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v84.RolltheBones:IsReady() or ((5 + 994) > (3504 - (721 + 90)))) then
					if (((6 + 457) < (1951 - 1350)) and (v113() or (v111() == (470 - (224 + 246))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (4 - 1)) and v15:HasTier(56 - 25, 1 + 3)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1 + 6)) and ((v84.ShadowDance:CooldownRemains() <= (3 + 0)) or (v84.Vanish:CooldownRemains() <= (5 - 2)))))) then
						if (v11(v84.RolltheBones) or ((7264 - 5081) < (1200 - (203 + 310)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v138 = 1995 - (1238 + 755);
			end
			if (((318 + 4231) == (6083 - (709 + 825))) and (v138 == (8 - 3))) then
				if (((6805 - 2133) == (5536 - (196 + 668))) and v84.BloodFury:IsCastable()) then
					if (v9.Cast(v84.BloodFury, v30) or ((14482 - 10814) < (818 - 423))) then
						return "Cast Blood Fury";
					end
				end
				if (v84.Berserking:IsCastable() or ((4999 - (171 + 662)) == (548 - (4 + 89)))) then
					if (v9.Cast(v84.Berserking, v30) or ((15593 - 11144) == (970 + 1693))) then
						return "Cast Berserking";
					end
				end
				if (v84.Fireblood:IsCastable() or ((18785 - 14508) < (1173 + 1816))) then
					if (v9.Cast(v84.Fireblood, v30) or ((2356 - (35 + 1451)) >= (5602 - (28 + 1425)))) then
						return "Cast Fireblood";
					end
				end
				v138 = 1999 - (941 + 1052);
			end
			if (((2121 + 91) < (4697 - (822 + 692))) and ((5 - 1) == v138)) then
				if (((2189 + 2457) > (3289 - (45 + 252))) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
					local v175 = 0 + 0;
					while true do
						if (((494 + 940) < (7559 - 4453)) and (v175 == (433 - (114 + 319)))) then
							v140 = v119();
							if (((1127 - 341) < (3873 - 850)) and v140) then
								return v140;
							end
							break;
						end
					end
				end
				if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (64 + 36)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (8 - 2)))) or ((5116 - 2674) < (2037 - (556 + 1407)))) then
					if (((5741 - (741 + 465)) == (5000 - (170 + 295))) and v9.Cast(v84.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if ((v84.BladeRush:IsCastable() and (v102 > (3 + 1)) and not v15:StealthUp(true, true)) or ((2764 + 245) <= (5182 - 3077))) then
					if (((1518 + 312) < (2353 + 1316)) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v138 = 3 + 2;
			end
			if ((v138 == (1230 - (957 + 273))) or ((383 + 1047) >= (1446 + 2166))) then
				v139 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (((10223 - 7540) >= (6482 - 4022)) and v139) then
					return "DPS Pot";
				end
				if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (5 - 3))))) or ((8932 - 7128) >= (5055 - (389 + 1391)))) then
					if (v11(v84.AdrenalineRush, v75) or ((890 + 527) > (378 + 3251))) then
						return "Cast Adrenaline Rush";
					end
				end
				v138 = 2 - 1;
			end
			if (((5746 - (783 + 168)) > (1349 - 947)) and ((6 + 0) == v138)) then
				if (((5124 - (309 + 2)) > (10947 - 7382)) and v84.AncestralCall:IsCastable()) then
					if (((5124 - (1090 + 122)) == (1269 + 2643)) and v9.Cast(v84.AncestralCall, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((9474 - 6653) <= (3302 + 1522)) and (v138 == (1120 - (628 + 490)))) then
				v140 = v120();
				if (((312 + 1426) <= (5434 - 3239)) and v140) then
					return v140;
				end
				if (((187 - 146) <= (3792 - (431 + 343))) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((5 - 2) + v21(v15:HasTier(89 - 58, 4 + 0)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (1 + 5)))) then
					if (((3840 - (556 + 1139)) <= (4119 - (6 + 9))) and v9.Cast(v84.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				v138 = 1 + 2;
			end
			if (((1378 + 1311) < (5014 - (28 + 141))) and (v138 == (2 + 1))) then
				if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (8 - 1))) or ((1645 + 677) > (3939 - (486 + 831)))) then
					if (v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((11798 - 7264) == (7329 - 5247))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((297 + 1274) > (5903 - 4036))) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 1274 - (668 + 595)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 10 + 1) or ((536 + 2118) >= (8170 - 5174))) then
						if (((4268 - (23 + 267)) > (4048 - (1129 + 815))) and v9.Cast(v84.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((3382 - (371 + 16)) > (3291 - (1326 + 424))) and v84.BladeRush:IsReady() and (v102 > (7 - 3)) and not v15:StealthUp(true, true)) then
					if (((11872 - 8623) > (1071 - (88 + 30))) and v9.Cast(v84.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v138 = 775 - (720 + 51);
			end
		end
	end
	local function v122()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (1779 - (421 + 1355))) or ((5399 - 2126) > (2247 + 2326))) then
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((4234 - (286 + 797)) < (4693 - 3409))) then
					if (v9.Press(v84.Ambush) or ((3064 - 1214) == (1968 - (397 + 42)))) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((257 + 564) < (2923 - (24 + 776))) and ((0 - 0) == v141)) then
				if (((1687 - (222 + 563)) < (5122 - 2797)) and v84.BladeFlurry:IsReady()) then
					if (((618 + 240) <= (3152 - (23 + 167))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1801 - (690 + 1108))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (2 + 3)))) then
						if (v11(v84.BladeFlurry, v70) or ((3255 + 691) < (2136 - (40 + 808)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((534 + 2708) == (2168 - 1601))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((810 + 37) >= (669 + 594))) then
						return "Cast Cold Blood";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (572 - (47 + 524))) or ((1463 + 790) == (5059 - 3208))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((3119 - 1032) > (5409 - 3037))) then
					if (v9.Cast(v84.BetweentheEyes) or ((6171 - (1165 + 561)) < (124 + 4025))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((5630 - 3812) == (33 + 52))) then
					if (((1109 - (341 + 138)) < (575 + 1552)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v141 = 3 - 1;
			end
			if ((v141 == (328 - (89 + 237))) or ((6234 - 4296) == (5292 - 2778))) then
				if (((5136 - (581 + 300)) >= (1275 - (855 + 365))) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (4 - 2)) and (v15:BuffStack(v84.Opportunity) >= (2 + 4)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1236 - (1030 + 205)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
					if (((2816 + 183) > (1076 + 80)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((2636 - (156 + 130)) > (2624 - 1469)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (((6789 - 2760) <= (9939 - 5086)) and v11(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v141 = 1 + 2;
			end
		end
	end
	local function v123()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (69 - (10 + 59))) or ((146 + 370) > (16911 - 13477))) then
				if (((5209 - (671 + 492)) >= (2415 + 618)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (1219 - (369 + 846))) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(8 + 22, 4 + 0)) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (v9.Press(v84.BetweentheEyes) or ((4664 - (1036 + 909)) <= (1151 + 296))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (75 - 30)) and (v84.ShadowDance:CooldownRemains() > (215 - (11 + 192)))) or ((2090 + 2044) < (4101 - (135 + 40)))) then
					if (v9.Press(v84.BetweentheEyes) or ((397 - 233) >= (1679 + 1106))) then
						return "Cast Between the Eyes";
					end
				end
				v142 = 2 - 1;
			end
			if ((v142 == (1 - 0)) or ((701 - (50 + 126)) == (5872 - 3763))) then
				if (((8 + 25) == (1446 - (1233 + 180))) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (969 - (522 + 447)))) and (v15:BuffRemains(v84.SliceandDice) < (((1422 - (107 + 1314)) + v97) * (1.8 + 0)))) then
					if (((9305 - 6251) <= (1706 + 2309)) and v9.Press(v84.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if (((3715 - 1844) < (13381 - 9999)) and v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
					if (((3203 - (716 + 1194)) <= (37 + 2129)) and v9.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v142 = 1 + 1;
			end
			if ((v142 == (505 - (74 + 429))) or ((4974 - 2395) < (61 + 62))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((1936 - 1090) >= (1676 + 692))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((12368 - 8356) <= (8302 - 4944))) then
						return "Cast Cold Blood";
					end
				end
				if (((1927 - (279 + 154)) <= (3783 - (454 + 324))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
					if (v9.Press(v84.Dispatch) or ((2448 + 663) == (2151 - (12 + 5)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if (((1270 + 1085) == (6000 - 3645)) and v28 and v84.EchoingReprimand:IsReady()) then
			if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((218 + 370) <= (1525 - (277 + 816)))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((20497 - 15700) >= (5078 - (1058 + 125))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
			if (((671 + 2906) == (4552 - (815 + 160))) and v9.Press(v84.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((16278 - 12484) > (8766 - 5073)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
			if (v9.Press(v84.PistolShot) or ((305 + 970) == (11984 - 7884))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (1904 - (41 + 1857))) or (v15:BuffRemains(v84.Opportunity) < (1895 - (1222 + 671))))) or ((4111 - 2520) >= (5145 - 1565))) then
			if (((2165 - (229 + 953)) <= (3582 - (1111 + 663))) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1580 - (874 + 705)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) or ((1467 + 683) <= (2487 - 1290))) then
			if (((107 + 3662) >= (1852 - (642 + 37))) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if (((339 + 1146) == (238 + 1247)) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (2.5 - 1)) or (v98 <= ((455 - (233 + 221)) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
			if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((7665 - 4350) <= (2449 + 333))) then
				return "Cast Pistol Shot";
			end
		end
		if (v84.SinisterStrike:IsCastable() or ((2417 - (718 + 823)) >= (1866 + 1098))) then
			if (v9.Press(v84.SinisterStrike) or ((3037 - (266 + 539)) > (7069 - 4572))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		v81();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v97 = v15:ComboPoints();
		v96 = v83.EffectiveComboPoints(v97);
		v98 = v15:ComboPointsDeficit();
		v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(1275 - (636 + 589))) or (0 - 0);
		v99 = v108();
		v100 = v15:EnergyRegen();
		v102 = v107(v103);
		v101 = v15:EnergyDeficitPredicted(nil, v103);
		if (v27 or ((4351 - 2241) <= (264 + 68))) then
			v91 = v15:GetEnemiesInRange(11 + 19);
			v92 = v15:GetEnemiesInRange(v95);
			v93 = #v92;
		else
			v93 = 1016 - (657 + 358);
		end
		v94 = v83.CrimsonVial();
		if (((9759 - 6073) > (7226 - 4054)) and v94) then
			return v94;
		end
		v83.Poisons();
		if ((v32 and (v15:HealthPercentage() <= v34)) or ((5661 - (1151 + 36)) < (792 + 28))) then
			if (((1125 + 3154) >= (8606 - 5724)) and (v33 == "Refreshing Healing Potion")) then
				if (v85.RefreshingHealingPotion:IsReady() or ((3861 - (1552 + 280)) >= (4355 - (64 + 770)))) then
					if (v9.Press(v86.RefreshingHealingPotion) or ((1384 + 653) >= (10537 - 5895))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((306 + 1414) < (5701 - (157 + 1086))) and (v33 == "Dreamwalker's Healing Potion")) then
				if (v85.DreamwalkersHealingPotion:IsReady() or ((872 - 436) > (13231 - 10210))) then
					if (((1092 - 379) <= (1155 - 308)) and v9.Press(v86.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (((2973 - (599 + 220)) <= (8027 - 3996)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
			if (((6546 - (1813 + 118)) == (3374 + 1241)) and v9.Cast(v84.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) or ((5007 - (841 + 376)) == (700 - 200))) then
			if (((21 + 68) < (603 - 382)) and v9.Cast(v84.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((2913 - (464 + 395)) >= (3646 - 2225)) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v146 = v82.Interrupt(v84.Kick, 4 + 4, true);
			if (((1529 - (467 + 370)) < (6319 - 3261)) and v146) then
				return v146;
			end
			v146 = v82.Interrupt(v84.Kick, 6 + 2, true, v12, v86.KickMouseover);
			if (v146 or ((11154 - 7900) == (259 + 1396))) then
				return v146;
			end
			v146 = v82.Interrupt(v84.Blind, 34 - 19, v79);
			if (v146 or ((1816 - (150 + 370)) == (6192 - (74 + 1208)))) then
				return v146;
			end
			v146 = v82.Interrupt(v84.Blind, 36 - 21, v79, v12, v86.BlindMouseover);
			if (((15973 - 12605) == (2397 + 971)) and v146) then
				return v146;
			end
			v146 = v82.InterruptWithStun(v84.CheapShot, 398 - (14 + 376), v15:StealthUp(false, false));
			if (((4583 - 1940) < (2469 + 1346)) and v146) then
				return v146;
			end
			v146 = v82.InterruptWithStun(v84.KidneyShot, 8 + 0, v15:ComboPoints() > (0 + 0));
			if (((5605 - 3692) > (371 + 122)) and v146) then
				return v146;
			end
		end
		if (((4833 - (23 + 55)) > (8124 - 4696)) and v29) then
			v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 21 + 9, true);
			if (((1241 + 140) <= (3672 - 1303)) and v94) then
				return v94;
			end
		end
		if ((not v15:AffectingCombat() and not v15:IsMounted() and v59) or ((1524 + 3319) == (4985 - (652 + 249)))) then
			v94 = v83.Stealth(v84.Stealth2, nil);
			if (((12494 - 7825) > (2231 - (708 + 1160))) and v94) then
				return "Stealth (OOC): " .. v94;
			end
		end
		if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (2 - 1)) and v16:IsInRange(14 - 6) and v26) or ((1904 - (10 + 17)) >= (705 + 2433))) then
			if (((6474 - (1400 + 332)) >= (6954 - 3328)) and v82.TargetIsValid() and v16:IsInRange(1918 - (242 + 1666)) and not (v15:IsChanneling() or v15:IsCasting())) then
				if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((1943 + 2597) == (336 + 580))) then
					if (v11(v84.BladeFlurry) or ((986 + 170) > (5285 - (850 + 90)))) then
						return "Blade Flurry (Opener)";
					end
				end
				if (((3917 - 1680) < (5639 - (360 + 1030))) and not v15:StealthUp(true, false)) then
					local v176 = 0 + 0;
					while true do
						if ((v176 == (0 - 0)) or ((3690 - 1007) < (1684 - (909 + 752)))) then
							v94 = v83.Stealth(v83.StealthSpell());
							if (((1920 - (109 + 1114)) <= (1511 - 685)) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if (((431 + 674) <= (1418 - (6 + 236))) and v82.TargetIsValid()) then
					if (((2129 + 1250) <= (3069 + 743)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v113())) then
						if (v9.Cast(v84.RolltheBones) or ((1375 - 587) >= (2749 - (1076 + 57)))) then
							return "Cast Roll the Bones (Opener)";
						end
					end
					if (((305 + 1549) <= (4068 - (579 + 110))) and v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))) then
						if (((4022 + 527) == (2415 + 2134)) and v9.Cast(v84.AdrenalineRush)) then
							return "Cast Adrenaline Rush (Opener)";
						end
					end
					if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((408 - (174 + 233)) + v97) * (2.8 - 1)))) or ((5303 - 2281) >= (1345 + 1679))) then
						if (((5994 - (663 + 511)) > (1961 + 237)) and v9.Press(v84.SliceandDice)) then
							return "Cast Slice and Dice (Opener)";
						end
					end
					if (v15:StealthUp(true, false) or ((231 + 830) >= (15078 - 10187))) then
						local v187 = 0 + 0;
						while true do
							if (((3211 - 1847) <= (10828 - 6355)) and (v187 == (0 + 0))) then
								v94 = v122();
								if (v94 or ((6997 - 3402) <= (3 + 0))) then
									return "Stealth (Opener): " .. v94;
								end
								v187 = 1 + 0;
							end
							if ((v187 == (723 - (478 + 244))) or ((5189 - (440 + 77)) == (1752 + 2100))) then
								if (((5705 - 4146) == (3115 - (655 + 901))) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
									if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((325 + 1427) <= (604 + 184))) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((2639 + 1268) == (712 - 535))) then
									if (((4915 - (695 + 750)) > (1894 - 1339)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
										return "Cast Ambush (Opener)";
									end
								elseif (v84.SinisterStrike:IsCastable() or ((1499 - 527) == (2594 - 1949))) then
									if (((3533 - (285 + 66)) >= (4930 - 2815)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
										return "Cast Sinister Strike (Opener)";
									end
								end
								break;
							end
						end
					elseif (((5203 - (682 + 628)) < (714 + 3715)) and v114()) then
						v94 = v123();
						if (v94 or ((3166 - (176 + 123)) < (797 + 1108))) then
							return "Finish (Opener): " .. v94;
						end
					end
					if (v84.SinisterStrike:IsCastable() or ((1303 + 493) >= (4320 - (239 + 30)))) then
						if (((441 + 1178) <= (3611 + 145)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
							return "Cast Sinister Strike (Opener)";
						end
					end
				end
				return;
			end
		end
		if (((1068 - 464) == (1884 - 1280)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
			local v147 = 315 - (306 + 9);
			while true do
				if ((v147 == (3 - 2)) or ((780 + 3704) == (553 + 347))) then
					v98 = v15:ComboPointsDeficit();
					break;
				end
				if ((v147 == (0 + 0)) or ((12750 - 8291) <= (2488 - (1140 + 235)))) then
					v97 = v25(v97, v83.FanTheHammerCP());
					v96 = v83.EffectiveComboPoints(v97);
					v147 = 1 + 0;
				end
			end
		end
		if (((3331 + 301) > (873 + 2525)) and v82.TargetIsValid()) then
			local v148 = 52 - (33 + 19);
			while true do
				if (((1474 + 2608) <= (14737 - 9820)) and (v148 == (1 + 1))) then
					if (((9475 - 4643) >= (1300 + 86)) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(694 - (586 + 103))) then
						if (((13 + 124) == (421 - 284)) and v9.Cast(v84.LightsJudgment, v30)) then
							return "Cast Lights Judgment";
						end
					end
					if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(1493 - (1309 + 179))) or ((2834 - 1264) >= (1886 + 2446))) then
						if (v9.Cast(v84.BagofTricks, v30) or ((10914 - 6850) <= (1374 + 445))) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (53 - 28)) and ((v98 >= (1 - 0)) or (v102 <= (610.2 - (295 + 314))))) or ((12246 - 7260) < (3536 - (1300 + 662)))) then
						if (((13898 - 9472) > (1927 - (1178 + 577))) and v9.Cast(v84.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					break;
				end
				if (((305 + 281) > (1344 - 889)) and (v148 == (1406 - (851 + 554)))) then
					v94 = v124();
					if (((731 + 95) == (2290 - 1464)) and v94) then
						return "Build: " .. v94;
					end
					if ((v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((32 - 17) + v100))) or ((4321 - (115 + 187)) > (3402 + 1039))) then
						if (((1910 + 107) < (16791 - 12530)) and v9.Cast(v84.ArcaneTorrent, v30)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((5877 - (160 + 1001)) > (70 + 10)) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
						if (v9.Cast(v84.ArcanePulse) or ((2420 + 1087) == (6697 - 3425))) then
							return "Cast Arcane Pulse";
						end
					end
					v148 = 360 - (237 + 121);
				end
				if (((897 - (525 + 372)) == v148) or ((1660 - 784) >= (10103 - 7028))) then
					v94 = v121();
					if (((4494 - (96 + 46)) > (3331 - (643 + 134))) and v94) then
						return "CDs: " .. v94;
					end
					if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((1591 + 2815) < (9693 - 5650))) then
						local v178 = 0 - 0;
						while true do
							if ((v178 == (0 + 0)) or ((3706 - 1817) >= (6914 - 3531))) then
								v94 = v122();
								if (((2611 - (316 + 403)) <= (1818 + 916)) and v94) then
									return "Stealth: " .. v94;
								end
								break;
							end
						end
					end
					if (((5286 - 3363) < (802 + 1416)) and v114()) then
						v94 = v123();
						if (((5472 - 3299) > (269 + 110)) and v94) then
							return "Finish: " .. v94;
						end
						return "Finish Pooling";
					end
					v148 = 1 + 0;
				end
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(900 - 640, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

