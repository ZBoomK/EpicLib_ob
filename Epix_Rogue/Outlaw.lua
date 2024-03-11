local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((804 + 2569) <= (264 + 3292)) and not v5) then
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
			if ((v127 == (1597 - (978 + 619))) or ((4645 - (243 + 1111)) < (2997 + 283))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (158 - (91 + 67));
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v127 = 1 + 0;
			end
			if (((4909 - (423 + 100)) >= (7 + 866)) and (v127 == (16 - 10))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v78 = EpicSettings.Settings['sepsis'];
				v127 = 4 + 3;
			end
			if (((1692 - (326 + 445)) <= (4808 - 3706)) and (v127 == (10 - 5))) then
				v70 = EpicSettings.Settings['BladeFlurryGCD'] or (0 - 0);
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 717 - (530 + 181);
			end
			if (((5587 - (614 + 267)) >= (995 - (19 + 13))) and ((6 - 2) == v127)) then
				v58 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v127 = 14 - 9;
			end
			if ((v127 == (1 + 1)) or ((1688 - 728) <= (1816 - 940))) then
				v39 = EpicSettings.Settings['InterruptThreshold'] or (1812 - (1293 + 519));
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 5 - 2;
			end
			if ((v127 == (18 - 11)) or ((3950 - 1884) == (4018 - 3086))) then
				v79 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
				v80 = EpicSettings.Settings['EvasionHP'] or (0 + 0);
				break;
			end
			if (((985 + 3840) < (11252 - 6409)) and (v127 == (1 + 2))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v127 = 3 + 1;
			end
			if ((v127 == (1097 - (709 + 387))) or ((5735 - (673 + 1185)) >= (13157 - 8620))) then
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v127 = 2 + 0;
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
	local v89 = (v88[16 - 3] and v19(v88[4 + 9])) or v19(0 - 0);
	local v90 = (v88[27 - 13] and v19(v88[1894 - (446 + 1434)])) or v19(1283 - (1040 + 243));
	v9:RegisterForEvent(function()
		v88 = v15:GetEquipment();
		v89 = (v88[38 - 25] and v19(v88[1860 - (559 + 1288)])) or v19(1931 - (609 + 1322));
		v90 = (v88[468 - (13 + 441)] and v19(v88[52 - 38])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 29 - 23;
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 + 0);
	end}};
	local v105, v106 = 0 + 0, 0 + 0;
	local function v107(v128)
		local v129 = 0 + 0;
		local v130;
		while true do
			if (((433 - (153 + 280)) == v129) or ((12460 - 8145) < (1550 + 176))) then
				v130 = v15:EnergyTimeToMaxPredicted(nil, v128);
				if ((v130 < v105) or ((v130 - v105) > (0.5 + 0)) or ((1926 + 1753) < (568 + 57))) then
					v105 = v130;
				end
				v129 = 1 + 0;
			end
			if ((v129 == (1 - 0)) or ((2859 + 1766) < (1299 - (89 + 578)))) then
				return v105;
			end
		end
	end
	local function v108()
		local v131 = 0 + 0;
		local v132;
		while true do
			if ((v131 == (0 - 0)) or ((1132 - (572 + 477)) > (241 + 1539))) then
				v132 = v15:EnergyPredicted();
				if (((328 + 218) <= (129 + 948)) and ((v132 > v106) or ((v132 - v106) > (95 - (84 + 2))))) then
					v106 = v132;
				end
				v131 = 1 - 0;
			end
			if (((1 + 0) == v131) or ((1838 - (497 + 345)) > (111 + 4190))) then
				return v106;
			end
		end
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((3670 + 400) > (1903 - 1216)) and not v10.APLVar.RtB_Buffs) then
			local v142 = 0 + 0;
			local v143;
			while true do
				if ((v142 == (490 - (457 + 32))) or ((279 + 377) >= (4732 - (832 + 570)))) then
					v10.APLVar.RtB_Buffs.Normal = 0 + 0;
					v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v10.APLVar.RtB_Buffs.Longer = 0 - 0;
					v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
					v142 = 798 - (588 + 208);
				end
				if (((5 - 3) == v142) or ((4292 - (884 + 916)) <= (701 - 366))) then
					v143 = v83.RtBRemains();
					for v181 = 1 + 0, #v109 do
						local v182 = v15:BuffRemains(v109[v181]);
						if (((4975 - (232 + 421)) >= (4451 - (1569 + 320))) and (v182 > (0 + 0))) then
							v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
							if ((v182 > v10.APLVar.RtB_Buffs.MaxRemains) or ((12255 - 8618) >= (4375 - (316 + 289)))) then
								v10.APLVar.RtB_Buffs.MaxRemains = v182;
							end
							local v187 = math.abs(v182 - v143);
							if ((v187 <= (0.5 - 0)) or ((110 + 2269) > (6031 - (666 + 787)))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (426 - (360 + 65));
								v10.APLVar.RtB_Buffs.Will_Lose[v109[v181]:Name()] = true;
								v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
							elseif ((v182 > v143) or ((737 - (79 + 175)) > (1171 - 428))) then
								v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
							else
								local v198 = 0 - 0;
								while true do
									if (((4725 - 2271) > (1477 - (503 + 396))) and (v198 == (181 - (92 + 89)))) then
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (1 - 0);
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v181]:Name()] = true;
										v198 = 1 + 0;
									end
									if (((551 + 379) < (17458 - 13000)) and (v198 == (1 + 0))) then
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (2 - 1);
										break;
									end
								end
							end
						end
						if (((578 + 84) <= (465 + 507)) and v110) then
							local v188 = 0 - 0;
							while true do
								if (((546 + 3824) == (6664 - 2294)) and (v188 == (1244 - (485 + 759)))) then
									print("RtbRemains", v143);
									print(v109[v181]:Name(), v182);
									break;
								end
							end
						end
					end
					if (v110 or ((11018 - 6256) <= (2050 - (442 + 747)))) then
						local v184 = 1135 - (832 + 303);
						while true do
							if ((v184 == (948 - (88 + 858))) or ((431 + 981) == (3529 + 735))) then
								print("longer: ", v10.APLVar.RtB_Buffs.Longer);
								print("max remains: ", v10.APLVar.RtB_Buffs.MaxRemains);
								break;
							end
							if ((v184 == (0 + 0)) or ((3957 - (766 + 23)) < (10628 - 8475))) then
								print("have: ", v10.APLVar.RtB_Buffs.Total);
								print("will lose: ", v10.APLVar.RtB_Buffs.Will_Lose.Total);
								v184 = 1 - 0;
							end
							if ((v184 == (2 - 1)) or ((16888 - 11912) < (2405 - (1036 + 37)))) then
								print("shorter: ", v10.APLVar.RtB_Buffs.Shorter);
								print("normal: ", v10.APLVar.RtB_Buffs.Normal);
								v184 = 2 + 0;
							end
						end
					end
					break;
				end
				if (((9012 - 4384) == (3641 + 987)) and (v142 == (1480 - (641 + 839)))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Will_Lose = {};
					v10.APLVar.RtB_Buffs.Will_Lose.Total = 913 - (910 + 3);
					v10.APLVar.RtB_Buffs.Total = 0 - 0;
					v142 = 1685 - (1466 + 218);
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v112(v133)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v133] and true) or false;
	end
	local function v113()
		if (not v10.APLVar.RtB_Reroll or ((25 + 29) == (1543 - (556 + 592)))) then
			if (((30 + 52) == (890 - (329 + 479))) and (v64 == "1+ Buff")) then
				v10.APLVar.RtB_Reroll = ((v111() <= (854 - (174 + 680))) and true) or false;
			elseif ((v64 == "Broadside") or ((1996 - 1415) < (584 - 302))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
			elseif ((v64 == "Buried Treasure") or ((3291 + 1318) < (3234 - (396 + 343)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
			elseif (((102 + 1050) == (2629 - (29 + 1448))) and (v64 == "Grand Melee")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
			elseif (((3285 - (135 + 1254)) <= (12891 - 9469)) and (v64 == "Skull and Crossbones")) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
			elseif ((v64 == "Ruthless Precision") or ((4622 - 3632) > (1080 + 540))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
			elseif ((v64 == "True Bearing") or ((2404 - (389 + 1138)) > (5269 - (102 + 472)))) then
				v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
			else
				local v207 = 0 + 0;
				while true do
					if (((1493 + 1198) >= (1726 + 125)) and (v207 == (1548 - (320 + 1225)))) then
						if ((v10.APLVar.RtB_Reroll and (v10.APLVar.RtB_Buffs.Longer == (0 - 0))) or ((v10.APLVar.RtB_Buffs.Normal == (0 + 0)) and (v10.APLVar.RtB_Buffs.Longer >= (1465 - (157 + 1307))) and (v111() < (1865 - (821 + 1038))) and (v10.APLVar.RtB_Buffs.MaxRemains <= (97 - 58)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)) or ((327 + 2658) >= (8624 - 3768))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((1591 + 2685) >= (2961 - 1766)) and (v16:FilteredTimeToDie("<", 1038 - (834 + 192)) or v9.BossFilteredFightRemains("<", 1 + 11))) then
							v10.APLVar.RtB_Reroll = false;
						end
						break;
					end
					if (((830 + 2402) <= (101 + 4589)) and (v207 == (0 - 0))) then
						v10.APLVar.RtB_Reroll = false;
						v111();
						v207 = 305 - (300 + 4);
					end
					if ((v207 == (1 + 0)) or ((2345 - 1449) >= (3508 - (112 + 250)))) then
						if (((1221 + 1840) >= (7410 - 4452)) and (v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee)))) and (v93 < (2 + 0))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((1649 + 1538) >= (482 + 162)) and v84.Crackshot:IsAvailable() and not v15:HasTier(16 + 15, 3 + 1) and ((not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1415 - (1001 + 413)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v207 = 4 - 2;
					end
					if (((1526 - (244 + 638)) <= (1397 - (627 + 66))) and (v207 == (5 - 3))) then
						if (((1560 - (512 + 90)) > (2853 - (1665 + 241))) and v84.Crackshot:IsAvailable() and v15:HasTier(748 - (373 + 344), 2 + 2) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff))))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((11848 - 7356) >= (4491 - 1837)) and not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((1101 - (35 + 1064)) + v112(v84.GrandMelee))) and (v93 < (2 + 0))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v207 = 6 - 3;
					end
				end
			end
		end
		return v10.APLVar.RtB_Reroll;
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (1 + 0)) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((1238 - (298 + 938)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (1309 - (233 + 1026)));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (1668 - (636 + 1030))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if (((3363 + 79) >= (447 + 1056)) and (v134 == (1 + 0))) then
				if ((v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (227 - (55 + 166))) or not v67) and not v15:StealthUp(true, false)) or ((615 + 2555) <= (148 + 1316))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((18320 - 13523) == (4685 - (36 + 261)))) then
						return "Cast Shadow Dance Crackshot";
					end
				end
				if (((963 - 412) <= (2049 - (34 + 1334))) and v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) then
					if (((1260 + 2017) > (317 + 90)) and v11(v84.ShadowDance, v9.Cast(v84.ShadowDance, v53))) then
						return "Cast Shadow Dance";
					end
				end
				v134 = 1285 - (1035 + 248);
			end
			if (((4716 - (20 + 1)) >= (738 + 677)) and (v134 == (321 - (134 + 185)))) then
				if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (1163 - (549 + 584))) or ((v84.KeepItRolling:CooldownRemains() >= (805 - (314 + 371))) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((11026 - 7814) <= (1912 - (478 + 490)))) then
					if (v9.Cast(v84.ShadowDance, v53) or ((1641 + 1455) <= (2970 - (786 + 386)))) then
						return "Cast Shadow Dance";
					end
				end
				if (((11456 - 7919) == (4916 - (1055 + 324))) and v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady()) then
					if (((5177 - (1093 + 247)) >= (1396 + 174)) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
						if (v9.Cast(v84.Shadowmeld, v30) or ((311 + 2639) == (15134 - 11322))) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
			if (((16028 - 11305) >= (6595 - 4277)) and (v134 == (0 - 0))) then
				if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (3 + 3))) and v115()) or ((7808 - 5781) > (9830 - 6978))) then
					if (v9.Cast(v84.Vanish, v67) or ((857 + 279) > (11040 - 6723))) then
						return "Cast Vanish (HO)";
					end
				end
				if (((5436 - (364 + 324)) == (13015 - 8267)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
					if (((8964 - 5228) <= (1571 + 3169)) and v9.Cast(v84.Vanish, v67)) then
						return "Cast Vanish (Finish)";
					end
				end
				v134 = 4 - 3;
			end
		end
	end
	local function v120()
		local v135 = v82.HandleTopTrinket(v87, v28, 64 - 24, nil);
		if (v135 or ((10295 - 6905) <= (4328 - (1249 + 19)))) then
			return v135;
		end
		local v135 = v82.HandleBottomTrinket(v87, v28, 37 + 3, nil);
		if (v135 or ((3888 - 2889) > (3779 - (686 + 400)))) then
			return v135;
		end
	end
	local function v121()
		local v136 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
		if (((364 + 99) < (830 - (73 + 156))) and v136) then
			return "DPS Pot";
		end
		if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))))) or ((2994 - (721 + 90)) < (8 + 679))) then
			if (((14769 - 10220) == (5019 - (224 + 246))) and v11(v84.AdrenalineRush, v75)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((7568 - 2896) == (8601 - 3929)) and v84.BladeFlurry:IsReady()) then
			if (((v93 >= ((1 + 1) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) or ((88 + 3580) < (291 + 104))) then
				if (v11(v84.BladeFlurry) or ((8282 - 4116) == (1514 - 1059))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v84.BladeFlurry:IsReady() or ((4962 - (203 + 310)) == (4656 - (1238 + 755)))) then
			if ((v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (1 + 2)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1539 - (709 + 825))))) or ((7881 - 3604) < (4353 - 1364))) then
				if (v11(v84.BladeFlurry) or ((1734 - (196 + 668)) >= (16381 - 12232))) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((4581 - 2369) < (4016 - (171 + 662))) and v84.RolltheBones:IsReady()) then
			if (((4739 - (4 + 89)) > (10486 - 7494)) and ((v113() and not v15:StealthUp(true, true)) or (v111() == (0 + 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (13 - 10)) and v15:HasTier(13 + 18, 1490 - (35 + 1451))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1460 - (28 + 1425))) and ((v84.ShadowDance:CooldownRemains() <= (1996 - (941 + 1052))) or (v84.Vanish:CooldownRemains() <= (3 + 0))) and not v15:StealthUp(true, true)))) then
				if (((2948 - (822 + 692)) < (4433 - 1327)) and v11(v84.RolltheBones)) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v137 = v120();
		if (((371 + 415) < (3320 - (45 + 252))) and v137) then
			return v137;
		end
		if ((v84.KeepItRolling:IsReady() and not v113() and (v111() >= (3 + 0 + v21(v15:HasTier(11 + 20, 9 - 5)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (439 - (114 + 319))))) or ((3505 - 1063) < (94 - 20))) then
			if (((2892 + 1643) == (6756 - 2221)) and v9.Cast(v84.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (14 - 7))) or ((4972 - (556 + 1407)) <= (3311 - (741 + 465)))) then
			if (((2295 - (170 + 295)) < (1934 + 1735)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((1314 + 116) >= (8892 - 5280))) then
			if (((2225 + 458) >= (1578 + 882)) and ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 7 + 4) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 1241 - (957 + 273)))) then
				if (v9.Cast(v84.Sepsis) or ((483 + 1321) >= (1312 + 1963))) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v84.BladeRush:IsReady() and (v102 > (15 - 11)) and not v15:StealthUp(true, true)) or ((3733 - 2316) > (11084 - 7455))) then
			if (((23743 - 18948) > (2182 - (389 + 1391))) and v9.Cast(v84.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((3020 + 1793) > (372 + 3193)) and not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) then
			local v144 = 0 - 0;
			while true do
				if (((4863 - (783 + 168)) == (13129 - 9217)) and (v144 == (0 + 0))) then
					v137 = v119();
					if (((3132 - (309 + 2)) <= (14813 - 9989)) and v137) then
						return v137;
					end
					break;
				end
			end
		end
		if (((2950 - (1090 + 122)) <= (712 + 1483)) and v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (335 - 235)) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (5 + 1)))) then
			if (((1159 - (628 + 490)) <= (542 + 2476)) and v9.Cast(v84.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (((5310 - 3165) <= (18755 - 14651)) and v84.BladeRush:IsCastable() and (v102 > (778 - (431 + 343))) and not v15:StealthUp(true, true)) then
			if (((5430 - 2741) < (14016 - 9171)) and v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush))) then
				return "Cast Blade Rush";
			end
		end
		if (v84.BloodFury:IsCastable() or ((1835 + 487) > (336 + 2286))) then
			if (v9.Cast(v84.BloodFury, v30) or ((6229 - (556 + 1139)) == (2097 - (6 + 9)))) then
				return "Cast Blood Fury";
			end
		end
		if (v84.Berserking:IsCastable() or ((288 + 1283) > (957 + 910))) then
			if (v9.Cast(v84.Berserking, v30) or ((2823 - (28 + 141)) >= (1161 + 1835))) then
				return "Cast Berserking";
			end
		end
		if (((4909 - 931) > (1491 + 613)) and v84.Fireblood:IsCastable()) then
			if (((4312 - (486 + 831)) > (4009 - 2468)) and v9.Cast(v84.Fireblood, v30)) then
				return "Cast Fireblood";
			end
		end
		if (((11438 - 8189) > (181 + 772)) and v84.AncestralCall:IsCastable()) then
			if (v9.Cast(v84.AncestralCall, v30) or ((10348 - 7075) > (5836 - (668 + 595)))) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v122()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1 + 0)) or ((8593 - 5442) < (1574 - (23 + 267)))) then
				if ((v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) or ((3794 - (1129 + 815)) == (1916 - (371 + 16)))) then
					if (((2571 - (1326 + 424)) < (4020 - 1897)) and v9.Cast(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((3296 - 2394) < (2443 - (88 + 30))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (((1629 - (720 + 51)) <= (6588 - 3626)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v138 = 1778 - (421 + 1355);
			end
			if ((v138 == (0 - 0)) or ((1939 + 2007) < (2371 - (286 + 797)))) then
				if ((v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (7 - 5)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((5369 - 2127) == (1006 - (397 + 42)))) then
					if (v70 or ((265 + 582) >= (2063 - (24 + 776)))) then
						v9.Cast(v84.BladeFlurry);
					elseif (v9.Cast(v84.BladeFlurry) or ((3470 - 1217) == (2636 - (222 + 563)))) then
						return "Cast Blade Flurry";
					end
				end
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((4597 - 2510) > (1708 + 664))) then
					if (v9.Cast(v84.ColdBlood) or ((4635 - (23 + 167)) < (5947 - (690 + 1108)))) then
						return "Cast Cold Blood";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (2 + 0)) or ((2666 - (40 + 808)) == (14 + 71))) then
				if (((2409 - 1779) < (2033 + 94)) and v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (2 + 0)) and (v15:BuffStack(v84.Opportunity) >= (4 + 2)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (572 - (47 + 524)))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
					if (v9.Press(v84.PistolShot) or ((1258 + 680) == (6872 - 4358))) then
						return "Cast Pistol Shot";
					end
				end
				if (((6362 - 2107) >= (125 - 70)) and v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) then
					if (((4725 - (1165 + 561)) > (35 + 1121)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v139 = 0 - 0;
		while true do
			if (((897 + 1453) > (1634 - (341 + 138))) and (v139 == (0 + 0))) then
				if (((8314 - 4285) <= (5179 - (89 + 237))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (12 - 8)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(63 - 33, 885 - (581 + 300))) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (v9.Press(v84.BetweentheEyes) or ((1736 - (855 + 365)) > (8156 - 4722))) then
						return "Cast Between the Eyes";
					end
				end
				if (((1322 + 2724) >= (4268 - (1030 + 205))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (43 + 2)) and (v84.ShadowDance:CooldownRemains() > (12 + 0))) then
					if (v9.Press(v84.BetweentheEyes) or ((3005 - (156 + 130)) <= (3287 - 1840))) then
						return "Cast Between the Eyes";
					end
				end
				v139 = 1 - 0;
			end
			if ((v139 == (3 - 1)) or ((1090 + 3044) < (2290 + 1636))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((233 - (10 + 59)) >= (788 + 1997))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((2585 - 2060) == (3272 - (671 + 492)))) then
						return "Cast Cold Blood";
					end
				end
				if (((27 + 6) == (1248 - (369 + 846))) and v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) then
					if (((809 + 2245) <= (3427 + 588)) and v9.Press(v84.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((3816 - (1036 + 909)) < (2689 + 693)) and (v139 == (1 - 0))) then
				if (((1496 - (11 + 192)) <= (1095 + 1071)) and v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (175 - (135 + 40)))) and (v15:BuffRemains(v84.SliceandDice) < (((2 - 1) + v97) * (1.8 + 0)))) then
					if (v9.Press(v84.SliceandDice) or ((5681 - 3102) < (184 - 61))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) or ((1022 - (50 + 126)) >= (6593 - 4225))) then
					if (v9.Cast(v84.KillingSpree) or ((888 + 3124) <= (4771 - (1233 + 180)))) then
						return "Cast Killing Spree";
					end
				end
				v139 = 971 - (522 + 447);
			end
		end
	end
	local function v124()
		local v140 = 1421 - (107 + 1314);
		while true do
			if (((694 + 800) <= (9156 - 6151)) and ((2 + 1) == v140)) then
				if ((v84.SinisterStrike:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((6177 - 3066) == (8443 - 6309))) then
					if (((4265 - (716 + 1194)) == (41 + 2314)) and v9.Press(v84.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v140 == (1 + 0)) or ((1091 - (74 + 429)) <= (833 - 401))) then
				if (((2378 + 2419) >= (8916 - 5021)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
					if (((2531 + 1046) == (11027 - 7450)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((9380 - 5586) > (4126 - (279 + 154))) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (784 - (454 + 324))) or (v15:BuffRemains(v84.Opportunity) < (2 + 0)))) then
					if (v9.Press(v84.PistolShot) or ((1292 - (12 + 5)) == (2211 + 1889))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v140 = 4 - 2;
			end
			if ((v140 == (1 + 1)) or ((2684 - (277 + 816)) >= (15297 - 11717))) then
				if (((2166 - (1058 + 125)) <= (339 + 1469)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((976 - (815 + 160)) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (4 - 3))))) or (v97 <= (2 - 1)))) then
					if (v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot)) or ((513 + 1637) <= (3498 - 2301))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((5667 - (41 + 1857)) >= (3066 - (1222 + 671))) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (2.5 - 1)) or (v98 <= ((1 - 0) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
					if (((2667 - (229 + 953)) == (3259 - (1111 + 663))) and v9.Cast(v84.PistolShot, nil, not v16:IsSpellInRange(v84.PistolShot))) then
						return "Cast Pistol Shot";
					end
				end
				v140 = 1582 - (874 + 705);
			end
			if ((v140 == (0 + 0)) or ((2262 + 1053) <= (5782 - 3000))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((25 + 851) >= (3643 - (642 + 37)))) then
					if (v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand)) or ((509 + 1723) > (400 + 2097))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((5297 - 3187) <= (786 - (233 + 221)))) then
					if (((8523 - 4837) > (2792 + 380)) and v9.Press(v84.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v140 = 1542 - (718 + 823);
			end
		end
	end
	local function v125()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (805 - (266 + 539))) or ((12666 - 8192) < (2045 - (636 + 589)))) then
				v81();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v141 = 2 - 1;
			end
			if (((8825 - 4546) >= (2284 + 598)) and (v141 == (2 + 1))) then
				if (v27 or ((3044 - (657 + 358)) >= (9322 - 5801))) then
					v91 = v15:GetEnemiesInRange(68 - 38);
					v92 = v15:GetEnemiesInRange(v95);
					v93 = #v92;
				else
					v93 = 1188 - (1151 + 36);
				end
				v94 = v83.CrimsonVial();
				if (v94 or ((1968 + 69) >= (1221 + 3421))) then
					return v94;
				end
				v83.Poisons();
				v141 = 11 - 7;
			end
			if (((3552 - (1552 + 280)) < (5292 - (64 + 770))) and (v141 == (4 + 1))) then
				if (v29 or ((989 - 553) > (537 + 2484))) then
					local v176 = 1243 - (157 + 1086);
					while true do
						if (((1426 - 713) <= (3709 - 2862)) and (v176 == (0 - 0))) then
							v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 40 - 10, true);
							if (((2973 - (599 + 220)) <= (8027 - 3996)) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if (((6546 - (1813 + 118)) == (3374 + 1241)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
					local v177 = 1217 - (841 + 376);
					while true do
						if ((v177 == (0 - 0)) or ((881 + 2909) == (1364 - 864))) then
							v94 = v83.Stealth(v84.Stealth2, nil);
							if (((948 - (464 + 395)) < (567 - 346)) and v94) then
								return "Stealth (OOC): " .. v94;
							end
							break;
						end
					end
				end
				if (((987 + 1067) >= (2258 - (467 + 370))) and not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(6 + 2) and v26) then
					if (((2372 - 1680) < (478 + 2580)) and v82.TargetIsValid() and v16:IsInRange(23 - 13) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v185 = 520 - (150 + 370);
						while true do
							if ((v185 == (1282 - (74 + 1208))) or ((8003 - 4749) == (7848 - 6193))) then
								if ((v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) or ((923 + 373) == (5300 - (14 + 376)))) then
									if (((5841 - 2473) == (2180 + 1188)) and v11(v84.BladeFlurry)) then
										return "Blade Flurry (Opener)";
									end
								end
								if (((2322 + 321) < (3639 + 176)) and not v15:StealthUp(true, false)) then
									local v200 = 0 - 0;
									while true do
										if (((1440 + 473) > (571 - (23 + 55))) and (v200 == (0 - 0))) then
											v94 = v83.Stealth(v83.StealthSpell());
											if (((3174 + 1581) > (3079 + 349)) and v94) then
												return v94;
											end
											break;
										end
									end
								end
								v185 = 1 - 0;
							end
							if (((435 + 946) <= (3270 - (652 + 249))) and (v185 == (2 - 1))) then
								if (v82.TargetIsValid() or ((6711 - (708 + 1160)) == (11085 - 7001))) then
									local v201 = 0 - 0;
									while true do
										if (((4696 - (10 + 17)) > (82 + 281)) and (v201 == (1734 - (1400 + 332)))) then
											if (v84.SinisterStrike:IsCastable() or ((3599 - 1722) >= (5046 - (242 + 1666)))) then
												if (((2030 + 2712) >= (1329 + 2297)) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if ((v201 == (1 + 0)) or ((5480 - (850 + 90)) == (1603 - 687))) then
											if ((v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((1391 - (360 + 1030)) + v97) * (1.8 + 0)))) or ((3262 - 2106) > (5977 - 1632))) then
												if (((3898 - (909 + 752)) < (5472 - (109 + 1114))) and v9.Press(v84.SliceandDice)) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (v15:StealthUp(true, false) or ((4911 - 2228) < (9 + 14))) then
												v94 = v122();
												if (((939 - (6 + 236)) <= (521 + 305)) and v94) then
													return "Stealth (Opener): " .. v94;
												end
												if (((890 + 215) <= (2773 - 1597)) and v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) then
													if (((5901 - 2522) <= (4945 - (1076 + 57))) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((130 + 658) >= (2305 - (579 + 110)))) then
													if (((147 + 1707) <= (2988 + 391)) and v11(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (((2415 + 2134) == (4956 - (174 + 233))) and v84.SinisterStrike:IsCastable()) then
													if (v11(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike)) or ((8441 - 5419) >= (5307 - 2283))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
											elseif (((2144 + 2676) > (3372 - (663 + 511))) and v114()) then
												local v209 = 0 + 0;
												while true do
													if ((v209 == (0 + 0)) or ((3270 - 2209) >= (2962 + 1929))) then
														v94 = v123();
														if (((3211 - 1847) <= (10828 - 6355)) and v94) then
															return "Finish (Opener): " .. v94;
														end
														break;
													end
												end
											end
											v201 = 1 + 1;
										end
										if ((v201 == (0 - 0)) or ((2563 + 1032) <= (1 + 2))) then
											if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (722 - (478 + 244))) or v113())) or ((5189 - (440 + 77)) == (1752 + 2100))) then
												if (((5705 - 4146) == (3115 - (655 + 901))) and v9.Cast(v84.RolltheBones)) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if ((v84.AdrenalineRush:IsReady() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1 + 1))) or ((1342 + 410) <= (533 + 255))) then
												if (v9.Cast(v84.AdrenalineRush) or ((15739 - 11832) == (1622 - (695 + 750)))) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v201 = 3 - 2;
										end
									end
								end
								return;
							end
						end
					end
				end
				if (((5355 - 1885) > (2232 - 1677)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					v97 = v25(v97, v83.FanTheHammerCP());
				end
				v141 = 357 - (285 + 66);
			end
			if (((2 - 1) == v141) or ((2282 - (682 + 628)) == (104 + 541))) then
				v97 = v15:ComboPoints();
				v96 = v83.EffectiveComboPoints(v97);
				v98 = v15:ComboPointsDeficit();
				v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(349 - (176 + 123))) or (0 + 0);
				v141 = 2 + 0;
			end
			if (((3451 - (239 + 30)) >= (575 + 1540)) and (v141 == (2 + 0))) then
				v99 = v108();
				v100 = v15:EnergyRegen();
				v102 = v107(v103);
				v101 = v15:EnergyDeficitPredicted(nil, v103);
				v141 = 4 - 1;
			end
			if (((12145 - 8252) < (4744 - (306 + 9))) and (v141 == (13 - 9))) then
				if ((v32 and (v15:HealthPercentage() <= v34)) or ((499 + 2368) < (1169 + 736))) then
					if ((v33 == "Refreshing Healing Potion") or ((865 + 931) >= (11584 - 7533))) then
						if (((2994 - (1140 + 235)) <= (2391 + 1365)) and v85.RefreshingHealingPotion:IsReady()) then
							if (((554 + 50) == (156 + 448)) and v9.Press(v86.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v33 == "Dreamwalker's Healing Potion") or ((4536 - (33 + 19)) == (325 + 575))) then
						if (v85.DreamwalkersHealingPotion:IsReady() or ((13364 - 8905) <= (491 + 622))) then
							if (((7122 - 3490) > (3187 + 211)) and v9.Press(v86.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((4771 - (586 + 103)) <= (448 + 4469)) and v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) then
					if (((14875 - 10043) >= (2874 - (1309 + 179))) and v9.Cast(v84.Feint)) then
						return "Cast Feint (Defensives)";
					end
				end
				if (((246 - 109) == (60 + 77)) and v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) then
					if (v9.Cast(v84.Evasion) or ((4216 - 2646) >= (3273 + 1059))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if ((not v15:IsCasting() and not v15:IsChanneling()) or ((8634 - 4570) <= (3624 - 1805))) then
					local v178 = 609 - (295 + 314);
					local v179;
					while true do
						if ((v178 == (6 - 3)) or ((6948 - (1300 + 662)) < (4942 - 3368))) then
							if (((6181 - (1178 + 577)) > (90 + 82)) and v179) then
								return v179;
							end
							v179 = v82.InterruptWithStun(v84.KidneyShot, 23 - 15, v15:ComboPoints() > (1405 - (851 + 554)));
							if (((519 + 67) > (1261 - 806)) and v179) then
								return v179;
							end
							break;
						end
						if (((1793 - 967) == (1128 - (115 + 187))) and ((0 + 0) == v178)) then
							v179 = v82.Interrupt(v84.Kick, 8 + 0, true);
							if (v179 or ((15837 - 11818) > (5602 - (160 + 1001)))) then
								return v179;
							end
							v179 = v82.Interrupt(v84.Kick, 7 + 1, true, v12, v86.KickMouseover);
							v178 = 1 + 0;
						end
						if (((4128 - 2111) < (4619 - (237 + 121))) and (v178 == (899 - (525 + 372)))) then
							v179 = v82.Interrupt(v84.Blind, 28 - 13, v79, v12, v86.BlindMouseover);
							if (((15494 - 10778) > (222 - (96 + 46))) and v179) then
								return v179;
							end
							v179 = v82.InterruptWithStun(v84.CheapShot, 785 - (643 + 134), v15:StealthUp(false, false));
							v178 = 2 + 1;
						end
						if ((v178 == (2 - 1)) or ((13020 - 9513) == (3138 + 134))) then
							if (v179 or ((1719 - 843) >= (6285 - 3210))) then
								return v179;
							end
							v179 = v82.Interrupt(v84.Blind, 734 - (316 + 403), v79);
							if (((2893 + 1459) > (7021 - 4467)) and v179) then
								return v179;
							end
							v178 = 1 + 1;
						end
					end
				end
				v141 = 12 - 7;
			end
			if ((v141 == (5 + 1)) or ((1420 + 2986) < (14008 - 9965))) then
				if (v82.TargetIsValid() or ((9021 - 7132) >= (7027 - 3644))) then
					local v180 = 0 + 0;
					while true do
						if (((3724 - 1832) <= (134 + 2600)) and (v180 == (5 - 3))) then
							if (((1940 - (12 + 5)) < (8614 - 6396)) and v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((31 - 16) + v100))) then
								if (((4619 - 2446) > (939 - 560)) and v9.Cast(v84.ArcaneTorrent, v30)) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) or ((526 + 2065) == (5382 - (1656 + 317)))) then
								if (((4023 + 491) > (2664 + 660)) and v9.Cast(v84.ArcanePulse)) then
									return "Cast Arcane Pulse";
								end
							end
							if ((v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(13 - 8)) or ((1023 - 815) >= (5182 - (5 + 349)))) then
								if (v9.Cast(v84.LightsJudgment, v30) or ((7518 - 5935) > (4838 - (266 + 1005)))) then
									return "Cast Lights Judgment";
								end
							end
							v180 = 2 + 1;
						end
						if (((0 - 0) == v180) or ((1728 - 415) == (2490 - (561 + 1135)))) then
							v94 = v121();
							if (((4136 - 962) > (9539 - 6637)) and v94) then
								return "CDs: " .. v94;
							end
							if (((5186 - (507 + 559)) <= (10689 - 6429)) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
								local v195 = 0 - 0;
								while true do
									if ((v195 == (388 - (212 + 176))) or ((1788 - (250 + 655)) > (13029 - 8251))) then
										v94 = v122();
										if (v94 or ((6325 - 2705) >= (7652 - 2761))) then
											return "Stealth: " .. v94;
										end
										break;
									end
								end
							end
							v180 = 1957 - (1869 + 87);
						end
						if (((14768 - 10510) > (2838 - (484 + 1417))) and (v180 == (2 - 1))) then
							if (v114() or ((8159 - 3290) < (1679 - (48 + 725)))) then
								local v196 = 0 - 0;
								while true do
									if ((v196 == (0 - 0)) or ((712 + 513) > (11298 - 7070))) then
										v94 = v123();
										if (((932 + 2396) > (653 + 1585)) and v94) then
											return "Finish: " .. v94;
										end
										break;
									end
								end
							end
							v94 = v124();
							if (((4692 - (152 + 701)) > (2716 - (430 + 881))) and v94) then
								return "Build: " .. v94;
							end
							v180 = 1 + 1;
						end
						if ((v180 == (898 - (557 + 338))) or ((383 + 910) <= (1428 - 921))) then
							if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(17 - 12)) or ((7693 - 4797) < (1734 - 929))) then
								if (((3117 - (499 + 302)) == (3182 - (39 + 827))) and v9.Cast(v84.BagofTricks, v30)) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v84.PistolShot:IsCastable() and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (68 - 43)) and ((v98 >= (2 - 1)) or (v102 <= (3.2 - 2)))) or ((3945 - 1375) == (132 + 1401))) then
								if (v9.Cast(v84.PistolShot) or ((2584 - 1701) == (234 + 1226))) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (v84.SinisterStrike:IsCastable() or ((7308 - 2689) <= (1103 - (103 + 1)))) then
								if (v9.Cast(v84.SinisterStrike) or ((3964 - (475 + 79)) > (8897 - 4781))) then
									return "Cast Sinister Strike Filler";
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
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(832 - 572, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

