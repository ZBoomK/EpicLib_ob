local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1801 - (455 + 974)) <= (1660 - 739)) and not v5) then
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
		v30 = EpicSettings.Settings['UseRacials'];
		v32 = EpicSettings.Settings['UseHealingPotion'];
		v33 = EpicSettings.Settings['HealingPotionName'];
		v34 = EpicSettings.Settings['HealingPotionHP'] or (683 - (27 + 656));
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v37 = EpicSettings.Settings['InterruptWithStun'];
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v29 = EpicSettings.Settings['HandleIncorporeal'];
		v52 = EpicSettings.Settings['VanishOffGCD'];
		v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v55 = EpicSettings.Settings['ColdBloodOffGCD'];
		v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
		v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
		v59 = EpicSettings.Settings['StealthOOC'];
		v64 = EpicSettings.Settings['RolltheBonesLogic'];
		v67 = EpicSettings.Settings['UseDPSVanish'];
		v70 = EpicSettings.Settings['BladeFlurryGCD'];
		v71 = EpicSettings.Settings['BladeRushGCD'];
		v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
		v74 = EpicSettings.Settings['KeepItRollingGCD'];
		v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
		v76 = EpicSettings.Settings['EchoingReprimand'];
		v77 = EpicSettings.Settings['UseSoloVanish'];
		v78 = EpicSettings.Settings['sepsis'];
		v79 = EpicSettings.Settings['BlindInterrupt'];
		v80 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
	end
	local v82 = v9.Commons.Everyone;
	local v83 = v9.Commons.Rogue;
	local v84 = v17.Rogue.Outlaw;
	local v85 = v19.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = {};
	local v88 = v15:GetEquipment();
	local v89 = (v88[1924 - (340 + 1571)] and v19(v88[6 + 7])) or v19(1772 - (1733 + 39));
	local v90 = (v88[38 - 24] and v19(v88[1048 - (125 + 909)])) or v19(1948 - (1096 + 852));
	v9:RegisterForEvent(function()
		local v151 = 0 + 0;
		while true do
			if (((5281 - 1582) < (4565 + 141)) and (v151 == (512 - (409 + 103)))) then
				v88 = v15:GetEquipment();
				v89 = (v88[249 - (46 + 190)] and v19(v88[108 - (51 + 44)])) or v19(0 + 0);
				v151 = 1318 - (1114 + 203);
			end
			if (((3372 - (228 + 498)) >= (190 + 686)) and (v151 == (1 + 0))) then
				v90 = (v88[677 - (174 + 489)] and v19(v88[36 - 22])) or v19(1905 - (830 + 1075));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 530 - (303 + 221);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 - 0);
	end}};
	local v105, v106 = 0 - 0, 0 - 0;
	local function v107(v152)
		local v153 = v15:EnergyTimeToMaxPredicted(nil, v152);
		if (((1862 - (111 + 1137)) <= (3342 - (91 + 67))) and ((v153 < v105) or ((v153 - v105) > (0.5 - 0)))) then
			v105 = v153;
		end
		return v105;
	end
	local function v108()
		local v154 = v15:EnergyPredicted();
		if (((780 + 2346) == (3649 - (423 + 100))) and ((v154 > v106) or ((v154 - v106) > (1 + 8)))) then
			v106 = v154;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		local v155 = 711 - (530 + 181);
		while true do
			if ((v155 == (881 - (614 + 267))) or ((2219 - (19 + 13)) >= (8063 - 3109))) then
				if (not v10.APLVar.RtB_Buffs or ((9034 - 5157) == (10212 - 6637))) then
					local v168 = 0 + 0;
					local v169;
					while true do
						if (((1243 - 536) > (1310 - 678)) and (v168 == (1813 - (1293 + 519)))) then
							v10.APLVar.RtB_Buffs.Normal = 0 - 0;
							v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
							v10.APLVar.RtB_Buffs.Longer = 0 - 0;
							v10.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
							v168 = 4 - 2;
						end
						if ((v168 == (2 + 0)) or ((112 + 434) >= (6236 - 3552))) then
							v169 = v83.RtBRemains();
							for v186 = 1 + 0, #v109 do
								local v187 = 0 + 0;
								local v188;
								while true do
									if (((916 + 549) <= (5397 - (709 + 387))) and (v187 == (1858 - (673 + 1185)))) then
										v188 = v15:BuffRemains(v109[v186]);
										if (((4941 - 3237) > (4575 - 3150)) and (v188 > (0 - 0))) then
											local v197 = 0 + 0;
											local v198;
											while true do
												if ((v197 == (1 + 0)) or ((927 - 240) == (1040 + 3194))) then
													v198 = math.abs(v188 - v169);
													if ((v198 <= (0.5 - 0)) or ((6536 - 3206) < (3309 - (446 + 1434)))) then
														local v202 = 1283 - (1040 + 243);
														while true do
															if (((3423 - 2276) >= (2182 - (559 + 1288))) and (v202 == (1931 - (609 + 1322)))) then
																v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (455 - (13 + 441));
																v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
																v202 = 3 - 2;
															end
															if (((8997 - 5562) > (10443 - 8346)) and (v202 == (1 + 0))) then
																v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (3 - 2);
																break;
															end
														end
													elseif ((v188 > v169) or ((1340 + 2430) >= (1771 + 2270))) then
														v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (2 - 1);
													else
														local v207 = 0 + 0;
														while true do
															if ((v207 == (0 - 0)) or ((2507 + 1284) <= (897 + 714))) then
																v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + 1 + 0;
																v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
																v207 = 1 + 0;
															end
															if ((v207 == (1 + 0)) or ((5011 - (153 + 280)) <= (5798 - 3790))) then
																v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
																break;
															end
														end
													end
													break;
												end
												if (((445 + 680) <= (1087 + 989)) and (v197 == (0 + 0))) then
													v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
													if ((v188 > v10.APLVar.RtB_Buffs.MaxRemains) or ((1131 - 388) >= (2719 + 1680))) then
														v10.APLVar.RtB_Buffs.MaxRemains = v188;
													end
													v197 = 668 - (89 + 578);
												end
											end
										end
										v187 = 1 + 0;
									end
									if (((2400 - 1245) < (2722 - (572 + 477))) and (v187 == (1 + 0))) then
										if (v110 or ((1395 + 929) <= (69 + 509))) then
											print("RtbRemains", v169);
											print(v109[v186]:Name(), v188);
										end
										break;
									end
								end
							end
							if (((3853 - (84 + 2)) == (6207 - 2440)) and v110) then
								local v190 = 0 + 0;
								while true do
									if (((4931 - (497 + 345)) == (105 + 3984)) and ((1 + 0) == v190)) then
										print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
										print("normal: ", v10.APLVar.RtB_Buffs.Normal);
										v190 = 1335 - (605 + 728);
									end
									if (((3181 + 1277) >= (3721 - 2047)) and (v190 == (1 + 1))) then
										print("longer: ", v10.APLVar.RtB_Buffs.Longer);
										print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
										break;
									end
									if (((3593 - 2621) <= (1279 + 139)) and (v190 == (0 - 0))) then
										print("have: ", v10.APLVar.RtB_Buffs.Total);
										print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
										v190 = 1 + 0;
									end
								end
							end
							break;
						end
						if ((v168 == (489 - (457 + 32))) or ((2096 + 2842) < (6164 - (832 + 570)))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Will_Lose = {};
							v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
							v10.APLVar.RtB_Buffs.Total = 0 + 0;
							v168 = 3 - 2;
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v112(v156)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v156] and true) or false;
	end
	local function v113()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (796 - (588 + 208))) or ((6748 - 4244) > (6064 - (884 + 916)))) then
				if (((4507 - 2354) == (1249 + 904)) and not v10.APLVar.RtB_Reroll) then
					if ((v64 == "1+ Buff") or ((1160 - (232 + 421)) >= (4480 - (1569 + 320)))) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
					elseif (((852 + 3629) == (15100 - 10619)) and (v64 == "Broadside")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif ((v64 == "Buried Treasure") or ((2933 - (316 + 289)) < (1813 - 1120))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((200 + 4128) == (5781 - (666 + 787))) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif (((2013 - (360 + 65)) >= (1245 + 87)) and (v64 == "Skull and Crossbones")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif ((v64 == "Ruthless Precision") or ((4428 - (79 + 175)) > (6697 - 2449))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((3579 + 1007) <= (251 - 169))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v111();
						v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (3 - 1))));
						if (((4762 - (503 + 396)) == (4044 - (92 + 89))) and v84.Crackshot:IsAvailable() and not v15:HasTier(59 - 28, 3 + 1)) then
							v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
						end
						if ((v84.Crackshot:IsAvailable() and v15:HasTier(121 - 90, 1 + 3)) or ((642 - 360) <= (37 + 5))) then
							v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff)));
						end
						if (((14037 - 9428) >= (96 + 670)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((2 - 0) + v21(v112(v84.GrandMelee)))) and (v93 < (1246 - (485 + 759)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 - 0)) or ((v10.APLVar.RtB_Buffs.Normal == (1189 - (442 + 747))) and (v10.APLVar.RtB_Buffs.Longer >= (1136 - (832 + 303))) and (v111() < (952 - (88 + 858))) and (v10.APLVar.RtB_Buffs.MaxRemains <= (12 + 27)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
						if (v16:FilteredTimeToDie("<", 10 + 2) or v9.BossFilteredFightRemains("<", 1 + 11) or ((1941 - (766 + 23)) == (12282 - 9794))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (1 - 0)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((4 - 2) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (169 - 119));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (1075 - (1036 + 37))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		if (((2427 + 995) > (6523 - 3173)) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (5 + 1))) and v115()) then
			if (((2357 - (641 + 839)) > (1289 - (910 + 3))) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) or ((7948 - 4830) <= (3535 - (1466 + 218)))) then
			if (v9.Cast(v84.Vanish, v67) or ((76 + 89) >= (4640 - (556 + 592)))) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((1405 + 2544) < (5664 - (329 + 479))) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (860 - (174 + 680))) or not v67) and not v15:StealthUp(true, false)) then
			if (v9.Cast(v84.ShadowDance, v53) or ((14693 - 10417) < (6250 - 3234))) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((3349 + 1341) > (4864 - (396 + 343))) and v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) then
			if (v11(v84.ShadowDance, v53) or ((5 + 45) >= (2373 - (29 + 1448)))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (1419 - (135 + 1254))) or ((v84.KeepItRolling:CooldownRemains() >= (452 - 332)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((8002 - 6288) >= (1972 + 986))) then
			if (v9.Cast(v84.ShadowDance, v53) or ((3018 - (389 + 1138)) < (1218 - (102 + 472)))) then
				return "Cast Shadow Dance";
			end
		end
		if (((665 + 39) < (548 + 439)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
			if (((3467 + 251) > (3451 - (320 + 1225))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
				if (v9.Cast(v84.Shadowmeld, v30) or ((1705 - 747) > (2225 + 1410))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v158 = v82.HandleTopTrinket(v87, v28, 1504 - (157 + 1307), nil);
		if (((5360 - (821 + 1038)) <= (11207 - 6715)) and v158) then
			return v158;
		end
		local v158 = v82.HandleBottomTrinket(v87, v28, 5 + 35, nil);
		if (v158 or ((6113 - 2671) < (949 + 1599))) then
			return v158;
		end
	end
	local function v121()
		local v159 = 0 - 0;
		local v160;
		local v161;
		while true do
			if (((3901 - (834 + 192)) >= (94 + 1370)) and ((1 + 0) == v159)) then
				if (v84.BladeFlurry:IsReady() or ((103 + 4694) >= (7580 - 2687))) then
					if (((v93 >= ((306 - (300 + 4)) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((148 + 403) > (5413 - 3345))) then
						if (((2476 - (112 + 250)) > (377 + 567)) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v84.BladeFlurry:IsReady() or ((5666 - 3404) >= (1774 + 1322))) then
					if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (2 + 1)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (4 + 1)))) or ((1119 + 1136) >= (2628 + 909))) then
						if (v11(v84.BladeFlurry) or ((5251 - (1001 + 413)) < (2912 - 1606))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((3832 - (244 + 638)) == (3643 - (627 + 66))) and v84.RolltheBones:IsReady()) then
					if (v113() or (v111() == (0 - 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (605 - (512 + 90))) and v15:HasTier(1937 - (1665 + 241), 721 - (373 + 344))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (4 + 3)) and ((v84.ShadowDance:CooldownRemains() <= (1 + 2)) or (v84.Vanish:CooldownRemains() <= (7 - 4)))) or ((7991 - 3268) < (4397 - (35 + 1064)))) then
						if (((827 + 309) >= (329 - 175)) and v11(v84.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v159 = 1 + 1;
			end
			if ((v159 == (1242 - (298 + 938))) or ((1530 - (233 + 1026)) > (6414 - (636 + 1030)))) then
				if (((2424 + 2316) >= (3079 + 73)) and v84.AncestralCall:IsCastable()) then
					if (v9.Cast(v84.AncestralCall, nil, v30) or ((766 + 1812) >= (230 + 3160))) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((262 - (55 + 166)) <= (322 + 1339)) and (v159 == (1 + 2))) then
				if (((2295 - 1694) < (3857 - (36 + 261))) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (12 - 5))) then
					if (((1603 - (34 + 1334)) < (265 + 422)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((3535 + 1014) > (2436 - (1035 + 248))) and v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 32 - (20 + 1)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 6 + 5) or ((4993 - (134 + 185)) < (5805 - (549 + 584)))) then
						if (((4353 - (314 + 371)) < (15657 - 11096)) and v9.Cast(v84.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v84.BladeRush:IsReady() and (v102 > (972 - (478 + 490))) and not v15:StealthUp(true, true)) or ((242 + 213) == (4777 - (786 + 386)))) then
					if (v9.Cast(v84.BladeRush) or ((8625 - 5962) == (4691 - (1055 + 324)))) then
						return "Cast Blade Rush";
					end
				end
				v159 = 1344 - (1093 + 247);
			end
			if (((3801 + 476) <= (471 + 4004)) and (v159 == (7 - 5))) then
				v161 = v120();
				if (v161 or ((2952 - 2082) == (3382 - 2193))) then
					return v161;
				end
				if (((3902 - 2349) <= (1115 + 2018)) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((11 - 8) + v21(v15:HasTier(106 - 75, 4 + 0)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (15 - 9)))) then
					if (v9.Cast(v84.KeepItRolling) or ((2925 - (364 + 324)) >= (9624 - 6113))) then
						return "Cast Keep it Rolling";
					end
				end
				v159 = 6 - 3;
			end
			if ((v159 == (0 + 0)) or ((5540 - 4216) > (4836 - 1816))) then
				v160 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (v160 or ((9086 - 6094) == (3149 - (1249 + 19)))) then
					return "DPS Pot";
				end
				if (((2804 + 302) > (5939 - 4413)) and v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1088 - (686 + 400)))))) then
					if (((2372 + 651) < (4099 - (73 + 156))) and v11(v84.AdrenalineRush, v75)) then
						return "Cast Adrenaline Rush";
					end
				end
				v159 = 1 + 0;
			end
			if (((954 - (721 + 90)) > (1 + 73)) and (v159 == (16 - 11))) then
				if (((488 - (224 + 246)) < (3421 - 1309)) and v84.BloodFury:IsCastable()) then
					if (((2019 - 922) <= (296 + 1332)) and v9.Cast(v84.BloodFury, nil, v30)) then
						return "Cast Blood Fury";
					end
				end
				if (((111 + 4519) == (3401 + 1229)) and v84.Berserking:IsCastable()) then
					if (((7038 - 3498) > (8928 - 6245)) and v9.Cast(v84.Berserking, nil, v30)) then
						return "Cast Berserking";
					end
				end
				if (((5307 - (203 + 310)) >= (5268 - (1238 + 755))) and v84.Fireblood:IsCastable()) then
					if (((104 + 1380) == (3018 - (709 + 825))) and v9.Cast(v84.Fireblood, nil, v30)) then
						return "Cast Fireblood";
					end
				end
				v159 = 10 - 4;
			end
			if (((2085 - 653) < (4419 - (196 + 668))) and (v159 == (15 - 11))) then
				if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((2206 - 1141) > (4411 - (171 + 662)))) then
					local v170 = 93 - (4 + 89);
					while true do
						if ((v170 == (0 - 0)) or ((1746 + 3049) < (6179 - 4772))) then
							v161 = v119();
							if (((727 + 1126) < (6299 - (35 + 1451))) and v161) then
								return v161;
							end
							break;
						end
					end
				end
				if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (1553 - (28 + 1425))) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (1999 - (941 + 1052))))) or ((2705 + 116) < (3945 - (822 + 692)))) then
					if (v9.Cast(v84.ThistleTea) or ((4102 - 1228) < (1028 + 1153))) then
						return "Cast Thistle Tea";
					end
				end
				if ((v84.BladeRush:IsCastable() and (v102 > (301 - (45 + 252))) and not v15:StealthUp(true, true)) or ((2661 + 28) <= (119 + 224))) then
					if (v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush)) or ((4548 - 2679) == (2442 - (114 + 319)))) then
						return "Cast Blade Rush";
					end
				end
				v159 = 6 - 1;
			end
		end
	end
	local function v122()
		local v162 = 0 - 0;
		while true do
			if ((v162 == (2 + 1)) or ((5282 - 1736) < (4864 - 2542))) then
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((4045 - (556 + 1407)) == (5979 - (741 + 465)))) then
					if (((3709 - (170 + 295)) > (556 + 499)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if ((v162 == (0 + 0)) or ((8156 - 4843) <= (1474 + 304))) then
				if ((v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (2 + 0)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((805 + 616) >= (3334 - (957 + 273)))) then
					if (((485 + 1327) <= (1301 + 1948)) and v70) then
						v9.Cast(v84.BladeFlurry);
					elseif (((6184 - 4561) <= (5156 - 3199)) and v9.Cast(v84.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((13476 - 9064) == (21846 - 17434)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (((3530 - (389 + 1391)) >= (529 + 313)) and v9.Cast(v84.ColdBlood, v55)) then
						return "Cast Cold Blood";
					end
				end
				v162 = 1 + 0;
			end
			if (((9953 - 5581) > (2801 - (783 + 168))) and (v162 == (6 - 4))) then
				if (((229 + 3) < (1132 - (309 + 2))) and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (5 - 3)) and (v15:BuffStack(v84.Opportunity) >= (1218 - (1090 + 122))) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
					if (((1739 - 1221) < (618 + 284)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((4112 - (628 + 490)) > (154 + 704)) and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v9.Cast(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush)) or ((9297 - 5542) <= (4181 - 3266))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v162 = 777 - (431 + 343);
			end
			if (((7969 - 4023) > (10828 - 7085)) and (v162 == (1 + 0))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((171 + 1164) >= (5001 - (556 + 1139)))) then
					if (((4859 - (6 + 9)) > (413 + 1840)) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((232 + 220) == (621 - (28 + 141))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (v9.Press(v84.Dispatch) or ((1766 + 2791) < (2575 - 488))) then
						return "Cast Dispatch";
					end
				end
				v162 = 2 + 0;
			end
		end
	end
	local function v123()
		local v163 = 1317 - (486 + 831);
		while true do
			if (((10081 - 6207) == (13638 - 9764)) and (v163 == (0 + 0))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (12 - 8)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(1293 - (668 + 595), 4 + 0)) and v15:BuffDown(v84.GreenskinsWickers)) or ((391 + 1547) > (13458 - 8523))) then
					if (v9.Press(v84.BetweentheEyes) or ((4545 - (23 + 267)) < (5367 - (1129 + 815)))) then
						return "Cast Between the Eyes";
					end
				end
				if (((1841 - (371 + 16)) <= (4241 - (1326 + 424))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (84 - 39)) and (v84.ShadowDance:CooldownRemains() > (43 - 31))) then
					if (v9.Press(v84.BetweentheEyes) or ((4275 - (88 + 30)) <= (3574 - (720 + 51)))) then
						return "Cast Between the Eyes";
					end
				end
				v163 = 2 - 1;
			end
			if (((6629 - (421 + 1355)) >= (4918 - 1936)) and (v163 == (1 + 1))) then
				if (((5217 - (286 + 797)) > (12271 - 8914)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) then
					if (v9.Cast(v84.ColdBlood, v55) or ((5659 - 2242) < (2973 - (397 + 42)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((851 + 1871) <= (964 - (24 + 776)))) then
					if (v9.Press(v84.Dispatch) or ((3709 - 1301) < (2894 - (222 + 563)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v163 == (1 - 0)) or ((24 + 9) == (1645 - (23 + 167)))) then
				if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (1798 - (690 + 1108)))) and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 + 0)))) or ((1291 - (40 + 808)) >= (662 + 3353))) then
					if (((12932 - 9550) > (159 + 7)) and v9.Press(v84.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((149 + 131) == (1678 + 1381))) then
					if (((2452 - (47 + 524)) > (840 + 453)) and v9.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v163 = 5 - 3;
			end
		end
	end
	local function v124()
		if (((3523 - 1166) == (5375 - 3018)) and v28 and v84.EchoingReprimand:IsReady()) then
			if (((1849 - (1165 + 561)) == (4 + 119)) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((3270 - 2214) >= (1295 + 2097))) then
			if (v9.Press(v84.Ambush) or ((1560 - (341 + 138)) < (291 + 784))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((2164 - 1115) >= (4758 - (89 + 237)))) then
			if (v9.Press(v84.PistolShot) or ((15338 - 10570) <= (1780 - 934))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (887 - (581 + 300))) or (v15:BuffRemains(v84.Opportunity) < (1222 - (855 + 365))))) or ((7975 - 4617) <= (464 + 956))) then
			if (v9.Press(v84.PistolShot) or ((4974 - (1030 + 205)) <= (2822 + 183))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= (1 + 0 + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (287 - (156 + 130)))))) or (v97 <= (2 - 1)))) or ((2795 - 1136) >= (4370 - 2236))) then
			if (v9.Press(v84.PistolShot) or ((860 + 2400) < (1374 + 981))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if ((not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (70.5 - (10 + 59))) or (v98 <= (1 + 0 + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((3294 - 2625) == (5386 - (671 + 492)))) then
			if (v9.Cast(v84.PistolShot) or ((1347 + 345) < (1803 - (369 + 846)))) then
				return "Cast Pistol Shot";
			end
		end
		if (v84.SinisterStrike:IsCastable() or ((1270 + 3527) < (3116 + 535))) then
			if (v9.Press(v84.SinisterStrike) or ((6122 - (1036 + 909)) > (3857 + 993))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		local v164 = 0 - 0;
		while true do
			if ((v164 == (208 - (11 + 192))) or ((203 + 197) > (1286 - (135 + 40)))) then
				v83.Poisons();
				if (((7392 - 4341) > (606 + 399)) and v32 and (v15:HealthPercentage() <= v34)) then
					if (((8135 - 4442) <= (6568 - 2186)) and (v33 == "Refreshing Healing Potion")) then
						if (v85.RefreshingHealingPotion:IsReady() or ((3458 - (50 + 126)) > (11416 - 7316))) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((793 + 2787) < (4257 - (1233 + 180)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1058 - (522 + 447)) < (5911 - (107 + 1314))) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((2313 + 2670) < (5508 - 3700))) then
							if (((1627 + 2202) > (7484 - 3715)) and v9.Press(v86.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((5875 - 4390) <= (4814 - (716 + 1194))) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (((73 + 4196) == (458 + 3811)) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v164 = 509 - (74 + 429);
			end
			if (((746 - 359) <= (1379 + 1403)) and (v164 == (13 - 7))) then
				if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) or ((1344 + 555) <= (2827 - 1910))) then
					if (v9.Cast(v84.Evasion) or ((10661 - 6349) <= (1309 - (279 + 154)))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((3010 - (454 + 324)) <= (2043 + 553)) and not v15:IsCasting() and not v15:IsChanneling()) then
					local v171 = 17 - (12 + 5);
					local v172;
					while true do
						if (((1130 + 965) < (9391 - 5705)) and (v171 == (1 + 1))) then
							v172 = v82.InterruptWithStun(v84.CheapShot, 1101 - (277 + 816), v15:StealthUp(false, false));
							if (v172 or ((6815 - 5220) >= (5657 - (1058 + 125)))) then
								return v172;
							end
							v172 = v82.InterruptWithStun(v84.KidneyShot, 2 + 6, v15:ComboPoints() > (975 - (815 + 160)));
							if (v172 or ((19818 - 15199) < (6841 - 3959))) then
								return v172;
							end
							break;
						end
						if ((v171 == (1 + 0)) or ((859 - 565) >= (6729 - (41 + 1857)))) then
							v172 = v82.Interrupt(v84.Blind, 1908 - (1222 + 671), v79);
							if (((5243 - 3214) <= (4432 - 1348)) and v172) then
								return v172;
							end
							v172 = v82.Interrupt(v84.Blind, 1197 - (229 + 953), v79, v12, v86.BlindMouseover);
							if (v172 or ((3811 - (1111 + 663)) == (3999 - (874 + 705)))) then
								return v172;
							end
							v171 = 1 + 1;
						end
						if (((3042 + 1416) > (8114 - 4210)) and (v171 == (0 + 0))) then
							v172 = v82.Interrupt(v84.Kick, 687 - (642 + 37), true);
							if (((100 + 336) >= (20 + 103)) and v172) then
								return v172;
							end
							v172 = v82.Interrupt(v84.Kick, 19 - 11, true, v12, v86.KickMouseover);
							if (((954 - (233 + 221)) < (4199 - 2383)) and v172) then
								return v172;
							end
							v171 = 1 + 0;
						end
					end
				end
				if (((5115 - (718 + 823)) == (2249 + 1325)) and v29) then
					v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 835 - (266 + 539), true);
					if (((625 - 404) < (1615 - (636 + 589))) and v94) then
						return v94;
					end
				end
				v164 = 16 - 9;
			end
			if ((v164 == (5 - 2)) or ((1754 + 459) <= (517 + 904))) then
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v164 = 1019 - (657 + 358);
			end
			if (((8096 - 5038) < (11072 - 6212)) and ((1187 - (1151 + 36)) == v164)) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v164 = 1 + 0;
			end
			if ((v164 == (1 + 0)) or ((3870 - 2574) >= (6278 - (1552 + 280)))) then
				v28 = EpicSettings.Toggles['cds'];
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v164 = 836 - (64 + 770);
			end
			if ((v164 == (5 + 2)) or ((3162 - 1769) > (798 + 3691))) then
				if ((not v15:AffectingCombat() and not v15:IsMounted() and v59) or ((5667 - (157 + 1086)) < (53 - 26))) then
					local v173 = 0 - 0;
					while true do
						if ((v173 == (0 - 0)) or ((2725 - 728) > (4634 - (599 + 220)))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (((6899 - 3434) > (3844 - (1813 + 118))) and v94) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if (((536 + 197) < (3036 - (841 + 376))) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(2 + 6) and v26) then
					if ((v82.TargetIsValid() and v16:IsInRange(27 - 17) and not (v15:IsChanneling() or v15:IsCasting())) or ((5254 - (464 + 395)) == (12203 - 7448))) then
						local v177 = 0 + 0;
						while true do
							if (((837 - (467 + 370)) == v177) or ((7837 - 4044) < (1739 + 630))) then
								if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((13999 - 9915) == (42 + 223))) then
									if (((10138 - 5780) == (4878 - (150 + 370))) and v11(v84.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v15:StealthUp(true, false) or ((4420 - (74 + 1208)) < (2442 - 1449))) then
									local v194 = 0 - 0;
									while true do
										if (((2370 + 960) > (2713 - (14 + 376))) and (v194 == (0 - 0))) then
											v94 = v83.Stealth(v83.StealthSpell());
											if (v94 or ((2347 + 1279) == (3505 + 484))) then
												return v94;
											end
											break;
										end
									end
								end
								v177 = 1 + 0;
							end
							if ((v177 == (2 - 1)) or ((690 + 226) == (2749 - (23 + 55)))) then
								if (((644 - 372) == (182 + 90)) and v82.TargetIsValid()) then
									local v195 = 0 + 0;
									while true do
										if (((6587 - 2338) <= (1523 + 3316)) and (v195 == (903 - (652 + 249)))) then
											if (((7431 - 4654) < (5068 - (708 + 1160))) and v84.SinisterStrike:IsCastable()) then
												if (((257 - 162) < (3567 - 1610)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if (((853 - (10 + 17)) < (386 + 1331)) and (v195 == (1732 - (1400 + 332)))) then
											if (((2734 - 1308) >= (3013 - (242 + 1666))) and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))) then
												if (((1010 + 1744) <= (2880 + 499)) and v9.Cast(v84.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (940 - (850 + 90))) or v113())) or ((6877 - 2950) == (2803 - (360 + 1030)))) then
												if (v9.Cast(v84.RolltheBones) or ((1022 + 132) <= (2223 - 1435))) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											v195 = 1 - 0;
										end
										if ((v195 == (1662 - (909 + 752))) or ((2866 - (109 + 1114)) > (6185 - 2806))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (243.8 - (6 + 236))))) or ((1766 + 1037) > (3662 + 887))) then
												if (v9.Press(v84.SliceandDice) or ((518 - 298) >= (5278 - 2256))) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((3955 - (1076 + 57)) == (465 + 2357)) and v15:StealthUp(true, false)) then
												v94 = v122();
												if (v94 or ((1750 - (579 + 110)) == (147 + 1710))) then
													return "Stealth (Opener): " .. v94;
												end
												if (((2441 + 319) > (724 + 640)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
													if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((5309 - (174 + 233)) <= (10041 - 6446))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((6760 - 2908) == (131 + 162))) then
													if (v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush)) or ((2733 - (663 + 511)) == (4094 + 494))) then
														return "Cast Ambush (Opener)";
													end
												elseif (v84.SinisterStrike:IsCastable() or ((974 + 3510) == (2429 - 1641))) then
													if (((2767 + 1801) >= (9198 - 5291)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
											elseif (((3016 - 1770) < (1656 + 1814)) and v114()) then
												v94 = v123();
												if (((7917 - 3849) >= (693 + 279)) and v94) then
													return "Finish (Opener): " .. v94;
												end
											end
											v195 = 1 + 1;
										end
									end
								end
								return;
							end
						end
					end
				end
				if (((1215 - (478 + 244)) < (4410 - (440 + 77))) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					v97 = v25(v97, v83.FanTheHammerCP());
					v96 = v83.EffectiveComboPoints(v97);
					v98 = v15:ComboPointsDeficit();
				end
				v164 = 4 + 4;
			end
			if ((v164 == (7 - 5)) or ((3029 - (655 + 901)) >= (618 + 2714))) then
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(39 + 11)) or (0 + 0);
				v99 = v108();
				v164 = 11 - 8;
			end
			if ((v164 == (1449 - (695 + 750))) or ((13832 - 9781) <= (1785 - 628))) then
				if (((2428 - 1824) < (3232 - (285 + 66))) and v27) then
					local v174 = 0 - 0;
					while true do
						if ((v174 == (1310 - (682 + 628))) or ((146 + 754) == (3676 - (176 + 123)))) then
							v91 = v15:GetEnemiesInRange(13 + 17);
							v92 = v15:GetEnemiesInRange(v95);
							v174 = 1 + 0;
						end
						if (((4728 - (239 + 30)) > (161 + 430)) and (v174 == (1 + 0))) then
							v93 = #v92;
							break;
						end
					end
				else
					v93 = 1 - 0;
				end
				v94 = v83.CrimsonVial();
				if (((10601 - 7203) >= (2710 - (306 + 9))) and v94) then
					return v94;
				end
				v164 = 17 - 12;
			end
			if ((v164 == (2 + 6)) or ((1340 + 843) >= (1360 + 1464))) then
				if (((5536 - 3600) == (3311 - (1140 + 235))) and v82.TargetIsValid()) then
					local v175 = 0 + 0;
					while true do
						if ((v175 == (2 + 0)) or ((1241 + 3591) < (4365 - (33 + 19)))) then
							if (((1477 + 2611) > (11611 - 7737)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > (7 + 8 + v100))) then
								if (((8495 - 4163) == (4063 + 269)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((4688 - (586 + 103)) >= (265 + 2635)) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
								if (v9.Cast(v84.ArcanePulse) or ((7773 - 5248) > (5552 - (1309 + 179)))) then
									return "Cast Arcane Pulse";
								end
							end
							if (((7890 - 3519) == (1903 + 2468)) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(13 - 8)) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((201 + 65) > (10593 - 5607))) then
									return "Cast Lights Judgment";
								end
							end
							v175 = 5 - 2;
						end
						if (((2600 - (295 + 314)) >= (2271 - 1346)) and (v175 == (1965 - (1300 + 662)))) then
							if (((1428 - 973) < (3808 - (1178 + 577))) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(3 + 2)) then
								if (v9.Cast(v84.BagofTricks, v30) or ((2441 - 1615) == (6256 - (851 + 554)))) then
									return "Cast Bag of Tricks";
								end
							end
							if (((162 + 21) == (507 - 324)) and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (54 - 29)) and ((v98 >= (303 - (115 + 187))) or (v102 <= (1.2 + 0)))) then
								if (((1098 + 61) <= (7045 - 5257)) and v9.Cast(v84.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((4668 - (160 + 1001)) > (3778 + 540))) then
								if (v9.Cast(v84.SinisterStrike) or ((2122 + 953) <= (6069 - 3104))) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if (((1723 - (237 + 121)) <= (2908 - (525 + 372))) and (v175 == (0 - 0))) then
							v94 = v121();
							if (v94 or ((9120 - 6344) > (3717 - (96 + 46)))) then
								return "CDs: " .. v94;
							end
							if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((3331 - (643 + 134)) == (1735 + 3069))) then
								local v191 = 0 - 0;
								while true do
									if (((9567 - 6990) == (2472 + 105)) and (v191 == (0 - 0))) then
										v94 = v122();
										if (v94 or ((12 - 6) >= (2608 - (316 + 403)))) then
											return "Stealth: " .. v94;
										end
										break;
									end
								end
							end
							v175 = 1 + 0;
						end
						if (((1391 - 885) <= (684 + 1208)) and (v175 == (2 - 1))) then
							if (v114() or ((1423 + 585) > (715 + 1503))) then
								local v192 = 0 - 0;
								while true do
									if (((1810 - 1431) <= (8614 - 4467)) and ((0 + 0) == v192)) then
										v94 = v123();
										if (v94 or ((8885 - 4371) <= (50 + 959))) then
											return "Finish: " .. v94;
										end
										v192 = 2 - 1;
									end
									if ((v192 == (18 - (12 + 5))) or ((13578 - 10082) == (2542 - 1350))) then
										return "Finish Pooling";
									end
								end
							end
							v94 = v124();
							if (v94 or ((442 - 234) == (7337 - 4378))) then
								return "Build: " .. v94;
							end
							v175 = 1 + 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(2233 - (1656 + 317), v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

