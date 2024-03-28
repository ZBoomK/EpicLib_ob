local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1227 - (83 + 468)) >= (3448 - (1202 + 604)))) then
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
		v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v37 = EpicSettings.Settings['InterruptWithStun'] or (325 - (45 + 280));
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
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
		v70 = EpicSettings.Settings['BladeFlurryGCD'] or (0 + 0);
		v71 = EpicSettings.Settings['BladeRushGCD'];
		v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
		v74 = EpicSettings.Settings['KeepItRollingGCD'];
		v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
		v76 = EpicSettings.Settings['EchoingReprimand'];
		v77 = EpicSettings.Settings['UseSoloVanish'];
		v78 = EpicSettings.Settings['sepsis'];
		v79 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
		v80 = EpicSettings.Settings['EvasionHP'] or (1911 - (340 + 1571));
	end
	local v82 = v9.Commons.Everyone;
	local v83 = v9.Commons.Rogue;
	local v84 = v17.Rogue.Outlaw;
	local v85 = v19.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = {};
	local v88 = v15:GetEquipment();
	local v89 = (v88[6 + 7] and v19(v88[1785 - (1733 + 39)])) or v19(0 - 0);
	local v90 = (v88[1048 - (125 + 909)] and v19(v88[1962 - (1096 + 852)])) or v19(0 + 0);
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[17 - 4] and v19(v88[13 + 0])) or v19(512 - (409 + 103));
		v90 = (v88[250 - (46 + 190)] and v19(v88[109 - (51 + 44)])) or v19(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 1323 - (1114 + 203);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 1162 - (171 + 991), 0 - 0;
	local function v107(v146)
		local v147 = 0 - 0;
		local v148;
		while true do
			if (((10321 - 6185) > (1919 + 478)) and (v147 == (0 - 0))) then
				v148 = v15:EnergyTimeToMaxPredicted(nil, v146);
				if ((v148 < v105) or ((v148 - v105) > (0.5 - 0)) or ((6985 - 2651) == (13122 - 8877))) then
					v105 = v148;
				end
				v147 = 1249 - (111 + 1137);
			end
			if ((v147 == (159 - (91 + 67))) or ((12726 - 8450) <= (757 + 2274))) then
				return v105;
			end
		end
	end
	local function v108()
		local v149 = v15:EnergyPredicted();
		if ((v149 > v106) or ((v149 - v106) > (532 - (423 + 100))) or ((34 + 4748) <= (3319 - 2120))) then
			v106 = v149;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		local v150 = 881 - (614 + 267);
		while true do
			if ((v150 == (32 - (19 + 13))) or ((7916 - 3052) < (4431 - 2529))) then
				if (((13823 - 8984) >= (961 + 2739)) and not v10.APLVar.RtB_Buffs) then
					local v164 = 0 - 0;
					local v165;
					while true do
						if ((v164 == (1 - 0)) or ((2887 - (1293 + 519)) > (3913 - 1995))) then
							v10.APLVar.RtB_Buffs.Normal = 0 - 0;
							v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
							v10.APLVar.RtB_Buffs.Longer = 0 - 0;
							v10.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
							v164 = 2 + 0;
						end
						if (((81 + 315) <= (8838 - 5034)) and (v164 == (1 + 1))) then
							v165 = v83.RtBRemains();
							for v183 = 1 + 0, #v109 do
								local v184 = 0 + 0;
								local v185;
								while true do
									if ((v184 == (1096 - (709 + 387))) or ((6027 - (673 + 1185)) == (6342 - 4155))) then
										v185 = v15:BuffRemains(v109[v183]);
										if (((4514 - 3108) == (2312 - 906)) and (v185 > (0 + 0))) then
											local v192 = 0 + 0;
											local v193;
											while true do
												if (((2066 - 535) < (1049 + 3222)) and (v192 == (0 - 0))) then
													v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1 - 0);
													if (((2515 - (446 + 1434)) == (1918 - (1040 + 243))) and (v185 > v10.APLVar.RtB_Buffs.MaxRemains)) then
														v10.APLVar.RtB_Buffs.MaxRemains = v185;
													end
													v192 = 2 - 1;
												end
												if (((5220 - (559 + 1288)) <= (5487 - (609 + 1322))) and (v192 == (455 - (13 + 441)))) then
													v193 = math.abs(v185 - v165);
													if ((v193 <= (0.5 - 0)) or ((8620 - 5329) < (16335 - 13055))) then
														local v199 = 0 + 0;
														while true do
															if (((15929 - 11543) >= (311 + 562)) and ((1 + 0) == v199)) then
																v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
																break;
															end
															if (((504 + 417) <= (2026 - 924)) and (v199 == (0 + 0))) then
																v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
																v10.APLVar.RtB_Buffs.Will_Lose[v109[v183]:Name()] = true;
																v199 = 1 + 0;
															end
														end
													elseif (((3952 + 754) >= (943 + 20)) and (v185 > v165)) then
														v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (434 - (153 + 280));
													else
														v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (2 - 1);
														v10.APLVar.RtB_Buffs.Will_Lose[v109[v183]:Name()] = true;
														v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
													end
													break;
												end
											end
										end
										v184 = 1 + 0;
									end
									if ((v184 == (1 + 0)) or ((872 + 88) <= (635 + 241))) then
										if (v110 or ((3145 - 1079) == (577 + 355))) then
											print("RtbRemains", v165);
											print(v109[v183]:Name(), v185);
										end
										break;
									end
								end
							end
							if (((5492 - (89 + 578)) < (3460 + 1383)) and v110) then
								local v187 = 0 - 0;
								while true do
									if ((v187 == (1050 - (572 + 477))) or ((523 + 3354) >= (2723 + 1814))) then
										print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
										print("normal: ", v10.APLVar.RtB_Buffs.Normal);
										v187 = 1 + 1;
									end
									if ((v187 == (86 - (84 + 2))) or ((7111 - 2796) < (1244 + 482))) then
										print("have: ", v10.APLVar.RtB_Buffs.Total);
										print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
										v187 = 843 - (497 + 345);
									end
									if ((v187 == (1 + 1)) or ((622 + 3057) < (1958 - (605 + 728)))) then
										print("longer: ", v10.APLVar.RtB_Buffs.Longer);
										print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
										break;
									end
								end
							end
							break;
						end
						if ((v164 == (0 + 0)) or ((10282 - 5657) < (29 + 603))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Will_Lose = {};
							v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
							v10.APLVar.RtB_Buffs.Total = 0 + 0;
							v164 = 2 - 1;
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v112(v151)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v151] and true) or false;
	end
	local function v113()
		if (not v10.APLVar.RtB_Reroll or ((63 + 20) > (2269 - (457 + 32)))) then
			if (((232 + 314) <= (2479 - (832 + 570))) and (v64 == "1+ Buff")) then
				v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
			elseif ((v64 == "Broadside") or ((260 + 736) > (15220 - 10919))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif (((1961 + 2109) > (1483 - (588 + 208))) and (v64 == "Buried Treasure")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif ((v64 == "Grand Melee") or ((1767 - 1111) >= (5130 - (884 + 916)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif ((v64 == "Skull and Crossbones") or ((5216 - 2724) <= (195 + 140))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((4975 - (232 + 421)) >= (4451 - (1569 + 320))) and (v64 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((893 + 2744) >= (717 + 3053))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				local v196 = 0 - 0;
				while true do
					if ((v196 == (606 - (316 + 289))) or ((6227 - 3848) > (212 + 4366))) then
						if (((v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (1455 - (666 + 787)))) or ((908 - (360 + 65)) > (695 + 48))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((2708 - (79 + 175)) > (910 - 332)) and v84.Crackshot:IsAvailable() and not v15:HasTier(25 + 6, 12 - 8) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 - 0))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v196 = 901 - (503 + 396);
					end
					if (((1111 - (92 + 89)) < (8648 - 4190)) and ((0 + 0) == v196)) then
						v10.APLVar.RtB_Reroll = false;
						v111();
						v196 = 1 + 0;
					end
					if (((2592 - 1930) <= (133 + 839)) and (v196 == (4 - 2))) then
						if (((3813 + 557) == (2088 + 2282)) and v84.Crackshot:IsAvailable() and v15:HasTier(94 - 63, 1 + 3) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((1 - 0) + v21(v15:BuffUp(v84.LoadedDiceBuff))))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((1246 - (485 + 759)) + v112(v84.GrandMelee))) and (v93 < (4 - 2))) or ((5951 - (442 + 747)) <= (1996 - (832 + 303)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v196 = 949 - (88 + 858);
					end
					if ((v196 == (1 + 2)) or ((1169 + 243) == (176 + 4088))) then
						if ((v10.APLVar.RtB_Reroll and (v10.APLVar.RtB_Buffs.Longer == (789 - (766 + 23)))) or ((v10.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v111() < (15 - 9)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (132 - 93)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)) or ((4241 - (1036 + 37)) < (1527 + 626))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (v16:FilteredTimeToDie("<", 23 - 11) or v9.BossFilteredFightRemains("<", 10 + 2) or ((6456 - (641 + 839)) < (2245 - (910 + 3)))) then
							v10.APLVar.RtB_Reroll = false;
						end
						break;
					end
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (2 - 1)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((1686 - (1466 + 218)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (23 + 27));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (1150 - (556 + 592))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v152 = 0 + 0;
		while true do
			if (((5436 - (329 + 479)) == (5482 - (174 + 680))) and (v152 == (3 - 2))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (11 - 5)) or not v67) and not v15:StealthUp(true, false)) or ((39 + 15) == (1134 - (396 + 343)))) then
					if (((8 + 74) == (1559 - (29 + 1448))) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((1970 - (135 + 1254)) < (1062 - 780))) then
					if (v11(v84.ShadowDance, v53) or ((21519 - 16910) < (1663 + 832))) then
						return "Cast Shadow Dance";
					end
				end
				v152 = 1529 - (389 + 1138);
			end
			if (((1726 - (102 + 472)) == (1088 + 64)) and (v152 == (2 + 0))) then
				if (((1768 + 128) <= (4967 - (320 + 1225))) and v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (53 - 23)) or ((v84.KeepItRolling:CooldownRemains() >= (74 + 46)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((2454 - (157 + 1307)) > (3479 - (821 + 1038)))) then
						return "Cast Shadow Dance";
					end
				end
				if ((v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) or ((2187 - 1310) > (514 + 4181))) then
					if (((4779 - 2088) >= (689 + 1162)) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
						if (v9.Cast(v84.Shadowmeld, v30) or ((7398 - 4413) >= (5882 - (834 + 192)))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((272 + 4004) >= (307 + 888)) and (v152 == (0 + 0))) then
				if (((5006 - 1774) <= (4994 - (300 + 4))) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (2 + 4))) and v115()) then
					if (v9.Cast(v84.Vanish, v67) or ((2345 - 1449) >= (3508 - (112 + 250)))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((1221 + 1840) >= (7410 - 4452)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (((1826 + 1361) >= (334 + 310)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (Finish)";
					end
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v120()
		local v153 = v82.HandleTopTrinket(v87, v28, 20 + 20, nil);
		if (((479 + 165) <= (2118 - (1001 + 413))) and v153) then
			return v153;
		end
		local v153 = v82.HandleBottomTrinket(v87, v28, 89 - 49, nil);
		if (((1840 - (244 + 638)) > (1640 - (627 + 66))) and v153) then
			return v153;
		end
	end
	local function v121()
		local v154 = 0 - 0;
		local v155;
		local v156;
		while true do
			if (((5094 - (512 + 90)) >= (4560 - (1665 + 241))) and (v154 == (719 - (373 + 344)))) then
				v156 = v120();
				if (((1553 + 1889) >= (398 + 1105)) and v156) then
					return v156;
				end
				if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((7 - 4) + v21(v15:HasTier(52 - 21, 1103 - (35 + 1064))))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (5 + 1)))) or ((6782 - 3612) <= (6 + 1458))) then
					if (v9.Cast(v84.KeepItRolling) or ((6033 - (298 + 938)) == (5647 - (233 + 1026)))) then
						return "Cast Keep it Rolling";
					end
				end
				v154 = 1669 - (636 + 1030);
			end
			if (((282 + 269) <= (666 + 15)) and (v154 == (2 + 2))) then
				if (((222 + 3055) > (628 - (55 + 166))) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
					v156 = v119();
					if (((910 + 3785) >= (143 + 1272)) and v156) then
						return v156;
					end
				end
				if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (381 - 281)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (303 - (36 + 261))))) or ((5616 - 2404) <= (2312 - (34 + 1334)))) then
					if (v9.Cast(v84.ThistleTea) or ((1191 + 1905) <= (1398 + 400))) then
						return "Cast Thistle Tea";
					end
				end
				if (((4820 - (1035 + 248)) == (3558 - (20 + 1))) and v84.BladeRush:IsCastable() and (v102 > (3 + 1)) and not v15:StealthUp(true, true)) then
					if (((4156 - (134 + 185)) >= (2703 - (549 + 584))) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v154 = 690 - (314 + 371);
			end
			if ((v154 == (0 - 0)) or ((3918 - (478 + 490)) == (2020 + 1792))) then
				v155 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (((5895 - (786 + 386)) >= (7507 - 5189)) and v155) then
					return "DPS Pot";
				end
				if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1381 - (1055 + 324)))))) or ((3367 - (1093 + 247)) > (2535 + 317))) then
					if (v11(v84.AdrenalineRush, v75) or ((120 + 1016) > (17139 - 12822))) then
						return "Cast Adrenaline Rush";
					end
				end
				v154 = 3 - 2;
			end
			if (((13510 - 8762) == (11931 - 7183)) and (v154 == (1 + 0))) then
				if (((14392 - 10656) <= (16337 - 11597)) and v84.BladeFlurry:IsReady()) then
					if (((v93 >= ((2 + 0) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((8669 - 5279) <= (3748 - (364 + 324)))) then
						if (v11(v84.BladeFlurry) or ((2738 - 1739) > (6461 - 3768))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((154 + 309) < (2514 - 1913)) and v84.BladeFlurry:IsReady()) then
					if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (4 - 1)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (15 - 10)))) or ((3451 - (1249 + 19)) < (621 + 66))) then
						if (((17706 - 13157) == (5635 - (686 + 400))) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((3666 + 1006) == (4901 - (73 + 156))) and v84.RolltheBones:IsReady()) then
					if ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (814 - (721 + 90))) and v15:HasTier(1 + 30, 12 - 8)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (477 - (224 + 246))) and ((v84.ShadowDance:CooldownRemains() <= (4 - 1)) or (v84.Vanish:CooldownRemains() <= (5 - 2))) and not v15:StealthUp(true, true)) or ((666 + 3002) < (10 + 385))) then
						if (v11(v84.RolltheBones) or ((3060 + 1106) == (904 - 449))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v154 = 6 - 4;
			end
			if ((v154 == (519 - (203 + 310))) or ((6442 - (1238 + 755)) == (187 + 2476))) then
				if (v84.AncestralCall:IsCastable() or ((5811 - (709 + 825)) < (5507 - 2518))) then
					if (v9.Cast(v84.AncestralCall, v30) or ((1267 - 397) >= (5013 - (196 + 668)))) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((8733 - 6521) < (6593 - 3410)) and ((838 - (171 + 662)) == v154)) then
				if (((4739 - (4 + 89)) > (10486 - 7494)) and v84.BloodFury:IsCastable()) then
					if (((523 + 911) < (13642 - 10536)) and v9.Cast(v84.BloodFury, v30)) then
						return "Cast Blood Fury";
					end
				end
				if (((309 + 477) < (4509 - (35 + 1451))) and v84.Berserking:IsCastable()) then
					if (v9.Cast(v84.Berserking, v30) or ((3895 - (28 + 1425)) < (2067 - (941 + 1052)))) then
						return "Cast Berserking";
					end
				end
				if (((4349 + 186) == (6049 - (822 + 692))) and v84.Fireblood:IsCastable()) then
					if (v9.Cast(v84.Fireblood, v30) or ((4295 - 1286) <= (992 + 1113))) then
						return "Cast Fireblood";
					end
				end
				v154 = 303 - (45 + 252);
			end
			if (((1811 + 19) < (1263 + 2406)) and (v154 == (7 - 4))) then
				if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (440 - (114 + 319)))) or ((2053 - 623) >= (4628 - 1016))) then
					if (((1711 + 972) >= (3665 - 1205)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((3779 - 1975) >= (5238 - (556 + 1407)))) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 1217 - (741 + 465)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 476 - (170 + 295)) or ((747 + 670) > (3334 + 295))) then
						if (((11805 - 7010) > (334 + 68)) and v9.Cast(v84.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((3087 + 1726) > (2019 + 1546)) and v84.BladeRush:IsReady() and (v102 > (1234 - (957 + 273))) and not v15:StealthUp(true, true)) then
					if (((1047 + 2865) == (1567 + 2345)) and v9.Cast(v84.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v154 = 15 - 11;
			end
		end
	end
	local function v122()
		local v157 = 0 - 0;
		while true do
			if (((8616 - 5795) <= (23886 - 19062)) and (v157 == (1780 - (389 + 1391)))) then
				if (((1091 + 647) <= (229 + 1966)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (4 - 2)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
					if (((992 - (783 + 168)) <= (10128 - 7110)) and v70) then
						v9.Cast(v84.BladeFlurry);
					elseif (((2110 + 35) <= (4415 - (309 + 2))) and v9.Cast(v84.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((8257 - 5568) < (6057 - (1090 + 122))) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (v9.Cast(v84.ColdBlood) or ((753 + 1569) > (8805 - 6183))) then
						return "Cast Cold Blood";
					end
				end
				v157 = 1 + 0;
			end
			if ((v157 == (1119 - (628 + 490))) or ((814 + 3720) == (5154 - 3072))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((7179 - 5608) > (2641 - (431 + 343)))) then
					if (v9.Cast(v84.BetweentheEyes) or ((5359 - 2705) >= (8667 - 5671))) then
						return "Cast Between the Eyes";
					end
				end
				if (((3143 + 835) > (270 + 1834)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (((4690 - (556 + 1139)) > (1556 - (6 + 9))) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v157 = 1 + 1;
			end
			if (((1665 + 1584) > (1122 - (28 + 141))) and (v157 == (1 + 1))) then
				if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (2 - 0)) and (v15:BuffStack(v84.Opportunity) >= (5 + 1)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1318 - (486 + 831)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) or ((8516 - 5243) > (16099 - 11526))) then
					if (v9.Press(v84.PistolShot) or ((596 + 2555) < (4059 - 2775))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((3113 - (668 + 595)) == (1376 + 153))) then
					if (((166 + 655) < (5789 - 3666)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v158 = 290 - (23 + 267);
		while true do
			if (((2846 - (1129 + 815)) < (2712 - (371 + 16))) and (v158 == (1751 - (1326 + 424)))) then
				if (((1624 - 766) <= (10823 - 7861)) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (118 - (88 + 30)))) and (v15:BuffRemains(v84.SliceandDice) < (((772 - (720 + 51)) + v97) * (2.8 - 1)))) then
					if (v9.Press(v84.SliceandDice) or ((5722 - (421 + 1355)) < (2124 - 836))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((1593 + 1649) == (1650 - (286 + 797)))) then
					if (v9.Cast(v84.KillingSpree) or ((3096 - 2249) >= (2091 - 828))) then
						return "Cast Killing Spree";
					end
				end
				v158 = 441 - (397 + 42);
			end
			if (((1 + 1) == v158) or ((3053 - (24 + 776)) == (2851 - 1000))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((2872 - (222 + 563)) > (5225 - 2853))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((3201 + 1244) < (4339 - (23 + 167)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((3616 - (690 + 1108)) == (31 + 54))) then
					if (((520 + 110) < (2975 - (40 + 808))) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v158 == (0 + 0)) or ((7410 - 5472) == (2403 + 111))) then
				if (((2251 + 2004) >= (31 + 24)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (575 - (47 + 524))) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(20 + 10, 10 - 6)) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (((4483 - 1484) > (2636 - 1480)) and v9.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((4076 - (1165 + 561)) > (35 + 1120)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (139 - 94)) and (v84.ShadowDance:CooldownRemains() > (5 + 7))) then
					if (((4508 - (341 + 138)) <= (1311 + 3542)) and v9.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v158 = 1 - 0;
			end
		end
	end
	local function v124()
		if ((v28 and v84.EchoingReprimand:IsReady()) or ((842 - (89 + 237)) > (11046 - 7612))) then
			if (((8517 - 4471) >= (3914 - (581 + 300))) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((3939 - (855 + 365)) <= (3436 - 1989))) then
			if (v9.Press(v84.Ambush) or ((1350 + 2784) < (5161 - (1030 + 205)))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((154 + 10) >= (2591 + 194))) then
			if (v9.Press(v84.PistolShot) or ((811 - (156 + 130)) == (4791 - 2682))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if (((55 - 22) == (67 - 34)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (2 + 4)) or (v15:BuffRemains(v84.Opportunity) < (2 + 0)))) then
			if (((3123 - (10 + 59)) <= (1136 + 2879)) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if (((9214 - 7343) < (4545 - (671 + 492))) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= (1 + 0 + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (1216 - (369 + 846)))))) or (v97 <= (1 + 0)))) then
			if (((1104 + 189) <= (4111 - (1036 + 909))) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if ((not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (1.5 + 0)) or (v98 <= ((1 - 0) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((2782 - (11 + 192)) < (63 + 60))) then
			if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((1021 - (135 + 40)) >= (5737 - 3369))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.SinisterStrike:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((2419 + 1593) <= (7397 - 4039))) then
			if (((2239 - 745) <= (3181 - (50 + 126))) and v9.Press(v84.SinisterStrike)) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		local v159 = 0 - 0;
		while true do
			if ((v159 == (1 + 2)) or ((4524 - (1233 + 180)) == (3103 - (522 + 447)))) then
				if (((3776 - (107 + 1314)) == (1093 + 1262)) and v27) then
					local v166 = 0 - 0;
					while true do
						if (((0 + 0) == v166) or ((1167 - 579) <= (1709 - 1277))) then
							v91 = v15:GetEnemiesInRange(1940 - (716 + 1194));
							v92 = v15:GetEnemiesInRange(v95);
							v166 = 1 + 0;
						end
						if (((514 + 4283) >= (4398 - (74 + 429))) and ((1 - 0) == v166)) then
							v93 = #v92;
							break;
						end
					end
				else
					v93 = 1 + 0;
				end
				v94 = v83.CrimsonVial();
				if (((8187 - 4610) == (2531 + 1046)) and v94) then
					return v94;
				end
				v83.Poisons();
				v159 = 12 - 8;
			end
			if (((9380 - 5586) > (4126 - (279 + 154))) and (v159 == (784 - (454 + 324)))) then
				if (v82.TargetIsValid() or ((1004 + 271) == (4117 - (12 + 5)))) then
					local v167 = 0 + 0;
					while true do
						if ((v167 == (0 - 0)) or ((588 + 1003) >= (4673 - (277 + 816)))) then
							v94 = v121();
							if (((4200 - 3217) <= (2991 - (1058 + 125))) and v94) then
								return "CDs: " .. v94;
							end
							if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((404 + 1746) <= (2172 - (815 + 160)))) then
								v94 = v122();
								if (((16171 - 12402) >= (2784 - 1611)) and v94) then
									return "Stealth: " .. v94;
								end
							end
							if (((355 + 1130) == (4340 - 2855)) and v114()) then
								v94 = v123();
								if (v94 or ((5213 - (41 + 1857)) <= (4675 - (1222 + 671)))) then
									return "Finish: " .. v94;
								end
							end
							v167 = 2 - 1;
						end
						if (((1 - 0) == v167) or ((2058 - (229 + 953)) >= (4738 - (1111 + 663)))) then
							v94 = v124();
							if (v94 or ((3811 - (874 + 705)) > (350 + 2147))) then
								return "Build: " .. v94;
							end
							if ((v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > (11 + 4 + v100))) or ((4385 - 2275) <= (10 + 322))) then
								if (((4365 - (642 + 37)) > (724 + 2448)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((716 + 3758) < (2058 - 1238))) then
								if (((4733 - (233 + 221)) >= (6664 - 3782)) and v9.Cast(v84.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							v167 = 2 + 0;
						end
						if ((v167 == (1543 - (718 + 823))) or ((1277 + 752) >= (4326 - (266 + 539)))) then
							if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(13 - 8)) or ((3262 - (636 + 589)) >= (11018 - 6376))) then
								if (((3547 - 1827) < (3533 + 925)) and v9.Cast(v84.LightsJudgment, v30)) then
									return "Cast Lights Judgment";
								end
							end
							if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(2 + 3)) or ((1451 - (657 + 358)) > (7998 - 4977))) then
								if (((1624 - 911) <= (2034 - (1151 + 36))) and v9.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if (((2081 + 73) <= (1060 + 2971)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (74 - 49)) and ((v98 >= (1833 - (1552 + 280))) or (v102 <= (835.2 - (64 + 770))))) then
								if (((3134 + 1481) == (10476 - 5861)) and v9.Cast(v84.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((673 + 3117) == (1743 - (157 + 1086)))) then
								if (((177 - 88) < (967 - 746)) and v9.Cast(v84.SinisterStrike)) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((3150 - 1096) >= (1939 - 518)) and ((821 - (599 + 220)) == v159)) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v159 = 5 - 2;
			end
			if (((2623 - (1813 + 118)) < (2236 + 822)) and (v159 == (1221 - (841 + 376)))) then
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((4559 - 1305) == (385 + 1270))) then
					local v168 = 0 - 0;
					while true do
						if ((v168 == (859 - (464 + 395))) or ((3326 - 2030) == (2358 + 2552))) then
							if (((4205 - (467 + 370)) == (6959 - 3591)) and (v33 == "Refreshing Healing Potion")) then
								if (((1941 + 702) < (13077 - 9262)) and v85.RefreshingHealingPotion:IsReady()) then
									if (((299 + 1614) > (1146 - 653)) and v9.Press(v86.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((5275 - (150 + 370)) > (4710 - (74 + 1208))) and (v33 == "Dreamwalker's Healing Potion")) then
								if (((3396 - 2015) <= (11235 - 8866)) and v85.DreamwalkersHealingPotion:IsReady()) then
									if (v9.Press(v86.RefreshingHealingPotion) or ((3447 + 1396) == (4474 - (14 + 376)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((8097 - 3428) > (235 + 128)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (v9.Cast(v84.Feint) or ((1649 + 228) >= (2993 + 145))) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((13894 - 9152) >= (2728 + 898)) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (v9.Cast(v84.Evasion) or ((4618 - (23 + 55)) == (2170 - 1254))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((772 + 384) > (3902 + 443))) then
					local v169 = 0 - 0;
					local v170;
					while true do
						if (((704 + 1533) < (5150 - (652 + 249))) and (v169 == (7 - 4))) then
							if (v170 or ((4551 - (708 + 1160)) < (62 - 39))) then
								return v170;
							end
							v170 = v82.InterruptWithStun(v84.KidneyShot, 14 - 6, v15:ComboPoints() > (27 - (10 + 17)));
							if (((157 + 540) <= (2558 - (1400 + 332))) and v170) then
								return v170;
							end
							break;
						end
						if (((2119 - 1014) <= (3084 - (242 + 1666))) and (v169 == (1 + 1))) then
							v170 = v82.Interrupt(v84.Blind, 6 + 9, v79, v12, v86.BlindMouseover);
							if (((2880 + 499) <= (4752 - (850 + 90))) and v170) then
								return v170;
							end
							v170 = v82.InterruptWithStun(v84.CheapShot, 13 - 5, v15:StealthUp(false, false));
							v169 = 1393 - (360 + 1030);
						end
						if ((v169 == (0 + 0)) or ((2223 - 1435) >= (2222 - 606))) then
							v170 = v82.Interrupt(v84.Kick, 1669 - (909 + 752), true);
							if (((3077 - (109 + 1114)) <= (6185 - 2806)) and v170) then
								return v170;
							end
							v170 = v82.Interrupt(v84.Kick, 4 + 4, true, v12, v86.KickMouseover);
							v169 = 243 - (6 + 236);
						end
						if (((2867 + 1682) == (3662 + 887)) and (v169 == (2 - 1))) then
							if (v170 or ((5278 - 2256) >= (4157 - (1076 + 57)))) then
								return v170;
							end
							v170 = v82.Interrupt(v84.Blind, 3 + 12, v79);
							if (((5509 - (579 + 110)) > (174 + 2024)) and v170) then
								return v170;
							end
							v169 = 2 + 0;
						end
					end
				end
				v159 = 3 + 2;
			end
			if ((v159 == (412 - (174 + 233))) or ((2963 - 1902) >= (8584 - 3693))) then
				if (((607 + 757) <= (5647 - (663 + 511))) and v29) then
					local v171 = 0 + 0;
					while true do
						if ((v171 == (0 + 0)) or ((11083 - 7488) <= (2 + 1))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 70 - 40, true);
							if (v94 or ((11309 - 6637) == (1839 + 2013))) then
								return v94;
							end
							break;
						end
					end
				end
				if (((3033 - 1474) == (1112 + 447)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					local v172 = 0 + 0;
					while true do
						if ((v172 == (722 - (478 + 244))) or ((2269 - (440 + 77)) <= (359 + 429))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (v94 or ((14299 - 10392) == (1733 - (655 + 901)))) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if (((644 + 2826) > (425 + 130)) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(32 - 24) and v26) then
					if ((v82.TargetIsValid() and v16:IsInRange(1455 - (695 + 750)) and not (v15:IsChanneling() or v15:IsCasting())) or ((3318 - 2346) == (994 - 349))) then
						if (((12797 - 9615) >= (2466 - (285 + 66))) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
							if (((9074 - 5181) < (5739 - (682 + 628))) and v11(v84.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v15:StealthUp(true, false) or ((463 + 2404) < (2204 - (176 + 123)))) then
							local v186 = 0 + 0;
							while true do
								if ((v186 == (0 + 0)) or ((2065 - (239 + 30)) >= (1102 + 2949))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (((1557 + 62) <= (6647 - 2891)) and v94) then
										return v94;
									end
									break;
								end
							end
						end
						if (((1884 - 1280) == (919 - (306 + 9))) and v82.TargetIsValid()) then
							if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v113())) or ((780 + 3704) == (553 + 347))) then
								if (v9.Cast(v84.RolltheBones) or ((2147 + 2312) <= (3182 - 2069))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if (((5007 - (1140 + 235)) > (2163 + 1235)) and v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))) then
								if (((1048 + 3034) <= (4969 - (33 + 19))) and v9.Cast(v84.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if (((1745 + 3087) >= (4154 - 2768)) and v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 - 0)))) then
								if (((129 + 8) == (826 - (586 + 103))) and v9.Press(v84.SliceandDice)) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (v15:StealthUp(true, false) or ((143 + 1427) >= (13336 - 9004))) then
								local v189 = 1488 - (1309 + 179);
								while true do
									if ((v189 == (0 - 0)) or ((1769 + 2295) <= (4884 - 3065))) then
										v94 = v122();
										if (v94 or ((3767 + 1219) < (3343 - 1769))) then
											return "Stealth (Opener): " .. v94;
										end
										v189 = 1 - 0;
									end
									if (((5035 - (295 + 314)) > (422 - 250)) and ((1963 - (1300 + 662)) == v189)) then
										if (((1839 - 1253) > (2210 - (1178 + 577))) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
											if (((429 + 397) == (2441 - 1615)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((5424 - (851 + 554)) > (3928 + 513))) then
											if (((5593 - 3576) < (9254 - 4993)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
												return "Cast Ambush (Opener)";
											end
										elseif (((5018 - (115 + 187)) > (62 + 18)) and v84.SinisterStrike:IsCastable()) then
											if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((3321 + 186) == (12893 - 9621))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
										break;
									end
								end
							elseif (v114() or ((2037 - (160 + 1001)) >= (2691 + 384))) then
								local v191 = 0 + 0;
								while true do
									if (((8908 - 4556) > (2912 - (237 + 121))) and (v191 == (897 - (525 + 372)))) then
										v94 = v123();
										if (v94 or ((8352 - 3946) < (13283 - 9240))) then
											return "Finish (Opener): " .. v94;
										end
										break;
									end
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((2031 - (96 + 46)) >= (4160 - (643 + 134)))) then
								if (((683 + 1209) <= (6555 - 3821)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
				if (((7139 - 5216) < (2128 + 90)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					v97 = v25(v97, v83.FanTheHammerCP());
				end
				v159 = 11 - 5;
			end
			if (((4441 - 2268) > (1098 - (316 + 403))) and (v159 == (1 + 0))) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(137 - 87)) or (0 + 0);
				v159 = 4 - 2;
			end
			if ((v159 == (0 + 0)) or ((836 + 1755) == (11811 - 8402))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v159 = 4 - 3;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(540 - 280, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

