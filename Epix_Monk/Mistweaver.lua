local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5373 - (232 + 609)) > (1259 + 1437)) and not v5) then
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
	local v109;
	local v110 = 12544 - (797 + 636);
	local v111 = 53947 - 42836;
	local v112;
	local v113 = v17.Monk.Mistweaver;
	local v114 = v19.Monk.Mistweaver;
	local v115 = v24.Monk.Mistweaver;
	local v116 = {};
	local v117;
	local v118;
	local v119 = {{v113.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v113.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v120 = v21.Commons.Everyone;
	local v121 = v21.Commons.Monk;
	local function v122()
		if (((809 + 239) >= (49 + 3)) and v113.ImprovedDetox:IsAvailable()) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if (((11308 - 8350) < (5054 - (83 + 468))) and v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
			if (v23(v113.DampenHarm, nil) or ((4541 - (1202 + 604)) == (6110 - 4801))) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((6873 - 2743) <= (8181 - 5226))) then
			if (v23(v113.FortifyingBrew, nil) or ((2289 - (45 + 280)) <= (1294 + 46))) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((2184 + 315) == (913 + 1586)) and v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) then
			if (v23(v113.ExpelHarm, nil) or ((1248 + 1007) < (4 + 18))) then
				return "expel_harm defensives 3";
			end
		end
		if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) or ((2010 - 924) >= (3316 - (340 + 1571)))) then
			if (v23(v115.Healthstone) or ((935 + 1434) == (2198 - (1733 + 39)))) then
				return "healthstone defensive 4";
			end
		end
		if ((v85 and (v12:HealthPercentage() <= v86)) or ((8452 - 5376) > (4217 - (125 + 909)))) then
			if (((3150 - (1096 + 852)) > (475 + 583)) and (v87 == "Refreshing Healing Potion")) then
				if (((5299 - 1588) > (3255 + 100)) and v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) then
					if (v23(v115.RefreshingHealingPotion) or ((1418 - (409 + 103)) >= (2465 - (46 + 190)))) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if (((1383 - (51 + 44)) > (353 + 898)) and (v87 == "Dreamwalker's Healing Potion")) then
				if ((v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) or ((5830 - (1114 + 203)) < (4078 - (228 + 498)))) then
					if (v23(v115.RefreshingHealingPotion) or ((448 + 1617) >= (1766 + 1430))) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v124()
		local v138 = 663 - (174 + 489);
		while true do
			if ((v138 == (5 - 3)) or ((6281 - (830 + 1075)) <= (2005 - (303 + 221)))) then
				if (v104 or ((4661 - (231 + 1038)) >= (3951 + 790))) then
					local v232 = 1162 - (171 + 991);
					while true do
						if (((13702 - 10377) >= (5783 - 3629)) and (v232 == (7 - 4))) then
							v28 = v120.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 33 + 7);
							if (v28 or ((4539 - 3244) >= (9326 - 6093))) then
								return v28;
							end
							break;
						end
						if (((7054 - 2677) > (5075 - 3433)) and (v232 == (1250 - (111 + 1137)))) then
							v28 = v120.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 198 - (91 + 67));
							if (((14056 - 9333) > (339 + 1017)) and v28) then
								return v28;
							end
							v232 = 526 - (423 + 100);
						end
						if ((v232 == (0 + 0)) or ((11451 - 7315) <= (1790 + 1643))) then
							v28 = v120.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 811 - (326 + 445));
							if (((18525 - 14280) <= (10316 - 5685)) and v28) then
								return v28;
							end
							v232 = 2 - 1;
						end
						if (((4987 - (530 + 181)) >= (4795 - (614 + 267))) and (v232 == (33 - (19 + 13)))) then
							v28 = v120.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 65 - 25);
							if (((461 - 263) <= (12469 - 8104)) and v28) then
								return v28;
							end
							v232 = 1 + 1;
						end
					end
				end
				if (((8409 - 3627) > (9697 - 5021)) and v105) then
					v28 = v120.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 1852 - (1293 + 519));
					if (((9923 - 5059) > (5736 - 3539)) and v28) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 76 - 36);
					if (v28 or ((15954 - 12254) == (5905 - 3398))) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 22 + 18);
					if (((913 + 3561) >= (636 - 362)) and v28) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 10 + 30);
					if (v28 or ((630 + 1264) <= (879 + 527))) then
						return v28;
					end
				end
				break;
			end
			if (((2668 - (709 + 387)) >= (3389 - (673 + 1185))) and (v138 == (0 - 0))) then
				if (v101 or ((15050 - 10363) < (7472 - 2930))) then
					v28 = v120.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 22 + 8, true);
					if (((2460 + 831) > (2250 - 583)) and v28) then
						return v28;
					end
				end
				if (v100 or ((215 + 658) == (4055 - 2021))) then
					local v233 = 0 - 0;
					while true do
						if ((v233 == (1880 - (446 + 1434))) or ((4099 - (1040 + 243)) < (32 - 21))) then
							v28 = v120.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 1877 - (559 + 1288));
							if (((5630 - (609 + 1322)) < (5160 - (13 + 441))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v138 = 3 - 2;
			end
			if (((6930 - 4284) >= (4362 - 3486)) and (v138 == (1 + 0))) then
				if (((2229 - 1615) <= (1131 + 2053)) and v102) then
					local v234 = 0 + 0;
					while true do
						if (((9276 - 6150) == (1711 + 1415)) and (v234 == (1 - 0))) then
							v28 = v120.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 27 + 13);
							if (v28 or ((1217 + 970) >= (3560 + 1394))) then
								return v28;
							end
							break;
						end
						if ((v234 == (0 + 0)) or ((3794 + 83) == (4008 - (153 + 280)))) then
							v28 = v120.HandleChromie(v113.Riptide, v115.RiptideMouseover, 115 - 75);
							if (((635 + 72) > (250 + 382)) and v28) then
								return v28;
							end
							v234 = 1 + 0;
						end
					end
				end
				if (v103 or ((496 + 50) >= (1945 + 739))) then
					v28 = v120.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 60 - 20);
					if (((906 + 559) <= (4968 - (89 + 578))) and v28) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 29 + 11);
					if (((3542 - 1838) > (2474 - (572 + 477))) and v28) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 6 + 34);
					if (v28 or ((413 + 274) == (506 + 3728))) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 126 - (84 + 2));
					if (v28 or ((5488 - 2158) < (1030 + 399))) then
						return v28;
					end
				end
				v138 = 844 - (497 + 345);
			end
		end
	end
	local function v125()
		if (((30 + 1117) >= (57 + 278)) and v113.ChiBurst:IsCastable() and v49) then
			if (((4768 - (605 + 728)) > (1497 + 600)) and v23(v113.ChiBurst, not v14:IsInRange(88 - 48))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (1 + 1))) or ((13938 - 10168) >= (3643 + 398))) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(21 - 13)) or ((2863 + 928) <= (2100 - (457 + 32)))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v113.TigerPalm:IsCastable() and v47) or ((1943 + 2635) <= (3410 - (832 + 570)))) then
			if (((1060 + 65) <= (542 + 1534)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(17 - 12))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v126()
		if ((v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (2 + 1)) and v43) or ((1539 - (588 + 208)) >= (11856 - 7457))) then
			if (((2955 - (884 + 916)) < (3502 - 1829)) and (v42 == "Player")) then
				if (v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(24 + 16)) or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif (((925 + 2842) == (716 + 3051)) and (v42 == "Cursor")) then
				if (((13778 - 9689) == (4694 - (316 + 289))) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(104 - 64))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((206 + 4252) >= (3127 - (666 + 787))) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
				if (((1397 - (360 + 65)) <= (1326 + 92)) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(294 - (79 + 175)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) or ((7785 - 2847) < (3716 + 1046))) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(122 - 82)) or ((4821 - 2317) > (5163 - (503 + 396)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((2334 - (92 + 89)) == (4175 - 2022)) and (v42 == "Confirmation")) then
				if (v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(21 + 19)) or ((301 + 206) >= (10146 - 7555))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((613 + 3868) == (10217 - 5736)) and v113.TouchofDeath:IsCastable() and v50) then
			if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(5 + 0)) or ((1112 + 1216) < (2110 - 1417))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((541 + 3787) == (6600 - 2272)) and v113.JadefireStomp:IsReady() and v48) then
			if (((2832 - (485 + 759)) >= (3081 - 1749)) and v23(v113.JadefireStomp, nil)) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v113.ChiBurst:IsCastable() and v49) or ((5363 - (442 + 747)) > (5383 - (832 + 303)))) then
			if (v23(v113.ChiBurst, not v14:IsInRange(986 - (88 + 858))) or ((1398 + 3188) <= (68 + 14))) then
				return "chi_burst aoe 4";
			end
		end
		if (((160 + 3703) == (4652 - (766 + 23))) and v113.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v113.MysticTouchDebuff) and v113.MysticTouch:IsAvailable()) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(39 - 31)) or ((385 - 103) <= (110 - 68))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((15642 - 11033) >= (1839 - (1036 + 37))) and v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (3 + 0))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(9 - 4)) or ((907 + 245) == (3968 - (641 + 839)))) then
				return "blackout_kick aoe 6";
			end
		end
		if (((4335 - (910 + 3)) > (8540 - 5190)) and v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (1684 - (1466 + 218))) and v47 and (v118 >= (2 + 1))) then
			if (((2025 - (556 + 592)) > (134 + 242)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(813 - (329 + 479)))) then
				return "tiger_palm aoe 7";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45) or ((3972 - (174 + 680)) <= (6360 - 4509))) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(16 - 8)) or ((118 + 47) >= (4231 - (396 + 343)))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		if (((350 + 3599) < (6333 - (29 + 1448))) and v113.TouchofDeath:IsCastable() and v50) then
			if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(1394 - (135 + 1254))) or ((16108 - 11832) < (14082 - 11066))) then
				return "touch_of_death st 1";
			end
		end
		if (((3126 + 1564) > (5652 - (389 + 1138))) and v113.JadefireStomp:IsReady() and v48) then
			if (v23(v113.JadefireStomp, nil) or ((624 - (102 + 472)) >= (846 + 50))) then
				return "JadefireStomp st 2";
			end
		end
		if ((v113.RisingSunKick:IsReady() and v46) or ((951 + 763) >= (2759 + 199))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1550 - (320 + 1225))) or ((2653 - 1162) < (395 + 249))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((2168 - (157 + 1307)) < (2846 - (821 + 1038))) and v113.ChiBurst:IsCastable() and v49) then
			if (((9276 - 5558) > (209 + 1697)) and v23(v113.ChiBurst, not v14:IsInRange(71 - 31))) then
				return "chi_burst st 4";
			end
		end
		if ((v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (2 + 1)) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) or ((2374 - 1416) > (4661 - (834 + 192)))) then
			if (((223 + 3278) <= (1153 + 3339)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(1 + 4))) then
				return "blackout_kick st 5";
			end
		end
		if ((v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (4 - 1)) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (306 - (300 + 4)))) and v47) or ((920 + 2522) < (6670 - 4122))) then
			if (((3237 - (112 + 250)) >= (584 + 880)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(12 - 7))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v128()
		if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (1.8 + 0))) or ((2481 + 2316) >= (3660 + 1233))) then
			if ((v16:HealthPercentage() <= v52) or ((274 + 277) > (1537 + 531))) then
				if (((3528 - (1001 + 413)) > (2104 - 1160)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 907 - (244 + 638)) > (694 - (627 + 66)))) or ((6739 - 4477) >= (3698 - (512 + 90)))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1911 - (1665 + 241))) or ((2972 - (373 + 344)) >= (1596 + 1941))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) or ((1016 + 2821) < (3444 - 2138))) then
			if (((4992 - 2042) == (4049 - (35 + 1064))) and (v16:HealthPercentage() <= v52)) then
				if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((3437 + 1286) < (7055 - 3757))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((5 + 1131) >= (1390 - (298 + 938))) and v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) then
			if ((v16:HealthPercentage() <= v56) or ((1530 - (233 + 1026)) > (6414 - (636 + 1030)))) then
				if (((2424 + 2316) >= (3079 + 73)) and v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) or ((766 + 1812) >= (230 + 3160))) then
			if (((262 - (55 + 166)) <= (322 + 1339)) and (v16:HealthPercentage() <= v60)) then
				if (((61 + 540) < (13595 - 10035)) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v129()
		if (((532 - (36 + 261)) < (1201 - 514)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 1393 - (34 + 1334)) > (1 + 0))) then
			if (((3535 + 1014) > (2436 - (1035 + 248))) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(26 - (20 + 1)))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (v120.AreUnitsBelowHealthPercentage(v63, v62) or ((2436 + 2238) < (4991 - (134 + 185)))) then
			local v224 = 1133 - (549 + 584);
			while true do
				if (((4353 - (314 + 371)) < (15657 - 11096)) and (v224 == (968 - (478 + 490)))) then
					if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((242 + 213) == (4777 - (786 + 386)))) then
						if (v23(v113.ManaTea, nil) or ((8625 - 5962) == (4691 - (1055 + 324)))) then
							return "EssenceFont healing aoe";
						end
					end
					if (((5617 - (1093 + 247)) <= (3977 + 498)) and v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) then
						if (v23(v113.ThunderFocusTea, nil) or ((92 + 778) == (4720 - 3531))) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v224 = 3 - 2;
				end
				if (((4418 - 2865) <= (7872 - 4739)) and (v224 == (1 + 0))) then
					if ((v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (30 - 22)))) or ((7710 - 5473) >= (2648 + 863))) then
						if (v23(v113.EssenceFont, nil) or ((3385 - 2061) > (3708 - (364 + 324)))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) or ((8201 - 5209) == (4513 - 2632))) then
						if (((1030 + 2076) > (6385 - 4859)) and v23(v113.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
			end
		end
		if (((4841 - 1818) < (11753 - 7883)) and v66 and v113.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v68, v67)) then
			if (((1411 - (1249 + 19)) > (67 + 7)) and v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse))) then
				return "ZenPulse healing aoe";
			end
		end
		if (((70 - 52) < (3198 - (686 + 400))) and v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v71, v70)) then
			if (((861 + 236) <= (1857 - (73 + 156))) and v23(v113.SheilunsGift, nil)) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v130()
		local v139 = 0 + 0;
		while true do
			if (((5441 - (721 + 90)) == (53 + 4577)) and (v139 == (3 - 2))) then
				if (((4010 - (224 + 246)) > (4346 - 1663)) and v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) then
					if (((8826 - 4032) >= (595 + 2680)) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
			if (((36 + 1448) == (1090 + 394)) and ((0 - 0) == v139)) then
				if (((4765 - 3333) < (4068 - (203 + 310))) and v57 and v113.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 2018 - (1238 + 755)) < (1 + 2))) then
					v28 = v120.FocusUnitRefreshableBuff(v113.EnvelopingMist, 1536 - (709 + 825), 73 - 33, nil, false, 35 - 10);
					if (v28 or ((1929 - (196 + 668)) > (14126 - 10548))) then
						return v28;
					end
					if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((9932 - 5137) < (2240 - (171 + 662)))) then
						return "Enveloping Mist YuLon";
					end
				end
				if (((1946 - (4 + 89)) < (16869 - 12056)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 10 + 15) > (8 - 6))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(2 + 3)) or ((4307 - (35 + 1451)) < (3884 - (28 + 1425)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v139 = 1994 - (941 + 1052);
			end
		end
	end
	local function v131()
		if ((v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (3 + 0))) or ((4388 - (822 + 692)) < (3113 - 932))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(3 + 2)) or ((2986 - (45 + 252)) <= (340 + 3))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (2 + 1))) or ((4548 - 2679) == (2442 - (114 + 319)))) then
			if ((v16:HealthPercentage() <= v58) or ((5090 - 1544) < (2975 - 653))) then
				if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((1328 + 754) == (7110 - 2337))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((6796 - 3552) > (3018 - (556 + 1407))) and v46 and v113.RisingSunKick:IsReady()) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1211 - (741 + 465))) or ((3778 - (170 + 295)) <= (937 + 841))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (2 + 0))) or ((3498 - 2077) >= (1745 + 359))) then
			if (((1163 + 649) <= (1840 + 1409)) and (v16:HealthPercentage() <= v58)) then
				if (((2853 - (957 + 273)) <= (524 + 1433)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if (((1767 + 2645) == (16811 - 12399)) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) then
			if (((4611 - 2861) >= (2571 - 1729)) and v23(v113.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v132()
		if (((21648 - 17276) > (3630 - (389 + 1391))) and v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
			if (((146 + 86) < (86 + 735)) and v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon))) then
				return "Life Cocoon CD";
			end
		end
		if (((1179 - 661) < (1853 - (783 + 168))) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81)) then
			if (((10048 - 7054) > (844 + 14)) and v23(v113.Revival, nil)) then
				return "Revival CD";
			end
		end
		if ((v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81)) or ((4066 - (309 + 2)) <= (2809 - 1894))) then
			if (((5158 - (1090 + 122)) > (1214 + 2529)) and v23(v113.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if ((v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v74, v73)) or ((4483 - 3148) >= (2263 + 1043))) then
			if (((5962 - (628 + 490)) > (404 + 1849)) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (2 - 1))) then
				v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 27 - 21, 814 - (431 + 343), nil, false, 50 - 25);
				if (((1307 - 855) == (358 + 94)) and v28) then
					return v28;
				end
				if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((583 + 3974) < (3782 - (556 + 1139)))) then
					return "Renewing Mist YuLon prep";
				end
			end
			if (((3889 - (6 + 9)) == (710 + 3164)) and v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (2 + 1)) and v12:BuffDown(v113.ManaTeaBuff)) then
				if (v23(v113.ManaTea, nil) or ((2107 - (28 + 141)) > (1912 + 3023))) then
					return "ManaTea YuLon prep";
				end
			end
			if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (24 - 4))) or ((3014 + 1241) < (4740 - (486 + 831)))) then
				if (((3783 - 2329) <= (8769 - 6278)) and v23(v113.SheilunsGift, nil)) then
					return "Sheilun's Gift YuLon prep";
				end
			end
			if ((v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((12 - 8) * v12:GCD()))) or ((5420 - (668 + 595)) <= (2523 + 280))) then
				if (((979 + 3874) >= (8132 - 5150)) and v23(v113.InvokeYulonTheJadeSerpent, nil)) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if (((4424 - (23 + 267)) > (5301 - (1129 + 815))) and (v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (412 - (371 + 16)))) then
			v28 = v130();
			if (v28 or ((5167 - (1326 + 424)) < (4799 - 2265))) then
				return v28;
			end
		end
		if ((v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v77, v76)) or ((9946 - 7224) <= (282 - (88 + 30)))) then
			local v225 = 771 - (720 + 51);
			while true do
				if (((2 - 1) == v225) or ((4184 - (421 + 1355)) < (3478 - 1369))) then
					if ((v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (1086 - (286 + 797))) and (v113.SheilunsGift:TimeSinceLastCast() < ((14 - 10) * v12:GCD()))) or ((53 - 20) == (1894 - (397 + 42)))) then
						if (v23(v113.InvokeChiJiTheRedCrane, nil) or ((139 + 304) >= (4815 - (24 + 776)))) then
							return "Invoke Chi'ji GO";
						end
					end
					break;
				end
				if (((5209 - 1827) > (951 - (222 + 563))) and (v225 == (0 - 0))) then
					if ((v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 + 0))) or ((470 - (23 + 167)) == (4857 - (690 + 1108)))) then
						v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 3 + 3, 33 + 7, nil, false, 873 - (40 + 808));
						if (((310 + 1571) > (4944 - 3651)) and v28) then
							return v28;
						end
						if (((2253 + 104) == (1247 + 1110)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if (((68 + 55) == (694 - (47 + 524))) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (13 + 7))) then
						if (v23(v113.SheilunsGift, nil) or ((2886 - 1830) >= (5071 - 1679))) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					v225 = 2 - 1;
				end
			end
		end
		if ((v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1751 - (1165 + 561))) or ((33 + 1048) < (3329 - 2254))) then
			v28 = v131();
			if (v28 or ((401 + 648) >= (4911 - (341 + 138)))) then
				return v28;
			end
		end
	end
	local function v133()
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
	local function v134()
		v95 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useRacials'];
		v97 = EpicSettings.Settings['trinketsWithCD'];
		v96 = EpicSettings.Settings['useTrinkets'];
		v98 = EpicSettings.Settings['fightRemainsCheck'];
		v99 = EpicSettings.Settings['useWeapon'];
		v88 = EpicSettings.Settings['dispelDebuffs'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v86 = EpicSettings.Settings['healingPotionHP'];
		v87 = EpicSettings.Settings['HealingPotionName'];
		v83 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['healthstoneHP'];
		v106 = EpicSettings.Settings['useManaPotion'];
		v107 = EpicSettings.Settings['manaPotionSlider'];
		v108 = EpicSettings.Settings['RevivalBurstingGroup'];
		v109 = EpicSettings.Settings['RevivalBurstingStacks'];
		v91 = EpicSettings.Settings['InterruptThreshold'];
		v89 = EpicSettings.Settings['InterruptWithStun'];
		v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v92 = EpicSettings.Settings['useSpearHandStrike'];
		v93 = EpicSettings.Settings['useLegSweep'];
		v100 = EpicSettings.Settings['handleAfflicted'];
		v101 = EpicSettings.Settings['HandleIncorporeal'];
		v102 = EpicSettings.Settings['HandleChromie'];
		v104 = EpicSettings.Settings['HandleCharredBrambles'];
		v103 = EpicSettings.Settings['HandleCharredTreant'];
		v105 = EpicSettings.Settings['HandleFyrakkNPC'];
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
	local v135 = 0 + 0;
	local function v136()
		v133();
		v134();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((9839 - 5071) <= (1172 - (89 + 237)))) then
			return;
		end
		v117 = v12:GetEnemiesInMeleeRange(25 - 17);
		if (v30 or ((7069 - 3711) <= (2301 - (581 + 300)))) then
			v118 = #v117;
		else
			v118 = 1221 - (855 + 365);
		end
		if (v120.TargetIsValid() or v12:AffectingCombat() or ((8880 - 5141) <= (982 + 2023))) then
			v112 = v12:GetEnemiesInRange(1275 - (1030 + 205));
			v110 = v9.BossFightRemains(nil, true);
			v111 = v110;
			if ((v111 == (10432 + 679)) or ((1544 + 115) >= (2420 - (156 + 130)))) then
				v111 = v9.FightRemains(v112, false);
			end
		end
		v28 = v124();
		if (v28 or ((7407 - 4147) < (3969 - 1614))) then
			return v28;
		end
		if (v12:AffectingCombat() or v29 or ((1369 - 700) == (1113 + 3110))) then
			local v226 = 0 + 0;
			local v227;
			while true do
				if ((v226 == (69 - (10 + 59))) or ((479 + 1213) < (2895 - 2307))) then
					v227 = v88 and v113.Detox:IsReady() and v32;
					v28 = v120.FocusUnit(v227, nil, 1203 - (671 + 492), nil, 20 + 5);
					v226 = 1216 - (369 + 846);
				end
				if ((v226 == (1 + 0)) or ((4094 + 703) < (5596 - (1036 + 909)))) then
					if (v28 or ((3322 + 855) > (8142 - 3292))) then
						return v28;
					end
					if ((v32 and v88) or ((603 - (11 + 192)) > (562 + 549))) then
						local v238 = 175 - (135 + 40);
						while true do
							if (((7392 - 4341) > (606 + 399)) and (v238 == (0 - 0))) then
								if (((5536 - 1843) <= (4558 - (50 + 126))) and v16) then
									if ((v113.Detox:IsCastable() and v120.DispellableFriendlyUnit(69 - 44)) or ((727 + 2555) > (5513 - (1233 + 180)))) then
										if ((v135 == (969 - (522 + 447))) or ((5001 - (107 + 1314)) < (1320 + 1524))) then
											v135 = GetTime();
										end
										if (((270 - 181) < (1908 + 2582)) and v120.Wait(992 - 492, v135)) then
											if (v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox)) or ((19715 - 14732) < (3718 - (716 + 1194)))) then
												return "detox dispel focus";
											end
											v135 = 0 + 0;
										end
									end
								end
								if (((411 + 3418) > (4272 - (74 + 429))) and v15 and v15:Exists() and v15:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v15)) then
									if (((2864 - 1379) <= (1440 + 1464)) and v113.Detox:IsCastable()) then
										if (((9771 - 5502) == (3021 + 1248)) and v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox))) then
											return "detox dispel mouseover";
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
		if (((1193 - 806) <= (6878 - 4096)) and not v12:AffectingCombat()) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((2332 - (279 + 154)) <= (1695 - (454 + 324)))) then
				local v228 = 0 + 0;
				local v229;
				while true do
					if ((v228 == (17 - (12 + 5))) or ((2325 + 1987) <= (2231 - 1355))) then
						v229 = v120.DeadFriendlyUnitsCount();
						if (((825 + 1407) <= (3689 - (277 + 816))) and (v229 > (4 - 3))) then
							if (((3278 - (1058 + 125)) < (692 + 2994)) and v23(v113.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v23(v115.ResuscitateMouseover, not v14:IsInRange(1015 - (815 + 160))) or ((6843 - 5248) >= (10620 - 6146))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if ((not v12:AffectingCombat() and v29) or ((1102 + 3517) < (8424 - 5542))) then
			v28 = v125();
			if (v28 or ((2192 - (41 + 1857)) >= (6724 - (1222 + 671)))) then
				return v28;
			end
		end
		if (((5243 - 3214) <= (4432 - 1348)) and (v29 or v12:AffectingCombat())) then
			if ((v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) or ((3219 - (229 + 953)) == (4194 - (1111 + 663)))) then
				if (((6037 - (874 + 705)) > (547 + 3357)) and v23(v115.UseWeapon, nil)) then
					return "Using Weapon Macro";
				end
			end
			if (((298 + 138) >= (255 - 132)) and v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) then
				if (((15 + 485) < (2495 - (642 + 37))) and v23(v115.ManaPotion, nil)) then
					return "Mana Potion main";
				end
			end
			if (((815 + 2759) == (572 + 3002)) and (v12:DebuffStack(v113.Bursting) > (12 - 7))) then
				if (((675 - (233 + 221)) < (901 - 511)) and v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) then
					if (v23(v113.DiffuseMagic, nil) or ((1948 + 265) <= (2962 - (718 + 823)))) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((1925 + 1133) < (5665 - (266 + 539))) and (v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) then
				if ((v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) or ((3668 - 2372) >= (5671 - (636 + 589)))) then
					if (v23(v113.Revival, nil) or ((3306 - 1913) > (9258 - 4769))) then
						return "Revival Bursting";
					end
				end
			end
			if (v33 or ((3506 + 918) < (10 + 17))) then
				local v230 = 1015 - (657 + 358);
				while true do
					if ((v230 == (7 - 4)) or ((4549 - 2552) > (5002 - (1151 + 36)))) then
						v28 = v128();
						if (((3347 + 118) > (503 + 1410)) and v28) then
							return v28;
						end
						break;
					end
					if (((2189 - 1456) < (3651 - (1552 + 280))) and (v230 == (835 - (64 + 770)))) then
						if ((v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) or ((2984 + 1411) == (10794 - 6039))) then
							if ((v14:HealthPercentage() <= v60) or ((674 + 3119) < (3612 - (157 + 1086)))) then
								if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((8174 - 4090) == (1160 - 895))) then
									return "SoothingMist main";
								end
							end
						end
						if (((6684 - 2326) == (5947 - 1589)) and v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (837 - (599 + 220))) and v113.ManaTea:IsCastable()) then
							if (v23(v113.ManaTea, nil) or ((6248 - 3110) < (2924 - (1813 + 118)))) then
								return "Mana Tea main avoid overcap";
							end
						end
						v230 = 2 + 0;
					end
					if (((4547 - (841 + 376)) > (3254 - 931)) and (v230 == (0 + 0))) then
						if ((v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (245 - 155)) and v65) or ((4485 - (464 + 395)) == (10237 - 6248))) then
							if ((v64 == "Player") or ((440 + 476) == (3508 - (467 + 370)))) then
								if (((561 - 289) == (200 + 72)) and v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(137 - 97))) then
									return "jade serpent main player";
								end
							elseif (((663 + 3586) <= (11257 - 6418)) and (v64 == "Cursor")) then
								if (((3297 - (150 + 370)) < (4482 - (74 + 1208))) and v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(98 - 58))) then
									return "jade serpent main cursor";
								end
							elseif (((450 - 355) < (1393 + 564)) and (v64 == "Confirmation")) then
								if (((1216 - (14 + 376)) < (2977 - 1260)) and v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(26 + 14))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((1253 + 173) >= (1054 + 51)) and v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) then
							if (((8069 - 5315) <= (2542 + 837)) and (v14:HealthPercentage() <= v52)) then
								if (v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist)) or ((4005 - (23 + 55)) == (3348 - 1935))) then
									return "RenewingMist main";
								end
							end
						end
						v230 = 1 + 0;
					end
					if ((v230 == (2 + 0)) or ((1788 - 634) <= (248 + 540))) then
						if (((v111 > v98) and v31) or ((2544 - (652 + 249)) > (9042 - 5663))) then
							v28 = v132();
							if (v28 or ((4671 - (708 + 1160)) > (12347 - 7798))) then
								return v28;
							end
						end
						if (v30 or ((401 - 181) >= (3049 - (10 + 17)))) then
							v28 = v129();
							if (((634 + 2188) == (4554 - (1400 + 332))) and v28) then
								return v28;
							end
						end
						v230 = 5 - 2;
					end
				end
			end
		end
		if (((v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14)) or ((2969 - (242 + 1666)) == (795 + 1062))) then
			v28 = v123();
			if (((1012 + 1748) > (1163 + 201)) and v28) then
				return v28;
			end
			if ((v96 and ((v31 and v97) or not v97)) or ((5842 - (850 + 90)) <= (6296 - 2701))) then
				local v231 = 1390 - (360 + 1030);
				while true do
					if ((v231 == (1 + 0)) or ((10872 - 7020) == (402 - 109))) then
						v28 = v120.HandleBottomTrinket(v116, v31, 1701 - (909 + 752), nil);
						if (v28 or ((2782 - (109 + 1114)) == (8399 - 3811))) then
							return v28;
						end
						break;
					end
					if ((v231 == (0 + 0)) or ((4726 - (6 + 236)) == (497 + 291))) then
						v28 = v120.HandleTopTrinket(v116, v31, 33 + 7, nil);
						if (((10773 - 6205) >= (6824 - 2917)) and v28) then
							return v28;
						end
						v231 = 1134 - (1076 + 57);
					end
				end
			end
			if (((205 + 1041) < (4159 - (579 + 110))) and v34) then
				if (((322 + 3746) >= (860 + 112)) and v94 and ((v31 and v95) or not v95) and (v111 < (10 + 8))) then
					local v235 = 407 - (174 + 233);
					while true do
						if (((1377 - 884) < (6832 - 2939)) and (v235 == (0 + 0))) then
							if (v113.BloodFury:IsCastable() or ((2647 - (663 + 511)) >= (2973 + 359))) then
								if (v23(v113.BloodFury, nil) or ((880 + 3171) <= (3566 - 2409))) then
									return "blood_fury main 4";
								end
							end
							if (((366 + 238) < (6782 - 3901)) and v113.Berserking:IsCastable()) then
								if (v23(v113.Berserking, nil) or ((2178 - 1278) == (1612 + 1765))) then
									return "berserking main 6";
								end
							end
							v235 = 1 - 0;
						end
						if (((3178 + 1281) > (55 + 536)) and (v235 == (724 - (478 + 244)))) then
							if (((3915 - (440 + 77)) >= (1089 + 1306)) and v113.AncestralCall:IsCastable()) then
								if (v23(v113.AncestralCall, nil) or ((7989 - 5806) >= (4380 - (655 + 901)))) then
									return "ancestral_call main 12";
								end
							end
							if (((360 + 1576) == (1483 + 453)) and v113.BagofTricks:IsCastable()) then
								if (v23(v113.BagofTricks, not v14:IsInRange(28 + 12)) or ((19466 - 14634) < (5758 - (695 + 750)))) then
									return "bag_of_tricks main 14";
								end
							end
							break;
						end
						if (((13959 - 9871) > (5978 - 2104)) and (v235 == (3 - 2))) then
							if (((4683 - (285 + 66)) == (10097 - 5765)) and v113.LightsJudgment:IsCastable()) then
								if (((5309 - (682 + 628)) >= (468 + 2432)) and v23(v113.LightsJudgment, not v14:IsInRange(339 - (176 + 123)))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((1057 + 1468) > (2948 + 1116))) then
								if (((4640 - (239 + 30)) == (1189 + 3182)) and v23(v113.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							v235 = 2 + 0;
						end
					end
				end
				if ((v37 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) or ((470 - 204) > (15555 - 10569))) then
					if (((2306 - (306 + 9)) >= (3227 - 2302)) and v23(v113.ThunderFocusTea, nil)) then
						return "ThunderFocusTea main 16";
					end
				end
				if (((80 + 375) < (1260 + 793)) and (v118 >= (2 + 1)) and v30) then
					local v236 = 0 - 0;
					while true do
						if ((v236 == (1375 - (1140 + 235))) or ((526 + 300) == (4449 + 402))) then
							v28 = v126();
							if (((47 + 136) == (235 - (33 + 19))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((419 + 740) <= (5359 - 3571)) and (v118 < (2 + 1))) then
					local v237 = 0 - 0;
					while true do
						if ((v237 == (0 + 0)) or ((4196 - (586 + 103)) > (394 + 3924))) then
							v28 = v127();
							if (v28 or ((9466 - 6391) <= (4453 - (1309 + 179)))) then
								return v28;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v137()
		v122();
		v113.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(487 - 217, v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

