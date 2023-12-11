local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2654 + 1170) > (126 + 283)) and not v5) then
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
			if (((2620 - (43 + 490)) == (2820 - (711 + 22))) and (v123 == (0 - 0))) then
				v27 = EpicSettings.Settings['UseRacials'];
				v29 = EpicSettings.Settings['UseHealingPotion'];
				v30 = EpicSettings.Settings['HealingPotionName'] or (859 - (240 + 619));
				v123 = 1 + 0;
			end
			if ((v123 == (9 - 3)) or ((226 + 3178) > (6247 - (1344 + 400)))) then
				v65 = EpicSettings.Settings['UseDPSVanish'];
				v68 = EpicSettings.Settings['BladeFlurryGCD'] or (405 - (255 + 150));
				v69 = EpicSettings.Settings['BladeRushGCD'];
				v123 = 6 + 1;
			end
			if ((v123 == (5 + 3)) or ((14979 - 11473) <= (4227 - 2918))) then
				v74 = EpicSettings.Settings['EchoingReprimand'];
				v75 = EpicSettings.Settings['UseSoloVanish'];
				v76 = EpicSettings.Settings['sepsis'];
				break;
			end
			if (((4694 - (404 + 1335)) == (3361 - (183 + 223))) and (v123 == (4 - 0))) then
				v53 = EpicSettings.Settings['ColdBloodOffGCD'];
				v54 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v55 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v123 = 2 + 3;
			end
			if ((v123 == (339 - (10 + 327))) or ((2022 + 881) == (1833 - (118 + 220)))) then
				v34 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v35 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (449 - (108 + 341));
				v36 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v123 = 12 - 9;
			end
			if (((6039 - (711 + 782)) >= (4361 - 2086)) and (v123 == (476 - (270 + 199)))) then
				v70 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v72 = EpicSettings.Settings['KeepItRollingGCD'];
				v73 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v123 = 3 + 5;
			end
			if (((2638 - (580 + 1239)) >= (65 - 43)) and (v123 == (3 + 0))) then
				v50 = EpicSettings.Settings['VanishOffGCD'];
				v51 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v52 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v123 = 1 + 3;
			end
			if (((1378 + 1784) == (8255 - 5093)) and (v123 == (1 + 0))) then
				v31 = EpicSettings.Settings['HealingPotionHP'] or (1167 - (645 + 522));
				v32 = EpicSettings.Settings['UseHealthstone'];
				v33 = EpicSettings.Settings['HealthstoneHP'] or (1790 - (1010 + 780));
				v123 = 2 + 0;
			end
			if ((v123 == (23 - 18)) or ((6942 - 4573) > (6265 - (1045 + 791)))) then
				v56 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v57 = EpicSettings.Settings['StealthOOC'];
				v62 = EpicSettings.Settings['RolltheBonesLogic'];
				v123 = 8 - 2;
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
	local v85 = (v84[28 - 15] and v17(v84[1572 - (1381 + 178)])) or v17(0 + 0);
	local v86 = (v84[12 + 2] and v17(v84[6 + 8])) or v17(0 - 0);
	v9:RegisterForEvent(function()
		v84 = v13:GetEquipment();
		v85 = (v84[7 + 6] and v17(v84[483 - (381 + 89)])) or v17(0 + 0);
		v86 = (v84[10 + 4] and v17(v84[23 - 9])) or v17(1156 - (1074 + 82));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v80.Dispatch:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v79.CPSpend() * (0.3 - 0) * (1785 - (214 + 1570)) * ((1456 - (990 + 465)) + (v13:VersatilityDmgPct() / (42 + 58))) * ((v14:DebuffUp(v80.GhostlyStrike) and (1.1 + 0)) or (1 + 0));
	end);
	local v87, v88, v89;
	local v90;
	local v91;
	local v92, v93, v94;
	local v95, v96, v97, v98, v99;
	local v100 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v101, v102 = 0 - 0, 0 - 0;
	local function v103(v124)
		local v125 = 0 + 0;
		local v126;
		while true do
			if (((767 + 3328) >= (2768 + 415)) and ((0 - 0) == v125)) then
				v126 = v13:EnergyTimeToMaxPredicted(nil, v124);
				if ((v126 < v101) or ((v126 - v101) > (1994.5 - (109 + 1885))) or ((5180 - (1269 + 200)) < (1931 - 923))) then
					v101 = v126;
				end
				v125 = 816 - (98 + 717);
			end
			if ((v125 == (827 - (802 + 24))) or ((1808 - 759) <= (1144 - 238))) then
				return v101;
			end
		end
	end
	local function v104()
		local v127 = v13:EnergyPredicted();
		if (((667 + 3846) > (2095 + 631)) and ((v127 > v102) or ((v127 - v102) > (2 + 7)))) then
			v102 = v127;
		end
		return v102;
	end
	local v105 = {v80.Broadside,v80.BuriedTreasure,v80.GrandMelee,v80.RuthlessPrecision,v80.SkullandCrossbones,v80.TrueBearing};
	local function v106(v128, v129)
		if (not v10.APLVar.RtB_List or ((1077 + 404) >= (1241 + 1417))) then
			v10.APLVar.RtB_List = {};
		end
		if (not v10.APLVar.RtB_List[v128] or ((4653 - (797 + 636)) == (6622 - 5258))) then
			v10.APLVar.RtB_List[v128] = {};
		end
		local v130 = table.concat(v129);
		if ((v128 == "All") or ((2673 - (1427 + 192)) > (1176 + 2216))) then
			if (not v10.APLVar.RtB_List[v128][v130] or ((1569 - 893) >= (1476 + 166))) then
				local v159 = 0 + 0;
				local v160;
				while true do
					if (((4462 - (192 + 134)) > (3673 - (316 + 960))) and (v159 == (0 + 0))) then
						v160 = 0 + 0;
						for v175 = 1 + 0, #v129 do
							if (v13:BuffUp(v105[v129[v175]]) or ((16568 - 12234) == (4796 - (83 + 468)))) then
								v160 = v160 + (1807 - (1202 + 604));
							end
						end
						v159 = 4 - 3;
					end
					if (((1 - 0) == v159) or ((11839 - 7563) <= (3356 - (45 + 280)))) then
						v10.APLVar.RtB_List[v128][v130] = ((v160 == #v129) and true) or false;
						break;
					end
				end
			end
		elseif (not v10.APLVar.RtB_List[v128][v130] or ((4616 + 166) <= (1048 + 151))) then
			local v161 = 0 + 0;
			while true do
				if ((v161 == (0 + 0)) or ((856 + 4008) < (3521 - 1619))) then
					v10.APLVar.RtB_List[v128][v130] = false;
					for v176 = 1912 - (340 + 1571), #v129 do
						if (((1909 + 2930) >= (5472 - (1733 + 39))) and v13:BuffUp(v105[v129[v176]])) then
							v10.APLVar.RtB_List[v128][v130] = true;
							break;
						end
					end
					break;
				end
			end
		end
		return v10.APLVar.RtB_List[v128][v130];
	end
	local function v107()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (1034 - (125 + 909))) or ((3023 - (1096 + 852)) > (861 + 1057))) then
				if (((564 - 168) <= (3690 + 114)) and not v10.APLVar.RtB_Buffs) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Total = 512 - (409 + 103);
					v10.APLVar.RtB_Buffs.Normal = 236 - (46 + 190);
					v10.APLVar.RtB_Buffs.Shorter = 95 - (51 + 44);
					v10.APLVar.RtB_Buffs.Longer = 0 + 0;
					local v168 = v79.RtBRemains();
					for v169 = 1318 - (1114 + 203), #v105 do
						local v170 = v13:BuffRemains(v105[v169]);
						if ((v170 > (726 - (228 + 498))) or ((904 + 3265) == (1209 + 978))) then
							local v177 = 663 - (174 + 489);
							while true do
								if (((3662 - 2256) == (3311 - (830 + 1075))) and (v177 == (524 - (303 + 221)))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1270 - (231 + 1038));
									if (((1276 + 255) < (5433 - (171 + 991))) and (v170 == v168)) then
										v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (4 - 3);
									elseif (((1705 - 1070) == (1584 - 949)) and (v170 > v168)) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
									else
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (3 - 2);
									end
									break;
								end
							end
						end
					end
				end
				return v10.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v108()
		if (((9730 - 6357) <= (5731 - 2175)) and not v10.APLVar.RtB_Reroll) then
			if ((v62 == "1+ Buff") or ((10173 - 6882) < (4528 - (111 + 1137)))) then
				v10.APLVar.RtB_Reroll = ((v107() <= (158 - (91 + 67))) and true) or false;
			elseif (((13053 - 8667) >= (218 + 655)) and (v62 == "Broadside")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.Broadside) and true) or false;
			elseif (((1444 - (423 + 100)) <= (8 + 1094)) and (v62 == "Buried Treasure")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.BuriedTreasure) and true) or false;
			elseif (((13029 - 8323) >= (502 + 461)) and (v62 == "Grand Melee")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.GrandMelee) and true) or false;
			elseif ((v62 == "Skull and Crossbones") or ((1731 - (326 + 445)) <= (3822 - 2946))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.SkullandCrossbones) and true) or false;
			elseif ((v62 == "Ruthless Precision") or ((4602 - 2536) == (2175 - 1243))) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.RuthlessPrecision) and true) or false;
			elseif (((5536 - (530 + 181)) < (5724 - (614 + 267))) and (v62 == "True Bearing")) then
				v10.APLVar.RtB_Reroll = (not v13:BuffUp(v80.TrueBearing) and true) or false;
			else
				v10.APLVar.RtB_Reroll = false;
				v107();
				if (((v107() <= (34 - (19 + 13))) and v13:BuffUp(v80.BuriedTreasure) and v13:BuffDown(v80.GrandMelee) and (v89 < (2 - 0))) or ((9034 - 5157) >= (12960 - 8423))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:HasTier(9 + 22, 6 - 2) and ((not v13:BuffUp(v80.TrueBearing) and v80.HiddenOpportunity:IsAvailable()) or (not v13:BuffUp(v80.Broadside) and not v80.HiddenOpportunity:IsAvailable())) and (v107() <= (1 - 0))) or ((6127 - (1293 + 519)) < (3521 - 1795))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v80.Crackshot:IsAvailable() and v13:HasTier(80 - 49, 7 - 3) and (v107() <= ((4 - 3) + v19(v13:BuffUp(v80.LoadedDiceBuff)))) and (v80.HiddenOpportunity:IsAvailable() or v13:BuffDown(v80.Broadside))) or ((8666 - 4987) < (332 + 293))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((not v80.Crackshot:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and not v13:BuffUp(v80.SkullandCrossbones) and (v107() < (1 + 1 + v19(v13:BuffUp(v80.GrandMelee)))) and (v89 < (4 - 2))) or ((1069 + 3556) < (210 + 422))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (v10.APLVar.RtB_Reroll or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1097 - (709 + 387))) and (v107() < (1863 - (673 + 1185))) and (v79.RtBRemains() <= (112 - 73))) or ((266 - 183) > (2928 - 1148))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((391 + 155) <= (805 + 272)) and (v14:FilteredTimeToDie("<", 15 - 3) or v9.BossFilteredFightRemains("<", 3 + 9))) then
					v10.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v109()
		return v92 >= ((v79.CPMaxSpend() - (1 - 0)) - v19((v13:StealthUp(true, true)) and v80.Crackshot:IsAvailable()));
	end
	local function v110()
		return (v80.HiddenOpportunity:IsAvailable() or (v94 >= ((3 - 1) + v19(v80.ImprovedAmbush:IsAvailable()) + v19(v13:BuffUp(v80.Broadside))))) and (v95 >= (1930 - (446 + 1434)));
	end
	local function v111()
		return not v25 or (v89 < (1285 - (1040 + 243))) or (v13:BuffRemains(v80.BladeFlurry) > ((2 - 1) + v19(v80.KillingSpree:IsAvailable())));
	end
	local function v112()
		return v65 and (not v13:IsTanking(v14) or v75);
	end
	local function v113()
		return not v80.ShadowDanceTalent:IsAvailable() and ((v80.FanTheHammer:TalentRank() + v19(v80.QuickDraw:IsAvailable()) + v19(v80.Audacity:IsAvailable())) < (v19(v80.CountTheOdds:IsAvailable()) + v19(v80.KeepItRolling:IsAvailable())));
	end
	local function v114()
		return v13:BuffUp(v80.BetweentheEyes) and (not v80.HiddenOpportunity:IsAvailable() or (v13:BuffDown(v80.AudacityBuff) and ((v80.FanTheHammer:TalentRank() < (1849 - (559 + 1288))) or v13:BuffDown(v80.Opportunity)))) and not v80.Crackshot:IsAvailable();
	end
	local function v115()
		if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v112() and v80.HiddenOpportunity:IsAvailable() and not v80.Crackshot:IsAvailable() and not v13:BuffUp(v80.Audacity) and (v113() or (v13:BuffStack(v80.Opportunity) < (1937 - (609 + 1322)))) and v110()) or ((1450 - (13 + 441)) > (16072 - 11771))) then
			if (((10660 - 6590) > (3421 - 2734)) and v9.Cast(v80.Vanish, v65)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v80.Vanish:IsCastable() and v80.Vanish:IsReady() and v112() and (not v80.HiddenOpportunity:IsAvailable() or v80.Crackshot:IsAvailable()) and v109()) or ((25 + 631) >= (12093 - 8763))) then
			if (v9.Cast(v80.Vanish, v65) or ((886 + 1606) <= (147 + 188))) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((12825 - 8503) >= (1402 + 1160)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.Crackshot:IsAvailable() and v109()) then
			if (v9.Cast(v80.ShadowDance) or ((6689 - 3052) >= (2493 + 1277))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and not v80.KeepItRolling:IsAvailable() and v114() and v13:BuffUp(v80.SliceandDice) and (v109() or v80.HiddenOpportunity:IsAvailable()) and (not v80.HiddenOpportunity:IsAvailable() or not v80.Vanish:IsReady())) or ((1324 + 1055) > (3290 + 1288))) then
			if (v9.Cast(v80.ShadowDance) or ((406 + 77) > (727 + 16))) then
				return "Cast Shadow Dance";
			end
		end
		if (((2887 - (153 + 280)) > (1668 - 1090)) and v80.ShadowDance:IsAvailable() and v80.ShadowDance:IsCastable() and v80.KeepItRolling:IsAvailable() and v114() and ((v80.KeepItRolling:CooldownRemains() <= (27 + 3)) or ((v80.KeepItRolling:CooldownRemains() >= (48 + 72)) and (v109() or v80.HiddenOpportunity:IsAvailable())))) then
			if (((487 + 443) < (4046 + 412)) and v9.Cast(v80.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if (((480 + 182) <= (1479 - 507)) and v80.Shadowmeld:IsAvailable() and v80.Shadowmeld:IsReady()) then
			if (((2701 + 1669) == (5037 - (89 + 578))) and ((v80.Crackshot:IsAvailable() and v109()) or (not v80.Crackshot:IsAvailable() and ((v80.CountTheOdds:IsAvailable() and v109()) or v80.HiddenOpportunity:IsAvailable())))) then
				if (v9.Cast(v80.Shadowmeld, v27) or ((3402 + 1360) <= (1789 - 928))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v116()
		local v132 = 1049 - (572 + 477);
		while true do
			if ((v132 == (0 + 0)) or ((848 + 564) == (509 + 3755))) then
				v90 = v78.HandleTopTrinket(v83, v26, 126 - (84 + 2), nil);
				if (v90 or ((5220 - 2052) < (1552 + 601))) then
					return v90;
				end
				v132 = 843 - (497 + 345);
			end
			if ((v132 == (1 + 0)) or ((842 + 4134) < (2665 - (605 + 728)))) then
				v90 = v78.HandleBottomTrinket(v83, v26, 29 + 11, nil);
				if (((10289 - 5661) == (213 + 4415)) and v90) then
					return v90;
				end
				break;
			end
		end
	end
	local function v117()
		if ((v26 and v80.AdrenalineRush:IsCastable() and (not v13:BuffUp(v80.AdrenalineRush) or (v13:StealthUp(true, true) and v80.Crackshot:IsAvailable() and v80.ImprovedAdrenalineRush:IsAvailable())) and ((v93 <= (7 - 5)) or not v80.ImprovedAdrenalineRush:IsAvailable())) or ((49 + 5) == (1094 - 699))) then
			if (((62 + 20) == (571 - (457 + 32))) and v9.Cast(v80.AdrenalineRush)) then
				return "Cast Adrenaline Rush";
			end
		end
		if ((v80.BladeFlurry:IsReady() and (v13:BuffRemains(v80.BladeFlurry) < v13:GCDRemains()) and ((v89 >= ((1 + 1) - v19(v80.UnderhandedUpperhand:IsAvailable()))) or (v80.DeftManeuvers:IsAvailable() and (v89 >= (1407 - (832 + 570))) and not v109()))) or ((548 + 33) < (74 + 208))) then
			if (v68 or ((16310 - 11701) < (1202 + 1293))) then
				if (((1948 - (588 + 208)) == (3104 - 1952)) and v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(1810 - (884 + 916)))) then
					return "Cast Blade Flurry";
				end
			elseif (((3969 - 2073) <= (1985 + 1437)) and v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(663 - (232 + 421)))) then
				return "Cast Blade Flurry";
			end
		end
		if (v80.RolltheBones:IsReady() or ((2879 - (1569 + 320)) > (398 + 1222))) then
			if (v108() or (v79.RtBRemains() <= (v19(v13:HasTier(6 + 25, 13 - 9)) + (v19((v80.ShadowDance:CooldownRemains() <= (606 - (316 + 289))) or (v80.Vanish:CooldownRemains() <= (2 - 1))) * (1 + 5)))) or ((2330 - (666 + 787)) > (5120 - (360 + 65)))) then
				if (((2515 + 176) >= (2105 - (79 + 175))) and v9.Cast(v80.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		if ((v80.KeepItRolling:IsReady() and not v108() and (v107() >= ((4 - 1) + v19(v13:HasTier(25 + 6, 12 - 8)))) and (v13:BuffDown(v80.ShadowDance) or (v107() >= (11 - 5)))) or ((3884 - (503 + 396)) >= (5037 - (92 + 89)))) then
			if (((8294 - 4018) >= (613 + 582)) and v9.Cast(v80.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if (((1913 + 1319) <= (18366 - 13676)) and v80.GhostlyStrike:IsAvailable() and v80.GhostlyStrike:IsReady()) then
			if (v9.Cast(v80.GhostlyStrike) or ((123 + 773) >= (7173 - 4027))) then
				return "Cast Ghostly Strike";
			end
		end
		if (((2671 + 390) >= (1413 + 1545)) and v26 and v80.Sepsis:IsAvailable() and v80.Sepsis:IsReady()) then
			if (((9706 - 6519) >= (81 + 563)) and ((v80.Crackshot:IsAvailable() and v80.BetweentheEyes:IsReady() and v109() and not v13:StealthUp(true, true)) or (not v80.Crackshot:IsAvailable() and v14:FilteredTimeToDie(">", 16 - 5) and v13:BuffUp(v80.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1255 - (485 + 759)))) then
				if (((1489 - 845) <= (1893 - (442 + 747))) and v9.Cast(v80.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((2093 - (832 + 303)) > (1893 - (88 + 858))) and v80.BladeRush:IsReady() and (v98 > (2 + 2)) and not v13:StealthUp(true, true)) then
			if (((3718 + 774) >= (110 + 2544)) and v9.Cast(v80.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((4231 - (766 + 23)) >= (7419 - 5916)) and not v13:StealthUp(true, true, true)) then
			local v138 = 0 - 0;
			while true do
				if ((v138 == (0 - 0)) or ((10759 - 7589) <= (2537 - (1036 + 37)))) then
					v90 = v115();
					if (v90 or ((3401 + 1396) == (8544 - 4156))) then
						return v90;
					end
					break;
				end
			end
		end
		if (((434 + 117) <= (2161 - (641 + 839))) and v26 and v80.ThistleTea:IsAvailable() and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and ((v97 >= (1013 - (910 + 3))) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (15 - 9)))) then
			if (((4961 - (1466 + 218)) > (188 + 219)) and v9.Cast(v80.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((5843 - (556 + 592)) >= (504 + 911)) and v80.BloodFury:IsCastable()) then
			if (v9.Cast(v80.BloodFury, v27) or ((4020 - (329 + 479)) <= (1798 - (174 + 680)))) then
				return "Cast Blood Fury";
			end
		end
		if (v80.Berserking:IsCastable() or ((10638 - 7542) <= (3726 - 1928))) then
			if (((2526 + 1011) == (4276 - (396 + 343))) and v9.Cast(v80.Berserking, v27)) then
				return "Cast Berserking";
			end
		end
		if (((340 + 3497) >= (3047 - (29 + 1448))) and v80.Fireblood:IsCastable()) then
			if (v9.Cast(v80.Fireblood, v27) or ((4339 - (135 + 1254)) == (14360 - 10548))) then
				return "Cast Fireblood";
			end
		end
		if (((22052 - 17329) >= (1545 + 773)) and v80.AncestralCall:IsCastable()) then
			if (v9.Cast(v80.AncestralCall, v27) or ((3554 - (389 + 1138)) > (3426 - (102 + 472)))) then
				return "Cast Ancestral Call";
			end
		end
		v90 = v116();
		if (v90 or ((1073 + 63) > (2394 + 1923))) then
			return v90;
		end
	end
	local function v118()
		if (((4428 + 320) == (6293 - (320 + 1225))) and v80.BladeFlurry:IsReady() and v80.BladeFlurry:IsCastable() and v25 and v80.Subterfuge:IsAvailable() and (v89 >= (2 - 0)) and (v13:BuffRemains(v80.BladeFlurry) <= v13:GCDRemains())) then
			if (((2286 + 1450) <= (6204 - (157 + 1307))) and v68) then
				if (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(1869 - (821 + 1038))) or ((8458 - 5068) <= (335 + 2725))) then
					return "Cast Blade Flurry";
				end
			elseif (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(17 - 7)) or ((372 + 627) > (6674 - 3981))) then
				return "Cast Blade Flurry";
			end
		end
		if (((1489 - (834 + 192)) < (39 + 562)) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch) and v109()) then
			if (v9.Cast(v80.ColdBlood) or ((561 + 1622) < (15 + 672))) then
				return "Cast Cold Blood";
			end
		end
		if (((7046 - 2497) == (4853 - (300 + 4))) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v109() and v80.Crackshot:IsAvailable()) then
			if (((1248 + 3424) == (12229 - 7557)) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch) and v109()) or ((4030 - (112 + 250)) < (158 + 237))) then
			if (v9.Press(v80.Dispatch) or ((10436 - 6270) == (261 + 194))) then
				return "Cast Dispatch";
			end
		end
		if ((v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and v80.Crackshot:IsAvailable() and (v80.FanTheHammer:TalentRank() >= (2 + 0)) and (v13:BuffStack(v80.Opportunity) >= (5 + 1)) and ((v13:BuffUp(v80.Broadside) and (v93 <= (1 + 0))) or v13:BuffUp(v80.GreenskinsWickersBuff))) or ((3306 + 1143) == (4077 - (1001 + 413)))) then
			if (v9.Press(v80.PistolShot) or ((9537 - 5260) < (3871 - (244 + 638)))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v80.Ambush:IsCastable() and v14:IsSpellInRange(v80.Ambush) and v80.HiddenOpportunity:IsAvailable()) or ((1563 - (627 + 66)) >= (12362 - 8213))) then
			if (((2814 - (512 + 90)) < (5089 - (1665 + 241))) and v9.Press(v80.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v119()
		if (((5363 - (373 + 344)) > (1350 + 1642)) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and not v80.Crackshot:IsAvailable() and ((v13:BuffRemains(v80.BetweentheEyes) < (2 + 2)) or v80.ImprovedBetweenTheEyes:IsAvailable() or v80.GreenskinsWickers:IsAvailable() or v13:HasTier(79 - 49, 6 - 2)) and v13:BuffDown(v80.GreenskinsWickers)) then
			if (((2533 - (35 + 1064)) < (2260 + 846)) and v9.Press(v80.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((1681 - 895) < (13 + 3010)) and v80.BetweentheEyes:IsCastable() and v14:IsSpellInRange(v80.BetweentheEyes) and v80.Crackshot:IsAvailable() and (v80.Vanish:CooldownRemains() > (1281 - (298 + 938))) and (v80.ShadowDance:CooldownRemains() > (1271 - (233 + 1026)))) then
			if (v9.Press(v80.BetweentheEyes) or ((4108 - (636 + 1030)) < (38 + 36))) then
				return "Cast Between the Eyes";
			end
		end
		if (((4430 + 105) == (1348 + 3187)) and v80.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v88, ">", v13:BuffRemains(v80.SliceandDice), true) or (v13:BuffRemains(v80.SliceandDice) == (0 + 0))) and (v13:BuffRemains(v80.SliceandDice) < (((222 - (55 + 166)) + v93) * (1.8 + 0)))) then
			if (v9.Press(v80.SliceandDice) or ((303 + 2706) <= (8038 - 5933))) then
				return "Cast Slice and Dice";
			end
		end
		if (((2127 - (36 + 261)) < (6416 - 2747)) and v80.KillingSpree:IsCastable() and v14:IsSpellInRange(v80.KillingSpree) and (v14:DebuffUp(v80.GhostlyStrike) or not v80.GhostlyStrike:IsAvailable())) then
			if (v9.Cast(v80.KillingSpree) or ((2798 - (34 + 1334)) >= (1389 + 2223))) then
				return "Cast Killing Spree";
			end
		end
		if (((2085 + 598) >= (3743 - (1035 + 248))) and v80.ColdBlood:IsCastable() and v13:BuffDown(v80.ColdBlood) and v14:IsSpellInRange(v80.Dispatch)) then
			if (v9.Cast(v80.ColdBlood, v53) or ((1825 - (20 + 1)) >= (1707 + 1568))) then
				return "Cast Cold Blood";
			end
		end
		if ((v80.Dispatch:IsCastable() and v14:IsSpellInRange(v80.Dispatch)) or ((1736 - (134 + 185)) > (4762 - (549 + 584)))) then
			if (((5480 - (314 + 371)) > (1379 - 977)) and v9.Press(v80.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v120()
		if (((5781 - (478 + 490)) > (1889 + 1676)) and v26 and v80.EchoingReprimand:IsReady()) then
			if (((5084 - (786 + 386)) == (12670 - 8758)) and v9.Cast(v80.EchoingReprimand, nil, v74)) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((4200 - (1055 + 324)) <= (6164 - (1093 + 247))) and v80.Ambush:IsCastable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.AudacityBuff)) then
			if (((1545 + 193) <= (231 + 1964)) and v9.Press(v80.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((162 - 121) <= (10242 - 7224)) and v80.FanTheHammer:IsAvailable() and v80.Audacity:IsAvailable() and v80.HiddenOpportunity:IsAvailable() and v13:BuffUp(v80.Opportunity) and v13:BuffDown(v80.AudacityBuff)) then
			if (((6103 - 3958) <= (10312 - 6208)) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if (((957 + 1732) < (18664 - 13819)) and v13:BuffUp(v80.GreenskinsWickersBuff) and ((not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity)) or (v13:BuffRemains(v80.GreenskinsWickersBuff) < (3.5 - 2)))) then
			if (v9.Press(v80.PistolShot) or ((1751 + 571) > (6705 - 4083))) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v13:BuffStack(v80.Opportunity) >= (694 - (364 + 324))) or (v13:BuffRemains(v80.Opportunity) < (5 - 3)))) or ((10879 - 6345) == (691 + 1391))) then
			if (v9.Press(v80.PistolShot) or ((6573 - 5002) > (2989 - 1122))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and (v94 > ((2 - 1) + (v19(v80.QuickDraw:IsAvailable()) * v80.FanTheHammer:TalentRank()))) and ((not v80.Vanish:IsReady() and not v80.ShadowDance:IsReady()) or v13:StealthUp(true, true) or not v80.Crackshot:IsAvailable() or (v80.FanTheHammer:TalentRank() <= (1269 - (1249 + 19))))) or ((2396 + 258) >= (11661 - 8665))) then
			if (((5064 - (686 + 400)) > (1651 + 453)) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((3224 - (73 + 156)) > (8 + 1533)) and not v80.FanTheHammer:IsAvailable() and v13:BuffUp(v80.Opportunity) and ((v98 > (812.5 - (721 + 90))) or (v94 <= (1 + 0 + v19(v13:BuffUp(v80.Broadside)))) or v80.QuickDraw:IsAvailable() or (v80.Audacity:IsAvailable() and v13:BuffDown(v80.AudacityBuff)))) then
			if (((10548 - 7299) > (1423 - (224 + 246))) and v9.Press(v80.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if ((v80.SinisterStrike:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) or ((5301 - 2028) > (8419 - 3846))) then
			if (v9.Press(v80.SinisterStrike) or ((572 + 2579) < (31 + 1253))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v121()
		v77();
		v24 = EpicSettings.Toggles['ooc'];
		v25 = EpicSettings.Toggles['aoe'];
		v26 = EpicSettings.Toggles['cds'];
		v93 = v13:ComboPoints();
		v92 = v79.EffectiveComboPoints(v93);
		v94 = v13:ComboPointsDeficit();
		v99 = (v13:BuffUp(v80.AdrenalineRush, nil, true) and -(37 + 13)) or (0 - 0);
		v95 = v104();
		v96 = v13:EnergyRegen();
		v98 = v103(v99);
		v97 = v13:EnergyDeficitPredicted(nil, v99);
		if (v25 or ((6156 - 4306) == (2042 - (203 + 310)))) then
			local v139 = 1993 - (1238 + 755);
			while true do
				if (((58 + 763) < (3657 - (709 + 825))) and (v139 == (1 - 0))) then
					if (((1313 - 411) < (3189 - (196 + 668))) and not v80.AcrobaticStrikes:IsAvailable()) then
						v88 = v13:GetEnemiesInRange(23 - 17);
					end
					v89 = #v88;
					break;
				end
				if (((1776 - 918) <= (3795 - (171 + 662))) and (v139 == (93 - (4 + 89)))) then
					v87 = v13:GetEnemiesInRange(105 - 75);
					if (v80.AcrobaticStrikes:IsAvailable() or ((1437 + 2509) < (5657 - 4369))) then
						v88 = v13:GetEnemiesInRange(4 + 6);
					end
					v139 = 1487 - (35 + 1451);
				end
			end
		else
			v89 = 1454 - (28 + 1425);
		end
		v90 = v79.CrimsonVial();
		if (v90 or ((5235 - (941 + 1052)) == (544 + 23))) then
			return v90;
		end
		v79.Poisons();
		if ((v81.Healthstone:IsReady() and (v13:HealthPercentage() < v33) and not (v13:IsChanneling() or v13:IsCasting())) or ((2361 - (822 + 692)) >= (1802 - 539))) then
			if (v9.Cast(v82.Healthstone) or ((1062 + 1191) == (2148 - (45 + 252)))) then
				return "Healthstone ";
			end
		end
		if ((v81.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v31) and not (v13:IsChanneling() or v13:IsCasting())) or ((2065 + 22) > (817 + 1555))) then
			if (v9.Cast(v82.RefreshingHealingPotion) or ((10818 - 6373) < (4582 - (114 + 319)))) then
				return "RefreshingHealingPotion ";
			end
		end
		if ((v80.Feint:IsCastable() and v80.Feint:IsReady() and (v13:HealthPercentage() <= v56) and not (v13:IsChanneling() or v13:IsCasting())) or ((2609 - 791) == (108 - 23))) then
			if (((402 + 228) < (3168 - 1041)) and v9.Cast(v80.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v57) or ((4060 - 2122) == (4477 - (556 + 1407)))) then
			v90 = v79.Stealth(v80.Stealth2, nil);
			if (((5461 - (741 + 465)) >= (520 - (170 + 295))) and v90) then
				return "Stealth (OOC): " .. v90;
			end
		end
		if (((1581 + 1418) > (1062 + 94)) and not v13:AffectingCombat() and (v80.Vanish:TimeSinceLastCast() > (2 - 1)) and v14:IsInRange(7 + 1) and v24) then
			if (((1508 + 842) > (655 + 500)) and v78.TargetIsValid() and v14:IsInRange(1240 - (957 + 273)) and not (v13:IsChanneling() or v13:IsCasting())) then
				if (((1078 + 2951) <= (1943 + 2910)) and v80.BladeFlurry:IsReady() and v13:BuffDown(v80.BladeFlurry) and v80.UnderhandedUpperhand:IsAvailable() and not v13:StealthUp(true, true)) then
					if (v9.Press(v80.BladeFlurry, not v14:IsInMeleeRange(38 - 28)) or ((1359 - 843) > (10488 - 7054))) then
						return "Blade Flurry (Opener)";
					end
				end
				if (((20034 - 15988) >= (4813 - (389 + 1391))) and not v13:StealthUp(true, false)) then
					v90 = v79.Stealth(v79.StealthSpell());
					if (v90 or ((1706 + 1013) <= (151 + 1296))) then
						return v90;
					end
				end
				if (v78.TargetIsValid() or ((9411 - 5277) < (4877 - (783 + 168)))) then
					if ((v80.AdrenalineRush:IsReady() and v80.ImprovedAdrenalineRush:IsAvailable() and (v93 <= (6 - 4))) or ((162 + 2) >= (3096 - (309 + 2)))) then
						if (v9.Cast(v80.AdrenalineRush) or ((1612 - 1087) == (3321 - (1090 + 122)))) then
							return "Cast Adrenaline Rush (Opener)";
						end
					end
					if (((11 + 22) == (110 - 77)) and v80.RolltheBones:IsReady() and not v13:DebuffUp(v80.Dreadblades) and ((v107() == (0 + 0)) or v108())) then
						if (((4172 - (628 + 490)) <= (720 + 3295)) and v9.Cast(v80.RolltheBones)) then
							return "Cast Roll the Bones (Opener)";
						end
					end
					if (((4632 - 2761) < (15455 - 12073)) and v80.SliceandDice:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (((775 - (431 + 343)) + v93) * (1.8 - 0)))) then
						if (((3740 - 2447) <= (1712 + 454)) and v9.Press(v80.SliceandDice)) then
							return "Cast Slice and Dice (Opener)";
						end
					end
					if (v13:StealthUp(true, false) or ((330 + 2249) < (1818 - (556 + 1139)))) then
						local v179 = 15 - (6 + 9);
						while true do
							if ((v179 == (0 + 0)) or ((434 + 412) >= (2537 - (28 + 141)))) then
								v90 = v118();
								if (v90 or ((1554 + 2458) <= (4144 - 786))) then
									return "Stealth (Opener): " .. v90;
								end
								v179 = 1 + 0;
							end
							if (((2811 - (486 + 831)) <= (7819 - 4814)) and (v179 == (3 - 2))) then
								if ((v80.KeepItRolling:IsAvailable() and v80.GhostlyStrike:IsReady() and v80.EchoingReprimand:IsAvailable()) or ((588 + 2523) == (6747 - 4613))) then
									if (((3618 - (668 + 595)) == (2120 + 235)) and v9.Press(v80.GhostlyStrike)) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if (v80.Ambush:IsCastable() or ((119 + 469) <= (1178 - 746))) then
									if (((5087 - (23 + 267)) >= (5839 - (1129 + 815))) and v9.Cast(v80.Ambush)) then
										return "Cast Ambush (Opener)";
									end
								end
								break;
							end
						end
					elseif (((3964 - (371 + 16)) == (5327 - (1326 + 424))) and v109()) then
						local v182 = 0 - 0;
						while true do
							if (((13864 - 10070) > (3811 - (88 + 30))) and (v182 == (771 - (720 + 51)))) then
								v90 = v119();
								if (v90 or ((2836 - 1561) == (5876 - (421 + 1355)))) then
									return "Finish (Opener): " .. v90;
								end
								break;
							end
						end
					end
					if (v80.SinisterStrike:IsCastable() or ((2624 - 1033) >= (1759 + 1821))) then
						if (((2066 - (286 + 797)) <= (6609 - 4801)) and v9.Cast(v80.SinisterStrike)) then
							return "Cast Sinister Strike (Opener)";
						end
					end
				end
				return;
			end
		end
		if ((v80.FanTheHammer:IsAvailable() and (v80.PistolShot:TimeSinceLastCast() < v13:GCDRemains())) or ((3561 - 1411) <= (1636 - (397 + 42)))) then
			v93 = v23(v93, v79.FanTheHammerCP());
		end
		if (((1178 + 2591) >= (1973 - (24 + 776))) and v78.TargetIsValid()) then
			local v140 = 0 - 0;
			while true do
				if (((2270 - (222 + 563)) == (3271 - 1786)) and (v140 == (2 + 0))) then
					if ((v80.ArcaneTorrent:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike) and (v97 > ((205 - (23 + 167)) + v96))) or ((5113 - (690 + 1108)) <= (1004 + 1778))) then
						if (v9.Cast(v80.ArcaneTorrent, v27) or ((723 + 153) >= (3812 - (40 + 808)))) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v80.ArcanePulse:IsCastable() and v14:IsSpellInRange(v80.SinisterStrike)) or ((368 + 1864) > (9548 - 7051))) then
						if (v9.Cast(v80.ArcanePulse) or ((2017 + 93) <= (176 + 156))) then
							return "Cast Arcane Pulse";
						end
					end
					if (((2022 + 1664) > (3743 - (47 + 524))) and v80.LightsJudgment:IsCastable() and v14:IsInMeleeRange(4 + 1)) then
						if (v9.Cast(v80.LightsJudgment, v27) or ((12229 - 7755) < (1226 - 406))) then
							return "Cast Lights Judgment";
						end
					end
					v140 = 6 - 3;
				end
				if (((6005 - (1165 + 561)) >= (86 + 2796)) and (v140 == (9 - 6))) then
					if ((v80.BagofTricks:IsCastable() and v14:IsInMeleeRange(2 + 3)) or ((2508 - (341 + 138)) >= (951 + 2570))) then
						if (v9.Cast(v80.BagofTricks, v27) or ((4203 - 2166) >= (4968 - (89 + 237)))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((5533 - 3813) < (9385 - 4927)) and v80.PistolShot:IsCastable() and v14:IsSpellInRange(v80.PistolShot) and not v14:IsInRange(887 - (581 + 300)) and not v13:StealthUp(true, true) and (v97 < (1245 - (855 + 365))) and ((v94 >= (2 - 1)) or (v98 <= (1.2 + 0)))) then
						if (v9.Cast(v80.PistolShot) or ((1671 - (1030 + 205)) > (2837 + 184))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((664 + 49) <= (1133 - (156 + 130))) and v80.SinisterStrike:IsCastable()) then
						if (((4893 - 2739) <= (6793 - 2762)) and v9.Cast(v80.SinisterStrike)) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((9452 - 4837) == (1217 + 3398)) and (v140 == (0 + 0))) then
					v90 = v117();
					if (v90 or ((3859 - (10 + 59)) == (142 + 358))) then
						return "CDs: " .. v90;
					end
					if (((438 - 349) < (1384 - (671 + 492))) and (v13:StealthUp(true, true) or v13:BuffUp(v80.Shadowmeld))) then
						v90 = v118();
						if (((1636 + 418) >= (2636 - (369 + 846))) and v90) then
							return "Stealth: " .. v90;
						end
					end
					v140 = 1 + 0;
				end
				if (((591 + 101) < (5003 - (1036 + 909))) and (v140 == (1 + 0))) then
					if (v109() or ((5462 - 2208) == (1858 - (11 + 192)))) then
						local v174 = 0 + 0;
						while true do
							if ((v174 == (175 - (135 + 40))) or ((3139 - 1843) == (2960 + 1950))) then
								v90 = v119();
								if (((7419 - 4051) == (5048 - 1680)) and v90) then
									return "Finish: " .. v90;
								end
								break;
							end
						end
					end
					v90 = v120();
					if (((2819 - (50 + 126)) < (10622 - 6807)) and v90) then
						return "Build: " .. v90;
					end
					v140 = 1 + 1;
				end
			end
		end
	end
	local function v122()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(1673 - (1233 + 180), v121, v122);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

