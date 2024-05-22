local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2933 - (1269 + 200)) > (4216 - 2016))) then
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
		local v127 = 815 - (98 + 717);
		while true do
			if ((v127 == (834 - (802 + 24))) or ((2338 - 982) > (5964 - 1241))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 2 + 7;
			end
			if ((v127 == (5 + 1)) or ((680 + 3456) <= (741 + 2692))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 19 - 12;
			end
			if (((14155 - 9910) <= (1657 + 2974)) and (v127 == (1 + 0))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v127 = 1 + 1;
			end
			if (((5709 - (797 + 636)) >= (19003 - 15089)) and (v127 == (1619 - (1427 + 192)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1 + 0;
			end
			if (((459 - 261) <= (3924 + 441)) and (v127 == (5 + 4))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (326 - (192 + 134));
				break;
			end
			if (((6058 - (316 + 960)) > (2603 + 2073)) and (v127 == (6 + 1))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 8 + 0;
			end
			if (((18595 - 13731) > (2748 - (83 + 468))) and (v127 == (1811 - (1202 + 604)))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v58 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 16 - 10;
			end
			if ((v127 == (328 - (45 + 280))) or ((3572 + 128) == (2191 + 316))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 2 + 2;
			end
			if (((2476 + 1998) >= (49 + 225)) and (v127 == (3 - 1))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1911 - (340 + 1571));
				v127 = 2 + 1;
			end
			if ((v127 == (1776 - (1733 + 39))) or ((5204 - 3310) <= (2440 - (125 + 909)))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 1953 - (1096 + 852);
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
	local v89 = (v88[6 + 7] and v19(v88[17 - 4])) or v19(0 + 0);
	local v90 = (v88[526 - (409 + 103)] and v19(v88[250 - (46 + 190)])) or v19(95 - (51 + 44));
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[4 + 9] and v19(v88[1330 - (1114 + 203)])) or v19(726 - (228 + 498));
		v90 = (v88[4 + 10] and v19(v88[8 + 6])) or v19(663 - (174 + 489));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 15 - 9;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 0 - 0, 0 - 0;
	local function v107(v128)
		local v129 = 0 - 0;
		local v130;
		while true do
			if (((4859 - 3287) >= (2779 - (111 + 1137))) and (v129 == (159 - (91 + 67)))) then
				return v105;
			end
			if ((v129 == (0 - 0)) or ((1170 + 3517) < (5065 - (423 + 100)))) then
				v130 = v15:EnergyTimeToMaxPredicted(nil, v128);
				if (((24 + 3267) > (4615 - 2948)) and ((v130 < v105) or ((v130 - v105) > (0.5 + 0)))) then
					v105 = v130;
				end
				v129 = 772 - (326 + 445);
			end
		end
	end
	local function v108()
		local v131 = 0 - 0;
		local v132;
		while true do
			if ((v131 == (0 - 0)) or ((2037 - 1164) == (2745 - (530 + 181)))) then
				v132 = v15:EnergyPredicted();
				if ((v132 > v106) or ((v132 - v106) > (890 - (614 + 267))) or ((2848 - (19 + 13)) < (17 - 6))) then
					v106 = v132;
				end
				v131 = 2 - 1;
			end
			if (((10566 - 6867) < (1223 + 3483)) and (v131 == (1 - 0))) then
				return v106;
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((6232 - 3586) >= (464 + 412)) and not v10.APLVar.RtB_Buffs) then
			local v141 = 0 + 0;
			local v142;
			while true do
				if (((1426 - 812) <= (736 + 2448)) and (v141 == (1 + 1))) then
					v142 = v83.RtBRemains();
					for v185 = 1 + 0, #v109 do
						local v186 = v15:BuffRemains(v109[v185]);
						if (((4222 - (709 + 387)) == (4984 - (673 + 1185))) and (v186 > (0 - 0))) then
							v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (3 - 2);
							if ((v186 > v10.APLVar.RtB_Buffs.MaxRemains) or ((3597 - 1410) >= (3544 + 1410))) then
								v10.APLVar.RtB_Buffs.MaxRemains = v186;
							end
							local v191 = math.abs(v186 - v142);
							if ((v191 <= (0.5 + 0)) or ((5234 - 1357) == (879 + 2696))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (1 - 0);
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v185]:Name()] = true;
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (1 - 0);
							elseif (((2587 - (446 + 1434)) > (1915 - (1040 + 243))) and (v186 > v142)) then
								v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (2 - 1);
							else
								local v201 = 1847 - (559 + 1288);
								while true do
									if ((v201 == (1931 - (609 + 1322))) or ((1000 - (13 + 441)) >= (10029 - 7345))) then
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (2 - 1);
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v185]:Name()] = true;
										v201 = 4 - 3;
									end
									if (((55 + 1410) <= (15620 - 11319)) and (v201 == (1 + 0))) then
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
										break;
									end
								end
							end
						end
						if (((5056 - 3352) > (780 + 645)) and v110) then
							local v192 = 0 - 0;
							while true do
								if ((v192 == (0 + 0)) or ((383 + 304) == (3043 + 1191))) then
									print("RtbRemains", v142);
									print(v109[v185]:Name(), v186);
									break;
								end
							end
						end
					end
					if (v110 or ((2797 + 533) < (1399 + 30))) then
						local v188 = 433 - (153 + 280);
						while true do
							if (((3311 - 2164) >= (301 + 34)) and (v188 == (1 + 0))) then
								print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v10.APLVar.RtB_Buffs.Normal);
								v188 = 2 + 0;
							end
							if (((3118 + 317) > (1520 + 577)) and (v188 == (2 - 0))) then
								print("longer: ", v10.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if ((v188 == (0 + 0)) or ((4437 - (89 + 578)) >= (2887 + 1154))) then
								print("have: ", v10.APLVar.RtB_Buffs.Total);
								print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
								v188 = 1 - 0;
							end
						end
					end
					break;
				end
				if (((1050 - (572 + 477)) == v141) or ((512 + 3279) <= (967 + 644))) then
					v10.APLVar.RtB_Buffs.Normal = 0 + 0;
					v10.APLVar.RtB_Buffs.Shorter = 86 - (84 + 2);
					v10.APLVar.RtB_Buffs.Longer = 0 - 0;
					v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v141 = 844 - (497 + 345);
				end
				if ((v141 == (0 + 0)) or ((774 + 3804) <= (3341 - (605 + 728)))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Will_Lose = {};
					v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
					v10.APLVar.RtB_Buffs.Total = 0 - 0;
					v141 = 1 + 0;
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v133)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v113()
		if (((4159 - 3034) <= (1872 + 204)) and not v10.APLVar.RtB_Reroll) then
			if ((v64 == "1+ Buff") or ((2058 - 1315) >= (3322 + 1077))) then
				v10.APLVar.RtB_Reroll = ((v111() <= (489 - (457 + 32))) and true) or false;
			elseif (((491 + 664) < (3075 - (832 + 570))) and (v64 == "Broadside")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif ((v64 == "Buried Treasure") or ((2190 + 134) <= (151 + 427))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif (((13330 - 9563) == (1815 + 1952)) and (v64 == "Grand Melee")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif (((4885 - (588 + 208)) == (11020 - 6931)) and (v64 == "Skull and Crossbones")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((6258 - (884 + 916)) >= (3504 - 1830)) and (v64 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif (((564 + 408) <= (2071 - (232 + 421))) and (v64 == "True Bearing")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				v10.APLVar.RtB_Reroll = false;
				v111();
				v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (1891 - (1569 + 320)))));
				if ((v84.Crackshot:IsAvailable() and not v15:HasTier(8 + 23, 1 + 3)) or ((16639 - 11701) < (5367 - (316 + 289)))) then
					v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (2 - 1)));
				end
				if ((v84.Crackshot:IsAvailable() and v15:HasTier(2 + 29, 1457 - (666 + 787))) or ((2929 - (360 + 65)) > (3985 + 279))) then
					v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((255 - (79 + 175)) + v21(v15:BuffUp(v84.LoadedDiceBuff)));
				end
				if (((3394 - 1241) == (1681 + 472)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((5 - 3) + v21(v112(v84.GrandMelee)))) and (v93 < (3 - 1))) then
					v10.APLVar.RtB_Reroll = true;
				end
				v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (899 - (503 + 396))) or ((v10.APLVar.RtB_Buffs.Normal == (181 - (92 + 89))) and (v10.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v111() < (4 + 2)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (24 + 15)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
				if (v16:FilteredTimeToDie("<", 46 - 34) or v9.BossFilteredFightRemains("<", 2 + 10) or ((1155 - 648) >= (2261 + 330))) then
					v10.APLVar.RtB_Reroll = false;
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (1 + 0)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((5 - 3) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (7 + 43));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (2 - 0)) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 1244 - (485 + 759);
		while true do
			if (((10368 - 5887) == (5670 - (442 + 747))) and (v134 == (1137 - (832 + 303)))) then
				if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (976 - (88 + 858))) or ((v84.KeepItRolling:CooldownRemains() >= (37 + 83)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((1927 + 401) < (29 + 664))) then
					if (((5117 - (766 + 23)) == (21366 - 17038)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				if (((2171 - 583) >= (3509 - 2177)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
					if ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())) or ((14166 - 9992) > (5321 - (1036 + 37)))) then
						if (v9.Cast(v84.Shadowmeld, v30) or ((3252 + 1334) <= (159 - 77))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((3039 + 824) == (5343 - (641 + 839))) and (v134 == (914 - (910 + 3)))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (15 - 9)) or not v67) and not v15:StealthUp(true, false)) or ((1966 - (1466 + 218)) <= (20 + 22))) then
					if (((5757 - (556 + 592)) >= (273 + 493)) and v9.Cast(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((1960 - (329 + 479)) == (3342 - (174 + 680)))) then
					if (((11758 - 8336) > (6943 - 3593)) and v11(v84.ShadowDance, v53)) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 2 + 0;
			end
			if (((1616 - (396 + 343)) > (34 + 342)) and (v134 == (1477 - (29 + 1448)))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (1395 - (135 + 1254)))) and v115()) or ((11746 - 8628) <= (8642 - 6791))) then
					if (v9.Cast(v84.Vanish, v67) or ((110 + 55) >= (5019 - (389 + 1138)))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((4523 - (102 + 472)) < (4583 + 273)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (v9.Cast(v84.Vanish, v67) or ((2372 + 1904) < (2813 + 203))) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 1546 - (320 + 1225);
			end
		end
	end
	local function v120()
		local v135 = v82.HandleTopTrinket(v87, v28, 14 - 6, nil);
		if (((2870 + 1820) > (5589 - (157 + 1307))) and v135) then
			return v135;
		end
		local v135 = v82.HandleBottomTrinket(v87, v28, 1867 - (821 + 1038), nil);
		if (v135 or ((124 - 74) >= (98 + 798))) then
			return v135;
		end
	end
	local function v121()
		local v136 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (v136 or ((3044 - 1330) >= (1101 + 1857))) then
			return "DPS Pot";
		end
		if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (4 - 2))))) or ((2517 - (834 + 192)) < (41 + 603))) then
			if (((181 + 523) < (22 + 965)) and v11(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((5759 - 2041) > (2210 - (300 + 4))) and v84.BladeFlurry:IsReady()) then
			if (((v93 >= ((1 + 1) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((2507 - 1549) > (3997 - (112 + 250)))) then
				if (((1396 + 2105) <= (11253 - 6761)) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.BladeFlurry:IsReady() or ((1972 + 1470) < (1318 + 1230))) then
			if (((2151 + 724) >= (726 + 738)) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (3 + 0)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1419 - (1001 + 413))))) then
				if (v11(v84.BladeFlurry) or ((10697 - 5900) >= (5775 - (244 + 638)))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.RolltheBones:IsReady() or ((1244 - (627 + 66)) > (6161 - 4093))) then
			if (((2716 - (512 + 90)) > (2850 - (1665 + 241))) and (v113() or (v111() == (717 - (373 + 344))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (2 + 1)) and v15:HasTier(9 + 22, 10 - 6)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (11 - 4)) and ((v84.ShadowDance:CooldownRemains() <= (1102 - (35 + 1064))) or (v84.Vanish:CooldownRemains() <= (3 + 0)))))) then
				if (v11(v84.RolltheBones) or ((4839 - 2577) >= (13 + 3083))) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v137 = v120();
		if (v137 or ((3491 - (298 + 938)) >= (4796 - (233 + 1026)))) then
			return v137;
		end
		if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((1669 - (636 + 1030)) + v21(v15:HasTier(16 + 15, 4 + 0)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (2 + 4)))) or ((260 + 3577) < (1527 - (55 + 166)))) then
			if (((572 + 2378) == (297 + 2653)) and v9.Cast(v84.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (26 - 19))) or ((5020 - (36 + 261)) < (5767 - 2469))) then
			if (((2504 - (34 + 1334)) >= (60 + 94)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((211 + 60) > (6031 - (1035 + 248)))) then
			if (((4761 - (20 + 1)) >= (1643 + 1509)) and ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 330 - (134 + 185)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1144 - (549 + 584)))) then
				if (v9.Cast(v84.Sepsis) or ((3263 - (314 + 371)) >= (11637 - 8247))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((1009 - (478 + 490)) <= (880 + 781)) and v84.BladeRush:IsReady() and (v102 > (1176 - (786 + 386))) and not v15:StealthUp(true, true)) then
			if (((1946 - 1345) < (4939 - (1055 + 324))) and v9.Cast(v84.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((1575 - (1093 + 247)) < (611 + 76)) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
			local v143 = 0 + 0;
			while true do
				if (((18060 - 13511) > (3912 - 2759)) and (v143 == (0 - 0))) then
					v137 = v119();
					if (v137 or ((11745 - 7071) < (1662 + 3010))) then
						return v137;
					end
					break;
				end
			end
		end
		if (((14130 - 10462) < (15720 - 11159)) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (76 + 24)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (15 - 9)))) then
			if (v9.Cast(v84.ThistleTea) or ((1143 - (364 + 324)) == (9882 - 6277))) then
				return "Cast Thistle Tea";
			end
		end
		if ((v84.BladeRush:IsCastable() and (v102 > (9 - 5)) and not v15:StealthUp(true, true)) or ((883 + 1780) == (13858 - 10546))) then
			if (((6849 - 2572) <= (13591 - 9116)) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((2138 - (1249 + 19)) == (1074 + 115))) then
			if (((6045 - 4492) <= (4219 - (686 + 400))) and v9.Cast(v84.BloodFury, v30)) then
				return "Cast Blood Fury";
			end
		end
		if (v84.Berserking:IsCastable() or ((1756 + 481) >= (3740 - (73 + 156)))) then
			if (v9.Cast(v84.Berserking, v30) or ((7 + 1317) > (3831 - (721 + 90)))) then
				return "Cast Berserking";
			end
		end
		if (v84.Fireblood:IsCastable() or ((34 + 2958) == (6107 - 4226))) then
			if (((3576 - (224 + 246)) > (2471 - 945)) and v9.Cast(v84.Fireblood, v30)) then
				return "Cast Fireblood";
			end
		end
		if (((5565 - 2542) < (702 + 3168)) and v84.AncestralCall:IsCastable()) then
			if (((4 + 139) > (55 + 19)) and v9.Cast(v84.AncestralCall, v30)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		if (((35 - 17) < (7028 - 4916)) and v84.BladeFlurry:IsReady()) then
			if (((1610 - (203 + 310)) <= (3621 - (1238 + 755))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1 + 2)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1539 - (709 + 825))))) then
				if (((8532 - 3902) == (6744 - 2114)) and v11(v84.BladeFlurry, v70)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((4404 - (196 + 668)) > (10593 - 7910)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
			if (((9930 - 5136) >= (4108 - (171 + 662))) and v9.Cast(v84.ColdBlood, v55)) then
				return "Cast Cold Blood";
			end
		end
		if (((1577 - (4 + 89)) == (5201 - 3717)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
			if (((522 + 910) < (15614 - 12059)) and v9.Cast(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((418 + 647) > (5064 - (35 + 1451)))) then
			if (v9.Press(v84.Dispatch) or ((6248 - (28 + 1425)) < (3400 - (941 + 1052)))) then
				return "Cast Dispatch";
			end
		end
		if (((1777 + 76) < (6327 - (822 + 692))) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (2 - 0)) and (v15:BuffStack(v84.Opportunity) >= (3 + 3)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (298 - (45 + 252)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
			if (v9.Press(v84.PistolShot) or ((2792 + 29) < (837 + 1594))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((6994 - 4120) < (2614 - (114 + 319)))) then
			if (v11(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush)) or ((3860 - 1171) <= (438 - 95))) then
				return "Cast Ambush (SS High-Prio Buffed)";
			end
		end
		if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((1192 + 677) == (2992 - 983))) then
			if (v9.Press(v84.Ambush) or ((7429 - 3883) < (4285 - (556 + 1407)))) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		local v138 = 1206 - (741 + 465);
		while true do
			if ((v138 == (466 - (170 + 295))) or ((1097 + 985) == (4385 + 388))) then
				if (((7986 - 4742) > (875 + 180)) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1231.8 - (957 + 273))))) then
					if (v9.Press(v84.SliceandDice) or ((887 + 2426) <= (712 + 1066))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((5414 - 3993) >= (5544 - 3440))) then
					if (((5534 - 3722) <= (16088 - 12839)) and v9.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v138 = 1782 - (389 + 1391);
			end
			if (((1019 + 604) <= (204 + 1753)) and (v138 == (0 - 0))) then
				if (((5363 - (783 + 168)) == (14807 - 10395)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (4 + 0)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(341 - (309 + 2), 12 - 8)) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (((2962 - (1090 + 122)) >= (273 + 569)) and v9.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((14683 - 10311) > (1267 + 583)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (1163 - (628 + 490))) and (v84.ShadowDance:CooldownRemains() > (3 + 9))) then
					if (((573 - 341) < (3751 - 2930)) and v9.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v138 = 775 - (431 + 343);
			end
			if (((1046 - 528) < (2609 - 1707)) and (v138 == (2 + 0))) then
				if (((383 + 2611) > (2553 - (556 + 1139))) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) then
					if (v9.Cast(v84.ColdBlood, v55) or ((3770 - (6 + 9)) <= (168 + 747))) then
						return "Cast Cold Blood";
					end
				end
				if (((2022 + 1924) > (3912 - (28 + 141))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
					if (v9.Press(v84.Dispatch) or ((518 + 817) >= (4080 - 774))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((6161 - (486 + 831)) > (5862 - 3609)) and (v139 == (10 - 7))) then
				if (((86 + 366) == (1429 - 977)) and v84.SinisterStrike:IsCastable()) then
					if (v9.Press(v84.SinisterStrike) or ((5820 - (668 + 595)) < (1878 + 209))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((782 + 3092) == (10564 - 6690)) and (v139 == (290 - (23 + 267)))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((3882 - (1129 + 815)) > (5322 - (371 + 16)))) then
					if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((6005 - (1326 + 424)) < (6482 - 3059))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (((5313 - 3859) <= (2609 - (88 + 30))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v9.Press(v84.Ambush) or ((4928 - (720 + 51)) <= (6235 - 3432))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v139 = 1777 - (421 + 1355);
			end
			if (((8006 - 3153) >= (1465 + 1517)) and (v139 == (1085 - (286 + 797)))) then
				if (((15112 - 10978) > (5560 - 2203)) and v84.PistolShot.IsCastable() and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((440 - (397 + 42)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) then
					if (v9.Press(v84.PistolShot) or ((4217 - (24 + 776)) < (3903 - 1369))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((v84.PistolShot.IsCastable() and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (786.5 - (222 + 563))) or (v98 <= ((1 - 0) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((1960 + 762) <= (354 - (23 + 167)))) then
					if (v9.Cast(v84.PistolShot) or ((4206 - (690 + 1108)) < (761 + 1348))) then
						return "Cast Pistol Shot";
					end
				end
				v139 = 3 + 0;
			end
			if ((v139 == (849 - (40 + 808))) or ((6 + 27) == (5563 - 4108))) then
				if ((v84.PistolShot.IsCastable() and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((424 + 19) >= (2125 + 1890))) then
					if (((1855 + 1527) > (737 - (47 + 524))) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.PistolShot.IsCastable() and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (4 + 2)) or (v15:BuffRemains(v84.Opportunity) < (5 - 3)))) or ((418 - 138) == (6976 - 3917))) then
					if (((3607 - (1165 + 561)) > (39 + 1254)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v139 = 6 - 4;
			end
		end
	end
	local function v125()
		local v140 = 0 + 0;
		while true do
			if (((2836 - (341 + 138)) == (637 + 1720)) and (v140 == (12 - 6))) then
				if (((449 - (89 + 237)) == (395 - 272)) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (v9.Cast(v84.Evasion) or ((2222 - 1166) >= (4273 - (581 + 300)))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((2301 - (855 + 365)) < (2553 - 1478))) then
					local v180 = 0 + 0;
					local v181;
					while true do
						if ((v180 == (1236 - (1030 + 205))) or ((985 + 64) >= (4123 + 309))) then
							if (v181 or ((5054 - (156 + 130)) <= (1922 - 1076))) then
								return v181;
							end
							v181 = v82.Interrupt(v84.Blind, 25 - 10, v79);
							if (v181 or ((6877 - 3519) <= (375 + 1045))) then
								return v181;
							end
							v180 = 2 + 0;
						end
						if ((v180 == (71 - (10 + 59))) or ((1058 + 2681) <= (14798 - 11793))) then
							v181 = v82.Interrupt(v84.Blind, 1178 - (671 + 492), v79, v12, v86.BlindMouseover);
							if (v181 or ((1321 + 338) >= (3349 - (369 + 846)))) then
								return v181;
							end
							v181 = v82.InterruptWithStun(v84.CheapShot, 3 + 5, v15:StealthUp(false, false));
							v180 = 3 + 0;
						end
						if ((v180 == (1948 - (1036 + 909))) or ((2592 + 668) < (3953 - 1598))) then
							if (v181 or ((872 - (11 + 192)) == (2135 + 2088))) then
								return v181;
							end
							v181 = v82.InterruptWithStun(v84.KidneyShot, 183 - (135 + 40), v15:ComboPoints() > (0 - 0));
							if (v181 or ((1020 + 672) < (1295 - 707))) then
								return v181;
							end
							break;
						end
						if ((v180 == (0 - 0)) or ((4973 - (50 + 126)) < (10166 - 6515))) then
							v181 = v82.Interrupt(v84.Kick, 2 + 6, true);
							if (v181 or ((5590 - (1233 + 180)) > (5819 - (522 + 447)))) then
								return v181;
							end
							v181 = v82.Interrupt(v84.Kick, 1429 - (107 + 1314), true, v12, v86.KickMouseover);
							v180 = 1 + 0;
						end
					end
				end
				if (v29 or ((1218 - 818) > (472 + 639))) then
					v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 59 - 29, true);
					if (((12071 - 9020) > (2915 - (716 + 1194))) and v94) then
						return v94;
					end
				end
				v140 = 1 + 6;
			end
			if (((396 + 3297) <= (4885 - (74 + 429))) and ((0 - 0) == v140)) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v140 = 1 + 0;
			end
			if ((v140 == (8 - 4)) or ((2322 + 960) > (12640 - 8540))) then
				if (v27 or ((8851 - 5271) < (3277 - (279 + 154)))) then
					local v182 = 778 - (454 + 324);
					while true do
						if (((71 + 18) < (4507 - (12 + 5))) and (v182 == (1 + 0))) then
							v93 = #v92;
							break;
						end
						if ((v182 == (0 - 0)) or ((1842 + 3141) < (2901 - (277 + 816)))) then
							v91 = v15:GetEnemiesInRange(128 - 98);
							v92 = v15:GetEnemiesInRange(v95);
							v182 = 1184 - (1058 + 125);
						end
					end
				else
					v93 = 1 + 0;
				end
				v94 = v83.CrimsonVial();
				if (((4804 - (815 + 160)) > (16171 - 12402)) and v94) then
					return v94;
				end
				v140 = 11 - 6;
			end
			if (((355 + 1130) <= (8488 - 5584)) and ((1899 - (41 + 1857)) == v140)) then
				v28 = EpicSettings.Toggles['cds'];
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v140 = 1895 - (1222 + 671);
			end
			if (((11033 - 6764) == (6135 - 1866)) and ((1190 - (229 + 953)) == v140)) then
				if (((2161 - (1111 + 663)) <= (4361 - (874 + 705))) and v82.TargetIsValid()) then
					local v183 = 0 + 0;
					while true do
						if ((v183 == (1 + 0)) or ((3946 - 2047) <= (26 + 891))) then
							v94 = v124();
							if (v94 or ((4991 - (642 + 37)) <= (200 + 676))) then
								return "Build: " .. v94;
							end
							if (((358 + 1874) <= (6517 - 3921)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((469 - (233 + 221)) + v100))) then
								if (((4844 - 2749) < (3245 + 441)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((3136 - (718 + 823)) >= (2816 + 1658))) then
								if (v9.Cast(v84.ArcanePulse) or ((5424 - (266 + 539)) < (8159 - 5277))) then
									return "Cast Arcane Pulse";
								end
							end
							v183 = 1227 - (636 + 589);
						end
						if (((4 - 2) == v183) or ((606 - 312) >= (3829 + 1002))) then
							if (((738 + 1291) <= (4099 - (657 + 358))) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(13 - 8)) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((4640 - 2603) == (3607 - (1151 + 36)))) then
									return "Cast Lights Judgment";
								end
							end
							if (((4306 + 152) > (1027 + 2877)) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(14 - 9)) then
								if (((2268 - (1552 + 280)) >= (957 - (64 + 770))) and v9.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if (((340 + 160) < (4122 - 2306)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (5 + 20)) and ((v98 >= (1244 - (157 + 1086))) or (v102 <= (1.2 - 0)))) then
								if (((15653 - 12079) == (5482 - 1908)) and v9.Cast(v84.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							break;
						end
						if (((301 - 80) < (1209 - (599 + 220))) and ((0 - 0) == v183)) then
							v94 = v121();
							if (v94 or ((4144 - (1813 + 118)) <= (1039 + 382))) then
								return "CDs: " .. v94;
							end
							if (((4275 - (841 + 376)) < (6810 - 1950)) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
								v94 = v122();
								if (v94 or ((302 + 994) >= (12135 - 7689))) then
									return "Stealth: " .. v94;
								end
							end
							if (v114() or ((2252 - (464 + 395)) > (11520 - 7031))) then
								local v199 = 0 + 0;
								while true do
									if ((v199 == (837 - (467 + 370))) or ((9142 - 4718) < (20 + 7))) then
										v94 = v123();
										if (v94 or ((6845 - 4848) > (596 + 3219))) then
											return "Finish: " .. v94;
										end
										v199 = 2 - 1;
									end
									if (((3985 - (150 + 370)) > (3195 - (74 + 1208))) and (v199 == (2 - 1))) then
										return "Finish Pooling";
									end
								end
							end
							v183 = 4 - 3;
						end
					end
				end
				break;
			end
			if (((522 + 211) < (2209 - (14 + 376))) and (v140 == (8 - 3))) then
				v83.Poisons();
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((2844 + 1551) == (4178 + 577))) then
					local v184 = 0 + 0;
					while true do
						if ((v184 == (0 - 0)) or ((2854 + 939) < (2447 - (23 + 55)))) then
							if ((v33 == "Refreshing Healing Potion") or ((9678 - 5594) == (177 + 88))) then
								if (((3914 + 444) == (6756 - 2398)) and v85.RefreshingHealingPotion:IsReady()) then
									if (v9.Press(v86.RefreshingHealingPotion) or ((988 + 2150) < (1894 - (652 + 249)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((8911 - 5581) > (4191 - (708 + 1160))) and (v33 == "Dreamwalker's Healing Potion")) then
								if (v85.DreamwalkersHealingPotion:IsReady() or ((9842 - 6216) == (7272 - 3283))) then
									if (v9.Press(v86.RefreshingHealingPotion) or ((943 - (10 + 17)) == (600 + 2071))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((2004 - (1400 + 332)) == (521 - 249)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (((6157 - (242 + 1666)) <= (2071 + 2768)) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v140 = 3 + 3;
			end
			if (((2367 + 410) < (4140 - (850 + 90))) and (v140 == (12 - 5))) then
				if (((1485 - (360 + 1030)) < (1732 + 225)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (((2330 - 1504) < (2362 - 645)) and v94) then
						return "Stealth (OOC): " .. v94;
					end
				end
				if (((3087 - (909 + 752)) >= (2328 - (109 + 1114))) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(4 + 4) and v26) then
					if (((2996 - (6 + 236)) <= (2129 + 1250)) and v82.TargetIsValid() and v16:IsInRange(9 + 1) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v189 = 0 - 0;
						while true do
							if ((v189 == (1 - 0)) or ((5060 - (1076 + 57)) == (233 + 1180))) then
								if (v82.TargetIsValid() or ((1843 - (579 + 110)) <= (63 + 725))) then
									if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 + 0)) or v113())) or ((872 + 771) > (3786 - (174 + 233)))) then
										if (v9.Cast(v84.RolltheBones) or ((7829 - 5026) > (7983 - 3434))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))) or ((1394 - (663 + 511)) >= (2696 + 326))) then
										if (((613 + 2209) == (8699 - 5877)) and v9.Cast(v84.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (2.8 - 1)))) or ((2568 - 1507) == (887 + 970))) then
										if (((5371 - 2611) > (973 + 391)) and v9.Press(v84.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v15:StealthUp(true, false) or ((449 + 4453) <= (4317 - (478 + 244)))) then
										local v205 = 517 - (440 + 77);
										while true do
											if (((0 + 0) == v205) or ((14098 - 10246) == (1849 - (655 + 901)))) then
												v94 = v122();
												if (v94 or ((290 + 1269) == (3513 + 1075))) then
													return "Stealth (Opener): " .. v94;
												end
												v205 = 1 + 0;
											end
											if ((v205 == (3 - 2)) or ((5929 - (695 + 750)) == (2690 - 1902))) then
												if (((7049 - 2481) >= (15712 - 11805)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
													if (((1597 - (285 + 66)) < (8088 - 4618)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (((5378 - (682 + 628)) >= (157 + 815)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
													if (((792 - (176 + 123)) < (1629 + 2264)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (v84.SinisterStrike:IsCastable() or ((1069 + 404) >= (3601 - (239 + 30)))) then
													if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((1102 + 2949) <= (1113 + 44))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
												break;
											end
										end
									elseif (((1068 - 464) < (8988 - 6107)) and v114()) then
										v94 = v123();
										if (v94 or ((1215 - (306 + 9)) == (11784 - 8407))) then
											return "Finish (Opener): " .. v94;
										end
									end
									if (((776 + 3683) > (363 + 228)) and v84.SinisterStrike:IsCastable()) then
										if (((1636 + 1762) >= (6848 - 4453)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
								end
								return;
							end
							if ((v189 == (1375 - (1140 + 235))) or ((1390 + 793) >= (2590 + 234))) then
								if (((497 + 1439) == (1988 - (33 + 19))) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
									if (v11(v84.BladeFlurry) or ((1745 + 3087) < (12927 - 8614))) then
										return "Blade Flurry (Opener)";
									end
								end
								if (((1801 + 2287) > (7597 - 3723)) and not v15:StealthUp(true, false)) then
									local v203 = 0 + 0;
									while true do
										if (((5021 - (586 + 103)) == (395 + 3937)) and (v203 == (0 - 0))) then
											v94 = v83.Stealth(v83.StealthSpell());
											if (((5487 - (1309 + 179)) >= (5235 - 2335)) and v94) then
												return v94;
											end
											break;
										end
									end
								end
								v189 = 1 + 0;
							end
						end
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) or ((6780 - 4255) > (3070 + 994))) then
					v97 = v25(v97, v83.FanTheHammerCP());
					v96 = v83.EffectiveComboPoints(v97);
					v98 = v15:ComboPointsDeficit();
				end
				v140 = 16 - 8;
			end
			if (((8709 - 4338) == (4980 - (295 + 314))) and (v140 == (6 - 3))) then
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v140 = 1966 - (1300 + 662);
			end
			if ((v140 == (6 - 4)) or ((2021 - (1178 + 577)) > (2590 + 2396))) then
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(147 - 97)) or (1405 - (851 + 554));
				v99 = v108();
				v140 = 3 + 0;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(721 - 461, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

