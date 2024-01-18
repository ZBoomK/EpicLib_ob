local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2845 + 480) >= (8877 - 6723)) and not v5) then
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
	local v104 = 29835 - 18724;
	local v105 = 27726 - 16615;
	local v106;
	local v107 = v17.Monk.Mistweaver;
	local v108 = v19.Monk.Mistweaver;
	local v109 = v24.Monk.Mistweaver;
	local v110 = {};
	local v111;
	local v112;
	local v113 = {{v107.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v107.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v114 = v21.Commons.Everyone;
	local v115 = v21.Commons.Monk;
	local function v116()
		if (v107.ImprovedDetox:IsAvailable() or ((324 + 971) >= (3756 - (423 + 100)))) then
			v114.DispellableDebuffs = v20.MergeTable(v114.DispellableMagicDebuffs, v114.DispellablePoisonDebuffs, v114.DispellableDiseaseDebuffs);
		else
			v114.DispellableDebuffs = v114.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v116();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v117()
		if (((31 + 4346) > (4546 - 2904)) and v107.DampenHarm:IsCastable() and v12:BuffDown(v107.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
			if (((2462 + 2261) > (2127 - (326 + 445))) and v23(v107.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v107.FortifyingBrew:IsCastable() and v12:BuffDown(v107.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((18049 - 13913) <= (7647 - 4214))) then
			if (((9908 - 5663) <= (5342 - (530 + 181))) and v23(v107.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((5157 - (614 + 267)) >= (3946 - (19 + 13))) and v107.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v107.ChiHarmonyBuff)) then
			if (((321 - 123) <= (10171 - 5806)) and v23(v107.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if (((13660 - 8878) > (1215 + 3461)) and v108.Healthstone:IsReady() and v83 and (v12:HealthPercentage() <= v84)) then
			if (((8554 - 3690) > (4555 - 2358)) and v23(v109.Healthstone)) then
				return "healthstone defensive 4";
			end
		end
		if ((v85 and (v12:HealthPercentage() <= v86)) or ((5512 - (1293 + 519)) == (5114 - 2607))) then
			local v142 = 0 - 0;
			while true do
				if (((8555 - 4081) >= (1181 - 907)) and (v142 == (0 - 0))) then
					if ((v87 == "Refreshing Healing Potion") or ((1004 + 890) <= (287 + 1119))) then
						if (((3652 - 2080) >= (354 + 1177)) and v108.RefreshingHealingPotion:IsReady()) then
							if (v23(v109.RefreshingHealingPotion) or ((1558 + 3129) < (2839 + 1703))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((4387 - (709 + 387)) > (3525 - (673 + 1185))) and (v87 == "Dreamwalker's Healing Potion")) then
						if (v108.DreamwalkersHealingPotion:IsReady() or ((2531 - 1658) == (6531 - 4497))) then
							if (v23(v109.RefreshingHealingPotion) or ((4632 - 1816) < (8 + 3))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v118()
		if (((2764 + 935) < (6353 - 1647)) and v100) then
			v28 = v114.HandleIncorporeal(v107.Paralysis, v109.ParalysisMouseover, 8 + 22, true);
			if (((5275 - 2629) >= (1719 - 843)) and v28) then
				return v28;
			end
		end
		if (((2494 - (446 + 1434)) <= (4467 - (1040 + 243))) and v99) then
			local v143 = 0 - 0;
			while true do
				if (((4973 - (559 + 1288)) == (5057 - (609 + 1322))) and (v143 == (454 - (13 + 441)))) then
					v28 = v114.HandleAfflicted(v107.Detox, v109.DetoxMouseover, 112 - 82);
					if (v28 or ((5728 - 3541) >= (24673 - 19719))) then
						return v28;
					end
					break;
				end
			end
		end
		if (v101 or ((145 + 3732) == (12983 - 9408))) then
			local v144 = 0 + 0;
			while true do
				if (((310 + 397) > (1875 - 1243)) and (v144 == (2 + 1))) then
					v28 = v114.HandleCharredTreant(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 73 - 33);
					if (v28 or ((361 + 185) >= (1493 + 1191))) then
						return v28;
					end
					break;
				end
				if (((1053 + 412) <= (3612 + 689)) and (v144 == (0 + 0))) then
					v28 = v114.HandleCharredTreant(v107.RenewingMist, v109.RenewingMistMouseover, 473 - (153 + 280));
					if (((4920 - 3216) > (1280 + 145)) and v28) then
						return v28;
					end
					v144 = 1 + 0;
				end
				if ((v144 == (2 + 0)) or ((624 + 63) == (3068 + 1166))) then
					v28 = v114.HandleCharredTreant(v107.Vivify, v109.VivifyMouseover, 60 - 20);
					if (v28 or ((2059 + 1271) < (2096 - (89 + 578)))) then
						return v28;
					end
					v144 = 3 + 0;
				end
				if (((2384 - 1237) >= (1384 - (572 + 477))) and (v144 == (1 + 0))) then
					v28 = v114.HandleCharredTreant(v107.SoothingMist, v109.SoothingMistMouseover, 25 + 15);
					if (((411 + 3024) > (2183 - (84 + 2))) and v28) then
						return v28;
					end
					v144 = 2 - 0;
				end
			end
		end
		if (v102 or ((2716 + 1054) >= (4883 - (497 + 345)))) then
			local v145 = 0 + 0;
			while true do
				if ((v145 == (1 + 0)) or ((5124 - (605 + 728)) <= (1150 + 461))) then
					v28 = v114.HandleCharredBrambles(v107.SoothingMist, v109.SoothingMistMouseover, 88 - 48);
					if (v28 or ((210 + 4368) <= (7424 - 5416))) then
						return v28;
					end
					v145 = 2 + 0;
				end
				if (((3116 - 1991) <= (1568 + 508)) and (v145 == (489 - (457 + 32)))) then
					v28 = v114.HandleCharredBrambles(v107.RenewingMist, v109.RenewingMistMouseover, 17 + 23);
					if (v28 or ((2145 - (832 + 570)) >= (4145 + 254))) then
						return v28;
					end
					v145 = 1 + 0;
				end
				if (((4087 - 2932) < (806 + 867)) and (v145 == (799 - (588 + 208)))) then
					v28 = v114.HandleCharredBrambles(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 107 - 67);
					if (v28 or ((4124 - (884 + 916)) <= (1209 - 631))) then
						return v28;
					end
					break;
				end
				if (((2185 + 1582) == (4420 - (232 + 421))) and (v145 == (1891 - (1569 + 320)))) then
					v28 = v114.HandleCharredBrambles(v107.Vivify, v109.VivifyMouseover, 10 + 30);
					if (((777 + 3312) == (13778 - 9689)) and v28) then
						return v28;
					end
					v145 = 608 - (316 + 289);
				end
			end
		end
		if (((11669 - 7211) >= (78 + 1596)) and v103) then
			v28 = v114.HandleFyrakkNPC(v107.RenewingMist, v109.RenewingMistMouseover, 1493 - (666 + 787));
			if (((1397 - (360 + 65)) <= (1326 + 92)) and v28) then
				return v28;
			end
			v28 = v114.HandleFyrakkNPC(v107.SoothingMist, v109.SoothingMistMouseover, 294 - (79 + 175));
			if (v28 or ((7785 - 2847) < (3716 + 1046))) then
				return v28;
			end
			v28 = v114.HandleFyrakkNPC(v107.Vivify, v109.VivifyMouseover, 122 - 82);
			if (v28 or ((4821 - 2317) > (5163 - (503 + 396)))) then
				return v28;
			end
			v28 = v114.HandleFyrakkNPC(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 221 - (92 + 89));
			if (((4175 - 2022) == (1105 + 1048)) and v28) then
				return v28;
			end
		end
	end
	local function v119()
		if ((v107.ChiBurst:IsCastable() and v49) or ((301 + 206) >= (10146 - 7555))) then
			if (((613 + 3868) == (10217 - 5736)) and v23(v107.ChiBurst, not v14:IsInRange(35 + 5))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v107.SpinningCraneKick:IsCastable() and v45 and (v112 >= (1 + 1))) or ((7090 - 4762) < (87 + 606))) then
			if (((6600 - 2272) == (5572 - (485 + 759))) and v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(18 - 10))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if (((2777 - (442 + 747)) >= (2467 - (832 + 303))) and v107.TigerPalm:IsCastable() and v47) then
			if (v23(v107.TigerPalm, not v14:IsInMeleeRange(951 - (88 + 858))) or ((1273 + 2901) > (3516 + 732))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v120()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (791 - (766 + 23))) or ((22639 - 18053) <= (111 - 29))) then
				if (((10177 - 6314) == (13111 - 9248)) and v107.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v107.MysticTouchDebuff) and v107.MysticTouch:IsAvailable()) then
					if (v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(1081 - (1036 + 37))) or ((200 + 82) <= (81 - 39))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((3626 + 983) >= (2246 - (641 + 839))) and v107.BlackoutKick:IsCastable() and v107.AncientConcordance:IsAvailable() and v12:BuffUp(v107.JadefireStomp) and v44 and (v112 >= (916 - (910 + 3)))) then
					if (v23(v107.BlackoutKick, not v14:IsInMeleeRange(12 - 7)) or ((2836 - (1466 + 218)) == (1144 + 1344))) then
						return "blackout_kick aoe 6";
					end
				end
				v131 = 1151 - (556 + 592);
			end
			if (((1217 + 2205) > (4158 - (329 + 479))) and (v131 == (855 - (174 + 680)))) then
				if (((3013 - 2136) > (778 - 402)) and v107.JadefireStomp:IsReady() and v48) then
					if (v23(v107.JadefireStomp, nil) or ((2227 + 891) <= (2590 - (396 + 343)))) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v107.ChiBurst:IsCastable() and v49) or ((15 + 150) >= (4969 - (29 + 1448)))) then
					if (((5338 - (135 + 1254)) < (18293 - 13437)) and v23(v107.ChiBurst, not v14:IsInRange(186 - 146))) then
						return "chi_burst aoe 4";
					end
				end
				v131 = 2 + 0;
			end
			if ((v131 == (1530 - (389 + 1138))) or ((4850 - (102 + 472)) < (2847 + 169))) then
				if (((2601 + 2089) > (3847 + 278)) and v107.TigerPalm:IsCastable() and v107.TeachingsoftheMonastery:IsAvailable() and (v107.BlackoutKick:CooldownRemains() > (1545 - (320 + 1225))) and v47 and (v112 >= (5 - 2))) then
					if (v23(v107.TigerPalm, not v14:IsInMeleeRange(4 + 1)) or ((1514 - (157 + 1307)) >= (2755 - (821 + 1038)))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v107.SpinningCraneKick:IsCastable() and v45) or ((4276 - 2562) >= (324 + 2634))) then
					if (v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(13 - 5)) or ((555 + 936) < (1596 - 952))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((1730 - (834 + 192)) < (63 + 924)) and (v131 == (0 + 0))) then
				if (((80 + 3638) > (2952 - 1046)) and v107.SummonWhiteTigerStatue:IsReady() and (v112 >= (307 - (300 + 4))) and v43) then
					if ((v42 == "Player") or ((256 + 702) > (9515 - 5880))) then
						if (((3863 - (112 + 250)) <= (1791 + 2701)) and v23(v109.SummonWhiteTigerStatuePlayer, not v14:IsInRange(100 - 60))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v42 == "Cursor") or ((1972 + 1470) < (1318 + 1230))) then
						if (((2151 + 724) >= (726 + 738)) and v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(30 + 10))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
						if (v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(922 - (244 + 638))) or ((1244 - (627 + 66)) > (6161 - 4093))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((2716 - (512 + 90)) > (2850 - (1665 + 241))) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
						if (v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(757 - (373 + 344))) or ((1021 + 1241) >= (820 + 2276))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v42 == "Confirmation") or ((5948 - 3693) >= (5985 - 2448))) then
						if (v23(v109.SummonWhiteTigerStatue, not v14:IsInRange(1139 - (35 + 1064))) or ((2792 + 1045) < (2794 - 1488))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((12 + 2938) == (4186 - (298 + 938))) and v107.TouchofDeath:IsCastable() and v50) then
					if (v23(v107.TouchofDeath, not v14:IsInMeleeRange(1264 - (233 + 1026))) or ((6389 - (636 + 1030)) < (1687 + 1611))) then
						return "touch_of_death aoe 2";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v121()
		local v132 = 0 + 0;
		while true do
			if (((77 + 1059) >= (375 - (55 + 166))) and (v132 == (1 + 0))) then
				if ((v107.RisingSunKick:IsReady() and v46) or ((28 + 243) > (18132 - 13384))) then
					if (((5037 - (36 + 261)) >= (5511 - 2359)) and v23(v107.RisingSunKick, not v14:IsInMeleeRange(1373 - (34 + 1334)))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v107.ChiBurst:IsCastable() and v49) or ((992 + 1586) >= (2634 + 756))) then
					if (((1324 - (1035 + 248)) <= (1682 - (20 + 1))) and v23(v107.ChiBurst, not v14:IsInRange(21 + 19))) then
						return "chi_burst st 4";
					end
				end
				v132 = 321 - (134 + 185);
			end
			if (((1734 - (549 + 584)) < (4245 - (314 + 371))) and (v132 == (6 - 4))) then
				if (((1203 - (478 + 490)) < (364 + 323)) and v107.BlackoutKick:IsCastable() and (v12:BuffStack(v107.TeachingsoftheMonasteryBuff) == (1175 - (786 + 386))) and (v107.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
					if (((14733 - 10184) > (2532 - (1055 + 324))) and v23(v107.BlackoutKick, not v14:IsInMeleeRange(1345 - (1093 + 247)))) then
						return "blackout_kick st 5";
					end
				end
				if ((v107.TigerPalm:IsCastable() and ((v12:BuffStack(v107.TeachingsoftheMonasteryBuff) < (3 + 0)) or (v12:BuffRemains(v107.TeachingsoftheMonasteryBuff) < (1 + 1))) and v47) or ((18556 - 13882) < (15855 - 11183))) then
					if (((10437 - 6769) < (11461 - 6900)) and v23(v107.TigerPalm, not v14:IsInMeleeRange(2 + 3))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((1568 - 1113) == (2719 + 886))) then
				if ((v107.TouchofDeath:IsCastable() and v50) or ((6810 - 4147) == (4000 - (364 + 324)))) then
					if (((11724 - 7447) <= (10738 - 6263)) and v23(v107.TouchofDeath, not v14:IsInMeleeRange(2 + 3))) then
						return "touch_of_death st 1";
					end
				end
				if ((v107.JadefireStomp:IsReady() and v48) or ((3640 - 2770) == (1903 - 714))) then
					if (((4716 - 3163) <= (4401 - (1249 + 19))) and v23(v107.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v122()
		if ((v51 and v107.RenewingMist:IsReady() and v16:BuffDown(v107.RenewingMistBuff) and (v107.RenewingMist:ChargesFractional() >= (3.8 - 2))) or ((3323 - (686 + 400)) >= (2755 + 756))) then
			if ((v16:HealthPercentage() <= v52) or ((1553 - (73 + 156)) > (15 + 3005))) then
				if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((3803 - (721 + 90)) == (22 + 1859))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((10084 - 6978) > (1996 - (224 + 246))) and v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.RenewingMistBuff, false, false, 40 - 15) > (1 - 0))) then
			if (((549 + 2474) < (93 + 3777)) and v23(v107.RisingSunKick, not v14:IsInMeleeRange(4 + 1))) then
				return "RisingSunKick healing st";
			end
		end
		if (((284 - 141) > (245 - 171)) and v51 and v107.RenewingMist:IsReady() and v16:BuffDown(v107.RenewingMistBuff)) then
			if (((531 - (203 + 310)) < (4105 - (1238 + 755))) and (v16:HealthPercentage() <= v52)) then
				if (((77 + 1020) <= (3162 - (709 + 825))) and v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((8532 - 3902) == (6744 - 2114)) and v55 and v107.Vivify:IsReady() and v12:BuffUp(v107.VivaciousVivificationBuff)) then
			if (((4404 - (196 + 668)) > (10593 - 7910)) and (v16:HealthPercentage() <= v56)) then
				if (((9930 - 5136) >= (4108 - (171 + 662))) and v23(v109.VivifyFocus, not v16:IsSpellInRange(v107.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if (((1577 - (4 + 89)) == (5201 - 3717)) and v59 and v107.SoothingMist:IsReady() and v16:BuffDown(v107.SoothingMist)) then
			if (((522 + 910) < (15614 - 12059)) and (v16:HealthPercentage() <= v60)) then
				if (v23(v109.SoothingMistFocus, not v16:IsSpellInRange(v107.SoothingMist)) or ((418 + 647) > (5064 - (35 + 1451)))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v123()
		local v133 = 1453 - (28 + 1425);
		while true do
			if ((v133 == (1993 - (941 + 1052))) or ((4598 + 197) < (2921 - (822 + 692)))) then
				if (((2644 - 791) < (2268 + 2545)) and v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.RenewingMistBuff, false, false, 322 - (45 + 252)) > (1 + 0))) then
					if (v23(v107.RisingSunKick, not v14:IsInMeleeRange(2 + 3)) or ((6865 - 4044) < (2864 - (114 + 319)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v114.AreUnitsBelowHealthPercentage(v63, v62) or ((4126 - 1252) < (2794 - 613))) then
					if ((v35 and (v12:BuffStack(v107.ManaTeaCharges) > v36) and v107.EssenceFont:IsReady() and v107.ManaTea:IsCastable()) or ((1715 + 974) <= (510 - 167))) then
						if (v23(v107.ManaTea, nil) or ((3915 - 2046) == (3972 - (556 + 1407)))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v37 and v107.ThunderFocusTea:IsReady() and (v107.EssenceFont:CooldownRemains() < v12:GCD())) or ((4752 - (741 + 465)) < (2787 - (170 + 295)))) then
						if (v23(v107.ThunderFocusTea, nil) or ((1097 + 985) == (4385 + 388))) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if (((7986 - 4742) > (875 + 180)) and v61 and v107.EssenceFont:IsReady() and (v12:BuffUp(v107.ThunderFocusTea) or (v107.ThunderFocusTea:CooldownRemains() > (6 + 2)))) then
						if (v23(v107.EssenceFont, nil) or ((1877 + 1436) <= (3008 - (957 + 273)))) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (1 + 0)) or ((5414 - 3993) >= (5544 - 3440))) then
				if (((5534 - 3722) <= (16088 - 12839)) and v61 and v107.EssenceFont:IsReady() and v107.AncientTeachings:IsAvailable() and v12:BuffDown(v107.EssenceFontBuff)) then
					if (((3403 - (389 + 1391)) <= (1228 + 729)) and v23(v107.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if (((460 + 3952) == (10044 - 5632)) and v66 and v107.ZenPulse:IsReady() and v114.AreUnitsBelowHealthPercentage(v68, v67)) then
					if (((2701 - (783 + 168)) >= (2825 - 1983)) and v23(v109.ZenPulseFocus, not v16:IsSpellInRange(v107.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				v133 = 2 + 0;
			end
			if (((4683 - (309 + 2)) > (5681 - 3831)) and (v133 == (1214 - (1090 + 122)))) then
				if (((76 + 156) < (2757 - 1936)) and v69 and v107.SheilunsGift:IsReady() and v107.SheilunsGift:IsCastable() and v114.AreUnitsBelowHealthPercentage(v71, v70)) then
					if (((355 + 163) < (2020 - (628 + 490))) and v23(v107.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v124()
		if (((537 + 2457) > (2124 - 1266)) and v57 and v107.EnvelopingMist:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.EnvelopingMist, false, false, 114 - 89) < (777 - (431 + 343)))) then
			local v146 = 0 - 0;
			while true do
				if ((v146 == (0 - 0)) or ((2967 + 788) <= (118 + 797))) then
					v28 = v114.FocusUnitRefreshableBuff(v107.EnvelopingMist, 1697 - (556 + 1139), 55 - (6 + 9), nil, false, 5 + 20);
					if (((2022 + 1924) > (3912 - (28 + 141))) and v28) then
						return v28;
					end
					v146 = 1 + 0;
				end
				if ((v146 == (1 - 0)) or ((946 + 389) >= (4623 - (486 + 831)))) then
					if (((12605 - 7761) > (7931 - 5678)) and v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
			end
		end
		if (((86 + 366) == (1429 - 977)) and v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.EnvelopingMist, false, false, 1288 - (668 + 595)) > (2 + 0))) then
			if (v23(v107.RisingSunKick, not v14:IsInMeleeRange(2 + 3)) or ((12427 - 7870) < (2377 - (23 + 267)))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((5818 - (1129 + 815)) == (4261 - (371 + 16))) and v59 and v107.SoothingMist:IsReady() and v16:BuffUp(v107.ChiHarmonyBuff) and v16:BuffDown(v107.SoothingMist)) then
			if (v23(v109.SoothingMistFocus, not v16:IsSpellInRange(v107.SoothingMist)) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v125()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (118 - (88 + 30))) or ((5026 - (720 + 51)) < (7614 - 4191))) then
				if (((3230 - (421 + 1355)) <= (4109 - 1618)) and v44 and v107.BlackoutKick:IsReady() and (v12:BuffStack(v107.TeachingsoftheMonastery) >= (2 + 1))) then
					if (v23(v107.BlackoutKick, not v14:IsInMeleeRange(1088 - (286 + 797))) or ((15196 - 11039) <= (4642 - 1839))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((5292 - (397 + 42)) >= (932 + 2050)) and v57 and v107.EnvelopingMist:IsReady() and (v12:BuffStack(v107.InvokeChiJiBuff) == (803 - (24 + 776)))) then
					if (((6368 - 2234) > (4142 - (222 + 563))) and (v16:HealthPercentage() <= v58)) then
						if (v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist)) or ((7528 - 4111) < (1825 + 709))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v134 = 191 - (23 + 167);
			end
			if ((v134 == (1800 - (690 + 1108))) or ((983 + 1739) <= (136 + 28))) then
				if ((v61 and v107.EssenceFont:IsReady() and v107.AncientTeachings:IsAvailable() and v12:BuffDown(v107.AncientTeachings)) or ((3256 - (40 + 808)) < (348 + 1761))) then
					if (v23(v107.EssenceFont, nil) or ((126 - 93) == (1391 + 64))) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if ((v134 == (1 + 0)) or ((243 + 200) >= (4586 - (47 + 524)))) then
				if (((2195 + 1187) > (453 - 287)) and v46 and v107.RisingSunKick:IsReady()) then
					if (v23(v107.RisingSunKick, not v14:IsInMeleeRange(7 - 2)) or ((638 - 358) == (4785 - (1165 + 561)))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((56 + 1825) > (4004 - 2711)) and v57 and v107.EnvelopingMist:IsReady() and (v12:BuffStack(v107.InvokeChiJiBuff) >= (1 + 1))) then
					if (((2836 - (341 + 138)) == (637 + 1720)) and (v16:HealthPercentage() <= v58)) then
						if (((253 - 130) == (449 - (89 + 237))) and v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v134 = 6 - 4;
			end
		end
	end
	local function v126()
		if ((v78 and v107.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) or ((2222 - 1166) >= (4273 - (581 + 300)))) then
			if (v23(v109.LifeCocoonFocus, not v16:IsSpellInRange(v107.LifeCocoon)) or ((2301 - (855 + 365)) < (2553 - 1478))) then
				return "Life Cocoon CD";
			end
		end
		if ((v80 and v107.Revival:IsReady() and v107.Revival:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v82, v81)) or ((343 + 706) >= (5667 - (1030 + 205)))) then
			if (v23(v107.Revival, nil) or ((4477 + 291) <= (788 + 58))) then
				return "Revival CD";
			end
		end
		if ((v80 and v107.Restoral:IsReady() and v107.Restoral:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v82, v81)) or ((3644 - (156 + 130)) <= (3226 - 1806))) then
			if (v23(v107.Restoral, nil) or ((6301 - 2562) <= (6154 - 3149))) then
				return "Restoral CD";
			end
		end
		if ((v72 and v107.InvokeYulonTheJadeSerpent:IsAvailable() and v107.InvokeYulonTheJadeSerpent:IsReady() and v114.AreUnitsBelowHealthPercentage(v74, v73)) or ((438 + 1221) >= (1245 + 889))) then
			if ((v51 and v107.RenewingMist:IsReady() and (v107.RenewingMist:ChargesFractional() >= (70 - (10 + 59)))) or ((923 + 2337) < (11597 - 9242))) then
				v28 = v114.FocusUnitRefreshableBuff(v107.RenewingMistBuff, 1169 - (671 + 492), 32 + 8, nil, false, 1240 - (369 + 846));
				if (v28 or ((178 + 491) == (3604 + 619))) then
					return v28;
				end
				if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((3637 - (1036 + 909)) < (468 + 120))) then
					return "Renewing Mist YuLon prep";
				end
			end
			if ((v35 and v107.ManaTea:IsCastable() and (v12:BuffStack(v107.ManaTeaCharges) >= (4 - 1)) and v12:BuffDown(v107.ManaTeaBuff)) or ((5000 - (11 + 192)) < (1846 + 1805))) then
				if (v23(v107.ManaTea, nil) or ((4352 - (135 + 40)) > (11750 - 6900))) then
					return "ManaTea YuLon prep";
				end
			end
			if ((v69 and v107.SheilunsGift:IsReady() and (v107.SheilunsGift:TimeSinceLastCast() > (13 + 7))) or ((881 - 481) > (1665 - 554))) then
				if (((3227 - (50 + 126)) > (2798 - 1793)) and v23(v107.SheilunsGift, nil)) then
					return "Sheilun's Gift YuLon prep";
				end
			end
			if (((818 + 2875) <= (5795 - (1233 + 180))) and v107.InvokeYulonTheJadeSerpent:IsReady() and (v107.RenewingMist:ChargesFractional() < (970 - (522 + 447))) and v12:BuffUp(v107.ManaTeaBuff) and (v107.SheilunsGift:TimeSinceLastCast() < ((1425 - (107 + 1314)) * v12:GCD()))) then
				if (v23(v107.InvokeYulonTheJadeSerpent, nil) or ((1523 + 1759) > (12493 - 8393))) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if ((v107.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (11 + 14)) or ((7109 - 3529) < (11252 - 8408))) then
			local v147 = 1910 - (716 + 1194);
			while true do
				if (((2 + 87) < (481 + 4009)) and (v147 == (503 - (74 + 429)))) then
					v28 = v124();
					if (v28 or ((9612 - 4629) < (897 + 911))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((8764 - 4935) > (2667 + 1102)) and v75 and v107.InvokeChiJiTheRedCrane:IsReady() and v107.InvokeChiJiTheRedCrane:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v77, v76)) then
			local v148 = 0 - 0;
			while true do
				if (((3671 - 2186) <= (3337 - (279 + 154))) and (v148 == (778 - (454 + 324)))) then
					if (((3359 + 910) == (4286 - (12 + 5))) and v51 and v107.RenewingMist:IsReady() and (v107.RenewingMist:ChargesFractional() >= (1 + 0))) then
						v28 = v114.FocusUnitRefreshableBuff(v107.RenewingMistBuff, 14 - 8, 15 + 25, nil, false, 1118 - (277 + 816));
						if (((1653 - 1266) <= (3965 - (1058 + 125))) and v28) then
							return v28;
						end
						if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((357 + 1542) <= (1892 - (815 + 160)))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if ((v69 and v107.SheilunsGift:IsReady() and (v107.SheilunsGift:TimeSinceLastCast() > (85 - 65))) or ((10235 - 5923) <= (209 + 667))) then
						if (((6524 - 4292) <= (4494 - (41 + 1857))) and v23(v107.SheilunsGift, nil)) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					v148 = 1894 - (1222 + 671);
				end
				if (((5414 - 3319) < (5297 - 1611)) and ((1183 - (229 + 953)) == v148)) then
					if ((v107.InvokeChiJiTheRedCrane:IsReady() and (v107.RenewingMist:ChargesFractional() < (1775 - (1111 + 663))) and v12:BuffUp(v107.AncientTeachings) and (v12:BuffStack(v107.TeachingsoftheMonastery) == (1582 - (874 + 705))) and (v107.SheilunsGift:TimeSinceLastCast() < ((1 + 3) * v12:GCD()))) or ((1089 + 506) >= (9299 - 4825))) then
						if (v23(v107.InvokeChiJiTheRedCrane, nil) or ((130 + 4489) < (3561 - (642 + 37)))) then
							return "Invoke Chi'ji GO";
						end
					end
					break;
				end
			end
		end
		if ((v107.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (6 + 19)) or ((48 + 246) >= (12129 - 7298))) then
			v28 = v125();
			if (((2483 - (233 + 221)) <= (7131 - 4047)) and v28) then
				return v28;
			end
		end
	end
	local function v127()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (1547 - (718 + 823))) or ((1282 + 755) == (3225 - (266 + 539)))) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((12621 - 8163) > (5129 - (636 + 589))) and (v135 == (6 - 3))) then
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v135 = 8 - 4;
			end
			if (((346 + 90) >= (45 + 78)) and (v135 == (1020 - (657 + 358)))) then
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v135 = 15 - 9;
			end
			if (((1139 - 639) < (3003 - (1151 + 36))) and (v135 == (2 + 0))) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v135 = 1 + 2;
			end
			if (((10673 - 7099) == (5406 - (1552 + 280))) and (v135 == (838 - (64 + 770)))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v135 = 4 + 1;
			end
			if (((501 - 280) < (70 + 320)) and (v135 == (1244 - (157 + 1086)))) then
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v135 = 3 - 1;
			end
			if ((v135 == (0 - 0)) or ((3393 - 1180) <= (1939 - 518))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v135 = 820 - (599 + 220);
			end
		end
	end
	local function v128()
		local v136 = 0 - 0;
		while true do
			if (((4989 - (1813 + 118)) < (3553 + 1307)) and (v136 == (1222 - (841 + 376)))) then
				v103 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v136 = 7 - 1;
			end
			if ((v136 == (1 + 1)) or ((3537 - 2241) >= (5305 - (464 + 395)))) then
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v136 = 7 - 4;
			end
			if ((v136 == (2 + 1)) or ((2230 - (467 + 370)) > (9276 - 4787))) then
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v136 = 3 + 1;
			end
			if ((v136 == (20 - 14)) or ((691 + 3733) < (62 - 35))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v136 = 527 - (150 + 370);
			end
			if ((v136 == (1289 - (74 + 1208))) or ((4911 - 2914) > (18092 - 14277))) then
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((2466 + 999) > (2303 - (14 + 376))) and (v136 == (0 - 0))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v136 = 1 + 0;
			end
			if (((644 + 89) < (1735 + 84)) and ((11 - 7) == v136)) then
				v99 = EpicSettings.Settings['handleAfflicted'];
				v100 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleCharredBrambles'];
				v101 = EpicSettings.Settings['HandleCharredTreant'];
				v136 = 4 + 1;
			end
			if ((v136 == (79 - (23 + 55))) or ((10415 - 6020) == (3174 + 1581))) then
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v136 = 2 + 0;
			end
		end
	end
	local function v129()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (1 + 1)) or ((4694 - (652 + 249)) < (6339 - 3970))) then
				if (v12:IsDeadOrGhost() or ((5952 - (708 + 1160)) == (719 - 454))) then
					return;
				end
				v111 = v12:GetEnemiesInMeleeRange(14 - 6);
				if (((4385 - (10 + 17)) == (979 + 3379)) and v30) then
					v112 = #v111;
				else
					v112 = 1733 - (1400 + 332);
				end
				if (v114.TargetIsValid() or v12:AffectingCombat() or ((6018 - 2880) < (2901 - (242 + 1666)))) then
					v106 = v12:GetEnemiesInRange(18 + 22);
					v104 = v9.BossFightRemains(nil, true);
					v105 = v104;
					if (((1221 + 2109) > (1980 + 343)) and (v105 == (12051 - (850 + 90)))) then
						v105 = v9.FightRemains(v106, false);
					end
				end
				v137 = 4 - 1;
			end
			if ((v137 == (1393 - (360 + 1030))) or ((3209 + 417) == (11258 - 7269))) then
				v28 = v118();
				if (v28 or ((1259 - 343) == (4332 - (909 + 752)))) then
					return v28;
				end
				if (((1495 - (109 + 1114)) == (497 - 225)) and (v12:AffectingCombat() or v29)) then
					local v224 = 0 + 0;
					local v225;
					while true do
						if (((4491 - (6 + 236)) <= (3049 + 1790)) and (v224 == (1 + 0))) then
							if (((6548 - 3771) < (5589 - 2389)) and v28) then
								return v28;
							end
							if (((1228 - (1076 + 57)) < (322 + 1635)) and v32 and v88) then
								if (((1515 - (579 + 110)) < (136 + 1581)) and v16) then
									if (((1261 + 165) >= (587 + 518)) and v107.Detox:IsCastable() and v114.DispellableFriendlyUnit(432 - (174 + 233))) then
										if (((7692 - 4938) <= (5930 - 2551)) and v23(v109.DetoxFocus, not v16:IsSpellInRange(v107.Detox))) then
											return "detox dispel focus";
										end
									end
								end
								if ((v15 and v15:Exists() and v15:IsAPlayer() and v114.UnitHasDispellableDebuffByPlayer(v15)) or ((1747 + 2180) == (2587 - (663 + 511)))) then
									if (v107.Detox:IsCastable() or ((1030 + 124) <= (172 + 616))) then
										if (v23(v109.DetoxMouseover, not v15:IsSpellInRange(v107.Detox)) or ((5065 - 3422) > (2047 + 1332))) then
											return "detox dispel mouseover";
										end
									end
								end
							end
							break;
						end
						if ((v224 == (0 - 0)) or ((6785 - 3982) > (2171 + 2378))) then
							v225 = v88 and v107.Detox:IsReady() and v32;
							v28 = v114.FocusUnit(v225, nil, nil, nil);
							v224 = 1 - 0;
						end
					end
				end
				if (not v12:AffectingCombat() or ((157 + 63) >= (277 + 2745))) then
					if (((3544 - (478 + 244)) == (3339 - (440 + 77))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v227 = v114.DeadFriendlyUnitsCount();
						if ((v227 > (1 + 0)) or ((3883 - 2822) == (3413 - (655 + 901)))) then
							if (((512 + 2248) > (1045 + 319)) and v23(v107.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v23(v109.ResuscitateMouseover, not v14:IsInRange(28 + 12)) or ((19748 - 14846) <= (5040 - (695 + 750)))) then
							return "resuscitate";
						end
					end
				end
				v137 = 13 - 9;
			end
			if (((0 - 0) == v137) or ((15491 - 11639) == (644 - (285 + 66)))) then
				v127();
				v128();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v137 = 2 - 1;
			end
			if (((1311 - (682 + 628)) == v137) or ((252 + 1307) == (4887 - (176 + 123)))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				v137 = 1 + 1;
			end
			if ((v137 == (3 + 1)) or ((4753 - (239 + 30)) == (215 + 573))) then
				if (((4391 + 177) >= (6915 - 3008)) and not v12:AffectingCombat() and v29) then
					v28 = v119();
					if (((3887 - 2641) < (3785 - (306 + 9))) and v28) then
						return v28;
					end
				end
				if (((14195 - 10127) >= (170 + 802)) and (v29 or v12:AffectingCombat())) then
					if (((303 + 190) < (1874 + 2019)) and v33) then
						local v228 = 0 - 0;
						while true do
							if ((v228 == (1375 - (1140 + 235))) or ((938 + 535) >= (3056 + 276))) then
								if ((v107.SummonJadeSerpentStatue:IsReady() and v107.SummonJadeSerpentStatue:IsAvailable() and (v107.SummonJadeSerpentStatue:TimeSinceLastCast() > (24 + 66)) and v65) or ((4103 - (33 + 19)) <= (418 + 739))) then
									if (((1810 - 1206) < (1270 + 1611)) and (v64 == "Player")) then
										if (v23(v109.SummonJadeSerpentStatuePlayer, not v14:IsInRange(78 - 38)) or ((844 + 56) == (4066 - (586 + 103)))) then
											return "jade serpent main player";
										end
									elseif (((406 + 4053) > (1819 - 1228)) and (v64 == "Cursor")) then
										if (((4886 - (1309 + 179)) >= (4323 - 1928)) and v23(v109.SummonJadeSerpentStatueCursor, not v14:IsInRange(18 + 22))) then
											return "jade serpent main cursor";
										end
									elseif ((v64 == "Confirmation") or ((5862 - 3679) >= (2134 + 690))) then
										if (((4113 - 2177) == (3857 - 1921)) and v23(v107.SummonJadeSerpentStatue, not v14:IsInRange(649 - (295 + 314)))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if ((v35 and (v12:BuffStack(v107.ManaTeaCharges) >= (43 - 25)) and v107.ManaTea:IsCastable()) or ((6794 - (1300 + 662)) < (13543 - 9230))) then
									if (((5843 - (1178 + 577)) > (2012 + 1862)) and v23(v107.ManaTea, nil)) then
										return "Mana Tea main avoid overcap";
									end
								end
								v228 = 2 - 1;
							end
							if (((5737 - (851 + 554)) == (3831 + 501)) and (v228 == (5 - 3))) then
								v28 = v122();
								if (((8684 - 4685) >= (3202 - (115 + 187))) and v28) then
									return v28;
								end
								break;
							end
							if ((v228 == (1 + 0)) or ((2391 + 134) > (16014 - 11950))) then
								if (((5532 - (160 + 1001)) == (3824 + 547)) and (v105 > v98) and v31) then
									v28 = v126();
									if (v28 or ((184 + 82) > (10206 - 5220))) then
										return v28;
									end
								end
								if (((2349 - (237 + 121)) >= (1822 - (525 + 372))) and v30) then
									v28 = v123();
									if (((862 - 407) < (6745 - 4692)) and v28) then
										return v28;
									end
								end
								v228 = 144 - (96 + 46);
							end
						end
					end
				end
				if (((v29 or v12:AffectingCombat()) and v114.TargetIsValid() and v12:CanAttack(v14)) or ((1603 - (643 + 134)) == (1752 + 3099))) then
					local v226 = 0 - 0;
					while true do
						if (((679 - 496) == (176 + 7)) and (v226 == (0 - 0))) then
							v28 = v117();
							if (((2368 - 1209) <= (2507 - (316 + 403))) and v28) then
								return v28;
							end
							v226 = 1 + 0;
						end
						if ((v226 == (2 - 1)) or ((1268 + 2239) > (10874 - 6556))) then
							if ((v96 and ((v31 and v97) or not v97)) or ((2180 + 895) <= (956 + 2009))) then
								v28 = v114.HandleTopTrinket(v110, v31, 138 - 98, nil);
								if (((6519 - 5154) <= (4177 - 2166)) and v28) then
									return v28;
								end
								v28 = v114.HandleBottomTrinket(v110, v31, 3 + 37, nil);
								if (v28 or ((5464 - 2688) > (175 + 3400))) then
									return v28;
								end
							end
							if (v34 or ((7514 - 4960) == (4821 - (12 + 5)))) then
								if (((10009 - 7432) == (5498 - 2921)) and v94 and ((v31 and v95) or not v95) and (v105 < (38 - 20))) then
									local v229 = 0 - 0;
									while true do
										if ((v229 == (1 + 1)) or ((1979 - (1656 + 317)) >= (1684 + 205))) then
											if (((406 + 100) <= (5030 - 3138)) and v107.AncestralCall:IsCastable()) then
												if (v23(v107.AncestralCall, nil) or ((9882 - 7874) > (2572 - (5 + 349)))) then
													return "ancestral_call main 12";
												end
											end
											if (((1800 - 1421) <= (5418 - (266 + 1005))) and v107.BagofTricks:IsCastable()) then
												if (v23(v107.BagofTricks, not v14:IsInRange(27 + 13)) or ((15402 - 10888) <= (1327 - 318))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
										if ((v229 == (1696 - (561 + 1135))) or ((4555 - 1059) == (3918 - 2726))) then
											if (v107.BloodFury:IsCastable() or ((1274 - (507 + 559)) == (7424 - 4465))) then
												if (((13227 - 8950) >= (1701 - (212 + 176))) and v23(v107.BloodFury, nil)) then
													return "blood_fury main 4";
												end
											end
											if (((3492 - (250 + 655)) < (8655 - 5481)) and v107.Berserking:IsCastable()) then
												if (v23(v107.Berserking, nil) or ((7199 - 3079) <= (3438 - 1240))) then
													return "berserking main 6";
												end
											end
											v229 = 1957 - (1869 + 87);
										end
										if ((v229 == (3 - 2)) or ((3497 - (484 + 1417)) == (1838 - 980))) then
											if (((5396 - 2176) == (3993 - (48 + 725))) and v107.LightsJudgment:IsCastable()) then
												if (v23(v107.LightsJudgment, not v14:IsInRange(65 - 25)) or ((3761 - 2359) > (2104 + 1516))) then
													return "lights_judgment main 8";
												end
											end
											if (((6878 - 4304) == (721 + 1853)) and v107.Fireblood:IsCastable()) then
												if (((524 + 1274) < (3610 - (152 + 701))) and v23(v107.Fireblood, nil)) then
													return "fireblood main 10";
												end
											end
											v229 = 1313 - (430 + 881);
										end
									end
								end
								if ((v37 and v107.ThunderFocusTea:IsReady() and not v107.EssenceFont:IsAvailable() and (v107.RisingSunKick:CooldownRemains() < v12:GCD())) or ((145 + 232) > (3499 - (557 + 338)))) then
									if (((168 + 400) < (2567 - 1656)) and v23(v107.ThunderFocusTea, nil)) then
										return "ThunderFocusTea main 16";
									end
								end
								if (((11503 - 8218) < (11232 - 7004)) and (v112 >= (6 - 3)) and v30) then
									local v230 = 801 - (499 + 302);
									while true do
										if (((4782 - (39 + 827)) > (9186 - 5858)) and (v230 == (0 - 0))) then
											v28 = v120();
											if (((9929 - 7429) < (5893 - 2054)) and v28) then
												return v28;
											end
											break;
										end
									end
								end
								if (((44 + 463) == (1483 - 976)) and (v112 < (1 + 2))) then
									v28 = v121();
									if (((379 - 139) <= (3269 - (103 + 1))) and v28) then
										return v28;
									end
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
	local function v130()
		local v138 = 554 - (475 + 79);
		while true do
			if (((1802 - 968) >= (2576 - 1771)) and (v138 == (0 + 0))) then
				v116();
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(238 + 32, v129, v130);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

