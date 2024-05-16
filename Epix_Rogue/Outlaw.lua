local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5861 - (59 + 1096)) < (3035 + 664))) then
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
		local v127 = 0 + 0;
		while true do
			if (((3808 - (171 + 991)) >= (3609 - 2733)) and (v127 == (0 - 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v127 = 1 + 0;
			end
			if (((2152 - 1538) <= (9184 - 6000)) and (v127 == (9 - 3))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v78 = EpicSettings.Settings['sepsis'];
				v127 = 21 - 14;
			end
			if (((4374 - (111 + 1137)) == (3284 - (91 + 67))) and (v127 == (14 - 9))) then
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 2 + 4;
			end
			if (((527 - (423 + 100)) == v127) or ((16 + 2171) >= (13716 - 8762))) then
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v127 = 776 - (326 + 445);
			end
			if ((v127 == (8 - 6)) or ((8637 - 4760) == (8344 - 4769))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (711 - (530 + 181));
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 884 - (614 + 267);
			end
			if (((739 - (19 + 13)) > (1028 - 396)) and (v127 == (16 - 9))) then
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if ((v127 == (1 + 2)) or ((959 - 413) >= (5565 - 2881))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1812 - (1293 + 519));
				v127 = 7 - 3;
			end
			if (((3825 - 2360) <= (8224 - 3923)) and (v127 == (4 - 3))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v127 = 2 + 0;
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
	local v89 = (v88[3 + 10] and v19(v88[29 - 16])) or v19(0 + 0);
	local v90 = (v88[5 + 9] and v19(v88[9 + 5])) or v19(1096 - (709 + 387));
	v9:RegisterForEvent(function()
		local v128 = 1858 - (673 + 1185);
		while true do
			if (((4941 - 3237) > (4575 - 3150)) and ((0 - 0) == v128)) then
				v88 = v15:GetEquipment();
				v89 = (v88[10 + 3] and v19(v88[10 + 3])) or v19(0 - 0);
				v128 = 1 + 0;
			end
			if ((v128 == (1 - 0)) or ((1348 - 661) == (6114 - (446 + 1434)))) then
				v90 = (v88[1297 - (1040 + 243)] and v19(v88[41 - 27])) or v19(1847 - (559 + 1288));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 1937 - (609 + 1322);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 - 0);
	end}};
	local v105, v106 = 0 + 0, 0 - 0;
	local function v107(v129)
		local v130 = v15:EnergyTimeToMaxPredicted(nil, v129);
		if ((v130 < v105) or ((v130 - v105) > (0.5 + 0)) or ((1853 + 1477) < (1027 + 402))) then
			v105 = v130;
		end
		return v105;
	end
	local function v108()
		local v131 = v15:EnergyPredicted();
		if (((964 + 183) >= (328 + 7)) and ((v131 > v106) or ((v131 - v106) > (442 - (153 + 280))))) then
			v106 = v131;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		local v132 = 0 - 0;
		while true do
			if (((2124 + 1311) > (2764 - (89 + 578))) and ((0 + 0) == v132)) then
				if (not v10.APLVar.RtB_Buffs or ((7837 - 4067) >= (5090 - (572 + 477)))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Will_Lose = {};
					v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v10.APLVar.RtB_Buffs.Total = 0 + 0;
					v10.APLVar.RtB_Buffs.Normal = 0 + 0;
					v10.APLVar.RtB_Buffs.Shorter = 86 - (84 + 2);
					v10.APLVar.RtB_Buffs.Longer = 0 - 0;
					v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					local v179 = v83.RtBRemains();
					for v187 = 843 - (497 + 345), #v109 do
						local v188 = v15:BuffRemains(v109[v187]);
						if ((v188 > (0 + 0)) or ((641 + 3150) <= (2944 - (605 + 728)))) then
							local v194 = 0 + 0;
							local v195;
							while true do
								if ((v194 == (1 - 0)) or ((210 + 4368) <= (7424 - 5416))) then
									v195 = math.abs(v188 - v179);
									if (((1015 + 110) <= (5751 - 3675)) and (v195 <= (0.5 + 0))) then
										local v203 = 489 - (457 + 32);
										while true do
											if ((v203 == (0 + 0)) or ((2145 - (832 + 570)) >= (4145 + 254))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
												v10.APLVar.RtB_Buffs.Will_Lose[v109[v187]:Name()] = true;
												v203 = 3 - 2;
											end
											if (((557 + 598) < (2469 - (588 + 208))) and ((2 - 1) == v203)) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (1801 - (884 + 916));
												break;
											end
										end
									elseif ((v188 > v179) or ((4865 - 2541) <= (336 + 242))) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (654 - (232 + 421));
									else
										local v207 = 1889 - (1569 + 320);
										while true do
											if (((925 + 2842) == (716 + 3051)) and (v207 == (3 - 2))) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (606 - (316 + 289));
												break;
											end
											if (((10703 - 6614) == (189 + 3900)) and (v207 == (1453 - (666 + 787)))) then
												v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (426 - (360 + 65));
												v10.APLVar.RtB_Buffs.Will_Lose[v109[v187]:Name()] = true;
												v207 = 1 + 0;
											end
										end
									end
									break;
								end
								if (((4712 - (79 + 175)) >= (2638 - 964)) and (v194 == (0 + 0))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (2 - 1);
									if (((1871 - 899) <= (2317 - (503 + 396))) and (v188 > v10.APLVar.RtB_Buffs.MaxRemains)) then
										v10.APLVar.RtB_Buffs.MaxRemains = v188;
									end
									v194 = 182 - (92 + 89);
								end
							end
						end
						if (v110 or ((9579 - 4641) < (2443 + 2319))) then
							local v196 = 0 + 0;
							while true do
								if ((v196 == (0 - 0)) or ((343 + 2161) > (9721 - 5457))) then
									print("RtbRemains", v179);
									print(v109[v187]:Name(), v188);
									break;
								end
							end
						end
					end
					if (((1879 + 274) == (1029 + 1124)) and v110) then
						local v190 = 0 - 0;
						while true do
							if ((v190 == (0 + 0)) or ((772 - 265) >= (3835 - (485 + 759)))) then
								print("have: ", v10.APLVar.RtB_Buffs.Total);
								print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
								v190 = 2 - 1;
							end
							if (((5670 - (442 + 747)) == (5616 - (832 + 303))) and (v190 == (948 - (88 + 858)))) then
								print("longer: ", v10.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if ((v190 == (1 + 0)) or ((1927 + 401) < (29 + 664))) then
								print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v10.APLVar.RtB_Buffs.Normal);
								v190 = 791 - (766 + 23);
							end
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v112(v133)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v113()
		if (((21366 - 17038) == (5918 - 1590)) and not v10.APLVar.RtB_Reroll) then
			if (((4183 - 2595) >= (4520 - 3188)) and (v64 == "1+ Buff")) then
				v10.APLVar.RtB_Reroll = ((v111() <= (1073 - (1036 + 37))) and true) or false;
			elseif ((v64 == "Broadside") or ((2960 + 1214) > (8272 - 4024))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif ((v64 == "Buried Treasure") or ((3608 + 978) <= (1562 - (641 + 839)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif (((4776 - (910 + 3)) == (9847 - 5984)) and (v64 == "Grand Melee")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif ((v64 == "Skull and Crossbones") or ((1966 - (1466 + 218)) <= (20 + 22))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((5757 - (556 + 592)) >= (273 + 493)) and (v64 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((1960 - (329 + 479)) == (3342 - (174 + 680)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				local v212 = 0 - 0;
				while true do
					if (((7092 - 3670) > (2392 + 958)) and (v212 == (739 - (396 + 343)))) then
						v10.APLVar.RtB_Reroll = false;
						v111();
						v212 = 1 + 0;
					end
					if (((2354 - (29 + 1448)) > (1765 - (135 + 1254))) and ((3 - 2) == v212)) then
						if (((v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (9 - 7))) or ((2078 + 1040) <= (3378 - (389 + 1138)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v84.Crackshot:IsAvailable() and not v15:HasTier(605 - (102 + 472), 4 + 0) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0))) or ((154 + 11) >= (5037 - (320 + 1225)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v212 = 2 - 0;
					end
					if (((2417 + 1532) < (6320 - (157 + 1307))) and (v212 == (1861 - (821 + 1038)))) then
						if ((v84.Crackshot:IsAvailable() and v15:HasTier(77 - 46, 1 + 3) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((1 - 0) + v21(v15:BuffUp(v84.LoadedDiceBuff))))) or ((1591 + 2685) < (7475 - 4459))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((5716 - (834 + 192)) > (263 + 3862)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < (1 + 1 + v112(v84.GrandMelee))) and (v93 < (1 + 1))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v212 = 4 - 1;
					end
					if ((v212 == (307 - (300 + 4))) or ((14 + 36) >= (2345 - 1449))) then
						v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (362 - (112 + 250))) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (2 - 1)) and (v111() < (4 + 2)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (21 + 18)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
						if (v16:FilteredTimeToDie("<", 9 + 3) or v9.BossFilteredFightRemains("<", 6 + 6) or ((1274 + 440) >= (4372 - (1001 + 413)))) then
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
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((884 - (244 + 638)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (743 - (627 + 66)));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (5 - 3)) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 602 - (512 + 90);
		while true do
			if ((v134 == (1908 - (1665 + 241))) or ((2208 - (373 + 344)) < (291 + 353))) then
				if (((187 + 517) < (2603 - 1616)) and v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (50 - 20)) or ((v84.KeepItRolling:CooldownRemains() >= (1219 - (35 + 1064))) and (v114() or v84.HiddenOpportunity:IsAvailable())))) then
					if (((2706 + 1012) > (4077 - 2171)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				if ((v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) or ((4 + 954) > (4871 - (298 + 938)))) then
					if (((4760 - (233 + 1026)) <= (6158 - (636 + 1030))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
						if (v9.Cast(v84.Shadowmeld, v30) or ((1760 + 1682) < (2489 + 59))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((855 + 2020) >= (99 + 1365)) and (v134 == (221 - (55 + 166)))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (2 + 4))) and v115()) or ((483 + 4314) >= (18686 - 13793))) then
					if (v9.Cast(v84.Vanish, v67) or ((848 - (36 + 261)) > (3616 - 1548))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((3482 - (34 + 1334)) > (363 + 581)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (v9.Cast(v84.Vanish, v67) or ((1758 + 504) >= (4379 - (1035 + 248)))) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 22 - (20 + 1);
			end
			if ((v134 == (1 + 0)) or ((2574 - (134 + 185)) >= (4670 - (549 + 584)))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (691 - (314 + 371))) or not v67) and not v15:StealthUp(true, false)) or ((13172 - 9335) < (2274 - (478 + 490)))) then
					if (((1563 + 1387) == (4122 - (786 + 386))) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((15297 - 10574) < (4677 - (1055 + 324)))) then
					if (((2476 - (1093 + 247)) >= (137 + 17)) and v11(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 1 + 1;
			end
		end
	end
	local function v120()
		local v135 = 0 - 0;
		local v136;
		while true do
			if ((v135 == (0 - 0)) or ((771 - 500) > (11931 - 7183))) then
				v136 = v82.HandleTopTrinket(v87, v28, 15 + 25, nil);
				if (((18260 - 13520) >= (10864 - 7712)) and v136) then
					return v136;
				end
				v135 = 1 + 0;
			end
			if ((v135 == (2 - 1)) or ((3266 - (364 + 324)) >= (9293 - 5903))) then
				v136 = v82.HandleBottomTrinket(v87, v28, 95 - 55, nil);
				if (((14 + 27) <= (6950 - 5289)) and v136) then
					return v136;
				end
				break;
			end
		end
	end
	local function v121()
		local v137 = 0 - 0;
		local v138;
		local v139;
		while true do
			if (((1825 - 1224) < (4828 - (1249 + 19))) and (v137 == (3 + 0))) then
				if (((914 - 679) < (1773 - (686 + 400))) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
					local v180 = 0 + 0;
					while true do
						if (((4778 - (73 + 156)) > (6 + 1147)) and (v180 == (811 - (721 + 90)))) then
							v139 = v119();
							if (v139 or ((53 + 4621) < (15169 - 10497))) then
								return v139;
							end
							break;
						end
					end
				end
				if (((4138 - (224 + 246)) < (7388 - 2827)) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (184 - 84)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (2 + 4)))) then
					if (v9.Cast(v84.ThistleTea) or ((11 + 444) == (2648 + 957))) then
						return "Cast Thistle Tea";
					end
				end
				if ((v84.BladeRush:IsCastable() and (v102 > (7 - 3)) and not v15:StealthUp(true, true)) or ((8861 - 6198) == (3825 - (203 + 310)))) then
					if (((6270 - (1238 + 755)) <= (313 + 4162)) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				if (v84.BloodFury:IsCastable() or ((2404 - (709 + 825)) == (2190 - 1001))) then
					if (((2261 - 708) <= (3997 - (196 + 668))) and v9.Cast(v84.BloodFury, v30)) then
						return "Cast Blood Fury";
					end
				end
				v137 = 15 - 11;
			end
			if ((v137 == (0 - 0)) or ((3070 - (171 + 662)) >= (3604 - (4 + 89)))) then
				v138 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (v138 or ((4640 - 3316) > (1100 + 1920))) then
					return "DPS Pot";
				end
				if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (8 - 6))))) or ((1174 + 1818) == (3367 - (35 + 1451)))) then
					if (((4559 - (28 + 1425)) > (3519 - (941 + 1052))) and v11(v84.AdrenalineRush, v75)) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((2899 + 124) < (5384 - (822 + 692))) and v84.BladeFlurry:IsReady()) then
					if (((203 - 60) > (35 + 39)) and (v93 >= ((299 - (45 + 252)) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) then
						if (((18 + 0) < (727 + 1385)) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				v137 = 2 - 1;
			end
			if (((1530 - (114 + 319)) <= (2337 - 709)) and (v137 == (1 - 0))) then
				if (((2952 + 1678) == (6898 - 2268)) and v84.BladeFlurry:IsReady()) then
					if (((7417 - 3877) > (4646 - (556 + 1407))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1209 - (741 + 465))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (470 - (170 + 295))))) then
						if (((2526 + 2268) >= (3009 + 266)) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((3653 - 2169) == (1231 + 253)) and v84.RolltheBones:IsReady()) then
					if (((919 + 513) < (2014 + 1541)) and ((v113() and not v15:StealthUp(true, true)) or (v111() == (1230 - (957 + 273))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1 + 2)) and v15:HasTier(13 + 18, 15 - 11)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (18 - 11)) and ((v84.ShadowDance:CooldownRemains() <= (9 - 6)) or (v84.Vanish:CooldownRemains() <= (14 - 11))) and not v15:StealthUp(true, true)))) then
						if (v11(v84.RolltheBones) or ((2845 - (389 + 1391)) > (2245 + 1333))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v139 = v120();
				if (v139 or ((500 + 4295) < (3202 - 1795))) then
					return v139;
				end
				v137 = 953 - (783 + 168);
			end
			if (((6218 - 4365) < (4735 + 78)) and (v137 == (313 - (309 + 2)))) then
				if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((9 - 6) + v21(v15:HasTier(1243 - (1090 + 122), 2 + 2)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (19 - 13)))) or ((1931 + 890) < (3549 - (628 + 490)))) then
					if (v9.Cast(v84.KeepItRolling) or ((516 + 2358) < (5399 - 3218))) then
						return "Cast Keep it Rolling";
					end
				end
				if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (31 - 24))) or ((3463 - (431 + 343)) <= (692 - 349))) then
					if (v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((5406 - 3537) == (1588 + 421))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((454 + 3092) < (4017 - (556 + 1139)))) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 26 - (6 + 9)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 3 + 8) or ((1067 + 1015) == (4942 - (28 + 141)))) then
						if (((1257 + 1987) > (1302 - 247)) and v9.Cast(v84.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v84.BladeRush:IsReady() and (v102 > (3 + 1)) and not v15:StealthUp(true, true)) or ((4630 - (486 + 831)) <= (4626 - 2848))) then
					if (v9.Cast(v84.BladeRush) or ((5002 - 3581) >= (398 + 1706))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 9 - 6;
			end
			if (((3075 - (668 + 595)) <= (2924 + 325)) and (v137 == (1 + 3))) then
				if (((4425 - 2802) <= (2247 - (23 + 267))) and v84.Berserking:IsCastable()) then
					if (((6356 - (1129 + 815)) == (4799 - (371 + 16))) and v9.Cast(v84.Berserking, v30)) then
						return "Cast Berserking";
					end
				end
				if (((3500 - (1326 + 424)) >= (1594 - 752)) and v84.Fireblood:IsCastable()) then
					if (((15976 - 11604) > (1968 - (88 + 30))) and v9.Cast(v84.Fireblood, v30)) then
						return "Cast Fireblood";
					end
				end
				if (((1003 - (720 + 51)) < (1826 - 1005)) and v84.AncestralCall:IsCastable()) then
					if (((2294 - (421 + 1355)) < (1487 - 585)) and v9.Cast(v84.AncestralCall, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v140 = 0 + 0;
		while true do
			if (((4077 - (286 + 797)) > (3136 - 2278)) and (v140 == (1 - 0))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((4194 - (397 + 42)) <= (286 + 629))) then
					if (((4746 - (24 + 776)) > (5766 - 2023)) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((2120 - (222 + 563)) >= (7283 - 3977))) then
					if (((3488 + 1356) > (2443 - (23 + 167))) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v140 = 1800 - (690 + 1108);
			end
			if (((164 + 288) == (373 + 79)) and (v140 == (850 - (40 + 808)))) then
				if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1 + 1)) and (v15:BuffStack(v84.Opportunity) >= (22 - 16)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) or ((2411 + 2146) < (1145 + 942))) then
					if (((4445 - (47 + 524)) == (2515 + 1359)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((5297 - 3359) > (7379 - 2444))) then
					if (v11(v84.SinisterStrike, nil, not v16:IsSpellInRange(v84.Ambush)) or ((9704 - 5449) < (5149 - (1165 + 561)))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 1 + 2;
			end
			if (((4503 - 3049) <= (951 + 1540)) and (v140 == (479 - (341 + 138)))) then
				if (v84.BladeFlurry:IsReady() or ((1123 + 3034) <= (5784 - 2981))) then
					if (((5179 - (89 + 237)) >= (9592 - 6610)) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (6 - 3)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (886 - (581 + 300))))) then
						if (((5354 - (855 + 365)) > (7973 - 4616)) and v11(v84.BladeFlurry, v70)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((1116 + 2301) < (3769 - (1030 + 205)))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((2556 + 166) <= (153 + 11))) then
						return "Cast Cold Blood";
					end
				end
				v140 = 287 - (156 + 130);
			end
			if ((v140 == (6 - 3)) or ((4058 - 1650) < (4318 - 2209))) then
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((9 + 24) == (849 + 606))) then
					if (v9.Press(v84.Ambush) or ((512 - (10 + 59)) >= (1136 + 2879))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((16655 - 13273) > (1329 - (671 + 492))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (4 + 0)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(1245 - (369 + 846), 2 + 2)) and v15:BuffDown(v84.GreenskinsWickers)) then
			if (v9.Press(v84.BetweentheEyes) or ((239 + 41) == (5004 - (1036 + 909)))) then
				return "Cast Between the Eyes";
			end
		end
		if (((1496 + 385) > (2170 - 877)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (248 - (11 + 192))) and (v84.ShadowDance:CooldownRemains() > (7 + 5))) then
			if (((2532 - (135 + 40)) == (5710 - 3353)) and v9.Press(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((75 + 48) == (270 - 147)) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 - 0))) and (v15:BuffRemains(v84.SliceandDice) < (((177 - (50 + 126)) + v97) * (2.8 - 1)))) then
			if (v9.Press(v84.SliceandDice) or ((234 + 822) >= (4805 - (1233 + 180)))) then
				return "Cast Slice and Dice";
			end
		end
		if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((2050 - (522 + 447)) < (2496 - (107 + 1314)))) then
			if (v9.Cast(v84.KillingSpree) or ((487 + 562) >= (13504 - 9072))) then
				return "Cast Killing Spree";
			end
		end
		if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((2026 + 2742) <= (1679 - 833))) then
			if (v9.Cast(v84.ColdBlood, v55) or ((13286 - 9928) <= (3330 - (716 + 1194)))) then
				return "Cast Cold Blood";
			end
		end
		if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((64 + 3675) <= (322 + 2683))) then
			if (v9.Press(v84.Dispatch) or ((2162 - (74 + 429)) >= (4116 - 1982))) then
				return "Cast Dispatch";
			end
		end
	end
	local function v124()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (0 - 0)) or ((2307 + 953) < (7260 - 4905))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((1653 - 984) == (4656 - (279 + 154)))) then
					if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((2470 - (454 + 324)) < (463 + 125))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((4814 - (12 + 5)) < (1969 + 1682))) then
					if (v9.Press(v84.Ambush) or ((10643 - 6466) > (1793 + 3057))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v141 = 1094 - (277 + 816);
			end
			if (((4 - 3) == v141) or ((1583 - (1058 + 125)) > (209 + 902))) then
				if (((4026 - (815 + 160)) > (4312 - 3307)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
					if (((8766 - 5073) <= (1046 + 3336)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (17 - 11)) or (v15:BuffRemains(v84.Opportunity) < (1900 - (41 + 1857))))) or ((5175 - (1222 + 671)) > (10596 - 6496))) then
					if (v9.Press(v84.PistolShot) or ((5145 - 1565) < (4026 - (229 + 953)))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v141 = 1776 - (1111 + 663);
			end
			if (((1668 - (874 + 705)) < (629 + 3861)) and ((3 + 0) == v141)) then
				if ((v84.SinisterStrike:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((10357 - 5374) < (51 + 1757))) then
					if (((4508 - (642 + 37)) > (860 + 2909)) and v9.Press(v84.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((238 + 1247) <= (7290 - 4386)) and ((456 - (233 + 221)) == v141)) then
				if (((9871 - 5602) == (3758 + 511)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1542 - (718 + 823)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) then
					if (((1192 - (266 + 539)) <= (7876 - 5094)) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (1226.5 - (636 + 589))) or (v98 <= ((2 - 1) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((3916 - 2017) <= (727 + 190))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((1567 + 2745) <= (1891 - (657 + 358)))) then
						return "Cast Pistol Shot";
					end
				end
				v141 = 7 - 4;
			end
		end
	end
	local function v125()
		local v142 = 0 - 0;
		while true do
			if (((3419 - (1151 + 36)) <= (2507 + 89)) and (v142 == (2 + 2))) then
				if (((6256 - 4161) < (5518 - (1552 + 280))) and v32 and (v15:HealthPercentage() <= v34)) then
					if ((v33 == "Refreshing Healing Potion") or ((2429 - (64 + 770)) >= (3038 + 1436))) then
						if (v85.RefreshingHealingPotion:IsReady() or ((10485 - 5866) < (512 + 2370))) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((1537 - (157 + 1086)) >= (9669 - 4838))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((8886 - 6857) <= (4730 - 1646)) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((2780 - 743) == (3239 - (599 + 220)))) then
							if (((8877 - 4419) > (5835 - (1813 + 118))) and v9.Press(v86.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((319 + 117) >= (1340 - (841 + 376))) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (((700 - 200) < (422 + 1394)) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((9755 - 6181) == (4433 - (464 + 395))) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (((567 - 346) < (188 + 202)) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((3050 - (467 + 370)) <= (2936 - 1515))) then
					local v181 = 0 + 0;
					local v182;
					while true do
						if (((10482 - 7424) < (759 + 4101)) and (v181 == (2 - 1))) then
							v182 = v82.Interrupt(v84.Blind, 535 - (150 + 370), v79);
							if (v182 or ((2578 - (74 + 1208)) >= (10935 - 6489))) then
								return v182;
							end
							v182 = v82.Interrupt(v84.Blind, 71 - 56, v79, v12, v86.BlindMouseover);
							if (v182 or ((992 + 401) > (4879 - (14 + 376)))) then
								return v182;
							end
							v181 = 3 - 1;
						end
						if ((v181 == (2 + 0)) or ((3887 + 537) < (26 + 1))) then
							v182 = v82.InterruptWithStun(v84.CheapShot, 23 - 15, v15:StealthUp(false, false));
							if (v182 or ((1503 + 494) > (3893 - (23 + 55)))) then
								return v182;
							end
							v182 = v82.InterruptWithStun(v84.KidneyShot, 18 - 10, v15:ComboPoints() > (0 + 0));
							if (((3112 + 353) > (2965 - 1052)) and v182) then
								return v182;
							end
							break;
						end
						if (((231 + 502) < (2720 - (652 + 249))) and ((0 - 0) == v181)) then
							v182 = v82.Interrupt(v84.Kick, 1876 - (708 + 1160), true);
							if (v182 or ((11929 - 7534) == (8669 - 3914))) then
								return v182;
							end
							v182 = v82.Interrupt(v84.Kick, 35 - (10 + 17), true, v12, v86.KickMouseover);
							if (v182 or ((852 + 2941) < (4101 - (1400 + 332)))) then
								return v182;
							end
							v181 = 1 - 0;
						end
					end
				end
				v142 = 1913 - (242 + 1666);
			end
			if ((v142 == (0 + 0)) or ((1497 + 2587) == (226 + 39))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v142 = 941 - (850 + 90);
			end
			if (((7632 - 3274) == (5748 - (360 + 1030))) and (v142 == (6 + 0))) then
				if (v82.TargetIsValid() or ((8856 - 5718) < (1365 - 372))) then
					v94 = v121();
					if (((4991 - (909 + 752)) > (3546 - (109 + 1114))) and v94) then
						return "CDs: " .. v94;
					end
					if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((6638 - 3012) == (1553 + 2436))) then
						local v191 = 242 - (6 + 236);
						while true do
							if ((v191 == (0 + 0)) or ((738 + 178) == (6298 - 3627))) then
								v94 = v122();
								if (((474 - 202) == (1405 - (1076 + 57))) and v94) then
									return "Stealth: " .. v94;
								end
								break;
							end
						end
					end
					if (((699 + 3550) <= (5528 - (579 + 110))) and v114()) then
						local v192 = 0 + 0;
						while true do
							if (((2456 + 321) < (1699 + 1501)) and (v192 == (408 - (174 + 233)))) then
								v9.Cast(v84.PoolEnergy);
								return "Finish Pooling";
							end
							if (((265 - 170) < (3434 - 1477)) and (v192 == (0 + 0))) then
								v94 = v123();
								if (((2000 - (663 + 511)) < (1532 + 185)) and v94) then
									return "Finish: " .. v94;
								end
								v192 = 1 + 0;
							end
						end
					end
					v94 = v124();
					if (((4396 - 2970) >= (670 + 435)) and v94) then
						return "Build: " .. v94;
					end
					if (((6483 - 3729) <= (8179 - 4800)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > (8 + 7 + v100))) then
						if (v9.Cast(v84.ArcaneTorrent, v30) or ((7643 - 3716) == (1008 + 405))) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((106 + 1048) <= (1510 - (478 + 244)))) then
						if (v9.Cast(v84.ArcanePulse) or ((2160 - (440 + 77)) > (1537 + 1842))) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(18 - 13)) or ((4359 - (655 + 901)) > (844 + 3705))) then
						if (v9.Cast(v84.LightsJudgment, v30) or ((169 + 51) >= (2041 + 981))) then
							return "Cast Lights Judgment";
						end
					end
					if (((11368 - 8546) == (4267 - (695 + 750))) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(16 - 11)) then
						if (v9.Cast(v84.BagofTricks, v30) or ((1637 - 576) == (7468 - 5611))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((3111 - (285 + 66)) > (3179 - 1815)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (1335 - (682 + 628))) and ((v98 >= (1 + 0)) or (v102 <= (300.2 - (176 + 123))))) then
						if (v9.Cast(v84.PistolShot) or ((2051 + 2851) <= (2608 + 987))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (not v16:IsSpellInRange(v84.Dispatch) or ((4121 - (239 + 30)) == (80 + 213))) then
						if (v11(v84.PoolEnergy, false, "OOR") or ((1499 + 60) == (8120 - 3532))) then
							return "Pool Energy (OOR)";
						end
					elseif (v11(v84.PoolEnergy) or ((13989 - 9505) == (1103 - (306 + 9)))) then
						return "Pool Energy";
					end
				end
				break;
			end
			if (((15940 - 11372) >= (680 + 3227)) and (v142 == (2 + 0))) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v142 = 2 + 1;
			end
			if (((3562 - 2316) < (4845 - (1140 + 235))) and ((1 + 0) == v142)) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(46 + 4)) or (0 + 0);
				v142 = 54 - (33 + 19);
			end
			if (((1469 + 2599) >= (2913 - 1941)) and (v142 == (2 + 1))) then
				if (((966 - 473) < (3651 + 242)) and v27) then
					local v183 = 689 - (586 + 103);
					while true do
						if (((0 + 0) == v183) or ((4534 - 3061) >= (4820 - (1309 + 179)))) then
							v91 = v15:GetEnemiesInRange(54 - 24);
							v92 = v15:GetEnemiesInRange(v95);
							v183 = 1 + 0;
						end
						if ((v183 == (2 - 1)) or ((3060 + 991) <= (2457 - 1300))) then
							v93 = #v92;
							break;
						end
					end
				else
					v93 = 1 - 0;
				end
				v94 = v83.CrimsonVial();
				if (((1213 - (295 + 314)) < (7076 - 4195)) and v94) then
					return v94;
				end
				v83.Poisons();
				v142 = 1966 - (1300 + 662);
			end
			if ((v142 == (15 - 10)) or ((2655 - (1178 + 577)) == (1754 + 1623))) then
				if (((13181 - 8722) > (1996 - (851 + 554))) and v29) then
					local v184 = 0 + 0;
					while true do
						if (((9423 - 6025) >= (5201 - 2806)) and (v184 == (302 - (115 + 187)))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 23 + 7, true);
							if (v94 or ((2067 + 116) >= (11128 - 8304))) then
								return v94;
							end
							break;
						end
					end
				end
				if (((3097 - (160 + 1001)) == (1694 + 242)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					local v185 = 0 + 0;
					while true do
						if (((0 - 0) == v185) or ((5190 - (237 + 121)) < (5210 - (525 + 372)))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (((7750 - 3662) > (12728 - 8854)) and v94) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if (((4474 - (96 + 46)) == (5109 - (643 + 134))) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(19 - 11) and v26) then
					if (((14846 - 10847) >= (2782 + 118)) and v82.TargetIsValid() and v16:IsInRange(19 - 9) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v193 = 0 - 0;
						while true do
							if (((720 - (316 + 403)) == v193) or ((1679 + 846) > (11173 - 7109))) then
								if (((1580 + 2791) == (11007 - 6636)) and v82.TargetIsValid()) then
									local v201 = 0 + 0;
									while true do
										if ((v201 == (1 + 1)) or ((921 - 655) > (23812 - 18826))) then
											if (((4136 - 2145) >= (53 + 872)) and v84.SinisterStrike:IsCastable()) then
												if (((895 - 440) < (101 + 1952)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v201 == (0 - 0)) or ((843 - (12 + 5)) == (18841 - 13990))) then
											if (((389 - 206) == (388 - 205)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v113())) then
												if (((236 + 923) <= (3761 - (1656 + 317))) and v9.Cast(v84.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))) or ((2811 + 696) > (11481 - 7163))) then
												if (v9.Cast(v84.AdrenalineRush) or ((15133 - 12058) <= (3319 - (5 + 349)))) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v201 = 4 - 3;
										end
										if (((2636 - (266 + 1005)) <= (1326 + 685)) and (v201 == (3 - 2))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((1 - 0) + v97) * (1697.8 - (561 + 1135))))) or ((3616 - 840) > (11751 - 8176))) then
												if (v9.Press(v84.SliceandDice) or ((3620 - (507 + 559)) == (12054 - 7250))) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((7969 - 5392) == (2965 - (212 + 176))) and v15:StealthUp(true, false)) then
												local v213 = 905 - (250 + 655);
												while true do
													if ((v213 == (2 - 1)) or ((10 - 4) >= (2954 - 1065))) then
														if (((2462 - (1869 + 87)) <= (6562 - 4670)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
															if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((3909 - (484 + 1417)) > (4753 - 2535))) then
																return "Cast Ghostly Strike KiR (Opener)";
															end
														end
														if (((634 - 255) <= (4920 - (48 + 725))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
															if (v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush)) or ((7373 - 2859) <= (2706 - 1697))) then
																return "Cast Ambush (Opener)";
															end
														elseif (v84.SinisterStrike:IsCastable() or ((2032 + 1464) == (3185 - 1993))) then
															if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((59 + 149) == (863 + 2096))) then
																return "Cast Sinister Strike (Opener)";
															end
														end
														break;
													end
													if (((5130 - (152 + 701)) >= (2624 - (430 + 881))) and (v213 == (0 + 0))) then
														v94 = v122();
														if (((3482 - (557 + 338)) < (939 + 2235)) and v94) then
															return "Stealth (Opener): " .. v94;
														end
														v213 = 2 - 1;
													end
												end
											elseif (v114() or ((14427 - 10307) <= (5839 - 3641))) then
												local v219 = 0 - 0;
												while true do
													if ((v219 == (801 - (499 + 302))) or ((2462 - (39 + 827)) == (2368 - 1510))) then
														v94 = v123();
														if (((7191 - 3971) == (12789 - 9569)) and v94) then
															return "Finish (Opener): " .. v94;
														end
														break;
													end
												end
											end
											v201 = 2 - 0;
										end
									end
								end
								return;
							end
							if ((v193 == (0 + 0)) or ((4103 - 2701) > (580 + 3040))) then
								if (((4072 - 1498) == (2678 - (103 + 1))) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
									if (((2352 - (475 + 79)) < (5959 - 3202)) and v11(v84.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v15:StealthUp(true, false) or ((1206 - 829) > (337 + 2267))) then
									local v202 = 0 + 0;
									while true do
										if (((2071 - (1395 + 108)) < (2650 - 1739)) and (v202 == (1204 - (7 + 1197)))) then
											v94 = v83.Stealth(v83.StealthSpell());
											if (((1433 + 1852) < (1476 + 2752)) and v94) then
												return v94;
											end
											break;
										end
									end
								end
								v193 = 320 - (27 + 292);
							end
						end
					end
				end
				if (((11474 - 7558) > (4243 - 915)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					local v186 = 0 - 0;
					while true do
						if (((4930 - 2430) < (7310 - 3471)) and ((140 - (43 + 96)) == v186)) then
							v98 = v15:ComboPointsDeficit();
							break;
						end
						if (((2068 - 1561) == (1145 - 638)) and (v186 == (0 + 0))) then
							v97 = v25(v97, v83.FanTheHammerCP());
							v96 = v83.EffectiveComboPoints(v97);
							v186 = 1 + 0;
						end
					end
				end
				v142 = 11 - 5;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(100 + 160, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

