local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5968 - (990 + 465)) < (1382 + 1970))) then
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
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v37 = EpicSettings.Settings['InterruptWithStun'];
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v29 = EpicSettings.Settings['HandleIncorporeal'];
		v52 = EpicSettings.Settings['VanishOffGCD'];
		v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v55 = EpicSettings.Settings['ColdBloodOffGCD'];
		v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v57 = EpicSettings.Settings['CrimsonVialHP'] or (1726 - (1668 + 58));
		v58 = EpicSettings.Settings['FeintHP'] or (626 - (512 + 114));
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
	local v89 = (v88[26 - 13] and v19(v88[45 - 32])) or v19(0 + 0);
	local v90 = (v88[3 + 11] and v19(v88[13 + 1])) or v19(0 - 0);
	v9:RegisterForEvent(function()
		local v151 = 1994 - (109 + 1885);
		while true do
			if ((v151 == (1469 - (1269 + 200))) or ((3957 - 1892) >= (4011 - (98 + 717)))) then
				v88 = v15:GetEquipment();
				v89 = (v88[839 - (802 + 24)] and v19(v88[22 - 9])) or v19(0 - 0);
				v151 = 1 + 0;
			end
			if ((v151 == (1 + 0)) or ((719 + 3657) <= (320 + 1161))) then
				v90 = (v88[38 - 24] and v19(v88[46 - 32])) or v19(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 3 + 3;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 0 + 0, 326 - (192 + 134);
	local function v107(v152)
		local v153 = v15:EnergyTimeToMaxPredicted(nil, v152);
		if ((v153 < v105) or ((v153 - v105) > (1276.5 - (316 + 960))) or ((1888 + 1504) >= (3659 + 1082))) then
			v105 = v153;
		end
		return v105;
	end
	local function v108()
		local v154 = v15:EnergyPredicted();
		if (((3074 + 251) >= (8234 - 6080)) and ((v154 > v106) or ((v154 - v106) > (560 - (83 + 468))))) then
			v106 = v154;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		local v155 = 0 + 0;
		while true do
			if ((v155 == (0 + 0)) or ((717 + 578) >= (569 + 2664))) then
				if (((8104 - 3727) > (3553 - (340 + 1571))) and not v10.APLVar.RtB_Buffs) then
					local v169 = 0 + 0;
					local v170;
					while true do
						if (((6495 - (1733 + 39)) > (3726 - 2370)) and (v169 == (1035 - (125 + 909)))) then
							v10.APLVar.RtB_Buffs.Normal = 1948 - (1096 + 852);
							v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
							v10.APLVar.RtB_Buffs.Longer = 0 - 0;
							v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
							v169 = 514 - (409 + 103);
						end
						if ((v169 == (238 - (46 + 190))) or ((4231 - (51 + 44)) <= (969 + 2464))) then
							v170 = v83.RtBRemains();
							for v186 = 1318 - (1114 + 203), #v109 do
								local v187 = v15:BuffRemains(v109[v186]);
								if (((4971 - (228 + 498)) <= (1004 + 3627)) and (v187 > (0 + 0))) then
									local v190 = 663 - (174 + 489);
									local v191;
									while true do
										if (((11140 - 6864) >= (5819 - (830 + 1075))) and (v190 == (524 - (303 + 221)))) then
											v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1270 - (231 + 1038));
											if (((165 + 33) <= (5527 - (171 + 991))) and (v187 > v10.APLVar.RtB_Buffs.MaxRemains)) then
												v10.APLVar.RtB_Buffs.MaxRemains = v187;
											end
											v190 = 4 - 3;
										end
										if (((12840 - 8058) > (11668 - 6992)) and (v190 == (1 + 0))) then
											v191 = math.abs(v187 - v170);
											if (((17049 - 12185) > (6337 - 4140)) and (v191 <= (0.5 - 0))) then
												local v199 = 0 - 0;
												while true do
													if ((v199 == (1248 - (111 + 1137))) or ((3858 - (91 + 67)) == (7461 - 4954))) then
														v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
														v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
														v199 = 524 - (423 + 100);
													end
													if (((32 + 4442) >= (758 - 484)) and (v199 == (1 + 0))) then
														v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (772 - (326 + 445));
														break;
													end
												end
											elseif ((v187 > v170) or ((8265 - 6371) <= (3131 - 1725))) then
												v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (2 - 1);
											else
												local v203 = 711 - (530 + 181);
												while true do
													if (((2453 - (614 + 267)) >= (1563 - (19 + 13))) and ((1 - 0) == v203)) then
														v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
														break;
													end
													if ((v203 == (0 - 0)) or ((1218 + 3469) < (7987 - 3445))) then
														v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1 - 0);
														v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
														v203 = 1813 - (1293 + 519);
													end
												end
											end
											break;
										end
									end
								end
								if (((6714 - 3423) > (4352 - 2685)) and v110) then
									local v192 = 0 - 0;
									while true do
										if ((v192 == (0 - 0)) or ((2056 - 1183) == (1078 + 956))) then
											print("RtbRemains", v170);
											print(v109[v186]:Name(), v187);
											break;
										end
									end
								end
							end
							if (v110 or ((575 + 2241) < (25 - 14))) then
								local v189 = 0 + 0;
								while true do
									if (((1229 + 2470) < (2941 + 1765)) and (v189 == (1098 - (709 + 387)))) then
										print("longer: ", v10.APLVar.RtB_Buffs.Longer);
										print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
										break;
									end
									if (((4504 - (673 + 1185)) >= (2540 - 1664)) and (v189 == (0 - 0))) then
										print("have: ", v10.APLVar.RtB_Buffs.Total);
										print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
										v189 = 1 - 0;
									end
									if (((440 + 174) <= (2380 + 804)) and ((1 - 0) == v189)) then
										print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
										print("normal: ", v10.APLVar.RtB_Buffs.Normal);
										v189 = 1 + 1;
									end
								end
							end
							break;
						end
						if (((6232 - 3106) == (6135 - 3009)) and (v169 == (1880 - (446 + 1434)))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Will_Lose = {};
							v10.APLVar.RtB_Buffs.Will_Lose.Total = 1283 - (1040 + 243);
							v10.APLVar.RtB_Buffs.Total = 0 - 0;
							v169 = 1848 - (559 + 1288);
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
		local v157 = 1931 - (609 + 1322);
		while true do
			if ((v157 == (454 - (13 + 441))) or ((8172 - 5985) >= (12976 - 8022))) then
				if (not v10.APLVar.RtB_Reroll or ((19309 - 15432) == (134 + 3441))) then
					if (((2567 - 1860) > (225 + 407)) and (v64 == "1+ Buff")) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
					elseif ((v64 == "Broadside") or ((1620 - 1074) >= (1469 + 1215))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif (((2694 - 1229) <= (2844 + 1457)) and (v64 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((948 + 756) > (1024 + 401)) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif ((v64 == "Skull and Crossbones") or ((577 + 110) == (4143 + 91))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif ((v64 == "Ruthless Precision") or ((3763 - (153 + 280)) < (4126 - 2697))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif (((1030 + 117) >= (133 + 202)) and (v64 == "True Bearing")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v111();
						if (((1798 + 1637) > (1903 + 194)) and (v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (2 + 0))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v84.Crackshot:IsAvailable() and not v15:HasTier(46 - 15, 3 + 1) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (668 - (89 + 578)))) or ((2694 + 1076) >= (8400 - 4359))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v84.Crackshot:IsAvailable() and v15:HasTier(1080 - (572 + 477), 1 + 3) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff))))) or ((453 + 3338) <= (1697 - (84 + 2)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((2 - 0) + v112(v84.GrandMelee))) and (v93 < (2 + 0))) or ((5420 - (497 + 345)) <= (52 + 1956))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v10.APLVar.RtB_Buffs.Normal == (1333 - (605 + 728))) and (v10.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v111() < (13 - 7)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (2 + 37)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
						if (((4159 - 3034) <= (1872 + 204)) and (v16:FilteredTimeToDie("<", 32 - 20) or v9.BossFilteredFightRemains("<", 10 + 2))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (490 - (457 + 32))) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= (1 + 1 + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (1452 - (832 + 570)));
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
		local v158 = 0 + 0;
		while true do
			if ((v158 == (6 - 4)) or ((358 + 385) >= (5195 - (588 + 208)))) then
				if (((3112 - 1957) < (3473 - (884 + 916))) and v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (62 - 32)) or ((v84.KeepItRolling:CooldownRemains() >= (70 + 50)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
						return "Cast Shadow Dance";
					end
				end
				if (((925 + 2842) == (716 + 3051)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
					if (((13778 - 9689) == (4694 - (316 + 289))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
						if (((11669 - 7211) >= (78 + 1596)) and v9.Cast(v84.Shadowmeld, v30)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((2425 - (666 + 787)) <= (1843 - (360 + 65))) and (v158 == (1 + 0))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (260 - (79 + 175))) or not v67) and not v15:StealthUp(true, false)) or ((7785 - 2847) < (3716 + 1046))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((7675 - 5171) > (8211 - 3947))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((3052 - (503 + 396)) == (2334 - (92 + 89))) and v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) then
					if (v11(v84.ShadowDance, v53) or ((983 - 476) >= (1329 + 1262))) then
						return "Cast Shadow Dance";
					end
				end
				v158 = 2 + 0;
			end
			if (((17548 - 13067) == (613 + 3868)) and (v158 == (0 - 0))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (6 + 0))) and v115()) or ((1112 + 1216) < (2110 - 1417))) then
					if (((541 + 3787) == (6600 - 2272)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((2832 - (485 + 759)) >= (3081 - 1749)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (v9.Cast(v84.Vanish, v67) or ((5363 - (442 + 747)) > (5383 - (832 + 303)))) then
						return "Cast Vanish (Finish)";
					end
				end
				v158 = 947 - (88 + 858);
			end
		end
	end
	local function v120()
		local v159 = 0 + 0;
		local v160;
		while true do
			if ((v159 == (1 + 0)) or ((189 + 4397) <= (871 - (766 + 23)))) then
				v160 = v82.HandleBottomTrinket(v87, v28, 197 - 157, nil);
				if (((5282 - 1419) == (10177 - 6314)) and v160) then
					return v160;
				end
				break;
			end
			if ((v159 == (0 - 0)) or ((1355 - (1036 + 37)) <= (30 + 12))) then
				v160 = v82.HandleTopTrinket(v87, v28, 77 - 37, nil);
				if (((3626 + 983) >= (2246 - (641 + 839))) and v160) then
					return v160;
				end
				v159 = 914 - (910 + 3);
			end
		end
	end
	local function v121()
		local v161 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (v161 or ((2936 - 1784) == (4172 - (1466 + 218)))) then
			return "DPS Pot";
		end
		if (((1573 + 1849) > (4498 - (556 + 592))) and v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))))) then
			if (((1685 - (329 + 479)) > (1230 - (174 + 680))) and v11(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (v84.BladeFlurry:IsReady() or ((10713 - 7595) <= (3836 - 1985))) then
			if (((v93 >= ((2 + 0) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((904 - (396 + 343)) >= (309 + 3183))) then
				if (((5426 - (29 + 1448)) < (6245 - (135 + 1254))) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.BladeFlurry:IsReady() or ((16108 - 11832) < (14082 - 11066))) then
			if (((3126 + 1564) > (5652 - (389 + 1138))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (577 - (102 + 472))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (5 + 0)))) then
				if (v11(v84.BladeFlurry) or ((28 + 22) >= (836 + 60))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.RolltheBones:IsReady() or ((3259 - (320 + 1225)) >= (5265 - 2307))) then
			if ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1467 - (157 + 1307))) and v15:HasTier(1890 - (821 + 1038), 9 - 5)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1 + 6)) and ((v84.ShadowDance:CooldownRemains() <= (4 - 1)) or (v84.Vanish:CooldownRemains() <= (2 + 1))) and not v15:StealthUp(true, true)) or ((3695 - 2204) < (1670 - (834 + 192)))) then
				if (((45 + 659) < (254 + 733)) and v11(v84.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v162 = v120();
		if (((80 + 3638) > (2952 - 1046)) and v162) then
			return v162;
		end
		if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((307 - (300 + 4)) + v21(v15:HasTier(9 + 22, 10 - 6)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (368 - (112 + 250))))) or ((382 + 576) > (9106 - 5471))) then
			if (((2006 + 1495) <= (2324 + 2168)) and v9.Cast(v84.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (6 + 1))) or ((1707 + 1735) < (1893 + 655))) then
			if (((4289 - (1001 + 413)) >= (3264 - 1800)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((5679 - (244 + 638)) >= (5586 - (627 + 66)))) then
			if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 32 - 21) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 613 - (512 + 90)) or ((2457 - (1665 + 241)) > (2785 - (373 + 344)))) then
				if (((954 + 1160) > (250 + 694)) and v9.Cast(v84.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v84.BladeRush:IsReady() and (v102 > (10 - 6)) and not v15:StealthUp(true, true)) or ((3827 - 1565) >= (4195 - (35 + 1064)))) then
			if (v9.Cast(v84.BladeRush) or ((1641 + 614) >= (7567 - 4030))) then
				return "Cast Blade Rush";
			end
		end
		if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((16 + 3821) < (2542 - (298 + 938)))) then
			v162 = v119();
			if (((4209 - (233 + 1026)) == (4616 - (636 + 1030))) and v162) then
				return v162;
			end
		end
		if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (52 + 48)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (6 + 0)))) or ((1404 + 3319) < (223 + 3075))) then
			if (((1357 - (55 + 166)) >= (30 + 124)) and v9.Cast(v84.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if ((v84.BladeRush:IsCastable() and (v102 > (1 + 3)) and not v15:StealthUp(true, true)) or ((1034 - 763) > (5045 - (36 + 261)))) then
			if (((8289 - 3549) >= (4520 - (34 + 1334))) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((992 + 1586) >= (2634 + 756))) then
			if (((1324 - (1035 + 248)) <= (1682 - (20 + 1))) and v9.Cast(v84.BloodFury, v30)) then
				return "Cast Blood Fury";
			end
		end
		if (((314 + 287) < (3879 - (134 + 185))) and v84.Berserking:IsCastable()) then
			if (((1368 - (549 + 584)) < (1372 - (314 + 371))) and v9.Cast(v84.Berserking, v30)) then
				return "Cast Berserking";
			end
		end
		if (((15616 - 11067) > (2121 - (478 + 490))) and v84.Fireblood:IsCastable()) then
			if (v9.Cast(v84.Fireblood, v30) or ((2476 + 2198) < (5844 - (786 + 386)))) then
				return "Cast Fireblood";
			end
		end
		if (((11880 - 8212) < (5940 - (1055 + 324))) and v84.AncestralCall:IsCastable()) then
			if (v9.Cast(v84.AncestralCall, v30) or ((1795 - (1093 + 247)) == (3204 + 401))) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		if (v84.BladeFlurry:IsReady() or ((281 + 2382) == (13149 - 9837))) then
			if (((14515 - 10238) <= (12733 - 8258)) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (7 - 4)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (2 + 3)))) then
				if (v11(v84.BladeFlurry, v70) or ((3351 - 2481) == (4098 - 2909))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((1172 + 381) <= (8011 - 4878)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
			if (v9.Cast(v84.ColdBlood, v55) or ((2925 - (364 + 324)) >= (9624 - 6113))) then
				return "Cast Cold Blood";
			end
		end
		if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((3177 - 1853) > (1001 + 2019))) then
			if (v9.Cast(v84.BetweentheEyes) or ((12519 - 9527) == (3012 - 1131))) then
				return "Cast Between the Eyes";
			end
		end
		if (((9433 - 6327) > (2794 - (1249 + 19))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
			if (((2729 + 294) < (15064 - 11194)) and v9.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((1229 - (686 + 400)) > (59 + 15)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (231 - (73 + 156))) and (v15:BuffStack(v84.Opportunity) >= (1 + 5)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (812 - (721 + 90)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
			if (((1 + 17) < (6857 - 4745)) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((1567 - (224 + 246)) <= (2636 - 1008)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
			if (((8524 - 3894) == (840 + 3790)) and v11(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush))) then
				return "Cast Ambush (SS High-Prio Buffed)";
			end
		end
		if (((85 + 3455) > (1971 + 712)) and v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
			if (((9530 - 4736) >= (10898 - 7623)) and v9.Press(v84.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		local v163 = 513 - (203 + 310);
		while true do
			if (((3477 - (1238 + 755)) == (104 + 1380)) and (v163 == (1536 - (709 + 825)))) then
				if (((2638 - 1206) < (5178 - 1623)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) then
					if (v9.Cast(v84.ColdBlood, v55) or ((1929 - (196 + 668)) > (14126 - 10548))) then
						return "Cast Cold Blood";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((9932 - 5137) < (2240 - (171 + 662)))) then
					if (((1946 - (4 + 89)) < (16869 - 12056)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v163 == (0 + 0)) or ((12390 - 9569) < (954 + 1477))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (1490 - (35 + 1451))) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(1483 - (28 + 1425), 1997 - (941 + 1052))) and v15:BuffDown(v84.GreenskinsWickers)) or ((2756 + 118) < (3695 - (822 + 692)))) then
					if (v9.Press(v84.BetweentheEyes) or ((3838 - 1149) <= (162 + 181))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (342 - (45 + 252))) and (v84.ShadowDance:CooldownRemains() > (12 + 0))) or ((644 + 1225) == (4889 - 2880))) then
					if (v9.Press(v84.BetweentheEyes) or ((3979 - (114 + 319)) < (3333 - 1011))) then
						return "Cast Between the Eyes";
					end
				end
				v163 = 1 - 0;
			end
			if ((v163 == (1 + 0)) or ((3101 - 1019) == (10000 - 5227))) then
				if (((5207 - (556 + 1407)) > (2261 - (741 + 465))) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (465 - (170 + 295)))) and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 + 0)))) then
					if (v9.Press(v84.SliceandDice) or ((8156 - 4843) <= (1474 + 304))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((912 + 509) >= (1192 + 912))) then
					if (((3042 - (957 + 273)) <= (869 + 2380)) and v9.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v163 = 1 + 1;
			end
		end
	end
	local function v124()
		local v164 = 0 - 0;
		while true do
			if (((4276 - 2653) <= (5977 - 4020)) and (v164 == (4 - 3))) then
				if (((6192 - (389 + 1391)) == (2769 + 1643)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
					if (((183 + 1567) >= (1916 - 1074)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((5323 - (783 + 168)) > (6208 - 4358)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (6 + 0)) or (v15:BuffRemains(v84.Opportunity) < (313 - (309 + 2))))) then
					if (((712 - 480) < (2033 - (1090 + 122))) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v164 = 1 + 1;
			end
			if (((1739 - 1221) < (618 + 284)) and (v164 == (1118 - (628 + 490)))) then
				if (((537 + 2457) > (2124 - 1266)) and v28 and v84.EchoingReprimand:IsReady()) then
					if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((17160 - 13405) <= (1689 - (431 + 343)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((7969 - 4023) > (10828 - 7085)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v9.Press(v84.Ambush) or ((1055 + 280) >= (423 + 2883))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v164 = 1696 - (556 + 1139);
			end
			if (((4859 - (6 + 9)) > (413 + 1840)) and (v164 == (2 + 1))) then
				if (((621 - (28 + 141)) == (176 + 276)) and v84.SinisterStrike:IsCastable()) then
					if (v9.Press(v84.SinisterStrike) or ((5624 - 1067) < (1479 + 608))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((5191 - (486 + 831)) == (10081 - 6207)) and (v164 == (6 - 4))) then
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= (1 + 0 + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (3 - 2))))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) or ((3201 - (668 + 595)) > (4441 + 494))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((858 + 3397) < (9334 - 5911))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((1744 - (23 + 267)) <= (4435 - (1129 + 815))) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (388.5 - (371 + 16))) or (v98 <= ((1751 - (1326 + 424)) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((7873 - 3716) <= (10242 - 7439))) then
						return "Cast Pistol Shot";
					end
				end
				v164 = 121 - (88 + 30);
			end
		end
	end
	local function v125()
		local v165 = 771 - (720 + 51);
		while true do
			if (((10795 - 5942) >= (4758 - (421 + 1355))) and ((9 - 3) == v165)) then
				if (((2031 + 2103) > (4440 - (286 + 797))) and v82.TargetIsValid()) then
					v94 = v121();
					if (v94 or ((12491 - 9074) < (4197 - 1663))) then
						return "CDs: " .. v94;
					end
					if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((3161 - (397 + 42)) <= (52 + 112))) then
						v94 = v122();
						if (v94 or ((3208 - (24 + 776)) < (3248 - 1139))) then
							return "Stealth: " .. v94;
						end
					end
					if (v114() or ((818 - (222 + 563)) == (3205 - 1750))) then
						local v176 = 0 + 0;
						while true do
							if ((v176 == (191 - (23 + 167))) or ((2241 - (690 + 1108)) >= (1449 + 2566))) then
								return "Finish Pooling";
							end
							if (((2790 + 592) > (1014 - (40 + 808))) and (v176 == (0 + 0))) then
								v94 = v123();
								if (v94 or ((1070 - 790) == (2924 + 135))) then
									return "Finish: " .. v94;
								end
								v176 = 1 + 0;
							end
						end
					end
					v94 = v124();
					if (((1032 + 849) > (1864 - (47 + 524))) and v94) then
						return "Build: " .. v94;
					end
					if (((1530 + 827) == (6442 - 4085)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((22 - 7) + v100))) then
						if (((280 - 157) == (1849 - (1165 + 561))) and v9.Cast(v84.ArcaneTorrent, v30)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((32 + 1024) >= (10505 - 7113))) then
						if (v9.Cast(v84.ArcanePulse) or ((413 + 668) < (1554 - (341 + 138)))) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(2 + 3)) or ((2164 - 1115) >= (4758 - (89 + 237)))) then
						if (v9.Cast(v84.LightsJudgment, v30) or ((15338 - 10570) <= (1780 - 934))) then
							return "Cast Lights Judgment";
						end
					end
					if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(886 - (581 + 300))) or ((4578 - (855 + 365)) <= (3372 - 1952))) then
						if (v9.Cast(v84.BagofTricks, v30) or ((1221 + 2518) <= (4240 - (1030 + 205)))) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (24 + 1)) and ((v98 >= (1 + 0)) or (v102 <= (287.2 - (156 + 130))))) or ((3769 - 2110) >= (3596 - 1462))) then
						if (v9.Cast(v84.PistolShot) or ((6676 - 3416) < (621 + 1734))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (not v16:IsSpellInRange(v84.Dispatch) or ((391 + 278) == (4292 - (10 + 59)))) then
						if (v11(v84.PoolEnergy, false, "OOR") or ((479 + 1213) < (2895 - 2307))) then
							return "Pool Energy (OOR)";
						end
					elseif (v11(v84.PoolEnergy) or ((5960 - (671 + 492)) < (2907 + 744))) then
						return "Pool Energy";
					end
				end
				break;
			end
			if ((v165 == (1216 - (369 + 846))) or ((1106 + 3071) > (4139 + 711))) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(1995 - (1036 + 909))) or (0 + 0);
				v165 = 2 - 0;
			end
			if ((v165 == (208 - (11 + 192))) or ((203 + 197) > (1286 - (135 + 40)))) then
				if (((7392 - 4341) > (606 + 399)) and v29) then
					local v171 = 0 - 0;
					while true do
						if (((5536 - 1843) <= (4558 - (50 + 126))) and (v171 == (0 - 0))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 7 + 23, true);
							if (v94 or ((4695 - (1233 + 180)) > (5069 - (522 + 447)))) then
								return v94;
							end
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and not v15:IsMounted() and v59) or ((5001 - (107 + 1314)) < (1320 + 1524))) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (((270 - 181) < (1908 + 2582)) and v94) then
						return "Stealth (OOC): " .. v94;
					end
				end
				if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(31 - 23) and v26) or ((6893 - (716 + 1194)) < (31 + 1777))) then
					if (((411 + 3418) > (4272 - (74 + 429))) and v82.TargetIsValid() and v16:IsInRange(19 - 9) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v177 = 0 + 0;
						while true do
							if (((3399 - 1914) <= (2055 + 849)) and ((0 - 0) == v177)) then
								if (((10555 - 6286) == (4702 - (279 + 154))) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
									if (((1165 - (454 + 324)) <= (2189 + 593)) and v11(v84.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v15:StealthUp(true, false) or ((1916 - (12 + 5)) <= (495 + 422))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (v94 or ((10986 - 6674) <= (324 + 552))) then
										return v94;
									end
								end
								v177 = 1094 - (277 + 816);
							end
							if (((9537 - 7305) <= (3779 - (1058 + 125))) and ((1 + 0) == v177)) then
								if (((3070 - (815 + 160)) < (15815 - 12129)) and v82.TargetIsValid()) then
									local v194 = 0 - 0;
									while true do
										if (((1 + 0) == v194) or ((4662 - 3067) >= (6372 - (41 + 1857)))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((1894 - (1222 + 671)) + v97) * (2.8 - 1)))) or ((6638 - 2019) < (4064 - (229 + 953)))) then
												if (v9.Press(v84.SliceandDice) or ((2068 - (1111 + 663)) >= (6410 - (874 + 705)))) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((285 + 1744) <= (2105 + 979)) and v15:StealthUp(true, false)) then
												local v201 = 0 - 0;
												while true do
													if ((v201 == (1 + 0)) or ((2716 - (642 + 37)) == (552 + 1868))) then
														if (((714 + 3744) > (9801 - 5897)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
															if (((890 - (233 + 221)) >= (284 - 161)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
																return "Cast Ghostly Strike KiR (Opener)";
															end
														end
														if (((441 + 59) < (3357 - (718 + 823))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
															if (((2249 + 1325) == (4379 - (266 + 539))) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
																return "Cast Ambush (Opener)";
															end
														elseif (((625 - 404) < (1615 - (636 + 589))) and v84.SinisterStrike:IsCastable()) then
															if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((5252 - 3039) <= (2930 - 1509))) then
																return "Cast Sinister Strike (Opener)";
															end
														end
														break;
													end
													if (((2424 + 634) < (1766 + 3094)) and (v201 == (1015 - (657 + 358)))) then
														v94 = v122();
														if (v94 or ((3431 - 2135) >= (10129 - 5683))) then
															return "Stealth (Opener): " .. v94;
														end
														v201 = 1188 - (1151 + 36);
													end
												end
											elseif (v114() or ((1346 + 47) > (1181 + 3308))) then
												v94 = v123();
												if (v94 or ((13211 - 8787) < (1859 - (1552 + 280)))) then
													return "Finish (Opener): " .. v94;
												end
											end
											v194 = 836 - (64 + 770);
										end
										if ((v194 == (0 + 0)) or ((4532 - 2535) > (678 + 3137))) then
											if (((4708 - (157 + 1086)) > (3828 - 1915)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v113())) then
												if (((1123 - 390) < (2482 - 663)) and v9.Cast(v84.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (821 - (599 + 220)))) or ((8751 - 4356) == (6686 - (1813 + 118)))) then
												if (v9.Cast(v84.AdrenalineRush) or ((2773 + 1020) < (3586 - (841 + 376)))) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v194 = 1 - 0;
										end
										if ((v194 == (1 + 1)) or ((11147 - 7063) == (1124 - (464 + 395)))) then
											if (((11184 - 6826) == (2093 + 2265)) and v84.SinisterStrike:IsCastable()) then
												if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((3975 - (467 + 370)) < (2051 - 1058))) then
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
					end
				end
				if (((2445 + 885) > (7963 - 5640)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					local v172 = 0 + 0;
					while true do
						if ((v172 == (0 - 0)) or ((4146 - (150 + 370)) == (5271 - (74 + 1208)))) then
							v97 = v25(v97, v83.FanTheHammerCP());
							v96 = v83.EffectiveComboPoints(v97);
							v172 = 2 - 1;
						end
						if ((v172 == (4 - 3)) or ((652 + 264) == (3061 - (14 + 376)))) then
							v98 = v15:ComboPointsDeficit();
							break;
						end
					end
				end
				v165 = 10 - 4;
			end
			if (((177 + 95) == (239 + 33)) and ((2 + 0) == v165)) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v165 = 8 - 5;
			end
			if (((3197 + 1052) <= (4917 - (23 + 55))) and (v165 == (9 - 5))) then
				if (((1854 + 923) < (2874 + 326)) and v32 and (v15:HealthPercentage() <= v34)) then
					if (((147 - 52) < (616 + 1341)) and (v33 == "Refreshing Healing Potion")) then
						if (((1727 - (652 + 249)) < (4594 - 2877)) and v85.RefreshingHealingPotion:IsReady()) then
							if (((3294 - (708 + 1160)) >= (2999 - 1894)) and v9.Press(v86.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((5020 - 2266) <= (3406 - (10 + 17))) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((883 + 3044) == (3145 - (1400 + 332)))) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((2213 - 1059) <= (2696 - (242 + 1666)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if ((v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) or ((704 + 939) > (1239 + 2140))) then
					if (v9.Cast(v84.Feint) or ((2389 + 414) > (5489 - (850 + 90)))) then
						return "Cast Feint (Defensives)";
					end
				end
				if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) or ((385 - 165) >= (4412 - (360 + 1030)))) then
					if (((2498 + 324) == (7964 - 5142)) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((1459 - 398) == (3518 - (909 + 752)))) then
					local v173 = 1223 - (109 + 1114);
					local v174;
					while true do
						if (((5053 - 2293) > (531 + 833)) and (v173 == (243 - (6 + 236)))) then
							if (v174 or ((3089 + 1813) <= (2894 + 701))) then
								return v174;
							end
							v174 = v82.Interrupt(v84.Blind, 35 - 20, v79);
							if (v174 or ((6728 - 2876) == (1426 - (1076 + 57)))) then
								return v174;
							end
							v173 = 1 + 1;
						end
						if ((v173 == (692 - (579 + 110))) or ((124 + 1435) == (4057 + 531))) then
							if (v174 or ((2380 + 2104) == (1195 - (174 + 233)))) then
								return v174;
							end
							v174 = v82.InterruptWithStun(v84.KidneyShot, 22 - 14, v15:ComboPoints() > (0 - 0));
							if (((2032 + 2536) >= (5081 - (663 + 511))) and v174) then
								return v174;
							end
							break;
						end
						if (((1112 + 134) < (754 + 2716)) and (v173 == (0 - 0))) then
							v174 = v82.Interrupt(v84.Kick, 5 + 3, true);
							if (((9577 - 5509) >= (2352 - 1380)) and v174) then
								return v174;
							end
							v174 = v82.Interrupt(v84.Kick, 4 + 4, true, v12, v86.KickMouseover);
							v173 = 1 - 0;
						end
						if (((352 + 141) < (356 + 3537)) and (v173 == (724 - (478 + 244)))) then
							v174 = v82.Interrupt(v84.Blind, 532 - (440 + 77), v79, v12, v86.BlindMouseover);
							if (v174 or ((670 + 803) >= (12195 - 8863))) then
								return v174;
							end
							v174 = v82.InterruptWithStun(v84.CheapShot, 1564 - (655 + 901), v15:StealthUp(false, false));
							v173 = 1 + 2;
						end
					end
				end
				v165 = 4 + 1;
			end
			if (((3 + 0) == v165) or ((16319 - 12268) <= (2602 - (695 + 750)))) then
				if (((2062 - 1458) < (4445 - 1564)) and v27) then
					v91 = v15:GetEnemiesInRange(120 - 90);
					v92 = v15:GetEnemiesInRange(v95);
					v93 = #v92;
				else
					v93 = 352 - (285 + 66);
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((2097 - 1197) == (4687 - (682 + 628)))) then
					return v94;
				end
				v83.Poisons();
				v165 = 1 + 3;
			end
			if (((4758 - (176 + 123)) > (248 + 343)) and (v165 == (0 + 0))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v165 = 270 - (239 + 30);
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(71 + 189, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

