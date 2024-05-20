local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4997 - (174 + 489)) == (11059 - 6814))) then
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
		local v127 = 1905 - (830 + 1075);
		while true do
			if ((v127 == (524 - (303 + 221))) or ((5545 - (231 + 1038)) <= (2526 + 505))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1163 - (171 + 991);
			end
			if ((v127 == (12 - 9)) or ((12840 - 8058) <= (2991 - 1792))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 4 + 0;
			end
			if ((v127 == (24 - 17)) or ((14031 - 9167) < (3065 - 1163))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 24 - 16;
			end
			if (((6087 - (111 + 1137)) >= (3858 - (91 + 67))) and (v127 == (11 - 7))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 2 + 3;
			end
			if ((v127 == (529 - (423 + 100))) or ((8 + 1067) > (5310 - 3392))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 4 + 3;
			end
			if (((1167 - (326 + 445)) <= (16600 - 12796)) and (v127 == (17 - 9))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 20 - 11;
			end
			if ((v127 == (712 - (530 + 181))) or ((5050 - (614 + 267)) == (2219 - (19 + 13)))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v127 = 5 - 3;
			end
			if (((366 + 1040) == (2472 - 1066)) and (v127 == (10 - 5))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1812 - (1293 + 519));
				v58 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 15 - 9;
			end
			if (((2927 - 1396) < (18416 - 14145)) and (v127 == (20 - 11))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if (((130 + 505) == (1475 - 840)) and (v127 == (1 + 1))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v127 = 2 + 1;
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
	local v89 = (v88[1109 - (709 + 387)] and v19(v88[1871 - (673 + 1185)])) or v19(0 - 0);
	local v90 = (v88[44 - 30] and v19(v88[22 - 8])) or v19(0 + 0);
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[10 + 3] and v19(v88[16 - 3])) or v19(0 + 0);
		v90 = (v88[27 - 13] and v19(v88[27 - 13])) or v19(1880 - (446 + 1434));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 1289 - (1040 + 243);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 - 0);
	end}};
	local v105, v106 = 0 + 0, 0 + 0;
	local function v107(v128)
		local v129 = v15:EnergyTimeToMaxPredicted(nil, v128);
		if (((10009 - 6636) <= (1946 + 1610)) and ((v129 < v105) or ((v129 - v105) > (0.5 - 0)))) then
			v105 = v129;
		end
		return v105;
	end
	local function v108()
		local v130 = 0 + 0;
		local v131;
		while true do
			if ((v130 == (0 + 0)) or ((2365 + 926) < (2755 + 525))) then
				v131 = v15:EnergyPredicted();
				if (((4292 + 94) >= (1306 - (153 + 280))) and ((v131 > v106) or ((v131 - v106) > (25 - 16)))) then
					v106 = v131;
				end
				v130 = 1 + 0;
			end
			if (((364 + 557) <= (577 + 525)) and (v130 == (1 + 0))) then
				return v106;
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((5755 - (572 + 477)) >= (130 + 833)) and not v10.APLVar.RtB_Buffs) then
			local v143 = 0 + 0;
			local v144;
			while true do
				if (((1 + 1) == v143) or ((1046 - (84 + 2)) <= (1443 - 567))) then
					v144 = v83.RtBRemains();
					for v188 = 1 + 0, #v109 do
						local v189 = 842 - (497 + 345);
						local v190;
						while true do
							if (((1 + 0) == v189) or ((350 + 1716) == (2265 - (605 + 728)))) then
								if (((3443 + 1382) < (10767 - 5924)) and v110) then
									print("RtbRemains", v144);
									print(v109[v188]:Name(), v190);
								end
								break;
							end
							if ((v189 == (0 + 0)) or ((14334 - 10457) >= (4091 + 446))) then
								v190 = v15:BuffRemains(v109[v188]);
								if ((v190 > (0 - 0)) or ((3259 + 1056) < (2215 - (457 + 32)))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
									if ((v190 > v10.APLVar.RtB_Buffs.MaxRemains) or ((5081 - (832 + 570)) < (589 + 36))) then
										v10.APLVar.RtB_Buffs.MaxRemains = v190;
									end
									local v196 = math.abs(v190 - v144);
									if ((v196 <= (0.5 + 0)) or ((16367 - 11742) < (305 + 327))) then
										local v199 = 796 - (588 + 208);
										while true do
											if ((v199 == (2 - 1)) or ((1883 - (884 + 916)) > (3726 - 1946))) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
												break;
											end
											if (((1199 - (232 + 421)) <= (2966 - (1569 + 320))) and (v199 == (0 + 0))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
												v10.APLVar.RtB_Buffs.Will_Lose[v109[v188]:Name()] = true;
												v199 = 3 - 2;
											end
										end
									elseif ((v190 > v144) or ((1601 - (316 + 289)) > (11258 - 6957))) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
									else
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1454 - (666 + 787));
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v188]:Name()] = true;
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (426 - (360 + 65));
									end
								end
								v189 = 1 + 0;
							end
						end
					end
					if (((4324 - (79 + 175)) > (1082 - 395)) and v110) then
						print("have: ", v10.APLVar.RtB_Buffs.Total);
						print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v10.APLVar.RtB_Buffs.Normal);
						print("longer: ", v10.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
					end
					break;
				end
				if (((1 + 0) == v143) or ((2010 - 1354) >= (6413 - 3083))) then
					v10.APLVar.RtB_Buffs.Normal = 899 - (503 + 396);
					v10.APLVar.RtB_Buffs.Shorter = 181 - (92 + 89);
					v10.APLVar.RtB_Buffs.Longer = 0 - 0;
					v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v143 = 2 + 0;
				end
				if ((v143 == (0 - 0)) or ((341 + 2151) <= (763 - 428))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Will_Lose = {};
					v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v10.APLVar.RtB_Buffs.Total = 0 + 0;
					v143 = 2 - 1;
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v132)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v132] and true) or false;
	end
	local function v113()
		local v133 = 0 + 0;
		while true do
			if (((6590 - 2268) >= (3806 - (485 + 759))) and (v133 == (0 - 0))) then
				if (not v10.APLVar.RtB_Reroll or ((4826 - (442 + 747)) >= (4905 - (832 + 303)))) then
					if ((v64 == "1+ Buff") or ((3325 - (88 + 858)) > (1396 + 3182))) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
					elseif ((v64 == "Broadside") or ((20 + 463) > (1532 - (766 + 23)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif (((12114 - 9660) > (790 - 212)) and (v64 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((2450 - 1520) < (15130 - 10672)) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif (((1735 - (1036 + 37)) <= (690 + 282)) and (v64 == "Skull and Crossbones")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif (((8510 - 4140) == (3438 + 932)) and (v64 == "Ruthless Precision")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((6242 - (641 + 839)) <= (1774 - (910 + 3)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						local v212 = 0 - 0;
						while true do
							if ((v212 == (1685 - (1466 + 218))) or ((649 + 763) == (5412 - (556 + 592)))) then
								if (((v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (1 + 1))) or ((3976 - (329 + 479)) < (3007 - (174 + 680)))) then
									v10.APLVar.RtB_Reroll = true;
								end
								if ((v84.Crackshot:IsAvailable() and not v15:HasTier(106 - 75, 8 - 4) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0))) or ((5715 - (396 + 343)) < (118 + 1214))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v212 = 1479 - (29 + 1448);
							end
							if (((6017 - (135 + 1254)) == (17434 - 12806)) and (v212 == (9 - 7))) then
								if ((v84.Crackshot:IsAvailable() and v15:HasTier(21 + 10, 1531 - (389 + 1138)) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((575 - (102 + 472)) + v21(v15:BuffUp(v84.LoadedDiceBuff))))) or ((51 + 3) == (220 + 175))) then
									v10.APLVar.RtB_Reroll = true;
								end
								if (((77 + 5) == (1627 - (320 + 1225))) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((2 - 0) + v112(v84.GrandMelee))) and (v93 < (2 + 0))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v212 = 1467 - (157 + 1307);
							end
							if ((v212 == (1862 - (821 + 1038))) or ((1449 - 868) < (31 + 251))) then
								v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 - 0)) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (2 - 1)) and (v111() < (1032 - (834 + 192))) and (v10.APLVar.RtB_Buffs.MaxRemains <= (3 + 36)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
								if (v16:FilteredTimeToDie("<", 4 + 8) or v9.BossFilteredFightRemains("<", 1 + 11) or ((7139 - 2530) < (2799 - (300 + 4)))) then
									v10.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if (((308 + 844) == (3015 - 1863)) and (v212 == (362 - (112 + 250)))) then
								v10.APLVar.RtB_Reroll = false;
								v111();
								v212 = 1 + 0;
							end
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (2 - 1)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= (2 + 0 + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (26 + 24));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (2 + 0)) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if (((1409 + 487) <= (4836 - (1001 + 413))) and (v134 == (4 - 2))) then
				if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (912 - (244 + 638))) or ((v84.KeepItRolling:CooldownRemains() >= (813 - (627 + 66))) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((2949 - 1959) > (2222 - (512 + 90)))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((2783 - (1665 + 241)) > (5412 - (373 + 344)))) then
						return "Cast Shadow Dance";
					end
				end
				if (((1214 + 1477) >= (490 + 1361)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
					if ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())) or ((7873 - 4888) >= (8217 - 3361))) then
						if (((5375 - (35 + 1064)) >= (870 + 325)) and v9.Cast(v84.Shadowmeld, v30)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((6914 - 3682) <= (19 + 4671)) and (v134 == (1236 - (298 + 938)))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (1265 - (233 + 1026)))) and v115()) or ((2562 - (636 + 1030)) >= (1609 + 1537))) then
					if (((2990 + 71) >= (879 + 2079)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((216 + 2971) >= (865 - (55 + 166))) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (((125 + 519) <= (71 + 633)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 3 - 2;
			end
			if (((1255 - (36 + 261)) > (1656 - 709)) and (v134 == (1369 - (34 + 1334)))) then
				if (((1727 + 2765) >= (2063 + 591)) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (1289 - (1035 + 248))) or not v67) and not v15:StealthUp(true, false)) then
					if (((3463 - (20 + 1)) >= (784 + 719)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((3489 - (134 + 185)) <= (2597 - (549 + 584)))) then
					if (v11(v84.ShadowDance, v53) or ((5482 - (314 + 371)) == (15063 - 10675))) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 970 - (478 + 490);
			end
		end
	end
	local function v120()
		local v135 = 0 + 0;
		local v136;
		while true do
			if (((1723 - (786 + 386)) <= (2205 - 1524)) and (v135 == (1379 - (1055 + 324)))) then
				v136 = v82.HandleTopTrinket(v87, v28, 1380 - (1093 + 247), nil);
				if (((2913 + 364) > (43 + 364)) and v136) then
					return v136;
				end
				v135 = 3 - 2;
			end
			if (((15933 - 11238) >= (4026 - 2611)) and (v135 == (2 - 1))) then
				v136 = v82.HandleBottomTrinket(v87, v28, 15 + 25, nil);
				if (v136 or ((12373 - 9161) <= (3253 - 2309))) then
					return v136;
				end
				break;
			end
		end
	end
	local function v121()
		local v137 = 0 + 0;
		local v138;
		local v139;
		while true do
			if ((v137 == (2 - 1)) or ((3784 - (364 + 324)) <= (4928 - 3130))) then
				if (((8487 - 4950) == (1173 + 2364)) and v84.BladeFlurry:IsReady()) then
					if (((16055 - 12218) >= (2514 - 944)) and (v93 >= ((5 - 3) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) then
						if (v11(v84.BladeFlurry) or ((4218 - (1249 + 19)) == (3441 + 371))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((18384 - 13661) >= (3404 - (686 + 400))) and v84.BladeFlurry:IsReady()) then
					if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (3 + 0)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (234 - (73 + 156))))) or ((10 + 2017) > (3663 - (721 + 90)))) then
						if (v11(v84.BladeFlurry) or ((13 + 1123) > (14016 - 9699))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((5218 - (224 + 246)) == (7691 - 2943)) and v84.RolltheBones:IsReady()) then
					if (((6878 - 3142) <= (860 + 3880)) and ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (3 + 0)) and v15:HasTier(61 - 30, 12 - 8)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (520 - (203 + 310))) and ((v84.ShadowDance:CooldownRemains() <= (1996 - (1238 + 755))) or (v84.Vanish:CooldownRemains() <= (1 + 2))) and not v15:StealthUp(true, true)))) then
						if (v11(v84.RolltheBones) or ((4924 - (709 + 825)) <= (5638 - 2578))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v137 = 2 - 0;
			end
			if (((869 - (196 + 668)) == v137) or ((3944 - 2945) > (5578 - 2885))) then
				if (((1296 - (171 + 662)) < (694 - (4 + 89))) and v84.BloodFury:IsCastable()) then
					if (v9.Cast(v84.BloodFury, v30) or ((7651 - 5468) < (251 + 436))) then
						return "Cast Blood Fury";
					end
				end
				if (((19980 - 15431) == (1784 + 2765)) and v84.Berserking:IsCastable()) then
					if (((6158 - (35 + 1451)) == (6125 - (28 + 1425))) and v9.Cast(v84.Berserking, v30)) then
						return "Cast Berserking";
					end
				end
				if (v84.Fireblood:IsCastable() or ((5661 - (941 + 1052)) < (379 + 16))) then
					if (v9.Cast(v84.Fireblood, v30) or ((5680 - (822 + 692)) == (649 - 194))) then
						return "Cast Fireblood";
					end
				end
				v137 = 3 + 3;
			end
			if ((v137 == (301 - (45 + 252))) or ((4402 + 47) == (917 + 1746))) then
				if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((10408 - 6131) < (3422 - (114 + 319)))) then
					local v180 = 0 - 0;
					while true do
						if ((v180 == (0 - 0)) or ((555 + 315) >= (6180 - 2031))) then
							v139 = v119();
							if (((4634 - 2422) < (5146 - (556 + 1407))) and v139) then
								return v139;
							end
							break;
						end
					end
				end
				if (((5852 - (741 + 465)) > (3457 - (170 + 295))) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (53 + 47)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (6 + 0)))) then
					if (((3530 - 2096) < (2575 + 531)) and v9.Cast(v84.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (((505 + 281) < (1712 + 1311)) and v84.BladeRush:IsCastable() and (v102 > (1234 - (957 + 273))) and not v15:StealthUp(true, true)) then
					if (v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush)) or ((654 + 1788) < (30 + 44))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 19 - 14;
			end
			if (((11950 - 7415) == (13852 - 9317)) and (v137 == (0 - 0))) then
				v138 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (v138 or ((4789 - (389 + 1391)) <= (1321 + 784))) then
					return "DPS Pot";
				end
				if (((191 + 1639) < (8352 - 4683)) and v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (953 - (783 + 168)))))) then
					if (v11(v84.AdrenalineRush, v75) or ((4799 - 3369) >= (3553 + 59))) then
						return "Cast Adrenaline Rush";
					end
				end
				v137 = 312 - (309 + 2);
			end
			if (((8239 - 5556) >= (3672 - (1090 + 122))) and ((2 + 4) == v137)) then
				if (v84.AncestralCall:IsCastable() or ((6058 - 4254) >= (2242 + 1033))) then
					if (v9.Cast(v84.AncestralCall, v30) or ((2535 - (628 + 490)) > (651 + 2978))) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((11872 - 7077) > (1837 - 1435)) and (v137 == (776 - (431 + 343)))) then
				v139 = v120();
				if (((9720 - 4907) > (10313 - 6748)) and v139) then
					return v139;
				end
				if (((3091 + 821) == (501 + 3411)) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((1698 - (556 + 1139)) + v21(v15:HasTier(46 - (6 + 9), 1 + 3)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (4 + 2)))) then
					if (((2990 - (28 + 141)) <= (1869 + 2955)) and v9.Cast(v84.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				v137 = 3 - 0;
			end
			if (((1231 + 507) <= (3512 - (486 + 831))) and (v137 == (7 - 4))) then
				if (((144 - 103) <= (571 + 2447)) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (22 - 15))) then
					if (((3408 - (668 + 595)) <= (3693 + 411)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((543 + 2146) < (13212 - 8367)) and v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 301 - (23 + 267)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1955 - (1129 + 815)) or ((2709 - (371 + 16)) > (4372 - (1326 + 424)))) then
						if (v9.Cast(v84.Sepsis) or ((8587 - 4053) == (7608 - 5526))) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v84.BladeRush:IsReady() and (v102 > (122 - (88 + 30))) and not v15:StealthUp(true, true)) or ((2342 - (720 + 51)) > (4153 - 2286))) then
					if (v9.Cast(v84.BladeRush) or ((4430 - (421 + 1355)) >= (4942 - 1946))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 2 + 2;
			end
		end
	end
	local function v122()
		local v140 = 1083 - (286 + 797);
		while true do
			if (((14542 - 10564) > (3484 - 1380)) and ((440 - (397 + 42)) == v140)) then
				if (((936 + 2059) > (2341 - (24 + 776))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
					if (((5004 - 1755) > (1738 - (222 + 563))) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((7211 - 3938) > (3293 + 1280))) then
					if (v9.Press(v84.Dispatch) or ((3341 - (23 + 167)) < (3082 - (690 + 1108)))) then
						return "Cast Dispatch";
					end
				end
				v140 = 1 + 1;
			end
			if ((v140 == (3 + 0)) or ((2698 - (40 + 808)) == (252 + 1277))) then
				if (((3139 - 2318) < (2030 + 93)) and v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
					if (((478 + 424) < (1275 + 1050)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((1429 - (47 + 524)) <= (1923 + 1039)) and (v140 == (0 - 0))) then
				if (v84.BladeFlurry:IsReady() or ((5900 - 1954) < (2937 - 1649))) then
					if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1729 - (1165 + 561))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1 + 4)))) or ((10040 - 6798) == (217 + 350))) then
						if (v11(v84.BladeFlurry, v70) or ((1326 - (341 + 138)) >= (341 + 922))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((4649 - 2396) == (2177 - (89 + 237)))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((6713 - 4626) > (4993 - 2621))) then
						return "Cast Cold Blood";
					end
				end
				v140 = 882 - (581 + 300);
			end
			if ((v140 == (1222 - (855 + 365))) or ((10557 - 6112) < (1355 + 2794))) then
				if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1237 - (1030 + 205))) and (v15:BuffStack(v84.Opportunity) >= (6 + 0)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) or ((2104 - (156 + 130)) == (193 - 108))) then
					if (((1061 - 431) < (4355 - 2228)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((511 + 1427) == (1466 + 1048))) then
					if (((4324 - (10 + 59)) >= (16 + 39)) and v11(v84.SinisterStrike, nil, not v16:IsSpellInRange(v84.Ambush))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 14 - 11;
			end
		end
	end
	local function v123()
		if (((4162 - (671 + 492)) > (921 + 235)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (1219 - (369 + 846))) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(8 + 22, 4 + 0)) and v15:BuffDown(v84.GreenskinsWickers)) then
			if (((4295 - (1036 + 909)) > (919 + 236)) and v9.Press(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((6763 - 2734) <= (5056 - (11 + 192))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (23 + 22)) and (v84.ShadowDance:CooldownRemains() > (187 - (135 + 40)))) then
			if (v9.Press(v84.BetweentheEyes) or ((1249 - 733) > (2070 + 1364))) then
				return "Cast Between the Eyes";
			end
		end
		if (((8913 - 4867) >= (4546 - 1513)) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (176 - (50 + 126)))) and (v15:BuffRemains(v84.SliceandDice) < (((2 - 1) + v97) * (1.8 + 0)))) then
			if (v9.Press(v84.SliceandDice) or ((4132 - (1233 + 180)) <= (2416 - (522 + 447)))) then
				return "Cast Slice and Dice";
			end
		end
		if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((5555 - (107 + 1314)) < (1822 + 2104))) then
			if (v9.Cast(v84.KillingSpree) or ((499 - 335) >= (1183 + 1602))) then
				return "Cast Killing Spree";
			end
		end
		if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((1042 - 517) == (8344 - 6235))) then
			if (((1943 - (716 + 1194)) == (1 + 32)) and v9.Cast(v84.ColdBlood, v55)) then
				return "Cast Cold Blood";
			end
		end
		if (((328 + 2726) <= (4518 - (74 + 429))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
			if (((3609 - 1738) < (1677 + 1705)) and v9.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v124()
		local v141 = 0 - 0;
		while true do
			if (((915 + 378) <= (6677 - 4511)) and (v141 == (7 - 4))) then
				if (v84.SinisterStrike:IsCastable() or ((3012 - (279 + 154)) < (901 - (454 + 324)))) then
					if (v9.Press(v84.SinisterStrike) or ((666 + 180) >= (2385 - (12 + 5)))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v141 == (2 + 0)) or ((10222 - 6210) <= (1241 + 2117))) then
				if (((2587 - (277 + 816)) <= (12840 - 9835)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1184 - (1058 + 125)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((4086 - (815 + 160)) == (9156 - 7022))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((5590 - 3235) == (562 + 1793)) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (2.5 - 1)) or (v98 <= ((1899 - (41 + 1857)) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((2481 - (1222 + 671)) <= (1116 - 684))) then
						return "Cast Pistol Shot";
					end
				end
				v141 = 3 - 0;
			end
			if (((5979 - (229 + 953)) >= (5669 - (1111 + 663))) and ((1580 - (874 + 705)) == v141)) then
				if (((501 + 3076) == (2441 + 1136)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
					if (((7885 - 4091) > (104 + 3589)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (685 - (642 + 37))) or (v15:BuffRemains(v84.Opportunity) < (1 + 1)))) or ((204 + 1071) == (10294 - 6194))) then
					if (v9.Press(v84.PistolShot) or ((2045 - (233 + 221)) >= (8278 - 4698))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v141 = 2 + 0;
			end
			if (((2524 - (718 + 823)) <= (1138 + 670)) and (v141 == (805 - (266 + 539)))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
					if (((8946 - 5177) >= (2418 - 1245)) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((1177 + 308) == (540 + 945)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v9.Press(v84.Ambush) or ((4330 - (657 + 358)) <= (7365 - 4583))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v141 = 2 - 1;
			end
		end
	end
	local function v125()
		local v142 = 1187 - (1151 + 36);
		while true do
			if ((v142 == (4 + 0)) or ((231 + 645) >= (8851 - 5887))) then
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((4064 - (1552 + 280)) > (3331 - (64 + 770)))) then
					local v181 = 0 + 0;
					while true do
						if ((v181 == (0 - 0)) or ((375 + 1735) <= (1575 - (157 + 1086)))) then
							if (((7377 - 3691) > (13892 - 10720)) and (v33 == "Refreshing Healing Potion")) then
								if (v85.RefreshingHealingPotion:IsReady() or ((6862 - 2388) < (1119 - 299))) then
									if (((5098 - (599 + 220)) >= (5738 - 2856)) and v9.Press(v86.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v33 == "Dreamwalker's Healing Potion") or ((3960 - (1813 + 118)) >= (2574 + 947))) then
								if (v85.DreamwalkersHealingPotion:IsReady() or ((3254 - (841 + 376)) >= (6504 - 1862))) then
									if (((400 + 1320) < (12168 - 7710)) and v9.Press(v86.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if ((v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) or ((1295 - (464 + 395)) > (7753 - 4732))) then
					if (((343 + 370) <= (1684 - (467 + 370))) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((4451 - 2297) <= (2959 + 1072)) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (((15820 - 11205) == (720 + 3895)) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((8817 - 5027) == (1020 - (150 + 370)))) then
					local v182 = v82.Interrupt(v84.Kick, 1290 - (74 + 1208), true);
					if (((218 - 129) < (1048 - 827)) and v182) then
						return v182;
					end
					v182 = v82.Interrupt(v84.Kick, 6 + 2, true, v12, v86.KickMouseover);
					if (((2444 - (14 + 376)) >= (2464 - 1043)) and v182) then
						return v182;
					end
					v182 = v82.Interrupt(v84.Blind, 10 + 5, v79);
					if (((608 + 84) < (2917 + 141)) and v182) then
						return v182;
					end
					v182 = v82.Interrupt(v84.Blind, 43 - 28, v79, v12, v86.BlindMouseover);
					if (v182 or ((2448 + 806) == (1733 - (23 + 55)))) then
						return v182;
					end
					v182 = v82.InterruptWithStun(v84.CheapShot, 18 - 10, v15:StealthUp(false, false));
					if (v182 or ((865 + 431) == (4410 + 500))) then
						return v182;
					end
					v182 = v82.InterruptWithStun(v84.KidneyShot, 11 - 3, v15:ComboPoints() > (0 + 0));
					if (((4269 - (652 + 249)) == (9013 - 5645)) and v182) then
						return v182;
					end
				end
				v142 = 1873 - (708 + 1160);
			end
			if (((7174 - 4531) < (6955 - 3140)) and (v142 == (29 - (10 + 17)))) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v142 = 1 + 2;
			end
			if (((3645 - (1400 + 332)) > (945 - 452)) and (v142 == (1911 - (242 + 1666)))) then
				if (((2035 + 2720) > (1257 + 2171)) and v27) then
					local v183 = 0 + 0;
					while true do
						if (((2321 - (850 + 90)) <= (4148 - 1779)) and (v183 == (1391 - (360 + 1030)))) then
							v93 = #v92;
							break;
						end
						if ((v183 == (0 + 0)) or ((13668 - 8825) == (5618 - 1534))) then
							v91 = v15:GetEnemiesInRange(1691 - (909 + 752));
							v92 = v15:GetEnemiesInRange(v95);
							v183 = 1224 - (109 + 1114);
						end
					end
				else
					v93 = 1 - 0;
				end
				v94 = v83.CrimsonVial();
				if (((1818 + 2851) > (605 - (6 + 236))) and v94) then
					return v94;
				end
				v83.Poisons();
				v142 = 3 + 1;
			end
			if ((v142 == (0 + 0)) or ((4426 - 2549) >= (5480 - 2342))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v142 = 1134 - (1076 + 57);
			end
			if (((780 + 3962) >= (4315 - (579 + 110))) and (v142 == (1 + 4))) then
				if (v29 or ((4014 + 526) == (487 + 429))) then
					local v184 = 407 - (174 + 233);
					while true do
						if ((v184 == (0 - 0)) or ((2028 - 872) > (1933 + 2412))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 1204 - (663 + 511), true);
							if (((1996 + 241) < (923 + 3326)) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and not v15:IsMounted() and v59) or ((8271 - 5588) < (14 + 9))) then
					local v185 = 0 - 0;
					while true do
						if (((1686 - 989) <= (395 + 431)) and (v185 == (0 - 0))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (((788 + 317) <= (108 + 1068)) and v94) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if (((4101 - (478 + 244)) <= (4329 - (440 + 77))) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(29 - 21) and v26) then
					if ((v82.TargetIsValid() and v16:IsInRange(1566 - (655 + 901)) and not (v15:IsChanneling() or v15:IsCasting())) or ((147 + 641) >= (1238 + 378))) then
						if (((1252 + 602) <= (13612 - 10233)) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
							if (((5994 - (695 + 750)) == (15533 - 10984)) and v11(v84.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v15:StealthUp(true, false) or ((4663 - 1641) >= (12161 - 9137))) then
							v94 = v83.Stealth(v83.StealthSpell());
							if (((5171 - (285 + 66)) > (5123 - 2925)) and v94) then
								return v94;
							end
						end
						if (v82.TargetIsValid() or ((2371 - (682 + 628)) >= (789 + 4102))) then
							if (((1663 - (176 + 123)) <= (1872 + 2601)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 + 0)) or v113())) then
								if (v9.Cast(v84.RolltheBones) or ((3864 - (239 + 30)) <= (1 + 2))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))) or ((8268 - 3596) == (12017 - 8165))) then
								if (((1874 - (306 + 9)) == (5440 - 3881)) and v9.Cast(v84.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 + 0)))) or ((844 + 908) <= (2253 - 1465))) then
								if (v9.Press(v84.SliceandDice) or ((5282 - (1140 + 235)) == (113 + 64))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((3183 + 287) > (143 + 412)) and v15:StealthUp(true, false)) then
								v94 = v122();
								if (v94 or ((1024 - (33 + 19)) == (233 + 412))) then
									return "Stealth (Opener): " .. v94;
								end
								if (((9537 - 6355) >= (932 + 1183)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
									if (((7633 - 3740) < (4153 + 276)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((3556 - (586 + 103)) < (174 + 1731))) then
									if (v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush)) or ((5529 - 3733) >= (5539 - (1309 + 179)))) then
										return "Cast Ambush (Opener)";
									end
								elseif (((2922 - 1303) <= (1635 + 2121)) and v84.SinisterStrike:IsCastable()) then
									if (((1622 - 1018) == (457 + 147)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
										return "Cast Sinister Strike (Opener)";
									end
								end
							elseif (v114() or ((9526 - 5042) == (1793 - 893))) then
								local v201 = 609 - (295 + 314);
								while true do
									if ((v201 == (0 - 0)) or ((6421 - (1300 + 662)) <= (3494 - 2381))) then
										v94 = v123();
										if (((5387 - (1178 + 577)) > (1765 + 1633)) and v94) then
											return "Finish (Opener): " .. v94;
										end
										break;
									end
								end
							end
							if (((12067 - 7985) <= (6322 - (851 + 554))) and v84.SinisterStrike:IsCastable()) then
								if (((4273 + 559) >= (3843 - 2457)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
				if (((297 - 160) == (439 - (115 + 187))) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					local v186 = 0 + 0;
					while true do
						if ((v186 == (0 + 0)) or ((6186 - 4616) >= (5493 - (160 + 1001)))) then
							v97 = v25(v97, v83.FanTheHammerCP());
							v96 = v83.EffectiveComboPoints(v97);
							v186 = 1 + 0;
						end
						if ((v186 == (1 + 0)) or ((8319 - 4255) <= (2177 - (237 + 121)))) then
							v98 = v15:ComboPointsDeficit();
							break;
						end
					end
				end
				v142 = 903 - (525 + 372);
			end
			if ((v142 == (10 - 4)) or ((16382 - 11396) < (1716 - (96 + 46)))) then
				if (((5203 - (643 + 134)) > (63 + 109)) and v82.TargetIsValid()) then
					local v187 = 0 - 0;
					while true do
						if (((2175 - 1589) > (437 + 18)) and (v187 == (3 - 1))) then
							if (((1688 - 862) == (1545 - (316 + 403))) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(4 + 1)) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((11049 - 7030) > (1605 + 2836))) then
									return "Cast Lights Judgment";
								end
							end
							if (((5079 - 3062) < (3020 + 1241)) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(2 + 3)) then
								if (((16340 - 11624) > (382 - 302)) and v9.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (51 - 26)) and ((v98 >= (1 + 0)) or (v102 <= (1.2 - 0)))) or ((172 + 3335) == (9626 - 6354))) then
								if (v9.Cast(v84.PistolShot) or ((893 - (12 + 5)) >= (11943 - 8868))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((9285 - 4933) > (5428 - 2874)) and not v16:IsSpellInRange(v84.Dispatch)) then
								if (v11(v84.PoolEnergy, false, "OOR") or ((10926 - 6520) < (821 + 3222))) then
									return "Pool Energy (OOR)";
								end
							elseif (v11(v84.PoolEnergy) or ((3862 - (1656 + 317)) >= (3015 + 368))) then
								return "Pool Energy";
							end
							break;
						end
						if (((1517 + 375) <= (7269 - 4535)) and (v187 == (4 - 3))) then
							v94 = v124();
							if (((2277 - (5 + 349)) < (10535 - 8317)) and v94) then
								return "Build: " .. v94;
							end
							if (((3444 - (266 + 1005)) > (250 + 129)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((51 - 36) + v100))) then
								if (v9.Cast(v84.ArcaneTorrent, v30) or ((3411 - 820) == (5105 - (561 + 1135)))) then
									return "Cast Arcane Torrent";
								end
							end
							if (((5882 - 1368) > (10926 - 7602)) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
								if (v9.Cast(v84.ArcanePulse) or ((1274 - (507 + 559)) >= (12114 - 7286))) then
									return "Cast Arcane Pulse";
								end
							end
							v187 = 6 - 4;
						end
						if ((v187 == (388 - (212 + 176))) or ((2488 - (250 + 655)) > (9726 - 6159))) then
							v94 = v121();
							if (v94 or ((2294 - 981) == (1241 - 447))) then
								return "CDs: " .. v94;
							end
							if (((5130 - (1869 + 87)) > (10065 - 7163)) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
								local v193 = 1901 - (484 + 1417);
								while true do
									if (((8830 - 4710) <= (7139 - 2879)) and (v193 == (773 - (48 + 725)))) then
										v94 = v122();
										if (v94 or ((1442 - 559) > (12818 - 8040))) then
											return "Stealth: " .. v94;
										end
										break;
									end
								end
							end
							if (v114() or ((2104 + 1516) >= (13070 - 8179))) then
								local v194 = 0 + 0;
								while true do
									if (((1241 + 3017) > (1790 - (152 + 701))) and (v194 == (1311 - (430 + 881)))) then
										v94 = v123();
										if (v94 or ((1865 + 3004) < (1801 - (557 + 338)))) then
											return "Finish: " .. v94;
										end
										v194 = 1 + 0;
									end
									if ((v194 == (2 - 1)) or ((4289 - 3064) > (11232 - 7004))) then
										return "Finish Pooling";
									end
								end
							end
							v187 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((4129 - (499 + 302)) > (3104 - (39 + 827))) and ((2 - 1) == v142)) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(111 - 61)) or (0 - 0);
				v142 = 2 - 0;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(23 + 237, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

