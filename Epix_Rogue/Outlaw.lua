local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2205 + 631) > (1238 - 744)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((4360 - (1607 + 27)) == (1114 + 2755))) then
			v6 = v0[v4];
			if (not v6 or ((6102 - (1668 + 58)) <= (2107 - (512 + 114)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
			if ((v128 == (10 - 7)) or ((1578 + 1814) >= (888 + 3853))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v128 = 13 - 9;
			end
			if (((5319 - (109 + 1885)) >= (3623 - (1269 + 200))) and ((3 - 1) == v128)) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (815 - (98 + 717));
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 829 - (802 + 24);
			end
			if ((v128 == (0 - 0)) or ((1635 - 340) >= (478 + 2755))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v128 = 1 + 0;
			end
			if (((945 + 3432) > (4567 - 2925)) and (v128 == (19 - 13))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v79 = EpicSettings.Settings['sepsis'];
				v128 = 3 + 4;
			end
			if (((1923 + 2800) > (1119 + 237)) and (v128 == (1 + 0))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v128 = 1435 - (797 + 636);
			end
			if ((v128 == (33 - 26)) or ((5755 - (1427 + 192)) <= (1190 + 2243))) then
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if (((3816 + 429) <= (2099 + 2532)) and (v128 == (330 - (192 + 134)))) then
				v59 = EpicSettings.Settings['FeintHP'] or (1276 - (316 + 960));
				v60 = EpicSettings.Settings['StealthOOC'];
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v128 = 3 + 2;
			end
			if (((3300 + 976) >= (3618 + 296)) and (v128 == (18 - 13))) then
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 557 - (83 + 468);
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
	local v90 = (v89[1819 - (1202 + 604)] and v20(v89[60 - 47])) or v20(0 - 0);
	local v91 = (v89[38 - 24] and v20(v89[339 - (45 + 280)])) or v20(0 + 0);
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if (((73 + 125) <= (2416 + 1949)) and (v129 == (0 + 0))) then
				v89 = v16:GetEquipment();
				v90 = (v89[23 - 10] and v20(v89[1924 - (340 + 1571)])) or v20(0 + 0);
				v129 = 1773 - (1733 + 39);
			end
			if (((13140 - 8358) > (5710 - (125 + 909))) and (v129 == (1949 - (1096 + 852)))) then
				v91 = (v89[7 + 7] and v20(v89[19 - 5])) or v20(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 518 - (409 + 103);
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 - 0);
	end}};
	local v106, v107 = 1905 - (830 + 1075), 524 - (303 + 221);
	local function v108(v130)
		local v131 = v16:EnergyTimeToMaxPredicted(nil, v130);
		if (((6133 - (231 + 1038)) > (1831 + 366)) and ((v131 < v106) or ((v131 - v106) > (1162.5 - (171 + 991))))) then
			v106 = v131;
		end
		return v106;
	end
	local function v109()
		local v132 = 0 - 0;
		local v133;
		while true do
			if ((v132 == (2 - 1)) or ((9233 - 5533) == (2007 + 500))) then
				return v107;
			end
			if (((15682 - 11208) >= (790 - 516)) and ((0 - 0) == v132)) then
				v133 = v16:EnergyPredicted();
				if ((v133 > v107) or ((v133 - v107) > (27 - 18)) or ((3142 - (111 + 1137)) <= (1564 - (91 + 67)))) then
					v107 = v133;
				end
				v132 = 2 - 1;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		local v134 = 0 - 0;
		while true do
			if (((3501 - 1929) >= (3573 - 2042)) and (v134 == (711 - (530 + 181)))) then
				if (not v11.APLVar.RtB_Buffs or ((5568 - (614 + 267)) < (4574 - (19 + 13)))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Normal = 0 - 0;
					v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v11.APLVar.RtB_Buffs.Longer = 0 - 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
					local v179 = v84.RtBRemains();
					for v183 = 1813 - (1293 + 519), #v110 do
						local v184 = v16:BuffRemains(v110[v183]);
						if (((6714 - 3423) > (4352 - 2685)) and (v184 > (0 - 0))) then
							local v189 = 0 - 0;
							local v190;
							while true do
								if ((v189 == (0 - 0)) or ((463 + 410) == (415 + 1619))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (2 - 1);
									if ((v184 > v11.APLVar.RtB_Buffs.MaxRemains) or ((651 + 2165) < (4 + 7))) then
										v11.APLVar.RtB_Buffs.MaxRemains = v184;
									end
									v189 = 1 + 0;
								end
								if (((4795 - (709 + 387)) < (6564 - (673 + 1185))) and (v189 == (2 - 1))) then
									v190 = math.abs(v184 - v179);
									if (((8496 - 5850) >= (1440 - 564)) and (v190 <= (0.5 + 0))) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v183]:Name()] = true;
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1 - 0);
									elseif (((151 + 463) <= (6348 - 3164)) and (v184 > v179)) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (1 - 0);
									else
										local v202 = 1880 - (446 + 1434);
										while true do
											if (((4409 - (1040 + 243)) == (9329 - 6203)) and (v202 == (1848 - (559 + 1288)))) then
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (1932 - (609 + 1322));
												break;
											end
											if ((v202 == (454 - (13 + 441))) or ((8172 - 5985) >= (12976 - 8022))) then
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (4 - 3);
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v183]:Name()] = true;
												v202 = 1 + 0;
											end
										end
									end
									break;
								end
							end
						end
						if (v111 or ((14080 - 10203) == (1270 + 2305))) then
							print("RtbRemains", v179);
							print(v110[v183]:Name(), v184);
						end
					end
					if (((310 + 397) > (1875 - 1243)) and v111) then
						local v186 = 0 + 0;
						while true do
							if ((v186 == (1 - 0)) or ((361 + 185) >= (1493 + 1191))) then
								print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v11.APLVar.RtB_Buffs.Normal);
								v186 = 2 + 0;
							end
							if (((1231 + 234) <= (4209 + 92)) and (v186 == (435 - (153 + 280)))) then
								print("longer: ", v11.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if (((4920 - 3216) > (1280 + 145)) and (v186 == (0 + 0))) then
								print("have: ", v11.APLVar.RtB_Buffs.Total);
								print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
								v186 = 1 + 0;
							end
						end
					end
				end
				return v11.APLVar.RtB_Buffs.Total;
			end
		end
	end
	local function v113(v135)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v135] and true) or false;
	end
	local function v114()
		if (not v11.APLVar.RtB_Reroll or ((624 + 63) == (3068 + 1166))) then
			if ((v65 == "1+ Buff") or ((5070 - 1740) < (884 + 545))) then
				v11.APLVar.RtB_Reroll = ((v112() <= (667 - (89 + 578))) and true) or false;
			elseif (((820 + 327) >= (696 - 361)) and (v65 == "Broadside")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
			elseif (((4484 - (572 + 477)) > (283 + 1814)) and (v65 == "Buried Treasure")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
			elseif ((v65 == "Grand Melee") or ((2263 + 1507) >= (483 + 3558))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
			elseif ((v65 == "Skull and Crossbones") or ((3877 - (84 + 2)) <= (2654 - 1043))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
			elseif ((v65 == "Ruthless Precision") or ((3299 + 1279) <= (2850 - (497 + 345)))) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
			elseif (((29 + 1096) <= (351 + 1725)) and (v65 == "True Bearing")) then
				v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
			else
				local v204 = 1333 - (605 + 728);
				while true do
					if ((v204 == (2 + 0)) or ((1651 - 908) >= (202 + 4197))) then
						if (((4270 - 3115) < (1509 + 164)) and v85.Crackshot:IsAvailable() and v16:HasTier(85 - 54, 4 + 0)) then
							v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((490 - (457 + 32)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
						end
						if ((not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < (1 + 1 + v22(v113(v85.GrandMelee)))) and (v94 < (1404 - (832 + 570)))) or ((2190 + 134) <= (151 + 427))) then
							v11.APLVar.RtB_Reroll = true;
						end
						v204 = 10 - 7;
					end
					if (((1815 + 1952) == (4563 - (588 + 208))) and (v204 == (8 - 5))) then
						v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (1800 - (884 + 916))) or ((v11.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (659 - (232 + 421))) and (v11.APLVar.RtB_Buffs.MaxRemains <= (1928 - (1569 + 320))) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
						if (((1004 + 3085) == (777 + 3312)) and (v17:FilteredTimeToDie("<", 40 - 28) or v10.BossFilteredFightRemains("<", 617 - (316 + 289)))) then
							v11.APLVar.RtB_Reroll = false;
						end
						break;
					end
					if (((11669 - 7211) >= (78 + 1596)) and (v204 == (1453 - (666 + 787)))) then
						v11.APLVar.RtB_Reroll = false;
						v112();
						v204 = 426 - (360 + 65);
					end
					if (((909 + 63) <= (1672 - (79 + 175))) and (v204 == (1 - 0))) then
						v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (2 + 0))));
						if ((v85.Crackshot:IsAvailable() and not v16:HasTier(94 - 63, 7 - 3)) or ((5837 - (503 + 396)) < (4943 - (92 + 89)))) then
							v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 - 0)));
						end
						v204 = 2 + 0;
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
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((7 - 5) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (7 + 43));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (4 - 2)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		if ((v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (6 + 0))) and v116()) or ((1196 + 1308) > (12986 - 8722))) then
			if (((269 + 1884) == (3283 - 1130)) and v10.Cast(v85.Vanish, v68)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) or ((1751 - (485 + 759)) >= (5995 - 3404))) then
			if (((5670 - (442 + 747)) == (5616 - (832 + 303))) and v10.Cast(v85.Vanish, v68)) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (952 - (88 + 858))) or not v68) and not v16:StealthUp(true, false)) or ((710 + 1618) < (574 + 119))) then
			if (((179 + 4149) == (5117 - (766 + 23))) and v10.Cast(v85.ShadowDance, v54)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((7839 - 6251) >= (1821 - 489)) and v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) then
			if (v12(v85.ShadowDance, v54) or ((10996 - 6822) > (14417 - 10169))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (1103 - (1036 + 37))) or ((v85.KeepItRolling:CooldownRemains() >= (86 + 34)) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((8930 - 4344) <= (65 + 17))) then
			if (((5343 - (641 + 839)) == (4776 - (910 + 3))) and v10.Cast(v85.ShadowDance, v54)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) or ((718 - 436) <= (1726 - (1466 + 218)))) then
			if (((2119 + 2490) >= (1914 - (556 + 592))) and ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())))) then
				if (v10.Cast(v85.Shadowmeld, v31) or ((410 + 742) == (3296 - (329 + 479)))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v121()
		local v136 = v83.HandleTopTrinket(v88, v29, 894 - (174 + 680), nil);
		if (((11758 - 8336) > (6943 - 3593)) and v136) then
			return v136;
		end
		local v136 = v83.HandleBottomTrinket(v88, v29, 29 + 11, nil);
		if (((1616 - (396 + 343)) > (34 + 342)) and v136) then
			return v136;
		end
	end
	local function v122()
		local v137 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
		if (v137 or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
			return "DPS Pot";
		end
		if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (7 - 5))))) or ((770 - 605) >= (2328 + 1164))) then
			if (((5476 - (389 + 1138)) < (5430 - (102 + 472))) and v12(v85.AdrenalineRush, v76)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (v85.BladeFlurry:IsReady() or ((4036 + 240) < (1673 + 1343))) then
			if (((4374 + 316) > (5670 - (320 + 1225))) and (v94 >= ((2 - 0) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) then
				if (v12(v85.BladeFlurry) or ((31 + 19) >= (2360 - (157 + 1307)))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v85.BladeFlurry:IsReady() or ((3573 - (821 + 1038)) >= (7380 - 4422))) then
			if ((v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (1 + 2)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (8 - 3)))) or ((555 + 936) < (1596 - 952))) then
				if (((1730 - (834 + 192)) < (63 + 924)) and v12(v85.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((955 + 2763) > (41 + 1865)) and v85.RolltheBones:IsReady()) then
			if (v114() or (v112() == (0 - 0)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (307 - (300 + 4))) and v16:HasTier(9 + 22, 10 - 6)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (369 - (112 + 250))) and ((v85.ShadowDance:CooldownRemains() <= (2 + 1)) or (v85.Vanish:CooldownRemains() <= (7 - 4)))) or ((549 + 409) > (1880 + 1755))) then
				if (((2619 + 882) <= (2228 + 2264)) and v12(v85.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v138 = v121();
		if (v138 or ((2557 + 885) < (3962 - (1001 + 413)))) then
			return v138;
		end
		if (((6411 - 3536) >= (2346 - (244 + 638))) and v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((696 - (627 + 66)) + v22(v16:HasTier(92 - 61, 606 - (512 + 90))))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (1912 - (1665 + 241))))) then
			if (v10.Cast(v85.KeepItRolling) or ((5514 - (373 + 344)) >= (2207 + 2686))) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (2 + 5))) or ((1453 - 902) > (3499 - 1431))) then
			if (((3213 - (35 + 1064)) > (687 + 257)) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((4839 - 2577) >= (13 + 3083))) then
			if ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 1247 - (298 + 938)) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1270 - (233 + 1026)) or ((3921 - (636 + 1030)) >= (1809 + 1728))) then
				if (v10.Cast(v85.Sepsis) or ((3748 + 89) < (388 + 918))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((200 + 2750) == (3171 - (55 + 166))) and v85.BladeRush:IsReady() and (v103 > (1 + 3)) and not v16:StealthUp(true, true)) then
			if (v10.Cast(v85.BladeRush) or ((475 + 4248) < (12595 - 9297))) then
				return "Cast Blade Rush";
			end
		end
		if (((1433 - (36 + 261)) >= (269 - 115)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
			local v142 = 1368 - (34 + 1334);
			while true do
				if ((v142 == (0 + 0)) or ((211 + 60) > (6031 - (1035 + 248)))) then
					v138 = v120();
					if (((4761 - (20 + 1)) >= (1643 + 1509)) and v138) then
						return v138;
					end
					break;
				end
			end
		end
		if ((v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (419 - (134 + 185))) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (1139 - (549 + 584))))) or ((3263 - (314 + 371)) >= (11637 - 8247))) then
			if (((1009 - (478 + 490)) <= (880 + 781)) and v10.Cast(v85.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((1773 - (786 + 386)) < (11530 - 7970)) and v85.BladeRush:IsCastable() and (v103 > (1383 - (1055 + 324))) and not v16:StealthUp(true, true)) then
			if (((1575 - (1093 + 247)) < (611 + 76)) and v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (((479 + 4070) > (4577 - 3424)) and v85.BloodFury:IsCastable()) then
			if (v10.Cast(v85.BloodFury, v31) or ((15862 - 11188) < (13294 - 8622))) then
				return "Cast Blood Fury";
			end
		end
		if (((9217 - 5549) < (1623 + 2938)) and v85.Berserking:IsCastable()) then
			if (v10.Cast(v85.Berserking, v31) or ((1752 - 1297) == (12425 - 8820))) then
				return "Cast Berserking";
			end
		end
		if (v85.Fireblood:IsCastable() or ((2008 + 655) == (8469 - 5157))) then
			if (((4965 - (364 + 324)) <= (12267 - 7792)) and v10.Cast(v85.Fireblood, v31)) then
				return "Cast Fireblood";
			end
		end
		if (v85.AncestralCall:IsCastable() or ((2087 - 1217) == (395 + 794))) then
			if (((6498 - 4945) <= (5017 - 1884)) and v10.Cast(v85.AncestralCall, v31)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v123()
		if ((v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (5 - 3)) and (v16:BuffRemains(v85.BladeFlurry) <= v16:GCD()) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((3505 - (1249 + 19)) >= (3170 + 341))) then
			if (v71 or ((5153 - 3829) > (4106 - (686 + 400)))) then
				v10.Cast(v85.BladeFlurry);
			elseif (v10.Cast(v85.BladeFlurry) or ((2348 + 644) == (2110 - (73 + 156)))) then
				return "Cast Blade Flurry";
			end
		end
		if (((15 + 3091) > (2337 - (721 + 90))) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
			if (((34 + 2989) < (12565 - 8695)) and v10.Cast(v85.ColdBlood, v56)) then
				return "Cast Cold Blood";
			end
		end
		if (((613 - (224 + 246)) > (119 - 45)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) then
			if (((32 - 14) < (384 + 1728)) and v10.Cast(v85.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((27 + 1070) <= (1196 + 432)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) then
			if (((9205 - 4575) == (15407 - 10777)) and v10.Press(v85.Dispatch)) then
				return "Cast Dispatch";
			end
		end
		if (((4053 - (203 + 310)) > (4676 - (1238 + 755))) and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (1 + 1)) and (v16:BuffStack(v85.Opportunity) >= (1540 - (709 + 825))) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 - 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) then
			if (((6983 - 2189) >= (4139 - (196 + 668))) and v10.Press(v85.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((5859 - 4375) == (3073 - 1589)) and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) then
			if (((2265 - (171 + 662)) < (3648 - (4 + 89))) and v10.Cast(v85.SinisterStrike, nil, not v17:IsSpellInRange(v85.Ambush))) then
				return "Cast Ambush (SS High-Prio Buffed)";
			end
		end
		if ((v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) or ((3732 - 2667) > (1303 + 2275))) then
			if (v10.Press(v85.Ambush) or ((21060 - 16265) < (552 + 855))) then
				return "Cast Ambush";
			end
		end
	end
	local function v124()
		if (((3339 - (35 + 1451)) < (6266 - (28 + 1425))) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (1997 - (941 + 1052))) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(29 + 1, 1518 - (822 + 692))) and v16:BuffDown(v85.GreenskinsWickers)) then
			if (v10.Press(v85.BetweentheEyes) or ((4027 - 1206) < (1146 + 1285))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (342 - (45 + 252))) and (v85.ShadowDance:CooldownRemains() > (12 + 0))) or ((990 + 1884) < (5307 - 3126))) then
			if (v10.Press(v85.BetweentheEyes) or ((3122 - (114 + 319)) <= (491 - 148))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 - 0))) and (v16:BuffRemains(v85.SliceandDice) < ((1 + 0 + v98) * (1.8 - 0)))) or ((3915 - 2046) == (3972 - (556 + 1407)))) then
			if (v10.Press(v85.SliceandDice) or ((4752 - (741 + 465)) < (2787 - (170 + 295)))) then
				return "Cast Slice and Dice";
			end
		end
		if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((1097 + 985) == (4385 + 388))) then
			if (((7986 - 4742) > (875 + 180)) and v10.Cast(v85.KillingSpree)) then
				return "Cast Killing Spree";
			end
		end
		if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((2125 + 1188) <= (1007 + 771))) then
			if (v10.Cast(v85.ColdBlood, v56) or ((2651 - (957 + 273)) >= (563 + 1541))) then
				return "Cast Cold Blood";
			end
		end
		if (((726 + 1086) <= (12380 - 9131)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
			if (((4276 - 2653) <= (5977 - 4020)) and v10.Press(v85.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v125()
		local v139 = 0 - 0;
		while true do
			if (((6192 - (389 + 1391)) == (2769 + 1643)) and (v139 == (1 + 0))) then
				if (((3984 - 2234) >= (1793 - (783 + 168))) and v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) then
					if (((14673 - 10301) > (1820 + 30)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((543 - (309 + 2)) < (2521 - 1700)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (1218 - (1090 + 122))) or (v16:BuffRemains(v85.Opportunity) < (1 + 1)))) then
					if (((1739 - 1221) < (618 + 284)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v139 = 1120 - (628 + 490);
			end
			if (((537 + 2457) > (2124 - 1266)) and (v139 == (13 - 10))) then
				if (v85.SinisterStrike:IsCastable() or ((4529 - (431 + 343)) <= (1847 - 932))) then
					if (((11415 - 7469) > (2957 + 786)) and v10.Press(v85.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v139 == (0 + 0)) or ((3030 - (556 + 1139)) >= (3321 - (6 + 9)))) then
				if (((887 + 3957) > (1155 + 1098)) and v29 and v85.EchoingReprimand:IsReady()) then
					if (((621 - (28 + 141)) == (176 + 276)) and v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((5624 - 1067) < (1479 + 608))) then
					if (((5191 - (486 + 831)) == (10081 - 6207)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v139 = 3 - 2;
			end
			if ((v139 == (1 + 1)) or ((6127 - 4189) > (6198 - (668 + 595)))) then
				if ((v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= (1 + 0 + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + 1 + 0)))) or (v98 <= (2 - 1)))) or ((4545 - (23 + 267)) < (5367 - (1129 + 815)))) then
					if (((1841 - (371 + 16)) <= (4241 - (1326 + 424))) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1.5 - 0)) or (v99 <= ((3 - 2) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) or ((4275 - (88 + 30)) <= (3574 - (720 + 51)))) then
					if (((10795 - 5942) >= (4758 - (421 + 1355))) and v10.Cast(v85.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				v139 = 4 - 1;
			end
		end
	end
	local function v126()
		local v140 = 0 + 0;
		while true do
			if (((5217 - (286 + 797)) > (12271 - 8914)) and ((6 - 2) == v140)) then
				if ((v33 and (v16:HealthPercentage() <= v35)) or ((3856 - (397 + 42)) < (792 + 1742))) then
					if ((v34 == "Refreshing Healing Potion") or ((3522 - (24 + 776)) <= (252 - 88))) then
						if (v86.RefreshingHealingPotion:IsReady() or ((3193 - (222 + 563)) < (4646 - 2537))) then
							if (v10.Press(v87.RefreshingHealingPotion) or ((24 + 9) == (1645 - (23 + 167)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v34 == "Dreamwalker's Healing Potion") or ((2241 - (690 + 1108)) >= (1449 + 2566))) then
						if (((2790 + 592) > (1014 - (40 + 808))) and v86.DreamwalkersHealingPotion:IsReady()) then
							if (v10.Press(v87.RefreshingHealingPotion) or ((47 + 233) == (11697 - 8638))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((1798 + 83) > (685 + 608)) and v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) then
					if (((1293 + 1064) == (2928 - (47 + 524))) and v10.Cast(v85.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((80 + 43) == (336 - 213)) and v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) then
					if (v10.Cast(v85.Evasion) or ((1578 - 522) >= (7735 - 4343))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v16:IsCasting() and not v16:IsChanneling()) or ((2807 - (1165 + 561)) < (32 + 1043))) then
					local v180 = 0 - 0;
					local v181;
					while true do
						if (((0 + 0) == v180) or ((1528 - (341 + 138)) >= (1197 + 3235))) then
							v181 = v83.Interrupt(v85.Kick, 16 - 8, true);
							if (v181 or ((5094 - (89 + 237)) <= (2721 - 1875))) then
								return v181;
							end
							v181 = v83.Interrupt(v85.Kick, 16 - 8, true, v13, v87.KickMouseover);
							v180 = 882 - (581 + 300);
						end
						if ((v180 == (1221 - (855 + 365))) or ((7975 - 4617) <= (464 + 956))) then
							if (v181 or ((4974 - (1030 + 205)) <= (2822 + 183))) then
								return v181;
							end
							v181 = v83.Interrupt(v85.Blind, 14 + 1, v80);
							if (v181 or ((1945 - (156 + 130)) >= (4848 - 2714))) then
								return v181;
							end
							v180 = 2 - 0;
						end
						if ((v180 == (3 - 1)) or ((860 + 2400) < (1374 + 981))) then
							v181 = v83.Interrupt(v85.Blind, 84 - (10 + 59), v80, v13, v87.BlindMouseover);
							if (v181 or ((190 + 479) == (20797 - 16574))) then
								return v181;
							end
							v181 = v83.InterruptWithStun(v85.CheapShot, 1171 - (671 + 492), v16:StealthUp(false, false));
							v180 = 3 + 0;
						end
						if ((v180 == (1218 - (369 + 846))) or ((448 + 1244) < (502 + 86))) then
							if (v181 or ((6742 - (1036 + 909)) < (2903 + 748))) then
								return v181;
							end
							v181 = v83.InterruptWithStun(v85.KidneyShot, 13 - 5, v16:ComboPoints() > (203 - (11 + 192)));
							if (v181 or ((2111 + 2066) > (5025 - (135 + 40)))) then
								return v181;
							end
							break;
						end
					end
				end
				v140 = 11 - 6;
			end
			if ((v140 == (0 + 0)) or ((881 - 481) > (1665 - 554))) then
				v82();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v140 = 177 - (50 + 126);
			end
			if (((8495 - 5444) > (223 + 782)) and (v140 == (1415 - (1233 + 180)))) then
				v100 = v109();
				v101 = v16:EnergyRegen();
				v103 = v108(v104);
				v102 = v16:EnergyDeficitPredicted(nil, v104);
				v140 = 972 - (522 + 447);
			end
			if (((5114 - (107 + 1314)) <= (2034 + 2348)) and ((15 - 10) == v140)) then
				if (v30 or ((1394 + 1888) > (8141 - 4041))) then
					v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 118 - 88, true);
					if (v95 or ((5490 - (716 + 1194)) < (49 + 2795))) then
						return v95;
					end
				end
				if (((10 + 79) < (4993 - (74 + 429))) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
					v95 = v84.Stealth(v85.Stealth2, nil);
					if (v95 or ((9612 - 4629) < (897 + 911))) then
						return "Stealth (OOC): " .. v95;
					end
				end
				if (((8764 - 4935) > (2667 + 1102)) and not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (2 - 1)) and v17:IsInRange(19 - 11) and v27) then
					if (((1918 - (279 + 154)) <= (3682 - (454 + 324))) and v83.TargetIsValid() and v17:IsInRange(8 + 2) and not (v16:IsChanneling() or v16:IsCasting())) then
						local v187 = 17 - (12 + 5);
						while true do
							if (((2302 + 1967) == (10877 - 6608)) and (v187 == (1 + 0))) then
								if (((1480 - (277 + 816)) <= (11887 - 9105)) and v83.TargetIsValid()) then
									local v195 = 1183 - (1058 + 125);
									while true do
										if ((v195 == (1 + 0)) or ((2874 - (815 + 160)) <= (3934 - 3017))) then
											if ((v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((2 - 1) + v98) * (1.8 + 0)))) or ((12604 - 8292) <= (2774 - (41 + 1857)))) then
												if (((4125 - (1222 + 671)) <= (6709 - 4113)) and v10.Press(v85.SliceandDice)) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((3010 - 915) < (4868 - (229 + 953))) and v16:StealthUp(true, false)) then
												local v205 = 1774 - (1111 + 663);
												while true do
													if ((v205 == (1579 - (874 + 705))) or ((224 + 1371) >= (3053 + 1421))) then
														v95 = v123();
														if (v95 or ((9600 - 4981) < (82 + 2800))) then
															return "Stealth (Opener): " .. v95;
														end
														v205 = 680 - (642 + 37);
													end
													if ((v205 == (1 + 0)) or ((48 + 246) >= (12129 - 7298))) then
														if (((2483 - (233 + 221)) <= (7131 - 4047)) and v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) then
															if (v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike)) or ((1793 + 244) == (3961 - (718 + 823)))) then
																return "Cast Ghostly Strike KiR (Opener)";
															end
														end
														if (((2806 + 1652) > (4709 - (266 + 539))) and v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) then
															if (((1234 - 798) >= (1348 - (636 + 589))) and v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush))) then
																return "Cast Ambush (Opener)";
															end
														elseif (((1186 - 686) < (3745 - 1929)) and v85.SinisterStrike:IsCastable()) then
															if (((2833 + 741) == (1299 + 2275)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
																return "Cast Sinister Strike (Opener)";
															end
														end
														break;
													end
												end
											elseif (((1236 - (657 + 358)) < (1032 - 642)) and v115()) then
												v95 = v124();
												if (v95 or ((5041 - 2828) <= (2608 - (1151 + 36)))) then
													return "Finish (Opener): " .. v95;
												end
											end
											v195 = 2 + 0;
										end
										if (((804 + 2254) < (14513 - 9653)) and (v195 == (1834 - (1552 + 280)))) then
											if (v85.SinisterStrike:IsCastable() or ((2130 - (64 + 770)) >= (3019 + 1427))) then
												if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((3162 - 1769) > (798 + 3691))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v195 == (1243 - (157 + 1086))) or ((8854 - 4430) < (118 - 91))) then
											if ((v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (2 - 0))) or ((2725 - 728) > (4634 - (599 + 220)))) then
												if (((6899 - 3434) > (3844 - (1813 + 118))) and v10.Cast(v85.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											if (((536 + 197) < (3036 - (841 + 376))) and v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (0 - 0)) or v114())) then
												if (v10.Cast(v85.RolltheBones) or ((1021 + 3374) == (12978 - 8223))) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											v195 = 860 - (464 + 395);
										end
									end
								end
								return;
							end
							if ((v187 == (0 - 0)) or ((1822 + 1971) < (3206 - (467 + 370)))) then
								if ((v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((8439 - 4355) == (195 + 70))) then
									if (((14939 - 10581) == (680 + 3678)) and v12(v85.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v16:StealthUp(true, false) or ((7300 - 4162) < (1513 - (150 + 370)))) then
									v95 = v84.Stealth(v84.StealthSpell());
									if (((4612 - (74 + 1208)) > (5713 - 3390)) and v95) then
										return v95;
									end
								end
								v187 = 4 - 3;
							end
						end
					end
				end
				if ((v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) or ((2581 + 1045) == (4379 - (14 + 376)))) then
					v98 = v26(v98, v84.FanTheHammerCP());
					v97 = v84.EffectiveComboPoints(v98);
					v99 = v16:ComboPointsDeficit();
				end
				v140 = 10 - 4;
			end
			if (((4 + 2) == v140) or ((805 + 111) == (2548 + 123))) then
				if (((796 - 524) == (205 + 67)) and v83.TargetIsValid()) then
					v95 = v122();
					if (((4327 - (23 + 55)) <= (11467 - 6628)) and v95) then
						return "CDs: " .. v95;
					end
					if (((1854 + 923) < (2874 + 326)) and (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld))) then
						local v188 = 0 - 0;
						while true do
							if (((30 + 65) < (2858 - (652 + 249))) and (v188 == (0 - 0))) then
								v95 = v123();
								if (((2694 - (708 + 1160)) < (4660 - 2943)) and v95) then
									return "Stealth: " .. v95;
								end
								break;
							end
						end
					end
					if (((2599 - 1173) >= (1132 - (10 + 17))) and v115()) then
						v95 = v124();
						if (((619 + 2135) <= (5111 - (1400 + 332))) and v95) then
							return "Finish: " .. v95;
						end
						return "Finish Pooling";
					end
					v95 = v125();
					if (v95 or ((7531 - 3604) == (3321 - (242 + 1666)))) then
						return "Build: " .. v95;
					end
					if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (7 + 8 + v101))) or ((423 + 731) <= (672 + 116))) then
						if (v10.Cast(v85.ArcaneTorrent, v31) or ((2583 - (850 + 90)) > (5917 - 2538))) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) or ((4193 - (360 + 1030)) > (4026 + 523))) then
						if (v10.Cast(v85.ArcanePulse) or ((620 - 400) >= (4157 - 1135))) then
							return "Cast Arcane Pulse";
						end
					end
					if (((4483 - (909 + 752)) == (4045 - (109 + 1114))) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(9 - 4)) then
						if (v10.Cast(v85.LightsJudgment, v31) or ((414 + 647) == (2099 - (6 + 236)))) then
							return "Cast Lights Judgment";
						end
					end
					if (((1739 + 1021) > (1098 + 266)) and v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(11 - 6)) then
						if (v10.Cast(v85.BagofTricks, v31) or ((8562 - 3660) <= (4728 - (1076 + 57)))) then
							return "Cast Bag of Tricks";
						end
					end
					if ((v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (5 + 20)) and ((v99 >= (690 - (579 + 110))) or (v103 <= (1.2 + 0)))) or ((3406 + 446) == (156 + 137))) then
						if (v10.Cast(v85.PistolShot) or ((1966 - (174 + 233)) == (12815 - 8227))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v85.SinisterStrike:IsCastable() or ((7869 - 3385) == (351 + 437))) then
						if (((5742 - (663 + 511)) >= (3486 + 421)) and v10.Cast(v85.SinisterStrike)) then
							return "Cast Sinister Strike Filler";
						end
					end
				end
				break;
			end
			if (((271 + 975) < (10697 - 7227)) and (v140 == (1 + 0))) then
				v98 = v16:ComboPoints();
				v97 = v84.EffectiveComboPoints(v98);
				v99 = v16:ComboPointsDeficit();
				v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(117 - 67)) or (0 - 0);
				v140 = 1 + 1;
			end
			if (((7917 - 3849) >= (693 + 279)) and ((1 + 2) == v140)) then
				if (((1215 - (478 + 244)) < (4410 - (440 + 77))) and v28) then
					local v182 = 0 + 0;
					while true do
						if ((v182 == (0 - 0)) or ((3029 - (655 + 901)) >= (618 + 2714))) then
							v92 = v16:GetEnemiesInRange(23 + 7);
							v93 = v16:GetEnemiesInRange(v96);
							v182 = 1 + 0;
						end
						if ((v182 == (3 - 2)) or ((5496 - (695 + 750)) <= (3950 - 2793))) then
							v94 = #v93;
							break;
						end
					end
				else
					v94 = 1 - 0;
				end
				v95 = v84.CrimsonVial();
				if (((2428 - 1824) < (3232 - (285 + 66))) and v95) then
					return v95;
				end
				v84.Poisons();
				v140 = 8 - 4;
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1570 - (682 + 628), v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

