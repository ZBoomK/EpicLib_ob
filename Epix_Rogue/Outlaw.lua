local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2437 - (374 + 433)) > (4960 - (418 + 344)))) then
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
		local v127 = 326 - (192 + 134);
		while true do
			if (((2330 - (316 + 960)) == (587 + 467)) and (v127 == (7 + 1))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 9 + 0;
			end
			if ((v127 == (22 - 16)) or ((1227 - (83 + 468)) >= (3448 - (1202 + 604)))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 32 - 25;
			end
			if (((6883 - 2747) > (6636 - 4239)) and (v127 == (326 - (45 + 280)))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v127 = 1 + 1;
			end
			if ((v127 == (0 + 0)) or ((763 + 3571) == (7860 - 3615))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1912 - (340 + 1571);
			end
			if ((v127 == (4 + 5)) or ((6048 - (1733 + 39)) <= (8328 - 5297))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (1034 - (125 + 909));
				break;
			end
			if ((v127 == (1955 - (1096 + 852))) or ((2146 + 2636) <= (1711 - 512))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 8 + 0;
			end
			if ((v127 == (517 - (409 + 103))) or ((5100 - (46 + 190)) < (1997 - (51 + 44)))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v58 = EpicSettings.Settings['FeintHP'] or (1317 - (1114 + 203));
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 732 - (228 + 498);
			end
			if (((1049 + 3790) >= (2045 + 1655)) and (v127 == (666 - (174 + 489)))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 10 - 6;
			end
			if ((v127 == (1907 - (830 + 1075))) or ((1599 - (303 + 221)) > (3187 - (231 + 1038)))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v127 = 1165 - (171 + 991);
			end
			if (((1631 - 1235) <= (10214 - 6410)) and (v127 == (9 - 5))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 5 + 0;
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
	local v89 = (v88[45 - 32] and v19(v88[37 - 24])) or v19(0 - 0);
	local v90 = (v88[43 - 29] and v19(v88[1262 - (111 + 1137)])) or v19(158 - (91 + 67));
	v9:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (1 + 0)) or ((4692 - (423 + 100)) == (16 + 2171))) then
				v90 = (v88[38 - 24] and v19(v88[8 + 6])) or v19(771 - (326 + 445));
				break;
			end
			if (((6135 - 4729) == (3131 - 1725)) and (v128 == (0 - 0))) then
				v88 = v15:GetEquipment();
				v89 = (v88[724 - (530 + 181)] and v19(v88[894 - (614 + 267)])) or v19(32 - (19 + 13));
				v128 = 1 - 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 13 - 7;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 - 0);
	end}};
	local v105, v106 = 0 - 0, 0 + 0;
	local function v107(v129)
		local v130 = v15:EnergyTimeToMaxPredicted(nil, v129);
		if (((313 + 1218) < (9923 - 5652)) and ((v130 < v105) or ((v130 - v105) > (0.5 + 0)))) then
			v105 = v130;
		end
		return v105;
	end
	local function v108()
		local v131 = 0 + 0;
		local v132;
		while true do
			if (((397 + 238) == (1731 - (709 + 387))) and (v131 == (1858 - (673 + 1185)))) then
				v132 = v15:EnergyPredicted();
				if (((9782 - 6409) <= (11418 - 7862)) and ((v132 > v106) or ((v132 - v106) > (14 - 5)))) then
					v106 = v132;
				end
				v131 = 1 + 0;
			end
			if ((v131 == (1 + 0)) or ((4443 - 1152) < (806 + 2474))) then
				return v106;
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((6317 - (609 + 1322)) >= (1327 - (13 + 441))) and not v10.APLVar.RtB_Buffs) then
			local v142 = 0 - 0;
			local v143;
			while true do
				if (((2412 - 1491) <= (5488 - 4386)) and (v142 == (1 + 1))) then
					v143 = v83.RtBRemains();
					for v186 = 3 - 2, #v109 do
						local v187 = v15:BuffRemains(v109[v186]);
						if (((1672 + 3034) >= (422 + 541)) and (v187 > (0 - 0))) then
							local v190 = 0 + 0;
							local v191;
							while true do
								if ((v190 == (0 - 0)) or ((635 + 325) <= (488 + 388))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
									if ((v187 > v10.APLVar.RtB_Buffs.MaxRemains) or ((1735 + 331) == (912 + 20))) then
										v10.APLVar.RtB_Buffs.MaxRemains = v187;
									end
									v190 = 434 - (153 + 280);
								end
								if (((13932 - 9107) < (4349 + 494)) and (v190 == (1 + 0))) then
									v191 = math.abs(v187 - v143);
									if ((v191 <= (0.5 + 0)) or ((3519 + 358) >= (3288 + 1249))) then
										local v199 = 0 - 0;
										while true do
											if ((v199 == (0 + 0)) or ((4982 - (89 + 578)) < (1233 + 493))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (1 - 0);
												v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
												v199 = 1050 - (572 + 477);
											end
											if ((v199 == (1 + 0)) or ((2208 + 1471) < (75 + 550))) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (87 - (84 + 2));
												break;
											end
										end
									elseif ((v187 > v143) or ((7622 - 2997) < (456 + 176))) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (843 - (497 + 345));
									else
										local v202 = 0 + 0;
										while true do
											if ((v202 == (1 + 0)) or ((1416 - (605 + 728)) > (1270 + 510))) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (1 - 0);
												break;
											end
											if (((26 + 520) <= (3981 - 2904)) and (v202 == (0 + 0))) then
												v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (2 - 1);
												v10.APLVar.RtB_Buffs.Will_Lose[v109[v186]:Name()] = true;
												v202 = 1 + 0;
											end
										end
									end
									break;
								end
							end
						end
						if (v110 or ((1485 - (457 + 32)) > (1825 + 2476))) then
							local v192 = 1402 - (832 + 570);
							while true do
								if (((3835 + 235) > (180 + 507)) and (v192 == (0 - 0))) then
									print("RtbRemains", v143);
									print(v109[v186]:Name(), v187);
									break;
								end
							end
						end
					end
					if (v110 or ((316 + 340) >= (4126 - (588 + 208)))) then
						print("have: ", v10.APLVar.RtB_Buffs.Total);
						print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
						print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v10.APLVar.RtB_Buffs.Normal);
						print("longer: ", v10.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
					end
					break;
				end
				if (((2 - 1) == v142) or ((4292 - (884 + 916)) <= (701 - 366))) then
					v10.APLVar.RtB_Buffs.Normal = 0 + 0;
					v10.APLVar.RtB_Buffs.Shorter = 653 - (232 + 421);
					v10.APLVar.RtB_Buffs.Longer = 1889 - (1569 + 320);
					v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v142 = 1 + 1;
				end
				if (((14564 - 10242) >= (3167 - (316 + 289))) and (v142 == (0 - 0))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Will_Lose = {};
					v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v10.APLVar.RtB_Buffs.Total = 1453 - (666 + 787);
					v142 = 426 - (360 + 65);
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v133)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v113()
		if (not v10.APLVar.RtB_Reroll or ((3400 + 237) >= (4024 - (79 + 175)))) then
			if ((v64 == "1+ Buff") or ((3750 - 1371) > (3573 + 1005))) then
				v10.APLVar.RtB_Reroll = ((v111() <= (0 - 0)) and true) or false;
			elseif ((v64 == "Broadside") or ((930 - 447) > (1642 - (503 + 396)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif (((2635 - (92 + 89)) > (1120 - 542)) and (v64 == "Buried Treasure")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif (((477 + 453) < (2639 + 1819)) and (v64 == "Grand Melee")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif (((2592 - 1930) <= (133 + 839)) and (v64 == "Skull and Crossbones")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((9964 - 5594) == (3813 + 557)) and (v64 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((2275 + 2487) <= (2622 - 1761))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				v10.APLVar.RtB_Reroll = false;
				v111();
				if (((v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (1 + 1))) or ((2152 - 740) == (5508 - (485 + 759)))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v84.Crackshot:IsAvailable() and not v15:HasTier(71 - 40, 1193 - (442 + 747)) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1136 - (832 + 303)))) or ((4114 - (88 + 858)) < (657 + 1496))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v84.Crackshot:IsAvailable() and v15:HasTier(26 + 5, 1 + 3) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((790 - (766 + 23)) + v21(v15:BuffUp(v84.LoadedDiceBuff))))) or ((24565 - 19589) < (1821 - 489))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((12193 - 7565) == (15707 - 11079)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((1075 - (1036 + 37)) + v112(v84.GrandMelee))) and (v93 < (2 + 0))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if ((v10.APLVar.RtB_Reroll and (v10.APLVar.RtB_Buffs.Longer == (0 - 0))) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1481 - (641 + 839))) and (v111() < (919 - (910 + 3))) and (v10.APLVar.RtB_Buffs.MaxRemains <= (99 - 60)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)) or ((1738 - (1466 + 218)) == (182 + 213))) then
					v10.APLVar.RtB_Reroll = true;
				end
				if (((1230 - (556 + 592)) == (30 + 52)) and (v16:FilteredTimeToDie("<", 820 - (329 + 479)) or v9.BossFilteredFightRemains("<", 866 - (174 + 680)))) then
					v10.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (3 - 2)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((3 - 1) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (36 + 14));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (741 - (396 + 343))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (1478 - (29 + 1448))) or ((1970 - (135 + 1254)) < (1062 - 780))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (27 - 21)) or not v67) and not v15:StealthUp(true, false)) or ((3072 + 1537) < (4022 - (389 + 1138)))) then
					if (((1726 - (102 + 472)) == (1088 + 64)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((1052 + 844) <= (3191 + 231)) and v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) then
					if (v11(v84.ShadowDance, v53) or ((2535 - (320 + 1225)) > (2883 - 1263))) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 2 + 0;
			end
			if ((v134 == (1464 - (157 + 1307))) or ((2736 - (821 + 1038)) > (11713 - 7018))) then
				if (((295 + 2396) >= (3287 - 1436)) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (3 + 3))) and v115()) then
					if (v9.Cast(v84.Vanish, v67) or ((7398 - 4413) >= (5882 - (834 + 192)))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((272 + 4004) >= (307 + 888)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (((70 + 3162) <= (7265 - 2575)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 305 - (300 + 4);
			end
			if (((1 + 1) == v134) or ((2345 - 1449) >= (3508 - (112 + 250)))) then
				if (((1221 + 1840) >= (7410 - 4452)) and v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (18 + 12)) or ((v84.KeepItRolling:CooldownRemains() >= (63 + 57)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) then
					if (((2384 + 803) >= (320 + 324)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				if (((479 + 165) <= (2118 - (1001 + 413))) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
					if (((2136 - 1178) > (1829 - (244 + 638))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
						if (((5185 - (627 + 66)) >= (7907 - 5253)) and v9.Cast(v84.Shadowmeld, v30)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v135 = 602 - (512 + 90);
		local v136;
		while true do
			if (((5348 - (1665 + 241)) >= (2220 - (373 + 344))) and (v135 == (0 + 0))) then
				v136 = v82.HandleTopTrinket(v87, v28, 11 + 29, nil);
				if (v136 or ((8361 - 5191) <= (2477 - 1013))) then
					return v136;
				end
				v135 = 1100 - (35 + 1064);
			end
			if ((v135 == (1 + 0)) or ((10263 - 5466) == (18 + 4370))) then
				v136 = v82.HandleBottomTrinket(v87, v28, 1276 - (298 + 938), nil);
				if (((1810 - (233 + 1026)) <= (2347 - (636 + 1030))) and v136) then
					return v136;
				end
				break;
			end
		end
	end
	local function v121()
		local v137 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (((1676 + 1601) > (398 + 9)) and v137) then
			return "DPS Pot";
		end
		if (((1395 + 3300) >= (96 + 1319)) and v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (223 - (55 + 166)))))) then
			if (v11(v84.AdrenalineRush, v75) or ((623 + 2589) <= (95 + 849))) then
				return "Cast Adrenaline Rush";
			end
		end
		if (v84.BladeFlurry:IsReady() or ((11823 - 8727) <= (2095 - (36 + 261)))) then
			if (((6185 - 2648) == (4905 - (34 + 1334))) and (v93 >= ((1 + 1) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) then
				if (((2982 + 855) >= (2853 - (1035 + 248))) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.BladeFlurry:IsReady() or ((2971 - (20 + 1)) == (1986 + 1826))) then
			if (((5042 - (134 + 185)) >= (3451 - (549 + 584))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (688 - (314 + 371))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (17 - 12)))) then
				if (v11(v84.BladeFlurry) or ((2995 - (478 + 490)) > (1511 + 1341))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.RolltheBones:IsReady() or ((2308 - (786 + 386)) > (13982 - 9665))) then
			if (((6127 - (1055 + 324)) == (6088 - (1093 + 247))) and ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1 + 2)) and v15:HasTier(123 - 92, 13 - 9)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (19 - 12)) and ((v84.ShadowDance:CooldownRemains() <= (7 - 4)) or (v84.Vanish:CooldownRemains() <= (2 + 1))) and not v15:StealthUp(true, true)))) then
				if (((14392 - 10656) <= (16337 - 11597)) and v11(v84.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v138 = v120();
		if (v138 or ((2557 + 833) <= (7825 - 4765))) then
			return v138;
		end
		if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((691 - (364 + 324)) + v21(v15:HasTier(84 - 53, 9 - 5)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (2 + 4)))) or ((4179 - 3180) > (4312 - 1619))) then
			if (((1405 - 942) < (1869 - (1249 + 19))) and v9.Cast(v84.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (7 + 0))) or ((8497 - 6314) < (1773 - (686 + 400)))) then
			if (((3570 + 979) == (4778 - (73 + 156))) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if (((23 + 4649) == (5483 - (721 + 90))) and v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
			if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 1 + 10) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 35 - 24) or ((4138 - (224 + 246)) < (639 - 244))) then
				if (v9.Cast(v84.Sepsis) or ((7670 - 3504) == (83 + 372))) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v84.BladeRush:IsReady() and (v102 > (1 + 3)) and not v15:StealthUp(true, true)) or ((3268 + 1181) == (5294 - 2631))) then
			if (v9.Cast(v84.BladeRush) or ((14232 - 9955) < (3502 - (203 + 310)))) then
				return "Cast Blade Rush";
			end
		end
		if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((2863 - (1238 + 755)) >= (290 + 3859))) then
			local v144 = 1534 - (709 + 825);
			while true do
				if (((4075 - 1863) < (4635 - 1452)) and (v144 == (864 - (196 + 668)))) then
					v138 = v119();
					if (((18343 - 13697) > (6197 - 3205)) and v138) then
						return v138;
					end
					break;
				end
			end
		end
		if (((2267 - (171 + 662)) < (3199 - (4 + 89))) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (350 - 250)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (3 + 3)))) then
			if (((3452 - 2666) < (1186 + 1837)) and v9.Cast(v84.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if ((v84.BladeRush:IsCastable() and (v102 > (1490 - (35 + 1451))) and not v15:StealthUp(true, true)) or ((3895 - (28 + 1425)) < (2067 - (941 + 1052)))) then
			if (((4349 + 186) == (6049 - (822 + 692))) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((4295 - 1286) <= (992 + 1113))) then
			if (((2127 - (45 + 252)) < (3631 + 38)) and v9.Cast(v84.BloodFury, v30)) then
				return "Cast Blood Fury";
			end
		end
		if (v84.Berserking:IsCastable() or ((493 + 937) >= (8790 - 5178))) then
			if (((3116 - (114 + 319)) >= (3532 - 1072)) and v9.Cast(v84.Berserking, v30)) then
				return "Cast Berserking";
			end
		end
		if (v84.Fireblood:IsCastable() or ((2310 - 506) >= (2088 + 1187))) then
			if (v9.Cast(v84.Fireblood, v30) or ((2110 - 693) > (7603 - 3974))) then
				return "Cast Fireblood";
			end
		end
		if (((6758 - (556 + 1407)) > (1608 - (741 + 465))) and v84.AncestralCall:IsCastable()) then
			if (((5278 - (170 + 295)) > (1879 + 1686)) and v9.Cast(v84.AncestralCall, v30)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		if (((3594 + 318) == (9631 - 5719)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (2 + 0)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
			if (((1810 + 1011) <= (2732 + 2092)) and v70) then
				v9.Cast(v84.BladeFlurry);
			elseif (((2968 - (957 + 273)) <= (588 + 1607)) and v9.Cast(v84.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if (((17 + 24) <= (11499 - 8481)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
			if (((5652 - 3507) <= (12535 - 8431)) and v9.Cast(v84.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if (((13315 - 10626) < (6625 - (389 + 1391))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
			if (v9.Cast(v84.BetweentheEyes) or ((1457 + 865) > (273 + 2349))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((10321 - 5787) == (3033 - (783 + 168)))) then
			if (v9.Press(v84.Dispatch) or ((5272 - 3701) > (1837 + 30))) then
				return "Cast Dispatch";
			end
		end
		if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (313 - (309 + 2))) and (v15:BuffStack(v84.Opportunity) >= (18 - 12)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1213 - (1090 + 122)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) or ((861 + 1793) >= (10061 - 7065))) then
			if (((2723 + 1255) > (3222 - (628 + 490))) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((538 + 2457) > (3815 - 2274)) and v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
			if (((14847 - 11598) > (1727 - (431 + 343))) and v9.Press(v84.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		local v139 = 0 - 0;
		while true do
			if (((5 - 3) == v139) or ((2586 + 687) > (585 + 3988))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((4846 - (556 + 1139)) < (1299 - (6 + 9)))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((339 + 1511) == (784 + 745))) then
						return "Cast Cold Blood";
					end
				end
				if (((990 - (28 + 141)) < (823 + 1300)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
					if (((1112 - 210) < (1647 + 678)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((2175 - (486 + 831)) <= (7707 - 4745)) and (v139 == (0 - 0))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (1 + 3)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(94 - 64, 1267 - (668 + 595))) and v15:BuffDown(v84.GreenskinsWickers)) or ((3551 + 395) < (260 + 1028))) then
					if (v9.Press(v84.BetweentheEyes) or ((8841 - 5599) == (857 - (23 + 267)))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (1989 - (1129 + 815))) and (v84.ShadowDance:CooldownRemains() > (399 - (371 + 16)))) or ((2597 - (1326 + 424)) >= (2391 - 1128))) then
					if (v9.Press(v84.BetweentheEyes) or ((8232 - 5979) == (1969 - (88 + 30)))) then
						return "Cast Between the Eyes";
					end
				end
				v139 = 772 - (720 + 51);
			end
			if (((2 - 1) == v139) or ((3863 - (421 + 1355)) > (3912 - 1540))) then
				if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v15:BuffRemains(v84.SliceandDice) < (((1084 - (286 + 797)) + v97) * (3.8 - 2)))) or ((7362 - 2917) < (4588 - (397 + 42)))) then
					if (v9.Press(v84.SliceandDice) or ((568 + 1250) == (885 - (24 + 776)))) then
						return "Cast Slice and Dice";
					end
				end
				if (((970 - 340) < (2912 - (222 + 563))) and v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
					if (v9.Cast(v84.KillingSpree) or ((4269 - 2331) == (1811 + 703))) then
						return "Cast Killing Spree";
					end
				end
				v139 = 192 - (23 + 167);
			end
		end
	end
	local function v124()
		local v140 = 1798 - (690 + 1108);
		while true do
			if (((1536 + 2719) >= (46 + 9)) and (v140 == (851 - (40 + 808)))) then
				if (((494 + 2505) > (4420 - 3264)) and v84.SinisterStrike:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
					if (((2247 + 103) > (612 + 543)) and v9.Press(v84.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((2210 + 1819) <= (5424 - (47 + 524))) and ((0 + 0) == v140)) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((1410 - 894) > (5134 - 1700))) then
					if (((9227 - 5181) >= (4759 - (1165 + 561))) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((81 + 2638) <= (4481 - 3034))) then
					if (v9.Press(v84.Ambush) or ((1578 + 2556) < (4405 - (341 + 138)))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v140 = 1 + 0;
			end
			if ((v140 == (3 - 1)) or ((490 - (89 + 237)) >= (8959 - 6174))) then
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1 - 0) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (882 - (581 + 300)))))) or (v97 <= (1221 - (855 + 365))))) or ((1246 - 721) == (689 + 1420))) then
					if (((1268 - (1030 + 205)) == (31 + 2)) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((2842 + 212) <= (4301 - (156 + 130))) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (2.5 - 1)) or (v98 <= ((1 - 0) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
					if (((3831 - 1960) < (892 + 2490)) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
						return "Cast Pistol Shot";
					end
				end
				v140 = 2 + 1;
			end
			if (((1362 - (10 + 59)) <= (613 + 1553)) and (v140 == (4 - 3))) then
				if ((v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((3742 - (671 + 492)) < (98 + 25))) then
					if (v9.Press(v84.PistolShot) or ((2061 - (369 + 846)) >= (627 + 1741))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (6 + 0)) or (v15:BuffRemains(v84.Opportunity) < (1947 - (1036 + 909))))) or ((3190 + 822) <= (5637 - 2279))) then
					if (((1697 - (11 + 192)) <= (1519 + 1486)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v140 = 177 - (135 + 40);
			end
		end
	end
	local function v125()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (4 + 1)) or ((6853 - 3742) == (3198 - 1064))) then
				if (((2531 - (50 + 126)) == (6557 - 4202)) and v29) then
					local v181 = 0 + 0;
					while true do
						if ((v181 == (1413 - (1233 + 180))) or ((1557 - (522 + 447)) <= (1853 - (107 + 1314)))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 14 + 16, true);
							if (((14616 - 9819) >= (1655 + 2240)) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if (((7102 - 3525) == (14152 - 10575)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					local v182 = 1910 - (716 + 1194);
					while true do
						if (((65 + 3729) > (396 + 3297)) and (v182 == (503 - (74 + 429)))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (v94 or ((2459 - 1184) == (2033 + 2067))) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (2 - 1)) and v16:IsInRange(6 + 2) and v26) or ((4904 - 3313) >= (8851 - 5271))) then
					if (((1416 - (279 + 154)) <= (2586 - (454 + 324))) and v82.TargetIsValid() and v16:IsInRange(8 + 2) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v189 = 17 - (12 + 5);
						while true do
							if ((v189 == (0 + 0)) or ((5478 - 3328) <= (443 + 754))) then
								if (((4862 - (277 + 816)) >= (5012 - 3839)) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
									if (((2668 - (1058 + 125)) == (279 + 1206)) and v11(v84.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v15:StealthUp(true, false) or ((4290 - (815 + 160)) <= (11936 - 9154))) then
									v94 = v83.Stealth(v83.StealthSpell());
									if (v94 or ((2079 - 1203) >= (708 + 2256))) then
										return v94;
									end
								end
								v189 = 2 - 1;
							end
							if ((v189 == (1899 - (41 + 1857))) or ((4125 - (1222 + 671)) > (6453 - 3956))) then
								if (v82.TargetIsValid() or ((3032 - 922) <= (1514 - (229 + 953)))) then
									local v197 = 1774 - (1111 + 663);
									while true do
										if (((5265 - (874 + 705)) > (445 + 2727)) and (v197 == (2 + 0))) then
											if (v84.SinisterStrike:IsCastable() or ((9299 - 4825) < (24 + 796))) then
												if (((4958 - (642 + 37)) >= (658 + 2224)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v197 == (1 + 0)) or ((5093 - 3064) >= (3975 - (233 + 221)))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((2 - 1) + v97) * (1.8 + 0)))) or ((3578 - (718 + 823)) >= (2922 + 1720))) then
												if (((2525 - (266 + 539)) < (12621 - 8163)) and v9.Press(v84.SliceandDice)) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (v15:StealthUp(true, false) or ((1661 - (636 + 589)) > (7171 - 4150))) then
												v94 = v122();
												if (((1470 - 757) <= (672 + 175)) and v94) then
													return "Stealth (Opener): " .. v94;
												end
												if (((783 + 1371) <= (5046 - (657 + 358))) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
													if (((12219 - 7604) == (10514 - 5899)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((4977 - (1151 + 36)) == (483 + 17))) then
													if (((24 + 65) < (659 - 438)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((3886 - (1552 + 280)) >= (2255 - (64 + 770))) and v84.SinisterStrike:IsCastable()) then
													if (((470 + 222) < (6941 - 3883)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
											elseif (v114() or ((578 + 2676) == (2898 - (157 + 1086)))) then
												v94 = v123();
												if (v94 or ((2593 - 1297) == (21504 - 16594))) then
													return "Finish (Opener): " .. v94;
												end
											end
											v197 = 2 - 0;
										end
										if (((4596 - 1228) == (4187 - (599 + 220))) and (v197 == (0 - 0))) then
											if (((4574 - (1813 + 118)) < (2789 + 1026)) and v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (1217 - (841 + 376))) or v113())) then
												if (((2679 - 766) > (115 + 378)) and v9.Cast(v84.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if (((12978 - 8223) > (4287 - (464 + 395))) and v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (5 - 3))) then
												if (((664 + 717) <= (3206 - (467 + 370))) and v9.Cast(v84.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v197 = 1 - 0;
										end
									end
								end
								return;
							end
						end
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) or ((3556 + 1287) == (13999 - 9915))) then
					v97 = v25(v97, v83.FanTheHammerCP());
				end
				v141 = 1 + 5;
			end
			if (((10862 - 6193) > (883 - (150 + 370))) and (v141 == (1288 - (74 + 1208)))) then
				if (v82.TargetIsValid() or ((4616 - 2739) >= (14882 - 11744))) then
					local v183 = 0 + 0;
					while true do
						if (((5132 - (14 + 376)) >= (6289 - 2663)) and (v183 == (2 + 0))) then
							if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(5 + 0)) or ((4330 + 210) == (2683 - 1767))) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((870 + 286) > (4423 - (23 + 55)))) then
									return "Cast Lights Judgment";
								end
							end
							if (((5301 - 3064) < (2836 + 1413)) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(5 + 0)) then
								if (v9.Cast(v84.BagofTricks, v30) or ((4159 - 1476) < (8 + 15))) then
									return "Cast Bag of Tricks";
								end
							end
							if (((1598 - (652 + 249)) <= (2210 - 1384)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (1893 - (708 + 1160))) and ((v98 >= (2 - 1)) or (v102 <= (1.2 - 0)))) then
								if (((1132 - (10 + 17)) <= (265 + 911)) and v9.Cast(v84.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((5111 - (1400 + 332)) <= (7311 - 3499)) and v84.SinisterStrike:IsCastable()) then
								if (v9.Cast(v84.SinisterStrike) or ((2696 - (242 + 1666)) >= (692 + 924))) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if (((680 + 1174) <= (2880 + 499)) and (v183 == (941 - (850 + 90)))) then
							v94 = v124();
							if (((7966 - 3417) == (5939 - (360 + 1030))) and v94) then
								return "Build: " .. v94;
							end
							if ((v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > (14 + 1 + v100))) or ((8529 - 5507) >= (4160 - 1136))) then
								if (((6481 - (909 + 752)) > (3421 - (109 + 1114))) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((1942 - 881) >= (1904 + 2987))) then
								if (((1606 - (6 + 236)) <= (2819 + 1654)) and v9.Cast(v84.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							v183 = 2 + 0;
						end
						if ((v183 == (0 - 0)) or ((6279 - 2684) <= (1136 - (1076 + 57)))) then
							v94 = v121();
							if (v94 or ((769 + 3903) == (4541 - (579 + 110)))) then
								return "CDs: " .. v94;
							end
							if (((124 + 1435) == (1379 + 180)) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
								v94 = v122();
								if (v94 or ((930 + 822) <= (1195 - (174 + 233)))) then
									return "Stealth: " .. v94;
								end
							end
							if (v114() or ((10913 - 7006) == (310 - 133))) then
								v94 = v123();
								if (((1544 + 1926) > (1729 - (663 + 511))) and v94) then
									return "Finish: " .. v94;
								end
							end
							v183 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v141 == (1 + 3)) or ((2996 - 2024) == (391 + 254))) then
				if (((7491 - 4309) >= (5120 - 3005)) and v32 and (v15:HealthPercentage() <= v34)) then
					if (((1858 + 2035) < (8619 - 4190)) and (v33 == "Refreshing Healing Potion")) then
						if (v85.RefreshingHealingPotion:IsReady() or ((2044 + 823) < (175 + 1730))) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((2518 - (478 + 244)) >= (4568 - (440 + 77)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((737 + 882) <= (13746 - 9990)) and (v33 == "Dreamwalker's Healing Potion")) then
						if (((2160 - (655 + 901)) == (113 + 491)) and v85.DreamwalkersHealingPotion:IsReady()) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((3433 + 1051) == (608 + 292))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if ((v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) or ((17963 - 13504) <= (2558 - (695 + 750)))) then
					if (((12402 - 8770) > (5243 - 1845)) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((16416 - 12334) <= (5268 - (285 + 66))) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (((11263 - 6431) >= (2696 - (682 + 628))) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((23 + 114) == (436 - (176 + 123))) and not v15:IsCasting() and not v15:IsChanneling()) then
					local v184 = v82.Interrupt(v84.Kick, 4 + 4, true);
					if (v184 or ((1139 + 431) >= (4601 - (239 + 30)))) then
						return v184;
					end
					v184 = v82.Interrupt(v84.Kick, 3 + 5, true, v12, v86.KickMouseover);
					if (v184 or ((3907 + 157) <= (3219 - 1400))) then
						return v184;
					end
					v184 = v82.Interrupt(v84.Blind, 46 - 31, v79);
					if (v184 or ((5301 - (306 + 9)) < (5492 - 3918))) then
						return v184;
					end
					v184 = v82.Interrupt(v84.Blind, 3 + 12, v79, v12, v86.BlindMouseover);
					if (((2716 + 1710) > (83 + 89)) and v184) then
						return v184;
					end
					v184 = v82.InterruptWithStun(v84.CheapShot, 22 - 14, v15:StealthUp(false, false));
					if (((1961 - (1140 + 235)) > (290 + 165)) and v184) then
						return v184;
					end
					v184 = v82.InterruptWithStun(v84.KidneyShot, 8 + 0, v15:ComboPoints() > (0 + 0));
					if (((878 - (33 + 19)) == (299 + 527)) and v184) then
						return v184;
					end
				end
				v141 = 14 - 9;
			end
			if ((v141 == (2 + 1)) or ((7881 - 3862) > (4165 + 276))) then
				if (((2706 - (586 + 103)) < (388 + 3873)) and v27) then
					local v185 = 0 - 0;
					while true do
						if (((6204 - (1309 + 179)) > (144 - 64)) and (v185 == (1 + 0))) then
							v93 = #v92;
							break;
						end
						if ((v185 == (0 - 0)) or ((2649 + 858) == (6951 - 3679))) then
							v91 = v15:GetEnemiesInRange(59 - 29);
							v92 = v15:GetEnemiesInRange(v95);
							v185 = 610 - (295 + 314);
						end
					end
				else
					v93 = 2 - 1;
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((2838 - (1300 + 662)) >= (9655 - 6580))) then
					return v94;
				end
				v83.Poisons();
				v141 = 1759 - (1178 + 577);
			end
			if (((2261 + 2091) > (7550 - 4996)) and (v141 == (1407 - (851 + 554)))) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v141 = 3 + 0;
			end
			if ((v141 == (0 - 0)) or ((9568 - 5162) < (4345 - (115 + 187)))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v141 = 1 + 0;
			end
			if ((v141 == (1 + 0)) or ((7443 - 5554) >= (4544 - (160 + 1001)))) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(44 + 6)) or (0 + 0);
				v141 = 3 - 1;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(618 - (237 + 121), v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

