local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((145 + 53) <= (5538 - (257 + 916))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Cast;
	local v12 = v9.Mouseover;
	local v13 = v9.Utils;
	local v14 = v9.Unit;
	local v15 = v14.Player;
	local v16 = v14.Target;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Macro;
	local v21 = v9.Commons.Everyone.num;
	local v22 = v9.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
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
	local v78;
	local v79;
	local v80;
	local function v81()
		local v127 = 0 + 0;
		while true do
			if (((2662 + 2120) > (3609 + 1067)) and (v127 == (8 + 0))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 34 - 25;
			end
			if (((5415 - (83 + 468)) > (4003 - (1202 + 604))) and (v127 == (27 - 21))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 11 - 4;
			end
			if ((v127 == (2 - 1)) or ((4025 - (45 + 280)) == (2420 + 87))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v127 = 2 + 0;
			end
			if (((787 + 3687) >= (506 - 232)) and (v127 == (1911 - (340 + 1571)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1 + 0;
			end
			if ((v127 == (1781 - (1733 + 39))) or ((5204 - 3310) <= (2440 - (125 + 909)))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (1948 - (1096 + 852));
				break;
			end
			if (((706 + 866) >= (2186 - 655)) and (v127 == (7 + 0))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 520 - (409 + 103);
			end
			if ((v127 == (241 - (46 + 190))) or ((4782 - (51 + 44)) < (1282 + 3260))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1317 - (1114 + 203));
				v58 = EpicSettings.Settings['FeintHP'] or (726 - (228 + 498));
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 2 + 4;
			end
			if (((1819 + 1472) > (2330 - (174 + 489))) and (v127 == (7 - 4))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 1909 - (830 + 1075);
			end
			if ((v127 == (526 - (303 + 221))) or ((2142 - (231 + 1038)) == (1695 + 339))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1162 - (171 + 991));
				v127 = 12 - 9;
			end
			if ((v127 == (10 - 6)) or ((7027 - 4211) < (9 + 2))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 17 - 12;
			end
		end
	end
	local v82 = v9.Commons.Everyone;
	local v83 = v9.Commons.Rogue;
	local v84 = v17.Rogue.Outlaw;
	local v85 = v19.Rogue.Outlaw;
	local v86 = v20.Rogue.Outlaw;
	local v87 = {};
	local v88 = v15:GetEquipment();
	local v89 = (v88[37 - 24] and v19(v88[20 - 7])) or v19(0 - 0);
	local v90 = (v88[1262 - (111 + 1137)] and v19(v88[172 - (91 + 67)])) or v19(0 - 0);
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[4 + 9] and v19(v88[536 - (423 + 100)])) or v19(0 + 0);
		v90 = (v88[38 - 24] and v19(v88[8 + 6])) or v19(771 - (326 + 445));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 26 - 20;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 0 - 0, 0 - 0;
	local function v107(v128)
		local v129 = 1812 - (1293 + 519);
		local v130;
		while true do
			if (((7546 - 3847) < (12287 - 7581)) and (v129 == (1 - 0))) then
				return v105;
			end
			if (((11409 - 8763) >= (2063 - 1187)) and (v129 == (0 + 0))) then
				v130 = v15:EnergyTimeToMaxPredicted(nil, v128);
				if (((126 + 488) <= (7397 - 4213)) and ((v130 < v105) or ((v130 - v105) > (0.5 + 0)))) then
					v105 = v130;
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v108()
		local v131 = v15:EnergyPredicted();
		if (((1954 + 1172) == (4222 - (709 + 387))) and ((v131 > v106) or ((v131 - v106) > (1867 - (673 + 1185))))) then
			v106 = v131;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (not v10.APLVar.RtB_Buffs or ((538 + 1649) >= (9877 - 4923))) then
			v10.APLVar.RtB_Buffs = {};
			v10.APLVar.RtB_Buffs.Will_Lose = {};
			v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 - 0;
			v10.APLVar.RtB_Buffs.Total = 1880 - (446 + 1434);
			v10.APLVar.RtB_Buffs.Normal = 1283 - (1040 + 243);
			v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
			v10.APLVar.RtB_Buffs.Longer = 1847 - (559 + 1288);
			v10.APLVar.RtB_Buffs.MaxRemains = 1931 - (609 + 1322);
			local v151 = v83.RtBRemains();
			for v176 = 455 - (13 + 441), #v109 do
				local v177 = 0 - 0;
				local v178;
				while true do
					if ((v177 == (0 - 0)) or ((19309 - 15432) == (134 + 3441))) then
						v178 = v15:BuffRemains(v109[v176]);
						if (((2567 - 1860) > (225 + 407)) and (v178 > (0 + 0))) then
							v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (2 - 1);
							if ((v178 > v10.APLVar.RtB_Buffs.MaxRemains) or ((299 + 247) >= (4936 - 2252))) then
								v10.APLVar.RtB_Buffs.MaxRemains = v178;
							end
							local v190 = math.abs(v178 - v151);
							if (((969 + 496) <= (2393 + 1908)) and (v190 <= (0.5 + 0))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v176]:Name()] = true;
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
							elseif (((2137 - (153 + 280)) > (4114 - 2689)) and (v178 > v151)) then
								v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
							else
								v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + 1 + 0;
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v176]:Name()] = true;
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
							end
						end
						v177 = 1 + 0;
					end
					if ((v177 == (1 + 0)) or ((1045 - 358) == (2617 + 1617))) then
						if (v110 or ((3997 - (89 + 578)) < (1021 + 408))) then
							local v191 = 0 - 0;
							while true do
								if (((2196 - (572 + 477)) >= (46 + 289)) and (v191 == (0 + 0))) then
									print("RtbRemains", v151);
									print(v109[v176]:Name(), v178);
									break;
								end
							end
						end
						break;
					end
				end
			end
			if (((411 + 3024) > (2183 - (84 + 2))) and v110) then
				local v182 = 0 - 0;
				while true do
					if (((1 + 0) == v182) or ((4612 - (497 + 345)) >= (104 + 3937))) then
						print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v10.APLVar.RtB_Buffs.Normal);
						v182 = 1 + 1;
					end
					if ((v182 == (1335 - (605 + 728))) or ((2705 + 1086) <= (3581 - 1970))) then
						print("longer: ", v10.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
						break;
					end
					if ((v182 == (0 + 0)) or ((16925 - 12347) <= (1811 + 197))) then
						print("have: ", v10.APLVar.RtB_Buffs.Total);
						print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
						v182 = 2 - 1;
					end
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v132)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v132] and true) or false;
	end
	local function v113()
		local v133 = 0 + 0;
		while true do
			if (((1614 - (457 + 32)) <= (881 + 1195)) and (v133 == (1402 - (832 + 570)))) then
				if (not v10.APLVar.RtB_Reroll or ((700 + 43) >= (1148 + 3251))) then
					if (((4087 - 2932) < (806 + 867)) and (v64 == "1+ Buff")) then
						v10.APLVar.RtB_Reroll = ((v111() <= (796 - (588 + 208))) and true) or false;
					elseif ((v64 == "Broadside") or ((6263 - 3939) <= (2378 - (884 + 916)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif (((7886 - 4119) == (2185 + 1582)) and (v64 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((4742 - (232 + 421)) == (5978 - (1569 + 320))) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif (((1094 + 3364) >= (319 + 1355)) and (v64 == "Skull and Crossbones")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif (((3275 - 2303) <= (2023 - (316 + 289))) and (v64 == "Ruthless Precision")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((12926 - 7988) < (220 + 4542))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						local v211 = 1453 - (666 + 787);
						while true do
							if ((v211 == (426 - (360 + 65))) or ((2341 + 163) > (4518 - (79 + 175)))) then
								v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (2 - 0))));
								if (((1681 + 472) == (6599 - 4446)) and v84.Crackshot:IsAvailable() and not v15:HasTier(59 - 28, 903 - (503 + 396))) then
									v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (182 - (92 + 89))));
								end
								v211 = 3 - 1;
							end
							if ((v211 == (2 + 0)) or ((301 + 206) >= (10146 - 7555))) then
								if (((613 + 3868) == (10217 - 5736)) and v84.Crackshot:IsAvailable() and v15:HasTier(28 + 3, 2 + 2)) then
									v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((2 - 1) + v21(v15:BuffUp(v84.LoadedDiceBuff)));
								end
								if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < (1 + 1 + v21(v112(v84.GrandMelee)))) and (v93 < (2 - 0))) or ((3572 - (485 + 759)) < (1603 - 910))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v211 = 1192 - (442 + 747);
							end
							if (((5463 - (832 + 303)) == (5274 - (88 + 858))) and (v211 == (1 + 2))) then
								v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (790 - (766 + 23))) and (v111() < (29 - 23)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (52 - 13)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
								if (((4183 - 2595) >= (4520 - 3188)) and (v16:FilteredTimeToDie("<", 1085 - (1036 + 37)) or v9.BossFilteredFightRemains("<", 9 + 3))) then
									v10.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if ((v211 == (0 - 0)) or ((3284 + 890) > (5728 - (641 + 839)))) then
								v10.APLVar.RtB_Reroll = false;
								v111();
								v211 = 914 - (910 + 3);
							end
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (2 - 1)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((1686 - (1466 + 218)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (23 + 27));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (1150 - (556 + 592))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (810 - (329 + 479))) or ((5440 - (174 + 680)) <= (281 - 199))) then
				if (((8006 - 4143) == (2759 + 1104)) and v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (769 - (396 + 343))) or ((v84.KeepItRolling:CooldownRemains() >= (11 + 109)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((1759 - (29 + 1448)) <= (1431 - (135 + 1254)))) then
						return "Cast Shadow Dance";
					end
				end
				if (((17362 - 12753) >= (3576 - 2810)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
					if ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())) or ((768 + 384) == (4015 - (389 + 1138)))) then
						if (((3996 - (102 + 472)) > (3162 + 188)) and v9.Cast(v84.Shadowmeld, v30)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((487 + 390) > (351 + 25)) and (v134 == (1545 - (320 + 1225)))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (10 - 4))) and v115()) or ((1908 + 1210) <= (3315 - (157 + 1307)))) then
					if (v9.Cast(v84.Vanish, v67) or ((2024 - (821 + 1038)) >= (8712 - 5220))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((432 + 3517) < (8624 - 3768)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (v9.Cast(v84.Vanish, v67) or ((1591 + 2685) < (7475 - 4459))) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 1027 - (834 + 192);
			end
			if (((299 + 4391) > (1059 + 3066)) and (v134 == (1 + 0))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (8 - 2)) or not v67) and not v15:StealthUp(true, false)) or ((354 - (300 + 4)) >= (240 + 656))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((4486 - 2772) >= (3320 - (112 + 250)))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((595 + 896) < (1612 - 968))) then
					if (((404 + 300) < (511 + 476)) and v11(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 2 + 0;
			end
		end
	end
	local function v120()
		local v135 = 0 + 0;
		local v136;
		while true do
			if (((2763 + 955) > (3320 - (1001 + 413))) and (v135 == (0 - 0))) then
				v136 = v82.HandleTopTrinket(v87, v28, 922 - (244 + 638), nil);
				if (v136 or ((1651 - (627 + 66)) > (10830 - 7195))) then
					return v136;
				end
				v135 = 603 - (512 + 90);
			end
			if (((5407 - (1665 + 241)) <= (5209 - (373 + 344))) and (v135 == (1 + 0))) then
				v136 = v82.HandleBottomTrinket(v87, v28, 11 + 29, nil);
				if (v136 or ((9078 - 5636) < (4311 - 1763))) then
					return v136;
				end
				break;
			end
		end
	end
	local function v121()
		local v137 = 1099 - (35 + 1064);
		local v138;
		local v139;
		while true do
			if (((2092 + 783) >= (3131 - 1667)) and (v137 == (1 + 0))) then
				if (v84.BladeFlurry:IsReady() or ((6033 - (298 + 938)) >= (6152 - (233 + 1026)))) then
					if (((v93 >= ((1668 - (636 + 1030)) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((282 + 269) > (2020 + 48))) then
						if (((628 + 1486) > (64 + 880)) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (v84.BladeFlurry:IsReady() or ((2483 - (55 + 166)) >= (600 + 2496))) then
					if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1 + 2)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (18 - 13)))) or ((2552 - (36 + 261)) >= (6185 - 2648))) then
						if (v11(v84.BladeFlurry) or ((5205 - (34 + 1334)) < (503 + 803))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((2293 + 657) == (4233 - (1035 + 248))) and v84.RolltheBones:IsReady()) then
					if (v113() or (v111() == (21 - (20 + 1))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (2 + 1)) and v15:HasTier(350 - (134 + 185), 1137 - (549 + 584))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (692 - (314 + 371))) and ((v84.ShadowDance:CooldownRemains() <= (10 - 7)) or (v84.Vanish:CooldownRemains() <= (971 - (478 + 490))))) or ((2502 + 2221) < (4470 - (786 + 386)))) then
						if (((3679 - 2543) >= (1533 - (1055 + 324))) and v11(v84.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v137 = 1342 - (1093 + 247);
			end
			if (((5 + 0) == v137) or ((29 + 242) > (18850 - 14102))) then
				if (((16086 - 11346) >= (8968 - 5816)) and v84.BloodFury:IsCastable()) then
					if (v9.Cast(v84.BloodFury, v30) or ((6478 - 3900) >= (1206 + 2184))) then
						return "Cast Blood Fury";
					end
				end
				if (((157 - 116) <= (5725 - 4064)) and v84.Berserking:IsCastable()) then
					if (((454 + 147) < (9104 - 5544)) and v9.Cast(v84.Berserking, v30)) then
						return "Cast Berserking";
					end
				end
				if (((923 - (364 + 324)) < (1883 - 1196)) and v84.Fireblood:IsCastable()) then
					if (((10915 - 6366) > (383 + 770)) and v9.Cast(v84.Fireblood, v30)) then
						return "Cast Fireblood";
					end
				end
				v137 = 24 - 18;
			end
			if ((v137 == (5 - 1)) or ((14195 - 9521) < (5940 - (1249 + 19)))) then
				if (((3311 + 357) < (17753 - 13192)) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
					local v183 = 1086 - (686 + 400);
					while true do
						if ((v183 == (0 + 0)) or ((684 - (73 + 156)) == (18 + 3587))) then
							v139 = v119();
							if (v139 or ((3474 - (721 + 90)) == (38 + 3274))) then
								return v139;
							end
							break;
						end
					end
				end
				if (((13886 - 9609) <= (4945 - (224 + 246))) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (162 - 62)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (10 - 4)))) then
					if (v9.Cast(v84.ThistleTea) or ((158 + 712) == (29 + 1160))) then
						return "Cast Thistle Tea";
					end
				end
				if (((1141 + 412) <= (6228 - 3095)) and v84.BladeRush:IsCastable() and (v102 > (12 - 8)) and not v15:StealthUp(true, true)) then
					if (v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush)) or ((2750 - (203 + 310)) >= (5504 - (1238 + 755)))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 1 + 4;
			end
			if ((v137 == (1534 - (709 + 825))) or ((2439 - 1115) > (4399 - 1379))) then
				v138 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (v138 or ((3856 - (196 + 668)) == (7426 - 5545))) then
					return "DPS Pot";
				end
				if (((6433 - 3327) > (2359 - (171 + 662))) and v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (95 - (4 + 89)))))) then
					if (((10595 - 7572) < (1410 + 2460)) and v11(v84.AdrenalineRush, v75)) then
						return "Cast Adrenaline Rush";
					end
				end
				v137 = 4 - 3;
			end
			if (((57 + 86) > (1560 - (35 + 1451))) and ((1459 - (28 + 1425)) == v137)) then
				if (((2011 - (941 + 1052)) < (2026 + 86)) and v84.AncestralCall:IsCastable()) then
					if (((2611 - (822 + 692)) <= (2323 - 695)) and v9.Cast(v84.AncestralCall, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((2181 + 2449) == (4927 - (45 + 252))) and (v137 == (2 + 0))) then
				v139 = v120();
				if (((1219 + 2321) > (6529 - 3846)) and v139) then
					return v139;
				end
				if (((5227 - (114 + 319)) >= (4701 - 1426)) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((3 - 0) + v21(v15:HasTier(20 + 11, 5 - 1)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (12 - 6)))) then
					if (((3447 - (556 + 1407)) == (2690 - (741 + 465))) and v9.Cast(v84.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				v137 = 468 - (170 + 295);
			end
			if (((755 + 677) < (3266 + 289)) and (v137 == (7 - 4))) then
				if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (6 + 1))) or ((683 + 382) > (2027 + 1551))) then
					if (v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((6025 - (957 + 273)) < (377 + 1030))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((742 + 1111) < (18339 - 13526)) and v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 28 - 17) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 33 - 22) or ((13968 - 11147) < (4211 - (389 + 1391)))) then
						if (v9.Cast(v84.Sepsis) or ((1804 + 1070) < (228 + 1953))) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v84.BladeRush:IsReady() and (v102 > (8 - 4)) and not v15:StealthUp(true, true)) or ((3640 - (783 + 168)) <= (1150 - 807))) then
					if (v9.Cast(v84.BladeRush) or ((1839 + 30) == (2320 - (309 + 2)))) then
						return "Cast Blade Rush";
					end
				end
				v137 = 12 - 8;
			end
		end
	end
	local function v122()
		local v140 = 1212 - (1090 + 122);
		while true do
			if (((1 + 0) == v140) or ((11909 - 8363) < (1590 + 732))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((3200 - (628 + 490)) == (856 + 3917))) then
					if (((8031 - 4787) > (4821 - 3766)) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((4087 - (431 + 343)) <= (3590 - 1812))) then
					if (v9.Press(v84.Dispatch) or ((4110 - 2689) >= (1663 + 441))) then
						return "Cast Dispatch";
					end
				end
				v140 = 1 + 1;
			end
			if (((3507 - (556 + 1139)) <= (3264 - (6 + 9))) and (v140 == (1 + 2))) then
				if (((832 + 791) <= (2126 - (28 + 141))) and v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
					if (((1709 + 2703) == (5445 - 1033)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((1240 + 510) >= (2159 - (486 + 831))) and (v140 == (0 - 0))) then
				if (((15392 - 11020) > (350 + 1500)) and v84.BladeFlurry:IsReady()) then
					if (((733 - 501) < (2084 - (668 + 595))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (3 + 0)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (2 + 3)))) then
						if (((1412 - 894) < (1192 - (23 + 267))) and v11(v84.BladeFlurry, v70)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((4938 - (1129 + 815)) > (1245 - (371 + 16))) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (v9.Cast(v84.ColdBlood, v55) or ((5505 - (1326 + 424)) <= (1732 - 817))) then
						return "Cast Cold Blood";
					end
				end
				v140 = 3 - 2;
			end
			if (((4064 - (88 + 30)) > (4514 - (720 + 51))) and (v140 == (4 - 2))) then
				if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1778 - (421 + 1355))) and (v15:BuffStack(v84.Opportunity) >= (9 - 3)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) or ((2418 - (286 + 797)) >= (12085 - 8779))) then
					if (((8023 - 3179) > (2692 - (397 + 42))) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((142 + 310) == (1252 - (24 + 776))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v11(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush)) or ((7019 - 2462) < (2872 - (222 + 563)))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v140 = 6 - 3;
			end
		end
	end
	local function v123()
		local v141 = 0 + 0;
		while true do
			if (((4064 - (23 + 167)) == (5672 - (690 + 1108))) and ((1 + 0) == v141)) then
				if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v15:BuffRemains(v84.SliceandDice) < (((849 - (40 + 808)) + v97) * (1.8 + 0)))) or ((7410 - 5472) > (4717 + 218))) then
					if (v9.Press(v84.SliceandDice) or ((2251 + 2004) < (1878 + 1545))) then
						return "Cast Slice and Dice";
					end
				end
				if (((2025 - (47 + 524)) <= (1617 + 874)) and v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
					if (v9.Cast(v84.KillingSpree) or ((11363 - 7206) <= (4191 - 1388))) then
						return "Cast Killing Spree";
					end
				end
				v141 = 4 - 2;
			end
			if (((6579 - (1165 + 561)) >= (89 + 2893)) and (v141 == (0 - 0))) then
				if (((1578 + 2556) > (3836 - (341 + 138))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (2 + 2)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(61 - 31, 330 - (89 + 237))) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (v9.Press(v84.BetweentheEyes) or ((10992 - 7575) < (5334 - 2800))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (926 - (581 + 300))) and (v84.ShadowDance:CooldownRemains() > (1232 - (855 + 365)))) or ((6465 - 3743) <= (54 + 110))) then
					if (v9.Press(v84.BetweentheEyes) or ((3643 - (1030 + 205)) < (1980 + 129))) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (288 - (156 + 130))) or ((74 - 41) == (2452 - 997))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((907 - 464) >= (1058 + 2957))) then
					if (((1973 + 1409) > (235 - (10 + 59))) and v9.Cast(v84.ColdBlood, v55)) then
						return "Cast Cold Blood";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((80 + 200) == (15064 - 12005))) then
					if (((3044 - (671 + 492)) > (1030 + 263)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if (((3572 - (369 + 846)) == (624 + 1733)) and v28 and v84.EchoingReprimand:IsReady()) then
			if (((105 + 18) == (2068 - (1036 + 909))) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((840 + 216) >= (5694 - 2302))) then
			if (v9.Press(v84.Ambush) or ((1284 - (11 + 192)) < (544 + 531))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v84.PistolShot:IsCastable() and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((1224 - (135 + 40)) >= (10738 - 6306))) then
			if (v9.Press(v84.PistolShot) or ((2874 + 1894) <= (1863 - 1017))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v84.PistolShot:IsCastable() and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (8 - 2)) or (v15:BuffRemains(v84.Opportunity) < (178 - (50 + 126))))) or ((9350 - 5992) <= (315 + 1105))) then
			if (v9.Press(v84.PistolShot) or ((5152 - (1233 + 180)) <= (3974 - (522 + 447)))) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v84.PistolShot:IsCastable() and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1422 - (107 + 1314)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) or ((5054 - 3395) >= (907 + 1227))) then
			if (v9.Press(v84.PistolShot) or ((6473 - 3213) < (9317 - 6962))) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if ((v84.PistolShot:IsCastable() and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (1911.5 - (716 + 1194))) or (v98 <= (1 + 0 + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((72 + 597) == (4726 - (74 + 429)))) then
			if (v9.Cast(v84.PistolShot) or ((3263 - 1571) < (292 + 296))) then
				return "Cast Pistol Shot";
			end
		end
		if (v84.SinisterStrike:IsCastable() or ((10980 - 6183) < (2584 + 1067))) then
			if (v9.Press(v84.SinisterStrike) or ((12877 - 8700) > (11992 - 7142))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		local v142 = 433 - (279 + 154);
		while true do
			if ((v142 == (784 - (454 + 324))) or ((315 + 85) > (1128 - (12 + 5)))) then
				if (((1645 + 1406) > (2560 - 1555)) and v82.TargetIsValid()) then
					local v184 = 0 + 0;
					while true do
						if (((4786 - (277 + 816)) <= (18724 - 14342)) and (v184 == (1183 - (1058 + 125)))) then
							v94 = v121();
							if (v94 or ((616 + 2666) > (5075 - (815 + 160)))) then
								return "CDs: " .. v94;
							end
							if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((15360 - 11780) < (6751 - 3907))) then
								v94 = v122();
								if (((22 + 67) < (13124 - 8634)) and v94) then
									return "Stealth: " .. v94;
								end
							end
							v184 = 1899 - (41 + 1857);
						end
						if ((v184 == (1895 - (1222 + 671))) or ((12878 - 7895) < (2598 - 790))) then
							if (((5011 - (229 + 953)) > (5543 - (1111 + 663))) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((1594 - (874 + 705)) + v100))) then
								if (((208 + 1277) <= (1982 + 922)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((8873 - 4604) == (121 + 4148)) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
								if (((1066 - (642 + 37)) <= (635 + 2147)) and v9.Cast(v84.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(1 + 4)) or ((4767 - 2868) <= (1371 - (233 + 221)))) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((9970 - 5658) <= (772 + 104))) then
									return "Cast Lights Judgment";
								end
							end
							v184 = 1544 - (718 + 823);
						end
						if (((1405 + 827) <= (3401 - (266 + 539))) and (v184 == (2 - 1))) then
							if (((3320 - (636 + 589)) < (8749 - 5063)) and v114()) then
								local v199 = 0 - 0;
								while true do
									if ((v199 == (0 + 0)) or ((580 + 1015) >= (5489 - (657 + 358)))) then
										v94 = v123();
										if (v94 or ((12229 - 7610) < (6565 - 3683))) then
											return "Finish: " .. v94;
										end
										v199 = 1188 - (1151 + 36);
									end
									if ((v199 == (1 + 0)) or ((78 + 216) >= (14427 - 9596))) then
										return "Finish Pooling";
									end
								end
							end
							v94 = v124();
							if (((3861 - (1552 + 280)) <= (3918 - (64 + 770))) and v94) then
								return "Build: " .. v94;
							end
							v184 = 2 + 0;
						end
						if ((v184 == (6 - 3)) or ((362 + 1675) == (3663 - (157 + 1086)))) then
							if (((8923 - 4465) > (17098 - 13194)) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(7 - 2)) then
								if (((594 - 158) >= (942 - (599 + 220))) and v9.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if (((995 - 495) < (3747 - (1813 + 118))) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (19 + 6)) and ((v98 >= (1218 - (841 + 376))) or (v102 <= (1.2 - 0)))) then
								if (((831 + 2743) == (9755 - 6181)) and v9.Cast(v84.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1080 - (464 + 395)) < (1000 - 610)) and (v142 == (1 + 1))) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v142 = 840 - (467 + 370);
			end
			if ((v142 == (5 - 2)) or ((1625 + 588) <= (4871 - 3450))) then
				if (((478 + 2580) < (11307 - 6447)) and v27) then
					v91 = v15:GetEnemiesInRange(550 - (150 + 370));
					v92 = v15:GetEnemiesInRange(v95);
					v93 = #v92;
				else
					v93 = 1283 - (74 + 1208);
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((3187 - 1891) >= (21085 - 16639))) then
					return v94;
				end
				v83.Poisons();
				v142 = 3 + 1;
			end
			if ((v142 == (390 - (14 + 376))) or ((2415 - 1022) > (2905 + 1584))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v142 = 1 + 0;
			end
			if ((v142 == (5 + 0)) or ((12962 - 8538) < (21 + 6))) then
				if (v29 or ((2075 - (23 + 55)) > (9041 - 5226))) then
					local v185 = 0 + 0;
					while true do
						if (((3112 + 353) > (2965 - 1052)) and (v185 == (0 + 0))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 931 - (652 + 249), true);
							if (((1961 - 1228) < (3687 - (708 + 1160))) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and not v15:IsMounted() and v59) or ((11929 - 7534) == (8669 - 3914))) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (v94 or ((3820 - (10 + 17)) < (533 + 1836))) then
						return "Stealth (OOC): " .. v94;
					end
				end
				if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1733 - (1400 + 332))) and v16:IsInRange(15 - 7) and v26) or ((5992 - (242 + 1666)) == (114 + 151))) then
					if (((1598 + 2760) == (3715 + 643)) and v82.TargetIsValid() and v16:IsInRange(950 - (850 + 90)) and not (v15:IsChanneling() or v15:IsCasting())) then
						if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((5495 - 2357) < (2383 - (360 + 1030)))) then
							if (((2947 + 383) > (6556 - 4233)) and v11(v84.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v15:StealthUp(true, false) or ((4988 - 1362) == (5650 - (909 + 752)))) then
							local v193 = 1223 - (109 + 1114);
							while true do
								if ((v193 == (0 - 0)) or ((357 + 559) == (2913 - (6 + 236)))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (((172 + 100) == (219 + 53)) and v94) then
										return v94;
									end
									break;
								end
							end
						end
						if (((10020 - 5771) <= (8451 - 3612)) and v82.TargetIsValid()) then
							local v194 = 1133 - (1076 + 57);
							while true do
								if (((457 + 2320) < (3889 - (579 + 110))) and (v194 == (0 + 0))) then
									if (((84 + 11) < (1039 + 918)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (407 - (174 + 233))) or v113())) then
										if (((2307 - 1481) < (3013 - 1296)) and v9.Cast(v84.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if (((635 + 791) >= (2279 - (663 + 511))) and v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))) then
										if (((598 + 2156) <= (10417 - 7038)) and v9.Cast(v84.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									v194 = 1 + 0;
								end
								if ((v194 == (4 - 2)) or ((9506 - 5579) == (675 + 738))) then
									if (v84.SinisterStrike:IsCastable() or ((2245 - 1091) <= (562 + 226))) then
										if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((151 + 1492) > (4101 - (478 + 244)))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if ((v194 == (518 - (440 + 77))) or ((1275 + 1528) > (16649 - 12100))) then
									if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((1557 - (655 + 901)) + v97) * (1.8 + 0)))) or ((169 + 51) >= (2041 + 981))) then
										if (((11368 - 8546) == (4267 - (695 + 750))) and v9.Press(v84.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v15:StealthUp(true, false) or ((3622 - 2561) == (2865 - 1008))) then
										local v206 = 0 - 0;
										while true do
											if (((3111 - (285 + 66)) > (3179 - 1815)) and (v206 == (1310 - (682 + 628)))) then
												v94 = v122();
												if (v94 or ((791 + 4111) <= (3894 - (176 + 123)))) then
													return "Stealth (Opener): " .. v94;
												end
												v206 = 1 + 0;
											end
											if ((v206 == (1 + 0)) or ((4121 - (239 + 30)) == (80 + 213))) then
												if ((v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) or ((1499 + 60) == (8120 - 3532))) then
													if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((13989 - 9505) == (1103 - (306 + 9)))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (((15940 - 11372) >= (680 + 3227)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
													if (((765 + 481) < (1671 + 1799)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((11632 - 7564) >= (2347 - (1140 + 235))) and v84.SinisterStrike:IsCastable()) then
													if (((314 + 179) < (3570 + 323)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
												break;
											end
										end
									elseif (v114() or ((379 + 1094) >= (3384 - (33 + 19)))) then
										local v208 = 0 + 0;
										while true do
											if ((v208 == (0 - 0)) or ((1785 + 2266) <= (2268 - 1111))) then
												v94 = v123();
												if (((567 + 37) < (3570 - (586 + 103))) and v94) then
													return "Finish (Opener): " .. v94;
												end
												break;
											end
										end
									end
									v194 = 1 + 1;
								end
							end
						end
						return;
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) or ((2770 - 1870) == (4865 - (1309 + 179)))) then
					v97 = v25(v97, v83.FanTheHammerCP());
					v96 = v83.EffectiveComboPoints(v97);
					v98 = v15:ComboPointsDeficit();
				end
				v142 = 10 - 4;
			end
			if (((1941 + 2518) > (1587 - 996)) and (v142 == (1 + 0))) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(106 - 56)) or (0 - 0);
				v142 = 611 - (295 + 314);
			end
			if (((8345 - 4947) >= (4357 - (1300 + 662))) and (v142 == (12 - 8))) then
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((3938 - (1178 + 577)) >= (1467 + 1357))) then
					if (((5722 - 3786) == (3341 - (851 + 554))) and (v33 == "Refreshing Healing Potion")) then
						if (v85.RefreshingHealingPotion:IsReady() or ((4273 + 559) < (11961 - 7648))) then
							if (((8878 - 4790) > (4176 - (115 + 187))) and v9.Press(v86.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((3318 + 1014) == (4102 + 230)) and (v33 == "Dreamwalker's Healing Potion")) then
						if (((15758 - 11759) >= (4061 - (160 + 1001))) and v85.DreamwalkersHealingPotion:IsReady()) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((2209 + 316) > (2805 + 1259))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((8947 - 4576) == (4729 - (237 + 121))) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (v9.Cast(v84.Feint) or ((1163 - (525 + 372)) > (9452 - 4466))) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((6541 - 4550) >= (1067 - (96 + 46))) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (((1232 - (643 + 134)) < (742 + 1311)) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((1980 - 1154) == (18010 - 13159))) then
					local v186 = 0 + 0;
					local v187;
					while true do
						if (((358 - 175) == (373 - 190)) and (v186 == (721 - (316 + 403)))) then
							v187 = v82.Interrupt(v84.Blind, 10 + 5, v79, v12, v86.BlindMouseover);
							if (((3186 - 2027) <= (647 + 1141)) and v187) then
								return v187;
							end
							v187 = v82.InterruptWithStun(v84.CheapShot, 20 - 12, v15:StealthUp(false, false));
							v186 = 3 + 0;
						end
						if ((v186 == (1 + 2)) or ((12151 - 8644) > (20622 - 16304))) then
							if (v187 or ((6388 - 3313) <= (170 + 2795))) then
								return v187;
							end
							v187 = v82.InterruptWithStun(v84.KidneyShot, 15 - 7, v15:ComboPoints() > (0 + 0));
							if (((4015 - 2650) <= (2028 - (12 + 5))) and v187) then
								return v187;
							end
							break;
						end
						if ((v186 == (0 - 0)) or ((5922 - 3146) > (7599 - 4024))) then
							v187 = v82.Interrupt(v84.Kick, 19 - 11, true);
							if (v187 or ((519 + 2035) == (6777 - (1656 + 317)))) then
								return v187;
							end
							v187 = v82.Interrupt(v84.Kick, 8 + 0, true, v12, v86.KickMouseover);
							v186 = 1 + 0;
						end
						if (((6851 - 4274) == (12682 - 10105)) and (v186 == (355 - (5 + 349)))) then
							if (v187 or ((28 - 22) >= (3160 - (266 + 1005)))) then
								return v187;
							end
							v187 = v82.Interrupt(v84.Blind, 10 + 5, v79);
							if (((1726 - 1220) <= (2490 - 598)) and v187) then
								return v187;
							end
							v186 = 1698 - (561 + 1135);
						end
					end
				end
				v142 = 6 - 1;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(854 - 594, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

