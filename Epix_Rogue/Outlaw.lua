local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3264 - 1009) < (35 - 13))) then
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
			if ((v127 == (15 - 7)) or ((3228 - 2142) >= (1344 + 61))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 1 + 8;
			end
			if ((v127 == (3 + 3)) or ((6184 - 3815) == (265 + 161))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'] or (1167 - (645 + 522));
				v127 = 1797 - (1010 + 780);
			end
			if ((v127 == (1 + 0)) or ((14653 - 11577) > (9327 - 6144))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (1836 - (1045 + 791));
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v127 = 2 - 0;
			end
			if (((1707 - (351 + 154)) > (2632 - (1281 + 293))) and (v127 == (266 - (28 + 238)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v127 = 1560 - (1381 + 178);
			end
			if (((3481 + 230) > (2706 + 649)) and (v127 == (4 + 5))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
				v80 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if ((v127 == (477 - (381 + 89))) or ((804 + 102) >= (1508 + 721))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 13 - 5;
			end
			if (((2444 - (1074 + 82)) > (2741 - 1490)) and (v127 == (1789 - (214 + 1570)))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (1455 - (990 + 465));
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 3 + 3;
			end
			if ((v127 == (3 + 0)) or ((17760 - 13247) < (5078 - (1668 + 58)))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 630 - (512 + 114);
			end
			if ((v127 == (5 - 3)) or ((4268 - 2203) >= (11120 - 7924))) then
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v127 = 10 - 7;
			end
			if ((v127 == (1998 - (109 + 1885))) or ((5845 - (1269 + 200)) <= (2838 - 1357))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 820 - (98 + 717);
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
	local v89 = (v88[839 - (802 + 24)] and v19(v88[22 - 9])) or v19(0 - 0);
	local v90 = (v88[3 + 11] and v19(v88[11 + 3])) or v19(0 + 0);
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[3 + 10] and v19(v88[36 - 23])) or v19(0 - 0);
		v90 = (v88[6 + 8] and v19(v88[6 + 8])) or v19(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v84.Dispatch:RegisterDamageFormula(function()
		return v15:AttackPowerDamageMod() * v83.CPSpend() * (0.3 + 0) * (1 + 0) * ((1434 - (797 + 636)) + (v15:VersatilityDmgPct() / (485 - 385))) * ((v16:DebuffUp(v84.GhostlyStrike) and (1620.1 - (1427 + 192))) or (1 + 0));
	end);
	local v91, v92, v93;
	local v94;
	local v95 = 13 - 7;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (551 - (83 + 468));
	end}};
	local v105, v106 = 1806 - (1202 + 604), 0 - 0;
	local function v107(v128)
		local v129 = v15:EnergyTimeToMaxPredicted(nil, v128);
		if ((v129 < v105) or ((v129 - v105) > (0.5 - 0)) or ((9391 - 5999) >= (5066 - (45 + 280)))) then
			v105 = v129;
		end
		return v105;
	end
	local function v108()
		local v130 = 0 + 0;
		local v131;
		while true do
			if (((2905 + 420) >= (787 + 1367)) and (v130 == (1 + 0))) then
				return v106;
			end
			if ((v130 == (0 + 0)) or ((2398 - 1103) >= (5144 - (340 + 1571)))) then
				v131 = v15:EnergyPredicted();
				if (((1727 + 2650) > (3414 - (1733 + 39))) and ((v131 > v106) or ((v131 - v106) > (24 - 15)))) then
					v106 = v131;
				end
				v130 = 1035 - (125 + 909);
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((4818 - (51 + 44)) > (383 + 973)) and not v10.APLVar.RtB_Buffs) then
			v10.APLVar.RtB_Buffs = {};
			v10.APLVar.RtB_Buffs.Will_Lose = {};
			v10.APLVar.RtB_Buffs.Will_Lose.Total = 1317 - (1114 + 203);
			v10.APLVar.RtB_Buffs.Total = 726 - (228 + 498);
			v10.APLVar.RtB_Buffs.Normal = 0 + 0;
			v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
			v10.APLVar.RtB_Buffs.Longer = 663 - (174 + 489);
			v10.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
			local v147 = v83.RtBRemains();
			for v167 = 1906 - (830 + 1075), #v109 do
				local v168 = v15:BuffRemains(v109[v167]);
				if ((v168 > (524 - (303 + 221))) or ((5405 - (231 + 1038)) <= (2861 + 572))) then
					v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1163 - (171 + 991));
					if (((17494 - 13249) <= (12435 - 7804)) and (v168 > v10.APLVar.RtB_Buffs.MaxRemains)) then
						v10.APLVar.RtB_Buffs.MaxRemains = v168;
					end
					local v174 = math.abs(v168 - v147);
					if (((10670 - 6394) >= (3133 + 781)) and (v174 <= (0.5 - 0))) then
						local v179 = 0 - 0;
						while true do
							if (((318 - 120) <= (13493 - 9128)) and (v179 == (1248 - (111 + 1137)))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (159 - (91 + 67));
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v167]:Name()] = true;
								v179 = 2 - 1;
							end
							if (((1194 + 3588) > (5199 - (423 + 100))) and (v179 == (1 + 0))) then
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
								break;
							end
						end
					elseif (((2536 + 2328) > (2968 - (326 + 445))) and (v168 > v147)) then
						v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (4 - 3);
					else
						v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (2 - 1);
						v10.APLVar.RtB_Buffs.Will_Lose[v109[v167]:Name()] = true;
						v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
					end
				end
				if (v110 or ((4411 - (530 + 181)) == (3388 - (614 + 267)))) then
					print("RtbRemains", v147);
					print(v109[v167]:Name(), v168);
				end
			end
			if (((4506 - (19 + 13)) >= (445 - 171)) and v110) then
				local v172 = 0 - 0;
				while true do
					if ((v172 == (5 - 3)) or ((492 + 1402) <= (2472 - 1066))) then
						print("longer: ", v10.APLVar.RtB_Buffs.Longer);
						print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
						break;
					end
					if (((3259 - 1687) >= (3343 - (1293 + 519))) and (v172 == (0 - 0))) then
						print("have: ", v10.APLVar.RtB_Buffs.Total);
						print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
						v172 = 2 - 1;
					end
					if (((1 - 0) == v172) or ((20210 - 15523) < (10699 - 6157))) then
						print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
						print("normal: ", v10.APLVar.RtB_Buffs.Normal);
						v172 = 2 + 0;
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
			if (((7646 - 4355) > (386 + 1281)) and (v133 == (0 + 0))) then
				if (not v10.APLVar.RtB_Reroll or ((546 + 327) == (3130 - (709 + 387)))) then
					if ((v64 == "1+ Buff") or ((4674 - (673 + 1185)) < (31 - 20))) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 - 0)) and true) or false;
					elseif (((6085 - 2386) < (3366 + 1340)) and (v64 == "Broadside")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif (((1978 + 668) >= (1181 - 305)) and (v64 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((151 + 463) <= (6348 - 3164)) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif (((6135 - 3009) == (5006 - (446 + 1434))) and (v64 == "Skull and Crossbones")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif ((v64 == "Ruthless Precision") or ((3470 - (1040 + 243)) >= (14785 - 9831))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((5724 - (559 + 1288)) == (5506 - (609 + 1322)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v111();
						if (((1161 - (13 + 441)) > (2361 - 1729)) and (v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (5 - 3))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v84.Crackshot:IsAvailable() and not v15:HasTier(154 - 123, 1 + 3) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (3 - 2))) or ((194 + 352) >= (1177 + 1507))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((4347 - 2882) <= (2354 + 1947)) and v84.Crackshot:IsAvailable() and v15:HasTier(56 - 25, 3 + 1) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff))))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((1225 + 479) > (1197 + 228)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < (2 + 0 + v112(v84.GrandMelee))) and (v93 < (435 - (153 + 280)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v10.APLVar.RtB_Reroll and (v10.APLVar.RtB_Buffs.Longer == (0 - 0))) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v111() < (4 + 2)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (36 + 3)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)) or ((498 + 189) == (6446 - 2212))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (v16:FilteredTimeToDie("<", 8 + 4) or v9.BossFilteredFightRemains("<", 679 - (89 + 578)) or ((2379 + 951) < (2970 - 1541))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (1050 - (572 + 477))) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= (1 + 1 + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (31 + 19));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (1 + 1)) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		if (((1233 - (84 + 2)) >= (552 - 217)) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (5 + 1))) and v115()) then
			if (((4277 - (497 + 345)) > (54 + 2043)) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) or ((638 + 3132) >= (5374 - (605 + 728)))) then
			if (v9.Cast(v84.Vanish, v67) or ((2705 + 1086) <= (3581 - 1970))) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (1 + 5)) or not v67) and not v15:StealthUp(true, false)) or ((16925 - 12347) <= (1811 + 197))) then
			if (((3116 - 1991) <= (1568 + 508)) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((1232 - (457 + 32)) >= (1867 + 2532))) then
			if (((2557 - (832 + 570)) < (1577 + 96)) and v11(v84.ShadowDance, v9.Cast(v84.ShadowDance, v53))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (8 + 22)) or ((v84.KeepItRolling:CooldownRemains() >= (424 - 304)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((1120 + 1204) <= (1374 - (588 + 208)))) then
			if (((10152 - 6385) == (5567 - (884 + 916))) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if (((8560 - 4471) == (2371 + 1718)) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady()) then
			if (((5111 - (232 + 421)) >= (3563 - (1569 + 320))) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
				if (((239 + 733) <= (270 + 1148)) and v9.Cast(v84.Shadowmeld, v30)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v134 = v82.HandleTopTrinket(v87, v28, 134 - 94, nil);
		if (v134 or ((5543 - (316 + 289)) < (12465 - 7703))) then
			return v134;
		end
		local v134 = v82.HandleBottomTrinket(v87, v28, 2 + 38, nil);
		if (v134 or ((3957 - (666 + 787)) > (4689 - (360 + 65)))) then
			return v134;
		end
	end
	local function v121()
		local v135 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (((2013 + 140) == (2407 - (79 + 175))) and v135) then
			return "DPS Pot";
		end
		if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 - 0))))) or ((396 + 111) >= (7941 - 5350))) then
			if (((8629 - 4148) == (5380 - (503 + 396))) and v11(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (v84.BladeFlurry:IsReady() or ((2509 - (92 + 89)) < (1343 - 650))) then
			if (((2220 + 2108) == (2562 + 1766)) and (v93 >= ((7 - 5) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) then
				if (((218 + 1370) >= (3036 - 1704)) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.BladeFlurry:IsReady() or ((3642 + 532) > (2029 + 2219))) then
			if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (8 - 5)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1 + 4)))) or ((6993 - 2407) <= (1326 - (485 + 759)))) then
				if (((8938 - 5075) == (5052 - (442 + 747))) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.RolltheBones:IsReady() or ((1417 - (832 + 303)) <= (988 - (88 + 858)))) then
			if (((1405 + 3204) >= (634 + 132)) and ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (792 - (766 + 23))) and v15:HasTier(153 - 122, 5 - 1)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (18 - 11)) and ((v84.ShadowDance:CooldownRemains() <= (10 - 7)) or (v84.Vanish:CooldownRemains() <= (1076 - (1036 + 37)))) and not v15:StealthUp(true, true)))) then
				if (v11(v84.RolltheBones) or ((817 + 335) == (4844 - 2356))) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v136 = v120();
		if (((2692 + 730) > (4830 - (641 + 839))) and v136) then
			return v136;
		end
		if (((1790 - (910 + 3)) > (958 - 582)) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((1687 - (1466 + 218)) + v21(v15:HasTier(15 + 16, 1152 - (556 + 592))))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (3 + 3)))) then
			if (v9.Cast(v84.KeepItRolling) or ((3926 - (329 + 479)) <= (2705 - (174 + 680)))) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (23 - 16))) or ((341 - 176) >= (2494 + 998))) then
			if (((4688 - (396 + 343)) < (430 + 4426)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((5753 - (29 + 1448)) < (4405 - (135 + 1254)))) then
			if (((17668 - 12978) > (19260 - 15135)) and ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 8 + 3) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1538 - (389 + 1138)))) then
				if (v9.Cast(v84.Sepsis) or ((624 - (102 + 472)) >= (846 + 50))) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v84.BladeRush:IsReady() and (v102 > (3 + 1)) and not v15:StealthUp(true, true)) or ((1599 + 115) >= (4503 - (320 + 1225)))) then
			if (v9.Cast(v84.BladeRush) or ((2653 - 1162) < (395 + 249))) then
				return "Cast Blade Rush";
			end
		end
		if (((2168 - (157 + 1307)) < (2846 - (821 + 1038))) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
			v136 = v119();
			if (((9276 - 5558) > (209 + 1697)) and v136) then
				return v136;
			end
		end
		if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (177 - 77)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (3 + 3)))) or ((2374 - 1416) > (4661 - (834 + 192)))) then
			if (((223 + 3278) <= (1153 + 3339)) and v9.Cast(v84.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if ((v84.BladeRush:IsCastable() and (v102 > (1 + 3)) and not v15:StealthUp(true, true)) or ((5331 - 1889) < (2852 - (300 + 4)))) then
			if (((768 + 2107) >= (3832 - 2368)) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((5159 - (112 + 250)) >= (1951 + 2942))) then
			if (v9.Cast(v84.BloodFury, v30) or ((1380 - 829) > (1185 + 883))) then
				return "Cast Blood Fury";
			end
		end
		if (((1094 + 1020) > (707 + 237)) and v84.Berserking:IsCastable()) then
			if (v9.Cast(v84.Berserking, v30) or ((1122 + 1140) >= (2300 + 796))) then
				return "Cast Berserking";
			end
		end
		if (v84.Fireblood:IsCastable() or ((3669 - (1001 + 413)) >= (7887 - 4350))) then
			if (v9.Cast(v84.Fireblood, v30) or ((4719 - (244 + 638)) < (1999 - (627 + 66)))) then
				return "Cast Fireblood";
			end
		end
		if (((8789 - 5839) == (3552 - (512 + 90))) and v84.AncestralCall:IsCastable()) then
			if (v9.Cast(v84.AncestralCall, v30) or ((6629 - (1665 + 241)) < (4015 - (373 + 344)))) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		if (((513 + 623) >= (41 + 113)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (5 - 3)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
			if (v70 or ((458 - 187) > (5847 - (35 + 1064)))) then
				v9.CastSuggested(v84.BladeFlurry);
			elseif (((3449 + 1291) >= (6743 - 3591)) and v9.Cast(v84.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((11 + 2567) >= (4626 - (298 + 938)))) then
			if (((1300 - (233 + 1026)) <= (3327 - (636 + 1030))) and v9.Cast(v84.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if (((308 + 293) < (3478 + 82)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
			if (((70 + 165) < (47 + 640)) and v9.Cast(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if (((4770 - (55 + 166)) > (224 + 929)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
			if (v9.Press(v84.Dispatch) or ((471 + 4203) < (17842 - 13170))) then
				return "Cast Dispatch";
			end
		end
		if (((3965 - (36 + 261)) < (7976 - 3415)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1370 - (34 + 1334))) and (v15:BuffStack(v84.Opportunity) >= (3 + 3)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
			if (v9.Press(v84.PistolShot) or ((1738 - (1035 + 248)) == (3626 - (20 + 1)))) then
				return "Cast Pistol Shot";
			end
		end
		if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((1388 + 1275) == (3631 - (134 + 185)))) then
			if (((5410 - (549 + 584)) <= (5160 - (314 + 371))) and v9.Press(v84.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v123()
		if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (13 - 9)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(998 - (478 + 490), 3 + 1)) and v15:BuffDown(v84.GreenskinsWickers)) or ((2042 - (786 + 386)) == (3850 - 2661))) then
			if (((2932 - (1055 + 324)) <= (4473 - (1093 + 247))) and v9.Press(v84.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (40 + 5)) and (v84.ShadowDance:CooldownRemains() > (2 + 10))) or ((8881 - 6644) >= (11915 - 8404))) then
			if (v9.Press(v84.BetweentheEyes) or ((3767 - 2443) > (7588 - 4568))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v15:BuffRemains(v84.SliceandDice) < (((3 - 2) + v97) * (3.8 - 2)))) or ((2257 + 735) == (4810 - 2929))) then
			if (((3794 - (364 + 324)) > (4182 - 2656)) and v9.Press(v84.SliceandDice)) then
				return "Cast Slice and Dice";
			end
		end
		if (((7253 - 4230) < (1283 + 2587)) and v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
			if (((598 - 455) > (117 - 43)) and v9.Cast(v84.KillingSpree)) then
				return "Cast Killing Spree";
			end
		end
		if (((54 - 36) < (3380 - (1249 + 19))) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) then
			if (((991 + 106) <= (6336 - 4708)) and v9.Cast(v84.ColdBlood, v55)) then
				return "Cast Cold Blood";
			end
		end
		if (((5716 - (686 + 400)) == (3633 + 997)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
			if (((3769 - (73 + 156)) > (13 + 2670)) and v9.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v124()
		local v137 = 811 - (721 + 90);
		while true do
			if (((54 + 4740) >= (10633 - 7358)) and (v137 == (472 - (224 + 246)))) then
				if (((2403 - 919) == (2731 - 1247)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= (1 + 0 + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + 1 + 0)))) or (v97 <= v21(v84.Ruthlessness:IsAvailable())))) then
					if (((1052 + 380) < (7067 - 3512)) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if ((not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (3.5 - 2)) or (v98 <= ((514 - (203 + 310)) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) or ((3058 - (1238 + 755)) > (250 + 3328))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((6329 - (709 + 825)) < (2592 - 1185))) then
						return "Cast Pistol Shot";
					end
				end
				v137 = 3 - 0;
			end
			if (((2717 - (196 + 668)) < (19002 - 14189)) and (v137 == (0 - 0))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((3654 - (171 + 662)) < (2524 - (4 + 89)))) then
					if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((10073 - 7199) < (795 + 1386))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((11810 - 9121) <= (135 + 208))) then
					if (v9.Press(v84.Ambush) or ((3355 - (35 + 1451)) == (3462 - (28 + 1425)))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v137 = 1994 - (941 + 1052);
			end
			if ((v137 == (1 + 0)) or ((5060 - (822 + 692)) < (3314 - 992))) then
				if ((v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) or ((981 + 1101) == (5070 - (45 + 252)))) then
					if (((3210 + 34) > (364 + 691)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (14 - 8)) or (v15:BuffRemains(v84.Opportunity) < (435 - (114 + 319))))) or ((4755 - 1442) <= (2277 - 499))) then
					if (v9.Press(v84.PistolShot) or ((906 + 515) >= (3134 - 1030))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v137 = 3 - 1;
			end
			if (((3775 - (556 + 1407)) <= (4455 - (741 + 465))) and (v137 == (468 - (170 + 295)))) then
				if (((856 + 767) <= (1798 + 159)) and v84.SinisterStrike:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
					if (((10862 - 6450) == (3658 + 754)) and v9.Press(v84.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v138 = 0 + 0;
		while true do
			if (((991 + 759) >= (2072 - (957 + 273))) and ((3 + 5) == v138)) then
				if (((1751 + 2621) > (7049 - 5199)) and v82.TargetIsValid()) then
					v94 = v121();
					if (((611 - 379) < (2507 - 1686)) and v94) then
						return "CDs: " .. v94;
					end
					if (((2564 - 2046) < (2682 - (389 + 1391))) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
						v94 = v122();
						if (((1879 + 1115) > (90 + 768)) and v94) then
							return "Stealth: " .. v94;
						end
					end
					if (v114() or ((8548 - 4793) <= (1866 - (783 + 168)))) then
						v94 = v123();
						if (((13243 - 9297) > (3682 + 61)) and v94) then
							return "Finish: " .. v94;
						end
					end
					v94 = v124();
					if (v94 or ((1646 - (309 + 2)) >= (10152 - 6846))) then
						return "Build: " .. v94;
					end
					if (((6056 - (1090 + 122)) > (731 + 1522)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((50 - 35) + v100))) then
						if (((310 + 142) == (1570 - (628 + 490))) and v9.Cast(v84.ArcaneTorrent, v30)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((818 + 3739) < (5166 - 3079))) then
						if (((17704 - 13830) == (4648 - (431 + 343))) and v9.Cast(v84.ArcanePulse)) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(10 - 5)) or ((5606 - 3668) > (3899 + 1036))) then
						if (v9.Cast(v84.LightsJudgment, v30) or ((545 + 3710) < (5118 - (556 + 1139)))) then
							return "Cast Lights Judgment";
						end
					end
					if (((1469 - (6 + 9)) <= (457 + 2034)) and v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(3 + 2)) then
						if (v9.Cast(v84.BagofTricks, v30) or ((4326 - (28 + 141)) <= (1086 + 1717))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((5989 - 1136) >= (2113 + 869)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (1342 - (486 + 831))) and ((v98 >= (2 - 1)) or (v102 <= (3.2 - 2)))) then
						if (((782 + 3352) > (10614 - 7257)) and v9.Cast(v84.PistolShot)) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v84.SinisterStrike:IsCastable() or ((4680 - (668 + 595)) < (2281 + 253))) then
						if (v9.Cast(v84.SinisterStrike) or ((549 + 2173) <= (447 - 283))) then
							return "Cast Sinister Strike Filler";
						end
					end
				end
				break;
			end
			if ((v138 == (294 - (23 + 267))) or ((4352 - (1129 + 815)) < (2496 - (371 + 16)))) then
				if (v27 or ((1783 - (1326 + 424)) == (2755 - 1300))) then
					local v175 = 0 - 0;
					while true do
						if ((v175 == (119 - (88 + 30))) or ((1214 - (720 + 51)) >= (8931 - 4916))) then
							v93 = #v92;
							break;
						end
						if (((5158 - (421 + 1355)) > (273 - 107)) and (v175 == (0 + 0))) then
							v91 = v15:GetEnemiesInRange(1113 - (286 + 797));
							v92 = v15:GetEnemiesInRange(v95);
							v175 = 3 - 2;
						end
					end
				else
					v93 = 1 - 0;
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((719 - (397 + 42)) == (956 + 2103))) then
					return v94;
				end
				v138 = 805 - (24 + 776);
			end
			if (((2897 - 1016) > (2078 - (222 + 563))) and (v138 == (14 - 7))) then
				if (((1697 + 660) == (2547 - (23 + 167))) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (((1921 - (690 + 1108)) == (45 + 78)) and v94) then
						return "Stealth (OOC): " .. v94;
					end
				end
				if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(856 - (40 + 808)) and v26) or ((174 + 882) >= (12970 - 9578))) then
					if ((v82.TargetIsValid() and v16:IsInRange(10 + 0) and not (v15:IsChanneling() or v15:IsCasting())) or ((572 + 509) < (590 + 485))) then
						local v181 = 571 - (47 + 524);
						while true do
							if (((0 + 0) == v181) or ((2867 - 1818) >= (6626 - 2194))) then
								if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((10873 - 6105) <= (2572 - (1165 + 561)))) then
									if (v11(v84.BladeFlurry) or ((100 + 3258) <= (4397 - 2977))) then
										return "Blade Flurry (Opener)";
									end
								end
								if (not v15:StealthUp(true, false) or ((1427 + 2312) <= (3484 - (341 + 138)))) then
									local v191 = 0 + 0;
									while true do
										if ((v191 == (0 - 0)) or ((1985 - (89 + 237)) >= (6864 - 4730))) then
											v94 = v83.Stealth(v83.StealthSpell());
											if (v94 or ((6863 - 3603) < (3236 - (581 + 300)))) then
												return v94;
											end
											break;
										end
									end
								end
								v181 = 1221 - (855 + 365);
							end
							if ((v181 == (2 - 1)) or ((219 + 450) == (5458 - (1030 + 205)))) then
								if (v82.TargetIsValid() or ((1589 + 103) < (547 + 41))) then
									local v192 = 286 - (156 + 130);
									while true do
										if ((v192 == (2 - 1)) or ((8084 - 3287) < (7477 - 3826))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 + 0)))) or ((4246 - (10 + 59)) > (1372 + 3478))) then
												if (v9.Press(v84.SliceandDice) or ((1969 - 1569) > (2274 - (671 + 492)))) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (((2429 + 622) > (2220 - (369 + 846))) and v15:StealthUp(true, false)) then
												local v196 = 0 + 0;
												while true do
													if (((3152 + 541) <= (6327 - (1036 + 909))) and ((1 + 0) == v196)) then
														if ((v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) or ((5509 - 2227) > (4303 - (11 + 192)))) then
															if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((1810 + 1770) < (3019 - (135 + 40)))) then
																return "Cast Ghostly Strike KiR (Opener)";
															end
														end
														if (((215 - 126) < (2707 + 1783)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
															if (v11(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush)) or ((10977 - 5994) < (2710 - 902))) then
																return "Cast Ambush (Opener)";
															end
														elseif (((4005 - (50 + 126)) > (10494 - 6725)) and v84.SinisterStrike:IsCastable()) then
															if (((329 + 1156) <= (4317 - (1233 + 180))) and v11(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
																return "Cast Sinister Strike (Opener)";
															end
														end
														break;
													end
													if (((5238 - (522 + 447)) == (5690 - (107 + 1314))) and (v196 == (0 + 0))) then
														v94 = v122();
														if (((1179 - 792) <= (1182 + 1600)) and v94) then
															return "Stealth (Opener): " .. v94;
														end
														v196 = 1 - 0;
													end
												end
											elseif (v114() or ((7513 - 5614) <= (2827 - (716 + 1194)))) then
												v94 = v123();
												if (v94 or ((74 + 4238) <= (94 + 782))) then
													return "Finish (Opener): " .. v94;
												end
											end
											v192 = 505 - (74 + 429);
										end
										if (((4305 - 2073) <= (1287 + 1309)) and (v192 == (4 - 2))) then
											if (((1483 + 612) < (11363 - 7677)) and v84.SinisterStrike:IsCastable()) then
												if (v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((3943 - 2348) >= (4907 - (279 + 154)))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v192 == (778 - (454 + 324))) or ((3635 + 984) < (2899 - (12 + 5)))) then
											if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 + 0)) or v113())) or ((749 - 455) >= (1786 + 3045))) then
												if (((3122 - (277 + 816)) <= (13178 - 10094)) and v9.Cast(v84.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1185 - (1058 + 125)))) or ((382 + 1655) == (3395 - (815 + 160)))) then
												if (((19127 - 14669) > (9267 - 5363)) and v9.Cast(v84.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v192 = 1 + 0;
										end
									end
								end
								return;
							end
						end
					end
				end
				if (((1274 - 838) >= (2021 - (41 + 1857))) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					v97 = v25(v97, v83.FanTheHammerCP());
				end
				v138 = 1901 - (1222 + 671);
			end
			if (((1292 - 792) < (2609 - 793)) and (v138 == (1182 - (229 + 953)))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v138 = 1775 - (1111 + 663);
			end
			if (((5153 - (874 + 705)) == (501 + 3073)) and (v138 == (4 + 1))) then
				v83.Poisons();
				if (((459 - 238) < (11 + 379)) and v32 and (v15:HealthPercentage() <= v34)) then
					if ((v33 == "Refreshing Healing Potion") or ((2892 - (642 + 37)) <= (325 + 1096))) then
						if (((490 + 2568) < (12202 - 7342)) and v85.RefreshingHealingPotion:IsReady()) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((1750 - (233 + 221)) >= (10280 - 5834))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((1227 + 166) > (6030 - (718 + 823)))) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((2784 + 1640) < (832 - (266 + 539)))) then
							if (v9.Press(v86.RefreshingHealingPotion) or ((5653 - 3656) > (5040 - (636 + 589)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((8225 - 4760) > (3945 - 2032)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (((581 + 152) < (661 + 1158)) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				v138 = 1021 - (657 + 358);
			end
			if ((v138 == (7 - 4)) or ((10013 - 5618) == (5942 - (1151 + 36)))) then
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v138 = 4 + 0;
			end
			if ((v138 == (1 + 0)) or ((11327 - 7534) < (4201 - (1552 + 280)))) then
				v28 = EpicSettings.Toggles['cds'];
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v138 = 836 - (64 + 770);
			end
			if ((v138 == (2 + 0)) or ((9270 - 5186) == (48 + 217))) then
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(1293 - (157 + 1086))) or (0 - 0);
				v99 = v108();
				v138 = 13 - 10;
			end
			if (((6684 - 2326) == (5947 - 1589)) and ((825 - (599 + 220)) == v138)) then
				if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) or ((6248 - 3110) < (2924 - (1813 + 118)))) then
					if (((2435 + 895) > (3540 - (841 + 376))) and v9.Cast(v84.Evasion)) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((5080 - 1454) == (927 + 3062))) then
					local v176 = v82.Interrupt(v84.Kick, 21 - 13, true);
					if (v176 or ((1775 - (464 + 395)) == (6854 - 4183))) then
						return v176;
					end
					v176 = v82.Interrupt(v84.Kick, 4 + 4, true, v12, v86.KickMouseover);
					if (((1109 - (467 + 370)) == (561 - 289)) and v176) then
						return v176;
					end
					v176 = v82.Interrupt(v84.Blind, 12 + 3, v79);
					if (((14565 - 10316) <= (755 + 4084)) and v176) then
						return v176;
					end
					v176 = v82.Interrupt(v84.Blind, 34 - 19, v79, v12, v86.BlindMouseover);
					if (((3297 - (150 + 370)) < (4482 - (74 + 1208))) and v176) then
						return v176;
					end
					v176 = v82.InterruptWithStun(v84.CheapShot, 19 - 11, v15:StealthUp(false, false));
					if (((450 - 355) < (1393 + 564)) and v176) then
						return v176;
					end
					v176 = v82.InterruptWithStun(v84.KidneyShot, 398 - (14 + 376), v15:ComboPoints() > (0 - 0));
					if (((535 + 291) < (1509 + 208)) and v176) then
						return v176;
					end
				end
				if (((1360 + 66) >= (3237 - 2132)) and v29) then
					local v177 = 0 + 0;
					while true do
						if (((2832 - (23 + 55)) <= (8007 - 4628)) and (v177 == (0 + 0))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 27 + 3, true);
							if (v94 or ((6088 - 2161) == (445 + 968))) then
								return v94;
							end
							break;
						end
					end
				end
				v138 = 908 - (652 + 249);
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(695 - 435, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

