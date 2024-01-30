local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((8662 - 5103) <= (32 + 394))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = GetNumGroupMembers;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v96;
	local v97;
	local v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105 = 11702 - (426 + 165);
	local v106 = 8893 + 2218;
	local v107;
	local v108 = v17.Monk.Mistweaver;
	local v109 = v19.Monk.Mistweaver;
	local v110 = v24.Monk.Mistweaver;
	local v111 = {};
	local v112;
	local v113;
	local v114 = {{v108.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v108.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v115 = v21.Commons.Everyone;
	local v116 = v21.Commons.Monk;
	local function v117()
		if (((1531 - (423 + 100)) <= (27 + 3684)) and v108.ImprovedDetox:IsAvailable()) then
			v115.DispellableDebuffs = v20.MergeTable(v115.DispellableMagicDebuffs, v115.DispellablePoisonDebuffs, v115.DispellableDiseaseDebuffs);
		else
			v115.DispellableDebuffs = v115.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v117();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v118()
		if ((v108.DampenHarm:IsCastable() and v12:BuffDown(v108.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) or ((2904 - 1855) <= (473 + 433))) then
			if (((5284 - (326 + 445)) > (11896 - 9170)) and v23(v108.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v108.FortifyingBrew:IsCastable() and v12:BuffDown(v108.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((3299 - 1818) >= (6204 - 3546))) then
			if (v23(v108.FortifyingBrew, nil) or ((3931 - (530 + 181)) == (2245 - (614 + 267)))) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v108.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v108.ChiHarmonyBuff)) or ((1086 - (19 + 13)) > (5520 - 2128))) then
			if (v23(v108.ExpelHarm, nil) or ((1574 - 898) >= (4690 - 3048))) then
				return "expel_harm defensives 3";
			end
		end
		if (((1075 + 3061) > (4215 - 1818)) and v109.Healthstone:IsReady() and v83 and (v12:HealthPercentage() <= v84)) then
			if (v23(v110.Healthstone) or ((8987 - 4653) == (6057 - (1293 + 519)))) then
				return "healthstone defensive 4";
			end
		end
		if ((v85 and (v12:HealthPercentage() <= v86)) or ((8724 - 4448) <= (7913 - 4882))) then
			if ((v87 == "Refreshing Healing Potion") or ((9144 - 4362) <= (5170 - 3971))) then
				if (v109.RefreshingHealingPotion:IsReady() or ((11458 - 6594) < (1008 + 894))) then
					if (((988 + 3851) >= (8597 - 4897)) and v23(v110.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if ((v87 == "Dreamwalker's Healing Potion") or ((249 + 826) > (638 + 1280))) then
				if (((248 + 148) <= (4900 - (709 + 387))) and v109.DreamwalkersHealingPotion:IsReady()) then
					if (v23(v110.RefreshingHealingPotion) or ((6027 - (673 + 1185)) == (6342 - 4155))) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v119()
		if (((4514 - 3108) == (2312 - 906)) and v100) then
			local v178 = 0 + 0;
			while true do
				if (((1144 + 387) < (5766 - 1495)) and (v178 == (0 + 0))) then
					v28 = v115.HandleIncorporeal(v108.Paralysis, v110.ParalysisMouseover, 59 - 29, true);
					if (((1246 - 611) == (2515 - (446 + 1434))) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((4656 - (1040 + 243)) <= (10613 - 7057)) and v99) then
			v28 = v115.HandleAfflicted(v108.Detox, v110.DetoxMouseover, 1877 - (559 + 1288));
			if (v28 or ((5222 - (609 + 1322)) < (3734 - (13 + 441)))) then
				return v28;
			end
		end
		if (((16389 - 12003) >= (2286 - 1413)) and v101) then
			local v179 = 0 - 0;
			while true do
				if (((35 + 886) <= (4002 - 2900)) and (v179 == (1 + 0))) then
					v28 = v115.HandleChromie(v108.HealingSurge, v110.HealingSurgeMouseover, 18 + 22);
					if (((13965 - 9259) >= (527 + 436)) and v28) then
						return v28;
					end
					break;
				end
				if ((v179 == (0 - 0)) or ((635 + 325) <= (488 + 388))) then
					v28 = v115.HandleChromie(v108.Riptide, v110.RiptideMouseover, 29 + 11);
					if (v28 or ((1735 + 331) == (912 + 20))) then
						return v28;
					end
					v179 = 434 - (153 + 280);
				end
			end
		end
		if (((13932 - 9107) < (4349 + 494)) and v102) then
			v28 = v115.HandleCharredTreant(v108.RenewingMist, v110.RenewingMistMouseover, 16 + 24);
			if (v28 or ((2029 + 1848) >= (4118 + 419))) then
				return v28;
			end
			v28 = v115.HandleCharredTreant(v108.SoothingMist, v110.SoothingMistMouseover, 29 + 11);
			if (v28 or ((6570 - 2255) < (1067 + 659))) then
				return v28;
			end
			v28 = v115.HandleCharredTreant(v108.Vivify, v110.VivifyMouseover, 707 - (89 + 578));
			if (v28 or ((2629 + 1050) < (1299 - 674))) then
				return v28;
			end
			v28 = v115.HandleCharredTreant(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 1089 - (572 + 477));
			if (v28 or ((624 + 4001) < (380 + 252))) then
				return v28;
			end
		end
		if (v103 or ((10 + 73) > (1866 - (84 + 2)))) then
			v28 = v115.HandleCharredBrambles(v108.RenewingMist, v110.RenewingMistMouseover, 65 - 25);
			if (((394 + 152) <= (1919 - (497 + 345))) and v28) then
				return v28;
			end
			v28 = v115.HandleCharredBrambles(v108.SoothingMist, v110.SoothingMistMouseover, 2 + 38);
			if (v28 or ((169 + 827) > (5634 - (605 + 728)))) then
				return v28;
			end
			v28 = v115.HandleCharredBrambles(v108.Vivify, v110.VivifyMouseover, 29 + 11);
			if (((9048 - 4978) > (32 + 655)) and v28) then
				return v28;
			end
			v28 = v115.HandleCharredBrambles(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 147 - 107);
			if (v28 or ((592 + 64) >= (9226 - 5896))) then
				return v28;
			end
		end
		if (v104 or ((1882 + 610) <= (824 - (457 + 32)))) then
			local v180 = 0 + 0;
			while true do
				if (((5724 - (832 + 570)) >= (2414 + 148)) and (v180 == (1 + 0))) then
					v28 = v115.HandleFyrakkNPC(v108.SoothingMist, v110.SoothingMistMouseover, 141 - 101);
					if (v28 or ((1752 + 1885) >= (4566 - (588 + 208)))) then
						return v28;
					end
					v180 = 5 - 3;
				end
				if ((v180 == (1803 - (884 + 916))) or ((4980 - 2601) > (2655 + 1923))) then
					v28 = v115.HandleFyrakkNPC(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 693 - (232 + 421));
					if (v28 or ((2372 - (1569 + 320)) > (183 + 560))) then
						return v28;
					end
					break;
				end
				if (((467 + 1987) > (1947 - 1369)) and (v180 == (605 - (316 + 289)))) then
					v28 = v115.HandleFyrakkNPC(v108.RenewingMist, v110.RenewingMistMouseover, 104 - 64);
					if (((43 + 887) < (5911 - (666 + 787))) and v28) then
						return v28;
					end
					v180 = 426 - (360 + 65);
				end
				if (((619 + 43) <= (1226 - (79 + 175))) and (v180 == (2 - 0))) then
					v28 = v115.HandleFyrakkNPC(v108.Vivify, v110.VivifyMouseover, 32 + 8);
					if (((13395 - 9025) == (8416 - 4046)) and v28) then
						return v28;
					end
					v180 = 902 - (503 + 396);
				end
			end
		end
	end
	local function v120()
		local v132 = 181 - (92 + 89);
		while true do
			if ((v132 == (1 - 0)) or ((2443 + 2319) <= (510 + 351))) then
				if ((v108.TigerPalm:IsCastable() and v47) or ((5529 - 4117) == (584 + 3680))) then
					if (v23(v108.TigerPalm, not v14:IsInMeleeRange(11 - 6)) or ((2765 + 403) < (1029 + 1124))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((622 + 4354) < (2030 - 698))) then
				if (((5872 - (485 + 759)) == (10708 - 6080)) and v108.ChiBurst:IsCastable() and v49) then
					if (v23(v108.ChiBurst, not v14:IsInRange(1229 - (442 + 747))) or ((1189 - (832 + 303)) == (1341 - (88 + 858)))) then
						return "chi_burst precombat 4";
					end
				end
				if (((25 + 57) == (68 + 14)) and v108.SpinningCraneKick:IsCastable() and v45 and (v113 >= (1 + 1))) then
					if (v23(v108.SpinningCraneKick, not v14:IsInMeleeRange(797 - (766 + 23))) or ((2868 - 2287) < (385 - 103))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v132 = 2 - 1;
			end
		end
	end
	local function v121()
		if ((v108.SummonWhiteTigerStatue:IsReady() and (v113 >= (10 - 7)) and v43) or ((5682 - (1036 + 37)) < (1769 + 726))) then
			if (((2243 - 1091) == (907 + 245)) and (v42 == "Player")) then
				if (((3376 - (641 + 839)) <= (4335 - (910 + 3))) and v23(v110.SummonWhiteTigerStatuePlayer, not v14:IsInRange(101 - 61))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v42 == "Cursor") or ((2674 - (1466 + 218)) > (745 + 875))) then
				if (v23(v110.SummonWhiteTigerStatueCursor, not v14:IsInRange(1188 - (556 + 592))) or ((312 + 565) > (5503 - (329 + 479)))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((3545 - (174 + 680)) >= (6360 - 4509)) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
				if (v23(v110.SummonWhiteTigerStatueCursor, not v14:IsInRange(82 - 42)) or ((2132 + 853) >= (5595 - (396 + 343)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((379 + 3897) >= (2672 - (29 + 1448))) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
				if (((4621 - (135 + 1254)) <= (17668 - 12978)) and v23(v110.SummonWhiteTigerStatueCursor, not v14:IsInRange(186 - 146))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif ((v42 == "Confirmation") or ((598 + 298) >= (4673 - (389 + 1138)))) then
				if (((3635 - (102 + 472)) >= (2792 + 166)) and v23(v110.SummonWhiteTigerStatue, not v14:IsInRange(23 + 17))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((2972 + 215) >= (2189 - (320 + 1225))) and v108.TouchofDeath:IsCastable() and v50) then
			if (((1145 - 501) <= (431 + 273)) and v23(v108.TouchofDeath, not v14:IsInMeleeRange(1469 - (157 + 1307)))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((2817 - (821 + 1038)) > (2362 - 1415)) and v108.JadefireStomp:IsReady() and v48) then
			if (((492 + 4000) >= (4714 - 2060)) and v23(v108.JadefireStomp, nil)) then
				return "JadefireStomp aoe3";
			end
		end
		if (((1281 + 2161) >= (3725 - 2222)) and v108.ChiBurst:IsCastable() and v49) then
			if (v23(v108.ChiBurst, not v14:IsInRange(1066 - (834 + 192))) or ((202 + 2968) <= (376 + 1088))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v108.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v108.MysticTouchDebuff) and v108.MysticTouch:IsAvailable()) or ((103 + 4694) == (6797 - 2409))) then
			if (((855 - (300 + 4)) <= (182 + 499)) and v23(v108.SpinningCraneKick, not v14:IsInMeleeRange(20 - 12))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((3639 - (112 + 250)) > (163 + 244)) and v108.BlackoutKick:IsCastable() and v108.AncientConcordance:IsAvailable() and v12:BuffUp(v108.JadefireStomp) and v44 and (v113 >= (7 - 4))) then
			if (((2690 + 2005) >= (732 + 683)) and v23(v108.BlackoutKick, not v14:IsInMeleeRange(4 + 1))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v108.TigerPalm:IsCastable() and v108.TeachingsoftheMonastery:IsAvailable() and (v108.BlackoutKick:CooldownRemains() > (0 + 0)) and v47 and (v113 >= (3 + 0))) or ((4626 - (1001 + 413)) <= (2104 - 1160))) then
			if (v23(v108.TigerPalm, not v14:IsInMeleeRange(887 - (244 + 638))) or ((3789 - (627 + 66)) <= (5357 - 3559))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((4139 - (512 + 90)) == (5443 - (1665 + 241))) and v108.SpinningCraneKick:IsCastable() and v45) then
			if (((4554 - (373 + 344)) >= (709 + 861)) and v23(v108.SpinningCraneKick, not v14:IsInMeleeRange(3 + 5))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v122()
		if ((v108.TouchofDeath:IsCastable() and v50) or ((7781 - 4831) == (6450 - 2638))) then
			if (((5822 - (35 + 1064)) >= (1687 + 631)) and v23(v108.TouchofDeath, not v14:IsInMeleeRange(10 - 5))) then
				return "touch_of_death st 1";
			end
		end
		if ((v108.JadefireStomp:IsReady() and v48) or ((9 + 2018) > (4088 - (298 + 938)))) then
			if (v23(v108.JadefireStomp, nil) or ((2395 - (233 + 1026)) > (5983 - (636 + 1030)))) then
				return "JadefireStomp st 2";
			end
		end
		if (((2428 + 2320) == (4638 + 110)) and v108.RisingSunKick:IsReady() and v46) then
			if (((1110 + 2626) <= (321 + 4419)) and v23(v108.RisingSunKick, not v14:IsInMeleeRange(226 - (55 + 166)))) then
				return "rising_sun_kick st 3";
			end
		end
		if ((v108.ChiBurst:IsCastable() and v49) or ((657 + 2733) <= (308 + 2752))) then
			if (v23(v108.ChiBurst, not v14:IsInRange(152 - 112)) or ((1296 - (36 + 261)) > (4708 - 2015))) then
				return "chi_burst st 4";
			end
		end
		if (((1831 - (34 + 1334)) < (232 + 369)) and v108.BlackoutKick:IsCastable() and (v12:BuffStack(v108.TeachingsoftheMonasteryBuff) == (3 + 0)) and (v108.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
			if (v23(v108.BlackoutKick, not v14:IsInMeleeRange(1288 - (1035 + 248))) or ((2204 - (20 + 1)) < (358 + 329))) then
				return "blackout_kick st 5";
			end
		end
		if (((4868 - (134 + 185)) == (5682 - (549 + 584))) and v108.TigerPalm:IsCastable() and ((v12:BuffStack(v108.TeachingsoftheMonasteryBuff) < (688 - (314 + 371))) or (v12:BuffRemains(v108.TeachingsoftheMonasteryBuff) < (6 - 4))) and v47) then
			if (((5640 - (478 + 490)) == (2475 + 2197)) and v23(v108.TigerPalm, not v14:IsInMeleeRange(1177 - (786 + 386)))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v123()
		if ((v51 and v108.RenewingMist:IsReady() and v16:BuffDown(v108.RenewingMistBuff) and (v108.RenewingMist:ChargesFractional() >= (3.8 - 2))) or ((5047 - (1055 + 324)) < (1735 - (1093 + 247)))) then
			if ((v16:HealthPercentage() <= v52) or ((3703 + 463) == (48 + 407))) then
				if (v23(v110.RenewingMistFocus, not v16:IsSpellInRange(v108.RenewingMist)) or ((17663 - 13214) == (9037 - 6374))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v46 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 71 - 46) > (2 - 1))) or ((1522 + 2755) < (11514 - 8525))) then
			if (v23(v108.RisingSunKick, not v14:IsInMeleeRange(17 - 12)) or ((657 + 213) >= (10610 - 6461))) then
				return "RisingSunKick healing st";
			end
		end
		if (((2900 - (364 + 324)) < (8725 - 5542)) and v51 and v108.RenewingMist:IsReady() and v16:BuffDown(v108.RenewingMistBuff)) then
			if (((11148 - 6502) > (992 + 2000)) and (v16:HealthPercentage() <= v52)) then
				if (((6000 - 4566) < (4974 - 1868)) and v23(v110.RenewingMistFocus, not v16:IsSpellInRange(v108.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((2387 - 1601) < (4291 - (1249 + 19))) and v55 and v108.Vivify:IsReady() and v12:BuffUp(v108.VivaciousVivificationBuff)) then
			if ((v16:HealthPercentage() <= v56) or ((2205 + 237) < (287 - 213))) then
				if (((5621 - (686 + 400)) == (3559 + 976)) and v23(v110.VivifyFocus, not v16:IsSpellInRange(v108.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v59 and v108.SoothingMist:IsReady() and v16:BuffDown(v108.SoothingMist)) or ((3238 - (73 + 156)) <= (10 + 2095))) then
			if (((2641 - (721 + 90)) < (42 + 3627)) and (v16:HealthPercentage() <= v60)) then
				if (v23(v110.SoothingMistFocus, not v16:IsSpellInRange(v108.SoothingMist)) or ((4643 - 3213) >= (4082 - (224 + 246)))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v124()
		local v133 = 0 - 0;
		while true do
			if (((4939 - 2256) >= (447 + 2013)) and (v133 == (1 + 1))) then
				if ((v69 and v108.SheilunsGift:IsReady() and v108.SheilunsGift:IsCastable() and v115.AreUnitsBelowHealthPercentage(v71, v70)) or ((1325 + 479) >= (6511 - 3236))) then
					if (v23(v108.SheilunsGift, nil) or ((4715 - 3298) > (4142 - (203 + 310)))) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((6788 - (1238 + 755)) > (29 + 373)) and (v133 == (1534 - (709 + 825)))) then
				if (((8868 - 4055) > (5192 - 1627)) and v46 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 889 - (196 + 668)) > (3 - 2))) then
					if (((8103 - 4191) == (4745 - (171 + 662))) and v23(v108.RisingSunKick, not v14:IsInMeleeRange(98 - (4 + 89)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (((9887 - 7066) <= (1757 + 3067)) and v115.AreUnitsBelowHealthPercentage(v63, v62)) then
					local v221 = 0 - 0;
					while true do
						if (((682 + 1056) <= (3681 - (35 + 1451))) and (v221 == (1453 - (28 + 1425)))) then
							if (((2034 - (941 + 1052)) <= (2894 + 124)) and v35 and (v12:BuffStack(v108.ManaTeaCharges) > v36) and v108.EssenceFont:IsReady() and v108.ManaTea:IsCastable()) then
								if (((3659 - (822 + 692)) <= (5858 - 1754)) and v23(v108.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((1267 + 1422) < (5142 - (45 + 252))) and v37 and v108.ThunderFocusTea:IsReady() and (v108.EssenceFont:CooldownRemains() < v12:GCD())) then
								if (v23(v108.ThunderFocusTea, nil) or ((2298 + 24) > (903 + 1719))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v221 = 2 - 1;
						end
						if ((v221 == (434 - (114 + 319))) or ((6509 - 1975) == (2667 - 585))) then
							if ((v61 and v108.EssenceFont:IsReady() and (v12:BuffUp(v108.ThunderFocusTea) or (v108.ThunderFocusTea:CooldownRemains() > (6 + 2)))) or ((2340 - 769) > (3911 - 2044))) then
								if (v23(v108.EssenceFont, nil) or ((4617 - (556 + 1407)) >= (4202 - (741 + 465)))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
					end
				end
				v133 = 466 - (170 + 295);
			end
			if (((2096 + 1882) > (1933 + 171)) and (v133 == (2 - 1))) then
				if (((2483 + 512) > (989 + 552)) and v61 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v12:BuffDown(v108.EssenceFontBuff)) then
					if (((1840 + 1409) > (2183 - (957 + 273))) and v23(v108.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v66 and v108.ZenPulse:IsReady() and v115.AreUnitsBelowHealthPercentage(v68, v67)) or ((876 + 2397) > (1831 + 2742))) then
					if (v23(v110.ZenPulseFocus, not v16:IsSpellInRange(v108.ZenPulse)) or ((12006 - 8855) < (3383 - 2099))) then
						return "ZenPulse healing aoe";
					end
				end
				v133 = 5 - 3;
			end
		end
	end
	local function v125()
		if ((v57 and v108.EnvelopingMist:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 123 - 98) < (1783 - (389 + 1391)))) or ((1161 + 689) == (160 + 1369))) then
			local v181 = 0 - 0;
			while true do
				if (((1772 - (783 + 168)) < (7124 - 5001)) and (v181 == (1 + 0))) then
					if (((1213 - (309 + 2)) < (7139 - 4814)) and v23(v110.EnvelopingMistFocus, not v16:IsSpellInRange(v108.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
				if (((2070 - (1090 + 122)) <= (961 + 2001)) and ((0 - 0) == v181)) then
					v28 = v115.FocusUnitRefreshableBuff(v108.EnvelopingMist, 2 + 0, 1158 - (628 + 490), nil, false, 5 + 20);
					if (v28 or ((9769 - 5823) < (5886 - 4598))) then
						return v28;
					end
					v181 = 775 - (431 + 343);
				end
			end
		end
		if ((v46 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 50 - 25) > (5 - 3))) or ((2562 + 680) == (73 + 494))) then
			if (v23(v108.RisingSunKick, not v14:IsInMeleeRange(1700 - (556 + 1139))) or ((862 - (6 + 9)) >= (232 + 1031))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if ((v59 and v108.SoothingMist:IsReady() and v16:BuffUp(v108.ChiHarmonyBuff) and v16:BuffDown(v108.SoothingMist)) or ((1155 + 1098) == (2020 - (28 + 141)))) then
			if (v23(v110.SoothingMistFocus, not v16:IsSpellInRange(v108.SoothingMist)) or ((809 + 1278) > (2927 - 555))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v126()
		if ((v44 and v108.BlackoutKick:IsReady() and (v12:BuffStack(v108.TeachingsoftheMonastery) >= (3 + 0))) or ((5762 - (486 + 831)) < (10796 - 6647))) then
			if (v23(v108.BlackoutKick, not v14:IsInMeleeRange(17 - 12)) or ((344 + 1474) == (268 - 183))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((1893 - (668 + 595)) < (1914 + 213)) and v57 and v108.EnvelopingMist:IsReady() and (v12:BuffStack(v108.InvokeChiJiBuff) == (1 + 2))) then
			if ((v16:HealthPercentage() <= v58) or ((5285 - 3347) == (2804 - (23 + 267)))) then
				if (((6199 - (1129 + 815)) >= (442 - (371 + 16))) and v23(v110.EnvelopingMistFocus, not v16:IsSpellInRange(v108.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((4749 - (1326 + 424)) > (2188 - 1032)) and v46 and v108.RisingSunKick:IsReady()) then
			if (((8587 - 6237) > (1273 - (88 + 30))) and v23(v108.RisingSunKick, not v14:IsInMeleeRange(776 - (720 + 51)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((8962 - 4933) <= (6629 - (421 + 1355))) and v57 and v108.EnvelopingMist:IsReady() and (v12:BuffStack(v108.InvokeChiJiBuff) >= (2 - 0))) then
			if ((v16:HealthPercentage() <= v58) or ((254 + 262) > (4517 - (286 + 797)))) then
				if (((14790 - 10744) >= (5023 - 1990)) and v23(v110.EnvelopingMistFocus, not v16:IsSpellInRange(v108.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v61 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v12:BuffDown(v108.AncientTeachings)) or ((3158 - (397 + 42)) <= (452 + 995))) then
			if (v23(v108.EssenceFont, nil) or ((4934 - (24 + 776)) < (6047 - 2121))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v127()
		local v134 = 785 - (222 + 563);
		while true do
			if ((v134 == (0 - 0)) or ((119 + 45) >= (2975 - (23 + 167)))) then
				if ((v78 and v108.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) or ((2323 - (690 + 1108)) == (761 + 1348))) then
					if (((28 + 5) == (881 - (40 + 808))) and v23(v110.LifeCocoonFocus, not v16:IsSpellInRange(v108.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if (((503 + 2551) <= (15353 - 11338)) and v80 and v108.Revival:IsReady() and v108.Revival:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v82, v81)) then
					if (((1789 + 82) < (1790 + 1592)) and v23(v108.Revival, nil)) then
						return "Revival CD";
					end
				end
				v134 = 1 + 0;
			end
			if (((1864 - (47 + 524)) <= (1406 + 760)) and (v134 == (5 - 3))) then
				if ((v108.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (37 - 12)) or ((5881 - 3302) < (1849 - (1165 + 561)))) then
					v28 = v125();
					if (v28 or ((26 + 820) >= (7333 - 4965))) then
						return v28;
					end
				end
				if ((v75 and v108.InvokeChiJiTheRedCrane:IsReady() and v108.InvokeChiJiTheRedCrane:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v77, v76)) or ((1531 + 2481) <= (3837 - (341 + 138)))) then
					local v222 = 0 + 0;
					while true do
						if (((3082 - 1588) <= (3331 - (89 + 237))) and (v222 == (0 - 0))) then
							if ((v51 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (1 - 0))) or ((3992 - (581 + 300)) == (3354 - (855 + 365)))) then
								local v229 = 0 - 0;
								while true do
									if (((769 + 1586) == (3590 - (1030 + 205))) and (v229 == (1 + 0))) then
										if (v23(v110.RenewingMistFocus, not v16:IsSpellInRange(v108.RenewingMist)) or ((547 + 41) <= (718 - (156 + 130)))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
									if (((10899 - 6102) >= (6564 - 2669)) and (v229 == (0 - 0))) then
										v28 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 2 + 4, 24 + 16, nil, false, 94 - (10 + 59));
										if (((1012 + 2565) == (17615 - 14038)) and v28) then
											return v28;
										end
										v229 = 1164 - (671 + 492);
									end
								end
							end
							if (((3021 + 773) > (4908 - (369 + 846))) and v69 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (6 + 14))) then
								if (v23(v108.SheilunsGift, nil) or ((1089 + 186) == (6045 - (1036 + 909)))) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v222 = 1 + 0;
						end
						if ((v222 == (1 - 0)) or ((1794 - (11 + 192)) >= (1810 + 1770))) then
							if (((1158 - (135 + 40)) <= (4380 - 2572)) and v108.InvokeChiJiTheRedCrane:IsReady() and (v108.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v108.AncientTeachings) and (v12:BuffStack(v108.TeachingsoftheMonastery) == (6 - 3)) and (v108.SheilunsGift:TimeSinceLastCast() < ((5 - 1) * v12:GCD()))) then
								if (v23(v108.InvokeChiJiTheRedCrane, nil) or ((2326 - (50 + 126)) <= (3333 - 2136))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v134 = 1 + 2;
			end
			if (((5182 - (1233 + 180)) >= (2142 - (522 + 447))) and (v134 == (1422 - (107 + 1314)))) then
				if (((690 + 795) == (4524 - 3039)) and v80 and v108.Restoral:IsReady() and v108.Restoral:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v82, v81)) then
					if (v23(v108.Restoral, nil) or ((1408 + 1907) <= (5524 - 2742))) then
						return "Restoral CD";
					end
				end
				if ((v72 and v108.InvokeYulonTheJadeSerpent:IsAvailable() and v108.InvokeYulonTheJadeSerpent:IsReady() and v115.AreUnitsBelowHealthPercentage(v74, v73)) or ((3465 - 2589) >= (4874 - (716 + 1194)))) then
					local v223 = 0 + 0;
					while true do
						if ((v223 == (1 + 0)) or ((2735 - (74 + 429)) > (4816 - 2319))) then
							if ((v69 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (10 + 10))) or ((4830 - 2720) <= (235 + 97))) then
								if (((11363 - 7677) > (7842 - 4670)) and v23(v108.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if ((v108.InvokeYulonTheJadeSerpent:IsReady() and (v108.RenewingMist:ChargesFractional() < (434 - (279 + 154))) and v12:BuffUp(v108.ManaTeaBuff) and (v108.SheilunsGift:TimeSinceLastCast() < ((782 - (454 + 324)) * v12:GCD()))) or ((3520 + 954) < (837 - (12 + 5)))) then
								if (((2308 + 1971) >= (7343 - 4461)) and v23(v108.InvokeYulonTheJadeSerpent, nil)) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
						if ((v223 == (0 + 0)) or ((3122 - (277 + 816)) >= (15045 - 11524))) then
							if ((v51 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (1184 - (1058 + 125)))) or ((382 + 1655) >= (5617 - (815 + 160)))) then
								v28 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 25 - 19, 94 - 54, nil, false, 6 + 19);
								if (((5027 - 3307) < (6356 - (41 + 1857))) and v28) then
									return v28;
								end
								if (v23(v110.RenewingMistFocus, not v16:IsSpellInRange(v108.RenewingMist)) or ((2329 - (1222 + 671)) > (7807 - 4786))) then
									return "Renewing Mist YuLon prep";
								end
							end
							if (((1024 - 311) <= (2029 - (229 + 953))) and v35 and v108.ManaTea:IsCastable() and (v12:BuffStack(v108.ManaTeaCharges) >= (1777 - (1111 + 663))) and v12:BuffDown(v108.ManaTeaBuff)) then
								if (((3733 - (874 + 705)) <= (565 + 3466)) and v23(v108.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v223 = 1 + 0;
						end
					end
				end
				v134 = 3 - 1;
			end
			if (((130 + 4485) == (5294 - (642 + 37))) and (v134 == (1 + 2))) then
				if ((v108.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (4 + 21)) or ((9515 - 5725) == (954 - (233 + 221)))) then
					local v224 = 0 - 0;
					while true do
						if (((79 + 10) < (1762 - (718 + 823))) and (v224 == (0 + 0))) then
							v28 = v126();
							if (((2859 - (266 + 539)) >= (4023 - 2602)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v128()
		v35 = EpicSettings.Settings['UseManaTea'];
		v36 = EpicSettings.Settings['ManaTeaStacks'];
		v37 = EpicSettings.Settings['UseThunderFocusTea'];
		v38 = EpicSettings.Settings['UseFortifyingBrew'];
		v39 = EpicSettings.Settings['FortifyingBrewHP'];
		v40 = EpicSettings.Settings['UseDampenHarm'];
		v41 = EpicSettings.Settings['DampenHarmHP'];
		v42 = EpicSettings.Settings['WhiteTigerUsage'];
		v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
		v44 = EpicSettings.Settings['UseBlackoutKick'];
		v45 = EpicSettings.Settings['UseSpinningCraneKick'];
		v46 = EpicSettings.Settings['UseRisingSunKick'];
		v47 = EpicSettings.Settings['UseTigerPalm'];
		v48 = EpicSettings.Settings['UseJadefireStomp'];
		v49 = EpicSettings.Settings['UseChiBurst'];
		v50 = EpicSettings.Settings['UseTouchOfDeath'];
		v51 = EpicSettings.Settings['UseRenewingMist'];
		v52 = EpicSettings.Settings['RenewingMistHP'];
		v53 = EpicSettings.Settings['UseExpelHarm'];
		v54 = EpicSettings.Settings['ExpelHarmHP'];
		v55 = EpicSettings.Settings['UseVivify'];
		v56 = EpicSettings.Settings['VivifyHP'];
		v57 = EpicSettings.Settings['UseEnvelopingMist'];
		v58 = EpicSettings.Settings['EnvelopingMistHP'];
		v59 = EpicSettings.Settings['UseSoothingMist'];
		v60 = EpicSettings.Settings['SoothingMistHP'];
		v61 = EpicSettings.Settings['UseEssenceFont'];
		v63 = EpicSettings.Settings['EssenceFontHP'];
		v62 = EpicSettings.Settings['EssenceFontGroup'];
		v65 = EpicSettings.Settings['UseJadeSerpent'];
		v64 = EpicSettings.Settings['JadeSerpentUsage'];
		v66 = EpicSettings.Settings['UseZenPulse'];
		v68 = EpicSettings.Settings['ZenPulseHP'];
		v67 = EpicSettings.Settings['ZenPulseGroup'];
		v69 = EpicSettings.Settings['UseSheilunsGift'];
		v71 = EpicSettings.Settings['SheilunsGiftHP'];
		v70 = EpicSettings.Settings['SheilunsGiftGroup'];
	end
	local function v129()
		local v172 = 1225 - (636 + 589);
		while true do
			if (((1642 - 950) < (6307 - 3249)) and (v172 == (1 + 0))) then
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v172 = 1 + 1;
			end
			if ((v172 == (1020 - (657 + 358))) or ((8615 - 5361) == (3770 - 2115))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v172 = 1193 - (1151 + 36);
			end
			if ((v172 == (0 + 0)) or ((341 + 955) == (14663 - 9753))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v172 = 1833 - (1552 + 280);
			end
			if (((4202 - (64 + 770)) == (2287 + 1081)) and (v172 == (8 - 4))) then
				v102 = EpicSettings.Settings['HandleCharredTreant'];
				v104 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v172 = 1 + 4;
			end
			if (((3886 - (157 + 1086)) < (7636 - 3821)) and (v172 == (8 - 6))) then
				v84 = EpicSettings.Settings['healthstoneHP'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v172 = 3 - 0;
			end
			if (((2610 - 697) > (1312 - (599 + 220))) and (v172 == (5 - 2))) then
				v93 = EpicSettings.Settings['useLegSweep'];
				v99 = EpicSettings.Settings['handleAfflicted'];
				v100 = EpicSettings.Settings['HandleIncorporeal'];
				v101 = EpicSettings.Settings['HandleChromie'];
				v103 = EpicSettings.Settings['HandleCharredBrambles'];
				v172 = 1935 - (1813 + 118);
			end
			if (((3476 + 1279) > (4645 - (841 + 376))) and (v172 == (7 - 1))) then
				v80 = EpicSettings.Settings['UseRevival'];
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
		end
	end
	local function v130()
		local v173 = 0 + 0;
		while true do
			if (((3769 - 2388) <= (3228 - (464 + 395))) and (v173 == (5 - 3))) then
				if (v12:IsDeadOrGhost() or ((2326 + 2517) == (4921 - (467 + 370)))) then
					return;
				end
				v112 = v12:GetEnemiesInMeleeRange(16 - 8);
				if (((3428 + 1241) > (1244 - 881)) and v30) then
					v113 = #v112;
				else
					v113 = 1 + 0;
				end
				if (v115.TargetIsValid() or v12:AffectingCombat() or ((4366 - 2489) >= (3658 - (150 + 370)))) then
					v107 = v12:GetEnemiesInRange(1322 - (74 + 1208));
					v105 = v9.BossFightRemains(nil, true);
					v106 = v105;
					if (((11662 - 6920) >= (17196 - 13570)) and (v106 == (7907 + 3204))) then
						v106 = v9.FightRemains(v107, false);
					end
				end
				v173 = 393 - (14 + 376);
			end
			if ((v173 == (0 - 0)) or ((2938 + 1602) == (805 + 111))) then
				v128();
				v129();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v173 = 1 + 0;
			end
			if ((v173 == (2 - 1)) or ((870 + 286) > (4423 - (23 + 55)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				v173 = 4 - 2;
			end
			if (((1493 + 744) < (3816 + 433)) and ((4 - 1) == v173)) then
				v28 = v119();
				if (v28 or ((844 + 1839) < (924 - (652 + 249)))) then
					return v28;
				end
				if (((1865 - 1168) <= (2694 - (708 + 1160))) and (v12:AffectingCombat() or v29)) then
					local v225 = v88 and v108.Detox:IsReady() and v32;
					v28 = v115.FocusUnit(v225, nil, nil, nil);
					if (((2999 - 1894) <= (2143 - 967)) and v28) then
						return v28;
					end
					if (((3406 - (10 + 17)) <= (857 + 2955)) and v32 and v88) then
						local v227 = 1732 - (1400 + 332);
						while true do
							if ((v227 == (0 - 0)) or ((2696 - (242 + 1666)) >= (692 + 924))) then
								if (((680 + 1174) <= (2880 + 499)) and v16) then
									if (((5489 - (850 + 90)) == (7966 - 3417)) and v108.Detox:IsCastable() and v115.DispellableFriendlyUnit(1415 - (360 + 1030))) then
										if (v23(v110.DetoxFocus, not v16:IsSpellInRange(v108.Detox)) or ((2675 + 347) >= (8535 - 5511))) then
											return "detox dispel focus";
										end
									end
								end
								if (((6631 - 1811) > (3859 - (909 + 752))) and v15 and v15:Exists() and v15:IsAPlayer() and v115.UnitHasDispellableDebuffByPlayer(v15)) then
									if (v108.Detox:IsCastable() or ((2284 - (109 + 1114)) >= (8954 - 4063))) then
										if (((531 + 833) <= (4715 - (6 + 236))) and v23(v110.DetoxMouseover, not v15:IsSpellInRange(v108.Detox))) then
											return "detox dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
				end
				if (not v12:AffectingCombat() or ((2265 + 1330) <= (3 + 0))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((11017 - 6345) == (6728 - 2876))) then
						local v228 = v115.DeadFriendlyUnitsCount();
						if (((2692 - (1076 + 57)) == (257 + 1302)) and (v228 > (690 - (579 + 110)))) then
							if (v23(v108.Reawaken, nil) or ((139 + 1613) <= (697 + 91))) then
								return "reawaken";
							end
						elseif (v23(v110.ResuscitateMouseover, not v14:IsInRange(22 + 18)) or ((4314 - (174 + 233)) == (494 - 317))) then
							return "resuscitate";
						end
					end
				end
				v173 = 6 - 2;
			end
			if (((1544 + 1926) > (1729 - (663 + 511))) and (v173 == (4 + 0))) then
				if ((not v12:AffectingCombat() and v29) or ((212 + 760) == (1988 - 1343))) then
					v28 = v120();
					if (((1927 + 1255) >= (4979 - 2864)) and v28) then
						return v28;
					end
				end
				if (((9424 - 5531) < (2114 + 2315)) and (v29 or v12:AffectingCombat())) then
					if (v33 or ((5579 - 2712) < (1358 + 547))) then
						if ((v108.SummonJadeSerpentStatue:IsReady() and v108.SummonJadeSerpentStatue:IsAvailable() and (v108.SummonJadeSerpentStatue:TimeSinceLastCast() > (9 + 81)) and v65) or ((2518 - (478 + 244)) >= (4568 - (440 + 77)))) then
							if (((737 + 882) <= (13746 - 9990)) and (v64 == "Player")) then
								if (((2160 - (655 + 901)) == (113 + 491)) and v23(v110.SummonJadeSerpentStatuePlayer, not v14:IsInRange(31 + 9))) then
									return "jade serpent main player";
								end
							elseif ((v64 == "Cursor") or ((3028 + 1456) == (3625 - 2725))) then
								if (v23(v110.SummonJadeSerpentStatueCursor, not v14:IsInRange(1485 - (695 + 750))) or ((15225 - 10766) <= (1716 - 603))) then
									return "jade serpent main cursor";
								end
							elseif (((14606 - 10974) > (3749 - (285 + 66))) and (v64 == "Confirmation")) then
								if (((9514 - 5432) <= (6227 - (682 + 628))) and v23(v108.SummonJadeSerpentStatue, not v14:IsInRange(7 + 33))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((5131 - (176 + 123)) >= (580 + 806)) and v35 and (v12:BuffStack(v108.ManaTeaCharges) >= (14 + 4)) and v108.ManaTea:IsCastable()) then
							if (((406 - (239 + 30)) == (38 + 99)) and v23(v108.ManaTea, nil)) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((v106 > v98) and v31) or ((1509 + 61) >= (7666 - 3334))) then
							v28 = v127();
							if (v28 or ((12679 - 8615) <= (2134 - (306 + 9)))) then
								return v28;
							end
						end
						if (v30 or ((17399 - 12413) < (274 + 1300))) then
							v28 = v124();
							if (((2716 + 1710) > (83 + 89)) and v28) then
								return v28;
							end
						end
						v28 = v123();
						if (((1675 - 1089) > (1830 - (1140 + 235))) and v28) then
							return v28;
						end
					end
				end
				if (((526 + 300) == (758 + 68)) and (v29 or v12:AffectingCombat()) and v115.TargetIsValid() and v12:CanAttack(v14)) then
					local v226 = 0 + 0;
					while true do
						if ((v226 == (53 - (33 + 19))) or ((1452 + 2567) > (13310 - 8869))) then
							if (((889 + 1128) < (8356 - 4095)) and v96 and ((v31 and v97) or not v97)) then
								v28 = v115.HandleTopTrinket(v111, v31, 38 + 2, nil);
								if (((5405 - (586 + 103)) > (8 + 72)) and v28) then
									return v28;
								end
								v28 = v115.HandleBottomTrinket(v111, v31, 123 - 83, nil);
								if (v28 or ((4995 - (1309 + 179)) == (5906 - 2634))) then
									return v28;
								end
							end
							if (v34 or ((382 + 494) >= (8258 - 5183))) then
								if (((3288 + 1064) > (5425 - 2871)) and v94 and ((v31 and v95) or not v95) and (v106 < (35 - 17))) then
									if (v108.BloodFury:IsCastable() or ((5015 - (295 + 314)) < (9930 - 5887))) then
										if (v23(v108.BloodFury, nil) or ((3851 - (1300 + 662)) >= (10622 - 7239))) then
											return "blood_fury main 4";
										end
									end
									if (((3647 - (1178 + 577)) <= (1420 + 1314)) and v108.Berserking:IsCastable()) then
										if (((5684 - 3761) < (3623 - (851 + 554))) and v23(v108.Berserking, nil)) then
											return "berserking main 6";
										end
									end
									if (((1922 + 251) > (1050 - 671)) and v108.LightsJudgment:IsCastable()) then
										if (v23(v108.LightsJudgment, not v14:IsInRange(86 - 46)) or ((2893 - (115 + 187)) == (2611 + 798))) then
											return "lights_judgment main 8";
										end
									end
									if (((4274 + 240) > (13098 - 9774)) and v108.Fireblood:IsCastable()) then
										if (v23(v108.Fireblood, nil) or ((1369 - (160 + 1001)) >= (4224 + 604))) then
											return "fireblood main 10";
										end
									end
									if (v108.AncestralCall:IsCastable() or ((1093 + 490) > (7301 - 3734))) then
										if (v23(v108.AncestralCall, nil) or ((1671 - (237 + 121)) == (1691 - (525 + 372)))) then
											return "ancestral_call main 12";
										end
									end
									if (((6017 - 2843) > (9534 - 6632)) and v108.BagofTricks:IsCastable()) then
										if (((4262 - (96 + 46)) <= (5037 - (643 + 134))) and v23(v108.BagofTricks, not v14:IsInRange(15 + 25))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if ((v37 and v108.ThunderFocusTea:IsReady() and not v108.EssenceFont:IsAvailable() and (v108.RisingSunKick:CooldownRemains() < v12:GCD())) or ((2116 - 1233) > (17739 - 12961))) then
									if (v23(v108.ThunderFocusTea, nil) or ((3472 + 148) >= (9598 - 4707))) then
										return "ThunderFocusTea main 16";
									end
								end
								if (((8703 - 4445) > (1656 - (316 + 403))) and (v113 >= (2 + 1)) and v30) then
									v28 = v121();
									if (v28 or ((13386 - 8517) < (328 + 578))) then
										return v28;
									end
								end
								if ((v113 < (7 - 4)) or ((869 + 356) > (1363 + 2865))) then
									local v230 = 0 - 0;
									while true do
										if (((15894 - 12566) > (4648 - 2410)) and (v230 == (0 + 0))) then
											v28 = v122();
											if (((7556 - 3717) > (69 + 1336)) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((v226 == (0 - 0)) or ((1310 - (12 + 5)) <= (1969 - 1462))) then
							v28 = v118();
							if (v28 or ((6178 - 3282) < (1711 - 906))) then
								return v28;
							end
							v226 = 2 - 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v174 = 0 + 0;
		while true do
			if (((4289 - (1656 + 317)) == (2064 + 252)) and (v174 == (0 + 0))) then
				v117();
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(717 - 447, v130, v131);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

