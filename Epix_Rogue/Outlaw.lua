local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((521 + 1734) < (9095 - 4567)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Macro;
	local v19 = v9.Commons.Everyone.num;
	local v20 = v9.Commons.Everyone.bool;
	local v21 = math.min;
	local v22 = math.abs;
	local v23 = math.max;
	local v24 = false;
	local v25 = false;
	local v26 = false;
	local v27;
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
	local function v77()
		local v123 = 0 + 0;
		while true do
			if ((v123 == (3 + 2)) or ((3195 - (1010 + 780)) >= (3440 + 1))) then
				v69 = EpicSettings.Settings['BladeRushGCD'];
				v70 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v72 = EpicSettings.Settings['KeepItRollingGCD'];
				v73 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v123 = 28 - 22;
			end
			if (((6942 - 4573) == (4205 - (1045 + 791))) and (v123 == (2 - 1))) then
				v32 = EpicSettings.Settings['UseHealthstone'];
				v33 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v34 = EpicSettings.Settings['InterruptWithStun'] or (505 - (351 + 154));
				v35 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1574 - (1281 + 293));
				v123 = 268 - (28 + 238);
			end
			if (((9149 - 5054) >= (4742 - (1381 + 178))) and (v123 == (3 + 0))) then
				v53 = EpicSettings.Settings['ColdBloodOffGCD'];
				v54 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v55 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v56 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v123 = 13 - 9;
			end
			if (((4 + 2) == v123) or ((4181 - (381 + 89)) < (894 + 114))) then
				v74 = EpicSettings.Settings['EchoingReprimand'];
				v75 = EpicSettings.Settings['UseSoloVanish'];
				v76 = EpicSettings.Settings['sepsis'];
				break;
			end
			if ((v123 == (3 + 1)) or ((1796 - 747) <= (2062 - (1074 + 82)))) then
				v57 = EpicSettings.Settings['StealthOOC'];
				v62 = EpicSettings.Settings['RolltheBonesLogic'];
				v65 = EpicSettings.Settings['UseDPSVanish'];
				v68 = EpicSettings.Settings['BladeFlurryGCD'] or (0 - 0);
				v123 = 1789 - (214 + 1570);
			end
			if (((5968 - (990 + 465)) > (1124 + 1602)) and (v123 == (1 + 1))) then
				v36 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v50 = EpicSettings.Settings['VanishOffGCD'];
				v51 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v52 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v123 = 11 - 8;
			end
			if ((v123 == (1726 - (1668 + 58))) or ((2107 - (512 + 114)) >= (6929 - 4271))) then
				v27 = EpicSettings.Settings['UseRacials'];
				v29 = EpicSettings.Settings['UseHealingPotion'];
				v30 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v31 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v123 = 1 + 0;
			end
		end
	end
	local v78 = v9.Commons.Everyone;
	local v79 = v9.Commons.Rogue;
	local v80 = v15.Rogue.Outlaw;
	local v81 = v17.Rogue.Outlaw;
	local v82 = v18.Rogue.Outlaw;
	local v83 = {v81.ManicGrieftorch:ID(),v81.DragonfireBombDispenser:ID(),v81.BeaconToTheBeyond:ID()};
	local v84 = v13:GetEquipment();
	local v85 = (v84[2007 - (109 + 1885)] and v17(v84[1482 - (1269 + 200)])) or v17(0 - 0);
	local v86 = (v84[829 - (98 + 717)] and v17(v84[840 - (802 + 24)])) or v17(0 - 0);
	v9:RegisterForEvent(function()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (0 + 0)) or ((2474 + 746) == (225 + 1139))) then
				v84 = v13:GetEquipment();
				v85 = (v84[3 + 10] and v17(v84[36 - 23])) or v17(0 - 0);
				v124 = 1 + 0;
			end
			if ((v124 == (1 + 0)) or ((870 + 184) > (2467 + 925))) then
				v86 = (v84[7 + 7] and v17(v84[1447 - (797 + 636)])) or v17(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v80.Dispatch:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v79.CPSpend() * (1619.3 - (1427 + 192)) * (1 + 0) * ((2 - 1) + (v13:VersatilityDmgPct() / (90 + 10))) * ((v14:DebuffUp(v80.GhostlyStrike) and (1.1 + 0)) or (327 - (192 + 134)));
	end);
	local v87, v88, v89;
	local v90;
	local v91;
	local v92, v93, v94;
	local v95, v96, v97, v98, v99;
	local v100 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v101, v102 = 0 - 0, 551 - (83 + 468);
	local function v103(v125)
		local v126 = 1806 - (1202 + 604);
		local v127;
		while true do
			if (((0 - 0) == v126) or ((1124 - 448) >= (4546 - 2904))) then
				v127 = v13:EnergyTimeToMaxPredicted(nil, v125);
				if (((4461 - (45 + 280)) > (2314 + 83)) and ((v127 < v101) or ((v127 - v101) > (0.5 + 0)))) then
					v101 = v127;
				end
				v126 = 1 + 0;
			end
			if ((v126 == (1 + 0)) or ((763 + 3571) == (7860 - 3615))) then
				return v101;
			end
		end
	end
	local function v104()
		local v128 = v13:EnergyPredicted();
		if ((v128 > v102) or ((v128 - v102) > (1920 - (340 + 1571))) or ((1687 + 2589) <= (4803 - (1733 + 39)))) then
			v102 = v128;
		end
		return v102;
	end
	local v105 = {v80.Broadside,v80.BuriedTreasure,v80.GrandMelee,v80.RuthlessPrecision,v80.SkullandCrossbones,v80.TrueBearing};
	local function v106(v129, v130)
		local v131 = 512 - (409 + 103);
		local v132;
		while true do
			if (((238 - (46 + 190)) == v131) or ((4877 - (51 + 44)) <= (339 + 860))) then
				return v10.APLVar.RtB_List[v129][v132];
			end
			if (((1318 - (1114 + 203)) == v131) or ((5590 - (228 + 498)) < (413 + 1489))) then
				v132 = table.concat(v130);
				if (((2674 + 2165) >= (4363 - (174 + 489))) and (v129 == "All")) then
					if (not v10.APLVar.RtB_List[v129][v132] or ((2800 - 1725) > (3823 - (830 + 1075)))) then
						local v174 = 524 - (303 + 221);
						for v178 = 1270 - (231 + 1038), #v130 do
							if (((330 + 66) <= (4966 - (171 + 991))) and v13:BuffUp(v105[v130[v178]])) then
								v174 = v174 + (4 - 3);
							end
						end
						v10.APLVar.RtB_List[v129][v132] = ((v174 == #v130) and true) or false;
					end
				elseif (not v10.APLVar.RtB_List[v129][v132] or ((11194 - 7025) == (5457 - 3270))) then
					local v176 = 0 + 0;
					while true do
						if (((4928 - 3522) == (4055 - 2649)) and (v176 == (0 - 0))) then
							v10.APLVar.RtB_List[v129][v132] = false;
							for v183 = 3 - 2, #v130 do
								if (((2779 - (111 + 1137)) < (4429 - (91 + 67))) and v13:BuffUp(v105[v130[v183]])) then
									v10.APLVar.RtB_List[v129][v132] = true;
									break;
								end
							end
							break;
						end
					end
				end
				v131 = 5 - 3;
			end
			if (((159 + 476) == (1158 - (423 + 100))) and (v131 == (0 + 0))) then
				if (((9338 - 5965) <= (1854 + 1702)) and not v10.APLVar.RtB_List) then
					v10.APLVar.RtB_List = {};
				end
				if (not v10.APLVar.RtB_List[v129] or ((4062 - (326 + 445)) < (14313 - 11033))) then
					v10.APLVar.RtB_List[v129] = {};
				end
				v131 = 2 - 1;
			end
		end
	end
	local function v107()
		if (((10237 - 5851) >= (1584 - (530 + 181))) and not v10.APLVar.RtB_Buffs) then
			local v136 = 881 - (614 + 267);
			local v137;
			while true do
				if (((953 - (19 + 13)) <= (1793 - 691)) and (v136 == (0 - 0))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Total = 0 - 0;
					v136 = 1 + 0;
				end
				if (((8275 - 3569) >= (1996 - 1033)) and (v136 == (1813 - (1293 + 519)))) then
					v10.APLVar.RtB_Buffs.Normal = 0 - 0;
					v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
					v136 = 3 - 1;
				end
				if ((v136 == (12 - 9)) or ((2261 - 1301) <= (464 + 412))) then
					for v170 = 1 + 0, #v105 do
						local v171 = 0 - 0;
						local v172;
						while true do
							if ((v171 == (0 + 0)) or ((687 + 1379) == (583 + 349))) then
								v172 = v13:BuffRemains(v105[v170]);
								if (((5921 - (709 + 387)) < (6701 - (673 + 1185))) and (v172 > (0 - 0))) then
									local v184 = 0 - 0;
									while true do
										if ((v184 == (0 - 0)) or ((2774 + 1103) >= (3391 + 1146))) then
											v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1 - 0);
											if ((v172 == v137) or ((1060 + 3255) < (3441 - 1715))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (1 - 0);
											elseif ((v172 > v137) or ((5559 - (446 + 1434)) < (1908 - (1040 + 243)))) then
												v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (2 - 1);
											else
												v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1848 - (559 + 1288));
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
				if ((v136 == (1933 - (609 + 1322))) or ((5079 - (13 + 441)) < (2361 - 1729))) then
					v10.APLVar.RtB_Buffs.Longer = 0 - 0;
					v137 = v79.RtBRemains();
					v136 = 14 - 11;
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v108()
		if (not v10.APLVar.RtB_Reroll or ((4 + 79) > (6464 - 4684))) then
			if (((194 + 352) <= (472 + 605)) and (v62 == "1+ Buff")) then
				v10.APLVar.RtB_Reroll = ((v107() <= (0 - 0)) and true) or false;
			elseif ((v62 == "Broadside") or ((546 + 450) > (7910 - 3609))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.Broadside) and true) or false;
			elseif (((2691 + 1379) > (383 + 304)) and (v62 == "Buried Treasure")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.BuriedTreasure) and true) or false;
			elseif ((v62 == "Grand Melee") or ((472 + 184) >= (2797 + 533))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.GrandMelee) and true) or false;
			elseif ((v62 == "Skull and Crossbones") or ((2439 + 53) <= (768 - (153 + 280)))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.SkullandCrossbones) and true) or false;
			elseif (((12479 - 8157) >= (2301 + 261)) and (v62 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.RuthlessPrecision) and true) or false;
			elseif ((v62 == "True Bearing") or ((1437 + 2200) >= (1973 + 1797))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.TrueBearing) and true) or false;
			else
				v10.APLVar.RtB_Reroll = false;
				v107();
				if (((v107() <= (2 + 0)) and v13:BuffUp(v80.BuriedTreasure) and v13:BuffDown(v80.GrandMelee) and (v89 < (2 + 0))) or ((3621 - 1242) > (2830 + 1748))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:HasTier(698 - (89 + 578), 3 + 1) and ((not v13:BuffUp(v80.TrueBearing) and v80.HiddenOpportunity:IsAvailable()) or (not v13:BuffUp(v80.Broadside) and not v80.HiddenOpportunity:IsAvailable())) and (v107() <= (1 - 0))) or ((1532 - (572 + 477)) > (101 + 642))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((1473 + 981) > (69 + 509)) and v80.Crackshot:IsAvailable() and v13:HasTier(117 - (84 + 2), 6 - 2) and (v107() <= (1 + 0 + v19(v13:BuffUp(v80.LoadedDiceBuff)))) and (v80.HiddenOpportunity:IsAvailable() or v13:BuffDown(v80.Broadside))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((1772 - (497 + 345)) < (115 + 4343)) and not v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:BuffUp(v80.SkullandCrossbones) and (v107() < (1 + 1 + v19(v13:BuffUp(v80.GrandMelee)))) and (v89 < (1335 - (605 + 728)))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((473 + 189) <= (2160 - 1188)) and (v10.APLVar.RtB_Reroll or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (3 - 2)) and (v107() < (5 + 0)) and (v79.RtBRemains() <= (107 - 68))))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((3300 + 1070) == (4859 - (457 + 32))) and (v14:FilteredTimeToDie("<", 6 + 6) or v9.BossFilteredFightRemains("<", 1414 - (832 + 570)))) then
					v10.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v109()
		return v92 >= ((v79.CPMaxSpend() - (1 + 0)) - v19((v13:StealthUp(true, true)) and v80.Crackshot:IsAvailable()));
	end
	local function v110()
		return (v80.HiddenOpportunity:IsAvailable() or (v94 >= (1 + 1 + v19(v80.ImprovedAmbush:IsAvailable()) + v19(v13:BuffUp(v80.Broadside))))) and (v95 >= (176 - 126));
	end
	local function v111()
		return not v25 or (v89 < (1 + 1)) or (v13:BuffRemains(v80.BladeFlurry) > ((797 - (588 + 208)) + v19(v80.KillingSpree:IsAvailable())));
	end
	local function v112()
		return v65 and (not v13:IsTanking(v14) or v75);
	end
	local function v113()
		return not v80.ShadowDanceTalent:IsAvailable() and ((v80.FanTheHammer:TalentRank() + v19(v80.QuickDraw:IsAvailable()) + v19(v80.Audacity:IsAvailable())) < (v19(v80.CountTheOdds:IsAvailable()) + v19(v80.KeepItRolling:IsAvailable())));
	end
	local function v114()
		return v13:BuffUp(v80.BetweentheEyes) and (not v80.HiddenOpportunity:IsAvailable() or (v13:BuffDown(v80.AudacityBuff) and ((v80.FanTheHammer:TalentRank() < (5 - 3)) or v13:BuffDown(v80.Opportunity)))) and not v80.Crackshot:IsAvailable();
	end
	local function v115()
		local v133 = 1800 - (884 + 916);
		while true do
			if ((v133 == (3 - 1)) or ((2762 + 2000) <= (1514 - (232 + 421)))) then
				if ((v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.KeepItRolling:IsAvailable() and v114() and ((v80.KeepItRolling:CooldownRemains() <= (1919 - (1569 + 320))) or ((v80.KeepItRolling:CooldownRemains() >= (30 + 90)) and (v109() or v80.HiddenOpportunity:IsAvailable())))) or ((269 + 1143) == (14368 - 10104))) then
					if (v9.Cast(v80.ShadowDance) or ((3773 - (316 + 289)) < (5635 - 3482))) then
						return "Cast Shadow Dance";
					end
				end
				if ((v80.Shadowmeld:IsAvailable() and v80.Shadowmeld:IsReady()) or ((230 + 4746) < (2785 - (666 + 787)))) then
					if (((5053 - (360 + 65)) == (4326 + 302)) and ((v80.Crackshot:IsAvailable() and v109()) or (not v80.Crackshot:IsAvailable() and ((v80.CountTheOdds:IsAvailable() and v109()) or v80.HiddenOpportunity:IsAvailable())))) then
						if (v9.Cast(v80.Shadowmeld, v27) or ((308 - (79 + 175)) == (622 - 227))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((64 + 18) == (251 - 169)) and (v133 == (1 - 0))) then
				if ((v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.Crackshot:IsAvailable() and v109()) or ((1480 - (503 + 396)) < (463 - (92 + 89)))) then
					if (v9.Cast(v80.ShadowDance) or ((8940 - 4331) < (1280 + 1215))) then
						return "Cast Shadow Dance";
					end
				end
				if (((682 + 470) == (4511 - 3359)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and not v80.KeepItRolling:IsAvailable() and v114() and v13:BuffUp(v80.SliceandDice) and (v109() or v80.HiddenOpportunity:IsAvailable()) and (not v80.HiddenOpportunity:IsAvailable() or not v80.Vanish:IsReady())) then
					if (((260 + 1636) <= (7802 - 4380)) and v9.Cast(v80.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				v133 = 2 + 0;
			end
			if ((v133 == (0 + 0)) or ((3015 - 2025) > (203 + 1417))) then
				if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v112() and v80.HiddenOpportunity:IsAvailable() and not v80.Crackshot:IsAvailable() and not v13:BuffUp(v80.Audacity) and (v113() or (v13:BuffStack(v80.Opportunity) < (8 - 2))) and v110()) or ((2121 - (485 + 759)) > (10863 - 6168))) then
					if (((3880 - (442 + 747)) >= (2986 - (832 + 303))) and v9.Cast(v80.Vanish, v65)) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v112() and (not v80.HiddenOpportunity:IsAvailable() or v80.Crackshot:IsAvailable()) and v109()) or ((3931 - (88 + 858)) >= (1481 + 3375))) then
					if (((3539 + 737) >= (50 + 1145)) and v9.Cast(v80.Vanish, v65)) then
						return "Cast Vanish (Finish)";
					end
				end
				v133 = 790 - (766 + 23);
			end
		end
	end
	local function v116()
		local v134 = 0 - 0;
		while true do
			if (((4419 - 1187) <= (12356 - 7666)) and (v134 == (3 - 2))) then
				v90 = v78.HandleBottomTrinket(v83, v26, 1113 - (1036 + 37), nil);
				if (v90 or ((636 + 260) >= (6126 - 2980))) then
					return v90;
				end
				break;
			end
			if (((2408 + 653) >= (4438 - (641 + 839))) and (v134 == (913 - (910 + 3)))) then
				v90 = v78.HandleTopTrinket(v83, v26, 101 - 61, nil);
				if (((4871 - (1466 + 218)) >= (296 + 348)) and v90) then
					return v90;
				end
				v134 = 1149 - (556 + 592);
			end
		end
	end
	local function v117()
		if (((230 + 414) <= (1512 - (329 + 479))) and v26 and v80.AdrenalineRush:IsCastable() and (not v13:BuffUp(v80.AdrenalineRush) or (v13:StealthUp(true, true) and v80.Crackshot:IsAvailable() and v80.ImprovedAdrenalineRush:IsAvailable())) and ((v93 <= (856 - (174 + 680))) or not v80.ImprovedAdrenalineRush:IsAvailable())) then
			if (((3291 - 2333) > (1962 - 1015)) and v9.Cast(v80.AdrenalineRush)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((3208 + 1284) >= (3393 - (396 + 343))) and v80.BladeFlurry:IsReady() and (v13:BuffRemains(v80.BladeFlurry) < v13:GCDRemains()) and ((v89 >= ((1 + 1) - v19(v80.UnderhandedUpperhand:IsAvailable()))) or (v80.DeftManeuvers:IsAvailable() and (v89 >= (1482 - (29 + 1448))) and not v109()))) then
			if (((4831 - (135 + 1254)) >= (5662 - 4159)) and v68) then
				if (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(46 - 36)) or ((2113 + 1057) <= (2991 - (389 + 1138)))) then
					return "Cast Blade Flurry";
				end
			elseif (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(584 - (102 + 472))) or ((4527 + 270) == (2434 + 1954))) then
				return "Cast Blade Flurry";
			end
		end
		if (((514 + 37) <= (2226 - (320 + 1225))) and v80.RolltheBones:IsReady()) then
			if (((5833 - 2556) > (250 + 157)) and (v108() or (v79.RtBRemains() <= (v19(v13:HasTier(1495 - (157 + 1307), 1863 - (821 + 1038))) + (v19((v80.ShadowDance:CooldownRemains() <= (2 - 1)) or (v80.Vanish:CooldownRemains() <= (1 + 0))) * (10 - 4)))))) then
				if (((1747 + 2948) >= (3507 - 2092)) and v9.Cast(v80.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		if ((v80.KeepItRolling:IsReady() and not v108() and (v107() >= ((1029 - (834 + 192)) + v19(v13:HasTier(2 + 29, 2 + 2)))) and (v13:BuffDown(v80.ShadowDance) or (v107() >= (1 + 5)))) or ((4975 - 1763) <= (1248 - (300 + 4)))) then
			if (v9.Cast(v80.KeepItRolling) or ((827 + 2269) <= (4706 - 2908))) then
				return "Cast Keep it Rolling";
			end
		end
		if (((3899 - (112 + 250)) == (1411 + 2126)) and v80.GhostlyStrike:IsAvailable() and v80.GhostlyStrike:IsReady()) then
			if (((9612 - 5775) >= (900 + 670)) and v9.Cast(v80.GhostlyStrike)) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v26 and v80.Sepsis:IsAvailable() and v80.Sepsis:IsReady()) or ((1526 + 1424) == (2851 + 961))) then
			if (((2342 + 2381) >= (1722 + 596)) and ((v80.Crackshot:IsAvailable() and v80.BetweentheEyes:IsReady() and v109() and not v13:StealthUp(true, true)) or (not v80.Crackshot:IsAvailable() and v14:FilteredTimeToDie(">", 1425 - (1001 + 413)) and v13:BuffUp(v80.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 24 - 13))) then
				if (v9.Cast(v80.Sepsis) or ((2909 - (244 + 638)) > (3545 - (627 + 66)))) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v80.BladeRush:IsReady() and (v98 > (11 - 7)) and not v13:StealthUp(true, true)) or ((1738 - (512 + 90)) > (6223 - (1665 + 241)))) then
			if (((5465 - (373 + 344)) == (2142 + 2606)) and v9.Cast(v80.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((989 + 2747) <= (12502 - 7762)) and not v13:StealthUp(true, true, true)) then
			local v138 = 0 - 0;
			while true do
				if ((v138 == (1099 - (35 + 1064))) or ((2467 + 923) <= (6546 - 3486))) then
					v90 = v115();
					if (v90 or ((4 + 995) > (3929 - (298 + 938)))) then
						return v90;
					end
					break;
				end
			end
		end
		if (((1722 - (233 + 1026)) < (2267 - (636 + 1030))) and v26 and v80.ThistleTea:IsAvailable() and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and ((v97 >= (52 + 48)) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (6 + 0)))) then
			if (v9.Cast(v80.ThistleTea) or ((649 + 1534) < (47 + 640))) then
				return "Cast Thistle Tea";
			end
		end
		if (((4770 - (55 + 166)) == (882 + 3667)) and v80.BloodFury:IsCastable()) then
			if (((470 + 4202) == (17842 - 13170)) and v9.Cast(v80.BloodFury, v27)) then
				return "Cast Blood Fury";
			end
		end
		if (v80.Berserking:IsCastable() or ((3965 - (36 + 261)) < (690 - 295))) then
			if (v9.Cast(v80.Berserking, v27) or ((5534 - (34 + 1334)) == (175 + 280))) then
				return "Cast Berserking";
			end
		end
		if (v80.Fireblood:IsCastable() or ((3457 + 992) == (3946 - (1035 + 248)))) then
			if (v9.Cast(v80.Fireblood, v27) or ((4298 - (20 + 1)) < (1558 + 1431))) then
				return "Cast Fireblood";
			end
		end
		if (v80.AncestralCall:IsCastable() or ((1189 - (134 + 185)) >= (5282 - (549 + 584)))) then
			if (((2897 - (314 + 371)) < (10926 - 7743)) and v9.Cast(v80.AncestralCall, v27)) then
				return "Cast Ancestral Call";
			end
		end
		v90 = v116();
		if (((5614 - (478 + 490)) > (1585 + 1407)) and v90) then
			return v90;
		end
	end
	local function v118()
		if (((2606 - (786 + 386)) < (10060 - 6954)) and v80.BladeFlurry:IsReady() and v80.BladeFlurry:IsCastable() and v25 and v80.Subterfuge:IsAvailable() and (v89 >= (1381 - (1055 + 324))) and (v13:BuffRemains(v80.BladeFlurry) <= v13:GCDRemains())) then
			if (((2126 - (1093 + 247)) < (2687 + 336)) and v68) then
				if (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(2 + 8)) or ((9695 - 7253) < (251 - 177))) then
					return "Cast Blade Flurry";
				end
			elseif (((12904 - 8369) == (11396 - 6861)) and v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(4 + 6))) then
				return "Cast Blade Flurry";
			end
		end
		if ((v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch) and v109()) or ((11591 - 8582) <= (7255 - 5150))) then
			if (((1380 + 450) < (9382 - 5713)) and v9.Cast(v80.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if ((v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v109() and v80.Crackshot:IsAvailable()) or ((2118 - (364 + 324)) >= (9901 - 6289))) then
			if (((6437 - 3754) >= (816 + 1644)) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch) and v109()) or ((7548 - 5744) >= (5245 - 1970))) then
			if (v9.Press(v80.Dispatch) or ((4303 - 2886) > (4897 - (1249 + 19)))) then
				return "Cast Dispatch";
			end
		end
		if (((4329 + 466) > (1564 - 1162)) and v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and v80.Crackshot:IsAvailable() and (v80.FanTheHammer:TalentRank() >= (1088 - (686 + 400))) and (v13:BuffStack(v80.Opportunity) >= (5 + 1)) and ((v13:BuffUp(v80.Broadside) and (v93 <= (230 - (73 + 156)))) or v13:BuffUp(v80.GreenskinsWickersBuff))) then
			if (((23 + 4790) > (4376 - (721 + 90))) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((44 + 3868) == (12701 - 8789)) and v80.Ambush:IsCastable() and v14:IsSpellInRange(v80.Ambush) and v80.HiddenOpportunity:IsAvailable()) then
			if (((3291 - (224 + 246)) <= (7814 - 2990)) and v9.Press(v80.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v119()
		if (((3199 - 1461) <= (399 + 1796)) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and not v80.Crackshot:IsAvailable() and ((v13:BuffRemains(v80.BetweentheEyes) < (1 + 3)) or v80.ImprovedBetweenTheEyes:IsAvailable() or v80.GreenskinsWickers:IsAvailable() or v13:HasTier(23 + 7, 7 - 3)) and v13:BuffDown(v80.GreenskinsWickers)) then
			if (((136 - 95) <= (3531 - (203 + 310))) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((4138 - (1238 + 755)) <= (287 + 3817)) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v80.Crackshot:IsAvailable() and (v80.Vanish:CooldownRemains() > (1579 - (709 + 825))) and (v80.ShadowDance:CooldownRemains() > (21 - 9))) then
			if (((3916 - 1227) < (5709 - (196 + 668))) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v80.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v88, ">", v13:BuffRemains(v80.SliceandDice), true) or (v13:BuffRemains(v80.SliceandDice) == (0 - 0))) and (v13:BuffRemains(v80.SliceandDice) < (((1 - 0) + v93) * (834.8 - (171 + 662))))) or ((2415 - (4 + 89)) > (9189 - 6567))) then
			if (v9.Press(v80.SliceandDice) or ((1651 + 2883) == (9144 - 7062))) then
				return "Cast Slice and Dice";
			end
		end
		if ((v80.KillingSpree:IsCastable() and v14:IsSpellInRange(v80.KillingSpree) and (v14:DebuffUp(v80.GhostlyStrike) or not v80.GhostlyStrike:IsAvailable())) or ((617 + 954) > (3353 - (35 + 1451)))) then
			if (v9.Cast(v80.KillingSpree) or ((4107 - (28 + 1425)) >= (4989 - (941 + 1052)))) then
				return "Cast Killing Spree";
			end
		end
		if (((3815 + 163) > (3618 - (822 + 692))) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch)) then
			if (((4275 - 1280) > (726 + 815)) and v9.Cast(v80.ColdBlood, v53)) then
				return "Cast Cold Blood";
			end
		end
		if (((3546 - (45 + 252)) > (943 + 10)) and v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch)) then
			if (v9.Press(v80.Dispatch) or ((1127 + 2146) > (11129 - 6556))) then
				return "Cast Dispatch";
			end
		end
	end
	local function v120()
		if ((v26 and v80.EchoingReprimand:IsReady()) or ((3584 - (114 + 319)) < (1843 - 559))) then
			if (v9.Cast(v80.EchoingReprimand, nil, v74) or ((2370 - 520) == (975 + 554))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((1222 - 401) < (4447 - 2324)) and v80.Ambush:IsCastable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.AudacityBuff)) then
			if (((2865 - (556 + 1407)) < (3531 - (741 + 465))) and v9.Press(v80.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((1323 - (170 + 295)) <= (1561 + 1401)) and v80.FanTheHammer:IsAvailable() and v80.Audacity:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.Opportunity) and v13:BuffDown(v80.AudacityBuff)) then
			if (v9.Press(v80.PistolShot) or ((3625 + 321) < (3170 - 1882))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v13:BuffUp(v80.GreenskinsWickersBuff) and ((not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity)) or (v13:BuffRemains(v80.GreenskinsWickersBuff) < (1.5 + 0)))) or ((2080 + 1162) == (322 + 245))) then
			if (v9.Press(v80.PistolShot) or ((2077 - (957 + 273)) >= (338 + 925))) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v13:BuffStack(v80.Opportunity) >= (3 + 3)) or (v13:BuffRemains(v80.Opportunity) < (7 - 5)))) or ((5937 - 3684) == (5653 - 3802))) then
			if (v9.Press(v80.PistolShot) or ((10334 - 8247) > (4152 - (389 + 1391)))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and (v94 > (1 + 0 + (v19(v80.QuickDraw:IsAvailable()) * v80.FanTheHammer:TalentRank()))) and ((not v80.Vanish:IsReady() and not v80.ShadowDance:IsReady()) or v13:StealthUp(true, true) or not v80.Crackshot:IsAvailable() or (v80.FanTheHammer:TalentRank() <= (1 + 0)))) or ((10119 - 5674) < (5100 - (783 + 168)))) then
			if (v9.Press(v80.PistolShot) or ((6101 - 4283) == (84 + 1))) then
				return "Cast Pistol Shot";
			end
		end
		if (((941 - (309 + 2)) < (6531 - 4404)) and not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v98 > (1213.5 - (1090 + 122))) or (v94 <= (1 + 0 + v19(v13:BuffUp(v80.Broadside)))) or v80.QuickDraw:IsAvailable() or (v80.Audacity:IsAvailable() and v13:BuffDown(v80.AudacityBuff)))) then
			if (v9.Press(v80.PistolShot) or ((6508 - 4570) == (1721 + 793))) then
				return "Cast Pistol Shot";
			end
		end
		if (((5373 - (628 + 490)) >= (10 + 45)) and v80.SinisterStrike:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) then
			if (((7424 - 4425) > (5282 - 4126)) and v9.Press(v80.SinisterStrike)) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v121()
		local v135 = 774 - (431 + 343);
		while true do
			if (((4746 - 2396) > (3341 - 2186)) and (v135 == (2 + 0))) then
				v94 = v13:ComboPointsDeficit();
				v99 = (v13:BuffUp(v80.AdrenalineRush, nil, true) and -(7 + 43)) or (1695 - (556 + 1139));
				v95 = v104();
				v135 = 18 - (6 + 9);
			end
			if (((738 + 3291) <= (2487 + 2366)) and (v135 == (174 - (28 + 141)))) then
				v79.Poisons();
				if ((v81.Healthstone:IsReady() and (v13:HealthPercentage() < v33) and not (v13:IsChanneling() or v13:IsCasting())) or ((200 + 316) > (4237 - 803))) then
					if (((2866 + 1180) >= (4350 - (486 + 831))) and v9.Cast(v82.Healthstone)) then
						return "Healthstone ";
					end
				end
				if ((v81.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v31) and not (v13:IsChanneling() or v13:IsCasting())) or ((7075 - 4356) <= (5094 - 3647))) then
					if (v9.Cast(v82.RefreshingHealingPotion) or ((782 + 3352) < (12413 - 8487))) then
						return "RefreshingHealingPotion ";
					end
				end
				v135 = 1269 - (668 + 595);
			end
			if ((v135 == (7 + 0)) or ((34 + 130) >= (7594 - 4809))) then
				if ((v80.FanTheHammer:IsAvailable() and (v80.PistolShot:TimeSinceLastCast() < v13:GCDRemains())) or ((815 - (23 + 267)) == (4053 - (1129 + 815)))) then
					v93 = v23(v93, v79.FanTheHammerCP());
				end
				if (((420 - (371 + 16)) == (1783 - (1326 + 424))) and v78.TargetIsValid()) then
					v90 = v117();
					if (((5784 - 2730) <= (14671 - 10656)) and v90) then
						return "CDs: " .. v90;
					end
					if (((1989 - (88 + 30)) < (4153 - (720 + 51))) and (v13:StealthUp(true, true) or v13:BuffUp(v80.Shadowmeld))) then
						v90 = v118();
						if (((2876 - 1583) <= (3942 - (421 + 1355))) and v90) then
							return "Stealth: " .. v90;
						end
					end
					if (v109() or ((4254 - 1675) < (61 + 62))) then
						local v177 = 1083 - (286 + 797);
						while true do
							if ((v177 == (0 - 0)) or ((1400 - 554) >= (2807 - (397 + 42)))) then
								v90 = v119();
								if (v90 or ((1254 + 2758) <= (4158 - (24 + 776)))) then
									return "Finish: " .. v90;
								end
								break;
							end
						end
					end
					v90 = v120();
					if (((2301 - 807) <= (3790 - (222 + 563))) and v90) then
						return "Build: " .. v90;
					end
					if ((v80.ArcaneTorrent:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike) and (v97 > ((33 - 18) + v96))) or ((2240 + 871) == (2324 - (23 + 167)))) then
						if (((4153 - (690 + 1108)) == (850 + 1505)) and v9.Cast(v80.ArcaneTorrent, v27)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v80.ArcanePulse:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) or ((486 + 102) <= (1280 - (40 + 808)))) then
						if (((790 + 4007) >= (14894 - 10999)) and v9.Cast(v80.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if (((3419 + 158) == (1893 + 1684)) and v80.LightsJudgment:IsCastable() and v14:IsInMeleeRange(3 + 2)) then
						if (((4365 - (47 + 524)) > (2397 + 1296)) and v9.Cast(v80.LightsJudgment, v27)) then
							return "Cast Lights Judgment";
						end
					end
					if ((v80.BagofTricks:IsCastable() and v14:IsInMeleeRange(13 - 8)) or ((1906 - 631) == (9350 - 5250))) then
						if (v9.Cast(v80.BagofTricks, v27) or ((3317 - (1165 + 561)) >= (107 + 3473))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((3044 - 2061) <= (690 + 1118)) and v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and not v14:IsInRange(485 - (341 + 138)) and not v13:StealthUp(true, true) and (v97 < (7 + 18)) and ((v94 >= (1 - 0)) or (v98 <= (327.2 - (89 + 237))))) then
						if (v9.Cast(v80.PistolShot) or ((6916 - 4766) <= (2519 - 1322))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((4650 - (581 + 300)) >= (2393 - (855 + 365))) and v80.SinisterStrike:IsCastable()) then
						if (((3527 - 2042) == (485 + 1000)) and v9.Cast(v80.SinisterStrike)) then
							return "Cast Sinister Strike Filler";
						end
					end
				end
				break;
			end
			if ((v135 == (1241 - (1030 + 205))) or ((3113 + 202) <= (2588 + 194))) then
				if ((v80.Feint:IsCastable() and (v13:HealthPercentage() <= v56) and not (v13:IsChanneling() or v13:IsCasting())) or ((1162 - (156 + 130)) >= (6734 - 3770))) then
					if (v9.Cast(v80.Feint) or ((3761 - 1529) > (5113 - 2616))) then
						return "Cast Feint (Defensives)";
					end
				end
				if ((not v13:AffectingCombat() and not v13:IsMounted() and v57) or ((556 + 1554) <= (194 + 138))) then
					local v168 = 69 - (10 + 59);
					while true do
						if (((1043 + 2643) > (15621 - 12449)) and (v168 == (1163 - (671 + 492)))) then
							v90 = v79.Stealth(v80.Stealth2, nil);
							if (v90 or ((3562 + 912) < (2035 - (369 + 846)))) then
								return "Stealth (OOC): " .. v90;
							end
							break;
						end
					end
				end
				if (((1133 + 3146) >= (2460 + 422)) and not v13:AffectingCombat() and (v80.Vanish:TimeSinceLastCast() > (1946 - (1036 + 909))) and v14:IsInRange(7 + 1) and v24) then
					if ((v78.TargetIsValid() and v14:IsInRange(16 - 6) and not (v13:IsChanneling() or v13:IsCasting())) or ((2232 - (11 + 192)) >= (1780 + 1741))) then
						if ((v80.BladeFlurry:IsReady() and v13:BuffDown(v80.BladeFlurry) and v80.UnderhandedUpperhand:IsAvailable() and not v13:StealthUp(true, true)) or ((2212 - (135 + 40)) >= (11246 - 6604))) then
							if (((1037 + 683) < (9820 - 5362)) and v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(14 - 4))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v13:StealthUp(true, false) or ((612 - (50 + 126)) > (8412 - 5391))) then
							local v180 = 0 + 0;
							while true do
								if (((2126 - (1233 + 180)) <= (1816 - (522 + 447))) and (v180 == (1421 - (107 + 1314)))) then
									v90 = v79.Stealth(v79.StealthSpell());
									if (((1000 + 1154) <= (12282 - 8251)) and v90) then
										return v90;
									end
									break;
								end
							end
						end
						if (((1961 + 2654) == (9164 - 4549)) and v78.TargetIsValid()) then
							if ((v80.AdrenalineRush:IsReady() and v80.ImprovedAdrenalineRush:IsAvailable() and (v93 <= (7 - 5))) or ((5700 - (716 + 1194)) == (9 + 491))) then
								if (((10 + 79) < (724 - (74 + 429))) and v9.Cast(v80.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if (((3961 - 1907) >= (705 + 716)) and v80.RolltheBones:IsReady() and not v13:DebuffUp(v80.Dreadblades) and ((v107() == (0 - 0)) or v108())) then
								if (((490 + 202) < (9427 - 6369)) and v9.Cast(v80.RolltheBones)) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if ((v80.SliceandDice:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (((2 - 1) + v93) * (434.8 - (279 + 154))))) or ((4032 - (454 + 324)) == (1303 + 352))) then
								if (v9.Press(v80.SliceandDice) or ((1313 - (12 + 5)) == (2648 + 2262))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((8581 - 5213) == (1245 + 2123)) and v13:StealthUp(true, false)) then
								v90 = v118();
								if (((3736 - (277 + 816)) < (16301 - 12486)) and v90) then
									return "Stealth (Opener): " .. v90;
								end
								if (((3096 - (1058 + 125)) > (93 + 400)) and v80.KeepItRolling:IsAvailable() and v80.GhostlyStrike:IsReady() and v80.EchoingReprimand:IsAvailable()) then
									if (((5730 - (815 + 160)) > (14708 - 11280)) and v9.Press(v80.GhostlyStrike)) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if (((3278 - 1897) <= (566 + 1803)) and v80.Ambush:IsCastable()) then
									if (v9.Cast(v80.Ambush) or ((14156 - 9313) == (5982 - (41 + 1857)))) then
										return "Cast Ambush (Opener)";
									end
								end
							elseif (((6562 - (1222 + 671)) > (937 - 574)) and v109()) then
								local v187 = 0 - 0;
								while true do
									if ((v187 == (1182 - (229 + 953))) or ((3651 - (1111 + 663)) >= (4717 - (874 + 705)))) then
										v90 = v119();
										if (((664 + 4078) >= (2474 + 1152)) and v90) then
											return "Finish (Opener): " .. v90;
										end
										break;
									end
								end
							end
							if (v80.SinisterStrike:IsCastable() or ((9437 - 4897) == (26 + 890))) then
								if (v9.Cast(v80.SinisterStrike) or ((1835 - (642 + 37)) > (991 + 3354))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
				v135 = 2 + 5;
			end
			if (((5616 - 3379) < (4703 - (233 + 221))) and (v135 == (0 - 0))) then
				v77();
				v24 = EpicSettings.Toggles['ooc'];
				v25 = EpicSettings.Toggles['aoe'];
				v135 = 1 + 0;
			end
			if ((v135 == (1542 - (718 + 823))) or ((1689 + 994) < (828 - (266 + 539)))) then
				v26 = EpicSettings.Toggles['cds'];
				v93 = v13:ComboPoints();
				v92 = v79.EffectiveComboPoints(v93);
				v135 = 5 - 3;
			end
			if (((1922 - (636 + 589)) <= (1960 - 1134)) and (v135 == (8 - 4))) then
				if (((876 + 229) <= (428 + 748)) and v25) then
					local v169 = 1015 - (657 + 358);
					while true do
						if (((8946 - 5567) <= (8684 - 4872)) and (v169 == (1188 - (1151 + 36)))) then
							if (not v80.AcrobaticStrikes:IsAvailable() or ((761 + 27) >= (425 + 1191))) then
								v88 = v13:GetEnemiesInRange(17 - 11);
							end
							v89 = #v88;
							break;
						end
						if (((3686 - (1552 + 280)) <= (4213 - (64 + 770))) and (v169 == (0 + 0))) then
							v87 = v13:GetEnemiesInRange(68 - 38);
							if (((808 + 3741) == (5792 - (157 + 1086))) and v80.AcrobaticStrikes:IsAvailable()) then
								v88 = v13:GetEnemiesInRange(20 - 10);
							end
							v169 = 4 - 3;
						end
					end
				else
					v89 = 1 - 0;
				end
				v90 = v79.CrimsonVial();
				if (v90 or ((4124 - 1102) >= (3843 - (599 + 220)))) then
					return v90;
				end
				v135 = 9 - 4;
			end
			if (((6751 - (1813 + 118)) > (1607 + 591)) and (v135 == (1220 - (841 + 376)))) then
				v96 = v13:EnergyRegen();
				v98 = v103(v99);
				v97 = v13:EnergyDeficitPredicted(nil, v99);
				v135 = 5 - 1;
			end
		end
	end
	local function v122()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(61 + 199, v121, v122);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

