local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 42 - (19 + 23);
	local v7;
	while true do
		if (((9934 - 5421) >= (10502 - 7776)) and (v6 == (1428 - (1233 + 195)))) then
			v7 = v1[v5];
			if (not v7 or ((4938 - 3457) >= (951 + 1707))) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
		if ((v6 == (1 + 0)) or ((2342 + 878) == (637 + 727))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Rogue_Outlaw.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Cast;
	local v14 = v11.Mouseover;
	local v15 = v11.Utils;
	local v16 = v11.Unit;
	local v17 = v16.Player;
	local v18 = v16.Target;
	local v19 = v11.Spell;
	local v20 = v11.MultiSpell;
	local v21 = v11.Item;
	local v22 = v11.Macro;
	local v23 = v11.Commons.Everyone.num;
	local v24 = v11.Commons.Everyone.bool;
	local v25 = math.min;
	local v26 = math.abs;
	local v27 = math.max;
	local v28 = false;
	local v29 = false;
	local v30 = false;
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
	local v82;
	local function v83()
		local v129 = 1433 - (797 + 636);
		while true do
			if ((v129 == (33 - 26)) or ((2673 - (1427 + 192)) > (1176 + 2216))) then
				v73 = EpicSettings.Settings['BladeRushGCD'];
				v74 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v76 = EpicSettings.Settings['KeepItRollingGCD'];
				v129 = 18 - 10;
			end
			if ((v129 == (5 + 0)) or ((307 + 369) >= (1968 - (192 + 134)))) then
				v59 = EpicSettings.Settings['CrimsonVialHP'] or (1276 - (316 + 960));
				v60 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v61 = EpicSettings.Settings['StealthOOC'];
				v129 = 5 + 1;
			end
			if (((3823 + 313) > (9163 - 6766)) and (v129 == (552 - (83 + 468)))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (1806 - (1202 + 604));
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v129 = 2 - 0;
			end
			if ((v129 == (10 - 6)) or ((4659 - (45 + 280)) == (4098 + 147))) then
				v56 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v57 = EpicSettings.Settings['ColdBloodOffGCD'];
				v58 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v129 = 5 + 0;
			end
			if (((3 + 5) == v129) or ((2367 + 1909) <= (534 + 2497))) then
				v77 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v78 = EpicSettings.Settings['EchoingReprimand'];
				v79 = EpicSettings.Settings['UseSoloVanish'];
				v129 = 16 - 7;
			end
			if ((v129 == (1914 - (340 + 1571))) or ((1887 + 2895) <= (2971 - (1733 + 39)))) then
				v31 = EpicSettings.Settings['HandleIncorporeal'];
				v54 = EpicSettings.Settings['VanishOffGCD'];
				v55 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v129 = 10 - 6;
			end
			if ((v129 == (1036 - (125 + 909))) or ((6812 - (1096 + 852)) < (854 + 1048))) then
				v39 = EpicSettings.Settings['InterruptWithStun'];
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v129 = 3 + 0;
			end
			if (((5351 - (409 + 103)) >= (3936 - (46 + 190))) and (v129 == (104 - (51 + 44)))) then
				v80 = EpicSettings.Settings['sepsis'];
				v81 = EpicSettings.Settings['BlindInterrupt'];
				v82 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if ((v129 == (1317 - (1114 + 203))) or ((1801 - (228 + 498)) > (416 + 1502))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'];
				v129 = 1 + 0;
			end
			if (((1059 - (174 + 489)) <= (9910 - 6106)) and ((1911 - (830 + 1075)) == v129)) then
				v66 = EpicSettings.Settings['RolltheBonesLogic'];
				v69 = EpicSettings.Settings['UseDPSVanish'];
				v72 = EpicSettings.Settings['BladeFlurryGCD'];
				v129 = 531 - (303 + 221);
			end
		end
	end
	local v84 = v11.Commons.Everyone;
	local v85 = v11.Commons.Rogue;
	local v86 = v19.Rogue.Outlaw;
	local v87 = v21.Rogue.Outlaw;
	local v88 = v22.Rogue.Outlaw;
	local v89 = {};
	local v90 = v17:GetEquipment();
	local v91 = (v90[1282 - (231 + 1038)] and v21(v90[11 + 2])) or v21(1162 - (171 + 991));
	local v92 = (v90[57 - 43] and v21(v90[37 - 23])) or v21(0 - 0);
	v11:RegisterForEvent(function()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 - 0)) or ((12026 - 7857) == (3524 - 1337))) then
				v90 = v17:GetEquipment();
				v91 = (v90[39 - 26] and v21(v90[1261 - (111 + 1137)])) or v21(158 - (91 + 67));
				v130 = 2 - 1;
			end
			if (((351 + 1055) == (1929 - (423 + 100))) and (v130 == (1 + 0))) then
				v92 = (v90[38 - 24] and v21(v90[8 + 6])) or v21(771 - (326 + 445));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v93, v94, v95;
	local v96;
	local v97 = 26 - 20;
	local v98, v99, v100;
	local v101, v102, v103, v104, v105;
	local v106 = {{v86.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v86.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v99 > (0 + 0);
	end}};
	local v107, v108 = 0 - 0, 0 - 0;
	local function v109(v131)
		local v132 = v17:EnergyTimeToMaxPredicted(nil, v131);
		if (((3343 - (1293 + 519)) < (8713 - 4442)) and ((v132 < v107) or ((v132 - v107) > (0.5 - 0)))) then
			v107 = v132;
		end
		return v107;
	end
	local function v110()
		local v133 = v17:EnergyPredicted();
		if (((1214 - 579) == (2738 - 2103)) and ((v133 > v108) or ((v133 - v108) > (20 - 11)))) then
			v108 = v133;
		end
		return v108;
	end
	local v111 = {v86.Broadside,v86.BuriedTreasure,v86.GrandMelee,v86.RuthlessPrecision,v86.SkullandCrossbones,v86.TrueBearing};
	local v112 = false;
	local function v113()
		if (((4469 - (709 + 387)) <= (5414 - (673 + 1185))) and not v12.APLVar.RtB_Buffs) then
			local v146 = 0 - 0;
			local v147;
			while true do
				if ((v146 == (3 - 2)) or ((5414 - 2123) < (2347 + 933))) then
					v12.APLVar.RtB_Buffs.Total = 0 + 0;
					v12.APLVar.RtB_Buffs.Normal = 0 - 0;
					v12.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v146 = 3 - 1;
				end
				if (((8609 - 4223) >= (2753 - (446 + 1434))) and ((1283 - (1040 + 243)) == v146)) then
					v12.APLVar.RtB_Buffs = {};
					v12.APLVar.RtB_Buffs.Will_Lose = {};
					v12.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
					v146 = 1848 - (559 + 1288);
				end
				if (((2852 - (609 + 1322)) <= (1556 - (13 + 441))) and (v146 == (7 - 5))) then
					v12.APLVar.RtB_Buffs.Longer = 0 - 0;
					v12.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
					v147 = v85.RtBRemains();
					v146 = 1 + 2;
				end
				if (((17091 - 12385) >= (343 + 620)) and (v146 == (2 + 1))) then
					for v186 = 2 - 1, #v111 do
						local v187 = 0 + 0;
						local v188;
						while true do
							if ((v187 == (1 - 0)) or ((635 + 325) <= (488 + 388))) then
								if (v112 or ((1485 + 581) == (783 + 149))) then
									print("RtbRemains", v147);
									print(v111[v186]:Name(), v188);
								end
								break;
							end
							if (((4721 + 104) < (5276 - (153 + 280))) and (v187 == (0 - 0))) then
								v188 = v17:BuffRemains(v111[v186]);
								if ((v188 > (0 + 0)) or ((1531 + 2346) >= (2375 + 2162))) then
									local v195 = 0 + 0;
									local v196;
									while true do
										if ((v195 == (1 + 0)) or ((6570 - 2255) < (1067 + 659))) then
											v196 = math.abs(v188 - v147);
											if ((v196 <= (667.5 - (89 + 578))) or ((2629 + 1050) < (1299 - 674))) then
												v12.APLVar.RtB_Buffs.Normal = v12.APLVar.RtB_Buffs.Normal + (1050 - (572 + 477));
												v12.APLVar.RtB_Buffs.Will_Lose[v111[v186]:Name()] = true;
												v12.APLVar.RtB_Buffs.Will_Lose.Total = v12.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
											elseif ((v188 > v147) or ((2776 + 1849) < (76 + 556))) then
												v12.APLVar.RtB_Buffs.Longer = v12.APLVar.RtB_Buffs.Longer + (87 - (84 + 2));
											else
												v12.APLVar.RtB_Buffs.Shorter = v12.APLVar.RtB_Buffs.Shorter + (1 - 0);
												v12.APLVar.RtB_Buffs.Will_Lose[v111[v186]:Name()] = true;
												v12.APLVar.RtB_Buffs.Will_Lose.Total = v12.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
											end
											break;
										end
										if ((v195 == (842 - (497 + 345))) or ((3 + 80) > (301 + 1479))) then
											v12.APLVar.RtB_Buffs.Total = v12.APLVar.RtB_Buffs.Total + (1334 - (605 + 728));
											if (((390 + 156) <= (2393 - 1316)) and (v188 > v12.APLVar.RtB_Buffs.MaxRemains)) then
												v12.APLVar.RtB_Buffs.MaxRemains = v188;
											end
											v195 = 1 + 0;
										end
									end
								end
								v187 = 3 - 2;
							end
						end
					end
					if (v112 or ((898 + 98) > (11916 - 7615))) then
						print("have: ", v12.APLVar.RtB_Buffs.Total);
						print("will lose: ", v12.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v12.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v12.APLVar.RtB_Buffs.Normal);
						print("longer: ", v12.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v12.APLVar.RtB_Buffs.MaxRemains);
					end
					break;
				end
			end
		end
		return v12.APLVar.RtB_Buffs.Total;
	end
	local function v114(v134)
		return (v12.APLVar.RtB_Buffs.Will_Lose and v12.APLVar.RtB_Buffs.Will_Lose[v134] and true) or false;
	end
	local function v115()
		local v135 = 0 + 0;
		while true do
			if (((4559 - (457 + 32)) > (292 + 395)) and (v135 == (1402 - (832 + 570)))) then
				if (not v12.APLVar.RtB_Reroll or ((619 + 37) >= (869 + 2461))) then
					if ((v66 == "1+ Buff") or ((8818 - 6326) <= (162 + 173))) then
						v12.APLVar.RtB_Reroll = ((v113() <= (796 - (588 + 208))) and true) or false;
					elseif (((11648 - 7326) >= (4362 - (884 + 916))) and (v66 == "Broadside")) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.Broadside) and true) or false;
					elseif ((v66 == "Buried Treasure") or ((7613 - 3976) >= (2186 + 1584))) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.BuriedTreasure) and true) or false;
					elseif ((v66 == "Grand Melee") or ((3032 - (232 + 421)) > (6467 - (1569 + 320)))) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.GrandMelee) and true) or false;
					elseif ((v66 == "Skull and Crossbones") or ((119 + 364) > (142 + 601))) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.SkullandCrossbones) and true) or false;
					elseif (((8269 - 5815) > (1183 - (316 + 289))) and (v66 == "Ruthless Precision")) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.RuthlessPrecision) and true) or false;
					elseif (((2434 - 1504) < (206 + 4252)) and (v66 == "True Bearing")) then
						v12.APLVar.RtB_Reroll = (not v17:BuffUp(v86.TrueBearing) and true) or false;
					else
						v12.APLVar.RtB_Reroll = false;
						v113();
						v12.APLVar.RtB_Reroll = v113() <= (v23(v114(v86.BuriedTreasure)) + v23(v114(v86.GrandMelee) and (v95 < (1455 - (666 + 787)))));
						if (((1087 - (360 + 65)) <= (909 + 63)) and v86.Crackshot:IsAvailable() and not v17:HasTier(285 - (79 + 175), 5 - 1)) then
							v12.APLVar.RtB_Reroll = (not v114(v86.TrueBearing) and v86.HiddenOpportunity:IsAvailable()) or (not v114(v86.Broadside) and not v86.HiddenOpportunity:IsAvailable() and (v12.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
						end
						if (((13395 - 9025) == (8416 - 4046)) and v86.Crackshot:IsAvailable() and v17:HasTier(930 - (503 + 396), 185 - (92 + 89))) then
							v12.APLVar.RtB_Reroll = v12.APLVar.RtB_Buffs.Will_Lose.Total <= ((1 - 0) + v23(v17:BuffUp(v86.LoadedDiceBuff)));
						end
						if ((not v86.Crackshot:IsAvailable() and v86.HiddenOpportunity:IsAvailable() and not v114(v86.SkullandCrossbones) and (v12.APLVar.RtB_Buffs.Will_Lose.Total < (2 + 0 + v23(v114(v86.GrandMelee)))) and (v95 < (2 + 0))) or ((18648 - 13886) <= (118 + 743))) then
							v12.APLVar.RtB_Reroll = true;
						end
						v12.APLVar.RtB_Reroll = v12.APLVar.RtB_Reroll and ((v12.APLVar.RtB_Buffs.Longer == (0 - 0)) or ((v12.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v12.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v113() < (17 - 11)) and (v12.APLVar.RtB_Buffs.MaxRemains <= (5 + 34)) and not v17:StealthUp(true, true) and v17:BuffUp(v86.LoadedDiceBuff)));
						if (v18:FilteredTimeToDie("<", 17 - 5) or v11.BossFilteredFightRemains("<", 1256 - (485 + 759)) or ((3267 - 1855) == (5453 - (442 + 747)))) then
							v12.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v12.APLVar.RtB_Reroll;
			end
		end
	end
	local function v116()
		return v98 >= ((v85.CPMaxSpend() - (1136 - (832 + 303))) - v23((v17:StealthUp(true, true)) and v86.Crackshot:IsAvailable()));
	end
	local function v117()
		return (v86.HiddenOpportunity:IsAvailable() or (v100 >= ((948 - (88 + 858)) + v23(v86.ImprovedAmbush:IsAvailable()) + v23(v17:BuffUp(v86.Broadside))))) and (v101 >= (16 + 34));
	end
	local function v118()
		return v69 and (not v17:IsTanking(v18) or v79);
	end
	local function v119()
		return not v86.ShadowDanceTalent:IsAvailable() and ((v86.FanTheHammer:TalentRank() + v23(v86.QuickDraw:IsAvailable()) + v23(v86.Audacity:IsAvailable())) < (v23(v86.CountTheOdds:IsAvailable()) + v23(v86.KeepItRolling:IsAvailable())));
	end
	local function v120()
		return v17:BuffUp(v86.BetweentheEyes) and (not v86.HiddenOpportunity:IsAvailable() or (v17:BuffDown(v86.AudacityBuff) and ((v86.FanTheHammer:TalentRank() < (2 + 0)) or v17:BuffDown(v86.Opportunity)))) and not v86.Crackshot:IsAvailable();
	end
	local function v121()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (790 - (766 + 23))) or ((15639 - 12471) < (2943 - 790))) then
				if ((v86.ShadowDance:IsReady() and v86.Crackshot:IsAvailable() and v116() and ((v86.Vanish:CooldownRemains() >= (15 - 9)) or not v69) and not v17:StealthUp(true, false)) or ((16888 - 11912) < (2405 - (1036 + 37)))) then
					if (((3282 + 1346) == (9012 - 4384)) and v11.Cast(v86.ShadowDance, v55)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v86.ShadowDance:IsReady() and not v86.KeepItRolling:IsAvailable() and v120() and v17:BuffUp(v86.SliceandDice) and (v116() or v86.HiddenOpportunity:IsAvailable()) and (not v86.HiddenOpportunity:IsAvailable() or not v86.Vanish:IsReady() or not v69)) or ((43 + 11) == (1875 - (641 + 839)))) then
					if (((995 - (910 + 3)) == (208 - 126)) and v13(v86.ShadowDance, v55)) then
						return "Cast Shadow Dance";
					end
				end
				v136 = 1686 - (1466 + 218);
			end
			if ((v136 == (1 + 1)) or ((1729 - (556 + 592)) < (101 + 181))) then
				if ((v86.ShadowDance:IsReady() and v86.KeepItRolling:IsAvailable() and v120() and ((v86.KeepItRolling:CooldownRemains() <= (838 - (329 + 479))) or ((v86.KeepItRolling:CooldownRemains() >= (974 - (174 + 680))) and (v116() or v86.HiddenOpportunity:IsAvailable())))) or ((15837 - 11228) < (5171 - 2676))) then
					if (((823 + 329) == (1891 - (396 + 343))) and v11.Cast(v86.ShadowDance, v55)) then
						return "Cast Shadow Dance";
					end
				end
				if (((168 + 1728) <= (4899 - (29 + 1448))) and v86.Shadowmeld:IsAvailable() and v86.Shadowmeld:IsReady() and v32) then
					if ((v86.Crackshot:IsAvailable() and v116()) or (not v86.Crackshot:IsAvailable() and ((v86.CountTheOdds:IsAvailable() and v116()) or v86.HiddenOpportunity:IsAvailable())) or ((2379 - (135 + 1254)) > (6102 - 4482))) then
						if (v11.Cast(v86.Shadowmeld, v32) or ((4094 - 3217) > (3129 + 1566))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((4218 - (389 + 1138)) >= (2425 - (102 + 472))) and (v136 == (0 + 0))) then
				if ((v86.Vanish:IsReady() and v118() and v86.HiddenOpportunity:IsAvailable() and not v86.Crackshot:IsAvailable() and not v17:BuffUp(v86.Audacity) and (v119() or (v17:BuffStack(v86.Opportunity) < (4 + 2))) and v117()) or ((2784 + 201) >= (6401 - (320 + 1225)))) then
					if (((7611 - 3335) >= (732 + 463)) and v11.Cast(v86.Vanish, v69)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((4696 - (157 + 1307)) <= (6549 - (821 + 1038))) and v86.Vanish:IsReady() and v118() and (not v86.HiddenOpportunity:IsAvailable() or v86.Crackshot:IsAvailable()) and v116()) then
					if (v11.Cast(v86.Vanish, v69) or ((2235 - 1339) >= (345 + 2801))) then
						return "Cast Vanish (Finish)";
					end
				end
				v136 = 1 - 0;
			end
		end
	end
	local function v122()
		local v137 = v84.HandleTopTrinket(v89, v30, 15 + 25, nil);
		if (((7586 - 4525) >= (3984 - (834 + 192))) and v137) then
			return v137;
		end
		local v137 = v84.HandleBottomTrinket(v89, v30, 3 + 37, nil);
		if (((819 + 2368) >= (14 + 630)) and v137) then
			return v137;
		end
	end
	local function v123()
		local v138 = v84.HandleDPSPotion(v17:BuffUp(v86.AdrenalineRush));
		if (((997 - 353) <= (1008 - (300 + 4))) and v138) then
			return "DPS Pot";
		end
		if (((256 + 702) > (2478 - 1531)) and v30 and v86.AdrenalineRush:IsCastable() and ((not v17:BuffUp(v86.AdrenalineRush) and (not v116() or not v86.ImprovedAdrenalineRush:IsAvailable())) or (v17:StealthUp(true, true) and v86.Crackshot:IsAvailable() and v86.ImprovedAdrenalineRush:IsAvailable() and (v99 <= (364 - (112 + 250)))))) then
			if (((1791 + 2701) >= (6648 - 3994)) and v13(v86.AdrenalineRush, v77)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((1972 + 1470) >= (778 + 725)) and v86.BladeFlurry:IsReady()) then
			if (((v95 >= ((2 + 0) - v23(v86.UnderhandedUpperhand:IsAvailable() and not v17:StealthUp(true, true) and v17:BuffUp(v86.AdrenalineRush)))) and (v17:BuffRemains(v86.BladeFlurry) < (2 + 1))) or ((2355 + 815) <= (2878 - (1001 + 413)))) then
				if (v13(v86.BladeFlurry) or ((10697 - 5900) == (5270 - (244 + 638)))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((1244 - (627 + 66)) <= (2029 - 1348)) and v86.BladeFlurry:IsReady()) then
			if (((3879 - (512 + 90)) > (2313 - (1665 + 241))) and v86.DeftManeuvers:IsAvailable() and not v116() and (((v95 >= (720 - (373 + 344))) and (v100 == (v95 + v23(v17:BuffUp(v86.Broadside))))) or (v95 >= (3 + 2)))) then
				if (((1243 + 3452) >= (3732 - 2317)) and v13(v86.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v86.RolltheBones:IsReady() or ((5435 - 2223) <= (2043 - (35 + 1064)))) then
			if (v115() or (v113() == (0 + 0)) or ((v12.APLVar.RtB_Buffs.MaxRemains <= (6 - 3)) and v17:HasTier(1 + 30, 1240 - (298 + 938))) or ((v12.APLVar.RtB_Buffs.MaxRemains <= (1266 - (233 + 1026))) and ((v86.ShadowDance:CooldownRemains() <= (1669 - (636 + 1030))) or (v86.Vanish:CooldownRemains() <= (2 + 1)))) or ((3025 + 71) <= (535 + 1263))) then
				if (((239 + 3298) == (3758 - (55 + 166))) and v13(v86.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v139 = v122();
		if (((744 + 3093) >= (158 + 1412)) and v139) then
			return v139;
		end
		if ((v86.KeepItRolling:IsReady() and not v115() and (v113() >= ((11 - 8) + v23(v17:HasTier(328 - (36 + 261), 6 - 2)))) and (v17:BuffDown(v86.ShadowDance) or (v113() >= (1374 - (34 + 1334))))) or ((1135 + 1815) == (2962 + 850))) then
			if (((6006 - (1035 + 248)) >= (2339 - (20 + 1))) and v11.Cast(v86.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v86.GhostlyStrike:IsAvailable() and v86.GhostlyStrike:IsReady() and (v98 < (4 + 3))) or ((2346 - (134 + 185)) > (3985 - (549 + 584)))) then
			if (v13(v86.GhostlyStrike, v74, nil, not v18:IsSpellInRange(v86.GhostlyStrike)) or ((1821 - (314 + 371)) > (14820 - 10503))) then
				return "Cast Ghostly Strike";
			end
		end
		if (((5716 - (478 + 490)) == (2516 + 2232)) and v30 and v86.Sepsis:IsAvailable() and v86.Sepsis:IsReady()) then
			if (((4908 - (786 + 386)) <= (15352 - 10612)) and ((v86.Crackshot:IsAvailable() and v86.BetweentheEyes:IsReady() and v116() and not v17:StealthUp(true, true)) or (not v86.Crackshot:IsAvailable() and v18:FilteredTimeToDie(">", 1390 - (1055 + 324)) and v17:BuffUp(v86.BetweentheEyes)) or v11.BossFilteredFightRemains("<", 1351 - (1093 + 247)))) then
				if (v11.Cast(v86.Sepsis) or ((3013 + 377) <= (322 + 2738))) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v86.BladeRush:IsReady() and (v104 > (15 - 11)) and not v17:StealthUp(true, true)) or ((3390 - 2391) > (7662 - 4969))) then
			if (((1163 - 700) < (214 + 387)) and v11.Cast(v86.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if ((not v17:StealthUp(true, true) and (not v86.Crackshot:IsAvailable() or v86.BetweentheEyes:IsReady())) or ((8409 - 6226) < (2367 - 1680))) then
			v139 = v121();
			if (((3431 + 1118) == (11633 - 7084)) and v139) then
				return v139;
			end
		end
		if (((5360 - (364 + 324)) == (12807 - 8135)) and v30 and v86.ThistleTea:IsAvailable() and v86.ThistleTea:IsCastable() and not v17:BuffUp(v86.ThistleTea) and ((v103 >= (239 - 139)) or v11.BossFilteredFightRemains("<", v86.ThistleTea:Charges() * (2 + 4)))) then
			if (v11.Cast(v86.ThistleTea) or ((15348 - 11680) < (632 - 237))) then
				return "Cast Thistle Tea";
			end
		end
		if ((v86.BladeRush:IsCastable() and (v104 > (11 - 7)) and not v17:StealthUp(true, true)) or ((5434 - (1249 + 19)) == (411 + 44))) then
			if (v13(v86.BladeRush, v72, nil, not v18:IsSpellInRange(v86.BladeRush)) or ((17317 - 12868) == (3749 - (686 + 400)))) then
				return "Cast Blade Rush";
			end
		end
		if (v86.BloodFury:IsCastable() or ((3356 + 921) < (3218 - (73 + 156)))) then
			if (v11.Cast(v86.BloodFury, nil, v32) or ((5 + 865) >= (4960 - (721 + 90)))) then
				return "Cast Blood Fury";
			end
		end
		if (((25 + 2187) < (10334 - 7151)) and v86.Berserking:IsCastable()) then
			if (((5116 - (224 + 246)) > (4846 - 1854)) and v11.Cast(v86.Berserking, nil, v32)) then
				return "Cast Berserking";
			end
		end
		if (((2639 - 1205) < (564 + 2542)) and v86.Fireblood:IsCastable()) then
			if (((19 + 767) < (2221 + 802)) and v11.Cast(v86.Fireblood, nil, v32)) then
				return "Cast Fireblood";
			end
		end
		if (v86.AncestralCall:IsCastable() or ((4854 - 2412) < (245 - 171))) then
			if (((5048 - (203 + 310)) == (6528 - (1238 + 755))) and v11.Cast(v86.AncestralCall, nil, v32)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v124()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (1537 - (709 + 825))) or ((5544 - 2535) <= (3065 - 960))) then
				if (((2694 - (196 + 668)) < (14486 - 10817)) and v86.Ambush:IsCastable() and v18:IsSpellInRange(v86.Ambush) and v86.HiddenOpportunity:IsAvailable()) then
					if (v11.Press(v86.Ambush) or ((2962 - 1532) >= (4445 - (171 + 662)))) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((2776 - (4 + 89)) >= (8622 - 6162)) and (v140 == (1 + 1))) then
				if ((v18:IsSpellInRange(v86.PistolShot) and v86.Crackshot:IsAvailable() and (v86.FanTheHammer:TalentRank() >= (8 - 6)) and (v17:BuffStack(v86.Opportunity) >= (3 + 3)) and ((v17:BuffUp(v86.Broadside) and (v99 <= (1487 - (35 + 1451)))) or v17:BuffUp(v86.GreenskinsWickersBuff))) or ((3257 - (28 + 1425)) >= (5268 - (941 + 1052)))) then
					if (v11.Press(v86.PistolShot) or ((1359 + 58) > (5143 - (822 + 692)))) then
						return "Cast Pistol Shot";
					end
				end
				if (((6845 - 2050) > (190 + 212)) and v86.HiddenOpportunity:IsAvailable() and v17:BuffUp(v86.AudacityBuff)) then
					if (((5110 - (45 + 252)) > (3528 + 37)) and v11.Cast(v86.Ambush, nil, not v18:IsSpellInRange(v86.Ambush))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 2 + 1;
			end
			if (((9520 - 5608) == (4345 - (114 + 319))) and (v140 == (0 - 0))) then
				if (((3614 - 793) <= (3076 + 1748)) and v86.BladeFlurry:IsReady() and v86.BladeFlurry:IsCastable() and v29 and v86.Subterfuge:IsAvailable() and v86.HiddenOpportunity:IsAvailable() and (v95 >= (2 - 0)) and (v17:BuffRemains(v86.BladeFlurry) <= (5 - 2)) and (v86.AdrenalineRush:IsReady() or v17:BuffUp(v86.AdrenalineRush))) then
					if (((3701 - (556 + 1407)) <= (3401 - (741 + 465))) and v72) then
						v11.Cast(v86.BladeFlurry);
					elseif (((506 - (170 + 295)) <= (1591 + 1427)) and v11.Cast(v86.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((1971 + 174) <= (10104 - 6000)) and v86.ColdBlood:IsCastable() and v17:BuffDown(v86.ColdBlood) and v18:IsSpellInRange(v86.Dispatch) and v116()) then
					if (((2230 + 459) < (3108 + 1737)) and v11.Cast(v86.ColdBlood, v57)) then
						return "Cast Cold Blood";
					end
				end
				v140 = 1 + 0;
			end
			if ((v140 == (1231 - (957 + 273))) or ((622 + 1700) > (1050 + 1572))) then
				if ((v86.BetweentheEyes:IsCastable() and v18:IsSpellInRange(v86.BetweentheEyes) and v116() and v86.Crackshot:IsAvailable() and (not v17:BuffUp(v86.Shadowmeld) or v17:StealthUp(true, false))) or ((17276 - 12742) == (5486 - 3404))) then
					if (v11.Cast(v86.BetweentheEyes) or ((4798 - 3227) > (9244 - 7377))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v86.Dispatch:IsCastable() and v18:IsSpellInRange(v86.Dispatch) and v116()) or ((4434 - (389 + 1391)) >= (1880 + 1116))) then
					if (((415 + 3563) > (4789 - 2685)) and v11.Press(v86.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v140 = 953 - (783 + 168);
			end
		end
	end
	local function v125()
		local v141 = 0 - 0;
		while true do
			if (((2946 + 49) > (1852 - (309 + 2))) and (v141 == (2 - 1))) then
				if (((4461 - (1090 + 122)) > (309 + 644)) and v86.SliceandDice:IsCastable() and (v11.FilteredFightRemains(v94, ">", v17:BuffRemains(v86.SliceandDice), true) or (v17:BuffRemains(v86.SliceandDice) == (0 - 0))) and (v17:BuffRemains(v86.SliceandDice) < ((1 + 0 + v99) * (1119.8 - (628 + 490))))) then
					if (v11.Press(v86.SliceandDice) or ((587 + 2686) > (11322 - 6749))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v86.KillingSpree:IsCastable() and v18:IsSpellInRange(v86.KillingSpree) and (v18:DebuffUp(v86.GhostlyStrike) or not v86.GhostlyStrike:IsAvailable())) or ((14400 - 11249) < (2058 - (431 + 343)))) then
					if (v11.Cast(v86.KillingSpree) or ((3736 - 1886) == (4423 - 2894))) then
						return "Cast Killing Spree";
					end
				end
				v141 = 2 + 0;
			end
			if (((106 + 715) < (3818 - (556 + 1139))) and (v141 == (17 - (6 + 9)))) then
				if (((166 + 736) < (1192 + 1133)) and v86.ColdBlood:IsCastable() and v17:BuffDown(v86.ColdBlood) and v18:IsSpellInRange(v86.Dispatch)) then
					if (((1027 - (28 + 141)) <= (1148 + 1814)) and v11.Cast(v86.ColdBlood, v57)) then
						return "Cast Cold Blood";
					end
				end
				if ((v86.Dispatch:IsCastable() and v18:IsSpellInRange(v86.Dispatch)) or ((4870 - 924) < (913 + 375))) then
					if (v11.Press(v86.Dispatch) or ((4559 - (486 + 831)) == (1475 - 908))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v141 == (0 - 0)) or ((161 + 686) >= (3993 - 2730))) then
				if ((v86.BetweentheEyes:IsCastable() and v18:IsSpellInRange(v86.BetweentheEyes) and not v86.Crackshot:IsAvailable() and ((v17:BuffRemains(v86.BetweentheEyes) < (1267 - (668 + 595))) or v86.ImprovedBetweenTheEyes:IsAvailable() or v86.GreenskinsWickers:IsAvailable() or v17:HasTier(27 + 3, 1 + 3)) and v17:BuffDown(v86.GreenskinsWickers)) or ((6144 - 3891) == (2141 - (23 + 267)))) then
					if (v11.Press(v86.BetweentheEyes) or ((4031 - (1129 + 815)) > (2759 - (371 + 16)))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v86.BetweentheEyes:IsCastable() and v18:IsSpellInRange(v86.BetweentheEyes) and v86.Crackshot:IsAvailable() and (v86.Vanish:CooldownRemains() > (1795 - (1326 + 424))) and (v86.ShadowDance:CooldownRemains() > (22 - 10))) or ((16243 - 11798) < (4267 - (88 + 30)))) then
					if (v11.Press(v86.BetweentheEyes) or ((2589 - (720 + 51)) == (189 - 104))) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 1777 - (421 + 1355);
			end
		end
	end
	local function v126()
		if (((1039 - 409) < (1045 + 1082)) and v30 and v86.EchoingReprimand:IsReady()) then
			if (v11.Cast(v86.EchoingReprimand, v78, nil, not v18:IsSpellInRange(v86.EchoingReprimand)) or ((3021 - (286 + 797)) == (9190 - 6676))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((7047 - 2792) >= (494 - (397 + 42))) and v86.Ambush:IsCastable() and v86.HiddenOpportunity:IsAvailable() and v17:BuffUp(v86.AudacityBuff)) then
			if (((937 + 2062) > (1956 - (24 + 776))) and v11.Press(v86.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((3620 - 1270) > (1940 - (222 + 563))) and v86.FanTheHammer:IsAvailable() and v86.Audacity:IsAvailable() and v86.HiddenOpportunity:IsAvailable() and v17:BuffUp(v86.Opportunity) and v17:BuffDown(v86.AudacityBuff)) then
			if (((8876 - 4847) <= (3495 + 1358)) and v11.Press(v86.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v86.FanTheHammer:IsAvailable() and v17:BuffUp(v86.Opportunity) and ((v17:BuffStack(v86.Opportunity) >= (196 - (23 + 167))) or (v17:BuffRemains(v86.Opportunity) < (1800 - (690 + 1108))))) or ((187 + 329) > (2833 + 601))) then
			if (((4894 - (40 + 808)) >= (500 + 2533)) and v11.Press(v86.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v86.FanTheHammer:IsAvailable() and v17:BuffUp(v86.Opportunity) and ((v100 >= ((3 - 2) + ((v23(v86.QuickDraw:IsAvailable()) + v23(v17:BuffUp(v86.Broadside))) * (v86.FanTheHammer:TalentRank() + 1 + 0)))) or (v99 <= (1 + 0)))) or ((1492 + 1227) <= (2018 - (47 + 524)))) then
			if (v11.Press(v86.PistolShot) or ((2683 + 1451) < (10731 - 6805))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if ((not v86.FanTheHammer:IsAvailable() and v17:BuffUp(v86.Opportunity) and ((v104 > (1.5 - 0)) or (v100 <= ((2 - 1) + v23(v17:BuffUp(v86.Broadside)))) or v86.QuickDraw:IsAvailable() or (v86.Audacity:IsAvailable() and v17:BuffDown(v86.AudacityBuff)))) or ((1890 - (1165 + 561)) >= (83 + 2702))) then
			if (v11.Cast(v86.PistolShot) or ((1626 - 1101) == (805 + 1304))) then
				return "Cast Pistol Shot";
			end
		end
		if (((512 - (341 + 138)) == (9 + 24)) and v86.SinisterStrike:IsCastable()) then
			if (((6302 - 3248) <= (4341 - (89 + 237))) and v11.Cast(v86.SinisterStrike, nil, nil, not v18:IsSpellInRange(v86.SinisterStrike))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v127()
		v83();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v99 = v17:ComboPoints();
		v98 = v85.EffectiveComboPoints(v99);
		v100 = v17:ComboPointsDeficit();
		v105 = (v17:BuffUp(v86.AdrenalineRush, nil, true) and -(160 - 110)) or (0 - 0);
		v101 = v110();
		v102 = v17:EnergyRegen();
		v104 = v109(v105);
		v103 = v17:EnergyDeficitPredicted(nil, v105);
		if (((2752 - (581 + 300)) < (4602 - (855 + 365))) and v29) then
			local v148 = 0 - 0;
			while true do
				if (((423 + 870) <= (3401 - (1030 + 205))) and ((0 + 0) == v148)) then
					v93 = v17:GetEnemiesInRange(28 + 2);
					v94 = v17:GetEnemiesInRange(v97);
					v148 = 287 - (156 + 130);
				end
				if (((2 - 1) == v148) or ((4346 - 1767) < (251 - 128))) then
					v95 = #v94;
					break;
				end
			end
		else
			v95 = 1 + 0;
		end
		v96 = v85.CrimsonVial();
		if (v96 or ((494 + 352) >= (2437 - (10 + 59)))) then
			return v96;
		end
		v85.Poisons();
		if ((v34 and (v17:HealthPercentage() <= v36)) or ((1135 + 2877) <= (16537 - 13179))) then
			local v149 = 1163 - (671 + 492);
			while true do
				if (((1190 + 304) <= (4220 - (369 + 846))) and ((0 + 0) == v149)) then
					if ((v35 == "Refreshing Healing Potion") or ((2655 + 456) == (4079 - (1036 + 909)))) then
						if (((1873 + 482) == (3953 - 1598)) and v87.RefreshingHealingPotion:IsReady()) then
							if (v11.Press(v88.RefreshingHealingPotion) or ((791 - (11 + 192)) <= (219 + 213))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((4972 - (135 + 40)) >= (9436 - 5541)) and (v35 == "Dreamwalker's Healing Potion")) then
						if (((2157 + 1420) == (7880 - 4303)) and v87.DreamwalkersHealingPotion:IsReady()) then
							if (((5687 - 1893) > (3869 - (50 + 126))) and v11.Press(v88.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if ((v86.Feint:IsCastable() and v86.Feint:IsReady() and (v17:HealthPercentage() <= v60)) or ((3550 - 2275) == (908 + 3192))) then
			if (v11.Cast(v86.Feint) or ((3004 - (1233 + 180)) >= (4549 - (522 + 447)))) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((2404 - (107 + 1314)) <= (839 + 969)) and v86.Evasion:IsCastable() and v86.Evasion:IsReady() and (v17:HealthPercentage() <= v82)) then
			if (v11.Cast(v86.Evasion) or ((6551 - 4401) <= (509 + 688))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((7484 - 3715) >= (4641 - 3468)) and not v17:IsCasting() and not v17:IsChanneling()) then
			local v150 = v84.Interrupt(v86.Kick, 1918 - (716 + 1194), true);
			if (((26 + 1459) == (160 + 1325)) and v150) then
				return v150;
			end
			v150 = v84.Interrupt(v86.Kick, 511 - (74 + 429), true, v14, v88.KickMouseover);
			if (v150 or ((6394 - 3079) <= (1379 + 1403))) then
				return v150;
			end
			v150 = v84.Interrupt(v86.Blind, 34 - 19, v81);
			if (v150 or ((620 + 256) >= (9137 - 6173))) then
				return v150;
			end
			v150 = v84.Interrupt(v86.Blind, 37 - 22, v81, v14, v88.BlindMouseover);
			if (v150 or ((2665 - (279 + 154)) > (3275 - (454 + 324)))) then
				return v150;
			end
			v150 = v84.InterruptWithStun(v86.CheapShot, 7 + 1, v17:StealthUp(false, false));
			if (v150 or ((2127 - (12 + 5)) <= (180 + 152))) then
				return v150;
			end
			v150 = v84.InterruptWithStun(v86.KidneyShot, 20 - 12, v17:ComboPoints() > (0 + 0));
			if (((4779 - (277 + 816)) > (13554 - 10382)) and v150) then
				return v150;
			end
		end
		if (v31 or ((5657 - (1058 + 125)) < (154 + 666))) then
			v96 = v84.HandleIncorporeal(v86.Blind, v88.BlindMouseover, 1005 - (815 + 160), true);
			if (((18359 - 14080) >= (6841 - 3959)) and v96) then
				return v96;
			end
		end
		if ((not v17:AffectingCombat() and not v17:IsMounted() and v61) or ((485 + 1544) >= (10292 - 6771))) then
			v96 = v85.Stealth(v86.Stealth2, nil);
			if (v96 or ((3935 - (41 + 1857)) >= (6535 - (1222 + 671)))) then
				return "Stealth (OOC): " .. v96;
			end
		end
		if (((4445 - 2725) < (6407 - 1949)) and not v17:AffectingCombat() and (v86.Vanish:TimeSinceLastCast() > (1183 - (229 + 953))) and v18:IsInRange(1782 - (1111 + 663)) and v28) then
			if ((v84.TargetIsValid() and v18:IsInRange(1589 - (874 + 705)) and not (v17:IsChanneling() or v17:IsCasting())) or ((62 + 374) > (2062 + 959))) then
				local v177 = 0 - 0;
				while true do
					if (((21 + 692) <= (1526 - (642 + 37))) and (v177 == (1 + 0))) then
						if (((345 + 1809) <= (10120 - 6089)) and v84.TargetIsValid()) then
							local v193 = 454 - (233 + 221);
							while true do
								if (((10671 - 6056) == (4063 + 552)) and (v193 == (1541 - (718 + 823)))) then
									if ((v86.ImprovedAdrenalineRush:IsAvailable() and (v99 <= (2 + 0))) or ((4595 - (266 + 539)) == (1415 - 915))) then
										if (((1314 - (636 + 589)) < (524 - 303)) and v11.Cast(v86.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if (((4236 - 2182) >= (1127 + 294)) and v86.RolltheBones:IsReady() and not v17:DebuffUp(v86.Dreadblades) and ((v113() == (0 + 0)) or v115())) then
										if (((1707 - (657 + 358)) < (8096 - 5038)) and v11.Cast(v86.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v193 = 2 - 1;
								end
								if ((v193 == (1188 - (1151 + 36))) or ((3143 + 111) == (436 + 1219))) then
									if ((v86.SliceandDice:IsReady() and (v17:BuffRemains(v86.SliceandDice) < (((2 - 1) + v99) * (1833.8 - (1552 + 280))))) or ((2130 - (64 + 770)) == (3334 + 1576))) then
										if (((7645 - 4277) == (598 + 2770)) and v11.Press(v86.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (((3886 - (157 + 1086)) < (7636 - 3821)) and (v17:StealthUp(true, false) or v86.Subterfuge:BuffUp())) then
										v96 = v124();
										if (((8378 - 6465) > (755 - 262)) and v96) then
											return "Stealth (Opener): " .. v96;
										end
										if (((6489 - 1734) > (4247 - (599 + 220))) and v86.KeepItRolling:IsAvailable() and v86.GhostlyStrike:IsReady() and v86.EchoingReprimand:IsAvailable()) then
											if (((2749 - 1368) <= (4300 - (1813 + 118))) and v11.Cast(v86.GhostlyStrike, nil, nil, not v18:IsSpellInRange(v86.GhostlyStrike))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v86.Ambush:IsCastable() and v86.HiddenOpportunity:IsAvailable()) or ((3541 + 1302) == (5301 - (841 + 376)))) then
											if (((6541 - 1872) > (85 + 278)) and v11.Cast(v86.Ambush, nil, nil, not v18:IsSpellInRange(v86.Ambush))) then
												return "Cast Ambush (Opener)";
											end
										elseif (v86.SinisterStrike:IsCastable() or ((5123 - 3246) >= (3997 - (464 + 395)))) then
											if (((12169 - 7427) >= (1742 + 1884)) and v11.Cast(v86.SinisterStrike, nil, nil, not v18:IsSpellInRange(v86.SinisterStrike))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
									elseif (v116() or ((5377 - (467 + 370)) == (1892 - 976))) then
										v96 = v125();
										if (v96 or ((849 + 307) > (14894 - 10549))) then
											return "Finish (Opener): " .. v96;
										end
									end
									v193 = 1 + 1;
								end
								if (((5204 - 2967) < (4769 - (150 + 370))) and (v193 == (1284 - (74 + 1208)))) then
									if (v86.SinisterStrike:IsCastable() or ((6599 - 3916) < (109 - 86))) then
										if (((496 + 201) <= (1216 - (14 + 376))) and v11.Cast(v86.SinisterStrike, nil, nil, not v18:IsSpellInRange(v86.SinisterStrike))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
							end
						end
						return;
					end
					if (((1916 - 811) <= (761 + 415)) and (v177 == (0 + 0))) then
						if (((3223 + 156) <= (11169 - 7357)) and v86.BladeFlurry:IsReady() and v17:BuffDown(v86.BladeFlurry) and v86.UnderhandedUpperhand:IsAvailable() and not v17:StealthUp(true, true) and (v86.AdrenalineRush:IsReady() or v17:BuffUp(v86.AdrenalineRush))) then
							if (v11.Press(v86.BladeFlurry) or ((593 + 195) >= (1694 - (23 + 55)))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((4393 - 2539) <= (2255 + 1124)) and not v17:StealthUp(true, false)) then
							local v194 = 0 + 0;
							while true do
								if (((7052 - 2503) == (1431 + 3118)) and (v194 == (901 - (652 + 249)))) then
									v96 = v85.Stealth(v86.Stealth);
									if (v96 or ((8087 - 5065) >= (4892 - (708 + 1160)))) then
										return v96;
									end
									break;
								end
							end
						end
						v177 = 2 - 1;
					end
				end
			end
		end
		if (((8787 - 3967) > (2225 - (10 + 17))) and v86.FanTheHammer:IsAvailable() and (v86.PistolShot:TimeSinceLastCast() < v17:GCDRemains())) then
			local v151 = 0 + 0;
			while true do
				if (((1733 - (1400 + 332)) == v151) or ((2034 - 973) >= (6799 - (242 + 1666)))) then
					v100 = v17:ComboPointsDeficit();
					break;
				end
				if (((584 + 780) <= (1640 + 2833)) and (v151 == (0 + 0))) then
					v99 = v27(v99, v85.FanTheHammerCP());
					v98 = v85.EffectiveComboPoints(v99);
					v151 = 941 - (850 + 90);
				end
			end
		end
		if (v84.TargetIsValid() or ((6296 - 2701) <= (1393 - (360 + 1030)))) then
			local v152 = 0 + 0;
			while true do
				if ((v152 == (2 - 1)) or ((6427 - 1755) == (5513 - (909 + 752)))) then
					if (((2782 - (109 + 1114)) == (2853 - 1294)) and v116()) then
						local v190 = 0 + 0;
						while true do
							if ((v190 == (243 - (6 + 236))) or ((1104 + 648) <= (635 + 153))) then
								return "Finish Pooling";
							end
							if ((v190 == (0 - 0)) or ((6824 - 2917) == (1310 - (1076 + 57)))) then
								v96 = v125();
								if (((571 + 2899) > (1244 - (579 + 110))) and v96) then
									return "Finish: " .. v96;
								end
								v190 = 1 + 0;
							end
						end
					end
					v96 = v126();
					if (v96 or ((860 + 112) == (343 + 302))) then
						return "Build: " .. v96;
					end
					v152 = 409 - (174 + 233);
				end
				if (((8888 - 5706) >= (3712 - 1597)) and (v152 == (1 + 1))) then
					if (((5067 - (663 + 511)) < (3952 + 477)) and v86.ArcaneTorrent:IsCastable() and v18:IsSpellInRange(v86.SinisterStrike) and (v103 > (4 + 11 + v102))) then
						if (v11.Cast(v86.ArcaneTorrent, v32) or ((8838 - 5971) < (1154 + 751))) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v86.ArcanePulse:IsCastable() and v18:IsSpellInRange(v86.SinisterStrike)) or ((4228 - 2432) >= (9806 - 5755))) then
						if (((773 + 846) <= (7310 - 3554)) and v11.Cast(v86.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if (((431 + 173) == (56 + 548)) and v86.LightsJudgment:IsCastable() and v18:IsInMeleeRange(727 - (478 + 244))) then
						if (v11.Cast(v86.LightsJudgment, v32) or ((5001 - (440 + 77)) == (410 + 490))) then
							return "Cast Lights Judgment";
						end
					end
					v152 = 10 - 7;
				end
				if ((v152 == (1559 - (655 + 901))) or ((827 + 3632) <= (853 + 260))) then
					if (((2453 + 1179) > (13689 - 10291)) and v86.BagofTricks:IsCastable() and v18:IsInMeleeRange(1450 - (695 + 750))) then
						if (((13938 - 9856) <= (7588 - 2671)) and v11.Cast(v86.BagofTricks, v32)) then
							return "Cast Bag of Tricks";
						end
					end
					if (((19432 - 14600) >= (1737 - (285 + 66))) and v18:IsSpellInRange(v86.PistolShot) and not v18:IsInRange(v97) and not v17:StealthUp(true, true) and (v103 < (58 - 33)) and ((v100 >= (1311 - (682 + 628))) or (v104 <= (1.2 + 0)))) then
						if (((436 - (176 + 123)) == (58 + 79)) and v11.Cast(v86.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v86.SinisterStrike:IsCastable() or ((1139 + 431) >= (4601 - (239 + 30)))) then
						if (v11.Cast(v86.SinisterStrike, nil, nil, not v18:IsSpellInRange(v86.SinisterStrike)) or ((1105 + 2959) <= (1749 + 70))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if ((v152 == (0 - 0)) or ((15555 - 10569) < (1889 - (306 + 9)))) then
					v96 = v123();
					if (((15444 - 11018) > (30 + 142)) and v96) then
						return "CDs: " .. v96;
					end
					if (((360 + 226) > (220 + 235)) and (v17:StealthUp(true, true) or v17:BuffUp(v86.Shadowmeld))) then
						local v191 = 0 - 0;
						while true do
							if (((2201 - (1140 + 235)) == (526 + 300)) and (v191 == (0 + 0))) then
								v96 = v124();
								if (v96 or ((1032 + 2987) > (4493 - (33 + 19)))) then
									return "Stealth: " .. v96;
								end
								break;
							end
						end
					end
					v152 = 1 + 0;
				end
			end
		end
	end
	local function v128()
		v11.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v11.SetAPL(779 - 519, v127, v128);
end;
return v1["Epix_Rogue_Outlaw.lua"](...);

