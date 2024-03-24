local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3372 - (27 + 656)) < (4127 + 596)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((2289 + 1847) >= (422 + 1975)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1912 - (340 + 1571))) or ((1710 + 2624) == (6017 - (1733 + 39)))) then
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
		v31 = EpicSettings.Settings['UseRacials'];
		v33 = EpicSettings.Settings['UseHealingPotion'];
		v34 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v35 = EpicSettings.Settings['HealingPotionHP'] or (1034 - (125 + 909));
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (1948 - (1096 + 852));
		v38 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v30 = EpicSettings.Settings['HandleIncorporeal'];
		v53 = EpicSettings.Settings['VanishOffGCD'];
		v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v56 = EpicSettings.Settings['ColdBloodOffGCD'];
		v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v58 = EpicSettings.Settings['CrimsonVialHP'] or (512 - (409 + 103));
		v59 = EpicSettings.Settings['FeintHP'] or (236 - (46 + 190));
		v60 = EpicSettings.Settings['StealthOOC'];
		v65 = EpicSettings.Settings['RolltheBonesLogic'];
		v68 = EpicSettings.Settings['UseDPSVanish'];
		v71 = EpicSettings.Settings['BladeFlurryGCD'] or (95 - (51 + 44));
		v72 = EpicSettings.Settings['BladeRushGCD'];
		v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
		v75 = EpicSettings.Settings['KeepItRollingGCD'];
		v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
		v77 = EpicSettings.Settings['EchoingReprimand'];
		v78 = EpicSettings.Settings['UseSoloVanish'];
		v79 = EpicSettings.Settings['sepsis'];
		v80 = EpicSettings.Settings['BlindInterrupt'] or (0 + 0);
		v81 = EpicSettings.Settings['EvasionHP'] or (1317 - (1114 + 203));
	end
	local v83 = v10.Commons.Everyone;
	local v84 = v10.Commons.Rogue;
	local v85 = v18.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = v21.Rogue.Outlaw;
	local v88 = {};
	local v89 = v16:GetEquipment();
	local v90 = (v89[739 - (228 + 498)] and v20(v89[3 + 10])) or v20(0 + 0);
	local v91 = (v89[677 - (174 + 489)] and v20(v89[36 - 22])) or v20(1905 - (830 + 1075));
	v10:RegisterForEvent(function()
		v89 = v16:GetEquipment();
		v90 = (v89[537 - (303 + 221)] and v20(v89[1282 - (231 + 1038)])) or v20(0 + 0);
		v91 = (v89[1176 - (171 + 991)] and v20(v89[57 - 43])) or v20(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 14 - 8;
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 523 - (423 + 100), 0 + 0;
	local function v108(v147)
		local v148 = v16:EnergyTimeToMaxPredicted(nil, v147);
		if ((v148 < v106) or ((v148 - v106) > (0.5 - 0)) or ((2229 + 2047) <= (3802 - (326 + 445)))) then
			v106 = v148;
		end
		return v106;
	end
	local function v109()
		local v149 = 0 - 0;
		local v150;
		while true do
			if (((2 - 1) == v149) or ((11161 - 6379) <= (1910 - (530 + 181)))) then
				return v107;
			end
			if ((v149 == (881 - (614 + 267))) or ((4896 - (19 + 13)) < (3095 - 1193))) then
				v150 = v16:EnergyPredicted();
				if (((11276 - 6437) >= (10569 - 6869)) and ((v150 > v107) or ((v150 - v107) > (3 + 6)))) then
					v107 = v150;
				end
				v149 = 1 - 0;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		if (not v11.APLVar.RtB_Buffs or ((2532 - 1457) > (1016 + 902))) then
			local v163 = 0 + 0;
			local v164;
			while true do
				if (((919 - 523) <= (880 + 2924)) and (v163 == (1 + 0))) then
					v11.APLVar.RtB_Buffs.Total = 0 + 0;
					v11.APLVar.RtB_Buffs.Normal = 1096 - (709 + 387);
					v11.APLVar.RtB_Buffs.Shorter = 1858 - (673 + 1185);
					v163 = 5 - 3;
				end
				if ((v163 == (6 - 4)) or ((6858 - 2689) == (1565 + 622))) then
					v11.APLVar.RtB_Buffs.Longer = 0 + 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
					v164 = v84.RtBRemains();
					v163 = 1 + 2;
				end
				if (((2803 - 1397) == (2759 - 1353)) and (v163 == (1880 - (446 + 1434)))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 1283 - (1040 + 243);
					v163 = 2 - 1;
				end
				if (((3378 - (559 + 1288)) < (6202 - (609 + 1322))) and (v163 == (457 - (13 + 441)))) then
					for v181 = 3 - 2, #v110 do
						local v182 = 0 - 0;
						local v183;
						while true do
							if (((3162 - 2527) == (24 + 611)) and (v182 == (0 - 0))) then
								v183 = v16:BuffRemains(v110[v181]);
								if (((1199 + 2174) <= (1559 + 1997)) and (v183 > (0 - 0))) then
									local v190 = 0 + 0;
									local v191;
									while true do
										if (((1 - 0) == v190) or ((2176 + 1115) < (1825 + 1455))) then
											v191 = math.abs(v183 - v164);
											if (((3152 + 1234) >= (734 + 139)) and (v191 <= (0.5 + 0))) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (434 - (153 + 280));
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v181]:Name()] = true;
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
											elseif (((827 + 94) <= (436 + 666)) and (v183 > v164)) then
												v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
											else
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v181]:Name()] = true;
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
											end
											break;
										end
										if (((7165 - 2459) >= (596 + 367)) and ((667 - (89 + 578)) == v190)) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
											if ((v183 > v11.APLVar.RtB_Buffs.MaxRemains) or ((1995 - 1035) <= (1925 - (572 + 477)))) then
												v11.APLVar.RtB_Buffs.MaxRemains = v183;
											end
											v190 = 1 + 0;
										end
									end
								end
								v182 = 1 + 0;
							end
							if ((v182 == (1 + 0)) or ((2152 - (84 + 2)) == (1535 - 603))) then
								if (((3476 + 1349) < (5685 - (497 + 345))) and v111) then
									local v192 = 0 + 0;
									while true do
										if ((v192 == (0 + 0)) or ((5210 - (605 + 728)) >= (3238 + 1299))) then
											print("RtbRemains", v164);
											print(v110[v181]:Name(), v183);
											break;
										end
									end
								end
								break;
							end
						end
					end
					if (v111 or ((9593 - 5278) < (80 + 1646))) then
						local v185 = 0 - 0;
						while true do
							if ((v185 == (1 + 0)) or ((10192 - 6513) < (472 + 153))) then
								print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v11.APLVar.RtB_Buffs.Normal);
								v185 = 491 - (457 + 32);
							end
							if (((0 + 0) == v185) or ((6027 - (832 + 570)) < (596 + 36))) then
								print("have: ", v11.APLVar.RtB_Buffs.Total);
								print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
								v185 = 1 + 0;
							end
							if ((v185 == (6 - 4)) or ((40 + 43) > (2576 - (588 + 208)))) then
								print("longer: ", v11.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
						end
					end
					break;
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v113(v151)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v151] and true) or false;
	end
	local function v114()
		if (((1471 - 925) <= (2877 - (884 + 916))) and not v11.APLVar.RtB_Reroll) then
			if ((v65 == "1+ Buff") or ((2084 - 1088) > (2494 + 1807))) then
				v11.APLVar.RtB_Reroll = ((v112() <= (653 - (232 + 421))) and true) or false;
			elseif (((5959 - (1569 + 320)) > (169 + 518)) and (v65 == "Broadside")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
			elseif ((v65 == "Buried Treasure") or ((125 + 531) >= (11221 - 7891))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
			elseif ((v65 == "Grand Melee") or ((3097 - (316 + 289)) <= (876 - 541))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
			elseif (((200 + 4122) >= (4015 - (666 + 787))) and (v65 == "Skull and Crossbones")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
			elseif ((v65 == "Ruthless Precision") or ((4062 - (360 + 65)) >= (3524 + 246))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
			elseif ((v65 == "True Bearing") or ((2633 - (79 + 175)) > (7218 - 2640))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
			else
				local v202 = 0 + 0;
				while true do
					if ((v202 == (2 - 1)) or ((930 - 447) > (1642 - (503 + 396)))) then
						if (((2635 - (92 + 89)) > (1120 - 542)) and (v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee)))) and (v94 < (2 + 0))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((551 + 379) < (17458 - 13000)) and v85.Crackshot:IsAvailable() and not v16:HasTier(5 + 26, 8 - 4) and ((not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable())) and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v202 = 1 + 1;
					end
					if (((2016 - 1354) <= (122 + 850)) and (v202 == (0 - 0))) then
						v11.APLVar.RtB_Reroll = false;
						v112();
						v202 = 1245 - (485 + 759);
					end
					if (((10111 - 5741) == (5559 - (442 + 747))) and (v202 == (1138 - (832 + 303)))) then
						if ((v11.APLVar.RtB_Reroll and (v11.APLVar.RtB_Buffs.Longer == (946 - (88 + 858)))) or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (1 + 5)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (828 - (766 + 23))) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)) or ((23508 - 18746) <= (1177 - 316))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (v17:FilteredTimeToDie("<", 31 - 19) or v10.BossFilteredFightRemains("<", 40 - 28) or ((2485 - (1036 + 37)) == (3024 + 1240))) then
							v11.APLVar.RtB_Reroll = false;
						end
						break;
					end
					if ((v202 == (3 - 1)) or ((2493 + 675) < (3633 - (641 + 839)))) then
						if ((v85.Crackshot:IsAvailable() and v16:HasTier(944 - (910 + 3), 9 - 5) and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((1685 - (1466 + 218)) + v22(v16:BuffUp(v85.LoadedDiceBuff))))) or ((2287 + 2689) < (2480 - (556 + 592)))) then
							v11.APLVar.RtB_Reroll = true;
						end
						if (((1646 + 2982) == (5436 - (329 + 479))) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((856 - (174 + 680)) + v113(v85.GrandMelee))) and (v94 < (6 - 4))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v202 = 5 - 2;
					end
				end
			end
		end
		return v11.APLVar.RtB_Reroll;
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1 + 0)) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((741 - (396 + 343)) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (5 + 45));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (1479 - (29 + 1448))) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v152 = 1389 - (135 + 1254);
		while true do
			if ((v152 == (7 - 5)) or ((252 - 198) == (264 + 131))) then
				if (((1609 - (389 + 1138)) == (656 - (102 + 472))) and v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (29 + 1)) or ((v85.KeepItRolling:CooldownRemains() >= (67 + 53)) and (v115() or v85.HiddenOpportunity:IsAvailable())))) then
					if (v10.Cast(v85.ShadowDance, v54) or ((542 + 39) < (1827 - (320 + 1225)))) then
						return "Cast Shadow Dance";
					end
				end
				if ((v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady()) or ((8204 - 3595) < (1527 + 968))) then
					if (((2616 - (157 + 1307)) == (3011 - (821 + 1038))) and ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())))) then
						if (((4730 - 2834) <= (375 + 3047)) and v10.Cast(v85.Shadowmeld, v31)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if ((v152 == (1 - 0)) or ((369 + 621) > (4015 - 2395))) then
				if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (1032 - (834 + 192))) or not v68) and not v16:StealthUp(true, false)) or ((56 + 821) > (1206 + 3489))) then
					if (((58 + 2633) >= (2867 - 1016)) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((3289 - (300 + 4)) >= (1297 + 3559))) then
					if (((11193 - 6917) >= (1557 - (112 + 250))) and v12(v85.ShadowDance, v10.Cast(v85.ShadowDance, v54))) then
						return "Cast Shadow Dance";
					end
				end
				v152 = 1 + 1;
			end
			if (((8096 - 4864) <= (2687 + 2003)) and (v152 == (0 + 0))) then
				if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (5 + 1))) and v116()) or ((445 + 451) >= (2338 + 808))) then
					if (((4475 - (1001 + 413)) >= (6596 - 3638)) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (HO)";
					end
				end
				if (((4069 - (244 + 638)) >= (1337 - (627 + 66))) and v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) then
					if (((1918 - 1274) <= (1306 - (512 + 90))) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (Finish)";
					end
				end
				v152 = 1907 - (1665 + 241);
			end
		end
	end
	local function v121()
		local v153 = 717 - (373 + 344);
		local v154;
		while true do
			if (((433 + 525) > (251 + 696)) and (v153 == (2 - 1))) then
				v154 = v83.HandleBottomTrinket(v88, v29, 67 - 27, nil);
				if (((5591 - (35 + 1064)) >= (1932 + 722)) and v154) then
					return v154;
				end
				break;
			end
			if (((7364 - 3922) >= (6 + 1497)) and (v153 == (1236 - (298 + 938)))) then
				v154 = v83.HandleTopTrinket(v88, v29, 1299 - (233 + 1026), nil);
				if (v154 or ((4836 - (636 + 1030)) <= (749 + 715))) then
					return v154;
				end
				v153 = 1 + 0;
			end
		end
	end
	local function v122()
		local v155 = 0 + 0;
		local v156;
		local v157;
		while true do
			if ((v155 == (1 + 2)) or ((5018 - (55 + 166)) == (851 + 3537))) then
				if (((56 + 495) <= (2600 - 1919)) and v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (304 - (36 + 261)))) then
					if (((5730 - 2453) > (1775 - (34 + 1334))) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((1805 + 2890) >= (1100 + 315)) and v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) then
					if ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 1294 - (1035 + 248)) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 32 - (20 + 1)) or ((1674 + 1538) <= (1263 - (134 + 185)))) then
						if (v10.Cast(v85.Sepsis) or ((4229 - (549 + 584)) <= (2483 - (314 + 371)))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((12142 - 8605) == (4505 - (478 + 490))) and v85.BladeRush:IsReady() and (v103 > (3 + 1)) and not v16:StealthUp(true, true)) then
					if (((5009 - (786 + 386)) >= (5085 - 3515)) and v10.Cast(v85.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v155 = 1383 - (1055 + 324);
			end
			if ((v155 == (1341 - (1093 + 247))) or ((2622 + 328) == (401 + 3411))) then
				if (((18751 - 14028) >= (7866 - 5548)) and v85.BladeFlurry:IsReady()) then
					if (((v94 >= ((5 - 3) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) or ((5093 - 3066) > (1015 + 1837))) then
						if (v12(v85.BladeFlurry) or ((4376 - 3240) > (14879 - 10562))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((3581 + 1167) == (12142 - 7394)) and v85.BladeFlurry:IsReady()) then
					if (((4424 - (364 + 324)) <= (12994 - 8254)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (6 - 3)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (2 + 3)))) then
						if (v12(v85.BladeFlurry) or ((14184 - 10794) <= (4900 - 1840))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v85.RolltheBones:IsReady() or ((3033 - 2034) > (3961 - (1249 + 19)))) then
					if (((418 + 45) < (2339 - 1738)) and ((v114() and not v16:StealthUp(true, true)) or (v112() == (1086 - (686 + 400))) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (3 + 0)) and v16:HasTier(260 - (73 + 156), 1 + 3)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (818 - (721 + 90))) and ((v85.ShadowDance:CooldownRemains() <= (1 + 2)) or (v85.Vanish:CooldownRemains() <= (9 - 6))) and not v16:StealthUp(true, true)))) then
						if (v12(v85.RolltheBones) or ((2653 - (224 + 246)) < (1112 - 425))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v155 = 3 - 1;
			end
			if (((826 + 3723) == (109 + 4440)) and (v155 == (2 + 0))) then
				v157 = v121();
				if (((9288 - 4616) == (15547 - 10875)) and v157) then
					return v157;
				end
				if ((v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((516 - (203 + 310)) + v22(v16:HasTier(2024 - (1238 + 755), 1 + 3)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (1540 - (709 + 825))))) or ((6758 - 3090) < (574 - 179))) then
					if (v10.Cast(v85.KeepItRolling) or ((5030 - (196 + 668)) == (1796 - 1341))) then
						return "Cast Keep it Rolling";
					end
				end
				v155 = 5 - 2;
			end
			if ((v155 == (838 - (171 + 662))) or ((4542 - (4 + 89)) == (9333 - 6670))) then
				if (v85.BloodFury:IsCastable() or ((1558 + 2719) < (13128 - 10139))) then
					if (v10.Cast(v85.BloodFury, v31) or ((342 + 528) >= (5635 - (35 + 1451)))) then
						return "Cast Blood Fury";
					end
				end
				if (((3665 - (28 + 1425)) < (5176 - (941 + 1052))) and v85.Berserking:IsCastable()) then
					if (((4455 + 191) > (4506 - (822 + 692))) and v10.Cast(v85.Berserking, v31)) then
						return "Cast Berserking";
					end
				end
				if (((2047 - 613) < (1463 + 1643)) and v85.Fireblood:IsCastable()) then
					if (((1083 - (45 + 252)) < (2992 + 31)) and v10.Cast(v85.Fireblood, v31)) then
						return "Cast Fireblood";
					end
				end
				v155 = 3 + 3;
			end
			if (((0 - 0) == v155) or ((2875 - (114 + 319)) < (106 - 32))) then
				v156 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (((5811 - 1276) == (2892 + 1643)) and v156) then
					return "DPS Pot";
				end
				if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (2 - 0))))) or ((6304 - 3295) <= (4068 - (556 + 1407)))) then
					if (((3036 - (741 + 465)) < (4134 - (170 + 295))) and v12(v85.AdrenalineRush, v76)) then
						return "Cast Adrenaline Rush";
					end
				end
				v155 = 1 + 0;
			end
			if ((v155 == (4 + 0)) or ((3520 - 2090) >= (2995 + 617))) then
				if (((1721 + 962) >= (1394 + 1066)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
					local v177 = 1230 - (957 + 273);
					while true do
						if (((0 + 0) == v177) or ((723 + 1081) >= (12479 - 9204))) then
							v157 = v120();
							if (v157 or ((3733 - 2316) > (11084 - 7455))) then
								return v157;
							end
							break;
						end
					end
				end
				if (((23743 - 18948) > (2182 - (389 + 1391))) and v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (63 + 37)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (1 + 5)))) then
					if (((10957 - 6144) > (4516 - (783 + 168))) and v10.Cast(v85.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (((13129 - 9217) == (3848 + 64)) and v85.BladeRush:IsCastable() and (v103 > (315 - (309 + 2))) and not v16:StealthUp(true, true)) then
					if (((8662 - 5841) <= (6036 - (1090 + 122))) and v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v155 = 2 + 3;
			end
			if (((5836 - 4098) <= (1503 + 692)) and (v155 == (1124 - (628 + 490)))) then
				if (((8 + 33) <= (7472 - 4454)) and v85.AncestralCall:IsCastable()) then
					if (((9802 - 7657) <= (4878 - (431 + 343))) and v10.Cast(v85.AncestralCall, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v158 = 0 - 0;
		while true do
			if (((7778 - 5089) < (3828 + 1017)) and ((1 + 0) == v158)) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) or ((4017 - (556 + 1139)) > (2637 - (6 + 9)))) then
					if (v10.Cast(v85.BetweentheEyes) or ((831 + 3703) == (1067 + 1015))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((1740 - (28 + 141)) > (724 + 1143))) then
					if (v10.Press(v85.Dispatch) or ((3275 - 621) >= (2122 + 874))) then
						return "Cast Dispatch";
					end
				end
				v158 = 1319 - (486 + 831);
			end
			if (((10351 - 6373) > (7407 - 5303)) and ((0 + 0) == v158)) then
				if (((9469 - 6474) > (2804 - (668 + 595))) and v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (2 + 0)) and (v16:BuffRemains(v85.BladeFlurry) <= v16:GCD()) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
					if (((656 + 2593) > (2598 - 1645)) and v71) then
						v10.Cast(v85.BladeFlurry);
					elseif (v10.Cast(v85.BladeFlurry) or ((3563 - (23 + 267)) > (6517 - (1129 + 815)))) then
						return "Cast Blade Flurry";
					end
				end
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((3538 - (371 + 16)) < (3034 - (1326 + 424)))) then
					if (v10.Cast(v85.ColdBlood) or ((3503 - 1653) == (5587 - 4058))) then
						return "Cast Cold Blood";
					end
				end
				v158 = 119 - (88 + 30);
			end
			if (((1592 - (720 + 51)) < (4722 - 2599)) and (v158 == (1778 - (421 + 1355)))) then
				if (((1487 - 585) < (1143 + 1182)) and v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (1085 - (286 + 797))) and (v16:BuffStack(v85.Opportunity) >= (21 - 15)) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 - 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) then
					if (((1297 - (397 + 42)) <= (926 + 2036)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) or ((4746 - (24 + 776)) < (1984 - 696))) then
					if (v10.Press(v85.Ambush) or ((4027 - (222 + 563)) == (1248 - 681))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (192 - (23 + 167))) or ((2645 - (690 + 1108)) >= (456 + 807))) then
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((1859 + 394) == (2699 - (40 + 808)))) then
					if (v10.Cast(v85.ColdBlood, v56) or ((344 + 1743) > (9070 - 6698))) then
						return "Cast Cold Blood";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) or ((4249 + 196) < (2195 + 1954))) then
					if (v10.Press(v85.Dispatch) or ((997 + 821) == (656 - (47 + 524)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((409 + 221) < (5814 - 3687)) and (v159 == (0 - 0))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (8 - 4)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(1756 - (1165 + 561), 1 + 3)) and v16:BuffDown(v85.GreenskinsWickers)) or ((6002 - 4064) == (960 + 1554))) then
					if (((4734 - (341 + 138)) >= (15 + 40)) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((6188 - 3189) > (1482 - (89 + 237))) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (144 - 99)) and (v85.ShadowDance:CooldownRemains() > (24 - 12))) then
					if (((3231 - (581 + 300)) > (2375 - (855 + 365))) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v159 = 2 - 1;
			end
			if (((1316 + 2713) <= (6088 - (1030 + 205))) and (v159 == (1 + 0))) then
				if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 + 0))) and (v16:BuffRemains(v85.SliceandDice) < (((287 - (156 + 130)) + v98) * (2.8 - 1)))) or ((869 - 353) > (7032 - 3598))) then
					if (((1067 + 2979) >= (1769 + 1264)) and v10.Press(v85.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((2788 - (10 + 59)) <= (410 + 1037))) then
					if (v10.Cast(v85.KillingSpree) or ((20359 - 16225) < (5089 - (671 + 492)))) then
						return "Cast Killing Spree";
					end
				end
				v159 = 2 + 0;
			end
		end
	end
	local function v125()
		local v160 = 1215 - (369 + 846);
		while true do
			if (((0 + 0) == v160) or ((140 + 24) >= (4730 - (1036 + 909)))) then
				if ((v29 and v85.EchoingReprimand:IsReady()) or ((418 + 107) == (3540 - 1431))) then
					if (((236 - (11 + 192)) == (17 + 16)) and v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((3229 - (135 + 40)) <= (9727 - 5712)) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
					if (((1128 + 743) < (7450 - 4068)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v160 = 1 - 0;
			end
			if (((1469 - (50 + 126)) <= (6031 - 3865)) and (v160 == (1 + 0))) then
				if ((v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((3992 - (1233 + 180)) < (1092 - (522 + 447)))) then
					if (v10.Press(v85.PistolShot) or ((2267 - (107 + 1314)) >= (1099 + 1269))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (18 - 12)) or (v16:BuffRemains(v85.Opportunity) < (1 + 1)))) or ((7966 - 3954) <= (13286 - 9928))) then
					if (((3404 - (716 + 1194)) <= (52 + 2953)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v160 = 1 + 1;
			end
			if ((v160 == (505 - (74 + 429))) or ((6001 - 2890) == (1058 + 1076))) then
				if (((5390 - 3035) == (1667 + 688)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((2 - 1) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (2 - 1))))) or (v98 <= (434 - (279 + 154))))) then
					if (v10.Cast(v85.PistolShot, nil, not v17:IsSpellInRange(v85.PistolShot)) or ((1366 - (454 + 324)) <= (340 + 92))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((4814 - (12 + 5)) >= (2101 + 1794)) and not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (2.5 - 1)) or (v99 <= (1 + 0 + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) then
					if (((4670 - (277 + 816)) == (15284 - 11707)) and v10.Cast(v85.PistolShot, nil, not v17:IsSpellInRange(v85.PistolShot))) then
						return "Cast Pistol Shot";
					end
				end
				v160 = 1186 - (1058 + 125);
			end
			if (((712 + 3082) > (4668 - (815 + 160))) and (v160 == (12 - 9))) then
				if ((v85.SinisterStrike:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) or ((3026 - 1751) == (979 + 3121))) then
					if (v10.Press(v85.SinisterStrike) or ((4650 - 3059) >= (5478 - (41 + 1857)))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v161 = 1893 - (1222 + 671);
		while true do
			if (((2540 - 1557) <= (2598 - 790)) and (v161 == (1183 - (229 + 953)))) then
				v29 = EpicSettings.Toggles['cds'];
				v98 = v16:ComboPoints();
				v97 = v84.EffectiveComboPoints(v98);
				v161 = 1776 - (1111 + 663);
			end
			if ((v161 == (1586 - (874 + 705))) or ((301 + 1849) <= (817 + 380))) then
				if (((7833 - 4064) >= (34 + 1139)) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
					local v178 = 679 - (642 + 37);
					while true do
						if (((339 + 1146) == (238 + 1247)) and (v178 == (0 - 0))) then
							v95 = v84.Stealth(v85.Stealth2, nil);
							if (v95 or ((3769 - (233 + 221)) <= (6432 - 3650))) then
								return "Stealth (OOC): " .. v95;
							end
							break;
						end
					end
				end
				if ((not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1 + 0)) and v17:IsInRange(1549 - (718 + 823)) and v27) or ((552 + 324) >= (3769 - (266 + 539)))) then
					if ((v83.TargetIsValid() and v17:IsInRange(28 - 18) and not (v16:IsChanneling() or v16:IsCasting())) or ((3457 - (636 + 589)) > (5927 - 3430))) then
						if ((v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((4351 - 2241) <= (264 + 68))) then
							if (((1340 + 2346) > (4187 - (657 + 358))) and v12(v85.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v16:StealthUp(true, false) or ((11845 - 7371) < (1868 - 1048))) then
							local v187 = 1187 - (1151 + 36);
							while true do
								if (((4133 + 146) >= (758 + 2124)) and (v187 == (0 - 0))) then
									v95 = v84.Stealth(v84.StealthSpell());
									if (v95 or ((3861 - (1552 + 280)) >= (4355 - (64 + 770)))) then
										return v95;
									end
									break;
								end
							end
						end
						if (v83.TargetIsValid() or ((1384 + 653) >= (10537 - 5895))) then
							local v188 = 0 + 0;
							while true do
								if (((2963 - (157 + 1086)) < (8923 - 4465)) and (v188 == (0 - 0))) then
									if ((v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (0 - 0)) or v114())) or ((594 - 158) > (3840 - (599 + 220)))) then
										if (((1419 - 706) <= (2778 - (1813 + 118))) and v10.Cast(v85.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if (((1575 + 579) <= (5248 - (841 + 376))) and v85.AdrenalineRush:IsReady() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (2 - 0))) then
										if (((1073 + 3542) == (12596 - 7981)) and v10.Cast(v85.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									v188 = 860 - (464 + 395);
								end
								if ((v188 == (2 - 1)) or ((1821 + 1969) == (1337 - (467 + 370)))) then
									if (((183 - 94) < (163 + 58)) and v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((3 - 2) + v98) * (1.8 + 0)))) then
										if (((4778 - 2724) >= (1941 - (150 + 370))) and v10.Press(v85.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (((1974 - (74 + 1208)) < (7521 - 4463)) and v16:StealthUp(true, false)) then
										local v196 = 0 - 0;
										while true do
											if ((v196 == (1 + 0)) or ((3644 - (14 + 376)) == (2870 - 1215))) then
												if ((v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) or ((839 + 457) == (4314 + 596))) then
													if (((3213 + 155) == (9868 - 6500)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (((1989 + 654) < (3893 - (23 + 55))) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) then
													if (((4533 - 2620) > (329 + 164)) and v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((4270 + 485) > (5314 - 1886)) and v85.SinisterStrike:IsCastable()) then
													if (((435 + 946) <= (3270 - (652 + 249))) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
												break;
											end
											if ((v196 == (0 - 0)) or ((6711 - (708 + 1160)) == (11085 - 7001))) then
												v95 = v123();
												if (((8512 - 3843) > (390 - (10 + 17))) and v95) then
													return "Stealth (Opener): " .. v95;
												end
												v196 = 1 + 0;
											end
										end
									elseif (v115() or ((3609 - (1400 + 332)) >= (6018 - 2880))) then
										v95 = v124();
										if (((6650 - (242 + 1666)) >= (1552 + 2074)) and v95) then
											return "Finish (Opener): " .. v95;
										end
									end
									v188 = 1 + 1;
								end
								if ((v188 == (2 + 0)) or ((5480 - (850 + 90)) == (1603 - 687))) then
									if (v85.SinisterStrike:IsCastable() or ((2546 - (360 + 1030)) > (3846 + 499))) then
										if (((6313 - 4076) < (5845 - 1596)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
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
				if ((v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) or ((4344 - (909 + 752)) < (1246 - (109 + 1114)))) then
					v98 = v26(v98, v84.FanTheHammerCP());
				end
				v161 = 14 - 6;
			end
			if (((272 + 425) <= (1068 - (6 + 236))) and (v161 == (6 + 2))) then
				if (((890 + 215) <= (2773 - 1597)) and v83.TargetIsValid()) then
					v95 = v122();
					if (((5901 - 2522) <= (4945 - (1076 + 57))) and v95) then
						return "CDs: " .. v95;
					end
					if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((130 + 658) >= (2305 - (579 + 110)))) then
						v95 = v123();
						if (((147 + 1707) <= (2988 + 391)) and v95) then
							return "Stealth: " .. v95;
						end
					end
					if (((2415 + 2134) == (4956 - (174 + 233))) and v115()) then
						v95 = v124();
						if (v95 or ((8441 - 5419) >= (5307 - 2283))) then
							return "Finish: " .. v95;
						end
					end
					v95 = v125();
					if (((2144 + 2676) > (3372 - (663 + 511))) and v95) then
						return "Build: " .. v95;
					end
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (14 + 1 + v101))) or ((231 + 830) >= (15078 - 10187))) then
						if (((826 + 538) <= (10530 - 6057)) and v10.Cast(v85.ArcaneTorrent, v31)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) or ((8702 - 5107) <= (2 + 1))) then
						if (v10.Cast(v85.ArcanePulse) or ((9093 - 4421) == (2746 + 1106))) then
							return "Cast Arcane Pulse";
						end
					end
					if (((143 + 1416) == (2281 - (478 + 244))) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(522 - (440 + 77))) then
						if (v10.Cast(v85.LightsJudgment, v31) or ((797 + 955) <= (2883 - 2095))) then
							return "Cast Lights Judgment";
						end
					end
					if ((v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(1561 - (655 + 901))) or ((725 + 3182) == (136 + 41))) then
						if (((2344 + 1126) > (2235 - 1680)) and v10.Cast(v85.BagofTricks, v31)) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (1470 - (695 + 750))) and ((v99 >= (3 - 2)) or (v103 <= (1.2 - 0)))) or ((3909 - 2937) == (996 - (285 + 66)))) then
						if (((7416 - 4234) >= (3425 - (682 + 628))) and v10.Cast(v85.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((628 + 3265) < (4728 - (176 + 123))) and v85.SinisterStrike:IsCastable()) then
						if (v10.Cast(v85.SinisterStrike) or ((1200 + 1667) < (1382 + 523))) then
							return "Cast Sinister Strike Filler";
						end
					end
				end
				break;
			end
			if (((269 - (239 + 30)) == v161) or ((489 + 1307) >= (3894 + 157))) then
				v82();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v161 = 1 - 0;
			end
			if (((5050 - 3431) <= (4071 - (306 + 9))) and (v161 == (6 - 4))) then
				v99 = v16:ComboPointsDeficit();
				v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(9 + 41)) or (0 + 0);
				v100 = v109();
				v161 = 2 + 1;
			end
			if (((1726 - 1122) == (1979 - (1140 + 235))) and (v161 == (3 + 1))) then
				if (v28 or ((4112 + 372) == (231 + 669))) then
					local v179 = 52 - (33 + 19);
					while true do
						if ((v179 == (0 + 0)) or ((13364 - 8905) <= (491 + 622))) then
							v92 = v16:GetEnemiesInRange(58 - 28);
							v93 = v16:GetEnemiesInRange(v96);
							v179 = 1 + 0;
						end
						if (((4321 - (586 + 103)) > (310 + 3088)) and ((2 - 1) == v179)) then
							v94 = #v93;
							break;
						end
					end
				else
					v94 = 1489 - (1309 + 179);
				end
				v95 = v84.CrimsonVial();
				if (((7368 - 3286) <= (2141 + 2776)) and v95) then
					return v95;
				end
				v161 = 13 - 8;
			end
			if (((3650 + 1182) >= (2944 - 1558)) and (v161 == (5 - 2))) then
				v101 = v16:EnergyRegen();
				v103 = v108(v104);
				v102 = v16:EnergyDeficitPredicted(nil, v104);
				v161 = 613 - (295 + 314);
			end
			if (((336 - 199) == (2099 - (1300 + 662))) and (v161 == (15 - 10))) then
				v84.Poisons();
				if ((v33 and (v16:HealthPercentage() <= v35)) or ((3325 - (1178 + 577)) >= (2250 + 2082))) then
					if ((v34 == "Refreshing Healing Potion") or ((12014 - 7950) <= (3224 - (851 + 554)))) then
						if (v86.RefreshingHealingPotion:IsReady() or ((4410 + 576) < (4364 - 2790))) then
							if (((9612 - 5186) > (474 - (115 + 187))) and v10.Press(v87.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((449 + 137) > (431 + 24)) and (v34 == "Dreamwalker's Healing Potion")) then
						if (((3254 - 2428) == (1987 - (160 + 1001))) and v86.DreamwalkersHealingPotion:IsReady()) then
							if (v10.Press(v87.RefreshingHealingPotion) or ((3516 + 503) > (3065 + 1376))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((4128 - 2111) < (4619 - (237 + 121))) and v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) then
					if (((5613 - (525 + 372)) > (151 - 71)) and v10.Cast(v85.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v161 = 19 - 13;
			end
			if ((v161 == (148 - (96 + 46))) or ((4284 - (643 + 134)) == (1182 + 2090))) then
				if ((v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) or ((2100 - 1224) >= (11416 - 8341))) then
					if (((4174 + 178) > (5011 - 2457)) and v10.Cast(v85.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v16:IsCasting() and not v16:IsChanneling()) or ((9006 - 4600) < (4762 - (316 + 403)))) then
					local v180 = v83.Interrupt(v85.Kick, 6 + 2, true);
					if (v180 or ((5193 - 3304) >= (1223 + 2160))) then
						return v180;
					end
					v180 = v83.Interrupt(v85.Kick, 20 - 12, true, v13, v87.KickMouseover);
					if (((1341 + 551) <= (882 + 1852)) and v180) then
						return v180;
					end
					v180 = v83.Interrupt(v85.Blind, 51 - 36, v80);
					if (((9183 - 7260) < (4607 - 2389)) and v180) then
						return v180;
					end
					v180 = v83.Interrupt(v85.Blind, 1 + 14, v80, v13, v87.BlindMouseover);
					if (((4277 - 2104) > (19 + 360)) and v180) then
						return v180;
					end
					v180 = v83.InterruptWithStun(v85.CheapShot, 23 - 15, v16:StealthUp(false, false));
					if (v180 or ((2608 - (12 + 5)) == (13240 - 9831))) then
						return v180;
					end
					v180 = v83.InterruptWithStun(v85.KidneyShot, 16 - 8, v16:ComboPoints() > (0 - 0));
					if (((11193 - 6679) > (675 + 2649)) and v180) then
						return v180;
					end
				end
				if (v30 or ((2181 - (1656 + 317)) >= (4303 + 525))) then
					v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 25 + 5, true);
					if (v95 or ((4209 - 2626) > (17555 - 13988))) then
						return v95;
					end
				end
				v161 = 361 - (5 + 349);
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1234 - 974, v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

