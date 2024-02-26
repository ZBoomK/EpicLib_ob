local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4143 - (317 + 115)) < (2026 - 1018))) then
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
			if ((v126 == (0 + 0)) or ((1875 - (802 + 24)) <= (1562 - 656))) then
				v29 = EpicSettings.Settings['UseRacials'];
				v31 = EpicSettings.Settings['UseHealingPotion'];
				v32 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v33 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v126 = 1 + 0;
			end
			if (((742 + 3771) > (589 + 2137)) and (v126 == (16 - 10))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				v78 = EpicSettings.Settings['BlindInterrupt'] or (0 - 0);
				v126 = 3 + 4;
			end
			if ((v126 == (3 + 2)) or ((1222 + 259) >= (1933 + 725))) then
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v126 = 3 + 3;
			end
			if (((1437 - (797 + 636)) == v126) or ((15634 - 12414) == (2983 - (1427 + 192)))) then
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'] or (0 + 0);
				v126 = 11 - 6;
			end
			if ((v126 == (2 + 0)) or ((478 + 576) > (3718 - (192 + 134)))) then
				v38 = EpicSettings.Settings['InterruptThreshold'] or (1276 - (316 + 960));
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v126 = 2 + 1;
			end
			if ((v126 == (6 + 1)) or ((625 + 51) >= (6277 - 4635))) then
				v79 = EpicSettings.Settings['EvasionHP'] or (551 - (83 + 468));
				break;
			end
			if (((5942 - (1202 + 604)) > (11189 - 8792)) and (v126 == (4 - 1))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v57 = EpicSettings.Settings['FeintHP'] or (325 - (45 + 280));
				v126 = 4 + 0;
			end
			if ((v126 == (1 + 0)) or ((1583 + 2751) == (2350 + 1895))) then
				v34 = EpicSettings.Settings['UseHealthstone'];
				v35 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v36 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1911 - (340 + 1571));
				v126 = 1 + 1;
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
	local v88 = (v87[1785 - (1733 + 39)] and v19(v87[35 - 22])) or v19(1034 - (125 + 909));
	local v89 = (v87[1962 - (1096 + 852)] and v19(v87[7 + 7])) or v19(0 - 0);
	v9:RegisterForEvent(function()
		local v127 = 0 + 0;
		while true do
			if (((512 - (409 + 103)) == v127) or ((4512 - (46 + 190)) <= (3126 - (51 + 44)))) then
				v87 = v15:GetEquipment();
				v88 = (v87[4 + 9] and v19(v87[1330 - (1114 + 203)])) or v19(726 - (228 + 498));
				v127 = 1 + 0;
			end
			if ((v127 == (1 + 0)) or ((5445 - (174 + 489)) <= (3123 - 1924))) then
				v89 = (v87[1919 - (830 + 1075)] and v19(v87[538 - (303 + 221)])) or v19(1269 - (231 + 1038));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v83.Dispatch:RegisterDamageFormula(function()
		return v15:AttackPowerDamageMod() * v82.CPSpend() * (0.3 + 0) * (1163 - (171 + 991)) * ((4 - 3) + (v15:VersatilityDmgPct() / (268 - 168))) * ((v16:DebuffUp(v83.GhostlyStrike) and (2.1 - 1)) or (1 + 0));
	end);
	local v90, v91, v92;
	local v93;
	local v94;
	local v95, v96, v97;
	local v98, v99, v100, v101, v102;
	local v103 = {{v83.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v104, v105 = 1248 - (111 + 1137), 158 - (91 + 67);
	local function v106(v128)
		local v129 = v15:EnergyTimeToMaxPredicted(nil, v128);
		if ((v129 < v104) or ((v129 - v104) > (0.5 - 0)) or ((1214 + 3650) < (2425 - (423 + 100)))) then
			v104 = v129;
		end
		return v104;
	end
	local function v107()
		local v130 = 0 + 0;
		local v131;
		while true do
			if (((13398 - 8559) >= (1929 + 1771)) and (v130 == (771 - (326 + 445)))) then
				v131 = v15:EnergyPredicted();
				if ((v131 > v105) or ((v131 - v105) > (39 - 30)) or ((2394 - 1319) > (4476 - 2558))) then
					v105 = v131;
				end
				v130 = 712 - (530 + 181);
			end
			if (((1277 - (614 + 267)) <= (3836 - (19 + 13))) and ((1 - 0) == v130)) then
				return v105;
			end
		end
	end
	local v108 = {v83.Broadside,v83.BuriedTreasure,v83.GrandMelee,v83.RuthlessPrecision,v83.SkullandCrossbones,v83.TrueBearing};
	local function v109(v132, v133)
		local v134 = 0 - 0;
		local v135;
		while true do
			if ((v134 == (2 - 1)) or ((7971 - 3802) == (9430 - 7243))) then
				v135 = table.concat(v133);
				if (((3311 - 1905) == (745 + 661)) and (v132 == "All")) then
					if (((313 + 1218) < (9923 - 5652)) and not v10.APLVar.RtB_List[v132][v135]) then
						local v181 = 0 + 0;
						for v186 = 1 + 0, #v133 do
							if (((397 + 238) == (1731 - (709 + 387))) and v15:BuffUp(v108[v133[v186]])) then
								v181 = v181 + (1859 - (673 + 1185));
							end
						end
						v10.APLVar.RtB_List[v132][v135] = ((v181 == #v133) and true) or false;
					end
				elseif (((9782 - 6409) <= (11418 - 7862)) and not v10.APLVar.RtB_List[v132][v135]) then
					v10.APLVar.RtB_List[v132][v135] = false;
					for v187 = 1 - 0, #v133 do
						if (v15:BuffUp(v108[v133[v187]]) or ((2354 + 937) < (2451 + 829))) then
							v10.APLVar.RtB_List[v132][v135] = true;
							break;
						end
					end
				end
				v134 = 2 - 0;
			end
			if (((1078 + 3308) >= (1740 - 867)) and (v134 == (3 - 1))) then
				return v10.APLVar.RtB_List[v132][v135];
			end
			if (((2801 - (446 + 1434)) <= (2385 - (1040 + 243))) and (v134 == (0 - 0))) then
				if (((6553 - (559 + 1288)) >= (2894 - (609 + 1322))) and not v10.APLVar.RtB_List) then
					v10.APLVar.RtB_List = {};
				end
				if (not v10.APLVar.RtB_List[v132] or ((1414 - (13 + 441)) <= (3273 - 2397))) then
					v10.APLVar.RtB_List[v132] = {};
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v110()
		if (not v10.APLVar.RtB_Buffs or ((10289 - 8223) == (35 + 897))) then
			local v146 = 0 - 0;
			local v147;
			while true do
				if (((1714 + 3111) < (2123 + 2720)) and (v146 == (5 - 3))) then
					v10.APLVar.RtB_Buffs.Longer = 0 + 0;
					v147 = v82.RtBRemains();
					v146 = 4 - 1;
				end
				if ((v146 == (1 + 0)) or ((2157 + 1720) >= (3260 + 1277))) then
					v10.APLVar.RtB_Buffs.Normal = 0 + 0;
					v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
					v146 = 435 - (153 + 280);
				end
				if ((v146 == (0 - 0)) or ((3875 + 440) < (682 + 1044))) then
					v10.APLVar.RtB_Buffs = {};
					v10.APLVar.RtB_Buffs.Total = 0 + 0;
					v146 = 1 + 0;
				end
				if ((v146 == (3 + 0)) or ((5601 - 1922) < (387 + 238))) then
					for v179 = 668 - (89 + 578), #v108 do
						local v180 = v15:BuffRemains(v108[v179]);
						if ((v180 > (0 + 0)) or ((9614 - 4989) < (1681 - (572 + 477)))) then
							v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
							if ((v180 == v147) or ((50 + 33) > (213 + 1567))) then
								v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (87 - (84 + 2));
							elseif (((899 - 353) <= (776 + 301)) and (v180 > v147)) then
								v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (843 - (497 + 345));
							else
								v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + 1 + 0;
							end
						end
					end
					break;
				end
			end
		end
		return v10.APLVar.RtB_Buffs.Total;
	end
	local function v111()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (1333 - (605 + 728))) or ((711 + 285) > (9562 - 5261))) then
				if (((187 + 3883) > (2539 - 1852)) and not v10.APLVar.RtB_Reroll) then
					if ((v63 == "1+ Buff") or ((592 + 64) >= (9226 - 5896))) then
						v10.APLVar.RtB_Reroll = ((v110() <= (0 + 0)) and true) or false;
					elseif ((v63 == "Broadside") or ((2981 - (457 + 32)) <= (143 + 192))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.Broadside) and true) or false;
					elseif (((5724 - (832 + 570)) >= (2414 + 148)) and (v63 == "Buried Treasure")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.BuriedTreasure) and true) or false;
					elseif ((v63 == "Grand Melee") or ((949 + 2688) >= (13341 - 9571))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((1146 + 1233) > (5374 - (588 + 208)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.SkullandCrossbones) and true) or false;
					elseif ((v63 == "Ruthless Precision") or ((1301 - 818) > (2543 - (884 + 916)))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.RuthlessPrecision) and true) or false;
					elseif (((5137 - 2683) > (336 + 242)) and (v63 == "True Bearing")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v83.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v110();
						if (((1583 - (232 + 421)) < (6347 - (1569 + 320))) and (v110() <= (1 + 1)) and v15:BuffUp(v83.BuriedTreasure) and v15:BuffDown(v83.GrandMelee) and (v92 < (1 + 1))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((2230 - 1568) <= (1577 - (316 + 289))) and v83.Crackshot:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and not v15:HasTier(81 - 50, 1 + 3) and ((not v15:BuffUp(v83.TrueBearing) and v83.HiddenOpportunity:IsAvailable()) or (not v15:BuffUp(v83.Broadside) and not v83.HiddenOpportunity:IsAvailable())) and (v110() <= (1454 - (666 + 787)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (((4795 - (360 + 65)) == (4085 + 285)) and v83.Crackshot:IsAvailable() and v15:HasTier(285 - (79 + 175), 5 - 1) and (v110() <= (1 + 0 + v21(v15:BuffUp(v83.LoadedDiceBuff))))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((not v83.Crackshot:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and not v15:BuffUp(v83.SkullandCrossbones) and (v110() < ((5 - 3) + v21(v15:BuffUp(v83.GrandMelee)))) and (v92 < (3 - 1))) or ((5661 - (503 + 396)) <= (1042 - (92 + 89)))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if ((v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 - 0)) or (v10.APLVar.RtB_Buffs.Normal == (0 + 0))) and (v10.APLVar.RtB_Buffs.Longer >= (1 + 0)) and (v110() < (19 - 14)) and (v82.RtBRemains() <= (6 + 33)) and not v15:StealthUp(true, true)) or ((3219 - 1807) == (3721 + 543))) then
							v10.APLVar.RtB_Reroll = true;
						end
						if (v16:FilteredTimeToDie("<", 6 + 6) or v9.BossFilteredFightRemains("<", 36 - 24) or ((396 + 2772) < (3283 - 1130))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v112()
		return v95 >= ((v82.CPMaxSpend() - (1245 - (485 + 759))) - v21((v15:StealthUp(true, true)) and v83.Crackshot:IsAvailable()));
	end
	local function v113()
		return (v83.HiddenOpportunity:IsAvailable() or (v97 >= ((4 - 2) + v21(v83.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v83.Broadside))))) and (v98 >= (1239 - (442 + 747)));
	end
	local function v114()
		return not v27 or (v92 < (1137 - (832 + 303))) or (v15:BuffRemains(v83.BladeFlurry) > ((947 - (88 + 858)) + v21(v83.KillingSpree:IsAvailable())));
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
		if ((v83.Vanish:IsCastable() and v83.Vanish:IsReady() and v115() and v83.HiddenOpportunity:IsAvailable() and not v83.Crackshot:IsAvailable() and not v15:BuffUp(v83.Audacity) and (v116() or (v15:BuffStack(v83.Opportunity) < (5 + 1))) and v113()) or ((205 + 4771) < (2121 - (766 + 23)))) then
			if (((22847 - 18219) == (6329 - 1701)) and v9.Cast(v83.Vanish, v66)) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v83.Vanish:IsCastable() and v83.Vanish:IsReady() and v115() and (not v83.HiddenOpportunity:IsAvailable() or v83.Crackshot:IsAvailable()) and v112()) or ((141 - 87) == (1340 - 945))) then
			if (((1155 - (1036 + 37)) == (59 + 23)) and v9.Cast(v83.Vanish, v66)) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v83.ShadowDance:IsReady() and v83.Crackshot:IsAvailable() and v112() and ((v83.Vanish:CooldownRemains() >= (11 - 5)) or not v66) and not v15:StealthUp(true, false)) or ((458 + 123) < (1762 - (641 + 839)))) then
			if (v9.Cast(v83.ShadowDance, v52) or ((5522 - (910 + 3)) < (6360 - 3865))) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if (((2836 - (1466 + 218)) == (530 + 622)) and v83.ShadowDance:IsAvailable() and v83.ShadowDance:IsCastable() and not v83.KeepItRolling:IsAvailable() and v117() and v15:BuffUp(v83.SliceandDice) and (v112() or v83.HiddenOpportunity:IsAvailable()) and (not v83.HiddenOpportunity:IsAvailable() or not v83.Vanish:IsReady())) then
			if (((3044 - (556 + 592)) <= (1217 + 2205)) and v9.Cast(v83.ShadowDance, v52)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v83.ShadowDance:IsAvailable() and v83.ShadowDance:IsCastable() and v83.KeepItRolling:IsAvailable() and v117() and ((v83.KeepItRolling:CooldownRemains() <= (838 - (329 + 479))) or ((v83.KeepItRolling:CooldownRemains() >= (974 - (174 + 680))) and (v112() or v83.HiddenOpportunity:IsAvailable())))) or ((3401 - 2411) > (3357 - 1737))) then
			if (v9.Cast(v83.ShadowDance, v52) or ((627 + 250) > (5434 - (396 + 343)))) then
				return "Cast Shadow Dance";
			end
		end
		if (((239 + 2452) >= (3328 - (29 + 1448))) and v83.Shadowmeld:IsAvailable() and v83.Shadowmeld:IsReady()) then
			if ((v83.Crackshot:IsAvailable() and v112()) or (not v83.Crackshot:IsAvailable() and ((v83.CountTheOdds:IsAvailable() and v112()) or v83.HiddenOpportunity:IsAvailable())) or ((4374 - (135 + 1254)) >= (18293 - 13437))) then
				if (((19965 - 15689) >= (797 + 398)) and v9.Cast(v83.Shadowmeld, v29)) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v119()
		local v137 = v81.HandleTopTrinket(v86, v28, 1567 - (389 + 1138), nil);
		if (((3806 - (102 + 472)) <= (4426 + 264)) and v137) then
			return v137;
		end
		local v137 = v81.HandleBottomTrinket(v86, v28, 23 + 17, nil);
		if (v137 or ((836 + 60) >= (4691 - (320 + 1225)))) then
			return v137;
		end
	end
	local function v120()
		local v138 = v81.HandleDPSPotion(v15:BuffUp(v83.AdrenalineRush));
		if (((5448 - 2387) >= (1810 + 1148)) and v138) then
			return "DPS Pot";
		end
		if (((4651 - (157 + 1307)) >= (2503 - (821 + 1038))) and v28 and v83.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v83.AdrenalineRush) and (not v112() or not v83.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v83.Crackshot:IsAvailable() and v83.ImprovedAdrenalineRush:IsAvailable() and (v96 <= (4 - 2))))) then
			if (((71 + 573) <= (1250 - 546)) and v11(v83.AdrenalineRush, v74)) then
				return "Cast Adrenaline Rush";
			end
		end
		if (((357 + 601) > (2346 - 1399)) and v83.BladeFlurry:IsReady()) then
			if (((5518 - (834 + 192)) >= (169 + 2485)) and (v92 >= ((1 + 1) - v21(v83.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v83.AdrenalineRush)))) and (v15:BuffRemains(v83.BladeFlurry) < v15:GCD())) then
				if (((74 + 3368) >= (2328 - 825)) and v11(v83.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (v83.BladeFlurry:IsReady() or ((3474 - (300 + 4)) <= (391 + 1073))) then
			if ((v83.DeftManeuvers:IsAvailable() and not v112() and (((v92 >= (7 - 4)) and (v97 == (v92 + v21(v15:BuffUp(v83.Broadside))))) or (v92 >= (367 - (112 + 250))))) or ((1913 + 2884) == (10992 - 6604))) then
				if (((316 + 235) <= (353 + 328)) and v11(v83.BladeFlurry)) then
					return "Cast Blade Flurry";
				end
			end
		end
		if (((2451 + 826) > (202 + 205)) and v83.RolltheBones:IsReady()) then
			if (((3488 + 1207) >= (2829 - (1001 + 413))) and ((v111() and not v15:StealthUp(true, true)) or (v110() == (0 - 0)) or ((v82.RtBRemains() <= (885 - (244 + 638))) and v15:HasTier(724 - (627 + 66), 11 - 7)) or ((v82.RtBRemains() <= (609 - (512 + 90))) and ((v83.ShadowDance:CooldownRemains() <= (1909 - (1665 + 241))) or (v83.Vanish:CooldownRemains() <= (720 - (373 + 344)))) and not v15:StealthUp(true, true)))) then
				if (v11(v83.RolltheBones) or ((1449 + 1763) <= (250 + 694))) then
					return "Cast Roll the Bones";
				end
			end
		end
		local v139 = v119();
		if (v139 or ((8166 - 5070) <= (3042 - 1244))) then
			return v139;
		end
		if (((4636 - (35 + 1064)) == (2574 + 963)) and v83.KeepItRolling:IsReady() and not v111() and (v110() >= ((6 - 3) + v21(v15:HasTier(1 + 30, 1240 - (298 + 938))))) and (v15:BuffDown(v83.ShadowDance) or (v110() >= (1265 - (233 + 1026))))) then
			if (((5503 - (636 + 1030)) >= (803 + 767)) and v9.Cast(v83.KeepItRolling)) then
				return "Cast Keep it Rolling";
			end
		end
		if ((v83.GhostlyStrike:IsAvailable() and v83.GhostlyStrike:IsReady() and (v95 < (7 + 0))) or ((877 + 2073) == (258 + 3554))) then
			if (((4944 - (55 + 166)) >= (450 + 1868)) and v11(v83.GhostlyStrike, v71, nil, not v16:IsSpellInRange(v83.GhostlyStrike))) then
				return "Cast Ghostly Strike";
			end
		end
		if ((v28 and v83.Sepsis:IsAvailable() and v83.Sepsis:IsReady()) or ((204 + 1823) > (10891 - 8039))) then
			if ((v83.Crackshot:IsAvailable() and v83.BetweentheEyes:IsReady() and v112() and not v15:StealthUp(true, true)) or (not v83.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 308 - (36 + 261)) and v15:BuffUp(v83.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 19 - 8) or ((2504 - (34 + 1334)) > (1660 + 2657))) then
				if (((3690 + 1058) == (6031 - (1035 + 248))) and v9.Cast(v83.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((3757 - (20 + 1)) <= (2470 + 2270)) and v83.BladeRush:IsReady() and (v101 > (323 - (134 + 185))) and not v15:StealthUp(true, true)) then
			if (v9.Cast(v83.BladeRush) or ((4523 - (549 + 584)) <= (3745 - (314 + 371)))) then
				return "Cast Blade Rush";
			end
		end
		if ((not v15:StealthUp(true, true) and (not v83.Crackshot:IsAvailable() or v83.BetweentheEyes:IsReady())) or ((3429 - 2430) > (3661 - (478 + 490)))) then
			local v148 = 0 + 0;
			while true do
				if (((1635 - (786 + 386)) < (1946 - 1345)) and (v148 == (1379 - (1055 + 324)))) then
					v139 = v118();
					if (v139 or ((3523 - (1093 + 247)) < (611 + 76))) then
						return v139;
					end
					break;
				end
			end
		end
		if (((479 + 4070) == (18060 - 13511)) and v28 and v83.ThistleTea:IsAvailable() and v83.ThistleTea:IsCastable() and not v15:BuffUp(v83.ThistleTea) and ((v100 >= (339 - 239)) or v9.BossFilteredFightRemains("<", v83.ThistleTea:Charges() * (16 - 10)))) then
			if (((11740 - 7068) == (1662 + 3010)) and v9.Cast(v83.ThistleTea)) then
				return "Cast Thistle Tea";
			end
		end
		if (v83.BloodFury:IsCastable() or ((14130 - 10462) < (1361 - 966))) then
			if (v9.Cast(v83.BloodFury, v29) or ((3142 + 1024) == (1163 - 708))) then
				return "Cast Blood Fury";
			end
		end
		if (v83.Berserking:IsCastable() or ((5137 - (364 + 324)) == (7299 - 4636))) then
			if (v9.Cast(v83.Berserking, v29) or ((10263 - 5986) < (991 + 1998))) then
				return "Cast Berserking";
			end
		end
		if (v83.Fireblood:IsCastable() or ((3640 - 2770) >= (6644 - 2495))) then
			if (((6717 - 4505) < (4451 - (1249 + 19))) and v9.Cast(v83.Fireblood, v29)) then
				return "Cast Fireblood";
			end
		end
		if (((4194 + 452) > (11646 - 8654)) and v83.AncestralCall:IsCastable()) then
			if (((2520 - (686 + 400)) < (2437 + 669)) and v9.Cast(v83.AncestralCall, v29)) then
				return "Cast Ancestral Call";
			end
		end
	end
	local function v121()
		local v140 = 229 - (73 + 156);
		while true do
			if (((4 + 782) < (3834 - (721 + 90))) and (v140 == (0 + 0))) then
				if ((v83.BladeFlurry:IsReady() and v83.BladeFlurry:IsCastable() and v27 and v83.Subterfuge:IsAvailable() and (v92 >= (6 - 4)) and (v15:BuffRemains(v83.BladeFlurry) <= v15:GCDRemains())) or ((2912 - (224 + 246)) < (119 - 45))) then
					if (((8350 - 3815) == (823 + 3712)) and v69) then
						if (v9.Press(v83.BladeFlurry, not v16:IsInMeleeRange(1 + 9)) or ((2211 + 798) <= (4185 - 2080))) then
							return "Cast Blade Flurry";
						end
					elseif (((6089 - 4259) < (4182 - (203 + 310))) and v9.Press(v83.BladeFlurry, not v16:IsInMeleeRange(2003 - (1238 + 755)))) then
						return "Cast Blade Flurry";
					end
				end
				if ((v83.ColdBlood:IsCastable() and v15:BuffDown(v83.ColdBlood) and v16:IsSpellInRange(v83.Dispatch) and v112()) or ((100 + 1330) >= (5146 - (709 + 825)))) then
					if (((4943 - 2260) >= (3583 - 1123)) and v9.Cast(v83.ColdBlood)) then
						return "Cast Cold Blood";
					end
				end
				v140 = 865 - (196 + 668);
			end
			if ((v140 == (7 - 5)) or ((3736 - 1932) >= (4108 - (171 + 662)))) then
				if ((v83.PistolShot:IsCastable() and v16:IsSpellInRange(v83.PistolShot) and v83.Crackshot:IsAvailable() and (v83.FanTheHammer:TalentRank() >= (95 - (4 + 89))) and (v15:BuffStack(v83.Opportunity) >= (20 - 14)) and ((v15:BuffUp(v83.Broadside) and (v96 <= (1 + 0))) or v15:BuffUp(v83.GreenskinsWickersBuff))) or ((6223 - 4806) > (1424 + 2205))) then
					if (((6281 - (35 + 1451)) > (1855 - (28 + 1425))) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((6806 - (941 + 1052)) > (3419 + 146)) and v83.Ambush:IsCastable() and v16:IsSpellInRange(v83.Ambush) and v83.HiddenOpportunity:IsAvailable()) then
					if (((5426 - (822 + 692)) == (5584 - 1672)) and v9.Press(v83.Ambush)) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((1329 + 1492) <= (5121 - (45 + 252))) and (v140 == (1 + 0))) then
				if (((599 + 1139) <= (5342 - 3147)) and v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and v112() and v83.Crackshot:IsAvailable()) then
					if (((474 - (114 + 319)) <= (4332 - 1314)) and v9.Press(v83.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((2748 - 603) <= (2617 + 1487)) and v83.Dispatch:IsCastable() and v16:IsSpellInRange(v83.Dispatch) and v112()) then
					if (((4005 - 1316) < (10151 - 5306)) and v9.Press(v83.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v140 = 1965 - (556 + 1407);
			end
		end
	end
	local function v122()
		local v141 = 1206 - (741 + 465);
		while true do
			if ((v141 == (465 - (170 + 295))) or ((1224 + 1098) > (2409 + 213))) then
				if ((v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and not v83.Crackshot:IsAvailable() and ((v15:BuffRemains(v83.BetweentheEyes) < (9 - 5)) or v83.ImprovedBetweenTheEyes:IsAvailable() or v83.GreenskinsWickers:IsAvailable() or v15:HasTier(25 + 5, 3 + 1)) and v15:BuffDown(v83.GreenskinsWickers)) or ((2568 + 1966) == (3312 - (957 + 273)))) then
					if (v9.Press(v83.BetweentheEyes) or ((421 + 1150) > (748 + 1119))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v83.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v83.BetweentheEyes) and v83.Crackshot:IsAvailable() and (v83.Vanish:CooldownRemains() > (171 - 126)) and (v83.ShadowDance:CooldownRemains() > (39 - 24))) or ((8106 - 5452) >= (14835 - 11839))) then
					if (((5758 - (389 + 1391)) > (1321 + 783)) and v9.Press(v83.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				v141 = 1 + 0;
			end
			if (((6818 - 3823) > (2492 - (783 + 168))) and (v141 == (6 - 4))) then
				if (((3196 + 53) > (1264 - (309 + 2))) and v83.ColdBlood:IsCastable() and v15:BuffDown(v83.ColdBlood) and v16:IsSpellInRange(v83.Dispatch)) then
					if (v9.Cast(v83.ColdBlood, v54) or ((10051 - 6778) > (5785 - (1090 + 122)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v83.Dispatch:IsCastable() and v16:IsSpellInRange(v83.Dispatch)) or ((1022 + 2129) < (4312 - 3028))) then
					if (v9.Press(v83.Dispatch) or ((1267 + 583) == (2647 - (628 + 490)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if (((148 + 673) < (5256 - 3133)) and ((4 - 3) == v141)) then
				if (((1676 - (431 + 343)) < (4695 - 2370)) and v83.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v91, ">", v15:BuffRemains(v83.SliceandDice), true) or (v15:BuffRemains(v83.SliceandDice) == (0 - 0))) and (v15:BuffRemains(v83.SliceandDice) < ((1 + 0 + v96) * (1.8 + 0)))) then
					if (((2553 - (556 + 1139)) <= (2977 - (6 + 9))) and v9.Press(v83.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v83.KillingSpree:IsCastable() and v16:IsSpellInRange(v83.KillingSpree) and (v16:DebuffUp(v83.GhostlyStrike) or not v83.GhostlyStrike:IsAvailable())) or ((723 + 3223) < (660 + 628))) then
					if (v9.Cast(v83.KillingSpree) or ((3411 - (28 + 141)) == (220 + 347))) then
						return "Cast Killing Spree";
					end
				end
				v141 = 2 - 0;
			end
		end
	end
	local function v123()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1317 - (486 + 831))) or ((2204 - 1357) >= (4446 - 3183))) then
				if ((v28 and v83.EchoingReprimand:IsReady()) or ((426 + 1827) == (5852 - 4001))) then
					if (v9.Cast(v83.EchoingReprimand, v75, nil, not v16:IsSpellInRange(v83.EchoingReprimand)) or ((3350 - (668 + 595)) > (2135 + 237))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v83.Ambush:IsCastable() and v83.HiddenOpportunity:IsAvailable() and v15:BuffUp(v83.AudacityBuff)) or ((897 + 3548) < (11314 - 7165))) then
					if (v9.Press(v83.Ambush) or ((2108 - (23 + 267)) == (2029 - (1129 + 815)))) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v142 = 388 - (371 + 16);
			end
			if (((2380 - (1326 + 424)) < (4028 - 1901)) and (v142 == (7 - 5))) then
				if ((v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and ((v15:BuffStack(v83.Opportunity) >= (124 - (88 + 30))) or (v15:BuffRemains(v83.Opportunity) < (773 - (720 + 51))))) or ((4310 - 2372) == (4290 - (421 + 1355)))) then
					if (((7019 - 2764) >= (28 + 27)) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				if (((4082 - (286 + 797)) > (4225 - 3069)) and v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and (v97 > ((1 - 0) + (v21(v83.QuickDraw:IsAvailable()) * v83.FanTheHammer:TalentRank()))) and ((not v83.Vanish:IsReady() and not v83.ShadowDance:IsReady()) or v15:StealthUp(true, true) or not v83.Crackshot:IsAvailable() or (v83.FanTheHammer:TalentRank() <= (440 - (397 + 42))))) then
					if (((734 + 1616) > (1955 - (24 + 776))) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				v142 = 4 - 1;
			end
			if (((4814 - (222 + 563)) <= (10692 - 5839)) and (v142 == (3 + 0))) then
				if ((not v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity) and ((v101 > (191.5 - (23 + 167))) or (v97 <= ((1799 - (690 + 1108)) + v21(v15:BuffUp(v83.Broadside)))) or v83.QuickDraw:IsAvailable() or (v83.Audacity:IsAvailable() and v15:BuffDown(v83.AudacityBuff)))) or ((187 + 329) > (2833 + 601))) then
					if (((4894 - (40 + 808)) >= (500 + 2533)) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if ((v83.SinisterStrike:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike)) or ((10397 - 7678) <= (1384 + 63))) then
					if (v9.Press(v83.SinisterStrike) or ((2187 + 1947) < (2153 + 1773))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v142 == (572 - (47 + 524))) or ((107 + 57) >= (7612 - 4827))) then
				if ((v83.FanTheHammer:IsAvailable() and v83.Audacity:IsAvailable() and v83.HiddenOpportunity:IsAvailable() and v15:BuffUp(v83.Opportunity) and v15:BuffDown(v83.AudacityBuff)) or ((785 - 260) == (4809 - 2700))) then
					if (((1759 - (1165 + 561)) == (1 + 32)) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if (((9458 - 6404) <= (1532 + 2483)) and v15:BuffUp(v83.GreenskinsWickersBuff) and ((not v83.FanTheHammer:IsAvailable() and v15:BuffUp(v83.Opportunity)) or (v15:BuffRemains(v83.GreenskinsWickersBuff) < (480.5 - (341 + 138))))) then
					if (((506 + 1365) < (6979 - 3597)) and v9.Press(v83.PistolShot)) then
						return "Cast Pistol Shot (GSW Dump)";
					end
				end
				v142 = 328 - (89 + 237);
			end
		end
	end
	local function v124()
		v80();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v96 = v15:ComboPoints();
		v95 = v82.EffectiveComboPoints(v96);
		v97 = v15:ComboPointsDeficit();
		v102 = (v15:BuffUp(v83.AdrenalineRush, nil, true) and -(160 - 110)) or (0 - 0);
		v98 = v107();
		v99 = v15:EnergyRegen();
		v101 = v106(v102);
		v100 = v15:EnergyDeficitPredicted(nil, v102);
		if (((2174 - (581 + 300)) <= (3386 - (855 + 365))) and v27) then
			v90 = v15:GetEnemiesInRange(71 - 41);
			if (v83.AcrobaticStrikes:IsAvailable() or ((843 + 1736) < (1358 - (1030 + 205)))) then
				v91 = v15:GetEnemiesInRange(9 + 0);
			end
			if (not v83.AcrobaticStrikes:IsAvailable() or ((788 + 58) >= (2654 - (156 + 130)))) then
				v91 = v15:GetEnemiesInRange(13 - 7);
			end
			v92 = #v91;
		else
			v92 = 1 - 0;
		end
		v93 = v82.CrimsonVial();
		if (v93 or ((8216 - 4204) <= (885 + 2473))) then
			return v93;
		end
		v82.Poisons();
		if (((872 + 622) <= (3074 - (10 + 59))) and v31 and (v15:HealthPercentage() <= v33)) then
			if ((v32 == "Refreshing Healing Potion") or ((880 + 2231) == (10509 - 8375))) then
				if (((3518 - (671 + 492)) == (1875 + 480)) and v84.RefreshingHealingPotion:IsReady()) then
					if (v9.Press(v85.RefreshingHealingPotion) or ((1803 - (369 + 846)) <= (115 + 317))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((4094 + 703) >= (5840 - (1036 + 909))) and (v32 == "Dreamwalker's Healing Potion")) then
				if (((2844 + 733) == (6004 - 2427)) and v84.DreamwalkersHealingPotion:IsReady()) then
					if (((3997 - (11 + 192)) > (1867 + 1826)) and v9.Press(v85.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if ((v83.Feint:IsCastable() and v83.Feint:IsReady() and (v15:HealthPercentage() <= v57)) or ((1450 - (135 + 40)) == (9933 - 5833))) then
			if (v9.Cast(v83.Feint) or ((959 + 632) >= (7886 - 4306))) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((1473 - 490) <= (1984 - (50 + 126))) and v83.Evasion:IsCastable() and v83.Evasion:IsReady() and (v15:HealthPercentage() <= v79)) then
			if (v9.Cast(v83.Evasion) or ((5986 - 3836) <= (265 + 932))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((5182 - (1233 + 180)) >= (2142 - (522 + 447))) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v149 = 1421 - (107 + 1314);
			local v150;
			while true do
				if (((690 + 795) == (4524 - 3039)) and (v149 == (0 + 0))) then
					v150 = v81.Interrupt(v83.Kick, 15 - 7, true);
					if (v150 or ((13116 - 9801) <= (4692 - (716 + 1194)))) then
						return v150;
					end
					v150 = v81.Interrupt(v83.Kick, 1 + 7, true, v12, v85.KickMouseover);
					v149 = 1 + 0;
				end
				if ((v149 == (504 - (74 + 429))) or ((1689 - 813) >= (1470 + 1494))) then
					if (v150 or ((5108 - 2876) > (1767 + 730))) then
						return v150;
					end
					v150 = v81.Interrupt(v83.Blind, 45 - 30, v78);
					if (v150 or ((5217 - 3107) <= (765 - (279 + 154)))) then
						return v150;
					end
					v149 = 780 - (454 + 324);
				end
				if (((2900 + 786) > (3189 - (12 + 5))) and ((2 + 1) == v149)) then
					if (v150 or ((11399 - 6925) < (304 + 516))) then
						return v150;
					end
					v150 = v81.InterruptWithStun(v83.KidneyShot, 1101 - (277 + 816), v15:ComboPoints() > (0 - 0));
					if (((5462 - (1058 + 125)) >= (541 + 2341)) and v150) then
						return v150;
					end
					break;
				end
				if (((977 - (815 + 160)) == v149) or ((8705 - 6676) >= (8358 - 4837))) then
					v150 = v81.Interrupt(v83.Blind, 4 + 11, v78, v12, v85.BlindMouseover);
					if (v150 or ((5954 - 3917) >= (6540 - (41 + 1857)))) then
						return v150;
					end
					v150 = v81.InterruptWithStun(v83.CheapShot, 1901 - (1222 + 671), v15:StealthUp(false, false));
					v149 = 7 - 4;
				end
			end
		end
		if (((2472 - 752) < (5640 - (229 + 953))) and not v15:AffectingCombat() and not v15:IsMounted() and v58) then
			local v151 = 1774 - (1111 + 663);
			while true do
				if ((v151 == (1579 - (874 + 705))) or ((62 + 374) > (2062 + 959))) then
					v93 = v82.Stealth(v83.Stealth2, nil);
					if (((1481 - 768) <= (24 + 823)) and v93) then
						return "Stealth (OOC): " .. v93;
					end
					break;
				end
			end
		end
		if (((2833 - (642 + 37)) <= (920 + 3111)) and not v15:AffectingCombat() and (v83.Vanish:TimeSinceLastCast() > (1 + 0)) and v16:IsInRange(19 - 11) and v26) then
			if (((5069 - (233 + 221)) == (10671 - 6056)) and v81.TargetIsValid() and v16:IsInRange(9 + 1) and not (v15:IsChanneling() or v15:IsCasting())) then
				local v171 = 1541 - (718 + 823);
				while true do
					if ((v171 == (0 + 0)) or ((4595 - (266 + 539)) == (1415 - 915))) then
						if (((1314 - (636 + 589)) < (524 - 303)) and v83.BladeFlurry:IsReady() and v15:BuffDown(v83.BladeFlurry) and v83.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v83.AdrenalineRush:IsReady() or v15:BuffUp(v83.AdrenalineRush))) then
							if (((4236 - 2182) >= (1127 + 294)) and v11(v83.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((252 + 440) < (4073 - (657 + 358))) and not v15:StealthUp(true, false)) then
							v93 = v82.Stealth(v82.StealthSpell());
							if (v93 or ((8615 - 5361) == (3770 - 2115))) then
								return v93;
							end
						end
						v171 = 1188 - (1151 + 36);
					end
					if ((v171 == (1 + 0)) or ((341 + 955) == (14663 - 9753))) then
						if (((5200 - (1552 + 280)) == (4202 - (64 + 770))) and v81.TargetIsValid()) then
							local v190 = 0 + 0;
							while true do
								if (((5999 - 3356) < (678 + 3137)) and ((1245 - (157 + 1086)) == v190)) then
									if (((3828 - 1915) > (2159 - 1666)) and v83.SinisterStrike:IsCastable()) then
										if (((7293 - 2538) > (4678 - 1250)) and v9.Cast(v83.SinisterStrike)) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if (((2200 - (599 + 220)) <= (4717 - 2348)) and ((1931 - (1813 + 118)) == v190)) then
									if ((v83.RolltheBones:IsReady() and not v15:DebuffUp(v83.Dreadblades) and ((v110() == (0 + 0)) or v111())) or ((6060 - (841 + 376)) == (5722 - 1638))) then
										if (((1085 + 3584) > (990 - 627)) and v9.Cast(v83.RolltheBones)) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									if ((v83.AdrenalineRush:IsReady() and v83.ImprovedAdrenalineRush:IsAvailable() and (v96 <= (861 - (464 + 395)))) or ((4817 - 2940) >= (1507 + 1631))) then
										if (((5579 - (467 + 370)) >= (7492 - 3866)) and v9.Cast(v83.AdrenalineRush)) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									v190 = 1 + 0;
								end
								if ((v190 == (3 - 2)) or ((709 + 3831) == (2131 - 1215))) then
									if ((v83.SliceandDice:IsReady() and (v15:BuffRemains(v83.SliceandDice) < (((521 - (150 + 370)) + v96) * (1283.8 - (74 + 1208))))) or ((2843 - 1687) > (20606 - 16261))) then
										if (((1592 + 645) < (4639 - (14 + 376))) and v9.Press(v83.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v15:StealthUp(true, false) or ((4653 - 1970) < (15 + 8))) then
										v93 = v121();
										if (((613 + 84) <= (788 + 38)) and v93) then
											return "Stealth (Opener): " .. v93;
										end
										if (((3237 - 2132) <= (885 + 291)) and v83.KeepItRolling:IsAvailable() and v83.GhostlyStrike:IsReady() and v83.EchoingReprimand:IsAvailable()) then
											if (((3457 - (23 + 55)) <= (9033 - 5221)) and v9.Press(v83.GhostlyStrike)) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (v83.Ambush:IsCastable() or ((526 + 262) >= (1452 + 164))) then
											if (((2873 - 1019) <= (1063 + 2316)) and v9.Cast(v83.Ambush)) then
												return "Cast Ambush (Opener)";
											end
										end
									elseif (((5450 - (652 + 249)) == (12173 - 7624)) and v112()) then
										v93 = v122();
										if (v93 or ((4890 - (708 + 1160)) >= (8208 - 5184))) then
											return "Finish (Opener): " .. v93;
										end
									end
									v190 = 3 - 1;
								end
							end
						end
						return;
					end
				end
			end
		end
		if (((4847 - (10 + 17)) > (494 + 1704)) and v83.FanTheHammer:IsAvailable() and (v83.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
			v96 = v25(v96, v82.FanTheHammerCP());
		end
		if (v81.TargetIsValid() or ((2793 - (1400 + 332)) >= (9381 - 4490))) then
			local v152 = 1908 - (242 + 1666);
			while true do
				if (((584 + 780) <= (1640 + 2833)) and (v152 == (2 + 0))) then
					if ((v83.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike) and (v100 > ((955 - (850 + 90)) + v99))) or ((6296 - 2701) <= (1393 - (360 + 1030)))) then
						if (v9.Cast(v83.ArcaneTorrent, v29) or ((4135 + 537) == (10872 - 7020))) then
							return "Cast Arcane Torrent";
						end
					end
					if (((2144 - 585) == (3220 - (909 + 752))) and v83.ArcanePulse:IsCastable() and v16:IsSpellInRange(v83.SinisterStrike)) then
						if (v9.Cast(v83.ArcanePulse) or ((2975 - (109 + 1114)) <= (1442 - 654))) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v83.LightsJudgment:IsCastable() and v16:IsInMeleeRange(2 + 3)) or ((4149 - (6 + 236)) == (112 + 65))) then
						if (((2794 + 676) > (1308 - 753)) and v9.Cast(v83.LightsJudgment, v29)) then
							return "Cast Lights Judgment";
						end
					end
					v152 = 4 - 1;
				end
				if (((1133 - (1076 + 57)) == v152) or ((160 + 812) == (1334 - (579 + 110)))) then
					v93 = v120();
					if (((252 + 2930) >= (1870 + 245)) and v93) then
						return "CDs: " .. v93;
					end
					if (((2067 + 1826) < (4836 - (174 + 233))) and (v15:StealthUp(true, true) or v15:BuffUp(v83.Shadowmeld))) then
						v93 = v121();
						if (v93 or ((8008 - 5141) < (3343 - 1438))) then
							return "Stealth: " .. v93;
						end
					end
					v152 = 1 + 0;
				end
				if ((v152 == (1175 - (663 + 511))) or ((1603 + 193) >= (880 + 3171))) then
					if (((4991 - 3372) <= (2275 + 1481)) and v112()) then
						local v185 = 0 - 0;
						while true do
							if (((1461 - 857) == (289 + 315)) and (v185 == (0 - 0))) then
								v93 = v122();
								if (v93 or ((3196 + 1288) == (83 + 817))) then
									return "Finish: " .. v93;
								end
								break;
							end
						end
					end
					v93 = v123();
					if (v93 or ((5181 - (478 + 244)) <= (1630 - (440 + 77)))) then
						return "Build: " .. v93;
					end
					v152 = 1 + 1;
				end
				if (((13293 - 9661) > (4954 - (655 + 901))) and (v152 == (1 + 2))) then
					if (((3126 + 956) <= (3321 + 1596)) and v83.BagofTricks:IsCastable() and v16:IsInMeleeRange(20 - 15)) then
						if (((6277 - (695 + 750)) >= (4732 - 3346)) and v9.Cast(v83.BagofTricks, v29)) then
							return "Cast Bag of Tricks";
						end
					end
					if (((211 - 74) == (550 - 413)) and v83.PistolShot:IsCastable() and v16:IsSpellInRange(v83.PistolShot) and not v16:IsInRange(357 - (285 + 66)) and not v15:StealthUp(true, true) and (v100 < (58 - 33)) and ((v97 >= (1311 - (682 + 628))) or (v101 <= (1.2 + 0)))) then
						if (v9.Cast(v83.PistolShot) or ((1869 - (176 + 123)) >= (1813 + 2519))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (v83.SinisterStrike:IsCastable() or ((2948 + 1116) <= (2088 - (239 + 30)))) then
						if (v9.Cast(v83.SinisterStrike) or ((1356 + 3630) < (1513 + 61))) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(460 - 200, v124, v125);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

