local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 874 - (69 + 805);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2599 - (83 + 468)) == (4837 - (1202 + 604)))) then
			v6 = v0[v4];
			if (not v6 or ((5597 - 4398) >= (3609 - 1440))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (326 - (45 + 280))) or ((614 + 22) == (1662 + 240))) then
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
		local v128 = 0 + 0;
		while true do
			if ((v128 == (5 + 3)) or ((852 + 3987) <= (6073 - 2793))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v128 = 1920 - (340 + 1571);
			end
			if ((v128 == (1 + 0)) or ((5446 - (1733 + 39)) <= (5391 - 3429))) then
				v35 = EpicSettings.Settings['HealingPotionHP'] or (1034 - (125 + 909));
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (1948 - (1096 + 852));
				v128 = 1 + 1;
			end
			if ((v128 == (7 - 1)) or ((1838 + 56) < (1918 - (409 + 103)))) then
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v128 = 243 - (46 + 190);
			end
			if (((1667 - (51 + 44)) >= (432 + 1099)) and (v128 == (1324 - (1114 + 203)))) then
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 734 - (228 + 498);
			end
			if ((v128 == (2 + 3)) or ((2590 + 2097) < (5205 - (174 + 489)))) then
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v59 = EpicSettings.Settings['FeintHP'] or (1905 - (830 + 1075));
				v60 = EpicSettings.Settings['StealthOOC'];
				v128 = 530 - (303 + 221);
			end
			if (((4560 - (231 + 1038)) > (1390 + 277)) and (v128 == (1166 - (171 + 991)))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v128 = 20 - 15;
			end
			if ((v128 == (0 - 0)) or ((2178 - 1305) == (1628 + 406))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v128 = 3 - 2;
			end
			if (((25 - 16) == v128) or ((4538 - 1722) < (33 - 22))) then
				v79 = EpicSettings.Settings['sepsis'];
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (1248 - (111 + 1137));
				break;
			end
			if (((3857 - (91 + 67)) < (14006 - 9300)) and (v128 == (1 + 2))) then
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 527 - (423 + 100);
			end
			if (((19 + 2627) >= (2425 - 1549)) and (v128 == (2 + 0))) then
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v40 = EpicSettings.Settings['InterruptThreshold'] or (771 - (326 + 445));
				v128 = 13 - 10;
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
	local v90 = (v89[28 - 15] and v20(v89[29 - 16])) or v20(711 - (530 + 181));
	local v91 = (v89[895 - (614 + 267)] and v20(v89[46 - (19 + 13)])) or v20(0 - 0);
	v10:RegisterForEvent(function()
		local v129 = 0 - 0;
		while true do
			if (((1753 - 1139) <= (827 + 2357)) and ((1 - 0) == v129)) then
				v91 = (v89[28 - 14] and v20(v89[1826 - (1293 + 519)])) or v20(0 - 0);
				break;
			end
			if (((8161 - 5035) == (5977 - 2851)) and ((0 - 0) == v129)) then
				v89 = v16:GetEquipment();
				v90 = (v89[30 - 17] and v20(v89[7 + 6])) or v20(0 + 0);
				v129 = 2 - 1;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 2 + 4;
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 0 - 0, 0 + 0;
	local function v108(v130)
		local v131 = v16:EnergyTimeToMaxPredicted(nil, v130);
		if ((v131 < v106) or ((v131 - v106) > (0.5 - 0)) or ((4293 - 2106) >= (6834 - (446 + 1434)))) then
			v106 = v131;
		end
		return v106;
	end
	local function v109()
		local v132 = 1283 - (1040 + 243);
		local v133;
		while true do
			if ((v132 == (2 - 1)) or ((5724 - (559 + 1288)) == (5506 - (609 + 1322)))) then
				return v107;
			end
			if (((1161 - (13 + 441)) > (2361 - 1729)) and (v132 == (0 - 0))) then
				v133 = v16:EnergyPredicted();
				if ((v133 > v107) or ((v133 - v107) > (44 - 35)) or ((21 + 525) >= (9747 - 7063))) then
					v107 = v133;
				end
				v132 = 1 + 0;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		if (((1053 + 412) <= (3612 + 689)) and not v11.APLVar.RtB_Buffs) then
			local v144 = 0 + 0;
			local v145;
			while true do
				if (((2137 - (153 + 280)) > (4114 - 2689)) and (v144 == (2 + 0))) then
					v11.APLVar.RtB_Buffs.Longer = 0 + 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v145 = v84.RtBRemains();
					v144 = 3 + 0;
				end
				if ((v144 == (1 + 0)) or ((1045 - 358) == (2617 + 1617))) then
					v11.APLVar.RtB_Buffs.Total = 667 - (89 + 578);
					v11.APLVar.RtB_Buffs.Normal = 0 + 0;
					v11.APLVar.RtB_Buffs.Shorter = 0 - 0;
					v144 = 1051 - (572 + 477);
				end
				if ((v144 == (0 + 0)) or ((1999 + 1331) < (171 + 1258))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 86 - (84 + 2);
					v144 = 1 - 0;
				end
				if (((827 + 320) >= (1177 - (497 + 345))) and (v144 == (1 + 2))) then
					for v184 = 1 + 0, #v110 do
						local v185 = v16:BuffRemains(v110[v184]);
						if (((4768 - (605 + 728)) > (1497 + 600)) and (v185 > (0 - 0))) then
							v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
							if ((v185 > v11.APLVar.RtB_Buffs.MaxRemains) or ((13938 - 10168) >= (3643 + 398))) then
								v11.APLVar.RtB_Buffs.MaxRemains = v185;
							end
							local v191 = math.abs(v185 - v145);
							if ((v191 <= (0.5 - 0)) or ((2863 + 928) <= (2100 - (457 + 32)))) then
								v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
								v11.APLVar.RtB_Buffs.Will_Lose[v110[v184]:Name()] = true;
								v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1403 - (832 + 570));
							elseif ((v185 > v145) or ((4313 + 265) <= (524 + 1484))) then
								v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (3 - 2);
							else
								local v202 = 0 + 0;
								while true do
									if (((1921 - (588 + 208)) <= (5595 - 3519)) and (v202 == (1801 - (884 + 916)))) then
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1 - 0);
										break;
									end
									if ((v202 == (0 + 0)) or ((1396 - (232 + 421)) >= (6288 - (1569 + 320)))) then
										v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v184]:Name()] = true;
										v202 = 1 + 0;
									end
								end
							end
						end
						if (((3892 - 2737) < (2278 - (316 + 289))) and v111) then
							local v192 = 0 - 0;
							while true do
								if ((v192 == (0 + 0)) or ((3777 - (666 + 787)) <= (1003 - (360 + 65)))) then
									print("RtbRemains", v145);
									print(v110[v184]:Name(), v185);
									break;
								end
							end
						end
					end
					if (((3521 + 246) == (4021 - (79 + 175))) and v111) then
						local v187 = 0 - 0;
						while true do
							if (((3191 + 898) == (12533 - 8444)) and (v187 == (3 - 1))) then
								print("longer: ", v11.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if (((5357 - (503 + 396)) >= (1855 - (92 + 89))) and (v187 == (0 - 0))) then
								print("have: ", v11.APLVar.RtB_Buffs.Total);
								print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
								v187 = 1 + 0;
							end
							if (((576 + 396) <= (5553 - 4135)) and (v187 == (1 + 0))) then
								print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v11.APLVar.RtB_Buffs.Normal);
								v187 = 4 - 2;
							end
						end
					end
					break;
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v113(v134)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v134] and true) or false;
	end
	local function v114()
		if (not v11.APLVar.RtB_Reroll or ((4309 + 629) < (2275 + 2487))) then
			if ((v65 == "1+ Buff") or ((7626 - 5122) > (533 + 3731))) then
				v11.APLVar.RtB_Reroll = ((v112() <= (0 - 0)) and true) or false;
			elseif (((3397 - (485 + 759)) == (4981 - 2828)) and (v65 == "Broadside")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
			elseif ((v65 == "Buried Treasure") or ((1696 - (442 + 747)) >= (3726 - (832 + 303)))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
			elseif (((5427 - (88 + 858)) == (1366 + 3115)) and (v65 == "Grand Melee")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
			elseif ((v65 == "Skull and Crossbones") or ((1927 + 401) < (29 + 664))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
			elseif (((5117 - (766 + 23)) == (21366 - 17038)) and (v65 == "Ruthless Precision")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
			elseif (((2171 - 583) >= (3509 - 2177)) and (v65 == "True Bearing")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
			else
				local v210 = 0 - 0;
				while true do
					if ((v210 == (1074 - (1036 + 37))) or ((2960 + 1214) > (8272 - 4024))) then
						v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (2 + 0))));
						if ((v85.Crackshot:IsAvailable() and not v16:HasTier(1511 - (641 + 839), 917 - (910 + 3))) or ((11691 - 7105) <= (1766 - (1466 + 218)))) then
							v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
						end
						v210 = 1150 - (556 + 592);
					end
					if (((1374 + 2489) == (4671 - (329 + 479))) and (v210 == (854 - (174 + 680)))) then
						v11.APLVar.RtB_Reroll = false;
						v112();
						v210 = 3 - 2;
					end
					if ((v210 == (5 - 2)) or ((202 + 80) <= (781 - (396 + 343)))) then
						v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v11.APLVar.RtB_Buffs.Normal == (1477 - (29 + 1448))) and (v11.APLVar.RtB_Buffs.Longer >= (1390 - (135 + 1254))) and (v112() < (22 - 16)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (182 - 143)) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
						if (((3072 + 1537) >= (2293 - (389 + 1138))) and (v17:FilteredTimeToDie("<", 586 - (102 + 472)) or v10.BossFilteredFightRemains("<", 12 + 0))) then
							v11.APLVar.RtB_Reroll = false;
						end
						break;
					end
					if ((v210 == (2 + 0)) or ((1075 + 77) == (4033 - (320 + 1225)))) then
						if (((6091 - 2669) > (2050 + 1300)) and v85.Crackshot:IsAvailable() and v16:HasTier(1495 - (157 + 1307), 1863 - (821 + 1038))) then
							v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((2 - 1) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
						end
						if (((96 + 781) > (667 - 291)) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < (1 + 1 + v22(v113(v85.GrandMelee)))) and (v94 < (4 - 2))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v210 = 1029 - (834 + 192);
					end
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1 + 0)) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= (1 + 1 + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (2 + 48));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (2 - 0)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v135 = 304 - (300 + 4);
		while true do
			if ((v135 == (1 + 0)) or ((8162 - 5044) <= (2213 - (112 + 250)))) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (3 + 3)) or not v68) and not v16:StealthUp(true, false)) or ((413 - 248) >= (2001 + 1491))) then
					if (((2043 + 1906) < (3632 + 1224)) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((2121 + 2155) < (2241 + 775))) then
					if (((6104 - (1001 + 413)) > (9198 - 5073)) and v12(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance";
					end
				end
				v135 = 884 - (244 + 638);
			end
			if ((v135 == (695 - (627 + 66))) or ((148 - 98) >= (1498 - (512 + 90)))) then
				if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (1936 - (1665 + 241))) or ((v85.KeepItRolling:CooldownRemains() >= (837 - (373 + 344))) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((774 + 940) >= (783 + 2175))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((3932 - 2441) < (1089 - 445))) then
						return "Cast Shadow Dance";
					end
				end
				if (((1803 - (35 + 1064)) < (719 + 268)) and v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) then
					if (((7954 - 4236) > (8 + 1898)) and ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())))) then
						if (v10.Cast(v85.Shadowmeld, v31) or ((2194 - (298 + 938)) > (4894 - (233 + 1026)))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((5167 - (636 + 1030)) <= (2297 + 2195)) and (v135 == (0 + 0))) then
				if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (2 + 4))) and v116()) or ((233 + 3209) < (2769 - (55 + 166)))) then
					if (((558 + 2317) >= (148 + 1316)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) or ((18320 - 13523) >= (5190 - (36 + 261)))) then
					if (v10.Cast(v85.Vanish, v68) or ((963 - 412) > (3436 - (34 + 1334)))) then
						return "Cast Vanish (Finish)";
					end
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v121()
		local v136 = v83.HandleTopTrinket(v88, v29, 32 + 8, nil);
		if (((3397 - (1035 + 248)) > (965 - (20 + 1))) and v136) then
			return v136;
		end
		local v136 = v83.HandleBottomTrinket(v88, v29, 21 + 19, nil);
		if (v136 or ((2581 - (134 + 185)) >= (4229 - (549 + 584)))) then
			return v136;
		end
	end
	local function v122()
		local v137 = 685 - (314 + 371);
		local v138;
		local v139;
		while true do
			if (((20 - 14) == v137) or ((3223 - (478 + 490)) >= (1874 + 1663))) then
				if (v85.AncestralCall:IsCastable() or ((5009 - (786 + 386)) < (4229 - 2923))) then
					if (((4329 - (1055 + 324)) == (4290 - (1093 + 247))) and v10.Cast(v85.AncestralCall, nil, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if ((v137 == (0 + 0)) or ((497 + 4226) < (13093 - 9795))) then
				v138 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (((3855 - 2719) >= (437 - 283)) and v138) then
					return "DPS Pot";
				end
				if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (4 - 2))))) or ((97 + 174) > (18291 - 13543))) then
					if (((16337 - 11597) >= (2377 + 775)) and v12(v85.AdrenalineRush, v76)) then
						return "Cast Adrenaline Rush";
					end
				end
				v137 = 2 - 1;
			end
			if (((689 - (364 + 324)) == v137) or ((7067 - 4489) >= (8134 - 4744))) then
				if (((14 + 27) <= (6950 - 5289)) and v85.BladeFlurry:IsReady()) then
					if (((962 - 361) < (10812 - 7252)) and (v94 >= ((1270 - (1249 + 19)) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) then
						if (((213 + 22) < (2673 - 1986)) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((5635 - (686 + 400)) > (905 + 248)) and v85.BladeFlurry:IsReady()) then
					if ((v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (232 - (73 + 156))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (1 + 4)))) or ((5485 - (721 + 90)) < (53 + 4619))) then
						if (((11909 - 8241) < (5031 - (224 + 246))) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v85.RolltheBones:IsReady() or ((737 - 282) == (6637 - 3032))) then
					if (v114() or (v112() == (0 + 0)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (1 + 2)) and v16:HasTier(23 + 8, 7 - 3)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (23 - 16)) and ((v85.ShadowDance:CooldownRemains() <= (516 - (203 + 310))) or (v85.Vanish:CooldownRemains() <= (1996 - (1238 + 755))))) or ((187 + 2476) == (4846 - (709 + 825)))) then
						if (((7881 - 3604) <= (6518 - 2043)) and v12(v85.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v137 = 866 - (196 + 668);
			end
			if ((v137 == (19 - 14)) or ((1802 - 932) == (2022 - (171 + 662)))) then
				if (((1646 - (4 + 89)) <= (10980 - 7847)) and v85.BloodFury:IsCastable()) then
					if (v10.Cast(v85.BloodFury, nil, v31) or ((815 + 1422) >= (15421 - 11910))) then
						return "Cast Blood Fury";
					end
				end
				if (v85.Berserking:IsCastable() or ((520 + 804) > (4506 - (35 + 1451)))) then
					if (v10.Cast(v85.Berserking, nil, v31) or ((4445 - (28 + 1425)) == (3874 - (941 + 1052)))) then
						return "Cast Berserking";
					end
				end
				if (((2979 + 127) > (3040 - (822 + 692))) and v85.Fireblood:IsCastable()) then
					if (((4314 - 1291) < (1823 + 2047)) and v10.Cast(v85.Fireblood, nil, v31)) then
						return "Cast Fireblood";
					end
				end
				v137 = 303 - (45 + 252);
			end
			if (((142 + 1) > (26 + 48)) and (v137 == (9 - 5))) then
				if (((451 - (114 + 319)) < (3031 - 919)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
					local v182 = 0 - 0;
					while true do
						if (((700 + 397) <= (2425 - 797)) and (v182 == (0 - 0))) then
							v139 = v120();
							if (((6593 - (556 + 1407)) == (5836 - (741 + 465))) and v139) then
								return v139;
							end
							break;
						end
					end
				end
				if (((4005 - (170 + 295)) > (1414 + 1269)) and v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (92 + 8)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (14 - 8)))) then
					if (((3975 + 819) >= (2101 + 1174)) and v10.Cast(v85.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (((841 + 643) == (2714 - (957 + 273))) and v85.BladeRush:IsCastable() and (v103 > (2 + 2)) and not v16:StealthUp(true, true)) then
					if (((574 + 858) < (13546 - 9991)) and v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 13 - 8;
			end
			if ((v137 == (9 - 6)) or ((5273 - 4208) > (5358 - (389 + 1391)))) then
				if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (5 + 2))) or ((500 + 4295) < (3202 - 1795))) then
					if (((2804 - (783 + 168)) < (16153 - 11340)) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((2775 + 46) < (2742 - (309 + 2)))) then
					if ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 33 - 22) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1223 - (1090 + 122)) or ((932 + 1942) < (7324 - 5143))) then
						if (v10.Cast(v85.Sepsis) or ((1841 + 848) <= (1461 - (628 + 490)))) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v85.BladeRush:IsReady() and (v103 > (1 + 3)) and not v16:StealthUp(true, true)) or ((4627 - 2758) == (9181 - 7172))) then
					if (v10.Cast(v85.BladeRush) or ((4320 - (431 + 343)) < (4689 - 2367))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 11 - 7;
			end
			if ((v137 == (2 + 0)) or ((267 + 1815) == (6468 - (556 + 1139)))) then
				v139 = v121();
				if (((3259 - (6 + 9)) > (194 + 861)) and v139) then
					return v139;
				end
				if ((v85.KeepItRolling:IsReady() and not v114() and (v112() >= (2 + 1 + v22(v16:HasTier(200 - (28 + 141), 2 + 2)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (7 - 1)))) or ((2347 + 966) <= (3095 - (486 + 831)))) then
					if (v10.Cast(v85.KeepItRolling) or ((3697 - 2276) >= (7407 - 5303))) then
						return "Cast Keep it Rolling";
					end
				end
				v137 = 1 + 2;
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if (((3075 - (668 + 595)) <= (2924 + 325)) and (v140 == (0 + 0))) then
				if (((4425 - 2802) <= (2247 - (23 + 267))) and v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (1946 - (1129 + 815))) and (v16:BuffRemains(v85.BladeFlurry) <= v16:GCD()) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
					if (((4799 - (371 + 16)) == (6162 - (1326 + 424))) and v71) then
						v10.Cast(v85.BladeFlurry);
					elseif (((3314 - 1564) >= (3076 - 2234)) and v10.Cast(v85.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((4490 - (88 + 30)) > (2621 - (720 + 51))) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (((515 - 283) < (2597 - (421 + 1355))) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				v140 = 1 - 0;
			end
			if (((255 + 263) < (1985 - (286 + 797))) and ((7 - 5) == v140)) then
				if (((4959 - 1965) > (1297 - (397 + 42))) and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (1 + 1)) and (v16:BuffStack(v85.Opportunity) >= (806 - (24 + 776))) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 - 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) then
					if (v10.Press(v85.PistolShot) or ((4540 - (222 + 563)) <= (2016 - 1101))) then
						return "Cast Pistol Shot";
					end
				end
				if (((2842 + 1104) > (3933 - (23 + 167))) and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
					if (v10.Cast(v85.SinisterStrike, nil, not v17:IsSpellInRange(v85.Ambush)) or ((3133 - (690 + 1108)) >= (1193 + 2113))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 3 + 0;
			end
			if (((5692 - (40 + 808)) > (371 + 1882)) and (v140 == (3 - 2))) then
				if (((433 + 19) == (240 + 212)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) then
					if (v10.Cast(v85.BetweentheEyes) or ((2499 + 2058) < (2658 - (47 + 524)))) then
						return "Cast Between the Eyes";
					end
				end
				if (((2515 + 1359) == (10589 - 6715)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (v10.Press(v85.Dispatch) or ((2897 - 959) > (11254 - 6319))) then
						return "Cast Dispatch";
					end
				end
				v140 = 1728 - (1165 + 561);
			end
			if (((1 + 2) == v140) or ((13178 - 8923) < (1307 + 2116))) then
				if (((1933 - (341 + 138)) <= (673 + 1818)) and v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) then
					if (v10.Press(v85.Ambush) or ((8578 - 4421) <= (3129 - (89 + 237)))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v141 = 0 - 0;
		while true do
			if (((10217 - 5364) >= (3863 - (581 + 300))) and ((1220 - (855 + 365)) == v141)) then
				if (((9819 - 5685) > (1097 + 2260)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (1239 - (1030 + 205))) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(29 + 1, 4 + 0)) and v16:BuffDown(v85.GreenskinsWickers)) then
					if (v10.Press(v85.BetweentheEyes) or ((3703 - (156 + 130)) < (5757 - 3223))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (75 - 30)) and (v85.ShadowDance:CooldownRemains() > (23 - 11))) or ((718 + 2004) <= (96 + 68))) then
					if (v10.Press(v85.BetweentheEyes) or ((2477 - (10 + 59)) < (597 + 1512))) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 4 - 3;
			end
			if ((v141 == (1165 - (671 + 492))) or ((27 + 6) == (2670 - (369 + 846)))) then
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((118 + 325) >= (3427 + 588))) then
					if (((5327 - (1036 + 909)) > (132 + 34)) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) or ((470 - 190) == (3262 - (11 + 192)))) then
					if (((951 + 930) > (1468 - (135 + 40))) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((5710 - 3353) == (1421 + 936)) and (v141 == (2 - 1))) then
				if (((184 - 61) == (299 - (50 + 126))) and v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 - 0))) and (v16:BuffRemains(v85.SliceandDice) < ((1 + 0 + v98) * (1414.8 - (1233 + 180))))) then
					if (v10.Press(v85.SliceandDice) or ((2025 - (522 + 447)) >= (4813 - (107 + 1314)))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((502 + 579) < (3275 - 2200))) then
					if (v10.Cast(v85.KillingSpree) or ((446 + 603) >= (8800 - 4368))) then
						return "Cast Killing Spree";
					end
				end
				v141 = 7 - 5;
			end
		end
	end
	local function v125()
		if ((v29 and v85.EchoingReprimand:IsReady()) or ((6678 - (716 + 1194)) <= (15 + 831))) then
			if (v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand)) or ((360 + 2998) <= (1923 - (74 + 429)))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((7212 - 3473) <= (1490 + 1515))) then
			if (v10.Press(v85.Ambush) or ((3797 - 2138) >= (1510 + 624))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((10050 - 6790) < (5822 - 3467))) then
			if (v10.Press(v85.PistolShot) or ((1102 - (279 + 154)) == (5001 - (454 + 324)))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (5 + 1)) or (v16:BuffRemains(v85.Opportunity) < (19 - (12 + 5))))) or ((913 + 779) < (1498 - 910))) then
			if (v10.Press(v85.PistolShot) or ((1773 + 3024) < (4744 - (277 + 816)))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((4 - 3) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (1184 - (1058 + 125)))))) or (v98 <= (1 + 0)))) or ((5152 - (815 + 160)) > (20809 - 15959))) then
			if (v10.Press(v85.PistolShot) or ((949 - 549) > (266 + 845))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if (((8918 - 5867) > (2903 - (41 + 1857))) and not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1894.5 - (1222 + 671))) or (v99 <= ((2 - 1) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) then
			if (((5307 - 1614) <= (5564 - (229 + 953))) and v10.Cast(v85.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (v85.SinisterStrike:IsCastable() or ((5056 - (1111 + 663)) > (5679 - (874 + 705)))) then
			if (v10.Press(v85.SinisterStrike) or ((502 + 3078) < (1941 + 903))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v126()
		local v142 = 0 - 0;
		while true do
			if (((3 + 86) < (5169 - (642 + 37))) and (v142 == (2 + 6))) then
				if (v83.TargetIsValid() or ((798 + 4185) < (4539 - 2731))) then
					v95 = v122();
					if (((4283 - (233 + 221)) > (8715 - 4946)) and v95) then
						return "CDs: " .. v95;
					end
					if (((1308 + 177) <= (4445 - (718 + 823))) and (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld))) then
						local v188 = 0 + 0;
						while true do
							if (((5074 - (266 + 539)) == (12086 - 7817)) and (v188 == (1225 - (636 + 589)))) then
								v95 = v123();
								if (((918 - 531) <= (5737 - 2955)) and v95) then
									return "Stealth: " .. v95;
								end
								break;
							end
						end
					end
					if (v115() or ((1505 + 394) <= (334 + 583))) then
						local v189 = 1015 - (657 + 358);
						while true do
							if ((v189 == (0 - 0)) or ((9823 - 5511) <= (2063 - (1151 + 36)))) then
								v95 = v124();
								if (((2156 + 76) <= (683 + 1913)) and v95) then
									return "Finish: " .. v95;
								end
								v189 = 2 - 1;
							end
							if (((3927 - (1552 + 280)) < (4520 - (64 + 770))) and (v189 == (1 + 0))) then
								return "Finish Pooling";
							end
						end
					end
					v95 = v125();
					if (v95 or ((3620 - 2025) >= (795 + 3679))) then
						return "Build: " .. v95;
					end
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > ((1258 - (157 + 1086)) + v101))) or ((9244 - 4625) < (12622 - 9740))) then
						if (v10.Cast(v85.ArcaneTorrent, v31) or ((450 - 156) >= (6593 - 1762))) then
							return "Cast Arcane Torrent";
						end
					end
					if (((2848 - (599 + 220)) <= (6141 - 3057)) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
						if (v10.Cast(v85.ArcanePulse) or ((3968 - (1813 + 118)) == (1769 + 651))) then
							return "Cast Arcane Pulse";
						end
					end
					if (((5675 - (841 + 376)) > (5470 - 1566)) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(2 + 3)) then
						if (((1190 - 754) >= (982 - (464 + 395))) and v10.Cast(v85.LightsJudgment, v31)) then
							return "Cast Lights Judgment";
						end
					end
					if (((1283 - 783) < (873 + 943)) and v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(842 - (467 + 370))) then
						if (((7385 - 3811) == (2624 + 950)) and v10.Cast(v85.BagofTricks, v31)) then
							return "Cast Bag of Tricks";
						end
					end
					if (((757 - 536) < (61 + 329)) and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (58 - 33)) and ((v99 >= (521 - (150 + 370))) or (v103 <= (1283.2 - (74 + 1208))))) then
						if (v10.Cast(v85.PistolShot) or ((5443 - 3230) <= (6739 - 5318))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((2176 + 882) < (5250 - (14 + 376))) and v85.SinisterStrike:IsCastable()) then
						if (v10.Cast(v85.SinisterStrike) or ((2247 - 951) >= (2877 + 1569))) then
							return "Cast Sinister Strike Filler";
						end
					end
				end
				break;
			end
			if ((v142 == (4 + 0)) or ((1329 + 64) > (13153 - 8664))) then
				if (v28 or ((3329 + 1095) < (105 - (23 + 55)))) then
					v92 = v16:GetEnemiesInRange(71 - 41);
					v93 = v16:GetEnemiesInRange(v96);
					v94 = #v93;
				else
					v94 = 1 + 0;
				end
				v95 = v84.CrimsonVial();
				if (v95 or ((1794 + 203) > (5915 - 2100))) then
					return v95;
				end
				v142 = 2 + 3;
			end
			if (((4366 - (652 + 249)) > (5119 - 3206)) and (v142 == (1869 - (708 + 1160)))) then
				v29 = EpicSettings.Toggles['cds'];
				v98 = v16:ComboPoints();
				v97 = v84.EffectiveComboPoints(v98);
				v142 = 5 - 3;
			end
			if (((1336 - 603) < (1846 - (10 + 17))) and (v142 == (1 + 1))) then
				v99 = v16:ComboPointsDeficit();
				v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(1782 - (1400 + 332))) or (0 - 0);
				v100 = v109();
				v142 = 1911 - (242 + 1666);
			end
			if ((v142 == (3 + 4)) or ((1611 + 2784) == (4053 + 702))) then
				if ((not v16:AffectingCombat() and not v16:IsMounted() and v60) or ((4733 - (850 + 90)) < (4148 - 1779))) then
					v95 = v84.Stealth(v85.Stealth2, nil);
					if (v95 or ((5474 - (360 + 1030)) == (235 + 30))) then
						return "Stealth (OOC): " .. v95;
					end
				end
				if (((12300 - 7942) == (5995 - 1637)) and not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1662 - (909 + 752))) and v17:IsInRange(1231 - (109 + 1114)) and v27) then
					if ((v83.TargetIsValid() and v17:IsInRange(18 - 8) and not (v16:IsChanneling() or v16:IsCasting())) or ((1222 + 1916) < (1235 - (6 + 236)))) then
						if (((2099 + 1231) > (1870 + 453)) and v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
							if (v12(v85.BladeFlurry) or ((8551 - 4925) == (6967 - 2978))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v16:StealthUp(true, false) or ((2049 - (1076 + 57)) == (440 + 2231))) then
							local v194 = 689 - (579 + 110);
							while true do
								if (((22 + 250) == (241 + 31)) and (v194 == (0 + 0))) then
									v95 = v84.Stealth(v84.StealthSpell());
									if (((4656 - (174 + 233)) <= (13516 - 8677)) and v95) then
										return v95;
									end
									break;
								end
							end
						end
						if (((4873 - 2096) < (1423 + 1777)) and v83.TargetIsValid()) then
							local v195 = 1174 - (663 + 511);
							while true do
								if (((85 + 10) < (425 + 1532)) and (v195 == (0 - 0))) then
									if (((501 + 325) < (4042 - 2325)) and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (4 - 2))) then
										if (((681 + 745) >= (2150 - 1045)) and v10.Cast(v85.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if (((1963 + 791) <= (309 + 3070)) and v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (722 - (478 + 244))) or v114())) then
										if (v10.Cast(v85.RolltheBones) or ((4444 - (440 + 77)) == (643 + 770))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v195 = 3 - 2;
								end
								if ((v195 == (1557 - (655 + 901))) or ((214 + 940) <= (604 + 184))) then
									if ((v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < ((1 + 0 + v98) * (3.8 - 2)))) or ((3088 - (695 + 750)) > (11538 - 8159))) then
										if (v10.Press(v85.SliceandDice) or ((4325 - 1522) > (18294 - 13745))) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v16:StealthUp(true, false) or ((571 - (285 + 66)) >= (7044 - 4022))) then
										local v205 = 1310 - (682 + 628);
										while true do
											if (((455 + 2367) == (3121 - (176 + 123))) and (v205 == (1 + 0))) then
												if ((v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) or ((770 + 291) == (2126 - (239 + 30)))) then
													if (((751 + 2009) > (1311 + 53)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) or ((8675 - 3773) <= (11215 - 7620))) then
													if (v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush)) or ((4167 - (306 + 9)) == (1022 - 729))) then
														return "Cast Ambush (Opener)";
													end
												elseif (v85.SinisterStrike:IsCastable() or ((272 + 1287) == (2815 + 1773))) then
													if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((2159 + 2325) == (2253 - 1465))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
												break;
											end
											if (((5943 - (1140 + 235)) >= (2487 + 1420)) and (v205 == (0 + 0))) then
												v95 = v123();
												if (((320 + 926) < (3522 - (33 + 19))) and v95) then
													return "Stealth (Opener): " .. v95;
												end
												v205 = 1 + 0;
											end
										end
									elseif (((12192 - 8124) >= (429 + 543)) and v115()) then
										local v211 = 0 - 0;
										while true do
											if (((463 + 30) < (4582 - (586 + 103))) and (v211 == (0 + 0))) then
												v95 = v124();
												if (v95 or ((4534 - 3061) >= (4820 - (1309 + 179)))) then
													return "Finish (Opener): " .. v95;
												end
												break;
											end
										end
									end
									v195 = 2 - 0;
								end
								if ((v195 == (1 + 1)) or ((10879 - 6828) <= (874 + 283))) then
									if (((1282 - 678) < (5740 - 2859)) and v85.SinisterStrike:IsCastable()) then
										if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((1509 - (295 + 314)) == (8294 - 4917))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
							end
						end
						return;
					end
				end
				if (((6421 - (1300 + 662)) > (1855 - 1264)) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
					v98 = v26(v98, v84.FanTheHammerCP());
					v97 = v84.EffectiveComboPoints(v98);
					v99 = v16:ComboPointsDeficit();
				end
				v142 = 1763 - (1178 + 577);
			end
			if (((1765 + 1633) >= (7079 - 4684)) and (v142 == (1408 - (851 + 554)))) then
				v101 = v16:EnergyRegen();
				v103 = v108(v104);
				v102 = v16:EnergyDeficitPredicted(nil, v104);
				v142 = 4 + 0;
			end
			if ((v142 == (16 - 10)) or ((4741 - 2558) >= (3126 - (115 + 187)))) then
				if (((1483 + 453) == (1833 + 103)) and v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) then
					if (v10.Cast(v85.Evasion) or ((19041 - 14209) < (5474 - (160 + 1001)))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((3577 + 511) > (2673 + 1201)) and not v16:IsCasting() and not v16:IsChanneling()) then
					local v183 = v83.Interrupt(v85.Kick, 16 - 8, true);
					if (((4690 - (237 + 121)) == (5229 - (525 + 372))) and v183) then
						return v183;
					end
					v183 = v83.Interrupt(v85.Kick, 14 - 6, true, v13, v87.KickMouseover);
					if (((13139 - 9140) >= (3042 - (96 + 46))) and v183) then
						return v183;
					end
					v183 = v83.Interrupt(v85.Blind, 792 - (643 + 134), v80);
					if (v183 or ((912 + 1613) > (9744 - 5680))) then
						return v183;
					end
					v183 = v83.Interrupt(v85.Blind, 55 - 40, v80, v13, v87.BlindMouseover);
					if (((4192 + 179) == (8578 - 4207)) and v183) then
						return v183;
					end
					v183 = v83.InterruptWithStun(v85.CheapShot, 16 - 8, v16:StealthUp(false, false));
					if (v183 or ((985 - (316 + 403)) > (3315 + 1671))) then
						return v183;
					end
					v183 = v83.InterruptWithStun(v85.KidneyShot, 21 - 13, v16:ComboPoints() > (0 + 0));
					if (((5013 - 3022) >= (656 + 269)) and v183) then
						return v183;
					end
				end
				if (((147 + 308) < (7113 - 5060)) and v30) then
					v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 143 - 113, true);
					if (v95 or ((1715 - 889) == (278 + 4573))) then
						return v95;
					end
				end
				v142 = 13 - 6;
			end
			if (((9 + 174) == (538 - 355)) and (v142 == (22 - (12 + 5)))) then
				v84.Poisons();
				if (((4501 - 3342) <= (3814 - 2026)) and v33 and (v16:HealthPercentage() <= v35)) then
					if ((v34 == "Refreshing Healing Potion") or ((7454 - 3947) > (10708 - 6390))) then
						if (v86.RefreshingHealingPotion:IsReady() or ((625 + 2450) <= (4938 - (1656 + 317)))) then
							if (((1217 + 148) <= (1612 + 399)) and v10.Press(v87.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v34 == "Dreamwalker's Healing Potion") or ((7381 - 4605) > (17594 - 14019))) then
						if (v86.DreamwalkersHealingPotion:IsReady() or ((2908 - (5 + 349)) == (22818 - 18014))) then
							if (((3848 - (266 + 1005)) == (1699 + 878)) and v10.Press(v87.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if ((v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) or ((20 - 14) >= (2486 - 597))) then
					if (((2202 - (561 + 1135)) <= (2464 - 572)) and v10.Cast(v85.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v142 = 19 - 13;
			end
			if ((v142 == (1066 - (507 + 559))) or ((5038 - 3030) > (6859 - 4641))) then
				v82();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v142 = 389 - (212 + 176);
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1165 - (250 + 655), v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

