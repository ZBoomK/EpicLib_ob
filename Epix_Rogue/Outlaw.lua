local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((19 + 657) == (1165 - 489)) and not v5) then
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
		local v124 = 0 - 0;
		while true do
			if (((611 + 3525) > (1842 + 555)) and (v124 == (1 + 4))) then
				v69 = EpicSettings.Settings['BladeRushGCD'];
				v70 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v72 = EpicSettings.Settings['KeepItRollingGCD'];
				v73 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v124 = 2 + 4;
			end
			if ((v124 == (2 - 1)) or ((14452 - 10118) == (1519 + 2726))) then
				v32 = EpicSettings.Settings['UseHealthstone'];
				v33 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v34 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v35 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v124 = 1 + 1;
			end
			if ((v124 == (1436 - (797 + 636))) or ((20761 - 16485) <= (4650 - (1427 + 192)))) then
				v53 = EpicSettings.Settings['ColdBloodOffGCD'];
				v54 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v55 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v56 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v124 = 4 + 0;
			end
			if (((3 + 3) == v124) or ((5108 - (192 + 134)) <= (2475 - (316 + 960)))) then
				v74 = EpicSettings.Settings['EchoingReprimand'];
				v75 = EpicSettings.Settings['UseSoloVanish'];
				v76 = EpicSettings.Settings['sepsis'];
				break;
			end
			if ((v124 == (3 + 1)) or ((3754 + 1110) < (1759 + 143))) then
				v57 = EpicSettings.Settings['StealthOOC'];
				v62 = EpicSettings.Settings['RolltheBonesLogic'];
				v65 = EpicSettings.Settings['UseDPSVanish'];
				v68 = EpicSettings.Settings['BladeFlurryGCD'];
				v124 = 18 - 13;
			end
			if (((5390 - (83 + 468)) >= (5506 - (1202 + 604))) and (v124 == (9 - 7))) then
				v36 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v50 = EpicSettings.Settings['VanishOffGCD'];
				v51 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v52 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v124 = 8 - 5;
			end
			if ((v124 == (325 - (45 + 280))) or ((1038 + 37) > (1676 + 242))) then
				v27 = EpicSettings.Settings['UseRacials'];
				v29 = EpicSettings.Settings['UseHealingPotion'];
				v30 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v31 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v124 = 1 + 0;
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
	local v85 = (v84[1785 - (1733 + 39)] and v17(v84[35 - 22])) or v17(1034 - (125 + 909));
	local v86 = (v84[1962 - (1096 + 852)] and v17(v84[7 + 7])) or v17(0 - 0);
	v9:RegisterForEvent(function()
		local v125 = 0 + 0;
		while true do
			if (((908 - (409 + 103)) <= (4040 - (46 + 190))) and (v125 == (95 - (51 + 44)))) then
				v84 = v13:GetEquipment();
				v85 = (v84[4 + 9] and v17(v84[1330 - (1114 + 203)])) or v17(726 - (228 + 498));
				v125 = 1 + 0;
			end
			if ((v125 == (1 + 0)) or ((4832 - (174 + 489)) == (5697 - 3510))) then
				v86 = (v84[1919 - (830 + 1075)] and v17(v84[538 - (303 + 221)])) or v17(1269 - (231 + 1038));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v80.Dispatch:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v79.CPSpend() * (0.3 + 0) * (1163 - (171 + 991)) * ((4 - 3) + (v13:VersatilityDmgPct() / (268 - 168))) * ((v14:DebuffUp(v80.GhostlyStrike) and (2.1 - 1)) or (1 + 0));
	end);
	local v87, v88, v89;
	local v90;
	local v91 = 20 - 14;
	local v92;
	local v93, v94, v95;
	local v96, v97, v98, v99, v100;
	local v101 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v102, v103 = 158 - (91 + 67), 0 - 0;
	local function v104(v126)
		local v127 = 0 + 0;
		local v128;
		while true do
			if (((1929 - (423 + 100)) == (10 + 1396)) and ((0 - 0) == v127)) then
				v128 = v13:EnergyTimeToMaxPredicted(nil, v126);
				if (((798 + 733) < (5042 - (326 + 445))) and ((v128 < v102) or ((v128 - v102) > (0.5 - 0)))) then
					v102 = v128;
				end
				v127 = 2 - 1;
			end
			if (((1481 - 846) == (1346 - (530 + 181))) and (v127 == (882 - (614 + 267)))) then
				return v102;
			end
		end
	end
	local function v105()
		local v129 = v13:EnergyPredicted();
		if (((3405 - (19 + 13)) <= (5787 - 2231)) and ((v129 > v103) or ((v129 - v103) > (20 - 11)))) then
			v103 = v129;
		end
		return v103;
	end
	local v106 = {v80.Broadside,v80.BuriedTreasure,v80.GrandMelee,v80.RuthlessPrecision,v80.SkullandCrossbones,v80.TrueBearing};
	local function v107(v130, v131)
		local v132 = 0 - 0;
		local v133;
		while true do
			if (((3 - 1) == v132) or ((14191 - 10900) < (7726 - 4446))) then
				return v10.APLVar.RtB_List[v130][v133];
			end
			if (((2324 + 2062) >= (179 + 694)) and ((2 - 1) == v132)) then
				v133 = table.concat(v131);
				if (((213 + 708) <= (367 + 735)) and (v130 == "All")) then
					if (((2941 + 1765) >= (2059 - (709 + 387))) and not v10.APLVar.RtB_List[v130][v133]) then
						local v170 = 1858 - (673 + 1185);
						for v175 = 2 - 1, #v131 do
							if (v13:BuffUp(v106[v131[v175]]) or ((3082 - 2122) <= (1440 - 564))) then
								v170 = v170 + 1 + 0;
							end
						end
						v10.APLVar.RtB_List[v130][v133] = ((v170 == #v131) and true) or false;
					end
				elseif (not v10.APLVar.RtB_List[v130][v133] or ((1544 + 522) == (1257 - 325))) then
					v10.APLVar.RtB_List[v130][v133] = false;
					for v176 = 1 + 0, #v131 do
						if (((9620 - 4795) < (9506 - 4663)) and v13:BuffUp(v106[v131[v176]])) then
							v10.APLVar.RtB_List[v130][v133] = true;
							break;
						end
					end
				end
				v132 = 1882 - (446 + 1434);
			end
			if ((v132 == (1283 - (1040 + 243))) or ((11571 - 7694) >= (6384 - (559 + 1288)))) then
				if (not v10.APLVar.RtB_List or ((6246 - (609 + 1322)) < (2180 - (13 + 441)))) then
					v10.APLVar.RtB_List = {};
				end
				if (not v10.APLVar.RtB_List[v130] or ((13747 - 10068) < (1637 - 1012))) then
					v10.APLVar.RtB_List[v130] = {};
				end
				v132 = 4 - 3;
			end
		end
	end
	local function v108()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 - 0)) or ((1643 + 2982) < (277 + 355))) then
				if (not v10.APLVar.RtB_Buffs or ((246 - 163) > (975 + 805))) then
					local v165 = 0 - 0;
					local v166;
					while true do
						if (((361 + 185) <= (600 + 477)) and (v165 == (0 + 0))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Total = 0 + 0;
							v165 = 1 + 0;
						end
						if (((434 - (153 + 280)) == v165) or ((2875 - 1879) > (3862 + 439))) then
							v10.APLVar.RtB_Buffs.Normal = 0 + 0;
							v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
							v165 = 2 + 0;
						end
						if (((2950 + 1120) > (1045 - 358)) and (v165 == (2 + 0))) then
							v10.APLVar.RtB_Buffs.Longer = 667 - (89 + 578);
							v166 = v79.RtBRemains();
							v165 = 3 + 0;
						end
						if ((v165 == (5 - 2)) or ((1705 - (572 + 477)) >= (450 + 2880))) then
							for v182 = 1 + 0, #v106 do
								local v183 = 0 + 0;
								local v184;
								while true do
									if ((v183 == (86 - (84 + 2))) or ((4106 - 1614) <= (242 + 93))) then
										v184 = v13:BuffRemains(v106[v182]);
										if (((5164 - (497 + 345)) >= (66 + 2496)) and (v184 > (0 + 0))) then
											v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1334 - (605 + 728));
											if ((v184 == v166) or ((2595 + 1042) >= (8381 - 4611))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
											elseif ((v184 > v166) or ((8795 - 6416) > (4128 + 450))) then
												v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (2 - 1);
											else
												v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + 1 + 0;
											end
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v109()
		local v135 = 489 - (457 + 32);
		while true do
			if ((v135 == (0 + 0)) or ((1885 - (832 + 570)) > (700 + 43))) then
				if (((640 + 1814) > (2045 - 1467)) and not v10.APLVar.RtB_Reroll) then
					if (((448 + 482) < (5254 - (588 + 208))) and (v62 == "1+ Buff")) then
						v10.APLVar.RtB_Reroll = ((v108() <= (0 - 0)) and true) or false;
					elseif (((2462 - (884 + 916)) <= (2034 - 1062)) and (v62 == "Broadside")) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.Broadside) and true) or false;
					elseif (((2534 + 1836) == (5023 - (232 + 421))) and (v62 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.BuriedTreasure) and true) or false;
					elseif ((v62 == "Grand Melee") or ((6651 - (1569 + 320)) <= (212 + 649))) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.GrandMelee) and true) or false;
					elseif ((v62 == "Skull and Crossbones") or ((269 + 1143) == (14368 - 10104))) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.SkullandCrossbones) and true) or false;
					elseif ((v62 == "Ruthless Precision") or ((3773 - (316 + 289)) < (5635 - 3482))) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.RuthlessPrecision) and true) or false;
					elseif ((v62 == "True Bearing") or ((230 + 4746) < (2785 - (666 + 787)))) then
						v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v108();
						if (((5053 - (360 + 65)) == (4326 + 302)) and (v108() <= (256 - (79 + 175))) and v13:BuffUp(v80.BuriedTreasure) and v13:BuffDown(v80.GrandMelee) and (v89 < (2 - 0))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:HasTier(25 + 6, 12 - 8) and ((not v13:BuffUp(v80.TrueBearing) and v80.HiddenOpportunity:IsAvailable()) or (not v13:BuffUp(v80.Broadside) and not v80.HiddenOpportunity:IsAvailable())) and (v108() <= (1 - 0))) or ((953 - (503 + 396)) == (576 - (92 + 89)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((158 - 76) == (43 + 39)) and v80.Crackshot:IsAvailable() and v13:HasTier(19 + 12, 15 - 11) and (v108() <= (1 + 0 + v19(v13:BuffUp(v80.LoadedDiceBuff)))) and (v80.HiddenOpportunity:IsAvailable() or v13:BuffDown(v80.Broadside))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((not v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:BuffUp(v80.SkullandCrossbones) and (v108() < ((4 - 2) + v19(v13:BuffUp(v80.GrandMelee)))) and (v89 < (2 + 0))) or ((278 + 303) < (858 - 576))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (v10.APLVar.RtB_Reroll or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v108() < (1249 - (485 + 759))) and (v79.RtBRemains() <= (89 - 50))) or ((5798 - (442 + 747)) < (3630 - (832 + 303)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((2098 - (88 + 858)) == (352 + 800)) and (v14:FilteredTimeToDie("<", 10 + 2) or v9.BossFilteredFightRemains("<", 1 + 11))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v110()
		return v93 >= ((v79.CPMaxSpend() - (790 - (766 + 23))) - v19((v13:StealthUp(true, true)) and v80.Crackshot:IsAvailable()));
	end
	local function v111()
		return (v80.HiddenOpportunity:IsAvailable() or (v95 >= ((9 - 7) + v19(v80.ImprovedAmbush:IsAvailable()) + v19(v13:BuffUp(v80.Broadside))))) and (v96 >= (68 - 18));
	end
	local function v112()
		return not v25 or (v89 < (4 - 2)) or (v13:BuffRemains(v80.BladeFlurry) > ((3 - 2) + v19(v80.KillingSpree:IsAvailable())));
	end
	local function v113()
		return v65 and (not v13:IsTanking(v14) or v75);
	end
	local function v114()
		return not v80.ShadowDanceTalent:IsAvailable() and ((v80.FanTheHammer:TalentRank() + v19(v80.QuickDraw:IsAvailable()) + v19(v80.Audacity:IsAvailable())) < (v19(v80.CountTheOdds:IsAvailable()) + v19(v80.KeepItRolling:IsAvailable())));
	end
	local function v115()
		return v13:BuffUp(v80.BetweentheEyes) and (not v80.HiddenOpportunity:IsAvailable() or (v13:BuffDown(v80.AudacityBuff) and ((v80.FanTheHammer:TalentRank() < (1075 - (1036 + 37))) or v13:BuffDown(v80.Opportunity)))) and not v80.Crackshot:IsAvailable();
	end
	local function v116()
		if (((1345 + 551) <= (6663 - 3241)) and v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v113() and v80.HiddenOpportunity:IsAvailable() and not v80.Crackshot:IsAvailable() and not v13:BuffUp(v80.Audacity) and (v114() or (v13:BuffStack(v80.Opportunity) < (5 + 1))) and v111()) then
			if (v9.Cast(v80.Vanish, v65) or ((2470 - (641 + 839)) > (2533 - (910 + 3)))) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v113() and (not v80.HiddenOpportunity:IsAvailable() or v80.Crackshot:IsAvailable()) and v110()) or ((2235 - 1358) > (6379 - (1466 + 218)))) then
			if (((1237 + 1454) >= (2999 - (556 + 592))) and v9.Cast(v80.Vanish, v65)) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.Crackshot:IsAvailable() and v110()) or ((1062 + 1923) >= (5664 - (329 + 479)))) then
			if (((5130 - (174 + 680)) >= (4106 - 2911)) and v9.Cast(v80.ShadowDance, v51)) then
				return "Cast Shadow Dance";
			end
		end
		if (((6698 - 3466) <= (3349 + 1341)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and not v80.KeepItRolling:IsAvailable() and v115() and v13:BuffUp(v80.SliceandDice) and (v110() or v80.HiddenOpportunity:IsAvailable()) and (not v80.HiddenOpportunity:IsAvailable() or not v80.Vanish:IsReady())) then
			if (v9.Cast(v80.ShadowDance, v51) or ((1635 - (396 + 343)) >= (279 + 2867))) then
				return "Cast Shadow Dance";
			end
		end
		if (((4538 - (29 + 1448)) >= (4347 - (135 + 1254))) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.KeepItRolling:IsAvailable() and v115() and ((v80.KeepItRolling:CooldownRemains() <= (113 - 83)) or ((v80.KeepItRolling:CooldownRemains() >= (560 - 440)) and (v110() or v80.HiddenOpportunity:IsAvailable())))) then
			if (((2124 + 1063) >= (2171 - (389 + 1138))) and v9.Cast(v80.ShadowDance, v51)) then
				return "Cast Shadow Dance";
			end
		end
		if (((1218 - (102 + 472)) <= (665 + 39)) and v80.Shadowmeld:IsAvailable() and v80.Shadowmeld:IsReady()) then
			if (((532 + 426) > (884 + 63)) and ((v80.Crackshot:IsAvailable() and v110()) or (not v80.Crackshot:IsAvailable() and ((v80.CountTheOdds:IsAvailable() and v110()) or v80.HiddenOpportunity:IsAvailable())))) then
				if (((6037 - (320 + 1225)) >= (4724 - 2070)) and v9.Cast(v80.Shadowmeld, v27)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v117()
		v90 = v78.HandleTopTrinket(v83, v26, 25 + 15, nil);
		if (((4906 - (157 + 1307)) >= (3362 - (821 + 1038))) and v90) then
			return v90;
		end
		v90 = v78.HandleBottomTrinket(v83, v26, 99 - 59, nil);
		if (v90 or ((347 + 2823) <= (2600 - 1136))) then
			return v90;
		end
	end
	local function v118()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (9 - 5)) or ((5823 - (834 + 192)) == (279 + 4109))) then
				if (((142 + 409) <= (15 + 666)) and v80.AncestralCall:IsCastable()) then
					if (((5075 - 1798) > (711 - (300 + 4))) and v9.Cast(v80.AncestralCall, v27)) then
						return "Cast Ancestral Call";
					end
				end
				v90 = v117();
				if (((1254 + 3441) >= (3704 - 2289)) and v90) then
					return v90;
				end
				break;
			end
			if ((v136 == (365 - (112 + 250))) or ((1281 + 1931) <= (2364 - 1420))) then
				if (v80.BloodFury:IsCastable() or ((1774 + 1322) <= (930 + 868))) then
					if (((2646 + 891) == (1754 + 1783)) and v9.Cast(v80.BloodFury, v27)) then
						return "Cast Blood Fury";
					end
				end
				if (((2851 + 986) >= (2984 - (1001 + 413))) and v80.Berserking:IsCastable()) then
					if (v9.Cast(v80.Berserking, v27) or ((6578 - 3628) == (4694 - (244 + 638)))) then
						return "Cast Berserking";
					end
				end
				if (((5416 - (627 + 66)) >= (6906 - 4588)) and v80.Fireblood:IsCastable()) then
					if (v9.Cast(v80.Fireblood, v27) or ((2629 - (512 + 90)) > (4758 - (1665 + 241)))) then
						return "Cast Fireblood";
					end
				end
				v136 = 721 - (373 + 344);
			end
			if ((v136 == (0 + 0)) or ((301 + 835) > (11386 - 7069))) then
				if (((8034 - 3286) == (5847 - (35 + 1064))) and v26 and v80.AdrenalineRush:IsCastable() and (not v13:BuffUp(v80.AdrenalineRush) or (v13:StealthUp(true, true) and v80.Crackshot:IsAvailable() and v80.ImprovedAdrenalineRush:IsAvailable())) and ((v94 <= (2 + 0)) or not v80.ImprovedAdrenalineRush:IsAvailable())) then
					if (((7993 - 4257) <= (19 + 4721)) and v9.Cast(v80.AdrenalineRush, v73)) then
						return "Cast Adrenaline Rush";
					end
				end
				if ((v80.BladeFlurry:IsReady() and (v89 >= ((1238 - (298 + 938)) - v19(v80.UnderhandedUpperhand:IsAvailable()))) and (v13:BuffRemains(v80.BladeFlurry) < v13:GCDRemains())) or (v80.DeftManeuvers:IsAvailable() and (v89 >= (1264 - (233 + 1026))) and not v110()) or ((5056 - (636 + 1030)) <= (1565 + 1495))) then
					if (v68 or ((976 + 23) > (800 + 1893))) then
						v9.CastSuggested(v80.BladeFlurry);
					elseif (((32 + 431) < (822 - (55 + 166))) and v9.Cast(v80.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (v80.RolltheBones:IsReady() or ((424 + 1759) < (70 + 617))) then
					if (((17372 - 12823) == (4846 - (36 + 261))) and (v109() or (v79.RtBRemains() <= (v19(v13:HasTier(53 - 22, 1372 - (34 + 1334))) + (v19((v80.ShadowDance:CooldownRemains() <= (1 + 0)) or (v80.Vanish:CooldownRemains() <= (1 + 0))) * (1289 - (1035 + 248))))))) then
						if (((4693 - (20 + 1)) == (2435 + 2237)) and v9.Cast(v80.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v136 = 320 - (134 + 185);
			end
			if ((v136 == (1134 - (549 + 584))) or ((4353 - (314 + 371)) < (1355 - 960))) then
				if ((v80.KeepItRolling:IsReady() and not v109() and (v108() >= ((971 - (478 + 490)) + v19(v13:HasTier(17 + 14, 1176 - (786 + 386))))) and (v13:BuffDown(v80.ShadowDance) or (v108() >= (19 - 13)))) or ((5545 - (1055 + 324)) == (1795 - (1093 + 247)))) then
					if (v9.Cast(v80.KeepItRolling, v72) or ((3954 + 495) == (281 + 2382))) then
						return "Cast Keep it Rolling";
					end
				end
				if ((v80.GhostlyStrike:IsAvailable() and v80.GhostlyStrike:IsReady()) or ((16980 - 12703) < (10143 - 7154))) then
					if (v9.Cast(v80.GhostlyStrike, v70) or ((2475 - 1605) >= (10425 - 6276))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((787 + 1425) < (12262 - 9079)) and v26 and v80.Sepsis:IsAvailable() and v80.Sepsis:IsReady()) then
					if (((16013 - 11367) > (2257 + 735)) and ((v80.Crackshot:IsAvailable() and v80.BetweentheEyes:IsReady() and v110() and not v13:StealthUp(true, true)) or (not v80.Crackshot:IsAvailable() and v14:FilteredTimeToDie(">", 28 - 17) and v13:BuffUp(v80.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 699 - (364 + 324)))) then
						if (((3931 - 2497) < (7452 - 4346)) and v9.Cast(v80.Sepsis, v76)) then
							return "Cast Sepsis";
						end
					end
				end
				v136 = 1 + 1;
			end
			if (((3288 - 2502) < (4841 - 1818)) and (v136 == (5 - 3))) then
				if ((v80.BladeRush:IsReady() and (v99 > (1272 - (1249 + 19))) and not v13:StealthUp(true, true)) or ((2205 + 237) < (287 - 213))) then
					if (((5621 - (686 + 400)) == (3559 + 976)) and v9.Cast(v80.BladeRush, v69)) then
						return "Cast Blade Rush";
					end
				end
				if (not v13:StealthUp(true, true, true) or ((3238 - (73 + 156)) <= (10 + 2095))) then
					v90 = v116();
					if (((2641 - (721 + 90)) < (42 + 3627)) and v90) then
						return v90;
					end
				end
				if ((v26 and v80.ThistleTea:IsAvailable() and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and ((v98 >= (324 - 224)) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (476 - (224 + 246))))) or ((2316 - 886) >= (6650 - 3038))) then
					if (((487 + 2196) >= (59 + 2401)) and v9.Cast(v80.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				v136 = 3 + 0;
			end
		end
	end
	local function v119()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (6 - 4)) or ((2317 - (203 + 310)) >= (5268 - (1238 + 755)))) then
				if ((v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and v80.Crackshot:IsAvailable() and (v80.FanTheHammer:TalentRank() >= (1 + 1)) and (v13:BuffStack(v80.Opportunity) >= (1540 - (709 + 825))) and ((v13:BuffUp(v80.Broadside) and (v94 <= (1 - 0))) or v13:BuffUp(v80.GreenskinsWickersBuff))) or ((2064 - 647) > (4493 - (196 + 668)))) then
					if (((18932 - 14137) > (832 - 430)) and v9.Press(v80.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((5646 - (171 + 662)) > (3658 - (4 + 89))) and v80.Ambush:IsCastable() and v14:IsSpellInRange(v80.Ambush) and v80.HiddenOpportunity:IsAvailable()) then
					if (((13711 - 9799) == (1425 + 2487)) and v9.Press(v80.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((12390 - 9569) <= (1892 + 2932)) and ((1487 - (35 + 1451)) == v137)) then
				if (((3191 - (28 + 1425)) <= (4188 - (941 + 1052))) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v110() and v80.Crackshot:IsAvailable()) then
					if (((40 + 1) <= (4532 - (822 + 692))) and v9.Press(v80.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((3061 - 916) <= (1934 + 2170)) and v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch) and v110()) then
					if (((2986 - (45 + 252)) < (4794 + 51)) and v9.Press(v80.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v137 = 1 + 1;
			end
			if ((v137 == (0 - 0)) or ((2755 - (114 + 319)) > (3764 - 1142))) then
				if ((v80.BladeFlurry:IsReady() and v80.BladeFlurry:IsCastable() and v25 and v80.Subterfuge:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and (v89 >= (2 - 0)) and (v13:BuffRemains(v80.BladeFlurry) <= v13:GCDRemains())) or ((2891 + 1643) == (3101 - 1019))) then
					if (v68 or ((3291 - 1720) > (3830 - (556 + 1407)))) then
						v9.CastSuggested(v80.BladeFlurry);
					elseif (v9.Cast(v80.BladeFlurry) or ((3860 - (741 + 465)) >= (3461 - (170 + 295)))) then
						return "Cast Blade Flurry";
					end
				end
				if (((2096 + 1882) > (1933 + 171)) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch) and v110()) then
					if (((7373 - 4378) > (1278 + 263)) and v9.Cast(v80.ColdBlood, v53)) then
						return "Cast Cold Blood";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v120()
		local v138 = 0 + 0;
		while true do
			if (((4479 - (957 + 273)) > (255 + 698)) and (v138 == (0 + 0))) then
				if ((v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and not v80.Crackshot:IsAvailable() and ((v13:BuffRemains(v80.BetweentheEyes) < (15 - 11)) or v80.ImprovedBetweenTheEyes:IsAvailable() or v80.GreenskinsWickers:IsAvailable() or v13:HasTier(79 - 49, 11 - 7)) and v13:BuffDown(v80.GreenskinsWickers)) or ((16206 - 12933) > (6353 - (389 + 1391)))) then
					if (v9.Press(v80.BetweentheEyes) or ((1977 + 1174) < (134 + 1150))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v80.Crackshot:IsAvailable() and (v80.Vanish:CooldownRemains() > (102 - 57)) and (v80.ShadowDance:CooldownRemains() > (963 - (783 + 168)))) or ((6208 - 4358) == (1504 + 25))) then
					if (((1132 - (309 + 2)) < (6519 - 4396)) and v9.Press(v80.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v138 = 1213 - (1090 + 122);
			end
			if (((293 + 609) < (7808 - 5483)) and (v138 == (1 + 0))) then
				if (((1976 - (628 + 490)) <= (532 + 2430)) and v80.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v88, ">", v13:BuffRemains(v80.SliceandDice), true) or (v13:BuffRemains(v80.SliceandDice) == (0 - 0))) and (v13:BuffRemains(v80.SliceandDice) < (((4 - 3) + v94) * (775.8 - (431 + 343))))) then
					if (v9.Press(v80.SliceandDice) or ((7969 - 4023) < (3726 - 2438))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v80.KillingSpree:IsCastable() and v14:IsSpellInRange(v80.KillingSpree) and (v14:DebuffUp(v80.GhostlyStrike) or not v80.GhostlyStrike:IsAvailable())) or ((2562 + 680) == (73 + 494))) then
					if (v9.Cast(v80.KillingSpree) or ((2542 - (556 + 1139)) >= (1278 - (6 + 9)))) then
						return "Cast Killing Spree";
					end
				end
				v138 = 1 + 1;
			end
			if ((v138 == (2 + 0)) or ((2422 - (28 + 141)) == (717 + 1134))) then
				if ((v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch)) or ((2575 - 488) > (1680 + 692))) then
					if (v9.Cast(v80.ColdBlood, v53) or ((5762 - (486 + 831)) < (10796 - 6647))) then
						return "Cast Cold Blood";
					end
				end
				if ((v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch)) or ((6400 - 4582) == (17 + 68))) then
					if (((1992 - 1362) < (3390 - (668 + 595))) and v9.Press(v80.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (0 + 0)) or ((5285 - 3347) == (2804 - (23 + 267)))) then
				if (((6199 - (1129 + 815)) >= (442 - (371 + 16))) and v26 and v80.EchoingReprimand:IsReady()) then
					if (((4749 - (1326 + 424)) > (2188 - 1032)) and v9.Cast(v80.EchoingReprimand, nil, v74)) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((8587 - 6237) > (1273 - (88 + 30))) and v80.Ambush:IsCastable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.AudacityBuff)) then
					if (((4800 - (720 + 51)) <= (10795 - 5942)) and v9.Press(v80.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v139 = 1777 - (421 + 1355);
			end
			if ((v139 == (1 - 0)) or ((254 + 262) > (4517 - (286 + 797)))) then
				if (((14790 - 10744) >= (5023 - 1990)) and v80.FanTheHammer:IsAvailable() and v80.Audacity:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.Opportunity) and v13:BuffDown(v80.AudacityBuff)) then
					if (v9.Press(v80.PistolShot) or ((3158 - (397 + 42)) <= (452 + 995))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v13:BuffUp(v80.GreenskinsWickersBuff) and ((not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity)) or (v13:BuffRemains(v80.GreenskinsWickersBuff) < (801.5 - (24 + 776))))) or ((6368 - 2234) < (4711 - (222 + 563)))) then
					if (v9.Press(v80.PistolShot) or ((360 - 196) >= (2006 + 779))) then
						return "Cast Pistol Shot (GSW Dump)";
					end
				end
				v139 = 192 - (23 + 167);
			end
			if (((1801 - (690 + 1108)) == v139) or ((190 + 335) == (1740 + 369))) then
				if (((881 - (40 + 808)) == (6 + 27)) and not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v99 > (3.5 - 2)) or (v95 <= (1 + 0 + v19(v13:BuffUp(v80.Broadside)))) or v80.QuickDraw:IsAvailable() or (v80.Audacity:IsAvailable() and v13:BuffDown(v80.AudacityBuff)))) then
					if (((1616 + 1438) <= (2202 + 1813)) and v9.Press(v80.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((2442 - (47 + 524)) < (2195 + 1187)) and v80.SinisterStrike:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) then
					if (((3534 - 2241) <= (3238 - 1072)) and v9.Press(v80.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((4 - 2) == v139) or ((4305 - (1165 + 561)) < (4 + 119))) then
				if ((v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v13:BuffStack(v80.Opportunity) >= (18 - 12)) or (v13:BuffRemains(v80.Opportunity) < (1 + 1)))) or ((1325 - (341 + 138)) >= (640 + 1728))) then
					if (v9.Press(v80.PistolShot) or ((8279 - 4267) <= (3684 - (89 + 237)))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				if (((4805 - 3311) <= (6326 - 3321)) and v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and (v95 > ((882 - (581 + 300)) + (v19(v80.QuickDraw:IsAvailable()) * v80.FanTheHammer:TalentRank()))) and ((not v80.Vanish:IsReady() and not v80.ShadowDance:IsReady()) or v13:StealthUp(true, true) or not v80.Crackshot:IsAvailable() or (v80.FanTheHammer:TalentRank() <= (1221 - (855 + 365))))) then
					if (v9.Press(v80.PistolShot) or ((7389 - 4278) == (697 + 1437))) then
						return "Cast Pistol Shot";
					end
				end
				v139 = 1238 - (1030 + 205);
			end
		end
	end
	local function v122()
		local v140 = 0 + 0;
		while true do
			if (((2191 + 164) == (2641 - (156 + 130))) and (v140 == (17 - 9))) then
				if (v78.TargetIsValid() or ((990 - 402) <= (884 - 452))) then
					local v167 = 0 + 0;
					while true do
						if (((2798 + 1999) >= (3964 - (10 + 59))) and (v167 == (0 + 0))) then
							v90 = v118();
							if (((17615 - 14038) == (4740 - (671 + 492))) and v90) then
								return "CDs: " .. v90;
							end
							if (((3021 + 773) > (4908 - (369 + 846))) and (v13:StealthUp(true, true) or v13:BuffUp(v80.Shadowmeld))) then
								local v187 = 0 + 0;
								while true do
									if ((v187 == (0 + 0)) or ((3220 - (1036 + 909)) == (3260 + 840))) then
										v90 = v119();
										if (v90 or ((2670 - 1079) >= (3783 - (11 + 192)))) then
											return "Stealth: " .. v90;
										end
										break;
									end
								end
							end
							if (((497 + 486) <= (1983 - (135 + 40))) and v110()) then
								local v188 = 0 - 0;
								while true do
									if ((v188 == (0 + 0)) or ((4736 - 2586) <= (1793 - 596))) then
										v90 = v120();
										if (((3945 - (50 + 126)) >= (3266 - 2093)) and v90) then
											return "Finish: " .. v90;
										end
										break;
									end
								end
							end
							v167 = 1 + 0;
						end
						if (((2898 - (1233 + 180)) == (2454 - (522 + 447))) and ((1422 - (107 + 1314)) == v167)) then
							v90 = v121();
							if (v90 or ((1539 + 1776) <= (8476 - 5694))) then
								return "Build: " .. v90;
							end
							if ((v80.ArcaneTorrent:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike) and (v98 > (7 + 8 + v97))) or ((1739 - 863) >= (11727 - 8763))) then
								if (v9.Cast(v80.ArcaneTorrent, v27) or ((4142 - (716 + 1194)) > (43 + 2454))) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v80.ArcanePulse:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) or ((227 + 1883) <= (835 - (74 + 429)))) then
								if (((7110 - 3424) > (1573 + 1599)) and v9.Cast(v80.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							v167 = 4 - 2;
						end
						if ((v167 == (2 + 0)) or ((13793 - 9319) < (2027 - 1207))) then
							if (((4712 - (279 + 154)) >= (3660 - (454 + 324))) and v80.LightsJudgment:IsCastable() and v14:IsInMeleeRange(4 + 1)) then
								if (v9.Cast(v80.LightsJudgment, v27) or ((2046 - (12 + 5)) >= (1899 + 1622))) then
									return "Cast Lights Judgment";
								end
							end
							if ((v80.BagofTricks:IsCastable() and v14:IsInMeleeRange(12 - 7)) or ((753 + 1284) >= (5735 - (277 + 816)))) then
								if (((7349 - 5629) < (5641 - (1058 + 125))) and v9.Cast(v80.BagofTricks, v27)) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and not v14:IsInRange(v91) and not v13:StealthUp(true, true) and (v98 < (5 + 20)) and ((v95 >= (976 - (815 + 160))) or (v99 <= (4.2 - 3)))) or ((1034 - 598) > (721 + 2300))) then
								if (((2084 - 1371) <= (2745 - (41 + 1857))) and v9.Cast(v80.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((4047 - (1222 + 671)) <= (10418 - 6387)) and v80.SinisterStrike:IsCastable()) then
								if (((6633 - 2018) == (5797 - (229 + 953))) and v9.Cast(v80.SinisterStrike)) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1779 - (1111 + 663)) == v140) or ((5369 - (874 + 705)) == (70 + 430))) then
				v90 = v79.CrimsonVial();
				if (((61 + 28) < (459 - 238)) and v90) then
					return v90;
				end
				v79.Poisons();
				v140 = 1 + 5;
			end
			if (((2733 - (642 + 37)) >= (325 + 1096)) and ((2 + 5) == v140)) then
				if (((1737 - 1045) < (3512 - (233 + 221))) and not v13:AffectingCombat() and not v13:IsMounted() and v57) then
					local v168 = 0 - 0;
					while true do
						if ((v168 == (0 + 0)) or ((4795 - (718 + 823)) == (1042 + 613))) then
							v90 = v79.Stealth(v80.Stealth2, nil);
							if (v90 or ((2101 - (266 + 539)) == (13901 - 8991))) then
								return "Stealth (OOC): " .. v90;
							end
							break;
						end
					end
				end
				if (((4593 - (636 + 589)) == (7994 - 4626)) and not v13:AffectingCombat() and (v80.Vanish:TimeSinceLastCast() > (1 - 0)) and v14:IsInRange(7 + 1) and v24) then
					if (((961 + 1682) < (4830 - (657 + 358))) and v78.TargetIsValid() and v14:IsInRange(26 - 16) and not (v13:IsChanneling() or v13:IsCasting())) then
						local v174 = 0 - 0;
						while true do
							if (((3100 - (1151 + 36)) > (477 + 16)) and (v174 == (1 + 0))) then
								if (((14200 - 9445) > (5260 - (1552 + 280))) and v78.TargetIsValid()) then
									local v190 = 834 - (64 + 770);
									while true do
										if (((938 + 443) <= (5377 - 3008)) and (v190 == (1 + 1))) then
											if (v80.SinisterStrike:IsCastable() or ((6086 - (157 + 1086)) == (8174 - 4090))) then
												if (((20448 - 15779) > (556 - 193)) and v9.Cast(v80.SinisterStrike)) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v190 == (0 - 0)) or ((2696 - (599 + 220)) >= (6248 - 3110))) then
											if (((6673 - (1813 + 118)) >= (2651 + 975)) and v80.AdrenalineRush:IsReady() and v80.ImprovedAdrenalineRush:IsAvailable() and (v94 <= (1219 - (841 + 376)))) then
												if (v9.Cast(v80.AdrenalineRush) or ((6361 - 1821) == (213 + 703))) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											if ((v80.RolltheBones:IsReady() and not v13:DebuffUp(v80.Dreadblades) and ((v108() == (0 - 0)) or v109())) or ((2015 - (464 + 395)) > (11150 - 6805))) then
												if (((1075 + 1162) < (5086 - (467 + 370))) and v9.Cast(v80.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											v190 = 1 - 0;
										end
										if ((v190 == (1 + 0)) or ((9197 - 6514) < (4 + 19))) then
											if (((1621 - 924) <= (1346 - (150 + 370))) and v80.SliceandDice:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (((1283 - (74 + 1208)) + v94) * (2.8 - 1)))) then
												if (((5240 - 4135) <= (837 + 339)) and v9.Press(v80.SliceandDice)) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((3769 - (14 + 376)) <= (6611 - 2799)) and v13:StealthUp(true, false)) then
												local v197 = 0 + 0;
												while true do
													if ((v197 == (0 + 0)) or ((752 + 36) >= (4735 - 3119))) then
														v90 = v119();
														if (((1395 + 459) <= (3457 - (23 + 55))) and v90) then
															return "Stealth (Opener): " .. v90;
														end
														v197 = 2 - 1;
													end
													if (((3036 + 1513) == (4085 + 464)) and (v197 == (1 - 0))) then
														if ((v80.KeepItRolling:IsAvailable() and v80.GhostlyStrike:IsAvailable() and v80.EchoingReprimand:IsAvailable()) or ((951 + 2071) >= (3925 - (652 + 249)))) then
															if (((12899 - 8079) > (4066 - (708 + 1160))) and v9.Cast(v80.GhostlyStrike)) then
																return "Cast Ghostly Strike KiR (Opener)";
															end
														end
														if (v80.Ambush:IsCastable() or ((2879 - 1818) >= (8917 - 4026))) then
															if (((1391 - (10 + 17)) <= (1005 + 3468)) and v9.Cast(v80.Ambush)) then
																return "Cast Ambush (Opener)";
															end
														end
														break;
													end
												end
											elseif (v110() or ((5327 - (1400 + 332)) <= (5 - 2))) then
												v90 = v120();
												if (v90 or ((6580 - (242 + 1666)) == (1649 + 2203))) then
													return "Finish (Opener): " .. v90;
												end
											end
											v190 = 1 + 1;
										end
									end
								end
								return;
							end
							if (((1329 + 230) == (2499 - (850 + 90))) and (v174 == (0 - 0))) then
								if ((v80.BladeFlurry:IsReady() and v13:BuffDown(v80.BladeFlurry) and v80.UnderhandedUpperhand:IsAvailable() and not v13:StealthUp(true, true)) or ((3142 - (360 + 1030)) <= (698 + 90))) then
									if (v9.Cast(v80.BladeFlurry) or ((11027 - 7120) == (243 - 66))) then
										return "Blade Flurry (Opener)";
									end
								end
								if (((5131 - (909 + 752)) > (1778 - (109 + 1114))) and not v13:StealthUp(true, false)) then
									local v191 = 0 - 0;
									while true do
										if ((v191 == (0 + 0)) or ((1214 - (6 + 236)) == (407 + 238))) then
											v90 = v79.Stealth(v79.StealthSpell());
											if (((2562 + 620) >= (4988 - 2873)) and v90) then
												return v90;
											end
											break;
										end
									end
								end
								v174 = 1 - 0;
							end
						end
					end
				end
				if (((5026 - (1076 + 57)) < (729 + 3700)) and v80.FanTheHammer:IsAvailable() and (v80.PistolShot:TimeSinceLastCast() < v13:GCDRemains())) then
					v94 = v23(v94, v79.FanTheHammerCP());
				end
				v140 = 697 - (579 + 110);
			end
			if ((v140 == (1 + 2)) or ((2535 + 332) < (1012 + 893))) then
				v100 = (v13:BuffUp(v80.AdrenalineRush, nil, true) and -(457 - (174 + 233))) or (0 - 0);
				v96 = v105();
				v97 = v13:EnergyRegen();
				v140 = 6 - 2;
			end
			if ((v140 == (2 + 2)) or ((2970 - (663 + 511)) >= (3614 + 437))) then
				v99 = v104(v100);
				v98 = v13:EnergyDeficitPredicted(nil, v100);
				if (((352 + 1267) <= (11579 - 7823)) and v25) then
					local v169 = 0 + 0;
					while true do
						if (((1421 - 817) == (1461 - 857)) and ((0 + 0) == v169)) then
							v87 = v13:GetEnemiesInRange(58 - 28);
							v88 = v13:GetEnemiesInRange(v91);
							v169 = 1 + 0;
						end
						if ((v169 == (1 + 0)) or ((5206 - (478 + 244)) == (1417 - (440 + 77)))) then
							v89 = #v88;
							break;
						end
					end
				else
					v89 = 1 + 0;
				end
				v140 = 18 - 13;
			end
			if ((v140 == (1558 - (655 + 901))) or ((827 + 3632) <= (853 + 260))) then
				v94 = v13:ComboPoints();
				v93 = v79.EffectiveComboPoints(v94);
				v95 = v13:ComboPointsDeficit();
				v140 = 3 + 0;
			end
			if (((14631 - 10999) > (4843 - (695 + 750))) and (v140 == (0 - 0))) then
				v77();
				v24 = EpicSettings.Toggles['ooc'];
				v25 = EpicSettings.Toggles['aoe'];
				v140 = 1 - 0;
			end
			if (((16416 - 12334) <= (5268 - (285 + 66))) and (v140 == (2 - 1))) then
				v26 = EpicSettings.Toggles['cds'];
				v91 = (v80.AcrobaticStrikes:IsAvailable() and (1319 - (682 + 628))) or (1 + 5);
				v92 = v80.Dispatch:Damage() * (300.25 - (176 + 123));
				v140 = 1 + 1;
			end
			if (((3506 + 1326) >= (1655 - (239 + 30))) and (v140 == (2 + 4))) then
				if (((132 + 5) == (242 - 105)) and v81.Healthstone:IsReady() and (v13:HealthPercentage() < v33) and not (v13:IsChanneling() or v13:IsCasting())) then
					if (v9.Cast(v82.Healthstone) or ((4898 - 3328) >= (4647 - (306 + 9)))) then
						return "Healthstone ";
					end
				end
				if ((v81.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v31) and not (v13:IsChanneling() or v13:IsCasting())) or ((14181 - 10117) <= (317 + 1502))) then
					if (v9.Cast(v82.RefreshingHealingPotion) or ((3060 + 1926) < (758 + 816))) then
						return "RefreshingHealingPotion ";
					end
				end
				if (((12656 - 8230) > (1547 - (1140 + 235))) and v80.Feint:IsCastable() and (v13:HealthPercentage() <= v56) and not (v13:IsChanneling() or v13:IsCasting())) then
					if (((373 + 213) > (418 + 37)) and v9.Cast(v80.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v140 = 2 + 5;
			end
		end
	end
	local function v123()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(312 - (33 + 19), v122, v123);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

