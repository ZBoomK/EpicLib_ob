local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1915 + 1644) <= (1866 - (1411 + 29)))) then
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
			if (((4724 - 3716) <= (36 + 3675)) and (v124 == (0 - 0))) then
				v27 = EpicSettings.Settings['UseRacials'];
				v29 = EpicSettings.Settings['UseHealingPotion'];
				v30 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v124 = 1392 - (157 + 1234);
			end
			if ((v124 == (9 - 3)) or ((2604 - (991 + 564)) <= (593 + 313))) then
				v65 = EpicSettings.Settings['UseDPSVanish'];
				v68 = EpicSettings.Settings['BladeFlurryGCD'] or (1559 - (1381 + 178));
				v69 = EpicSettings.Settings['BladeRushGCD'];
				v124 = 7 + 0;
			end
			if (((3640 + 873) > (1163 + 1563)) and (v124 == (27 - 19))) then
				v74 = EpicSettings.Settings['EchoingReprimand'];
				v75 = EpicSettings.Settings['UseSoloVanish'];
				v76 = EpicSettings.Settings['sepsis'];
				break;
			end
			if ((v124 == (3 + 1)) or ((1951 - (381 + 89)) >= (2358 + 300))) then
				v53 = EpicSettings.Settings['ColdBloodOffGCD'];
				v54 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v55 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v124 = 8 - 3;
			end
			if ((v124 == (1158 - (1074 + 82))) or ((7056 - 3836) == (3148 - (214 + 1570)))) then
				v34 = EpicSettings.Settings['InterruptWithStun'] or (1455 - (990 + 465));
				v35 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v36 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v124 = 3 + 0;
			end
			if ((v124 == (27 - 20)) or ((2780 - (1668 + 58)) > (4018 - (512 + 114)))) then
				v70 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v72 = EpicSettings.Settings['KeepItRollingGCD'];
				v73 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v124 = 20 - 12;
			end
			if ((v124 == (5 - 2)) or ((2352 - 1676) >= (764 + 878))) then
				v50 = EpicSettings.Settings['VanishOffGCD'];
				v51 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v52 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v124 = 1 + 3;
			end
			if (((3596 + 540) > (8084 - 5687)) and (v124 == (1995 - (109 + 1885)))) then
				v31 = EpicSettings.Settings['HealingPotionHP'] or (1469 - (1269 + 200));
				v32 = EpicSettings.Settings['UseHealthstone'];
				v33 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v124 = 817 - (98 + 717);
			end
			if ((v124 == (831 - (802 + 24))) or ((7473 - 3139) == (5361 - 1116))) then
				v56 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v57 = EpicSettings.Settings['StealthOOC'];
				v62 = EpicSettings.Settings['RolltheBonesLogic'];
				v124 = 5 + 1;
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
	local v85 = (v84[43 - 30] and v17(v84[5 + 8])) or v17(0 + 0);
	local v86 = (v84[12 + 2] and v17(v84[11 + 3])) or v17(0 + 0);
	v9:RegisterForEvent(function()
		v84 = v13:GetEquipment();
		v85 = (v84[1446 - (797 + 636)] and v17(v84[63 - 50])) or v17(1619 - (1427 + 192));
		v86 = (v84[5 + 9] and v17(v84[32 - 18])) or v17(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v80.Dispatch:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v79.CPSpend() * (0.3 + 0) * (327 - (192 + 134)) * ((1277 - (316 + 960)) + (v13:VersatilityDmgPct() / (56 + 44))) * ((v14:DebuffUp(v80.GhostlyStrike) and (1.1 + 0)) or (1 + 0));
	end);
	local v87, v88, v89;
	local v90;
	local v91 = 22 - 16;
	local v92;
	local v93, v94, v95;
	local v96, v97, v98, v99, v100;
	local v101 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v102, v103 = 0 - 0, 325 - (45 + 280);
	local function v104(v125)
		local v126 = 0 + 0;
		local v127;
		while true do
			if (((0 + 0) == v126) or ((1562 + 2714) <= (1678 + 1353))) then
				v127 = v13:EnergyTimeToMaxPredicted(nil, v125);
				if ((v127 < v102) or ((v127 - v102) > (0.5 + 0)) or ((8854 - 4072) <= (3110 - (340 + 1571)))) then
					v102 = v127;
				end
				v126 = 1 + 0;
			end
			if ((v126 == (1773 - (1733 + 39))) or ((13365 - 8501) < (2936 - (125 + 909)))) then
				return v102;
			end
		end
	end
	local function v105()
		local v128 = 1948 - (1096 + 852);
		local v129;
		while true do
			if (((2171 + 2668) >= (5283 - 1583)) and (v128 == (0 + 0))) then
				v129 = v13:EnergyPredicted();
				if ((v129 > v103) or ((v129 - v103) > (521 - (409 + 103))) or ((1311 - (46 + 190)) > (2013 - (51 + 44)))) then
					v103 = v129;
				end
				v128 = 1 + 0;
			end
			if (((1713 - (1114 + 203)) <= (4530 - (228 + 498))) and ((1 + 0) == v128)) then
				return v103;
			end
		end
	end
	local v106 = {v80.Broadside,v80.BuriedTreasure,v80.GrandMelee,v80.RuthlessPrecision,v80.SkullandCrossbones,v80.TrueBearing};
	local function v107(v130, v131)
		local v132 = 0 + 0;
		local v133;
		while true do
			if ((v132 == (1163 - (171 + 991))) or ((17181 - 13012) == (5872 - 3685))) then
				v133 = table.concat(v131);
				if (((3508 - 2102) == (1126 + 280)) and (v130 == "All")) then
					if (((5366 - 3835) < (12320 - 8049)) and not v10.APLVar.RtB_List[v130][v133]) then
						local v168 = 0 - 0;
						for v172 = 3 - 2, #v131 do
							if (((1883 - (111 + 1137)) == (793 - (91 + 67))) and v13:BuffUp(v106[v131[v172]])) then
								v168 = v168 + (2 - 1);
							end
						end
						v10.APLVar.RtB_List[v130][v133] = ((v168 == #v131) and true) or false;
					end
				elseif (((842 + 2531) <= (4079 - (423 + 100))) and not v10.APLVar.RtB_List[v130][v133]) then
					local v170 = 0 + 0;
					while true do
						if ((v170 == (0 - 0)) or ((1716 + 1575) < (4051 - (326 + 445)))) then
							v10.APLVar.RtB_List[v130][v133] = false;
							for v183 = 4 - 3, #v131 do
								if (((9770 - 5384) >= (2037 - 1164)) and v13:BuffUp(v106[v131[v183]])) then
									v10.APLVar.RtB_List[v130][v133] = true;
									break;
								end
							end
							break;
						end
					end
				end
				v132 = 713 - (530 + 181);
			end
			if (((1802 - (614 + 267)) <= (1134 - (19 + 13))) and (v132 == (2 - 0))) then
				return v10.APLVar.RtB_List[v130][v133];
			end
			if (((10966 - 6260) >= (2750 - 1787)) and (v132 == (0 + 0))) then
				if (not v10.APLVar.RtB_List or ((1688 - 728) <= (1816 - 940))) then
					v10.APLVar.RtB_List = {};
				end
				if (not v10.APLVar.RtB_List[v130] or ((3878 - (1293 + 519)) == (1900 - 968))) then
					v10.APLVar.RtB_List[v130] = {};
				end
				v132 = 2 - 1;
			end
		end
	end
	local function v108()
		local v134 = 0 - 0;
		while true do
			if (((20805 - 15980) < (11408 - 6565)) and (v134 == (0 + 0))) then
				if (not v10.APLVar.RtB_Buffs or ((791 + 3086) >= (10541 - 6004))) then
					local v162 = 0 + 0;
					local v163;
					while true do
						if ((v162 == (1 + 2)) or ((2697 + 1618) < (2822 - (709 + 387)))) then
							for v179 = 1859 - (673 + 1185), #v106 do
								local v180 = v13:BuffRemains(v106[v179]);
								if ((v180 > (0 - 0)) or ((11813 - 8134) < (1028 - 403))) then
									local v184 = 0 + 0;
									while true do
										if ((v184 == (0 + 0)) or ((6244 - 1619) < (156 + 476))) then
											v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1 - 0);
											if ((v180 == v163) or ((162 - 79) > (3660 - (446 + 1434)))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (1284 - (1040 + 243));
											elseif (((1629 - 1083) <= (2924 - (559 + 1288))) and (v180 > v163)) then
												v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (1932 - (609 + 1322));
											else
												v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (455 - (13 + 441));
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((v162 == (7 - 5)) or ((2608 - 1612) > (21420 - 17119))) then
							v10.APLVar.RtB_Buffs.Longer = 0 + 0;
							v163 = v79.RtBRemains();
							v162 = 10 - 7;
						end
						if (((1446 + 2624) > (302 + 385)) and (v162 == (0 - 0))) then
							v10.APLVar.RtB_Buffs = {};
							v10.APLVar.RtB_Buffs.Total = 0 + 0;
							v162 = 1 - 0;
						end
						if ((v162 == (1 + 0)) or ((365 + 291) >= (2393 + 937))) then
							v10.APLVar.RtB_Buffs.Normal = 0 + 0;
							v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
							v162 = 435 - (153 + 280);
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v109()
		if (not v10.APLVar.RtB_Reroll or ((7195 - 4703) <= (301 + 34))) then
			if (((1707 + 2615) >= (1341 + 1221)) and (v62 == "1+ Buff")) then
				v10.APLVar.RtB_Reroll = ((v108() <= (0 + 0)) and true) or false;
			elseif ((v62 == "Broadside") or ((2636 + 1001) >= (5740 - 1970))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.Broadside) and true) or false;
			elseif ((v62 == "Buried Treasure") or ((1471 + 908) > (5245 - (89 + 578)))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.BuriedTreasure) and true) or false;
			elseif ((v62 == "Grand Melee") or ((346 + 137) > (1544 - 801))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.GrandMelee) and true) or false;
			elseif (((3503 - (572 + 477)) > (78 + 500)) and (v62 == "Skull and Crossbones")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.SkullandCrossbones) and true) or false;
			elseif (((559 + 371) < (533 + 3925)) and (v62 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.RuthlessPrecision) and true) or false;
			elseif (((748 - (84 + 2)) <= (1601 - 629)) and (v62 == "True Bearing")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.TrueBearing) and true) or false;
			else
				v10.APLVar.RtB_Reroll = false;
				v108();
				if (((3149 + 1221) == (5212 - (497 + 345))) and (v108() <= (1 + 1)) and v13:BuffUp(v80.BuriedTreasure) and v13:BuffDown(v80.GrandMelee) and (v89 < (1 + 1))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:HasTier(1364 - (605 + 728), 3 + 1) and ((not v13:BuffUp(v80.TrueBearing) and v80.HiddenOpportunity:IsAvailable()) or (not v13:BuffUp(v80.Broadside) and not v80.HiddenOpportunity:IsAvailable())) and (v108() <= (1 - 0))) or ((219 + 4543) <= (3183 - 2322))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v80.Crackshot:IsAvailable() and v13:HasTier(28 + 3, 10 - 6) and (v108() <= (1 + 0 + v19(v13:BuffUp(v80.LoadedDiceBuff)))) and (v80.HiddenOpportunity:IsAvailable() or v13:BuffDown(v80.Broadside))) or ((1901 - (457 + 32)) == (1810 + 2454))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((not v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:BuffUp(v80.SkullandCrossbones) and (v108() < ((1404 - (832 + 570)) + v19(v13:BuffUp(v80.GrandMelee)))) and (v89 < (2 + 0))) or ((827 + 2341) < (7618 - 5465))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (v10.APLVar.RtB_Reroll or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (797 - (588 + 208))) and (v108() < (13 - 8)) and (v79.RtBRemains() <= (1839 - (884 + 916)))) or ((10417 - 5441) < (773 + 559))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((5281 - (232 + 421)) == (6517 - (1569 + 320))) and (v14:FilteredTimeToDie("<", 3 + 9) or v9.BossFilteredFightRemains("<", 3 + 9))) then
					v10.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v110()
		return v93 >= ((v79.CPMaxSpend() - (3 - 2)) - v19((v13:StealthUp(true, true)) and v80.Crackshot:IsAvailable()));
	end
	local function v111()
		return (v80.HiddenOpportunity:IsAvailable() or (v95 >= ((607 - (316 + 289)) + v19(v80.ImprovedAmbush:IsAvailable()) + v19(v13:BuffUp(v80.Broadside))))) and (v96 >= (130 - 80));
	end
	local function v112()
		return not v25 or (v89 < (1 + 1)) or (v13:BuffRemains(v80.BladeFlurry) > ((1454 - (666 + 787)) + v19(v80.KillingSpree:IsAvailable())));
	end
	local function v113()
		return v65 and (not v13:IsTanking(v14) or v75);
	end
	local function v114()
		return not v80.ShadowDanceTalent:IsAvailable() and ((v80.FanTheHammer:TalentRank() + v19(v80.QuickDraw:IsAvailable()) + v19(v80.Audacity:IsAvailable())) < (v19(v80.CountTheOdds:IsAvailable()) + v19(v80.KeepItRolling:IsAvailable())));
	end
	local function v115()
		return v13:BuffUp(v80.BetweentheEyes) and (not v80.HiddenOpportunity:IsAvailable() or (v13:BuffDown(v80.AudacityBuff) and ((v80.FanTheHammer:TalentRank() < (427 - (360 + 65))) or v13:BuffDown(v80.Opportunity)))) and not v80.Crackshot:IsAvailable();
	end
	local function v116()
		if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v113() and v80.HiddenOpportunity:IsAvailable() and not v80.Crackshot:IsAvailable() and not v13:BuffUp(v80.Audacity) and (v114() or (v13:BuffStack(v80.Opportunity) < (6 + 0))) and v111()) or ((308 - (79 + 175)) == (622 - 227))) then
			if (((64 + 18) == (251 - 169)) and v9.Cast(v80.Vanish, v65)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v113() and (not v80.HiddenOpportunity:IsAvailable() or v80.Crackshot:IsAvailable()) and v110()) or ((1118 - 537) < (1181 - (503 + 396)))) then
			if (v9.Cast(v80.Vanish, v65) or ((4790 - (92 + 89)) < (4839 - 2344))) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((591 + 561) == (682 + 470)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.Crackshot:IsAvailable() and v110()) then
			if (((7424 - 5528) <= (468 + 2954)) and v9.Cast(v80.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and not v80.KeepItRolling:IsAvailable() and v115() and v13:BuffUp(v80.SliceandDice) and (v110() or v80.HiddenOpportunity:IsAvailable()) and (not v80.HiddenOpportunity:IsAvailable() or not v80.Vanish:IsReady())) or ((2257 - 1267) > (1414 + 206))) then
			if (v9.Cast(v80.ShadowDance) or ((419 + 458) > (14299 - 9604))) then
				return "Cast Shadow Dance";
			end
		end
		if (((336 + 2355) >= (2822 - 971)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.KeepItRolling:IsAvailable() and v115() and ((v80.KeepItRolling:CooldownRemains() <= (1274 - (485 + 759))) or ((v80.KeepItRolling:CooldownRemains() >= (277 - 157)) and (v110() or v80.HiddenOpportunity:IsAvailable())))) then
			if (v9.Cast(v80.ShadowDance) or ((4174 - (442 + 747)) >= (5991 - (832 + 303)))) then
				return "Cast Shadow Dance";
			end
		end
		if (((5222 - (88 + 858)) >= (365 + 830)) and v80.Shadowmeld:IsAvailable() and v80.Shadowmeld:IsReady()) then
			if (((2675 + 557) <= (194 + 4496)) and ((v80.Crackshot:IsAvailable() and v110()) or (not v80.Crackshot:IsAvailable() and ((v80.CountTheOdds:IsAvailable() and v110()) or v80.HiddenOpportunity:IsAvailable())))) then
				if (v9.Cast(v80.Shadowmeld, v27) or ((1685 - (766 + 23)) >= (15530 - 12384))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v117()
		v90 = v78.HandleTopTrinket(v83, v26, 54 - 14, nil);
		if (((8064 - 5003) >= (10039 - 7081)) and v90) then
			return v90;
		end
		v90 = v78.HandleBottomTrinket(v83, v26, 1113 - (1036 + 37), nil);
		if (((2260 + 927) >= (1253 - 609)) and v90) then
			return v90;
		end
	end
	local function v118()
		local v135 = 0 + 0;
		while true do
			if (((2124 - (641 + 839)) <= (1617 - (910 + 3))) and (v135 == (0 - 0))) then
				if (((2642 - (1466 + 218)) > (436 + 511)) and v26 and v80.AdrenalineRush:IsCastable() and (not v13:BuffUp(v80.AdrenalineRush) or (v13:StealthUp(true, true) and v80.Crackshot:IsAvailable() and v80.ImprovedAdrenalineRush:IsAvailable())) and ((v94 <= (1150 - (556 + 592))) or not v80.ImprovedAdrenalineRush:IsAvailable())) then
					if (((1598 + 2894) >= (3462 - (329 + 479))) and v9.Cast(v80.AdrenalineRush)) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((4296 - (174 + 680)) >= (5164 - 3661)) and ((v80.BladeFlurry:IsReady() and (v89 >= ((3 - 1) - v19(v80.UnderhandedUpperhand:IsAvailable()))) and (v13:BuffRemains(v80.BladeFlurry) < v13:GCDRemains())) or (v80.DeftManeuvers:IsAvailable() and (v89 >= (4 + 1)) and not v110()))) then
					if (v68 or ((3909 - (396 + 343)) <= (130 + 1334))) then
						v9.Cast(v80.BladeFlurry);
					elseif (v9.Cast(v80.BladeFlurry) or ((6274 - (29 + 1448)) == (5777 - (135 + 1254)))) then
						return "Cast Blade Flurry";
					end
				end
				if (((2075 - 1524) <= (3179 - 2498)) and v80.RolltheBones:IsReady()) then
					if (((2184 + 1093) > (1934 - (389 + 1138))) and (v109() or (v79.RtBRemains() <= (v19(v13:HasTier(605 - (102 + 472), 4 + 0)) + (v19((v80.ShadowDance:CooldownRemains() <= (1 + 0)) or (v80.Vanish:CooldownRemains() <= (1 + 0))) * (1551 - (320 + 1225))))))) then
						if (((8358 - 3663) >= (866 + 549)) and v9.Cast(v80.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v135 = 1465 - (157 + 1307);
			end
			if ((v135 == (1862 - (821 + 1038))) or ((8013 - 4801) <= (104 + 840))) then
				if (v80.BloodFury:IsCastable() or ((5498 - 2402) <= (669 + 1129))) then
					if (((8766 - 5229) == (4563 - (834 + 192))) and v9.Cast(v80.BloodFury, v27)) then
						return "Cast Blood Fury";
					end
				end
				if (((244 + 3593) >= (403 + 1167)) and v80.Berserking:IsCastable()) then
					if (v9.Cast(v80.Berserking, v27) or ((64 + 2886) == (5904 - 2092))) then
						return "Cast Berserking";
					end
				end
				if (((5027 - (300 + 4)) >= (620 + 1698)) and v80.Fireblood:IsCastable()) then
					if (v9.Cast(v80.Fireblood, v27) or ((5306 - 3279) > (3214 - (112 + 250)))) then
						return "Cast Fireblood";
					end
				end
				v135 = 2 + 2;
			end
			if ((v135 == (4 - 2)) or ((651 + 485) > (2233 + 2084))) then
				if (((3551 + 1197) == (2355 + 2393)) and v80.BladeRush:IsReady() and (v99 > (3 + 1)) and not v13:StealthUp(true, true)) then
					if (((5150 - (1001 + 413)) <= (10570 - 5830)) and v9.Cast(v80.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				if (not v13:StealthUp(true, true, true) or ((4272 - (244 + 638)) <= (3753 - (627 + 66)))) then
					local v164 = 0 - 0;
					while true do
						if ((v164 == (602 - (512 + 90))) or ((2905 - (1665 + 241)) > (3410 - (373 + 344)))) then
							v90 = v116();
							if (((209 + 254) < (160 + 441)) and v90) then
								return v90;
							end
							break;
						end
					end
				end
				if ((v26 and v80.ThistleTea:IsAvailable() and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and ((v98 >= (263 - 163)) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (9 - 3)))) or ((3282 - (35 + 1064)) < (500 + 187))) then
					if (((9732 - 5183) == (19 + 4530)) and v9.Cast(v80.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				v135 = 1239 - (298 + 938);
			end
			if (((5931 - (233 + 1026)) == (6338 - (636 + 1030))) and (v135 == (3 + 1))) then
				if (v80.AncestralCall:IsCastable() or ((3583 + 85) < (118 + 277))) then
					if (v9.Cast(v80.AncestralCall, v27) or ((282 + 3884) == (676 - (55 + 166)))) then
						return "Cast Ancestral Call";
					end
				end
				v90 = v117();
				if (v90 or ((863 + 3586) == (268 + 2395))) then
					return v90;
				end
				break;
			end
			if ((v135 == (3 - 2)) or ((4574 - (36 + 261)) < (5226 - 2237))) then
				if ((v80.KeepItRolling:IsReady() and not v109() and (v108() >= ((1371 - (34 + 1334)) + v19(v13:HasTier(12 + 19, 4 + 0)))) and (v13:BuffDown(v80.ShadowDance) or (v108() >= (1289 - (1035 + 248))))) or ((891 - (20 + 1)) >= (2162 + 1987))) then
					if (((2531 - (134 + 185)) < (4316 - (549 + 584))) and v9.Cast(v80.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				if (((5331 - (314 + 371)) > (10271 - 7279)) and v80.GhostlyStrike:IsAvailable() and v80.GhostlyStrike:IsReady()) then
					if (((2402 - (478 + 490)) < (1646 + 1460)) and v9.Cast(v80.GhostlyStrike)) then
						return "Cast Ghostly Strike";
					end
				end
				if (((1958 - (786 + 386)) < (9791 - 6768)) and v26 and v80.Sepsis:IsAvailable() and v80.Sepsis:IsReady()) then
					if ((v80.Crackshot:IsAvailable() and v80.BetweentheEyes:IsReady() and v110() and not v13:StealthUp(true, true)) or (not v80.Crackshot:IsAvailable() and v14:FilteredTimeToDie(">", 1390 - (1055 + 324)) and v13:BuffUp(v80.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1351 - (1093 + 247)) or ((2171 + 271) < (8 + 66))) then
						if (((18004 - 13469) == (15390 - 10855)) and v9.Cast(v80.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				v135 = 5 - 3;
			end
		end
	end
	local function v119()
		if ((v80.BladeFlurry:IsReady() and v80.BladeFlurry:IsCastable() and v25 and v80.Subterfuge:IsAvailable() and (v89 >= (4 - 2)) and (v13:BuffRemains(v80.BladeFlurry) <= v13:GCDRemains())) or ((1071 + 1938) <= (8109 - 6004))) then
			if (((6307 - 4477) < (2767 + 902)) and v68) then
				v9.Press(v80.BladeFlurry);
			elseif (v9.Press(v80.BladeFlurry) or ((3657 - 2227) >= (4300 - (364 + 324)))) then
				return "Cast Blade Flurry";
			end
		end
		if (((7354 - 4671) >= (5903 - 3443)) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch) and v110()) then
			if (v9.Cast(v80.ColdBlood) or ((598 + 1206) >= (13703 - 10428))) then
				return "Cast Cold Blood";
			end
		end
		if ((v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v110() and v80.Crackshot:IsAvailable()) or ((2268 - 851) > (11021 - 7392))) then
			if (((6063 - (1249 + 19)) > (363 + 39)) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((18734 - 13921) > (4651 - (686 + 400))) and v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch) and v110()) then
			if (((3070 + 842) == (4141 - (73 + 156))) and v9.Press(v80.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((14 + 2807) <= (5635 - (721 + 90))) and v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and v80.Crackshot:IsAvailable() and (v80.FanTheHammer:TalentRank() >= (1 + 1)) and (v13:BuffStack(v80.Opportunity) >= (19 - 13)) and ((v13:BuffUp(v80.Broadside) and (v94 <= (471 - (224 + 246)))) or v13:BuffUp(v80.GreenskinsWickersBuff))) then
			if (((2815 - 1077) <= (4041 - 1846)) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((8 + 33) <= (72 + 2946)) and v80.Ambush:IsCastable() and v14:IsSpellInRange(v80.Ambush) and v80.HiddenOpportunity:IsAvailable()) then
			if (((1576 + 569) <= (8158 - 4054)) and v9.Press(v80.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v120()
		local v136 = 0 - 0;
		while true do
			if (((3202 - (203 + 310)) < (6838 - (1238 + 755))) and (v136 == (1 + 0))) then
				if ((v80.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v88, ">", v13:BuffRemains(v80.SliceandDice), true) or (v13:BuffRemains(v80.SliceandDice) == (1534 - (709 + 825)))) and (v13:BuffRemains(v80.SliceandDice) < (((1 - 0) + v94) * (1.8 - 0)))) or ((3186 - (196 + 668)) > (10352 - 7730))) then
					if (v9.Press(v80.SliceandDice) or ((9391 - 4857) == (2915 - (171 + 662)))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v80.KillingSpree:IsCastable() and v14:IsSpellInRange(v80.KillingSpree) and (v14:DebuffUp(v80.GhostlyStrike) or not v80.GhostlyStrike:IsAvailable())) or ((1664 - (4 + 89)) > (6543 - 4676))) then
					if (v9.Cast(v80.KillingSpree) or ((967 + 1687) >= (13158 - 10162))) then
						return "Cast Killing Spree";
					end
				end
				v136 = 1 + 1;
			end
			if (((5464 - (35 + 1451)) > (3557 - (28 + 1425))) and (v136 == (1993 - (941 + 1052)))) then
				if (((2872 + 123) > (3055 - (822 + 692))) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and not v80.Crackshot:IsAvailable() and ((v13:BuffRemains(v80.BetweentheEyes) < (5 - 1)) or v80.ImprovedBetweenTheEyes:IsAvailable() or v80.GreenskinsWickers:IsAvailable() or v13:HasTier(15 + 15, 301 - (45 + 252))) and v13:BuffDown(v80.GreenskinsWickers)) then
					if (((3215 + 34) > (328 + 625)) and v9.Press(v80.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if ((v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v80.Crackshot:IsAvailable() and (v80.Vanish:CooldownRemains() > (109 - 64)) and (v80.ShadowDance:CooldownRemains() > (445 - (114 + 319)))) or ((4698 - 1425) > (5859 - 1286))) then
					if (v9.Press(v80.BetweentheEyes) or ((2009 + 1142) < (1912 - 628))) then
						return "Cast Between the Eyes";
					end
				end
				v136 = 1 - 0;
			end
			if ((v136 == (1965 - (556 + 1407))) or ((3056 - (741 + 465)) == (1994 - (170 + 295)))) then
				if (((433 + 388) < (1951 + 172)) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch)) then
					if (((2220 - 1318) < (1928 + 397)) and v9.Cast(v80.ColdBlood, v53)) then
						return "Cast Cold Blood";
					end
				end
				if (((551 + 307) <= (1678 + 1284)) and v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch)) then
					if (v9.Press(v80.Dispatch) or ((5176 - (957 + 273)) < (345 + 943))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v121()
		if ((v26 and v80.EchoingReprimand:IsReady()) or ((1298 + 1944) == (2160 - 1593))) then
			if (v9.Cast(v80.EchoingReprimand, nil, v74) or ((2231 - 1384) >= (3857 - 2594))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v80.Ambush:IsCastable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.AudacityBuff)) or ((11156 - 8903) == (3631 - (389 + 1391)))) then
			if (v9.Press(v80.Ambush) or ((1310 + 777) > (247 + 2125))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and v80.Audacity:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.Opportunity) and v13:BuffDown(v80.AudacityBuff)) or ((10119 - 5674) < (5100 - (783 + 168)))) then
			if (v9.Press(v80.PistolShot) or ((6101 - 4283) == (84 + 1))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if (((941 - (309 + 2)) < (6531 - 4404)) and v13:BuffUp(v80.GreenskinsWickersBuff) and ((not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity)) or (v13:BuffRemains(v80.GreenskinsWickersBuff) < (1213.5 - (1090 + 122))))) then
			if (v9.Press(v80.PistolShot) or ((629 + 1309) == (8443 - 5929))) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if (((2912 + 1343) >= (1173 - (628 + 490))) and v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v13:BuffStack(v80.Opportunity) >= (2 + 4)) or (v13:BuffRemains(v80.Opportunity) < (4 - 2)))) then
			if (((13705 - 10706) > (1930 - (431 + 343))) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if (((4746 - 2396) > (3341 - 2186)) and v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and (v95 > (1 + 0 + (v19(v80.QuickDraw:IsAvailable()) * v80.FanTheHammer:TalentRank()))) and ((not v80.Vanish:IsReady() and not v80.ShadowDance:IsReady()) or v13:StealthUp(true, true) or not v80.Crackshot:IsAvailable() or (v80.FanTheHammer:TalentRank() <= (1 + 0)))) then
			if (((5724 - (556 + 1139)) <= (4868 - (6 + 9))) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v99 > (1.5 + 0)) or (v95 <= (1 + 0 + v19(v13:BuffUp(v80.Broadside)))) or v80.QuickDraw:IsAvailable() or (v80.Audacity:IsAvailable() and v13:BuffDown(v80.AudacityBuff)))) or ((685 - (28 + 141)) > (1331 + 2103))) then
			if (((4994 - 948) >= (2149 + 884)) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v80.SinisterStrike:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) or ((4036 - (486 + 831)) <= (3765 - 2318))) then
			if (v9.Press(v80.SinisterStrike) or ((14553 - 10419) < (742 + 3184))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v122()
		v77();
		v24 = EpicSettings.Toggles['ooc'];
		v25 = EpicSettings.Toggles['aoe'];
		v26 = EpicSettings.Toggles['cds'];
		v91 = (v80.AcrobaticStrikes:IsAvailable() and (31 - 21)) or (1269 - (668 + 595));
		v94 = v13:ComboPoints();
		v93 = v79.EffectiveComboPoints(v94);
		v95 = v13:ComboPointsDeficit();
		v100 = (v13:BuffUp(v80.AdrenalineRush, nil, true) and -(45 + 5)) or (0 + 0);
		v96 = v105();
		v97 = v13:EnergyRegen();
		v99 = v104(v100);
		v98 = v13:EnergyDeficitPredicted(nil, v100);
		if (v25 or ((447 - 283) >= (3075 - (23 + 267)))) then
			v87 = v13:GetEnemiesInRange(1974 - (1129 + 815));
			v88 = v13:GetEnemiesInRange(v91);
			v89 = #v88;
		else
			v89 = 388 - (371 + 16);
		end
		v90 = v79.CrimsonVial();
		if (v90 or ((2275 - (1326 + 424)) == (3993 - 1884))) then
			return v90;
		end
		v79.Poisons();
		if (((120 - 87) == (151 - (88 + 30))) and v81.Healthstone:IsReady() and (v13:HealthPercentage() < v33) and not (v13:IsChanneling() or v13:IsCasting())) then
			if (((3825 - (720 + 51)) <= (8931 - 4916)) and v9.Cast(v82.Healthstone)) then
				return "Healthstone ";
			end
		end
		if (((3647 - (421 + 1355)) < (5578 - 2196)) and v81.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v31) and not (v13:IsChanneling() or v13:IsCasting())) then
			if (((636 + 657) <= (3249 - (286 + 797))) and v9.Cast(v82.RefreshingHealingPotion)) then
				return "RefreshingHealingPotion ";
			end
		end
		if ((v80.Feint:IsCastable() and (v13:HealthPercentage() <= v56) and not (v13:IsChanneling() or v13:IsCasting())) or ((9427 - 6848) < (202 - 79))) then
			if (v9.Cast(v80.Feint) or ((1285 - (397 + 42)) >= (740 + 1628))) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v57) or ((4812 - (24 + 776)) <= (5173 - 1815))) then
			v90 = v79.Stealth(v80.Stealth2, nil);
			if (((2279 - (222 + 563)) <= (6621 - 3616)) and v90) then
				return "Stealth (OOC): " .. v90;
			end
		end
		if ((not v13:AffectingCombat() and (v80.Vanish:TimeSinceLastCast() > (1 + 0)) and v14:IsInRange(198 - (23 + 167)) and v24) or ((4909 - (690 + 1108)) == (770 + 1364))) then
			if (((1943 + 412) == (3203 - (40 + 808))) and v78.TargetIsValid() and v14:IsInRange(2 + 8) and not (v13:IsChanneling() or v13:IsCasting())) then
				if ((v80.BladeFlurry:IsReady() and v13:BuffDown(v80.BladeFlurry) and v80.UnderhandedUpperhand:IsAvailable() and not v13:StealthUp(true, true)) or ((2248 - 1660) <= (413 + 19))) then
					if (((2538 + 2259) >= (2136 + 1759)) and v9.Cast(v80.BladeFlurry)) then
						return "Blade Flurry (Opener)";
					end
				end
				if (((4148 - (47 + 524)) == (2322 + 1255)) and not v13:StealthUp(true, false)) then
					local v166 = 0 - 0;
					while true do
						if (((5672 - 1878) > (8422 - 4729)) and (v166 == (1726 - (1165 + 561)))) then
							v90 = v79.Stealth(v79.StealthSpell());
							if (v90 or ((38 + 1237) == (12698 - 8598))) then
								return v90;
							end
							break;
						end
					end
				end
				if (v78.TargetIsValid() or ((608 + 983) >= (4059 - (341 + 138)))) then
					local v167 = 0 + 0;
					while true do
						if (((2028 - 1045) <= (2134 - (89 + 237))) and ((0 - 0) == v167)) then
							if ((v80.AdrenalineRush:IsReady() and v80.ImprovedAdrenalineRush:IsAvailable() and (v94 <= (3 - 1))) or ((3031 - (581 + 300)) <= (2417 - (855 + 365)))) then
								if (((8951 - 5182) >= (384 + 789)) and v9.Cast(v80.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if (((2720 - (1030 + 205)) == (1395 + 90)) and v80.RolltheBones:IsReady() and not v13:DebuffUp(v80.Dreadblades) and ((v108() == (0 + 0)) or v109())) then
								if (v9.Cast(v80.RolltheBones) or ((3601 - (156 + 130)) <= (6321 - 3539))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							v167 = 1 - 0;
						end
						if ((v167 == (1 - 0)) or ((231 + 645) >= (1729 + 1235))) then
							if ((v80.SliceandDice:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (((70 - (10 + 59)) + v94) * (1.8 + 0)))) or ((10992 - 8760) > (3660 - (671 + 492)))) then
								if (v9.Press(v80.SliceandDice) or ((1680 + 430) <= (1547 - (369 + 846)))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((976 + 2710) > (2707 + 465)) and v13:StealthUp(true, false)) then
								local v185 = 1945 - (1036 + 909);
								while true do
									if (((0 + 0) == v185) or ((7511 - 3037) < (1023 - (11 + 192)))) then
										v90 = v119();
										if (((2163 + 2116) >= (3057 - (135 + 40))) and v90) then
											return "Stealth (Opener): " .. v90;
										end
										v185 = 2 - 1;
									end
									if ((v185 == (1 + 0)) or ((4469 - 2440) >= (5277 - 1756))) then
										if ((v80.KeepItRolling:IsAvailable() and v80.GhostlyStrike:IsReady() and v80.EchoingReprimand:IsAvailable()) or ((2213 - (50 + 126)) >= (12925 - 8283))) then
											if (((381 + 1339) < (5871 - (1233 + 180))) and v9.Press(v80.GhostlyStrike)) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (v80.Ambush:IsCastable() or ((1405 - (522 + 447)) > (4442 - (107 + 1314)))) then
											if (((331 + 382) <= (2580 - 1733)) and v9.Cast(v80.Ambush)) then
												return "Cast Ambush (Opener)";
											end
										end
										break;
									end
								end
							elseif (((915 + 1239) <= (8004 - 3973)) and v110()) then
								local v188 = 0 - 0;
								while true do
									if (((6525 - (716 + 1194)) == (79 + 4536)) and (v188 == (0 + 0))) then
										v90 = v120();
										if (v90 or ((4293 - (74 + 429)) == (964 - 464))) then
											return "Finish (Opener): " .. v90;
										end
										break;
									end
								end
							end
							v167 = 1 + 1;
						end
						if (((203 - 114) < (157 + 64)) and (v167 == (5 - 3))) then
							if (((5078 - 3024) >= (1854 - (279 + 154))) and v80.SinisterStrike:IsCastable()) then
								if (((1470 - (454 + 324)) < (2406 + 652)) and v9.Cast(v80.SinisterStrike)) then
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
		if ((v80.FanTheHammer:IsAvailable() and (v80.PistolShot:TimeSinceLastCast() < v13:GCDRemains())) or ((3271 - (12 + 5)) == (893 + 762))) then
			v94 = v23(v94, v79.FanTheHammerCP());
		end
		if (v78.TargetIsValid() or ((3301 - 2005) == (1815 + 3095))) then
			local v140 = 1093 - (277 + 816);
			while true do
				if (((14391 - 11023) == (4551 - (1058 + 125))) and (v140 == (0 + 0))) then
					v90 = v118();
					if (((3618 - (815 + 160)) < (16368 - 12553)) and v90) then
						return "CDs: " .. v90;
					end
					if (((4541 - 2628) > (118 + 375)) and (v13:StealthUp(true, true) or v13:BuffUp(v80.Shadowmeld))) then
						v90 = v119();
						if (((13899 - 9144) > (5326 - (41 + 1857))) and v90) then
							return "Stealth: " .. v90;
						end
					end
					v140 = 1894 - (1222 + 671);
				end
				if (((3569 - 2188) <= (3404 - 1035)) and ((1185 - (229 + 953)) == v140)) then
					if ((v80.BagofTricks:IsCastable() and v14:IsInMeleeRange(1779 - (1111 + 663))) or ((6422 - (874 + 705)) == (572 + 3512))) then
						if (((3186 + 1483) > (754 - 391)) and v9.Cast(v80.BagofTricks, v27)) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and not v14:IsInRange(v91) and not v13:StealthUp(true, true) and (v98 < (1 + 24)) and ((v95 >= (680 - (642 + 37))) or (v99 <= (1.2 + 0)))) or ((301 + 1576) >= (7878 - 4740))) then
						if (((5196 - (233 + 221)) >= (8384 - 4758)) and v9.Cast(v80.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v80.SinisterStrike:IsCastable() or ((3996 + 544) == (2457 - (718 + 823)))) then
						if (v9.Cast(v80.SinisterStrike) or ((728 + 428) > (5150 - (266 + 539)))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((6333 - 4096) < (5474 - (636 + 589))) and (v140 == (4 - 2))) then
					if ((v80.ArcaneTorrent:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike) and (v98 > ((30 - 15) + v97))) or ((2127 + 556) < (9 + 14))) then
						if (((1712 - (657 + 358)) <= (2186 - 1360)) and v9.Cast(v80.ArcaneTorrent, v27)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((2517 - 1412) <= (2363 - (1151 + 36))) and v80.ArcanePulse:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) then
						if (((3264 + 115) <= (1003 + 2809)) and v9.Cast(v80.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v80.LightsJudgment:IsCastable() and v14:IsInMeleeRange(14 - 9)) or ((2620 - (1552 + 280)) >= (2450 - (64 + 770)))) then
						if (((1259 + 595) <= (7670 - 4291)) and v9.Cast(v80.LightsJudgment, v27)) then
							return "Cast Lights Judgment";
						end
					end
					v140 = 1 + 2;
				end
				if (((5792 - (157 + 1086)) == (9104 - 4555)) and (v140 == (4 - 3))) then
					if (v110() or ((4635 - 1613) >= (4127 - 1103))) then
						local v171 = 819 - (599 + 220);
						while true do
							if (((9598 - 4778) > (4129 - (1813 + 118))) and (v171 == (0 + 0))) then
								v90 = v120();
								if (v90 or ((2278 - (841 + 376)) >= (6853 - 1962))) then
									return "Finish: " .. v90;
								end
								break;
							end
						end
					end
					v90 = v121();
					if (((317 + 1047) <= (12209 - 7736)) and v90) then
						return "Build: " .. v90;
					end
					v140 = 861 - (464 + 395);
				end
			end
		end
	end
	local function v123()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(667 - 407, v122, v123);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

