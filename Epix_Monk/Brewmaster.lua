local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((3709 - (118 + 688)) >= (1543 - (25 + 23))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((6432 - (927 + 959)) >= (7668 - 5393)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 733 - (16 + 716);
		end
		if (((1580 - 761) >= (119 - (11 + 86))) and (v5 == (2 - 1))) then
			return v6(...);
		end
	end
end
v0["Epix_Monk_Brewmaster.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.Mouseover;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v10.Utils;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = GetTime;
	local v29 = UnitHealthMax;
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
	local v60 = v18.Monk.Brewmaster;
	local v61 = v20.Monk.Brewmaster;
	local v62 = v23.Monk.Brewmaster;
	local v63 = {v61.AlgetharPuzzleBox:ID(),v61.Djaruun:ID()};
	local v64;
	local v65;
	local v66;
	local v67;
	local v68 = v21.Commons.Everyone;
	local v69 = v21.Commons.Monk;
	local function v70()
		v68.DispellableDebuffs = v25.MergeTable(v68.DispellablePoisonDebuffs, v68.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v70();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v71 = GetInventoryItemLink("player", 78 - 62) or "";
	local v72 = IsEquippedItemType("Two-Hand");
	v10:RegisterForEvent(function()
		local v81 = 1796 - (503 + 1293);
		while true do
			if (((8830 - 5668) == (2287 + 875)) and (v81 == (1061 - (810 + 251)))) then
				v71 = GetInventoryItemLink("player", 12 + 4) or "";
				v72 = IsEquippedItemType("Two-Hand");
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v73()
		ShouldReturn = v68.HandleTopTrinket(v63, v13:BuffUp(v60.BonedustBrewBuff) or v13:BuffUp(v60.WeaponsOfOrder) or v13:BloodlustUp(), 13 + 27, nil);
		if (ShouldReturn or ((2136 + 233) > (4962 - (43 + 490)))) then
			return ShouldReturn;
		end
		ShouldReturn = v68.HandleBottomTrinket(v63, v13:BuffUp(v60.BonedustBrewBuff) or v13:BuffUp(v60.WeaponsOfOrder) or v13:BloodlustUp(), 773 - (711 + 22), nil);
		if (((15840 - 11745) >= (4042 - (240 + 619))) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v74()
		local v82 = v13:StaggerFull() or (0 + 0);
		if ((v82 == (0 - 0)) or ((246 + 3465) < (2752 - (1344 + 400)))) then
			return false;
		end
		local v83 = 405 - (255 + 150);
		local v84 = nil;
		if (v13:BuffUp(v60.LightStagger) or ((827 + 222) <= (486 + 420))) then
			v84 = v60.LightStagger;
		elseif (((19282 - 14769) > (8804 - 6078)) and v13:BuffUp(v60.ModerateStagger)) then
			v84 = v60.ModerateStagger;
		elseif (v13:BuffUp(v60.HeavyStagger) or ((3220 - (404 + 1335)) >= (3064 - (183 + 223)))) then
			v84 = v60.HeavyStagger;
		end
		if (v84 or ((3918 - 698) == (904 + 460))) then
			local v94 = v13:DebuffInfo(v84, false, true);
			v83 = v94.points[1 + 1];
		end
		if (((v60.PurifyingBrew:ChargesFractional() >= (338.8 - (10 + 327))) and (v13:DebuffUp(v60.HeavyStagger) or v13:DebuffUp(v60.ModerateStagger) or v13:DebuffUp(v60.LightStagger))) or ((734 + 320) > (3730 - (118 + 220)))) then
			return true;
		end
		return false;
	end
	local function v75()
		local v85 = 0 + 0;
		while true do
			if ((v85 == (450 - (108 + 341))) or ((304 + 372) >= (6941 - 5299))) then
				if (((5629 - (711 + 782)) > (4594 - 2197)) and v60.ChiWave:IsReady()) then
					if (v24(v60.ChiWave, not v14:IsInMeleeRange(477 - (270 + 199)), true) or ((1406 + 2928) == (6064 - (580 + 1239)))) then
						return "chi_wave precombat 10";
					end
				end
				if (v60.RushingJadeWind:IsReady() or ((12711 - 8435) <= (2899 + 132))) then
					if (v24(v60.RushingJadeWind, not v14:IsInMeleeRange(1 + 7)) or ((2084 + 2698) <= (3130 - 1931))) then
						return "rushing_jade_wind precombat 4";
					end
				end
				v85 = 2 + 0;
			end
			if ((v85 == (1169 - (645 + 522))) or ((6654 - (1010 + 780)) < (1902 + 0))) then
				if (((23052 - 18213) >= (10842 - 7142)) and v60.KegSmash:IsReady()) then
					if (v24(v60.KegSmash, not v14:IsInRange(1876 - (1045 + 791))) or ((2721 - 1646) > (2928 - 1010))) then
						return "keg_smash precombat 8";
					end
				end
				break;
			end
			if (((901 - (351 + 154)) <= (5378 - (1281 + 293))) and (v85 == (266 - (28 + 238)))) then
				if ((v58 == "OOC") or (v58 == "Both") or ((9315 - 5146) == (3746 - (1381 + 178)))) then
					if (((1319 + 87) == (1134 + 272)) and v60.Clash:IsReady() and not v14:IsInRange(4 + 4) and v14:IsInRange(103 - 73)) then
						if (((794 + 737) < (4741 - (381 + 89))) and v24(v60.Clash)) then
							return "clash precombat 8";
						end
					end
				end
				if (((564 + 71) == (430 + 205)) and v60.ChiBurst:IsReady() and (CovenantID ~= (4 - 1))) then
					if (((4529 - (1074 + 82)) <= (7792 - 4236)) and v24(v60.ChiBurst, not v14:IsInMeleeRange(1792 - (214 + 1570)), true)) then
						return "chi_burst precombat 6";
					end
				end
				v85 = 1456 - (990 + 465);
			end
		end
	end
	local function v76()
		local v86 = 0 + 0;
		while true do
			if ((v86 == (1 + 1)) or ((3201 + 90) < (12908 - 9628))) then
				if (((6112 - (1668 + 58)) >= (1499 - (512 + 114))) and v60.FortifyingBrew:IsCastable() and v48 and v13:BuffDown(v60.DampenHarmBuff) and (v13:HealthPercentage() <= v49)) then
					if (((2401 - 1480) <= (2277 - 1175)) and v24(v60.FortifyingBrew)) then
						return "Fortifying Brew";
					end
				end
				if (((16375 - 11669) >= (448 + 515)) and v60.HealingElixir:IsCastable() and v50 and (v13:HealthPercentage() <= v51)) then
					if (v24(v60.HealingElixir) or ((180 + 780) <= (762 + 114))) then
						return "Healing Elixir Brew";
					end
				end
				v86 = 10 - 7;
			end
			if ((v86 == (1995 - (109 + 1885))) or ((3535 - (1269 + 200)) == (1786 - 854))) then
				if (((5640 - (98 + 717)) < (5669 - (802 + 24))) and v60.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= (137 - 57))) then
					if (v24(v60.ExpelHarm) or ((4896 - 1019) >= (671 + 3866))) then
						return "Expel Harm";
					end
				end
				if ((v60.DampenHarm:IsCastable() and v13:BuffDown(v60.FortifyingBrewBuff) and (v13:HealthPercentage() <= (27 + 8))) or ((709 + 3606) < (373 + 1353))) then
					if (v24(v60.DampenHarm) or ((10234 - 6555) < (2084 - 1459))) then
						return "Dampen Harm";
					end
				end
				v86 = 1 + 1;
			end
			if ((v86 == (2 + 2)) or ((3815 + 810) < (460 + 172))) then
				if ((v34 and (v13:HealthPercentage() <= v36)) or ((39 + 44) > (3213 - (797 + 636)))) then
					if (((2650 - 2104) <= (2696 - (1427 + 192))) and (v35 == "Refreshing Healing Potion")) then
						if (v61.RefreshingHealingPotion:IsReady() or ((346 + 650) > (9985 - 5684))) then
							if (((3659 + 411) > (312 + 375)) and v24(v62.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v86 == (329 - (192 + 134))) or ((1932 - (316 + 960)) >= (1854 + 1476))) then
				if ((v60.DiffuseMagic:IsCastable() and v56 and (v13:HealthPercentage() <= v57)) or ((1924 + 568) <= (310 + 25))) then
					if (((16522 - 12200) >= (3113 - (83 + 468))) and v24(v60.DiffuseMagic)) then
						return "Diffuse Magic";
					end
				end
				if ((v61.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) or ((5443 - (1202 + 604)) >= (17599 - 13829))) then
					if (v24(v62.Healthstone, nil, nil, true) or ((3958 - 1579) > (12675 - 8097))) then
						return "healthstone defensive 3";
					end
				end
				v86 = 329 - (45 + 280);
			end
			if ((v86 == (0 + 0)) or ((422 + 61) > (272 + 471))) then
				if (((1358 + 1096) > (102 + 476)) and v60.CelestialBrew:IsCastable() and v47 and v13:BuffDown(v60.BlackoutComboBuff) and (v13:IncomingDamageTaken(3701 - 1702) > ((v29("player") * (1911.1 - (340 + 1571))) + v13:StaggerLastTickDamage(2 + 2))) and (v13:BuffStack(v60.ElusiveBrawlerBuff) < (1774 - (1733 + 39)))) then
					if (((2555 - 1625) < (5492 - (125 + 909))) and v24(v60.CelestialBrew)) then
						return "Celestial Brew";
					end
				end
				if (((2610 - (1096 + 852)) <= (437 + 535)) and v60.PurifyingBrew:IsCastable() and v74() and v45 and (v13:HealthPercentage() <= v46)) then
					if (((6240 - 1870) == (4239 + 131)) and v24(v60.PurifyingBrew)) then
						return "Purifying Brew";
					end
				end
				v86 = 513 - (409 + 103);
			end
		end
	end
	local function v77()
		local v87 = 236 - (46 + 190);
		while true do
			if ((v87 == (95 - (51 + 44))) or ((1344 + 3418) <= (2178 - (1114 + 203)))) then
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or "";
				v36 = EpicSettings.Settings['HealingPotionHP'] or (726 - (228 + 498));
				v37 = EpicSettings.Settings['UseHealthstone'];
				v87 = 1 + 0;
			end
			if ((v87 == (4 + 2)) or ((2075 - (174 + 489)) == (11108 - 6844))) then
				v58 = EpicSettings.Settings['ClashUsage'] or "";
				v59 = EpicSettings.Settings['UseDjaruun'];
				break;
			end
			if (((1909 - (830 + 1075)) == v87) or ((3692 - (303 + 221)) < (3422 - (231 + 1038)))) then
				v50 = EpicSettings.Settings['UseHealingElixir'];
				v51 = EpicSettings.Settings['HealingElixirHP'] or (0 + 0);
				v52 = EpicSettings.Settings['ExplodingKegUsage'] or "";
				v53 = EpicSettings.Settings['UseNiuzao'];
				v87 = 1167 - (171 + 991);
			end
			if ((v87 == (12 - 9)) or ((13361 - 8385) < (3323 - 1991))) then
				v46 = EpicSettings.Settings['PurifyingBrewHP'] or (0 + 0);
				v47 = EpicSettings.Settings['UseCelestialBrew'];
				v48 = EpicSettings.Settings['UseFortifyingBrew'];
				v49 = EpicSettings.Settings['FortifyingBrewHP'] or (0 - 0);
				v87 = 11 - 7;
			end
			if (((7459 - 2831) == (14306 - 9678)) and (v87 == (1250 - (111 + 1137)))) then
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v43 = EpicSettings.Settings['InterruptThreshold'] or (158 - (91 + 67));
				v44 = EpicSettings.Settings['UseBlackOxBrew'];
				v45 = EpicSettings.Settings['UsePurifyingBrew'];
				v87 = 8 - 5;
			end
			if ((v87 == (1 + 0)) or ((577 - (423 + 100)) == (3 + 392))) then
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v39 = EpicSettings.Settings['DispelDebuffs'];
				v40 = EpicSettings.Settings['DispelBuffs'];
				v41 = EpicSettings.Settings['InterruptWithStun'];
				v87 = 2 + 0;
			end
			if (((853 - (326 + 445)) == (357 - 275)) and (v87 == (10 - 5))) then
				v54 = EpicSettings.Settings['SummonWhiteTigerStatueUsage'] or "";
				v55 = EpicSettings.Settings['BonedustBrewUsage'] or "";
				v56 = EpicSettings.Settings['UseDiffuseMagic'];
				v57 = EpicSettings.Settings['DiffuseMagicHP'] or (0 - 0);
				v87 = 717 - (530 + 181);
			end
		end
	end
	local function v78()
		v77();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v64 = v13:GetEnemiesInMeleeRange(886 - (614 + 267));
		v65 = v13:GetEnemiesInMeleeRange(40 - (19 + 13));
		v66 = #v65;
		v66 = ((#v65 > (0 - 0)) and #v65) or (2 - 1);
		EnemiesCount5 = ((#v64 > (0 - 0)) and #v64) or (1 + 0);
		v67 = v13:IsTankingAoE(13 - 5) or v13:IsTanking(v14);
		if (v13:IsDeadOrGhost() or ((1204 - 623) < (2094 - (1293 + 519)))) then
			return;
		end
		if ((v13:AffectingCombat() and v39) or ((9403 - 4794) < (6514 - 4019))) then
			if (((2202 - 1050) == (4967 - 3815)) and v60.Detox:IsReady() and v33) then
				local v111 = 0 - 0;
				while true do
					if (((1005 + 891) <= (699 + 2723)) and (v111 == (0 - 0))) then
						ShouldReturn = v68.FocusUnit(true, nil, nil, nil);
						if (ShouldReturn or ((229 + 761) > (539 + 1081))) then
							return ShouldReturn;
						end
						break;
					end
				end
			end
		end
		if (v68.TargetIsValid() or ((549 + 328) > (5791 - (709 + 387)))) then
			if (((4549 - (673 + 1185)) >= (5367 - 3516)) and not v13:AffectingCombat() and v30) then
				local v112 = 0 - 0;
				local v113;
				while true do
					if ((v112 == (0 - 0)) or ((2136 + 849) >= (3629 + 1227))) then
						v113 = v75();
						if (((5772 - 1496) >= (294 + 901)) and v113) then
							return v113;
						end
						break;
					end
				end
			end
			if (((6443 - 3211) <= (9206 - 4516)) and (v13:AffectingCombat() or v30)) then
				local v114 = 1880 - (446 + 1434);
				while true do
					if ((v114 == (1286 - (1040 + 243))) or ((2674 - 1778) >= (4993 - (559 + 1288)))) then
						if (((4992 - (609 + 1322)) >= (3412 - (13 + 441))) and v60.ArcaneTorrent:IsCastable() and v32 and (v13:Energy() < (115 - 84))) then
							if (((8347 - 5160) >= (3207 - 2563)) and v24(v60.ArcaneTorrent, not v14:IsInMeleeRange(1 + 7))) then
								return "arcane_torrent main 68";
							end
						end
						if (((2338 - 1694) <= (251 + 453)) and v60.TouchofDeath:IsCastable() and v32) then
							if (((420 + 538) > (2810 - 1863)) and v24(v60.TouchofDeath, not v14:IsInMeleeRange(3 + 2))) then
								return "touch_of_death main 52";
							end
						end
						if (((8261 - 3769) >= (1755 + 899)) and v60.BreathOfFire:IsCastable() and CharredPassionsEquipped and v13:BuffDown(v60.CharredPassions)) then
							if (((1915 + 1527) >= (1080 + 423)) and v24(v60.BreathOfFire, not v14:IsInRange(11 + 1))) then
								return "breath_of_fire main 42";
							end
						end
						v114 = 4 + 0;
					end
					if ((v114 == (433 - (153 + 280))) or ((9153 - 5983) <= (1315 + 149))) then
						if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1895 + 2902) == (2297 + 2091))) then
							local v116 = v68.Interrupt(v60.SpearHandStrike, 8 + 0, true);
							if (((400 + 151) <= (1036 - 355)) and v116) then
								return v116;
							end
							v116 = v68.InterruptWithStun(v60.LegSweep, 5 + 3);
							if (((3944 - (89 + 578)) > (291 + 116)) and v116) then
								return v116;
							end
							v116 = v68.Interrupt(v60.SpearHandStrike, 83 - 43, true, v16, v62.SpearHandStrikeMouseover);
							if (((5744 - (572 + 477)) >= (191 + 1224)) and v116) then
								return v116;
							end
						end
						if (v67 or ((1928 + 1284) <= (113 + 831))) then
							local v117 = v76();
							if (v117 or ((3182 - (84 + 2)) <= (2963 - 1165))) then
								return v117;
							end
						end
						if (((2549 + 988) == (4379 - (497 + 345))) and v15) then
							if (((99 + 3738) >= (266 + 1304)) and v39 and v33 and v60.Detox:IsReady() and v68.DispellableFriendlyUnit()) then
								if (v24(v62.DetoxFocus) or ((4283 - (605 + 728)) == (2720 + 1092))) then
									return "detox main";
								end
							end
						end
						v114 = 1 - 0;
					end
					if (((217 + 4506) >= (8570 - 6252)) and (v114 == (1 + 0))) then
						if (v32 or ((5616 - 3589) > (2154 + 698))) then
							local v118 = 489 - (457 + 32);
							while true do
								if ((v118 == (0 + 0)) or ((2538 - (832 + 570)) > (4067 + 250))) then
									if (((1239 + 3509) == (16802 - 12054)) and v60.SummonWhiteTigerStatue:IsCastable()) then
										if (((1800 + 1936) <= (5536 - (588 + 208))) and (v54 == "Player")) then
											if (v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(21 - 13)) or ((5190 - (884 + 916)) <= (6406 - 3346))) then
												return "summon_white_tiger_statue 4";
											end
										elseif ((v54 == "Cursor") or ((580 + 419) > (3346 - (232 + 421)))) then
											if (((2352 - (1569 + 320)) < (148 + 453)) and v24(v62.SummonWhiteTigerStatueCursor)) then
												return "summon_white_tiger_statue 4";
											end
										end
									end
									if ((v32 and v59 and v61.Djaruun:IsEquippedAndReady()) or ((415 + 1768) < (2314 - 1627))) then
										if (((5154 - (316 + 289)) == (11907 - 7358)) and v24(v62.Djaruun, not v14:IsInMeleeRange(1 + 7))) then
											return "djaruun_pillar_of_the_elder_flame main 4";
										end
									end
									if (((6125 - (666 + 787)) == (5097 - (360 + 65))) and v32) then
										local v120 = 0 + 0;
										local v121;
										while true do
											if (((254 - (79 + 175)) == v120) or ((5783 - 2115) < (309 + 86))) then
												v121 = v73();
												if (v121 or ((12769 - 8603) == (876 - 421))) then
													return v121;
												end
												break;
											end
										end
									end
									v118 = 900 - (503 + 396);
								end
								if ((v118 == (184 - (92 + 89))) or ((8630 - 4181) == (1366 + 1297))) then
									if ((v60.InvokeNiuzaoTheBlackOx:IsCastable() and v10.BossFilteredFightRemains(">", 15 + 10) and v53) or ((16749 - 12472) < (409 + 2580))) then
										if (v24(v60.InvokeNiuzaoTheBlackOx, not v14:IsInRange(91 - 51)) or ((760 + 110) >= (1982 + 2167))) then
											return "invoke_niuzao_the_black_ox main 18";
										end
									end
									if (((6736 - 4524) < (398 + 2785)) and v60.TouchofDeath:IsCastable() and (v14:HealthPercentage() <= (22 - 7))) then
										if (((5890 - (485 + 759)) > (6922 - 3930)) and v24(v60.TouchofDeath, not v14:IsInMeleeRange(1194 - (442 + 747)))) then
											return "touch_of_death main 20";
										end
									end
									if (((2569 - (832 + 303)) < (4052 - (88 + 858))) and v60.WeaponsOfOrder:IsCastable()) then
										if (((240 + 546) < (2502 + 521)) and v24(v60.WeaponsOfOrder)) then
											return "weapons_of_order main 22";
										end
									end
									v118 = 1 + 3;
								end
								if ((v118 == (790 - (766 + 23))) or ((12055 - 9613) < (101 - 27))) then
									if (((11948 - 7413) == (15391 - 10856)) and v60.BloodFury:IsCastable()) then
										if (v24(v60.BloodFury) or ((4082 - (1036 + 37)) <= (1493 + 612))) then
											return "blood_fury main 6";
										end
									end
									if (((3563 - 1733) < (2887 + 782)) and v60.Berserking:IsCastable()) then
										if (v24(v60.Berserking) or ((2910 - (641 + 839)) >= (4525 - (910 + 3)))) then
											return "berserking main 8";
										end
									end
									if (((6839 - 4156) >= (4144 - (1466 + 218))) and v60.LightsJudgment:IsCastable()) then
										if (v24(v60.LightsJudgment, not v14:IsInRange(19 + 21)) or ((2952 - (556 + 592)) >= (1165 + 2110))) then
											return "lights_judgment main 10";
										end
									end
									v118 = 810 - (329 + 479);
								end
								if ((v118 == (856 - (174 + 680))) or ((4868 - 3451) > (7521 - 3892))) then
									if (((3424 + 1371) > (1141 - (396 + 343))) and v60.Fireblood:IsCastable()) then
										if (((426 + 4387) > (5042 - (29 + 1448))) and v24(v60.Fireblood)) then
											return "fireblood main 12";
										end
									end
									if (((5301 - (135 + 1254)) == (14737 - 10825)) and v60.AncestralCall:IsCastable()) then
										if (((13171 - 10350) <= (3215 + 1609)) and v24(v60.AncestralCall)) then
											return "ancestral_call main 14";
										end
									end
									if (((3265 - (389 + 1138)) <= (2769 - (102 + 472))) and v60.BagofTricks:IsCastable()) then
										if (((39 + 2) <= (1674 + 1344)) and v24(v60.BagofTricks, not v14:IsInRange(38 + 2))) then
											return "bag_of_tricks main 16";
										end
									end
									v118 = 1548 - (320 + 1225);
								end
								if (((3818 - 1673) <= (2512 + 1592)) and (v118 == (1468 - (157 + 1307)))) then
									if (((4548 - (821 + 1038)) < (12088 - 7243)) and v60.BonedustBrew:IsCastable() and (v14:DebuffDown(v60.BonedustBrew))) then
										if ((v55 == "Player") or ((254 + 2068) > (4656 - 2034))) then
											if (v24(v62.BonedustBrewPlayer, not v14:IsInMeleeRange(3 + 5)) or ((11237 - 6703) == (3108 - (834 + 192)))) then
												return "bonedust_brew 26";
											end
										elseif ((v55 == "Enemy Under Cursor") or ((100 + 1471) > (480 + 1387))) then
											if ((v16:Exists() and v13:CanAttack(v16) and (v16:DebuffDown(v60.BonedustBrew))) or ((57 + 2597) >= (4641 - 1645))) then
												if (((4282 - (300 + 4)) > (562 + 1542)) and v24(v62.BonedustBrewCursor)) then
													return "bonedust_brew 26";
												end
											end
										elseif (((7840 - 4845) > (1903 - (112 + 250))) and (v55 == "Cursor")) then
											if (((1296 + 1953) > (2387 - 1434)) and v24(v62.BonedustBrewCursor)) then
												return "bonedust_brew 26";
											end
										elseif ((v55 == "Confirmation") or ((1876 + 1397) > (2365 + 2208))) then
											if (v24(v60.BonedustBrew) or ((2357 + 794) < (637 + 647))) then
												return "bonedust_brew 26";
											end
										end
									end
									break;
								end
							end
						end
						if ((v32 and v44) or ((1375 + 475) == (2943 - (1001 + 413)))) then
							local v119 = 0 - 0;
							while true do
								if (((1703 - (244 + 638)) < (2816 - (627 + 66))) and ((0 - 0) == v119)) then
									if (((1504 - (512 + 90)) < (4231 - (1665 + 241))) and v60.BlackOxBrew:IsCastable() and (v60.PurifyingBrew:ChargesFractional() < (717.5 - (373 + 344)))) then
										if (((387 + 471) <= (784 + 2178)) and v24(v60.BlackOxBrew)) then
											return "black_ox_brew main 28";
										end
									end
									if ((v60.BlackOxBrew:IsCastable() and ((v13:Energy() + (v13:EnergyRegen() * v60.KegSmash:CooldownRemains())) < (105 - 65)) and v13:BuffDown(v60.BlackoutComboBuff) and v60.KegSmash:CooldownUp()) or ((6677 - 2731) < (2387 - (35 + 1064)))) then
										if (v24(v60.BlackOxBrew) or ((2359 + 883) == (1212 - 645))) then
											return "black_ox_brew main 30";
										end
									end
									break;
								end
							end
						end
						if ((v60.KegSmash:IsCastable() and (v66 >= (1 + 1))) or ((2083 - (298 + 938)) >= (2522 - (233 + 1026)))) then
							if (v24(v60.KegSmash, not v14:IsSpellInRange(v60.KegSmash)) or ((3919 - (636 + 1030)) == (947 + 904))) then
								return "keg_smash main 34";
							end
						end
						v114 = 2 + 0;
					end
					if ((v114 == (2 + 3)) or ((142 + 1945) > (2593 - (55 + 166)))) then
						if (v60.ChiBurst:IsCastable() or ((862 + 3583) < (418 + 3731))) then
							if (v24(v60.ChiBurst, not v14:IsInMeleeRange(30 - 22)) or ((2115 - (36 + 261)) == (148 - 63))) then
								return "chi_burst main 60";
							end
						end
						if (((1998 - (34 + 1334)) < (818 + 1309)) and v60.ChiWave:IsCastable()) then
							if (v24(v60.ChiWave, not v14:IsInMeleeRange(7 + 1)) or ((3221 - (1035 + 248)) == (2535 - (20 + 1)))) then
								return "chi_wave main 62";
							end
						end
						if (((2217 + 2038) >= (374 - (134 + 185))) and v60.SpinningCraneKick:IsCastable() and not ShaohaosMightEquipped and (v66 >= (1136 - (549 + 584))) and (v60.KegSmash:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v60.KegSmash:CooldownRemains() + v60.SpinningCraneKick:ExecuteTime()))) >= (750 - (314 + 371))) and (not v60.Spitfire:IsAvailable() or not CharredPassionsEquipped)) then
							if (((10295 - 7296) > (2124 - (478 + 490))) and v24(v60.SpinningCraneKick, not v14:IsInMeleeRange(5 + 3))) then
								return "spinning_crane_kick main 64";
							end
						end
						v114 = 1178 - (786 + 386);
					end
					if (((7611 - 5261) > (2534 - (1055 + 324))) and (v114 == (1344 - (1093 + 247)))) then
						if (((3581 + 448) <= (511 + 4342)) and v60.BreathOfFire:IsCastable() and v13:BuffDown(v60.BlackoutComboBuff) and (v13:BloodlustDown() or (v13:BloodlustUp() and v14:BuffRefreshable(v60.BreathOfFireDotDebuff)))) then
							if (v24(v60.BreathOfFire, not v14:IsInMeleeRange(31 - 23)) or ((1750 - 1234) > (9771 - 6337))) then
								return "breath_of_fire main 58";
							end
						end
						if (((10167 - 6121) >= (1079 + 1954)) and v60.RushingJadeWind:IsCastable()) then
							if (v24(v60.RushingJadeWind, not v14:IsInMeleeRange(30 - 22)) or ((9371 - 6652) <= (1092 + 355))) then
								return "rushing_jade_wind main 72";
							end
						end
						if ((v60.SpinningCraneKick:IsReady() and (v13:BuffUp(v60.CharredPassions))) or ((10571 - 6437) < (4614 - (364 + 324)))) then
							if (v24(v60.SpinningCraneKick, not v14:IsInMeleeRange(21 - 13)) or ((393 - 229) >= (924 + 1861))) then
								return "spinning_crane_kick main 56";
							end
						end
						v114 = 20 - 15;
					end
					if ((v114 == (9 - 3)) or ((1594 - 1069) == (3377 - (1249 + 19)))) then
						if (((30 + 3) == (128 - 95)) and v60.RushingJadeWind:IsCastable() and (v13:BuffDown(v60.RushingJadeWind))) then
							if (((4140 - (686 + 400)) <= (3151 + 864)) and v24(v60.RushingJadeWind, not v14:IsInMeleeRange(237 - (73 + 156)))) then
								return "rushing_jade_wind main 54";
							end
						end
						if (((9 + 1862) < (4193 - (721 + 90))) and v60.TigerPalm:IsReady() and v60.RushingJadeWind:IsAvailable() and v13:BuffUp(v60.BlackoutComboBuff) and v13:BuffUp(v60.RushingJadeWind)) then
							if (((15 + 1278) <= (7032 - 4866)) and v24(v60.TigerPalm, not v14:IsInMeleeRange(475 - (224 + 246)))) then
								return "tiger_palm main 40";
							end
						end
						if (v60.BlackoutKick:IsCastable() or ((4177 - 1598) < (226 - 103))) then
							if (v24(v60.BlackoutKick, not v14:IsInMeleeRange(1 + 4)) or ((21 + 825) >= (1740 + 628))) then
								return "blackout_kick main 44";
							end
						end
						v114 = 13 - 6;
					end
					if ((v114 == (6 - 4)) or ((4525 - (203 + 310)) <= (5351 - (1238 + 755)))) then
						if (((105 + 1389) <= (4539 - (709 + 825))) and v60.ExplodingKeg:IsCastable()) then
							if ((v52 == "Player") or ((5732 - 2621) == (3108 - 974))) then
								if (((3219 - (196 + 668)) == (9298 - 6943)) and v24(v62.ExplodingKegPlayer, not v14:IsInMeleeRange(16 - 8))) then
									return "exploding_keg 39";
								end
							elseif ((v52 == "Enemy Under Cursor") or ((1421 - (171 + 662)) <= (525 - (4 + 89)))) then
								if (((16813 - 12016) >= (1419 + 2476)) and v16:Exists() and v13:CanAttack(v16)) then
									if (((15710 - 12133) == (1403 + 2174)) and v24(v62.ExplodingKegCursor)) then
										return "exploding_keg 39";
									end
								end
							elseif (((5280 - (35 + 1451)) > (5146 - (28 + 1425))) and (v52 == "Cursor")) then
								if (v24(v62.ExplodingKegCursor) or ((3268 - (941 + 1052)) == (3932 + 168))) then
									return "exploding_keg 39";
								end
							elseif ((v52 == "Confirmation") or ((3105 - (822 + 692)) >= (5111 - 1531))) then
								if (((464 + 519) <= (2105 - (45 + 252))) and v24(v60.ExplodingKeg)) then
									return "exploding_keg 39";
								end
							end
						end
						if ((v58 == "Combat") or (v58 == "Both") or ((2128 + 22) <= (412 + 785))) then
							if (((9172 - 5403) >= (1606 - (114 + 319))) and v60.Clash:IsReady() and not v14:IsInRange(11 - 3) and v14:IsInRange(38 - 8)) then
								if (((947 + 538) == (2212 - 727)) and v24(v60.Clash)) then
									return "clash combat 8";
								end
							end
						end
						if ((v60.ChiBurst:IsCastable() and (v60.FaelineStomp:CooldownRemains() > (3 - 1)) and (v66 >= (1965 - (556 + 1407)))) or ((4521 - (741 + 465)) <= (3247 - (170 + 295)))) then
							if (v24(v60.ChiBurst, not v14:IsInMeleeRange(5 + 3)) or ((805 + 71) >= (7297 - 4333))) then
								return "chi_burst main 48";
							end
						end
						v114 = 3 + 0;
					end
					if (((5 + 2) == v114) or ((1264 + 968) > (3727 - (957 + 273)))) then
						if (v60.RisingSunKick:IsCastable() or ((565 + 1545) <= (133 + 199))) then
							if (((14045 - 10359) > (8358 - 5186)) and v24(v60.RisingSunKick, not v14:IsInMeleeRange(15 - 10))) then
								return "rising_sun_kick main 46";
							end
						end
						if (v60.KegSmash:IsReady() or ((22153 - 17679) < (2600 - (389 + 1391)))) then
							if (((2685 + 1594) >= (300 + 2582)) and v24(v60.KegSmash, not v14:IsSpellInRange(v60.KegSmash))) then
								return "keg_smash main 46";
							end
						end
						if ((v60.TigerPalm:IsCastable() and not v60.BlackoutCombo:IsAvailable() and (v60.KegSmash:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v60.KegSmash:CooldownRemains() + v13:GCD()))) >= (147 - 82))) or ((2980 - (783 + 168)) >= (11817 - 8296))) then
							if (v24(v60.TigerPalm, not v14:IsSpellInRange(v60.TigerPalm)) or ((2004 + 33) >= (4953 - (309 + 2)))) then
								return "tiger_palm main 66";
							end
						end
						break;
					end
				end
			end
			if (((5281 - 3561) < (5670 - (1090 + 122))) and v24(v60.PoolEnergy)) then
				return "Pool Energy";
			end
		end
	end
	local function v79()
		v70();
		v21.Print("Brewmaster Monk rotation by Epic BoomK");
		EpicSettings.SetupVersion("Brewmaster Monk X v 10.2.01 By BoomK");
	end
	v21.SetAPL(87 + 181, v78, v79);
end;
return v0["Epix_Monk_Brewmaster.lua"]();

