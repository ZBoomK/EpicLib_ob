local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((6942 - 4573) == (2262 - (1045 + 791)))) then
			v6 = v0[v4];
			if (not v6 or ((7786 - 4710) > (4860 - 1677))) then
				return v1(v4, ...);
			end
			v5 = 506 - (351 + 154);
		end
		if (((2776 - (1281 + 293)) > (1324 - (28 + 238))) and (v5 == (2 - 1))) then
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
	local function v81()
		local v127 = 1559 - (1381 + 178);
		while true do
			if (((3481 + 230) > (2706 + 649)) and (v127 == (4 + 4))) then
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v78 = EpicSettings.Settings['sepsis'];
				v127 = 30 - 21;
			end
			if ((v127 == (1 + 0)) or ((1376 - (381 + 89)) >= (1977 + 252))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v127 = 1158 - (1074 + 82);
			end
			if (((2822 - 1534) > (3035 - (214 + 1570))) and (v127 == (1461 - (990 + 465)))) then
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'] or (0 + 0);
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v127 = 4 + 3;
			end
			if ((v127 == (7 + 0)) or ((17760 - 13247) < (5078 - (1668 + 58)))) then
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v127 = 634 - (512 + 114);
			end
			if ((v127 == (13 - 8)) or ((4268 - 2203) >= (11120 - 7924))) then
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v127 = 2 + 4;
			end
			if ((v127 == (4 + 0)) or ((14760 - 10384) <= (3475 - (109 + 1885)))) then
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1469 - (1269 + 200));
				v127 = 9 - 4;
			end
			if ((v127 == (815 - (98 + 717))) or ((4218 - (802 + 24)) >= (8175 - 3434))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v127 = 1 + 0;
			end
			if (((2555 + 770) >= (354 + 1800)) and ((2 + 7) == v127)) then
				v79 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
				v80 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if ((v127 == (2 + 1)) or ((528 + 767) >= (2667 + 566))) then
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v127 = 3 + 1;
			end
			if (((2044 + 2333) > (3075 - (797 + 636))) and (v127 == (9 - 7))) then
				v37 = EpicSettings.Settings['InterruptWithStun'] or (1619 - (1427 + 192));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v127 = 3 + 0;
			end
		end
	end
	local v82 = v10.Commons.Everyone;
	local v83 = v10.Commons.Rogue;
	local v84 = v18.Rogue.Outlaw;
	local v85 = v20.Rogue.Outlaw;
	local v86 = v21.Rogue.Outlaw;
	local v87 = {};
	local v88 = v16:GetEquipment();
	local v89 = (v88[6 + 7] and v20(v88[339 - (192 + 134)])) or v20(1276 - (316 + 960));
	local v90 = (v88[8 + 6] and v20(v88[11 + 3])) or v20(0 + 0);
	v10:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if (((5274 - (83 + 468)) > (3162 - (1202 + 604))) and ((4 - 3) == v128)) then
				v90 = (v88[23 - 9] and v20(v88[38 - 24])) or v20(325 - (45 + 280));
				break;
			end
			if (((0 + 0) == v128) or ((3614 + 522) <= (1254 + 2179))) then
				v88 = v16:GetEquipment();
				v89 = (v88[8 + 5] and v20(v88[3 + 10])) or v20(0 - 0);
				v128 = 1912 - (340 + 1571);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v84.Dispatch:RegisterDamageFormula(function()
		return v16:AttackPowerDamageMod() * v83.CPSpend() * (0.3 + 0) * (1773 - (1733 + 39)) * ((2 - 1) + (v16:VersatilityDmgPct() / (1134 - (125 + 909)))) * ((v17:DebuffUp(v84.GhostlyStrike) and (1949.1 - (1096 + 852))) or (1 + 0));
	end);
	local v91, v92, v93;
	local v94;
	local v95;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v105, v106 = 95 - (51 + 44), 0 + 0;
	local function v107(v129)
		local v130 = v16:EnergyTimeToMaxPredicted(nil, v129);
		if (((5562 - (1114 + 203)) <= (5357 - (228 + 498))) and ((v130 < v105) or ((v130 - v105) > (0.5 + 0)))) then
			v105 = v130;
		end
		return v105;
	end
	local function v108()
		local v131 = 0 + 0;
		local v132;
		while true do
			if (((4939 - (174 + 489)) >= (10197 - 6283)) and (v131 == (1906 - (830 + 1075)))) then
				return v106;
			end
			if (((722 - (303 + 221)) <= (5634 - (231 + 1038))) and (v131 == (0 + 0))) then
				v132 = v16:EnergyPredicted();
				if (((5944 - (171 + 991)) > (19270 - 14594)) and ((v132 > v106) or ((v132 - v106) > (23 - 14)))) then
					v106 = v132;
				end
				v131 = 2 - 1;
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local function v110(v133, v134)
		if (((5022 - (91 + 67)) > (6538 - 4341)) and not v11.APLVar.RtB_List) then
			v11.APLVar.RtB_List = {};
		end
		if (not v11.APLVar.RtB_List[v133] or ((924 + 2776) == (3030 - (423 + 100)))) then
			v11.APLVar.RtB_List[v133] = {};
		end
		local v135 = table.concat(v134);
		if (((32 + 4442) >= (758 - 484)) and (v133 == "All")) then
			if (not v11.APLVar.RtB_List[v133][v135] or ((988 + 906) <= (2177 - (326 + 445)))) then
				local v169 = 0 - 0;
				local v170;
				while true do
					if (((3501 - 1929) >= (3573 - 2042)) and (v169 == (712 - (530 + 181)))) then
						v11.APLVar.RtB_List[v133][v135] = ((v170 == #v134) and true) or false;
						break;
					end
					if (((881 - (614 + 267)) == v169) or ((4719 - (19 + 13)) < (7392 - 2850))) then
						v170 = 0 - 0;
						for v187 = 2 - 1, #v134 do
							if (((855 + 2436) > (2931 - 1264)) and v16:BuffUp(v109[v134[v187]])) then
								v170 = v170 + (1 - 0);
							end
						end
						v169 = 1813 - (1293 + 519);
					end
				end
			end
		elseif (not v11.APLVar.RtB_List[v133][v135] or ((1781 - 908) == (5310 - 3276))) then
			local v171 = 0 - 0;
			while true do
				if ((v171 == (0 - 0)) or ((6633 - 3817) < (6 + 5))) then
					v11.APLVar.RtB_List[v133][v135] = false;
					for v188 = 1 + 0, #v134 do
						if (((8594 - 4895) < (1088 + 3618)) and v16:BuffUp(v109[v134[v188]])) then
							v11.APLVar.RtB_List[v133][v135] = true;
							break;
						end
					end
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v133][v135];
	end
	local function v111()
		if (((880 + 1766) >= (548 + 328)) and not v11.APLVar.RtB_Buffs) then
			local v147 = 1096 - (709 + 387);
			local v148;
			while true do
				if (((2472 - (673 + 1185)) <= (9233 - 6049)) and (v147 == (9 - 6))) then
					for v181 = 1 - 0, #v109 do
						local v182 = 0 + 0;
						local v183;
						while true do
							if (((2336 + 790) == (4219 - 1093)) and (v182 == (0 + 0))) then
								v183 = v16:BuffRemains(v109[v181]);
								if ((v183 > (0 - 0)) or ((4293 - 2106) >= (6834 - (446 + 1434)))) then
									local v194 = 1283 - (1040 + 243);
									while true do
										if ((v194 == (0 - 0)) or ((5724 - (559 + 1288)) == (5506 - (609 + 1322)))) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (455 - (13 + 441));
											if (((2641 - 1934) > (1655 - 1023)) and (v183 == v148)) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (4 - 3);
											elseif ((v183 > v148) or ((21 + 525) >= (9747 - 7063))) then
												v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
											else
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
											end
											break;
										end
									end
								end
								break;
							end
						end
					end
					break;
				end
				if (((4347 - 2882) <= (2354 + 1947)) and (v147 == (3 - 1))) then
					v11.APLVar.RtB_Buffs.Longer = 0 + 0;
					v148 = v83.RtBRemains();
					v147 = 2 + 1;
				end
				if (((1225 + 479) > (1197 + 228)) and (v147 == (0 + 0))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Total = 433 - (153 + 280);
					v147 = 2 - 1;
				end
				if ((v147 == (1 + 0)) or ((272 + 415) == (2216 + 2018))) then
					v11.APLVar.RtB_Buffs.Normal = 0 + 0;
					v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v147 = 2 - 0;
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v112()
		if (not v11.APLVar.RtB_Reroll or ((2059 + 1271) < (2096 - (89 + 578)))) then
			if (((820 + 327) >= (696 - 361)) and (v64 == "1+ Buff")) then
				v11.APLVar.RtB_Reroll = ((v111() <= (1049 - (572 + 477))) and true) or false;
			elseif (((464 + 2971) > (1259 + 838)) and (v64 == "Broadside")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.Broadside) and true) or false;
			elseif ((v64 == "Buried Treasure") or ((451 + 3319) >= (4127 - (84 + 2)))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif ((v64 == "Grand Melee") or ((6247 - 2456) <= (1161 + 450))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.GrandMelee) and true) or false;
			elseif ((v64 == "Skull and Crossbones") or ((5420 - (497 + 345)) <= (52 + 1956))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((191 + 934) <= (3409 - (605 + 728))) and (v64 == "Ruthless Precision")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((531 + 212) >= (9779 - 5380))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.TrueBearing) and true) or false;
			else
				v11.APLVar.RtB_Reroll = false;
				v111();
				if (((53 + 1102) < (6185 - 4512)) and (v111() <= (2 + 0)) and v16:BuffUp(v84.BuriedTreasure) and v16:BuffDown(v84.GrandMelee) and (v93 < (5 - 3))) then
					v11.APLVar.RtB_Reroll = true;
				end
				if ((v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:HasTier(24 + 7, 493 - (457 + 32)) and ((not v16:BuffUp(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v16:BuffUp(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v111() <= (1 + 0))) or ((3726 - (832 + 570)) <= (545 + 33))) then
					v11.APLVar.RtB_Reroll = true;
				end
				if (((983 + 2784) == (13330 - 9563)) and v84.Crackshot:IsAvailable() and v16:HasTier(15 + 16, 800 - (588 + 208)) and (v111() <= ((2 - 1) + v22(v16:BuffUp(v84.LoadedDiceBuff))))) then
					v11.APLVar.RtB_Reroll = true;
				end
				if (((5889 - (884 + 916)) == (8560 - 4471)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:BuffUp(v84.SkullandCrossbones) and (v111() < (2 + 0 + v22(v16:BuffUp(v84.GrandMelee)))) and (v93 < (655 - (232 + 421)))) then
					v11.APLVar.RtB_Reroll = true;
				end
				if (((6347 - (1569 + 320)) >= (411 + 1263)) and v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (0 + 0)) or (v11.APLVar.RtB_Buffs.Normal == (0 - 0))) and (v11.APLVar.RtB_Buffs.Longer >= (606 - (316 + 289))) and (v111() < (13 - 8)) and (v83.RtBRemains() <= (2 + 37)) and not v16:StealthUp(true, true)) then
					v11.APLVar.RtB_Reroll = true;
				end
				if (((2425 - (666 + 787)) <= (1843 - (360 + 65))) and (v17:FilteredTimeToDie("<", 12 + 0) or v10.BossFilteredFightRemains("<", 266 - (79 + 175)))) then
					v11.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v113()
		return v96 >= ((v83.CPMaxSpend() - (1 - 0)) - v22((v16:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v114()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= (2 + 0 + v22(v84.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v84.Broadside))))) and (v99 >= (153 - 103));
	end
	local function v115()
		return not v28 or (v93 < (3 - 1)) or (v16:BuffRemains(v84.BladeFlurry) > ((900 - (503 + 396)) + v22(v84.KillingSpree:IsAvailable())));
	end
	local function v116()
		return v67 and (not v16:IsTanking(v17) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v22(v84.QuickDraw:IsAvailable()) + v22(v84.Audacity:IsAvailable())) < (v22(v84.CountTheOdds:IsAvailable()) + v22(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v16:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (183 - (92 + 89))) or v16:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		if ((v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v16:BuffUp(v84.Audacity) and (v117() or (v16:BuffStack(v84.Opportunity) < (10 - 4))) and v114()) or ((2533 + 2405) < (2819 + 1943))) then
			if (v10.Cast(v84.Vanish, v67) or ((9805 - 7301) > (584 + 3680))) then
				return "Cast Vanish (HO)";
			end
		end
		if (((4908 - 2755) == (1879 + 274)) and v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v113()) then
			if (v10.Cast(v84.Vanish, v67) or ((243 + 264) >= (7891 - 5300))) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((560 + 3921) == (6833 - 2352)) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v113() and ((v84.Vanish:CooldownRemains() >= (1250 - (485 + 759))) or not v67) and not v16:StealthUp(true, false)) then
			if (v10.Cast(v84.ShadowDance, v53) or ((5386 - 3058) < (1882 - (442 + 747)))) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((5463 - (832 + 303)) == (5274 - (88 + 858))) and v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and not v84.KeepItRolling:IsAvailable() and v118() and v16:BuffUp(v84.SliceandDice) and (v113() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady())) then
			if (((484 + 1104) >= (1103 + 229)) and v10.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (2 + 28)) or ((v84.KeepItRolling:CooldownRemains() >= (909 - (766 + 23))) and (v113() or v84.HiddenOpportunity:IsAvailable())))) or ((20605 - 16431) > (5809 - 1561))) then
			if (v10.Cast(v84.ShadowDance, v53) or ((12082 - 7496) <= (278 - 196))) then
				return "Cast Shadow Dance";
			end
		end
		if (((4936 - (1036 + 37)) == (2739 + 1124)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady()) then
			if ((v84.Crackshot:IsAvailable() and v113()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v113()) or v84.HiddenOpportunity:IsAvailable())) or ((548 - 266) <= (34 + 8))) then
				if (((6089 - (641 + 839)) >= (1679 - (910 + 3))) and v10.Cast(v84.Shadowmeld, v30)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v136 = v82.HandleTopTrinket(v87, v29, 101 - 61, nil);
		if (v136 or ((2836 - (1466 + 218)) == (1144 + 1344))) then
			return v136;
		end
		local v136 = v82.HandleBottomTrinket(v87, v29, 1188 - (556 + 592), nil);
		if (((1217 + 2205) > (4158 - (329 + 479))) and v136) then
			return v136;
		end
	end
	local function v121()
		local v137 = 854 - (174 + 680);
		local v138;
		local v139;
		while true do
			if (((3013 - 2136) > (778 - 402)) and (v137 == (2 + 0))) then
				if ((v84.KeepItRolling:IsReady() and not v112() and (v111() >= ((742 - (396 + 343)) + v22(v16:HasTier(3 + 28, 1481 - (29 + 1448))))) and (v16:BuffDown(v84.ShadowDance) or (v111() >= (1395 - (135 + 1254))))) or ((11746 - 8628) <= (8642 - 6791))) then
					if (v10.Cast(v84.KeepItRolling) or ((110 + 55) >= (5019 - (389 + 1138)))) then
						return "Cast Keep it Rolling";
					end
				end
				if (((4523 - (102 + 472)) < (4583 + 273)) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (4 + 3))) then
					if (v12(v84.GhostlyStrike, v72, nil, not v17:IsSpellInRange(v84.GhostlyStrike)) or ((3988 + 288) < (4561 - (320 + 1225)))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((8349 - 3659) > (2524 + 1601)) and v29 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v113() and not v16:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 1475 - (157 + 1307)) and v16:BuffUp(v84.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1870 - (821 + 1038)) or ((124 - 74) >= (98 + 798))) then
						if (v10.Cast(v84.Sepsis) or ((3044 - 1330) >= (1101 + 1857))) then
							return "Cast Sepsis";
						end
					end
				end
				v137 = 7 - 4;
			end
			if ((v137 == (1031 - (834 + 192))) or ((95 + 1396) < (166 + 478))) then
				if (((16 + 688) < (1528 - 541)) and v84.Berserking:IsCastable()) then
					if (((4022 - (300 + 4)) > (510 + 1396)) and v10.Cast(v84.Berserking, v30)) then
						return "Cast Berserking";
					end
				end
				if (v84.Fireblood:IsCastable() or ((2507 - 1549) > (3997 - (112 + 250)))) then
					if (((1396 + 2105) <= (11253 - 6761)) and v10.Cast(v84.Fireblood, v30)) then
						return "Cast Fireblood";
					end
				end
				if (v84.AncestralCall:IsCastable() or ((1972 + 1470) < (1318 + 1230))) then
					if (((2151 + 724) >= (726 + 738)) and v10.Cast(v84.AncestralCall, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if ((v137 == (3 + 0)) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
				if ((v84.BladeRush:IsReady() and (v102 > (886 - (244 + 638))) and not v16:StealthUp(true, true)) or ((1244 - (627 + 66)) > (6161 - 4093))) then
					if (((2716 - (512 + 90)) > (2850 - (1665 + 241))) and v10.Cast(v84.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				if ((not v16:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((2979 - (373 + 344)) >= (1397 + 1699))) then
					local v180 = 0 + 0;
					while true do
						if ((v180 == (0 - 0)) or ((3815 - 1560) >= (4636 - (35 + 1064)))) then
							v138 = v119();
							if (v138 or ((2792 + 1045) < (2794 - 1488))) then
								return v138;
							end
							break;
						end
					end
				end
				if (((12 + 2938) == (4186 - (298 + 938))) and v29 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v16:BuffUp(v84.ThistleTea) and ((v101 >= (1359 - (233 + 1026))) or v10.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (1672 - (636 + 1030))))) then
					if (v10.Cast(v84.ThistleTea) or ((2415 + 2308) < (3222 + 76))) then
						return "Cast Thistle Tea";
					end
				end
				v137 = 2 + 2;
			end
			if (((77 + 1059) >= (375 - (55 + 166))) and (v137 == (1 + 0))) then
				if (v84.RolltheBones:IsReady() or ((28 + 243) > (18132 - 13384))) then
					if (((5037 - (36 + 261)) >= (5511 - 2359)) and ((v112() and not v16:StealthUp(true, true)) or (v111() == (1368 - (34 + 1334))) or ((v83.RtBRemains() <= (2 + 1)) and v16:HasTier(25 + 6, 1287 - (1035 + 248))) or ((v83.RtBRemains() <= (28 - (20 + 1))) and ((v84.ShadowDance:CooldownRemains() <= (2 + 1)) or (v84.Vanish:CooldownRemains() <= (322 - (134 + 185)))) and not v16:StealthUp(true, true)))) then
						if (v12(v84.RolltheBones) or ((3711 - (549 + 584)) >= (4075 - (314 + 371)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v138 = v120();
				if (((140 - 99) <= (2629 - (478 + 490))) and v138) then
					return v138;
				end
				v137 = 2 + 0;
			end
			if (((1773 - (786 + 386)) < (11530 - 7970)) and (v137 == (1383 - (1055 + 324)))) then
				v139 = v82.HandleDPSPotion(v16:BuffUp(v84.AdrenalineRush));
				if (((1575 - (1093 + 247)) < (611 + 76)) and v139) then
					return v139;
				end
				if (((479 + 4070) > (4577 - 3424)) and v84.BloodFury:IsCastable()) then
					if (v10.Cast(v84.BloodFury, v30) or ((15862 - 11188) < (13294 - 8622))) then
						return "Cast Blood Fury";
					end
				end
				v137 = 12 - 7;
			end
			if (((1305 + 2363) < (17570 - 13009)) and (v137 == (0 - 0))) then
				if ((v29 and v84.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v84.AdrenalineRush) and (not v113() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))))) or ((1163 - 708) == (4293 - (364 + 324)))) then
					if (v12(v84.AdrenalineRush, v75) or ((7299 - 4636) == (7947 - 4635))) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((1418 + 2859) <= (18724 - 14249)) and v84.BladeFlurry:IsReady()) then
					if (((v93 >= ((2 - 0) - v22(v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v84.AdrenalineRush)))) and (v16:BuffRemains(v84.BladeFlurry) < v16:GCD())) or ((2642 - 1772) == (2457 - (1249 + 19)))) then
						if (((1402 + 151) <= (12195 - 9062)) and v12(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v84.BladeFlurry:IsReady() or ((3323 - (686 + 400)) >= (2755 + 756))) then
					if ((v84.DeftManeuvers:IsAvailable() and not v113() and (((v93 >= (232 - (73 + 156))) and (v98 == (v93 + v22(v16:BuffUp(v84.Broadside))))) or (v93 >= (1 + 4)))) or ((2135 - (721 + 90)) > (34 + 2986))) then
						if (v12(v84.BladeFlurry) or ((9714 - 6722) == (2351 - (224 + 246)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				v137 = 1 - 0;
			end
		end
	end
	local function v122()
		if (((5718 - 2612) > (277 + 1249)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v28 and v84.Subterfuge:IsAvailable() and (v93 >= (1 + 1)) and (v16:BuffRemains(v84.BladeFlurry) <= v16:GCDRemains())) then
			if (((2221 + 802) < (7694 - 3824)) and v70) then
				if (((475 - 332) > (587 - (203 + 310))) and v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(2003 - (1238 + 755)))) then
					return "Cast Blade Flurry";
				end
			elseif (((2 + 16) < (3646 - (709 + 825))) and v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(18 - 8))) then
				return "Cast Blade Flurry";
			end
		end
		if (((1597 - 500) <= (2492 - (196 + 668))) and v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch) and v113()) then
			if (((18280 - 13650) == (9590 - 4960)) and v10.Cast(v84.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if (((4373 - (171 + 662)) > (2776 - (4 + 89))) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v113() and v84.Crackshot:IsAvailable()) then
			if (((16802 - 12008) >= (1193 + 2082)) and v10.Press(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((6518 - 5034) == (582 + 902)) and v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch) and v113()) then
			if (((2918 - (35 + 1451)) < (5008 - (28 + 1425))) and v10.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if ((v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1995 - (941 + 1052))) and (v16:BuffStack(v84.Opportunity) >= (6 + 0)) and ((v16:BuffUp(v84.Broadside) and (v97 <= (1515 - (822 + 692)))) or v16:BuffUp(v84.GreenskinsWickersBuff))) or ((1519 - 454) > (1686 + 1892))) then
			if (v10.Press(v84.PistolShot) or ((5092 - (45 + 252)) < (1393 + 14))) then
				return "Cast Pistol Shot";
			end
		end
		if (((638 + 1215) < (11713 - 6900)) and v84.Ambush:IsCastable() and v17:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
			if (v10.Press(v84.Ambush) or ((3254 - (114 + 319)) < (3490 - 1059))) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1 + 0)) or ((4281 - 1407) < (4569 - 2388))) then
				if ((v84.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v92, ">", v16:BuffRemains(v84.SliceandDice), true) or (v16:BuffRemains(v84.SliceandDice) == (1963 - (556 + 1407)))) and (v16:BuffRemains(v84.SliceandDice) < (((1207 - (741 + 465)) + v97) * (466.8 - (170 + 295))))) or ((1417 + 1272) <= (316 + 27))) then
					if (v10.Press(v84.SliceandDice) or ((4601 - 2732) == (1666 + 343))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v17:IsSpellInRange(v84.KillingSpree) and (v17:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((2275 + 1271) < (1315 + 1007))) then
					if (v10.Cast(v84.KillingSpree) or ((3312 - (957 + 273)) == (1277 + 3496))) then
						return "Cast Killing Spree";
					end
				end
				v140 = 1 + 1;
			end
			if (((12361 - 9117) > (2780 - 1725)) and ((5 - 3) == v140)) then
				if ((v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch)) or ((16404 - 13091) <= (3558 - (389 + 1391)))) then
					if (v10.Cast(v84.ColdBlood, v55) or ((892 + 529) >= (219 + 1885))) then
						return "Cast Cold Blood";
					end
				end
				if (((4124 - 2312) <= (4200 - (783 + 168))) and v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch)) then
					if (((5446 - 3823) <= (1925 + 32)) and v10.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((4723 - (309 + 2)) == (13548 - 9136)) and (v140 == (1212 - (1090 + 122)))) then
				if (((568 + 1182) >= (2827 - 1985)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v16:BuffRemains(v84.BetweentheEyes) < (3 + 1)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v16:HasTier(1148 - (628 + 490), 1 + 3)) and v16:BuffDown(v84.GreenskinsWickers)) then
					if (((10824 - 6452) > (8454 - 6604)) and v10.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((1006 - (431 + 343)) < (1657 - 836)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (130 - 85)) and (v84.ShadowDance:CooldownRemains() > (12 + 3))) then
					if (((67 + 451) < (2597 - (556 + 1139))) and v10.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v140 = 16 - (6 + 9);
			end
		end
	end
	local function v124()
		if (((549 + 2445) > (440 + 418)) and v29 and v84.EchoingReprimand:IsReady()) then
			if (v10.Cast(v84.EchoingReprimand, v76, nil, not v17:IsSpellInRange(v84.EchoingReprimand)) or ((3924 - (28 + 141)) <= (355 + 560))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((4870 - 924) > (2651 + 1092)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.AudacityBuff)) then
			if (v10.Press(v84.Ambush) or ((2652 - (486 + 831)) >= (8602 - 5296))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((17053 - 12209) > (426 + 1827)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.Opportunity) and v16:BuffDown(v84.AudacityBuff)) then
			if (((1429 - 977) == (1715 - (668 + 595))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v16:BuffUp(v84.GreenskinsWickersBuff) and ((not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity)) or (v16:BuffRemains(v84.GreenskinsWickersBuff) < (1.5 + 0)))) or ((919 + 3638) < (5691 - 3604))) then
			if (((4164 - (23 + 267)) == (5818 - (1129 + 815))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v16:BuffStack(v84.Opportunity) >= (393 - (371 + 16))) or (v16:BuffRemains(v84.Opportunity) < (1752 - (1326 + 424))))) or ((3670 - 1732) > (18033 - 13098))) then
			if (v10.Press(v84.PistolShot) or ((4373 - (88 + 30)) < (4194 - (720 + 51)))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if (((3234 - 1780) <= (4267 - (421 + 1355))) and v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and (v98 > ((1 - 0) + (v22(v84.QuickDraw:IsAvailable()) * v84.FanTheHammer:TalentRank()))) and ((not v84.Vanish:IsReady() and not v84.ShadowDance:IsReady()) or v16:StealthUp(true, true) or not v84.Crackshot:IsAvailable() or (v84.FanTheHammer:TalentRank() <= (1 + 0)))) then
			if (v10.Press(v84.PistolShot) or ((5240 - (286 + 797)) <= (10246 - 7443))) then
				return "Cast Pistol Shot";
			end
		end
		if (((8037 - 3184) >= (3421 - (397 + 42))) and not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v102 > (1.5 + 0)) or (v98 <= ((801 - (24 + 776)) + v22(v16:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v16:BuffDown(v84.AudacityBuff)))) then
			if (((6368 - 2234) > (4142 - (222 + 563))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.SinisterStrike:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) or ((7528 - 4111) < (1825 + 709))) then
			if (v10.Press(v84.SinisterStrike) or ((2912 - (23 + 167)) <= (1962 - (690 + 1108)))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		v81();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v97 = v16:ComboPoints();
		v96 = v83.EffectiveComboPoints(v97);
		v98 = v16:ComboPointsDeficit();
		v103 = (v16:BuffUp(v84.AdrenalineRush, nil, true) and -(19 + 31)) or (0 + 0);
		v99 = v108();
		v100 = v16:EnergyRegen();
		v102 = v107(v103);
		v101 = v16:EnergyDeficitPredicted(nil, v103);
		if (v28 or ((3256 - (40 + 808)) < (348 + 1761))) then
			v91 = v16:GetEnemiesInRange(114 - 84);
			if (v84.AcrobaticStrikes:IsAvailable() or ((32 + 1) == (770 + 685))) then
				v92 = v16:GetEnemiesInRange(5 + 4);
			end
			if (not v84.AcrobaticStrikes:IsAvailable() or ((1014 - (47 + 524)) >= (2606 + 1409))) then
				v92 = v16:GetEnemiesInRange(16 - 10);
			end
			v93 = #v92;
		else
			v93 = 1 - 0;
		end
		v94 = v83.CrimsonVial();
		if (((7712 - 4330) > (1892 - (1165 + 561))) and v94) then
			return v94;
		end
		v83.Poisons();
		if ((v32 and (v16:HealthPercentage() <= v34)) or ((9 + 271) == (9473 - 6414))) then
			local v149 = 0 + 0;
			while true do
				if (((2360 - (341 + 138)) > (350 + 943)) and ((0 - 0) == v149)) then
					if (((2683 - (89 + 237)) == (7582 - 5225)) and (v33 == "Refreshing Healing Potion")) then
						if (((258 - 135) == (1004 - (581 + 300))) and v85.RefreshingHealingPotion:IsReady()) then
							if (v10.Press(v86.RefreshingHealingPotion) or ((2276 - (855 + 365)) >= (8056 - 4664))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((353 + 728) < (2310 - (1030 + 205)))) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((985 + 64) >= (4123 + 309))) then
							if (v10.Press(v86.RefreshingHealingPotion) or ((5054 - (156 + 130)) <= (1922 - 1076))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if ((v84.Feint:IsCastable() and v84.Feint:IsReady() and (v16:HealthPercentage() <= v58)) or ((5659 - 2301) <= (2908 - 1488))) then
			if (v10.Cast(v84.Feint) or ((986 + 2753) <= (1753 + 1252))) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v16:HealthPercentage() <= v80)) or ((1728 - (10 + 59)) >= (604 + 1530))) then
			if (v10.Cast(v84.Evasion) or ((16054 - 12794) < (3518 - (671 + 492)))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if ((not v16:IsCasting() and not v16:IsChanneling()) or ((533 + 136) == (5438 - (369 + 846)))) then
			local v150 = v82.Interrupt(v84.Kick, 3 + 5, true);
			if (v150 or ((1444 + 248) < (2533 - (1036 + 909)))) then
				return v150;
			end
			v150 = v82.Interrupt(v84.Kick, 7 + 1, true, v13, v86.KickMouseover);
			if (v150 or ((8053 - 3256) < (3854 - (11 + 192)))) then
				return v150;
			end
			v150 = v82.Interrupt(v84.Blind, 8 + 7, v79);
			if (v150 or ((4352 - (135 + 40)) > (11750 - 6900))) then
				return v150;
			end
			v150 = v82.Interrupt(v84.Blind, 10 + 5, v79, v13, v86.BlindMouseover);
			if (v150 or ((881 - 481) > (1665 - 554))) then
				return v150;
			end
			v150 = v82.InterruptWithStun(v84.CheapShot, 184 - (50 + 126), v16:StealthUp(false, false));
			if (((8495 - 5444) > (223 + 782)) and v150) then
				return v150;
			end
			v150 = v82.InterruptWithStun(v84.KidneyShot, 1421 - (1233 + 180), v16:ComboPoints() > (969 - (522 + 447)));
			if (((5114 - (107 + 1314)) <= (2034 + 2348)) and v150) then
				return v150;
			end
		end
		if ((not v16:AffectingCombat() and not v16:IsMounted() and v59) or ((10000 - 6718) > (1742 + 2358))) then
			v94 = v83.Stealth(v84.Stealth2, nil);
			if (v94 or ((7109 - 3529) < (11252 - 8408))) then
				return "Stealth (OOC): " .. v94;
			end
		end
		if (((1999 - (716 + 1194)) < (77 + 4413)) and not v16:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v17:IsInRange(511 - (74 + 429)) and v27) then
			if ((v82.TargetIsValid() and v17:IsInRange(19 - 9) and not (v16:IsChanneling() or v16:IsCasting())) or ((2470 + 2513) < (4138 - 2330))) then
				local v173 = 0 + 0;
				while true do
					if (((11804 - 7975) > (9318 - 5549)) and (v173 == (433 - (279 + 154)))) then
						if (((2263 - (454 + 324)) <= (2285 + 619)) and v84.BladeFlurry:IsReady() and v16:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v16:BuffUp(v84.AdrenalineRush))) then
							if (((4286 - (12 + 5)) == (2302 + 1967)) and v12(v84.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((986 - 599) <= (1029 + 1753)) and not v16:StealthUp(true, false)) then
							local v190 = 1093 - (277 + 816);
							while true do
								if ((v190 == (0 - 0)) or ((3082 - (1058 + 125)) <= (172 + 745))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (v94 or ((5287 - (815 + 160)) <= (3758 - 2882))) then
										return v94;
									end
									break;
								end
							end
						end
						v173 = 2 - 1;
					end
					if (((533 + 1699) <= (7588 - 4992)) and (v173 == (1899 - (41 + 1857)))) then
						if (((3988 - (1222 + 671)) < (9526 - 5840)) and v82.TargetIsValid()) then
							local v191 = 0 - 0;
							while true do
								if ((v191 == (1182 - (229 + 953))) or ((3369 - (1111 + 663)) >= (6053 - (874 + 705)))) then
									if ((v84.RolltheBones:IsReady() and not v16:DebuffUp(v84.Dreadblades) and ((v111() == (0 + 0)) or v112())) or ((3152 + 1467) < (5989 - 3107))) then
										if (v10.Cast(v84.RolltheBones) or ((9 + 285) >= (5510 - (642 + 37)))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if (((463 + 1566) <= (494 + 2590)) and v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (4 - 2))) then
										if (v10.Cast(v84.AdrenalineRush) or ((2491 - (233 + 221)) == (5596 - 3176))) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									v191 = 1 + 0;
								end
								if (((5999 - (718 + 823)) > (2457 + 1447)) and (v191 == (807 - (266 + 539)))) then
									if (((1234 - 798) >= (1348 - (636 + 589))) and v84.SinisterStrike:IsCastable()) then
										if (((1186 - 686) < (3745 - 1929)) and v10.Cast(v84.SinisterStrike)) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if (((2833 + 741) == (1299 + 2275)) and (v191 == (1016 - (657 + 358)))) then
									if (((584 - 363) < (888 - 498)) and v84.SliceandDice:IsReady() and (v16:BuffRemains(v84.SliceandDice) < (((1188 - (1151 + 36)) + v97) * (1.8 + 0)))) then
										if (v10.Press(v84.SliceandDice) or ((582 + 1631) <= (4243 - 2822))) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (((4890 - (1552 + 280)) < (5694 - (64 + 770))) and v16:StealthUp(true, false)) then
										v94 = v122();
										if (v94 or ((880 + 416) >= (10092 - 5646))) then
											return "Stealth (Opener): " .. v94;
										end
										if ((v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) or ((248 + 1145) > (5732 - (157 + 1086)))) then
											if (v10.Press(v84.GhostlyStrike) or ((8854 - 4430) < (118 - 91))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (v84.Ambush:IsCastable() or ((3063 - 1066) > (5206 - 1391))) then
											if (((4284 - (599 + 220)) > (3808 - 1895)) and v10.Cast(v84.Ambush)) then
												return "Cast Ambush (Opener)";
											end
										end
									elseif (((2664 - (1813 + 118)) < (1330 + 489)) and v113()) then
										local v201 = 1217 - (841 + 376);
										while true do
											if (((0 - 0) == v201) or ((1021 + 3374) == (12978 - 8223))) then
												v94 = v123();
												if (v94 or ((4652 - (464 + 395)) < (6079 - 3710))) then
													return "Finish (Opener): " .. v94;
												end
												break;
											end
										end
									end
									v191 = 1 + 1;
								end
							end
						end
						return;
					end
				end
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) or ((4921 - (467 + 370)) == (547 - 282))) then
			v97 = v26(v97, v83.FanTheHammerCP());
		end
		if (((3200 + 1158) == (14939 - 10581)) and v82.TargetIsValid()) then
			v94 = v121();
			if (v94 or ((490 + 2648) < (2309 - 1316))) then
				return "CDs: " .. v94;
			end
			if (((3850 - (150 + 370)) > (3605 - (74 + 1208))) and (v16:StealthUp(true, true) or v16:BuffUp(v84.Shadowmeld))) then
				local v174 = 0 - 0;
				while true do
					if ((v174 == (0 - 0)) or ((2581 + 1045) == (4379 - (14 + 376)))) then
						v94 = v122();
						if (v94 or ((1588 - 672) == (1729 + 942))) then
							return "Stealth: " .. v94;
						end
						break;
					end
				end
			end
			if (((239 + 33) == (260 + 12)) and v113()) then
				v94 = v123();
				if (((12450 - 8201) <= (3641 + 1198)) and v94) then
					return "Finish: " .. v94;
				end
			end
			v94 = v124();
			if (((2855 - (23 + 55)) < (7583 - 4383)) and v94) then
				return "Build: " .. v94;
			end
			if (((64 + 31) < (1758 + 199)) and v84.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike) and (v101 > ((23 - 8) + v100))) then
				if (((260 + 566) < (2618 - (652 + 249))) and v10.Cast(v84.ArcaneTorrent, v30)) then
					return "Cast Arcane Torrent";
				end
			end
			if (((3816 - 2390) >= (2973 - (708 + 1160))) and v84.ArcanePulse:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) then
				if (((7475 - 4721) <= (6160 - 2781)) and v10.Cast(v84.ArcanePulse)) then
					return "Cast Arcane Pulse";
				end
			end
			if ((v84.LightsJudgment:IsCastable() and v17:IsInMeleeRange(32 - (10 + 17))) or ((883 + 3044) == (3145 - (1400 + 332)))) then
				if (v10.Cast(v84.LightsJudgment, v30) or ((2213 - 1059) <= (2696 - (242 + 1666)))) then
					return "Cast Lights Judgment";
				end
			end
			if ((v84.BagofTricks:IsCastable() and v17:IsInMeleeRange(3 + 2)) or ((603 + 1040) > (2880 + 499))) then
				if (v10.Cast(v84.BagofTricks, v30) or ((3743 - (850 + 90)) > (7966 - 3417))) then
					return "Cast Bag of Tricks";
				end
			end
			if ((v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and not v17:IsInRange(1396 - (360 + 1030)) and not v16:StealthUp(true, true) and (v101 < (23 + 2)) and ((v98 >= (2 - 1)) or (v102 <= (1.2 - 0)))) or ((1881 - (909 + 752)) >= (4245 - (109 + 1114)))) then
				if (((5166 - 2344) == (1099 + 1723)) and v10.Cast(v84.PistolShot)) then
					return "Cast Pistol Shot (OOR)";
				end
			end
			if (v84.SinisterStrike:IsCastable() or ((1303 - (6 + 236)) == (1170 + 687))) then
				if (((2222 + 538) > (3216 - 1852)) and v10.Cast(v84.SinisterStrike)) then
					return "Cast Sinister Strike Filler";
				end
			end
		end
	end
	local function v126()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(454 - 194, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

