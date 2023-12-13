local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5411 - 2575) > (1468 - 974)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((98 + 2628) == (1686 + 2183))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((5543 - (645 + 522)) <= (3271 - (1010 + 780)))) then
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
		local v124 = 0 + 0;
		while true do
			if ((v124 == (14 - 11)) or ((9940 - 6548) >= (6577 - (1045 + 791)))) then
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v124 = 9 - 5;
			end
			if (((5077 - 1752) >= (2659 - (351 + 154))) and (v124 == (1578 - (1281 + 293)))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (266 - (28 + 238));
				v124 = 10 - 5;
			end
			if ((v124 == (1567 - (1381 + 178))) or ((1215 + 80) >= (2607 + 626))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				break;
			end
			if (((1868 + 2509) > (5660 - 4018)) and (v124 == (0 + 0))) then
				v28 = EpicSettings.Settings['UseRacials'];
				v30 = EpicSettings.Settings['UseHealingPotion'];
				v31 = EpicSettings.Settings['HealingPotionName'] or (470 - (381 + 89));
				v124 = 1 + 0;
			end
			if (((3195 + 1528) > (2322 - 966)) and (v124 == (1163 - (1074 + 82)))) then
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v124 = 17 - 9;
			end
			if ((v124 == (1786 - (214 + 1570))) or ((5591 - (990 + 465)) <= (1416 + 2017))) then
				v35 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v36 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v37 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v124 = 1729 - (1668 + 58);
			end
			if (((4871 - (512 + 114)) <= (12073 - 7442)) and (v124 == (1 - 0))) then
				v32 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v33 = EpicSettings.Settings['UseHealthstone'];
				v34 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v124 = 1 + 1;
			end
			if (((3718 + 558) >= (13201 - 9287)) and (v124 == (2000 - (109 + 1885)))) then
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'] or (1469 - (1269 + 200));
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v124 = 13 - 6;
			end
			if (((1013 - (98 + 717)) <= (5191 - (802 + 24))) and (v124 == (8 - 3))) then
				v57 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v124 = 1 + 5;
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
	local v86 = (v85[36 - 23] and v18(v85[43 - 30])) or v18(0 + 0);
	local v87 = (v85[6 + 8] and v18(v85[12 + 2])) or v18(0 + 0);
	v10:RegisterForEvent(function()
		v85 = v14:GetEquipment();
		v86 = (v85[7 + 6] and v18(v85[1446 - (797 + 636)])) or v18(0 - 0);
		v87 = (v85[1633 - (1427 + 192)] and v18(v85[5 + 9])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v81.Dispatch:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v80.CPSpend() * (0.3 + 0) * (1 + 0) * ((327 - (192 + 134)) + (v14:VersatilityDmgPct() / (1376 - (316 + 960)))) * ((v15:DebuffUp(v81.GhostlyStrike) and (1.1 + 0)) or (1 + 0));
	end);
	local v88, v89, v90;
	local v91;
	local v92;
	local v93, v94, v95;
	local v96, v97, v98, v99, v100;
	local v101 = {{v81.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v102, v103 = 0 - 0, 0 - 0;
	local function v104(v125)
		local v126 = 0 - 0;
		local v127;
		while true do
			if (((5107 - (45 + 280)) > (4514 + 162)) and ((1 + 0) == v126)) then
				return v102;
			end
			if (((1777 + 3087) > (1216 + 981)) and (v126 == (0 + 0))) then
				v127 = v14:EnergyTimeToMaxPredicted(nil, v125);
				if ((v127 < v102) or ((v127 - v102) > (0.5 - 0)) or ((5611 - (340 + 1571)) == (989 + 1518))) then
					v102 = v127;
				end
				v126 = 1773 - (1733 + 39);
			end
		end
	end
	local function v105()
		local v128 = v14:EnergyPredicted();
		if (((12294 - 7820) >= (1308 - (125 + 909))) and ((v128 > v103) or ((v128 - v103) > (1957 - (1096 + 852))))) then
			v103 = v128;
		end
		return v103;
	end
	local v106 = {v81.Broadside,v81.BuriedTreasure,v81.GrandMelee,v81.RuthlessPrecision,v81.SkullandCrossbones,v81.TrueBearing};
	local function v107(v129, v130)
		if (not v11.APLVar.RtB_List or ((535 + 1359) <= (2723 - (1114 + 203)))) then
			v11.APLVar.RtB_List = {};
		end
		if (((2298 - (228 + 498)) >= (332 + 1199)) and not v11.APLVar.RtB_List[v129]) then
			v11.APLVar.RtB_List[v129] = {};
		end
		local v131 = table.concat(v130);
		if ((v129 == "All") or ((2590 + 2097) < (5205 - (174 + 489)))) then
			if (((8573 - 5282) > (3572 - (830 + 1075))) and not v11.APLVar.RtB_List[v129][v131]) then
				local v162 = 524 - (303 + 221);
				for v165 = 1270 - (231 + 1038), #v130 do
					if (v14:BuffUp(v106[v130[v165]]) or ((728 + 145) == (3196 - (171 + 991)))) then
						v162 = v162 + (4 - 3);
					end
				end
				v11.APLVar.RtB_List[v129][v131] = ((v162 == #v130) and true) or false;
			end
		elseif (not v11.APLVar.RtB_List[v129][v131] or ((7561 - 4745) < (27 - 16))) then
			local v164 = 0 + 0;
			while true do
				if (((12966 - 9267) < (13575 - 8869)) and (v164 == (0 - 0))) then
					v11.APLVar.RtB_List[v129][v131] = false;
					for v174 = 3 - 2, #v130 do
						if (((3894 - (111 + 1137)) >= (1034 - (91 + 67))) and v14:BuffUp(v106[v130[v174]])) then
							v11.APLVar.RtB_List[v129][v131] = true;
							break;
						end
					end
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v129][v131];
	end
	local function v108()
		local v132 = 0 - 0;
		while true do
			if (((154 + 460) <= (3707 - (423 + 100))) and (v132 == (0 + 0))) then
				if (((8654 - 5528) == (1630 + 1496)) and not v11.APLVar.RtB_Buffs) then
					local v166 = 771 - (326 + 445);
					local v167;
					while true do
						if ((v166 == (0 - 0)) or ((4872 - 2685) >= (11563 - 6609))) then
							v11.APLVar.RtB_Buffs = {};
							v11.APLVar.RtB_Buffs.Total = 711 - (530 + 181);
							v166 = 882 - (614 + 267);
						end
						if ((v166 == (33 - (19 + 13))) or ((6310 - 2433) == (8330 - 4755))) then
							v11.APLVar.RtB_Buffs.Normal = 0 - 0;
							v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
							v166 = 3 - 1;
						end
						if (((1465 - 758) > (2444 - (1293 + 519))) and (v166 == (5 - 2))) then
							for v180 = 2 - 1, #v106 do
								local v181 = 0 - 0;
								local v182;
								while true do
									if ((v181 == (0 - 0)) or ((1285 - 739) >= (1422 + 1262))) then
										v182 = v14:BuffRemains(v106[v180]);
										if (((299 + 1166) <= (9993 - 5692)) and (v182 > (0 + 0))) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
											if (((1065 + 639) > (2521 - (709 + 387))) and (v182 == v167)) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1859 - (673 + 1185));
											elseif ((v182 > v167) or ((1992 - 1305) == (13595 - 9361))) then
												v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (1 - 0);
											else
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
											end
										end
										break;
									end
								end
							end
							break;
						end
						if ((v166 == (2 + 0)) or ((4496 - 1166) < (351 + 1078))) then
							v11.APLVar.RtB_Buffs.Longer = 0 - 0;
							v167 = v80.RtBRemains();
							v166 = 5 - 2;
						end
					end
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v109()
		local v133 = 1880 - (446 + 1434);
		while true do
			if (((2430 - (1040 + 243)) >= (999 - 664)) and (v133 == (1847 - (559 + 1288)))) then
				if (((5366 - (609 + 1322)) > (2551 - (13 + 441))) and not v11.APLVar.RtB_Reroll) then
					if ((v63 == "1+ Buff") or ((14087 - 10317) >= (10584 - 6543))) then
						v11.APLVar.RtB_Reroll = ((v108() <= (0 - 0)) and true) or false;
					elseif ((v63 == "Broadside") or ((142 + 3649) <= (5850 - 4239))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.Broadside) and true) or false;
					elseif ((v63 == "Buried Treasure") or ((1626 + 2952) <= (880 + 1128))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.BuriedTreasure) and true) or false;
					elseif (((3338 - 2213) <= (1137 + 939)) and (v63 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((1365 - 622) >= (2909 + 1490))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.SkullandCrossbones) and true) or false;
					elseif (((643 + 512) < (1203 + 470)) and (v63 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.RuthlessPrecision) and true) or false;
					elseif ((v63 == "True Bearing") or ((1952 + 372) <= (566 + 12))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.TrueBearing) and true) or false;
					else
						v11.APLVar.RtB_Reroll = false;
						v108();
						if (((4200 - (153 + 280)) == (10877 - 7110)) and (v108() <= (2 + 0)) and v14:BuffUp(v81.BuriedTreasure) and v14:BuffDown(v81.GrandMelee) and (v90 < (1 + 1))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((2140 + 1949) == (3711 + 378)) and v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:HasTier(23 + 8, 5 - 1) and ((not v14:BuffUp(v81.TrueBearing) and v81.HiddenOpportunity:IsAvailable()) or (not v14:BuffUp(v81.Broadside) and not v81.HiddenOpportunity:IsAvailable())) and (v108() <= (1 + 0))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((5125 - (89 + 578)) >= (1196 + 478)) and v81.Crackshot:IsAvailable() and v14:HasTier(64 - 33, 1053 - (572 + 477)) and (v108() <= (1 + 0 + v20(v14:BuffUp(v81.LoadedDiceBuff)))) and (v81.HiddenOpportunity:IsAvailable() or v14:BuffDown(v81.Broadside))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((584 + 388) <= (170 + 1248)) and not v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:BuffUp(v81.SkullandCrossbones) and (v108() < ((88 - (84 + 2)) + v20(v14:BuffUp(v81.GrandMelee)))) and (v90 < (2 - 0))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (v11.APLVar.RtB_Reroll or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (843 - (497 + 345))) and (v108() < (1 + 4)) and (v80.RtBRemains() <= (7 + 32))) or ((6271 - (605 + 728)) < (3398 + 1364))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (v15:FilteredTimeToDie("<", 26 - 14) or v10.BossFilteredFightRemains("<", 1 + 11) or ((9257 - 6753) > (3844 + 420))) then
							v11.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v110()
		return v93 >= ((v80.CPMaxSpend() - (2 - 1)) - v20((v14:StealthUp(true, true)) and v81.Crackshot:IsAvailable()));
	end
	local function v111()
		return (v81.HiddenOpportunity:IsAvailable() or (v95 >= (2 + 0 + v20(v81.ImprovedAmbush:IsAvailable()) + v20(v14:BuffUp(v81.Broadside))))) and (v96 >= (539 - (457 + 32)));
	end
	local function v112()
		return not v26 or (v90 < (1 + 1)) or (v14:BuffRemains(v81.BladeFlurry) > ((1403 - (832 + 570)) + v20(v81.KillingSpree:IsAvailable())));
	end
	local function v113()
		return v66 and (not v14:IsTanking(v15) or v76);
	end
	local function v114()
		return not v81.ShadowDanceTalent:IsAvailable() and ((v81.FanTheHammer:TalentRank() + v20(v81.QuickDraw:IsAvailable()) + v20(v81.Audacity:IsAvailable())) < (v20(v81.CountTheOdds:IsAvailable()) + v20(v81.KeepItRolling:IsAvailable())));
	end
	local function v115()
		return v14:BuffUp(v81.BetweentheEyes) and (not v81.HiddenOpportunity:IsAvailable() or (v14:BuffDown(v81.AudacityBuff) and ((v81.FanTheHammer:TalentRank() < (2 + 0)) or v14:BuffDown(v81.Opportunity)))) and not v81.Crackshot:IsAvailable();
	end
	local function v116()
		if (((562 + 1591) == (7618 - 5465)) and v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v113() and v81.HiddenOpportunity:IsAvailable() and not v81.Crackshot:IsAvailable() and not v14:BuffUp(v81.Audacity) and (v114() or (v14:BuffStack(v81.Opportunity) < (3 + 3))) and v111()) then
			if (v10.Cast(v81.Vanish, v66) or ((1303 - (588 + 208)) >= (6983 - 4392))) then
				return "Cast Vanish (HO)";
			end
		end
		if (((6281 - (884 + 916)) == (9381 - 4900)) and v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v113() and (not v81.HiddenOpportunity:IsAvailable() or v81.Crackshot:IsAvailable()) and v110()) then
			if (v10.Cast(v81.Vanish, v66) or ((1350 + 978) < (1346 - (232 + 421)))) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((6217 - (1569 + 320)) == (1062 + 3266)) and v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.Crackshot:IsAvailable() and v110()) then
			if (((302 + 1286) >= (4488 - 3156)) and v10.Cast(v81.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and not v81.KeepItRolling:IsAvailable() and v115() and v14:BuffUp(v81.SliceandDice) and (v110() or v81.HiddenOpportunity:IsAvailable()) and (not v81.HiddenOpportunity:IsAvailable() or not v81.Vanish:IsReady())) or ((4779 - (316 + 289)) > (11119 - 6871))) then
			if (v10.Cast(v81.ShadowDance) or ((212 + 4374) <= (1535 - (666 + 787)))) then
				return "Cast Shadow Dance";
			end
		end
		if (((4288 - (360 + 65)) == (3611 + 252)) and v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.KeepItRolling:IsAvailable() and v115() and ((v81.KeepItRolling:CooldownRemains() <= (284 - (79 + 175))) or ((v81.KeepItRolling:CooldownRemains() >= (189 - 69)) and (v110() or v81.HiddenOpportunity:IsAvailable())))) then
			if (v10.Cast(v81.ShadowDance) or ((221 + 61) <= (128 - 86))) then
				return "Cast Shadow Dance";
			end
		end
		if (((8875 - 4266) >= (1665 - (503 + 396))) and v81.Shadowmeld:IsAvailable() and v81.Shadowmeld:IsReady()) then
			if ((v81.Crackshot:IsAvailable() and v110()) or (not v81.Crackshot:IsAvailable() and ((v81.CountTheOdds:IsAvailable() and v110()) or v81.HiddenOpportunity:IsAvailable())) or ((1333 - (92 + 89)) == (4826 - 2338))) then
				if (((1755 + 1667) > (1983 + 1367)) and v10.Cast(v81.Shadowmeld, v28)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v117()
		v91 = v79.HandleTopTrinket(v84, v27, 156 - 116, nil);
		if (((120 + 757) > (857 - 481)) and v91) then
			return v91;
		end
		v91 = v79.HandleBottomTrinket(v84, v27, 35 + 5, nil);
		if (v91 or ((1490 + 1628) <= (5637 - 3786))) then
			return v91;
		end
	end
	local function v118()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (4 - 1)) or ((1409 - (485 + 759)) >= (8079 - 4587))) then
				if (((5138 - (442 + 747)) < (5991 - (832 + 303))) and v81.BloodFury:IsCastable()) then
					if (v10.Cast(v81.BloodFury, v28) or ((5222 - (88 + 858)) < (920 + 2096))) then
						return "Cast Blood Fury";
					end
				end
				if (((3882 + 808) > (170 + 3955)) and v81.Berserking:IsCastable()) then
					if (v10.Cast(v81.Berserking, v28) or ((839 - (766 + 23)) >= (4423 - 3527))) then
						return "Cast Berserking";
					end
				end
				if (v81.Fireblood:IsCastable() or ((2343 - 629) >= (7793 - 4835))) then
					if (v10.Cast(v81.Fireblood, v28) or ((5060 - 3569) < (1717 - (1036 + 37)))) then
						return "Cast Fireblood";
					end
				end
				v134 = 3 + 1;
			end
			if (((1370 - 666) < (777 + 210)) and (v134 == (1480 - (641 + 839)))) then
				if (((4631 - (910 + 3)) > (4858 - 2952)) and v27 and v81.AdrenalineRush:IsCastable() and (not v14:BuffUp(v81.AdrenalineRush) or (v14:StealthUp(true, true) and v81.Crackshot:IsAvailable() and v81.ImprovedAdrenalineRush:IsAvailable())) and ((v94 <= (1686 - (1466 + 218))) or not v81.ImprovedAdrenalineRush:IsAvailable())) then
					if (v10.Cast(v81.AdrenalineRush) or ((441 + 517) > (4783 - (556 + 592)))) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((1245 + 2256) <= (5300 - (329 + 479))) and v81.BladeFlurry:IsReady() and (v14:BuffRemains(v81.BladeFlurry) < v14:GCDRemains()) and ((v90 >= ((856 - (174 + 680)) - v20(v81.UnderhandedUpperhand:IsAvailable()))) or (v81.DeftManeuvers:IsAvailable() and (v90 >= (17 - 12)) and not v110()))) then
					if (v69 or ((7133 - 3691) < (1820 + 728))) then
						if (((3614 - (396 + 343)) >= (130 + 1334)) and v10.Press(v81.BladeFlurry, not v15:IsInMeleeRange(1487 - (29 + 1448)))) then
							return "Cast Blade Flurry";
						end
					elseif (v10.Press(v81.BladeFlurry, not v15:IsInMeleeRange(1399 - (135 + 1254))) or ((18071 - 13274) >= (22846 - 17953))) then
						return "Cast Blade Flurry";
					end
				end
				if (v81.RolltheBones:IsReady() or ((368 + 183) > (3595 - (389 + 1138)))) then
					if (((2688 - (102 + 472)) > (891 + 53)) and (v109() or (v80.RtBRemains() <= (v20(v14:HasTier(18 + 13, 4 + 0)) + (v20((v81.ShadowDance:CooldownRemains() <= (1546 - (320 + 1225))) or (v81.Vanish:CooldownRemains() <= (1 - 0))) * (4 + 2)))))) then
						if (v10.Cast(v81.RolltheBones) or ((3726 - (157 + 1307)) >= (4955 - (821 + 1038)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v134 = 2 - 1;
			end
			if ((v134 == (1 + 1)) or ((4005 - 1750) >= (1316 + 2221))) then
				if ((v81.BladeRush:IsReady() and (v99 > (9 - 5)) and not v14:StealthUp(true, true)) or ((4863 - (834 + 192)) < (84 + 1222))) then
					if (((758 + 2192) == (64 + 2886)) and v10.Cast(v81.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				if (not v14:StealthUp(true, true, true) or ((7316 - 2593) < (3602 - (300 + 4)))) then
					local v168 = 0 + 0;
					while true do
						if (((2973 - 1837) >= (516 - (112 + 250))) and (v168 == (0 + 0))) then
							v91 = v116();
							if (v91 or ((678 - 407) > (2721 + 2027))) then
								return v91;
							end
							break;
						end
					end
				end
				if (((2452 + 2288) >= (2358 + 794)) and v27 and v81.ThistleTea:IsAvailable() and v81.ThistleTea:IsCastable() and not v14:BuffUp(v81.ThistleTea) and ((v98 >= (50 + 50)) or v10.BossFilteredFightRemains("<", v81.ThistleTea:Charges() * (5 + 1)))) then
					if (v10.Cast(v81.ThistleTea) or ((3992 - (1001 + 413)) >= (7559 - 4169))) then
						return "Cast Thistle Tea";
					end
				end
				v134 = 885 - (244 + 638);
			end
			if (((734 - (627 + 66)) <= (4949 - 3288)) and (v134 == (606 - (512 + 90)))) then
				if (((2507 - (1665 + 241)) < (4277 - (373 + 344))) and v81.AncestralCall:IsCastable()) then
					if (((106 + 129) < (182 + 505)) and v10.Cast(v81.AncestralCall, v28)) then
						return "Cast Ancestral Call";
					end
				end
				v91 = v117();
				if (((11998 - 7449) > (1950 - 797)) and v91) then
					return v91;
				end
				break;
			end
			if ((v134 == (1100 - (35 + 1064))) or ((3401 + 1273) < (9995 - 5323))) then
				if (((15 + 3653) < (5797 - (298 + 938))) and v81.KeepItRolling:IsReady() and not v109() and (v108() >= ((1262 - (233 + 1026)) + v20(v14:HasTier(1697 - (636 + 1030), 3 + 1)))) and (v14:BuffDown(v81.ShadowDance) or (v108() >= (6 + 0)))) then
					if (v10.Cast(v81.KeepItRolling) or ((136 + 319) == (244 + 3361))) then
						return "Cast Keep it Rolling";
					end
				end
				if ((v81.GhostlyStrike:IsAvailable() and v81.GhostlyStrike:IsReady()) or ((2884 - (55 + 166)) == (642 + 2670))) then
					if (((431 + 3846) <= (17090 - 12615)) and v10.Cast(v81.GhostlyStrike)) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v27 and v81.Sepsis:IsAvailable() and v81.Sepsis:IsReady()) or ((1167 - (36 + 261)) == (2078 - 889))) then
					if (((2921 - (34 + 1334)) <= (1205 + 1928)) and ((v81.Crackshot:IsAvailable() and v81.BetweentheEyes:IsReady() and v110() and not v14:StealthUp(true, true)) or (not v81.Crackshot:IsAvailable() and v15:FilteredTimeToDie(">", 9 + 2) and v14:BuffUp(v81.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1294 - (1035 + 248)))) then
						if (v10.Cast(v81.Sepsis) or ((2258 - (20 + 1)) >= (1830 + 1681))) then
							return "Cast Sepsis";
						end
					end
				end
				v134 = 321 - (134 + 185);
			end
		end
	end
	local function v119()
		if ((v81.BladeFlurry:IsReady() and v81.BladeFlurry:IsCastable() and v26 and v81.Subterfuge:IsAvailable() and (v90 >= (1135 - (549 + 584))) and (v14:BuffRemains(v81.BladeFlurry) <= v14:GCDRemains())) or ((2009 - (314 + 371)) > (10367 - 7347))) then
			if (v69 or ((3960 - (478 + 490)) == (997 + 884))) then
				if (((4278 - (786 + 386)) > (4942 - 3416)) and v10.Press(v81.BladeFlurry, not v15:IsInMeleeRange(1389 - (1055 + 324)))) then
					return "Cast Blade Flurry";
				end
			elseif (((4363 - (1093 + 247)) < (3440 + 430)) and v10.Press(v81.BladeFlurry, not v15:IsInMeleeRange(2 + 8))) then
				return "Cast Blade Flurry";
			end
		end
		if (((567 - 424) > (251 - 177)) and v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch) and v110()) then
			if (((50 - 32) < (5307 - 3195)) and v10.Cast(v81.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if (((391 + 706) <= (6271 - 4643)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v110() and v81.Crackshot:IsAvailable()) then
			if (((15958 - 11328) == (3492 + 1138)) and v10.Press(v81.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((9053 - 5513) > (3371 - (364 + 324))) and v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch) and v110()) then
			if (((13141 - 8347) >= (7858 - 4583)) and v10.Press(v81.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((492 + 992) == (6209 - 4725)) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and v81.Crackshot:IsAvailable() and (v81.FanTheHammer:TalentRank() >= (2 - 0)) and (v14:BuffStack(v81.Opportunity) >= (18 - 12)) and ((v14:BuffUp(v81.Broadside) and (v94 <= (1269 - (1249 + 19)))) or v14:BuffUp(v81.GreenskinsWickersBuff))) then
			if (((1293 + 139) < (13837 - 10282)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v81.Ambush:IsCastable() and v15:IsSpellInRange(v81.Ambush) and v81.HiddenOpportunity:IsAvailable()) or ((2151 - (686 + 400)) > (2808 + 770))) then
			if (v10.Press(v81.Ambush) or ((5024 - (73 + 156)) < (7 + 1400))) then
				return "Cast Ambush";
			end
		end
	end
	local function v120()
		local v135 = 811 - (721 + 90);
		while true do
			if (((21 + 1832) < (15627 - 10814)) and (v135 == (472 - (224 + 246)))) then
				if ((v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch)) or ((4569 - 1748) < (4475 - 2044))) then
					if (v10.Cast(v81.ColdBlood, v54) or ((522 + 2352) < (52 + 2129))) then
						return "Cast Cold Blood";
					end
				end
				if ((v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch)) or ((1976 + 713) <= (681 - 338))) then
					if (v10.Press(v81.Dispatch) or ((6219 - 4350) == (2522 - (203 + 310)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v135 == (1994 - (1238 + 755))) or ((248 + 3298) < (3856 - (709 + 825)))) then
				if ((v81.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v89, ">", v14:BuffRemains(v81.SliceandDice), true) or (v14:BuffRemains(v81.SliceandDice) == (0 - 0))) and (v14:BuffRemains(v81.SliceandDice) < (((1 - 0) + v94) * (865.8 - (196 + 668))))) or ((8220 - 6138) == (9886 - 5113))) then
					if (((4077 - (171 + 662)) > (1148 - (4 + 89))) and v10.Press(v81.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v81.KillingSpree:IsCastable() and v15:IsSpellInRange(v81.KillingSpree) and (v15:DebuffUp(v81.GhostlyStrike) or not v81.GhostlyStrike:IsAvailable())) or ((11611 - 8298) <= (648 + 1130))) then
					if (v10.Cast(v81.KillingSpree) or ((6241 - 4820) >= (826 + 1278))) then
						return "Cast Killing Spree";
					end
				end
				v135 = 1488 - (35 + 1451);
			end
			if (((3265 - (28 + 1425)) <= (5242 - (941 + 1052))) and (v135 == (0 + 0))) then
				if (((3137 - (822 + 692)) <= (2793 - 836)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and not v81.Crackshot:IsAvailable() and ((v14:BuffRemains(v81.BetweentheEyes) < (2 + 2)) or v81.ImprovedBetweenTheEyes:IsAvailable() or v81.GreenskinsWickers:IsAvailable() or v14:HasTier(327 - (45 + 252), 4 + 0)) and v14:BuffDown(v81.GreenskinsWickers)) then
					if (((1519 + 2893) == (10737 - 6325)) and v10.Press(v81.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((2183 - (114 + 319)) >= (1208 - 366)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v81.Crackshot:IsAvailable() and (v81.Vanish:CooldownRemains() > (57 - 12)) and (v81.ShadowDance:CooldownRemains() > (8 + 4))) then
					if (((6512 - 2140) > (3876 - 2026)) and v10.Press(v81.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v135 = 1964 - (556 + 1407);
			end
		end
	end
	local function v121()
		local v136 = 1206 - (741 + 465);
		while true do
			if (((697 - (170 + 295)) < (433 + 388)) and ((1 + 0) == v136)) then
				if (((1275 - 757) < (748 + 154)) and v81.FanTheHammer:IsAvailable() and v81.Audacity:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.Opportunity) and v14:BuffDown(v81.AudacityBuff)) then
					if (((1921 + 1073) > (486 + 372)) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v14:BuffUp(v81.GreenskinsWickersBuff) and ((not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity)) or (v14:BuffRemains(v81.GreenskinsWickersBuff) < (1231.5 - (957 + 273))))) or ((1005 + 2750) <= (367 + 548))) then
					if (((15035 - 11089) > (9863 - 6120)) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot (GSW Dump)";
					end
				end
				v136 = 5 - 3;
			end
			if ((v136 == (14 - 11)) or ((3115 - (389 + 1391)) >= (2075 + 1231))) then
				if (((505 + 4339) > (5129 - 2876)) and not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v99 > (952.5 - (783 + 168))) or (v95 <= ((3 - 2) + v20(v14:BuffUp(v81.Broadside)))) or v81.QuickDraw:IsAvailable() or (v81.Audacity:IsAvailable() and v14:BuffDown(v81.AudacityBuff)))) then
					if (((445 + 7) == (763 - (309 + 2))) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v81.SinisterStrike:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) or ((13993 - 9436) < (3299 - (1090 + 122)))) then
					if (((1256 + 2618) == (13010 - 9136)) and v10.Press(v81.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v136 == (0 + 0)) or ((3056 - (628 + 490)) > (885 + 4050))) then
				if ((v27 and v81.EchoingReprimand:IsReady()) or ((10535 - 6280) < (15643 - 12220))) then
					if (((2228 - (431 + 343)) <= (5030 - 2539)) and v10.Cast(v81.EchoingReprimand, nil, v75)) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v81.Ambush:IsCastable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.AudacityBuff)) or ((12025 - 7868) <= (2215 + 588))) then
					if (((621 + 4232) >= (4677 - (556 + 1139))) and v10.Press(v81.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v136 = 16 - (6 + 9);
			end
			if (((757 + 3377) > (1720 + 1637)) and ((171 - (28 + 141)) == v136)) then
				if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v14:BuffStack(v81.Opportunity) >= (3 + 3)) or (v14:BuffRemains(v81.Opportunity) < (2 - 0)))) or ((2421 + 996) < (3851 - (486 + 831)))) then
					if (v10.Press(v81.PistolShot) or ((7083 - 4361) <= (577 - 413))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and (v95 > (1 + 0 + (v20(v81.QuickDraw:IsAvailable()) * v81.FanTheHammer:TalentRank()))) and ((not v81.Vanish:IsReady() and not v81.ShadowDance:IsReady()) or v14:StealthUp(true, true) or not v81.Crackshot:IsAvailable() or (v81.FanTheHammer:TalentRank() <= (3 - 2)))) or ((3671 - (668 + 595)) < (1898 + 211))) then
					if (v10.Press(v81.PistolShot) or ((7 + 26) == (3967 - 2512))) then
						return "Cast Pistol Shot";
					end
				end
				v136 = 293 - (23 + 267);
			end
		end
	end
	local function v122()
		local v137 = 1944 - (1129 + 815);
		while true do
			if ((v137 == (389 - (371 + 16))) or ((2193 - (1326 + 424)) >= (7604 - 3589))) then
				v96 = v105();
				v97 = v14:EnergyRegen();
				v99 = v104(v100);
				v98 = v14:EnergyDeficitPredicted(nil, v100);
				v137 = 10 - 7;
			end
			if (((3500 - (88 + 30)) > (937 - (720 + 51))) and (v137 == (11 - 6))) then
				if (v79.TargetIsValid() or ((2056 - (421 + 1355)) == (5046 - 1987))) then
					local v169 = 0 + 0;
					while true do
						if (((2964 - (286 + 797)) > (4726 - 3433)) and (v169 == (1 - 0))) then
							v91 = v121();
							if (((2796 - (397 + 42)) == (737 + 1620)) and v91) then
								return "Build: " .. v91;
							end
							if (((923 - (24 + 776)) == (189 - 66)) and v81.ArcaneTorrent:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike) and (v98 > ((800 - (222 + 563)) + v97))) then
								if (v10.Cast(v81.ArcaneTorrent, v28) or ((2326 - 1270) >= (2443 + 949))) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v81.ArcanePulse:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) or ((1271 - (23 + 167)) < (2873 - (690 + 1108)))) then
								if (v10.Cast(v81.ArcanePulse) or ((379 + 670) >= (3656 + 776))) then
									return "Cast Arcane Pulse";
								end
							end
							v169 = 850 - (40 + 808);
						end
						if ((v169 == (1 + 1)) or ((18232 - 13464) <= (809 + 37))) then
							if ((v81.LightsJudgment:IsCastable() and v15:IsInMeleeRange(3 + 2)) or ((1842 + 1516) <= (1991 - (47 + 524)))) then
								if (v10.Cast(v81.LightsJudgment, v28) or ((2427 + 1312) <= (8214 - 5209))) then
									return "Cast Lights Judgment";
								end
							end
							if ((v81.BagofTricks:IsCastable() and v15:IsInMeleeRange(7 - 2)) or ((3783 - 2124) >= (3860 - (1165 + 561)))) then
								if (v10.Cast(v81.BagofTricks, v28) or ((97 + 3163) < (7293 - 4938))) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and not v15:IsInRange(3 + 3) and not v14:StealthUp(true, true) and (v98 < (504 - (341 + 138))) and ((v95 >= (1 + 0)) or (v99 <= (1.2 - 0)))) or ((995 - (89 + 237)) == (13585 - 9362))) then
								if (v10.Cast(v81.PistolShot) or ((3561 - 1869) < (1469 - (581 + 300)))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (v81.SinisterStrike:IsCastable() or ((6017 - (855 + 365)) < (8671 - 5020))) then
								if (v10.Cast(v81.SinisterStrike) or ((1364 + 2813) > (6085 - (1030 + 205)))) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if ((v169 == (0 + 0)) or ((373 + 27) > (1397 - (156 + 130)))) then
							v91 = v118();
							if (((6932 - 3881) > (1693 - 688)) and v91) then
								return "CDs: " .. v91;
							end
							if (((7563 - 3870) <= (1155 + 3227)) and (v14:StealthUp(true, true) or v14:BuffUp(v81.Shadowmeld))) then
								local v185 = 0 + 0;
								while true do
									if ((v185 == (69 - (10 + 59))) or ((929 + 2353) > (20191 - 16091))) then
										v91 = v119();
										if (v91 or ((4743 - (671 + 492)) < (2264 + 580))) then
											return "Stealth: " .. v91;
										end
										break;
									end
								end
							end
							if (((1304 - (369 + 846)) < (1189 + 3301)) and v110()) then
								local v186 = 0 + 0;
								while true do
									if ((v186 == (1945 - (1036 + 909))) or ((3962 + 1021) < (3035 - 1227))) then
										v91 = v120();
										if (((4032 - (11 + 192)) > (1905 + 1864)) and v91) then
											return "Finish: " .. v91;
										end
										break;
									end
								end
							end
							v169 = 176 - (135 + 40);
						end
					end
				end
				break;
			end
			if (((3597 - 2112) <= (1751 + 1153)) and (v137 == (8 - 4))) then
				if (((6399 - 2130) == (4445 - (50 + 126))) and v81.Feint:IsCastable() and v81.Feint:IsReady() and (v14:HealthPercentage() <= v57) and not (v14:IsChanneling() or v14:IsCasting())) then
					if (((1077 - 690) <= (616 + 2166)) and v10.Cast(v81.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if ((not v14:AffectingCombat() and not v14:IsMounted() and v58) or ((3312 - (1233 + 180)) <= (1886 - (522 + 447)))) then
					local v170 = 1421 - (107 + 1314);
					while true do
						if (((0 + 0) == v170) or ((13139 - 8827) <= (373 + 503))) then
							v91 = v80.Stealth(v81.Stealth2, nil);
							if (((4431 - 2199) <= (10271 - 7675)) and v91) then
								return "Stealth (OOC): " .. v91;
							end
							break;
						end
					end
				end
				if (((4005 - (716 + 1194)) < (63 + 3623)) and not v14:AffectingCombat() and (v81.Vanish:TimeSinceLastCast() > (1 + 0)) and v15:IsInRange(511 - (74 + 429)) and v25) then
					if ((v79.TargetIsValid() and v15:IsInRange(19 - 9) and not (v14:IsChanneling() or v14:IsCasting())) or ((791 + 804) >= (10241 - 5767))) then
						local v173 = 0 + 0;
						while true do
							if ((v173 == (0 - 0)) or ((11420 - 6801) < (3315 - (279 + 154)))) then
								if ((v81.BladeFlurry:IsReady() and v14:BuffDown(v81.BladeFlurry) and v81.UnderhandedUpperhand:IsAvailable() and not v14:StealthUp(true, true)) or ((1072 - (454 + 324)) >= (3801 + 1030))) then
									if (((2046 - (12 + 5)) <= (1663 + 1421)) and v10.Press(v81.BladeFlurry, not v15:IsInMeleeRange(25 - 15))) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v14:StealthUp(true, false) or ((753 + 1284) == (3513 - (277 + 816)))) then
									v91 = v80.Stealth(v80.StealthSpell());
									if (((19049 - 14591) > (5087 - (1058 + 125))) and v91) then
										return v91;
									end
								end
								v173 = 1 + 0;
							end
							if (((1411 - (815 + 160)) >= (527 - 404)) and (v173 == (2 - 1))) then
								if (((120 + 380) < (5308 - 3492)) and v79.TargetIsValid()) then
									if (((5472 - (41 + 1857)) == (5467 - (1222 + 671))) and v81.AdrenalineRush:IsReady() and v81.ImprovedAdrenalineRush:IsAvailable() and (v94 <= (5 - 3))) then
										if (((317 - 96) < (1572 - (229 + 953))) and v10.Cast(v81.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v81.RolltheBones:IsReady() and not v14:DebuffUp(v81.Dreadblades) and ((v108() == (1774 - (1111 + 663))) or v109())) or ((3792 - (874 + 705)) <= (199 + 1222))) then
										if (((2087 + 971) < (10102 - 5242)) and v10.Cast(v81.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if ((v81.SliceandDice:IsReady() and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v94) * (680.8 - (642 + 37))))) or ((296 + 1000) >= (712 + 3734))) then
										if (v10.Press(v81.SliceandDice) or ((3497 - 2104) > (4943 - (233 + 221)))) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v14:StealthUp(true, false) or ((10229 - 5805) < (24 + 3))) then
										local v190 = 1541 - (718 + 823);
										while true do
											if ((v190 == (0 + 0)) or ((2802 - (266 + 539)) > (10800 - 6985))) then
												v91 = v119();
												if (((4690 - (636 + 589)) > (4540 - 2627)) and v91) then
													return "Stealth (Opener): " .. v91;
												end
												v190 = 1 - 0;
											end
											if (((581 + 152) < (661 + 1158)) and (v190 == (1016 - (657 + 358)))) then
												if ((v81.KeepItRolling:IsAvailable() and v81.GhostlyStrike:IsReady() and v81.EchoingReprimand:IsAvailable()) or ((11636 - 7241) == (10833 - 6078))) then
													if (v10.Press(v81.GhostlyStrike) or ((4980 - (1151 + 36)) < (2288 + 81))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (v81.Ambush:IsCastable() or ((1074 + 3010) == (791 - 526))) then
													if (((6190 - (1552 + 280)) == (5192 - (64 + 770))) and v10.Cast(v81.Ambush)) then
														return "Cast Ambush (Opener)";
													end
												end
												break;
											end
										end
									elseif (v110() or ((2131 + 1007) < (2254 - 1261))) then
										local v193 = 0 + 0;
										while true do
											if (((4573 - (157 + 1086)) > (4649 - 2326)) and (v193 == (0 - 0))) then
												v91 = v120();
												if (v91 or ((5561 - 1935) == (5443 - 1454))) then
													return "Finish (Opener): " .. v91;
												end
												break;
											end
										end
									end
									if (v81.SinisterStrike:IsCastable() or ((1735 - (599 + 220)) == (5318 - 2647))) then
										if (((2203 - (1813 + 118)) == (199 + 73)) and v10.Cast(v81.SinisterStrike)) then
											return "Cast Sinister Strike (Opener)";
										end
									end
								end
								return;
							end
						end
					end
				end
				if (((5466 - (841 + 376)) <= (6779 - 1940)) and v81.FanTheHammer:IsAvailable() and (v81.PistolShot:TimeSinceLastCast() < v14:GCDRemains())) then
					v94 = v24(v94, v80.FanTheHammerCP());
				end
				v137 = 2 + 3;
			end
			if (((7579 - 4802) < (4059 - (464 + 395))) and (v137 == (0 - 0))) then
				v78();
				v25 = EpicSettings.Toggles['ooc'];
				v26 = EpicSettings.Toggles['aoe'];
				v27 = EpicSettings.Toggles['cds'];
				v137 = 1 + 0;
			end
			if (((932 - (467 + 370)) < (4044 - 2087)) and (v137 == (1 + 0))) then
				v94 = v14:ComboPoints();
				v93 = v80.EffectiveComboPoints(v94);
				v95 = v14:ComboPointsDeficit();
				v100 = (v14:BuffUp(v81.AdrenalineRush, nil, true) and -(171 - 121)) or (0 + 0);
				v137 = 4 - 2;
			end
			if (((1346 - (150 + 370)) < (2999 - (74 + 1208))) and ((7 - 4) == v137)) then
				if (((6762 - 5336) >= (787 + 318)) and v26) then
					v88 = v14:GetEnemiesInRange(420 - (14 + 376));
					if (((4776 - 2022) <= (2187 + 1192)) and v81.AcrobaticStrikes:IsAvailable()) then
						v89 = v14:GetEnemiesInRange(9 + 1);
					end
					if (not v81.AcrobaticStrikes:IsAvailable() or ((3746 + 181) == (4140 - 2727))) then
						v89 = v14:GetEnemiesInRange(5 + 1);
					end
					v90 = #v89;
				else
					v90 = 79 - (23 + 55);
				end
				v91 = v80.CrimsonVial();
				if (v91 or ((2734 - 1580) <= (526 + 262))) then
					return v91;
				end
				v80.Poisons();
				v137 = 4 + 0;
			end
		end
	end
	local function v123()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(403 - 143, v122, v123);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

