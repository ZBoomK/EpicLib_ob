local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4386 - 2017) == (2337 - (340 + 1571)))) then
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
	local v105;
	local v106;
	local v107;
	local v108;
	local v109 = 4383 + 6728;
	local v110 = 12883 - (1733 + 39);
	local v111;
	local v112 = v17.Monk.Mistweaver;
	local v113 = v19.Monk.Mistweaver;
	local v114 = v24.Monk.Mistweaver;
	local v115 = {};
	local v116;
	local v117;
	local v118 = {{v112.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v112.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v119 = v21.Commons.Everyone;
	local v120 = v21.Commons.Monk;
	local function v121()
		if (v112.ImprovedDetox:IsAvailable() or ((3171 - (51 + 44)) > (898 + 2285))) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellablePoisonDebuffs, v119.DispellableDiseaseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		if (((2519 - (1114 + 203)) > (1784 - (228 + 498))) and v112.DampenHarm:IsCastable() and v12:BuffDown(v112.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
			if (((805 + 2906) > (1854 + 1501)) and v23(v112.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v112.FortifyingBrew:IsCastable() and v12:BuffDown(v112.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((1569 - (174 + 489)) >= (5807 - 3578))) then
			if (((3193 - (830 + 1075)) > (1775 - (303 + 221))) and v23(v112.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v112.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v112.ChiHarmonyBuff)) or ((5782 - (231 + 1038)) < (2794 + 558))) then
			if (v23(v112.ExpelHarm, nil) or ((3227 - (171 + 991)) >= (13171 - 9975))) then
				return "expel_harm defensives 3";
			end
		end
		if ((v113.Healthstone:IsReady() and v113.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) or ((11750 - 7374) <= (3695 - 2214))) then
			if (v23(v114.Healthstone) or ((2715 + 677) >= (16618 - 11877))) then
				return "healthstone defensive 4";
			end
		end
		if (((9591 - 6266) >= (3471 - 1317)) and v85 and (v12:HealthPercentage() <= v86)) then
			local v218 = 0 - 0;
			while true do
				if ((v218 == (1248 - (111 + 1137))) or ((1453 - (91 + 67)) >= (9622 - 6389))) then
					if (((1093 + 3284) > (2165 - (423 + 100))) and (v87 == "Refreshing Healing Potion")) then
						if (((34 + 4689) > (3754 - 2398)) and v113.RefreshingHealingPotion:IsReady() and v113.RefreshingHealingPotion:IsUsable()) then
							if (v23(v114.RefreshingHealingPotion) or ((2156 + 1980) <= (4204 - (326 + 445)))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((18525 - 14280) <= (10316 - 5685)) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((9980 - 5704) >= (4625 - (530 + 181))) and v113.DreamwalkersHealingPotion:IsReady() and v113.DreamwalkersHealingPotion:IsUsable()) then
							if (((1079 - (614 + 267)) <= (4397 - (19 + 13))) and v23(v114.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		if (((7782 - 3000) > (10896 - 6220)) and v100) then
			local v219 = 0 - 0;
			while true do
				if (((1264 + 3600) > (3863 - 1666)) and (v219 == (0 - 0))) then
					v28 = v119.HandleIncorporeal(v112.Paralysis, v114.ParalysisMouseover, 1842 - (1293 + 519), true);
					if (v28 or ((7549 - 3849) == (6545 - 4038))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((8555 - 4081) >= (1181 - 907)) and v99) then
			v28 = v119.HandleAfflicted(v112.Detox, v114.DetoxMouseover, 70 - 40);
			if (v28 or ((1004 + 890) <= (287 + 1119))) then
				return v28;
			end
		end
		if (((3652 - 2080) >= (354 + 1177)) and v101) then
			local v220 = 0 + 0;
			while true do
				if ((v220 == (1 + 0)) or ((5783 - (709 + 387)) < (6400 - (673 + 1185)))) then
					v28 = v119.HandleChromie(v112.HealingSurge, v114.HealingSurgeMouseover, 116 - 76);
					if (((10567 - 7276) > (2742 - 1075)) and v28) then
						return v28;
					end
					break;
				end
				if ((v220 == (0 + 0)) or ((653 + 220) == (2746 - 712))) then
					v28 = v119.HandleChromie(v112.Riptide, v114.RiptideMouseover, 10 + 30);
					if (v28 or ((5614 - 2798) < (21 - 10))) then
						return v28;
					end
					v220 = 1881 - (446 + 1434);
				end
			end
		end
		if (((4982 - (1040 + 243)) < (14045 - 9339)) and v102) then
			v28 = v119.HandleCharredTreant(v112.RenewingMist, v114.RenewingMistMouseover, 1887 - (559 + 1288));
			if (((4577 - (609 + 1322)) >= (1330 - (13 + 441))) and v28) then
				return v28;
			end
			v28 = v119.HandleCharredTreant(v112.SoothingMist, v114.SoothingMistMouseover, 149 - 109);
			if (((1608 - 994) <= (15857 - 12673)) and v28) then
				return v28;
			end
			v28 = v119.HandleCharredTreant(v112.Vivify, v114.VivifyMouseover, 2 + 38);
			if (((11352 - 8226) == (1111 + 2015)) and v28) then
				return v28;
			end
			v28 = v119.HandleCharredTreant(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 18 + 22);
			if (v28 or ((6489 - 4302) >= (2711 + 2243))) then
				return v28;
			end
		end
		if (v103 or ((7130 - 3253) == (2364 + 1211))) then
			v28 = v119.HandleCharredBrambles(v112.RenewingMist, v114.RenewingMistMouseover, 23 + 17);
			if (((508 + 199) > (531 + 101)) and v28) then
				return v28;
			end
			v28 = v119.HandleCharredBrambles(v112.SoothingMist, v114.SoothingMistMouseover, 40 + 0);
			if (v28 or ((979 - (153 + 280)) >= (7750 - 5066))) then
				return v28;
			end
			v28 = v119.HandleCharredBrambles(v112.Vivify, v114.VivifyMouseover, 36 + 4);
			if (((579 + 886) <= (2251 + 2050)) and v28) then
				return v28;
			end
			v28 = v119.HandleCharredBrambles(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 37 + 3);
			if (((1235 + 469) > (2169 - 744)) and v28) then
				return v28;
			end
		end
		if (v104 or ((425 + 262) == (4901 - (89 + 578)))) then
			local v221 = 0 + 0;
			while true do
				if ((v221 == (5 - 2)) or ((4379 - (572 + 477)) < (193 + 1236))) then
					v28 = v119.HandleFyrakkNPC(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 25 + 15);
					if (((137 + 1010) >= (421 - (84 + 2))) and v28) then
						return v28;
					end
					break;
				end
				if (((5661 - 2226) > (1511 + 586)) and (v221 == (844 - (497 + 345)))) then
					v28 = v119.HandleFyrakkNPC(v112.Vivify, v114.VivifyMouseover, 2 + 38);
					if (v28 or ((638 + 3132) >= (5374 - (605 + 728)))) then
						return v28;
					end
					v221 = 3 + 0;
				end
				if ((v221 == (1 - 0)) or ((174 + 3617) <= (5956 - 4345))) then
					v28 = v119.HandleFyrakkNPC(v112.SoothingMist, v114.SoothingMistMouseover, 37 + 3);
					if (v28 or ((12683 - 8105) <= (1517 + 491))) then
						return v28;
					end
					v221 = 491 - (457 + 32);
				end
				if (((478 + 647) <= (3478 - (832 + 570))) and (v221 == (0 + 0))) then
					v28 = v119.HandleFyrakkNPC(v112.RenewingMist, v114.RenewingMistMouseover, 11 + 29);
					if (v28 or ((2629 - 1886) >= (2120 + 2279))) then
						return v28;
					end
					v221 = 797 - (588 + 208);
				end
			end
		end
	end
	local function v124()
		if (((3112 - 1957) < (3473 - (884 + 916))) and v112.ChiBurst:IsCastable() and v49) then
			if (v23(v112.ChiBurst, not v14:IsInRange(83 - 43)) or ((1348 + 976) <= (1231 - (232 + 421)))) then
				return "chi_burst precombat 4";
			end
		end
		if (((5656 - (1569 + 320)) == (925 + 2842)) and v112.SpinningCraneKick:IsCastable() and v45 and (v117 >= (1 + 1))) then
			if (((13778 - 9689) == (4694 - (316 + 289))) and v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(20 - 12))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if (((206 + 4252) >= (3127 - (666 + 787))) and v112.TigerPalm:IsCastable() and v47) then
			if (((1397 - (360 + 65)) <= (1326 + 92)) and v23(v112.TigerPalm, not v14:IsInMeleeRange(259 - (79 + 175)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v125()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (2 + 0)) or ((15136 - 10198) < (9170 - 4408))) then
				if ((v112.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v112.MysticTouchDebuff) and v112.MysticTouch:IsAvailable()) or ((3403 - (503 + 396)) > (4445 - (92 + 89)))) then
					if (((4175 - 2022) == (1105 + 1048)) and v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(5 + 3))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v112.BlackoutKick:IsCastable() and v112.AncientConcordance:IsAvailable() and v12:BuffUp(v112.JadefireStomp) and v44 and (v117 >= (11 - 8))) or ((70 + 437) >= (5907 - 3316))) then
					if (((3910 + 571) == (2141 + 2340)) and v23(v112.BlackoutKick, not v14:IsInMeleeRange(15 - 10))) then
						return "blackout_kick aoe 6";
					end
				end
				v137 = 1 + 2;
			end
			if (((1 - 0) == v137) or ((3572 - (485 + 759)) < (1603 - 910))) then
				if (((5517 - (442 + 747)) == (5463 - (832 + 303))) and v112.JadefireStomp:IsReady() and v48) then
					if (((2534 - (88 + 858)) >= (406 + 926)) and v23(v112.JadefireStomp, nil)) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v112.ChiBurst:IsCastable() and v49) or ((3455 + 719) > (175 + 4073))) then
					if (v23(v112.ChiBurst, not v14:IsInRange(829 - (766 + 23))) or ((22639 - 18053) <= (111 - 29))) then
						return "chi_burst aoe 4";
					end
				end
				v137 = 4 - 2;
			end
			if (((13111 - 9248) == (4936 - (1036 + 37))) and (v137 == (0 + 0))) then
				if ((v112.SummonWhiteTigerStatue:IsReady() and (v117 >= (5 - 2)) and v43) or ((222 + 60) <= (1522 - (641 + 839)))) then
					if (((5522 - (910 + 3)) >= (1952 - 1186)) and (v42 == "Player")) then
						if (v23(v114.SummonWhiteTigerStatuePlayer, not v14:IsInRange(1724 - (1466 + 218))) or ((530 + 622) == (3636 - (556 + 592)))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((1217 + 2205) > (4158 - (329 + 479))) and (v42 == "Cursor")) then
						if (((1731 - (174 + 680)) > (1291 - 915)) and v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(82 - 42))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((2227 + 891) <= (2590 - (396 + 343)))) then
						if (v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(4 + 36)) or ((1642 - (29 + 1448)) >= (4881 - (135 + 1254)))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((14876 - 10927) < (22673 - 17817)) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
						if (v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(27 + 13)) or ((5803 - (389 + 1138)) < (3590 - (102 + 472)))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif (((4426 + 264) > (2288 + 1837)) and (v42 == "Confirmation")) then
						if (v23(v114.SummonWhiteTigerStatue, not v14:IsInRange(38 + 2)) or ((1595 - (320 + 1225)) >= (1594 - 698))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v112.TouchofDeath:IsCastable() and v50) or ((1049 + 665) >= (4422 - (157 + 1307)))) then
					if (v23(v112.TouchofDeath, not v14:IsInMeleeRange(1864 - (821 + 1038))) or ((3719 - 2228) < (71 + 573))) then
						return "touch_of_death aoe 2";
					end
				end
				v137 = 1 - 0;
			end
			if (((262 + 442) < (2446 - 1459)) and (v137 == (1029 - (834 + 192)))) then
				if (((237 + 3481) > (490 + 1416)) and v112.TigerPalm:IsCastable() and v112.TeachingsoftheMonastery:IsAvailable() and (v112.BlackoutKick:CooldownRemains() > (0 + 0)) and v47 and (v117 >= (4 - 1))) then
					if (v23(v112.TigerPalm, not v14:IsInMeleeRange(309 - (300 + 4))) or ((256 + 702) > (9515 - 5880))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((3863 - (112 + 250)) <= (1791 + 2701)) and v112.SpinningCraneKick:IsCastable() and v45) then
					if (v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(19 - 11)) or ((1972 + 1470) < (1318 + 1230))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v138 = 0 + 0;
		while true do
			if (((1426 + 1449) >= (1088 + 376)) and (v138 == (1415 - (1001 + 413)))) then
				if ((v112.RisingSunKick:IsReady() and v46) or ((10697 - 5900) >= (5775 - (244 + 638)))) then
					if (v23(v112.RisingSunKick, not v14:IsInMeleeRange(698 - (627 + 66))) or ((1641 - 1090) > (2670 - (512 + 90)))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((4020 - (1665 + 241)) > (1661 - (373 + 344))) and v112.ChiBurst:IsCastable() and v49) then
					if (v23(v112.ChiBurst, not v14:IsInRange(19 + 21)) or ((599 + 1663) >= (8166 - 5070))) then
						return "chi_burst st 4";
					end
				end
				v138 = 2 - 0;
			end
			if (((1099 - (35 + 1064)) == v138) or ((1641 + 614) >= (7567 - 4030))) then
				if ((v112.TouchofDeath:IsCastable() and v50) or ((16 + 3821) < (2542 - (298 + 938)))) then
					if (((4209 - (233 + 1026)) == (4616 - (636 + 1030))) and v23(v112.TouchofDeath, not v14:IsInMeleeRange(3 + 2))) then
						return "touch_of_death st 1";
					end
				end
				if ((v112.JadefireStomp:IsReady() and v48) or ((4614 + 109) < (980 + 2318))) then
					if (((77 + 1059) >= (375 - (55 + 166))) and v23(v112.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (1 + 1)) or ((1034 - 763) > (5045 - (36 + 261)))) then
				if (((8289 - 3549) >= (4520 - (34 + 1334))) and v112.BlackoutKick:IsCastable() and (v12:BuffStack(v112.TeachingsoftheMonasteryBuff) == (2 + 1)) and (v112.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
					if (v23(v112.BlackoutKick, not v14:IsInMeleeRange(4 + 1)) or ((3861 - (1035 + 248)) >= (3411 - (20 + 1)))) then
						return "blackout_kick st 5";
					end
				end
				if (((22 + 19) <= (1980 - (134 + 185))) and v112.TigerPalm:IsCastable() and ((v12:BuffStack(v112.TeachingsoftheMonasteryBuff) < (1136 - (549 + 584))) or (v12:BuffRemains(v112.TeachingsoftheMonasteryBuff) < (687 - (314 + 371)))) and v47) then
					if (((2063 - 1462) < (4528 - (478 + 490))) and v23(v112.TigerPalm, not v14:IsInMeleeRange(3 + 2))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
		end
	end
	local function v127()
		if (((1407 - (786 + 386)) < (2225 - 1538)) and v51 and v112.RenewingMist:IsReady() and v16:BuffDown(v112.RenewingMistBuff) and (v112.RenewingMist:ChargesFractional() >= (1380.8 - (1055 + 324)))) then
			if (((5889 - (1093 + 247)) > (1025 + 128)) and (v16:HealthPercentage() <= v52)) then
				if (v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist)) or ((492 + 4182) < (18548 - 13876))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((12448 - 8780) < (12978 - 8417)) and v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.RenewingMistBuff, false, false, 62 - 37) > (1 + 0))) then
			if (v23(v112.RisingSunKick, not v14:IsInMeleeRange(19 - 14)) or ((1568 - 1113) == (2719 + 886))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v51 and v112.RenewingMist:IsReady() and v16:BuffDown(v112.RenewingMistBuff)) or ((6810 - 4147) == (4000 - (364 + 324)))) then
			if (((11724 - 7447) <= (10738 - 6263)) and (v16:HealthPercentage() <= v52)) then
				if (v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist)) or ((289 + 581) == (4975 - 3786))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((2487 - 934) <= (9515 - 6382)) and v55 and v112.Vivify:IsReady() and v12:BuffUp(v112.VivaciousVivificationBuff)) then
			if ((v16:HealthPercentage() <= v56) or ((3505 - (1249 + 19)) >= (3170 + 341))) then
				if (v23(v114.VivifyFocus, not v16:IsSpellInRange(v112.Vivify)) or ((5153 - 3829) > (4106 - (686 + 400)))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v59 and v112.SoothingMist:IsReady() and v16:BuffDown(v112.SoothingMist)) or ((2348 + 644) == (2110 - (73 + 156)))) then
			if (((15 + 3091) > (2337 - (721 + 90))) and (v16:HealthPercentage() <= v60)) then
				if (((34 + 2989) < (12565 - 8695)) and v23(v114.SoothingMistFocus, not v16:IsSpellInRange(v112.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v128()
		if (((613 - (224 + 246)) > (119 - 45)) and v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.RenewingMistBuff, false, false, 46 - 21) > (1 + 0))) then
			if (((1 + 17) < (1552 + 560)) and v23(v112.RisingSunKick, not v14:IsInMeleeRange(9 - 4))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (((3650 - 2553) <= (2141 - (203 + 310))) and v119.AreUnitsBelowHealthPercentage(v63, v62)) then
			local v222 = 1993 - (1238 + 755);
			while true do
				if (((324 + 4306) == (6164 - (709 + 825))) and (v222 == (0 - 0))) then
					if (((5156 - 1616) > (3547 - (196 + 668))) and v35 and (v12:BuffStack(v112.ManaTeaCharges) > v36) and v112.EssenceFont:IsReady() and v112.ManaTea:IsCastable()) then
						if (((18927 - 14133) >= (6783 - 3508)) and v23(v112.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((2317 - (171 + 662)) == (1577 - (4 + 89))) and v37 and v112.ThunderFocusTea:IsReady() and (v112.EssenceFont:CooldownRemains() < v12:GCD())) then
						if (((5018 - 3586) < (1295 + 2260)) and v23(v112.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v222 = 4 - 3;
				end
				if (((1 + 0) == v222) or ((2551 - (35 + 1451)) > (5031 - (28 + 1425)))) then
					if ((v61 and v112.EssenceFont:IsReady() and (v12:BuffUp(v112.ThunderFocusTea) or (v112.ThunderFocusTea:CooldownRemains() > (2001 - (941 + 1052))))) or ((4598 + 197) < (2921 - (822 + 692)))) then
						if (((2644 - 791) < (2268 + 2545)) and v23(v112.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
			end
		end
		if ((v61 and v112.EssenceFont:IsReady() and v112.AncientTeachings:IsAvailable() and v12:BuffDown(v112.EssenceFontBuff)) or ((3118 - (45 + 252)) < (2406 + 25))) then
			if (v23(v112.EssenceFont, nil) or ((990 + 1884) < (5307 - 3126))) then
				return "EssenceFont healing aoe";
			end
		end
		if ((v66 and v112.ZenPulse:IsReady() and v119.AreUnitsBelowHealthPercentage(v68, v67)) or ((3122 - (114 + 319)) <= (491 - 148))) then
			if (v23(v114.ZenPulseFocus, not v16:IsSpellInRange(v112.ZenPulse)) or ((2394 - 525) == (1281 + 728))) then
				return "ZenPulse healing aoe";
			end
		end
		if ((v69 and v112.SheilunsGift:IsReady() and v112.SheilunsGift:IsCastable() and v119.AreUnitsBelowHealthPercentage(v71, v70)) or ((5282 - 1736) < (4864 - 2542))) then
			if (v23(v112.SheilunsGift, nil) or ((4045 - (556 + 1407)) == (5979 - (741 + 465)))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v129()
		local v139 = 465 - (170 + 295);
		while true do
			if (((1710 + 1534) > (970 + 85)) and (v139 == (0 - 0))) then
				if ((v57 and v112.EnvelopingMist:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.EnvelopingMist, false, false, 21 + 4) < (2 + 1))) or ((1877 + 1436) <= (3008 - (957 + 273)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (0 + 0)) or ((5414 - 3993) >= (5544 - 3440))) then
							v28 = v119.FocusUnitRefreshableBuff(v112.EnvelopingMist, 5 - 3, 198 - 158, nil, false, 1805 - (389 + 1391));
							if (((1137 + 675) <= (339 + 2910)) and v28) then
								return v28;
							end
							v232 = 2 - 1;
						end
						if (((2574 - (783 + 168)) <= (6568 - 4611)) and (v232 == (1 + 0))) then
							if (((4723 - (309 + 2)) == (13548 - 9136)) and v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if (((2962 - (1090 + 122)) >= (273 + 569)) and v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.EnvelopingMist, false, false, 83 - 58) > (2 + 0))) then
					if (((5490 - (628 + 490)) > (332 + 1518)) and v23(v112.RisingSunKick, not v14:IsInMeleeRange(12 - 7))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v139 = 4 - 3;
			end
			if (((1006 - (431 + 343)) < (1657 - 836)) and (v139 == (2 - 1))) then
				if (((410 + 108) < (116 + 786)) and v59 and v112.SoothingMist:IsReady() and v16:BuffUp(v112.ChiHarmonyBuff) and v16:BuffDown(v112.SoothingMist)) then
					if (((4689 - (556 + 1139)) > (873 - (6 + 9))) and v23(v114.SoothingMistFocus, not v16:IsSpellInRange(v112.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v130()
		if ((v44 and v112.BlackoutKick:IsReady() and (v12:BuffStack(v112.TeachingsoftheMonastery) >= (1 + 2))) or ((1924 + 1831) <= (1084 - (28 + 141)))) then
			if (((1529 + 2417) > (4619 - 876)) and v23(v112.BlackoutKick, not v14:IsInMeleeRange(4 + 1))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v57 and v112.EnvelopingMist:IsReady() and (v12:BuffStack(v112.InvokeChiJiBuff) == (1320 - (486 + 831)))) or ((3473 - 2138) >= (11639 - 8333))) then
			if (((916 + 3928) > (7123 - 4870)) and (v16:HealthPercentage() <= v58)) then
				if (((1715 - (668 + 595)) == (407 + 45)) and v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v46 and v112.RisingSunKick:IsReady()) or ((919 + 3638) < (5691 - 3604))) then
			if (((4164 - (23 + 267)) == (5818 - (1129 + 815))) and v23(v112.RisingSunKick, not v14:IsInMeleeRange(392 - (371 + 16)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v57 and v112.EnvelopingMist:IsReady() and (v12:BuffStack(v112.InvokeChiJiBuff) >= (1752 - (1326 + 424)))) or ((3670 - 1732) > (18033 - 13098))) then
			if ((v16:HealthPercentage() <= v58) or ((4373 - (88 + 30)) < (4194 - (720 + 51)))) then
				if (((3234 - 1780) <= (4267 - (421 + 1355))) and v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v61 and v112.EssenceFont:IsReady() and v112.AncientTeachings:IsAvailable() and v12:BuffDown(v112.AncientTeachings)) or ((6857 - 2700) <= (1377 + 1426))) then
			if (((5936 - (286 + 797)) >= (10901 - 7919)) and v23(v112.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v131()
		if (((6847 - 2713) > (3796 - (397 + 42))) and v78 and v112.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
			if (v23(v114.LifeCocoonFocus, not v16:IsSpellInRange(v112.LifeCocoon)) or ((1068 + 2349) < (3334 - (24 + 776)))) then
				return "Life Cocoon CD";
			end
		end
		if ((v80 and v112.Revival:IsReady() and v112.Revival:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81)) or ((4192 - 1470) <= (949 - (222 + 563)))) then
			if (v23(v112.Revival, nil) or ((5305 - 2897) < (1519 + 590))) then
				return "Revival CD";
			end
		end
		if ((v80 and v112.Restoral:IsReady() and v112.Restoral:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81)) or ((223 - (23 + 167)) == (3253 - (690 + 1108)))) then
			if (v23(v112.Restoral, nil) or ((160 + 283) >= (3312 + 703))) then
				return "Restoral CD";
			end
		end
		if (((4230 - (40 + 808)) > (28 + 138)) and v72 and v112.InvokeYulonTheJadeSerpent:IsAvailable() and v112.InvokeYulonTheJadeSerpent:IsReady() and v119.AreUnitsBelowHealthPercentage(v74, v73)) then
			local v223 = 0 - 0;
			while true do
				if ((v223 == (1 + 0)) or ((149 + 131) == (1678 + 1381))) then
					if (((2452 - (47 + 524)) > (840 + 453)) and v69 and v112.SheilunsGift:IsReady() and (v112.SheilunsGift:TimeSinceLastCast() > (54 - 34))) then
						if (((3523 - 1166) == (5375 - 3018)) and v23(v112.SheilunsGift, nil)) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if (((1849 - (1165 + 561)) == (4 + 119)) and v112.InvokeYulonTheJadeSerpent:IsReady() and (v112.RenewingMist:ChargesFractional() < (3 - 2)) and v12:BuffUp(v112.ManaTeaBuff) and (v112.SheilunsGift:TimeSinceLastCast() < ((2 + 2) * v12:GCD()))) then
						if (v23(v112.InvokeYulonTheJadeSerpent, nil) or ((1535 - (341 + 138)) >= (916 + 2476))) then
							return "Invoke Yu'lon GO";
						end
					end
					break;
				end
				if ((v223 == (0 - 0)) or ((1407 - (89 + 237)) < (3458 - 2383))) then
					if ((v51 and v112.RenewingMist:IsReady() and (v112.RenewingMist:ChargesFractional() >= (1 - 0))) or ((1930 - (581 + 300)) >= (5652 - (855 + 365)))) then
						v28 = v119.FocusUnitRefreshableBuff(v112.RenewingMistBuff, 13 - 7, 14 + 26, nil, false, 1260 - (1030 + 205));
						if (v28 or ((4477 + 291) <= (788 + 58))) then
							return v28;
						end
						if (v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist)) or ((3644 - (156 + 130)) <= (3226 - 1806))) then
							return "Renewing Mist YuLon prep";
						end
					end
					if ((v35 and v112.ManaTea:IsCastable() and (v12:BuffStack(v112.ManaTeaCharges) >= (4 - 1)) and v12:BuffDown(v112.ManaTeaBuff)) or ((7657 - 3918) <= (792 + 2213))) then
						if (v23(v112.ManaTea, nil) or ((968 + 691) >= (2203 - (10 + 59)))) then
							return "ManaTea YuLon prep";
						end
					end
					v223 = 1 + 0;
				end
			end
		end
		if ((v112.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (123 - 98)) or ((4423 - (671 + 492)) < (1875 + 480))) then
			local v224 = 1215 - (369 + 846);
			while true do
				if ((v224 == (0 + 0)) or ((571 + 98) == (6168 - (1036 + 909)))) then
					v28 = v129();
					if (v28 or ((1346 + 346) < (987 - 399))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v75 and v112.InvokeChiJiTheRedCrane:IsReady() and v112.InvokeChiJiTheRedCrane:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v77, v76)) or ((5000 - (11 + 192)) < (1846 + 1805))) then
			if ((v51 and v112.RenewingMist:IsReady() and (v112.RenewingMist:ChargesFractional() >= (176 - (135 + 40)))) or ((10120 - 5943) > (2924 + 1926))) then
				local v231 = 0 - 0;
				while true do
					if ((v231 == (1 - 0)) or ((576 - (50 + 126)) > (3093 - 1982))) then
						if (((676 + 2375) > (2418 - (1233 + 180))) and v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist))) then
							return "Renewing Mist ChiJi prep";
						end
						break;
					end
					if (((4662 - (522 + 447)) <= (5803 - (107 + 1314))) and (v231 == (0 + 0))) then
						v28 = v119.FocusUnitRefreshableBuff(v112.RenewingMistBuff, 18 - 12, 17 + 23, nil, false, 49 - 24);
						if (v28 or ((12985 - 9703) > (6010 - (716 + 1194)))) then
							return v28;
						end
						v231 = 1 + 0;
					end
				end
			end
			if ((v69 and v112.SheilunsGift:IsReady() and (v112.SheilunsGift:TimeSinceLastCast() > (3 + 17))) or ((4083 - (74 + 429)) < (5485 - 2641))) then
				if (((45 + 44) < (10278 - 5788)) and v23(v112.SheilunsGift, nil)) then
					return "Sheilun's Gift ChiJi prep";
				end
			end
			if ((v112.InvokeChiJiTheRedCrane:IsReady() and (v112.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v112.AncientTeachings) and (v12:BuffStack(v112.TeachingsoftheMonastery) == (8 - 5)) and (v112.SheilunsGift:TimeSinceLastCast() < ((9 - 5) * v12:GCD()))) or ((5416 - (279 + 154)) < (2586 - (454 + 324)))) then
				if (((3013 + 816) > (3786 - (12 + 5))) and v23(v112.InvokeChiJiTheRedCrane, nil)) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((801 + 684) <= (7399 - 4495)) and (v112.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (10 + 15))) then
			v28 = v130();
			if (((5362 - (277 + 816)) == (18241 - 13972)) and v28) then
				return v28;
			end
		end
	end
	local function v132()
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
	local function v133()
		v95 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useRacials'];
		v97 = EpicSettings.Settings['trinketsWithCD'];
		v96 = EpicSettings.Settings['useTrinkets'];
		v98 = EpicSettings.Settings['fightRemainsCheck'];
		v88 = EpicSettings.Settings['dispelDebuffs'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v86 = EpicSettings.Settings['healingPotionHP'];
		v87 = EpicSettings.Settings['HealingPotionName'];
		v83 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['healthstoneHP'];
		v105 = EpicSettings.Settings['useManaPotion'];
		v106 = EpicSettings.Settings['manaPotionSlider'];
		v107 = EpicSettings.Settings['RevivalBurstingGroup'];
		v108 = EpicSettings.Settings['RevivalBurstingStacks'];
		v91 = EpicSettings.Settings['InterruptThreshold'];
		v89 = EpicSettings.Settings['InterruptWithStun'];
		v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v92 = EpicSettings.Settings['useSpearHandStrike'];
		v93 = EpicSettings.Settings['useLegSweep'];
		v99 = EpicSettings.Settings['handleAfflicted'];
		v100 = EpicSettings.Settings['HandleIncorporeal'];
		v101 = EpicSettings.Settings['HandleChromie'];
		v103 = EpicSettings.Settings['HandleCharredBrambles'];
		v102 = EpicSettings.Settings['HandleCharredTreant'];
		v104 = EpicSettings.Settings['HandleFyrakkNPC'];
		v72 = EpicSettings.Settings['UseInvokeYulon'];
		v74 = EpicSettings.Settings['InvokeYulonHP'];
		v73 = EpicSettings.Settings['InvokeYulonGroup'];
		v75 = EpicSettings.Settings['UseInvokeChiJi'];
		v77 = EpicSettings.Settings['InvokeChiJiHP'];
		v76 = EpicSettings.Settings['InvokeChiJiGroup'];
		v78 = EpicSettings.Settings['UseLifeCocoon'];
		v79 = EpicSettings.Settings['LifeCocoonHP'];
		v80 = EpicSettings.Settings['UseRevival'];
		v82 = EpicSettings.Settings['RevivalHP'];
		v81 = EpicSettings.Settings['RevivalGroup'];
	end
	local v134 = 1183 - (1058 + 125);
	local function v135()
		local v214 = 0 + 0;
		while true do
			if (((1362 - (815 + 160)) <= (11936 - 9154)) and (v214 == (7 - 4))) then
				v116 = v12:GetEnemiesInMeleeRange(2 + 6);
				if (v30 or ((5551 - 3652) <= (2815 - (41 + 1857)))) then
					v117 = #v116;
				else
					v117 = 1894 - (1222 + 671);
				end
				if (v119.TargetIsValid() or v12:AffectingCombat() or ((11144 - 6832) <= (1258 - 382))) then
					local v233 = 1182 - (229 + 953);
					while true do
						if (((4006 - (1111 + 663)) <= (4175 - (874 + 705))) and ((0 + 0) == v233)) then
							v111 = v12:GetEnemiesInRange(28 + 12);
							v109 = v9.BossFightRemains(nil, true);
							v233 = 1 - 0;
						end
						if (((59 + 2036) < (4365 - (642 + 37))) and ((1 + 0) == v233)) then
							v110 = v109;
							if ((v110 == (1778 + 9333)) or ((4004 - 2409) >= (4928 - (233 + 221)))) then
								v110 = v9.FightRemains(v111, false);
							end
							break;
						end
					end
				end
				v214 = 8 - 4;
			end
			if ((v214 == (1 + 0)) or ((6160 - (718 + 823)) < (1814 + 1068))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v214 = 807 - (266 + 539);
			end
			if ((v214 == (5 - 3)) or ((1519 - (636 + 589)) >= (11467 - 6636))) then
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (((4184 - 2155) <= (2444 + 640)) and v12:IsDeadOrGhost()) then
					return;
				end
				v214 = 2 + 1;
			end
			if ((v214 == (1020 - (657 + 358))) or ((5393 - 3356) == (5513 - 3093))) then
				if (((5645 - (1151 + 36)) > (3771 + 133)) and not v12:AffectingCombat()) then
					if (((115 + 321) >= (367 - 244)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v236 = 1832 - (1552 + 280);
						local v237;
						while true do
							if (((1334 - (64 + 770)) < (1233 + 583)) and (v236 == (0 - 0))) then
								v237 = v119.DeadFriendlyUnitsCount();
								if (((635 + 2939) == (4817 - (157 + 1086))) and (v237 > (1 - 0))) then
									if (((967 - 746) < (598 - 208)) and v23(v112.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (v23(v114.ResuscitateMouseover, not v14:IsInRange(54 - 14)) or ((3032 - (599 + 220)) <= (2829 - 1408))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if (((4989 - (1813 + 118)) < (3553 + 1307)) and not v12:AffectingCombat() and v29) then
					v28 = v124();
					if (v28 or ((2513 - (841 + 376)) >= (6229 - 1783))) then
						return v28;
					end
				end
				if (v29 or v12:AffectingCombat() or ((324 + 1069) > (12252 - 7763))) then
					local v234 = 859 - (464 + 395);
					while true do
						if (((0 - 0) == v234) or ((2125 + 2299) < (864 - (467 + 370)))) then
							if ((v105 and v113.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v106)) or ((4126 - 2129) > (2801 + 1014))) then
								if (((11878 - 8413) > (299 + 1614)) and v23(v114.ManaPotion, nil)) then
									return "Mana Potion main";
								end
							end
							if (((1705 - 972) < (2339 - (150 + 370))) and (v12:DebuffStack(v112.Bursting) > (1287 - (74 + 1208)))) then
								if ((v112.DiffuseMagic:IsReady() and v112.DiffuseMagic:IsAvailable()) or ((10810 - 6415) == (22550 - 17795))) then
									if (v23(v112.DiffuseMagic, nil) or ((2699 + 1094) < (2759 - (14 + 376)))) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							v234 = 1 - 0;
						end
						if ((v234 == (1 + 0)) or ((3588 + 496) == (253 + 12))) then
							if (((12769 - 8411) == (3279 + 1079)) and (v112.Bursting:MaxDebuffStack() > v108) and (v112.Bursting:AuraActiveCount() > v107)) then
								if ((v80 and v112.Revival:IsReady() and v112.Revival:IsAvailable()) or ((3216 - (23 + 55)) < (2353 - 1360))) then
									if (((2223 + 1107) > (2087 + 236)) and v23(v112.Revival, nil)) then
										return "Revival Bursting";
									end
								end
							end
							if (v33 or ((5621 - 1995) == (1255 + 2734))) then
								local v239 = 901 - (652 + 249);
								while true do
									if ((v239 == (0 - 0)) or ((2784 - (708 + 1160)) == (7250 - 4579))) then
										if (((495 - 223) == (299 - (10 + 17))) and v112.SummonJadeSerpentStatue:IsReady() and v112.SummonJadeSerpentStatue:IsAvailable() and (v112.SummonJadeSerpentStatue:TimeSinceLastCast() > (21 + 69)) and v65) then
											if (((5981 - (1400 + 332)) <= (9281 - 4442)) and (v64 == "Player")) then
												if (((4685 - (242 + 1666)) < (1370 + 1830)) and v23(v114.SummonJadeSerpentStatuePlayer, not v14:IsInRange(15 + 25))) then
													return "jade serpent main player";
												end
											elseif (((81 + 14) < (2897 - (850 + 90))) and (v64 == "Cursor")) then
												if (((1446 - 620) < (3107 - (360 + 1030))) and v23(v114.SummonJadeSerpentStatueCursor, not v14:IsInRange(36 + 4))) then
													return "jade serpent main cursor";
												end
											elseif (((4024 - 2598) >= (1519 - 414)) and (v64 == "Confirmation")) then
												if (((4415 - (909 + 752)) <= (4602 - (109 + 1114))) and v23(v112.SummonJadeSerpentStatue, not v14:IsInRange(73 - 33))) then
													return "jade serpent main confirmation";
												end
											end
										end
										if ((v35 and (v12:BuffStack(v112.ManaTeaCharges) >= (8 + 10)) and v112.ManaTea:IsCastable()) or ((4169 - (6 + 236)) == (891 + 522))) then
											if (v23(v112.ManaTea, nil) or ((929 + 225) <= (1858 - 1070))) then
												return "Mana Tea main avoid overcap";
											end
										end
										v239 = 1 - 0;
									end
									if ((v239 == (1135 - (1076 + 57))) or ((271 + 1372) > (4068 - (579 + 110)))) then
										v28 = v127();
										if (v28 or ((222 + 2581) > (4022 + 527))) then
											return v28;
										end
										break;
									end
									if (((1 + 0) == v239) or ((627 - (174 + 233)) >= (8441 - 5419))) then
										if (((4952 - 2130) == (1255 + 1567)) and (v110 > v98) and v31) then
											v28 = v131();
											if (v28 or ((2235 - (663 + 511)) == (1657 + 200))) then
												return v28;
											end
										end
										if (((600 + 2160) > (4204 - 2840)) and v30) then
											local v240 = 0 + 0;
											while true do
												if ((v240 == (0 - 0)) or ((11866 - 6964) <= (1716 + 1879))) then
													v28 = v128();
													if (v28 or ((7497 - 3645) == (209 + 84))) then
														return v28;
													end
													break;
												end
											end
										end
										v239 = 1 + 1;
									end
								end
							end
							break;
						end
					end
				end
				v214 = 728 - (478 + 244);
			end
			if (((517 - (440 + 77)) == v214) or ((709 + 850) == (16792 - 12204))) then
				v132();
				v133();
				v29 = EpicSettings.Toggles['ooc'];
				v214 = 1557 - (655 + 901);
			end
			if ((v214 == (1 + 3)) or ((3433 + 1051) == (533 + 255))) then
				v28 = v123();
				if (((18402 - 13834) >= (5352 - (695 + 750))) and v28) then
					return v28;
				end
				if (((4254 - 3008) < (5355 - 1885)) and (v12:AffectingCombat() or v29)) then
					local v235 = v88 and v112.Detox:IsReady() and v32;
					v28 = v119.FocusUnit(v235, nil, nil, nil);
					if (((16360 - 12292) >= (1323 - (285 + 66))) and v28) then
						return v28;
					end
					if (((1149 - 656) < (5203 - (682 + 628))) and v32 and v88) then
						if (v16 or ((238 + 1235) >= (3631 - (176 + 123)))) then
							if ((v112.Detox:IsCastable() and v119.DispellableFriendlyUnit(11 + 14)) or ((2939 + 1112) <= (1426 - (239 + 30)))) then
								if (((165 + 439) < (2770 + 111)) and (v134 == (0 - 0))) then
									v134 = GetTime();
								end
								if (v119.Wait(1559 - 1059, v134) or ((1215 - (306 + 9)) == (11784 - 8407))) then
									if (((776 + 3683) > (363 + 228)) and v23(v114.DetoxFocus, not v16:IsSpellInRange(v112.Detox))) then
										return "detox dispel focus";
									end
									v134 = 0 + 0;
								end
							end
						end
						if (((9716 - 6318) >= (3770 - (1140 + 235))) and v15 and v15:Exists() and v15:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v15)) then
							if (v112.Detox:IsCastable() or ((1390 + 793) >= (2590 + 234))) then
								if (((497 + 1439) == (1988 - (33 + 19))) and v23(v114.DetoxMouseover, not v15:IsSpellInRange(v112.Detox))) then
									return "detox dispel mouseover";
								end
							end
						end
					end
				end
				v214 = 2 + 3;
			end
			if ((v214 == (17 - 11)) or ((2129 + 2703) < (8457 - 4144))) then
				if (((3834 + 254) > (4563 - (586 + 103))) and (v29 or v12:AffectingCombat()) and v119.TargetIsValid() and v12:CanAttack(v14)) then
					v28 = v122();
					if (((395 + 3937) == (13336 - 9004)) and v28) then
						return v28;
					end
					if (((5487 - (1309 + 179)) >= (5235 - 2335)) and v96 and ((v31 and v97) or not v97)) then
						v28 = v119.HandleTopTrinket(v115, v31, 18 + 22, nil);
						if (v28 or ((6780 - 4255) > (3070 + 994))) then
							return v28;
						end
						v28 = v119.HandleBottomTrinket(v115, v31, 84 - 44, nil);
						if (((8709 - 4338) == (4980 - (295 + 314))) and v28) then
							return v28;
						end
					end
					if (v34 or ((653 - 387) > (6948 - (1300 + 662)))) then
						local v238 = 0 - 0;
						while true do
							if (((3746 - (1178 + 577)) >= (481 + 444)) and (v238 == (2 - 1))) then
								if (((1860 - (851 + 554)) < (1816 + 237)) and (v117 >= (8 - 5)) and v30) then
									v28 = v125();
									if (v28 or ((1793 - 967) == (5153 - (115 + 187)))) then
										return v28;
									end
								end
								if (((141 + 42) == (174 + 9)) and (v117 < (11 - 8))) then
									v28 = v126();
									if (((2320 - (160 + 1001)) <= (1565 + 223)) and v28) then
										return v28;
									end
								end
								break;
							end
							if ((v238 == (0 + 0)) or ((7178 - 3671) > (4676 - (237 + 121)))) then
								if ((v94 and ((v31 and v95) or not v95) and (v110 < (915 - (525 + 372)))) or ((5829 - 2754) <= (9741 - 6776))) then
									if (((1507 - (96 + 46)) <= (2788 - (643 + 134))) and v112.BloodFury:IsCastable()) then
										if (v23(v112.BloodFury, nil) or ((1003 + 1773) > (8571 - 4996))) then
											return "blood_fury main 4";
										end
									end
									if (v112.Berserking:IsCastable() or ((9482 - 6928) == (4608 + 196))) then
										if (((5057 - 2480) == (5267 - 2690)) and v23(v112.Berserking, nil)) then
											return "berserking main 6";
										end
									end
									if (v112.LightsJudgment:IsCastable() or ((725 - (316 + 403)) >= (1256 + 633))) then
										if (((1391 - 885) <= (684 + 1208)) and v23(v112.LightsJudgment, not v14:IsInRange(100 - 60))) then
											return "lights_judgment main 8";
										end
									end
									if (v112.Fireblood:IsCastable() or ((1423 + 585) > (715 + 1503))) then
										if (((1312 - 933) <= (19805 - 15658)) and v23(v112.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (v112.AncestralCall:IsCastable() or ((9376 - 4862) <= (58 + 951))) then
										if (v23(v112.AncestralCall, nil) or ((6882 - 3386) == (59 + 1133))) then
											return "ancestral_call main 12";
										end
									end
									if (v112.BagofTricks:IsCastable() or ((611 - 403) == (2976 - (12 + 5)))) then
										if (((16611 - 12334) >= (2800 - 1487)) and v23(v112.BagofTricks, not v14:IsInRange(85 - 45))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if (((6415 - 3828) < (645 + 2529)) and v37 and v112.ThunderFocusTea:IsReady() and not v112.EssenceFont:IsAvailable() and (v112.RisingSunKick:CooldownRemains() < v12:GCD())) then
									if (v23(v112.ThunderFocusTea, nil) or ((6093 - (1656 + 317)) <= (1959 + 239))) then
										return "ThunderFocusTea main 16";
									end
								end
								v238 = 1 + 0;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v136()
		v121();
		v112.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(717 - 447, v135, v136);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

