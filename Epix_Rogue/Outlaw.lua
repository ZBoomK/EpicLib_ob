local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((8358 - 5632) == (2180 + 1689))) then
			v6 = v0[v4];
			if (not v6 or ((6010 - (1607 + 27)) <= (427 + 1054))) then
				return v1(v4, ...);
			end
			v5 = 1727 - (1668 + 58);
		end
		if ((v5 == (627 - (512 + 114))) or ((8843 - 5451) >= (9801 - 5060))) then
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
			if (((1547 + 1778) >= (404 + 1750)) and (v128 == (4 + 0))) then
				v59 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v60 = EpicSettings.Settings['StealthOOC'];
				v65 = EpicSettings.Settings['RolltheBonesLogic'];
				v68 = EpicSettings.Settings['UseDPSVanish'];
				v128 = 1999 - (109 + 1885);
			end
			if ((v128 == (1474 - (1269 + 200))) or ((2482 - 1187) >= (4048 - (98 + 717)))) then
				v71 = EpicSettings.Settings['BladeFlurryGCD'];
				v72 = EpicSettings.Settings['BladeRushGCD'];
				v73 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v75 = EpicSettings.Settings['KeepItRollingGCD'];
				v128 = 832 - (802 + 24);
			end
			if (((7547 - 3170) > (2073 - 431)) and (v128 == (1 + 1))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v30 = EpicSettings.Settings['HandleIncorporeal'];
				v53 = EpicSettings.Settings['VanishOffGCD'];
				v54 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v128 = 1 + 2;
			end
			if (((1019 + 3704) > (3772 - 2416)) and (v128 == (19 - 13))) then
				v76 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v77 = EpicSettings.Settings['EchoingReprimand'];
				v78 = EpicSettings.Settings['UseSoloVanish'];
				v79 = EpicSettings.Settings['sepsis'];
				v128 = 3 + 4;
			end
			if ((v128 == (0 + 0)) or ((3412 + 724) <= (2497 + 936))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'];
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v128 = 1434 - (797 + 636);
			end
			if (((20610 - 16365) <= (6250 - (1427 + 192))) and ((3 + 4) == v128)) then
				v80 = EpicSettings.Settings['BlindInterrupt'];
				v81 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if (((3844 + 432) >= (1774 + 2140)) and (v128 == (329 - (192 + 134)))) then
				v55 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v56 = EpicSettings.Settings['ColdBloodOffGCD'];
				v57 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v58 = EpicSettings.Settings['CrimsonVialHP'] or (1276 - (316 + 960));
				v128 = 3 + 1;
			end
			if (((153 + 45) <= (4035 + 330)) and (v128 == (3 - 2))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (551 - (83 + 468));
				v38 = EpicSettings.Settings['InterruptWithStun'];
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v128 = 1808 - (1202 + 604);
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
	local v90 = (v89[60 - 47] and v20(v89[20 - 7])) or v20(0 - 0);
	local v91 = (v89[339 - (45 + 280)] and v20(v89[14 + 0])) or v20(0 + 0);
	v10:RegisterForEvent(function()
		local v129 = 0 + 0;
		while true do
			if (((2647 + 2135) > (823 + 3853)) and (v129 == (0 - 0))) then
				v89 = v16:GetEquipment();
				v90 = (v89[1924 - (340 + 1571)] and v20(v89[6 + 7])) or v20(1772 - (1733 + 39));
				v129 = 2 - 1;
			end
			if (((5898 - (125 + 909)) > (4145 - (1096 + 852))) and ((1 + 0) == v129)) then
				v91 = (v89[19 - 5] and v20(v89[14 + 0])) or v20(512 - (409 + 103));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v92, v93, v94;
	local v95;
	local v96 = 242 - (46 + 190);
	local v97, v98, v99;
	local v100, v101, v102, v103, v104;
	local v105 = {{v85.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v85.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v98 > (1905 - (830 + 1075));
	end}};
	local v106, v107 = 524 - (303 + 221), 1269 - (231 + 1038);
	local function v108(v130)
		local v131 = 0 + 0;
		local v132;
		while true do
			if ((v131 == (1163 - (171 + 991))) or ((15248 - 11548) == (6731 - 4224))) then
				return v106;
			end
			if (((11164 - 6690) >= (220 + 54)) and (v131 == (0 - 0))) then
				v132 = v16:EnergyTimeToMaxPredicted(nil, v130);
				if ((v132 < v106) or ((v132 - v106) > (0.5 - 0)) or ((3052 - 1158) <= (4346 - 2940))) then
					v106 = v132;
				end
				v131 = 1249 - (111 + 1137);
			end
		end
	end
	local function v109()
		local v133 = 158 - (91 + 67);
		local v134;
		while true do
			if (((4678 - 3106) >= (382 + 1149)) and (v133 == (523 - (423 + 100)))) then
				v134 = v16:EnergyPredicted();
				if ((v134 > v107) or ((v134 - v107) > (1 + 8)) or ((12977 - 8290) < (2368 + 2174))) then
					v107 = v134;
				end
				v133 = 772 - (326 + 445);
			end
			if (((14361 - 11070) > (3713 - 2046)) and ((2 - 1) == v133)) then
				return v107;
			end
		end
	end
	local v110 = {v85.Broadside,v85.BuriedTreasure,v85.GrandMelee,v85.RuthlessPrecision,v85.SkullandCrossbones,v85.TrueBearing};
	local v111 = false;
	local function v112()
		if (not v11.APLVar.RtB_Buffs or ((227 + 646) == (3577 - 1543))) then
			local v147 = 0 - 0;
			local v148;
			while true do
				if ((v147 == (1815 - (1293 + 519))) or ((5745 - 2929) < (28 - 17))) then
					for v186 = 1 - 0, #v110 do
						local v187 = v16:BuffRemains(v110[v186]);
						if (((15950 - 12251) < (11085 - 6379)) and (v187 > (0 + 0))) then
							local v189 = 0 + 0;
							local v190;
							while true do
								if (((6147 - 3501) >= (203 + 673)) and (v189 == (1 + 0))) then
									v190 = math.abs(v187 - v148);
									if (((384 + 230) <= (4280 - (709 + 387))) and (v190 <= (1858.5 - (673 + 1185)))) then
										local v196 = 0 - 0;
										while true do
											if (((10037 - 6911) == (5142 - 2016)) and (v196 == (1 + 0))) then
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
												break;
											end
											if ((v196 == (0 - 0)) or ((538 + 1649) >= (9877 - 4923))) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + (1 - 0);
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v186]:Name()] = true;
												v196 = 1881 - (446 + 1434);
											end
										end
									elseif ((v187 > v148) or ((5160 - (1040 + 243)) == (10670 - 7095))) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (1848 - (559 + 1288));
									else
										local v200 = 1931 - (609 + 1322);
										while true do
											if (((1161 - (13 + 441)) > (2361 - 1729)) and (v200 == (2 - 1))) then
												v11.APLVar.RtB_Buffs.Will_Lose.Total = v11.APLVar.RtB_Buffs.Will_Lose.Total + (4 - 3);
												break;
											end
											if ((v200 == (0 + 0)) or ((1982 - 1436) >= (954 + 1730))) then
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + 1 + 0;
												v11.APLVar.RtB_Buffs.Will_Lose[v110[v186]:Name()] = true;
												v200 = 2 - 1;
											end
										end
									end
									break;
								end
								if (((802 + 663) <= (7910 - 3609)) and (v189 == (0 + 0))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + 1 + 0;
									if (((1225 + 479) > (1197 + 228)) and (v187 > v11.APLVar.RtB_Buffs.MaxRemains)) then
										v11.APLVar.RtB_Buffs.MaxRemains = v187;
									end
									v189 = 1 + 0;
								end
							end
						end
						if (v111 or ((1120 - (153 + 280)) == (12225 - 7991))) then
							print("RtbRemains", v148);
							print(v110[v186]:Name(), v187);
						end
					end
					if (v111 or ((2990 + 340) < (565 + 864))) then
						print("have: ", v11.APLVar.RtB_Buffs.Total);
						print("will lose: ", v11.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v11.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v11.APLVar.RtB_Buffs.Normal);
						print("longer: ", v11.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v11.APLVar.RtB_Buffs.MaxRemains);
					end
					break;
				end
				if (((601 + 546) >= (305 + 30)) and (v147 == (1 + 0))) then
					v11.APLVar.RtB_Buffs.Total = 0 - 0;
					v11.APLVar.RtB_Buffs.Normal = 0 + 0;
					v11.APLVar.RtB_Buffs.Shorter = 667 - (89 + 578);
					v147 = 2 + 0;
				end
				if (((7140 - 3705) > (3146 - (572 + 477))) and (v147 == (1 + 1))) then
					v11.APLVar.RtB_Buffs.Longer = 0 + 0;
					v11.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v148 = v84.RtBRemains();
					v147 = 89 - (84 + 2);
				end
				if ((v147 == (0 - 0)) or ((2716 + 1054) >= (4883 - (497 + 345)))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Will_Lose = {};
					v11.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v147 = 1 + 0;
				end
			end
		end
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v113(v135)
		return (v11.APLVar.RtB_Buffs.Will_Lose and v11.APLVar.RtB_Buffs.Will_Lose[v135] and true) or false;
	end
	local function v114()
		local v136 = 1333 - (605 + 728);
		while true do
			if ((v136 == (0 + 0)) or ((8428 - 4637) <= (74 + 1537))) then
				if (not v11.APLVar.RtB_Reroll or ((16925 - 12347) <= (1811 + 197))) then
					if (((3116 - 1991) <= (1568 + 508)) and (v65 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v112() <= (489 - (457 + 32))) and true) or false;
					elseif ((v65 == "Broadside") or ((316 + 427) >= (5801 - (832 + 570)))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.Broadside) and true) or false;
					elseif (((1089 + 66) < (437 + 1236)) and (v65 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.BuriedTreasure) and true) or false;
					elseif ((v65 == "Grand Melee") or ((8223 - 5899) <= (279 + 299))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.GrandMelee) and true) or false;
					elseif (((4563 - (588 + 208)) == (10152 - 6385)) and (v65 == "Skull and Crossbones")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.SkullandCrossbones) and true) or false;
					elseif (((5889 - (884 + 916)) == (8560 - 4471)) and (v65 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.RuthlessPrecision) and true) or false;
					elseif (((2585 + 1873) >= (2327 - (232 + 421))) and (v65 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v85.TrueBearing) and true) or false;
					else
						local v210 = 1889 - (1569 + 320);
						while true do
							if (((239 + 733) <= (270 + 1148)) and (v210 == (3 - 2))) then
								v11.APLVar.RtB_Reroll = v112() <= (v22(v113(v85.BuriedTreasure)) + v22(v113(v85.GrandMelee) and (v94 < (607 - (316 + 289)))));
								if ((v85.Crackshot:IsAvailable() and not v16:HasTier(81 - 50, 1 + 3)) or ((6391 - (666 + 787)) < (5187 - (360 + 65)))) then
									v11.APLVar.RtB_Reroll = (not v113(v85.TrueBearing) and v85.HiddenOpportunity:IsAvailable()) or (not v113(v85.Broadside) and not v85.HiddenOpportunity:IsAvailable() and (v11.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
								end
								v210 = 256 - (79 + 175);
							end
							if ((v210 == (0 - 0)) or ((1954 + 550) > (13070 - 8806))) then
								v11.APLVar.RtB_Reroll = false;
								v112();
								v210 = 1 - 0;
							end
							if (((3052 - (503 + 396)) == (2334 - (92 + 89))) and (v210 == (3 - 1))) then
								if ((v85.Crackshot:IsAvailable() and v16:HasTier(16 + 15, 3 + 1)) or ((1985 - 1478) >= (355 + 2236))) then
									v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Buffs.Will_Lose.Total <= ((2 - 1) + v22(v16:BuffUp(v85.LoadedDiceBuff)));
								end
								if (((3910 + 571) == (2141 + 2340)) and not v85.Crackshot:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and not v113(v85.SkullandCrossbones) and (v11.APLVar.RtB_Buffs.Will_Lose.Total < ((5 - 3) + v22(v113(v85.GrandMelee)))) and (v94 < (1 + 1))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v210 = 4 - 1;
							end
							if ((v210 == (1247 - (485 + 759))) or ((5386 - 3058) < (1882 - (442 + 747)))) then
								v11.APLVar.RtB_Reroll = v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (1135 - (832 + 303))) or ((v11.APLVar.RtB_Buffs.Normal == (946 - (88 + 858))) and (v11.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v112() < (5 + 1)) and (v11.APLVar.RtB_Buffs.MaxRemains <= (2 + 37)) and not v16:StealthUp(true, true) and v16:BuffUp(v85.LoadedDiceBuff)));
								if (((5117 - (766 + 23)) == (21366 - 17038)) and (v17:FilteredTimeToDie("<", 15 - 3) or v10.BossFilteredFightRemains("<", 31 - 19))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v115()
		return v97 >= ((v84.CPMaxSpend() - (3 - 2)) - v22((v16:StealthUp(true, true)) and v85.Crackshot:IsAvailable()));
	end
	local function v116()
		return (v85.HiddenOpportunity:IsAvailable() or (v99 >= ((1075 - (1036 + 37)) + v22(v85.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))))) and (v100 >= (36 + 14));
	end
	local function v117()
		return v68 and (not v16:IsTanking(v17) or v78);
	end
	local function v118()
		return not v85.ShadowDanceTalent:IsAvailable() and ((v85.FanTheHammer:TalentRank() + v22(v85.QuickDraw:IsAvailable()) + v22(v85.Audacity:IsAvailable())) < (v22(v85.CountTheOdds:IsAvailable()) + v22(v85.KeepItRolling:IsAvailable())));
	end
	local function v119()
		return v16:BuffUp(v85.BetweentheEyes) and (not v85.HiddenOpportunity:IsAvailable() or (v16:BuffDown(v85.AudacityBuff) and ((v85.FanTheHammer:TalentRank() < (3 - 1)) or v16:BuffDown(v85.Opportunity)))) and not v85.Crackshot:IsAvailable();
	end
	local function v120()
		if (((1250 + 338) >= (2812 - (641 + 839))) and v85.Vanish:IsReady() and v117() and v85.HiddenOpportunity:IsAvailable() and not v85.Crackshot:IsAvailable() and not v16:BuffUp(v85.Audacity) and (v118() or (v16:BuffStack(v85.Opportunity) < (919 - (910 + 3)))) and v116()) then
			if (v10.Cast(v85.Vanish, v68) or ((10640 - 6466) > (5932 - (1466 + 218)))) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v85.Vanish:IsReady() and v117() and (not v85.HiddenOpportunity:IsAvailable() or v85.Crackshot:IsAvailable()) and v115()) or ((2108 + 2478) <= (1230 - (556 + 592)))) then
			if (((1374 + 2489) == (4671 - (329 + 479))) and v10.Cast(v85.Vanish, v68)) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v85.ShadowDance:IsReady() and v85.Crackshot:IsAvailable() and v115() and ((v85.Vanish:CooldownRemains() >= (860 - (174 + 680))) or not v68) and not v16:StealthUp(true, false)) or ((968 - 686) <= (86 - 44))) then
			if (((3291 + 1318) >= (1505 - (396 + 343))) and v10.Cast(v85.ShadowDance, v54)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if ((v85.ShadowDance:IsReady() and not v85.KeepItRolling:IsAvailable() and v119() and v16:BuffUp(v85.SliceandDice) and (v115() or v85.HiddenOpportunity:IsAvailable()) and (not v85.HiddenOpportunity:IsAvailable() or not v85.Vanish:IsReady() or not v68)) or ((102 + 1050) == (3965 - (29 + 1448)))) then
			if (((4811 - (135 + 1254)) > (12620 - 9270)) and v12(v85.ShadowDance, v54)) then
				return "Cast Shadow Dance";
			end
		end
		if (((4094 - 3217) > (251 + 125)) and v85.ShadowDance:IsReady() and v85.KeepItRolling:IsAvailable() and v119() and ((v85.KeepItRolling:CooldownRemains() <= (1557 - (389 + 1138))) or ((v85.KeepItRolling:CooldownRemains() >= (694 - (102 + 472))) and (v115() or v85.HiddenOpportunity:IsAvailable())))) then
			if (v10.Cast(v85.ShadowDance, v54) or ((2943 + 175) <= (1027 + 824))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v85.Shadowmeld:IsAvailable() and v85.Shadowmeld:IsReady() and v31) or ((154 + 11) >= (5037 - (320 + 1225)))) then
			if (((7029 - 3080) < (2972 + 1884)) and ((v85.Crackshot:IsAvailable() and v115()) or (not v85.Crackshot:IsAvailable() and ((v85.CountTheOdds:IsAvailable() and v115()) or v85.HiddenOpportunity:IsAvailable())))) then
				if (v10.Cast(v85.Shadowmeld, v31) or ((5740 - (157 + 1307)) < (4875 - (821 + 1038)))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v121()
		local v137 = v83.HandleTopTrinket(v88, v29, 99 - 59, nil);
		if (((513 + 4177) > (7326 - 3201)) and v137) then
			return v137;
		end
		local v137 = v83.HandleBottomTrinket(v88, v29, 15 + 25, nil);
		if (v137 or ((123 - 73) >= (1922 - (834 + 192)))) then
			return v137;
		end
	end
	local function v122()
		local v138 = v83.HandleDPSPotion(v16:BuffUp(v85.AdrenalineRush));
		if (v138 or ((109 + 1605) >= (760 + 2198))) then
			return "DPS Pot";
		end
		if ((v29 and v85.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v85.AdrenalineRush) and (not v115() or not v85.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v85.Crackshot:IsAvailable() and v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (1 + 1))))) or ((2309 - 818) < (948 - (300 + 4)))) then
			if (((189 + 515) < (2583 - 1596)) and v12(v85.AdrenalineRush, v76)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((4080 - (112 + 250)) > (760 + 1146)) and v85.BladeFlurry:IsReady()) then
			if (((v94 >= ((4 - 2) - v22(v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v85.AdrenalineRush)))) and (v16:BuffRemains(v85.BladeFlurry) < (2 + 1))) or ((496 + 462) > (2719 + 916))) then
				if (((1736 + 1765) <= (3338 + 1154)) and v12(v85.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v85.BladeFlurry:IsReady() or ((4856 - (1001 + 413)) < (5681 - 3133))) then
			if (((3757 - (244 + 638)) >= (2157 - (627 + 66))) and v85.DeftManeuvers:IsAvailable() and not v115() and (((v94 >= (8 - 5)) and (v99 == (v94 + v22(v16:BuffUp(v85.Broadside))))) or (v94 >= (607 - (512 + 90))))) then
				if (v12(v85.BladeFlurry) or ((6703 - (1665 + 241)) >= (5610 - (373 + 344)))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v85.RolltheBones:IsReady() or ((249 + 302) > (548 + 1520))) then
			if (((5575 - 3461) > (1597 - 653)) and (v114() or (v112() == (1099 - (35 + 1064))) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (3 + 0)) and v16:HasTier(66 - 35, 1 + 3)) or ((v11.APLVar.RtB_Buffs.MaxRemains <= (1243 - (298 + 938))) and ((v85.ShadowDance:CooldownRemains() <= (1262 - (233 + 1026))) or (v85.Vanish:CooldownRemains() <= (1669 - (636 + 1030))))))) then
				if (v12(v85.RolltheBones) or ((1157 + 1105) >= (3025 + 71))) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v139 = v121();
		if (v139 or ((670 + 1585) >= (239 + 3298))) then
			return v139;
		end
		if ((v85.KeepItRolling:IsReady() and not v114() and (v112() >= ((224 - (55 + 166)) + v22(v16:HasTier(7 + 24, 1 + 3)))) and (v16:BuffDown(v85.ShadowDance) or (v112() >= (22 - 16)))) or ((4134 - (36 + 261)) < (2283 - 977))) then
			if (((4318 - (34 + 1334)) == (1135 + 1815)) and v10.Cast(v85.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v85.GhostlyStrike:IsAvailable() and v85.GhostlyStrike:IsReady() and (v97 < (6 + 1))) or ((6006 - (1035 + 248)) < (3319 - (20 + 1)))) then
			if (((592 + 544) >= (473 - (134 + 185))) and v12(v85.GhostlyStrike, v73, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v29 and v85.Sepsis:IsAvailable() and v85.Sepsis:IsReady()) or ((1404 - (549 + 584)) > (5433 - (314 + 371)))) then
			if (((16272 - 11532) >= (4120 - (478 + 490))) and ((v85.Crackshot:IsAvailable() and v85.BetweentheEyes:IsReady() and v115() and not v16:StealthUp(true, true)) or (not v85.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 6 + 5) and v16:BuffUp(v85.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 1183 - (786 + 386)))) then
				if (v10.Cast(v85.Sepsis) or ((8350 - 5772) >= (4769 - (1055 + 324)))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((1381 - (1093 + 247)) <= (1477 + 184)) and v85.BladeRush:IsReady() and (v103 > (1 + 3)) and not v16:StealthUp(true, true)) then
			if (((2386 - 1785) < (12081 - 8521)) and v10.Cast(v85.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((668 - 433) < (1726 - 1039)) and not v16:StealthUp(true, true) and (not v85.Crackshot:IsAvailable() or v85.BetweentheEyes:IsReady())) then
			v139 = v120();
			if (((1619 + 2930) > (4441 - 3288)) and v139) then
				return v139;
			end
		end
		if ((v29 and v85.ThistleTea:IsAvailable() and v85.ThistleTea:IsCastable() and not v16:BuffUp(v85.ThistleTea) and ((v102 >= (344 - 244)) or v10.BossFilteredFightRemains("<", v85.ThistleTea:Charges() * (5 + 1)))) or ((11952 - 7278) < (5360 - (364 + 324)))) then
			if (((10055 - 6387) < (10944 - 6383)) and v10.Cast(v85.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if ((v85.BladeRush:IsCastable() and (v103 > (2 + 2)) and not v16:StealthUp(true, true)) or ((1903 - 1448) == (5773 - 2168))) then
			if (v12(v85.BladeRush, v71, nil, not v17:IsSpellInRange(v85.BladeRush)) or ((8087 - 5424) == (4580 - (1249 + 19)))) then
				return "Cast Blade Rush";
			end
		end
		if (((3861 + 416) <= (17418 - 12943)) and v85.BloodFury:IsCastable()) then
			if (v10.Cast(v85.BloodFury, nil, v31) or ((1956 - (686 + 400)) == (933 + 256))) then
				return "Cast Blood Fury";
			end
		end
		if (((1782 - (73 + 156)) <= (15 + 3118)) and v85.Berserking:IsCastable()) then
			if (v10.Cast(v85.Berserking, nil, v31) or ((3048 - (721 + 90)) >= (40 + 3471))) then
				return "Cast Berserking";
			end
		end
		if (v85.Fireblood:IsCastable() or ((4298 - 2974) > (3490 - (224 + 246)))) then
			if (v10.Cast(v85.Fireblood, nil, v31) or ((4846 - 1854) == (3463 - 1582))) then
				return "Cast Fireblood";
			end
		end
		if (((564 + 2542) > (37 + 1489)) and v85.AncestralCall:IsCastable()) then
			if (((2221 + 802) < (7694 - 3824)) and v10.Cast(v85.AncestralCall, nil, v31)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if (((656 - (203 + 310)) > (2067 - (1238 + 755))) and (v140 == (0 + 0))) then
				if (((1552 - (709 + 825)) < (3891 - 1779)) and v85.BladeFlurry:IsReady() and v85.BladeFlurry:IsCastable() and v28 and v85.Subterfuge:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and (v94 >= (2 - 0)) and (v16:BuffRemains(v85.BladeFlurry) <= (867 - (196 + 668))) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) then
					if (((4331 - 3234) <= (3371 - 1743)) and v71) then
						v10.Cast(v85.BladeFlurry);
					elseif (((5463 - (171 + 662)) == (4723 - (4 + 89))) and v10.Cast(v85.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((12407 - 8867) > (977 + 1706)) and v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch) and v115()) then
					if (((21056 - 16262) >= (1285 + 1990)) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				v140 = 1487 - (35 + 1451);
			end
			if (((2937 - (28 + 1425)) == (3477 - (941 + 1052))) and (v140 == (1 + 0))) then
				if (((2946 - (822 + 692)) < (5074 - 1519)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v115() and v85.Crackshot:IsAvailable() and (not v16:BuffUp(v85.Shadowmeld) or v16:StealthUp(true, false))) then
					if (v10.Cast(v85.BetweentheEyes) or ((502 + 563) > (3875 - (45 + 252)))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch) and v115()) or ((4745 + 50) < (485 + 922))) then
					if (((4509 - 2656) < (5246 - (114 + 319))) and v10.Press(v85.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v140 = 2 - 0;
			end
			if (((2 - 0) == v140) or ((1799 + 1022) < (3621 - 1190))) then
				if ((v17:IsSpellInRange(v85.PistolShot) and v85.Crackshot:IsAvailable() and (v85.FanTheHammer:TalentRank() >= (3 - 1)) and (v16:BuffStack(v85.Opportunity) >= (1969 - (556 + 1407))) and ((v16:BuffUp(v85.Broadside) and (v98 <= (1207 - (741 + 465)))) or v16:BuffUp(v85.GreenskinsWickersBuff))) or ((3339 - (170 + 295)) < (1150 + 1031))) then
					if (v10.Press(v85.PistolShot) or ((2470 + 219) <= (844 - 501))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((1550 + 319) == (1289 + 720))) then
					if (v10.Cast(v85.Ambush, nil, not v17:IsSpellInRange(v85.Ambush)) or ((2008 + 1538) < (3552 - (957 + 273)))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 1 + 2;
			end
			if ((v140 == (2 + 1)) or ((7933 - 5851) == (12577 - 7804))) then
				if (((9908 - 6664) > (5224 - 4169)) and v85.Ambush:IsCastable() and v17:IsSpellInRange(v85.Ambush) and v85.HiddenOpportunity:IsAvailable()) then
					if (v10.Press(v85.Ambush) or ((5093 - (389 + 1391)) <= (1116 + 662))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (0 - 0)) or ((2372 - (783 + 168)) >= (7061 - 4957))) then
				if (((1783 + 29) <= (3560 - (309 + 2))) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and not v85.Crackshot:IsAvailable() and ((v16:BuffRemains(v85.BetweentheEyes) < (12 - 8)) or v85.ImprovedBetweenTheEyes:IsAvailable() or v85.GreenskinsWickers:IsAvailable() or v16:HasTier(1242 - (1090 + 122), 2 + 2)) and v16:BuffDown(v85.GreenskinsWickers)) then
					if (((5450 - 3827) <= (1340 + 617)) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((5530 - (628 + 490)) == (792 + 3620)) and v85.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v85.BetweentheEyes) and v85.Crackshot:IsAvailable() and (v85.Vanish:CooldownRemains() > (111 - 66)) and (v85.ShadowDance:CooldownRemains() > (54 - 42))) then
					if (((2524 - (431 + 343)) >= (1700 - 858)) and v10.Press(v85.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 2 - 1;
			end
			if (((3454 + 918) > (237 + 1613)) and (v141 == (1696 - (556 + 1139)))) then
				if (((247 - (6 + 9)) < (151 + 670)) and v85.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v93, ">", v16:BuffRemains(v85.SliceandDice), true) or (v16:BuffRemains(v85.SliceandDice) == (0 + 0))) and (v16:BuffRemains(v85.SliceandDice) < (((170 - (28 + 141)) + v98) * (1.8 + 0)))) then
					if (((638 - 120) < (639 + 263)) and v10.Press(v85.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if (((4311 - (486 + 831)) > (2232 - 1374)) and v85.KillingSpree:IsCastable() and v17:IsSpellInRange(v85.KillingSpree) and (v17:DebuffUp(v85.GhostlyStrike) or not v85.GhostlyStrike:IsAvailable())) then
					if (v10.Cast(v85.KillingSpree) or ((13219 - 9464) <= (173 + 742))) then
						return "Cast Killing Spree";
					end
				end
				v141 = 6 - 4;
			end
			if (((5209 - (668 + 595)) > (3369 + 374)) and (v141 == (1 + 1))) then
				if ((v85.ColdBlood:IsCastable() and v16:BuffDown(v85.ColdBlood) and v17:IsSpellInRange(v85.Dispatch)) or ((3640 - 2305) >= (3596 - (23 + 267)))) then
					if (((6788 - (1129 + 815)) > (2640 - (371 + 16))) and v10.Cast(v85.ColdBlood, v56)) then
						return "Cast Cold Blood";
					end
				end
				if (((2202 - (1326 + 424)) == (855 - 403)) and v85.Dispatch:IsCastable() and v17:IsSpellInRange(v85.Dispatch)) then
					if (v10.Press(v85.Dispatch) or ((16652 - 12095) < (2205 - (88 + 30)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v142 = 771 - (720 + 51);
		while true do
			if (((8617 - 4743) == (5650 - (421 + 1355))) and (v142 == (1 - 0))) then
				if ((v85.FanTheHammer:IsAvailable() and v85.Audacity:IsAvailable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.Opportunity) and v16:BuffDown(v85.AudacityBuff)) or ((952 + 986) > (6018 - (286 + 797)))) then
					if (v10.Press(v85.PistolShot) or ((15554 - 11299) < (5668 - 2245))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((1893 - (397 + 42)) <= (779 + 1712)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v16:BuffStack(v85.Opportunity) >= (806 - (24 + 776))) or (v16:BuffRemains(v85.Opportunity) < (2 - 0)))) then
					if (v10.Press(v85.PistolShot) or ((4942 - (222 + 563)) <= (6175 - 3372))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v142 = 2 + 0;
			end
			if (((5043 - (23 + 167)) >= (4780 - (690 + 1108))) and (v142 == (2 + 1))) then
				if (((3410 + 724) > (4205 - (40 + 808))) and v85.SinisterStrike:IsCastable()) then
					if (v10.Press(v85.SinisterStrike) or ((563 + 2854) < (9689 - 7155))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((0 + 0) == v142) or ((1440 + 1282) <= (90 + 74))) then
				if ((v29 and v85.EchoingReprimand:IsReady()) or ((2979 - (47 + 524)) < (1369 + 740))) then
					if (v10.Cast(v85.EchoingReprimand, v77, nil, not v17:IsSpellInRange(v85.EchoingReprimand)) or ((90 - 57) == (2175 - 720))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable() and v16:BuffUp(v85.AudacityBuff)) or ((1009 - 566) >= (5741 - (1165 + 561)))) then
					if (((101 + 3281) > (514 - 348)) and v10.Press(v85.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v142 = 1 + 0;
			end
			if (((481 - (341 + 138)) == v142) or ((76 + 204) == (6312 - 3253))) then
				if (((2207 - (89 + 237)) > (4159 - 2866)) and v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v99 >= ((1 - 0) + ((v22(v85.QuickDraw:IsAvailable()) + v22(v16:BuffUp(v85.Broadside))) * (v85.FanTheHammer:TalentRank() + (882 - (581 + 300)))))) or (v98 <= (1221 - (855 + 365))))) then
					if (((5598 - 3241) == (770 + 1587)) and v10.Press(v85.PistolShot)) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((1358 - (1030 + 205)) == (116 + 7)) and not v85.FanTheHammer:IsAvailable() and v16:BuffUp(v85.Opportunity) and ((v103 > (1.5 + 0)) or (v99 <= ((287 - (156 + 130)) + v22(v16:BuffUp(v85.Broadside)))) or v85.QuickDraw:IsAvailable() or (v85.Audacity:IsAvailable() and v16:BuffDown(v85.AudacityBuff)))) then
					if (v10.Cast(v85.PistolShot) or ((2399 - 1343) >= (5716 - 2324))) then
						return "Cast Pistol Shot";
					end
				end
				v142 = 5 - 2;
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
		v104 = (v16:BuffUp(v85.AdrenalineRush, nil, true) and -(14 + 36)) or (0 + 0);
		v100 = v109();
		v101 = v16:EnergyRegen();
		v103 = v108(v104);
		v102 = v16:EnergyDeficitPredicted(nil, v104);
		if (v28 or ((1150 - (10 + 59)) < (305 + 770))) then
			v92 = v16:GetEnemiesInRange(147 - 117);
			v93 = v16:GetEnemiesInRange(v96);
			v94 = #v93;
		else
			v94 = 1164 - (671 + 492);
		end
		v95 = v84.CrimsonVial();
		if (v95 or ((836 + 213) >= (5647 - (369 + 846)))) then
			return v95;
		end
		v84.Poisons();
		if ((v33 and (v16:HealthPercentage() <= v35)) or ((1263 + 3505) <= (722 + 124))) then
			if ((v34 == "Refreshing Healing Potion") or ((5303 - (1036 + 909)) <= (1130 + 290))) then
				if (v86.RefreshingHealingPotion:IsReady() or ((6276 - 2537) <= (3208 - (11 + 192)))) then
					if (v10.Press(v87.RefreshingHealingPotion) or ((839 + 820) >= (2309 - (135 + 40)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v34 == "Dreamwalker's Healing Potion") or ((7898 - 4638) < (1420 + 935))) then
				if (v86.DreamwalkersHealingPotion:IsReady() or ((1473 - 804) == (6330 - 2107))) then
					if (v10.Press(v87.RefreshingHealingPotion) or ((1868 - (50 + 126)) < (1637 - 1049))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if ((v85.Feint:IsCastable() and v85.Feint:IsReady() and (v16:HealthPercentage() <= v59)) or ((1062 + 3735) < (5064 - (1233 + 180)))) then
			if (v10.Cast(v85.Feint) or ((5146 - (522 + 447)) > (6271 - (107 + 1314)))) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v85.Evasion:IsCastable() and v85.Evasion:IsReady() and (v16:HealthPercentage() <= v81)) or ((186 + 214) > (3385 - 2274))) then
			if (((1296 + 1755) > (1995 - 990)) and v10.Cast(v85.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((14611 - 10918) <= (6292 - (716 + 1194))) and not v16:IsCasting() and not v16:IsChanneling()) then
			local v149 = v83.Interrupt(v85.Kick, 1 + 7, true);
			if (v149 or ((352 + 2930) > (4603 - (74 + 429)))) then
				return v149;
			end
			v149 = v83.Interrupt(v85.Kick, 14 - 6, true, v13, v87.KickMouseover);
			if (v149 or ((1775 + 1805) < (6509 - 3665))) then
				return v149;
			end
			v149 = v83.Interrupt(v85.Blind, 11 + 4, v80);
			if (((274 - 185) < (11101 - 6611)) and v149) then
				return v149;
			end
			v149 = v83.Interrupt(v85.Blind, 448 - (279 + 154), v80, v13, v87.BlindMouseover);
			if (v149 or ((5761 - (454 + 324)) < (1423 + 385))) then
				return v149;
			end
			v149 = v83.InterruptWithStun(v85.CheapShot, 25 - (12 + 5), v16:StealthUp(false, false));
			if (((2065 + 1764) > (9603 - 5834)) and v149) then
				return v149;
			end
			v149 = v83.InterruptWithStun(v85.KidneyShot, 3 + 5, v16:ComboPoints() > (1093 - (277 + 816)));
			if (((6345 - 4860) <= (4087 - (1058 + 125))) and v149) then
				return v149;
			end
		end
		if (((801 + 3468) == (5244 - (815 + 160))) and v30) then
			v95 = v83.HandleIncorporeal(v85.Blind, v87.BlindMouseover, 128 - 98, true);
			if (((918 - 531) <= (664 + 2118)) and v95) then
				return v95;
			end
		end
		if ((not v16:AffectingCombat() and not v16:IsMounted() and v60) or ((5551 - 3652) <= (2815 - (41 + 1857)))) then
			local v150 = 1893 - (1222 + 671);
			while true do
				if ((v150 == (0 - 0)) or ((6197 - 1885) <= (2058 - (229 + 953)))) then
					v95 = v84.Stealth(v85.Stealth2, nil);
					if (((4006 - (1111 + 663)) <= (4175 - (874 + 705))) and v95) then
						return "Stealth (OOC): " .. v95;
					end
					break;
				end
			end
		end
		if (((294 + 1801) < (2515 + 1171)) and not v16:AffectingCombat() and (v85.Vanish:TimeSinceLastCast() > (1 - 0)) and v17:IsInRange(1 + 7) and v27) then
			if ((v83.TargetIsValid() and v17:IsInRange(689 - (642 + 37)) and not (v16:IsChanneling() or v16:IsCasting())) or ((364 + 1231) >= (716 + 3758))) then
				local v175 = 0 - 0;
				while true do
					if ((v175 == (455 - (233 + 221))) or ((10680 - 6061) < (2537 + 345))) then
						if (v83.TargetIsValid() or ((1835 - (718 + 823)) >= (3040 + 1791))) then
							local v192 = 805 - (266 + 539);
							while true do
								if (((5744 - 3715) <= (4309 - (636 + 589))) and (v192 == (2 - 1))) then
									if ((v85.SliceandDice:IsReady() and (v16:BuffRemains(v85.SliceandDice) < (((1 - 0) + v98) * (1.8 + 0)))) or ((741 + 1296) == (3435 - (657 + 358)))) then
										if (((11803 - 7345) > (8894 - 4990)) and v10.Press(v85.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (((1623 - (1151 + 36)) >= (119 + 4)) and (v16:StealthUp(true, false) or v85.Subterfuge:BuffUp())) then
										v95 = v123();
										if (((132 + 368) < (5423 - 3607)) and v95) then
											return "Stealth (Opener): " .. v95;
										end
										if (((5406 - (1552 + 280)) == (4408 - (64 + 770))) and v85.KeepItRolling:IsAvailable() and v85.GhostlyStrike:IsReady() and v85.EchoingReprimand:IsAvailable()) then
											if (((151 + 70) < (885 - 495)) and v10.Cast(v85.GhostlyStrike, nil, nil, not v17:IsSpellInRange(v85.GhostlyStrike))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v85.Ambush:IsCastable() and v85.HiddenOpportunity:IsAvailable()) or ((393 + 1820) <= (2664 - (157 + 1086)))) then
											if (((6120 - 3062) < (21285 - 16425)) and v10.Cast(v85.Ambush, nil, nil, not v17:IsSpellInRange(v85.Ambush))) then
												return "Cast Ambush (Opener)";
											end
										elseif (v85.SinisterStrike:IsCastable() or ((1987 - 691) >= (6067 - 1621))) then
											if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((2212 - (599 + 220)) > (8938 - 4449))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
									elseif (v115() or ((6355 - (1813 + 118)) < (20 + 7))) then
										v95 = v124();
										if (v95 or ((3214 - (841 + 376)) > (5345 - 1530))) then
											return "Finish (Opener): " .. v95;
										end
									end
									v192 = 1 + 1;
								end
								if (((9457 - 5992) > (2772 - (464 + 395))) and (v192 == (5 - 3))) then
									if (((353 + 380) < (2656 - (467 + 370))) and v85.SinisterStrike:IsCastable()) then
										if (v10.Cast(v85.SinisterStrike, nil, nil, not v17:IsSpellInRange(v85.SinisterStrike)) or ((9082 - 4687) == (3491 + 1264))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if ((v192 == (0 - 0)) or ((592 + 3201) < (5511 - 3142))) then
									if ((v85.ImprovedAdrenalineRush:IsAvailable() and (v98 <= (522 - (150 + 370)))) or ((5366 - (74 + 1208)) == (651 - 386))) then
										if (((20668 - 16310) == (3101 + 1257)) and v10.Cast(v85.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v85.RolltheBones:IsReady() and not v16:DebuffUp(v85.Dreadblades) and ((v112() == (390 - (14 + 376))) or v114())) or ((5442 - 2304) < (643 + 350))) then
										if (((2926 + 404) > (2216 + 107)) and v10.Cast(v85.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v192 = 2 - 1;
								end
							end
						end
						return;
					end
					if ((v175 == (0 + 0)) or ((3704 - (23 + 55)) == (9453 - 5464))) then
						if ((v85.BladeFlurry:IsReady() and v16:BuffDown(v85.BladeFlurry) and v85.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v85.AdrenalineRush:IsReady() or v16:BuffUp(v85.AdrenalineRush))) or ((612 + 304) == (2399 + 272))) then
							if (((421 - 149) == (86 + 186)) and v10.Press(v85.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((5150 - (652 + 249)) <= (12949 - 8110)) and not v16:StealthUp(true, false)) then
							local v193 = 1868 - (708 + 1160);
							while true do
								if (((7537 - 4760) < (5834 - 2634)) and (v193 == (27 - (10 + 17)))) then
									v95 = v84.Stealth(v85.Stealth);
									if (((22 + 73) < (3689 - (1400 + 332))) and v95) then
										return v95;
									end
									break;
								end
							end
						end
						v175 = 1 - 0;
					end
				end
			end
		end
		if (((2734 - (242 + 1666)) < (735 + 982)) and v85.FanTheHammer:IsAvailable() and (v85.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) then
			v98 = v26(v98, v84.FanTheHammerCP());
			v97 = v84.EffectiveComboPoints(v98);
			v99 = v16:ComboPointsDeficit();
		end
		if (((523 + 903) >= (942 + 163)) and v83.TargetIsValid()) then
			v95 = v122();
			if (((3694 - (850 + 90)) <= (5917 - 2538)) and v95) then
				return "CDs: " .. v95;
			end
			if (v16:StealthUp(true, true) or v16:BuffUp(v85.Shadowmeld) or ((5317 - (360 + 1030)) == (1251 + 162))) then
				local v176 = 0 - 0;
				while true do
					if ((v176 == (0 - 0)) or ((2815 - (909 + 752)) <= (2011 - (109 + 1114)))) then
						v95 = v123();
						if (v95 or ((3007 - 1364) > (1316 + 2063))) then
							return "Stealth: " .. v95;
						end
						break;
					end
				end
			end
			if (v115() or ((3045 - (6 + 236)) > (2867 + 1682))) then
				local v177 = 0 + 0;
				while true do
					if ((v177 == (0 - 0)) or ((384 - 164) >= (4155 - (1076 + 57)))) then
						v95 = v124();
						if (((465 + 2357) == (3511 - (579 + 110))) and v95) then
							return "Finish: " .. v95;
						end
						v177 = 1 + 0;
					end
					if ((v177 == (1 + 0)) or ((564 + 497) == (2264 - (174 + 233)))) then
						return "Finish Pooling";
					end
				end
			end
			v95 = v125();
			if (((7709 - 4949) > (2393 - 1029)) and v95) then
				return "Build: " .. v95;
			end
			if ((v85.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike) and (v102 > (7 + 8 + v101))) or ((6076 - (663 + 511)) <= (3208 + 387))) then
				if (v10.Cast(v85.ArcaneTorrent, v31) or ((837 + 3015) == (903 - 610))) then
					return "Cast Arcane Torrent";
				end
			end
			if ((v85.ArcanePulse:IsCastable() and v17:IsSpellInRange(v85.SinisterStrike)) or ((945 + 614) == (10801 - 6213))) then
				if (v10.Cast(v85.ArcanePulse) or ((10854 - 6370) == (377 + 411))) then
					return "Cast Arcane Pulse";
				end
			end
			if (((8890 - 4322) >= (2785 + 1122)) and v85.LightsJudgment:IsCastable() and v17:IsInMeleeRange(1 + 4)) then
				if (((1968 - (478 + 244)) < (3987 - (440 + 77))) and v10.Cast(v85.LightsJudgment, v31)) then
					return "Cast Lights Judgment";
				end
			end
			if (((1850 + 2218) >= (3557 - 2585)) and v85.BagofTricks:IsCastable() and v17:IsInMeleeRange(1561 - (655 + 901))) then
				if (((92 + 401) < (2981 + 912)) and v10.Cast(v85.BagofTricks, v31)) then
					return "Cast Bag of Tricks";
				end
			end
			if ((v17:IsSpellInRange(v85.PistolShot) and not v17:IsInRange(v96) and not v16:StealthUp(true, true) and (v102 < (17 + 8)) and ((v99 >= (3 - 2)) or (v103 <= (1446.2 - (695 + 750))))) or ((5029 - 3556) >= (5141 - 1809))) then
				if (v10.Cast(v85.PistolShot) or ((16292 - 12241) <= (1508 - (285 + 66)))) then
					return "Cast Pistol Shot (OOR)";
				end
			end
			if (((1407 - 803) < (4191 - (682 + 628))) and v85.SinisterStrike:IsCastable()) then
				if (v10.Cast(v85.SinisterStrike) or ((146 + 754) == (3676 - (176 + 123)))) then
					return "Cast Sinister Strike Filler";
				end
			end
		end
	end
	local function v127()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(109 + 151, v126, v127);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

