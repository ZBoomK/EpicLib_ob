local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1634 - (1607 + 27);
	local v6;
	while true do
		if (((927 + 2293) == (4946 - (1668 + 58))) and (v5 == (626 - (512 + 114)))) then
			v6 = v0[v4];
			if (((5563 - 3429) == (4411 - 2277)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (1 + 0)) or ((404 + 1750) >= (2891 + 434))) then
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
	local v81;
	local function v82()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (2002 - (109 + 1885))) or ((2764 - (1269 + 200)) >= (6196 - 2963))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v128 = 824 - (98 + 717);
			end
			if (((5203 - (802 + 24)) > (2831 - 1189)) and (v128 == (1 - 0))) then
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v128 = 1 + 1;
			end
			if (((1019 + 3704) > (3772 - 2416)) and (v128 == (19 - 13))) then
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v128 = 3 + 4;
			end
			if ((v128 == (3 + 4)) or ((3412 + 724) <= (2497 + 936))) then
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 4 + 4;
			end
			if (((5678 - (797 + 636)) <= (22485 - 17854)) and (v128 == (1624 - (1427 + 192)))) then
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v59 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v60 = EpicSettings.Settings['StealthOOC'];
				v128 = 6 + 0;
			end
			if (((1938 + 2338) >= (4240 - (192 + 134))) and (v128 == (1280 - (316 + 960)))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v128 = 3 + 2;
			end
			if (((153 + 45) <= (4035 + 330)) and (v128 == (0 - 0))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v128 = 552 - (83 + 468);
			end
			if (((6588 - (1202 + 604)) > (21828 - 17152)) and ((14 - 5) == v128)) then
				v79 = EpicSettings.Settings['sepsis'];
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if (((5189 - (45 + 280)) > (2121 + 76)) and (v128 == (3 + 0))) then
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 2 + 2;
			end
			if ((v128 == (2 + 0)) or ((651 + 3049) == (4642 - 2135))) then
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v40 = EpicSettings.Settings['InterruptThreshold'] or (1911 - (340 + 1571));
				v128 = 2 + 1;
			end
		end
	end
	local v83 = v10.Commons.Everyone;
	local v84 = v10.Commons.Rogue;
	local v85 = v18.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = v21.Rogue.Outlaw;
	local v88 = {};
	local v89 = v16:GetEquipment();
	local v90 = (v89[1785 - (1733 + 39)] and v20(v89[35 - 22])) or v20(1034 - (125 + 909));
	local v91 = (v89[1962 - (1096 + 852)] and v20(v89[7 + 7])) or v20(0 - 0);
	v10:RegisterForEvent(function()
		v89 = v16:GetEquipment();
		v90 = (v89[13 + 0] and v20(v89[525 - (409 + 103)])) or v20(236 - (46 + 190));
		v91 = (v89[109 - (51 + 44)] and v20(v89[4 + 10])) or v20(1317 - (1114 + 203));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 732 - (228 + 498);
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (1162 - (171 + 991));
	end}};
	local v106, v107 = 0 - 0, 0 - 0;
	local function v108(v129)
		local v130 = v16:EnergyTimeToMaxPredicted(nil, v129);
		if (((11164 - 6690) >= (220 + 54)) and ((v130 < v106) or ((v130 - v106) > (0.5 - 0)))) then
			v106 = v130;
		end
		return v106;
	end
	local function v109()
		local v131 = 0 - 0;
		local v132;
		while true do
			if (((1 - 0) == v131) or ((5854 - 3960) <= (2654 - (111 + 1137)))) then
				return v107;
			end
			if (((1730 - (91 + 67)) >= (4556 - 3025)) and ((0 + 0) == v131)) then
				v132 = v16:EnergyPredicted();
				if ((v132 > v107) or ((v132 - v107) > (532 - (423 + 100))) or ((33 + 4654) < (12575 - 8033))) then
					v107 = v132;
				end
				v131 = 1 + 0;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		local v133 = 32 - (19 + 13);
		while true do
			if (((5356 - 2065) > (3884 - 2217)) and (v133 == (0 - 0))) then
				if (not v11.APLVar.RtB_Buffs or ((227 + 646) == (3577 - 1543))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Total = 1812 - (1293 + 519);
					v11.APLVar.RtB_Buffs.Normal = 0 - 0;
					v11.APLVar.RtB_Buffs.Shorter = 0 - 0;
					v11.APLVar.RtB_Buffs.Longer = 0 - 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
					local v184 = v84.RtBRemains();
					for v186 = 2 - 1, #v110 do
						local v187 = v16:BuffRemains(v110[v186]);
						if ((v187 > (0 + 0)) or ((575 + 2241) < (25 - 14))) then
							local v192 = 0 + 0;
							local v193;
							while true do
								if (((1229 + 2470) < (2941 + 1765)) and (v192 == (1097 - (709 + 387)))) then
									v193 = math.abs(v187 - v184);
									if (((4504 - (673 + 1185)) >= (2540 - 1664)) and (v193 <= (0.5 - 0))) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1 - 0);
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v186]:Name()] = true;
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
									elseif (((459 + 155) <= (4298 - 1114)) and (v187 > v184)) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
									else
										local v205 = 0 - 0;
										while true do
											if (((6135 - 3009) == (5006 - (446 + 1434))) and (v205 == (1283 - (1040 + 243)))) then
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (2 - 1);
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v186]:Name()] = true;
												v205 = 1848 - (559 + 1288);
											end
											if ((v205 == (1932 - (609 + 1322))) or ((2641 - (13 + 441)) >= (18512 - 13558))) then
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
												break;
											end
										end
									end
									break;
								end
								if (((0 - 0) == v192) or ((145 + 3732) == (12983 - 9408))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
									if (((310 + 397) > (1875 - 1243)) and (v187 > v11.APLVar.RtB_Buffs.MaxRemains)) then
										v11.APLVar.RtB_Buffs.MaxRemains = v187;
									end
									v192 = 1 + 0;
								end
							end
						end
						if (v111 or ((1003 - 457) >= (1775 + 909))) then
							print("RtbRemains", v184);
							print(v110[v186]:Name(), v187);
						end
					end
					if (((815 + 650) <= (3091 + 1210)) and v111) then
						local v190 = 0 + 0;
						while true do
							if (((1668 + 36) > (1858 - (153 + 280))) and (v190 == (5 - 3))) then
								print("longer: ", v11.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if ((v190 == (0 + 0)) or ((272 + 415) == (2216 + 2018))) then
								print("have: ", v11.APLVar.RtB_Buffs.Total);
								print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
								v190 = 1 + 0;
							end
							if ((v190 == (1 + 0)) or ((5070 - 1740) < (884 + 545))) then
								print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v11.APLVar.RtB_Buffs.Normal);
								v190 = 669 - (89 + 578);
							end
						end
					end
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v113(v134)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v134] and true) or false;
	end
	local function v114()
		if (((820 + 327) >= (696 - 361)) and not v11.APLVar.RtB_Reroll) then
			if (((4484 - (572 + 477)) > (283 + 1814)) and (v65 == "1+ Buff")) then
				v11.APLVar.RtB_Reroll = ((v112() <= (0 + 0)) and true) or false;
			elseif ((v65 == "Broadside") or ((451 + 3319) >= (4127 - (84 + 2)))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
			elseif ((v65 == "Buried Treasure") or ((6247 - 2456) <= (1161 + 450))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
			elseif ((v65 == "Grand Melee") or ((5420 - (497 + 345)) <= (52 + 1956))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
			elseif (((191 + 934) <= (3409 - (605 + 728))) and (v65 == "Skull and Crossbones")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
			elseif ((v65 == "Ruthless Precision") or ((531 + 212) >= (9779 - 5380))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
			elseif (((53 + 1102) < (6185 - 4512)) and (v65 == "True Bearing")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
			else
				v11.APLVar.RtB_Reroll = false;
				v112();
				v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (2 + 0))));
				if ((v85.Crackshot:IsAvailable() and not v16:HasTier(85 - 54, 4 + 0)) or ((2813 - (457 + 32)) <= (246 + 332))) then
					v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1403 - (832 + 570))));
				end
				if (((3549 + 218) == (983 + 2784)) and v85.Crackshot:IsAvailable() and v16:HasTier(109 - 78, 2 + 2)) then
					v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((797 - (588 + 208)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
				end
				if (((11020 - 6931) == (5889 - (884 + 916))) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((3 - 1) + v22(v113(v85.GrandMelee)))) and (v94 < (2 + 0))) then
					v11.APLVar.RtB_Reroll = true;
				end
				v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (653 - (232 + 421))) or ((v11.APLVar.RtB_Buffs.Normal == (1889 - (1569 + 320))) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (2 + 4)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (131 - 92)) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
				if (((5063 - (316 + 289)) >= (4381 - 2707)) and (v17:FilteredTimeToDie("<", 1 + 11) or v10.BossFilteredFightRemains("<", 1465 - (666 + 787)))) then
					v11.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (426 - (360 + 65))) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= (2 + 0 + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (304 - (79 + 175)));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (2 - 0)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v135 = 0 + 0;
		while true do
			if (((2979 - 2007) <= (2730 - 1312)) and (v135 == (899 - (503 + 396)))) then
				if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (187 - (92 + 89)))) and v116()) or ((9579 - 4641) < (2443 + 2319))) then
					if (v10.Cast(v85.Vanish, v68) or ((1482 + 1022) > (16698 - 12434))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((295 + 1858) == (4908 - 2755)) and v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) then
					if (v10.Cast(v85.Vanish, v68) or ((443 + 64) >= (1238 + 1353))) then
						return "Cast Vanish (Finish)";
					end
				end
				v135 = 2 - 1;
			end
			if (((560 + 3921) == (6833 - 2352)) and (v135 == (1245 - (485 + 759)))) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (13 - 7)) or not v68) and not v16:StealthUp(true, false)) or ((3517 - (442 + 747)) < (1828 - (832 + 303)))) then
					if (((5274 - (88 + 858)) == (1320 + 3008)) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((1315 + 273) >= (55 + 1277)) and v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) then
					if (v12(v85.ShadowDance, v54) or ((4963 - (766 + 23)) > (20971 - 16723))) then
						return "Cast Shadow Dance";
					end
				end
				v135 = 2 - 0;
			end
			if ((v135 == (4 - 2)) or ((15564 - 10978) <= (1155 - (1036 + 37)))) then
				if (((2739 + 1124) == (7522 - 3659)) and v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (24 + 6)) or ((v85.KeepItRolling:CooldownRemains() >= (1600 - (641 + 839))) and (v115() or v85.HiddenOpportunity:IsAvailable())))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((1195 - (910 + 3)) <= (106 - 64))) then
						return "Cast Shadow Dance";
					end
				end
				if (((6293 - (1466 + 218)) >= (353 + 413)) and v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) then
					if ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())) or ((2300 - (556 + 592)) == (885 + 1603))) then
						if (((4230 - (329 + 479)) > (4204 - (174 + 680))) and v10.Cast(v85.Shadowmeld, v31)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		local v137;
		while true do
			if (((1817 - 940) > (269 + 107)) and (v136 == (739 - (396 + 343)))) then
				v137 = v83.HandleTopTrinket(v88, v29, 4 + 36, nil);
				if (v137 or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
					return v137;
				end
				v136 = 3 - 2;
			end
			if ((v136 == (4 - 3)) or ((110 + 55) >= (5019 - (389 + 1138)))) then
				v137 = v83.HandleBottomTrinket(v88, v29, 614 - (102 + 472), nil);
				if (((3727 + 222) < (2693 + 2163)) and v137) then
					return v137;
				end
				break;
			end
		end
	end
	local function v122()
		local v138 = 0 + 0;
		local v139;
		local v140;
		while true do
			if ((v138 == (1547 - (320 + 1225))) or ((7611 - 3335) < (1846 + 1170))) then
				v140 = v121();
				if (((6154 - (157 + 1307)) > (5984 - (821 + 1038))) and v140) then
					return v140;
				end
				if ((v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((7 - 4) + v22(v16:HasTier(4 + 27, 6 - 2)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (3 + 3)))) or ((123 - 73) >= (1922 - (834 + 192)))) then
					if (v10.Cast(v85.KeepItRolling) or ((109 + 1605) >= (760 + 2198))) then
						return "Cast Keep it Rolling";
					end
				end
				v138 = 1 + 2;
			end
			if ((v138 == (8 - 2)) or ((1795 - (300 + 4)) < (172 + 472))) then
				if (((1842 - 1138) < (1349 - (112 + 250))) and v85.AncestralCall:IsCastable()) then
					if (((1483 + 2235) > (4774 - 2868)) and v10.Cast(v85.AncestralCall, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if ((v138 == (3 + 1)) or ((496 + 462) > (2719 + 916))) then
				if (((1736 + 1765) <= (3338 + 1154)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
					local v185 = 1414 - (1001 + 413);
					while true do
						if (((0 - 0) == v185) or ((4324 - (244 + 638)) < (3241 - (627 + 66)))) then
							v140 = v120();
							if (((8566 - 5691) >= (2066 - (512 + 90))) and v140) then
								return v140;
							end
							break;
						end
					end
				end
				if ((v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (2006 - (1665 + 241))) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (723 - (373 + 344))))) or ((2164 + 2633) >= (1295 + 3598))) then
					if (v10.Cast(v85.ThistleTea) or ((1453 - 902) > (3499 - 1431))) then
						return "Cast Thistle Tea";
					end
				end
				if (((3213 - (35 + 1064)) > (687 + 257)) and v85.BladeRush:IsCastable() and (v103 > (8 - 4)) and not v16:StealthUp(true, true)) then
					if (v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush)) or ((10 + 2252) >= (4332 - (298 + 938)))) then
						return "Cast Blade Rush";
					end
				end
				v138 = 1264 - (233 + 1026);
			end
			if ((v138 == (1669 - (636 + 1030))) or ((1153 + 1102) >= (3455 + 82))) then
				if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (3 + 4))) or ((260 + 3577) < (1527 - (55 + 166)))) then
					if (((572 + 2378) == (297 + 2653)) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((18037 - 13314) < (3595 - (36 + 261)))) then
					if (((1986 - 850) >= (1522 - (34 + 1334))) and ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 5 + 6) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 9 + 2))) then
						if (v10.Cast(v85.Sepsis) or ((1554 - (1035 + 248)) > (4769 - (20 + 1)))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((2470 + 2270) >= (3471 - (134 + 185))) and v85.BladeRush:IsReady() and (v103 > (1137 - (549 + 584))) and not v16:StealthUp(true, true)) then
					if (v10.Cast(v85.BladeRush) or ((3263 - (314 + 371)) >= (11637 - 8247))) then
						return "Cast Blade Rush";
					end
				end
				v138 = 972 - (478 + 490);
			end
			if (((22 + 19) <= (2833 - (786 + 386))) and (v138 == (3 - 2))) then
				if (((1980 - (1055 + 324)) < (4900 - (1093 + 247))) and v85.BladeFlurry:IsReady()) then
					if (((209 + 26) < (73 + 614)) and (v94 >= ((7 - 5) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) then
						if (((15438 - 10889) > (3280 - 2127)) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v85.BladeFlurry:IsReady() or ((11745 - 7071) < (1662 + 3010))) then
					if (((14130 - 10462) < (15720 - 11159)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (3 + 0)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (12 - 7)))) then
						if (v12(v85.BladeFlurry) or ((1143 - (364 + 324)) == (9882 - 6277))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v85.RolltheBones:IsReady() or ((6389 - 3726) == (1098 + 2214))) then
					if (((17896 - 13619) <= (7166 - 2691)) and (v114() or (v112() == (0 - 0)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (1271 - (1249 + 19))) and v16:HasTier(28 + 3, 15 - 11)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (1093 - (686 + 400))) and ((v85.ShadowDance:CooldownRemains() <= (3 + 0)) or (v85.Vanish:CooldownRemains() <= (232 - (73 + 156))))))) then
						if (v12(v85.RolltheBones) or ((5 + 865) == (2000 - (721 + 90)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v138 = 1 + 1;
			end
			if (((5042 - 3489) <= (3603 - (224 + 246))) and (v138 == (0 - 0))) then
				v139 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (v139 or ((4118 - 1881) >= (637 + 2874))) then
					return "DPS Pot";
				end
				if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1 + 1))))) or ((973 + 351) > (6004 - 2984))) then
					if (v12(v85.AdrenalineRush, v76) or ((9956 - 6964) == (2394 - (203 + 310)))) then
						return "Cast Adrenaline Rush";
					end
				end
				v138 = 1994 - (1238 + 755);
			end
			if (((217 + 2889) > (3060 - (709 + 825))) and (v138 == (8 - 3))) then
				if (((4402 - 1379) < (4734 - (196 + 668))) and v85.BloodFury:IsCastable()) then
					if (((564 - 421) > (152 - 78)) and v10.Cast(v85.BloodFury, v31)) then
						return "Cast Blood Fury";
					end
				end
				if (((851 - (171 + 662)) < (2205 - (4 + 89))) and v85.Berserking:IsCastable()) then
					if (((3844 - 2747) <= (593 + 1035)) and v10.Cast(v85.Berserking, v31)) then
						return "Cast Berserking";
					end
				end
				if (((20336 - 15706) == (1816 + 2814)) and v85.Fireblood:IsCastable()) then
					if (((5026 - (35 + 1451)) > (4136 - (28 + 1425))) and v10.Cast(v85.Fireblood, v31)) then
						return "Cast Fireblood";
					end
				end
				v138 = 1999 - (941 + 1052);
			end
		end
	end
	local function v123()
		local v141 = 0 + 0;
		while true do
			if (((6308 - (822 + 692)) >= (4675 - 1400)) and (v141 == (0 + 0))) then
				if (((1781 - (45 + 252)) == (1469 + 15)) and v85.BladeFlurry:IsReady()) then
					if (((493 + 939) < (8652 - 5097)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (435 - (114 + 319))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (6 - 1)))) then
						if (v10.Cast(v85.BladeFlurry, v71) or ((1364 - 299) > (2281 + 1297))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((7143 - 2348) < (2947 - 1540))) then
					if (((3816 - (556 + 1407)) < (6019 - (741 + 465))) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				v141 = 466 - (170 + 295);
			end
			if ((v141 == (2 + 0)) or ((2592 + 229) < (5985 - 3554))) then
				if ((v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (2 + 0)) and (v16:BuffStack(v85.Opportunity) >= (4 + 2)) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 + 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) or ((4104 - (957 + 273)) < (584 + 1597))) then
					if (v10.Press(v85.PistolShot) or ((1077 + 1612) <= (1306 - 963))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((4925 - 3056) == (6136 - 4127))) then
					if (v12(v85.Ambush, nil, not v17:IsSpellInRange(v85.Ambush)) or ((17558 - 14012) < (4102 - (389 + 1391)))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v141 = 2 + 1;
			end
			if (((1 + 2) == v141) or ((4739 - 2657) == (5724 - (783 + 168)))) then
				if (((10887 - 7643) > (1038 + 17)) and v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) then
					if (v10.Press(v85.Ambush) or ((3624 - (309 + 2)) <= (5460 - 3682))) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if ((v141 == (1213 - (1090 + 122))) or ((461 + 960) >= (7066 - 4962))) then
				if (((1241 + 571) <= (4367 - (628 + 490))) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) then
					if (((292 + 1331) <= (4844 - 2887)) and v10.Cast(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((20162 - 15750) == (5186 - (431 + 343))) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (((3534 - 1784) >= (2435 - 1593)) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v141 = 2 + 0;
			end
		end
	end
	local function v124()
		local v142 = 0 + 0;
		while true do
			if (((6067 - (556 + 1139)) > (1865 - (6 + 9))) and (v142 == (0 + 0))) then
				if (((119 + 113) < (990 - (28 + 141))) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (2 + 2)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(37 - 7, 3 + 1)) and v16:BuffDown(v85.GreenskinsWickers)) then
					if (((1835 - (486 + 831)) < (2347 - 1445)) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((10540 - 7546) > (163 + 695)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (142 - 97)) and (v85.ShadowDance:CooldownRemains() > (1275 - (668 + 595)))) then
					if (v10.Press(v85.BetweentheEyes) or ((3379 + 376) <= (185 + 730))) then
						return "Cast Between the Eyes";
					end
				end
				v142 = 2 - 1;
			end
			if (((4236 - (23 + 267)) > (5687 - (1129 + 815))) and (v142 == (389 - (371 + 16)))) then
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((3085 - (1326 + 424)) >= (6260 - 2954))) then
					if (((17701 - 12857) > (2371 - (88 + 30))) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				if (((1223 - (720 + 51)) == (1005 - 553)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Press(v85.Dispatch) or ((6333 - (421 + 1355)) < (3442 - 1355))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((1903 + 1971) == (4957 - (286 + 797))) and ((3 - 2) == v142)) then
				if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 - 0))) and (v16:BuffRemains(v85.SliceandDice) < (((440 - (397 + 42)) + v98) * (1.8 + 0)))) or ((2738 - (24 + 776)) > (7602 - 2667))) then
					if (v10.Press(v85.SliceandDice) or ((5040 - (222 + 563)) < (7541 - 4118))) then
						return "Cast Slice and Dice";
					end
				end
				if (((1047 + 407) <= (2681 - (23 + 167))) and v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) then
					if (v10.Cast(v85.KillingSpree) or ((5955 - (690 + 1108)) <= (1012 + 1791))) then
						return "Cast Killing Spree";
					end
				end
				v142 = 2 + 0;
			end
		end
	end
	local function v125()
		if (((5701 - (40 + 808)) >= (491 + 2491)) and v29 and v85.EchoingReprimand:IsReady()) then
			if (((15808 - 11674) > (3209 + 148)) and v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((1808 + 1609) < (1390 + 1144))) then
			if (v10.Press(v85.Ambush) or ((3293 - (47 + 524)) <= (107 + 57))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v85.PistolShot:IsCastable() and v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((6582 - 4174) < (3153 - 1044))) then
			if (v10.Press(v85.PistolShot) or ((74 - 41) == (3181 - (1165 + 561)))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v85.PistolShot:IsCastable() and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (1 + 5)) or (v16:BuffRemains(v85.Opportunity) < (6 - 4)))) or ((170 + 273) >= (4494 - (341 + 138)))) then
			if (((913 + 2469) > (342 - 176)) and v10.Press(v85.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v85.PistolShot:IsCastable() and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((327 - (89 + 237)) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (3 - 2))))) or (v98 <= v22(v85.Ruthlessness:IsAvailable())))) or ((589 - 309) == (3940 - (581 + 300)))) then
			if (((3101 - (855 + 365)) > (3070 - 1777)) and v10.Press(v85.PistolShot)) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if (((770 + 1587) == (3592 - (1030 + 205))) and v85.PistolShot:IsCastable() and not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1.5 + 0)) or (v99 <= (1 + 0 + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) then
			if (((409 - (156 + 130)) == (279 - 156)) and v10.Cast(v85.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (v85.SinisterStrike:IsCastable() or ((1779 - 723) >= (6946 - 3554))) then
			if (v10.Press(v85.SinisterStrike) or ((285 + 796) < (627 + 448))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v126()
		v82();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		v98 = v16:ComboPoints();
		v97 = v84.EffectiveComboPoints(v98);
		v99 = v16:ComboPointsDeficit();
		v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(119 - (10 + 59))) or (0 + 0);
		v100 = v109();
		v101 = v16:EnergyRegen();
		v103 = v108(v104);
		v102 = v16:EnergyDeficitPredicted(nil, v104);
		if (v28 or ((5166 - 4117) >= (5595 - (671 + 492)))) then
			local v147 = 0 + 0;
			while true do
				if ((v147 == (1215 - (369 + 846))) or ((1263 + 3505) <= (722 + 124))) then
					v92 = v16:GetEnemiesInRange(1975 - (1036 + 909));
					v93 = v16:GetEnemiesInRange(v96);
					v147 = 1 + 0;
				end
				if ((v147 == (1 - 0)) or ((3561 - (11 + 192)) <= (718 + 702))) then
					v94 = #v93;
					break;
				end
			end
		else
			v94 = 176 - (135 + 40);
		end
		v95 = v84.CrimsonVial();
		if (v95 or ((9058 - 5319) <= (1812 + 1193))) then
			return v95;
		end
		v84.Poisons();
		if ((v33 and (v16:HealthPercentage() <= v35)) or ((3654 - 1995) >= (3198 - 1064))) then
			if ((v34 == "Refreshing Healing Potion") or ((3436 - (50 + 126)) < (6557 - 4202))) then
				if (v86.RefreshingHealingPotion:IsReady() or ((149 + 520) == (5636 - (1233 + 180)))) then
					if (v10.Press(v87.RefreshingHealingPotion) or ((2661 - (522 + 447)) < (2009 - (107 + 1314)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v34 == "Dreamwalker's Healing Potion") or ((2226 + 2571) < (11124 - 7473))) then
				if (v86.DreamwalkersHealingPotion:IsReady() or ((1775 + 2402) > (9631 - 4781))) then
					if (v10.Press(v87.RefreshingHealingPotion) or ((1582 - 1182) > (3021 - (716 + 1194)))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (((53 + 2998) > (108 + 897)) and v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) then
			if (((4196 - (74 + 429)) <= (8452 - 4070)) and v10.Cast(v85.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) or ((1627 + 1655) > (9385 - 5285))) then
			if (v10.Cast(v85.Evasion) or ((2533 + 1047) < (8767 - 5923))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((219 - 130) < (4923 - (279 + 154))) and not v16:IsCasting() and not v16:IsChanneling()) then
			local v148 = v83.Interrupt(v85.Kick, 786 - (454 + 324), true);
			if (v148 or ((3921 + 1062) < (1825 - (12 + 5)))) then
				return v148;
			end
			v148 = v83.Interrupt(v85.Kick, 5 + 3, true, v13, v87.KickMouseover);
			if (((9756 - 5927) > (1393 + 2376)) and v148) then
				return v148;
			end
			v148 = v83.Interrupt(v85.Blind, 1108 - (277 + 816), v80);
			if (((6345 - 4860) <= (4087 - (1058 + 125))) and v148) then
				return v148;
			end
			v148 = v83.Interrupt(v85.Blind, 3 + 12, v80, v13, v87.BlindMouseover);
			if (((5244 - (815 + 160)) == (18316 - 14047)) and v148) then
				return v148;
			end
			v148 = v83.InterruptWithStun(v85.CheapShot, 18 - 10, v16:StealthUp(false, false));
			if (((93 + 294) <= (8132 - 5350)) and v148) then
				return v148;
			end
			v148 = v83.InterruptWithStun(v85.KidneyShot, 1906 - (41 + 1857), v16:ComboPoints() > (1893 - (1222 + 671)));
			if (v148 or ((4907 - 3008) <= (1318 - 401))) then
				return v148;
			end
		end
		if (v30 or ((5494 - (229 + 953)) <= (2650 - (1111 + 663)))) then
			v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 1609 - (874 + 705), true);
			if (((313 + 1919) <= (1772 + 824)) and v95) then
				return v95;
			end
		end
		if (((4354 - 2259) < (104 + 3582)) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
			v95 = v84.Stealth(v85.Stealth2, nil);
			if (v95 or ((2274 - (642 + 37)) >= (1021 + 3453))) then
				return "Stealth (OOC): " .. v95;
			end
		end
		if ((not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1 + 0)) and v17:IsInRange(19 - 11) and v27) or ((5073 - (233 + 221)) < (6664 - 3782))) then
			if ((v83.TargetIsValid() and v17:IsInRange(9 + 1) and not (v16:IsChanneling() or v16:IsCasting())) or ((1835 - (718 + 823)) >= (3040 + 1791))) then
				if (((2834 - (266 + 539)) <= (8731 - 5647)) and v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
					if (v12(v85.BladeFlurry) or ((3262 - (636 + 589)) == (5744 - 3324))) then
						return "Blade Flurry (Opener)";
					end
				end
				if (((9194 - 4736) > (3094 + 810)) and not v16:StealthUp(true, false)) then
					v95 = v84.Stealth(v84.StealthSpell());
					if (((159 + 277) >= (1138 - (657 + 358))) and v95) then
						return v95;
					end
				end
				if (((1323 - 823) < (4137 - 2321)) and v83.TargetIsValid()) then
					local v189 = 1187 - (1151 + 36);
					while true do
						if (((3452 + 122) == (940 + 2634)) and (v189 == (5 - 3))) then
							if (((2053 - (1552 + 280)) < (1224 - (64 + 770))) and v85.SinisterStrike:IsCastable()) then
								if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((1503 + 710) <= (3225 - 1804))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
							break;
						end
						if (((543 + 2515) < (6103 - (157 + 1086))) and (v189 == (1 - 0))) then
							if ((v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((4 - 3) + v98) * (1.8 - 0)))) or ((1768 - 472) >= (5265 - (599 + 220)))) then
								if (v10.Press(v85.SliceandDice) or ((2773 - 1380) > (6420 - (1813 + 118)))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (v16:StealthUp(true, false) or ((3234 + 1190) < (1244 - (841 + 376)))) then
								local v197 = 0 - 0;
								while true do
									if ((v197 == (1 + 0)) or ((5450 - 3453) > (4674 - (464 + 395)))) then
										if (((8892 - 5427) > (919 + 994)) and v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) then
											if (((1570 - (467 + 370)) < (3758 - 1939)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) or ((3227 + 1168) == (16300 - 11545))) then
											if (v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush)) or ((592 + 3201) < (5511 - 3142))) then
												return "Cast Ambush (Opener)";
											end
										elseif (v85.SinisterStrike:IsCastable() or ((4604 - (150 + 370)) == (1547 - (74 + 1208)))) then
											if (((10718 - 6360) == (20668 - 16310)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
										break;
									end
									if ((v197 == (0 + 0)) or ((3528 - (14 + 376)) < (1721 - 728))) then
										v95 = v123();
										if (((2155 + 1175) > (2041 + 282)) and v95) then
											return "Stealth (Opener): " .. v95;
										end
										v197 = 1 + 0;
									end
								end
							elseif (v115() or ((10624 - 6998) == (3001 + 988))) then
								v95 = v124();
								if (v95 or ((994 - (23 + 55)) == (6329 - 3658))) then
									return "Finish (Opener): " .. v95;
								end
							end
							v189 = 2 + 0;
						end
						if (((245 + 27) == (421 - 149)) and (v189 == (0 + 0))) then
							if (((5150 - (652 + 249)) <= (12949 - 8110)) and v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (1868 - (708 + 1160))) or v114())) then
								if (((7537 - 4760) < (5834 - 2634)) and v10.Cast(v85.RolltheBones)) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if (((122 - (10 + 17)) < (440 + 1517)) and v85.AdrenalineRush:IsReady() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1734 - (1400 + 332)))) then
								if (((1584 - 758) < (3625 - (242 + 1666))) and v10.Cast(v85.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							v189 = 1 + 0;
						end
					end
				end
				return;
			end
		end
		if (((523 + 903) >= (942 + 163)) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
			local v149 = 940 - (850 + 90);
			while true do
				if (((4823 - 2069) <= (4769 - (360 + 1030))) and (v149 == (0 + 0))) then
					v98 = v26(v98, v84.FanTheHammerCP());
					v97 = v84.EffectiveComboPoints(v98);
					v149 = 2 - 1;
				end
				if ((v149 == (1 - 0)) or ((5588 - (909 + 752)) == (2636 - (109 + 1114)))) then
					v99 = v16:ComboPointsDeficit();
					break;
				end
			end
		end
		if (v83.TargetIsValid() or ((2112 - 958) <= (307 + 481))) then
			local v150 = 242 - (6 + 236);
			while true do
				if ((v150 == (2 + 0)) or ((1323 + 320) > (7968 - 4589))) then
					if ((v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(8 - 3)) or ((3936 - (1076 + 57)) > (749 + 3800))) then
						if (v10.Cast(v85.LightsJudgment, v31) or ((909 - (579 + 110)) >= (239 + 2783))) then
							return "Cast Lights Judgment";
						end
					end
					if (((2496 + 326) == (1498 + 1324)) and v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(412 - (174 + 233))) then
						if (v10.Cast(v85.BagofTricks, v31) or ((2963 - 1902) == (3259 - 1402))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((1228 + 1532) > (2538 - (663 + 511))) and v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (23 + 2)) and ((v99 >= (1 + 0)) or (v103 <= (2.2 - 1)))) then
						if (v10.Cast(v85.PistolShot) or ((2969 + 1933) <= (8463 - 4868))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					break;
				end
				if ((v150 == (0 - 0)) or ((1839 + 2013) == (569 - 276))) then
					v95 = v122();
					if (v95 or ((1112 + 447) == (420 + 4168))) then
						return "CDs: " .. v95;
					end
					if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((5206 - (478 + 244)) == (1305 - (440 + 77)))) then
						v95 = v123();
						if (((2077 + 2491) >= (14299 - 10392)) and v95) then
							return "Stealth: " .. v95;
						end
					end
					if (((2802 - (655 + 901)) < (644 + 2826)) and v115()) then
						local v191 = 0 + 0;
						while true do
							if (((2747 + 1321) >= (3915 - 2943)) and (v191 == (1445 - (695 + 750)))) then
								v95 = v124();
								if (((1683 - 1190) < (6007 - 2114)) and v95) then
									return "Finish: " .. v95;
								end
								v191 = 3 - 2;
							end
							if ((v191 == (352 - (285 + 66))) or ((3433 - 1960) >= (4642 - (682 + 628)))) then
								return "Finish Pooling";
							end
						end
					end
					v150 = 1 + 0;
				end
				if ((v150 == (300 - (176 + 123))) or ((1695 + 2356) <= (840 + 317))) then
					v95 = v125();
					if (((873 - (239 + 30)) < (784 + 2097)) and v95) then
						return "Build: " .. v95;
					end
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (15 + 0 + v101))) or ((1592 - 692) == (10535 - 7158))) then
						if (((4774 - (306 + 9)) > (2062 - 1471)) and v10.Cast(v85.ArcaneTorrent, v31)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((591 + 2807) >= (1470 + 925)) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
						if (v10.Cast(v85.ArcanePulse) or ((1051 + 1132) >= (8075 - 5251))) then
							return "Cast Arcane Pulse";
						end
					end
					v150 = 1377 - (1140 + 235);
				end
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(166 + 94, v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

