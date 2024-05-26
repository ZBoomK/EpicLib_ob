local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((536 - (19 + 23)) <= (7378 - 4026)) and not v5) then
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
			if ((v127 == (1436 - (1233 + 195))) or ((12205 - 8545) <= (739 + 1326))) then
				v75 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v76 = EpicSettings.Settings['EchoingReprimand'];
				v77 = EpicSettings.Settings['UseSoloVanish'];
				v127 = 4 + 5;
			end
			if ((v127 == (5 + 1)) or ((2989 + 1121) > (2044 + 2332))) then
				v64 = EpicSettings.Settings['RolltheBonesLogic'];
				v67 = EpicSettings.Settings['UseDPSVanish'];
				v70 = EpicSettings.Settings['BladeFlurryGCD'];
				v127 = 1440 - (797 + 636);
			end
			if ((v127 == (4 - 3)) or ((3249 - (1427 + 192)) > (1455 + 2743))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v127 = 1 + 1;
			end
			if (((1380 - (192 + 134)) == (2330 - (316 + 960))) and (v127 == (0 + 0))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'];
				v127 = 1 + 0;
			end
			if ((v127 == (9 + 0)) or ((2584 - 1908) >= (2193 - (83 + 468)))) then
				v78 = EpicSettings.Settings['sepsis'];
				v79 = EpicSettings.Settings['BlindInterrupt'];
				v80 = EpicSettings.Settings['EvasionHP'] or (1806 - (1202 + 604));
				break;
			end
			if (((19307 - 15171) > (3989 - 1592)) and (v127 == (19 - 12))) then
				v71 = EpicSettings.Settings['BladeRushGCD'];
				v72 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v74 = EpicSettings.Settings['KeepItRollingGCD'];
				v127 = 333 - (45 + 280);
			end
			if ((v127 == (5 + 0)) or ((3787 + 547) == (1551 + 2694))) then
				v57 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
				v58 = EpicSettings.Settings['FeintHP'] or (0 + 0);
				v59 = EpicSettings.Settings['StealthOOC'];
				v127 = 10 - 4;
			end
			if ((v127 == (1914 - (340 + 1571))) or ((1687 + 2589) <= (4803 - (1733 + 39)))) then
				v29 = EpicSettings.Settings['HandleIncorporeal'];
				v52 = EpicSettings.Settings['VanishOffGCD'];
				v53 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v127 = 10 - 6;
			end
			if ((v127 == (1036 - (125 + 909))) or ((6730 - (1096 + 852)) <= (538 + 661))) then
				v37 = EpicSettings.Settings['InterruptWithStun'];
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v127 = 3 + 0;
			end
			if ((v127 == (516 - (409 + 103))) or ((5100 - (46 + 190)) < (1997 - (51 + 44)))) then
				v54 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v55 = EpicSettings.Settings['ColdBloodOffGCD'];
				v56 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v127 = 2 + 3;
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
	local v89 = (v88[1330 - (1114 + 203)] and v19(v88[739 - (228 + 498)])) or v19(0 + 0);
	local v90 = (v88[8 + 6] and v19(v88[677 - (174 + 489)])) or v19(0 - 0);
	v9:RegisterForEvent(function()
		local v128 = 1905 - (830 + 1075);
		while true do
			if (((5363 - (303 + 221)) >= (4969 - (231 + 1038))) and (v128 == (1 + 0))) then
				v90 = (v88[1176 - (171 + 991)] and v19(v88[57 - 43])) or v19(0 - 0);
				break;
			end
			if ((v128 == (0 - 0)) or ((861 + 214) > (6723 - 4805))) then
				v88 = v15:GetEquipment();
				v89 = (v88[37 - 24] and v19(v88[20 - 7])) or v19(0 - 0);
				v128 = 1249 - (111 + 1137);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v91, v92, v93;
	local v94;
	local v95 = 164 - (91 + 67);
	local v96, v97, v98;
	local v99, v100, v101, v102, v103;
	local v104 = {{v84.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v84.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v97 > (0 - 0);
	end}};
	local v105, v106 = 0 - 0, 711 - (530 + 181);
	local function v107(v129)
		local v130 = v15:EnergyTimeToMaxPredicted(nil, v129);
		if (((1277 - (614 + 267)) <= (3836 - (19 + 13))) and ((v130 < v105) or ((v130 - v105) > (0.5 - 0)))) then
			v105 = v130;
		end
		return v105;
	end
	local function v108()
		local v131 = v15:EnergyPredicted();
		if ((v131 > v106) or ((v131 - v106) > (20 - 11)) or ((11909 - 7740) == (568 + 1619))) then
			v106 = v131;
		end
		return v106;
	end
	local v109 = {v84.Broadside,v84.BuriedTreasure,v84.GrandMelee,v84.RuthlessPrecision,v84.SkullandCrossbones,v84.TrueBearing};
	local v110 = false;
	local function v111()
		if (((6062 - 4656) == (3311 - 1905)) and not v10.APLVar.RtB_Buffs) then
			v10.APLVar.RtB_Buffs = {};
			v10.APLVar.RtB_Buffs.Will_Lose = {};
			v10.APLVar.RtB_Buffs.Will_Lose.Total = 0 + 0;
			v10.APLVar.RtB_Buffs.Total = 0 + 0;
			v10.APLVar.RtB_Buffs.Normal = 0 - 0;
			v10.APLVar.RtB_Buffs.Shorter = 0 + 0;
			v10.APLVar.RtB_Buffs.Longer = 0 + 0;
			v10.APLVar.RtB_Buffs.MaxRemains = 0 + 0;
			local v153 = v83.RtBRemains();
			for v183 = 1097 - (709 + 387), #v109 do
				local v184 = 1858 - (673 + 1185);
				local v185;
				while true do
					if (((4439 - 2908) < (13714 - 9443)) and (v184 == (0 - 0))) then
						v185 = v15:BuffRemains(v109[v183]);
						if (((455 + 180) == (475 + 160)) and (v185 > (0 - 0))) then
							local v191 = 0 + 0;
							local v192;
							while true do
								if (((6725 - 3352) <= (6979 - 3423)) and ((1881 - (446 + 1434)) == v191)) then
									v192 = math.abs(v185 - v153);
									if ((v192 <= (1283.5 - (1040 + 243))) or ((9822 - 6531) < (5127 - (559 + 1288)))) then
										v10.APLVar.RtB_Buffs.Normal = v10.APLVar.RtB_Buffs.Normal + (1932 - (609 + 1322));
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v183]:Name()] = true;
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (455 - (13 + 441));
									elseif (((16389 - 12003) >= (2286 - 1413)) and (v185 > v153)) then
										v10.APLVar.RtB_Buffs.Longer = v10.APLVar.RtB_Buffs.Longer + (4 - 3);
									else
										v10.APLVar.RtB_Buffs.Shorter = v10.APLVar.RtB_Buffs.Shorter + 1 + 0;
										v10.APLVar.RtB_Buffs.Will_Lose[v109[v183]:Name()] = true;
										v10.APLVar.RtB_Buffs.Will_Lose.Total = v10.APLVar.RtB_Buffs.Will_Lose.Total + (3 - 2);
									end
									break;
								end
								if (((328 + 593) <= (483 + 619)) and (v191 == (0 - 0))) then
									v10.APLVar.RtB_Buffs.Total = v10.APLVar.RtB_Buffs.Total + 1 + 0;
									if (((8654 - 3948) >= (637 + 326)) and (v185 > v10.APLVar.RtB_Buffs.MaxRemains)) then
										v10.APLVar.RtB_Buffs.MaxRemains = v185;
									end
									v191 = 1 + 0;
								end
							end
						end
						v184 = 1 + 0;
					end
					if ((v184 == (1 + 0)) or ((940 + 20) <= (1309 - (153 + 280)))) then
						if (v110 or ((5965 - 3899) == (837 + 95))) then
							print("RtbRemains", v153);
							print(v109[v183]:Name(), v185);
						end
						break;
					end
				end
			end
			if (((1906 + 2919) < (2535 + 2308)) and v110) then
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
	local function v112(v132)
		return (v10.APLVar.RtB_Buffs.Will_Lose and v10.APLVar.RtB_Buffs.Will_Lose[v132] and true) or false;
	end
	local function v113()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (0 + 0)) or ((5902 - 2025) >= (2805 + 1732))) then
				if (not v10.APLVar.RtB_Reroll or ((4982 - (89 + 578)) < (1233 + 493))) then
					if ((v64 == "1+ Buff") or ((7648 - 3969) < (1674 - (572 + 477)))) then
						v10.APLVar.RtB_Reroll = ((v111() <= (0 + 0)) and true) or false;
					elseif ((v64 == "Broadside") or ((2776 + 1849) < (76 + 556))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.Broadside) and true) or false;
					elseif ((v64 == "Buried Treasure") or ((169 - (84 + 2)) > (2933 - 1153))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.BuriedTreasure) and true) or false;
					elseif (((394 + 152) <= (1919 - (497 + 345))) and (v64 == "Grand Melee")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.GrandMelee) and true) or false;
					elseif ((v64 == "Skull and Crossbones") or ((26 + 970) > (728 + 3573))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.SkullandCrossbones) and true) or false;
					elseif (((5403 - (605 + 728)) > (491 + 196)) and (v64 == "Ruthless Precision")) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.RuthlessPrecision) and true) or false;
					elseif ((v64 == "True Bearing") or ((1458 - 802) >= (153 + 3177))) then
						v10.APLVar.RtB_Reroll = (not v15:BuffUp(v84.TrueBearing) and true) or false;
					else
						v10.APLVar.RtB_Reroll = false;
						v111();
						v10.APLVar.RtB_Reroll = v111() <= (v21(v112(v84.BuriedTreasure)) + v21(v112(v84.GrandMelee) and (v93 < (7 - 5))));
						if ((v84.Crackshot:IsAvailable() and not v15:HasTier(28 + 3, 10 - 6)) or ((1882 + 610) <= (824 - (457 + 32)))) then
							v10.APLVar.RtB_Reroll = (not v112(v84.TrueBearing) and v84.HiddenOpportunity:IsAvailable()) or (not v112(v84.Broadside) and not v84.HiddenOpportunity:IsAvailable() and (v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0)));
						end
						if (((5724 - (832 + 570)) >= (2414 + 148)) and v84.Crackshot:IsAvailable() and v15:HasTier(9 + 22, 13 - 9)) then
							v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Buffs.Will_Lose.Total <= (1 + 0 + v21(v15:BuffUp(v84.LoadedDiceBuff)));
						end
						if ((not v84.Crackshot:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and not v112(v84.SkullandCrossbones) and (v10.APLVar.RtB_Buffs.Will_Lose.Total < ((798 - (588 + 208)) + v21(v112(v84.GrandMelee)))) and (v93 < (5 - 3))) or ((5437 - (884 + 916)) >= (7892 - 4122))) then
							v10.APLVar.RtB_Reroll = true;
						end
						v10.APLVar.RtB_Reroll = v10.APLVar.RtB_Reroll and ((v10.APLVar.RtB_Buffs.Longer == (0 + 0)) or ((v10.APLVar.RtB_Buffs.Normal == (653 - (232 + 421))) and (v10.APLVar.RtB_Buffs.Longer >= (1890 - (1569 + 320))) and (v111() < (2 + 4)) and (v10.APLVar.RtB_Buffs.MaxRemains <= (8 + 31)) and not v15:StealthUp(true, true) and v15:BuffUp(v84.LoadedDiceBuff)));
						if (v16:FilteredTimeToDie("<", 40 - 28) or v9.BossFilteredFightRemains("<", 617 - (316 + 289)) or ((6227 - 3848) > (212 + 4366))) then
							v10.APLVar.RtB_Reroll = false;
						end
					end
				end
				return v10.APLVar.RtB_Reroll;
			end
		end
	end
	local function v114()
		return v96 >= ((v83.CPMaxSpend() - (1454 - (666 + 787))) - v21((v15:StealthUp(true, true)) and v84.Crackshot:IsAvailable()));
	end
	local function v115()
		return (v84.HiddenOpportunity:IsAvailable() or (v98 >= ((427 - (360 + 65)) + v21(v84.ImprovedAmbush:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))))) and (v99 >= (47 + 3));
	end
	local function v116()
		return v67 and (not v15:IsTanking(v16) or v77);
	end
	local function v117()
		return not v84.ShadowDanceTalent:IsAvailable() and ((v84.FanTheHammer:TalentRank() + v21(v84.QuickDraw:IsAvailable()) + v21(v84.Audacity:IsAvailable())) < (v21(v84.CountTheOdds:IsAvailable()) + v21(v84.KeepItRolling:IsAvailable())));
	end
	local function v118()
		return v15:BuffUp(v84.BetweentheEyes) and (not v84.HiddenOpportunity:IsAvailable() or (v15:BuffDown(v84.AudacityBuff) and ((v84.FanTheHammer:TalentRank() < (256 - (79 + 175))) or v15:BuffDown(v84.Opportunity)))) and not v84.Crackshot:IsAvailable();
	end
	local function v119()
		if ((v84.Vanish:IsReady() and v116() and v84.HiddenOpportunity:IsAvailable() and not v84.Crackshot:IsAvailable() and not v15:BuffUp(v84.Audacity) and (v117() or (v15:BuffStack(v84.Opportunity) < (9 - 3))) and v115()) or ((377 + 106) > (2277 - 1534))) then
			if (((4725 - 2271) > (1477 - (503 + 396))) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (HO)";
			end
		end
		if (((1111 - (92 + 89)) < (8648 - 4190)) and v84.Vanish:IsReady() and v116() and (not v84.HiddenOpportunity:IsAvailable() or v84.Crackshot:IsAvailable()) and v114()) then
			if (((340 + 322) <= (576 + 396)) and v9.Cast(v84.Vanish, v67)) then
				return "Cast Vanish (Finish)";
			end
		end
		if (((17113 - 12743) == (598 + 3772)) and v84.ShadowDance:IsReady() and v84.Crackshot:IsAvailable() and v114() and ((v84.Vanish:CooldownRemains() >= (13 - 7)) or not v67) and not v15:StealthUp(true, false)) then
			if (v9.Cast(v84.ShadowDance, v53) or ((4155 + 607) <= (412 + 449))) then
				return "Cast Shadow Dance Crackshot";
			end
		end
		if ((v84.ShadowDance:IsReady() and not v84.KeepItRolling:IsAvailable() and v118() and v15:BuffUp(v84.SliceandDice) and (v114() or v84.HiddenOpportunity:IsAvailable()) and (not v84.HiddenOpportunity:IsAvailable() or not v84.Vanish:IsReady() or not v67)) or ((4300 - 2888) == (533 + 3731))) then
			if (v11(v84.ShadowDance, v53) or ((4831 - 1663) < (3397 - (485 + 759)))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.ShadowDance:IsReady() and v84.KeepItRolling:IsAvailable() and v118() and ((v84.KeepItRolling:CooldownRemains() <= (69 - 39)) or ((v84.KeepItRolling:CooldownRemains() >= (1309 - (442 + 747))) and (v114() or v84.HiddenOpportunity:IsAvailable())))) or ((6111 - (832 + 303)) < (2278 - (88 + 858)))) then
			if (((1411 + 3217) == (3831 + 797)) and v9.Cast(v84.ShadowDance, v53)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v84.Shadowmeld:IsAvailable() and v84.Shadowmeld:IsReady() and v30) or ((3 + 51) == (1184 - (766 + 23)))) then
			if (((404 - 322) == (111 - 29)) and ((v84.Crackshot:IsAvailable() and v114()) or (not v84.Crackshot:IsAvailable() and ((v84.CountTheOdds:IsAvailable() and v114()) or v84.HiddenOpportunity:IsAvailable())))) then
				if (v9.Cast(v84.Shadowmeld, v30) or ((1530 - 949) < (956 - 674))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v120()
		local v134 = 1073 - (1036 + 37);
		local v135;
		while true do
			if ((v134 == (0 + 0)) or ((8975 - 4366) < (1963 + 532))) then
				v135 = v82.HandleTopTrinket(v87, v28, 1520 - (641 + 839), nil);
				if (((2065 - (910 + 3)) == (2936 - 1784)) and v135) then
					return v135;
				end
				v134 = 1685 - (1466 + 218);
			end
			if (((872 + 1024) <= (4570 - (556 + 592))) and (v134 == (1 + 0))) then
				v135 = v82.HandleBottomTrinket(v87, v28, 848 - (329 + 479), nil);
				if (v135 or ((1844 - (174 + 680)) > (5566 - 3946))) then
					return v135;
				end
				break;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		local v137;
		local v138;
		while true do
			if ((v136 == (2 + 0)) or ((1616 - (396 + 343)) > (416 + 4279))) then
				if (((4168 - (29 + 1448)) >= (3240 - (135 + 1254))) and v84.KeepItRolling:IsReady() and not v113() and (v111() >= ((11 - 8) + v21(v15:HasTier(144 - 113, 3 + 1)))) and (v15:BuffDown(v84.ShadowDance) or (v111() >= (1533 - (389 + 1138))))) then
					if (v9.Cast(v84.KeepItRolling) or ((3559 - (102 + 472)) >= (4583 + 273))) then
						return "Cast Keep it Rolling";
					end
				end
				if (((2372 + 1904) >= (1115 + 80)) and v84.GhostlyStrike:IsAvailable() and v84.GhostlyStrike:IsReady() and (v96 < (1552 - (320 + 1225)))) then
					if (((5752 - 2520) <= (2870 + 1820)) and v11(v84.GhostlyStrike, v72, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
						return "Cast Ghostly Strike";
					end
				end
				if ((v28 and v84.Sepsis:IsAvailable() and v84.Sepsis:IsReady()) or ((2360 - (157 + 1307)) >= (5005 - (821 + 1038)))) then
					if (((7637 - 4576) >= (324 + 2634)) and ((v84.Crackshot:IsAvailable() and v84.BetweentheEyes:IsReady() and v114() and not v15:StealthUp(true, true)) or (not v84.Crackshot:IsAvailable() and v16:FilteredTimeToDie(">", 19 - 8) and v15:BuffUp(v84.BetweentheEyes)) or v9.BossFilteredFightRemains("<", 5 + 6))) then
						if (((7898 - 4711) >= (1670 - (834 + 192))) and v9.Cast(v84.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((41 + 603) <= (181 + 523)) and v84.BladeRush:IsReady() and (v102 > (1 + 3)) and not v15:StealthUp(true, true)) then
					if (((1483 - 525) > (1251 - (300 + 4))) and v9.Cast(v84.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				v136 = 1 + 2;
			end
			if (((11758 - 7266) >= (3016 - (112 + 250))) and (v136 == (2 + 2))) then
				if (((8622 - 5180) >= (862 + 641)) and v84.Berserking:IsCastable()) then
					if (v9.Cast(v84.Berserking, nil, v30) or ((1640 + 1530) <= (1095 + 369))) then
						return "Cast Berserking";
					end
				end
				if (v84.Fireblood:IsCastable() or ((2379 + 2418) == (3260 + 1128))) then
					if (((1965 - (1001 + 413)) <= (1518 - 837)) and v9.Cast(v84.Fireblood, nil, v30)) then
						return "Cast Fireblood";
					end
				end
				if (((4159 - (244 + 638)) > (1100 - (627 + 66))) and v84.AncestralCall:IsCastable()) then
					if (((13989 - 9294) >= (2017 - (512 + 90))) and v9.Cast(v84.AncestralCall, nil, v30)) then
						return "Cast Ancestral Call";
					end
				end
				break;
			end
			if ((v136 == (1909 - (1665 + 241))) or ((3929 - (373 + 344)) <= (426 + 518))) then
				if ((not v15:StealthUp(true, true) and (not v84.Crackshot:IsAvailable() or v84.BetweentheEyes:IsReady())) or ((820 + 2276) <= (4742 - 2944))) then
					local v187 = 0 - 0;
					while true do
						if (((4636 - (35 + 1064)) == (2574 + 963)) and (v187 == (0 - 0))) then
							v138 = v119();
							if (((16 + 3821) >= (2806 - (298 + 938))) and v138) then
								return v138;
							end
							break;
						end
					end
				end
				if ((v28 and v84.ThistleTea:IsAvailable() and v84.ThistleTea:IsCastable() and not v15:BuffUp(v84.ThistleTea) and ((v101 >= (1359 - (233 + 1026))) or v9.BossFilteredFightRemains("<", v84.ThistleTea:Charges() * (1672 - (636 + 1030))))) or ((1509 + 1441) == (3724 + 88))) then
					if (((1404 + 3319) >= (157 + 2161)) and v9.Cast(v84.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if ((v84.BladeRush:IsCastable() and (v102 > (225 - (55 + 166))) and not v15:StealthUp(true, true)) or ((393 + 1634) > (287 + 2565))) then
					if (v11(v84.BladeRush, v70, nil, not v16:IsSpellInRange(v84.BladeRush)) or ((4338 - 3202) > (4614 - (36 + 261)))) then
						return "Cast Blade Rush";
					end
				end
				if (((8303 - 3555) == (6116 - (34 + 1334))) and v84.BloodFury:IsCastable()) then
					if (((1437 + 2299) <= (3683 + 1057)) and v9.Cast(v84.BloodFury, nil, v30)) then
						return "Cast Blood Fury";
					end
				end
				v136 = 1287 - (1035 + 248);
			end
			if ((v136 == (22 - (20 + 1))) or ((1767 + 1623) <= (3379 - (134 + 185)))) then
				if (v84.BladeFlurry:IsReady() or ((2132 - (549 + 584)) > (3378 - (314 + 371)))) then
					if (((1589 - 1126) < (1569 - (478 + 490))) and v84.DeftManeuvers:IsAvailable() and not v114() and (((v93 >= (2 + 1)) and (v98 == (v93 + v21(v15:BuffUp(v84.Broadside))))) or (v93 >= (1177 - (786 + 386))))) then
						if (v11(v84.BladeFlurry) or ((7070 - 4887) < (2066 - (1055 + 324)))) then
							return "Cast Blade Flurry";
						end
					end
				end
				if (((5889 - (1093 + 247)) == (4043 + 506)) and v84.RolltheBones:IsReady()) then
					if (((492 + 4180) == (18548 - 13876)) and (v113() or (v111() == (0 - 0)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (8 - 5)) and v15:HasTier(77 - 46, 2 + 2)) or ((v10.APLVar.RtB_Buffs.MaxRemains <= (26 - 19)) and ((v84.ShadowDance:CooldownRemains() <= (10 - 7)) or (v84.Vanish:CooldownRemains() <= (3 + 0)))))) then
						if (v11(v84.RolltheBones) or ((9380 - 5712) < (1083 - (364 + 324)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				v138 = v120();
				if (v138 or ((11420 - 7254) == (1091 - 636))) then
					return v138;
				end
				v136 = 1 + 1;
			end
			if ((v136 == (0 - 0)) or ((7124 - 2675) == (8087 - 5424))) then
				v137 = v82.HandleDPSPotion(v15:BuffUp(v84.AdrenalineRush));
				if (v137 or ((5545 - (1249 + 19)) < (2698 + 291))) then
					return "DPS Pot";
				end
				if ((v28 and v84.AdrenalineRush:IsCastable() and ((not v15:BuffUp(v84.AdrenalineRush) and (not v114() or not v84.ImprovedAdrenalineRush:IsAvailable())) or (v15:StealthUp(true, true) and v84.Crackshot:IsAvailable() and v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (7 - 5))))) or ((1956 - (686 + 400)) >= (3256 + 893))) then
					if (((2441 - (73 + 156)) < (16 + 3167)) and v11(v84.AdrenalineRush, v75)) then
						return "Cast Adrenaline Rush";
					end
				end
				if (((5457 - (721 + 90)) > (34 + 2958)) and v84.BladeFlurry:IsReady()) then
					if (((4655 - 3221) < (3576 - (224 + 246))) and (v93 >= ((2 - 0) - v21(v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and v15:BuffUp(v84.AdrenalineRush)))) and (v15:BuffRemains(v84.BladeFlurry) < v15:GCD())) then
						if (((1447 - 661) < (549 + 2474)) and v11(v84.BladeFlurry)) then
							return "Cast Blade Flurry";
						end
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v122()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (3 - 1)) or ((8126 - 5684) < (587 - (203 + 310)))) then
				if (((6528 - (1238 + 755)) == (317 + 4218)) and v16:IsSpellInRange(v84.PistolShot) and v84.Crackshot:IsAvailable() and (v84.FanTheHammer:TalentRank() >= (1536 - (709 + 825))) and (v15:BuffStack(v84.Opportunity) >= (10 - 4)) and ((v15:BuffUp(v84.Broadside) and (v97 <= (1 - 0))) or v15:BuffUp(v84.GreenskinsWickersBuff))) then
					if (v9.Press(v84.PistolShot) or ((3873 - (196 + 668)) <= (8311 - 6206))) then
						return "Cast Pistol Shot";
					end
				end
				if (((3790 - 1960) < (4502 - (171 + 662))) and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) then
					if (v9.Cast(v84.Ambush, nil, not v16:IsSpellInRange(v84.Ambush)) or ((1523 - (4 + 89)) >= (12659 - 9047))) then
						return "Cast Ambush (SS High-Prio Buffed)";
					end
				end
				v139 = 2 + 1;
			end
			if (((11784 - 9101) >= (965 + 1495)) and (v139 == (1489 - (35 + 1451)))) then
				if ((v84.Ambush:IsCastable() and v16:IsSpellInRange(v84.Ambush) and v84.HiddenOpportunity:IsAvailable()) or ((3257 - (28 + 1425)) >= (5268 - (941 + 1052)))) then
					if (v9.Press(v84.Ambush) or ((1359 + 58) > (5143 - (822 + 692)))) then
						return "Cast Ambush";
					end
				end
				break;
			end
			if (((6845 - 2050) > (190 + 212)) and (v139 == (297 - (45 + 252)))) then
				if (((4763 + 50) > (1227 + 2338)) and v84.BladeFlurry:IsReady() and v84.BladeFlurry:IsCastable() and v27 and v84.Subterfuge:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and (v93 >= (4 - 2)) and (v15:BuffRemains(v84.BladeFlurry) <= v15:GCD()) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
					if (((4345 - (114 + 319)) == (5616 - 1704)) and v70) then
						v9.Cast(v84.BladeFlurry);
					elseif (((3614 - 793) <= (3076 + 1748)) and v9.Cast(v84.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((2589 - 851) <= (4598 - 2403)) and v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch) and v114()) then
					if (((2004 - (556 + 1407)) <= (4224 - (741 + 465))) and v9.Cast(v84.ColdBlood, v55)) then
						return "Cast Cold Blood";
					end
				end
				v139 = 466 - (170 + 295);
			end
			if (((1131 + 1014) <= (3770 + 334)) and (v139 == (2 - 1))) then
				if (((2230 + 459) < (3108 + 1737)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v114() and v84.Crackshot:IsAvailable() and (not v15:BuffUp(v84.Shadowmeld) or v15:StealthUp(true, false))) then
					if (v9.Cast(v84.BetweentheEyes) or ((1315 + 1007) > (3852 - (957 + 273)))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch) and v114()) or ((1213 + 3321) == (834 + 1248))) then
					if (v9.Press(v84.Dispatch) or ((5986 - 4415) > (4919 - 3052))) then
						return "Cast Dispatch";
					end
				end
				v139 = 5 - 3;
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1780 - (389 + 1391))) or ((1666 + 988) >= (312 + 2684))) then
				if (((9056 - 5078) > (3055 - (783 + 168))) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and not v84.Crackshot:IsAvailable() and ((v15:BuffRemains(v84.BetweentheEyes) < (13 - 9)) or v84.ImprovedBetweenTheEyes:IsAvailable() or v84.GreenskinsWickers:IsAvailable() or v15:HasTier(30 + 0, 315 - (309 + 2))) and v15:BuffDown(v84.GreenskinsWickers)) then
					if (((9197 - 6202) > (2753 - (1090 + 122))) and v9.Press(v84.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((1054 + 2195) > (3200 - 2247)) and v84.BetweentheEyes:IsCastable() and v16:IsSpellInRange(v84.BetweentheEyes) and v84.Crackshot:IsAvailable() and (v84.Vanish:CooldownRemains() > (31 + 14)) and (v84.ShadowDance:CooldownRemains() > (1130 - (628 + 490)))) then
					if (v9.Press(v84.BetweentheEyes) or ((587 + 2686) > (11322 - 6749))) then
						return "Cast Between the Eyes";
					end
				end
				v140 = 4 - 3;
			end
			if ((v140 == (775 - (431 + 343))) or ((6363 - 3212) < (3714 - 2430))) then
				if ((v84.SliceandDice:IsCastable() and (v9.FilteredFightRemains(v92, ">", v15:BuffRemains(v84.SliceandDice), true) or (v15:BuffRemains(v84.SliceandDice) == (0 + 0))) and (v15:BuffRemains(v84.SliceandDice) < ((1 + 0 + v97) * (1696.8 - (556 + 1139))))) or ((1865 - (6 + 9)) == (280 + 1249))) then
					if (((421 + 400) < (2292 - (28 + 141))) and v9.Press(v84.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if (((350 + 552) < (2869 - 544)) and v84.KillingSpree:IsCastable() and v16:IsSpellInRange(v84.KillingSpree) and (v16:DebuffUp(v84.GhostlyStrike) or not v84.GhostlyStrike:IsAvailable())) then
					if (((608 + 250) <= (4279 - (486 + 831))) and v9.Cast(v84.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v140 = 5 - 3;
			end
			if ((v140 == (6 - 4)) or ((746 + 3200) < (4072 - 2784))) then
				if ((v84.ColdBlood:IsCastable() and v15:BuffDown(v84.ColdBlood) and v16:IsSpellInRange(v84.Dispatch)) or ((4505 - (668 + 595)) == (511 + 56))) then
					if (v9.Cast(v84.ColdBlood, v55) or ((171 + 676) >= (3444 - 2181))) then
						return "Cast Cold Blood";
					end
				end
				if ((v84.Dispatch:IsCastable() and v16:IsSpellInRange(v84.Dispatch)) or ((2543 - (23 + 267)) == (3795 - (1129 + 815)))) then
					if (v9.Press(v84.Dispatch) or ((2474 - (371 + 16)) > (4122 - (1326 + 424)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (0 - 0)) or ((4563 - (88 + 30)) < (4920 - (720 + 51)))) then
				if ((v28 and v84.EchoingReprimand:IsReady()) or ((4043 - 2225) == (1861 - (421 + 1355)))) then
					if (((1039 - 409) < (1045 + 1082)) and v9.Cast(v84.EchoingReprimand, v76, nil, not v16:IsSpellInRange(v84.EchoingReprimand))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.AudacityBuff)) or ((3021 - (286 + 797)) == (9190 - 6676))) then
					if (((7047 - 2792) >= (494 - (397 + 42))) and v9.Press(v84.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v141 = 1 + 0;
			end
			if (((3799 - (24 + 776)) > (1780 - 624)) and (v141 == (786 - (222 + 563)))) then
				if (((5177 - 2827) > (832 + 323)) and v84.FanTheHammer:IsAvailable() and v84.Audacity:IsAvailable() and v84.HiddenOpportunity:IsAvailable() and v15:BuffUp(v84.Opportunity) and v15:BuffDown(v84.AudacityBuff)) then
					if (((4219 - (23 + 167)) <= (6651 - (690 + 1108))) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v15:BuffStack(v84.Opportunity) >= (3 + 3)) or (v15:BuffRemains(v84.Opportunity) < (2 + 0)))) or ((1364 - (40 + 808)) > (566 + 2868))) then
					if (((15471 - 11425) >= (2899 + 134)) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				v141 = 2 + 0;
			end
			if (((2 + 1) == v141) or ((3290 - (47 + 524)) <= (940 + 507))) then
				if (v84.SinisterStrike:IsCastable() or ((11300 - 7166) < (5870 - 1944))) then
					if (v9.Press(v84.SinisterStrike) or ((373 - 209) >= (4511 - (1165 + 561)))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if (((1 + 1) == v141) or ((1626 - 1101) == (805 + 1304))) then
				if (((512 - (341 + 138)) == (9 + 24)) and v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v98 >= ((1 - 0) + ((v21(v84.QuickDraw:IsAvailable()) + v21(v15:BuffUp(v84.Broadside))) * (v84.FanTheHammer:TalentRank() + (327 - (89 + 237)))))) or (v97 <= (3 - 2)))) then
					if (((6429 - 3375) <= (4896 - (581 + 300))) and v9.Press(v84.PistolShot)) then
						return "Cast Pistol Shot (Low CP Opportunity)";
					end
				end
				if (((3091 - (855 + 365)) < (8032 - 4650)) and not v84.FanTheHammer:IsAvailable() and v15:BuffUp(v84.Opportunity) and ((v102 > (1.5 + 0)) or (v98 <= ((1236 - (1030 + 205)) + v21(v15:BuffUp(v84.Broadside)))) or v84.QuickDraw:IsAvailable() or (v84.Audacity:IsAvailable() and v15:BuffDown(v84.AudacityBuff)))) then
					if (((1214 + 79) <= (2015 + 151)) and v9.Cast(v84.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				v141 = 289 - (156 + 130);
			end
		end
	end
	local function v125()
		v81();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		v97 = v15:ComboPoints();
		v96 = v83.EffectiveComboPoints(v97);
		v98 = v15:ComboPointsDeficit();
		v103 = (v15:BuffUp(v84.AdrenalineRush, nil, true) and -(113 - 63)) or (0 - 0);
		v99 = v108();
		v100 = v15:EnergyRegen();
		v102 = v107(v103);
		v101 = v15:EnergyDeficitPredicted(nil, v103);
		if (v27 or ((5281 - 2702) < (33 + 90))) then
			local v154 = 0 + 0;
			while true do
				if (((70 - (10 + 59)) == v154) or ((240 + 606) >= (11661 - 9293))) then
					v93 = #v92;
					break;
				end
				if ((v154 == (1163 - (671 + 492))) or ((3194 + 818) <= (4573 - (369 + 846)))) then
					v91 = v15:GetEnemiesInRange(8 + 22);
					v92 = v15:GetEnemiesInRange(v95);
					v154 = 1 + 0;
				end
			end
		else
			v93 = 1946 - (1036 + 909);
		end
		v94 = v83.CrimsonVial();
		if (((1188 + 306) <= (5045 - 2040)) and v94) then
			return v94;
		end
		v83.Poisons();
		if ((v32 and (v15:HealthPercentage() <= v34)) or ((3314 - (11 + 192)) == (1079 + 1055))) then
			if (((2530 - (135 + 40)) == (5705 - 3350)) and (v33 == "Refreshing Healing Potion")) then
				if (v85.RefreshingHealingPotion:IsReady() or ((355 + 233) <= (951 - 519))) then
					if (((7190 - 2393) >= (4071 - (50 + 126))) and v9.Press(v86.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((9960 - 6383) == (792 + 2785)) and (v33 == "Dreamwalker's Healing Potion")) then
				if (((5207 - (1233 + 180)) > (4662 - (522 + 447))) and v85.DreamwalkersHealingPotion:IsReady()) then
					if (v9.Press(v86.RefreshingHealingPotion) or ((2696 - (107 + 1314)) == (1903 + 2197))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if ((v84.Feint:IsCastable() and v84.Feint:IsReady() and (v15:HealthPercentage() <= v58)) or ((4847 - 3256) >= (1521 + 2059))) then
			if (((1951 - 968) <= (7153 - 5345)) and v9.Cast(v84.Feint)) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((v84.Evasion:IsCastable() and v84.Evasion:IsReady() and (v15:HealthPercentage() <= v80)) or ((4060 - (716 + 1194)) <= (21 + 1176))) then
			if (((404 + 3365) >= (1676 - (74 + 429))) and v9.Cast(v84.Evasion)) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((2864 - 1379) == (736 + 749)) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v155 = 0 - 0;
			local v156;
			while true do
				if ((v155 == (2 + 0)) or ((10219 - 6904) <= (6878 - 4096))) then
					v156 = v82.InterruptWithStun(v84.CheapShot, 441 - (279 + 154), v15:StealthUp(false, false));
					if (v156 or ((1654 - (454 + 324)) >= (2332 + 632))) then
						return v156;
					end
					v156 = v82.InterruptWithStun(v84.KidneyShot, 25 - (12 + 5), v15:ComboPoints() > (0 + 0));
					if (v156 or ((5686 - 3454) > (923 + 1574))) then
						return v156;
					end
					break;
				end
				if ((v155 == (1093 - (277 + 816))) or ((9016 - 6906) <= (1515 - (1058 + 125)))) then
					v156 = v82.Interrupt(v84.Kick, 2 + 6, true);
					if (((4661 - (815 + 160)) > (13609 - 10437)) and v156) then
						return v156;
					end
					v156 = v82.Interrupt(v84.Kick, 18 - 10, true, v12, v86.KickMouseover);
					if (v156 or ((1068 + 3406) < (2396 - 1576))) then
						return v156;
					end
					v155 = 1899 - (41 + 1857);
				end
				if (((6172 - (1222 + 671)) >= (7448 - 4566)) and (v155 == (1 - 0))) then
					v156 = v82.Interrupt(v84.Blind, 1197 - (229 + 953), v79);
					if (v156 or ((3803 - (1111 + 663)) >= (5100 - (874 + 705)))) then
						return v156;
					end
					v156 = v82.Interrupt(v84.Blind, 3 + 12, v79, v12, v86.BlindMouseover);
					if (v156 or ((1390 + 647) >= (9648 - 5006))) then
						return v156;
					end
					v155 = 1 + 1;
				end
			end
		end
		if (((2399 - (642 + 37)) < (1017 + 3441)) and v29) then
			local v157 = 0 + 0;
			while true do
				if ((v157 == (0 - 0)) or ((890 - (233 + 221)) > (6985 - 3964))) then
					v94 = v82.HandleIncorporeal(v84.Blind, v86.BlindMouseover, 27 + 3, true);
					if (((2254 - (718 + 823)) <= (533 + 314)) and v94) then
						return v94;
					end
					break;
				end
			end
		end
		if (((2959 - (266 + 539)) <= (11412 - 7381)) and not v15:AffectingCombat() and not v15:IsMounted() and v59) then
			v94 = v83.Stealth(v84.Stealth2, nil);
			if (((5840 - (636 + 589)) == (10954 - 6339)) and v94) then
				return "Stealth (OOC): " .. v94;
			end
		end
		if ((not v15:AffectingCombat() and (v84.Vanish:TimeSinceLastCast() > (1 - 0)) and v16:IsInRange(7 + 1) and v26) or ((1377 + 2413) == (1515 - (657 + 358)))) then
			if (((235 - 146) < (503 - 282)) and v82.TargetIsValid() and v16:IsInRange(1197 - (1151 + 36)) and not (v15:IsChanneling() or v15:IsCasting())) then
				if (((1984 + 70) >= (374 + 1047)) and v84.BladeFlurry:IsReady() and v15:BuffDown(v84.BladeFlurry) and v84.UnderhandedUpperhand:IsAvailable() and not v15:StealthUp(true, true) and (v84.AdrenalineRush:IsReady() or v15:BuffUp(v84.AdrenalineRush))) then
					if (((2066 - 1374) < (4890 - (1552 + 280))) and v11(v84.BladeFlurry)) then
						return "Blade Flurry (Opener)";
					end
				end
				if (not v15:StealthUp(true, false) or ((4088 - (64 + 770)) == (1124 + 531))) then
					local v188 = 0 - 0;
					while true do
						if (((0 + 0) == v188) or ((2539 - (157 + 1086)) == (9827 - 4917))) then
							v94 = v83.Stealth(v84.Stealth);
							if (((14750 - 11382) == (5166 - 1798)) and v94) then
								return v94;
							end
							break;
						end
					end
				end
				if (((3606 - 963) < (4634 - (599 + 220))) and v82.TargetIsValid()) then
					local v189 = 0 - 0;
					while true do
						if (((3844 - (1813 + 118)) > (361 + 132)) and (v189 == (1219 - (841 + 376)))) then
							if (((6662 - 1907) > (797 + 2631)) and v84.SinisterStrike:IsCastable()) then
								if (((3769 - 2388) <= (3228 - (464 + 395))) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
									return "Cast Sinister Strike (Opener)";
								end
							end
							break;
						end
						if ((v189 == (2 - 1)) or ((2326 + 2517) == (4921 - (467 + 370)))) then
							if (((9648 - 4979) > (267 + 96)) and v84.SliceandDice:IsReady() and (v15:BuffRemains(v84.SliceandDice) < (((3 - 2) + v97) * (1.8 + 0)))) then
								if (v9.Press(v84.SliceandDice) or ((4366 - 2489) >= (3658 - (150 + 370)))) then
									return "Cast Slice and Dice (Opener)";
								end
							end
							if (((6024 - (74 + 1208)) >= (8918 - 5292)) and v15:StealthUp(true, false)) then
								local v196 = 0 - 0;
								while true do
									if ((v196 == (1 + 0)) or ((4930 - (14 + 376)) == (1588 - 672))) then
										if ((v84.KeepItRolling:IsAvailable() and v84.GhostlyStrike:IsReady() and v84.EchoingReprimand:IsAvailable()) or ((749 + 407) > (3817 + 528))) then
											if (((2134 + 103) < (12450 - 8201)) and v9.Cast(v84.GhostlyStrike, nil, nil, not v16:IsSpellInRange(v84.GhostlyStrike))) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if ((v84.Ambush:IsCastable() and v84.HiddenOpportunity:IsAvailable()) or ((2019 + 664) < (101 - (23 + 55)))) then
											if (((1651 - 954) <= (552 + 274)) and v9.Cast(v84.Ambush, nil, nil, not v16:IsSpellInRange(v84.Ambush))) then
												return "Cast Ambush (Opener)";
											end
										elseif (((993 + 112) <= (1823 - 647)) and v84.SinisterStrike:IsCastable()) then
											if (((1063 + 2316) <= (4713 - (652 + 249))) and v9.Cast(v84.SinisterStrike, nil, nil, not v16:IsSpellInRange(v84.SinisterStrike))) then
												return "Cast Sinister Strike (Opener)";
											end
										end
										break;
									end
									if ((v196 == (0 - 0)) or ((2656 - (708 + 1160)) >= (4386 - 2770))) then
										v94 = v122();
										if (((3379 - 1525) <= (3406 - (10 + 17))) and v94) then
											return "Stealth (Opener): " .. v94;
										end
										v196 = 1 + 0;
									end
								end
							elseif (((6281 - (1400 + 332)) == (8724 - 4175)) and v114()) then
								v94 = v123();
								if (v94 or ((4930 - (242 + 1666)) >= (1295 + 1729))) then
									return "Finish (Opener): " .. v94;
								end
							end
							v189 = 1 + 1;
						end
						if (((4108 + 712) > (3138 - (850 + 90))) and (v189 == (0 - 0))) then
							if ((v84.ImprovedAdrenalineRush:IsAvailable() and (v97 <= (1392 - (360 + 1030)))) or ((939 + 122) >= (13804 - 8913))) then
								if (((1876 - 512) <= (6134 - (909 + 752))) and v9.Cast(v84.AdrenalineRush)) then
									return "Cast Adrenaline Rush (Opener)";
								end
							end
							if ((v84.RolltheBones:IsReady() and not v15:DebuffUp(v84.Dreadblades) and ((v111() == (1223 - (109 + 1114))) or v113())) or ((6581 - 2986) <= (2 + 1))) then
								if (v9.Cast(v84.RolltheBones) or ((4914 - (6 + 236)) == (2427 + 1425))) then
									return "Cast Roll the Bones (Opener)";
								end
							end
							v189 = 1 + 0;
						end
					end
				end
				return;
			end
		end
		if (((3676 - 2117) == (2722 - 1163)) and v84.FanTheHammer:IsAvailable() and (v84.PistolShot:TimeSinceLastCast() < v15:GCDRemains())) then
			local v158 = 1133 - (1076 + 57);
			while true do
				if ((v158 == (0 + 0)) or ((2441 - (579 + 110)) <= (63 + 725))) then
					v97 = v25(v97, v83.FanTheHammerCP());
					v96 = v83.EffectiveComboPoints(v97);
					v158 = 1 + 0;
				end
				if ((v158 == (1 + 0)) or ((4314 - (174 + 233)) == (494 - 317))) then
					v98 = v15:ComboPointsDeficit();
					break;
				end
			end
		end
		if (((6090 - 2620) > (247 + 308)) and v82.TargetIsValid()) then
			v94 = v121();
			if (v94 or ((2146 - (663 + 511)) == (576 + 69))) then
				return "CDs: " .. v94;
			end
			if (((691 + 2491) >= (6520 - 4405)) and (v15:StealthUp(true, true) or v15:BuffUp(v84.Shadowmeld))) then
				v94 = v122();
				if (((2358 + 1535) < (10427 - 5998)) and v94) then
					return "Stealth: " .. v94;
				end
			end
			if (v114() or ((6940 - 4073) < (910 + 995))) then
				local v186 = 0 - 0;
				while true do
					if ((v186 == (1 + 0)) or ((165 + 1631) >= (4773 - (478 + 244)))) then
						return "Finish Pooling";
					end
					if (((2136 - (440 + 77)) <= (1708 + 2048)) and (v186 == (0 - 0))) then
						v94 = v123();
						if (((2160 - (655 + 901)) == (113 + 491)) and v94) then
							return "Finish: " .. v94;
						end
						v186 = 1 + 0;
					end
				end
			end
			v94 = v124();
			if (v94 or ((3028 + 1456) == (3625 - 2725))) then
				return "Build: " .. v94;
			end
			if ((v84.ArcaneTorrent:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike) and (v101 > ((1460 - (695 + 750)) + v100))) or ((15225 - 10766) <= (1716 - 603))) then
				if (((14606 - 10974) > (3749 - (285 + 66))) and v9.Cast(v84.ArcaneTorrent, v30)) then
					return "Cast Arcane Torrent";
				end
			end
			if (((9514 - 5432) <= (6227 - (682 + 628))) and v84.ArcanePulse:IsCastable() and v16:IsSpellInRange(v84.SinisterStrike)) then
				if (((779 + 4053) >= (1685 - (176 + 123))) and v9.Cast(v84.ArcanePulse)) then
					return "Cast Arcane Pulse";
				end
			end
			if (((58 + 79) == (100 + 37)) and v84.LightsJudgment:IsCastable() and v16:IsInMeleeRange(274 - (239 + 30))) then
				if (v9.Cast(v84.LightsJudgment, v30) or ((427 + 1143) >= (4164 + 168))) then
					return "Cast Lights Judgment";
				end
			end
			if ((v84.BagofTricks:IsCastable() and v16:IsInMeleeRange(8 - 3)) or ((12679 - 8615) <= (2134 - (306 + 9)))) then
				if (v9.Cast(v84.BagofTricks, v30) or ((17399 - 12413) < (274 + 1300))) then
					return "Cast Bag of Tricks";
				end
			end
			if (((2716 + 1710) > (83 + 89)) and v16:IsSpellInRange(v84.PistolShot) and not v16:IsInRange(v95) and not v15:StealthUp(true, true) and (v101 < (71 - 46)) and ((v98 >= (1376 - (1140 + 235))) or (v102 <= (1.2 + 0)))) then
				if (((538 + 48) > (117 + 338)) and v9.Cast(v84.PistolShot)) then
					return "Cast Pistol Shot (OOR)";
				end
			end
			if (((878 - (33 + 19)) == (299 + 527)) and v84.SinisterStrike:IsCastable()) then
				if (v9.Cast(v84.SinisterStrike) or ((12045 - 8026) > (1957 + 2484))) then
					return "Cast Sinister Strike Filler";
				end
			end
		end
	end
	local function v126()
		v9.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v9.SetAPL(509 - 249, v125, v126);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

