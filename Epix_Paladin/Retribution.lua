local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((795 + 308) < (2491 - (530 + 181))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Focus;
	local v14 = v11.Player;
	local v15 = v11.MouseOver;
	local v16 = v11.Target;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = math.min;
	local v28 = math.max;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96 = v20.Commons.Everyone;
	local v97 = v18.Paladin.Retribution;
	local v98 = v19.Paladin.Retribution;
	local v99 = {};
	local function v100()
		if (((3565 - (614 + 267)) > (578 - (19 + 13))) and v97.CleanseToxins:IsAvailable()) then
			v96.DispellableDebuffs = v12.MergeTable(v96.DispellableDiseaseDebuffs, v96.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v100();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v101 = v23.Paladin.Retribution;
	local v102;
	local v103;
	local v104 = 18084 - 6973;
	local v105 = 25892 - 14781;
	local v106;
	local v107 = 0 - 0;
	local v108 = 0 + 0;
	local v109;
	v9:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if (((3038 - 1573) <= (6113 - (1293 + 519))) and (v126 == (0 - 0))) then
				v104 = 29010 - 17899;
				v105 = 21247 - 10136;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		local v127 = 0 - 0;
		local v128;
		local v129;
		while true do
			if (((4014 - 2310) > (755 + 670)) and (v127 == (1 + 0))) then
				if ((v128 > v129) or ((1596 - 909) == (979 + 3255))) then
					return v128;
				end
				return v129;
			end
			if ((v127 == (0 + 0)) or ((2081 + 1249) < (2525 - (709 + 387)))) then
				v128 = v14:GCDRemains();
				v129 = v27(v97.CrusaderStrike:CooldownRemains(), v97.BladeofJustice:CooldownRemains(), v97.Judgment:CooldownRemains(), (v97.HammerofWrath:IsUsable() and v97.HammerofWrath:CooldownRemains()) or (1868 - (673 + 1185)), v97.WakeofAshes:CooldownRemains());
				v127 = 2 - 1;
			end
		end
	end
	local function v111()
		return v14:BuffDown(v97.RetributionAura) and v14:BuffDown(v97.DevotionAura) and v14:BuffDown(v97.ConcentrationAura) and v14:BuffDown(v97.CrusaderAura);
	end
	local v112 = 0 - 0;
	local function v113()
		if (((1886 - 739) >= (240 + 95)) and v97.CleanseToxins:IsReady() and v96.DispellableFriendlyUnit(19 + 6)) then
			local v153 = 0 - 0;
			while true do
				if (((844 + 2591) > (4180 - 2083)) and (v153 == (0 - 0))) then
					if ((v112 == (1880 - (446 + 1434))) or ((5053 - (1040 + 243)) >= (12060 - 8019))) then
						v112 = GetTime();
					end
					if (v96.Wait(2347 - (559 + 1288), v112) or ((5722 - (609 + 1322)) <= (2065 - (13 + 441)))) then
						if (v24(v101.CleanseToxinsFocus) or ((17107 - 12529) <= (5259 - 3251))) then
							return "cleanse_toxins dispel";
						end
						v112 = 0 - 0;
					end
					break;
				end
			end
		end
	end
	local function v114()
		if (((42 + 1083) <= (7539 - 5463)) and v93 and (v14:HealthPercentage() <= v94)) then
			if (v97.FlashofLight:IsReady() or ((264 + 479) >= (1928 + 2471))) then
				if (((3427 - 2272) < (916 + 757)) and v24(v97.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (1 + 0)) or ((1293 + 1031) <= (416 + 162))) then
				if (((3163 + 604) == (3686 + 81)) and v13) then
					local v194 = 433 - (153 + 280);
					while true do
						if (((11807 - 7718) == (3672 + 417)) and (v194 == (1 + 0))) then
							if (((2333 + 2125) >= (1520 + 154)) and v97.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v73)) then
								if (((705 + 267) <= (2159 - 741)) and v24(v101.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v97.BlessingofProtection:IsCastable() and v64 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v72)) or ((3052 + 1886) < (5429 - (89 + 578)))) then
								if (v24(v101.BlessingofProtectionFocus) or ((1789 + 715) > (8864 - 4600))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if (((3202 - (572 + 477)) == (291 + 1862)) and (v194 == (0 + 0))) then
							if ((v97.WordofGlory:IsReady() and v62 and (v13:HealthPercentage() <= v70)) or ((61 + 446) >= (2677 - (84 + 2)))) then
								if (((7384 - 2903) == (3229 + 1252)) and v24(v101.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v97.LayonHands:IsCastable() and v61 and v13:DebuffDown(v97.ForbearanceDebuff) and (v13:HealthPercentage() <= v69)) or ((3170 - (497 + 345)) < (18 + 675))) then
								if (((732 + 3596) == (5661 - (605 + 728))) and v24(v101.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v194 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((3530 - 1942) >= (62 + 1270)) and (v130 == (0 - 0))) then
				if (v15:Exists() or ((3763 + 411) > (11769 - 7521))) then
					if ((v97.WordofGlory:IsReady() and v63 and (v15:HealthPercentage() <= v71)) or ((3463 + 1123) <= (571 - (457 + 32)))) then
						if (((1639 + 2224) == (5265 - (832 + 570))) and v24(v101.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(29 + 1) or ((74 + 208) <= (148 - 106))) then
					return;
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v116()
		local v131 = 796 - (588 + 208);
		while true do
			if (((12422 - 7813) >= (2566 - (884 + 916))) and (v131 == (0 - 0))) then
				v29 = v96.HandleTopTrinket(v99, v32, 24 + 16, nil);
				if (v29 or ((1805 - (232 + 421)) == (4377 - (1569 + 320)))) then
					return v29;
				end
				v131 = 1 + 0;
			end
			if (((651 + 2771) > (11288 - 7938)) and (v131 == (606 - (316 + 289)))) then
				v29 = v96.HandleBottomTrinket(v99, v32, 104 - 64, nil);
				if (((41 + 836) > (1829 - (666 + 787))) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v117()
		local v132 = 425 - (360 + 65);
		while true do
			if ((v132 == (1 + 0)) or ((3372 - (79 + 175)) <= (2918 - 1067))) then
				if ((v97.JusticarsVengeance:IsAvailable() and v97.JusticarsVengeance:IsReady() and v43 and (v107 >= (4 + 0))) or ((505 - 340) >= (6724 - 3232))) then
					if (((4848 - (503 + 396)) < (5037 - (92 + 89))) and v24(v97.JusticarsVengeance, not v16:IsSpellInRange(v97.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v97.FinalVerdict:IsAvailable() and v97.FinalVerdict:IsReady() and v47 and (v107 >= (7 - 3))) or ((2193 + 2083) < (1786 + 1230))) then
					if (((18366 - 13676) > (565 + 3560)) and v24(v97.FinalVerdict, not v16:IsSpellInRange(v97.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v132 = 4 - 2;
			end
			if ((v132 == (0 + 0)) or ((24 + 26) >= (2728 - 1832))) then
				if ((v97.ArcaneTorrent:IsCastable() and v86 and ((v87 and v32) or not v87) and v97.FinalReckoning:IsAvailable()) or ((214 + 1500) >= (4510 - 1552))) then
					if (v24(v97.ArcaneTorrent, not v16:IsInRange(1252 - (485 + 759))) or ((3449 - 1958) < (1833 - (442 + 747)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((1839 - (832 + 303)) < (1933 - (88 + 858))) and v97.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55)) then
					if (((1134 + 2584) > (1578 + 328)) and v24(v97.ShieldofVengeance, not v16:IsInRange(1 + 7))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v132 = 790 - (766 + 23);
			end
			if ((v132 == (19 - 15)) or ((1309 - 351) > (9577 - 5942))) then
				if (((11882 - 8381) <= (5565 - (1036 + 37))) and v97.CrusaderStrike:IsCastable() and v36) then
					if (v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike)) or ((2441 + 1001) < (4961 - 2413))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((2262 + 613) >= (2944 - (641 + 839))) and (v132 == (915 - (910 + 3)))) then
				if ((v97.TemplarsVerdict:IsReady() and v47 and (v107 >= (9 - 5))) or ((6481 - (1466 + 218)) >= (2249 + 2644))) then
					if (v24(v97.TemplarsVerdict, not v16:IsSpellInRange(v97.TemplarsVerdict)) or ((1699 - (556 + 592)) > (736 + 1332))) then
						return "templars verdict precombat 4";
					end
				end
				if (((2922 - (329 + 479)) > (1798 - (174 + 680))) and v97.BladeofJustice:IsCastable() and v34) then
					if (v24(v97.BladeofJustice, not v16:IsSpellInRange(v97.BladeofJustice)) or ((7772 - 5510) >= (6416 - 3320))) then
						return "blade_of_justice precombat 5";
					end
				end
				v132 = 3 + 0;
			end
			if ((v132 == (742 - (396 + 343))) or ((200 + 2055) >= (5014 - (29 + 1448)))) then
				if ((v97.Judgment:IsCastable() and v42) or ((5226 - (135 + 1254)) < (4919 - 3613))) then
					if (((13773 - 10823) == (1966 + 984)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if ((v97.HammerofWrath:IsReady() and v41) or ((6250 - (389 + 1138)) < (3872 - (102 + 472)))) then
					if (((1073 + 63) >= (86 + 68)) and v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v132 = 4 + 0;
			end
		end
	end
	local function v118()
		local v133 = 1545 - (320 + 1225);
		local v134;
		while true do
			if ((v133 == (0 - 0)) or ((166 + 105) > (6212 - (157 + 1307)))) then
				v134 = v96.HandleDPSPotion(v14:BuffUp(v97.AvengingWrathBuff) or (v14:BuffUp(v97.CrusadeBuff) and (v14.BuffStack(v97.Crusade) == (1869 - (821 + 1038)))) or (v105 < (62 - 37)));
				if (((519 + 4221) >= (5598 - 2446)) and v134) then
					return v134;
				end
				v133 = 1 + 0;
			end
			if ((v133 == (7 - 4)) or ((3604 - (834 + 192)) >= (216 + 3174))) then
				if (((11 + 30) <= (36 + 1625)) and v97.ExecutionSentence:IsCastable() and v40 and ((v14:BuffDown(v97.CrusadeBuff) and (v97.Crusade:CooldownRemains() > (23 - 8))) or (v14:BuffStack(v97.CrusadeBuff) == (314 - (300 + 4))) or (v97.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v97.AvengingWrath:CooldownRemains() > (39 - 24))) and (((v107 >= (366 - (112 + 250))) and (v9.CombatTime() < (2 + 3))) or ((v107 >= (7 - 4)) and (v9.CombatTime() > (3 + 2))) or ((v107 >= (2 + 0)) and v97.DivineAuxiliary:IsAvailable())) and (((v105 > (6 + 2)) and not v97.ExecutionersWill:IsAvailable()) or (v105 > (6 + 6)))) then
					if (((447 + 154) < (4974 - (1001 + 413))) and v24(v97.ExecutionSentence, not v16:IsSpellInRange(v97.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((524 - 289) < (1569 - (244 + 638))) and v97.AvengingWrath:IsCastable() and v48 and ((v32 and v52) or not v52) and (((v107 >= (697 - (627 + 66))) and (v9.CombatTime() < (14 - 9))) or ((v107 >= (605 - (512 + 90))) and (v9.CombatTime() > (1911 - (1665 + 241)))) or ((v107 >= (719 - (373 + 344))) and v97.DivineAuxiliary:IsAvailable() and ((v97.ExecutionSentence:IsAvailable() and ((v97.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v97.ExecutionSentence:CooldownRemains() > (4 + 11)) or not v97.ExecutionSentence:IsReady())) or (v97.FinalReckoning:IsAvailable() and ((v97.FinalReckoning:CooldownRemains() == (0 - 0)) or (v97.FinalReckoning:CooldownRemains() > (50 - 20)) or not v97.FinalReckoning:IsReady())))))) then
					if (((5648 - (35 + 1064)) > (839 + 314)) and v24(v97.AvengingWrath, not v16:IsInRange(21 - 11))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v133 = 1 + 3;
			end
			if ((v133 == (1240 - (298 + 938))) or ((5933 - (233 + 1026)) < (6338 - (636 + 1030)))) then
				if (((1876 + 1792) < (4456 + 105)) and v97.Crusade:IsCastable() and v49 and ((v32 and v53) or not v53) and (v14:BuffRemains(v97.CrusadeBuff) < v14:GCD()) and (((v107 >= (2 + 3)) and (v9.CombatTime() < (1 + 4))) or ((v107 >= (224 - (55 + 166))) and (v9.CombatTime() > (1 + 4))))) then
					if (v24(v97.Crusade, not v16:IsInRange(2 + 8)) or ((1737 - 1282) == (3902 - (36 + 261)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v97.FinalReckoning:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v107 >= (6 - 2)) and (v9.CombatTime() < (1376 - (34 + 1334)))) or ((v107 >= (2 + 1)) and (v9.CombatTime() >= (7 + 1))) or ((v107 >= (1285 - (1035 + 248))) and v97.DivineAuxiliary:IsAvailable())) and ((v97.AvengingWrath:CooldownRemains() > (31 - (20 + 1))) or (v97.Crusade:CooldownDown() and (v14:BuffDown(v97.CrusadeBuff) or (v14:BuffStack(v97.CrusadeBuff) >= (6 + 4))))) and ((v106 > (319 - (134 + 185))) or (v107 == (1138 - (549 + 584))) or ((v107 >= (687 - (314 + 371))) and v97.DivineAuxiliary:IsAvailable()))) or ((9141 - 6478) == (4280 - (478 + 490)))) then
					local v195 = 0 + 0;
					while true do
						if (((5449 - (786 + 386)) <= (14494 - 10019)) and ((1379 - (1055 + 324)) == v195)) then
							if ((v95 == "player") or ((2210 - (1093 + 247)) == (1057 + 132))) then
								if (((164 + 1389) <= (12438 - 9305)) and v24(v101.FinalReckoningPlayer, not v16:IsInRange(33 - 23))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v95 == "cursor") or ((6365 - 4128) >= (8822 - 5311))) then
								if (v24(v101.FinalReckoningCursor, not v16:IsInRange(8 + 12)) or ((5100 - 3776) > (10409 - 7389))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v133 == (2 + 0)) or ((7651 - 4659) == (2569 - (364 + 324)))) then
				if (((8514 - 5408) > (3661 - 2135)) and v84 and ((v32 and v85) or not v85) and v16:IsInRange(3 + 5)) then
					local v196 = 0 - 0;
					while true do
						if (((4841 - 1818) < (11753 - 7883)) and (v196 == (1268 - (1249 + 19)))) then
							v29 = v116();
							if (((130 + 13) > (287 - 213)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((1104 - (686 + 400)) < (1658 + 454)) and v97.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55) and (v105 > (244 - (73 + 156))) and (not v97.ExecutionSentence:IsAvailable() or v16:DebuffDown(v97.ExecutionSentence))) then
					if (((6 + 1091) <= (2439 - (721 + 90))) and v24(v97.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v133 = 1 + 2;
			end
			if (((15033 - 10403) == (5100 - (224 + 246))) and ((1 - 0) == v133)) then
				if (((6517 - 2977) > (487 + 2196)) and v97.LightsJudgment:IsCastable() and v86 and ((v87 and v32) or not v87)) then
					if (((115 + 4679) >= (2406 + 869)) and v24(v97.LightsJudgment, not v16:IsInRange(79 - 39))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((4938 - 3454) == (1997 - (203 + 310))) and v97.Fireblood:IsCastable() and v86 and ((v87 and v32) or not v87) and (v14:BuffUp(v97.AvengingWrathBuff) or (v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) == (2003 - (1238 + 755)))))) then
					if (((101 + 1331) < (5089 - (709 + 825))) and v24(v97.Fireblood, not v16:IsInRange(18 - 8))) then
						return "fireblood cooldowns 6";
					end
				end
				v133 = 2 - 0;
			end
		end
	end
	local function v119()
		v109 = ((v103 >= (867 - (196 + 668))) or ((v103 >= (7 - 5)) and not v97.DivineArbiter:IsAvailable()) or v14:BuffUp(v97.EmpyreanPowerBuff)) and v14:BuffDown(v97.EmpyreanLegacyBuff) and not (v14:BuffUp(v97.DivineArbiterBuff) and (v14:BuffStack(v97.DivineArbiterBuff) > (49 - 25)));
		if ((v97.DivineStorm:IsReady() and v38 and v109 and (not v97.Crusade:IsAvailable() or (v97.Crusade:CooldownRemains() > (v108 * (836 - (171 + 662)))) or (v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) < (103 - (4 + 89)))))) or ((3732 - 2667) > (1303 + 2275))) then
			if (v24(v97.DivineStorm, not v16:IsInRange(43 - 33)) or ((1881 + 2914) < (2893 - (35 + 1451)))) then
				return "divine_storm finishers 2";
			end
		end
		if (((3306 - (28 + 1425)) < (6806 - (941 + 1052))) and v97.JusticarsVengeance:IsReady() and v43 and (not v97.Crusade:IsAvailable() or (v97.Crusade:CooldownRemains() > (v108 * (3 + 0))) or (v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) < (1524 - (822 + 692)))))) then
			if (v24(v97.JusticarsVengeance, not v16:IsSpellInRange(v97.JusticarsVengeance)) or ((4027 - 1206) < (1146 + 1285))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v97.FinalVerdict:IsAvailable() and v97.FinalVerdict:IsCastable() and v47 and (not v97.Crusade:IsAvailable() or (v97.Crusade:CooldownRemains() > (v108 * (300 - (45 + 252)))) or (v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) < (10 + 0))))) or ((990 + 1884) < (5307 - 3126))) then
			if (v24(v97.FinalVerdict, not v16:IsSpellInRange(v97.FinalVerdict)) or ((3122 - (114 + 319)) <= (491 - 148))) then
				return "final verdict finishers 6";
			end
		end
		if ((v97.TemplarsVerdict:IsReady() and v47 and (not v97.Crusade:IsAvailable() or (v97.Crusade:CooldownRemains() > (v108 * (3 - 0))) or (v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) < (7 + 3))))) or ((2783 - 914) == (4209 - 2200))) then
			if (v24(v97.TemplarsVerdict, not v16:IsSpellInRange(v97.TemplarsVerdict)) or ((5509 - (556 + 1407)) < (3528 - (741 + 465)))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v120()
		local v135 = 465 - (170 + 295);
		while true do
			if ((v135 == (5 + 3)) or ((1913 + 169) == (11751 - 6978))) then
				if (((2690 + 554) > (677 + 378)) and v97.ArcaneTorrent:IsCastable() and ((v87 and v32) or not v87) and v86 and (v107 < (3 + 2)) and (v83 < v105)) then
					if (v24(v97.ArcaneTorrent, not v16:IsInRange(1240 - (957 + 273))) or ((887 + 2426) <= (712 + 1066))) then
						return "arcane_torrent generators 28";
					end
				end
				if ((v97.Consecration:IsCastable() and v35) or ((5414 - 3993) >= (5544 - 3440))) then
					if (((5534 - 3722) <= (16088 - 12839)) and v24(v97.Consecration, not v16:IsInRange(1790 - (389 + 1391)))) then
						return "consecration generators 30";
					end
				end
				if (((1019 + 604) <= (204 + 1753)) and v97.DivineHammer:IsCastable() and v37) then
					if (((10044 - 5632) == (5363 - (783 + 168))) and v24(v97.DivineHammer, not v16:IsInRange(33 - 23))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((1722 + 28) >= (1153 - (309 + 2))) and (v135 == (18 - 12))) then
				if (((5584 - (1090 + 122)) > (600 + 1250)) and v29) then
					return v29;
				end
				if (((779 - 547) < (562 + 259)) and v97.TemplarSlash:IsReady() and v44) then
					if (((1636 - (628 + 490)) < (162 + 740)) and v24(v97.TemplarSlash, not v16:IsInRange(24 - 14))) then
						return "templar_slash generators 28";
					end
				end
				if (((13682 - 10688) > (1632 - (431 + 343))) and v97.TemplarStrike:IsReady() and v45) then
					if (v24(v97.TemplarStrike, not v16:IsInRange(20 - 10)) or ((10863 - 7108) <= (723 + 192))) then
						return "templar_strike generators 30";
					end
				end
				v135 = 1 + 6;
			end
			if (((5641 - (556 + 1139)) > (3758 - (6 + 9))) and ((2 + 5) == v135)) then
				if ((v97.Judgment:IsReady() and v42 and ((v107 <= (2 + 1)) or not v97.BoundlessJudgment:IsAvailable())) or ((1504 - (28 + 141)) >= (1281 + 2025))) then
					if (((5978 - 1134) > (1596 + 657)) and v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment))) then
						return "judgment generators 32";
					end
				end
				if (((1769 - (486 + 831)) == (1176 - 724)) and v97.HammerofWrath:IsReady() and v41 and ((v107 <= (10 - 7)) or (v16:HealthPercentage() > (4 + 16)) or not v97.VanguardsMomentum:IsAvailable())) then
					if (v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath)) or ((14409 - 9852) < (3350 - (668 + 595)))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((3486 + 388) == (782 + 3092)) and v97.CrusaderStrike:IsCastable() and v36) then
					if (v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike)) or ((5285 - 3347) > (5225 - (23 + 267)))) then
						return "crusader_strike generators 26";
					end
				end
				v135 = 1952 - (1129 + 815);
			end
			if ((v135 == (390 - (371 + 16))) or ((6005 - (1326 + 424)) < (6482 - 3059))) then
				if (((5313 - 3859) <= (2609 - (88 + 30))) and v97.HammerofWrath:IsReady() and v41 and ((v103 < (773 - (720 + 51))) or not v97.BlessedChampion:IsAvailable() or v14:HasTier(66 - 36, 1780 - (421 + 1355))) and ((v107 <= (4 - 1)) or (v16:HealthPercentage() > (10 + 10)) or not v97.VanguardsMomentum:IsAvailable())) then
					if (v24(v97.HammerofWrath, not v16:IsSpellInRange(v97.HammerofWrath)) or ((5240 - (286 + 797)) <= (10246 - 7443))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((8037 - 3184) >= (3421 - (397 + 42))) and v97.TemplarSlash:IsReady() and v44 and ((v97.TemplarStrike:TimeSinceLastCast() + v108) < (2 + 2))) then
					if (((4934 - (24 + 776)) > (5171 - 1814)) and v24(v97.TemplarSlash, not v16:IsSpellInRange(v97.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v97.Judgment:IsReady() and v42 and v16:DebuffDown(v97.JudgmentDebuff) and ((v107 <= (788 - (222 + 563))) or not v97.BoundlessJudgment:IsAvailable())) or ((7528 - 4111) < (1825 + 709))) then
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((2912 - (23 + 167)) <= (1962 - (690 + 1108)))) then
						return "judgment generators 16";
					end
				end
				v135 = 2 + 2;
			end
			if ((v135 == (2 + 0)) or ((3256 - (40 + 808)) < (348 + 1761))) then
				if (((v107 >= (11 - 8)) and v14:BuffUp(v97.CrusadeBuff) and (v14:BuffStack(v97.CrusadeBuff) < (10 + 0))) or ((18 + 15) == (798 + 657))) then
					v29 = v119();
					if (v29 or ((1014 - (47 + 524)) >= (2606 + 1409))) then
						return v29;
					end
				end
				if (((9244 - 5862) > (247 - 81)) and v97.TemplarSlash:IsReady() and v44 and ((v97.TemplarStrike:TimeSinceLastCast() + v108) < (8 - 4)) and (v103 >= (1728 - (1165 + 561)))) then
					if (v24(v97.TemplarSlash, not v16:IsInRange(1 + 9)) or ((867 - 587) == (1168 + 1891))) then
						return "templar_slash generators 8";
					end
				end
				if (((2360 - (341 + 138)) > (350 + 943)) and v97.BladeofJustice:IsCastable() and v34 and ((v107 <= (5 - 2)) or not v97.HolyBlade:IsAvailable()) and (((v103 >= (328 - (89 + 237))) and not v97.CrusadingStrikes:IsAvailable()) or (v103 >= (12 - 8)))) then
					if (((4961 - 2604) == (3238 - (581 + 300))) and v24(v97.BladeofJustice, not v16:IsSpellInRange(v97.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v135 = 1223 - (855 + 365);
			end
			if (((291 - 168) == (41 + 82)) and ((1236 - (1030 + 205)) == v135)) then
				if ((v97.BladeofJustice:IsCastable() and v34 and not v16:DebuffUp(v97.ExpurgationDebuff) and (v107 <= (3 + 0)) and v14:HasTier(29 + 2, 288 - (156 + 130))) or ((2399 - 1343) >= (5716 - 2324))) then
					if (v24(v97.BladeofJustice, not v16:IsSpellInRange(v97.BladeofJustice)) or ((2213 - 1132) < (284 + 791))) then
						return "blade_of_justice generators 4";
					end
				end
				if ((v97.DivineToll:IsCastable() and v39 and (v107 <= (2 + 0)) and ((v97.AvengingWrath:CooldownRemains() > (84 - (10 + 59))) or (v97.Crusade:CooldownRemains() > (5 + 10)) or (v105 < (39 - 31)))) or ((2212 - (671 + 492)) >= (3529 + 903))) then
					if (v24(v97.DivineToll, not v16:IsInRange(1245 - (369 + 846))) or ((1263 + 3505) <= (722 + 124))) then
						return "divine_toll generators 6";
					end
				end
				if ((v97.Judgment:IsReady() and v42 and v16:DebuffUp(v97.ExpurgationDebuff) and v14:BuffDown(v97.EchoesofWrathBuff) and v14:HasTier(1976 - (1036 + 909), 2 + 0)) or ((5637 - 2279) <= (1623 - (11 + 192)))) then
					if (v24(v97.Judgment, not v16:IsSpellInRange(v97.Judgment)) or ((1890 + 1849) <= (3180 - (135 + 40)))) then
						return "judgment generators 7";
					end
				end
				v135 = 4 - 2;
			end
			if ((v135 == (4 + 1)) or ((3654 - 1995) >= (3198 - 1064))) then
				if ((v97.DivineHammer:IsCastable() and v37 and (v103 >= (178 - (50 + 126)))) or ((9077 - 5817) < (522 + 1833))) then
					if (v24(v97.DivineHammer, not v16:IsInRange(1423 - (1233 + 180))) or ((1638 - (522 + 447)) == (5644 - (107 + 1314)))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v97.CrusaderStrike:IsCastable() and v36 and (v97.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v107 <= (5 - 3)) or ((v107 <= (2 + 1)) and (v97.BladeofJustice:CooldownRemains() > (v108 * (3 - 1)))) or ((v107 == (15 - 11)) and (v97.BladeofJustice:CooldownRemains() > (v108 * (1912 - (716 + 1194)))) and (v97.Judgment:CooldownRemains() > (v108 * (1 + 1)))))) or ((182 + 1510) < (1091 - (74 + 429)))) then
					if (v24(v97.CrusaderStrike, not v16:IsSpellInRange(v97.CrusaderStrike)) or ((9253 - 4456) < (1810 + 1841))) then
						return "crusader_strike generators 26";
					end
				end
				v29 = v119();
				v135 = 13 - 7;
			end
			if ((v135 == (3 + 1)) or ((12877 - 8700) > (11992 - 7142))) then
				if ((v97.BladeofJustice:IsCastable() and v34 and ((v107 <= (436 - (279 + 154))) or not v97.HolyBlade:IsAvailable())) or ((1178 - (454 + 324)) > (875 + 236))) then
					if (((3068 - (12 + 5)) > (542 + 463)) and v24(v97.BladeofJustice, not v16:IsSpellInRange(v97.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((9409 - 5716) <= (1620 + 2762)) and ((v16:HealthPercentage() <= (1113 - (277 + 816))) or v14:BuffUp(v97.AvengingWrathBuff) or v14:BuffUp(v97.CrusadeBuff) or v14:BuffUp(v97.EmpyreanPowerBuff))) then
					local v197 = 0 - 0;
					while true do
						if ((v197 == (1183 - (1058 + 125))) or ((616 + 2666) > (5075 - (815 + 160)))) then
							v29 = v119();
							if (v29 or ((15360 - 11780) < (6751 - 3907))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((22 + 67) < (13124 - 8634)) and v97.Consecration:IsCastable() and v35 and v16:DebuffDown(v97.ConsecrationDebuff) and (v103 >= (1900 - (41 + 1857)))) then
					if (v24(v97.Consecration, not v16:IsInRange(1903 - (1222 + 671))) or ((12878 - 7895) < (2598 - 790))) then
						return "consecration generators 22";
					end
				end
				v135 = 1187 - (229 + 953);
			end
			if (((5603 - (1111 + 663)) > (5348 - (874 + 705))) and (v135 == (0 + 0))) then
				if (((1014 + 471) <= (6035 - 3131)) and ((v107 >= (1 + 4)) or (v14:BuffUp(v97.EchoesofWrathBuff) and v14:HasTier(710 - (642 + 37), 1 + 3) and v97.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v97.JudgmentDebuff) or (v107 == (1 + 3))) and v14:BuffUp(v97.DivineResonanceBuff) and not v14:HasTier(77 - 46, 456 - (233 + 221))))) then
					local v198 = 0 - 0;
					while true do
						if (((3758 + 511) == (5810 - (718 + 823))) and (v198 == (0 + 0))) then
							v29 = v119();
							if (((1192 - (266 + 539)) <= (7876 - 5094)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v97.BladeofJustice:IsCastable() and v34 and not v16:DebuffUp(v97.ExpurgationDebuff) and (v107 <= (1228 - (636 + 589))) and v14:HasTier(73 - 42, 3 - 1)) or ((1505 + 394) <= (334 + 583))) then
					if (v24(v97.BladeofJustice, not v16:IsSpellInRange(v97.BladeofJustice)) or ((5327 - (657 + 358)) <= (2319 - 1443))) then
						return "blade_of_justice generators 1";
					end
				end
				if (((5084 - 2852) <= (3783 - (1151 + 36))) and v97.WakeofAshes:IsCastable() and v46 and (v107 <= (2 + 0)) and ((v97.AvengingWrath:CooldownRemains() > (0 + 0)) or (v97.Crusade:CooldownRemains() > (0 - 0)) or not v97.Crusade:IsAvailable() or not v97.AvengingWrath:IsReady()) and (not v97.ExecutionSentence:IsAvailable() or (v97.ExecutionSentence:CooldownRemains() > (1836 - (1552 + 280))) or (v105 < (842 - (64 + 770))) or not v97.ExecutionSentence:IsReady())) then
					if (((1423 + 672) < (8367 - 4681)) and v24(v97.WakeofAshes, not v16:IsInRange(2 + 8))) then
						return "wake_of_ashes generators 2";
					end
				end
				v135 = 1244 - (157 + 1086);
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (21 - 16)) or ((2446 - 851) >= (6106 - 1632))) then
				v54 = EpicSettings.Settings['finalReckoningWithCD'];
				v55 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v136 == (819 - (599 + 220))) or ((9197 - 4578) < (4813 - (1813 + 118)))) then
				v34 = EpicSettings.Settings['useBladeofJustice'];
				v35 = EpicSettings.Settings['useConsecration'];
				v36 = EpicSettings.Settings['useCrusaderStrike'];
				v37 = EpicSettings.Settings['useDivineHammer'];
				v136 = 1 + 0;
			end
			if (((1218 - (841 + 376)) == v136) or ((411 - 117) >= (1123 + 3708))) then
				v38 = EpicSettings.Settings['useDivineStorm'];
				v39 = EpicSettings.Settings['useDivineToll'];
				v40 = EpicSettings.Settings['useExecutionSentence'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v136 = 5 - 3;
			end
			if (((2888 - (464 + 395)) <= (7914 - 4830)) and (v136 == (1 + 1))) then
				v42 = EpicSettings.Settings['useJudgment'];
				v43 = EpicSettings.Settings['useJusticarsVengeance'];
				v44 = EpicSettings.Settings['useTemplarSlash'];
				v45 = EpicSettings.Settings['useTemplarStrike'];
				v136 = 840 - (467 + 370);
			end
			if ((v136 == (8 - 4)) or ((1496 + 541) == (8295 - 5875))) then
				v50 = EpicSettings.Settings['useFinalReckoning'];
				v51 = EpicSettings.Settings['useShieldofVengeance'];
				v52 = EpicSettings.Settings['avengingWrathWithCD'];
				v53 = EpicSettings.Settings['crusadeWithCD'];
				v136 = 1 + 4;
			end
			if (((10371 - 5913) > (4424 - (150 + 370))) and (v136 == (1285 - (74 + 1208)))) then
				v46 = EpicSettings.Settings['useWakeofAshes'];
				v47 = EpicSettings.Settings['useVerdict'];
				v48 = EpicSettings.Settings['useAvengingWrath'];
				v49 = EpicSettings.Settings['useCrusade'];
				v136 = 9 - 5;
			end
		end
	end
	local function v122()
		v56 = EpicSettings.Settings['useRebuke'];
		v57 = EpicSettings.Settings['useHammerofJustice'];
		v58 = EpicSettings.Settings['useDivineProtection'];
		v59 = EpicSettings.Settings['useDivineShield'];
		v60 = EpicSettings.Settings['useLayonHands'];
		v61 = EpicSettings.Settings['useLayonHandsFocus'];
		v62 = EpicSettings.Settings['useWordofGloryFocus'];
		v63 = EpicSettings.Settings['useWordofGloryMouseover'];
		v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v66 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
		v67 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
		v68 = EpicSettings.Settings['layonHandsHP'] or (390 - (14 + 376));
		v69 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
		v70 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
		v71 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 + 0);
		v72 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
		v73 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
		v74 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v75 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v95 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v123()
		local v149 = 0 + 0;
		while true do
			if (((514 - (23 + 55)) >= (291 - 168)) and (v149 == (0 + 0))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v149 = 1 - 0;
			end
			if (((158 + 342) < (2717 - (652 + 249))) and (v149 == (5 - 3))) then
				v85 = EpicSettings.Settings['trinketsWithCD'];
				v87 = EpicSettings.Settings['racialsWithCD'];
				v89 = EpicSettings.Settings['useHealthstone'];
				v88 = EpicSettings.Settings['useHealingPotion'];
				v149 = 1871 - (708 + 1160);
			end
			if (((9701 - 6127) == (6515 - 2941)) and (v149 == (31 - (10 + 17)))) then
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				v93 = EpicSettings.Settings['HealOOC'];
				v94 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
			if (((1953 - (1400 + 332)) < (748 - 358)) and (v149 == (1911 - (242 + 1666)))) then
				v91 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v90 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v92 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v149 = 4 + 0;
			end
			if ((v149 == (941 - (850 + 90))) or ((3875 - 1662) <= (2811 - (360 + 1030)))) then
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v84 = EpicSettings.Settings['useTrinkets'];
				v86 = EpicSettings.Settings['useRacials'];
				v149 = 2 + 0;
			end
		end
	end
	local function v124()
		local v150 = 0 - 0;
		while true do
			if (((4206 - 1148) < (6521 - (909 + 752))) and (v150 == (1232 - (109 + 1114)))) then
				if ((v14:AffectingCombat() and v96.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2372 - 1076) >= (1731 + 2715))) then
					local v199 = 242 - (6 + 236);
					while true do
						if ((v199 == (2 + 0)) or ((1122 + 271) > (10586 - 6097))) then
							if ((v88 and (v14:HealthPercentage() <= v90)) or ((7726 - 3302) < (1160 - (1076 + 57)))) then
								local v209 = 0 + 0;
								while true do
									if ((v209 == (689 - (579 + 110))) or ((158 + 1839) > (3373 + 442))) then
										if (((1839 + 1626) > (2320 - (174 + 233))) and (v92 == "Refreshing Healing Potion")) then
											if (((2047 - 1314) < (3192 - 1373)) and v98.RefreshingHealingPotion:IsReady()) then
												if (v24(v101.RefreshingHealingPotion) or ((1955 + 2440) == (5929 - (663 + 511)))) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v92 == "Dreamwalker's Healing Potion") or ((3384 + 409) < (515 + 1854))) then
											if (v98.DreamwalkersHealingPotion:IsReady() or ((12590 - 8506) == (161 + 104))) then
												if (((10259 - 5901) == (10549 - 6191)) and v24(v101.RefreshingHealingPotion)) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v83 < v105) or ((1498 + 1640) < (1932 - 939))) then
								local v210 = 0 + 0;
								while true do
									if (((305 + 3025) > (3045 - (478 + 244))) and ((518 - (440 + 77)) == v210)) then
										if ((v32 and v98.FyralathTheDreamrender:IsEquippedAndReady()) or ((1649 + 1977) == (14599 - 10610))) then
											if (v24(v101.UseWeapon) or ((2472 - (655 + 901)) == (496 + 2175))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
									if (((209 + 63) == (184 + 88)) and (v210 == (0 - 0))) then
										v29 = v118();
										if (((5694 - (695 + 750)) <= (16523 - 11684)) and v29) then
											return v29;
										end
										v210 = 1 - 0;
									end
								end
							end
							v199 = 11 - 8;
						end
						if (((3128 - (285 + 66)) < (7459 - 4259)) and (v199 == (1313 - (682 + 628)))) then
							v29 = v120();
							if (((16 + 79) < (2256 - (176 + 123))) and v29) then
								return v29;
							end
							v199 = 2 + 2;
						end
						if (((600 + 226) < (1986 - (239 + 30))) and ((0 + 0) == v199)) then
							if (((1371 + 55) >= (1955 - 850)) and v60 and (v14:HealthPercentage() <= v68) and v97.LayonHands:IsReady() and v14:DebuffDown(v97.ForbearanceDebuff)) then
								if (((8592 - 5838) <= (3694 - (306 + 9))) and v24(v97.LayonHands)) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v59 and (v14:HealthPercentage() <= v67) and v97.DivineShield:IsCastable() and v14:DebuffDown(v97.ForbearanceDebuff)) or ((13703 - 9776) == (246 + 1167))) then
								if (v24(v97.DivineShield) or ((709 + 445) <= (380 + 408))) then
									return "divine_shield defensive";
								end
							end
							v199 = 2 - 1;
						end
						if (((1376 - (1140 + 235)) == v199) or ((1046 + 597) > (3099 + 280))) then
							if ((v58 and v97.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v66)) or ((720 + 2083) > (4601 - (33 + 19)))) then
								if (v24(v97.DivineProtection) or ((80 + 140) >= (9057 - 6035))) then
									return "divine_protection defensive";
								end
							end
							if (((1244 + 1578) == (5533 - 2711)) and v98.Healthstone:IsReady() and v89 and (v14:HealthPercentage() <= v91)) then
								if (v24(v101.Healthstone) or ((995 + 66) == (2546 - (586 + 103)))) then
									return "healthstone defensive";
								end
							end
							v199 = 1 + 1;
						end
						if (((8497 - 5737) > (2852 - (1309 + 179))) and (v199 == (6 - 2))) then
							if (v24(v97.Pool) or ((2134 + 2768) <= (9654 - 6059))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v150 == (4 + 1)) or ((8183 - 4331) == (583 - 290))) then
				if (v14:AffectingCombat() or ((2168 - (295 + 314)) == (11268 - 6680))) then
					if ((v97.Intercession:IsCastable() and (v14:HolyPower() >= (1965 - (1300 + 662))) and v97.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((14080 - 9596) == (2543 - (1178 + 577)))) then
						if (((2373 + 2195) >= (11549 - 7642)) and v24(v101.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				if (((2651 - (851 + 554)) < (3069 + 401)) and (v14:AffectingCombat() or (v77 and v97.CleanseToxins:IsAvailable()))) then
					local v200 = 0 - 0;
					local v201;
					while true do
						if (((8834 - 4766) >= (1274 - (115 + 187))) and (v200 == (0 + 0))) then
							v201 = v77 and v97.CleanseToxins:IsReady() and v33;
							v29 = v96.FocusUnit(v201, v101, 19 + 1, nil, 98 - 73);
							v200 = 1162 - (160 + 1001);
						end
						if (((432 + 61) < (2687 + 1206)) and (v200 == (1 - 0))) then
							if (v29 or ((1831 - (237 + 121)) >= (4229 - (525 + 372)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (v33 or ((7680 - 3629) <= (3801 - 2644))) then
					local v202 = 142 - (96 + 46);
					while true do
						if (((1381 - (643 + 134)) < (1041 + 1840)) and (v202 == (0 - 0))) then
							v29 = v96.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 148 - 108, 24 + 1);
							if (v29 or ((1766 - 866) == (6902 - 3525))) then
								return v29;
							end
							v202 = 720 - (316 + 403);
						end
						if (((2964 + 1495) > (1624 - 1033)) and (v202 == (1 + 0))) then
							if (((8557 - 5159) >= (1698 + 697)) and v97.BlessingofFreedom:IsReady() and v96.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
								if (v24(v101.BlessingofFreedomFocus) or ((704 + 1479) >= (9784 - 6960))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				v150 = 28 - 22;
			end
			if (((4021 - 2085) == (111 + 1825)) and (v150 == (15 - 7))) then
				v29 = v115();
				if (v29 or ((237 + 4595) < (12689 - 8376))) then
					return v29;
				end
				if (((4105 - (12 + 5)) > (15046 - 11172)) and not v14:AffectingCombat() and v30 and v96.TargetIsValid()) then
					local v203 = 0 - 0;
					while true do
						if (((9208 - 4876) == (10742 - 6410)) and (v203 == (0 + 0))) then
							v29 = v117();
							if (((5972 - (1656 + 317)) >= (2585 + 315)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v150 = 8 + 1;
			end
			if ((v150 == (10 - 6)) or ((12426 - 9901) > (4418 - (5 + 349)))) then
				if (((20761 - 16390) == (5642 - (266 + 1005))) and not v14:AffectingCombat()) then
					if ((v97.RetributionAura:IsCastable() and (v111())) or ((176 + 90) > (17012 - 12026))) then
						if (((2621 - 630) >= (2621 - (561 + 1135))) and v24(v97.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if (((592 - 137) < (6748 - 4695)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (v14:AffectingCombat() or ((1892 - (507 + 559)) == (12172 - 7321))) then
						if (((565 - 382) == (571 - (212 + 176))) and v97.Intercession:IsCastable()) then
							if (((2064 - (250 + 655)) <= (4875 - 3087)) and v24(v97.Intercession, not v16:IsInRange(52 - 22), true)) then
								return "intercession target";
							end
						end
					elseif (v97.Redemption:IsCastable() or ((5486 - 1979) > (6274 - (1869 + 87)))) then
						if (v24(v97.Redemption, not v16:IsInRange(104 - 74), true) or ((4976 - (484 + 1417)) <= (6355 - 3390))) then
							return "redemption target";
						end
					end
				end
				if (((2287 - 922) <= (2784 - (48 + 725))) and v97.Redemption:IsCastable() and v97.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v24(v101.RedemptionMouseover) or ((4534 - 1758) > (9591 - 6016))) then
						return "redemption mouseover";
					end
				end
				v150 = 3 + 2;
			end
			if ((v150 == (4 - 2)) or ((715 + 1839) == (1401 + 3403))) then
				v33 = EpicSettings.Toggles['dispel'];
				if (((3430 - (152 + 701)) == (3888 - (430 + 881))) and v14:IsDeadOrGhost()) then
					return v29;
				end
				v102 = v14:GetEnemiesInMeleeRange(4 + 4);
				v150 = 898 - (557 + 338);
			end
			if ((v150 == (1 + 2)) or ((16 - 10) >= (6614 - 4725))) then
				if (((1344 - 838) <= (4077 - 2185)) and v31) then
					v103 = #v102;
				else
					local v204 = 801 - (499 + 302);
					while true do
						if (((866 - (39 + 827)) == v204) or ((5542 - 3534) > (4953 - 2735))) then
							v102 = {};
							v103 = 3 - 2;
							break;
						end
					end
				end
				if (((581 - 202) <= (356 + 3791)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if ((v97.CrusaderAura:IsCastable() and (v14:BuffDown(v97.CrusaderAura))) or ((13211 - 8697) <= (162 + 847))) then
						if (v24(v97.CrusaderAura) or ((5531 - 2035) == (1296 - (103 + 1)))) then
							return "crusader_aura";
						end
					end
				end
				v106 = v110();
				v150 = 558 - (475 + 79);
			end
			if ((v150 == (12 - 6)) or ((665 - 457) == (383 + 2576))) then
				if (((3765 + 512) >= (2816 - (1395 + 108))) and (v96.TargetIsValid() or v14:AffectingCombat())) then
					local v205 = 0 - 0;
					while true do
						if (((3791 - (7 + 1197)) < (1384 + 1790)) and (v205 == (1 + 0))) then
							if ((v105 == (11430 - (27 + 292))) or ((12073 - 7953) <= (2802 - 604))) then
								v105 = v9.FightRemains(v102, false);
							end
							v108 = v14:GCD();
							v205 = 8 - 6;
						end
						if ((v205 == (3 - 1)) or ((3039 - 1443) == (997 - (43 + 96)))) then
							v107 = v14:HolyPower();
							break;
						end
						if (((13134 - 9914) == (7280 - 4060)) and (v205 == (0 + 0))) then
							v104 = v9.BossFightRemains(nil, true);
							v105 = v104;
							v205 = 1 + 0;
						end
					end
				end
				if (v78 or ((2770 - 1368) > (1388 + 2232))) then
					local v206 = 0 - 0;
					while true do
						if (((811 + 1763) == (189 + 2385)) and (v206 == (1751 - (1414 + 337)))) then
							if (((3738 - (1642 + 298)) < (7187 - 4430)) and v74) then
								v29 = v96.HandleAfflicted(v97.CleanseToxins, v101.CleanseToxinsMouseover, 115 - 75);
								if (v29 or ((1118 - 741) > (857 + 1747))) then
									return v29;
								end
							end
							if (((442 + 126) < (1883 - (357 + 615))) and v75 and (v107 > (2 + 0))) then
								local v211 = 0 - 0;
								while true do
									if (((2815 + 470) < (9060 - 4832)) and (v211 == (0 + 0))) then
										v29 = v96.HandleAfflicted(v97.WordofGlory, v101.WordofGloryMouseover, 3 + 37, true);
										if (((2462 + 1454) > (4629 - (384 + 917))) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((3197 - (128 + 569)) < (5382 - (1407 + 136))) and v79) then
					local v207 = 1887 - (687 + 1200);
					while true do
						if (((2217 - (556 + 1154)) == (1783 - 1276)) and (v207 == (95 - (9 + 86)))) then
							v29 = v96.HandleIncorporeal(v97.Repentance, v101.RepentanceMouseOver, 451 - (275 + 146), true);
							if (((40 + 200) <= (3229 - (29 + 35))) and v29) then
								return v29;
							end
							v207 = 4 - 3;
						end
						if (((2490 - 1656) >= (3553 - 2748)) and (v207 == (1 + 0))) then
							v29 = v96.HandleIncorporeal(v97.TurnEvil, v101.TurnEvilMouseOver, 1042 - (53 + 959), true);
							if (v29 or ((4220 - (312 + 96)) < (4019 - 1703))) then
								return v29;
							end
							break;
						end
					end
				end
				v150 = 292 - (147 + 138);
			end
			if ((v150 == (900 - (813 + 86))) or ((2397 + 255) <= (2839 - 1306))) then
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v150 = 494 - (18 + 474);
			end
			if ((v150 == (0 + 0)) or ((11743 - 8145) < (2546 - (860 + 226)))) then
				v122();
				v121();
				v123();
				v150 = 304 - (121 + 182);
			end
			if ((v150 == (1 + 6)) or ((5356 - (988 + 252)) < (135 + 1057))) then
				v29 = v114();
				if (v29 or ((1058 + 2319) <= (2873 - (49 + 1921)))) then
					return v29;
				end
				if (((4866 - (223 + 667)) >= (491 - (51 + 1))) and v77 and v33) then
					if (((6457 - 2705) == (8033 - 4281)) and v13) then
						local v208 = 1125 - (146 + 979);
						while true do
							if (((1142 + 2904) > (3300 - (311 + 294))) and (v208 == (0 - 0))) then
								v29 = v113();
								if (v29 or ((1502 + 2043) == (4640 - (496 + 947)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((3752 - (1233 + 125)) > (152 + 221)) and v15 and v15:Exists() and v15:IsAPlayer() and (v96.UnitHasCurseDebuff(v15) or v96.UnitHasPoisonDebuff(v15))) then
						if (((3728 + 427) <= (805 + 3427)) and v97.CleanseToxins:IsReady()) then
							if (v24(v101.CleanseToxinsMouseover) or ((5226 - (963 + 682)) == (2899 + 574))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v150 = 1512 - (504 + 1000);
			end
		end
	end
	local function v125()
		local v151 = 0 + 0;
		while true do
			if (((4549 + 446) > (316 + 3032)) and (v151 == (0 - 0))) then
				v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v100();
				break;
			end
		end
	end
	v20.SetAPL(60 + 10, v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

