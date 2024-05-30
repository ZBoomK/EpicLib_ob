local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((895 - 523) <= (137 + 784)) and ((1034 - (125 + 909)) == v5)) then
			v6 = v0[v4];
			if (((5647 - (1096 + 852)) < (2111 + 2595)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((2567 + 79) >= (1388 - (409 + 103))) and (v5 == (237 - (46 + 190)))) then
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
		local v128 = 95 - (51 + 44);
		while true do
			if (((174 + 440) <= (4501 - (1114 + 203))) and (v128 == (726 - (228 + 498)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v128 = 1 + 0;
			end
			if (((3789 - (174 + 489)) == (8143 - 5017)) and (v128 == (1911 - (830 + 1075)))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v79 = EpicSettings.Settings['sepsis'];
				v128 = 531 - (303 + 221);
			end
			if ((v128 == (1274 - (231 + 1038))) or ((1823 + 364) >= (6116 - (171 + 991)))) then
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 24 - 18;
			end
			if (((10 - 6) == v128) or ((9674 - 5797) == (2862 + 713))) then
				v59 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v60 = EpicSettings.Settings['StealthOOC'];
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v128 = 14 - 9;
			end
			if (((1138 - 431) > (1953 - 1321)) and (v128 == (1250 - (111 + 1137)))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (158 - (91 + 67));
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 8 - 5;
			end
			if ((v128 == (2 + 5)) or ((1069 - (423 + 100)) >= (19 + 2665))) then
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if (((764 + 701) <= (5072 - (326 + 445))) and (v128 == (13 - 10))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v128 = 9 - 5;
			end
			if (((2415 - (530 + 181)) > (2306 - (614 + 267))) and (v128 == (33 - (19 + 13)))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v128 = 4 - 2;
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
	local v90 = (v89[37 - 24] and v20(v89[4 + 9])) or v20(0 - 0);
	local v91 = (v89[28 - 14] and v20(v89[1826 - (1293 + 519)])) or v20(0 - 0);
	v10:RegisterForEvent(function()
		v89 = v16:GetEquipment();
		v90 = (v89[33 - 20] and v20(v89[24 - 11])) or v20(0 - 0);
		v91 = (v89[32 - 18] and v20(v89[8 + 6])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 13 - 7;
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 0 + 0, 0 - 0;
	local function v108(v129)
		local v130 = 0 + 0;
		local v131;
		while true do
			if (((0 - 0) == v130) or ((1348 - 661) == (6114 - (446 + 1434)))) then
				v131 = v16:EnergyTimeToMaxPredicted(nil, v129);
				if ((v131 < v106) or ((v131 - v106) > (1283.5 - (1040 + 243))) or ((9938 - 6608) < (3276 - (559 + 1288)))) then
					v106 = v131;
				end
				v130 = 1932 - (609 + 1322);
			end
			if (((1601 - (13 + 441)) >= (1251 - 916)) and (v130 == (2 - 1))) then
				return v106;
			end
		end
	end
	local function v109()
		local v132 = 0 - 0;
		local v133;
		while true do
			if (((128 + 3307) > (7615 - 5518)) and (v132 == (0 + 0))) then
				v133 = v16:EnergyPredicted();
				if ((v133 > v107) or ((v133 - v107) > (4 + 5)) or ((11187 - 7417) >= (2212 + 1829))) then
					v107 = v133;
				end
				v132 = 1 - 0;
			end
			if (((1 + 0) == v132) or ((2109 + 1682) <= (1158 + 453))) then
				return v107;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 + 0)) or ((3318 + 1260) <= (3057 - 1049))) then
				if (((696 + 429) <= (2743 - (89 + 578))) and not v11.APLVar.RtB_Buffs) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v11.APLVar.RtB_Buffs.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Normal = 1049 - (572 + 477);
					v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v11.APLVar.RtB_Buffs.Longer = 0 + 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					local v182 = v84.RtBRemains();
					for v191 = 87 - (84 + 2), #v110 do
						local v192 = v16:BuffRemains(v110[v191]);
						if ((v192 > (0 - 0)) or ((536 + 207) >= (5241 - (497 + 345)))) then
							v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
							if (((196 + 959) < (3006 - (605 + 728))) and (v192 > v11.APLVar.RtB_Buffs.MaxRemains)) then
								v11.APLVar.RtB_Buffs.MaxRemains = v192;
							end
							local v195 = math.abs(v192 - v182);
							if ((v195 <= (0.5 + 0)) or ((5166 - 2842) <= (27 + 551))) then
								local v201 = 0 - 0;
								while true do
									if (((3396 + 371) == (10436 - 6669)) and (v201 == (1 + 0))) then
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (490 - (457 + 32));
										break;
									end
									if (((1735 + 2354) == (5491 - (832 + 570))) and (v201 == (0 + 0))) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v191]:Name()] = true;
										v201 = 3 - 2;
									end
								end
							elseif (((2148 + 2310) >= (2470 - (588 + 208))) and (v192 > v182)) then
								v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (2 - 1);
							else
								local v205 = 1800 - (884 + 916);
								while true do
									if (((2034 - 1062) <= (823 + 595)) and ((654 - (232 + 421)) == v205)) then
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1890 - (1569 + 320));
										break;
									end
									if ((v205 == (0 + 0)) or ((939 + 3999) < (16046 - 11284))) then
										v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (606 - (316 + 289));
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v191]:Name()] = true;
										v205 = 2 - 1;
									end
								end
							end
						end
						if (v111 or ((116 + 2388) > (5717 - (666 + 787)))) then
							local v196 = 425 - (360 + 65);
							while true do
								if (((2013 + 140) == (2407 - (79 + 175))) and (v196 == (0 - 0))) then
									print("RtbRemains", v182);
									print(v110[v191]:Name(), v192);
									break;
								end
							end
						end
					end
					if (v111 or ((396 + 111) >= (7941 - 5350))) then
						print("have: ", v11.APLVar.RtB_Buffs.Total);
						print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v11.APLVar.RtB_Buffs.Normal);
						print("longer: ", v11.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
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
		if (((8629 - 4148) == (5380 - (503 + 396))) and not v11.APLVar.RtB_Reroll) then
			if ((v65 == "1+ Buff") or ((2509 - (92 + 89)) < (1343 - 650))) then
				v11.APLVar.RtB_Reroll = ((v112() <= (0 + 0)) and true) or false;
			elseif (((2562 + 1766) == (16949 - 12621)) and (v65 == "Broadside")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
			elseif (((218 + 1370) >= (3036 - 1704)) and (v65 == "Buried Treasure")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
			elseif ((v65 == "Grand Melee") or ((3642 + 532) > (2029 + 2219))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
			elseif ((v65 == "Skull and Crossbones") or ((13967 - 9381) <= (11 + 71))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
			elseif (((5890 - 2027) == (5107 - (485 + 759))) and (v65 == "Ruthless Precision")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
			elseif ((v65 == "True Bearing") or ((652 - 370) <= (1231 - (442 + 747)))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
			else
				v11.APLVar.RtB_Reroll = false;
				v112();
				v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (1137 - (832 + 303)))));
				if (((5555 - (88 + 858)) >= (234 + 532)) and v85.Crackshot:IsAvailable() and not v16:HasTier(26 + 5, 1 + 3)) then
					v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (790 - (766 + 23))));
				end
				if ((v85.Crackshot:IsAvailable() and v16:HasTier(153 - 122, 5 - 1)) or ((3034 - 1882) == (8444 - 5956))) then
					v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((1074 - (1036 + 37)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
				end
				if (((2427 + 995) > (6523 - 3173)) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < (2 + 0 + v22(v113(v85.GrandMelee)))) and (v94 < (1482 - (641 + 839)))) then
					v11.APLVar.RtB_Reroll = true;
				end
				v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (913 - (910 + 3))) or ((v11.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1685 - (1466 + 218))) and (v112() < (3 + 3)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (1187 - (556 + 592))) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
				if (((312 + 565) > (1184 - (329 + 479))) and (v17:FilteredTimeToDie("<", 866 - (174 + 680)) or v10.BossFilteredFightRemains("<", 41 - 29))) then
					v11.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1 - 0)) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= (2 + 0 + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (789 - (396 + 343)));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (1 + 1)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v136 = 1477 - (29 + 1448);
		while true do
			if ((v136 == (1389 - (135 + 1254))) or ((11746 - 8628) <= (8642 - 6791))) then
				if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (4 + 2))) and v116()) or ((1692 - (389 + 1138)) >= (4066 - (102 + 472)))) then
					if (((3727 + 222) < (2693 + 2163)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) or ((3988 + 288) < (4561 - (320 + 1225)))) then
					if (((8349 - 3659) > (2524 + 1601)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (Finish)";
					end
				end
				v136 = 1465 - (157 + 1307);
			end
			if ((v136 == (1861 - (821 + 1038))) or ((124 - 74) >= (98 + 798))) then
				if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (53 - 23)) or ((v85.KeepItRolling:CooldownRemains() >= (45 + 75)) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((4248 - 2534) >= (3984 - (834 + 192)))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((95 + 1396) < (166 + 478))) then
						return "Cast Shadow Dance";
					end
				end
				if (((16 + 688) < (1528 - 541)) and v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) then
					if (((4022 - (300 + 4)) > (510 + 1396)) and ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())))) then
						if (v10.Cast(v85.Shadowmeld, v31) or ((2507 - 1549) > (3997 - (112 + 250)))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((1396 + 2105) <= (11253 - 6761)) and (v136 == (1 + 0))) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (4 + 2)) or not v68) and not v16:StealthUp(true, false)) or ((2575 + 867) < (1264 + 1284))) then
					if (((2136 + 739) >= (2878 - (1001 + 413))) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((10697 - 5900) >= (5775 - (244 + 638)))) then
					if (v12(v85.ShadowDance, v54) or ((1244 - (627 + 66)) > (6161 - 4093))) then
						return "Cast Shadow Dance";
					end
				end
				v136 = 604 - (512 + 90);
			end
		end
	end
	local function v121()
		local v137 = 1906 - (1665 + 241);
		local v138;
		while true do
			if (((2831 - (373 + 344)) > (426 + 518)) and (v137 == (1 + 0))) then
				v138 = v83.HandleBottomTrinket(v88, v29, 105 - 65, nil);
				if (v138 or ((3827 - 1565) >= (4195 - (35 + 1064)))) then
					return v138;
				end
				break;
			end
			if ((v137 == (0 + 0)) or ((4824 - 2569) >= (15 + 3522))) then
				v138 = v83.HandleTopTrinket(v88, v29, 1276 - (298 + 938), nil);
				if (v138 or ((5096 - (233 + 1026)) < (2972 - (636 + 1030)))) then
					return v138;
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v122()
		local v139 = 0 + 0;
		local v140;
		local v141;
		while true do
			if (((877 + 2073) == (200 + 2750)) and (v139 == (223 - (55 + 166)))) then
				v141 = v121();
				if (v141 or ((916 + 3807) < (332 + 2966))) then
					return v141;
				end
				if (((4338 - 3202) >= (451 - (36 + 261))) and v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((4 - 1) + v22(v16:HasTier(1399 - (34 + 1334), 2 + 2)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (5 + 1)))) then
					if (v10.Cast(v85.KeepItRolling) or ((1554 - (1035 + 248)) > (4769 - (20 + 1)))) then
						return "Cast Keep it Rolling";
					end
				end
				v139 = 2 + 1;
			end
			if (((5059 - (134 + 185)) >= (4285 - (549 + 584))) and (v139 == (689 - (314 + 371)))) then
				if ((not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) or ((8850 - 6272) >= (4358 - (478 + 490)))) then
					local v183 = 0 + 0;
					while true do
						if (((1213 - (786 + 386)) <= (5379 - 3718)) and (v183 == (1379 - (1055 + 324)))) then
							v141 = v120();
							if (((1941 - (1093 + 247)) < (3164 + 396)) and v141) then
								return v141;
							end
							break;
						end
					end
				end
				if (((25 + 210) < (2727 - 2040)) and v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (339 - 239)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (16 - 10)))) then
					if (((11431 - 6882) > (411 + 742)) and v10.Cast(v85.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if ((v85.BladeRush:IsCastable() and (v103 > (15 - 11)) and not v16:StealthUp(true, true)) or ((16110 - 11436) < (3523 + 1149))) then
					if (((9380 - 5712) < (5249 - (364 + 324))) and v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v139 = 13 - 8;
			end
			if ((v139 == (0 - 0)) or ((151 + 304) == (15084 - 11479))) then
				v140 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (v140 or ((4264 - 1601) == (10058 - 6746))) then
					return "DPS Pot";
				end
				if (((5545 - (1249 + 19)) <= (4040 + 435)) and v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (7 - 5))))) then
					if (v12(v85.AdrenalineRush, v76) or ((1956 - (686 + 400)) == (933 + 256))) then
						return "Cast Adrenaline Rush";
					end
				end
				v139 = 230 - (73 + 156);
			end
			if (((8 + 1545) <= (3944 - (721 + 90))) and (v139 == (1 + 0))) then
				if (v85.BladeFlurry:IsReady() or ((7263 - 5026) >= (3981 - (224 + 246)))) then
					if (((v94 >= ((2 - 0) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) or ((2437 - 1113) > (548 + 2472))) then
						if (v12(v85.BladeFlurry) or ((72 + 2920) == (1382 + 499))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((6174 - 3068) > (5078 - 3552)) and v85.BladeFlurry:IsReady()) then
					if (((3536 - (203 + 310)) < (5863 - (1238 + 755))) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (1 + 2)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (1539 - (709 + 825))))) then
						if (((262 - 119) > (107 - 33)) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((882 - (196 + 668)) < (8338 - 6226)) and v85.RolltheBones:IsReady()) then
					if (((2272 - 1175) <= (2461 - (171 + 662))) and (v114() or (v112() == (93 - (4 + 89))) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (10 - 7)) and v16:HasTier(12 + 19, 17 - 13)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (3 + 4)) and ((v85.ShadowDance:CooldownRemains() <= (1489 - (35 + 1451))) or (v85.Vanish:CooldownRemains() <= (1456 - (28 + 1425))))))) then
						if (((6623 - (941 + 1052)) == (4440 + 190)) and v12(v85.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v139 = 1516 - (822 + 692);
			end
			if (((5053 - 1513) > (1264 + 1419)) and (v139 == (303 - (45 + 252)))) then
				if (((4744 + 50) >= (1128 + 2147)) and v85.AncestralCall:IsCastable()) then
					if (((3611 - 2127) == (1917 - (114 + 319))) and v10.Cast(v85.AncestralCall, nil, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((2055 - 623) < (4555 - 1000)) and ((4 + 1) == v139)) then
				if (v85.BloodFury:IsCastable() or ((1586 - 521) > (7496 - 3918))) then
					if (v10.Cast(v85.BloodFury, nil, v31) or ((6758 - (556 + 1407)) < (2613 - (741 + 465)))) then
						return "Cast Blood Fury";
					end
				end
				if (((2318 - (170 + 295)) < (2536 + 2277)) and v85.Berserking:IsCastable()) then
					if (v10.Cast(v85.Berserking, nil, v31) or ((2592 + 229) < (5985 - 3554))) then
						return "Cast Berserking";
					end
				end
				if (v85.Fireblood:IsCastable() or ((2383 + 491) < (1399 + 782))) then
					if (v10.Cast(v85.Fireblood, nil, v31) or ((1523 + 1166) <= (1573 - (957 + 273)))) then
						return "Cast Fireblood";
					end
				end
				v139 = 2 + 4;
			end
			if ((v139 == (2 + 1)) or ((7121 - 5252) == (5294 - 3285))) then
				if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (20 - 13))) or ((17558 - 14012) < (4102 - (389 + 1391)))) then
					if (v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike)) or ((1307 + 775) == (497 + 4276))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((7385 - 4141) > (2006 - (783 + 168))) and v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) then
					if ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 36 - 25) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 11 + 0) or ((3624 - (309 + 2)) <= (5460 - 3682))) then
						if (v10.Cast(v85.Sepsis) or ((2633 - (1090 + 122)) >= (683 + 1421))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((6085 - 4273) <= (2224 + 1025)) and v85.BladeRush:IsReady() and (v103 > (1122 - (628 + 490))) and not v16:StealthUp(true, true)) then
					if (((292 + 1331) <= (4844 - 2887)) and v10.Cast(v85.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v139 = 18 - 14;
			end
		end
	end
	local function v123()
		if (((5186 - (431 + 343)) == (8910 - 4498)) and v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (5 - 3)) and (v16:BuffRemains(v85.BladeFlurry) <= v16:GCD()) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
			if (((1383 + 367) >= (108 + 734)) and v71) then
				v10.Cast(v85.BladeFlurry);
			elseif (((6067 - (556 + 1139)) > (1865 - (6 + 9))) and v10.Cast(v85.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if (((43 + 189) < (421 + 400)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
			if (((687 - (28 + 141)) < (350 + 552)) and v10.Cast(v85.ColdBlood, v56)) then
				return "Cast Cold Blood";
			end
		end
		if (((3694 - 700) > (608 + 250)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) then
			if (v10.Cast(v85.BetweentheEyes) or ((5072 - (486 + 831)) <= (2380 - 1465))) then
				return "Cast Between the Eyes";
			end
		end
		if (((13892 - 9946) > (708 + 3035)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) then
			if (v10.Press(v85.Dispatch) or ((4221 - 2886) >= (4569 - (668 + 595)))) then
				return "Cast Dispatch";
			end
		end
		if (((4359 + 485) > (455 + 1798)) and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (5 - 3)) and (v16:BuffStack(v85.Opportunity) >= (296 - (23 + 267))) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1945 - (1129 + 815)))) or v16:BuffUp(v85.GreenskinsWickersBuff))) then
			if (((839 - (371 + 16)) == (2202 - (1326 + 424))) and v10.Press(v85.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((8630 - 4073) < (7626 - 5539))) then
			if (((3992 - (88 + 30)) == (4645 - (720 + 51))) and v10.Cast(v85.Ambush, nil, not v17:IsSpellInRange(v85.Ambush))) then
				return "Cast Ambush (SS High-Prio Buffed)";
			end
		end
		if ((v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) or ((4310 - 2372) > (6711 - (421 + 1355)))) then
			if (v10.Press(v85.Ambush) or ((7019 - 2764) < (1682 + 1741))) then
				return "Cast Ambush";
			end
		end
	end
	local function v124()
		local v142 = 1083 - (286 + 797);
		while true do
			if (((5315 - 3861) <= (4125 - 1634)) and (v142 == (439 - (397 + 42)))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (2 + 2)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(830 - (24 + 776), 5 - 1)) and v16:BuffDown(v85.GreenskinsWickers)) or ((4942 - (222 + 563)) <= (6175 - 3372))) then
					if (((3495 + 1358) >= (3172 - (23 + 167))) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((5932 - (690 + 1108)) > (1212 + 2145)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (38 + 7)) and (v85.ShadowDance:CooldownRemains() > (860 - (40 + 808)))) then
					if (v10.Press(v85.BetweentheEyes) or ((563 + 2854) < (9689 - 7155))) then
						return "Cast Between the Eyes";
					end
				end
				v142 = 1 + 0;
			end
			if ((v142 == (1 + 0)) or ((1493 + 1229) <= (735 - (47 + 524)))) then
				if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 + 0))) and (v16:BuffRemains(v85.SliceandDice) < (((2 - 1) + v98) * (1.8 - 0)))) or ((5491 - 3083) < (3835 - (1165 + 561)))) then
					if (v10.Press(v85.SliceandDice) or ((1 + 32) == (4506 - 3051))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((170 + 273) >= (4494 - (341 + 138)))) then
					if (((913 + 2469) > (342 - 176)) and v10.Cast(v85.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v142 = 328 - (89 + 237);
			end
			if ((v142 == (6 - 4)) or ((589 - 309) == (3940 - (581 + 300)))) then
				if (((3101 - (855 + 365)) > (3070 - 1777)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) then
					if (((770 + 1587) == (3592 - (1030 + 205))) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				if (((116 + 7) == (115 + 8)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Press(v85.Dispatch) or ((1342 - (156 + 130)) >= (7707 - 4315))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (3 - 1)) or ((285 + 796) < (627 + 448))) then
				if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((70 - (10 + 59)) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + 1 + 0)))) or (v98 <= (4 - 3)))) or ((2212 - (671 + 492)) >= (3529 + 903))) then
					if (v10.Press(v85.PistolShot) or ((5983 - (369 + 846)) <= (224 + 622))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1.5 + 0)) or (v99 <= ((1946 - (1036 + 909)) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) or ((2670 + 688) <= (2384 - 964))) then
					if (v10.Cast(v85.PistolShot) or ((3942 - (11 + 192)) <= (1519 + 1486))) then
						return "Cast Pistol Shot";
					end
				end
				v143 = 178 - (135 + 40);
			end
			if (((6 - 3) == v143) or ((1000 + 659) >= (4701 - 2567))) then
				if (v85.SinisterStrike:IsCastable() or ((4887 - 1627) < (2531 - (50 + 126)))) then
					if (v10.Press(v85.SinisterStrike) or ((1862 - 1193) == (935 + 3288))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v143 == (1413 - (1233 + 180))) or ((2661 - (522 + 447)) < (2009 - (107 + 1314)))) then
				if ((v29 and v85.EchoingReprimand:IsReady()) or ((2226 + 2571) < (11124 - 7473))) then
					if (v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand)) or ((1775 + 2402) > (9631 - 4781))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((1582 - 1182) > (3021 - (716 + 1194)))) then
					if (((53 + 2998) > (108 + 897)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v143 = 504 - (74 + 429);
			end
			if (((7123 - 3430) <= (2172 + 2210)) and (v143 == (2 - 1))) then
				if ((v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((2322 + 960) > (12640 - 8540))) then
					if (v10.Press(v85.PistolShot) or ((8851 - 5271) < (3277 - (279 + 154)))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((867 - (454 + 324)) < (3533 + 957)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (23 - (12 + 5))) or (v16:BuffRemains(v85.Opportunity) < (2 + 0)))) then
					if (v10.Press(v85.PistolShot) or ((12696 - 7713) < (669 + 1139))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v143 = 1095 - (277 + 816);
			end
		end
	end
	local function v126()
		local v144 = 0 - 0;
		while true do
			if (((5012 - (1058 + 125)) > (707 + 3062)) and ((979 - (815 + 160)) == v144)) then
				if (((6371 - 4886) <= (6893 - 3989)) and v33 and (v16:HealthPercentage() <= v35)) then
					local v184 = 0 + 0;
					while true do
						if (((12478 - 8209) == (6167 - (41 + 1857))) and (v184 == (1893 - (1222 + 671)))) then
							if (((1000 - 613) <= (3998 - 1216)) and (v34 == "Refreshing Healing Potion")) then
								if (v86.RefreshingHealingPotion:IsReady() or ((3081 - (229 + 953)) <= (2691 - (1111 + 663)))) then
									if (v10.Press(v87.RefreshingHealingPotion) or ((5891 - (874 + 705)) <= (123 + 753))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((1523 + 709) <= (5395 - 2799)) and (v34 == "Dreamwalker's Healing Potion")) then
								if (((59 + 2036) < (4365 - (642 + 37))) and v86.DreamwalkersHealingPotion:IsReady()) then
									if (v10.Press(v87.RefreshingHealingPotion) or ((364 + 1231) >= (716 + 3758))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if ((v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) or ((11596 - 6977) < (3336 - (233 + 221)))) then
					if (v10.Cast(v85.Feint) or ((679 - 385) >= (4253 + 578))) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((3570 - (718 + 823)) <= (1941 + 1143)) and v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) then
					if (v10.Cast(v85.Evasion) or ((2842 - (266 + 539)) == (6851 - 4431))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((5683 - (636 + 589)) > (9266 - 5362)) and not v16:IsCasting() and not v16:IsChanneling()) then
					local v185 = v83.Interrupt(v85.Kick, 16 - 8, true);
					if (((346 + 90) >= (45 + 78)) and v185) then
						return v185;
					end
					v185 = v83.Interrupt(v85.Kick, 1023 - (657 + 358), true, v13, v87.KickMouseover);
					if (((1323 - 823) < (4137 - 2321)) and v185) then
						return v185;
					end
					v185 = v83.Interrupt(v85.Blind, 1202 - (1151 + 36), v80);
					if (((3452 + 122) == (940 + 2634)) and v185) then
						return v185;
					end
					v185 = v83.Interrupt(v85.Blind, 44 - 29, v80, v13, v87.BlindMouseover);
					if (((2053 - (1552 + 280)) < (1224 - (64 + 770))) and v185) then
						return v185;
					end
					v185 = v83.InterruptWithStun(v85.CheapShot, 6 + 2, v16:StealthUp(false, false));
					if (v185 or ((5023 - 2810) <= (253 + 1168))) then
						return v185;
					end
					v185 = v83.InterruptWithStun(v85.KidneyShot, 1251 - (157 + 1086), v16:ComboPoints() > (0 - 0));
					if (((13393 - 10335) < (7455 - 2595)) and v185) then
						return v185;
					end
				end
				v144 = 6 - 1;
			end
			if ((v144 == (820 - (599 + 220))) or ((2580 - 1284) >= (6377 - (1813 + 118)))) then
				v98 = v16:ComboPoints();
				v97 = v84.EffectiveComboPoints(v98);
				v99 = v16:ComboPointsDeficit();
				v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(37 + 13)) or (1217 - (841 + 376));
				v144 = 2 - 0;
			end
			if (((1 + 2) == v144) or ((3802 - 2409) > (5348 - (464 + 395)))) then
				if (v28 or ((11353 - 6929) < (13 + 14))) then
					local v186 = 837 - (467 + 370);
					while true do
						if ((v186 == (0 - 0)) or ((1466 + 531) > (13077 - 9262))) then
							v92 = v16:GetEnemiesInRange(5 + 25);
							v93 = v16:GetEnemiesInRange(v96);
							v186 = 2 - 1;
						end
						if (((3985 - (150 + 370)) > (3195 - (74 + 1208))) and (v186 == (2 - 1))) then
							v94 = #v93;
							break;
						end
					end
				else
					v94 = 4 - 3;
				end
				v95 = v84.CrimsonVial();
				if (((522 + 211) < (2209 - (14 + 376))) and v95) then
					return v95;
				end
				v84.Poisons();
				v144 = 6 - 2;
			end
			if ((v144 == (2 + 0)) or ((3861 + 534) == (4535 + 220))) then
				v100 = v109();
				v101 = v16:EnergyRegen();
				v103 = v108(v104);
				v102 = v16:EnergyDeficitPredicted(nil, v104);
				v144 = 8 - 5;
			end
			if ((v144 == (4 + 1)) or ((3871 - (23 + 55)) < (5614 - 3245))) then
				if (v30 or ((2726 + 1358) == (238 + 27))) then
					local v187 = 0 - 0;
					while true do
						if (((1371 + 2987) == (5259 - (652 + 249))) and (v187 == (0 - 0))) then
							v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 1898 - (708 + 1160), true);
							if (v95 or ((8517 - 5379) < (1810 - 817))) then
								return v95;
							end
							break;
						end
					end
				end
				if (((3357 - (10 + 17)) > (522 + 1801)) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
					local v188 = 1732 - (1400 + 332);
					while true do
						if ((v188 == (0 - 0)) or ((5534 - (242 + 1666)) == (1707 + 2282))) then
							v95 = v84.Stealth(v85.Stealth2, nil);
							if (v95 or ((336 + 580) == (2277 + 394))) then
								return "Stealth (OOC): " .. v95;
							end
							break;
						end
					end
				end
				if (((1212 - (850 + 90)) == (475 - 203)) and not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1391 - (360 + 1030))) and v17:IsInRange(8 + 0) and v27) then
					if (((11992 - 7743) <= (6657 - 1818)) and v83.TargetIsValid() and v17:IsInRange(1671 - (909 + 752)) and not (v16:IsChanneling() or v16:IsCasting())) then
						if (((4000 - (109 + 1114)) < (5858 - 2658)) and v85.BladeFlurry:IsReady() and (v16:BuffDown(v85.BladeFlurry) or ((v16:BuffRemains(v85.BladeFlurry) <= (2 + 1)) and v28 and (v94 > (243 - (6 + 236))))) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
							if (((60 + 35) < (1576 + 381)) and v10.Press(v85.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((1947 - 1121) < (2998 - 1281)) and not v16:StealthUp(true, false)) then
							local v198 = 1133 - (1076 + 57);
							while true do
								if (((235 + 1191) >= (1794 - (579 + 110))) and (v198 == (0 + 0))) then
									v95 = v84.Stealth(v85.Stealth);
									if (((2435 + 319) <= (1794 + 1585)) and v95) then
										return v95;
									end
									break;
								end
							end
						end
						if (v83.TargetIsValid() or ((4334 - (174 + 233)) == (3946 - 2533))) then
							local v199 = 0 - 0;
							while true do
								if ((v199 == (1 + 1)) or ((2328 - (663 + 511)) <= (703 + 85))) then
									if (v85.SinisterStrike:IsCastable() or ((357 + 1286) > (10417 - 7038))) then
										if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((1698 + 1105) > (10709 - 6160))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if ((v199 == (2 - 1)) or ((105 + 115) >= (5881 - 2859))) then
									if (((2012 + 810) == (258 + 2564)) and v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((723 - (478 + 244)) + v98) * (518.8 - (440 + 77))))) then
										if (v10.Press(v85.SliceandDice) or ((483 + 578) == (6796 - 4939))) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (((4316 - (655 + 901)) > (253 + 1111)) and (v16:StealthUp(true, false) or v85.Subterfuge:BuffUp())) then
										local v211 = 0 + 0;
										while true do
											if ((v211 == (0 + 0)) or ((19748 - 14846) <= (5040 - (695 + 750)))) then
												v95 = v123();
												if (v95 or ((13153 - 9301) == (451 - 158))) then
													return "Stealth (Opener): " .. v95;
												end
												v211 = 3 - 2;
											end
											if ((v211 == (352 - (285 + 66))) or ((3633 - 2074) == (5898 - (682 + 628)))) then
												if ((v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) or ((723 + 3761) == (1087 - (176 + 123)))) then
													if (((1911 + 2657) >= (2835 + 1072)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (((1515 - (239 + 30)) < (944 + 2526)) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) then
													if (((3910 + 158) >= (1719 - 747)) and v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((1537 - 1044) < (4208 - (306 + 9))) and v85.SinisterStrike:IsCastable()) then
													if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((5140 - 3667) >= (580 + 2752))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
												break;
											end
										end
									elseif (v115() or ((2486 + 1565) <= (557 + 600))) then
										local v217 = 0 - 0;
										while true do
											if (((1979 - (1140 + 235)) < (1834 + 1047)) and ((0 + 0) == v217)) then
												v95 = v124();
												if (v95 or ((231 + 669) == (3429 - (33 + 19)))) then
													return "Finish (Opener): " .. v95;
												end
												break;
											end
										end
									end
									v199 = 1 + 1;
								end
								if (((13364 - 8905) > (261 + 330)) and (v199 == (0 - 0))) then
									if (((3187 + 211) >= (3084 - (586 + 103))) and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1 + 1))) then
										if (v10.Cast(v85.AdrenalineRush) or ((6720 - 4537) >= (4312 - (1309 + 179)))) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if (((3494 - 1558) == (843 + 1093)) and v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (0 - 0)) or v114())) then
										if (v10.Cast(v85.RolltheBones) or ((3650 + 1182) < (9163 - 4850))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v199 = 1 - 0;
								end
							end
						end
						return;
					end
				end
				if (((4697 - (295 + 314)) > (9514 - 5640)) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
					local v189 = 1962 - (1300 + 662);
					while true do
						if (((13603 - 9271) == (6087 - (1178 + 577))) and ((0 + 0) == v189)) then
							v98 = v26(v98, v84.FanTheHammerCP());
							v97 = v84.EffectiveComboPoints(v98);
							v189 = 2 - 1;
						end
						if (((5404 - (851 + 554)) >= (2565 + 335)) and (v189 == (2 - 1))) then
							v99 = v16:ComboPointsDeficit();
							break;
						end
					end
				end
				v144 = 12 - 6;
			end
			if ((v144 == (308 - (115 + 187))) or ((1934 + 591) > (3848 + 216))) then
				if (((17224 - 12853) == (5532 - (160 + 1001))) and v83.TargetIsValid()) then
					local v190 = 0 + 0;
					while true do
						if ((v190 == (0 + 0)) or ((544 - 278) > (5344 - (237 + 121)))) then
							v95 = v122();
							if (((2888 - (525 + 372)) >= (1753 - 828)) and v95) then
								return "CDs: " .. v95;
							end
							if (((1494 - 1039) < (2195 - (96 + 46))) and (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld))) then
								local v203 = 777 - (643 + 134);
								while true do
									if (((0 + 0) == v203) or ((1980 - 1154) == (18010 - 13159))) then
										v95 = v123();
										if (((176 + 7) == (358 - 175)) and v95) then
											return "Stealth: " .. v95;
										end
										break;
									end
								end
							end
							v190 = 1 - 0;
						end
						if (((1878 - (316 + 403)) <= (1189 + 599)) and (v190 == (8 - 5))) then
							if ((v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(2 + 3)) or ((8831 - 5324) > (3060 + 1258))) then
								if (v10.Cast(v85.BagofTricks, v31) or ((992 + 2083) <= (10273 - 7308))) then
									return "Cast Bag of Tricks";
								end
							end
							if (((6519 - 5154) <= (4177 - 2166)) and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (2 + 23)) and ((v99 >= (1 - 0)) or (v103 <= (1.2 + 0)))) then
								if (v10.Cast(v85.PistolShot) or ((8167 - 5391) > (3592 - (12 + 5)))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (v85.SinisterStrike:IsCastable() or ((9919 - 7365) == (10249 - 5445))) then
								if (((5477 - 2900) == (6390 - 3813)) and v10.Cast(v85.SinisterStrike)) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if ((v190 == (1 + 0)) or ((1979 - (1656 + 317)) >= (1684 + 205))) then
							if (((406 + 100) <= (5030 - 3138)) and v115()) then
								v95 = v124();
								if (v95 or ((9882 - 7874) > (2572 - (5 + 349)))) then
									return "Finish: " .. v95;
								end
								return "Finish Pooling";
							end
							v95 = v125();
							if (((1800 - 1421) <= (5418 - (266 + 1005))) and v95) then
								return "Build: " .. v95;
							end
							v190 = 2 + 0;
						end
						if ((v190 == (6 - 4)) or ((5942 - 1428) <= (2705 - (561 + 1135)))) then
							if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > ((19 - 4) + v101))) or ((11491 - 7995) == (2258 - (507 + 559)))) then
								if (v10.Cast(v85.ArcaneTorrent, v31) or ((521 - 313) == (9151 - 6192))) then
									return "Cast Arcane Torrent";
								end
							end
							if (((4665 - (212 + 176)) >= (2218 - (250 + 655))) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
								if (((7054 - 4467) < (5545 - 2371)) and v10.Cast(v85.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							if ((v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(7 - 2)) or ((6076 - (1869 + 87)) <= (7623 - 5425))) then
								if (v10.Cast(v85.LightsJudgment, v31) or ((3497 - (484 + 1417)) == (1838 - 980))) then
									return "Cast Lights Judgment";
								end
							end
							v190 = 4 - 1;
						end
					end
				end
				break;
			end
			if (((3993 - (48 + 725)) == (5260 - 2040)) and (v144 == (0 - 0))) then
				v82();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v144 = 1 + 0;
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(694 - 434, v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

