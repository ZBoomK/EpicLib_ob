local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 45 - (5 + 40);
	local v6;
	while true do
		if ((v5 == (1515 - (624 + 891))) or ((3793 - (142 + 748)) > (6181 - (1192 + 35)))) then
			v6 = v0[v4];
			if (((10814 - 7730) > (77 - 37)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((5182 - (1134 + 636)) > (1314 - (263 + 232))) and (v5 == (2 - 1))) then
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
		local v125 = 0 - 0;
		while true do
			if (((3319 - (26 + 131)) <= (100 + 3341)) and (v125 == (11 - 8))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (859 - (240 + 619));
				v57 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v125 = 5 - 1;
			end
			if (((312 + 4394) > (6173 - (1344 + 400))) and (v125 == (407 - (255 + 150)))) then
				v37 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v125 = 2 + 1;
			end
			if (((12193 - 9339) < (13226 - 9131)) and (v125 == (1739 - (404 + 1335)))) then
				v28 = EpicSettings.Settings['UseRacials'];
				v30 = EpicSettings.Settings['UseHealingPotion'];
				v31 = EpicSettings.Settings['HealingPotionName'] or (406 - (183 + 223));
				v32 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v125 = 1 + 0;
			end
			if ((v125 == (3 + 3)) or ((1395 - (10 + 327)) >= (838 + 364))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				break;
			end
			if (((4049 - (118 + 220)) > (1119 + 2236)) and (v125 == (450 - (108 + 341)))) then
				v33 = EpicSettings.Settings['UseHealthstone'];
				v34 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v35 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v36 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1493 - (711 + 782));
				v125 = 3 - 1;
			end
			if ((v125 == (474 - (270 + 199))) or ((294 + 612) >= (4048 - (580 + 1239)))) then
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v125 = 17 - 11;
			end
			if (((1232 + 56) > (45 + 1206)) and (v125 == (2 + 2))) then
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'];
				v125 = 13 - 8;
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
	local v86 = (v85[13 + 0] and v18(v85[61 - 48])) or v18(0 - 0);
	local v87 = (v85[1850 - (1045 + 791)] and v18(v85[34 - 20])) or v18(0 - 0);
	v10:RegisterForEvent(function()
		v85 = v14:GetEquipment();
		v86 = (v85[518 - (351 + 154)] and v18(v85[1587 - (1281 + 293)])) or v18(266 - (28 + 238));
		v87 = (v85[31 - 17] and v18(v85[1573 - (1381 + 178)])) or v18(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v81.Dispatch:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v80.CPSpend() * (0.3 + 0) * (1 + 0) * ((3 - 2) + (v14:VersatilityDmgPct() / (52 + 48))) * ((v15:DebuffUp(v81.GhostlyStrike) and (471.1 - (381 + 89))) or (1 + 0));
	end);
	local v88, v89, v90;
	local v91;
	local v92 = 5 + 1;
	local v93;
	local v94, v95, v96;
	local v97, v98, v99, v100, v101;
	local v102 = {{v81.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v103, v104 = 1455 - (990 + 465), 0 + 0;
	local function v105(v126)
		local v127 = 0 + 0;
		local v128;
		while true do
			if ((v127 == (0 + 0)) or ((17760 - 13247) < (5078 - (1668 + 58)))) then
				v128 = v14:EnergyTimeToMaxPredicted(nil, v126);
				if ((v128 < v103) or ((v128 - v103) > (626.5 - (512 + 114))) or ((5383 - 3318) >= (6606 - 3410))) then
					v103 = v128;
				end
				v127 = 3 - 2;
			end
			if ((v127 == (1 + 0)) or ((820 + 3556) <= (1288 + 193))) then
				return v103;
			end
		end
	end
	local function v106()
		local v129 = 0 - 0;
		local v130;
		while true do
			if ((v129 == (1995 - (109 + 1885))) or ((4861 - (1269 + 200)) >= (9086 - 4345))) then
				return v104;
			end
			if (((4140 - (98 + 717)) >= (2980 - (802 + 24))) and ((0 - 0) == v129)) then
				v130 = v14:EnergyPredicted();
				if ((v130 > v104) or ((v130 - v104) > (10 - 1)) or ((192 + 1103) >= (2484 + 749))) then
					v104 = v130;
				end
				v129 = 1 + 0;
			end
		end
	end
	local v107 = {v81.Broadside,v81.BuriedTreasure,v81.GrandMelee,v81.RuthlessPrecision,v81.SkullandCrossbones,v81.TrueBearing};
	local function v108(v131, v132)
		if (((3183 + 1194) > (767 + 875)) and not v11.APLVar.RtB_List) then
			v11.APLVar.RtB_List = {};
		end
		if (((6156 - (797 + 636)) > (6583 - 5227)) and not v11.APLVar.RtB_List[v131]) then
			v11.APLVar.RtB_List[v131] = {};
		end
		local v133 = table.concat(v132);
		if ((v131 == "All") or ((5755 - (1427 + 192)) <= (1190 + 2243))) then
			if (((9855 - 5610) <= (4163 + 468)) and not v11.APLVar.RtB_List[v131][v133]) then
				local v174 = 0 + 0;
				for v178 = 327 - (192 + 134), #v132 do
					if (((5552 - (316 + 960)) >= (2179 + 1735)) and v14:BuffUp(v107[v132[v178]])) then
						v174 = v174 + 1 + 0;
					end
				end
				v11.APLVar.RtB_List[v131][v133] = ((v174 == #v132) and true) or false;
			end
		elseif (((184 + 14) <= (16687 - 12322)) and not v11.APLVar.RtB_List[v131][v133]) then
			v11.APLVar.RtB_List[v131][v133] = false;
			for v179 = 552 - (83 + 468), #v132 do
				if (((6588 - (1202 + 604)) > (21828 - 17152)) and v14:BuffUp(v107[v132[v179]])) then
					v11.APLVar.RtB_List[v131][v133] = true;
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v131][v133];
	end
	local function v109()
		if (((8095 - 3231) > (6082 - 3885)) and not v11.APLVar.RtB_Buffs) then
			v11.APLVar.RtB_Buffs = {};
			v11.APLVar.RtB_Buffs.Total = 325 - (45 + 280);
			v11.APLVar.RtB_Buffs.Normal = 0 + 0;
			v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
			v11.APLVar.RtB_Buffs.Longer = 0 + 0;
			local v150 = v80.RtBRemains();
			for v172 = 1 + 0, #v107 do
				local v173 = v14:BuffRemains(v107[v172]);
				if ((v173 > (0 + 0)) or ((6851 - 3151) == (4418 - (340 + 1571)))) then
					v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
					if (((6246 - (1733 + 39)) >= (752 - 478)) and (v173 == v150)) then
						v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1035 - (125 + 909));
					elseif ((v173 > v150) or ((3842 - (1096 + 852)) <= (631 + 775))) then
						v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (1 - 0);
					else
						v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
					end
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v110()
		local v134 = 512 - (409 + 103);
		while true do
			if (((1808 - (46 + 190)) >= (1626 - (51 + 44))) and ((0 + 0) == v134)) then
				if (not v11.APLVar.RtB_Reroll or ((6004 - (1114 + 203)) < (5268 - (228 + 498)))) then
					if (((714 + 2577) > (921 + 746)) and (v63 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v109() <= (663 - (174 + 489))) and true) or false;
					elseif ((v63 == "Broadside") or ((2274 - 1401) == (3939 - (830 + 1075)))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.Broadside) and true) or false;
					elseif ((v63 == "Buried Treasure") or ((3340 - (303 + 221)) < (1280 - (231 + 1038)))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.BuriedTreasure) and true) or false;
					elseif (((3083 + 616) < (5868 - (171 + 991))) and (v63 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.GrandMelee) and true) or false;
					elseif (((10904 - 8258) >= (2352 - 1476)) and (v63 == "Skull and Crossbones")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.SkullandCrossbones) and true) or false;
					elseif (((1531 - 917) <= (2549 + 635)) and (v63 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.RuthlessPrecision) and true) or false;
					elseif (((10957 - 7831) == (9017 - 5891)) and (v63 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.TrueBearing) and true) or false;
					else
						v11.APLVar.RtB_Reroll = false;
						v109();
						if (((v109() <= (2 - 0)) and v14:BuffUp(v81.BuriedTreasure) and v14:BuffDown(v81.GrandMelee) and (v90 < (6 - 4))) or ((3435 - (111 + 1137)) >= (5112 - (91 + 67)))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if ((v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:HasTier(92 - 61, 1 + 3) and ((not v14:BuffUp(v81.TrueBearing) and v81.HiddenOpportunity:IsAvailable()) or (not v14:BuffUp(v81.Broadside) and not v81.HiddenOpportunity:IsAvailable())) and (v109() <= (524 - (423 + 100)))) or ((28 + 3849) == (9898 - 6323))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((369 + 338) > (1403 - (326 + 445))) and v81.Crackshot:IsAvailable() and v14:HasTier(135 - 104, 8 - 4) and (v109() <= ((2 - 1) + v20(v14:BuffUp(v81.LoadedDiceBuff)))) and (v81.HiddenOpportunity:IsAvailable() or v14:BuffDown(v81.Broadside))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if ((not v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:BuffUp(v81.SkullandCrossbones) and (v109() < ((713 - (530 + 181)) + v20(v14:BuffUp(v81.GrandMelee)))) and (v90 < (883 - (614 + 267)))) or ((578 - (19 + 13)) >= (4368 - 1684))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((3413 - 1948) <= (12286 - 7985)) and (v11.APLVar.RtB_Reroll or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v109() < (10 - 5)) and (v80.RtBRemains() <= (1851 - (1293 + 519)))))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((3476 - 1772) > (3720 - 2295)) and (v15:FilteredTimeToDie("<", 22 - 10) or v10.BossFilteredFightRemains("<", 51 - 39))) then
							v11.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v111()
		return v94 >= ((v80.CPMaxSpend() - (2 - 1)) - v20((v14:StealthUp(true, true)) and v81.Crackshot:IsAvailable()));
	end
	local function v112()
		return (v81.HiddenOpportunity:IsAvailable() or (v96 >= (2 + 0 + v20(v81.ImprovedAmbush:IsAvailable()) + v20(v14:BuffUp(v81.Broadside))))) and (v97 >= (11 + 39));
	end
	local function v113()
		return not v26 or (v90 < (4 - 2)) or (v14:BuffRemains(v81.BladeFlurry) > (1 + 0 + v20(v81.KillingSpree:IsAvailable())));
	end
	local function v114()
		return v66 and (not v14:IsTanking(v15) or v76);
	end
	local function v115()
		return not v81.ShadowDanceTalent:IsAvailable() and ((v81.FanTheHammer:TalentRank() + v20(v81.QuickDraw:IsAvailable()) + v20(v81.Audacity:IsAvailable())) < (v20(v81.CountTheOdds:IsAvailable()) + v20(v81.KeepItRolling:IsAvailable())));
	end
	local function v116()
		return v14:BuffUp(v81.BetweentheEyes) and (not v81.HiddenOpportunity:IsAvailable() or (v14:BuffDown(v81.AudacityBuff) and ((v81.FanTheHammer:TalentRank() < (1 + 1)) or v14:BuffDown(v81.Opportunity)))) and not v81.Crackshot:IsAvailable();
	end
	local function v117()
		local v135 = 0 + 0;
		while true do
			if (((1096 - (709 + 387)) == v135) or ((2545 - (673 + 1185)) == (12278 - 8044))) then
				if ((v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and v81.HiddenOpportunity:IsAvailable() and not v81.Crackshot:IsAvailable() and not v14:BuffUp(v81.Audacity) and (v115() or (v14:BuffStack(v81.Opportunity) < (19 - 13))) and v112()) or ((5478 - 2148) < (1023 + 406))) then
					if (((858 + 289) >= (451 - 116)) and v10.Cast(v81.Vanish, v66)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((844 + 2591) > (4180 - 2083)) and v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and (not v81.HiddenOpportunity:IsAvailable() or v81.Crackshot:IsAvailable()) and v111()) then
					if (v10.Cast(v81.Vanish, v66) or ((7400 - 3630) >= (5921 - (446 + 1434)))) then
						return "Cast Vanish (Finish)";
					end
				end
				v135 = 1284 - (1040 + 243);
			end
			if ((v135 == (2 - 1)) or ((5638 - (559 + 1288)) <= (3542 - (609 + 1322)))) then
				if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.Crackshot:IsAvailable() and v111()) or ((5032 - (13 + 441)) <= (7503 - 5495))) then
					if (((2946 - 1821) <= (10339 - 8263)) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and not v81.KeepItRolling:IsAvailable() and v116() and v14:BuffUp(v81.SliceandDice) and (v111() or v81.HiddenOpportunity:IsAvailable()) and (not v81.HiddenOpportunity:IsAvailable() or not v81.Vanish:IsReady())) or ((28 + 715) >= (15976 - 11577))) then
					if (((411 + 744) < (734 + 939)) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				v135 = 5 - 3;
			end
			if ((v135 == (2 + 0)) or ((4274 - 1950) <= (383 + 195))) then
				if (((2096 + 1671) == (2707 + 1060)) and v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.KeepItRolling:IsAvailable() and v116() and ((v81.KeepItRolling:CooldownRemains() <= (26 + 4)) or ((v81.KeepItRolling:CooldownRemains() >= (118 + 2)) and (v111() or v81.HiddenOpportunity:IsAvailable())))) then
					if (((4522 - (153 + 280)) == (11807 - 7718)) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				if (((4003 + 455) >= (661 + 1013)) and v81.Shadowmeld:IsAvailable() and v81.Shadowmeld:IsReady()) then
					if (((509 + 463) <= (1287 + 131)) and ((v81.Crackshot:IsAvailable() and v111()) or (not v81.Crackshot:IsAvailable() and ((v81.CountTheOdds:IsAvailable() and v111()) or v81.HiddenOpportunity:IsAvailable())))) then
						if (v10.Cast(v81.Shadowmeld, v28) or ((3579 + 1359) < (7250 - 2488))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (668 - (89 + 578))) or ((1789 + 715) > (8864 - 4600))) then
				v91 = v79.HandleBottomTrinket(v84, v27, 1089 - (572 + 477), nil);
				if (((291 + 1862) == (1293 + 860)) and v91) then
					return v91;
				end
				break;
			end
			if ((v136 == (0 + 0)) or ((593 - (84 + 2)) >= (4269 - 1678))) then
				v91 = v79.HandleTopTrinket(v84, v27, 29 + 11, nil);
				if (((5323 - (497 + 345)) == (115 + 4366)) and v91) then
					return v91;
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v119()
		if ((v27 and v81.AdrenalineRush:IsCastable() and (not v14:BuffUp(v81.AdrenalineRush) or (v14:StealthUp(true, true) and v81.Crackshot:IsAvailable() and v81.ImprovedAdrenalineRush:IsAvailable())) and ((v95 <= (1335 - (605 + 728))) or not v81.ImprovedAdrenalineRush:IsAvailable())) or ((1661 + 667) < (1540 - 847))) then
			if (((199 + 4129) == (16001 - 11673)) and v10.Cast(v81.AdrenalineRush)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((1432 + 156) >= (3690 - 2358)) and ((v81.BladeFlurry:IsReady() and (v90 >= ((2 + 0) - v20(v81.UnderhandedUpperhand:IsAvailable()))) and (v14:BuffRemains(v81.BladeFlurry) < v14:GCDRemains())) or (v81.DeftManeuvers:IsAvailable() and (v90 >= (494 - (457 + 32))) and not v111()))) then
			if (v69 or ((1771 + 2403) > (5650 - (832 + 570)))) then
				v10.Cast(v81.BladeFlurry);
			elseif (v10.Cast(v81.BladeFlurry) or ((4321 + 265) <= (22 + 60))) then
				return "Cast Blade Flurry";
			end
		end
		if (((13670 - 9807) == (1861 + 2002)) and v81.RolltheBones:IsReady()) then
			if (v110() or (v80.RtBRemains() <= (v20(v14:HasTier(827 - (588 + 208), 10 - 6)) + (v20((v81.ShadowDance:CooldownRemains() <= (1801 - (884 + 916))) or (v81.Vanish:CooldownRemains() <= (1 - 0))) * (4 + 2)))) or ((935 - (232 + 421)) <= (1931 - (1569 + 320)))) then
				if (((1131 + 3478) >= (146 + 620)) and v10.Cast(v81.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		if ((v81.KeepItRolling:IsReady() and not v110() and (v109() >= ((9 - 6) + v20(v14:HasTier(636 - (316 + 289), 10 - 6)))) and (v14:BuffDown(v81.ShadowDance) or (v109() >= (1 + 5)))) or ((2605 - (666 + 787)) == (2913 - (360 + 65)))) then
			if (((3199 + 223) > (3604 - (79 + 175))) and v10.Cast(v81.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if (((1382 - 505) > (294 + 82)) and v81.GhostlyStrike:IsAvailable() and v81.GhostlyStrike:IsReady()) then
			if (v10.Cast(v81.GhostlyStrike) or ((9557 - 6439) <= (3564 - 1713))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v27 and v81.Sepsis:IsAvailable() and v81.Sepsis:IsReady()) or ((1064 - (503 + 396)) >= (3673 - (92 + 89)))) then
			if (((7660 - 3711) < (2491 + 2365)) and ((v81.Crackshot:IsAvailable() and v81.BetweentheEyes:IsReady() and v111() and not v14:StealthUp(true, true)) or (not v81.Crackshot:IsAvailable() and v15:FilteredTimeToDie(">", 7 + 4) and v14:BuffUp(v81.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 42 - 31))) then
				if (v10.Cast(v81.Sepsis) or ((585 + 3691) < (6876 - 3860))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((4092 + 598) > (1971 + 2154)) and v81.BladeRush:IsReady() and (v100 > (12 - 8)) and not v14:StealthUp(true, true)) then
			if (v10.Cast(v81.BladeRush) or ((7 + 43) >= (1366 - 470))) then
				return "Cast Blade Rush";
			end
		end
		if (not v14:StealthUp(true, true, true) or ((2958 - (485 + 759)) >= (6844 - 3886))) then
			v91 = v117();
			if (v91 or ((2680 - (442 + 747)) < (1779 - (832 + 303)))) then
				return v91;
			end
		end
		if (((1650 - (88 + 858)) < (301 + 686)) and v27 and v81.ThistleTea:IsAvailable() and v81.ThistleTea:IsCastable() and not v14:BuffUp(v81.ThistleTea) and ((v99 >= (83 + 17)) or v10.BossFilteredFightRemains("<", v81.ThistleTea:Charges() * (1 + 5)))) then
			if (((4507 - (766 + 23)) > (9409 - 7503)) and v10.Cast(v81.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (v81.BloodFury:IsCastable() or ((1309 - 351) > (9577 - 5942))) then
			if (((11882 - 8381) <= (5565 - (1036 + 37))) and v10.Cast(v81.BloodFury, v28)) then
				return "Cast Blood Fury";
			end
		end
		if (v81.Berserking:IsCastable() or ((2441 + 1001) < (4961 - 2413))) then
			if (((2262 + 613) >= (2944 - (641 + 839))) and v10.Cast(v81.Berserking, v28)) then
				return "Cast Berserking";
			end
		end
		if (v81.Fireblood:IsCastable() or ((5710 - (910 + 3)) >= (12473 - 7580))) then
			if (v10.Cast(v81.Fireblood, v28) or ((2235 - (1466 + 218)) > (951 + 1117))) then
				return "Cast Fireblood";
			end
		end
		if (((3262 - (556 + 592)) > (336 + 608)) and v81.AncestralCall:IsCastable()) then
			if (v10.Cast(v81.AncestralCall, v28) or ((3070 - (329 + 479)) >= (3950 - (174 + 680)))) then
				return "Cast Ancestral Call";
			end
		end
		v91 = v118();
		if (v91 or ((7748 - 5493) >= (7331 - 3794))) then
			return v91;
		end
	end
	local function v120()
		if ((v81.BladeFlurry:IsReady() and v81.BladeFlurry:IsCastable() and v26 and v81.Subterfuge:IsAvailable() and (v90 >= (2 + 0)) and (v14:BuffRemains(v81.BladeFlurry) <= v14:GCDRemains())) or ((4576 - (396 + 343)) < (116 + 1190))) then
			if (((4427 - (29 + 1448)) == (4339 - (135 + 1254))) and v69) then
				v10.Press(v81.BladeFlurry);
			elseif (v10.Press(v81.BladeFlurry) or ((17792 - 13069) < (15398 - 12100))) then
				return "Cast Blade Flurry";
			end
		end
		if (((758 + 378) >= (1681 - (389 + 1138))) and v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch) and v111()) then
			if (v10.Cast(v81.ColdBlood) or ((845 - (102 + 472)) > (4481 + 267))) then
				return "Cast Cold Blood";
			end
		end
		if (((2629 + 2111) >= (2940 + 212)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v111() and v81.Crackshot:IsAvailable()) then
			if (v10.Press(v81.BetweentheEyes) or ((4123 - (320 + 1225)) >= (6034 - 2644))) then
				return "Cast Between the Eyes";
			end
		end
		if (((26 + 15) <= (3125 - (157 + 1307))) and v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch) and v111()) then
			if (((2460 - (821 + 1038)) < (8882 - 5322)) and v10.Press(v81.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((26 + 209) < (1220 - 533)) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and v81.Crackshot:IsAvailable() and (v81.FanTheHammer:TalentRank() >= (1 + 1)) and (v14:BuffStack(v81.Opportunity) >= (14 - 8)) and ((v14:BuffUp(v81.Broadside) and (v95 <= (1027 - (834 + 192)))) or v14:BuffUp(v81.GreenskinsWickersBuff))) then
			if (((290 + 4259) > (296 + 857)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v81.Ambush:IsCastable() and v15:IsSpellInRange(v81.Ambush) and v81.HiddenOpportunity:IsAvailable()) or ((101 + 4573) < (7237 - 2565))) then
			if (((3972 - (300 + 4)) < (1219 + 3342)) and v10.Press(v81.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v121()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (363 - (112 + 250))) or ((182 + 273) == (9031 - 5426))) then
				if ((v81.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v89, ">", v14:BuffRemains(v81.SliceandDice), true) or (v14:BuffRemains(v81.SliceandDice) == (0 + 0))) and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v95) * (1.8 + 0)))) or ((1321 + 1342) == (2461 + 851))) then
					if (((5691 - (1001 + 413)) <= (9979 - 5504)) and v10.Press(v81.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v81.KillingSpree:IsCastable() and v15:IsSpellInRange(v81.KillingSpree) and (v15:DebuffUp(v81.GhostlyStrike) or not v81.GhostlyStrike:IsAvailable())) or ((1752 - (244 + 638)) == (1882 - (627 + 66)))) then
					if (((4627 - 3074) <= (3735 - (512 + 90))) and v10.Cast(v81.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v137 = 1908 - (1665 + 241);
			end
			if ((v137 == (719 - (373 + 344))) or ((1009 + 1228) >= (929 + 2582))) then
				if ((v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch)) or ((3492 - 2168) > (5110 - 2090))) then
					if (v10.Cast(v81.ColdBlood, v54) or ((4091 - (35 + 1064)) == (1369 + 512))) then
						return "Cast Cold Blood";
					end
				end
				if (((6645 - 3539) > (7 + 1519)) and v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch)) then
					if (((4259 - (298 + 938)) < (5129 - (233 + 1026))) and v10.Press(v81.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((1809 - (636 + 1030)) > (38 + 36)) and (v137 == (0 + 0))) then
				if (((6 + 12) < (143 + 1969)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and not v81.Crackshot:IsAvailable() and ((v14:BuffRemains(v81.BetweentheEyes) < (225 - (55 + 166))) or v81.ImprovedBetweenTheEyes:IsAvailable() or v81.GreenskinsWickers:IsAvailable() or v14:HasTier(6 + 24, 1 + 3)) and v14:BuffDown(v81.GreenskinsWickers)) then
					if (((4189 - 3092) <= (1925 - (36 + 261))) and v10.Press(v81.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((8097 - 3467) == (5998 - (34 + 1334))) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v81.Crackshot:IsAvailable() and (v81.Vanish:CooldownRemains() > (18 + 27)) and (v81.ShadowDance:CooldownRemains() > (10 + 2))) then
					if (((4823 - (1035 + 248)) > (2704 - (20 + 1))) and v10.Press(v81.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v122()
		local v138 = 319 - (134 + 185);
		while true do
			if (((5927 - (549 + 584)) >= (3960 - (314 + 371))) and (v138 == (3 - 2))) then
				if (((2452 - (478 + 490)) == (787 + 697)) and v81.FanTheHammer:IsAvailable() and v81.Audacity:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.Opportunity) and v14:BuffDown(v81.AudacityBuff)) then
					if (((2604 - (786 + 386)) < (11514 - 7959)) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v14:BuffUp(v81.GreenskinsWickersBuff) and ((not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity)) or (v14:BuffRemains(v81.GreenskinsWickersBuff) < (1380.5 - (1055 + 324))))) or ((2405 - (1093 + 247)) > (3180 + 398))) then
					if (v10.Press(v81.PistolShot) or ((505 + 4290) < (5586 - 4179))) then
						return "Cast Pistol Shot (GSW Dump)";
					end
				end
				v138 = 6 - 4;
			end
			if (((5272 - 3419) < (12094 - 7281)) and (v138 == (0 + 0))) then
				if ((v27 and v81.EchoingReprimand:IsReady()) or ((10867 - 8046) < (8379 - 5948))) then
					if (v10.Cast(v81.EchoingReprimand, nil, v75) or ((2168 + 706) < (5577 - 3396))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v81.Ambush:IsCastable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.AudacityBuff)) or ((3377 - (364 + 324)) <= (939 - 596))) then
					if (v10.Press(v81.Ambush) or ((4484 - 2615) == (666 + 1343))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v138 = 4 - 3;
			end
			if ((v138 == (2 - 0)) or ((10769 - 7223) < (3590 - (1249 + 19)))) then
				if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v14:BuffStack(v81.Opportunity) >= (6 + 0)) or (v14:BuffRemains(v81.Opportunity) < (7 - 5)))) or ((3168 - (686 + 400)) == (3745 + 1028))) then
					if (((3473 - (73 + 156)) > (5 + 1050)) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				if ((v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and (v96 > ((812 - (721 + 90)) + (v20(v81.QuickDraw:IsAvailable()) * v81.FanTheHammer:TalentRank()))) and ((not v81.Vanish:IsReady() and not v81.ShadowDance:IsReady()) or v14:StealthUp(true, true) or not v81.Crackshot:IsAvailable() or (v81.FanTheHammer:TalentRank() <= (1 + 0)))) or ((10756 - 7443) <= (2248 - (224 + 246)))) then
					if (v10.Press(v81.PistolShot) or ((2301 - 880) >= (3873 - 1769))) then
						return "Cast Pistol Shot";
					end
				end
				v138 = 1 + 2;
			end
			if (((44 + 1768) <= (2387 + 862)) and (v138 == (5 - 2))) then
				if (((5400 - 3777) <= (2470 - (203 + 310))) and not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v100 > (1994.5 - (1238 + 755))) or (v96 <= (1 + 0 + v20(v14:BuffUp(v81.Broadside)))) or v81.QuickDraw:IsAvailable() or (v81.Audacity:IsAvailable() and v14:BuffDown(v81.AudacityBuff)))) then
					if (((5946 - (709 + 825)) == (8129 - 3717)) and v10.Press(v81.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((2549 - 799) >= (1706 - (196 + 668))) and v81.SinisterStrike:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) then
					if (((17261 - 12889) > (3832 - 1982)) and v10.Press(v81.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
		end
	end
	local function v123()
		v78();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v92 = (v81.AcrobaticStrikes:IsAvailable() and (843 - (171 + 662))) or (99 - (4 + 89));
		v95 = v14:ComboPoints();
		v94 = v80.EffectiveComboPoints(v95);
		v96 = v14:ComboPointsDeficit();
		v101 = (v14:BuffUp(v81.AdrenalineRush, nil, true) and -(175 - 125)) or (0 + 0);
		v97 = v106();
		v98 = v14:EnergyRegen();
		v100 = v105(v101);
		v99 = v14:EnergyDeficitPredicted(nil, v101);
		if (((1018 - 786) < (322 + 499)) and v26) then
			v88 = v14:GetEnemiesInRange(1516 - (35 + 1451));
			v89 = v14:GetEnemiesInRange(v92);
			v90 = #v89;
		else
			v90 = 1454 - (28 + 1425);
		end
		v91 = v80.CrimsonVial();
		if (((2511 - (941 + 1052)) < (865 + 37)) and v91) then
			return v91;
		end
		v80.Poisons();
		if (((4508 - (822 + 692)) > (1224 - 366)) and v82.Healthstone:IsReady() and (v14:HealthPercentage() < v34) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (v10.Cast(v83.Healthstone) or ((1769 + 1986) <= (1212 - (45 + 252)))) then
				return "Healthstone ";
			end
		end
		if (((3905 + 41) > (1289 + 2454)) and v82.RefreshingHealingPotion:IsReady() and (v14:HealthPercentage() < v32) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (v10.Cast(v83.RefreshingHealingPotion) or ((3249 - 1914) >= (3739 - (114 + 319)))) then
				return "RefreshingHealingPotion ";
			end
		end
		if (((6954 - 2110) > (2886 - 633)) and v81.Feint:IsCastable() and (v14:HealthPercentage() <= v57) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (((289 + 163) == (672 - 220)) and v10.Cast(v81.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((not v14:AffectingCombat() and not v14:IsMounted() and v58) or ((9548 - 4991) < (4050 - (556 + 1407)))) then
			local v151 = 1206 - (741 + 465);
			while true do
				if (((4339 - (170 + 295)) == (2042 + 1832)) and (v151 == (0 + 0))) then
					v91 = v80.Stealth(v81.Stealth2, nil);
					if (v91 or ((4771 - 2833) > (4091 + 844))) then
						return "Stealth (OOC): " .. v91;
					end
					break;
				end
			end
		end
		if ((not v14:AffectingCombat() and (v81.Vanish:TimeSinceLastCast() > (1 + 0)) and v15:IsInRange(5 + 3) and v25) or ((5485 - (957 + 273)) < (916 + 2507))) then
			if (((583 + 871) <= (9491 - 7000)) and v79.TargetIsValid() and v15:IsInRange(26 - 16) and not (v14:IsChanneling() or v14:IsCasting())) then
				local v177 = 0 - 0;
				while true do
					if ((v177 == (0 - 0)) or ((5937 - (389 + 1391)) <= (1759 + 1044))) then
						if (((506 + 4347) >= (6788 - 3806)) and v81.BladeFlurry:IsReady() and v14:BuffDown(v81.BladeFlurry) and v81.UnderhandedUpperhand:IsAvailable() and not v14:StealthUp(true, true)) then
							if (((5085 - (783 + 168)) > (11266 - 7909)) and v10.Cast(v81.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v14:StealthUp(true, false) or ((3362 + 55) < (2845 - (309 + 2)))) then
							local v188 = 0 - 0;
							while true do
								if ((v188 == (1212 - (1090 + 122))) or ((883 + 1839) <= (550 - 386))) then
									v91 = v80.Stealth(v80.StealthSpell());
									if (v91 or ((1648 + 760) < (3227 - (628 + 490)))) then
										return v91;
									end
									break;
								end
							end
						end
						v177 = 1 + 0;
					end
					if ((v177 == (2 - 1)) or ((150 - 117) == (2229 - (431 + 343)))) then
						if (v79.TargetIsValid() or ((894 - 451) >= (11615 - 7600))) then
							if (((2672 + 710) > (22 + 144)) and v81.AdrenalineRush:IsReady() and v81.ImprovedAdrenalineRush:IsAvailable() and (v95 <= (1697 - (556 + 1139)))) then
								if (v10.Cast(v81.AdrenalineRush) or ((295 - (6 + 9)) == (561 + 2498))) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if (((964 + 917) > (1462 - (28 + 141))) and v81.RolltheBones:IsReady() and not v14:DebuffUp(v81.Dreadblades) and ((v109() == (0 + 0)) or v110())) then
								if (((2908 - 551) == (1670 + 687)) and v10.Cast(v81.RolltheBones)) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if (((1440 - (486 + 831)) == (319 - 196)) and v81.SliceandDice:IsReady() and (v14:BuffRemains(v81.SliceandDice) < (((3 - 2) + v95) * (1.8 + 0)))) then
								if (v10.Press(v81.SliceandDice) or ((3338 - 2282) >= (4655 - (668 + 595)))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (v14:StealthUp(true, false) or ((973 + 108) < (217 + 858))) then
								v91 = v120();
								if (v91 or ((2860 - 1811) >= (4722 - (23 + 267)))) then
									return "Stealth (Opener): " .. v91;
								end
								if ((v81.KeepItRolling:IsAvailable() and v81.GhostlyStrike:IsReady() and v81.EchoingReprimand:IsAvailable()) or ((6712 - (1129 + 815)) <= (1233 - (371 + 16)))) then
									if (v10.Press(v81.GhostlyStrike) or ((5108 - (1326 + 424)) <= (2689 - 1269))) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if (v81.Ambush:IsCastable() or ((13663 - 9924) <= (3123 - (88 + 30)))) then
									if (v10.Cast(v81.Ambush) or ((2430 - (720 + 51)) >= (4746 - 2612))) then
										return "Cast Ambush (Opener)";
									end
								end
							elseif (v111() or ((5036 - (421 + 1355)) < (3885 - 1530))) then
								v91 = v121();
								if (v91 or ((329 + 340) == (5306 - (286 + 797)))) then
									return "Finish (Opener): " .. v91;
								end
							end
							if (v81.SinisterStrike:IsCastable() or ((6185 - 4493) < (973 - 385))) then
								if (v10.Cast(v81.SinisterStrike) or ((5236 - (397 + 42)) < (1141 + 2510))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
			end
		end
		if ((v81.FanTheHammer:IsAvailable() and (v81.PistolShot:TimeSinceLastCast() < v14:GCDRemains())) or ((4977 - (24 + 776)) > (7471 - 2621))) then
			v95 = v24(v95, v80.FanTheHammerCP());
		end
		if (v79.TargetIsValid() or ((1185 - (222 + 563)) > (2447 - 1336))) then
			local v152 = 0 + 0;
			while true do
				if (((3241 - (23 + 167)) > (2803 - (690 + 1108))) and (v152 == (0 + 0))) then
					v91 = v119();
					if (((3047 + 646) <= (5230 - (40 + 808))) and v91) then
						return "CDs: " .. v91;
					end
					if (v14:StealthUp(true, true) or v14:BuffUp(v81.Shadowmeld) or ((541 + 2741) > (15678 - 11578))) then
						v91 = v120();
						if (v91 or ((3422 + 158) < (1505 + 1339))) then
							return "Stealth: " .. v91;
						end
					end
					v152 = 1 + 0;
				end
				if (((660 - (47 + 524)) < (2914 + 1576)) and (v152 == (2 - 1))) then
					if (v111() or ((7450 - 2467) < (4123 - 2315))) then
						local v184 = 1726 - (1165 + 561);
						while true do
							if (((114 + 3715) > (11672 - 7903)) and (v184 == (0 + 0))) then
								v91 = v121();
								if (((1964 - (341 + 138)) <= (784 + 2120)) and v91) then
									return "Finish: " .. v91;
								end
								break;
							end
						end
					end
					v91 = v122();
					if (((8809 - 4540) == (4595 - (89 + 237))) and v91) then
						return "Build: " .. v91;
					end
					v152 = 6 - 4;
				end
				if (((814 - 427) <= (3663 - (581 + 300))) and ((1223 - (855 + 365)) == v152)) then
					if ((v81.BagofTricks:IsCastable() and v15:IsInMeleeRange(11 - 6)) or ((621 + 1278) <= (2152 - (1030 + 205)))) then
						if (v10.Cast(v81.BagofTricks, v28) or ((4049 + 263) <= (815 + 61))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((2518 - (156 + 130)) <= (5898 - 3302)) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and not v15:IsInRange(v92) and not v14:StealthUp(true, true) and (v99 < (42 - 17)) and ((v96 >= (1 - 0)) or (v100 <= (1.2 + 0)))) then
						if (((1222 + 873) < (3755 - (10 + 59))) and v10.Cast(v81.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v81.SinisterStrike:IsCastable() or ((452 + 1143) >= (22033 - 17559))) then
						if (v10.Cast(v81.SinisterStrike) or ((5782 - (671 + 492)) < (2295 + 587))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((1217 - (369 + 846)) == v152) or ((78 + 216) >= (4123 + 708))) then
					if (((3974 - (1036 + 909)) <= (2453 + 631)) and v81.ArcaneTorrent:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike) and (v99 > ((25 - 10) + v98))) then
						if (v10.Cast(v81.ArcaneTorrent, v28) or ((2240 - (11 + 192)) == (1223 + 1197))) then
							return "Cast Arcane Torrent";
						end
					end
					if (((4633 - (135 + 40)) > (9458 - 5554)) and v81.ArcanePulse:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) then
						if (((263 + 173) >= (270 - 147)) and v10.Cast(v81.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if (((749 - 249) < (1992 - (50 + 126))) and v81.LightsJudgment:IsCastable() and v15:IsInMeleeRange(13 - 8)) then
						if (((792 + 2782) == (4987 - (1233 + 180))) and v10.Cast(v81.LightsJudgment, v28)) then
							return "Cast Lights Judgment";
						end
					end
					v152 = 972 - (522 + 447);
				end
			end
		end
	end
	local function v124()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1681 - (107 + 1314), v123, v124);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

