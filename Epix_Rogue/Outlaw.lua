local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((1258 + 3585) < (8485 - 3660))) then
			v6 = v0[v4];
			if (not v6 or ((8039 - 4162) >= (6349 - (1293 + 519)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (2 - 1)) or ((8251 - 3936) < (7442 - 5716))) then
			return v6(...);
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
			if ((v128 == (5 + 3)) or ((751 + 2928) < (1451 - 826))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v128 = 3 + 6;
			end
			if ((v128 == (1 + 1)) or ((2891 + 1734) < (1728 - (709 + 387)))) then
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v40 = EpicSettings.Settings['InterruptThreshold'] or (1858 - (673 + 1185));
				v128 = 8 - 5;
			end
			if ((v128 == (22 - 15)) or ((136 - 53) > (1274 + 506))) then
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 6 + 2;
			end
			if (((736 - 190) <= (265 + 812)) and (v128 == (1 - 0))) then
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (1880 - (446 + 1434));
				v128 = 1285 - (1040 + 243);
			end
			if ((v128 == (0 - 0)) or ((2843 - (559 + 1288)) > (6232 - (609 + 1322)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v128 = 455 - (13 + 441);
			end
			if (((15208 - 11138) > (1799 - 1112)) and (v128 == (44 - 35))) then
				v79 = EpicSettings.Settings['sepsis'];
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if (((14 - 10) == v128) or ((233 + 423) >= (1460 + 1870))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v128 = 14 - 9;
			end
			if ((v128 == (4 + 2)) or ((4582 - 2090) <= (222 + 113))) then
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v128 = 4 + 3;
			end
			if (((3106 + 1216) >= (2152 + 410)) and (v128 == (5 + 0))) then
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (433 - (153 + 280));
				v59 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v60 = EpicSettings.Settings['StealthOOC'];
				v128 = 6 + 0;
			end
			if (((2 + 1) == v128) or ((1904 + 1733) >= (3422 + 348))) then
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 3 + 1;
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
	local v90 = (v89[19 - 6] and v20(v89[9 + 4])) or v20(667 - (89 + 578));
	local v91 = (v89[11 + 3] and v20(v89[28 - 14])) or v20(1049 - (572 + 477));
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (0 + 0)) or ((284 + 2095) > (4664 - (84 + 2)))) then
				v89 = v16:GetEquipment();
				v90 = (v89[21 - 8] and v20(v89[10 + 3])) or v20(842 - (497 + 345));
				v129 = 1 + 0;
			end
			if ((v129 == (1 + 0)) or ((1816 - (605 + 728)) > (531 + 212))) then
				v91 = (v89[30 - 16] and v20(v89[1 + 13])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 6 + 0;
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 796 - (588 + 208), 0 - 0;
	local function v108(v130)
		local v131 = v16:EnergyTimeToMaxPredicted(nil, v130);
		if (((4254 - (884 + 916)) > (1209 - 631)) and ((v131 < v106) or ((v131 - v106) > (0.5 + 0)))) then
			v106 = v131;
		end
		return v106;
	end
	local function v109()
		local v132 = 653 - (232 + 421);
		local v133;
		while true do
			if (((2819 - (1569 + 320)) < (1094 + 3364)) and (v132 == (1 + 0))) then
				return v107;
			end
			if (((2230 - 1568) <= (1577 - (316 + 289))) and (v132 == (0 - 0))) then
				v133 = v16:EnergyPredicted();
				if (((202 + 4168) == (5823 - (666 + 787))) and ((v133 > v107) or ((v133 - v107) > (434 - (360 + 65))))) then
					v107 = v133;
				end
				v132 = 1 + 0;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		local v134 = 181 - (92 + 89);
		while true do
			if (((0 - 0) == v134) or ((2443 + 2319) <= (510 + 351))) then
				if (not v11.APLVar.RtB_Buffs or ((5529 - 4117) == (584 + 3680))) then
					local v180 = 0 - 0;
					local v181;
					while true do
						if ((v180 == (2 + 0)) or ((1514 + 1654) < (6557 - 4404))) then
							v181 = v84.RtBRemains();
							for v193 = 1 + 0, #v110 do
								local v194 = v16:BuffRemains(v110[v193]);
								if ((v194 > (0 - 0)) or ((6220 - (485 + 759)) < (3081 - 1749))) then
									local v198 = 1189 - (442 + 747);
									local v199;
									while true do
										if (((5763 - (832 + 303)) == (5574 - (88 + 858))) and ((1 + 0) == v198)) then
											v199 = math.abs(v194 - v181);
											if ((v199 <= (0.5 + 0)) or ((3 + 51) == (1184 - (766 + 23)))) then
												local v207 = 0 - 0;
												while true do
													if (((111 - 29) == (215 - 133)) and (v207 == (3 - 2))) then
														v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1074 - (1036 + 37));
														break;
													end
													if ((v207 == (0 + 0)) or ((1131 - 550) < (222 + 60))) then
														v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1481 - (641 + 839));
														v11.APLVar.RtB_Buffs.Will_Lose[v110[v193]:Name()] = true;
														v207 = 914 - (910 + 3);
													end
												end
											elseif ((v194 > v181) or ((11749 - 7140) < (4179 - (1466 + 218)))) then
												v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
											else
												local v211 = 1148 - (556 + 592);
												while true do
													if (((410 + 742) == (1960 - (329 + 479))) and (v211 == (855 - (174 + 680)))) then
														v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (3 - 2);
														break;
													end
													if (((3929 - 2033) <= (2444 + 978)) and (v211 == (739 - (396 + 343)))) then
														v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
														v11.APLVar.RtB_Buffs.Will_Lose[v110[v193]:Name()] = true;
														v211 = 1478 - (29 + 1448);
													end
												end
											end
											break;
										end
										if ((v198 == (1389 - (135 + 1254))) or ((3729 - 2739) > (7563 - 5943))) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
											if ((v194 > v11.APLVar.RtB_Buffs.MaxRemains) or ((2404 - (389 + 1138)) > (5269 - (102 + 472)))) then
												v11.APLVar.RtB_Buffs.MaxRemains = v194;
											end
											v198 = 1 + 0;
										end
									end
								end
								if (((1493 + 1198) >= (1726 + 125)) and v111) then
									local v200 = 1545 - (320 + 1225);
									while true do
										if ((v200 == (0 - 0)) or ((1827 + 1158) >= (6320 - (157 + 1307)))) then
											print("RtbRemains", v181);
											print(v110[v193]:Name(), v194);
											break;
										end
									end
								end
							end
							if (((6135 - (821 + 1038)) >= (2981 - 1786)) and v111) then
								local v197 = 0 + 0;
								while true do
									if (((5740 - 2508) <= (1745 + 2945)) and (v197 == (4 - 2))) then
										print("longer: ", v11.APLVar.RtB_Buffs.Longer);
										print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
										break;
									end
									if ((v197 == (1027 - (834 + 192))) or ((57 + 839) >= (808 + 2338))) then
										print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
										print("normal: ", v11.APLVar.RtB_Buffs.Normal);
										v197 = 1 + 1;
									end
									if (((4741 - 1680) >= (3262 - (300 + 4))) and (v197 == (0 + 0))) then
										print("have: ", v11.APLVar.RtB_Buffs.Total);
										print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
										v197 = 2 - 1;
									end
								end
							end
							break;
						end
						if (((3549 - (112 + 250)) >= (257 + 387)) and (v180 == (0 - 0))) then
							v11.APLVar.RtB_Buffs = {};
							v11.APLVar.RtB_Buffs.Will_Lose = {};
							v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
							v11.APLVar.RtB_Buffs.Total = 0 + 0;
							v180 = 1 + 0;
						end
						if (((320 + 324) <= (523 + 181)) and (v180 == (1415 - (1001 + 413)))) then
							v11.APLVar.RtB_Buffs.Normal = 0 - 0;
							v11.APLVar.RtB_Buffs.Shorter = 882 - (244 + 638);
							v11.APLVar.RtB_Buffs.Longer = 693 - (627 + 66);
							v11.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
							v180 = 604 - (512 + 90);
						end
					end
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v113(v135)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v135] and true) or false;
	end
	local function v114()
		local v136 = 1906 - (1665 + 241);
		while true do
			if (((1675 - (373 + 344)) > (428 + 519)) and ((0 + 0) == v136)) then
				if (((11848 - 7356) >= (4491 - 1837)) and not v11.APLVar.RtB_Reroll) then
					if (((4541 - (35 + 1064)) >= (1094 + 409)) and (v65 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v112() <= (0 - 0)) and true) or false;
					elseif ((v65 == "Broadside") or ((13 + 3157) <= (2700 - (298 + 938)))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
					elseif ((v65 == "Buried Treasure") or ((6056 - (233 + 1026)) == (6054 - (636 + 1030)))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
					elseif (((282 + 269) <= (666 + 15)) and (v65 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
					elseif (((974 + 2303) > (28 + 379)) and (v65 == "Skull and Crossbones")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
					elseif (((4916 - (55 + 166)) >= (275 + 1140)) and (v65 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
					elseif ((v65 == "True Bearing") or ((323 + 2889) <= (3605 - 2661))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
					else
						local v216 = 297 - (36 + 261);
						while true do
							if (((3 - 1) == v216) or ((4464 - (34 + 1334)) <= (692 + 1106))) then
								if (((2749 + 788) == (4820 - (1035 + 248))) and v85.Crackshot:IsAvailable() and v16:HasTier(52 - (20 + 1), 3 + 1)) then
									v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((320 - (134 + 185)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
								end
								if (((4970 - (549 + 584)) >= (2255 - (314 + 371))) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((6 - 4) + v22(v113(v85.GrandMelee)))) and (v94 < (970 - (478 + 490)))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v216 = 2 + 1;
							end
							if (((1175 - (786 + 386)) == v216) or ((9555 - 6605) == (5191 - (1055 + 324)))) then
								v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (1340 - (1093 + 247))) or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (23 - 17)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (132 - 93)) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
								if (((13439 - 8716) >= (5824 - 3506)) and (v17:FilteredTimeToDie("<", 5 + 7) or v10.BossFilteredFightRemains("<", 46 - 34))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if ((v216 == (3 - 2)) or ((1529 + 498) > (7293 - 4441))) then
								v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (690 - (364 + 324)))));
								if ((v85.Crackshot:IsAvailable() and not v16:HasTier(84 - 53, 9 - 5)) or ((377 + 759) > (18063 - 13746))) then
									v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 - 0)));
								end
								v216 = 5 - 3;
							end
							if (((6016 - (1249 + 19)) == (4286 + 462)) and (v216 == (0 - 0))) then
								v11.APLVar.RtB_Reroll = false;
								v112();
								v216 = 1087 - (686 + 400);
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1 + 0)) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((231 - (73 + 156)) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (1 + 49));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (813 - (721 + 90))) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v137 = 0 + 0;
		while true do
			if (((12130 - 8394) <= (5210 - (224 + 246))) and (v137 == (2 - 0))) then
				if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (55 - 25)) or ((v85.KeepItRolling:CooldownRemains() >= (22 + 98)) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((81 + 3309) <= (2248 + 812))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((1985 - 986) > (8961 - 6268))) then
						return "Cast Shadow Dance";
					end
				end
				if (((976 - (203 + 310)) < (2594 - (1238 + 755))) and v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) then
					if ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())) or ((153 + 2030) < (2221 - (709 + 825)))) then
						if (((8382 - 3833) == (6625 - 2076)) and v10.Cast(v85.Shadowmeld, v31)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((5536 - (196 + 668)) == (18446 - 13774)) and ((1 - 0) == v137)) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (839 - (171 + 662))) or not v68) and not v16:StealthUp(true, false)) or ((3761 - (4 + 89)) < (1384 - 989))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((1517 + 2649) == (1998 - 1543))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((1745 + 2704) == (4149 - (35 + 1451)))) then
					if (v12(v85.ShadowDance, v54) or ((5730 - (28 + 1425)) < (4982 - (941 + 1052)))) then
						return "Cast Shadow Dance";
					end
				end
				v137 = 2 + 0;
			end
			if ((v137 == (1514 - (822 + 692))) or ((1242 - 372) >= (1955 + 2194))) then
				if (((2509 - (45 + 252)) < (3150 + 33)) and v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (3 + 3))) and v116()) then
					if (((11306 - 6660) > (3425 - (114 + 319))) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((2058 - 624) < (3979 - 873)) and v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) then
					if (((502 + 284) < (4503 - 1480)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (Finish)";
					end
				end
				v137 = 1 - 0;
			end
		end
	end
	local function v121()
		local v138 = v83.HandleTopTrinket(v88, v29, 2003 - (556 + 1407), nil);
		if (v138 or ((3648 - (741 + 465)) < (539 - (170 + 295)))) then
			return v138;
		end
		local v138 = v83.HandleBottomTrinket(v88, v29, 22 + 18, nil);
		if (((4166 + 369) == (11165 - 6630)) and v138) then
			return v138;
		end
	end
	local function v122()
		local v139 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
		if (v139 or ((2495 + 514) <= (1350 + 755))) then
			return "DPS Pot";
		end
		if (((1037 + 793) < (4899 - (957 + 273))) and v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1 + 1))))) then
			if (v12(v85.AdrenalineRush, v76) or ((573 + 857) >= (13763 - 10151))) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((7070 - 4387) >= (7514 - 5054)) and v85.BladeFlurry:IsReady()) then
			if (((v94 >= ((9 - 7) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) or ((3584 - (389 + 1391)) >= (2055 + 1220))) then
				if (v12(v85.BladeFlurry) or ((148 + 1269) > (8261 - 4632))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((5746 - (783 + 168)) > (1349 - 947)) and v85.BladeFlurry:IsReady()) then
			if (((4735 + 78) > (3876 - (309 + 2))) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (9 - 6)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (1217 - (1090 + 122))))) then
				if (((1269 + 2643) == (13138 - 9226)) and v12(v85.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((1931 + 890) <= (5942 - (628 + 490))) and v85.RolltheBones:IsReady()) then
			if (((312 + 1426) <= (5434 - 3239)) and (v114() or (v112() == (0 - 0)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (777 - (431 + 343))) and v16:HasTier(62 - 31, 11 - 7)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (6 + 1)) and ((v85.ShadowDance:CooldownRemains() <= (1 + 2)) or (v85.Vanish:CooldownRemains() <= (1698 - (556 + 1139))))))) then
				if (((56 - (6 + 9)) <= (553 + 2465)) and v12(v85.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v140 = v121();
		if (((1099 + 1046) <= (4273 - (28 + 141))) and v140) then
			return v140;
		end
		if (((1042 + 1647) < (5980 - 1135)) and v85.KeepItRolling:IsReady() and not v114() and (v112() >= (3 + 0 + v22(v16:HasTier(1348 - (486 + 831), 10 - 6)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (21 - 15)))) then
			if (v10.Cast(v85.KeepItRolling) or ((439 + 1883) > (8290 - 5668))) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (1270 - (668 + 595)))) or ((4080 + 454) == (420 + 1662))) then
			if (v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike)) or ((4284 - 2713) > (2157 - (23 + 267)))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((4598 - (1129 + 815)) >= (3383 - (371 + 16)))) then
			if (((5728 - (1326 + 424)) > (3984 - 1880)) and ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 40 - 29) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 129 - (88 + 30)))) then
				if (((3766 - (720 + 51)) > (3427 - 1886)) and v10.Cast(v85.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((5025 - (421 + 1355)) > (1572 - 619)) and v85.BladeRush:IsReady() and (v103 > (2 + 2)) and not v16:StealthUp(true, true)) then
			if (v10.Cast(v85.BladeRush) or ((4356 - (286 + 797)) > (16717 - 12144))) then
				return "Cast Blade Rush";
			end
		end
		if ((not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) or ((5218 - 2067) < (1723 - (397 + 42)))) then
			v140 = v120();
			if (v140 or ((578 + 1272) == (2329 - (24 + 776)))) then
				return v140;
			end
		end
		if (((1264 - 443) < (2908 - (222 + 563))) and v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (220 - 120)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (5 + 1)))) then
			if (((1092 - (23 + 167)) < (4123 - (690 + 1108))) and v10.Cast(v85.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((310 + 548) <= (2444 + 518)) and v85.BladeRush:IsCastable() and (v103 > (852 - (40 + 808))) and not v16:StealthUp(true, true)) then
			if (v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush)) or ((650 + 3296) < (4925 - 3637))) then
				return "Cast Blade Rush";
			end
		end
		if (v85.BloodFury:IsCastable() or ((3099 + 143) == (300 + 267))) then
			if (v10.Cast(v85.BloodFury, v31) or ((465 + 382) >= (1834 - (47 + 524)))) then
				return "Cast Blood Fury";
			end
		end
		if (v85.Berserking:IsCastable() or ((1463 + 790) == (5059 - 3208))) then
			if (v10.Cast(v85.Berserking, v31) or ((3119 - 1032) > (5409 - 3037))) then
				return "Cast Berserking";
			end
		end
		if (v85.Fireblood:IsCastable() or ((6171 - (1165 + 561)) < (124 + 4025))) then
			if (v10.Cast(v85.Fireblood, v31) or ((5630 - 3812) == (33 + 52))) then
				return "Cast Fireblood";
			end
		end
		if (((1109 - (341 + 138)) < (575 + 1552)) and v85.AncestralCall:IsCastable()) then
			if (v10.Cast(v85.AncestralCall, v31) or ((3999 - 2061) == (2840 - (89 + 237)))) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v123()
		local v141 = 0 - 0;
		while true do
			if (((8958 - 4703) >= (936 - (581 + 300))) and (v141 == (1222 - (855 + 365)))) then
				if (((7123 - 4124) > (378 + 778)) and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (1237 - (1030 + 205))) and (v16:BuffStack(v85.Opportunity) >= (6 + 0)) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 + 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) then
					if (((2636 - (156 + 130)) > (2624 - 1469)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((6789 - 2760) <= (9939 - 5086)) and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
					if (v12(v85.SinisterStrike, nil, not v17:IsSpellInRange(v85.Ambush)) or ((136 + 380) > (2003 + 1431))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v141 = 72 - (10 + 59);
			end
			if (((1145 + 2901) >= (14936 - 11903)) and (v141 == (1164 - (671 + 492)))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) or ((2165 + 554) <= (2662 - (369 + 846)))) then
					if (v10.Cast(v85.BetweentheEyes) or ((1095 + 3039) < (3351 + 575))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((2109 - (1036 + 909)) >= (2215 + 570))) then
					if (v10.Press(v85.Dispatch) or ((881 - 356) == (2312 - (11 + 192)))) then
						return "Cast Dispatch";
					end
				end
				v141 = 2 + 0;
			end
			if (((208 - (135 + 40)) == (79 - 46)) and (v141 == (0 + 0))) then
				if (((6727 - 3673) <= (6018 - 2003)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (178 - (50 + 126))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (13 - 8)))) then
					if (((415 + 1456) < (4795 - (1233 + 180))) and v10.Cast(v85.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((2262 - (522 + 447)) <= (3587 - (107 + 1314))) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (v10.Cast(v85.ColdBlood, v56) or ((1197 + 1382) < (374 - 251))) then
						return "Cast Cold Blood";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (5 - 2)) or ((3347 - 2501) >= (4278 - (716 + 1194)))) then
				if ((v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) or ((69 + 3943) <= (360 + 2998))) then
					if (((1997 - (74 + 429)) <= (5796 - 2791)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (4 - 2)) or ((2201 + 910) == (6578 - 4444))) then
				if (((5822 - 3467) == (2788 - (279 + 154))) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Cast(v85.ColdBlood, v56) or ((1366 - (454 + 324)) <= (340 + 92))) then
						return "Cast Cold Blood";
					end
				end
				if (((4814 - (12 + 5)) >= (2101 + 1794)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (((9114 - 5537) == (1322 + 2255)) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((4887 - (277 + 816)) > (15780 - 12087)) and (v142 == (1183 - (1058 + 125)))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (1 + 3)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(1005 - (815 + 160), 17 - 13)) and v16:BuffDown(v85.GreenskinsWickers)) or ((3026 - 1751) == (979 + 3121))) then
					if (v10.Press(v85.BetweentheEyes) or ((4650 - 3059) >= (5478 - (41 + 1857)))) then
						return "Cast Between the Eyes";
					end
				end
				if (((2876 - (1222 + 671)) <= (4672 - 2864)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (64 - 19)) and (v85.ShadowDance:CooldownRemains() > (1194 - (229 + 953)))) then
					if (v10.Press(v85.BetweentheEyes) or ((3924 - (1111 + 663)) <= (2776 - (874 + 705)))) then
						return "Cast Between the Eyes";
					end
				end
				v142 = 1 + 0;
			end
			if (((2572 + 1197) >= (2438 - 1265)) and (v142 == (1 + 0))) then
				if (((2164 - (642 + 37)) == (339 + 1146)) and v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 + 0))) and (v16:BuffRemains(v85.SliceandDice) < (((2 - 1) + v98) * (455.8 - (233 + 221))))) then
					if (v10.Press(v85.SliceandDice) or ((7665 - 4350) <= (2449 + 333))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((2417 - (718 + 823)) >= (1866 + 1098))) then
					if (v10.Cast(v85.KillingSpree) or ((3037 - (266 + 539)) > (7069 - 4572))) then
						return "Cast Killing Spree";
					end
				end
				v142 = 1227 - (636 + 589);
			end
		end
	end
	local function v125()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (0 - 0)) or ((1673 + 437) <= (121 + 211))) then
				if (((4701 - (657 + 358)) > (8398 - 5226)) and v29 and v85.EchoingReprimand:IsReady()) then
					if (v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand)) or ((10192 - 5718) < (2007 - (1151 + 36)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((4133 + 146) >= (758 + 2124)) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
					if (v10.Press(v85.Ambush) or ((6059 - 4030) >= (5353 - (1552 + 280)))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v143 = 835 - (64 + 770);
			end
			if ((v143 == (3 + 0)) or ((4623 - 2586) >= (825 + 3817))) then
				if (((2963 - (157 + 1086)) < (8923 - 4465)) and v85.SinisterStrike:IsCastable()) then
					if (v10.Press(v85.SinisterStrike) or ((1909 - 1473) > (4633 - 1612))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((972 - 259) <= (1666 - (599 + 220))) and (v143 == (3 - 1))) then
				if (((4085 - (1813 + 118)) <= (2947 + 1084)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((1218 - (841 + 376)) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (1 - 0))))) or (v98 <= v22(v85.Ruthlessness:IsAvailable())))) then
					if (((1073 + 3542) == (12596 - 7981)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (860.5 - (464 + 395))) or (v99 <= ((2 - 1) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) or ((1821 + 1969) == (1337 - (467 + 370)))) then
					if (((183 - 94) < (163 + 58)) and v10.Cast(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				v143 = 10 - 7;
			end
			if (((321 + 1733) >= (3305 - 1884)) and (v143 == (521 - (150 + 370)))) then
				if (((1974 - (74 + 1208)) < (7521 - 4463)) and v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) then
					if (v10.Press(v85.PistolShot) or ((15432 - 12178) == (1178 + 477))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (396 - (14 + 376))) or (v16:BuffRemains(v85.Opportunity) < (3 - 1)))) or ((839 + 457) == (4314 + 596))) then
					if (((3213 + 155) == (9868 - 6500)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v143 = 2 + 0;
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
		v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(128 - (23 + 55))) or (0 - 0);
		v100 = v109();
		v101 = v16:EnergyRegen();
		v103 = v108(v104);
		v102 = v16:EnergyDeficitPredicted(nil, v104);
		if (((1764 + 879) < (3426 + 389)) and v28) then
			local v148 = 0 - 0;
			while true do
				if (((602 + 1311) > (1394 - (652 + 249))) and (v148 == (0 - 0))) then
					v92 = v16:GetEnemiesInRange(1898 - (708 + 1160));
					v93 = v16:GetEnemiesInRange(v96);
					v148 = 2 - 1;
				end
				if (((8669 - 3914) > (3455 - (10 + 17))) and (v148 == (1 + 0))) then
					v94 = #v93;
					break;
				end
			end
		else
			v94 = 1733 - (1400 + 332);
		end
		v95 = v84.CrimsonVial();
		if (((2648 - 1267) <= (4277 - (242 + 1666))) and v95) then
			return v95;
		end
		v84.Poisons();
		if ((v33 and (v16:HealthPercentage() <= v35)) or ((2073 + 2770) == (1497 + 2587))) then
			if (((3980 + 689) > (1303 - (850 + 90))) and (v34 == "Refreshing Healing Potion")) then
				if (v86.RefreshingHealingPotion:IsReady() or ((3287 - 1410) >= (4528 - (360 + 1030)))) then
					if (((4197 + 545) >= (10234 - 6608)) and v10.Press(v87.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v34 == "Dreamwalker's Healing Potion") or ((6246 - 1706) == (2577 - (909 + 752)))) then
				if (v86.DreamwalkersHealingPotion:IsReady() or ((2379 - (109 + 1114)) > (7954 - 3609))) then
					if (((871 + 1366) < (4491 - (6 + 236))) and v10.Press(v87.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if ((v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) or ((1691 + 992) < (19 + 4))) then
			if (((1643 - 946) <= (1442 - 616)) and v10.Cast(v85.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((2238 - (1076 + 57)) <= (194 + 982)) and v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) then
			if (((4068 - (579 + 110)) <= (301 + 3511)) and v10.Cast(v85.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if ((not v16:IsCasting() and not v16:IsChanneling()) or ((697 + 91) >= (858 + 758))) then
			local v149 = 407 - (174 + 233);
			local v150;
			while true do
				if (((5178 - 3324) <= (5930 - 2551)) and (v149 == (1 + 0))) then
					if (((5723 - (663 + 511)) == (4059 + 490)) and v150) then
						return v150;
					end
					v150 = v83.Interrupt(v85.Blind, 4 + 11, v80);
					if (v150 or ((9316 - 6294) >= (1832 + 1192))) then
						return v150;
					end
					v149 = 4 - 2;
				end
				if (((11668 - 6848) > (1049 + 1149)) and (v149 == (0 - 0))) then
					v150 = v83.Interrupt(v85.Kick, 6 + 2, true);
					if (v150 or ((97 + 964) >= (5613 - (478 + 244)))) then
						return v150;
					end
					v150 = v83.Interrupt(v85.Kick, 525 - (440 + 77), true, v13, v87.KickMouseover);
					v149 = 1 + 0;
				end
				if (((4992 - 3628) <= (6029 - (655 + 901))) and (v149 == (1 + 1))) then
					v150 = v83.Interrupt(v85.Blind, 12 + 3, v80, v13, v87.BlindMouseover);
					if (v150 or ((2428 + 1167) <= (11 - 8))) then
						return v150;
					end
					v150 = v83.InterruptWithStun(v85.CheapShot, 1453 - (695 + 750), v16:StealthUp(false, false));
					v149 = 9 - 6;
				end
				if (((3 - 0) == v149) or ((18789 - 14117) == (4203 - (285 + 66)))) then
					if (((3633 - 2074) == (2869 - (682 + 628))) and v150) then
						return v150;
					end
					v150 = v83.InterruptWithStun(v85.KidneyShot, 2 + 6, v16:ComboPoints() > (299 - (176 + 123)));
					if (v150 or ((733 + 1019) <= (572 + 216))) then
						return v150;
					end
					break;
				end
			end
		end
		if (v30 or ((4176 - (239 + 30)) == (49 + 128))) then
			local v151 = 0 + 0;
			while true do
				if (((6141 - 2671) > (1731 - 1176)) and ((315 - (306 + 9)) == v151)) then
					v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 104 - 74, true);
					if (v95 or ((170 + 802) == (396 + 249))) then
						return v95;
					end
					break;
				end
			end
		end
		if (((1532 + 1650) >= (6048 - 3933)) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
			local v152 = 1375 - (1140 + 235);
			while true do
				if (((2478 + 1415) < (4062 + 367)) and (v152 == (0 + 0))) then
					v95 = v84.Stealth(v85.Stealth2, nil);
					if (v95 or ((2919 - (33 + 19)) < (688 + 1217))) then
						return "Stealth (OOC): " .. v95;
					end
					break;
				end
			end
		end
		if ((not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (2 - 1)) and v17:IsInRange(4 + 4) and v27) or ((3521 - 1725) >= (3799 + 252))) then
			if (((2308 - (586 + 103)) <= (342 + 3414)) and v83.TargetIsValid() and v17:IsInRange(30 - 20) and not (v16:IsChanneling() or v16:IsCasting())) then
				local v179 = 1488 - (1309 + 179);
				while true do
					if (((1089 - 485) == (263 + 341)) and (v179 == (0 - 0))) then
						if ((v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((3387 + 1097) == (1912 - 1012))) then
							if (v12(v85.BladeFlurry) or ((8884 - 4425) <= (1722 - (295 + 314)))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((8920 - 5288) > (5360 - (1300 + 662))) and not v16:StealthUp(true, false)) then
							local v196 = 0 - 0;
							while true do
								if (((5837 - (1178 + 577)) <= (2554 + 2363)) and (v196 == (0 - 0))) then
									v95 = v84.Stealth(v84.StealthSpell());
									if (((6237 - (851 + 554)) >= (1226 + 160)) and v95) then
										return v95;
									end
									break;
								end
							end
						end
						v179 = 2 - 1;
					end
					if (((297 - 160) == (439 - (115 + 187))) and (v179 == (1 + 0))) then
						if (v83.TargetIsValid() or ((1487 + 83) >= (17070 - 12738))) then
							if ((v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (1161 - (160 + 1001))) or v114())) or ((3556 + 508) <= (1256 + 563))) then
								if (v10.Cast(v85.RolltheBones) or ((10206 - 5220) < (1932 - (237 + 121)))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if (((5323 - (525 + 372)) > (325 - 153)) and v85.AdrenalineRush:IsReady() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (6 - 4))) then
								if (((728 - (96 + 46)) > (1232 - (643 + 134))) and v10.Cast(v85.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if (((299 + 527) == (1980 - 1154)) and v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((3 - 2) + v98) * (1.8 + 0)))) then
								if (v10.Press(v85.SliceandDice) or ((7886 - 3867) > (9077 - 4636))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((2736 - (316 + 403)) < (2833 + 1428)) and v16:StealthUp(true, false)) then
								local v202 = 0 - 0;
								while true do
									if (((1705 + 3011) > (201 - 121)) and (v202 == (0 + 0))) then
										v95 = v123();
										if (v95 or ((1131 + 2376) == (11337 - 8065))) then
											return "Stealth (Opener): " .. v95;
										end
										v202 = 4 - 3;
									end
									if ((v202 == (1 - 0)) or ((51 + 825) >= (6053 - 2978))) then
										if (((213 + 4139) > (7514 - 4960)) and v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) then
											if (v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike)) or ((4423 - (12 + 5)) < (15703 - 11660))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) or ((4029 - 2140) >= (7191 - 3808))) then
											if (((4691 - 2799) <= (555 + 2179)) and v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush))) then
												return "Cast Ambush (Opener)";
											end
										elseif (((3896 - (1656 + 317)) < (1977 + 241)) and v85.SinisterStrike:IsCastable()) then
											if (((1742 + 431) > (1007 - 628)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
										break;
									end
								end
							elseif (v115() or ((12751 - 10160) == (3763 - (5 + 349)))) then
								local v204 = 0 - 0;
								while true do
									if (((5785 - (266 + 1005)) > (2191 + 1133)) and (v204 == (0 - 0))) then
										v95 = v124();
										if (v95 or ((273 - 65) >= (6524 - (561 + 1135)))) then
											return "Finish (Opener): " .. v95;
										end
										break;
									end
								end
							end
							if (v85.SinisterStrike:IsCastable() or ((2062 - 479) > (11724 - 8157))) then
								if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((2379 - (507 + 559)) == (1992 - 1198))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
			end
		end
		if (((9815 - 6641) > (3290 - (212 + 176))) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
			local v153 = 905 - (250 + 655);
			while true do
				if (((11234 - 7114) <= (7443 - 3183)) and ((0 - 0) == v153)) then
					v98 = v26(v98, v84.FanTheHammerCP());
					v97 = v84.EffectiveComboPoints(v98);
					v153 = 1957 - (1869 + 87);
				end
				if (((3 - 2) == v153) or ((2784 - (484 + 1417)) > (10240 - 5462))) then
					v99 = v16:ComboPointsDeficit();
					break;
				end
			end
		end
		if (v83.TargetIsValid() or ((6066 - 2446) >= (5664 - (48 + 725)))) then
			local v154 = 0 - 0;
			while true do
				if (((11423 - 7165) > (545 + 392)) and ((7 - 4) == v154)) then
					if ((v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(2 + 3)) or ((1419 + 3450) < (1759 - (152 + 701)))) then
						if (v10.Cast(v85.BagofTricks, v31) or ((2536 - (430 + 881)) > (1620 + 2608))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((4223 - (557 + 338)) > (662 + 1576)) and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (70 - 45)) and ((v99 >= (3 - 2)) or (v103 <= (2.2 - 1)))) then
						if (((8273 - 4434) > (2206 - (499 + 302))) and v10.Cast(v85.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					break;
				end
				if ((v154 == (867 - (39 + 827))) or ((3568 - 2275) <= (1132 - 625))) then
					if (v115() or ((11502 - 8606) < (1235 - 430))) then
						local v183 = 0 + 0;
						while true do
							if (((6778 - 4462) == (371 + 1945)) and (v183 == (1 - 0))) then
								return "Finish Pooling";
							end
							if ((v183 == (104 - (103 + 1))) or ((3124 - (475 + 79)) == (3313 - 1780))) then
								v95 = v124();
								if (v95 or ((2825 - 1942) == (189 + 1271))) then
									return "Finish: " .. v95;
								end
								v183 = 1 + 0;
							end
						end
					end
					v95 = v125();
					if (v95 or ((6122 - (1395 + 108)) <= (2906 - 1907))) then
						return "Build: " .. v95;
					end
					v154 = 1206 - (7 + 1197);
				end
				if ((v154 == (0 + 0)) or ((1190 + 2220) > (4435 - (27 + 292)))) then
					v95 = v122();
					if (v95 or ((2645 - 1742) >= (3900 - 841))) then
						return "CDs: " .. v95;
					end
					if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((16674 - 12698) < (5634 - 2777))) then
						local v184 = 0 - 0;
						while true do
							if (((5069 - (43 + 96)) > (9410 - 7103)) and (v184 == (0 - 0))) then
								v95 = v123();
								if (v95 or ((3358 + 688) < (365 + 926))) then
									return "Stealth: " .. v95;
								end
								break;
							end
						end
					end
					v154 = 1 - 0;
				end
				if ((v154 == (1 + 1)) or ((7947 - 3706) == (1117 + 2428))) then
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (2 + 13 + v101))) or ((5799 - (1414 + 337)) > (6172 - (1642 + 298)))) then
						if (v10.Cast(v85.ArcaneTorrent, v31) or ((4562 - 2812) >= (9990 - 6517))) then
							return "Cast Arcane Torrent";
						end
					end
					if (((9395 - 6229) == (1042 + 2124)) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
						if (((1372 + 391) < (4696 - (357 + 615))) and v10.Cast(v85.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if (((41 + 16) <= (6680 - 3957)) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(5 + 0)) then
						if (v10.Cast(v85.LightsJudgment, v31) or ((4436 - 2366) == (355 + 88))) then
							return "Cast Lights Judgment";
						end
					end
					v154 = 1 + 2;
				end
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(164 + 96, v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

