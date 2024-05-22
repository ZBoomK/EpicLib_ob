local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (88 - (36 + 51))) or ((16717 - 12840) >= (10687 - 6150))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((881 + 3434) < (4009 - 2283))) then
			v6 = v0[v4];
			if (not v6 or ((851 + 2828) < (208 + 417))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		v34 = EpicSettings.Settings['HealingPotionName'];
		v35 = EpicSettings.Settings['HealingPotionHP'] or (1096 - (709 + 387));
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (1858 - (673 + 1185));
		v38 = EpicSettings.Settings['InterruptWithStun'];
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v40 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v30 = EpicSettings.Settings['HandleIncorporeal'];
		v53 = EpicSettings.Settings['VanishOffGCD'];
		v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v56 = EpicSettings.Settings['ColdBloodOffGCD'];
		v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v58 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
		v59 = EpicSettings.Settings['FeintHP'] or (0 - 0);
		v60 = EpicSettings.Settings['StealthOOC'];
		v65 = EpicSettings.Settings['RolltheBonesLogic'];
		v68 = EpicSettings.Settings['UseDPSVanish'];
		v71 = EpicSettings.Settings['BladeFlurryGCD'];
		v72 = EpicSettings.Settings['BladeRushGCD'];
		v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
		v75 = EpicSettings.Settings['KeepItRollingGCD'];
		v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
		v77 = EpicSettings.Settings['EchoingReprimand'];
		v78 = EpicSettings.Settings['UseSoloVanish'];
		v79 = EpicSettings.Settings['sepsis'];
		v80 = EpicSettings.Settings['BlindInterrupt'];
		v81 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
	end
	local v83 = v10.Commons.Everyone;
	local v84 = v10.Commons.Rogue;
	local v85 = v18.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = v21.Rogue.Outlaw;
	local v88 = {};
	local v89 = v16:GetEquipment();
	local v90 = (v89[10 + 3] and v20(v89[16 - 3])) or v20(0 + 0);
	local v91 = (v89[27 - 13] and v20(v89[27 - 13])) or v20(1880 - (446 + 1434));
	v10:RegisterForEvent(function()
		local v152 = 1283 - (1040 + 243);
		while true do
			if ((v152 == (2 - 1)) or ((6472 - (559 + 1288)) < (2563 - (609 + 1322)))) then
				v91 = (v89[468 - (13 + 441)] and v20(v89[52 - 38])) or v20(0 - 0);
				break;
			end
			if ((v152 == (0 - 0)) or ((4 + 79) > (6464 - 4684))) then
				v89 = v16:GetEquipment();
				v90 = (v89[5 + 8] and v20(v89[6 + 7])) or v20(0 - 0);
				v152 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 10 - 4;
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (0 + 0);
	end}};
	local v106, v107 = 0 + 0, 0 + 0;
	local function v108(v153)
		local v154 = 0 + 0;
		local v155;
		while true do
			if (((831 - 285) <= (666 + 411)) and (v154 == (668 - (89 + 578)))) then
				return v106;
			end
			if ((v154 == (0 + 0)) or ((2070 - 1074) > (5350 - (572 + 477)))) then
				v155 = v16:EnergyTimeToMaxPredicted(nil, v153);
				if (((549 + 3521) > (413 + 274)) and ((v155 < v106) or ((v155 - v106) > (0.5 + 0)))) then
					v106 = v155;
				end
				v154 = 87 - (84 + 2);
			end
		end
	end
	local function v109()
		local v156 = v16:EnergyPredicted();
		if ((v156 > v107) or ((v156 - v107) > (14 - 5)) or ((473 + 183) >= (4172 - (497 + 345)))) then
			v107 = v156;
		end
		return v107;
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		if (not v11.APLVar.RtB_Buffs or ((9213 - 6721) <= (303 + 32))) then
			local v170 = 0 - 0;
			local v171;
			while true do
				if (((3264 + 1058) >= (3051 - (457 + 32))) and (v170 == (2 + 1))) then
					for v191 = 1403 - (832 + 570), #v110 do
						local v192 = v16:BuffRemains(v110[v191]);
						if ((v192 > (0 + 0)) or ((949 + 2688) >= (13341 - 9571))) then
							local v195 = 0 + 0;
							local v196;
							while true do
								if (((797 - (588 + 208)) == v195) or ((6411 - 4032) > (6378 - (884 + 916)))) then
									v196 = math.abs(v192 - v171);
									if ((v196 <= (0.5 - 0)) or ((281 + 202) > (1396 - (232 + 421)))) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1890 - (1569 + 320));
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v191]:Name()] = true;
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
									elseif (((467 + 1987) > (1947 - 1369)) and (v192 > v171)) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (606 - (316 + 289));
									else
										v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (2 - 1);
										v11.APLVar.RtB_Buffs.Will_Lose[v110[v191]:Name()] = true;
										v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
									end
									break;
								end
								if (((2383 - (666 + 787)) < (4883 - (360 + 65))) and (v195 == (0 + 0))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (255 - (79 + 175));
									if (((1043 - 381) <= (759 + 213)) and (v192 > v11.APLVar.RtB_Buffs.MaxRemains)) then
										v11.APLVar.RtB_Buffs.MaxRemains = v192;
									end
									v195 = 2 - 1;
								end
							end
						end
						if (((8416 - 4046) == (5269 - (503 + 396))) and v111) then
							local v197 = 181 - (92 + 89);
							while true do
								if ((v197 == (0 - 0)) or ((2443 + 2319) <= (510 + 351))) then
									print("RtbRemains", v171);
									print(v110[v191]:Name(), v192);
									break;
								end
							end
						end
					end
					if (v111 or ((5529 - 4117) == (584 + 3680))) then
						print("have: ", v11.APLVar.RtB_Buffs.Total);
						print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v11.APLVar.RtB_Buffs.Normal);
						print("longer: ", v11.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
					end
					break;
				end
				if ((v170 == (2 - 1)) or ((2765 + 403) < (1029 + 1124))) then
					v11.APLVar.RtB_Buffs.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Normal = 0 + 0;
					v11.APLVar.RtB_Buffs.Shorter = 0 - 0;
					v170 = 1246 - (485 + 759);
				end
				if ((v170 == (4 - 2)) or ((6165 - (442 + 747)) < (2467 - (832 + 303)))) then
					v11.APLVar.RtB_Buffs.Longer = 946 - (88 + 858);
					v11.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v171 = v84.RtBRemains();
					v170 = 3 + 0;
				end
				if (((191 + 4437) == (5417 - (766 + 23))) and (v170 == (0 - 0))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
					v170 = 2 - 1;
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v113(v157)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v157] and true) or false;
	end
	local function v114()
		local v158 = 0 - 0;
		while true do
			if ((v158 == (1073 - (1036 + 37))) or ((39 + 15) == (769 - 374))) then
				if (((65 + 17) == (1562 - (641 + 839))) and not v11.APLVar.RtB_Reroll) then
					if ((v65 == "1+ Buff") or ((1494 - (910 + 3)) < (718 - 436))) then
						v11.APLVar.RtB_Reroll = ((v112() <= (1684 - (1466 + 218))) and true) or false;
					elseif ((v65 == "Broadside") or ((2119 + 2490) < (3643 - (556 + 592)))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
					elseif (((410 + 742) == (1960 - (329 + 479))) and (v65 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
					elseif (((2750 - (174 + 680)) <= (11758 - 8336)) and (v65 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
					elseif ((v65 == "Skull and Crossbones") or ((2052 - 1062) > (1157 + 463))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
					elseif ((v65 == "Ruthless Precision") or ((1616 - (396 + 343)) > (416 + 4279))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
					elseif (((4168 - (29 + 1448)) >= (3240 - (135 + 1254))) and (v65 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
					else
						local v217 = 0 - 0;
						while true do
							if (((4 - 3) == v217) or ((1990 + 995) >= (6383 - (389 + 1138)))) then
								v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (576 - (102 + 472)))));
								if (((4036 + 240) >= (663 + 532)) and v85.Crackshot:IsAvailable() and not v16:HasTier(29 + 2, 1549 - (320 + 1225))) then
									v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 - 0)));
								end
								v217 = 2 + 0;
							end
							if (((4696 - (157 + 1307)) <= (6549 - (821 + 1038))) and (v217 == (0 - 0))) then
								v11.APLVar.RtB_Reroll = false;
								v112();
								v217 = 1 + 0;
							end
							if (((4 - 1) == v217) or ((334 + 562) >= (7797 - 4651))) then
								v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (1026 - (834 + 192))) or ((v11.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (1 + 5)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (59 - 20)) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
								if (((3365 - (300 + 4)) >= (790 + 2168)) and (v17:FilteredTimeToDie("<", 31 - 19) or v10.BossFilteredFightRemains("<", 374 - (112 + 250)))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if (((1271 + 1916) >= (1612 - 968)) and (v217 == (2 + 0))) then
								if (((334 + 310) <= (527 + 177)) and v85.Crackshot:IsAvailable() and v16:HasTier(16 + 15, 3 + 1)) then
									v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((1415 - (1001 + 413)) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
								end
								if (((2136 - 1178) > (1829 - (244 + 638))) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((695 - (627 + 66)) + v22(v113(v85.GrandMelee)))) and (v94 < (5 - 3))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v217 = 605 - (512 + 90);
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (1907 - (1665 + 241))) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((719 - (373 + 344)) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (23 + 27));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (1 + 1)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		local v159 = 0 - 0;
		while true do
			if (((7601 - 3109) >= (3753 - (35 + 1064))) and (v159 == (1 + 0))) then
				if (((7364 - 3922) >= (6 + 1497)) and v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (1242 - (298 + 938))) or not v68) and not v16:StealthUp(true, false)) then
					if (v10.Cast(v85.ShadowDance, v54) or ((4429 - (233 + 1026)) <= (3130 - (636 + 1030)))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((2453 + 2344) == (4287 + 101))) then
					if (((164 + 387) <= (47 + 634)) and v12(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance";
					end
				end
				v159 = 223 - (55 + 166);
			end
			if (((636 + 2641) > (41 + 366)) and (v159 == (0 - 0))) then
				if (((4992 - (36 + 261)) >= (2474 - 1059)) and v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (1374 - (34 + 1334)))) and v116()) then
					if (v10.Cast(v85.Vanish, v68) or ((1235 + 1977) <= (734 + 210))) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) or ((4379 - (1035 + 248)) <= (1819 - (20 + 1)))) then
					if (((1843 + 1694) == (3856 - (134 + 185))) and v10.Cast(v85.Vanish, v68)) then
						return "Cast Vanish (Finish)";
					end
				end
				v159 = 1134 - (549 + 584);
			end
			if (((4522 - (314 + 371)) >= (5389 - 3819)) and (v159 == (970 - (478 + 490)))) then
				if ((v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (16 + 14)) or ((v85.KeepItRolling:CooldownRemains() >= (1292 - (786 + 386))) and (v115() or v85.HiddenOpportunity:IsAvailable())))) or ((9555 - 6605) == (5191 - (1055 + 324)))) then
					if (((6063 - (1093 + 247)) >= (2060 + 258)) and v10.Cast(v85.ShadowDance, v54)) then
						return "Cast Shadow Dance";
					end
				end
				if ((v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) or ((214 + 1813) > (11322 - 8470))) then
					if ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())) or ((3855 - 2719) > (12283 - 7966))) then
						if (((11931 - 7183) == (1689 + 3059)) and v10.Cast(v85.Shadowmeld, v31)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v160 = 0 - 0;
		local v161;
		while true do
			if (((12877 - 9141) <= (3575 + 1165)) and ((2 - 1) == v160)) then
				v161 = v83.HandleBottomTrinket(v88, v29, 696 - (364 + 324), nil);
				if (v161 or ((9293 - 5903) <= (7342 - 4282))) then
					return v161;
				end
				break;
			end
			if ((v160 == (0 + 0)) or ((4179 - 3180) > (4312 - 1619))) then
				v161 = v83.HandleTopTrinket(v88, v29, 24 - 16, nil);
				if (((1731 - (1249 + 19)) < (543 + 58)) and v161) then
					return v161;
				end
				v160 = 3 - 2;
			end
		end
	end
	local function v122()
		local v162 = 1086 - (686 + 400);
		local v163;
		local v164;
		while true do
			if ((v162 == (4 + 1)) or ((2412 - (73 + 156)) < (4 + 683))) then
				if (((5360 - (721 + 90)) == (52 + 4497)) and v85.BloodFury:IsCastable()) then
					if (((15169 - 10497) == (5142 - (224 + 246))) and v10.Cast(v85.BloodFury, v31)) then
						return "Cast Blood Fury";
					end
				end
				if (v85.Berserking:IsCastable() or ((5941 - 2273) < (727 - 332))) then
					if (v10.Cast(v85.Berserking, v31) or ((756 + 3410) == (11 + 444))) then
						return "Cast Berserking";
					end
				end
				if (v85.Fireblood:IsCastable() or ((3268 + 1181) == (5294 - 2631))) then
					if (v10.Cast(v85.Fireblood, v31) or ((14232 - 9955) < (3502 - (203 + 310)))) then
						return "Cast Fireblood";
					end
				end
				v162 = 1999 - (1238 + 755);
			end
			if ((v162 == (0 + 0)) or ((2404 - (709 + 825)) >= (7645 - 3496))) then
				v163 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
				if (((3221 - 1009) < (4047 - (196 + 668))) and v163) then
					return "DPS Pot";
				end
				if (((18343 - 13697) > (6197 - 3205)) and v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (835 - (171 + 662)))))) then
					if (((1527 - (4 + 89)) < (10886 - 7780)) and v12(v85.AdrenalineRush, v76)) then
						return "Cast Adrenaline Rush";
					end
				end
				v162 = 1 + 0;
			end
			if (((3452 - 2666) < (1186 + 1837)) and (v162 == (1488 - (35 + 1451)))) then
				v164 = v121();
				if (v164 or ((3895 - (28 + 1425)) < (2067 - (941 + 1052)))) then
					return v164;
				end
				if (((4349 + 186) == (6049 - (822 + 692))) and v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((3 - 0) + v22(v16:HasTier(15 + 16, 301 - (45 + 252))))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (6 + 0)))) then
					if (v10.Cast(v85.KeepItRolling) or ((1036 + 1973) <= (5123 - 3018))) then
						return "Cast Keep it Rolling";
					end
				end
				v162 = 436 - (114 + 319);
			end
			if (((2627 - 797) < (4700 - 1031)) and (v162 == (2 + 1))) then
				if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (9 - 2))) or ((2996 - 1566) >= (5575 - (556 + 1407)))) then
					if (((3889 - (741 + 465)) >= (2925 - (170 + 295))) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((951 + 853) >= (3009 + 266))) then
					if ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 26 - 15) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 10 + 1) or ((909 + 508) > (2055 + 1574))) then
						if (((6025 - (957 + 273)) > (108 + 294)) and v10.Cast(v85.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((1927 + 2886) > (13584 - 10019)) and v85.BladeRush:IsReady() and (v103 > (10 - 6)) and not v16:StealthUp(true, true)) then
					if (((11948 - 8036) == (19370 - 15458)) and v10.Cast(v85.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v162 = 1784 - (389 + 1391);
			end
			if (((1770 + 1051) <= (503 + 4321)) and (v162 == (13 - 7))) then
				if (((2689 - (783 + 168)) <= (7366 - 5171)) and v85.AncestralCall:IsCastable()) then
					if (((41 + 0) <= (3329 - (309 + 2))) and v10.Cast(v85.AncestralCall, v31)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((6587 - 4442) <= (5316 - (1090 + 122))) and (v162 == (2 + 2))) then
				if (((9030 - 6341) < (3316 + 1529)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
					local v183 = 1118 - (628 + 490);
					while true do
						if ((v183 == (0 + 0)) or ((5748 - 3426) > (11982 - 9360))) then
							v164 = v120();
							if (v164 or ((5308 - (431 + 343)) == (4204 - 2122))) then
								return v164;
							end
							break;
						end
					end
				end
				if ((v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (289 - 189)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (5 + 1)))) or ((201 + 1370) > (3562 - (556 + 1139)))) then
					if (v10.Cast(v85.ThistleTea) or ((2669 - (6 + 9)) >= (549 + 2447))) then
						return "Cast Thistle Tea";
					end
				end
				if (((2038 + 1940) > (2273 - (28 + 141))) and v85.BladeRush:IsCastable() and (v103 > (2 + 2)) and not v16:StealthUp(true, true)) then
					if (((3696 - 701) > (1092 + 449)) and v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v162 = 1322 - (486 + 831);
			end
			if (((8454 - 5205) > (3354 - 2401)) and (v162 == (1 + 0))) then
				if (v85.BladeFlurry:IsReady() or ((10348 - 7075) > (5836 - (668 + 595)))) then
					if (((v94 >= ((2 + 0) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < v16:GCD())) or ((636 + 2515) < (3501 - 2217))) then
						if (v12(v85.BladeFlurry) or ((2140 - (23 + 267)) == (3473 - (1129 + 815)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((1208 - (371 + 16)) < (3873 - (1326 + 424))) and v85.BladeFlurry:IsReady()) then
					if (((1707 - 805) < (8496 - 6171)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (121 - (88 + 30))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (776 - (720 + 51))))) then
						if (((1908 - 1050) <= (4738 - (421 + 1355))) and v12(v85.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v85.RolltheBones:IsReady() or ((6509 - 2563) < (633 + 655))) then
					if (v114() or (v112() == (1083 - (286 + 797))) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (10 - 7)) and v16:HasTier(51 - 20, 443 - (397 + 42))) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (3 + 4)) and ((v85.ShadowDance:CooldownRemains() <= (803 - (24 + 776))) or (v85.Vanish:CooldownRemains() <= (4 - 1)))) or ((4027 - (222 + 563)) == (1248 - 681))) then
						if (v12(v85.RolltheBones) or ((610 + 237) >= (1453 - (23 + 167)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v162 = 1800 - (690 + 1108);
			end
		end
	end
	local function v123()
		local v165 = 0 + 0;
		while true do
			if ((v165 == (1 + 0)) or ((3101 - (40 + 808)) == (305 + 1546))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) or ((7980 - 5893) > (2268 + 104))) then
					if (v10.Cast(v85.BetweentheEyes) or ((2352 + 2093) < (2276 + 1873))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((2389 - (47 + 524)) == (56 + 29))) then
					if (((1722 - 1092) < (3179 - 1052)) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v165 = 4 - 2;
			end
			if ((v165 == (1726 - (1165 + 561))) or ((58 + 1880) == (7786 - 5272))) then
				if (((1624 + 2631) >= (534 - (341 + 138))) and v85.BladeFlurry:IsReady()) then
					if (((810 + 2189) > (2385 - 1229)) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (329 - (89 + 237))) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (16 - 11)))) then
						if (((4947 - 2597) > (2036 - (581 + 300))) and v12(v85.BladeFlurry, v71)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((5249 - (855 + 365)) <= (11526 - 6673)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (v10.Cast(v85.ColdBlood, v56) or ((169 + 347) > (4669 - (1030 + 205)))) then
						return "Cast Cold Blood";
					end
				end
				v165 = 1 + 0;
			end
			if (((3764 + 282) >= (3319 - (156 + 130))) and (v165 == (4 - 2))) then
				if ((v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (2 - 0)) and (v16:BuffStack(v85.Opportunity) >= (11 - 5)) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1 + 0))) or v16:BuffUp(v85.GreenskinsWickersBuff))) or ((1586 + 1133) <= (1516 - (10 + 59)))) then
					if (v10.Press(v85.PistolShot) or ((1170 + 2964) < (19334 - 15408))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((1327 - (671 + 492)) >= (2218 + 567))) then
					if (v12(v85.Ambush, nil, not v17:IsSpellInRange(v85.Ambush)) or ((1740 - (369 + 846)) == (559 + 1550))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v165 = 3 + 0;
			end
			if (((1978 - (1036 + 909)) == (27 + 6)) and ((4 - 1) == v165)) then
				if (((3257 - (11 + 192)) <= (2029 + 1986)) and v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) then
					if (((2046 - (135 + 40)) < (8193 - 4811)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v166 = 0 + 0;
		while true do
			if (((2848 - 1555) <= (3246 - 1080)) and (v166 == (177 - (50 + 126)))) then
				if ((v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 - 0))) and (v16:BuffRemains(v85.SliceandDice) < ((1 + 0 + v98) * (1414.8 - (1233 + 180))))) or ((3548 - (522 + 447)) < (1544 - (107 + 1314)))) then
					if (v10.Press(v85.SliceandDice) or ((393 + 453) >= (7215 - 4847))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) or ((1705 + 2307) <= (6668 - 3310))) then
					if (((5911 - 4417) <= (4915 - (716 + 1194))) and v10.Cast(v85.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v166 = 1 + 1;
			end
			if ((v166 == (1 + 1)) or ((3614 - (74 + 429)) == (4116 - 1982))) then
				if (((1168 + 1187) == (5390 - 3035)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Cast(v85.ColdBlood, v56) or ((416 + 172) <= (1331 - 899))) then
						return "Cast Cold Blood";
					end
				end
				if (((11860 - 7063) >= (4328 - (279 + 154))) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (((4355 - (454 + 324)) == (2815 + 762)) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((3811 - (12 + 5)) > (1992 + 1701)) and (v166 == (0 - 0))) then
				if ((v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (2 + 2)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(1123 - (277 + 816), 17 - 13)) and v16:BuffDown(v85.GreenskinsWickers)) or ((2458 - (1058 + 125)) == (769 + 3331))) then
					if (v10.Press(v85.BetweentheEyes) or ((2566 - (815 + 160)) >= (15360 - 11780))) then
						return "Cast Between the Eyes";
					end
				end
				if (((2333 - 1350) <= (432 + 1376)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (131 - 86)) and (v85.ShadowDance:CooldownRemains() > (1910 - (41 + 1857)))) then
					if (v10.Press(v85.BetweentheEyes) or ((4043 - (1222 + 671)) <= (3093 - 1896))) then
						return "Cast Between the Eyes";
					end
				end
				v166 = 1 - 0;
			end
		end
	end
	local function v125()
		local v167 = 1182 - (229 + 953);
		while true do
			if (((5543 - (1111 + 663)) >= (2752 - (874 + 705))) and (v167 == (1 + 1))) then
				if (((1014 + 471) == (3086 - 1601)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= (1 + 0 + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (680 - (642 + 37)))))) or (v98 <= v22(v85.Ruthlessness:IsAvailable())))) then
					if (v10.Cast(v85.PistolShot, nil, not v17:IsSpellInRange(v85.PistolShot)) or ((756 + 2559) <= (446 + 2336))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (2.5 - 1)) or (v99 <= ((455 - (233 + 221)) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) or ((2025 - 1149) >= (2609 + 355))) then
					if (v10.Cast(v85.PistolShot, nil, not v17:IsSpellInRange(v85.PistolShot)) or ((3773 - (718 + 823)) > (1572 + 925))) then
						return "Cast Pistol Shot";
					end
				end
				v167 = 808 - (266 + 539);
			end
			if ((v167 == (2 - 1)) or ((3335 - (636 + 589)) <= (787 - 455))) then
				if (((7602 - 3916) > (2514 + 658)) and v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) then
					if (v10.Press(v85.PistolShot) or ((1626 + 2848) < (1835 - (657 + 358)))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((11329 - 7050) >= (6565 - 3683)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (1193 - (1151 + 36))) or (v16:BuffRemains(v85.Opportunity) < (2 + 0)))) then
					if (v10.Press(v85.PistolShot) or ((534 + 1495) >= (10515 - 6994))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v167 = 1834 - (1552 + 280);
			end
			if (((837 - (64 + 770)) == v167) or ((1384 + 653) >= (10537 - 5895))) then
				if (((306 + 1414) < (5701 - (157 + 1086))) and v85.SinisterStrike:IsCastable()) then
					if (v10.Press(v85.SinisterStrike) or ((872 - 436) > (13231 - 10210))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((1092 - 379) <= (1155 - 308)) and (v167 == (819 - (599 + 220)))) then
				if (((4289 - 2135) <= (5962 - (1813 + 118))) and v29 and v85.EchoingReprimand:IsReady()) then
					if (((3374 + 1241) == (5832 - (841 + 376))) and v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((5310 - 1520) == (117 + 383))) then
					if (((242 - 153) < (1080 - (464 + 395))) and v10.Press(v85.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v167 = 2 - 1;
			end
		end
	end
	local function v126()
		local v168 = 0 + 0;
		while true do
			if (((2891 - (467 + 370)) >= (2936 - 1515)) and (v168 == (3 + 0))) then
				v101 = v16:EnergyRegen();
				v103 = v108(v104);
				v102 = v16:EnergyDeficitPredicted(nil, v104);
				v168 = 13 - 9;
			end
			if (((108 + 584) < (7114 - 4056)) and (v168 == (521 - (150 + 370)))) then
				v29 = EpicSettings.Toggles['cds'];
				v98 = v16:ComboPoints();
				v97 = v84.EffectiveComboPoints(v98);
				v168 = 1284 - (74 + 1208);
			end
			if (((9 - 5) == v168) or ((15432 - 12178) == (1178 + 477))) then
				if (v28 or ((1686 - (14 + 376)) == (8516 - 3606))) then
					local v184 = 0 + 0;
					while true do
						if (((2959 + 409) == (3213 + 155)) and (v184 == (2 - 1))) then
							v94 = #v93;
							break;
						end
						if (((1989 + 654) < (3893 - (23 + 55))) and (v184 == (0 - 0))) then
							v92 = v16:GetEnemiesInRange(21 + 9);
							v93 = v16:GetEnemiesInRange(v96);
							v184 = 1 + 0;
						end
					end
				else
					v94 = 1 - 0;
				end
				v95 = v84.CrimsonVial();
				if (((602 + 1311) > (1394 - (652 + 249))) and v95) then
					return v95;
				end
				v168 = 13 - 8;
			end
			if (((6623 - (708 + 1160)) > (9304 - 5876)) and (v168 == (0 - 0))) then
				v82();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v168 = 28 - (10 + 17);
			end
			if (((311 + 1070) <= (4101 - (1400 + 332))) and (v168 == (3 - 1))) then
				v99 = v16:ComboPointsDeficit();
				v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(1958 - (242 + 1666))) or (0 + 0);
				v100 = v109();
				v168 = 2 + 1;
			end
			if (((7 + 1) == v168) or ((5783 - (850 + 90)) == (7152 - 3068))) then
				if (((6059 - (360 + 1030)) > (322 + 41)) and v83.TargetIsValid()) then
					local v185 = 0 - 0;
					while true do
						if ((v185 == (0 - 0)) or ((3538 - (909 + 752)) >= (4361 - (109 + 1114)))) then
							v95 = v122();
							if (((8681 - 3939) >= (1412 + 2214)) and v95) then
								return "CDs: " .. v95;
							end
							if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((4782 - (6 + 236)) == (578 + 338))) then
								local v199 = 0 + 0;
								while true do
									if ((v199 == (0 - 0)) or ((2019 - 863) > (5478 - (1076 + 57)))) then
										v95 = v123();
										if (((368 + 1869) < (4938 - (579 + 110))) and v95) then
											return "Stealth: " .. v95;
										end
										break;
									end
								end
							end
							v185 = 1 + 0;
						end
						if ((v185 == (2 + 0)) or ((1424 + 1259) < (430 - (174 + 233)))) then
							if (((1946 - 1249) <= (1449 - 623)) and v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (7 + 8 + v101))) then
								if (((2279 - (663 + 511)) <= (1050 + 126)) and v10.Cast(v85.ArcaneTorrent, v31)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((734 + 2645) <= (11752 - 7940)) and v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) then
								if (v10.Cast(v85.ArcanePulse) or ((478 + 310) >= (3804 - 2188))) then
									return "Cast Arcane Pulse";
								end
							end
							if (((4487 - 2633) <= (1613 + 1766)) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(9 - 4)) then
								if (((3242 + 1307) == (416 + 4133)) and v10.Cast(v85.LightsJudgment, v31)) then
									return "Cast Lights Judgment";
								end
							end
							v185 = 725 - (478 + 244);
						end
						if ((v185 == (518 - (440 + 77))) or ((1375 + 1647) >= (11067 - 8043))) then
							if (((6376 - (655 + 901)) > (408 + 1790)) and v115()) then
								local v200 = 0 + 0;
								while true do
									if ((v200 == (1 + 0)) or ((4274 - 3213) >= (6336 - (695 + 750)))) then
										return "Finish Pooling";
									end
									if (((4657 - 3293) <= (6902 - 2429)) and (v200 == (0 - 0))) then
										v95 = v124();
										if (v95 or ((3946 - (285 + 66)) <= (6 - 3))) then
											return "Finish: " .. v95;
										end
										v200 = 1311 - (682 + 628);
									end
								end
							end
							v95 = v125();
							if (v95 or ((754 + 3918) == (4151 - (176 + 123)))) then
								return "Build: " .. v95;
							end
							v185 = 1 + 1;
						end
						if (((1131 + 428) == (1828 - (239 + 30))) and (v185 == (1 + 2))) then
							if ((v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(5 + 0)) or ((3100 - 1348) <= (2458 - 1670))) then
								if (v10.Cast(v85.BagofTricks, v31) or ((4222 - (306 + 9)) == (617 - 440))) then
									return "Cast Bag of Tricks";
								end
							end
							if (((604 + 2866) > (341 + 214)) and v85.PistolShot:IsCastable() and v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (13 + 12)) and ((v99 >= (2 - 1)) or (v103 <= (1376.2 - (1140 + 235))))) then
								if (v10.Cast(v85.PistolShot) or ((619 + 353) == (592 + 53))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((817 + 2365) >= (2167 - (33 + 19))) and not v17:IsSpellInRange(v85.Dispatch)) then
								if (((1406 + 2487) < (13274 - 8845)) and v12(v85.PoolEnergy, false, "OOR")) then
									return "Pool Energy (OOR)";
								end
							elseif (v12(v85.PoolEnergy) or ((1263 + 1604) < (3735 - 1830))) then
								return "Pool Energy";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v168 == (7 + 0)) or ((2485 - (586 + 103)) >= (369 + 3682))) then
				if (((4984 - 3365) <= (5244 - (1309 + 179))) and not v16:AffectingCombat() and not v16:IsMounted() and v60) then
					local v186 = 0 - 0;
					while true do
						if (((263 + 341) == (1622 - 1018)) and (v186 == (0 + 0))) then
							v95 = v84.Stealth(v85.Stealth2, nil);
							if (v95 or ((9526 - 5042) == (1793 - 893))) then
								return "Stealth (OOC): " .. v95;
							end
							break;
						end
					end
				end
				if ((not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (610 - (295 + 314))) and v17:IsInRange(19 - 11) and v27) or ((6421 - (1300 + 662)) <= (3494 - 2381))) then
					if (((5387 - (1178 + 577)) > (1765 + 1633)) and v83.TargetIsValid() and v17:IsInRange(29 - 19) and not (v16:IsChanneling() or v16:IsCasting())) then
						local v194 = 1405 - (851 + 554);
						while true do
							if (((3610 + 472) <= (13636 - 8719)) and ((0 - 0) == v194)) then
								if (((5134 - (115 + 187)) >= (1062 + 324)) and v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
									if (((130 + 7) == (539 - 402)) and v12(v85.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v16:StealthUp(true, false) or ((2731 - (160 + 1001)) >= (3790 + 542))) then
									local v203 = 0 + 0;
									while true do
										if (((0 - 0) == v203) or ((4422 - (237 + 121)) <= (2716 - (525 + 372)))) then
											v95 = v84.Stealth(v84.StealthSpell());
											if (v95 or ((9452 - 4466) < (5171 - 3597))) then
												return v95;
											end
											break;
										end
									end
								end
								v194 = 143 - (96 + 46);
							end
							if (((5203 - (643 + 134)) > (63 + 109)) and (v194 == (2 - 1))) then
								if (((2175 - 1589) > (437 + 18)) and v83.TargetIsValid()) then
									local v204 = 0 - 0;
									while true do
										if (((1688 - 862) == (1545 - (316 + 403))) and ((1 + 0) == v204)) then
											if ((v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((2 - 1) + v98) * (1.8 + 0)))) or ((10121 - 6102) > (3148 + 1293))) then
												if (((651 + 1366) < (14764 - 10503)) and v10.Press(v85.SliceandDice)) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((22522 - 17806) > (166 - 86)) and v16:StealthUp(true, false)) then
												v95 = v123();
												if (v95 or ((201 + 3306) == (6441 - 3169))) then
													return "Stealth (Opener): " .. v95;
												end
												if ((v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) or ((43 + 833) >= (9046 - 5971))) then
													if (((4369 - (12 + 5)) > (9919 - 7365)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) or ((9400 - 4994) < (8594 - 4551))) then
													if (v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush)) or ((4684 - 2795) >= (687 + 2696))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((3865 - (1656 + 317)) <= (2437 + 297)) and v85.SinisterStrike:IsCastable()) then
													if (((1541 + 382) < (5897 - 3679)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
											elseif (((10694 - 8521) > (733 - (5 + 349))) and v115()) then
												local v218 = 0 - 0;
												while true do
													if ((v218 == (1271 - (266 + 1005))) or ((1708 + 883) == (11631 - 8222))) then
														v95 = v124();
														if (((5942 - 1428) > (5020 - (561 + 1135))) and v95) then
															return "Finish (Opener): " .. v95;
														end
														break;
													end
												end
											end
											v204 = 2 - 0;
										end
										if ((v204 == (0 - 0)) or ((1274 - (507 + 559)) >= (12114 - 7286))) then
											if ((v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (0 - 0)) or v114())) or ((1971 - (212 + 176)) > (4472 - (250 + 655)))) then
												if (v10.Cast(v85.RolltheBones) or ((3580 - 2267) == (1386 - 592))) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if (((4965 - 1791) > (4858 - (1869 + 87))) and v85.AdrenalineRush:IsReady() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (6 - 4))) then
												if (((6021 - (484 + 1417)) <= (9130 - 4870)) and v10.Cast(v85.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v204 = 1 - 0;
										end
										if ((v204 == (775 - (48 + 725))) or ((1442 - 559) > (12818 - 8040))) then
											if (v85.SinisterStrike:IsCastable() or ((2104 + 1516) >= (13070 - 8179))) then
												if (((1192 + 3066) > (274 + 663)) and v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike))) then
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
					end
				end
				if ((v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) or ((5722 - (152 + 701)) < (2217 - (430 + 881)))) then
					local v187 = 0 + 0;
					while true do
						if ((v187 == (895 - (557 + 338))) or ((363 + 862) > (11914 - 7686))) then
							v98 = v26(v98, v84.FanTheHammerCP());
							v97 = v84.EffectiveComboPoints(v98);
							v187 = 3 - 2;
						end
						if (((8841 - 5513) > (4823 - 2585)) and (v187 == (802 - (499 + 302)))) then
							v99 = v16:ComboPointsDeficit();
							break;
						end
					end
				end
				v168 = 874 - (39 + 827);
			end
			if (((10597 - 6758) > (3137 - 1732)) and (v168 == (19 - 14))) then
				v84.Poisons();
				if ((v33 and (v16:HealthPercentage() <= v35)) or ((1984 - 691) <= (44 + 463))) then
					local v188 = 0 - 0;
					while true do
						if ((v188 == (0 + 0)) or ((4582 - 1686) < (909 - (103 + 1)))) then
							if (((2870 - (475 + 79)) == (5006 - 2690)) and (v34 == "Refreshing Healing Potion")) then
								if (v86.RefreshingHealingPotion:IsReady() or ((8224 - 5654) == (199 + 1334))) then
									if (v10.Press(v87.RefreshingHealingPotion) or ((778 + 105) == (2963 - (1395 + 108)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v34 == "Dreamwalker's Healing Potion") or ((13440 - 8821) <= (2203 - (7 + 1197)))) then
								if (v86.DreamwalkersHealingPotion:IsReady() or ((1487 + 1923) > (1437 + 2679))) then
									if (v10.Press(v87.RefreshingHealingPotion) or ((1222 - (27 + 292)) >= (8963 - 5904))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if ((v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) or ((5070 - 1094) < (11981 - 9124))) then
					if (((9722 - 4792) > (4393 - 2086)) and v10.Cast(v85.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v168 = 145 - (43 + 96);
			end
			if ((v168 == (24 - 18)) or ((9147 - 5101) < (1072 + 219))) then
				if ((v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) or ((1198 + 3043) == (7006 - 3461))) then
					if (v10.Cast(v85.Evasion) or ((1552 + 2496) > (7930 - 3698))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v16:IsCasting() and not v16:IsChanneling()) or ((551 + 1199) >= (255 + 3218))) then
					local v189 = v83.Interrupt(v85.Kick, 1759 - (1414 + 337), true);
					if (((5106 - (1642 + 298)) == (8252 - 5086)) and v189) then
						return v189;
					end
					v189 = v83.Interrupt(v85.Kick, 22 - 14, true, v13, v87.KickMouseover);
					if (((5231 - 3468) < (1226 + 2498)) and v189) then
						return v189;
					end
					v189 = v83.Interrupt(v85.Blind, 12 + 3, v80);
					if (((1029 - (357 + 615)) <= (1912 + 811)) and v189) then
						return v189;
					end
					v189 = v83.Interrupt(v85.Blind, 36 - 21, v80, v13, v87.BlindMouseover);
					if (v189 or ((1774 + 296) == (949 - 506))) then
						return v189;
					end
					v189 = v83.InterruptWithStun(v85.CheapShot, 7 + 1, v16:StealthUp(false, false));
					if (v189 or ((184 + 2521) == (876 + 517))) then
						return v189;
					end
					v189 = v83.InterruptWithStun(v85.KidneyShot, 1309 - (384 + 917), v16:ComboPoints() > (697 - (128 + 569)));
					if (v189 or ((6144 - (1407 + 136)) < (1948 - (687 + 1200)))) then
						return v189;
					end
				end
				if (v30 or ((3100 - (556 + 1154)) >= (16689 - 11945))) then
					local v190 = 95 - (9 + 86);
					while true do
						if (((421 - (275 + 146)) == v190) or ((326 + 1677) > (3898 - (29 + 35)))) then
							v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 132 - 102, true);
							if (v95 or ((465 - 309) > (17273 - 13360))) then
								return v95;
							end
							break;
						end
					end
				end
				v168 = 5 + 2;
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1272 - (53 + 959), v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

