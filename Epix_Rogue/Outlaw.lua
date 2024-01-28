local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1469 - (1269 + 200);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((2969 - (98 + 717)) >= (4151 - (802 + 24)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1635 - 340) >= (478 + 2755))) then
			v6 = v0[v4];
			if (((3363 + 1014) > (270 + 1372)) and not v6) then
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
	local function v81()
		local v127 = 0 - 0;
		while true do
			if (((15749 - 11026) > (485 + 871)) and (v127 == (0 + 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v127 = 1 + 0;
			end
			if ((v127 == (1439 - (797 + 636))) or ((20081 - 15945) <= (5052 - (1427 + 192)))) then
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'] or (0 + 0);
				v127 = 16 - 9;
			end
			if (((3816 + 429) <= (2099 + 2532)) and (v127 == (331 - (192 + 134)))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v127 = 1282 - (316 + 960);
			end
			if (((2380 + 1896) >= (3021 + 893)) and ((4 + 0) == v127)) then
				v59 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'] or (0 - 0);
				v127 = 556 - (83 + 468);
			end
			if (((2004 - (1202 + 604)) <= (20376 - 16011)) and (v127 == (2 - 0))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v127 = 328 - (45 + 280);
			end
			if (((4616 + 166) > (4086 + 590)) and (v127 == (3 + 4))) then
				v80 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if (((856 + 4008) > (4068 - 1871)) and (v127 == (1914 - (340 + 1571)))) then
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v58 = EpicSettings.Settings['FeintHP'] or (1772 - (1733 + 39));
				v127 = 10 - 6;
			end
			if ((v127 == (1035 - (125 + 909))) or ((5648 - (1096 + 852)) == (1125 + 1382))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (512 - (409 + 103));
				v127 = 238 - (46 + 190);
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
	local v89 = (v88[108 - (51 + 44)] and v20(v88[4 + 9])) or v20(1317 - (1114 + 203));
	local v90 = (v88[740 - (228 + 498)] and v20(v88[4 + 10])) or v20(0 + 0);
	v10:RegisterForEvent(function()
		local v128 = 663 - (174 + 489);
		while true do
			if (((11656 - 7182) >= (2179 - (830 + 1075))) and ((524 - (303 + 221)) == v128)) then
				v88 = v16:GetEquipment();
				v89 = (v88[1282 - (231 + 1038)] and v20(v88[11 + 2])) or v20(1162 - (171 + 991));
				v128 = 4 - 3;
			end
			if ((v128 == (2 - 1)) or ((4726 - 2832) <= (1126 + 280))) then
				v90 = (v88[48 - 34] and v20(v88[40 - 26])) or v20(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v84.Dispatch:RegisterDamageFormula(function()
		return v16:AttackPowerDamageMod() * v83.CPSpend() * (0.3 - 0) * (1249 - (111 + 1137)) * ((159 - (91 + 67)) + (v16:VersatilityDmgPct() / (297 - 197))) * ((v17:DebuffUp(v84.GhostlyStrike) and (1.1 + 0)) or (524 - (423 + 100)));
	end);
	local v91, v92, v93;
	local v94;
	local v95;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v105, v106 = 0 - 0, 0 - 0;
	local function v107(v129)
		local v130 = 0 - 0;
		local v131;
		while true do
			if (((2283 - (530 + 181)) >= (2412 - (614 + 267))) and (v130 == (32 - (19 + 13)))) then
				v131 = v16:EnergyTimeToMaxPredicted(nil, v129);
				if ((v131 < v105) or ((v131 - v105) > (0.5 - 0)) or ((10922 - 6235) < (12974 - 8432))) then
					v105 = v131;
				end
				v130 = 1 + 0;
			end
			if (((5787 - 2496) > (3456 - 1789)) and ((1813 - (1293 + 519)) == v130)) then
				return v105;
			end
		end
	end
	local function v108()
		local v132 = v16:EnergyPredicted();
		if ((v132 > v106) or ((v132 - v106) > (17 - 8)) or ((2278 - 1405) == (3889 - 1855))) then
			v106 = v132;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local function v110(v133, v134)
		if (not v11.APLVar.RtB_List or ((936 + 1880) < (7 + 4))) then
			v11.APLVar.RtB_List = {};
		end
		if (((4795 - (709 + 387)) < (6564 - (673 + 1185))) and not v11.APLVar.RtB_List[v133]) then
			v11.APLVar.RtB_List[v133] = {};
		end
		local v135 = table.concat(v134);
		if (((7673 - 5027) >= (2812 - 1936)) and (v133 == "All")) then
			if (((1009 - 395) <= (2278 + 906)) and not v11.APLVar.RtB_List[v133][v135]) then
				local v169 = 0 + 0;
				local v170;
				while true do
					if (((4219 - 1093) == (768 + 2358)) and (v169 == (1 - 0))) then
						v11.APLVar.RtB_List[v133][v135] = ((v170 == #v134) and true) or false;
						break;
					end
					if ((v169 == (0 - 0)) or ((4067 - (446 + 1434)) >= (6237 - (1040 + 243)))) then
						v170 = 0 - 0;
						for v186 = 1848 - (559 + 1288), #v134 do
							if (v16:BuffUp(v109[v134[v186]]) or ((5808 - (609 + 1322)) == (4029 - (13 + 441)))) then
								v170 = v170 + (3 - 2);
							end
						end
						v169 = 2 - 1;
					end
				end
			end
		elseif (((3521 - 2814) > (24 + 608)) and not v11.APLVar.RtB_List[v133][v135]) then
			local v171 = 0 - 0;
			while true do
				if ((v171 == (0 + 0)) or ((240 + 306) >= (7964 - 5280))) then
					v11.APLVar.RtB_List[v133][v135] = false;
					for v187 = 1 + 0, #v134 do
						if (((2694 - 1229) <= (2844 + 1457)) and v16:BuffUp(v109[v134[v187]])) then
							v11.APLVar.RtB_List[v133][v135] = true;
							break;
						end
					end
					break;
				end
			end
		end
		return v11.APLVar.RtB_List[v133][v135];
	end
	local function v111()
		if (((948 + 756) > (1024 + 401)) and not v11.APLVar.RtB_Buffs) then
			local v146 = 0 + 0;
			local v147;
			while true do
				if ((v146 == (0 + 0)) or ((1120 - (153 + 280)) == (12225 - 7991))) then
					v11.APLVar.RtB_Buffs = {};
					v11.APLVar.RtB_Buffs.Total = 0 + 0;
					v146 = 1 + 0;
				end
				if ((v146 == (2 + 0)) or ((3022 + 308) < (1036 + 393))) then
					v11.APLVar.RtB_Buffs.Longer = 0 - 0;
					v147 = v83.RtBRemains();
					v146 = 2 + 1;
				end
				if (((1814 - (89 + 578)) >= (240 + 95)) and (v146 == (1 - 0))) then
					v11.APLVar.RtB_Buffs.Normal = 1049 - (572 + 477);
					v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v146 = 2 + 0;
				end
				if (((411 + 3024) > (2183 - (84 + 2))) and (v146 == (4 - 1))) then
					for v180 = 1 + 0, #v109 do
						local v181 = 842 - (497 + 345);
						local v182;
						while true do
							if ((v181 == (0 + 0)) or ((638 + 3132) >= (5374 - (605 + 728)))) then
								v182 = v16:BuffRemains(v109[v180]);
								if ((v182 > (0 + 0)) or ((8428 - 4637) <= (74 + 1537))) then
									local v193 = 0 - 0;
									while true do
										if ((v193 == (0 + 0)) or ((12683 - 8105) <= (1517 + 491))) then
											v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (490 - (457 + 32));
											if (((478 + 647) <= (3478 - (832 + 570))) and (v182 == v147)) then
												v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
											elseif ((v182 > v147) or ((194 + 549) >= (15567 - 11168))) then
												v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
											else
												v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (797 - (588 + 208));
											end
											break;
										end
									end
								end
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
	local function v112()
		local v136 = 0 - 0;
		while true do
			if (((2955 - (884 + 916)) < (3502 - 1829)) and (v136 == (0 + 0))) then
				if (not v11.APLVar.RtB_Reroll or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
					if (((925 + 2842) == (716 + 3051)) and (v64 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v111() <= (0 - 0)) and true) or false;
					elseif (((4694 - (316 + 289)) == (10703 - 6614)) and (v64 == "Broadside")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.Broadside) and true) or false;
					elseif (((206 + 4252) >= (3127 - (666 + 787))) and (v64 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((1397 - (360 + 65)) <= (1326 + 92)) and (v64 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.GrandMelee) and true) or false;
					elseif ((v64 == "Skull and Crossbones") or ((5192 - (79 + 175)) < (7508 - 2746))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif ((v64 == "Ruthless Precision") or ((1954 + 550) > (13070 - 8806))) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif (((4146 - 1993) == (3052 - (503 + 396))) and (v64 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v16:BuffUp(v84.TrueBearing) and true) or false;
					else
						local v205 = 181 - (92 + 89);
						while true do
							if ((v205 == (1 - 0)) or ((261 + 246) >= (1534 + 1057))) then
								if (((17548 - 13067) == (613 + 3868)) and (v111() <= (4 - 2)) and v16:BuffUp(v84.BuriedTreasure) and v16:BuffDown(v84.GrandMelee) and (v93 < (2 + 0))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:HasTier(15 + 16, 12 - 8) and ((not v16:BuffUp(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v16:BuffUp(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v111() <= (1 + 0))) or ((3550 - 1222) < (1937 - (485 + 759)))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v205 = 4 - 2;
							end
							if (((5517 - (442 + 747)) == (5463 - (832 + 303))) and (v205 == (948 - (88 + 858)))) then
								if (((484 + 1104) >= (1103 + 229)) and v84.Crackshot:IsAvailable() and v16:HasTier(2 + 29, 793 - (766 + 23)) and (v111() <= ((4 - 3) + v22(v16:BuffUp(v84.LoadedDiceBuff))))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v16:BuffUp(v84.SkullandCrossbones) and (v111() < ((2 - 0) + v22(v16:BuffUp(v84.GrandMelee)))) and (v93 < (4 - 2))) or ((14166 - 9992) > (5321 - (1036 + 37)))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v205 = 3 + 0;
							end
							if ((v205 == (0 - 0)) or ((3608 + 978) <= (1562 - (641 + 839)))) then
								v11.APLVar.RtB_Reroll = false;
								v111();
								v205 = 914 - (910 + 3);
							end
							if (((9847 - 5984) == (5547 - (1466 + 218))) and ((2 + 1) == v205)) then
								if ((v11.APLVar.RtB_Reroll and ((v11.APLVar.RtB_Buffs.Longer == (1148 - (556 + 592))) or (v11.APLVar.RtB_Buffs.Normal == (0 + 0))) and (v11.APLVar.RtB_Buffs.Longer >= (809 - (329 + 479))) and (v111() < (859 - (174 + 680))) and (v83.RtBRemains() <= (133 - 94)) and not v16:StealthUp(true, true)) or ((584 - 302) <= (30 + 12))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if (((5348 - (396 + 343)) >= (68 + 698)) and (v17:FilteredTimeToDie("<", 1489 - (29 + 1448)) or v10.BossFilteredFightRemains("<", 1401 - (135 + 1254)))) then
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
	local function v113()
		return v96 >= ((v83.CPMaxSpend() - (3 - 2)) - v22((v16:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v114()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((9 - 7) + v22(v84.ImprovedAmbush:IsAvailable()) + v22(v16:BuffUp(v84.Broadside))))) and (v99 >= (34 + 16));
	end
	local function v115()
		return not v28 or (v93 < (1529 - (389 + 1138))) or (v16:BuffRemains(v84.BladeFlurry) > ((575 - (102 + 472)) + v22(v84.KillingSpree:IsAvailable())));
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
		if ((v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v16:BuffUp(v84.Audacity) and (v117() or (v16:BuffStack(v84.Opportunity) < (4 + 2))) and v114()) or ((1075 + 77) == (4033 - (320 + 1225)))) then
			if (((6091 - 2669) > (2050 + 1300)) and v10.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (HO)";
			end
		end
		if (((2341 - (157 + 1307)) > (2235 - (821 + 1038))) and v84.Vanish:IsCastable() and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v113()) then
			if (v10.Cast(v84.Vanish, v67) or ((7779 - 4661) <= (203 + 1648))) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v113() and ((v84.Vanish:CooldownRemains() >= (10 - 4)) or not v67) and not v16:StealthUp(true, false)) or ((62 + 103) >= (8654 - 5162))) then
			if (((4975 - (834 + 192)) < (309 + 4547)) and v10.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if ((v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and not v84.KeepItRolling:IsAvailable() and v118() and v16:BuffUp(v84.SliceandDice) and (v113() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady())) or ((1098 + 3178) < (65 + 2951))) then
			if (((7265 - 2575) > (4429 - (300 + 4))) and v10.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsAvailable() and v84.ShadowDance:IsCastable() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (9 + 21)) or ((v84.KeepItRolling:CooldownRemains() >= (314 - 194)) and (v113() or v84.HiddenOpportunity:IsAvailable())))) or ((412 - (112 + 250)) >= (358 + 538))) then
			if (v10.Cast(v84.ShadowDance, v53) or ((4293 - 2579) >= (1695 + 1263))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady()) or ((772 + 719) < (482 + 162))) then
			if (((350 + 354) < (734 + 253)) and ((v84.Crackshot:IsAvailable() and v113()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v113()) or v84.HiddenOpportunity:IsAvailable())))) then
				if (((5132 - (1001 + 413)) > (4250 - 2344)) and v10.Cast(v84.Shadowmeld, v30)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v137 = v82.HandleTopTrinket(v87, v29, 922 - (244 + 638), nil);
		if (v137 or ((1651 - (627 + 66)) > (10830 - 7195))) then
			return v137;
		end
		local v137 = v82.HandleBottomTrinket(v87, v29, 642 - (512 + 90), nil);
		if (((5407 - (1665 + 241)) <= (5209 - (373 + 344))) and v137) then
			return v137;
		end
	end
	local function v121()
		local v138 = 0 + 0;
		local v139;
		while true do
			if ((v138 == (1 + 1)) or ((9078 - 5636) < (4311 - 1763))) then
				if (((3974 - (35 + 1064)) >= (1066 + 398)) and v84.KeepItRolling:IsReady() and not v112() and (v111() >= ((6 - 3) + v22(v16:HasTier(1 + 30, 1240 - (298 + 938))))) and (v16:BuffDown(v84.ShadowDance) or (v111() >= (1265 - (233 + 1026))))) then
					if (v10.Cast(v84.KeepItRolling) or ((6463 - (636 + 1030)) >= (2502 + 2391))) then
						return "Cast Keep it Rolling";
					end
				end
				if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (7 + 0))) or ((164 + 387) > (140 + 1928))) then
					if (((2335 - (55 + 166)) > (183 + 761)) and v12(v84.GhostlyStrike, v72, nil, not v17:IsSpellInRange(v84.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v29 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((228 + 2034) >= (11823 - 8727))) then
					if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v113() and not v16:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v17:FilteredTimeToDie(">", 308 - (36 + 261)) and v16:BuffUp(v84.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 19 - 8) or ((3623 - (34 + 1334)) >= (1360 + 2177))) then
						if (v10.Cast(v84.Sepsis) or ((2982 + 855) < (2589 - (1035 + 248)))) then
							return "Cast Sepsis";
						end
					end
				end
				v138 = 24 - (20 + 1);
			end
			if (((1537 + 1413) == (3269 - (134 + 185))) and (v138 == (1138 - (549 + 584)))) then
				if (v84.AncestralCall:IsCastable() or ((5408 - (314 + 371)) < (11321 - 8023))) then
					if (((2104 - (478 + 490)) >= (82 + 72)) and v10.Cast(v84.AncestralCall, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if ((v138 == (1176 - (786 + 386))) or ((877 - 606) > (6127 - (1055 + 324)))) then
				if (((6080 - (1093 + 247)) >= (2801 + 351)) and v84.BloodFury:IsCastable()) then
					if (v10.Cast(v84.BloodFury, v30) or ((272 + 2306) >= (13458 - 10068))) then
						return "Cast Blood Fury";
					end
				end
				if (((139 - 98) <= (4726 - 3065)) and v84.Berserking:IsCastable()) then
					if (((1510 - 909) < (1267 + 2293)) and v10.Cast(v84.Berserking, v30)) then
						return "Cast Berserking";
					end
				end
				if (((905 - 670) < (2367 - 1680)) and v84.Fireblood:IsCastable()) then
					if (((3431 + 1118) > (2948 - 1795)) and v10.Cast(v84.Fireblood, v30)) then
						return "Cast Fireblood";
					end
				end
				v138 = 693 - (364 + 324);
			end
			if ((v138 == (7 - 4)) or ((11215 - 6541) < (1549 + 3123))) then
				if (((15348 - 11680) < (7304 - 2743)) and v84.BladeRush:IsReady() and (v102 > (11 - 7)) and not v16:StealthUp(true, true)) then
					if (v10.Cast(v84.BladeRush) or ((1723 - (1249 + 19)) == (3255 + 350))) then
						return "Cast Blade Rush";
					end
				end
				if ((not v16:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((10365 - 7702) == (4398 - (686 + 400)))) then
					v139 = v119();
					if (((3356 + 921) <= (4704 - (73 + 156))) and v139) then
						return v139;
					end
				end
				if ((v29 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v16:BuffUp(v84.ThistleTea) and ((v101 >= (1 + 99)) or v10.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (817 - (721 + 90))))) or ((10 + 860) == (3860 - 2671))) then
					if (((2023 - (224 + 246)) <= (5075 - 1942)) and v10.Cast(v84.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				v138 = 6 - 2;
			end
			if ((v138 == (1 + 0)) or ((54 + 2183) >= (2579 + 932))) then
				if (v84.RolltheBones:IsReady() or ((2631 - 1307) > (10050 - 7030))) then
					if ((v112() and not v16:StealthUp(true, true)) or (v111() == (513 - (203 + 310))) or ((v83.RtBRemains() <= (1996 - (1238 + 755))) and v16:HasTier(3 + 28, 1538 - (709 + 825))) or ((v83.RtBRemains() <= (12 - 5)) and ((v84.ShadowDance:CooldownRemains() <= (3 - 0)) or (v84.Vanish:CooldownRemains() <= (867 - (196 + 668)))) and not v16:StealthUp(true, true)) or ((11813 - 8821) == (3896 - 2015))) then
						if (((3939 - (171 + 662)) > (1619 - (4 + 89))) and v12(v84.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v139 = v120();
				if (((10595 - 7572) < (1410 + 2460)) and v139) then
					return v139;
				end
				v138 = 8 - 6;
			end
			if (((57 + 86) > (1560 - (35 + 1451))) and (v138 == (1453 - (28 + 1425)))) then
				if (((2011 - (941 + 1052)) < (2026 + 86)) and v29 and v84.AdrenalineRush:IsCastable() and ((not v16:BuffUp(v84.AdrenalineRush) and (not v113() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v16:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1516 - (822 + 692)))))) then
					if (((1566 - 469) <= (767 + 861)) and v12(v84.AdrenalineRush, v75)) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((4927 - (45 + 252)) == (4582 + 48)) and v84.BladeFlurry:IsReady()) then
					if (((1219 + 2321) > (6529 - 3846)) and (v93 >= ((435 - (114 + 319)) - v22(v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and v16:BuffUp(v84.AdrenalineRush)))) and (v16:BuffRemains(v84.BladeFlurry) < v16:GCD())) then
						if (((6883 - 2089) >= (4196 - 921)) and v12(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((947 + 537) == (2210 - 726)) and v84.BladeFlurry:IsReady()) then
					if (((3000 - 1568) < (5518 - (556 + 1407))) and v84.DeftManeuvers:IsAvailable() and not v113() and (((v93 >= (1209 - (741 + 465))) and (v98 == (v93 + v22(v16:BuffUp(v84.Broadside))))) or (v93 >= (470 - (170 + 295))))) then
						if (v12(v84.BladeFlurry) or ((562 + 503) > (3287 + 291))) then
							return "Cast Blade Flurry";
						end
					end
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v122()
		local v140 = 0 + 0;
		while true do
			if (((0 + 0) == v140) or ((2716 + 2079) < (2637 - (957 + 273)))) then
				if (((496 + 1357) < (1927 + 2886)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v28 and v84.Subterfuge:IsAvailable() and (v93 >= (7 - 5)) and (v16:BuffRemains(v84.BladeFlurry) <= v16:GCDRemains())) then
					if (v70 or ((7433 - 4612) < (7425 - 4994))) then
						if (v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(49 - 39)) or ((4654 - (389 + 1391)) < (1369 + 812))) then
							return "Cast Blade Flurry";
						end
					elseif (v10.Press(v84.BladeFlurry, not v17:IsInMeleeRange(2 + 8)) or ((6121 - 3432) <= (1294 - (783 + 168)))) then
						return "Cast Blade Flurry";
					end
				end
				if ((v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch) and v113()) or ((6272 - 4403) == (1977 + 32))) then
					if (v10.Cast(v84.ColdBlood) or ((3857 - (309 + 2)) < (7130 - 4808))) then
						return "Cast Cold Blood";
					end
				end
				v140 = 1213 - (1090 + 122);
			end
			if ((v140 == (1 + 0)) or ((6992 - 4910) == (3267 + 1506))) then
				if (((4362 - (628 + 490)) > (190 + 865)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v113() and v84.Crackshot:IsAvailable()) then
					if (v10.Press(v84.BetweentheEyes) or ((8202 - 4889) <= (8125 - 6347))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch) and v113()) or ((2195 - (431 + 343)) >= (4248 - 2144))) then
					if (((5241 - 3429) <= (2567 + 682)) and v10.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v140 = 1 + 1;
			end
			if (((3318 - (556 + 1139)) <= (1972 - (6 + 9))) and (v140 == (1 + 1))) then
				if (((2261 + 2151) == (4581 - (28 + 141))) and v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1 + 1)) and (v16:BuffStack(v84.Opportunity) >= (7 - 1)) and ((v16:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v16:BuffUp(v84.GreenskinsWickersBuff))) then
					if (((3067 - (486 + 831)) >= (2190 - 1348)) and v10.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((15392 - 11020) > (350 + 1500)) and v84.Ambush:IsCastable() and v17:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
					if (((733 - 501) < (2084 - (668 + 595))) and v10.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v141 = 0 + 0;
		while true do
			if (((105 + 413) < (2459 - 1557)) and (v141 == (292 - (23 + 267)))) then
				if (((4938 - (1129 + 815)) > (1245 - (371 + 16))) and v84.ColdBlood:IsCastable() and v16:BuffDown(v84.ColdBlood) and v17:IsSpellInRange(v84.Dispatch)) then
					if (v10.Cast(v84.ColdBlood, v55) or ((5505 - (1326 + 424)) <= (1732 - 817))) then
						return "Cast Cold Blood";
					end
				end
				if (((14419 - 10473) > (3861 - (88 + 30))) and v84.Dispatch:IsCastable() and v17:IsSpellInRange(v84.Dispatch)) then
					if (v10.Press(v84.Dispatch) or ((2106 - (720 + 51)) >= (7354 - 4048))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((6620 - (421 + 1355)) > (3716 - 1463)) and ((0 + 0) == v141)) then
				if (((1535 - (286 + 797)) == (1652 - 1200)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v16:BuffRemains(v84.BetweentheEyes) < (6 - 2)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v16:HasTier(469 - (397 + 42), 2 + 2)) and v16:BuffDown(v84.GreenskinsWickers)) then
					if (v10.Press(v84.BetweentheEyes) or ((5357 - (24 + 776)) < (3214 - 1127))) then
						return "Cast Between the Eyes";
					end
				end
				if (((4659 - (222 + 563)) == (8535 - 4661)) and v84.BetweentheEyes:IsCastable() and v17:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (33 + 12)) and (v84.ShadowDance:CooldownRemains() > (205 - (23 + 167)))) then
					if (v10.Press(v84.BetweentheEyes) or ((3736 - (690 + 1108)) > (1781 + 3154))) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (849 - (40 + 808))) or ((701 + 3554) < (13089 - 9666))) then
				if (((1390 + 64) <= (1318 + 1173)) and v84.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v92, ">", v16:BuffRemains(v84.SliceandDice), true) or (v16:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v16:BuffRemains(v84.SliceandDice) < (((572 - (47 + 524)) + v97) * (1.8 + 0)))) then
					if (v10.Press(v84.SliceandDice) or ((11363 - 7206) <= (4191 - 1388))) then
						return "Cast Slice and Dice";
					end
				end
				if (((11067 - 6214) >= (4708 - (1165 + 561))) and v84.KillingSpree:IsCastable() and v17:IsSpellInRange(v84.KillingSpree) and (v17:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
					if (((123 + 4011) > (10397 - 7040)) and v10.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v141 = 1 + 1;
			end
		end
	end
	local function v124()
		if ((v29 and v84.EchoingReprimand:IsReady()) or ((3896 - (341 + 138)) < (685 + 1849))) then
			if (v10.Cast(v84.EchoingReprimand, v76, nil, not v17:IsSpellInRange(v84.EchoingReprimand)) or ((5617 - 2895) <= (490 - (89 + 237)))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.AudacityBuff)) or ((7746 - 5338) < (4439 - 2330))) then
			if (v10.Press(v84.Ambush) or ((914 - (581 + 300)) == (2675 - (855 + 365)))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v16:BuffUp(v84.Opportunity) and v16:BuffDown(v84.AudacityBuff)) or ((1051 - 608) >= (1311 + 2704))) then
			if (((4617 - (1030 + 205)) > (156 + 10)) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v16:BuffUp(v84.GreenskinsWickersBuff) and ((not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity)) or (v16:BuffRemains(v84.GreenskinsWickersBuff) < (1.5 + 0)))) or ((566 - (156 + 130)) == (6950 - 3891))) then
			if (((3169 - 1288) > (2648 - 1355)) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if (((622 + 1735) == (1375 + 982)) and v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v16:BuffStack(v84.Opportunity) >= (75 - (10 + 59))) or (v16:BuffRemains(v84.Opportunity) < (1 + 1)))) then
			if (((605 - 482) == (1286 - (671 + 492))) and v10.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and (v98 > (1 + 0 + (v22(v84.QuickDraw:IsAvailable()) * v84.FanTheHammer:TalentRank()))) and ((not v84.Vanish:IsReady() and not v84.ShadowDance:IsReady()) or v16:StealthUp(true, true) or not v84.Crackshot:IsAvailable() or (v84.FanTheHammer:TalentRank() <= (1216 - (369 + 846))))) or ((280 + 776) >= (2895 + 497))) then
			if (v10.Press(v84.PistolShot) or ((3026 - (1036 + 909)) < (855 + 220))) then
				return "Cast Pistol Shot";
			end
		end
		if ((not v84.FanTheHammer:IsAvailable() and v16:BuffUp(v84.Opportunity) and ((v102 > (1.5 - 0)) or (v98 <= ((204 - (11 + 192)) + v22(v16:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v16:BuffDown(v84.AudacityBuff)))) or ((531 + 518) >= (4607 - (135 + 40)))) then
			if (v10.Press(v84.PistolShot) or ((11552 - 6784) <= (510 + 336))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.SinisterStrike:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) or ((7397 - 4039) <= (2128 - 708))) then
			if (v10.Press(v84.SinisterStrike) or ((3915 - (50 + 126)) <= (8367 - 5362))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1417 - (1233 + 180))) or ((2628 - (522 + 447)) >= (3555 - (107 + 1314)))) then
				if (v28 or ((1513 + 1747) < (7175 - 4820))) then
					v91 = v16:GetEnemiesInRange(13 + 17);
					if (v84.AcrobaticStrikes:IsAvailable() or ((1328 - 659) == (16708 - 12485))) then
						v92 = v16:GetEnemiesInRange(1919 - (716 + 1194));
					end
					if (not v84.AcrobaticStrikes:IsAvailable() or ((29 + 1663) < (63 + 525))) then
						v92 = v16:GetEnemiesInRange(509 - (74 + 429));
					end
					v93 = #v92;
				else
					v93 = 1 - 0;
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((2378 + 2419) < (8357 - 4706))) then
					return v94;
				end
				v142 = 4 + 1;
			end
			if ((v142 == (8 - 5)) or ((10327 - 6150) > (5283 - (279 + 154)))) then
				v100 = v16:EnergyRegen();
				v102 = v107(v103);
				v101 = v16:EnergyDeficitPredicted(nil, v103);
				v142 = 782 - (454 + 324);
			end
			if (((1 + 0) == v142) or ((417 - (12 + 5)) > (600 + 511))) then
				v29 = EpicSettings.Toggles['cds'];
				v97 = v16:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v142 = 4 - 2;
			end
			if (((1128 + 1923) > (2098 - (277 + 816))) and (v142 == (21 - 16))) then
				v83.Poisons();
				if (((4876 - (1058 + 125)) <= (822 + 3560)) and v32 and (v16:HealthPercentage() <= v34)) then
					local v177 = 975 - (815 + 160);
					while true do
						if ((v177 == (0 - 0)) or ((7790 - 4508) > (979 + 3121))) then
							if ((v33 == "Refreshing Healing Potion") or ((10464 - 6884) < (4742 - (41 + 1857)))) then
								if (((1982 - (1222 + 671)) < (11604 - 7114)) and v85.RefreshingHealingPotion:IsReady()) then
									if (v10.Press(v86.RefreshingHealingPotion) or ((7161 - 2178) < (2990 - (229 + 953)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((5603 - (1111 + 663)) > (5348 - (874 + 705))) and (v33 == "Dreamwalker's Healing Potion")) then
								if (((208 + 1277) <= (1982 + 922)) and v85.DreamwalkersHealingPotion:IsReady()) then
									if (((8873 - 4604) == (121 + 4148)) and v10.Press(v86.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((1066 - (642 + 37)) <= (635 + 2147)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v16:HealthPercentage() <= v58)) then
					if (v10.Cast(v84.Feint) or ((304 + 1595) <= (2302 - 1385))) then
						return "Cast Feint (Defensives)";
					end
				end
				v142 = 460 - (233 + 221);
			end
			if ((v142 == (0 - 0)) or ((3796 + 516) <= (2417 - (718 + 823)))) then
				v81();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v142 = 1 + 0;
			end
			if (((3037 - (266 + 539)) <= (7349 - 4753)) and (v142 == (1227 - (636 + 589)))) then
				v98 = v16:ComboPointsDeficit();
				v103 = (v16:BuffUp(v84.AdrenalineRush, nil, true) and -(118 - 68)) or (0 - 0);
				v99 = v108();
				v142 = 3 + 0;
			end
			if (((762 + 1333) < (4701 - (657 + 358))) and (v142 == (15 - 9))) then
				if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v16:HealthPercentage() <= v80)) or ((3633 - 2038) >= (5661 - (1151 + 36)))) then
					if (v10.Cast(v84.Evasion) or ((4461 + 158) < (758 + 2124))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v16:IsCasting() and not v16:IsChanneling()) or ((877 - 583) >= (6663 - (1552 + 280)))) then
					local v178 = v82.Interrupt(v84.Kick, 842 - (64 + 770), true);
					if (((1378 + 651) <= (7000 - 3916)) and v178) then
						return v178;
					end
					v178 = v82.Interrupt(v84.Kick, 2 + 6, true, v13, v86.KickMouseover);
					if (v178 or ((3280 - (157 + 1086)) == (4843 - 2423))) then
						return v178;
					end
					v178 = v82.Interrupt(v84.Blind, 65 - 50, v79);
					if (((6838 - 2380) > (5328 - 1424)) and v178) then
						return v178;
					end
					v178 = v82.Interrupt(v84.Blind, 834 - (599 + 220), v79, v13, v86.BlindMouseover);
					if (((867 - 431) >= (2054 - (1813 + 118))) and v178) then
						return v178;
					end
					v178 = v82.InterruptWithStun(v84.CheapShot, 6 + 2, v16:StealthUp(false, false));
					if (((1717 - (841 + 376)) < (2543 - 727)) and v178) then
						return v178;
					end
					v178 = v82.InterruptWithStun(v84.KidneyShot, 2 + 6, v16:ComboPoints() > (0 - 0));
					if (((4433 - (464 + 395)) == (9172 - 5598)) and v178) then
						return v178;
					end
				end
				if (((107 + 114) < (1227 - (467 + 370))) and not v16:AffectingCombat() and not v16:IsMounted() and v59) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (v94 or ((4572 - 2359) <= (1044 + 377))) then
						return "Stealth (OOC): " .. v94;
					end
				end
				v142 = 23 - 16;
			end
			if (((478 + 2580) < (11307 - 6447)) and (v142 == (527 - (150 + 370)))) then
				if ((not v16:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1283 - (74 + 1208))) and v17:IsInRange(19 - 11) and v27) or ((6146 - 4850) >= (3164 + 1282))) then
					if ((v82.TargetIsValid() and v17:IsInRange(400 - (14 + 376)) and not (v16:IsChanneling() or v16:IsCasting())) or ((2415 - 1022) > (2905 + 1584))) then
						if ((v84.BladeFlurry:IsReady() and v16:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v16:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v16:BuffUp(v84.AdrenalineRush))) or ((3887 + 537) < (26 + 1))) then
							if (v12(v84.BladeFlurry) or ((5851 - 3854) > (2870 + 945))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((3543 - (23 + 55)) > (4533 - 2620)) and not v16:StealthUp(true, false)) then
							local v189 = 0 + 0;
							while true do
								if (((659 + 74) < (2819 - 1000)) and (v189 == (0 + 0))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (v94 or ((5296 - (652 + 249)) == (12725 - 7970))) then
										return v94;
									end
									break;
								end
							end
						end
						if (v82.TargetIsValid() or ((5661 - (708 + 1160)) < (6430 - 4061))) then
							if ((v84.RolltheBones:IsReady() and not v16:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v112())) or ((4111 - (10 + 17)) == (60 + 205))) then
								if (((6090 - (1400 + 332)) == (8358 - 4000)) and v10.Cast(v84.RolltheBones)) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1910 - (242 + 1666)))) or ((1343 + 1795) < (364 + 629))) then
								if (((2838 + 492) > (3263 - (850 + 90))) and v10.Cast(v84.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if ((v84.SliceandDice:IsReady() and (v16:BuffRemains(v84.SliceandDice) < (((1 - 0) + v97) * (1391.8 - (360 + 1030))))) or ((3209 + 417) == (11258 - 7269))) then
								if (v10.Press(v84.SliceandDice) or ((1259 - 343) == (4332 - (909 + 752)))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((1495 - (109 + 1114)) == (497 - 225)) and v16:StealthUp(true, false)) then
								local v195 = 0 + 0;
								while true do
									if (((4491 - (6 + 236)) <= (3049 + 1790)) and (v195 == (0 + 0))) then
										v94 = v122();
										if (((6548 - 3771) < (5589 - 2389)) and v94) then
											return "Stealth (Opener): " .. v94;
										end
										v195 = 1134 - (1076 + 57);
									end
									if (((16 + 79) < (2646 - (579 + 110))) and (v195 == (1 + 0))) then
										if (((731 + 95) < (912 + 805)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
											if (((1833 - (174 + 233)) >= (3086 - 1981)) and v10.Press(v84.GhostlyStrike)) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (((4833 - 2079) <= (1503 + 1876)) and v84.Ambush:IsCastable()) then
											if (v10.Cast(v84.Ambush) or ((5101 - (663 + 511)) == (1261 + 152))) then
												return "Cast Ambush (Opener)";
											end
										end
										break;
									end
								end
							elseif (v113() or ((251 + 903) <= (2429 - 1641))) then
								local v197 = 0 + 0;
								while true do
									if ((v197 == (0 - 0)) or ((3977 - 2334) > (1613 + 1766))) then
										v94 = v123();
										if (v94 or ((5455 - 2652) > (3242 + 1307))) then
											return "Finish (Opener): " .. v94;
										end
										break;
									end
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((21 + 199) >= (3744 - (478 + 244)))) then
								if (((3339 - (440 + 77)) == (1284 + 1538)) and v10.Cast(v84.SinisterStrike)) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v16:GCDRemains())) or ((3883 - 2822) == (3413 - (655 + 901)))) then
					v97 = v26(v97, v83.FanTheHammerCP());
				end
				if (((512 + 2248) > (1045 + 319)) and v82.TargetIsValid()) then
					local v179 = 0 + 0;
					while true do
						if ((v179 == (0 - 0)) or ((6347 - (695 + 750)) <= (12275 - 8680))) then
							v94 = v121();
							if (v94 or ((5944 - 2092) == (1178 - 885))) then
								return "CDs: " .. v94;
							end
							if (v16:StealthUp(true, true) or v16:BuffUp(v84.Shadowmeld) or ((1910 - (285 + 66)) == (10694 - 6106))) then
								local v191 = 1310 - (682 + 628);
								while true do
									if ((v191 == (0 + 0)) or ((4783 - (176 + 123)) == (330 + 458))) then
										v94 = v122();
										if (((3314 + 1254) >= (4176 - (239 + 30))) and v94) then
											return "Stealth: " .. v94;
										end
										break;
									end
								end
							end
							if (((339 + 907) < (3336 + 134)) and v113()) then
								local v192 = 0 - 0;
								while true do
									if (((12691 - 8623) >= (1287 - (306 + 9))) and (v192 == (0 - 0))) then
										v94 = v123();
										if (((86 + 407) < (2389 + 1504)) and v94) then
											return "Finish: " .. v94;
										end
										break;
									end
								end
							end
							v179 = 1 + 0;
						end
						if ((v179 == (5 - 3)) or ((2848 - (1140 + 235)) >= (2121 + 1211))) then
							if ((v84.LightsJudgment:IsCastable() and v17:IsInMeleeRange(5 + 0)) or ((1040 + 3011) <= (1209 - (33 + 19)))) then
								if (((219 + 385) < (8635 - 5754)) and v10.Cast(v84.LightsJudgment, v30)) then
									return "Cast Lights Judgment";
								end
							end
							if ((v84.BagofTricks:IsCastable() and v17:IsInMeleeRange(3 + 2)) or ((1764 - 864) == (3167 + 210))) then
								if (((5148 - (586 + 103)) > (54 + 537)) and v10.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if (((10461 - 7063) >= (3883 - (1309 + 179))) and v84.PistolShot:IsCastable() and v17:IsSpellInRange(v84.PistolShot) and not v17:IsInRange(10 - 4) and not v16:StealthUp(true, true) and (v101 < (11 + 14)) and ((v98 >= (2 - 1)) or (v102 <= (1.2 + 0)))) then
								if (v10.Cast(v84.PistolShot) or ((4637 - 2454) >= (5626 - 2802))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((2545 - (295 + 314)) == (4755 - 2819)) and v84.SinisterStrike:IsCastable()) then
								if (v10.Cast(v84.SinisterStrike) or ((6794 - (1300 + 662)) < (13543 - 9230))) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if (((5843 - (1178 + 577)) > (2012 + 1862)) and (v179 == (2 - 1))) then
							v94 = v124();
							if (((5737 - (851 + 554)) == (3831 + 501)) and v94) then
								return "Build: " .. v94;
							end
							if (((11090 - 7091) >= (6298 - 3398)) and v84.ArcaneTorrent:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike) and (v101 > ((317 - (115 + 187)) + v100))) then
								if (v10.Cast(v84.ArcaneTorrent, v30) or ((1934 + 591) > (3848 + 216))) then
									return "Cast Arcane Torrent";
								end
							end
							if (((17224 - 12853) == (5532 - (160 + 1001))) and v84.ArcanePulse:IsCastable() and v17:IsSpellInRange(v84.SinisterStrike)) then
								if (v10.Cast(v84.ArcanePulse) or ((233 + 33) > (3441 + 1545))) then
									return "Cast Arcane Pulse";
								end
							end
							v179 = 3 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(618 - (237 + 121), v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

