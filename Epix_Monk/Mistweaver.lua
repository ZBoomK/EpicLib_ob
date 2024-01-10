local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4129 - 3081) >= (194 - 142)) and not v5) then
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
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v46 = v17.Monk.Mistweaver;
	local v47 = v19.Monk.Mistweaver;
	local v48 = v24.Monk.Mistweaver;
	local v49 = {};
	local v50;
	local v51;
	local v52;
	local v53 = {{v46.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v46.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v54 = v21.Commons.Everyone;
	local v55 = v21.Commons.Monk;
	local function v56()
		if (((3538 - (361 + 219)) < (4823 - (53 + 267))) and v46.ImprovedPurifySpirit:IsAvailable()) then
			v54.DispellableDebuffs = v20.MergeTable(v54.DispellableMagicDebuffs, v54.DispellableCurseDebuffs);
		else
			v54.DispellableDebuffs = v54.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v56();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v57()
		local v66 = 0 + 0;
		local v67;
		while true do
			if ((v66 == (413 - (15 + 398))) or ((3717 - (18 + 964)) == (4927 - 3618))) then
				v67 = v12:GetUseableTrinkets(v49);
				if (v67 or ((2392 + 1738) <= (1862 + 1093))) then
					if (v22(v67, nil, Settings.Commons.DisplayStyle.Trinkets) or ((2814 - (20 + 830)) <= (1046 + 294))) then
						return "Generic use_items for " .. v67:Name();
					end
				end
				break;
			end
		end
	end
	local function v58()
		local v68 = 126 - (116 + 10);
		while true do
			if (((185 + 2314) == (3237 - (542 + 196))) and (v68 == (0 - 0))) then
				if ((v46.DampenHarm:IsCastable() and v12:BuffDown(v46.FortifyingBrew) and (v12:HealthPercentage() <= Settings.Mistweaver.DampenHarmHP)) or ((659 + 1596) < (12 + 10))) then
					if (v22(v46.DampenHarm, nil, Settings.Mistweaver.DisplayStyle.DampenHarm) or ((391 + 695) >= (3701 - 2296))) then
						return "dampen_harm defensives 2";
					end
				end
				if ((v46.FortifyingBrew:IsCastable() and v12:BuffDown(v46.DampenHarm) and (v12:HealthPercentage() <= Settings.Mistweaver.FortifyingBrewHP)) or ((6073 - 3704) == (1977 - (1126 + 425)))) then
					if (v22(v46.FortifyingBrew, Settings.Mistweaver.DisplayStyle.FortifyingBrew) or ((3481 - (118 + 287)) > (12474 - 9291))) then
						return "fortifying_brew defensives 4";
					end
				end
				break;
			end
		end
	end
	local function v59()
		local v69 = 1121 - (118 + 1003);
		while true do
			if (((3517 - 2315) > (1435 - (142 + 235))) and (v69 == (0 - 0))) then
				if (((808 + 2903) > (4332 - (553 + 424))) and v46.ChiBurst:IsCastable()) then
					if (v22(v46.ChiBurst, nil, nil, not v14:IsInRange(75 - 35)) or ((799 + 107) >= (2212 + 17))) then
						return "chi_burst precombat 4";
					end
				end
				if (((750 + 538) > (532 + 719)) and v46.ChiWave:IsCastable()) then
					if (v22(v46.ChiWave, nil, nil, not v14:IsInRange(23 + 17)) or ((9783 - 5270) < (9339 - 5987))) then
						return "chi_wave precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v60()
		local v70 = 0 - 0;
		while true do
			if ((v70 == (1 + 0)) or ((9979 - 7914) >= (3949 - (239 + 514)))) then
				if (v46.ChiBurst:IsCastable() or ((1537 + 2839) <= (2810 - (797 + 532)))) then
					if (v22(v46.ChiBurst, nil, nil, not v14:IsInRange(30 + 10)) or ((1145 + 2247) >= (11147 - 6406))) then
						return "chi_burst aoe 6";
					end
				end
				break;
			end
			if (((4527 - (373 + 829)) >= (2885 - (476 + 255))) and (v70 == (1130 - (369 + 761)))) then
				if (v46.SpinningCraneKick:IsCastable() or ((750 + 545) >= (5872 - 2639))) then
					if (((8294 - 3917) > (1880 - (64 + 174))) and v22(v46.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "spinning_crane_kick aoe 2";
					end
				end
				if (((6993 - 2270) > (1692 - (144 + 192))) and v46.ChiWave:IsCastable()) then
					if (v22(v46.ChiWave, nil, nil, not v14:IsInRange(256 - (42 + 174))) or ((3108 + 1028) <= (2844 + 589))) then
						return "chi_wave aoe 4";
					end
				end
				v70 = 1 + 0;
			end
		end
	end
	local function v61()
		if (((5749 - (363 + 1141)) <= (6211 - (1183 + 397))) and v46.ThunderFocusTea:IsCastable()) then
			if (((13017 - 8741) >= (2870 + 1044)) and v22(v46.ThunderFocusTea, Settings.Mistweaver.OffGCDasOffGCD.ThunderFocusTea)) then
				return "thunder_focus_tea st 2";
			end
		end
		if (((148 + 50) <= (6340 - (1913 + 62))) and v46.RisingSunKick:IsReady()) then
			if (((3012 + 1770) > (12378 - 7702)) and v22(v46.RisingSunKick, nil, nil, not v14:IsInMeleeRange(1938 - (565 + 1368)))) then
				return "rising_sun_kick st 4";
			end
		end
		if (((18292 - 13428) > (3858 - (1477 + 184))) and v46.BlackoutKick:IsCastable() and (v12:BuffStack(v46.TeachingsOfTheMonasteryBuff) == (1 - 0)) and (v46.RisingSunKick:CooldownRemains() < (12 + 0))) then
			if (v22(v46.BlackoutKick, nil, nil, not v14:IsInMeleeRange(861 - (564 + 292))) or ((6384 - 2684) == (7556 - 5049))) then
				return "blackout_kick st 6";
			end
		end
		if (((4778 - (244 + 60)) >= (211 + 63)) and v46.ChiWave:IsCastable()) then
			if (v22(v46.ChiWave, nil, nil, not v14:IsInRange(516 - (41 + 435))) or ((2895 - (938 + 63)) <= (1082 + 324))) then
				return "chi_wave st 8";
			end
		end
		if (((2697 - (936 + 189)) >= (504 + 1027)) and v46.ChiBurst:IsCastable()) then
			if (v22(v46.ChiBurst, nil, nil, not v14:IsInRange(1653 - (1565 + 48))) or ((2896 + 1791) < (5680 - (782 + 356)))) then
				return "chi_burst st 10";
			end
		end
		if (((3558 - (176 + 91)) > (4342 - 2675)) and v46.TigerPalm:IsCastable() and ((v12:BuffStack(v46.TeachingsOfTheMonasteryBuff) < (4 - 1)) or (v12:BuffRemains(v46.TeachingsOfTheMonasteryBuff) < (1094 - (975 + 117))))) then
			if (v22(v46.TigerPalm, nil, nil, not v14:IsInMeleeRange(1880 - (157 + 1718))) or ((709 + 164) == (7220 - 5186))) then
				return "tiger_palm st 12";
			end
		end
	end
	local function v62()
	end
	local function v63()
	end
	local function v64()
		v62();
		v63();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['cds'];
		v30 = EpicSettings.Toggles['dispel'];
		v31 = EpicSettings.Toggles['healing'];
		v32 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((9627 - 6811) < (1029 - (697 + 321)))) then
			return;
		end
		v50 = v12:GetEnemiesInMeleeRange(13 - 8);
		v51 = v12:GetEnemiesInMeleeRange(16 - 8);
		if (((8527 - 4828) < (1832 + 2874)) and v60) then
			v52 = #v51;
		else
			v52 = 1 - 0;
		end
		if (((7093 - 4447) >= (2103 - (322 + 905))) and (v54.TargetIsValid() or v12:AffectingCombat())) then
			local v80 = 611 - (602 + 9);
			while true do
				if (((1803 - (449 + 740)) <= (4056 - (826 + 46))) and (v80 == (948 - (245 + 702)))) then
					FightRemains = BossFightRemains;
					if (((9877 - 6751) == (1005 + 2121)) and (FightRemains == (13009 - (260 + 1638)))) then
						FightRemains = v9.FightRemains(Enemies40y, false);
					end
					break;
				end
				if ((v80 == (440 - (382 + 58))) or ((7015 - 4828) >= (4117 + 837))) then
					Enemies40y = v12:GetEnemiesInRange(82 - 42);
					BossFightRemains = v9.BossFightRemains(nil, true);
					v80 = 2 - 1;
				end
			end
		end
		if (v12:AffectingCombat() or v28 or ((5082 - (902 + 303)) == (7849 - 4274))) then
			local v81 = 0 - 0;
			local v82;
			while true do
				if (((61 + 646) > (2322 - (1121 + 569))) and (v81 == (215 - (22 + 192)))) then
					if (v27 or ((1229 - (483 + 200)) >= (4147 - (1404 + 59)))) then
						return v27;
					end
					if (((4009 - 2544) <= (5780 - 1479)) and v30) then
						if (((2469 - (468 + 297)) > (1987 - (334 + 228))) and v16 and v42) then
							if ((v46.PurifySpirit:IsReady() and v54.DispellableFriendlyUnit(84 - 59)) or ((1591 - 904) == (7678 - 3444))) then
								if (v23(v48.PurifySpiritFocus, not v16:IsSpellInRange(v46.PurifySpirit)) or ((946 + 2384) < (1665 - (141 + 95)))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					break;
				end
				if (((1127 + 20) >= (862 - 527)) and (v81 == (0 - 0))) then
					v82 = v42 and v46.PurifySpirit:IsReady() and v30;
					v27 = v54.FocusUnit(v82, nil, nil, nil);
					v81 = 1 + 0;
				end
			end
		end
		if (((9411 - 5976) > (1475 + 622)) and not v12:AffectingCombat()) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((1964 + 1806) >= (5690 - 1649))) then
				local v86 = v54.DeadFriendlyUnitsCount();
				if ((v86 > (1 + 0)) or ((3954 - (92 + 71)) <= (796 + 815))) then
					if (v23(v46.AncestralVision, nil) or ((7696 - 3118) <= (2773 - (574 + 191)))) then
						return "ancestral_vision";
					end
				elseif (((928 + 197) <= (5200 - 3124)) and v23(v48.AncestralSpiritMouseover, not v14:IsInRange(21 + 19))) then
					return "ancestral_spirit";
				end
			end
		end
		if ((not v12:AffectingCombat() and v28) or ((1592 - (254 + 595)) >= (4525 - (55 + 71)))) then
			local v83 = 0 - 0;
			while true do
				if (((2945 - (573 + 1217)) < (4633 - 2960)) and (v83 == (0 + 0))) then
					v27 = v59();
					if (v27 or ((3744 - 1420) <= (1517 - (714 + 225)))) then
						return v27;
					end
					break;
				end
			end
		end
		if (((11008 - 7241) == (5251 - 1484)) and (v28 or v12:AffectingCombat())) then
			local v84 = 0 + 0;
			while true do
				if (((5920 - 1831) == (4895 - (118 + 688))) and (v84 == (48 - (25 + 23)))) then
					v27 = HandleAffixes();
					if (((864 + 3594) >= (3560 - (927 + 959))) and v27) then
						return v27;
					end
					v84 = 3 - 2;
				end
				if (((1704 - (16 + 716)) <= (2737 - 1319)) and (v84 == (98 - (11 + 86)))) then
					if (v31 or ((12044 - 7106) < (5047 - (175 + 110)))) then
						local v87 = 0 - 0;
						while true do
							if ((v87 == (4 - 3)) or ((4300 - (503 + 1293)) > (11908 - 7644))) then
								v27 = HealingST();
								if (((1557 + 596) == (3214 - (810 + 251))) and v27) then
									return v27;
								end
								break;
							end
							if (((0 + 0) == v87) or ((156 + 351) >= (2336 + 255))) then
								v27 = HealingAOE();
								if (((5014 - (43 + 490)) == (5214 - (711 + 22))) and v27) then
									return v27;
								end
								v87 = 3 - 2;
							end
						end
					end
					if ((FightRemains > FightRemainsCheck) or ((3187 - (240 + 619)) < (168 + 525))) then
						v27 = Cooldowns();
						if (((6884 - 2556) == (287 + 4041)) and v27) then
							return v27;
						end
					end
					break;
				end
			end
		end
		if (((3332 - (1344 + 400)) >= (1737 - (255 + 150))) and (v28 or v12:AffectingCombat()) and v54.TargetIsValid()) then
			local v85 = 0 + 0;
			while true do
				if ((v85 == (0 + 0)) or ((17833 - 13659) > (13720 - 9472))) then
					v27 = v58();
					if (v27 or ((6325 - (404 + 1335)) <= (488 - (183 + 223)))) then
						return v27;
					end
					v85 = 1 - 0;
				end
				if (((2560 + 1303) == (1391 + 2472)) and (v85 == (338 - (10 + 327)))) then
					if ((UseTrinkets and ((v29 and TrinketsWithCD) or not TrinketsWithCD)) or ((197 + 85) <= (380 - (118 + 220)))) then
						local v88 = 0 + 0;
						while true do
							if (((5058 - (108 + 341)) >= (345 + 421)) and (v88 == (4 - 3))) then
								v27 = v54.HandleBottomTrinket(v49, v29, 1533 - (711 + 782), nil);
								if (v27 or ((2207 - 1055) == (2957 - (270 + 199)))) then
									return v27;
								end
								break;
							end
							if (((1110 + 2312) > (5169 - (580 + 1239))) and ((0 - 0) == v88)) then
								v27 = v54.HandleTopTrinket(v49, v29, 39 + 1, nil);
								if (((32 + 845) > (164 + 212)) and v27) then
									return v27;
								end
								v88 = 2 - 1;
							end
						end
					end
					if (v32 or ((1938 + 1180) <= (3018 - (645 + 522)))) then
						local v89 = 1790 - (1010 + 780);
						while true do
							if ((v89 == (0 + 0)) or ((786 - 621) >= (10233 - 6741))) then
								if (((5785 - (1045 + 791)) < (12291 - 7435)) and v29 and (FightRemains < (27 - 9))) then
									local v90 = 505 - (351 + 154);
									while true do
										if ((v90 == (1575 - (1281 + 293))) or ((4542 - (28 + 238)) < (6738 - 3722))) then
											if (((6249 - (1381 + 178)) > (3869 + 256)) and v46.LightsJudgment:IsCastable()) then
												if (v22(v46.LightsJudgment, not v14:IsInRange(33 + 7)) or ((22 + 28) >= (3088 - 2192))) then
													return "lights_judgment main 8";
												end
											end
											if (v46.Fireblood:IsCastable() or ((888 + 826) >= (3428 - (381 + 89)))) then
												if (v22(v46.Fireblood, nil) or ((1323 + 168) < (436 + 208))) then
													return "fireblood main 10";
												end
											end
											v90 = 2 - 0;
										end
										if (((1860 - (1074 + 82)) < (2162 - 1175)) and (v90 == (1786 - (214 + 1570)))) then
											if (((5173 - (990 + 465)) > (786 + 1120)) and v46.AncestralCall:IsCastable()) then
												if (v22(v46.AncestralCall, nil) or ((417 + 541) > (3535 + 100))) then
													return "ancestral_call main 12";
												end
											end
											if (((13778 - 10277) <= (6218 - (1668 + 58))) and v46.BagOfTricks:IsCastable()) then
												if (v22(v46.BagOfTricks, not v14:IsInRange(666 - (512 + 114))) or ((8973 - 5531) < (5267 - 2719))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
										if (((10004 - 7129) >= (682 + 782)) and (v90 == (0 + 0))) then
											if (v46.BloodFury:IsCastable() or ((4171 + 626) >= (16503 - 11610))) then
												if (v22(v46.BloodFury, nil) or ((2545 - (109 + 1885)) > (3537 - (1269 + 200)))) then
													return "blood_fury main 4";
												end
											end
											if (((4051 - 1937) > (1759 - (98 + 717))) and v46.Berserking:IsCastable()) then
												if (v22(v46.Berserking, nil) or ((3088 - (802 + 24)) >= (5338 - 2242))) then
													return "berserking main 6";
												end
											end
											v90 = 1 - 0;
										end
									end
								end
								if ((v46.WeaponsOfOrder:IsCastable() and v29) or ((334 + 1921) >= (2718 + 819))) then
									if (v22(v46.WeaponsOfOrder, nil) or ((631 + 3206) < (282 + 1024))) then
										return "weapons_of_order main 18";
									end
								end
								v89 = 2 - 1;
							end
							if (((9837 - 6887) == (1056 + 1894)) and (v89 == (1 + 1))) then
								if ((v52 < (3 + 0)) or ((3435 + 1288) < (1540 + 1758))) then
									local v91 = 1433 - (797 + 636);
									while true do
										if (((5515 - 4379) >= (1773 - (1427 + 192))) and (v91 == (0 + 0))) then
											v27 = v61();
											if (v27 or ((629 - 358) > (4268 + 480))) then
												return v27;
											end
											break;
										end
									end
								end
								if (((2149 + 2591) >= (3478 - (192 + 134))) and v22(v46.PoolEnergy)) then
									return "Pool Energy";
								end
								break;
							end
							if ((v89 == (1277 - (316 + 960))) or ((1435 + 1143) >= (2617 + 773))) then
								if (((38 + 3) <= (6349 - 4688)) and v46.FaelineStomp:IsCastable()) then
									if (((1152 - (83 + 468)) < (5366 - (1202 + 604))) and v22(v46.FaelineStomp, nil)) then
										return "faeline_stomp main 20";
									end
								end
								if (((1097 - 862) < (1143 - 456)) and (v52 >= (8 - 5))) then
									local v92 = 325 - (45 + 280);
									while true do
										if (((4391 + 158) > (1008 + 145)) and ((0 + 0) == v92)) then
											v27 = v60();
											if (v27 or ((2587 + 2087) < (822 + 3850))) then
												return v27;
											end
											break;
										end
									end
								end
								v89 = 3 - 1;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v65()
		local v76 = 1911 - (340 + 1571);
		while true do
			if (((1447 + 2221) < (6333 - (1733 + 39))) and (v76 == (0 - 0))) then
				v56();
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(1304 - (125 + 909), v64, v65);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

