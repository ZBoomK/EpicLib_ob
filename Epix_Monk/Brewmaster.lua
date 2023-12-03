local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 285 - (175 + 110);
	local v6;
	while true do
		if (((2661 - 1607) <= (17119 - 13648)) and ((1796 - (503 + 1293)) == v5)) then
			v6 = v0[v4];
			if (not v6 or ((4476 - 2873) <= (489 + 187))) then
				return v1(v4, ...);
			end
			v5 = 1062 - (810 + 251);
		end
		if (((2383 + 1050) <= (1270 + 2866)) and ((1 + 0) == v5)) then
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
	local v60;
	local v61;
	local v62 = v18.Monk.Brewmaster;
	local v63 = v20.Monk.Brewmaster;
	local v64 = v23.Monk.Brewmaster;
	local v65 = {v63.AlgetharPuzzleBox:ID(),v63.Djaruun:ID()};
	local v66;
	local v67;
	local v68;
	local v69;
	local v70 = v21.Commons.Everyone;
	local v71 = v21.Commons.Monk;
	local function v72()
		v70.DispellableDebuffs = v25.MergeTable(v70.DispellablePoisonDebuffs, v70.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v72();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v73 = GetInventoryItemLink("player", 61 - 45) or "";
	local v74 = IsEquippedItemType("Two-Hand");
	v10:RegisterForEvent(function()
		local v83 = 859 - (240 + 619);
		while true do
			if (((1025 + 3220) <= (7366 - 2735)) and ((0 + 0) == v83)) then
				v73 = GetInventoryItemLink("player", 1760 - (1344 + 400)) or "";
				v74 = IsEquippedItemType("Two-Hand");
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v75()
		ShouldReturn = v70.HandleTopTrinket(v65, v13:BuffUp(v62.BonedustBrewBuff) or v13:BuffUp(v62.WeaponsOfOrder) or v13:BloodlustUp(), 445 - (255 + 150), nil);
		if (((3369 + 907) >= (2096 + 1818)) and ShouldReturn) then
			return ShouldReturn;
		end
		ShouldReturn = v70.HandleBottomTrinket(v65, v13:BuffUp(v62.BonedustBrewBuff) or v13:BuffUp(v62.WeaponsOfOrder) or v13:BloodlustUp(), 170 - 130, nil);
		if (((639 - 441) <= (6104 - (404 + 1335))) and ShouldReturn) then
			return ShouldReturn;
		end
	end
	local function v76()
		local v84 = 406 - (183 + 223);
		local v85;
		local v86;
		local v87;
		while true do
			if (((5818 - 1036) > (3099 + 1577)) and (v84 == (1 + 1))) then
				if (((5201 - (10 + 327)) > (1530 + 667)) and v13:BuffUp(v62.LightStagger)) then
					v87 = v62.LightStagger;
				elseif (v13:BuffUp(v62.ModerateStagger) or ((4038 - (118 + 220)) == (836 + 1671))) then
					v87 = v62.ModerateStagger;
				elseif (((4923 - (108 + 341)) >= (124 + 150)) and v13:BuffUp(v62.HeavyStagger)) then
					v87 = v62.HeavyStagger;
				end
				if (v87 or ((8007 - 6113) <= (2899 - (711 + 782)))) then
					local v111 = 0 - 0;
					local v112;
					while true do
						if (((2041 - (270 + 199)) >= (497 + 1034)) and (v111 == (1819 - (580 + 1239)))) then
							v112 = v13:DebuffInfo(v87, false, true);
							v86 = v112.points[5 - 3];
							break;
						end
					end
				end
				v84 = 3 + 0;
			end
			if ((v84 == (1 + 0)) or ((2042 + 2645) < (11858 - 7316))) then
				v86 = 0 + 0;
				v87 = nil;
				v84 = 1169 - (645 + 522);
			end
			if (((5081 - (1010 + 780)) > (1667 + 0)) and (v84 == (14 - 11))) then
				if (((v62.PurifyingBrew:ChargesFractional() >= (2.8 - 1)) and (v13:DebuffUp(v62.HeavyStagger) or v13:DebuffUp(v62.ModerateStagger) or v13:DebuffUp(v62.LightStagger))) or ((2709 - (1045 + 791)) == (5148 - 3114))) then
					return true;
				end
				return false;
			end
			if ((v84 == (0 - 0)) or ((3321 - (351 + 154)) < (1585 - (1281 + 293)))) then
				v85 = v13:StaggerFull() or (266 - (28 + 238));
				if (((8264 - 4565) < (6265 - (1381 + 178))) and (v85 == (0 + 0))) then
					return false;
				end
				v84 = 1 + 0;
			end
		end
	end
	local function v77()
		if (((1129 + 1517) >= (3019 - 2143)) and ((v60 == "OOC") or (v60 == "Both"))) then
			if (((319 + 295) <= (3654 - (381 + 89))) and v62.Clash:IsReady() and not v14:IsInRange(8 + 0) and v14:IsInRange(21 + 9)) then
				if (((5354 - 2228) == (4282 - (1074 + 82))) and v24(v62.Clash)) then
					return "clash precombat 8";
				end
			end
		end
		if ((v62.ChiBurst:IsReady() and (CovenantID ~= (6 - 3))) or ((3971 - (214 + 1570)) >= (6409 - (990 + 465)))) then
			if (v24(v62.ChiBurst, not v14:IsInMeleeRange(4 + 4), true) or ((1687 + 2190) == (3477 + 98))) then
				return "chi_burst precombat 6";
			end
		end
		if (((2782 - 2075) > (2358 - (1668 + 58))) and v62.ChiWave:IsReady()) then
			if (v24(v62.ChiWave, not v14:IsInMeleeRange(634 - (512 + 114)), true) or ((1423 - 877) >= (5548 - 2864))) then
				return "chi_wave precombat 10";
			end
		end
		if (((5097 - 3632) <= (2001 + 2300)) and v62.RushingJadeWind:IsReady()) then
			if (((319 + 1385) > (1239 + 186)) and v24(v62.RushingJadeWind, not v14:IsInMeleeRange(26 - 18))) then
				return "rushing_jade_wind precombat 4";
			end
		end
		if (v62.KegSmash:IsReady() or ((2681 - (109 + 1885)) == (5703 - (1269 + 200)))) then
			if (v24(v62.KegSmash, not v14:IsInRange(76 - 36)) or ((4145 - (98 + 717)) < (2255 - (802 + 24)))) then
				return "keg_smash precombat 8";
			end
		end
	end
	local function v78()
		if (((1977 - 830) >= (423 - 88)) and v62.CelestialBrew:IsCastable() and v49 and v13:BuffDown(v62.BlackoutComboBuff) and (v13:IncomingDamageTaken(296 + 1703) > ((v29("player") * (0.1 + 0)) + v13:StaggerLastTickDamage(1 + 3))) and (v13:BuffStack(v62.ElusiveBrawlerBuff) < (1 + 1))) then
			if (((9555 - 6120) > (6992 - 4895)) and v24(v62.CelestialBrew)) then
				return "Celestial Brew";
			end
		end
		if ((v62.PurifyingBrew:IsCastable() and v76() and v47 and (v13:HealthPercentage() <= v48)) or ((1349 + 2421) >= (1645 + 2396))) then
			if (v24(v62.PurifyingBrew) or ((3128 + 663) <= (1172 + 439))) then
				return "Purifying Brew";
			end
		end
		if ((v62.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= (38 + 42))) or ((6011 - (797 + 636)) <= (9749 - 7741))) then
			if (((2744 - (1427 + 192)) <= (720 + 1356)) and v24(v62.ExpelHarm)) then
				return "Expel Harm";
			end
		end
		if ((v62.DampenHarm:IsCastable() and v13:BuffDown(v62.FortifyingBrewBuff) and (v13:HealthPercentage() <= (81 - 46))) or ((668 + 75) >= (1994 + 2405))) then
			if (((1481 - (192 + 134)) < (2949 - (316 + 960))) and v24(v62.DampenHarm)) then
				return "Dampen Harm";
			end
		end
		if ((v62.FortifyingBrew:IsCastable() and v50 and v13:BuffDown(v62.DampenHarmBuff) and (v13:HealthPercentage() <= v51)) or ((1294 + 1030) <= (447 + 131))) then
			if (((3482 + 285) == (14401 - 10634)) and v24(v62.FortifyingBrew)) then
				return "Fortifying Brew";
			end
		end
		if (((4640 - (83 + 468)) == (5895 - (1202 + 604))) and v62.HealingElixir:IsCastable() and v52 and (v13:HealthPercentage() <= v53)) then
			if (((20810 - 16352) >= (2785 - 1111)) and v24(v62.HealingElixir)) then
				return "Healing Elixir Brew";
			end
		end
		if (((2691 - 1719) <= (1743 - (45 + 280))) and v62.DiffuseMagic:IsCastable() and v58 and (v13:HealthPercentage() <= v59)) then
			if (v24(v62.DiffuseMagic) or ((4767 + 171) < (4161 + 601))) then
				return "Diffuse Magic";
			end
		end
		if ((v63.Healthstone:IsReady() and v37 and (v13:HealthPercentage() <= v38)) or ((915 + 1589) > (2360 + 1904))) then
			if (((379 + 1774) == (3986 - 1833)) and v24(v64.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v13:HealthPercentage() <= v36)) or ((2418 - (340 + 1571)) >= (1022 + 1569))) then
			if (((6253 - (1733 + 39)) == (12313 - 7832)) and (v35 == "Refreshing Healing Potion")) then
				if (v63.RefreshingHealingPotion:IsReady() or ((3362 - (125 + 909)) < (2641 - (1096 + 852)))) then
					if (((1942 + 2386) == (6180 - 1852)) and v24(v64.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v79()
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (512 - (409 + 103));
		v39 = EpicSettings.Settings['DispelDebuffs'];
		v40 = EpicSettings.Settings['DispelBuffs'];
		v41 = EpicSettings.Settings['HandleAfflicted'];
		v42 = EpicSettings.Settings['HandleIncorporeal'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'] or (236 - (46 + 190));
		v46 = EpicSettings.Settings['UseBlackOxBrew'];
		v47 = EpicSettings.Settings['UsePurifyingBrew'];
		v48 = EpicSettings.Settings['PurifyingBrewHP'] or (95 - (51 + 44));
		v49 = EpicSettings.Settings['UseCelestialBrew'];
		v50 = EpicSettings.Settings['UseFortifyingBrew'];
		v51 = EpicSettings.Settings['FortifyingBrewHP'] or (0 + 0);
		v52 = EpicSettings.Settings['UseHealingElixir'];
		v53 = EpicSettings.Settings['HealingElixirHP'] or (1317 - (1114 + 203));
		v54 = EpicSettings.Settings['ExplodingKegUsage'] or "";
		v55 = EpicSettings.Settings['UseNiuzao'];
		v56 = EpicSettings.Settings['SummonWhiteTigerStatueUsage'] or "";
		v57 = EpicSettings.Settings['BonedustBrewUsage'] or "";
		v58 = EpicSettings.Settings['UseDiffuseMagic'];
		v59 = EpicSettings.Settings['DiffuseMagicHP'] or (726 - (228 + 498));
		v60 = EpicSettings.Settings['ClashUsage'] or "";
		v61 = EpicSettings.Settings['UseDjaruun'];
	end
	local function v80()
		local v104 = 0 + 0;
		while true do
			if (((878 + 710) >= (1995 - (174 + 489))) and ((5 - 3) == v104)) then
				v67 = v13:GetEnemiesInMeleeRange(1913 - (830 + 1075));
				v68 = #v67;
				v68 = ((#v67 > (524 - (303 + 221))) and #v67) or (1270 - (231 + 1038));
				v104 = 3 + 0;
			end
			if ((v104 == (1162 - (171 + 991))) or ((17201 - 13027) > (11406 - 7158))) then
				v79();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v104 = 2 - 1;
			end
			if ((v104 == (1 + 0)) or ((16075 - 11489) <= (236 - 154))) then
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v66 = v13:GetEnemiesInMeleeRange(8 - 3);
				v104 = 6 - 4;
			end
			if (((5111 - (111 + 1137)) == (4021 - (91 + 67))) and (v104 == (8 - 5))) then
				EnemiesCount5 = ((#v66 > (0 + 0)) and #v66) or (524 - (423 + 100));
				v69 = v13:IsTankingAoE(1 + 7) or v13:IsTanking(v14);
				if (v13:IsDeadOrGhost() or ((780 - 498) <= (22 + 20))) then
					return;
				end
				v104 = 775 - (326 + 445);
			end
			if (((20113 - 15504) >= (1705 - 939)) and ((9 - 5) == v104)) then
				if ((v13:AffectingCombat() and v39) or ((1863 - (530 + 181)) == (3369 - (614 + 267)))) then
					if (((3454 - (19 + 13)) > (5452 - 2102)) and v62.Detox:IsReady() and v33) then
						local v114 = 0 - 0;
						while true do
							if (((2505 - 1628) > (98 + 278)) and ((0 - 0) == v114)) then
								ShouldReturn = v70.FocusUnit(true, nil, nil, nil);
								if (ShouldReturn or ((6466 - 3348) <= (3663 - (1293 + 519)))) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				if (v70.TargetIsValid() or ((336 - 171) >= (9117 - 5625))) then
					if (((7551 - 3602) < (20939 - 16083)) and not v13:AffectingCombat() and v30) then
						local v115 = 0 - 0;
						local v116;
						while true do
							if (((0 + 0) == v115) or ((873 + 3403) < (7007 - 3991))) then
								v116 = v77();
								if (((1084 + 3606) > (1371 + 2754)) and v116) then
									return v116;
								end
								break;
							end
						end
					end
					if (v13:AffectingCombat() or v30 or ((32 + 18) >= (1992 - (709 + 387)))) then
						local v117 = 1858 - (673 + 1185);
						while true do
							if ((v117 == (5 - 3)) or ((5503 - 3789) >= (4866 - 1908))) then
								if ((v32 and v46) or ((1067 + 424) < (482 + 162))) then
									local v120 = 0 - 0;
									while true do
										if (((173 + 531) < (1967 - 980)) and (v120 == (0 - 0))) then
											if (((5598 - (446 + 1434)) > (3189 - (1040 + 243))) and v62.BlackOxBrew:IsCastable() and (v62.PurifyingBrew:ChargesFractional() < (0.5 - 0))) then
												if (v24(v62.BlackOxBrew) or ((2805 - (559 + 1288)) > (5566 - (609 + 1322)))) then
													return "black_ox_brew main 28";
												end
											end
											if (((3955 - (13 + 441)) <= (16785 - 12293)) and v62.BlackOxBrew:IsCastable() and ((v13:Energy() + (v13:EnergyRegen() * v62.KegSmash:CooldownRemains())) < (104 - 64)) and v13:BuffDown(v62.BlackoutComboBuff) and v62.KegSmash:CooldownUp()) then
												if (v24(v62.BlackOxBrew) or ((17142 - 13700) < (95 + 2453))) then
													return "black_ox_brew main 30";
												end
											end
											break;
										end
									end
								end
								if (((10441 - 7566) >= (520 + 944)) and v62.KegSmash:IsCastable() and (v68 >= (1 + 1))) then
									if (v24(v62.KegSmash, not v14:IsSpellInRange(v62.KegSmash)) or ((14235 - 9438) >= (2678 + 2215))) then
										return "keg_smash main 34";
									end
								end
								if (v62.ExplodingKeg:IsCastable() or ((1013 - 462) > (1368 + 700))) then
									if (((1176 + 938) > (679 + 265)) and (v54 == "Player")) then
										if (v24(v64.ExplodingKegPlayer, not v14:IsInMeleeRange(7 + 1)) or ((2214 + 48) >= (3529 - (153 + 280)))) then
											return "exploding_keg 39";
										end
									elseif ((v54 == "Enemy Under Cursor") or ((6511 - 4256) >= (3176 + 361))) then
										if ((v16:Exists() and v13:CanAttack(v16)) or ((1516 + 2321) < (684 + 622))) then
											if (((2678 + 272) == (2138 + 812)) and v24(v64.ExplodingKegCursor)) then
												return "exploding_keg 39";
											end
										end
									elseif ((v54 == "Cursor") or ((7191 - 2468) < (2039 + 1259))) then
										if (((1803 - (89 + 578)) >= (111 + 43)) and v24(v64.ExplodingKegCursor)) then
											return "exploding_keg 39";
										end
									elseif ((v54 == "Confirmation") or ((563 - 292) > (5797 - (572 + 477)))) then
										if (((640 + 4100) >= (1892 + 1260)) and v24(v62.ExplodingKeg)) then
											return "exploding_keg 39";
										end
									end
								end
								v117 = 1 + 2;
							end
							if ((v117 == (92 - (84 + 2))) or ((4248 - 1670) >= (2443 + 947))) then
								if (((883 - (497 + 345)) <= (43 + 1618)) and v62.ChiWave:IsCastable()) then
									if (((102 + 499) < (4893 - (605 + 728))) and v24(v62.ChiWave, not v14:IsInMeleeRange(6 + 2))) then
										return "chi_wave main 62";
									end
								end
								if (((522 - 287) < (32 + 655)) and v62.SpinningCraneKick:IsCastable() and not ShaohaosMightEquipped and (v68 >= (10 - 7)) and (v62.KegSmash:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v62.KegSmash:CooldownRemains() + v62.SpinningCraneKick:ExecuteTime()))) >= (59 + 6)) and (not v62.Spitfire:IsAvailable() or not CharredPassionsEquipped)) then
									if (((12603 - 8054) > (871 + 282)) and v24(v62.SpinningCraneKick, not v14:IsInMeleeRange(497 - (457 + 32)))) then
										return "spinning_crane_kick main 64";
									end
								end
								if ((v62.RushingJadeWind:IsCastable() and (v13:BuffDown(v62.RushingJadeWind))) or ((1984 + 2690) < (6074 - (832 + 570)))) then
									if (((3456 + 212) < (1190 + 3371)) and v24(v62.RushingJadeWind, not v14:IsInMeleeRange(28 - 20))) then
										return "rushing_jade_wind main 54";
									end
								end
								v117 = 4 + 3;
							end
							if ((v117 == (796 - (588 + 208))) or ((1226 - 771) == (5405 - (884 + 916)))) then
								if ((not v13:IsCasting() and not v13:IsChanneling()) or ((5575 - 2912) == (1921 + 1391))) then
									local v121 = 653 - (232 + 421);
									local v122;
									while true do
										if (((6166 - (1569 + 320)) <= (1098 + 3377)) and (v121 == (0 + 0))) then
											v122 = v70.Interrupt(v62.SpearHandStrike, 26 - 18, true);
											if (v122 or ((1475 - (316 + 289)) == (3112 - 1923))) then
												return v122;
											end
											v121 = 1 + 0;
										end
										if (((3006 - (666 + 787)) <= (3558 - (360 + 65))) and (v121 == (2 + 0))) then
											v122 = v70.Interrupt(v62.SpearHandStrike, 294 - (79 + 175), true, v16, v64.SpearHandStrikeMouseover);
											if (v122 or ((3527 - 1290) >= (2740 + 771))) then
												return v122;
											end
											break;
										end
										if ((v121 == (2 - 1)) or ((2549 - 1225) > (3919 - (503 + 396)))) then
											v122 = v70.InterruptWithStun(v62.LegSweep, 189 - (92 + 89));
											if (v122 or ((5803 - 2811) == (965 + 916))) then
												return v122;
											end
											v121 = 2 + 0;
										end
									end
								end
								if (((12163 - 9057) > (209 + 1317)) and v69) then
									local v123 = 0 - 0;
									local v124;
									while true do
										if (((2638 + 385) < (1849 + 2021)) and (v123 == (0 - 0))) then
											v124 = v78();
											if (((18 + 125) > (112 - 38)) and v124) then
												return v124;
											end
											break;
										end
									end
								end
								if (((1262 - (485 + 759)) < (4886 - 2774)) and v41) then
									local v125 = 1189 - (442 + 747);
									while true do
										if (((2232 - (832 + 303)) <= (2574 - (88 + 858))) and (v125 == (0 + 0))) then
											ShouldReturn = v70.HandleAfflicted(v62.Detox, v64.DetoxMouseover, 34 + 6);
											if (((191 + 4439) == (5419 - (766 + 23))) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								v117 = 4 - 3;
							end
							if (((4841 - 1301) > (7068 - 4385)) and (v117 == (13 - 9))) then
								if (((5867 - (1036 + 37)) >= (2322 + 953)) and v62.TouchofDeath:IsCastable() and v32) then
									if (((2889 - 1405) == (1168 + 316)) and v24(v62.TouchofDeath, not v14:IsInMeleeRange(1485 - (641 + 839)))) then
										return "touch_of_death main 52";
									end
								end
								if (((2345 - (910 + 3)) < (9062 - 5507)) and v62.BreathOfFire:IsCastable() and CharredPassionsEquipped and v13:BuffDown(v62.CharredPassions)) then
									if (v24(v62.BreathOfFire, not v14:IsInRange(1696 - (1466 + 218))) or ((490 + 575) > (4726 - (556 + 592)))) then
										return "breath_of_fire main 42";
									end
								end
								if ((v62.BreathOfFire:IsCastable() and v13:BuffDown(v62.BlackoutComboBuff) and (v13:BloodlustDown() or (v13:BloodlustUp() and v14:BuffRefreshable(v62.BreathOfFireDotDebuff)))) or ((1706 + 3089) < (2215 - (329 + 479)))) then
									if (((2707 - (174 + 680)) < (16538 - 11725)) and v24(v62.BreathOfFire, not v14:IsInMeleeRange(16 - 8))) then
										return "breath_of_fire main 58";
									end
								end
								v117 = 4 + 1;
							end
							if (((742 - (396 + 343)) == v117) or ((250 + 2571) < (3908 - (29 + 1448)))) then
								if ((v60 == "Combat") or (v60 == "Both") or ((4263 - (135 + 1254)) < (8216 - 6035))) then
									if ((v62.Clash:IsReady() and not v14:IsInRange(37 - 29) and v14:IsInRange(20 + 10)) or ((4216 - (389 + 1138)) <= (917 - (102 + 472)))) then
										if (v24(v62.Clash) or ((1764 + 105) == (1115 + 894))) then
											return "clash combat 8";
										end
									end
								end
								if ((v62.ChiBurst:IsCastable() and (v62.FaelineStomp:CooldownRemains() > (2 + 0)) and (v68 >= (1547 - (320 + 1225)))) or ((6312 - 2766) < (1421 + 901))) then
									if (v24(v62.ChiBurst, not v14:IsInMeleeRange(1472 - (157 + 1307))) or ((3941 - (821 + 1038)) == (11908 - 7135))) then
										return "chi_burst main 48";
									end
								end
								if (((355 + 2889) > (1873 - 818)) and v62.ArcaneTorrent:IsCastable() and v32 and (v13:Energy() < (12 + 19))) then
									if (v24(v62.ArcaneTorrent, not v14:IsInMeleeRange(19 - 11)) or ((4339 - (834 + 192)) <= (114 + 1664))) then
										return "arcane_torrent main 68";
									end
								end
								v117 = 2 + 2;
							end
							if (((1 + 4) == v117) or ((2201 - 780) >= (2408 - (300 + 4)))) then
								if (((484 + 1328) <= (8504 - 5255)) and v62.RushingJadeWind:IsCastable()) then
									if (((1985 - (112 + 250)) <= (781 + 1176)) and v24(v62.RushingJadeWind, not v14:IsInMeleeRange(19 - 11))) then
										return "rushing_jade_wind main 72";
									end
								end
								if (((2528 + 1884) == (2282 + 2130)) and v62.SpinningCraneKick:IsReady() and (v13:BuffUp(v62.CharredPassions))) then
									if (((1309 + 441) >= (418 + 424)) and v24(v62.SpinningCraneKick, not v14:IsInMeleeRange(6 + 2))) then
										return "spinning_crane_kick main 56";
									end
								end
								if (((5786 - (1001 + 413)) > (4125 - 2275)) and v62.ChiBurst:IsCastable()) then
									if (((1114 - (244 + 638)) < (1514 - (627 + 66))) and v24(v62.ChiBurst, not v14:IsInMeleeRange(23 - 15))) then
										return "chi_burst main 60";
									end
								end
								v117 = 608 - (512 + 90);
							end
							if (((2424 - (1665 + 241)) < (1619 - (373 + 344))) and (v117 == (1 + 0))) then
								if (((793 + 2201) > (2263 - 1405)) and v42) then
									local v126 = 0 - 0;
									while true do
										if ((v126 == (1099 - (35 + 1064))) or ((2733 + 1022) <= (1957 - 1042))) then
											ShouldReturn = v70.HandleIncorporeal(v62.Paralysis, v64.ParalysisMouseover, 1 + 19);
											if (((5182 - (298 + 938)) > (5002 - (233 + 1026))) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								if (v15 or ((3001 - (636 + 1030)) >= (1691 + 1615))) then
									if (((4732 + 112) > (670 + 1583)) and v39 and v33 and v62.Detox:IsReady() and v70.DispellableFriendlyUnit()) then
										if (((31 + 421) == (673 - (55 + 166))) and v24(v64.DetoxFocus)) then
											return "detox main";
										end
									end
								end
								if (v32 or ((884 + 3673) < (210 + 1877))) then
									local v127 = 0 - 0;
									while true do
										if (((4171 - (36 + 261)) == (6774 - 2900)) and (v127 == (1372 - (34 + 1334)))) then
											if ((v62.BonedustBrew:IsCastable() and (v14:DebuffDown(v62.BonedustBrew))) or ((746 + 1192) > (3835 + 1100))) then
												if ((v57 == "Player") or ((5538 - (1035 + 248)) < (3444 - (20 + 1)))) then
													if (((758 + 696) <= (2810 - (134 + 185))) and v24(v64.BonedustBrewPlayer, not v14:IsInMeleeRange(1141 - (549 + 584)))) then
														return "bonedust_brew 26";
													end
												elseif ((v57 == "Enemy Under Cursor") or ((4842 - (314 + 371)) <= (9622 - 6819))) then
													if (((5821 - (478 + 490)) >= (1580 + 1402)) and v16:Exists() and v13:CanAttack(v16) and (v16:DebuffDown(v62.BonedustBrew))) then
														if (((5306 - (786 + 386)) > (10873 - 7516)) and v24(v64.BonedustBrewCursor)) then
															return "bonedust_brew 26";
														end
													end
												elseif ((v57 == "Cursor") or ((4796 - (1055 + 324)) < (3874 - (1093 + 247)))) then
													if (v24(v64.BonedustBrewCursor) or ((2419 + 303) <= (18 + 146))) then
														return "bonedust_brew 26";
													end
												elseif ((v57 == "Confirmation") or ((9560 - 7152) < (7157 - 5048))) then
													if (v24(v62.BonedustBrew) or ((93 - 60) == (3656 - 2201))) then
														return "bonedust_brew 26";
													end
												end
											end
											break;
										end
										if ((v127 == (1 + 0)) or ((1706 - 1263) >= (13838 - 9823))) then
											if (((2551 + 831) > (424 - 258)) and v62.BloodFury:IsCastable()) then
												if (v24(v62.BloodFury) or ((968 - (364 + 324)) == (8385 - 5326))) then
													return "blood_fury main 6";
												end
											end
											if (((4513 - 2632) > (429 + 864)) and v62.Berserking:IsCastable()) then
												if (((9862 - 7505) == (3774 - 1417)) and v24(v62.Berserking)) then
													return "berserking main 8";
												end
											end
											if (((373 - 250) == (1391 - (1249 + 19))) and v62.LightsJudgment:IsCastable()) then
												if (v24(v62.LightsJudgment, not v14:IsInRange(37 + 3)) or ((4110 - 3054) >= (4478 - (686 + 400)))) then
													return "lights_judgment main 10";
												end
											end
											v127 = 2 + 0;
										end
										if ((v127 == (229 - (73 + 156))) or ((6 + 1075) < (1886 - (721 + 90)))) then
											if (v62.SummonWhiteTigerStatue:IsCastable() or ((12 + 1037) >= (14389 - 9957))) then
												if ((v56 == "Player") or ((5238 - (224 + 246)) <= (1370 - 524))) then
													if (v24(v64.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(14 - 6)) or ((610 + 2748) <= (34 + 1386))) then
														return "summon_white_tiger_statue 4";
													end
												elseif ((v56 == "Cursor") or ((2747 + 992) <= (5974 - 2969))) then
													if (v24(v64.SummonWhiteTigerStatueCursor) or ((5520 - 3861) >= (2647 - (203 + 310)))) then
														return "summon_white_tiger_statue 4";
													end
												end
											end
											if ((v32 and v61 and v63.Djaruun:IsEquippedAndReady()) or ((5253 - (1238 + 755)) < (165 + 2190))) then
												if (v24(v64.Djaruun, not v14:IsInMeleeRange(1542 - (709 + 825))) or ((1232 - 563) == (6150 - 1927))) then
													return "djaruun_pillar_of_the_elder_flame main 4";
												end
											end
											if (v32 or ((2556 - (196 + 668)) < (2321 - 1733))) then
												local v128 = v75();
												if (v128 or ((9936 - 5139) < (4484 - (171 + 662)))) then
													return v128;
												end
											end
											v127 = 94 - (4 + 89);
										end
										if ((v127 == (10 - 7)) or ((1521 + 2656) > (21302 - 16452))) then
											if ((v62.InvokeNiuzaoTheBlackOx:IsCastable() and v10.BossFilteredFightRemains(">", 10 + 15) and v55) or ((1886 - (35 + 1451)) > (2564 - (28 + 1425)))) then
												if (((5044 - (941 + 1052)) > (964 + 41)) and v24(v62.InvokeNiuzaoTheBlackOx, not v14:IsInRange(1554 - (822 + 692)))) then
													return "invoke_niuzao_the_black_ox main 18";
												end
											end
											if (((5271 - 1578) <= (2065 + 2317)) and v62.TouchofDeath:IsCastable() and (v14:HealthPercentage() <= (312 - (45 + 252)))) then
												if (v24(v62.TouchofDeath, not v14:IsInMeleeRange(5 + 0)) or ((1130 + 2152) > (9978 - 5878))) then
													return "touch_of_death main 20";
												end
											end
											if (v62.WeaponsOfOrder:IsCastable() or ((4013 - (114 + 319)) < (4083 - 1239))) then
												if (((113 - 24) < (2863 + 1627)) and v24(v62.WeaponsOfOrder)) then
													return "weapons_of_order main 22";
												end
											end
											v127 = 5 - 1;
										end
										if ((v127 == (3 - 1)) or ((6946 - (556 + 1407)) < (3014 - (741 + 465)))) then
											if (((4294 - (170 + 295)) > (1986 + 1783)) and v62.Fireblood:IsCastable()) then
												if (((1365 + 120) <= (7149 - 4245)) and v24(v62.Fireblood)) then
													return "fireblood main 12";
												end
											end
											if (((3539 + 730) == (2738 + 1531)) and v62.AncestralCall:IsCastable()) then
												if (((220 + 167) <= (4012 - (957 + 273))) and v24(v62.AncestralCall)) then
													return "ancestral_call main 14";
												end
											end
											if (v62.BagofTricks:IsCastable() or ((508 + 1391) <= (368 + 549))) then
												if (v24(v62.BagofTricks, not v14:IsInRange(152 - 112)) or ((11362 - 7050) <= (2675 - 1799))) then
													return "bag_of_tricks main 16";
												end
											end
											v127 = 14 - 11;
										end
									end
								end
								v117 = 1782 - (389 + 1391);
							end
							if (((1401 + 831) <= (271 + 2325)) and (v117 == (18 - 10))) then
								if (((3046 - (783 + 168)) < (12370 - 8684)) and v62.KegSmash:IsReady()) then
									if (v24(v62.KegSmash, not v14:IsSpellInRange(v62.KegSmash)) or ((1569 + 26) >= (4785 - (309 + 2)))) then
										return "keg_smash main 46";
									end
								end
								if ((v62.TigerPalm:IsCastable() and not v62.BlackoutCombo:IsAvailable() and (v62.KegSmash:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v62.KegSmash:CooldownRemains() + v13:GCD()))) >= (199 - 134))) or ((5831 - (1090 + 122)) < (935 + 1947))) then
									if (v24(v62.TigerPalm, not v14:IsSpellInRange(v62.TigerPalm)) or ((987 - 693) >= (3307 + 1524))) then
										return "tiger_palm main 66";
									end
								end
								break;
							end
							if (((3147 - (628 + 490)) <= (554 + 2530)) and (v117 == (16 - 9))) then
								if ((v62.TigerPalm:IsReady() and v62.RushingJadeWind:IsAvailable() and v13:BuffUp(v62.BlackoutComboBuff) and v13:BuffUp(v62.RushingJadeWind)) or ((9309 - 7272) == (3194 - (431 + 343)))) then
									if (((9003 - 4545) > (11293 - 7389)) and v24(v62.TigerPalm, not v14:IsInMeleeRange(4 + 1))) then
										return "tiger_palm main 40";
									end
								end
								if (((56 + 380) >= (1818 - (556 + 1139))) and v62.BlackoutKick:IsCastable()) then
									if (((515 - (6 + 9)) < (333 + 1483)) and v24(v62.BlackoutKick, not v14:IsInMeleeRange(3 + 2))) then
										return "blackout_kick main 44";
									end
								end
								if (((3743 - (28 + 141)) == (1385 + 2189)) and v62.RisingSunKick:IsCastable()) then
									if (((272 - 51) < (277 + 113)) and v24(v62.RisingSunKick, not v14:IsInMeleeRange(1322 - (486 + 831)))) then
										return "rising_sun_kick main 46";
									end
								end
								v117 = 20 - 12;
							end
						end
					end
					if (v24(v62.PoolEnergy) or ((7790 - 5577) <= (269 + 1152))) then
						return "Pool Energy";
					end
				end
				break;
			end
		end
	end
	local function v81()
		v72();
		v21.Print("Brewmaster Monk rotation by Epic BoomK");
		EpicSettings.SetupVersion("Brewmaster Monk X v 10.2.00 By BoomK");
	end
	v21.SetAPL(847 - 579, v80, v81);
end;
return v0["Epix_Monk_Brewmaster.lua"]();

