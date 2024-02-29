local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3559 - (192 + 134)) == (4509 - (316 + 960))) and not v5) then
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
	local function v80()
		local v126 = 0 + 0;
		while true do
			if (((1130 + 334) <= (4046 + 331)) and (v126 == (7 - 5))) then
				v38 = EpicSettings.Settings['InterruptThreshold'] or (551 - (83 + 468));
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v126 = 1809 - (1202 + 604);
			end
			if (((12552 - 9863) < (7859 - 3136)) and (v126 == (10 - 6))) then
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'] or (325 - (45 + 280));
				v126 = 5 + 0;
			end
			if (((3614 + 522) >= (876 + 1521)) and (v126 == (3 + 2))) then
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v126 = 2 + 4;
			end
			if ((v126 == (0 - 0)) or ((6245 - (340 + 1571)) == (1675 + 2570))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (1772 - (1733 + 39));
				v33 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v126 = 1035 - (125 + 909);
			end
			if ((v126 == (1951 - (1096 + 852))) or ((1919 + 2357) <= (4328 - 1297))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v57 = EpicSettings.Settings['FeintHP'] or (512 - (409 + 103));
				v126 = 240 - (46 + 190);
			end
			if (((101 - (51 + 44)) == v126) or ((1349 + 3433) <= (2516 - (1114 + 203)))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				v78 = EpicSettings.Settings['BlindInterrupt'] or (726 - (228 + 498));
				v126 = 2 + 5;
			end
			if ((v126 == (1 + 0)) or ((5527 - (174 + 489)) < (4955 - 3053))) then
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (1905 - (830 + 1075));
				v36 = EpicSettings.Settings['InterruptWithStun'] or (524 - (303 + 221));
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1269 - (231 + 1038));
				v126 = 2 + 0;
			end
			if (((6001 - (171 + 991)) >= (15248 - 11548)) and (v126 == (18 - 11))) then
				v79 = EpicSettings.Settings['EvasionHP'] or (0 - 0);
				break;
			end
		end
	end
	local v81 = v9.Commons.Everyone;
	local v82 = v9.Commons.Rogue;
	local v83 = v17.Rogue.Outlaw;
	local v84 = v19.Rogue.Outlaw;
	local v85 = v20.Rogue.Outlaw;
	local v86 = {};
	local v87 = v15:GetEquipment();
	local v88 = (v87[11 + 2] and v19(v87[45 - 32])) or v19(0 - 0);
	local v89 = (v87[22 - 8] and v19(v87[43 - 29])) or v19(1248 - (111 + 1137));
	v9:RegisterForEvent(function()
		v87 = v15:GetEquipment();
		v88 = (v87[171 - (91 + 67)] and v19(v87[38 - 25])) or v19(0 + 0);
		v89 = (v87[537 - (423 + 100)] and v19(v87[1 + 13])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v83.Dispatch:RegisterDamageFormula(function()
		return v15:AttackPowerDamageMod() * v82.CPSpend() * (0.3 + 0) * (772 - (326 + 445)) * ((4 - 3) + (v15:VersatilityDmgPct() / (222 - 122))) * ((v16:DebuffUp(v83.GhostlyStrike) and (2.1 - 1)) or (712 - (530 + 181)));
	end);
	local v90, v91, v92;
	local v93;
	local v94 = 887 - (614 + 267);
	local v95, v96, v97;
	local v98, v99, v100, v101, v102;
	local v103 = {{v83.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v83.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v96 > (0 - 0);
	end}};
	local v104, v105 = 0 - 0, 0 - 0;
	local function v106(v127)
		local v128 = v15:EnergyTimeToMaxPredicted(nil, v127);
		if ((v128 < v104) or ((v128 - v104) > (0.5 - 0)) or ((2532 - 1457) > (1016 + 902))) then
			v104 = v128;
		end
		return v104;
	end
	local function v107()
		local v129 = 0 + 0;
		local v130;
		while true do
			if (((919 - 523) <= (880 + 2924)) and (v129 == (1 + 0))) then
				return v105;
			end
			if (((0 + 0) == v129) or ((5265 - (709 + 387)) == (4045 - (673 + 1185)))) then
				v130 = v15:EnergyPredicted();
				if (((4077 - 2671) == (4514 - 3108)) and ((v130 > v105) or ((v130 - v105) > (14 - 5)))) then
					v105 = v130;
				end
				v129 = 1 + 0;
			end
		end
	end
	local v108 = {v83.Broadside,v83.BuriedTreasure,v83.GrandMelee,v83.RuthlessPrecision,v83.SkullandCrossbones,v83.TrueBearing};
	local v109 = false;
	local function v110()
		if (((2814 - (1040 + 243)) < (12747 - 8476)) and not v10.APLVar.RtB_Buffs) then
			v10.APLVar.RtB_Buffs = {};
			v10.APLVar.RtB_Buffs.Will_Lose = {};
			v10.APLVar.RtB_Buffs.Will_Lose.Total = 1847 - (559 + 1288);
			v10.APLVar.RtB_Buffs.Total = 1931 - (609 + 1322);
			v10.APLVar.RtB_Buffs.Normal = 454 - (13 + 441);
			v10.APLVar.RtB_Buffs.Shorter = 0 - 0;
			v10.APLVar.RtB_Buffs.Longer = 0 - 0;
			v10.APLVar.RtB_Buffs.MaxRemains = 0 - 0;
			local v148 = v82.RtBRemains();
			for v167 = 1 + 0, #v108 do
				local v168 = 0 - 0;
				local v169;
				while true do
					if (((226 + 409) == (279 + 356)) and (v168 == (2 - 1))) then
						if (((1846 + 1527) <= (6539 - 2983)) and v109) then
							print("RtbRemains", v148);
							print(v108[v167]:Name(), v169);
						end
						break;
					end
					if ((v168 == (0 + 0)) or ((1831 + 1460) < (2357 + 923))) then
						v169 = v15:BuffRemains(v108[v167]);
						if (((3683 + 703) >= (855 + 18)) and (v169 > (433 - (153 + 280)))) then
							local v181 = 0 - 0;
							local v182;
							while true do
								if (((827 + 94) <= (436 + 666)) and (v181 == (0 + 0))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
									if (((3410 + 1296) >= (1466 - 503)) and (v169 > v10.APLVar.RtB_Buffs.MaxRemains)) then
										v10.APLVar.RtB_Buffs.MaxRemains = v169;
									end
									v181 = 1 + 0;
								end
								if ((v181 == (668 - (89 + 578))) or ((686 + 274) <= (1820 - 944))) then
									v182 = math.abs(v169 - v148);
									if ((v182 <= (1049.5 - (572 + 477))) or ((279 + 1787) == (560 + 372))) then
										local v190 = 0 + 0;
										while true do
											if (((4911 - (84 + 2)) < (7981 - 3138)) and ((1 + 0) == v190)) then
												v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (843 - (497 + 345));
												break;
											end
											if ((v190 == (0 + 0)) or ((656 + 3221) >= (5870 - (605 + 728)))) then
												v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + 1 + 0;
												v10.APLVar.RtB_Buffs.Will_Lose[v108[v167]:Name()] = true;
												v190 = 1 - 0;
											end
										end
									elseif ((v169 > v148) or ((198 + 4117) < (6381 - 4655))) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + 1 + 0;
									else
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + (2 - 1);
										v10.APLVar.RtB_Buffs.Will_Lose[v108[v167]:Name()] = true;
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + 1 + 0;
									end
									break;
								end
							end
						end
						v168 = 490 - (457 + 32);
					end
				end
			end
			if (v109 or ((1561 + 2118) < (2027 - (832 + 570)))) then
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
	local function v111(v131)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v131] and true) or false;
	end
	local function v112()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (0 + 0)) or ((16367 - 11742) < (305 + 327))) then
				if (not v10.APLVar.RtB_Reroll or ((879 - (588 + 208)) > (4797 - 3017))) then
					if (((2346 - (884 + 916)) <= (2254 - 1177)) and (v63 == "1+ Buff")) then
						v10.APLVar.RtB_Reroll = ((v110() <= (0 + 0)) and true) or false;
					elseif ((v63 == "Broadside") or ((1649 - (232 + 421)) > (6190 - (1569 + 320)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.Broadside) and true) or false;
					elseif (((999 + 3071) > (131 + 556)) and (v63 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.BuriedTreasure) and true) or false;
					elseif ((v63 == "Grand Melee") or ((2210 - 1554) >= (3935 - (316 + 289)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((6523 - 4031) <= (16 + 319))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.SkullandCrossbones) and true) or false;
					elseif (((5775 - (666 + 787)) >= (2987 - (360 + 65))) and (v63 == "Ruthless Precision")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.RuthlessPrecision) and true) or false;
					elseif ((v63 == "True Bearing") or ((3400 + 237) >= (4024 - (79 + 175)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.TrueBearing) and true) or false;
					else
						local v202 = 0 - 0;
						while true do
							if ((v202 == (2 + 0)) or ((7291 - 4912) > (8816 - 4238))) then
								if ((v83.Crackshot:IsAvailable() and v15:HasTier(930 - (503 + 396), 185 - (92 + 89)) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= ((1 - 0) + v21(v15:BuffUp(v83.LoadedDiceBuff))))) or ((248 + 235) > (440 + 303))) then
									v10.APLVar.RtB_Reroll = true;
								end
								if (((9610 - 7156) > (80 + 498)) and not v83.Crackshot:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and not v111(v83.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((4 - 2) + v111(v83.GrandMelee))) and (v92 < (2 + 0))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v202 = 2 + 1;
							end
							if (((2832 - 1902) < (557 + 3901)) and (v202 == (1 - 0))) then
								if (((1906 - (485 + 759)) <= (2248 - 1276)) and (v110() <= (v21(v111(v83.BuriedTreasure)) + v21(v111(v83.GrandMelee)))) and (v92 < (1191 - (442 + 747)))) then
									v10.APLVar.RtB_Reroll = true;
								end
								if (((5505 - (832 + 303)) == (5316 - (88 + 858))) and v83.Crackshot:IsAvailable() and not v15:HasTier(10 + 21, 4 + 0) and ((not v111(v83.TrueBearing) and v83.HiddenOpportunity:IsAvailable()) or (not v111(v83.Broadside) and not v83.HiddenOpportunity:IsAvailable())) and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0))) then
									v10.APLVar.RtB_Reroll = true;
								end
								v202 = 791 - (766 + 23);
							end
							if ((v202 == (0 - 0)) or ((6512 - 1750) <= (2268 - 1407))) then
								v10.APLVar.RtB_Reroll = false;
								v110();
								v202 = 3 - 2;
							end
							if ((v202 == (1076 - (1036 + 37))) or ((1002 + 410) == (8303 - 4039))) then
								if ((v10.APLVar.RtB_Reroll and (v10.APLVar.RtB_Buffs.Longer == (0 + 0))) or ((v10.APLVar.RtB_Buffs.Normal == (1480 - (641 + 839))) and (v10.APLVar.RtB_Buffs.Longer >= (914 - (910 + 3))) and (v110() < (15 - 9)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (1723 - (1466 + 218))) and not v15:StealthUp(true, true) and v15:BuffUp(v83.LoadedDiceBuff)) or ((1456 + 1712) < (3301 - (556 + 592)))) then
									v10.APLVar.RtB_Reroll = true;
								end
								if (v16:FilteredTimeToDie("<", 5 + 7) or v9.BossFilteredFightRemains("<", 820 - (329 + 479)) or ((5830 - (174 + 680)) < (4576 - 3244))) then
									v10.APLVar.RtB_Reroll = false;
								end
								break;
							end
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v113()
		return v95 >= ((v82.CPMaxSpend() - (1 - 0)) - v21((v15:StealthUp(true, true)) and v83.Crackshot:IsAvailable()));
	end
	local function v114()
		return (v83.HiddenOpportunity:IsAvailable() or (v97 >= (2 + 0 + v21(v83.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v83.Broadside))))) and (v98 >= (789 - (396 + 343)));
	end
	local function v115()
		return v66 and (not v15:IsTanking(v16) or v76);
	end
	local function v116()
		return not v83.ShadowDanceTalent:IsAvailable() and ((v83.FanTheHammer:TalentRank() + v21(v83.QuickDraw:IsAvailable()) + v21(v83.Audacity:IsAvailable())) < (v21(v83.CountTheOdds:IsAvailable()) + v21(v83.KeepItRolling:IsAvailable())));
	end
	local function v117()
		return v15:BuffUp(v83.BetweentheEyes) and (not v83.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v83.AudacityBuff) and ((v83.FanTheHammer:TalentRank() < (1 + 1)) or v15:BuffDown(v83.Opportunity)))) and not v83.Crackshot:IsAvailable();
	end
	local function v118()
		if (((6105 - (29 + 1448)) == (6017 - (135 + 1254))) and v83.Vanish:IsReady() and v115() and v83.HiddenOpportunity:IsAvailable() and not v83.Crackshot:IsAvailable() and not v15:BuffUp(v83.Audacity) and (v116() or (v15:BuffStack(v83.Opportunity) < (22 - 16))) and v114()) then
			if (v9.Cast(v83.Vanish, v66) or ((252 - 198) == (264 + 131))) then
				return "Cast Vanish (HO)";
			end
		end
		if (((1609 - (389 + 1138)) == (656 - (102 + 472))) and v83.Vanish:IsReady() and v115() and (not v83.HiddenOpportunity:IsAvailable() or v83.Crackshot:IsAvailable()) and v113()) then
			if (v9.Cast(v83.Vanish, v66) or ((549 + 32) < (157 + 125))) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v83.ShadowDance:IsReady() and v83.Crackshot:IsAvailable() and v113() and ((v83.Vanish:CooldownRemains() >= (6 + 0)) or not v66) and not v15:StealthUp(true, false)) or ((6154 - (320 + 1225)) < (4441 - 1946))) then
			if (((705 + 447) == (2616 - (157 + 1307))) and v9.Cast(v83.ShadowDance, v52)) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((3755 - (821 + 1038)) <= (8537 - 5115)) and v83.ShadowDance:IsReady() and not v83.KeepItRolling:IsAvailable() and v117() and v15:BuffUp(v83.SliceandDice) and (v113() or v83.HiddenOpportunity:IsAvailable()) and (not v83.HiddenOpportunity:IsAvailable() or not v83.Vanish:IsReady() or not v66)) then
			if (v11(v83.ShadowDance, v9.Cast(v83.ShadowDance, v52)) or ((109 + 881) > (2877 - 1257))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v83.ShadowDance:IsReady() and v83.KeepItRolling:IsAvailable() and v117() and ((v83.KeepItRolling:CooldownRemains() <= (12 + 18)) or ((v83.KeepItRolling:CooldownRemains() >= (297 - 177)) and (v113() or v83.HiddenOpportunity:IsAvailable())))) or ((1903 - (834 + 192)) > (299 + 4396))) then
			if (((691 + 2000) >= (40 + 1811)) and v9.Cast(v83.ShadowDance, v52)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v83.Shadowmeld:IsAvailable() and v83.Shadowmeld:IsReady()) or ((4624 - 1639) >= (5160 - (300 + 4)))) then
			if (((1142 + 3134) >= (3128 - 1933)) and ((v83.Crackshot:IsAvailable() and v113()) or (not v83.Crackshot:IsAvailable() and ((v83.CountTheOdds:IsAvailable() and v113()) or v83.HiddenOpportunity:IsAvailable())))) then
				if (((3594 - (112 + 250)) <= (1870 + 2820)) and v9.Cast(v83.Shadowmeld, v29)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v119()
		local v133 = v81.HandleTopTrinket(v86, v28, 100 - 60, nil);
		if (v133 or ((514 + 382) >= (1627 + 1519))) then
			return v133;
		end
		local v133 = v81.HandleBottomTrinket(v86, v28, 30 + 10, nil);
		if (((1518 + 1543) >= (2198 + 760)) and v133) then
			return v133;
		end
	end
	local function v120()
		local v134 = 1414 - (1001 + 413);
		local v135;
		local v136;
		while true do
			if (((7106 - 3919) >= (1526 - (244 + 638))) and (v134 == (694 - (627 + 66)))) then
				if (((1918 - 1274) <= (1306 - (512 + 90))) and v83.BladeFlurry:IsReady()) then
					if (((2864 - (1665 + 241)) > (1664 - (373 + 344))) and (v92 >= ((1 + 1) - v21(v83.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v83.AdrenalineRush)))) and (v15:BuffRemains(v83.BladeFlurry) < v15:GCD())) then
						if (((1189 + 3303) >= (7000 - 4346)) and v11(v83.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((5824 - 2382) >= (2602 - (35 + 1064))) and v83.BladeFlurry:IsReady()) then
					if ((v83.DeftManeuvers:IsAvailable() and not v113() and (((v92 >= (3 + 0)) and (v97 == (v92 + v21(v15:BuffUp(v83.Broadside))))) or (v92 >= (10 - 5)))) or ((13 + 3157) <= (2700 - (298 + 938)))) then
						if (v11(v83.BladeFlurry) or ((6056 - (233 + 1026)) == (6054 - (636 + 1030)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((282 + 269) <= (666 + 15)) and v83.RolltheBones:IsReady()) then
					if (((974 + 2303) > (28 + 379)) and ((v112() and not v15:StealthUp(true, true)) or (v110() == (221 - (55 + 166))) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (1 + 2)) and v15:HasTier(4 + 27, 15 - 11)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (304 - (36 + 261))) and ((v83.ShadowDance:CooldownRemains() <= (4 - 1)) or (v83.Vanish:CooldownRemains() <= (1371 - (34 + 1334)))) and not v15:StealthUp(true, true)))) then
						if (((1805 + 2890) >= (1100 + 315)) and v11(v83.RolltheBones)) then
							return "Cast Roll the Bones";
						end
					end
				end
				v134 = 1285 - (1035 + 248);
			end
			if ((v134 == (27 - (20 + 1))) or ((1674 + 1538) <= (1263 - (134 + 185)))) then
				if (v83.AncestralCall:IsCastable() or ((4229 - (549 + 584)) <= (2483 - (314 + 371)))) then
					if (((12142 - 8605) == (4505 - (478 + 490))) and v9.Cast(v83.AncestralCall, v29)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if (((2033 + 1804) >= (2742 - (786 + 386))) and (v134 == (0 - 0))) then
				v135 = v81.HandleDPSPotion(v15:BuffUp(v83.AdrenalineRush));
				if (v135 or ((4329 - (1055 + 324)) == (5152 - (1093 + 247)))) then
					return "DPS Pot";
				end
				if (((4198 + 525) >= (244 + 2074)) and v28 and v83.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v83.AdrenalineRush) and (not v113() or not v83.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v83.Crackshot:IsAvailable() and v83.ImprovedAdrenalineRush:IsAvailable() and (v96 <= (7 - 5))))) then
					if (v11(v83.AdrenalineRush, v74) or ((6879 - 4852) > (8115 - 5263))) then
						return "Cast Adrenaline Rush";
					end
				end
				v134 = 2 - 1;
			end
			if ((v134 == (2 + 1)) or ((4376 - 3240) > (14879 - 10562))) then
				if (((3581 + 1167) == (12142 - 7394)) and v83.GhostlyStrike:IsAvailable() and v83.GhostlyStrike:IsReady() and (v95 < (695 - (364 + 324)))) then
					if (((10241 - 6505) <= (11374 - 6634)) and v11(v83.GhostlyStrike, v71, nil, not v16:IsSpellInRange(v83.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v28 and v83.Sepsis:IsAvailable() and v83.Sepsis:IsReady()) or ((1124 + 2266) <= (12804 - 9744))) then
					if ((v83.Crackshot:IsAvailable() and v83.BetweentheEyes:IsReady() and v113() and not v15:StealthUp(true, true)) or (not v83.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 17 - 6) and v15:BuffUp(v83.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 33 - 22) or ((2267 - (1249 + 19)) > (2431 + 262))) then
						if (((1802 - 1339) < (1687 - (686 + 400))) and v9.Cast(v83.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v83.BladeRush:IsReady() and (v101 > (4 + 0)) and not v15:StealthUp(true, true)) or ((2412 - (73 + 156)) < (4 + 683))) then
					if (((5360 - (721 + 90)) == (52 + 4497)) and v9.Cast(v83.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v134 = 12 - 8;
			end
			if (((5142 - (224 + 246)) == (7568 - 2896)) and (v134 == (6 - 2))) then
				if ((not v15:StealthUp(true, true) and (not v83.Crackshot:IsAvailable() or v83.BetweentheEyes:IsReady())) or ((666 + 3002) < (10 + 385))) then
					local v173 = 0 + 0;
					while true do
						if ((v173 == (0 - 0)) or ((13863 - 9697) == (968 - (203 + 310)))) then
							v136 = v118();
							if (v136 or ((6442 - (1238 + 755)) == (187 + 2476))) then
								return v136;
							end
							break;
						end
					end
				end
				if ((v28 and v83.ThistleTea:IsAvailable() and v83.ThistleTea:IsCastable() and not v15:BuffUp(v83.ThistleTea) and ((v100 >= (1634 - (709 + 825))) or v9.BossFilteredFightRemains("<", v83.ThistleTea:Charges() * (10 - 4)))) or ((6230 - 1953) < (3853 - (196 + 668)))) then
					if (v9.Cast(v83.ThistleTea) or ((3435 - 2565) >= (8593 - 4444))) then
						return "Cast Thistle Tea";
					end
				end
				if (((3045 - (171 + 662)) < (3276 - (4 + 89))) and v83.BladeRush:IsCastable() and (v101 > (13 - 9)) and not v15:StealthUp(true, true)) then
					if (((1692 + 2954) > (13141 - 10149)) and v11(v83.BladeRush, v69, nil, not v16:IsSpellInRange(v83.BladeRush))) then
						return "Cast Blade Rush";
					end
				end
				v134 = 2 + 3;
			end
			if (((2920 - (35 + 1451)) < (4559 - (28 + 1425))) and (v134 == (1995 - (941 + 1052)))) then
				v136 = v119();
				if (((754 + 32) < (4537 - (822 + 692))) and v136) then
					return v136;
				end
				if ((v83.KeepItRolling:IsReady() and not v112() and (v110() >= ((3 - 0) + v21(v15:HasTier(15 + 16, 301 - (45 + 252))))) and (v15:BuffDown(v83.ShadowDance) or (v110() >= (6 + 0)))) or ((841 + 1601) < (179 - 105))) then
					if (((4968 - (114 + 319)) == (6510 - 1975)) and v9.Cast(v83.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				v134 = 3 - 0;
			end
			if ((v134 == (4 + 1)) or ((4482 - 1473) <= (4410 - 2305))) then
				if (((3793 - (556 + 1407)) < (4875 - (741 + 465))) and v83.BloodFury:IsCastable()) then
					if (v9.Cast(v83.BloodFury, v29) or ((1895 - (170 + 295)) >= (1904 + 1708))) then
						return "Cast Blood Fury";
					end
				end
				if (((2465 + 218) >= (6056 - 3596)) and v83.Berserking:IsCastable()) then
					if (v9.Cast(v83.Berserking, v29) or ((1496 + 308) >= (2101 + 1174))) then
						return "Cast Berserking";
					end
				end
				if (v83.Fireblood:IsCastable() or ((803 + 614) > (4859 - (957 + 273)))) then
					if (((1283 + 3512) > (161 + 241)) and v9.Cast(v83.Fireblood, v29)) then
						return "Cast Fireblood";
					end
				end
				v134 = 22 - 16;
			end
		end
	end
	local function v121()
		if (((12683 - 7870) > (10889 - 7324)) and v83.BladeFlurry:IsReady() and v83.BladeFlurry:IsCastable() and v27 and v83.Subterfuge:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and (v92 >= (9 - 7)) and (v15:BuffRemains(v83.BladeFlurry) <= v15:GCD()) and (v83.AdrenalineRush:IsReady() or v15:BuffUp(v83.AdrenalineRush))) then
			if (((5692 - (389 + 1391)) == (2455 + 1457)) and v69) then
				v9.CastSuggested(v83.BladeFlurry);
			elseif (((294 + 2527) <= (10982 - 6158)) and v9.Cast(v83.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if (((2689 - (783 + 168)) <= (7366 - 5171)) and v83.ColdBlood:IsCastable() and v15:BuffDown(v83.ColdBlood) and v16:IsSpellInRange(v83.Dispatch) and v113()) then
			if (((41 + 0) <= (3329 - (309 + 2))) and v9.Cast(v83.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		if (((6587 - 4442) <= (5316 - (1090 + 122))) and v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and v113() and v83.Crackshot:IsAvailable() and (not v15:BuffUp(v83.Shadowmeld) or v15:StealthUp(true, false))) then
			if (((872 + 1817) < (16271 - 11426)) and v9.Cast(v83.BetweentheEyes)) then
				return "Cast Between the Eyes";
			end
		end
		if ((v83.Dispatch:IsCastable() and v16:IsSpellInRange(v83.Dispatch) and v113()) or ((1590 + 732) > (3740 - (628 + 490)))) then
			if (v9.Press(v83.Dispatch) or ((814 + 3720) == (5154 - 3072))) then
				return "Cast Dispatch";
			end
		end
		if ((v83.PistolShot:IsCastable() and v16:IsSpellInRange(v83.PistolShot) and v83.Crackshot:IsAvailable() and (v83.FanTheHammer:TalentRank() >= (9 - 7)) and (v15:BuffStack(v83.Opportunity) >= (780 - (431 + 343))) and ((v15:BuffUp(v83.Broadside) and (v96 <= (1 - 0))) or v15:BuffUp(v83.GreenskinsWickersBuff))) or ((4544 - 2973) > (1475 + 392))) then
			if (v9.Press(v83.PistolShot) or ((340 + 2314) >= (4691 - (556 + 1139)))) then
				return "Cast Pistol Shot";
			end
		end
		if (((3993 - (6 + 9)) > (386 + 1718)) and v83.Ambush:IsCastable() and v16:IsSpellInRange(v83.Ambush) and v83.HiddenOpportunity:IsAvailable()) then
			if (((1535 + 1460) > (1710 - (28 + 141))) and v9.Press(v83.Ambush)) then
				return "Cast Ambush";
			end
		end
	end
	local function v122()
		local v137 = 0 + 0;
		while true do
			if (((4009 - 760) > (675 + 278)) and (v137 == (1317 - (486 + 831)))) then
				if ((v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and not v83.Crackshot:IsAvailable() and ((v15:BuffRemains(v83.BetweentheEyes) < (10 - 6)) or v83.ImprovedBetweenTheEyes:IsAvailable() or v83.GreenskinsWickers:IsAvailable() or v15:HasTier(105 - 75, 1 + 3)) and v15:BuffDown(v83.GreenskinsWickers)) or ((10348 - 7075) > (5836 - (668 + 595)))) then
					if (v9.Press(v83.BetweentheEyes) or ((2836 + 315) < (259 + 1025))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and v83.Crackshot:IsAvailable() and (v83.Vanish:CooldownRemains() > (122 - 77)) and (v83.ShadowDance:CooldownRemains() > (302 - (23 + 267)))) or ((3794 - (1129 + 815)) == (1916 - (371 + 16)))) then
					if (((2571 - (1326 + 424)) < (4020 - 1897)) and v9.Press(v83.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v137 = 3 - 2;
			end
			if (((1020 - (88 + 30)) < (3096 - (720 + 51))) and (v137 == (4 - 2))) then
				if (((2634 - (421 + 1355)) <= (4885 - 1923)) and v83.ColdBlood:IsCastable() and v15:BuffDown(v83.ColdBlood) and v16:IsSpellInRange(v83.Dispatch)) then
					if (v9.Cast(v83.ColdBlood, v54) or ((1939 + 2007) < (2371 - (286 + 797)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v83.Dispatch:IsCastable() and v16:IsSpellInRange(v83.Dispatch)) or ((11851 - 8609) == (939 - 372))) then
					if (v9.Press(v83.Dispatch) or ((1286 - (397 + 42)) >= (395 + 868))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v137 == (801 - (24 + 776))) or ((3470 - 1217) == (2636 - (222 + 563)))) then
				if ((v83.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v91, ">", v15:BuffRemains(v83.SliceandDice), true) or (v15:BuffRemains(v83.SliceandDice) == (0 - 0))) and (v15:BuffRemains(v83.SliceandDice) < ((1 + 0 + v96) * (191.8 - (23 + 167))))) or ((3885 - (690 + 1108)) > (856 + 1516))) then
					if (v9.Press(v83.SliceandDice) or ((3667 + 778) < (4997 - (40 + 808)))) then
						return "Cast Slice and Dice";
					end
				end
				if ((v83.KillingSpree:IsCastable() and v16:IsSpellInRange(v83.KillingSpree) and (v16:DebuffUp(v83.GhostlyStrike) or not v83.GhostlyStrike:IsAvailable())) or ((300 + 1518) == (325 - 240))) then
					if (((603 + 27) < (1126 + 1001)) and v9.Cast(v83.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v137 = 2 + 0;
			end
		end
	end
	local function v123()
		local v138 = 571 - (47 + 524);
		while true do
			if (((2 + 1) == v138) or ((5297 - 3359) == (3758 - 1244))) then
				if (((9704 - 5449) >= (1781 - (1165 + 561))) and v83.SinisterStrike:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike)) then
					if (((90 + 2909) > (3580 - 2424)) and v9.Press(v83.SinisterStrike)) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((897 + 1453) > (1634 - (341 + 138))) and (v138 == (1 + 1))) then
				if (((8314 - 4285) <= (5179 - (89 + 237))) and v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and ((v97 >= ((3 - 2) + ((v21(v83.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v83.Broadside))) * (v83.FanTheHammer:TalentRank() + (1 - 0))))) or (v96 <= v21(v83.Ruthlessness:IsAvailable())))) then
					if (v9.Cast(v83.PistolShot, nil, not v16:IsSpellInRange(v83.PistolShot)) or ((1397 - (581 + 300)) > (4654 - (855 + 365)))) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((9609 - 5563) >= (991 + 2042)) and not v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and ((v101 > (1236.5 - (1030 + 205))) or (v97 <= (1 + 0 + v21(v15:BuffUp(v83.Broadside)))) or v83.QuickDraw:IsAvailable() or (v83.Audacity:IsAvailable() and v15:BuffDown(v83.AudacityBuff)))) then
					if (v9.Cast(v83.PistolShot, nil, not v16:IsSpellInRange(v83.PistolShot)) or ((2530 + 189) <= (1733 - (156 + 130)))) then
						return "Cast Pistol Shot";
					end
				end
				v138 = 6 - 3;
			end
			if ((v138 == (1 - 0)) or ((8466 - 4332) < (1035 + 2891))) then
				if ((v83.FanTheHammer:IsAvailable() and v83.Audacity:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and v15:BuffUp(v83.Opportunity) and v15:BuffDown(v83.AudacityBuff)) or ((96 + 68) >= (2854 - (10 + 59)))) then
					if (v9.Press(v83.PistolShot) or ((149 + 376) == (10386 - 8277))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((1196 - (671 + 492)) == (27 + 6)) and v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and ((v15:BuffStack(v83.Opportunity) >= (1221 - (369 + 846))) or (v15:BuffRemains(v83.Opportunity) < (1 + 1)))) then
					if (((2607 + 447) <= (5960 - (1036 + 909))) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v138 = 2 + 0;
			end
			if (((3140 - 1269) < (3585 - (11 + 192))) and ((0 + 0) == v138)) then
				if (((1468 - (135 + 40)) <= (5247 - 3081)) and v28 and v83.EchoingReprimand:IsReady()) then
					if (v9.Cast(v83.EchoingReprimand, v75, nil, not v16:IsSpellInRange(v83.EchoingReprimand)) or ((1555 + 1024) < (270 - 147))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v83.Ambush:IsCastable() and v83.HiddenOpportunity:IsAvailable() and v15:BuffUp(v83.AudacityBuff)) or ((1267 - 421) >= (2544 - (50 + 126)))) then
					if (v9.Press(v83.Ambush) or ((11171 - 7159) <= (744 + 2614))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v138 = 1414 - (1233 + 180);
			end
		end
	end
	local function v124()
		local v139 = 969 - (522 + 447);
		while true do
			if (((2915 - (107 + 1314)) <= (1395 + 1610)) and (v139 == (15 - 10))) then
				if ((not v15:AffectingCombat() and not v15:IsMounted() and v58) or ((1322 + 1789) == (4237 - 2103))) then
					local v174 = 0 - 0;
					while true do
						if (((4265 - (716 + 1194)) == (41 + 2314)) and (v174 == (0 + 0))) then
							v93 = v82.Stealth(v83.Stealth2, nil);
							if (v93 or ((1091 - (74 + 429)) <= (833 - 401))) then
								return "Stealth (OOC): " .. v93;
							end
							break;
						end
					end
				end
				if (((2378 + 2419) >= (8916 - 5021)) and not v15:AffectingCombat() and (v83.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(24 - 16) and v26) then
					if (((8843 - 5266) == (4010 - (279 + 154))) and v81.TargetIsValid() and v16:IsInRange(788 - (454 + 324)) and not (v15:IsChanneling() or v15:IsCasting())) then
						local v180 = 0 + 0;
						while true do
							if (((3811 - (12 + 5)) > (1992 + 1701)) and (v180 == (2 - 1))) then
								if (v81.TargetIsValid() or ((472 + 803) == (5193 - (277 + 816)))) then
									local v187 = 0 - 0;
									while true do
										if ((v187 == (1185 - (1058 + 125))) or ((299 + 1292) >= (4555 - (815 + 160)))) then
											if (((4217 - 3234) <= (4291 - 2483)) and v83.SinisterStrike:IsCastable()) then
												if (v9.Cast(v83.SinisterStrike, nil, nil, not v16:IsSpellInRange(v83.SinisterStrike)) or ((513 + 1637) <= (3498 - 2301))) then
													return "Cast Sinister Strike (Opener)";
												end
											end
											break;
										end
										if (((5667 - (41 + 1857)) >= (3066 - (1222 + 671))) and (v187 == (2 - 1))) then
											if (((2134 - 649) == (2667 - (229 + 953))) and v83.SliceandDice:IsReady() and (v15:BuffRemains(v83.SliceandDice) < (((1775 - (1111 + 663)) + v96) * (1580.8 - (874 + 705))))) then
												if (v9.Press(v83.SliceandDice) or ((465 + 2850) <= (1899 + 883))) then
													return "Cast Slice and Dice (Opener)";
												end
											end
											if (v15:StealthUp(true, false) or ((1820 - 944) >= (84 + 2880))) then
												v93 = v121();
												if (v93 or ((2911 - (642 + 37)) > (570 + 1927))) then
													return "Stealth (Opener): " .. v93;
												end
												if ((v83.KeepItRolling:IsAvailable() and v83.GhostlyStrike:IsReady() and v83.EchoingReprimand:IsAvailable()) or ((338 + 1772) <= (833 - 501))) then
													if (((4140 - (233 + 221)) > (7334 - 4162)) and v9.Cast(v83.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v83.GhostlyStrike))) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if ((v83.Ambush:IsCastable() and v83.HiddenOpportunity:IsAvailable()) or ((3938 + 536) < (2361 - (718 + 823)))) then
													if (((2693 + 1586) >= (3687 - (266 + 539))) and v11(v83.Ambush, nil, nil, not v16:IsSpellInRange(v83.Ambush))) then
														return "Cast Ambush (Opener)";
													end
												elseif (v83.SinisterStrike:IsCastable() or ((5744 - 3715) >= (4746 - (636 + 589)))) then
													if (v11(v83.SinisterStrike, nil, nil, not v16:IsSpellInRange(v83.SinisterStrike)) or ((4835 - 2798) >= (9573 - 4931))) then
														return "Cast Sinister Strike (Opener)";
													end
												end
											elseif (((1364 + 356) < (1620 + 2838)) and v113()) then
												local v203 = 1015 - (657 + 358);
												while true do
													if ((v203 == (0 - 0)) or ((993 - 557) > (4208 - (1151 + 36)))) then
														v93 = v122();
														if (((689 + 24) <= (223 + 624)) and v93) then
															return "Finish (Opener): " .. v93;
														end
														break;
													end
												end
											end
											v187 = 5 - 3;
										end
										if (((3986 - (1552 + 280)) <= (4865 - (64 + 770))) and (v187 == (0 + 0))) then
											if (((10476 - 5861) == (820 + 3795)) and v83.RolltheBones:IsReady() and not v15:DebuffUp(v83.Dreadblades) and ((v110() == (1243 - (157 + 1086))) or v112())) then
												if (v9.Cast(v83.RolltheBones) or ((7586 - 3796) == (2189 - 1689))) then
													return "Cast Roll the Bones (Opener)";
												end
											end
											if (((135 - 46) < (301 - 80)) and v83.AdrenalineRush:IsReady() and v83.ImprovedAdrenalineRush:IsAvailable() and (v96 <= (821 - (599 + 220)))) then
												if (((4090 - 2036) >= (3352 - (1813 + 118))) and v9.Cast(v83.AdrenalineRush)) then
													return "Cast Adrenaline Rush (Opener)";
												end
											end
											v187 = 1 + 0;
										end
									end
								end
								return;
							end
							if (((1909 - (841 + 376)) < (4284 - 1226)) and (v180 == (0 + 0))) then
								if ((v83.BladeFlurry:IsReady() and v15:BuffDown(v83.BladeFlurry) and v83.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v83.AdrenalineRush:IsReady() or v15:BuffUp(v83.AdrenalineRush))) or ((8881 - 5627) == (2514 - (464 + 395)))) then
									if (v11(v83.BladeFlurry) or ((3326 - 2030) == (2358 + 2552))) then
										return "Blade Flurry (Opener)";
									end
								end
								if (((4205 - (467 + 370)) == (6959 - 3591)) and not v15:StealthUp(true, false)) then
									local v188 = 0 + 0;
									while true do
										if (((9060 - 6417) < (596 + 3219)) and (v188 == (0 - 0))) then
											v93 = v82.Stealth(v82.StealthSpell());
											if (((2433 - (150 + 370)) > (1775 - (74 + 1208))) and v93) then
												return v93;
											end
											break;
										end
									end
								end
								v180 = 2 - 1;
							end
						end
					end
				end
				if (((22550 - 17795) > (2440 + 988)) and v83.FanTheHammer:IsAvailable() and (v83.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
					v96 = v25(v96, v82.FanTheHammerCP());
				end
				if (((1771 - (14 + 376)) <= (4108 - 1739)) and v81.TargetIsValid()) then
					local v175 = 0 + 0;
					while true do
						if ((v175 == (1 + 0)) or ((4619 + 224) == (11966 - 7882))) then
							v93 = v123();
							if (((3513 + 1156) > (441 - (23 + 55))) and v93) then
								return "Build: " .. v93;
							end
							if ((v83.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike) and (v100 > ((35 - 20) + v99))) or ((1253 + 624) >= (2818 + 320))) then
								if (((7352 - 2610) >= (1141 + 2485)) and v9.Cast(v83.ArcaneTorrent, v29)) then
									return "Cast Arcane Torrent";
								end
							end
							if ((v83.ArcanePulse:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike)) or ((5441 - (652 + 249)) == (2451 - 1535))) then
								if (v9.Cast(v83.ArcanePulse) or ((3024 - (708 + 1160)) > (11794 - 7449))) then
									return "Cast Arcane Pulse";
								end
							end
							v175 = 3 - 1;
						end
						if (((2264 - (10 + 17)) < (955 + 3294)) and ((1734 - (1400 + 332)) == v175)) then
							if ((v83.LightsJudgment:IsCastable() and v16:IsInMeleeRange(9 - 4)) or ((4591 - (242 + 1666)) < (10 + 13))) then
								if (((256 + 441) <= (704 + 122)) and v9.Cast(v83.LightsJudgment, v29)) then
									return "Cast Lights Judgment";
								end
							end
							if (((2045 - (850 + 90)) <= (2059 - 883)) and v83.BagofTricks:IsCastable() and v16:IsInMeleeRange(1395 - (360 + 1030))) then
								if (((2991 + 388) <= (10759 - 6947)) and v9.Cast(v83.BagofTricks, v29)) then
									return "Cast Bag of Tricks";
								end
							end
							if ((v83.PistolShot:IsCastable() and v16:IsSpellInRange(v83.PistolShot) and not v16:IsInRange(v94) and not v15:StealthUp(true, true) and (v100 < (33 - 8)) and ((v97 >= (1662 - (909 + 752))) or (v101 <= (1224.2 - (109 + 1114))))) or ((1442 - 654) >= (630 + 986))) then
								if (((2096 - (6 + 236)) <= (2129 + 1250)) and v9.Cast(v83.PistolShot)) then
									return "Cast Pistol Shot (OOR)";
								end
							end
							if (((3662 + 887) == (10727 - 6178)) and v83.SinisterStrike:IsCastable()) then
								if (v9.Cast(v83.SinisterStrike) or ((5278 - 2256) >= (4157 - (1076 + 57)))) then
									return "Cast Sinister Strike Filler";
								end
							end
							break;
						end
						if (((793 + 4027) > (2887 - (579 + 110))) and ((0 + 0) == v175)) then
							v93 = v120();
							if (v93 or ((939 + 122) >= (2596 + 2295))) then
								return "CDs: " .. v93;
							end
							if (((1771 - (174 + 233)) <= (12494 - 8021)) and (v15:StealthUp(true, true) or v15:BuffUp(v83.Shadowmeld))) then
								local v184 = 0 - 0;
								while true do
									if ((v184 == (0 + 0)) or ((4769 - (663 + 511)) <= (3 + 0))) then
										v93 = v121();
										if (v93 or ((1015 + 3657) == (11875 - 8023))) then
											return "Stealth: " .. v93;
										end
										break;
									end
								end
							end
							if (((945 + 614) == (3670 - 2111)) and v113()) then
								v93 = v122();
								if (v93 or ((4240 - 2488) <= (377 + 411))) then
									return "Finish: " .. v93;
								end
							end
							v175 = 1 - 0;
						end
					end
				end
				break;
			end
			if ((v139 == (2 + 0)) or ((358 + 3549) == (899 - (478 + 244)))) then
				v98 = v107();
				v99 = v15:EnergyRegen();
				v101 = v106(v102);
				v100 = v15:EnergyDeficitPredicted(nil, v102);
				v139 = 520 - (440 + 77);
			end
			if (((1578 + 1892) > (2031 - 1476)) and (v139 == (1559 - (655 + 901)))) then
				if (v27 or ((181 + 791) == (494 + 151))) then
					local v176 = 0 + 0;
					while true do
						if (((12819 - 9637) >= (3560 - (695 + 750))) and (v176 == (0 - 0))) then
							v90 = v15:GetEnemiesInRange(46 - 16);
							v91 = v15:GetEnemiesInRange(v94);
							v176 = 3 - 2;
						end
						if (((4244 - (285 + 66)) < (10324 - 5895)) and (v176 == (1311 - (682 + 628)))) then
							v92 = #v91;
							break;
						end
					end
				else
					v92 = 1 + 0;
				end
				v93 = v82.CrimsonVial();
				if (v93 or ((3166 - (176 + 123)) < (797 + 1108))) then
					return v93;
				end
				v82.Poisons();
				v139 = 3 + 1;
			end
			if ((v139 == (273 - (239 + 30))) or ((489 + 1307) >= (3894 + 157))) then
				if (((2865 - 1246) <= (11717 - 7961)) and v31 and (v15:HealthPercentage() <= v33)) then
					if (((919 - (306 + 9)) == (2107 - 1503)) and (v32 == "Refreshing Healing Potion")) then
						if (v84.RefreshingHealingPotion:IsReady() or ((780 + 3704) == (553 + 347))) then
							if (v9.Press(v85.RefreshingHealingPotion) or ((2147 + 2312) <= (3182 - 2069))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((5007 - (1140 + 235)) > (2163 + 1235)) and (v32 == "Dreamwalker's Healing Potion")) then
						if (((3744 + 338) <= (1262 + 3655)) and v84.DreamwalkersHealingPotion:IsReady()) then
							if (((4884 - (33 + 19)) >= (501 + 885)) and v9.Press(v85.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (((410 - 273) == (61 + 76)) and v83.Feint:IsCastable() and v83.Feint:IsReady() and (v15:HealthPercentage() <= v57)) then
					if (v9.Cast(v83.Feint) or ((3078 - 1508) >= (4063 + 269))) then
						return "Cast Feint (Defensives)";
					end
				end
				if ((v83.Evasion:IsCastable() and v83.Evasion:IsReady() and (v15:HealthPercentage() <= v79)) or ((4753 - (586 + 103)) <= (166 + 1653))) then
					if (v9.Cast(v83.Evasion) or ((15350 - 10364) < (3062 - (1309 + 179)))) then
						return "Cast Evasion (Defensives)";
					end
				end
				if (((7989 - 3563) > (75 + 97)) and not v15:IsCasting() and not v15:IsChanneling()) then
					local v177 = 0 - 0;
					local v178;
					while true do
						if (((443 + 143) > (966 - 511)) and ((1 - 0) == v177)) then
							v178 = v81.Interrupt(v83.Blind, 624 - (295 + 314), v78);
							if (((2028 - 1202) == (2788 - (1300 + 662))) and v178) then
								return v178;
							end
							v178 = v81.Interrupt(v83.Blind, 46 - 31, v78, v12, v85.BlindMouseover);
							if (v178 or ((5774 - (1178 + 577)) > (2307 + 2134))) then
								return v178;
							end
							v177 = 5 - 3;
						end
						if (((3422 - (851 + 554)) < (3768 + 493)) and (v177 == (0 - 0))) then
							v178 = v81.Interrupt(v83.Kick, 17 - 9, true);
							if (((5018 - (115 + 187)) > (62 + 18)) and v178) then
								return v178;
							end
							v178 = v81.Interrupt(v83.Kick, 8 + 0, true, v12, v85.KickMouseover);
							if (v178 or ((13819 - 10312) == (4433 - (160 + 1001)))) then
								return v178;
							end
							v177 = 1 + 0;
						end
						if ((v177 == (2 + 0)) or ((1792 - 916) >= (3433 - (237 + 121)))) then
							v178 = v81.InterruptWithStun(v83.CheapShot, 905 - (525 + 372), v15:StealthUp(false, false));
							if (((8250 - 3898) > (8391 - 5837)) and v178) then
								return v178;
							end
							v178 = v81.InterruptWithStun(v83.KidneyShot, 150 - (96 + 46), v15:ComboPoints() > (777 - (643 + 134)));
							if (v178 or ((1591 + 2815) < (9693 - 5650))) then
								return v178;
							end
							break;
						end
					end
				end
				v139 = 18 - 13;
			end
			if (((1 + 0) == v139) or ((3706 - 1817) >= (6914 - 3531))) then
				v96 = v15:ComboPoints();
				v95 = v82.EffectiveComboPoints(v96);
				v97 = v15:ComboPointsDeficit();
				v102 = (v15:BuffUp(v83.AdrenalineRush, nil, true) and -(769 - (316 + 403))) or (0 + 0);
				v139 = 5 - 3;
			end
			if (((684 + 1208) <= (6885 - 4151)) and (v139 == (0 + 0))) then
				v80();
				v26 = EpicSettings.Toggles['ooc'];
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v139 = 1 + 0;
			end
		end
	end
	local function v125()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(900 - 640, v124, v125);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

