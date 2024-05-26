local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((931 + 118) < (1297 + 620)) and not v5) then
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
		local v127 = 0 - 0;
		while true do
			if (((3992 - (1074 + 82)) > (1082 - 588)) and (v127 == (1784 - (214 + 1570)))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1456 - (990 + 465);
			end
			if ((v127 == (2 + 1)) or ((1187 + 1539) == (3763 + 106))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 15 - 11;
			end
			if ((v127 == (1733 - (1668 + 58))) or ((5002 - (512 + 114)) <= (3861 - 2380))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 16 - 8;
			end
			if ((v127 == (13 - 9)) or ((1578 + 1814) >= (888 + 3853))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 5 + 0;
			end
			if (((11215 - 7890) >= (4148 - (109 + 1885))) and (v127 == (1475 - (1269 + 200)))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 13 - 6;
			end
			if ((v127 == (823 - (98 + 717))) or ((2121 - (802 + 24)) >= (5575 - 2342))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 10 - 1;
			end
			if (((647 + 3730) > (1262 + 380)) and (v127 == (1 + 0))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v127 = 6 - 4;
			end
			if (((1690 + 3033) > (552 + 804)) and (v127 == (5 + 0))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 1439 - (797 + 636);
			end
			if ((v127 == (43 - 34)) or ((5755 - (1427 + 192)) <= (1190 + 2243))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
			if (((3816 + 429) <= (2099 + 2532)) and (v127 == (328 - (192 + 134)))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1276 - (316 + 960));
				v127 = 2 + 1;
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
	local v89 = (v88[11 + 2] and v19(v88[13 + 0])) or v19(0 - 0);
	local v90 = (v88[565 - (83 + 468)] and v19(v88[1820 - (1202 + 604)])) or v19(0 - 0);
	v9:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if (((11839 - 7563) >= (4239 - (45 + 280))) and (v128 == (0 + 0))) then
				v88 = v15:GetEquipment();
				v89 = (v88[12 + 1] and v19(v88[5 + 8])) or v19(0 + 0);
				v128 = 1 + 0;
			end
			if (((366 - 168) <= (6276 - (340 + 1571))) and (v128 == (1 + 0))) then
				v90 = (v88[1786 - (1733 + 39)] and v19(v88[38 - 24])) or v19(1034 - (125 + 909));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 1954 - (1096 + 852);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (726 - (228 + 498));
	end}};
	local v105, v106 = 0 + 0, 0 + 0;
	local function v107(v129)
		local v130 = 663 - (174 + 489);
		local v131;
		while true do
			if (((12458 - 7676) > (6581 - (830 + 1075))) and ((525 - (303 + 221)) == v130)) then
				return v105;
			end
			if (((6133 - (231 + 1038)) > (1831 + 366)) and (v130 == (1162 - (171 + 991)))) then
				v131 = v15:EnergyTimeToMaxPredicted(nil, v129);
				if ((v131 < v105) or ((v131 - v105) > (0.5 - 0)) or ((9935 - 6235) == (6255 - 3748))) then
					v105 = v131;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v108()
		local v132 = v15:EnergyPredicted();
		if (((15682 - 11208) >= (790 - 516)) and ((v132 > v106) or ((v132 - v106) > (13 - 4)))) then
			v106 = v132;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (not v10.APLVar.RtB_Buffs or ((14 + 1880) <= (3892 - 2486))) then
			v10.APLVar.RtB_Buffs = {};
			v10.APLVar.RtB_Buffs.Will_Lose = {};
			v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
			v10.APLVar.RtB_Buffs.Total = 771 - (326 + 445);
			v10.APLVar.RtB_Buffs.Normal = 0 - 0;
			v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
			v10.APLVar.RtB_Buffs.Longer = 0 - 0;
			v10.APLVar.RtB_Buffs.MaxRemains = 711 - (530 + 181);
			local v147 = v83.RtBRemains();
			for v173 = 882 - (614 + 267), #v109 do
				local v174 = 32 - (19 + 13);
				local v175;
				while true do
					if (((2558 - 986) >= (3567 - 2036)) and (v174 == (0 - 0))) then
						v175 = v15:BuffRemains(v109[v173]);
						if ((v175 > (0 + 0)) or ((8242 - 3555) < (9418 - 4876))) then
							v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + (1813 - (1293 + 519));
							if (((6714 - 3423) > (4352 - 2685)) and (v175 > v10.APLVar.RtB_Buffs.MaxRemains)) then
								v10.APLVar.RtB_Buffs.MaxRemains = v175;
							end
							local v187 = math.abs(v175 - v147);
							if ((v187 <= (0.5 - 0)) or ((3764 - 2891) == (4791 - 2757))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v173]:Name()] = true;
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
							elseif ((v175 > v147) or ((6542 - 3726) < (3 + 8))) then
								v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
							else
								local v198 = 0 + 0;
								while true do
									if (((4795 - (709 + 387)) < (6564 - (673 + 1185))) and (v198 == (2 - 1))) then
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (3 - 2);
										break;
									end
									if (((4353 - 1707) >= (627 + 249)) and ((0 + 0) == v198)) then
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1 - 0);
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v173]:Name()] = true;
										v198 = 1 + 0;
									end
								end
							end
						end
						v174 = 1 - 0;
					end
					if (((1205 - 591) <= (5064 - (446 + 1434))) and (v174 == (1284 - (1040 + 243)))) then
						if (((9329 - 6203) == (4973 - (559 + 1288))) and v110) then
							local v188 = 1931 - (609 + 1322);
							while true do
								if ((v188 == (454 - (13 + 441))) or ((8172 - 5985) >= (12976 - 8022))) then
									print("RtbRemains", v147);
									print(v109[v173]:Name(), v175);
									break;
								end
							end
						end
						break;
					end
				end
			end
			if (v110 or ((19309 - 15432) == (134 + 3441))) then
				print("have: ", v10.APLVar.RtB_Buffs.Total);
				print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
				print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
				print("normal: ", v10.APLVar.RtB_Buffs.Normal);
				print("longer: ", v10.APLVar.RtB_Buffs.Longer);
				print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v133)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v113()
		if (((2567 - 1860) > (225 + 407)) and not v10.APLVar.RtB_Reroll) then
			if ((v64 == "1+ Buff") or ((240 + 306) >= (7964 - 5280))) then
				v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
			elseif (((2694 - 1229) <= (2844 + 1457)) and (v64 == "Broadside")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif (((948 + 756) > (1024 + 401)) and (v64 == "Buried Treasure")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif ((v64 == "Grand Melee") or ((577 + 110) == (4143 + 91))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif ((v64 == "Skull and Crossbones") or ((3763 - (153 + 280)) < (4126 - 2697))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif (((1030 + 117) >= (133 + 202)) and (v64 == "Ruthless Precision")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif (((1798 + 1637) > (1903 + 194)) and (v64 == "True Bearing")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				local v206 = 0 + 0;
				while true do
					if ((v206 == (2 - 0)) or ((2331 + 1439) >= (4708 - (89 + 578)))) then
						if ((v84.Crackshot:IsAvailable() and v15:HasTier(23 + 8, 8 - 4)) or ((4840 - (572 + 477)) <= (218 + 1393))) then
							v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff)));
						end
						if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < (1 + 1 + v21(v112(v84.GrandMelee)))) and (v93 < (88 - (84 + 2)))) or ((7544 - 2966) <= (1447 + 561))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v206 = 845 - (497 + 345);
					end
					if (((29 + 1096) <= (351 + 1725)) and (v206 == (1333 - (605 + 728)))) then
						v10.APLVar.RtB_Reroll = false;
						v111();
						v206 = 1 + 0;
					end
					if ((v206 == (1 - 0)) or ((35 + 708) >= (16264 - 11865))) then
						v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (2 + 0))));
						if (((3199 - 2044) < (1264 + 409)) and v84.Crackshot:IsAvailable() and not v15:HasTier(520 - (457 + 32), 2 + 2)) then
							v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1403 - (832 + 570))));
						end
						v206 = 2 + 0;
					end
					if ((v206 == (1 + 2)) or ((8223 - 5899) <= (279 + 299))) then
						v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (796 - (588 + 208))) or ((v10.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1801 - (884 + 916))) and (v111() < (12 - 6)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (23 + 16)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
						if (((4420 - (232 + 421)) == (5656 - (1569 + 320))) and (v16:FilteredTimeToDie("<", 3 + 9) or v9.BossFilteredFightRemains("<", 3 + 9))) then
							v10.APLVar.RtB_Reroll = false;
						end
						break;
					end
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (3 - 2)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((607 - (316 + 289)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (130 - 80));
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
		if (((5542 - (666 + 787)) == (4514 - (360 + 65))) and v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (6 + 0))) and v115()) then
			if (((4712 - (79 + 175)) >= (2638 - 964)) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (HO)";
			end
		end
		if (((759 + 213) <= (4346 - 2928)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
			if (v9.Cast(v84.Vanish, v67) or ((9509 - 4571) < (5661 - (503 + 396)))) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (187 - (92 + 89))) or not v67) and not v15:StealthUp(true, false)) or ((4857 - 2353) > (2187 + 2077))) then
			if (((1275 + 878) == (8431 - 6278)) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((70 + 437) >= (5907 - 3316))) then
			if (((3910 + 571) == (2141 + 2340)) and v11(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (91 - 61)) or ((v84.KeepItRolling:CooldownRemains() >= (15 + 105)) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((3550 - 1222) < (1937 - (485 + 759)))) then
			if (((10014 - 5686) == (5517 - (442 + 747))) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if (((2723 - (832 + 303)) >= (2278 - (88 + 858))) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) then
			if ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())) or ((1273 + 2901) > (3516 + 732))) then
				if (v9.Cast(v84.Shadowmeld, v30) or ((189 + 4397) <= (871 - (766 + 23)))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v134 = v82.HandleTopTrinket(v87, v28, 197 - 157, nil);
		if (((5282 - 1419) == (10177 - 6314)) and v134) then
			return v134;
		end
		local v134 = v82.HandleBottomTrinket(v87, v28, 135 - 95, nil);
		if (v134 or ((1355 - (1036 + 37)) <= (30 + 12))) then
			return v134;
		end
	end
	local function v121()
		local v135 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (((8975 - 4366) >= (603 + 163)) and v135) then
			return "DPS Pot";
		end
		if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1482 - (641 + 839)))))) or ((2065 - (910 + 3)) == (6342 - 3854))) then
			if (((5106 - (1466 + 218)) > (1540 + 1810)) and v11(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((2025 - (556 + 592)) > (134 + 242)) and v84.BladeFlurry:IsReady()) then
			if (((v93 >= ((810 - (329 + 479)) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((3972 - (174 + 680)) <= (6360 - 4509))) then
				if (v11(v84.BladeFlurry) or ((341 - 176) >= (2494 + 998))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((4688 - (396 + 343)) < (430 + 4426)) and v84.BladeFlurry:IsReady()) then
			if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1480 - (29 + 1448))) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1394 - (135 + 1254))))) or ((16108 - 11832) < (14082 - 11066))) then
				if (((3126 + 1564) > (5652 - (389 + 1138))) and v11(v84.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.RolltheBones:IsReady() or ((624 - (102 + 472)) >= (846 + 50))) then
			if (v113() or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (3 + 0)) and v15:HasTier(1576 - (320 + 1225), 6 - 2)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (5 + 2)) and ((v84.ShadowDance:CooldownRemains() <= (1467 - (157 + 1307))) or (v84.Vanish:CooldownRemains() <= (1862 - (821 + 1038))))) or ((4276 - 2562) >= (324 + 2634))) then
				if (v11(v84.RolltheBones) or ((2648 - 1157) < (240 + 404))) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v136 = v120();
		if (((1744 - 1040) < (2013 - (834 + 192))) and v136) then
			return v136;
		end
		if (((237 + 3481) > (490 + 1416)) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= (1 + 2 + v21(v15:HasTier(47 - 16, 308 - (300 + 4))))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (2 + 4)))) then
			if (v9.Cast(v84.KeepItRolling) or ((2507 - 1549) > (3997 - (112 + 250)))) then
				return "Cast Keep it Rolling";
			end
		end
		if (((1396 + 2105) <= (11253 - 6761)) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (5 + 2))) then
			if (v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((1781 + 1661) < (1906 + 642))) then
				return "Cast Ghostly Strike";
			end
		end
		if (((1426 + 1449) >= (1088 + 376)) and v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) then
			if ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 1425 - (1001 + 413)) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 24 - 13) or ((5679 - (244 + 638)) >= (5586 - (627 + 66)))) then
				if (v9.Cast(v84.Sepsis) or ((1641 - 1090) > (2670 - (512 + 90)))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((4020 - (1665 + 241)) > (1661 - (373 + 344))) and v84.BladeRush:IsReady() and (v102 > (2 + 2)) and not v15:StealthUp(true, true)) then
			if (v9.Cast(v84.BladeRush) or ((599 + 1663) >= (8166 - 5070))) then
				return "Cast Blade Rush";
			end
		end
		if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((3815 - 1560) >= (4636 - (35 + 1064)))) then
			local v148 = 0 + 0;
			while true do
				if ((v148 == (0 - 0)) or ((16 + 3821) < (2542 - (298 + 938)))) then
					v136 = v119();
					if (((4209 - (233 + 1026)) == (4616 - (636 + 1030))) and v136) then
						return v136;
					end
					break;
				end
			end
		end
		if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (52 + 48)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (6 + 0)))) or ((1404 + 3319) < (223 + 3075))) then
			if (((1357 - (55 + 166)) >= (30 + 124)) and v9.Cast(v84.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if ((v84.BladeRush:IsCastable() and (v102 > (1 + 3)) and not v15:StealthUp(true, true)) or ((1034 - 763) > (5045 - (36 + 261)))) then
			if (((8289 - 3549) >= (4520 - (34 + 1334))) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((992 + 1586) >= (2634 + 756))) then
			if (((1324 - (1035 + 248)) <= (1682 - (20 + 1))) and v9.Cast(v84.BloodFury, nil, v30)) then
				return "Cast Blood Fury";
			end
		end
		if (((314 + 287) < (3879 - (134 + 185))) and v84.Berserking:IsCastable()) then
			if (((1368 - (549 + 584)) < (1372 - (314 + 371))) and v9.Cast(v84.Berserking, nil, v30)) then
				return "Cast Berserking";
			end
		end
		if (((15616 - 11067) > (2121 - (478 + 490))) and v84.Fireblood:IsCastable()) then
			if (v9.Cast(v84.Fireblood, nil, v30) or ((2476 + 2198) < (5844 - (786 + 386)))) then
				return "Cast Fireblood";
			end
		end
		if (((11880 - 8212) < (5940 - (1055 + 324))) and v84.AncestralCall:IsCastable()) then
			if (v9.Cast(v84.AncestralCall, nil, v30) or ((1795 - (1093 + 247)) == (3204 + 401))) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (0 - 0)) or ((9037 - 6374) == (9424 - 6112))) then
				if (((10747 - 6470) <= (1592 + 2883)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (7 - 5)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
					if (v70 or ((2998 - 2128) == (897 + 292))) then
						v9.Cast(v84.BladeFlurry);
					elseif (((3971 - 2418) <= (3821 - (364 + 324))) and v9.Cast(v84.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((6132 - 3895) >= (8424 - 4913))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((439 + 885) > (12636 - 9616))) then
						return "Cast Cold Blood";
					end
				end
				v137 = 1 - 0;
			end
			if ((v137 == (5 - 3)) or ((4260 - (1249 + 19)) == (1698 + 183))) then
				if (((12090 - 8984) > (2612 - (686 + 400))) and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (2 + 0)) and (v15:BuffStack(v84.Opportunity) >= (235 - (73 + 156))) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 + 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
					if (((3834 - (721 + 90)) < (44 + 3826)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((464 - 321) > (544 - (224 + 246))) and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (((28 - 10) < (3888 - 1776)) and v9.Cast(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v137 = 1 + 2;
			end
			if (((27 + 1070) <= (1196 + 432)) and (v137 == (1 - 0))) then
				if (((15407 - 10777) == (5143 - (203 + 310))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
					if (((5533 - (1238 + 755)) > (188 + 2495)) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((6328 - (709 + 825)) >= (6034 - 2759)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (((2161 - 677) == (2348 - (196 + 668))) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v137 = 7 - 5;
			end
			if (((2966 - 1534) < (4388 - (171 + 662))) and (v137 == (96 - (4 + 89)))) then
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((3732 - 2667) > (1303 + 2275))) then
					if (v9.Press(v84.Ambush) or ((21060 - 16265) < (552 + 855))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((3339 - (35 + 1451)) < (6266 - (28 + 1425))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (1997 - (941 + 1052))) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(29 + 1, 1518 - (822 + 692))) and v15:BuffDown(v84.GreenskinsWickers)) then
			if (v9.Press(v84.BetweentheEyes) or ((4027 - 1206) < (1146 + 1285))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (342 - (45 + 252))) and (v84.ShadowDance:CooldownRemains() > (12 + 0))) or ((990 + 1884) < (5307 - 3126))) then
			if (v9.Press(v84.BetweentheEyes) or ((3122 - (114 + 319)) <= (491 - 148))) then
				return "Cast Between the Eyes";
			end
		end
		if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 - 0))) and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1.8 - 0)))) or ((3915 - 2046) == (3972 - (556 + 1407)))) then
			if (v9.Press(v84.SliceandDice) or ((4752 - (741 + 465)) < (2787 - (170 + 295)))) then
				return "Cast Slice and Dice";
			end
		end
		if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((1097 + 985) == (4385 + 388))) then
			if (((7986 - 4742) > (875 + 180)) and v9.Cast(v84.KillingSpree)) then
				return "Cast Killing Spree";
			end
		end
		if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((2125 + 1188) <= (1007 + 771))) then
			if (v9.Cast(v84.ColdBlood, v55) or ((2651 - (957 + 273)) >= (563 + 1541))) then
				return "Cast Cold Blood";
			end
		end
		if (((726 + 1086) <= (12380 - 9131)) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
			if (((4276 - 2653) <= (5977 - 4020)) and v9.Press(v84.Dispatch)) then
				return "Cast Dispatch";
			end
		end
	end
	local function v124()
		if (((21846 - 17434) == (6192 - (389 + 1391))) and v28 and v84.EchoingReprimand:IsReady()) then
			if (((1098 + 652) >= (88 + 754)) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((9953 - 5581) > (2801 - (783 + 168))) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
			if (((778 - 546) < (808 + 13)) and v9.Press(v84.Ambush)) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((829 - (309 + 2)) < (2769 - 1867)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
			if (((4206 - (1090 + 122)) > (279 + 579)) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (19 - 13)) or (v15:BuffRemains(v84.Opportunity) < (2 + 0)))) or ((4873 - (628 + 490)) <= (165 + 750))) then
			if (((9769 - 5823) > (17105 - 13362)) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((775 - (431 + 343)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (1 - 0))))) or (v97 <= (2 - 1)))) or ((1055 + 280) >= (423 + 2883))) then
			if (((6539 - (556 + 1139)) > (2268 - (6 + 9))) and v9.Press(v84.PistolShot)) then
				return "Cast Pistol Shot (Low CP Opportunity)";
			end
		end
		if (((83 + 369) == (232 + 220)) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (170.5 - (28 + 141))) or (v98 <= (1 + 0 + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
			if (v9.Cast(v84.PistolShot) or ((5624 - 1067) < (1479 + 608))) then
				return "Cast Pistol Shot";
			end
		end
		if (((5191 - (486 + 831)) == (10081 - 6207)) and v84.SinisterStrike:IsCastable()) then
			if (v9.Press(v84.SinisterStrike) or ((6822 - 4884) > (933 + 4002))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1265 - (668 + 595))) or ((3829 + 426) < (691 + 2732))) then
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(136 - 86)) or (290 - (23 + 267));
				v99 = v108();
				v138 = 1947 - (1129 + 815);
			end
			if (((1841 - (371 + 16)) <= (4241 - (1326 + 424))) and (v138 == (9 - 4))) then
				v83.Poisons();
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((15190 - 11033) <= (2921 - (88 + 30)))) then
					local v180 = 771 - (720 + 51);
					while true do
						if (((10795 - 5942) >= (4758 - (421 + 1355))) and (v180 == (0 - 0))) then
							if (((2031 + 2103) > (4440 - (286 + 797))) and (v33 == "Refreshing Healing Potion")) then
								if (v85.RefreshingHealingPotion:IsReady() or ((12491 - 9074) < (4197 - 1663))) then
									if (v9.Press(v86.RefreshingHealingPotion) or ((3161 - (397 + 42)) <= (52 + 112))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v33 == "Dreamwalker's Healing Potion") or ((3208 - (24 + 776)) < (3248 - 1139))) then
								if (v85.DreamwalkersHealingPotion:IsReady() or ((818 - (222 + 563)) == (3205 - 1750))) then
									if (v9.Press(v86.RefreshingHealingPotion) or ((319 + 124) >= (4205 - (23 + 167)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				if (((5180 - (690 + 1108)) > (60 + 106)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (v9.Cast(v84.Feint) or ((231 + 49) == (3907 - (40 + 808)))) then
						return "Cast Feint (Defensives)";
					end
				end
				v138 = 1 + 5;
			end
			if (((7192 - 5311) > (1236 + 57)) and ((4 + 3) == v138)) then
				if (((1293 + 1064) == (2928 - (47 + 524))) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					v94 = v83.Stealth(v84.Stealth2, nil);
					if (((80 + 43) == (336 - 213)) and v94) then
						return "Stealth (OOC): " .. v94;
					end
				end
				if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(17 - 9) and v26) or ((2782 - (1165 + 561)) >= (101 + 3291))) then
					if ((v82.TargetIsValid() and v16:IsInRange(30 - 20) and not (v15:IsChanneling() or v15:IsCasting())) or ((413 + 668) < (1554 - (341 + 138)))) then
						if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((284 + 765) >= (9146 - 4714))) then
							if (v11(v84.BladeFlurry) or ((5094 - (89 + 237)) <= (2721 - 1875))) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v15:StealthUp(true, false) or ((7069 - 3711) <= (2301 - (581 + 300)))) then
							v94 = v83.Stealth(v84.Stealth);
							if (v94 or ((4959 - (855 + 365)) <= (7137 - 4132))) then
								return v94;
							end
						end
						if (v82.TargetIsValid() or ((542 + 1117) >= (3369 - (1030 + 205)))) then
							if ((v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (2 + 0))) or ((3033 + 227) < (2641 - (156 + 130)))) then
								if (v9.Cast(v84.AdrenalineRush) or ((1519 - 850) == (7117 - 2894))) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (0 - 0)) or v113())) or ((446 + 1246) < (343 + 245))) then
								if (v9.Cast(v84.RolltheBones) or ((4866 - (10 + 59)) < (1033 + 2618))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((4 - 3) + v97) * (1164.8 - (671 + 492))))) or ((3326 + 851) > (6065 - (369 + 846)))) then
								if (v9.Press(v84.SliceandDice) or ((106 + 294) > (949 + 162))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((4996 - (1036 + 909)) > (800 + 205)) and (v15:StealthUp(true, false) or v84.Subterfuge:BuffUp())) then
								v94 = v122();
								if (((6200 - 2507) <= (4585 - (11 + 192))) and v94) then
									return "Stealth (Opener): " .. v94;
								end
								if ((v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) or ((1659 + 1623) > (4275 - (135 + 40)))) then
									if (v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike)) or ((8673 - 5093) < (1715 + 1129))) then
										return "Cast Ghostly Strike KiR (Opener)";
									end
								end
								if (((195 - 106) < (6730 - 2240)) and v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) then
									if (v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush)) or ((5159 - (50 + 126)) < (5034 - 3226))) then
										return "Cast Ambush (Opener)";
									end
								elseif (((848 + 2981) > (5182 - (1233 + 180))) and v84.SinisterStrike:IsCastable()) then
									if (((2454 - (522 + 447)) <= (4325 - (107 + 1314))) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
										return "Cast Sinister Strike (Opener)";
									end
								end
							elseif (((1981 + 2288) == (13007 - 8738)) and v114()) then
								local v200 = 0 + 0;
								while true do
									if (((768 - 381) <= (11007 - 8225)) and (v200 == (1910 - (716 + 1194)))) then
										v94 = v123();
										if (v94 or ((33 + 1866) <= (99 + 818))) then
											return "Finish (Opener): " .. v94;
										end
										break;
									end
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((4815 - (74 + 429)) <= (1689 - 813))) then
								if (((1107 + 1125) <= (5942 - 3346)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
						end
						return;
					end
				end
				if (((1483 + 612) < (11363 - 7677)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					local v181 = 0 - 0;
					while true do
						if (((433 - (279 + 154)) == v181) or ((2373 - (454 + 324)) >= (3520 + 954))) then
							v97 = v25(v97, v83.FanTheHammerCP());
							v96 = v83.EffectiveComboPoints(v97);
							v181 = 18 - (12 + 5);
						end
						if (((1 + 0) == v181) or ((11769 - 7150) < (1065 + 1817))) then
							v98 = v15:ComboPointsDeficit();
							break;
						end
					end
				end
				v138 = 1101 - (277 + 816);
			end
			if ((v138 == (25 - 19)) or ((1477 - (1058 + 125)) >= (906 + 3925))) then
				if (((3004 - (815 + 160)) <= (13232 - 10148)) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (v9.Cast(v84.Evasion) or ((4835 - 2798) == (578 + 1842))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((13031 - 8573) > (5802 - (41 + 1857))) and not v15:IsCasting() and not v15:IsChanneling()) then
					local v182 = 1893 - (1222 + 671);
					local v183;
					while true do
						if (((1126 - 690) >= (175 - 52)) and (v182 == (1183 - (229 + 953)))) then
							if (((2274 - (1111 + 663)) < (3395 - (874 + 705))) and v183) then
								return v183;
							end
							v183 = v82.Interrupt(v84.Blind, 3 + 12, v79);
							if (((2439 + 1135) == (7428 - 3854)) and v183) then
								return v183;
							end
							v182 = 1 + 1;
						end
						if (((900 - (642 + 37)) < (89 + 301)) and (v182 == (1 + 2))) then
							if (v183 or ((5556 - 3343) <= (1875 - (233 + 221)))) then
								return v183;
							end
							v183 = v82.InterruptWithStun(v84.KidneyShot, 18 - 10, v15:ComboPoints() > (0 + 0));
							if (((4599 - (718 + 823)) < (3059 + 1801)) and v183) then
								return v183;
							end
							break;
						end
						if ((v182 == (805 - (266 + 539))) or ((3668 - 2372) >= (5671 - (636 + 589)))) then
							v183 = v82.Interrupt(v84.Kick, 18 - 10, true);
							if (v183 or ((2872 - 1479) > (3558 + 931))) then
								return v183;
							end
							v183 = v82.Interrupt(v84.Kick, 3 + 5, true, v12, v86.KickMouseover);
							v182 = 1016 - (657 + 358);
						end
						if ((v182 == (4 - 2)) or ((10078 - 5654) < (1214 - (1151 + 36)))) then
							v183 = v82.Interrupt(v84.Blind, 15 + 0, v79, v12, v86.BlindMouseover);
							if (v183 or ((526 + 1471) > (11393 - 7578))) then
								return v183;
							end
							v183 = v82.InterruptWithStun(v84.CheapShot, 1840 - (1552 + 280), v15:StealthUp(false, false));
							v182 = 837 - (64 + 770);
						end
					end
				end
				if (((2353 + 1112) > (4342 - 2429)) and v29) then
					v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 6 + 24, true);
					if (((1976 - (157 + 1086)) < (3640 - 1821)) and v94) then
						return v94;
					end
				end
				v138 = 30 - 23;
			end
			if ((v138 == (0 - 0)) or ((5998 - 1603) == (5574 - (599 + 220)))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v138 = 1 - 0;
			end
			if ((v138 == (1932 - (1813 + 118))) or ((2773 + 1020) < (3586 - (841 + 376)))) then
				v28 = EpicSettings.Toggles['cds'];
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v138 = 2 - 0;
			end
			if (((2 + 6) == v138) or ((11147 - 7063) == (1124 - (464 + 395)))) then
				if (((11184 - 6826) == (2093 + 2265)) and v82.TargetIsValid()) then
					local v184 = 837 - (467 + 370);
					while true do
						if ((v184 == (0 - 0)) or ((2304 + 834) < (3403 - 2410))) then
							v94 = v121();
							if (((520 + 2810) > (5404 - 3081)) and v94) then
								return "CDs: " .. v94;
							end
							if (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld) or ((4146 - (150 + 370)) == (5271 - (74 + 1208)))) then
								local v195 = 0 - 0;
								while true do
									if ((v195 == (0 - 0)) or ((652 + 264) == (3061 - (14 + 376)))) then
										v94 = v122();
										if (((471 - 199) == (177 + 95)) and v94) then
											return "Stealth: " .. v94;
										end
										break;
									end
								end
							end
							v184 = 1 + 0;
						end
						if (((4053 + 196) <= (14178 - 9339)) and (v184 == (2 + 0))) then
							if (((2855 - (23 + 55)) < (7583 - 4383)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > (11 + 4 + v100))) then
								if (((86 + 9) < (3033 - 1076)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((260 + 566) < (2618 - (652 + 249))) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
								if (((3816 - 2390) >= (2973 - (708 + 1160))) and v9.Cast(v84.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							if (((7475 - 4721) <= (6160 - 2781)) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(32 - (10 + 17))) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((883 + 3044) == (3145 - (1400 + 332)))) then
									return "Cast Lights Judgment";
								end
							end
							v184 = 5 - 2;
						end
						if ((v184 == (1909 - (242 + 1666))) or ((494 + 660) <= (289 + 499))) then
							if (v114() or ((1401 + 242) > (4319 - (850 + 90)))) then
								local v196 = 0 - 0;
								while true do
									if ((v196 == (1390 - (360 + 1030))) or ((2481 + 322) > (12839 - 8290))) then
										v94 = v123();
										if (v94 or ((302 - 82) >= (4683 - (909 + 752)))) then
											return "Finish: " .. v94;
										end
										v196 = 1224 - (109 + 1114);
									end
									if (((5166 - 2344) == (1099 + 1723)) and (v196 == (243 - (6 + 236)))) then
										return "Finish Pooling";
									end
								end
							end
							v94 = v124();
							if (v94 or ((669 + 392) == (1495 + 362))) then
								return "Build: " .. v94;
							end
							v184 = 4 - 2;
						end
						if (((4820 - 2060) > (2497 - (1076 + 57))) and (v184 == (1 + 2))) then
							if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(694 - (579 + 110))) or ((388 + 4514) <= (3179 + 416))) then
								if (v9.Cast(v84.BagofTricks, v30) or ((2045 + 1807) == (700 - (174 + 233)))) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (69 - 44)) and ((v98 >= (1 - 0)) or (v102 <= (1.2 + 0)))) or ((2733 - (663 + 511)) == (4094 + 494))) then
								if (v9.Cast(v84.PistolShot) or ((974 + 3510) == (2429 - 1641))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((2767 + 1801) >= (9198 - 5291)) and v84.SinisterStrike:IsCastable()) then
								if (((3016 - 1770) < (1656 + 1814)) and v9.Cast(v84.SinisterStrike)) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((7917 - 3849) >= (693 + 279)) and (v138 == (1 + 2))) then
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v138 = 726 - (478 + 244);
			end
			if (((1010 - (440 + 77)) < (1771 + 2122)) and (v138 == (14 - 10))) then
				if (v27 or ((3029 - (655 + 901)) >= (618 + 2714))) then
					v91 = v15:GetEnemiesInRange(23 + 7);
					v92 = v15:GetEnemiesInRange(v95);
					v93 = #v92;
				else
					v93 = 1 + 0;
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((16319 - 12268) <= (2602 - (695 + 750)))) then
					return v94;
				end
				v138 = 16 - 11;
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(401 - 141, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

