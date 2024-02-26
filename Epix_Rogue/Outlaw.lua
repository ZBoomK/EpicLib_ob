local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1150 - (428 + 722);
	local v6;
	while true do
		if (((7296 - 3472) > (1215 - 806)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((75 + 2012) == (910 + 1177)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((4571 - (645 + 522)) > (6293 - (1010 + 780)))) then
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
		local v127 = 0 + 0;
		while true do
			if ((v127 == (19 - 15)) or ((10274 - 6768) <= (3145 - (1045 + 791)))) then
				v59 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'] or (0 - 0);
				v127 = 7 - 2;
			end
			if (((3460 - (351 + 154)) == (4529 - (1281 + 293))) and (v127 == (271 - (28 + 238)))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v127 = 12 - 6;
			end
			if ((v127 == (1561 - (1381 + 178))) or ((2723 + 180) == (1206 + 289))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v127 = 10 - 7;
			end
			if (((2356 + 2190) >= (2745 - (381 + 89))) and (v127 == (6 + 0))) then
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'] or (0 + 0);
				v127 = 11 - 4;
			end
			if (((1975 - (1074 + 82)) >= (47 - 25)) and (v127 == (1784 - (214 + 1570)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (1455 - (990 + 465));
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v127 = 1 + 0;
			end
			if (((3075 + 87) == (12443 - 9281)) and ((1733 - (1668 + 58)) == v127)) then
				v80 = EpicSettings.Settings['EvasionHP'] or (626 - (512 + 114));
				break;
			end
			if ((v127 == (7 - 4)) or ((4897 - 2528) > (15411 - 10982))) then
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v127 = 4 + 0;
			end
			if (((13812 - 9717) >= (5177 - (109 + 1885))) and (v127 == (1470 - (1269 + 200)))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptWithStun'] or (815 - (98 + 717));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (826 - (802 + 24));
				v127 = 2 - 0;
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
	local v89 = (v88[15 - 2] and v20(v88[2 + 11])) or v20(0 + 0);
	local v90 = (v88[3 + 11] and v20(v88[4 + 10])) or v20(0 - 0);
	v10:RegisterForEvent(function()
		v88 = v16:GetEquipment();
		v89 = (v88[43 - 30] and v20(v88[5 + 8])) or v20(0 + 0);
		v90 = (v88[12 + 2] and v20(v88[11 + 3])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v84.Dispatch:RegisterDamageFormula(function()
		return v16:AttackPowerDamageMod() * v83.CPSpend() * (1433.3 - (797 + 636)) * (4 - 3) * ((1620 - (1427 + 192)) + (v16:VersatilityDmgPct() / (35 + 65))) * ((v17:DebuffUp(v84.GhostlyStrike) and (2.1 - 1)) or (1 + 0));
	end);
	local v91, v92, v93;
	local v94;
	local v95;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v105, v106 = 0 + 0, 0 + 0;
	local function v107(v128)
		local v129 = v16:EnergyTimeToMaxPredicted(nil, v128);
		if ((v129 < v105) or ((v129 - v105) > (0.5 - 0)) or ((4262 - (83 + 468)) < (2814 - (1202 + 604)))) then
			v105 = v129;
		end
		return v105;
	end
	local function v108()
		local v130 = v16:EnergyPredicted();
		if ((v130 > v106) or ((v130 - v106) > (41 - 32)) or ((1745 - 696) <= (2508 - 1602))) then
			v106 = v130;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local function v110(v131, v132)
		if (((8356 - 3843) > (4637 - (340 + 1571))) and not v11.APLVar.RtB_List) then
			v11.APLVar.RtB_List = {};
		end
		if (not v11.APLVar.RtB_List[v131] or ((585 + 896) >= (4430 - (1733 + 39)))) then
			v11.APLVar.RtB_List[v131] = {};
		end
		local v133 = table.concat(v132);
		if ((v131 == "All") or ((8848 - 5628) == (2398 - (125 + 909)))) then
			if (not v11.APLVar.RtB_List[v131][v133] or ((3002 - (1096 + 852)) > (1522 + 1870))) then
				local v174 = 0 - 0;
				for v178 = 1 + 0, #v132 do
					if (v16:BuffUp(v109[v132[v178]]) or ((1188 - (409 + 103)) >= (1878 - (46 + 190)))) then
						v174 = v174 + (96 - (51 + 44));
					end
				end
				v11.APLVar.RtB_List[v131][v133] = ((v174 == #v132) and true) or false;
			end
		elseif (((1167 + 2969) > (3714 - (1114 + 203))) and not v11.APLVar.RtB_List[v131][v133]) then
			v11.APLVar.RtB_List[v131][v133] = false;
			for v179 = 727 - (228 + 498), #v132 do
				if (v16:BuffUp(v109[v132[v179]]) or ((939 + 3395) == (2346 + 1899))) then
					v11.APLVar.RtB_List[v131][v133] = true;
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v131][v133];
	end
	local function v111()
		if (not v11.APLVar.RtB_Buffs or ((4939 - (174 + 489)) <= (7896 - 4865))) then
			v11.APLVar.RtB_Buffs = {};
			v11.APLVar.RtB_Buffs.Total = 1905 - (830 + 1075);
			v11.APLVar.RtB_Buffs.Normal = 524 - (303 + 221);
			v11.APLVar.RtB_Buffs.Shorter = 1269 - (231 + 1038);
			v11.APLVar.RtB_Buffs.Longer = 0 + 0;
			local v149 = v83.RtBRemains();
			for v172 = 1163 - (171 + 991), #v109 do
				local v173 = v16:BuffRemains(v109[v172]);
				if ((v173 > (0 - 0)) or ((12840 - 8058) <= (2991 - 1792))) then
					v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
					if ((v173 == v149) or ((17049 - 12185) < (5486 - 3584))) then
						v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1 - 0);
					elseif (((14958 - 10119) >= (4948 - (111 + 1137))) and (v173 > v149)) then
						v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (159 - (91 + 67));
					else
						v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (2 - 1);
					end
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v112()
		if (not v11.APLVar.RtB_Reroll or ((269 + 806) > (2441 - (423 + 100)))) then
			if (((3 + 393) <= (10532 - 6728)) and (v64 == "1+ Buff")) then
				v11.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
			elseif ((v64 == "Broadside") or ((4940 - (326 + 445)) == (9543 - 7356))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.Broadside) and true) or false;
			elseif (((3131 - 1725) == (3281 - 1875)) and (v64 == "Buried Treasure")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif (((2242 - (530 + 181)) < (5152 - (614 + 267))) and (v64 == "Grand Melee")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.GrandMelee) and true) or false;
			elseif (((667 - (19 + 13)) == (1033 - 398)) and (v64 == "Skull and Crossbones")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((7859 - 4486) <= (10158 - 6602)) and (v64 == "Ruthless Precision")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((855 + 2436) < (5768 - 2488))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.TrueBearing) and true) or false;
			else
				local v194 = 0 - 0;
				while true do
					if (((6198 - (1293 + 519)) >= (1781 - 908)) and (v194 == (7 - 4))) then
						if (((1761 - 840) <= (4751 - 3649)) and v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (0 - 0)) or (v11.APLVar.RtB_Buffs.Normal == (0 + 0))) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v111() < (11 - 6)) and (v83.RtBRemains() <= (10 + 29)) and not v16:StealthUp(true, true)) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((1564 + 3142) >= (602 + 361)) and (v17:FilteredTimeToDie("<", 1108 - (709 + 387)) or v10.BossFilteredFightRemains("<", 1870 - (673 + 1185)))) then
							v11.APLVar.RtB_Reroll = false;
						end
						break;
					end
					if (((2 - 1) == v194) or ((3082 - 2122) <= (1440 - 564))) then
						if (((v111() <= (2 + 0)) and v16:BuffUp(v84.BuriedTreasure) and v16:BuffDown(v84.GrandMelee) and (v93 < (2 + 0))) or ((2788 - 722) == (229 + 703))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((9620 - 4795) < (9506 - 4663)) and v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:HasTier(1911 - (446 + 1434), 1287 - (1040 + 243)) and ((not v16:BuffUp(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v16:BuffUp(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v111() <= (2 - 1))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v194 = 1849 - (559 + 1288);
					end
					if (((1933 - (609 + 1322)) == v194) or ((4331 - (13 + 441)) >= (16953 - 12416))) then
						if ((v84.Crackshot:IsAvailable() and v16:HasTier(81 - 50, 19 - 15) and (v111() <= (1 + 0 + v22(v16:BuffUp(v84.LoadedDiceBuff))))) or ((15671 - 11356) < (614 + 1112))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:BuffUp(v84.SkullandCrossbones) and (v111() < (1 + 1 + v22(v16:BuffUp(v84.GrandMelee)))) and (v93 < (5 - 3))) or ((2014 + 1665) < (1149 - 524))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v194 = 2 + 1;
					end
					if ((v194 == (0 + 0)) or ((3324 + 1301) < (531 + 101))) then
						v11.APLVar.RtB_Reroll = false;
						v111();
						v194 = 1 + 0;
					end
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v113()
		return v96 >= ((v83.CPMaxSpend() - (434 - (153 + 280))) - v22((v16:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v114()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((5 - 3) + v22(v84.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v84.Broadside))))) and (v99 >= (45 + 5));
	end
	local function v115()
		return not v28 or (v93 < (1 + 1)) or (v16:BuffRemains(v84.BladeFlurry) > (1 + 0 + v22(v84.KillingSpree:IsAvailable())));
	end
	local function v116()
		return v67 and (not v16:IsTanking(v17) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v22(v84.QuickDraw:IsAvailable()) + v22(v84.Audacity:IsAvailable())) < (v22(v84.CountTheOdds:IsAvailable()) + v22(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v16:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (2 + 0)) or v16:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (1 - 0)) or ((52 + 31) > (2447 - (89 + 578)))) then
				if (((391 + 155) <= (2238 - 1161)) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v113() and ((v84.Vanish:CooldownRemains() >= (1055 - (572 + 477))) or not v67) and not v16:StealthUp(true, false)) then
					if (v10.Cast(v84.ShadowDance, v53) or ((135 + 861) > (2582 + 1719))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((486 + 3584) > (773 - (84 + 2))) and v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and not v84.KeepItRolling:IsAvailable() and v118() and v16:BuffUp(v84.SliceandDice) and (v113() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady())) then
					if (v10.Cast(v84.ShadowDance, v53) or ((1080 - 424) >= (2399 + 931))) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 844 - (497 + 345);
			end
			if (((0 + 0) == v134) or ((422 + 2070) <= (1668 - (605 + 728)))) then
				if (((3084 + 1238) >= (5695 - 3133)) and v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v16:BuffUp(v84.Audacity) and (v117() or (v16:BuffStack(v84.Opportunity) < (1 + 5))) and v114()) then
					if (v10.Cast(v84.Vanish, v67) or ((13446 - 9809) >= (3399 + 371))) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v113()) or ((6590 - 4211) > (3457 + 1121))) then
					if (v10.Cast(v84.Vanish, v67) or ((972 - (457 + 32)) > (316 + 427))) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 1403 - (832 + 570);
			end
			if (((2312 + 142) > (151 + 427)) and (v134 == (6 - 4))) then
				if (((448 + 482) < (5254 - (588 + 208))) and v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (80 - 50)) or ((v84.KeepItRolling:CooldownRemains() >= (1920 - (884 + 916))) and (v113() or v84.HiddenOpportunity:IsAvailable())))) then
					if (((1385 - 723) <= (564 + 408)) and v10.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				if (((5023 - (232 + 421)) == (6259 - (1569 + 320))) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady()) then
					if ((v84.Crackshot:IsAvailable() and v113()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v113()) or v84.HiddenOpportunity:IsAvailable())) or ((1169 + 3593) <= (164 + 697))) then
						if (v10.Cast(v84.Shadowmeld, v30) or ((4758 - 3346) == (4869 - (316 + 289)))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v135 = v82.HandleTopTrinket(v87, v29, 104 - 64, nil);
		if (v135 or ((147 + 3021) < (3606 - (666 + 787)))) then
			return v135;
		end
		local v135 = v82.HandleBottomTrinket(v87, v29, 465 - (360 + 65), nil);
		if (v135 or ((4651 + 325) < (1586 - (79 + 175)))) then
			return v135;
		end
	end
	local function v121()
		local v136 = v82.HandleDPSPotion(v16:BuffUp(v84.AdrenalineRush));
		if (((7297 - 2669) == (3612 + 1016)) and v136) then
			return v136;
		end
		if ((v29 and v84.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v84.AdrenalineRush) and (not v113() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (5 - 3))))) or ((103 - 49) == (1294 - (503 + 396)))) then
			if (((263 - (92 + 89)) == (158 - 76)) and v12(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (v84.BladeFlurry:IsReady() or ((298 + 283) < (167 + 115))) then
			if (((v93 >= ((7 - 5) - v22(v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v84.AdrenalineRush)))) and (v16:BuffRemains(v84.BladeFlurry) < v16:GCD())) or ((631 + 3978) < (5688 - 3193))) then
				if (((1006 + 146) == (551 + 601)) and v12(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((5774 - 3878) <= (428 + 2994)) and v84.BladeFlurry:IsReady()) then
			if ((v84.DeftManeuvers:IsAvailable() and not v113() and (((v93 >= (4 - 1)) and (v98 == (v93 + v22(v16:BuffUp(v84.Broadside))))) or (v93 >= (1249 - (485 + 759))))) or ((2290 - 1300) > (2809 - (442 + 747)))) then
				if (v12(v84.BladeFlurry) or ((2012 - (832 + 303)) > (5641 - (88 + 858)))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((821 + 1870) >= (1532 + 319)) and v84.RolltheBones:IsReady()) then
			if ((v112() and not v16:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v83.RtBRemains() <= (792 - (766 + 23))) and v16:HasTier(153 - 122, 5 - 1)) or ((v83.RtBRemains() <= (18 - 11)) and ((v84.ShadowDance:CooldownRemains() <= (10 - 7)) or (v84.Vanish:CooldownRemains() <= (1076 - (1036 + 37)))) and not v16:StealthUp(true, true)) or ((2117 + 868) >= (9456 - 4600))) then
				if (((3364 + 912) >= (2675 - (641 + 839))) and v12(v84.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v137 = v120();
		if (((4145 - (910 + 3)) <= (11956 - 7266)) and v137) then
			return v137;
		end
		if ((v84.KeepItRolling:IsReady() and not v112() and (v111() >= ((1687 - (1466 + 218)) + v22(v16:HasTier(15 + 16, 1152 - (556 + 592))))) and (v16:BuffDown(v84.ShadowDance) or (v111() >= (3 + 3)))) or ((1704 - (329 + 479)) >= (4000 - (174 + 680)))) then
			if (((10518 - 7457) >= (6130 - 3172)) and v10.Cast(v84.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if (((2276 + 911) >= (1383 - (396 + 343))) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (1 + 6))) then
			if (((2121 - (29 + 1448)) <= (2093 - (135 + 1254))) and v12(v84.GhostlyStrike, v72, nil, not v17:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if (((3608 - 2650) > (4421 - 3474)) and v29 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
			if (((2994 + 1498) >= (4181 - (389 + 1138))) and ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v113() and not v16:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 585 - (102 + 472)) and v16:BuffUp(v84.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 11 + 0))) then
				if (((1909 + 1533) >= (1402 + 101)) and v10.Cast(v84.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v84.BladeRush:IsReady() and (v102 > (1549 - (320 + 1225))) and not v16:StealthUp(true, true)) or ((5643 - 2473) <= (896 + 568))) then
			if (v10.Cast(v84.BladeRush) or ((6261 - (157 + 1307)) == (6247 - (821 + 1038)))) then
				return "Cast Blade Rush";
			end
		end
		if (((1374 - 823) <= (75 + 606)) and not v16:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
			local v150 = 0 - 0;
			while true do
				if (((1220 + 2057) > (1008 - 601)) and (v150 == (1026 - (834 + 192)))) then
					v137 = v119();
					if (((299 + 4396) >= (364 + 1051)) and v137) then
						return v137;
					end
					break;
				end
			end
		end
		if ((v29 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v16:BuffUp(v84.ThistleTea) and ((v101 >= (3 + 97)) or v10.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (8 - 2)))) or ((3516 - (300 + 4)) <= (253 + 691))) then
			if (v10.Cast(v84.ThistleTea) or ((8104 - 5008) <= (2160 - (112 + 250)))) then
				return "Cast Thistle Tea";
			end
		end
		if (((1411 + 2126) == (8860 - 5323)) and v84.BloodFury:IsCastable()) then
			if (((2199 + 1638) >= (812 + 758)) and v10.Cast(v84.BloodFury, v30)) then
				return "Cast Blood Fury";
			end
		end
		if (v84.Berserking:IsCastable() or ((2207 + 743) == (1891 + 1921))) then
			if (((3509 + 1214) >= (3732 - (1001 + 413))) and v10.Cast(v84.Berserking, v30)) then
				return "Cast Berserking";
			end
		end
		if (v84.Fireblood:IsCastable() or ((4520 - 2493) > (3734 - (244 + 638)))) then
			if (v10.Cast(v84.Fireblood, v30) or ((1829 - (627 + 66)) > (12862 - 8545))) then
				return "Cast Fireblood";
			end
		end
		if (((5350 - (512 + 90)) == (6654 - (1665 + 241))) and v84.AncestralCall:IsCastable()) then
			if (((4453 - (373 + 344)) <= (2138 + 2602)) and v10.Cast(v84.AncestralCall, v30)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		if ((v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v28 and v84.Subterfuge:IsAvailable() and (v93 >= (1 + 1)) and (v16:BuffRemains(v84.BladeFlurry) <= v16:GCDRemains())) or ((8941 - 5551) <= (5178 - 2118))) then
			if (v70 or ((2098 - (35 + 1064)) > (1960 + 733))) then
				if (((990 - 527) < (3 + 598)) and v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(1246 - (298 + 938)))) then
					return "Cast Blade Flurry";
				end
			elseif (v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(1269 - (233 + 1026))) or ((3849 - (636 + 1030)) < (352 + 335))) then
				return "Cast Blade Flurry";
			end
		end
		if (((4444 + 105) == (1352 + 3197)) and v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch) and v113()) then
			if (((316 + 4356) == (4893 - (55 + 166))) and v10.Cast(v84.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if ((v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v113() and v84.Crackshot:IsAvailable()) or ((711 + 2957) < (40 + 355))) then
			if (v10.Press(v84.BetweentheEyes) or ((15910 - 11744) == (752 - (36 + 261)))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch) and v113()) or ((7780 - 3331) == (4031 - (34 + 1334)))) then
			if (v10.Press(v84.Dispatch) or ((1645 + 2632) < (2323 + 666))) then
				return "Cast Dispatch";
			end
		end
		if ((v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1285 - (1035 + 248))) and (v16:BuffStack(v84.Opportunity) >= (27 - (20 + 1))) and ((v16:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v16:BuffUp(v84.GreenskinsWickersBuff))) or ((1189 - (134 + 185)) >= (5282 - (549 + 584)))) then
			if (((2897 - (314 + 371)) < (10926 - 7743)) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((5614 - (478 + 490)) > (1585 + 1407)) and v84.Ambush:IsCastable() and v17:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
			if (((2606 - (786 + 386)) < (10060 - 6954)) and v10.Press(v84.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		if (((2165 - (1055 + 324)) < (4363 - (1093 + 247))) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v16:BuffRemains(v84.BetweentheEyes) < (4 + 0)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v16:HasTier(4 + 26, 15 - 11)) and v16:BuffDown(v84.GreenskinsWickers)) then
			if (v10.Press(v84.BetweentheEyes) or ((8287 - 5845) < (210 - 136))) then
				return "Cast Between the Eyes";
			end
		end
		if (((11396 - 6861) == (1614 + 2921)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (173 - 128)) and (v84.ShadowDance:CooldownRemains() > (51 - 36))) then
			if (v10.Press(v84.BetweentheEyes) or ((2269 + 740) <= (5383 - 3278))) then
				return "Cast Between the Eyes";
			end
		end
		if (((2518 - (364 + 324)) < (10057 - 6388)) and v84.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v92, ">", v16:BuffRemains(v84.SliceandDice), true) or (v16:BuffRemains(v84.SliceandDice) == (0 - 0))) and (v16:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (4.8 - 3)))) then
			if (v10.Press(v84.SliceandDice) or ((2290 - 860) >= (10969 - 7357))) then
				return "Cast Slice and Dice";
			end
		end
		if (((3951 - (1249 + 19)) >= (2221 + 239)) and v84.KillingSpree:IsCastable() and v17:IsSpellInRange(v84.KillingSpree) and (v17:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
			if (v10.Cast(v84.KillingSpree) or ((7021 - 5217) >= (4361 - (686 + 400)))) then
				return "Cast Killing Spree";
			end
		end
		if ((v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch)) or ((1112 + 305) > (3858 - (73 + 156)))) then
			if (((23 + 4772) > (1213 - (721 + 90))) and v10.Cast(v84.ColdBlood, v55)) then
				return "Cast Cold Blood";
			end
		end
		if (((55 + 4758) > (11575 - 8010)) and v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch)) then
			if (((4382 - (224 + 246)) == (6337 - 2425)) and v10.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v124()
		if (((5193 - 2372) <= (876 + 3948)) and v29 and v84.EchoingReprimand:IsReady()) then
			if (((42 + 1696) <= (1613 + 582)) and v10.Cast(v84.EchoingReprimand, v76, nil, not v17:IsSpellInRange(v84.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((81 - 40) <= (10043 - 7025)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.AudacityBuff)) then
			if (((2658 - (203 + 310)) <= (6097 - (1238 + 755))) and v10.Press(v84.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((188 + 2501) < (6379 - (709 + 825))) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.Opportunity) and v16:BuffDown(v84.AudacityBuff)) then
			if (v10.Press(v84.PistolShot) or ((4278 - 1956) > (3818 - 1196))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v16:BuffUp(v84.GreenskinsWickersBuff) and ((not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity)) or (v16:BuffRemains(v84.GreenskinsWickersBuff) < (865.5 - (196 + 668))))) or ((17901 - 13367) == (4312 - 2230))) then
			if (v10.Press(v84.PistolShot) or ((2404 - (171 + 662)) > (1960 - (4 + 89)))) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v16:BuffStack(v84.Opportunity) >= (20 - 14)) or (v16:BuffRemains(v84.Opportunity) < (1 + 1)))) or ((11656 - 9002) >= (1175 + 1821))) then
			if (((5464 - (35 + 1451)) > (3557 - (28 + 1425))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if (((4988 - (941 + 1052)) > (1478 + 63)) and v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and (v98 > ((1515 - (822 + 692)) + (v22(v84.QuickDraw:IsAvailable()) * v84.FanTheHammer:TalentRank()))) and ((not v84.Vanish:IsReady() and not v84.ShadowDance:IsReady()) or v16:StealthUp(true, true) or not v84.Crackshot:IsAvailable() or (v84.FanTheHammer:TalentRank() <= (1 - 0)))) then
			if (((1531 + 1718) > (1250 - (45 + 252))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v102 > (1.5 + 0)) or (v98 <= (1 + 0 + v22(v16:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v16:BuffDown(v84.AudacityBuff)))) or ((7965 - 4692) > (5006 - (114 + 319)))) then
			if (v10.Press(v84.PistolShot) or ((4523 - 1372) < (1644 - 360))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.SinisterStrike:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) or ((1180 + 670) == (2277 - 748))) then
			if (((1720 - 899) < (4086 - (556 + 1407))) and v10.Press(v84.SinisterStrike)) then
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
		v103 = (v16:BuffUp(v84.AdrenalineRush, nil, true) and -(1256 - (741 + 465))) or (465 - (170 + 295));
		v99 = v108();
		v100 = v16:EnergyRegen();
		v102 = v107(v103);
		v101 = v16:EnergyDeficitPredicted(nil, v103);
		if (((476 + 426) < (2136 + 189)) and v28) then
			v91 = v16:GetEnemiesInRange(73 - 43);
			if (((712 + 146) <= (1900 + 1062)) and v84.AcrobaticStrikes:IsAvailable()) then
				v92 = v16:GetEnemiesInRange(6 + 3);
			end
			if (not v84.AcrobaticStrikes:IsAvailable() or ((5176 - (957 + 273)) < (345 + 943))) then
				v92 = v16:GetEnemiesInRange(3 + 3);
			end
			v93 = #v92;
		else
			v93 = 3 - 2;
		end
		v94 = v83.CrimsonVial();
		if (v94 or ((8543 - 5301) == (1731 - 1164))) then
			return v94;
		end
		v83.Poisons();
		if ((v32 and (v16:HealthPercentage() <= v34)) or ((4194 - 3347) >= (3043 - (389 + 1391)))) then
			local v151 = 0 + 0;
			while true do
				if ((v151 == (0 + 0)) or ((5129 - 2876) == (2802 - (783 + 168)))) then
					if ((v33 == "Refreshing Healing Potion") or ((7004 - 4917) > (2334 + 38))) then
						if (v85.RefreshingHealingPotion:IsReady() or ((4756 - (309 + 2)) < (12740 - 8591))) then
							if (v10.Press(v86.RefreshingHealingPotion) or ((3030 - (1090 + 122)) == (28 + 57))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2115 - 1485) < (1456 + 671)) and (v33 == "Dreamwalker's Healing Potion")) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((3056 - (628 + 490)) == (451 + 2063))) then
							if (((10535 - 6280) >= (251 - 196)) and v10.Press(v86.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		if (((3773 - (431 + 343)) > (2334 - 1178)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v16:HealthPercentage() <= v58)) then
			if (((6798 - 4448) > (913 + 242)) and v10.Cast(v84.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((516 + 3513) <= (6548 - (556 + 1139))) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v16:HealthPercentage() <= v80)) then
			if (v10.Cast(v84.Evasion) or ((531 - (6 + 9)) > (629 + 2805))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((2073 + 1973) >= (3202 - (28 + 141))) and not v16:IsCasting() and not v16:IsChanneling()) then
			local v152 = v82.Interrupt(v84.Kick, 4 + 4, true);
			if (v152 or ((3355 - 636) <= (1025 + 422))) then
				return v152;
			end
			v152 = v82.Interrupt(v84.Kick, 1325 - (486 + 831), true, v13, v86.KickMouseover);
			if (v152 or ((10757 - 6623) < (13821 - 9895))) then
				return v152;
			end
			v152 = v82.Interrupt(v84.Blind, 3 + 12, v79);
			if (v152 or ((518 - 354) >= (4048 - (668 + 595)))) then
				return v152;
			end
			v152 = v82.Interrupt(v84.Blind, 14 + 1, v79, v13, v86.BlindMouseover);
			if (v152 or ((106 + 419) == (5751 - 3642))) then
				return v152;
			end
			v152 = v82.InterruptWithStun(v84.CheapShot, 298 - (23 + 267), v16:StealthUp(false, false));
			if (((1977 - (1129 + 815)) == (420 - (371 + 16))) and v152) then
				return v152;
			end
			v152 = v82.InterruptWithStun(v84.KidneyShot, 1758 - (1326 + 424), v16:ComboPoints() > (0 - 0));
			if (((11160 - 8106) <= (4133 - (88 + 30))) and v152) then
				return v152;
			end
		end
		if (((2642 - (720 + 51)) < (7523 - 4141)) and not v16:AffectingCombat() and not v16:IsMounted() and v59) then
			v94 = v83.Stealth(v84.Stealth2, nil);
			if (((3069 - (421 + 1355)) <= (3573 - 1407)) and v94) then
				return "Stealth (OOC): " .. v94;
			end
		end
		if ((not v16:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v17:IsInRange(1091 - (286 + 797)) and v27) or ((9427 - 6848) < (202 - 79))) then
			if ((v82.TargetIsValid() and v17:IsInRange(449 - (397 + 42)) and not (v16:IsChanneling() or v16:IsCasting())) or ((265 + 581) >= (3168 - (24 + 776)))) then
				if ((v84.BladeFlurry:IsReady() and v16:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v16:BuffUp(v84.AdrenalineRush))) or ((6180 - 2168) <= (4143 - (222 + 563)))) then
					if (((3291 - 1797) <= (2164 + 841)) and v12(v84.BladeFlurry)) then
						return "Blade Flurry (Opener)";
					end
				end
				if (not v16:StealthUp(true, false) or ((3301 - (23 + 167)) == (3932 - (690 + 1108)))) then
					v94 = v83.Stealth(v83.StealthSpell());
					if (((850 + 1505) == (1943 + 412)) and v94) then
						return v94;
					end
				end
				if (v82.TargetIsValid() or ((1436 - (40 + 808)) <= (72 + 360))) then
					local v182 = 0 - 0;
					while true do
						if (((4585 + 212) >= (2061 + 1834)) and (v182 == (1 + 0))) then
							if (((4148 - (47 + 524)) == (2322 + 1255)) and v84.SliceandDice:IsReady() and (v16:BuffRemains(v84.SliceandDice) < (((2 - 1) + v97) * (1.8 - 0)))) then
								if (((8652 - 4858) > (5419 - (1165 + 561))) and v10.Press(v84.SliceandDice)) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (v16:StealthUp(true, false) or ((38 + 1237) == (12698 - 8598))) then
								local v190 = 0 + 0;
								while true do
									if ((v190 == (479 - (341 + 138))) or ((430 + 1161) >= (7388 - 3808))) then
										v94 = v122();
										if (((1309 - (89 + 237)) <= (5816 - 4008)) and v94) then
											return "Stealth (Opener): " .. v94;
										end
										v190 = 1 - 0;
									end
									if ((v190 == (882 - (581 + 300))) or ((3370 - (855 + 365)) <= (2843 - 1646))) then
										if (((1231 + 2538) >= (2408 - (1030 + 205))) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
											if (((1395 + 90) == (1382 + 103)) and v10.Press(v84.GhostlyStrike)) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (v84.Ambush:IsCastable() or ((3601 - (156 + 130)) <= (6321 - 3539))) then
											if (v10.Cast(v84.Ambush) or ((1476 - 600) >= (6070 - 3106))) then
												return "Cast Ambush (Opener)";
											end
										end
										break;
									end
								end
							elseif (v113() or ((589 + 1643) > (1457 + 1040))) then
								v94 = v123();
								if (v94 or ((2179 - (10 + 59)) <= (94 + 238))) then
									return "Finish (Opener): " .. v94;
								end
							end
							v182 = 9 - 7;
						end
						if (((4849 - (671 + 492)) > (2526 + 646)) and (v182 == (1217 - (369 + 846)))) then
							if (v84.SinisterStrike:IsCastable() or ((1185 + 3289) < (700 + 120))) then
								if (((6224 - (1036 + 909)) >= (2292 + 590)) and v10.Cast(v84.SinisterStrike)) then
									return "Cast Sinister Strike (Opener)";
								end
							end
							break;
						end
						if ((v182 == (0 - 0)) or ((2232 - (11 + 192)) >= (1780 + 1741))) then
							if ((v84.RolltheBones:IsReady() and not v16:DebuffUp(v84.Dreadblades) and ((v111() == (175 - (135 + 40))) or v112())) or ((4935 - 2898) >= (2799 + 1843))) then
								if (((3789 - 2069) < (6682 - 2224)) and v10.Cast(v84.RolltheBones)) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (178 - (50 + 126)))) or ((1213 - 777) > (669 + 2352))) then
								if (((2126 - (1233 + 180)) <= (1816 - (522 + 447))) and v10.Cast(v84.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							v182 = 1422 - (107 + 1314);
						end
					end
				end
				return;
			end
		end
		if (((1000 + 1154) <= (12282 - 8251)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
			v97 = v26(v97, v83.FanTheHammerCP());
		end
		if (((1961 + 2654) == (9164 - 4549)) and v82.TargetIsValid()) then
			local v153 = 0 - 0;
			while true do
				if ((v153 == (1912 - (716 + 1194))) or ((65 + 3725) == (54 + 446))) then
					if (((592 - (74 + 429)) < (426 - 205)) and v84.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike) and (v101 > (8 + 7 + v100))) then
						if (((4701 - 2647) >= (1006 + 415)) and v10.Cast(v84.ArcaneTorrent, v30)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((2133 - 1441) < (7561 - 4503)) and v84.ArcanePulse:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) then
						if (v10.Cast(v84.ArcanePulse) or ((3687 - (279 + 154)) == (2433 - (454 + 324)))) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v84.LightsJudgment:IsCastable() and v17:IsInMeleeRange(4 + 1)) or ((1313 - (12 + 5)) == (2648 + 2262))) then
						if (((8581 - 5213) == (1245 + 2123)) and v10.Cast(v84.LightsJudgment, v30)) then
							return "Cast Lights Judgment";
						end
					end
					v153 = 1096 - (277 + 816);
				end
				if (((11293 - 8650) < (4998 - (1058 + 125))) and (v153 == (1 + 2))) then
					if (((2888 - (815 + 160)) > (2115 - 1622)) and v84.BagofTricks:IsCastable() and v17:IsInMeleeRange(11 - 6)) then
						if (((1135 + 3620) > (10020 - 6592)) and v10.Cast(v84.BagofTricks, v30)) then
							return "Cast Bag of Tricks";
						end
					end
					if (((3279 - (41 + 1857)) <= (4262 - (1222 + 671))) and v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and not v17:IsInRange(15 - 9) and not v16:StealthUp(true, true) and (v101 < (35 - 10)) and ((v98 >= (1183 - (229 + 953))) or (v102 <= (1775.2 - (1111 + 663))))) then
						if (v10.Cast(v84.PistolShot) or ((6422 - (874 + 705)) == (572 + 3512))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((3186 + 1483) > (754 - 391)) and v84.SinisterStrike:IsCastable()) then
						if (v10.Cast(v84.SinisterStrike) or ((53 + 1824) >= (3817 - (642 + 37)))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((1082 + 3660) >= (581 + 3045)) and (v153 == (0 - 0))) then
					v94 = v121();
					if (v94 or ((4994 - (233 + 221)) == (2117 - 1201))) then
						return "CDs: " .. v94;
					end
					if (v16:StealthUp(true, true) or v16:BuffUp(v84.Shadowmeld) or ((1018 + 138) > (5886 - (718 + 823)))) then
						v94 = v122();
						if (((1408 + 829) < (5054 - (266 + 539))) and v94) then
							return "Stealth: " .. v94;
						end
					end
					v153 = 2 - 1;
				end
				if ((v153 == (1226 - (636 + 589))) or ((6368 - 3685) < (46 - 23))) then
					if (((553 + 144) <= (301 + 525)) and v113()) then
						local v185 = 1015 - (657 + 358);
						while true do
							if (((2925 - 1820) <= (2679 - 1503)) and (v185 == (1187 - (1151 + 36)))) then
								v94 = v123();
								if (((3264 + 115) <= (1003 + 2809)) and v94) then
									return "Finish: " .. v94;
								end
								break;
							end
						end
					end
					v94 = v124();
					if (v94 or ((2353 - 1565) >= (3448 - (1552 + 280)))) then
						return "Build: " .. v94;
					end
					v153 = 836 - (64 + 770);
				end
			end
		end
	end
	local function v126()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(177 + 83, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

