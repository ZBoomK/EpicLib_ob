local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((2518 + 178) >= (3189 + 1343))) then
			v6 = v0[v4];
			if (((1174 - (55 + 71)) >= (67 - 15)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1791 - (573 + 1217);
		end
		if (((8191 - 5233) < (343 + 4160)) and (v5 == (1 - 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Macro;
	local v20 = v10.Commons.Everyone.num;
	local v21 = v10.Commons.Everyone.bool;
	local v22 = math.min;
	local v23 = math.abs;
	local v24 = math.max;
	local v25 = false;
	local v26 = false;
	local v27 = false;
	local v28;
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
	local function v78()
		local v125 = 939 - (714 + 225);
		while true do
			if ((v125 == (8 - 5)) or ((3812 - 1077) == (142 + 1167))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v57 = EpicSettings.Settings['FeintHP'] or (806 - (118 + 688));
				v125 = 52 - (25 + 23);
			end
			if ((v125 == (1 + 1)) or ((6016 - (927 + 959)) <= (9961 - 7006))) then
				v37 = EpicSettings.Settings['InterruptThreshold'] or (732 - (16 + 716));
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v125 = 5 - 2;
			end
			if ((v125 == (97 - (11 + 86))) or ((4790 - 2826) <= (1625 - (175 + 110)))) then
				v28 = EpicSettings.Settings['UseRacials'];
				v30 = EpicSettings.Settings['UseHealingPotion'];
				v31 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v32 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v125 = 1797 - (503 + 1293);
			end
			if (((6979 - 4480) == (1808 + 691)) and (v125 == (1067 - (810 + 251)))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				break;
			end
			if ((v125 == (1 + 0)) or ((693 + 1562) < (20 + 2))) then
				v33 = EpicSettings.Settings['UseHealthstone'];
				v34 = EpicSettings.Settings['HealthstoneHP'] or (533 - (43 + 490));
				v35 = EpicSettings.Settings['InterruptWithStun'] or (733 - (711 + 22));
				v36 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v125 = 861 - (240 + 619);
			end
			if ((v125 == (2 + 3)) or ((1727 - 641) >= (93 + 1312))) then
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v125 = 1750 - (1344 + 400);
			end
			if ((v125 == (409 - (255 + 150))) or ((1867 + 502) == (229 + 197))) then
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'];
				v125 = 21 - 16;
			end
		end
	end
	local v79 = v10.Commons.Everyone;
	local v80 = v10.Commons.Rogue;
	local v81 = v16.Rogue.Outlaw;
	local v82 = v18.Rogue.Outlaw;
	local v83 = v19.Rogue.Outlaw;
	local v84 = {v82.ManicGrieftorch:ID(),v82.DragonfireBombDispenser:ID(),v82.BeaconToTheBeyond:ID()};
	local v85 = v14:GetEquipment();
	local v86 = (v85[15 - 2] and v18(v85[9 + 4])) or v18(0 + 0);
	local v87 = (v85[351 - (10 + 327)] and v18(v85[10 + 4])) or v18(338 - (118 + 220));
	v10:RegisterForEvent(function()
		v85 = v14:GetEquipment();
		v86 = (v85[5 + 8] and v18(v85[462 - (108 + 341)])) or v18(0 + 0);
		v87 = (v85[59 - 45] and v18(v85[1507 - (711 + 782)])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v81.Dispatch:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v80.CPSpend() * (469.3 - (270 + 199)) * (1 + 0) * ((1820 - (580 + 1239)) + (v14:VersatilityDmgPct() / (297 - 197))) * ((v15:DebuffUp(v81.GhostlyStrike) and (1.1 + 0)) or (1 + 0));
	end);
	local v88, v89, v90;
	local v91;
	local v92 = 3 + 3;
	local v93;
	local v94, v95, v96;
	local v97, v98, v99, v100, v101;
	local v102 = {{v81.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v103, v104 = 0 + 0, 0 - 0;
	local function v105(v126)
		local v127 = v14:EnergyTimeToMaxPredicted(nil, v126);
		if ((v127 < v103) or ((v127 - v103) > (0.5 - 0)) or ((4912 - (1045 + 791)) > (8056 - 4873))) then
			v103 = v127;
		end
		return v103;
	end
	local function v106()
		local v128 = 0 - 0;
		local v129;
		while true do
			if (((1707 - (351 + 154)) > (2632 - (1281 + 293))) and (v128 == (266 - (28 + 238)))) then
				v129 = v14:EnergyPredicted();
				if (((8291 - 4580) > (4914 - (1381 + 178))) and ((v129 > v104) or ((v129 - v104) > (9 + 0)))) then
					v104 = v129;
				end
				v128 = 1 + 0;
			end
			if ((v128 == (1 + 0)) or ((3123 - 2217) >= (1155 + 1074))) then
				return v104;
			end
		end
	end
	local v107 = {v81.Broadside,v81.BuriedTreasure,v81.GrandMelee,v81.RuthlessPrecision,v81.SkullandCrossbones,v81.TrueBearing};
	local function v108(v130, v131)
		if (((3072 - (214 + 1570)) > (2706 - (990 + 465))) and not v11.APLVar.RtB_List) then
			v11.APLVar.RtB_List = {};
		end
		if (not v11.APLVar.RtB_List[v130] or ((1861 + 2652) < (1459 + 1893))) then
			v11.APLVar.RtB_List[v130] = {};
		end
		local v132 = table.concat(v131);
		if ((v130 == "All") or ((2009 + 56) >= (12577 - 9381))) then
			if (not v11.APLVar.RtB_List[v130][v132] or ((6102 - (1668 + 58)) <= (2107 - (512 + 114)))) then
				local v161 = 0 - 0;
				local v162;
				while true do
					if ((v161 == (1 - 0)) or ((11802 - 8410) >= (2206 + 2535))) then
						v11.APLVar.RtB_List[v130][v132] = ((v162 == #v131) and true) or false;
						break;
					end
					if (((623 + 2702) >= (1873 + 281)) and ((0 - 0) == v161)) then
						v162 = 1994 - (109 + 1885);
						for v178 = 1470 - (1269 + 200), #v131 do
							if (v14:BuffUp(v107[v131[v178]]) or ((2482 - 1187) >= (4048 - (98 + 717)))) then
								v162 = v162 + (827 - (802 + 24));
							end
						end
						v161 = 1 - 0;
					end
				end
			end
		elseif (((5527 - 1150) > (243 + 1399)) and not v11.APLVar.RtB_List[v130][v132]) then
			v11.APLVar.RtB_List[v130][v132] = false;
			for v165 = 1 + 0, #v131 do
				if (((776 + 3947) > (293 + 1063)) and v14:BuffUp(v107[v131[v165]])) then
					v11.APLVar.RtB_List[v130][v132] = true;
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v130][v132];
	end
	local function v109()
		local v133 = 0 - 0;
		while true do
			if (((0 - 0) == v133) or ((1480 + 2656) <= (1398 + 2035))) then
				if (((3502 + 743) <= (3368 + 1263)) and not v11.APLVar.RtB_Buffs) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Total = 0 + 0;
					v11.APLVar.RtB_Buffs.Normal = 1433 - (797 + 636);
					v11.APLVar.RtB_Buffs.Shorter = 0 - 0;
					v11.APLVar.RtB_Buffs.Longer = 1619 - (1427 + 192);
					local v171 = v80.RtBRemains();
					for v172 = 1 + 0, #v107 do
						local v173 = 0 - 0;
						local v174;
						while true do
							if (((3844 + 432) >= (1774 + 2140)) and ((326 - (192 + 134)) == v173)) then
								v174 = v14:BuffRemains(v107[v172]);
								if (((1474 - (316 + 960)) <= (2430 + 1935)) and (v174 > (0 + 0))) then
									local v181 = 0 + 0;
									while true do
										if (((18281 - 13499) > (5227 - (83 + 468))) and (v181 == (1806 - (1202 + 604)))) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (4 - 3);
											if (((8095 - 3231) > (6082 - 3885)) and (v174 == v171)) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (326 - (45 + 280));
											elseif ((v174 > v171) or ((3572 + 128) == (2191 + 316))) then
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
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v110()
		local v134 = 0 + 0;
		while true do
			if (((8284 - 3810) >= (2185 - (340 + 1571))) and (v134 == (0 + 0))) then
				if (not v11.APLVar.RtB_Reroll or ((3666 - (1733 + 39)) <= (3863 - 2457))) then
					if (((2606 - (125 + 909)) >= (3479 - (1096 + 852))) and (v63 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v109() <= (0 + 0)) and true) or false;
					elseif ((v63 == "Broadside") or ((6693 - 2006) < (4406 + 136))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.Broadside) and true) or false;
					elseif (((3803 - (409 + 103)) > (1903 - (46 + 190))) and (v63 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.BuriedTreasure) and true) or false;
					elseif ((v63 == "Grand Melee") or ((968 - (51 + 44)) == (574 + 1460))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((4133 - (1114 + 203)) < (737 - (228 + 498)))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.SkullandCrossbones) and true) or false;
					elseif (((802 + 2897) < (2600 + 2106)) and (v63 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.RuthlessPrecision) and true) or false;
					elseif (((3309 - (174 + 489)) >= (2282 - 1406)) and (v63 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.TrueBearing) and true) or false;
					else
						local v192 = 1905 - (830 + 1075);
						while true do
							if (((1138 - (303 + 221)) <= (4453 - (231 + 1038))) and (v192 == (1 + 0))) then
								if (((4288 - (171 + 991)) == (12882 - 9756)) and (v109() <= (5 - 3)) and v14:BuffUp(v81.BuriedTreasure) and v14:BuffDown(v81.GrandMelee) and (v90 < (4 - 2))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:HasTier(25 + 6, 13 - 9) and ((not v14:BuffUp(v81.TrueBearing) and v81.HiddenOpportunity:IsAvailable()) or (not v14:BuffUp(v81.Broadside) and not v81.HiddenOpportunity:IsAvailable())) and (v109() <= (2 - 1))) or ((3524 - 1337) >= (15313 - 10359))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v192 = 1250 - (111 + 1137);
							end
							if ((v192 == (160 - (91 + 67))) or ((11538 - 7661) == (892 + 2683))) then
								if (((1230 - (423 + 100)) > (5 + 627)) and v81.Crackshot:IsAvailable() and v14:HasTier(85 - 54, 3 + 1) and (v109() <= ((772 - (326 + 445)) + v20(v14:BuffUp(v81.LoadedDiceBuff)))) and (v81.HiddenOpportunity:IsAvailable() or v14:BuffDown(v81.Broadside))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((not v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:BuffUp(v81.SkullandCrossbones) and (v109() < ((8 - 6) + v20(v14:BuffUp(v81.GrandMelee)))) and (v90 < (4 - 2))) or ((1273 - 727) >= (3395 - (530 + 181)))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v192 = 884 - (614 + 267);
							end
							if (((1497 - (19 + 13)) <= (7000 - 2699)) and (v192 == (6 - 3))) then
								if (((4867 - 3163) > (371 + 1054)) and (v11.APLVar.RtB_Reroll or ((v11.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v109() < (1817 - (1293 + 519))) and (v80.RtBRemains() <= (79 - 40))))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if (v15:FilteredTimeToDie("<", 31 - 19) or v10.BossFilteredFightRemains("<", 22 - 10) or ((2962 - 2275) == (9974 - 5740))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if ((v192 == (0 + 0)) or ((680 + 2650) < (3319 - 1890))) then
								v11.APLVar.RtB_Reroll = false;
								v109();
								v192 = 1 + 0;
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v111()
		return v94 >= ((v80.CPMaxSpend() - (1 + 0)) - v20((v14:StealthUp(true, true)) and v81.Crackshot:IsAvailable()));
	end
	local function v112()
		return (v81.HiddenOpportunity:IsAvailable() or (v96 >= (2 + 0 + v20(v81.ImprovedAmbush:IsAvailable()) + v20(v14:BuffUp(v81.Broadside))))) and (v97 >= (1146 - (709 + 387)));
	end
	local function v113()
		return not v26 or (v90 < (1860 - (673 + 1185))) or (v14:BuffRemains(v81.BladeFlurry) > ((2 - 1) + v20(v81.KillingSpree:IsAvailable())));
	end
	local function v114()
		return v66 and (not v14:IsTanking(v15) or v76);
	end
	local function v115()
		return not v81.ShadowDanceTalent:IsAvailable() and ((v81.FanTheHammer:TalentRank() + v20(v81.QuickDraw:IsAvailable()) + v20(v81.Audacity:IsAvailable())) < (v20(v81.CountTheOdds:IsAvailable()) + v20(v81.KeepItRolling:IsAvailable())));
	end
	local function v116()
		return v14:BuffUp(v81.BetweentheEyes) and (not v81.HiddenOpportunity:IsAvailable() or (v14:BuffDown(v81.AudacityBuff) and ((v81.FanTheHammer:TalentRank() < (6 - 4)) or v14:BuffDown(v81.Opportunity)))) and not v81.Crackshot:IsAvailable();
	end
	local function v117()
		if (((1886 - 739) >= (240 + 95)) and v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and v81.HiddenOpportunity:IsAvailable() and not v81.Crackshot:IsAvailable() and not v14:BuffUp(v81.Audacity) and (v115() or (v14:BuffStack(v81.Opportunity) < (5 + 1))) and v112()) then
			if (((4637 - 1202) > (516 + 1581)) and v10.Cast(v81.Vanish, v66)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and (not v81.HiddenOpportunity:IsAvailable() or v81.Crackshot:IsAvailable()) and v111()) or ((7517 - 3747) >= (7932 - 3891))) then
			if (v10.Cast(v81.Vanish, v66) or ((5671 - (446 + 1434)) <= (2894 - (1040 + 243)))) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.Crackshot:IsAvailable() and v111()) or ((13663 - 9085) <= (3855 - (559 + 1288)))) then
			if (((3056 - (609 + 1322)) <= (2530 - (13 + 441))) and v10.Cast(v81.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and not v81.KeepItRolling:IsAvailable() and v116() and v14:BuffUp(v81.SliceandDice) and (v111() or v81.HiddenOpportunity:IsAvailable()) and (not v81.HiddenOpportunity:IsAvailable() or not v81.Vanish:IsReady())) or ((2776 - 2033) >= (11522 - 7123))) then
			if (((5752 - 4597) < (63 + 1610)) and v10.Cast(v81.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.KeepItRolling:IsAvailable() and v116() and ((v81.KeepItRolling:CooldownRemains() <= (108 - 78)) or ((v81.KeepItRolling:CooldownRemains() >= (43 + 77)) and (v111() or v81.HiddenOpportunity:IsAvailable())))) or ((1019 + 1305) <= (1715 - 1137))) then
			if (((2062 + 1705) == (6928 - 3161)) and v10.Cast(v81.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if (((2704 + 1385) == (2275 + 1814)) and v81.Shadowmeld:IsAvailable() and v81.Shadowmeld:IsReady()) then
			if (((3204 + 1254) >= (1406 + 268)) and ((v81.Crackshot:IsAvailable() and v111()) or (not v81.Crackshot:IsAvailable() and ((v81.CountTheOdds:IsAvailable() and v111()) or v81.HiddenOpportunity:IsAvailable())))) then
				if (((951 + 21) <= (1851 - (153 + 280))) and v10.Cast(v81.Shadowmeld, v28)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v118()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (0 + 0)) or ((1950 + 2988) < (2493 + 2269))) then
				v91 = v79.HandleTopTrinket(v84, v27, 37 + 3, nil);
				if (v91 or ((1815 + 689) > (6492 - 2228))) then
					return v91;
				end
				v135 = 1 + 0;
			end
			if (((2820 - (89 + 578)) == (1539 + 614)) and (v135 == (1 - 0))) then
				v91 = v79.HandleBottomTrinket(v84, v27, 1089 - (572 + 477), nil);
				if (v91 or ((69 + 438) >= (1555 + 1036))) then
					return v91;
				end
				break;
			end
		end
	end
	local function v119()
		if (((535 + 3946) == (4567 - (84 + 2))) and v27 and v81.AdrenalineRush:IsCastable() and (not v14:BuffUp(v81.AdrenalineRush) or (v14:StealthUp(true, true) and v81.Crackshot:IsAvailable() and v81.ImprovedAdrenalineRush:IsAvailable())) and ((v95 <= (2 - 0)) or not v81.ImprovedAdrenalineRush:IsAvailable())) then
			if (v10.Cast(v81.AdrenalineRush) or ((1678 + 650) < (1535 - (497 + 345)))) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((111 + 4217) == (732 + 3596)) and ((v81.BladeFlurry:IsReady() and (v90 >= ((1335 - (605 + 728)) - v20(v81.UnderhandedUpperhand:IsAvailable()))) and (v14:BuffRemains(v81.BladeFlurry) < v14:GCDRemains())) or (v81.DeftManeuvers:IsAvailable() and (v90 >= (4 + 1)) and not v111()))) then
			if (((3530 - 1942) >= (62 + 1270)) and v69) then
				v10.CastSuggested(v81.BladeFlurry);
			elseif (v10.Cast(v81.BladeFlurry) or ((15432 - 11258) > (3830 + 418))) then
				return "Cast Blade Flurry";
			end
		end
		if (v81.RolltheBones:IsReady() or ((12705 - 8119) <= (62 + 20))) then
			if (((4352 - (457 + 32)) == (1639 + 2224)) and (v110() or (v80.RtBRemains() <= (v20(v14:HasTier(1433 - (832 + 570), 4 + 0)) + (v20((v81.ShadowDance:CooldownRemains() <= (1 + 0)) or (v81.Vanish:CooldownRemains() <= (3 - 2))) * (3 + 3)))))) then
				if (v10.Cast(v81.RolltheBones) or ((1078 - (588 + 208)) <= (113 - 71))) then
					return "Cast Roll the Bones";
				end
			end
		end
		if (((6409 - (884 + 916)) >= (1603 - 837)) and v81.KeepItRolling:IsReady() and not v110() and (v109() >= (2 + 1 + v20(v14:HasTier(684 - (232 + 421), 1893 - (1569 + 320))))) and (v14:BuffDown(v81.ShadowDance) or (v109() >= (2 + 4)))) then
			if (v10.Cast(v81.KeepItRolling) or ((219 + 933) == (8383 - 5895))) then
				return "Cast Keep it Rolling";
			end
		end
		if (((4027 - (316 + 289)) > (8769 - 5419)) and v81.GhostlyStrike:IsAvailable() and v81.GhostlyStrike:IsReady()) then
			if (((41 + 836) > (1829 - (666 + 787))) and v10.Cast(v81.GhostlyStrike)) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v27 and v81.Sepsis:IsAvailable() and v81.Sepsis:IsReady()) or ((3543 - (360 + 65)) <= (1730 + 121))) then
			if ((v81.Crackshot:IsAvailable() and v81.BetweentheEyes:IsReady() and v111() and not v14:StealthUp(true, true)) or (not v81.Crackshot:IsAvailable() and v15:FilteredTimeToDie(">", 265 - (79 + 175)) and v14:BuffUp(v81.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 17 - 6) or ((129 + 36) >= (10703 - 7211))) then
				if (((7604 - 3655) < (5755 - (503 + 396))) and v10.Cast(v81.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v81.BladeRush:IsReady() and (v100 > (185 - (92 + 89))) and not v14:StealthUp(true, true)) or ((8294 - 4018) < (1547 + 1469))) then
			if (((2776 + 1914) > (16154 - 12029)) and v10.Cast(v81.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (not v14:StealthUp(true, true, true) or ((7 + 43) >= (2042 - 1146))) then
			v91 = v117();
			if (v91 or ((1496 + 218) >= (1413 + 1545))) then
				return v91;
			end
		end
		if ((v27 and v81.ThistleTea:IsAvailable() and v81.ThistleTea:IsCastable() and not v14:BuffUp(v81.ThistleTea) and ((v99 >= (304 - 204)) or v10.BossFilteredFightRemains("<", v81.ThistleTea:Charges() * (1 + 5)))) or ((2273 - 782) < (1888 - (485 + 759)))) then
			if (((1628 - 924) < (2176 - (442 + 747))) and v10.Cast(v81.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((4853 - (832 + 303)) > (2852 - (88 + 858))) and v81.BloodFury:IsCastable()) then
			if (v10.Cast(v81.BloodFury, v28) or ((292 + 666) > (3009 + 626))) then
				return "Cast Blood Fury";
			end
		end
		if (((145 + 3356) <= (5281 - (766 + 23))) and v81.Berserking:IsCastable()) then
			if (v10.Cast(v81.Berserking, v28) or ((16992 - 13550) < (3484 - 936))) then
				return "Cast Berserking";
			end
		end
		if (((7574 - 4699) >= (4968 - 3504)) and v81.Fireblood:IsCastable()) then
			if (v10.Cast(v81.Fireblood, v28) or ((5870 - (1036 + 37)) >= (3470 + 1423))) then
				return "Cast Fireblood";
			end
		end
		if (v81.AncestralCall:IsCastable() or ((1072 - 521) > (1627 + 441))) then
			if (((3594 - (641 + 839)) > (1857 - (910 + 3))) and v10.Cast(v81.AncestralCall, v28)) then
				return "Cast Ancestral Call";
			end
		end
		v91 = v118();
		if (v91 or ((5766 - 3504) >= (4780 - (1466 + 218)))) then
			return v91;
		end
	end
	local function v120()
		if ((v81.BladeFlurry:IsReady() and v81.BladeFlurry:IsCastable() and v26 and v81.Subterfuge:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and (v90 >= (1 + 1)) and (v14:BuffRemains(v81.BladeFlurry) <= v14:GCDRemains())) or ((3403 - (556 + 592)) >= (1258 + 2279))) then
			if (v69 or ((4645 - (329 + 479)) < (2160 - (174 + 680)))) then
				v10.Press(v81.BladeFlurry);
			elseif (((10136 - 7186) == (6114 - 3164)) and v10.Press(v81.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if ((v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch) and v111()) or ((3373 + 1350) < (4037 - (396 + 343)))) then
			if (((101 + 1035) >= (1631 - (29 + 1448))) and v10.Cast(v81.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if ((v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v111() and v81.Crackshot:IsAvailable()) or ((1660 - (135 + 1254)) > (17886 - 13138))) then
			if (((22131 - 17391) >= (2101 + 1051)) and v10.Press(v81.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch) and v111()) or ((4105 - (389 + 1138)) >= (3964 - (102 + 472)))) then
			if (((39 + 2) <= (922 + 739)) and v10.Press(v81.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((561 + 40) < (5105 - (320 + 1225))) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and v81.Crackshot:IsAvailable() and (v81.FanTheHammer:TalentRank() >= (2 - 0)) and (v14:BuffStack(v81.Opportunity) >= (4 + 2)) and ((v14:BuffUp(v81.Broadside) and (v95 <= (1465 - (157 + 1307)))) or v14:BuffUp(v81.GreenskinsWickersBuff))) then
			if (((2094 - (821 + 1038)) < (1713 - 1026)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((498 + 4051) > (2047 - 894)) and v81.Ambush:IsCastable() and v15:IsSpellInRange(v81.Ambush) and v81.HiddenOpportunity:IsAvailable()) then
			if (v10.Press(v81.Ambush) or ((1739 + 2935) < (11579 - 6907))) then
				return "Cast Ambush";
			end
		end
	end
	local function v121()
		if (((4694 - (834 + 192)) < (290 + 4271)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and not v81.Crackshot:IsAvailable() and ((v14:BuffRemains(v81.BetweentheEyes) < (2 + 2)) or v81.ImprovedBetweenTheEyes:IsAvailable() or v81.GreenskinsWickers:IsAvailable() or v14:HasTier(1 + 29, 5 - 1)) and v14:BuffDown(v81.GreenskinsWickers)) then
			if (v10.Press(v81.BetweentheEyes) or ((759 - (300 + 4)) == (963 + 2642))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v81.Crackshot:IsAvailable() and (v81.Vanish:CooldownRemains() > (117 - 72)) and (v81.ShadowDance:CooldownRemains() > (374 - (112 + 250)))) or ((1062 + 1601) == (8297 - 4985))) then
			if (((2451 + 1826) <= (2315 + 2160)) and v10.Press(v81.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v81.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v89, ">", v14:BuffRemains(v81.SliceandDice), true) or (v14:BuffRemains(v81.SliceandDice) == (0 + 0))) and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v95) * (1.8 + 0)))) or ((2284 - (1001 + 413)) == (2651 - 1462))) then
			if (((2435 - (244 + 638)) <= (3826 - (627 + 66))) and v10.Press(v81.SliceandDice)) then
				return "Cast Slice and Dice";
			end
		end
		if ((v81.KillingSpree:IsCastable() and v15:IsSpellInRange(v81.KillingSpree) and (v15:DebuffUp(v81.GhostlyStrike) or not v81.GhostlyStrike:IsAvailable())) or ((6665 - 4428) >= (4113 - (512 + 90)))) then
			if (v10.Cast(v81.KillingSpree) or ((3230 - (1665 + 241)) > (3737 - (373 + 344)))) then
				return "Cast Killing Spree";
			end
		end
		if ((v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch)) or ((1350 + 1642) == (498 + 1383))) then
			if (((8192 - 5086) > (2581 - 1055)) and v10.Cast(v81.ColdBlood, v54)) then
				return "Cast Cold Blood";
			end
		end
		if (((4122 - (35 + 1064)) < (2816 + 1054)) and v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch)) then
			if (((305 - 162) > (1 + 73)) and v10.Press(v81.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v122()
		if (((1254 - (298 + 938)) < (3371 - (233 + 1026))) and v27 and v81.EchoingReprimand:IsReady()) then
			if (((2763 - (636 + 1030)) <= (833 + 795)) and v10.Cast(v81.EchoingReprimand, nil, v75)) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((4523 + 107) == (1376 + 3254)) and v81.Ambush:IsCastable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.AudacityBuff)) then
			if (((240 + 3300) > (2904 - (55 + 166))) and v10.Press(v81.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((930 + 3864) >= (330 + 2945)) and v81.FanTheHammer:IsAvailable() and v81.Audacity:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.Opportunity) and v14:BuffDown(v81.AudacityBuff)) then
			if (((5667 - 4183) == (1781 - (36 + 261))) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if (((2503 - 1071) < (4923 - (34 + 1334))) and v14:BuffUp(v81.GreenskinsWickersBuff) and ((not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity)) or (v14:BuffRemains(v81.GreenskinsWickersBuff) < (1.5 + 0)))) then
			if (v10.Press(v81.PistolShot) or ((828 + 237) > (4861 - (1035 + 248)))) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v14:BuffStack(v81.Opportunity) >= (27 - (20 + 1))) or (v14:BuffRemains(v81.Opportunity) < (2 + 0)))) or ((5114 - (134 + 185)) < (2540 - (549 + 584)))) then
			if (((2538 - (314 + 371)) < (16522 - 11709)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and (v96 > ((969 - (478 + 490)) + (v20(v81.QuickDraw:IsAvailable()) * v81.FanTheHammer:TalentRank()))) and ((not v81.Vanish:IsReady() and not v81.ShadowDance:IsReady()) or v14:StealthUp(true, true) or not v81.Crackshot:IsAvailable() or (v81.FanTheHammer:TalentRank() <= (1 + 0)))) or ((3993 - (786 + 386)) < (7873 - 5442))) then
			if (v10.Press(v81.PistolShot) or ((4253 - (1055 + 324)) < (3521 - (1093 + 247)))) then
				return "Cast Pistol Shot";
			end
		end
		if ((not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v100 > (1.5 + 0)) or (v96 <= (1 + 0 + v20(v14:BuffUp(v81.Broadside)))) or v81.QuickDraw:IsAvailable() or (v81.Audacity:IsAvailable() and v14:BuffDown(v81.AudacityBuff)))) or ((10675 - 7986) <= (1163 - 820))) then
			if (v10.Press(v81.PistolShot) or ((5317 - 3448) == (5048 - 3039))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v81.SinisterStrike:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) or ((1262 + 2284) < (8945 - 6623))) then
			if (v10.Press(v81.SinisterStrike) or ((7176 - 5094) == (3599 + 1174))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v123()
		v78();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v92 = (v81.AcrobaticStrikes:IsAvailable() and (25 - 15)) or (694 - (364 + 324));
		v95 = v14:ComboPoints();
		v94 = v80.EffectiveComboPoints(v95);
		v96 = v14:ComboPointsDeficit();
		v101 = (v14:BuffUp(v81.AdrenalineRush, nil, true) and -(137 - 87)) or (0 - 0);
		v97 = v106();
		v98 = v14:EnergyRegen();
		v100 = v105(v101);
		v99 = v14:EnergyDeficitPredicted(nil, v101);
		if (((1076 + 2168) > (4414 - 3359)) and v26) then
			v88 = v14:GetEnemiesInRange(48 - 18);
			v89 = v14:GetEnemiesInRange(v92);
			v90 = #v89;
		else
			v90 = 2 - 1;
		end
		v91 = v80.CrimsonVial();
		if (v91 or ((4581 - (1249 + 19)) <= (1605 + 173))) then
			return v91;
		end
		v80.Poisons();
		if ((v82.Healthstone:IsReady() and (v14:HealthPercentage() < v34) and not (v14:IsChanneling() or v14:IsCasting())) or ((5531 - 4110) >= (3190 - (686 + 400)))) then
			if (((1422 + 390) <= (3478 - (73 + 156))) and v10.Cast(v83.Healthstone)) then
				return "Healthstone ";
			end
		end
		if (((8 + 1615) <= (2768 - (721 + 90))) and v82.RefreshingHealingPotion:IsReady() and (v14:HealthPercentage() < v32) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (((50 + 4362) == (14325 - 9913)) and v10.Cast(v83.RefreshingHealingPotion)) then
				return "RefreshingHealingPotion ";
			end
		end
		if (((2220 - (224 + 246)) >= (1363 - 521)) and v81.Feint:IsCastable() and (v14:HealthPercentage() <= v57) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (((8049 - 3677) > (336 + 1514)) and v10.Cast(v81.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((6 + 226) < (604 + 217)) and not v14:AffectingCombat() and not v14:IsMounted() and v58) then
			v91 = v80.Stealth(v81.Stealth2, nil);
			if (((1029 - 511) < (3001 - 2099)) and v91) then
				return "Stealth (OOC): " .. v91;
			end
		end
		if (((3507 - (203 + 310)) > (2851 - (1238 + 755))) and not v14:AffectingCombat() and (v81.Vanish:TimeSinceLastCast() > (1 + 0)) and v15:IsInRange(1542 - (709 + 825)) and v25) then
			if ((v79.TargetIsValid() and v15:IsInRange(18 - 8) and not (v14:IsChanneling() or v14:IsCasting())) or ((5469 - 1714) <= (1779 - (196 + 668)))) then
				local v164 = 0 - 0;
				while true do
					if (((8173 - 4227) > (4576 - (171 + 662))) and (v164 == (93 - (4 + 89)))) then
						if ((v81.BladeFlurry:IsReady() and v14:BuffDown(v81.BladeFlurry) and v81.UnderhandedUpperhand:IsAvailable() and not v14:StealthUp(true, true)) or ((4678 - 3343) >= (1204 + 2102))) then
							if (((21275 - 16431) > (884 + 1369)) and v10.Cast(v81.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((1938 - (35 + 1451)) == (1905 - (28 + 1425))) and not v14:StealthUp(true, false)) then
							v91 = v80.Stealth(v80.StealthSpell());
							if (v91 or ((6550 - (941 + 1052)) < (2002 + 85))) then
								return v91;
							end
						end
						v164 = 1515 - (822 + 692);
					end
					if (((5530 - 1656) == (1825 + 2049)) and ((298 - (45 + 252)) == v164)) then
						if (v79.TargetIsValid() or ((1918 + 20) > (1699 + 3236))) then
							local v180 = 0 - 0;
							while true do
								if ((v180 == (435 - (114 + 319))) or ((6108 - 1853) < (4385 - 962))) then
									if (((927 + 527) <= (3710 - 1219)) and v81.SinisterStrike:IsCastable()) then
										if (v10.Cast(v81.SinisterStrike) or ((8709 - 4552) <= (4766 - (556 + 1407)))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if (((6059 - (741 + 465)) >= (3447 - (170 + 295))) and (v180 == (1 + 0))) then
									if (((3798 + 336) > (8265 - 4908)) and v81.SliceandDice:IsReady() and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v95) * (1.8 + 0)))) then
										if (v10.Press(v81.SliceandDice) or ((1935 + 1482) < (3764 - (957 + 273)))) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v14:StealthUp(true, false) or ((729 + 1993) <= (66 + 98))) then
										v91 = v120();
										if (v91 or ((9175 - 6767) < (5557 - 3448))) then
											return "Stealth (Opener): " .. v91;
										end
										if ((v81.KeepItRolling:IsAvailable() and v81.GhostlyStrike:IsReady() and v81.EchoingReprimand:IsAvailable()) or ((100 - 67) == (7204 - 5749))) then
											if (v10.Press(v81.GhostlyStrike) or ((2223 - (389 + 1391)) >= (2519 + 1496))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (((353 + 3029) > (377 - 211)) and v81.Ambush:IsCastable()) then
											if (v10.Cast(v81.Ambush) or ((1231 - (783 + 168)) == (10266 - 7207))) then
												return "Cast Ambush (Opener)";
											end
										end
									elseif (((1851 + 30) > (1604 - (309 + 2))) and v111()) then
										local v187 = 0 - 0;
										while true do
											if (((3569 - (1090 + 122)) == (765 + 1592)) and (v187 == (0 - 0))) then
												v91 = v121();
												if (((85 + 38) == (1241 - (628 + 490))) and v91) then
													return "Finish (Opener): " .. v91;
												end
												break;
											end
										end
									end
									v180 = 1 + 1;
								end
								if ((v180 == (0 - 0)) or ((4825 - 3769) >= (4166 - (431 + 343)))) then
									if ((v81.AdrenalineRush:IsReady() and v81.ImprovedAdrenalineRush:IsAvailable() and (v95 <= (3 - 1))) or ((3127 - 2046) < (850 + 225))) then
										if (v10.Cast(v81.AdrenalineRush) or ((135 + 914) >= (6127 - (556 + 1139)))) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v81.RolltheBones:IsReady() and not v14:DebuffUp(v81.Dreadblades) and ((v109() == (15 - (6 + 9))) or v110())) or ((873 + 3895) <= (434 + 412))) then
										if (v10.Cast(v81.RolltheBones) or ((3527 - (28 + 141)) <= (551 + 869))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v180 = 1 - 0;
								end
							end
						end
						return;
					end
				end
			end
		end
		if ((v81.FanTheHammer:IsAvailable() and (v81.PistolShot:TimeSinceLastCast() < v14:GCDRemains())) or ((2649 + 1090) <= (4322 - (486 + 831)))) then
			v95 = v24(v95, v80.FanTheHammerCP());
		end
		if (v79.TargetIsValid() or ((4316 - 2657) >= (7512 - 5378))) then
			v91 = v119();
			if (v91 or ((617 + 2643) < (7446 - 5091))) then
				return "CDs: " .. v91;
			end
			if (v14:StealthUp(true, true) or v14:BuffUp(v81.Shadowmeld) or ((1932 - (668 + 595)) == (3800 + 423))) then
				v91 = v120();
				if (v91 or ((342 + 1350) < (1603 - 1015))) then
					return "Stealth: " .. v91;
				end
			end
			if (v111() or ((5087 - (23 + 267)) < (5595 - (1129 + 815)))) then
				v91 = v121();
				if (v91 or ((4564 - (371 + 16)) > (6600 - (1326 + 424)))) then
					return "Finish: " .. v91;
				end
			end
			v91 = v122();
			if (v91 or ((757 - 357) > (4059 - 2948))) then
				return "Build: " .. v91;
			end
			if (((3169 - (88 + 30)) > (1776 - (720 + 51))) and v81.ArcaneTorrent:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike) and (v99 > ((33 - 18) + v98))) then
				if (((5469 - (421 + 1355)) <= (7228 - 2846)) and v10.Cast(v81.ArcaneTorrent, v28)) then
					return "Cast Arcane Torrent";
				end
			end
			if ((v81.ArcanePulse:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) or ((1613 + 1669) > (5183 - (286 + 797)))) then
				if (v10.Cast(v81.ArcanePulse) or ((13087 - 9507) < (4710 - 1866))) then
					return "Cast Arcane Pulse";
				end
			end
			if (((528 - (397 + 42)) < (1403 + 3087)) and v81.LightsJudgment:IsCastable() and v15:IsInMeleeRange(805 - (24 + 776))) then
				if (v10.Cast(v81.LightsJudgment, v28) or ((7676 - 2693) < (2593 - (222 + 563)))) then
					return "Cast Lights Judgment";
				end
			end
			if (((8436 - 4607) > (2714 + 1055)) and v81.BagofTricks:IsCastable() and v15:IsInMeleeRange(195 - (23 + 167))) then
				if (((3283 - (690 + 1108)) <= (1048 + 1856)) and v10.Cast(v81.BagofTricks, v28)) then
					return "Cast Bag of Tricks";
				end
			end
			if (((3522 + 747) == (5117 - (40 + 808))) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and not v15:IsInRange(v92) and not v14:StealthUp(true, true) and (v99 < (5 + 20)) and ((v96 >= (3 - 2)) or (v100 <= (1.2 + 0)))) then
				if (((205 + 182) <= (1526 + 1256)) and v10.Cast(v81.PistolShot)) then
					return "Cast Pistol Shot (OOR)";
				end
			end
			if (v81.SinisterStrike:IsCastable() or ((2470 - (47 + 524)) <= (596 + 321))) then
				if (v10.Cast(v81.SinisterStrike) or ((11786 - 7474) <= (1309 - 433))) then
					return "Cast Sinister Strike Filler";
				end
			end
		end
	end
	local function v124()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(592 - 332, v123, v124);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

